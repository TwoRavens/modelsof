
clear
clear all
clear mata
set more off
set matsize 11000
set maxvar 30000

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


***************************************************************************
***THIS FILE PRODUCES APPENDIX A TABLES AND FIGURES
**APPENDIX C TABLES AND FIGURES PRODUCED IN MAIN PAPER REGS FILE
**************************************************************************


*****************************************************************************
*Data Appendix
*Figure A1: share tested by time since testing
*Figure A2: sample coverage within locations over time
*Table A1: robustness
*Figure A3: balanced panel of event sutdy figure
*Figure A4: description of timing of introduction of testing across locations
*Figure A5: timing of testing and location observables
*Figure A6: accuracy of testing by location exception rates
*Figure A7. accuracy of testing by other location observables
*****************************************************************************

capture log close
log using "$app_log/share_tested_coverage.log", replace
*****************************************************************************
*Testing Appendix Figure 1
*SHARE TESTED BY TIME SINCE TESTING
*****************************************************************************

use "$data_output/clean_hiredworkers_nost_2", clear

assert hasscore == (green==1 | yellow==1 | red==1)

collapse hasscore testing_med testing_any start_testing_month_med (count) Nworkers=employeeID, by(location hire_month)

gen time_since = hire_month - start_testing_month_med

table time_since, c(mean Nworkers)

gen inwindow = time_since>=-36  & time_since<=36
tab inwindow
tab inwindow [aw=Nworkers]
*Collapse across locations, weighting by hires
collapse hasscore (p50) med=hasscore (p25) p25=hasscore (p75)p75=hasscore [aw=Nworkers], by(time_since)
twoway (line hasscore time_since if time_since>=-36 & time_since<=36 ), xtitle("Months since assigned testing date") ytitle(Share tested) legend(off) graphregion(color(white)) bgcolor(white) xlabel(-36 -18 0 18 36)
graph export $app_graphs/TAfig_share_tested_unr.pdf, as(pdf) replace

*****************************************************************************
*APPENDIX FIGURE 2: COVERAGE ACROSS LOCATIONS
*****************************************************************************
use "$data_output/clean_hiredworkers_nost_2", clear
collapse testing_med clientID start_testing_month_med (count) Nworkers = ldur , by(location hire_month)

assert testing_med!=.

sort clientID location
egen cli_loc = group(clientID location)
sum cli_loc
local until = r(max)
egen cli_grp = group(clientID)
sum cli_grp
local cli_until = r(max)

***make 5 spaces between client groups

foreach cli of numlist 2/`cli_until' {
	replace cli_loc = cli_loc + 5*(`cli' - 1) if cli_grp==`cli'
}
	

***for labeling
bysort clientID: egen ave_index = mean(cli_loc)
tab ave_index


tsset cli_loc hire_month, monthly
gen time_since = hire_month - start_testing_month_med

*To guarantee confidentiality, remove y-labeling from version in paper.
twoway (scatter cli_loc hire_month if testing_med==0 & time_since>=-36 & time_since<=36,  msymbol(Oh) msize(vsmall) mcolor(navy) mlwidth(vvthin)) (scatter cli_loc hire_month if testing_med==0 & time_since==.,  msymbol(Oh) msize(vsmall) mcolor(navy) mlwidth(vvthin)) (scatter cli_loc hire_month if testing_med==1&  time_since>=-36 & time_since!=.,  msymbol(O) msize(vsmall) mcolor(navy) mlwidth(vvthin)) , xtitle(Hire Date, size(small)) ytitle("Client Firm", size(small)) legend(off) xlabel(, labsize(small)) graphregion(color(white))  bgcolor(white) caption("Hollow = pre-testing, Filled = post-testing", size(small))

graph export $app_graphs/TAfig_location_coverage_unr.pdf, replace

capture log close
log using "$app_log/intro_robustness_balance.log", replace
*****************************************************************************
*Appendix Table A1
*ROBUSTNESS TO DIFFERENT TESTING DEFINITIONS AND SAMPLE COVERAGE
*****************************************************************************
use "$data_output/reg_workerlevel_wID_7", clear

gen EX_any = STDcut2EX_viol_3_L if testing_any==1
replace EX_any = 0 if testing_any == 0

gen EX_has = STDcut2EX_viol_3_L if hasscore==1
replace EX_has = 0 if hasscore == 0

***locations observed both before and after testing
bysort location: egen helper = sd(testing_med)
codebook location if helper!=0

****balanced panel
gen time_since = hire_month - start_testing_month_med
gen time_since_qtr = floor(time_since/3)
sum time_since_qtr
bysort location: egen first = min(time_since_qtr)
bysort location: egen last = max(time_since_qtr)

foreach num of numlist 12(-1)1 {
	gen em`num' = (time_since_qtr==-`num')
}
foreach num of numlist 1/12 {
	gen ep`num' = (time_since_qtr==`num')
}
gen e0 = (time_since_qtr==0)
gen event_intm13plus = (time_since_qtr<=-13)
gen event_intp13plus = (time_since_qtr>=13)
**all these interactions should sum to 1
gen test = e0 + event_intm13plus + event_intp13plus
foreach num of numlist 1/12 {
	replace test = test + em`num' + ep`num'
}

