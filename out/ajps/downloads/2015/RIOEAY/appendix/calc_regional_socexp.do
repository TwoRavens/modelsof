/* This file
   calculates Regional social expenditure
   by weighting national expenditure by regional dependent population
   Definition of dependent pop: unempl., retired
 */


import excel "CntryData.xlsx", sheet("EXPORT") firstrow clear
save CntryData.dta, replace

import excel "RegionalData.xlsx", sheet("EXPORT") firstrow clear
save RegionData.dta, replace


use "../Data.dta", clear
/* exclude non-imputed data from calculation */
drop if _mi_m==0

/* share of dependent pop  */
collapse transue transre, by(region cntryn)
egen depshare = rowtotal(transue transre)

merge 1:1 region using RegionData.dta
drop _merge
merge m:1 cntryn using CntryData.dta
drop _merge

/* Weight Social exp. pC by dependent share */
gen Rsocexp = socexp2*depshare

keep region Rsocexp 
save socexp_region, replace



