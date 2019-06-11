
clear
clear mata
set more off
set matsize 11000
set mem 700m
pause on

* Set paths here
global path = ""
cd "$path"
global log = ""
global output = ""
global raw = ""
global working = ""
global tables = ""
global graphs = ""


capture log close
log using "$log/step1_data_cleaning_21.log", replace

*******************************************************************************
**Initial cleaning
*******************************************************************************
use "$raw/Attrition_base", clear

* Mask some variable names for confidentiality
do "$Do/zz_rename.do"


**EMPLOYEE IDs				

*EMPLOYEE KEY
assert employee_key==. if hire_date==.
drop if hire_date==. & emp_id1!=.
assert emp_id1==. if hire_date==.

count if hire_date!=. & employee_key==.
assert emp_id1!=. if employee_key==. & hire_date!=.
count if hire_date!=.

**when non-missing employee key is unique
duplicates tag employee_key, gen(tag)
tab tag 
assert tag==0 if employee_key!=.
drop tag

*EMP_ID1
assert emp_id1==. if hire_date==.
count if hire_date!=. & emp_id1==.
count if hire_date!=.

*datafirm_ID1
**unique for non-hired people
duplicates tag datafirm_id1 hire_date, gen(tag)
tab tag if datafirm_id1!=. & hire_date==.
assert tag==0 if datafirm_id1!=. & hire_date==.
drop tag
**datafirm_id1 missing for 2 non-hired people
gen test = (datafirm_id1==. & hire_date==.)
tab test
list if test==1
assert score=="" if test==1
assert created_date==. if test==1
drop if test==1
drop test

codebook datafirm_id1 if hire_date!=.

gen applicant_id=datafirm_id1

********************************************************************************
**Generate a unique non-missing person ID				      **
**	1. emp_id1 client_key if non-missing					      **
**	2. employee_key if hired and #1 missing		      			  **
**	3. datafirm_id1 if missing (i.e., not hired)			      **
********************************************************************************

duplicates tag emp_id1 client_key, gen(dup)
egen helper = group(emp_id1 client_key) if ~mi(hire_date)
egen helper2 = group(employee_key) if dup==1
egen helper3 = group(datafirm_id1) if mi(hire_date)

sum helper
local top_val = r(max)
gen employeeID = helper if dup==0
replace employeeID = helper2 + `top_val'+1 if hire_date!=. & employeeID==.
assert employeeID!=. if hire_date!=.
assert employeeID==. if hire_date==.
sum employeeID
local top_val = r(max)
replace employeeID = helper3 + `top_val' + 1 if hire_date==.

assert employeeID!=.
duplicates tag employeeID, gen(tag)
assert tag==0
drop tag helper helper2 helper3

label var employeeID "unique, non-missing employee ID" 


*******************************************************************************
**CLIENT IDs			
******************************************************************************

*CLIENT KEY
assert client_key!=. if hire_date!=.
count if client_key!=. & hire_date==.
count if client_key==.

gen clientID = client_key
assert clientID!=.

*******************************************************************************
**END USER CLIENT IDs			
**use the two variables client1_nbr and client2_nr
******************************************************************************

replace client1_nbr = subinstr(client1_nbr,"Client ","",.) 
destring client1_nbr, replace
tab client1_nbr

replace client2_nbr = subinstr(client2_nbr,"Client ","",.) 
destring client2_nbr, replace
tab client2_nbr

**client2 is almost always missing if client1 is, but not the reverse
sum client2_nbr if client1_nbr==.
sum client1_nbr if client2_nbr==.

**there is almost always a unique mapping
unique client1_nbr, by(client2_nbr) gen(test)
tab test if client1_nbr!=. & client2_nbr!=.
drop test

**client1_nbr is the main client and sometimes there is a second client
gen end_user_client = client1_nbr
replace end_user_client = client2_nbr if client1_nbr==.

gen secondary_end_user_client = client2_nbr
replace secondary_end_user_client = 99999 if secondary_end_user_client==. & client1_nbr!=.

