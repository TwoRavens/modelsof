***** Distelhorst and Hou 2016 JoP *****

* constsvc_jop_repl.do
* Replicates empirical results reported in:
*   "Constituency Service Under Nondemocratic Rule: Evidence from China"
*   Greg Distelhorst and Yue Hou
*   Journal of Politics

* Thanks to Manfred Elfstrom, Jeremy Wallace, and Jessica Weiss for sharing their data on labor strikes and local anti-foreign protests.

* Elfstrom, Manfred. 2012. China Strikes [Computer File]. Available at: https://chinastrikes.crowdmap.com.

* Wallace, J.L. and Weiss, J.C., 2015. The Political Geography of Nationalist Protest in China: Cities and the 2012 Anti-Japanese Protests. The China Quarterly, 222, pp.403-429.

* Updated September 30, 2016

* outreg2 required
* . ssc install outreg2

* Using KRLS with outreg2:
* The ereturn values for KRLS do not align with outreg2
* The following programs store KRLS ereturn values in a format outreg2 can handle
* They can only be defined once; if running the .do file a second time, delete these programs first, using: program drop krls_e krls_r krlsout


program krls_e, eclass
 mat myOut = e(Output)
 mat myB = e(b)
 mat mySE = myOut[1..rowsof(myOut),2]
 mat mySE = diag(mySE)
 mat myV = mySE*mySE
 local mydep = "KRLS: "+ e(depvar)
 local myR2 = e(R2)
 local myN = r(N)
 ereturn post myB myV, depname("`mydep'")
 ereturn scalar r2 = `myR2' 
 ereturn scalar N= `myN'
end

program krls_r, rclass
 scalar myN = r(N)
 return scalar N=myN
end

program krlsout
 krls_e
 krls_r
end
 
log using replication_constituency.txt, replace text

clear 
set more off
use constsvc_jop_repl.dta

global MAIN primary lstrikes lpcnet lpcgovrev

* Five waves of studies, wave4 used as reference
global WAVE_D wave1 wave2 wave3 wave5

* Randomized treatments from five studies; wave 3 had two
global TREATMENT_D treatment_w1 treatment_w2 treatment_w3_1 treatment_w3_2 treatment_w4 treatment_w5

* Education variables:
global EDU1 edu_spending
global EDU2 edu_schools
global EDU3 edu_teachers

set seed 1


******************************
* Table 2: Field audits (China results)
*****************************

* How many letters received helpful replies?
tab disc_per

*************************
* Table 3: Predictors of const service quality in China
*************************
global OPT cl(prefnum) 
global OUTREG_OPT tex replace

* Col 1-5
reg disc_per primary $WAVE_D $TREATMENT_D, $OPT
outreg2 using Table3, $OUTREG_OPT
reg disc_per lstrikes $WAVE_D $TREATMENT_D, $OPT
outreg2
reg disc_per lpcnet $WAVE_D $TREATMENT_D, $OPT
outreg2
reg disc_per lpcgovrev $WAVE_D $TREATMENT_D, $OPT
outreg2
reg disc_per $MAIN $WAVE_D $TREATMENT_D, $OPT
outreg2
reg disc_per $MAIN $WAVE_D $TREATMENT_D provnum2-provnum31, $OPT
outreg2

* Col 6-8
krls disc_per $MAIN $WAVE_D $TREATMENT_D
krlsout
outreg2
krls disc_per $MAIN $WAVE_D $TREATMENT_D provnum2-provnum31
krlsout
outreg2


*********************************************************
* Online Appendix
********************************************************** 

* Table A1: Summary Statistics
sum primary strikes lstrikes pcnet lpcnet pcgovrev lpcgovrev if submit_dummy==1

* Table A2: Service quality by audit wave
* (Observation counts also appear in Table 1)

tabstat reply_per, by(wave) stat(n mean) format(%6.3f) 
tabstat disc_per, by(wave) stat(n mean) format(%6.3f) 

* Table A3: Robustness: Logit
reg disc_per $MAIN $WAVE_D $TREATMENT_D, $OPT
outreg2 using TableA3, $OUTREG_OPT
logit disc_per $MAIN $WAVE_D $TREATMENT_D, cl(prefnum)
outreg2
reg disc_per $MAIN $WAVE_D $TREATMENT_D provnum2-provnum31, $OPT
outreg2
clogit disc_per $MAIN $WAVE_D $TREATMENT_D, group(provnum)
outreg2

* Table A4: Robustness: Alternative measure of state capacity
reg disc_per primary lstrikes lpcnet lpcgovexp $WAVE_D $TREATMENT_D provnum2-provnum31, cl(prefnum)
outreg2 using TableA4, $OUTREG_OPT
krls disc_per primary lstrikes lpcnet lpcgovexp $WAVE_D $TREATMENT_D provnum2-provnum31
krlsout
outreg2
reg disc_per primary lstrikes lpcnet publicm_p  $WAVE_D $TREATMENT_D provnum2-provnum31, cl(prefnum)
outreg2
krls disc_per primary lstrikes lpcnet publicm_p $WAVE_D $TREATMENT_D provnum2-provnum31
krlsout
outreg2

