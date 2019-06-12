set more off  //Note: As in GW (2016) and GSS (2005) we use standard S&P500 and yield changes (we do not apply risk-free TYield as LM(2015))
capture log close

use "$path0\FOMC_timeseries.dta", clear
joinby date_day date_FOMC day month year using "$path3\\Intraday_MoreData2.dta", unmatched(master) update
tab _merge
drop _merge
/*joinby date_day date_FOMC day month year using "$path3\\Intraday_spread_vol_tick_data2.dta", unmatched(master) update
tab _merge
drop _merge*/
foreach var of varlist R1_ED_GW R1_TU_GW R1_FV_GW R1_TY_GW R2_ED_GW R2_TU_GW R2_FV_GW R2_TY_GW { 
replace `var' = 100*`var' // futures in basis points
}
local vars1 "ED TU FV TY"
forv w=1/2 {
foreach var of local vars1 { 
replace R`w'_`var'_GW = R1_`var'_GW if  R`w'_`var'_GW==.
replace R`w'_`var'_GW = R2_`var'_GW if  R`w'_`var'_GW==.
}
}
capture drop R1_SP_GL7- R5_SP R3_* *R4_* *R5_*
drop if R1_SP==. & R2_SP==. & date_FOMC==134
replace R1_SP=R2_SP if R1_SP==.
replace R2_SP=R1_SP if R2_SP==.
tab date_FOMC if FOMC_unscheduled==1 & year>=1994
sort date_day

drop if year<1994 //drop if FOMC_unscheduled==1 //drop if date_FOMC==74 | date_FOMC==123 | date_FOMC==127 | date_FOMC==134
forv w=1/2 {

putexcel A1=("Variables") B1=("U 1994-02") C1=("D 1994-02") D1=("U 2002-18") E1=("D 2002-18") using "$path0T\\ID_sum`w'.xls", sheet("Sheet1") replace
local k=2
quietly  {  //    //    //  //
foreach var of varlist R`w'_SP {
foreach stat in "mean" "p50" "sd" "min" "max" "N" {
sum `var' if FOMC_pub==0 & dissent==0, d
putexcel A`k'=("`var' - `stat'") B`k'=(r(`stat')) using "$path0T\\ID_sum`w'.xls", sheet("Sheet1") modify
sum `var' if FOMC_pub==0 & dissent==1, d
putexcel C`k'=(r(`stat')) using "$path0T\\ID_sum`w'.xls", sheet("Sheet1") modify
sum `var' if FOMC_pub==1 & dissent==0, d
putexcel D`k'=(r(`stat')) using "$path0T\\ID_sum`w'.xls", sheet("Sheet1") modify
sum `var' if FOMC_pub==1 & dissent==1, d
putexcel E`k'=(r(`stat')) using "$path0T\\ID_sum`w'.xls", sheet("Sheet1") modify
local k=1+`k'
}
}  //   //  //
foreach var of varlist R`w'_ED_GW R`w'_TU_GW R`w'_FV_GW R`w'_TY_GW {
foreach stat in "mean" "p50" "sd" "N" {
sum `var' if FOMC_pub==0 & dissent==0, d
putexcel A`k'=("`var' - `stat'") B`k'=(r(`stat')) using "$path0T\\ID_sum`w'.xls", sheet("Sheet1") modify
sum `var' if FOMC_pub==0 & dissent==1, d
putexcel C`k'=(r(`stat')) using "$path0T\\ID_sum`w'.xls", sheet("Sheet1") modify
sum `var' if FOMC_pub==1 & dissent==0, d
putexcel D`k'=(r(`stat')) using "$path0T\\ID_sum`w'.xls", sheet("Sheet1") modify
sum `var' if FOMC_pub==1 & dissent==1, d
putexcel E`k'=(r(`stat')) using "$path0T\\ID_sum`w'.xls", sheet("Sheet1") modify
local k=1+`k'
}
}
}  //    //    //  //

}
pwcorr R1_SP R2_SP if FOMC_pub==0 & dissent==0 
pwcorr R1_SP R2_SP if FOMC_pub==0 & dissent==1
pwcorr R1_SP R2_SP if FOMC_pub==1 & dissent==0 
pwcorr R1_SP R2_SP if FOMC_pub==1 & dissent==1 
/*foreach var of varlist R1_SP R1_ED_GW R1_TU_GW R1_FV_GW R1_TY_GW {
g mean_`var'= `var'
g median_`var'= `var'
g sd_`var'= `var'
}
collapse (mean) mean_* (median) median_* (sd) sd_*, by(FOMC_public dissent)*/

use "$path3\\Intraday2_spread_vol_tick_data2.dta", clear //"$path3\\Intraday_spread_vol_tick_data2.dta" "$path3\\Intraday2_spread_vol_tick_data2.dta"
drop if year<1994 //drop if FOMC_unscheduled==1 //drop if date_FOMC==74 | date_FOMC==123 | date_FOMC==127 | date_FOMC==134
forv w=1/2 {
putexcel A1=("Variables") B1=("U 1994-02") C1=("D 1994-02") D1=("U 2002-18") E1=("D 2002-18") using "$path0T\\ID_ESVol`w'.xls", sheet("Sheet1") replace
local k=2
quietly  {  //    //    //  //
foreach var of varlist R`w'_ESVol_GW {
foreach stat in "mean" "p50" "sd" "N" {
sum `var' if FOMC_pub==0 & dissent==0, d
putexcel A`k'=("`var' - `stat'") B`k'=(r(`stat')) using "$path0T\\ID_ESVol`w'.xls", sheet("Sheet1") modify
sum `var' if FOMC_pub==0 & dissent==1, d
putexcel C`k'=(r(`stat')) using "$path0T\\ID_ESVol`w'.xls", sheet("Sheet1") modify
sum `var' if FOMC_pub==1 & dissent==0, d
putexcel D`k'=(r(`stat')) using "$path0T\\ID_ESVol`w'.xls", sheet("Sheet1") modify
sum `var' if FOMC_pub==1 & dissent==1, d
putexcel E`k'=(r(`stat')) using "$path0T\\ID_ESVol`w'.xls", sheet("Sheet1") modify
local k=1+`k'
}
}  //   //  //
}
}
//    //    //  //

