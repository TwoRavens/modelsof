#delimit ;
clear all;
set mem 600m;
set more off;
* Replace with your local working directory name;
local dir "C:\Users\hchor\Documents\Projects\InstEd\wvsmerge\Replication";
cd "`dir'";

*************************;
* Reproducing Figure 1  *;
*************************;

use wvsmerge_RESTAT_replication.dta, clear;
iis countrywave;
cap drop edX*;
cap drop incX*;

*******************************************;
* Generating interactions with education  *;
*******************************************;

local varname "pop1564 arable_pop1564 hcap wdigdppcus K62s_pop1564";
local varname2 "gini_di democ";

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

keep if missing==0;
sort isocode wave;

local baselinecontrols "age agesq gender dum_married nchild dum_student dum_emp incomedec education";

local depvar pc1b;

tempvar i;
gen `i'=1;
cap drop beta_`depvar';
cap drop cnumber;
cap gen beta_`depvar'=.;
cap egen cnumber=group(countrywave);
summ cnumber;
local N=r(max);

while `i'<=`N' { ;
cap quietly regress `depvar' `baselinecontrols'	if cnumber==`i';
cap drop beta_temp; 
cap gen beta_temp=_b[education];
cap replace beta_`depvar' = beta_temp if cnumber==`i';
replace `i'=`i'+1;
};



cap drop beta_temp;
keep isocode wave countrywave beta_* larable_pop1564_lag lK62s_pop1564_lag lhcap_lag lwdigdppcus_lag lpop1564_lag
	gini_di_lag mean_obed_work democ_lag elf_eth socialist;
bysort countrywave: keep if _n==1;

local ctycontrols "lwdigdppcus_lag lpop1564_lag gini_di_lag democ_lag elf_eth socialist";

* Generating partial residuals;

cap drop beta_`depvar'_resid*;
cap drop insample;

reg beta_`depvar' larable_pop1564_lag lK62s_pop1564_lag lhcap_lag mean_obed_work `ctycontrols', cluster(isocode);
gen insample = .;
replace insample = 1 if e(sample);

reg beta_`depvar' lK62s_pop1564_lag lhcap_lag mean_obed_work `ctycontrols' if insample==1, cluster(isocode);
predict beta_`depvar'_residT if insample==1, resid; 

reg beta_`depvar' larable_pop1564_lag lhcap_lag mean_obed_work `ctycontrols' if insample==1, cluster(isocode);
predict beta_`depvar'_residK if insample==1, resid; 

reg beta_`depvar' larable_pop1564_lag lK62s_pop1564_lag mean_obed_work `ctycontrols' if insample==1, cluster(isocode);
predict beta_`depvar'_residH if insample==1, resid; 

reg beta_`depvar' larable_pop1564_lag lK62s_pop1564_lag lhcap_lag `ctycontrols' if insample==1, cluster(isocode);
predict beta_`depvar'_residO if insample==1, resid; 



* Instructions for figures;
* Run separately for each figure;
#delimit ;
twoway (scatter beta_pc1b_residT larable_pop1564_lag if larable_pop1564_lag>-3, msymbol(none) mlabel(isocode)) 
	(lfit beta_pc1b_residT larable_pop1564_lag if larable_pop1564_lag>-3), 
	ytitle(Education coefficient residuals) xtitle(Log (T/L)) legend(off) graphregion(color(white));

#delimit ;
twoway (scatter beta_pc1b_residK lK62s_pop1564_lag if lK62s_pop1564_lag>0.9, msymbol(none) mlabel(isocode)) 
	(lfit beta_pc1b_residK lK62s_pop1564_lag if lK62s_pop1564_lag>0.9), 
	ytitle(Education coefficient residuals) xtitle(Log (K/L)) legend(off) graphregion(color(white));

#delimit ;
twoway (scatter beta_pc1b_residH lhcap_lag if lhcap_lag>0.3, msymbol(none) mlabel(isocode)) 
	(lfit beta_pc1b_residH lhcap_lag if lhcap_lag>0.3), 
	ytitle(Education coefficient residuals) xtitle(Log (H/L)) legend(off) graphregion(color(white));

#delimit ;
twoway (scatter beta_pc1b_residO mean_obed_work, msymbol(none) mlabel(isocode)) 
	(lfit beta_pc1b_residO mean_obed_work), 
	ytitle(Education coefficient residuals) xtitle(Mean Obedience) legend(off) graphregion(color(white));
