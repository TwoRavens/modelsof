set more off
capture log close
use "$path3\\Tick_daily2pm.dta", clear  //use "D:\Docs2\CM_JM\bloomberg2.dta", clear
joinby date_day using "$path1\\FED_dissent_date.dta", unmatched(both) update
tab _merge
drop _merge
joinby date_day using "$path1\\FED_dissent_6dayW.dta", unmatched(master) update //joinby date_day using "$path1\\bloomberg2_dissent_window.dta", unmatched(master) update // unmatched(both) update
tab _merge
drop _merge
joinby year day month using "$path1\\FED_surprise.dta", unmatched(master) update // unmatched(both) update
tab _merge
drop _merge Date
joinby date_day using "$path1\bloomberg2_reduced.dta", unmatched(master) update // unmatched(both) update
tab _merge
drop _merge 
joinby date_day using "$path1\\yields_d.dta", unmatched(master) update // unmatched(both) update
tab _merge
drop _merge
joinby year month using "$path1\CycleDummyVariables.dta", unmatched(master) update
tab _merge
drop _merge
drop if year<${year_min}
capture drop date_BS
egen date_BS = group(date_day)
quietly {  // "2 3 1" "3 1 2 5 8 10 12"
replace ffr_nr=DFF if ffr_nr==.
replace ffr_original=DFF if ffr_original==.
sum date_FOMC if year>=2015
local dF1=r(min)
local dF2=r(max)
forv d=`dF1'/`dF2' {
local d0=`d'-1
foreach var of varlist ffr_nr ffr_original { 
sum `var' if date_FOMC==`d0' & window>0
local v=r(mean)
sum date_BS if date_FOMC==`d0' & window>0
local dw1=r(min)
sum date_BS if date_FOMC==`d'  & window<0
local dw2=r(max)
replace `var' = `v' if date_BS>=`dw1' & date_BS<=`dw2' & `var'==.
}
}  //    //
sum date_BS if year>=2015
local dB1=r(min)
local dB2=r(max)
forv d=`dB1'/`dB2' {
local d0=`d'-1
foreach var of varlist ffr_nr ffr_original { 
sum `var' if date_BS==`d0' 
local v=r(mean)
replace `var' = `v' if date_BS==`d' & `var'==.
}
}
}
replace Kuttner_surprise=0 if Kuttner_surprise==.
capture drop TB* //replace TBill_3M = max(0, TBill_3M) if TBill_3M<. *egen TBill_3M = rowmin(YTM_3M DGS3MO_TBi DTB3_Tbil) *egen TBill_3M0 = rowmax(YTM_3M DGS3MO_TBi DTB3_Tbil) //sum TBill_3M TBill_3M0 YTM_3M DGS3MO_TBill3m_cmr DTB3_Tbill3m_smr Libor_3m_p USA_TB10y_p //pwcorr TBill_3M TBill_3M0 YTM_3M DGS3MO_TBill3m_cmr DTB3_Tbill3m_smr Libor_3m_p USA_TB10y_p
capture egen TBill_3M0 = rowmax(YTM_3M DGS3MO_TBi DTB3_Tbil)
replace TBill_3M = max(0, TBill_3M) if TBill_3M<. //egen TBill_3M0 = rowmax(YTM_3M DGS3MO_TBi DTB3_Tbil)
tsset date_day
save "$path3\\Tick_daily2pm.dta", replace 

replace Fed_fund_rate_futures_p = 100-Fed_fund_rate_futures_p
replace Euro_dollar_futures_3m_p = 100-Euro_dollar_futures_3m_p
quietly {
foreach var of varlist SP_open { //SP_close S_P500_p NASDAQ_p DAX_p FTSE100_p CAC40_p IBEX_p SMI_p
g `var'0 = F.`var'  //L.`var'
g `var'_exreturn = ln(`var'0)-ln(`var') //ln(`var')-ln(`var'0)
replace `var'_exreturn = 262*`var'_exreturn // Annualize excess returns 
drop  `var'0  //replace `var'_exreturn = (262/`sw2')*`var'_exreturn // Annualize excess returns
}
}
quietly { // Possible riskless interest rates (Fed_fund_rate_futures_p or USA_TB10y_p)
foreach var of varlist SP_open_exreturn { // SP_close_exreturn S_P500_p_exreturn NASDAQ_p_exreturn DAX_p_exr FTSE100_p_exr CAC40_p_exr IBEX_p_exr SMI_p_exr 
replace `var' = `var' - 1*ln(1 + 0.01*${TBill_rfree})  //replace `var' = `var' - 1*0.01*${TBill_rfree}
sum `var', d //replace `var' = max(r(p1), min(`var',r(p99)))
}
}     
sum date_FOMC
local dF1=r(min)
local dF2=r(max)
sum window
local w1 = r(min)
sum date_FOMC- FOMC_session_public window1

