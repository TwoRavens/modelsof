set more off
clear all

insheet using "mturka_raw.csv", names


* Fold the extremity measures, and scale 0-1
foreach var of varlist cbext ssext gmext scext afext {
	recode `var' (4 = 0) (3 5 = 1) (2 6 = 2) (1 7 = 3), gen(`var'fold2)
	gen `var'fold = `var'fold2/3
	drop `var'fold2
	}

* Scale importance measures 0-1
foreach var of varlist cbimp ssimp gmimp scimp afimp {
	replace `var' = (`var'-1)/4
	}

* Scale relevance measures 0-1
foreach var of varlist cbrelev ssrelev gmrelev screlev afrelev {
	replace `var' = (`var'-1)/4
	}

* Scale moral conviction measures 0-1 and check reliability
alpha cbsmor1 cbsmor2, gen(cbsmor)
replace cbsmor = (cbsmor-1)/4
alpha sssmor1 sssmor2, gen(sssmor)
replace sssmor = (sssmor-1)/4
alpha gmsmor1 gmsmor2, gen(gmsmor)
replace gmsmor = (gmsmor-1)/4
alpha scsmor1 scsmor2, gen(scsmor)
replace scsmor = (scsmor-1)/4
alpha afsmor1 afsmor2, gen(afsmor)
replace afsmor = (afsmor-1)/4

foreach var in cb ss gm sc af {
	replace `var'smor1 = (`var'smor1-1)/4
	replace `var'smor2 = (`var'smor2-1)/4
	}

* Scale compromise measures 0-1
foreach var in cb ss gm sc af { // Low values mean oppose compromise
	rename `var'comp `var'comp2
	gen `var'comp = 1-((`var'comp2-1)/6)
	drop `var'comp2
	}

* Partisanship
gen pidr2 = .
replace pidr2 = 0 if demstrong==1
replace pidr2 = 1 if demstrong==2
replace pidr2 = 2 if partclose==2
replace pidr2 = 3 if partclose==3
replace pidr2 = 4 if partclose==1
replace pidr2 = 5 if repstrong==2
replace pidr2 = 6 if repstrong==1
	
gen republican = 0
gen democrat = 0
replace republican = 1 if pidr2>3
replace democrat = 1 if pidr2<3
drop pidr2
	
* Create age categories
egen agebin = cut(age), at(18,29,39,49,59,69,120) icodes

* Education categories
recode educ (1 = 0) (2 = 1) (3 4 5 = 2) (6 = 3) (7 8 9 = 4), gen(educ2)

* The rest of the file restructures the dataset to be more suitable for panel-style analysis

* Change formatting of variable labels to the format the "Reshape" command likes
foreach iss in cb ss gm sc af {
	foreach dv in extfold imp relev smor smor1 comp {
		rename `iss'`dv' `dv'`iss'
		}
	}

* Reshape
reshape long smor smor1 extfold imp comp relev, i(idno) j(cb) string

rename cb issuetag2 // A better name. Indicates which issue this row is about.
encode issuetag2, gen(issue) // Encode it.

save "mturka_working.dta", replace

