
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

use $dumpdir/outcomes_patent_eins_w2_inv_noninvMF.dta, clear
recode invM noninvM invF noninvF  (.=0)
replace wage_invM=. if invM==0
replace wage_invF=. if invF==0
replace wage_noninvM=. if noninvM==0
replace wage_noninvF=. if noninvF==0

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
invM noninvM invF noninvF wage_invM wage_invF wage_noninvM wage_noninvF

destring unmasked_tin, replace 
drop if unmasked_tin==.

*******************************************************************************
* 2. WINZORIZE output vars
*******************************************************************************

foreach var in invM noninvM invF noninvF wage_invM wage_invF wage_noninvM wage_noninvF {
*qui winzorize_by_year, var(`var') pct(2) yr(year)
}

*******************************************************************************
* 3. Adjust for Inflation
*******************************************************************************
local varlist "wage_invM wage_invF wage_noninvM wage_noninvF"
usd2014, var(wage_invM) yr(year) 
usd2014, var(wage_invF) yr(year) 
usd2014, var(wage_noninvM) yr(year) 
usd2014, var(wage_noninvF) yr(year) 

*******************************************************************************
* 4. SAVE Data
*******************************************************************************

g form="w2"
sort unmasked_tin year
saveold $dtadir/outcomes_patent_eins_inv_noninvMF.dta, replace
