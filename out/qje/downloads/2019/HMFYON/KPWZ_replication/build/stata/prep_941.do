/*
*Load Data
import delimited "$rawdir_ks/brtf_f941_2000.csv", clear 
drop if totcomp==.
tostring tax_prd, replace
g year = substr(tax_prd,1,4)
g quarter = substr(tax_prd,5,6) 
drop tax_prd

 
*keep if year == "2001"
export delimited "$rawdir/brtf_f941.csv"
*/

*PATENT SPINE
use $dtadir/einXyear_spine.dta, clear
sort unmasked_tin
merge m:1 unmasked_tin using $dtadir/tin_ein_xwalk.dta
keep if _merge==3
drop _merge
tempfile tin_year_spine
sort tin
save `tin_year_spine'

*LOAD DATA
*import delimited "$rawdir/brtf_f941.csv", clear
*sort tin year
forv y = 2001/2018{
disp "`y'"
use if year==`y' using $dumpdir/patent_eins_941.dta, clear
merge m:1 tin year using `tin_year_spine'

tab _merge
keep if _merge==3
drop _merge
sort unmasked_tin year
save $dumpdir/patent_eins_941_`y'.dta, replace
}


