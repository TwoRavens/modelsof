
/*******************************************************
*This do file contains replication code for the article: 
"The Social Costs of Public Political Participation: Evidence from a Petition
 Experiment in Lebanon" by Laura Paler, Leslie Marshall and Sami Atallah.

For any questions regarding this replication dataset, contact Laura Paler at lpaler@pitt.edu

In this do file we:
	-Generate probability weights based on the sampling design
	-Run 10 rounds of missing data imputation using Stata's ice command for chained imputation
	-Create post-survey weights via raking and entropy balancing for each dataset
	-Combine the 10 datasets into one for analysis. 

Please note:
	-The missing data imputation here can produce slightly different versions of the data than the one
	used in the actual analysis. For that reason we also supply the dataset that we used for the actual analysis with the replication.
	
	-After saving "$final/lebsurv_imputed_FINAL_REP.dta" there was a data cleaning step where we recoded variables that we used in the analysis.
	We omit the code here for the sake of space but we follow a naming convention described in the Codebook so that readers can easily follow our recoding.
*******************************************************/


*******************************************************
*SET GLOBAL DIRECTORIES
*******************************************************

*cd ~/

* Create two sub-folders to output imputed datasets created by this do-file and create a folder called "IMPUTED" inside each of these
	global working "WORKING"
	global final "FINAL"

* Use cleaned dataset pre-imputation and pre-weights	
	use "lebsurv_preimpute_REP.dta", clear
	set more off


******************************************************
*CREATE POPULATION WEIGHTS BASED ON SURVEY PROBABILITIES
*Weights the sample up to all those eligible to have been sampled (adult citizens 18-65) based on 
*probabilities of selection from survey design
*******************************************************

*Probability a psu was selected within strata_label
	g pr_psu = 1/n_in_strata	

*Create population weights based on survey probabilities	
	bysort psu: egen mean_hh_size_psu = mean(q4_tot_hh_ppl)
	g n_hh_psu = n_residents_psu / mean_hh_size_psu
	g pr_hh = final_sample_ints / n_hh_psu
	g pr_ind2 = 1/q5_eligible_ppl	
	g prob2 = pr_psu*pr_hh*pr_ind2
	g wgt_main2a = 1/prob2
	
	

*******************************************************
*MACROS NEEDED FOR MISSING DATA IMPUTATION
*******************************************************

*Categorical outcomes
	local y_cat_all q85_a_first_concern q85_b_second_concern q85_c_third_concern

*Treat these as continuous
	local y_behave q80_overall_info_REC2 pet_sign_final fb_final q95_fb_interest_REC1 q93_fb_account
	local y_selfcat q83_a_resp_low_REC1 q83_b_resp_mid_REC1 q83_c_resp_upp_REC1 q83_d_resp_sun_REC1 q83_e_resp_chr_REC1 q83_f_resp_dru_REC1 q83_g_resp_shi_REC1 q83_h_resp_leb_REC1
	local y_groupdist q84_a_pchr_pmus_REC1 q84_b_rchr_rmus_REC1 q84_c_pchr_rchr_REC1 q84_d_pmus_rmus_REC1
	local y_policy q86_elect_law_REC1b q88_party_support_REC1 q89_pol_support_REC3
	local y_party q87_a_amal_REC1 q87_b_future_REC1 q87_c_fpm_REC1 q87_d_hezbollah_REC1 q87_e_lf_REC1 q87_f_phalanges_REC1 q87_g_psp_REC1 q87_h_ssp_REC1 q87_i_marada_REC1 q87_j_tashnag_REC1 
	local y_sectact q91_a_sect_REC1b q91_c_zaim_REC1b q91_f_sect_protest_REC1b q91_g_sect_party_REC1b
	local y_xsectact q91_b_othersect_REC1b q91_d_petition_REC1b q91_e_cs_protest_REC1b q91_h_cs_party_REC1b
	local y_xpress q90_a_enemies_REC1b q90_b_social_sanc_REC1b q90_c_unsure_REC1b
	local y_noeff q92_citizens_mob_REC1
	
*Group together
	local y_all `y_behave' `y_selfcat' `y_groupdist' `y_policy' `y_party' `y_sectact' `y_xsectact' `y_xpress' `y_noeff'
	
*MAP EXERCISE OUTCOME VARS
*Percent allocated to each district
	local y1_map q57_beirut_REC1 q57_baalbek_REC1 q57_hasbaya_REC1 q57_hermel_REC1 q57_rashaya_REC1  q57_westbek_REC1 q57_zahle_REC1 q57_aley_REC1  q57_baabda_REC1  q57_chouf_REC1  q57_jbeil_REC1  q57_keserwan_REC1 q57_metn_REC1   q57_bintjbeil_REC1  
	local y2_map q57_marjayoun_REC1 q57_nabatieh_REC1 q57_akkar_REC1 q57_batroun_REC1 q57_becharre_REC1  q57_koura_REC1  q57_mindin_REC1  q57_tripoli_REC1   q57_zgharta_REC1  q57_jezzine_REC1  q57_saida_REC1  q57_sour_REC1 
	
	local y_map_all `y1_map' `y2_map'

