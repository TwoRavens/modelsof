
clear
clear mata
set more off
set matsize 11000
set mem 700m
pause on


global path = ""
cd "$path"
global log = ""
global output = ""
global raw = ""
global working = ""
global tables = ""
global graphs = ""


capture log close
log using "$log/step2_create_apppool_17.log", replace

*******************************************************************************
*MAKE APPLICATION POOL
*******************************************************************************

use "$working/master_allworkers_1", clear

tab post_datafirm
keep if post_datafirm==1

assert location!=.
assert clientID!=.
assert recruiter_id!=.

**There are a couple hundred very early application dates.
**These are almost entirely from one client firm.
ren created_date apply_date
gen helper = year(apply_date)
tab helper
drop if helper<2001
drop helper

assert apply_date!=. if hired==0 
count

count if apply_date==. 
assert hired==1 if apply_date==.

gen apply_month = ym(year(apply_date), month(apply_date))
gen hire_month = ym(year(hire_date),month(hire_date))

gen gap = hire_month - apply_month
sum gap, d
tab gap
drop gap
**Fill in "apply_month" for about 1,500 people, use median gap is 1 month
replace apply_month = hire_month-1 if apply_date==.

sort recruiter_id location clientID 
li recruiter_id location clientID apply_date in 1/200

*recruiters can be associated with multiple loctions
bys recruiter_id: egen numloc=nvals(location)
tab numloc
tab numloc if  recruiter_id!=9999

bys recruiter_id: egen numclient=nvals(clientID)
tab numclient 
tab numclient if  recruiter_id!=9999


******************************************************************************
*THIS CREATES AN APPLICANT MONTH FILE FOR MONTHS THEY ARE IN PLAY
*a pool will be non-missing so long as there is at least one applicant in play
******************************************************************************

replace apply_month = hire_month if apply_month>hire_month & hire_month!=.

*What is the maximum amount of time a hired worker was in the data before being hired?
gen timetohire = hire_month-apply_month + 1
sum timetohire if hire_month!=., d
tab timetohire if hire_month!=.

*THIS PART RESTRICTS TO PEOPLE WHO HAVE BEEN IN THE POOL UP TO 4 MONTHS
*You can be in play for up to 4 months and only up to the moment you are hired
gen event_month1 = apply_month
gen counter_id=_n
foreach num of numlist 2/4 {
	local helper = `num'-1
	gen event_month`num' = apply_month+`helper'
	*We are dropping people who have been hired by that event month
	replace event_month`num'=. if hire_month<event_month`num'
}
reshape long event_month, i(counter_id) j(counter)
drop if event_month==.
tab counter
drop counter

format event_month apply_month hire_month %tmNN-CCYY

*NOW CREATE A PANEL BY (RECRUITER LOCATION) OVER VARIOUS MONTHS
egen recloc_id = group(recruiter_id location)
assert recloc_id!=.

sort recloc_id event_month counter_id
ren hired everhired
gen hired=(hire_month==event_month)
replace hired=0 if hire_month==.
tab hired

egen poolid=group(recloc_id event_month)

*Note that hire_month=event_month (if you need to merge)
d recruiter_id location event_month 
format event_month apply_month hire_month %tmNN-CCYY

save "$working/temp_pool_indiv", replace

******************************************************************************
*THIS CREATES AN APPLICANT MONTH FILE FOR MONTHS THEY ARE IN PLAY
*a pool will be non-missing so long as there is at least one applicant in play
*For each person, create a month which is their actual hire month and a month which is their application month
******************************************************************************

use "$working/temp_pool_indiv", clear

**no variation within pool in client
bysort poolid: egen helper = sd(clientID)
assert helper==0 if helper!=.
drop helper

sort recloc_id event_month employeeID 
assert poolid!=.
li employeeID poolid recloc_id event_month appscore everhired hired hire_month in 1/20

*IS THERE EVER A HIRE IN THE POOL?
bys poolid: egen anyonehired_pool=max(hired)

