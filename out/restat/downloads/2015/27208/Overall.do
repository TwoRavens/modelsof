**************************
*** OVERALL_ReStat2014 ***
**************************

*** Start with the Manufacturing Statistics - files from Statistics Norway
*** Keep only the most relevant information

use "in1993.dta"
keep aar bnr fonr btype tilstand eierform bkode storb regn kopi skjema naering psektor ktgml ktny kommune handel arbeid invest landsdel utenl syssel loennk loennsI loennsII v11 v12 v13 v14 v15 v16 v17 v21 v27 v34 v35 v36 v38 v39-v88 v93 
save "small_manu1993.dta", replace
tabu kopi

use "in1994.dta"
keep aar bnr fonr btype tilstand eierform bkode storb regn kopi skjema naering psektor ktgml ktny kommune handel arbeid invest landsdel utenl syssel loennk loennsI loennsII v11 v12 v13 v14 v15 v16 v17 v21 v27 v34 v35 v36 v38 v39-v88 v93
tabu kopi
save "small_manu1994.dta", replace

use "in1995.dta"
keep aar bnr fonr btype tilstand eierform bkode storb regn kopi skjema naering psektor ktgml ktny kommune handel arbeid invest landsdel utenl syssel loennk loennsI loennsII v11 v12 v13 v14 v15 v16 v17 v21 v27 v34 v35 v36 v38 v39-v88 v93
tabu kopi
save "small_manu1995.dta", replace

use "in1996.dta"
keep aar bnr fonr btype tilstand eierform bkode storb skjema naering psektor kommune arbeid landsdel utenl syssel loennk loennsI loennsII v11 v12 v13 v14 v15 v16 v17 v21 v27 v34 v35 v36 v38 v39-v83
save "small_manu1996.dta", replace

use "in1997.dta"
keep aar bnr fonr btype tilstand eierform bkode storb skjema naering psektor kommune arbeid landsdel utenl syssel loennk loennsI loennsII v11 v12 v13 v14 v15 v16 v17 v21 v27 v34 v35 v36 v38 v39-v83
save "small_manu1997.dta", replace

use "in1998.dta"
keep aar bnr fonr btype tilstand eierform bkode storb skjema naering psektor kommune arbeid landsdel utenl syssel loennk loennsI loennsII v11 v12 v13 v14 v15 v16 v17 v21 v27 v34 v35 v36 v38 v39-v83
save "small_manu1998.dta", replace

use "in1999.dta"
keep aar bnr fonr btype tilstand eierform bkode storb skjema naering psektor kommune arbeid landsdel utenl syssel loennk loennsI loennsII v11 v12 v13 v14 v15 v16 v17 v21 v27 v34 v35 v36 v38 v39-v83
save "small_manu1999.dta", replace

use "in2000.dta"
keep aar bnr fonr btype tilstand eierform bkode storb skjema naering psektor kommune arbeid landsdel utenl syssel loennk loennsI loennsII v11 v12 v13 v14 v15 v16 v17 v21 v27 v34 v35 v36 v38 v39-v83
save "small_manu2000.dta", replace

use "in2001.dta"
keep aar bnr fonr btype tilstand eierform bkode storb skjema naering psektor kommune arbeid landsdel utenl syssel loennk loennsI loennsII v11 v12 v13 v14 v15 v16 v17 v21 v27 v34 v35 v36 v38 v39-v83
save "small_manu2001.dta", replace

use "in2002.dta"
keep aar bnr fonr btype tilstand eierform bkode storb skjema naering psektor kommune arbeid landsdel utenl syssel loennk loennsI loennsII v11 v12 v13 v14 v15 v16 v17 v21 v27 v34 v35 v36 v38 v39-v83
save "small_manu2002.dta", replace

use "in2003.dta"
keep aar bnr fonr btype eierform bkode storb skjema naering psektor kommune landsdel utenl syssel loennk loennsI loennsII v11 v12 v13 v14 v15 v16 v17 v21 v27 v34 v36 v38 v39-v83
save "small_manu2003.dta", replace

use "in2004.dta"
keep aar bnr fonr btype eierform bkode storb skjema naering psektor kommune landsdel utenl syssel loennk loennsI loennsII v11 v12 v13 v14 v15 v16 v17 v21 v27 v34 v36 v38 v39-v83
save "small_manu2004.dta", replace

