*****Ziller, Conrad. Societal Implications of Antidiscrimination Policy in Europe. Reasearch & Politics*****
*24 October 2014*


*All used data are open source: 
*http://www.gesis.org/eurobarometer-data-service/data-access/
*http://www.europeansocialsurvey.org/data/
*http://www.mipex.eu/download


*Analyses conducted in Stata 12*


*--required packages--*
*ssc install coefplot 
*ssc install estout 


***************************************************************************************
*********************************1. MACRO ANALYSES ************************************
***************************************************************************************



use "macro_data.dta", clear


//Fig. 2


pwcorr know_12perc adp_10, obs star(.05)

twoway scatter know_12perc adp_10 , mlabel(cntry) scheme(s1mono)  ytitle("Knowledge of rights 2012 (%)") || lfit know_12perc adp_10 , lcolor(red) 


//Table 1: Lagged Dependent Variable Models


reg know_12perc adp_10 know_06perc 
eststo lag1
reg know_12perc adp_10 know_08perc
eststo lag2
reg know_12perc adp_10 know_09perc
eststo lag3

esttab lag1 lag2 lag3 ///
using "lagged_DV.rtf", b(3) wide nogaps star(+ 0.1 * 0.05 ** 0.01 *** 0.001)  se  stats(N r2) replace


//Fig. A1

twoway scatter adp_10 adp_07, mlabel(cntry) scheme(s1mono) ytitle("Antidiscrimination policy 2010") xtitle("Antidiscrimination policy 2007") ///
  || function y=x, range(0 100)

  
  
  
  
  
  
  

*********************************************************************************************************************
************************************MULTILEVEL ANALYSES**************************************************************
*********************************************************************************************************************



*****************************************************************
******** 2. Antidiscrimination policy index as predictor ********
*****************************************************************



use "EB_discr_merged.dta", clear


//Experienced discrimination as outcome

foreach v of varlist dex* {
xtmelogit `v' first second gender age educ_2 educ_3 educ_4 unemp u2 u3 adp_10_2 ln_gdp_10 unempl_10 fb_cen_12  i.year if year!=2006 ||idx:   , var ml laplace 
eststo model_ADP_`v'
}
*

coefplot model_ADP_dex_gen  , bylabel(Gender) || model_ADP_dex_age  ,bylabel(Age) || model_ADP_dex_eth  , bylabel(Ethnic origin) || model_ADP_dex_rel , bylabel(Religion) || model_ADP_dex_sex , bylabel(Sexual orient.) || ///
model_ADP_dex_dis , bylabel(Disability) || model_ADP_dex_sum, bylabel(Any ground) ||, keep(adp_10_2)  xline(0) bycoefs  scheme(s1mono) ///
 levels(95 90) msymbol(s) mfcolor(white) ciopts(color(blue )) mlabel format(%9.2f)  mlabposition(12)mlabgap(*2) xlabel(,format(%9.0g))   ///
 title("DV: Personally felt discriminated during the past 12 months" "on the basis of...")
 
 
graph save Graph "coefplot_dex_ADP.gph", replace

esttab model_ADP_dex_gen model_ADP_dex_age model_ADP_dex_eth  model_ADP_dex_rel model_ADP_dex_sex model_ADP_dex_dis model_ADP_dex_oth model_ADP_dex_sum ///
using "dex_ADP.rtf", b(3)  star(+ 0.1 * 0.05 ** 0.01 *** 0.001)  se  stats(ll N deviance aic bic) transform(ln*: exp(2*@) 2*exp(2*@)) replace


//Witnessed discrimination as outcome

foreach v of varlist dw* {
xtmelogit `v' first second gender age educ_2 educ_3 educ_4 unemp u2 u3 adp_10_2 ln_gdp_10 unempl_10 fb_cen_12 wm_dex_10  i.year if year!=2006 ||idx:   , var ml laplace 
eststo model_ADP_`v'
}
*

