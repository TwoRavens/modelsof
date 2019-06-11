clear
clear mata
set more off
set matsize 11000
set mem 700m
pause on

global path = ""
cd "$path"
global data_output = ""
global working_econ = ""
global log = ""
global output = ""
global raw = ""
global working = ""
global tables = ""
global graphs = ""


capture log close
log using "$log/step3_create_regfile_29.log", replace


******************************************************************************
*MAKE VERSION OF POOL INDIV FOR THE HIRED WORKERS ONLY
*NOTE THAT FOR THE COMPARING EXCEPTIONS VS. PASSED UPS USING APPLICATION COHORT EFFECTS WE NEED TO START FROM pool_indiv_3 AND LOOK AT APPLICATION EFFECTS.  
******************************************************************************
use "$working/pool_indiv_3", clear
keep if hired==1

capture drop tag
duplicates tag employeeID recruiter_id location hire_month, gen(tag)
tab tag
assert tag==0
drop tag
save "$working/temp", replace


******************************************************************************
*MAKE REGRESSION SAMPLE FOR HIRED WORKERS ONLY (FOR LOOKING AT DURATION)
******************************************************************************

use "$working/clean_hiredworkers_nost_2", clear

assert hired==1
count if dur==.
count

gen event_month=hire_month
merge m:1 employeeID recruiter_id location event_month using "$working/temp"
drop if _merge==2
ren _merge indivpoolmatch
tab indivpoolmatch
recode indivpoolmatch 1=0 3=1

*MATCH ALL POST datafirm WORKERS TO THE POOL THEY WERE HIRED FROM
merge m:1 recruiter_id location event_month using "$working/pool_level_3"
drop if _merge==2

ren _merge poolmatch
tab poolmatch
recode poolmatch 1=0 3=1
tab post_datafirm poolmatch

assert location!=.
assert post_datafirm!=.
capture drop helper
bysort location: egen helper = mean(post_datafirm)
tab location if helper==1
drop helper


******************************************************************************
*MAKE SAMPLE RESTRICTIONS
******************************************************************************

bys location: egen helper=nvals(recruiter_id event_month)
bys location: egen numpools=max(helper)
drop helper
tab numpools, missing
gen res_numpools=(numpools>10 & numpools!=.)
tab res_numpools

gen scored_apps = numapp_g + numapp_y + numapp_r
gen scored_hires = numhire_g + numhire_y + numhire_r
sum scored_apps scored_hires, d

gen res_poolsize = (scored_apps>=3 & scored_apps!=.)
gen res_hiresize = (scored_hires>=2 & scored_hires!=.)
gen res_poolsize_noss=(res_poolsize==1 & stock_sampled==0)

gen keepmed=((recruiter_id!=9999 & testing_med==1) | testing_med==0)
gen keepany=((recruiter_id!=9999 & testing_any==1) | testing_any==0)

tab keepmed keepany

keep if keepmed==1
keep if keepany==1
drop keepmed keepany
count

assert poolmatch<=1
count

gen keepmed=((poolmatch==1 & testing_med==1) | testing_med==0)
gen keepany=((poolmatch==1 & testing_any==1) | testing_any==0)

tab keepmed keepany
keep if keepmed==1 
keep if keepany==1
drop keepmed keepany

count
tab res_poolsize if testing_med==1
gen keepmed=((res_poolsize==1 & testing_med==1) | testing_med==0)
gen keepany=((res_poolsize==1 & testing_any==1) | testing_any==0)

tab keepmed keepany
keep if keepmed==1 
keep if keepany==1
drop keepmed keepany

gen share_green = numapp_g/(numapp_g + numapp_y + numapp_r)
gen Mtest = (appscore=="")

label var poolmatch "Hire matched to an app pool"
label var exception "Hired above applicant with better score"
label var numpools "Number of app pools (with >=1 hire) at this location"
label var res_numpools "Location has >10 pools"
label var res_poolsize "Pool has >=3 apps in play"
label var res_hiresize "Pool as >=2 hires"

save "$working/temp2", replace

******************************************************************************
*CREATE CLEAN EXCEPTION RATE VARIABLES -- POOL LEVEL
******************************************************************************
use "$working/temp2", clear

