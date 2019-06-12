set more off
local sub0 "Period before votes in press release"
local sub1 "Period with votes in press release"
local tp=0

set more off
local sw = ${sw_op} //2 3
local sw2 = (1-${std_op})+2*`sw'
local sw3 = 262/`sw2'
local tp=1 

use "$path3\T2pm_dissent.dta", clear //use "$path_d\bloomberg2_dissent.dta", clear //use "$path_d\bloomberg1_dissent.dta", clear
g period = 1 if year>2002
replace period = 1 if year==2002 & month>=2
replace period = 2 if year>2007
replace period = 2 if year==2007 & month>=3
replace period = 3 if year>2009
replace period = 3 if year==2009 & month>=7
replace period = 0 if period==.
sum date_FOMC
local dF1=r(min)
local dF2=r(max)
sum window
local w1 = -2 //r(min)
local w1_1 = `w1'+1
local w2 = r(max) //1 //r(max)
joinby date_day using "$path1\bloomberg2_reduced.dta", unmatched(both) update // unmatched(both) update
tab _merge
drop _merge 
drop if year<${year_min}
egen date_BS2 = group(date_BS)
tsset date_BS2
//   //		//	//		//   replace SP_close = S_P500_p if SP_close==.
quietly { // TY (U.S. 10-year T-note futures), FV (5-year T-note futures), TU (2-year T-note futures), IAP (VIX index)
foreach var of varlist SP_open {  // ED (Eurodollar futures), ES (E-mini S&P500 futures)
g var0=ln(`var') if window==1 // if window==2
g var00=ln(`var') if window>=1 & window<.
g var1=ln(`var') if window==0 // 0=24 hour window //if window==-2
g var11=ln(`var') if window<=0
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
replace SP_open_WD=262*SP_open_WD
drop SP_open_exreturn
rename SP_open_WD SP_open_exreturn
//   //
quietly {  
local varR="SP_open_exreturn" // SP_close_CAR3 SP_close_exreturn S_P500_p_exreturn
g Sq_R_SP=`varR'^2
g Abs_R_SP=abs(`varR')
g SqDM_R_SP=.
g AbsDM_R_SP=.
g SqDM2_R_SP=.
g AbsDM2_R_SP=.
forv w=-1/1 {  
sum `varR' if FOMC_public_vote!=1 & window1==`w', d  //  Demeaned versions	//		//		//
replace SqDM_R_SP=(`varR'-r(mean))^2 if FOMC_public_vote!=1 & window1==`w'
replace AbsDM_R_SP=abs(`varR'-r(p50)) if FOMC_public_vote!=1 & window1==`w'
sum `varR' if FOMC_public_vote==1 & dissent==0 & window1==`w', d
replace SqDM_R_SP=(`varR'-r(mean))^2 if FOMC_public_vote==1 & dissent==0 & window1==`w'
replace AbsDM_R_SP=abs(`varR'-r(p50)) if FOMC_public_vote==1 & dissent==0 & window1==`w'
sum `varR' if FOMC_public_vote==1 & dissent==1 & window1==`w', d
replace SqDM_R_SP=(`varR'-r(mean))^2 if FOMC_public_vote==1 & dissent==1 & window1==`w'
replace AbsDM_R_SP=abs(`varR'-r(p50)) if FOMC_public_vote==1 & dissent==1 & window1==`w'
}
// Demeaned versions 2
replace SqDM2_R_SP=SqDM_R_SP if FOMC_public_vote!=1
replace AbsDM2_R_SP=AbsDM_R_SP if FOMC_public_vote!=1 
forv p=1/3 {  
forv w=-1/1 {  
sum `varR' if period==`p' & dissent==0 & window1==`w', d
replace SqDM2_R_SP=(`varR'-r(mean))^2 if period==`p' & dissent==0 & window1==`w'
replace AbsDM2_R_SP=abs(`varR'-r(p50)) if period==`p' & dissent==0 & window1==`w'
sum `varR' if period==`p' & dissent==1, d
replace SqDM2_R_SP=(`varR'-r(mean))^2 if period==`p' & dissent==1 & window1==`w'
replace AbsDM2_R_SP=abs(`varR'-r(p50)) if period==`p' & dissent==1 & window1==`w'
}
}
}
//  //
bysort window: sum Sq* Abs*
drop if window<=-2  
drop if window>=2 //keep if window==1 
save "$path3\T2pm_SQ_Abs.dta", replace 

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
use "$path3\T2pm_SQ_Abs.dta", clear //use "$path3\T2pm_SQ_Abs0.dta", clear 
keep if window1==1
local ylist "Sq_R_SP Abs_R_SP SqDM_R_SP AbsDM_R_SP SqDM2_R_SP AbsDM2_R_SP"
local i=1
foreach var of local ylist { 
if `i'==1 {
local efsave "replace"
}
if `i'>1 {
local efsave "append"
}
reg `var' dissent if period==0, `varR'   //  unanimity , nocons
outreg2 using "$path0T2\AbsSQall_P0_W3.xls", `efsave'
reg `var' dissent if period>=1, `varR'
outreg2 using "$path0T2\AbsSQall_Pub_W3.xls", `efsave'
reg `var' dissent if period==3, `varR'
outreg2 using "$path0T2\AbsSQall_P3_W3.xls", `efsave'
local i = 1+`i'		
}
capture log close
