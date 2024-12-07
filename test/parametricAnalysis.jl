using Revise
using Plots
using PlotlyJS
using Statistics
includet("../src/antennaArray.jl")
includet("../src/utils.jl")

N = 10
λ = 1
f = C_LIGHT / λ
δ = 0
precisionStep = 0.1

function meanHeuristic(I)
    antenna = createAntennaArray1D(f, I, 0.5, [0.25, 0.25, 0.25, 0.25, 0.25], N, [0.0, 0.0, 0.0, 0.0, 0.0])
    
    θ = deg2rad.(0:1:70)
    AF = arrayFactor.(Ref(antenna), θ, 0)
    return mean(AF)
end

function maxSLL(AF)
    local_maxima = findall(x -> x > 0 && AF[x] > AF[x-1] && AF[x] > AF[x+1], 2:length(AF)-1)
    sorted_maxima = sort(AF[local_maxima], rev=true)
    return length(sorted_maxima) >= 2 ? sorted_maxima[2] : NaN
end

# Max SLL simulation for different A values, without manual tuning 
θ = deg2rad.(vcat(0:precisionStep:180))
plotlyjs()
p = Plots.plot()
for A in [4, 8, 16, 24]
    I_h = collect(range(1, stop=A, length=Int(N/2)))
    I = vcat(I_h, reverse(I_h))
    antenna = createAntennaArray1D(f, I, 0.5, [0.25, 0.25, 0.25, 0.25, 0.25], N, [0.0, 0.0, 0.0, 0.0, 0.0])
    AF = arrayFactor.(Ref(antenna), θ, 0)
    normAF = abs.(AF) ./ maximum(abs.(AF))
    Plots.plot!(p, θ, 20log10.(normAF), label="A = $A")
    SLL = maxSLL(normAF)
    println("A: ", A, " Maximum SLL: ", 20log10(SLL), " dB")
end
xlabel!(p, "Angle (radians)")
ylabel!(p, "Array Factor")
title!(p, "Radiation Patterns for Multiple A Values, without Manual Tuning")
display(p)

# Max SLL simulation for different A values, with manual tuning

for A in [4, 8, 16, 24]
    p = Plots.plot()
    I_h = collect(range(1, stop=A, length=Int(N/2)))
    for (i, j) in [(1.15, 1), (0.85, 1), (1, 1.15), (1, 0.85)]
        I_h[2] = i * I_h[2]
        I_h[4] = j * I_h[4]
        I = vcat(I_h, reverse(I_h))
        antenna = createAntennaArray1D(f, I, 0.5, [0.25, 0.25, 0.25, 0.25, 0.25], N, [0.0, 0.0, 0.0, 0.0, 0.0])
        AF = arrayFactor.(Ref(antenna), θ, 0)
        normAF = abs.(AF) ./ maximum(abs.(AF))
        Plots.plot!(p, θ, 20log10.(normAF), label="A = $A, I[$i] = $j")
        SLL = maxSLL(normAF)
        println("A: ", A, " I[$i]: $j Maximum SLL: ", 20log10(SLL), " dB")
    end
    xlabel!(p, "Angle (radians)")
    ylabel!(p, "Array Factor")
    title!(p, "Radiation Patterns for A = $A with Manual Tuning")
    display(p)
end
