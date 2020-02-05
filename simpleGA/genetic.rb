# -*- coding: utf-8 -*-

require "./individual"
require "./global"
require "./randomnumber"
require "./fitness"

class Genetic
	attr_accessor :seed, :individuals, :p

	def initialize(seed)
		@seed = seed    # seed値
		@individuals = []   # 全固体を格納
		@parents = []
		@children = []
		@p = [] # Probabilityを格納
	end

	def Genetic()

		Initialization()

		for i in 1..END_GENERATION do

			fitness = []
			@parents = []
			@children = []

			@individuals.each_with_index do | ind , j |
				ind.fitness = FitnessFunc(ind.chrom)
				fitness << ind.fitness
			end

			file = File.open('./result.csv', 'a')
			file.puts "#{i}, #{fitness.max}"
			file.close
			#puts "#{i}, #{fitness.max}"
			puts "#{fitness.max}"

			RouletteSelection()
			OnePointCrossover()
			BitFlipMutation()
		end
	end

	def Initialization()
		
		for i in 1..INDIVIDUAL_NUM do	# 第１世代の個体を生成
			ind = Individual.new
			for j in 0..(GENE_NUM-1) do
				ind.chrom[j] = (1.999999 * RandomNumber(@seed)).floor;
				@seed -= 111
			end
			@individuals << ind
		end

	end

#/*=================================================================*/
	def RouletteSelection()
		total = 0.0
		sub = 0.0
		rn = 0.0
		ridx = 0
		roulette = Array.new(INDIVIDUAL_NUM)

		if (OPTIMIZE_TYPE == "MAX")
			total = 0.0

			@individuals.each do | ind |
				total += (ind.fitness + 0.1)
			end

			sub = 0.0

			@individuals.each_with_index do | ind , i |
				sub += (ind.fitness + 0.1)
				roulette[i] = sub / total
				if (i == INDIVIDUAL_NUM-1)
					roulette[i] = 1.0
				end
			end
		
		elsif (OPTIMIZE_TYPE == "MIN")
			total = 0.0
			@individuals.each do | ind |
				total += 1.0 / (ind.fitness + 0.1)
			end

			sub = 0.0

			@individuals.each do | ind |
				sub += 1.0 / (ind.fitness + 0.1)
				roulette[i] = sub / total
				if (i == INDIVIDUAL_NUM - 1)
					roulette[i] = 1.0
				end
			end
		end
	
		for i in 0..(INDIVIDUAL_NUM - 1) do
			rn = RandomNumber(@seed)
			@seed -= 111

			for j in 0..(INDIVIDUAL_NUM - 1) do
				if (rn < roulette[j])
					ridx = j
					break
				end
			end

			parent = Individual.new
			child = Individual.new
			#puts "#{parent}"

			for j in 0..(GENE_NUM - 1) do
				parent.chrom << @individuals[ridx].chrom[j]
				child.chrom << nil
			end

			@parents << parent
			@children << child
		end
	end
#/*=================================================================*/
	def OnePointCrossover()

		k = 0
		xp = 0

		while k < INDIVIDUAL_NUM
			if (RandomNumber(@seed) <= CROSSOVER_RATE)
				@seed -= 111
				xp = (GENE_NUM - 0.000001) * RandomNumber(@seed)
				@seed -= 111
				for i in 0..(GENE_NUM - 1) do
					if (xp <= i)
						@children[k].chrom[i] = @parents[k].chrom[i]
						@children[k + 1].chrom[i] = @parents[k + 1].chrom[i]
					elsif (xp > i)
						@children[k].chrom[i] = @parents[k + 1].chrom[i]
						@children[k + 1].chrom[i] = @parents[k].chrom[i]
					else
						puts("Crossover is something wrong!")
					end
				end
			
			else
				@seed -= 111
				for i in 0..(GENE_NUM - 1) do
					@children[k].chrom[i] = @parents[k].chrom[i]
					@children[k+1].chrom[i] = @parents[k + 1].chrom[i]
				end
			end
			k += 2
		end
	end
#/*==================================================================*/
	def BitFlipMutation()
		rand_num = 0.0

		@children.each do | child |
			for j in 0..(GENE_NUM - 1) do
				rand_num = RandomNumber(@seed)
				@seed -= 111
				if (rand_num <= MUTATION_RATE)
					child.chrom[j] = 1.99999 * RandomNumber(@seed)
					@seed -= 111
				end
			end
		end

		@individuals.zip(@children).each do | ind , child |
			for j in 0..(GENE_NUM - 1) do
				#puts "#{ind.chrom}, #{child.chrom}"
				ind.chrom[j] = child.chrom[j]
			end
		end

	end

end
