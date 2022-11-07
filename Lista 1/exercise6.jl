function f(x)
    sqrt(x^2 + 1.) - 1.
end

function g(x)
    x^2 / (sqrt(x^2 + 1.) + 1.)
end

function main()
    values = zeros(0)   
    for i in 1:100
        append!(values, 8.0^(-i))
    end
    f1 = map(x -> f(x), values)
    g1 = map(x -> g(x), values)
    foreach((x, y) -> println("f(x)=", x, "    ", "g(x)=", y), f1, g1)
    #foreach((x, y, z) -> println("x=", z, "  ", "relative error=", abs(x - y)), f1, g1, values)

end