*******************************************************************************
*Create variables related to testing
*******************************************************************************

*generate appscore as maximum of all tests -- for app_pool

gen post_datafirm= (datafirm_id1!=.)

gen appscore=""
foreach var of varlist jscore_*_clr {
	replace appscore = "r" if `var'=="RED"
}
foreach var of varlist jscore_*_clr {
	replace appscore = "y" if `var'=="YELLOW"
}
foreach var of varlist jscore_*_clr {
	replace appscore = "g" if `var'=="GREEN"
}

* Fill in ~500 missing observations for one firm
replace appscore = "r" if score=="RED" & mi(appscore)
replace appscore = "y" if score=="YELLOW" & mi(appscore)
replace appscore = "g" if score=="GREEN" & mi(appscore)

* Check that appscore is non-missing.
foreach var of varlist score jscore_*_clr {
	assert appscore!="" if `var'!=""
}


tab score, missing
tab appscore, missing

gen hasscore = (appscore!="")
tab hasscore post_datafirm
assert hasscore==0 if post_datafirm==0
tab hasscore post_datafirm
tab hasscore post_datafirm if hire_date!=.

*******************************************************************************
*LOCATION VARIABLES AND LOCATIONS CROSSWALK
*******************************************************************************
codebook *loc*
gen hired = (hire_date!=.)
gen terminated = (TERM==1)
bysort location_nbr: egen Nhires_loc = sum(hired)
bysort location_nbr: egen Nterm_loc = sum(terminated)
bysort location_nbr: egen Nscores_loc = sum(hasscore)
sum N*
assert Nhires_loc>=1 & Nhires_loc!=. if location_nbr!=""
gen tag = (Nterm_loc==0 & Nscores_loc==0)
tab location_nbr if tag==1
assert tag==0 if post_datafirm==1 & location_nbr!=""

***destring the ones that need it
destring emp_location_id, replace force
replace emp_location_id=. if emp_location_id==0

**location_nbr
replace location_nbr = subinstr(location_nbr,"Location ","",.) 
destring location_nbr, replace
tab location_nbr

**app_location_nbr
replace app_location_nbr = subinstr(app_location_nbr,"Application Location ","",.) 
destring app_location_nbr, replace
tab app_location_nbr

assert hire_date!=. if post_datafirm==0

