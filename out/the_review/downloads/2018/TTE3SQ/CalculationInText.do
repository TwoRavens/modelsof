use "dta/DynastyPanel.dta", clear
keep if districtid!=.

gen evermargin = 0
replace evermargin = 1 if abs(margin)<0.066

keep if main == 1
keep if year > 1952
keep if year < 1982

bysort pid: egen insample = max(evermargin)

collapse insample mpprecede, by(pid)

tab insample mpprecede, col

*** "About half (48\%) of the senior members of dynasties in our full sample are never close 
*** enough to the cut-off for winning or losing a seat to be included in our estimation sample."
