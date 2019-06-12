*12345678901234567890123456789012345678901234567890123456789012345678901234567890
capture log close
clear all
set more off

*	************************************************************************
* 	File-Name: 	AklinUrpelainenAnalysis.do
*	Date:  		05/18/2010
*				04/15/2013
*	Author: 	Micha‘l Aklin (NYU) & Johannes Urpelainen (Columbia)
*	Data Used:  AklinUrpelainen2014ISQ.dta
*	Purpose:   	.do file for the replication of "The Global Spread of 
*				Environmental Ministries: Domestic-International Interactions"
*				forthcoming at ISQ
*
*	Structure:
*				1. Open the dataset
*				2. Summary statistics (Table 1)
*				3. Main Regressions (other tables)
*				4. Tests (proportionality, etc)
*				5. References in main text (e.g., correlation coefficients)
*				6. Graphs
*				7. Robustness checks (alternative modeling, variables, etc.)
*	************************************************************************


*	************************************************************************
* 	1. Run the coding do file
*	************************************************************************

*	Change the working directory. THIS IS NEEDED FOR THE FILE TO WORK!
cd ""

*	Open the dataset
use "AklinUrpelainen2014ISQ.dta"


*	************************************************************************
* 	2. Summary statistic and correlations
*	************************************************************************

*	* Summary statistics
estpost summarize env_ministryonset_realb demo_dummy3 emn_av emnav_x_demodummy3 emb_av embav_x_demodummy3 gdpcapk pop_density_wdi openk service1 if env_ministryonset_realb != . & demo_dummy3 != . & emb_av != . & embav_x_demodummy3 != . & gdpcapk != . & pop_density_wdi != . & openk != . & service1 != .
esttab using "table1.tex", replace cells("count mean(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))") noobs label booktabs ///
title(Summary Statistics\label{table1})
eststo clear

*	* Correlation table
eststo clear
estpost correlate env_ministryonset_realb demo_dummy3 ir9294 emb_av regional_proportion_envministry, matrix listwise
esttab using "table1b.tex", unstack not noobs compress label replace b(3)	///
title(Correlation Matrix\label{table1b})

eststo clear
estpost correlate env_ministryonset_realb demo_dummy3 ir9294 emb_av regional_proportion_envministry ir9294_x_demod3 embav_x_demodummy3 regionalpe_x_demodummy3, matrix listwise
esttab using "table1c.tex", unstack not noobs compress label replace b(3)	///
title(Correlation Matrix\label{table1c})


*	************************************************************************
*	3. Analyses
*		a. Rio approach (international pressure starting in the 1992)
*		b. Foreign aid approach
*		c. Environmental aid approach
*		d. Peer pressure approach
*	************************************************************************

stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stsum

stvary


*	************************************************************************
*	NEW TABLES
*	************************************************************************

eststo: logit env_ministryonset_realb demo_dummy3 ir9294 ir9294_x_demod3  gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
eststo: logit env_ministryonset_realb demo_dummy3 ir9295 ir9295_x_demod3  gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
eststo: logit env_ministryonset_realb demo_dummy3 ir9296 ir9296_x_demod3  gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
eststo: logit env_ministryonset_realb demo_dummy3 ir9297 ir9297_x_demod3  gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
esttab using "rrtable2.tex", replace booktabs b(3) se label star(* 0.10 ** 0.05 *** 0.01)  scalars("chi2 $\chi^2$" "N_sub N Subject" "N_fail N Failures") ///
title(International Pressure and Democratization: Rio and Beyond\label{rrtable2})
eststo clear

eststo: logit env_ministryonset_realb demo_dummy3 emn_av emnav_x_demodummy3 lowesst, cluster(ccode)
eststo: logit env_ministryonset_realb demo_dummy3 emn_av emnav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
eststo: logit env_ministryonset_realb demo_dummy3 emb_av embav_x_demodummy3 lowesst, cluster(ccode)
eststo: logit env_ministryonset_realb demo_dummy3 emb_av embav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
eststo: logit env_ministryonset_realb demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 lowesst, cluster(ccode)
eststo: logit env_ministryonset_realb demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
esttab using "rrtable3.tex", replace booktabs b(3) se label star(* 0.10 ** 0.05 *** 0.01)  scalars("chi2 $\chi^2$" "N_sub N Subject" "N_fail N Failures") ///
mtitle("Panel A: Env. Aid" "" "" "" "Panel B: Peer Pressure" "") nonumbers title(International Pressure and Democratization\label{rrtable3})
eststo clear


eststo: xtreg co2capita_cait6 env_ministry_real year, fe
eststo: xtreg co2capita_cait6 env_ministry_real year gdpcapk, fe
eststo: xtreg co2capita_cait6 env_ministry_real year gdpcapk pop_density_wdi openk service1 oecd_real polity2 ir9294, fe
eststo: xtreg co2capita_cait6 env_ministry_real gdpcapk pop_density_wdi openk service1 oecd_real polity2 ir9294 yd*, fe

esttab using "rrtable4.tex", replace booktabs b(3) se label star(* 0.10 ** 0.05 *** 0.01) ///
mtitle("FE" "FE" "FE" "FE+Year FE" "FE") nonumbers title(Environmental Ministries and Carbon Dioxide\label{rrtable4})
eststo clear

eststo: xtreg soxcapita env_ministry_real year, fe
eststo: xtreg soxcapita env_ministry_real year gdpcapk, fe
eststo: xtreg soxcapita env_ministry_real year gdpcapk pop_density_wdi openk service1 oecd_real polity2 ir9294, fe
eststo: xtreg soxcapita env_ministry_real gdpcapk pop_density_wdi openk service1 oecd_real polity2 ir9294 yd*, fe

esttab using "rrtable5.tex", replace booktabs b(3) se label star(* 0.10 ** 0.05 *** 0.01) ///
mtitle("FE" "FE" "FE" "FE+Year FE" "FE") nonumbers title(Environmental Ministries and SOx\label{rrtable5})
eststo clear


eststo: xtreg envtreaty_sum_bernauer env_ministry_real year, fe
eststo: xtreg envtreaty_sum_bernauer env_ministry_real year gdpcapk, fe
eststo: xtreg envtreaty_sum_bernauer env_ministry_real year gdpcapk pop_density_wdi openk service1 oecd_real polity2 ir9294, fe
eststo: xtreg envtreaty_sum_bernauer env_ministry_real gdpcapk pop_density_wdi openk service1 oecd_real polity2 ir9294 yd*, fe

esttab using "rrtable6.tex", replace booktabs b(3) se label star(* 0.10 ** 0.05 *** 0.01) ///
nonumbers title(Environmental Ministries and International Env. Treaties\label{rrtable6})
eststo clear




*	************************************************************************
*	a. Rio Approach
*		i. 		Model without any IR influence
*		ii. 	Model with IR (for various years)
*		iii. 	Model for OECD and non-OECD countries
*		iv. 	Model with IR*Democratization interaction (for various years)
*	************************************************************************


*	************************************************************************
*		i. Model without any IR influence
*	************************************************************************
eststo: streg demo_dummy3 ir9294 gdpcapk, nohr distribution(weibull)
di 100*(exp(_b[demo_dummy3])-1)
di 100*(exp(_b[ir9294])-1)
eststo: streg demo_dummy3 ir9294 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
esttab using "table2.tex", replace booktabs se(3) b(3) label star(* 0.10 ** 0.05 *** 0.01)  scalars("chi2 $\chi^2$" "N_sub N Subject" "N_fail N Failures") ///
title(Domestic Factors\label{table2}) mtitles("Basic" "Basic +")

eststo clear

*	************************************************************************
*		ii. Model with IR dummy (for various years)
*	************************************************************************

eststo: streg demo_dummy3 ir9294 ir9294_x_demod3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
eststo: streg demo_dummy3 ir9295 ir9295_x_demod3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
eststo: streg demo_dummy3 ir9296 ir9296_x_demod3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
eststo: streg demo_dummy3 ir9297 ir9297_x_demod3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)

esttab using "table3.tex", replace booktabs b(3) se label star(* 0.10 ** 0.05 *** 0.01) scalars("chi2 $\chi^2$" "N_sub N Subject" "N_fail N Failures") ///
mtitles("Rio" "Rio+" "Rio ++" "Rio to Kyoto") title(Survival Model -- International Pressure\label{table3})
eststo clear


* Predictions using model 1 (all variables set at their median
streg demo_dummy3 ir9294 ir9294_x_demod3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)

* If pop_density_wdi goes from its mean to mean + 1 sd: 10 years shorter
di exp(lngamma(1+(1/e(aux_p))))*exp(-_b[_cons]/e(aux_p)-_b[demo_dummy3]/e(aux_p)*0-_b[ir9294]/e(aux_p)*0 - _b[ir9294_x_demod3]/e(aux_p)*0 - _b[gdpcapk]/e(aux_p)*3.907 - _b[pop_density_wdi]/e(aux_p)*131 - _b[openk]/e(aux_p)*58 - _b[service1]/e(aux_p)*67 - _b[oecd_real]/e(aux_p)*0)
di exp(lngamma(1+(1/e(aux_p))))*exp(-_b[_cons]/e(aux_p)-_b[demo_dummy3]/e(aux_p)*0-_b[ir9294]/e(aux_p)*0 - _b[ir9294_x_demod3]/e(aux_p)*0 - _b[gdpcapk]/e(aux_p)*3.907 - _b[pop_density_wdi]/e(aux_p)*710 - _b[openk]/e(aux_p)*58 - _b[service1]/e(aux_p)*67 - _b[oecd_real]/e(aux_p)*0)

* If a country is democratizing in 92-94: 20 years shorter
di exp(lngamma(1+(1/e(aux_p))))*exp(-_b[_cons]/e(aux_p)-_b[demo_dummy3]/e(aux_p)*0-_b[ir9294]/e(aux_p)*0 - _b[ir9294_x_demod3]/e(aux_p)*0 - _b[gdpcapk]/e(aux_p)*3.907 - _b[pop_density_wdi]/e(aux_p)*131 - _b[openk]/e(aux_p)*58 - _b[service1]/e(aux_p)*67 - _b[oecd_real]/e(aux_p)*0)
di exp(lngamma(1+(1/e(aux_p))))*exp(-_b[_cons]/e(aux_p)-_b[demo_dummy3]/e(aux_p)*1-_b[ir9294]/e(aux_p)*1 - _b[ir9294_x_demod3]/e(aux_p)*1 - _b[gdpcapk]/e(aux_p)*3.907 - _b[pop_density_wdi]/e(aux_p)*131 - _b[openk]/e(aux_p)*58 - _b[service1]/e(aux_p)*67 - _b[oecd_real]/e(aux_p)*0)


*	************************************************************************
*		iv. Model with environmental aid 
*	************************************************************************

stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
eststo: stcox demo_dummy3 emb_av embav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr efron
eststo: streg demo_dummy3 emb_av embav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
eststo: logit env_ministryonset_realb demo_dummy3 emb_av embav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
eststo: logit env_ministryonset_realb demo_dummy3 emb_av embav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
eststo: logit env_ministryonset_realb demo_dummy3 emb_av embav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)

esttab using "table5.tex", replace booktabs b(3) se label star(* 0.10 ** 0.05 *** 0.01)  scalars("chi2 $\chi^2$" "N_sub N Subject" "N_fail N Failures") ///
mtitles("Cox" "Weibull" "Logit Lowess" "Logit Log" "Logit Square") title(Env. Aid (broad) and Democratization\label{table5})
eststo clear

*	Estimating the effect of a change in covariates:
streg demo_dummy3 emb_av embav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)

* Pop density
di exp(lngamma(1+(1/e(aux_p))))*exp(-_b[_cons]/e(aux_p)-_b[demo_dummy3]/e(aux_p)*0-_b[emb_av]/e(aux_p)*8.55 - _b[embav_x_demodummy3]/e(aux_p)*0 - _b[gdpcapk]/e(aux_p)*3.907 - _b[pop_density_wdi]/e(aux_p)*131 - _b[openk]/e(aux_p)*58 - _b[service1]/e(aux_p)*67 - _b[oecd_real]/e(aux_p)*0)
di exp(lngamma(1+(1/e(aux_p))))*exp(-_b[_cons]/e(aux_p)-_b[demo_dummy3]/e(aux_p)*0-_b[emb_av]/e(aux_p)*8.55 - _b[embav_x_demodummy3]/e(aux_p)*0 - _b[gdpcapk]/e(aux_p)*3.907 - _b[pop_density_wdi]/e(aux_p)* 710 - _b[openk]/e(aux_p)*58 - _b[service1]/e(aux_p)*67 - _b[oecd_real]/e(aux_p)*0)

* Env. Aid
di exp(lngamma(1+(1/e(aux_p))))*exp(-_b[_cons]/e(aux_p)-_b[demo_dummy3]/e(aux_p)*0-_b[emb_av]/e(aux_p)*8.55 - _b[embav_x_demodummy3]/e(aux_p)*0 - _b[gdpcapk]/e(aux_p)*3.907 - _b[pop_density_wdi]/e(aux_p)*131 - _b[openk]/e(aux_p)*58 - _b[service1]/e(aux_p)*67 - _b[oecd_real]/e(aux_p)*0)
di exp(lngamma(1+(1/e(aux_p))))*exp(-_b[_cons]/e(aux_p)-_b[demo_dummy3]/e(aux_p)*1-_b[emb_av]/e(aux_p)*43.19 - _b[embav_x_demodummy3]/e(aux_p)*43.19 - _b[gdpcapk]/e(aux_p)*3.907 - _b[pop_density_wdi]/e(aux_p)*131 - _b[openk]/e(aux_p)*58 - _b[service1]/e(aux_p)*67 - _b[oecd_real]/e(aux_p)*0)



stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
eststo: stcox demo_dummy3 emn_av emnav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr efron
eststo: streg demo_dummy3 emn_av emnav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
eststo: logit env_ministryonset_realb demo_dummy3 emn_av emnav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
eststo: logit env_ministryonset_realb demo_dummy3 emn_av emnav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
eststo: logit env_ministryonset_realb demo_dummy3 emn_av emnav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)

esttab using "table6.tex", replace booktabs b(3) se label star(* 0.10 ** 0.05 *** 0.01)  scalars("chi2 $\chi^2$" "N_sub N Subject" "N_fail N Failures") ///
mtitles("Cox" "Weibull" "Logit Lowess" "Logit Log" "Logit Square") title(Env. Aid (narrow) and Democratization\label{table6})
eststo clear


*	************************************************************************
*		v. Model with peer pressure 
*			1. Global peer pressure
*			2. Regional peer pressure
*	************************************************************************

