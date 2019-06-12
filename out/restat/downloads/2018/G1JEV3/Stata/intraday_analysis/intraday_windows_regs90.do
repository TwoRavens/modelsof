set more off  //Note: As in GW (2016) and GSS (2005) we use standard S&P500 and yield changes (we do not apply risk-free TYield as LM(2015))
capture log close

local MDi=1 // local MDi = 1 // minute of data 1min=1, 5min=2, both=3  1/3
use "$path3\\Tick_1min_events_dissent90.dta", clear //use "$path3\\Tick_1min_events_dissent2.dta", clear //use "$path3\\Tick_5min_events_dissent.dta", clear 
drop if year>2002
drop if year==2002 & month>=3
g ESVol_log = ln(ES_volume)
g ESVol = ES_volume
rename SP_tickcou tickC_SP
rename ES_tickcou tickC_ES
sum *_volume //joinby date_day using "$path1\FED_dissent_3dayW.dta", unmatched(both) update
sum *_tickcount 
sum SP* //drop if SP_close==. // Trading Hours for bonds and stocks are different
drop *_volume *_tickcount
sum diss* date_FOMC
sum date_day day month year if date_FOMC==134 //keep if date_FOMC<.  // Use only days of anouncements  // check data after 2015?

replace hour=hour+1 // Chicago time is one hour behind DC/New York announcements
tab hour
bysort hour: tab minute // It seems market is active from 9:30 to 16:00 (NY/DC) or 8:30 to 15:00 (Chicago)
drop if hour==16 & minute>=1
tab date_FOMC  if hh_GW<=9 | hh_LM<=9 // problem dates 74, 123, 127, 134: 17sep2001, 17aug2007, 22jan2008, 08oct2008

