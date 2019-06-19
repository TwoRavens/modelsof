/**
Alternative methodologies: 
1. Basecase: Gross Output Wooldridge method with capital, blue collar and white collar labor as state variables, 
		 materials as proxy variable
2. Cobb-douglas Gross Output OLS FE specification, allow fixed effect to vary by period
3. Translog Gross Output OLS FE specification (with fixed effect error)
**/

*--------------------------------------------------------------------------------;
* Baseline (1) Wooldridge, treating Blue and White collar labor, as well as Capital 
		as state variables, and materials as proxy variable;
*--------------------------------------------------------------------------------;
#delimit;
use temp_chile_fin, clear;
xtset ppn year ;
gen lnb_l1 = L.lnb;
gen lnw_l1 = L.lnw;
gen lnk_l1 = L.lnk;
gen lnm_l1 = L.lnm;
gen lne_l1 = L.lne;
gen lns_l1 = L.lns;
/*** Set f(g(x_t-1, m_t-1) as a 2nd-order polynomial, and allow blue collar and white collar labor to be 
state variables as well (so only lne and lns are the other flexible inputs) ***/

local i=1;
foreach x in lnb_l1 lnw_l1 lnk_l1 lnm_l1 {;
gen double var_`i'=`x';
local i=`i'+1;
};
forv i=1/4{;
forv j=`i'/4{;
gen double var_`i'`j'=var_`i'*var_`j';
};
};

gen lnb_l2 = L.lnb_l1;
gen lnw_l2 = L.lnw_l1;
gen lnm_l2 = L.lnm_l1;
gen lne_l2 = L.lne_l1;
gen lns_l2 = L.lns_l1;
gen lnk_l2 = L.lnk_l1;

global exoreg  lnk lnb lnw var_*;
global endoreg lne lnm lns;
global instr lne_l1 lns_l1 lnm_l2 lnb_l2 lnw_l2 lne_l2 lns_l2;

/** We collate the coefficients, the Hansen/Sargent overidentification test p-values and number of 
observations **/
sort ciiu_3d;
statsby _b jp=e(jp) nobs=e(N), by(ciiu_3d) saving(coefs_grwslk, replace): 
	ivreg2 lny $exoreg ($endoreg = $instr), gmm2s cluster(ppn);

*--------------------------------------------------------------------------------;
* Alternative (2) OLS FE Specification -- alllow the fixed effect to vary by period;
*--------------------------------------------------------------------------------;
use temp_chile_fin, clear;
egen ppntpd=group(ppn tpd);
statsby _b , by(ciiu_3d) saving(coefs_olsfe, replace): 
	xtreg lny lnb lnw lnk lnm lne lns, fe i(ppntpd) cluster(ppn);
*--------------------------------------------------------------------------------;
* Alternative (3) Translog OLS FE Specification ;
*--------------------------------------------------------------------------------;
use temp_chile_fin, clear;
local i=1;
foreach x in lnb lnw lnk lnm lne lns{;
gen double var_`i'=`x';
local i=`i'+1;
};
forv i=1/6{;
forv j=`i'/6{;
gen double var_`i'`j'=var_`i'*var_`j';
};
};

statsby _b , by(ciiu_3d) saving(coefs_transfe, replace): 
	xtreg lny var*, fe i(ppntpd) cluster(ppn);

