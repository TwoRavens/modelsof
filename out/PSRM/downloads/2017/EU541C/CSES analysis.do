*************************************************************************************************
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*			                       Replication file for:     		           	        	    *
*       "The Effects of Government System Fractionalization on Satisfaction with Democracy"     *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*																						 		*			
* Author: 			Pablo Christmann and Mariano Torcal                                   		*
* Contact: 			pablo.christmann@upf.edu                                              		*
* Date: 			16th of May 2017                                                     		*
* Version:			Stata 13.1                                                              	*                                                                          
* Dataset:          CSES.dta                                                					*		
* Logfile: 			CSES analysis.txt															*
*																								*
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*************************************************************************************************

set more off

*** Install required packages
ssc install outreg2
ssc install norm

*** Set directory to the location where replication files have been saved, for example:
cd "C:\PSRM Replication Files"

*** Opening log
capture log close
log using CSES_analysis.log, name(CSES_Log) replace 

*** Load TSCS panel dataset
use "CSES.dta", clear

*************************************************************************************************
*** Generate 'between' terns (discarding all longitutional information at the national level) ***
*************************************************************************************************
*** Notes: The between terms are used to discard all longitudional information at the contextual level, only country averages will be compared.
***        The estimation of interaction terms, squared terms and logged variables need to be done before with the original data!

*** Generation of squared term
gen govfrac_sq=govfrac*govfrac
gen ENEP1_sq=ENEP1*ENEP1
gen GALLAGH_sq=GALLAGH*GALLAGH

*** Generation of interaction term
gen govfrac_GALLAGH=govfrac*GALLAGH
gen ENEP1_gallager=ENEP1*GALLAGH

*** Generation of logged term
gen tier1_avemag_log=log(tier1_avemag)

*** Between terms
egen gpd_percap_mean = mean(wdi_gdppccur), by(country)
egen growth_rate_mean = mean(growth_rate), by(country)
egen ENEP1_mean = mean(ENEP1), by(country)
egen ENPP1_mean = mean(ENPP1), by(country)
egen Gallagindex_mean = mean(GALLAGH), by(country)
egen GALLAGH_sq_mean = mean(GALLAGH_sq), by(country)
egen GOVFRAC_mean = mean(govfrac), by(country)
egen icrg_qog_mean = mean(icrg_qog), by(country)
egen govfrac_sq_mean = mean(govfrac_sq), by(country)
egen ENEP1_sq_mean = mean(ENEP1_sq), by(country)
egen govfrac_GALLAGH_mean = mean(govfrac_GALLAGH), by(country)
egen ENEP1_gallager_mean = mean(ENEP1_gallager), by(country)
egen tier1_avemag_mean = mean(tier1_avemag), by(country)
egen tier1_avemag_log_mean = mean(tier1_avemag_log), by(country)

**********************************************
*** Standardization of Continous Variables ***
**********************************************
*** Note: All standardized variables have the prefix zee_ 
norm gpd_percap_mean, method(zee)
norm growth_rate_mean, method(zee)
norm ENEP1_mean, method(zee)
norm ENEP1_sq_mean, method(zee)
norm ENPP1_mean, method(zee)
norm ENEP1_gallager_mean, method(zee)
norm Gallagindex_mean, method(zee)
norm GALLAGH_sq_mean, method(zee)
norm GOVFRAC_mean, method(zee)
norm icrg_qog_mean , method(zee)
norm tier1_avemag_mean , method(zee)
norm tier1_avemag_log_mean , method(zee)
norm govfrac_GALLAGH_mean , method(zee)
norm Age , method(zee)
norm Household_Income , method(zee)
norm Left_Right_Self , method(zee)
norm political_efficacy , method(zee)
norm Congruence , method(zee)
norm repesentation_deficit, method(zee)

********************************************************
*** Table 2: Multilevel Analysis of the CSES Dataset ***
********************************************************
*** Notes: estat ic and estat icc are used to estimate the AIC and the Intraclass Correlation Coefficient after each model
***        The country-year level=election level
***        The table has been created based on the information conveyed by outreg2 and the Stata output (Variance components, Log likelihood, AIC and ICCs)

