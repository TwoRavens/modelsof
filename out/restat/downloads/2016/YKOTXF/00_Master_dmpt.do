

clear
clear matrix 
set mem  5G
set matsize 3000
set scheme s1mono

// the data are stored in the folder "data" 
// the do-files are stored in the folder "do" 
// the tables and figures are exported to the folder "results" 
// the description of the variables of the dataset base_for_reg.dta is in list-variables.pdf

/* HERE ARE THE PATHS TO THESE FOLDERS */

global datapath \research\Data\restat_tax\data
global dopath \research\Data\restat_tax\do 
global resultpath \research\Data\restat_tax\results
global graphpath \research\Data\restat_tax\results
  
				
					

*============================================================
*
*	    MASTER DO-FILE 
*       "Knocking on Tax Haven's Door: 
*		Multinational Firms and Transfer Pricing"   
*       by Davies, Martin, Parenti, Toubal
*		Name: master_dmpt.do 
*		Date: Dec. 11, 2016
* 
*============================================================

					
* I. Build and Merge data sets

cd "$dopath"
do 01_TradeDataset	/* merge Custom data with intrafirm data from Enquete Mondialisation */

cd "$dopath"
do 02_CountryInfo	/* collect and merge data about destination countries */

cd "$dopath"
do 03_FinalData	    /* combine trade data firm level data, country data, product level data, and 

info on firm ownership  */

* II. Prepare the data for the empirical analysis 

global lowerbound 1
global upperbound 99 
cd "$dopath"
do 04_DataMgmt	    /* drop outliers, keep usefull obs etc...  */

* III. Results of the paper (using the 1%-99% thesholds) 
 
cd "$dopath"
do table1.do // Stat des

cd "$dopath"
do table2.do // EMTR, Baseline 

cd "$dopath"
do table3.do // EMTR, Additional

cd "$dopath"
do table4.do // Quantification 

cd "$dopath"
do table5.do // List tax rates / status 

cd "$dopath"
do table6.do // Quantities  

cd "$dopath"
do figure1.do // Non-linear effect of EMTR 

* IV - Appendix 

cd "$dopath"
do table1_appendix.do // Stat desc. thresholds 

cd "$dopath"
do table2_appendix.do  // Stat desc. intra-firm exports usage 

cd "$dopath"
do table3_appendix.do  // Additional results: pricing-to-market  

cd "$dopath"
do table4_appendix.do // Stat desc. composition exports tax havvens / non-havens

cd "$dopath"
do table5_appendix.do // Additional results: alt. measure of tariffs

cd "$dopath"
do table6_appendix. // Additional results: alt. clustering 

cd "$dopath"
do table7_appendix.do   // EATR, Baseline

cd "$dopath"
do table8_appendix.do // EATR, Additional

cd "$dopath"
do table9_appendix.do   // Additional results: product differenciation 


// Now we change the thresholds => we have to build the data for regressions accordingly

*** TABLE A.10 
global lowerbound 2
global upperbound 98 
cd "$dopath"
do 04_DataMgmt	    /* drop outliers, keep usefull obs etc...  */
global threshold threshold98

cd "$dopath"
do table10_appendix.do // baseline regression, alt. threshold (2%-98%) 

cd "$dopath"
do figures_3_4_appendix.do // baseline regression, alt. threshold (2%-98%) 


*** TABLE A.11
global lowerbound 0
global upperbound 100 
cd "$dopath"
do 04_DataMgmt	    /* drop outliers, keep usefull obs etc...  */
global threshold threshold100
cd "$dopath"
do table11_appendix.do // baseline regression, alt. threshold (0%-100%) 

*** TABLE A.12
global lowerbound 10
global upperbound 90 
cd "$dopath"
do 04_DataMgmt	    /* drop outliers, keep usefull obs etc...  */
global threshold threshold90

cd "$dopath"
do table12_appendix.do // baseline regression, alt. threshold (1%-99%) 


*** TABLE A.13-A.14
global lowerbound 0
global upperbound 0
cd "$dopath"
do 04_DataMgmt	    /* drop outliers, keep usefull obs etc...  */
global threshold nothreshold

cd "$dopath"
do table13_appendix.do // baseline regression, no threshold, continuous

cd "$dopath"
do table14_appendix.do // baseline regression, no threshold, binary 


