# Assigment 1 - Creating Objects

## Lucía Martín Fernández

Written in ruby

### USAGE:

`usage: main.rb gene_information.tsv seed_stock_data.tsv cross_data.tsv new_stock_data.tsv`

#### Arguments

| **Argument**                           | **Description**                                                                                                 |                                                   
|:----------------------------------------|:----------------------------------------------------------------------------------------------------------------|
|`gene_information.tsv`                                |  TSV file stored. Contains Gene_ID, Gene_Name and Mutant_phenotype columns                                            |                  
|`seed_stock_data.tsv`                                  | TSV file stored. Contains Seed_Stock, Mutant_Gene_ID, Last_Planted, Storage and Grams_Remaining columns                   |
|`cross_data.tsv`                                |  TSV file stored. Contains Parent1, Parent2, F2_Wild, F2_P1, F2_P2, F2_P1P2 columns                                            |                  
|`new_stock_data.tsv`                                  | New TSV file. Update from seed_stock_data.tsv                    |                                                               

All requested files to run the script are contained in this github repository

### SOURCE FILES

##### main.rb

The following tasks are performed:

1) Argument control

2) Plantation
- Simulation of planting 7 grams of seeds from each of the records in the seed stock genebank
- Creation of an updated file with the new state of the genebank seedstock
- When a seed stock is finished, a warning messaege appears on screen.

3) Determination of gentically-linked genes
- Performance of a Chi-square test for each cross
- If 2 genes are linked, this information appears on screen.

#### CLASSES  



##### FileMaster.rb

##### Gene.rb

##### SeedStock.rb

##### HybridCross.rb