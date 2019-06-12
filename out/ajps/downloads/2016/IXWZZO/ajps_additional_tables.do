/****************************/
// AJPS Additional Tables
// This do file uses Stata 14 to produce all of the results that are available upon request or reviewer results only
// For questions, contact Cesi Cruz [cesi.cruz@ubc.ca]
//
// Output and Display Packages: 
// 		ESTOUT: Ben Jann (2007) Making Regression Tables Simplified.
// 
// Analytical Packages:
// 		RD: Austin Nichols (2011) Revised Stata Module for Regression Discontinuity Estimation. 
//
// All packages can be directly installed from the STATA console using "findit [package name]" or "ssc install [package name]"
// 		ESTOUT can be downloaded directly from  http://repec.org/bocode/e/estout/
// 		RD can be downloaded directly from http://ideas.repec.org/c/boc/bocode/s456888.html
/****************************/


clear
clear matrix
set more off


//Find and install packages used
findit rd			//Regression discontinuity package
findit rd			//Regression discontinuity package
findit estout		//Output and display package

//Load KALAHI reelection dataset
use ajps_data, clear


//X.1 Adjusted sample for KALAHI and mayor reelection prior to disbursement of funds: removing municipalities that *possibly* might have disbursement before elections
//Data coded by comparing World Bank dataset to project documents on paper

//Specify control variables (basevars = excluding political and competitiveness variables)
local controlvars term3_04 contenders_07 dynasty_04 poverty_nscb log_pop urban tax_growth_avg_3yr
local basevars poverty_nscb log_pop urban tax_growth_avg_3yr
eststo clear
eststo: logistic rel_07 kc_phase1 `basevars' provs* if no_funds_2007_adj==1, cluster(prov_geocode)
eststo: logistic rel_07 kc_phase1 `controlvars' provs* if no_funds_2007_adj==1, cluster(prov_geocode)
esttab using kc_ajps_additional.rtf, ///
	replace title("KALAHI and Mayor Reelection Prior to Disbursement of Funds (Adj)") ///
	eform rtf label nogap unstack compress nonotes star(* 0.05) ///
	order(kc_*) mtitles("(1)" "(2)" "(3)") ///
	se(2) b(a2) pr2 ///
	indicate("Province Fixed Effects = provs*") ///
	addnotes("Dependent variable is the reelection of incumbent mayor or relative. Logistic regression with province fixed effects and exponentiated coefficients (odds ratios). Standard errors, clustered by province, in parentheses. * p < 0.05, ** p < .01, *** p < .001") 

//X.2 Comparing only provinces in which disbursement was given before the elections (i.e. not just announcement)
local controlvars term3_04 contenders_07 dynasty_04 poverty_nscb log_pop urban tax_growth_avg_3yr
local basevars poverty_nscb log_pop urban tax_growth_avg_3yr
eststo clear
eststo: logistic rel_07 kc_phase1 provs* if prov_avg_first<=2007, cluster(prov_geocode)
estadd fitstat
eststo: logistic rel_07 kc_phase1 `basevars' provs* if prov_avg_first<=2007, cluster(prov_geocode)
estadd fitstat
eststo: logistic rel_07 kc_phase1 `controlvars' provs* if prov_avg_first<=2007, cluster(prov_geocode)
estadd fitstat
esttab using kc_ajps_additional.rtf, ///
	append title("KALAHI Participation and Incumbent Reelection in 2007") ///
	eform rtf label nogap unstack compress nonotes nonumbers star(* 0.05) ///
	order(kc_*) mtitles("Bivariate" "Base Model" "Full Model") ///
	se(2) b(a2) pr2(2) scalars("r2_cu Cragg-Uhler R2" "lrx2 Wald chi2" "lrx2_p P > chi2" ) sfmt(a2 a2 %8.2f) ///
	indicate("Province Fixed Effects = provs*") ///
	addnotes("Dependent variable is the reelection of incumbent mayor or relative. Logistic regression with province fixed effects and exponentiated coefficients (odds ratios). Standard errors, clustered by province, in parentheses. * p < 0.05, ** p < .01, *** p < .001") 
	
//X.3 Robustness to excluding pilot sites and areas where mistakes may have been made in ranking/allocation (same sample used for RDD histogram and robustness check)
//Note that model 3 is significant only at 10% level

drop if kalahi_rank==999
drop if kalahi_rank==.
drop if provincename==""

//Dropping pilot sites
drop if (provincename == "QUEZON") & (municityname == "DOLORES")
drop if (provincename == "CAPIZ") & (municityname == "DUMARAO")
drop if (provincename == "BILIRAN") & (municityname == "NAVAL")
drop if (provincename == "DAVAO DEL NORTE") & (municityname == "SANTO TOMAS")
drop if (provincename == "AGUSAN DEL NORTE") & (municityname == "CARMEN")

