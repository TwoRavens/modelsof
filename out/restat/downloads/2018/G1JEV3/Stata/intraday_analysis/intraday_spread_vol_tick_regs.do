set more off  //Note: As in GW (2016) and GSS (2005) we use standard S&P500 and yield changes (we do not apply risk-free TYield as LM(2015))
capture log close

forv MDi=1/2 {  // local MDi = 1 // minute of data 1min=1, 5min=2, both=3  1/3
if `MDi'==1 {  // For 1min, 5min, both analysis
use "$path3\\Tick_1min_events_dissent.dta", clear //use "$path3\\Tick_1min_events_dissent2.dta", clear //use "$path3\\Tick_5min_events_dissent.dta", clear 
}
if `MDi'==2 {  // For 5min analysis
use "$path3\\Tick_5min_events_dissent.dta", clear 
}
if `MDi'==3 {  // For both analysis
use "$path3\\Tick_1min_events_dissent2.dta", clear 
}
drop if year<1994 // FOMC meetings in 1993, but no press statements
drop if year>${Lyear} // Same period as daily data analysis
g ESVol_log = ln(ES_volume)
g ESVol = ES_volume
rename SP_tickcou tickC_SP
rename ES_tickcou tickC_ES
sum *_volume //joinby date_day using "$path1\FED_dissent_3dayW.dta", unmatched(both) update
sum *_tickcount  //sum SP*  //drop if SP_close==. // Trading Hours for bonds and stocks are different
drop *_volume *_tickcount
keep if date_FOMC<.  // Use only days of anouncements
replace hour=hour+1 // Chicago time is one hour behind DC/New York announcements
tab hour // It seems market is active from 9:30 to 16:00 (NY/DC) or 8:30 to 15:00 (Chicago)
drop if hour==16 & minute>=1
joinby date_day using "$path1\FED_dissent_3dayW.dta", unmatched(master) update
tab _merge
drop _merge

// Make two windows: pre-announcement volume the accumulated one between -10 and -1 mins and the accumulated volume of +1 to +20 mins
// Window 2: pre-announcement volume accumulated between -15 and -1 and the accumulated of +1 to +45mins
local wlbeg "-10 -15 -5" // -20 -25 -30
local wlend "20 45 5"  // 70 95 120 Windows from 30 mins up to 150 mins (2.5 hours)
forv i=1/3 { //1/5
foreach x in GW LM { // LM GL1 GL2 GL3 Tight window
local vy1 =  word("`wlbeg'",`i')
local vy2 =  word("`wlend'",`i')
g W`i'_`x'_mm_beg = mm_`x'+`vy1'  // GW Tight window (Beginning)
g W`i'_`x'_hh_beg = hh_GW //hh_`x'
replace W`i'_`x'_hh_beg = W`i'_`x'_hh_beg-1 if W`i'_`x'_mm_beg<0
replace W`i'_`x'_mm_beg = 60+W`i'_`x'_mm_beg if W`i'_`x'_mm_beg<0
g W`i'_`x'_mm_end = mm_`x'+`vy2' // GW Tight window (End)
g W`i'_`x'_hh_end = hh_GW //hh_`x'
forv k=1/3 {
replace W`i'_`x'_hh_end = W`i'_`x'_hh_end+1 if W`i'_`x'_mm_end>=60
replace W`i'_`x'_mm_end = W`i'_`x'_mm_end-60 if W`i'_`x'_mm_end>=60
}
//   //    //
g W`i'_window_`x'=.
replace W`i'_window_`x'=1 if hour==W`i'_`x'_hh_beg & minute>=W`i'_`x'_mm_beg & minute<=60 & hour<W`i'_`x'_hh_end
replace W`i'_window_`x'=1 if hour==W`i'_`x'_hh_beg & minute>=W`i'_`x'_mm_beg & minute<=W`i'_`x'_mm_end & hour==W`i'_`x'_hh_end
replace W`i'_window_`x'=1 if hour>W`i'_`x'_hh_beg & minute>=0 & minute<=W`i'_`x'_mm_end & hour==W`i'_`x'_hh_end
replace W`i'_window_`x'=1 if hour>W`i'_`x'_hh_beg & minute>=0 & minute<=60 & hour<W`i'_`x'_hh_end
}
sum W`i'_window_GW W`i'_window_LM
replace W`i'_window_GW = 0 if W`i'_window_LM==1 & W`i'_window_GW==.
replace W`i'_window_LM = 0 if W`i'_window_GW==1 & W`i'_window_LM==.
tab W`i'_window_GW W`i'_window_LM
}
egen any_window_GW = rowmax(W*_window_GW)
egen any_window_LM = rowmax(W*_window_LM)
joinby date_day using "$path3\\Tick_5min_events_lagfw.dta", unmatched(master) update
tab _merge
drop _merge
//   //    //

