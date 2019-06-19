******************************************************************************
*** Contents: This file describes the data generation process from the raw ***
***           to the final dataset used in the estimation      		   ***
******************************************************************************


cd "E:\REStat_MS14767_Vol96(2)\Data preparation Compustat"

****************************************
* First step: Cleaning COMPUSTAT       *
****************************************

* There is a problems with double entries in the database
*
* One example
*
* ticker name	                year    CUSIP	        sales	 employees   rdexpense
* ATYT	 ATI TECHNOLOGIES INC	1997	001941103	433.984	 1.074	     32.006
* ATY.	 ATI TECHNOLOGIES INC	1997	001941103	602.839	 1.074	     44.459
* 
* A problem arises when assigning rd-expenditures to firms and when 
* calculating market shares.
* Therefore the double entries were manually removed,
* though it is not alawys clear which entries are more reliable.

do 1_cleancompustat.do


**************************************
* Second step: American data set
**************************************

* A small data set only containing
* country-information is created:
* ticker_country.dta

* After that all non-american firms
* are dropped from the compustat sample
* resulting in 
* new\compustat_master_america.dta

do 2_compustatamerica.do



**************************************
* Third step: Generating Compustat vars
**************************************

* The data set clean_compustat_master is used
* to generate MS, HHI and sales_new:
* compustatvars.dta

do 3_compustatvars.do


*********************************
* Fourth step: Create RJV panel *
*********************************

* Here we start from the file 
* "JV180506_corrected_ticker.dta"
* some corrections are done, a panel is built by blowing 
* the data up to a panel.
* Outcome is a panel on rjv-insiders: 
* "raw_rjv_panel.dta.dta"


do 4_RJV_panel.do



**********************************
* Fifth step: RJV american panel
**********************************

* After that all non-american firms
* are dropped from the RJV panel
* resulting in 
* raw_rjv_panel_usa.dta
* Entries before 1985 are dropped
* and observations without ticker are deleted.
* Generation of in-variable.


do 5_RJVamerica.do


*********************************
* Sixth step: RJV Participation panel *
*********************************

* Using the dataset
* raw_rjv_panel_america.dta
* some temporarly needed variables are generated 
* (rjv`i'. etc). 
* The result is saved in 
* RJVparticip_panel.dta

* The next step is the generation of
* participation variables using the data
* RJVparticip_panel.dta
* resulting into the small file
* RJVvars.dta
* only containing identifiers and RJVvars.


do 6_RJVparticip.do




*********************************************
* Sevens step: Creation of link variables    *
*********************************************

* The basic data set used here is again
* raw_rjv_panel_america.dta
* Variables are generated which give information
* on the structure of RJVs concerning the industries
* its members belong to.
* The resulting variables are saved in
* links.dta


do 7_links.do



******************************************************
* Eighth step: Creation of link variables based on MS *
******************************************************

* look at it correct it....

do 8_links_MS.do





*************************************
* Nineth step: Managing patent data *
*************************************

* Since the patent data have only the identifier "assignee",
* it is necessary to append another matching identifier to the file.
* Based on 
* "clean_compustat_master.dta" 
* it is searched for matches
* by name and by cusip between COMPUSTAT and a special matching file,
* namely "patent files\patents\match.dta" and finally the data set
* "data\Working\cusipnamemerged.dta" 
* is created which will later support
* the merging procedure of patent infos to COMPUSTAT. 

do 9_match_cq.do



***********************************************
* Tenth step: Aggregation to few patent vars *
***********************************************

* To retrieve information from the patent data,
* the file
* data\raw data\patents\apat63_99.dta
* is first merged with the matching data set
* "Working\cusipnamemerged.dta" 
* Several procedures result in panel
* on patent information:
* "Working\spillover_pool_panel.dta" 
* and a further small data set:
* "Working\patentvars.dta"

do 10_patentvars.do

***************************************************
* Eleventh step: generate patent stock variable   *
***************************************************

* In order to use a variable presenting the history
* of patent data for each firm, a panel on
* patents is build using 
* "raw data\apat63_99.dta"
* Outcome is a small data set with a patent stock variable
* and some lagged variables to be found here:
* patentpanel.dta


do 11_patentpanel.do



****************************************
* Last step: Creation of final sample  *
****************************************


* This final step prepares the final sample using
* compustat_master_america.dta
* and connecting it to the RJVvars from
* RJVvars.dta and links.dta
* Patent infos are added and sales
* are corrected. Then, market shares are defined
* and explaining variables are generated.
* The final sample is saved as
* estimation_sample.dta


do 12_estimation_sample.do

end
