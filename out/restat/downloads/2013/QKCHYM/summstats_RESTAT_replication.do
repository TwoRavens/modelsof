# delimit ;
clear all;
set mem 600m;
set more off;
* Replace with your local working directory name;
local dir "C:\Users\hchor\Documents\Projects\InstEd\wvsmerge\Replication";
cd "`dir'";

***************************************;
* Appendix Tables: Summary Statistics *;
***************************************;

* WVS first;
use wvsmerge_RESTAT_replication.dta, clear;
iis countrywave;
cap drop edX*;
cap drop incX*;

pca interest_polm imp_pol discuss_pol demonstr petition;
predict pc1b, score;

local varname "arable_pop1564 hcap K62s_pop1564 pop1564 wdigdppcus food3_merexp ores3_merexp skprem130 skprem133";
foreach x of local varname {; 
	* cap drop l`x';
	cap drop l`x'_lag;
	* gen l`x' = ln(`x');
	gen l`x'_lag = ln(`x'_lag);
	* gen edX`x' = education*`x';
	gen edX`x'_lag = education*`x'_lag;
	* gen edXl`x' = education*l`x';
	gen edXl`x'_lag = education*l`x'_lag;
};


local depvar pc1b;

local baselinecontrols "age agesq gender dum_married nchild dum_student dum_emp incomedec education";

	cap log close;
	cap erase summstats_RESTAT_replication.log;
	log using summstats_RESTAT_replication.log, replace;
	cap drop insample;
	cap drop first; 
	gen insample=2;
	
	areg `depvar' `baselinecontrols' edXlarable_pop1564_lag edXlK62s_pop1564_lag edXlhcap_lag, absorb(countrywave) cluster(country); 
	replace insample=1 if e(sample);
	tab isocode wave if insample==1;
	
	gen first=.;	
	sort countrywave insample;
	bysort countrywave: replace first=1 if _n==1;
	count if insample==1 & first==1;

	local depvarlist "interest_polm imp_pol discuss_pol demonstr petition pc1b";
	foreach x of local depvarlist {;
		cap drop mean_`x';
		bysort countrywave: egen mean_`x' = mean(`x') if insample==1;
		summ mean_`x' if insample==1 & first==1, det;
	};

	foreach x of local baselinecontrols {;
		cap drop mean_`x';
		bysort countrywave: egen mean_`x' = mean(`x') if insample==1;
		summ mean_`x' if insample==1 & first==1, det;
	};
	
	summ larable_pop1564_lag if insample==1 & first==1, det;
	summ lK62s_pop1564_lag if insample==1 & first==1, det;
	summ lhcap_lag if insample==1 & first==1, det;
	summ lwdigdppcus_lag if insample==1 & first==1, det;
	summ lpop1564_lag if insample==1 & first==1, det;
	summ gini_di_lag if insample==1 & first==1, det;
	summ elf_eth if insample==1 & first==1, det;
	summ democ_lag if insample==1 & first==1, det;
	summ socialist if insample==1 & first==1, det;
	summ mean_obed_work if insample==1 & first==1, det;

	summ lfood3_merexp_lag if insample==1 & first==1, det;
	summ lores3_merexp_lag if insample==1 & first==1, det;
	summ lskprem130_lag if insample==1 & first==1, det;
	summ lskprem133_lag if insample==1 & first==1, det;



log close;
	
	
* CSES;
use csesmerge_RESTAT_replication.dta, clear;
sort countrywave;
egen countrywave2=group(countrywave);
drop countrywave;
rename countrywave2 countrywave;
iis countrywave;
cap drop edX*;
cap drop incX*;

local varname "arable_pop1564 hcap K62s_pop1564 pop1564 wdigdppcus food3_merexp ores3_merexp skprem130 skprem133";
foreach x of local varname {; 
	* cap drop l`x';
	cap drop l`x'_lag;
	* gen l`x' = ln(`x');
	gen l`x'_lag = ln(`x'_lag);
	* gen edX`x' = education*`x';
	gen edX`x'_lag = education*`x'_lag;
	* gen edXl`x' = education*l`x';
	gen edXl`x'_lag = education*l`x'_lag;
};

local varname2 "compul_vote3";
foreach x of local varname2 {;
	cap drop edX`x';
	gen edX`x' = education*`x';
};

sort isocode wave;
xi, prefix(_W) i.countrywave;

local depvar vote;

local baselinecontrols "age agesq gender dum_married nchild dum_student dum_emp incomequint education";


	log using summstats_RESTAT_replication.log, append;
	cap drop insample;
	cap drop first; 
	gen insample=2;
	
	ologit `depvar' `baselinecontrols' edXlarable_pop1564_lag edXlK62s_pop1564_lag edXlhcap_lag edXcompul _W*, cluster(country); 
	replace insample=1 if e(sample);
	tab isocode wave if insample==1;
	
	gen first=.;	
	sort countrywave insample;
	bysort countrywave: replace first=1 if _n==1;
	count if insample==1 & first==1;
	
	local depvarlist "vote";
	foreach x of local depvarlist {;
		cap drop mean_`x';
		bysort countrywave: egen mean_`x' = mean(`x') if insample==1;
		summ mean_`x' if insample==1 & first==1, det;
	};
	
	foreach x of local baselinecontrols {;
		cap drop mean_`x';
		bysort countrywave: egen mean_`x' = mean(`x') if insample==1;
		summ mean_`x' if insample==1 & first==1, det;
	};
	
	summ larable_pop1564_lag if insample==1 & first==1, det;
	summ lK62s_pop1564_lag if insample==1 & first==1, det;
	summ lhcap_lag if insample==1 & first==1, det;
	summ lwdigdppcus_lag if insample==1 & first==1, det;
	summ lpop1564_lag if insample==1 & first==1, det;
	summ gini_di_lag if insample==1 & first==1, det;
	summ elf_eth if insample==1 & first==1, det;
	summ democ_lag if insample==1 & first==1, det;
	summ socialist if insample==1 & first==1, det;
	summ mean_obed_work if insample==1 & first==1, det;

	summ compul_vote3 if insample==1 & first==1, det;
	summ lfood3_merexp_lag if insample==1 & first==1, det;
	summ lores3_merexp_lag if insample==1 & first==1, det;
	summ lskprem130_lag if insample==1 & first==1, det;
	summ lskprem133_lag if insample==1 & first==1, det;



log close;


