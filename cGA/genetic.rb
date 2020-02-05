# -*- coding: utf-8 -*-

require "./individual.rb"
require "./global.rb"
require "./randomnumber"
require "./fitness"

class Genetic
	attr_accessor :seed, :individuals, :p, :flag

	def initialize(seed)
		@seed = seed    # seed値
		@individuals = []   # 全固体を格納
		@tournaments = []		# トーナメントで勝ち上がった100個体を格納
		@p = [] # Probabilityを格納
		@flag = false # 終了条件
	end

	def Genetic()

		Initialization()	# 第一世代の個体と初期確率ベクトルを生成

		for i in 1..END_GENERATION do

			fitness = []
			@individuals.each do | ind |	# 全固体の適応度の計算
				ind.fitness = FitnessFunc(ind.chrom)
				fitness << ind.fitness
			end
			#puts ("#{i}世代目: 最高値#{fitness.max}")
			puts ("#{fitness.max}")

			CreateFinish?()	#cGAを終了するかどうか
			return if @flag

			TournamentSlection()	# トーナメント選択で勝ち上がった個体を格納
			UpdateProbabilityVector()	# 確率ベクトルを更新
			CreateIndividuals()	# 確率ベクトルをもとに、新世代の個体を作成

		end

		return 
	end

	def Initialization()
		
		for i in 1..INDIVIDUAL_NUM do	# 第１世代の個体を生成
			ind = Individual.new
			for j in 0..(GENE_NUM-1) do
				if RandomNumber(@seed) <= 0.5
					ind.chrom[j] = 0
				else
					ind.chrom[j] = 1
				end
				@seed -= 1
			end
			@individuals << ind
		end
		
		for i in 0..(GENE_NUM-1) do	# 初期確率ベクトルの生成
			@p[i] = 0.5
		end
		
	end

	def CreateFinish?()	# 確率ベクトルが全て0か1になったら終了
		uniq = @p.uniq
		@flag = true if uniq == [1] or uniq == [0]
	end

	def TournamentSlection	# トーナメント選択で勝ち上がった100個体を格納

		@tournaments = []	# 初期化
		for i in 0..TOURNAMENT_TIME do # 100回トーナメント選択同等の行為を行う
						
			for j in 1..TOURNAMENT_SIZE do	# 10回戦のトーナメントを実行
				random = (INDIVIDUAL_NUM * RandomNumber(@seed)).floor
				@seed -= 1
				
				if j == 1
					max_fitness = @individuals[random].fitness
					max_ind = @individuals[random]
				elsif max_fitness <= @individuals[random].fitness
					max_fitness = @individuals[random].fitness
					max_ind = @individuals[random]
				end
			end

			@tournaments |= [max_ind]
		end

	end

	def UpdateProbabilityVector()
		
		i = 0
		@tournaments = @tournaments.sort_by do | ind |	# 適応度の昇順にソート
			[ind.fitness, i += 1]
		end

		winner = @tournaments[0]	# 適応度1位の個体
		loser = @tournaments[-1]	# 適応度最下位の個体
		#puts "#{winner.chrom}"
		#puts "#{loser.chrom}"

		for i in 0..(GENE_NUM-1) do
			# 確率ベクトルの更新
			if winner.chrom[i] == 0 and loser.chrom[i] == 1
				@p[i] = (@p[i]*10 - PROBABILITY_SHIFT_RATE*10) / 10
			elsif winner.chrom[i] == 1 and loser.chrom[i] == 0
				@p[i] = (@p[i]*10 + PROBABILITY_SHIFT_RATE*10) / 10
			end
		end
		#puts "#{@p}"

	end

	def CreateIndividuals

		@individuals.clear	# 前世代の個体を削除
		for i in 1..INDIVIDUAL_NUM do	# 新世代の個体を生成
			ind = Individual.new
			for j in 0..(GENE_NUM-1) do
				if RandomNumber(@seed) <= @p[j]
					ind.chrom[j] = 0
				else
					ind.chrom[j] = 1
				end
				@seed -= 1
			end
			@individuals << ind
		end
	
	end

end

