# Autor Piotr Zapała nr.indeksu 261712 

include("./module.jl")
using .Algorithms
using Plots

f = x -> exp(x)
g = x -> x^2 * sin(x)
for n in [5, 10, 15]
    plot_f = rysujNnfx(f, 0., 1., n)
    plot_g = rysujNnfx(g, -1., 1., n)
    savefig(plot_f, "z5f1_$n.png")
    savefig(plot_g, "z5f2_$n.png")
end