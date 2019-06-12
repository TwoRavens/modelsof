**  ConMooAJPS
 use "ConMooLogit.dta", clear

 gen ccode = cowccode
drop if cowccode==.
 sort ccode year
merge m:1 ccode using cites.dta 
drop if _m==2 
drop _merge

gen cites = year>=citesyr

sort id year

btscs no_tort year cowccode, g(spellcount) f

gen spellcount2=spellcount*spellcount

gen spellcount3=spellcount2*spellcount

gen study = ""
foreach n in orig noth fe time fet ct yfe cyfe {
gen method_`n' = ""
gen dv_`n' = ""
gen b_cites_`n' = .
gen se_cites_`n'= .
gen pval_cites_`n' = .
gen lo_cites_`n'=.
gen hi_cites_`n'=.
gen N_cites_`n'=.
}
gen studynum=.
gen timetrend=""
qui do cites.do
local ii = 1
logit no_tort cites aclpreg polconv speech threat2 ngoprc lag_intensity haz_weibull loggdpflL1 logpopflL1 ///
	  civil3 spellcount spellcount2 spellcount3, cluster(cowccode)
cites `ii' orig
logit no_tort cites aclpreg polconv speech threat2 ngoprc lag_intensity haz_weibull loggdpflL1 logpopflL1 ///
      civil3 , cluster(cowccode)
cites `ii' noth
xtlogit no_tort cites aclpreg polconv speech threat2 ngoprc lag_intensity haz_weibull loggdpflL1 logpopflL1 ///
	  civil3 , fe
cites `ii' fe
logit no_tort cites aclpreg polconv speech threat2 ngoprc lag_intensity haz_weibull loggdpflL1 logpopflL1 ///
	  civil3 spellcount spellcount2 spellcount3, cluster(cowccode)
cites `ii' time
xtlogit no_tort cites aclpreg polconv speech threat2 ngoprc lag_intensity haz_weibull loggdpflL1 logpopflL1 ///
	  civil3 spellcount spellcount2 spellcount3 , fe
cites `ii' fet
logit no_tort cites aclpreg polconv speech threat2 ngoprc lag_intensity haz_weibull loggdpflL1 logpopflL1 ///
	  civil3 spellcount spellcount2 spellcount3 i.cowccode#c.year , cluster(cowccode)
cites `ii' ct
xtreg no_tort cites aclpreg polconv speech threat2 ngoprc lag_intensity haz_weibull loggdpflL1 logpopflL1 ///
	  civil3 i.year , fe vce(cl ccode)
cites `ii' cyfe
clogit no_tort cites aclpreg polconv speech threat2 ngoprc lag_intensity haz_weibull loggdpflL1 logpopflL1 ///
	  civil3  , group(year) vce(cl year)
cites `ii' yfe
replace studynum = `ii' if _n==`ii'   
replace timetrend="splines" if _n==`ii'
local ii=`ii'+1
*************************************************************
*   Using Threat Coded as 1 if Banks or Uppsala Coded 1     *
*************************************************************

logit no_tort cites aclpreg polconv speech UPPSALA_BANKS ngoprc lag_intensity haz_weibull loggdpflL1 logpopflL1 ///
	  civil3 spellcount spellcount2 spellcount3, cluster(cowccode)
cites `ii' orig
logit no_tort cites aclpreg polconv speech UPPSALA_BANKS ngoprc lag_intensity haz_weibull loggdpflL1 logpopflL1 ///
	  civil3 , cluster(cowccode)
cites `ii' noth
xtlogit no_tort cites aclpreg polconv speech UPPSALA_BANKS ngoprc lag_intensity haz_weibull loggdpflL1 logpopflL1 ///
	  civil3 ,  fe
     cites `ii' fe
logit no_tort cites aclpreg polconv speech UPPSALA_BANKS ngoprc lag_intensity haz_weibull loggdpflL1 logpopflL1 ///
	  civil3 spellcount spellcount2 spellcount3, cluster(cowccode)
cites `ii' time
xtlogit no_tort cites aclpreg polconv speech UPPSALA_BANKS ngoprc lag_intensity haz_weibull loggdpflL1 logpopflL1 ///
	  civil3 spellcount spellcount2 spellcount3 ,  fe
cites `ii' fet
logit no_tort cites aclpreg polconv speech UPPSALA_BANKS ngoprc lag_intensity haz_weibull loggdpflL1 logpopflL1 ///
	  civil3 spellcount spellcount2 spellcount3 i.cowccode#c.year , cluster(cowccode)
cites `ii' ct
clogit no_tort cites aclpreg polconv speech UPPSALA_BANKS ngoprc lag_intensity haz_weibull loggdpflL1 logpopflL1 ///
	  civil3  ,  group(year) vce(cl year)
cites `ii' yfe
xtreg no_tort cites aclpreg polconv speech UPPSALA_BANKS ngoprc lag_intensity haz_weibull loggdpflL1 logpopflL1 ///
	  civil3 i.year ,  fe vce(cl ccode)
cites `ii' cyfe
replace studynum = `ii' if _n==`ii'   
replace timetrend="splines" if _n==`ii'
local ii=`ii'+1   
*************************************************************
*     Using Threat Coded as 1 if COW or Uppsala Coded 1     *
*************************************************************

