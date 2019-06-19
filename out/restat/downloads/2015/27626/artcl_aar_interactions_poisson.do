#delimit;
clear all;
version 13.1;
pause on;
program drop _all;
capture log close;
set more off;

/*INSERT FOLDER PATH*/
cd /;


foreach defn in strct {;

use multi_level_dataset_005_field_vars.dta, clear;
drop if ovrlp_anypos==1;
keep id year yr srce_pmid nbcites_it treat rltd age age_at_rtrct treatXaar* case_code shldrs uprght rtrct_reason;

xtqmlp nbcites_it treatXaar1-treatXaar10 i.age i.yr if subv_of_trth_`defn'==1, fe i(id) cluster(case_code);
estimates save estimates/poisson_main_aar_intr_`defn'.ster, replace;
bysort age_at_rtrct: keep if _n==_N;

matrix drop _all;
estimates drop _all;
estimates use estimates/poisson_main_aar_intr_`defn'.ster;

matrix B=e(b);
matrix V=e(V);

foreach y of numlist 1/10 {;
	local t=colnumb(B,"treatXaar`y'");
	gen aaar_score`y'_coef = B[1,`t'];
	gen aaar_score`y'_var = V[`t',`t'];
};


gen aaar_coefs=.;
gen aaar_vars=.;

foreach j of numlist 1/10 {;
	replace aaar_coefs=aaar_score`j'_coef  if age_at_rtrct==`j';
	replace aaar_vars =aaar_score`j'_var   if age_at_rtrct==`j';
};

gen aaar_95lo=aaar_coefs-1.96*sqrt(aaar_vars);
gen aaar_95hi=aaar_coefs+1.96*sqrt(aaar_vars);

sort age_at_rtrct;

twoway rcap aaar_95hi aaar_95lo age_at_rtrct || scatter aaar_coefs age_at_rtrct, msize(medsmall) mcolor(teal) yline(0, lcolor(black) lwidth(thin)) || if age_at_rtrct >= 1 & age_at_rtrct <= 10, xtitle(" " "Article Vintage at the Time of Retraction") ytitle(" " "Magnitude of the Treatment Effect", size(medsmall)) ylabel(-0.75(0.25)0.75, format(%15.2f) angle(horizontal) labsize(small)) xlabel(1(1)10, labsize(small)) legend(off) saving(graphs/poisson_main_aar_intr_`defn'.gph, replace);
	};