require "./global"

MIN =	0
MAX = 1
OPTIMIZE_TYPE = MAX
NUM_BBS	= 20  #The best fitness is 20*4=80

def FitnessFunc(dummy)

	fitness_value = 0.to_f
	for k in 0..(NUM_BBS - 1) do
		
		tmp_add = 0
		if (dummy[k] == 1)
			tmp_add += 1
		end
		if (dummy[k+NUM_BBS] == 1)
			tmp_add += 1
		end
		if (dummy[k+2*NUM_BBS] == 1)
			tmp_add += 1
		end
		if (dummy[k+3*NUM_BBS] == 1)
			tmp_add +=1
		end

		if (tmp_add == 0)
			fitness_value += 3
		elsif (tmp_add == 1)
			fitness_value += 2
		elsif (tmp_add == 2)
			fitness_value += 1
		elsif (tmp_add == 4)
			fitness_value += 4
		end
	
	end
	return fitness_value
end