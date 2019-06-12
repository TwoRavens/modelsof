local Vxn=2
if `Vxn'==1 {
local varR ""
}
if `Vxn'==2 {
local varR "vce(robust)"
}
if `Vxn'==3 {
local varR "vce(bootstrap, reps(${Breps}))"
}
set more off

use "$path3\\Tick_daily2pm.dta", clear  //use "D:\Docs2\CM_JM\bloomberg2.dta", clear
joinby date_day using "$path3\\tips_series.dta", unmatched(master) update //T5YIFR.dta
tab _merge 
drop _merge
replace Fed_fund_rate_futures_p = 100-Fed_fund_rate_futures_p
replace Euro_dollar_futures_3m_p = 100-Euro_dollar_futures_3m_p
tsset date_day
capture drop date_BS
egen date_BS = group(date_day)
sort date_BS
tsset date_BS
quietly { // TY (U.S. 10-year T-note futures), FV (5-year T-note futures), TU (2-year T-note futures), IAP (VIX index)
foreach var of varlist YTM_6M YTM_1Y YTM_18M YTM_3Y YTM_5Y DFII5 DFII10 T5YIE T10YIE T5YIFR TBill_3M {  
g `var'0 = L.`var'
g `var'_exr = `var'-`var'0 
replace `var'_exr = 100*`var'_exr
drop  `var'0  //replace `var'_exreturn = (262/`sw2')*`var'_exreturn // Annualize excess returns
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

g window3 = 0 
replace window3 = 2+window1 if window1>=-1 & window1<=1 & dissent==0 & date_day>=`dp1' //dissent2
replace window3 = 5+window1 if window1>=-1 & window1<=1 & dissent==1 & date_day>=`dp1'
replace window3 = 8+window1 if window1>=-1 & window1<=1 & date_day<`dp1'
/*g window3 = 0 
replace window3 = 1+window1 if window1>=0 & window1<=1 & dissent==0 & date_day>=`dp1'
replace window3 = 3+window1 if window1>=0 & window1<=1 & dissent==1 & date_day>=`dp1'
replace window3 = 5+window1 if window1>=0 & window1<=1 & date_day<`dp1'*/
label variable window3 "FOMC_outcome"
label def window_l3 0 "No Meeting" 1 "Day before U" 2 "Day of U" 3 "Day after U"  4 "Day before D" 5 "Day of D" 6 "Day after D" 7 "Day before F" 8 "Day of F" 9 "Day after F"
*label def window_l3 0 "No Meeting" 1 "Day before U" 2 "Day of U"  3 "Day before D" 4 "Day of D" 5 "Day before F" 6 "Day of F"
tab window3
label values window3 window_l3
g dissent_lag0 = 0 
replace dissent_lag0 = dissent_lag if window1>=0 & window1<=1 & dissent<. & date_day>=`dp1' //if window1>=-1 & window1<=1 & dissent2<. & date_day>=`dp1'
label def window_l 0 "Day Before" 1 "FOMC day" 2 "Day After" 10 "No meeting"
label variable dissent "dissent"
label def dissent_l 9 "No meeting" 0 "Unanimity" 1 "Dissent"
label values dissent dissent_l
quietly { // Intensity of trading 
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
quietly { // Daily volatility
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
g FOMC_unscheduled0 = FOMC_unscheduled if window1>=-1 & window1<=1
bysort date_FOMC: egen FOMC_unscheduled1 = max(FOMC_unscheduled0) if window1>=-1 & window1<=1
replace FOMC_unscheduled1=0 if FOMC_unscheduled1==.
tab FOMC_unscheduled1
g USA_TB10year = 0.01*USA_TB10y_p 
g USA_TB5year = 0.01*YTM_5Y
g USA_TB1year = 0.01*YTM_1Y
quietly { // Explanatory variables are lags of 2 days
g dummy_Greenspan = 0
replace dummy_Greenspan = 1 if year<=2005
replace dummy_Greenspan = 1 if year==2006 & month<=1
g dummy_Yellen = 0
replace dummy_Yellen = 1 if year==2014 & month>=2
replace dummy_Yellen = 1 if year>=2015 & year<.
tsset date_BS
g index_itv = S_P500_itv1
g dif_index_itv = dif2_S_P500_i //dif_S_P500_i
g index_dv = S_P500_dv
g dif_index_dv = dif2_S_P500_dv //dif_S_P500_dv
foreach var of varlist dif2_VIX VIX_lag dif_index_itv dif_index_dv index_itv index_dv USA_TB1year USA_TB5year USA_TB10year { 
g OR_`var' = `var'
}
foreach var of varlist dif2_VIX VIX_lag dif_index_itv dif_index_dv { // dif_index_itv index_itv dif_index_dv index_dv
g var0 = L2.OR_`var' //L2 L 
drop `var' 
rename var0 `var' /* */
}
foreach var of varlist USA_TB1year USA_TB5year USA_TB10year { //Kuttner_surprise ffr_nr USA_TB1year USA_TB5year
g var0 = L2.OR_`var' //L3 L2 L
drop `var' 
rename var0 `var' 
}
foreach var of varlist index_itv index_dv { //Kuttner_surprise ffr_nr USA_TB1year USA_TB5year
g var0 = L3.OR_`var' //L3 L2 L
drop `var' 
rename var0 `var' 
}
}
tab window3 if date_FOMC<. & window3>0

local ylist "YTM_6M_exr YTM_1Y_exr YTM_18M_exr YTM_3Y_exr YTM_5Y_exr" //S_P500_p_e NASDAQ_p_e DAX_p_e FTSE100_p_e CAC40_p_e IBEX_p_e SMI_p_e
local xvars "dif2_VIX VIX_lag Kuttner_surprise ffr_nr FOMC_unscheduled1" //RecessionDummy TighteningCycleDummy EasingCycleDummy
local xvars0 "`xvars' RecessionDummy TighteningCycleDummy EasingCycleDummy"
local xvars2 "`xvars0' USA_TB1year USA_TB5year USA_TB10year" // Most of these variables are TB Futures local xvars2 "USA_TB10year dif_index_dv index_dv" // 
local xvars "FOMC_unscheduled1 dif_index_itv index_itv dif2_VIX VIX_lag Kuttner_surprise ffr_nr USA_TB1year USA_TB5year RecessionDummy TighteningCycleDummy EasingCycleDummy dummy_Greenspan dummy_Yellen"
local esave1 = "replace"
local esave2 = "append"
local es=1
keep if year>=2002
drop if month<3 & year==2002
foreach vy of local ylist { 
reg `vy' i.(window3) dissent_lag0 `xvars', `varR' // 
outreg2 using "$path0T2\\Yields_ally.xls", `esave`es''
reg `vy' i.(window3), `varR' //
outreg2 using "$path0T2\Yields_noy.xls", `esave`es''
qreg `vy' i.(window3) dissent_lag0 `xvars', `varR' //
outreg2 using "$path0T2\\Yields_QR_ally.xls", `esave`es''
qreg `vy' i.(window3), `varR' // 
outreg2 using "$path0T2\Yields_QR_noy.xls", `esave`es''
local es=2
}
drop if window1==.
local ylist "YTM_6M_exr YTM_1Y_exr YTM_18M_exr YTM_3Y_exr YTM_5Y_exr"
keep dissent window1 `ylist'
sum dissent if dissent==0 & window1==0
g d_n0 = r(N)
sum dissent if dissent==1 & window1==0
g d_n1 = r(N)
foreach var of local ylist {
bysort window1 dissent: egen `var'_sd = sd(`var') 
}
collapse (mean) `ylist' *_sd d_n0 d_n1, by(window1 dissent)
foreach var of local ylist {
g `var'0 = `var' if dissent==0
g `var'0_sd = `var'_sd if dissent==0
bysort window1: egen `var'00 = mean(`var'0)
bysort window1: egen `var'00_sd = mean(`var'0_sd)
g `var'00_sd_un = sqrt(((`var'00_sd^2)/d_n0)+((`var'_sd^2)/d_n1))
g T_`var'_dun = (`var'-`var'00)/`var'00_sd_un
g T_`var'_d0 = sqrt(d_n1)*`var'/`var'_sd
g sig_`var'_dun = (1- normal( abs(T_`var'_dun) ) )*2
g sig_`var'_d0 = (1- normal( abs(T_`var'_d0) ) )*2
}
keep if dissent==1
keep window1 dissent T_* sig_*
save "$path0T2\yields_data_sig_pub.dta", replace
keep window1 sig_*
export excel using "$path0T2\yields_data_sig_pub.xls", firstrow(variables) nolabel replace
keep window1 *d0
export excel using "$path0T2\yields_data_sig_d0_pub.xls", firstrow(variables) nolabel replace
use "$path0T2\yields_data_sig_pub.dta", clear
keep window1 sig_*
keep window1 *dun
export excel using "$path_d\yields_data_sig_dun_pub.xls", firstrow(variables) nolabel replace
/*foreach var of varlist YTM_6M_exr YTM_1Y_exr YTM_18M_exr YTM_3Y_exr YTM_5Y_exr { 
ttest UL_e_read_medianq1 = `var' //similar results with ztest
}*/
clear 
