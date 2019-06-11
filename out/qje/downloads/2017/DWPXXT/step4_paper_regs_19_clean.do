clear
clear mata
set more off
set matsize 11000
set mem 700m
pause on

global path = ""
cd "$path"
global data_output = ""
global app_log = ""
global main_log = ""
global resp_log = ""
global scratch_log = ""
global app_tables = ""
global main_tables = ""
global resp_tables = ""
global scratch_tables = ""
global app_graphs = ""
global main_graphs = ""
global resp_graphs = ""
global scratch_graphs = ""
global working_econ = ""
global working = ""


****************************************************************************

******************************************************************************
***THIS FILE PRODUCES ALL RESULTS IN THE PAPER AND APPENDIX C TABLES AND FIGURES
*******************************************************************************

******************************************************************************
***Section 2: CONTEXT AND DATA
*Table 1: sum stats
*Figure 1: duration histogram
*Various summary statistics reported in the paper (mainly section 2)
*******************************************************************************

capture log close
log using "$main_log/sumstats.log", replace


******************************************************************************
*TABLE 1 (SUMMARY STATS)
*******************************************************************************

use "$data_output/reg_workerlevel_wID_7", clear

*Location coverage
codebook location
codebook location if testing_med==0
codebook location if testing_med==1

*Hired Worker Coverage
count
count if testing_med==0
count if testing_med==1

*Post testing coverage

*NUMBER OF APPLICANTS (in locations in our final data) 
use "$data_output/reg_workerlevel_wID_7" if testing_med==1, clear
keep location recruiter_id
duplicates drop
tempfile locs
save `locs', replace

**merge dataset with locs that meet all our restrictions
use "$data_output/pool_indiv_3", clear
merge m:1 location recruiter_id using `locs'
keep if _merge==3
*NUMBER OF APPLICANTS
codebook counter_id

use "$data_output/reg_workerlevel_wID_7", clear
keep if testing_med==1
*NUMBER OF MANAGERS
codebook recruiter_id

*NUMBER OF POOLS
codebook poolid
bysort poolid: gen counter = _n

*APPLICANTS / POOL
**use numapp_color in table
sum numapp numapp_color if counter==1


*PART 2: WORKER CHARACTERISTICS
use "$data_output/reg_workerlevel_wID_7", clear

**duration means
gen dur_cen = dur if censored==1
gen dur_uncen = dur if censored==0

sum dur_uncen dur_cen censored outputperhour60 

sum dur_uncen dur_cen censored outputperhour60 if testing_med==0
sum dur_uncen dur_cen censored outputperhour60 if testing_med==1

sum dur_uncen dur_cen censored outputperhour60 if testing_med==1 & green==1
sum dur_uncen dur_cen censored outputperhour60 if testing_med==1 & yellow==1
sum dur_uncen dur_cen censored outputperhour60 if testing_med==1 & red==1

* Milestone means on top of Appendix Table C1
sum month3_restrict month6_restrict month12_restrict 

sum month3_restrict month6_restrict month12_restrict if testing_med==0
sum month3_restrict month6_restrict month12_restrict if testing_med==1
sum month3_restrict month6_restrict month12_restrict if testing_med==1 & green==1
sum month3_restrict month6_restrict month12_restrict if testing_med==1 & yellow==1
sum month3_restrict month6_restrict month12_restrict if testing_med==1 & red==1


*PART 3: APPLICANT POOL CHARACTERISTICS

use "$data_output/reg_workerlevel_wID_7", clear
keep if testing_med==1 & inexceptionregs1==1

collapse numapp numapp_color numapp_g numapp_y numapp_r numhire numhire_g numhire_y numhire_r cut2EX_viol_3, by(poolid)
**applicants per pool

**REPORTING pool characteristics for applicants with color scores
sum numapp numapp_color
gen rate = numhire/numapp
gen rate2 = (numhire_g + numhire_y + numhire_r)/(numapp_g + numapp_y + numapp_r)

***hiring rate
sum rate2

***Average exception rate across pools
* Mention in Section 5 of main text.
sum cut2EX_viol_3

**share of applicants that are each color
gen share_g = numapp_g/numapp_color
gen share_y = numapp_y/numapp_color
gen share_r = numapp_r/numapp_color
sum share_g share_y share_r

**hire rate by color
gen hire_g = numhire_g/numapp_g
gen hire_y = numhire_y/numapp_y
gen hire_r = numhire_r/numapp_r
sum hire_g hire_y hire_r

******************************************************************************
*Other details reported throughout paper
****************************************************************************
**share of obs that are censored
use "$data_output/reg_workerlevel_wID_7", clear
**median completed duration
sum dur if censored==0, d
**completed cells that last a month, using censored in text
sum month1 if censored==0
sum month1_restrict
**availability of outputperhour60
gen Moutput = (outputperhour60==.)
tab Moutput
tab clientID if outputperhour60!=.

**average time period
sum hire_month if testing_med==0
sum hire_month if testing_med==1
**share of obs/locations with missing economic data
tab M_economicdata
preserve
collapse M_economicdata, by(location)
tab M_economicdata
restore

**distribution at pool and manager levels
sum cut2EX_viol_3 if testing_med==1, d
sum cut2EX_viol_3_R if testing_med==1, d
**number of managers per location, first unrestricted then restricted
use "$data_output/reg_workerlevel_wID_5_unrestrict" if testing_med==1, clear
bysort location: egen Nmgrs_full = nvals(recruiter_id)
collapse Nmgrs_full (count) Nhires=ldur, by(location)
sum Nmgrs_full, d
sum Nmgrs_full [aw=Nhires], d
**with restrictions
use "$data_output/reg_workerlevel_wID_7" if testing_med==1, clear
bysort location: egen Nmgrs_full = nvals(recruiter_id)
collapse Nmgrs_full (count) Nhires=ldur, by(location)
sum Nmgrs_full, d
sum Nmgrs_full [aw=Nhires], d


******************************************************************************
*FIGURE 1: HISTOGRAM OF COMPLETED SPELL DURATION
*******************************************************************************
use "$data_output/reg_workerlevel_wID_7", clear
histogram dur, saving($scratch_graphs/test, replace)

gen dur_uncen = dur if censored==0

