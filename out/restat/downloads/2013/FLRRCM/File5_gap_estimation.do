#delimit;
/** This code defines the gaps and runs the baseline regressions and some robustness checks ***/

/** 1.  Rename coefficients **/
foreach x in grwslk olsfe transfe {;
use coefs_`x', clear;
capture renpfix _b `x';
capture drop grwslk_var_*;
save, replace;
};




/** 2.  Merge in coefficients **/

#delimit;
use temp_checks, clear;
foreach x in grwlp full_lp olsfe transfe grwslk {;
sort ciiu_3d ppn year;
merge ciiu_3d using coefs_`x';
drop _merge;
};

/***********************************************************************************************/
/** Some coefficient estimates are less than 0.  Since negative elasticity is implausible,
we exclude such cases by setting the coefficients for that estimator to missing in such cases. Also exclude 
cases where the RTS on the vraiable inputs alone excluding capital exceed 1 (to gurantee SOCs). 
(We leave out the translog case where the elasticity is a function of the input level and hence
the coefficient estimate can be negative.) **/
/***********************************************************************************************/

foreach x in grwslk olsfe {;
foreach y in b w m e s {;
replace `x'_ln`y'=. if (min(`x'_lnb, `x'_lnw, `x'_lnk, `x'_lnm, `x'_lne, `x'_lns)<0) |
	((`x'_lnm + `x'_lne) >1);
};
};

/***********************************************************************************************/
/*** Marginal products for the different production functions**/
/***********************************************************************************************/
gen km = lnk*lnm;
gen k2 = lnk^2;
gen m2 = lnm^2;
gen k2m = lnk^2*lnm;
gen km2 = lnk*lnm^2;
gen k3 = lnk^3;
gen m3 = lnm^3;

global indlist 311 313 321 322 323 324 331 332 342 351 352 354 355 356 361 362 381 383 384 385 390;
gen yhat=.;
foreach x in $indlist{;
qui reg lny lnb lnw lnm lns lnk lne km k2 m2 k2m km2 k3 m3 if ciiu_3d==`x', cluster(ppn);
qui predict xx;
qui replace yhat=xx if ciiu_3d==`x'; drop xx;
display ".";
};

*--------------------------------------------------------------------------------;
* Marginal products for (1)BASELINE Wooldridge Production function, using both full error
				   and trensmitted component (omega) ***;
*--------------------------------------------------------------------------------;

#delimit;
sort ppn year;
foreach x in grwslk {;
gen double `x'_err= (lny - `x'_lnb*lnb - `x'_lnw*lnw - `x'_lnk*lnk - `x'_lnm*lnm
				- `x'_lns*lns -`x'_lne*lne);

gen `x'_omega= (yhat - `x'_lnb*lnb - `x'_lnw*lnw - `x'_lnk*lnk - `x'_lnm*lnm
				-`x'_lns*lns - `x'_lne*lne);

foreach y in err omega {;
gen `x'_mpr_b_`y'=`x'_lnb* exp(lny)*exp(`x'_`y')/(blue*exp(`x'_err));
gen `x'_mpr_w_`y'=`x'_lnw* exp(lny)*exp(`x'_`y')/(white*exp(`x'_err));
gen `x'_mpr_m_`y'=`x'_lnm* exp(lny)*exp(`x'_`y')/(rm*exp(`x'_err));
gen `x'_mpr_e_`y'=`x'_lne* exp(lny)*exp(`x'_`y')/(elecbvol*exp(`x'_err));
};
};

*--------------------------------------------------------------------------------;
* (2) Marginal products for OLS FE Specification ;
*--------------------------------------------------------------------------------;
gen double olsfe_err= (lny - olsfe_lnb*lnb - olsfe_lnw*lnw - olsfe_lnk*lnk - olsfe_lnm*lnm
				-olsfe_lns*lns -olsfe_lne*lne);
foreach y in err {;
gen olsfe_mpr_b_`y'=olsfe_lnb* exp(lny)*exp(olsfe_`y')/(blue*exp(olsfe_err));
gen olsfe_mpr_w_`y'=olsfe_lnw* exp(lny)*exp(olsfe_`y')/(white*exp(olsfe_err));
gen olsfe_mpr_m_`y'=olsfe_lnm* exp(lny)*exp(olsfe_`y')/(rm*exp(olsfe_err));
gen olsfe_mpr_e_`y'=olsfe_lne* exp(lny)*exp(olsfe_`y')/(elecbvol*exp(olsfe_err));
};
*--------------------------------------------------------------------------------;
* (3) Marginal products for Translog OLS FE Specification ;
*--------------------------------------------------------------------------------;
gen tb= transfe_var_1 + transfe_var_12* var_2+ transfe_var_13* var_3+ transfe_var_14* var_4+ transfe_var_15* var_5
		+ transfe_var_16* var_6 + 2*transfe_var_11*var_1;
gen tw= transfe_var_2 + transfe_var_12* var_1+ transfe_var_23* var_3+ transfe_var_24* var_4+ transfe_var_25* var_5
		+ transfe_var_26* var_6 + 2*transfe_var_22*var_2;
gen tk= transfe_var_3 + transfe_var_13* var_1+ transfe_var_23* var_2+ transfe_var_34* var_4+ transfe_var_35* var_5
		+ transfe_var_36* var_6 + 2*transfe_var_33*var_3;
