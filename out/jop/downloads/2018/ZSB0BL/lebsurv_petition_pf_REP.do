
/*******************************************************
*This do file contains replication code for the article: 
"The Social Costs of Public Political Participation: Evidence from a Petition
 Experiment in Lebanon" by Laura Paler, Leslie Marshall and Sami Atallah.

For any questions regarding this replication dataset, contact Laura Paler at lpaler@pitt.edu

In this do file we:
	-Prepare the weights that we use in the population analysis
	-Run a program to create indices using inverse covariance weighting
	-Create indices used for the analysis of the sample and population
	-Create additional variables used in the analysis
	-Provide all code necessary to reproduce tables in the main text and appendix.
	
Please note:
	-We provide the dataset used in the actual anlaysis ("lebsurv_petition_pf_REP.dta")
	-Prior to the analysis we ran 10 rounds of missing data imputation using Stata's ice command for chained imputation.
	For replication code for this, see lebsurv_impute_REP.do included with this replication file. 
	-After saving "$final/lebsurv_imputed_FINAL_REP.dta" in lebsurv_impute_REP.do there was a data cleaning step where we 
	recoded variables that we used in the analysis. We omit the code here for the sake of space but we follow a naming convention 
	described in the Codebook so that interested readers can follow our recoding. 
*******************************************************/


*******************************************************
*SET GLOBAL DIRECTORIES
*******************************************************

*cd ~/

* Create a sub-folder to output tables created by this do-file
	global gt "G&T"

	use "lebsurv_petition_pf_REP.dta", clear
	set more off

		
*******************************************************
*PREPARE WEIGHT VARIABLES TO MAKE INDICES
*******************************************************
	
*Create a weight=1 for the sample (needed to run the make_index program below)	
	g wgt=1
	
*Trim one observation that gets very heavy weight	
	g wgt_ebal2b = wgt_ebal2	
	replace wgt_ebal2b = . if wgt_ebal2>25

*Create a version of the weight for use in index creation
*Replaces empty weights in the unimputed data with 1 so an index can be created for the raw data (not used in the analysis)	
	g wgt_eb = wgt_ebal2b
	replace wgt_eb=1 if wgt_eb==. & m_impute==0


/*******************************************************
*RUN PROGRAM TO MAKE INDICES
*The program below creates an index using inverse covariance weighting, a la Anderson (2008).
*The command is 'make_index' and it takes three arguments in a required sequence 
*	(1) The prefix for the name of the new index
*	(2) The sampling weight (used in the covariance matrix)
*	(3) The name of the local macro with the variables for the weighted index.
*******************************************************/
	
capture program drop make_index
	
