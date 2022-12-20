require 'rest-client'
require './Seq'

# == FileMaster
#
# Class to read file containing the gene list, write the reports files and fetch information froma a URL
#
# Contains the functions to read the file and create a genelist array, to fetch information from API
# and to create the reports file for genes with no CTTCTT repeats, the GFF3 file with gene relative coordinates and the GFF3 file with chromosome absolute coordinates
#
# == Summary
# 
# This class can be use to load the genelist file, to use the fetch function and to write the reports files
#
class FileMaster

    # Class variable [Array<String>]
    # Contains every gene id from the genelist file
    @@genelist = []

    #
    # Class method to read genelist file and create an array withall the genes
    #
    # @param filename [String] the name of the file cointaiing the gene list as a String
    # @return [Array<String>] the gene list
    #
    def self.get_genelist_from_file(filename)

        if @@genelist.empty? # Only if genelist has not been previously defined

            File.open(filename, "r") do |f|

                f.readlines.each do |l|
                    geneid = l.chop                # Remove final \n
                    @@genelist.push(geneid.upcase) # Add genes in all caps
                end

            end

        end

        return @@genelist

    end

    #
    # Class method fetch to access an URL via code, donated by Mark Wilkinson.
    #
    # @param [String] url URL
    # @param [String] headers headers
    # @param [String] user username, default ""
    # @param [String] pass password, default ""
    #
    # @return [String, false] the contents of the URL, or false if an exception occured
    #
    def self.fetch(url:, headers: {accept: "*/*"}, user: "", pass: "")

        response = RestClient::Request.execute({
            method: :get,
            url: url.to_s,
            user: user,
            password: pass,
            headers: headers})
        return response
        
        rescue RestClient::ExceptionWithResponse => e
            $stderr.puts e.inspect
            response = false
            return response  
        
        rescue RestClient::Exception => e
            $stderr.puts e.inspect
            response = false
            return response  

        rescue Exception => e
            $stderr.puts e.inspect
            response = false
            return response 

    end 
    
    #
    # Class method to write report with all the genes that don't contain any CTTCTT region in any of their exons
    #
    # Creates the no_CTTCTT_genes_report
    #
    def self.generate_no_report

        # Save the information in local variables
        no_genes = Seq.get_no_genes
        no_genes_count = no_genes.length()
        total_genes = @@genelist.length()

        # Write file
        open("no_CTTCTT_genes_report.txt", "w") do |f|
            f.puts "#{total_genes} were evaluated"
            f.puts "#{no_genes_count} genes do not have any CTTCTT region in any of their exons:"
            no_genes.each do |gene|
                f.puts gene
            end
        end

    end

    #
    # Class method to write GFF3 report with all the CTTCTT regions found in the genes from the list. 
    # The coordinates are relative to the gene.
    #
    # @param seq_objects [Array<Object>] the list of all Seq objects as an Array
    # Creates a GFF3 report file of the CTTCTT regions with gene related coordinates
    #
    def self.generate_gff3_report(seq_objects)

        # Common variables
        source = "Ruby"
        type = "CTTCTT_region"
        score = "."
        phase = "."
        
        # Write file
        open("GFF_genes.gff3", "w") do |f|

            # Header
            f.puts "##gff-version 3" 

            seq_objects.each do |seq_obj| # For each Seq object
                seqid = seq_obj.id        # Get gene id
                biosequence = seq_obj.sequence  # Get the sequence attribute type Bio::Sequence object
                biosequence.features.each do |feature|
                    next unless feature.feature == "CTTCTT_region" # For each CTTCTT_region feature

                    # Gene relative coordinates 
                    location = feature.locations[0] # Get location as Bio::Location
                    start_pos = location.from
                    end_pos = location.to

                    # Rest of variables
                    strand = feature.assoc["strand"]
                    cttctt_id = feature.assoc["CTTCTT_id"]
                    attributes = "gene_id=#{seqid}; CTTCTT_id=#{cttctt_id}"

                    # Write tab separated GFF3 file
                    columns = [seqid, source, type, start_pos, end_pos, score, strand, phase, attributes]
                    f.puts columns.join("\t")

                end
            end

        end

    end

    #
    # Class method to write GFF3 report with all the CTTCTT regions found in the genes from the list. 
    # The coordinates are relative to the chromosome.
    #
    # @param seq_objects [Array<Object>] the list of all Seq objects as an Array. 
    # Creates a GFF3 report file of the CTTCTT regions with chromosome related coordinates.
    #
    def self.generate_gff3_report_chr(seq_objects)

        # Common variables
        source = "Ruby"
        type = "CTTCTT_region"
        score = "."
        phase = "."
        
        # Write file
        open("GFF_chr.gff3", "w") do |f|

            # Header
            f.puts "##gff-version 3" 

            seq_objects.each do |seq_obj| # For each Seq object
                chr = "Chr#{seq_obj.chromosome}" # Get chromosome 
                biosequence = seq_obj.sequence # Get the sequence attribute type Bio::Sequence object
                biosequence.features.each do |feature|
                    next unless feature.feature == "CTTCTT_region" # For each CTTCTT_region feature
                    
                    # Chromosome relative coordinates 
                    location = feature.locations[0] # Get location as Bio::Location
                    start_pos = (seq_obj.start_gene_chr + location.from.to_i - 1)  # -1 to add 1-base offset
                    end_pos = (seq_obj.start_gene_chr + location.to.to_i - 1) # -1 to add 1-base offset
                    
                    # Rest of variables
                    strand = feature.assoc["strand"]
                    cttctt_id = feature.assoc["CTTCTT_id"]
                    attributes = "gene_id=#{seq_obj.id}; CTTCTT_id=#{cttctt_id}"

                    # Write tab separated GFF3 file
                    columns = [chr, source, type, start_pos, end_pos, score, strand, phase, attributes]
                    f.puts columns.join("\t")

                end
            end

        end

    end

end