gen tm= transfe_var_4 + transfe_var_14* var_1+ transfe_var_24* var_2+ transfe_var_34* var_3+ transfe_var_45* var_5
		+ transfe_var_46* var_6 + 2*transfe_var_44*var_4;
gen te= transfe_var_5 + transfe_var_15* var_1+ transfe_var_25* var_2+ transfe_var_35* var_3+ transfe_var_45* var_4
		+ transfe_var_56* var_6 + 2*transfe_var_55*var_5;
gen ts= transfe_var_6 + transfe_var_16* var_1+ transfe_var_26* var_2+ transfe_var_36* var_3+ transfe_var_46* var_4
		+ transfe_var_56* var_5 + 2*transfe_var_66*var_6;

local i=1;
foreach x in lnb lnw lnk lnm lne lns{;
gen double term`i'=transfe_var_`i'*var_`i';
local i=`i'+1;
};

forv i=1/6{;
forv j=`i'/6{;
gen double term`i'`j'=transfe_var_`i'`j'*var_`i'*var_`j';
};
};

gen double transfe_err= lny - (term1+term2+term3+term4+term5+term6+term11+term12+term13+term14+term15+term16
	+term22+term23+term24+term25+term26+term33+term34+term35+term36+term44+term45+term46+term55+term56+term66 );

foreach y in err {;
gen transfe_mpr_b_`y'= tb*exp(lny)*exp(transfe_`y')/(blue*exp(transfe_err));
gen transfe_mpr_w_`y'=tw*exp(lny)*exp(transfe_`y')/(white*exp(transfe_err));
gen transfe_mpr_m_`y'=tm*exp(lny)*exp(transfe_`y')/(rm*exp(transfe_err));
gen transfe_mpr_e_`y'=te*exp(lny)*exp(transfe_`y')/(elecbvol*exp(transfe_err));
};

save temp_pmpr_apr11, replace;

/*********************************************************************************/
/***** REAL ABSOLUTE GAPS ************/
/*********************************************************************************/
/*********************************************************************************/
***Note: The VALUE MARGINAL PRODUCT = MP from above * Industry Price index= MP*0.01*def_op79
/*********************************************************************************/

#delimit;
use temp_pmpr_apr11, clear;
sort year;
/** Merging in deflators **/
merge year using chile_inf2;

ren cpi cpi_nbase;
gen xx=cpi if year==1979;
egen dd=max(xx);
gen cpi79=cpi_nbase*100/dd; drop dd xx;

ren chile_gdef gdef79;

label var cpi79 "Consumer price index (Base 1979=100) ";
label var gdef79 "GDP deflator (World Bank WDI) (Base 1979=100) ";

/*** SO THREE ALTERNATIVE DEFLATORS ARE dop79, ppi79 and cpi79 ***/

/** HERE WE CAN SPECIFY DIFFERENT DEFLATORS**/

global grwslk_list err omega ;
global olsfe_list err ;
global transfe_list err;

foreach def in cpi79 gdef79{;
foreach z in grwslk olsfe transfe {;
foreach y in ${`z'_list} {;
foreach x in b w m e {;
	qui gen `z'_gap_`x'_`def'_`y'=(0.01*dop79*`z'_mpr_`x'_`y'- pr_`x')/(`def'*0.01);
     	qui gen xx= abs(`z'_gap_`x'_`def'_`y');
	qui winsor xx, gen(`z'_agap_`x'_`def'_`y') p(0.01); drop xx;
};
label var `z'_agap_b_`def'_`y' "Blue Collar Gap (`z', `def', `y')";
label var `z'_agap_w_`def'_`y' "White Collar Gap (`z', `def', `y')";
label var `z'_agap_m_`def'_`y' "Materials Gap (`z', `def', `y')";
label var `z'_agap_e_`def'_`y' "Electricity Gap (`z', `def', `y')";
};
};
};

save temp_pgap_apr11, replace;

/***/
/*********************************************************************/
/*** REGRESSION TABLE: Real absolute gaps on period dummies with plant fixed effects **/
/*********************************************************************/
#delimit;
use temp_pgap_apr11, clear;
keep if year>1981 & year<1995 & perch_indop ~=.;
program drop _all;
program define myfocregs;
	xi: areg `1'_agap_`2'_`3'_`4' pd*, absorb(ppn) cluster(isic);
 	if `5'==1 {;
 	outreg2 using baseline_plus1, se bracket
	addstat(Number of clusters, e(N_clust)) adec(3)  replace;
 	};
 	if `5'~=1 {;
 	outreg2 using baseline_plus1, se bracket
	 addstat(Number of clusters, e(N_clust)) adec(3) append;
	};

	xi: areg `1'_agap_`2'_`3'_`4' perch_indop pd*, absorb(ppn) cluster(isic);
 	outreg2 using baseline_plus1, se bracket
	 addstat(Number of clusters, e(N_clust)) adec(3) append;

end;

local i=1;
foreach def in cpi79 gdef79{;
foreach z in grwslk olsfe transfe {;
foreach y in ${`z'_list} {;
foreach x in b w m e {;
myfocregs `z' `x' `def' `y' `i';
local i=`i'+1;
};
};
};
};
