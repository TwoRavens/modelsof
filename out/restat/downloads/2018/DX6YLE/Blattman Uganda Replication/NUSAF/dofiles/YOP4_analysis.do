/***************************************************************************
* Title: Table production for Blattman, Fiala, and Martinez 2013, "Generating Skilled Self-Employment in Developing Countries: Experimental Evidence from Uganda" 
* Date: October 2014
* Replication file
****************************************************************************/

/* 

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
INSTRUCTIONS FOR REPLICATION:
	1. In 1.1, set up the directory to point to the replication folder on your personal computer.
	2. Run the do-file. It will break at "STOP" before Section 3.0. This preliminary section does the final preparations
	   to the dataset for analysis.
	3. Sections 3.0, 4.0, and 5.0 comprise the main tables, the appendix tables, and the supplementary tables. After 
	   the dataset has been prepared by Section 1.0, you may highlight any table and run it individually. The output
	   will go to the "Output" folder in the replication folder on your personal computer.
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  
 
TABLE OF CONTENTS 
 
1.0 SETUP
	1.1 DIRECTORIES 
	1.2 SET GLOBALS
	1.3 OUTREG PROGRAM DEFINITION
	
	
3.0 IMPACTS ANALYSIS (PAPER) 
	3.1 TABLE 1: SURVEY RESPONSE RATES
	3.2 TABLE 2: BASELINE SUMMARY STATISTICS AND TESTS OF BALANCE
	3.3 TABLE 3: SUMMARY STATISTICS, MAJOR OUTCOMES
	3.4 TABLE 4: CAPITAL STOCK
	3.5 TABLE 5: PROGRAM IMPACTS ON HIRED LABOR
	3.6 TABLE 6: INCOME
	3.7 TABLE 7: SENSITIVITY
	3.8 TABLE 8: SOCIAL OUTCOMES 
	3.9 TABLE 9: IMPACT HETEROGENEITY 
	3.10 TABLE 10: MALE FEMALE DIFFERENCES 
	3.11 FIGURE 3: EARNINGS TRENDS

4.0 APPENDIX
	4.1 APPENDIX TABLE 1: CORRELATES OF ATTRITION
	4.2 APPENDIX TABLE 2: SENSITIVITY OF BASELINE RANDOMIZATION BALANCE
	4.3 APPENDIX TABLE 3: POPULATION ATE
	4.4 APPENDIX TABLE 4: CORRELATES OF NON-COMPLIANCE
	4.5 APPENDIX TABLE 5: DESCRIPTIVE STATISTICS AND SIMPLE ITT EFFECTS
	4.5 APPENDIX TABLE 6: TRAINING INCIDENCE AND HOURS
	4.6 APPENDIX TABLE 7: RETURNS BY TRADE
	4.7 APPENDIX TABLE 8: USING GRANT SIZE PER PERSON AS THE TREATMENT INDICATOR
	4.8 APPENDIX TABLE 9: EXTENDED SENSITIVITY
	4.9 APPENDIX TABLE 10: SOCIAL OUTCOMES
	4.10 APPENDIX TABLE 11: AGGRESSION HETEROGENEITY
	4.11 APPENDIX TABLE 12: PATIENCE
	
5.0 SUPPLEMENTARY TABLES
	5.1 TOP 10% OF PAYROLL
	5.2 ADDITIONAL SUMMARY STATISTICS
	5.3 POPULATION HETEROGENEITY
	5.4 CORRELATES OF DROPPED FROM TRACKING
	5.5 GROUP HETEROGENEITY


*/ 

