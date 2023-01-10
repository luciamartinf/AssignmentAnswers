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

