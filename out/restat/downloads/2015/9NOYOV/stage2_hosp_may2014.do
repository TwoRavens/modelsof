/* stage2_hosp_may2014 */
/* this is an updated version of the code for productivity paper */
/* that makes the adoption factors. Now makes 2 factors */
/* derived from stage2_hosp_june08.do */
/* doug staiger & jon skinner */
/* original do file: 29th mar 2007 */
/* revised 14 mar to create cov model */
/* revised 29 Mar / 29 Nov */
/* revised 3 june 2008, and renamed stage2_hosp_june08 */
/* program to create dataset for productivity paper */

/* set variables in two factor models here as globals */
global goodstuff "asahosp betahosp reper12"
global badstuff "cabg30d latepci lidohosp"
clear all
capture log close
cd "/Volumes/JSS/Staiger Productivity"
* cd "C:\projects\nia\productivity"
log using stage2_hosp_may2014, text replace
set mem 300m
set matsize 800
set more off
/* this global determines the minimum size threshold */

global cut_ccp=5

use "/Volumes/JSS/Staiger Productivity/fe_ami_hosp_86_nov07.dta"

keep if year==1994
destring provider, replace
keep provider
sort provider
save id_insamp_86, replace

/* now read in the ccp data & create the adoption measures, and limit sample to those insamp */
clear all
use "/Volumes/JSS/CCP data/Data/ccp_cohort.dta", clear

sort provider
merge provider using id_insamp_86
tab _merge
keep if _merge==3
drop _merge

gen reper12 = max(thr12,ptca12)
gen latepci=pci30d
replace latepci=0 if pci30d==1 & ptca12==1
gen num_proc=0
gen num_proc_oth_all=0
gen num_proc_oth_select=0
gen cath_index=0
gen cabg_index=0
gen pci_index=0
gen stent_index=0
forval i=1/6 {
replace num_proc=num_proc+1 if proc`i'!=""
#delimit ;
replace num_proc_oth_all=num_proc_oth_all+1 if proc`i'!="" 
 & proc`i'!="3601"
 & proc`i'!="3602"
 & proc`i'!="3605"
 & proc`i'!="3606"
 & proc`i'!="3607"
 & proc`i'!="3610"
 & proc`i'!="3611"
 & proc`i'!="3612"
 & proc`i'!="3613"
 & proc`i'!="3614"
 & proc`i'!="3615"
 & proc`i'!="3616"
 & proc`i'!="3617"
 & proc`i'!="3618"
 & proc`i'!="3619"
 & proc`i'!="3721"
 & proc`i'!="3722"
 & proc`i'!="3723";
replace num_proc_oth_select=num_proc_oth_select+1 if  
   proc`i'=="3761"
 | proc`i'=="3778"
 | proc`i'=="3954"
 | proc`i'=="3964"
 | proc`i'=="9604"
 | proc`i'=="9671"
 | proc`i'=="9672"
 | proc`i'=="9904"
 ;

replace cath_index=1 if
   proc`i'=="3721"
 | proc`i'=="3722"
 | proc`i'=="3723";
replace cabg_index=1 if
   proc`i'=="3610"
 | proc`i'=="3611"
 | proc`i'=="3612"
 | proc`i'=="3613"
 | proc`i'=="3614"
 | proc`i'=="3615"
 | proc`i'=="3616"
 | proc`i'=="3617"
 | proc`i'=="3618"
 | proc`i'=="3619";
replace pci_index=1 if
   proc`i'=="3601"
 | proc`i'=="3602"
 | proc`i'=="3605"
 | proc`i'=="3606"
 | proc`i'=="3607";
replace stent_index=1 if
   proc`i'=="3606";
 
#delimit cr
}
foreach v in $goodstuff $badstuff {
 drop if `v'==.
 }
save ccp_temp, replace

keep provider $goodstuff $badstuff majteach black rl6inab
gen nobs=1
summ
collapse (count) nobs (mean) $goodstuff $badstuff majteach black rl6inab, by(provider)
sort provider

keep  if nobs>=$cut_ccp
sort provider
save ccp_hosp_rates, replace

/* estimate factor models with hosp data */
use ccp_hosp_rates, clear
/* summary stats unweighted */
summ 
/* summary stats weighted */
summ [aw=nobs]

/* do factor analysis in levels */
factor $goodstuff [aw=nobs], fact(1)
predict f_level1
/* this shows how factor combines the 3 measures */
reg f_level1 $goodstuff
/* this shows how factor is correlated with the 3 measures */
corr f_level1 $goodstuff [aw=nobs]
pwcorr f_level1 $goodstuff [aw=nobs], sig