///////////////
// 1.0 SETUP //
////////////////

	// 1.1 DIRECTORIES
					
			clear
			clear matrix 
			clear mata
			set maxvar 8000
			set more off  

		// SET OUTPUT DIRECTORY
			cd "$NUSAF/YOP4_output"	
	
			
		// OPEN DATASET
			use "$NUSAF/data/yop_analysis_deident"
	

		
		// SET SURVEY DESIGN 
			svyset [pw=w_sampling_e], strata(district) psu(group_endline)	
	
	// 1.2 SET ANALYSIS GLOBALS 
		
		// BASELINE CONTROLS
				
			gl districts "D_1-D_13"
			gl ctrl_indiv "age age_2 age_3 urban ind_found_b risk_aversion"
			gl H "education literate voc_training numeracy_numcorrect_m adl"
			gl K "wealthindex savings_6mo_p99 cash4w_p99 loan_100k loan_1mil"
			gl K2 "wealthindex2 lsavings cash4w_ln loan_100k loan_1mil"
			gl E "lowskill7da_zero lowbus7da_zero skilledtrade7da_zero highskill7da_zero acto7da_zero aghours7da_zero chores7da_zero zero_hours nonag_dummy emplvoc inschool"
			gl G "admin_cost_us groupsize_est_e grantsize_pp_US_est3 group_existed group_age ingroup_hetero ingroup_dynamic grp_leader grp_chair avgdisteduc"
		
			
			gl R "mosquitonet_resc wakalonenight_resc q123_resc q126_resc q127_resc q129_resc q131_resc q132_resc"

			gl controls "$ctrl_indiv $H $K $E $G $districts"
	 	
			gl S "family_caring family_disputes social_support_all prosocial groups_in hrs_bizz_advice"
			gl I "jumpy q157 q162 quarrelsome unloved q166 dishonest takethings disobeyparents curse threaten disputes"
			gl W "violence_by violence_against violence_others violence_witnessed"
			gl P_e "pptemptresist_time_e ppmedwait_time_e pptakewarnings_time_e ppstopdoing_time_e pppostponeact_time_e ppspendmoney_time_e ppactquickly_time_e ppregretpast_time_e pptaskfirst_time_e ppchoosemed_time_e pptimepref1_e pptimepref2_e pptimepref3_e pptimepref4_e pptimepref5_e pptimepref6_e ppmakespend_e ppmakekeep_e pppatient_e ppatientcomp_e"
			gl P_m "pptemptresist_time_e_m ppmedwait_time_e_m pptakewarnings_time_e_m ppstopdoing_time_e_m pppostponeact_time_e_m ppspendmoney_time_e_m ppactquickly_time_e_m ppregretpast_time_e_m pptaskfirst_time_e_m ppchoosemed_time_e_m"
			gl P_m2 "pptemptresist_time_e_m ppmedwait_time_e_m pptakewarnings_time_e_m ppstopdoing_time_e_m pppostponeact_time_e_m ppspendmoney_time_e_m ppactquickly_time_e_m ppregretpast_time_e_m pptaskfirst_time_e_m ppchoosemed_time_e_m pptimepref1_e_m pptimepref2_e_m pptimepref3_e_m pptimepref4_e_m pptimepref5_e_m pptimepref6_e_m ppmakespend_e_m ppmakekeep_e_m pppatient_e_m ppatientcomp_e_m"
		 
		// OUTCOMES
		
			gl outcomes_transfer "ngogovtransfer nonyop_transfers_real_p99 anytransferlikely"
			gl outcomes_invest "voc_training training_hours bizasset_val_real_p99"
			gl outcomes_work "totalhrs7da_zero aghours7da_zero nonaghours7da_zero chores7da_zero lowskill7da_zero lowbus7da_zero skilledtrade7da_zero highskill7da_zero acto7da_zero zero_hours nonag_dummy trade_dummy"
			gl outcomes_income "profits4w_real_p99 wealthindex consumption_real_p99_z wealthladder"
			gl outcomes_migrate "migrate urban capital"
			gl outcomes_formalize "bizlog bizregister biztaxes employees employs"
			gl outcomes_other "return_school savings_real_p99 net_hhtransfers_p99 wages adjusted_profits2 fulltimeskill"
			gl table_social "social_int_n community_n contrpubgood_e2_n aggression_n aggression_e2_n protest_e2_n"
			gl table_social_other "groups_capped support_e1_n distress__n grit female_empower wife_abuse_attitude wife_abuse_actual" 

		// SOCIAL GLOBALS
		
			gl personality_e2 "grit conscientious industriousness"
			gl social_int "hhcaring_resc fam_disp_resc live_together helpelders_resc"
			gl support_e1 "lookedafterfam_resc distressed_resc mindoff_resc futureplans_resc helpfuladvice_resc listener_resc taughtsomething_resc jokedwith_resc"
			gl aggression "agg_quarrelsome agg_take agg_curse agg_threaten neigh_disp commlead_disp pol_disp fight_disp"
			gl aggression_e2 "quarrelsome_resc takethings_resc curse_resc threaten_resc wbyelled_resc wbreactedanger_resc wbfrustrateang_resc wbdamagemad_resc wbnowantang_resc wbangrythreat_resc wbhittinggood_resc wbhitdefend_resc wbdamagefun_resc wbforcewant_resc wbforcemoney_resc wbgangothers_resc wbweaponfight_resc wbyelledtodo_resc neigh_disp commlead_disp pol_disp fight_disp"
			gl community_e1 "comm_meet comm_mblzr comm_leader madespeech"
			gl community_e2 "cclcommeet12m_resc comm_mblzr ldmcomlc1 ldmcomother ldmacceptc1 rcaraiseissue12m_dum"
			gl contrpubgood_e2 "cpgroad12m_dum cpgwater12m_dum cpgbldgoth12m_dum cpgschl12m_dum cpglatrine12m_dum cpgoth12m_dum cpgfuneral12m_dum"
			gl protest_e2 "protests attptreasonjustified_resc attptviolencejustified_resc attptpolvioljustified_resc hcaptwish hcaptwouldgo hcaptwouldgoviol"
			gl election_action_e2 "epavoteredu2011el_dum epadiscussvote2011el_dum epareportinc2011el_dum regsuccess2011 vote2011elprez vote2011ellcv"
			gl partisan_e2 "pparally2011el_resc ppaprimary2011el_resc partyworked_resc partymember_resc "
			gl distress_ "jumpy_ unloved_ worried_ restless_ thinkpast_ nightmares_ lifediff_"
		
			
	// 1.3 DEFINE PROGRAMS FOR OUTREG COMMAND
	** The following three programs format the regression tables for easy use, as well as adding additional relevant statistics to the bottom of each table. 
	** The programs are used below to output some of the tables in order to simplify the code.


		// PROGRAM 1: ITT ESTIMATION AND OUTPUT
			* FULL SAMPLE POOLED (MALE AND FEMALE, E1 & E2)
			* ESTIMATES ATE BY GENDER AND ENDLINE
		 
			cap program drop ITT
				program def ITT
			 				
				local lab : var label ${Y}_e	
	
					* Control Mean E1 All 
						sum ${Y}_e [iw=w_sampling_e] if e1==1 & assigned==0
						scalar ${Y}e1c = r(mean)
						scalar ${Y}e1N = r(N)
					
					* Control Mean E1 Female
						sum ${Y}_e [iw=w_sampling_e] if e1==1 & assigned==0 & female==1
						scalar ${Y}e1cf = r(mean)
					
					* Control Mean E1 Male
						sum ${Y}_e [iw=w_sampling_e] if e1==1 & assigned==0 & female==0
						scalar ${Y}e1cm = r(mean)
					
					* E1 ITT, all
						if ${Y}e1N != 0 { 
							svy: reg ${Y}_e female $X assigned if e1==1
							outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle(`lab') nocons drop(female $X) addstat(Control Mean, ${Y}e1c, Male Control Mean, ${Y}e1cm, Female Control Mean, ${Y}e1cf)
						}
							
					* E1 ITT, by gender
						if ${Y}e1N != 0 { 
							svy: reg ${Y}_e female ${X} assigned female_assigned if e1==1
						}
												
						 lincom assigned+female_assigned
							scalar Ysumcoeff_e1 = r(estimate)
							scalar Ysumpval_e1 = 2*ttail(e(df_r),abs(r(estimate)/r(se)))
							local Ysumse_e1 = r(se)
							local Ysumser_e1 = round(`Ysumse_e1', .001)
							local pstar_e1
							if Ysumpval_e1<=0.01 { 
								local pstar_e1 "*" 
							}
						 	if Ysumpval_e1<=0.05 { 
								local pstar_e1 "`pstar_e1'*" 
		 					}
							if Ysumpval_e1<=0.1 { 
								local pstar_e1 "`pstar_e1'*" 
							}
							local Ysumsestar_e1 "[`Ysumser_e1']`pstar_e1'" 
						
							
						if ${Y}e1N != 0 { 
							outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle(`lab') nocons drop(female $X) addstat(Female TE coeff, Ysumcoeff_e1, Female TE Pval, Ysumpval_e1, Female TE Std Error ,`Ysumse_e1' ) addtext (Female TE Std Error Star , "`Ysumsestar_e1'")
						}					
										
					* Control Mean E2 All 
						sum ${Y}_e [iw=w_sampling_e] if e2==1 & assigned==0
						scalar ${Y}e2c = r(mean)
						scalar ${Y}e2N = r(N)
					
					* Control Mean E2 Female
						sum ${Y}_e [iw=w_sampling_e] if e2==1 & assigned==0 & female==1
						scalar ${Y}e2cf = r(mean)
					
					* Control Mean E2 Male
						sum ${Y}_e [iw=w_sampling_e] if e2==1 & assigned==0 & female==0
						scalar ${Y}e2cm = r(mean)
														
					* E2 ITT, all
						if ${Y}e2N != 0 { 
							svy: reg ${Y}_e female ${X} assigned if e2==1
							outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle(`lab') nocons drop(female $X) addstat(Control Mean, ${Y}e2c, Male Control Mean, ${Y}e2cm, Female Control Mean, ${Y}e2cf)
						}
							 
					* E2 ITT, by gender
						if ${Y}e2N != 0 { 
							svy: reg ${Y}_e female ${X} assigned female_assigned if e2==1
						}
												
						 lincom assigned+female_assigned
							scalar Ysumcoeff_e2 = r(estimate)
							scalar Ysumpval_e2 = 2*ttail(e(df_r),abs(r(estimate)/r(se)))
							local Ysumse_e2 = r(se)
							local Ysumser_e2 = round(`Ysumse_e2', .001)
							local pstar_e2
							if Ysumpval_e2<=0.01 { 
								local pstar_e2 "*" 
							}
						 	if Ysumpval_e2<=0.05 { 
								local pstar_e2 "`pstar_e2'*" 
		 					}
							if Ysumpval_e2<=0.1 { 
								local pstar_e2 "`pstar_e2'*" 
							}
							local Ysumsestar_e2 "[`Ysumser_e2']`pstar_e2'" 
						
							
						if ${Y}e2N != 0 { 
							outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle(`lab') nocons drop(female ${X}) addstat(Female TE coeff, Ysumcoeff_e2, Female TE Pval, Ysumpval_e2, Female TE Std Error ,`Ysumse_e2' ) addtext (Female TE Std Error Star , "`Ysumsestar_e2'")
						}					
					
				end
 




 
/////////////////////////////////////
// 3.0 MAIN TABLES (WORKING PAPER) //
/////////////////////////////////////

	// 3.1 TABLE 1: SURVEY RESPONSE RATES
		
			gl table table1
				cap erase $table.xls
				cap erase $table.txt

				summ ind_found_b if e1==1 				
				scalar attrition_all_b=r(mean)
				summ ind_found_b if assigned==0 & e1==1
				scalar attrition_c_b=r(mean)
				summ ind_found_b if assigned==1 & e1==1
				scalar attrition_t_b=r(mean)				

			 	reg ind_found_b assigned $districts if e1==1, cluster(group_endline)
					sca diff_b = _b[assigned]
					testparm assigned
					sca pstat_b = r(p)

				summ ind_found_e1 [iw=w_sampling_e] if e1==1 & phase2_notrack_e1==.				
				scalar attrition_all_e1=r(mean)
				summ ind_found_e1 [iw=w_sampling_e] if assigned==0 & e1==1 & phase2_notrack_e1==.
				scalar attrition_c_e1=r(mean)
				summ ind_found_e1 [iw=w_sampling_e] if assigned==1 & e1==1 & phase2_notrack_e1==.
				scalar attrition_t_e1=r(mean)

			 	reg ind_found_e1 assigned $districts [pw=w_sampling_e] if e1==1, cluster(group_endline)
					sca diff_e1 = _b[assigned]
					testparm assigned
					sca pstat_e1 = r(p)

				summ ind_found_e2 [iw=w_sampling_e] if e2==1 & phase2_notrack_e2==.				
				scalar attrition_all_e2=r(mean)
				summ ind_found_e2 [iw=w_sampling_e] if assigned==0 & e2==1 & phase2_notrack_e2==.
				scalar attrition_c_e2=r(mean)
				summ ind_found_e2 [iw=w_sampling_e] if assigned==1 & e2==1 & phase2_notrack_e2==.
				scalar attrition_t_e2=r(mean)
				
			 	reg ind_found_e2 assigned $districts [pw=w_sampling_e] if e2==1, cluster(group_endline)
					sca diff_e2 = _b[assigned]
					testparm assigned
					sca pstat_e2 = r(p)
					
					
				matrix D=(attrition_all_b, attrition_c_b, attrition_t_b, diff_b, pstat_b \ attrition_all_e1, attrition_c_e1, attrition_t_e1, diff_e1, pstat_e1 \ attrition_all_e2, attrition_c_e2, attrition_t_e2, diff_e2, pstat_e2 )
				local cnames `" "All" "Control" "Treatment" "Difference" "p-value" "'				
				local rnames `" "Baseline" "2-year endline" "4-year endline" "'
				
				xml_tab D, save("$table.xml") replace noisily cnames(`cnames') rnames(`rname') font("Times New Roman" 10) format((SCLR0) (SCCR0 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2))


	// 3.2 TABLE 2: BASELINE SUMMARY STATISTICS AND TESTS OF BALANCE 

		** GROUP LEVEL
	
			cap bysort groupid: egen count=rank(partid) if e1==1

			gl table table2a
				cap erase $table.xml
				cap erase $table.txt
		
			cap matrix drop E
			
			// ADMIN DATA
			
			foreach x in admin_cost_us groupsize_est_e grantsize_pp_US_est3 {
		 		sum `x' if assigned==1 & count==1 & e1==1
					sca c_mu = r(mean)
					sca c_v = r(sd)
					sca c_N = r(N)
				
			
		 		sum `x' if assigned==0 & count==1 & e1==1
					sca d_mu = r(mean)
					sca d_v = r(sd)
					sca d_N = r(N)
			 		
				qui reg `x' assigned $districts if e1==1 & count==1, cluster(group_endline)
					sca b_hat = _b[assigned]
					testparm assigned
					sca pstat = r(p)

				matrix E=nullmat(E)\(d_mu, d_v, d_N, c_mu, c_v, c_N, b_hat, pstat)
			}	
			
			// GROUP SURVEY DATA
			
			foreach x in group_existed group_age ingroup_hetero ingroup_dynamic avgdisteduc {
		 		sum `x' if assigned==1 & count==1 & e1==1 & group_unfound_b==0
					sca c_mu = r(mean)
					sca c_v = r(sd)
					sca c_N = r(N)
				
			
		 		sum `x' if assigned==0 & count==1 & e1==1 & group_unfound_b==0
					sca d_mu = r(mean)
					sca d_v = r(sd)
					sca d_N = r(N)
			 		
				qui reg `x' assigned $districts if e1==1 & count==1 & group_unfound_b==0, cluster(group_endline)
					sca b_hat = _b[assigned]
					testparm assigned
					sca pstat = r(p)

				matrix E=nullmat(E)\(d_mu, d_v, d_N, c_mu, c_v, c_N, b_hat, pstat)
			}	
				
			local cnames `" "Control Mean" "Control Standard Deviation" "Control Obs" "Treatment Mean" "Treatment Standard Deviation" "Treatment Obs" "Regression difference" "P-Value" "'
			local rname
			foreach x in admin_cost_us groupsize_est_e grantsize_pp_US_est3 group_existed group_age ingroup_hetero ingroup_dynamic avgdisteduc {
				local lbl : variable label `x'
				local rname `" `rname' "`lbl'" "'
			}	
				
			xml_tab E, save("$table.xml") replace noisily cnames(`cnames') rnames(`rname') font("Times New Roman" 10) format((SCLR0) (SCCR0 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2))
			 
		** INDIVIDUAL LEVEL

		gl baseline_ind "age female urban risk_aversion grp_leader grp_chair totalhrs7da_zero nonaghours7da_zero $E $H $K"

			gl table table2b
				cap erase $table.xml
				cap erase $table.txt
		
			cap matrix drop E
			
			// Balance on whether individual found at baseline

	 			sum ind_unfound_b if assigned==1 & e1==1
					sca c_mu = r(mean)
					sca c_v = r(sd)
					sca c_N = r(N)
			
		 		sum ind_unfound_b if assigned==0 & e1==1
					sca d_mu = r(mean)
					sca d_v = r(sd)
					sca d_N = r(N)
					
				qui reg ind_unfound_b assigned $districts if e1==1, cluster(group_endline)
					sca b_hat = _b[assigned]
					testparm assigned
					sca pstat = r(p)
			 		
				matrix E=nullmat(E)\(d_mu, d_v, d_N, c_mu, c_v, c_N, b_hat, pstat)
			
			// Balance on survey characteristics
			
				foreach x in $baseline_ind {
			 		sum `x' if assigned==1 & ind_found_b==1 & e1==1
						sca c_mu = r(mean)
						sca c_v = r(sd)
						sca c_N = r(N)
				
			 		sum `x' if assigned==0 & ind_found_b==1 & e1==1
						sca d_mu = r(mean)
						sca d_v = r(sd)
						sca d_N = r(N)
						
					qui reg `x' assigned $districts if e1==1 & ind_found_b==1, cluster(group_endline)
						sca b_hat = _b[assigned]
						testparm assigned
						sca pstat = r(p)
				 		
					matrix E=nullmat(E)\(d_mu, d_v, d_N, c_mu, c_v, c_N, b_hat, pstat)
				}	
					
			local cnames `" "Control Mean" "Control Standard Deviation" "Control Obs" "Treatment Mean" "Treatment Standard Deviation" "Treatment Obs" "Regression difference" "P-Value" "'
			local rname
			foreach x in ind_unfound_b $baseline_ind {
				local lbl : variable label `x'
				local rname `" `rname' "`lbl'" "'
			}	
			
			xml_tab E, save("$table.xml") replace noisily cnames(`cnames') rnames(`rname') font("Times New Roman" 10) format((SCLR0) (SCCR0 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2))

	// 3.2b F-TEST ON BASELINE VARIABLES
		
		gl table table32b
				cap erase $table.xml
				cap erase $table.txt
				
		reg assigned $ctrl_indiv $H $K $E $G if e1==1 & ind_unfound_b==0, cluster (group_endline)
		testparm $ctrl_indiv $H $K $E $G
		local Fstatistic = r(F)
		local Pstat = r(p)
		outreg2 using $table.xml, excel append aster(se) ctitle(`lbl') br label addstat(F Statistic, `Fstatistic', P stat, `Pstat')
		
	// 3.2c WHAT CONTROL VALUE WOULD LEAD TO BALANCE?
	/*
		gl table table2c
				cap erase $table.xml
				cap erase $table.txt
	
		foreach x in S_K wealthindex {
		
			foreach y in 50 60 70 80 90 {
			
			local lab: var label `x'
			gen `x'_`y'=`x'	
			la var `x'_`y' "`lab': imputed percentile `y'"
			sum `x', d
			replace `x'_`y'=r(p50) if ind_unfound_b==1 & assigned==1
			_pctile `x', p(`y')
			replace `x'_`y'=r(r1) if ind_unfound_b==1 & assigned==0
			
			sum `x'_`y' if assigned==1 &  e1==1
						sca c_mu_`y' = r(mean)
						sca c_v_`y' = r(sd)
						sca c_N_`y' = r(N)
				
			 		sum `x'_`y' if assigned==0 & e1==1
						sca d_mu_`y' = r(mean)
						sca d_v_`y' = r(sd)
						sca d_N_`y' = r(N)
			
			qui reg `x'_`y' assigned $districts if e1==1, cluster(group_endline)
						sca b_hat = _b[assigned]
						testparm assigned
						sca pstat = r(p)
						matrix E=nullmat(E)\(d_mu_`y', d_v_`y', d_N_`y', c_mu_`y', c_v_`y', c_N_`y', b_hat, pstat)
						
						}
			}
			
		local cnames `" "Control Mean" "Control Standard Deviation" "Control Obs" "Treatment Mean" "Treatment Standard Deviation" "Treatment Obs" "Regression difference" "P-Value" "'
			local rname
			foreach x in  S_K wealthindex {
				foreach y in 50 60 70 80 90 {
				local lbl : variable label `x'_`y'
				local rname `" `rname' "`lbl'" "'
			}
			}	
			
			xml_tab E, save("$table.xml") replace noisily cnames(`cnames') rnames(`rname') font("Times New Roman" 10) format((SCLR0) (SCCR0 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2))
*/
 
		gl table table32c
						cap erase $table.xml
						cap erase $table.txt
			
				foreach x in S_K wealthindex voc_training loan_100k savings_6mo_p99{
					
					local lab: var label `x'
					gen `x'_std=`x'
					sum `x'_std, d
					replace `x'_std = (`x'_std-r(mean))/r(sd)
					la var `x'_std "`lab': std"
				
				}
				
				foreach x in S_K_std wealthindex_std voc_training_std loan_100k_std savings_6mo_p99_std {
				
				foreach p in 0 1 2 3 4 5 {
				
					
					local lab: var label `x'
					gen `x'_`p'=`x'	
					la var `x'_`p' "`lab':`p'"
					replace `x'_`p'=0 if ind_unfound_b==1 & assigned==1
					replace `x'_`p'=(0.5*`p') if ind_unfound_b==1 & assigned==0
					
					sum `x'_`p' if assigned==1 &  e1==1
								sca c_mu_`p' = r(mean)
								sca c_v_`p' = r(sd)
								sca c_N_`p' = r(N)
						
							sum `x'_`p' if assigned==0 & e1==1
								sca d_mu_`p' = r(mean)
								sca d_v_`p' = r(sd)
								sca d_N_`p' = r(N)
					
					qui reg `x'_`p' assigned $districts if e1==1, cluster(group_endline)
								sca b_hat = _b[assigned]
								testparm assigned
								sca pstat = r(p)
								matrix E=nullmat(E)\(d_mu_`p', d_v_`p', d_N_`p', c_mu_`p', c_v_`p', c_N_`p', b_hat, pstat)
								
								}
					}
					
					
				local cnames `" "Control Mean" "Control Standard Deviation" "Control Obs" "Treatment Mean" "Treatment Standard Deviation" "Treatment Obs" "Regression difference" "P-Value" "'
					local rname
					foreach x in  S_K_std wealthindex_std voc_training_std loan_100k_std savings_6mo_p99_std{
						foreach y in 0 1 2 3 4 5 {
						local lbl : variable label `x'_`y'
						local rname `" `rname' "`lbl'" "'
					}
					}	
					
					xml_tab E, save("$table.xml") replace noisily cnames(`cnames') rnames(`rname') font("Times New Roman" 10) format((SCLR0) (SCCR0 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2))

		
	// 3.3 TABLE 3: SUMMARY STATISTICS, MAJOR OUTCOMES
		
		gl table table3a
			cap erase $table.xml
			cap erase $table.txt
	
		cap matrix drop E
		
		gl outcomes "$outcomes_transfer $outcomes_invest $outcomes_work $outcomes_income $outcomes_migrate $outcomes_formalize $outcomes_other"
				
	 		sum treated if e1==1
				sca obs_e = r(N)

	 		sum treated if e1==1 & assigned==0
				sca c_mu_e = r(mean)
				sca c_v_e = r(sd)
		
			sum treated if e1==1 & assigned==1
				sca c_mu_e2 = r(mean)
				sca c_v_e2 = r(sd)
			
	 		sum treated if e2==1
				sca obs_e2 = r(N)

			sum treated if e2==1 & assigned==0
				sca c_mu_e3 = r(mean)
				sca c_v_e3 = r(sd)
				
			sum treated if e2==1 & assigned==1
				sca c_mu_e4 = r(mean)
				sca c_v_e4 = r(sd)
			
			matrix E=nullmat(E)\(c_mu_e, c_v_e, c_mu_e2, c_v_e2, obs_e, c_mu_e3, c_v_e3, c_mu_e4, c_v_e4, obs_e2)
					
					
		foreach x in $outcomes {
		
			sca placeholder = 0
		
	 		sum `x'_e [iw=w_sampling_e] if e1==1
				sca obs_e = r(N)

	 		sum `x'_e [iw=w_sampling_e] if e1==1 & assigned==0
				sca c_mu_e = r(mean)
				sca c_v_e = r(sd)
		
			sum `x'_e [iw=w_sampling_e] if e1==1 & assigned==1
				sca c_mu_e2 = r(mean)
				sca c_v_e2 = r(sd)
			
	 		sum `x'_e [iw=w_sampling_e] if e2==1
				sca obs_e2 = r(N)

			sum `x'_e [iw=w_sampling_e] if e2==1 & assigned==0
				sca c_mu_e3 = r(mean)
				sca c_v_e3 = r(sd)
				
			sum `x'_e [iw=w_sampling_e] if e2==1 & assigned==1
				sca c_mu_e4 = r(mean)
				sca c_v_e4 = r(sd)
			
			matrix E=nullmat(E)\(c_mu_e, c_v_e, c_mu_e2, c_v_e2, obs_e, c_mu_e3, c_v_e3, c_mu_e4, c_v_e4, obs_e2)
					
		}	
			
		local cnames `" "Control Mean" "Control Std. Dev." "Treatment Mean" "Treatment Std. Dev." "Obs" "Control Mean" "Control Std. Dev." "Treatment Mean" "Treatment Std. Dev." "Obs" "'
		local rname
		foreach x in treated $outcomes {
			local lbl : variable label `x'_e
			local rname `" `rname' "`lbl'" "'
		}	
			
		xml_tab E, save("$table.xml") replace noisily cnames(`cnames') rnames(`rname') font("Times New Roman" 11) format((SCLR0) (SCCR0 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2))
		 
		 
		gl table table3b
			cap erase $table.xml
			cap erase $table.txt
		
		regress treated assigned female $controls if e1==1, cluster(groupid)
		outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle ("Treated") nocons drop(female $controls) 				

		foreach e in e1 e2 { 
			foreach y in $outcomes { 
				local lab : var label `y'_e
				di "`lab', `e'" 
				cap svy: regress `y'_e assigned female $controls if `e'==1
				cap outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle (`lab') nocons drop(female $controls) 				
				}
			}


	// 3.4 TABLE 4: CAPITAL STOCK
		gl table table4a
			cap erase $table.xls
			cap erase $table.txt
				
		foreach y of varlist bizasset_val_real_p99_e {
		
			local lab : var label `y'	

			foreach n in 1 2 {	
			
				foreach t in 0 1 {
								
					* All 
						sum `y' [iw=w_sampling_e] if e`n'==1 & assigned==`t'
							scalar `y'e`n'`t' = r(mean)
							scalar `y'e`n'`t'se = r(sd)
						sum `y' if e`n'==1 & assigned==`t', d
							scalar `y'e`n'`t'med = r(p50)						
					
					* Female
						sum `y' [iw=w_sampling_e] if e`n'==1 & assigned==`t' & female==1
							scalar `y'e`n'`t'f = r(mean)
							scalar `y'e`n'`t'fse = r(sd)
						sum `y' if e`n'==1 & assigned==`t' & female==1, d
							scalar `y'e`n'`t'fmed = r(p50)						
					
					* Male
						sum `y' [iw=w_sampling_e] if e`n'==1 & assigned==`t' & female==0
							scalar `y'e`n'`t'm = r(mean)
							scalar `y'e`n'`t'mse = r(sd)
						sum `y' if e`n'==1 & assigned==`t' & female==0, d
							scalar `y'e`n'`t'mmed = r(p50)						
					}
				}								

				foreach t in 0 1 {
				
					svy: reg `y' e2 female $controls if assigned==`t'
						outreg2 using $table.xls, excel aster(se) dec(1) br label ctitle(`lab') nocons drop(female $controls) addstat(E1 mean, `y'e1`t', E1 se, `y'e1`t'se, E1 median, `y'e1`t'med, E2 mean, `y'e2`t', E2 se, `y'e2`t'se, E2 median, `y'e2`t'med)

					svy: reg `y' e2 $controls if assigned==`t' & female==1
						outreg2 using $table.xls, excel aster(se) dec(1) br label ctitle(`lab') nocons drop($controls) addstat(E1 mean, `y'e1`t'f, E1 se, `y'e1`t'fse, E1 median, `y'e1`t'fmed, E2 mean, `y'e2`t'f, E2 se, `y'e2`t'fse, E2 median, `y'e2`t'fmed)

					svy: reg `y' e2 $controls if assigned==`t' & female==0
						outreg2 using $table.xls, excel aster(se) dec(1) br label ctitle(`lab') nocons drop($controls) addstat(E1 mean, `y'e1`t'm, E1 se, `y'e1`t'mse, E1 median, `y'e1`t'mmed, E2 mean, `y'e2`t'm, E2 se, `y'e2`t'mse, E2 median, `y'e2`t'mmed)

				}

			}


		gl table table4b
			cap erase $table.xls
			cap erase $table.txt
			
			gl Y bizasset_val_real_p99
			gl X $controls
			ITT	
			
		gl table table4c
			cap erase $table.xls
			cap erase $table.txt	
		
		cap matrix drop E
					
			foreach x in nottreated notraining_e notskilled_e trainskilled_e {
					
						sca placeholder = 0	

						sum bizasset_val_real_p99_e [iw=w_sampling_e] if e1==1 & assigned==1 & `x'==1
							sca mean2010 = r(mean)
						
						sum bizasset_val_real_p99_e [iw=w_sampling_e] if e2==1 & assigned==1 & `x'==1
							sca mean2012 = r(mean)
								
						svy: reg  bizasset_val_real_p99_e e2 $controls if assigned==1 & `x'==1
							sca change=_b[e2]
							sca sdchange=_se[e2]
								
						
						matrix E=nullmat(E)\(mean2010, mean2012, change, placeholder, sdchange)
								
					}	
						
					local cnames `" "2010 mean" "2012 mean" "Change" "% Change" "SD" "'
					local rname
					foreach x in  nottreated notraining_e notskilled_e trainskilled_e  {
						local lbl : variable label `x'
						local rname `" `rname' "`lbl'" "'
					}	
						
					xml_tab E, save("$table.xml") replace noisily cnames(`cnames') rnames(`rname') font("Times New Roman" 11) format((SCLR0) (SCCR0 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2))
					

	// 3.5 TABLE 5: PROGRAM IMPACTS ON HIRED LABOR
	
		
			gl table table5
						cap erase $table.xml
						cap erase $table.txt
				
					cap matrix drop E
					
					gl employment_table "employees employees2 employees3 employhours employhours2 employhours3 pemployees pemployees2 pemployees3 payroll payroll2 payroll3 mpayroll mpayroll2 mpayroll3"

			foreach x in $employment_table {
					
						sca placeholder = 0
					

						sum `x'_e if e2==1 & assigned==0, d
							sca c_mu_e3 = r(mean)
							sca c_v_e3 = r(N)
						
						sum `x'_e if e2==1 & assigned==0 & `x'_e!=. & `x'_e>0, d
							sca percent1 = r(N)/c_v_e3
							
						sum `x'_e if e2==1 & assigned==1, d
							sca c_mu_e4 = r(mean)
							sca c_v_e4 = r(N)
						
						sum `x'_e if e2==1 & assigned==1 & `x'_e!=. & `x'_e>0, d
							sca percent2 = r(N)/c_v_e4
						
						matrix E=nullmat(E)\(percent1, percent2, c_mu_e3, c_mu_e4)
								
					}	
						
					local cnames `" "Control Percentage" "Treatment Percentage" "Control Mean" "Treatment Mean" "'
					local rname
					foreach x in  $employment_table {
						local lbl : variable label `x'_e
						local rname `" `rname' "`lbl'" "'
					}	
						
					xml_tab E, save("$table.xml") replace noisily cnames(`cnames') rnames(`rname') font("Times New Roman" 11) format((SCLR0) (SCCR0 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2))
					

			gl table table5b
						cap erase $table.xml
						cap erase $table.txt
						
						foreach y in $employment_table { 
							local lab : var label `y'_e
							di "`lab', `e'" 
							cap svy: regress `y'_e assigned female $controls if e2==1
							cap outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle (`lab') nocons drop(female $controls) 				
							}
							
		
	// 3.6 TABLE 6: INCOME
	
		gl table table6
			cap erase $table.xls
			cap erase $table.txt
			
		foreach g in outcomes_income { 
			foreach y in $`g' { 
			gl Y `y'
			gl X $controls
			ITT	
			}	
			}
					

	// 3.7 TABLE 7: SENSITIVITY

		// ALTERNATE MODELS
		
		gl table table7a
			cap erase $table.xls
			cap erase $table.txt
			
		foreach y in skilledtrade7da_zero profits4w_real_p99 wealthindex {
			
			local lab: var label `y'_e
			
			foreach n in 1 2 {
					
				// 1 Main specification
					qui svy: reg `y'_e female $controls assigned if e`n'==1
						outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle(`lab') nocons drop(female $controls) 
		
				// 2 No control vector other than strata FE	
					qui svy: reg `y'_e $districts assigned if e`n'==1
						outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle(`lab') nocons drop($districts) 
				
				// 3 Diff-in-diff with controls
					cap qui svy: reg `y'_diff_e female $ctrl_indiv $H $G lsavings loan_100k loan_1mil aghours7da_zero chores7da_zero zero_hours nonag_dummy inschool assigned if e`n'==1
						cap outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle(`lab') nocons drop(female $ctrl_indiv $H $G lsavings loan_100k loan_1mil aghours7da_zero chores7da_zero zero_hours nonag_dummy trade_dummy inschool) 
		
				// 4 TOT with controls
					qui svy: ivregress 2sls `y'_e $controls (treated=assigned) if e`n'==1
						outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle(`lab') nocons drop(female $controls) 

			}
			}
						
		// BOUNDING EXERCISE FOR AVERAGE TREATMENT EFFECTS

			gl table table_7b_e1
				cap erase $table.xml
				cap erase $table.txt
				
			gl title "Mean standarized treatment effects under varying missing data assumptions"
		
			gl bounding "skilledtrade7da_zero_e profits4w_real_p99_e wealthindex_e"
		
		foreach x in e1 {
		
			foreach g in bounding {
				capture matrix drop `g'
	
					foreach var in $`g' {
					
						capture matrix drop `var'
					
						// 1. +/1 0.1 SD 
							gen `var'l10_`x' = `var'
							
								sum `var' if assigned==0 & `var'!=. & `x'==1, d
									replace `var'l10_`x' = r(mean) + 0.1*r(sd) if ind_unfound_`x'==1 & assigned==0 & `x'==1
							
								sum `var' if assigned==1 &`var'!=. & `x'==1, d
									replace `var'l10_`x' = r(mean) - 0.1*r(sd) if ind_unfound_`x'==1 & assigned==1 & `x'==1			
						
						// 2. +/- .25 SD 
							gen `var'l25_`x' = `var'
							
								sum `var' if assigned==0 & `var'!=. & `x'==1, d
									replace `var'l25_`x' = r(mean) + 0.25*r(sd) if ind_unfound_`x'==1 & assigned==0 & `x'==1
							
								sum `var' if assigned==1 &`var'!=. & `x'==1, d
									replace `var'l25_`x' = r(mean) - 0.25*r(sd) if ind_unfound_`x'==1 & assigned==1 & `x'==1

						// 3. +/- 0.5 SD
							gen `var'l5_`x' = `var'
							
								sum `var' if assigned==0 & `var'!=. & `x'==1, d
									replace `var'l5_`x' = r(mean) + 0.5*r(sd) if ind_unfound_`x'==1 & assigned==0 & `x'==1
							
								sum `var' if assigned==1 &`var'!=. & `x'==1, d
									replace `var'l5_`x' = r(mean) - 0.5*r(sd) if ind_unfound_`x'==1 & assigned==1 & `x'==1
																		
						// 4. +/- 1.0 SD
							gen `var'l1_`x'= `var'
							
								sum `var' if assigned==0 &`var'!=. & `x'==1, d
									replace `var'l1_`x' = r(mean) + r(sd) if ind_unfound_`x'==1 & assigned==0 & `x'==1
							
								sum `var' if assigned==1 & `var'!=. & `x'==1, d
									replace `var'l1_`x' = r(mean) - r(sd) if ind_unfound_`x'==1 & assigned==1 & `x'==1
						
						// 5. Lower Manski Bound
							gen `var'lmm_`x' = 	`var'
							
								sum `var' if assigned==0 &`var'!=. & `x'==1, d
									replace `var'lmm_`x' = r(max) if ind_unfound_`x'==1 & assigned==0 &`x'==1
							
								sum `var' if assigned==1 &`var'!=. & `x'==1, d
									replace `var'lmm_`x' = r(min) if ind_unfound_`x'==1 & assigned==1 &`x'==1
					
						foreach z in l10 l25 l5 l1 lmm { 
							
							sum `var'`z'_`x' [iw=w_sampling_e] if assigned==0 & `x'==1
								local `var'`z'mean = r(mean)
								display ``var'`z'mean'
							
							qui svy: reg `var'`z'_`x' female $controls assigned if `x'==1
								
								local obs`z' = e(N)
									display `obs`z''
									
								local treated`z'coeff = _b[assigned]
									display `treated`z'coeff'
									
								local treated`z'perc = _b[assigned]/``var'`z'mean'
									display `treated`z'perc'	
									
								local treated`z'se = _se[assigned]
									display `treated`z'se'
							
								qui testparm assigned
								local treated`z'pstat = r(p)
									
							matrix mat`var's = (`treated`z'coeff' \ `treated`z'se' \ `treated`z'perc'\ `treated`z'pstat' \ `obs`z'')
								matrix list mat`var's
							
							matrix `var' = nullmat(`var'), mat`var's
								matrix list `var'
								
							cap drop `var'`z'
						}
					
					// Big matrix
						matrix `g' = (nullmat(`g') \ `var')
							matrix list `g'
							
						local lbl : variable label `var'
						local rname `" `rname' "`lbl'" "'
						local rname `" `rname' "se" "% Change" "pstat" "Obs" "'
						display `rname'		
	
				
					}	
					
				// Set colum names
					local cnames `" "Lower 0.1 SD" "Lower 0.25 SD" "Lower 0.5 SD" "Lower 1 SD" "Lower Manski" "'	
							
				// Save table	
					xml_tab `g', save("$table.xml") cnames(`cnames') rnames(`rname') replace
			}
	}	
	
	// 3.8 TABLE 8: SOCIAL OUTCOMES
		
		gl table table8
			cap erase $table.xls
			cap erase $table.txt
			
			foreach g in table_social { 
				foreach y in $`g' {
				gl Y `y'
				gl X "$controls $S $I $W"
				ITT	
				}
			}	
	

	// 3.9 TABLE 9: IMPACT HETEROGENEITY	
		
		gl table table9
			cap erase $table.xml
			cap erase $table.txt
	 
		foreach y in bizasset_val_real_p99 profits4w_real_p99 { 
		
			* Label of dependant variables
				local lab : var label `y'_e 
	
				reg `y'_e assigned e2 assigned_e2 female female_e2 $ctrl_indiv $E $G A_emplvoc S_K A_S_K S_H A_S_H S_P_m A_S_P_m $districts [pw=w_sampling_e], cluster(partid)
					outreg2 using $table.xls, excel aster(se) dec(1) br label ctitle (`lab') nocons drop ($ctrl_indiv lowskill7da_zero lowbus7da_zero skilledtrade7da_zero highskill7da_zero acto7da_zero aghours7da_zero chores7da_zero zero_hours nonag_dummy inschool $G $districts) 
		
				reg `y'_e assigned e2 assigned_e2 $ctrl_indiv $E $G A_emplvoc S_K A_S_K S_H A_S_H S_P_m A_S_P_m $districts [pw=w_sampling_e] if female==0, cluster(partid)
					outreg2 using $table.xls, excel aster(se) dec(1) br label ctitle (`lab') nocons drop ($ctrl_indiv lowskill7da_zero lowbus7da_zero skilledtrade7da_zero highskill7da_zero acto7da_zero aghours7da_zero chores7da_zero zero_hours nonag_dummy inschool $G $districts) 
	
				reg `y'_e assigned e2 assigned_e2 $ctrl_indiv $E $G A_emplvoc S_K A_S_K S_H A_S_H S_P_m A_S_P_m $districts [pw=w_sampling_e] if female==1, cluster(partid)
					outreg2 using $table.xls, excel aster(se) dec(1) br label ctitle (`lab') nocons drop ($ctrl_indiv lowskill7da_zero lowbus7da_zero skilledtrade7da_zero highskill7da_zero acto7da_zero aghours7da_zero chores7da_zero zero_hours nonag_dummy inschool $G $districts) 
		
				}
				

	
	// 3.10 TABLE 10: MALE FEMALE DIFFERENCES
	
			gl table table10
					cap erase $table.xml
					cap erase $table.txt
				
				foreach y in wealthindex savings_6mo_p99 cash4w_p99 loan_100k loan_1mil S_K tot_outloansize_p99 tot_outloansize_cond_p99 S_H { 
							 
					local lab : var label `y'

						sum `y' if female==0 & e1==1 & ind_found_b==1
						local Ymean = r(mean)
					
						reg `y' female $districts if e1==1 & ind_found_b==1, cluster(groupid)
							outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle (`lab') nocons drop ($districts) addstat(Male mean, `Ymean')
					}	
	
				foreach y in S_P_m { 
							 
					local lab : var label `y'

						sum `y' if female==0 & e1==1 & ind_found_e1==1
						local Ymean = r(mean)
					
						svy: reg `y' female $districts if e1==1 & ind_found_e1==1
							outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle (`lab') nocons drop ($districts) addstat(Male mean, `Ymean')
					}	
	
				foreach y in wealthindex_e savings_real_p99_e profits4w_real_p99_e loan_100k_e loan_1mil_e tot_outloansize_p99_e  voc_training_e training_hours_e bizasset_val_real_p99_e { 
							 
					local lab : var label `y'

						sum `y' if female==0 & e1==1 & assigned==0 & ind_found_e1==1
						local Ymean = r(mean)
					
						svy: reg `y' female $districts if e1==1 & assigned==0 & ind_found_e1==1
							outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle (`lab') nocons drop ($districts) addstat(Male mean, `Ymean')
					}	
					
					sum  tot_outloansize_cond_p99_e if female==0 & e1==1 & assigned==0 & ind_found_e1==1
						local Ymean = r(mean)
					
						reg  tot_outloansize_cond_p99_e female $districts if e1==1 & assigned==0 & ind_found_e1==1 [pw=w_sampling_e], cluster(group_endline)
							outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle (`lab') nocons drop ($districts) addstat(Male mean, `Ymean')

				foreach y in wealthindex_e profits4w_real_p99_e bizasset_val_real_p99_e { 
							 
					local lab : var label `y'

						sum `y' if female==0 & e2==1 & assigned==0 & ind_found_e2==1
						local Ymean = r(mean)
					
						svy: reg `y' female $districts if e2==1 & assigned==0 & ind_found_e2==1
							outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle (`lab') nocons drop ($districts) addstat(Male mean, `Ymean')
					}								
	 
			
	// 3.10 TABLE 10: SOCIAL OUTCOMES
		
		gl table table10
			cap erase $table.xls
			cap erase $table.txt
			
			foreach g in table_social { 
				foreach y in $`g' {
				gl Y `y'
				gl X "$controls $S $I $W"
				ITT	
				}
			}	
			
		
	// 3.11 FIGURE 3: EARNINGS TRENDS

		summ profits4w_p99 if e1==1 & female==0 & assigned==0
		summ profits4w_p99 if e1==1 & female==0 & assigned==1
		summ profits4w_p99 if e1==1 & female==1 & assigned==0
		summ profits4w_p99 if e1==1 & female==1 & assigned==1
				
		summ profits4w_real_p99_e [iw=w_sampling_e] if e1==1 & ind_found_e1==1 & female==0 & assigned==0
		summ profits4w_real_p99_e [iw=w_sampling_e] if e1==1 & ind_found_e1==1 & female==0 & assigned==1
		summ profits4w_real_p99_e [iw=w_sampling_e] if e1==1 & ind_found_e1==1 & female==1 & assigned==0
		summ profits4w_real_p99_e [iw=w_sampling_e] if e1==1 & ind_found_e1==1 & female==1 & assigned==1

		summ profits4w_real_p99_e [iw=w_sampling_e] if e2==1 & ind_found_e2==1 & female==0 & assigned==0
		summ profits4w_real_p99_e [iw=w_sampling_e] if e2==1 & ind_found_e2==1 & female==0 & assigned==1
		summ profits4w_real_p99_e [iw=w_sampling_e] if e2==1 & ind_found_e2==1 & female==1 & assigned==0
		summ profits4w_real_p99_e [iw=w_sampling_e] if e2==1 & ind_found_e2==1 & female==1 & assigned==1	
		
	
		
		
				
	// 3.11 FIGURE 1: GROUP AND GRANT SIZE
	
		// 2a: GROUP SIZE HISTOGRAM
 
			tw hist group_size if assigned==1, percent start(0) width(5) gap(10) color(black) || hist group_size if assigned==0, graphr(color(white)) percent start(0) width(5) gap(45) lc(black) fc(white) legend(label(1 "Treatment") label(2 "Control"))

		// 2b: GRANT SIZE HISTOGRAM
	
			 tw hist grantsize_pp_US_e if assigned==1, percent width(50) gap(20) bcolor(gs5) graphr(color(white)) start(0)
	
			
//////////////////////	
// 4.0 APPENDIX //////
//////////////////////

	// 4.1 APPENDIX TABLE 1: CORRELATES OF ATTRITION

			gl table attrition
					cap erase $table.xml
					cap erase $table.txt 
			
			reg ind_unfound_e1 assigned admin_cost_us groupsize_est_e grantsize_pp_US_est3 group_existed group_age ingroup_hetero ingroup_dynamic avgdisteduc age urban risk_aversion grp_leader grp_chair  $E $H $K $districts [pw=w_sampling_e] if e1==1 & phase2_notrack_e1!=1, cluster(group_endline)
				testparm assigned admin_cost_us groupsize_est_e grantsize_pp_US_est3 group_existed group_age ingroup_hetero ingroup_dynamic avgdisteduc age urban risk_aversion grp_leader grp_chair  $E $H $K
				local Fstatistic = r(F)
				local Pstat = r(p)
			outreg2 using $table.xml, excel append aster(se) bdec(3) ctitle(`lbl') br label addstat(F Statistic, `Fstatistic', P stat, `Pstat')
			
			reg ind_unfound_e2 assigned admin_cost_us groupsize_est_e grantsize_pp_US_est3 group_existed group_age ingroup_hetero ingroup_dynamic avgdisteduc age urban risk_aversion grp_leader grp_chair  $E $H $K $districts [pw=w_sampling_e] if e2==1 & phase2_notrack_e2!=1, cluster(group_endline)
				testparm assigned admin_cost_us groupsize_est_e grantsize_pp_US_est3 group_existed group_age ingroup_hetero ingroup_dynamic avgdisteduc age urban risk_aversion grp_leader grp_chair  $E $H $K
				local Fstatistic = r(F)
				local Pstat = r(p)
			outreg2 using $table.xml, excel append aster(se) bdec(3) ctitle(`lbl') br label addstat(F Statistic, `Fstatistic', P stat, `Pstat')
			
		
							gl table attritionb
										cap erase $table.xml
										cap erase $table.txt
							
							cap matrix drop E	
							
							foreach x in assigned admin_cost_us groupsize_est_e grantsize_pp_US_est3 group_existed group_age ingroup_hetero ingroup_dynamic avgdisteduc age urban risk_aversion grp_leader grp_chair  $E $H $K {
							
											sum `x' [iw=w_sampling_e] if  e1==1 & ind_unfound_b==0 
											sca sd=r(sd)
											
										matrix E=nullmat(E)\(sd)
								}	
									
									local cnames `" "Standard Deviation" "'
									local rname
									foreach x in  assigned admin_cost_us groupsize_est_e grantsize_pp_US_est3 group_existed group_age ingroup_hetero ingroup_dynamic avgdisteduc age urban risk_aversion grp_leader grp_chair  $E $H $K {
										local lbl : variable label `x'
										local rname `" `rname' "`lbl'" "'
									}	
										
							xml_tab E, save("$table.xml") replace noisily cnames(`cnames') rnames(`rname') font("Times New Roman" 10) format((SCLR0) (SCCR0 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2))

	// 4.2 APPENDIX TABLE 2: SENSITIVITY OF BASELINE RANDOMIZATION BALANCE	
			gl table tableA2
						cap erase $table.xml
						cap erase $table.txt
						cap matrix drop E
				/* Note: these variables are created in lines 501 to 509 */
				foreach x in  wealthindex_std voc_training_std loan_100k_std savings_6mo_p99_std {
				
				foreach p in 0 1 2 3 4 5 {
				
					
					local lab: var label `x'
					la var `x'_`p' "`lab':`p'"
					replace `x'_`p'=0 if ind_unfound_b==1 & assigned==1
					replace `x'_`p'=(0.5*`p') if ind_unfound_b==1 & assigned==0
					
					sum `x'_`p' if assigned==1 &  e1==1
								sca c_mu_`p' = r(mean)
								sca c_v_`p' = r(sd)
								sca c_N_`p' = r(N)
						
							sum `x'_`p' if assigned==0 & e1==1
								sca d_mu_`p' = r(mean)
								sca d_v_`p' = r(sd)
								sca d_N_`p' = r(N)
					
					qui reg `x'_`p' assigned $districts if e1==1, cluster(group_endline)
								sca b_hat = _b[assigned]
								testparm assigned
								sca pstat = r(p)
								matrix E=nullmat(E)\(d_mu_`p', d_v_`p', d_N_`p', c_mu_`p', c_v_`p', c_N_`p', b_hat, pstat)
								
								}
					}
					
					
				local cnames `" "Control Mean" "Control Standard Deviation" "Control Obs" "Treatment Mean" "Treatment Standard Deviation" "Treatment Obs" "Regression difference" "P-Value" "'
					local rname
					foreach x in  wealthindex_std voc_training_std loan_100k_std savings_6mo_p99_std{
						foreach y in 0 1 2 3 4 5 {
						local lbl : variable label `x'_`y'
						local rname `" `rname' "`lbl'" "'
					}
					}	
					
					xml_tab E, save("$table.xml") replace noisily cnames(`cnames') rnames(`rname') font("Times New Roman" 10) format((SCLR0) (SCCR0 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2))

		

	// 4.3 APPENDIX TABLE 3: POPULATION ATE
	
				gl table population_ATE
						cap erase $table.xls
						cap erase $table.txt 
						
				foreach y in training_hours  {
					
					svy: reg `y'_e female $controls assigned  
					outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle(`lab') nocons drop(female $controls e2) 
					
					svy: reg `y'_e female $controls assigned  if age>15 & age<36 
					outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle(`lab') nocons drop(female $controls e2) 
					
					svyset [pw=pop_weight1], strata(district) psu(group_endline)
					svy: reg `y'_e female $controls assigned 
					outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle(`lab') nocons drop(female $controls e2) 
					
					svyset [pw=w_sampling_e], strata(district) psu(group_endline)
					svy: reg `y'_e female $controls assigned  if age>17 & age<31 
					outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle(`lab') nocons drop(female $controls e2)
					
					svyset [pw=pop_weight2], strata(district) psu(group_endline)
					svy: reg `y'_e female $controls assigned 
					outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle(`lab') nocons drop(female $controls e2)
					
					svyset [pw=w_sampling_e], strata(district) psu(group_endline)
					
					}
				
				foreach y in bizasset_val_real_p99 skilledtrade7da_zero profits4w_real_p99 wealthindex {
					
					svy: reg `y'_e female $controls assigned  if e2==1
					outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle(`lab') nocons drop(female $controls e2) 
					
					svy: reg `y'_e female $controls assigned  if age>15 & age<36 & e2==1
					outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle(`lab') nocons drop(female $controls e2) 
					
					svyset [pw=pop_weight1], strata(district) psu(group_endline)
					svy: reg `y'_e female $controls assigned if e2==1
					outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle(`lab') nocons drop(female $controls e2) 
					
					svyset [pw=w_sampling_e], strata(district) psu(group_endline)
					svy: reg `y'_e female $controls assigned  if age>17 & age<31 & e2==1
					outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle(`lab') nocons drop(female $controls e2)
					
					svyset [pw=pop_weight2], strata(district) psu(group_endline)
					svy: reg `y'_e female $controls assigned if e2==1
					outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle(`lab') nocons drop(female $controls e2)
					
					svyset [pw=w_sampling_e], strata(district) psu(group_endline)
					
					}	
					
	// 4.4 APPENDIX TABLE 4: CORRELATES OF NON-COMPLIANCE
	
					gl table compliance
							cap erase $table.xml
							cap erase $table.txt 
							
						gen not_treated=.
						replace not_treated=1 if treated==0
						replace not_treated=0 if treated==1
						
						cap bysort groupid: egen count=rank(partid) if e1==1

							foreach x in age female urban ind_found_b risk_aversion $H $K $E {
								local lab: var label `x'
								bysort groupid: egen `x'_gr=mean(`x')
								la var `x'_gr "`lab': group average"
							
							}
						
						gl H_gr "education_gr literate_gr voc_training_gr numeracy_numcorrect_m_gr adl_gr"
						gl K_gr "wealthindex_gr savings_6mo_p99_gr cash4w_p99_gr loan_100k_gr loan_1mil_gr"
						gl E_gr "lowskill7da_zero_gr lowbus7da_zero_gr skilledtrade7da_zero_gr highskill7da_zero_gr acto7da_zero_gr aghours7da_zero_gr chores7da_zero_gr zero_hours_gr nonag_dummy_gr emplvoc_gr inschool_gr"		
						gl G_gr "admin_cost_us groupsize_est_e grantsize_pp_US_est3 group_existed group_age ingroup_hetero ingroup_dynamic avgdisteduc"

						
						reg not_treated age_gr female_gr urban_gr risk_aversion_gr $H_gr $K_gr $E_gr $G_gr $districts if e1==1 & ind_unfound_b==0 & assigned==1 & count==1, cluster (group_endline)
						testparm age_gr urban_gr risk_aversion_gr $H_gr $K_gr $E_gr $G_gr 
						local Fstatistic = r(F)
						local Pstat = r(p)
						outreg2 using $table.xml, excel append aster(se) ctitle(`lbl') br label addstat(F Statistic, `Fstatistic', P stat, `Pstat')
						
					gl table complianceb
								cap erase $table.xml
								cap erase $table.txt
						
						cap matrix drop E	
								
								foreach x in age_gr female_gr urban_gr risk_aversion_gr $H_gr $K_gr $E_gr $G_gr {
								
									sum `x' [iw=w_sampling_e] if assigned==1 & e1==1 & ind_unfound_b==0 & count==1
									sca sd=r(sd)
									
									matrix E=nullmat(E)\(sd)
							}	
								
							local cnames `" "Standard Deviation" "'
							local rname
							foreach x in  age_gr female_gr urban_gr risk_aversion_gr $H_gr $K_gr $E_gr $G_gr {
								local lbl : variable label `x'
								local rname `" `rname' "`lbl'" "'
							}	
								
							xml_tab E, save("$table.xml") replace noisily cnames(`cnames') rnames(`rname') font("Times New Roman" 10) format((SCLR0) (SCCR0 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2))
	
	
	// 4.5 APPENDIX TABLE 5: DESCRIPTIVE STATISTICS AND SIMPLE ITT EFFECTS
	
			gl table tableA5a
			cap erase $table.xml
			cap erase $table.txt
	
		cap matrix drop E
		
		gl outcomes "$outcomes_transfer $outcomes_invest $outcomes_work $outcomes_income $outcomes_migrate $outcomes_formalize $outcomes_other"
				
	 		sum treated if e1==1
				sca obs_e = r(N)

	 		sum treated if e1==1 & assigned==0
				sca c_mu_e = r(mean)
				
		
			sum treated if e1==1 & assigned==1
				sca c_mu_e2 = r(mean)
				
			
	 		sum treated if e2==1
				sca obs_e2 = r(N)

			sum treated if e2==1 & assigned==0
				sca c_mu_e3 = r(mean)
				
				
			sum treated if e2==1 & assigned==1
				sca c_mu_e4 = r(mean)
				
			
			matrix E=nullmat(E)\(c_mu_e, c_mu_e2, obs_e, c_mu_e3, c_mu_e4, obs_e2)
					
					
		foreach x in $outcomes {
		
			sca placeholder = 0
		
	 		sum `x'_e [iw=w_sampling_e] if e1==1
				sca obs_e = r(N)

	 		sum `x'_e [iw=w_sampling_e] if e1==1 & assigned==0
				sca c_mu_e = r(mean)
		
			sum `x'_e [iw=w_sampling_e] if e1==1 & assigned==1
				sca c_mu_e2 = r(mean)
			
	 		sum `x'_e [iw=w_sampling_e] if e2==1
				sca obs_e2 = r(N)

			sum `x'_e [iw=w_sampling_e] if e2==1 & assigned==0
				sca c_mu_e3 = r(mean)
				
			sum `x'_e [iw=w_sampling_e] if e2==1 & assigned==1
				sca c_mu_e4 = r(mean)
			
			matrix E=nullmat(E)\(c_mu_e, c_mu_e2, obs_e, c_mu_e3, c_mu_e4, obs_e2)
					
		}	
			
		local cnames `" "Control Mean" "Treatment Mean"  "Obs" "Control Mean"  "Treatment Mean"  "Obs" "'
		local rname
		foreach x in treated $outcomes {
			local lbl : variable label `x'_e
			local rname `" `rname' "`lbl'" "'
		}	
			
		xml_tab E, save("$table.xml") replace noisily cnames(`cnames') rnames(`rname') font("Times New Roman" 11) format((SCLR0) (SCCR0 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2))
		 
		 
		gl table tableA5b
			cap erase $table.xml
			cap erase $table.txt
		
		regress treated assigned female $districts if e1==1, cluster(groupid)
		outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle ("Treated") nocons drop(female $controls) 				

		foreach e in e1 e2 { 
			foreach y in $outcomes { 
				local lab : var label `y'_e
				di "`lab', `e'" 
				cap svy: regress `y'_e assigned female $districts if `e'==1
				cap outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle (`lab') nocons drop(female $controls) 				
				}
			}

	
	
	
	
	// 4.6 APPENDIX TABLE 6: TRAINING INCIDENCE AND HOURS
	
		gl table TableA6
			cap erase $table.xml
			cap erase $table.txt
		 
		cap matrix drop E 
				
		foreach x in tailoring carpentry metalwork salon busmanagment repair mechanic brick farm other notrain {
		
			qui sum train_`x'_e [iw=w_sampling_e] if assigned==1
			scalar `x'1 = r(mean)	
			
			qui sum train_`x'_e [iw=w_sampling_e] if assigned==0
			scalar `x'2 = r(mean)
			
			qui sum train_`x'_e [iw=w_sampling_e] if assigned==1 & any_training_16_e==1
			scalar `x'3 = r(mean)	
			
			qui sum train_`x'_e [iw=w_sampling_e] if assigned==0 & any_training_16_e==1
			scalar `x'4 = r(mean)
			
			qui sum train_`x'_e [iw=w_sampling_e] if assigned==1 & female==0 & any_training_16_e==1
			scalar `x'5 = r(mean)	
			
			qui sum train_`x'_e [iw=w_sampling_e] if assigned==0 & female==0 & any_training_16_e==1
			scalar `x'6 = r(mean)
		
			qui sum train_`x'_e [iw=w_sampling_e] if assigned==1 & female==1 & any_training_16_e==1
			scalar `x'7 = r(mean)	
			
			qui sum train_`x'_e [iw=w_sampling_e] if assigned==0 & female==1 & any_training_16_e==1
			scalar `x'8 = r(mean)
		 
			qui sum hours_`x'_e [iw=w_sampling_e] if assigned==1 & any_training_16_e==1
			scalar `x'9 = r(mean)
			
			qui sum hours_`x'_e [iw=w_sampling_e] if assigned==0 & any_training_16_e==1
			scalar `x'10 = r(mean)	
			
			qui sum hours_`x'_e [iw=w_sampling_e] if assigned==1 & any_training_16_e==1 & female==0
			scalar `x'11 = r(mean)
			
			qui sum hours_`x'_e [iw=w_sampling_e] if assigned==0 & any_training_16_e==1 & female==0
			scalar `x'12 = r(mean)	
			
			qui sum hours_`x'_e [iw=w_sampling_e] if assigned==1 & any_training_16_e==1 & female==1
			scalar `x'13 = r(mean)
			
			qui sum hours_`x'_e [iw=w_sampling_e] if assigned==0 & any_training_16_e==1 & female==1
			scalar `x'14 = r(mean)	
			
			matrix E = nullmat(E)\( `x'1, `x'2, `x'3, `x'4, `x'5, `x'6, `x'7, `x'8, `x'9, `x'10, `x'11, `x'12, `x'13, `x'14)
		}
		
		local ceq `" "Incidence(All)" "Incidence(All)" "Incidence(Any Training)" "Incidence(Any Training)" "Incidence(Male Any Training)" "Incidence(Male Any Training)" "Incidence(Female Any Training)" "Incidence(Female Any Training)" "Hours" "Hours" "Hours - male" "Hours - male" "Hours - female" "Hours - female"  "'
		local cnames `" "Treatment" "Control" "Treatment" "Control" "Treatment" "Control" "Treatment" "Control" "Treatment" "Control" "Treatment" "Control" "Treatment" "Control" "'
		local rnames `" "Tailoring" "Carpentry" "Metal Work" "Salon" "Business & Management" "Repairs" "Mechanic" "Brick" "Farm" "Other" "No training" "'

		xml_tab E, save("$table.xml") replace noisily cnames(`cnames') rnames(`rnames') ceq(`ceq') showeq line(0 2, -1 2) font("Times New Roman" 11) ///
		format((SCLR0) (SCCR0 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2))
	
	
	// 4.7 APPENDIX TABLE 7: RETURNS BY TRADE
		
						gl table ProfitsbyTrade
							cap erase $table.xml
							cap erase $table.txt
						 
						cap matrix drop E 
						
						foreach x in brick beekeep bike shoe carp bore weave metal tailor saloon {
						
						gen `x'profit4w_p99_e=`x'profit4w_e
						qui sum `x'profit4w_e, d
						replace `x'profit4w_p99_e=r(p99) if `x'profit4w_p99_e>r(p99) & `x'profit4w_p99_e!=.
						replace `x'profit4w_p99_e=`x'profit4w_p99_e/1000
						
						}
						
						foreach x in brick beekeep bike shoe carp bore weave metal tailor saloon {
						
							qui sum `x'profit4w_p99_e if treated==1 & e2==1, d
							scalar `x'_mean = r(mean)
							scalar `x'_median = r(p50)
							scalar `x'_stddev = r(sd)
							scalar `x'_N = r(N)		
						
							qui sum `x'profit4w_p99_e if female==0 & treated==1 & e2==1 , d
							scalar `x'_mean_m = r(mean)
							scalar `x'_median_m = r(p50)
							scalar `x'_stddev_m = r(sd)
							scalar `x'_N_m = r(N)
							
						
							qui sum `x'profit4w_p99_e if female==1 & treated==1 & e2==1 , d
							scalar `x'_mean_f = r(mean)
							scalar `x'_median_f = r(p50)
							scalar `x'_stddev_f = r(sd)
							scalar `x'_N_f = r(N)
							
							matrix E = nullmat(E)\( `x'_mean, `x'_median,`x'_stddev, `x'_N, `x'_mean_m, `x'_median_m,`x'_stddev_m, `x'_N_m, `x'_mean_f, `x'_median_f,`x'_stddev_f, `x'_N_f )
							
							}
							
						local ceq `" "All" "All" "All" "All" "Male" "Male" "Male" "Male" "Female" "Female" "Female" "Female" "'
						local cnames `" "Mean" "Median" "Std. Dev" "N" "Mean" "Median" "Std. Dev" "N" "Mean" "Median" "Std. Dev" "N" "'
						local rnames `" "Brick" "Bee-Keeping" "Bike Repair" "Shoe Repair" "Carpentry" "Borehole Repair" "Weaving" "Metal Fabrication" "Tailoring" "Hair Salon" "'
						
						xml_tab E, save("$table.xml") replace noisily cnames(`cnames') rnames(`rnames') ceq(`ceq') showeq line(0 2, -1 2) font("Times New Roman" 11) ///
						format((SCLR0) (SCCR0 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2))
						
					/// Profits by Trade -- zeros excluded


						gl table ProfitsbyTrade_zeros
							cap erase $table.xml
							cap erase $table.txt
						 
						cap matrix drop E 
						
						foreach x in brick beekeep bike shoe carp bore weave metal tailor saloon {
						
							qui sum `x'profit4w_p99_e if treated==1 & `x'profit4w_p99_e>0 & e2==1 , d
							scalar `x'_mean = r(mean)
							scalar `x'_median = r(p50)
							scalar `x'_stddev = r(sd)
							scalar `x'_N = r(N)		
						
							qui sum `x'profit4w_p99_e if female==0 & treated==1 & `x'profit4w_p99_e>0 & e2==1, d
							scalar `x'_mean_m = r(mean)
							scalar `x'_median_m = r(p50)
							scalar `x'_stddev_m = r(sd)
							scalar `x'_N_m = r(N)
							
						
							qui sum `x'profit4w_p99_e if female==1 & treated==1 & `x'profit4w_p99_e>0 & e2==1, d
							scalar `x'_mean_f = r(mean)
							scalar `x'_median_f = r(p50)
							scalar `x'_stddev_f = r(sd)
							scalar `x'_N_f = r(N)
							
							matrix E = nullmat(E)\( `x'_mean, `x'_median,`x'_stddev, `x'_N, `x'_mean_m, `x'_median_m,`x'_stddev_m, `x'_N_m, `x'_mean_f, `x'_median_f,`x'_stddev_f, `x'_N_f )
							
							}
							
						local ceq `" "All" "All" "All" "All" "Male" "Male" "Male" "Male" "Female" "Female" "Female" "Female" "'
						local cnames `" "Mean" "Median" "Std. Dev" "N" "Mean" "Median" "Std. Dev" "N" "Mean" "Median" "Std. Dev" "N" "'
						local rnames `" "Brick" "Bee-Keeping" "Bike Repair" "Shoe Repair" "Carpentry" "Borehole Repair" "Weaving" "Metal Fabrication" "Tailoring" "Hair Salon" "'
						
						xml_tab E, save("$table.xml") replace noisily cnames(`cnames') rnames(`rnames') ceq(`ceq') showeq line(0 2, -1 2) font("Times New Roman" 11) ///
						format((SCLR0) (SCCR0 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2))
						
					//// Average wage from each trade
					
						foreach x in brick beekeep bike shoe carp bore weave metal tailor saloon {
						
						gen `x'wage4w_e=`x'profit4w_p99_e/`x'4whrs_e
						 
						}
						
						gl table WagesbyTrade
							cap erase $table.xml
							cap erase $table.txt
						 
						cap matrix drop E 
						
						
						foreach x in brick beekeep bike shoe carp bore weave metal tailor saloon {
						
							qui sum `x'wage4w_e if treated==1 & e2==1, d
							scalar `x'_mean = r(mean)
							scalar `x'_median = r(p50)
							scalar `x'_stddev = r(sd)
							scalar `x'_N = r(N)		
						
							qui sum `x'wage4w_e if female==0 & treated==1 & e2==1 , d
							scalar `x'_mean_m = r(mean)
							scalar `x'_median_m = r(p50)
							scalar `x'_stddev_m = r(sd)
							scalar `x'_N_m = r(N)
							
						
							qui sum `x'wage4w_e if female==1 & treated==1 & e2==1 , d
							scalar `x'_mean_f = r(mean)
							scalar `x'_median_f = r(p50)
							scalar `x'_stddev_f = r(sd)
							scalar `x'_N_f = r(N)
							
							matrix E = nullmat(E)\( `x'_mean, `x'_median,`x'_stddev, `x'_N, `x'_mean_m, `x'_median_m,`x'_stddev_m, `x'_N_m, `x'_mean_f, `x'_median_f,`x'_stddev_f, `x'_N_f )
							
							}
							
						local ceq `" "All" "All" "All" "All" "Male" "Male" "Male" "Male" "Female" "Female" "Female" "Female" "'
						local cnames `" "Mean" "Median" "Std. Dev" "N" "Mean" "Median" "Std. Dev" "N" "Mean" "Median" "Std. Dev" "N" "'
						local rnames `" "Brick" "Bee-Keeping" "Bike Repair" "Shoe Repair" "Carpentry" "Borehole Repair" "Weaving" "Metal Fabrication" "Tailoring" "Hair Salon" "'
						
						xml_tab E, save("$table.xml") replace noisily cnames(`cnames') rnames(`rnames') ceq(`ceq') showeq line(0 2, -1 2) font("Times New Roman" 11) ///
						format((SCLR0) (SCCR0 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2))
						
					/// Wages by Trade -- zeros excluded


						gl table WagesbyTrade_zeros
							cap erase $table.xml
							cap erase $table.txt
						 
						cap matrix drop E 
						
						foreach x in brick beekeep bike shoe carp bore weave metal tailor saloon {
						
							qui sum `x'wage4w_e if treated==1 & `x'profit4w_p99_e>0 & e2==1, d
							scalar `x'_mean = r(mean)
							scalar `x'_median = r(p50)
							scalar `x'_stddev = r(sd)
							scalar `x'_N = r(N)		
						
							qui sum `x'wage4w_e if female==0 & treated==1 & `x'profit4w_p99_e>0 & e2==1, d
							scalar `x'_mean_m = r(mean)
							scalar `x'_median_m = r(p50)
							scalar `x'_stddev_m = r(sd)
							scalar `x'_N_m = r(N)
							
						
							qui sum `x'wage4w_e if female==1 & treated==1 & `x'profit4w_p99_e>0 & e2==1, d
							scalar `x'_mean_f = r(mean)
							scalar `x'_median_f = r(p50)
							scalar `x'_stddev_f = r(sd)
							scalar `x'_N_f = r(N)
							
							matrix E = nullmat(E)\( `x'_mean, `x'_median,`x'_stddev, `x'_N, `x'_mean_m, `x'_median_m,`x'_stddev_m, `x'_N_m, `x'_mean_f, `x'_median_f,`x'_stddev_f, `x'_N_f )
							
							}
							
						local ceq `" "All" "All" "All" "All" "Male" "Male" "Male" "Male" "Female" "Female" "Female" "Female" "'
						local cnames `" "Mean" "Median" "Std. Dev" "N" "Mean" "Median" "Std. Dev" "N" "Mean" "Median" "Std. Dev" "N" "'
						local rnames `" "Brick" "Bee-Keeping" "Bike Repair" "Shoe Repair" "Carpentry" "Borehole Repair" "Weaving" "Metal Fabrication" "Tailoring" "Hair Salon" "'
						
						xml_tab E, save("$table.xml") replace noisily cnames(`cnames') rnames(`rnames') ceq(`ceq') showeq line(0 2, -1 2) font("Times New Roman" 11) ///
						format((SCLR0) (SCCR0 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2))		
	
	// 4.8 APPENDIX TABLE 8: USING GRANT SIZE PER PERSON AS THE TREATMENT INDICATOR
	 
	 	gl table tableA8
			cap erase $table.xml
			cap erase $table.txt
		
		foreach y in bizasset_val_real_p99_e profits4w_real_p99_e wealthindex_e consaggpercap2_p99_e savings_real_p99_e grantsize_pp_est1a { 
		
			gen s_`y'=`y'
			sum `y' , d
			replace s_`y'=(`y'-r(mean))/r(sd) if `y'!=.
			 
			 }
		
		foreach y in bizasset_val_real_p99 profits4w_real_p99 wealthindex consaggpercap2_p99 savings_real_p99 { 
		
					local lab : var label s_`y'_e
				 			 
					// Observation Number with no weight 
						reg s_`y'_e s_grantsize_pp_est1a female e2 S_H S_K $districts $ctrl_indiv if treated==1 
						local obs = e(N)
	 
						svy: reg s_`y'_e s_grantsize_pp_est1a female e2 S_H S_K $districts $ctrl_indiv if treated==1
						outreg2 using $table.xls, excel aster(se) bdec(4) br label ctitle (`lab') nocons drop ($districts $ctrl_indiv) addstat(Obs, `obs') noobs addn("Robust standard errors in brackets, clustered by group and stratified by district Omitted regressors include an age quartic, district indicators, and baseline measures of employmnet and human and working capital")
					
					}	
 
		foreach y in bizasset_val_real_p99_e profits4w_real_p99_e wealthindex_e consaggpercap2_p99_e savings_real_p99_e grantsize_pp_est1a { 
			
			drop s_`y'
		
		}
	
 // 4.9 APPENDIX TABLE 9: EXTENDED SENSITIVITY 
	
						// ALTERNATE MODELS
							
							gl table tableA9
								cap erase $table.xls
								cap erase $table.txt
								
							foreach y in voc_training training_hours bizasset_val_real_p99 consumption_real_p99_z wealthladder aghours7da_zero nonaghours7da_zero {
								
								local lab: var label `y'_e
								
								foreach n in 1 2 {
										
									// 1 Main specification
										cap qui svy: reg `y'_e female $controls assigned if e`n'==1
											cap outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle(`lab') nocons drop(female $controls) 
							
									// 2 No control vector other than strata FE	
										cap qui svy: reg `y'_e $districts assigned if e`n'==1
											cap outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle(`lab') nocons drop($districts) 
									
									// 3 Diff-in-diff with controls
										cap qui svy: reg `y'_diff_e female $ctrl_indiv $H $G lsavings loan_100k loan_1mil aghours7da_zero chores7da_zero zero_hours nonag_dummy inschool assigned if e`n'==1
											cap outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle(`lab') nocons drop(female $ctrl_indiv $H $G lsavings loan_100k loan_1mil aghours7da_zero chores7da_zero zero_hours nonag_dummy trade_dummy inschool) 
							
									// 4 TOT with controls
										cap qui svy: ivregress 2sls `y'_e $controls (treated=assigned) if e`n'==1
											cap outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle(`lab') nocons drop(female $controls) 

								}
								}
											
							// BOUNDING EXERCISE FOR AVERAGE TREATMENT EFFECTS

								gl table tableA9b_e1
									cap erase $table.xml
									cap erase $table.txt
									
								gl title "Mean standarized treatment effects under varying missing data assumptions"
							
								gl bounding "voc_training_e training_hours_e bizasset_val_real_p99_e wealthladder_e aghours7da_zero_e nonaghours7da_zero_e"
							
							foreach x in e1 {
							
								foreach g in bounding {
									capture matrix drop `g'
						
										foreach var in $`g' {
										
											capture matrix drop `var'
										
											// 1. +/1 0.1 SD 
												gen `var'l10_`x' = `var'
												
													sum `var' if assigned==0 & `var'!=. & `x'==1, d
														replace `var'l10_`x' = r(mean) + 0.1*r(sd) if ind_unfound_`x'==1 & assigned==0 & `x'==1
												
													sum `var' if assigned==1 &`var'!=. & `x'==1, d
														replace `var'l10_`x' = r(mean) - 0.1*r(sd) if ind_unfound_`x'==1 & assigned==1 & `x'==1			
											
											// 2. +/- .25 SD 
												gen `var'l25_`x' = `var'
												
													sum `var' if assigned==0 & `var'!=. & `x'==1, d
														replace `var'l25_`x' = r(mean) + 0.25*r(sd) if ind_unfound_`x'==1 & assigned==0 & `x'==1
												
													sum `var' if assigned==1 &`var'!=. & `x'==1, d
														replace `var'l25_`x' = r(mean) - 0.25*r(sd) if ind_unfound_`x'==1 & assigned==1 & `x'==1

											// 3. +/- 0.5 SD
												gen `var'l5_`x' = `var'
												
													sum `var' if assigned==0 & `var'!=. & `x'==1, d
														replace `var'l5_`x' = r(mean) + 0.5*r(sd) if ind_unfound_`x'==1 & assigned==0 & `x'==1
												
													sum `var' if assigned==1 &`var'!=. & `x'==1, d
														replace `var'l5_`x' = r(mean) - 0.5*r(sd) if ind_unfound_`x'==1 & assigned==1 & `x'==1
																							
											// 4. +/- 1.0 SD
												gen `var'l1_`x'= `var'
												
													sum `var' if assigned==0 &`var'!=. & `x'==1, d
														replace `var'l1_`x' = r(mean) + r(sd) if ind_unfound_`x'==1 & assigned==0 & `x'==1
												
													sum `var' if assigned==1 & `var'!=. & `x'==1, d
														replace `var'l1_`x' = r(mean) - r(sd) if ind_unfound_`x'==1 & assigned==1 & `x'==1
											
											// 5. Lower Manski Bound
												gen `var'lmm_`x' = 	`var'
												
													sum `var' if assigned==0 &`var'!=. & `x'==1, d
														replace `var'lmm_`x' = r(max) if ind_unfound_`x'==1 & assigned==0 &`x'==1
												
													sum `var' if assigned==1 &`var'!=. & `x'==1, d
														replace `var'lmm_`x' = r(min) if ind_unfound_`x'==1 & assigned==1 &`x'==1
										
											foreach z in l10 l25 l5 l1 lmm { 
												
												sum `var'`z'_`x' [iw=w_sampling_e] if assigned==0 & `x'==1
													local `var'`z'mean = r(mean)
													display ``var'`z'mean'
												
												qui svy: reg `var'`z'_`x' female $controls assigned if `x'==1
													
													local obs`z' = e(N)
														display `obs`z''
														
													local treated`z'coeff = _b[assigned]
														display `treated`z'coeff'
														
													local treated`z'perc = _b[assigned]/``var'`z'mean'
														display `treated`z'perc'	
														
													local treated`z'se = _se[assigned]
														display `treated`z'se'
												
													qui testparm assigned
													local treated`z'pstat = r(p)
														
												matrix mat`var's = (`treated`z'coeff' \ `treated`z'se' \ `treated`z'perc'\ `treated`z'pstat' \ `obs`z'')
													matrix list mat`var's
												
												matrix `var' = nullmat(`var'), mat`var's
													matrix list `var'
													
												cap drop `var'`z'
											}
										
										// Big matrix
											matrix `g' = (nullmat(`g') \ `var')
												matrix list `g'
												
											local lbl : variable label `var'
											local rname `" `rname' "`lbl'" "'
											local rname `" `rname' "se" "% Change" "pstat" "Obs" "'
											display `rname'		
						
									
										}	
										
									// Set colum names
										local cnames `" "Lower 0.1 SD" "Lower 0.25 SD" "Lower 0.5 SD" "Lower 1 SD" "Lower Manski" "'	
												
									// Save table	
										xml_tab `g', save("$table.xml") cnames(`cnames') rnames(`rname') replace
								}
						}	
						
						// BOUNDING EXERCISE FOR AVERAGE TREATMENT EFFECTS

													gl table tableA9b_e2
														cap erase $table.xml
														cap erase $table.txt
														
													gl title "Mean standarized treatment effects under varying missing data assumptions"
												
													gl bounding "bizasset_val_real_p99_e consumption_real_p99_z_e wealthladder_e aghours7da_zero_e nonaghours7da_zero_e"
												
												foreach x in e2 {
												
													foreach g in bounding {
														capture matrix drop `g'
											
															foreach var in $`g' {
															
																capture matrix drop `var'
															
																// 1. +/1 0.1 SD 
																	gen `var'l10_`x' = `var'
																	
																		sum `var' if assigned==0 & `var'!=. & `x'==1, d
																			replace `var'l10_`x' = r(mean) + 0.1*r(sd) if ind_unfound_`x'==1 & assigned==0 & `x'==1
																	
																		sum `var' if assigned==1 &`var'!=. & `x'==1, d
																			replace `var'l10_`x' = r(mean) - 0.1*r(sd) if ind_unfound_`x'==1 & assigned==1 & `x'==1			
																
																// 2. +/- .25 SD 
																	gen `var'l25_`x' = `var'
																	
																		sum `var' if assigned==0 & `var'!=. & `x'==1, d
																			replace `var'l25_`x' = r(mean) + 0.25*r(sd) if ind_unfound_`x'==1 & assigned==0 & `x'==1
																	
																		sum `var' if assigned==1 &`var'!=. & `x'==1, d
																			replace `var'l25_`x' = r(mean) - 0.25*r(sd) if ind_unfound_`x'==1 & assigned==1 & `x'==1

																// 3. +/- 0.5 SD
																	gen `var'l5_`x' = `var'
																	
																		sum `var' if assigned==0 & `var'!=. & `x'==1, d
																			replace `var'l5_`x' = r(mean) + 0.5*r(sd) if ind_unfound_`x'==1 & assigned==0 & `x'==1
																	
																		sum `var' if assigned==1 &`var'!=. & `x'==1, d
																			replace `var'l5_`x' = r(mean) - 0.5*r(sd) if ind_unfound_`x'==1 & assigned==1 & `x'==1
																												
																// 4. +/- 1.0 SD
																	gen `var'l1_`x'= `var'
																	
																		sum `var' if assigned==0 &`var'!=. & `x'==1, d
																			replace `var'l1_`x' = r(mean) + r(sd) if ind_unfound_`x'==1 & assigned==0 & `x'==1
																	
																		sum `var' if assigned==1 & `var'!=. & `x'==1, d
																			replace `var'l1_`x' = r(mean) - r(sd) if ind_unfound_`x'==1 & assigned==1 & `x'==1
																
																// 5. Lower Manski Bound
																	gen `var'lmm_`x' = 	`var'
																	
																		sum `var' if assigned==0 &`var'!=. & `x'==1, d
																			replace `var'lmm_`x' = r(max) if ind_unfound_`x'==1 & assigned==0 &`x'==1
																	
																		sum `var' if assigned==1 &`var'!=. & `x'==1, d
																			replace `var'lmm_`x' = r(min) if ind_unfound_`x'==1 & assigned==1 &`x'==1
															
																foreach z in l10 l25 l5 l1 lmm { 
																	
																	sum `var'`z'_`x' [iw=w_sampling_e] if assigned==0 & `x'==1
																		local `var'`z'mean = r(mean)
																		display ``var'`z'mean'
																	
																	qui svy: reg `var'`z'_`x' female $controls assigned if `x'==1
																		
																		local obs`z' = e(N)
																			display `obs`z''
																			
																		local treated`z'coeff = _b[assigned]
																			display `treated`z'coeff'
																			
																		local treated`z'perc = _b[assigned]/``var'`z'mean'
																			display `treated`z'perc'	
																			
																		local treated`z'se = _se[assigned]
																			display `treated`z'se'
																	
																		qui testparm assigned
																		local treated`z'pstat = r(p)
																			
																	matrix mat`var's = (`treated`z'coeff' \ `treated`z'se' \ `treated`z'perc'\ `treated`z'pstat' \ `obs`z'')
																		matrix list mat`var's
																	
																	matrix `var' = nullmat(`var'), mat`var's
																		matrix list `var'
																		
																	cap drop `var'`z'
																}
															
															// Big matrix
																matrix `g' = (nullmat(`g') \ `var')
																	matrix list `g'
																	
																local lbl : variable label `var'
																local rname `" `rname' "`lbl'" "'
																local rname `" `rname' "se" "% Change" "pstat" "Obs" "'
																display `rname'		
											
														
															}	
															
														// Set colum names
															local cnames `" "Lower 0.1 SD" "Lower 0.25 SD" "Lower 0.5 SD" "Lower 1 SD" "Lower Manski" "'	
																	
														// Save table	
															xml_tab `g', save("$table.xml") cnames(`cnames') rnames(`rname') replace
													}
											}	 
	
	// 4.10 APPENDIX TABLE 10: SOCIAL OUTCOMES
	
					gl tableA9_1 "hhcaring_resc fam_disp_resc live_together helpelders_resc groups_capped comm_meet comm_mblzr comm_leader madespeech agg_quarrelsome agg_take agg_curse agg_threaten neigh_disp commlead_disp pol_disp fight_disp "
					gl tableA9_2 "cclcommeet12m_resc rcaraiseissue12m_dum cpgroad12m_dum cpgwater12m_dum cpgbldgoth12m_dum cpgschl12m_dum cpglatrine12m_dum cpgoth12m_dum cpgfuneral12m_dum "
					gl tableA9_3 "wbyelled_resc wbreactedanger_resc wbfrustrateang_resc wbdamagemad_resc wbnowantang_resc wbangrythreat_resc wbhittinggood_resc wbhitdefend_resc wbdamagefun_resc wbforcewant_resc wbforcemoney_resc wbgangothers_resc wbweaponfight_resc wbyelledtodo_resc"
					
					**ATE values***
						 
						gl table tableA10
							cap erase $table.xml
							cap erase $table.txt
						
						foreach e in e1 e2 { 
							foreach y in $tableA9_1 $tableA9_2 $tableA9_3 { 
								local lab : var label `y'_e
								di "`lab', `e'" 
								cap svy: regress `y'_e assigned female $controls if `e'==1
								cap outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle (`lab') nocons drop(female $controls) 				
								}
							}	
	
	
	// 4.11 APPENDIX TABLE 11: AGGRESSION HETEROGENEITY
							
					// Heterogeneity using baseline aggression

							gl table Agg_Het1
							cap erase $table.xml
							cap erase $table.txt


						* Anti-social behavior
							ivregress 2sls aggression_n_e aggression_n $ctrl_indiv $districts (treated T_aggression_n = assigned A_aggression_n) if e2==0 & female==0 [pw=w_sampling_e], cluster(group_endline)
								 outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle("E1 Male") nocons drop (district_* $ctrl_indiv) addn("Robust standard errors in brackets, clustered by group")
					
							ivregress 2sls aggression_n_e aggression_n $ctrl_indiv $districts (treated T_aggression_n = assigned A_aggression_n) if e2==0 & female==1 [pw=w_sampling_e], cluster(group_endline)
								 outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle("E1 Female") nocons drop (district_* $ctrl_indiv) addn("Robust standard errors in brackets, clustered by group")
					
							ivregress 2sls aggression_n_e aggression_n $ctrl_indiv $districts (treated T_aggression_n = assigned A_aggression_n) if e2==1 & female==0 [pw=w_sampling_e], cluster(group_endline)
								 outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle("E2 Male") nocons drop (district_* $ctrl_indiv) addn("Robust standard errors in brackets, clustered by group")
					
							ivregress 2sls aggression_n_e aggression_n $ctrl_indiv $districts (treated T_aggression_n = assigned A_aggression_n) if e2==1 & female==1 [pw=w_sampling_e], cluster(group_endline)
									 outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle("E2 Female") nocons drop (district_* $ctrl_indiv) addn("Robust standard errors in brackets, clustered by group")
					
						* Anti-social behavior, extended
							ivregress 2sls aggression_e2_n_e aggression_n $ctrl_indiv $districts (treated T_aggression_n = assigned A_aggression_n) if e2==1 & female==0 [pw=w_sampling_e], cluster(group_endline)
								 outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle("E2 Male") nocons drop (district_* $ctrl_indiv) addn("Robust standard errors in brackets, clustered by group")
					
							ivregress 2sls aggression_e2_n_e aggression_n $ctrl_indiv $districts (treated T_aggression_n = assigned A_aggression_n) if e2==1 & female==1 [pw=w_sampling_e], cluster(group_endline)
									 outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle("E2 Female") nocons drop (district_* $ctrl_indiv) addn("Robust standard errors in brackets, clustered by group")
					
						* Protest attitudes
							ivregress 2sls protest_e2_n_e aggression_n $ctrl_indiv $districts (treated T_aggression_n = assigned A_aggression_n) if e2==1 & female==0 [pw=w_sampling_e], cluster(group_endline)
								 outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle("E2 Male") nocons drop (district_* $ctrl_indiv) addn("Robust standard errors in brackets, clustered by group")
					
							ivregress 2sls protest_e2_n_e aggression_n $ctrl_indiv $districts (treated T_aggression_n = assigned A_aggression_n) if e2==1 & female==1 [pw=w_sampling_e], cluster(group_endline)
									 outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle("E2 Female") nocons drop (district_* $ctrl_indiv) addn("Robust standard errors in brackets, clustered by group")
									 
						* S_K
						
							ivregress 2sls S_K aggression_n $ctrl_indiv $districts (treated T_aggression_n = assigned A_aggression_n) if e1==1 & female==0 [pw=w_sampling_e], cluster(group_endline)
								 outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle("E2 Male") nocons drop (district_* $ctrl_indiv) addn("Robust standard errors in brackets, clustered by group")
					
							ivregress 2sls S_K aggression_n $ctrl_indiv $districts (treated T_aggression_n = assigned A_aggression_n) if e1==1 & female==1 [pw=w_sampling_e], cluster(group_endline)
									 outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle("E2 Female") nocons drop (district_* $ctrl_indiv) addn("Robust standard errors in brackets, clustered by group")


						gl table Agg_Het4
							cap erase $table.xml
							cap erase $table.txt
					
						// Using predicted aggression

						* Anti-social behavior
							ivregress 2sls aggression_n_e A $ctrl_indiv $districts (treated T_A = assigned A_A) if e2==0 & female==0 [pw=w_sampling_e], cluster(group_endline)
								 outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle("E1 Male") nocons drop (district_* $ctrl_indiv) addn("Robust standard errors in brackets, clustered by group")
									lincom treated+T_A
					
							ivregress 2sls aggression_n_e A $ctrl_indiv $districts (treated T_A = assigned A_A) if e2==0 & female==1 [pw=w_sampling_e], cluster(group_endline)
								 outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle("E1 Female") nocons drop (district_* $ctrl_indiv) addn("Robust standard errors in brackets, clustered by group")
										lincom treated+T_A

							ivregress 2sls aggression_n_e A $ctrl_indiv $districts (treated T_A = assigned A_A) if e2==1 & female==0 [pw=w_sampling_e], cluster(group_endline)
								 outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle("E2 Male") nocons drop (district_* $ctrl_indiv) addn("Robust standard errors in brackets, clustered by group")
									lincom treated+T_A
					
							ivregress 2sls aggression_n_e A $ctrl_indiv $districts (treated T_A = assigned A_A) if e2==1 & female==1 [pw=w_sampling_e], cluster(group_endline)
								outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle("E2 Female") nocons drop (district_* $ctrl_indiv) addn("Robust standard errors in brackets, clustered by group")
									lincom treated+T_A
					
						* Anti-social behavior, extended
							ivregress 2sls aggression_e2_n_e A $ctrl_indiv $districts (treated T_A = assigned A_A) if e2==1 & female==0 [pw=w_sampling_e], cluster(group_endline)
								 outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle("E2 Male") nocons drop (district_* $ctrl_indiv) addn("Robust standard errors in brackets, clustered by group")
									lincom treated+T_A
					
							ivregress 2sls aggression_e2_n_e A $ctrl_indiv $districts (treated T_A = assigned A_A) if e2==1 & female==1 [pw=w_sampling_e], cluster(group_endline)
								outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle("E2 Female") nocons drop (district_* $ctrl_indiv) addn("Robust standard errors in brackets, clustered by group")
									lincom treated+T_A
					
						* Protest attitudes
							ivregress 2sls protest_e2_n_e A $ctrl_indiv $districts (treated T_A = assigned A_A) if e2==1 & female==0 [pw=w_sampling_e], cluster(group_endline)
								 outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle("E2 Male") nocons drop (district_* $ctrl_indiv) addn("Robust standard errors in brackets, clustered by group")
									lincom treated+T_A
					
							ivregress 2sls protest_e2_n_e A $ctrl_indiv $districts (treated T_A = assigned A_A) if e2==1 & female==1 [pw=w_sampling_e], cluster(group_endline)
								outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle("E2 Female") nocons drop (district_* $ctrl_indiv) addn("Robust standard errors in brackets, clustered by group")
									lincom treated+T_A
									
						* S_K
							ivregress 2sls S_K A $ctrl_indiv $districts (treated T_A = assigned A_A) if e1==1 & female==0 [pw=w_sampling_e], cluster(group_endline)
								 outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle("E2 Male") nocons drop (district_* $ctrl_indiv) addn("Robust standard errors in brackets, clustered by group")
									lincom treated+T_A
					
							ivregress 2sls S_K A $ctrl_indiv $districts (treated T_A = assigned A_A) if e1==1 & female==1 [pw=w_sampling_e], cluster(group_endline)
								outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle("E2 Female") nocons drop (district_* $ctrl_indiv) addn("Robust standard errors in brackets, clustered by group")
									lincom treated+T_A


			
	// 4.12 APPENDIX TABLE 12: PATIENCE
	
				gl table tableA12
							cap erase $table.xml
							cap erase $table.txt
					
						cap matrix drop E
						
						
						// Balance on survey characteristics
						
							foreach x in S_P_m $P_e {
								sum `x' if assigned==1 
									sca c_mu = r(mean)
									sca c_v = r(sd)
									sca c_N = r(N)
							
								sum `x' if assigned==0 
									sca d_mu = r(mean)
									sca d_v = r(sd)
									sca d_N = r(N)
									
								qui reg `x' assigned $districts, cluster(group_endline)
									sca b_hat = _b[assigned]
									testparm assigned
									sca pstat = r(p)
									
								matrix E=nullmat(E)\(d_mu, d_v, d_N, c_mu, c_v, c_N, b_hat, pstat)
							}	
								
						local cnames `" "Control Mean" "Control Standard Deviation" "Control Obs" "Treatment Mean" "Treatment Standard Deviation" "Treatment Obs" "Regression difference" "P-Value" "'
						local rname
						foreach x in S_P_m $P_e{
							local lbl : variable label `x'
							local rname `" `rname' "`lbl'" "'
						}	
						
						xml_tab E, save("$table.xml") replace noisily cnames(`cnames') rnames(`rname') font("Times New Roman" 10) format((SCLR0) (SCCR0 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2))

						
						
	// 4.13 APPENDIX TABLE 13: GROUP HETEROGENEITY
	
	
			gl table group_hetero
				cap erase $table.xml
				cap erase $table.txt
				
				foreach y in training_hours bizasset_val_real_p99 profits4w_real_p99 { 
				
					foreach s in e1 e2 { 
			 
					// Skip if the variables doesn't exist in e1 or e2
						sum `y'_e if `s'==1
						local `y'N = r(N) 
										
						if ``y'N' != 0 { 
						
						// Label of dependant variables
							local lab : var label `y'_e
		 
						// Control Mean
							sum `y'_e [iw=w_sampling_e] if assigned==0 & `s'==1
							local Y1mean = r(mean)
						
						// ENDLINE Level terms for treatment group 
				
							* Observation Number with no weight
								reg `y'_e female $controls group_existed ingroup_dynamic group_roster_size group_female ingroup_hetero group_grant_ineq_e group_leader_capture2_e if `s'==1 & assigned==1
								local obs = e(N)
								
							* Regression that we outsheet
								svy: reg `y'_e female $controls group_existed ingroup_dynamic group_roster_size group_female ingroup_hetero group_grant_ineq_e group_leader_capture2_e if `s'==1 & assigned==1
								outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle (`lab') nocons drop (district_* $ctrl_indiv) addstat(Obs, `obs', Control Mean, `Y1mean') noobs addn("Robust standard errors in brackets, clustered by group and stratified by district Omitted regressors include an age quartic, district indicators, and baseline measures of employmnet and human and working capital")
						
						// ENDLINE T+C Full Sample
						 
							* Observation Number with no weight
								qui ivregress 2sls `y'_e assigned female $controls group_existed ingroup_dynamic group_roster_size group_female ingroup_hetero A_group_existed A_ingroup_dynamic A_group_roster_size A_group_female A_ingroup_hetero if `s'==1 
								local obs = e(N)
								
							* Regression that we outsheet	
								svy: ivregress 2sls `y'_e assigned female $controls group_existed ingroup_dynamic group_roster_size group_female ingroup_hetero A_group_existed A_ingroup_dynamic A_group_roster_size A_group_female A_ingroup_hetero if `s'==1 
								outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle (`lab') nocons drop (district_* $ctrl_indiv) addstat(Obs, `obs',	Control Mean, `Y1mean') noobs addn("Robust standard errors in brackets, clustered by group and stratified by district Omitted regressors include an age quartic, district indicators, and baseline measures of employmnet and human and working capital")
						}
					}	
				}		
			 
			 
				foreach y in bizasset_val_real_p99 profits4w_real_p99 {
				
					// Label of dependant variables
							local lab : var label `y'_e
		 
						// Control Mean
							sum `y'_e [iw=w_sampling_e] if assigned==0 
							local Y1mean = r(mean)
						
						// ENDLINE Level terms for treatment group 
				
							* Observation Number with no weight
								reg `y'_e female $controls group_existed ingroup_dynamic group_roster_size group_female ingroup_hetero group_grant_ineq_e group_leader_capture2_e e2 if assigned==1
								local obs = e(N)
								
							* Regression that we outsheet
								svy: reg `y'_e female $controls group_existed ingroup_dynamic group_roster_size group_female ingroup_hetero group_grant_ineq_e group_leader_capture2_e e2 if assigned==1
								outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle (`lab') nocons drop (district_* $ctrl_indiv) addstat(Obs, `obs', Control Mean, `Y1mean') noobs addn("Robust standard errors in brackets, clustered by group and stratified by district Omitted regressors include an age quartic, district indicators, and baseline measures of employmnet and human and working capital")
						
						// ENDLINE T+C Full Sample
						 
							* Observation Number with no weight
								qui regress `y'_e assigned female $controls group_existed ingroup_dynamic group_roster_size group_female ingroup_hetero e2 A_group_existed A_ingroup_dynamic A_group_roster_size A_group_female A_ingroup_hetero assigned_e2 
								local obs = e(N)
								
							* Regression that we outsheet	
								svy: regress  `y'_e assigned female $controls group_existed ingroup_dynamic group_roster_size group_female ingroup_hetero e2 A_group_existed A_ingroup_dynamic A_group_roster_size A_group_female A_ingroup_hetero assigned_e2
								outreg2 using $table.xls, excel aster(se) bdec(3) br label ctitle (`lab') nocons drop (district_* $ctrl_indiv) addstat(Obs, `obs',	Control Mean, `Y1mean') noobs addn("Robust standard errors in brackets, clustered by group and stratified by district Omitted regressors include an age quartic, district indicators, and baseline measures of employmnet and human and working capital")
						}
				

//////////////////////	
// 5.0 SUPPLEMENTARY /
//////////////////////						
						
	// 5.1 TOP PAYERS
	
		gl table toppayer
				cap erase $table.xml
				cap erase $table.txt
				
		reg toppayer_e assigned age urban risk_aversion $H $K $E $G if e2==1 & ind_unfound_b==0, cluster (group_endline)
		outreg2 using $table.xml, excel append aster(se) ctitle(`lbl') br label 
		
							gl table toppayerb
										cap erase $table.xml
										cap erase $table.txt
							
							cap matrix drop E	
							
							foreach x in assigned age urban risk_aversion $H $K $E $G {
							
											sum `x' [iw=w_sampling_e] if  e1==1 & ind_unfound_b==0 
											sca sd=r(sd)
											
										matrix E=nullmat(E)\(sd)
								}	
									
									local cnames `" "Standard Deviation" "'
									local rname
									foreach x in  assigned age urban risk_aversion $H $K $E $G {
										local lbl : variable label `x'
										local rname `" `rname' "`lbl'" "'
									}	
										
							xml_tab E, save("$table.xml") replace noisily cnames(`cnames') rnames(`rname') font("Times New Roman" 10) format((SCLR0) (SCCR0 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2))
		

		
	// 5.2 ADDITIONAL SUMMARY STATISTICS
		
		gl table supplementary
				cap erase $table.xml
				cap erase $table.txt
		
			cap matrix drop E
				
			// Balance on survey characteristics
				
			 		sum savings_6mo_p99 if e1==1 & ind_unfound_b==0, d
						sca mean1 = r(mean)
						sca median1 = r(p50)
						sca obs1= r(N)
					
					sum tot_outloansize_p99 if e1==1 & ind_unfound_b==0, d
						sca mean2 = r(mean)
						sca median2 = r(p50)
						sca obs2 = r(N)
						
					sum savings_6mo_p99 if e1==1 & ind_unfound_b==0 & savings_6mo_p99>0 & savings_6mo_p99!=., d
						sca percent1 = r(N)/obs1 
						sca median3 = r(p50)
					
					sum tot_outloansize_p99 if e1==1 & ind_unfound_b==0 & tot_outloansize_p99>0 & tot_outloansize_p99!=., d 
						sca percent2 = r(N)/obs2
						sca median4 = r(p50)
					
					sum profits4w_p99 if e1==1 & ind_unfound_b==0, d
						sca mean3 = r(mean)
						sca median5 = r(p50)
					
					sum q195 if e1==1 & ind_unfound_b==0, d
						sca mean4 = r(mean)
						
					
		
				 		
					matrix E=nullmat(E)\(mean1, median1, mean2, median2, percent1, percent2, median3, median4, mean3, median5, mean4 )
					
					
			local cnames `" "Average savings" "Median savings" "Average loans" "Median loans" "Percent with positive savings" "Percent with positive loans" "Median for non-zero savings" "Median for non-zero loans" "Mean net monthly profits" "Median net monthly profits" "Percentage of non-combatants"  "'
			local rname
			
			
			xml_tab E, save("$table.xml") replace noisily cnames(`cnames') rnames(`rname') font("Times New Roman" 10) format((SCLR0) (SCCR0 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2 NBCR2))
	
	// 5.3 POPULATION HETEROGENEITY
	
		gl table population_hetero
			cap erase $table.xml
			cap erase $table.txt
	 
		foreach y in bizasset_val_real_p99 profits4w_real_p99 { 
		
			* Label of dependant variables
				local lab : var label `y'_e 
	
				reg `y'_e assigned e2 assigned_e2 female female_e2 $ctrl_indiv $E $G A_yop_prob yop_prob $districts [pw=w_sampling_e], cluster(partid)
					outreg2 using $table.xls, excel aster(se) dec(1) br label ctitle (`lab') nocons drop ($ctrl_indiv lowskill7da_zero lowbus7da_zero skilledtrade7da_zero highskill7da_zero acto7da_zero aghours7da_zero chores7da_zero zero_hours nonag_dummy inschool $G $districts) 
		
				reg `y'_e assigned e2 assigned_e2 $ctrl_indiv $E $G  A_yop_prob yop_prob $districts [pw=w_sampling_e] if female==0, cluster(partid)
					outreg2 using $table.xls, excel aster(se) dec(1) br label ctitle (`lab') nocons drop ($ctrl_indiv lowskill7da_zero lowbus7da_zero skilledtrade7da_zero highskill7da_zero acto7da_zero aghours7da_zero chores7da_zero zero_hours nonag_dummy inschool $G $districts) 
	
				reg `y'_e assigned e2 assigned_e2 $ctrl_indiv $E $G A_yop_prob yop_prob $districts [pw=w_sampling_e] if female==1, cluster(partid)
					outreg2 using $table.xls, excel aster(se) dec(1) br label ctitle (`lab') nocons drop ($ctrl_indiv lowskill7da_zero lowbus7da_zero skilledtrade7da_zero highskill7da_zero acto7da_zero aghours7da_zero chores7da_zero zero_hours nonag_dummy inschool $G $districts) 
		
				}	
				
	// 5.4 CORRELATES OF DROPPED FROM TRACKING

			gl table dropped
					cap erase $table.xml
					cap erase $table.txt 
			
			reg phase2_notrack_e1 assigned admin_cost_us groupsize_est_e grantsize_pp_US_est3 group_existed group_age ingroup_hetero ingroup_dynamic avgdisteduc age urban risk_aversion grp_leader grp_chair  $E $H $K $districts if e1==1 & ind_unfound_p1_e1==1, cluster(group_endline)
				testparm assigned admin_cost_us groupsize_est_e grantsize_pp_US_est3 group_existed group_age ingroup_hetero ingroup_dynamic avgdisteduc age urban risk_aversion grp_leader grp_chair  $E $H $K 
				local Fstatistic = r(F)
				local Pstat = r(p)
			outreg2 using $table.xml, excel append aster(se) ctitle(`lbl') br label addstat(F Statistic, `Fstatistic', P stat, `Pstat')
			
			reg phase2_notrack_e2 assigned admin_cost_us groupsize_est_e grantsize_pp_US_est3 group_existed group_age ingroup_hetero ingroup_dynamic avgdisteduc age urban risk_aversion grp_leader grp_chair  $E $H $K $districts if e2==1 & ind_unfound_p1_e2==1, cluster(group_endline)
			testparm assigned admin_cost_us groupsize_est_e grantsize_pp_US_est3 group_existed group_age ingroup_hetero ingroup_dynamic avgdisteduc age urban risk_aversion grp_leader grp_chair  $E $H $K 
				local Fstatistic = r(F)
				local Pstat = r(p)
			outreg2 using $table.xml, excel append aster(se) ctitle(`lbl') br label addstat(F Statistic, `Fstatistic', P stat, `Pstat')
			
	
********************************************************************************
* Move our working directory back to where the master do-file is located *******
********************************************************************************
/* 	This allows us to continue on with the next steps in the master do file.
*/ 
cd $NUSAF



******************************************************************************** 				
	