*** Model 4 (Null)
xtmixed  SWD  || country: || country_year:  , mle  variance
outreg2 using "Table 2.out",   replace ctitle(Model 4)  dec(2) onecol alpha(0.001,0.01,0.05) symbol(***,**,*)  sideway
estat ic // Get AIC values
estat icc // Get Intraclass correlation coefficient (ICC) for the country-level
display 1-0.1833896 // Estimate ICC for the respondent level
display 0.1833896-0.140175 // Estimate ICC for the election level

*** Notes on the ICCs: estat icc provides two values (country and elec_id|country). The ICC values for "country" provides information about the share of variation that can 
*   be attributed to the county-level (=ICC Country in Table 2, Model 4). 
*   "country_year|country" provides the information about how much variation can be attributed jointly to to the country-level and the election-level(election-level=country-year in this dataset).
*   To estimate the ICC for the respondent level, simply substract the variation that can be attributed to the country-level and election-level (country_year|country) from the total varition 1.
*   ICC respondent = 1-0.1833896 = 0.8166104.
*   To get the ICC for the election-level, substract the variation attributable to the country-level (country) from the shared variation of the country and election-level (elec_id|country).
*   ICC Election = 0.1833896-0.140175 = 0.0432146

*** Model 5: Individual Level
xtmixed  SWD zee_Age i.Gender b3.Education zee_Household_Income zee_Left_Right_Self zee_political_efficacy c.zee_Congruence i.party_identification  b1.Winner_PM_Cat zee_repesentation_deficit || country: || country_year:  , mle  variance
outreg2 using "Table 2.out",   append ctitle(Model 5)  dec(2) onecol alpha(0.001,0.01,0.05) symbol(***,**,*)  sideway
estat ic
estat icc

*** Model 6: Individual Level + Contextual Level
xtmixed  SWD zee_Age i.Gender b3.Education zee_Household_Income zee_Left_Right_Self zee_political_efficacy c.zee_Congruence i.party_identification  b1.Winner_PM_Cat zee_repesentation_deficit zee_GOVFRAC_mean zee_Gallagindex_mean  i.regime zee_gpd_percap_mean zee_growth_rate_mean zee_icrg_qog_mean || country: || country_year:  , mle  variance
outreg2 using "Table 2.out",   append ctitle(Model 6)  dec(2) onecol alpha(0.001,0.01,0.05) symbol(***,**,*)  sideway
estat ic
estat icc

*** Model 7: Individual Level + Contextual Level + Cross-Level Interaction
xtmixed  SWD zee_Age i.Gender b3.Education zee_Household_Income zee_Left_Right_Self zee_political_efficacy c.zee_Congruence i.party_identification  b1.Winner_PM_Cat##c.zee_GOVFRAC_mean c.zee_repesentation_deficit##c.zee_GOVFRAC_mean zee_Gallagindex_mean  i.regime zee_gpd_percap_mean zee_growth_rate_mean zee_icrg_qog_mean || country: || country_year:  , mle  variance
outreg2 using "Table 2.out",   append ctitle(Model 7)  dec(2) onecol alpha(0.001,0.01,0.05) symbol(***,**,*)  sideway
estat ic
estat icc

******************************
*** Generation of Figure 3 ***
******************************
*** Notes: For better interpretation the marginal effects plots are based on unstandardized coefficients for government fractionalization.
***        Figure 3 has been formatted with the Graph Editor afterwards. The corresponding .gph files have been uploaded in the folder "Figures and Tables".

*** Model 7: Individual Level + Contextual Level + Cross-Level Interaction
xtmixed  SWD zee_Age i.Gender b3.Education zee_Household_Income zee_Left_Right_Self zee_political_efficacy c.zee_Congruence i.party_identification  b1.Winner_PM_Cat##c.GOVFRAC_mean c.zee_repesentation_deficit##c.GOVFRAC_mean zee_Gallagindex_mean  i.regime zee_gpd_percap_mean zee_growth_rate_mean zee_icrg_qog_mean || country: || country_year:  , mle  variance