*COLLAPSE TO POOL LEVEL
keep recruiter_id location hire_month EX* testing_med scoreapp viol
duplicates drop

duplicates tag recruiter_id location hire_month, gen(tag)
tab tag
assert tag==0
drop tag

***EXCEPTION RATE (STANDARDIZE ACROSS ALL POOLS) AND MAKE HI LO
foreach var of varlist EX_* scoreapp viol {
replace `var'=. if testing_med==0
sum `var', d
	local median = r(p50)
	local mean = r(mean)
	local sd = r(sd)
	gen STD`var' = (`var'-`mean')/`sd'
	gen HI`var' = (`var'>=`median' & `var'!=.)
}

save "$working/temp_RLM", replace



******************************************************************************
*CREATE CLEAN EXCEPTION RATE VARIABLES -- MANAGER LEVEL
******************************************************************************
use "$working/temp2", clear
keep if testing_med==1

capture drop temp
bysort location: egen temp = nvals(recruiter_id) if testing_med==1
bysort location: egen Nmgrs = max(temp)
sum Nmgrs, d
keep if Nmgrs>=2

bys recruiter_id: egen npools_rec=nvals(poolid)

gen trimEX_viol_3=EX_viol_3 if EX_viol_3<1
gen restrict1 = (numhire_g==0 & numhire_y==0)
replace restrict1 = 1 if npools_rec==1
gen cut1EX_viol_3 = EX_viol_3 if restrict1==0
***no greens or yellows hired but at least 1 had applied, and reds hired
gen restrict2 = (numhire_g==0 & numhire_y==0 & numhire_r!=0 & (numapp_g!=0 | numapp_y!=0))
**no greens hired but greens had applied and yellows hired
replace restrict2 = 1 if numhire_g==0 & numhire_y!=0 & numapp_g!=0
***at least 2 pools per mgt
replace restrict2 = 1 if npools_rec==1
gen cut2EX_viol_3 = EX_viol_3 if restrict2==0
gen cut2EX_viol_ran = EX_viol_ran if restrict2==0
gen cut2EX_score_ran2 = EX_score_ran2 if restrict2==0
gen cut2EX_score_max2 = EX_score_max2 if restrict2==0

*COLLAPSE TO MANAGER LEVEL
collapse trimEX* cut*EX* EX* viol scoreapp npools_rec, by(recruiter_id)
duplicates drop

duplicates tag recruiter_id, gen(tag)
tab tag
assert tag==0
drop tag

***EXCEPTION RATE (STANDARDIZE ACROSS ALL MANAGERS POST TESTING) AND MAKE HI LO
foreach var of varlist trimEX* cut*EX* EX_* scoreapp viol {
sum `var', d
	local median = r(p50)
	local mean = r(mean)
	local sd = r(sd)
	gen STD`var'_R = (`var'-`mean')/`sd'
	gen HI`var'_R = (`var'>=`median' & `var'!=.)
	
	ren `var' `var'_R
}

save "$working/temp_R", replace

******************************************************************************
*CREATE CLEAN EXCEPTION RATE VARIABLES -- LOCATION LEVEL
******************************************************************************
use "$working/temp2", clear
keep if testing_med==1

*CONSTRUCT NUMBER OF MANAGERS 
capture drop temp
bysort location: egen temp = nvals(recruiter_id) if testing_med==1
bysort location: egen Nmgrs = max(temp)
sum Nmgrs, d
keep if Nmgrs>=2

bys recruiter_id: egen npools_rec=nvals(poolid)

gen trimEX_viol_3=EX_viol_3 if EX_viol_3<1
gen restrict1 = (numhire_g==0 & numhire_y==0)
replace restrict1 = 1 if npools_rec==1
gen cut1EX_viol_3 = EX_viol_3 if restrict1==0
***no greens or yellows hired but at least 1 had applied, and reds hired
gen restrict2 = (numhire_g==0 & numhire_y==0 & numhire_r!=0 & (numapp_g!=0 | numapp_y!=0))
**no greens hired but greens had applied and yellows hired
replace restrict2 = 1 if numhire_g==0 & numhire_y!=0 & numapp_g!=0
***at least 2 pools per mgt
replace restrict2 = 1 if npools_rec==1
gen cut2EX_viol_3 = EX_viol_3 if restrict2==0
gen cut2EX_viol_ran = EX_viol_ran if restrict2==0
gen cut2EX_score_ran2 = EX_score_ran2 if restrict2==0
gen cut2EX_score_max2 = EX_score_max2 if restrict2==0