local wlbeg "-10 -15"  //-20 -25 -30 //70 95 120  // Windows from 30 mins up to 150 mins (2.5 hours)
local wlend "20 45"  // Short and Wide windows
forv i=1/2 { //1/5
foreach x in GW { // Tight window 
local vy1 =  word("`wlbeg'",`i')
local vy2 =  word("`wlend'",`i')
g W`i'_`x'_mm_beg = mm_`x'+`vy1'  // GW Tight window (Beginning)
g W`i'_`x'_hh_beg = hh_GW //hh_`x'
replace W`i'_`x'_hh_beg = W`i'_`x'_hh_beg-1 if W`i'_`x'_mm_beg<0
replace W`i'_`x'_mm_beg = 60+W`i'_`x'_mm_beg if W`i'_`x'_mm_beg<0
g W`i'_`x'_mm_end = mm_`x'+`vy2' // GW Tight window (End)
g W`i'_`x'_hh_end = hh_GW //hh_`x'
forv k=1/2 {
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
}
egen any_window_GW = rowmax(W*_window_GW)

bysort date_FOMC: g day_obs=1 if _n==1 & date_FOMC<.
g date_FOMC2=date_FOMC if W1_window_GW==1
bysort date_FOMC2: g day_obs_window=1 if _n==1 & date_FOMC2<.
drop date_FOMC2

order date*, first
sort date_day
keep if any_window_GW==1  |  date_FOMC==123  |  date_FOMC==127  | date_FOMC==134  // | any_window_LM==1
drop if  (date_FOMC==123  | date_FOMC==127 | date_FOMC==134) & (hour>=12)
sort date_day hour minute
egen time = group(date_day hour minute)
foreach x in GW { 
forv i=1/2 { //1/5
g time1 = time if W`i'_window_`x'==1 
bysort date_day: egen time_beg`i'_`x'=min(time1) 
bysort date_day: egen time_end`i'_`x'=max(time1)
drop time1 
}
}
local vars1 "SP" // 
foreach x of local vars1 {
forv k=1/2 { //1/5
foreach v in GW { 
g var0 = ln(`x'_close) if time==time_beg`k'_`v'
g var1 = ln(`x'_close) if time==time_end`k'_`v'
replace var0 = ln(`x'_high) if time==time_beg`k'_`v' & dissent==1 & FOMC_public_vote==1
replace var1 = ln(`x'_low) if time==time_end`k'_`v' & dissent==1 & FOMC_public_vote==1
replace var0 = ln(`x'_low) if time==time_beg`k'_`v' & dissent==0
replace var1 = ln(`x'_high) if time==time_end`k'_`v' & dissent==0
bysort date_day: egen var00=mean(var0)
bysort date_day: egen var11=mean(var1)
g R`k'_`x'_`v'=var11-var00
drop var0 var1 var00 var11
}  
g R`k'_`x' = R`k'_`x'_GW
capture drop var0 var1 
capture drop var11* var00* var0_2 var1_2
pwcorr R`k'_`x'*
}
}
foreach x of local vars1 {  // For dates of 22jan2008 and 8oct2008
forv k=1/2 {  // 1/5 For 22jan2008 use ES futures quote of 1271.25 or 1325.27 as the closing value of the SP
g var1 = ln(`x'_close) if time==time_end`k'_GW  // For 08oct2008 use SP_close of 997.88 from previous day
replace var1 = ln(`x'_low) if time==time_end`k'_GW & dissent==1 
replace var1 = ln(`x'_high) if time==time_end`k'_GW & dissent==0
replace R`k'_`x' = var1-ln(1414.84) if date_FOMC==123
replace R`k'_`x' = var1-ln(1325.27) if date_FOMC==127
replace R`k'_`x' = var1-ln(997.88) if date_FOMC==134

sum `x'_close if date_FOMC==123 & hour==9 & minute>34 & minute<=40  //local r1=ln(r(min)) 
local r2=ln(r(max))
replace R`k'_`x' = `r2'-ln(1414.84) if date_FOMC==123 & R`k'_`x'==. //& dissent==0 

sum `x'_close if date_FOMC==127 & hour==9 & minute>34 & minute<=40
local r1=ln(r(min)) //local r2=ln(r(max))
replace R`k'_`x' = `r1'-ln(1325.27) if date_FOMC==127 & R`k'_`x'==. //& dissent==1

sum `x'_close if date_FOMC==134 & hour==9 & minute>34 & minute<=40  //local r1=ln(r(min)) 
local r2=ln(r(max))
replace R`k'_`x' = `r2'-ln(997.88) if date_FOMC==134 & R`k'_`x'==. //& dissent==0 
drop var1
}
}
sum R*_SP if date_FOMC==123  | date_FOMC==127  | date_FOMC==134
tab date_day date_FOMC if R1_SP==. //& R4_SP<. &  //replace R4_SP=. if date_FOMC==74 replace R5_SP=. if date_FOMC==74
sum R*_SP  // For 17sep2001 use SP_close of 1092.58 from 10sep2001 or ignore
capture drop R*_Ssprea*
//  //  //  //
local Xvars "FOMC_unscheduled FOMC_pub"
collapse R* `Xvars', by(date_day date_FOMC year month day dissent)
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
}  //   //	//		//		//		// if `MDi'==1 {  // For 1min ticks only
forv k=1/2 {  //1/5
replace R`k'_SP=100*R`k'_SP
replace R`k'_SP_GW=100*R`k'_SP_GW
}
g unanimity=(dissent==0)
g period = 1 if year>2002
replace period = 1 if year==2002 & month>=2
replace period = 2 if year>2007
replace period = 2 if year==2007 & month>=3
replace period = 3 if year>2009
replace period = 3 if year==2009 & month>=7
replace period = 0 if period==.
//   //
local vars1 "tickC_SP tickC_ES spread_CS_ES spread_CS_SP" // 
foreach x of local vars1 {
foreach v in GW { // LM
forv k=1/2 { //1/5
capture rename R`k'_`x'_`v' R`k'_`x'
capture rename R`k'_S`x'_`v' R`k'_S`x'
}
}
}
//   //
local vars1 "ESVol_log ESVol tickC_SP tickC_ES" // 
joinby date_day using "$path3\\GSS_factors.dta", unmatched(master) update
tab _merge
drop _merge //save "$path3\\Intraday_windows_all`MDi'.dta", replace
replace unanimity=(dissent==0) if unanimity==.
replace FOMC_pub=0 if FOMC_pub==.

local vars11 "SP TY FV TU ES_GW IAP ED ESVol_log ESVol_GW tickC_SP tickC_ES"
local Xvars0 "Kuttner_surprise FOMC_unscheduled" // ffr_original
local Vxn=1
foreach Vx in "" "R" "B" {  //
if `Vxn'==1 {
local varR ""
}
if `Vxn'==2 {
local varR "vce(robust)"
}
if `Vxn'==3 {
local varR "vce(bootstrap, reps(${Breps}))"
}
local vars11 "SP" 
foreach var of local vars11 {  // SP500 returns
forv k=1/2 {
reg R`k'_`var' dissent unanimity if period==0, nocons `varR' 
test dissent=unanimity
outreg2 using "${path0T`MDi'`Vx'}\\IDr`k'_`var'_90.xls", replace
}  //}
}
/*foreach var of local vars11 { // With Controls //  //	//		//		//
forv k=1/2 {
reg R`k'_`var' dissent unanimity `Xvars0' if period==0, nocons `varR' 
test dissent=unanimity
outreg2 using "${path0T`MDi'`Vx'}\\IDr`k'_`var'_Xv_90.xls", replace
}  //}
}
foreach var of local vars11 { // With Controls //  //	//		//		//
forv k=1/2 {
reg R`k'_`var' dissent unanimity ffs_factor1 ffs_factor2 `Xvars0' if period==0, nocons `varR' 
test dissent=unanimity
outreg2 using "${path0T`MDi'`Vx'}\\IDr`k'_`var'_XvF_90.xls", replace
reg R`k'_`var' dissent unanimity ffs_factor1 ffs_factor2 if period==0, nocons `varR' //  //	//		//		//
test dissent=unanimity
outreg2 using "${path0T`MDi'`Vx'}\\IDr`k'_`var'_XvF_90.xls", append
}  //}
}  //		//		//		//		//		//		//		//		//		//   */
local Vxn=1+`Vxn'
}
//   //