*	* 1. Global peer pressure
stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
eststo: streg demo_dummy3 lsumm lsumm_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
eststo: logit env_ministryonset_realb demo_dummy3 lsumm lsumm_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
eststo: logit env_ministryonset_realb demo_dummy3 lsumm lsumm_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
eststo: logit env_ministryonset_realb demo_dummy3 lsumm lsumm_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)
esttab using "table7.tex", replace booktabs b(3) se label star(* 0.10 ** 0.05 *** 0.01)  scalars("chi2 $\chi^2$" "N_sub N Subject" "N_fail N Failures") ///
mtitles("Weibull" "Logit Lowess" "Logit Log" "Logit Square") title(Peer Pressure and Democratization\label{table7})
eststo clear

*	* 2. Continental/regional peer pressure
stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
eststo: stcox demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr efron
eststo: streg demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
eststo: logit env_ministryonset_realb demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
eststo: logit env_ministryonset_realb demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
eststo: logit env_ministryonset_realb demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)
esttab using "table8.tex", replace booktabs b(3) se label star(* 0.10 ** 0.05 *** 0.01)  scalars("chi2 $\chi^2$" "N_sub N Subject" "N_fail N Failures") ///
mtitles("Cox" "Weibull" "Logit Lowess" "Logit Log" "Logit Square") title(Regional Peer Pressure and Democratization\label{table8})
eststo clear



*	Estimating the effect of a change in covariates:
streg demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)

* Pop density
di exp(lngamma(1+(1/e(aux_p))))*exp(-_b[_cons]/e(aux_p)-_b[demo_dummy3]/e(aux_p)*0-_b[regional_proportion_envministry]/e(aux_p)*19.2 - _b[regionalpe_x_demodummy3]/e(aux_p)*0 - _b[gdpcapk]/e(aux_p)*3.907 - _b[pop_density_wdi]/e(aux_p)*131 - _b[openk]/e(aux_p)*58 - _b[service1]/e(aux_p)*67 - _b[oecd_real]/e(aux_p)*0)
di exp(lngamma(1+(1/e(aux_p))))*exp(-_b[_cons]/e(aux_p)-_b[demo_dummy3]/e(aux_p)*0-_b[regional_proportion_envministry]/e(aux_p)*19.2 - _b[regionalpe_x_demodummy3]/e(aux_p)*0 - _b[gdpcapk]/e(aux_p)*3.907 - _b[pop_density_wdi]/e(aux_p)*710 - _b[openk]/e(aux_p)*58 - _b[service1]/e(aux_p)*67 - _b[oecd_real]/e(aux_p)*0)

* Env. Aid
di exp(lngamma(1+(1/e(aux_p))))*exp(-_b[_cons]/e(aux_p)-_b[demo_dummy3]/e(aux_p)*0-_b[regional_proportion_envministry]/e(aux_p)*19.2 - _b[regionalpe_x_demodummy3]/e(aux_p)*0 - _b[gdpcapk]/e(aux_p)*3.907 - _b[pop_density_wdi]/e(aux_p)*131 - _b[openk]/e(aux_p)*58 - _b[service1]/e(aux_p)*67 - _b[oecd_real]/e(aux_p)*0)
di exp(lngamma(1+(1/e(aux_p))))*exp(-_b[_cons]/e(aux_p)-_b[demo_dummy3]/e(aux_p)*1-_b[regional_proportion_envministry]/e(aux_p)*40.85 - _b[regionalpe_x_demodummy3]/e(aux_p)*40.85 - _b[gdpcapk]/e(aux_p)*3.907 - _b[pop_density_wdi]/e(aux_p)*131 - _b[openk]/e(aux_p)*58 - _b[service1]/e(aux_p)*67 - _b[oecd_real]/e(aux_p)*0)


stop


*	************************************************************************
*	4. Tests
*		i. Proportionality test. All Cox models presented above satisfy
*			the proportinonality test at conventional levels. 
*	************************************************************************

*	************************************************************************
*		i. Proportionality test. Null hypothesis: proportionality
*	************************************************************************
stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)

stcox demo_dummy3 aid_capita_wdi aidcap_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr
estat phtest, detail

stcox demo_dummy3 emb_av embav_x_demodummy3 gdpcapk service1 openk pop_density_wdi, nohr
estat phtest, detail

stcox demo_dummy3 emn_av emnav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr
estat phtest, detail


*	************************************************************************
* 	5. References for comments in text
*	************************************************************************

*	Policies (Bernauer): countries with env. ministries have more ratified 
*	treaties in any given year. 
sum envtreaty_sum_bernauer if env_ministry_real == 1 & year == 1980
sum envtreaty_sum_bernauer if env_ministry_real == 0 & year == 1980

sum envtreaty_sum_bernauer if env_ministry_real == 1 & year == 1990
sum envtreaty_sum_bernauer if env_ministry_real == 0 & year == 1990

sum envtreaty_sum_bernauer if env_ministry_real == 1 & year == 2000
sum envtreaty_sum_bernauer if env_ministry_real == 0 & year == 2000

*	Policies (Holzinger): countries wi
sum policy_sum_holzinger if env_ministry_real == 1 & year == 1980
sum policy_sum_holzinger if env_ministry_real == 0 & year == 1980

sum policy_sum_holzinger if env_ministry_real == 1 & year == 1990
sum policy_sum_holzinger if env_ministry_real == 0 & year == 1990

sum policy_sum_holzinger if env_ministry_real == 1 & year == 2000
sum policy_sum_holzinger if env_ministry_real == 0 & year == 2000

*	Related to Graph 1: the claim that the correlation between democracies 
*	and ministries is equal to over .9
corr sum_dem sum_ministries if year<2008

*	* Correlation of service sector and economy
cor gdpcapk service1

*	* Correlation of income and pop density
cor gdpcapk pop_density_wdi

*	* Correlation two versions of environmental aid
cor emb_av emn_av

*	* Claim that it increases the probability by >2/3
logit env_ministryonset_realb democratization5 emn_av emnav_x_democratization gdpcapk service1 openk pop_density_wdi lowesst, cluster(ccode)
gen x_betahat0 = _b[democratization5]*0 + _b[emn_av]*1596 + _b[emnav_x_democratization]*0+ _b[gdpcapk]*7.19 + _b[service1]*65.62 + _b[openk]*70.56 + _b[pop_density_wdi]*131.53 + _b[lowesst]*0.02 + _b[_cons]
gen x_betahat1 = _b[democratization5]*5 + _b[emn_av]*1596 + _b[emnav_x_democratization]*5*1596 + _b[gdpcapk]*7.19 + _b[service1]*65.62 + _b[openk]*70.56 + _b[pop_density_wdi]*131.53 + _b[lowesst]*0.02 + _b[_cons]

gen prob0=exp(x_betahat0)/(1 + exp(x_betahat0))
gen prob1=exp(x_betahat1)/(1 + exp(x_betahat1))
di (prob0/prob1)
drop x_betahat0 x_betahat1 prob0 prob1

*	* References for Table on share of democracies and autocracies that
*		have environmental ministries
* Democracies: Nbr of democracies & Nbr of democracies with ministry:
sum env_ministry_real if year == 1975 & polity2 >= 6 & polity2 != .
sum env_ministry_real if year == 1975 & polity2 >= 6 & polity2 != . & env_ministry_real == 1
di 10/36

sum env_ministry_real if year == 1985 & polity2 >= 6 & polity2 != .
sum env_ministry_real if year == 1985 & polity2 >= 6 & polity2 != . & env_ministry_real == 1
di 17/44

sum env_ministry_real if year == 1995 & polity2 >= 6 & polity2 != .
sum env_ministry_real if year == 1995 & polity2 >= 6 & polity2 != . & env_ministry_real == 1
di 57/76

sum env_ministry_real if year == 2000 & polity2 >= 6 & polity2 != .
sum env_ministry_real if year == 2000 & polity2 >= 6 & polity2 != . & env_ministry_real == 1
di 66/80

* Autocracies: Nbr of democracies & Nbr of democracies with ministry:
sum env_ministry_real if year == 1975 & polity2 < 6 & polity2 != .
sum env_ministry_real if year == 1975 & polity2 < 6 & polity2 != . & env_ministry_real == 1
di 5/102

sum env_ministry_real if year == 1985 & polity2 < 6 & polity2 != .
sum env_ministry_real if year == 1985 & polity2 < 6 & polity2 != . & env_ministry_real == 1
di 14/93

sum env_ministry_real if year == 1995 & polity2 < 6 & polity2 != .
sum env_ministry_real if year == 1995 & polity2 < 6 & polity2 != . & env_ministry_real == 1
di 43/82

sum env_ministry_real if year == 2000 & polity2 < 6 & polity2 != .
sum env_ministry_real if year == 2000 & polity2 < 6 & polity2 != . & env_ministry_real == 1
di 46/78

* Total: Nbr of democracies & Nbr of democracies with ministry:
sum env_ministry_real if year == 1975 & env_ministry_real != .
sum env_ministry_real if year == 1975 & env_ministry_real == 1
di 15/195

sum env_ministry_real if year == 1985 & env_ministry_real != .
sum env_ministry_real if year == 1985 & env_ministry_real == 1
di 32/195

sum env_ministry_real if year == 1995 & env_ministry_real != .
sum env_ministry_real if year == 1995 & env_ministry_real == 1
di 106/195

sum env_ministry_real if year == 2000 & env_ministry_real != .
sum env_ministry_real if year == 2000  & env_ministry_real == 1
di 119/195


*	* Marginal effects Table
* 	Rio
stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
streg demo_dummy3 ir9294 ir9294_x_demod3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
matrix V=e(V)
scalar varb1=V[1,1]
scalar varb2=V[2,2]
scalar varb3=V[3,3]
scalar covb1b3=V[1,3]
scalar covb2b3=V[2,3]

* Demo
di _b[demo_dummy3] 
di _b[demo_dummy3] - 1.96*sqrt(varb1)
di _b[demo_dummy3] + 1.96*sqrt(varb1)

* IR
di _b[ir9294] 
di _b[ir9294] - 1.96*sqrt(varb2)
di _b[ir9294] + 1.96*sqrt(varb2)

* Demo IR
di _b[demo_dummy3] + _b[ir9294_x_demod3]
di _b[demo_dummy3] + _b[ir9294_x_demod3] - 1.96*sqrt(varb1 + varb3 + 2*covb1b3)
di _b[demo_dummy3] + _b[ir9294_x_demod3] + 1.96*sqrt(varb1 + varb3 + 2*covb1b3)

* IR Demo
di _b[ir9294] + _b[ir9294_x_demod3]
di _b[ir9294] + _b[ir9294_x_demod3] - 1.96*sqrt(varb2 + varb3 + 2*covb2b3)
di _b[ir9294] + _b[ir9294_x_demod3] + 1.96*sqrt(varb2 + varb3 + 2*covb2b3)


* 	Env. Aid.

logit env_ministryonset_realb demo_dummy3 emb_av embav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
matrix V=e(V)
scalar varb1=V[1,1]
scalar varb2=V[2,2]
scalar varb3=V[3,3]
scalar covb1b3=V[1,3]
scalar covb2b3=V[2,3]

sum emb_av, detail

* Demo
di _b[demo_dummy3] 
di _b[demo_dummy3] - 1.96*sqrt(varb1)
di _b[demo_dummy3] + 1.96*sqrt(varb1)

* IR
di _b[emb_av] 
di _b[emb_av] - 1.96*sqrt(varb2)
di _b[emb_av] + 1.96*sqrt(varb2)

* Demo IR (75th percentile)
di _b[demo_dummy3] + 0.886*_b[embav_x_demodummy3]
di _b[demo_dummy3] + 0.886*_b[embav_x_demodummy3] - 1.96*sqrt(varb1 + 0.886^2*varb3 + 2*0.886*covb1b3)
di _b[demo_dummy3] + 0.886*_b[embav_x_demodummy3] + 1.96*sqrt(varb1 + 0.886^2*varb3 + 2*0.886*covb1b3)

* Demo IR (95th percentile)
di _b[demo_dummy3] + 42.89*_b[embav_x_demodummy3]
di _b[demo_dummy3] + 42.89*_b[embav_x_demodummy3] - 1.96*sqrt(varb1 + 42.89^2*varb3 + 2*42.89*covb1b3)
di _b[demo_dummy3] + 42.89*_b[embav_x_demodummy3] + 1.96*sqrt(varb1 + 42.89^2*varb3 + 2*42.89*covb1b3)