use "in2005.dta"
keep aar bnr fonr btype eierform bkode storb skjema naering psektor kommune landsdel syssel loennk loennsI loennsII v11 v12 v13 v14 v15 v16 v17 v21 v27 v34 v36 v38 v39-v83
save "small_manu2005.dta", replace

use          "small_manu1993.dta", replace
append using "small_manu1994.dta"
append using "small_manu1995.dta"
append using "small_manu1996.dta"
append using "small_manu1997.dta"
append using "small_manu1998.dta"
append using "small_manu1999.dta"
append using "small_manu2000.dta"
append using "small_manu2001.dta"
append using "small_manu2002.dta"
append using "small_manu2003.dta"
append using "small_manu2004.dta"
append using "small_manu2005.dta"

compress

*** Drop 4 plants because of some inconsistensies
drop if (bnr == 1445855 | bnr == 1527797 | bnr == 4127692 | bnr == 5897750) 

saveold "small_19962005.dta", replace

***************
* Use the file generated above
***************
use "small_19962005.dta", clear

***
* drop if central or local goverments won more than 50% of equity, or ownership form unknown
***
drop if eierform >= 6 & eierform <= 9 | eierform == 11
drop if tilstand == 0

***
* create 2-digit sectors variable
***
gen  int naering2 = round(naering/1000)
egen int naer2_bnr = mode(naering2), by(bnr) maxmode
drop if  naer2_bnr == .

***
* focus on manufacturing
*** 
drop if naer2_bnr < 30 | naer2_bnr >=40

***
* drop auxillary units
***
drop if tilstand == 2 | tilstand == 4 | tilstand == 5

***
* drop some minor types of plants
***
drop if btype == 0 | btype == 4 | btype == 13

****
* drop very small plants
***
egen    mean_v11 = mean(v11), by(bnr)
egen    mode_v11 = mode(v11), by(bnr) maxmode
drop if mode_v11 < 10

***
* find production, Y
***
des  v16 
summ v16, det

***
* Make fixed-price variable
***
gen     prod_f = v16
 replace prod_f = v16*100/98.0 if aar == 1993
 replace prod_f = v16*100/98.8 if aar == 1994
 replace prod_f = v16*100/99.4 if aar == 1995
replace prod_f = v16*100/100.0 if aar == 1996
replace prod_f = v16*100/101.5 if aar == 1997
replace prod_f = v16*100/102.5 if aar == 1998
replace prod_f = v16*100/105.9 if aar == 1999
replace prod_f = v16*100/111.1 if aar == 2000
replace prod_f = v16*100/111.5 if aar == 2001
replace prod_f = v16*100/108.1 if aar == 2002
replace prod_f = v16*100/109.9 if aar == 2003
replace prod_f = v16*100/116.9 if aar == 2004
replace prod_f = v16*100/124.4 if aar == 2005
label var prod_f "v16 in fixed 1996 prices"

***
* drop negative production
***
drop if prod_f < 0 


*****************************
* find the replacement value of capital
* based on fire insurance value
* only for the end of year 1993, 1994 and 1995
* we are interested in the replacement value in the beginning of the year
* and we have to build up the capital stock and I_K for the whole sample period
*****************************
do "replacev.do"
rename K_mach_bg_fix K_init



*********************************
**  Detects hole in the serie  **
*********************************
sort bnr aar
gen  byte hole = 0

replace   hole = 1 if bnr == bnr[_n-1] & aar != aar[_n-1]+1  
label var hole "1 if aar != aar[_n-1]"

quietly by bnr: gen long bnr2 = bnr*100 + sum(hole)
format bnr2 %9.0f

**********************************************
** Makes a new plant identifier 
** Each of these new plants have a sequence of observations without missing years
**********************************************
sort       bnr2 aar
quietly by bnr2: gen tst_hole = sum(hole)       
replace              tst_hole = -tst_hole if hole == 1

***
* Generate new set of bnr where serie must be continuously (and useable)
***
gen double bnr3 = bnr2*100 + tst_hole
format bnr3 %11.0f


***
* Find max observation per the new bnr (bnr3)
* consecutive observations
***
egen    max_obs = count(bnr3), by(bnr3)
drop if max_obs <= 5