foreach var of varlist em* ep* e0 {
	bysort location: egen L`var' = mean(`var')
}

***balanced means X months prior, the 0 month and X-1 months post (the 0 month should also be included as a post month)
gen runningbalance = (Le0!=0)
foreach balance of numlist 2/12 {
	local post = (`balance' - 1)
	gen panel`balance' = (first<=-1*`balance' & last>=`post' & time_since!=.)
	replace runningbalance = runningbalance*(Lem`balance'!=0)*(Lep`post'!=0)
	gen balance`balance' = runningbalance
	
	tab panel`balance' balance`balance'
}
gen panel1 = (first<=-1 & time_since!=.)
gen balance1 = (Lem1!=0 & Le0!=0)

sum panel* balance*
***among locations observed both before and after testing
sum panel* balance* if helper!=0


gen gap = last - first
sum last first gap if helper!=0

***summary statistics cited in appendix{App_coverage}
display "total number of locations"
codebook location
display "total number of locations with testing"
codebook location if testing_med==1
display "total number of locations with data pre AND post testing"
codebook location if helper!=0
display "average observation window among pre/post locations"
display "add 4 quarters to last to take into account the 0 testing quarter"
sum last first if helper!=0
display "locations observed at least N months pre/post"
sum panel2 panel4 panel6 panel8 if helper!=0
display "conditional on panel, locations hiring in each quarter within panel"
sum balance4 if panel4==1

**original
cnreg ldur  testing_med locdum_* monthdum_* posdum_* , censor(censored) cluster(location)
outreg2  testing_med using "$app_tables/TAtab_robustness", replace stats(coef, se) nocons excel 

***testing starts when first worker is tested
cnreg ldur  testing_any locdum_* monthdum_* posdum_* , censor(censored) cluster(location)
outreg2  testing_any using "$app_tables/TAtab_robustness", append stats(coef, se) nocons excel 

***testing defined at individ level
cnreg ldur  hasscore locdum_* monthdum_* posdum_* , censor(censored) cluster(location)
outreg2  hasscore using "$app_tables/TAtab_robustness", append stats(coef, se) nocons excel 

***restrict to locations observed both before and after testing
cnreg ldur  testing_med locdum_* monthdum_* posdum_* if helper!=0, censor(censored) cluster(location)
outreg2  testing_med using "$app_tables/TAtab_robustness", append stats(coef, se) nocons excel 

**restrict to locations observed in 4 quarter balanced window
cnreg ldur  testing_med locdum_* monthdum_* posdum_* if balance4==1, censor(censored) cluster(location)
outreg2  testing_med using "$app_tables/TAtab_robustness", append stats(coef, se) nocons excel 


**restrict to clients that had no testing in pre-period
do "$Do/zz_make_notest.do"
cnreg ldur  testing_med locdum_* monthdum_* posdum_* if notest==1, censor(censored) cluster(location)
outreg2  testing_med using "$app_tables/TAtab_robustness", append stats(coef, se) nocons excel 


**original
cnreg ldur STDcut2EX_viol_3_L_med testing_med locdum_* monthdum_* posdum_* , censor(censored) cluster(location)
outreg2 STDcut2EX_viol_3_L_med testing_med using "$app_tables/TAtab_robustness", append stats(coef, se) nocons excel 

***testing starts when first worker is tested
cnreg ldur EX_any testing_any locdum_* monthdum_* posdum_* , censor(censored) cluster(location)
outreg2 EX_any testing_any using "$app_tables/TAtab_robustness", append stats(coef, se) nocons excel 

***testing defined at individ level
cnreg ldur EX_has hasscore locdum_* monthdum_* posdum_* , censor(censored) cluster(location)
outreg2 EX_has hasscore using "$app_tables/TAtab_robustness", append stats(coef, se) nocons excel 

***restrict to locations observed both before and after testing
cnreg ldur STDcut2EX_viol_3_L_med testing_med locdum_* monthdum_* posdum_* if helper!=0, censor(censored) cluster(location)
outreg2 STDcut2EX_viol_3_L_med testing_med using "$app_tables/TAtab_robustness", append stats(coef, se) nocons excel 

**restrict to locations observed in 4 month balanced window
cnreg ldur STDcut2EX_viol_3_L_med testing_med locdum_* monthdum_* posdum_* if balance4==1, censor(censored) cluster(location)
outreg2 STDcut2EX_viol_3_L_med testing_med using "$app_tables/TAtab_robustness", append stats(coef, se) nocons excel 

**restrict to clients that had no testing in pre-period
cnreg ldur STDcut2EX_viol_3_L_med testing_med locdum_* monthdum_* posdum_* if notest==1, censor(censored) cluster(location)
outreg2 STDcut2EX_viol_3_L_med testing_med using "$app_tables/TAtab_robustness", append stats(coef, se) nocons excel 

	
*****************************************************************************
*Appendix Figure A3
*EVENT STUDY BALANCED PANEL
*****************************************************************************

