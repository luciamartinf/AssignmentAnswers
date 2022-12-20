# Assigment 3 - GFF feature files and visualization

### Lucía Martín Fernández

Assignment 3 for the Bioinformatics Programming Challenges course from the Master in Computational Biology at Universidad Politécnica de Madrid.

## USAGE:

`USAGE main.rb ArabidopsisSubNetwork_GeneList.txt`

All the files needed to run the script and the ones generated are contained in this github repository and detailed below.

#### Arguments

| **Argument**                           | **Description**                                                                                                 |                                                   
|:----------------------------------------|:----------------------------------------------------------------------------------------------------------------|
|`ArabidopsisSubNetwork_GeneList.txt`                                |  txt file stored. Contains a list of Arabidopsis Thaliana co-expressed genes                          |                  
|`GFF_genes.gff3`                                  | New GFF3 file. Report generated that contains all Interaction Networks involving genes from the list with its GO and KEGG annotations                  |                                                               
|`GFF_chr.gff3`                                  | New GFF3 file. Report generated that contains all Interaction Networks involving genes from the list with its GO and KEGG annotations                  |   
|`no_CTTCTT_genes_report.txt`                                  | New txt file. Report generated that contains all Interaction Networks involving genes from the list with its GO and KEGG annotations                  |     

## SOURCE FILES

### main.rb

The following tasks are performed:

-   Reads the genelist file with Arabidopsis Thaliana genes and stores them in an Array
-   Finds all Interaction Networks involving genes from the genelist
-   Creates a file called report.txt to store all the information about the Interaction Networks

### FileMaster.rb

Class for File Management. Methods defined:

- `get_genelist_from_file`: Class method to read genelist file and create an array withall the genes
- `fetch`: Class method fetch to access an URL via code, donated by Mark Wilkinson.
- `generate_report`: Class method to write report with all the information about the Interaction Networks

### Seq.rb 

- `initialize`: Definition of initialize method
- `get_interaction`: Instance method to get interactions of a given gene
- `create_network`: Instance method to create an interaction network starting with a gene id using a recursive function
- `get_genes_network`: Instance method to get all genes in the network as a simple Array
- `get_genes_from_genelist`: Instance method to get all genes in the network that are also in the gene list as a simple Array
- `get_annotation`: Instance method to get GO and KEGG annotations for all genes in the network

### Annotation.rb

- `fetch`: Class method fetch to access an URL via code, donated by Mark Wilkinson.
- `kegg_annotations`: Class method to return the KEGG annotations (KEGG ID and KEGG pathway) in a hash for a given gene id
- `go_annotations`: Class method to return the GO annotations (GO ID and Biological function) in a hash for a given gene id
