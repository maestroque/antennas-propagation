using Revise
using Plots
using PlotlyJS
includet("../src/antennaArray.jl")

antenna = createAntennaArray(1e9, 1, 0.5, 0.5, 0.5, 16, 12, 1, 1)
θ = 0:0.01:2π
ϕ = 0:0.01:π

X(r,theta,phi) = r * sin(theta) * sin(phi)
Y(r,theta,phi) = r * sin(theta) * cos(phi)
Z(r,theta,phi) = r * cos(theta)

xs = [X(fieldIntensity(antenna, theta, phi), theta, phi) for theta in θ, phi in ϕ]
ys = [Y(fieldIntensity(antenna, theta, phi), theta, phi) for theta in θ, phi in ϕ]
zs = [Z(fieldIntensity(antenna, theta, phi), theta, phi) for theta in θ, phi in ϕ]

PlotlyJS.plot(PlotlyJS.surface(x=xs, y=ys, z=zs, surfacecolor=@. xs^2 + ys^2 + zs^2))