*COLLAPSE TO MANAGER LEVEL
collapse trimEX* cut*EX* EX* viol scoreapp, by(location)
duplicates drop

duplicates tag location, gen(tag)
tab tag
assert tag==0
drop tag

***EXCEPTION RATE (STANDARDIZE ACROSS ALL LOCATIONS POST TESTING) AND MAKE HI LO
foreach var of varlist  trimEX* cut*EX* EX_* scoreapp viol {
sum `var', d
	local median = r(p50)
	local mean = r(mean)
	local sd = r(sd)
	gen STD`var'_L = (`var'-`mean')/`sd'
	gen HI`var'_L = (`var'>=`median' & `var'!=.)
	
	ren `var' `var'_L
}

save "$working/temp_L", replace

******************************************************************************
*MERGE BACK INTO INDIV FILE
******************************************************************************
use "$working/temp2", clear
assert green + yellow + red==1 if testing_med==1 & appscore!=""

merge m:1 recruiter_id location hire_month using "$working/temp_RLM"
assert _merge==3
drop _merge

merge m:1 recruiter_id using "$working/temp_R"
assert _merge!=2
drop _merge

merge m:1 location using "$working/temp_L"
assert _merge!=2
drop _merge


*MAKE INTERACTIONS SO THAT VARIABLES ARE SET TO 0 PRE TESTING
foreach var of varlist numapp_g numapp_y numapp_r share_green green yellow red Mtest *exception* STD* HI* EX* scoreapp viol {
	gen `var'_med = `var'
	replace `var'_med=0 if testing_med==0
	sum `var'_med, d
}

count if HIscoreapp_L==.

******************************************************************************
*CLEAN OUTCOME VARIABLES
******************************************************************************
capture drop ldur_restrict* dur_restrict ldur

gen leave_new=(term_date!=.)
gen censored = 1- leave_new

*GENERATE RESTRICTED VARIABLES
gen ldur_restrict=log(dur) if leave_new==1
gen dur_restrict=dur if leave_new==1

capture drop month*restrict
foreach month in 1 3 6 12 24 {
	gen month`month'_restrict = month`month' if hire_month + `month'<=data_end_c
	replace month`month'_restrict=. if dur==.
}


*GENERATE UNRESTRICTED VARIABLES
gen ldur=log(dur)

*Just flagging that these variables already exist
d dur month1 month12 

replace numapp_g=0 if numapp_g==.
replace numapp_y=0 if numapp_y==.
replace numapp_r=0 if numapp_r==.
replace share_green=0 if share_green==.

sort employeeID location recruiter_id hire_month

*MERGE IN LOCATION IDS WITH ECONOMIC DATA
gen hire_year=year(hire_date)
tab hire_year


tab location, gen(locdum_)
tab hire_month, gen(monthdum_)
egen temp=group(clientID hire_year_only)
tab temp, gen(clientyeardum_)
drop temp
foreach var of varlist locdum_* {
	gen ym`var'=`var'*hire_month
}

*DECILES OF NUMAPP
xtile group_numapp_g=numapp_g, nq(10)
xtile group_numapp_y=numapp_y, nq(10)
xtile group_numapp_r=numapp_r, nq(10)
tab group_numapp_g, gen(gnumappgdum_)
tab group_numapp_y, gen(gnumappydum_)
tab group_numapp_r, gen(gnumapprdum_)

save "$working/clean_hires_pools_nost_10", replace


******************************************************************************
*CLEAN UP CLEAN POOL DATA FOR ANALYSIS
******************************************************************************
save $working/temp2, replace
 
use "$working/clean_hires_pools_nost_10", clear

*DROP IF DURATION IS MISSING
count if dur==.
drop if dur==.

** Make the positions: creates "position_clean" and "position_short"
do "$Do/zz_make_positions.do"

tab position_short if ~mi(hire_date)

gen c = clientID
gen l = location
egen client_year = group(clientID hire_year)


