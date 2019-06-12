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
capture log close

use "$path3\\Tick_daily2pm.dta", clear  //use "D:\Docs2\CM_JM\bloomberg2.dta", clear
joinby date_day using "$path1\FED3_dissent_date_MinutesPre02.dta", unmatched(master) update //joinby date_day using "$path1\FED2_dissent_date_MinutesPre02.dta", unmatched(master) update
sort date_BS
tsset date_BS
sum date_FOMC
local dF1=r(min)
local dF2=r(max)
sum window
local w1 = r(min)
g fw = F._merge
g lag = L._merge
g window_M = 0 if _merge==3
replace window_M = -1 if fw==3
replace window_M = 1 if lag==3
tab window_M
drop _merge fw lag // *egen TBill_3M = rowmin(YTM_3M DGS3MO_TBi DTB3_Tbil)
replace TBill_3M = max(0, TBill_3M) if TBill_3M<. //egen TBill_3M0 = rowmax(YTM_3M DGS3MO_TBi DTB3_Tbil)
replace Fed_fund_rate_futures_p = 100-Fed_fund_rate_futures_p
replace Euro_dollar_futures_3m_p = 100-Euro_dollar_futures_3m_p //tsset date_day

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

g window3 = 0 
replace window3 = 1 if window1==-1 & dissent==0 & date_day>=`dp1' //dissent2
replace window3 = 2 if window1==0 & dissent==0 & date_day>=`dp1'
replace window3 = 3 if window1==1 & dissent==0 & date_day>=`dp1'
replace window3 = 4 if window1==-1 & dissent==1 & date_day>=`dp1'
replace window3 = 5 if window1==0 & dissent==1 & date_day>=`dp1'
replace window3 = 6 if window1==1 & dissent==1 & date_day>=`dp1'
replace window3 = 7 if window1==-1 & date_day<`dp1'
replace window3 = 8 if window1==0 & date_day<`dp1'
replace window3 = 9 if window1==1 & date_day<`dp1'
/*g window3 = 0 
replace window3 = 1+window1 if window1>=0 & window1<=1 & dissent==0 & date_day>=`dp1'
replace window3 = 3+window1 if window1>=0 & window1<=1 & dissent==1 & date_day>=`dp1'
replace window3 = 5+window1 if window1>=0 & window1<=1 & date_day<`dp1'*/
label variable window3 "FOMC_outcome"
label def window_l3 0 "No Meeting" 1 "Day before U" 2 "Day of U" 3 "Day after U"  4 "Day before D" 5 "Day of D" 6 "Day after D" 7 "Day before F" 8 "Day of F" 9 "Day after F"
*label def window_l3 0 "No Meeting" 1 "Day before U" 2 "Day of U"  3 "Day before D" 4 "Day of D" 5 "Day before F" 6 "Day of F"
tab window3
label values window3 window_l3

foreach var of varlist Dissent_minute Dissent_la_minute Dissent_both_minute nr_pers FOMC_1or2dayBMin { 
g `var'0 = 0 
replace `var'0 = `var' if window_M==0  //& window_M<=1 // or FOMC_pub==1
g var00= L.`var'
replace `var'0 = var00 if window_M==1  
g `var'2 = 0 
replace `var'2 = var00 if window_M==1 
drop var00
}
g window_MM = 0 
replace window_MM = 1+window_M if window_M>=0 & window_M<=1 & Dissent_minute0==0 //Dissent_minute Dissent_la_minute Dissent_both_minute nr_pers
replace window_MM = 3+window_M if window_M>=0 & window_M<=1 & Dissent_minute0==1 
label variable window_MM "Minute_outcome"
label def window_l4 0 "No Minute" 1 "Day before U-M" 2 "Day of U-M"  3 "Day before D-M" 4 "Day of D_M" 
label values window_MM window_l4 //window_l3
tab window_MM
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
//   //
label variable dissent "dissent"
label def dissent_l 9 "No meeting" 0 "Unanimity" 1 "Dissent"
label values dissent dissent_l
g FOMC_unscheduled0 = FOMC_unscheduled if window1==0 //if window1>=0 & window1<=1
bysort date_FOMC: egen FOMC_unscheduled1 = max(FOMC_unscheduled0) //if window1==1 //if window1>=0 & window1<=1
replace FOMC_unscheduled1=0 if FOMC_unscheduled1==.
replace FOMC_unscheduled1=0 if window1!=1
tab FOMC_unscheduled1  /* */
g USA_TB10year = 0.01*USA_TB10y_p 
g USA_TB5year = 0.01*YTM_5Y
g USA_TB1year = 0.01*YTM_1Y

