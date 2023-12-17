#Autor: Piotr Zapała 2023

function check(delta)
    for k in 1:10
        println(bitstring(Float64(1 + k*delta)))
    end
end

function main()
    println('-'^20)
    check(Float64((1/2)^(53)))
    println('-'^20)
    @show check(Float64((1/2)^(52)))
    println('-'^20)
    @show check(Float64((1/2)^(51)))
    println('-'^20)
end