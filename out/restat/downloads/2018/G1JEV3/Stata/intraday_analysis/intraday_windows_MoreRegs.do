set more off  //Note: As in GW (2016) and GSS (2005) we use standard S&P500 and yield changes (we do not apply risk-free TYield as LM(2015))
capture log close

forv MDi=1/2 {  // 1/3 local MDi = 1 // minute of data 1min=1, 5min=2, both=3
if `MDi'==1 {  // For 1min, 5min, both analysis
use "$path3\\Tick_1min_events_dissent.dta", clear //use "$path3\\Tick_1min_events_dissent2.dta", clear //use "$path3\\Tick_5min_events_dissent.dta", clear 
}
if `MDi'==2 {  // For 1min, 5min, both analysis
use "$path3\\Tick_5min_events_dissent.dta", clear 
}
if `MDi'==3 {  // For 1min, 5min, both analysis
use "$path3\\Tick_1min_events_dissent2.dta", clear 
}
drop if year<1994 // FOMC meetings in 1993, but no press statements
drop if year>${Lyear} // Same period as daily data analysis
g ESVol_log = ln(ES_volume)
g ESVol = ES_volume
sum *_volume //joinby date_day using "$path1\FED_dissent_3dayW.dta", unmatched(both) update
sum *_tickcount 
sum SP* //drop if SP_close==. // Trading Hours for bonds and stocks are different
drop *_volume *_tickcount
sum diss* date_FOMC
keep if date_FOMC<.  // Use only days of anouncements
replace hour=hour+1 // Chicago time is one hour behind DC/New York announcements
tab hour
bysort hour: tab minute // It seems market is active from 9:30 to 16:00 (NY/DC) or 8:30 to 15:00 (Chicago)
drop if hour==16 & minute>=1
tab date_FOMC  if hh_GW<=9 | hh_LM<=9 // problem dates 74, 123, 127, 134: 17sep2001, 17aug2007, 22jan2008, 08oct2008 (meeting of 07oct2008)
tab date_FOMC  if hh_GW>=16 | hh_LM>=16
tab hh_GW if date_FOMC==134
tab date_day if  date_FOMC==74 |  date_FOMC==123  |  date_FOMC==127  | date_FOMC==134
tab hh_GW if date_FOMC==74  |  date_FOMC==123  |  date_FOMC==127  | date_FOMC==134
tab mm_GW mm_LM if date_FOMC==74  |  date_FOMC==123  |  date_FOMC==127  | date_FOMC==134 // same exact time in GW and LM
g aa=(hh_GW!=hh_LM) if hh_LM<.
tab aa //hour is always the same
drop aa
joinby date_day using "$path1\FED_dissent_3dayW.dta", unmatched(master) update
tab _merge
drop _merge

local wlbeg "-10 -15 -20 -25 -30"
local wlend "20 45 70 95 120"  // Windows from 30 mins up to 150 mins (2.5 hours)
forv i=1/5 {
foreach x in GW LM { // Tight window
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

bysort date_FOMC: g day_obs=1 if _n==1 & date_FOMC<.
g date_FOMC2=date_FOMC if W1_window_GW==1
bysort date_FOMC2: g day_obs_window=1 if _n==1 & date_FOMC2<.
sum date_FOMC day_obs day_obs_window // 9 dates missing (8 from year 1993, other date is  07oct2008, which is day 17812 in Stata)
sum year month day if day_obs==1 & day_obs_window==.
sum hour hh_GW hh_LM if date_day==17812
drop date_FOMC2

order date*, first
sort date_day
keep if any_window_GW==1 | any_window_LM==1   |  date_FOMC==123  |  date_FOMC==127  | date_FOMC==134
drop if  (date_FOMC==123  |  date_FOMC==127  | date_FOMC==134) & (hour>=12)
sort date_day hour minute
egen time = group(date_day hour minute)
foreach x in GW LM { 
forv i=1/5 {
g time1 = time if W`i'_window_`x'==1 
bysort date_day: egen time_beg`i'_`x'=min(time1) 
bysort date_day: egen time_end`i'_`x'=max(time1)
drop time1 
}
}
tsset time
local vars1 "SP" // 
foreach x of local vars1 {
forv k=1/5 {
foreach v in GW LM { 
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
forv k=1/5 {  // For 22jan2008 use ES futures quote of 1271.25 or 1325.27 as the closing value of the SP
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
sum R*_SP if date_FOMC==123   | date_FOMC==127  | date_FOMC==134
tab date_day date_FOMC if R4_SP<. & R1_SP==.
replace R4_SP=. if date_FOMC==74
replace R5_SP=. if date_FOMC==74
sum R*_SP  // For 17sep2001 use SP_close of 1092.58 from 10sep2001 or ignore

local vars1 "TY FV TU ES IAP ED" // 
foreach x of local vars1 {
foreach v in GW { // LM
forv k=1/5 {
g time0=time if time>=time_beg`k'_`v' & `x'_open<.
bysort date_FOMC: egen time00=min(time0)
g time1=time if time<=time_end`k'_`v' & `x'_close<.
bysort date_FOMC: egen time11=max(time1)

g var0 = `x'_open if time==time00
g var1 = `x'_close if time==time11
bysort date_day: egen var00=mean(var0)
bysort date_day: egen var11=mean(var1)
g R`k'_`x'_`v'=var11-var00
drop var0 var1 var00 var11 time0 time1 time00 time11
}
}
}
foreach x of local vars1 {
foreach v in GW { // LM
forv k=1/5 {
g time1=time if time<=time_end`k'_`v' & `x'_close<.
bysort date_FOMC: egen time11=max(time1)

g var1 = `x'_close if time==time11
bysort date_day: egen var11=mean(var1)
replace R`k'_`x'_`v'=var11-`x'_close_lag if date_FOMC==123  | date_FOMC==127  | date_FOMC==134
drop var1 var11 time1 time11
foreach num of numlist 123 127 134 {
sum `x'_close if date_FOMC==`num' & hour==9 & minute>34 & minute<=40
replace R`k'_`x'_`v'=r(mean)-`x'_close_lag if date_FOMC==`num' & R`k'_`x'_`v'==.
sum `x'_close if date_FOMC==`num' & hour==9 & minute>34 & minute<=59
replace R`k'_`x'_`v'=r(mean)-`x'_close_lag if date_FOMC==`num' & R`k'_`x'_`v'==.
}
}
}
}
sum R*_TY_GW if date_FOMC==123  | date_FOMC==127  | date_FOMC==134
tab date_day if date_FOMC==74
foreach x of local vars1 { // Ignore date after sept 11 2001 because markets were closed for one week
foreach v in GW { // LM
forv k=1/5 {
replace R`k'_`x'_`v'=. if date_FOMC==74
}
}
}
local vars1 "ESVol_log ESVol" // 
foreach x of local vars1 {
foreach v in GW { // LM
forv k=1/5 {
g time0=time if time>=time_beg`k'_`v' & `x'<.
bysort date_FOMC: egen time00=min(time0)
g time1=time if time<=time_end`k'_`v' & `x'<.
bysort date_FOMC: egen time11=max(time1)

g var0 = `x' if time==time00
g var1 = `x' if time==time11
bysort date_day: egen var00=mean(var0)
bysort date_day: egen var11=mean(var1)
g R`k'_`x'_`v'=var11-var00
g R`k'_S`x'_`v'=100*(var11/var00)
drop var0 var1 var00 var11 time0 time1 time00 time11
}
}
}
foreach x of local vars1 {
foreach v in GW { // LM
forv k=1/5 {
g time1=time if time<=time_end`k'_`v' & `x'<.
bysort date_FOMC: egen time11=max(time1)

g var1 = `x' if time==time11
bysort date_day: egen var11=mean(var1)
replace R`k'_`x'_`v'=var11-`x'_lag if date_FOMC==123  | date_FOMC==127  | date_FOMC==134
replace R`k'_S`x'_`v'=100*(var11/`x'_lag) if date_FOMC==123  | date_FOMC==127  | date_FOMC==134
drop var1 var11 time1 time11
foreach num of numlist 123 127 134 {
sum `x' if date_FOMC==`num' & hour==9 & minute>34 & minute<=40
replace R`k'_`x'_`v'=r(mean)-`x'_lag if date_FOMC==`num' & R`k'_`x'_`v'==.
replace R`k'_S`x'_`v'=100*(r(mean)/`x'_lag) if date_FOMC==`num' & R`k'_S`x'_`v'==.
sum `x' if date_FOMC==`num' & hour==9 & minute>34 & minute<=59
replace R`k'_`x'_`v'=r(mean)-`x'_lag if date_FOMC==`num' & R`k'_`x'_`v'==.
replace R`k'_S`x'_`v'=100*(r(mean)/`x'_lag) if date_FOMC==`num' & R`k'_S`x'_`v'==.
}
}
}
}
//  //  //  //
local Xvars "Kuttner_surprise FOMC_unscheduled ffr_original FOMC_pub"
collapse R* `Xvars' ESVol_log_lag ESVol_lag, by(date_day date_FOMC year month day dissent)
forv k=1/5 {  
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
quietly {  
forv k=1/5 {  
local varR="R`k'_SP" // R`k'_SP R`k'_SP_GW
g Sq_R`k'_SP=`varR'^2
g Abs_R`k'_SP=abs(`varR')
sum `varR' if FOMC_public_vote!=1, d  //  Demeaned versions	//		//		//
g SqDM_R`k'_SP=(`varR'-r(mean))^2 if FOMC_public_vote!=1
g AbsDM_R`k'_SP=abs(`varR'-r(p50)) if FOMC_public_vote!=1
sum `varR' if FOMC_public_vote==1 & dissent==0, d
replace SqDM_R`k'_SP=(`varR'-r(mean))^2 if FOMC_public_vote==1 & dissent==0
replace AbsDM_R`k'_SP=abs(`varR'-r(p50)) if FOMC_public_vote==1 & dissent==0
sum `varR' if FOMC_public_vote==1 & dissent==1, d
replace SqDM_R`k'_SP=(`varR'-r(mean))^2 if FOMC_public_vote==1 & dissent==1
replace AbsDM_R`k'_SP=abs(`varR'-r(p50)) if FOMC_public_vote==1 & dissent==1
// Demeaned versions 2
g SqDM2_R`k'_SP=SqDM_R`k'_SP if FOMC_public_vote!=1
g AbsDM2_R`k'_SP=AbsDM_R`k'_SP if FOMC_public_vote!=1 
forv p=1/3 {  
sum `varR' if period==`p' & dissent==0, d
replace SqDM2_R`k'_SP=(`varR'-r(mean))^2 if period==`p' & dissent==0
replace AbsDM2_R`k'_SP=abs(`varR'-r(p50)) if period==`p' & dissent==0
sum `varR' if period==`p' & dissent==1, d
replace SqDM2_R`k'_SP=(`varR'-r(mean))^2 if period==`p' & dissent==1
replace AbsDM2_R`k'_SP=abs(`varR'-r(p50)) if period==`p' & dissent==1
}
}
}
bysort FOMC_public_vote dissent: sum R*_SP_*
bysort period dissent: sum R*_SP_*
drop R*SP*GW R*SP*LM 
g FOMC_nonpublic=(FOMC_public_vote==0)
g unanimity_public=(dissent==0 & FOMC_public_vote==1)
g dissent_public=(dissent==1 & FOMC_public_vote==1)
g unanimity_nonpublic=(dissent==0 & FOMC_public_vote==0)
g dissent_nonpublic=(dissent==1 & FOMC_public_vote==0)
g SQ_Kuttner_surprise=Kuttner_surprise^2
g ABS_Kuttner_surprise=abs(Kuttner_surprise)
save "$path3\\Intraday_MoreData`MDi'.dta", replace

local vars11 "SP TY FV TU ES_GW IAP ED ESVol_log ESVol_GW"
log using "$path0T\Intraday_periods.log", replace 
// Note: Variable IAP does not have period 0 (that is, before 2002)
// Note: Variable ES starts in sep1997, IAP starts in august 2003
foreach var of local vars11 { 
display("`var'")
tab period if R1_`var'<.
sum date_day if R1_`var'<.
tab date_day if date_day==r(min)
tab date_day if date_day==r(max)
}
log close

local Xvars0 "Kuttner_surprise FOMC_unscheduled" // ffr_original
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
local vars11 "SP" 
local Rvars11 "Sq Abs SqDM AbsDM SqDM2 AbsDM2" // Squared, Absolute returns //  //  //  //  //		
foreach Rvar of local Rvars11 { 
foreach var of local vars11 { 
forv k=1/2 { //k=1/5 log using "${path0T`MDi'`Vx'}\\`Rvar'_SP`k'_periods.log", replace 
reg `Rvar'_R`k'_`var' dissent if period==0, `varR' //unanimity , nocons //test dissent=unanimity
outreg2 using "${path0T`MDi'`Vx'}\\`Rvar'_IDr`k'_`var'.xls", replace
reg `Rvar'_R`k'_`var' dissent if period>=1, `varR'
outreg2 using "${path0T`MDi'`Vx'}\\`Rvar'_IDr`k'_`var'.xls", append
reg `Rvar'_R`k'_`var' dissent if period==1, `varR'
outreg2 using "${path0T`MDi'`Vx'}\\`Rvar'_IDr`k'_`var'.xls", append
reg `Rvar'_R`k'_`var' dissent if period==2, `varR'
outreg2 using "${path0T`MDi'`Vx'}\\`Rvar'_IDr`k'_`var'.xls", append
reg `Rvar'_R`k'_`var' dissent if period==3, `varR'
outreg2 using "${path0T`MDi'`Vx'}\\`Rvar'_IDr`k'_`var'.xls", append
reg `Rvar'_R`k'_`var' dissent if period>=2, `varR'
outreg2 using "${path0T`MDi'`Vx'}\\`Rvar'_IDr`k'_`var'.xls", append
reg `Rvar'_R`k'_`var' dissent if period>=1 & date_FOMC!=74 & date_FOMC!=123 & date_FOMC!=127 & date_FOMC!=134, `varR'
outreg2 using "${path0T`MDi'`Vx'}\\`Rvar'_IDr`k'_`var'.xls", append  //log close
}  //}
}
}  //   //  //   //   //	//		//			// 
local Rvars2 "Abs SqDM AbsDM SqDM2 AbsDM2" // Squared, Absolute returns //  //  //  //  //	
foreach var of local vars11 { 
forv k=1/2 { //k=1/5 log using "${path0T`MDi'`Vx'}\\`Rvar'_SP`k'_periods.log", replace 
reg Sq_R`k'_`var' dissent if period>=1, `varR' //unanimity , nocons //test dissent=unanimity
outreg2 using "${path0T`MDi'`Vx'}\\Allvars_Risk`k'_Pub.xls", replace
foreach Rvar of local Rvars2 { 
reg `Rvar'_R`k'_`var' dissent if period>=1, `varR'
outreg2 using "${path0T`MDi'`Vx'}\\Allvars_Risk`k'_Pub.xls", append
}  	
reg Sq_R`k'_`var' dissent if period>=1 & date_FOMC!=74 & date_FOMC!=123 & date_FOMC!=127 & date_FOMC!=134, `varR' //unanimity , nocons //test dissent=unanimity
outreg2 using "${path0T`MDi'`Vx'}\\Allvars_Risk`k'_Pub2.xls", replace
foreach Rvar of local Rvars2 { 
reg `Rvar'_R`k'_`var' dissent if period>=1 & date_FOMC!=74 & date_FOMC!=123 & date_FOMC!=127 & date_FOMC!=134, `varR'
outreg2 using "${path0T`MDi'`Vx'}\\Allvars_Risk`k'_Pub2.xls", append
} 
//
forv p=0/3 {
reg Sq_R`k'_`var' dissent if period==`p', `varR' //unanimity , nocons //test dissent=unanimity
outreg2 using "${path0T`MDi'`Vx'}\\Allvars_Risk`k'_P`p'.xls", replace	
foreach Rvar of local Rvars2 { 
reg `Rvar'_R`k'_`var' dissent if period==`p', `varR'
outreg2 using "${path0T`MDi'`Vx'}\\Allvars_Risk`k'_P`p'.xls", append
}  
}
}
}
//   //  //   //   //	//		//			// 

local vp0 "TU FV TY ED ES_GW" //"TY FV TU ES ED"
local vp1 "TU FV TY IAP ED ES_GW ESVol_log ESVol_GW SESVol_GW"  //   //   //	//		//			//
local vars11 "TY FV TU ES_GW ED" // IAP 
local vars11 "IAP ESVol_log ESVol_GW SESVol_GW" //    // 
local vars11 "SP TY FV TU ES_GW IAP ED ESVol_log ESVol_GW SESVol_GW" //forv k=1/2 {   }  // 
local Vxn=1+`Vxn'
}
//   //
}
//   // //   //
