#Autor: Piotr Zapała
module Utils

using DataStructures
using DelimitedFiles
using Printf

export loadFile, printMatrix

function printMatrix(matrix_dict, size_of_matrix)
    for row in 1:size_of_matrix
        for col in 1:size_of_matrix
            row_dict = matrix_dict[row]
            if haskey(row_dict, col)
                value = row_dict[col]
                if value < 0
                    formatted_value = @sprintf("%.4f", value)
                    print(" ($formatted_value)")
                else
                    formatted_value = @sprintf("%.5f", value)
                    print(" ($formatted_value)")  
                end              
            else
                print("   0.0000")
            end
        end
        println()
    end
end

function loadFile(filename1, filename2)
    matrix_dict = SortedDict{Int, SortedDict{Int, Float64}}()
    vector = Float64[]
    size_of_matrix = 0
    size_of_nested_matrixes = 0

    open(filename1) do file
        line = readline(file)
        values = split(line)
        size_of_matrix = parse(Int, values[1])
        size_of_nested_matrixes = parse(Int, values[2])

        for line in eachline(file)
            values = split(line)
            i = parse(Int, values[1])
            j = parse(Int, values[2])
            value = parse(Float64, values[3])

            if haskey(matrix_dict, i)
                matrix_dict[i][j] = value
            else
                matrix_dict[i] = SortedDict{Int, Float64}(j => value)
            end
        end
    end

    open(filename2) do file
        readline(file)
        for line in eachline(file)
            value = parse(Float64, line)
            push!(vector, value)
        end
    end
    
    return matrix_dict, vector, size_of_matrix, size_of_nested_matrixes
end

end