* Demo IR (99th percentile)
di _b[demo_dummy3] + 156.34*_b[embav_x_demodummy3]
di _b[demo_dummy3] + 156.34*_b[embav_x_demodummy3] - 1.96*sqrt(varb1 + 156.34^2*varb3 + 2*156.34*covb1b3)
di _b[demo_dummy3] + 156.34*_b[embav_x_demodummy3] + 1.96*sqrt(varb1 + 156.34^2*varb3 + 2*156.34*covb1b3

* IR Demo
di _b[emb_av] + _b[embav_x_demodummy3]
di _b[emb_av] + _b[embav_x_demodummy3] - 1.96*sqrt(varb2 + varb3 + 2*covb2b3)
di _b[emb_av] + _b[embav_x_demodummy3] + 1.96*sqrt(varb2 + varb3 + 2*covb2b3)



* 	Regional peer pressure

logit env_ministryonset_realb demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
matrix V=e(V)
scalar varb1=V[1,1]
scalar varb2=V[2,2]
scalar varb3=V[3,3]
scalar covb1b3=V[1,3]
scalar covb2b3=V[2,3]

sum regional_proportion_envministry, detail


* Demo
di _b[demo_dummy3] 
di _b[demo_dummy3] - 1.96*sqrt(varb1)
di _b[demo_dummy3] + 1.96*sqrt(varb1)

* IR
di _b[regional_proportion_envministry] 
di _b[regional_proportion_envministry] - 1.96*sqrt(varb2)
di _b[regional_proportion_envministry] + 1.96*sqrt(varb2)

* Demo IR (50th percentile)
di _b[demo_dummy3] + 10.71*_b[regionalpe_x_demodummy3]
di _b[demo_dummy3] + 10.71*_b[regionalpe_x_demodummy3] - 1.96*sqrt(varb1 + 10.71^2*varb3 + 2*10.71*covb1b3)
di _b[demo_dummy3] + 10.71*_b[regionalpe_x_demodummy3] + 1.96*sqrt(varb1 + 10.71^2*varb3 + 2*10.71*covb1b3)

* Demo IR (75th percentile)
di _b[demo_dummy3] + 31.25*_b[regionalpe_x_demodummy3]
di _b[demo_dummy3] + 31.25*_b[regionalpe_x_demodummy3] - 1.96*sqrt(varb1 + 31.25^2*varb3 + 2*31.25*covb1b3)
di _b[demo_dummy3] + 31.25*_b[regionalpe_x_demodummy3] + 1.96*sqrt(varb1 + 31.25^2*varb3 + 2*31.25*covb1b3)

* Demo IR (95th percentile)
di _b[demo_dummy3] + 60.71*_b[regionalpe_x_demodummy3]
di _b[demo_dummy3] + 60.71*_b[regionalpe_x_demodummy3] - 1.96*sqrt(varb1 + 60.71^2*varb3 + 2*60.71*covb1b3)
di _b[demo_dummy3] + 60.71*_b[regionalpe_x_demodummy3] + 1.96*sqrt(varb1 + 60.71^2*varb3 + 2*60.71*covb1b3)

* IR Demo
di _b[regional_proportion_envministry] + _b[regionalpe_x_demodummy3]
di _b[regional_proportion_envministry] + _b[regionalpe_x_demodummy3] - 1.96*sqrt(varb2 + varb3 + 2*covb2b3)
di _b[regional_proportion_envministry] + _b[regionalpe_x_demodummy3] + 1.96*sqrt(varb2 + varb3 + 2*covb2b3)


*	************************************************************************
* 	6. Graphs
*	************************************************************************

*	* Graph 1: cumulative ministries (year before 2008 to match existing data on 
*		democracies)
preserve
tsset ccode year, yearly
twoway (tsline sum_ministries) if year<2008, title("Environmental Ministries", size(4))
graph export "graph1.pdf", replace


*	* Graph 2: Cumulative ministries and democracies (year before 2008 to match existing data on 
*		democracies)
preserve
tsset ccode year, yearly
graph twoway (tsline sum_dem, clpattern(dash)) (tsline sum_ministries) if year<2008, title("Democracies and Environmental Ministries", size(4)) graphregion(fcolor(white))
graph export "graph2.pdf", replace


*	* Graph 3: Nelson-Aalen
stset year, id(ctry_prefname) failure(env_ministryonset_realb==1)
sts graph if year < 2008, na title("Nelson-Aalen Cumulative Hazard Estimate")
graph export "graph3.pdf", replace



*	************************************************************************
* 	B. Simulations. Based on Brambor et al (2006)'s code.
*	************************************************************************

*	************************************************************************
* 	i. a) Simulation for IR (92-94)
*	************************************************************************

xtset ccode year

*	1. Running the IR*democratization model. Notice that this is the same
*	model as in Table 3, Column 1, but run as a logit model with lowesst
*	taking into account time dependency.  
logit env_ministryonset_realb demo_dummy3 ir9294 ir9294_x_demod3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)

preserve
drawnorm MG_b1-MG_b10, n(1000) means(e(b)) cov(e(V)) clear
postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi using sim, replace

noisily display "start"

*	2. I put all variables at the mean, except for my indep. variable
*	of interest -demo_dummy- with will be moved from 0 to 1, and for OECD
*	which is here defined as a non-OECD country. 
local a = 0 
while `a' <= 1 {
{
scalar h_demo_dummy5 = 0
scalar h_gdpcapk = 7.193102
scalar h_pop_density_wdi = 131.5261
scalar h_openk = 70.55944
scalar h_service1 = 65.62408
scalar h_oecd_real = 0
scalar h_lowesst = .0166979
scalar h_constant = 1

*	3. We now look at the expected change in probability when
*	democratization shifts from 0 to 1.
generate x_betahat0 = MG_b1*h_demo_dummy5 + MG_b2*(`a') + MG_b3* h_demo_dummy5 *(`a') + MG_b4 * h_gdpcapk + MG_b5*h_pop_density_wdi + MG_b6*h_openk + MG_b7* h_service1 + MG_b8*h_oecd_real + MG_b9*h_lowesst + MG_b10*h_constant

generate x_betahat1 = MG_b1*(h_demo_dummy5+1) + MG_b2*(`a') + MG_b3*(h_demo_dummy5+1)*(`a') + MG_b4*h_gdpcapk + MG_b5*h_pop_density_wdi+ MG_b6*h_openk + MG_b7* h_service1 + MG_b8* h_oecd_real + MG_b9*h_lowesst + MG_b10*h_constant

gen prob0=exp(x_betahat0)/(1 + exp(x_betahat0))
gen prob1=exp(x_betahat1)/(1 + exp(x_betahat1))
gen diff=prob1-prob0

egen probhat0=mean(prob0)
egen probhat1=mean(prob1)
egen diffhat=mean(diff)

tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi

*	4. I now build the confidence intervals.
_pctile prob0, p(2.5,97.5)
scalar `lo0' = r(r1)
scalar `hi0' = r(r2)
_pctile prob1, p(2.5,97.5)
scalar `lo1'= r(r1)
scalar `hi1'= r(r2)

_pctile diff, p(2.5,97.5)
scalar `diff_lo'= r(r1)
scalar `diff_hi'= r(r2)

scalar `prob_hat0'=probhat0
scalar `prob_hat1'=probhat1
scalar `diff_hat'=diffhat

post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') (`diff_hat') (`diff_lo') (`diff_hi')}

drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat

*	5. This represents the jumb in the IR variable. 
local a = `a'+ 1
display "."	_c
}

display ""

postclose mypost

use sim, clear

gen MV = _n-1

graph twoway line diff_hat MV, clwidth(medium) clcolor(blue) clcolor(black) || line diff_lo MV, clpattern(dash) clwidth(thin) clcolor(black) || line diff_hi MV, clpattern(dash) clwidth(thin) clcolor(black) || ,  legend(off ) title("Marginal Effect of Democratization in 1992-94 or Other Years", size(3)) subtitle(" " "Dependent Variable: Environmental Ministry Creation" " ", size(3)) xtitle("Year 1992-1994", size(3.5) ) ytitle("Marginal Effect of Democratization", size(3.5)) xsca(titlegap(2)) ysca(titlegap(2)) scheme(s2mono) graphregion(fcolor(white)) name(ir94) xlabel(0(1)1) xmtick(0(1)1)
graph export "marginal_ir.pdf", replace

restore

*	************************************************************************
* 	i. b) Simulation for IR (92-95)
*	************************************************************************

xtset ccode year

*	1. Running the IR*democratization model. Notice that this is the same
*	model as in Table 3, Column 1, but run as a logit model with lowesst
*	taking into account time dependency.  
logit env_ministryonset_realb demo_dummy3 ir9295 ir9295_x_demod3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)

preserve
drawnorm MG_b1-MG_b10, n(1000) means(e(b)) cov(e(V)) clear
postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi using sim, replace

noisily display "start"

*	2. I put all variables at the mean, except for my indep. variable
*	of interest -demo_dummy- with will be moved from 0 to 1, and for OECD
*	which is here defined as a non-OECD country. 
local a = 0 
while `a' <= 1 {
{
scalar h_demo_dummy5 = 0
scalar h_gdpcapk = 7.193102
scalar h_pop_density_wdi = 131.5261
scalar h_openk = 70.55944
scalar h_service1 = 65.62408
scalar h_oecd_real = 0
scalar h_lowesst = .0166979
scalar h_constant = 1

*	3. We now look at the expected change in probability when
*	democratization shifts from 0 to 1.
generate x_betahat0 = MG_b1*h_demo_dummy5 + MG_b2*(`a') + MG_b3* h_demo_dummy5 *(`a') + MG_b4 * h_gdpcapk + MG_b5*h_pop_density_wdi + MG_b6*h_openk + MG_b7* h_service1 + MG_b8*h_oecd_real + MG_b9*h_lowesst + MG_b10*h_constant

generate x_betahat1 = MG_b1*(h_demo_dummy5+1) + MG_b2*(`a') + MG_b3*(h_demo_dummy5+1)*(`a') + MG_b4*h_gdpcapk + MG_b5*h_pop_density_wdi+ MG_b6*h_openk + MG_b7* h_service1 + MG_b8* h_oecd_real + MG_b9*h_lowesst + MG_b10*h_constant

gen prob0=exp(x_betahat0)/(1 + exp(x_betahat0))
gen prob1=exp(x_betahat1)/(1 + exp(x_betahat1))
gen diff=prob1-prob0

egen probhat0=mean(prob0)
egen probhat1=mean(prob1)
egen diffhat=mean(diff)

tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi

*	4. I now build the confidence intervals.
_pctile prob0, p(2.5,97.5)
scalar `lo0' = r(r1)
scalar `hi0' = r(r2)
_pctile prob1, p(2.5,97.5)
scalar `lo1'= r(r1)
scalar `hi1'= r(r2)

_pctile diff, p(2.5,97.5)
scalar `diff_lo'= r(r1)
scalar `diff_hi'= r(r2)

scalar `prob_hat0'=probhat0
scalar `prob_hat1'=probhat1
scalar `diff_hat'=diffhat

post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') (`diff_hat') (`diff_lo') (`diff_hi')}
drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat

*	5. This represents the jumb in the IR variable. 
local a = `a'+ 1
display "."	_c
}

display ""

postclose mypost

use sim, clear

gen MV = _n-1

graph twoway line diff_hat MV, clwidth(medium) clcolor(blue) clcolor(black) || line diff_lo MV, clpattern(dash) clwidth(thin) clcolor(black) || line diff_hi MV, clpattern(dash) clwidth(thin) clcolor(black) || ,  legend(off ) title("Marginal Effect of Democratization in 1992-95 or Other Years", size(3)) subtitle(" " "Dependent Variable: Environmental Ministry Creation" " ", size(3)) xtitle("Year 1992-1995", size(3.5) ) ytitle("Marginal Effect of Democratization", size(3.5)) xsca(titlegap(2)) ysca(titlegap(2)) scheme(s2mono) graphregion(fcolor(white)) name(ir95) xlabel(0(1)1) xmtick(0(1)1) 
graph export "marginal_ir2.pdf", replace

restore


*	************************************************************************
* 	i. c) Simulation for IR (92-96)
*	************************************************************************

xtset ccode year

*	1. Running the IR*democratization model. Notice that this is the same
*	model as in Table 3, Column 1, but run as a logit model with lowesst
*	taking into account time dependency.  
logit env_ministryonset_realb demo_dummy3 ir9296 ir9296_x_demod3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)

preserve
drawnorm MG_b1-MG_b10, n(1000) means(e(b)) cov(e(V)) clear
postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi using sim, replace

noisily display "start"

*	2. I put all variables at the mean, except for my indep. variable
*	of interest -demo_dummy- with will be moved from 0 to 1, and for OECD
*	which is here defined as a non-OECD country. 
local a = 0 
while `a' <= 1 {
{
scalar h_demo_dummy3 = 0
scalar h_gdpcapk = 7.193102
scalar h_pop_density_wdi = 131.5261
scalar h_openk = 70.55944
scalar h_service1 = 65.62408
scalar h_oecd_real = 0
scalar h_lowesst = .0166979
scalar h_constant = 1

*	3. We now look at the expected change in probability when
*	democratization shifts from 0 to 1.
generate x_betahat0 = MG_b1*h_demo_dummy3 + MG_b2*(`a') + MG_b3* h_demo_dummy3 *(`a') + MG_b4 * h_gdpcapk + MG_b5*h_pop_density_wdi + MG_b6*h_openk + MG_b7* h_service1 + MG_b8*h_oecd_real + MG_b9*h_lowesst + MG_b10*h_constant

generate x_betahat1 = MG_b1*(h_demo_dummy3+1) + MG_b2*(`a') + MG_b3*(h_demo_dummy3+1)*(`a') + MG_b4*h_gdpcapk + MG_b5*h_pop_density_wdi+ MG_b6*h_openk + MG_b7* h_service1 + MG_b8* h_oecd_real + MG_b9*h_lowesst + MG_b10*h_constant

gen prob0=exp(x_betahat0)/(1 + exp(x_betahat0))
gen prob1=exp(x_betahat1)/(1 + exp(x_betahat1))
gen diff=prob1-prob0

egen probhat0=mean(prob0)
egen probhat1=mean(prob1)
egen diffhat=mean(diff)

tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi

*	4. I now build the confidence intervals.
_pctile prob0, p(2.5,97.5)
scalar `lo0' = r(r1)
scalar `hi0' = r(r2)
_pctile prob1, p(2.5,97.5)
scalar `lo1'= r(r1)
scalar `hi1'= r(r2)

_pctile diff, p(2.5,97.5)
scalar `diff_lo'= r(r1)
scalar `diff_hi'= r(r2)

scalar `prob_hat0'=probhat0
scalar `prob_hat1'=probhat1
scalar `diff_hat'=diffhat

post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') (`diff_hat') (`diff_lo') (`diff_hi')}
drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat

*	5. This represents the jumb in the IR variable. 
local a = `a'+ 1
display "."	_c
}

display ""

postclose mypost

use sim, clear

gen MV = _n-1

graph twoway line diff_hat MV, clwidth(medium) clcolor(blue) clcolor(black) || line diff_lo MV, clpattern(dash) clwidth(thin) clcolor(black) || line diff_hi MV, clpattern(dash) clwidth(thin) clcolor(black) || ,  legend(off ) title("Marginal Effect of Democratization in 1992-96 or Other Years", size(3)) subtitle(" " "Dependent Variable: Environmental Ministry Creation" " ", size(3)) xtitle("Year 1992-1996", size(3.5) ) ytitle("Marginal Effect of Democratization", size(3.5)) xsca(titlegap(2)) ysca(titlegap(2)) scheme(s2mono) graphregion(fcolor(white)) name(ir96) xlabel(0(1)1) xmtick(0(1)1)
graph export "marginal_ir3.pdf", replace

restore


*	************************************************************************
* 	i. b) Simulation for IR (92-97)
*	************************************************************************

xtset ccode year

*	1. Running the IR*democratization model. Notice that this is the same
*	model as in Table 3, Column 1, but run as a logit model with lowesst
*	taking into account time dependency.  
logit env_ministryonset_realb demo_dummy3 ir9297 ir9297_x_demod3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)

preserve
drawnorm MG_b1-MG_b10, n(1000) means(e(b)) cov(e(V)) clear
postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi using sim, replace

noisily display "start"

