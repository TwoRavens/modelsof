#delimit ;
clear all;
set mem 600m;
set more off;
* Replace with your local working directory name;
local dir "C:\Users\hchor\Documents\Projects\InstEd\wvsmerge\Replication";
cd "`dir'";

use csesmerge_RESTAT_replication.dta, clear;
sort countrywave;
egen countrywave2=group(countrywave);
drop countrywave;
rename countrywave2 countrywave;
iis countrywave;
cap drop edX*;
cap drop incX*;

local varname "pop1564 arable_pop1564 hcap wdigdppcus K62s_pop1564 skprem130 skprem133 food3_merexp ores3_merexp";
local varname2 "gini_di democ";

foreach x of local varname {; 
	* cap drop l`x';
	cap drop l`x'_lag;
	* gen l`x' = ln(`x');
	gen l`x'_lag = ln(`x'_lag);
	* gen edXl`x' = education*l`x';
	gen edXl`x'_lag = education*l`x'_lag;
};

foreach x of local varname2 {; 
	* gen edX`x' = education*`x';
	gen edX`x'_lag = education*`x'_lag;
};


local varname3 "elf_eth socialist mean_obed_work compul_vote3";
foreach x of local varname3 {;
	gen edX`x' = education*`x';
};
compress;


sort isocode wave;
xi, prefix(_W) i.countrywave;


local baselinecontrols "age agesq gender dum_married nchild dum_student dum_emp incomequint education";
local factorinteractions "edXlarable_pop1564_lag edXlK62s_pop1564_lag edXlhcap_lag";
local scaleinteractions "edXlwdigdppcus_lag edXlpop1564_lag";
local auxillaryinteractions "edXlwdigdppcus_lag edXlpop1564_lag edXmean_obed_work edXgini_di_lag edXelf_eth edXdemoc_lag edXsocialist";
local defoptions "bdec(3,3) coefastr se 3aster bracket nocons 
		addstat("No. of countries", e(N_clust))";
local ofile Table4356_CSES.out;
local logfile Table4356_CSES.log;
local depvar vote;


cap erase `ofile';
cap erase `logfile';
cap log close;

