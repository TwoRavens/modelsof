cd C:\DataFiles\Research-Papers\Immigration\Kato\REStatPublicFiles\Fig2
*Rename directory according to own folder name.
clear
set more off
capture log close
log using VisaIssuances.log, text replace


set mem 500m
set matsize 3000

/*************************************************************************
Takao Kato & Chad Sparber
"Quotas and Quality: The Effect of H-1B Visa Restrictions 
   on the Pool of Prospective Undergraduate Students from Abroad"

Stata do-file for Figure 2: Visa Issuances
Data Source: US State Department, 
  http://www.travel.state.gov/visa/statistics/nivstats/nivstats_4582.html
  Nonimmigrant Visa Issuances by Visa Class and by Nationality
  NIV Detail Table for FY2000-FY2008

This file graphs H-1B, H-1B1, TN, and E3 Visa Issuances for
 Mexico, Australia, Chile, and Singapore
*******************************************************************************/






use VisaIssuances.dta, clear

twoway (scatter H1B TN year if country=="Mexico", title("Mexico") connect(l l) lpattern(l _) m(none none))
graph save Mex, replace

twoway (scatter H1B E3 year if country=="Australia", title("Australia") connect(l l) lpattern(l _) m(none none)) 
graph save Aus, replace

twoway (scatter H1B H1B1 year if country=="Chile", title("Chile") connect(l l) lpattern(l _) m(none none)) 
graph save Chi, replace

twoway (scatter H1B H1B1 year if country=="Singapore", title("Singapore") connect(l l) lpattern(l _) m(none none)) 
graph save Sing, replace




capture log close

exit
