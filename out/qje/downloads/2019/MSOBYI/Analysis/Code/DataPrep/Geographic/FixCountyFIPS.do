/* FixCountyFIPS.do */
* Additional data available here: http://www.ddorn.net/data/FIPS_County_Code_Changes.pdf
** MIAMI-DADE
* For all years, use Miami-Dade (FIPS 12-086) instead of Dade (FIPS 12-025).
* This county was renamed for the 2000 Census, without a change in borders. 
replace state_countyFIPS = 12086 if state_countyFIPS==12025


** SHANNON
* In 2015, Shannon County (46113) was renamed Oglala Lakota County (46102). The land area did not change. The FIPS code was changed retroactively in the REIS and perhaps other datasets.
* https://en.wikipedia.org/wiki/Oglala_Lakota_County,_South_Dakota

* Fix: use the Shannon County FIPS code for all years
replace state_countyFIPS = 46113 if state_countyFIPS==46102


** SHAWANO-MENOMINEE
* Some data sources combine Shawano county with the Menominee Indian reservation. 

* Fix: do nothing. All of our sources report separately.
*replace state_countyFIPS = 55901 if state_countyFIPS==55115
*replace state_countyFIPS = 55901 if state_countyFIPS==55078
