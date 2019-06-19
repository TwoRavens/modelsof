global x "$masterpath/datafiles/prices/"
global y "$masterpath/datafiles/"
global z "$masterpath/outfiles/prices/"
global a "$masterpath/figures/"

# delimit ;
clear;
set mem 2250m;
set matsize 2000;
set more off;
capture log close;
global path ~/research;

********************************************************;
* Purpose: 	Occupation-Specific GRH Regressions 	*;
* Author: 	Shannon Phillips & Avi Ebenstein		*;
* Date: 	December 2009					*;
********************************************************;

log using ${z}ll.log, replace;
**************************************************************************;
* Bring in occupation-specific measure of exportables versus importables *;
* just as we did for the offshoring and the trade measures. 		     *;
**************************************************************************;
use ${y}offshore_exposure.dta, clear;
collapse expfin1_effective impfin1_effective, by(occ8090 year) fast; 
sort occ8090 year;
merge occ8090 year using ${x}premium_occ8090_all.dta;  
sort occ8090 year;
tab _merge;
keep if _merge==1|_merge==3;


gen unskillemp=(1-higheduc)*emp_cps;
gen skillemp  =higheduc*emp_cps;
label variable unskillemp "Total # low skill (high school degree or less) workers in occupation";
label variable skillemp "Total # high skill (some college or more) workers in occupation";

bysort occ8090 year: gen I=(lowincemp+highincemp)/(unskillemp+lowincemp+highincemp);
label variable I "% of routine (i.e. low-skill) tasks performed offshore, as share of total low skill tasks performed both at home and abroad";

bysort occ8090 year: gen I_low=lowincemp/(unskillemp+lowincemp);
label variable I_low "% of routine (i.e. low-skill) tasks performed offshore in LWC, as share of total low skill tasks performed both at home and abroad in LWC";

bysort occ8090 year: gen I_high=highincemp/(skillemp+highincemp);
label variable I_high "% of tasks performed offshore in HWC, as share of total high skill tasks performed both at home and abroad in HWC";
capture drop _merge;
sort occ8090;
save $masterpath/datafiles/figure_wageprem, replace;
