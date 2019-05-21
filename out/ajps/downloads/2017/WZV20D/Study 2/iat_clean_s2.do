* This file takes the summarized IAT responses, created by "iat_import_s2.R" and 
* prepares them to be merged with the Qualtrics responses for Study 2 
* of Ryan, "How do Indifferent Voters Decide?" (AJPS). Analysis was conducted on 
* Stata/SE 14.2 for Mac (64-bit Intel).

clear all
insheet using "summarized_s2.csv", names

format id %11.0f

sort date

drop if d=="NaN"
drop if id==1840890276 // Invalid entry; unmatchable
drop if id==1442180476 // Invalid entry; unmatchable


duplicates tag id, gen(dup) // 9 people took the IAT twice
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

rename id idno // Standardize naming convention

replace d_s1 = "" if d_s1=="NaN"
replace d_s2 = "" if d_s2=="NaN"

save "study2_iat_cleaned.dta", replace
