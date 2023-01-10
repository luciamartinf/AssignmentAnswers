require './BlastFun'

$stderr.reopen(File.new('/dev/null','w')) # redirect standard error output

# USAGE main.rb arabidopsis.fa spombe.fa
file1, file2 = ARGV

# Make blast databases from files
BlastFun.make_blast_database(file1)
BlastFun.make_blast_database(file2)

# Build factories
fact1, fact2 = BlastFun.build_factories

# Find Best Reciprocal hits
BlastFun.find_reciprocal_hits(fact1, fact2, file1, file2)

# Write report
BlastFun.write_report