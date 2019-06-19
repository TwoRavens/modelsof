
set more off 
// using nearest neighbors *****************************************************
clear 

use "$root/myanmarpanel_analysis.dta", clear 
keep if year == 2013 
collapse (mean) rscr_sftu, by(qrno) 
save "$jetro/jetro_survival_analysis_13", replace 

use "$root/myanmarpanel_analysis.dta", clear 
keep if year == 2014
collapse (mean) rscr_sftu, by(qrno) 
save "$jetro/jetro_survival_analysis_14", replace 

use "$root/myanmarpanel_analysis.dta", clear 
keep if year == 2015 
collapse (mean) rscr_sftu, by(qrno) 
save "$jetro/jetro_survival_analysis_15", replace 

// finding nearest surviving firm 
local replace replace 
foreach y in 13 14 15 {
cd "$jetro" 
use jetroide2005_working, clear 
rename nfor nfor05
rename log_nsewm log_nsewm05
rename mage mage05
sort qrno
cd "$jetro" 

keep if fdifull05k==0

capture drop _merge 
merge 1:1 qrno using "$jetro/jetro_survival_analysis_`y'"
drop if _merge==2 // observed only in the later years 

gen surv = (_merge==3 & rscr_sftu !=.) 
drop _merge 

gen ap_in1hr = (ap_time_hr<1) if ap_time_hr!=. 

// propensity score estimate 
local outreg outreg2 using survival_eahcy, se alpha( 0.01, 0.05, 0.1) tex label 
probit surv log_emp04k iz_k city_time_hr ap_in1hr dnonknitint04k 
predict p, pr
sum surv if e(sample)==1 
local m = r(mean)
`outreg' addstat(Mean, `m') `replace'
local replace 
sort p log_emp04k iz_k qrno // sometimes, p-s are the same - list all so that the order is unique 

// nearest neighbor 
gen match_lower = qrno[_n-1] if surv[_n-1] ==1 
gen p_lower = p[_n-1] if surv[_n-1] ==1 
gen match_higher = qrno[_n+1] if surv[_n+1] ==1 
gen p_higher = p[_n+1] if surv[_n+1] ==1 
forvalues i = 2/10 {
replace match_lower = qrno[_n-`i'] if match_lower==. & surv[_n-`i'] ==1 
replace p_lower = p[_n-`i'] if p_lower==. & surv[_n-`i'] ==1 
replace match_higher = qrno[_n+`i'] if match_higher==. & surv[_n+`i'] ==1 
replace p_higher = p[_n+`i'] if p_higher==. & surv[_n+`i'] ==1 
}
gen p_dist_lower = p - p_lower 
gen p_dist_higher = p_higher - p 
gen match_`y' = match_lower if surv==0 
replace match_`y' = match_higher if surv==0 & (p_dist_lower > p_dist_higher)

gen year = 20`y'
rename surv surv_`y'
cd "$jetro" 
save jetroide2005_p`y', replace 
}

use "$root/myanmarpanel_analysis.dta", clear 
merge m:1 qrno year using "$jetro/jetroide2005_p13"
drop _merge 

merge m:1 qrno year using "$jetro/jetroide2005_p14"
drop _merge 

merge m:1 qrno year using "$jetro/jetroide2005_p15"
drop _merge 

gen match = match_13 if year == 2013 
replace match = match_14 if year == 2014 
replace match = match_15 if year == 2015

gen surv = surv_13 if year == 2013 
replace surv = surv_14 if year == 2014 
replace surv = surv_15 if year == 2015

tab year surv, m // summarize the data (including missing) 

save "$jetro/attrition_data", replace 

*** B.3.7. Reweighting *****************************************
use "$jetro/attrition_data", replace 

gen ap_timeo_i = ap_timeo if ap_timeo!=. 
replace ap_timeo_i = ap_time_hr if ap_time_hr!=. & ap_timeo_i==. & surv!=. 
gen ap_in1hr_i = (ap_timeo_i<1) if ap_timeo_i!=. 

gen izo_i  = izo 
replace izo_i = iz_k if iz_k!=. & izo==. & surv!=.

gen city_timeo_i  = city_timeo 
replace city_timeo_i = city_time_hr if city_time_hr!=. & city_timeo==. & surv!=.

gen dnonknitbf05_i = dnonknitbf05
replace dnonknitbf05_i = dnonknitint04k if dnonknitbf05==. 

gen log_emp_i = log_emp 
replace log_emp_i = log_emp04k if log_emp_i ==. & surv!=. 

replace surv = 0 if obs_airport==0

// Table B.3.6 survival analysis (surv =. if only observed in 2013--2015, but p_surv is calculated for these firms too)
local outreg outreg2 using survival, se alpha( 0.01, 0.05, 0.1) tex label
probit surv log_emp_i izo_i if qrno!=. 
sum surv if e(sample)==1 
local m = r(mean)
`outreg' addstat(Mean, `m')  replace 

probit surv log_emp_i izo_i ap_in1hr_i city_timeo_i if qrno!=. 
sum surv if e(sample)==1 
local m = r(mean)
`outreg' addstat(Mean, `m') 

probit surv log_emp_i izo_i dnonknitbf05_i if qrno!=. 
sum surv if e(sample)==1 
local m = r(mean)
`outreg' addstat(Mean, `m') 

probit surv log_emp_i ap_in1hr_i dnonknitbf05_i izo_i city_timeo_i if qrno!=. 
predict p_surv, p  
sum surv if e(sample)==1 
local m = r(mean)
`outreg' addstat(Mean, `m')  
gen weight = 1/p_surv


// reweighting 
 
local outreg outreg2 using reweight, se alpha( 0.01, 0.05, 0.1) tex label
local treat ap_in1hr // airport 
ivregress 2sls rscr_sftu (export_sh = `treat') city_timeo_i izo_i i.district i.year [aw=weight] if obs_airport==1, cluster(firmid) 
`outreg' replace 

local treat dnonknitbf05_i // woven 
ivregress 2sls rscr_sftu (export_sh = `treat') oeducu ochinese firmage i.district i.year [aw=weight] if obs_enterbf05==1, cluster(firmid) 
`outreg'  

local treat ap_in1hr // airport 
ivregress 2sls lwage (export_sh = `treat') city_timeo_i izo_i i.district i.year [aw=weight] if obs_airport==1, cluster(firmid) 
`outreg'  

local treat dnonknitbf05_i // woven 
ivregress 2sls lwage (export_sh = `treat') oeducu ochinese firmage i.district i.year [aw=weight] if obs_enterbf05==1, cluster(firmid) 
`outreg'  

local treat ap_in1hr // airport 
ivregress 2sls longhw (export_sh = `treat') city_timeo_i izo_i i.district i.year [aw=weight] if obs_airport==1, cluster(firmid) 
`outreg'  

local treat dnonknitbf05_i // woven 
ivregress 2sls longhw (export_sh = `treat') oeducu ochinese firmage i.district i.year [aw=weight] if obs_enterbf05==1, cluster(firmid) 
`outreg'  


local treat ap_in1hr // airport 
ivregress 2sls rscr_manag_woitic (export_sh = `treat') city_timeo_i izo_i i.district i.year [aw=weight] if obs_airport==1, cluster(firmid) 
`outreg'  

local treat dnonknitbf05_i // woven 
ivregress 2sls rscr_manag_woitic (export_sh = `treat') oeducu ochinese firmage i.district i.year [aw=weight] if obs_enterbf05==1, cluster(firmid) 
`outreg'  



*** Table B.3.8 Lee bounds *****************************************
use "$jetro/attrition_data", replace 

gen ap_in1hr_i = (ap_timeo<1) if ap_timeo!=. 
replace ap_in1hr_i = (ap_time_hr<1) if ap_time_hr!=. & ap_in1hr_i==. & surv!=. 

gen izo_i  = izo 
replace izo_i = iz_k if iz_k!=. & izo==. & surv==0 

gen city_timeo_i  = city_timeo 
replace city_timeo_i = city_time_hr if city_time_hr!=. & city_timeo==. & surv!=.

sum city_timeo_i, detail
gen near_city = (city_timeo_i<1.3)  if city_timeo_i!=. 

gen dnonknitbf05_i = dnonknitbf05
replace dnonknitbf05_i = dnonknitint04k if dnonknitbf05==. 

gen firmage_i = firmage - 8 if year == 2013 
replace firmage_i = firmage - 9 if year == 2014
replace firmage_i = firmage - 10 if year == 2015
replace firmage_i = firmage05k if firmage_i ==. & firmage05k!=. & surv==0 

gen dagedfirm = (firmage_i>=5) if firmage_i!=. 
sum firmage_i if firmage_i>0, detail 

replace district = 1 if qrno!=. & district ==. 

replace obs_airport = 1 if surv ==0 

gen all_ap =  (obs_airport==1 | surv==0) & izo_i!=. & city_timeo_i!=.
gen obs_ap  = (obs_airport==1 & rscr_sftu!=.) 
tab ap_in1hr_i obs_ap if all_ap ==1, row 

gen all_woven =  (obs_enterbf05==1 | surv==0) 
tab dnonknitbf05_i surv if all_woven ==1, row 

// reduced form - benchmark 
local outreg outreg2 using bound, se alpha( 0.01, 0.05, 0.1) tex label
reg rscr_sftu ap_in1hr_i if (obs_airport==1 | surv==0) & district == 1
`outreg' replace 
reg rscr_sftu dnonknitbf05_i if (obs_enterbf05==1 | surv==0) & district == 1
`outreg'

// airport (leebounds)
leebounds rscr_sftu ap_in1hr_i if (obs_airport==1 | surv==0) & izo_i!=. & city_timeo_i!=. & district == 1 , tight(izo_i) 
`outreg'

// woven (leebounds) 
leebounds rscr_sftu dnonknitbf05_i  if (obs_enterbf05==1 | surv==0)  & district == 1, tight(izo_i)   
`outreg'

