set more off  // format 1993-2013 vote data
*use "D:\Docs2\CM_JM\FED_votes93_13f.dta", clear //\FED_dissent_governors.dta" //FED_dissent_date_governors.dta"
use "$pathF2\FED_dissent_date.dta", clear
sum
clear
import excel "$path1\FED_unscheduled.xlsx", sheet("Sheet1") firstrow
generate date_day = date(Date, "MDY")
format %td date_day
keep date_day
save "$pathF2\data_temp.dta", replace

use "$pathF\bloomberg2.dta", clear
joinby date_day using "$pathF2\FED_dissent_date.dta", unmatched(both) update
tab _merge
g FOMC_session = (_merge==3)
g FOMC_session_public = (FOMC_public_vote==1)
drop _merge
joinby date_day using "$pathF2\data_temp.dta", unmatched(both) update
tab _merge
g FOMC_unscheduled = (_merge==3)

sort date_day
egen date_BS = group(date_day)
sum date_FOMC
local dF1=r(min)
local dF2=r(max)
sum date_BS
local dB1=r(min)
local dB2=r(max)
quietly {  // "2 3 1" "3 1 2 5 8 10 12" 
local sw0 = "${sw_op}"  // FOMC meets on average every 6 weeks (5*6==30 business days), 
		// therefore largest window should be -14,0,+14
local i = 1		
*forv i=1/4 { 
g sample`i' = 0 
g window`i' = .
*}
forv d=`dF1'/`dF2' {
sum date_BS if date_FOMC==`d'
local dbw = r(mean)
*forv i=1/4 { 
local sw =  real(word("`sw0'",`i'))
local sw2 = 1+2*`sw'
local dw1=`dbw'-`sw'
local dw2=`dbw'+`sw'
replace sample`i' = 1 if date_BS>=`dw1' & date_BS<=`dw2'
replace window`i' = date_BS-`dbw' if date_BS>=`dw1' & date_BS<=`dw2' & window`i'==.
foreach var of varlist date_FOMC-FOMC_session_public FOMC_unscheduled { 
sum `var' if date_FOMC==`d' 
replace `var' = r(mean) if date_BS>=`dw1' & date_BS<=`dw2' & `var'==.
}
*}
}
}
sum sample* window*
sort date_BS
tsset date_BS
if ${std_op}==0 { 
foreach var of varlist S_P500_p NASDAQ_p DAX_p FTSE100_p CAC40_p IBEX_p SMI_p { 
//American, American Tech, German, UK, Frence, Spain and Swiss stock returns
g `var'_exreturn = ln(`var')
g lag0 = L.`var'_exreturn
replace `var'_exreturn = `var'_exreturn-lag0
drop lag0
}
}
//    // Compute FED surprise   //
replace Fed_fund_rate_futures_p = 100-Fed_fund_rate_futures_p
replace Euro_dollar_futures_3m_p = 100-Euro_dollar_futures_3m_p
pwcorr Fed_fund_rate_futures_p Euro_dollar_futures_3m_p
pwcorr Fed_fund_rate_futures_p ffr
g Date = date_day
capture drop _merge
joinby Date using "$pathF2\FED_surprise.dta", unmatched(master) update
tab _merge
drop _merge
tsset date_BS
g KS2 = L.Fed_fund_rate_futures_p
replace KS2 = Fed_fund_rate_futures_p-KS2
replace KS2 = (D/(D-day))*KS2 if dummy_3days==0
replace KS2 = round(100*KS2)
pwcorr Kuttner_surprise KS2
sum Kut  KS2 if KS2<. & Kut<.
drop Date D dummy_3days KS2
sort date_BS
g ffr_original = ffr_nr
quietly {
sum date_BS
local dB1=r(min)
local dB2=r(max)
forv d=`dB1'/`dB2' {
g ff_last = ffr_nr if date_BS<=`d'
egen date_fomc = group(date_BS) if date_BS<=`d' & ff_last<.
sum date_fomc
local dB3=r(max)
sum ff_last if date_fomc>=`dB3'
local dB4=r(max)
replace ffr_nr = `dB4' if date_BS<=`d' & ffr_nr==.
capture drop ff_last date_fomc
}
}
replace Kuttner_surprise = 0 if Kuttner_surprise==.  //   //    //
joinby date_day using "$path1\yields_d.dta", unmatched(master) update
tab _merge
drop _merge
egen TBill_3M = rowmin(YTM_3M DGS3MO_TBi DTB3_Tbil)
replace TBill_3M = max(0, TBill_3M) if TBill_3M<.
egen TBill_3M0 = rowmax(YTM_3M DGS3MO_TBi DTB3_Tbil)
sum TBill_3M TBill_3M0 YTM_3M DGS3MO_TBill3m_cmr DTB3_Tbill3m_smr Libor_3m_p USA_TB10y_p
pwcorr TBill_3M TBill_3M0 YTM_3M DGS3MO_TBill3m_cmr DTB3_Tbill3m_smr Libor_3m_p USA_TB10y_p
save "$pathF\bloomberg2_dissent.dta", replace
save "$path1\bloomberg2_dissent.dta", replace

