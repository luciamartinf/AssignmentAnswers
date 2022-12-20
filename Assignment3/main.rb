require 'bio'
require './FileMaster'
require './Seq'


# USAGE main.rb ArabidopsisSubNetwork_GeneList.txt
genelist_file = ARGV

# Create genelist array from file
genelist = FileMaster.get_genelist_from_file(genelist_file[0])

# Create a Seq object and get all the useful information for each gene in the genelist file 
seq_objects = []

genelist.each do |gene|
    seq_obj = Seq.new(id: gene)
    seq_obj.get_bio
    seq_obj.get_coords_chr
    seq_obj.match_exons
    seq_objects.push(seq_obj)
end

# Generating reports
FileMaster.generate_no_report
FileMaster.generate_gff3_report(seq_objects)
FileMaster.generate_gff3_report_chr(seq_objects)