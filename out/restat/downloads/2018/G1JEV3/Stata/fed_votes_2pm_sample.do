set more off
local sw =  ${sw_op}

use "$path1\bloomberg2.dta", clear
joinby date_day using "$path1\bloomberg1_dissent.dta", unmatched(both) update
drop DAX* FTSE100* CAC40* IBEX* SMI* _merge
joinby date_day using "$path1\\FED_dissent_6dayW.dta", unmatched(master) update 
tab _merge
drop _merge
joinby date_day using "$path1\\yields_d.dta", unmatched(master) update 
tab _merge
drop _merge
capture drop sample1
save "$path1\bloomberg2_reduced.dta", replace

use "$path3\\Tick_daily2pm.dta", clear  //use "D:\Docs2\CM_JM\bloomberg2.dta", clear
joinby date_day using "$path1\\FED_dissent_date.dta", unmatched(both) update  //unmatched(both)
tab _merge
drop _merge
joinby date_day using "$path1\\FED_dissent_6dayW.dta", unmatched(master) update //joinby date_day using "$path1\\bloomberg2_dissent_window.dta", unmatched(master) update // unmatched(both) update
tab _merge
drop _merge
joinby date_day using "$path1\\bloomberg2_reduced.dta", unmatched(master) update
tab _merge
drop _merge

sum date_FOMC
local dF1=r(min)
local dF2=r(max)
g sample1 = 1 if window1!=.
sum sample* window*
sort date_BS
tsset date_BS
save "$path3\T2pm_dissent.dta", replace

use "$path3\T2pm_dissent.dta", clear
local sw2 = (1-${std_op})+2*`sw'
bysort date_FOMC: egen SW2=min(window1)
replace SW2 = min(1, window1-SW2)
bysort date_FOMC: egen SW3=max(window1)
replace SW3 = min(1, SW3-SW2)
display "`sw2'"
quietly {
foreach var of varlist SP_open NASDAQ_p { // SP_close S_P500_p American, American Tech, German, UK, Frence, Spain and Swiss stock returns
g `var'_exreturn = ln(`var')
forv d=`dF1'/`dF2' {
sum window if date_FOMC==`d' & `var'_exreturn <.
local dbw = r(min)
sum `var'_exreturn if date_FOMC==`d' & window==`dbw' & `var'_exreturn <.
local dbm0 = r(min)
replace `var'_exreturn = `var'_exreturn-`dbm0' if date_FOMC==`d' 
}
replace `var'_exreturn = (262/SW3)*`var'_exreturn // (262/SW2)* Annualize excess returns //(262/`sw2')* 
}
}
capture drop _merge  //g original_SP_close_exreturn = SP_close_exreturn //g original_S_P500_p_exreturn = S_P500_p_exreturn 
keep if sample1==1
drop sample* 
sum date_day if FOMC_session_public==1
local d_pmin = r(min)-`sw'-1-3
g FOMC_public = FOMC_session_public  // Time window over which FOMC votes were public
replace FOMC_public = 1 if date_day>`d_pmin'  
save "$path3\T2pm_dissent.dta", replace
