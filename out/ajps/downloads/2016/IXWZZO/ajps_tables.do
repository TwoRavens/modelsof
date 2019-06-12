/****************************/
// AJPS Publication Tables
// This do file uses Stata 14 to produce all of the tables for
// Foreign Aid and the Politics of Undeserved Credit Claiming
// Cesi Cruz and Christina Schneider
//
// For questions, contact Cesi Cruz [cesi.cruz@ubc.ca]
//
// Output and Display Packages: 
// 		ESTOUT: Ben Jann (2007) Making Regression Tables Simplified.
// 
// Analytical Packages:
// 		FITSTAT: J. Scott Long and Jeremy Freese (2001) Stata Module to Compute Fit Statistics for Single Equation Regression Models. 
//
// All packages can be directly installed from the STATA console using "findit [package name]" or "ssc install [package name]"
// 		ESTOUT can be downloaded directly from  http://repec.org/bocode/e/estout/
// 		FITSTAT can be downloaded directly from http://www.indiana.edu/~jslsoc/stata/  
/****************************/

clear
clear matrix
set more off

//Find and install packages used
findit estout		//Output and display package
findit fitstat		//Computing fit statistics for use with estout: optional


//Load KALAHI reelection dataset
use ajps_data, clear

//Specify control variables (basevars = excluding political and competitiveness variables)
local controlvars term3_04 contenders_07 dynasty_04 poverty_nscb log_pop urban tax_growth_avg_3yr
local basevars poverty_nscb log_pop urban tax_growth_avg_3yr

//Table 1: KALAHI participation and incumbent mayor or relative re-election in 2007 
//Logistic regression with province fixed effects and clustered standard errors
eststo clear
eststo: logistic rel_07 kc_phase1 provs*, cluster(prov_geocode)
estadd fitstat
eststo: logistic rel_07 kc_phase1 `basevars' provs*, cluster(prov_geocode)
estadd fitstat
eststo: logistic rel_07 kc_phase1 `controlvars' provs* , cluster(prov_geocode)
estadd fitstat
esttab using kc_ajps_tables.rtf, ///
	replace title("Table 1: KALAHI Participation and the Reelection of Mayors") ///
	eform rtf label nogap unstack compress nonotes nonumbers star(* 0.05) ///
	order(kc_*) mtitles("Bivariate" "Baseline" "Full Model") ///
	se(2) b(a2) pr2(2) scalars("r2_cu Cragg-Uhler R2" "lrx2 Wald chi2" "lrx2_p P > chi2" ) sfmt(a2 a2 %8.2f) ///
	indicate("Province Fixed Effects = provs*") nodepvars ///
	addnotes("Dependent variable is the reelection of incumbent mayor or relative in 2007. Logistic regression with province fixed effects and exponentiated coefficients (odds ratios). Standard errors, clustered by province, in parentheses. * p < 0.05") 

//Load KALAHI mayor visits dataset
use ajps_visits_data, clear

//Table 2: KALAHI participation and mayor visits
//Negative binomial regression
//Note: Poisson distribution not used because of overdispersion (likelihood ratio test) 
//Mean of visits_mayor = 3.28; variance 33.117; i.e. 10x the mean when it should be about equal
eststo clear
eststo: nbreg visits_mayor treat road_dirt_pct bar_meetings log_num_households poor log_ira provis*,  vce(robust)
estadd fitstat
eststo: nbreg visits_mayor treat road_dirt_pct bar_meetings log_num_households poor log_ira provis* if muni_funds==0,  vce(robust)
estadd fitstat
eststo: nbreg visits_midwife treat road_dirt_pct bar_meetings log_num_households poor log_ira provis*,   vce(robust)
estadd fitstat
esttab using kc_ajps_tables.rtf, ///
	append title("Table 2: KALAHI Participation and Credit Claiming Activities") ///
	eform rtf label nogap unstack compress nonotes nonumbers star(* .05) ///
	se(2) b(a2) scalars("r2_cu Cragg-Uhler R2" "lrx2 Wald chi2" "lrx2_p P > chi2" ) sfmt(a2 %8.2f a2 a2 a2) ///
	order(treat) mtitles("Mayor Visits" "Mayor Visits" "Midwife Visits") ///
	indicate("Province Fixed Effects = provis*")  ///
	addnotes("Dependent variables are the count of mayor (1-2) and midwife (3) visits. Column 2 restricts the sample to areas that received no municipal funding. Negative binomial regression with exponentiated coefficients (odds ratios) displayed. Robust standard errors in parentheses.  * p < .05") 

