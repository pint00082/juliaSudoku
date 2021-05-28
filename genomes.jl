function createSudoku(allowedPerms)
    puzzle = zeros(UInt32, 9)
    for i in 1:9
        puzzle[i] = allowedPerms[i][rand(1:length(allowedPerms[i]))]
    end
    return puzzle
end

function crossover(sudokuA, sudokuB, perms)
    puzzle = zeros(UInt32, 9)
    order = shuffle(1:9)
    puzzle[order[1]] = sudokuA[order[1]]
    for o in 2:9
        i = order[o]
        sumA = 0
        sumB = 0
        for j in 1:9
            if j != i && puzzle[j] != 0
                sumA += compareRows(sudokuA[i], i, puzzle[j], j, perms)
                sumB += compareRows(sudokuB[i], i, puzzle[j], j, perms)
            end
        end
        if sumB < sumA
            puzzle[i] = sudokuB[i]
        else
            puzzle[i] = sudokuA[i]
        end
    end
    return puzzle
end

function mutate(sudoku, allowedPerms)
    puzzle = zeros(UInt32, 9)
    for i in 1:9
        puzzle[i] = sudoku[i]
    end
    i = rand(1:9)
    puzzle[i] = allowedPerms[i][rand(1:length(allowedPerms[i]))]
    return puzzle
end    

function evolve(sudoku, allowedPerms, perms)
    puzzle = zeros(UInt32, 9)
    for i in 1:9
        puzzle[i] = sudoku[i]
    end
    row = rand(1:9)
    currentSum = 0
    for j in 1:9
        if row != j
            currentSum += compareRows(puzzle[row], row, puzzle[j], j, perms)
        end
    end
    if currentSum == 0
        return puzzle
    end
    for newRow in allowedPerms[row]
        newSum = 0
        for j in 1:9
            if row != j
                newSum += compareRows(newRow, row, puzzle[j], j, perms)
            end
        end
        if newSum < currentSum
            puzzle[row] = newRow
            break
        end
    end
    return puzzle
end
    