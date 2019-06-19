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


local varname3 "elf_eth socialist mean_obed_work";
foreach x of local varname3 {;
	gen edX`x' = education*`x';
};
compress;


*******************************************;
* Generating principal components         *;
*******************************************;

pca interest_polm imp_pol discuss_pol demonstr petition;
predict pc1b, score;

sort isocode wave;

local baselinecontrols "age agesq gender dum_married nchild dum_student dum_emp incomedec education";
local factorinteractions "edXlarable_pop1564_lag edXlK62s_pop1564_lag edXlhcap_lag";
local scaleinteractions "edXlwdigdppcus_lag edXlpop1564_lag";
local auxillaryinteractions "edXlwdigdppcus_lag edXlpop1564_lag edXmean_obed_work edXgini_di_lag edXelf_eth edXdemoc_lag edXsocialist";
local defoptions "bdec(3,3) coefastr se 3aster bracket nocons 
		addstat("No. of countries", e(N_clust) , "No. of surveys" , e(df_a)+1 )";
local ofile Table13567_WVS.out;
local logfile Table13567_WVS.log;
local depvar pc1b;

cap erase `ofile';
cap erase `logfile';
cap log close;

log using "`logfile'", replace;	

	* Trim datasets of observations that will not be in the sample, to make the program run faster;
	foreach x of local baselinecontrols {;
		cap drop if `x'==.;
	};



	* TABLE 1 SPECIFICATIONS;

	display "*(i) Baseline: Individual controls only";
	areg `depvar' `baselinecontrols' if missing==0, absorb(countrywave) cluster(country); 
	outreg `baselinecontrols' using `ofile', replace `defoptions' ctitle(i);
	
	display "*(ii) All factor endowment relevant variables";
	areg `depvar' `baselinecontrols' `factorinteractions' if missing==0, 
		absorb(countrywave) cluster(country); 
	outreg `baselinecontrols' `factorinteractions' using `ofile', 
		append `defoptions' ctitle(ii);
		
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
	
	display "*(iii) Drop outliers";
	areg `depvar' `baselinecontrols' `factorinteractions' if missing==0 & outlier~=1, 
		absorb(countrywave) cluster(country); 
	outreg `baselinecontrols' `factorinteractions' using `ofile', 
		append `defoptions' ctitle(iii);
		
	display "*(iv) Add both edXlwdigdppcus_lag and edXlpop1564_lag";
	areg `depvar' `baselinecontrols' `factorinteractions' `scaleinteractions' if missing==0 & outlier~=1, 
		absorb(countrywave) cluster(country); 
	outreg `baselinecontrols' `factorinteractions' `scaleinteractions' using `ofile', 
		append `defoptions' ctitle(iv);
	
	display "*(v) Add all auxillary education interactions";
	areg `depvar' `baselinecontrols' `factorinteractions' `auxillaryinteractions' if missing==0 & outlier~=1, 
		absorb(countrywave) cluster(country); 
	outreg `baselinecontrols' `factorinteractions' `auxillaryinteractions' using `ofile', 
		append `defoptions' ctitle(v);
		
	/* Generating countrywave interacted with income decile */
	xi, prefix(_D) i.countrywave*incomedec;
	drop _Dcountrywa*;
	
	display "*(vi) Add income interactions";
	areg `depvar' `baselinecontrols' `factorinteractions' `auxillaryinteractions' _DcouX* if missing==0 & outlier~=1, 
		absorb(countrywave) cluster(country); 
	outreg `baselinecontrols' `factorinteractions' `auxillaryinteractions' using `ofile', 
		append `defoptions' ctitle(vi);
		
	display "*(vii) Glaeser, Shapiro, Ponzetto treatment for missing individual characteristics";
	areg `depvar' `baselinecontrols' `factorinteractions' `auxillaryinteractions' missing_* _DcouX* if outlier~=1, 
		absorb(countrywave) cluster(country); 
	outreg `baselinecontrols' `factorinteractions' `auxillaryinteractions' using `ofile', 
		append `defoptions' ctitle(vii);
	
	
	/* Calculating the main effect of education */ 
	cap drop insample;
	cap drop first;
	gen insample = 1 if e(sample);
	bysort countrywave insample: gen first=1 if _n==1 & insample==1;
	local ctyvar "larable_pop1564_lag lK62s_pop1564_lag lhcap_lag lwdigdppcus_lag lpop1564_lag 
		mean_obed_work gini_di_lag elf_eth democ_lag socialist";
	foreach v of local ctyvar {;
		summ `v' if first==1, det;
		local `v'_med = r(p50);
	};
	local edeffect = _b[education] + _b[edXlarable_pop1564_lag]*`larable_pop1564_lag_med' + _b[edXlK62s_pop1564_lag]*`lK62s_pop1564_lag_med' 
						+ _b[edXlhcap_lag]*`lhcap_lag_med' + _b[edXlwdigdppcus_lag]*`lwdigdppcus_lag_med' + _b[edXlpop1564_lag]*`lpop1564_lag_med'
						+ _b[edXmean_obed_work]*`mean_obed_work_med' + _b[edXgini_di_lag]*`gini_di_lag_med' + _b[edXelf_eth]*`elf_eth_med' 
						+ _b[edXdemoc_lag]*`democ_lag_med' + _b[edXsocialist]*`socialist_med';
	dis `edeffect';
	test education + edXlarable_pop1564_lag*`larable_pop1564_lag_med' + edXlK62s_pop1564_lag*`lK62s_pop1564_lag_med' 
						+ edXlhcap_lag*`lhcap_lag_med' + edXlwdigdppcus_lag*`lwdigdppcus_lag_med' + edXlpop1564_lag*`lpop1564_lag_med'
						+ edXmean_obed_work*`mean_obed_work_med' + edXgini_di_lag*`gini_di_lag_med' + edXelf_eth*`elf_eth_med' 
						+ edXdemoc_lag*`democ_lag_med' + edXsocialist*`socialist_med' = 0;
	
	/* Calculating the quantitative implications of the factor interaction coefficients */
	cap drop mean_pc1b;
	bysort countrywave: egen mean_pc1b = mean(pc1b) if insample==1;
	summ mean_pc1b if first==1;
	local pc1bsd = r(sd);
	
	local factors "larable_pop1564_lag lK62s_pop1564_lag lhcap_lag mean_obed_work";
	foreach f of local factors {;
		summ `f' if first==1, det;
		local `f'p25 = r(p25);
		local `f'p75 = r(p75);
		tab isocode if `f'==``f'p25';
		tab isocode if `f'==``f'p75';
		local `f'edeffect25 = `edeffect' - _b[edX`f']*``f'_med' +_b[edX`f']*``f'p25';
		local `f'edeffect75 = `edeffect' - _b[edX`f']*``f'_med' +_b[edX`f']*``f'p75';	
		dis ``f'edeffect25';
		dis ``f'edeffect75';
		dis (``f'edeffect75' - ``f'edeffect25')/``f'edeffect25';
		local change`f' = _b[edX`f']*(``f'p75'-``f'p25');
		dis (`change`f'')/`pc1bsd';
	};
	
	foreach f of local factors {;
		summ `f' if first==1, det;
		local `f'p10 = r(p10);
		local `f'p90 = r(p90);
		tab isocode if `f'==``f'p10';
		tab isocode if `f'==``f'p90';
		local `f'edeffect10 = `edeffect' - _b[edX`f']*``f'_med' +_b[edX`f']*``f'p10';
		local `f'edeffect90 = `edeffect' - _b[edX`f']*``f'_med' +_b[edX`f']*``f'p90';	
		dis ``f'edeffect10';
		dis ``f'edeffect90';
		dis (``f'edeffect90' - ``f'edeffect10')/``f'edeffect10';
		local change`f' = _b[edX`f']*(``f'p90'-``f'p10');
		dis (`change`f'')/`pc1bsd';
	};
		
	gen occupation3 = floor(occupation/10);
	replace occupation3 = 9 if occupation==.;
	xi, prefix(_O3) i.occupation3;
	
	display "*(viii) Occupation dummies";
	areg `depvar' `baselinecontrols' `factorinteractions' `auxillaryinteractions' missing_* _DcouX* _O3* if outlier~=1, 
		absorb(countrywave) cluster(country); 
	outreg `baselinecontrols' `factorinteractions' `auxillaryinteractions' using `ofile', 
		append `defoptions' ctitle(viii);
	
	
	
	* TABLE 3 SPECIFICATIONS: WVS by wave;
	
	display "*(3i) Wave==3";
	areg `depvar' `baselinecontrols' `factorinteractions' if missing==0 & wave==3, 
		absorb(countrywave) cluster(country); 
	outreg `baselinecontrols' `factorinteractions' using `ofile', 
		append `defoptions' ctitle(3i);
	
	display "*(3ii) Wave==3";
	areg `depvar' `baselinecontrols' `factorinteractions' `auxillaryinteractions' missing_* _DcouX* if outlier~=1 & wave==3, 
		absorb(countrywave) cluster(country); 
	outreg `baselinecontrols' `factorinteractions' `auxillaryinteractions' using `ofile', 
		append `defoptions' ctitle(3ii);
	
	display "*(3iii) Wave==4";
	areg `depvar' `baselinecontrols' `factorinteractions' if missing==0 & wave==4, 
		absorb(countrywave) cluster(country); 
	outreg `baselinecontrols' `factorinteractions' using `ofile', 
		append `defoptions' ctitle(3iii);
	
	display "*(3iv) Wave==4";
	areg `depvar' `baselinecontrols' `factorinteractions' `auxillaryinteractions' missing_* _DcouX* if outlier~=1 & wave==4, 
		absorb(countrywave) cluster(country); 
	outreg `baselinecontrols' `factorinteractions' `auxillaryinteractions' using `ofile', 
		append `defoptions' ctitle(3iv);
	
	
	
	* TABLE 5 SPECIFICATIONS: SKILL PREMIUM;
	
	foreach n of numlist 130 133 {;
	
	display "*(5i) Skill premium `n': Baseline specification";
	areg `depvar' `baselinecontrols' edXlskprem`n'_lag if missing==0, 
		absorb(countrywave) cluster(country); 
	outreg `baselinecontrols' edXlskprem`n'_lag using `ofile', 
		append `defoptions' ctitle(5i);
		
	display "*(5ii) Skill premium `n': With factor endowment interactions";
	areg `depvar' `baselinecontrols' edXlskprem`n'_lag `factorinteractions' if missing==0, 
		absorb(countrywave) cluster(country); 
	outreg `baselinecontrols' edXlskprem`n'_lag `factorinteractions' using `ofile', 
		append `defoptions' ctitle(5ii);
		
	display "*(5iii) Skill premium `n': With auxillary interactions";
	areg `depvar' `baselinecontrols' edXlskprem`n'_lag `auxillaryinteractions' missing_* _DcouX* if outlier~=1,
		absorb(countrywave) cluster(country); 
	outreg `baselinecontrols' edXlskprem`n'_lag `auxillaryinteractions' using `ofile', 
		append `defoptions' ctitle(5iii);
		
	display "*(5iv) Skill premium `n': With auxillary interactions and factor endowment interactions";	
	areg `depvar' `baselinecontrols' edXlskprem`n'_lag `factorinteractions' `auxillaryinteractions' missing_* _DcouX* if outlier~=1,
		absorb(countrywave) cluster(country); 
	outreg `baselinecontrols' edXlskprem`n'_lag `factorinteractions' `auxillaryinteractions' using `ofile', 
		append `defoptions' ctitle(5iv);
		
	};



	* TABLE 6 SPECIFICATIONS: Food and ores exports;
	
	display "*(6i) Baseline specification";
	areg `depvar' `baselinecontrols' edXlfood3_merexp_lag edXlores3_merexp_lag if missing==0, 
		absorb(countrywave) cluster(country); 
	outreg `baselinecontrols' edXlfood3_merexp_lag edXlores3_merexp_lag using `ofile', 
		append `defoptions' ctitle(6i);
		
	display "*(6ii) With factor endowment interactions";
	areg `depvar' `baselinecontrols' edXlfood3_merexp_lag edXlores3_merexp_lag `factorinteractions' if missing==0, 
		absorb(countrywave) cluster(country); 
	outreg `baselinecontrols' edXlfood3_merexp_lag edXlores3_merexp_lag `factorinteractions' using `ofile', 
		append `defoptions' ctitle(6ii);
		
	display "*(6iii) With auxillary interactions";
	areg `depvar' `baselinecontrols' edXlfood3_merexp_lag edXlores3_merexp_lag `auxillaryinteractions' missing_* _DcouX* if outlier~=1,
		absorb(countrywave) cluster(country); 
	outreg `baselinecontrols' edXlfood3_merexp_lag edXlores3_merexp_lag `auxillaryinteractions' using `ofile', 
		append `defoptions' ctitle(6iii);
		
	display "*(6iv)  With auxillary interactions and factor endowment interactions";	
	areg `depvar' `baselinecontrols' edXlfood3_merexp_lag edXlores3_merexp_lag `factorinteractions' `auxillaryinteractions' missing_* _DcouX* if outlier~=1,
		absorb(countrywave) cluster(country); 
	outreg `baselinecontrols' edXlfood3_merexp_lag edXlores3_merexp_lag `factorinteractions' `auxillaryinteractions' using `ofile', 
		append `defoptions' ctitle(6iv);
		


	* TABLE 7 SPECIFICATIONS: Within-US;
	
	keep if isocode=="USA";
	sort isocode wave;
	
	cap drop occupation2;
	gen occupation2 = occupation;
	replace occupation2 = 99 if occupation==.;
	xi, prefix(_O2) i.occupation2;
	
	cap drop occsk* edXoccsk*;
	gen occsk1 = 0;
	replace occsk1 = 1 if (floor(occupation2/10)==1 | floor(occupation2/10)==2 | occupation2==31 | occupation2==32);
	gen edXoccsk1 = education*occsk1;
	
	gen occsk2 = occsk1;
	replace occsk2 = 0 if occupation2==16;
	gen edXoccsk2 = education*occsk2;
	
	gen occsk3 = occsk1;
	replace occsk3 = 0 if (floor(occupation2/10)==1);
	gen edXoccsk3 = education*occsk3;	
	
	local defoptions "bdec(3,3) coefastr se 3aster bracket nocons";
	
	display "*(i) Skilled workers";
	areg `depvar' `baselinecontrols' edXoccsk1 _O2* if missing==0, absorb(wave) r; 
	outreg `baselinecontrols' edXoccsk1 _O2* using `ofile', append `defoptions' ctitle(7i);
	
	display "*(ii) Skilled workers";
	areg `depvar' `baselinecontrols' edXoccsk2 _O2* if missing==0, absorb(wave) r; 
	outreg `baselinecontrols' edXoccsk2 _O2* using `ofile', append `defoptions' ctitle(7ii);
	
	display "*(iii) Skilled workers";
	areg `depvar' `baselinecontrols' edXoccsk3 _O2* if missing==0, absorb(wave) r; 
	outreg `baselinecontrols' edXoccsk3 _O2* using `ofile', append `defoptions' ctitle(7iii);
	

	cap drop occunsk* edXoccunsk*;
	gen occunsk1 = 0;
	replace occunsk1 = 1 if (occupation2==33 | occupation2==34 | floor(occupation2/10)==4 | occupation2==51 | occupation2==61 | occupation2==99);
	gen edXoccunsk1 = education*occunsk1;
	
	gen occunsk2 = occunsk1;
	replace occunsk2 = 0 if (floor(occupation2/10)==4 | occupation2==51 | occupation2==99);
	gen edXoccunsk2 = education*occunsk2;
	
	gen occunsk3 = occunsk1;
	replace occunsk3 = 0 if (floor(occupation2/10)==4 | occupation2==51 | occupation2==61 | occupation2==99);
	gen edXoccunsk3 = education*occunsk3;
	
	display "*(i) Unskilled workers";
	areg `depvar' `baselinecontrols' edXoccunsk1 _O2* if missing==0, absorb(wave) r; 
	outreg `baselinecontrols' edXoccunsk1 _O2* using `ofile', append `defoptions' ctitle(7iv);
	
	display "*(ii) Unskilled workers";
	areg `depvar' `baselinecontrols' edXoccunsk2 _O2* if missing==0, absorb(wave) r; 
	outreg `baselinecontrols' edXoccunsk2 _O2* using `ofile', append `defoptions' ctitle(7v);
	
	display "*(iii) Unskilled workers";
	areg `depvar' `baselinecontrols' edXoccunsk3 _O2* if missing==0, absorb(wave) r; 
	outreg `baselinecontrols' edXoccunsk3 _O2* using `ofile', append `defoptions' ctitle(7vi);
	

log close;

