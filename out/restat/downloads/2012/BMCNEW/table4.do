clear
set more off
set mem 900m
set matsize 1000
set scheme s2mono

cd "C:\Users\sfreedm\Documents\My Dropbox\toy-replication-files\pgm"


/****************
Share of top firms in each toy category
*****************/

use ..\data\toys_qtr, clear

replace units = units/1000

collapse (sum) units, by(parent_company category year_qt)

*Keep top 10 firms and top 2 not made in China firms
sort parent_company
merge parent_company using ..\data\firmranks, nokeep
drop _merge
keep if rank_units <= 10 | parent_company=="AMERICAN PLASTIC TOYS" | parent_company == "PLAYMOBIL"

bysort parent_company year_qt: egen total_u = total(units)
gen share = units/total_u
keep if year_qt == 200604
keep parent_company category rank_units share
gen sharesq = (share*100)*(share*100)
reshape wide share sharesq, i(parent_company) j(category)
foreach var of varlist share* {
	replace `var' = 0 if `var'==.
}
egen hhi = rowtotal(sharesq*)
drop sharesq*
order parent_company rank_units
sort rank_units

outsheet using ..\output\table4.csv, c replace