margins, dydx(Winner_PM_Cat) at(GOVFRAC_mean=(0 (0.1) 0.8)) vsquish atmeans 
marginsplot, recast(line) recastci(rarea) yline(0)
graph save "Figure 3_Winning and Losing.gph", replace

margins, dydx(zee_repesentation_deficit) at(GOVFRAC_mean=(0 (0.1) 0.8)) vsquish atmeans 
marginsplot, recast(line) recastci(rarea) yline(0)
graph save "Figure 3_Representation Deficit.gph", replace

*******************************************************************************
*** Table E: Electoral System and Average District Magnitude (CSES Dataset) ***
*******************************************************************************
*** Model 10 (Electoral System)
xtmixed  SWD zee_Age i.Gender b3.Education zee_Household_Income zee_Left_Right_Self zee_political_efficacy c.zee_Congruence i.party_identification  b1.Winner_PM_Cat zee_repesentation_deficit i.gol_est  i.regime zee_gpd_percap_mean zee_growth_rate_mean zee_icrg_qog_mean || country: || country_year:  , mle  variance
outreg2 using "Table E.out",   replace ctitle(Model 10)  dec(2) onecol alpha(0.001,0.01,0.05) symbol(***,**,*)  sideway
estat ic
estat icc

*** Model 11 (Average District Magnitude)
xtmixed  SWD zee_Age i.Gender b3.Education zee_Household_Income zee_Left_Right_Self zee_political_efficacy c.zee_Congruence i.party_identification  b1.Winner_PM_Cat zee_repesentation_deficit zee_tier1_avemag_mean  i.regime zee_gpd_percap_mean zee_growth_rate_mean zee_icrg_qog_mean || country: || country_year:  , mle  variance
outreg2 using "Table E.out",   append ctitle(Model 11)  dec(2) onecol alpha(0.001,0.01,0.05) symbol(***,**,*)  sideway
estat ic
estat icc

**********************************************************************************************************
*** Table G: Party/Government System Fractionalization and Electoral Disproportionality (CSES Dataset) ***
**********************************************************************************************************
*** Model 19 (Gallagher Index)
xtmixed  SWD zee_Age i.Gender b3.Education zee_Household_Income zee_Left_Right_Self zee_political_efficacy c.zee_Congruence i.party_identification  b1.Winner_PM_Cat zee_repesentation_deficit zee_Gallagindex_mean  i.regime zee_gpd_percap_mean zee_growth_rate_mean zee_icrg_qog_mean || country: || country_year:  , mle  variance
outreg2 using "Table G.out",   replace ctitle(Model 19)  dec(2) onecol alpha(0.001,0.01,0.05) symbol(***,**,*)  sideway
estat ic
estat icc

*** Model 20 (Gallagher Index squared)
xtmixed  SWD zee_Age i.Gender b3.Education zee_Household_Income zee_Left_Right_Self zee_political_efficacy c.zee_Congruence i.party_identification  b1.Winner_PM_Cat zee_repesentation_deficit zee_Gallagindex_mean zee_GALLAGH_sq_mean i.regime zee_gpd_percap_mean zee_growth_rate_mean zee_icrg_qog_mean || country: || country_year:  , mle  variance
outreg2 using "Table G.out",   append ctitle(Model 20)  dec(2) onecol alpha(0.001,0.01,0.05) symbol(***,**,*)  sideway
estat ic
estat icc

*** Model 21 (ENEP)
xtmixed  SWD zee_Age i.Gender b3.Education zee_Household_Income zee_Left_Right_Self zee_political_efficacy c.zee_Congruence i.party_identification  b1.Winner_PM_Cat zee_repesentation_deficit zee_ENEP1_mean  i.regime zee_gpd_percap_mean zee_growth_rate_mean zee_icrg_qog_mean || country: || country_year:  , mle  variance
outreg2 using "Table G.out",   append ctitle(Model 21)  dec(2) onecol alpha(0.001,0.01,0.05) symbol(***,**,*)  sideway
estat ic
estat icc

