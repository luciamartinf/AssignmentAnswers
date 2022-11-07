class Gene

    attr_accessor :gene_id
    attr_accessor :gene_name
    attr_accessor :mutant_phenotype
    @@header = ["Gene_ID\tGene_name\tMutant_Phenotype"]
    @@all = []
    @@id_name = {}

    def initialize (gene_id: 'AT0G0000', gene_name: 'abc', mutant_phenotype: "mutant phenotype")
        
        @gene_id = gene_id
        unless @gene_id =~ /A[Tt]\d[Gg]\d\d\d\d\d/      # check that gene_id has Atabidopsis' format
            abort "ERROR: the gene identifier #{gene_id} does not match the Arabidopsis gene_id format"
        end
        @gene_name = gene_name
        @mutant_phenotype = mutant_phenotype
        @@all << self                                   # add current instance to array
        @@id_name[gene_id] = gene_name                  # add current seed_stock => mutant_gene_id to hash

    end

    def Gene.new_from_hash(line)

        """
        Class method to create an instance from hash
        """

        gene_id = line.fetch("gene_id")
        gene_name = line.fetch("gene_name")
        mutant_phenotype = line.fetch("mutant_phenotype")

        # returns calling initialize method 
        return Gene.new(gene_id: gene_id, gene_name: gene_name, mutant_phenotype: mutant_phenotype)

    end

    def to_s
        """
        Instance method to retrieve the current instance as a string. 
        Records are separated by tabs
        """
        return "#{gene_id}\t#{gene_name}\t#{mutant_phenotype}"
    end

    def Gene.get_header
        """
        Class method to retrieve class header
        """
        return @@header
    end

    def Gene.get_all
        """
        Class method to retrieve all instances from the class. 
        The format is defined by the to_s method
        """
        return @@all
    end

    def Gene.get_gene_info(id) 
        """
        Class method to retrieve the whole instance with the seed_stock
        """ 
        return @@all.find{|g| g.gene_id == id}
    end

    def Gene.get_gene_name(id)
        """
        Class method to retrieve the name of the given gene identificator
        """
        name = @@id_name.fetch(id)
        return name
    end

end