***pool controls
foreach var in g y {
	gen share_`var' = numapp_`var'/(numapp_g + numapp_y + numapp_r)
}
gen hire_rate = (numhire_g + numhire_y + numhire_r + numhire_Mcolor)/(numapp_g + numapp_y + numapp_r + numapp_Mcolor)

***demean variables
foreach var in share_g share_y numapp hire_rate {
	sum `var' if testing_med==1
	gen NORM`var' = `var' - r(mean) if testing_med==1
}

*DECILES FOR POOL CONTROLS
foreach var in share_g share_y numapp hire_rate {
		xtile group_`var' = `var' if testing_med==1, nq(10)
		tab group_`var' if testing_med==1, gen(APC`var'dum_)
	}

save $working/temp, replace


***create working economic datasets
use "$working_econ/ACS_empstats_locid", clear
ren location_id location
ren year hire_year
save "$working/ACS_empstats_locid", replace
use "$working_econ/state_unemps_monthly_locid", clear
ren location_id location
save "$working/state_unemps_monthly_locid", replace
use "$working_econ/state_emps_monthly_locid", clear
ren location_id location
save "$working/state_emps_monthly_locid", replace
use "$working_econ/Foreign_locid", clear
ren location_id location
ren year hire_year
save "$working/Foreign_locid", replace
use "$working_econ/Unusual_locid", clear
ren location_id location
ren year hire_year
**bring in national unemployment rates
merge m:1 hire_year using "$working_econ/nat_unemps"
***data include 2000 and 2014 where we won't have hires
tab hire_year if _merge==1
drop if _merge==1
drop _merge
save "$working/Unusual_locid", replace

*CREATE FIXES FOR DURATION VARIABLES
use $working/temp, clear

**bring in local labor market variables and check original resuults
merge m:1 location hire_year using  "$working/ACS_empstats_locid"
drop if _merge==2
gen M_economicdata = (_merge==1)
drop _merge
merge m:1 location hire_month using "$working/state_unemps_monthly_locid"
drop if _merge==2
assert _merge==1 if M_economicdata==1
assert _merge==3 if M_economicdata==0
bysort location year: egen helper = sd(unempCPS)
sum helper
drop helper
drop _merge
merge m:1 location hire_month using "$working/state_emps_monthly_locid"
drop if _merge==2
assert _merge==1 if M_economicdata==1
assert _merge==3 if M_economicdata==0
drop _merge
merge m:1 location hire_year using "$working/Foreign_locid"
assert _merge!=3 if M_economicdata==0
codebook location if _merge==3
drop if _merge==2
gen M_foreign = (_merge==1)
drop _merge
merge m:1 location hire_year using "$working/Unusual_locid"
assert _merge!=3 if M_economicdata==0 | M_foreign==0
drop if _merge==2
gen M_unusual = (_merge==1)
drop _merge

gen test = (1-M_economicdata) + (1-M_foreign) + (1-M_unusual)
assert test==1
drop test