sum dur_uncen, d
local samplemean = r(mean)
local samplemed = r(p50)
display "`samplemean' `samplemed'"
sum dur_uncen if dur_uncen<1000
gen exclude = dur_uncen>1000 & dur_uncen!=.
sum exclude if dur_uncen!=.

di "got here"

histogram dur_uncen if dur_uncen <1000, caption("Solid line = Mean, Dashed line = Median") xline(`samplemean', lcolor(black)) xline(`samplemed', lcolor(black) lpattern(dash))  graphregion(color(white)) bgcolor(white) ytitle(Density) xtitle("Days of Tenure") scheme(s2mono)
graph export $main_graphs/fig_dur_hist.pdf, as(pdf) replace
graph export $main_graphs/fig_dur_hist.eps, as(eps) replace

sum month1_restrict
gen Moutputs = (outputperhour60==.)
sum Moutputs

***what fraction of locations are international or unusual (i.e., non-standard)
bysort location: gen counter = _n
tab fill_local if counter==1
tab fill_unusual if counter==1
gen fill_foreign = (fill_local==0 & fill_unusual==0)
tab fill_foreign if counter==1



******************************************************************************
***Section 3: INTRODUCTION OF TESTING
*Table 2: Introduction of testing -- duration
*Figure 2: Introduction of testing event studies
*Appendix Table C1: Introduction of testing -- alternative LHS
*******************************************************************************
capture log close
log using "$main_log/impact_of_testing.log", replace

******************************************************************************
*TABLE 2: INTRODUCTION OF TESTING -- LOG DURATION 
*******************************************************************************

use "$data_output/reg_workerlevel_wID_7", clear

cnreg ldur testing_med locdum_* monthdum_* posdum_*, cen(censored) cluster(location)
outreg2 testing_med using "$main_tables/tab_introtesting_main", replace stats(coef, se) nocons excel

cnreg ldur testing_med locdum_* monthdum_* posdum_* clientyeardum_*, cen(censored) cluster(location)
outreg2 testing_med using "$main_tables/tab_introtesting_main", append stats(coef, se) nocons excel

cnreg ldur testing_med locdum_* monthdum_* posdum_* clientyeardum_* fill_*, cen(censored) cluster(location)
outreg2 testing_med using "$main_tables/tab_introtesting_main", append stats(coef, se) nocons excel

cnreg ldur testing_med locdum_* monthdum_* posdum_* clientyeardum_* fill_* ymlocdum_*, cen(censored) cluster(location)
outreg2 testing_med using "$main_tables/tab_introtesting_main", append stats(coef, se) nocons excel

******************************************************************************
*APPENDIX TABLE C1: INTRODUCTION OF TESTING -- MILESTONES, Panel A
*******************************************************************************

use "$data_output/reg_workerlevel_wID_7", clear

capture erase "$main_tables/tab_introtesting_milestones.txt"
capture erase "$main_tables/tab_introtesting_milestones.xml"

foreach var of varlist month3_restrict month6_restrict month12_restrict {

*BASE CONTROLS
reg `var' testing_med locdum_* monthdum_* posdum_*, cluster(location)
outreg2 testing_med using "$main_tables/tab_introtesting_milestones", append stats(coef, se) nocons excel

*FULL CONTROLS
reg `var' testing_med locdum_* monthdum_* posdum_* clientyeardum_* fill_* ymlocdum_* , cluster(location)
outreg2 testing_med using "$main_tables/tab_introtesting_milestones", append stats(coef, se) nocons excel
}

******************************************************************************
*FIGURE 2: INTRODUCTION OF TESTING EVENT STUDIES  
*******************************************************************************

local controls "locdum_* monthdum_* posdum_*"
use "$data_output/reg_workerlevel_wID_7", clear

sum month3_restrict month6_restrict month12_restrict
gen mytesting = start_testing_month_med
assert hire_month!=. 
gen time_since = hire_month - mytesting 
sum time_since
gen time_since_qtr = floor(time_since/3)
sum time_since_qtr
foreach num of numlist 12(-1)1 {
	gen event_intm`num' = (time_since_qtr==-`num')
}
foreach num of numlist 1/12 {
	gen event_intp`num' = (time_since_qtr==`num')
}
gen event_in0 = (time_since_qtr==0)
gen event_intm13plus = (time_since_qtr<=-13)
gen event_intp13plus = (time_since_qtr>=13)

gen test = event_in0 + event_intm13plus + event_intp13plus
foreach num of numlist 1/12 {
	replace test = test + event_intm`num' + event_intp`num'
}
assert test==1
drop test

cnreg ldur event_intm13plus event_intm12-event_intm2 event_in0 event_intp1-event_intp12 event_intp13plus locdum_* monthdum_* posdum_* clientyeardum_* fill_*, cen(censored) cluster(location)
*get matrix coefficients and standard errors
matrix Tcoeffs=e(b)
matrix Tses = e(V)
mata: coeffs = st_matrix("Tcoeffs")'
mata: ses = diagonal(st_matrix("Tses"))
*only plot 12 lags and leads
mata: coeffs = coeffs[2..25]
mata: ses = ses[2..25]:^.5

foreach month in 3 6 12 {
	reg month`month'_restrict event_intm13plus event_intm12-event_intm2 event_in0 event_intp1-event_intp12 event_intp13plus locdum_* monthdum_* posdum_*  clientyeardum_* fill_*, cluster(location)
	*get matrix coefficients and standard errors
	matrix Tcoeffs=e(b)
	matrix Tses = e(V)
	mata: coeffs`month' = st_matrix("Tcoeffs")'
	mata: ses`month' = diagonal(st_matrix("Tses"))
	*only plot 12 lags and leads
	mata: coeffs`month' = coeffs`month'[2..25]
	mata: ses`month' = ses`month'[2..25]:^.5
}
	
clear
getmata coeffs ses coeffs3 ses3 coeffs6 ses6 coeffs12 ses12
gen ci_plus = coeffs + 1.96*ses
gen ci_minus = coeffs - 1.96*ses
foreach month in 3 6 12 {
	gen ci_plus`month' = coeffs`month' + 1.96*ses`month'
	gen ci_minus`month' = coeffs`month' - 1.96*ses`month'
}

gen counter = _n 
gen lag = -13 + counter   if counter<12
replace lag = -12 + counter if counter>=12
local helper = _N +1 
set obs `helper'
replace coeffs=0 in `helper'
replace ci_plus=0 in `helper'
replace ci_minus=0 in `helper'
replace lag = -1 in `helper'
foreach month in 3 6 12 {
	replace coeffs`month'=0 in `helper'
	replace ci_plus`month'=0 in `helper'
	replace ci_minus`month'=0 in `helper'
}
sort lag
list

