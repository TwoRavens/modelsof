 log using McCabe_Snyder_ReStat_Table_5_Data_Cleaning, replace

**********************************************************************
*
* Program McCabe_Snyder_ReStat_Table_5_Data_Cleaning.DO
* 
* Cleans data used by McCabe_Snyder_ReStat_Table_5.do.  This way a
* clean dataset can be posted on the journal website.  Uses 
* information collected by research assistants on subsample of 1,500 
* articles.   
*
* McCabe & Snyder August 2013
*
**********************************************************************

* Set initial Stata parameters
version 12
set more 1
 
import excel using FaulknerArchiving.xls, firstrow clear
drop if pyear == .
drop if note ~= ""
replace repec = cepr if repec == "same as cepr"

foreach var in nber cepr ssrn repec inst {
   quietly replace `var' = trim(subinstr(`var',"?","",.))
   quietly replace `var' = "5000" if `var' == "." | `var' == "" 
   gen `var'_date = real(`var')
   gen pre_`var'_date = `var'_date
   quietly replace pre_`var'_date = 5000 if pre_`var'_date > pyear
   gen pre_`var'_ind = pre_`var'_date < 5000
   gen post_`var'_date = `var'_date
   quietly replace post_`var'_date = 5000 if post_`var'_date <= pyear
   gen post_`var'_ind = post_`var'_date < 5000
   }
   
   save McCabe_Snyder_ReStat_archiving, replace
   
   
