using Revise
using Plots
using PlotlyJS

includet("antennaArray.jl")

# HPBW values taken from the HPBW-Antenna Length-θ_0 chart
HPBW = Dict{Tuple{Any, Any}, Any}()
HPBW[(0.5, 0)] = 37
HPBW[(0.5, π/6)] = 13
HPBW[(0.5, π/3)] = 7
HPBW[(0.5, π/2)] = 6
HPBW[(0.25, 0)] = 50
HPBW[(0.25, π/6)] = 22
HPBW[(0.25, π/3)] = 14
HPBW[(0.25, π/2)] = 10

function fieldIntensity(array::UniformAntennaArray2D, θ, ϕ)
    η_0 = 120π
    k = 2π / array.λ
    r = 1

    E_0 = im * (η_0 * array.I * k * array.l) / (4π * r) * exp(-im * k * r)
    return abs(E_0) * arrayFactor(array, θ, ϕ)
end

function fieldIntensity(array::AntennaArray1D, θ, ϕ)
    η_0 = 120π
    k = 2π / array.λ
    r = 1

    E_0 = im * (η_0 * k * array.l) / (4π * r) * exp(-im * k * r)
    return abs(E_0) * abs(arrayFactor(array, θ, ϕ))
end

function directivityD(array::UniformAntennaArray2D, θ0::Float64, ϕ0::Float64)
    
    arrayX = createUniformAntennaArray1D(3e8 / array.λ, array.I, array.l / array.λ, 
                                  array.d_x / array.λ, array.N_x, array.δx)
    arrayY = createUniformAntennaArray1D(3e8 / array.λ, array.I, array.l / array.λ, 
                                  array.d_y / array.λ, array.N_y, array.δy)
    D_x = directivityD(arrayX, ϕ0)
    D_y = directivityD(arrayY, θ0)
    println(D_x)
    println(D_y)

    return π * cos(ϕ0) * D_x * D_y
end

function directivityD(array::UniformAntennaArray1D, θ0::Float64)
    D_0 = 2 * array.N * array.d / array.λ
    
    return D_0 * HPBW[(array.d / array.λ, 0)] / HPBW[(array.d / array.λ, θ0)]
end

function directivityHPBW(array::UniformAntennaArray2D, θ0::Float64, ϕ0::Float64)
    arrayX = createUniformAntennaArray1D(3e8 / array.λ, array.I, array.l / array.λ, 
                                  array.d_x / array.λ, array.N_x, array.δx)
    arrayY = createUniformAntennaArray1D(3e8 / array.λ, array.I, array.l / array.λ, 
                                  array.d_y / array.λ, array.N_y, array.δy)
    
    Θ_x = deg2rad(HPBW[(arrayX.d / arrayX.λ, ϕ0)])
    Θ_y = deg2rad(HPBW[(arrayY.d / arrayY.λ, θ0)])

    Θ_h = deg2rad(1 / (cos(θ0) * sqrt(cos(ϕ0)^2 / Θ_x^2 + sin(ϕ0)^2 / Θ_y^2)))
    Ψ_h = deg2rad(1 / sqrt(sin(ϕ0)^2 / Θ_x^2 + cos(ϕ0)^2 / Θ_y^2))
    println(Θ_h)
    println(Ψ_h)

    return 32400 / (Θ_h * Ψ_h)
end

function sincDirectivity(array::UniformAntennaArray1D)
    k = 2π / array.λ
    b1 = array.N * (-k * array.d + array.δ) / 2
    b2 = array.N * (k * array.d + array.δ) / 2
    return array.N * k * array.d / 
           ((sin(b1))^2 / b1 - (sin(b2))^2 / b2
           + sinint(b2) - sinint(b1))
end

"""
Directivity calculation using the definition and Riemann Sums
"""
function riemannDirectivity(array::AntennaArray, precision::Float64)
    Δϕ = precision
    Δθ = precision
    ϕ = 0:precision:2π
    θ = 0:precision:2π

    η_0 = 120π
    k = 2π / array.λ
    r = 1

    E_0 = im * (η_0 * array.I * k * array.l) / (4π * r) * exp(-im * k * r)

    integral = 0
    for i in ϕ
        for j in θ
            integral += fieldIntensity(array, j, i)^2 * sin(j) * Δϕ * Δθ
        end
    end

    A = [arrayFactor(array, i, j) for i in ϕ, j in θ]

    return 4π * abs(E_0)^2 * maximum(abs.(A))^2 / integral
end

