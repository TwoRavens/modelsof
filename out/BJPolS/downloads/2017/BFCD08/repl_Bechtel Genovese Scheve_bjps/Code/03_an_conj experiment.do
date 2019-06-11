*************************************************************************
* Replication archive for Bechtel, Genovese and Scheve (2016)            *
* "Interests, Norms and Support for the Provision of Global Public Goods:*
* The Case of Climate Cooperation", British Journal of Political Science *
*************************************************************************

/* Analysis of the Conjoint Experimental Data*/
capture log close
clear all
set memory 200m
set more off

* Global path
global dropboxpath = "/Users/genovesefederica/Dropbox/Pref IEC_Context/repl_Bechtel Genovese Scheve_bjps/"
*global dropboxpath = "/Users/mbechtel/Desktop/repdata"
*global dropboxpath = "/Users/scheve/Dropbox/Pref IEC_Context/repl_Bechtel Genovese Scheve_bjps/"

/* Use pooled agreement-level data */
cd "$dropboxpath/Data/Main Pooled"
use main_pooled_agreementlevel_industry.dta

* Generate dummies for treatment conditions
tab cost_cj, gen(cost_)
tab sanctions_cj, gen(sanctions_) 
tab ctries_cj, gen(ctries_)
tab emissions_cj, gen(emissions_)
tab distrib_cj, gen(distrib_)
tab monitoring_cj, gen(monitoring_)

cd "$dropboxpath/Results/Conjoint analysis"
log using "03_an_conj experiment.smcl", replace

/*
1. Estimate conjoint effects for norms and cost dimensions:
Costs: i.cost_cj i.sanctions_cj 
Reciprocity norms: i.ctries_cj i.emissions_cj
Fairness norms: i.distrib_cj

2. Explore interactions between norms and costs
a) Within conjoint results: i.ctries_cj i.emissions_cj i.distrib_cj by: i.cost_cj i.sanctions_cj
b) Using pollution measures: i.ctries_cj i.emissions_cj i.distrib_cj by: industryco2_onlyemp industryco2eq_onlyemp industryco2eq_wb_onlyemp industryoileq_onlyemp industryco2_emp_onlyemp industryoileq_emp_onlyemp
c) By reciprocity measure (strategy method): i.ctries_cj i.emissions_cj i.distrib_cj i.cost_cj i.sanctions_cj
*/

* Generate interactions
foreach var of varlist cost_1 cost_2 cost_3 cost_4 cost_5 sanctions_1 sanctions_2 sanctions_3 sanctions_4 ctries_1 ctries_2 ctries_3 emissions_1 emissions_2 emissions_3 {
gen `var'Xind_co2eq=`var'*industryco2eq_onlyemp
}

* Calculate effects of all agreement dimensions for plotting with i. prefix
reg choice_cj i.cost_cj i.sanctions_cj i.ctries_cj i.emissions_cj i.distrib_cj i.monitoring_cj , vce(cluster ID)
parmest, saving(cj_all, replace)

* Calculate effects of only costs and norms dimensions for plotting with i. prefix: no weights  [pweight=weight]
reg choice_cj i.cost_cj i.sanctions_cj i.ctries_cj i.emissions_cj, vce(cluster ID)
parmest, saving(cj_main, replace)

/* Main Analyses */

* Table 3 - Willingness To Pay Estimates
* Estimation using continuous cost variable for willingness to pay estimation: Recode and estimate by country!
gen cost_cont=.

* For France (id=1):1=28 2=56 3=84 4=113 5=141
replace cost_cont=28 if cost_cj==1 & country==1
replace cost_cont=56 if cost_cj==2 & country==1
replace cost_cont=84 if cost_cj==3 & country==1
replace cost_cont=113 if cost_cj==4 & country==1
replace cost_cont=141 if cost_cj==5 & country==1

* For Germany (id=2):1=39 2=77 3=116 4=154 5=193
replace cost_cont=39 if cost_cj==1 & country==2
replace cost_cont=77 if cost_cj==2 & country==2
replace cost_cont=116 if cost_cj==3 & country==2
replace cost_cont=154 if cost_cj==4 & country==2
replace cost_cont=193 if cost_cj==5 & country==2

* For UK (id=3):1=15 2=30 3=45 4=60 5=75
replace cost_cont=15 if cost_cj==1 & country==3
replace cost_cont=30 if cost_cj==2 & country==3
replace cost_cont=45 if cost_cj==3 & country==3
replace cost_cont=60 if cost_cj==4 & country==3
replace cost_cont=75 if cost_cj==5 & country==3

