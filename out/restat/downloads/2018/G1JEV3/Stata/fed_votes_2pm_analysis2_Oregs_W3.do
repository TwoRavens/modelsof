set more off
local tp=1 
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

use "$path3\T2pm_dissent.dta", clear //use "$path_d\bloomberg2_dissent.dta", clear //use "$path_d\bloomberg1_dissent.dta", clear
g period = 1 if year>2002
replace period = 1 if year==2002 & month>=2
replace period = 2 if year>2007
replace period = 2 if year==2007 & month>=3
replace period = 3 if year>2009
replace period = 3 if year==2009 & month>=7
replace period = 0 if period==.
joinby date_day using "$path1\bloomberg2_reduced.dta", unmatched(master) update // unmatched(both) update
tab _merge
drop _merge 
egen date_BS2 = group(date_BS)
tsset date_BS2
quietly { // TY (U.S. 10-year T-note futures), FV (5-year T-note futures), TU (2-year T-note futures), IAP (VIX index)
foreach var of varlist ED_open IAP_open ES_open TU_open FV_open TY_open ES_tickcount {  // ED (Eurodollar futures), ES (E-mini S&P500 futures)
sort date_BS2
local var2=subinstr("`var'","open","close",1)
g var0=`var' if window==1 // 1=24 hour window // if window==2
replace var0=L.`var2' if window==1 & var0==.
g var00=`var' if window>=1 & window<.
g var1=`var' if window==0 // 0
replace var1=L.`var2' if window==0 & var1==.
g var11=`var' if window<=0
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
joinby date_day using "$path3\REPO.dta", unmatched(master) update
tab _merge
drop _merge 
foreach var of varlist TBill_3M0 tgc_repo {  // ED (Eurodollar futures), ES (E-mini S&P500 futures)
sort date_BS2
g var0=`var' if window==0
g var00=`var' if window>=0 & window<.
g var1=`var' if window==-1 
g var11=`var' if window<0
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
}  //  /* ${TBill_rfree} if window==`kw1' // USA_TB10y_p ${TBill_rfree} */  
//  //

drop if year<${year_min}
keep if window1==1 // ==2  // ${sw_op}  //2 3
label variable dissent "dissent"
label def dissent_l 0 "Unanimity" 1 "Dissent"
label values dissent dissent_l
g unanimity=(dissent==0)
quietly { // TY (U.S. 10-year T-note futures), FV (5-year T-note futures), TU (2-year T-note futures), IAP (VIX index)
foreach var of varlist ED_open_WD IAP_open_WD ES_open_WD TU_open_WD FV_open_WD TY_open_WD ES_tickcount_WD { 
g `var'S1 = 1 if `var'>0 & `var'<.
replace `var'S1 = 0 if `var'==0
replace `var'S1 = -1 if `var'<0
g `var'S2 = 0 if `var'>0 & `var'<.
replace `var'S2 = 0 if `var'==0
replace `var'S2 = 1 if `var'<0
}
}
drop if period==.
save "$path_d\CARS4_un_Odis_W3all.dta", replace //keep if FOMC_public==`tp' 
save "$path_d\CARS4_un_Odis_W3.dta", replace

foreach var of varlist *_WD *_WDS1 ES_tickcount {
log using "$path0T2\`var'_regs_log_W3.log", replace  // Sign Regressions
reg `var' dissent unanimity if FOMC_public==`tp', nocons  `varR'
outreg2 using "$path0T2\`var'_regs_W3.xls", replace
reg `var' dissent unanimity if period==1, nocons `varR'
outreg2 using "$path0T2\`var'_regs_W3.xls", append
reg `var' dissent unanimity if period==2, nocons `varR'
outreg2 using "$path0T2\`var'_regs_W3.xls", append
reg `var' dissent unanimity if period==3, nocons `varR'
outreg2 using "$path0T2\`var'_regs_W3.xls", append
reg `var' dissent unanimity if period>=2, nocons `varR'
outreg2 using "$path0T2\`var'_regs_W3.xls", append
capture reg `var' dissent unanimity if period==0, nocons `varR'
capture outreg2 using "$path0T2\`var'_regs_W3.xls", append
log close
}
foreach var of varlist *_WD {
log using "$path0T2\`var'_regs_log2.log", replace  // Sign Regressions 
reg `var' dissent unanimity Kuttner_surprise if FOMC_public==`tp', nocons `varR'
outreg2 using "$path0T2\`var'_regs2_W3.xls", replace
reg `var' dissent unanimity Kuttner_surprise if period==1, nocons `varR'
outreg2 using "$path0T2\`var'_regs2_W3.xls", append
reg `var' dissent unanimity Kuttner_surprise if period==2, nocons `varR'
outreg2 using "$path0T2\`var'_regs2_W3.xls", append
reg `var' dissent unanimity Kuttner_surprise if period==3, nocons `varR'
outreg2 using "$path0T2\`var'_regs2_W3.xls", append
reg `var' dissent unanimity Kuttner_surprise if period>=2, nocons `varR'
outreg2 using "$path0T2\`var'_regs2_W3.xls", append
capture reg `var' dissent unanimity Kuttner_surprise if period==0, nocons `varR'
capture outreg2 using "$path0T2\`var'_regs2_W3.xls", append
log close
}
use "$path_d\CARS4_un_Odis_W3all.dta", clear
reg ES_tickcount_WD dissent unanimity if period==0, nocons `varR'
outreg2 using "$path0T2\Oregs2_W3nonpub.xls", replace
reg ES_tickcount_WD dissent unanimity Kuttner_surprise if period==0, nocons `varR'
outreg2 using "$path0T2\Oregs2_W3nonpub.xls", append 
reg ES_tickcount dissent unanimity if period==0, nocons `varR'
outreg2 using "$path0T2\Oregs2_W3nonpub.xls", append 
reg ES_tickcount dissent unanimity Kuttner_surprise if period==0, nocons `varR'
outreg2 using "$path0T2\Oregs2_W3nonpub.xls", append 

use "$path3\\\Tick_5min_events.dta", clear
egen nr_tick=group(hour minute)
keep date_day-year ES_tickcount ES_volume
g ES_tickcount0=ES_tickcount if hour<13
g ES_tickcount1=ES_tickcount if hour>=13
g ES_volume0=ES_volume if hour<13
g ES_volume1=ES_volume if hour>=13
collapse (sum) *volu* *tick*, by(date_day day month year)
tsset date_day
drop ES_tickcount ES_volume
g ES_tickcount0_fw=F.ES_tickcount0
g ES_tickcount=max(0,ES_tickcount0_fw)+ES_tickcount1 if ES_tickcount1<.
g ES_volume0_fw=F.ES_volume0
g ES_volume=max(0,ES_volume0_fw)+ES_volume1 if ES_volume1<.

joinby date_day using "$path1\\FED_dissent_date.dta", unmatched(master) update  //unmatched(both)
drop _merge
joinby date_day using "$path1\\FED_dissent_6dayW.dta", unmatched(master) update //joinby date_day using "$path1\\bloomberg2_dissent_window.dta", unmatched(master) update // unmatched(both) update
drop _merge
joinby date_day using "$path1\\bloomberg2_reduced.dta", unmatched(master) update
drop _merge
joinby date_day using "$path1\\yields_d.dta", unmatched(master) update //joinby date_day using "$path1\\bloomberg2_dissent2_yields_TB.dta", unmatched(master) update // unmatched(both) update
drop _merge 

drop if year<${year_min}
keep if window==0
drop if ES_tickcount==.  |  ES_tickcount==0
save "$path_d\CARS4_un_Odis_W3.dta", replace
log using "${path0T2}\\\EStickDaily_nonpub_pub.log", replace
g unanimity=(dissent==0)
reg ES_tickcount dissent unanimity if FOMC_public==0, nocons `varR'
test dissent=unanimity
outreg2 using "$path0T2\EStickDaily_nonpub_pub.xls", replace
reg ES_tickcount dissent unanimity if FOMC_public==1, nocons `varR'
test dissent=unanimity
outreg2 using "$path0T2\EStickDaily_nonpub_pub.xls", append
drop if ES_volume==.  |  ES_volume==0
reg ES_volume dissent unanimity if FOMC_public==1, nocons `varR'
test dissent=unanimity
outreg2 using "$path0T2\EStickDaily_nonpub_pub.xls", append
log close

use "$path_d\CARS4_un_Odis_W3.dta", clear
log using "${path0T2}\\\EStickDaily_nonpub_pub2.log", replace
reg ES_tickcount dissent if FOMC_public==0, `varR'
outreg2 using "$path0T2\EStickDaily_nonpub_pub2.xls", replace
reg ES_tickcount dissent if FOMC_public==1, `varR'
outreg2 using "$path0T2\EStickDaily_nonpub_pub2.xls", append
drop if ES_volume==.  |  ES_volume==0
reg ES_volume dissent if FOMC_public==1, `varR'
outreg2 using "$path0T2\EStickDaily_nonpub_pub2.xls", append
log close