//Re-load KALAHI reelection dataset
use ajps_data, clear
	
local controlvars term3_04 contenders_07 dynasty_04 poverty_nscb log_pop urban  tax_growth_avg_3yr
local basevars poverty_nscb log_pop urban tax_growth_avg_3yr

//Table 3: KALAHI and mayor reelection prior to disbursement of funds
eststo clear
eststo: logistic rel_07 kc_phase1 `basevars' provs* if no_funds_2007==1, cluster(prov_geocode)
estadd fitstat
eststo: logistic rel_07 kc_phase1 `controlvars' provs* if no_funds_2007==1, cluster(prov_geocode)
estadd fitstat
esttab using kc_ajps_tables.rtf, ///
	append title("Table 3: KALAHI Participation and Mayor Reelection Prior to Disbursement of Funds") ///
	eform rtf label nogap unstack compress nonotes star(* 0.05) ///
	order(kc_*) mtitles("(Baseline)" "(Full)") ///
	se(2) b(a2) pr2(2) scalars("r2_cu Cragg-Uhler R2" "lrx2 Wald chi2" "lrx2_p P > chi2" ) sfmt(a2 a2 %8.2f) ///
	indicate("Province Fixed Effects = provs*") nodepvars ///
	addnotes("Dependent variable is the reelection of incumbent mayor or relative in 2007. Logistic regression with province fixed effects and exponentiated coefficients (odds ratios). Standard errors, clustered by province, in parentheses. * p < 0.05") 


/**********************************************************************************************************/
//Tables in the Appendix
/**********************************************************************************************************/
//A.1 Summary statistics for main dataset
generate x = uniform()
eststo clear
quietly regress x rel_07 kc_phase1 term3_04 contenders_07 dynasty_04 poverty_nscb log_pop urban tax_growth_avg_3yr, noconstant
estadd summ, mean sd min max
esttab using kc_ajps_tables.rtf, b(2) cells("mean(fmt(a2)) sd(fmt(a2)) min(fmt(a2)) max(fmt(a2))") nogap nomtitle nonumber label append ///
	title("A. Descriptive Statistics (Main Data Set)")

//Load KALAHI mayor visits dataset
use ajps_visits_data, clear

//B.1 Summary statistics for KALAHI survey data
generate x = uniform()
eststo clear
quietly regress x visits_mayor visits_midwife treat road_dirt_pct bar_meetings log_num_households poor log_ira, noconstant
estadd summ, mean sd min max
esttab using kc_ajps_tables.rtf, b(2) cells("mean(fmt(a2)) sd(fmt(a2)) min(fmt(a2)) max(fmt(a2))") nogap nomtitle nonumber label append ///
	title("B. Descriptive Statistics (KALAHI Survey Data)")

//Re-load KALAHI reelection dataset
use ajps_data, clear

//C.1 Poverty variables
eststo clear
	local pov_vars term3_04 contenders_07 dynasty_04 log_pop urban tax_growth_avg_3yr  
