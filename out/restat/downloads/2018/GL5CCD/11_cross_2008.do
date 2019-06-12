*Set up
clear all
set memory 5g

set more off

*N.B.: Unweighted localization file;

use "\\ead02\ead_uquam\Localization\NAICS6_panel\restat_final.dta", clear

cd "\\ead02\ead_uquam\Localization\restat_results"

*************************************************************************************VARIABLE CONSTRUCTION************************************************************************************************

*TSET FUNCTION;

destring naics, replace
destring oecd80, replace

xtset naics year, delta(1)


//Baseline pooled cross-sectional estimates for model (1) 

*CDF evaluated at 50km restricted to 2008

xi: reg  ln_cdf50 lnav_klems if year==2008, robust
estimates store PCS1
outreg2 using CDF50PCS08, ctitle("PCS1: CDF 50km")  sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) replace

xi: reg  ln_cdf50 lnav_klems m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr if year==2008, robust
estimates store PCS2
outreg2 using CDF50PCS08, ctitle("PCS2: CDF 50km")  sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) append

xi: reg  ln_cdf50 lnav_klems lnl_idist_n5 lnl_odist_n5 lndistn5 if year==2008, robust
estimates store PCS3
outreg2 using CDF50PCS08, ctitle("PCS3: CDF 50km")  sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) append

xi: reg  ln_cdf50 lnav_klems m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lnl_idist_n5 lnl_odist_n5 lndistn5 if year==2008, robust
estimates store PCS4
outreg2 using CDF50PCS08, ctitle("PCS4: CDF 50km")  sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) append

xi: reg  ln_cdf50 lnav_klems ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee lnifqh3shr lnrdl if year==2008, robust
estimates store PCS5
outreg2 using CDF50PCS08, ctitle("PCS5: CDF 50km")  sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) append

xi: reg  ln_cdf50 lnav_klems ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee lnifqh3shr lnrdl m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lnl_idist_n5 lnl_odist_n5 lndistn5 if year==2008, robust
estimates store PCS6
outreg2 using CDF50PCS08, ctitle("PCS6: CDF 50km")  sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) append

xi: reg  ln_cdf50 lnav_klems_resid ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee lnifqh3shr lnrdl m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lnl_idist_n5 lnl_odist_n5 lndistn5 if year==2008, robust
estimates store PCS7
outreg2 using CDF50PCS08, ctitle("PCS7: CDF 50km")  sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) append

estimates table PCS*, b(%7.3f) star (.10 .05 .01) stat(N r2_a)

