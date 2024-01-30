#Autor: Piotr Zapała
module BlockSys

include("Utils.jl")

using DataStructures
using SparseArrays
using LinearAlgebra
using .Utils

export gaussEliminationWithoutPartialPivoting, gaussEliminationWithPartialPivoting,
       LUdecompositionWithoutPivoting, LUdecompositionWithPivoting, solveLU, multiplyLU,
       dictToSparseMatrix, dictToDenseMatrix, multiplyMatrixByVector, relativeError

# Funkcja konwertująca słownik do macierzy rzadkiej
function dictToSparseMatrix(dict, n)
    S = spzeros(n, n)
    for (i, row) in dict
        for (j, value) in row
            S[i, j] = value
        end
    end
    return S
end

# Funkcja mnożąca macierze L i U
function multiplyLU(L_dict, U_dict, n)
    L = dictToSparseMatrix(L_dict, n)
    U = dictToSparseMatrix(U_dict, n)
    LU = L * U
    return Array(LU)
end

function divideRow(matrix_dict, vector, row, pivot)
    for (col, value) in matrix_dict[row]
        matrix_dict[row][col] /= pivot
    end
    vector[row] /= pivot
end

function subtractMultipleOfRow(matrix_dict, vector, source_row, target_row, factor)
    for (col, value) in matrix_dict[source_row]
        if haskey(matrix_dict[target_row], col)
            matrix_dict[target_row][col] -= value * factor
            if matrix_dict[target_row][col] == 0
                delete!(matrix_dict[target_row], col)
            end
        else
            matrix_dict[target_row][col] = -value * factor
        end
    end
    vector[target_row] -= vector[source_row] * factor
end

function gaussEliminationFirstLRowsWithoutPartialPivoting(matrix_dict, vector, n, l)
    for row in 1:l
        pivot = matrix_dict[row][row]
        if pivot != 0
            divideRow(matrix_dict, vector, row, pivot)
            
            for target_row in (row+1):l
                if haskey(matrix_dict[target_row], row)
                    factor = matrix_dict[target_row][row]
                    subtractMultipleOfRow(matrix_dict, vector, row, target_row, factor)
                end
            end
        end
    end
end

function gaussEliminationWithoutPartialPivoting(matrix_dict, vector, n, l)
    gaussEliminationFirstLRowsWithoutPartialPivoting(matrix_dict, vector, n, l) 
    for row in (l):(n-l)
        pivot = matrix_dict[row][row]
        if pivot != 0
            divideRow(matrix_dict, vector, row, pivot)
            
            for target_row in (row+1):min(n, row+l)
                if haskey(matrix_dict[target_row], row)
                    factor = matrix_dict[target_row][row]
                    subtractMultipleOfRow(matrix_dict, vector, row, target_row, factor)
                end
            end
        end
    end
    gaussEliminationLastLRowsWithoutPartialPivoting(matrix_dict, vector, n, l)
    solution = backwardSubstitution(matrix_dict, vector, n)
    
    return solution, matrix_dict
end

function gaussEliminationLastLRowsWithoutPartialPivoting(matrix_dict, vector, n, l)
    for row in (n-l+1):n
        pivot = matrix_dict[row][row]
        if pivot != 0
            divideRow(matrix_dict, vector, row, pivot)
            
            for target_row in (row+1):n
                if haskey(matrix_dict[target_row], row)
                    factor = matrix_dict[target_row][row]
                    subtractMultipleOfRow(matrix_dict, vector, row, target_row, factor)
                end
            end
        end
    end
end

function partialPivot(matrix_dict, vector, n, row)
    max_value = abs(matrix_dict[row][row])
    max_row = row
    for i in row+1:n
        if haskey(matrix_dict[i], row) && abs(matrix_dict[i][row]) > max_value
            max_value = abs(matrix_dict[i][row])
            max_row = i
        end
    end

    if max_row != row
        matrix_dict[row], matrix_dict[max_row] = matrix_dict[max_row], matrix_dict[row]
        vector[row], vector[max_row] = vector[max_row], vector[row]
    end
end