bysort date_FOMC: g day_obs=1 if _n==1 & date_FOMC<.
g date_FOMC2=date_FOMC if W1_window_GW==1
bysort date_FOMC2: g day_obs_window=1 if _n==1 & date_FOMC2<.
drop date_FOMC2

order date*, first
sort date_day
keep if any_window_GW==1 | any_window_LM==1  |  date_FOMC==123  |  date_FOMC==127  | date_FOMC==134
drop if  (date_FOMC==123  |  date_FOMC==127  | date_FOMC==134) & (hour>=12)
sort date_day hour minute
egen time = group(date_day hour minute)
foreach x in GW LM { //GL1 GL2 GL3 
forv i=1/3 { //1/5
g time1 = time if W`i'_window_`x'==1 
bysort date_day: egen time_beg`i'_`x'=min(time1) 
bysort date_day: egen time_end`i'_`x'=max(time1)
drop time1 
}
}
tsset time
local vars1 "ESVol tickC_SP tickC_ES" // ESVol_log 
foreach x of local vars1 {
foreach v in GW { // LM
forv k=1/2 { //1/5
g time0=time if time>=time_beg`k'_`v' & `x'<. & time<time_beg3_`v'
bysort date_FOMC: egen time00=min(time0)
g time1=time if time<=time_end`k'_`v' & `x'<. & time>time_end3_`v'
bysort date_FOMC: egen time11=max(time1)

g var0 = `x' if time>=time00 & time<time_beg3_`v'
g var1 = `x' if time<=time11 & time>time_end3_`v'
bysort date_day: egen var00=total(var0), missing
bysort date_day: egen var11=total(var1), missing
g R`k'_`x'_`v'=var11-var00
g R`k'_S`x'_`v'=100*(var11/var00)
drop var0 var1 var00 var11 time0 time1 time00 time11
}
}
}
capture drop R*_SESVol_log*
//    //   //
if `MDi'==2 {  // For 5min analysis
local vars1 "spread_CS_ES spread_CS_SP" // 
foreach x of local vars1 {
foreach v in GW { // LM
forv k=1/2 { //1/5
g time0=time if time>=time_beg`k'_`v' & `x'<. & time<time_beg3_`v'
bysort date_FOMC: egen time00=min(time0)
g time1=time if time<=time_end`k'_`v' & `x'<. & time>time_end3_`v'
bysort date_FOMC: egen time11=max(time1)

g var0 = `x' if time>=time00 & time<time_beg3_`v'
g var1 = `x' if time<=time11 & time>time_end3_`v'
bysort date_day: egen var00=mean(var0)
bysort date_day: egen var11=mean(var1)
g R`k'_`x'_`v'=var11-var00
drop var0 var1 var00 var11 time0 time1 time00 time11
}
}
}
}
//  //  //  //
local Xvars "Kuttner_surprise FOMC_unscheduled ffr_original FOMC_pub"
collapse R* `Xvars' ESVol_log_lag ESVol_lag, by(date_day date_FOMC year month day dissent)
quietly {   //   //	//		//		//		//
joinby date_FOMC using "$path1\FOMC_Xvars.dta", unmatched(master) update
tab _merge
tab date_day date_FOMC if dissent_la2==.
drop _merge
joinby date_FOMC using "$path1\FED_dissent_date_extralags.dta", unmatched(master) update
tab _merge
drop _merge
joinby date_FOMC using "$path1\\dissent_pastTrack.dta", unmatched(master) update
tab _merge
drop _merge
joinby year month using "$path1\CycleDummyVariables.dta", unmatched(master) update
tab _merge
drop _merge DATE
local XVdlag "dissent_la dissent_lag Dp1_lag Dp2_lag dissent_p1_lag dissent_p2_lag dissent_p3_lag dummy_LG dummy_LGH D_Multiple_dissent past_dissent_pc_Dmembers past_dissent_pc_Dm"
foreach var of local XVdlag { 
replace `var'2 = `var' if FOMC_pu==1 & `var'2==.  // or FOMC_pub==1
replace `var'2 = 0 if FOMC_pu==0 & `var'2==.
}
foreach var of varlist dif2_VIX-index_dv {
replace `var' = 0 if `var'==.
}
capture replace dummy_Greenspan = 1 if year<=2005
capture replace dummy_Yellen = 0 if year<2014 
drop quarter-past_dissent_pcm
}  //   //	//		//		//		//
g unanimity=(dissent==0)
g period = 1 if year>2002
replace period = 1 if year==2002 & month>=2
replace period = 2 if year>2007
replace period = 2 if year==2007 & month>=3
replace period = 3 if year>2009
replace period = 3 if year==2009 & month>=7
replace period = 0 if period==.
//   //
g FOMC_nonpublic=(FOMC_public_vote==0)
g unanimity_public=(dissent==0 & FOMC_public_vote==1)
g dissent_public=(dissent==1 & FOMC_public_vote==1)
g unanimity_nonpublic=(dissent==0 & FOMC_public_vote==0)
g dissent_nonpublic=(dissent==1 & FOMC_public_vote==0)
g SQ_Kuttner_surprise=Kuttner_surprise^2
g ABS_Kuttner_surprise=abs(Kuttner_surprise)
save "$path3\\Intraday_spread_vol_tick_data`MDi'.dta", replace //   //

