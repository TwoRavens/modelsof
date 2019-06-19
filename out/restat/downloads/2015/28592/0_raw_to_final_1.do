*****************************************************************
*** Contents: This file describes the process from the raw data *
***           to the finaldataset to be worked with. 		    *
*****************************************************************

cd "E:\REStat_MS14767_Vol96(2)\Data preparation Compustat segment"

****************************************
* First step: Cleaning COMPUSTAT *
****************************************

* There is a severe problem with double entries in the database.
*
* ticker	name	                  year	 CUSIP	sales	  employees	rdexpense
* ATYT	ATI TECHNOLOGIES INC	1997	001941103	433.984	1.074	32.006
* ATY.	ATI TECHNOLOGIES INC	1997	001941103	602.839	1.074	44.459
* 
* There are no mistakes when merging on ticker.
* A problem arises when assigning rd-expenditures to firms and when 
* calculating market shares.
* Therefore the double entries were manually removed,
* the data set "clean_compustat_master.dta" is saved in this step.

do 1.cleancompustat.do


**************************************
* Second step: American data set
**************************************
* the "clean_compustat_master.dta" set is used in this step

* After that all non-american firms are dropped from the compustat sample
* resulting in compustat_master_america.dta

do 2.compustatamerica.do

**************************************
* Third step: Segment Data set
**************************************

* here the data set :raw data\segments_1986-1999.dta is included
* We work only with business-segment data, thus we only keep observation which refere to buisiness segments.

* Even if there are not such double entries in the the segment database, it is usefull to drop the same firms.
* If we would not do that, the double entries would emerge after merging the compustat data with the segment data.  

do 3.segmentdata.do


**************************************
* fourth step: Generating variables
**************************************

* The data set clean_compustat_master is merged with the segment data.
* Further information about the merging process are in the do-file.
* Then   MS and  HHI  are generated. the data sets "compustat+segment.dta" , 
* "segment_compustatvars.dta" and  "segment_wide.dta" are created.


* Additionally a small data set only containing
* year -ticker information is created:ticker_country.dta

do 4.segmentvars.do

*********************************
* Fourth step: Create RJV panel *
*********************************

* Here we start from the file "JV180506_corrected_ticker.dta"
* some corrections are done, a panel is built by blowing  the data up to a panel.
* Outcome is a panel on rjv-insiders: "raw_rjv_panel.dta.dta"

do 5.RJV_panel.do

**********************************
* Fifth step: RJV american panel
**********************************

* After that all non-american firms are dropped from the RJV panel
* resulting in raw_rjv_panel_usa.dta. 
* Entries before 1985 are dropped and observations without ticker are deleted.
* Generation of in-variable.

do 6.RJVsegment.do

*********************************
* Sixth step: RJV Participation panel *
*********************************

* Using the dataset raw_rjv_panel_america.dta
* some temporarly needed variables are generated (rjv`i'. etc). 
* The result is saved in RJVparticip_panel.dta

* The next step is the generation of participation variables using the data
* RJVparticip_panel.dta resulting into the small file RJVvars.dta
* only containing identifiers and RJVvars.

do 7.RJVparticip.do

*********************************************
* Sevens step: Creation of link variables    *
*********************************************

* The basic data set used here is again raw_rjv_panel_america.dta
* Variables are generated which give information on the structure of RJVs concerning the industries
* its members belong to. The resulting variables are saved in links.dta 
* Market shares and number of links are generated in the same step.
* more detailed information are in the do-file.


do 8.links.do

*************************************
* Nineth step: Managing patent data *
*************************************

* Since the patent data have only the identifier "assignee",
* it is necessary to append another matching identifier to the file.
* Based on "compustat+segment.dta" it is searched for matches
* by name and by cusip between COMPUSTAT and a special matching file,
* namely "patent files\patents\match.dta" and finally the data set
* "data\Working\cusipnamemerged.dta" is created which will later support
* the merging procedure of patent infos to COMPUSTAT. 

do 9.match_cq.do

***********************************************
* Tenth step: Aggregation to few patent vars *
***********************************************

* To retrieve information from the patent data, the file data\raw data\patents\apat63_99.dta
* is first merged with the matching data set "Working\cusipnamemerged.dta". 
* Several procedures result in panel on patent information: "Working\spillover_pool_panel.dta" 
* and a further small data set: "Working\patentvars.dta"

do 10.patentvars.do

***************************************************
* Eleventh step: generate patent stock variable   *
***************************************************

* In order to use a variable presenting the history of patent data for each firm, a panel on
* patents is build using "raw data\apat63_99.dta"
* The outcome is a small data set with a patent stock variable and some lagged variables to be found here:
* patentpanel.dta

do 11.patentpanel.do

****************************************
* Last step: Creation of final sample  *
****************************************

* This final step prepares the final sample using compustat_master_america.dta
* and connecting it to the RJVvars from RJVvars.dta and links.dta
* Patent infos are added and sales are corrected. Then, market shares are defined
* and explaining variables are generated.
* The final sample is saved as RESTATestimation_sample_segment.dta


do 12.estimation_sample.do
 log close
