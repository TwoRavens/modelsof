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
collapse expfin1_effective impfin1_effective, by(occ8090 year); 
sort occ8090 year;
merge occ8090 year using ${x}premium_occ8090_all.dta;  
sort occ8090 year;
tab _merge;
keep if _merge==3;
drop _merge;

gen unskillemp=(1-higheduc)*emp_cps;
gen skillemp  =higheduc*emp_cps;
label variable unskillemp "Total # low skill (high school degree or less) workers in occupation";
label variable skillemp "Total # high skill (some college or more) workers in occupation";

bysort occ8090 year: gen I=(lowincemp+highincemp)/(unskillemp+lowincemp+highincemp);
label variable I "% of routine (i.e. low-skill) tasks performed offshore, as share of total low skill tasks performed both at home and abroad";

bysort occ8090 year: gen I_low=lowincemp/(skillemp+lowincemp);
label variable I_low "% of routine (i.e. low-skill) tasks performed offshore in LWC, as share of total low skill tasks performed both at home and abroad in LWC";

bysort occ8090 year: gen I_high=highincemp/(skillemp+highincemp);
label variable I_high "% of tasks performed offshore in HWC, as share of total high skill tasks performed both at home and abroad in HWC";

bysort occ8090: gen p_I=I[_n-1];
gen dI=I-p_I;
gen dI1_I=dI/(1-I);

bysort occ8090: gen p_I_low=I_low[_n-1];
gen dI_low=I_low-p_I_low;
gen dI1_I_low=dI_low/(1-I_low);

bysort occ8090: gen p_I_high=I_high[_n-1];
gen dI_high=I_high-p_I_high;
gen dI1_I_high=dI_high/(1-I_high);

sort occ8090 year;
bysort occ8090: gen p_lwageres_unskill=lwageres_unskill[_n-1];
**********Use this one;
gen dlwageres_unskill=lwageres_unskill-p_lwageres_unskill;

bysort occ8090: gen p_lwageres_skill=lwageres_skill[_n-1];
gen dlwageres_skill=lwageres_skill-p_lwageres_skill;

bysort occ8090: gen p_lwageres=lwageres[_n-1];
gen dlwageres=lwageres-p_lwageres;

collapse dlwageres dlwageres_unskill routine I dI1_I, by(occ8090);

twoway (scatter dlwageres routine) (lfit dlwageres routine), title("Occupational Wage Premium Changes, by Routine") saving(${a}figure_wageprem_occ, replace);
*twoway (scatter dlwageres_unskill routine) (lfit dlwageres_unskill routine), saving(${a}figure_wageprem_occ, replace);
*twoway (scatter dlwageres_unskill dI1_I) (lfit dlwageres_unskill dI1_I), saving(${a}figure_wageprem_occ, replace);
*twoway (scatter dlwageres_unskill I) (lfit dlwageres_unskill I), saving(${a}figure_wageprem_occ, replace);



use $masterpath/datafiles/premium_ind7090, clear;
gen routine=(finger + sts)/(finger + sts + math + dcp + ehf);

sort ind7090 year;
bysort ind7090: gen p_lwageres=myresid[_n-1];
**********Use this one;
gen dlwageres=myresid-p_lwageres;

collapse dlwageres routine, by(ind7090);
twoway (scatter dlwageres routine) (lfit dlwageres routine), title("Industry Wage Premium Changes, by Routine. All Industries") saving(${a}figure_wageprem_ind, replace);




use $masterpath/datafiles/premium_man7090, clear;
gen routine=(finger + sts)/(finger + sts + math + dcp + ehf);

sort man7090 year;
bysort man7090: gen p_lwageres=myresid[_n-1];
**********Use this one;
gen dlwageres=myresid-p_lwageres;

collapse dlwageres routine, by(man7090);
twoway (scatter dlwageres routine) (lfit dlwageres routine), title("Industry Wage Premium Changes, by Routine. Only Mfg") saving(${a}figure_wageprem_mfg, replace);

exit;