* For US (id=4):1=53 2=107 3=160 4=213 5=267
replace cost_cont=53 if cost_cj==1 & country==4
replace cost_cont=107 if cost_cj==2 & country==4
replace cost_cont=160 if cost_cj==3 & country==4
replace cost_cont=213 if cost_cj==4 & country==4
replace cost_cont=267 if cost_cj==5 & country==4

reg choice_cj cost_cont i.sanctions_cj i.ctries_cj i.emissions_cj if country==1, vce(cluster ID)
parmest, saving(cj_main_wtp_fr, replace)

reg choice_cj cost_cont i.sanctions_cj i.ctries_cj i.emissions_cj if country==2, vce(cluster ID)
parmest, saving(cj_main_wtp_ge, replace)

reg choice_cj cost_cont i.sanctions_cj i.ctries_cj i.emissions_cj if country==3, vce(cluster ID)
parmest, saving(cj_main_wtp_uk, replace)

reg choice_cj cost_cont i.sanctions_cj i.ctries_cj i.emissions_cj if country==4, vce(cluster ID)
parmest, saving(cj_main_wtp_us, replace)

/* Analyses for Figure 1 and Appendix plots (see folder "R figures" in the replication archive for code) */

* Figure 1: effects of costs and norms dimensions with CO2-equivalent pollution measure subgroups with i. prefix

* Pollution low group
reg choice_cj i.cost_cj i.sanctions_cj i.ctries_cj i.emissions_cj if industryco2eq_onlyemp==0, vce(cluster ID)
parmest, saving(cj_mat_co2eqlow, replace)
* Pollution high group
reg choice_cj i.cost_cj i.sanctions_cj i.ctries_cj i.emissions_cj if industryco2eq_onlyemp==1 , vce(cluster ID)
parmest, saving(cj_mat_co2eqhigh, replace)

* Appendix

* Figure A.2: effects of costs and norms dimensions with CO2eq WB pollution measure subgroups with i. prefix

* Pollution low group
reg choice_cj i.cost_cj i.sanctions_cj i.ctries_cj i.emissions_cj if industryco2eq_wb_onlyemp==0 , vce(cluster ID)
parmest, saving(cj_mat_co2eqwblow, replace)
* Pollution high group
reg choice_cj i.cost_cj i.sanctions_cj i.ctries_cj i.emissions_cj if industryco2eq_wb_onlyemp==1 , vce(cluster ID)
parmest, saving(cj_mat_co2eqwbhigh, replace)

* Figure A.3: effects of costs and norms dimensions with CO2 pollution measure subgroups with i. prefix

* Pollution low group
reg choice_cj i.cost_cj i.sanctions_cj i.ctries_cj i.emissions_cj if industryco2_onlyemp==0 , vce(cluster ID)
parmest, saving(cj_mat_co2low, replace)
* Pollution high group
reg choice_cj i.cost_cj i.sanctions_cj i.ctries_cj i.emissions_cj if industryco2_onlyemp==1 , vce(cluster ID)
parmest, saving(cj_mat_co2high, replace)

*  Figure A.4: effects of costs and norms dimensions with Oil eq pollution measure subgroups with i. prefix

* Pollution low group
reg choice_cj i.cost_cj i.sanctions_cj i.ctries_cj i.emissions_cj if industryoileq_onlyemp==0 , vce(cluster ID)
parmest, saving(cj_mat_oileqlow, replace)
* Pollution high group
reg choice_cj i.cost_cj i.sanctions_cj i.ctries_cj i.emissions_cj if industryoileq_onlyemp==1, vce(cluster ID)
parmest, saving(cj_mat_oileqhigh, replace)

*  Figure A.5: effects of costs and norms dimensions with CO2eq weighted by employment, measure subgroups with i. prefix

* Pollution low group
reg choice_cj i.cost_cj i.sanctions_cj i.ctries_cj i.emissions_cj if industryco2eq_emp_onlyemp==0 , vce(cluster ID)
parmest, saving(cj_mat_co2eqemplow, replace)
* Pollution high group
reg choice_cj i.cost_cj i.sanctions_cj i.ctries_cj i.emissions_cj if industryco2eq_emp_onlyemp==1 , vce(cluster ID)
parmest, saving(cj_mat_co2eqemphigh, replace)

* Figure A.6: effects of costs and norms dimensions with reciprocity subgroups with i. prefix