foreach var of varlist unempACS_dropout unempACS_hs unempACS_sc unempACS_college_plus {
gen fill_`var'=`var'
replace fill_`var'=0 if M_foreign==0
}

gen fill_unemp_foreign = unempWB/100 if M_foreign==0
replace fill_unemp_foreign = 0 if M_foreign==1

foreach ed in dropout hs sc college_plus {
	replace fill_unempACS_`ed' = nat_unemp_`ed'/100 if M_unusual==0
	assert fill_unempACS_`ed'!=.
}
sum fill_*
assert fill_unemp_foreign!=0 if M_foreign==0
assert fill_unempACS_dropout!=0 if M_economicdata==0 | M_unusual==0

gen fill_local = (M_economicdata==0)
gen fill_unusual = (M_unusual==0)
assert M_foreign==0 if fill_local==0 & fill_unusual==0

 

tab position_short, gen(posdum_)


*CONSTRUCT NUMBER OF MANAGERS 
capture drop temp
bysort location: egen temp = nvals(recruiter_id) if testing_med==1
bysort location: egen Nmgrs = max(temp)
sum Nmgrs, d

bysort location: egen hastesting = max(testing_med)
tab hastesting
assert hastesting!=.
assert Nmgrs!=. if hastesting==1
assert hastesting==0 if Nmgrs==.

**GEN VARIABLE FOR EXCEPTION REGS
gen restrict1 = (numhire_g==0 & numhire_y==0)
replace restrict1 = 1 if  npools_rec==1
gen restrict2 = (numhire_g==0 & numhire_y==0 & numhire_r!=0 & (numapp_g!=0 | numapp_y!=0))
**no greens hired but greens had applied and yellows hired
replace restrict2 = 1 if numhire_g==0 & numhire_y!=0 & numapp_g!=0
***at least 2 pools per mgt
replace restrict2 = 1 if npools_rec==1

gen inexceptionregs1 = ((restrict1==0 & STDcut1EX_viol_3_R!=. & testing_med==1 & Nmgrs>=2) | testing_med==0)
gen inexceptionregs2 = ((restrict2==0 & STDcut2EX_viol_3_R!=. & testing_med==1 & Nmgrs>=2) | testing_med==0)

gen cut1EX_viol_3 = EX_viol_3 if inexceptionregs1==1
gen cut2EX_viol_3 = EX_viol_3 if inexceptionregs2==1

save "$working/reg_workerlevel_6", replace

keep if inexceptionregs2==1
save "$working/reg_workerlevel_6_restrict", replace


******************************************************************************
*SET UP PASSED OVER
******************************************************************************
use "$working/reg_workerlevel_6_restrict", clear
keep location recruiter_id hire_month testing_med 
duplicates drop
save $working/temp, replace

use "$working/pool_indiv_3", clear

*DROP IF DURATION IS MISSING
count if dur==.
drop if dur==.

** Make the positions: creates "position_clean" and "position_short"
do "$Do/zz_make_positions.do"


tab position_short if ~mi(hire_date)

*CREATE CENSORED VARIABLES
gen leave_new=(term_date!=.)
gen censored = 1-leave_new

gen hire_year = year(hire_date)
**bring in local labor market variables and check original resuults
merge m:1 location hire_year using  "$working/ACS_empstats_locid"
drop if _merge==2
gen M_economicdata = (_merge==1)
drop _merge
merge m:1 location hire_month using "$working/state_unemps_monthly_locid"
drop if _merge==2
assert _merge==1 if M_economicdata==1
assert _merge==3 if M_economicdata==0
bysort location year: egen helper = sd(unempCPS)
sum helper
drop helper
drop _merge
merge m:1 location hire_month using "$working/state_emps_monthly_locid"
drop if _merge==2
assert _merge==1 if M_economicdata==1
assert _merge==3 if M_economicdata==0
drop _merge
merge m:1 location hire_year using "$working/Foreign_locid"
assert _merge!=3 if M_economicdata==0
codebook location if _merge==3
drop if _merge==2
gen M_foreign = (_merge==1)
drop _merge
merge m:1 location hire_year using "$working/Unusual_locid"
assert _merge!=3 if M_economicdata==0 | M_foreign==0
drop if _merge==2
gen M_unusual = (_merge==1)
drop _merge


**economic data for all locations
gen test = (1-M_economicdata) + (1-M_foreign) + (1-M_unusual)
assert test==1
drop test

foreach var of varlist unempACS_dropout unempACS_hs unempACS_sc unempACS_college_plus {
gen fill_`var'=`var'
replace fill_`var'=0 if M_foreign==0
}

gen fill_unemp_foreign = unempWB/100 if M_foreign==0
replace fill_unemp_foreign = 0 if M_foreign==1

foreach ed in dropout hs sc college_plus {
	replace fill_unempACS_`ed' = nat_unemp_`ed'/100 if M_unusual==0
	assert fill_unempACS_`ed'!=.
}
sum fill_*
assert fill_unemp_foreign!=0 if M_foreign==0
assert fill_unempACS_dropout!=0 if M_economicdata==0 | M_unusual==0

gen fill_local = (M_economicdata==0)
gen fill_unusual = (M_unusual==0)
assert M_foreign==0 if fill_local==0 & fill_unusual==0

 

tab position_short, gen(posdum_)


*GET POOLS THAT MEET SAMPLE RESTRICTION, _merge==1 do not
capture drop _merge
merge m:1 location recruiter_id hire_month using $working/temp
drop if _merge==2
drop if _merge==1
drop _merge


tab location, gen(locdum_)
tab hire_month, gen(monthdum_)
egen client_year = group(clientID hire_year)
tab client_year, gen(clientyeardum_)
egen pool=group(location recruiter_id event_month)

***pool controls
foreach var in g y {
	gen share_`var' = numapp_`var'/(numapp_g + numapp_y + numapp_r)
}
gen hire_rate = (numhire_g + numhire_y + numhire_r + numhire_Mcolor)/(numapp_g + numapp_y + numapp_r + numapp_Mcolor)
gen numapp = numapp_g + numapp_y + numapp_r + numapp_Mcolor
***demean variables
foreach var in share_g share_y numapp hire_rate {
	sum `var' if testing_med==1
	gen NORM`var' = `var' - r(mean) if testing_med==1
}