****************************************************************
* The definition of investment has changed over time. 
* Make a definition that IS time-consitent
****************************************************************
gen     I = (v50+v52+v53) - (v64+v66+v67) 
replace I = (v50        ) - (v64        ) if aar == 1996 | aar == 1997 | aar == 1998
replace I = I/0.932 if aar == 1993
replace I = I/0.966 if aar == 1994
replace I = I/0.943 if aar == 1995
replace I = I/1.000 if aar == 1996
replace I = I/1.011 if aar == 1997
replace I = I/1.045 if aar == 1998
replace I = I/1.068 if aar == 1999
replace I = I/1.102 if aar == 2000
replace I = I/1.091 if aar == 2001
replace I = I/1.057 if aar == 2002
replace I = I/1.034 if aar == 2003
replace I = I/1.068 if aar == 2004
replace I = I/1.057 if aar == 2005

*******
* Construct some additional variables
*******
des v38 v11
gen wage_pr_empl = v38/v11

*** 
* use the same price index as for output
***
 replace wage_pr_empl = wage_pr_empl*100/98.0 if aar == 1993
 replace wage_pr_empl = wage_pr_empl*100/98.8 if aar == 1994
 replace wage_pr_empl = wage_pr_empl*100/99.4 if aar == 1995
replace wage_pr_empl = wage_pr_empl*100/100.0 if aar == 1996
replace wage_pr_empl = wage_pr_empl*100/101.5 if aar == 1997
replace wage_pr_empl = wage_pr_empl*100/102.5 if aar == 1998
replace wage_pr_empl = wage_pr_empl*100/105.9 if aar == 1999
replace wage_pr_empl = wage_pr_empl*100/111.1 if aar == 2000
replace wage_pr_empl = wage_pr_empl*100/111.5 if aar == 2001
replace wage_pr_empl = wage_pr_empl*100/108.1 if aar == 2002
replace wage_pr_empl = wage_pr_empl*100/109.9 if aar == 2003
replace wage_pr_empl = wage_pr_empl*100/116.9 if aar == 2004
replace wage_pr_empl = wage_pr_empl*100/124.4 if aar == 2005
label var wage_pr_empl "wage_pr_empl in fixed 1996 prices (1000NOK)"

summ wage_pr_empl, det
summ wage_pr_empl if wage_pr_empl > 50 & wage_pr_empl <= 2000, det
***
* Based on the above 25, 50 and 75 percentiles; Whether we use the cleaning based on 
* these percentiles or percentiles after having deleted obsviously strange obs.
* should not make a big difference
***

tsset bnr aar


***
* construct the difference in nbr. of employees
sort bnr3 aar
bys bnr3: gen dL_L = (v11/v11[_n-1] - 1) if bnr3 == bnr3[_n-1] & aar == aar[_n-1]+1

***
* Now it is about time to find capital 
***
sort bnr3 aar
bys bnr3: gen K = K_init[1] 
quietly by bnr3: replace   K = K[_n-1]*(1-0.10) + I[_n-1] if bnr3 == bnr3[_n-1] & aar == aar[_n-1]+1
gen I_K = I/K

***
* can calculate Y/K
***
gen Y_K = prod_f/K

summ Y_K, det

***
* define some outliers
***
gen byte dont = (prod_f < 0 | K <= 0 | wage_pr_empl < 50 |  wage_pr_empl > 2000 | max_obs < 6 | dL_L < -0.67 | (dL_L > 2 & dL_L != .) | Y_K > 75 | I_K < -0.67 | I_K > 3 ) 

