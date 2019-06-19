*** Figure 2 ****** 
use data_4_restat.dta , clear

gen unemp=LRUSECON 
label var unemp "unemployment"
gen labcomp=LXNFRUSECON 
label var labcomp "real labor compensation"

twoway (line labcomp date if date>0, yaxis(1) ) (line unemp date if date>0, yaxis(2) lpattern(dash)) 
