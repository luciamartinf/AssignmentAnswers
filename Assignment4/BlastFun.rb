require 'bio'

# == BlastFun
#
# Class to write a best reciprocal hits report
#
# Contains the functions to get the sequence type of a fasta file, make a blast database, build blast factories, 
# find the best reciprocal hits and write a report about them
#
# == Summary
# 
# This class contains all the necessary functions to find reciprocal best hits using blast
#
class BlastFun

    # Class variable [Array<Array<String>>] 
    # Is an array of arrays with the structure: [ database_path, database_basename, fasta_type, genome_filename ]
    @@all_blastdb = []

    # Class variable [Array<Array<Symbol>>] 
    # Is an array of arrays that contains all the pairs of best reciprocal hits found
    @@reciprocal_hits = []

    #
    # Class method to get the class variable @@all_blastdb
    #
    # @return [Array<Array<String>>] which contains information about the blast database
    #
    def self.get_all_blastdb

        return @@all_blastdb

    end

    #
    # Class method to get the class variable @@reciprocal_hits
    #
    # @return [Array<Array<Symbol>>] which contains the best reciprocal hits
    #    
    def self.get_reciprocal_hits

        return @@reciprocal_hits

    end

    #
    # Class method to define the sequence type of a fasta file. 
    #
    # @param filename [String] the name of the fasta file
    # 
    # @return [String] the sequence type. Options are 'prot' or 'nucleotide'
    #
    def self.get_fasta_type(filename)

        fastafile = Bio::FlatFile.auto(filename)
        seq_type = fastafile.next_entry.to_biosequence.guess # guess the sequence type of the first entry.

        if seq_type == Bio::Sequence::NA
            return 'nucl'
        elsif seq_type == Bio::Sequence::AA
            return 'prot'
        else
            abort("Unable to recognize sequence types of the fasta file #{filename}")
        end
        
    end

    #
    # Class method to make blast database from a fasta file. 
    #
    # @param filename [String] the name of the fasta file
    # 
    # Updates the @@all_blastdb array with the information about the blast database
    #
    def self.make_blast_database(filename)

        fasta_type = BlastFun.get_fasta_type(filename) # get the sequence type of the fasta file

        basename = File.basename(filename, ".fa") # obtain basename of the fasta file https://stackoverflow.com/questions/20793180/get-file-name-and-extension-in-ruby
        db_name = basename + "_db"
        db_path = "blastdb/" + db_name
        
        system("makeblastdb -in #{filename} -dbtype #{fasta_type} -out #{db_path}") # run makeblastdb on the system

        @@all_blastdb.push([db_path, db_name, fasta_type, filename]) # update class variable

    end

    #
    # Class method to build local blast factories
    #
    # @param evalue [String] evalue threshold number as string. Optional, default is "1e-6"
    # @param filter_algor [String] the filter algorithm to use. Optional, default is "m S"
    #
    # @return [Bio::Blast, Bio::Blast] factories
    #
    def self.build_factories(evalue = "1e-6", filter_algor = "m S") # default values from https://doi.org/10.1093/bioinformatics/btm585

        path_db1 = @@all_blastdb[0][0]
        type_db1 = @@all_blastdb[0][2]

        path_db2 = @@all_blastdb[1][0]
        type_db2 = @@all_blastdb[1][2]

        arguments = "-e #{evalue.to_f} -F #{filter_algor}" # write arguments line

        # Depending on the sequence types of the fasta files, the factories will be created using different blast types
        if type_db1 == 'prot' && type_db2 == 'prot'
            factory1 = Bio::Blast.local('blastp', path_db1, arguments) 
            factory2 = Bio::Blast.local('blastp', path_db2, arguments) 
        elsif type_db1 == 'nucl' && type_db2 == 'nucl'
            factory1 = Bio::Blast.local('blastn', path_db1, arguments) 
            factory2 = Bio::Blast.local('blastn', path_db2, arguments) 
        elsif type_db1 == 'nucl' && type_db2 == 'prot'
            factory1 = Bio::Blast.local('tblastn', path_db1, arguments) 
            factory2 = Bio::Blast.local('blastx', path_db2, arguments) 
        elsif type_db1 == 'prot' && type_db2 == 'nucl'
            factory1 = Bio::Blast.local('blastx', path_db1, arguments) 
            factory2 = Bio::Blast.local('tblastn', path_db2, arguments) 
        else
            abort("Not supported database types combination #{type_db1} and #{type_db2}")
        end

        return factory1, factory2
    end
    
    # 
    # Class method to find the best reciprocal hits between 2 files
    #
    # @param factory1 [Bio::Blast] 
    # @param factory2 [Bio::Blast]
    # @param file_1 [String] filename1
    # @param file_2 [String] filename2
    #
    # Updates the @@reciprocal_hits array
    #
    def self.find_reciprocal_hits(factory1, factory2, file_1, file_2, coverage = 0.5)  # default value from https://doi.org/10.1093/bioinformatics/btm585

        possible_orthologues = {} # initialize hash

        Bio::FlatFile.auto(file_1).each_entry do |entry|

            report = factory2.query(entry)
            next if report.hits.empty?
            best_hit = report.hits[0] # the best hit is the first one on the report
            hit_cov = (best_hit.query_end.to_f - best_hit.query_start.to_f)/best_hit.query_len.to_f # calculate hit coverage
            next unless hit_cov.abs >= coverage # compare it to the threshold value

            candidate_db2 = best_hit.definition.split("|")[0].to_sym 
            candidate_db1 = entry.definition.split("|")[0].to_sym

            possible_orthologues[candidate_db2] = candidate_db1 # add candidates to Hash

        end

        # Reverse procedure
        Bio::FlatFile.auto(file_2).each_entry do |entry|

            report = factory1.query(entry)
            next if report.hits.empty?
            best_hit = report.hits[0] # the best hit is the first one on the report
            hit_cov = (best_hit.query_end.to_f - best_hit.query_start.to_f)/best_hit.query_len.to_f # calculate hit coverage
            next unless hit_cov.abs >= coverage # compare it to the threshold value

            candidate_db1 = best_hit.definition.split("|")[0].to_sym
            candidate_db2 = entry.definition.split("|")[0].to_sym 

            if possible_orthologues[candidate_db2] == candidate_db1 # Check if candidates are in the Hash
                @@reciprocal_hits.push([candidate_db2, candidate_db1]) # add them to the @@reciprocal_hits class array
            end
            
        end

    end

    #
    # Writes a .tsv format report with the best reciprocal hits
    #
    # @param report [String] The name of the report file. Optional, default is "reciprocal_hits_report.tsv"
    #
    def self.write_report(report = "reciprocal_hits_report.tsv")

        filename1 = @@all_blastdb[0][3]
        basename1 = File.basename(filename1, ".fa")

        filename2 = @@all_blastdb[1][3]
        basename2 = File.basename(filename2, ".fa")

        open(report, "w") do |f|
            
            f.puts "#{basename1}\t#{basename2}" # heading

            @@reciprocal_hits.each do |seq1, seq2|
                f.puts("#{seq1}\t#{seq2}")
            end

        end

    end

end