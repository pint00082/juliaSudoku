
include("genomes.jl")

function ga(config, perms, allowedPerms)
    generationSize = config["generationSize"]
    # create initial population
    generationCnt = 1
    generation = fill([], generationSize)
    generationEvaluation = zeros(generationSize)

    Threads.@threads for i in 1:generationSize
        generation[i] = createSudoku(allowedPerms)
        generationEvaluation[i] = evaluateSudoku(generation[i], perms)
    end      

    generationSum = 0  
    for i in 1:generationSize
        if generationEvaluation[i] == 0
            return generation[i]
        end
        generationSum += generationEvaluation[i]
    end
    generationMean = generationSum / generationSize
    println("Generation: ", generationCnt, " Mean: ", generationMean)
    
    rateSum = config["crossoverRate"] + config["surviveRate"] + config["newRate"] + config["evolveRate"] + config["mutateRate"]
    # Next generations
    while true
        generationCnt += 1

        nextGeneration = fill([], generationSize)
        nextGenerationEvaluation = zeros(generationSize)
        
        Threads.@threads for i in 1:generationSize
            randomManipulation = rand(1:rateSum)
            if randomManipulation <= config["crossoverRate"]
                nextGeneration[i] = crossover(generation[i], generation[rand(1:generationSize)], perms)
            elseif randomManipulation <= config["crossoverRate"] + config["surviveRate"]
                nextGeneration[i] = generation[i]
            elseif randomManipulation <= config["crossoverRate"] + config["surviveRate"] + config["newRate"] 
                nextGeneration[i] = createSudoku(allowedPerms)
            elseif randomManipulation <= config["crossoverRate"] + config["surviveRate"] + config["newRate"] + config["evolveRate"] 
                nextGeneration[i] = evolve(generation[i], allowedPerms, perms)
            else 
                nextGeneration[i] = mutate(generation[i], allowedPerms)
            end
            nextGenerationEvaluation[i] = evaluateSudoku(nextGeneration[i], perms)            
        end        

        nextGenerationSum = 0
        for i in 1:generationSize
            if nextGenerationEvaluation[i] == 0
                println("Solved in generation: ", generationCnt)
                return nextGeneration[i]
            end
            nextGenerationSum += nextGenerationEvaluation[i] 
        end
        nextGenerationMean = nextGenerationSum / generationSize
        

        if nextGenerationMean < generationMean
            generation = nextGeneration
            generationMean = nextGenerationMean
            println("Generation: ", generationCnt, " Mean: ", nextGenerationMean)
        end
    end

end