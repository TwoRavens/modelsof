set more off
capture log close
local tp=1 
local d_range = "-2(1)2"
local Vxn=2 // Robust standard errors only
if `Vxn'==1 {
local varR ""
}
if `Vxn'==2 {
local varR "vce(robust)"
}
if `Vxn'==3 {
local varR "vce(bootstrap, reps(${Breps}))"
}
// //

use "$path3\\T5YIFR.dta", clear  //use "D:\Docs2\CM_JM\bloomberg2.dta", clear
joinby date_day using "$path1\\FED_dissent_date.dta", unmatched(both) update
tab _merge
drop _merge
joinby date_day using "$path1\bloomberg2_reduced.dta", unmatched(master) update // unmatched(both) update
tab _merge
drop _merge 
capture drop date_BS
egen date_BS = group(date_day)
sort date_BS
tsset date_BS
quietly { // TY (U.S. 10-year T-note futures), FV (5-year T-note futures), TU (2-year T-note futures), IAP (VIX index)
foreach var of varlist T5YIFR {  // ED (Eurodollar futures), ES (E-mini S&P500 futures)
g var0=`var' if window==0 // 0=24 hour window // 1=48 hour window // if window==2
g var00=`var' if window>=1 & window<.
g var1=`var' if window==-1 //if window==-2
g var11=`var' if window<=-1
bysort date_FOMC: egen var_temp0 = mean(var0)
bysort date_FOMC: egen var_temp00 = mean(var00)
bysort date_FOMC: egen var_temp1 = mean(var1)
bysort date_FOMC: egen var_temp11 = mean(var11)
g `var'_WD = var_temp0-var_temp1
replace `var'_WD = var_temp00-var_temp1 if `var'_WD==.
replace `var'_WD = var_temp0-var_temp11 if `var'_WD==.
replace `var'_WD = var_temp00-var_temp11 if `var'_WD==.
drop var0 var1 var00 var11 var_temp0 var_temp1 var_temp00 var_temp11
}
}
g period = 1 if year>2002
replace period = 1 if year==2002 & month>=2
replace period = 2 if year>2007
replace period = 2 if year==2007 & month>=3
replace period = 3 if year>2009
replace period = 3 if year==2009 & month>=7
replace period = 0 if period==.
g var0=T5YIFR if window==-2
bysort date_FOMC: egen var_temp0 = mean(var0)
g T5YIFR_change=T5YIFR-var_temp0 if window>=-2 & window<=2
drop if year<${year_min}
save "$path3\T5YIFR_dissent.dta", replace

use "$path3\T5YIFR_dissent.dta", clear 
keep if FOMC_public==1
keep if window>=-2 & window<=2 
collapse T5YIFR T5YIFR_change, by(window1 dissent)
xtset dissent window1
label variable T5YIFR "T5YIFR Level"
label variable T5YIFR_change "T5YIFR Change"
label variable dissent "dissent"
label def dissent_l 0 "Unanimity" 1 "Dissent"
label values dissent dissent_l
xtline T5YIFR, byopts(note("")) byopts(title("")) xlabel(`d_range') xtick(`d_range') xtitle("Day from FOMC decision") 
graph export "$path_g\T5YIFR_pub1.emf", replace  
xtline T5YIFR_change, byopts(note("")) byopts(title("")) xlabel(`d_range') xtick(`d_range') xtitle("Day from FOMC decision") 
graph export "$path_g\T5YIFRC_pub1.emf", replace 

use "$path3\T5YIFR_dissent.dta", clear
keep if window1==0 // ==2  // ${sw_op}  //2 3
keep if FOMC_public==`tp' 
label variable dissent "dissent"
label def dissent_l 0 "Unanimity" 1 "Dissent"
label values dissent dissent_l
g unanimity=(dissent==0)
quietly { // TY (U.S. 10-year T-note futures), FV (5-year T-note futures), TU (2-year T-note futures), IAP (VIX index)
foreach var of varlist T5YIFR_WD { 
g `var'S1 = 1 if `var'>0 & `var'<.
replace `var'S1 = 0 if `var'==0
replace `var'S1 = -1 if `var'<0
g `var'S2 = 0 if `var'>0 & `var'<.
replace `var'S2 = 0 if `var'==0
replace `var'S2 = 1 if `var'<0
}
}
drop if period==.

foreach var of varlist *_WD *_WDS1 {
log using "$path0T2\`var'_regs_log_W3.log", replace  // Sign Regressions
reg `var' dissent unanimity, nocons  `varR'
outreg2 using "$path0T2\`var'_regs_W3.xls", replace
reg `var' dissent unanimity if period==1, nocons  `varR'
outreg2 using "$path0T2\`var'_regs_W3.xls", append
reg `var' dissent unanimity if period==2, nocons  `varR'
outreg2 using "$path0T2\`var'_regs_W3.xls", append
reg `var' dissent unanimity if period==3, nocons  `varR'
outreg2 using "$path0T2\`var'_regs_W3.xls", append
reg `var' dissent unanimity if period>=2, nocons  `varR'
outreg2 using "$path0T2\`var'_regs_W3.xls", append
log close
}
//   //
