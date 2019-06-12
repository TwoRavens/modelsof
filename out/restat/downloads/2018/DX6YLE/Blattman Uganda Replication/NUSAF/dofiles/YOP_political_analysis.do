/***************************************************************************
*			Title: NUSAF Analysis          
*			Output: Yop_data
*			Date: May, 2012
*			Files Used: 
****************************************************************************/

/***************************************************************************
*** 1. SET UP **************************************************************
****************************************************************************/

// CLEAR 
	drop _all 
	clear matrix
	clear mata
	
// SET PARAMETERS 
	set more off
	set varabbrev on
	set maxvar 27000

// TEMPORARY FILES
	tempfile yop parish
	

	

// SET DIRECTORY FOR OUTPUT
	cd "$NUSAF/YOP_politics_output"	 

// GLOBALS 
 	gl dv_econ_small "treated bizasset_val_real_p99_e totalhrs7da_zero_e zero_hours_e trade_dummy_e migrate_e urban_e capital_e profits4w_real_p99_e wealthindex_e consumption_real_p99_z_e"
	
	gl dv_main "epa_index_std_e ppa_index_std_e nrm_prez_std_e opposition_std_e e_influenced_std_e ldm_index_std_e contr_community_std_e protest_attitude_std_e existpatron_std_e" 
	
	gl dv_comp_epa "epa_index_std_e epavoteredu2011el_dum_e epadiscussvote2011el_dum_e epareportinc2011el_dum_e vote2011elprez_e" 
	gl dv_comp_ppa "ppa_index_std_e pparally2011el_resc_e ppaprimary2011el_resc_e partyworked_resc_e ppapartymember_e"
	gl dv_comp_part_nrm "nrm_prez_std_e nrmvote_e partyaffnrm_dum_e nrmclose_alt_e nrmworked_e partywmembnrm_e voteinc_dum_e apprprezcurrent_dum_e"
	gl dv_comp_part_opp "opposition_std_e oppvote_e partyaffopp_dum_e oppclose_alt_e oppworked_e partymembopp_e voteopp_dum_e"
	gl dv_comp_infl "e_influenced_std_e vb_offeredmoney_resc_e vb_threatened_resc_e vb_intimidated_resc_e tb_takentopoll_e cpneedinflvote_e"
	gl dv_comp_ldm "ldm_index_std_e ldmcomlc1_resc_e ldmcomother_resc_e ldmacceptc1_resc_e"
	gl dv_comp_contrcomm "contr_community_std_e contrpubgood_vol_dum_e comm_meet12m_dum_e comm_mobilizer_e belongs_to_group_e"
	gl dv_comp_protest "protest_attitude_std_e protests_e attptreasonjustified_resc_e attptviolencejustified_resc_e attptpolvioljustified_resc_e hcaptwish_e hcaptwouldgo_e hcaptwouldgoviol_e"
	gl dv_comp_patron "existpatron_std_e cpneedrelative_e cpneedrelbigman_e cpneedrellocpol_e cpneedinflvote_e" 
	gl dv_comp_part_fdc "fdc_std_e fdcvote_e partyafffdc_dum_e fdcclose_alt_e fdcworked_e partymembfdc_e"
	gl dv_comp_part_upc "upc_std_e upcvote_e partyafffupc_dum_e upcclose_alt_e upcworked_e partymembupc_e"
	gl dv_comp_part_dp "dp_std_e dpvote_e partyaffdp_dum_e dpclose_alt_e dpworked_e partymembdp_e"
	
	gl dv_other_elections "free2011el_resc_e secballott_e"
	gl dv_other_tax "taxcorrupt_e taxright_e"
	gl dv_other_enum "survey_gov_e survey_int_e survey_oth_e" 
	gl dv_other_lc "apprlc1current_e apprlc3current_e apprlc3previous_e apprlc5current_e apprlc5previous_e"
	gl dv_other_others "discusspol_resc_e intrightinfluence_e"	
	gl dv_comp_client_sumstat "vb_offeredmoney_often_e vb_offeredmoney_sometimes_e vb_offeredmoney_rarely_e vb_offeredmoney_never_e vb_threatened_often_e vb_threatened_sometimes_e vb_threatened_rarely_e vb_threatened_never_e vb_intimidated_often_e vb_intimidated_sometimes_e vb_intimidated_rarely_e vb_intimidated_never_e tb_takentopoll_e"
	 
	gl dv_other_futuretrans "helpfuturengocomm12mlik_e helpfuturegovcomm12mlik_e helpfuturengoyou12mlik_e helpfuturegovyou12mlik_e" 
	gl dv_other_rateecon "eccountrynowpos_e ecselfnowpos_e eccountrypastpos_e ecselfpastpos_e eccountryfuturepos_e ecselffuturepos_e" 
 
	gl ethnicgroup "acholi_dum alur_dum bagwere_dum iteso_dum karamojong_dum langi_dum lugbara_dum madi_dum"	
	gl ethnicgroup_imp "acholi_dum_imp alur_dum_imp bagwere_dum_imp iteso_dum_imp karamojong_dum_imp langi_dum_imp lugbara_dum_imp madi_dum_imp"	
	
	gl controls "$ctrl_indiv $H $K $E $G $P $districts"
	gl ctrl_indiv "age age_2 age_3 urban ind_found_b risk_aversion"
	gl ctrl_indiv_nofound "age age_2 age_3 urban risk_aversion"
	gl ctrl_indiv_noage "urban ind_found_b risk_aversion"
	gl H "education literate voc_training numeracy_numcorrect_m adl"
	gl K "wealthindex savings_6mo_p99 cash4w_p99 loan_100k loan_1mil"
	gl E "lowskill7da_zero lowbus7da_zero skilledtrade7da_zero highskill7da_zero acto7da_zero aghours7da_zero chores7da_zero zero_hours nonag_dummy emplvoc inschool"
	gl G "admin_cost_us groupsize_est_e grantsize_pp_US_est3 group_existed group_age ingroup_hetero ingroup_dynamic grp_leader grp_chair avgdisteduc"
	gl P "regsuccess2006 vote2006elprez vote2005ref vote2006ellcv ppapartymember comm_elections_dum comm_meetings comm_mobilizer comm_leaders ldmcomother ldmacceptc1"
	gl districts "D_1-D_13"

/***************************************************************************
*** 2. CALL DATA ***********************************************************
***************************************************************************/

// OPEN NUSAF DATASET
 	use "$NUSAF/data/yop_political_analysis.dta", clear
	

// SET SURVEY DESIGN
	svyset [pw=w_sampling_e], strata(district) psu(group_endline)	
	
 asdf

/***************************************************************************
*** T1. BASELINE BALANCE ***************************************************
****************************************************************************/
cap bysort groupid: egen count=rank(partid) if e1==1
cap bysort groupid: egen count2=rank(partid) if e2==1
replace count=count2 if e2
drop count2
 
local if_g_1 "group_unfound_b==0"
local if_g_2 "group_unfound_e1==0"
local if_g_3 "group_unfound_e2==0"
local if_i_1 "ind_found_b==1"
local if_i_2 "ind_found_e1==1"
local if_i_3 "ind_found_e2==1"
local e_1 "e1==1"
local e_2 "e1==1"
local e_3 "e2==1"
local attr_1 "ind_unfound_b"
local attr_2 "ind_unfound_e1"
local attr_3 "ind_unfound_e2"

