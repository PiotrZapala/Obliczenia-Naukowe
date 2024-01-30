#Autor: Piotr Zapała
include("BlockSys.jl")
include("Utils.jl")

using .BlockSys
using .Utils
using Printf 
using LinearAlgebra
using BenchmarkTools
using Plots

function test1()
    matrix, vector, size_of_matrix, size_of_nested_matrixes = loadFile("testy/Dane16_1_1/A.txt", "testy/Dane16_1_1/b.txt")
    solution, matrix = gaussEliminationWithPartialPivoting(matrix, vector, size_of_matrix, size_of_nested_matrixes)
    printMatrix(matrix, size_of_matrix)
    println("The solution is:")
    for i in 1:size_of_matrix
        @printf("x[%d] = %.30f\n", i, solution[i])
    end
end

function test2()
    matrix, vector, size_of_matrix, size_of_nested_matrixes = loadFile("testy/Dane16_1_1/A.txt", "testy/Dane16_1_1/b.txt")
    printMatrix(matrix, size_of_matrix)
    solution, matrix= gaussEliminationWithPartialPivoting(matrix, vector, size_of_matrix, size_of_nested_matrixes)
    printMatrix(matrix, size_of_matrix)
    println("The solution is:")
    for i in 1:size_of_matrix
        @printf("x[%d] = %.30f\n", i, solution[i])
    end
end

function test3()
    matrix, vector, size_of_matrix, size_of_nested_matrixes = loadFile("testy/Dane16_1_1/A.txt", "testy/Dane16_1_1/b.txt")
    printMatrix(matrix, size_of_matrix)
    println()
    L, U, new_vector = LUdecompositionWithPivoting(matrix, vector, size_of_matrix, size_of_nested_matrixes)
    printMatrix(L, size_of_matrix)
    println()
    printMatrix(U, size_of_matrix)
    println()
    solution = solveLU(L, U, new_vector, size_of_matrix)
    println("The solution is:")
    for i in 1:size_of_matrix
        @printf("x[%d] = %.30f\n", i, solution[i])
    end
end

function test4()
    matrix, vector, size_of_matrix, size_of_nested_matrixes = loadFile("testy/Dane16_1_1/A.txt", "testy/Dane16_1_1/b.txt")
    printMatrix(matrix, size_of_matrix)
    println()
    L, U = LUdecompositionWithoutPivoting(matrix, size_of_matrix, size_of_nested_matrixes)
    printMatrix(L, size_of_matrix)
    println()
    printMatrix(U, size_of_matrix)
    solution = solveLU(L, U, vector, size_of_matrix)
    println("The solution is:")
    for i in 1:size_of_matrix
        @printf("x[%d] = %.30f\n", i, solution[i])
    end
end

function test5()
    matrix, vector, size_of_matrix, size_of_nested_matrixes = loadFile("testy/Dane16_1_1/A.txt", "testy/Dane16_1_1/b.txt")
    matr = dictToSparseMatrix(matrix, size_of_matrix)
    matr = hcat(matr...)
    matrix, vector, size_of_matrix, size_of_nested_matrixes = loadFile("testy/Dane16_1_1/A.txt", "testy/Dane16_1_1/b.txt")
    L, U = LUdecompositionWithoutPivoting(matrix, size_of_matrix, size_of_nested_matrixes)
    matr1 = multiplyLU(L, U, size_of_matrix)
    matr1 = hcat(matr1...)
    isapprox(matr1, matr)
end

function test6()
    matrix, vector, size_of_matrix, size_of_nested_matrixes = loadFile("testy/Dane16_1_1/A.txt", "testy/Dane16_1_1/b.txt")
    solution, matrix = gaussEliminationWithPartialPivoting(matrix, vector, size_of_matrix, size_of_nested_matrixes)
    b = multiplyMatrixByVector(matrix, solution)
    println(b)
    println()
    println(vector)
    println()
    error = relativeError(b, vector)
    println(error)
end

function measure_gauss_elimination(matrix, vector, n, l)
    time_elapsed = @elapsed gaussEliminationWithoutPartialPivoting(matrix, vector, n, l)
    return time_elapsed
end

