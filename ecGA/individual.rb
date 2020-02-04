# -*- coding: utf-8 -*-

class Individual
	attr_accessor :chrom, :fitness
	
	def initialize
		@chrom = []
		@fitness = nil
	end

	def clone_ind(_ind)
		ind = _ind.clone
		ind.chrom = _ind.chrom.clone
		ind.fitness = _ind.fitness
		return ind
	end
end