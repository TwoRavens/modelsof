*This do-file replicates the tables in Lafortune, Lewis and Tessada "People and Machines";

*Generate the skill ratio variables and their instruments:
do do/Making_data_xz.do

*Generate the outcome variables from the manufacturing censuses:
do do/Making_data_y.do

*Generate the data bases for analysis:
do do/final_data.do

*Replicate the tables of the paper and of the appendix:
do do/final_tables_full.do
