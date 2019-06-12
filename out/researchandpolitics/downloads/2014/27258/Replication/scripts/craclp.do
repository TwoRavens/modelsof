/**********************************************************************
File-Name:      craclp.do
Date:           July 8, 2009                                    
Author:         Fernando Martel                                 
Purpose:        Create Alvarez, Cheibub, Limogni and Przeworski data set 
Data Input:     REG02.csv
                Data from Przeworski et al. downloaded Feb 2008 from 
                http://politics.as.nyu.edu/object/przeworskilinks.html
                Data on regime type
Output File:    
Data Output:    aclp.dta
Previous file:  crmaster.do
Status:         Complete
Machine:        IBM, X41 tablet                                 
*************************************************************************/

clear

* Set global path to working directory for this task
global path ///
C:\Users\Fernando\Documents\docs\research_projects\Replication\data_clean
cd "$path"

* Import rego02.csv regime data into stata and save as aclp.dta
* -------------------------------------------------------------
insheet using "../data_raw/ACLP/Data/REG02.csv"
note: Data from Przeworski Cheibub Alvarez and Limogni, downloaded from Przeworski ///
 web site Feb 2008
sort country year, stable
save aclp, replace


* Rename Pze et al ctycode before merging with universal country code
* This is to differentiate from similar named vars in other datasets
* -------------------------------------------------------------------
rename country pzctycodenum
sort pzctycodenum, stable
save aclp,replace


* Add universal country codes and names to ACLP data
* --------------------------------------------------
/*
Data does not have a ISO alpha-3 country code so need to insert one
Concordances between various country codes are in the file 
country_codes.dta which I created (see notes in that do file for 
details, and notes on country_codes.dta)
*/

* Sort country dictionary by merging variable
clear
use ctydic
sort pzctycodenum, stable
save ctydic, replace
clear

* Merge
* -----
use aclp
merge pzctycodenum using ctydic, keep(ctycode ctyname)
order ctycode ctyname

* check merge
tab _merge
di "There are no 1 values in merge so everything ok, "
list  ctycode ctyname countryname pzctycodenum if _merge==2 
drop if _merge==2

* Sort and save
* -------------
sort ctycode year, stable
drop  countryname pzctycodenum ctyalpha
save aclp, replace
clear

