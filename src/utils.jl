using Revise
using Plots
using PlotlyJS
includet("antennaArray.jl")

X(r,theta,phi) = r * sin(theta) * sin(phi)
Y(r,theta,phi) = r * sin(theta) * cos(phi)
Z(r,theta,phi) = r * cos(theta)

function radiationPatternPlot3D(antenna::AntennaArray, precision::Float64, title::String)
    θ = 0:precision:2π+2precision
    ϕ = 0:precision:π+2precision
    xs = [X(fieldIntensity(antenna, theta, phi), theta, phi) for theta in θ, phi in ϕ]
    ys = [Y(fieldIntensity(antenna, theta, phi), theta, phi) for theta in θ, phi in ϕ]
    zs = [Z(fieldIntensity(antenna, theta, phi), theta, phi) for theta in θ, phi in ϕ]
    p = PlotlyJS.plot(PlotlyJS.surface(x=xs, y=ys, z=zs, surfacecolor=@. xs^2 + ys^2 + zs^2), 
                      Layout(title=attr(text=title, xanchor="center", yanchor= "top")))
    display(p)
end

function radiationPatternPlotVertical(antenna::AntennaArray, precision::Float64, text::String)
    θ = 0:precision:2π
    ϕ = 0:precision:2π
    p = Plots.plot(ϕ, fieldIntensity.(Ref(antenna), π/2, ϕ), proj=:polar, gridlinewidth=2, title=text)
    display(p)
end

function radiationPatternPlotHorizontal(antenna::AntennaArray, precision::Float64, text::String)
    θ = 0:precision:2π
    ϕ = 0:precision:π
    p = Plots.plot(θ, fieldIntensity.(Ref(antenna), θ, 0), proj=:polar, gridlinewidth=2, title=text)
    display(p)
end