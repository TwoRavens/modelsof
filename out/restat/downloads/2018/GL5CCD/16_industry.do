*log using "\\ead02\ead_uquam\Localization\restat_results", replace 

use "\\ead02\ead_uquam\Localization\NAICS6_panel\restat_final.dta", clear

cd "\\ead02\ead_uquam\Localization\restat_results"

*************************************************************************************VARIABLE CONSTRUCTION************************************************************************************************

*TSET FUNCTION;

destring naics, replace
destring oecd80, replace

xtset naics year, delta(1)


//Table 6: Estimates of equation (1) excluding textiles and high tech industries

*FE: Model 4 without textile industries
xi: xtreg  ln_cdf10 ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lnav_klems_resid lnl_idist_n5 lnl_odist_n5 lndistn5 lnifqh3shr lnrdl i.year if textile!=1, fe cluster(naics)
estimates store Model_4t_CDF10km
outreg2 using CDFFE_text, ctitle("FE4_t: CDF 10km")  sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) replace

xi: xtreg  ln_cdf100 ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lnav_klems_resid lnl_idist_n5 lnl_odist_n5 lndistn5 lnifqh3shr lnrdl i.year if textile!=1, fe cluster(naics)
estimates store Model_4t_CDF100km
outreg2 using CDFFE_text, ctitle("FE4_t: CDF 100km")  sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) append

xi: xtreg  ln_cdf500 ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lnav_klems_resid lnl_idist_n5 lnl_odist_n5 lndistn5 lnifqh3shr lnrdl i.year if textile!=1, fe cluster(naics)
estimates store Model_4t_CDF500km
outreg2 using CDFFE_text, ctitle("FE4_t: CDF 500km")  sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) append

estimates table Model_4t_CDF10km Model_4t_CDF100km Model_4t_CDF500km, b(%7.3f) star (.10 .05 .01) stat(N r2_a)


*FE: Model 4 without High tech industries
xi: xtreg  ln_cdf10 ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lnav_klems_resid lnl_idist_n5 lnl_odist_n5 lndistn5 lnifqh3shr lnrdl i.year if hightech!=1, fe cluster(naics)
estimates store Model_4ht_CDF10km
outreg2 using CDFFE_ht, ctitle("FE4_t: CDF 10km") sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) replace

xi: xtreg  ln_cdf100 ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lnav_klems_resid lnl_idist_n5 lnl_odist_n5 lndistn5 lnifqh3shr lnrdl i.year if hightech!=1, fe cluster(naics)
estimates store Model_4ht_CDF100km
outreg2 using CDFFE_ht, ctitle("FE4_t: CDF 100km")  sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) append

xi: xtreg  ln_cdf500 ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lnav_klems_resid lnl_idist_n5 lnl_odist_n5 lndistn5 lnifqh3shr lnrdl i.year if hightech!=1, fe cluster(naics)
estimates store Model_4ht_CDF500km
outreg2 using CDFFE_ht, ctitle("FE4_t: CDF 500km")  sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) append

estimates table Model_4ht_CDF10km Model_4ht_CDF100km Model_4ht_CDF500km, b(%7.3f) star (.10 .05 .01) stat(N r2_a)