*DECILES FOR POOL CONTROLS
foreach var in share_g share_y numapp hire_rate {
		xtile group_`var' = `var' if testing_med==1, nq(10)
		tab group_`var' if testing_med==1, gen(APC`var'dum_)
	}


save $working/reg_indiv_pool_6, replace


******************************************************************************
*CLEAN OUTPUT DATA
******************************************************************************

use $raw/outputmetric, clear
ren client_key clientID
save $working/temp_outputmetric, replace

use "$working/master_allworkers_long_1", clear
keep emp_id1 clientID location hire_date 
keep if hire_date!=.
keep if emp_id1!=.
duplicates drop

merge 1:m emp_id1 clientID using $working/temp_outputmetric
drop if _merge==2
drop _merge

gen Coutputmetric = outputmetric 
replace Coutputmetric = 36000 if outputmetric>36000 & outputmetric!=.
gen outputperhour_unres = 60/(Coutputmetric/60) 
gen outputperhour60 = 60/(Coutputmetric/60) if Coutputmetric>60

gen tenure = metric_date - hire_date
keep if tenure>0
gen weeks = floor(tenure/7)
gen months = floor(tenure/30)
gen metric_month = ym(year(metric_date), month(metric_date))
xtile Dcount = outputmetric_count, nquantiles(10)
xtile Qweeks = weeks, nquantiles(5)
xtile Vcount = outputmetric_count, nquantiles(20)

qui tab Dcount, gen(outputmetric_count_dum)

*TENURE BASED OUTPUT PER HOUR
foreach type of numlist 60 {
foreach i of numlist 1 3 6 9 12 15 18 21 24 {
gen output`type'_`i'mo = outputperhour`type' if months<=`i'
}
}

collapse outputperhour* output*_*mo outputmetric_count outputmetric_count_dum*, by(clientID emp_id1)
save "$working/outputmetric_indiv_2", replace


******************************************************************************
*ID CROSSWALK
******************************************************************************

use "$working/master_allworkers_long_1", clear
keep location recruiter_id employeeID emp_id1 clientID
duplicates drop
bys location recruiter_id employeeID: assert _n==_N
save $working/idfile, replace

use "$working/reg_workerlevel_6_restrict", clear
merge 1:1 location recruiter_id employeeID using $working/idfile
assert _merge!=1
drop if _merge==2
drop _merge

*MERGE IN OUTPUT
merge m:1 emp_id1 clientID using "$working/outputmetric_indiv_2"
drop if _merge==2
assert _merge==1 if emp_id1==.
gen Moutputmetric = (_merge==1)
drop _merge

d position_short

****restrict to locations with at least 50 hires
bysort location: gen Nhires = _N
bysort location: gen counter = _n
gen innit = (Nhires>=50)
display "share of observations meeting N hires within location restriction"
tab innit
display "share of locations meeting N hires within location restriction"
tab innit if counter==1
keep if innit==1
drop Nhires counter innit
save "$working/reg_workerlevel_wID_7", replace

***unrestricted

use "$working/reg_workerlevel_6", clear
merge 1:1 location recruiter_id employeeID using $working/idfile
assert _merge!=1
***_merge=2 are mainly not hired workers and also those that don't meet our sample criteria
drop if _merge==2
drop _merge

merge m:1 emp_id1 clientID using "$working/outputmetric_indiv_2"
drop if _merge==2
assert _merge==1 if emp_id1==.
gen Moutputmetric = (_merge==1)
drop _merge

save "$working/reg_workerlevel_wID_5_unrestrict", replace