program make_index
version 14
    syntax anything [if]
    gettoken newname anything: anything
    gettoken wgt anything: anything
    local Xvars `anything'
	marksample touse
	quietly: cor `Xvars' [aweight=`wgt']
	matrix S = r(C)
  	mata: icwxmata(("`Xvars'"),"`wgt'", "index")
	rename index index_`newname'
end
 
mata:
	mata clear
	function icwxmata(xvars, wgts, indexname)
	{
		st_view(X=0,.,tokens(xvars))
		st_view(wgt=.,.,wgts)
		nr = rows(X)
		nc = cols(X)
		wgtst = wgt/sum(wgt)
		wgtstdM = J(1,nc,1) # wgtst
		wgtdmeans = colsum(X:*wgtstdM)
		wgtdmeandevs = (X - J(nr,1,1) # wgtdmeans)
		wgtdstds = sqrt(colsum(wgt:*(wgtdmeandevs:*wgtdmeandevs)):/(sum(wgt)-1))
		Xs = wgtdmeandevs:/(J(nr,1,1) # wgtdstds)
		invS = invsym(st_matrix("S"))
		ivec = J(nc,1,1)
		indexout_sc = (invsym(ivec'*invS*ivec)*ivec'*invS*Xs')'
		indexout = (indexout_sc - J(nr,1,1)# mean(indexout_sc))/sqrt(variance(indexout_sc))
		st_addvar("float",indexname)
		st_store(.,indexname,indexout)
	}
end

*******************************************************
*MAKE INDICES
*This code stores local macros that are used to create covariate indices.
*It creates one set of indices to be used for analysis on the sample (wgt)
*It creates one set of indices to be used for analysis with population weights (wbt_eb)
*It also creates a binary version of the indices by dichotomizing at the median.
*******************************************************

	local c_fear_sanction q42_b_sanc_zaim_REC1b q42_d_sanc_fam_REC1b q42_e_sanc_sect_REC1b 
	local c_sect_benefits q39_a_benefits_REC1b q39_b_econ_dev_REC1b q39_c_local_dev_REC1b q39_d_rep_govt_REC1b q39_e_leb_protect_REC1b q39_f_sect_protect_REC1b q39_g_sect_status_REC1b q39_h_stability_REC1b q36_a_help_zaim_REC1 q37_d_satis_mps_sect_REC1b q40_support_sect_REC2
	local c_sect_prej q59_a_neighbors_REC1 q59_b_supervised_REC1 q59_c_friends_REC1 q59_d_business_REC1 q59_e_marry_REC1
	local c_sect_id q60_sect_id_REC1b q46_d_sect_REC1b 
	local c_econ_attach q46_e_job_REC1b q46_f_class_REC1b
	local c_dist_same q84_a_pchr_pmus_REC1 q84_b_rchr_rmus_REC1 
	local c_dist_poor_rich q84_c_pchr_rchr_REC1 q84_d_pmus_rmus_REC1 
	local c_pol_active q41_a_socialmedia q41_b_zaim q41_c_petition q41_d_protest q41_e_ngo
	local c_efficacy q38_a_citizen_power_REC1 q38_b_official_power_REC1b 
	local y_cross_press q90_a_enemies_REC1b q90_b_social_sanc_REC1b q90_c_unsure_REC1b
	local c_leb_identity q60_primary_id_REC1 q46_g_lebanese_REC1b 

	
*Create indices	
	foreach item in c_sect_benefits c_sect_prej c_sect_id c_econ_attach c_dist_same c_dist_poor_rich c_pol_active c_efficacy y_cross_press 	c_leb_identity c_fear_sanction {
		mi xeq: make_index `item' wgt ``item''
		mi xeq: xtile index_`item'_REC2 = index_`item', nquant(2)
		recode index_`item'_REC2 (2=1) (1=0)
				
		mi xeq: make_index `item'_eb wgt_eb ``item''
		mi xeq: xtile index_`item'REC2_eb = index_`item'_eb, nquant(2)
		recode index_`item'REC2_eb (2=1) (1=0)
	}


*For wealth indices also recodes in terciles	

	local c_high_class q61_a_tv q61_b_desktop q61_c_phone q61_d_laptop q61_e_house_REC1 q61_f_car q69_hh_income_REC1 q68_n_white_collar q71_econ_class_REC1b 
	
	foreach item in c_high_class {
		mi xeq: make_index `item' wgt ``item''
		mi xeq: xtile index_`item'_REC2 = index_`item', nquant(2)
		mi xeq: xtile index_`item'_REC3 = index_`item', nquant(3)
		recode index_`item'_REC2 (2=1) (1=0)
		recode index_`item'_REC3 (1=0) (2=1) (3=2) 
	
		mi xeq: make_index `item'_eb wgt_eb ``item''
		mi xeq: xtile index_`item'REC2_eb = index_`item'_eb, nquant(2)
		mi xeq: xtile index_`item'REC3_eb = index_`item'_eb, nquant(3)
		recode index_`item'REC2_eb (2=1) (1=0)
		recode index_`item'REC3_eb (1=0) (2=1) (3=2) 		
	}	
	
* Generate a variable equal to the poorest third of observations as determined by the "high-class wealth index"
	g index_poor2=index_c_high_class_REC3==0
	lab var index_poor2 "Poor"
	
	
