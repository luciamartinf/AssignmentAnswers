require './SeedStock'
require './Gene'
require './HybridCross'
require './FileMaster'
require 'date'

gene_file, seedstock_file, crossdata_file, newstock_file = ARGV 

genes = FileMaster.load_from_file(gene_file, Gene)
seeds = FileMaster.load_from_file(seedstock_file, SeedStock)
cross = FileMaster.load_from_file(crossdata_file, HybridCross)


seeds.each { |s| s.plant_seeds }


linked_genes = {}

cross.each do |hc|

    chi2, parent1, parent2 = hc.chi_square

    if chi2 > 7.815

        p1_gene_id = SeedStock.get_gene_id(parent1)
        p2_gene_id = SeedStock.get_gene_id(parent2)
        p1_gene_name = Gene.get_gene_name(p1_gene_id)
        p2_gene_name = Gene.get_gene_name(p2_gene_id)

        linked_genes[p1_gene_name] = p2_gene_name
        puts "Recording: #{p1_gene_name} is genetically linked to #{p2_gene_name} with chisquare score #{chi2}"
        puts 

    end
    
end

puts "\nFinal Report: \n\n"

linked_genes.each do |gene1, gene2|
    puts "#{gene1} is linked to #{gene2}"
    puts "#{gene2} is linked to #{gene1}"
end

FileMaster.create_updated_file(newstock_file, SeedStock)