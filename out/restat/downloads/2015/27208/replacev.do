***********************
***   replacev.do   *** 
***********************

* ================
***
* set new ini_year for all obs. for each plant
*  use the max of potential initial years
***
cap prog drop max_yrM
prog def      max_yrM

  local varlist "req ex max(1)"
  tempvar max_mx 

  egen int `max_mx' = max(M_iniyr), by(bnr)
  replace M_iniyr = `max_mx'

end
* ================


gen       M_depr = 0.10
label var M_depr "Machines, depreciation rate"


***
* initial fire-insurance values
***
** There is one mis-punching (a negative value)
**
gen     M_fire = v87
replace M_fire = -M_fire if M_fire <0

***
* 1996 prices as in the main do-file
***
gen        Mffix = . 
label var  Mffix "Machines fire insurance value 1996 prices"
 replace   Mffix = M_fire/0.980  if aar == 1993 
 replace   Mffix = M_fire/0.988  if aar == 1994 
 replace   Mffix = M_fire/0.994  if aar == 1995 


***
* Net investment; machinery, fixtures and fittings and other means of transport
* Net investment is defined as purchases minus sales of fixed capital
***
gen        M_invf = (v50+v52+v53) - (v64+v66+v67) 
label var  M_invf "Machines investment 1996 fixed prices"
 replace   M_invf = M_invf/0.980 if aar == 1993 
 replace   M_invf = M_invf/0.988 if aar == 1994 
 replace   M_invf = M_invf/0.994 if aar == 1995 
 

***
* initial aar (defined as the first aar where the fire insurance value is ge. 250)
*   i) find the first year of each plant
*  ii) find the first year with replacement value ge. 250
* iii) assign the year where replacement value le. 250 to all observations of the plant
*       (variable name M_iniyr)
***
egen int   M0iniyr = min(aar) , by(bnr)
egen int   M1iniyr = min(aar) if Mffix >= 250, by(bnr)
replace    M0iniyr = M1iniyr if M1iniyr > M0iniyr & M1iniyr != .
egen int   M2iniyr = max(M0iniyr) , by(bnr)
drop       M0iniyr M1iniyr 
rename 	   M2iniyr M_iniyr


***
* initial values (starting from the first year that has a reasonable 
*    starting values. see above)
***
sort  bnr aar
gen       M_fix = -99
replace   M_fix = Mffix  if aar == M_iniyr
label var M_fix  "Machines (end of year), repl.value 1996 prices"

format    Mffix M_invf M_fix %9.0f

***
* calculate forward (if aar > M_iniyr) and backward (if aar < M_iniyr)
*** 
sort bnr aar
quietly by bnr: replace M_fix = M_fix[_n-1]*(1-M_depr) + M_invf   if bnr == bnr[_n-1] & aar > M_iniyr

gsort bnr -aar
quietly by bnr: replace M_fix = (M_fix[_n-1]-M_invf[_n-1])/(1-M_depr)   if bnr == bnr[_n-1] & aar < M_iniyr


***
* It might be that the replacement value now becomes negative in one of the years 1994-1995
* due to selling capital which is larger than the calculated replacement value. If so, we
* rather do not use the 1993 value as starting value, but the 1994 or 1995.
***

***
* 1) replacement value negative
***
sort bnr aar
***
* If we have negative replacement, we have to reset the M_iniyr. 
*   Set the M_iniyr to the first year where M_fix < 0
***
replace  M_iniyr = aar if M_fix < 0	& M_fix[_n-1] >= 0 & bnr == bnr[_n-1]
	
max_yrM  
***
* Use the fire insurance value (in fixed prices) for the year where the replacement value is negative
***
replace  M_fix = Mffix  if M_fix < 0

***
* have made a new initial replacement value. Calculate forward and backward again
*** 
sort bnr aar
quietly by bnr: replace M_fix = M_fix[_n-1]*(1-M_depr) + M_invf   if bnr == bnr[_n-1] & aar > M_iniyr

gsort bnr -aar
quietly by bnr: replace M_fix = (M_fix[_n-1]-M_invf[_n-1])/(1-M_depr)   if bnr == bnr[_n-1] & aar < M_iniyr

***
* 2) replacement value negative
***
sort bnr aar
count if M_fix < 0
replace  M_iniyr = aar if M_fix < 0 & M_fix[_n-1] >= 0 & bnr == bnr[_n-1]

max_yrM
replace M_fix = Mffix  if M_fix < 0 

***
* have made a new initial replacement value. Calculate forward and backward again
***
sort bnr aar
quietly by bnr: replace M_fix = M_fix[_n-1]*(1-M_depr) + M_invf   if bnr == bnr[_n-1] & aar > M_iniyr

gsort bnr -aar
quietly by bnr: replace M_fix = (M_fix[_n-1]-M_invf[_n-1])/(1-M_depr)   if bnr == bnr[_n-1] & aar < M_iniyr


****
* make the replacement in the beginning of the year
**** 
gen       K_mach_bg_fix = (M_fix-M_invf)/(1-M_depr)
gen       I_K_correct   = M_invf/K_mach_bg_fix
label var I_K_correct "I_K (K in beginning of period)"

***
* Keep only plants for which the K_mach_bg_fix - the replacement value
* in the beginning of the first year of each plant's series - is larger than 250
***
sort bnr aar 
by bnr: gen byte K_ok = 1 if K_mach_bg_fix[1] >= 250
egen byte K_ok2 = max(K_ok), by(bnr)
keep if K_ok2 == 1

****
* Constructing the I_K and K for the rest of the period (i.e. in the years
* subsequent to the first year of each plant's series) is done in Overall.do
****


