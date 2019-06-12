* adjust path
cd
cd "Dropbox/StateHydrocarbonRents/StateHydrocarbonRents_Data/Publication"

set more off
capture log close
graph drop _all
log using StateHydrocarbonRents.log, replace

************************************************************************************************************************************************
* Lucas V & Richter T (2016): State Hydrocarbon Rents, Authoritarian Survival and the Onset of Democracy: Evidence from a New Dataset *
* last update: 2016-06-14 **********************************************************************************************************************
************************************************************************************************************************************************


use StateHydrocarbonRents.dta, clear

merge 1:1 cowcode year using Wrightetal_Data.dta
drop _merge
order cowcode cowcode2 year country geddes_country cg_country ross_country pol4_country mad_country, first

sort cowcode year
tsset cowcode year

* rename variable names
rename R_roilgas_GDPGSRE_Mpc R_rog_GDPGSRE_Mpc
rename m_totexpenditures_GDPGSRE_Mpc m_texpendit_GDPGSRE_Mpc
rename m_exp_public_order_GDPGSRE_Mpc m_exp_porder_GDPGSRE_Mpc
rename m_wagessalaries_GDPGSRE_Mpc m_wages_GDPGSRE_Mpc
rename m_expend_security_GDPGSRE_Mpc m_security_GDPGSRE_Mpc
rename m_total_welfare_GDPGSRE_Mpc m_twelfare_GDPGSRE_Mpc
rename m_other_income_tax_GDPGSRE_Mpc m_oincome_tax_GDPGSRE_Mpc
rename m_t_goods_services_GDPGSRE_Mpc m_t_goservic_GDPGSRE_Mpc

* generate taxation revenues without hydrocarbon rents
* total tax revenues
gen m_total_tax_nor_GDPGSRE_Mpc = m_tax_revenues_GDPGSRE_Mpc - m_corptaxprimcom_GDPGSRE_Mpc
replace m_total_tax_nor_GDPGSRE_Mpc = m_tax_revenues_GDPGSRE_Mpc if m_total_tax_nor_GDPGSRE_Mpc==.
label var m_total_tax_nor_GDPGSRE_Mpc "Total tax revenues (GSRE) without hydrocarbon rents"
* direct tax revenues
gen m_dtax_nor1_GDPGSRE_Mpc = m_income_tax_GDPGSRE_Mpc + m_othercorptax_GDPGSRE_Mpc
sum m_dtax_nor1_GDPGSRE_Mpc m_intax_rents_GDPGSRE_Mpc m_othercorptax_GDPGSRE_Mpc
replace m_dtax_nor1_GDPGSRE_Mpc = m_income_tax_GDPGSRE_Mpc if m_dtax_nor1_GDPGSRE_Mpc==.
replace m_dtax_nor1_GDPGSRE_Mpc = m_othercorptax_GDPGSRE_Mpc if m_dtax_nor1_GDPGSRE_Mpc==.
label var m_dtax_nor1_GDPGSRE_Mpc "Direct tax revenues (GSRE) without hydrocarbon rents"

* add 0-values of hydrocarbon rents using the Haber & Menaldo data
gen R_rog_0 = R_roilgas
* drop if using StateHydrocarbonRents.dta
recode R_rog_0 (mis=0) if R_totaloilincomepc_HM==0 & R_naturalgasincomepc_HM==0
gen R_rog_0_GDPGSRE_Mpc = R_rog_GDPGSRE_Mpc
* drop if using StateHydrocarbonRents.dta
recode R_rog_0_GDPGSRE_Mpc (mis=0) if R_totaloilincomepc_HM==0 & R_naturalgasincomepc_HM==0 & year>1945
label var R_rog_0_GDPGSRE_Mpc "State revenues from producing oil and gas (GSRE) with 0 from H&M"

sum R_rog_GDPGSRE_Mpc R_rog_0_GDPGSRE_Mpc total_oil_income_pc
sum R_rog_GDPGSRE_Mpc if R_rog_GDPGSRE_Mpc>0

* generate natural logs
foreach variable of varlist m_* e_* R_*Mpc R_*HM {
		gen `variable'_ln = ln(1+l.`variable')
	}	

* Generate mean values over autocratic spells
by cowcode: egen R_rog_GDPGSRE_Mpc_lnm_a = mean(R_rog_GDPGSRE_Mpc_ln) if INST_autocracy_GWF==1
by cowcode: gen R_rog_GDPGSRE_Mpc_lnmdev_a = R_rog_GDPGSRE_Mpc_ln - R_rog_GDPGSRE_Mpc_lnm_a if INST_autocracy_GWF==1
label var R_rog_GDPGSRE_Mpc_lnm_a "Country Mean (a) State Hydrocarbon Rents USD pc ln (GSRE)"
label var R_rog_GDPGSRE_Mpc_lnmdev_a "Deviation from Country Mean (a) State Hydrocarbon Rents USD pc ln (GSRE)"

by cowcode: egen R_rog_0_GDPGSRE_Mpc_lnm_a = mean(R_rog_0_GDPGSRE_Mpc_ln) if INST_autocracy_GWF==1
recode R_rog_0_GDPGSRE_Mpc_lnm_a (nonmis=.) if R_rog_0_GDPGSRE_Mpc_ln==.
by cowcode: gen R_rog_0_GDPGSRE_Mpc_lnmdev_a = R_rog_0_GDPGSRE_Mpc_ln - R_rog_0_GDPGSRE_Mpc_lnm_a if INST_autocracy_GWF==1
label var R_rog_0_GDPGSRE_Mpc_lnm_a "Country Mean State Hydrocarbon Rents USD pc ln (GSRE plus 0 HM)"
label var R_rog_0_GDPGSRE_Mpc_lnmdev_a "Deviation from Country Mean State Hydrocarbon Rents USD pc ln (GSRE plus 0 HM)"

by cowcode: egen R_oilgasincomepc_HM_lnm_a = mean(R_oilgasincomepc_HM_ln) if INST_autocracy_GWF==1
by cowcode: gen R_oilgasincomepc_HM_lnmdev_a = R_oilgasincomepc_HM_ln - R_oilgasincomepc_HM_lnm_a if INST_autocracy_GWF==1
label var R_oilgasincomepc_HM_lnm_a "Country Mean Oil & Gas Income USD pc ln (HM)"
label var R_oilgasincomepc_HM_lnmdev_a "Deviation from Country Mean Oil & Gas Income USD pc ln (HM)"

* Generate military expenditures from COW data used by Wright et al.
gen milx = ln(1+(nmc_milex/gdpdeflator))
gen milx_pc = ln(1+(((nmc_milex*1000)/gdpdeflator)/population))
label var milx_pc "Military Spending USD pc ln (COW)"
pwcorr m_security_GDPGSRE_Mpc_ln milx milx_pc, obs

* label variables
label var m_total_tax_nor_GDPGSRE_Mpc_ln "Total Tax Revenues without Hydrocarbon Rents USD pc ln (GSRE)"
label var R_rog_0_GDPGSRE_Mpc_ln "State Hydrocarbon Rents USD pc ln (GSRE) with 0 from H&M"
label var e_GDP_pc_Maddison_ln "GDP USD pc ln (Maddison)"
label var m_dtax_nor1_GDPGSRE_Mpc_ln "Direct Tax Revenues without Hydrocarbon Rents USD pc ln (GSRE)"
label var m_indirect_taxes_GDPGSRE_Mpc_ln "Indirect Tax Revenues USD pc ln (GSRE)"
label var m_income_tax_GDPGSRE_Mpc_ln "Income Tax Revenues USD pc ln (GSRE)"
label var m_othercorptax_GDPGSRE_Mpc_ln "Corporate Tax Revenues without Hydrocarbon Rents USD pc ln (GSRE)"
label var m_texpendit_GDPGSRE_Mpc_ln "Total Expenditures USD pc ln (GSRE)"
label var m_security_GDPGSRE_Mpc_ln "Expenditures for Security USD pc ln (GSRE)"
label var m_wages_GDPGSRE_Mpc_ln "Expenditures for Public Wages USD pc ln (GSRE)"
label var m_twelfare_GDPGSRE_Mpc_ln "Total Expenditures for Social Welfare USD pc ln (GSRE)"
label var ged_time "Time since Last Breakdown (GWF)"
label var ged_time2 "Time since Last Breakdown Squared (GWF)"
label var ged_time3 "Time since Last Breakdown Cubic (GWF)"
label var mean_gdp "Country Mean GDP pc ln (Maddison)"
label var dev_gdp "Deviation from Country Mean GDP pc ln (Maddison)"
label var civilwar "Civil War (UCDP/PRIO)"
label var nbr_dem "Neighboring Democratic Transition"
label var mean_hmoil "Country Mean Oil Income pc ln (HM)"
label var dev_hmoil "Deviation from Country Mean Oil Income pc ln (HM)"
label var ged_fail "Regime Breakdown"
label var mean_fail "Country Mean Regime Breakdown"
label var ged_dict "Authoritarian Transition"
label var mean_dict "Country Mean Authoritarian Transition"
label var ged_dem "Democratic Transition"
label var mean_dem "Country Mean Democratic Transition"
label var time "General Annual Time Trend"
label var time2 "General Annual Time Trend Squared"
label var time3 "General Annual Time Trend Cubic"

