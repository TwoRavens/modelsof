/****************************/
// AJPS Publication Figures
// This do file uses Stata 14 to produce all of the figures for
// Foreign Aid and the Politics of Undeserved Credit Claiming
// Cesi Cruz and Christina Schneider
//
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

//Find and install packages used
findit rd			//Regression discontinuity package
findit estout		//Output and display package


use ajps_rdd_data, clear
drop if prov_geocode==. 

set scheme s1mono

//Regression Discontinuity: full set of observations
//NOTE: Results are robust to using the sample with ranking errors and pilot sites removed 
eststo clear
eststo: rd rel_07 kc_cutoff , z0(.76)  cluster(prov_geocode) graph noscatter
esttab using kc_ajps_tables_rd.rtf, ///
	replace title("Regression Discontinuity: KALAHI Participation and Incumbent Reelection in 2007") ///
	eform rtf label nogap unstack compress nonotes nonumbers star(* 0.05) ///
	order(kc_*) mtitles("RD") ///
	se(2) b(a2)  ///
	addnotes("Dependent variable is the reelection of incumbent mayor or relative. Exponentiated coefficients displayed for consistency. * p < 0.05")

//Balance tables

use ajps_rdd_data, clear
//Setting unranked to missing
replace kalahi_rank=. if kalahi_rank==999

//Two possible duplicate observations in Davao (could also be split municipality)
drop if (provincename == "DAVAO DEL NORTE") & (municityname=="SANTO TOMAS") & (first_year==last_year)
drop if (provincename == "DAVAO DEL NORTE") & (municityname=="TALAINGOD") & (first_year==last_year)

order kalahi_rank kc_cutoff kc_phase1

gen winmargin_07_pct = winmargin_07/100


gen kc_cutoff_small_c = 0
replace kc_cutoff_small_c = 1 if kc_cutoff >= .59 & kc_cutoff<.75

gen kc_cutoff_small_t = 0
replace kc_cutoff_small_t = 1 if kc_cutoff <= .91 & kc_cutoff>.75

//Displays balance around the cutpoint (small bandwidth)	
keep if kc_cutoff_small_c == 1 | kc_cutoff_small_t == 1

//Generating summary statistics for all the variables in the list
collapse (mean) term3_041 = term3_04 dynasty_041 = dynasty_04 winmargin_07_pct1 = winmargin_07_pct poverty_nscb1 = poverty_nscb urban1 = urban tax_growth_avg_3yr1 = tax_growth_avg_3yr socialsec_pct_20071 = socialsec_pct_2007 edu_pct_20071 = edu_pct_2007  health_pct_20071 = health_pct_2007  ///
(sd) term3_042 = term3_04 dynasty_042 = dynasty_04 winmargin_07_pct2 = winmargin_07_pct poverty_nscb2 = poverty_nscb urban2 = urban tax_growth_avg_3yr2 = tax_growth_avg_3yr socialsec_pct_20072 = socialsec_pct_2007 edu_pct_20072 = edu_pct_2007  health_pct_20072 = health_pct_2007  ///
(min) term3_043 = term3_04 dynasty_043 = dynasty_04 winmargin_07_pct3 = winmargin_07_pct poverty_nscb3 = poverty_nscb urban3 = urban tax_growth_avg_3yr3 = tax_growth_avg_3yr socialsec_pct_20073 = socialsec_pct_2007 edu_pct_20073 = edu_pct_2007  health_pct_20073 = health_pct_2007  ///
(max) term3_044 = term3_04 dynasty_044 = dynasty_04 winmargin_07_pct4 = winmargin_07_pct poverty_nscb4 = poverty_nscb urban4 = urban tax_growth_avg_3yr4 = tax_growth_avg_3yr socialsec_pct_20074 = socialsec_pct_2007 edu_pct_20074 = edu_pct_2007  health_pct_20074 = health_pct_2007  ///
(count) term3_045 = term3_04 dynasty_045 = dynasty_04 winmargin_07_pct5 = winmargin_07_pct poverty_nscb5 = poverty_nscb urban5 = urban tax_growth_avg_3yr5 = tax_growth_avg_3yr socialsec_pct_20075 = socialsec_pct_2007 edu_pct_20075 = edu_pct_2007  health_pct_20075 = health_pct_2007 , by(kc_cutoff_small_t)

//Defining treatment and control summary statistics
reshape long term3_04 dynasty_04 winmargin_07_pct poverty_nscb urban tax_growth_avg_3yr socialsec_pct_2007 edu_pct_2007 health_pct_2007 , i(kc_cutoff_small_t) j(treat)

//Transposing the data so that summary statistics are columns
xpose, varname clear

order _varname  v1 v2 v3 v4 v5 v6 v7 v8 v9 v10