sum date_day if FOMC_session_public<.
drop if date_day<r(min)-10
sum date_day if FOMC_session_public==1
local dp1 = r(min)-10
local dp0 = `dp1'-1
sum date_day if FOMC_session_public==1 //sum date_day if month==3 & year==2002 *drop if date_day<r(min)-9 *drop if date_day>r(max)+5 
capture drop date_BS
egen date_BS = group(date_day)
sort date_BS
tsset date_BS

g VIX_lag = L.VIX_p
g dif_VIX = VIX_p-VIX_lag
reg VIX_p VIX_lag
predict var_p0
g dif2_VIX = VIX_p-var_p0
drop var_p0

g window2 = 9
replace window2 = window1 if window1>=-1 & window1<=1
replace window2 = window2 +1
g dissent2 = 9
replace dissent2 = dissent if window1>=-1 & window1<=1
g window2_u = window2 if dissent2==0
replace window2_u = 10 if window2_u==.
g window2_d = window2 if dissent2==1
replace window2_d = 10 if window2_d==.

/*g window3 = 0 
replace window3 = 2+window1 if window1>=-1 & window1<=1 & dissent2==0 & date_day>=`dp1'
replace window3 = 5+window1 if window1>=-1 & window1<=1 & dissent2==1 & date_day>=`dp1'
replace window3 = 8+window1 if window1>=-1 & window1<=1 & date_day<`dp1'*/

g window3 = 0 
replace window3 = 1 if window1==-1 & dissent2==0 & date_day>=`dp1'
replace window3 = 2 if window1==0 & dissent2==0 & date_day>=`dp1'
replace window3 = 3 if window1==1 & dissent2==0 & date_day>=`dp1'
replace window3 = 4 if window1==-1 & dissent2==1 & date_day>=`dp1'
replace window3 = 5 if window1==0 & dissent2==1 & date_day>=`dp1'
replace window3 = 6 if window1==1 & dissent2==1 & date_day>=`dp1'
replace window3 = 7 if window1==-1 & date_day<`dp1'
replace window3 = 8 if window1==0 & date_day<`dp1'
replace window3 = 9 if window1==1 & date_day<`dp1'

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

// Intensity of trading 
quietly {
foreach var of varlist S_P500_itv { //NASDAQ_itv DAX_itv FTSE100_itv CAC40_itv IBEX_itv SMI_itv
g `var'0 = L.`var'
g `var'1 = ln(`var'0)
g  dif_`var' = ln(`var') - ln(`var'0)
g `var'2 =  ln(`var')
reg `var'2 `var'1
predict var_p0
g dif2_`var' = `var'2-var_p0
drop `var'0 `var'2 var_p0
}
}
// Daily volatility
quietly {
foreach var of varlist S_P500_dv { //NASDAQ_dv DAX_dv FTSE100_dv CAC40_dv IBEX_dv SMI_dv
g `var'0 = L.`var'
g `var'1 = 0.01*`var'0
g  dif_`var' = 0.01*(`var' - `var'0)
g `var'2 =  0.01*`var'
reg `var'2 `var'1
predict var_p0
g dif2_`var' = `var'2-var_p0
drop `var'0 `var'2 var_p0
}
}
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

capture log close  //log using "$path0T\exc_returns_regs.log", replace 
sum Kuttner_surprise ffr_nr if year==1992
sum Kuttner_surprise ffr_nr if year==1991
drop if year<1993
sum year //drop if year<2002 //drop if year==2002 & month<=2

