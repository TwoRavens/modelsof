version 8.2
capture clear
capture log close
set more off
set mem 5000m
set mat 2000



use "Enterprise surveys_judicial_reforms_standardized dataset_with pre data.dta"

sum DJ4g1m
centile(DJ4g1m), centile(50)
display `r(c_1)'
*hist DJ4g1, percent

label variable h7a "Judicial efficiency"
label variable reform_dum1_post "Judicial reform * Post" 
label variable reform_dum1_post_DJ4g1m  "Judicial reform * Post * Specific" 

label variable reform_dum1_pre "Judicial reform * Pre" 
label variable reform_dum1_pre_DJ4g1m  "Judicial reform * Pre * Specific" 


label variable reform_dum_small1_post "Limited judicial reform * Post" 
label variable reform_db_dum_post "Domestic judicial reform * Post" 

label variable dtf "Business climate"
replace foreign_aid2_percap=foreign_aid2_percap*1000000
label variable  foreign_aid2_percap "Foreign aid per capita"


replace va_perwo_ppp_trim1=va_perwo_ppp_trim1/1000
label variable va_perwo_ppp_trim1 "Value added per worker (Thousand dollars)"
local lab : var label va_perwo_ppp_trim1


sum va_perwo_ppp_trim1 if reform_dum1==0&pre!=1
sum h7a if reform_dum1==0&pre!=1




*Triple diff:


xi: reg h7a reform_dum1_post reform_dum1_post_DJ4g1m i.post*DJ4g1m reform_dum1_pre reform_dum1_pre_DJ4g1m i.pre*DJ4g1m i.countryname*DJ4g1m, robust cluster(countryname)
****F-test:
global varlist reform_dum1_post_DJ4g1m _IposXDJ4g1_1 _IcouXDJ4_* DJ4g1m
testparm $varlist
local F_test=r(F)
sum va_perwo_ppp_trim1 if reform_dum1==0
local mean_dep_var=r(mean)
local sd_dep_var=r(sd)
outreg2 using "Table3.tex", tex  addtext(Country fixed effects, YES) ///
keep(reform_dum1_post reform_dum1_post_DJ4g1m reform_dum1_pre reform_dum1_pre_DJ4g1m) ///
addstat("F-test", `F_test', "Mean control group", `mean_dep_var', "(SD)", `sd_dep_var') ///
label bdec(2) se sdec(2) ctitle("Triple difference") replace


xi: reg va_perwo_ppp_trim1 reform_dum1_post reform_dum1_post_DJ4g1m i.post*DJ4g1m reform_dum1_pre reform_dum1_pre_DJ4g1m i.pre*DJ4g1m i.countryname*DJ4g1m, robust cluster(countryname)
****F-test:
global varlist reform_dum1_post_DJ4g1m _IposXDJ4g1_1 _IcouXDJ4_* DJ4g1m
testparm $varlist
local F_test=r(F)
sum va_perwo_ppp_trim1 if reform_dum1==0
local mean_dep_var=r(mean)
local sd_dep_var=r(sd)
outreg2 using "Table3.tex", tex addtext(Country fixed effects, YES) ///
keep(reform_dum1_post reform_dum1_post_DJ4g1m reform_dum1_pre reform_dum1_pre_DJ4g1m) ///
addstat("F-test", `F_test', "Mean control group", `mean_dep_var', "(SD)", `sd_dep_var') ///
label bdec(2) se sdec(2) ctitle("Triple difference") append


 
xi: reg va_perwo_ppp_trim1 reform_dum1_post reform_dum1_post_DJ4g1m reform_dum_small1_post reform_dum_small1_pre i.post*DJ4g1m  reform_dum1_pre reform_dum1_pre_DJ4g1m i.pre*DJ4g1m i.countryname*DJ4g1m, robust cluster(countryname)
****F-test:
global varlist reform_dum1_post_DJ4g1m _IposXDJ4g1_1 _IcouXDJ4_* DJ4g1m
testparm $varlist
local F_test=r(F)
sum va_perwo_ppp_trim1 if reform_dum1==0
local mean_dep_var=r(mean)
local sd_dep_var=r(sd)
outreg2 using "Table3.tex", tex  addtext(Country fixed effects, YES) ///
keep(reform_dum1_post reform_dum1_post_DJ4g1m reform_dum1_pre reform_dum1_pre_DJ4g1m reform_dum_small1_post reform_db_dum_post dtf foreign_aid2_percap) ///
addstat("F-test", `F_test', "Mean control group", `mean_dep_var', "(SD)", `sd_dep_var') ///
  label bdec(2) se sdec(2) ctitle("Triple difference") append

*adec(2) addstat("F-test", `F_test', "Mean control group", `mean_dep_var', "(SD)", `sd_dep_var')

xi: reg va_perwo_ppp_trim1 reform_dum1_post reform_dum1_post_DJ4g1m reform_dum_small1_post reform_dum_small1_pre reform_db_dum_post reform_db_dum_pre i.post*DJ4g1m  reform_dum1_pre reform_dum1_pre_DJ4g1m i.pre*DJ4g1m i.countryname*DJ4g1m, robust cluster(countryname)
****F-test:
global varlist reform_dum1_post_DJ4g1m _IposXDJ4g1_1 _IcouXDJ4_* DJ4g1m
testparm $varlist
local F_test=r(F)
sum va_perwo_ppp_trim1 if reform_dum1==0
local mean_dep_var=r(mean)
local sd_dep_var=r(sd)
outreg2 using "Table3.tex", tex  addtext(Country fixed effects, YES) ///
keep(reform_dum1_post reform_dum1_post_DJ4g1m reform_dum1_pre reform_dum1_pre_DJ4g1m reform_dum_small1_post reform_db_dum_post dtf foreign_aid2_percap) ///
addstat("F-test", `F_test', "Mean control group", `mean_dep_var', "(SD)", `sd_dep_var') ///
 label bdec(2) se sdec(2) ctitle("Triple difference") append

 
xi: reg va_perwo_ppp_trim1 reform_dum1_post reform_dum1_post_DJ4g1m reform_dum_small1_post reform_dum_small1_pre reform_db_dum_post reform_db_dum_pre i.post*DJ4g1m  reform_dum1_pre reform_dum1_pre_DJ4g1m i.pre*DJ4g1m i.countryname*DJ4g1m i.DJ4g1m*dtf, robust cluster(countryname)
****F-test:
global varlist reform_dum1_post_DJ4g1m _IposXDJ4g1_1 _IcouXDJ4_* DJ4g1m  _IDJ4g1m_1 _IDJ4Xdtf_1 
testparm $varlist
local F_test=r(F)
sum va_perwo_ppp_trim1 if reform_dum1==0
local mean_dep_var=r(mean)
local sd_dep_var=r(sd)
outreg2 using "Table3.tex", tex  addtext(Country fixed effects, YES) ///
keep(reform_dum1_post reform_dum1_post_DJ4g1m reform_dum1_pre reform_dum1_pre_DJ4g1m reform_dum_small1_post reform_db_dum_post dtf) ///
 addstat("F-test", `F_test', "Mean control group", `mean_dep_var', "(SD)", `sd_dep_var') ///
label bdec(2) se sdec(2) ctitle("Triple difference") append

 
xi: reg va_perwo_ppp_trim1 reform_dum1_post reform_dum1_post_DJ4g1m reform_dum_small1_post reform_dum_small1_pre reform_db_dum_post reform_db_dum_pre i.post*DJ4g1m  reform_dum1_pre reform_dum1_pre_DJ4g1m i.pre*DJ4g1m i.countryname*DJ4g1m i.DJ4g1m*dtf i.DJ4g1m*foreign_aid2_percap, robust cluster(countryname)
****F-test:
global varlist reform_dum1_post_DJ4g1m _IposXDJ4g1_1 _IcouXDJ4_* DJ4g1m _IDJ4g1m_1 _IDJ4Xdtf_1 _IDJ4Xforei_1 	  
testparm $varlist
local F_test=r(F)
sum va_perwo_ppp_trim1 if reform_dum1==0
local mean_dep_var=r(mean)
local sd_dep_var=r(sd)
outreg2 using "Table3.tex", tex  addtext(Country fixed effects, YES) ///
keep(reform_dum1_post reform_dum1_post_DJ4g1m reform_dum1_pre reform_dum1_pre_DJ4g1m reform_dum_small1_post reform_db_dum_post dtf foreign_aid2_percap) ///
addstat("F-test", `F_test', "Mean control group", `mean_dep_var', "(SD)", `sd_dep_var') ///
 label bdec(2) se sdec(2) ctitle("Triple difference") append


 
xi: reg va_perwo_ppp_trim1 reform_dum1_post reform_dum1_post_DJ4g1m reform_dum_small1_post reform_db_dum_post i.post*DJ4g1m  reform_dum1_pre reform_dum1_pre_DJ4g1m i.pre*DJ4g1m i.countryname*DJ4g1m  i.DJ4g1m*dtf i.DJ4g1m*foreign_aid2_percap i.sector*DJ4g1m, robust cluster(countryname)
****F-test:
*global varlist reform_dum1_post_DJ4g1m _IposXDJ4g1_1 _IcouXDJ4_* DJ4g1m
global varlist reform_dum1_post_DJ4g1m _IposXDJ4g1_1 _IcouXDJ4_* DJ4g1m  _IDJ4g1m_1 _IDJ4Xdtf_1 _IDJ4Xforei_1 _IsecXDJ4_*
testparm $varlist

local F_test=r(F)
sum va_perwo_ppp_trim1 if reform_dum1==0
local mean_dep_var=r(mean)
local sd_dep_var=r(sd)
outreg2 using "Table3.tex", tex  addtext(Country fixed effects, YES, Sector fixed effects, YES) ///
keep(reform_dum1_post reform_dum1_post_DJ4g1m reform_dum_small1_post reform_db_dum_post dtf foreign_aid2_percap) ///
sortvar(reform_dum1_post reform_dum1_post_DJ4g1m reform_dum1_pre reform_dum1_pre_DJ4g1m reform_dum1_post_Sue reform_dum1_post_DJ4g1m_Sue  reform_dum1_post_Po reform_dum1_post_DJ4g1m_Po reform_dum_small1_post reform_db_dum_post dtf foreign_aid2_percap) ///
 addstat("F-test", `F_test', "Mean control group", `mean_dep_var', "(SD)", `sd_dep_var') ///
 label bdec(2) se sdec(2) ctitle("Triple difference") append

 
 

label variable reform_dum1_post_DJ4g1m  "Judicial reform * Post * Specific" 

label variable reform_edu_gdp_post_DJ4g1m "Education * Post * Specific"
label variable reform_health_gdp_post_DJ4g1m "Health * Post * Specific"
label variable reform_trans_gdp_post_DJ4g1m "Transport * Post * Specific"
label variable reform_nrj_gdp_post_DJ4g1m "Energy * Post * Specific"
label variable reform_bank_gdp_post_DJ4g1m "Bank * Post * Specific"
label variable reform_indus_gdp_post_DJ4g1m "Support Industry * Post * Specific"
label variable reform_trade_gdp_post_DJ4g1m "Trade * Post * Specific"
label variable reform_debt_gdp_post_DJ4g1m "Debt * Post * Specific"
label variable reform_corrup_gdp_post_DJ4g1m "Corruption * Post * Specific"
label variable reform_tax_gdp_post_DJ4g1m "Tax * Post * Specific"
label variable reform_confl_gdp_post_DJ4g1m "Conflict * Post * Specific"
label variable reform_parlia_gdp_post_DJ4g1m "Parliament * Post * Specific"
label variable reform_elec_gdp_post_DJ4g1m "Elections * Post * Specific"
label variable reform_media_gdp_post_DJ4g1m "Media * Post * Specific"



*Table Other reforms:
xi: reg va_perwo_ppp_trim1 reform_dum1_post reform_dum1_post_DJ4g1m reform_dum_small1_post reform_db_dum_post reform_edu_gdp_post reform_edu_gdp_post_DJ4g1m i.post*DJ4g1m  i.countryname*DJ4g1m i.DJ4g1m*dtf i.DJ4g1m*foreign_aid2_percap i.sector*DJ4g1m, robust cluster(countryname)
sum va_perwo_ppp_trim1 if reform_dum1==0
local mean_dep_var=r(mean)
local sd_dep_var=r(sd)
outreg2 using "Table4.tex", tex  addtext(Country fixed effects, YES, Sector fixed effects, YES, Controls, YES) keep(reform_dum1_post reform_dum1_post_DJ4g1m reform_edu_gdp_post reform_edu_gdp_post_DJ4g1m) adec(2) addstat("Mean control group", `mean_dep_var', "(SD)", `sd_dep_var') label bdec(2) se sdec(2) ctitle("Triple difference") replace