* Reciprocity low group
reg choice_cj i.cost_cj i.sanctions_cj i.ctries_cj i.emissions_cj if recip_s_high_group==0 & emp_status==1 , vce(cluster ID)
parmest, saving(cj_mat_reciplow, replace)
* Reciprocity high group
reg choice_cj i.cost_cj i.sanctions_cj i.ctries_cj i.emissions_cj if recip_s_high_group==1 & emp_status==1 , vce(cluster ID)
parmest, saving(cj_mat_reciphigh, replace)

/*
* effects of costs and norms dimensions with Reciprocity (all respondents) subgroups with i. prefix
* Reciprocity low group
reg choice_cj i.cost_cj i.sanctions_cj i.ctries_cj i.emissions_cj if recip_s_high_group==0  , vce(cluster ID)
parmest, saving(cj_mat_reciplow_all, replace)
* Reciprocity high group
reg choice_cj i.cost_cj i.sanctions_cj i.ctries_cj i.emissions_cj if recip_s_high_group==1 , vce(cluster ID)
parmest, saving(cj_mat_reciphigh_all, replace)
*/

* Figure A.7: effects of costs and norms dimensions with Educational Attainment

* Education high group
reg choice_cj i.cost_cj i.sanctions_cj i.ctries_cj i.emissions_cj if educ_high==1  , vce(cluster ID)
*outreg2 using conjoint.xls, ctitle("Education: High") excel bdec(3) stats(coef se) append
parmest, saving(cj_mat_eduhigh, replace)
* Education low group
reg choice_cj i.cost_cj i.sanctions_cj i.ctries_cj i.emissions_cj if educ_high==0  , vce(cluster ID)
*outreg2 using conjoint.xls, ctitle("Education: Low") excel bdec(3) stats(coef se) append
parmest, saving(cj_mat_edulow, replace)


* Need to save the results data in old dta format and as txt
clear
foreach set in cj_all cj_main cj_mat_co2eqlow cj_mat_co2eqhigh cj_mat_co2low cj_mat_co2high cj_mat_co2eqemplow cj_mat_co2eqemphigh cj_mat_co2eqwbhigh cj_mat_co2eqwblow cj_mat_oileqhigh cj_mat_oileqlow  cj_mat_reciplow cj_mat_reciphigh    {
use `set'.dta
saveold `set'.dta, replace
export delimited using `set'.txt, replace
}

clear


* Figure A8: Individual country conjoint analysis (by country)

cd "$dropboxpath/Data/Main Pooled"
use main_pooled_agreementlevel_industry.dta

keep if country==1
cd "$dropboxpath/Results/Conjoint analysis/FR"

reg choice_cj    , vce(cluster ID)
outreg2 using conjoint.xls, excel bdec(3) stats(coef se) replace

* All with weights for plotting with i. prefix
reg choice_cj i.cost_cj i.sanctions_cj i.ctries_cj i.emissions_cj i.distrib_cj i.monitoring_cj  , vce(cluster ID)
parmest, saving(cj_all, replace)

* Only costs and norms dimensions for plotting with i. prefix
reg choice_cj i.cost_cj i.sanctions_cj i.ctries_cj i.emissions_cj  , vce(cluster ID)
parmest, saving(cj_main, replace)


* Estimate effects of cost and norms dimensions with CO2 equivalent pollution measure subgroups for France plotting with i. prefix
* Pollution low group
reg choice_cj i.cost_cj i.sanctions_cj i.ctries_cj i.emissions_cj if industryco2eq_onlyemp==0 , vce(cluster ID)
parmest, saving(cj_mat_co2eqlow, replace)
* Pollution high group
reg choice_cj i.cost_cj i.sanctions_cj i.ctries_cj i.emissions_cj if industryco2eq_onlyemp==1  , vce(cluster ID)
parmest, saving(cj_mat_co2eqhigh, replace)

clear
foreach set in cj_all cj_main cj_mat_co2eqlow cj_mat_co2eqhigh{
use `set'.dta
saveold `set'.dta, replace
export delimited using `set'.txt, replace
}

clear

cd "$dropboxpath/Data/Main Pooled"
use main_pooled_agreementlevel_industry.dta

keep if country==2
cd "$dropboxpath/Results/Conjoint analysis/GE"

reg choice_cj    , vce(cluster ID)
outreg2 using conjoint.xls, excel bdec(3) stats(coef se) replace

