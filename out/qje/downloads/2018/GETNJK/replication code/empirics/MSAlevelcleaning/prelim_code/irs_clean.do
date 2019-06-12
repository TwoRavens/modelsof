* This code takes csv files downloaded from IRS as $input, converts them into MSA-year level income panel.
* IRS: https://www.irs.gov/statistics/soi-tax-stats-individual-income-tax-statistics-zip-code-data-soi

clear all

set more off
global input = "input/IRS"

*since the csv files have different names in roughly each year, we need to load them separately
import delimited using $input/2007zipcode/zipcode07.csv, varnames(1) stringcols(2) clear
gen year = 2007
save temp/tax_07, replace

import delimited using $input/2008zipcode/08zpall.csv, varnames(1) stringcols(2) clear
gen year = 2008
save temp/tax_08, replace

import delimited $input/2009zipcode/09zpallagi.csv, varnames(1) stringcols(3) clear
gen year = 2009
save temp/tax_09, replace

import delimited using $input/2010zipcode/10zpallagi.csv, varnames(1) stringcols(3) clear
gen year = 2010
save temp/tax_10, replace

use temp/tax_10, clear
foreach y in 07 08 09 {
append using temp/tax_`y'
}
replace agi_class = 0 if agi_class == .
replace agi_stub = 0 if agi_stub == .
gen agi_cat = agi_class + agi_stub
drop agi_class agi_stub

tab agi_cat   year , m

// 2007/8 have one more category; then 1 and 2 got merged
replace agi_cat = max(agi_cat-1, 1) if year<2009 

save temp/merged, replace

rename zipcode prop_zip
merge m:1 prop_zip using input/zipTOmsa
drop if _m<3 

replace msa = msa_div if msa_div!=.

drop if msa == . 
drop if n1 <1 
sort prop_zip year agi_cat
save temp/panel, replace

// all
preserve
	collapse (sum) n1 a00100 n00200 a00200 , by (msa year)
	foreach x in 1 2 {
	replace a00`x'00 = a00`x'00 * 1000 if year == 2009 | year == 2010
	}
	gen avg_grossinc = a00100/n1
	gen avg_wagesalincome = a00200/n1  
	drop n00200
	save tmp.tmp, replace
restore

// only including those with under 200k adjusted gross income
drop if agi_cat==6
collapse (sum) n1 a00100 n00200 a00200 , by (msa year)
foreach x in 1 2 {
replace a00`x'00 = a00`x'00 * 1000 if year == 2009 | year == 2010
}
gen avg_grossinc_under200k = a00100/n1
gen avg_wagesalincome_under200k = a00200/n1  
drop n1 a00100 n00200 a00200

merge 1:1 msa year using tmp.tmp, nogen

save output/msa_year_income_all, replace 




