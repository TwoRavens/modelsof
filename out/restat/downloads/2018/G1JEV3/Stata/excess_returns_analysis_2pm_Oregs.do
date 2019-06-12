set more off
capture log close

use "$path3\\Tick_daily2pm.dta", clear  //use "D:\Docs2\CM_JM\bloomberg2.dta", clear
replace Fed_fund_rate_futures_p = 100-Fed_fund_rate_futures_p
replace Euro_dollar_futures_3m_p = 100-Euro_dollar_futures_3m_p
tsset date_day
capture drop date_BS
egen date_BS = group(date_day)
sort date_BS
tsset date_BS
quietly { // TY (U.S. 10-year T-note futures), FV (5-year T-note futures), TU (2-year T-note futures), IAP (VIX index)
foreach var of varlist ED_open IAP_open ES_open TU_open FV_open TY_open {  // ED (Eurodollar futures), ES (E-mini S&P500 futures)
g `var'0 = F.`var' //L.`var'  // S_P500_p S_P500_p NASDAQ_p DAX_p FTSE100_p CAC40_p IBEX_p SMI_p
g `var'_exr = `var'0-`var' //`var'-`var'0 //ED_close IAP_close ES_close TU_close FV_close TY_close SP_close
drop  `var'0  //replace `var'_exreturn = (262/`sw2')*`var'_exreturn // Annualize excess returns
}
}  
quietly {
foreach var of varlist SP_open { //SP_close S_P500_p NASDAQ_p DAX_p FTSE100_p CAC40_p IBEX_p SMI_p
g `var'0 = F.`var'  //L.`var'
g `var'_exreturn = ln(`var'0)-ln(`var') //ln(`var')-ln(`var'0)
replace `var'_exreturn = 262*`var'_exreturn // Annualize excess returns 
drop  `var'0  //replace `var'_exreturn = (262/`sw2')*`var'_exreturn // Annualize excess returns
}
}
sum date_FOMC
local dF1=r(min)
local dF2=r(max)
sum window
local w1 = r(min)
sum date_FOMC-FOMC_session_public window1

sum date_day if FOMC_session_public<.
drop if date_day<r(min)-10
sum date_day if FOMC_session_public==1
local dp1 = r(min)-10
local dp0 = `dp1'-1
sum date_day if FOMC_session_public==1 //sum date_day if month==3 & year==2002 *drop if date_day<r(min)-9 *drop if date_day>r(max)+5 

g VIX_lag = L.VIX_p
g dif_VIX = VIX_p-VIX_lag
reg VIX_p VIX_lag
predict var_p0
g dif2_VIX = VIX_p-var_p0
drop var_p0

g window1_new = window1 if window1==0
g var1=L.window1_new
g var0=F.window1_new
replace window1_new = 1 if window1_new==. & var1==0
replace window1_new = -1 if window1_new==. & var0==0
tab window1_new window1
sum window1_new window1
sum window1_new window1 if window1>=-1 & window1<=1
drop window1 var0 var1 
rename window1_new window1
quietly {
foreach var of varlist dissent dissent_lag { 
g var0 = L.`var'
g var1 = F.`var'
replace `var' = var0 if `var'==. & window1<.
replace `var' = var1 if `var'==. & window1<.
drop var0 var1  
}
}
sum dissent dissent_lag window1 date_FOMC if window1<.
sum dissent dissent_lag window1 date_FOMC if window1==0
tab window1 

g window2 = 9
replace window2 = window1 if window1>=-1 & window1<=1
replace window2 = window2 +1
g dissent2 = 9
replace dissent2 = dissent if window1>=-1 & window1<=1
g window2_u = window2 if dissent2==0
replace window2_u = 10 if window2_u==.
g window2_d = window2 if dissent2==1
replace window2_d = 10 if window2_d==.

g window3 = 0 
replace window3 = 2+window1 if window1>=-1 & window1<=1 & dissent2==0 & date_day>=`dp1'
replace window3 = 5+window1 if window1>=-1 & window1<=1 & dissent2==1 & date_day>=`dp1'
replace window3 = 8+window1 if window1>=-1 & window1<=1 & date_day<`dp1'

g nr_diss0 = 0 
replace nr_diss0 = nr_dissents if window1>=-1 & window1<=1 & dissent2<. & date_day>=`dp1'

