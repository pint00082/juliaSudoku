import Combinatorics.permutations
using Random
using Distributed
import YAML

include("ui.jl")
include("eval.jl")
include("domain.jl")
include("ga.jl")

function main()
    # Load configuration file
    config = YAML.load_file("config.yml")
    while true
        # Select sudoku puzzle
        sudoku = selectFile(0)
        printSudoku(sudoku) 
        # Find eligible rows for selected puzzle
        domain = findDomain(sudoku)
        perms, allowedPerms = permutationEligibility(domain)
        # Run genetic algorithm for selected puzzle
        solution = ga(config, perms, allowedPerms)
        # Print solution
        printPuzzle(solution, perms)
    end
end


main()