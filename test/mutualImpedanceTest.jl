using Plots
using Revise

includet("../src/mutualImpedance.jl")

f = 1e9
l = 0.5
d = 0.01:0.01:3

Zm = @. parallelMutualImpedance(f, l, d)

# print(last.(Zm))
Plots.plot(d, first.(Zm), label="R_12m")
Plots.plot!(d, last.(Zm), label="X_12m")