* All with weights for plotting with i. prefix
reg choice_cj i.cost_cj i.sanctions_cj i.ctries_cj i.emissions_cj i.distrib_cj i.monitoring_cj  , vce(cluster ID)
parmest, saving(cj_all, replace)

* Only costs and norms dimensions for plotting with i. prefix
reg choice_cj i.cost_cj i.sanctions_cj i.ctries_cj i.emissions_cj  , vce(cluster ID)
parmest, saving(cj_main, replace)


* Estimate effects of cost and norms dimensions with CO2 equivalent pollution measure subgroups for Germany plotting with i. prefix
* Pollution low group
reg choice_cj i.cost_cj i.sanctions_cj i.ctries_cj i.emissions_cj if industryco2eq_onlyemp==0 , vce(cluster ID)
parmest, saving(cj_mat_co2eqlow, replace)
* Pollution high group
reg choice_cj i.cost_cj i.sanctions_cj i.ctries_cj i.emissions_cj if industryco2eq_onlyemp==1  , vce(cluster ID)
parmest, saving(cj_mat_co2eqhigh, replace)

clear
foreach set in cj_all cj_main cj_mat_co2eqlow cj_mat_co2eqhigh{
use `set'.dta
saveold `set'.dta, replace
export delimited using `set'.txt, replace
}

clear


cd "$dropboxpath/Data/Main Pooled"
use main_pooled_agreementlevel_industry.dta

keep if country==3
cd "$dropboxpath/Results/Conjoint analysis/Uk"

reg choice_cj    , vce(cluster ID)
outreg2 using conjoint.xls, excel bdec(3) stats(coef se) replace

* All with weights for plotting with i. prefix
reg choice_cj i.cost_cj i.sanctions_cj i.ctries_cj i.emissions_cj i.distrib_cj i.monitoring_cj  , vce(cluster ID)
parmest, saving(cj_all, replace)

* Only costs and norms dimensions for plotting with i. prefix
reg choice_cj i.cost_cj i.sanctions_cj i.ctries_cj i.emissions_cj  , vce(cluster ID)
parmest, saving(cj_main, replace)


* Estimate effects of cost and norms dimensions with CO2 equivalent pollution measure subgroups for UK plotting with i. prefix
* Pollution low group
reg choice_cj i.cost_cj i.sanctions_cj i.ctries_cj i.emissions_cj if industryco2eq_onlyemp==0 , vce(cluster ID)
parmest, saving(cj_mat_co2eqlow, replace)
* Pollution high group
reg choice_cj i.cost_cj i.sanctions_cj i.ctries_cj i.emissions_cj if industryco2eq_onlyemp==1  , vce(cluster ID)
parmest, saving(cj_mat_co2eqhigh, replace)

clear
foreach set in cj_all cj_main cj_mat_co2eqlow cj_mat_co2eqhigh{
use `set'.dta
saveold `set'.dta, replace
export delimited using `set'.txt, replace
}

clear

cd "$dropboxpath/Data/Main Pooled"
use main_pooled_agreementlevel_industry.dta

keep if country==4
cd "$dropboxpath/Results/Conjoint analysis/US"

reg choice_cj    , vce(cluster ID)
outreg2 using conjoint.xls, excel bdec(3) stats(coef se) replace

* All with weights for plotting with i. prefix
reg choice_cj i.cost_cj i.sanctions_cj i.ctries_cj i.emissions_cj i.distrib_cj i.monitoring_cj  , vce(cluster ID)
parmest, saving(cj_all, replace)

* Only costs and norms dimensions for plotting with i. prefix
reg choice_cj i.cost_cj i.sanctions_cj i.ctries_cj i.emissions_cj  , vce(cluster ID)
parmest, saving(cj_main, replace)


* Estimate effects of cost and norms dimensions with CO2 equivalent pollution measure subgroups for US plotting with i. prefix
* Pollution low group
reg choice_cj i.cost_cj i.sanctions_cj i.ctries_cj i.emissions_cj if industryco2eq_onlyemp==0 , vce(cluster ID)
parmest, saving(cj_mat_co2eqlow, replace)
* Pollution high group
reg choice_cj i.cost_cj i.sanctions_cj i.ctries_cj i.emissions_cj if industryco2eq_onlyemp==1  , vce(cluster ID)
parmest, saving(cj_mat_co2eqhigh, replace)

clear
foreach set in cj_all cj_main cj_mat_co2eqlow cj_mat_co2eqhigh{
use `set'.dta
saveold `set'.dta, replace
export delimited using `set'.txt, replace
}

clear


log close
exit

