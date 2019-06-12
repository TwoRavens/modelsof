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


//regression of the endogeneous variable (transportation cost) on all other exogeneous variables

quietly xi: reg lnav_klems ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee lnifqh3shr lnrdl m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lnl_idist_n5 lnl_odist_n5 lndistn5 i.year i.naics
estat hettest

//predict residuals for suspected endogenous variables

predict yhat, xb

gen resid=yhat-lnav_klems_resid
gen resid2_av=resid^2

quietly xi: reg lnl_odist_n5 lnav_klems ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee lnifqh3shr lnrdl m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lnl_idist_n5  lndistn5 i.year i.naics
estat hettest

predict yhat_on, xb

gen resid_od=yhat_on-lnl_odist_n5
gen resid2_od=resid_od^2


quietly xi: reg lnl_idist_n5 lnav_klems ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee lnifqh3shr lnrdl m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr  lnl_odist_n5 lndistn5 i.year i.naics
estat hettest

predict yhat_in, xb

gen resid_id=yhat_in-lnl_idist_n5
gen resid2_id=resid_id^2


quietly xi: reg m_asiashr lnav_klems ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee lnifqh3shr lnrdl m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr  lnl_idist_n5 lnl_odist_n5 lndistn5 i.year i.naics
estat hettest

predict yhat_masia, xb

gen resid_masia=yhat_masia-lnl_idist_n5
gen resid2_masia=resid_id^2


quietly xi: reg m_oecdshr lnav_klems ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee lnifqh3shr lnrdl m_asiashr m_naftashr x_asiashr x_oecdshr x_naftashr  lnl_idist_n5 lnl_odist_n5 lndistn5 i.year i.naics
estat hettest

predict yhat_moecd, xb

gen resid_moecd=yhat_moecd-lnl_idist_n5
gen resid2_moecd=resid_id^2


quietly xi: reg m_naftashr lnav_klems ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee lnifqh3shr lnrdl m_asiashr m_oecdshr x_asiashr x_oecdshr x_naftashr  lnl_idist_n5 lnl_odist_n5 lndistn5 i.year i.naics
estat hettest

predict yhat_mnafta, xb

gen resid_mnafta=yhat_mnafta-lnl_idist_n5
gen resid2_mnafta=resid_id^2


quietly xi: reg x_oecdshr lnav_klems ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee lnifqh3shr lnrdl m_asiashr m_oecdshr m_naftashr x_asiashr x_naftashr  lnl_idist_n5 lnl_odist_n5 lndistn5 i.year i.naics
estat hettest

predict yhat_xoecd, xb

gen resid_xoecd=yhat_xoecd-lnl_idist_n5
gen resid2_xoecd=resid_id^2


quietly xi: reg x_naftashr lnav_klems ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee lnifqh3shr lnrdl m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr lnl_idist_n5 lnl_odist_n5 lndistn5 i.year i.naics
estat hettest

predict yhat_xnafta, xb

gen resid_xnafta=yhat_xnafta-lnl_idist_n5
gen resid2_xnafta=resid_id^2


quietly xi: reg x_asiashr lnav_klems ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee lnifqh3shr lnrdl m_asiashr m_oecdshr m_naftashr x_naftashr x_oecdshr lnl_idist_n5 lnl_odist_n5 lndistn5 i.year i.naics
estat hettest

predict yhat_xasia, xb

gen resid_xasia=yhat_xasia-lnl_idist_n5
gen resid2_xasia=resid_id^2

//Test correlation of transportations cost, input/output distance and export/import shares with residuals square
pwcorr lnav_klems_resid resid2_av, star(0.01)
pwcorr lnl_odist_n5 resid2_od, star(0.01)
pwcorr lnl_idist_n5 resid2_id, star(0.01)
pwcorr m_asiashr resid2_masia, star(0.01)
pwcorr m_oecdshr resid2_xoecd, star(0.01)
pwcorr m_naftashr resid2_xnafta, star(0.01)
pwcorr x_oecdshr resid2_xoecd, star(0.01)
pwcorr x_naftashr resid2_xnafta, star(0.01)
pwcorr x_asiashr resid2_xasia, star(0.01)


//Additional variables

*US instrument
generate lnav_klemsus = ln(av_klemsus)
set more off


*Bins

gen q3_bin = .
levelsof year, local(year_1)
foreach i in `year_1' {
xtile q3_temp=lnav_klems_resid if year==`i', nq(3)
replace q3_bin = q3_temp if missing(q3_bin)
drop q3_temp
} 

gen q5_bin = .
levelsof year, local(year_1)
foreach i in `year_1' {
xtile q5_temp=lnav_klems_resid if year==`i', nq(5)
replace q5_bin = q5_temp if missing(q5_bin)
drop q5_temp
} 


*IO variables abreviations for the Lewbel
gen id = lnl_idist_n5
gen od = lnl_odist_n5
gen lnav_klemsr=lnav_klems_resid


log using "\\ead02\ead_uquam\Localization\restat_results\IV_cross_2008", replace

xi: reg  ln_cdf50 lnav_klems_resid ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee lnifqh3shr lnrdl m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lnl_idist_n5 lnl_odist_n5 lndistn5 if year==2008, cluster(naics)
outreg2 using Lewbel_2SLS_Cross_2008_rev2, ctitle("Base")  sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) replace

xi: ivreg2 ln_cdf50 ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee lnifqh3shr lnrdl m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr id od lndistn5 (lnav_klems_resid = q5_bin) if year==2008, first cluster(naics)
outreg2 using Lewbel_2SLS_Cross_2008_rev2, ctitle("2SLS Q5")  sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) append

xi: ivreg2 ln_cdf50 ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee lnifqh3shr lnrdl m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr id od lndistn5 (lnav_klems_resid = q3_bin) if year==2008, first cluster(naics)
outreg2 using Lewbel_2SLS_Cross_2008_rev2, ctitle("2SLS Q3")  sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) append

*Lewbel

xi: ivreg2h  ln_cdf50 ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee lnifqh3shr lnrdl m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lndistn5 (lnav_klemsr id od=q5_bin) if year==2008, cluster(naics) partial(ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee lnifqh3shr lnrdl m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lndistn5)
outreg2 using Lewbel_2SLS_Cross_2008_rev2, ctitle("Lewbel")  sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) append

log close










