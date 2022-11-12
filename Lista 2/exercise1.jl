#Autor: Piotr Zapała nr.indeksu 261712

function example1(x, y, type)
    sum = type(0)
    for i in (1:length(x))
        sum = sum + x[i]*y[i]
    end
    return sum
end

function example2(x, y, type)
    sum = type(0)
    for i in (length(x):-1:1) 
        sum = sum + x[i]*y[i]
    end
    return sum
end

function example3(x, y, type)
    sum1 = type[]
    sum2 = type[]
    for i in (1:length(x))
        sum = x[i]*y[i]
        if sum >= 0
            append!(sum1, sum)
        else 
            append!(sum2, sum)
        end
    end
    sort!(sum1, rev=true)
    sort!(sum2, rev=true)
    positive = 0
    negative = 0

    for i in (1:length(sum1))
        positive += sum1[i]
    end

    for i in (1:length(sum2))
        negative += sum2[i]
    end

    return positive + negative
end

function example4(x, y, type)
    sum1 = type[]
    sum2 = type[]
    for i in (1:length(x))
        sum = x[i]*y[i]
        if sum >= 0
            append!(sum1, sum)
        else 
            append!(sum2, sum)
        end
    end
    sort!(sum1)
    sort!(sum2)
    positive = 0
    negative = 0

    for i in (1:length(sum1))
        positive += sum1[i]
    end

    for i in (1:length(sum2))
        negative += sum2[i]
    end

    return positive + negative
end

function main()
    types = [Float32, Float64]
    for type in types
        x = map(type, [2.718281828, -3.141592654, 1.414213562, 0.577215664, 0.301029995])
        y = map(type, [1486.2497, 878366.9879, -22.37492, 4773714.647, 0.0000185049])
        println('-'^20)
        @show type
        @show example1(x, y, type)
        @show example2(x, y, type)
        @show example3(x, y, type)
        @show example4(x, y, type)
        println('-'^20)
    end
end