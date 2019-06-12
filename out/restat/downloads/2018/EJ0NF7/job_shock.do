use workhistory.dta /// using data (not provided) from the full work histories of employment 

keep caseid year jobsheld reason_left*

// try to line up reason for leaving job X with maximum number of jobs held 
// in year Y
reshape long reason_left_job_, i(caseid year) j(job) // this expands the data a lot but is useful
ren reason_left_job_ reason_left_job

* isolating job transitions and their reasons:
bys caseid year: gen count = _n  // should be 57 but we need to see when jobsheld changes
sort caseid year job count 		 // just for looking at the data
gen new_jobs_held_temp = jobsheld - jobsheld[_n-1] if count==1 // did they report holding a new job?
bys caseid year: egen new_jobs_held = max(new_jobs_held_temp)  // let's get the max for each 

drop new_jobs_held_temp // drop temp

// we want to keep the observations where the job number with the reason assigned is less than the total number of jobs held but greater than or equal to the potential number of new jobs held between gaps.

keep if job<jobsheld & job >=jobsheld-new_jobs_held 

* now we're left with uniqueness in terms of (caseid, job) and the years for each
* transition so we can have timing with our job reasons. we don't want to merge
* this back until we have uniqueness in terms of (caseid, year), so now turn to dummies

* simple job shock: layoff, closed workplace, fired , bankruptcy/failed business, Quit because Rs ill health, disability (reason_left_job = {1,2,4,22,10})

gen job_shock_temp = reason_left_job == 1 | reason_left_job == 2 | reason_left_job == 4 | reason_left_job == 10 | reason_left_job == 22
replace job_shock_temp = . if mi(reason_left_job)
bys caseid year: egen job_shock = sum(job_shock_temp) if job_shock_temp!=.   // keeping the total number of shocks

* job ended (temp)
gen job_end_temp = reason_left_job == 3 | reason_left_job == 5 | reason_left_job == 21 
replace job_end_temp = . if mi(reason_left_job)
bys caseid year: egen job_end = sum(job_end_temp) if job_end_temp!=.   // keeping the total number of shocks

* job quits  
gen job_quit_temp = (reason_left_job >= 6 & reason_left_job < 9 ) | (reason_left_job >= 11 & reason_left_job<=14)
replace job_quit_temp = . if mi(reason_left_job)
bys caseid year: egen job_quit = sum(job_quit_temp) if job_quit_temp!=.    // keeping the total number of shocks

bys case year: gen numjobs=_N

duplicates drop caseid year job_shock, force // give us uniqueness in caseid year
keep caseid year job_shock 	job_end job_quit numjobs reason		 // clean up a bit and prep for merge
drop if mi(job_shock)						 // prep for merge

merge 1:1 case year using "${int}/jobsheld.dta" // merege with total number of jobs held

sort case year

// for the times in between, when there were no job changes we need to replace shocks with zeros!

sort case year
gen nj=numjob
bys case: replace nj = nj[_n-1] if nj >= . 
bys case: replace nj = nj[_n+1] if nj >= . 

replace nj=. if totjobsh==.
drop numjobs  _m
rename nj numjobs

label var job_end "no. of temporary job ended"
label var job_quit "no. of job quits"
label var job_shock "no. of jobs ended unexpectedly"

rename jobsheld totjobsh

label var numjobs "number of jobs held"
label var totjobsh "total number of jobs ever held"

// because of the way the job+shock vars were created, if the i didn't change jobs, he has no data ... so we replace these data with zeros
tsset case year
tsfill, full

replace job_shock=0 if job_shock==.
replace job_quit=0 if job_quit==.
replace job_end=0 if job_end==.

bys case (year): replace totjobsh=totjobsh[_n-1] if totjobsh==. & totjobsh[_n-1]!=.
bys case (year): replace numjobs=numjobs[_n-1] if numjobs==. & numjobs[_n-1]!=.

drop jobsheldo job_shocko job_quito job_endo

save job_shock.dta, replace

