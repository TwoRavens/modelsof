
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
use $dtadir_ks/f1125e.dta, clear
rename firm_tin tin
rename tax_yr year

keep tin year owner_tin amt_comp

*make unique at owner - firm year level
gsort tin year -amt_comp 
egen tag=tag(tin owner_tin year)
tab tag
keep if tag ==1
drop tag

*construct onwer count and firm level aggregates
g num_off=1
collapse (sum) num_off amt_comp, by(tin year)


*merge to spine
sort tin year
merge m:1 tin year using `tin_year_spine'
tab _merge
keep if _merge==3
drop _merge

*******************************************************************************
*1.1 LOAD WAGE DATA
*******************************************************************************

keep unmasked_tin year  ///
num_off amt_comp

duplicates drop

rename amt_comp wb_off
g wage_off=wb_off/num_off
replace wage_off =. if num_off==0
replace wage_off =. if wage_off==0
replace wage_off =. if wage_off<0 & !mi(wage_off)


destring unmasked_tin, replace 
drop if unmasked_tin==.

*******************************************************************************
* 2. WINZORIZE output vars
*******************************************************************************

*******************************************************************************
* 3. Adjust for Inflation
*******************************************************************************
usd2014, var(wb_off) yr(year) 
usd2014, var(wage_off) yr(year) 

*******************************************************************************
* 4. SAVE Data
*******************************************************************************


g form="1125e"
sort unmasked_tin year
save $dtadir/outcomes_patent_wages_1125e.dta, replace
