**************************************************************
* For each loan ID and month, calculate associated second lien balance from Equifax
* Input: temp/full`x'.dta
* Output: temp/second_bal`x'.dta
*************************************************************

set more off
clear

foreach y of global list {
use temp/full`y'.dta, clear

gen close_datem = mofd(date(close_dt, "YMD"))
drop if mi(close_dt)
keep loan_id cid conf primary_flag ces* fm* heloc* close_datem prin_bal_amt prop_zip as_of_mon_id purpose_type orig_amt

gen purpose_refi = inlist(purpose_type, "2", "3", "5")

keep if primary_flag
replace ces_num = 0 if ces_num == .
replace heloc_num = 0 if heloc_num == .
gen num_seconds = ces_num + heloc_num
replace num_seconds = 0 if num_seconds == .
replace fm_num = 0 if fm_num == .
rename heloc_lim heloc_bal_orig
foreach v in fm ces heloc {
gen `v'_3lrg_bal_orig = `v'_bal_orig - `v'_lrg_bal_orig - `v'_2lrg_bal_orig if fm_num > 2
gen `v'_3lrg_bal = `v'_bal - `v'_lrg_bal - `v'_2lrg_bal if fm_num > 2
gen `v'_3lrg_opendt = .
}


foreach v of varlist *opendt {
gen year = floor(`v'/100)
gen month = `v'-year*100
gen `v'_datem = mofd(mdy(month, 1, year))
drop year month `v'
}

renvars *, subst(fm_lrg fm_1lrg)
renvars *, subst(ces_lrg ces_1lrg)
renvars *, subst(heloc_lrg heloc_1lrg)

* identify which EFX loan an LPS loan is matched to 
gen bal_diff1 = abs(orig_amt - fm_1lrg_bal_orig)
gen date_diff1 = abs(fm_1lrg_opendt_datem - close_datem) 

gen bal_diff2 = abs(orig_amt - fm_2lrg_bal_orig) 
gen date_diff2 = abs(fm_2lrg_opendt_datem - close_datem) 

gen bal_diff3 = abs(orig_amt - fm_3lrg_bal_orig) 
gen date_diff3 = abs(fm_3lrg_opendt_datem - close_datem )

gen match1 =  date_diff1 <= 4 & bal_diff1 < 10000
gen match2 = date_diff2 <= 4 & bal_diff2 < 10000
gen match3 = bal_diff3 < 10000

gen perfect_match1 = date_diff1 == 0 & bal_diff1 < 1 
gen perfect_match2 = date_diff2 == 0 & bal_diff2 < 1 

gen new_match = 3 if match3 == 1
replace new_match = 2 if match2 == 1
replace new_match = 1 if match1 == 1 & date_diff1 <= date_diff2 
replace new_match = 2 if perfect_match2 == 1 
replace new_match = 1 if perfect_match1 == 1


gen lps_match = 3 if fm_3lrg_bal ~= .
replace lps_match = 2 if abs(fm_2lrg_opendt_datem - close_datem) <= ///
	abs(fm_1lrg_opendt_datem - close_datem) & abs(fm_2lrg_opendt_datem - close_datem) <= 4
replace lps_match = 1  if abs(fm_2lrg_opendt_datem - close_datem) > ///
	abs(fm_1lrg_opendt_datem - close_datem) & abs(fm_1lrg_opendt_datem - close_datem) <= 4
	
tab new_match 
tab lps_match 
tab new_match lps_match 
gen match = new_match ! = .

gen second_bal = 0

* loop through all CES and HELOCs and match them to the largest loan that was opened before or within a couple of months

* add their balances to running total if that loan is the matching loan to the LPS loan   
forvalues x = 1/3 {
gen fm_match1 = 0
gen fm_match2 = 0 
gen fm_match3 = 0

replace fm_match3 = 1 if fm_num > 2
replace fm_match3 = 0 if  ces_`x'lrg_bal_orig > fm_3lrg_bal_orig

replace fm_match2 = 1 if abs(ces_`x'lrg_opendt - fm_2lrg_opendt) <= 3 & ces_`x'lrg_bal_orig <= fm_2lrg_bal_orig
replace fm_match2 = 1 if  ces_`x'lrg_opendt >= fm_2lrg_opendt & ces_`x'lrg_bal_orig <= fm_2lrg_bal_orig & !mi(ces_1lrg_opendt)
replace fm_match1 = 1 if abs(ces_`x'lrg_opendt -  fm_1lrg_opendt) <= 3 & ces_`x'lrg_bal_orig <= fm_1lrg_bal_orig
replace fm_match1 = 1 if  ces_`x'lrg_opendt >= fm_1lrg_opendt & ces_`x'lrg_bal_orig <= fm_1lrg_bal_orig & !mi(ces_1lrg_opendt)


replace second_bal = second_bal + ces_`x'lrg_bal if fm_match1 == 1 & new_match == 1 & ces_`x'lrg_bal ~= .
replace second_bal = second_bal + ces_`x'lrg_bal if fm_match2 == 1 & new_match == 2 & ces_`x'lrg_bal ~= .
replace second_bal = second_bal + ces_`x'lrg_bal if fm_match3 == 1 & new_match == 3 & ces_`x'lrg_bal ~= .

drop fm_match*

gen fm_match1 = 0
gen fm_match2 = 0 
gen fm_match3 = 0

replace fm_match3 = 1 if fm_num > 2
replace fm_match3 = 0 if  heloc_`x'lrg_bal_orig > fm_3lrg_bal_orig

replace fm_match2 = 1 if abs(heloc_`x'lrg_opendt - fm_2lrg_opendt) <= 3 & heloc_`x'lrg_bal_orig <= fm_2lrg_bal_orig
replace fm_match2 = 1 if  heloc_`x'lrg_opendt >= fm_2lrg_opendt & heloc_`x'lrg_bal_orig <= fm_2lrg_bal_orig & !mi(heloc_1lrg_opendt)
replace fm_match1 = 1 if abs(heloc_`x'lrg_opendt -  fm_1lrg_opendt) <= 3 & heloc_`x'lrg_bal_orig <= fm_1lrg_bal_orig
replace fm_match1 = 1 if  heloc_`x'lrg_opendt >= fm_1lrg_opendt & heloc_`x'lrg_bal_orig <= fm_1lrg_bal_orig & !mi(heloc_1lrg_opendt)

replace second_bal = second_bal + heloc_`x'lrg_bal if fm_match1 == 1 & new_match == 1 & heloc_`x'lrg_bal ~= .
replace second_bal = second_bal + heloc_`x'lrg_bal if fm_match2 == 1 & new_match == 2 & heloc_`x'lrg_bal ~= .
replace second_bal = second_bal + heloc_`x'lrg_bal if fm_match3 == 1 & new_match == 3 & heloc_`x'lrg_bal ~= .

drop fm_match*

}
keep loan_id as_of_mon_id  second_bal 
isid loan_id as_of_mon_id


foreach v of varlist as_of_mon_id {
gen year = floor(`v'/100)
gen month = `v'-year*100
gen datem = mofd(mdy(month, 1, year))
drop year month `v'
}

save temp/second_bal`y'.dta, replace
}


clear
foreach y of global list {
append using temp/second_bal`y'.dta
}
save temp/second_bal.dta, replace

tabstat second_bal, st(p10 p25 p50 p75 p90 mean) 

gen has_second = second_bal > 0 
tab has_second 
