#Autor: Piotr Zapała nr.indeksu 261712

include("./module.jl")
using .Algorithms

function f(x)
    exp(x) - 3*x
end

function pf(x)
    exp(x) - 3
end

function main()
    delta = 10^(-4)
    epsilon = 10^(-4)
    @show mbisekcji(f, 0.0, 1.0, delta, epsilon)
    @show mbisekcji(f, 1.0, 2.0, delta, epsilon)
end