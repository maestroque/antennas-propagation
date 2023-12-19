using Revise
using Plots
using PlotlyJS

includet("antennaArray.jl")

function fieldIntensity(array::AntennaArray2D, θ, ϕ)
    η_0 = 120π
    k = 2π / array.λ
    r = 1

    E_0 = im * (η_0 * array.I * k * array.l) / (4π * r) * exp(-im * k * r)
    return abs(E_0) * arrayFactor(array, θ, ϕ)
end

function directivity(array::AntennaArray2D, θ0::Float64)
    
    arrayX = createAntennaArray1D(3e8 / array.λ, array.I, array.l, 
                                  array.d_x, array.N_x, array.δx)
    arrayY = createAntennaArray1D(3e8 / array.λ, array.I, array.l, 
                                  array.d_y, array.N_y, array.δy)
    D_x = sincDirectivity(arrayX)
    D_y = sincDirectivity(arrayY)

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