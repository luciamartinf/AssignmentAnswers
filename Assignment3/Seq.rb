require 'bio'
require './FileMaster'

# == Seq
#
# Class to represent all of the information associated with a gene
# 
# Contains the functions to get the no_CTTCTT genes list, to get the bio records of embl and and sequence, 
# to get the the chromosome number and the chromosome related coordinates, to add new features to the bio sequence,
# to find the matches of the sequence in the gene exons.
#
# == Summary
# 
## This can be used to represent all the information associated with a gene
#
class Seq

    # Get/Set the id of the gene sequence
    # @!attribute [rw]
    # @return [String] The gene id
    attr_accessor :id

    # Get/Set the embl associated with a gene id
    # @!attribute [rw]
    # @return [Bio::EMBL] The bio embl record
    attr_accessor :embl

    # Get/Set the biosequence extracted from the embl
    # @!attribute [rw]
    # @return [Bio::Sequence] The bio sequence record
    attr_accessor :sequence

    # Get/Set the chromosome number in which the gene is located
    # @!attribute [rw]
    # @return [String] The chromosome number
    attr_accessor :chromosome

    # Get/Set the starting position of the chromosome in the genome
    # @!attribute [rw]
    # @return [Integer] The chromosome starting position
    attr_accessor :start_gene_chr

    # Get/Set the ending position of the chromosome in the genome
    # @!attribute [rw]
    # @return [Integer] The chromosome ending position
    attr_accessor :end_gene_chr

    # Class variable [Array<String>] 
    # Contains the genes id of the genes that don't contain any CTTCTT repeats in any of their exons
    @@no_cttctt_genes = []


    #
    # Inizialize method to create a new instance of Seq. Called with new
    #
    # @param id [String] the id of the gene as a String
    # @return [sequence] an instance of Seq
    #
    def initialize(id:)

        @id = id

    end

    #
    # Class method to get the the class variable @@no_cttctt_genes
    #
    # @return [Array<String>] The Array with all of the gene id that don't have any cttctt repeat in their exons
    #
    def self.get_no_genes

        return @@no_cttctt_genes.uniq

    end

    #
    # Instance method to obtain information for the current genes.
    #
    # Takes the instance atribute @id and 
    # saves the [Bio::EMBL] and [Bio::Sequence] created objects in its respective instance atributes @embl and @sequence
    #
    def get_bio #Obtaining gene information for the current gene (gene id)

        response = FileMaster.fetch(url:"http://www.ebi.ac.uk/Tools/dbfetch/dbfetch?db=ensemblgenomesgene&format=embl&id=#{@id}")  # Fetch EMBL file

        if response 
            @embl = Bio::EMBL.new(response.body) # Transform the EMBL file into a Bio::EMBL object and save it into @embl
            @sequence = @embl.to_biosequence  # Transforming the Bio::EMBL into Bio::Sequence object and save it into @sequence
        end

    end

    #
    # Instance method to obtain the chromose number and the chromosome relative coordinates of the gene
    #
    # Takes the @embl instance variable and 
    # saves the chromosome number and chromosome relative coordinates of the gene 
    # on its respective instance attributes @chromosome, @start_gene_chr and @end_gene_chr
    #
    def get_coords_chr

        # chromosome information is stored in the accession of the Bio::EMBL object. 
        # Accesion format: chromosome:TAIR10:5:22038165:22039568:1
        acc = @embl.accession.split(":") 
        chr = acc[2]
        start_chr = acc[3].to_i
        end_chr = acc[4].to_i

        # Save chromosome related information into its respective instance variables
        @chromosome = chr
        @start_gene_chr = start_chr
        @end_gene_chr = end_chr

    end

    #
    # Instance method to create new CTTCTT_region feature and add it to the Bio::Sequence object @sequence
    #
    # @param [String] strand "+" for forward strand, "-" for the reverse strand
    # @param [String] position_s string that stores the repeat position as "start_pos..end_pos"
    # @param [Integer] index to keep a record of all of the CTTCTT regions in the sequence
    #
    def add_new_feature(strand, position_s, index)

        new_feature = Bio::Feature.new(    # Creating new feature 
            feature = "CTTCTT_region",     # Feature name
            position = position_s,         # Position with Bio::Location format: "start_pos..end_pos"
            qualifiers = [ Bio::Feature::Qualifier.new('sequence', 'CTTCTT'),
                           Bio::Feature::Qualifier.new('strand', strand),
                           Bio::Feature::Qualifier.new('CTTCTT_id', "#{@id}.CTTCTT.#{strand}.#{index}") ] )

        @sequence.features << new_feature  # Add new_feature to Bio::Sequence object @sequence

    end

    #
    # Instance method to find every CTTCTT region in the exons of the current gene on both the + and - strands, 
    # adds a new feature to its @sequence and updates @@no_cttctt_genes array
    #
    # Takes the @embl [Bio::EMBL] instance variable and 
    # creates a new CTTCTT_region feature for its @sequence [Bio::Sequence]
    # If the CTTCTT sequence is not in any of the exons, the @id [String] is added to @@no_cttctt_genes [Array]
    #
    def match_exons

        # Initializing local variables
        match_positions_direct = []
        match_positions_reverse = []

        # Iterating over the features of the Bio::EMBL object
        @embl.features.each do |feature|

            # Getting the exon nucleotide sequence
            next unless feature.feature == "exon"            # Checking only exons
            location = feature.locations[0]                  # Position of the exon relative to the gene as Bio::Location object
            start_pos, end_pos = location.from, location.to  # Saving the start and end position of the exon
            next unless end_pos.between?(0,@embl.seqlen)     # Next if exon is out of sequence range 
            exon_seq = @sequence.subseq(start_pos,end_pos)   # Getting the sequence of the exon
            next if exon_seq.empty?                          # Next if exon sequence is empty
            
            # Finding a CTTCTT region when exon is in the + strand
            if location.strand == 1

                # Match region
                match_start_rel = exon_seq.enum_for(:scan, /(?=(cttctt))/i).map {Regexp.last_match.begin(0)} # Match and get position
                # https://stackoverflow.com/questions/5241653/ruby-regex-match-and-get-positions-of
                # i ignores case while matching alphabets https://learnbyexample.github.io/Ruby_Regexp/modifiers.html 
                # ?= Lookahead to find overlapping regions https://learnbyexample.github.io/Ruby_Regexp/lookarounds.html 
                next if match_start_rel.empty?
                
                # Saving gene relative coordinates of the CTTCTT region
                match_start_rel.each do |start|                    # For each match found
                    match_start = start.to_i + start_pos.to_i      # Start of the region in the exon + start of the exon in the gene
                    match_end = start.to_i + start_pos.to_i + 5    # 5 is the length -1 of the region (1-base offset)
                    position_s =  "#{match_start}..#{match_end}"   # Save position with Bio::Location format
                    match_positions_direct.push(position_s)        # Add it to the matching positions direct array
                end

            # Finding a CTTCTT region when exon is in the - strand    
            elsif location.strand == -1

                # Match region
                match_start_rel = exon_seq.enum_for(:scan, /(?=(aagaag))/i).map {Regexp.last_match.begin(0)} # aagaag is the reverse complement of cttctt
                # https://stackoverflow.com/questions/5241653/ruby-regex-match-and-get-positions-of
                # i ignores case while matching alphabets https://learnbyexample.github.io/Ruby_Regexp/modifiers.html 
                # ?= Lookahead to find overlapping regions https://learnbyexample.github.io/Ruby_Regexp/lookarounds.html 
                next if match_start_rel.empty? 
                
                # Saving gene relative coordinates of the CTTCTT region
                match_start_rel.each do |start|                    # For each match found
                    match_start = start.to_i + start_pos.to_i      # Start of the region in the exon + start of the exon in the gene
                    match_end = start.to_i + start_pos.to_i + 5    # 5 is the length -1 of the region (1-base offset)
                    position_s =  "#{match_start}..#{match_end}"   # Save position with Bio::Location format
                    match_positions_reverse.push(position_s)       # Add it to the matching positions reverse array
                end

            end

        end
        
        # Eliminate repeated matchs if any
        match_positions_direct = match_positions_direct.uniq
        match_positions_reverse = match_positions_reverse.uniq

        
        if match_positions_direct.empty? && match_positions_reverse.empty? # If no match was found in any of the exons...
            @@no_cttctt_genes.push(@id) # ...Add @id to the @@no_cttctt_genes array
        end

        # Add new CTTCTT_region features for the direct strand matches
        index = 1
        match_positions_direct.each do |position|
            strand_s = "+"
            add_new_feature(strand_s, position, index)
            index+=1
        end

        # Add new CTTCTT_region features for the reverse strand matches
        index = 1
        match_positions_reverse.each do |position|
            strand_s = "-"
            add_new_feature(strand_s, position, index)
            index+=1
        end

    end

end