*******************************************************
*CREATE ADDITIONAL VARIABLES USED IN THE ANALYSIS
*******************************************************
	
	g pubXfear_index = T_pet_pub*index_c_fear_sanction_REC2
	g pubXfear_zaim = T_pet_pub*q42_b_sanc_zaim_REC2 	
	g pubXfear_fam = T_pet_pub*q42_d_sanc_fam_REC2
	g pubXfear_sect = T_pet_pub*q42_e_sanc_sect_REC2
	
	g pubXfemale = T_pet_pub*female
	g pubXpoor = T_pet_pub*index_poor2
	
	g pubXmaronite = T_pet_pub*q33_maronite	
	g pubXsunni = T_pet_pub*q33_sunni
	g pubXshia = T_pet_pub*q33_shia
	
	g pubXsect_contact_REC2 = T_pet_pub*q43_sect_contact_REC2	
	
	lab var pubXfear_index "Public * Fear of sanctioning (index)"
	lab var pubXfear_zaim "Public * Fear of sanctioning by elites"
	lab var pubXfear_fam "Public * Fear of sanctioning by fam, friends"
	lab var pubXfear_sect "Public * Fear of sanctioning by community"
	
	lab var pubXfemale "Public * Female"
	lab var pubXpoor "Public * Poor"
	
	lab var pubXmaronite "Public * Maronite"
	lab var pubXsunni "Public * Sunni"
	lab var pubXshia "Public * Shia"
	
	
*******************************************************
*CREATE MACROS NEEDED FOR ANALYSIS
*Macros with _sate are used in the sample analysis and used indices created for sample
*Macros with _pate are used in the population analysis and used indices created for population (_eb)
*******************************************************

	global controls_demo     	  age q31_educ q29_hh_head_REC2 q30_married q43_sect_contact_REC1 majority co_sect1 q44_econ_contact_REC1 q33_maronite q33_shia q33_sunni female
	
	global controls_sate_indx     				 index_c_sect_benefits    index_c_sect_prej    index_c_sect_id    index_c_high_class    index_c_econ_attach    index_c_dist_same    index_c_dist_poor_rich    index_c_pol_active    index_c_efficacy    index_y_cross_press    index_c_leb_identity    index_c_fear_sanction 
	global controls_pate_indx     				 index_c_sect_benefits_eb index_c_sect_prej_eb index_c_sect_id_eb index_c_high_class_eb index_c_econ_attach_eb index_c_dist_same_eb index_c_dist_poor_rich_eb index_c_pol_active_eb index_c_efficacy_eb index_y_cross_press_eb index_c_leb_identity_eb index_c_fear_sanction_eb 
		
	global controls_sate_nofear   $controls_demo index_c_sect_benefits    index_c_sect_prej    index_c_sect_id    index_c_high_class    index_c_econ_attach    index_c_dist_same    index_c_dist_poor_rich    index_c_pol_active    index_c_efficacy    index_y_cross_press    index_c_leb_identity 
	global controls_pate_nofear   $controls_demo index_c_sect_benefits_eb index_c_sect_prej_eb index_c_sect_id_eb index_c_high_class_eb index_c_econ_attach_eb index_c_dist_same_eb index_c_dist_poor_rich_eb index_c_pol_active_eb index_c_efficacy_eb index_y_cross_press_eb index_c_leb_identity_eb 
	
	global controls_sate_all 	  $controls_demo $controls_sate_indx	
	global controls_pate_all 	  $controls_demo $controls_pate_indx
	
	global varsin_indices `c_sect_benefits' `c_sect_prej' `c_sect_id' `c_econ_attach' `c_dist_same' `c_dist_poor_rich' `c_pol_active' `c_efficacy' `y_cross_press' `c_leb_identity' `c_fear_sanction' `c_high_class'
	
	
*This macro contains vars used in post-survey weighting	
	global post_surv_wgt_vars beirut mt_leb north beqaa south nabatieh age female q31_educ_secondary q30_married q33_sunni q33_shia q33_maronite q33_druze q69_hh_income_REC1 employed own_computer own_car 
	