*	2. I put all variables at the mean, except for my indep. variable
*	of interest -demo_dummy- with will be moved from 0 to 1, and for OECD
*	which is here defined as a non-OECD country. 
local a = 0 
while `a' <= 1 {
{
scalar h_demo_dummy3 = 0
scalar h_gdpcapk = 7.193102
scalar h_pop_density_wdi = 131.5261
scalar h_openk = 70.55944
scalar h_service1 = 65.62408
scalar h_oecd_real = 0
scalar h_lowesst = .0166979
scalar h_constant = 1

*	3. We now look at the expected change in probability when
*	democratization shifts from 0 to 1.
generate x_betahat0 = MG_b1*h_demo_dummy3 + MG_b2*(`a') + MG_b3* h_demo_dummy3 *(`a') + MG_b4 * h_gdpcapk + MG_b5*h_pop_density_wdi + MG_b6*h_openk + MG_b7* h_service1 + MG_b8*h_oecd_real + MG_b9*h_lowesst + MG_b10*h_constant

generate x_betahat1 = MG_b1*(h_demo_dummy3+1) + MG_b2*(`a') + MG_b3*(h_demo_dummy3+1)*(`a') + MG_b4*h_gdpcapk + MG_b5*h_pop_density_wdi+ MG_b6*h_openk + MG_b7* h_service1 + MG_b8* h_oecd_real + MG_b9*h_lowesst + MG_b10*h_constant

gen prob0=exp(x_betahat0)/(1 + exp(x_betahat0))
gen prob1=exp(x_betahat1)/(1 + exp(x_betahat1))
gen diff=prob1-prob0

egen probhat0=mean(prob0)
egen probhat1=mean(prob1)
egen diffhat=mean(diff)

tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi

*	4. I now build the confidence intervals.
_pctile prob0, p(2.5,97.5)
scalar `lo0' = r(r1)
scalar `hi0' = r(r2)
_pctile prob1, p(2.5,97.5)
scalar `lo1'= r(r1)
scalar `hi1'= r(r2)

_pctile diff, p(2.5,97.5)
scalar `diff_lo'= r(r1)
scalar `diff_hi'= r(r2)

scalar `prob_hat0'=probhat0
scalar `prob_hat1'=probhat1
scalar `diff_hat'=diffhat

post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') (`diff_hat') (`diff_lo') (`diff_hi')}
drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat

*	5. This represents the jumb in the IR variable. 
local a = `a'+ 1
display "."	_c
}

display ""

postclose mypost

use sim, clear

gen MV = _n-1

graph twoway line diff_hat MV, clwidth(medium) clcolor(blue) clcolor(black) || line diff_lo MV, clpattern(dash) clwidth(thin) clcolor(black) || line diff_hi MV, clpattern(dash) clwidth(thin) clcolor(black) || ,  legend(off ) title("Marginal Effect of Democratization in 1992-97 or Other Years", size(3)) subtitle(" " "Dependent Variable: Environmental Ministry Creation" " ", size(3)) xtitle("Year 1992-1997", size(3.5) ) ytitle("Marginal Effect of Democratization", size(3.5)) xsca(titlegap(2)) ysca(titlegap(2)) scheme(s2mono) graphregion(fcolor(white)) name(ir97) xlabel(0(1)1) xmtick(0(1)1)
graph export "marginal_ir4.pdf", replace

restore

graph combine ir94 ir95 ir96 ir97
graph export "marginal_irmulti.pdf", replace




*	************************************************************************
* 	ii. Simulation for Environmental Aid (broad)
*	************************************************************************

xtset ccode year

*	1. Running the IR*democratization model. Notice that this is the same
*	model as in Table 3, Column 1, but run as a logit model with lowesst
*	taking into account time dependency.  
logit env_ministryonset_realb demo_dummy3 emb_av embav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)

preserve
drawnorm MG_b1-MG_b10, n(1000) means(e(b)) cov(e(V)) clear
postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi using sim, replace

noisily display "start"

*	2. I put all variables at the mean, except for my indep. variable
*	of interest -demo_dummy- with will be moved from 0 to 1, and for OECD
*	which is here defined as a non-OECD country. 
*	Notice that "a" below represents the range of values for the IR 
*	variable.
local a = 0 
while `a' <= 655.100 {
{
scalar h_demo_dummy3 = 0
scalar h_gdpcapk = 7.193102
scalar h_pop_density_wdi = 131.5261
scalar h_openk = 70.55944
scalar h_service1 = 65.62408
scalar h_oecd_real = 0
scalar h_lowesst = .0166979
scalar h_constant = 1

*	3. We now look at the expected change in probability when
*	democratization shifts from 0 to 1.
generate x_betahat0 = MG_b1*h_demo_dummy3 + MG_b2*(`a') + MG_b3* h_demo_dummy3 *(`a') + MG_b4 * h_gdpcapk + MG_b5*h_pop_density_wdi + MG_b6*h_openk + MG_b7* h_service1 + MG_b8*h_oecd_real + MG_b9*h_lowesst + MG_b10*h_constant

generate x_betahat1 = MG_b1*(h_demo_dummy3+1) + MG_b2*(`a') + MG_b3*(h_demo_dummy3+1)*(`a') + MG_b4*h_gdpcapk + MG_b5*h_pop_density_wdi+ MG_b6*h_openk + MG_b7* h_service1 + MG_b8* h_oecd_real + MG_b9*h_lowesst + MG_b10*h_constant

gen prob0=exp(x_betahat0)/(1 + exp(x_betahat0))
gen prob1=exp(x_betahat1)/(1 + exp(x_betahat1))
gen diff=prob1-prob0

egen probhat0=mean(prob0)
egen probhat1=mean(prob1)
egen diffhat=mean(diff)

tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi

*	4. I now build the confidence intervals.
_pctile prob0, p(2.5,97.5)
scalar `lo0' = r(r1)
scalar `hi0' = r(r2)
_pctile prob1, p(2.5,97.5)
scalar `lo1'= r(r1)
scalar `hi1'= r(r2)

_pctile diff, p(2.5,97.5)
scalar `diff_lo'= r(r1)
scalar `diff_hi'= r(r2)

scalar `prob_hat0'=probhat0
scalar `prob_hat1'=probhat1
scalar `diff_hat'=diffhat

post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') (`diff_hat') (`diff_lo') (`diff_hi')}
drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat

*	5. This represents the jumb in the IR variable. 
local a = `a'+ 1
display "."	_c
}

display ""

postclose mypost

use sim, clear

gen MV = _n-1

graph twoway line diff_hat MV, clwidth(medium) clcolor(blue) clcolor(black) || line diff_lo MV, clpattern(dash) clwidth(thin) clcolor(black) || line diff_hi MV, clpattern(dash) clwidth(thin) clcolor(black) || ,  legend(off ) title("Marg. Effect of Democratization on Env. Ministry As Env. Aid (broad) Changes", size(3)) subtitle(" " "Dependent Variable: Environmental Ministry Creation" " ", size(3)) xtitle("Environmental Aid (broad) (m$)", size(3.5) ) ytitle("Marginal Effect of Democratization", size(3.5)) xsca(titlegap(2)) ysca(titlegap(2)) scheme(s2mono) graphregion(fcolor(white))   
graph export "marginal_emb.pdf", replace

restore



*	************************************************************************
* 	iii. Simulation for Environmental Aid (narrow)
*	************************************************************************

xtset ccode year

*	1. Running the IR*democratization model. Notice that this is the same
*	model as in Table 3, Column 1, but run as a logit model with lowesst
*	taking into account time dependency.  
logit env_ministryonset_realb demo_dummy3 emn_av emnav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)

preserve
drawnorm MG_b1-MG_b10, n(1000) means(e(b)) cov(e(V)) clear
postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi using sim, replace

noisily display "start"

*	2. I put all variables at the mean, except for my indep. variable
*	of interest -demo_dummy- with will be moved from 0 to 1, and for OECD
*	which is here defined as a non-OECD country. 
*	Notice that "a" below represents the range of values for the IR 
*	variable.
local a = 0 
while `a' <= 293.900 {
{
scalar h_demo_dummy3 = 0
scalar h_gdpcapk = 7.193102
scalar h_pop_density_wdi = 131.5261
scalar h_openk = 70.55944
scalar h_service1 = 65.62408
scalar h_oecd_real = 0
scalar h_lowesst = .0166979
scalar h_constant = 1

*	3. We now look at the expected change in probability when
*	democratization shifts from 0 to 1.
generate x_betahat0 = MG_b1*h_demo_dummy3 + MG_b2*(`a') + MG_b3* h_demo_dummy3 *(`a') + MG_b4*h_gdpcapk + MG_b5*h_pop_density_wdi + MG_b6*h_openk + MG_b7*h_service1 + MG_b8*h_oecd_real + MG_b9*h_lowesst + MG_b10*h_constant

generate x_betahat1 = MG_b1*(h_demo_dummy3+1) + MG_b2*(`a') + MG_b3*(h_demo_dummy3+1)*(`a') + MG_b4*h_gdpcapk + MG_b5*h_pop_density_wdi+ MG_b6*h_openk + MG_b7* h_service1 + MG_b8* h_oecd_real + MG_b9*h_lowesst + MG_b10*h_constant

gen prob0=exp(x_betahat0)/(1 + exp(x_betahat0))
gen prob1=exp(x_betahat1)/(1 + exp(x_betahat1))
gen diff=prob1-prob0

egen probhat0=mean(prob0)
egen probhat1=mean(prob1)
egen diffhat=mean(diff)

tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi

*	4. I now build the confidence intervals.
_pctile prob0, p(2.5,97.5)
scalar `lo0' = r(r1)
scalar `hi0' = r(r2)
_pctile prob1, p(2.5,97.5)
scalar `lo1'= r(r1)
scalar `hi1'= r(r2)

_pctile diff, p(2.5,97.5)
scalar `diff_lo'= r(r1)
scalar `diff_hi'= r(r2)

scalar `prob_hat0'=probhat0
scalar `prob_hat1'=probhat1
scalar `diff_hat'=diffhat

post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') (`diff_hat') (`diff_lo') (`diff_hi')}
drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat

*	5. This represents the jumb in the IR variable. 
local a = `a'+ 1
display "."	_c
}

display ""

postclose mypost

use sim, clear

gen MV = _n-1

graph twoway line diff_hat MV, clwidth(medium) clcolor(blue) clcolor(black) || line diff_lo MV, clpattern(dash) clwidth(thin) clcolor(black) || line diff_hi MV, clpattern(dash) clwidth(thin) clcolor(black) || ,  legend(off ) title("Marg. Effect of Democratization on Env. Ministry As Env. Aid (narrow) Changes", size(3)) subtitle(" " "Dependent Variable: Environmental Ministry Creation" " ", size(3)) xtitle("Environmental Aid (narrow) (m$)", size(3.5) ) ytitle("Marginal Effect of Democratization", size(3.5)) xsca(titlegap(2)) ysca(titlegap(2)) scheme(s2mono) graphregion(fcolor(white))   
graph export "marginal_emn.pdf", replace

restore


*	************************************************************************
* 	iv. Simulation for Peer pressure 
*	************************************************************************

xtset ccode year

*	1. Running the IR*democratization model. Notice that this is the same
*	model as in Table 3, Column 1, but run as a logit model with lowesst
*	taking into account time dependency.  
logit env_ministryonset_realb demo_dummy3 lsumm lsumm_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)

preserve
drawnorm MG_b1-MG_b10, n(1000) means(e(b)) cov(e(V)) clear
postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi using sim, replace

noisily display "start"

*	2. I put all variables at the mean, except for my indep. variable
*	of interest -demo_dummy- with will be moved from 0 to 1, and for OECD
*	which is here defined as a non-OECD country. 
*	Notice that "a" below represents the range of values for the IR 
*	variable.
local a = 0 
while `a' <= 130 {
{
scalar h_demo_dummy3 = 0
scalar h_gdpcapk = 7.193102
scalar h_pop_density_wdi = 131.5261
scalar h_openk = 70.55944
scalar h_service1 = 65.62408
scalar h_oecd_real = 0
scalar h_lowesst = .0166979
scalar h_constant = 1

*	3. We now look at the expected change in probability when
*	democratization shifts from 0 to 1.
generate x_betahat0 = MG_b1*h_demo_dummy3 + MG_b2*(`a') + MG_b3* h_demo_dummy3 *(`a') + MG_b4 * h_gdpcapk + MG_b5*h_pop_density_wdi + MG_b6*h_openk + MG_b7* h_service1 + MG_b8*h_oecd_real + MG_b9*h_lowesst + MG_b10*h_constant

generate x_betahat1 = MG_b1*(h_demo_dummy3+1) + MG_b2*(`a') + MG_b3*(h_demo_dummy3+1)*(`a') + MG_b4*h_gdpcapk + MG_b5*h_pop_density_wdi+ MG_b6*h_openk + MG_b7* h_service1 + MG_b8* h_oecd_real + MG_b9*h_lowesst + MG_b10*h_constant

gen prob0=exp(x_betahat0)/(1 + exp(x_betahat0))
gen prob1=exp(x_betahat1)/(1 + exp(x_betahat1))
gen diff=prob1-prob0

egen probhat0=mean(prob0)
egen probhat1=mean(prob1)
egen diffhat=mean(diff)

tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi

*	4. I now build the confidence intervals.
_pctile prob0, p(2.5,97.5)
scalar `lo0' = r(r1)
scalar `hi0' = r(r2)
_pctile prob1, p(2.5,97.5)
scalar `lo1'= r(r1)
scalar `hi1'= r(r2)

_pctile diff, p(2.5,97.5)
scalar `diff_lo'= r(r1)
scalar `diff_hi'= r(r2)

scalar `prob_hat0'=probhat0
scalar `prob_hat1'=probhat1
scalar `diff_hat'=diffhat

post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') (`diff_hat') (`diff_lo') (`diff_hi')}
drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat

*	5. This represents the jumb in the IR variable. 
local a = `a'+ 1
display "."	_c
}

display ""

postclose mypost

use sim, clear

gen MV = _n-1

graph twoway line diff_hat MV, clwidth(medium) clcolor(blue) clcolor(black) || line diff_lo MV, clpattern(dash) clwidth(thin) clcolor(black) || line diff_hi MV, clpattern(dash) clwidth(thin) clcolor(black) || ,  legend(off ) title("Marg. Effect of Democratization on Env. Ministry As Number of Peers Changes", size(3)) subtitle(" " "Dependent Variable: Environmental Ministry Creation" " ", size(3)) xtitle("Sum Countries with Env. Ministry", size(3.5) ) ytitle("Marginal Effect of Democratization", size(3.5)) xsca(titlegap(2)) ysca(titlegap(2)) scheme(s2mono) graphregion(fcolor(white))   
graph export "marginal_peer.pdf", replace

restore



*	************************************************************************
* 	v. Simulation for Regional Peer pressure 
*	************************************************************************

xtset ccode year