*** Model 22 (ENEP squared)
xtmixed  SWD zee_Age i.Gender b3.Education zee_Household_Income zee_Left_Right_Self zee_political_efficacy c.zee_Congruence i.party_identification  b1.Winner_PM_Cat zee_repesentation_deficit zee_ENEP1_mean zee_ENEP1_sq_mean i.regime zee_gpd_percap_mean zee_growth_rate_mean zee_icrg_qog_mean || country: || country_year:  , mle  variance
outreg2 using "Table G.out",   append ctitle(Model 22)  dec(2) onecol alpha(0.001,0.01,0.05) symbol(***,**,*)  sideway
estat ic
estat icc

*** Model 23 (ENEP, Gallagher Index)
xtmixed  SWD zee_Age i.Gender b3.Education zee_Household_Income zee_Left_Right_Self zee_political_efficacy c.zee_Congruence i.party_identification  b1.Winner_PM_Cat zee_repesentation_deficit zee_ENEP1_mean  zee_Gallagindex_mean i.regime zee_gpd_percap_mean zee_growth_rate_mean zee_icrg_qog_mean || country: || country_year:  , mle  variance
outreg2 using "Table G.out",   append ctitle(Model 23)  dec(2) onecol alpha(0.001,0.01,0.05) symbol(***,**,*)  sideway
estat ic
estat icc

*** Model 24 (ENEP * Gallagher Index)
xtmixed  SWD zee_Age i.Gender b3.Education zee_Household_Income zee_Left_Right_Self zee_political_efficacy c.zee_Congruence i.party_identification  b1.Winner_PM_Cat zee_repesentation_deficit zee_ENEP1_mean  zee_Gallagindex_mean zee_ENEP1_gallager_mean i.regime zee_gpd_percap_mean zee_growth_rate_mean zee_icrg_qog_mean || country: || country_year:  , mle  variance
outreg2 using "Table G.out",   append ctitle(Model 24)  dec(2) onecol alpha(0.001,0.01,0.05) symbol(***,**,*)  sideway
estat ic
estat icc

*** Model 25 (Government Fractionalization)
xtmixed  SWD zee_Age i.Gender b3.Education zee_Household_Income zee_Left_Right_Self zee_political_efficacy c.zee_Congruence i.party_identification  b1.Winner_PM_Cat zee_repesentation_deficit zee_GOVFRAC_mean i.regime zee_gpd_percap_mean zee_growth_rate_mean zee_icrg_qog_mean || country: || country_year:  , mle  variance
outreg2 using "Table G.out",   append ctitle(Model 25)  dec(2) onecol alpha(0.001,0.01,0.05) symbol(***,**,*)  sideway
estat ic
estat icc

*** Model 26 (Government Fractionalization * Gallagher Index)
xtmixed  SWD zee_Age i.Gender b3.Education zee_Household_Income zee_Left_Right_Self zee_political_efficacy c.zee_Congruence i.party_identification  b1.Winner_PM_Cat zee_repesentation_deficit zee_GOVFRAC_mean  zee_Gallagindex_mean zee_govfrac_GALLAGH_mean i.regime zee_gpd_percap_mean zee_growth_rate_mean zee_icrg_qog_mean || country: || country_year:  , mle  variance
outreg2 using "Table G.out",   append ctitle(Model 26)  dec(2) onecol alpha(0.001,0.01,0.05) symbol(***,**,*)  sideway
estat ic
estat icc

***********************************************************************************************
*** Table I: Government System Fractionalization (CSES Dataset, Parliamentary Systems Only) ***
***********************************************************************************************
*** Keep only parliamentary systems, create temporary file of the used dataset
save "CSES_temp.dta", replace

drop if regime==2 // drop if Presidential
drop if regime==1 // drop if Semi-Presidential

*** Model 28: Individual Level + Contextual Level
xtmixed  SWD zee_Age i.Gender b3.Education zee_Household_Income zee_Left_Right_Self zee_political_efficacy c.zee_Congruence i.party_identification  b1.Winner_PM_Cat zee_repesentation_deficit zee_GOVFRAC_mean zee_Gallagindex_mean  i.regime zee_gpd_percap_mean zee_growth_rate_mean zee_icrg_qog_mean || country: || country_year:  , mle  variance
outreg2 using "Table I.out",   replace ctitle(Model 28)  dec(2) onecol alpha(0.001,0.01,0.05) symbol(***,**,*)  sideway
estat ic
estat icc

