***REPLICATION SYNTAX FOR THE PARTIES IN OUR HEADS: MISPERCEPTIONS ABOUT PARTY COMPOSITION AND THEIR CONSEQUENCES***

*Douglas J. Ahler
*Florida Satate University
*doug.ahler@gmail.com

*Gaurav Sood
*gsood07@gmail.com

*Data and scripts available online at: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/CLMQ8E
*See R replication code for figures

*PUT ALL THE DATA IN ONE WORKING DIRECTORY, THEN SET THAT AS THE WORKING DIRECTORY.
*cd "~/"

*****************************************
***ACTUAL PARTY COMPOSITION STATISTICS***
*****************************************

use "anes_timeseries_2012.dta", clear

	*Generating group variables
	gen union = 0
	replace union = 1 if dem_unionwho_r == 1
	replace orientn_rgay = . if ! inrange(orientn_rgay,1,3)
	recode orientn_rgay (1=0)(2/3=1), gen(lgb)
	gen south = 0
	replace south = 1 if inlist(sample_state,"TX","AR","MS","AL","LA","FL")
	replace south = 1 if inlist(sample_state,"GA","SC","NC","TN","VA")
	replace south = 1 if inlist(sample_state,"KY","DC")
	gen old = 0
	replace old = 1 if dem_agegrp_iwdate >= 11
	gen rich = 0
	replace rich = 1 if inc_incgroup_pre == 28
	replace pid_x = . if ! inrange(pid_x,1,7)
	gen pid_3 = "Dem" if inrange(pid_x,1,3)
	replace pid_3 = "Rep" if inrange(pid_x,5,7)
	replace pid_3 = "Ind" if pid_x == 4

*DEM-BLACK
tab dem_racecps_black if pid_3 == "Dem" [aw = weight_full]
	regress dem_racecps_black if pid_3 == "Dem" [aw = weight_full]
		*regsave using "fig_1_data_actual.dta", replace addlabel(Party, "Democratic", Group, "Black")
tab pid_3 if dem_racecps_black == 1 [aw = weight_full]

*DEM-UNION
tab union if pid_3 == "Dem" [aw = weight_full]
	regress union if pid_3 == "Dem" [aw = weight_full]
		*regsave using "fig_1_data_actual.dta", append addlabel(Party, "Democratic", Group, "Union")
tab pid_3 if union == 1 [aw = weight_full]

*DEM-LGB
tab lgb if pid_3 == "Dem" [aw = weight_full]
	regress lgb if pid_3 == "Dem" [aw = weight_full]
		*regsave using "fig_1_data_actual.dta", append addlabel(Party, "Democratic", Group, "LGB")
tab pid_3 if lgb == 1 [aw = weight_full]

*REP-SOUTH
	*NOTE: BASED ON STATES RESPONDENTS TO A REPRESENTATIVE 538 SURVEY CALLED "SOUTHERN" AT 50%+
tab south if pid_3 == "Rep" [aw = weight_full]
	regress south if pid_3 == "Rep" [aw = weight_full]
		*regsave using "fig_1_data_actual.dta", append addlabel(Party, "Republican", Group, "Southern")
tab pid_3 if south == 1 [aw = weight_full]

*REP-65+
tab old if pid_3 == "Rep" [aw = weight_full]
	regress old if pid_3 == "Rep" &  dem_agegrp_iwdate != -2 [aw = weight_full]
		*regsave using "fig_1_data_actual.dta", append addlabel(Party, "Republican", Group, "Age 65+")
tab pid_3 if old == 1 [aw = weight_full]

*REP-$250K+
tab rich if pid_3 == "Rep" [aw = weight_full]
	regress rich if pid_3 == "Rep" [aw = weight_full]
		*regsave using "fig_1_data_actual.dta", append addlabel(Party, "Republican", Group, "$250K+ Income")
tab pid_3 if rich == 1 [aw = weight_full]

/*
*RELIGIOUS GROUP-PARTY DYADS: SEE 2014 PEW RELIGION & PUBLIC LIFE REPORT FOR STATS USED HERE
use "fig_1_data_actual.dta", clear
set obs 8 
	drop var r2 N
	rename stderr se
	*DEM-AA
	*IN REPORT: 73% of atheist/agnostic are Democratic
	display (0.73 * 0.057) / 0.48
	replace coef = .0866875 in 7
	*Getting a SE estimate:
	display (1 - ((.48 * 2973) / 72000000)) * ((0.087)*(1-0.087) / ((.48 * 2973) - 1)) * 100
  	replace se = .00556993 in 7

	*REP-EVANG
	*IN REPORT: 71% of (white) evangelicals are Republican, 34.3% of Republicans are (white) evangelical
	replace coef = .343 in 8
	*Getting a SE estimate:
	display (1 - ((.43 * 2973) / 55000000)) * ((0.343)*(1-0.343) / ((.43 * 2973) - 1)) * 100
  	replace se = .01764111 in 8
	
	*Saving DTA for generating a figure
	replace Party = "Republican" if _n == 8
	replace Party = "Democratic" if _n == 7
	replace Group = "Evangelical" if _n == 8
	replace Group = "Atheist/Agnostic" if _n == 7
	rename coef actual_pct
	rename se actual_se
	replace actual_se = actual_se * 100
	replace actual_pct = actual_pct * 100
	save "fig_1_data_actual.dta", replace
*/

