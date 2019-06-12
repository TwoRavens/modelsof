*Set up
clear all
set memory 5g

set more off

use "\\ead02\ead_uquam\Localization\NAICS6_panel\restat_final.dta", clear

cd "\\ead02\ead_uquam\Localization\restat_results"


*TSET FUNCTION;

destring naics, replace
destring oecd80, replace

xtset naics year, delta(1)

//Additional variables 

qui bys naics: egen s_local = sum(localised)
qui bys naics: egen s_disper = sum(dispersed)


//Table 15 Robustness check contolling for industry shifts using the integration of pi (localised) and phi (dispersed) 


*PI and PHI left-hand-side variables evaluated at 800km

xi: reg localised lnav_klems_resid ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee lnifqh3shr lnrdl m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lnl_idist_n5 lnl_odist_n5 lndistn5 i.year if s_disper==0 & s_local>=1, cluster(naics)
outreg2 using Geography, ctitle("Local: cross")  sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) append

xi: xtreg localised lnav_klems_resid ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee lnifqh3shr lnrdl m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lnl_idist_n5 lnl_odist_n5 lndistn5 i.year if s_disper==0 & s_local>=1, fe cluster(naics)
outreg2 using Geography, ctitle("Local: panel")  sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) append

xi: reg pi lnav_klems_resid ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee lnifqh3shr lnrdl m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lnl_idist_n5 lnl_odist_n5 lndistn5 i.year if s_disper==0 & s_local>=1, cluster(naics)
outreg2 using Geography, ctitle("PI: cross")  sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) append

xi: xtreg pi lnav_klems_resid ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee lnifqh3shr lnrdl m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lnl_idist_n5 lnl_odist_n5 lndistn5 i.year if s_disper==0 & s_local>=1, fe cluster(naics)
outreg2 using Geography, ctitle("PI: panel")  sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) append

*end