twoway (line coeffs lag, lcolor(black)) (line ci_plus lag, lcolor(black) lpattern(dash) lwidth(vvthin)) (line ci_minus lag, lcolor(black) lpattern(dash) lwidth(vvthin)) , xtitle("") ytitle("") title("Log(Duration)")  legend(off) xline(-1, lcolor(black)) legend(off) yline(0, lcolor(black) lpattern(dash) lwidth(vvthin)) saving("$scratch_graphs/g1", replace)  graphregion(color(white)) bgcolor(white) scheme(s2mono)

foreach month in 3 6 12 {
	twoway (line coeffs`month' lag, lcolor(black)) (line ci_plus`month' lag, lcolor(black) lpattern(dash) lwidth(vvthin)) (line ci_minus`month' lag, lcolor(black) lpattern(dash) lwidth(vvthin)) , xtitle("") ytitle("") title("Survived `month' Months")  legend(off) xline(-1, lcolor(black)) legend(off) yline(0, lcolor(black) lpattern(dash) lwidth(vvthin)) saving("$scratch_graphs/g`month'", replace)  graphregion(color(white)) bgcolor(white) scheme(s2mono) 
}

graph combine "$scratch_graphs/g1" "$scratch_graphs/g3" "$scratch_graphs/g6" "$scratch_graphs/g12", l1title(Coefficient) b1title(Quarters from Introduction of Testing)  graphregion(color(white))  scheme(s2mono)
graph export $main_graphs/fig_event_ldur_notimetrend.pdf, as(pdf) replace
graph export $main_graphs/fig_event_ldur_notimetrend.eps, as(eps) replace


******************************************************************************
***Section 5: EXCEPTION RATES AND OUTCOMES
*Figure 3: Histogram of exception rates

*Figure 4: Post testing correlaton
*Table 3: Post testing correlaton
*Appendix Table C1: Post testing correlaton and milestones

*Figure 5: Intro testing and exception rates
*Table 4: Intro testing and exception rates
*Appendix Table C1: Intro testing and exception rates, milestones

*******************************************************************************

capture log close
log using "$main_log/exceptions.log", replace

******************************************************************************
**FIGURE 3: HISTOGRAMS OF EXCEPTION RATES  -- weighted by hires where applicable
*******************************************************************************

***Pool level
use "$data_output/reg_workerlevel_wID_7", clear
keep if testing_med==1

collapse cut2EX_viol_3 numhire recruiter_id location hire_month, by(poolid)
sum cut2EX_viol_3, d
local samplemean = r(mean)
local samplemed = r(p50)