foreach group in 1 2 3  {
	local g = `group'
	local i = 0 
	foreach x in groupsize_est_e grantsize_pp_US_est3 {
			local ++i
			local lab: var lab `x'
			local var_`i' `lab'
			qui sum `x' if assigned==0 & count==1 & `e_`group'' 
				local mean_c_`group'_`i' = r(mean) 
			count if count==1 & e1==1  	
				local n_`group'_`i'=e(N)
			qui reg `x' assigned $districts if `e_`group''  & count==1, cluster(group_endline)
				local diff_`group'_`i' = _b[assigned]
				qui testparm assigned
				local p_`group'_`i' = r(p)			
	}
	foreach x in group_existed {
			local ++i
			local lab: var lab `x'
			local var_`i' `lab'
			qui sum `x' if assigned==0 & count==1 & `e_`group''  & `if_g_`group''
				local mean_c_`group'_`i' = r(mean) 
			count if count==1 & e1==1  & `if_g_`group''
				local n_`group'_`i'=e(N)
			qui reg `x' assigned $districts if `e_`group''  & count==1 & `if_g_`group'', cluster(group_endline)
				local diff_`group'_`i' = _b[assigned]
				qui testparm assigned
				local p_`group'_`i' = r(p)
			}
			
	
	foreach x in `attr_`group''	{
			local ++i
			local lab: var lab `x'
			local var_`i' `lab'
			qui sum `x' if assigned==0 & `e_`group'' 
					local mean_c_`group'_`i' = r(mean) 
			count if assigned==0 & `e_`group'' 
					local n_`group'_`i'=e(N)
			qui reg `x' assigned $districts if `e_`group'' , cluster(group_endline)
					local diff_`group'_`i' = _b[assigned]
					qui testparm assigned
					local p_`group'_`i' = r(p)
			}
	
	foreach x in age female urban totalhrs7da_zero nonaghours7da_zero aghours7da_zero zero_hours emplvoc education literate voc_training wealthindex cash4w_p99 savings_6mo_p99 savings loan_100k regsuccess2006 vote2006elprez ppapartymember comm_leaders ldmcomother pres_nrm_prop_06 q195  {
			local ++i
			local lab: var lab `x'
			local var_`i' `lab'
			qui sum `x' if assigned==0 & `if_i_`group'' & `e_`group'' 
				local mean_c_`group'_`i' = r(mean)
			count if `if_i_`group'' & `e_`group'' 
				local n_`group'_`i'=e(N)
			qui reg `x' assigned $districts if `e_`group'' & `if_i_`group'', cluster(group_endline)
				local diff_`group'_`i' = _b[assigned]
				qui testparm assigned
				local p_`group'_`i' = r(p)	

	}	
			local ++i
			local var_`i' "P-value from F-test"
			svy: reg assigned groupsize_est_e grantsize_pp_US_est3 group_existed ind_unfound_b age female urban totalhrs7da_zero nonaghours7da_zero aghours7da_zero zero_hours emplvoc education literate voc_training wealthindex cash4w_p99 savings_6mo_p99 savings loan_100k regsuccess2006 vote2006elprez ppapartymember comm_leaders ldmcomother pres_nrm_prop_06 q195  if `if_i_`group''
				test groupsize_est_e grantsize_pp_US_est3 group_existed ind_unfound_b age female urban totalhrs7da_zero nonaghours7da_zero aghours7da_zero zero_hours emplvoc education literate voc_training wealthindex cash4w_p99 savings_6mo_p99 savings loan_100k regsuccess2006 vote2006elprez ppapartymember comm_leaders ldmcomother pres_nrm_prop_06 q195 
				local p_`group'_`i' = r(p)
}	

	

preserve
	clear
	local I `i'
	local G `g'

	set obs `=`I'+1'

		qui gen var = ""
		forv i = 1/`I' {
			qui replace var = "`var_`i''" in `i'
		}

		forv g = 1/`G' {
			foreach v in mean_c diff n p {
				qui gen `v'_`g' = ""
				forv i = 1/`I' {
					qui replace `v'_`g' = "``v'_`g'_`i''" in `i'
				}
			}
		}
		
		order n_1 n_2 n_3, last
		export excel using "T1 - Balance by round.xlsx", sheet(raw) sheetreplace firstrow(var)
		restore

	
	
	// 2012 ATTRITION AND F-TEST
		gl table table1_bis
			cap erase $table.xml
			cap erase $table.txt
			
		svy: reg ind_found_e2 groupsize_est_e grantsize_pp_US_est3 group_existed ind_unfound_b age female urban totalhrs7da_zero nonaghours7da_zero aghours7da_zero zero_hours emplvoc education literate voc_training wealthindex cash4w_p99 savings_6mo_p99 regsuccess2006 vote2006elprez ppapartymember comm_leaders ldmcomother pres_nrm_prop_06 q195 $districts if e2==1
			outreg2 using $table.xls, excel aster(se) bdec(3) br label 
		
		svy: reg assigned groupsize_est_e grantsize_pp_US_est3 group_existed ind_unfound_b age female urban totalhrs7da_zero nonaghours7da_zero aghours7da_zero zero_hours emplvoc education literate voc_training wealthindex cash4w_p99 savings_6mo_p99 regsuccess2006 vote2006elprez ppapartymember comm_leaders ldmcomother pres_nrm_prop_06 q195 if e2==1
		test groupsize_est_e grantsize_pp_US_est3 group_existed ind_unfound_b age female urban totalhrs7da_zero nonaghours7da_zero aghours7da_zero zero_hours emplvoc education literate voc_training wealthindex cash4w_p99 savings_6mo_p99 regsuccess2006 vote2006elprez ppapartymember comm_leaders ldmcomother pres_nrm_prop_06 q195
			outreg2 using $table.xls, excel aster(se) bdec(3) br label adds(F-test, r(F), Prob > F, `r(p)') 


/***************************************************************************
*** ITT IMPACTS (T2,3,4,8) *************************************************
****************************************************************************/


	local dv_main nrm_prez_std_e nrmvote_e partyaffnrm_dum_e nrmclose_alt_e nrmworked_e partywmembnrm_e voteinc_dum_e apprprezcurrent_dum_e opposition_std_e oppvote_e partyaffopp_dum_e oppclose_alt_e oppworked_e partymembopp_e voteopp_dum_e
	local dv_pol pol_std_e epavoteredu2011el_dum_e epadiscussvote2011el_dum_e epareportinc2011el_dum_e vote2011elprez_e pparally2011el_resc_e ppaprimary2011el_resc_e partyworked_resc_e ppapartymember_e 
	local dv_local apprlc1current_dum_e apprlc3current_dum_e apprlc5current_dum_e vote2011ellcv_e vote2011ellcvinccomb_dum_e vote2011ellcvinccomb_dum_nrm_e vote2011ellcvinccomb_dum_opp_e
	local dv_app  econ_std_e e_influenced_std_e existpatron_std_e social_int_n community_n contrpubgood_e2_n aggression_e2_n protest_e2_n migrate 
*	local dv_group  group_opposition_std_e  group_nrmvote_e group_partyaffnrm_dum_e group_nrmclose_alt_e 
	local dv_other e_influenced_std_e vb_offeredmoney_resc_e vb_threatened_resc_e vb_intimidated_resc_e tb_takentopoll_e cpneedinflvote_e existpatron_std_e cpneedrelative_e cpneedrelbigman_e cpneedrellocpol_e cpneedinflvote_e
	local dv_attribution attribution_govt attrimpl_1_e attrimpl_2_e attrimpl_3_e attrimpl_4_e attribution_local attrimpl_6_e attrimpl_7_e attrimpl_8_e attrimpl_9_e attribution_wb attrimpl_5_e attrimpl_10_e attrimpl_11_e attrimpl_12_e attrimpl_13_e attrimpl_14_e attrinterpretation1_2 attrinterpretation1_incsup attrinterpretation1_1 attrinterpretation1_4 attrinterpretation1_5 attrinterpretation1_3 attrinterpretation1_dk attrinterpretation1_6 attrinterpretation1_7 attrselectreason_1_e attrselectreason_hardwork attrselectreason_2_e attrselectreason_3_e attrselectreason_4_e attrselectreason_5_e attrselectreason_6_e attrselectreason_7_e attrselect_1 attrselect_2 attrselect_3 attrselect_4 attrselect_5 attrselect_dk selfair_e anytransferlikely_e

	local dv_other_appendix $dv_other_elections $dv_other_tax $dv_other_enum $dv_other_lc $dv_attribution polknowledge 

	
	foreach fam in app main pol local /*group*/ other  other_appendix attribution {
	/* Set counter */
		local i = 0
		/* Loop over outcomes of interest */
		foreach y in `dv_`fam''  {
		/* Increment counter */
			local ++i
			/* Get var label */
			local var_`i': var lab `y'
			
				/* Get mean and sd by group */
				qui sum `y' [iw=w_sampling_e] if e2==1 & assigned==0 
					local m_`i' = r(mean)
					
				/* Run ITT regression,*/
				 qui svy: reg `y' female $ctrl_indiv $H $K $E $G $districts assigned if e2==1
					local b_`i' = _b[assigned]
					local se_`i' = _se[assigned]
					local p_`i' = 2*ttail(e(df_r),abs(_b[assigned]/_se[assigned]))
					local N_`i' = e(N)	
	
			/* Format standard errors */
			foreach x in `i'  {
					local se_`x' = round(`se_`x'',.001)
					/* Occasionally the round function gives output 
					like 1.2340000000000001. Here, we truncate those outputs */
						local dec = ""
						local dec = substr("`se_`x''",strpos("`se_`x''","."),.)
						if (strlen("`dec'")>4 ) local se_`x' = substr("`se_`x''",1,strpos("`se_`x''",".")+3)
						if (strlen("`dec'")==3) local se_`x' = "`se_`x''0"
						if (strlen("`dec'")==2) local se_`x' = "`se_`x''00"
						if (strlen("`dec'")<2 ) local se_`x' = "`se_`x''000"
					/* Put some brackets and asterisks on the standard errors */
						local se_`x' = "[`se_`x'']"
						if (`p_`x''<=.1 ) local se_`x' = "`se_`x''*"
						if (`p_`x''<=.05) local se_`x' = "`se_`x''*"
						if (`p_`x''<=.01) local se_`x' = "`se_`x''*"
			}
		}

		/* Get number of DVs */
		local I = `i'
		/* Create matrix for results */
		preserve
			clear
			qui set obs `I'
			qui gen var = ""
			forv i = 1/`I' {
				qui replace var = "`var_`i''" in `i'
			}
			
				foreach x in m b se N {
					qui gen `x' = ""
					forv i = 1/`I' {
						qui replace `x' = "``x'_`i''" in `i'
					}
				}
			
			export excel using "T - ITT.xlsx", sheet("raw - `fam'") sheetreplace firstrow(var)
		restore
		}
		/* End of table */


 
 
