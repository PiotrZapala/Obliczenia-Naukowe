#Autor: Piotr Zapała 2023

function machEps(type)
    epsilon = one(type)
    while one(type) + epsilon / 2 != one(type)
        epsilon = type(epsilon / 2)
    end
    return epsilon
end

function eta(type)
    eta = one(type)
    while eta / 2 != 0
        eta = type(eta / 2)
    end
    return eta
end

function maxFloat(type)
    max = prevfloat(one(type))
    while !isinf(2*max)
        max *= 2
    end
    return max
end

function main()
    types = [Float16, Float32, Float64]
    for type in types
        @show type
        println()
        @show machEps(type)
        @show eps(type)
        println()
        @show eta(type)
        @show nextfloat(type(0))
        println()
        @show maxFloat(type)
        @show floatmax(type)
        println('-'^60)
    end
end