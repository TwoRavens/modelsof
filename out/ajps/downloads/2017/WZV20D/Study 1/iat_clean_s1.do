* This file takes the summarized IAT responses, created by "iat_import_s1.R" and 
* prepares them to be merged with the Qualtrics responses for Study 1 
* of Ryan, "How do Indifferent Voters Decide?" (AJPS). Analysis was conducted on 
* Stata/SE 14.2 for Mac (64-bit Intel).

clear all
insheet using "summarized_s1.csv", names

format id %11.0f

sort date

drop if d=="NaN" // Incomplete responses; no IAT score

drop if id==1441980480 // This was a test run
drop if id==246874052 // test run
drop if id==1441980486 // test run
drop if id==25114 // Will be unmatchable
drop if id==25116 // Will be unmatchable

duplicates report id // 22 people took the IAT twice
gen start2 = clock(date,"MDYhm") / 1000 // Extract time R started taking survey
format start2 %12.0f

gen dropmark = 0

* The following code identifies which IAT response was earlier.
sort id
sum v1
local obs = r(N)
foreach n of numlist 2/`obs' {
	local n1 = `n'-1
	local n2 = `n'
	if id[`n1'] == id[`n2'] {
		replace dropmark = 1 in `n1' if start2[`n1'] > start2[`n2']
		replace dropmark = 1 in `n2' if start2[`n2'] > start2[`n1']
		}
	else {
		}
	}

drop if dropmark==1 // drop later response
drop start2
drop dropmark
rename id idno // For consistency with labeling in the Qualtrics dataset

save "study1_iat_cleaned.dta", replace
