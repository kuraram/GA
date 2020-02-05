# -*- coding: utf-8 -*-

require "./individual.rb"
require "./global.rb"
require "./randomnumber"
require "./fitness"
require "./linckage"

class Genetic
	attr_accessor :seed, :individuals, :p, :flag

	def initialize(seed)
		@seed = seed    # seed値
		@individuals = []   # 全固体を格納
		@tournaments = []		# トーナメントで勝ち上がった100個体を格納
		@p = [] # Probabilityを格納
		@flag = false # 終了条件
		@min_linckage = nil
	end

	def Genetic()

		Initialization()	# 第一世代の個体と初期確率ベクトルを生成

		for i in 1..END_GENERATION do

			fitness = []
			@individuals.each do | ind |	# 全固体の適応度の計算
				ind.fitness = FitnessFunc(ind.chrom)
				fitness << ind.fitness
			end
			puts ("#{i}世代目: 最高値#{fitness.max}")

			#TournamentSlection()	# トーナメント選択で勝ち上がった個体を格納
			UpperSelection()
			#puts "#{@tournaments}"
			MPMSearch()	# MPM
			CreateIndividuals()	# 新世代の個体を生成			

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
				@seed -= 111
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

		@tournaments.clear	# 初期化
		for i in 1..TOURNAMENT_TIME do # 100回トーナメント選択同等の行為を行う

			for j in 1..TOURNAMENT_SIZE do	# 10回戦のトーナメントを実行
				random = (INDIVIDUAL_NUM * RandomNumber(@seed)).floor
				@seed -= 111
				
				if j == 1
					max_fitness = @individuals[random].fitness
					max_ind = @individuals[random]
				elsif max_fitness <= @individuals[random].fitness
					max_fitness = @individuals[random].fitness
					max_ind = @individuals[random]
				end
			end
			#puts "#{max_ind.fitness}"

			@tournaments |= [max_ind]
		end

	end

	def MPMSearch

		initial_model = []	# 最初のモデル
		for i in 0..(GENE_NUM-1)
			initial_model << [i]
		end

		linckage = Linckage.new(initial_model, @tournaments)
		linckages = Hash.new{|hash, key| hash[key] = []}
		step_min_c_c = Hash.new # step毎のc_cの最小値を格納

		step = 1
		linckages[step] << linckage	# stepごとにリンケージを管理

		while true

			i = 0
			linckages[step] = linckages[step].sort_by do | linckage |	# c_cの昇順にソート
				[linckage.c_c, i+=1]
			end

			if step == 1
				min_linckage = linckages[step][0]
				step_min_c_c[step] = min_linckage.c_c
				#puts "Step. #{step} : Minimal c_c #{min_linckage.c_c}"
				#puts " c_m #{min_linckage.c_m},  c_p #{min_linckage.c_p}"
				#puts "Optimal Model : #{min_linckage.model}"
				#puts "Linckage ::::\n #{min_linckage.MD}"
			elsif linckages[step][0].c_c < min_linckage.c_c	# 前のステップのc_cが次のステップのc_cより大きい時
				min_linckage = linckages[step][0]
				step_min_c_c[step] = linckages[step][0].c_c
			elsif linckages[step][0].c_c > min_linckage.c_c	# 次のステップのc_cが前のステップのc_cより大きい時
				puts "Find minimal"
				puts "Step. #{step} : Minimal c_c #{min_linckage.c_c}"
				puts " c_m #{min_linckage.c_m},  c_p #{min_linckage.c_p}"
				puts "Optimal Model : #{min_linckage.model}"
				puts "Linckage ::::\n #{min_linckage.MD}"
				@min_linckage = min_linckage
				break
			end
			puts "Step. #{step} : Minimal c_c #{step_min_c_c[step]}"
			#puts "#{min_linckage.model}"

			step += 1
			# 新しいモデル候補の作成
			pre_model = min_linckage.model.clone
			next_models = []
			#puts "#{pre_model}"
			
			k = 1
			for i in 0..(pre_model.size - 2) do
				k += 1
				for j in k..(pre_model.size - 1) do
					new_model = pre_model.clone
					new_model.delete(pre_model[i])
					new_model.delete(pre_model[j])
					tmp = []
					tmp |= pre_model[i]
					tmp |= pre_model[j]
					#puts "#{tmp}"
					new_model.unshift(tmp)
					#puts "#{new_model}"
					linckage = Linckage.new(new_model, @tournaments)
					linckages[step] << linckage
				end
			end

		end
	
	end

	def CreateIndividuals()

		@individuals.clear	# 前世代の個体を削除
		size = @tournaments.size

		for i in 1..INDIVIDUAL_NUM do	# 第１世代の個体を生成
			ind = Individual.new

			#puts "#{@min_linckage.MD}"
			@min_linckage.MD.each do | elm, hash |
				#puts "====="
				#puts "#{elm}"
				#puts "#{hash}"
				random = RandomNumber(@seed)
				@seed -= 111
				total = 0
				used_pattern = []

				#puts "#{hash}"
				hash.each do | pattern, count |	# どのパターンを採用するかを決める
					used_pattern = pattern.clone
					total += count.quo(size).to_f
					break if random <= total
				end
				#puts "#{total}"
				#puts "#{used_pattern}"

				elm.each do | position |	# 生成
					ind.chrom[position] = used_pattern.shift
				end

				#puts "#{ind.fitness}"
			end

			@individuals << ind
		end

	end

	def UpperSelection	# 最強１０個

		@tournaments.clear	# 初期化
		i = 0
		@individuals = @individuals.sort_by do | ind |
			[ind.fitness, i+=1]
		end

		for i in 1..GET_SIZE do
			clone_ind = Individual.new
			clone_ind = clone_ind.clone_ind(@individuals[-1*i])
			@tournaments << clone_ind
			#puts "#{@tournaments[i-1].fitness}"
		end

	end

end