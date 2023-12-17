# Autor Piotr Zapała nr.indeksu 261712 

include("./module.jl")
using .Algorithms
using Plots

f = x -> abs(x)
g = x -> 1/(1+x^2)
for n in [5, 10, 15]
    plot_f = rysujNnfx(f, -1., 1., n)
    plot_g = rysujNnfx(g, -5., 5., n)
    savefig(plot_f, "z6f1_$n.png")
    savefig(plot_g, "z6f2_$n.png")
end