coefplot model_ADP_dw_gen  , bylabel(Gender) || model_ADP_dw_age  ,bylabel(Age) || model_ADP_dw_eth  , bylabel(Ethnic origin) || model_ADP_dw_rel , bylabel(Religion) || model_ADP_dw_sex , bylabel(Sexual orient.) || ///
model_ADP_dw_dis , bylabel(Disability) || model_ADP_dw_any, bylabel(Any ground) ||, keep(adp_10_2)  xline(0) bycoefs  scheme(s1mono) ///
 levels(95 90) msymbol(s) mfcolor(white) ciopts(color(blue )) mlabel format(%9.2f)  mlabposition(12)mlabgap(*2) xlabel(,format(%9.0g))   ///
 title("DV: Witnessed or heard of someone being discriminated" "in the past 12 months on the basis of...")
 
 
graph save Graph "coefplot_dw_ADP.gph", replace

esttab model_ADP_dw_gen model_ADP_dw_age model_ADP_dw_eth  model_ADP_dw_rel model_ADP_dw_sex model_ADP_dw_dis model_ADP_dw_oth model_ADP_dw_any ///
using "dw_ADP.rtf", b(3)  star(+ 0.1 * 0.05 ** 0.01 *** 0.001)  se  stats(ll N deviance aic bic) transform(ln*: exp(2*@) 2*exp(2*@)) replace


//Sociotropic perceptions of discrimination as outcome

foreach v of varlist dper* {
xtmixed `v' first second gender age educ_2 educ_3 educ_4 unemp u2 u3 adp_10_2 ln_gdp_10 unempl_10 fb_cen_12 wm_dex_10  i.year if year!=2006 ||idx:   , var ml 
eststo model_ADP_`v'
}
*

coefplot model_ADP_dper_gen, bylabel(Gender) || model_ADP_dper_age ,bylabel(Age) || model_ADP_dper_eth, bylabel(Ethnic origin) || model_ADP_dper_rel, bylabel(Religion) || model_ADP_dper_sex, bylabel(Sexual orient.) || ///
model_ADP_dper_dis, bylabel(Disability) || model_ADP_dper_mean, bylabel(Average) ||, keep(adp_10_2)  xline(0) bycoefs  scheme(s1mono) ///
 levels(95 90) msymbol(s) mfcolor(white) ciopts(color(blue )) mlabel format(%9.2f)  mlabposition(12)mlabgap(*2) xlabel(,format(%9.0g))  ///
 title("DV: Perceived prevalence of discrimination in R' country," "on the basis of...")
 
 
graph save Graph "coefplot_dper_ADP.gph", replace

esttab model_ADP_dper_gen model_ADP_dper_age model_ADP_dper_eth  model_ADP_dper_rel model_ADP_dper_sex model_ADP_dper_dis model_ADP_dper_mean ///
using "dper_ADP.rtf", b(3)  star(+ 0.1 * 0.05 ** 0.01 *** 0.001)  se  stats(ll N) transform(ln*: exp(2*@) 2*exp(2*@)) replace



//Self-identification with a discriminated group as outcome

use "ESS_discr_merged.dta", clear

foreach v of varlist dgroup* {
xtmelogit `v' i.first i.second i.gender agex educyears unemp2 u1 u2 u4 u5  adp_10_2 ln_gdp_10 unempl_10 fb_cen_12 wm_dex_10  i.year if year!=2006 ||idx:   , var ml  laplace
eststo model_ADP_`v' 
}
*

coefplot model_ADP_dgroup_gen, bylabel(Gender) || model_ADP_dgroup_age ,bylabel(Age) || model_ADP_dgroup_eth2, bylabel(Race or ethnic origin) ||model_ADP_dgroup_nat, bylabel(Nationality) || model_ADP_dgroup_lang, bylabel(Language) ///
|| model_ADP_dgroup_rel, bylabel(Religion) || model_ADP_dgroup_sex, bylabel(Sexual orient.) || ///
model_ADP_dgroup_dis, bylabel(Disability) || model_ADP_dgroup_oth, bylabel(Other) || model_ADP_dgroup_any, bylabel(Any ground) ||, keep(adp_10_2)  xline(0) bycoefs  scheme(s1mono) ///
 levels(95 90) msymbol(s) mfcolor(white) ciopts(color(blue )) mlabel format(%9.2f)  mlabposition(12) mlabgap(*1) xlabel(,format(%9.0g))   ///
 title("DV: Being a member of a group discriminated against" "on the basis of...") 
 
