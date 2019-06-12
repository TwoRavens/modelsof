*******************************************************
*** Replication file for Agrawal and Foremny (2018) ***
*******************************************************

* This master do-file replicates the results. Before running 
* the file, make sure to have at least 10 GB of free disc 
* space. The raw data has to be copied into the respective 
* folders as described in readme.txt

global dir `c(pwd)'

*********************************
*** read and arrange raw data ***
*********************************

* This do-file will arrange the raw data and output a data file 
* which contains all the information used in the different parts 
* of the analysis. Part of this code are taken from 
* Jorge De la Roca and Diego Puga (REStud 2017). We gratefully
* acknowledge their effort in providing the code.
* This part will also call automatically the tax calculator
* provided in \taxcalc\ to simulate average and marginal tax rates.

cd $dir\mcvl\mcvl_merge\
do merge_mcvl.do

****************************************
*** produce datasets for the analysis ***
****************************************

* These files produces the different datasets used for the 
* three different types of analysys in the paper.
* The input file is the the final panel with simulated tax rates 
* merged to affiliation data.

cd $dir\replication\data\
do data_ind_agg.do
do data_agg_clean.do

***************
*** results ***
***************

* Section 3 - Aggregate analysis
*
* This file generates: 
* Figures 2, 3, 4.
* Tables 1, A9.

cd $dir\replication\aggregate\
do est_agg.do

* Section 4 - Individual analysis
*
* This file generates: 
* Figures 5a, 5b
* Tables 2, 3, 4, A11, A13, A14, A15, A16, A17, A20, A21

cd $dir\replication\individual\
do est_ind.do

* Tables and graphs
*
* This file generates: 
* Tables A1, A2, A8, A10 and the information needed for A3, A4, A18, A19. These tables 
* are not generated automatically and the information can be found in the
* log-file tables.smcl

cd $dir\replication\matrix_tables\
do tables.do

* This file generates: 
* Figures 1a, 1b. A1, A2, A3

cd $dir\replication\figures\
do figures.do

*Section 5 - Revenue simulations
*
*This file generates figures 6A and 6B for the revenue 
* simulations as well as the appendix table A22.

cd $dir\replication\revenue\
do est_revenue.do