***describe when IDs are missing
foreach var of varlist *loc* {
	display "`var'"
	gen temp = (`var'==.)
	display "`var' missing pre-datafirm"
	sum temp if post_datafirm==0
	display "`var' missing post-datafirm not hired"
	sum temp if post_datafirm==1 &  hire_date==.
	display "`var' missing post-datafirm hired"
	sum temp if post_datafirm==1 &  hire_date!=.
	drop temp
}

sum location_id app_location_id
cor location_id app_location_id
count if location_id!=. & app_location_id==.
count if location_id==. & app_location_id!=.
count if app_location_nbr!=. & location_id==. & app_location_id==.

gen location = app_location_id
replace location = location_id if location==.
assert app_location_nbr==. if location==.

assert location!=. if hire_date==.
count if location==. & datafirm_id1!=.

preserve
keep if post_datafirm==1 & hire_date!=.
collapse (count) obs=employeeID, by(location location_nbr)
assert obs!=0 & obs!=.
bysort location_nbr: gen LBK_per_nbr = _N
bysort location_nbr: gen counter_nbr = _n
bysort location: gen nbr_per = _N
bysort location: gen counter = _n

display "number of locations per location_nbr"
tab LBK_per_nbr if counter_nbr==1

display "number of location_nbrs per location"
tab nbr_per if counter==1

bysort location_nbr: egen tot_obs = sum(obs)
gen share_obs = obs/tot_obs
sort location_nbr counter_nbr
list obs share_obs location_nbr counter_nbr location if LBK_per_nbr==2
list obs share_obs location_nbr counter_nbr location if LBK_per_nbr==3
list obs share_obs location_nbr counter_nbr location if LBK_per_nbr==4

bysort location_nbr: egen biggest_share = max(share_obs)
display "summarize what share of data is in modal location when not all"
sum biggest_share if counter_nbr==1 & biggest_share<1, d
bysort LBK_per_nbr: sum biggest_share if counter_nbr==1
bysort LBK_per_nbr: count if biggest_share<=.5 & counter_nbr==1

gen thisone = (share_obs==biggest_share)
replace thisone = 0 if biggest_share<=.5
sort location_nbr counter_nbr
list obs share_obs biggest_share thisone location_nbr counter_nbr location in 1/100

bysort location_nbr: egen helper = sum(thisone)
assert helper<=1

display "number of location_nbrs that did not match"
count if helper==0 & counter_nbr==1
egen tot_obs_miss = sum(obs) if helper==0 & location_nbr!=.
sum tot_obs_miss
bysort location_nbr: egen totnotmatch = sum(helper)
tab helper
sum totnotmatch
tab location_nbr if totnotmatch==0
tab location_nbr if totnotmatch==0 [fw=obs]
keep if thisone==1

keep location_nbr location LBK_per_nbr
bysort location_nbr: gen counter = _N
assert counter==1
assert location_nbr!=. & location!=.
drop counter

ren location location_merge

tempfile location_mapping
save `location_mapping'
restore

merge m:1 location_nbr using `location_mapping' 

**non-hired applicants do not have location_nbrs
assert _merge==1 if hire_date==.

***non-matched hired applicants will be those whose location_nbr could not be mapped consistently to a location
tab _merge if hire_date!=.
tab _merge if hire_date!=. & post_datafirm==0
tab _merge if hire_date!=. & post_datafirm==1

tab _merge if hire_date!=.
tab _merge if hire_date!=. & tag==1

cor location_merge location

bysort location_nbr: egen helper = sd(location_merge)
assert helper==0 if location_nbr!=. & location_merge!=.

count if location!=location_merge & location!=. & location_merge!=.
count if location_merge!=. & hire_date!=. & post_datafirm==0
count if hire_date!=. & post_datafirm==0
count if location_merge==. & location!=. & hire_date!=. & post_datafirm==1

**assign location IDs to pre-datafirm obs
replace location = location_merge if hire_date!=. & post_datafirm==0
replace location = location_merge if hire_date!=. 

count if location!=.
count if location==.

capture drop helper
bysort location: egen helper = nvals(location_nbr) if location_nbr!=. & location!=. 
tab helper

***how many observations pre- and post- datafirm do we have by location?
preserve
collapse (count) obs=employeeID, by(location post_datafirm)
reshape wide obs, i(location) j(post_datafirm)

list

restore
capture drop obs
gen pre_datafirm = 1-post_datafirm
tab pre_datafirm
bysort location: egen obs = sum(pre_datafirm )
sum obs
tab location if obs==0, m
tab location_nbr if obs==0, m

count if location!=.
count if location!=. & pre_datafirm==1
count if location!=. & post_datafirm==1 & hire_date!=.
count if location!=. & post_datafirm==1 & hire_date==.
count if location==.

keep if location!=.

assert location!=. & clientID!=. & employeeID!=.

**variation across clients in location
bysort clientID: tab location

**variation within location in client
capture drop helper
bysort location: egen helper = sd(clientID)
sum helper, d
assert helper==0 if helper!=.
drop helper

tab recruiter_id if post_datafirm==1, m
replace recruiter_id=9999 if recruiter_id==. & post_datafirm==1
assert recruiter_id==. if post_datafirm==0

save "$working/master_allworkers_long_1", replace


*MAKE SHORT VERSION
use "$working/master_allworkers_long_1", clear
keep term* hire_date TERM state educational created_date typing* dur score hired terminated recruiter_id post_datafirm location employeeID clientID end_user_client* secondary_end* appscore hasscore applicant_id position_type
save "$working/master_allworkers_1", replace


****************************************************************************
*MAKE INDICATOR FOR INTRODUCTION OF datafirm 
*TESTING = 1 IF A PERSON IS HIRED POST TESTING
****************************************************************************
use "$working/master_allworkers_1", clear

**************************************************************************
**RESTRICTION: Use only hired people
**************************************************************************
keep if hire_date!=.

gen hire_month = ym(year(hire_date),month(hire_date))

gen hire_month_only=month(hire_date)
gen hire_year_only=year(hire_date)

*GENERATE EARLIEST DATE SOMEONE STARTS TESTING
capture drop helper
gen helper = hire_month if hasscore==1
bys location: egen start_testing_month_any = min(helper)

tab location if start_testing_month_any==.
assert start_testing_month_any!=.

gen testing_any = (hire_month>=start_testing_month_any)
assert testing_any==0 if start_testing_month_any==.
assert hire_month>=start_testing_month_any if testing_any==1
assert hire_month<start_testing_month_any if testing_any==0

*Started_test=. if no one at the location has an datafirm_id.  
*Locations for which noone ever has an datafirm id are coded as no testing.

*variation in testing dates within client
bysort clientID: tab start_testing_month_any
drop helper

*GENERATE EARLIEST DATE THAT MEDIAN PERSON IN A LOCATION HAS TESTING
bys location hire_month: egen temp=median(hasscore)
tab temp
gen helper = hire_month if temp==1
*earliest date that median person has testing
bys location: egen start_testing_month_med=min(helper)
count if start_testing_month_med==.

gen testing_med=(hire_month>=start_testing_month_med)
assert testing_med==0 if start_testing_month_med==.

*variation in testing dates within client
bysort clientID: tab start_testing_month_med

drop helper temp

*GENERATE VARS IF LOCATION EVER STARTS TESTING
assert start_testing_month_any!=.
gen everstart_med=(start_testing_month_med!=.)

tab everstart_med

****************************************************************************
*GENERATE CONTROL VARIABLES
****************************************************************************
**make values for missings
gen Mend_use_cl = (end_user_client==.)
replace end_user_client = 99998 if Mend_use_cl==1
replace secondary_end_user_client = 99998 if Mend_use_cl==1

gen green=(appscore=="g")
replace green=. if appscore==""
gen yellow=(appscore=="y")
replace yellow=. if appscore==""
gen red=(appscore=="r")
replace red=. if appscore==""

****************************************************************************
*GENERATE LHS VARIABLES
****************************************************************************
count if dur==.
count if dur==0
*so ldur exists only for people with durations

gen ldur = log(dur)
assert ldur==. if dur==.

assert TERM!=.

gen leave = (TERM==1)
gen two_weeks = (dur>=14)
foreach num of numlist 1 2 3 6 12 24 {
	gen month`num' = (dur>=`num'*30 & dur!=.)
}

save "$working/master_hiredworkers_2", replace


****************************************************************************
*CREATE SAMPLE RESTRICTIONS
*******************************************************************************

use "$working/master_hiredworkers_2", clear

count if TERM!=1 & term_date!=.
assert hire_date!=.
assert clientID!=.
assert location!=.

*NO HIRES, BY CLIENT
bysort clientID: egen numhires_ever_c = sum(hired)
sum numhires_ever_c, d
tab clientID
tab clientID if numhires_ever_c<=1
assert numhires_ever_c!=0 & numhires_ever_c!=. 

*NO TERMINATIONS, BY CLIENT
bysort clientID: egen numterms_ever_c = sum(TERM)
sum numterms_ever_c, d
tab clientID
tab clientID if numterms_ever_c<=1
assert numterms_ever_c!=0 & numterms_ever_c!=.

*NO HIRES, BY LOCATION
bysort location: egen numhires_ever_l = sum(hired)
sum numhires_ever_l, d
tab location
tab location if numhires_ever_l<1
assert numhires_ever_l!=0 & numhires_ever_l!=.

*NO TERMS, BY LOCATION
bysort location: egen numterms_ever_l = sum(TERM)
sum numterms_ever_l
tab location if numterms_ever_l<1
count if numhires_ever_l==0
tab hire_month_only if numhires_ever_l==0
tab hire_year_only if numhires_ever_l==0

assert numterms_ever_l!=0 & numterms_ever_l!=.

drop numhires_ever* numterms_ever*

gen year = year(term_date)
tab year if term_date!=.
assert year>=2001
drop year

* This drops individuals hired before 2001. However, the same people
* would get eliminated in the stock sampling restriction below.
tab hire_year_only
drop if hire_year_only<=2000

*STOCK SAMPLING
gen term_month = ym(year(term_date),month(term_date))
assert term_month==. if term_date==.
bysort clientID: egen data_start_c = min(term_month)
assert data_start_c!=.
tab data_start_c

bysort location: egen data_start_l = min(term_month)
assert data_start_l!=.

*AT THE CLIENT LEVEL
gen stock_sampled = (hire_month<data_start_c)
tab hire_year_only if stock_sampled==1
gen stock_sampled_l = (hire_month<data_start_l)

tab stock_sampled stock_sampled_l
assert stock_sampled_l==1 if stock_sampled==1

tab stock_sampled if testing_any==1
tab stock_sampled if testing_med==1

replace stock_sampled = 0 if testing_any==1 | testing_med==1

tab stock_sampled

**************************************************************************
**RESTRICTION: stock_sampled==0
**************************************************************************
drop if stock_sampled==1

****************************************************************************
*TIME PRE AND POST TESTING, NUMBER OF OBS PRE AND POST TESTING
*******************************************************************************

count if start_testing_month_any==.
assert testing_any==1 if hire_month>=start_testing_month_any & start_testing_month_any!=.
assert testing_any==0 if hire_month<start_testing_month_any

*GENERATE INDICATORS FOR WORKERS BEING PRE AND POST
assert start_testing_month_any!=.
foreach s in any med {
	gen pre_`s' =(hire_month<start_testing_month_`s')
	assert pre_`s'==1 if start_testing_month_`s'==.
	gen post_`s' = (hire_month>=start_testing_month_`s')
	assert post_`s'==0 if start_testing_month_`s'==.
	assert hire_month!=.
}

*NUMBER OF OBS PRE AND POST TESTING, BY LOCATION
foreach s in any med {
	foreach var of varlist pre_`s' post_`s' {
		bys location: egen nobs_`var'=total(`var')
	}
}

