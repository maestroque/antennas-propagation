using Revise
using Plots
using PlotlyJS
includet("antennaArray.jl")
includet("radiation.jl")

X(r,theta,phi) = r * sin(theta) * sin(phi)
Y(r,theta,phi) = r * sin(theta) * cos(phi)
Z(r,theta,phi) = r * cos(theta)

db(x) = 10log10(x)

C_LIGHT = 3e8

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
    normalized_intensity = fieldIntensity.(Ref(antenna), π/2, ϕ) ./ maximum(fieldIntensity.(Ref(antenna), π/2, ϕ))
    p = PlotlyJS.plot(ϕ, db.(normalized_intensity), proj=:polar, gridlinewidth=2, title=text)
    
    display(p)
end

function radiationPatternPlotHorizontal(antenna::AntennaArray, precision::Float64, text::String)
    θ = 0:precision:2π
    ϕ = 0:precision:π
    normalized_intensity = fieldIntensity.(Ref(antenna), θ, 0) ./ maximum(fieldIntensity.(Ref(antenna), θ, 0))
    p = PlotlyJS.plot(θ, db.(normalized_intensity), proj=:polar, gridlinewidth=2, title=text)
    display(p)
end