histogram cut2EX_viol_3, title("Pool Level, Unweighted")  xline(`samplemean', lcolor(black)) xline(`samplemed', lcolor(black) lpattern(dash)) saving("$scratch_graphs/g1", replace) graphregion(color(white)) bgcolor(white) ytitle(Density) xtitle("") ytitle("") scheme(s2mono)

sum cut2EX_viol_3 [fw=numhire], d
local samplemean = r(mean)
local samplemed = r(p50)

histogram cut2EX_viol_3 [fw=numhire], title("Pool Level, Weighted by # Hires")  xline(`samplemean', lcolor(black)) xline(`samplemed', lcolor(black) lpattern(dash)) saving("$scratch_graphs/g2", replace) graphregion(color(white)) bgcolor(white) ytitle(Density) xtitle("") ytitle("") scheme(s2mono)

***Manager Level
use "$data_output/reg_workerlevel_wID_7", clear
keep if testing_med==1
collapse cut2EX_viol_3_R (count) numhire=ldur, by(recruiter_id)

sum cut2EX_viol_3_R, d
local samplemean = r(mean)
local samplemed = r(p50)

histogram cut2EX_viol_3_R, title("Manager Level, Unweighted")  xline(`samplemean', lcolor(black)) xline(`samplemed', lcolor(black) lpattern(dash)) saving("$scratch_graphs/g3", replace) graphregion(color(white)) bgcolor(white) ytitle(Density) xtitle("") ytitle("") scheme(s2mono)

**Weighted
sum cut2EX_viol_3 [fw=numhire], d
local samplemean = r(mean)
local samplemed = r(p50)
histogram cut2EX_viol_3 [fw=numhire], title("Manager Level, Weighted by # Hires")  xline(`samplemean', lcolor(black)) xline(`samplemed', lcolor(black) lpattern(dash)) saving("$scratch_graphs/g4", replace) graphregion(color(white)) bgcolor(white) ytitle(Density) xtitle("") ytitle("") scheme(s2mono)

***Location Level
use "$data_output/reg_workerlevel_wID_7", clear
keep if testing_med==1
collapse cut2EX_viol_3_L (count) numhire=ldur, by(recruiter_id)

sum cut2EX_viol_3_L, d
local samplemean = r(mean)
local samplemed = r(p50)

histogram cut2EX_viol_3_L, title("Location Level, Unweighted")  xline(`samplemean', lcolor(black)) xline(`samplemed', lcolor(black) lpattern(dash)) saving("$scratch_graphs/g5", replace) graphregion(color(white)) bgcolor(white) ytitle(Density) xtitle("") ytitle("") scheme(s2mono)

**Weighted
sum cut2EX_viol_3 [fw=numhire], d
local samplemean = r(mean)
local samplemed = r(p50)
histogram cut2EX_viol_3 [fw=numhire], title("Location Level, Weighted by # Hires")  xline(`samplemean', lcolor(black)) xline(`samplemed', lcolor(black) lpattern(dash)) saving("$scratch_graphs/g6", replace) graphregion(color(white)) bgcolor(white) ytitle(Density) xtitle("") ytitle("") scheme(s2mono)


graph combine "$scratch_graphs/g1" "$scratch_graphs/g2" "$scratch_graphs/g3" "$scratch_graphs/g4" "$scratch_graphs/g5" "$scratch_graphs/g6", rows(3) caption("Solid line = mean, dashed line = median") graphregion(color(white)) scheme(s2mono)
graph export $main_graphs/fig_exception_hist.pdf, as(pdf) replace  
graph export $main_graphs/fig_exception_hist.eps, as(eps) replace  



**variation in managers within location
use "$data_output/reg_workerlevel_wID_7", clear
keep if testing_med==1
capture drop Nmgrs
capture drop counter
bysort location: egen Nmgrs = nvals(recruiter_id)
bysort location: gen counter = _n
display "unweighted"
sum Nmgrs if counter==1
display "worker weighted"
sum Nmgrs

**pools per manager
capture drop Npools
capture drop counter
bysort recruiter_id: egen Npools = nvals(poolid)
bysort recruiter_id: gen counter = _n
display "unweighted"
sum Npools if counter==1
display "worker weighted"
sum Npools

**pools with exception rates about 50%
keep if testing_med==1
sum cut2EX_viol_3_R, d
gen high = cut2EX_viol_3_R>.5
tab high

**random benchmark <1
gen less = (cut2EX_viol_ran_R<1)
tab less

******************************************************************************
**FIGURE 4: POST TESTING CORRELATIONS, DURATION AND MANAGER LEVEL EXCEPTION RATE (CENSORED NORMAL)
******************************************************************************

use "$data_output/reg_workerlevel_wID_7" if testing_med==1, clear

**means and sds for milestones
sum month3_restrict month6_restrict month12_restrict

***make hires-weighted ventiles
xtile Vex = cut2EX_viol_3_R, nquantiles(20)

qui tab Vex, gen(Dex)
cnreg ldur Dex1-Dex20 locdum_* monthdum_* posdum_*, censor(censored) cluster(location) nocons
gen coeff = .
foreach V of numlist 1/20 {
	replace coeff=_b[Dex`V'] if Vex==`V'
}

save $working/temp, replace

collapse coeff cut2EX_viol_3_R, by(Vex)
twoway (scatter coeff cut2EX_viol_3_R, mcolor(black)) (lfit coeff cut2EX_viol_3_R, lcolor(black) lpattern(dash)), xtitle("") ytitle("") title("Log(Duration)") legend(off) saving("$scratch_graphs/g1", replace)  graphregion(color(white)) bgcolor(white)  scheme(s2mono)

use $working/temp, clear
foreach month in 3 6 12 {
	binscatter month`month'_restrict cut2EX_viol_3_R, lcolor(black) mcolor(black) saving("$scratch_graphs/g`month'", replace) title("Survived `month' Months") xtitle("") ytitle("")  graphregion(color(white)) bgcolor(white)  controls(locdum_* monthdum_* posdum_*)  scheme(s2mono)
}

graph combine "$scratch_graphs/g1" "$scratch_graphs/g3" "$scratch_graphs/g6" "$scratch_graphs/g12", l1title(Duration Measure) b1title(Average Exception Rate)  graphregion(color(white))  scheme(s2mono)
graph export $main_graphs/fig_post_ldur_controls.pdf, as(pdf) replace
graph export $main_graphs/fig_post_ldur_controls.eps, as(eps) replace


******************************************************************************
**TABLE 3: POST TESTING CORRELATIONS, DURATION AND EXCEPTION RATE (CENSORED NORMAL)
******************************************************************************

use "$data_output/reg_workerlevel_wID_7" if testing_med==1, clear

cnreg ldur STDcut2EX_viol_3_R_med locdum_* monthdum_* posdum_*, censor(censored) cluster(location)
outreg2 STDcut2EX_viol_3_R_med using "$main_tables/tab_post_exception", replace stats(coef, se) nocons excel 
cnreg ldur STDcut2EX_viol_3_R_med locdum_* monthdum_* posdum_* clientyeardum_*, censor(censored) cluster(location)
outreg2 STDcut2EX_viol_3_R_med using "$main_tables/tab_post_exception", append stats(coef, se) nocons excel 
cnreg ldur STDcut2EX_viol_3_R_med locdum_* monthdum_* posdum_* clientyeardum_* fill_*, censor(censored) cluster(location)
outreg2 STDcut2EX_viol_3_R_med using "$main_tables/tab_post_exception", append stats(coef, se) nocons excel 
cnreg ldur STDcut2EX_viol_3_R_med locdum_* monthdum_* posdum_* clientyeardum_* fill_* ymlocdum_*, censor(censored) cluster(location)
outreg2 STDcut2EX_viol_3_R_med using "$main_tables/tab_post_exception", append stats(coef, se) nocons excel 
cnreg ldur STDcut2EX_viol_3_R_med locdum_* monthdum_* posdum_* clientyeardum_* fill_* ymlocdum_* APC*dum_*, censor(censored) cluster(location)
outreg2 STDcut2EX_viol_3_R_med using "$main_tables/tab_post_exception", append stats(coef, se) nocons excel 

******************************************************************************
**APPENDIX TABLE C1: POST TESTING CORRELATIONS, MILESTONES AND EXCEPTION RATE
* Panel B 
******************************************************************************

use "$data_output/reg_workerlevel_wID_7" if testing_med==1, clear

reg month3_restrict STDcut2EX_viol_3_R_med locdum_* monthdum_* posdum_*, cluster(location)
outreg2 STDcut2EX_viol_3_R_med using "$main_tables/tab_post_exception_month", replace stats(coef, se) nocons excel 

reg month3_restrict STDcut2EX_viol_3_R_med locdum_* monthdum_* posdum_* clientyeardum_* fill_* ymlocdum_* APC*dum_*, cluster(location)
outreg2 STDcut2EX_viol_3_R_med using "$main_tables/tab_post_exception_month", append stats(coef, se) nocons excel 
	
foreach month in 6 12 {
reg month`month'_restrict STDcut2EX_viol_3_R_med locdum_* monthdum_* posdum_*, cluster(location)
outreg2 STDcut2EX_viol_3_R_med using "$main_tables/tab_post_exception_month", append stats(coef, se) nocons excel 

reg month`month'_restrict STDcut2EX_viol_3_R_med locdum_* monthdum_* posdum_* clientyeardum_* fill_* ymlocdum_* APC*dum_*, cluster(location)
outreg2 STDcut2EX_viol_3_R_med using "$main_tables/tab_post_exception_month", append stats(coef, se) nocons excel 
}


******************************************************************************
*FIGURE 5: DIFFERENTIAL IMPACT OF TESTING BY EXCEPTION RATE 
*******************************************************************************

***create snapshot by location -- use the # currently working in July 2013, or earlier year if necessary
use "$data_output/reg_workerlevel_wID_7", clear
sum hire_month if hire_year_only==2013 & hire_month_only==7
local date = r(mean)
sum hire_month, d
local start = r(min)
local end = r(max)
foreach month of numlist `start'/`end' {
	gen working`month' = (hire_month<=`month' & term_month>=`month')
}
collapse (sum) working*, by(location)
**start with 2013Q3
gen location_size = working`date'
sum location_size, d
count if location_size==0
local helper = `date' - 12
replace location_size = working`helper' if location_size==0
sum location_size, d
assert location_size!=0 & location_size!=.
sum location_size, d
keep location location_size
save "$data_output/location_size", replace

***location size defined above, but define location size in pre-period
***SIZE IN PRE-TESTING PERIOD
use "$data_output/reg_workerlevel_wID_7", clear
keep if testing_med==0

sum hire_month if hire_year_only==2009 & hire_month_only==7
local date = r(mean)

sum hire_month, d
local start = r(min)
local end = r(max)
foreach month of numlist `start'/`end' {
	gen working`month' = (hire_month<=`month' & term_month>=`month')
}
collapse (sum) working*, by(location)
gen location_size = working`date'
sum location_size, d
count if location_size==0
local helper = `date' + 12
replace location_size = working`helper' if location_size==0
sum location_size, d
local helper = `date' + 24
replace location_size = working`helper' if location_size==0
sum location_size, d
local helper = `date' + 36
replace location_size = working`helper' if location_size==0
sum location_size, d
local helper = `date' + 48
replace location_size = working`helper' if location_size==0
sum location_size, d

assert location_size!=0
ren location_size location_size_pre
sum location_size_pre, d
keep location location_size_pre
save "$data_output/location_size_pre", replace


use "$data_output/reg_workerlevel_wID_7", clear
***location-level exceptions

*merge in location size 
merge m:1 location using "$data_output/location_size.dta"
assert _merge==3
drop _merge

merge m:1 location using "$data_output/location_size_pre.dta"
assert _merge!=2
drop _merge

gen count=1
bys location: egen test=total(count) if testing_med==0
bys location: egen locsize=max(test)

local nbins = 20

capture drop test
xtile Vex = cut2EX_viol_3_L if testing_med==1, nquantiles(`nbins')
bys location: egen test=sd(Vex) if testing_med==1
sum test
assert test==0 | test==.

qui tab Vex, gen(Dex)
foreach V of numlist 1/`nbins' {
	***interactions will all = 0 pre-testing
	replace Dex`V' = 0 if Dex`V'==.
	gen test`V' = testing_med*Dex`V'
}

gen coeff_base = .
gen coeff3_base=.
gen coeff6_base=.
gen coeff12_base=.

gen coeff_med = .
gen coeff3_med=.
gen coeff6_med=.
gen coeff12_med=.

gen coeff_full = .
gen coeff3_full=.
gen coeff6_full=.
gen coeff12_full=.

**base spec
cnreg ldur test1-test`nbins' locdum_* monthdum_* posdum_* , censor(censored) cluster(location)
foreach V of numlist 1/`nbins' {
	replace coeff_base = _b[test`V'] if Vex==`V'
	
}

**everything but ymlocdums
cnreg ldur test1-test`nbins' locdum_* monthdum_* posdum_* clientyeardum_* fill_*  , censor(censored) cluster(location)
foreach V of numlist 1/`nbins' {
	replace coeff_med = _b[test`V'] if Vex==`V'
	
}

**full spec
cnreg ldur test1-test`nbins' locdum_* monthdum_* posdum_*  clientyeardum_* fill_* ymlocdum_* , censor(censored) cluster(location)
foreach V of numlist 1/`nbins' {
	replace coeff_full = _b[test`V'] if Vex==`V'
}

foreach month in 3 6 12 {
	*base
	reg month`month'_restrict test1-test`nbins' locdum_* monthdum_* posdum_* , cluster(location)
		foreach V of numlist 1/`nbins' {
			replace coeff`month'_base = _b[test`V'] if Vex==`V'
	}
	
	*everything but
	reg month`month'_restrict test1-test`nbins' locdum_* monthdum_* posdum_*  clientyeardum_* fill_*, cluster(location)
		foreach V of numlist 1/`nbins' {
			replace coeff`month'_med = _b[test`V'] if Vex==`V'
	}

	*full
	reg month`month'_restrict test1-test`nbins' locdum_* monthdum_* posdum_*  clientyeardum_* fill_* ymlocdum_* , cluster(location)
		foreach V of numlist 1/`nbins' {
			replace coeff`month'_full = _b[test`V'] if Vex==`V'
	}
}


collapse coeff* cut2EX_viol_3_L, by(Vex)

foreach stem in base med full {
	twoway (scatter coeff_`stem' cut2EX_viol_3_L, mcolor(black)) (lfit coeff_`stem' cut2EX_viol_3_L , lcolor(black) lpattern(dash)), xtitle("") ytitle("") title("Log(Duration)") legend(off) saving("$scratch_graphs/g1", replace)  graphregion(color(white)) bgcolor(white) scheme(s2mono) 

	foreach month in 3 6 12 {
		twoway (scatter coeff`month'_`stem' cut2EX_viol_3_L  , mcolor(black))  (lfit coeff`month'_`stem' cut2EX_viol_3_L , lcolor(black) lpattern(dash)), saving("$scratch_graphs/g`month'", replace) title("Survived `month' Months") xtitle("") ytitle("")  graphregion(color(white)) bgcolor(white) legend(off) scheme(s2mono)
	}
	

	graph combine "$scratch_graphs/g1" "$scratch_graphs/g3" "$scratch_graphs/g6" "$scratch_graphs/g12", l1title(Impact of Testing) b1title(Average Exception Rate)  graphregion(color(white)) scheme(s2mono) 
	graph export $main_graphs/fig_introtesting_exceptions_`stem'x.pdf, as(pdf) replace
	graph export $main_graphs/fig_introtesting_exceptions_`stem'x.eps, as(eps) replace
}
	