local list_reform_type health trans nrj bank
   

foreach var of local list_reform_type{

xi: reg va_perwo_ppp_trim1 reform_dum1_post reform_dum1_post_DJ4g1m reform_dum_small1_post reform_db_dum_post  reform_`var'_gdp_post reform_`var'_gdp_post_DJ4g1m i.post*DJ4g1m  i.countryname*DJ4g1m i.DJ4g1m*dtf i.DJ4g1m*foreign_aid2_percap i.sector*DJ4g1m, robust cluster(countryname)
sum va_perwo_ppp_trim1 if reform_dum1==0
local mean_dep_var=r(mean)
local sd_dep_var=r(sd)
outreg2 using "Table4.tex", tex  addtext(Country fixed effects, YES, Sector fixed effects, YES, Controls, YES) keep(reform_dum1_post reform_dum1_post_DJ4g1m reform_dum1_pre reform_dum1_pre_DJ4g1m reform_`var'_gdp_post reform_`var'_gdp_post_DJ4g1m) adec(2) addstat("Mean control group", `mean_dep_var', "(SD)", `sd_dep_var') label bdec(2) se sdec(2) ctitle("Triple difference") append


}	
	
	
*/
	
	
/*	
****Rest of table in appendix:	

xi: reg va_perwo_ppp_trim1 reform_dum1_post reform_dum1_post_DJ4g1m reform_dum_small1_post reform_db_dum_post reform_indus_gdp_post reform_indus_gdp_post_DJ4g1m i.post*DJ4g1m  i.countryname*DJ4g1m i.DJ4g1m*dtf i.DJ4g1m*foreign_aid2_percap i.sector*DJ4g1m, robust cluster(countryname)
sum va_perwo_ppp_trim1 if reform_dum1==0
local mean_dep_var=r(mean)
local sd_dep_var=r(sd)
outreg2 using "TableD2.tex", tex  addtext(Country fixed effects, YES, Sector fixed effects, YES, Controls, YES) keep(reform_dum1_post reform_dum1_post_DJ4g1m reform_indus_gdp_post reform_indus_gdp_post_DJ4g1m) adec(2) addstat("Mean control group", `mean_dep_var', "(SD)", `sd_dep_var') label bdec(2) se sdec(2) ctitle("Triple difference") replace


local list_reform_type trade debt tax confl parlia media elec corrup 
   

foreach var of local list_reform_type{

xi: reg va_perwo_ppp_trim1 reform_dum1_post reform_dum1_post_DJ4g1m reform_dum_small1_post reform_db_dum_post  reform_`var'_gdp_post reform_`var'_gdp_post_DJ4g1m i.post*DJ4g1m  i.countryname*DJ4g1m i.DJ4g1m*dtf i.DJ4g1m*foreign_aid2_percap i.sector*DJ4g1m, robust cluster(countryname)
sum va_perwo_ppp_trim1 if reform_dum1==0
local mean_dep_var=r(mean)
local sd_dep_var=r(sd)
outreg2 using "TableD2.tex", tex  addtext(Country fixed effects, YES, Sector fixed effects, YES, Controls, YES) keep(reform_dum1_post reform_dum1_post_DJ4g1m reform_dum1_pre reform_dum1_pre_DJ4g1m reform_`var'_gdp_post reform_`var'_gdp_post_DJ4g1m) adec(2) addstat("Mean control group", `mean_dep_var', "(SD)", `sd_dep_var') label bdec(2) se sdec(2) ctitle("Triple difference") append


}	

*/
	


*Other indices:

label variable reform_dum1_post_DJ4s1m  "Judicial reform * Post * Herfindhal Sweden" 
label variable reform_dum1_post_DJ4s2m  "Judicial reform * Post * Input/output Sweden" 
label variable reform_dum1_post_DJ4c1m  "Judicial reform * Post * Herfindhal Continent" 
label variable reform_dum1_post_DJ4c2m  "Judicial reform * Post * Input/output Continent" 


xi: reg va_perwo_ppp_trim1 reform_dum1_post reform_dum1_post_DJ4g1m reform_dum_small1_post reform_db_dum_post i.post*DJ4g1m  i.countryname*DJ4g1m  i.DJ4g1m*dtf i.DJ4g1m*foreign_aid2_percap i.sector*DJ4g1m, robust cluster(countryname)
sum va_perwo_ppp_trim1 if reform_dum1==0
local mean_dep_var=r(mean)
local sd_dep_var=r(sd)
outreg2 using "Table5.tex", tex  addtext(Country fixed effects, YES, Sector fixed effects, YES, Controls, YES) keep(reform_dum1_post reform_dum1_post_DJ4g1m) adec(2) addstat("Mean control group", `mean_dep_var', "(SD)", `sd_dep_var') label bdec(2) se sdec(2) ctitle("Triple difference") replace


local list_triple_diff DJ4s1m DJ4s2m
foreach var of local list_triple_diff{

xi: reg va_perwo_ppp_trim1 reform_dum1_post reform_dum1_post_`var' reform_dum_small1_post reform_db_dum_post i.post*`var'  i.countryname*`var'  i.`var'*dtf i.`var'*foreign_aid2_percap i.sector*`var', robust cluster(countryname)
sum va_perwo_ppp_trim1 if reform_dum1==0
local mean_dep_var=r(mean)
local sd_dep_var=r(sd)
outreg2 using "Table5.tex", tex  addtext(Country fixed effects, YES, Sector fixed effects, YES, Controls, YES) keep(reform_dum1_post reform_dum1_post_`var') adec(2) addstat("Mean control group", `mean_dep_var', "(SD)", `sd_dep_var') label bdec(2) se sdec(2) ctitle("`lab'") append


}


*continent: take out the comparison countries
local list_triple_diff  DJ4c1m DJ4c2m
foreach var of local list_triple_diff{

xi: reg va_perwo_ppp_trim1  reform_dum1_post reform_dum1_post_`var' reform_dum_small1_post reform_db_dum_post i.post*`var'  i.countryname*`var' i.`var'*dtf i.`var'*foreign_aid2_percap i.sector*`var' if countryname!="Malaysia"&countryname!="Thailand"&countryname!="Morocco"&countryname!="Tunisia"&countryname!="Mexico"&countryname!="Peru"&countryname!="Mauritius"&countryname!="Rwanda", robust cluster(countryname)
sum va_perwo_ppp_trim1  if reform_dum1==0
local mean_dep_var=r(mean)
local sd_dep_var=r(sd)
outreg2 using "Table5.tex", tex  addtext(Country fixed effects, YES, Sector fixed effects, YES, Controls, YES) keep(reform_dum1_post reform_dum1_post_`var') adec(2) addstat("Mean control group", `mean_dep_var', "(SD)", `sd_dep_var') label bdec(2) se sdec(2) ctitle("`lab'") append



}




****heterogeneous affects of judicial reforms:
xi: reg va_perwo_ppp_trim1 reform_dum1_post reform_dum1_post_DJ4g1m i.post*DJ4g1m reform_dum1_pre reform_dum1_pre_DJ4g1m i.pre*DJ4g1m i.countryname*DJ4g1m, robust cluster(countryname)
****F-test:
global varlist reform_dum1_post_DJ4g1m _IposXDJ4g1_1 _IcouXDJ4_* DJ4g1m
testparm $varlist
local F_test=r(F)
sum va_perwo_ppp_trim1 if reform_dum1==0
local mean_dep_var=r(mean)
local sd_dep_var=r(sd)
outreg2 using "Table E1.tex", tex addtext(Country fixed effects, YES) ///
keep(reform_dum1_post reform_dum1_post_DJ4g1m reform_dum1_pre reform_dum1_pre_DJ4g1m) ///
addstat("F-test", `F_test', "Mean control group", `mean_dep_var', "(SD)", `sd_dep_var') ///
label bdec(2) se sdec(2) ctitle("Triple difference") replace





***Heterogeneous effect by pbetaT-l:
gen sueing_condition_pos=1 if sueing_condition>=0
replace sueing_condition_pos=0 if sueing_condition<0

label define Negative_Positive 0 "Suing condition: Negative" 1 "Suing condition: Positive", modify
label values sueing_condition_pos Negative_Positive

gen reform_dum1_post_Sue=reform_dum1_post*sueing_condition_pos
gen reform_dum1_post_DJ4g1m_Sue=reform_dum1_post_DJ4g1m*sueing_condition_pos

label variable reform_dum1_post_Sue "Judicial reform * Post * Suing condition positive" 
label variable reform_dum1_post_DJ4g1m_Sue  "Judicial reform * Post * Specific * Suing condition positive" 

xi: reg va_perwo_ppp_trim1 reform_dum1_post reform_dum1_post_DJ4g1m reform_dum1_post_Sue reform_dum1_post_DJ4g1m_Sue i.post*DJ4g1m reform_dum1_pre reform_dum1_pre_DJ4g1m i.pre*DJ4g1m  i.countryname*DJ4g1m, robust cluster(countryname)
****F-test:
global varlist reform_dum1_post_DJ4g1m _IposXDJ4g1_1 _IcouXDJ4_* DJ4g1m
testparm $varlist
local F_test=r(F)
sum va_perwo_ppp_trim1 if reform_dum1==0
local mean_dep_var=r(mean)
local sd_dep_var=r(sd)
outreg2 using "Table E1.tex", tex  addtext(Country fixed effects, YES) ///
keep(reform_dum1_post reform_dum1_post_DJ4g1m reform_dum1_pre reform_dum1_pre_DJ4g1m reform_dum_small1_post reform_dum1_post_Sue reform_dum1_post_DJ4g1m_Sue reform_db_dum_post dtf foreign_aid2_percap) ///
addstat("F-test", `F_test', "Mean control group", `mean_dep_var', "(SD)", `sd_dep_var') ///
 label bdec(2) se sdec(2) ctitle("Triple difference") append

***polityIV:
gen reform_dum1_post_Po=reform_dum1_post*polity2
gen reform_dum1_post_DJ4g1m_Po=reform_dum1_post_DJ4g1m*polity2

label variable reform_dum1_post_Po "Judicial reform * Post * Polity IV" 
label variable reform_dum1_post_DJ4g1m_Po  "Judicial reform * Post * Specific * Polity IV" 

xi: reg va_perwo_ppp_trim1 reform_dum1_post reform_dum1_post_DJ4g1m reform_dum1_post_Po reform_dum1_post_DJ4g1m_Po i.post*DJ4g1m  reform_dum1_pre reform_dum1_pre_DJ4g1m i.pre*DJ4g1m i.countryname*DJ4g1m, robust cluster(countryname)
****F-test:
global varlist reform_dum1_post_DJ4g1m _IposXDJ4g1_1 _IcouXDJ4_* DJ4g1m
testparm $varlist
local F_test=r(F)
sum va_perwo_ppp_trim1 if reform_dum1==0
local mean_dep_var=r(mean)
local sd_dep_var=r(sd)
outreg2 using "Table E1.tex", tex  addtext(Country fixed effects, YES) ///
keep(reform_dum1_post reform_dum1_post_DJ4g1m reform_dum1_pre reform_dum1_pre_DJ4g1m reform_dum_small1_post reform_dum1_post_Po reform_dum1_post_DJ4g1m_Po reform_db_dum_post dtf foreign_aid2_percap) ///
addstat("F-test", `F_test', "Mean control group", `mean_dep_var', "(SD)", `sd_dep_var') ///
 label bdec(2) se sdec(2) ctitle("Triple difference") append

 
 
 
 
 
 
 
 
****other robustness checks:

*country time trends
*budget 3% 7%
*sum limited reforms
*wb_usaid


xi: reg va_perwo_ppp_trim1 reform_dum1_post reform_dum1_post_DJ4g1m reform_dum_small1_post reform_db_dum_post i.post*DJ4g1m  i.countryname*DJ4g1m  i.DJ4g1m*dtf i.DJ4g1m*foreign_aid2_percap i.sector*DJ4g1m, robust cluster(countryname)
sum va_perwo_ppp_trim1 if reform_dum1==0
local mean_dep_var=r(mean)
local sd_dep_var=r(sd)
outreg2 using "Table H1.tex", tex  addtext(Country fixed effects, YES, Sector fixed effects, YES, Controls, YES) ///
keep(reform_dum1_post reform_dum1_post_DJ4g1m) ///
adec(2) addstat("Mean control group", `mean_dep_var', "(SD)", `sd_dep_var') label bdec(2) se sdec(2) ctitle("Triple difference") replace

*Country time trends:
*Note: if I include i.countryname*i.post, then reform_dum1_post is a linear combination of some of the i.countryname*i.post
*Therefore one cannot include both reform_dum1_post and i.countryname*i.post
*I take it out of the regression:
xi: reg va_perwo_ppp_trim1 reform_dum1_post_DJ4g1m i.countryname*i.post, robust cluster(countryname)
sum va_perwo_ppp_trim1 if reform_dum1==0
local mean_dep_var=r(mean)
local sd_dep_var=r(sd)
outreg2 using "Table H1.tex", tex  addtext(Country-specific trends, YES) keep(reform_dum1_post reform_dum1_post_DJ4g1m) adec(2) addstat("Mean control group", `mean_dep_var', "(SD)", `sd_dep_var') label bdec(2) se sdec(2) ctitle("Country trends") append



****Robustness check on sum of limited reforms:

label variable reform_sum_comp_post "Sum Comprehensive Reforms * Post"
label variable reform_sum_comp_post_DJ4g1m  "Sum Comprehensive Reforms * Post * Specific"
label variable reform_sum_limited_post "Sum Limited Reforms * Post"

xi: reg va_perwo_ppp_trim1 reform_sum_comp_post reform_sum_comp_post_DJ4g1m reform_sum_limited_post reform_db_dum_post i.post*DJ4g1m  i.countryname*DJ4g1m i.sector*DJ4g1m i.DJ4g1m*dtf i.DJ4g1m*foreign_aid2_percap , robust cluster(countryname)
sum va_perwo_ppp_trim1 if reform_dum1==0
local mean_dep_var=r(mean)
local sd_dep_var=r(sd)
outreg2 using "Table H1.tex", tex  addtext(Country fixed effects, YES, Sector fixed effects, YES, Controls, YES) keep(reform_sum_comp_post reform_sum_comp_post_DJ4g1m reform_sum_limited_post) adec(2) addstat("Mean control group", `mean_dep_var', "(SD)", `sd_dep_var') label bdec(2) se sdec(2) ctitle("Triple difference") append



xi: reg va_perwo_ppp_trim1 reform_dum2_post reform_dum2_post_DJ4g1m reform_dum_small2_post reform_db_dum_post i.post*DJ4g1m  i.countryname*DJ4g1m  i.DJ4g1m*dtf i.DJ4g1m*foreign_aid2_percap i.sector*DJ4g1m, robust cluster(countryname)
sum va_perwo_ppp_trim1 if reform_dum1==0
local mean_dep_var=r(mean)
local sd_dep_var=r(sd)
outreg2 using "Table H1.tex", tex  addtext(Country fixed effects, YES, Sector fixed effects, YES, Controls, YES) ///
keep(reform_dum2_post reform_dum2_post_DJ4g1m) ///
adec(2) addstat("Mean control group", `mean_dep_var', "(SD)", `sd_dep_var') label bdec(2) se sdec(2) ctitle("3%") append

xi: reg va_perwo_ppp_trim1 reform_dum3_post reform_dum3_post_DJ4g1m reform_dum_small3_post reform_db_dum_post i.post*DJ4g1m  i.countryname*DJ4g1m  i.DJ4g1m*dtf i.DJ4g1m*foreign_aid2_percap i.sector*DJ4g1m, robust cluster(countryname)
sum va_perwo_ppp_trim1 if reform_dum1==0
local mean_dep_var=r(mean)
local sd_dep_var=r(sd)
outreg2 using "Table H1.tex", tex  addtext(Country fixed effects, YES, Sector fixed effects, YES, Controls, YES) ///
keep(reform_dum3_post reform_dum3_post_DJ4g1m) ///
adec(2) addstat("Mean control group", `mean_dep_var', "(SD)", `sd_dep_var') label bdec(2) se sdec(2) ctitle("7%") append


xi: reg va_perwo_ppp_trim1 reform_dum4_post reform_dum4_post_DJ4g1m reform_dum_small4_post reform_db_dum_post i.post*DJ4g1m  i.countryname*DJ4g1m  i.DJ4g1m*dtf i.DJ4g1m*foreign_aid2_percap i.sector*DJ4g1m, robust cluster(countryname)
sum va_perwo_ppp_trim1 if reform_dum1==0
local mean_dep_var=r(mean)
local sd_dep_var=r(sd)
outreg2 using "Table H1.tex", tex  addtext(Country fixed effects, YES, Sector fixed effects, YES, Controls, YES) ///
keep(reform_dum4_post reform_dum4_post_DJ4g1m) ///
sortvar(reform_dum1_post reform_dum1_post_DJ4g1m reform_sum_comp_post reform_sum_comp_post_DJ4g1m reform_sum_limited_post reform_dum2_post reform_dum2_post_DJ4g1m reform_dum3_post reform_dum3_post_DJ4g1m reform_dum4_post reform_dum4_post_DJ4g1m) ///
adec(2) addstat("Mean control group", `mean_dep_var', "(SD)", `sd_dep_var') label bdec(2) se sdec(2) ctitle("1%") append








****Table coding:


xi: reg va_perwo_ppp_trim1 reform_dum1_post reform_dum1_post_DJ4g1m reform_dum_small1_post reform_db_dum_post i.post*DJ4g1m  i.countryname*DJ4g1m  i.DJ4g1m*dtf i.DJ4g1m*foreign_aid2_percap i.sector*DJ4g1m, robust cluster(countryname)
sum va_perwo_ppp_trim1 if reform_dum1==0
local mean_dep_var=r(mean)
local sd_dep_var=r(sd)
outreg2 using "Table C1.tex", tex  addtext(Country fixed effects, YES, Sector fixed effects, YES, Controls, YES) keep(reform_dum1_post reform_dum1_post_DJ4g1m) adec(2) addstat("Mean control group", `mean_dep_var', "(SD)", `sd_dep_var') label bdec(2) se sdec(2) ctitle("Triple difference") replace


*Triple diff without Malawi and Rwanda:
replace reform_dum1_post=0 if countryname=="Malawi"
replace reform_dum1_post_DJ4g1m=0 if countryname=="Malawi"
replace reform_dum_small1_post=1 if countryname=="Malawi"

replace reform_dum1_post=0 if countryname=="Rwanda"
replace reform_dum1_post_DJ4g1m=0 if countryname=="Rwanda"
replace reform_dum_small1_post=1 if countryname=="Rwanda"

xi: reg va_perwo_ppp_trim1 reform_dum1_post reform_dum1_post_DJ4g1m reform_dum_small1_post reform_db_dum_post i.post*DJ4g1m  i.countryname*DJ4g1m i.DJ4g1m*dtf i.DJ4g1m*foreign_aid2_percap i.sector*DJ4g1m, robust cluster(countryname)
sum va_perwo_ppp_trim1 if reform_dum1==0
local mean_dep_var=r(mean)
local sd_dep_var=r(sd)
outreg2 using "Table C1.tex", tex  addtext(Country fixed effects, YES, Sector fixed effects, YES, Controls, YES) keep(reform_dum1_post reform_dum1_post_DJ4g1m) adec(2) addstat("Mean control group", `mean_dep_var', "(SD)", `sd_dep_var') label bdec(2) se sdec(2) ctitle("Without Malawi Rwanda") append







clear
use "Enterprise surveys_judicial_reforms_standardized dataset.dta"

sum DJ4g1m
centile(DJ4g1m), centile(50)
display `r(c_1)'
*hist DJ4g1, percent

label variable h7a "Judicial efficiency"
label variable reform_dum1_post "Judicial reform * Post" 
label variable reform_dum1_post_DJ4g1m  "Judicial reform * Post * Specific" 


label variable reform_dum_small1_post "Limited judicial reform * Post" 
label variable reform_db_dum_post "Domestic judicial reform * Post" 

label variable dtf "Business climate"
replace foreign_aid2_percap=foreign_aid2_percap*1000000
label variable  foreign_aid2_percap "Foreign aid per capita"


replace va_perwo_ppp_trim1=va_perwo_ppp_trim1/1000
label variable va_perwo_ppp_trim1 "Value added per worker (Thousand dollars)"
local lab : var label va_perwo_ppp_trim1




***robustness check in appendix:

label variable reform_dum1_post_CI "Judicial reform * Post * Contract Intensive" 
label variable reform_dum1_post_DJ4g1  "Judicial reform * Post * Specific (continuous)" 
label variable reform_dum1_post_DJ4s1  "Judicial reform * Post * Herfindhal Sweden (continuous)" 
label variable reform_dum1_post_DJ4s2  "Judicial reform * Post * Input/output Sweden (continuous)" 
label variable reform_dum1_post_DJ4c1  "Judicial reform * Post * Herfindhal Continent (continuous)" 
label variable reform_dum1_post_DJ4c2  "Judicial reform * Post * Input/output Continent (continuous)" 



xi: reg va_perwo_ppp_trim1 reform_dum1_post reform_dum1_post_CI reform_dum_small1_post reform_db_dum_post i.post*CI i.countryname*CI  dtf foreign_aid2_percap i.sector*CI , robust cluster(countryname)
sum va_perwo_ppp_trim1 if reform_dum1==0
local mean_dep_var=r(mean)
local sd_dep_var=r(sd)
outreg2 using "Table G1.tex", tex  addtext(Country fixed effects, YES, Sector fixed effects, YES, Controls, YES) keep(reform_dum1_post reform_dum1_post_CI ) adec(2) addstat("Mean control group", `mean_dep_var', "(SD)", `sd_dep_var') label bdec(2) se sdec(2) ctitle("`lab'") replace



local list_triple_diff DJ4g1 DJ4s1 DJ4s2 DJ4c1 DJ4c2
foreach var of local list_triple_diff{


xi: reg va_perwo_ppp_trim1 reform_dum1_post reform_dum1_post_`var' reform_dum_small1_post reform_db_dum_post i.post*`var'  i.countryname*`var' dtf foreign_aid2_percap i.sector*`var', robust cluster(countryname)
sum va_perwo_ppp_trim1 if reform_dum1==0
local mean_dep_var=r(mean)
local sd_dep_var=r(sd)
outreg2 using "Table G1.tex", tex  addtext(Country fixed effects, YES, Sector fixed effects, YES, Controls, YES) keep(reform_dum1_post reform_dum1_post_`var') adec(2) addstat("Mean control group", `mean_dep_var', "(SD)", `sd_dep_var') label bdec(2) se sdec(2) ctitle("`lab'") append




}

exit