/***************************************************************************
*** T5 - ATTRIBUTION *********************************************************
****************************************************************************/

********************************************************************************
* Attribution similar to ITT ***************************************************
********************************************************************************
// same as above. Means you don't have to run everything at once. 
local dv_attribution attribution_govt attrimpl_1_e attrimpl_2_e attrimpl_3_e attrimpl_4_e attribution_local attrimpl_6_e attrimpl_7_e attrimpl_8_e attrimpl_9_e attribution_wb attrimpl_5_e attrimpl_10_e attrimpl_11_e attrimpl_12_e attrimpl_13_e attrimpl_14_e attrinterpretation1_2 attrinterpretation1_incsup attrinterpretation1_1 attrinterpretation1_4 attrinterpretation1_5 attrinterpretation1_3 attrinterpretation1_dk attrinterpretation1_6 attrinterpretation1_7 attrselectreason_1_e attrselectreason_hardwork attrselectreason_2_e attrselectreason_3_e attrselectreason_4_e attrselectreason_5_e attrselectreason_6_e attrselectreason_7_e attrselect_1 attrselect_2 attrselect_3 attrselect_4 attrselect_5 attrselect_dk selfair_e anytransferlikely_e

foreach fam in attribution {
	/* Set counter */
		local i = 0
		/* Loop over outcomes of interest */
		foreach y in `dv_`fam''  {
		/* Increment counter */
			local ++i
			/* Get var label */
			local var_`i': var lab `y'
			
				/* Get mean and sd by group */
				qui sum `y' [iw=w_sampling_e] if e2==1 & assigned==0 
					local m_`i' = r(mean)
					
				/* Run ITT regression,*/
				 qui svy: reg `y' female $ctrl_indiv $H $K $E $G $districts assigned if e2==1
					local b_`i' = _b[assigned]
					local se_`i' = _se[assigned]
					local p_`i' = 2*ttail(e(df_r),abs(_b[assigned]/_se[assigned]))
					local N_`i' = e(N)	
	
			/* Format standard errors */
			foreach x in `i'  {
					local se_`x' = round(`se_`x'',.001)
					/* Occasionally the round function gives output 
					like 1.2340000000000001. Here, we truncate those outputs */
						local dec = ""
						local dec = substr("`se_`x''",strpos("`se_`x''","."),.)
						if (strlen("`dec'")>4 ) local se_`x' = substr("`se_`x''",1,strpos("`se_`x''",".")+3)
						if (strlen("`dec'")==3) local se_`x' = "`se_`x''0"
						if (strlen("`dec'")==2) local se_`x' = "`se_`x''00"
						if (strlen("`dec'")<2 ) local se_`x' = "`se_`x''000"
					/* Put some brackets and asterisks on the standard errors */
						local se_`x' = "[`se_`x'']"
						if (`p_`x''<=.1 ) local se_`x' = "`se_`x''*"
						if (`p_`x''<=.05) local se_`x' = "`se_`x''*"
						if (`p_`x''<=.01) local se_`x' = "`se_`x''*"
			}
		}

		/* Get number of DVs */
		local I = `i'
		/* Create matrix for results */
		preserve
			clear
			qui set obs `I'
			qui gen var = ""
			forv i = 1/`I' {
				qui replace var = "`var_`i''" in `i'
			}
			
				foreach x in m b se N {
					qui gen `x' = ""
					forv i = 1/`I' {
						qui replace `x' = "``x'_`i''" in `i'
					}
				}
			
			export excel using "T - ITT.xlsx", sheet("raw - `fam'") sheetreplace firstrow(var)
		restore
		}
		/* End of table */


 

 
 
 
	gl table "T5 - Attribution"
		cap erase $table.xml
		cap erase $table.txt
		
	cap matrix drop E
	gl attribution attribution_govt attrimpl_1_e attrimpl_2_e attrimpl_3_e attrimpl_4_e attribution_local attrimpl_6_e attrimpl_7_e attrimpl_8_e attrimpl_9_e attribution_wb attrimpl_5_e attrimpl_10_e attrimpl_11_e attrimpl_12_e attrimpl_13_e attrimpl_14_e attrinterpretation1_2 attrinterpretation1_incsup attrinterpretation1_1 attrinterpretation1_4 attrinterpretation1_5 attrinterpretation1_3 attrinterpretation1_dk attrinterpretation1_6 attrinterpretation1_7 attrselectreason_1_e attrselectreason_hardwork attrselectreason_2_e attrselectreason_3_e attrselectreason_4_e attrselectreason_5_e attrselectreason_6_e attrselectreason_7_e attrselect_1 attrselect_2 attrselect_3 attrselect_4 attrselect_5 attrselect_dk selfair_e anytransferlikely_e

	foreach x of varlist $attribution {
		 qui sum `x' if assigned==1 & e2==1
			sca c_mu = r(mean)
		 qui sum `x' if assigned==0 & e2==1
			sca d_mu = r(mean)
		 qui reg `x' assigned $districts if e2==1, cluster(group_endline)
			sca b_hat = _b[assigned]
			scal se_hat = _se[assigned]
			qui testparm assigned
			sca pstat = r(p)
			sca N = e(N)
		
		matrix E=nullmat(E)\(d_mu, c_mu,  b_hat, se_hat, pstat, N)
		
		* Row Names
			local lbl : variable label `x'
			local rnames `" `rnames' "`lbl'" "'	
			*"
	}	
	
	mat rownames E = $attribution
	frmttable using "T5 table.rtf", statmat(E) replace ctitle("Variable", "Control Mean", "Treatment Mean", "Beta", "SE", "P", "N") sdec(3) varlabels
		
	*local cnames `" "Control Mean" "Treatment Mean"   "Regression difference" "Standard Error" "P-Value"  "'
	*xml_tab E, save("$table.xml") replace noisily cnames(`cnames') rnames(`rnames') font("Times New Roman" 10) 

/***************************************************************************
*** T6. HETERO BY ATTRIBUTION ********************************************
****************************************************************************/
 
	cap gen a_attribution_govt_e  = assigned * attribution_govt_e 
	
	gl table "T6_hetero_by_attribution.xlsx"
		cap erase $table.xls
		cap erase $table.txt
	
	foreach y in nrm_prez_std_e opposition_std_e {
	
	qui svy: reg `y' female $ctrl_indiv $H $K $E $G $districts assigned attribution_govt_e if e2==1
		outreg2 using $table, excel aster(se) bdec(3) br label ctitle (`lab') drop(female $ctrl_indiv $H $K $E $G $districts)
	
	qui svy: reg `y' female $ctrl_indiv $H $K $E $G $districts assigned attribution_govt_e a_attribution_govt_e if e2==1
		outreg2 using $table, excel aster(se) bdec(3) br label ctitle (`lab') drop(female $ctrl_indiv $H $K $E $G $districts)
	
	}
	
	

