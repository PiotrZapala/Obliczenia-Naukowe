using LinearAlgebra

#Autor: Prof. Paweł Zieliński
function hilb(n::Int)
    if n < 1
        error("size n should be >= 1")
    end
    return [1 / (i + j - 1) for i in 1:n, j in 1:n]
end


function matcond(n::Int, c::Float64)
    if n < 2
        error("size n should be > 1")
    end
    if c< 1.0
        error("condition number  c of a matrix  should be >= 1.0")
    end
    (U,S,V)=svd(rand(n,n))
    return U*diagm(0 =>[LinRange(1.0,c,n);])*V'
end

#Autor: Piotr Zapała

#Funkcja generująca losową macierz o zadanym wskaniku uwarunkowania 
function randomMatrixGenerator(size, cond)
    random = []
    for i in eachindex(size)
        for j in eachindex(cond)
            push!(random, matcond(size[i], cond[j]))
        end
    end
    return random
end

#Funkcja generująca macierz hilberta o zadanych wymaiarch
function hilbertMatrixGenerator(size)
    hilbert = []
    for i in eachindex(size)
        push!(hilbert, hilb(size[i]))
    end
    return hilbert
end

#Funkcja rozwiązująca układy równań liniowych
function matrixSolver(hilbert, random)
    gaussian1 = []
    inv1 = [] 
    for i in eachindex(hilbert)
        x = ones(Int(length(hilbert[i])^(1/2)))
        b = hilbert[i]*x
        push!(gaussian1, hilbert[i]\b)
        push!(inv1, inv(hilbert[i])*b)
    end
    gaussian2 = []
    inv2 = [] 
    for j in eachindex(random)
        x = ones(Int(length(random[j])^(1/2)))
        b = random[j]*x
        push!(gaussian2, random[j]\b)
        push!(inv2, inv(random[j])*b)
    end
    return gaussian1, inv1, gaussian2, inv2
end


function relativeError(gaussian1, inv1, gaussian2, inv2)
    relativeGaussianHilbert = []
    relativeInvHilbert = []
    relativeGaussianRandom = []
    relativeInvRandom = []
    size1 = []
    size2 = []
    for i in eachindex(gaussian1)
        b = ones(length(gaussian1[i]))
        push!(size1, length(gaussian1[i]))
        push!(relativeGaussianHilbert, norm(b - gaussian1[i])/norm(b))
        push!(relativeInvHilbert, norm(b - inv1[i])/norm(b))
    end
    for j in eachindex(gaussian2)
        b = ones(length(gaussian2[j]))
        push!(size2, length(gaussian2[j]))
        push!(relativeGaussianRandom, norm(b - gaussian2[j])/norm(b))
        push!(relativeInvRandom, norm(b - inv2[j])/norm(b))
    end
    return relativeGaussianHilbert, relativeInvHilbert, 
    relativeGaussianRandom, relativeInvRandom, size1, size2
end

function displayHilbertResults(hilbert, relativeGaussianHilbert, relativeInvHilbert, size)
    for i in eachindex(hilbert)
        print("size = $(size[i]), rank = $(rank(hilbert[i])) cond = $(cond(hilbert[i])), gaussian relative error = $(relativeGaussianHilbert[i]), invert relative error = $(relativeInvHilbert[i]), \n")
    end
end

function displayRandomResults(random, relativeGaussianRandom, relativeInvRandom, size)
    for i in eachindex(random)
        print("size = $(size[i]), rank = $(rank(random[i])) cond = $(cond(random[i])), gaussian relative error = $(relativeGaussianRandom[i]), invert relative error = $(relativeInvRandom[i]), \n")
    end
end

function main()
    sizeRandom = [5, 10, 20]
    sizeHilbert = map(Int, collect(range(2, 36, length=18)))
    cond = map(Float64, [1, 10, 10^3, 10^7, 10^12, 10^16])
    random = randomMatrixGenerator(sizeRandom, cond)
    hilbert = hilbertMatrixGenerator(sizeHilbert)
    gaussianHilbert, invHilbert, gaussianRandom, invRandom = matrixSolver(hilbert, random)
    relativeGaussianHilbert, relativeInvHilbert, relativeGaussianRandom, relativeInvRandom, size1, size2 = 
    relativeError(gaussianHilbert, invHilbert, gaussianRandom, invRandom)
    displayHilbertResults(hilbert, relativeGaussianHilbert, relativeInvHilbert, size1)
    println()
    displayRandomResults(random, relativeGaussianRandom, relativeInvRandom, size2)
end