*This macro contains vars used in the het effects analysis	
	local het_vars_fear q42_b_sanc_zaim_REC2 q42_d_sanc_fam_REC2 q42_e_sanc_sect_REC2 
	local het_vars_grps female `c_high_class' q33_maronite q33_shia q33_sunni

	
*******************************************************
*TABLE 1 IN MAIN TEXT
*******************************************************
	
	est clear
	eststo: mi estimate, post: areg pet_sign_final T_pet_pub                     																				, absorb(strata_exp) cluster(id_psu)
	eststo: mi estimate, post: areg pet_sign_final T_pet_pub pubXfear_index  index_c_fear_sanction_REC2															, absorb(strata_exp) cluster(id_psu)
	eststo: mi estimate, post: areg pet_sign_final T_pet_pub pubXfear_zaim 	 q42_b_sanc_zaim_REC2 q42_d_sanc_fam_REC2 q42_e_sanc_sect_REC2						, absorb(strata_exp) cluster(id_psu)
	eststo: mi estimate, post: areg pet_sign_final T_pet_pub pubXfear_fam 	 q42_b_sanc_zaim_REC2 q42_d_sanc_fam_REC2 q42_e_sanc_sect_REC2						, absorb(strata_exp) cluster(id_psu)
	eststo: mi estimate, post: areg pet_sign_final T_pet_pub pubXfear_sect 	 q42_b_sanc_zaim_REC2 q42_d_sanc_fam_REC2 q42_e_sanc_sect_REC2						, absorb(strata_exp) cluster(id_psu)

	estout using "$gt/leb_main_results.xls", la replace cells(b(fmt(2) star) se(par(`"="("'`")""') fmt(2))) starl(* .05 ** .01  *** .001) noomitted stats(N_mi) stardrop(_cons)
	
*Store p-values on interaction for multiple hypothesis correction	
	estout using "$gt/leb_pvals.xls", replace keep(pubX*) cells(p(fmt(%9.3f))) label


***************************APPENDICES**************************************************************	
	
	
*******************************************************
*APPENDIX TABLE 2: BALANCE CHECK FOR SAMPLE
*Make sure .xls file is deleted before running (if running for a 2nd+ time)
*******************************************************
	
	foreach var of varlist $controls_sate_all $varsin_indices {
		est clear
		eststo: mi estimate, post: areg `var' T_pet_pub           , absorb(strata_exp) cluster(id_psu)
		estout using "$gt/leb_balance_sample.xls", append cells((b(fmt(%9.2f)) p(fmt(%9.3f)))) noomitted nobaselevels stardrop(_cons) stardetach mlabels(`var')
	}

	
*******************************************************
*BOUNDING THE EFFECT (DISCUSSED IN APPENDIX E.2)
*******************************************************

*Create a dataset for the attrited
	preserve
	clear
	set obs 1498
	g T_pet_pub = mod(_n,2)	
	g pet_sign_final = 0
	
	save "lebsurv_petition_pf_REP_temp.dta", replace
	
	use "lebsurv_petition_pf_REP.dta", clear

	keep if m_impute==0
	
	keep T_pet_pub pet_sign_final m_impute strata_exp id_psu
	
	append using "lebsurv_petition_pf_REP_temp.dta"
	
	mean pet_sign_final, over(T_pet_pub)
	
	reg pet_sign_final T_pet_pub
	
	restore

	
