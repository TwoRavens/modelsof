**************************************************************************************
** file name: 	ABD_2018.do                 										**
** purpose: 	estimation, producing tables and information for figures 			**
** paper:		do voters benchmark economic performance?							**
** date: 		march 2018															**
** authors: 	Vincent Arel-Bundock, André Blais & Ruth Dassonneville				**
**************************************************************************************


** install commands ( if not installed yet) 

ssc install mat2txt, replace all
ssc install estout, replace all

** set working directory to folder with replication materials

cd "/Users/yourname/Desktop/benchmarking/"


******************************
** 		MAIN RESULTS 		**
******************************


** Table 1 (OLS regression models with incumbent vote share as dependent variable)

use "KP2012_Benchmarking_Agg_Data.dta", clear

	* labeling variables
	label variable gr_an "Domestic Growth (Gy)"
	label variable gr_loc_pc_an "Local Growth (Gy-Gi)"
	label variable gr_glob_pc_an "Global Growth (Gi)"
	label variable unem_loc_pc_an "Local Unemployment"
	label variable unem_glob_pc_an "Global Unemployment"
	label variable coalsize "Coalition size"
	label variable pop "Population"
	label variable elecyr "Year"
	label variable enep "Eff.Num.Parties"
	label variable votelead_m1 "Leader vote lag"

	* estimating models
	quietly reg votelead gr_an gr_glob_pc_an unem_loc_pc_an unem_glob_pc_an, robust
	est store m1, title(Baseline')
	quietly reg votelead gr_an gr_glob_pc_an unem_loc_pc_an unem_glob_pc_an coalsize enep pop elecyr, robust
	est store m2, title('Controls')
	quietly reg votelead votelead_m1 gr_an gr_glob_pc_an unem_loc_pc_an unem_glob_pc_an coalsize enep pop elecyr, robust
	est store m3, title('Lag')
	quietly xtreg votelead votelead_m1 gr_an gr_glob_pc_an unem_loc_pc_an unem_glob_pc_an coalsize enep pop elecyr, fe robust i(ccode)
	est store m4, title('Lag + FE')

	* generate table
	esttab m1 m2 m3 m4 using "tables_and_figures/table1.tex", ///
	title("OLS regression models with incumbent vote share as dependent variable.\label{tab:kpreplication}") ///
	label mlabels(,titles) nogap compress r2 b(3) se(3) nonumbers star(* 0.1 ** 0.05 *** 0.01) replace booktabs
	

** Table 2 (Benchmarking with multiple reference points)

use "Aytac2017.dta", clear

	* generate numerical country variable
	encode country, generate(country_num)

	* generate constitutive variables (Aytac does not include all constitutive variables in his dataset)
	gen growth_intl = intl_growth
	gen growth_cycle = rel_intl_growth + growth_intl
	gen growth_hist = -1 * rel_dom_growth + growth_cycle

	* labeling variables
	label variable vote_prev "Vote share lag"
	label variable growth_intl "Gi"
	label variable growth_cycle "Gt"
	label variable growth_year "Gy"
	label variable growth_hist "Gh"
	label variable coalition "Coalition"
	label variable enp "ENP"
	label variable presidential "Presidential"
	label variable rerun "Re-run"

	* standardize moderator variables
	egen education_min = min(education)
	egen education_max = max(education)
	egen trade_intensity_min = min(trade_intensity)
	egen trade_intensity_max = max(trade_intensity)
	egen income_min = min(income)
	egen income_max = max(income)
	replace education = (education - education_min) / (education_max - education_min)
	replace trade_intensity = (trade_intensity - trade_intensity_min) / (trade_intensity_max - trade_intensity_min)
	replace income = (income - income_min) / (income_max - income_min)
	
	* estimating models
	eststo clear
	quietly reg inc_vote growth_year growth_intl vote_prev coalition enp presidential rerun, cluster(country)
	est store m1, title('International')

	quietly reg inc_vote growth_year growth_hist vote_prev coalition enp presidential rerun, cluster(country)
	est store m2, title('Historical')

	quietly reg inc_vote growth_year growth_intl growth_hist vote_prev coalition enp presidential rerun, cluster(country)
	est store m3, title('Both')

	quietly reg inc_vote growth_cycle growth_intl vote_prev coalition enp presidential rerun, cluster(country)
	est store m4, title('International')

	quietly reg inc_vote growth_cycle growth_hist vote_prev coalition enp presidential rerun, cluster(country)
	est store m5, title('Historical')

	quietly reg inc_vote growth_cycle growth_intl growth_hist vote_prev coalition enp presidential rerun, cluster(country)
	est store m6, title('Both')
	
	* generate table
	esttab m1 m2 m3 m4 m5 m6 using "tables_and_figures/table2.tex", ////// 
       title("Benchmarking with multiple reference points. OLS regressions with country-clustered standard errors.\label{tab:aytacinspired}") ///
       mlabels(,titles) nogap r2 b(3) se(3) star(* .1 ** .05 *** .01) nonumbers replace booktabs label

	   
** Figure 2 (marginal effect of international growth on votes for the incumbent in six regression models with 3 different moderators)

	/* note that the code below serves to estimate the models and to 
	calculate the marginal effects, the marginal effects are then saved
	for plotting in R (code not included here) */

	* local macros
	local cycle inc_vote c.growth_intl#c.Moderator c.growth_cycle#c.Moderator growth_intl growth_cycle Moderator vote_prev coalition enp presidential rerun, cluster(country)
	local year inc_vote c.growth_intl#c.Moderator c.growth_year#c.Moderator growth_intl growth_year Moderator vote_prev coalition enp presidential rerun, cluster(country)
	eststo clear

	* estimations
	gen Moderator = .
	replace Moderator = education

	quietly reg `cycle'
	est store m1, title('Education')
	quietly margins , dydx(growth_intl) at(Moderator = (0 .125 .25 .375 .5 .625 .75 .875 1))
	matrix K = r(table)'
	mat2txt , matrix(K) saving(aytac_interaction_mfx_cycle_education.csv) replace

	quietly reg `year'
	est store m2, title('Education')
	quietly margins , dydx(growth_intl) at(Moderator = (0 .125 .25 .375 .5 .625 .75 .875 1))
	matrix K = r(table)'
	mat2txt , matrix(K) saving(aytac_interaction_mfx_year_education.csv) replace

	replace Moderator = trade_intensity

	quietly reg `cycle'
	est store m3, title('Trade')
	quietly margins , dydx(growth_intl) at(Moderator = (0 .125 .25 .375 .5 .625 .75 .875 1))
	matrix K = r(table)'
	mat2txt , matrix(K) saving(aytac_interaction_mfx_cycle_trade.csv) replace

	quietly reg `year'
	est store m4, title('Trade')
	quietly margins , dydx(growth_intl) at(Moderator = (0 .125 .25 .375 .5 .625 .75 .875 1))
	matrix K = r(table)'
	mat2txt , matrix(K) saving(aytac_interaction_mfx_year_trade.csv) replace

	replace Moderator = income

	quietly reg `cycle'
	est store m5, title('Income')
	quietly margins , dydx(growth_intl) at(Moderator = (0 .125 .25 .375 .5 .625 .75 .875 1))
	matrix K = r(table)'
	mat2txt , matrix(K) saving(aytac_interaction_mfx_cycle_income.csv) replace

	quietly reg `year'
	est store m6, title('Income')
	quietly margins , dydx(growth_intl) at(Moderator = (0 .125 .25 .375 .5 .625 .75 .875 1))
	matrix K = r(table)'
	mat2txt , matrix(K) saving(aytac_interaction_mfx_year_income.csv) replace
 
	* generate table (Table A6 in Supplementary Information)
	esttab m1 m2 m3 m4 m5 m6 using "tables_and_figures/table_fig2.tex", ////// 
		   title("Conditional benchmarking. OLS regressions with country-clustered standard errors.\label{tab:aytacinteraction}") ///
		   mlabels(,titles) label nogap r2 b(3) se(3) star(* .1 ** .05 *** .01) nonumbers interaction(" X ") replace booktabs




**********************************
** 	SUPPLEMENTARY INFORMATION 	**
**********************************


** Table A1 (Model equivalence)

	use "KP2012_Benchmarking_Agg_Data.dta", clear
	
	* label variables
	label variable gr_an "Domestic Growth (Gy)"
	label variable gr_loc_pc_an "Local Growth (Gy-Gi)"
	label variable gr_glob_pc_an "Global Growth (Gi)"
	label variable unem_loc_pc_an "Local Unemployment"
	label variable unem_glob_pc_an "Global Unemployment"
	label variable coalsize "Coalition size"
	label variable pop "Population"
	label variable elecyr "Year"
	label variable enep "Eff.Num.Parties"
	label variable votelead_m1 "Leader vote lag"

	*estimate models
	quietly reg votelead gr_loc_pc_an gr_glob_pc_an unem_loc_pc_an unem_glob_pc_an coalsize enep pop elecyr, robust
	est store m1, title('KP')
	quietly reg votelead gr_an gr_glob_pc_an unem_loc_pc_an unem_glob_pc_an coalsize enep pop elecyr, robust
	est store m2, title('ABD')
	
	* generate table
	esttab m1 m2 using "tables_and_figures/tablea1.tex", ///
	title("The simple and complicated models of benchmarking are equivalent.\label{tab:equivalence}") ///
	label mlabels(,titles) nogap compress r2 b(6) se(6) nonumbers star(* 0.1 ** 0.05 *** 0.01) replace booktabs



** Table A2 (replication KP Table 1)

	* clear variable labels
	foreach var of varlist _all {
		label var `var' ""
	}

	* estimate models
	quietly reg votelead gr_an unem_an, robust
	est store m1
	
	quietly reg votelead gr_an gr_glob_med_an unem_an unem_glob_med_an, robust
	est store m2

	quietly reg votelead gr_an gr_glob_pc_an unem_an unem_glob_pc_an, robust
	est store m3

	quietly reg votelead gr_an gr_glob_tr_an unem_an unem_glob_tr_an, robust
	est store m4
	
	* generate table
	esttab m1 m2 m3 m4 using "tables_and_figures/tablea2.tex", ///
	title("Replication of KP Table 1 - Aggregate-level results for benchmarking in the economic vote") ///
	label mlabels(,titles) nogap compress r2 b(3) se(3) nonumbers star(* 0.1 ** 0.05 *** 0.01) replace booktabs


	
** Table A3 (replication KP table 3)

	* local macros
	local controls coalsize enep pop elecyr, robust
	local controls_ldv votelead_m1	coalsize enep pop elecyr, robust
	local controls_ldv_fe votelead_m1	coalsize enep pop elecyr, fe robust i(ccode)
	
	* estimate models
	quietly reg votelead gr_an gr_glob_med_an unem_an unem_glob_med_an `controls'
	est store m1
	
	quietly reg votelead gr_an gr_glob_pc_an unem_an unem_glob_pc_an `controls'
	est store m2
	
	quietly reg votelead gr_an gr_glob_tr_an unem_an unem_glob_tr_an `controls'
	est store m3
	
	quietly reg votelead gr_an gr_glob_med_an unem_an unem_glob_med_an `controls_ldv'
	est store m4
	
	quietly reg votelead gr_an gr_glob_pc_an unem_an unem_glob_pc_an `controls_ldv'
	est store m5
	
	quietly reg votelead gr_an gr_glob_tr_an unem_an unem_glob_tr_an `controls_ldv'
	est store m6
	
	quietly xtreg votelead gr_an gr_glob_med_an unem_an unem_glob_med_an `controls_ldv_fe'
	est store m7
	
	quietly xtreg votelead gr_an gr_glob_pc_an unem_an unem_glob_pc_an `controls_ldv_fe'
	est store m8
	
	quietly xtreg votelead gr_an gr_glob_tr_an unem_an unem_glob_tr_an `controls_ldv_fe'
	est store m9

	* generate table
	esttab m1 m2 m3 m4 m5 m6 m7 m8 m9 using "tables_and_figures/tablea3.tex", ///
	title("Replication of KP Table 3 - Robustness checks for aggregate level models") ///
	label mlabels(,titles) nogap compress r2 ar2  b(3) se(3) nonumbers star(* 0.1 ** 0.05 *** 0.01) replace booktabs


	
** Table A4 (replication of KP table 5)

	use "KP2012_Benchmarking_Ind_Data.dta", clear

	* create additional variables
	gen country = substr(elecstud,1,3)
	gen outside = (party==0)

	gen gr_lead = gr * lead
	gen unem_lead = unem * lead
	gen gr_loc_md_lead = gr_loc_md * lead
	gen gr_loc_pc_lead = gr_loc_pc * lead
	gen gr_loc_tr_lead = gr_loc_tr * lead
	gen gr_glob_md_lead = gr_glob_md * lead
	gen gr_glob_pc_lead = gr_glob_pc * lead
	gen gr_glob_tr_lead = gr_glob_tr * lead
	gen unem_loc_md_lead = unem_loc_md * lead
	gen unem_loc_pc_lead = unem_loc_pc * lead
	gen unem_loc_tr_lead = unem_loc_tr * lead
	gen unem_glob_md_lead = unem_glob_md * lead
	gen unem_glob_pc_lead = unem_glob_pc * lead
	gen unem_glob_tr_lead = unem_glob_tr * lead
	
	* estimate models
	quietly clogit votemulti outside lead dist gr_lead unem_lead, group(id) cluster(elecstud)
	est store m1
	
	quietly clogit votemulti outside lead dist gr_lead gr_glob_md_lead unem_lead unem_glob_md_lead, group(id) cluster(elecstud)
	est store m2

	quietly clogit votemulti outside lead dist gr_lead gr_glob_pc_lead unem_lead unem_glob_pc_lead, group(id) cluster(elecstud)
	est store m3

	quietly clogit votemulti outside lead dist gr_lead gr_glob_tr_lead unem_lead unem_glob_tr_lead, group(id) cluster(elecstud)
	est store m4
	
	* generate table
	esttab m1 m2 m3 m4  using "tables_and_figures/tablea4.tex", ///
	title("Replication of KP Table 5 - Individual-level results for benchmarking in the economic vote") ///
	label mlabels(,titles) nogap compress pr2   b(3) se(3) nonumbers star(* 0.1 ** 0.05 *** 0.01) replace booktabs


** Table A5 (replication of KP table 6)

	* create additional variables
	gen idf1 = id_family == 1
	gen idf2 = id_family == 2
	gen idf3 = id_family == 3
	gen idf4 = id_family == 4
	gen idf5 = id_family == 5
	gen idf6 = id_family == 6
	gen idf7 = id_family == 7
	gen idf8 = id_family == 8
	gen idf9 = id_family == 9
	gen idf10 = id_family == 10
	gen idf13 = id_family == 13
	gen year_founded_sq = year_founded^2

	gen gender_lead = gender * lead
	gen age_lead = age * lead
	gen income_lead = income * lead
	gen educ_lead = educ * lead

	gen idf1_gender = idf1 * gender
	gen idf2_gender = idf2 * gender
	gen idf3_gender = idf3 * gender
	gen idf4_gender = idf4 * gender
	gen idf5_gender = idf5 * gender
	gen idf6_gender = idf6 * gender
	gen idf7_gender = idf7 * gender
	gen idf8_gender = idf8 * gender
	gen idf9_gender = idf9 * gender
	gen idf10_gender = idf10 * gender
	gen idf13_gender = idf13 * gender

	gen idf1_age = idf1 * age
	gen idf2_age = idf2 * age
	gen idf3_age = idf3 * age
	gen idf4_age = idf4 * age
	gen idf5_age = idf5 * age
	gen idf6_age = idf6 * age
	gen idf7_age = idf7 * age
	gen idf8_age = idf8 * age
	gen idf9_age = idf9 * age
	gen idf10_age = idf10 * age
	gen idf13_age = idf13 * age

	gen idf1_income = idf1 * income
	gen idf2_income = idf2 * income
	gen idf3_income = idf3 * income
	gen idf4_income = idf4 * income
	gen idf5_income = idf5 * income
	gen idf6_income = idf6 * income
	gen idf7_income = idf7 * income
	gen idf8_income = idf8 * income
	gen idf9_income = idf9 * income
	gen idf10_income = idf10 * income
	gen idf13_income = idf13 * income

	gen idf1_educ = idf1 * educ
	gen idf2_educ = idf2 * educ
	gen idf3_educ = idf3 * educ
	gen idf4_educ = idf4 * educ
	gen idf5_educ = idf5 * educ
	gen idf6_educ = idf6 * educ
	gen idf7_educ = idf7 * educ
	gen idf8_educ = idf8 * educ
	gen idf9_educ = idf9 * educ
	gen idf10_educ = idf10 * educ
	gen idf13_educ = idf13 * educ

	gen yf_gender = year_founded * gender
	gen yf2_gender = year_founded_sq * gender

	gen yf_age = year_founded * age
	gen yf2_age = year_founded_sq * age

	gen yf_educ = year_founded * educ
	gen yf2_educ = year_founded_sq * educ
	
	* local macros
	local parties idf1-idf13 year_founded year_founded_sq, group(id) cluster(elecstud)
	local parties_demolead idf1-idf13 year_founded year_founded_sq gender_lead age_lead educ_lead, group(id) cluster(elecstud)
	local parties_demolead_demoparties idf1-idf13 year_founded year_founded_sq gender_lead age_lead educ_lead idf1_gender-idf13_gender idf1_age-idf13_age idf1_educ-idf13_educ yf_gender yf2_gender yf_age yf2_age yf_educ yf2_educ, group(id) cluster(elecstud)

	* estimate models
	quietly clogit votemulti lead dist gr_lead gr_glob_md_lead unem_lead unem_glob_md_lead `parties'
	est store m1
	
	quietly clogit votemulti lead dist gr_lead gr_glob_pc_lead unem_lead unem_glob_pc_lead `parties'
	est store m2
	
	quietly clogit votemulti lead dist gr_lead gr_glob_tr_lead unem_lead unem_glob_tr_lead `parties'
	est store m3

	quietly clogit votemulti lead dist gr_lead gr_glob_md_lead unem_lead unem_glob_md_lead `parties_demolead'
	est store m4
	
	quietly clogit votemulti lead dist gr_lead gr_glob_pc_lead unem_lead unem_glob_pc_lead `parties_demolead'
	est store m5
	
	quietly clogit votemulti lead dist gr_lead gr_glob_tr_lead unem_lead unem_glob_tr_lead `parties_demolead'
	est store m6
	
	quietly clogit votemulti lead dist gr_lead gr_glob_md_lead unem_lead unem_glob_md_lead `parties_demolead_demoparties'
	est store m7
	
	quietly clogit votemulti lead dist gr_lead gr_glob_pc_lead unem_lead unem_glob_pc_lead `parties_demolead_demoparties'
	est store m8
	
	quietly clogit votemulti lead dist gr_lead gr_glob_tr_lead unem_lead unem_glob_tr_lead `parties_demolead_demoparties'
	est store m9
	
	* generate table
	esttab m1 m2 m3 m4 m5 m6 m7 m8 m9 using "tables_and_figures/tablea5.tex", ///
	title("Replication of KP Table 6 - Robustness checks for individual-level models") ///
	label mlabels(,titles) nogap compress pr2   b(3) se(3) nonumbers star(* 0.1 ** 0.05 *** 0.01) replace booktabs

	
** Table A6 (see replication of Figure 2 in 'Main results'-section)
