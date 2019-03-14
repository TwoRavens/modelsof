


clear



insheet using topics.csv

keep if v3 == 2013

sort v2

save temp, replace

forval t = 1 / 15 {
	clear
	use temp
	keep if v2 == `t'
	gsort -v4
	keep if _n <= 15 
	
	local words
	forval x = 1 / 15 {

		local this = v1[`x']
		local words `words' `this',
	}
	clear all
	set obs 1 
	gen topic = `t'
	gen words = "`words'"
	save temp`t', replace 
}

clear
forval t = 1 / 15 {
	append using temp`t'
	erase temp`t'.dta
}



texsave topic word using "output/topic_word_list2013.tex",   ///
 title("Bla") ///
 varlabels marker(tab:descriptive) location(h) frag align(cl)   ///
 replace 




clear



insheet using topics.csv

rename v1 word
rename v2 topic
rename v3 year
rename v4 probs

global tops 15
global twords 50

save output/topics, replace

local t 1




*****with function

clear
use output/topics

sort year word

save topics, replace

gen obs = 1
collapse (sum) obs, by(year word)
save temp, replace
clear
use topics
merge year word using temp
drop _merge
sort year topic word
save topics, replace


set more off

clear all

global twords 50

program computing_dist

	local t 15

	*one year
	forval x = 1995 / 2015 {
		local r = `x' + 1
		*other year
		forval y = `r' / 2015 {
			*one topics
			forval v = 1 / `t' {
				local w = 1
				*local found = 0
				*while `w' <= `t' & `found' == 0 {
				*other topic
				while `w' <= `t' {

					clear
					use topics
					keep if (topic == `v' & year == `x') | (topic == `w' & year == `y')
					*save temp, replace
					levelsof word, local(levels) 
				
					local k 0
					foreach l of local levels {
						local k = `k' + 1
						gen v`k' = 0
						gen q`k' = 0
						*replace v`k' = 1 if word == "`l'"
						replace v`k' = 1 / obs if word == "`l'"
						replace q`k' = 1 if word == "`l'"
						
					}
					
					display `k'
					
					
					
					*save temp, replace
					collapse (max) v* , by(year)
					
										
					*forval f = 1 / `k' {
					*	replace v`f' = 
					*}
					
					*keep v*			
					xpose, clear
					drop if _n == 1
					gen v3 = v1 * v2
					
					keep if v3 != 0
					
					
					
					local same1 0
					
				
					*corr v1 v2 if _n <= `k'
					*local a = `r(rho)'
					
				
					local doof = $twords * 2 - `k'
					
					if `doof' >= 1 {
						sum v3
						local same1 = `r(mean)' * `r(N)'
						post buffer (`x') (`v') (`y') (`w') (`doof') (`same1')
						*this is if I want to quit when I found one
						*if `doof' >= 35 {
						*	local found = 1
						*}
					}
					local w = `w' + 1
					
				}
			}
		
			*save compare_`x'_`y'
		}
	}
	
end



postfile buffer year1 topic1 year2 topic2 same2 same1 using "output/comparing_twords_big", replace
*postfile buffer year1 topic1 year2 topic2 same2 same1 using hurz, replace
computing_dist
postclose buffer		


