# -*- coding: utf-8 -*-

require "./individual.rb"
require "./global.rb"


class Genetic
    attr_accessor :seed, :individuals, :p

    def initialize(seed)
        @seed = seed    # seed値
        @individuals = []   # 全固体を格納
        @p = [] # Probabilityを格納
    end

    def Genetic()

    end

end

