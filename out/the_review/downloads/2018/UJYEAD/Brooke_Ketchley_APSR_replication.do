********************************************************************************
*"Social and Institutional Origins of Political Islam"
********************************************************************************
cap cd "/Users/k1619065/Dropbox/MB paper/APSR_production"
cap use Brooke_Ketchley_APSR_replicationI, clear
set more off

********************************************************************************
*Subdistrict variables
******************************************************************************** 

	gen copts = (male_copt + female_copt)
	gen non_egyptian = (male_foreigners + female_foreigners)
	gen agriculture = (male_farmers_fishermen_and_hunti + female_farmers_fishermen_and_hun)
	gen literate = (female_age_5_and_above_read_and_ + male_age_5_and_above_read_and_wr)
	gen religious_other = (male_other_religions + female_other_religions)
	gen non_muslim = (copts+religious_other)

*NB: need to construct denominator literate*
	gen literate_denom = (female_age_5_and_above_read_and_ + female_age_5_and_above_illiterat ///
	+ male_age_5_and_above_read_and_wr + male_age_5_and_above_illiterate)
	
*gen literacy with relevant cohorts as denominator*
	gen literate_pct = ((female_age_5_and_above_read_and_ + male_age_5_and_above_read_and_wr)/literate_denom)*100
	
*Social context variables over denominator as % of total_pop*

local social_context = "non_egyptian agriculture non_muslim"
foreach var of local social_context  {
	gen `var'_pct = `var'
	local name: variable label `var'
	di "`name'"
	label variable `var'_pct "`name'" 
	}
	
	foreach var of local social_context  {
	quietly summ `var'_pct
	replace `var'_pct = (`var'_pct/total_population)*100
	}
	
*gen unemployed males with males as denominator
	gen unemployed_men_pct = (male_without_occupations/male_total)*100
	
*gen offset variable
	gen muslims_subdistrict = male_moslem + female_moslem 
	gen ln_muslim_subdistrict = log(muslims_subdistrict)
	
*******************************************************************************
*district variables as % over relevant denominator 
*******************************************************************************
*% population change since 1917*
gen pop_change_20yrs = ((district_total_pop - pop_1917)/ pop_1917)*100

*% employed in state admin*
gen state_admin_pct = (_total_gov_employees/_population_over_5)*100

*% Europeans*
gen european_pct = ((greek+french+british+italian)/district_total_pop)*100

*Missionaries per 10,000 of the population*
gen missionaries_per10000 = (total_missionaries/district_total_pop)*10000

*MB HQ is in Muski - Muski centroid = 30.0512531427455 31.2531474997934*
geodist district_Y district_X 30.0512531427455 31.2531474997934, sphere gen(distance_from_HQ)
gen sqrtdistancefromHQ  = sqrt(distance_from_HQ)  

********************************************************************************
*Drop rows with missing values for analysis.
********************************************************************************

