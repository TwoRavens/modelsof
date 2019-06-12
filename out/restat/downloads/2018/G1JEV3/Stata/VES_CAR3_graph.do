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

use "$path3\\Tick_daily2pm.dta", clear   //use "$path3\T2pm_dissent.dta", clear
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
g ESVol_log = ln(ES_volume)
quietly { // TY (U.S. 10-year T-note futures), FV (5-year T-note futures), TU (2-year T-note futures), IAP (VIX index)
foreach var of varlist ES_volume ESVol_log {  // ED (Eurodollar futures), ES (E-mini S&P500 futures)
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
g `var'_WS = var_temp0/var_temp1
replace `var'_WS = var_temp00/var_temp1 if `var'_WS==.
replace `var'_WS = var_temp0/var_temp11 if `var'_WS==.
replace `var'_WS = var_temp00/var_temp11 if `var'_WS==.
replace `var'_WS = 100*`var'_WS
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
g var0=ES_volume if window==-2
bysort date_FOMC: egen var_temp0 = mean(var0)
g ES_volume_change=ES_volume-var_temp0 if window>=-2 & window<=2
g ES_volume_S=100*(ES_volume/var_temp0) if window>=-2 & window<=2
drop var0 var_temp0

g var0=ESVol_log if window==-2
bysort date_FOMC: egen var_temp0 = mean(var0)
g ESVol_log_change=ESVol_log-var_temp0 if window>=-2 & window<=2
drop var0 var_temp0
drop if year<${year_min}
save "$path3\ESVol_dissent.dta", replace

use "$path3\ESVol_dissent.dta", clear 
keep if FOMC_public==1
keep if window>=-2 & window<=2 
collapse ES_volume ES_volume_change ESVol_log ESVol_log_change ES_volume_S, by(window1 dissent)
xtset dissent window1
label variable ES_volume "ES Volume Level"
label variable ES_volume_change "ES Volume Change"
label variable ES_volume_S "ES Volume Standardized"
label variable dissent "dissent"
label def dissent_l 0 "Unanimity" 1 "Dissent"
label values dissent dissent_l
xtline ES_volume, byopts(note("")) byopts(title("")) xlabel(`d_range') xtick(`d_range') xtitle("Day from FOMC decision") 
graph export "$path_g\ESVol_pub1.emf", replace  
xtline ES_volume_change, byopts(note("")) byopts(title("")) xlabel(`d_range') xtick(`d_range') xtitle("Day from FOMC decision") 
graph export "$path_g\ESVolC_pub1.emf", replace 
xtline ES_volume_S, byopts(note("")) byopts(title("")) xlabel(`d_range') xtick(`d_range') xtitle("Day from FOMC decision") 
graph export "$path_g\ESVolS_pub1.emf", replace 

label variable ESVol_log "ES Volume (Ln) Level"
label variable ESVol_log_change "ES Volume (Ln) Change"
xtline ESVol_log, byopts(note("")) byopts(title("")) xlabel(`d_range') xtick(`d_range') xtitle("Day from FOMC decision") 
graph export "$path_g\ESVol_log_pub1.emf", replace  
xtline ESVol_log_change, byopts(note("")) byopts(title("")) xlabel(`d_range') xtick(`d_range') xtitle("Day from FOMC decision") 
graph export "$path_g\ESVol_logC_pub1.emf", replace 

keep if window>=-1 & window<=2 
xtline ES_volume, byopts(note("")) byopts(title("")) xlabel(-1(1)2) xtick(-1(1)2) xtitle("Day from FOMC decision") 
graph export "$path_g\ESVol_pub2.emf", replace 
keep if window>=-1 & window<=1
xtline ES_volume, byopts(note("")) byopts(title("")) xlabel(-1(1)1) xtick(-1(1)1) xtitle("Day from FOMC decision") 
graph export "$path_g\ESVol_pub3.emf", replace 

use "$path3\ESVol_dissent.dta", clear
keep if window1==0 // ==2  // ${sw_op}  //2 3
keep if FOMC_public==`tp' 
label variable dissent "dissent"
label def dissent_l 0 "Unanimity" 1 "Dissent"
label values dissent dissent_l
g unanimity=(dissent==0)
quietly { // TY (U.S. 10-year T-note futures), FV (5-year T-note futures), TU (2-year T-note futures), IAP (VIX index)
foreach var of varlist ES_volume_WD ESVol_log_WD { 
g `var'S1 = 1 if `var'>0 & `var'<.
replace `var'S1 = 0 if `var'==0
replace `var'S1 = -1 if `var'<0
g `var'S2 = 0 if `var'>0 & `var'<.
replace `var'S2 = 0 if `var'==0
replace `var'S2 = 1 if `var'<0
}
}
drop if period==.

foreach var of varlist *_WD *_WS *_WDS1 {
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
