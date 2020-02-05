# -*- coding: utf-8 -*-

require "./individual.rb"
require "./global.rb"

class Linckage
	attr_accessor :model, :c_m, :c_p, :c_c, :MD
    
	def initialize(model, tournaments)
		@model = model
		@MD = Hash.new { |hash, key| hash[key] = Hash.new } 	#周辺分布
		@c_m = CalcModelComplexity(tournaments)
		@c_p = CalcCompressedPopulationComplexity(tournaments)
		@c_c = @c_m + @c_p
	end

	def CalcModelComplexity(tournaments)
		
		total = 0
		#@model.each{ | elm | total += (elm.size * (2**(elm.size) - 1)) }	# sigmaのとこ
		@model.each{ | elm | total +=  (2**(elm.size) - 1) }
		c_m = Math.log2(INDIVIDUAL_NUM + 1) * total

		#puts "c_m : #{c_m}"
		return c_m
	end

	def CalcCompressedPopulationComplexity(tournaments)

		total = 0
		a = Hash.new
		@model.each do | elm |
			#puts "#{elm}"
			hash = GetMarginalDistribution(elm, tournaments)
			#puts "#{hash}" if elm.size > 2
			@MD[elm] = hash
			#puts "#{@MD}"
			total += GetEntropy(hash, tournaments)
			#puts "#{total}"
		end
		c_p = INDIVIDUAL_NUM * total

		#puts "c_p : #{c_p}"
		return c_p
	end

	def GetEntropy(hash, tournaments)

		total = 0
		size = tournaments.size
		#puts "#{size}"
		hash.each do | elm, count |
			p1 = count.quo(size).to_f
			p1 = 0 if p1.nan?
			p0 = 1 - p1
			#puts "#{pk}"
			total += (-1 * p1 * Math.log2(p1) -1 * p0 * Math.log2(p0))
		end

		return total
	end

	def GetMarginalDistribution(elm, tournaments)

		hash = Hash.new { |hash, key| hash[key] = 0 }
		tournaments.each do | ind |
			tmp = []
			elm.each do | position |	# あるリンケージが何個有るかをカウント
				tmp << ind.chrom[position]
			end
			hash[tmp] += 1
		end
		#puts "#{hash}" if elm.size == 3
		return hash
	end

end