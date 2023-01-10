# Assigment 4 - Searching for Orthologues

### Lucía Martín Fernández

Assignment 4 for the Bioinformatics Programming Challenges course from the Master in Computational Biology at Universidad Politécnica de Madrid.

## USAGE:

`USAGE ruby main.rb AThaliana.fa SPombe.fa`

Notice that running the script with this files may take a while (around 4 hours)

## Files 

All the files needed to run the script and the ones generated are contained in this github repository and detailed below. 

| **Files**                           | **Description**                                                                                                 |                                                   
|:----------------------------------------|:----------------------------------------------------------------------------------------------------------------|
|`AThaliana.fa`                                |  fasta file stored. Contains a list of Arabidopsis thaliana gene sequences                          |                  
|`SPombe.fa`                                  | fasta file stored. Contains a list of Schizosaccharomyces pombe protein sequences                |                                                               
|`reciprocal_hits_report.tsv`                                  | New tsv file. Best reciprocal hits report               |   
|`blastdb`                                  | New directory. Contains the blast databases generated from the AThaliana.fa and SPombe.fa files     |     

## Source Files

### main.rb

The following tasks are performed:

-   Make blast databases from files
-   Build Blast factories for each file 
-   Find Best Reciprocal Hits
-   Writes report

### BlastFun.rb 

Class to represent all of the information associated with a gene. Methods defined:

- `get_all_blastdb`: Class method to get the class variable @@all_blastdb
- `get_reciprocal_hits`: Class method to get the class variable @@reciprocal_hits
- `get_fasta_type`: Class method to define the sequence type of a fasta file
- `make_blast_database`: Class method to make blast database from a fasta file
- `build_factories`: Class method to build local blast factories
- `find_reciprocal_hits`: Class method to find the best reciprocal hits between 2 files
- `write_report`: Writes a .tsv format report with the best reciprocal hits


## Other files in this repository

- Ruby scripts are commented with YARD and respective documentation can be found in this repository. 

## Further notes

#### Best Reciprocal Hits parameters

- To find the Best reciprocal hits, a maximum E-value threshold of 1×10 − 6 and a coverage of at least 50% were required. In addition, we used a soft Filter method to make the study more computationally efficient [1]

#### What's next? 

- Two genes are orthologs if their last common ascestor in the tree was a speciation event. Thus, to confirm orthology, by analyzing the phylogenetic trees (i.e. using tree reconciliation algorithms) it is possible to derive a collection of fine-grained predictions of all orthology relationship among sequences [2]. 

- If we want to distinguish between orthologs and paralogs we can implement the Cluster of Orthologous Groups (COG) database [3] or other similars such as EGGNOG [4]

-  Finally, applying the OMA matrix to the COGs obtained may result in OMA-COGs subsets of the true orthology relation [2]. 


## References

[1] Gabriel Moreno-Hagelsieb, Kristen Latimer, Choosing BLAST options for better detection of orthologs as reciprocal best hits, *Bioinformatics, Volume 24, Issue 3*, 1 February 2008, Pages 319-324, doi: 10.1093/bioinformatics/btm585

[2] Setubal JC, Stadler PF. Gene Phylogenies and Orthologous Groups. *Methods Mol Biol*. 2018;1704:1-28. doi: 10.1007/978-1-4939-7463-4_1. PMID: 29277861.

[3] Tatusov RL, Koonin EV, Lipman DJ. A genomic perspective on protein families. *Science.* 1997 Oct 24;278(5338):631-7. doi: 10.1126/science.278.5338.631. PMID: 9381173.

[4] eggNOG 5.0: a hierarchical, functionally and phylogenetically annotated orthology resource based on 5090 organisms and 2502 viruses. 
Jaime Huerta-Cepas, Damian Szklarczyk, Davide Heller, Ana Hernández-Plaza, Sofia K Forslund, Helen Cook, Daniel R Mende, Ivica Letunic, Thomas Rattei, Lars J Jensen, Christian von Mering, Peer Bork. *Nucleic Acids Res.* 2019 Jan 8; 47(Database issue): D309–D314. doi: 10.1093/nar/gky1085