******************
***YOUGOV STUDY***
******************
use "pcomp_yougov_data.dta", clear

	**************************************************************
	***DESCRIPTIVE STATS USED IN FIGURE 1 AND TABLE 1, COLUMN 2***
	**************************************************************
	*Weights barely change results.
	reg dem_black
	reg dem_black [aw = weight]
		*regsave using "fig_1_data_perc.dta", replace addlabel(Party, "Democratic", Group, "Black")
	reg dem_union
	reg dem_union [aw = weight]
		*regsave using "fig_1_data_perc.dta", append addlabel(Party, "Democratic", Group, "Union")
	reg dem_aa
	reg dem_aa [aw = weight]
		*regsave using "fig_1_data_perc.dta", append addlabel(Party, "Democratic", Group, "Atheist/Agnostic")
	reg dem_lgb
	reg dem_lgb [aw = weight]
		*regsave using "fig_1_data_perc.dta", append addlabel(Party, "Democratic", Group, "LGB")

	reg rep_evang
	reg rep_evang [aw = weight]
		*regsave using "fig_1_data_perc.dta", append addlabel(Party, "Republican", Group, "Evangelical")
	reg rep_rich
	reg rep_rich [aw = weight]
		*regsave using "fig_1_data_perc.dta", append addlabel(Party, "Republican", Group, "$250K+ Income")
	reg rep_old
	reg rep_old [aw = weight]
		*regsave using "fig_1_data_perc.dta", append addlabel(Party, "Republican", Group, "Age 65+")
	reg rep_south
	reg rep_south [aw = weight]
		*regsave using "fig_1_data_perc.dta", append addlabel(Party, "Republican", Group, "Southern")
	
	/*
	use "fig_1_data_perc.dta", clear
	drop var r2 N
	rename stderr perc_se
	rename coef perc_mean

	merge 1:1 Group using "fig_1_data_actual.dta"
	drop _merge
	rename actual_se true_se
	rename actual_pct true_mean
	save "fig_1_data.dta", replace
	*/
	
	*****************************************************
	***AVERAGE % DEVIATION IN PERCEPTIONS FROM REALITY***
	*****************************************************
	gen mean_error_aa = (dem_aa - 8.7) / 8.7
	gen mean_error_black = (dem_black - 24) / 24
	gen mean_error_lgb = (dem_lgb - 6.3) / 6.3
	gen mean_error_union = (dem_union - 10.5) / 10.5
	gen mean_error_evang = (rep_evang - 34.3) / 34.3
	gen mean_error_south = (rep_south - 35.7) / 35.7
	gen mean_error_old = (rep_old - 21.3) / 21.3
	gen mean_error_rich = (rep_rich - 2.2) / 2.2	
	
	egen mean_error_dem = rowmean(mean_error_aa mean_error_black mean_error_lgb mean_error_union)
	egen mean_error_rep = rowmean(mean_error_rich mean_error_old mean_error_south mean_error_evang)
	egen mean_error_all = rowmean(mean_error_aa mean_error_black mean_error_lgb mean_error_union mean_error_rich mean_error_old mean_error_south mean_error_evang)
	
	reg mean_error_all [aw = weight]
	
	*********************************************
	***BY RESPONDENT PARTY (COL. 3-4, TABLE 1)***
	*********************************************
	gen pid_3 = .
	replace pid_3 = 1 if inlist(pid7, "Strong Democrat", "Not very strong Democrat", "Lean Democrat")
	replace pid_3 = 3 if inlist(pid7, "Strong Republican", "Not very strong Republican", "Lean Republican")
	replace pid_3 = 2 if pid7 == "Independent"
	label define party_lbl 1 "Democratic" 2 "Independent" 3 "Republican", replace
	label values pid_3 party_lbl
	bys pid_3: regress dem_black [aw=weight]
	bys pid_3: regress dem_aa [aw=weight]
	bys pid_3: regress dem_lgb [aw=weight]
	bys pid_3: regress dem_union [aw=weight]
	bys pid_3: regress rep_south [aw=weight]
	bys pid_3: regress rep_old [aw=weight]
	bys pid_3: regress rep_evang [aw=weight]
	bys pid_3: regress rep_rich [aw=weight]	
	
	*************************
	***MEAN ERROR BY PARTY***
	*************************
	gen repub = 0
	replace repub = 1 if pid_3 == 3
	gen demo = 0
	replace demo = 1 if pid_3 == 1
	
	reg mean_error_dem repub [aw = weight] if repub == 1 | demo == 1
	reg mean_error_rep demo [aw = weight] if repub == 1 | demo == 1
	
	**************************************************************************
	***LINEAR REGRESSIONS AND CI PLOTS TO ACCOMPANY LOESS PLOTS IN FIGURE 2***
	**************************************************************************
	*See R code for LOESS plots
	ciplot dem_black, by(newsint_r)
	ciplot dem_aa, by(newsint_r)
	ciplot dem_union, by(newsint_r)
	ciplot dem_lgb, by(newsint_r)

	regress dem_black newsint_r [aw = weight]
	regress dem_aa newsint_r [aw = weight]
	regress dem_union newsint_r [aw = weight]
	regress dem_lgb newsint_r [aw = weight]

	ciplot rep_rich, by(newsint_r)
	ciplot rep_evang, by(newsint_r)
	ciplot rep_south, by(newsint_r)
	ciplot rep_old, by(newsint_r)

	reg rep_rich newsint_r [aw = weight]
	reg rep_evang newsint_r [aw = weight]
	reg rep_south newsint_r [aw = weight]
	reg rep_old newsint_r [aw = weight]

	