foreach var of varlist hire_month  {
	bys location: egen first_`var'=min(`var')
	bys location: egen last_`var'=max(`var')
}

foreach s in any med {
	gen time_pre_`s' = (start_testing_month_`s' - first_hire_month)
	assert time_pre_`s'>=0
	gen time_post_`s' = (last_hire_month - start_testing_month_`s')
		assert time_post_`s'>=0
}

drop first* last* 

bys location: egen test=nvals(testing_any)
tab test
assert test==2 if time_pre_any>0 & time_post_any>0

*******************************************************************************
**data end date:
**	latest hire or termination by client			    	    
*******************************************************************************
bysort clientID: egen date1 = max(hire_date)
bysort clientID: egen date2 = max(term_date)
assert date1!=. & date2!=.
gen data_end_c = ym(year(date1),month(date1))
replace data_end_c = ym(year(date2),month(date2)) if date2>date1

foreach s in any med {

	*These are ppl who hired someone before testing started
	gen res_prepost_`s' = (nobs_pre_`s'>=20 & nobs_post_`s'>=20 & time_pre_`s'>=2 & time_post_`s'>=2)
	tab res_prepost_`s'
	assert start_testing_month_`s'!=. if res_prepost_`s'==1

}

****************************************************************************
*KEEP AND LABEL VARIABLES
****************************************************************************
do "$Do/zz_keep&label.do"


save "$working/clean_hiredworkers_nost_2", replace