save temp.dta, replace


***********
* Table 1 *
***********
use temp.dta, clear
* Haber & Menaldo without zeros
* time coverage
sum year if total_oil_income_pc!=. & total_oil_income_pc>0
display r(min)
display r(max)
* number of years
tab year if total_oil_income_pc!=. & total_oil_income_pc>0, nofreq
return list
display r(r)
* number of countries 
tab cowcode if total_oil_income_pc!=. & total_oil_income_pc>0, nofreq
return list
display r(r)
* GSRE 1.0 without zeros
* time coverage
sum year if R_rog_GDPGSRE_Mpc!=. & R_rog_GDPGSRE_Mpc>0
display r(min)
display r(max)
* number of years
tab year if R_rog_GDPGSRE_Mpc!=. & R_rog_GDPGSRE_Mpc>0, nofreq
return list
display r(r)
* number of countries 
tab cowcode if R_rog_GDPGSRE_Mpc!=. & R_rog_GDPGSRE_Mpc>0, nofreq
return list
display r(r)
* correlation
pwcorr total_oil_income_pc R_rog_GDPGSRE_Mpc if total_oil_income_pc!=. & total_oil_income_pc>0 & R_rog_GDPGSRE_Mpc!=. & R_rog_GDPGSRE_Mpc>0, obs

* Haber & Menaldo with zeros
* time coverage
sum year if total_oil_income_pc!=.
display r(min)
display r(max)
* number of years
tab year if total_oil_income_pc!=., nofreq
return list
display r(r)
* number of countries 
tab cowcode if total_oil_income_pc!=., nofreq
return list
display r(r)
* GSRE 1.0 with zeros
* time coverage
sum year if R_rog_0_GDPGSRE_Mpc!=. 
display r(min)
display r(max)
* number of years
tab year if R_rog_0_GDPGSRE_Mpc!=. , nofreq
return list
display r(r)
* number of countries 
tab cowcode if R_rog_0_GDPGSRE_Mpc!=. , nofreq
return list
display r(r)
* correlation
pwcorr total_oil_income_pc R_rog_0_GDPGSRE_Mpc if total_oil_income_pc!=. & R_rog_0_GDPGSRE_Mpc!=., obs

* GFS 2012
* time coverage
sum year if id_GFS2012!=. & m_GFS12_CG_11_GDPGSRE_Mpc!=.
display r(min)
display r(max)
* number of years
tab year if id_GFS2012!=. & m_GFS12_CG_11_GDPGSRE_Mpc!=., nofreq
return list
display r(r)
* number of countries 
tab cowcode if id_GFS2012!=. & m_GFS12_CG_11_GDPGSRE_Mpc!=., nofreq
return list
display r(r)

* GSRE 1.0
* time coverage
sum year if id_GSRE!=. & m_tax_revenues_GDPGSRE_Mpc!=.
display r(min)
display r(max)
* number of years
tab year if id_GSRE!=. & m_tax_revenues_GDPGSRE_Mpc!=., nofreq
return list
display r(r)
* number of countries
tab cowcode if id_GSRE!=. & m_tax_revenues_GDPGSRE_Mpc!=., nofreq
return list
display r(r)
pwcorr  m_GFS12_CG_11_GDPGSRE_Mpc m_tax_revenues_GDPGSRE_Mpc, obs


***********
* Table 2 *
***********

use temp, clear
eststo clear
eststo: logit ged_fail  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem mean_hmoil dev_hmoil mean_fail, cluster(cowcode)
lroc,  nograph
tab ged_fail if e(sample)
* share of 0s
tab mean_hmoil if e(sample)
tab dev_hmoil if e(sample)

eststo: logit ged_fail  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem R_rog_0_GDPGSRE_Mpc_lnm_a R_rog_0_GDPGSRE_Mpc_lnmdev_a mean_fail if e(sample), cluster(cowcode)
lroc,  nograph
tab ged_fail if e(sample)
* share of 0s
tab R_rog_0_GDPGSRE_Mpc_lnm_a if e(sample)
tab R_rog_0_GDPGSRE_Mpc_lnmdev_a if e(sample)

eststo: logit ged_fail  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem mean_hmoil dev_hmoil mean_fail if e(sample), cluster(cowcode)
lroc,  nograph
tab ged_fail if e(sample)

use temp, clear
eststo: logit ged_dict  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem mean_hmoil dev_hmoil mean_dict, cluster(cowcode)
lroc,  nograph
tab ged_dict if e(sample)
eststo: logit ged_dict  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem R_rog_0_GDPGSRE_Mpc_lnm_a R_rog_0_GDPGSRE_Mpc_lnmdev_a mean_dict if e(sample), cluster(cowcode)
lroc,  nograph
tab ged_dict if e(sample)
eststo: logit ged_dict  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem mean_hmoil dev_hmoil mean_dict if e(sample), cluster(cowcode)
lroc,  nograph
tab ged_dict if e(sample)

use temp, clear
eststo: logit ged_dem  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem mean_hmoil dev_hmoil mean_dem, cluster(cowcode)
lroc,  nograph
tab ged_dem if e(sample)
eststo: logit ged_dem  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem R_rog_0_GDPGSRE_Mpc_lnm_a R_rog_0_GDPGSRE_Mpc_lnmdev_a mean_dem if e(sample), cluster(cowcode)
lroc,  nograph
tab ged_dem if e(sample)
eststo: logit ged_dem  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem mean_hmoil dev_hmoil mean_dem if e(sample), cluster(cowcode)
lroc,  nograph
tab ged_dem if e(sample)

# delimit ;
esttab using Table2.csv, label replace star (+ 0.10 * 0.05 ** 0.01) 
nonumbers compress p ar2 pr2 scalars ("ll Log Likelihood" "chi2 Chi-Square" "N_clust No of Countries") lines nogaps obslast mtitles(
"(1) All Regime Failures" "(2) All Regime Failures" "(3) All Regime Failures"
"(4) Authoritarian Transitions" "(5) Authoritarian Transitions" "(6) Authoritarian Transitions"
"(7) Democratic Transitions" "(8) Democratic Transitions" "(9) Democratic Transitions");
# delimit cr


*************
** Table 3 **
*************
use temp.dta, clear
eststo clear
eststo: xi: regress D.m_total_tax_nor_GDPGSRE_Mpc_ln L.m_total_tax_nor_GDPGSRE_Mpc_ln D.R_rog_0_GDPGSRE_Mpc_ln L.R_rog_0_GDPGSRE_Mpc_ln D.p_both_UCDPPRIO L.p_both_UCDPPRIO D.p_iwar1st_UCDPPRIO L.p_iwar1st_UCDPPRIO d.INST1_demtrans4k_gwf_cat L.INST1_demtrans4k_gwf_cat d.e_GDP_pc_Maddison_ln L.e_GDP_pc_Maddison_ln d.INST_regimeyears_GWF L.INST_regimeyears_GWF  i.cowcode*time i.cowcode*time2  if INST_autocracy_GWF==1, cluster(cowcode)
eststo: xi: regress D.m_dtax_nor1_GDPGSRE_Mpc_ln L.m_dtax_nor1_GDPGSRE_Mpc_ln D.R_rog_0_GDPGSRE_Mpc_ln L.R_rog_0_GDPGSRE_Mpc_ln D.p_both_UCDPPRIO L.p_both_UCDPPRIO D.p_iwar1st_UCDPPRIO L.p_iwar1st_UCDPPRIO d.INST1_demtrans4k_gwf_cat L.INST1_demtrans4k_gwf_cat d.e_GDP_pc_Maddison_ln L.e_GDP_pc_Maddison_ln d.INST_regimeyears_GWF L.INST_regimeyears_GWF  i.cowcode*time i.cowcode*time2 if INST_autocracy_GWF==1, cluster(cowcode)
sum R_rog_0_GDPGSRE_Mpc_ln if e(sample) /*one standard deviation is 2.452412*/
	lincom D.R_rog_0_GDPGSRE_Mpc_ln*2.452412 /*-11.89%*/
	
eststo: xi: regress d.m_indirect_taxes_GDPGSRE_Mpc_ln L.m_indirect_taxes_GDPGSRE_Mpc_ln D.R_rog_0_GDPGSRE_Mpc_ln L.R_rog_0_GDPGSRE_Mpc_ln D.p_both_UCDPPRIO L.p_both_UCDPPRIO D.p_iwar1st_UCDPPRIO L.p_iwar1st_UCDPPRIO d.INST1_demtrans4k_gwf_cat L.INST1_demtrans4k_gwf_cat d.e_GDP_pc_Maddison_ln L.e_GDP_pc_Maddison_ln d.INST_regimeyears_GWF L.INST_regimeyears_GWF i.cowcode*time i.cowcode*time2 if INST_autocracy_GWF==1, cluster(cowcode)
eststo: xi: regress D.m_income_tax_GDPGSRE_Mpc_ln L.m_income_tax_GDPGSRE_Mpc_ln D.R_rog_0_GDPGSRE_Mpc_ln L.R_rog_0_GDPGSRE_Mpc_ln D.p_both_UCDPPRIO L.p_both_UCDPPRIO D.p_iwar1st_UCDPPRIO L.p_iwar1st_UCDPPRIO d.INST1_demtrans4k_gwf_cat L.INST1_demtrans4k_gwf_cat d.e_GDP_pc_Maddison_ln L.e_GDP_pc_Maddison_ln d.INST_regimeyears_GWF L.INST_regimeyears_GWF  i.cowcode*time i.cowcode*time2 if INST_autocracy_GWF==1, cluster(cowcode)
sum R_rog_0_GDPGSRE_Mpc_ln if e(sample	) /*one standard deviation is  2.335186*/
	lincom D.R_rog_0_GDPGSRE_Mpc_ln*2.335186 /*-9.35%*/
	
