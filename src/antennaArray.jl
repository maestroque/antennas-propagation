using Revise
using Plots
using PlotlyJS
using SpecialFunctions

abstract type AntennaArray end

mutable struct AntennaArray2D <: AntennaArray
    λ::Float64
    I::Float64
    l::Float64
    d_x::Float64
    d_y::Float64
    N_x::Int
    N_y::Int
    δx::Float64
    δy::Float64
end

mutable struct AntennaArray1D <: AntennaArray
    λ::Float64
    I::Float64
    l::Float64
    d::Float64
    N::Int
    δ::Float64
end

"""
## Arguements
- `f`: Frequency
- `I`: Current 
- `lλ`: Length of the dipole (fraction of λ)
- `dλ_x`: Distance between dipoles in X axis (fraction of λ)
- `dλ_y`: Distance between dipoles in Y axis (fraction of λ)
- `N_x`: Number of dipoles per row (X axis)
- `N_y`: Number of dipoles per column (Y axis)
- `δx` : Phase difference between dipoles in X axis
- `δy` : Phase difference between dipoles in Y axis
"""
function createAntennaArray2D(f, I, lλ, dλ_x, dλ_y, N_x, N_y, δx, δy)
    λ = 3e8 / f
    d_x = dλ_x * λ
    d_y = dλ_y * λ
    l = lλ * λ
    return AntennaArray2D(λ, I, l, d_x, d_y, N_x, N_y, δx, δy)
end
function createAntennaArray1D(f, I, lλ, dλ, N, δ)
    λ = 3e8 / f
    d = dλ * λ
    l = lλ * λ
    return AntennaArray1D(λ, I, l, d, N, δ)
end

function steerAntennaArray(array::AntennaArray2D, θ0::Float64, ϕ0::Float64)
    k = 2π / array.λ
    δx = - k * array.d_x * sin(θ0) * cos(ϕ0)
    δy = - k * array.d_y * sin(θ0) * sin(ϕ0)

    return AntennaArray2D(array.λ, array.I, array.l, array.d_x,
                        array.d_y, array.N_x, array.N_y, δx, δy)
end

function arrayFactor(array::AntennaArray2D, θ, ϕ)
    k = 2π / array.λ
    ψ_x = k * array.d_x * cos(ϕ) * sin(θ) + array.δx
    ψ_y = k * array.d_y * sin(ϕ) * sin(θ) + array.δy

    factor = abs((sin(array.N_x * ψ_x / 2))/(sin(ψ_x / 2))) * abs((sin(array.N_y * ψ_y / 2))/(sin(ψ_y / 2)))
    return factor
end

function fieldIntensity(array::AntennaArray2D, θ, ϕ)
    η_0 = 120π
    k = 2π / array.λ
    r = 1

    E_0 = im * (η_0 * array.I * k * array.l) / (4π * r) * exp(-im * k * r)
    return abs(E_0) * arrayFactor(array, θ, ϕ)
end

function directivity(array::AntennaArray2D, θ0::Float64)
    
    arrayX = createAntennaArray1D(array.f, array.I, array.l, 
                                  array.d_x, array.N_x, array.δx)
    arrayY = createAntennaArray1D(array.f, array.I, array.l, 
                                  array.d_y, array.N_y, array.δy)
    D_x = directivity(arrayX)
    D_y = directivity(arrayY)

    return π * θ0 * D_x * D_y
end

function chartDirectivity(array::AntennaArray1D, θ0::Float64)
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
    
    D_0 = 2 * array.N * array.d / array.λ
    
    return D_0 * HPBW[(array.d / array.λ, 0)] / HPBW[(array.d / array.λ, θ0)]

end

function sincDirectivity(array::AntennaArray1D)
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
function riemannDirectivity(array::AntennaArray)
    
end