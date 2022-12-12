#Autor: Piotr Zapała nr.indeksu 261712

function exercise1(p0, r, iterations, type, condition)
    predecessor = type(p0)
    successor = type(0)
    for i in 1:iterations
        successor = type(predecessor) + type(r)*type(predecessor)*(type(1) - type(predecessor))
        predecessor = type(successor)
        if i == 10 && condition == true
            predecessor = trunc(predecessor, digits=3)
        end 
    end 
    return successor
end

function main()
    p0 = 0.01
    r = 3
    iterations = 40
    result1 = exercise1(p0, r, iterations, Float32, false)
    result2 = exercise1(p0, r, iterations, Float32, true)
    result3 = exercise1(p0, r, iterations, Float64, false)
    println(result1)
    println(result2)
    println(result3)
end