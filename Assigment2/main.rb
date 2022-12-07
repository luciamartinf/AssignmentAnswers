require './InteractionNetwork'
require './FileMaster'

# USAGE main.rb ArabidopsisSubNetwork_GeneList.txt report.txt
genelist_file, report = ARGV # function takes 2 arguments

# Create genelist from file
genelist = FileMaster.get_genelist_from_file(genelist_file)
genelist_clone = genelist.clone # make a clone to edit

# Find all interaction networks and stored them as objects in the networks_objects array
networks_objects = []
genelist_clone.each do |gene|
    obj_net = InteractionNetwork.new(id:gene,genelist:genelist_clone) # initialize network object
    net = obj_net.create_network(gene) # create the network
    next if net.empty? # skip the rest if the network is empty
    networks_objects.push(obj_net) # add the new instance to the networks_objects array
    obj_net.get_genes_network # get the list with all the genes in the network
    obj_net.get_annotations # get GO and KEGG annotations 
    my_genes = obj_net.get_genes_from_genelist # get list with genes in both the genelist and the network
    my_genes.each do |gene|
        genelist_clone.delete(gene) # remove the genes that are already in a network from the genelist clone
    end
end

# Generate final report
FileMaster.generate_report(report, networks_objects)