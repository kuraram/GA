require "./genetic"

if ARGV[0] == nil
    seed = 9999999999999
else
    seed = ARGV[0].to_i
end

genetic = Genetic.new(seed)
genetic.Genetic()

return