local Xvars0 "Kuttner_surprise FOMC_unscheduled" // ffr_original
local Vxn=1
foreach Vx in "" "R" "B" {
if `Vxn'==1 {
local varR ""
}
if `Vxn'==2 {
local varR "vce(robust)"
}
if `Vxn'==3 {
local varR "vce(bootstrap, reps(${Breps}))"
}
local esave1 "replace"
local esave2 "append"

local vp0 "tickC_SP StickC_SP tickC_ES StickC_ES" //"TY FV TU ES ED"
local vp1 "tickC_SP StickC_SP ESVol_GW SESVol_GW tickC_ES StickC_ES" //ESVol_log 
if `MDi'==2 {  // For 5min analysis
local vp0 "tickC_SP StickC_SP spread_CS_SP tickC_ES StickC_ES spread_CS_ES" //"TY FV TU ES ED"
local vp1 "tickC_SP StickC_SP spread_CS_SP ESVol_GW SESVol_GW tickC_ES StickC_ES spread_CS_ES" //ESVol_log 
}
forv k=1/2 {
local es=1
foreach var of local vp1 {  //For the public votes entire period
reg R`k'_`var' dissent unanimity if period>=1, nocons `varR'
outreg2 using "${path0T`MDi'`Vx'_2}\Vols_ticks_spreads`k'_pub.xls", `esave`es''
reg R`k'_`var' dissent if period>=1, `varR'
outreg2 using "${path0T`MDi'`Vx'_2}\Vols_ticks_IDay`k'_pub.xls", `esave`es''
local es=2
}
forv p=0/3 {
local p2=min(1,`p')
local es=1
foreach var of local vp`p2' {  //foreach v in GW LM {
reg R`k'_`var' dissent unanimity if period==`p', nocons `varR'
outreg2 using "${path0T`MDi'`Vx'_2}\Vols_ticks_spreads`k'_P`p'.xls", `esave`es''
reg R`k'_`var' dissent if period==`p', `varR'
outreg2 using "${path0T`MDi'`Vx'_2}\Vols_ticks_IDay`k'_P`p'.xls", `esave`es''
local es=2
}
}
}
//    // 
local vars11 "ESVol_GW SESVol_GW tickC_SP StickC_SP tickC_ES StickC_ES" //SP TY FV TU ES_GW IAP ED ESVol_log 
if `MDi'==2 {  // For 5min analysis
local vars11 "ESVol_GW SESVol_GW tickC_SP StickC_SP tickC_ES StickC_ES spread_CS_SP spread_CS_ES" //SP TY FV TU ES_GW IAP ED ESVol_log 
}
forv k=1/2 {  // Regressions with all data plus controls
local es=1
foreach var of local vars11 { 
reg R`k'_`var' FOMC_nonpublic dissent_pub unanimity_pub `Xvars0', nocons `varR' 
test dissent_pub=unanimity_pub
outreg2 using "${path0T`MDi'`Vx'}\\RX_Vols_ticks_spreads`k'_allvars_Xv.xls", `esave`es''
local es=2
}
}
// 
//	//		//		//		//		//		//		//		//		//		//
local Xvars2 "dissent_p1_lag2 D_Multiple_dissent2 dissent_la2 past_dissent_pc_Dmembers2" // dissent_lag2
forv k=1/2 {  // Regressions with all data plus More controls
local es=1
foreach var of local vars11 { 
reg R`k'_`var' FOMC_nonpublic dissent_pub unanimity_pub `Xvars0' `Xvars2', nocons `varR' 
test dissent_pub=unanimity_pub
outreg2 using "${path0T`MDi'`Vx'}\\RX_Vols_ticks_spreads`k'_Xmore.xls", `esave`es''
local es=2
}
}
// 
local Xvars2 "dissent_p1_lag2 dissent_la2" // dissent_lag2
forv k=1/2 {  // Regressions with all data plus More controls  //SQ_Kuttner_surprise ABS_Kuttner_surprise FOMC_unscheduled
local es=1
foreach var of local vars11 { 
reg R`k'_`var' FOMC_nonpublic dissent_pub unanimity_pub `Xvars0' `Xvars2', nocons `varR' 
test dissent_pub=unanimity_pub
outreg2 using "${path0T`MDi'`Vx'}\\RX_Vols_ticks_spreads`k'_XXmore.xls", `esave`es''
local es=2
}
}
//	//		//		//		//		//		//		//		//		//		//

local Vxn=1+`Vxn'
}
//   //
}
//   // //   //