//  Event dates to Excel file
use "$pathF\bloomberg2_dissent.dta", clear
keep if sample1==1
keep date_day day month year quarter S_P500_p date_FOMC FOMC_public_vote dissent date_BS FOMC_session FOMC_session_public sample1 window1
sum
*edit
drop if window1==-3
drop if window1==3
tab window1
drop S_P500_p date_FOMC FOMC_public_vote dissent date_BS FOMC_session FOMC_session_public sample1 window1
bysort year: sum date_day
save "$pathF2\bloomberg_event_dates.dta", replace  //     //                //
save "$path1\bloomberg_event_dates.dta", replace

use "$pathF\bloomberg2_dissent.dta", clear
local sw2 = (1-${std_op})+2*`sw'
display "`sw2'"
keep if sample1==1
drop sample* 
*drop window2-window4 
quietly {
foreach var of varlist S_P500_p NASDAQ_p DAX_p FTSE100_p CAC40_p IBEX_p SMI_p { 
//American, American Tech, German, UK, Frence, Spain and Swiss stock returns
if ${std_op}==1 { //  Old way
g `var'_exreturn = ln(`var')
}
//  //           ///
forv d=`dF1'/`dF2' {

if ${std_op}==0 { 
sum window if date_FOMC==`d'
local dbw1 = 1+r(min)
local dbw2 = r(max)
forv dbw=`dbw1'/`dbw2' {
local dbw0=`dbw'-1
sum `var'_exreturn if date_FOMC==`d' & window==`dbw0'
replace `var'_exreturn = `var'_exreturn+r(min) if date_FOMC==`d' & window==`dbw'
}
}
//    //   ///
if ${std_op}==1 { //  Old way
*g `var'_exreturn = ln(`var')
sum window if date_FOMC==`d' & `var'_exreturn <.
local dbw = r(min)
sum `var'_exreturn if date_FOMC==`d' & window==`dbw' & `var'_exreturn <.
local dbm0 = r(min)
replace `var'_exreturn = `var'_exreturn-`dbm0' if date_FOMC==`d' 
}
//    //  ///  
}
replace `var'_exreturn = (262/`sw2')*`var'_exreturn // Annualize excess returns  
}
}
capture drop _merge
save "$pathF\bloomberg2_dissent.dta", replace  //  //  //
save "$path1\bloomberg2_dissent.dta", replace

use "$pathF\bloomberg2_dissent.dta", clear
keep if window1<.
g FFrate = ffr_original if window1>=0 & window1<=1
keep date_day day month year quarter dissent dissent_ma dissent_la nr_dissents nr_dissents_ma ///
nr_dissents_la exp_votes_dissents exp_NO_dissents exp_dissents_FOMC period_past_dissent ///
period_total_dissent dissent_lag Fed_fund_rate_futures_p date_FOMC FOMC_public_vote ///
FOMC_session FOMC_session_public FOMC_unscheduled date_BS window1 Kuttner_surprise ///
FFrate  ffr_original date_day2 //FOMC_meeting_Kuttner
save "$pathF2\FED_dissent_6dayW_vs1.dta", replace

use "$pathF2\FED_dissent_6dayW_vs0.dta" 
drop date_FOMC
save "$pathF2\FED_dissent_6dayW_vs00.dta", replace 

use "$pathF2\FED_dissent_6dayW_vs1", clear
joinby date_day using "$pathF2\FED_dissent_6dayW_vs00", unmatched(master) update
tab _merge
drop _merg
save "$pathF\FED_dissent_6dayW.dta", replace
save "$path1\FED_dissent_6dayW.dta", replace
