clear
set more off
set mem 900m
set matsize 1000
set scheme s2mono

cd "C:\Users\sfreedm\Documents\My Dropbox\toy-replication-files\pgm"

/****************
Changes in Sales for top 10 firms 
and top firms outside of China
*****************/

use ..\data\toys_qtr, clear

replace units = units/1000

collapse (sum) units transactions, by(parent_company year_qt)

*Keep top 10 firms and top 2 not made in China firms
sort parent_company
merge parent_company using ..\data\firmranks, nokeep
drop _merge
keep if rank_units <= 10 | parent_company=="AMERICAN PLASTIC TOYS" | parent_company == "PLAYMOBIL"

reshape wide units transactions, i(parent_company) j(year_qt) 

gen q4perchng07 = (units200704-units200604)/units200604
gen ratio06_q1 = units200604/units200601
gen ratio07_q1 = units200704/units200701
gen ratperch_q1 = (ratio07_q1- ratio06_q1)/ratio06_q1

keep units200601 units200604 units200701 units200704 transactions200604 q4perchng07 ratperch_q1 parent_company rank_units

*Calculations for total market
preserve
use ..\data\toys_qtr, clear
replace units = units/1000

collapse (sum) units transactions, by(year_qt)
gen parent_company = "TOTAL MARKET"
gen rank_units = 0
reshape wide units transactions, i(parent_company) j(year_qt) 

gen q4perchng07 = (units200704-units200604)/units200604
gen ratio06_q1 = units200604/units200601
gen ratio07_q1 = units200704/units200701
gen ratperch_q1 = (ratio07_q1- ratio06_q1)/ratio06_q1

keep units200601 units200604 units200701 units200704 transactions200604 q4perchng07 ratperch_q1 parent_company rank_units
order parent_company rank_units units* q4perchng07 ratperch_q1 transactions200604
tempfile totalmarket
save `totalmarket'
restore

append using `totalmarket'

order parent_company rank_units units* q4perchng07 ratperch_q1 transactions200604
sort rank_units

outsheet using ..\output\table3.csv, c replace