eststo: xi: regress d.m_othercorptax_GDPGSRE_Mpc_ln L.m_othercorptax_GDPGSRE_Mpc_ln D.R_rog_0_GDPGSRE_Mpc_ln L.R_rog_0_GDPGSRE_Mpc_ln D.p_both_UCDPPRIO L.p_both_UCDPPRIO D.p_iwar1st_UCDPPRIO L.p_iwar1st_UCDPPRIO d.INST1_demtrans4k_gwf_cat L.INST1_demtrans4k_gwf_cat d.e_GDP_pc_Maddison_ln L.e_GDP_pc_Maddison_ln d.INST_regimeyears_GWF L.INST_regimeyears_GWF  i.cowcode*time i.cowcode*time2 if INST_autocracy_GWF==1, cluster(cowcode)
sum R_rog_0_GDPGSRE_Mpc_ln if e(sample) /*one standard deviation is 2.380009*/
	lincom L.R_rog_0_GDPGSRE_Mpc_ln*2.380009 /*-18.26%*/
	lincom D.R_rog_0_GDPGSRE_Mpc_ln*2.380009 /*-14.15%*/
	
eststo: xi: regress D.m_texpendit_GDPGSRE_Mpc_ln L.m_texpendit_GDPGSRE_Mpc_ln D.R_rog_0_GDPGSRE_Mpc_ln L.R_rog_0_GDPGSRE_Mpc_ln D.p_both_UCDPPRIO L.p_both_UCDPPRIO D.p_iwar1st_UCDPPRIO L.p_iwar1st_UCDPPRIO d.INST1_demtrans4k_gwf_cat L.INST1_demtrans4k_gwf_cat d.e_GDP_pc_Maddison_ln L.e_GDP_pc_Maddison_ln d.INST_regimeyears_GWF L.INST_regimeyears_GWF  i.cowcode*time i.cowcode*time2  if INST_autocracy_GWF==1, cluster(cowcode)
eststo: xi: regress D.m_security_GDPGSRE_Mpc_ln L.m_security_GDPGSRE_Mpc_ln D.R_rog_0_GDPGSRE_Mpc_ln L.R_rog_0_GDPGSRE_Mpc_ln D.p_both_UCDPPRIO L.p_both_UCDPPRIO D.p_iwar1st_UCDPPRIO L.p_iwar1st_UCDPPRIO d.INST1_demtrans4k_gwf_cat L.INST1_demtrans4k_gwf_cat d.e_GDP_pc_Maddison_ln L.e_GDP_pc_Maddison_ln d.INST_regimeyears_GWF L.INST_regimeyears_GWF  i.cowcode*time i.cowcode*time2 if INST_autocracy_GWF==1, cluster(cowcode)
eststo: xi: regress D.m_wages_GDPGSRE_Mpc_ln L.m_wages_GDPGSRE_Mpc_ln D.R_rog_0_GDPGSRE_Mpc_ln L.R_rog_0_GDPGSRE_Mpc_ln D.p_both_UCDPPRIO L.p_both_UCDPPRIO D.p_iwar1st_UCDPPRIO L.p_iwar1st_UCDPPRIO d.INST1_demtrans4k_gwf_cat L.INST1_demtrans4k_gwf_cat d.e_GDP_pc_Maddison_ln L.e_GDP_pc_Maddison_ln d.INST_regimeyears_GWF L.INST_regimeyears_GWF  i.cowcode*time i.cowcode*time2 if INST_autocracy_GWF==1, cluster(cowcode)
eststo: xi: regress D.m_twelfare_GDPGSRE_Mpc_ln L.m_twelfare_GDPGSRE_Mpc_ln D.R_rog_0_GDPGSRE_Mpc_ln L.R_rog_0_GDPGSRE_Mpc_ln D.p_both_UCDPPRIO L.p_both_UCDPPRIO D.p_iwar1st_UCDPPRIO L.p_iwar1st_UCDPPRIO d.INST1_demtrans4k_gwf_cat L.INST1_demtrans4k_gwf_cat d.e_GDP_pc_Maddison_ln L.e_GDP_pc_Maddison_ln d.INST_regimeyears_GWF L.INST_regimeyears_GWF  i.cowcode*time i.cowcode*time2 if INST_autocracy_GWF==1, cluster(cowcode)
# delimit ;
esttab using Table3.csv, b(3) p(3) label replace star (+ 0.10 * 0.05 ** 0.01) 
nonumbers compress scalars ("r2 R2" "N_clust No of Countries") lines nogaps obslast mtitles(
"(1) Total Taxes" "(2) Total Direct Taxes" "(3) Total Indirect Taxes" "(4) Total Income Taxes" "(5) Total Corporate Taxes" "(6) Total Expenditures" "(7) Total Security" "(8) Total Mil COW" "(9) Total Security" "(10) Total Mil COW" "(11) Total Wages" "(12) Total Welfare");
# delimit cr



**************
* Appendix A *
**************

* Figure A-1: Comparison between Oil Income (HM) and Hydrocarbon Rents (GSRE 1.0) without zero-values
use temp.dta, clear
gen total_oil_income_no0 = total_oil_income_pc
recode total_oil_income_no0 (0=.)
gen R_rog_GDPGSRE_Mpc_no0 = R_rog_GDPGSRE_Mpc
recode R_rog_GDPGSRE_Mpc_no0 (0=.)
sum total_oil_income_no0 R_rog_GDPGSRE_Mpc_no0

foreach var of varlist total_oil_income_no0 R_rog_GDPGSRE_Mpc_no0 {
cap drop obs_y_`var'
gen obs_y_`var'=.
foreach year of numlist 1946/2011{
qui sum `var' if year==`year'
replace obs_y_`var'=r(N) if year==`year'
label variable obs_y_`var' "Observations of `var'"
}
}

label variable obs_y_total_oil_income_no0 "Observations of Total Oil Income (HM)"
label variable obs_y_R_rog_GDPGSRE_Mpc_no0 "Observations of Total Hydrocarbon Rents (GSRE 1.0)" 
local obs1="Rents without Zeros"
local GSREobs1="obs_y_total_oil_income_no0"
local GFSobs1="obs_y_R_rog_GDPGSRE_Mpc_no0"

#delimit;
graph twoway
bar `GSREobs1' year,
	color(gs10)
	xscale(range(1945(10)2006)) xlabel(1945(10)2006)
	yscale(range(0(20)100)) ylabel(0(20)100)||
bar `GFSobs1' year,
	lcolor(gs0) lwidth(thin) fcolor(none)
	title("Coverage of `obs1'")
	ytitle("No. of Observations")
	xtitle("Year")
	legend(pos(7) cols(1) region(color(none)))
	name(bar_`GSREobs1')
	;
#delimit cr
graph export AppendixA_FigureA-1_Oil_Hydrocarbon_without0.pdf, as(pdf) replace


* Figure A-2: Comparison between Oil Income (HM) and Hydrocarbon Rents (GSRE 1.0) with zero-values
use temp.dta, clear
foreach var of varlist total_oil_income_pc R_rog_0_GDPGSRE_Mpc {
cap drop obs_y_`var'
gen obs_y_`var'=.
foreach year of numlist 1946/2011{
qui sum `var' if year==`year'
replace obs_y_`var'=r(N) if year==`year'
label variable obs_y_`var' "Observations of `var'"
}
}

label variable obs_y_total_oil_income_pc "Observations of Total Oil Income (HM)"
label variable obs_y_R_rog_0_GDPGSRE_Mpc "Observations of Total Hydrocarbon Rents (GSRE 1.0)" 
local obs1="Rents with Zeros"
local GSREobs1="obs_y_total_oil_income_pc"
local GFSobs1="obs_y_R_rog_0_GDPGSRE_Mpc"

#delimit;
graph twoway
bar `GSREobs1' year,
	color(gs10)
	xscale(range(1945(10)2006)) xlabel(1945(10)2006)
	yscale(range(0(20)100)) ylabel(0(20)100)||
bar `GFSobs1' year,
	lcolor(gs0) lwidth(thin) fcolor(none)
	title("Coverage of `obs1'")
	ytitle("No. of Observations")
	xtitle("Year")
	legend(pos(7) cols(1) region(color(none)))
	name(bar_`GSREobs1')
	;
#delimit cr
graph export AppendixA_FigureA-2_Oil_Hydrocarbon_with0.pdf, as(pdf) replace


* Figure A-3: Comparison between Total Tax Revenues from GFS and GSRE 1.0
use temp.dta, clear
foreach var of varlist total_tax_revenues GFS12_CG_11 {
cap drop obs_y_`var'
gen obs_y_`var'=.
foreach year of numlist 1946/2011{
qui sum `var' if year==`year'
replace obs_y_`var'=r(N) if year==`year'
label variable obs_y_`var' "Observations of `var'"
}
}