function gaussEliminationFirstLRowsWithPartialPivoting(matrix_dict, vector, n, l)
    for row in 1:l
        partialPivot(matrix_dict, vector, l, row)
        pivot = matrix_dict[row][row]
        if pivot != 0
            divideRow(matrix_dict, vector, row, pivot)

            for target_row in (row+1):l
                if haskey(matrix_dict[target_row], row)
                    factor = matrix_dict[target_row][row]
                    subtractMultipleOfRow(matrix_dict, vector, row, target_row, factor)
                end
            end
        end
    end
end

function gaussEliminationWithPartialPivoting(matrix_dict, vector, n, l)
    gaussEliminationFirstLRowsWithPartialPivoting(matrix_dict, vector, n, l)
    for row in (l):(n-l)
        partialPivot(matrix_dict, vector, row+l, row)
        pivot = matrix_dict[row][row]
        if pivot != 0
            divideRow(matrix_dict, vector, row, pivot)

            for target_row in row+1:min(n, row+l)
                if haskey(matrix_dict[target_row], row)
                    factor = matrix_dict[target_row][row]
                    subtractMultipleOfRow(matrix_dict, vector, row, target_row, factor)
                end
            end
        end
    end
    gaussEliminationLastLRowsWithPartialPivoting(matrix_dict, vector, n, l)
    solution = backwardSubstitution(matrix_dict, vector, n)

    return solution, matrix_dict
end

function gaussEliminationLastLRowsWithPartialPivoting(matrix_dict, vector, n, l)
    for row in (n-l+1):n
        partialPivot(matrix_dict, vector, n, row)
        pivot = matrix_dict[row][row]
        if pivot != 0
            divideRow(matrix_dict, vector, row, pivot)

            for target_row in row+1:n
                if haskey(matrix_dict[target_row], row)
                    factor = matrix_dict[target_row][row]
                    subtractMultipleOfRow(matrix_dict, vector, row, target_row, factor)
                end
            end
        end
    end
end

function fillMatrixesWithoutPivoting1(L, U, start, stop)
    # Proces tworzenia macierzy U i L
    for row in start:stop
        pivot = U[row][row]

        # Aktualizacja U oraz tworzenie L
        for target_row in (row+1):stop
            if haskey(U[target_row], row)
                L[target_row][row] = U[target_row][row] / pivot
                
                for (col, value) in U[row]
                    if col >= row
                        if haskey(U[target_row], col)
                            U[target_row][col] -= L[target_row][row] * value
                            if U[target_row][col] == 0.0
                                delete!(U[target_row], col)  # Usuwanie kluczy o wartościach zerowych
                            end
                        else
                            U[target_row][col] = -L[target_row][row] * value
                            if U[target_row][col] == 0.0
                                delete!(U[target_row], col)  # Usuwanie kluczy o wartościach zerowych
                            end
                        end
                    end
                end
            end
        end        
    end
end

function fillMatrixesWithoutPivoting2(L, U, start, stop, l)
    # Proces tworzenia macierzy U i L
    for row in start:stop
        pivot = U[row][row]
        i=0
        # Aktualizacja U oraz tworzenie L
        for target_row in (row+1):row+l-i
            if haskey(U[target_row], row)
                L[target_row][row] = U[target_row][row] / pivot
                
                for (col, value) in U[row]
                    if col >= row
                        if haskey(U[target_row], col)
                            U[target_row][col] -= L[target_row][row] * value
                            if U[target_row][col] == 0.0
                                delete!(U[target_row], col)  # Usuwanie kluczy o wartościach zerowych
                            end
                        else
                            U[target_row][col] = -L[target_row][row] * value
                            if U[target_row][col] == 0.0
                                delete!(U[target_row], col)  # Usuwanie kluczy o wartościach zerowych
                            end
                        end
                    end
                end
            end
            i  = i + 1
        end        
    end
end

function LUdecompositionWithoutPivoting(matrix_dict, n, l)
    L = Dict{Int, Dict{Int, Float64}}()

    # Inicjalizacja L
    for i in 1:n
        L[i] = Dict{Int, Float64}(i => 1.0)
    end

    fillMatrixesWithoutPivoting1(L, matrix_dict, 1, l)
    fillMatrixesWithoutPivoting2(L, matrix_dict, l, n-l, l)
    fillMatrixesWithoutPivoting1(L, matrix_dict, n-l+1, n)   

    return L, matrix_dict
