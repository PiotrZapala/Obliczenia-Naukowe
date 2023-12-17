#Autor: Piotr Zapała 2023

function kahanEps(type)
    return type(3) * (type(4/3) - one(type)) - one(type)
end

function main()
    types = [Float16, Float32, Float64]
    for type in types
        println('-'^20)
        @show type
        @show kahanEps(type)
        @show eps(type)
        println('-'^20)
    end
end