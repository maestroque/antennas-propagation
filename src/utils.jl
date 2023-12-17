using Revise
using Plots
using PlotlyJS
includet("antennaArray.jl")

X(r,theta,phi) = r * sin(theta) * sin(phi)
Y(r,theta,phi) = r * sin(theta) * cos(phi)
Z(r,theta,phi) = r * cos(theta)

function radiationPatternPlot3D(antenna::AntennaArray)
    xs = [X(fieldIntensity(antenna, theta, phi), theta, phi) for theta in θ, phi in ϕ]
    ys = [Y(fieldIntensity(antenna, theta, phi), theta, phi) for theta in θ, phi in ϕ]
    zs = [Z(fieldIntensity(antenna, theta, phi), theta, phi) for theta in θ, phi in ϕ]

    PlotlyJS.plot(PlotlyJS.surface(x=xs, y=ys, z=zs, surfacecolor=@. xs^2 + ys^2 + zs^2))
end

function radiationPatternPlotVertical(antenna::AntennaArray)
    xs = [X(fieldIntensity(antenna, theta, phi), theta, phi) for theta in θ, phi in ϕ]
    ys = [Y(fieldIntensity(antenna, theta, phi), theta, phi) for theta in θ, phi in ϕ]
    zs = [Z(fieldIntensity(antenna, theta, phi), theta, phi) for theta in θ, phi in ϕ]

end

function radiationPatternPlotHorizontal(antenna::AntennaArray)
    xs = [X(fieldIntensity(antenna, theta, phi), theta, phi) for theta in θ, phi in ϕ]
    ys = [Y(fieldIntensity(antenna, theta, phi), theta, phi) for theta in θ, phi in ϕ]
    zs = [Z(fieldIntensity(antenna, theta, phi), theta, phi) for theta in θ, phi in ϕ]

end