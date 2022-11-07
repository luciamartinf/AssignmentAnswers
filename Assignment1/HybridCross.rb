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
        
        """
        Definition of initialize method
        """

        @parent1 = parent1
        @parent2 = parent2
        @f2_wild = f2_wild.to_f     # needs to be a float number
        @f2_p1 = f2_p1.to_f         # needs to be a float number
        @f2_p2 = f2_p2.to_f         # needs to be a float number
        @f2_p1p2 = f2_p1p2.to_f     # needs to be a float number
        @@all << self               # add current instance to array

    end

    def HybridCross.new_from_hash(line)

        """
        Class method to create an instance from hash
        """

        parent1 = line.fetch("parent1")
        parent2 = line.fetch("parent2")
        f2_wild = line.fetch("f2_wild")
        f2_p1 = line.fetch("f2_p1")
        f2_p2 = line.fetch("f2_p2")
        f2_p1p2 = line.fetch("f2_p1p2")

        # returns calling initialize method 
        return HybridCross.new(parent1: parent1, parent2: parent2, f2_wild: f2_wild, f2_p1: f2_p1, f2_p2: f2_p2, f2_p1p2: f2_p1p2)

    end

    def to_s
        """
        Instance method to retrieve the current instance as a string. 
        Records are separated by tabs
        """
        return "#{parent1}, #{parent2}, #{f2_wild}, #{f2_p1}, #{f2_p2}, #{f2_p1p2}"
    end

    def HybridCross.get_header
        """
        Class method to retrieve class header
        """
        return @@header
    end

    def HybridCross.get_all
        """
        Class method to retrieve all instances from the class. 
        The format is defined by the to_s method
        """
        return @@all
    end

    def HybridCross.get_crosses(p1) 
        """
        Class method to retrieve all crosses performed with a given seed
        """ 
        cross1 = @@all.find{|c| c.parent1 == p1 } 
        cross2 = @@all.find{|c| c.parent2 == p1 }
        return cross1, cross2
    end

    def HybridCross.get_cross(p1,p2) 
        """
        Class method to retrieve the cross between two given seeds
        """ 
        return @@all.find{|c| (c.parent1 == p1 && c.parent2 == p2) || (c.parent1 == p2 && c.parent2 == p1) } 
    end

    def chi_square 
        
        """
        Instance method to calculate ChiSquare
        """

        total = f2_wild + f2_p1 + f2_p2 + f2_p1p2
        e_f2_wild = total * 9/16
        e_f2_p1 = total * 3/16
        e_f2_p2 = total * 3/16
        e_f2_p1p2 = total * 1/16

        chi2 = ((f2_wild - e_f2_wild)**2)/e_f2_wild + ((f2_p1 - e_f2_p1)**2)/e_f2_p1 + ((f2_p2 - e_f2_p2)**2)/e_f2_p2 + ((f2_p1p2 - e_f2_p1p2)**2)/e_f2_p1p2

        return chi2, parent1, parent2

    end

end