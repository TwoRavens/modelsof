* 
* Creates a state-level dataset of historical variables (used in A.4).
* 
* Share of slaves from Mitchener and McLean 2003
* 
* Collective bargainig legislation and RTW based on Holmes 1998, 
* updated with online sources, and Flaving and Hartney 2015
* 

clear
import delim rtw, numericcols(3 4 5 6)

* Calc share of years with RTW and collective bargaining 
* between 2004 and 1950
gen H_rtwshyrs = (2004 - rtw_year)/ 54
replace H_rtwshyrs = 0 if rtw_year > 2004

gen H_collshyrs = (2004 - collbafh_year)/ 54
replace H_collshyrs = 0 if collbafh_year > 2004

keep statefip H_rtwshyrs H_collshyrs

merge 1:1 statefip using mitchener_mclean2003/mmc_data
drop _merge

rename slavery1860 H_slavery1860


keep statefip H_rtwshyrs H_collshyrs H_slavery1860 

save stateHistory, replace