/***************************************************************************
*** T7. INCOME *************************************************************
***************************************************************************/

	gl table "T7_opposition_support_and_income"
			cap erase $table.xlsx
			cap erase $table.txt
	
		qui svy: reg  opposition_std_e female $ctrl_indiv $H $K $E $G $districts econ_std_e if e2==1 & assigned==0
			outreg2 using $table.xlsx, excel aster(se) bdec(3) br label ctitle ("OLS - Control Group") append drop(female $ctrl_indiv $H $K $E $G $districts)
		
		qui svy: reg  opposition_std_e female $ctrl_indiv $H $K $E $G $districts econ_std_e if e2==1 
			outreg2 using $table.xlsx, excel aster(se) bdec(3) br label ctitle ("OLS") append drop(female $ctrl_indiv $H $K $E $G $districts)

		qui svy: reg  opposition_std_e female $ctrl_indiv $H $K $E $G $districts assigned  if e2==1 
			outreg2 using $table.xlsx, excel aster(se) bdec(3) br label ctitle ("ATE") append drop(female $ctrl_indiv $H $K $E $G $districts)
	
		qui svy: reg  opposition_std_e female $ctrl_indiv $H $K $E $G $districts assigned econ_std_e   if e2==1 
			outreg2 using $table.xlsx, excel aster(se) bdec(3) br label ctitle ("ATE + I") append drop(female $ctrl_indiv $H $K $E $G $districts)
	
		qui svy: reg  opposition_std_e female $ctrl_indiv $H $K $E $G $districts assigned econ_std_e e_influenced_std_e existpatron_std_e social_int_n community_n contrpubgood_e2_n aggression_e2_n protest_e2_n migrate groupcoop_e if e2==1 
			outreg2 using $table.xlsx, excel aster(se) bdec(3) br label ctitle ("ATE + I + O") append drop(female $ctrl_indiv $H $K $E $G $districts)
		
		
		qui svy: reg  opposition_std_e female $ctrl_indiv $H $K $E $G $districts assigned  if e2==1 
		est store c4	
		qui svy: reg  opposition_std_e female $ctrl_indiv $H $K $E $G $districts assigned econ_std_e   if e2==1 
		est store c5
		qui svy: reg  opposition_std_e female $ctrl_indiv $H $K $E $G $districts assigned econ_std_e e_influenced_std_e existpatron_std_e social_int_n community_n contrpubgood_e2_n aggression_e2_n protest_e2_n migrate groupcoop_e  if e2==1 
		est store c6
		
		qui suest c4 c5 c6
		
		test [c4]assigned =[c5]assigned
		* Get p-value for assigned, C4 - C5
		test [c5]assigned =[c6]assigned
		* Get p-value for assigned, C5 - C4
		test [c5]econ_std_e =[c6]econ_std_e
		* Get p-value for econ_index, C5 - C4
	
	


/***************************************************************************
** APPENDIX ****************************************************************
***************************************************************************/
	
	
// Figure A1 and Table T1 (NUSAF funding): see Analysis/dofiles/Patronage/programs/patronage.do	
// Table A2 (Survey responses rate): See Blattman's QJE article	
	
// Table A3: Survey experiment

