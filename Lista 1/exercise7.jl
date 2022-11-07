function f(x)
    sin(x) + cos(3*x)
end

function g(x)
    cos(x) - 3*sin(3*x)
end

function derivative(f, h, x0)
    (f(x0+h) - f(x0))/h
end

function relativeError(f, g, h, x0)
    abs(g(x0)-derivative(f, h, x0))
end


function main()
    x0 = 1
    @show g(x0)
    for i in 0:54
        h = 2.0^(-i)
        @show h
        @show 1+h
        @show derivative(f, h, x0)
        @show derivative(f, 1+h, x0)
        @show relativeError(f, g, h, x0)
        @show relativeError(f, g, 1+h, x0)
        println('-'^100)
    end
end