eststo: logistic rel_07 kc_phase1 pov_inc2003 `pov_vars' provs*, cluster(prov_geocode)
estadd fitstat
eststo: logistic rel_07 kc_phase1 poverty_squared `pov_vars' provs*, cluster(prov_geocode)
estadd fitstat
eststo: logistic rel_07 kc_phase1 poverty_log `pov_vars' provs*, cluster(prov_geocode)
estadd fitstat
esttab using kc_ajps_tables.rtf, ///
	append title("Table C.1: Measures of Poverty")  ///
	eform rtf label nogap unstack compress nonotes star(* 0.05) ///
	se(2) b(a2) pr2(2) scalars("r2_cu Cragg-Uhler R2" "lrx2 Wald chi2" "lrx2_p P > chi2" ) sfmt(a2 a2 %8.2f) ///
	order(kc_* pov*) ///
	mtitles("(1)" "(2)" "(3)") nonumbers ///
	indicate("Province Fixed Effects = provs*") nonotes  ///
	addnotes("Dependent variable is the reelection of incumbent mayor or relative in 2007. Logistic regression with province fixed effects and exponentiated coefficients (odds ratios). Standard errors, clustered by province, in parentheses.  * p < 0.05") 

//B.3 Falsification (Placebo) tests
eststo clear
	local placebovars contenders_mean pov_inc2000 log_pop_00 urban tax_growth_avg_3yr  
eststo: logistic rel_98 kc_phase1 term_95 clan_95 `placebovars'  provs* , cluster(prov_geocode)
estadd fitstat
eststo: logistic rel_01 kc_phase1 term3_98 clan_98 `placebovars'  provs* , cluster(prov_geocode)
estadd fitstat
esttab using kc_ajps_tables.rtf, ///
	append title("Table C.2: Falsification (Placebo) Tests")  ///
	eform rtf label nogap unstack compress nonotes star(* 0.05) ///
	se(2) b(a2) pr2(2) scalars("r2_cu Cragg-Uhler R2" "lrx2 Wald chi2" "lrx2_p P > chi2" ) sfmt(a2 a2 %8.2f) ///
	order(kc_* poverty*) ///
	mtitles("(Election in 1998)" "(Election in 2001)") nonumbers ///
	indicate("Province Fixed Effects = provs*") nonotes nodepvars ///
	addnotes("Dependent variable: reelection of incumbent mayor or relative in 1998 (col. 1) and 2001 (col. 2). Logistic regression with province fixed effects and exponentiated coefficients (odds ratios). Standard errors, clustered by province, in parentheses.  * p < 0.05")  
//Note: Earlier data is not available, regressions use 2000 data for population and poverty
//No candidate data available, so average number of candidates used instead
	

//Insert here
/****************************/
//Figure C.1: Covariate Balance Above and Below the Theshold

//Figure C.2: KALAHI Participation by Ranking

//Figure C.3: Regression Discontinuity Graphs

/****************************/
	
//Appendix D. Sensitivity Analysis	
//D.3 Electoral competitiveness 
eststo clear
	local elect_vars term3_04 contenders_07 poverty_nscb log_pop urban tax_growth_avg_3yr
eststo: logistic rel_07 kc_phase1 clan_04 `elect_vars' provs* , cluster(prov_geocode)
estadd fitstat
eststo: logistic rel_07 kc_phase1 clan_total_04 `elect_vars' provs* , cluster(prov_geocode)
estadd fitstat
eststo: logistic rel_07 kc_phase1 `elect_vars' provs* if clan_total<.8, cluster(prov_geocode)
estadd fitstat
esttab using kc_ajps_tables.rtf, ///
	append title("Table D.3: Electoral Competitiveness")  ///
	eform rtf label nogap unstack compress nonotes star(* 0.05) ///
	se(2) b(a2) pr2(2) scalars("r2_cu Cragg-Uhler R2" "lrx2 Wald chi2" "lrx2_p P > chi2" ) sfmt(a2 a2 %8.2f) ///
	order(kc_* clan_*) ///
	mtitles("Clan Incumbent" "Clan Mayor" "Non-clan Sample" "Non-clan, Contested") ///
	indicate("Province Fixed Effects = provs*") nonotes  ///
	addnotes("Dependent variable: reelection of the incumbent mayor or his/her relative in 2007. Logistic regression with exponentiated coefficients (odds ratios); standard errors, clustered by province, in parentheses. * p < 0.05") nodepvars

