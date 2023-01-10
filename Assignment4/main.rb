require './BlastFun'

$stderr.reopen(File.new('/dev/null','w'))

# USAGE main.rb arabidopsis.fa spombe.fa
file1, file2 = ARGV

BlastFun.make_blast_database(file1)
BlastFun.make_blast_database(file2)

alldb = BlastFun.get_all_blastdb

file_1 = alldb[0][3]

file_2 = alldb[1][3]

fact1, fact2 = BlastFun.build_factories


BlastFun.reciprocal_blast(fact1, fact2, file_1, file_2)

# Esto creo que no hace falta, es solo repetir
# BlastFun.reciprocal_blast(fact2, fact1, file_2, file_1)

BlastFun.write_report