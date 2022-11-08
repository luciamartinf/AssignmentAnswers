# Assigment 1 - Creating Objects

### Lucía Martín Fernández

Assignment 1 for the Bioinformatics Programming Challenges course from the Master in Computational Biology at Universidad Politécnica de Madrid.

## USAGE:

`usage: main.rb gene_information.tsv seed_stock_data.tsv cross_data.tsv new_stock_data.tsv`

All the files needed to run the script are contained in this github repository and detailed above

#### Arguments

| **Argument**                           | **Description**                                                                                                 |                                                   
|:----------------------------------------|:----------------------------------------------------------------------------------------------------------------|
|`gene_information.tsv`                                |  TSV file stored. Contains Gene_ID, Gene_Name and Mutant_phenotype columns                                            |                  
|`seed_stock_data.tsv`                                  | TSV file stored. Contains Seed_Stock, Mutant_Gene_ID, Last_Planted, Storage and Grams_Remaining columns                   |
|`cross_data.tsv`                                |  TSV file stored. Contains Parent1, Parent2, F2_Wild, F2_P1, F2_P2, F2_P1P2 columns                                            |                  
|`new_stock_data.tsv`                                  | New TSV file. Update from seed_stock_data.tsv                    |                                                               


## SOURCE FILES

### main.rb

The following tasks are performed:

**1) Argument control**
- Checks that 4 arguments are given when running the code
- *BONUS!!* Checks that introduced gene-ids follow the Arabidopsis' format 

**2) Plantation**
-   Simulation of planting 7 grams of seeds from each of the records in the seed stock genebank
-   Creation of an updated file with the new state of the genebank seedstock
-   When a seed stock is finished, a warning messaege appears on screen.

**3) Determination of gentically-linked genes**
-   Performance of a Chi-square test for each cross
-   Shows whenever two genes are linked

### FileMaster.rb

Class for File Management. Methods defined:

1) *BONUS!!* `load_from_file`: Class method to retrieve all lines of a specific file as instances of a given class. Returns an array with all objects. 

2) *BONUS!!* `create_updated_file`: Class method to create an updated file with all of the objects of a given class. 


### DATA CLASSES  

A class has been defined for each of the 3 given data files with following common methods:

- `initialize`: Definition of initialize method
- `new_from_hash`: Class method to create an instance from hash
- `to_s`: Instance method to retrieve the current instance as a string. Records are separated by tabs
- `get_header`: Class method to retrieve class header
- `get_all`: Class method to retrieve all instances from the class. The format is defined by the to_s method

And other class-specific methods are detailed hereafter.

### Gene.rb

- `get_gene_info`: Class method to retrieve the whole instance with the seed_stock
- `get_gene_name`: Class method to retrieve the name of the given gene identificator

### SeedStock.rb

- *BONUS!!* `get_seed_stock`: Class method to retrieve the whole instance with the seed_stock
- `get_gene_id`: Class method to retrieve the id of the mutated gene in the indicated seed stock
- `plant_seeds`: Instance method to plant seeds

### HybridCross.rb

- `get_crosses`: Class method to retrieve all crosses performed with a given seed
- `get_cross`: Class method to retrieve the cross between two given seeds
- `chi_square`: Instance method to calculate Chi-Square test
