#Autor: Piotr Zapała 2023

function example1()
    a = one(Float64)
    while nextfloat(a) * (one(Float64)/nextfloat(a)) == one(Float64) && a < 2
        a = nextfloat(a)
    end
    return nextfloat(a)
end

function example2()
    b = nextfloat(zero(Float64))
    while nextfloat(b) * (one(Float64)/nextfloat(b)) == one(Float64)
        b = nextfloat(b)
    end
    return nextfloat(b)
end

function main()
    @show example1()
    @show example2()
end