************************************
***ALTERNATIVE EXPLANATIONS STUDY***
************************************
use "alt_exps_data.dta", clear

	**************************************************
	***DESCRIPTIVE STATISTICS FOR TABLE 1, COLUMN 5***
	**************************************************
	reg dem_black
	reg dem_union
	reg dem_lgb
	reg dem_aa
	reg rep_rich
	reg rep_evang
	reg rep_south
	reg rep_old
	
	****************************************
	***DESCRIPTIVE STATISTICS FOR TABLE 2***
	****************************************
	bys condition: reg dem_black
	bys condition: reg dem_union
	bys condition: reg dem_lgb
	bys condition: reg dem_aa
	bys condition: reg rep_rich
	bys condition: reg rep_evang
	bys condition: reg rep_south
	bys condition: reg rep_old
	
	************************************************************
	***NO REDUCTION IN MEAN PERCEPTUAL ERROR IN ANY CONDITION***
	************************************************************
	*GENERATING CONDITION DUMMIES
	gen simple = 0
	replace simple = 1 if condition == "simpleask"
	gen complex = 0
	replace complex = 1 if condition == "complexask"
	gen incentive = 0
	replace incentive = 1 if condition == "incentive"
	gen baserates = 0 
	replace baserates = 1 if condition == "baserates_given"

	gen error_rich = abs(rep_rich - 2.2)
	gen error_evang = abs(rep_evang - 34.3)	
	gen error_south = abs(rep_south - 35.7)	
	gen error_old = abs(rep_old - 21.3)
	gen error_black = abs(dem_black - 24)
	gen error_lgb = abs(dem_lgb - 6.3)	
	gen error_union = abs(dem_union - 10.5)
	gen error_aa = abs(dem_aa - 8.7)
	
	*RESHAPING
	gen respondent = _n
	reshape long error_, i(respondent) j(group) string

	*FE REGRESSION
	areg error_ complex incentive baserates, a(group) cluster(respondent)

	*NONPARAMETRIC
	ranksum error_ if simple == 1 | complex == 1, by(simple)
	ranksum error_ if simple == 1 | incentive == 1, by(simple)
	ranksum error_ if simple == 1 | baserates == 1, by(simple)
	
	