*******************************************************
*APPENDIX TABLE 3: ROBUSTNESS OF SAMPLE RESULTS TO CONTROLS
*******************************************************
	
	est clear
	eststo: mi estimate, post: areg pet_sign_final T_pet_pub 																			   $controls_sate_all    , absorb(strata_exp) cluster(id_psu)
	eststo: mi estimate, post: areg pet_sign_final T_pet_pub pubXfear_index  index_c_fear_sanction_REC2									   $controls_sate_nofear , absorb(strata_exp) cluster(id_psu)
	eststo: mi estimate, post: areg pet_sign_final T_pet_pub pubXfear_zaim 	 q42_b_sanc_zaim_REC2 q42_d_sanc_fam_REC2 q42_e_sanc_sect_REC2 $controls_sate_nofear , absorb(strata_exp) cluster(id_psu)
	eststo: mi estimate, post: areg pet_sign_final T_pet_pub pubXfear_fam 	 q42_b_sanc_zaim_REC2 q42_d_sanc_fam_REC2 q42_e_sanc_sect_REC2 $controls_sate_nofear , absorb(strata_exp) cluster(id_psu)
	eststo: mi estimate, post: areg pet_sign_final T_pet_pub pubXfear_sect 	 q42_b_sanc_zaim_REC2 q42_d_sanc_fam_REC2 q42_e_sanc_sect_REC2 $controls_sate_nofear , absorb(strata_exp) cluster(id_psu)
	
	estout using "$gt/leb_main_robust.xls", la replace cells(b(fmt(2) star) se(par(`"="("'`")""') fmt(2))) starl(* .05 ** .01  *** .001) noomitted drop($controls_sate_nofear) stats(N_mi) stardrop(_cons)

		
*******************************************************
*ADDITIONAL ANALYSIS: FEAR OF SOCIAL SANCTIONING (WITH NETWORK VARIABLES)
*******************************************************
	
*APPENDIX TABLE 5

*Obtain results with no controls (binary measure of homogeneity)
	est clear
	eststo: mi estimate, post: areg pet_sign_final T_pet_pub pubXsect_contact_REC2 q43_sect_contact_REC2			, absorb(strata_exp) cluster(id_psu)

*Store p-values on interaction for multiple hypothesis correction	
	estout using "$gt/leb_pvals.xls", append keep(pubX*) cells(p(fmt(%9.3f))) label
	
	estout using "$gt/pf_append_network1.xls", la replace cells(b(fmt(2) star) se(par(`"="("'`")""') fmt(2))) starl(* .05 ** .01  *** .001) noomitted stats(N_mi) stardrop(_cons)

	
*Obtain results with controls (binary neasure of homogeneity)	

*First create new control macros that drop q43_sect_contact_REC1 from analysis 	
	
	global controls_up $controls_sate_all
	global var_out q43_sect_contact_REC1

	unab  varlist  : $controls_up
	unab  drop_var : $var_out
	global newlist : list varlist - drop_var

*Run results	
	eststo: mi estimate, post: areg pet_sign_final T_pet_pub pubXsect_contact_REC2 q43_sect_contact_REC2   $newlist , absorb(strata_exp) cluster(id_psu)
	
	estout using "$gt/pf_append_network1.xls", la append cells(b(fmt(2) star) se(par(`"="("'`")""') fmt(2))) starl(* .05 ** .01  *** .001) noomitted drop($newlist) stats(N_mi) stardrop(_cons)

	
*APPENDIX TABLE 6	
*Estimate the marginal effects at five levels of q43_sect_contact_REC1
	
*Program to do this without controls	
	capture program drop leb_pf_marg_netw_nocont
		program leb_pf_marg_netw_nocont, eclass properties(mi)
			args DV hetvar
			version 13
			areg `DV' T_pet_pub##`hetvar', absorb(strata_exp) cluster(id_psu)
			margins, dydx(T_pet_pub) at(`hetvar'=(1 2 3 4 5)) atmeans post
			eststo margins
		end

	est clear
	eststo: mi estimate, esampvaryok cmdok post: leb_pf_marg_netw_nocont pet_sign_final q43_sect_contact_REC1 
	estout using "$gt/pf_append_network2.xls", replace cells((b(fmt(2) star) se(par(`"="("'`")""') fmt(2)))) starl(* .05 ** .01  *** .001) noomitted nobaselevels   

	
*Program to do this with controls		
	capture program drop leb_pf_marg_netw_cont
	program leb_pf_marg_netw_cont, eclass properties(mi)
		args DV hetvar controls
		version 14
			areg `DV' T_pet_pub##`hetvar' $newlist, absorb(strata_exp) cluster(id_psu)
			margins, dydx(T_pet_pub) at(`hetvar'=(1 2 3 4 5)) atmeans post
			eststo margins
	end

	est clear
	eststo: mi estimate, esampvaryok cmdok post: leb_pf_marg_netw_cont pet_sign_final q43_sect_contact_REC1 
	estout using "$gt/pf_append_network3.xls", replace cells((b(fmt(2) star) se(par(`"="("'`")""') fmt(2)))) starl(* .05 ** .01  *** .001) noomitted nobaselevels 

	

*******************************************************
*APPENDIX TABLE 7: DESCRIPTIVE STATS FOR HET EFFECTS VARS
*******************************************************

	foreach var of varlist `het_vars_fear' `het_vars_grps' {
		est clear
		estpost tabstat `var' if m_impute==0, listwise statistics(mean sd min max count) columns(statistics)
		esttab using "$gt/leb_het_vars1.csv", cells("mean sd min max count") nomtitle nonumber noobs append plain
	}
	
	
*******************************************************
*APPENDIX TABLE 8: HETEROGENEOUS EFFECTS BY SOCIAL GROUP
*******************************************************
	
*Adjust control macros for regression on poor (remove index)
*Use the adjusted macros in all regs with controls so can use index_poor2	
	global controls_up $controls_sate_all
	global var_out index_c_high_class
	unab  varlist  : $controls_up
	unab  drop_var : $var_out
	global controls_sate_poor : list varlist - drop_var
	
	
*OLS without controls	
est clear
	eststo: mi estimate, post: areg pet_sign_final T_pet_pub pubXfemale female								, absorb(strata_exp) cluster(id_psu)
	eststo: mi estimate, post: areg pet_sign_final T_pet_pub pubXpoor index_poor2							, absorb(strata_exp) cluster(id_psu)
	eststo: mi estimate, post: areg pet_sign_final T_pet_pub pubXmaronite q33_maronite						, absorb(strata_exp) cluster(id_psu)
	eststo: mi estimate, post: areg pet_sign_final T_pet_pub pubXsunni q33_sunni							, absorb(strata_exp) cluster(id_psu)
	eststo: mi estimate, post: areg pet_sign_final T_pet_pub pubXshia q33_shia								, absorb(strata_exp) cluster(id_psu)

*Store p-values on interaction for multiple hypothesis correction	
	estout using "$gt/leb_pvals.xls", append keep(pubX*) cells(p(fmt(%9.3f))) label

*OLS with controls	
	eststo: mi estimate, post: areg pet_sign_final T_pet_pub pubXfemale   index_poor2 $controls_sate_poor	, absorb(strata_exp) cluster(id_psu)
	eststo: mi estimate, post: areg pet_sign_final T_pet_pub pubXpoor 	  index_poor2 $controls_sate_poor	, absorb(strata_exp) cluster(id_psu)
	eststo: mi estimate, post: areg pet_sign_final T_pet_pub pubXmaronite index_poor2 $controls_sate_poor	, absorb(strata_exp) cluster(id_psu)
	eststo: mi estimate, post: areg pet_sign_final T_pet_pub pubXsunni    index_poor2 $controls_sate_poor	, absorb(strata_exp) cluster(id_psu)
	eststo: mi estimate, post: areg pet_sign_final T_pet_pub pubXshia     index_poor2 $controls_sate_poor	, absorb(strata_exp) cluster(id_psu)
	
	estout using "$gt/leb_append_soc_grps_results.xls", la replace cells(b(fmt(2) star) se(par(`"="("'`")""') fmt(2))) starl(* .05 ** .01  *** .001) noomitted stats(N_mi) keep(T_pet_pub pubX* female index_poor2 q33* _cons) stardrop(_cons)

	

*******************************************************
*APPENDIX TABLE 9: COMPARING THE SAMPLE TO THE POPULATION
*******************************************************
	
*Descriptives on the sample (no imputation)
	foreach var of varlist $post_surv_wgt_vars {
		est clear
		estpost tabstat `var' if m_impute==0, listwise statistics(mean sd min max count) columns(statistics)
		esttab using "$gt/survey_descrip_samp.csv", cells("mean sd count") nomtitle nonumber noobs append plain
	}
	
*Population estimates using three versions of the population weights (missing data imputed)
	
	foreach weight in wgt_main2a wgt_post2a wgt_ebal2 {
		mi svyset id_psu [pweight=`weight']
			est clear
			foreach y of varlist $post_surv_wgt_vars {
				cap drop y2
				qui: mi xeq : generate y2 = `y'^2 
				eststo: mi est, esampvaryok post: svy: mean `y' y2
				estadd scalar meanUp = _b[`y']
				estadd scalar sdUp = sqrt( _b[y2] - _b[`y']^2 )
				estadd scalar nUp = (e(N))
				cap drop y2
			}
			esttab using "$gt/survey_descrip_`weight'.csv", l replace scalar(meanUp sdUp nUp) sfmt(%9.2f %9.2f %9.0f) cells(none) noobs mti($post_surv_wgt_vars) equations(1)
		}		

	
	
*******************************************************
*APPENDIX TABLE 10: BALANCE CHECK FOR POPULATION 
*Make sure .xls file is deleted before running (if running a 2nd time)
*******************************************************
		
	foreach var of varlist $controls_pate_all $varsin_indices {
		est clear
		eststo: mi estimate, post: areg `var' T_pet_pub  [pweight=wgt_ebal2]    , absorb(strata_exp) cluster(id_psu)
		estout using "$gt/leb_balance_pop.xls", append cells((b(fmt(%9.2f)) p(fmt(%9.3f)))) noomitted nobaselevels stardrop(_cons) stardetach mlabels(`var')
	}

	

*******************************************************
*MAIN RESULTS FOR POPULATION
*Make sure .xls file is deleted before running (if running a 2nd time)
*******************************************************
	
*Main Results	
	est clear
	foreach weight in wgt_main2a wgt_post2a wgt_ebal2 {
		eststo: mi estimate, post: areg pet_sign_final T_pet_pub 					[pweight=`weight'] , absorb(strata_exp) cluster(id_psu)
		eststo: mi estimate, post: areg pet_sign_final T_pet_pub $controls_pate_all [pweight=`weight'] , absorb(strata_exp) cluster(id_psu)
	}
		
	estout using "$gt/leb_append_main_pop.xls", la replace cells(b(fmt(2) star) se(par(`"="("'`")""') fmt(2))) starl(* .05 ** .01  *** .001) noomitted keep(T_pet_pub _cons) stats(N_mi) stardrop(_cons)	
	
	
*Heterogeneous effects

	foreach weight in wgt_main2a wgt_post2a wgt_ebal2 {
		est clear
		eststo: mi estimate, post: areg pet_sign_final T_pet_pub pubXfear_index  index_c_fear_sanction_REC2														     [pweight=`weight'], absorb(strata_exp) cluster(id_psu)
		eststo: mi estimate, post: areg pet_sign_final T_pet_pub pubXfear_zaim 	 q42_b_sanc_zaim_REC2 q42_d_sanc_fam_REC2 q42_e_sanc_sect_REC2					     [pweight=`weight'], absorb(strata_exp) cluster(id_psu)
		eststo: mi estimate, post: areg pet_sign_final T_pet_pub pubXfear_fam 	 q42_b_sanc_zaim_REC2 q42_d_sanc_fam_REC2 q42_e_sanc_sect_REC2					     [pweight=`weight'], absorb(strata_exp) cluster(id_psu)
		eststo: mi estimate, post: areg pet_sign_final T_pet_pub pubXfear_sect 	 q42_b_sanc_zaim_REC2 q42_d_sanc_fam_REC2 q42_e_sanc_sect_REC2					     [pweight=`weight'], absorb(strata_exp) cluster(id_psu)
	
		eststo: mi estimate, post: areg pet_sign_final T_pet_pub pubXfear_index  index_c_fear_sanction_REC2									   $controls_pate_nofear [pweight=`weight'], absorb(strata_exp) cluster(id_psu)
		eststo: mi estimate, post: areg pet_sign_final T_pet_pub pubXfear_zaim 	 q42_b_sanc_zaim_REC2 q42_d_sanc_fam_REC2 q42_e_sanc_sect_REC2 $controls_pate_nofear [pweight=`weight'], absorb(strata_exp) cluster(id_psu)
		eststo: mi estimate, post: areg pet_sign_final T_pet_pub pubXfear_fam 	 q42_b_sanc_zaim_REC2 q42_d_sanc_fam_REC2 q42_e_sanc_sect_REC2 $controls_pate_nofear [pweight=`weight'], absorb(strata_exp) cluster(id_psu)
		eststo: mi estimate, post: areg pet_sign_final T_pet_pub pubXfear_sect 	 q42_b_sanc_zaim_REC2 q42_d_sanc_fam_REC2 q42_e_sanc_sect_REC2 $controls_pate_nofear [pweight=`weight'], absorb(strata_exp) cluster(id_psu)
	
		estout using "$gt/leb_append_het_`weight'.xls", la replace cells(b(fmt(2) star) se(par(`"="("'`")""') fmt(2))) starl(* .05 ** .01  *** .001) noomitted drop($controls_pate_nofear) stats(N_mi) stardrop(_cons)

	}
	
	

*******************************************************
*APPENDIX TABLE 14: MULTIPLE HYPOTHESIS TESTING ADJUSTMENT
*******************************************************

/* 
Refer to the p-values stored in "$gt/leb_pvals.xls" throughout this do-file. Follow the instructions in the do-file
from Anderson: "Anderson_fdr_sharpened_qvalues.do" included with this replication package. Cut and paste the relevant
p-values into that file (following the instructions) to obtain q-values and replicate Appendix Table 14.
*/
	
	

		