foreach balance in balance panel {

	cnreg ldur event_intm13plus em12-em2 e0 ep1-ep12 event_intp13plus locdum_* monthdum_* posdum_* clientyeardum_* fill_* if `balance'4==1, cen(censored) cluster(location)


	*get matrix coefficients and standard errors
	matrix Tcoeffs=e(b)
	matrix Tses = e(V)
	mata: coeffs`balance' = st_matrix("Tcoeffs")'
	mata: ses`balance' = diagonal(st_matrix("Tses"))
	*only plot 12 lags and leads
	mata: coeffs`balance' = coeffs`balance'[2..25]
	mata: ses`balance' = ses`balance'[2..25]:^.5

*DO THE MILESTONES TOO
foreach month in 3 6 12 {
reg month`month'_restrict em10-em2 e0 ep1-ep10  locdum_* monthdum_* posdum_* clientyeardum_* fill_* if `balance'4==1 & time_since_qtr<=10 & time_since_qtr>=-10, cluster(location)
	*get matrix coefficients and standard errors
	matrix Tcoeffs=e(b)
	matrix Tses = e(V)
	mata: coeffs`balance'month`month' = st_matrix("Tcoeffs")'
	mata: ses`balance'month`month' = diagonal(st_matrix("Tses"))
	*only plot 12 lags and leads
	*mata: coeffsmonth`month' = coeffsmonth`month'[2..25]
	*mata: sesmonth`month' = sesmonth`month'[2..25]:^.5
	mata: coeffs`balance'month`month' = .\.\coeffs`balance'month`month'[1..20]\.\.
	mata: ses`balance'month`month' = .\.\ses`balance'month`month'[1..20]:^.5\.\.
}
}
clear
getmata coeffspanel sespanel coeffsbalance sesbalance coeffspanelmonth3 sespanelmonth3 coeffsbalancemonth3 sesbalancemonth3  coeffspanelmonth6 sespanelmonth6 coeffsbalancemonth6 sesbalancemonth6  coeffspanelmonth12 sespanelmonth12 coeffsbalancemonth12 sesbalancemonth12  

foreach balance in balance panel {
	gen ci_plus`balance' = coeffs`balance' + 1.96*ses`balance'
	gen ci_minus`balance' = coeffs`balance' - 1.96*ses`balance'
	foreach month in 3 6 12 {
		gen ci_plus`balance'month`month' = coeffs`balance'month`month' + 1.96*ses`balance'month`month'
		gen ci_minus`balance'month`month' = coeffs`balance'month`month' - 1.96*ses`balance'month`month'
	}
}


gen counter = _n 
gen lag = -13 + counter   if counter<12
replace lag = -12 + counter if counter>=12
local helper = _N +1 
set obs `helper'
replace lag = -1 in `helper'

***makes graphs for completely balanced panels and for locations observed for the full length of the window but not nec in each quarter
**only using balance right now
foreach balance in balance panel {
	replace coeffs`balance'=0 in `helper'
	replace ci_plus`balance'=0 in `helper'
	replace ci_minus`balance'=0 in `helper'
	
	foreach month in 3 6 12 {
		 replace coeffs`balance'month`month' = 0 in `helper'
		 replace ci_plus`balance'month`month' = 0 in `helper'
		 replace ci_minus`balance'month`month' = 0 in `helper'
	}
}


**month12 has more missings because balanced panel does not have obs close to data end date
foreach balance in balance panel {
	replace coeffs`balance'month12=. if lag>=9 
	replace ci_plus`balance'month12 = . if lag>=9
	replace ci_minus`balance'month12 = . if lag>=9
}
sort lag
list


local bhelp = -4
local b2 = 3
foreach balance in balance panel {
	twoway (line coeffs`balance' lag if lag>=-10 & lag<=10, lcolor(navy)) (line ci_plus`balance' lag if lag>=-10 & lag<=10, lcolor(navy) lpattern(dash) lwidth(vvthin)) (line ci_minus`balance' lag if lag>=-10 & lag<=10, lcolor(navy) lpattern(dash) lwidth(vvthin)) , xtitle("") ytitle("") title("Log(Duration)") legend(off) xline(-1, lcolor(red)) legend(off) yline(0, lcolor(black) lpattern(dash) lwidth(vvthin)) saving("$scratch_graphs/g`balance'", replace) xline(`bhelp' `b2', lcolor(black) lpattern(dash)) graphregion(color(white)) bgcolor(white) xlabel(-8 -4 0 4 8)  

	foreach month in 3 6 12 {
		twoway (line coeffs`balance'month`month' lag if lag>=-10 & lag<=10, lcolor(navy)) (line ci_plus`balance'month`month' lag if lag>=-10 & lag<=10, lcolor(navy) lpattern(dash) lwidth(vvthin)) (line ci_minus`balance'month`month' lag if lag>=-10 & lag<=10, lcolor(navy) lpattern(dash) lwidth(vvthin)) , xtitle("") ytitle("")  title("Survived `month' Months") legend(off) xline(-1, lcolor(red)) legend(off) yline(0, lcolor(black) lpattern(dash) lwidth(vvthin)) saving("$scratch_graphs/gmonth`month'_`balance'", replace) xline(`bhelp' `b2', lcolor(black) lpattern(dash)) graphregion(color(white)) bgcolor(white)  xlabel(-8 -4 0 4 8)
	}
}