sum Kuttner_surprise ffr_nr if year==1992
sum Kuttner_surprise ffr_nr if year==1991
drop if year<1993
drop if year<${year_min}
sum year //drop if year<2002 //drop if year==2002 & month<=2

g index_itv = S_P500_itv1
g dif_index_itv = dif2_S_P500_i //dif_S_P500_i
g index_dv = S_P500_dv
g dif_index_dv = dif2_S_P500_dv //dif_S_P500_dv
joinby date_FOMC using "$path1\FED_dissent_date_extralags.dta", unmatched(both) update
tab _merge
drop _merge
joinby date_FOMC using "$path1\\dissent_pastTrack.dta", unmatched(both) update
tab _merge
drop _merge
tsset date_BS
save "$path1\data_temp_2pm.dta", replace // FOMC_XVars
quietly { // Explanatory variables are lags of 2 days
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
g nr_diss0 = 0 
replace nr_diss0 = nr_dissents if window1>=0 & window1<=1 & dissent<. & date_day>=`dp1'
tab nr_dissents if window1==1
g D_Multiple_dissent = 0
replace D_Multiple_dissent = 1 if window1>=0 & window1<=1 & nr_dissents>=2 & nr_dissents<=12 & dissent<. & date_day>=`dp1' 
g dissent_lag0 = 0 
replace dissent_lag0 = dissent_lag if window1>=0 & window1<=1 & dissent<. & date_day>=`dp1'
g dissent_bothsides = (dissent_ma==1 & dissent_la==1) if dissent<.
local XVdlag "Dp1_lag Dp2_lag dissent_p1_lag dissent_p2_lag dissent_p3_lag dummy_LG dummy_LGH D_Multiple_dissent dissent_la past_dissent_pc_Dmembers past_dissent_pc_Dm"
foreach var of local XVdlag { 
g `var'0 = 0 
replace `var'0 = `var' if window1>=0 & window1<=1 & date_day>=`dp1'  // or FOMC_pub==1
}
local XVdlag "dissent_lag Dp1_lag Dp2_lag dissent_p1_lag dissent_p2_lag dissent_p3_lag dummy_LG dummy_LGH D_Multiple_dissent dissent_la past_dissent_pc_Dmembers past_dissent_pc_Dm"
foreach var of local XVdlag { 
g `var'2 = 0 
replace `var'2 = `var' if window1>=1 & window1<=1 & date_day>=`dp1'  // or FOMC_pub==1
}
local XVdlag "dissent_lag Dp1_lag Dp2_lag dissent_p1_lag dissent_p2_lag dissent_p3_lag dummy_LG dummy_LGH D_Multiple_dissent dissent_la past_dissent_pc_Dmembers past_dissent_pc_Dm"
local XVdlag0 "dissent_lag0 Dp1_lag0 Dp2_lag0 dissent_p1_lag0 dissent_p2_lag0 dissent_p3_lag0 dummy_LG0 dummy_LGH0 D_Multiple_dissent0 dissent_la0 past_dissent_pc_Dmembers0 past_dissent_pc_Dm0"
local XVdlag2 "dissent_lag2 Dp1_lag2 Dp2_lag2 dissent_p1_lag2 dissent_p2_lag2 dissent_p3_lag2 dummy_LG2 dummy_LGH2 D_Multiple_dissent2 dissent_la2 past_dissent_pc_Dmembers2 past_dissent_pc_Dm2"
sum `XVdlag' 
sum `XVdlag0'
sum `XVdlag2'
log using "$path0T\FOMC_hawk_dove.log", replace 
tab dissent dissent_ma if window1==0 & FOMC_pu==1, row
tab dissent dissent_la if window1==0 & FOMC_pu==1, row
tab dissent dissent_both if window1==0 & FOMC_pu==1, row
tab dissent dissent_ma if window1==0 & FOMC_pu==0, row
tab dissent dissent_la if window1==0 & FOMC_pu==0, row
tab dissent dissent_both if window1==0 & FOMC_pu==0, row
bysort FOMC_pu: sum dissent dissent_ma dissent_la dissent_both if window1==0
log close
g dummy_Greenspan = 0
replace dummy_Greenspan = 1 if year<=2005
replace dummy_Greenspan = 1 if year==2006 & month<=1
g dummy_Yellen = 0
replace dummy_Yellen = 1 if year==2014 & month>=2
replace dummy_Yellen = 1 if year>=2015 & year<.
tsset date_BS
save "$path1\data_temp_2pm.dta", replace

use "$path1\data_temp_2pm.dta", clear
local ylist "SP_open_exreturn" //S_P500_p_e NASDAQ_p_e DAX_p_e FTSE100_p_e CAC40_p_e IBEX_p_e SMI_p_e
local esave1 = "replace"
local esave2 = "append"
local XVd1 ""
local XVd2 "dissent_lag0"
local XVd5 "dissent_lag0 dissent_p2_lag0 dissent_p3_lag0 past_dissent_pc_Dm0 D_Multiple_dissent0 dissent_la0" 
local XVd1_vs1 ""
local XVd2_vs1 "dissent_lag2"
local XVd5_vs1 "dissent_lag2 dissent_p2_lag2 dissent_p3_lag2 past_dissent_pc_Dmembers2 D_Multiple_dissent2 dissent_la2" 
local XVd5_vs2 "dissent_lag2 dissent_p2_lag2 dissent_p3_lag2 past_dissent_pc_Dm2 D_Multiple_dissent2 dissent_la2" //past_dissent_pc_Dmembers2 past_dissent_pc_Dm2 dummy_LG2

local xvars "FOMC_unscheduled1 dif_index_itv index_itv dif2_VIX VIX_lag Kuttner_surprise ffr_nr USA_TB1year USA_TB5year RecessionDummy TighteningCycleDummy EasingCycleDummy dummy_Greenspan dummy_Yellen"
local xvars2 "USA_TB10year dif_index_dv index_dv" // 
local var="SP_open_exreturn"
reg `var' i.(window_MM), `varR' //
outreg2 using "$path0T2\\reg_exr_x_Minutes.xls", replace
reg `var' i.(window_MM) if year>=1996 & year<=2002, `varR' // vce(robust)
outreg2 using "$path0T2\\reg_exr_x_Minutes.xls", append
reg `var' i.(window_MM) FOMC_1or2dayBMin2 if year>=1996 & year<=2002, `varR' // vce(robust)
outreg2 using "$path0T2\\reg_exr_x_Minutes.xls", append
reg `var' i.(window_MM window3) if year>=1996 & year<=2002, `varR' // vce(robust)
outreg2 using "$path0T2\\reg_exr_x_Minutes.xls", append
reg `var' i.(window_MM) `xvars', `varR' // vce(robust)
outreg2 using "$path0T2\\reg_exr_x_Minutes.xls", append
qreg `var' i.(window_MM), `varR' // vce(robust) 
outreg2 using "$path0T2\\reg_exr_x_Minutes.xls", append
qreg `var' i.(window_MM) if year>=1996 & year<=2002, `varR' // vce(robust)
outreg2 using "$path0T2\\reg_exr_x_Minutes.xls", append
qreg `var' i.(window_MM) FOMC_1or2dayBMin2 if year>=1996 & year<=2002, `varR' // vce(robust)
outreg2 using "$path0T2\\reg_exr_x_Minutes.xls", append
qreg `var' i.(window_MM window3) if year>=1996 & year<=2002, `varR' // vce(robust)
outreg2 using "$path0T2\\reg_exr_x_Minutes.xls", append
qreg `var' i.(window_MM) `xvars', `varR' // vce(robust)
outreg2 using "$path0T2\\reg_exr_x_Minutes.xls", append
clear 