*NUMBER OF HIRES OF EACH TYPE WITHIN A POOL
tab appscore, m
foreach color in g y r {
	gen temp = (appscore=="`color'")
	bys poolid: egen numapp_`color'=total(temp)
	drop temp
	
	gen temp = (appscore=="`color'" & hired==1)
	bys poolid: egen numhire_`color'=total(temp)
	drop temp
	
	gen temp = (appscore=="`color'" & hired==0)
	bys poolid: egen numnhire_`color'=total(temp)
	drop temp
}

	gen temp = (appscore=="")
	bys poolid: egen numapp_Mcolor=total(temp)
	drop temp
	
	gen temp = (appscore=="" & hired==1)
	bys poolid: egen numhire_Mcolor=total(temp)
	drop temp
	
	gen temp = (appscore=="" & hired==0)
	bys poolid: egen numnhire_Mcolor=total(temp)
	drop temp

*WHETHER SOMEONE IS AN EXCEPTION (IF NOT HIRED, SET TO 0)
*You were an exception if:
*1. You are a yellow HIRED and there are greens NOT hired
*2. You are a red HIRED and there are yellow or greens NOT hired

gen exception_y=(appscore=="y" & numnhire_g>=1 & hired==1)
gen exception_r=(appscore=="r" & (numnhire_g>=1 | numnhire_y>=1) & hired==1)

gen nonexception_y=(appscore=="y" & numnhire_g==0 & hired==1)
gen nonexception_r=(appscore=="r" & numnhire_g==0 & numnhire_y==0 & hired==1)

gen exception=(exception_y==1 | exception_r==1)
gen nonexception=((appscore=="g" & hired==1) | nonexception_y==1 | nonexception_r==1)

*WHETHER SOMEONE IS A PASSED UP GREEN YELLOW RED (EG A LOWER COLOR WAS HIRED AHEAD OF THEM)
gen passedup_g=(appscore=="g" & hired==0 & (numhire_y>=1 | numhire_r>=1))
gen passedup_y=(appscore=="y" & hired==0 & numhire_r>=1)

*WHETHER SOMEONE IS EVENTUALLY HIRED (will need to eventually link their performance when they are hired)
gen hiredlater=(hired==0 & everhired==1)
foreach color in g y r {
gen hiredlater_`color'=(hiredlater==1 & appscore=="`color'")
}

save "$working/interim", replace

*******EXCEPTION #S WITH EVERHIRED PPL NOT COUNTED (E.G. IF NOT HIRED NOW BUT HIRED LATER, WE DROP YOU)

use "$working/temp_pool_indiv", clear
drop if hired==0 & everhired==1

gen temp=(hired==1)
bys poolid: egen numhireever=total(temp)
drop temp

*NUMBER OF HIRES OF EACH TYPE WITHIN A POOL
tab appscore, m
foreach color in g y r {
	gen temp = (appscore=="`color'")
	bys poolid: egen numappever_`color'=total(temp)
	drop temp
	
	gen temp = (appscore=="`color'" & hired==1)
	bys poolid: egen numhireever_`color'=total(temp)
	drop temp
	
	gen temp = (appscore=="`color'" & hired==0)
	bys poolid: egen numnhireever_`color'=total(temp)
	drop temp
}

	gen temp = (appscore=="")
	bys poolid: egen numappever_Mcolor=total(temp)
	drop temp
	
	gen temp = (appscore=="" & hired==1)
	bys poolid: egen numhireever_Mcolor=total(temp)
	drop temp
	
	gen temp = (appscore=="" & hired==0)
	bys poolid: egen numnhireever_Mcolor=total(temp)
	drop temp

*WHETHER SOMEONE IS AN EXCEPTION (IF NOT HIRED, SET TO 0)
*You were an exception if:
*1. You are a yellow HIRED and there are greens NOT hired
*2. You are a red HIRED and there are yellow or greens NOT hired

gen exceptionever_y=(appscore=="y" & numnhireever_g>=1 & hired==1)
gen exceptionever_r=(appscore=="r" & (numnhireever_g>=1 | numnhireever_y>=1) & hired==1)

gen nonexceptionever_y=(appscore=="y" & numnhireever_g==0 & hired==1)
gen nonexceptionever_r=(appscore=="r" & numnhireever_g==0 & numnhireever_y==0 & hired==1)

gen exceptionever=(exceptionever_y==1 | exceptionever_r==1)

keep employeeID poolid recloc_id event_month *exceptionever* *hireever* numappever*
save "$working/temp_evers", replace

******************************************************************************
*DATA ON WHETHER HIRED PPL WERE EXCEPTIONS OR WERE EVER PASSED UP
******************************************************************************

use "$working/clean_hiredworkers_nost_2", clear
keep clientID data_end_c
duplicates drop
duplicates tag clientID, gen(tag)
tab tag
assert tag==0
drop tag
save "$working/temp", replace


use "$working/interim", clear

duplicates tag employeeID event_month, gen(tag)
tab tag
assert tag==0
drop tag

merge m:1 clientID using "$working/temp"
assert _merge==3
drop _merge

sort employeeID event_month
by employeeID: gen poolcounter=_n

*WHETHER HIRED PPL WERE EXCEPTIONS OR WERE EVER PASSED UP
foreach var of varlist passedup* exception* nonexception* {
bys employeeID: egen ever`var'=max(`var')
}