*	1. Running the IR*democratization model. Notice that this is the same
*	model as in Table 3, Column 1, but run as a logit model with lowesst
*	taking into account time dependency.  
logit env_ministryonset_realb demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)

preserve
drawnorm MG_b1-MG_b10, n(1000) means(e(b)) cov(e(V)) clear
postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi using sim, replace

noisily display "start"

*	2. I put all variables at the mean, except for my indep. variable
*	of interest -demo_dummy- with will be moved from 0 to 1, and for OECD
*	which is here defined as a non-OECD country. 
*	Notice that "a" below represents the range of values for the IR 
*	variable.
local a = 0 
while `a' <= 100 {
{
scalar h_demo_dummy3 = 0
scalar h_gdpcapk = 7.193102
scalar h_pop_density_wdi = 131.5261
scalar h_openk = 70.55944
scalar h_service1 = 65.62408
scalar h_oecd_real = 0
scalar h_lowesst = .0166979
scalar h_constant = 1

*	3. We now look at the expected change in probability when
*	democratization shifts from 0 to 1.
generate x_betahat0 = MG_b1*h_demo_dummy3 + MG_b2*(`a') + MG_b3* h_demo_dummy3 *(`a') + MG_b4 * h_gdpcapk + MG_b5*h_pop_density_wdi + MG_b6*h_openk + MG_b7* h_service1 + MG_b8*h_oecd_real + MG_b9*h_lowesst + MG_b10*h_constant

generate x_betahat1 = MG_b1*(h_demo_dummy3+1) + MG_b2*(`a') + MG_b3*(h_demo_dummy3+1)*(`a') + MG_b4*h_gdpcapk + MG_b5*h_pop_density_wdi+ MG_b6*h_openk + MG_b7* h_service1 + MG_b8* h_oecd_real + MG_b9*h_lowesst + MG_b10*h_constant

gen prob0=exp(x_betahat0)/(1 + exp(x_betahat0))
gen prob1=exp(x_betahat1)/(1 + exp(x_betahat1))
gen diff=prob1-prob0

egen probhat0=mean(prob0)
egen probhat1=mean(prob1)
egen diffhat=mean(diff)

tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi

*	4. I now build the confidence intervals.
_pctile prob0, p(2.5,97.5)
scalar `lo0' = r(r1)
scalar `hi0' = r(r2)
_pctile prob1, p(2.5,97.5)
scalar `lo1'= r(r1)
scalar `hi1'= r(r2)

_pctile diff, p(2.5,97.5)
scalar `diff_lo'= r(r1)
scalar `diff_hi'= r(r2)

scalar `prob_hat0'=probhat0
scalar `prob_hat1'=probhat1
scalar `diff_hat'=diffhat

post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') (`diff_hat') (`diff_lo') (`diff_hi')}
drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat

*	5. This represents the jumb in the IR variable. 
local a = `a'+ 1
display "."	_c
}

display ""

postclose mypost

use sim, clear

gen MV = _n-1

graph twoway line diff_hat MV, clwidth(medium) clcolor(blue) clcolor(black) || line diff_lo MV, clpattern(dash) clwidth(thin) clcolor(black) || line diff_hi MV, clpattern(dash) clwidth(thin) clcolor(black) || ,  legend(off ) title("Marg. Effect of Democratization on Env. Ministry As Proportion of Regional Peers Changes", size(3)) subtitle(" " "Dependent Variable: Environmental Ministry Creation" " ", size(3)) xtitle("Proportion (by Region) of Countries with Env. Ministry", size(3.5) ) ytitle("Marginal Effect of Democratization", size(3.5)) xsca(titlegap(2)) ysca(titlegap(2)) scheme(s2mono) graphregion(fcolor(white))   
graph export "marginal_regiopeer.pdf", replace

restore


*	************************************************************************
* 	7. Robustness Checks
*		A. Alternative definition of democratization (now based on
*			Polity IV (t) - Polity IV (t-5)
*		B. Alternative time frame for democratization (now based on
*			t - t-1 instead of t - t-5). 
*	************************************************************************

*	************************************************************************
*	A. Same as above, but with -democratization5- (and corresponding 
*		interaction effects) instead of -demo_dummy3-
*	************************************************************************
*	************************************************************************
*		i. Model without any IR influence
*	************************************************************************

stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)

streg democratization3 ir9294 gdpcapk, nohr distribution(weibull)
streg democratization3 ir9294 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)

*	************************************************************************
*		ii. Model with IR dummy (for various years)
*	************************************************************************

streg democratization3 ir9294 ir9294_x_democratization3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
streg democratization3 ir9295 ir9295_x_democratization3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
streg democratization3 ir9296 ir9296_x_democratization3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
streg democratization3 ir9297 ir9297_x_democratization3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)


*	************************************************************************
*		iii. Model with environmental aid 
*	************************************************************************

stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox democratization3 emb_av embav_x_democratization3 gdpcapk service1 openk pop_density_wdi, nohr
streg democratization3 emb_av embav_x_democratization3 gdpcapk service1 openk pop_density_wdi, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb democratization3 emb_av embav_x_democratization3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb democratization3 emb_av embav_x_democratization3 gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb democratization3 emb_av embav_x_democratization3 gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)


stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox democratization3 emn_av emnav_x_democratization3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr
streg democratization3 emn_av emnav_x_democratization3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb democratization3 emn_av emnav_x_democratization3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb democratization3 emn_av emnav_x_democratization3 gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb democratization3 emn_av emnav_x_democratization3 gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)

*	************************************************************************
*		iv. Model with peer pressure 
*	************************************************************************

stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
streg democratization3 lsumm lsumm_x_democratization3 gdpcapk service openk pop_density_wdi lowesst, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb democratization3 lsumm lsumm_x_democratization3 gdpcapk pop_density_wdi openk service oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb democratization3 lsumm lsumm_x_democratization3 gdpcapk pop_density_wdi openk service oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb democratization3 lsumm lsumm_x_democratization3 gdpcapk pop_density_wdi openk service oecd_real dur2, cluster(ccode)

stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox democratization3 regional_proportion_envministry regionalpe_x_democratization3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr
streg democratization3 regional_proportion_envministry regionalpe_x_democratization3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb democratization3 regional_proportion_envministry regionalpe_x_democratization3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb democratization3 regional_proportion_envministry regionalpe_x_democratization3 gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb democratization3 regional_proportion_envministry regionalpe_x_democratization3 gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)


*	************************************************************************
*	B. Same models, but with the democratization variable measured
*		between t and t-1 (instead of t - t-3).
*	************************************************************************

*	************************************************************************
*		i. Model without any IR influence
*	************************************************************************
streg demo_dummy1 ir9294 gdpcapk, nohr distribution(weibull)
streg demo_dummy1 ir9294 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)


*	************************************************************************
*		ii. Model with IR dummy (for various years)
*	************************************************************************

streg demo_dummy1 ir9294 ir9294_x_demod1 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
streg demo_dummy1 ir9295 ir9295_x_demod1 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
streg demo_dummy1 ir9296 ir9296_x_demod1 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
streg demo_dummy1 ir9297 ir9297_x_demod1 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)


*	************************************************************************
*		iii. Model with environmental aid 
*	************************************************************************

stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox demo_dummy1 emb_av embav_x_demodummy1 gdpcapk service1 openk pop_density_wdi, nohr
streg demo_dummy1 emb_av embav_x_demodummy1 gdpcapk service1 openk pop_density_wdi, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy1 emb_av embav_x_demodummy1 gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb demo_dummy1 emb_av embav_x_demodummy1 gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb demo_dummy1 emb_av embav_x_demodummy1 gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)


stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox demo_dummy1 emn_av emnav_x_demodummy1 gdpcapk pop_density_wdi openk service1 oecd_real, nohr
streg demo_dummy1 emn_av emnav_x_demodummy1 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy1 emn_av emnav_x_demodummy1 gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb demo_dummy1 emn_av emnav_x_demodummy1 gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb demo_dummy1 emn_av emnav_x_demodummy1 gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)

*	************************************************************************
*		iv. Model with peer pressure 
*	************************************************************************

stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
streg demo_dummy1 lsumm lsumm_x_demodummy1 gdpcapk service openk pop_density_wdi lowesst, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy1 lsumm lsumm_x_demodummy1 gdpcapk pop_density_wdi openk service oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb demo_dummy1 lsumm lsumm_x_demodummy1 gdpcapk pop_density_wdi openk service oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb demo_dummy1 lsumm lsumm_x_demodummy1 gdpcapk pop_density_wdi openk service oecd_real dur2, cluster(ccode)

stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox demo_dummy1 regional_proportion_envministry regionalpe_x_demodummy1 gdpcapk pop_density_wdi openk service1 oecd_real, nohr
streg demo_dummy1 regional_proportion_envministry regionalpe_x_demodummy1 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy1 regional_proportion_envministry regionalpe_x_demodummy1 gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb demo_dummy1 regional_proportion_envministry regionalpe_x_demodummy1 gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb demo_dummy1 regional_proportion_envministry regionalpe_x_demodummy1 gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)


*	************************************************************************
*	C. Same models, but with the democratization variable measured
*		between t and t-5 (instead of t - t-3).
*	************************************************************************

*	************************************************************************
*		i. Model without any IR influence
*	************************************************************************
streg demo_dummy5 ir9294 gdpcapk, nohr distribution(weibull)
streg demo_dummy5 ir9294 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)


*	************************************************************************
*		ii. Model with IR dummy (for various years)
*	************************************************************************

streg demo_dummy5 ir9294 ir9294_x_demod1 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
streg demo_dummy5 ir9295 ir9295_x_demod1 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
streg demo_dummy5 ir9296 ir9296_x_demod1 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
streg demo_dummy5 ir9297 ir9297_x_demod1 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)


*	************************************************************************
*		iii. Model with environmental aid 
*	************************************************************************

stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox demo_dummy5 emb_av embav_x_demodummy5 gdpcapk service1 openk pop_density_wdi, nohr
streg demo_dummy5 emb_av embav_x_demodummy5 gdpcapk service1 openk pop_density_wdi, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy5 emb_av embav_x_demodummy5 gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb demo_dummy5 emb_av embav_x_demodummy5 gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb demo_dummy5 emb_av embav_x_demodummy5 gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)


stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox demo_dummy5 emn_av emnav_x_demodummy5 gdpcapk pop_density_wdi openk service1 oecd_real, nohr
streg demo_dummy5 emn_av emnav_x_demodummy5 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy5 emn_av emnav_x_demodummy5 gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb demo_dummy5 emn_av emnav_x_demodummy5 gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb demo_dummy5 emn_av emnav_x_demodummy5 gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)

*	************************************************************************
*		iv. Model with peer pressure 
*	************************************************************************

stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
streg demo_dummy5 lsumm lsumm_x_demodummy5 gdpcapk service openk pop_density_wdi lowesst, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy5 lsumm lsumm_x_demodummy5 gdpcapk pop_density_wdi openk service oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb demo_dummy5 lsumm lsumm_x_demodummy5 gdpcapk pop_density_wdi openk service oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb demo_dummy5 lsumm lsumm_x_demodummy5 gdpcapk pop_density_wdi openk service oecd_real dur2, cluster(ccode)

stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox demo_dummy5 regional_proportion_envministry regionalpe_x_demodummy5 gdpcapk pop_density_wdi openk service1 oecd_real, nohr
streg demo_dummy5 regional_proportion_envministry regionalpe_x_demodummy5 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy5 regional_proportion_envministry regionalpe_x_demodummy5 gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb demo_dummy5 regional_proportion_envministry regionalpe_x_demodummy5 gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb demo_dummy5 regional_proportion_envministry regionalpe_x_demodummy5 gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)


*	************************************************************************
*	D. Split data: dropping all OECD countries
*	************************************************************************

*	************************************************************************
*		i. Model without any IR influence
*	************************************************************************
streg demo_dummy3 ir9294 gdpcapk if oecd_membership == 0, nohr distribution(weibull)
streg demo_dummy3 ir9294 gdpcapk pop_density_wdi openk service1 oecd_real if oecd_membership == 0, nohr distribution(weibull)


*	************************************************************************
*		ii. Model with IR dummy (for various years)
*	************************************************************************

streg demo_dummy3 ir9294 ir9294_x_demod3 gdpcapk pop_density_wdi openk service1 oecd_real if oecd_membership == 0, nohr distribution(weibull)
streg demo_dummy3 ir9295 ir9295_x_demod3 gdpcapk pop_density_wdi openk service1 oecd_real if oecd_membership == 0, nohr distribution(weibull)
streg demo_dummy3 ir9296 ir9296_x_demod3 gdpcapk pop_density_wdi openk service1 oecd_real if oecd_membership == 0, nohr distribution(weibull)
streg demo_dummy3 ir9297 ir9297_x_demod3 gdpcapk pop_density_wdi openk service1 oecd_real if oecd_membership == 0, nohr distribution(weibull)


*	************************************************************************
*		iii. Model with environmental aid 
*	************************************************************************

stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox demo_dummy3 emb_av embav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real if oecd_membership == 0, nohr
streg demo_dummy3 emb_av embav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real if oecd_membership == 0, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy3 emb_av embav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst if oecd_membership == 0, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 emb_av embav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real logdur if oecd_membership == 0, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 emb_av embav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real dur2 if oecd_membership == 0, cluster(ccode)


stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox demo_dummy3 emn_av emnav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real if oecd_membership == 0, nohr
streg demo_dummy3 emn_av emnav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real if oecd_membership == 0, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy3 emn_av emnav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst if oecd_membership == 0, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 emn_av emnav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real logdur if oecd_membership == 0, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 emn_av emnav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real dur2 if oecd_membership == 0, cluster(ccode)

*	************************************************************************
*		iv. Model with peer pressure 
*			1. Global peer pressure
*			2. Regional peer pressure
*	************************************************************************

*	* 1. Global peer pressure
stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
streg demo_dummy3 lsumm lsumm_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real if oecd_membership == 0, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy3 lsumm lsumm_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst if oecd_membership == 0, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 lsumm lsumm_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real logdur if oecd_membership == 0, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 lsumm lsumm_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real dur2 if oecd_membership == 0, cluster(ccode)


*	* 2. Continental/regional peer pressure
stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real if oecd_membership == 0, nohr
streg demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real if oecd_membership == 0, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst if oecd_membership == 0, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real logdur if oecd_membership == 0, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real dur2 if oecd_membership == 0, cluster(ccode)


*	************************************************************************
*	E. Models on Environmental Aid, but dropping values > 90th percentile
*		of env. aid (keeping out extreme values)
*	************************************************************************

*	************************************************************************
*		iv. Model with environmental aid 
*	************************************************************************

stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox demo_dummy3 emb_av embav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real if emb_av < 18650, nohr
streg demo_dummy3 emb_av embav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real if emb_av < 18650, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy3 emb_av embav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst if emb_av < 18650, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 emb_av embav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real logdur if emb_av < 18650, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 emb_av embav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real dur2 if emb_av < 18650, cluster(ccode)


stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox demo_dummy3 emn_av emnav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real if emn_av < 416, nohr
streg demo_dummy3 emn_av emnav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real if emn_av < 416, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy3 emn_av emnav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst if emn_av < 416, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 emn_av emnav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real logdur if emn_av < 416, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 emn_av emnav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real dur2 if emn_av < 416, cluster(ccode)


*	************************************************************************
*	F. Models on Environmental Aid, but with lagged values
*	************************************************************************

*	************************************************************************
*		iv. Model with environmental aid 
*	************************************************************************

stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox ldemo_dummy3 lemb_av lembav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real if emb_av < 18650, nohr
streg ldemo_dummy3 lemb_av lembav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real if emb_av < 18650, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb ldemo_dummy3 lemb_av lembav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst if emb_av < 18650, cluster(ccode)
logit env_ministryonset_realb ldemo_dummy3 lemb_av lembav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real logdur if emb_av < 18650, cluster(ccode)
logit env_ministryonset_realb ldemo_dummy3 lemb_av lembav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real dur2 if emb_av < 18650, cluster(ccode)


stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox ldemo_dummy3 lemn_av lemnav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real if emn_av < 416, nohr
streg ldemo_dummy3 lemn_av lemnav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real if emn_av < 416, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb ldemo_dummy3 lemn_av lemnav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst if emn_av < 416, cluster(ccode)
logit env_ministryonset_realb ldemo_dummy3 lemn_av lemnav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real logdur if emn_av < 416, cluster(ccode)
logit env_ministryonset_realb ldemo_dummy3 lemn_av lemnav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real dur2 if emn_av < 416, cluster(ccode)




*	************************************************************************
*	G. Other threshold for democratization dummy: d.polity > 4
*	************************************************************************

*	************************************************************************
*		i. Model without any IR influence
*	************************************************************************
streg demo4_dummy3 ir9294 gdpcapk, nohr distribution(weibull)
streg demo4_dummy3 ir9294 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)


*	************************************************************************
*		ii. Model with IR dummy (for various years)
*	************************************************************************

streg demo4_dummy3 ir9294 ir9294_x_demo4d3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
streg demo4_dummy3 ir9295 ir9295_x_demo4d3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
streg demo4_dummy3 ir9296 ir9296_x_demo4d3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
streg demo4_dummy3 ir9297 ir9297_x_demo4d3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)


*	************************************************************************
*		iii. Model with environmental aid 
*	************************************************************************

stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox demo4_dummy3 emb_av embav_x_demo4dummy3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr
streg demo4_dummy3 emb_av embav_x_demo4dummy3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo4_dummy3 emb_av embav_x_demo4dummy3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb demo4_dummy3 emb_av embav_x_demo4dummy3 gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb demo4_dummy3 emb_av embav_x_demo4dummy3 gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)


stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox demo4_dummy3 emn_av emnav_x_demo4dummy3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr
streg demo4_dummy3 emn_av emnav_x_demo4dummy3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo4_dummy3 emn_av emnav_x_demo4dummy3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb demo4_dummy3 emn_av emnav_x_demo4dummy3 gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb demo4_dummy3 emn_av emnav_x_demo4dummy3 gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)

*	************************************************************************
*		iv. Model with peer pressure 
*			1. Global peer pressure
*			2. Regional peer pressure
*	************************************************************************

*	* 1. Global peer pressure
stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
streg demo4_dummy3 lsumm lsumm_x_demo4dummy3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo4_dummy3 lsumm lsumm_x_demo4dummy3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb demo4_dummy3 lsumm lsumm_x_demo4dummy3 gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb demo4_dummy3 lsumm lsumm_x_demo4dummy3 gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)


*	* 2. Continental/regional peer pressure
stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox demo4_dummy3 regional_proportion_envministry regionalpe_x_demo4dummy3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr
streg demo4_dummy3 regional_proportion_envministry regionalpe_x_demo4dummy3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo4_dummy3 regional_proportion_envministry regionalpe_x_demo4dummy3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb demo4_dummy3 regional_proportion_envministry regionalpe_x_demo4dummy3 gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb demo4_dummy3 regional_proportion_envministry regionalpe_x_demo4dummy3 gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)



*	************************************************************************
*	H. Other threshold for democratization dummy: d.polity > 2
*	************************************************************************

*	************************************************************************
*		i. Model without any IR influence
*	************************************************************************
streg demo2_dummy3 ir9294 gdpcapk, nohr distribution(weibull)
streg demo2_dummy3 ir9294 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)


*	************************************************************************
*		ii. Model with IR dummy (for various years)
*	************************************************************************

streg demo2_dummy3 ir9294 ir9294_x_demo2d3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
streg demo2_dummy3 ir9295 ir9295_x_demo2d3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
streg demo2_dummy3 ir9296 ir9296_x_demo2d3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
streg demo2_dummy3 ir9297 ir9297_x_demo2d3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)


*	************************************************************************
*		iii. Model with environmental aid 
*	************************************************************************

stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox demo2_dummy3 emb_av embav_x_demo2dummy3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr
streg demo2_dummy3 emb_av embav_x_demo2dummy3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo2_dummy3 emb_av embav_x_demo2dummy3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb demo2_dummy3 emb_av embav_x_demo2dummy3 gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb demo2_dummy3 emb_av embav_x_demo2dummy3 gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)


stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox demo2_dummy3 emn_av emnav_x_demo2dummy3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr
streg demo2_dummy3 emn_av emnav_x_demo2dummy3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo2_dummy3 emn_av emnav_x_demo2dummy3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb demo2_dummy3 emn_av emnav_x_demo2dummy3 gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb demo2_dummy3 emn_av emnav_x_demo2dummy3 gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)

*	************************************************************************
*		iv. Model with peer pressure 
*			1. Global peer pressure
*			2. Regional peer pressure
*	************************************************************************

*	* 1. Global peer pressure
stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
streg demo2_dummy3 lsumm lsumm_x_demo2dummy3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo2_dummy3 lsumm lsumm_x_demo2dummy3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb demo2_dummy3 lsumm lsumm_x_demo2dummy3 gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb demo2_dummy3 lsumm lsumm_x_demo2dummy3 gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)


*	* 2. Continental/regional peer pressure
stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox demo2_dummy3 regional_proportion_envministry regionalpe_x_demo2dummy3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr
streg demo2_dummy3 regional_proportion_envministry regionalpe_x_demo2dummy3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo2_dummy3 regional_proportion_envministry regionalpe_x_demo2dummy3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb demo2_dummy3 regional_proportion_envministry regionalpe_x_demo2dummy3 gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb demo2_dummy3 regional_proportion_envministry regionalpe_x_demo2dummy3 gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)




*	************************************************************************
*	I. Adding a post-communism country-year dummy
*	************************************************************************

*	************************************************************************
*		i. Model without any IR influence
*	************************************************************************
streg demo_dummy3 ir9294 gdpcapk postcomm_ctry_real, nohr distribution(weibull)
streg demo_dummy3 ir9294 gdpcapk pop_density_wdi openk service1 oecd_real postcomm_ctry_real, nohr distribution(weibull)


*	************************************************************************
*		ii. Model with IR dummy (for various years)
*	************************************************************************

streg demo_dummy3 ir9294 ir9294_x_demod3 gdpcapk pop_density_wdi openk service1 oecd_real postcomm_ctry_real, nohr distribution(weibull)
streg demo_dummy3 ir9295 ir9295_x_demod3 gdpcapk pop_density_wdi openk service1 oecd_real postcomm_ctry_real, nohr distribution(weibull)
streg demo_dummy3 ir9296 ir9296_x_demod3 gdpcapk pop_density_wdi openk service1 oecd_real postcomm_ctry_real, nohr distribution(weibull)
streg demo_dummy3 ir9297 ir9297_x_demod3 gdpcapk pop_density_wdi openk service1 oecd_real postcomm_ctry_real, nohr distribution(weibull)


*	************************************************************************
*		iii. Model with environmental aid 
*	************************************************************************

stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox demo_dummy3 emb_av embav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real postcomm_ctry_real, nohr
streg demo_dummy3 emb_av embav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real postcomm_ctry_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy3 emb_av embav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst postcomm_ctry_real, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 emb_av embav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real logdur postcomm_ctry_real, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 emb_av embav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real dur2 postcomm_ctry_real, cluster(ccode)


stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox demo_dummy3 emn_av emnav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real postcomm_ctry_real, nohr
streg demo_dummy3 emn_av emnav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real postcomm_ctry_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy3 emn_av emnav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst postcomm_ctry_real, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 emn_av emnav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real logdur postcomm_ctry_real, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 emn_av emnav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real dur2 postcomm_ctry_real, cluster(ccode)

*	************************************************************************
*		iv. Model with peer pressure 
*			1. Global peer pressure
*			2. Regional peer pressure
*	************************************************************************

*	* 1. Global peer pressure
stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
streg demo_dummy3 lsumm lsumm_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real postcomm_ctry_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy3 lsumm lsumm_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst postcomm_ctry_real, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 lsumm lsumm_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real logdur postcomm_ctry_real, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 lsumm lsumm_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real dur2 postcomm_ctry_real, cluster(ccode)


*	* 2. Continental/regional peer pressure
stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real postcomm_ctry_real, nohr
streg demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real postcomm_ctry_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst postcomm_ctry_real, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real logdur postcomm_ctry_real, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real dur2 postcomm_ctry_real, cluster(ccode)



*	************************************************************************
*	J. Using Cheibub et al's (based on Przeworski et al) democracy variable
*	************************************************************************
*	************************************************************************
*		i. Model without any IR influence
*	************************************************************************

stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)

streg democratization_cheibub ir9294 gdpcapk, nohr distribution(weibull)
streg democratization_cheibub ir9294 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)

*	************************************************************************
*		ii. Model with IR dummy (for various years)
*	************************************************************************

streg democratization_cheibub ir9294 ir9294_x_democratization_cheibub gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
streg democratization_cheibub ir9295 ir9295_x_democratization_cheibub gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
streg democratization_cheibub ir9296 ir9296_x_democratization_cheibub gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
streg democratization_cheibub ir9297 ir9297_x_democratization_cheibub gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)


*	************************************************************************
*		iii. Model with environmental aid 
*	************************************************************************

stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox democratization_cheibub emb_av embav_x_democratization_cheibub gdpcapk service1 openk pop_density_wdi, nohr
streg democratization_cheibub emb_av embav_x_democratization_cheibub gdpcapk service1 openk pop_density_wdi, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb democratization_cheibub emb_av embav_x_democratization_cheibub gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb democratization_cheibub emb_av embav_x_democratization_cheibub gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb democratization_cheibub emb_av embav_x_democratization_cheibub gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)


stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox democratization_cheibub emn_av emnav_x_democratization_cheibub gdpcapk pop_density_wdi openk service1 oecd_real, nohr
streg democratization_cheibub emn_av emnav_x_democratization_cheibub gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb democratization_cheibub emn_av emnav_x_democratization_cheibub gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb democratization_cheibub emn_av emnav_x_democratization_cheibub gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb democratization_cheibub emn_av emnav_x_democratization_cheibub gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)

*	************************************************************************
*		iv. Model with peer pressure 
*	************************************************************************

stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
streg democratization_cheibub lsumm lsumm_x_democratization_cheibub gdpcapk service openk pop_density_wdi lowesst, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb democratization_cheibub lsumm lsumm_x_democratization_cheibub gdpcapk pop_density_wdi openk service oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb democratization_cheibub lsumm lsumm_x_democratization_cheibub gdpcapk pop_density_wdi openk service oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb democratization_cheibub lsumm lsumm_x_democratization_cheibub gdpcapk pop_density_wdi openk service oecd_real dur2, cluster(ccode)

stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox democratization_cheibub regional_proportion_envministry regionalpe_x_demo_cheibub gdpcapk pop_density_wdi openk service1 oecd_real, nohr
streg democratization_cheibub regional_proportion_envministry regionalpe_x_demo_cheibub gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb democratization_cheibub regional_proportion_envministry regionalpe_x_demo_cheibub gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb democratization_cheibub regional_proportion_envministry regionalpe_x_demo_cheibub gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb democratization_cheibub regional_proportion_envministry regionalpe_x_demo_cheibub gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)


*	************************************************************************
*	K. Special 'all in one' model
*	************************************************************************
*	************************************************************************
*		iii. Model with environmental aid 
*	************************************************************************

stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
streg demo_dummy3 emb_av embav_x_demodummy3 ir9294 ir9294_x_demod3 gdpcapk pop_density_wdi openk service1, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy3 emb_av embav_x_demodummy3 ir9294 ir9294_x_demod3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 emb_av embav_x_demodummy3 ir9294 ir9294_x_demod3 gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 emb_av embav_x_demodummy3 ir9294 ir9294_x_demod3 gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)

lsumm lsumm_x_demodummy3 regional_proportion_envministry regionalpe_x_demodummy3



*	************************************************************************
*	L. Different Env. Aid specification: Env. Aid averaged over t-4 to t-1
*	************************************************************************

stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
eststo: stcox demo_dummy3 emb_av41 emb_av41_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr
eststo: streg demo_dummy3 emb_av41 emb_av41_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
eststo: logit env_ministryonset_realb demo_dummy3 emb_av41 emb_av41_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
eststo: logit env_ministryonset_realb demo_dummy3 emb_av41 emb_av41_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
eststo: logit env_ministryonset_realb demo_dummy3 emb_av41 emb_av41_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)

esttab using "table9.tex", replace booktabs se(3) b(3) label star(* 0.10 ** 0.05 *** 0.01)  scalars("chi2 $\chi^2$" "N_sub N Subject" "N_fail N Failures") ///
mtitles("Cox" "Weibull" "Logit Lowess" "Logit Log" "Logit Square") title(Alternative Aid Specification\label{table9})
eststo clear


stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
eststo: stcox demo_dummy3 emn_av41 emn_av41_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr
eststo: streg demo_dummy3 emn_av41 emn_av41_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
eststo: logit env_ministryonset_realb demo_dummy3 emn_av41 emn_av41_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
eststo: logit env_ministryonset_realb demo_dummy3 emn_av41 emn_av41_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
eststo: logit env_ministryonset_realb demo_dummy3 emn_av41 emn_av41_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)

