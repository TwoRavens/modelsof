
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

insheet using $rawdir/mean_quartile_entrant3s.csv, clear
rename payer_tin_w2_max tin
rename tax_yr year
rename quartile_entrant3s ent3q
rename mean_entrant3_q_wages wage_ent3q

*merge to spine
sort tin year
merge m:1 tin year using `tin_year_spine'
tab _merge
keep if _merge==3
drop _merge

recode ent3q (.=0)
replace wage_ent3q =. if ent3q==0
reshape wide wage_ent3q ent3q, i(tin year) j(quartile)

*******************************************************************************
*1.1 LOAD WAGE DATA
*******************************************************************************

duplicates drop
keep unmasked_tin year  ///
wage_ent3q* ent3q*

destring unmasked_tin, replace 
drop if unmasked_tin==.

*******************************************************************************
* 2. WINZORIZE output vars
*******************************************************************************

foreach var in wage_ent3q1 wage_ent3q2 wage_ent3q3 wage_ent3q4 {
*qui winzorize_by_year, var(`var') pct(2) yr(year)
}

*******************************************************************************
* 3. Adjust for Inflation
*******************************************************************************
local varlist "wage_ent3q1 wage_ent3q2 wage_ent3q3 wage_ent3q4"

foreach var in `varlist' {
usd2014, var(`var') yr(year) 
}

*******************************************************************************
* 4. SAVE Data
*******************************************************************************

g form="w2"
sort unmasked_tin year
saveold $dtadir/outcomes_patent_eins_entrants3q.dta, replace