graph save Graph "coefplot_dgroup_ADP.gph", replace


esttab model_ADP_dgroup_gen  model_ADP_dgroup_age  model_ADP_dgroup_eth2  model_ADP_dgroup_nat  model_ADP_dgroup_lang  model_ADP_dgroup_rel  ///
model_ADP_dgroup_sex  model_ADP_dgroup_dis  model_ADP_dgroup_oth  model_ADP_dgroup_any  ///
using "dgroup_ADP.rtf", ///
b(3)  star(+ 0.1 * 0.05 ** 0.01 *** 0.001)  se  stats(ll N deviance aic bic) transform(ln*: exp(2*@) 2*exp(2*@)) replace







*****************************************************************
******* 3. Knowledge of rights as predictor (HYBRID MODELS) *****
*****************************************************************


use "EB_discr_merged.dta", clear


//Experienced discrimination as outcome

foreach v of varlist dex* {
xtmelogit `v' d_know first second gender age educ_2 educ_3 educ_4 unemp u2 u3 b_know w_know adp_10_2 time ||idx: ||cnt_year:  , var ml laplace
eststo model_KNOW_`v'
}
*


coefplot model_KNOW_dex_gen  , bylabel(Gender) || model_KNOW_dex_age  ,bylabel(Age) || model_KNOW_dex_eth  , bylabel(Ethnic origin) || model_KNOW_dex_rel , bylabel(Religion) || model_KNOW_dex_sex , bylabel(Sexual orient.) || ///
model_KNOW_dex_dis , bylabel(Disability) || model_KNOW_dex_oth, bylabel(Other) || model_KNOW_dex_any, bylabel(Any ground) ||, keep(b_know w_know)  xline(0) bycoefs  scheme(s1mono) ///
 levels(95 90) msymbol(s) mfcolor(white) ciopts(color(blue )) mlabel format(%9.2f)  mlabposition(12)mlabgap(*2) xlabel(,format(%9.0g))   ///
 byopts(title("DV: Personally felt discriminated during the past 12 months" "on the basis of..."))
 
 
graph save Graph "coefplot_dex_KNOW.gph", replace


esttab model_KNOW_dex_gen model_KNOW_dex_age model_KNOW_dex_eth  model_KNOW_dex_rel model_KNOW_dex_sex model_KNOW_dex_dis model_KNOW_dex_oth model_KNOW_dex_any ///
using "dex_KNOW.rtf", b(3)  star(+ 0.1 * 0.05 ** 0.01 *** 0.001)  se  stats(ll N deviance aic bic) transform(ln*: exp(2*@) 2*exp(2*@)) replace


//Witnessed discrimination as outcome

foreach v of varlist dw* {
xtmelogit `v' d_know first second gender age educ_2 educ_3 educ_4 unemp u2 u3 b_know w_know adp_10_2 time ||idx: ||cnt_year:  , var ml laplace
eststo model_KNOW_`v'
}
*


coefplot model_KNOW_dw_gen  , bylabel(Gender) || model_KNOW_dw_age  ,bylabel(Age) || model_KNOW_dw_eth  , bylabel(Ethnic origin) || model_KNOW_dw_rel , bylabel(Religion) || model_KNOW_dw_sex , bylabel(Sexual orient.) || ///
model_KNOW_dw_dis , bylabel(Disability) || model_KNOW_dw_oth, bylabel(Other) || model_KNOW_dw_any, bylabel(Any ground) ||, keep(b_know w_know)  xline(0) bycoefs  scheme(s1mono) ///
 levels(95 90) msymbol(s) mfcolor(white) ciopts(color(blue )) mlabel format(%9.2f)  mlabposition(12)mlabgap(*2) xlabel(,format(%9.0g))   ///
 byopts(title("DV: Personally felt discriminated during the past 12 months" "on the basis of..."))
 
 
graph save Graph "coefplot_dw_KNOW.gph", replace


