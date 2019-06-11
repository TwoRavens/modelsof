/*
** last changes: August 2017  by: J. Spenkuch (j-spenkuch@kellogg.northwestern.edu)
*/

#delim;
clear all;
set more off;
capture log close;
set matsize 11000;
set maxvar 32767;
version 14.2;
set logtype text;
pause on;
set seed 301184;



/**********************************************************
***
***		clean school finance data
***
**********************************************************/;


global PATH "F:\projects\advertising\RD";
global PATHdata "F:\projects\advertising\RD\data";
global PATHcode "F:\projects\advertising\RD\code";
global PATHlogs "F:\projects\advertising\RD\logs";

global GRPfile "R:/Dropbox/research/advertising_paper/analysis/input/grps.dta";



log using $PATHlogs/clean_schools, replace;


/* *** CLEAN DATA *** */;
* ArcGIS FID to DMA crosswalk;
tempfile fid_dma_crosswalk;
clear;
import delimited $PATHdata\crosswalks\FIDtoDMA.csv;

save `fid_dma_crosswalk';

*** GRPs;
tempfile grps_2012;
tempfile grps_2008;
use $GRPfile, clear;

preserve;
keep if year==2012;
keep dma_code cmag_prez_ptyd_base;

rename cmag_prez_ptyd_base ptyd_base_2012;

compress;
save `grps_2012';

restore;
keep if year==2008;
keep dma_code cmag_prez_ptyd_base;

rename cmag_prez_ptyd_base ptyd_base_2008;

compress;
save `grps_2008';

clear;


* distance from school district centroid to nearest DMA border;
import delimited $PATHdata\GISoutput\school_districts_distance_border.txt;
tempfile distances;

keep name10 geoid10 distance_meter left_fid right_fid;
rename geoid10 leaid;

save `distances';
clear;

* DMA in which school district (centroid) is located;
import delimited $PATHdata\GISoutput\school_districts_dma.txt;
tempfile home_dma;

keep name10 geoid10 id;
rename geoid10 leaid;
rename id DMA;

save `home_dma';
clear;


* school district finance data;
import delimited "$PATHdata/schools_data/school district finance/SDF091a.txt", delimiter(tab);

merge 1:1 leaid using `distances', keepusing(distance_meter left_fid right_fid);
keep if _merge==3; drop _merge;

merge 1:1 leaid using `home_dma', keepusing(DMA);
keep if _merge==3; drop _merge;
rename DMA DMAown;


*  advertising measures & DMA codes;
rename left_fid fid;
merge m:1 fid using `fid_dma_crosswalk', keepusing(dma_code);
drop if _merge==2;
drop _merge;
replace dma_code=. if DMAown==dma_code;
drop fid;

rename right_fid fid;
merge m:1 fid using `fid_dma_crosswalk', keepusing(dma_code) update;
drop if _merge==2;
drop _merge;
rename dma_code DMAother;
drop fid;

rename DMAother dma_code;
merge m:1 dma_code using `grps_2012', keepusing(ptyd_base_2012);
keep if _merge==3; drop _merge;
rename dma_code DMAother;
foreach v in ptyd_base_2012 {;
	rename `v' r_`v'_other;
};
rename DMAown dma_code;
merge m:1 dma_code using `grps_2012', keepusing(ptyd_base_2012);
keep if _merge==3; drop _merge;
rename dma_code DMAown;
foreach v in ptyd_base_2012 {;
	rename `v' r_`v'_own;
};

rename DMAother dma_code;
merge m:1 dma_code using `grps_2008', keepusing(ptyd_base_2008);
keep if _merge==3; drop _merge;
rename dma_code DMAother;
foreach v in ptyd_base_2008 {;
	rename `v' r_`v'_other;
};
rename DMAown dma_code;
merge m:1 dma_code using `grps_2008', keepusing(ptyd_base_2008);
keep if _merge==3; drop _merge;
rename dma_code DMAown;
foreach v in ptyd_base_2008 {;
	rename `v' r_`v'_own;
};



	* recode distance into "directional" measure based on sign of "GRP difference";
forvalues y=2008(4)2012 {;	
	foreach grp in ptyd_base {;
		gen r_D_`grp'_`y'=distance*(r_`grp'_`y'_own>r_`grp'_`y'_other) - distance*(r_`grp'_`y'_own<r_`grp'_`y'_other) if distance>0;
		gen r_MD_`grp'_`y'=0;
		replace r_MD_`grp'_`y'=1 if r_`grp'_`y'_own==r_`grp'_`y'_other | distance<=0 | mi(r_`grp'_`y'_other) | mi(r_`grp'_`y'_own);
		replace r_D_`grp'_`y'=0 if r_MD_`grp'_`y'==1;
		assert (r_D_`grp'_`y'==0 & r_MD_`grp'_`y'==1) | (r_D_`grp'_`y'!=0 & r_MD_`grp'_`y'==0);
	};
};
drop r_*other r_*own;
reshape long r_D_ptyd_base_ r_MD_ptyd_base_, i(leaid) j(YEAR);
rename r_D_ptyd_base_ r_D_ptyd_base;
rename r_MD_ptyd_base_ r_MD_ptyd_base;



* school district "quality" measures;
gen r_numstudents=v33 if v33>0;
gen r_Mnumstudents=(v33<=0);
replace r_numstudents=0 if r_Mnumstudents==1;
assert !mi(r_numstudents) & r_numstudents>=0;

gen r_cur_exp=tcurelsc if tcurelsc>0;
gen r_Mcur_exp=(tcurelsc<=0);
replace r_cur_exp=0 if r_Mcur_exp==1;
assert !mi(r_cur_exp) & r_cur_exp>=0;

gen r_cur_exp_ps=r_cur_exp/r_numstudents if r_Mnumstudents==0 & r_Mcur_exp==0;
gen r_Mcur_exp_ps=(r_Mnumstudents==1 | r_Mcur_exp==1);
replace r_cur_exp_ps=0 if r_Mcur_exp_ps==1;
assert !mi(r_cur_exp_ps) & r_cur_exp_ps>=0;

gen r_ln_cur_exp_ps=log(r_cur_exp_ps);
gen r_Mln_cur_exp_ps=r_Mcur_exp_ps;



* type of school system;
gen ELEMENTARY=(schlev==1);
gen SECONDARY=(schlev==2);
gen COMBINED=(schlev==3);


* create additional variables for RD;
gen T=(r_D_ptyd_base>0);

gen distance1=r_D_ptyd_base;
gen distance2= r_D_ptyd_base^2;
gen distance3= r_D_ptyd_base^3;
gen distance4= r_D_ptyd_base^4;

gen  T_x_distance1= T*r_D_ptyd_base;
gen  T_x_distance2= T*r_D_ptyd_base^2;
gen  T_x_distance3= T*r_D_ptyd_base^3;
gen  T_x_distance4= T*r_D_ptyd_base^4;



* border segment ID;
gen dummy1=DMAown*(DMAown>DMAother) + DMAother*(DMAown<DMAother);
gen dummy2=DMAown*(DMAown<DMAother) + DMAother*(DMAown>DMAother);
egen BORDER=group(dummy1 dummy2 stabbr);
egen BORDER_YEAR=group(dummy1 dummy2 stabbr YEAR ELEMENTARY SECONDARY COMBINED);
drop dummy*;

egen STATE=group(stabbr);

drop if r_MD_ptyd_base==1;
keep ELEMENTARY SECONDARY COMBINED BORDER* STATE T r_*  *distance*;


save $PATHdata/schools, replace;

log close;