*WHAT SOMEONE'S PERFORMANCE IS IF THEY ARE EVERHIRED
foreach num of numlist 1 2 3 6 12 24 {
	gen month`num' = (dur>=`num'*30 & dur!=.)
}

gen ldur=log(dur)
gen dur_restrict = dur if terminated==1
gen ldur_restrict = ldur if terminated==1

foreach month in 1 3 6 12 24 {
	gen month`month'_restrict = month`month' if hire_month + `month'<=data_end_c
	replace month`month'_restrict=. if dur==.
}

*THIS IS THE "EVENTUAL" DURATION
foreach var of varlist ldur_restrict dur_restrict month1_restrict month3_restrict month6_restrict month12_restrict {
bys employeeID: egen even_`var'_restrict=max(`var')
}

foreach var of varlist ldur dur {
bys employeeID: egen even_`var'=max(`var')
}

*GENERATE EVENTUALLY CENSORED
gen temp_cens=(term_date==.) if everhired==1
bys employeeID: egen even_censored=max(temp_cens)
replace even_censored=. if everhired==0

*HOW MANY MONTHS YOU WERE WAITING IN THE POOL BEFORE BEING HIRED
by employeeID: egen wait=max(poolcounter)

foreach color in g y r {
gen `color'1=(wait==1 & appscore=="`color'")
gen `color'2=(wait==2 & appscore=="`color'")
gen `color'3=(wait==3 & appscore=="`color'")
gen `color'4=(wait==4 & appscore=="`color'")
}

save "$working/pool_indiv_3", replace


******************************************************************************
*COLLAPSE TO POOLID LEVEL TO CONSTRUCT VIOLATION INFORMATION
******************************************************************************
use "$working/pool_indiv_3", clear

*MERGE IN EVER variables
merge 1:1 employeeID poolid event_month using "$working/temp_evers"
assert _merge!=2

