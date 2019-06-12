* This file creates a dataset of election results to be matched with the CCES data
* and analyzed in Study 3 of Broockman & Ryan, Preaching
* to the Choir (AJPS). Analysis was conducted on State/SE 13.1 for 
* Mac (64-bit Intel)

set more off
clear all

cd "~/Dropbox/Broockman-Ryan/Outpartisan Communication/DATA/Final Replication Files/Study3"

foreach num of numlist 1/5 { // The data was downloaded as 5 separate files, each of which need to be cleaned
	insheet using "house`num'.csv", clear comma
	drop in 2 // drop extra rows in the raw datasets
	drop in 1

	outsheet using "temp.csv", comma replace nonames // This line and the next get Stata to recognize variable labels
	insheet using "temp.csv", names clear
	drop if state=="" // drop extra rows
	drop if state=="State" // more debris
	save "house`num'", replace // save cleaned up dataset
	}

* Combine the five files
use "house1.dta", clear
append using "house2.dta"
append using "house3.dta"
append using "house4.dta"
append using "house5.dta"

destring raceyear, replace
rename raceyear year

* Remove commas from vote totals
replace repvotes = subinstr(repvotes, ",", "",1)
replace demvotes = subinstr(demvotes, ",", "",1)

* Convert to string
destring repvotes, replace force
destring demvotes, replace force

* Calculate 2-party vote
gen vote2party = repvotes + demvotes
gen demperc = demvotes / vote2party

* Dem victory percentage. (Negative means Dems lost.)
gen demwinperc = demperc - .5

* Extract district info
gen district = ""
replace district = regexs(2) if regexm(area, "(District )([0-9]+)")
destring district, replace
replace district = 1 if area=="At Large"

* District info in alternative format
gen distasstring = string(district)
gen distname = state + distasstring

keep repvotes demvotes demwin demwinperc vote2party state district year district distname

foreach var in repvotes demvotes demwinperc vote2party {
	rename `var' h`var' // H for house
	}
	
order state district, first

drop if state=="Louisiana" & (hrepvotes==12511 | hdemvote==35153) // These were two runoff elections in which only one party received votes
drop if state=="Texas" & hrepvotes==60175 // Save D/R runoff only

save "house2006.dta", replace


	