g dissent_lag0 = 0 
replace dissent_lag0 = dissent_lag if window1>=-1 & window1<=1 & dissent2<. & date_day>=`dp1'

label variable window3 "FOMC_outcome"
label def window_l3 0 "No Meeting" 1 "Day before U" 2 "Day of U" 3 "Day after U"  4 "Day before D" 5 "Day of D" 6 "Day after D" 7 "Day before F" 8 "Day of F" 9 "Day after F"
label values window3 window_l3
label variable window2 "FOMC_day"
label def window_l 0 "Day Before" 1 "FOMC day" 2 "Day After" 10 "No meeting"
label values window2 window_l
label values window2_u window_l
label values window2_d window_l

//   //
label variable dissent "dissent"
label def dissent_l 9 "No meeting" 0 "Unanimity" 1 "Dissent"
label values dissent dissent_l
label values dissent2 dissent_l
g FOMC_unscheduled0 = FOMC_unscheduled if window1>=-1 & window1<=1
bysort date_FOMC: egen FOMC_unscheduled1 = max(FOMC_unscheduled0) if window1>=-1 & window1<=1
replace FOMC_unscheduled1=0 if FOMC_unscheduled1==.
tab FOMC_unscheduled1
g USA_TB10year = 0.01*USA_TB10y_p 
g USA_TB5year = 0.01*YTM_5Y
g USA_TB1year = 0.01*YTM_1Y

capture log close
drop if year<1993
quietly { // Explanatory variables are lags of 2 days
tsset date_BS
foreach var of varlist VIX_lag { // dif_index_itv index_itv dif_index_dv index_dv
g var0 = L.`var' //L2 L /* */
rename `var' O_`var'
rename var0 `var' 
}
foreach var of varlist dif2_VIX USA_TB1year USA_TB5year USA_TB10year { //Kuttner_surprise ffr_nr USA_TB1year USA_TB5year
g var0 = L2.`var' //L3 L2 L
rename `var' O_`var'
rename var0 `var' 
}
} //local ylist "SP_close_exr ED_close_exr IAP_close_exr ES_close_exr TU_close_exr FV_close_exr TY_close_exr" //S_P500_p_e NASDAQ_p_e DAX_p_e FTSE100_p_e CAC40_p_e IBEX_p_e SMI_p_e
local ylist "SP_open_exr" // SP_close_exr
local xvars "dif2_VIX VIX_lag Kuttner_surprise ffr_nr FOMC_unscheduled1 RecessionDummy TighteningCycleDummy EasingCycleDummy"
local xvars2 "`xvars' USA_TB1year USA_TB5year USA_TB10year" // Most of these variables are TB Futures

local Vxn=1
foreach Vx in "" "R" { // "B"
if `Vxn'==1 {
local varR ""
}
if `Vxn'==2 {
local varR "vce(robust)"
}
if `Vxn'==3 {
local varR "vce(bootstrap, reps(${Breps}))"
}
local i = 1

foreach var of local ylist { 
local vy =  word("`ylist'",`i')
if `i'==1  {
local vsave = "replace"
}
else {
local vsave = "append"
}
log using "${path0T`Vxn'}\\Ox_`vy'_regs.log", replace 
reg `vy' i.(window3) dissent_lag0 `xvars', `varR'
test 4.window3+5.window3+6.window3=0 // Wald test for Dissent different than 0
test 4.window3+5.window3+6.window3=1.window3+2.window3+3.window3 // Wald test for Dissent different than Unanimity
outreg2 using "${path0T`Vxn'}\\\Oreg_exr_x_ally.xls", replace //`vsave'
qreg `vy' i.(window3) dissent_lag0 `xvars', `varR'
test 4.window3+5.window3+6.window3=0 // Wald test for Dissent different than 0
test 4.window3+5.window3+6.window3=1.window3+2.window3+3.window3 // Wald test for Dissent different than Unanimity
outreg2 using "${path0T`Vxn'}\\\Oqreg_exr_x_ally.xls", replace //`vsave'
//   //   //
reg `vy' i.(window3) dissent_lag0 `xvars2', `varR'
test 4.window3+5.window3+6.window3=0 // Wald test for Dissent different than 0
test 4.window3+5.window3+6.window3=1.window3+2.window3+3.window3 // Wald test for Dissent different than Unanimity
outreg2 using "${path0T`Vxn'}\\Oreg_exr_x_ally.xls", append          //Oreg_exr_x_ally2.xls", `vsave'
qreg `vy' i.(window3) dissent_lag0 `xvars2', `varR'
test 4.window3+5.window3+6.window3=0 // Wald test for Dissent different than 0
test 4.window3+5.window3+6.window3=1.window3+2.window3+3.window3 // Wald test for Dissent different than Unanimity
outreg2 using "${path0T`Vxn'}\\Oqreg_exr_x_ally.xls", append //Oqreg_exr_x_ally2.xls", `vsave'
//   //   //
reg `vy' i.(window3) `xvars', `varR'
test 4.window3+5.window3+6.window3=0 // Wald test for Dissent different than 0
test 4.window3+5.window3+6.window3=1.window3+2.window3+3.window3 // Wald test for Dissent different than Unanimity
outreg2 using "${path0T`Vxn'}\Oreg_exr_x_ally.xls", append    //Oreg_exr_x_ally_nolag.xls", `vsave'
qreg `vy' i.(window3) `xvars', `varR'
test 4.window3+5.window3+6.window3=0 // Wald test for Dissent different than 0
test 4.window3+5.window3+6.window3=1.window3+2.window3+3.window3 // Wald test for Dissent different than Unanimity
outreg2 using "${path0T`Vxn'}\\Oqreg_exr_x_ally.xls", append    //Oqreg_exr_x_ally_nolag.xls", `vsave'
//      //    //
reg `vy' i.(window3), `varR' //dissent_lag0 
test 4.window3+5.window3+6.window3=0 // Wald test for Dissent different than 0
test 4.window3+5.window3+6.window3=1.window3+2.window3+3.window3 // Wald test for Dissent different than Unanimity
outreg2 using "${path0T`Vxn'}\\Oreg_exr_x_ally.xls", append  //Oreg_exr_x_ally0.xls", `vsave'
qreg `vy' i.(window3), `varR' //dissent_lag0 
test 4.window3+5.window3+6.window3=0 // Wald test for Dissent different than 0
test 4.window3+5.window3+6.window3=1.window3+2.window3+3.window3 // Wald test for Dissent different than Unanimity
outreg2 using "${path0T`Vxn'}\\Oqreg_exr_x_ally.xls", append   //Oqreg_exr_x_ally0.xls", `vsave'
//      //    //
log close
local i = 1+`i'		
}
local Vxn=1+`Vxn'
}
clear 
