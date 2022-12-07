require './InteractionNetwork'

# == FileMaster
#
# Class to read file containing the gene list and write the report file
# Contains the functions to read the file and create a genelist array 
# and to create the report file with the information of all interaction networks that involve genes of the genelist
#
# == Summary
# 
# This class can be use to load the genelist file and to write the report file for all networks
#
class FileMaster

    # Class variable, array to store every gene from the genelist file
    @@genelist = []

    #
    # Class method to read genelist file and create an array withall the genes
    #
    # @param filename [String] the name of the file cointaiing the gene list as a String
    # @return [Array<String>] the gene list
    #
    def self.get_genelist_from_file(filename)
        if @@genelist.empty? # only if genelist has not been previously defined
            File.open(filename, "r") do |f|
                f.readlines.each do |l|
                    geneid = l.chop # remove final \n
                    @@genelist.push(geneid.upcase) # add genes in all caps
                end
            end
        end
        return @@genelist
    end

    #
    # Class method to write report with all the information about the Interaction Networks
    #
    # @param filename [String] the name of the file that is going to store the report information as String
    # @param networks_objects [Array<Object>] the list of all networks objects as an Array
    #
    def self.generate_report(filename, networks_objects)
        
        open(filename,"w+") do |f|
            # header
            f.puts
            f.puts "                                                 INTERACTION NETWORKS                               "
            f.puts
            f.puts "----------------------------------------------------------------------------------------------------------------------"
            f.puts
            count = 0 # to keep count of all the interacting networks created
            networks_objects.each do |net|
                count +=1
                f.puts "NETWORK #{count}"
                f.puts
                # write reciprocal interactions
                f.puts "Interactions in Network #{count}: "
                network = net.network
                network.each do |gene1, gene2|
                    f.puts "\t#{gene1} <--> #{gene2}"
                end
                f.puts
                total_genes = net.genes_network.length # count the number of genes in the network
                genes_in_list = net.my_genes # count the number of genes in the network included in the gene list
                if genes_in_list.length > 1
                    f.puts "Out of #{total_genes} genes in Network #{count}, #{genes_in_list.length} genes are in the gene list: "
                else
                    f.puts "Out of #{total_genes} genes in Network #{count}, #{genes_in_list.length} genes are in the gene list: "
                end
                # write the genes on the genelist in a single line
                f.print "\t"
                genes_in_list.each do |gene|
                    f.print "#{gene} "
                end
                f.puts
                f.puts
                # write all KEGG annotations
                kegg_annon = net.kegg_annotations
                unless kegg_annon.empty?
                    f.puts "KEGG Pathways for all genes in Network #{count}: "
                    kegg_annon.each do |kegg_id, pathway_name|
                        f.puts "\tID: #{kegg_id}, Pathway name: #{pathway_name}"
                    end
                else
                    f.puts "There are no KEGG Pathways annotated for any of the genes in Network #{count}: "
                end
                f.puts
                # write all GO annotations
                f.puts "GO Terms associated with the total of all genes in Network #{count}: "
                go_annon = net.go_annotations
                go_annon.each do |go_id, go_process|
                    f.puts "\tID: #{go_id}, Biological process: #{go_process}"
                end
                f.puts
                f.puts "----------------------------------------------------------------------------------------------------------------------"
                f.puts
            end
        end
    end

end 
