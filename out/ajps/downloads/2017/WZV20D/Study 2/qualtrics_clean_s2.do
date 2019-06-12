* This file prepares Qualtrics survey responses for Study 2 of Ryan, "How Do 
* Indifferent Voters Decide?" (AJPS) for analysis. It also merges IAT responses 
* with the IAT responses created by "iat_clean_s2." Analysis was conducted on 
* Stata/SE 14.2 for Mac (64-bit Intel).

clear all
set more off

cd "~/Dropbox/IAT/data/8_replication"

** Set up Wave 1 Responses
use "s2_w1_qualtrics_raw.dta", clear

* Duplicates. Some people took the instrument twice. We need to retain one response per person. Step 1 is to eliminate incomplete responses.

gen time1 = substr(starttime,12,8)
gen time2 = substr(endtime,12,8)
gen start = clock(time1,"hms") / 1000
gen end = clock(time2,"hms") / 1000
gen elapse = end - start

replace elapse = elapse + 86400 if elapse<0 & elapse!=. // people crossing midnight

drop if elapse < 100 // Incomplete responses. (Many have complete responses elsewhere in the dataset.)

* Step 2 is to retain the earliest of the remaining responses.

gen start2 = clock(starttime_w1,"YMDhms") / 1000
format start2 %12.0f
gen dropmark = 0

sum start
local obs = r(N)
sort idno start
foreach n of numlist 2/`obs' {
	local n1 = `n'-1
	local n2 = `n'
	if idno[`n1'] == idno[`n2'] {
		replace dropmark = 1 in `n1' if start2[`n1'] > start2[`n2']
		replace dropmark = 1 in `n2' if start2[`n2'] > start2[`n1']
		*di "Yes"
		}
	else {
		}
	}

drop if dropmark==1

keep idno demplike repplike starttime_w1

save "s2_w1_qualtrics_trimmed.dta", replace

** Set up Wave 2 responses
clear all
use "s2_w2_qualtrics_raw.dta", clear
gen time1 = substr(starttime_w2,12,8)
gen time2 = substr(endtime_w2,12,8)
gen start = clock(time1,"hms") / 1000
gen end = clock(time2,"hms")/1000
gen elapse = end - start
replace elapse = elapse + 86400 if elapse<0 & elapse!=. // people crossing midnight

sort elapse

drop if elapse<40 // Incomplete responses. (Many have complete responses elsewhere in the dataset.)

* Retain earliest remaining response.
gen start2 = clock(starttime,"YMDhms")

format start2 %25.0f
gen dropmark = 0

sum start2
local obs = r(N)
sort idno start2
foreach n of numlist 2/`obs' {
	local n1 = `n'-1
	local n2 = `n'
	if idno[`n1'] == idno[`n2'] {
		replace dropmark = 1 in `n1' if start2[`n1'] > start2[`n2']
		replace dropmark = 1 in `n2' if start2[`n2'] > start2[`n1']
		*di "Yes"
		}
	else {
		}
	}

*br pidno v8 start2 dropmark
	
drop if dropmark==1
drop if idno==1440892062 & starttime_w2=="2015-03-27 10:45:28" // Handling one manually because a Stata quirk causes the loop above to miss this person.
drop if idno==1440768648 & starttime_w2=="2015-04-24 15:36:16" // Handling this one manually too. Person opened the instrument three times, so the loop above misses him/her
drop if idno==1440768648 & starttime_w2=="2015-04-24 15:36:42" // Still handling respondent from line just above

keep starttime_w2 endtime idno *credit *blame 

save "s2_w2_qualtrics_trimmed.dta", replace

* Merge
clear all
use "s2_w1_qualtrics_trimmed.dta"
merge 1:1 idno using "s2_w2_qualtrics_trimmed.dta"
rename _merge merge1
merge 1:1 idno using "study2_iat_cleaned.dta"
destring d d_s1 d_s2, replace

* Conditions
gen goodnews = .
replace goodnews = 1 if kecredit!=.
replace goodnews = 0 if keblame!=.

* Main DV
foreach var in kecredit kocred keblame koblame { // This loops rescales these vars 0-1
	replace `var' = (`var' - 1) / 4
	}
	
gen presinfluence = kocredit - kecredit if goodnews==1 // Presidency argument is convincing
replace presinfluence = keblame - koblame if goodnews==0 // Presidency argument is convincing
replace presinfluence = (presinfluence + 1) / 2 // Rescale 0-1

* OIA Categories
gen intensity = abs(4-demplike) + abs(4-repplike)
gen dempdif = demplike - repplike

gen oiacat = .
replace oiacat = 1 if intensity < 3 & intensity!=.
replace oiacat = 0 if intensity > 2 & abs(dempdif)>2 & intensity !=.
replace oiacat = 2 if intensity > 2 & abs(dempdif)<=2

replace dempdif = dempdif / 6 // Scale -1 to 1
gen explicit = dempdif // Synonym
gen explicit2 = explicit * 6 // rescaled synonym, convenient for figures

lab def oiacat 0 "One-sided" 1 "Indifferent" 2 "Ambivalent"
lab val oiacat oiacat

* Remove questionable d-scores
replace d = . if error>.35 & error!=. // Error rate above 35%
replace d = . if fast>.2 & fast!=. // More than 20% of responses very fast

gen implicit = d // Synonym 

drop endtime_w2 merge1 v1 date block4m block7m block7sd diff diffs1 ///
	diffs2 block4sd fullsd dup start2 dropmark _merge fullsd* 

save "study2_qualtrics_working.dta", replace