graph combine "$scratch_graphs/gbalance" "$scratch_graphs/gmonth3_balance" "$scratch_graphs/gmonth6_balance" "$scratch_graphs/gmonth12_balance", l1title(Coefficient) b1title(Quarters since Introduction of Testing)  graphregion(color(white)) 
graph export $app_graphs/TAfig_event_balanced4.pdf, as(pdf) replace
*note("Regressions adjust for censoring and include base controls. Balanced panels restrict to locations" "with observations in each quarter from 4 lags to 4 leads.")

capture log close
log using "$app_log/intro_loc_chars.log", replace


*****************************************************************************
*Testing Appendix Figure 4
*TIMING OF TESTING ADOPTION ACROSS LOCATIONS
*****************************************************************************
***create snapshot by location -- use the # currently working in July of 2013
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
**start with 2013Q3 -- all but 1 location has workers at that date
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

*Create figure
use "$data_output/reg_workerlevel_wID_7", clear
merge m:1 location using "$data_output/location_size"
assert _merge==3 

**create within-client weights
egen newclient=group(clientID)
bysort newclient: egen total_size = sum(location_size)
gen within_wt = location_size/total_size
gen test_start_date = hire_month if testing_med==1

collapse newclient location_size within_wt start_testing_month_med (min) test_start_date, by(location)

tsset location test_start_date, monthly
twoway scatter newclient test_start_date [aw=location_size],  xtitle("Test Date") ytitle("Client Firm") legend(off) scale(.7) msymbol(circle_hollow)  graphregion(color(white)) bgcolor(white)
graph export $scratch_graphs/fig_timetest_altdate.pdf, replace
*title("Date of Location Testing Adoption, by Client Firm") subtitle("Unweighted")

**weight obs by share of size within client unused
twoway scatter newclient test_start_date [aweight=within_wt],  xtitle("Test Date") ytitle("Client Firm") legend(off) scale(.7) msymbol(circle_hollow) graphregion(color(white)) bgcolor(white)
graph export $scratch_graphs/fig_timingoftest_w2.pdf, replace
*title("Date of Location Testing Adoption, by Client Firm") subtitle("Weighted by Number of Hires")

**USE THIS ONE: this graph shows the original start testing date, before any restrictions 
tsset location start_testing_month_med, monthly
twoway scatter newclient start_testing_month_med [aw=location_size],  xtitle("Test Date") ytitle("Client Firm") legend(off) scale(.7) msymbol(circle_hollow)  graphregion(color(white)) bgcolor(white)
graph export $app_graphs/TAfig_timingoftest_w1.pdf, replace


***stats reported in the text around this figure
***testing "turn on" v no testing at all
use "$data_output/reg_workerlevel_wID_7", clear
codebook location
codebook location if testing_med==1
codebook location if hasscore==1

**number of clients with more than 1 location
bysort clientID: egen Nlocs = nvals(location)
codebook clientID if Nlocs!=1
display "Share of hires to clients with more than one location"
tab Nlocs

***within location range of dates for testing
capture drop temp
gen temp = hire_month if testing_med==1
bysort location: egen testing_start_date = min(temp)
bysort clientID: egen First_test = min(testing_start_date)
bysort clientID: egen Last_test = max(testing_start_date)
gen range = Last_test - First_test
tab range if Nlocs!=1
bysort clientID: gen counter = _n
display "Range of testing dates within client (unweighted)"
tab range if counter==1 & Nlocs!=1


*****************************************************************************
*APPENDIX FIGURE 5: LOCATION CHARACTERISTICS BY TIMING OF TESTING
*LOCATION CHARS BY MONTH
*****************************************************************************
use "$data_output/reg_workerlevel_wID_7", clear

***SIZE IN PRE-TESTING PERIOD
use "$data_output/reg_workerlevel_wID_7", clear
keep if testing_med==0

* Similar to code for Figure 5 in step4 in extracting size.
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

**frequency of hires: share of quarters from first quarter to last quarter where hires are made
use "$data_output/reg_workerlevel_wID_7", clear

bysort location: egen start = min(hire_month)
bysort location: egen end = max(hire_month)
bysort location: egen nmnths = nvals(hire_month)
gen share_w_hires = nmnths/(end-start+1)
sum share_w_hires, d
keep share_w_hires location
duplicates drop
save "$data_output/location_freq_hires", replace

***frequency of hires pre testing
use "$data_output/reg_workerlevel_wID_7", clear
keep if testing_med==0

bysort location: egen start = min(hire_month)
bysort location: egen end = max(hire_month)
bysort location: egen nmnths = nvals(hire_month)
gen share_w_hires = nmnths/(end-start+1)
sum share_w_hires, d
keep share_w_hires location
duplicates drop
ren share_w_hires share_w_hires_pre
save "$data_output/location_freq_hires_pre", replace

***location-specific churn rate PRE testing
use "$data_output/reg_workerlevel_wID_7", clear
keep if testing_med==0
sum hire_month
local start = r(min)
local end = r(max)

