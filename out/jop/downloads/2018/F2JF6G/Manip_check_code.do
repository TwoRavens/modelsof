* This file codes manipulation check data for Timothy J. Ryan, 
* "Actions Versus Consequences in Political Arguments: Insights 
* from Moral Psychology" (JOP). Analysis was conducted on 
* Stata/SE 14.2 for Mac (64-bit Intel).


insheet using "manip_check_raw.csv", clear names

* Conditions
gen cond = .
replace cond = 0 if mcmora_1!=.
replace cond = 1 if mcmorb_1!=.
replace cond = 2 if mcmorc_1!=.
replace cond = 3 if mcmord_1!=.

gen deontcond = .
replace deontcond = 1 if cond==1 | cond==3
replace deontcond = 0 if cond==0 | cond==2

gen libexper = .
replace libexper = 1 if cond==0 | cond==1
replace libexper = 0 if cond==2 | cond==3

* Moral items: Rescale responses 0-1
foreach cond in a b c d {
	foreach var of varlist mcmor`cond'_1-mcmor`cond'_6 {
		replace `var' = (`var' - 1) / 4
		}
	}

* Moral items: Collapse across conditions
foreach x of numlist 1/6 {
	egen mcmor`x' = rowmax(mcmora_`x' mcmorb_`x' mcmorc_`x' mcmord_`x') 
		}
		
alpha mcmor1 mcmor3 mcmor5, gen(deontscale) //.87
alpha mcmor2 mcmor4 mcmor6, gen(consscale) //.89
	
* Extraneous items: Collapse and rescale responses 0-1	
foreach x of numlist 1/9 {
	egen mcthink`x' = rowmax(mcthinka_`x' mcthinkb_`x' mcthinkc_`x' mcthinkd_`x')
	replace mcthink`x' = (mcthink`x' - 1) / 4
	}	

lab var mcthink1 "Economy"
lab var mcthink2 "Future"
lab var mcthink3 "Family"
lab var mcthink4 "Job"
lab var mcthink5 "Religion"
lab var mcthink6 "Mitt Romney"
lab var mcthink7 "Obama"
lab var mcthink8 "Repub. Party"
lab var mcthink9 "Dem. Party"

* Speaker's age
egen mcage = rowmax(mcagea mcageb mcagec mcaged)

* Time reading
egen mctime = rowmax(mctimera_1 mctimerb_1 mctimerc_1 mctimerd_1)

save "manip_check_working.dta", replace