label variable obs_y_total_tax_revenues "Observations of Total Tax Revenues (GSRE 1.0)"
label variable obs_y_GFS12_CG_11 "Observations of Total Tax Revenues (GFS 2012)" 
local obs1="Total Tax Revenues"
local GSREobs1="obs_y_GFS12_CG_11"
local GFSobs1="obs_y_total_tax"

#delimit;
graph twoway
bar `GSREobs1' year,
	color(gs10)
	xscale(range(1945(10)2015)) xlabel(1945(10)2015)
	yscale(range(0(20)160)) ylabel(0(20)160)||
bar `GFSobs1' year,
	lcolor(gs0) lwidth(thin) fcolor(none)
	title("Coverage of `obs1'")
	ytitle("No. of Observations")
	xtitle("Year")
	legend(pos(7) cols(1) region(color(none)))
	name(bar_`GSREobs1')
	;
#delimit cr
graph export AppendixA_FigureA-3_TotalTaxRevenues.pdf, as(pdf) replace


**************
* Appendix B *
**************

* Table B-1: Summary Statistics for Specifications 1, 4, and 7 in Table 2

use temp.dta, clear
quietly: logit ged_fail ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem mean_hmoil dev_hmoil mean_fail, cluster(cowcode)
fsum ged_fail mean_fail ged_dict mean_dict ged_dem mean_dem mean_hmoil dev_hmoil mean_gdp dev_gdp civilwar nbr_dem ged_time* time time2 time3 if e(sample), uselabel

* Table B-2: Summary Statistics for Specifications 2, 5 and 8 in Table 2

use temp.dta, clear
quietly: logit ged_fail ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem mean_hmoil dev_hmoil mean_fail, cluster(cowcode)
quietly: logit ged_fail ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem R_rog_0_GDPGSRE_Mpc_lnm_a R_rog_0_GDPGSRE_Mpc_lnmdev_a mean_fail if e(sample), cluster(cowcode)
fsum ged_fail mean_fail ged_dict mean_dict ged_dem mean_dem R_rog_0_GDPGSRE_Mpc_lnm_a R_rog_0_GDPGSRE_Mpc_lnmdev_a mean_gdp dev_gdp civilwar nbr_dem ged_time* time time2 time3 if e(sample), uselabel

* Table B-4: State Hydrocarbon Rents, Authoritarian Survival and the Onset of Democracy (Linear Probability)
use temp, clear
eststo clear
eststo: regress ged_fail  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem mean_hmoil dev_hmoil mean_fail, cluster(cowcode)
tab ged_fail if e(sample)
eststo: regress ged_fail  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem R_rog_0_GDPGSRE_Mpc_lnm_a R_rog_0_GDPGSRE_Mpc_lnmdev_a mean_fail if e(sample), cluster(cowcode)
tab ged_fail if e(sample)
eststo: regress ged_fail  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem mean_hmoil dev_hmoil mean_fail if e(sample), cluster(cowcode)
tab ged_fail if e(sample)

use temp, clear
eststo: regress ged_dict  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem mean_hmoil dev_hmoil mean_dict, cluster(cowcode)
tab ged_dict if e(sample)
eststo: regress ged_dict  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem R_rog_0_GDPGSRE_Mpc_lnm_a R_rog_0_GDPGSRE_Mpc_lnmdev_a mean_dict if e(sample), cluster(cowcode)
tab ged_dict if e(sample)
eststo: regress ged_dict  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem mean_hmoil dev_hmoil mean_dict if e(sample), cluster(cowcode)
tab ged_dict if e(sample)

use temp, clear
eststo: regress ged_dem  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem mean_hmoil dev_hmoil mean_dem, cluster(cowcode)
tab ged_dem if e(sample)
eststo: regress ged_dem  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem R_rog_0_GDPGSRE_Mpc_lnm_a R_rog_0_GDPGSRE_Mpc_lnmdev_a mean_dem if e(sample), cluster(cowcode)
tab ged_dem if e(sample)
eststo: regress ged_dem  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem mean_hmoil dev_hmoil mean_dem if e(sample), cluster(cowcode)
tab ged_dem if e(sample)

# delimit ;
esttab using AppendixB_TableB-4_Replication_Wrightetal2015_linear.csv, label replace star (+ 0.10 * 0.05 ** 0.01) 
nonumbers compress p ar2 pr2 scalars ("ll Log Likelihood" "chi2 Chi-Square" "N_clust No of Countries") lines nogaps obslast mtitles(
"(1) All Regime Failures" "(2) All Regime Failures" "(3) All Regime Failures"
"(4) Authoritarian Transitions" "(5) Authoritarian Transitions" "(6) Authoritarian Transitions"
"(7) Democratic Transitions" "(8) Democratic Transitions" "(9) Democratic Transitions");
# delimit cr

* Table B-5: State Hydrocarbon Rents, Authoritarian Survival and the Onset of Democracy (Non-linear Probability Models without Zeros)

use temp, clear
eststo clear
eststo: logit ged_fail  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem mean_hmoil dev_hmoil mean_fail if total_oil_income_pc!=0, cluster(cowcode)
lroc,  nograph
tab ged_fail if e(sample)
eststo: logit ged_fail  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem R_rog_0_GDPGSRE_Mpc_lnm_a R_rog_0_GDPGSRE_Mpc_lnmdev_a mean_fail if e(sample) & R_rog_0_GDPGSRE_Mpc!=0, cluster(cowcode)
lroc,  nograph
tab ged_fail if e(sample)
eststo: logit ged_fail  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem mean_hmoil dev_hmoil mean_fail if e(sample), cluster(cowcode)
lroc,  nograph
tab ged_fail if e(sample)

use temp,clear
eststo: logit ged_dict  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem mean_hmoil dev_hmoil mean_dict if total_oil_income_pc!=0, cluster(cowcode)
lroc,  nograph
tab ged_dict if e(sample)
eststo: logit ged_dict  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem R_rog_0_GDPGSRE_Mpc_lnm_a R_rog_0_GDPGSRE_Mpc_lnmdev_a mean_dict if e(sample) & R_rog_0_GDPGSRE_Mpc!=0, cluster(cowcode)
lroc,  nograph
tab ged_dict if e(sample)
eststo: logit ged_dict  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem mean_hmoil dev_hmoil mean_dict if e(sample), cluster(cowcode)
lroc,  nograph
tab ged_dict if e(sample)

use temp, clear
eststo: logit ged_dem  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem mean_hmoil dev_hmoil mean_dem if total_oil_income_pc!=0, cluster(cowcode)
lroc,  nograph
tab ged_dem if e(sample)
eststo: logit ged_dem  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem R_rog_0_GDPGSRE_Mpc_lnm_a R_rog_0_GDPGSRE_Mpc_lnmdev_a mean_dem if e(sample) & R_rog_0_GDPGSRE_Mpc!=0, cluster(cowcode)
lroc,  nograph
tab ged_dem if e(sample)
eststo: logit ged_dem  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem mean_hmoil dev_hmoil mean_dem if e(sample), cluster(cowcode)
lroc,  nograph
tab ged_dem if e(sample)

# delimit ;
esttab using AppendixB_TableB-5_Replication_Wrightetal2015_logit_without0.csv, label replace star (+ 0.10 * 0.05 ** 0.01) 
nonumbers compress p ar2 pr2 scalars ("ll Log Likelihood" "chi2 Chi-Square" "N_clust No of Countries") lines nogaps obslast mtitles(
"(1) All Regime Failures" "(2) All Regime Failures" "(3) All Regime Failures"
"(4) Authoritarian Transitions" "(5) Authoritarian Transitions" "(6) Authoritarian Transitions"
"(7) Democratic Transitions" "(8) Democratic Transitions" "(9) Democratic Transitions");
# delimit cr

* Table B-6: State Hydrocarbon Rents, Authoritarian Survival and the Onset of Democracy (Linear Probability Models without Zeros)* 

use temp, clear
eststo clear
eststo: regress ged_fail  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem mean_hmoil dev_hmoil mean_fail if total_oil_income_pc!=0, cluster(cowcode)
tab ged_fail if e(sample)
eststo: regress ged_fail  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem R_rog_0_GDPGSRE_Mpc_lnm_a R_rog_0_GDPGSRE_Mpc_lnmdev_a mean_fail if e(sample) & R_rog_0_GDPGSRE_Mpc!=0, cluster(cowcode)
tab ged_fail if e(sample)
eststo: regress ged_fail  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem mean_hmoil dev_hmoil mean_fail if e(sample), cluster(cowcode)
tab ged_fail if e(sample)

use temp,clear
eststo: regress ged_dict  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem mean_hmoil dev_hmoil mean_dict if total_oil_income_pc!=0, cluster(cowcode)
tab ged_dict if e(sample)
eststo: regress ged_dict  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem R_rog_0_GDPGSRE_Mpc_lnm_a R_rog_0_GDPGSRE_Mpc_lnmdev_a mean_dict if e(sample) & R_rog_0_GDPGSRE_Mpc!=0, cluster(cowcode)
tab ged_dict if e(sample)
eststo: regress ged_dict  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem mean_hmoil dev_hmoil mean_dict if e(sample), cluster(cowcode)
tab ged_dict if e(sample)

use temp, clear
eststo: regress ged_dem  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem mean_hmoil dev_hmoil mean_dem if total_oil_income_pc!=0, cluster(cowcode)
tab ged_dem if e(sample)
eststo: regress ged_dem  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem R_rog_0_GDPGSRE_Mpc_lnm_a R_rog_0_GDPGSRE_Mpc_lnmdev_a mean_dem if e(sample) & R_rog_0_GDPGSRE_Mpc!=0, cluster(cowcode)
tab ged_dem if e(sample)
eststo: regress ged_dem  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem mean_hmoil dev_hmoil mean_dem if e(sample), cluster(cowcode)
tab ged_dem if e(sample)

# delimit ;
esttab using AppendixB_TableB-6_Replication_Wrightetal2015_linear_without0.csv, label replace star (+ 0.10 * 0.05 ** 0.01) 
nonumbers compress p ar2 pr2 scalars ("ll Log Likelihood" "chi2 Chi-Square" "N_clust No of Countries") lines nogaps obslast mtitles(
"(1) All Regime Failures" "(2) All Regime Failures" "(3) All Regime Failures"
"(4) Authoritarian Transitions" "(5) Authoritarian Transitions" "(6) Authoritarian Transitions"
"(7) Democratic Transitions" "(8) Democratic Transitions" "(9) Democratic Transitions");
# delimit cr


* Figure B-1: All Regime Failures and Country-Means
use temp.dta, clear
quietly: logit ged_fail  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem mean_hmoil dev_hmoil mean_fail, cluster(cowcode)
sum mean_hmoil if mean_hmoil>0, detail
sum mean_hmoil if mean_hmoil>0 & e(sample), detail
* between-country variation mean_hmoil>0 is 0.38 at 10th percentile and 6.8 at 90th percentile
 
# delimit ;
margins, at 
(mean_hmoil=(0.38(0.1)6.8) dev_hmoil=(0) mean_gdp(mean) dev_gdp(mean) 
mean_fail(median) ged_time(median) ged_time2(median) ged_time3(median) time=(46) time2=(2116) time3=(97336)
nbr_dem(mean)
civilwar(mean) )
;
# delimit cr
marginsplot, name(A, replace) level(90) scale(0.6) ///
			 yscale(range(-0.01 0.05)) ylabel (-0.01(0.01)0.05) yline(0,lpattern(dash)) ///
			 xscale(range(0 7)) xlabel(0(1)7) ///
			 recast(line) recastci(rline) ciopts(lpattern(dot)) ///
			 title("All Regime Failures") ///
			 xtitle("Country-Means for Oil Income USD pc ln (H&M with 0s)") ///
			 ytitle("Probability of All Regime Failures (GWF)") graphregion(color(white)) bgcolor(white)

use temp.dta, clear
quietly: logit ged_fail  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem mean_hmoil dev_hmoil mean_fail, cluster(cowcode)
quietly: logit ged_fail  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem R_rog_0_GDPGSRE_Mpc_lnm_a R_rog_0_GDPGSRE_Mpc_lnmdev_a mean_fail if e(sample), cluster(cowcode)
sum R_rog_0_GDPGSRE_Mpc_lnm_a if e(sample) & R_rog_0_GDPGSRE_Mpc_lnm_a>0, detail

# delimit ;
margins, at 
(R_rog_0_GDPGSRE_Mpc_lnm_a=(0.10(0.1)6.39) R_rog_0_GDPGSRE_Mpc_lnmdev_a=(0) mean_gdp(mean) dev_gdp(mean) 
mean_fail(median) ged_time(median) ged_time2(median) ged_time3(median) time=(46) time2=(2116) time3=(97336)
nbr_dem(mean)
civilwar(mean) )
;
# delimit cr
marginsplot, name(B, replace) level(90) scale(0.6) ///
			 yscale(range(-0.01 0.05)) ylabel(-0.01(0.01)0.05) yline(0,lpattern(dash)) ///
			 xscale(range(0 7)) xlabel(0(1)7) ///
			 recast(line) recastci(rline) ciopts(lpattern(dot)) ///
			 title("All Regime Failures") ///
			 xtitle("Country-Means for State Hydrocarbon Rents USD pc ln (GSRE with 0s)") ///
			 ytitle("Probability of All Regime Failures (GWF)") graphregion(color(white)) bgcolor(white)

graph combine A B
graph export AppendixB_Figure_B-1_AllTransitions_Country-Mean.pdf, as(pdf) replace


* Figure B-2: All Regime Failures and Deviations Country-Means
use temp.dta, clear
quietly: logit ged_fail  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem mean_hmoil dev_hmoil mean_fail, cluster(cowcode)
sum dev_hmoil if mean_hmoil>0, detail
sum dev_hmoil if e(sample) & mean_hmoil>0, detail
* within-country variation with dev_hmoil>0 is -1.53 at 10th percentile and 1.81 at 90th percentile
sum mean_hmoil if mean_hmoil>0, detail
sum mean_hmoil if e(sample) & mean_hmoil>0, detail
* mean value of mean_hmoil is at 3.04 log unites

# delimit ;
margins, at 
(dev_hmoil=(-1.53(0.1)1.81) mean_hmoil=(3.039233) mean_gdp(mean) dev_gdp(mean) 
mean_fail(median) ged_time(median) ged_time2(median) ged_time3(median) time=(46) time2=(2116) time3=(97336)
nbr_dem(mean)
civilwar(mean) )
;
# delimit cr
marginsplot, name(C, replace) level(90) scale(0.6) ///
			 recast(line) recastci(rline) ciopts(lpattern(dot)) ///
			 yscale(range(-0.01 0.08)) ylabel(-0.01(0.01)0.08) yline(0,lpattern(dash)) ///
			 xscale(range(-1.8 2.6)) xlabel(-1.8(0.4)2.6) ///
			 title("All Regime Failures") ///
			 xtitle("Deviations from Country-Means for Oil Income USD pc ln (H&M with 0s)") ///
			 ytitle("Probability of All Regime Failures (GWF)") graphregion(color(white)) bgcolor(white)

			 
use temp.dta, clear
quietly: logit ged_fail  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem mean_hmoil dev_hmoil mean_fail, cluster(cowcode)
quietly: logit ged_fail  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem R_rog_0_GDPGSRE_Mpc_lnm_a R_rog_0_GDPGSRE_Mpc_lnmdev_a mean_fail if e(sample), cluster(cowcode)
sum R_rog_0_GDPGSRE_Mpc_lnmdev_a if R_rog_0_GDPGSRE_Mpc_lnm_a>0, detail
* within-country variation with R_rog_0_GDPGSRE_Mpc_lnmdev_a>0 is -1.36 at 10th percentile and 2.05 at 90th percentile
sum R_rog_0_GDPGSRE_Mpc_lnm_a if e(sample) & R_rog_0_GDPGSRE_Mpc_lnm_a>0, detail
* mean value of R_rog_0_GDPGSRE_Mpc_lnm is set at 2.32 log unites

# delimit ;
margins, at 
(R_rog_0_GDPGSRE_Mpc_lnmdev=(-1.36(0.1)2.05) R_rog_0_GDPGSRE_Mpc_lnmdev=(2.318684) mean_gdp(mean) dev_gdp(mean) 
mean_fail(median) ged_time(median) ged_time2(median) ged_time3(median) time=(46) time2=(2116) time3=(97336)
nbr_dem(mean)
civilwar(mean) )
;
# delimit cr
marginsplot, name(D, replace) level(90) scale(0.6) ///
			 yscale(range(-0.01 0.08)) ylabel(-0.01(0.01)0.08) yline(0,lpattern(dash)) ///
			 xscale(range(-1.8 2.6)) xlabel(-1.8(0.4)2.6) ///
			 recast(line) recastci(rline) ciopts(lpattern(dot)) ///
			 title("All Regime Failures") ///
			 xtitle("Deviations from Country-Means for State Hydrocarbon Rents USD pc ln (GSRE with 0s)") ///
			 ytitle("Probability of All Regime Failures (GWF)") graphregion(color(white)) bgcolor(white)

graph combine C D
graph export AppendixB_Figure_B-2_AllTransitions_Deviations-Country-Mean.pdf, as(pdf) replace


* Figure B-3: Authoritarian Transitions and Country-Means
use temp.dta, clear
quietly: logit ged_dict ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem mean_hmoil dev_hmoil mean_dict, cluster(cowcode)
sum mean_hmoil if mean_hmoil>0, detail
sum mean_hmoil if mean_hmoil>0 & e(sample), detail

# delimit ;
margins, at 
(mean_hmoil=(0.38(0.1)6.8) dev_hmoil=(0) mean_gdp(mean) dev_gdp(mean) 
mean_dict(median) ged_time(median) ged_time2(median) ged_time3(median) time=(46) time2=(2116) time3=(97336)
nbr_dem(mean)
civilwar(mean) )
;
# delimit cr
marginsplot, name(E, replace) level(90) scale(0.6) ///
			 yscale(range(-0.01 0.05)) ylabel (-0.01(0.01)0.05) yline(0,lpattern(dash)) ///
			 xscale(range(0 7)) xlabel(0(1)7) ///
			 recast(line) recastci(rline) ciopts(lpattern(dot)) ///
			 title("Authoritarian Transition") ///
			 xtitle("Country-Means for Oil Income USD pc ln (H&M with 0s)") ///
			 ytitle("Probability of Authoritarian Transition (GWF)") graphregion(color(white)) bgcolor(white)

use temp.dta, clear
quietly: logit ged_dict ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem mean_hmoil dev_hmoil mean_dict, cluster(cowcode)
quietly: logit ged_dict ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem R_rog_0_GDPGSRE_Mpc_lnm_a R_rog_0_GDPGSRE_Mpc_lnmdev_a mean_dict if e(sample), cluster(cowcode)
sum R_rog_0_GDPGSRE_Mpc_lnmdev_a if R_rog_0_GDPGSRE_Mpc_lnm_a>0, detail
* within-country variation with R_rog_0_GDPGSRE_Mpc_lnmdev_a>0 is -1.36 at 10th percentile and 2.05 at 90th percentile
sum R_rog_0_GDPGSRE_Mpc_lnm_a if e(sample) & R_rog_0_GDPGSRE_Mpc_lnm_a>0, detail
* mean value of R_rog_0_GDPGSRE_Mpc_lnm_a is set at 2.32 log unites

# delimit ;
margins, at 
(R_rog_0_GDPGSRE_Mpc_lnmdev=(-1.36(0.1)2.05) R_rog_0_GDPGSRE_Mpc_lnmdev=(2.318684) mean_gdp(mean) dev_gdp(mean) 
mean_dict(median) ged_time(median) ged_time2(median) ged_time3(median) time=(46) time2=(2116) time3=(97336)
nbr_dem(mean)
civilwar(mean) )
;
# delimit cr
marginsplot, name(F, replace) level(90) scale(0.6) ///
			 yscale(range(-0.01 0.08)) ylabel(-0.01(0.01)0.08) yline(0,lpattern(dash)) ///
			 xscale(range(-1.8 2.6)) xlabel(-1.8(0.4)2.6) ///
			 recast(line) recastci(rline) ciopts(lpattern(dot)) ///
			 title("Authoritarian Transition") ///
			 xtitle("Deviations from Country-Means for State Hydrocarbon Rents USD pc ln (GSRE with 0s)") ///
			 ytitle("Probability of Authoritarian Transition (GWF)") graphregion(color(white)) bgcolor(white)

graph combine E F
graph export AppendixB_Figure_B-3_AuthoritarianTransitions_Country-Mean.pdf, as(pdf) replace


* Figure B-4: Authoritarian Transitions and Deviations from Country-Means
use temp.dta, clear
quietly: logit ged_dict ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem mean_hmoil dev_hmoil mean_dict, cluster(cowcode)
sum dev_hmoil if mean_hmoil>0, detail
sum dev_hmoil if e(sample) & mean_hmoil>0, detail
* within-country variation with dev_hmoil>0 is -1.36 at 10th percentile and 1.82 at 90th percentile
sum mean_hmoil if mean_hmoil>0, detail
sum mean_hmoil if e(sample) & mean_hmoil>0, detail
* mean value of mean_hmoil is at 3.04 log unites

# delimit ;
margins, at 
(dev_hmoil=(-1.36(0.1)1.82) mean_hmoil=(3.039233) mean_gdp(mean) dev_gdp(mean) 
mean_dict(median) ged_time(median) ged_time2(median) ged_time3(median) time=(46) time2=(2116) time3=(97336)
nbr_dem(mean)
civilwar(mean) )
;
# delimit cr
marginsplot, name(G, replace) level(90) scale(0.6) ///
			 recast(line) recastci(rline) ciopts(lpattern(dot)) ///
			 yscale(range(-0.01 0.08)) ylabel(-0.01(0.01)0.08) yline(0,lpattern(dash)) ///
			 xscale(range(-1.8 2.6)) xlabel(-1.8(0.4)2.6) ///
			 title("Authoritarian Transition") ///
			 xtitle("Deviations from Country-Means for Oil Income USD pc ln (H&M with 0s)") ///
			 ytitle("Probability of Authoritarian Transition (GWF)") graphregion(color(white)) bgcolor(white)

			 
use temp.dta, clear
quietly: logit ged_dict  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem mean_hmoil dev_hmoil mean_dict, cluster(cowcode)
quietly: logit ged_dict  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem R_rog_0_GDPGSRE_Mpc_lnm_a R_rog_0_GDPGSRE_Mpc_lnmdev_a mean_dict if e(sample), cluster(cowcode)
sum R_rog_0_GDPGSRE_Mpc_lnmdev_a if R_rog_0_GDPGSRE_Mpc_lnm_a>0, detail
* within-country variation with R_rog_0_GDPGSRE_Mpc_lnmdev_a>0 is -1.36 at 10th percentile and 2.05 at 90th percentile
sum R_rog_0_GDPGSRE_Mpc_lnm_a if e(sample) & R_rog_0_GDPGSRE_Mpc_lnm_a>0, detail
* mean value of R_rog_0_GDPGSRE_Mpc_lnm is set at 2.32 log unites


# delimit ;
margins, at 
(R_rog_0_GDPGSRE_Mpc_lnmdev=(-1.36(0.1)2.05) R_rog_0_GDPGSRE_Mpc_lnmdev=(2.318684) mean_gdp(mean) dev_gdp(mean) 
mean_dict(median) ged_time(median) ged_time2(median) ged_time3(median) time=(46) time2=(2116) time3=(97336)
nbr_dem(mean)
civilwar(mean) )
;
# delimit cr
marginsplot, name(H, replace) level(90) scale(0.6) ///
			 yscale(range(-0.01 0.08)) ylabel(-0.01(0.01)0.08) yline(0,lpattern(dash)) ///
			 xscale(range(-1.8 2.6)) xlabel(-1.8(0.4)2.6) ///
			 recast(line) recastci(rline) ciopts(lpattern(dot)) ///
			 title("Authoritarian Transition") ///
			 xtitle("Deviations from Country-Means for State Hydrocarbon Rents USD pc ln (GSRE with 0s)") ///
			 ytitle("Probability of Authoritarian Transition (GWF)") graphregion(color(white)) bgcolor(white)

graph combine G H
graph export AppendixB_Figure_B-4_AuthoritarianTransitions_Deviations_Country-Mean.pdf, as(pdf) replace


* Figure B-5: Democratic Transitions and Country-Means
use temp.dta, clear
quietly: logit ged_dem ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem mean_hmoil dev_hmoil mean_dem, cluster(cowcode)
sum mean_hmoil if mean_hmoil>0, detail
sum mean_hmoil if mean_hmoil>0 & e(sample), detail

# delimit ;
margins, at 
(mean_hmoil=(0.38(0.1)7.47) dev_hmoil=(0) mean_gdp(mean) dev_gdp(mean) 
mean_dem(median) ged_time(median) ged_time2(median) ged_time3(median) time=(46) time2=(2116) time3=(97336)
nbr_dem(mean)
civilwar(mean) )
;
# delimit cr
marginsplot, name(I, replace) level(90) scale(0.6) ///
			 yscale(range(-0.01 0.05)) ylabel (-0.01(0.01)0.05) yline(0,lpattern(dash)) ///
			 xscale(range(0 7)) xlabel(0(1)7) ///
			 recast(line) recastci(rline) ciopts(lpattern(dot)) ///
			 title("Democratic Transition") ///
			 xtitle("Country-Means for Oil Income USD pc ln (H&M with 0s)") ///
			 ytitle("Probability of Democratic Transition (GWF)") graphregion(color(white)) bgcolor(white)

use temp.dta, clear
quietly: logit ged_dem ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem mean_hmoil dev_hmoil mean_dem, cluster(cowcode)
quietly: logit ged_dem ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem R_rog_0_GDPGSRE_Mpc_lnm_a R_rog_0_GDPGSRE_Mpc_lnmdev_a mean_dem if e(sample), cluster(cowcode)
sum R_rog_0_GDPGSRE_Mpc_lnmdev_a if R_rog_0_GDPGSRE_Mpc_lnm_a>0, detail
* within-country variation with R_rog_0_GDPGSRE_Mpc_lnmdev_a>0 is -1.36 at 10th percentile and 2.05 at 90th percentile
sum R_rog_0_GDPGSRE_Mpc_lnm_a if e(sample) & R_rog_0_GDPGSRE_Mpc_lnm_a>0, detail
* mean value of R_rog_0_GDPGSRE_Mpc_lnm_a is set at 2.32 log unites

# delimit ;
margins, at 
(R_rog_0_GDPGSRE_Mpc_lnmdev=(-1.36(0.1)2.05) R_rog_0_GDPGSRE_Mpc_lnmdev=(2.318684) mean_gdp(mean) dev_gdp(mean) 
mean_dem(median) ged_time(median) ged_time2(median) ged_time3(median) time=(46) time2=(2116) time3=(97336)
nbr_dem(mean)
civilwar(mean) )
;
# delimit cr
marginsplot, name(J, replace) level(90) scale(0.6) ///
			 yscale(range(-0.01 0.08)) ylabel(-0.01(0.01)0.08) yline(0,lpattern(dash)) ///
			 xscale(range(-1.8 2.6)) xlabel(-1.8(0.4)2.6) ///
			 recast(line) recastci(rline) ciopts(lpattern(dot)) ///
			 title("Democratic Transition") ///
			 xtitle("Deviations from Country-Means for State Hydrocarbon Rents USD pc ln (GSRE with 0s)") ///
			 ytitle("Probability of Democratic Transition (GWF)") graphregion(color(white)) bgcolor(white)

graph combine I J
graph export AppendixB_Figure_B-5_DemocraticTransitions_Country-Mean.pdf, as(pdf) replace


* Figure B-6: Democratic Transitions and Deviations from Country-Means
use temp.dta, clear
quietly: logit ged_dem ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem mean_hmoil dev_hmoil mean_dem, cluster(cowcode)
sum dev_hmoil if mean_hmoil>0, detail
sum dev_hmoil if e(sample) & mean_hmoil>0, detail
* within-country variation with dev_hmoil>0 is -1.36 at 10th percentile and 1.82 at 90th percentile
sum mean_hmoil if mean_hmoil>0, detail
sum mean_hmoil if e(sample) & mean_hmoil>0, detail
* mean value of mean_hmoil is at 3.04 log unites

# delimit ;
margins, at 
(dev_hmoil=(-1.36(0.1)1.82) mean_hmoil=(3.039233) mean_gdp(mean) dev_gdp(mean) 
mean_dem(median) ged_time(median) ged_time2(median) ged_time3(median) time=(46) time2=(2116) time3=(97336)
nbr_dem(mean)
civilwar(mean) )
;
# delimit cr
marginsplot, name(K, replace) level(90) scale(0.6) ///
			 recast(line) recastci(rline) ciopts(lpattern(dot)) ///
			 yscale(range(-0.01 0.08)) ylabel(-0.01(0.01)0.08) yline(0,lpattern(dash)) ///
			 xscale(range(-1.8 2.6)) xlabel(-1.8(0.4)2.6) ///
			 title("Democratic Transition") ///
			 xtitle("Deviations from Country-Means for Oil Income USD pc ln (H&M with 0s)") ///
			 ytitle("Probability of Democratic Transition (GWF)") graphregion(color(white)) bgcolor(white)

use temp.dta, clear
quietly: logit ged_dem  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem mean_hmoil dev_hmoil mean_dem, cluster(cowcode)
quietly: logit ged_dem  ged_time* time time2 time3 mean_gdp dev_gdp civilwar nbr_dem R_rog_0_GDPGSRE_Mpc_lnm_a R_rog_0_GDPGSRE_Mpc_lnmdev_a mean_dem if e(sample), cluster(cowcode)
sum R_rog_0_GDPGSRE_Mpc_lnmdev_a if R_rog_0_GDPGSRE_Mpc_lnm_a>0, detail
* within-country variation with R_rog_0_GDPGSRE_Mpc_lnmdev_a>0 is -1.36 at 10th percentile and 2.05 at 90th percentile
sum R_rog_0_GDPGSRE_Mpc_lnm_a if e(sample) & R_rog_0_GDPGSRE_Mpc_lnm_a>0, detail
* mean value of R_rog_0_GDPGSRE_Mpc_lnm is set at 2.32 log unites

# delimit ;
margins, at 
(R_rog_0_GDPGSRE_Mpc_lnmdev=(-1.36(0.1)2.05) R_rog_0_GDPGSRE_Mpc_lnmdev=(2.318684) mean_gdp(mean) dev_gdp(mean) 
mean_dem(median) ged_time(median) ged_time2(median) ged_time3(median) time=(46) time2=(2116) time3=(97336)
nbr_dem(mean)
civilwar(mean) )
;
# delimit cr
marginsplot, name(L, replace) level(90) scale(0.6) ///
			 yscale(range(-0.01 0.08)) ylabel(-0.01(0.01)0.08) yline(0,lpattern(dash)) ///
			 xscale(range(-1.8 2.6)) xlabel(-1.8(0.4)2.6) ///
			 recast(line) recastci(rline) ciopts(lpattern(dot)) ///
			 title("Democratic Transition") ///
			 xtitle("Deviations from Country-Means for State Hydrocarbon Rents USD pc ln (GSRE with 0s)") ///
			 ytitle("Probability of Democratic Transition (GWF)") graphregion(color(white)) bgcolor(white)

graph combine K L
graph export AppendixB_Figure_B-6_DemocraticTransitions_Deviations_Country-Mean.pdf, as(pdf) replace


**************
* Appendix C *
**************

use temp.dta, clear
eststo clear
eststo: xi: regress D.m_security_GDPGSRE_Mpc_ln L.m_security_GDPGSRE_Mpc_ln D.R_rog_0_GDPGSRE_Mpc_ln L.R_rog_0_GDPGSRE_Mpc_ln D.p_both_UCDPPRIO L.p_both_UCDPPRIO D.p_iwar1st_UCDPPRIO L.p_iwar1st_UCDPPRIO d.INST1_demtrans4k_gwf_cat L.INST1_demtrans4k_gwf_cat d.e_GDP_pc_Maddison_ln L.e_GDP_pc_Maddison_ln d.INST_regimeyears_GWF L.INST_regimeyears_GWF  i.cowcode*time i.cowcode*time2 if INST_autocracy_GWF==1, cluster(cowcode)
eststo: xi: regress D.milx_pc L.milx_pc D.R_rog_0_GDPGSRE_Mpc_ln L.R_rog_0_GDPGSRE_Mpc_ln D.p_both_UCDPPRIO L.p_both_UCDPPRIO D.p_iwar1st_UCDPPRIO L.p_iwar1st_UCDPPRIO d.INST1_demtrans4k_gwf_cat L.INST1_demtrans4k_gwf_cat d.e_GDP_pc_Maddison_ln L.e_GDP_pc_Maddison_ln d.INST_regimeyears_GWF L.INST_regimeyears_GWF  i.cowcode*time i.cowcode*time2 if e(sample), cluster(cowcode)
eststo: xi: regress D.m_security_GDPGSRE_Mpc_ln L.m_security_GDPGSRE_Mpc_ln D.R_rog_0_GDPGSRE_Mpc_ln L.R_rog_0_GDPGSRE_Mpc_ln D.p_both_UCDPPRIO L.p_both_UCDPPRIO D.p_iwar1st_UCDPPRIO L.p_iwar1st_UCDPPRIO d.INST1_demtrans4k_gwf_cat L.INST1_demtrans4k_gwf_cat d.e_GDP_pc_Maddison_ln L.e_GDP_pc_Maddison_ln d.INST_regimeyears_GWF L.INST_regimeyears_GWF  i.cowcode*time i.cowcode*time2 if e(sample), cluster(cowcode)
eststo: xi: regress D.milx_pc L.milx_pc D.R_rog_0_GDPGSRE_Mpc_ln L.R_rog_0_GDPGSRE_Mpc_ln D.p_both_UCDPPRIO L.p_both_UCDPPRIO D.p_iwar1st_UCDPPRIO L.p_iwar1st_UCDPPRIO d.INST1_demtrans4k_gwf_cat L.INST1_demtrans4k_gwf_cat d.e_GDP_pc_Maddison_ln L.e_GDP_pc_Maddison_ln d.INST_regimeyears_GWF L.INST_regimeyears_GWF  i.cowcode*time i.cowcode*time2 if INST_autocracy_GWF==1, cluster(cowcode)
# delimit ;
esttab using AppendixC_TableC-1_military.csv, b(3) p(3) label replace star (+ 0.10 * 0.05 ** 0.01) 
nonumbers compress scalars ("r2 R2" "N_clust No of Countries") lines nogaps obslast mtitles(
"(1) Total Security GSRE" "(2) Total Military COW" "(3) Total Security GSRE" "(4) Total Military COW");
# delimit cr


use temp.dta, clear
quietly: xi: regress D.m_total_tax_nor_GDPGSRE_Mpc_ln L.m_total_tax_nor_GDPGSRE_Mpc_ln D.R_rog_0_GDPGSRE_Mpc_ln L.R_rog_0_GDPGSRE_Mpc_ln D.p_both_UCDPPRIO L.p_both_UCDPPRIO D.p_iwar1st_UCDPPRIO L.p_iwar1st_UCDPPRIO d.INST1_demtrans4k_gwf_cat L.INST1_demtrans4k_gwf_cat d.e_GDP_pc_Maddison_ln L.e_GDP_pc_Maddison_ln d.INST_regimeyears_GWF L.INST_regimeyears_GWF  i.cowcode*time i.cowcode*time2  if INST_autocracy_GWF==1, cluster(cowcode)
* Table C-2
fsum m_total_tax_nor_GDPGSRE_Mpc_ln R_rog_0_GDPGSRE_Mpc_ln p_both_UCDPPRIO p_iwar1st_UCDPPRIO INST1_demtrans4k_gwf_cat e_GDP_pc_Maddison_ln INST_regimeyears_GWF time time2 if e(sample), uselabel

quietly: xi: regress D.m_dtax_nor1_GDPGSRE_Mpc_ln L.m_dtax_nor1_GDPGSRE_Mpc_ln D.R_rog_0_GDPGSRE_Mpc_ln L.R_rog_0_GDPGSRE_Mpc_ln D.p_both_UCDPPRIO L.p_both_UCDPPRIO D.p_iwar1st_UCDPPRIO L.p_iwar1st_UCDPPRIO d.INST1_demtrans4k_gwf_cat L.INST1_demtrans4k_gwf_cat d.e_GDP_pc_Maddison_ln L.e_GDP_pc_Maddison_ln d.INST_regimeyears_GWF L.INST_regimeyears_GWF  i.cowcode*time i.cowcode*time2 if INST_autocracy_GWF==1, cluster(cowcode)
* Table C-3
fsum m_dtax_nor1_GDPGSRE_Mpc_ln R_rog_0_GDPGSRE_Mpc_ln p_both_UCDPPRIO p_iwar1st_UCDPPRIO INST1_demtrans4k_gwf_cat e_GDP_pc_Maddison_ln INST_regimeyears_GWF time time2 if e(sample), uselabel

quietly: xi: regress d.m_indirect_taxes_GDPGSRE_Mpc_ln L.m_indirect_taxes_GDPGSRE_Mpc_ln D.R_rog_0_GDPGSRE_Mpc_ln L.R_rog_0_GDPGSRE_Mpc_ln D.p_both_UCDPPRIO L.p_both_UCDPPRIO D.p_iwar1st_UCDPPRIO L.p_iwar1st_UCDPPRIO d.INST1_demtrans4k_gwf_cat L.INST1_demtrans4k_gwf_cat d.e_GDP_pc_Maddison_ln L.e_GDP_pc_Maddison_ln d.INST_regimeyears_GWF L.INST_regimeyears_GWF i.cowcode*time i.cowcode*time2 if INST_autocracy_GWF==1, cluster(cowcode)
* Table C-4
fsum m_indirect_taxes_GDPGSRE_Mpc_ln R_rog_0_GDPGSRE_Mpc_ln p_both_UCDPPRIO p_iwar1st_UCDPPRIO INST1_demtrans4k_gwf_cat e_GDP_pc_Maddison_ln INST_regimeyears_GWF time time2 if e(sample), uselabel

quietly: xi: regress D.m_income_tax_GDPGSRE_Mpc_ln L.m_income_tax_GDPGSRE_Mpc_ln D.R_rog_0_GDPGSRE_Mpc_ln L.R_rog_0_GDPGSRE_Mpc_ln D.p_both_UCDPPRIO L.p_both_UCDPPRIO D.p_iwar1st_UCDPPRIO L.p_iwar1st_UCDPPRIO d.INST1_demtrans4k_gwf_cat L.INST1_demtrans4k_gwf_cat d.e_GDP_pc_Maddison_ln L.e_GDP_pc_Maddison_ln d.INST_regimeyears_GWF L.INST_regimeyears_GWF  i.cowcode*time i.cowcode*time2 if INST_autocracy_GWF==1, cluster(cowcode)
* Table C-5
fsum m_income_tax_GDPGSRE_Mpc_ln R_rog_0_GDPGSRE_Mpc_ln p_both_UCDPPRIO p_iwar1st_UCDPPRIO INST1_demtrans4k_gwf_cat e_GDP_pc_Maddison_ln INST_regimeyears_GWF time time2 if e(sample), uselabel

quietly: xi: regress d.m_othercorptax_GDPGSRE_Mpc_ln L.m_othercorptax_GDPGSRE_Mpc_ln D.R_rog_0_GDPGSRE_Mpc_ln L.R_rog_0_GDPGSRE_Mpc_ln D.p_both_UCDPPRIO L.p_both_UCDPPRIO D.p_iwar1st_UCDPPRIO L.p_iwar1st_UCDPPRIO d.INST1_demtrans4k_gwf_cat L.INST1_demtrans4k_gwf_cat d.e_GDP_pc_Maddison_ln L.e_GDP_pc_Maddison_ln d.INST_regimeyears_GWF L.INST_regimeyears_GWF  i.cowcode*time i.cowcode*time2 if INST_autocracy_GWF==1, cluster(cowcode)
* Table C-6
fsum m_othercorptax_GDPGSRE_Mpc_ln R_rog_0_GDPGSRE_Mpc_ln p_both_UCDPPRIO p_iwar1st_UCDPPRIO INST1_demtrans4k_gwf_cat e_GDP_pc_Maddison_ln INST_regimeyears_GWF time time2 if e(sample), uselabel

quietly: xi: regress D.m_texpendit_GDPGSRE_Mpc_ln L.m_texpendit_GDPGSRE_Mpc_ln D.R_rog_0_GDPGSRE_Mpc_ln L.R_rog_0_GDPGSRE_Mpc_ln D.p_both_UCDPPRIO L.p_both_UCDPPRIO D.p_iwar1st_UCDPPRIO L.p_iwar1st_UCDPPRIO d.INST1_demtrans4k_gwf_cat L.INST1_demtrans4k_gwf_cat d.e_GDP_pc_Maddison_ln L.e_GDP_pc_Maddison_ln d.INST_regimeyears_GWF L.INST_regimeyears_GWF  i.cowcode*time i.cowcode*time2  if INST_autocracy_GWF==1, cluster(cowcode)
* Table C-7
fsum m_texpendit_GDPGSRE_Mpc_ln R_rog_0_GDPGSRE_Mpc_ln p_both_UCDPPRIO p_iwar1st_UCDPPRIO INST1_demtrans4k_gwf_cat e_GDP_pc_Maddison_ln INST_regimeyears_GWF time time2 if e(sample), uselabel

quietly: xi: regress D.m_security_GDPGSRE_Mpc_ln L.m_security_GDPGSRE_Mpc_ln D.R_rog_0_GDPGSRE_Mpc_ln L.R_rog_0_GDPGSRE_Mpc_ln D.p_both_UCDPPRIO L.p_both_UCDPPRIO D.p_iwar1st_UCDPPRIO L.p_iwar1st_UCDPPRIO d.INST1_demtrans4k_gwf_cat L.INST1_demtrans4k_gwf_cat d.e_GDP_pc_Maddison_ln L.e_GDP_pc_Maddison_ln d.INST_regimeyears_GWF L.INST_regimeyears_GWF  i.cowcode*time i.cowcode*time2 if INST_autocracy_GWF==1, cluster(cowcode)
* Table C-8
fsum m_security_GDPGSRE_Mpc_ln R_rog_0_GDPGSRE_Mpc_ln p_both_UCDPPRIO p_iwar1st_UCDPPRIO INST1_demtrans4k_gwf_cat e_GDP_pc_Maddison_ln INST_regimeyears_GWF time time2 if e(sample), uselabel

quietly: xi: regress D.m_wages_GDPGSRE_Mpc_ln L.m_wages_GDPGSRE_Mpc_ln D.R_rog_0_GDPGSRE_Mpc_ln L.R_rog_0_GDPGSRE_Mpc_ln D.p_both_UCDPPRIO L.p_both_UCDPPRIO D.p_iwar1st_UCDPPRIO L.p_iwar1st_UCDPPRIO d.INST1_demtrans4k_gwf_cat L.INST1_demtrans4k_gwf_cat d.e_GDP_pc_Maddison_ln L.e_GDP_pc_Maddison_ln d.INST_regimeyears_GWF L.INST_regimeyears_GWF  i.cowcode*time i.cowcode*time2 if INST_autocracy_GWF==1, cluster(cowcode)
* Table C-9
fsum m_wages_GDPGSRE_Mpc_ln R_rog_0_GDPGSRE_Mpc_ln p_both_UCDPPRIO p_iwar1st_UCDPPRIO INST1_demtrans4k_gwf_cat e_GDP_pc_Maddison_ln INST_regimeyears_GWF time time2 if e(sample), uselabel

quietly: xi: regress D.m_twelfare_GDPGSRE_Mpc_ln L.m_twelfare_GDPGSRE_Mpc_ln D.R_rog_0_GDPGSRE_Mpc_ln L.R_rog_0_GDPGSRE_Mpc_ln D.p_both_UCDPPRIO L.p_both_UCDPPRIO D.p_iwar1st_UCDPPRIO L.p_iwar1st_UCDPPRIO d.INST1_demtrans4k_gwf_cat L.INST1_demtrans4k_gwf_cat d.e_GDP_pc_Maddison_ln L.e_GDP_pc_Maddison_ln d.INST_regimeyears_GWF L.INST_regimeyears_GWF  i.cowcode*time i.cowcode*time2 if INST_autocracy_GWF==1, cluster(cowcode)
* Table C-10
fsum m_twelfare_GDPGSRE_Mpc_ln R_rog_0_GDPGSRE_Mpc_ln p_both_UCDPPRIO p_iwar1st_UCDPPRIO INST1_demtrans4k_gwf_cat e_GDP_pc_Maddison_ln INST_regimeyears_GWF time time2 if e(sample), uselabel


erase temp.dta

capture log close
