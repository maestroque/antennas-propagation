using Revise
using Plots
using PlotlyJS

mutable struct AntennaArray
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
function AntennaArray(f, I, lλ, dλ_x, dλ_y, N_x, N_y, δx, δy)
    λ = 3e8 / f
    d_x = dλ_x * λ
    d_y = dλ_y * λ
    l = lλ * λ
    AntennaArray(λ, I, l, d_x, d_y, N_x, N_y, δx, δy)
end

function arrayFactor(array::AntennaArray, θ, ϕ)
    k = 2π / array.λ
    ψ_x = k * array.d_x * cos(ϕ) * sin(θ) + array.δx
    ψ_y = k * array.d_y * sin(ϕ) * sin(θ) + array.δy

    factor = abs((sin(array.N_x * ψ_x / 2))/(sin(ψ_x / 2))) * abs((sin(array.N_y * ψ_y / 2))/(sin(ψ_y / 2)))
    return factor
end

function fieldIntensity(array::AntennaArray, θ, ϕ)
    η_0 = 120π
    k = 2π / array.λ
    r = 1

    E_0 = im * (η_0 * array.I * k * array.l) / (4π * r) * exp(-im * k * r)
    return abs(E_0) * arrayFactor(array, θ, ϕ)
end

function antennaArrayFieldIntensity(a::AntennaArray, θ, ϕ)
    k = 2π / a.λ
    r = 10
    arrayFactor = 1
    for i in range(1, a.N-1)
        if a.alternatingCurrents
            arrayFactor += (-1)^(i) * exp(im * k * a.d * (i) * cos(ϕ) * sin(θ))
        else
            arrayFactor += exp(im * k * a.d * (i + 1) * cos(ϕ) * sin(θ))
        end 
    end

    return abs(im * 60 * a.I * exp(-im * k * r) * (cos(k / 2 * a.l * cos(θ)) - cos(k / 2 * a.l)) / (r * sin(θ)) * arrayFactor)
end