esttab using "table10.tex", replace booktabs se(3) b(3) label star(* 0.10 ** 0.05 *** 0.01)  scalars("chi2 $\chi^2$" "N_sub N Subject" "N_fail N Failures") ///
mtitles("Cox" "Weibull" "Logit Lowess" "Logit Log" "Logit Square") title(Alternative Aid Specification\label{table10})
eststo clear

*	************************************************************************
*	M. Adding the interaction between income and democratization
*	************************************************************************


*	************************************************************************
*	a. Rio Approach
*		i. 		Model without any IR influence
*		ii. 	Model with IR (for various years)
*		iii. 	Model for OECD and non-OECD countries
*		iv. 	Model with IR*Democratization interaction (for various years)
*	************************************************************************


*	************************************************************************
*		i. Model without any IR influence
*	************************************************************************
stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
streg demo_dummy3 ir9294 gdpcapk gdpcapk_x_demodummy3, nohr distribution(weibull)
streg demo_dummy3 ir9294 gdpcapk gdpcapk_x_demodummy3 pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)


*	************************************************************************
*		ii. Model with IR dummy (for various years)
*	************************************************************************

streg demo_dummy3 ir9294 ir9294_x_demod3 gdpcapk gdpcapk_x_demodummy3 pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
streg demo_dummy3 ir9295 ir9295_x_demod3 gdpcapk gdpcapk_x_demodummy3 pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
streg demo_dummy3 ir9296 ir9296_x_demod3 gdpcapk gdpcapk_x_demodummy3 pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
streg demo_dummy3 ir9297 ir9297_x_demod3 gdpcapk gdpcapk_x_demodummy3 pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)


*	************************************************************************
*		iv. Model with environmental aid 
*	************************************************************************

stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox demo_dummy3 emb_av embav_x_demodummy3 gdpcapk gdpcapk_x_demodummy3 pop_density_wdi openk service1 oecd_real, nohr
streg demo_dummy3 emb_av embav_x_demodummy3 gdpcapk gdpcapk_x_demodummy3 pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy3 emb_av embav_x_demodummy3 gdpcapk gdpcapk_x_demodummy3 pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 emb_av embav_x_demodummy3 gdpcapk gdpcapk_x_demodummy3 pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 emb_av embav_x_demodummy3 gdpcapk gdpcapk_x_demodummy3 pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)


stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox demo_dummy3 emn_av emnav_x_demodummy3 gdpcapk gdpcapk_x_demodummy3 pop_density_wdi openk service1 oecd_real, nohr
streg demo_dummy3 emn_av emnav_x_demodummy3 gdpcapk gdpcapk_x_demodummy3 pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy3 emn_av emnav_x_demodummy3 gdpcapk gdpcapk_x_demodummy3 pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 emn_av emnav_x_demodummy3 gdpcapk gdpcapk_x_demodummy3 pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 emn_av emnav_x_demodummy3 gdpcapk gdpcapk_x_demodummy3 pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)



*	************************************************************************
*		v. Model with peer pressure 
*			1. Global peer pressure
*			2. Regional peer pressure
*	************************************************************************

*	* 1. Global peer pressure
stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
streg demo_dummy3 lsumm lsumm_x_demodummy3 gdpcapk gdpcapk_x_demodummy3 pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy3 lsumm lsumm_x_demodummy3 gdpcapk gdpcapk_x_demodummy3 pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 lsumm lsumm_x_demodummy3 gdpcapk gdpcapk_x_demodummy3 pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 lsumm lsumm_x_demodummy3 gdpcapk gdpcapk_x_demodummy3 pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)


*	* 2. Continental/regional peer pressure
stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 gdpcapk gdpcapk_x_demodummy3 pop_density_wdi openk service1 oecd_real, nohr
streg demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 gdpcapk gdpcapk_x_demodummy3 pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 gdpcapk gdpcapk_x_demodummy3 pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 gdpcapk gdpcapk_x_demodummy3 pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 gdpcapk gdpcapk_x_demodummy3 pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)



*	************************************************************************
*	N. Adding SOx as a proxy for the demand for green public goods
*	************************************************************************

*	************************************************************************
*	a. Rio Approach
*		i. 		Model without any IR influence
*		ii. 	Model with IR (for various years)
*		iii. 	Model for OECD and non-OECD countries
*		iv. 	Model with IR*Democratization interaction (for various years)
*	************************************************************************


*	************************************************************************
*		i. Model without any IR influence
*	************************************************************************
stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
streg demo_dummy3 ir9294 gdpcapk, nohr distribution(weibull)
streg demo_dummy3 ir9294 gdpcapk pop_density_wdi noxcapita openk service1 oecd_real, nohr distribution(weibull)


*	************************************************************************
*		ii. Model with IR dummy (for various years)
*	************************************************************************

streg demo_dummy3 ir9294 ir9294_x_demod3 gdpcapk pop_density_wdi noxcapita openk service1 oecd_real, nohr distribution(weibull)
streg demo_dummy3 ir9295 ir9295_x_demod3 gdpcapk pop_density_wdi noxcapita openk service1 oecd_real, nohr distribution(weibull)
streg demo_dummy3 ir9296 ir9296_x_demod3 gdpcapk pop_density_wdi noxcapita openk service1 oecd_real, nohr distribution(weibull)
streg demo_dummy3 ir9297 ir9297_x_demod3 gdpcapk pop_density_wdi noxcapita openk service1 oecd_real, nohr distribution(weibull)




*	************************************************************************
*		iv. Model with environmental aid 
*	************************************************************************

stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox demo_dummy3 emb_av embav_x_demodummy3 gdpcapk pop_density_wdi noxcapita openk service1 oecd_real, nohr
streg demo_dummy3 emb_av embav_x_demodummy3 gdpcapk pop_density_wdi noxcapita openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy3 emb_av embav_x_demodummy3 gdpcapk pop_density_wdi noxcapita openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 emb_av embav_x_demodummy3 gdpcapk pop_density_wdi noxcapita openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 emb_av embav_x_demodummy3 gdpcapk pop_density_wdi noxcapita openk service1 oecd_real dur2, cluster(ccode)


stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox demo_dummy3 emn_av emnav_x_demodummy3 gdpcapk pop_density_wdi noxcapita openk service1 oecd_real, nohr
streg demo_dummy3 emn_av emnav_x_demodummy3 gdpcapk pop_density_wdi noxcapita openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy3 emn_av emnav_x_demodummy3 gdpcapk pop_density_wdi noxcapita openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 emn_av emnav_x_demodummy3 gdpcapk pop_density_wdi noxcapita openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 emn_av emnav_x_demodummy3 gdpcapk pop_density_wdi noxcapita openk service1 oecd_real dur2, cluster(ccode)



*	************************************************************************
*		v. Model with peer pressure 
*			1. Global peer pressure
*			2. Regional peer pressure
*	************************************************************************

*	* 1. Global peer pressure
stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
streg demo_dummy3 lsumm lsumm_x_demodummy3 gdpcapk pop_density_wdi noxcapita openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy3 lsumm lsumm_x_demodummy3 gdpcapk pop_density_wdi noxcapita openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 lsumm lsumm_x_demodummy3 gdpcapk pop_density_wdi noxcapita openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 lsumm lsumm_x_demodummy3 gdpcapk pop_density_wdi noxcapita openk service1 oecd_real dur2, cluster(ccode)


*	* 2. Continental/regional peer pressure
stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 gdpcapk pop_density_wdi noxcapita openk service1 oecd_real, nohr
streg demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 gdpcapk pop_density_wdi noxcapita openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 gdpcapk pop_density_wdi noxcapita openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 gdpcapk pop_density_wdi noxcapita openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 gdpcapk pop_density_wdi noxcapita openk service1 oecd_real dur2, cluster(ccode)



*	************************************************************************
*	O. Removing Countries that have ministries but for which the 
*	starting data is unclear (currently coded as 0)
*	************************************************************************

preserve
drop if ctry_prefname == "Botswana"
drop if ctry_prefname == "Burundi"
drop if ctry_prefname == "Cape Verde"
drop if ctry_prefname == "Comoros"
drop if ctry_prefname == "Congo"
drop if ctry_prefname == "Djibouti"
drop if ctry_prefname == "Equatorial Guinea"
drop if ctry_prefname == "Mauritania"
drop if ctry_prefname == "Sao Tome and Principe"
drop if ctry_prefname == "Somalia"

*	************************************************************************
*		i. Model without any IR influence
*	************************************************************************
stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
streg demo_dummy3 ir9294 gdpcapk, nohr distribution(weibull)
streg demo_dummy3 ir9294 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)


*	************************************************************************
*		ii. Model with IR dummy (for various years)
*	************************************************************************

streg demo_dummy3 ir9294 ir9294_x_demod3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
streg demo_dummy3 ir9295 ir9295_x_demod3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
streg demo_dummy3 ir9296 ir9296_x_demod3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
streg demo_dummy3 ir9297 ir9297_x_demod3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)


*	************************************************************************
*		iv. Model with environmental aid 
*	************************************************************************

stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox demo_dummy3 emb_av embav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr
streg demo_dummy3 emb_av embav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy3 emb_av embav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 emb_av embav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 emb_av embav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)


stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox demo_dummy3 emn_av emnav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr
streg demo_dummy3 emn_av emnav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy3 emn_av emnav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 emn_av emnav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 emn_av emnav_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)



*	************************************************************************
*		v. Model with peer pressure 
*			1. Global peer pressure
*			2. Regional peer pressure
*	************************************************************************

*	* 1. Global peer pressure
stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
streg demo_dummy3 lsumm lsumm_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy3 lsumm lsumm_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 lsumm lsumm_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 lsumm lsumm_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)


*	* 2. Continental/regional peer pressure
stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr
streg demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)

restore


*	************************************************************************
*	P. With Freedom House Index instead of Polity
*	************************************************************************


*	************************************************************************
*	a. Rio Approach
*		i. 		Model without any IR influence
*		ii. 	Model with IR (for various years)
*		iii. 	Model for OECD and non-OECD countries
*		iv. 	Model with IR*Democratization interaction (for various years)
*	************************************************************************


*	************************************************************************
*		i. Model without any IR influence
*	************************************************************************
stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)

streg democfh ir9294 gdpcapk, nohr distribution(weibull)
streg democfh ir9294 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)


*	************************************************************************
*		ii. Model with IR dummy (for various years)
*	************************************************************************

streg democfh ir9294 democfh_x_ir9294 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
streg democfh ir9295 democfh_x_ir9295 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
streg democfh ir9296 democfh_x_ir9296 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
streg democfh ir9297 democfh_x_ir9297 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)



*	************************************************************************
*		iv. Model with environmental aid 
*	************************************************************************

stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox democfh emb_av democfh_x_embav gdpcapk pop_density_wdi openk service1 oecd_real, nohr
streg democfh emb_av democfh_x_embav gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb democfh emb_av democfh_x_embav gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb democfh emb_av democfh_x_embav gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb democfh emb_av democfh_x_embav gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)


stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox democfh emn_av democfh_x_emnav gdpcapk pop_density_wdi openk service1 oecd_real, nohr
streg democfh emn_av democfh_x_emnav gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb democfh emn_av democfh_x_emnav gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb democfh emn_av democfh_x_emnav gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb democfh emn_av democfh_x_emnav gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)



*	************************************************************************
*		v. Model with peer pressure 
*			1. Global peer pressure
*			2. Regional peer pressure
*	************************************************************************

*	* 1. Global peer pressure
stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
streg democfh lsumm democfh_x_lsumm gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb democfh lsumm democfh_x_lsumm gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb democfh lsumm democfh_x_lsumm gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb democfh lsumm democfh_x_lsumm gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)


*	* 2. Continental/regional peer pressure
stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox democfh regional_proportion_envministry democfh_x_regional gdpcapk pop_density_wdi openk service1 oecd_real, nohr
streg democfh regional_proportion_envministry democfh_x_regional gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb democfh regional_proportion_envministry democfh_x_regional gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb democfh regional_proportion_envministry democfh_x_regional gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb democfh regional_proportion_envministry democfh_x_regional gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)



*	************************************************************************
*	Q. With Polity > 6 threshold
*	************************************************************************


*	************************************************************************
*	a. Rio Approach
*		i. 		Model without any IR influence
*		ii. 	Model with IR (for various years)
*		iii. 	Model for OECD and non-OECD countries
*		iv. 	Model with IR*Democratization interaction (for various years)
*	************************************************************************


*	************************************************************************
*		i. Model without any IR influence
*	************************************************************************
stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)

streg democ_alter ir9294 gdpcapk, nohr distribution(weibull)
streg democ_alter ir9294 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)


*	************************************************************************
*		ii. Model with IR dummy (for various years)
*	************************************************************************

streg democ_alter ir9294 democ_alter_x_ir9294 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
streg democ_alter ir9295 democ_alter_x_ir9295 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
streg democ_alter ir9296 democ_alter_x_ir9296 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
streg democ_alter ir9297 democ_alter_x_ir9297 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)


*	************************************************************************
*		iv. Model with environmental aid 
*	************************************************************************

stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox democ_alter emb_av democ_alter_x_embav gdpcapk pop_density_wdi openk service1 oecd_real, nohr
streg democ_alter emb_av democ_alter_x_embav gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb democ_alter emb_av democ_alter_x_embav gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb democ_alter emb_av democ_alter_x_embav gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb democ_alter emb_av democ_alter_x_embav gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)


stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox democ_alter emn_av democ_alter_x_emnav gdpcapk pop_density_wdi openk service1 oecd_real, nohr
streg democ_alter emn_av democ_alter_x_emnav gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb democ_alter emn_av democ_alter_x_emnav gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb democ_alter emn_av democ_alter_x_emnav gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb democ_alter emn_av democ_alter_x_emnav gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)


*	************************************************************************
*		v. Model with peer pressure 
*			1. Global peer pressure
*			2. Regional peer pressure
*	************************************************************************

*	* 1. Global peer pressure
stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
streg democ_alter lsumm democ_alter_x_lsumm gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb democ_alter lsumm democ_alter_x_lsumm gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb democ_alter lsumm democ_alter_x_lsumm gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb democ_alter lsumm democ_alter_x_lsumm gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)


*	* 2. Continental/regional peer pressure
stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox democ_alter regional_proportion_envministry democ_alter_x_regional gdpcapk pop_density_wdi openk service1 oecd_real, nohr
streg democ_alter regional_proportion_envministry democ_alter_x_regional gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb democ_alter regional_proportion_envministry democ_alter_x_regional gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb democ_alter regional_proportion_envministry democ_alter_x_regional gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb democ_alter regional_proportion_envministry democ_alter_x_regional gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)




