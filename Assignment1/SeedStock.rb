class SeedStock

    attr_accessor :seed_stock
    attr_accessor :mutant_gene_id # or Mutant_Gene_ID, no se si es mejor que compartan nombre o que no
    attr_accessor :last_planted # quiero ponerlo como date
    attr_accessor :storage
    attr_accessor :grams_remaining # quiero ponerlo como número
    @@header = ["Seed_Stock\tMutant_Gene_ID\tLast_planted\tStorage\tGrams_Remaining"]
    @@all = []
    @@seed_id = {}
    
    def initialize(seed_stock: 'A000', mutant_gene_id: 'AT0G0000', last_planted: "01/01/2000", storage: "cama0", grams_remaining: 50)
        
        @seed_stock = seed_stock
        @mutant_gene_id = mutant_gene_id
        @last_planted = last_planted
        @storage = storage
        @grams_remaining = grams_remaining
        @@all << self
        @@seed_id[seed_stock] = mutant_gene_id
        
    end

    def SeedStock.new_from_hash(line)

        seed_stock = line.fetch("seed_stock")
        mutant_gene_id = line.fetch("mutant_gene_id")
        last_planted = line.fetch("last_planted")
        storage = line.fetch("storage")
        grams_remaining = line.fetch("grams_remaining").to_i
        
        return SeedStock.new(seed_stock: seed_stock, mutant_gene_id: mutant_gene_id, last_planted: last_planted, storage: storage, grams_remaining: grams_remaining)
    
    end

    def to_s
        return "#{seed_stock}\t#{mutant_gene_id}\t#{last_planted}\t#{storage}\t#{grams_remaining}"
    end

    def SeedStock.get_header
        return @@header
    end

    def SeedStock.get_all
        return @@all
    end

    def SeedStock.get_seed_stock(seed) 
        return @@all.find{|s| s.seed_stock == seed} # https://learn.co/lessons/ruby-advanced-class-methods-readme
    end

    def SeedStock.get_gene_id(seed)
        id = @@seed_id.fetch(seed)
        return id
    end

    def plant_seeds
        new_remaining = grams_remaining - 7
        today = DateTime.now.strftime("%d/%m/%Y")
        
        if new_remaining <= 0
            new_remaining = 0
            puts "WARNING: we have run out of Seed Stock #{@seed_stock}"
        end

        @grams_remaining = new_remaining
        @last_planted = today

        return new_remaining
    end

end