local ylist "SP_open_exreturn" //SP_close_exreturn S_P500_p_e NASDAQ_p_e DAX_p_e FTSE100_p_e CAC40_p_e IBEX_p_e SMI_p_e
g index_itv = S_P500_itv1
g dif_index_itv = dif2_S_P500_i //dif_S_P500_i
g index_dv = S_P500_dv
g dif_index_dv = dif2_S_P500_dv //dif_S_P500_dv
quietly { // Explanatory variables are lags of 2 days
tsset date_BS
foreach var of varlist dif2_VIX VIX_lag dif_index_itv dif_index_dv { // dif_index_itv index_itv dif_index_dv index_dv
/*g var0 = L2.`var' //L2 L 
rename `var' O_`var'
rename var0 `var' */
}
foreach var of varlist index_itv index_dv USA_TB1year USA_TB5year USA_TB10year { //Kuttner_surprise ffr_nr USA_TB1year USA_TB5year
g var0 = L.`var' //L3 L2 L
rename `var' O_`var'
rename var0 `var' 
}
}
local xvars "dif2_VIX VIX_lag dif_index_itv index_itv Kuttner_surprise ffr_nr FOMC_unscheduled1 USA_TB1year USA_TB5year RecessionDummy TighteningCycleDummy EasingCycleDummy"
local xvars2 "`xvars' USA_TB10year dif_index_dv index_dv" // 

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
log using "${path0T`Vxn'}\\SPdaily_regs.log", replace 
foreach var of local ylist { 
local vy =  word("`ylist'",`i')   /*forv k=1/6 {  local x`k' =  word("`xlist`k''",`i')   }*/

reg `vy' i.(window3) dissent_lag0 `xvars', `varR' 
test 4.window3+5.window3+6.window3=0 // Wald test for Dissent different than 0
test 4.window3+5.window3+6.window3=1.window3+2.window3+3.window3 // Wald test for Dissent different than Unanimity
outreg2 using "${path0T`Vxn'}\\reg_exr_x_ally.xls", replace
qreg `vy' i.(window3) dissent_lag0 `xvars', `varR'
test 4.window3+5.window3+6.window3=0 // Wald test for Dissent different than 0
test 4.window3+5.window3+6.window3=1.window3+2.window3+3.window3 // Wald test for Dissent different than Unanimity
outreg2 using "${path0T`Vxn'}\\qreg_exr_x_ally.xls", replace
//      //    //
reg `vy' i.(window3) dissent_lag0 `xvars2', `varR' 
test 4.window3+5.window3+6.window3=0 // Wald test for Dissent different than 0
test 4.window3+5.window3+6.window3=1.window3+2.window3+3.window3 // Wald test for Dissent different than Unanimity
outreg2 using "${path0T`Vxn'}\reg_exr_x_ally.xls", append
qreg `vy' i.(window3) dissent_lag0 `xvars2', `varR'
test 4.window3+5.window3+6.window3=0 // Wald test for Dissent different than 0
test 4.window3+5.window3+6.window3=1.window3+2.window3+3.window3 // Wald test for Dissent different than Unanimity
outreg2 using "${path0T`Vxn'}\qreg_exr_x_ally.xls", append
//   //   //
reg `vy' i.(window3) `xvars', `varR'
test 4.window3+5.window3+6.window3=0 // Wald test for Dissent different than 0
test 4.window3+5.window3+6.window3=1.window3+2.window3+3.window3 // Wald test for Dissent different than Unanimity
outreg2 using "${path0T`Vxn'}\reg_exr_x_ally.xls", append
qreg `vy' i.(window3) `xvars', `varR'
test 4.window3+5.window3+6.window3=0 // Wald test for Dissent different than 0
test 4.window3+5.window3+6.window3=1.window3+2.window3+3.window3 // Wald test for Dissent different than Unanimity
outreg2 using "${path0T`Vxn'}\qreg_exr_x_ally.xls", append
//      //    //
reg `vy' i.(window3) dissent_lag0 dif2_VIX VIX_lag dif_index_itv index_itv, `varR' 
test 4.window3+5.window3+6.window3=0 // Wald test for Dissent different than 0
test 4.window3+5.window3+6.window3=1.window3+2.window3+3.window3 // Wald test for Dissent different than Unanimity
outreg2 using "${path0T`Vxn'}\reg_exr_x_ally.xls", append
qreg `vy' i.(window3) dissent_lag0 dif_VIX VIX_lag dif_index_itv index_itv, `varR' 
test 4.window3+5.window3+6.window3=0 // Wald test for Dissent different than 0
test 4.window3+5.window3+6.window3=1.window3+2.window3+3.window3 // Wald test for Dissent different than Unanimity
outreg2 using "${path0T`Vxn'}\qreg_exr_x_ally.xls", append

reg `vy' i.(window3), `varR' //dissent_lag0 
test 4.window3+5.window3+6.window3=0 // Wald test for Dissent different than 0
test 4.window3+5.window3+6.window3=1.window3+2.window3+3.window3 // Wald test for Dissent different than Unanimity
outreg2 using "${path0T`Vxn'}\reg_exr_x_ally.xls", append
qreg `vy' i.(window3), `varR' //dissent_lag0 
test 4.window3+5.window3+6.window3=0 // Wald test for Dissent different than 0
test 4.window3+5.window3+6.window3=1.window3+2.window3+3.window3 // Wald test for Dissent different than Unanimity
outreg2 using "${path0T`Vxn'}\qreg_exr_x_ally.xls", append

local i = 1+`i'		
}
log close
local Vxn=1+`Vxn'
}
clear 