*** Model 29: Individual Level + Contextual Level + Cross-Level Interaction
xtmixed  SWD zee_Age i.Gender b3.Education zee_Household_Income zee_Left_Right_Self zee_political_efficacy c.zee_Congruence i.party_identification  b1.Winner_PM_Cat##c.zee_GOVFRAC_mean c.zee_repesentation_deficit##c.zee_GOVFRAC_mean zee_Gallagindex_mean  i.regime zee_gpd_percap_mean zee_growth_rate_mean zee_icrg_qog_mean || country: || country_year:  , mle  variance
outreg2 using "Table I.out",   append ctitle(Model 29)  dec(2) onecol alpha(0.001,0.01,0.05) symbol(***,**,*)  sideway
estat ic
estat icc

use "CSES_temp.dta", clear // restore data


************************************************
************************************************
*** End of Analysis Reported in the Article  ***
************************************************
************************************************

***********************************************************************************
*** Additional Robustness Checks mentioned in the Supplementary Online Appendix ***
***********************************************************************************
*** Notes: 	We performed three additional robustness checks for the results presented in Table 2 which we describe only in the Appendix. 
***        	1.) Comparison of robust standard errors,
***			2.) analysis the errors u0 (country intercept), control for influential cases at the country level
***			3.) Estimation of an ordered probit multilevel regression

******************************************
*** Table 2: 1.)Robust Standard Errors ***
******************************************
*** Model 6: Individual Level + Contextual Level
xtmixed  SWD zee_Age i.Gender b3.Education zee_Household_Income zee_Left_Right_Self zee_political_efficacy c.zee_Congruence i.party_identification  b1.Winner_PM_Cat zee_repesentation_deficit zee_GOVFRAC_mean zee_Gallagindex_mean  i.regime zee_gpd_percap_mean zee_growth_rate_mean zee_icrg_qog_mean || country: || country_year:  , mle robust variance

*** Model 7: Individual Level + Contextual Level + Cross-Level 
xtmixed  SWD zee_Age i.Gender b3.Education zee_Household_Income zee_Left_Right_Self zee_political_efficacy c.zee_Congruence i.party_identification  b1.Winner_PM_Cat##c.zee_GOVFRAC_mean c.zee_repesentation_deficit##c.zee_GOVFRAC_mean zee_Gallagindex_mean  i.regime zee_gpd_percap_mean zee_growth_rate_mean zee_icrg_qog_mean || country: || country_year:  , mle robust variance

*******************************************
*** Table 2: 2.) Analyzing u0 (Country) ***
*******************************************
*** Create temporary file of the used dataset
save "CSES_temp.dta", replace

************************************************
*** Model 6: Individual Level + Contextual Level
xtmixed  SWD zee_Age i.Gender b3.Education zee_Household_Income zee_Left_Right_Self zee_political_efficacy c.zee_Congruence i.party_identification  b1.Winner_PM_Cat zee_repesentation_deficit zee_GOVFRAC_mean zee_Gallagindex_mean  i.regime zee_gpd_percap_mean zee_growth_rate_mean zee_icrg_qog_mean || country: || country_year:  , mle variance

* Search for influential cases at the country level
predict u_country u_election, reffects 
sort u_country
gen rank0= _n
bysort country: egen secuencia0=seq()
scatter u_country rank0 if secuencia0==1, mlabel(country) yline(0) // Denmark, Iceland, South Korea, Israel
twoway (scatter u_country zee_GOVFRAC_mean  if secuencia0==1, mlabel(country) sort) (lfit u_country zee_GOVFRAC_mean if secuencia0==1, sort) 
twoway (scatter u_country zee_Gallagindex_mean  if secuencia0==1, mlabel(country) sort) (lfit u_country zee_Gallagindex_mean if secuencia0==1, sort) 

* gen country dummies
gen Denmark = 0
replace Denmark = 1 if country=="Denmark"
gen Israel = 0
replace Israel = 1 if country=="Israel"
gen South_Korea = 0
replace South_Korea = 1 if country=="South Korea"
gen Iceland = 0
replace Iceland = 1 if country=="Iceland"

