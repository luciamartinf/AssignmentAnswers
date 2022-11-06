class HybridCross

    attr_accessor :parent1
    attr_accessor :parent2 
    attr_accessor :f2_wild
    attr_accessor :f2_p1
    attr_accessor :f2_p2
    attr_accessor :f2_p1p2
    @@header = ["Parent1\tParent2\tF2_Wild\tF2_P1\tF2_P2\tF2_P1P2"]
    @@all = []

    def initialize (parent1: 'A000', parent2: 'B000', f2_wild: 90, f2_p1: 30, f2_p2: 30, f2_p1p2: 10)
        
        @parent1 = parent1
        @parent2 = parent2
        @f2_wild = f2_wild
        @f2_p1 = f2_p1
        @f2_p2 = f2_p2
        @f2_p1p2 = f2_p1p2
        @@all << self

    end

    def HybridCross.new_from_hash(line)

        parent1 = line.fetch("parent1")
        parent2 = line.fetch("parent2")
        f2_wild = line.fetch("f2_wild").to_f
        f2_p1 = line.fetch("f2_p1").to_f
        f2_p2 = line.fetch("f2_p2").to_f
        f2_p1p2 = line.fetch("f2_p1p2").to_f

        return HybridCross.new(parent1: parent1, parent2: parent2, f2_wild: f2_wild, f2_p1: f2_p1, f2_p2: f2_p2, f2_p1p2: f2_p1p2)

    end

    def to_s
        return "#{parent1}, #{parent2}, #{f2_wild}, #{f2_p1}, #{f2_p2}, #{f2_p1p2}"
    end

    def HybridCross.get_header
        return @@header
    end

    def HybridCross.get_all
        return @@all
    end

    def HybridCross.get_crosses(p1) 
        # https://learn.co/lessons/ruby-advanced-class-methods-readme
        cross1 = @@all.find{|c| c.parent1 == p1 } 
        cross2 = @@all.find{|c| c.parent2 == p1 }
        return cross1, cross2
    end

    def HybridCross.get_cross(p1,p2) 
        # https://learn.co/lessons/ruby-advanced-class-methods-readme
        return @@all.find{|c| (c.parent1 == p1 && c.parent2 == p2) || (c.parent1 == p2 && c.parent2 == p1) } 
    end



    def chi_square # instance method to calculate ChiSquare

        total = f2_wild + f2_p1 + f2_p2 + f2_p1p2
        e_f2_wild = total * 9/16
        e_f2_p1 = total * 3/16
        e_f2_p2 = total * 3/16
        e_f2_p1p2 = total * 1/16


        chi2 = ((f2_wild - e_f2_wild)**2)/e_f2_wild + ((f2_p1 - e_f2_p1)**2)/e_f2_p1 + ((f2_p2 - e_f2_p2)**2)/e_f2_p2 + ((f2_p1p2 - e_f2_p1p2)**2)/e_f2_p1p2

        # The degree of freedom is 3 (= number_phen-1)
        # When df = 3, a value of greater than 7.815 is required for results to be considered statistically significant (p < 0.05)

        #if chi2 > 7.815
            #puts "ChiSquare is #{chi2}"
            #puts "#{parent1} is genetically linked to #{parent2}"
            
        #end

        return chi2, parent1, parent2

    end

end