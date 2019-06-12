
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

insheet using $rawdir/quartile_sep_rate.csv, clear
rename payer_tin_w2_max tin
rename tax_yr year
rename quartile_entrants entq
rename quartile_mean_entrantwages wage_entq
rename quartile_mean_entrantlagwages lagwage_entq
rename quartile_separators sepq
rename quartile_mean_separatorwages wage_sepq
rename quartile_mean_separatorleadwages leadwage_sepq
rename quartile_sep_rate sep_rateq


recode  entq sepq sep_rateq (.=0)
replace wage_entq     =. if entq==0
replace lagwage_entq  =. if entq==0
replace wage_sepq     =. if sepq==0
replace leadwage_sepq =. if sepq==0

reshape wide entq wage_entq lagwage_entq sepq  wage_sepq leadwage_sepq sep_rateq, i(tin year) j(quartile)

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
entq* wage_entq* lagwage_entq* sepq*  wage_sepq* leadwage_sepq* sep_rateq*

destring unmasked_tin, replace 
drop if unmasked_tin==.

*******************************************************************************
* 2. WINZORIZE output vars
*******************************************************************************

foreach var in  {
*qui winzorize_by_year, var(`var') pct(2) yr(year)
}

*******************************************************************************
* 3. Adjust for Inflation
*******************************************************************************
local varlist "wage_entq1 wage_entq2 wage_entq3 wage_entq4 lagwage_entq1 lagwage_entq2 lagwage_entq3 lagwage_entq4 wage_sepq1 wage_sepq2 wage_sepq3 wage_sepq4 leadwage_sepq1 leadwage_sepq2 leadwage_sepq3 leadwage_sepq4"

foreach var in `varlist' {
usd2014, var(`var') yr(year) 
}

*******************************************************************************
* 4. SAVE Data
*******************************************************************************

g form="w2"
sort unmasked_tin year
saveold $dtadir/outcomes_patent_eins_sepq.dta, replace
