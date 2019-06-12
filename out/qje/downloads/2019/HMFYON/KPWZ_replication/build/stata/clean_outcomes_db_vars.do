
*******************************************************************************
*******************************************************************************
* BUILD WAGE OUTCOMES 
*******************************************************************************
*******************************************************************************
set more off
clear 
set maxvar 8000

*******************************************************************************
*0.1 KEEP EINS WITH WAGE OUTCOMES OF EINS IN SPINE (WITH TINS)
*******************************************************************************

use $dtadir/einXyear_spine.dta, clear
sort unmasked_tin
merge m:1 unmasked_tin using $dtadir/tin_ein_xwalk.dta
keep if _merge==3
drop _merge
tempfile tin_year_spine
sort tin
save `tin_year_spine'

*******************************************************************************
*1.0 LOAD WAGE DATA COMPONENTS
*******************************************************************************

use $dumpdir/outcomes_patent_db_vars.dta, clear

replace age=. if age>150 & !mi(age)
replace age=. if age<=0 & !mi(age)

recode n_over40 n_under40 n_college n_tax (.=0)

*merge to spine
sort tin year
merge 1:1 tin year using `tin_year_spine'
tab _merge
keep if _merge==3
drop _merge

*******************************************************************************
*1.1 LOAD WAGE DATA
*******************************************************************************

duplicates drop
keep unmasked_tin year  ///
age n_over40 n_under40 wage_over40 wage_under40 share_college n_college avg_tax n_tax

destring unmasked_tin, replace 
drop if unmasked_tin==.

*******************************************************************************
* 2. WINZORIZE output vars
*******************************************************************************

foreach var in wagegr3 ents_who_stay_3 wagegr3dhs {
*qui winzorize_by_year, var(`var') pct(2) yr(year)
}

*******************************************************************************
* 3. Adjust for Inflation
*******************************************************************************
usd2014, var(wage_over40) yr(year) 
usd2014, var(wage_under40) yr(year) 
usd2014, var(avg_tax) yr(year) 

*******************************************************************************
* 4. SAVE Data
*******************************************************************************
g form="w2"
sort unmasked_tin year
save $dtadir/outcomes_patent_db_vars.dta, replace