function test7()
    sizes = [16, 10000, 50000, 100000, 300000, 500000]
    results = Float64[]

    for size in sizes
        matrix_file = "testy/Dane$(size)_1_1/A.txt"
        vector_file = "testy/Dane$(size)_1_1/b.txt"
        matrix, vector, size_of_matrix, size_of_nested_matrixes = loadFile(matrix_file, vector_file)
        push!(results, measure_gauss_elimination(matrix, vector, size_of_matrix, size_of_nested_matrixes))
    end

    # Rysowanie wykresu
    plot(sizes, results, xlabel="Rozmiar macierzy", ylabel="Czas wykonania (s)", legend=false)
end
function test8()
    sizes = [16, 10000, 50000, 100000, 300000, 500000]
    results = Float64[]

    for size in sizes
        matrix_file = "testy/Dane$(size)_1_1/A.txt"
        vector_file = "testy/Dane$(size)_1_1/b.txt"
        matrix, vector, size_of_matrix, size_of_nested_matrixes = loadFile(matrix_file, vector_file)
        push!(results, measure_gauss_elimination(matrix, vector, size_of_matrix, size_of_nested_matrixes))
    end

    # Rysowanie wykresu
    plot(sizes, results, xlabel="Rozmiar macierzy", ylabel="Czas wykonania (s)", legend=false)
end

function test8()
    sizes = [16, 10000, 50000, 100000, 300000, 500000]
    results = Float64[]

    for size in sizes
        matrix_file = "testy/Dane$(size)_1_1/A.txt"
        vector_file = "testy/Dane$(size)_1_1/b.txt"
        matrix, vector, size_of_matrix, size_of_nested_matrixes = loadFile(matrix_file, vector_file)
        real_values = ones(size_of_matrix)
        solution, matrix = gaussEliminationWithoutPartialPivoting(matrix, vector, size_of_matrix, size_of_nested_matrixes)
        error = relativeError(solution, real_values)
        push!(results, error)
    end
    println(results)
end

function test9()
    sizes = [16, 10000, 50000, 100000, 300000, 500000]
    results = Float64[]

    for size in sizes
        matrix_file = "testy/Dane$(size)_1_1/A.txt"
        vector_file = "testy/Dane$(size)_1_1/b.txt"
        matrix, vector, size_of_matrix, size_of_nested_matrixes = loadFile(matrix_file, vector_file)
        real_values = ones(size_of_matrix)
        solution, matrix = gaussEliminationWithPartialPivoting(matrix, vector, size_of_matrix, size_of_nested_matrixes)
        error = relativeError(solution, real_values)
        push!(results, error)
    end
    println(results)
end

function test10()
    sizes = [16, 10000, 50000, 100000, 300000, 500000]
    results = Float64[]

    for size in sizes
        matrix_file = "testy/Dane$(size)_1_1/A.txt"
        vector_file = "testy/Dane$(size)_1_1/b.txt"
        matrix, vector, size_of_matrix, size_of_nested_matrixes = loadFile(matrix_file, vector_file)
        real_values = ones(size_of_matrix)
        L, U = LUdecompositionWithoutPivoting(matrix, size_of_matrix, size_of_nested_matrixes)
        solution = solveLU(L, U, vector, size_of_matrix)
        error = relativeError(solution, real_values)
        push!(results, error)
    end
    println(results)
end

function test11()
    sizes = [16, 10000, 50000, 100000, 300000, 500000]
    results = Float64[]

    for size in sizes
        matrix_file = "testy/Dane$(size)_1_1/A.txt"
        vector_file = "testy/Dane$(size)_1_1/b.txt"
        matrix, vector, size_of_matrix, size_of_nested_matrixes = loadFile(matrix_file, vector_file)
        real_values = ones(size_of_matrix)
        L, U, new_vector = LUdecompositionWithPivoting(matrix, vector, size_of_matrix, size_of_nested_matrixes)
        solution = solveLU(L, U, new_vector, size_of_matrix)
        error = relativeError(solution, real_values)
        push!(results, error)
    end
    println(results)
end

#test1()
#test2()
#test3()
#test4()
#test5()
#test6()
#test7()
#test8()
#test9()
#test10()
test11()