log using "`logfile'", replace;

	* Trim datasets of observations that will not be in the sample, to make the program run faster;
	foreach x of local baselinecontrols {;
		cap drop if `x'==.;
	};
	
	
	
	* TABLE 4 SPECIFICATIONS;
	
	display "*(i) Baseline: Individual controls only";
	cap noisily ologit `depvar' `baselinecontrols' _W* if missing==0, cluster(country); 
	cap noisily outreg `baselinecontrols' using `ofile', replace `defoptions' ctitle(i);
	
	display "*(ii) All factor endowment relevant variables";
	cap noisily ologit `depvar' `baselinecontrols' `factorinteractions' _W* if missing==0, cluster(country); 
	cap noisily outreg `baselinecontrols' `factorinteractions' using `ofile', append `defoptions' ctitle(ii);
	
	/* Generating dummy for outliers to be excluded later */
	cap drop insample;
	cap drop first;
	gen insample = 1 if e(sample);
	bysort countrywave insample: gen first=1 if _n==1 & insample==1;

	cap drop outlier;
	gen outlier = 0;
	local factors "larable_pop1564_lag lK62s_pop1564_lag lhcap_lag";
	foreach f of local factors {;
		summ `f' if first==1, det;
		replace outlier=1 if abs((`f' - r(mean))/r(sd))>3 & abs((`f' - r(mean))/r(sd))~=.;
		tab isocode if outlier==1;
	};
	/* No outliers */
	
	display "*(iii) Add compulsory voting interaction";
	cap noisily ologit `depvar' `baselinecontrols' `factorinteractions' edXcompul _W* if missing==0, cluster(country); 
	cap noisily outreg `baselinecontrols' `factorinteractions' edXcompul using `ofile', append `defoptions' ctitle(iii);
	
	display "*(iv) Add both edXlwdigdppcus_lag and edXlpop1564_lag";
	cap noisily ologit `depvar' `baselinecontrols' `factorinteractions' `scaleinteractions' edXcompul _W* if missing==0, cluster(country); 
	cap noisily outreg `baselinecontrols' `factorinteractions' `scaleinteractions' edXcompul using `ofile', append `defoptions' ctitle(iv);
	
	display "*(v) Add all auxillary education interactions";
	cap noisily ologit `depvar' `baselinecontrols' `factorinteractions' `auxillaryinteractions' edXcompul _W* if missing==0, cluster(country); 
	cap noisily outreg `baselinecontrols' `factorinteractions' `auxillaryinteractions' edXcompul using `ofile', append `defoptions' ctitle(v);
	
	/* Generating countrywave interacted with income quintile */
	xi, prefix(_D) i.countrywave*incomequint;
	drop _Dcountrywa*;
	
	display "*(vi) Add income interactions";
	cap noisily ologit `depvar' `baselinecontrols' `factorinteractions' `auxillaryinteractions' edXcompul _DcouX* _W* if missing==0, cluster(country); 
	cap noisily outreg `baselinecontrols' `factorinteractions' `auxillaryinteractions' edXcompul using `ofile', append `defoptions' ctitle(vi);
	
	display "*(vii) Glaeser, Shapiro, Ponzetto treatment for missing individual characteristics";
	cap noisily ologit `depvar' `baselinecontrols' `factorinteractions' `auxillaryinteractions' edXcompul missing_* _DcouX* _W*, cluster(country); 
	cap noisily outreg `baselinecontrols' `factorinteractions' `auxillaryinteractions' edXcompul using `ofile', append `defoptions' ctitle(vii);	
	
	replace occupation = . if (occupation==97 | occupation==98 | occupation==99);
	gen occupation3 = floor(occupation/10);
	replace occupation3 = 10 if occupation==.;
	xi, prefix(_O3) i.occupation3;
	
	display "*(viii) Occupation dummies";
	cap noisily ologit `depvar' `baselinecontrols' `factorinteractions' `auxillaryinteractions' edXcompul missing_* _O3* _DcouX* _W*, cluster(country); 
	cap noisily outreg `baselinecontrols' `factorinteractions' `auxillaryinteractions' edXcompul using `ofile', append `defoptions' ctitle(viii);	
	
	
	
	* TABLE 3 SPECIFICATIONS: CSES by wave;
	
	display "*(3v) Wave==1";
	cap noisily ologit `depvar' `baselinecontrols' `factorinteractions' edXcompul _W* if missing==0 & wave==1, cluster(country); 
	cap noisily outreg `baselinecontrols' `factorinteractions' edXcompul using `ofile', append `defoptions' ctitle(3v);
	
	display "*(3vi) Wave==1";
	cap noisily ologit `depvar' `baselinecontrols' `factorinteractions' `auxillaryinteractions' edXcompul missing_* _DcouX* _W* if wave==1, cluster(country); 
	cap noisily outreg `baselinecontrols' `factorinteractions' `auxillaryinteractions' edXcompul using `ofile', append `defoptions' ctitle(3vi);	
	
	display "*(3vii) Wave==2";
	cap noisily ologit `depvar' `baselinecontrols' `factorinteractions' edXcompul _W* if missing==0 & wave==2, cluster(country); 
	cap noisily outreg `baselinecontrols' `factorinteractions' edXcompul using `ofile', append `defoptions' ctitle(3vii);
	
	display "*(3viii) Wave==2";
	cap noisily ologit `depvar' `baselinecontrols' `factorinteractions' `auxillaryinteractions' edXcompul missing_* _DcouX* _W* if wave==2, cluster(country); 
	cap noisily outreg `baselinecontrols' `factorinteractions' `auxillaryinteractions' edXcompul using `ofile', append `defoptions' ctitle(3viii);	
	
	

	* TABLE 5 SPECIFICATIONS: SKILL PREMIUM;
	
	foreach n of numlist 130 133 {;
	
	display "*(5v) Skill premium `n': Baseline specification";
	cap noisily ologit `depvar' `baselinecontrols' edXlskprem`n'_lag edXcompul _W* if missing==0, 
		cluster(country); 
	cap noisily outreg `baselinecontrols' edXlskprem`n'_lag edXcompul using `ofile', 
		append `defoptions' ctitle(5v);
		
	display "*(5vi) Skill premium `n': With factor endowment interactions";
	cap noisily ologit `depvar' `baselinecontrols' edXlskprem`n'_lag `factorinteractions' edXcompul _W* if missing==0, 
		cluster(country); 
	cap noisily outreg `baselinecontrols' edXlskprem`n'_lag `factorinteractions' edXcompul using `ofile', 
		append `defoptions' ctitle(5vi);
				
	};
	
	
		
	* TABLE 6 SPECIFICATIONS: Food and ores exports;
	
	display "*(6v) Baseline specification";
	cap noisily ologit `depvar' `baselinecontrols' edXlfood3_merexp_lag edXlores3_merexp_lag edXcompul _W* if missing==0, 
		cluster(country); 
	cap noisily outreg `baselinecontrols' edXlfood3_merexp_lag edXlores3_merexp_lag edXcompul using `ofile', 
		append `defoptions' ctitle(6v);
		
	display "*(6vi) With factor endowment interactions";
	cap noisily ologit `depvar' `baselinecontrols' edXlfood3_merexp_lag edXlores3_merexp_lag `factorinteractions' edXcompul _W* if missing==0, 
		cluster(country); 
	cap noisily outreg `baselinecontrols' edXlfood3_merexp_lag edXlores3_merexp_lag `factorinteractions' edXcompul using `ofile', 
		append `defoptions' ctitle(6vi);
	
	
log close;



	

	


	

	

