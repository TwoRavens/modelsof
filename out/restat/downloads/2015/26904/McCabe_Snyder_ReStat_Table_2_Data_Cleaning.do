log using McCabe_Snyder_ReStat_Table_2_Data_Cleaning, replace

**********************************************************************
*
* Program McCabe_Snyder_ReStat_Table_2_Data_Cleaning.DO
* 
* Cleans data used by McCabe_Snyder_ReStat_Table_2.do.  This way a
* clean dataset can be posted on the journal website.  Uses 
* information collected by research assistants on subsample of 1,500 
* articles.   
*
* McCabe & Snyder August 2013
*
**********************************************************************

set more 1

use titles
sort issn
keep issn journaltitle
rename journaltitle jrnlfull
save titlestemp, replace
use subfield
sort issn
merge 1:1 issn using titlestemp
erase titlestemp.dta
keep jrnlfull subfield
replace jrnlfull = upper(trim(jrnlfull))
gen cje = "CANADIAN JOURNAL OF ECONOMICS"
replace jrnlfull = cje if strpos(jrnlfull,cje) > 0 
gen jite = "JOURNAL OF INSTITUTIONAL AND THEORETICAL ECONOMICS"
replace jrnlfull = jite if strpos(jrnlfull,jite) > 0 
sort jrnlfull
save subfieldtemp, replace
clear all

import excel using FaulknerReferences.xls, firstrow clear

gen cje = "CANADIAN JOURNAL OF ECONOMICS"
replace jrnlfull = cje if strpos(jrnlfull,cje) > 0 
gen jite = "JOURNAL OF INSTITUTIONAL AND THEORETICAL ECONOMICS"
replace jrnlfull = jite if strpos(jrnlfull,jite) > 0 
sort jrnlfull
replace jrnlfull = upper(trim(jrnlfull))
merge m:1 jrnlfull using subfieldtemp
erase subfieldtemp.dta

destring ref, gen(refnum) force
drop ref
rename refnum ref
save McCabe_Snyder_ReStat_references, replace
