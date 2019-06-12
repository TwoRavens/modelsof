set more off
local sub0 "Period before votes in press release"
local sub1 "Period with votes in press release"
local tp=0

use "$path3\T2pm_dissent.dta", clear
local sw = ${sw_op} //2 3
local sw2 = (1-${std_op})+2*`sw'
local sw3 = 262/`sw2'
local sw_min = -`sw'
local sw_max = `sw'
local d_range = "`sw_min'(1)`sw_max'"
sum date_FOMC
local dF1=r(min)
local dF2=r(max)
sum window
local w1 = r(min)
local w1_1 = `w1'+1
local w2 = r(max)  //tab FOMC_session_public
joinby date_day using "$path1\\yields_d.dta", unmatched(master) update //joinby date_day using "$path1\\bloomberg2_dissent2_yields_TB.dta", unmatched(master) update // unmatched(both) update
tab _merge
drop _merge 
joinby date_day using "$path1\\FED_dissent_6dayW.dta", unmatched(master) update //joinby date_day using "$path1\\bloomberg2_dissent2_only.dta", unmatched(master) update // unmatched(both) update
tab _merge
drop _merge
capture drop TB*
capture egen TBill_3M0 = rowmax(YTM_3M DGS3MO_TBi DTB3_Tbil)
quietly { // Possible riskless interest rates (Fed_fund_rate_futures_p or USA_TB10y_p)
foreach var of varlist SP_open_exreturn { //S_P500_p_exreturn
g `var'2 = `var'*SW3/262  //*SW2/262
forv kw1=`w1_1'/`w2' {
g var_temp0 = ${TBill_rfree} if window==`kw1'
bysort date_FOMC: egen var_temp1 = mean(var_temp0)
replace var_temp1 = 0 if var_temp1==.
replace `var'2 = `var'2 - ln(1 + 0.01*var_temp1)/262 if window>=`kw1'
drop var_temp0 var_temp1
}
replace `var'2 = 262/SW3*`var'2 // `sw3'* 262/SW3* 262/SW2* Annualize excess returns       
}
} //g vs2_SP_close_exreturn = SP_close_exreturn //replace S_P500_p_exreturn = original_S_P500_p_exreturn
joinby date_day using "$path1\\bloomberg2_SP500_NASDAQ_window.dta", unmatched(both) update // unmatched(both) update //pwcorr SP_close_exreturn original_SP_close_exreturn original_S_P500_p_exreturn vs2_S_P500_p_exreturn
tab _merge //replace SP_close_exreturn=vs2_S_P500_p_exreturn if SP_close_exreturn==.
drop _merge
save "$path3\T2pm_dissent.dta", replace

use "$path3\T2pm_dissent.dta", clear
drop if year<${year_min}
keep if FOMC_public==`tp' 
collapse SP_open_exr* NASDAQ_p_exreturn, by(window1 dissent) // vs2_NASDAQ_p_exreturn
xtset dissent window1
label variable dissent "dissent"
label def dissent_l 0 "Unanimity" 1 "Dissent"
label values dissent dissent_l
local sw1 = "S&P S&P NASDAQ" // "S&P NASDAQ"  //local sw0 = "S&P NASDAQ VIX"
local i=1
foreach x of varlist SP_open_exr* NASDAQ_p_exreturn { // vs2_NASDAQ_p_exreturn // S_P500_p_ex-NASDAQ_p_ex
local sw =  word("`sw1'",`i')
label variable `x' "`sw'"
local i = 1+`i'		
}
xtline SP_open_exreturn2, ///   SP_open_exreturn // Graphics for effect of Dissent on Cumulative Stock Returns
byopts(title("")) xlabel(`d_range') xtick(`d_range') ///
ylabel(0.00(0.05)0.35) ytick(0.00(0.025)0.35) byopts(note("")) ///   
lp("l") lwidth(medthick) legend(cols(1) span  forcesize) xtitle("Day from FOMC decision") ytitle("Cumulative Excess Returns")
graph export "$path_g\sp500_cr1_pub`tp'.emf", replace  //byopts(title("S&P and NASDAQ Cumulative Returns around FOMC vote" "`sub`tp''")) xlabel(`d_range') xtick(`d_range') ///
*save "$path3\fseries_dissent_pub`tp'.dta", replace  //*lp("l" "_..." "_-" "l-.." "_--") lwidth(medthick medthick medium medthick medium) ///
xtline SP_open_exreturn2 NASDAQ_p_exreturn, ///  vs2_NASDAQ_p_exreturn // Graphics for effect of Dissent on Cumulative Stock Returns
byopts(title("")) xlabel(`d_range') xtick(`d_range') byopts(note("")) ///  
lp("l" "_...") lwidth(medthick medthick) legend(cols(2) span  forcesize) xtitle("Day from FOMC decision") ytitle("Cumulative Excess Returns")
graph export "$path_g\sp500_nas_cr1_pub`tp'.emf", replace  //byopts(title("S&P and NASDAQ Cumulative Returns around FOMC vote" "`sub`tp''")) xlabel(`d_range') xtick(`d_range') ///

local tp=1
use "$path3\T2pm_dissent.dta", clear
drop if year<${year_min}
keep if FOMC_public==`tp' 
collapse SP_open_exr* NASDAQ_p_exreturn, by(window1 dissent) // vs2_NASDAQ_p_exreturn
xtset dissent window1
label variable dissent "dissent"
label def dissent_l 0 "Unanimity" 1 "Dissent"
label values dissent dissent_l
local sw1 = "S&P S&P NASDAQ" // "S&P NASDAQ"  //local sw0 = "S&P NASDAQ VIX"
local i=1
foreach x of varlist SP_open_exr* NASDAQ_p_exreturn { // vs2_NASDAQ_p_exreturn //S_P500_p_ex-NASDAQ_p_ex
local sw =  word("`sw1'",`i')
label variable `x' "`sw'"
local i = 1+`i'		
}
xtline SP_open_exreturn2, ///   // Graphics for effect of Dissent on Cumulative Stock Returns
byopts(title("")) xlabel(`d_range') xtick(`d_range') ///
ylabel(-0.15(0.05)0.20) ytick(-0.15(0.025)0.20) byopts(note("")) ///   
lp("l") lwidth(medthick) legend(cols(1) span  forcesize) xtitle("Day from FOMC decision") ytitle("Cumulative Excess Returns")
graph export "$path_g\sp500_cr1_pub`tp'.emf", replace  //byopts(title("S&P and NASDAQ Cumulative Returns around FOMC vote" "`sub`tp''")) xlabel(`d_range') xtick(`d_range') ///
xtline SP_open_exreturn2 NASDAQ_p_exreturn, /// vs2_NASDAQ_p_exreturn  // Graphics for effect of Dissent on Cumulative Stock Returns
byopts(title("")) xlabel(`d_range') xtick(`d_range') byopts(note("")) ///  
lp("l" "_...") lwidth(medthick medthick) legend(cols(2) span  forcesize) xtitle("Day from FOMC decision") ytitle("Cumulative Excess Returns")
graph export "$path_g\sp500_nas_cr1_pub`tp'.emf", replace  //byopts(title("S&P and NASDAQ Cumulative Returns around FOMC vote" "`sub`tp''")) xlabel(`d_range') xtick(`d_range') ///
*save "$path3\fseries_dissent_pub`tp'.dta", replace  //*lp("l" "_..." "_-" "l-.." "_--") lwidth(medthick medthick medium medthick medium) ///