* Table A5: Robustness: models with GDP measures
reg disc_per $MAIN lgrp $WAVE_D $TREATMENT_D provnum2-provnum31, $OPT
outreg2 using TableA5, $OUTREG_OPT
krls disc_per $MAIN lgrp $WAVE_D $TREATMENT_D provnum2-provnum31
krlsout
outreg2
reg disc_per $MAIN lpcgrp $WAVE_D $TREATMENT_D provnum2-provnum31, $OPT
outreg2
krls disc_per $MAIN lpcgrp $WAVE_D $TREATMENT_D provnum2-provnum31
krlsout
outreg2

* Table A6: Robustness: alternative measure of social conflict: 
* Local protest data from: 
* Jeremy Wallace & Jessic Weiss (2014) 
* "The Political Geography of Nationalist Protest in China"
reg disc_per primary protestcount lpcnet lpcgovrev $WAVE_D $TREATMENT_D provnum2-provnum31, $OPT
outreg2 using TableA6, $OUTREG_OPT
krls disc_per primary protestcount lpcnet lpcgovrev $WAVE_D $TREATMENT_D provnum2-provnum31
krlsout
outreg2
reg disc_per primary lprotest lpcnet lpcgovrev $WAVE_D $TREATMENT_D provnum2-provnum31, $OPT
outreg2
krls disc_per primary lprotest lpcnet lpcgovrev $WAVE_D $TREATMENT_D provnum2-provnum31
krlsout
outreg2

* Table A7: Robustness: unlogged measures in KRLS
krls disc_per primary strikes pcnet pcgovrev $WAVE_D $TREATMENT_D 
krlsout
outreg2 using TableA7, $OUTREG_OPT
krls disc_per primary strikes pcnet pcgovrev $WAVE_D $TREATMENT_D provnum2-provnum31 
krlsout
outreg2

* Table A8: Robustness: Adding education controls
reg disc_per $MAIN $EDU1 $WAVE_D $TREATMENT_D provnum2-provnum31, $OPT
outreg2 using TableA8, $OUTREG_OPT
krls disc_per $MAIN $EDU1 $WAVE_D $TREATMENT_D provnum2-provnum31
krlsout
outreg2
reg disc_per $MAIN $EDU2 $WAVE_D $TREATMENT_D provnum2-provnum31, $OPT
outreg2
krls disc_per $MAIN $EDU2 $WAVE_D $TREATMENT_D provnum2-provnum31
krlsout
outreg2
reg disc_per $MAIN $EDU3 $WAVE_D $TREATMENT_D provnum2-provnum31, $OPT
outreg2
krls disc_per $MAIN $EDU3 $WAVE_D $TREATMENT_D provnum2-provnum31
krlsout
outreg2

* Table A9: Robustness: Using primary_workers and primary_workers_share instead of primary 
reg disc_per primary_empl_share  $WAVE_D $TREATMENT_D, $OPT
outreg2 using TableA9, $OUTREG_OPT
reg disc_per primary_empl_share lstrikes lpcnet lpcgovrev $WAVE_D $TREATMENT_D, $OPT
outreg2
krls disc_per primary_empl_share lstrikes lpcnet lpcgovrev $WAVE_D $TREATMENT_D
krlsout
outreg2
reg disc_per primary_empl_share lstrikes lpcnet lpcgovrev $WAVE_D $TREATMENT_D provnum2-provnum31, $OPT
outreg2
krls disc_per primary_empl_share lstrikes lpcnet lpcgovrev $WAVE_D $TREATMENT_D provnum2-provnum31
krlsout
outreg2
 
* Table A10: Robustness: measure replies, do not screen "non-helpful" replies 
reg reply_per $MAIN $WAVE_D $TREATMENT_D, $OPT
outreg2 using TableA10, $OUTREG_OPT
krls reply_per $MAIN $WAVE_D $TREATMENT_D 
krlsout
outreg2
reg reply_per $MAIN $WAVE_D $TREATMENT_D provnum2-provnum31, $OPT
outreg2
krls reply_per $MAIN $WAVE_D $TREATMENT_D provnum2-provnum31
krlsout
outreg2

* Table A11: Robustness: recoding "non-helpful" replies as missing
reg disc_per_recode $MAIN $WAVE_D $TREATMENT_D provnum2-provnum31, cl(prefnum) 
outreg2 using TableA11, $OUTREG_OPT
krls disc_per_recode $MAIN $WAVE_D $TREATMENT_D provnum2-provnum31
krlsout
outreg2
reg reply_per_recode $MAIN $WAVE_D $TREATMENT_D provnum2-provnum31, cl(prefnum) 
outreg2
krls reply_per_recode $MAIN $WAVE_D $TREATMENT_D provnum2-provnum31
krlsout
outreg2

log close