*CONTROL VARIABLES	
	local c_demo q31_educ age resp_gender  
	local c_oil  q55_a_imp_leb_REC1 q55_b_imp_sect_REC1 q55_c_imp_hh_REC1 q55_d_imp_elite_REC1
	local c_satis q36_a_help_zaim_REC1 q36_b_help_rel_REC1 q37_d_satis_mps_sect_REC1
	local c_eff q38_a_citizen_power_REC1 q38_b_official_power_REC1 
	local c_act q41_a_socialmedia q41_b_zaim q41_c_petition q41_d_protest q41_e_ngo
	local c_attach1 q59_a_neighbors_REC1 q59_b_supervised_REC1 q59_c_friends_REC1 q59_d_business_REC1 q59_e_marry_REC1 q35_sect_fut_REC1
	local c_attach2 q39_a_benefits_REC1 q39_b_econ_dev_REC1 q39_c_local_dev_REC1 q39_d_rep_govt_REC1 q39_e_leb_protect_REC1 q39_f_sect_protect_REC1 q39_g_sect_status_REC1 q39_h_stability_REC1 q40_support_sect_REC1
	local c_sanction q42_b_sanc_zaim_REC1 q42_d_sanc_fam_REC1 q42_e_sanc_sect_REC1
	local c_xpress q43_sect_contact_REC1 q44_econ_contact_REC1 q45_debate
	local c_id q46_a_age_REC1b q46_b_gender_REC1b q46_c_region_REC1b q46_d_sect_REC1b q46_e_job_REC1b q46_f_class_REC1b q46_g_lebanese_REC1b q60_primary_id_REC1
	local c_econ1 q66_main_earner q64_travel q70_subj_income_REC1 q71_econ_class_REC1 q73_tax_upper_REC1b q61_a_tv q61_b_desktop q61_c_phone q61_d_laptop q61_e_house_REC1 q61_f_car q62_elect_hrs q63_blackout_hrs_REC1 q69_hh_income_REC1 q67_resp_work_REC1 q68_resp_iga_REC3 q68_main_iga_REC3 
	
	local c_all `c_demo' `c_oil' `c_satis' `c_eff' `c_act' `c_attach1' `c_attach2' `c_sanction' `c_xpress' `c_id' `c_econ1' 
	
*Q72_a collinear so need to impute separately	
	local c_econ2 q72_b_rich_REC1 q72_c_mid_REC1 q72_d_poor_REC1 q72_e_expoor_REC1
	local c_econ3 q72_a_elite_REC1
	
*Impute two versions of q33 (REC4 is partially corrected by me first)	
	local c_sect1 q33_sect_REC3
	local c_sect2 q33_sect_REC4
	
*Categorical	
	local c_cat_demo q29_hh_head q30_marital q32_elect_dist 

	local c_cat_econ q74_first_econ_REC3 q75_second_econ_REC3	
	
	local c_cat_all `c_cat_demo' `c_cat_econ'

	
*TREATMENT INDICATORS	
	local z_treat T_econ_ineq T_econ_cleave T_econ_action T_pet_pub T_fb_pub T_map_econ T_map_sect
	

***********************************
*IMPUTE FULL DATASET (USING ICE)
*Impute in two rounds due to collinearity in econ_class
****************************************************

	save "$final/IMPUTED/lebsurv_imputed_0.dta", replace
	save "$final/IMPUTED/lebsurv_imputed_poststrat_0.dta", replace
		
	forvalues i = 1/10 {
		use "$final/IMPUTED/lebsurv_imputed_poststrat_0.dta", clear
		ice i.strata_label `c_econ2' `c_sect1' `z_treat' `y_cat_all' `c_cat_all' `y_all' `y_map_all' `c_all'  , cmd(`y_cat_all' `c_cat_all':mlogit, `y_all' `y_map_all' `c_all' `c_econ2' `c_sect1':regress) match m(1)  saving("$working/IMPUTED/lebsurv_imputed_`i'_temp1.dta", replace)  
		use "$working/IMPUTED/lebsurv_imputed_`i'_temp1.dta", clear
		keep if _mj==1
		rename _mj _mj1
		rename _mi _mi1
		ice i.strata_label `c_econ3' `c_sect2' `z_treat' `y_cat_all' `c_cat_all' `y_all' `y_map_all' `c_all' ,  cmd(`y_cat_all' `c_cat_all':mlogit, `y_all' `y_map_all' `c_all' `c_econ3' `c_sect2':regress) match m(1)  saving("$working/IMPUTED/lebsurv_imputed_`i'_temp2.dta", replace)  
		use "$working/IMPUTED/lebsurv_imputed_`i'_temp2.dta", clear
		keep if _mj==1
		save "$final/IMPUTED/lebsurv_imputed_`i'.dta", replace
	}