foreach month of numlist `start'/`end' {
	gen working`month' = (hire_month<=`month' & term_month>=`month')
	gen hire`month' = (hire_month==`month')
	gen sep`month' = (term_month==`month')
	
}
bysort location: egen start = min(hire_month)
bysort location: egen end = max(hire_month)
collapse start end (sum) working`start'-sep`end', by(location)

reshape long working hire sep, i(location) j(mntime)
***keep only quarters where the firm is active
keep if mntime>=start & mntime<=end
gen churn = (hire + sep - abs(hire - sep))/working
sum churn, d

***take an unweighted average across months the location hires in
**also separate variable that excludes quarters with no hires
gen churn_hires = churn if hire!=0
sum churn churn_hires, d
collapse churn churn_hires, by(location)
ren churn churn_pre 
ren churn_hires churn_hires_pre

save "$data_output/location_churn_pre", replace

****************************************************************************
*CENSORING ADJUSTED SPELLS PRE_TESTING
*****************************************************************************
use "$data_output/reg_workerlevel_wID_7", clear

keep if testing_med==0
egen loc_group = group(location)
qui tab loc_group, gen(Dloc)
sum loc_group
local until = r(max)

gen adj_pre_dur = .
cnreg ldur Dloc1-Dloc`until', censor(censored) nocons
foreach loc_group of numlist 1/`until' {
	replace adj_pre_dur = _b[Dloc`loc_group'] if loc_group==`loc_group'
}
assert adj_pre_dur!=.
keep adj_pre_dur location
duplicates drop
save "$data_output/location_durs", replace

****************************************************************************
*CENSORING ADJUSTED CHANGE IN DURATIONS PRE-TESTING
*****************************************************************************
use "$data_output/reg_workerlevel_wID_7", clear

keep if testing_med==0
egen loc_group = group(location)
qui tab loc_group, gen(Dloc)
sum loc_group
local until = r(max)

bysort location: egen ave_month = mean(hire_month)
gen demean_time = hire_month - ave_month

foreach loc of numlist 1/`until' {
	gen time_Dloc`loc' = Dloc`loc'*demean_time
}

gen adj_pre_dur = .
gen adj_time = .
cnreg ldur Dloc1-Dloc`until' time_Dloc1-time_Dloc`until', censor(censored) nocons
foreach loc_group of numlist 1/`until' {
	replace adj_pre_dur = _b[Dloc`loc_group'] if loc_group==`loc_group'
	replace adj_time = _b[time_Dloc`loc_group'] if loc_group==`loc_group'
}

assert adj_pre_dur!=.
replace adj_time = . if adj_time==0

keep adj_pre_dur adj_time location
duplicates drop
save "$data_output/location_durs_trend", replace


****************************************************************************
*BRING EVERYTHING TOGETHER WITH ADDITIONAL LOCATION CHARACTERISTICS
*****************************************************************************
use "$data_output/reg_workerlevel_wID_7", clear

bysort location: egen Nendusers = nvals(end_user_client)
bysort location: egen Nendusers_pre = nvals(end_user_client) if testing_med==0
bysort location: egen Nrecruiters = nvals(recruiter_id)

foreach var in share_g share_y numapp hire_rate {
	replace `var' = . if testing_med==0
}

capture drop temp
gen testing_start_date = hire_month if testing_med==1
gen outputmetric_pre60 = outputperhour60 if testing_med==0
gen Moutputmetric_pre = (outputperhour60==.) if testing_med==0

gen LOC_except = cut2EX_viol_3 if testing_med==1

foreach var in unempACS_dropout unempACS_hs unempACS_sc unempACS_college_plus {
	gen `var'_pre = `var' if testing_med==0 & fill_local==1
}

gen hires_pre = dur if testing_med==0
bysort location: egen Nmonths = nvals(hire_month)
bysort location: egen Nmonths_pre = nvals(hire_month) if testing_med==0

collapse Nmonths Nmonths_pre clientID LOC_except Nendusers Nendusers_pre Nrecruiters unempACS_dropout* unempACS_hs* unempACS_sc* unempACS_college_plus* share_g share_y numapp hire_rate outputmetric_pre60 Moutputmetric_pre fill_* M_economicdata (min) testing_start_date (count) total_hires = dur hires_pre, by(location)

**bring in location size
merge 1:1 location using "$data_output/location_size"
assert _merge==3
drop _merge

**pre-testing durs
merge 1:1 location using "$data_output/location_durs"
gen nopre = _merge
drop _merge
**pre-time trends
merge 1:1 location using "$data_output/location_durs_trend"
assert _merge==nopre
drop _merge


**bring in location size pre
merge 1:1 location using "$data_output/location_size_pre"
assert _merge==nopre
drop _merge
**bring in frequency of hires pre
merge 1:1 location using "$data_output/location_freq_hires_pre"
assert _merge==nopre
drop _merge
**location-specific churn rate pre
merge 1:1 location using "$data_output/location_churn_pre"
assert nopre==_merge
drop _merge

sum testing_start_date, d

tsset location testing_start_date, monthly


