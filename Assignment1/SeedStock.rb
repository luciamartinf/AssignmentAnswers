class SeedStock

    attr_accessor :seed_stock
    attr_accessor :mutant_gene_id
    attr_accessor :last_planted
    attr_accessor :storage
    attr_accessor :grams_remaining 
    @@header = ["Seed_Stock\tMutant_Gene_ID\tLast_planted\tStorage\tGrams_Remaining"]
    @@all = []
    @@seed_id = {}
    
    def initialize(seed_stock: 'A000', mutant_gene_id: 'AT0G0000', last_planted: "01/01/2000", storage: "cama0", grams_remaining: 50)
        
        """
        Definition of initialize method
        """

        @seed_stock = seed_stock
        @mutant_gene_id = mutant_gene_id
        @last_planted = last_planted
        @storage = storage
        @grams_remaining = grams_remaining.to_i     # needs to be an integer
        @@all << self                               # add current instance to array
        @@seed_id[seed_stock] = mutant_gene_id      # add current seed_stock => mutant_gene_id to hash
        
    end

    def SeedStock.new_from_hash(line_hash)

        """
        Class method to create an instance from hash
        """

        seed_stock = line_hash.fetch("seed_stock")
        mutant_gene_id = line_hash.fetch("mutant_gene_id")
        last_planted = line_hash.fetch("last_planted")
        storage = line_hash.fetch("storage")
        grams_remaining = line_hash.fetch("grams_remaining")
        
        # returns calling initialize method 
        return SeedStock.new(seed_stock: seed_stock, mutant_gene_id: mutant_gene_id, last_planted: last_planted, storage: storage, grams_remaining: grams_remaining)
    
    end

    def to_s
        """
        Instance method to retrieve the current instance as a string. 
        Records are separated by tabs
        """
        return "#{seed_stock}\t#{mutant_gene_id}\t#{last_planted}\t#{storage}\t#{grams_remaining}"
    end

    def SeedStock.get_header
        """
        Class method to retrieve class header
        """
        return @@header
    end

    def SeedStock.get_all
        """
        Class method to retrieve all instances from the class. 
        The format is defined by the to_s method
        """
        return @@all
    end

    def SeedStock.get_seed_stock(seed)
        """
        Class method to retrieve the whole instance with the seed_stock
        """ 
        return @@all.find{|s| s.seed_stock == seed} 
    end

    def SeedStock.get_gene_id(seed)
        """
        Class method to retrieve the id of the mutated gene in the indicated seed stock
        """
        id = @@seed_id.fetch(seed)
        return id
    end

    def plant_seeds

        """
        Instance method to plant seeds
        """

        new_remaining = @grams_remaining - 7
        today = DateTime.now.strftime("%d/%m/%Y") # Today's date defined in format: DD/MM/YYYY
        
        if new_remaining <= 0
            new_remaining = 0
            puts "WARNING: we have run out of Seed Stock #{@seed_stock}"
        end

        # Update SeedStock class
        @grams_remaining = new_remaining
        @last_planted = today

        return new_remaining

    end

end