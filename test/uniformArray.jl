using Revise
using Plots
using PlotlyJS
includet("../src/antennaArray.jl")
includet("../src/utils.jl")

antennaBase = createAntennaArray(1e9, 1, 0.5, 0.5, 0.5, 16, 12, 0, 0)

steered = steerAntennaArray(antennaBase, π/2, π/3)

radiationPatternPlot3D(steered, 0.01)
radiationPatternPlotHorizontal(steered, 0.01)
# radiationPatternPlotVertical(steered, 0.01)

