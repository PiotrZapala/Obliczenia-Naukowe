#Autor: Piotr Zapała nr.indeksu 261712

module Algorithms

    export mbisekcji, mstycznych, msiecznych

    function mbisekcji(f::Function, a::Float64, b::Float64, delta::Float64, epsilon::Float64)
        it = 0
        u = f(a)
        v = f(b)
        e = b - a
        if sign(u) == sign(v)
            return 0, 0, it, 1
        end
        while true
            it = it + 1
            e = e/2
            c = a + e
            w = f(c)
            if abs(e) < delta || abs(w) < epsilon
                return c, w, it, 0
            end
            if sign(w) != sign(u)
                b = c
                v = w
            else
                a = c
                u = w
            end
        end  
    end

    function mstycznych(f::Function, pf::Function, x0::Float64, delta::Float64, epsilon::Float64, maxit::Int)
        v = f(x0)
        if abs(v) < epsilon
            return x0, v, 0, 0
        end
        if abs(pf(x0)) < epsilon
            return 0, 0, 0, 2
        end
        for i in 1:maxit
            x1 = x0 - v/pf(x0)
            v = f(x1)
            if abs(x1 - x0) < delta || abs(v) < epsilon
                return x1, v, i, 0
            end
            x0 = x1
        end
        return 0, 0, 0, 1 
    end

    function msiecznych(f::Function, x0::Float64, x1::Float64, delta::Float64, epsilon::Float64, maxit::Int)
        fa = f(x0)
        fb = f(x1)
        for i in 1:maxit
            if abs(fa) > abs(fb)
                x0, x1 = x1, x0
                fa, fb = fb, fa
            end
            s = (x1 - x0)/(fb - fa)
            x1 = x0
            fb = fa
            x0 = x0 - (fa * s)
            fa = f(x0)
            if abs(x1 - x0) < delta || abs(fa) < epsilon
                return x0, fa, i, 0
            end
        end
        return 0, 0, 0, 1 
    end
    
end