**********************************************
** Makes again plant-specific series without holes (after having removed outliers
**********************************************
sort       bnr3 aar
quietly by bnr3: gen tst_hole2 = sum(dont)       
replace              tst_hole2 = -tst_hole2 if dont == 1

***
* Generate new set of bnr where series must be continuous (and useable)
***
gen double bnr4 = bnr3*100 + tst_hole2
format bnr4 %13.0f

***
* Find max observation per the new bnr (bnr3)
* consecutive observations
***
egen max_obsFine = count(bnr4), by(bnr4)

tabu aar             if max_obsFine >= 6
tabu naer2_bnr       if max_obsFine >= 6
tabu aar max_obsFine if max_obsFine >= 6

summ wage_pr_empl Y_K dL_L I_K if max_obsFine >= 6, det


**********************************************************
* prepare the final dataset
**********************************************************
egen      avr_v11 = mean(v11), by(bnr4)
label var avr_v11  "egen avr_v11 = mean(v11), by(bnr4)"
label var mean_v11 "egen mean_v11 = mean(v11), by(bnr)"

egen      min_v11 = min(v11), by(bnr4)

***
* drop plants that have an avr employemnt over the potential cleaned 
* years (incl. the initial periods) less than 10
* They may have been larger earlier on. This can be seen
* if one looks at mean_v11 which is based on information from
* periods where no data-cleaning has been done
***
drop if avr_v11 < 10
drop if min_v11 < 10

***
* indicator for the first 4 observations in each series of bnr4. These should 
* not be used for the analysis, only for for instance Mundlack variables
***
gen byte frst_obs = (bnr4 != bnr4[_n-1])
sort bnr4 aar
quietly by bnr4: replace frst_obs = frst_obs[_n-1]+1 if bnr4 == bnr4[_n-1]
list bnr bnr4 aar frst_obs if _n<20


***
* The nbr of zeroes
***
count if max_obsFine >= 6
count if max_obsFine >= 6 & I_K == 0

count if dL_L == 0 &  max_obsFine >= 6
count if dL_L != . &  max_obsFine >= 6


summ  bnr bnr2 bnr3 bnr4 aar nbr_obs1 naering naering2 naer2_bnr v11 v13 mean_v11 mode_v11 avr_v11 min_v11 prod_f g I K_init wage_pr_empl dL_L K I_K Y_K max_obsFine frst_obs if max_obsFine >= 6
des   bnr bnr2 bnr3 bnr4 aar nbr_obs1 naering naering2 naer2_bnr v11 v13 mean_v11 mode_v11 avr_v11 min_v11 prod_f g I K_init wage_pr_empl dL_L K I_K Y_K max_obsFine frst_obs 
order bnr bnr2 bnr3 bnr4 aar nbr_obs1 naering naering2 naer2_bnr v11 v13 mean_v11 mode_v11 avr_v11 min_v11 prod_f g I K_init wage_pr_empl dL_L K I_K Y_K max_obsFine frst_obs

keep  bnr bnr2 bnr3 bnr4 aar nbr_obs1 naering naering2 naer2_bnr v11 v13 mean_v11 mode_v11 avr_v11 min_v11 prod_f g I K_init wage_pr_empl dL_L K I_K Y_K max_obsFine frst_obs
keep if max_obsFine >= 6
saveold "interrelated.dta", replace


***********************************
*** Prepare the data for MATLAB ***
***********************************
use "interrelated.dta", clear

* First, drop all variables that won't be used to construct moments.
drop bnr2 bnr3 bnr4 nbr_obs1 naering naering2 naer2_bnr frst_obs max_obsFine wage_pr_empl mean_v11 mode_v11 avr_v11 min_v11 prod_f g

* Drop and define some more variables
gen  Y = Y_K*K
drop Y_K
gen  L = v11
drop v11 v13
gen  H_L = dL_L + .1
drop I K_init
drop if Y == .
drop if K == .
drop if L == .
drop if I_K == . 
drop if H_L == .
drop if Y == 0

* Make sure to use a balanced panel for now.
xtset bnr aar
count
drop if l.Y == . & aar != 1996
drop if l.Y == . & aar != 1996
drop if l.Y == . & aar != 1996
drop if l.Y == . & aar != 1996
drop if l.Y == . & aar != 1996
drop if l.Y == . & aar != 1996
drop if l.Y == . & aar != 1996
drop if l.Y == . & aar != 1996
drop if l.Y == . & aar != 1996
drop if l.Y == . & aar != 1996

drop if f.Y == . & aar != 2005
drop if f.Y == . & aar != 2005
drop if f.Y == . & aar != 2005
drop if f.Y == . & aar != 2005
drop if f.Y == . & aar != 2005
drop if f.Y == . & aar != 2005
drop if f.Y == . & aar != 2005
drop if f.Y == . & aar != 2005
drop if f.Y == . & aar != 2005
drop if f.Y == . & aar != 2005
xtset bnr aar
count

order bnr aar Y K L I_K H_L dL_L
matwrite using "balanced.mat", replace
