cd C:\DataFiles\Research-Papers\Immigration\Kato\REStatPublicFiles\Fig3
*Rename directory according to own folder name.
clear
set more off
capture log close
log using Fig3Rank2009.log, text replace


set mem 500m
set matsize 3000

/*************************************************************************
Takao Kato & Chad Sparber
"Quotas and Quality: The Effect of H-1B Visa Restrictions 
   on the Pool of Prospective Undergraduate Students from Abroad"

Stata do-file for Figure 3: Average SAT Scores of Enrollees and College Rank
Data Source: 2009 US News and World Reports "America's Best Colleges"

This file graphs 2009 USNWR Rank and Average of Q1 & Q3 SAT scores of enrollees
for research and liberal arts schools
*******************************************************************************/






use Rank2009, clear
gen rrank = (1-lib)*rank
replace rrank=. if rrank==0
gen lrank = lib*rank
replace lrank=. if lrank==0

label var rrank "Research Universities"
label var lrank "Liberal Arts Colleges"

label var avgsat "Average SAT Score"
twoway (scatter rrank lrank avgsat, msymbol(O d)) , ti("SAT Scores and College Rank") yti("College Rank") ysc(r(0 150)) 

reg rank avgsat





capture log close

exit
