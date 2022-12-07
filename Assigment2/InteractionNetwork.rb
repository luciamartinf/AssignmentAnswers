require './Annotation'

# == InteractionNetwork
#
# Class to represent an interaction network between genes from a list.
# Contains the functions to look for the interactions, create the network, get a list with all the genes,
# get a list with the genes in the list and get the GO and KEGG annotations for the genes in the network
#
# == Summary
# 
# This can be used to find interactions networks between genes from a list.
#
class InteractionNetwork

    # Get/Set the starting gene to create the network
    # @!attribute [rw]
    # @return [String] The gene id
    attr_accessor :id

    # Get/Set the gene list upon which the network will be/was created
    # @!attribute [rw]
    # @return [Array<String>] The Gene list
    attr_accessor :genelist

    # Get/Set the network
    # @!attribute [rw]
    # @return [Array<String, String>] The network
    attr_accessor :network

    # Get/Set all genes in the network
    # @!attribute [rw]
    # @return [Array<String>] The genes from the network
    attr_accessor :genes_network

    # Get/Set all the genes that are both in the gene list and the network
    # @!attribute [rw]
    # @return [Array<String>] The genes from the network included in the list 
    attr_accessor :my_genes

    # Get/Set the KEGG annotations for all genes in the network
    # @!attribute [rw]
    # @return [Hash<String, String>] The KEGG annotations {Kegg id => pathway name}
    attr_accessor :kegg_annotations

    # Get/Set the GO annotations for all genes in the network
    # @!attribute [rw]
    # @return [Hash<String, String>] The GO annotations {GO id => biological process}
    attr_accessor :go_annotations
    
    #
    # Create a new instance of InteractionNetwork
    #
    # @param id [String] the id of the starting gene as a String
    # @param genelist [Array<String>] the list of genes of as an Array
    # @return [Network] an instance of InteractionNetwork
    #
    def initialize(id:, genelist:)
        @id = id
        @genelist = genelist
        @network = []
        @genes_network = []
        @my_genes = []
        @go_annotations = {}
        @kegg_annotations = {}

    end

    #
    # Get interactions of a gene
    #
    # @param id [String] the id of the gene as a String
    # @param cutoff [Numeric] the cutoff for the score of the interaction as a Number. If no cutoff is given, the default value is 0.45 (medium confidence)
    # @return [Array<String>] the new genes list of genes that can be added to the interaction network as an Array
    #
    def get_interaction(gene_id, cutoff=0.45)
        new_genes = []
        response = Annotation.fetch(url:"http://www.ebi.ac.uk/Tools/webservices/psicquic/intact/webservices/current/search/interactor/#{gene_id}?format=tab25")
        if response # if fetch was successful
            unless response.body.empty?
                response.body.each_line do |line|
                    fields = line.split("\t")
                    # fields 9 and 10 contain the species
                    next unless fields[9] =~ /taxid:3702/ && fields[10] =~ /taxid:3702/ # Filtering by species, taxid:3702 is Arabidopsis thaliana
                    # fields 14 contains the mi-score
                    matchscore = fields[14].split(":")[1] # to get only the numeric part of the score
                    score = matchscore.to_f # transform the score to float number
                    next unless score >= cutoff # Filtering by score >= cutoff
                    int_genes = []
                    # fields 4 and 5 contain the interacting genes
                    matchgene1 = fields[4].match(/uniprotkb:([Aa][Tt]\w[Gg]\d\d\d\d\d)/)
                    matchgene2 = fields[5].match(/uniprotkb:([Aa][Tt]\w[Gg]\d\d\d\d\d)/)
                    next unless matchgene1 && matchgene2
                    gene1 = matchgene1[1].upcase
                    gene2 = matchgene2[1].upcase
                    next if gene1 == gene2 #skip if both are the same
                    next unless @genelist.include?(gene1) || @genelist.include?(gene2) # we are only interested in interactions that involve genes from our gene list
                    # adding the gene that is not the one we started with (gene_id)
                    if gene1 =~ /#{gene_id.upcase}/
                        new_genes.push(gene2)
                    elsif gene2 =~ /#{gene_id.upcase}/
                        new_genes.push(gene1)
                    end
                end
            end

        end
        return new_genes.uniq
    end

    #
    # Create Interaction Network starting with a gene id using a recursive function
    #
    # @param id [String] the id of the gene as a String
    # @return [Array<String, String>] the network list of genes that interact with each other as an Array
    #
    def create_network(gene_id) 
        genes = get_interaction(gene_id) # get the list of new genes that interact with gene id
        genes.each do |gene|
            # add the new interaction unless it had been already saved
            unless @network.include?([gene_id, gene]) || @network.include?([gene, gene_id]) 
                @network.push([gene_id,gene])
                create_network(gene) # call the function again until the condition is no longer matched
            end
        end
        return @network
    end

    #
    # Get all genes in the network as a simple Array
    #
    # @return [Array<String>] the list of genes of the network as an Array
    #
    def get_genes_network
       @genes_network = @network.flatten.uniq
    end

    #
    # Get all genes in the network that are also in the gene list as a simple Array
    #
    # @return [Array<String>] the list of genes included in both the network an the gene list as an Array
    #
    def get_genes_from_genelist
        @genes_network.each do |gene|
            if @genelist.include?(gene)
                @my_genes.push(gene)
            end
        end
        return @my_genes
    end

    #
    # Get all annotations for all genes in the network
    #
    def get_annotations
        @genes_network.each do |gene|
            new_go = Annotation.go_annotation(gene)
            @go_annotations = @go_annotations.merge(new_go)
            new_kegg = Annotation.kegg_annotation(gene)
            @kegg_annotations = @kegg_annotations.merge(new_kegg)
        end
        @go_annotations = @go_annotations.sort
        @kegg_annotations = @kegg_annotations.sort
    end

end
