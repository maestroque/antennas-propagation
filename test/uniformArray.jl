using Revise
using Plots
using PlotlyJS
includet("../src/antennaArray.jl")

antennaBase = createAntennaArray(1e9, 1, 0.5, 0.5, 0.5, 16, 12, 0, 0)
θ = 0:0.01:2π
ϕ = 0:0.01:π

steered60 = steerAntennaArray(antennaBase, π/3)

X(r,theta,phi) = r * sin(theta) * sin(phi)
Y(r,theta,phi) = r * sin(theta) * cos(phi)
Z(r,theta,phi) = r * cos(theta)

xs = [X(fieldIntensity(steered30, theta, phi), theta, phi) for theta in θ, phi in ϕ]
ys = [Y(fieldIntensity(steered30, theta, phi), theta, phi) for theta in θ, phi in ϕ]
zs = [Z(fieldIntensity(steered30, theta, phi), theta, phi) for theta in θ, phi in ϕ]

PlotlyJS.plot(PlotlyJS.surface(x=xs, y=ys, z=zs, surfacecolor=@. xs^2 + ys^2 + zs^2))

