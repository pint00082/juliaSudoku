# printSudoku prints a sudoku in the cmd
function printSudoku(sudoku)
    for i in 1:9
        for j in 1:9
            num = sudoku[i,j]
            if num == 0
                print("_", " ")
            else
                print(sudoku[i,j], " ")
            end
        end
        println()
    end
end

function printPuzzle(puzzle, perms)
    sudoku = zeros(UInt8, (9, 9))
    for i in 1:9,j in 1:9
        sudoku[i,j] = perms[puzzle[i]][j]
    end
    printSudoku(sudoku)
end

# ui asks the user which puzzle to solve
function ui(maxNumber)
    selection = 0
    while selection == 0
        println("Select difficulty 1 - ", maxNumber, " : ")
        selection = parse(UInt16, readline())
        if selection < 1 || selection > maxNumber
            selection = 0
        end
    end
    return selection
end

# selectFile lets the user to select a puzzle
function selectFile(default)
    lines = readlines("learningcurve.sdm")
    if default == 0
        selection = ui(length(lines))
    else
        selection = default
    end
    selectedLine = lines[selection]
    sudoku = zeros(UInt8, 9, 9)
    ind = 1
    for i in 1:9
        for j in 1:9
            sudoku[i,j] = parse(UInt8, selectedLine[ind])
            ind += 1
        end
    end
    return sudoku
end