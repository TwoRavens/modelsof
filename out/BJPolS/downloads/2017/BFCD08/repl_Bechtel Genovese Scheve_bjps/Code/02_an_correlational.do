*************************************************************************
* Replication archive for Bechtel, Genovese and Scheve (2016)            *
* "Interests, Norms and Support for the Provision of Global Public Goods:*
* The Case of Climate Cooperation", British Journal of Political Science *
*************************************************************************

/* Analysis of the Correlational Data */
capture log close
clear all
set memory 200m
set more off

* Global path
global dropboxpath = "/Users/genovesefederica/Dropbox/Pref IEC_Context/repl_Bechtel Genovese Scheve_bjps/"
*global dropboxpath = "/Users/mbechtel/Desktop/repdata"
*global dropboxpath = "/Users/scheve/Dropbox/Pref IEC_Context/repl_Bechtel Genovese Scheve_bjps/"

/* Use pooled individual-level data */
cd "$dropboxpath/Data/Main Pooled"
use main_pooled_industry.dta

*histogram estimate, percent fcolor(navy) lcolor(white) lpattern(solid) xtitle(Contribution Elasticity (in $))
*histogram  altru_howmuch if altru_howmuch!=0, percent fcolor(navy) lcolor(white) lpattern(solid) xtitle(Altruism (in $))

cd "$dropboxpath/Results/Correlational analysis"
log using "02_analysis_indiv.smcl", replace

tab co2eqdichot emp_status /* 0 Other 1 Paid work 2 Unemployed 3 Retired */
tab co2eqdichot employment, miss

* Enter pollution vars
global pollutionvars="industryco2eq_onlyemp industryco2_onlyemp industryco2eq_wb_onlyemp industryoileq_onlyemp industryco2_emp_onlyemp industryco2eq_emp_onlyemp industryoileq_emp_onlyemp"

/* Descriptives */

* Central outcome is Support for International Cooperation : support_iec_level (reverse of q3_2)
* (5) Strongly support (4) Somewhat support (3) Neither support nor oppose (2) Somewhat oppose (1) Strongly oppose */

* The industry-level pollution measures are: industryco2_onlyemp industryco2eq_onlyemp industryco2eq_wb_onlyemp industryoileq_onlyemp industryco2_emp_onlyemp industryoileq_emp_onlyemp

su support_iec_level reductions_important_level pay_env
tab support_iec_level
tab support_iec_level, nolab
tab reductions_important_level
tab pay_env
tabstat  support_iec_level, by (industryco2eq_onlyemp) stat(mean)
tabstat  reductions_important_level, by (industryco2eq_onlyemp) stat(mean)

tab support_iec_high_group
bysort country: tab support_iec_high_group

proportion support_iec_high_group

*graph pie, over(support_iec_high_group) pie(1, color(midblue)) pie(2, color(green)) plabel(_all percent, size(medlarge) orientation(horizontal) format(%2.1g)) line(lcolor(white) lwidth(none)) legend(order(2 "Support" 1 "Oppose or neither/nor" ) position(6)) graphregion(fcolor(none) lcolor(none) lwidth(none) lpattern(solid) ifcolor(none) ilcolor(none) ilwidth(none)) plotregion(fcolor(white) lcolor(white) ifcolor(none) ilcolor(none))

* France
proportion support_iec_high_group if country==1
* Germany
proportion support_iec_high_group if country==2
* UK
proportion support_iec_high_group if country==3
* US
proportion support_iec_high_group if country==4

* Correlations

pwcorr recip_s_high_group altru_donate industryco2eq_onlyemp reductions_important_level, sig

cd "$dropboxpath/Results/Correlational analysis"
* Generate continuous interactions
foreach var of varlist $pollutionvars {
gen `var'Xrecipc= `var'*recip_s_method
gen `var'Xaltruc= `var'*altru_howmuch
}


/* Main Regressions (by categories, unweighted values)  */

