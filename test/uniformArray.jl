using Revise
using Plots
using PlotlyJS
includet("../src/antennaArray.jl")
includet("../src/utils.jl")

antennaBase = createAntennaArray(1e9, 1, 0.5, 0.25, 0.25, 16, 12, 0, 0)

steered = steerAntennaArray(antennaBase, π/2, 0.0)

radiationPatternPlot3D(steered, 0.01, "3D Radiation Plot - 0 degrees")
radiationPatternPlotHorizontal(steered, 0.01, "Vertical Radiation Plot - 0 degrees")
radiationPatternPlotVertical(steered, 0.01, "Horizontal Radiation Plot - 0 degrees")

