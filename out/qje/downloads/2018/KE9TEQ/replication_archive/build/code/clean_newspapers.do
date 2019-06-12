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
***		clean newspaper circulation data
***
**********************************************************/;


global PATH "F:\projects\advertising\RD";
global PATHdata "F:\projects\advertising\RD\data";
global PATHcode "F:\projects\advertising\RD\code";
global PATHlogs "F:\projects\advertising\RD\logs";

global GRPfile "R:/Dropbox/research/advertising_paper/analysis/input/grps.dta";



log using $PATHlogs/clean_newspapers, replace;

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


* distance from ZIP centroid to nearest DMA border;
import delimited $PATHdata\newspaper_data\distances_zip.txt;
tempfile distances;

keep zip distance_meter left_fid right_fid;
duplicates drop zip, force;

save `distances';
clear;

* DMA in which ZIP (centroid) is located;
import delimited $PATHdata\newspaper_data\dma_zip.txt;
tempfile home_dma;

keep zip id;
rename id DMA;
duplicates drop zip, force;

save `home_dma';
clear;




*** newspaper circulation data;
import delimited $PATHdata\newspaper_data\newspapers_zip.csv;

keep membernumber zipcode zipstate averageprojcirc hshd;

rename membernumber PAPER;
rename zipcode zip;
rename zipstate STATE;
rename averageprojcirc circulation;
rename hshd households;

replace circulation=subinstr(circulation,",","",.);
replace households=subinstr(households,",","",.);
destring circulation, replace;
destring households, replace;



collapse (median) households (max) circulation (firstnm) STATE, by(zip PAPER);
fillin PAPER zip;


replace circulation=0 if mi(circulation);
by zip, sort: egen hh=max(households); drop households;

gen r_circ_hh=circulation/hh;
gen r_Mcirc_hh=(r_circ_hh<0 | r_circ_hh>1 | mi(r_circ_hh));
replace r_circ_hh=0 if r_Mcirc_hh==1;


* merge in GIS data;
merge m:1 zip using `distances', keepusing(distance_meter left_fid right_fid);
keep if _merge==3; drop _merge;

merge m:1 zip using `home_dma', keepusing(DMA);
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
reshape long r_D_ptyd_base_ r_MD_ptyd_base_, i(PAPER zip) j(YEAR);
rename r_D_ptyd_base_ r_D_ptyd_base;
rename r_MD_ptyd_base_ r_MD_ptyd_base;



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
egen BORDER=group(dummy1 dummy2 STATE);
drop dummy*;
egen BORDER_PAPER_YEAR=group(BORDER PAPER YEAR);

drop if r_MD_ptyd_base==1;
keep PAPER STATE BORDER* T r_*  *distance*;


save $PATHdata/newspapers, replace;


log close;









