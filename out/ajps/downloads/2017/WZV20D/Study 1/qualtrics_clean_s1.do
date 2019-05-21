* This file prepares Qualtrics survey responses for Study 1 of Ryan, "How Do 
* Indifferent Voters Decide?" (AJPS) for analysis. It also merges IAT responses 
* with the IAT responses created by "iat_clean_s1." Analysis was conducted on 
* Stata/SE 14.2 for Mac (64-bit Intel)

clear all

use "study1_qualtrics_raw.dta"

* Some respondents loaded the Qualtrics instrument more than once, generating excess responses. The following section determines which response to keep.

duplicates report idno

* First step is to exclude incomplete responses. (Several people scoped the survey and did not finish it, but then returned and provided a complete response later on.

gen time1 = substr(starttime,12,8)
gen time2 = substr(endtime,12,8)
gen start = clock(time1,"hms") / 1000
gen end = clock(time2,"hms") / 1000
gen elapse = end - start

replace elapse = elapse + 86400 if elapse<0 & elapse!=. // people crossing midnight

drop if elapse < 174 // Rushed / incomplete responses. (Many have complete responses elsewhere in the dataset.)

* Second step is to identify and retain the earliest remaining response.
gen start2 = clock(starttime,"YMDhms") / 1000
format start2 %12.0f
gen dropmark = 0

sum start2
local obs = r(N)
sort idno start
foreach n of numlist 2/`obs' {
	local n1 = `n'-1
	local n2 = `n'
	if idno[`n1'] == idno[`n2'] {
		replace dropmark = 1 in `n1' if start2[`n1'] > start2[`n2']
		replace dropmark = 1 in `n2' if start2[`n2'] > start2[`n1']
		}
	}

drop if dropmark==1
duplicates report idno

merge 1:1 idno using "study1_iat_cleaned.dta", keepusing(d d_s1 d_s2 error fast)

drop if _merge==2 // Unuseable IAT responses
replace d_s1="" if d_s1=="NaN" // Convert to missing value
destring d d_s1 d_s2, replace

* OIA Categories
gen intensity = abs(4-demplike) + abs(4-repplike)
gen dempdif = demplike - repplike

gen oiacat = .
replace oiacat = 1 if intensity < 3 & intensity!=.
replace oiacat = 0 if intensity > 2 & abs(dempdif)>2 & intensity !=.
replace oiacat = 2 if intensity > 2 & abs(dempdif)<=2

lab def oiacat 0 "One-sided" 1 "Indifferent" 2 "Ambivalent"
lab val oiacat oiacat

replace dempdif = dempdif / 6 // Scale -1 to 1
gen explicit = dempdif // Synonym
gen explicit2 = explicit * 6 // rescaled synonym, convenient for figures

* Quality of comment. (Main DV.)
gen qual = max(proqual, conqual)
replace qual = (qual-1)/6

* Pro-administration or con-administration argument? (Treatment variable)
gen proarg = .
replace proarg = 1 if dobrfl_12=="Pro arg"
replace proarg = 0 if dobrfl_12=="Con arg"

* Eliminate questionable d-scores
replace d = . if error>.35 & error!=. // Error rate above 35%
replace d = . if fast>.2 & fast!=. // More than 20% of responses very fast

gen implicit = d // Synonym

drop time1 time2 elapse start start2 end dropmark _merge // Simplify

save "study1_qualtrics_working.dta", replace