********************************************************
***OBSERVATIONAL EVIDENCE OF CONSEQUENCES -- IGS POLL***	
********************************************************
	
	use "pcomp_igspoll.dta", clear
	
	*GENERATING DVs FOR TABLE 4
		
		*Social distance
		egen sd_index = rowmean(sd_marry sd_nbor sd_work sd_potus) if (pid_3 == "D" & sd_marry_text == "Your son or daughter marrying a Republican") | (pid_3 == "R" & sd_marry_text == "Your son or daughter marrying a Democrat")
		
			*Reliability
			alpha sd_marry sd_nbor sd_work sd_potus  if (pid_3 == "D" & sd_marry_text == "Your son or daughter marrying a Republican") | (pid_3 == "R" & sd_marry_text == "Your son or daughter marrying a Democrat")
		
		*In-party allegiance
		egen vote_index = rowmean(pbi_votehouse pbi_potus pbi_switch) if inlist(pid_3, "D", "R")
		
			*Reliability 
			alpha pbi_votehouse pbi_potus pbi_switch
	
	*************
	***TABLE 4***
	*************
	*Column 1
	reg sd_index op_error [aw=weight]
	*Column 2
	reg sd_index op_error opgrps_ft repub strongpartisan [aw=weight]
	*Column 3
	reg vote_index op_error [aw=weight]
	*Column 4
	reg vote_index op_error opgrps_ft repub strongpartisan [aw=weight]
	
	*************
	***TABLE 3***
	*************

	*Observational evidence to correspond with Extremity Perceptions Study
	gen respondent = _n

	*Create placeholders for self/others variables
	gen singlepayer_self = .
	gen cutgovthealth_self = .
	gen pathtocit_self = .
	gen strongerborder_self = .
	gen taxrich_self = .
	gen lowercorptax_self = .
	gen strictbackcheck_self = .
	gen morefossilfuels_self = .
	gen captrade_self = .
	gen increasesocsec_self = .
	gen medicarevoucher_self = .
	gen substudentloans_self = .
	gen vouchers_self = .
	gen militaryoverdiplomacy_self = .
	gen useforcerussia_self = .
	gen livingwage_self = .
	gen righttowork_self = .
	gen monitorpolice_self = .
	gen noaffaction_self = .
	gen abortionondemand_self = .
	gen abortionban_self = .
	gen noexemptbc_self = .
	gen prossm_self = .
	gen legalpot_self = .
	gen prodeathpenalty_self = .

	gen singlepayer_dems = .
	gen cutgovthealth_dems = .
	gen pathtocit_dems = .
	gen strongerborder_dems = .
	gen taxrich_dems = .
	gen lowercorptax_dems = .
	gen strictbackcheck_dems = .
	gen morefossilfuels_dems = .
	gen captrade_dems = .
	gen increasesocsec_dems = .
	gen medicarevoucher_dems = .
	gen substudentloans_dems = .
	gen vouchers_dems = .
	gen militaryoverdiplomacy_dems = .
	gen useforcerussia_dems = .
	gen livingwage_dems = .
	gen righttowork_dems = .
	gen monitorpolice_dems = .
	gen noaffaction_dems = .
	gen abortionondemand_dems = .
	gen abortionban_dems = .
	gen noexemptbc_dems = .
	gen prossm_dems = .
	gen legalpot_dems = .
	gen prodeathpenalty_dems = .

	gen singlepayer_reps = .
	gen cutgovthealth_reps = .
	gen pathtocit_reps = .
	gen strongerborder_reps = .
	gen taxrich_reps = .
	gen lowercorptax_reps = .
	gen strictbackcheck_reps = .
	gen morefossilfuels_reps = .
	gen captrade_reps = .
	gen increasesocsec_reps = .
	gen medicarevoucher_reps = .
	gen substudentloans_reps = .
	gen vouchers_reps = .
	gen militaryoverdiplomacy_reps = .
	gen useforcerussia_reps = .
	gen livingwage_reps = .
	gen righttowork_reps = .
	gen monitorpolice_reps = .
	gen noaffaction_reps = .
	gen abortionondemand_reps = .
	gen abortionban_reps = .
	gen noexemptbc_reps = .
	gen prossm_reps = .
	gen legalpot_reps = .
	gen prodeathpenalty_reps = .

	*Cleaning self questions
	destring q5_1, replace
	destring q5_2, replace
	destring q5_3, replace
	destring q5_4, replace
	destring q5_5, replace
	destring q5_6, replace

	*Consolidating Dems and Reps questions
	gen dem_perc_1 = .
	gen dem_perc_2 = .
	gen dem_perc_3 = .
	gen dem_perc_4 = .
	gen dem_perc_5 = .
	gen dem_perc_6 = .
	foreach n in `"1"' `"2"' `"3"' `"4"' `"5"' `"6"'	{
		replace dem_perc_`n' = q19_`n'
		replace dem_perc_`n' = q147_`n' if dem_perc_`n' == .
			}

	gen rep_perc_1 = .
	gen rep_perc_2 = .
	gen rep_perc_3 = .
	gen rep_perc_4 = .
	gen rep_perc_5 = .
	gen rep_perc_6 = .
	foreach n in `"1"' `"2"' `"3"' `"4"' `"5"' `"6"'	{
		replace rep_perc_`n' = q98_`n'
		replace rep_perc_`n' = q148_`n' if rep_perc_`n' == .
	}

	*Writing a loop to fill in the values
	foreach n in `"1"' `"2"' `"3"' `"4"' `"5"' `"6"'	{
		replace singlepayer_self = q5_`n' if policy`n' == "The government should implement a single-payer health care system, directly providing insurance coverage for all Americans free of charge."
		replace cutgovthealth_self = q5_`n' if policy`n' == "The government should significantly cut spending on health care, only helping to pay for emergency care for the elderly and those with very low incomes."
		replace pathtocit_self = q5_`n' if policy`n' == "Undocumented immigrants living in the US who learn English, pay back taxes, and lack a criminal record should be allowed to stay in the country legally."
		replace strongerborder_self = q5_`n' if policy`n' == "The federal government should restrict and control people coming to live in our country more than it currently does."
		replace taxrich_self = q5_`n' if policy`n' == "The government should raise taxes on people who earn over $250,000 per year and cut taxes for people who earn less than that."
		replace lowercorptax_self = q5_`n' if policy`n' == "The government should lower the tax rate on corporations."
		replace strictbackcheck_self = q5_`n' if policy`n' == "There should be stricter background checks for gun purchasers."
		replace morefossilfuels_self = q5_`n' if policy`n' == "The government should promote the expansion of oil, coal, and natural gas production more than the development of alternative energy sources."
		replace captrade_self = q5_`n' if policy`n' == "To slow climate change, the government should institute a carbon tax on companies that would keep emissions at or just below their current levels."
		replace increasesocsec_self = q5_`n' if policy`n' == "Government-funded Social Security benefits should be increased."
		replace medicarevoucher_self = q5_`n' if policy`n' == "The government should reduce the rate of growth in Medicare spending by transitioning to a voucher system that helps seniors to buy private insurance instead of directly covering health costs."
		replace substudentloans_self = q5_`n' if policy`n' == "The federal government should subsidize student loans for low-income students."
		replace vouchers_self = q5_`n' if policy`n' == "The government should create a school voucher program, paying private and parochial school tuition for families so that they have choice over their children‰Ûªs education."
		replace militaryoverdiplomacy_self = q5_`n' if policy`n' == "US foreign policy should emphasize military strength over diplomacy."
		replace useforcerussia_self = q5_`n' if policy`n' == "The US should use military force if Russia invades a NATO ally (like Estonia or Latvia) as it did Ukraine."
		replace livingwage_self = q5_`n' if policy`n' == "The government should raise the minimum wage that employers must pay their workers to $13.10, the estimated living wage."
		replace righttowork_self = q5_`n' if policy`n' == "The government should pass a law guaranteeing all workers the right to hold their jobs in a company whose employees are represented by a union, regardless of whether they join that union or not."
		replace monitorpolice_self = q5_`n' if policy`n' == "The federal government should do more to make sure that local police forces treat people equally, regardless of race or ethnicity."
		replace noaffaction_self = q5_`n' if policy`n' == "It should be illegal for public universities to promote diversity on campus by considering applicants‰Ûª racial and ethnic backgrounds when admitting students."
		replace abortionondemand_self = q5_`n' if policy`n' == "Abortion should be legal under all circumstances."
		replace abortionban_self = q5_`n' if policy`n' == "Abortion should be illegal under all circumstances."
		replace noexemptbc_self = q5_`n' if policy`n' == "Insurance companies, pharmacists, and employers should be allowed to refuse selling or covering birth control."
		replace prossm_self = q5_`n' if policy`n' == "Same-sex couples should be allowed to marry."
		replace legalpot_self = q5_`n' if policy`n' == "Marijuana should be legal for adults to purchase and use recreationally, with government regulation similar to the regulation of alcohol."
		replace prodeathpenalty_self = q5_`n' if policy`n' == "The death penalty should be a legal option for punishing the most serious crimes."
	}

	foreach n in `"1"' `"2"' `"3"' `"4"' `"5"' `"6"'	{
		replace singlepayer_dems = dem_perc_`n' if policy`n' == "The government should implement a single-payer health care system, directly providing insurance coverage for all Americans free of charge."
		replace cutgovthealth_dems = dem_perc_`n' if policy`n' == "The government should significantly cut spending on health care, only helping to pay for emergency care for the elderly and those with very low incomes."
		replace pathtocit_dems = dem_perc_`n' if policy`n' == "Undocumented immigrants living in the US who learn English, pay back taxes, and lack a criminal record should be allowed to stay in the country legally."
		replace strongerborder_dems = dem_perc_`n' if policy`n' == "The federal government should restrict and control people coming to live in our country more than it currently does."
		replace taxrich_dems = dem_perc_`n' if policy`n' == "The government should raise taxes on people who earn over $250,000 per year and cut taxes for people who earn less than that."
		replace lowercorptax_dems = dem_perc_`n' if policy`n' == "The government should lower the tax rate on corporations."
		replace strictbackcheck_dems = dem_perc_`n' if policy`n' == "There should be stricter background checks for gun purchasers."
		replace morefossilfuels_dems = dem_perc_`n' if policy`n' == "The government should promote the expansion of oil, coal, and natural gas production more than the development of alternative energy sources."
		replace captrade_dems = dem_perc_`n' if policy`n' == "To slow climate change, the government should institute a carbon tax on companies that would keep emissions at or just below their current levels."
		replace increasesocsec_dems = dem_perc_`n' if policy`n' == "Government-funded Social Security benefits should be increased."
		replace medicarevoucher_dems = dem_perc_`n' if policy`n' == "The government should reduce the rate of growth in Medicare spending by transitioning to a voucher system that helps seniors to buy private insurance instead of directly covering health costs."
		replace substudentloans_dems = dem_perc_`n' if policy`n' == "The federal government should subsidize student loans for low-income students."
		replace vouchers_dems = dem_perc_`n' if policy`n' == "The government should create a school voucher program, paying private and parochial school tuition for families so that they have choice over their children‰Ûªs education."
		replace militaryoverdiplomacy_dems = dem_perc_`n' if policy`n' == "US foreign policy should emphasize military strength over diplomacy."
		replace useforcerussia_dems = dem_perc_`n' if policy`n' == "The US should use military force if Russia invades a NATO ally (like Estonia or Latvia) as it did Ukraine."
		replace livingwage_dems = dem_perc_`n' if policy`n' == "The government should raise the minimum wage that employers must pay their workers to $13.10, the estimated living wage."
		replace righttowork_dems = dem_perc_`n' if policy`n' == "The government should pass a law guaranteeing all workers the right to hold their jobs in a company whose employees are represented by a union, regardless of whether they join that union or not."
		replace monitorpolice_dems = dem_perc_`n' if policy`n' == "The federal government should do more to make sure that local police forces treat people equally, regardless of race or ethnicity."
		replace noaffaction_dems = dem_perc_`n' if policy`n' == "It should be illegal for public universities to promote diversity on campus by considering applicants‰Ûª racial and ethnic backgrounds when admitting students."
		replace abortionondemand_dems = dem_perc_`n' if policy`n' == "Abortion should be legal under all circumstances."
		replace abortionban_dems = dem_perc_`n' if policy`n' == "Abortion should be illegal under all circumstances."
		replace noexemptbc_dems = dem_perc_`n' if policy`n' == "Insurance companies, pharmacists, and employers should be allowed to refuse selling or covering birth control."
		replace prossm_dems = dem_perc_`n' if policy`n' == "Same-sex couples should be allowed to marry."
		replace legalpot_dems = dem_perc_`n' if policy`n' == "Marijuana should be legal for adults to purchase and use recreationally, with government regulation similar to the regulation of alcohol."
		replace prodeathpenalty_dems = dem_perc_`n' if policy`n' == "The death penalty should be a legal option for punishing the most serious crimes."
	}

	foreach n in `"1"' `"2"' `"3"' `"4"' `"5"' `"6"'	{
		replace singlepayer_reps = rep_perc_`n' if policy`n' == "The government should implement a single-payer health care system, directly providing insurance coverage for all Americans free of charge."
		replace cutgovthealth_reps = rep_perc_`n' if policy`n' == "The government should significantly cut spending on health care, only helping to pay for emergency care for the elderly and those with very low incomes."
		replace pathtocit_reps = rep_perc_`n' if policy`n' == "Undocumented immigrants living in the US who learn English, pay back taxes, and lack a criminal record should be allowed to stay in the country legally."
		replace strongerborder_reps = rep_perc_`n' if policy`n' == "The federal government should restrict and control people coming to live in our country more than it currently does."
		replace taxrich_reps = rep_perc_`n' if policy`n' == "The government should raise taxes on people who earn over $250,000 per year and cut taxes for people who earn less than that."
		replace lowercorptax_reps = rep_perc_`n' if policy`n' == "The government should lower the tax rate on corporations."
		replace strictbackcheck_reps = rep_perc_`n' if policy`n' == "There should be stricter background checks for gun purchasers."
		replace morefossilfuels_reps = rep_perc_`n' if policy`n' == "The government should promote the expansion of oil, coal, and natural gas production more than the development of alternative energy sources."
		replace captrade_reps = rep_perc_`n' if policy`n' == "To slow climate change, the government should institute a carbon tax on companies that would keep emissions at or just below their current levels."
		replace increasesocsec_reps = rep_perc_`n' if policy`n' == "Government-funded Social Security benefits should be increased."
		replace medicarevoucher_reps = rep_perc_`n' if policy`n' == "The government should reduce the rate of growth in Medicare spending by transitioning to a voucher system that helps seniors to buy private insurance instead of directly covering health costs."
		replace substudentloans_reps = rep_perc_`n' if policy`n' == "The federal government should subsidize student loans for low-income students."
		replace vouchers_reps = rep_perc_`n' if policy`n' == "The government should create a school voucher program, paying private and parochial school tuition for families so that they have choice over their children‰Ûªs education."
		replace militaryoverdiplomacy_reps = rep_perc_`n' if policy`n' == "US foreign policy should emphasize military strength over diplomacy."
		replace useforcerussia_reps = rep_perc_`n' if policy`n' == "The US should use military force if Russia invades a NATO ally (like Estonia or Latvia) as it did Ukraine."
		replace livingwage_reps = rep_perc_`n' if policy`n' == "The government should raise the minimum wage that employers must pay their workers to $13.10, the estimated living wage."
		replace righttowork_reps = rep_perc_`n' if policy`n' == "The government should pass a law guaranteeing all workers the right to hold their jobs in a company whose employees are represented by a union, regardless of whether they join that union or not."
		replace monitorpolice_reps = rep_perc_`n' if policy`n' == "The federal government should do more to make sure that local police forces treat people equally, regardless of race or ethnicity."
		replace noaffaction_reps = rep_perc_`n' if policy`n' == "It should be illegal for public universities to promote diversity on campus by considering applicants‰Ûª racial and ethnic backgrounds when admitting students."
		replace abortionondemand_reps = rep_perc_`n' if policy`n' == "Abortion should be legal under all circumstances."
		replace abortionban_reps = rep_perc_`n' if policy`n' == "Abortion should be illegal under all circumstances."
		replace noexemptbc_reps = rep_perc_`n' if policy`n' == "Insurance companies, pharmacists, and employers should be allowed to refuse selling or covering birth control."
		replace prossm_reps = rep_perc_`n' if policy`n' == "Same-sex couples should be allowed to marry."
		replace legalpot_reps = rep_perc_`n' if policy`n' == "Marijuana should be legal for adults to purchase and use recreationally, with government regulation similar to the regulation of alcohol."
		replace prodeathpenalty_reps = rep_perc_`n' if policy`n' == "The death penalty should be a legal option for punishing the most serious crimes."
	}

	*Recoding policy_self to 0 = Oppose and 1 = Support
	foreach q in `"singlepayer_self"' `"cutgovthealth_self"' `"pathtocit_self"' `"strongerborder_self"' `"taxrich_self	 "' `"lowercorptax_self"' `"strictbackcheck_self"' `"morefossilfuels_self"' `"captrade_self"' `"increasesocsec_self"' `"medicarevoucher_self"' `"substudentloans_self"' `"vouchers_self"' `"militaryoverdiplomacy_self "' `"useforcerussia_self"' `"livingwage_self"' `"righttowork_self"' `"monitorpolice_self"' `"noaffaction_self"' `"abortionondemand_self "' `"abortionban_self"' `"noexemptbc_self"' `"prossm_self"' `"legalpot_self"' `"prodeathpenalty_self"'	{
		recode `q' (1=1)(2=0)
	}

	*Beating data into shape for the P-Comp observational analyses
	rename singlepayer_dems pp_dem_singlepayer
	rename cutgovthealth_dems pp_dem_cutgovthealth
	rename pathtocit_dems pp_dem_pathtocit
	rename strongerborder_dems pp_dem_strongerborder
	rename taxrich_dems pp_dem_taxrich
	rename lowercorptax_dems pp_dem_lowercorptax
	rename strictbackcheck_dems pp_dem_strictbackcheck
	rename morefossilfuels_dems pp_dem_morefossilfuels
	rename captrade_dems pp_dem_captrade
	rename increasesocsec_dems pp_dem_increasesocsec
	rename medicarevoucher_dems pp_dem_medicarevoucher
	rename substudentloans_dems pp_dem_substudentloans
	rename vouchers_dems pp_dem_vouchers
	rename militaryoverdiplomacy_dems pp_dem_military
	rename useforcerussia_dems pp_dem_useforcerussia
	rename livingwage_dems pp_dem_livingwage
	rename righttowork_dems pp_dem_righttowork
	rename monitorpolice_dems pp_dem_monitorpolice
	rename noaffaction_dems pp_dem_noaffaction
	rename abortionondemand_dems pp_dem_abortionondemand
	rename abortionban_dems pp_dem_abortionban
	rename noexemptbc_dems pp_dem_noexemptbc
	rename prossm_dems pp_dem_prossm
	rename legalpot_dems pp_dem_legalpot
	rename prodeathpenalty_dems pp_dem_prodeathpenalty
	
	rename singlepayer_reps pp_rep_singlepayer
	rename cutgovthealth_reps pp_rep_cutgovthealth
	rename pathtocit_reps pp_rep_pathtocit
	rename strongerborder_reps pp_rep_strongerborder
	rename taxrich_reps pp_rep_taxrich
	rename lowercorptax_reps pp_rep_lowercorptax
	rename strictbackcheck_reps pp_rep_strictbackcheck
	rename morefossilfuels_reps pp_rep_morefossilfuels
	rename captrade_reps pp_rep_captrade
	rename increasesocsec_reps pp_rep_increasesocsec
	rename medicarevoucher_reps pp_rep_medicarevoucher
	rename substudentloans_reps pp_rep_substudentloans
	rename vouchers_reps pp_rep_vouchers
	rename militaryoverdiplomacy_reps pp_rep_military
	rename useforcerussia_reps pp_rep_useforcerussia
	rename livingwage_reps pp_rep_livingwage
	rename righttowork_reps pp_rep_righttowork
	rename monitorpolice_reps pp_rep_monitorpolice
	rename noaffaction_reps pp_rep_noaffaction
	rename abortionondemand_reps pp_rep_abortionondemand
	rename abortionban_reps pp_rep_abortionban
	rename noexemptbc_reps pp_rep_noexemptbc
	rename prossm_reps pp_rep_prossm
	rename legalpot_reps pp_rep_legalpot
	rename prodeathpenalty_reps pp_rep_prodeathpenalty

	*Genearting "difference" vars
	foreach i in `"singlepayer"' `"cutgovthealth"' `"pathtocit"' `"strongerborder"' `"taxrich"' `"lowercorptax"' `"strictbackcheck"' `"morefossilfuels"' `"captrade"' `"increasesocsec"' `"medicarevoucher"' `"substudentloans"' `"vouchers"' `"military"' `"useforcerussia"' `"livingwage"' `"righttowork"' `"monitorpolice"' `"noaffaction"' `"abortionondemand "' `"abortionban"' `"noexemptbc"' `"prossm"' `"legalpot"' `"prodeathpenalty"'	{
		gen policy_diff_`i' = pp_dem_`i' - pp_rep_`i'
	}

*Recoding for liberal items
	foreach i in `"singlepayer"' `"pathtocit"' `"taxrich"' `"strictbackcheck"' `"captrade"' `"increasesocsec"' `"substudentloans"' `"livingwage"' `"monitorpolice"' `"abortionondemand "' `"prossm"' `"legalpot"' `"prodeathpenalty"'	{
		replace pp_dem_`i' = 100 - pp_dem_`i'
		replace pp_rep_`i' = 100 - pp_rep_`i'
	}

	*Reshaping
	reshape long pp_dem_ pp_rep_ policy_diff_, i(v1) j(issue) string

	reshape long pp_, i(v1 issue) j(party) string

	*Getting the right error variables:
	gen perc_error = .
	replace perc_error = op_error if party == "dem_" & pid_3 == "R"
	replace perc_error = ip_error if party == "dem_" & pid_3 == "D"
	replace perc_error = op_error if party == "rep_" & pid_3 == "D"
	replace perc_error = ip_error if party == "rep_" & pid_3 == "R"

	replace pp_ = pp_ / 100
	
	***COLUMN 1
	areg pp_ perc_error if party == "dem_" [aw=weight], a(issue) cluster(respondent)
	***COLUMN 2
	areg pp_ perc_error opgrps_dem strongpartisan repub if party == "dem_" [aw=weight], a(issue) cluster(respondent)
	***COLUMN 3
	areg pp_ perc_error if party == "rep_" [aw=weight], a(issue) cluster(respondent)
	*COLUMN 4
	areg pp_ perc_error opgrps_rep strongpartisan repub if party == "rep_" [aw=weight], a(issue) cluster(respondent)
	