foreach var of varlist numhireever* numnhireever* {
bys poolid: egen test=max(`var')
replace `var'=test
drop test
}

collapse (mean) recruiter_id location event_month clientID numapp* numhire* numnhire* (count) numapp=event_month (sum) numhire=hired, by(poolid)

codebook poolid
codebook poolid if numhire>0

sum numapp*, d
sum numhire*, d
sum numnhire*, d

assert numapp>=numapp_g
assert numhire>=numhire_g

*What percent of applicants have test info
gen pool_test_share = (numapp_g + numapp_y + numapp_r)/numapp
sum pool_test_share, d
sum pool_test_share if recruiter_id!=-9999, d

*number of times they hire someone without a test
count if numhire_g + numhire_y+numhire_r!=numhire

count
count if numhire==0

*ONLY KEEP POOLS WITH AT LEAST 1 HIRE 
drop if numhire==0
assert numhire!=.

*TOTAL AMOUNT OF POSSIBLE FLEXIBILITY (# OF WAYS TO MAKE HIRES GIVEN POOL
gen double totflex = comb(numapp, numhire)

****************SCORING VERSION: GREEN GET 2 PTS, YELLOWS 1, REDS 0

*Make numerator
gen score_actual=2*numhire_g + numhire_y

*Make denominator
**random score is score of all the applicants * share hired
*This version uses all hired and applications
gen score_ran1=((2*numapp_g + numapp_y)/(numapp))*(numhire)
*This version uses all only hired and applications with a color score
gen score_ran2=((2*numapp_g + numapp_y)/(numapp_g + numapp_y+numapp_r))*(numhire_g + numhire_y+numhire_r)

*Max score = highest possible score given applicant pool
**if hire fewer than total number of green apps:
gen score_max1=2*numhire if numhire<=numapp_g
gen temp=numhire-numapp_g 
replace score_max1=2*numapp_g + temp if  numhire>numapp_g & temp<=numapp_y
replace score_max1=2*numapp_g + numapp_y if numhire>numapp_g & temp>numapp_y
replace score_max1=. if numhire==. 
drop temp

gen temp=numhire_g + numhire_y+numhire_r
gen score_max2=2*temp if temp<=numapp_g
capture drop temp2
gen temp2=temp-numapp_g 
replace score_max2=2*numapp_g + temp2 if  temp>numapp_g & temp2<=numapp_y
replace score_max2=2*numapp_g + numapp_y if temp>numapp_g & temp2>numapp_y
replace score_max2=. if numhire==. 
drop temp temp2


********************************ORDER VIOLATION VERSION 

gen order_viol=numhire_y*numnhire_g + numhire_r*(numnhire_g+numnhire_y)
gen order_violever=numhire_y*numnhireever_g + numhire_r*(numnhireever_g+numnhireever_y)

*************DENOMINATOR FOR MAIN EXCEPTION RATE

*Number of hires with a color score
gen numhire_total=numhire_g+numhire_y+numhire_r

*Number of slots left after hiring all reds
gen numslotsleft_after_red=numhire_total-numapp_r

*Number of slots left after hiring all reds and all yellows
gen numslotsleft_after_red_yellow=numhire_total-numapp_r-numapp_y

*Number of applicants total
gen numapp_color=numapp_r+numapp_y+numapp_g

*1.  If there are more red applicants than the number you hired, max violations is number of people you hired (assume they are all red, times the number of greens and yellows that you did not hire, which in this case is all the green and yellow applicants)
gen max_viol3=numhire_total*(numapp_g+numapp_y) if numhire_total<=numapp_r

*2.  Now assume there aren't more red applicants than number of people you plan to hire.  Also assume that the number of slots you have left after hiring all reds is less than the number of yellow applicants. Then number of violations is number of red hires (all of them) times number of unhired greens (all green applicants) + unhired yellows (all yellow applicants minus set that are hired after reds run out) + number of violations coming from the yellows -- all the hired yellows (numslotsleft_after_red) times all unhired greens -- all green applicants. 
replace max_viol3=numapp_r*(numapp_g+(numapp_y-numslotsleft_after_red))+ numslotsleft_after_red*numapp_g if numhire_total>numapp_r & numslotsleft_after_red<=numapp_y 

*3. Now assume that number of slots left after hiring all reds is greater than number of yellow applicants, but less than the total number of applicants  Now there are no unhired yellows so all violations come from unhired greens.

replace max_viol3=numapp_r*(numapp_g-numslotsleft_after_red_yellow)+numapp_y*(numapp_g-numslotsleft_after_red_yellow) if numhire_total>numapp_r & numslotsleft_after_red>numapp_y & numhire_total<numapp_color

*4.  Now assume that there are not enough yellows or greens to make up the difference -- then there are no violations because you have hired everyone.
replace max_viol3=0 if numhire_total>=numapp_color
assert max_viol3!=.

*************NOT USED: ALTERNATIVE DENOMINATOR FOR EXCEPTION RATE -- INCLUDES HIRES WITHOUT TEST SCORES
capture drop numhire_total numslotsleft_after_red numslotsleft_after_red_yellow numapp_color

*Number of hires with a color score
gen numhire_total=numhire

*Number of slots left after hiring all reds
gen numslotsleft_after_red=numhire_total-numapp_r

*Number of slots left after hiring all reds and all yellows
gen numslotsleft_after_red_yellow=numhire_total-numapp_r-numapp_y

*Number of applicants total
gen numapp_color=numapp_r+numapp_y+numapp_g

*1.  If there are more red applicants than the number you hired, max violations is number of people you hired (assume they are all red, times the number of greens and yellows that you did not hire, which in this case is all the green and yellow applicants)
gen max_viol4=numhire_total*(numapp_g+numapp_y) if numhire_total<=numapp_r

*2.  Now assume there aren't more red applicants than number of people you plan to hire.  Also assume that the number of slots you have left after hiring all reds is less than the number of yellow applicants. Then number of violations is number of red hires (all of them) times number of unhired greens (all green applicants) + unhired yellows (all yellow applicants minus set that are hired after reds run out) + number of violations coming from the yellows -- all the hired yellows (numslotsleft_after_red) times all unhired greens -- all green applicants. 
replace max_viol4=numapp_r*(numapp_g+(numapp_y-numslotsleft_after_red))+ numslotsleft_after_red*numapp_g if numhire_total>numapp_r & numslotsleft_after_red<=numapp_y 

*3. Now assume that number of slots left after hiring all reds is greater than number of yellow applicants, but less than the total number of applicants  Now there are no unhired yellows so all violations come from unhired greens.

replace max_viol4=numapp_r*(numapp_g-numslotsleft_after_red_yellow)+numapp_y*(numapp_g-numslotsleft_after_red_yellow) if numhire_total>numapp_r & numslotsleft_after_red>numapp_y & numhire_total<numapp_color

*4.  Now assume that there are not enough yellows or greens to make up the difference -- then there are no violations because you have hired everyone.
replace max_viol4=0 if numhire_total>=numapp_color
assert max_viol4!=.


******RANDOM DENOMINATOR--if you hired at random, how many order violations would there be?
foreach stem in g y r {
	gen sim_numhire_`stem' = numhire*(numapp_`stem'/(numapp_g + numapp_y + numapp_r))
	gen sim_numnhire_`stem' = numapp_`stem' - sim_numhire_`stem'
}
gen sim_violations = sim_numhire_y*sim_numnhire_g + sim_numhire_r*(sim_numnhire_g + sim_numnhire_y)

sum order_viol sim_violations max_viol3

**********************GENERATE RATIOS
*Score, higher is better
gen EX_score_ran1=score_actual/score_ran1
gen EX_score_ran2=score_actual/score_ran2
gen EX_score_max1=score_actual/score_max1
gen EX_score_max2=score_actual/score_max2

*Violations, lower is better
gen EX_viol_3=order_viol/max_viol3
gen EX_viol_4=order_viol/max_viol4
gen EX_viol_ran = order_viol/sim_violations

sum EX_*, d

assert numhire>0 & numhire!=.
foreach var of varlist EX_*2 EX_*3 max_viol3 EX_*1 EX_*4 max_viol4 {
	replace `var' = . if (numhire_g +numhire_y+numhire_r)==0
}

*INDICATOR FOR SAME COLOR POOLS
gen same_color = (numapp_g==(numapp_g+numapp_y+numapp_r) | numapp_y==(numapp_g+numapp_y+numapp_r) | numapp_r==(numapp_g+numapp_y+numapp_r))
tab same_color

*MAKE VERSION THAT ONLY EXISTS IF THERE'S COLOR VARIATION
foreach var of varlist EX_* {
                gen `var'_colorvar = `var' if  same_color==0
}

keep recruiter_id location clientID event_month EX_* numhire* numapp* numnhire* same_color score_actual order_viol  max_viol3  max_viol4 score_ran2 score_max2 sim_violations
ren score_actual scoreapp
ren order_viol viol

egen tempid=group(recruiter_id location event_month)
codebook tempid 
codebook tempid if numhire>0
assert numhire>0
drop tempid
save "$working/pool_level_3", replace