local variables_to_be_analyzed = "agriculture_pct literate_pct unemployed_men_pct pop_change_20yrs sqrtdistancefromHQ admin_centre non_muslim_pct european_pct missionaries_per10000 state_admin_pct state_railway_station"
foreach var of local variables_to_be_analyzed  {
	drop if missing(`var')
	}

********************************************************************************
*Label variables to be tested in main analysis + robustness
********************************************************************************

*DV's
lab var mb_1937 "(Subdistrict) Muslim Brotherhood branch, 1937"
lab var mb_1940 "(Subdistrict) Muslim Brotherhood branch, 1940"

*Units of analysis
lab var muhafatha "Governorate"
lab var qism "District"
lab var name "Subdistrict"

*H1 variables
lab var literate_pct "(Subdistrict) Literate %"
lab var agriculture_pct "(Subdistrict) Employed in agriculture %"
lab var unemployed_men_pct "(Subdistrict) Unemployed males %"
lab var pop_change_20yrs "(District) Population change since 1917 %"

*H2 variables
lab var european_pct "(District) European %"
lab var missionaries_per10000 "(District) Missionaries per 10,000"
lab var non_muslim_pct "(Subdistrict) Non-Muslim %"

*H3 variables
lab var state_admin_pct "(District) Employed in state administration %"
lab var state_railway_station "(Subdistrict) Egyptian state railway"

*Controls
lab var sqrtdistancefromHQ "(District) Distance to MB's headquarters, sqrt km"
lab var admin_centre "(District) Administrative centre"

*Offset
lab var ln_muslim_subdistrict "(Subdistrict) Muslim population, logged"

*Robustness variables
lab var non_egyptian_pct "(Subdistrict) Non-Egyptians (Europeans and Arabs) %"
lab var founder_district "(District) MB founding member's home district"
lab var founder_governorate "(Governorate) MB founding member's home governorate"
lab var british_military_base_1926 "(District) British military base present in 1926"
lab var barracks_capacity_1926 "(District) Capacity of British military barracks in 1926"
lab var british_military_base_1937 "(District) British military base present in 1937"


********************************************************************************
*Table 1 - Descriptive statistics
********************************************************************************

tabstat mb_1937 ln_muslim_subdistrict literate_pct agriculture_pct unemployed_men_pct non_muslim_pct ///
state_railway_station pop_change_20yrs european_pct missionaries_per10000 state_admin_pct ///
sqrtdistancefromHQ admin_centre, col(stat) stat(min max mean sd)

********************************************************************************
*Table A1 - Corr matrix
********************************************************************************

corr mb_1937 ln_muslim_subdistrict literate_pct agriculture_pct unemployed_men_pct non_muslim_pct ///
state_railway_station pop_change_20yrs european_pct missionaries_per10000 state_admin_pct ///
sqrtdistancefromHQ admin_centre

********************************************************************************
*Local macros for analysis
********************************************************************************

local basicdv =	 "mb_1937"
local alternativedv = "mb_1940"
local controls = "sqrtdistancefromHQ admin_centre"
local alternative_controls = "sqrtdistancefromHQ"
local h1_variables = "literate_pct agriculture_pct unemployed_men_pct pop_change_20yrs"
local h2_variables = "non_muslim_pct european_pct missionaries_per10000"
local h2_alternative_variables = "non_muslim_pct non_egyptian_pct missionaries_per10000"
local h3_variables = "state_admin_pct state_railway_station"
local offset = "ln_muslim_subdistrict"
local significant_covariates = "literate_pct agriculture_pct european_pct state_admin_pct state_railway_station"

********************************************************************************
*Table 2 - 1937 survey - Multilevel logistic regression with ln(Muslims) as offset
********************************************************************************

*1937 branch - null model*
mixed mb_1937 || qism:
estat icc
estimates store null

*Model 1 - 1937 survey - H1*
xtmelogit `basicdv' `h1_variables' `controls' ///
	|| qism:, nolog or intpoints(8) offset(`offset')

estat ic
*outreg2 using main_results.doc, drop(mb_1937) ctitle(Odds ratio) eform alpha(0.001, 0.01, 0.05) replace

*Model 2 - 1937 survey - H1 & H2*
xtmelogit `basicdv' `h1_variables' `h2_variables' `controls' ///
	|| qism:, nolog intpoints(8) or offset(`offset')

estat ic
*outreg2 using main_results.doc, drop(mb_1937) ctitle(Odds ratio) eform alpha(0.001, 0.01, 0.05) append

*Model 3 - 1937 survey - H1 & H2 & H3*
xtmelogit `basicdv' `h1_variables' `h2_variables' `h3_variables' `controls' ///
	|| qism:, nolog intpoints(8) or offset(`offset')

estat ic
*outreg2 using main_results.doc, drop(mb_1937) ctitle(Odds ratio) eform alpha(0.001, 0.01, 0.05) append

********************************************************************************
*Figure 2 - Margins plots holding all other variables at median point using genatmedian
*written by Michael Biggs (Department of Sociology, University of Oxford). To run this command
*genatmedian has to be in STATA's base .ado files. *NB. Enter ln(Muslims) as seperate IV as 
*genatmedian does not account for offset term.
********************************************************************************

*Subdistrict - margins for literate holding at median values*
xtmelogit `basicdv' `h1_variables' `h2_variables' `h3_variables' `controls' `offset' ///
	|| qism:, nolog intpoints(8) or 

genatmediant literate_pct, gen(p_lit)

twoway ///
	(rline p_lit_ul p_lit_ll literate_pct, lpattern(dash) lwidth(medium)) ///    
	(scatter p_lit_p literate_pct, ///
		msymbol(o) mcolor(black) msize(medium)) ///
			if literate_pct<30, ///
			scheme(plotplain) ytitle(Predicted probability of a branch) legend(off) aspectratio(1) ///
			xtitle (Literate %) ///
			ylabel(0(0.01)0.07, nogrid) xlabel(,nogrid)

*graph export "C:\Users\k1619065\Dropbox\MB paper\APSR_production\Brooke_Ketchley_fig2a.tif", as(tif) replace

*report 10th and 90th percentiles*
sum literate_pct, detail
sum p_lit_p, det
sum p_lit_ll, det

*Subdistrict - margins for agriculture holding at median values*

xtmelogit `basicdv' `h1_variables' `h2_variables' `h3_variables' `controls' `offset' ///
	|| qism:, nolog intpoints(8) or 

genatmediant  agriculture_pct, gen(p_agri)

twoway ///
	(rline p_agri_ul p_agri_ll agriculture_pct, lpattern(dash) lwidth(medium)) ///    
	(scatter p_agri_p agriculture_pct, ///
		msymbol(o) mcolor(black) msize(medium)) ///
			if agriculture_pct<80, ///
			scheme(plotplain) ytitle(Predicted probability of a branch) legend(off) aspectratio(1) ///
			xtitle (Employed in agriculture %) ///
			ylabel(0(0.01)0.07, nogrid) xlabel(,nogrid)

*graph export "C:\Users\k1619065\Dropbox\MB paper\APSR_production\Brooke_Ketchley_fig2b.tif", as(tif) replace

*report 10th and 90th percentiles*
sum agriculture_pct, det
sum p_agri_p, det
sum p_agri_ll, det

*District - margins for Europeanpct holding at median values*

xtmelogit `basicdv' `h1_variables' `h2_variables' `h3_variables' `controls' `offset' ///
	|| qism:, nolog intpoints(8) or 

genatmediant european_pct, gen(p_euro)

twoway ///
	(rline p_euro_ul p_euro_ll european_pct, lpattern(dash) lwidth(medium)) ///
	(scatter p_euro_p european_pct, ///
		msymbol(o) mcolor(black) msize(medium)) ///	
			if european_pct<10,  ///
			scheme(plotplain) ytitle(Predicted probability of a branch) legend(off) aspectratio(1) ///
			xtitle (Europeans %) ///
			ylabel(0(0.005)0.025, nogrid) xlabel(,nogrid)
			
*graph export "C:\Users\k1619065\Dropbox\MB paper\APSR_production\Brooke_Ketchley_fig2c.tif", as(tif) replace
					
*report 10th and 90th percentiles*
sum european_pct, det
summarize p_euro_p, det
sort european_pct p_euro_p
br european_pct p_euro_p

*District - margins for govt_employees_pct at median values*

xtmelogit `basicdv' `h1_variables' `h2_variables' `h3_variables' `controls' `offset' ///
	|| qism:, nolog intpoints(8) or 

genatmediant state_admin_pct, gen(p_state)

twoway ///
	(rline p_state_ul p_state_ll state_admin_pct, lpattern(dash) lwidth(medium))    ///
	(scatter p_state_p state_admin_pct, ///
		msymbol(o) mcolor(black) msize(medium)) ///	
	if state_admin_pct<5,  ///
			scheme(plotplain) ytitle(Predicted probability of a branch) legend(off) aspectratio(1) ///
			xtitle (Employed in state administration %) ylabel(0(0.005)0.025, nogrid) xlabel(,nogrid)
			
*graph export "C:\Users\k1619065\Dropbox\MB paper\APSR_production\Brooke_Ketchley_fig2d.tif", as(tif) replace
			
*report 10th and 90th percentiles*
sum state_admin_pct, det
summarize p_state_p, det
sort state_admin_pct p_state_p
br state_admin_pct p_state_p


********************************************************************************
*Table A2 - 1937 survey - Penalized logistic regression with ln(Muslims) as IV
*NB. Users should have the firthlogit command installed in STATA's base .ado files
*This can be done by removing the * preceeding ssc install firthlogit. The relogit
*command should also be in STATA's base .ado files, and can be downloaded 
*here https://gking.harvard.edu/files/gking/files/relogit.zip (last checked 1 Nov 2017)
********************************************************************************

*install firthlogit*
*ssc install firthlogit

*Model 4 - penalized logistic regression with log Muslims as seperate IV*
firthlogit `basicdv' `h1_variables' `h2_variables' `h3_variables' `offset' `controls' ///
	, or nolog

*outreg2 using 1937_robustness_results.doc, drop(mb_1937) ctitle(Odds ratio) eform alpha(0.001, 0.01, 0.05) replace
	
*Relogit with log Muslims as seperate IV and robust SE's at qism level*
relogit `basicdv' `h1_variables' `h2_variables' `h3_variables' `offset' `controls'  ///
	, cluster(qism) 

/*Generate odds ratio 
local independent_variables = "literate_pct agriculture_pct unemployed_men_pct pop_change_20yrs sqrtdistancefromHQ admin_centre non_muslim_pct european_pct missionaries_per10000 state_admin_pct state_railway_station ln_muslim_subdistrict"
foreach var of local independent_variables  {
	predictnl OR`var' = exp(_b[`var']), se(OR`var'SE) 
	l OR`var' OR`var' in 1
	}
*/
	
*Logit with robust SE's at qism level
logit `basicdv' `h1_variables' `h2_variables' `h3_variables' `controls' ///
	, vce(cluster qism) or offset(`offset')

********************************************************************************
*Robustness - Westernization
********************************************************************************

*% non-Egyptians in subdistrict - drop Europeanpct (corr non-Egyptian and Europeanpct = 0.7)*
*corr non_egyptian_pct european_pct*
xtmelogit `basicdv' `h1_variables' `h2_alternative_variables' `h3_variables' `controls' ///
	|| qism:, nolog intpoints(8) or offset(`offset')

*Is negative Europeans finding just picking up strong state presence?*
sum state_admin_pct, detail 

*90th percentile = 1.004518*
cap gen strong_state = 1 if state_admin_pct >= 1.004518
cap replace strong_state = 0 if strong_state ==.

xtmelogit `basicdv' `h1_variables' `h2_variables' `h3_variables' `controls' strong_state ///
	|| qism:, nolog intpoints(8) or offset(`offset')
	
*Without admin_centre dummy*
xtmelogit `basicdv' `h1_variables' `h2_variables' `h3_variables' `alternative_controls' strong_state ///
	|| qism:, nolog intpoints(8) or offset(`offset')
	
*Drop at high values and test on subset of the data*
preserve
drop if strong_state == 1

xtmelogit `basicdv' `h1_variables' `h2_variables' `h3_variables' `controls'  ///
	|| qism:, nolog intpoints(8) or offset(`offset')
	
restore

*Does Westernization finding remain for % non-Egyptians if controlling for strong state?*
xtmelogit `basicdv' `h1_variables' `h2_alternative_variables' `h3_variables' `controls' strong_state ///
	|| qism:, nolog intpoints(8) or offset(`offset')
	
*Interaction term between % Europeans and % state officials*
xtmelogit `basicdv' `h1_variables' `h2_variables' `h3_variables' `controls' c.european_pct#c.state_admin_pct ///
	|| qism:, nolog intpoints(8) or offset(`offset')
	
*Interaction term between  % Europeans and % state officials without admin centers*
xtmelogit `basicdv' `h1_variables' `h2_variables' `h3_variables' `alternative_controls' c.european_pct#c.state_admin_pct ///
	|| qism:, nolog intpoints(8) or offset(`offset')

********************************************************************************
*Robustness - Statistically sig (p<.05) covariates from Model 3 without controls
********************************************************************************	

*Statistically significant covariates from Model 3 without controls*
xtmelogit `basicdv' `significant_covariates' ///
	|| qism:, nolog intpoints(8) or offset(`offset')

********************************************************************************
*Robustness - British military presence
********************************************************************************

*1926 military base*
xtmelogit `basicdv' `h1_variables' `h2_variables' `h3_variables' `controls' british_military_base_1926 ///
	|| qism:, nolog intpoints(8) or offset(`offset')
	
*1926 barracks capacity*
xtmelogit `basicdv' `h1_variables' `h2_variables' `h3_variables' `controls' barracks_capacity_1926 ///
	|| qism:, nolog intpoints(8) or offset(`offset')
	
*1926 sqrt barracks capacity*
cap gen sqrt_barracks_capacity_1926 = sqrt(barracks_capacity_1926)
xtmelogit `basicdv' `h1_variables' `h2_variables' `h3_variables' `controls' sqrt_barracks_capacity_1926 ///
	|| qism:, nolog intpoints(8) or offset(`offset')

*1937 military base*
xtmelogit `basicdv' `h1_variables' `h2_variables' `h3_variables' `controls' british_military_base_1937 ///
	|| qism:, nolog intpoints(8) or offset(`offset')

********************************************************************************
*Robustness - MB leaders' social networks
********************************************************************************

*1937 Founder district*
xtmelogit `basicdv' `h1_variables' `h2_variables' `h3_variables' `controls' founder_district ///
	|| qism:, nolog intpoints(8) or offset(`offset')

*1937 Founder governorate*
xtmelogit `basicdv' `h1_variables' `h2_variables' `h3_variables' `controls' founder_governorate ///
	|| qism:, nolog intpoints(8) or offset(`offset')

********************************************************************************
*Tables 3 & A3 - 1940 survey - Multilevel logistic regression with ln(Muslims) as offset
********************************************************************************

*Model 5 - 1940 survey include dummy for branches present in 1937*
xtmelogit `alternativedv' `basicdv' `h1_variables' `h2_variables' `h3_variables' `controls' ///
	|| qism:, nolog intpoints(8) or offset(`offset')
 
*outreg2 using 1940_survey_results.doc, drop(mb_1940) ctitle(Odds ratio) eform alpha(0.001, 0.01, 0.05) replace

*penalized logistic regression (with 1937 dummy)*
firthlogit `alternativedv' `basicdv' `h1_variables' `h2_variables' `h3_variables' `offset' `controls' ///
	, or

*outreg2 using 1940_robustness_results.doc, drop(mb_1937) ctitle(Odds ratio) eform alpha(0.001, 0.01, 0.05) replace

********************************************************************************
*Figure 4 - Time series of Church Missionary Society Missionaries in Egypt, 1923-1939
********************************************************************************
use Brooke_Ketchley_APSR_replicationII, clear

twoway bar missionaries year, lwidth(medthick) ///
		ytitle(Missionaries) ///
		ylabel(0(20)80, nogrid) ///
		xlabel(,nogrid) ///
		tlabel(1923 1924 1925 1926 1927 1928 1929 1930 1931 1932 ///
		1933 1934 1935 1936 1937 1938 1939, angle(45)) ///
		xtitle(Year) ///
		scheme(plotplain) ///
		aspectratio(1)
		
*graph export "C:\Users\k1619065\Dropbox\MB paper\APSR_production\Brooke_Ketchley_fig4.pdf", as(pdf) replace


