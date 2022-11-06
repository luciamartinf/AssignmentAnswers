class Gene

    attr_accessor :gene_id
    attr_accessor :gene_name
    attr_accessor :mutant_phenotype
    @@header = ["Gene_ID\tGene_name\tMutant_Phenotype"]
    @@all = []
    @@id_name = {}

    def initialize (gene_id: 'AT0G0000', gene_name: 'abc', mutant_phenotype: "mutant phenotype")
        
        @gene_id = gene_id
        unless @gene_id =~ /A[Tt]\d[Gg]\d\d\d\d\d/
            abort "ERROR: the gene identifier #{gene_id} does not match the Arabidopsis gene_id format"
        end
        @gene_name = gene_name
        @mutant_phenotype = mutant_phenotype
        @@all << self
        @@id_name[gene_id] = gene_name

    end

    def Gene.new_from_hash(line)

        gene_id = line.fetch("gene_id")
        gene_name = line.fetch("gene_name")
        mutant_phenotype = line.fetch("mutant_phenotype")

        return Gene.new(gene_id: gene_id, gene_name: gene_name, mutant_phenotype: mutant_phenotype)

    end

    def to_s
        return "#{gene_id}\t#{gene_name}\t#{mutant_phenotype}"
    end

    def Gene.all
        return @@all
    end

    def Gene.get_header
        return @@header
    end

    def Gene.get_gene_info(id) 
        return @@all.find{|g| g.gene_id == id} # https://learn.co/lessons/ruby-advanced-class-methods-readme
    end

    def Gene.get_gene_name(id)
        name = @@id_name.fetch(id)
        return name
    end

end