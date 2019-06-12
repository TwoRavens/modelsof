******************************************************************************
*                                                                            *
* Michael Poznansky and Matt K. Scroggs                                      *
* "Ballots and Blackmail: Coercive Bargaining and the Democratic Peace"      *
* International Studies Quarterly                                            *
*                                                                            *
******************************************************************************


* Purpose
* This Stata do file walks through the process of cleaning dataset in preparation for running the Aronow et. al. sandwich estimator R script.
*
* https://dataverse.harvard.edu/dataverse/mkscroggs
*
* Version 1.0
* Last updated: January 15, 2016

*(1) Find R script from Aronow et al. (2015) here: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/OMJYE5
*(2) Use "5-russett-oneal-reanalysis.R"
*(3) Change directory, name of dataset for R to read, and relevant covariates

**************
*Paper Models*
**************

clear
set more off
cd $dir
use "PoznanskyScroggsISQ.dta", clear

*Generate unique IDs per Aronow et al. (2015)
rename ccode1 statea
rename ccode2 stateb
gen dyadid = (statea*1000)+stateb

*Drop any observations that are not politically relevant dyads

drop if polrev<1

*Keep only the variables of interest

keep statea stateb dyadid mct polyprod polity_low polity_both lowdpnd alliance1 conttype2 cincratio absidealdiff time time_sq time_cu

*Drop any missing observations

drop if missing(polyprod)
drop if missing(lowdpnd)
drop if missing(alliance1)
drop if missing(conttype2)
drop if missing(cincratio)
drop if missing(absidealdiff)

saveold "lowdpnd_sandwich.dta", replace

******************
*for UN_affinity2*
******************

clear
set more off
cd $dir
use "PoznanskyScroggsISQ.dta", clear

*Generate unique IDs according to Aronow et al. (2015)
rename ccode1 statea
rename ccode2 stateb
gen dyadid = (statea*1000)+stateb

*Drop any obs that are not politically relevant dyads

drop if polrev<1

*Keep only the variables of interest

keep statea stateb dyadid mct polyprod polity_low polity_both lowdpnd alliance1 conttype2 cincratio UN_affinity2 time time_sq time_cu

*Drop any missing data

drop if missing(polyprod)
drop if missing(lowdpnd)
drop if missing(alliance1)
drop if missing(conttype2)
drop if missing(cincratio)
drop if missing(UN_affinity2)

saveold "UNaffinity_sandwich.dta", replace

************
*for lowCIE*
************

clear
set more off
cd $dir
use "PoznanskyScroggsISQ.dta", clear

*Generate unique IDs according to Aronow et al. (2015)
rename ccode1 statea
rename ccode2 stateb
gen dyadid = (statea*1000)+stateb

*Drop any obs that are not politically relevant dyads

drop if polrev<1

*Keep only the variables of interest

keep statea stateb dyadid mct polyprod polity_low polity_both lowdpnd lowCIE alliance1 conttype2 cincratio absidealdiff time time_sq time_cu

*Drop any missing data

drop if missing(polyprod)
drop if missing(lowdpnd)
drop if missing(lowCIE)
drop if missing(alliance1)
drop if missing(conttype2)
drop if missing(cincratio)
drop if missing(absidealdiff)

saveold "lowCIE_sandwich.dta", replace

***************************
*for UNAffinity and lowCIE*
***************************

clear
set more off
cd $dir
use "PoznanskyScroggsISQ.dta", clear

*Generate unique IDs according to Aronow et al. (2015)
rename ccode1 statea
rename ccode2 stateb
gen dyadid = (statea*1000)+stateb

*Drop any obs that are not politically relevant dyads

drop if polrev<1

*Keep only the variables of interest

keep statea stateb dyadid mct polyprod polity_low polity_both lowdpnd lowCIE alliance1 conttype2 cincratio UN_affinity2 time time_sq time_cu

*Drop any missing data

drop if missing(polyprod)
drop if missing(lowdpnd)
drop if missing(lowCIE)
drop if missing(alliance1)
drop if missing(conttype2)
drop if missing(cincratio)
drop if missing(UN_affinity2)

saveold "UNAffinityCIE_sandwich.dta", replace
