#delimit ;
clear all;
set mem 600m;
set more off;
* Replace with your local working directory name;
local dir "C:\Users\hchor\Documents\Projects\InstEd\wvsmerge\Replication";
cd "`dir'";

use wvsmerge_RESTAT_replication.dta, clear;
iis countrywave;
cap drop edX*;
cap drop incX*;

local varname "pop1564 arable_pop1564 hcap wdigdppcus K62s_pop1564";
local varname2 "gini_di democ";

foreach x of local varname {; 
	cap drop l`x';
	cap drop l`x'_lag;
	gen l`x' = ln(`x');
	gen l`x'_lag = ln(`x'_lag);
	gen edXl`x' = education*l`x';
	gen edXl`x'_lag = education*l`x'_lag;
};

foreach x of local varname2 {; 
	gen edX`x' = education*`x';
	gen edX`x'_lag = education*`x'_lag;
};


local varname3 "elf_eth socialist mean_obed_work";
foreach x of local varname3 {;
	gen edX`x' = education*`x';
};
compress;

**************************************************;
* Individual political participation measures     ;
**************************************************;

sort isocode wave;

local baselinecontrols "age agesq gender dum_married nchild dum_student dum_emp incomedec education";
local factorinteractions "edXlarable_pop1564_lag edXlK62s_pop1564_lag edXlhcap_lag";
local scaleinteractions "edXlwdigdppcus_lag edXlpop1564_lag";
local auxillaryinteractions "edXlwdigdppcus_lag edXlpop1564_lag edXmean_obed_work edXgini_di_lag edXelf_eth edXdemoc_lag edXsocialist";
local defoptions "bdec(3,3) coefastr se 3aster bracket nocons 
		addstat("No. of countries", e(N_clust) , "No. of surveys" , e(df_a)+1 )";
local ofile Table2.out;
local logfile Table2.log;

cap erase `ofile';
cap erase `logfile';
cap log close;

log using "`logfile'", replace;

	* Trim datasets of observations that will not be in the sample, to make the program run faster;
	foreach x of local baselinecontrols {;
		cap drop if `x'==.;
	};
	cap drop if larable_pop1564_lag==. & lK62s_pop1564_lag==. & lhcap_lag==.;


	* Initialize the out file;
	quietly areg interest_polm `baselinecontrols' if missing==0, absorb(countrywave) cluster(country); 
	outreg `baselinecontrols' using `ofile', replace `defoptions' ctitle(base);
	
	/* Generating countrywave interacted with income decile */
	xi, prefix(_D) i.countrywave*incomedec;
	drop _Dcountrywa*;

	* TABLE 2 SPECIFICATIONS: OLS;
	
	local depvarlist "interest_polm imp_pol discuss_pol demonstr petition";
	
	foreach depvar of local depvarlist {;

	display "*(i) All factor endowment relevant variables";
	areg `depvar' `baselinecontrols' `factorinteractions' if missing==0, 
		absorb(countrywave) cluster(country); 
	outreg `baselinecontrols' `factorinteractions' using `ofile', 
		append `defoptions' ctitle(`depvar');
		
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
	
	display "*(ii) Full specification";
	areg `depvar' `baselinecontrols' `factorinteractions' `auxillaryinteractions' missing_* _DcouX* if outlier~=1, 
		absorb(countrywave) cluster(country); 
	outreg `baselinecontrols' `factorinteractions' `auxillaryinteractions' using `ofile', 
		append `defoptions' ctitle(`depvar');
	
	};
	
		
	* TABLE 2 SPECIFICATIONS: ordered logit;
	
	local defoptions "bdec(3,3) coefastr se 3aster bracket nocons addstat("No. of countries", e(N_clust))";
	
	sort isocode wave;
	xi, prefix(_W) i.countrywave;	

	foreach depvar of local depvarlist {;
	
	display "*(i) All factor endowment relevant variables";
	ologit `depvar' `baselinecontrols' `factorinteractions' _W* if missing==0, cluster(country); 
	outreg `baselinecontrols' `factorinteractions' using `ofile', append `defoptions' ctitle(`depvar');
		
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
	
	display "*(ii) Full specification";
	ologit `depvar' `baselinecontrols' `factorinteractions' `auxillaryinteractions' missing_* _DcouX* _W* if outlier~=1, 
		cluster(country); 
	outreg `baselinecontrols' `factorinteractions' `auxillaryinteractions' using `ofile', 
		append `defoptions' ctitle(`depvar');

	};

log close;

