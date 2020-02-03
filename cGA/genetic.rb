# -*- coding: utf-8 -*-

require "./individual.rb"
require "./global.rb"
require "./randomnumber"


class Genetic
	attr_accessor :seed, :individuals, :p

	def initialize(seed)
		@seed = seed    # seed値
		@individuals = []   # 全固体を格納
		@p = [] # Probabilityを格納
	end

	def Genetic()

		Initialization()

	end

	def Initialization()
		
		for i in 1..INDIVIDUAL_NUM do	# 第１世代の個体を生成
			ind = Individual.new
			for j in 0..(GENE_NUM-1) do
				ind.chrom[j] = (1.999999 * RandomNumber()).floor;
			end
			@individuals << ind
		end
		
		for i in 0..(INDIVIDUAL_NUM-1) do	# 初期確率ベクトルの生成
			@p[i] = 0.5
		end
		
	end

end

