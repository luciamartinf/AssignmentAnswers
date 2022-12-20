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



# id1 = "AT5G54270"

# #id1 = genelist[0]
# seq1 = Seq.new(id: id1)

# seq1.get_bio

# seq1.match_exons

# seq1.get_coords_chr

# sequence1 = seq1.sequence

# embl1=seq1.embl

# accession = embl1.accession.split(":")

# chr = accession[2]
# start_chr = accession[3]
# end_chr = accession[4]

# puts chr, start_chr, end_chr

# puts embl1.accession
# puts sequence1.primary_accession
# #puts sequence1.primary_accession.split(":")[3]

# sequence1.features.each do |feature|
#     if feature.feature == "CTTCTT_direct"
#         location = feature.locations[0]
#         star = location.from.to_i
#         puts star
#         puts seq1.start_gene_chr.to_i
#         start_pos = seq1.start_gene_chr.to_i + location.from.to_i
#         end_pos = seq1.start_gene_chr.to_i + location.to.to_i
#         puts "#{start_pos}..#{end_pos}"
#     end
# end

# # 22039263	22039268


# puts embl1.description

# sequence1.features.each do |feature|
#     puts feature.feature
#     puts feature.assoc
#     if feature.feature == "CTTCTT_direct"
#         puts feature.position
#     end

# end