*	************************************************************************
*	R. With Polity included
*	************************************************************************


*	************************************************************************
*	a. Rio Approach
*		i. 		Model without any IR influence
*		ii. 	Model with IR (for various years)
*		iii. 	Model for OECD and non-OECD countries
*		iv. 	Model with IR*Democratization interaction (for various years)
*	************************************************************************


*	************************************************************************
*		i. Model without any IR influence
*	************************************************************************
stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)

streg demo_dummy3 ir9294 polity2 gdpcapk, nohr distribution(weibull)
streg demo_dummy3 ir9294 polity2 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)


*	************************************************************************
*		ii. Model with IR dummy (for various years)
*	************************************************************************

streg demo_dummy3 ir9294 ir9294_x_demod3 polity2 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
streg demo_dummy3 ir9295 ir9295_x_demod3 polity2 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
streg demo_dummy3 ir9296 ir9296_x_demod3 polity2 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
streg demo_dummy3 ir9297 ir9297_x_demod3 polity2 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)



*	************************************************************************
*		iv. Model with environmental aid 
*	************************************************************************

stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox demo_dummy3 emb_av embav_x_demodummy3 polity2 gdpcapk pop_density_wdi openk service1 oecd_real, nohr
streg demo_dummy3 emb_av embav_x_demodummy3 polity2 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy3 emb_av embav_x_demodummy3 polity2 gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 emb_av embav_x_demodummy3 polity2 gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 emb_av embav_x_demodummy3 polity2 gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)


stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox demo_dummy3 emn_av emnav_x_demodummy3 polity2 gdpcapk pop_density_wdi openk service1 oecd_real, nohr
streg demo_dummy3 emn_av emnav_x_demodummy3 polity2 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy3 emn_av emnav_x_demodummy3 polity2 gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 emn_av emnav_x_demodummy3 polity2 gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 emn_av emnav_x_demodummy3 polity2 gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)



*	************************************************************************
*		v. Model with peer pressure 
*			1. Global peer pressure
*			2. Regional peer pressure
*	************************************************************************

*	* 1. Global peer pressure
stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
streg demo_dummy3 lsumm lsumm_x_demodummy3 polity2 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy3 lsumm lsumm_x_demodummy3 polity2 gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 lsumm lsumm_x_demodummy3 polity2 gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 lsumm lsumm_x_demodummy3 polity2 gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)


*	* 2. Continental/regional peer pressure
stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 polity2 gdpcapk pop_density_wdi openk service1 oecd_real, nohr
streg demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 polity2 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 polity2 gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 polity2 gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 polity2 gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)




*	************************************************************************
*	S. With autocratization
*	************************************************************************

*	************************************************************************
*	a. Rio Approach
*		i. 		Model without any IR influence
*		ii. 	Model with IR (for various years)
*		iii. 	Model for OECD and non-OECD countries
*		iv. 	Model with IR*Democratization interaction (for various years)
*	************************************************************************


*	************************************************************************
*		i. Model without any IR influence
*	************************************************************************
stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)

streg demo_dummy3 ir9294 auto_dummy3 gdpcapk, nohr distribution(weibull)
streg demo_dummy3 ir9294 auto_dummy3 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)


*	************************************************************************
*		ii. Model with IR dummy (for various years)
*	************************************************************************

streg demo_dummy3 ir9294 ir9294_x_demod3 auto_dummy3 auto_dummy3_x_ir9294 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
streg demo_dummy3 ir9295 ir9295_x_demod3 auto_dummy3 auto_dummy3_x_ir9295 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
streg demo_dummy3 ir9296 ir9296_x_demod3 auto_dummy3 auto_dummy3_x_ir9296 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
streg demo_dummy3 ir9297 ir9297_x_demod3 auto_dummy3 auto_dummy3_x_ir9297 gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)




*	************************************************************************
*		iv. Model with environmental aid 
*	************************************************************************

stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox demo_dummy3 emb_av embav_x_demodummy3 auto_dummy3 auto_dummy3_x_embav gdpcapk pop_density_wdi openk service1 oecd_real, nohr
streg demo_dummy3 emb_av embav_x_demodummy3 auto_dummy3 auto_dummy3_x_embav gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy3 emb_av embav_x_demodummy3 auto_dummy3 auto_dummy3_x_embav gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 emb_av embav_x_demodummy3 auto_dummy3 auto_dummy3_x_embav gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 emb_av embav_x_demodummy3 auto_dummy3 auto_dummy3_x_embav gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)


stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox demo_dummy3 emn_av emnav_x_demodummy3 auto_dummy3 auto_dummy3_x_emnav gdpcapk pop_density_wdi openk service1 oecd_real, nohr
streg demo_dummy3 emn_av emnav_x_demodummy3 auto_dummy3 auto_dummy3_x_emnav gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy3 emn_av emnav_x_demodummy3 auto_dummy3 auto_dummy3_x_emnav gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 emn_av emnav_x_demodummy3 auto_dummy3 auto_dummy3_x_emnav gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 emn_av emnav_x_demodummy3 auto_dummy3 auto_dummy3_x_emnav gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)



*	************************************************************************
*		v. Model with peer pressure 
*			1. Global peer pressure
*			2. Regional peer pressure
*	************************************************************************

*	* 1. Global peer pressure
stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
streg demo_dummy3 lsumm lsumm_x_demodummy3 auto_dummy3 auto_dummy3_x_lsumm gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy3 lsumm lsumm_x_demodummy3 auto_dummy3 auto_dummy3_x_lsumm gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 lsumm lsumm_x_demodummy3 auto_dummy3 auto_dummy3_x_lsumm gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 lsumm lsumm_x_demodummy3 auto_dummy3 auto_dummy3_x_lsumm gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)


*	* 2. Continental/regional peer pressure
stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 auto_dummy3 auto_dummy3_x_regional gdpcapk pop_density_wdi openk service1 oecd_real, nohr
streg demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 auto_dummy3 auto_dummy3_x_regional gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 auto_dummy3 auto_dummy3_x_regional gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 auto_dummy3 auto_dummy3_x_regional gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 auto_dummy3 auto_dummy3_x_regional gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)



*	************************************************************************
*	T. With industrialization
*	************************************************************************


*	************************************************************************
*	a. Rio Approach
*		i. 		Model without any IR influence
*		ii. 	Model with IR (for various years)
*		iii. 	Model for OECD and non-OECD countries
*		iv. 	Model with IR*Democratization interaction (for various years)
*	************************************************************************


*	************************************************************************
*		i. Model without any IR influence
*	************************************************************************
stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)

streg demo_dummy3 ir9294 gdpcapk, nohr distribution(weibull)
streg demo_dummy3 ir9294 gdpcapk pop_density_wdi openk service1 industry_pcgdp_wdi oecd_real, nohr distribution(weibull)

*	************************************************************************
*		ii. Model with IR dummy (for various years)
*	************************************************************************

streg demo_dummy3 ir9294 ir9294_x_demod3 gdpcapk pop_density_wdi openk service1 industry_pcgdp_wdi oecd_real, nohr distribution(weibull)
streg demo_dummy3 ir9295 ir9295_x_demod3 gdpcapk pop_density_wdi openk service1 industry_pcgdp_wdi oecd_real, nohr distribution(weibull)
streg demo_dummy3 ir9296 ir9296_x_demod3 gdpcapk pop_density_wdi openk service1 industry_pcgdp_wdi oecd_real, nohr distribution(weibull)
streg demo_dummy3 ir9297 ir9297_x_demod3 gdpcapk pop_density_wdi openk service1 industry_pcgdp_wdi oecd_real, nohr distribution(weibull)



*	************************************************************************
*		iv. Model with environmental aid 
*	************************************************************************

stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox demo_dummy3 emb_av embav_x_demodummy3 gdpcapk pop_density_wdi openk service1 industry_pcgdp_wdi oecd_real, nohr
streg demo_dummy3 emb_av embav_x_demodummy3 gdpcapk pop_density_wdi openk service1 industry_pcgdp_wdi oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy3 emb_av embav_x_demodummy3 gdpcapk pop_density_wdi openk service1 industry_pcgdp_wdi oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 emb_av embav_x_demodummy3 gdpcapk pop_density_wdi openk service1 industry_pcgdp_wdi oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 emb_av embav_x_demodummy3 gdpcapk pop_density_wdi openk service1 industry_pcgdp_wdi oecd_real dur2, cluster(ccode)


stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox demo_dummy3 emn_av emnav_x_demodummy3 gdpcapk pop_density_wdi openk service1 industry_pcgdp_wdi oecd_real, nohr
streg demo_dummy3 emn_av emnav_x_demodummy3 gdpcapk pop_density_wdi openk service1 industry_pcgdp_wdi oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy3 emn_av emnav_x_demodummy3 gdpcapk pop_density_wdi openk service1 industry_pcgdp_wdi oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 emn_av emnav_x_demodummy3 gdpcapk pop_density_wdi openk service1 industry_pcgdp_wdi oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 emn_av emnav_x_demodummy3 gdpcapk pop_density_wdi openk service1 industry_pcgdp_wdi oecd_real dur2, cluster(ccode)



*	************************************************************************
*		v. Model with peer pressure 
*			1. Global peer pressure
*			2. Regional peer pressure
*	************************************************************************

*	* 1. Global peer pressure
stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
streg demo_dummy3 lsumm lsumm_x_demodummy3 gdpcapk pop_density_wdi openk service1 industry_pcgdp_wdi oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy3 lsumm lsumm_x_demodummy3 gdpcapk pop_density_wdi openk service1 industry_pcgdp_wdi oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 lsumm lsumm_x_demodummy3 gdpcapk pop_density_wdi openk service1 industry_pcgdp_wdi oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 lsumm lsumm_x_demodummy3 gdpcapk pop_density_wdi openk service1 industry_pcgdp_wdi oecd_real dur2, cluster(ccode)


*	* 2. Continental/regional peer pressure
stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 gdpcapk pop_density_wdi openk service1 industry_pcgdp_wdi oecd_real, nohr
streg demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 gdpcapk pop_density_wdi openk service1 industry_pcgdp_wdi oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 gdpcapk pop_density_wdi openk service1 industry_pcgdp_wdi oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 gdpcapk pop_density_wdi openk service1 industry_pcgdp_wdi oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 gdpcapk pop_density_wdi openk service1 industry_pcgdp_wdi oecd_real dur2, cluster(ccode)



*	************************************************************************
*	4. Merging with the data on green NGO's
*	************************************************************************

preserve

use "/Users/michaelaklin/Documents/Research/aklin_urpelainen_2010_envministry/data/aklin_urpelainen_capacity_031710_v1.dta"
*use "/Users/michaelaklin/Documents/Research/data/pik_master_dataset/pik_master_150310_v3.dta"
rename cow_nr cowcode
drop if cowcode == .
merge 1:1 cowcode year using "/Users/michaelaklin/Documents/Research/data/pik_master_dataset/pik_master_subdatasets/amanda/Amanda.dta"
drop if _merge == 2
rename cowcode cow_nr


*	************************************************************************
*	a. Rio Approach
*		i. 		Model without any IR influence
*		ii. 	Model with IR (for various years)
*		iii. 	Model for OECD and non-OECD countries
*		iv. 	Model with IR*Democratization interaction (for various years)
*	************************************************************************


*	************************************************************************
*		i. Model without any IR influence
*	************************************************************************
stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)

streg demo_dummy3 ir9294 ENVIROsecretariatlocation gdpcapk, nohr distribution(weibull)
streg demo_dummy3 ir9294 ENVIROsecretariatlocation gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)


*	************************************************************************
*		ii. Model with IR dummy (for various years)
*	************************************************************************

streg demo_dummy3 ir9294 ir9294_x_demod3 ENVIROsecretariatlocation gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
streg demo_dummy3 ir9295 ir9295_x_demod3 ENVIROsecretariatlocation gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
streg demo_dummy3 ir9296 ir9296_x_demod3 ENVIROsecretariatlocation gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
streg demo_dummy3 ir9297 ir9297_x_demod3 ENVIROsecretariatlocation gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)


*	************************************************************************
*		iv. Model with environmental aid 
*	************************************************************************

stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox demo_dummy3 emb_av embav_x_demodummy3 ENVIROsecretariatlocation gdpcapk pop_density_wdi openk service1 oecd_real, nohr
streg demo_dummy3 emb_av embav_x_demodummy3 ENVIROsecretariatlocation gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy3 emb_av embav_x_demodummy3 ENVIROsecretariatlocation gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 emb_av embav_x_demodummy3 ENVIROsecretariatlocation gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 emb_av embav_x_demodummy3 ENVIROsecretariatlocation gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)


stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox demo_dummy3 emn_av emnav_x_demodummy3 ENVIROsecretariatlocation gdpcapk pop_density_wdi openk service1 oecd_real, nohr
streg demo_dummy3 emn_av emnav_x_demodummy3 ENVIROsecretariatlocation gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy3 emn_av emnav_x_demodummy3 ENVIROsecretariatlocation gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 emn_av emnav_x_demodummy3 ENVIROsecretariatlocation gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 emn_av emnav_x_demodummy3 ENVIROsecretariatlocation gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)


*	************************************************************************
*		v. Model with peer pressure 
*			1. Global peer pressure
*			2. Regional peer pressure
*	************************************************************************

*	* 1. Global peer pressure
stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
streg demo_dummy3 lsumm lsumm_x_demodummy3 ENVIROsecretariatlocation gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy3 lsumm lsumm_x_demodummy3 ENVIROsecretariatlocation gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 lsumm lsumm_x_demodummy3 ENVIROsecretariatlocation gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 lsumm lsumm_x_demodummy3 ENVIROsecretariatlocation gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)


*	* 2. Continental/regional peer pressure
stset time, id(ctry_prefname) failure(env_ministryonset_realb==1)
stcox demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 ENVIROsecretariatlocation gdpcapk pop_density_wdi openk service1 oecd_real, nohr
streg demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 ENVIROsecretariatlocation gdpcapk pop_density_wdi openk service1 oecd_real, nohr distribution(weibull)
xtset ccode year
logit env_ministryonset_realb demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 ENVIROsecretariatlocation gdpcapk pop_density_wdi openk service1 oecd_real lowesst, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 ENVIROsecretariatlocation gdpcapk pop_density_wdi openk service1 oecd_real logdur, cluster(ccode)
logit env_ministryonset_realb demo_dummy3 regional_proportion_envministry regionalpe_x_demodummy3 ENVIROsecretariatlocation gdpcapk pop_density_wdi openk service1 oecd_real dur2, cluster(ccode)

restore

