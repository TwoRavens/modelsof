//This do file selects observations that were present in 2003. 
// Jiro Yoshida
// modified on 2014/2/8

cd "C:\Users\juy18\Downloads\rent_index\rri2003sample"
log using full-2003-comp, replace smcl

clear
*set mem 64m
set matsize 1000
set more off
set type double

foreach m in  ///
"Atlanta" ///
"Boston" ///
"Dallas" ///
"Detroit" ///
"Houston" ///
"Los_Angeles" ///
"Miami" ///
"San_Francisco" ///
"Seattle" ///
"Washington" ///
{
use `m'rri2003sample, clear
// add BLSI
drop _merge
cd "C:\Users\juy18\Downloads\rent_index"
merge 1:1 time using BLS_full_q

foreach var of varlist BLSFull*  {
	rename `var' `: var label `var''_BLSFull
 }

foreach var of varlist *_BLSFull  {
	label variable `var' `var'_simulated  
} 
 
foreach var of varlist numpropf*  {
	rename `var' `: var label `var''_numpropf
 }

sort time
drop if `m'rshet2003sample==.

keep time month `m'*
gen msa_name4 = "`m'"


cd "C:\Users\juy18\Downloads\rent_index\rri2003sample"

twoway (rarea `m'rshet_l `m'rshet_u time, cmissing(n) color(gs14) lwidth(none)) ///
(connected `m'rshet2003sample time, cmissing(n) msymbol(oh) mcolor(green) lcolor(green)) ///
(connected `m'_BLSFull time, cmissing(n) msymbol(th) mcolor(dkorange) lcolor(dkorange)) ///
(line `m'_BLSA_r_n time, lcolor(red) lwidth(medthick) lpattern(dash)) ///
(line `m'rshet time, lcolor(edkblue) lwidth(thick)), ///
legend(order(5 "RRI" 1 "RRI +/- 1 s.e." 2 "RRI (2003 sample)" ///
3 "Simulated BLS Index" 4 "Actual BLS Index"))
 
graph export `m'BLS2003_Full.png, replace

*twoway (connected `m'_numpropf time) (connected `m'_numprop time, msymbol(circle_hollow)), legend(label(1 "Full Sample") label(2 "2003 Sample")) ytitle("`m' Number of Properties")
*graph export `m'numprop2003_Full.png, replace

save `m'RRI_BLS_2003_Full, replace

}

log close
