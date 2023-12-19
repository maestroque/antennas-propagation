using Revise
using Plots
using Statistics
using Evolutionary
using Distributions
includet("../src/antennaArray.jl")
includet("../src/utils.jl")

N = 10
λ = 1
f = 3e8 / λ
δ = 0
d = 0.5

function arrayFactorMinimization(currentsVector)
    N = 10
    λ = 1
    f = 3e8 / λ
    δ = zeros(10)
    d = 0.5 * ones(10)
    I = [
        currentsVector[1], currentsVector[2], currentsVector[3], currentsVector[4], currentsVector[5], 
        currentsVector[1], currentsVector[2], currentsVector[3], currentsVector[4], currentsVector[5]
    ]

    antenna = createAntennaArray1D(f, I, 0.5, d, N, δ)

    return arrayFactor(antenna, deg2rad(70), 0)
end

lower = 0.1 * ones(6)
upper = 10 * ones(6)
constraints = BoxConstraints(lower, upper)

# ga = GA(populationSize = 500, selection = tournament(50), crossover=SPX, mutation = PLM())
# options = Evolutionary.Options(show_trace = true, iterations = 100)
N = 10
λ = 1
f = 3e8 / λ
δ = zeros(10)
d = 0.5 * ones(10)
antenna = createAntennaArray1D(f, rand(Uniform(0.1, 10), 10), 0.5, d, N, δ)

radiationPatternPlot3D(antenna, 0.01, "ggg")
# radiationPatternPlotHorizontal(antenna, 0.01, "fff")