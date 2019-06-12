set more off
local sub0 "Period before votes in press release"
local sub1 "Period with votes in press release"
local tp=1 

local W1_L=-2
local W1_H=2
local W2_L=-1
local W2_H=2
local W3_L=-1
local W3_H=1
local W4_L=0  
local W4_H=1
global TBill_rfree "tgc_repo" 

forv Wn=1/4 { // Table A.2 (CR-2D), A.4 (4D-CER), A.5 (4D-CER, Bloom)
local WS=`W`Wn'_H'-`W`Wn'_L'
use "$path3\T2pm_dissent.dta", clear //use "$path_d\bloomberg2_dissent.dta", clear //use "$path_d\bloomberg1_dissent.dta", clear
g period = 1 if year>2002  //SP_open SP_high SP_low SP_close
replace period = 1 if year==2002 & month>=2
replace period = 2 if year>2007
replace period = 2 if year==2007 & month>=3
replace period = 3 if year>2009
replace period = 3 if year==2009 & month>=7
replace period = 0 if period==.
joinby date_day using "$path1\bloomberg2_reduced.dta", unmatched(both) update // unmatched(both) update
tab _merge
drop _merge  
joinby date_day using "$path3\REPO.dta", unmatched(master) update
tab _merge
drop _merge 
sum date_FOMC //replace SP_close = S_P500_p if SP_close==. //g S_P500_p_exreturn00 = vs2_S_P500_p_exreturn //g NASDAQ_p_exreturn00 = vs2_NASDAQ_p_exreturn
local dF1=r(min)
local dF2=r(max)
sum window
local w1 = r(min)
local w1_1 = `w1'+1
local w2 = r(max) 
egen date_BS2 = group(date_BS)
tsset date_BS2 //g VIX_lag = L.VIX_p //g dif_VIX = VIX_p-VIX_lag //reg VIX_p VIX_lag //predict var_p0 //g dif2_VIX = VIX_p-var_p0 //drop var_p0

sort date_day
quietly {
foreach var of varlist S_P500_p SP_close SP_open {
g var0=ln(`var') if window==`W`Wn'_L'
g var1=ln(`var') if window==`W`Wn'_H'
bysort date_FOMC: egen var00=mean(var0)
bysort date_FOMC: egen var11=mean(var1)
g `var'_CR=var11-var00 if window==0
replace `var'_CR=ln(SP_close)-ln(SP_open) if `var'_CR==. & window==0
drop var0 var1 var00 var11
g var0 = ${TBill_rfree} if window>=`W`Wn'_L' & window<=`W`Wn'_H'
bysort date_FOMC: egen var1 = mean(var0)
g `var'_CER = `var'_CR - `WS'*ln(1+0.01*var1)/262 if window==0
replace `var'_CR=`var'_CR*(262/`WS')
replace `var'_CER=`var'_CER*(262/`WS')
drop var0 var1
}
}
drop S_P500_p_CR S_P500_p_CER SP_close_CR SP_close_CER
}
sum dissent *_CR *_CER if wind==0 //pwcorr dissent SP_open_car S_P500_p_car 

drop if year<${year_min}
keep if window1==0 //${sw_op}  //2 3
drop if period==.
label drop  _all
label variable dissent "dissent"
label def dissent_l 0 "Unanimity" 1 "Dissent"
label values dissent dissent_l
g unanimity=(dissent==0)
foreach var of varlist *_CR *_CER { //SP_CAR`Wn'
g `var'_sign = 1 if `var'>0 & `var'<.
replace `var'_sign = 0 if `var'==0
replace `var'_sign = -1 if `var'<0
g `var'_sign2 = 0 if `var'>=0 & `var'<.
replace `var'_sign2 = 1 if `var'<0
}
save "$path_d\CARS4_un_dis.dta", replace

local Vxn=1
foreach Vx in "" "R" { // "B"
use "$path_d\CARS4_un_dis.dta", clear
if `Vxn'==1 {
local varR ""
}
if `Vxn'==2 {
local varR "vce(robust)"
}
if `Vxn'==3 {
local varR "vce(bootstrap, reps(${Breps}))"
}
foreach var of varlist *_CR *_CER *_sign {
log using "${path0T`Vxn'}\\\`var'_regs_logW`Wn'.log", replace
reg `var' dissent unanimity if FOMC_public==`tp', nocons `varR' 
outreg2 using "${path0T`Vxn'}\`var'_regsW`Wn'.xls", replace
test dissent=unanimity
reg `var' dissent unanimity if period==1, nocons `varR' 
outreg2 using "${path0T`Vxn'}\`var'_regsW`Wn'.xls", append
reg `var' dissent unanimity if period==2, nocons `varR' 
outreg2 using "${path0T`Vxn'}\`var'_regsW`Wn'.xls", append
reg `var' dissent unanimity if period==3, nocons `varR' 
outreg2 using "${path0T`Vxn'}\`var'_regsW`Wn'.xls", append
reg `var' dissent unanimity if period>=2, nocons `varR' 
outreg2 using "${path0T`Vxn'}\`var'_regsW`Wn'.xls", append
reg `var' dissent unanimity if period==0, nocons `varR' 
outreg2 using "${path0T`Vxn'}\`var'_regsW`Wn'.xls", append
reg `var' dissent unanimity dissent_lag FOMC_public Kuttner_surprise ffr_nr, nocons `varR' // dif2_VIX VIX_lag dif2_S_P500_i S_P500_itv1 //dif2_VIX VIX_lag dif_index_itv index_itv 
outreg2 using "${path0T`Vxn'}\`var'_regsW`Wn'.xls", append
log close
}
collapse *_sign2, by(dissent period)
export excel using "${path0T`Vxn'}\CAR_Sign_rawW`Wn'.xls", firstrow(variables) nolabel replace
use "$path_d\CARS4_un_dis.dta", clear
collapse *_sign2, by(FOMC_public dissent)
export excel using "${path0T`Vxn'}\CAR_Sign0_rawW`Wn'.xls", firstrow(variables) nolabel replace

use "$path3\T2pm_dissent.dta", clear   //  //  //  //  //
drop if year<${year_min}
keep if FOMC_public==1  //NASDAQ_p_exreturn
g unanimity=(dissent==0)
log using "${path0T`Vxn'}\\\SPgraph_regs_log.log", replace  
reg SP_open_exreturn dissent unanimity if window==0, nocons `varR'
outreg2 using "${path0T`Vxn'}\SPgraphs_regsallW.xls", replace
test dissent=unanimity
forv k=1/3 {
reg SP_open_exreturn dissent unanimity if window==`k', nocons `varR'
outreg2 using "${path0T`Vxn'}\SPgraphs_regsallW.xls", append
test dissent=unanimity
}  
forv k=0/3 {
reg NASDAQ_p_exreturn dissent unanimity if window==`k', nocons `varR'
outreg2 using "${path0T`Vxn'}\SPgraphs_regsallW.xls", append
} 
log close   //  //  //  //  //     //  //  //  //  //     //  //  //  //  //

local Vxn=1+`Vxn'
}  //   //
}
//  //  //  //

