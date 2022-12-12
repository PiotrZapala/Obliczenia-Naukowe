#Autor: Piotr Zapała nr.indeksu 261712

include("./module.jl")
using .Algorithms

function f(x)
    sin(x) - (1/4)*x^2
end

function pf(x)
    cos(x) - (1/2)*x
end

function main()
    delta = (1/2)*10^(-5)
    epsilon = (1/2)*10^(-5)
    @show mbisekcji(f, 1.5, 2.0, delta, epsilon)
    @show mstycznych(f, pf, 1.5, delta, epsilon, 40)
    @show msiecznych(f, 1.0, 2.0, delta, epsilon, 40)
end