******************************************************************************
*TABLE 4: DIFFERENTIAL IMPACT OF TESTING BY EXCEPTION RATE 
*******************************************************************************
use "$data_output/reg_workerlevel_wID_7", clear

cnreg ldur STDcut2EX_viol_3_L_med testing_med locdum_* monthdum_* posdum_*, censor(censored) cluster(location)
outreg2 STDcut2EX_viol_3_L_med testing_med using "$main_tables/tab_intro_exception", replace stats(coef, se) nocons excel 

cnreg ldur STDcut2EX_viol_3_L_med testing_med locdum_* monthdum_* posdum_* clientyeardum_*, censor(censored) cluster(location)
outreg2 STDcut2EX_viol_3_L_med testing_med using "$main_tables/tab_intro_exception", append stats(coef, se) nocons excel 

cnreg ldur STDcut2EX_viol_3_L_med testing_med locdum_* monthdum_* posdum_* clientyeardum_* fill_*, censor(censored) cluster(location)
outreg2 STDcut2EX_viol_3_L_med testing_med using "$main_tables/tab_intro_exception", append stats(coef, se) nocons excel 

cnreg ldur STDcut2EX_viol_3_L_med testing_med locdum_* monthdum_* posdum_* clientyeardum_* fill_* ymlocdum_*, censor(censored) cluster(location)
outreg2 STDcut2EX_viol_3_L_med testing_med using "$main_tables/tab_intro_exception", append stats(coef, se) nocons excel 

