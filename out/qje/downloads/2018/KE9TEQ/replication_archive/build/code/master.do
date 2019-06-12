/**************************************************************************
	
	Program: Master.do
	Last Update: February 2018
	JS/DT
	
	The purpose of this script is to run all of the build programs.
		
**************************************************************************

	0. Define filepaths

**************************************************************************/

	clear all
	set more off
	set maxvar 8000
	set seed 82114

	* File paths
	global path "/Volumes/research/advertising/build/_CLEAN"
	global input "$path/../input"
	global code "$path/code"
	global temp "$path/temp"
	global data "$path/data"
	global output "$path/output"
	
	* Election dates
	global election2004 "02nov2004"
	global election2008 "04nov2008"
	global election2012 "06nov2012"

	* Age-sex groups in Nielsen data
	global groups "male_2_plus male_18_34 male_35_64 male_65_plus male_35_plus male_18_plus female_2_plus female_18_34 female_35_64 female_65_plus female_35_plus female_18_plus"
	global agegroups "2_p 18_34 35_64 65_p 35_p 18_p"
	
	* Differenced variables
	#delimit;
	global df_variables "tot_pop_adult tot_pop_all pop_share_minority edu_dropout edu_hsplus edu_colplus lfp income pct_poverty 
						foreign_born_pct newspaper_slant turnout vote_share_rep vote_share2pty_rep vote_share_dem 
						vote_share2pty_dem vote_share_ptydf vote_share2pty_ptydf cand_visits cand_visits_dem cand_visits_rep cand_visits_ptydf lag_turnout_pres 
						lag_vote_share_ptydf lag_vote_share2pty_ptydf   
						cmag_prez_ptya_base cmag_prez_ptya_grp cmag_prez_ptya_uniq cmag_prez_ptya_1knads cmag_prez_ptya_pro cmag_prez_ptya_neg  
						cmag_prez_ptya_180days cmag_prez_ptya_120days cmag_prez_ptya_30days cmag_prez_ptya_2plus cmag_prez_rep_base 
						cmag_prez_dem_base cmag_prez_ptyd_base cmag_oth_ptya_base cmag_oth_ptya_grp cmag_oth_ptya_uniq cmag_oth_ptya_1knads 
						cmag_oth_ptya_pro cmag_oth_ptya_neg cmag_oth_ptya_180days cmag_oth_ptya_120days cmag_oth_ptya_30days cmag_oth_ptya_2plus 
						cmag_oth_rep_base cmag_oth_dem_base cmag_oth_ptyd_base news_ptya_freq news_ptya_count document_count";
	#delimit cr

/**************************************************************************

	1. Create background files

**************************************************************************/

	do "$code/prepare_xwalks.do"
	do "$code/clean_bls.do"
	do "$code/clean_census"
	do "$code/clean_border_matches"
	do "$code/clean_factiva"
	do "$code/clean_geolytics"
	do "$code/clean_newspaper"
	do "$code/clean_pres"
	do "$code/clean_sigviewed"
	do "$code/clean_visits"
	do "$code/clean_cq_pres"
	do "$code/clean_districts.do"	
	do "$code/create_lag_values.do" 
	
/**************************************************************************

	2. Run 2004 and 2008 Advertisements 

**************************************************************************/
	
	do "$code/prepare_national_ads_2008.do"
	do "$code/clean_nielsen.do" 2004
	do "$code/clean_nielsen.do" 2008
	do "$code/clean_cmag.do"
	
	foreach year in 2004 2008 {

		do "$code/append_advertising.do" `year'
		do "$code/clean_newsbank.do"
		do "$code/combine_data.do" `year'

	}

/**************************************************************************

	3. Run 2012 Advertisements 

**************************************************************************/

	do "$code/prepare_national_ads_2012.do"
	do "$code/clean_nielsen.do" 2012
	do "$code/collapse_nielsen_impressions_2012.do"
	do "$code/clean_wesleyan"
	do "$code/clean_nielsen.do" 2012
	do "$code/append_advertising.do" 2012
	do "$code/combine_data.do" 2012	

	do "$code/combine_years"
	
**************************************************************************/

* END OF FILE#
