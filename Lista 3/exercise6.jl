#Autor: Piotr Zapała nr.indeksu 261712

include("./module.jl")
using .Algorithms

function f1(x)
    exp(1-x) - 1
end

function pf1(x)
    -exp(1-x)
end

function f2(x)
    x*exp(-x)
end

function pf2(x)
    -exp(-x)*(x-1)
end

function main()
    delta = 10^(-5)
    epsilon = 10^(-5)
    @show mbisekcji(f1, 0.5, 2.0, delta, epsilon)
    @show mbisekcji(f2, -1.5, 0.5, delta, epsilon)
    @show mstycznych(f1, pf1, 0.0, delta, epsilon, 40)
    @show mstycznych(f2, pf2, -1.0, delta, epsilon, 40)
    @show msiecznych(f1, 0.5, 2.0, delta, epsilon, 40)
    @show msiecznych(f2, -1.5, 0.5, delta, epsilon, 40)
end