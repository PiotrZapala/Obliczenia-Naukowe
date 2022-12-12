#Autor: Piotr Zapała nr.indeksu 261712

function exercise1(c, x0, iterations, type)
    predecessor = type(x0)
    successor = type(0)
    for i in 1:iterations
        successor = type(predecessor)*type(predecessor) + type(c)
        predecessor = type(successor)
    end 
    return successor
end

function main()
    @show exercise1(-2, 1, 40, Float64)
    @show exercise1(-2, 2, 40, Float64)
    @show exercise1(-2, 1.99999999999999, 40, Float64)
    @show exercise1(-1, 1, 40, Float64)
    @show exercise1(-1, -1, 40, Float64)
    @show exercise1(-1, 0.75, 40, Float64)
    @show exercise1(-1, 0.25, 40, Float64)
end