di _b[STDcut2EX_viol_3_L_med]
di _b[STDcut2EX_viol_3_L_med]/_se[STDcut2EX_viol_3_L_med]

******************************************************************************
*APPENDIX TABLE C1: DIFFERENTIAL IMAPCT OF TESTING BY EXCEPTION RATE  -- MILESTONES
*Panel C
*******************************************************************************
use "$data_output/reg_workerlevel_wID_7", clear


capture erase "$main_tables/tab_treat_ldur.txt"
capture erase "$main_tables/tab_treat_ldur.xml"


foreach month in 3 6 12 {
	reg month`month'_restrict STDcut2EX_viol_3_L_med testing_med locdum_* monthdum_* posdum_*, cluster(location)
	outreg2 STDcut2EX_viol_3_L_med testing_med using "$main_tables/tab_treat_ldur", append stats(coef, se) nocons excel 
	
	reg month`month'_restrict STDcut2EX_viol_3_L_med testing_med locdum_* monthdum_* posdum_* clientyeardum_* fill_* ymlocdum_* , cluster(location)
	outreg2 STDcut2EX_viol_3_L_med testing_med using "$main_tables/tab_treat_ldur", append stats(coef, se) nocons excel 
}

*pause

******************************************************************************
**Section 5: ROBUSTNESS ANALYSES
**Table 5: Initially Passed over Applicants
**Appendix Table C2: Outcomes by Wait Time until hired
**Appendix Table C3: Pools with many greens
******************************************************************************

capture log close
log using "$main_log/section5_robustness.log", replace

******************************************************************************
*TABLE 5: PASSED OVER MAIN REGRESSIONS
*******************************************************************************
***need to find locations that meet criteria
use "$data_output/reg_workerlevel_wID_7", clear
keep location
duplicates drop
tempfile locs
save `locs', replace

******EXCEPTION YELLOWS VS PASSED OVER GREENS
use $data_output/reg_indiv_pool_6, clear
merge m:1 location using `locs'
keep if _merge==3

keep if exception_y==1 | (passedup_g==1 & hiredlater==1)

assert hire_month!=event_month if passedup_g==1

assert hire_month==event_month if exception_y==1

tab testing_med
keep if testing_med==1

gen waittime = hire_month - apply_month
assert waittime<=3 if exception_y==1
tab waittime if passedup_g==1
drop if waittime>3 & passedup_g==1

bysort pool: egen Ngreen = sum(passedup_g)
bysort pool: egen Nyellow = sum(exception_y)
gen hasID = (Ngreen>0 & Nyellow>0)
tab hasID
keep if hasID==1

bysort location: gen Nhires_loc = _N
bysort location: gen count_loc = _n
sum Nhires_loc, d
sum Nhires_loc if count_loc==1, d 

bysort pool: gen Nhires_pool = _N
bysort pool: gen count_pool = _n
sum Nhires_pool, d
sum Nhires_pool if count_pool==1, d 

keep if Nhires_loc>=10 & Nhires_pool>=5

keep ldur passedup_g locdum_* monthdum_* posdum_* censored location clientyeardum_* APC*dum_* fill_* pool hire_month
foreach var of varlist locdum_* {
	gen yr`var'=`var'*hire_month
}
qui tab pool, gen(pooldum_)

*JUST LOCATION AND TIME FES
cnreg ldur passedup_g locdum_* monthdum_* posdum_*, cen(censored) cluster(location) 
outreg2 passedup_g using "$main_tables/tab_passedover_all", replace stats(coef, se) nocons excel

*APPLICATION POOL FES
cnreg ldur passedup_g monthdum_* posdum_* pooldum_*, cen(censored) cluster(location) 
outreg2 passedup_g using "$main_tables/tab_passedover_all", append stats(coef, se) nocons excel


