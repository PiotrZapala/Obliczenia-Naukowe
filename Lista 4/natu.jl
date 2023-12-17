include("./module.jl")
using .Algorithms

function main() 
    
    println(naturalna([-1.0,0.0,1.0,2.0], ilorazyRoznicowe([-1.0,0.0,1.0,2.0], [-1.0,0.0,-1.0,2.0])))
end