//Dropping ranking errors
drop if (provincename == "IFUGAO") & (municityname == "HINGYON") //Hingyon was ranked wealthy but it's a 5th class municipality
drop if (provincename == "BOHOL") & (municityname == "GARCIA-HERNANDEZ") //There is a Garcia-Hernandez and a Pres. Garcia municipality that appears to have been switched

//Two possible duplicate observations in Davao
drop if (provincename == "DAVAO DEL NORTE") & (municityname=="SANTO TOMAS") & (first_year==last_year)
drop if (provincename == "DAVAO DEL NORTE") & (municityname=="TALAINGOD") & (first_year==last_year)

//Dropping pilot provinces/unsure rollout/original project documents unavailable
drop if provincename == "MASBATE" | provincename == "ILOILO" | provincename == "LEYTE" | provincename == "LANAO DEL NORTE" | provincename == "ZAMBOANGA DEL NORTE" | ///
	provincename == "NORTH COTABATO" | provincename == "ROMBLON" | provincename == "EASTERN SAMAR" | provincename == "NORTHERN SAMAR" | provincename == "SAMAR" | ///
	provincename == "SIQUIJOR" 

local controlvars term3_04 contenders_07 dynasty_04 poverty_nscb log_pop urban tax_growth_avg_3yr
local basevars poverty_nscb log_pop urban tax_growth_avg_3yr
eststo clear
eststo: logistic rel_07 kc_phase1 provs* , cluster(prov_geocode)
estadd fitstat
eststo: logistic rel_07 kc_phase1 `basevars' provs* , cluster(prov_geocode)
estadd fitstat
eststo: logistic rel_07 kc_phase1 `controlvars' provs* , cluster(prov_geocode)
estadd fitstat
esttab using kc_ajps_additional.rtf, ///
	append title("KALAHI Participation and Incumbent Reelection in 2007") ///
	eform rtf label nogap unstack compress nonotes nonumbers star(* 0.05) ///
	order(kc_*) mtitles("Bivariate" "Base Model" "Full Model") ///
	se(2) b(a2) pr2(2) scalars("r2_cu Cragg-Uhler R2" "lrx2 Wald chi2" "lrx2_p P > chi2" ) sfmt(a2 a2 %8.2f) ///
	indicate("Province Fixed Effects = provs*") ///
	addnotes("Dependent variable is the reelection of incumbent mayor or relative. Logistic regression with province fixed effects and exponentiated coefficients (odds ratios). Standard errors, clustered by province, in parentheses. * p < 0.05, ** p < .01, *** p < .001") 
	
//X.4 RDD results are robust to using the sample excluding pilot sites and ranking errors (same sample used in the histogram) 
	
use ajps_rdd_data, clear
drop if prov_geocode==. 
//Removes observations without ranking data
drop if kalahi_rank==999
drop if kalahi_rank==.
drop if provincename==""
	
//Dropping pilot sites
drop if (provincename == "QUEZON") & (municityname == "DOLORES")
drop if (provincename == "CAPIZ") & (municityname == "DUMARAO")
drop if (provincename == "BILIRAN") & (municityname == "NAVAL")
drop if (provincename == "DAVAO DEL NORTE") & (municityname == "SANTO TOMAS")
drop if (provincename == "AGUSAN DEL NORTE") & (municityname == "CARMEN")

//Dropping ranking errors
drop if (provincename == "IFUGAO") & (municityname == "HINGYON") //Hingyon was ranked wealthy but it's a 5th class municipality
drop if (provincename == "BOHOL") & (municityname == "GARCIA-HERNANDEZ") //There is a Garcia-Hernandez and a Pres. Garcia municipality that appears to have been switched

//Two possible duplicate observations in Davao
drop if (provincename == "DAVAO DEL NORTE") & (municityname=="SANTO TOMAS") & (first_year==last_year)
drop if (provincename == "DAVAO DEL NORTE") & (municityname=="TALAINGOD") & (first_year==last_year)

//Dropping pilot provinces/unsure rollout
drop if provincename == "MASBATE" | provincename == "ILOILO" | provincename == "LEYTE" | provincename == "LANAO DEL NORTE" | provincename == "ZAMBOANGA DEL NORTE" | ///
	provincename == "NORTH COTABATO" | provincename == "ROMBLON" 

	
//Regression Discontinuity: robustness to dropping pilot sites, ranking errors, etc.
eststo clear
eststo: rd rel_07 kc_cutoff , z0(.76)  cluster(prov_geocode) //graph noscatter
esttab using kc_ajps_additional.rtf, ///
	append title("Regression Discontinuity: KALAHI Participation and Incumbent Reelection in 2007") ///
	eform rtf label nogap unstack compress nonotes nonumbers star(* 0.05)  ///
	order(kc_*) mtitles("RD, Pilot sites removed") ///
	se(2) b(a2)  ///
	addnotes("Dependent variable is the reelection of incumbent mayor or relative. Exponentiated coefficients displayed for consistency. * p < 0.05")

	
