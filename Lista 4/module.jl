#Autor: Piotr Zapała nr.indeksu 261712

module Algorithms
using Plots

    export ilorazyRoznicowe, warNewton, naturalna, rysujNnfx

    function ilorazyRoznicowe(x::Vector{Float64}, f::Vector{Float64})
        n = length(f)
        d = [i for i in f]
        for j in 1:n
            for i in n:-1:j+1
                d[i] = (d[i] - d[i-1])/(x[i] - x[i-j])
            end
        end
        return d
    end

    function warNewton(x::Vector{Float64}, fx::Vector{Float64}, t::Float64)
        n = length(fx)
        b = fx[n]
        for i in n-1:-1:1
            b = fx[i] + (t - x[i]) * b
        end
        return b
    end

    function naturalna(x::Vector{Float64}, fx::Vector{Float64})
        n = length(x)
        a = zeros(n)
        a[n] = fx[n]
        for i in (n-1):-1:1
            a[i] = fx[i] - x[i] * a[i+1]
            for j in (i+1):(n-1)
                a[j] = a[j] - x[i] + a[j+1]
            end
        end
        return a
    end

    function rysujNnfx(f, a::Float64, b::Float64, n::Int)
        x = zeros(n+1)
        y = zeros(n+1)
        h = (b-a)/n
        for k in 0:n
            x[k+1] = a + k*h
            y[k+1] = f(x[k+1])
        end
        c = ilorazyRoznicowe(x, y)
        points = 50 * (n+1)
        dx = (b-a)/(points-1)
        xs = zeros(points)
        polynomial = zeros(points)
        func = zeros(points)
        xs[1] = a
        polynomial[1] = func[1] = y[1]
        for i in 2:points
            xs[i] = xs[i-1] + dx
            polynomial[i] = warNewton(x, c, xs[i])
            func[i] = f(xs[i])
        end
        p = plot(xs, [polynomial func], label=["wielomian" "funkcja"], title="n = $n")
        display(p)
        return p
    end
end