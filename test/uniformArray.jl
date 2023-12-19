using Revise
using Plots
using PlotlyJS
includet("../src/antennaArray.jl")
includet("../src/radiation.jl")
includet("../src/utils.jl")

antennaBase = createAntennaArray2D(1e9, 1, 0.5, 0.25, 0.25, 16, 12, 0, 0)
steered = steerAntennaArray(antennaBase, π/2, π/3)

# radiationPatternPlot3D(steered, 0.01, "3D Radiation Plot - 0 degrees")
# radiationPatternPlotHorizontal(steered, 0.01, "Vertical Radiation Plot - 0 degrees")
# radiationPatternPlotVertical(steered, 0.01, "Horizontal Radiation Plot - 0 degrees")

print("Directivity is: ", directivity(steered, π/3))

