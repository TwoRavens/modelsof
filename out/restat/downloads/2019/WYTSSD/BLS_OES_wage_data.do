foreach year of numlist 2006/2013 {

import excel using BLS_OES_state_M`year'_dl.xls, case(lower) clear firstrow
rename area statefip
destring statefip, replace
labmask statefip, values(state)
keep if statefip!=11 & statefip<=56

rename occ_title occname
rename occ_code occsoc
replace occsoc=trim(subinstr(occsoc,"-","",.))
replace occsoc=trim(substr(occsoc,1,6))
capture rename occ_group group
replace group="total" if occsoc=="000000"
replace group="detailed" if group==""
replace occname=lower(occname)

keep statefip st state occsoc occname group tot_emp h_mean a_mean h_median a_median a_pct75 a_pct25 h_pct75 h_pct25

destring tot_emp h_mean a_mean h_median a_median a_pct75 a_pct25 h_pct75 h_pct25 , replace force
*recode h_mean a_mean h_median a_median (missing=.c)

gen year=`year'

tempfile oes`year'
save `oes`year'', replace

}


foreach year of numlist 2006/2012 {
append using `oes`year''
}

save oeswages.dta, replace

use oeswages.dta, clear
keep if group=="detailed"
*recode tot_emp h_mean a_mean h_pct25 h_median h_pct75 a_pct25 a_median a_pct75 (missing=0)
gen occsoc_match=occsoc
replace occsoc_match="151151" if occsoc=="151041"
replace occsoc_match="151151" if occsoc=="151150"
replace occsoc_match="292034" if occsoc=="292037"
replace occsoc_match="173020" if substr(occsoc,1,5)=="17302"
replace occsoc_match="333010" if substr(occsoc,1,5)=="33301"
replace occsoc_match="333050" if substr(occsoc,1,5)=="33305"
replace occsoc_match="339030" if substr(occsoc,1,5)=="33903"
replace occsoc_match="533030" if substr(occsoc,1,5)=="53303"
preserve
collapse (mean) h_mean a_mean h_pct25 h_median h_pct75 a_pct25 a_median a_pct75 [fw=tot_emp] , by(statefip occsoc_match year)
tempfile a
save `a'
restore
collapse (sum) tot_emp, by(statefip occsoc_match year) 
merge 1:1 statefip occsoc_match year using `a', keep(match) nogen
rename occsoc_match occsoc

save oes_wage_employment.dta, replace
