/*
The program computes straight-line distance from hs campus to college of attendance.
The main files:
(1)   HS graduation files from Nighthawk
(2)   Distance metrics from my RAs directory
*/

clear
#delimit;
set mem 1g ;
set more off;

global d1="${col_remediation}program/program_paco/publication/"; 
do ${d1}do/top_program.do; 

log using "${d1}log/distancesubgroup.log", replace;

* generate data set of altpid and campus codes - 1991 to 2001;
use "${nh_data}TEA_PEIMS/Grad/Grad1991.dta", clear;
forvalues year = 1992/2001 {;
	append using "${nh_data}TEA_PEIMS/Grad/Grad`year'.dta";
};
rename ssn altpid;
rename ethnic grad_eth;
rename sex grad_sex;
keep altpid campus grad_eth grad_sex;
duplicates drop altpid, force;
sort altpid;

merge altpid using "${d1}data/tasp192_200_withall_tmp.dta", sort;
tab _merge;
keep if _merge==2 | _merge==3;
gen vm_dist=((grad_eth==ethnic_rep2)+(grad_sex==sex_rep2))>=2;
rename school fice_n;
drop grad_eth grad_sex _merge;
sort campus fice_n;
save "${d1}data/new/tasp192_200_withall_isaac.dta", replace; /* eventually save to paco directory */

*  SUBROUTINE TO COMPUTE DISTANCES;
/*
	Distances available only from high schools from 1998 to 2002
*/

use "${d1}jbourdier/hs_cc_1998_l.dta", clear;
forvalues year = 1999/2001 {;
	append using "${d1}jbourdier/hs_cc_`year'_l.dta";
}; /* close loop */
duplicates report fice_n campus;
duplicates drop fice_n campus, force;
save "${d1}data/new/hs_cc_98_01.dta", replace;

* hs distance to all sr colleges;
use "${d1}jbourdier/hs_u_1998_l.dta", clear;
forvalues year = 1999/2001 {;
	append using "${d1}jbourdier/hs_u_`year'_l.dta";
}; /* close loop */
duplicates report fice_n campus;
duplicates drop fice_n campus, force;
save "${d1}data/new/hs_u_98_01.dta", replace;

append using "${d1}data/new/hs_cc_98_01.dta";
sort campus fice_n;
save "${d1}data/new/hs_cc_u_98_01.dta", replace;

* merge distances with main dataset;
merge campus fice_n using "${d1}data/new/tasp192_200_withall_isaac.dta";
tab _merge;
keep if _merge==2 | _merge==3;

* generate distance dummies for dist bw hs campus and college campus;
* less than 25miles;
gen dist25=distance<=25; /* conventional wisdom for commuting distance */
* more than 50miles;
gen dist50=distance>=50; /* would likely have to commit to moving away from family */
label var dist25 "college < 25mi (straight-line) from hs campus";
label var dist50 "college > 50mi (straight-line) from hs campus";

save "${d1}data/new/tasp192_200_withall_isaac.dta", replace;

log close;