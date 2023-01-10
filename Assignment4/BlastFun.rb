require 'bio'


# Gabriel Moreno-Hagelsieb, Kristen Latimer, Choosing BLAST options for better detection of orthologs as reciprocal best hits, Bioinformatics, Volume 24, Issue 3, 1 February 2008, Pages 319–324, https://doi.org/10.1093/bioinformatics/btm585

# Protocol for best reciprocal hit. Steps
# https://www.protocols.io/view/reciprocal-best-hit-blast-x54v9rezv3eq/v1

# 1. Retrieve Sequences. Done, we have the files

# 2. Create database in a new directory
#    makeblastdb -in FILE_NAME.fasta -dbtype 'TYPE' -out DATABASE_NAME
#       TYPE = 'prot' or 'nucleotide'

# 3. Select sequences as queries to search for homolods in database


# == FileMaster
#
# !! Class to read file containing the gene list, write the reports files and fetch information froma a URL
#
# !! Contains the functions to read the file and create a genelist array, to fetch information from API
# !! and to create the reports file for genes with no CTTCTT repeats, the GFF3 file with gene relative coordinates and the GFF3 file with chromosome absolute coordinates
#
# == Summary
# 
# !! This class can be use to load the genelist file, to use the fetch function and to write the reports files
#
class BlastFun

    @@all_blastdb = [] # hash to store blast database names and types

    @@reciprocal_hits = []

    def self.get_all_blastdb
        return @@all_blastdb
    end

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

    def self.make_blast_database(filename)

        fasta_type = BlastFun.get_fasta_type(filename)
        basename = File.basename(filename, ".fa") # https://stackoverflow.com/questions/20793180/get-file-name-and-extension-in-ruby
        db_name = basename + "_db"
        db_path = "blastdb/" + db_name
        system("makeblastdb -in #{filename} -dbtype #{fasta_type} -out #{db_path}")
        @@all_blastdb.push([db_path, db_name, fasta_type, filename])

    end

    def self.build_factories(evalue = "1e-6", filter_algor = "m S") # default values from https://doi.org/10.1093/bioinformatics/btm585

        path_db1 = @@all_blastdb[0][0]
        type_db1 = @@all_blastdb[0][2]

        path_db2 = @@all_blastdb[1][0]
        type_db2 = @@all_blastdb[1][2]

        #arguments = "-F #{filter_algor}"
        arguments = "-e #{evalue.to_f} -F #{filter_algor}"

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
    
    def self.reciprocal_blast(factory1, factory2, file_1, file_2, coverage = 0.5)  # default values from https://doi.org/10.1093/bioinformatics/btm585
        # or db_blasting

        possible_orthologues = {}

        Bio::FlatFile.auto(file_1).each_entry do |entry|

            report = factory2.query(entry)
            next if report.hits.empty?
            best_hit = report.hits[0]
            hit_cov = (best_hit.query_start.to_f - best_hit.query_end.to_f)/best_hit.query_len.to_f
            next unless hit_cov.abs >= coverage
            #puts "#{best_hit.query_id} : evalue #{best_hit.evalue}\t#{best_hit.target_id} at #{best_hit.lap_at}"

            candidate_db2 = best_hit.definition.split("|")[0].to_sym #.split(".")[0]
            candidate_db1 = entry.definition.split("|")[0].to_sym #.split(".")[0]

            possible_orthologues[candidate_db2] = candidate_db1

        end

        Bio::FlatFile.auto(file_2).each_entry do |entry|

            report = factory1.query(entry)
            next if report.hits.empty?
            best_hit = report.hits[0]
            hit_cov = (best_hit.query_start.to_f - best_hit.query_end.to_f)/best_hit.query_len.to_f
            next unless hit_cov.abs >= coverage
            #puts "#{best_hit.query_id} : evalue #{best_hit.evalue}\t#{best_hit.target_id} at #{best_hit.lap_at}"

            candidate_db1 = best_hit.definition.split("|")[0] #.split(".")[0]
            candidate_db2 = entry.definition.split("|")[0] #.split(".")[0]

            if possible_orthologues[candidate_db2.to_sym] == candidate_db1.to_sym
                next if @@reciprocal_hits.include?([candidate_db1, candidate_db2])
                @@reciprocal_hits.push([candidate_db2, candidate_db1])
            end
            
            
        end

    end


    def self.write_report(report = "reciprocal_hits_report.tsv")
        open(report, "w") do |f|
        #f.puts "#{file1}\t#{file2}"
            @@reciprocal_hits.each do |seq1, seq2|
                f.puts("#{seq1}\t#{seq2}")
            end
        end

    end


end