using Revise
using Plots
using PlotlyJS
using SpecialFunctions

abstract type AntennaArray end

mutable struct UniformAntennaArray2D <: AntennaArray
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

mutable struct UniformAntennaArray1D <: AntennaArray
    λ::Float64
    I::Float64
    l::Float64
    d::Float64
    N::Int
    δ::Float64
end

mutable struct AntennaArray1D <: AntennaArray
    λ::Float64
    I::Vector{Float64}
    l::Float64
    d::Vector{Float64}
    N::Int
    δ::Vector{Float64}
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
function createUniformAntennaArray2D(f, I, lλ, dλ_x, dλ_y, N_x, N_y, δx, δy)
    λ = 3e8 / f
    d_x = dλ_x * λ
    d_y = dλ_y * λ
    l = lλ * λ
    return UniformAntennaArray2D(λ, I, l, d_x, d_y, N_x, N_y, δx, δy)
end

function createAntennaArray1D(f, I::Array{Float64}, lλ, dλ::Array{Float64}, N, δ::Array{Float64})
    if length(I) != N
        throw(ArgumentError("Length of current array I must be equal to N, you might need createUniformAntennaArray1D"))
    end

    λ = 3e8 / f
    d = dλ .* λ
    l = lλ * λ
    return AntennaArray1D(λ, I, l, d, N, δ)
end

function createUniformAntennaArray1D(f, I, lλ, dλ, N, δ)
    λ = 3e8 / f
    d = dλ * λ
    l = lλ * λ
    return UniformAntennaArray1D(λ, I, l, d, N, δ)
end

function steerAntennaArray(array::UniformAntennaArray2D, θ0::Float64, ϕ0::Float64)
    k = 2π / array.λ
    δx = - k * array.d_x * sin(θ0) * cos(ϕ0)
    δy = - k * array.d_y * sin(θ0) * sin(ϕ0)

    return UniformAntennaArray2D(array.λ, array.I, array.l, array.d_x,
                        array.d_y, array.N_x, array.N_y, δx, δy)
end

function hansenWoodyardArray(array::UniformAntennaArray2D, θ0::Float64, ϕ0::Float64)
    k = 2π / array.λ
    δx = - k * array.d_x * sin(θ0) * cos(ϕ0) - 2.92 / array.N_x
    δy = - k * array.d_y * sin(θ0) * sin(ϕ0) - 2.92 / array.N_y

    return UniformAntennaArray2D(array.λ, array.I, array.l, array.d_x,
                          array.d_y, array.N_x, array.N_y, δx, δy)
end

function arrayFactor(array::UniformAntennaArray2D, θ, ϕ)
    k = 2π / array.λ
    ψ_x = k * array.d_x * cos(ϕ) * sin(θ) + array.δx
    ψ_y = k * array.d_y * sin(ϕ) * sin(θ) + array.δy

    factor = abs((sin(array.N_x * ψ_x / 2))/(sin(ψ_x / 2))) * abs((sin(array.N_y * ψ_y / 2))/(sin(ψ_y / 2)))
    return factor
end

"""
Vertical (Z-axis) antenna array
"""
function arrayFactor(array::AntennaArray1D, θ, ϕ)
    k = 2π / array.λ
    ψ = k * array.d[1] * cos(θ) + array.δ[1]

    sum = 1
    for i in range(1, array.N)
        sum += array.I[i] * exp(im * i * ψ)
    end

    return sum
end