* Reestimate Model 6: Results are robust
xtmixed  SWD zee_Age i.Gender b3.Education zee_Household_Income zee_Left_Right_Self zee_political_efficacy c.zee_Congruence i.party_identification  b1.Winner_PM_Cat zee_repesentation_deficit zee_GOVFRAC_mean zee_Gallagindex_mean  i.regime zee_gpd_percap_mean zee_growth_rate_mean zee_icrg_qog_mean ///
Denmark Israel South_Korea Iceland || country: || country_year:  , mle variance

use "CSES_temp.dta", clear // restore data

**************************************************************
*** Model 7: Individual Level + Contextual Level + Cross-Level 
xtmixed  SWD zee_Age i.Gender b3.Education zee_Household_Income zee_Left_Right_Self zee_political_efficacy c.zee_Congruence i.party_identification  b1.Winner_PM_Cat##c.zee_GOVFRAC_mean c.zee_repesentation_deficit##c.zee_GOVFRAC_mean zee_Gallagindex_mean  i.regime zee_gpd_percap_mean zee_growth_rate_mean zee_icrg_qog_mean || country: || country_year:  , mle variance

* Search for influential cases at the country level
predict u_country u_election, reffects 
sort u_country
gen rank0= _n
bysort country: egen secuencia0=seq()
scatter u_country rank0 if secuencia0==1, mlabel(country) yline(0) // Denmark, Iceland, South Korea, Israel
twoway (scatter u_country zee_GOVFRAC_mean  if secuencia0==1, mlabel(country) sort) (lfit u_country zee_GOVFRAC_mean if secuencia0==1, sort) 
twoway (scatter u_country zee_Gallagindex_mean  if secuencia0==1, mlabel(country) sort) (lfit u_country zee_Gallagindex_mean if secuencia0==1, sort) 

* gen country dummies
gen Denmark = 0
replace Denmark = 1 if country=="Denmark"
gen Israel = 0
replace Israel = 1 if country=="Israel"
gen South_Korea = 0
replace South_Korea = 1 if country=="South Korea"
gen Iceland = 0
replace Iceland = 1 if country=="Iceland"
gen United_Kingdom = 0
replace United_Kingdom = 1 if country=="United Kingdom"

* Reestimate Model 7: Results are robust
xtmixed  SWD zee_Age i.Gender b3.Education zee_Household_Income zee_Left_Right_Self zee_political_efficacy c.zee_Congruence i.party_identification  b1.Winner_PM_Cat##c.zee_GOVFRAC_mean c.zee_repesentation_deficit##c.zee_GOVFRAC_mean zee_Gallagindex_mean  i.regime zee_gpd_percap_mean zee_growth_rate_mean zee_icrg_qog_mean ///
Denmark Israel South_Korea Iceland United_Kingdom || country: || country_year:  , mle  variance

use "CSES_temp.dta", clear // restore data

********************************************************
*** Table 2: 3.)Ordered Probit Multilevel Regression ***
********************************************************
*** Model 6: Individual Level + Contextual Level
meologit  SWD zee_Age i.Gender b3.Education zee_Household_Income zee_Left_Right_Self zee_political_efficacy c.zee_Congruence i.party_identification  b1.Winner_PM_Cat zee_repesentation_deficit zee_GOVFRAC_mean zee_Gallagindex_mean  i.regime zee_gpd_percap_mean zee_growth_rate_mean zee_icrg_qog_mean || country: || country_year: 
estat ic

*** Model 7: Individual Level + Contextual Level + Cross-Level Interaction
meologit  SWD zee_Age i.Gender b3.Education zee_Household_Income zee_Left_Right_Self zee_political_efficacy c.zee_Congruence i.party_identification  b1.Winner_PM_Cat##c.zee_GOVFRAC_mean c.zee_repesentation_deficit##c.zee_GOVFRAC_mean zee_Gallagindex_mean  i.regime zee_gpd_percap_mean zee_growth_rate_mean zee_icrg_qog_mean || country: || country_year:  
estat ic

***************************************************************************
*** Results for Table 2 are robust on every tested aspect, end analysis ***
***************************************************************************

log close CSES_Log