esttab model_KNOW_dw_gen model_KNOW_dw_age model_KNOW_dw_eth  model_KNOW_dw_rel model_KNOW_dw_sex model_KNOW_dw_dis model_KNOW_dw_oth model_KNOW_dw_any ///
using "dw_KNOW.rtf", b(3)  star(+ 0.1 * 0.05 ** 0.01 *** 0.001)  se  stats(ll N deviance aic bic) transform(ln*: exp(2*@) 2*exp(2*@)) replace


//Sociotropic perceptions of discrimination as outcome

foreach v of varlist dper* {
xtmixed `v' d_know first second gender age educ_2 educ_3 educ_4 unemp u2 u3 b_know w_know adp_10_2 time ||idx: ||cnt_year:  , var ml
eststo model_KNOW_`v'
}
*


coefplot model_KNOW_dper_gen, bylabel(Gender) || model_KNOW_dper_age ,bylabel(Age) || model_KNOW_dper_eth, bylabel(Ethnic origin) || model_KNOW_dper_rel, bylabel(Religion) || model_KNOW_dper_sex, bylabel(Sexual orient.) || ///
model_KNOW_dper_dis, bylabel(Disability) || model_KNOW_dper_mean, bylabel(Average) ||, keep(b_know w_know)  xline(0) bycoefs  scheme(s1mono) ///
 levels(95 90) msymbol(s) mfcolor(white) ciopts(color(blue )) mlabel format(%9.2f)  mlabposition(12)mlabgap(*2) xlabel(,format(%9.0g))   ///
 byopts(title("DV: Perceived prevalence of discrimination in R' country," "on the basis of..."))
 
 
graph save Graph "coefplot_dper_KNOW.gph", replace


esttab model_KNOW_dper_gen model_KNOW_dper_age model_KNOW_dper_eth  model_KNOW_dper_rel model_KNOW_dper_sex model_KNOW_dper_dis model_KNOW_dper_mean ///
using "dper_KNOW.rtf", b(3)  star(+ 0.1 * 0.05 ** 0.01 *** 0.001)  se  stats(ll N) transform(ln*: exp(2*@) 2*exp(2*@)) replace


//Self-identification with a discriminated group as outcome

use "ess_discr_merged.dta", clear

foreach v of varlist dgroup* {
xtmelogit `v' first second gender agex educyears unemp2 u1 u2 u4 u5 b_know w_know adp_10_2 time ||idx: ||cnt_year:  , var ml laplace
eststo model_KNOW_`v'
}
*

coefplot model_KNOW_dgroup_gen, bylabel(Gender) || model_KNOW_dgroup_age ,bylabel(Age) || model_KNOW_dgroup_eth2, bylabel(Race or ethnic origin) ||model_KNOW_dgroup_nat, bylabel(Nationality) || model_KNOW_dgroup_lang, bylabel(Language) ///
|| model_KNOW_dgroup_rel, bylabel(Religion) || model_KNOW_dgroup_sex, bylabel(Sexual orient.) || ///
model_KNOW_dgroup_dis, bylabel(Disability) || model_KNOW_dgroup_oth, bylabel(Other) || model_KNOW_dgroup_any, bylabel(Any ground) ||, keep(b_know w_know)  xline(0) bycoefs  scheme(s1mono) ///
 levels(95 90) msymbol(s) mfcolor(white) ciopts(color(blue )) mlabel format(%9.2f)  mlabposition(12) mlabgap(*1) xlabel(,format(%9.0g)) xscale(r(-8 5))  ///
 byopts(title("DV: Being a member of a group discriminated against" "on the basis of...")) 
 
graph save Graph "coefplot_dgroup_KNOW.gph", replace


esttab model_KNOW_dgroup_gen  model_KNOW_dgroup_age  model_KNOW_dgroup_eth2  model_KNOW_dgroup_nat  model_KNOW_dgroup_lang  model_KNOW_dgroup_rel  ///
model_KNOW_dgroup_sex  model_KNOW_dgroup_dis  model_KNOW_dgroup_oth  model_KNOW_dgroup_any  ///
using "dgroup_KNOW.rtf", ///
b(3)  star(+ 0.1 * 0.05 ** 0.01 *** 0.001)  se  stats(ll N deviance aic bic) transform(ln*: exp(2*@) 2*exp(2*@)) replace
 
 
 


