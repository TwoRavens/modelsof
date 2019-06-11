/*
** last changes: August 2017  by: J. Spenkuch (j-spenkuch@kellogg.northwestern.edu)
*/
if c(os) == "Unix" {
	global PATH "/projects/p30061"
	global PATHdata "/projects/p30061/data"
	global PATHcode "/projects/p30061/code"
	global PATHlogs "/projects/p30061/logs"
	
	cd $PATH
}
else if c(os) == "Windows" {
	global PATH "R:/Dropbox/research/advertising_paper/analysis"
	global PATHdata "R:/Dropbox/research/advertising_paper/analysis/input"
	global PATHcode "R:/Dropbox/research/advertising_paper/analysis/code"
	global PATHlogs "R:/Dropbox/research/advertising_paper/output"
	
	cd $PATH
}
else {
    display "unable to recognize OS -> abort!"
    exit
}

include code/preamble_clean.do

#delim;

/**********************************************************
***
***		clean & assemble home value data
***
**********************************************************/;

cd $PATHcode;


global GRPfile "$PATHdata/grps.dta";

global GRPs "ptyd_base"; 
global STUBS "r_ptyd_base_own_ r_D_ptyd_base_ r_MD_ptyd_base_";

global STATES "AK AL AR AZ CA CO CT DE FL GA HI IA ID IL IN KS KY LA MA MD ME MI MN MO MT MS NC ND NE NJ NH NM NV NY OH OK OR PA RI SD SC TN TX UT VA VT WV WA WI WY DC";


log using $PATHlogs/clean_dataquick.txt, replace;



/* *** ASSEMBLE DATA *** */;

*** ArcGIS FID to DMA crosswalk;
tempfile fid_dma_crosswalk;
clear;
import delimited $PATHdata/crosswalks/FIDtoDMA.csv;

save `fid_dma_crosswalk';

*** FIPS to DMA crosswalk;
tempfile fips_dma_crosswalk;
clear;
import delimited $PATHdata/crosswalks/fips_dma.csv;
duplicates drop fips, force;
save `fips_dma_crosswalk';


*** GRPs;
tempfile grps_2012;
tempfile grps_2008;
use $GRPfile, clear;

preserve;
keep if year==2012;

rename cmag_prez_ptyd_base ptyd_base;

keep dma_code $GRPs;
 
compress;
save `grps_2012';

restore;
keep if year==2008;

rename cmag_prez_ptyd_base ptyd_base;

keep dma_code $GRPs;

compress;
save `grps_2008';



*** merge ArcGIS output with vote histories & ad measures;
foreach s in $STATES {;

	tempfile temp`s';
	
	di "STATE: `s'";
	
	clear;
	import delimited "$PATHdata/GIS/output/`s'_dataquick.csv";
	
	
	***  add measures & DMA codes;
	rename id DMAown;
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
	
	forvalues y=2008(4)2012 {;
		rename DMAother dma_code;
		merge m:1 dma_code using `grps_`y'', keepusing($GRPs);
		drop if _merge==2; drop _merge;
		rename dma_code DMAother;
		foreach v in $GRPs {;
			rename `v' r_`v'_other_`y';
		};
		rename DMAown dma_code;
		merge m:1 dma_code using `grps_`y'', keepusing($GRPs);
		drop if _merge==2; drop _merge;
		rename dma_code DMAown;
		foreach v in $GRPs {;
			rename `v' r_`v'_own_`y';
		};
	};
	
	
	* recode distance into "directional" measure based on sign of "GRP difference";
	forvalues y=2008(4)2012 {;	
		foreach grp in ptyd_base {;
			gen r_D_`grp'_`y'=distance*(r_`grp'_own_`y'>r_`grp'_other_`y') - distance*(r_`grp'_own_`y'<r_`grp'_other_`y') if distance>0;
			gen r_MD_`grp'_`y'=0;
			replace r_MD_`grp'_`y'=1 if r_`grp'_own_`y'==r_`grp'_other_`y' | distance<=0 | mi(r_`grp'_other_`y') | mi(r_`grp'_own_`y');
			replace r_D_`grp'_`y'=0 if r_MD_`grp'_`y'==1;
			assert (r_D_`grp'_`y'==0 & r_MD_`grp'_`y'==1) | (r_D_`grp'_`y'!=0 & r_MD_`grp'_`y'==0);
		};
	
	drop r*_other_`y';
	};
	
	gen r_distance=distance if distance>0;
	gen r_Mdistance=(distance<=0);
	replace r_distance=0 if r_Mdistance==1;
	assert r_distance>=0;
	
	
	reshape long $STUBS, i(sa_property_id) j(YEAR);

	foreach stub in $STUBS {;
		
		local l = strlen("`stub'") -1;
		local vname = substr("`stub'",1,`l');
		rename `stub' `vname';
		
	};

	
	keep sa_property_id r_* DMA*;
	
	save `temp`s'';
};

clear;

foreach s in $STATES {;
    
    append using `temp`s'';
};

merge m:1 sa_property_id using $PATHdata/temp/dataquick_values.dta;
drop _merge;

rename mm_state_code STATE;

gen dummy1=DMAown*(DMAown>DMAother) + DMAother*(DMAown<DMAother);
gen dummy2=DMAown*(DMAown<DMAother) + DMAother*(DMAown>DMAother);
egen BORDER=group(dummy1 dummy2 STATE);
drop dummy*;


compress;

save $PATHdata/dataquick.dta, replace;