factor $badstuff [aw=nobs], fact(1)
predict f_level2
/* this shows how factor combines the 3 measures */
reg f_level2 $badstuff
/* this shows how factor is correlated with the 3 measures */
corr f_level2 $badstuff [aw=nobs]
pwcorr f_level2 $badstuff [aw=nobs], sig

/* do joint factor model to compare */
/* could do promax or varimax rotation and get similar results */
factor $goodstuff $badstuff [aw=nobs], fact(2)
rotate, varimax
*rotate, promax
predict f_joint*
screeplot, mean
estat factors
matrix list e(r_Phi)
corr f_joint* [aw=nobs]
/* look at correlation of common factor estimates across the methods */
corr f_* $goodstuff $badstuff
/* TABLE 1A: CORRELATION BETWEEN FACTORS AND MEASURES IN CCP DATA, PATIENT WEIGHTED */
corr f_joint1 f_joint2 $goodstuff $badstuff [aw=nobs]
pwcorr f_joint1 f_joint2 $goodstuff $badstuff [aw=nobs], sig



/* construct quintiles & see how adoption varies by quintile */

foreach f in f_level1 f_level2 {
 xtile `f'_5 = `f' [aw=nobs], nq(5)
 foreach y in  $goodstuff $badstuff majteach black nobs {
  tab `f'_5 [aw=nobs], summ(`y')
  tab `f'_5, summ(`y')
 }
}
drop f_level1_5 f_level2_5

/* keep provider f_level* f_ln* f_ln_cox* nobs */
keep provider f_level* f_joint* $goodstuff $badstuff rl6inab nobs
sort provider
save ccp_factors_hosp, replace


/* now merge fe & factor data at hospital level */
/* first make aha ownership data */
clear all
use aha94
gen provider=real(hcfaid)
drop hcfaid
gen forprof=(cntrl>=31 & cntrl<=33)
gen govt=((cntrl>=11 & cntrl<=16)|(cntrl>=41 & cntrl<=48))
sort provider
save aha94_1, replace

/*  first merge on hrr */

use "/Volumes/JSS/Staiger Productivity/fe_ami_hosp_86_nov07", clear
destring provider, replace
sort provider
merge provider using hosp94_to_hrr.dta
tab _merge
drop if _merge==2
drop _merge

/* merge on the ccp hospital data */
sort provider
merge provider using ccp_factors_hosp
tab _merge
keep if _merge==3
drop _merge
/* merge on hospital ownership */
sort provider
merge provider using aha94_1
tab _merge
drop if _merge==2
drop _merge
* merge on drug-eluting stent data
sort provider
merge provider using des_rates
tab _merge
drop if _merge==2
drop _merge

/* construct quintiles & see how adoption varies by quintile */

foreach f in f_level1 f_joint1 f_joint2 avdif {
 xtile `f'_5 = `f' [aw=nobs_], nq(5)
 tab `f'_5
 tab `f'_5 [aw=nobs_]
}


/* save the final analysis dataset */
save analysis_1986_2_2014, replace
/* create data with just the quintiles, to merge back below */
keep provider f_level1_5 f_joint1_5 f_joint2_5
collapse (mean) f_level1_5 f_joint1_5 f_joint2_5, by(provider)
save analysis_quintiles, replace

/* create means by quintile for table 1a */
use ccp_temp, clear
keep provider admdate hrr majteach asahosp betahosp reper12 cabg30d latepci lidohosp
gen year=1994 if admdate<12784
replace year=1995 if admdate>=12784
tab year, m
* Merge income data
sort hrr
merge hrr using "/Volumes/jss/Staiger Productivity/hrr_names.dta"
tab _merge 
drop _merge
rename hrrstate state
sort state year
merge state year using "/Volumes/jss/Staiger Productivity/state_year_inc.dta"
tab _merge
drop if _merge==2
drop _merge
/* merge on hospital ownership */
sort provider
merge provider using aha94_1
tab _merge
drop if _merge==2
drop _merge
* merge on drug-eluting stent data
sort provider
merge provider using des_rates
tab _merge
drop if _merge==2
drop _merge
gen has_avdif=(avdif!=.)
* merge on quintiles
sort provider
merge provider using analysis_quintiles
tab _merge
drop if _merge==2
drop _merge
egen nobs=count(provider), by(provider)

foreach y in $goodstuff $badstuff nobs majteach forprof govt income has_avdif avdif {
  tab f_level1_5, summ(`y')
  tab f_joint1_5, summ(`y')
  tab f_joint2_5, summ(`y')
 }
 
log close
