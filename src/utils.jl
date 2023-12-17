using Revise
using Plots
using PlotlyJS
includet("antennaArray.jl")

X(r,theta,phi) = r * sin(theta) * sin(phi)
Y(r,theta,phi) = r * sin(theta) * cos(phi)
Z(r,theta,phi) = r * cos(theta)

function radiationPatternPlot3D(antenna::AntennaArray, precision::Float64)
    θ = 0:precision:2π
    ϕ = 0:precision:π

    xs = [X(fieldIntensity(antenna, theta, phi), theta, phi) for theta in θ, phi in ϕ]
    ys = [Y(fieldIntensity(antenna, theta, phi), theta, phi) for theta in θ, phi in ϕ]
    zs = [Z(fieldIntensity(antenna, theta, phi), theta, phi) for theta in θ, phi in ϕ]

    p = PlotlyJS.plot(PlotlyJS.surface(x=xs, y=ys, z=zs, surfacecolor=@. xs^2 + ys^2 + zs^2))
    display(p)
end

function radiationPatternPlotVertical(antenna::AntennaArray, precision::Float64)
    θ = 0:precision:2π
    ϕ = 0:precision:π
    
    p = Plots.plot(ϕ, fieldIntensity.(Ref(antenna), π/2, ϕ), proj=:polar, gridlinewidth=2)
    # p = PlotlyJS.plot(PlotlyJS.scatterpolar(ϕ, fieldIntensity.(Ref(antenna), π/2, ϕ), theta=:y, mode="lines"))
    display(p)
end

function radiationPatternPlotHorizontal(antenna::AntennaArray, precision::Float64)
    θ = 0:precision:2π
    ϕ = 0:precision:π
    p = Plots.plot(θ, fieldIntensity.(Ref(antenna), θ, 0), proj=:polar, gridlinewidth=2)
    # p = PlotlyJS.plot(PlotlyJS.scatterpolar(ϕ, fieldIntensity.(Ref(antenna), θ, 0), theta=:y, mode="lines"))

    display(p)
end