//Labeling the summary statistics: prefix "c_*" = control; "t_*" = treatment
rename v1 c_mean
rename v2 c_stddev
rename v3 c_min
rename v4 c_max
rename v5 c_obs

rename v6 t_mean
rename v7 t_stddev
rename v8 t_min
rename v9 t_max
rename v10 t_obs

//drop rows for checking rename
drop if _varname == "kc_cutoff_small_t" | _varname == "treat"

//Creating ids for the histogram labels
gen id = _n

generate hitreat = t_mean + invttail(t_obs-1,0.1)*(t_stddev / sqrt(t_obs))
generate lotreat = t_mean - invttail(t_obs-1,0.1)*(t_stddev / sqrt(t_obs))	

generate hicontrol = c_mean + invttail(c_obs-1,0.1)*(c_stddev / sqrt(c_obs))
generate locontrol = c_mean - invttail(c_obs-1,0.1)*(c_stddev / sqrt(c_obs))	

label def names 1 "Third Term" 2 "Dynasty Member" 3 "Winning Margin (2007)" 4 "Poverty"  5 "Urban" ///
	6 "Tax Revenue Growth" 7 "Social Services Expenditures" 8 "Education Expenditures" 9 "Health Expenditures" 	
label val id names

twoway rspike lotreat hitreat id, horizontal lcolor(gray)|| scatter id t_mean, mcolor(gray) msymbol(D) msize(2) ///
		|| rspike locontrol hicontrol id, horizontal lcolor(black) ///
	 	|| scatter id c_mean,  ///
	 	mcolor(black) msize(2)   ylabel(1(1)9, valuelabel angle(0)) ///
	xtitle("Sample Value") ytitle("") legend(order(2 "Kalahi" 4 "Non-Kalahi"))  scheme(s1mono)


	
/***************************************************************/
//Histogram to show Kalahi rankings with pilot sites and ranking errors removed
/***************************************************************/

use ajps_rdd_data, clear
	
drop if kalahi_rank==999
drop if kalahi_rank==.
drop if provincename==""
duplicates drop

//Two duplicate observations in Davao
drop if (provincename == "DAVAO DEL NORTE") & (municityname=="SANTO TOMAS") & (first_year==last_year)
drop if (provincename == "DAVAO DEL NORTE") & (municityname=="TALAINGOD") & (first_year==last_year)


//Optional adjustments based on ranking inconsistencies
//NOTE: These are cases where the number of municipalities in the province doesn't match 
//		the original ranking data (either the dataset is missing a municipality or new municipalities were created)
replace kalahi_rank = kalahi_rank - 1 if provincename == "DAVAO DEL NORTE" & kalahi_rank>=5
replace kalahi_rank = kalahi_rank - 3 if provincename == "DAVAO DEL NORTE" & kalahi_rank>=8
replace kalahi_rank = kalahi_rank - 1 if provincename == "NORTHERN SAMAR" & kalahi_rank>=18
replace kalahi_rank = kalahi_rank - 1 if provincename == "QUEZON" & kalahi_rank>=35
replace kalahi_rank = kalahi_rank - 1 if provincename == "ZAMBOANGA DEL NORTE" & kalahi_rank>=12
replace kalahi_rank = kalahi_rank - 1 if provincename == "ZAMBOANGA DEL NORTE" & kalahi_rank>=21

//Dropping problem provinces (unsure rollout/possibly not fully participated)
drop if provincename == "MASBATE" | provincename == "ILOILO" | provincename == "LEYTE" | provincename == "LANAO DEL NORTE" | provincename == "ZAMBOANGA DEL NORTE" | ///
	provincename == "NORTH COTABATO" | provincename == "ROMBLON" | provincename == "EASTERN SAMAR" | provincename == "NORTHERN SAMAR" | provincename == "SAMAR" | ///
	provincename == "SIQUIJOR" 

//Dropping pilot sites
drop if (provincename == "QUEZON") & (municityname == "DOLORES")
drop if (provincename == "DAVAO DEL NORTE") & (municityname=="SANTO TOMAS")
drop if (provincename == "BILIRAN") & (municityname=="NAVAL")
drop if (provincename == "AGUSAN DEL NORTE") & (municityname=="CARMEN")
drop if (provincename == "CAPIZ") & (municityname=="DUMARAO")


drop if kc_phase1==1 & first_year>2007

twoway (histogram kc_cutoff if kc_project_07==1, width(.05) start(0) fcolor(gray) lcolor(black)) ///
       (histogram kc_cutoff if kc_project_07==0, width(.05)  start(0)   ///
	   fcolor(none) lcolor(black)), xline(.75) xtitle("Poverty Ranking Percentile") legend(order(1 "Kalahi Participant" 2 "Non-participant" )) scheme(s1mono)


