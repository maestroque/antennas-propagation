using Revise
using Plots
using PlotlyJS
includet("../src/antennaArray.jl")
includet("../src/utils.jl")

antennaBase = createAntennaArray(1e9, 1, 0.5, 0.5, 0.5, 16, 12, 0, 0)

steered60 = steerAntennaArray(antennaBase, π/3)

radiationPatternPlot3D(steered60, 0.01)

