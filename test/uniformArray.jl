using Revise
using Plots
using PlotlyJS
includet("../src/antennaArray.jl")
includet("../src/radiation.jl")
includet("../src/utils.jl")

beam_theta = π/2
beam_phi = π/3
d = 0.25

antennaBase = createUniformAntennaArray2D(1e9, 1, 0.5, d, d, 16, 12, 0, 0)
steered = steerAntennaArray(antennaBase, beam_theta, beam_phi)

radiationPatternPlot3D(steered, 0.01, "3D Radiation Plot - 0 degrees")
radiationPatternPlotHorizontal(steered, 0.01, "Vertical Radiation Plot - 0 degrees")
radiationPatternPlotVertical(steered, 0.01, "Horizontal Radiation Plot - 0 degrees")

println("Directivity is (using D): ", 10log10(directivityD(steered, beam_theta, beam_phi)))
println("Directivity is (using HPBW): ", 10log10(directivityHPBW(steered, beam_theta, beam_phi)))
println("Directivity (Riemann Sums) is: ", 10log10(riemannDirectivity(steered, 0.01)))



