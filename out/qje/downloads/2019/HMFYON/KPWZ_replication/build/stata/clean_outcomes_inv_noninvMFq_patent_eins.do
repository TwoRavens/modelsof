
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

insheet using $rawdir/quartile_gender_inventor.csv, clear

rename payer_tin_w2_max tin
rename tax_yr year
rename mean_male_q_wages wageMq
rename quartile_males Mq
rename mean_female_q_wages wageFq
rename quartile_females Fq

*drop 3way interactions
keep tin year quartile wageMq Mq wageFq Fq

*merge to spine
sort tin year
merge m:1 tin year using `tin_year_spine'
tab _merge
keep if _merge==3
drop _merge

recode  Mq Fq (.=0)
replace wageMq=. if Mq==0
replace wageFq=. if Fq==0

reshape wide wageMq Mq wageFq Fq, i(tin year) j(quartile)

*******************************************************************************
*1.1 LOAD WAGE DATA
*******************************************************************************

duplicates drop
keep unmasked_tin year  ///
wageMq* Mq* wageFq* Fq*

destring unmasked_tin, replace 
drop if unmasked_tin==.

*******************************************************************************
* 2. WINZORIZE output vars
*******************************************************************************

foreach var in wageMq1 wageMq2 wageMq3 wageMq4 wageFq1 wageFq2 wageFq3 wageFq4 {
*qui winzorize_by_year, var(`var') pct(2) yr(year)
}

*******************************************************************************
* 3. Adjust for Inflation
*******************************************************************************
local varlist "wageMq1 wageMq2 wageMq3 wageMq4 wageFq1 wageFq2 wageFq3 wageFq4"

foreach var in `varlist' {
usd2014, var(`var') yr(year) 
}

*******************************************************************************
* 4. SAVE Data
*******************************************************************************

g form="w2"
sort unmasked_tin year
saveold $dtadir/outcomes_patent_eins_inv_noninvMFq.dta, replace