end

function fillMatrixesWithPivoting1(L, U, vector, start, stop)
    # Proces tworzenia macierzy U i L
    for row in start:stop
        partialPivot(U, vector, stop, row)
        pivot = U[row][row]

        # Aktualizacja U oraz tworzenie L
        for target_row in (row+1):stop
            if haskey(U[target_row], row)
                L[target_row][row] = U[target_row][row] / pivot
                
                for (col, value) in U[row]
                    if col >= row
                        if haskey(U[target_row], col)
                            U[target_row][col] -= L[target_row][row] * value
                            if U[target_row][col] == 0.0
                                delete!(U[target_row], col)  # Usuwanie kluczy o wartościach zerowych
                            end
                        else
                            U[target_row][col] = -L[target_row][row] * value
                            if U[target_row][col] == 0.0
                                delete!(U[target_row], col)  # Usuwanie kluczy o wartościach zerowych
                            end
                        end
                    end
                end
            end
        end        
    end
end

function fillMatrixesWithPivoting2(L, U, vector, start, stop, l)
    # Proces tworzenia macierzy U i L
    for row in start:stop
        partialPivot(U, vector, row+l, row)
        pivot = U[row][row]
        i = 0
        # Aktualizacja U oraz tworzenie L
        for target_row in (row+1):row+l
            if haskey(U[target_row], row)
                L[target_row][row] = U[target_row][row] / pivot
                
                for (col, value) in U[row]
                    if col >= row
                        if haskey(U[target_row], col)
                            U[target_row][col] -= L[target_row][row] * value
                            if U[target_row][col] == 0.0
                                delete!(U[target_row], col)  # Usuwanie kluczy o wartościach zerowych
                            end
                        else
                            U[target_row][col] = -L[target_row][row] * value
                            if U[target_row][col] == 0.0
                                delete!(U[target_row], col)  # Usuwanie kluczy o wartościach zerowych
                            end
                        end
                    end
                end
            end
        end
        i = i + 1        
    end
end

function LUdecompositionWithPivoting(matrix_dict, vector, n, l)
    L = Dict{Int, Dict{Int, Float64}}()

    # Inicjalizacja L
    for i in 1:n
        L[i] = Dict{Int, Float64}(i => 1.0)
    end

    fillMatrixesWithPivoting1(L, matrix_dict, vector, 1, l)
    fillMatrixesWithPivoting2(L, matrix_dict, vector, l, n-l, l)
    fillMatrixesWithPivoting1(L, matrix_dict, vector, n-l+1, n)   

    return L, matrix_dict, vector
end

function multiplyMatrixByVector(matrix_dict, vector)
    n = length(vector)
    result = zeros(Float64, n)

    for row in 1:n
        sum = 0.0
        if haskey(matrix_dict, row)
            for (col, value) in matrix_dict[row]
                if col <= n
                    sum += value * vector[col]
                end
            end
        end
        result[row] = sum
    end

    return result
end

function relativeError(vector_a, vector_b)
    # Obliczanie różnicy wektorów
    diff = vector_a - vector_b

    # Obliczanie normy euklidesowej różnicy i normy euklidesowej wektora odniesienia
    norm_diff = norm(diff)
    norm_ref = norm(vector_b)

    # Zwracanie błędu względnego
    return norm_diff / norm_ref
end

function forwardSubstitution(L, b, n)
    y = zeros(n)
    for i in 1:n
        sum = 0.0
        for j in keys(L[i])
            sum += L[i][j] * y[j]
        end
        y[i] = b[i] - sum
    end
    return y
end

function backwardSubstitution(U, y, n)
    x = zeros(n)
    for i in n:-1:1
        sum = 0.0
        for j in keys(U[i])
            sum += U[i][j] * x[j]
        end
        x[i] = (y[i] - sum) / U[i][i]
    end
    return x
end

function solveLU(L, U, b, n)
    y = forwardSubstitution(L, b, n)
    x = backwardSubstitution(U, y, n)
    return x
end

end