* Table 1 - Main Correlational Results: Binary IEC, original scale Reductions, and WTP
* First regression is placeholder for vars

* IEC: binary
regress support_iec_high_group female agegr30_39 agegr40_49 agegr50_59 agegr60_o incgr_lowermiddle incgr_uppermiddle incgr_high educ_high i.recip_s_high_group i.altru_donate i.industryco2eq_onlyemp i.country  if emp_status==1 & industryco2eq_onlyemp!=.  , robust
outreg2 using reg_siec_main.xls, ctitle(placeholder) excel bdec(3) stats(coef se) replace

regress support_iec_high_group female agegr30_39 agegr40_49 agegr50_59 agegr60_o incgr_lowermiddle incgr_uppermiddle incgr_high educ_high i.country  if emp_status==1 & industryco2eq_onlyemp!=.  , robust
outreg2 using reg_siec_main.xls, ctitle("Socio-demographics") excel bdec(3) stats(coef se) append

regress support_iec_high_group female agegr30_39 agegr40_49 agegr50_59 agegr60_o incgr_lowermiddle incgr_uppermiddle incgr_high educ_high i.recip_s_high_group i.altru_donate i.country if emp_status==1 & industryco2eq_onlyemp!=.  , robust
outreg2 using reg_siec_main.xls, ctitle(Norms) excel bdec(3) stats(coef se) append

regress support_iec_high_group female agegr30_39 agegr40_49 agegr50_59 agegr60_o incgr_lowermiddle incgr_uppermiddle incgr_high educ_high i.industryco2eq_onlyemp i.country if emp_status==1 & industryco2eq_onlyemp!=. , robust
outreg2 using reg_siec_main.xls, ctitle(Interest) excel bdec(3) stats(coef se) append

regress support_iec_high_group female agegr30_39 agegr40_49 agegr50_59 agegr60_o incgr_lowermiddle incgr_uppermiddle incgr_high educ_high i.recip_s_high_group i.altru_donate i.industryco2eq_onlyemp i.country  if emp_status==1 & industryco2eq_onlyemp!=.  , robust
outreg2 using reg_siec_main.xls, ctitle(Full) excel bdec(3) stats(coef se) append

* Importance of reductions and WTP (original scale): full models
foreach Y of varlist reductions_important_level pay_env  {
regress `Y' female agegr30_39 agegr40_49 agegr50_59 agegr60_o incgr_lowermiddle incgr_uppermiddle incgr_high educ_high i.recip_s_high_group i.altru_donate i.industryco2eq_onlyemp i.country if emp_status==1  & industryco2eq_onlyemp!=. , robust
outreg2 using reg_siec_main.xls, ctitle(Outcome: `Y') excel bdec(3) stats(coef se) append
	}
	
	
/* Additional Regressions in the Appendix  */

* Appendix Tables A.6-A.8:  Alternative  Measures of Industrial Pollution Cost - models of IEC (binary), importance of reductions and WTP (original scale)

global appendixvar="industryco2eq_wb_onlyemp industryco2_onlyemp industryoileq_onlyemp industryco2eq_emp_onlyemp"

regress support_iec_high_group 
outreg2 using reg_siec_app_alternativecostmeasures.xls, ctitle(placeholder) excel bdec(3) stats(coef se) label replace