*****************************************************************************
*Make acutal figure
*APPENDIX FIGURE 5: LOCATION CHARACTERISTICS BY TIMING OF TESTING
*****************************************************************
**numapp is on a weird scale
ren numapp numapp_temp
gen float numapp = numapp_temp
drop numapp_temp
local counter = 1
foreach var in adj_pre_dur adj_time unempACS_hs_pre share_g numapp LOC_except {
	local title = "title(`var')"
	if "`var'" == "unempACS_hs_pre" {
		local title = "title(HS Unemployment Rate) subtitle(Pre-Testing Average)"
	}
	if "`var'" == "share_g" {
		local title = "title(Share Green Applicants) subtitle(Post-Testing Average)"
	}
	if "`var'" == "numapp" {
		local title = "title(Number of Applicants) subtitle(Post-Testing Average)"
	}
	if "`var'" == "adj_pre_dur" {
		local title = "title(Job Duration) subtitle(Pre-Testing Average)"
	}
	if "`var'" == "LOC_except" {
		local title = "title(Exception Rate) subtitle(Post-Testing Average)"
	}
	if "`var'" == "adj_time" {
		local title = "title(Job Duration Trend) subtitle(Pre-Testing)"
	}
	
	twoway (scatter `var' testing_start_date if location_size_pre!=.) (lfit `var' testing_start_date if location_size_pre!=.), `title' xtitle("") ytitle("") saving("$scratch_graphs/g`counter'", replace) legend(off) scale(.7) graphregion(color(white)) bgcolor(white)
	twoway (scatter `var' testing_start_date [aw=location_size_pre] if location_size_pre!=., msymbol(circle_hollow)) (lfit `var' testing_start_date  if location_size_pre!=. [aw=location_size_pre]), `title'  xtitle("") ytitle("") saving("$scratch_graphs/g`counter'_wt", replace) legend(off) scale(.7) graphregion(color(white)) bgcolor(white)

	local counter = `counter' + 1
}


graph combine "$scratch_graphs/g1" "$scratch_graphs/g2" "$scratch_graphs/g3"  "$scratch_graphs/g4" "$scratch_graphs/g5" "$scratch_graphs/g6", rows(2) b1title("Location Test-Adoption Date") graphregion(color(white))
graph export $scratch_graphs/LOC_chars.pdf, replace
graph combine "$scratch_graphs/g1_wt" "$scratch_graphs/g2_wt" "$scratch_graphs/g3_wt"  "$scratch_graphs/g4_wt" "$scratch_graphs/g5_wt" "$scratch_graphs/g6_wt", rows(2) graphregion(color(white))  b1title("Location Test-Adoption Date") 
graph export $app_graphs/TAfig_chars_wt.pdf, replace


foreach var in adj_pre_dur adj_time unempACS_hs_pre share_g numapp LOC_except {
	reg `var' testing_start_date [aw=location_size_pre]
	
}

capture log close
log using "$app_log/heterog_bycolor.log", replace


******************************************************************************************
*FIGURE A6: HETEROGENEITY -- Color score-job duration relationship by exception rate
******************************************************************************************
use "$data_output/reg_workerlevel_wID_7" if testing_med==1, clear

***make hires-weighted ventiles
xtile Vex = cut2EX_viol_3_R, nquantiles(20)

qui tab Vex, gen(Dex)

global Cont_FigA6 "locdum_* monthdum_* posdum_*"

cnreg ldur Dex1-Dex20 $Cont_FigA6 if green==1, censor(censored) cluster(location) nocons
gen coeff1g = .
foreach V of numlist 1/20 {
	replace coeff1g=_b[Dex`V'] if Vex==`V'
}

cnreg ldur Dex1-Dex20 $Cont_FigA6 if yellow==1, censor(censored) cluster(location) nocons
gen coeff1y = .
foreach V of numlist 1/20 {
	replace coeff1y=_b[Dex`V'] if Vex==`V'
}

cnreg ldur Dex1-Dex20 $Cont_FigA6 if red==1, censor(censored) cluster(location) nocons
gen coeff1r = .
foreach V of numlist 1/20 {
	replace coeff1r=_b[Dex`V'] if Vex==`V'
}

collapse coeff* cut2EX_viol_3_R, by(Vex)
twoway scatter coeff1g cut2EX_viol_3_R, mcolor(green) || lfit coeff1g cut2EX_viol_3_R, lcolor(green) || scatter coeff1y cut2EX_viol_3_R, mcolor(yellow) msymbol(triangle) || lfit coeff1y cut2EX_viol_3_R, lcolor(yellow)|| scatter coeff1r cut2EX_viol_3_R, mcolor(red) msymbol(X) || lfit coeff1r cut2EX_viol_3_R, lcolor(red) xtitle("Manager-Level Exception Rate") ytitle("Log(Duration)")   legend(order(1 3 5) label(1 "Green") label(3 "Yellow") label(5 "Red")) graphregion(color(white)) bgcolor(white)  scale(.8) 
graph export $app_graphs/fig_corrbycolor.pdf, replace

*****************************************************************************
*APPENDIX FIGURE A7: Heterogeneity in accuracy of test -- other outcomes
*****************************************************************

***produce figure for other characteristics (same ones as used for timing of testing)
use "$data_output/reg_workerlevel_wID_7", clear

bysort location: egen Nendusers = nvals(end_user_client)
bysort location: egen Nendusers_pre = nvals(end_user_client) if testing_med==0
bysort location: egen Nrecruiters = nvals(recruiter_id)

foreach var in share_g share_y numapp hire_rate {
	replace `var' = . if testing_med==0
}

capture drop temp
gen testing_start_date = hire_month if testing_med==1
gen outputmetric_pre60 = outputperhour60 if testing_med==0
gen Moutputmetric_pre = (outputperhour60==.) if testing_med==0

gen LOC_except = cut2EX_viol_3 if testing_med==1

foreach var in unempACS_dropout unempACS_hs unempACS_sc unempACS_college_plus {
	gen `var'_pre = `var' if testing_med==0 & fill_local==1   
}

gen hires_pre = dur if testing_med==0
bysort location: egen Nmonths = nvals(hire_month)
bysort location: egen Nmonths_pre = nvals(hire_month) if testing_med==0

collapse Nmonths Nmonths_pre clientID LOC_except Nendusers Nendusers_pre Nrecruiters unempACS_dropout* unempACS_hs* unempACS_sc* unempACS_college_plus* share_g share_y numapp hire_rate outputmetric_pre60 Moutputmetric_pre (min) testing_start_date (count) total_hires = dur hires_pre, by(location)
save "$data_output/oth_chars", replace

use "$data_output/reg_workerlevel_wID_7", clear
keep if testing_med==1

**has some pre- and some-post characteristics
merge m:1 location using "$data_output/oth_chars"
assert _merge!=1
drop if _merge==2
drop _merge

**bring in location size
merge m:1 location using "$data_output/location_size"
assert _merge!=1
drop if _merge==2
drop _merge

**pre-testing durs
**only merge if location has obs pre-testing
merge m:1 location using "$data_output/location_durs"
drop if _merge==2
gen nopre = _merge
drop _merge
**pre-time trends
merge m:1 location using "$data_output/location_durs_trend"
drop if _merge==2
assert _merge==nopre
drop _merge


**bring in location size pre
merge m:1 location using "$data_output/location_size_pre"
drop if _merge==2
assert _merge==nopre
drop _merge

**bring in frequency of hires pre
merge m:1 location using "$data_output/location_freq_hires_pre"
drop if _merge==2
assert _merge==nopre
drop _merge

**location-specific churn rate pre
merge m:1 location using "$data_output/location_churn_pre"
drop if _merge==2
assert _merge==nopre
drop _merge

sum testing_start_date, d


keep if testing_med==1

ren numapp numapp_temp
gen float numapp = numapp_temp
drop numapp_temp

**do unemp vars only for the state-level
foreach var in dropout hs sc college_plus {
	replace unempACS_`var'_pre = . if M_economicdata==1
}

save $working/temp, replace

local counter = 1
foreach var in adj_pre_dur adj_time unempACS_hs_pre share_g numapp   LOC_except   {
	use $working/temp, clear
	
	local title = "`var'"
	if "`var'" == "unempACS_hs_pre" {
		local title = "HS Unemployment Rate, Pre-Testing Average"
	}
	if "`var'" == "share_g" {
		local title = "Share Green Applicants, Post-Testing Average"
	}
	if "`var'" == "numapp" {
		local title = "Number of Applicants, Post-Testing Average"
	}
	if "`var'" == "adj_pre_dur" {
		local title = "Job Duration, Pre-Testing Average"
	}
	if "`var'" == "LOC_except" {
		local title = "Exception Rate, Post-Testing Average"
	}
	if "`var'" == "adj_time" {
		local title = "Job Duration Trend, Pre-Testing"
	}

	***make hires-weighted ventiles of location characteristics
	xtile Vex = `var', nquantiles(20)

	qui tab Vex, gen(Dex)
	
	global Cont_FigA7 "monthdum_* posdum_*"
	
	cnreg ldur Dex* $Cont_FigA7 if green==1, censor(censored) cluster(location) nocons
	gen coeff1g = .
	foreach V of numlist 1/20 {
		capture replace coeff1g=_b[Dex`V'] if Vex==`V'
	}

	cnreg ldur Dex* $Cont_FigA7 if yellow==1, censor(censored) cluster(location) nocons
	gen coeff1y = .
	foreach V of numlist 1/20 {
		capture replace coeff1y=_b[Dex`V'] if Vex==`V'
	}

	cnreg ldur Dex* $Cont_FigA7 if red==1, censor(censored) cluster(location) nocons
	gen coeff1r = .
	foreach V of numlist 1/20 {
		capture replace coeff1r=_b[Dex`V'] if Vex==`V'
	}

	collapse coeff* `var', by(Vex)

	twoway scatter coeff1g `var', mcolor(green) || lfit coeff1g `var', lcolor(green) || scatter coeff1y `var', mcolor(yellow) msymbol(triangle) || lfit coeff1y `var', lcolor(yellow)|| scatter coeff1r `var', mcolor(red) msymbol(X) || lfit coeff1r `var', lcolor(red) xtitle("`title'") ytitle("")   legend(off) graphregion(color(white)) bgcolor(white)  scale(.8) saving("$scratch_graphs/g`counter'", replace) 

	local counter = `counter' + 1
}


graph combine "$scratch_graphs/g1" "$scratch_graphs/g2" "$scratch_graphs/g3"  "$scratch_graphs/g4" "$scratch_graphs/g5" "$scratch_graphs/g6", rows(2) b1title("Location-Level Characteristic") l1title("Log(Duration)") graphregion(color(white))
graph export "$app_graphs/TA_fig_LOC_chars_bycolor.pdf", replace

capture log close
log using "$app_log/alt_viol_rates.log", replace


******************************************************************************
*APPENDIX TABLE A2: ALTERNATIVE VIOLATION MEASURES
******************************************************************************

use "$data_output/reg_workerlevel_wID_7", clear

gen invscore_ran = -1*STDcut2EX_score_ran2_R_med
gen invscore_max = -1*STDcut2EX_score_max2_R_med

gen invscore_Lran = -1*STDcut2EX_score_ran2_L_med
gen invscore_Lmax = -1*STDcut2EX_score_max2_L_med
capture erase "$app_tables/tab_robust_altexception.txt"
capture erase "$app_tables/tab_robust_altexception.xml"

foreach var in STDcut2EX_viol_ran_R_med invscore_max invscore_ran  {
	cnreg ldur `var' locdum_* monthdum_* posdum_* if testing_med==1, censor(censored) cluster(location)
	outreg2 `var' using "$app_tables/tab_robust_altexception", append stats(coef, se) nocons excel 
	cnreg ldur `var' locdum_* monthdum_* posdum_* clientyeardum_* fill_* ymlocdum_* APC*dum_* if testing_med==1, censor(censored) cluster(location)
	outreg2 `var' using "$app_tables/tab_robust_altexception", append stats(coef, se) nocons excel 
}
foreach var in STDcut2EX_viol_ran_L_med invscore_Lmax invscore_Lran  {
	cnreg ldur `var' testing_med locdum_* monthdum_* posdum_* , censor(censored) cluster(location)
	outreg2 `var' testing_med using "$app_tables/tab_robust_altexception", append stats(coef, se) nocons excel 
	cnreg ldur `var' testing_med locdum_* monthdum_* posdum_* clientyeardum_* fill_* ymlocdum_*, censor(censored) cluster(location)
	outreg2 `var' testing_med using "$app_tables/tab_robust_altexception", append stats(coef, se) nocons excel 
}

capture log close
log using "$app_log/restrictions.log", replace

******************************************************************************
*APPENDIX A7: REPORTING ON SAMPLE RESTRICTIONS
******************************************************************************

use "$data_output/reg_workerlevel_wID_5_unrestrict" if testing_med==1, clear
gen RNmgr = (Nmgrs<2)
codebook recruiter_id
codebook recruiter_id if RNmgr==1
tab RNmgr

gen exceptonly = (numhire_g==0 & numhire_y==0 & numhire_r!=0 & (numapp_g!=0 | numapp_y!=0))
replace exceptonly = 1 if numhire_g==0 & numhire_y!=0 & numapp_g!=0
codebook poolid
codebook poolid if exceptonly==1
tab exceptonly

gen low = (npools_rec==1)
codebook recruiter_id
codebook recruiter_id if low==1
tab low

gen Mpool_R = (cut2EX_viol_3_R==.)
codebook recruiter_id 
codebook recruiter_id if Mpool_R==1
sum Mpool_R

gen Mpool = (cut2EX_viol_3==.)
codebook poolid 
codebook poolid if Mpool==1
sum Mpool

bysort location: gen Nhires = _N
gen innit = (Nhires>50)
codebook location if innit==1
tab innit
drop Nhires innit

***CUMULATIVE RESTRICTIONS
use "$data_output/reg_workerlevel_wID_5_unrestrict" if testing_med==1, clear
gen RNmgr = (Nmgrs<2)
codebook recruiter_id
codebook recruiter_id if RNmgr==1
tab RNmgr
keep if RNmgr==0

*pools with no exception hires
gen exceptonly = (numhire_g==0 & numhire_y==0 & numhire_r!=0 & (numapp_g!=0 | numapp_y!=0))
replace exceptonly = 1 if numhire_g==0 & numhire_y!=0 & numapp_g!=0
codebook poolid
codebook poolid if exceptonly==1
tab exceptonly
keep if exceptonly==0

**observations to managers that do not have at least 2 pools
gen low = (npools_rec==1)
codebook recruiter_id
codebook recruiter_id if low==1
tab low
drop if low==1

**managers with missing exception rate
gen Mpool_R = (cut2EX_viol_3_R==.)
codebook recruiter_id 
codebook recruiter_id if Mpool_R==1
sum Mpool_R
drop if Mpool_R==1

assert inexceptionregs2==1

**get location > 50 restriction on whole sample
keep emp_id1 clientID
duplicates drop
tempfile innit
save `innit', replace
use "$data_output/reg_workerlevel_wID_5_unrestrict" , clear
merge 1:1 emp_id1 clientID using `innit'
keep if testing_med==0 | _merge==3
***locations that do not have at least 50 obs
bysort location: gen Nhires = _N
gen innit = (Nhires>50)
codebook location
codebook location if innit==1
tab innit
keep if innit==1
drop Nhires innit

log close
