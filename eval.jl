function compareRows(rowA, rowNumA, rowB, rowNumB, perms)
    if (rowNumA - 1)  ÷  3 == (rowNumB - 1)  ÷  3
        for i in 1:9
            multiplier = (i - 1)  ÷  3
            for j in 1:3
                if perms[rowA][i] == perms[rowB][multiplier * 3 + j] 
                    return 1
                end
            end
        end
    else
        for i in 1:9
            if perms[rowA][i] == perms[rowB][i]
                return 1
            end
        end
    end
    return 0
end

function evaluateSudoku(puzzle, perms)
    penalty = 0
    for rowA in 1:9, rowB in (rowA + 1):9
        penalty += compareRows(puzzle[rowA], rowA, puzzle[rowB], rowB, perms)
    end
    return penalty
end