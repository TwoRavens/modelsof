set more off
local sub0 "Period before votes in press release"
local sub1 "Period with votes in press release"
local tp=0

use "$path1\bloomberg2_dissent.dta", clear
drop if year<${year_min}
drop if window>1
drop if window<-1
local d_range = "-1(1)1"
sum date_FOMC
local dF1=r(min)
local dF2=r(max)
sum window
local w1 = r(min)
local w1_1 = `w1'+1
local w2 = r(max)
tab FOMC_session_public
sum date_day if FOMC_session_public==1
local d_pmin = r(min)-`sw'-1-3
g FOMC_public = FOMC_session_public  // Time window over which FOMC votes were public
replace FOMC_public = 1 if date_day>`d_pmin'  

sum S_P500_itv NASDAQ_itv DAX_itv FTSE100_itv CAC40_itv IBEX_itv SMI_itv
pwcorr S_P500_itv NASDAQ_itv DAX_itv FTSE100_itv CAC40_itv IBEX_itv SMI_itv // Standardize Intensity of trading relative to first day of window
quietly {
foreach var of varlist S_P500_itv NASDAQ_itv DAX_itv FTSE100_itv CAC40_itv IBEX_itv SMI_itv { //American, American Tech, German, UK, Frence, Spain and Swiss stock returns
g `var'2 = ln(`var')
g `var'1 = ln(`var')
sum `var'1, d
replace `var'1 = `var'1-r(mean)
forv d=`dF1'/`dF2' {
sum `var'2 if date_FOMC==`d' & window==`w1'
replace `var'2 = `var'2-r(min) if date_FOMC==`d' 
}
}        
foreach var of varlist S_P500_itv NASDAQ_itv DAX_itv FTSE100_itv CAC40_itv IBEX_itv SMI_itv {  //American, American Tech, German, UK, Frence, Spain and Swiss stock returns
g S_`var' = `var'
g `var'0 = `var' if window==-1
bysort date_FOMC: egen `var'00=mean(`var'0)
replace S_`var'=100*(S_`var'/`var'00)
drop `var'0 `var'00
sum S_`var', d
replace S_`var' = min(S_`var', r(p99))     
}
}
sum *S_P500_itv*, d
save "$path1\data_work.dta", replace

forv tp=0/1 {
use "$path1\data_work.dta", clear
keep if FOMC_public==`tp' 
collapse  *itv*, by(window1 dissent)
xtset dissent window1

label variable dissent "dissent"
label def dissent_l 0 "Unanimity" 1 "Dissent"
label values dissent dissent_l

local sw0 = "S&P NASDAQ VIX DAX FTSE100 CAC40 IBEX SMI"
local sw1 = "S&P NASDAQ DAX FTSE100 CAC40 IBEX SMI" 
local i=1
foreach x of varlist S_P500_itv-VIX_itv DAX_itv-SMI_itv {
local sw =  word("`sw0'",`i')
label variable `x' "`sw'"
local i = 1+`i'		
}
local i=1
foreach x of varlist S_P500_itv1-SMI_itv1 {
local sw =  word("`sw0'",`i')
label variable `x' "`sw'"
local i = 1+`i'		
}
local i=1
foreach x of varlist S_S_P500_itv-S_SMI_itv {
local sw =  word("`sw0'",`i')
label variable `x' "`sw'"
local i = 1+`i'		
}
//
// Graphics for effect of Dissent on Stock Market Trading
xtline S_P500_itv, /// NASDAQ_itv
byopts(title("")) xlabel(`d_range') xtick(`d_range') ///
lp("l" "_...") lwidth(medthick medthick) byopts(note("")) ///
legend(cols(2) span  forcesize) xtitle("Day from FOMC decision") ytitle("Nr of Transactions") 
graph export "$path_g\sp500_itv1_pub`tp'.emf", replace //save "$path_d\fseries_dissent_pub`tp'.dta", replace
xtline S_P500_itv1, /// NASDAQ_itv
byopts(title("")) xlabel(`d_range') xtick(`d_range') ///
lp("l" "_...") lwidth(medthick medthick) byopts(note("")) ///
legend(cols(2) span  forcesize) xtitle("Day from FOMC decision") ytitle("Log-Transactions") 
graph export "$path_g\sp500_Litv1_pub`tp'.emf", replace //save "$path_d\fseries_dissent_pub`tp'.dta", replace
xtline S_S_P500_itv, /// NASDAQ_itv
byopts(title("")) xlabel(`d_range') xtick(`d_range') ///
lp("l" "_...") lwidth(medthick medthick) byopts(note("")) ///
legend(cols(2) span  forcesize) xtitle("Day from FOMC decision") ytitle("Standardized Volume") 
graph export "$path_g\sp500_Sitv1_pub`tp'.emf", replace //save "$path_d\fseries_dissent_pub`tp'.dta", replace
}
//   //   //