******EXCEPTION REDS VS PASSED OVER YELLOWS AND PASSED OVER GREENS
use $data_output/reg_indiv_pool_6, clear
merge m:1 location using `locs'
keep if _merge==3

keep if exception_r==1 | (passedup_g==1 & hiredlater==1) | (passedup_y==1 & hiredlater==1)

assert hire_month!=event_month if passedup_g==1 | passedup_y==1

assert hire_month==event_month if exception_r==1

tab testing_med
keep if testing_med==1

gen waittime = hire_month - apply_month
assert waittime<=3 if exception_r==1
tab waittime if passedup_y==1 | passedup_g==1
drop if waittime>3 & (passedup_y==1 | passedup_g==1)

bysort pool: egen Ngreen = sum(passedup_g)
bysort pool: egen Nyellow = sum(passedup_y)
bysort pool: egen Nred = sum(exception_r)
gen hasID = (Nred>0 & (Ngreen>0 | Nyellow>0))
tab hasID
keep if hasID==1
bysort location: gen Nhires_loc = _N
bysort location: gen count_loc = _n
sum Nhires_loc, d
sum Nhires_loc if count_loc==1, d 

bysort pool: gen Nhires_pool = _N
bysort pool: gen count_pool = _n
sum Nhires_pool, d
sum Nhires_pool if count_pool==1, d 

keep if Nhires_loc>=10 & Nhires_pool>=5

keep ldur passedup_g passedup_y locdum_* monthdum_* posdum_* censored location clientyeardum_* APC*dum_* fill_* pool hire_month
foreach var of varlist locdum_* {
	gen yr`var'=`var'*hire_month
}
qui tab pool, gen(pooldum_)

*JUST LOCATION AND TIME FES
cnreg ldur passedup_g passedup_y locdum_* monthdum_* posdum_*, cen(censored) cluster(location) 
outreg2 passedup_g passedup_y using "$main_tables/tab_passedover_all", append stats(coef, se) nocons excel

*APPLICATION POOL FES
cnreg ldur passedup_g passedup_y monthdum_* posdum_* pooldum_*, cen(censored) cluster(location) 
outreg2 passedup_g passedup_y using "$main_tables/tab_passedover_all", append stats(coef, se) nocons excel


******************************************************************************
*Appendix TABLE C2: WAIT TIME AND DURATION
****************************************************************************

*****	Green Workers
use "$data_output/reg_workerlevel_wID_7" if green==1, clear

keep if testing_med==1
assert apply_month!=. & hire_month!=.
gen passedup = hire_month>apply_month

drop wait
gen wait = hire_month - apply_month
assert wait<=3
tab wait
gen wait1 = (wait==1)
gen wait2 = (wait==2)
gen wait3 = (wait==3)

keep ldur green yellow red wait wait1 wait2 wait3 exception_y passedup locdum_* monthdum_* posdum_* clientyeardum_* fill_* ymlocdum_* APC*dum_*  location censored recruiter_id apply_month

bysort location recruiter_id apply_month: egen helper = sd(wait)

gen hasID = (helper!=0 & helper!=.)
tab hasID

keep if hasID==1
egen initialpoolid = group(location recruiter_id apply_month)
bysort location: gen Nhires_loc = _N
bysort location: gen count_loc = _n
sum Nhires_loc, d
sum Nhires_loc if count_loc==1, d 

bysort initialpoolid: gen Nhires_pool = _N
bysort initialpoolid: gen count_pool = _n
sum Nhires_pool, d
sum Nhires_pool if count_pool==1, d 
keep if Nhires_loc>=10 & Nhires_pool>=5

qui tab initialpoolid, gen(appdum_)
	
*JUST LOCATION AND TIME FES
cnreg ldur wait1 wait2 wait3  locdum_* monthdum_*  posdum_* , cluster(location) censor(censored)
outreg2 wait1 wait2 wait3  using "$main_tables/tab_wait_g", replace stats(coef, se) nocons excel 

*APPLICATION POOL FES FROM INITIAL POOL HIRED TO. These are a manager-location-month level.
cnreg ldur wait1 wait2 wait3  posdum_* appdum_* , cluster(location) censor(censored)
outreg2 wait1 wait2 wait3  using "$main_tables/tab_wait_g", append stats(coef, se) nocons excel 


*****	Yellow Workers	
use "$data_output/reg_workerlevel_wID_7" if yellow==1, clear

keep if testing_med==1
assert apply_month!=. & hire_month!=.
gen passedup = hire_month>apply_month

drop wait
gen wait = hire_month - apply_month
assert wait<=3
tab wait
gen wait1 = (wait==1)
gen wait2 = (wait==2)
gen wait3 = (wait==3)

keep ldur green yellow red wait wait1 wait2 wait3 exception_y passedup locdum_* monthdum_* posdum_* clientyeardum_* fill_* ymlocdum_* APC*dum_*  location censored recruiter_id apply_month

bysort location recruiter_id apply_month: egen helper = sd(wait)
	
gen hasID = (helper!=0 & helper!=.)
tab hasID

keep if hasID==1
egen initialpoolid = group(location recruiter_id apply_month)

bysort location: gen Nhires_loc = _N
bysort location: gen count_loc = _n
sum Nhires_loc, d
sum Nhires_loc if count_loc==1, d 

bysort initialpoolid: gen Nhires_pool = _N
bysort initialpoolid: gen count_pool = _n
sum Nhires_pool, d
sum Nhires_pool if count_pool==1, d 
keep if Nhires_loc>=10 & Nhires_pool>=5
qui tab initialpoolid, gen(appdum_)
	
*JUST LOCATION AND TIME FES
cnreg ldur wait1 wait2 wait3  locdum_* monthdum_*  posdum_* , cluster(location) censor(censored)
outreg2 wait1 wait2 wait3  using "$main_tables/tab_wait_y", replace stats(coef, se) nocons excel 

*APPLICATION POOL FES FROM INITIAL POOL HIRED TO
cnreg ldur wait1 wait2 wait3  posdum_*  appdum_* , cluster(location) censor(censored)
outreg2 wait1 wait2 wait3  using "$main_tables/tab_wait_y", append stats(coef, se) nocons excel 


*****	Red Workers
use "$data_output/reg_workerlevel_wID_7" if red==1, clear

keep if testing_med==1
assert apply_month!=.
gen passedup = hire_month>apply_month

drop wait
gen wait = hire_month - apply_month
tab wait
gen wait1 = (wait==1)
gen wait2 = (wait==2)
gen wait3 = (wait==3)

keep ldur green yellow red wait wait1 wait2 wait3 exception_y passedup locdum_* monthdum_* posdum_* clientyeardum_* fill_* ymlocdum_* APC*dum_*  location censored recruiter_id apply_month

bysort location recruiter_id apply_month: egen helper = sd(wait)

gen hasID = (helper!=0 & helper!=.)
tab hasID

