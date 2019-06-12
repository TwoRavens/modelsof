set more off
capture log close

use "$path3\\Tick_daily2pm.dta", clear  //use "D:\Docs2\CM_JM\bloomberg2.dta", clear
replace Fed_fund_rate_futures_p = 100-Fed_fund_rate_futures_p
replace Euro_dollar_futures_3m_p = 100-Euro_dollar_futures_3m_p
tsset date_day
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
foreach var of varlist SP_close S_P500_p { //S_P500_p NASDAQ_p DAX_p FTSE100_p CAC40_p IBEX_p SMI_p
g `var'0 = L.`var'
g `var'_exreturn = ln(`var')-ln(`var'0)
replace `var'_exreturn = 262*`var'_exreturn // Annualize excess returns 
drop  `var'0  //replace `var'_exreturn = (262/`sw2')*`var'_exreturn // Annualize excess returns
}
foreach var of varlist SP_close_exreturn S_P500_p_exreturn { //NASDAQ_p_exreturn DAX_p_exr FTSE100_p_exr CAC40_p_exr IBEX_p_exr SMI_p_exr 
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
label values dissent2 dissent_l
g FOMC_unscheduled0 = FOMC_unscheduled if window1>=-1 & window1<=1
bysort date_FOMC: egen FOMC_unscheduled1 = max(FOMC_unscheduled0) if window1>=-1 & window1<=1
replace FOMC_unscheduled1=0 if FOMC_unscheduled1==.
tab FOMC_unscheduled1
g USA_TB10year = 0.01*USA_TB10y_p 
g USA_TB5year = 0.01*YTM_5Y
g USA_TB1year = 0.01*YTM_1Y

sum Kuttner_surprise ffr_nr if year==1992
sum Kuttner_surprise ffr_nr if year==1991
drop if year<1993
sum year //drop if year<2002 //drop if year==2002 & month<=2

g index_itv = S_P500_itv1
g dif_index_itv = dif2_S_P500_i //dif_S_P500_i
g index_dv = S_P500_dv
g dif_index_dv = dif2_S_P500_dv //dif_S_P500_dv
joinby date_FOMC using "$path1\FED_dissent_date_extralags.dta", unmatched(both) update
tab _merge
drop _merge
tsset date_BS
save "$path1\data_temp_2pm.dta", replace
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
tab dissent_lag0 if window3>0
tab dissent_lag0 if window3==0
sum dissent_lag0 if FOMC_pub==0
local XVdlag "dissent_p2_lag dissent_p3_lag dummy_LG dummy_LGH"
foreach var of local XVdlag { 
g `var'0 = 0 
replace `var'0 = `var' if window1>=-1 & window1<=1 & date_day>=`dp1'  // or FOMC_pub==1
}
local XVdlag "dissent_lag dissent_p2_lag dissent_p3_lag dummy_LG dummy_LGH"
foreach var of local XVdlag { 
g `var'2 = 0 
replace `var'2 = `var' if window1>=0 & window1<=1 & date_day>=`dp1'  // or FOMC_pub==1
}
local XVdlag "dissent_lag dissent_p2_lag dissent_p3_lag dummy_LG dummy_LGH"
local XVdlag0 "dissent_lag0 dissent_p2_lag0 dissent_p3_lag0 dummy_LG0 dummy_LGH0"
local XVdlag2 "dissent_lag2 dissent_p2_lag2 dissent_p3_lag2 dummy_LG2 dummy_LGH2"
sum `XVdlag' 
sum `XVdlag0'
sum `XVdlag2'
save "$path1\data_temp_2pm.dta", replace

local ylist "SP_open_exreturn" // SP_open_exreturn SP_close_exreturn S_P500_p_e NASDAQ_p_e DAX_p_e FTSE100_p_e CAC40_p_e IBEX_p_e SMI_p_e
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

local esave1 = "replace"
local esave2 = "append"
local XVd1 ""
local XVd2 "dissent_lag0"
local XVd3 "dissent_lag0 dissent_p2_lag0"
local XVd4 "dissent_lag0 dissent_p2_lag0 dissent_p3_lag0"
local XVd5 "dissent_lag0 dissent_p2_lag0 dissent_p3_lag0 dummy_LG0"

local xvars "FOMC_unscheduled1 dif_index_itv index_itv dif2_VIX VIX_lag Kuttner_surprise ffr_nr USA_TB1year USA_TB5year RecessionDummy TighteningCycleDummy EasingCycleDummy"
local xvars2 "USA_TB10year dif_index_dv index_dv" // 
foreach var of local ylist { 
putexcel A1=("Dissent != 0") B1=("Dissent != Unanimity") C1=("Dissent2 != 0") D1=("Dissent2 != Unanimity2") using "${path0T`Vxn'}\\reg_exr_x_MoreR_Fp.xls", sheet("Sheet1") replace
putexcel A1=("Dissent != 0") B1=("Dissent != Unanimity") C1=("Dissent2 != 0") D1=("Dissent2 != Unanimity2") E1=("Pseudo R2") using "${path0T`Vxn'}\\qreg_exr_x_MoreR_Fp.xls", sheet("Sheet1") replace
forv XV=1/5  {
local es=min(`XV',2)
local XV2 = `XV'+1
reg `var' i.(window3) `XVd`XV'' `xvars', `varR' // vce(robust)
outreg2 using "${path0T`Vxn'}\\reg_exr_x_MoreR.xls", `esave`es''
test 4.window3+5.window3+6.window3=0 // Wald test for Dissent different than 0
putexcel A`XV2'=(r(p)) using "${path0T`Vxn'}\\reg_exr_x_MoreR_Fp.xls", sheet("Sheet1") modify
test 4.window3+5.window3+6.window3=1.window3+2.window3+3.window3 // Wald test for Dissent different than Unanimity
putexcel B`XV2'=(r(p)) using "${path0T`Vxn'}\\reg_exr_x_MoreR_Fp.xls", sheet("Sheet1") modify
test 5.window3+6.window3=0 // Wald test for Dissent different than 0
putexcel C`XV2'=(r(p)) using "${path0T`Vxn'}\\reg_exr_x_MoreR_Fp.xls", sheet("Sheet1") modify
test 5.window3+6.window3=2.window3+3.window3 // Wald test for Dissent different than Unanimity
putexcel D`XV2'=(r(p)) using "${path0T`Vxn'}\\reg_exr_x_MoreR_Fp.xls", sheet("Sheet1") modify

qreg `var' i.(window3) `XVd`XV'' `xvars', `varR' // vce(robust)
outreg2 using "${path0T`Vxn'}\\qreg_exr_x_MoreR.xls", `esave`es''
test 4.window3+5.window3+6.window3=0 // Wald test for Dissent different than 0
putexcel A`XV2'=(r(p)) using "${path0T`Vxn'}\\qreg_exr_x_MoreR_Fp.xls", sheet("Sheet1") modify
test 4.window3+5.window3+6.window3=1.window3+2.window3+3.window3 // Wald test for Dissent different than Unanimity
putexcel B`XV2'=(r(p)) using "${path0T`Vxn'}\\qreg_exr_x_MoreR_Fp.xls", sheet("Sheet1") modify
test 5.window3+6.window3=0 // Wald test for Dissent different than 0
putexcel C`XV2'=(r(p)) using "${path0T`Vxn'}\\qreg_exr_x_MoreR_Fp.xls", sheet("Sheet1") modify
test 5.window3+6.window3=2.window3+3.window3 // Wald test for Dissent different than Unanimity
putexcel D`XV2'=(r(p)) using "${path0T`Vxn'}\\qreg_exr_x_MoreR_Fp.xls", sheet("Sheet1") modify
local psr2=1-e(sum_adev)/e(sum_rdev)
putexcel E`XV2'=(`psr2') using "${path0T`Vxn'}\\qreg_exr_x_MoreR_Fp.xls", sheet("Sheet1") modify

}
local i = 1+`i'		
}
local Vxn=1+`Vxn'
}
clear 
