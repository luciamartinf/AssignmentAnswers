require './SeedStock'
require './Gene'
require './HybridCross'
require './FileMaster'
require 'date'

# ------------------------------ ARGUMENTS & FILES ------------------------------ #

# Argument control
unless ARGV.length == 4
    abort "ERROR: incorret number of arguments given. Expected 4, given #{ARGV.length}"
end

# Retrieve arguments
gene_file, seedstock_file, crossdata_file, newstock_file = ARGV 

# Create an array for each class with all instances loaded from the files
genes = FileMaster.load_from_file(gene_file, Gene)
seeds = FileMaster.load_from_file(seedstock_file, SeedStock)
cross = FileMaster.load_from_file(crossdata_file, HybridCross)


# ---------------------------------- PLANTATION ---------------------------------- #

# Plant seeds
seeds.each { |s| s.plant_seeds }

# Create updated SeedStock file
FileMaster.create_updated_file(newstock_file, SeedStock)


# ---------------------------- CHECK FOR LINKED GENES ---------------------------- # 

# Calculate ChiSquare for each cross and save linked genes

linked_genes = {} # initialize linked_genes as hash

cross.each do |hc|

    chi2, parent1, parent2 = hc.chi_square

    # The degree of freedom is 3 (= number_phen-1)
    # When df = 3, a value of greater than 7.815 is required for results to be considered statistically significant (p < 0.05)
    if chi2 > 7.815  
        
        # convert seed to gene_id
        p1_gene_id = SeedStock.get_gene_id(parent1)
        p2_gene_id = SeedStock.get_gene_id(parent2)

        # convert gene_id to gene_name
        p1_gene_name = Gene.get_gene_name(p1_gene_id)
        p2_gene_name = Gene.get_gene_name(p2_gene_id)
        
        # add pair of linked genes to linked_genes hash
        linked_genes[p1_gene_name] = p2_gene_name 

        # puts output on screen
        puts "Recording: #{p1_gene_name} is genetically linked to #{p2_gene_name} with chisquare score #{chi2}"
        puts 

    end

end

# puts output on screen

puts "\nFinal Report: \n\n"

linked_genes.each do |gene1, gene2|
    puts "#{gene1} is linked to #{gene2}"
    puts "#{gene2} is linked to #{gene1}"
end

