clear all
set more off
use output/comparing_twords_big

*what should be baseline year
keep if year2 == 2013

*minimum weighted number of words that have to coincide
local thresh1 1

*minimum number of words that have to coincide to consider something same topic
local thresh2 3





replace topic1 = topic1 - 1
replace topic2 = topic2 - 1
sort year2 topic2 year1 same1 same2

save tempt, replace


local minni 50
local r 0
local stopit 1

while `r' < 50 & `stopit' > 0 {

	clear 

	use tempt

	if `r' > 0 {
		sort year2 topic2 year1 topic1
	
		forval x = 1 / 2 {
	
			if `x' == 1 {
				sort year`x' topic`x'
				merge year`x' topic`x' using found_topics`x'
			}
			if `x' == 2 {
				sort year1 year`x' topic`x'
				merge year1 year`x' topic`x' using found_topics`x'
		
			}
			keep if _merge == 1
			drop _merge
		}

	}
	
	display _N
	local stopit = _N

	bysort year1 topic1: egen ei1 = max(same1) 
	bysort year2 topic2: egen ei2 = max(same1) 
	gen ach = topic2 if same1 == ei1 & same1 == ei2 & (same2 > `thresh2' | same1 > `thresh1')

	sum same1 if ach != .
	if `r(N)' > 0 {
		local minni = min(`minni', `r(min)')
	}

	keep if ach != .
	drop ei* ach
	sort year2 topic2 year1 topic1
	if `r' > 0 {
		append using found_topics
	}

	save found_topics, replace

	forval x = 1 / 2 {
		clear
		use found_topics
	
		if `x' == 1 {
			keep year`x' topic`x'
			sort year`x' topic`x'
		}
		if `x' == 2 {
			keep year1 year`x' topic`x'
			sort year1 year`x' topic`x'
		}
		save found_topics`x', replace
	}
*r loop
	local r = `r' + 1	
}


display `minni'