//D.4 Additional Controls
eststo clear
eststo: logistic rel_07 kc_phase1 `controlvars' kc_funding_pct provs* , cluster(prov_geocode)
estadd fitstat
eststo: logistic rel_07 kc_phase1 `controlvars' natl_party_inc provs* , cluster(prov_geocode)
estadd fitstat
eststo: logistic rel_07 kc_phase1 `controlvars' total_grant_pct provs* , cluster(prov_geocode)
estadd fitstat
eststo: logistic rel_07 kc_phase1 `controlvars' term2_04 provs* , cluster(prov_geocode)
estadd fitstat
esttab using kc_ajps_tables.rtf, ///
	append title("Table D.4: Additional Control Variables") order(kc* natl_party_inc total_grant* term*) ///
	eform rtf label nogap unstack compress nonotes star(* 0.05) ///
	se(2) b(a2) pr2(2) scalars("r2_cu Cragg-Uhler R2" "lrx2 Wald chi2" "lrx2_p P > chi2" ) sfmt(a2 a2 %8.2f) ///
	mtitles("KC Funding" "Parties" "Grants Amount" "Terms in Office") ///
	indicate("Province Fixed Effects = provs*") nonotes  ///
	addnotes("Dependent variable: reelection of the incumbent mayor or his/her relative in 2007. Logistic regression with exponentiated Coefficients (odds ratios); standard errors, clustered by province, in parentheses.  * p < 0.05") nodepvars
	
	
//D.5 Different Model Specifications
eststo clear
eststo: logistic rel_07 kc_phase1 `controlvars' , robust
estadd fitstat
eststo: logistic rel_07 kc_phase1 `controlvars' provs* , robust
estadd fitstat
eststo: logistic rel_07 kc_phase1 `controlvars' , cluster(prov_geocode)
estadd fitstat
esttab using kc_ajps_tables.rtf, ///
	append title("Table D.5: Different Model Specifications") ///
	eform rtf label nogap unstack compress nonotes star(* 0.05) ///
	se(2) b(a2) pr2(2) scalars("r2_cu Cragg-Uhler R2" "lrx2 Wald chi2" "lrx2_p P > chi2" ) sfmt(a2 a2 %8.2f) ///
	order(kc_* ) ///
	mtitles("(No FE, Robust)" "(FE, Robust)" "(No FE, Clustered)") ///
	indicate("Province Fixed Effects = provs*") nonotes  ///
	addnotes("Dependent variable: reelection of the incumbent mayor or his/her relative in 2007. Logistic regression with exponentiated coefficients (odds ratios) displayed. Standard errors in parentheses.  * p < 0.05") nodepvars

	
//E.6 Strategic Redistribution of Local Budget
eststo clear
 local controlvars poverty_nscb log_pop log_land_area urban log_total_exp_avg 
eststo: reg pg_expenditure kc_phase1 `controlvars'  provs*, cluster(prov_geocode)
estadd fitstat
eststo: reg tg_expenditure kc_phase1 `controlvars'  provs*, cluster(prov_geocode)
estadd fitstat
eststo: reg pg_expenditure kc_phase1 `controlvars'  provs* if no_funds_2007==1, cluster(prov_geocode)
estadd fitstat
eststo: reg tg_expenditure kc_phase1 `controlvars'  provs* if no_funds_2007==1, cluster(prov_geocode)
estadd fitstat
esttab using kc_ajps_tables.rtf, ///
	append title("Table E.6: Strategic Redistrbution of the Local Budget") ///
	rtf label nogap unstack compress nonotes star(* 0.05) ///
	se(2) b(a2) pr2(2) scalars("r2_cu Cragg-Uhler R2" "lrx2 Wald chi2" "lrx2_p P > chi2" ) sfmt(a2 a2 %8.2f) ///
	order(kc_*) ///
	mtitles("Public Goods" "Targeted Goods" "Public Goods Excluding Municipalities with Funding before 2007" "Targeted Goods Excluding Municipalities with Funding before 2007" )   ///
	indicate("Province Fixed Effects = provs*") nonotes ///
	addnotes("Dependent variable: reelection of the incumbent mayor or his/her relative in 2007. OLS with standard errors (clustered by province) in parentheses.  Average municipal spending figures calculated from the first year of participation in the program, or if a non-participant, the first year that any municipality in the province participated.  * p < 0.05")