keep if hasID==1
egen initialpoolid = group(location recruiter_id apply_month)
bysort location: gen Nhires_loc = _N
bysort location: gen count_loc = _n
sum Nhires_loc, d
sum Nhires_loc if count_loc==1, d 

bysort initialpoolid: gen Nhires_pool = _N
bysort initialpoolid: gen count_pool = _n
sum Nhires_pool, d
sum Nhires_pool if count_pool==1, d 
keep if Nhires_loc>=10 & Nhires_pool>=5

qui tab initialpoolid, gen(appdum_)
	
*JUST LOCATION AND TIME FES
cnreg ldur wait1 wait2 wait3  locdum_* monthdum_*  posdum_* , cluster(location) censor(censored)
outreg2 wait1 wait2 wait3  using "$main_tables/tab_wait_r", replace stats(coef, se) nocons excel 

*APPLICATION POOL FES FROM INITIAL POOL HIRED TO
cnreg ldur wait1 wait2 wait3  posdum_* appdum_* , cluster(location) censor(censored)
outreg2 wait1 wait2 wait3  using "$main_tables/tab_wait_r", append stats(coef, se) nocons excel 


******************************************************************************************
*APPENDIX TABLE C3: MORE GREENS
******************************************************************************************

use "$data_output/reg_workerlevel_wID_7", clear

keep if testing_med==0 | (numapp_g>= numhire_g + numhire_y + numhire_r & numapp_g!=.)

bysort location testing_med: egen Nperiods = nvals(hire_month)
sum Nperiods, d
keep if testing_med==0 | (testing_med==1 & Nperiods>2)

cnreg ldur STDcut2EX_viol_3_R_med locdum_* monthdum_*  posdum_* if testing_med==1, cluster(location) censor(censored)
outreg2 STDcut2EX_viol_3_R_med using "$main_tables/tab_moregreens", replace stats(coef, se) nocons excel keep(STDcut2EX_viol_3_R_med)

cnreg ldur STDcut2EX_viol_3_R_med locdum_* monthdum_*  posdum_* clientyeardum_* fill_* ymlocdum_* APC*dum_* if testing_med==1, cluster(location) censor(censored)
outreg2 STDcut2EX_viol_3_R_med using "$main_tables/tab_moregreens", append stats(coef, se) nocons excel keep(STDcut2EX_viol_3_R_med)

cnreg ldur STDcut2EX_viol_3_L_med testing_med locdum_* monthdum_*  posdum_* , cluster(location) censor(censored)
outreg2 STDcut2EX_viol_3_L_med testing_med using "$main_tables/tab_moregreens", append stats(coef, se) nocons excel keep(STDcut2EX_viol_3_L_med testing_med)

cnreg ldur STDcut2EX_viol_3_L_med testing_med locdum_* monthdum_*  posdum_* clientyeardum_* fill_* ymlocdum_* , cluster(location) censor(censored)
outreg2 STDcut2EX_viol_3_L_med testing_med using "$main_tables/tab_moregreens", append stats(coef, se) nocons excel keep(STDcut2EX_viol_3_L_med testing_med)

******************************************************************************
**Section 5: Output per hour
*Appendix Figure C1: Correlation bw duration and output per hour
*Table 6: Main output per hour analysis
******************************************************************************

capture log close
log using "$main_log/outputperhour.log", replace
******************************************************************************
*PREDICTING MISSING OUTPUT PER HOUR
******************************************************************************
use "$data_output/reg_workerlevel_wID_7", clear
gen Moutputs = (outputperhour60!=.)
tab Moutputs
reg Moutputs locdum_* monthdum_* posdum_*
gen weeks = round(dur/7)
reg Moutputs locdum_* monthdum_* posdum_* i.weeks

******************************************************************************
*APPENDIX FIGURE C1: CORR BETWEEN OUTPUT PER HOUR AND DURATIONS
******************************************************************************
use "$data_output/reg_workerlevel_wID_7", clear
keep if outputperhour60!=.

binscatter outputperhour60 ldur, nquantiles(20) controls(locdum_* ) xtitle("Log(Duration)") ytitle("Output per Hour")
graph export $main_graphs/fig_outputmetric_dur.pdf, as(pdf) replace

binscatter outputperhour60 ldur, nquantiles(20)  xtitle("Log(Duration)") ytitle("Output per Hour")
graph export $scratch_graphs/fig_outputmetric_dur_nocontrols.pdf, as(pdf) replace

binscatter outputperhour60 ldur, nquantiles(20)  xtitle("Log(Duration)") ytitle("Output per Hour") controls(locdum_* monthdum_* posdum_* outputmetric_count_dum*)
graph export $scratch_graphs/fig_outputmetric_dur_basecontrols.pdf, as(pdf) replace


******************************************************************************
*TABLE 6: MAIN OUTPUT PER HOUR ANALYSIS
******************************************************************************
use "$data_output/reg_workerlevel_wID_7", clear
keep if outputperhour60!=.

areg outputperhour60 STDcut2EX_viol_3_R_med  i.location posdum_* outputmetric_count_dum* if testing_med==1, cluster(location) absorb(hire_month)
outreg2 STDcut2EX_viol_3_R_med  using "$main_tables/tab_outputperhour", replace stats(coef, se) nocons excel 

areg outputperhour60 STDcut2EX_viol_3_R_med  i.location posdum_* outputmetric_count_dum* clientyeardum_* fill_* ymlocdum_* APC*dum_* if testing_med==1, cluster(location) absorb(hire_month)
outreg2 STDcut2EX_viol_3_R_med  using "$main_tables/tab_outputperhour", append stats(coef, se) nocons excel 

areg outputperhour60 STDcut2EX_viol_3_L_med testing_med  i.location posdum_* outputmetric_count_dum* , cluster(location) absorb(hire_month)
outreg2 STDcut2EX_viol_3_L_med testing_med using "$main_tables/tab_outputperhour", append stats(coef, se) nocons excel

areg outputperhour60 STDcut2EX_viol_3_L_med testing_med  i.location posdum_* outputmetric_count_dum* clientyeardum_* fill_* ymlocdum_* , cluster(location) absorb(hire_month)
outreg2 STDcut2EX_viol_3_L_med testing_med using "$main_tables/tab_outputperhour", append stats(coef, se) nocons excel 