*************************************
***EXTREMITY PERCEPTION EXPERIMENT***
*************************************
use "extremity_exp_data.dta", clear
	
	**************************************************
	***DESCRIPTIVE STATISTICS FOR TABLE 2, COLUMN 3***
	**************************************************
	reg d_comp_per_black
	reg d_comp_per_union
	reg d_comp_per_lgb
	reg d_comp_per_aa
	reg r_comp_per_rich
	reg r_comp_per_evang
	reg r_comp_per_south
	reg r_comp_per_young
	
	*****************************************************************************
	***FIGURE 3 TRENDS, DESCRIBED VIA OLS (SEE R SCRIPT FOR FIGURE REPLICATION***
	*****************************************************************************

	*FIGURE 3A (MAIN EFFECT)
	areg perc_extreme ask tell if inlist(pid_3,1,3), a(policy) cluster(responseid)
	*FIGURE 3B (SLOPES WITHIN CONDITION)
	areg perc_extreme avg_error if control == 1 & inlist(pid_3,1,3), a(policy) cluster(responseid)
	areg perc_extreme avg_error if ask == 1 & inlist(pid_3,1,3), a(policy) cluster(responseid)
	areg perc_extreme avg_error if tell == 1 & inlist(pid_3,1,3), a(policy) cluster(responseid)
	
	******************
	***PLACEBO TEST***
	******************
	gen placebo_extreme = 0
	replace placebo_extreme = 1 if rep_per == 1 & pid_3 == 3
	replace placebo_extreme = 1 if dem_per == 0 & pid_3 == 1
	replace placebo_extreme = 1 if rep_per == 1 & pid_3 == 2 & d_comp_per_black != .
	replace placebo_extreme = 1 if dem_per == 0 & pid_3 == 2 & r_comp_per_evang != .

	areg placebo_extreme ask tell, a(policy) cluster(responseid)
	areg placebo_extreme ask tell if inlist(pid_3,1,3), a(policy) cluster(responseid)	

	/*
	*Creating a DTA for generating Figure 3
	areg perc_extreme if control == 1 & inlist(pid_3,1,3), a(policy) cluster(responseid)
		regsave using "ep_maineffects_plot_data.dta", replace addlabel(condition, "control", treat_n, 1, n_part, 278)
	areg perc_extreme if ask == 1 & inlist(pid_3,1,3), a(policy) cluster(responseid)
		regsave using "ep_maineffects_plot_data.dta", append addlabel(condition, "ask", treat_n, 2, n_part, 273)
	areg perc_extreme if tell == 1 & inlist(pid_3,1,3), a(policy) cluster(responseid)
		regsave using "ep_maineffects_plot_data.dta", append addlabel(condition, "tell", treat_n, 3, n_part, 258)		

	use "ep_maineffects_plot_data.dta", clear
	drop var r2
	rename N n
	rename stderr se
	rename coef mean
	save "ep_maineffects_plot_data.dta", replace
	*/

*****************************************************
***PARTISAN AFFECT EXPERIMENT 1: DV = OUT-PARTY FT***
*****************************************************

reshape wide dem_per rep_per op_ext_per ip_ext_per perc_extreme placebo_extreme, i(responseid) j(policy) string

	******************************************************************************
	***FIGURE 4 TRENDS, DESCRIBED VIA OLS (SEE R SCRIPT FOR FIGURE REPLICATION)***
	******************************************************************************
	gen ft_op_reverse = (100 - ft_op) / 100
	
	*FIGURE 4A (MAIN EFFECT)
	reg ft_op_reverse ask tell

	*FIGURE 4B (SLOPES WITHIN CONDITION)
	reg ft_op_reverse avg_error if control == 1
	reg ft_op_reverse avg_error if ask == 1
	reg ft_op_reverse avg_error if tell == 1
	
	*Interaction model
	reg ft_op_reverse i.control##c.avg_error i.ask##c.avg_error
	
	******************
	***PLACEBO TEST***
	******************
	gen ft_ip_reverse = (100 - ft_ip) / 100
	regress ft_ip_reverse ask tell
	
	/*
	*Creating a DTA for generating Figure 4
	reg ft_op_reverse if control == 1 & inlist(pid_3,1,3)
		regsave using "ft_maineffects_plot_data.dta", replace addlabel(condition, "control", treat_n, 1)
	reg ft_op_reverse if ask == 1 & inlist(pid_3,1,3)
		regsave using "ft_maineffects_plot_data.dta", append addlabel(condition, "ask", treat_n, 2)
	reg ft_op_reverse if tell == 1 & inlist(pid_3,1,3)
		regsave using "ft_maineffects_plot_data.dta", append addlabel(condition, "tell", treat_n, 3)		

	use "ft_maineffects_plot_data.dta", clear
	drop var r2
	rename N n
	rename stderr se
	rename coef mean
	save "ft_maineffects_plot_data.dta", replace
	*/

********************************************************
***PARTISAN AFFECT EXPERIMENT 2: DV = SOCIAL DISTANCE***
********************************************************
use "affect_exp_data.dta", clear
	
	*GENERATING VARS FOR FIG. 5
	egen sd_index = rowmean(sd_marriage sd_neighbor sd_work sd_potus)
	
	gen rich_error = rep_rich - 2.2
		egen max_rich_error = max(rich_error)
		egen min_rich_error = min(rich_error)
		gen rich_error01 = (rich_error - min_rich_error) / (max_rich_error - min_rich_error)
	gen evang_error = rep_evang - 34.3
		egen max_evang_error = max(evang_error)
		egen min_evang_error = min(evang_error)
		gen evang_error01 = (evang_error - min_evang_error) / (max_evang_error - min_evang_error)
	gen south_error = rep_south - 35.7
		egen max_south_error = max(south_error)
		egen min_south_error = min(south_error)
		gen south_error01 = (south_error - min_south_error) / (max_south_error - min_south_error)
	gen old_error = rep_old - 21.3
		egen max_old_error = max(old_error)
		egen min_old_error = min(old_error)
		gen old_error01 = (old_error - min_old_error) / (max_old_error - min_old_error)
	gen black_error = dem_black - 24
		egen max_black_error = max(black_error)
		egen min_black_error = min(black_error)
		gen black_error01 = (black_error - min_black_error) / (max_black_error - min_black_error)
	gen lgb_error = dem_lgb - 6.3
		egen max_lgb_error = max(lgb_error)
		egen min_lgb_error = min(lgb_error)
		gen lgb_error01 = (lgb_error - min_lgb_error) / (max_lgb_error - min_lgb_error)
	gen union_error = dem_union - 10.5
		egen max_union_error = max(union_error)
		egen min_union_error = min(union_error)
		gen union_error01 = (union_error - min_union_error) / (max_union_error - min_union_error)
	gen aa_error = dem_aa - 8.7
		egen max_aa_error = max(aa_error)
		egen min_aa_error = min(aa_error)
		gen aa_error01 = (aa_error - min_aa_error) / (max_aa_error - min_aa_error)
	egen avg_error = rowmean(aa_error01 black_error01 union_error01 lgb_error01 rich_error01 evang_error01 south_error01 old_error01)
	
	**************************************************
	***DESCRIPTIVE STATISTICS FOR TABLE 2, COLUMN 2***
	**************************************************
	reg dem_black
	reg dem_union
	reg dem_lgb
	reg dem_aa
	reg rep_rich
	reg rep_evang
	reg rep_south
	reg rep_old
	
	*************************************************
	***EXPERIMENTAL RESULTS, AS DEPICTED IN FIG. 5***
	*************************************************
	
	*FIGURE 5A (MAIN EFFECT)
	regress sd_index tell ask if inlist(pid_3,"D","R")
	
	*FIGURE 5B (SLOPES WITHIN CONDITION)
	regress sd_index avg_error if control == 1 & inlist(pid_3,"D","R")
	regress sd_index avg_error if ask == 1 & inlist(pid_3,"D","R")
	regress sd_index avg_error if tell == 1 & inlist(pid_3,"D","R")
	