*****************************************************************
******** 4. Robustness tests (HYBRID MODELS) ********************
*****************************************************************

use "eb_discr_merged.dta", clear



//Experienced discrimination as outcome

foreach v of varlist dex* {
xtmelogit `v' d_know first second gender age educ_2 educ_3 educ_4 unemp u2 u3 b_know w_know adp_10_2 b_gdp1000 w_gdp1000 b_unempl w_unempl time ||idx: ||cnt_year:  , var ml laplace
eststo model_KNOW_`v'_econ
}
*

esttab model_KNOW_dex_gen_econ model_KNOW_dex_age_econ model_KNOW_dex_eth_econ  model_KNOW_dex_rel_econ model_KNOW_dex_sex_econ model_KNOW_dex_dis_econ model_KNOW_dex_oth_econ model_KNOW_dex_any_econ ///
using "dex_KNOW_robust_econ.rtf", b(3)  star(+ 0.1 * 0.05 ** 0.01 *** 0.001)  se  stats(ll N deviance aic bic) transform(ln*: exp(2*@) 2*exp(2*@)) replace




//Witnessed discrimination as outcome

foreach v of varlist dw* {
xtmelogit `v' d_know first second gender age educ_2 educ_3 educ_4 unemp u2 u3 b_know w_know adp_10_2 b_dex_sum w_dex_sum time ||idx: ||cnt_year:  , var ml laplace
eststo model_KNOW_`v'_dex
}
*


foreach v of varlist dw* {
xtmelogit `v' d_know first second gender age educ_2 educ_3 educ_4 unemp u2 u3 b_know w_know adp_10_2 b_gdp1000 w_gdp1000 b_unempl w_unempl time ||idx: ||cnt_year:  , var ml laplace
eststo model_KNOW_`v'_econ
}
*

esttab model_KNOW_dw_gen_dex model_KNOW_dw_age_dex model_KNOW_dw_eth_dex  model_KNOW_dw_rel_dex model_KNOW_dw_sex_dex model_KNOW_dw_dis_dex model_KNOW_dw_oth_dex model_KNOW_dw_any_dex ///
using "dw_KNOW_robust_dex.rtf", b(3)  star(+ 0.1 * 0.05 ** 0.01 *** 0.001)  se  stats(ll N deviance aic bic) transform(ln*: exp(2*@) 2*exp(2*@)) replace

esttab model_KNOW_dw_gen_econ model_KNOW_dw_age_econ model_KNOW_dw_eth_econ  model_KNOW_dw_rel_econ model_KNOW_dw_sex_econ model_KNOW_dw_dis_econ model_KNOW_dw_oth_econ model_KNOW_dw_any_econ ///
using "dw_KNOW_robust_econ.rtf", b(3)  star(+ 0.1 * 0.05 ** 0.01 *** 0.001)  se  stats(ll N deviance aic bic) transform(ln*: exp(2*@) 2*exp(2*@)) replace




//Sociotropic perceptions of discrimination as outcome

foreach v of varlist dper* {
xtmixed `v' d_know first second gender age educ_2 educ_3 educ_4 unemp u2 u3 b_know w_know adp_10_2 b_dex_sum w_dex_sum time ||idx: ||cnt_year:  , var ml
eststo model_KNOW_`v'_dex
}
*

foreach v of varlist dper* {
xtmixed `v' d_know first second gender age educ_2 educ_3 educ_4 unemp u2 u3 b_know w_know adp_10_2 b_gdp1000 w_gdp1000 b_unempl w_unempl time ||idx: ||cnt_year:  , var ml
eststo model_KNOW_`v'_econ
}
*


esttab model_KNOW_dper_gen_dex model_KNOW_dper_age_dex model_KNOW_dper_eth_dex  model_KNOW_dper_rel_dex model_KNOW_dper_sex_dex model_KNOW_dper_dis_dex model_KNOW_dper_mean_dex ///
using "dper_KNOW_robust_dex.rtf", b(3)  star(+ 0.1 * 0.05 ** 0.01 *** 0.001)  se  stats(ll N deviance aic bic) transform(ln*: exp(2*@) 2*exp(2*@)) replace

