using Revise
using Plots
using PlotlyJS
includet("../src/antennaArray.jl")
includet("../src/radiation.jl")
includet("../src/utils.jl")

d = 0.25

antennaBase = createUniformAntennaArray2D(1e9, 1, 0.5, d, d, 16, 12, 0, 0)
antennaHW = hansenWoodyardArray(antennaBase, π/2, 0.0)

radiationPatternPlot3D(antennaHW, 0.01, "3D Radiation Plot - Hansen-Woodyard")