set more off  //Note: As in GW (2016) and GSS (2005) we use standard S&P500 and yield changes (we do not apply risk-free TYield as LM(2015))
capture log close

forv MDi=1/2 {  // 1/3 local MDi = 1 // minute of data 1min=1, 5min=2, both=3  1/3
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
sum *_tickcount 
sum SP*
drop if SP_close==. // Trading Hours for bonds and stocks are different
drop *_volume *_tickcount
sum diss* date_FOMC
replace hour=hour+1 // Chicago time is one hour behind DC/New York announcements
tab hour
bysort hour: tab minute // It seems market is active from 9:30 to 16:00 (NY/DC) or 8:30 to 15:00 (Chicago)
drop if hour==16 & minute>=1
joinby date_day using "$path1\FED3_dissent_date_MinutesPre02.dta", unmatched(master) update //joinby date_day using "$path1\FED2_dissent_date_MinutesPre02.dta", unmatched(master) update
tab _merge
sum year if _merge==3
keep if _merge==3
drop _merge

capture drop date_FOMC hh_GW mm_GW
g date_FOMC=date_M
g hh_GW=M_hour 
g mm_GW=M_minute
local wlbeg "-10 -15 -20 -25 -30"
local wlend "20 45 70 95 120"  // Windows from 30 mins up to 150 mins (2.5 hours)
forv i=1/2 {
foreach x in GW { // Tight window
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
sum W`i'_window_GW 
}
egen any_window_GW = rowmax(W*_window_GW)
joinby date_day using "$path3\\Tick_Minutes_lagfw.dta", unmatched(master) update
tab _merge
drop _merge
bysort date_FOMC: g day_obs=1 if _n==1 & date_FOMC<.
g date_FOMC2=date_FOMC if W1_window_GW==1
bysort date_FOMC2: g day_obs_window=1 if _n==1 & date_FOMC2<.
sum date_FOMC day_obs day_obs_window // 9 dates missing (8 from year 1993, other date is  07oct2008, which is day 17812 in Stata)
sum year month day if day_obs==1 & day_obs_window==.
drop date_FOMC2

order date*, first
sort date_day //keep if any_window_GW==1 
keep if date_M<.
sort date_day hour minute
egen time = group(date_day hour minute)
foreach x in GW {
forv i=1/2 {
g time1 = time if W`i'_window_`x'==1 
bysort date_day: egen time_beg`i'_`x'=min(time1) 
bysort date_day: egen time_end`i'_`x'=max(time1)
drop time1 
}
}
tsset time
local vars1 "SP" // 
foreach x of local vars1 {
forv k=1/2 {
foreach v in GW {
g var0 = ln(`x'_close) if time==time_beg`k'_`v'
g var1 = ln(`x'_close) if time==time_end`k'_`v'
bysort date_day: egen var00=mean(var0)
bysort date_day: egen var11=mean(var1)
g R`k'_`x'_`v'=var11-var00
drop var0 var1 var00 var11
//   //  //
g var0 = ln(`x'_close) 
g time0=time if `x'_close<. & time<=time_beg`k'_`v'
bysort date_day: egen time00=max(time0)
bysort date_day: egen TV00=max(R`k'_`x'_`v')
replace R`k'_`x'_`v' = ln(SP_open_fw) -var0 if TV00==.
drop var0 time0 time00 TV00
g var0 = ln(`x'_open)    //   //
g time0=time if `x'_open<. & time>=time_beg`k'_`v'
bysort date_day: egen time00=min(time0)
bysort date_day: egen TV00=max(R`k'_`x'_`v')
replace R`k'_`x'_`v' = var0-ln(SP_close_lag) if TV00==.
drop var0 time0 time00 TV00
//   //   //
}
}
}
sum R*_SP*  //local vars1 "ESVol_log ESVol tickC_SP tickC_ES" // capture drop R*_Ssprea*
//  //  //  //  local Xvars "Kuttner_surprise FOMC_unscheduled ffr_original FOMC_pub"
collapse R* `Xvars', by(date_day date_FOMC year month day nr_pers Dissent_minute Dissent_la_minute Dissent_both_minute FOMC_1dayBMin FOMC_1or2dayBMin)
forv k=1/2 {  
replace R`k'_SP_GW=100*R`k'_SP_GW
}
g dissent_minute =(Dissent_minute==1)
g unanimity_minute =(Dissent_minute==0)
local Vxn=1
foreach Vx in "" "R" { //"B" 
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
local k=1
reg R`k'_`var' dissent_minute unanimity_minute, nocons `varR'
outreg2 using "${path0T`MDi'`Vx'}\\SPMinutes`k'_`var'.xls", replace
qreg R`k'_`var' dissent_minute unanimity_minute, `varR' 
outreg2 using "${path0T`MDi'`Vx'}\\SPMinutes`k'_`var'.xls", append
local k=2
reg R`k'_`var' dissent_minute unanimity_minute, nocons vce(robust)
outreg2 using "${path0T`MDi'`Vx'}\\SPMinutes`k'_`var'.xls", replace
qreg R`k'_`var' dissent_minute unanimity_minute, `varR' 
outreg2 using "${path0T`MDi'`Vx'}\\SPMinutes`k'_`var'.xls", append
/*forv k=1/2 {
reg R`k'_`var' dissent_minute unanimity_minute, nocons `varR'
outreg2 using "${path0T`MDi'`Vx'}\\SPMinutes`k'_`var'.xls", replace
qreg R`k'_`var' dissent_minute unanimity_minute, `varR' 
outreg2 using "${path0T`MDi'`Vx'}\\SPMinutes`k'_`var'.xls", append
}  //}  */
}
local Vxn=1+`Vxn'
}
//   //
}
//   // //   //