esttab model_KNOW_dper_gen_econ model_KNOW_dper_age_econ model_KNOW_dper_eth_econ  model_KNOW_dper_rel_econ model_KNOW_dper_sex_econ model_KNOW_dper_dis_econ model_KNOW_dper_mean_econ ///
using "dper_KNOW_robust_econ.rtf", b(3)  star(+ 0.1 * 0.05 ** 0.01 *** 0.001)  se  stats(ll N deviance aic bic) transform(ln*: exp(2*@) 2*exp(2*@)) replace




//Self-identification with a discriminated group as outcome

use "ess_discr_merged.dta", clear

foreach v of varlist dgroup* {
xtmelogit `v' first second gender agex educyears unemp2 u1 u2 u4 u5 b_know w_know adp_10_2 b_dex_sum w_dex_sum  time ||idx: ||cnt_year:  , var ml laplace
eststo model_KNOW_`v'_dex
}
*

foreach v of varlist dgroup* {
xtmelogit `v' first second gender agex educyears unemp2 u1 u2 u4 u5 b_know w_know adp_10_2 b_gdp1000 w_gdp1000 b_unempl w_unempl time ||idx: ||cnt_year:  , var ml laplace
eststo model_KNOW_`v'_econ
}
*



esttab model_KNOW_dgroup_gen_dex model_KNOW_dgroup_age_dex model_KNOW_dgroup_eth2_dex model_KNOW_dgroup_nat_dex model_KNOW_dgroup_lang_dex model_KNOW_dgroup_rel_dex ///
model_KNOW_dgroup_sex_dex model_KNOW_dgroup_dis_dex model_KNOW_dgroup_oth_dex model_KNOW_dgroup_any_dex ///
using "dgroup_KNOW_robust_dex.rtf", ///
b(3)  star(+ 0.1 * 0.05 ** 0.01 *** 0.001)  se  stats(ll N deviance aic bic) transform(ln*: exp(2*@) 2*exp(2*@)) replace
 
esttab model_KNOW_dgroup_gen_econ model_KNOW_dgroup_age_econ model_KNOW_dgroup_eth2_econ model_KNOW_dgroup_nat_econ model_KNOW_dgroup_lang_econ model_KNOW_dgroup_rel_econ ///
model_KNOW_dgroup_sex_econ model_KNOW_dgroup_dis_econ model_KNOW_dgroup_oth_econ model_KNOW_dgroup_any_econ ///
using "dgroup_KNOW_robust_econ.rtf", ///
b(3)  star(+ 0.1 * 0.05 ** 0.01 *** 0.001)  se  stats(ll N deviance aic bic) transform(ln*: exp(2*@) 2*exp(2*@)) replace






*****************************************************************
******** 5. Illustration effect size ****************************
*****************************************************************

**NOTE: Diff. between highest and lowest observed level of knowledge is .5512275	 

//Witnessed discrimination 'any ground'

use "eb_discr_merged.dta", clear


xtmelogit dw_any d_know first second gender age educ_2 educ_3 educ_4 unemp u2 u3 b_know w_know adp_10_2 time  ||idx: ||cnt_year:  , var ml laplace
margins, dydx(w_know) atmean vsquish predict(mu fixedonly) //.332058
di .332058*.5512275



//Sociotropic perceptions 'average'

xtmixed dper_mean d_know first second gender age educ_2 educ_3 educ_4 unemp u2 u3 b_know w_know adp_10_2 time ||idx: ||cnt_year:  , var ml
margins, dydx(w_know) atmean vsquish  //-1.056664
di -1.056664*.5512275
sum dper_mean



//Self-identification 'any ground'

use "ess_discr_merged.dta", clear


xtmelogit dgroup_any first second gender agex educyears unemp2 u1 u2 u4 u5 b_know w_know adp_10_2 time ||idx: ||cnt_year:  , var ml laplace
margins, dydx(w_know) atmean vsquish predict(mu fixedonly) //-.083734
di -.083734*.5512275






****END****