gen COW_UPPSALA=.
replace COW_UPPSALA=1 if warinci==1
replace COW_UPPSALA=1 if warst2==1
replace COW_UPPSALA=1 if atwar2==1
replace COW_UPPSALA=0 if atwar2==0 & warst2==0 & warinci==0

logit no_tort cites aclpreg polconv speech COW_UPPSALA ngoprc lag_intensity haz_weibull loggdpflL1 logpopflL1 ///
	  civil3 spellcount spellcount2 spellcount3, cluster(cowccode)
cites `ii' orig
logit no_tort cites aclpreg polconv speech COW_UPPSALA ngoprc lag_intensity haz_weibull loggdpflL1 logpopflL1 ///
	  civil3 , cluster(cowccode)
cites `ii' noth
xtlogit no_tort cites aclpreg polconv speech COW_UPPSALA ngoprc lag_intensity haz_weibull loggdpflL1 logpopflL1 ///
	  civil3 , fe
cites `ii' fe
logit no_tort cites aclpreg polconv speech COW_UPPSALA ngoprc lag_intensity haz_weibull loggdpflL1 logpopflL1 ///
	  civil3 spellcount spellcount2 spellcount3, cluster(cowccode)
cites `ii' time
xtlogit no_tort cites aclpreg polconv speech COW_UPPSALA ngoprc lag_intensity haz_weibull loggdpflL1 logpopflL1 ///
	  civil3 spellcount spellcount2 spellcount3 , fe
cites `ii' fet
logit no_tort cites aclpreg polconv speech COW_UPPSALA ngoprc lag_intensity haz_weibull loggdpflL1 logpopflL1 ///
	  civil3 spellcount spellcount2 spellcount3 i.cowccode#c.year, cluster(cowccode)
cites `ii' ct
xtreg no_tort cites aclpreg polconv speech COW_UPPSALA ngoprc lag_intensity haz_weibull loggdpflL1 logpopflL1 ///
	  civil3 i.year , fe vce(cl ccode)
cites `ii' cyfe
clogit no_tort cites aclpreg polconv speech COW_UPPSALA ngoprc lag_intensity haz_weibull loggdpflL1 logpopflL1 ///
	  civil3 , group(year) vce(cl year)
cites `ii' yfe
replace studynum = `ii' if _n==`ii'   
replace timetrend="splines" if _n==`ii'
local ii=`ii'+1
	
replace study = "Conrad Moore" if studynum~=. 	
keep study-timetrend
drop if studynum==.
compress
save conmoo.dta , replace

use "ConMooMNL.dta", clear

gen ccode = cowccode
drop if cowccode==.
 sort ccode year
merge m:1 ccode using cites.dta 
drop if _m==2 
drop _merge

gen cites = year>=citesyr

sort id year

btscs no_tort year cowccode, g(spellcount) f
gen spellcount2=spellcount*spellcount

gen spellcount3=spellcount2*spellcount
gen study = ""
foreach n in orig noth fe time fet ct yfe cyfe {
gen method_`n' = ""
gen dv_`n' = ""
gen b_cites_`n' = .
gen se_cites_`n'= .
gen pval_cites_`n' = .
gen lo_cites_`n'=.
gen hi_cites_`n'=.
}
gen studynum=.
gen timetrend=""

qui do cites.do
local ii = 1
mlogit StopTort cites aclpreg polconv speech ///
	    ngoprc lag_intensity haz_weibull ///
        loggdpflL1 logpopflL1 ///
	    civil3 ///
        gdpgrowth milper ///
        spellcount spellcount2 spellcount3, cluster(cowccode)
replace b_cites_orig= _b[1:cites] if _n==`ii'
replace se_cites_orig = _se[1:cites]  if _n==`ii'
replace pval_cites_orig= 2*normal(-abs(_b[1:cites]/_se[1:cites]))  if _n==`ii'
replace method_orig = "`e(cmd)'" if _n==`ii'
replace dv_orig = "`:word 2 of `e(cmdline)''" if _n==`ii'
replace lo_cites_orig = _b[1:cites]-(_se[1:cites]*invnormal(.975)) if _n==`ii'
replace hi_cites_orig = _b[1:cites]+(_se[1:cites]*invnormal(.975)) if _n==`ii'    
replace studynum = `ii'+3 if _n==`ii'   
replace timetrend="splines" if _n==`ii'

local ii=`ii'+1

replace b_cites_orig= _b[2:cites] if _n==`ii'
replace se_cites_orig = _se[2:cites]  if _n==`ii'
replace pval_cites_orig= 2*normal(-abs(_b[2:cites]/_se[2:cites]))  if _n==`ii'
replace method_orig = "`e(cmd)'" if _n==`ii'
replace dv_orig = "`:word 2 of `e(cmdline)''" if _n==`ii'
replace lo_cites_orig = _b[2:cites]-(_se[2:cites]*invnormal(.975)) if _n==`ii'
replace hi_cites_orig = _b[2:cites]+(_se[2:cites]*invnormal(.975)) if _n==`ii'  
replace studynum = `ii'+3 if _n==`ii'   
replace timetrend="splines" if _n==`ii'

replace study = "Conrad Moore" if studynum~=. 	

keep study-timetrend
drop if studynum==.
compress
append using conmoo.dta
save conmoo.dta , replace
