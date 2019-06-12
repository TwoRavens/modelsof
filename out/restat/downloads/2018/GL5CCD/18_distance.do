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


*Cross with incremental: 10-50, 50-100, 100-500 using the base model

*CDF 10-50
xi: reg  ln_cdf10_25 lnav_klems_resid ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lnl_idist_n5 lnl_odist_n5 lndistn5 lnifqh3shr lnrdl i.year, cluster(naics)
outreg2 using Inc_CDF, ctitle("Cross 10-25km")  sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) replace

*CDF 25-50
xi: reg  ln_cdf25_50 lnav_klems_resid  ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lnl_idist_n5 lnl_odist_n5 lndistn5 lnifqh3shr lnrdl i.year, cluster(naics)
outreg2 using Inc_CDF, ctitle("Cross 25-50km")  sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) append

*CDF 50-100
xi: reg  ln_cdf50_100 lnav_klems_resid  ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lnl_idist_n5 lnl_odist_n5 lndistn5 lnifqh3shr lnrdl i.year, cluster(naics)
outreg2 using Inc_CDF, ctitle("Cross 50-100km")  sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) append

*CFF 100-500
xi: reg  ln_cdf100_500 lnav_klems_resid ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lnl_idist_n5 lnl_odist_n5 lndistn5 lnifqh3shr lnrdl i.year, cluster(naics)
outreg2 using Inc_CDF, ctitle("Cross 100-500km")  sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) append


*Panel with incremental: 10-50, 50-100, 100-500 using the base model

*CDF 10-50
xi: xtreg  ln_cdf10_25 lnav_klems_resid ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lnl_idist_n5 lnl_odist_n5 lndistn5 lnifqh3shr lnrdl i.year, fe cluster(naics)
outreg2 using Inc_CDF, ctitle("Panel 10-25km")  sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) append

*CDF 25-50
xi: xtreg  ln_cdf25_50 lnav_klems_resid ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lnl_idist_n5 lnl_odist_n5 lndistn5 lnifqh3shr lnrdl i.year, fe cluster(naics)
outreg2 using Inc_CDF, ctitle("Panel 25-50km")  sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) append

*CDF 50-100
xi: xtreg  ln_cdf50_100 lnav_klems_resid ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lnl_idist_n5 lnl_odist_n5 lndistn5 lnifqh3shr lnrdl i.year, fe cluster(naics)
outreg2 using Inc_CDF, ctitle("Panel 50-100km")  sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) append

*CFF 100-500
xi: xtreg  ln_cdf100_500 lnav_klems_resid ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lnl_idist_n5 lnl_odist_n5 lndistn5 lnifqh3shr lnrdl i.year, fe cluster(naics)
outreg2 using Inc_CDF, ctitle("Panel 100-500km")  sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) append

