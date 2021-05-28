function allowedRows(perm, domain)
    rows = []
    for i in 1:9
        allowed = true
        for j in 1:9
            if domain[i,j,perm[j]] != true
                allowed = false
                break
            end
        end
        if allowed == true
            push!(rows, i)
        end
    end
    return rows
end

# permutationEligibility checks for each row if every possible permutation is eligible
function permutationEligibility(domain)
    perms = collect(permutations([1,2,3,4,5,6,7,8,9]))
    allowedPerms = [Vector{UInt32}() for i in 1:9]
    cnt = 0
    for perm in perms
        cnt += 1
        allowed = allowedRows(perm, domain)
        for a in allowed
            push!(allowedPerms[a], cnt)
        end
    end
    println("Before elimination")
    for i in 1:9 
        println("Possible permutations for row number ", i, " : ", length(allowedPerms[i]))
    end
    finalPerms = eliminateRows(perms, allowedPerms)
    println("After elimination")
    for i in 1:9 
        println("Possible permutations for row number ", i, " : ", length(finalPerms[i]))
    end
    return perms, finalPerms
end
# compareRows(newRow, row, puzzle[j], j, perms)
function eliminateRows(perms, allowedPerms)
    eliminations = 0
    eliminatedPerms = [Vector{UInt32}() for i in 1:9]
    for i in 1:9
        for p in allowedPerms[i]
            pass = true
            for j in 1:9
                combination = false
                if i != j
                    for pp in allowedPerms[j]
                        if compareRows(p, i, pp, j, perms) == 0
                            combination = true
                            break
                        end
                    end
                    if combination == false
                        pass = false
                        break
                    end
                end
            end
            if pass == true
                push!(eliminatedPerms[i], p)
            else
                eliminations += 1
            end
        end
    end
    if eliminations == 0
        return eliminatedPerms
    else
        return eliminateRows(perms, eliminatedPerms)
    end
end

# findDomain reduces the domain for each position
function findDomain(sudoku)
    domain = Dict{Tuple{UInt8,UInt8,UInt8},Bool}()
    for i in 1:9, j in 1:9, z in 1:9
        domain[i,j,z] = true
    end
    for i in 1:9
        for j in 1:9
            number = sudoku[i,j]
            if number != 0
                # allow only this number in this cell
                for z in 1:9
                    if z != number
                        domain[i,j,z] = false
                    end
                end 
                # ban this number from row
                for row in 1:9
                    if row != i
                        domain[row,j,number] = false
                    end
                end
                # ban this number from column
                for column in 1:9
                    if column != j
                        domain[i,column,number] = false
                    end
                end
                # ban this number from quadrant
                for row in 1:9, column in 1:9
                    if ((row - 1)   ÷  3 == (i - 1)  ÷  3) && ((column - 1)  ÷  3 == (j - 1) ÷  3) 
                        if !(row == i && column == j)
                            domain[row,column,number] = false
                        end
                    end
                end
            end 
        end
    end
    for i in 1:9, j in 1:9
        print("Domain for cell ", i, " - ", j, " : ")
        for z in 1:9 
            if domain[i,j,z] == true
                print(z, " ")
            end
        end
        println()
    end
    return domain
end