local i = 0
foreach var in govt_e wb {
	local ++i
	qui svy: reg  attribution_`var' female $ctrl_indiv $H $K $E $G $districts  assigned_wb assigned_govt  if e2==1
		local v_`i' attribution_`var'
		foreach g in govt wb {
			local b_`g'_`i' =  _b[assigned_`g']
			local se_`g'_`i' = _se[assigned_`g']
			test assigned_`g'
			local p_`g'_`i' = r(p)
			
			/* Format standard errors */
			foreach x in `g'_`i' {
					local se_`x' = round(`se_`x'',.001)
					/* Occasionally the round function gives output 
					like 1.2340000000000001. Here, we truncate those outputs */
						local dec = ""
						local dec = substr("`se_`x''",strpos("`se_`x''","."),.)
						if (strlen("`dec'")>4 ) local se_`x' = substr("`se_`x''",1,strpos("`se_`x''",".")+3)
						if (strlen("`dec'")==3) local se_`x' = "`se_`x''0"
						if (strlen("`dec'")==2) local se_`x' = "`se_`x''00"
						if (strlen("`dec'")<2 ) local se_`x' = "`se_`x''000"
					/* Put some brackets and asterisks on the standard errors */
						local se_`x' = "[`se_`x'']"
						if (`p_`x''<=.1 ) local se_`x' = "`se_`x''*"
						if (`p_`x''<=.05) local se_`x' = "`se_`x''*"
						if (`p_`x''<=.01) local se_`x' = "`se_`x''*"
			}
		}
 }
 
 local I `i'
 preserve
	clear	
	set obs `=`I'*2'
	foreach var in v {
		qui gen `var' =""
		forv i = 1/`I' {
			qui replace `var' = "`v_`i''" in `=2*`i'-1'
		}
	}
	foreach var in govt wb  {
		qui gen `var'= ""
		forv i = 1/`I' {
			qui replace `var' = "`b_`var'_`i''" in `=2*`i'-1'
			qui replace `var' = "`se_`var'_`i''" in `=2*`i''
		}
	}

	export excel using "A3 - Survey experiment.xlsx", sheet("raw - govt") sheetreplace firstrow(var)

	restore 
/* End of table(s) */

local i = 0
foreach var in random notrandom {
	local ++i
	qui svy: reg  selection_`var'_e female $ctrl_indiv $H $K $E $G $districts  assigned_random assigned_notrandom  if e2==1
		local v_`i' selection_`var'_e
		foreach g in random notrandom {
			local b_`g'_`i' =  _b[assigned_`g']
			local se_`g'_`i' = _se[assigned_`g']
			test assigned_`g'
			local p_`g'_`i' = r(p)
			
			/* Format standard errors */
			foreach x in `g'_`i' {
					local se_`x' = round(`se_`x'',.001)
					/* Occasionally the round function gives output 
					like 1.2340000000000001. Here, we truncate those outputs */
						local dec = ""
						local dec = substr("`se_`x''",strpos("`se_`x''","."),.)
						if (strlen("`dec'")>4 ) local se_`x' = substr("`se_`x''",1,strpos("`se_`x''",".")+3)
						if (strlen("`dec'")==3) local se_`x' = "`se_`x''0"
						if (strlen("`dec'")==2) local se_`x' = "`se_`x''00"
						if (strlen("`dec'")<2 ) local se_`x' = "`se_`x''000"
					/* Put some brackets and asterisks on the standard errors */
						local se_`x' = "[`se_`x'']"
						if (`p_`x''<=.1 ) local se_`x' = "`se_`x''*"
						if (`p_`x''<=.05) local se_`x' = "`se_`x''*"
						if (`p_`x''<=.01) local se_`x' = "`se_`x''*"
			}
		}
 }
 
 
 local I `i'
 preserve
	clear	
	set obs `=`I'*2'
	foreach var in v {
		qui gen `var' =""
		forv i = 1/`I' {
			qui replace `var' = "`v_`i''" in `=2*`i'-1'
		}
	}
	foreach var in random notrandom {
		qui gen `var'= ""
		forv i = 1/`I' {
			qui replace `var' = "`b_`var'_`i''" in `=2*`i'-1'
			qui replace `var' = "`se_`var'_`i''" in `=2*`i''
		}
	}

	export excel using "A3 - Survey experiment.xlsx", sheet("raw - random") sheetreplace firstrow(var)
restore
	

// Table B1 (Baseline balance): See Blattman QJE	
// Table B2 (Correlates of attrition): See Blattman QJE
// Table B3 (Sensitivity of balance): See Blattman QJE

// Table B5 (Robustness to alternate specifications)

	local i = 0 	
	foreach dv in  nrm_prez_std_e opposition_std_e pol_std_e {
		local ++i
		local lab: var lab `dv'
		local var`i' = "`lab'"
						
					/* Main specification */
					cap {
						qui svy: reg `dv' assigned female $districts $ctrl_indiv $H $K $E $G if e2==1
						/* Recover Coefficients, standard errors, and p-values */
							local b_1_`i' = _b[assigned]
							local se_1_`i' = _se[assigned]
							local n_1_`i' = e(N)
							qui testparm assigned
								local p_1_`i' = r(p)
					}
					/* Districts */
					cap {
						qui svy: reg `dv' assigned $districts if e2==1
						/* Recover Coefficients, standard errors, and p-values */
							local b_2_`i' = _b[assigned]
							local se_2_`i' = _se[assigned]
							local n_2_`i' = e(N)
							qui testparm assigned
								local p_2_`i' = r(p)
					}
					
					/* Plus demographic controls */
					cap {
						qui svy: reg `dv' assigned $districts $ctrl_indiv female if e2==1
						/* Recover Coefficients, standard errors, and p-values */
							local b_3_`i' = _b[assigned]
							local se_3_`i' = _se[assigned]
							local n_3_`i' = e(N)
							qui testparm assigned
								local p_3_`i' = r(p)
					}
					/* Plus human/physical capital controls */
					cap {
						qui svy: reg `dv' assigned $districts $ctrl_indiv female $H $K if e2==1
						/* Recover Coefficients, standard errors, and p-values */
							local b_4_`i' = _b[assigned]
							local se_4_`i' = _se[assigned]
							local n_4_`i' = e(N)
							qui testparm assigned
								local p_4_`i' = r(p)
					}
					
					

				/* Format standard errors */
				forv z = 1/4 {
							local se = round(`se_`z'_`i'',.001)
							/* Fix rounding (Sometimes it rounds 1.234123 to 1.234000000001) */
							local dec = ""
							local dec = substr("`se'",strpos("`se'","."),.)
							if (strlen("`dec'")>4) local se = substr("`se'",1,strpos("`se'",".")+3)
							if (strlen("`dec'")==3) local se = "`se'0"
							if (strlen("`dec'")==2) local se = "`se'00"
							if (strlen("`dec'")<2) local se = "`se'000"
							/* Add asterisks and brackets */
							local se_`z'_`i' = "[`se']"
							cap if (`p_`z'_`i''<=.10) local se_`z'_`i' = "`se_`z'_`i''*"
							cap if (`p_`z'_`i''<=.05) local se_`z'_`i' = "`se_`z'_`i''*"
							cap if (`p_`z'_`i''<=.01) local se_`z'_`i' = "`se_`z'_`i''*"
				}
			}
			
	local I = `i'
	preserve
		clear
		qui set obs `=`I'*3'
		forv i = 1/`I' {
			cap gen var = ""
			qui replace var = "`var`i''" in `=`i'*3-2'
			forv z = 1/5 {
					cap gen treat`z' = ""
						qui replace treat`z' = "`b_`z'_`i''" in `=`i'*3-2'
						qui replace treat`z' = "`se_`z'_`i''" in `=`i'*3-1'
						qui replace treat`z' = "`n_`z'_`i''" in `=`i'*3'
			}
		}
		
		export excel using "B5 - Robustness.xlsx", sheet(raw) sheetreplace firstrow(var)
		restore 

********************************************************************************
stop line 685 this part takes a long time
********************************************************************************



/* This part takes about an hour to run*/
* Randomization inference *
merge m:1 groupid using  "$NUSAF/data/yop_ri.dta", nogen

	local rep 1000
	local i = 0
	local j = 0 /* seed for bootstrapping, to be incremented */
	/* Set restrictions for short and long term surveys */
	foreach y in  nrm_prez_std opposition_std pol_std { 
		local ++i
		local lab: var lab `y'_e
		local var`i' = "`lab'"
		/* Loop over short term and long term */
					local ++j
					
				 				
				/* Randomization Inference */
					qui svy: reg `y'_e female $ctrl_indiv $H $K $E $G $districts assigned if e2==1
					/* Recover Coefficients */
					foreach x in assigned {
						local `x'1_b`i' = _b[`x']
					}
					
					/* For RI SE, create version of outcome variables w/out ATEs */
					qui gen `y'_sim = `y'_e
					foreach x in assigned {
						replace `y'_sim = `y'_sim - ``x'1_b`i'' if `x'
					}
					
					forv k = 1/`rep' {
						set seed `=`j'*10000*`k''
						qui gen assigned_sim`k' = 0 
						replace assigned_sim`k'=1 if t`k'==1
						
						* for point estimates *
						qui svy: reg `y'_e female $ctrl_indiv $H $K $E $G $districts assigned_sim`k' if e2==1
						foreach x in assigned {
							local b_`x'_`k' = _b[`x'_sim`k']
						}
						* for standard errors
						qui gen `y'_`k' = `y'_sim
						foreach x in assigned {
							* create new outcome variables assuming constant treatment effects
							qui replace `y'_`k' = `y'_`k' + ``x'1_b`i'' if `x'_sim`k'==1
						}
						qui svy: reg `y'_`k' female $ctrl_indiv $H $K $E $G $districts assigned_sim`k' if e2==1
						foreach x in assigned {
							local bse_`x'_`k' = _b[`x'_sim`k']
						}
						drop assigned_sim`k'  `y'_`k'
					}
					preserve
						clear
						set obs `rep'
						foreach x in assigned {
							qui gen `x' = .
							qui gen `x'_se = . 
							gen `x'_t = .
							qui gen fail = 0
							forv k = 1/`rep' { 
								qui replace `x' =  `b_`x'_`k'' in `k' 
								qui replace fail = 1 in `k' if abs(``x'1_b`i'') <= abs(`b_`x'_`k'') 
								qui replace `x'_se = `bse_`x'_`k'' in `k'
								}
							qui sum `x'_se
								local `x'1_se`i' = r(sd)
							egen pval = mean(fail)
							local `x'1_p`i' = round(pval,.001)
							drop fail pval
							}
						restore
				

	
			
				/* Format standard errors */
				foreach z in 1 {
					foreach x in assigned`z' {
							local se = round(``x'_se`i'',.001)
							/* Fix rounding (Sometimes it rounds 1.234123 to 1.234000000001) */
							local dec = ""
							local dec = substr("`se'",strpos("`se'","."),.)
							if (strlen("`dec'")>4) local se = substr("`se'",1,strpos("`se'",".")+3)
							if (strlen("`dec'")==3) local se = "`se'0"
							if (strlen("`dec'")==2) local se = "`se'00"
							if (strlen("`dec'")<2) local se = "`se'000"
							/* Add asterisks and brackets */
							local `x'`z'_se`i' = "[`se']"
							cap if (``x'_p`i''<=.10) local `x'_se`i' = "``x'_se`i''*"
							cap if (``x'_p`i''<=.05) local `x'_se`i' = "``x'_se`i''*"
							cap if (``x'_p`i''<=.01) local `x'_se`i' = "``x'_se`i''*"
					}
				}
			
			}
		
	
	local I = `i'
	preserve
		clear
		qui set obs `=`I'*3'
		forv i = 1/`I' {
			cap gen var = ""
			qui replace var = "`var`i''" in `=`i'*3-2'
			foreach z in 1 {
				foreach x in assigned {
					cap gen `x'`z' = ""
						qui replace `x'`z' = "``x'`z'_b`i''" in `=`i'*3-2'
						qui replace `x'`z' = "``x'`z'_se`i''" in `=`i'*3-1'
						qui replace `x'`z' = "``x'`z'_p`i''" in `=`i'*3'
						}
			}
		}
		export excel using "B5 - Robustness.xlsx", sheet(ri) sheetreplace firstrow(var)
		
			restore



// Table B6 : Alternate attrition scenarios
cap drop sample_final_m
gen sample_final_m = 1 if ind_tracked_p2_e2==1 & ind_unfound_p2_e2==1
la var sample_final_m "In final NUSAF political sample but missing"

foreach v in  nrm_prez_std opposition_std pol_std {
	foreach scenario in 9010 7525 5050 9505 9703 manski {
		foreach dir in u d {
			gen `v'_`scenario'_`dir'_e = `v'_e
			local lab: var lab `v'_e
			label var `v'_`scenario'_`dir'_e "`lab', `scenario' bound"	
		}
	}
}


** Lower bound, Increasing variables
foreach v in pol_std nrm_prez_std opposition_std {	
					
					* Treatment minimum
					qui sum `v'_e if assigned==1 & e2==1, d
					if r(N) {
						local min_t = r(min)
						local sd_t = r(sd)
					}
					* Control maximum
					qui sum `v'_e if assigned==0 & e2==1, d
					if r(N) { 
						local max_c = r(max)
						local sd_c = r(sd)
					}
					* Sample mean
					qui sum `v'_e if e2==1
					if r(N) {
						local mean = r(mean)
					}
						
						qui replace `v'_9703_d_e = `mean' + .025*`sd_c' if assigned==0 & sample_final_m==1
						qui replace `v'_9703_d_e = `mean' - .025*`sd_t' if assigned==1 & sample_final_m==1
						
						qui replace `v'_9505_d_e = `mean' + .05*`sd_c' if assigned==0 & sample_final_m==1
						qui replace `v'_9505_d_e = `mean' - .05*`sd_t' if assigned==1 & sample_final_m==1
						
						qui replace `v'_9010_d_e = `mean' + .1*`sd_c' if assigned==0 &  sample_final_m==1
						qui replace `v'_9010_d_e = `mean' - .1*`sd_t' if assigned==1 &  sample_final_m==1
						
						qui replace `v'_7525_d_e = `mean' + .25*`sd_c' if assigned==0 & sample_final_m==1
						qui replace `v'_7525_d_e = `mean' - .25*`sd_t' if assigned==1 & sample_final_m==1
						
						qui replace `v'_5050_d_e = `mean' + .5*`sd_c' if assigned==0 &  sample_final_m==1
						qui replace `v'_5050_d_e = `mean' - .5*`sd_t' if assigned==1 &  sample_final_m==1
						
						qui replace `v'_manski_d_e = `max_c' if assigned==0 & sample_final_m==1
						qui replace `v'_manski_d_e = `min_t' if assigned==1 & sample_final_m==1
					}
	
** Upper bound, decreasing	variables		
foreach v in nrm_prez_std {	
					
					* Treatment minimum
					qui sum `v'_e if assigned==1 & e2==1, d
					if r(N) {
						local min_t = r(min)
						local sd_t = r(sd)
					}
					* Control maxmimum
					qui sum `v'_e if assigned==0 & e2==1, d
					if r(N) { 
						local max_c = r(max)
						local sd_c = r(sd)
					}
					* Sample mean
					qui sum `v'_e if e2==1
					if r(N) {
						local mean = r(mean)
					}
										
						qui replace `v'_9703_u_e = `mean' - .025*`sd_c' if assigned==0 & sample_final_m==1
						qui replace `v'_9703_u_e = `mean' + .025*`sd_t' if assigned==1 & sample_final_m==1
						
						qui replace `v'_9505_u_e = `mean' - .05*`sd_c' if assigned==0 & sample_final_m==1
						qui replace `v'_9505_u_e = `mean' + .05*`sd_t' if assigned==1 & sample_final_m==1
						
						qui replace `v'_9010_u_e = `mean' - .1*`sd_c' if assigned==0 &  sample_final_m==1
						qui replace `v'_9010_u_e = `mean' + .1*`sd_t' if assigned==1 &  sample_final_m==1

						qui replace `v'_7525_u_e = `mean' - .25*`sd_c' if assigned==0 & sample_final_m==1
						qui replace `v'_7525_u_e = `mean' + .25*`sd_t' if assigned==1 & sample_final_m==1
						
						qui replace `v'_5050_u_e = `mean' - .5*`sd_c' if assigned==0 &  sample_final_m==1
						qui replace `v'_5050_u_e = `mean' + .5*`sd_t' if assigned==1 &  sample_final_m==1
						
						qui replace `v'_manski_u_e = `min_t' if assigned==0 & sample_final_m==1
						qui replace `v'_manski_u_e = `max_c' if assigned==1 & sample_final_m==1
					}
			
				
				
** Upper bound, increasing variables
foreach v in pol_std nrm_prez_std opposition_std {	
					
					* Treatment minimum
					qui sum `v'_e if assigned==1 & e2==1, d
					if r(N) {
						local min_t = r(min)
						local sd_t = r(sd)
					}
					* Control maximum
					qui sum `v'_e if assigned==0 & e2==1, d
					if r(N) { 
						local max_c = r(max)
						local sd_c = r(sd)
					}
					* Sample mean
					qui sum `v'_e if e2==1
					if r(N) {
						local mean = r(mean)
					}
						
						qui replace `v'_9703_u_e = `mean' - .025*`sd_c' if assigned==0 & sample_final_m==1
						qui replace `v'_9703_u_e = `mean' + .025*`sd_t' if assigned==1 & sample_final_m==1
						
						qui replace `v'_9505_u_e = `mean' - .05*`sd_c' if assigned==0 & sample_final_m==1
						qui replace `v'_9505_u_e = `mean' + .05*`sd_t' if assigned==1 & sample_final_m==1
						
						qui replace `v'_9010_u_e = `mean' - .1*`sd_c' if assigned==0 &  sample_final_m==1
						qui replace `v'_9010_u_e = `mean' + .1*`sd_t' if assigned==1 &  sample_final_m==1
						
						qui replace `v'_7525_u_e = `mean' - .25*`sd_c' if assigned==0 & sample_final_m==1
						qui replace `v'_7525_u_e = `mean' + .25*`sd_t' if assigned==1 & sample_final_m==1
						
						qui replace `v'_5050_u_e = `mean' - .50*`sd_c' if assigned==0 & sample_final_m==1
						qui replace `v'_5050_u_e = `mean' + .50*`sd_t' if assigned==1 & sample_final_m==1
						
						qui replace `v'_manski_u_e = `min_t' if assigned==0 & sample_final_m==1
						qui replace `v'_manski_u_e = `max_c' if assigned==1 & sample_final_m==1
					}
** Lower bound, decreasing	variable	
foreach v in nrm_prez_std {	
					
					* Treatment minimum
					qui sum `v'_e if assigned==1 & e2==1, d
					if r(N) {
						local min_t = r(min)
						local sd_t = r(sd)
					}
					* Control maxmimum
					qui sum `v'_e if assigned==0 & e2==1, d
					if r(N) { 
						local max_c = r(max)
						local sd_c = r(sd)
					}
					* Sample mean
					qui sum `v'_e if e2==1
					if r(N) {
						local mean = r(mean)
					}
					
						qui replace `v'_9703_d_e = `mean' + .025*`sd_c' if assigned==0 & sample_final_m==1
						qui replace `v'_9703_d_e = `mean' - .025*`sd_t' if assigned==1 & sample_final_m==1
											
						qui replace `v'_9505_d_e = `mean' + .05*`sd_c' if assigned==0 & sample_final_m==1
						qui replace `v'_9505_d_e = `mean' - .05*`sd_t' if assigned==1 & sample_final_m==1
						
						qui replace `v'_9010_d_e = `mean' + .1*`sd_c' if assigned==0 & sample_final_m==1
						qui replace `v'_9010_d_e = `mean' - .1*`sd_t' if assigned==1 & sample_final_m==1

						qui replace `v'_7525_d_e = `mean' + .25*`sd_c' if assigned==0 & sample_final_m==1
						qui replace `v'_7525_d_e = `mean' - .25*`sd_t' if assigned==1 & sample_final_m==1
						
						qui replace `v'_5050_d_e = `mean' + .50*`sd_c' if assigned==0 & sample_final_m==1
						qui replace `v'_5050_d_e = `mean' - .50*`sd_t' if assigned==1 & sample_final_m==1
						
						qui replace `v'_manski_d_e = `max_c' if assigned==0 & sample_final_m==1
						qui replace `v'_manski_d_e = `min_t' if assigned==1 & sample_final_m==1
					}

	

				
	local i = 0 	
	foreach y in nrm_prez_std opposition_std pol_std {
		local ++i
		local var`i' = "`y'"
									
					/* Attrition Manski */
					cap {
						qui svy: reg `y'_manski_d_e female $ctrl_indiv $H $K $E $G $districts assigned if e2==1
						/* Recover Coefficients, standard errors, and p-values */
							local b_1_`i' = _b[assigned]
							local se_1_`i' = _se[assigned]
							local n_1_`i' = e(N)
							qui testparm assigned
								local p_1_`i' = r(p)
					}
					/* Attrition .75/.25 */
					cap {
						qui svy: reg `y'_7525_d_e female $ctrl_indiv $H $K $E $G $districts assigned if e2==1
						/* Recover Coefficients, standard errors, and p-values */
							local b_2_`i' = _b[assigned]
							local se_2_`i' = _se[assigned]
							local n_2_`i' = e(N)
							qui testparm assigned
								local p_2_`i' = r(p)
					}
					
					/* Attrition .9/.1 */
					cap {
						qui svy: reg `y'_9010_d_e female $ctrl_indiv $H $K $E $G $districts assigned if e2==1
						/* Recover Coefficients, standard errors, and p-values */
							local b_3_`i' = _b[assigned]
							local se_3_`i' = _se[assigned]
							local n_3_`i' = e(N)
							qui testparm assigned
								local p_3_`i' = r(p)
					}
					/* Attrition .95/.05 */
					cap {
						qui svy: reg `y'_9505_d_e female $ctrl_indiv $H $K $E $G $districts assigned if e2==1
						/* Recover Coefficients, standard errors, and p-values */
							local b_4_`i' = _b[assigned]
							local se_4_`i' = _se[assigned]
							local n_4_`i' = e(N)
							qui testparm assigned
								local p_4_`i' = r(p)
					}
					
					/* Attrition .975/.025 */
					cap {
						qui svy: reg `y'_9703_d_e female $ctrl_indiv $H $K $E $G $districts assigned if e2==1
						/* Recover Coefficients, standard errors, and p-values */
							local b_5_`i' = _b[assigned]
							local se_5_`i' = _se[assigned]
							local n_5_`i' = e(N)
							qui testparm assigned
								local p_5_`i' = r(p)
					}

					/* Main Specification */
					cap {
						qui svy: reg `y'_e female $ctrl_indiv $H $K $E $G $districts assigned if e2==1
						/* Recover Coefficients, standard errors, and p-values */
							local b_6_`i' = _b[assigned]
							local se_6_`i' = _se[assigned]
							local n_6_`i' = e(N)
							qui testparm assigned
								local p_6_`i' = r(p)
					}
					/* Attrition .975/.025 */
					cap {
						qui svy: reg `y'_9703_u_e female $ctrl_indiv $H $K $E $G $districts assigned if e2==1
						/* Recover Coefficients, standard errors, and p-values */
							local b_7_`i' = _b[assigned]
							local se_7_`i' = _se[assigned]
							local n_7_`i' = e(N)
							qui testparm assigned
								local p_7_`i' = r(p)
					}
					
					/* Attrition .95/.05 */
					cap {
						qui svy: reg `y'_9505_u_e female $ctrl_indiv $H $K $E $G $districts assigned if e2==1
						/* Recover Coefficients, standard errors, and p-values */
							local b_8_`i' = _b[assigned]
							local se_8_`i' = _se[assigned]
							local n_8_`i' = e(N)
							qui testparm assigned
								local p_8_`i' = r(p)
					}

					/* Attrition .9/.1 */
					cap {
						qui svy: reg `y'_9010_u_e female $ctrl_indiv $H $K $E $G $districts assigned if e2==1
						/* Recover Coefficients, standard errors, and p-values */
							local b_9_`i' = _b[assigned]
							local se_9_`i' = _se[assigned]
							local n_9_`i' = e(N)
							qui testparm assigned
								local p_9_`i' = r(p)
					}
					/* Attrition .75/.25 */
					cap {
						qui svy: reg `y'_7525_u_e female $ctrl_indiv $H $K $E $G $districts assigned if e2==1
						/* Recover Coefficients, standard errors, and p-values */
							local b_10_`i' = _b[assigned]
							local se_10_`i' = _se[assigned]
							local n_10_`i' = e(N)
							qui testparm assigned
								local p_10_`i' = r(p)
					}
					
					/* Attrition Manski */
					cap {
						qui svy: reg `y'_manski_u_e female $ctrl_indiv $H $K $E $G $districts assigned if e2==1
						/* Recover Coefficients, standard errors, and p-values */
							local b_11_`i' = _b[assigned]
							local se_11_`i' = _se[assigned]
							local n_11_`i' = e(N)
							qui testparm assigned
								local p_11_`i' = r(p)
					}


				/* Format standard errors */
				forv z = 1/11 {
							local se = round(`se_`z'_`i'',.001)
							/* Fix rounding (Sometimes it rounds 1.234123 to 1.234000000001) */
							local dec = ""
							local dec = substr("`se'",strpos("`se'","."),.)
							if (strlen("`dec'")>4) local se = substr("`se'",1,strpos("`se'",".")+3)
							if (strlen("`dec'")==3) local se = "`se'0"
							if (strlen("`dec'")==2) local se = "`se'00"
							if (strlen("`dec'")<2) local se = "`se'000"
							/* Add asterisks and brackets */
							local se_`z'_`i' = "[`se']"
							cap if (`p_`z'_`i''<=.10) local se_`z'_`i' = "`se_`z'_`i''*"
							cap if (`p_`z'_`i''<=.05) local se_`z'_`i' = "`se_`z'_`i''*"
							cap if (`p_`z'_`i''<=.01) local se_`z'_`i' = "`se_`z'_`i''*"
				}
			}
			
	local I = `i'
	preserve
		clear
		qui set obs `=`I'*3'
		forv i = 1/`I' {
			cap gen var = ""
			qui replace var = "`var`i''" in `=`i'*3-2'
			forv z = 1/11 {
					cap gen treat`z' = ""
						qui replace treat`z' = "`b_`z'_`i''" in `=`i'*3-2'
						qui replace treat`z' = "`se_`z'_`i''" in `=`i'*3-1'
						qui replace treat`z' = "`n_`z'_`i''" in `=`i'*3'
			}
		}
		
		export excel using "B6 - Attrition bounds.xlsx", sheet(raw) sheetreplace firstrow(var)
		restore
/* End of table(s) */


// Table B7 (Attrition weight LOO)

	cap { //so it is only created once. this part also takes about an hour to run.
		gen foundpct_loo = .
		levelsof partid if e2==1, local(participants)
		
		foreach i in `participants' {
		
			qui  probit ind_found_e2  assigned female $ctrl_indiv $H $K $E $G $districts if e2==1 & partid != `i'
			
			predict foundpct_`i', pr
			replace foundpct_loo = foundpct_`i' if partid==`i' & e2==1
			drop foundpct_`i'
		}
		
		
		gen w_sampling_a_e = 1/foundpct_loo
		
		gen w_sampling_sa_e = w_sampling_a_e * w_sampling_e
		la var w_sampling_sa_e "Sampling weight for both attrition and tracking"
	}
	
	
// Table B7: Robustness to Attrition Weights 

	gl table "B7_robustness_to_attrition_weights"
		cap erase $table.xlsx
		cap erase $table.txt
	set more off
	
	
	
	foreach y in  nrm_prez_std opposition_std pol_std { 
		* No attrition weight
		svyset [pw=w_sampling_e], strata(district) psu(group_endline)
			svy: reg `y'_e female $ctrl_indiv $H $K $E $G $districts assigned if e2==1		
			outreg2 using $table.xlsx, excel aster(se) bdec(3) br label ctitle (`lab') drop(female $ctrl_indiv $H $K $E $G $districts)
	
		* Attrition weight included
		qui svyset [pw=w_sampling_sa_e], strata(district) psu(group_endline)
			svy: reg `y'_e female $ctrl_indiv $H $K $E $G $districts assigned if e2==1		
			outreg2 using $table.xlsx, excel aster(se) bdec(3) br label ctitle (`lab') drop(female $ctrl_indiv $H $K $E $G $districts)
			
		}
	
	
// Table B8: Hetero  by age

	
	gl table "B8_hetero_by_age"
			cap erase $table.xlsx
			cap erase $table.txt

	cap gen ageunder20 = (age<=20) & !missing(age)
	la var ageunder20 "Age 20 or under "
	cap gen aXageunder20 = assigned*ageunder20
	la var aXageunder20 "Assigned x age 20 or under"
	
	qui svy: reg opposition_std_e female $ctrl_indiv_noage $H $K $E $G $districts assigned if age<=20
			outreg2 using $table.xlsx, excel aster(se) bdec(3) br label ctitle ("Effect under 20") append drop(female $ctrl_indiv_noage $H $K $E $G $districts)
	
	qui svy: reg opposition_std_e female $ctrl_indiv_noage $H $K $E $G $districts assigned if age>20
			outreg2 using $table.xlsx, excel aster(se) bdec(3) br label ctitle ("Effect over 20 in 2008") append drop(female $ctrl_indiv_noage $H $K $E $G $districts)
	
	qui svy: reg opposition_std_e female $ctrl_indiv_noage $H $K $E $G $districts assigned ageunder20 aXageunder20 
			outreg2 using $table.xlsx, excel aster(se) bdec(3) br label ctitle ("Age 20 or under indicator") append drop(female $ctrl_indiv_noage $H $K $E $G $districts)
	
	
	
// Table B9: Heterogeneity by fair and random

** HETEROGENEITY BY FAIR SELECTION
	
	gl table "B9_hetero_by_fair_selection"
			cap erase $table.xml
			cap erase $table.txt

	foreach v in selfair random notrandom  {
		cap gen a_`v'_e = assigned*`v'_e
	}
	
	foreach dv in opposition_std_e {
	
		svy: reg `dv' female $ctrl_indiv $H $K $E $G $districts assigned if e2==1 & selfair_e==1
			outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle (`lab') append drop(female $ctrl_indiv $H $K $E $G $districts)
		
		svy: reg `dv' female $ctrl_indiv $H $K $E $G $districts assigned if e2==1 & selfair_e==0
			outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle (`lab') append drop(female $ctrl_indiv $H $K $E $G $districts)	
		
		qui svy: reg `dv' female $ctrl_indiv $H $K $E $G $districts assigned if e2==1 & selection_random_e==1
			outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle (`lab') append drop(female $ctrl_indiv $H $K $E $G $districts)
		
		qui svy: reg `dv' female $ctrl_indiv $H $K $E $G $districts assigned if e2==1 & selection_notrandom_e==1
			outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle (`lab') append drop(female $ctrl_indiv $H $K $E $G $districts)	
	}
	
	

	
// Table B9 - Mediation analysis


	local y_list econ_std_e e_influenced_std_e existpatron_std_e social_int_n community_n contrpubgood_e2_n aggression_e2_n protest_e2_n migrate groupcoop_e
	local i = 0 
	foreach y in `y_list' {
		local ++i
		
		local var_`i' = "`y'"
		
		qui svy: reg  `y' assigned female $ctrl_indiv $H $K $E $G $districts if e2==1
						local b_1_`i' = _b[assigned]
						local se_1_`i' = _se[assigned]
						local p_1_`i' = 2*ttail(e(df_r),abs(_b[assigned]/_se[assigned]))
		
		qui svy: reg  opposition_std_e  assigned female $ctrl_indiv $H $K $E $G $districts `y' if e2==1
						local b_2_`i' = _b[`y']
						local se_2_`i' = _se[`y']
						local p_2_`i' = 2*ttail(e(df_r),abs(_b[`y']/_se[`y']))
						
		qui svy: reg  opposition_std_e  assigned female $ctrl_indiv $H $K $E $G $districts if e2==1
						local b_3_`i' = _b[assigned]
						local se_3_`i' = _se[assigned]
						local p_3_`i' = 2*ttail(e(df_r),abs(_b[assigned]/_se[assigned]))
		
		* Percent mediated
		local pct_`i' = `b_1_`i'' * `b_2_`i'' / `b_3_`i''
		
		/* Format standard errors */
				foreach x in 1_`i' 2_`i' 3_`i'  {
						local se_`x' = round(`se_`x'',.001)
						/* Occasionally the round function gives output 
						like 1.2340000000000001. Here, we truncate those outputs */
							local dec = ""
							local dec = substr("`se_`x''",strpos("`se_`x''","."),.)
							if (strlen("`dec'")>4 ) local se_`x' = substr("`se_`x''",1,strpos("`se_`x''",".")+3)
							if (strlen("`dec'")==3) local se_`x' = "`se_`x''0"
							if (strlen("`dec'")==2) local se_`x' = "`se_`x''00"
							if (strlen("`dec'")<2 ) local se_`x' = "`se_`x''000"
						/* Put some brackets and asterisks on the standard errors */
							local se_`x' = "[`se_`x'']"
							if (`p_`x''<=.1 ) local se_`x' = "`se_`x''*"
							if (`p_`x''<=.05) local se_`x' = "`se_`x''*"
							if (`p_`x''<=.01) local se_`x' = "`se_`x''*"
				}
		}
		
		preserve
			
			clear
			local I `i'
			set obs `I'
			
				qui gen var = ""
				forv i = 1/`I' {
					qui replace var = "`var_`i''" in `i'
				}
				
				foreach n in 1 2 3 {
					foreach v in b se {
					qui gen `v'_`n' = ""
						forv i = 1/`I' {
							qui replace `v'_`n' = "``v'_`n'_`i''" in `i'
						}
					}
				}
				qui gen pct_med = ""
				forv i = 1/`I' {
					qui replace pct_med = "`pct_`i''" in `i'
				}
				destring b_* pct_med, replace
				replace pct_med=abs(round(pct_med,.01))
				
				export excel using "B10 - Mediation.xlsx", sheetreplace sheet("raw") firstrow(var)
				
		restore
		

	// THE ANALYSIS BELOW THIS IS FOR THE MOST RECENT REPLIES TO AEJ-APPLIED
	// WILL UPDATE WHEN WE DECIDE IF TO KEEP OF NOT
		

	local i 0
	
	foreach x in $G {
		local ++i
		
		local var_`i' "`x'"
		
		qui sum `x' [iw=w_sampling_e] if e2==1 & assigned==0 
					local mc_`i' = r(mean)
					local sc_`i' = r(sd)
				
		qui sum `x' [iw=w_sampling_e] if e2==1 & assigned==1 
					local mt_`i' = r(mean)
					local st_`i' = r(sd)
	}
	
	
	preserve
	
	local I `i'
	clear
	set obs `I'
	foreach var in var mc sc mt st {
		qui gen `var' =""
		forv i=1/`I' {	
			qui replace `var' = "``var'_`i''" in `i'
		}
	
	}
	
	export excel using "Group attributes.xlsx", sheet("raw - g") sheetreplace firstrow(var)
		restore
		

		
		
	/* ATE by group existing or not */		
	gl table table_groupexisted
			cap erase $table.xml
			cap erase $table.txt

	cap gen aXgroup_existed = assigned*group_existed
	la var aXgroup_existed "Assigned x group_existed"
	
	qui svy: reg opposition_std_e female $ctrl_indiv $H $K $E $G $districts assigned if group_existed==1
			outreg2 using $table.xlm, excel aster(se) bdec(3) br label ctitle ("Effect for group existed") append drop(female $ctrl_indiv $H $K $E  $districts)
	
	qui svy: reg opposition_std_e female $ctrl_indiv $H $K $E $G $districts assigned if group_existed!=1
			outreg2 using $table.xlm, excel aster(se) bdec(3) br label ctitle ("Effect for ! group existed") append drop(female $ctrl_indiv $H $K $E  $districts)
	
	qui svy: reg opposition_std_e female $ctrl_indiv $H $K $E $G $districts assigned group_existed aXgroup_existed 
			outreg2 using $table.xlm, excel aster(se) bdec(3) br label ctitle ("Group existed indicator") append drop(female $ctrl_indiv $H $K $E  $districts)
	
	
	
	/* Political preferences */
	
	foreach x in  opposition_std_e  nrmvote_e partyaffnrm_dum_e nrmclose_alt_e  {
		egen group_`x' = mean(`x') if e2==1,  by(group_endline)
		replace group_`x' = . if `x'==.
	}
	
	local i 0
	
	foreach x in nrmvote_e partyaffnrm_dum_e nrmclose_alt_e opposition_std_e {
		local ++i
		
		local var_`i' "group_`x'"
		
		qui sum group_`x' [iw=w_sampling_e] if e2==1 & assigned==0 
					local mc_`i' = r(mean)
					local sc_`i' = r(sd)
				
		qui sum group_`x' [iw=w_sampling_e] if e2==1 & assigned==1 
					local mt_`i' = r(mean)
					local st_`i' = r(sd)
	}
	
	
	preserve
	
	local I `i'
	clear
	set obs `I'
	foreach var in var mc sc mt st {
		qui gen `var' =""
		forv i=1/`I' {	
			qui replace `var' = "``var'_`i''" in `i'
		}
	
	}
	
	export excel using "Group attributes.xlsx", sheet(raw) sheetreplace firstrow(var)
		restore



********************************************************************************
* Move our working directory back to where the master do-file is located *******
********************************************************************************
/* 	This allows us to continue on with the next steps in the master do file.
*/ 
cd $NUSAF

******************************************************************************** 				
	