****************************************************
*DO POSTSTRATIFICATION WEIGHTING AND ENTROPY BALANCING WITHIN EACH DATASET
*Can only run raking on imputed data 1/10 but create variables for all datasets (for descriptive stats later)
****************************************************
	
	clear
	forval i = 0/10 { 
	use "$final/IMPUTED/lebsurv_imputed_`i'.dta", clear
	
	g female = resp_gender==2

	g q31_educ_secondary = q31_educ>=5
	
	g beirut = mohafaza=="Beirut"
	g mt_leb = mohafaza=="Mount Lebanon"
	g north = mohafaza=="North"
	g beqaa = mohafaza=="Beqaa"
	g south = mohafaza=="South"
	g nabatieh = mohafaza=="Nabatieh"
		
	recode q30_marital (2=1) (1 3 4 5=0), g(q30_married)

	g q33_maronite = q33_sect_REC4==1
	g q33_sunni = q33_sect_REC4==2
	g q33_shia = q33_sect_REC4==3
	g q33_druze = q33_sect_REC4==4
	
	g own_computer = q61_b_desktop>0 | q61_d_laptop>0 

	g own_car = q61_f_car>0
	
	recode q67_resp_work_REC1 (4/7=1) (1/3 8/9=0), g(employed)
	  
	g _one = 1

	save "$final/IMPUTED/lebsurv_imputed_`i'_v2.dta", replace
	
	}
	
	
*PREP FOR RAKING	
	clear
	forval i = 1/10 { 
	use "$final/IMPUTED/lebsurv_imputed_`i'_v2.dta", clear

	matrix female = (.489, .511)
	matrix colnames female = 0 1
	matrix coleq female = _one
	matrix rownames female = female
	matrix list female
   
	matrix q31_educ_secondary = (.479, .521)
	matrix colnames q31_educ_secondary = 0 1
	matrix coleq q31_educ_secondary = _one
	matrix rownames q31_educ_secondary = q31_educ_secondary
	matrix list q31_educ_secondary
  
	matrix q33_sect_REC4 = (.255, .274, .272, .077, .122)
	matrix colnames q33_sect_REC4 = 1 2 3 4 5
	matrix coleq q33_sect_REC4 = _one
	matrix rownames q33_sect_REC4 = q33_sect_REC4
	matrix list q33_sect_REC4
  
	matrix employed = (.348, .652)
	matrix colnames employed = 0 1
	matrix coleq employed = _one
	matrix rownames employed = employed
	matrix list employed
 
	
	egen adult_pop2a = sum(wgt_main2a)
	g wgt_main2a_convert = wgt_main2a/adult_pop2a


*IPF Raking command	
	ipfraking [pw=wgt_main2a_convert], generate(wgt_post2a) ctotal(female q31_educ_secondary q33_sect_REC4 employed) nograph
 
 
*Entropy balancing (the means come from the analysis of the Arab Barometer data).	
	ebalance beirut mt_leb beqaa south nabatieh age female q31_educ_secondary q30_married q33_sunni q33_shia q33_maronite q33_druze q69_hh_income_REC1 employed own_computer own_car, manualtargets (0.11 0.39 0.12 0.11 0.06 39 0.51 0.52 0.59 0.27 0.27 0.26 0.08 4.90 0.65 0.78 0.69)

	rename _webal wgt_ebal1

	ebalance beirut mt_leb beqaa south nabatieh age female q31_educ_secondary q30_married q33_sunni q33_shia q33_maronite q33_druze q69_hh_income_REC1 employed own_computer own_car, manualtargets (0.11 0.39 0.12 0.11 0.06 39 0.51 0.52 0.59 0.27 0.27 0.26 0.08 4.90 0.65 0.78 0.69) basewt(wgt_main2a)
	
	rename _webal wgt_ebal2
	
	save "$final/IMPUTED/lebsurv_imputed_poststrat_`i'.dta", replace

 }  	
	
****************************************************
*COMBINE DATASETS FOR ANALYSIS USING MI
****************************************************

	clear
	g m_impute = 0
	forval i = 0/10 { 
		append using "$final/IMPUTED/lebsurv_imputed_poststrat_`i'.dta", nol
	replace m_impute = `i' if m_impute == .
		}
	
	mi import flong, m(m_impute) id(resp_id) clear

	misstable sum wgt_post2a wgt_ebal1 `z_treat' `y_cat_all' `c_cat_all' `y_all' `y_map_all' `c_all' `c_econ2' `c_econ3' `c_sect1' `c_sect2' if m_impute==0

	misstable sum wgt_post2a wgt_ebal2 `z_treat' `y_cat_all' `c_cat_all' `y_all' `y_map_all' `c_all' `c_econ2' `c_econ3' `c_sect1' `c_sect2' if m_impute>0

	mi register imputed `z_treat' `y_cat_all' `c_cat_all' `y_all' `y_map_all' `c_all' `c_econ2' `c_econ3' `c_sect1' `c_sect2'

	save "$final/lebsurv_imputed_FINAL_REP.dta", replace