foreach Y of varlist support_iec_high_group reductions_important_level pay_env {
foreach var of varlist $appendixvar 				{
regress `Y' female agegr30_39 agegr40_49 agegr50_59 agegr60_o incgr_lowermiddle incgr_uppermiddle incgr_high educ_high i.recip_s_high_group i.altru_donate i.`var' i.country if emp_status==1  , robust
outreg2 using reg_siec_app_alternativecostmeasures.xls, ctitle(Outcome: `Y', Measure: `var') excel bdec(3) stats(coef se) label append
	}
}	

* Appendix Table A.9: Models with Car 
foreach Y of varlist support_iec_high_group reductions_important_level pay_env  {
regress `Y' female agegr30_39 agegr40_49 agegr50_59 agegr60_o incgr_lowermiddle incgr_uppermiddle incgr_high educ_high i.recip_s_high_group i.altru_donate i.industryco2eq_onlyemp i.owncar i.country if emp_status==1  , robust
outreg2 using reg_siec_app_car.xls, ctitle(Outcome: `Y' (car ownership)) excel bdec(3) stats(coef se) label append
	}
	
* Appendix Table A.10: Models with Right vs Left
foreach Y of varlist support_iec_high_group reductions_important_level pay_env {
regress `Y' female agegr30_39 agegr40_49 agegr50_59 agegr60_o incgr_lowermiddle incgr_uppermiddle incgr_high educ_high i.recip_s_high_group i.altru_donate i.industryco2eq_onlyemp i.right i.country if emp_status==1  , robust
outreg2 using reg_siec_app_ideol.xls, ctitle(Outcome: `Y' (ideology)) excel bdec(3) stats(coef se) label append
}

* Appendix Table A.11: GHG missingness, employment status regressions, controlling for environmentalism
regress support_iec_high_group female agegr30_39 agegr40_49 agegr50_59 agegr60_o incgr_lowermiddle incgr_uppermiddle incgr_high educ_high i.recip_s_high_group i.altru_donate i.industryco2eq
outreg2 using reg_siec_app_employment.xls, ctitle(Placeholder) excel bdec(3) stats(coef se) replace

regress support_iec_high_group female agegr30_39 agegr40_49 agegr50_59 agegr60_o incgr_lowermiddle incgr_uppermiddle incgr_high educ_high i.recip_s_high_group i.altru_donate i.industryco2eq i.country  , robust
outreg2 using reg_siec_app_employment.xls, ctitle(Binary SIEC, Full) excel bdec(3) stats(coef se)append

regress support_iec_level female agegr30_39 agegr40_49 agegr50_59 agegr60_o incgr_lowermiddle incgr_uppermiddle incgr_high educ_high i.recip_s_high_group i.altru_donate i.industryco2eq i.country  , robust
outreg2 using reg_siec_app_employment.xls, ctitle(5 points SIEC, Full) excel bdec(3) stats(coef se) append

regress support_iec_high_group female agegr30_39 agegr40_49 agegr50_59 agegr60_o incgr_lowermiddle incgr_uppermiddle incgr_high educ_high i.recip_s_high_group i.altru_donate i.emp_status i.country  , robust
outreg2 using reg_siec_app_employment.xls, ctitle(Binary SIEC, Full) excel bdec(3) stats(coef se) append

/* Appendix table (continued):  dummies for retired and unemployed*/
gen unemployed=1 if emp_status==2
replace unemployed=0 if unemployed==.
gen retired=1 if emp_status==3
replace retired=0 if retired==.

regress support_iec_high_group female agegr30_39 agegr40_49 agegr50_59 agegr60_o incgr_lowermiddle incgr_uppermiddle incgr_high educ_high i.recip_s_high_group i.altru_donate  i.industryco2eq i.unemployed i.retired i.country    , robust
outreg2 using reg_siec_app_employment.xls, ctitle(Binary SIEC, Full w/ unemployed and retired) excel bdec(3) stats(coef se) append

regress support_iec_high_group female agegr30_39 agegr40_49 agegr50_59 agegr60_o incgr_lowermiddle incgr_uppermiddle incgr_high educ_high i.recip_s_high_group i.altru_donate i.industryco2eq i.right reductions_important_level i.country if emp_status==1  , robust
outreg2 using reg_siec_app_employment.xls, ctitle(Binary SIEC, Environmental) excel bdec(3) stats(coef se) append

* Appendix Table A.12: Models of IEC (binary) by country
foreach Y of varlist support_iec_level  {
regress `Y' female agegr30_39 agegr40_49 agegr50_59 agegr60_o incgr_lowermiddle incgr_uppermiddle incgr_high educ_high  i.recip_s_high_group i.altru_donate i.industryco2eq_onlyemp if country==1 &  emp_status==1  , robust
outreg2 using reg_siec_app_bycountry.xls, ctitle(France, Outcome: `Y', Measure: industryco2eq_onlyemp) excel bdec(3) stats(coef se) append

regress `Y' female agegr30_39 agegr40_49 agegr50_59 agegr60_o incgr_lowermiddle incgr_uppermiddle incgr_high educ_high  i.recip_s_high_group i.altru_donate i.industryco2eq_onlyemp if country==2 &  emp_status==1   , robust
outreg2 using reg_siec_app_bycountry.xls, ctitle(Germany, Outcome: `Y', Measure: industryco2eq_onlyemp) excel bdec(3) stats(coef se) append

regress `Y' female agegr30_39 agegr40_49 agegr50_59 agegr60_o incgr_lowermiddle incgr_uppermiddle incgr_high educ_high i.recip_s_high_group i.altru_donate i.industryco2eq_onlyemp if country==3 &  emp_status==1  , robust
outreg2 using reg_siec_app_bycountry.xls, ctitle("United Kingdom, Outcome: `Y', Measure: industryco2eq_onlyemp") excel bdec(3) stats(coef se) append

regress `Y' female agegr30_39 agegr40_49 agegr50_59 agegr60_o incgr_lowermiddle incgr_uppermiddle incgr_high educ_high i.recip_s_high_group i.altru_donate i.industryco2eq_onlyemp if country==4 &  emp_status==1  , robust
outreg2 using reg_siec_app_bycountry.xls, ctitle("United States, Outcome: `Y', Measure: industryco2eq_onlyemp") excel bdec(3) stats(coef se) append
	}
	
* Appendix Table A.13: Main Correlational Results using the outcome vars in levels (ordered probit for support climate change (scale 1-5)
* Tobit for reductions important and WTP measure, scale 1-10

oprobit support_iec_level female agegr30_39 agegr40_49 agegr50_59 agegr60_o incgr_lowermiddle incgr_uppermiddle incgr_high educ_high i.recip_s_high_group i.altru_donate i.industryco2eq_onlyemp i.country if emp_status==1  , robust
outreg2 using reg_siec_app_oprobit.xls, ctitle(placeholder) excel bdec(3) stats(coef se) replace

oprobit support_iec_level female agegr30_39 agegr40_49 agegr50_59 agegr60_o incgr_lowermiddle incgr_uppermiddle incgr_high educ_high i.country  if emp_status==1 & industryco2eq_onlyemp!=.  , robust
outreg2 using reg_siec_app_oprobit.xls, ctitle("Socio-demographics") excel bdec(3) stats(coef se) append

oprobit support_iec_level female agegr30_39 agegr40_49 agegr50_59 agegr60_o incgr_lowermiddle incgr_uppermiddle incgr_high educ_high i.recip_s_high_group i.altru_donate i.country  if emp_status==1 & industryco2eq_onlyemp!=.  , robust
outreg2 using reg_siec_app_oprobit.xls, ctitle(Norms) excel bdec(3) stats(coef se) append

oprobit support_iec_level female agegr30_39 agegr40_49 agegr50_59 agegr60_o incgr_lowermiddle incgr_uppermiddle incgr_high educ_high i.industryco2eq_onlyemp i.country  if emp_status==1 & industryco2eq_onlyemp!=.  , robust
outreg2 using reg_siec_app_oprobit.xls, ctitle(Interest) excel bdec(3) stats(coef se) append

oprobit support_iec_level female agegr30_39 agegr40_49 agegr50_59 agegr60_o incgr_lowermiddle incgr_uppermiddle incgr_high educ_high i.recip_s_high_group i.altru_donate i.industryco2eq_onlyemp i.country  if emp_status==1 & industryco2eq_onlyemp!=.   , robust 
outreg2 using reg_siec_app_oprobit.xls, ctitle(Full) excel bdec(3) stats(coef se) append

tobit reductions_important_level female agegr30_39 agegr40_49 agegr50_59 agegr60_o incgr_lowermiddle incgr_uppermiddle incgr_high educ_high i.recip_s_high_group i.altru_donate i.industryco2eq_onlyemp i.country if emp_status==1 & industryco2eq_onlyemp!=.   , robust ll(0) ul(10)
outreg2 using reg_siec_app_oprobit.xls, ctitle(Tobit - Outcome: reductions_important_level) excel bdec(3) stats(coef se) append

tobit pay_env female agegr30_39 agegr40_49 agegr50_59 agegr60_o incgr_lowermiddle incgr_uppermiddle incgr_high educ_high i.recip_s_high_group i.altru_donate i.industryco2eq_onlyemp i.country if emp_status==1 & industryco2eq_onlyemp!=.   , robust ll(0) ul(100)
outreg2 using reg_siec_app_oprobit.xls, ctitle(Tobit - Outcome: pay_env) excel bdec(3) stats(coef se) append
	
*  Appendix Table A.14: Models without the (most likely?)  public sectors and with dummy for public sectors
* ISIC: 13 (Scientific & technical activities) 14 (Admin and support service) 15 (Public admin and defense) 16 (Education) 17 (Human health and social work) 18 (Arts and Recreation)

foreach Y of varlist support_iec_high_group reductions_important_level pay_env {
regress `Y' female agegr30_39 agegr40_49 agegr50_59 agegr60_o incgr_lowermiddle incgr_uppermiddle incgr_high educ_high i.recip_s_high_group i.altru_donate i.industryco2eq_onlyemp i.country  if emp_status==1 & industryco2eq_onlyemp!=. & isic4_major_02!=13 & isic4_major_02!=14 & isic4_major_02!=15 & isic4_major_02!=16 & isic4_major_02!=17 & isic4_major_02!=18   , robust
outreg2 using reg_siec_app_publicsect.xls, ctitle(Outcome: `Y', without likely public sectors) excel bdec(3) stats(coef se) label replace
}
gen publicsector=0 if emp_status==1 & industryco2eq_onlyemp!=. 
replace publicsector=1 if isic4_major_02==13 | isic4_major_02==14 | isic4_major_02==15 | isic4_major_02==16 | isic4_major_02==17 | isic4_major_02==18

foreach Y of varlist support_iec_high_group reductions_important_level pay_env {
regress `Y' female agegr30_39 agegr40_49 agegr50_59 agegr60_o incgr_lowermiddle incgr_uppermiddle incgr_high educ_high i.recip_s_high_group i.altru_donate i.industryco2eq_onlyemp i.publicsector i.country  if emp_status==1 & industryco2eq_onlyemp!=.  , robust
outreg2 using reg_siec_app_publicsect.xls, ctitle(Outcome: `Y', dummy for likely public sectors) excel bdec(3) stats(coef se) label append
}	
	
* Appendix Table A.15: Interactions between Measures of Norms and Industry Measures

regress support_iec_high_group
outreg2 using reg_siec_app_interactions.xls, ctitle() excel bdec(3) stats(coef se) label replace

foreach Y of varlist support_iec_high_group reductions_important_level pay_env {
regress `Y' female agegr30_39 agegr40_49 agegr50_59 agegr60_o incgr_lowermiddle incgr_uppermiddle incgr_high educ_high recip_s_high_group altru_donate industryco2eq_onlyemp industryco2eq_onlyempXrecip industryco2eq_onlyempXaltru i.country if emp_status==1 & industryco2eq_onlyemp!=.  , robust
outreg2 using reg_siec_app_interactions.xls, ctitle(Outcome: `Y', Interactions) excel bdec(3) stats(coef se) label append
}


* Appendix Table A.16: Unemployed individuals as the ref group
/* Recode CO2 eq intensity variables to make not employed individuals the ref group*/
recode industryco2eq (0=1) (1=2) (2=0), gen(industryco2eq_recoded)
lab define industryco2eq_recoded 0 consumers 1 low 2 high 
lab values industryco2eq_recoded industryco2eq_recoded
tab industryco2eq_recoded
tab industryco2eq_recoded, nolab

regress support_iec_high_group female agegr30_39 agegr40_49 agegr50_59 agegr60_o incgr_lowermiddle incgr_uppermiddle incgr_high educ_high i.recip_s_high_group i.altru_donate i.industryco2eq_recoded i.country  , robust
outreg2 using reg_siec_app_unemployedref.xls, ctitle(Binary SIEC, Full, Ref recoded) excel bdec(3) stats(coef se) append

regress support_iec_level female agegr30_39 agegr40_49 agegr50_59 agegr60_o incgr_lowermiddle incgr_uppermiddle incgr_high educ_high i.recip_s_high_group i.altru_donate i.industryco2eq_recoded i.country  , robust
outreg2 using reg_siec_app_unemployedref.xls, ctitle(5 points SIEC, Full, Ref recoded) excel bdec(3) stats(coef se) append

regress support_iec_high_group female agegr30_39 agegr40_49 agegr50_59 agegr60_o incgr_lowermiddle incgr_uppermiddle incgr_high educ_high i.recip_s_high_group i.altru_donate  i.industryco2eq_recoded i.unemployed i.retired i.country    , robust
outreg2 using reg_siec_app_unemployedref.xls, ctitle(Binary SIEC, Full Ref recoded, w/ unemployed and retired) excel bdec(3) stats(coef se) append


* Appendix Table A.17: Main models ran with raw, three- and four-category CO2 eq variables *
gen co2bteq=co2mteq/1000
regress support_iec_high_group female agegr30_39 agegr40_49 agegr50_59 agegr60_o incgr_lowermiddle incgr_uppermiddle incgr_high educ_high i.recip_s_high_group i.altru_donate co2bteq  i.country if emp_status==1 & industryco2eq_onlyemp!=.  , robust
outreg2 using reg_siec_app_othercatcost.xls, ctitle(placeholder) excel bdec(3) stats(coef se) replace

foreach Y of varlist support_iec_high_group    {
regress `Y' female agegr30_39 agegr40_49 agegr50_59 agegr60_o incgr_lowermiddle incgr_uppermiddle incgr_high educ_high i.recip_s_high_group i.altru_donate co2bteq i.country if emp_status==1  & industryco2eq_onlyemp!=.  , robust
outreg2 using reg_siec_app_othercatcost.xls, ctitle(Outcome: `Y', Raw Co2eq) excel bdec(3) stats(coef se) append
	}

global catcostvar="co2eqtert co2eqquart" /* Note that, although we added a "3" for unemployed in the original coding of the dichotomous var, the unmployed are dropped in this analysis*/
foreach Y of varlist support_iec_high_group    {
foreach var of varlist $catcostvar 				{
regress `Y' female agegr30_39 agegr40_49 agegr50_59 agegr60_o incgr_lowermiddle incgr_uppermiddle incgr_high educ_high i.recip_s_high_group i.altru_donate i.`var' i.country if emp_status==1  & industryco2eq_onlyemp!=.  , robust
outreg2 using reg_siec_app_othercatcost.xls, ctitle(Outcome: `Y') excel bdec(3) stats(coef se) append
	}
 } 

*****  Appendix Table A.18: Main table without Germany  (IEC: binary)
regress support_iec_high_group female agegr30_39 agegr40_49 agegr50_59 agegr60_o incgr_lowermiddle incgr_uppermiddle incgr_high educ_high i.recip_s_high_group i.altru_donate i.industryco2eq_onlyemp i.country if emp_status==1 & industryco2eq_onlyemp!=. & country!=2  , robust
outreg2 using reg_siec_app_noGermany.xls, ctitle(placeholder) excel bdec(3) stats(coef se) replace

regress support_iec_high_group female agegr30_39 agegr40_49 agegr50_59 agegr60_o incgr_lowermiddle incgr_uppermiddle incgr_high educ_high i.recip_s_high_group i.altru_donate i.industryco2eq_onlyemp i.country  if emp_status==1 & industryco2eq_onlyemp!=.  & country!=2   , robust
outreg2 using reg_siec_app_noGermany.xls, ctitle(Full) excel bdec(3) stats(coef se) append

foreach Y of varlist reductions_important_level pay_env  {
regress `Y' female agegr30_39 agegr40_49 agegr50_59 agegr60_o incgr_lowermiddle incgr_uppermiddle incgr_high educ_high i.recip_s_high_group i.altru_donate i.industryco2eq_onlyemp i.country if emp_status==1  & industryco2eq_onlyemp!=.  & country!=2   , robust
outreg2 using reg_siec_app_noGermany.xls, ctitle(Outcome: `Y') excel bdec(3) stats(coef se) append
	}

* Appendix Table A.19: Main models with weights

* IEC: binary
regress support_iec_high_group female agegr30_39 agegr40_49 agegr50_59 agegr60_o incgr_lowermiddle incgr_uppermiddle incgr_high educ_high i.recip_s_high_group i.altru_donate i.industryco2eq_onlyemp i.country if emp_status==1 & industryco2eq_onlyemp!=. [aweight = weight], robust
outreg2 using reg_siec_app_weights.xls, ctitle(placeholder) excel bdec(3) stats(coef se) replace

regress support_iec_high_group female agegr30_39 agegr40_49 agegr50_59 agegr60_o incgr_lowermiddle incgr_uppermiddle incgr_high educ_high i.country  if emp_status==1 & industryco2eq_onlyemp!=. [aweight = weight], robust
outreg2 using reg_siec_app_weights.xls, ctitle("Socio-demographics") excel bdec(3) stats(coef se) append

regress support_iec_high_group female agegr30_39 agegr40_49 agegr50_59 agegr60_o incgr_lowermiddle incgr_uppermiddle incgr_high educ_high i.recip_s_high_group i.altru_donate i.country  if emp_status==1 & industryco2eq_onlyemp!=. [aweight = weight], robust
outreg2 using reg_siec_app_weights.xls, ctitle(Norms) excel bdec(3) stats(coef se) append

regress support_iec_high_group female agegr30_39 agegr40_49 agegr50_59 agegr60_o incgr_lowermiddle incgr_uppermiddle incgr_high educ_high i.industryco2eq_onlyemp i.country  if emp_status==1 & industryco2eq_onlyemp!=. [aweight = weight], robust
outreg2 using reg_siec_app_weights.xls, ctitle(Interest) excel bdec(3) stats(coef se) append

regress support_iec_high_group female agegr30_39 agegr40_49 agegr50_59 agegr60_o incgr_lowermiddle incgr_uppermiddle incgr_high educ_high i.recip_s_high_group i.altru_donate i.industryco2eq_onlyemp i.country  if emp_status==1 & industryco2eq_onlyemp!=. [aweight = weight], robust
outreg2 using reg_siec_app_weights.xls, ctitle(Full) excel bdec(3) stats(coef se) append

* Importance of reductions and WTP (original scale): full models
foreach Y of varlist reductions_important_level pay_env  {
regress `Y' female agegr30_39 agegr40_49 agegr50_59 agegr60_o incgr_lowermiddle incgr_uppermiddle incgr_high educ_high i.recip_s_high_group i.altru_donate i.industryco2eq_onlyemp i.country if emp_status==1  & industryco2eq_onlyemp!=. [aweight = weight], robust
outreg2 using reg_siec_app_weights.xls, ctitle(Outcome: `Y') excel bdec(3) stats(coef se) append
	}
	
	
log close
exit
