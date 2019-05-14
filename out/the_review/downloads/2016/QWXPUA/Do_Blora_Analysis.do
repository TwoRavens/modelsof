/****************************************************************************
This do file contains all replication code for the paper: 

Laura Paler. 2013. "Keeping the Public Purse: An Experiment in Windfalls, Taxes, and the Incentives to Restrain Government," 
American Political Science Review 107(4): 706-725.

A few things to note:
-Before you can run the user-written command blora_ri you must run the ado file blorasim_ri_embed (see more below). 
-Process to obtain FDR adjusted p-values reported in Table 2 and Table 3 of main text at end of do file (see more below).
-All output is to excel where results were combined and formatted as in the text and exported to Latex.
-See Do_Blora_Figures.do for all figures in the main text and appendix.
*****************************************************************************/


******************************************
*SET DIRECTORIES
******************************************

cd "~/Dropbox/BLORA_TAX_REP_FINAL/"  /// adjust to suit your individual file path

global tables "Tables"
global figures "Figures"
global ri "Randomization_Inference"


clear
use "Data_Blora_Final.dta"  

******************************************
*MACROS YOU WILL NEED
******************************************

	global tax_main_tab2 q147_learnmore_apbd_REC2 q146_learnmore_govt_REC2 q145_scrutinize_REC2 pol_act_tot POST votefor_1 votefor_3 GOODGOV 
	global tax_mech_tab3 q119_winmore_REC5 tax_share2 windfall_share2 q121_owns_apbd_REC2 q122_apbd_relevant_REC2 q142_satis_apbd_REC2 q144_trust_bupati_REC2 q144_trust_dprd_REC2 q123_power_REC2 
	global tax_extra     q141_performance_REC2 q120_avoidloss_REC5 q143_satis_govt_REC2

	local controls age sex q31_marital_REC2 highed q34_newspaper_REC1 numlevel q37_work_REC2 tot_mailbox_min3 paytax q51_tax_whopays_REC2 q53_tax_gowhere_REC2 polaware_level q84_heard_bupati_REC2
	
******************************************
*RUN USER WRITTEN-COMMANDS
******************************************

******************************************
*User-written command for the ATE of the tax treatment
******************************************

capture program drop blora_tax_ate
program blora_tax_ate
version 11.1

        syntax varlist [if]
        marksample touse
        gettoken y  : varlist
        set more off
        preserve
        keep if  `touse'

        est clear
        eststo: mean `y', over(taxgrp)
		qui: estout using "$tables/blora_tax_ate_`y'.xls", cells(b(fmt(2))) replace title(Group Means)
		est clear
		eststo: reg `y' taxgrp, vce(hc2)
		qui: estout using "$tables/blora_tax_ate_`y'.xls", append cells(b(fmt(%9.2f) star) se(par(`"="("'`")""') fmt(%9.2f))) stat(N) starl(* .10 ** .05  *** .01)

restore
end

******************************************
*User-written command for effect of the tax treatment conditional on information
******************************************

capture program drop blora_tax_cate
program blora_tax_cate
version 11.1

        syntax varlist [if]
        marksample touse
        gettoken y  : varlist
        set more off
        preserve
        keep if  `touse'

        est clear
        eststo: mean `y' if infogrp==0, over(taxgrp)
        eststo: mean `y' if infogrp==1, over(taxgrp)
		qui: estout using "$tables/blora_tax_cate_`y'.xls", cells(b(fmt(2))) replace title(Group Means)
		est clear
		eststo: reg `y' taxgrp if infogrp==0, vce(hc2)
        eststo: reg `y' taxgrp if infogrp==1, vce(hc2)
        eststo: reg `y' infogrp if taxgrp==0, vce(hc2)
        eststo: reg `y' infogrp if taxgrp==1, vce(hc2)
		eststo: reg `y' c.taxgrp##i.infogrp, vce(hc2)
		qui: estout using "$tables/blora_tax_cate_`y'.xls", append cells(b(fmt(%9.2f) star) se(par(`"="("'`")""') fmt(%9.2f))) starl(* .10 ** .05  *** .01)  


restore
end

	
/******************************************
*User written command to obtain randomization inference p-values	
*NOTE: 
-Make sure you run blorasim_ri_embed.ado before using the blora_ri command
-blorasim_ri_embed.ado performs one run of randomization inference
-blora_ri then runs blorasim_ri_embed 10,000 times, stores relevant output, and and returns p-values from a two-tailed
	test reflecting the proportion of the randomization distribution that is larger than the observed coefficient on the observed treatment effect.
	It also returns standard errors if you would like to calculate additional test statistics.
	-blora_ri returns 7 p-values as follows:	
	-pv_1_tt is the RI p-value for the effect of the tax treatment in the low info environment
	-pv_2_tt is the RI p-value for the effect of the info treatment in a windfall environment
	-pv_3_tt is the RI p-value for the effect of the info treatment in the tax environment
	-pv_4_tt is the RI p-value for the effect of the tax treatment in the high info environment
	-pv_5_tt is the RI p-value for the ATE of the tax treatment
	-pv_6_tt is the RI p-value for the ATE of the info treatment
	-pv_7_tt is the RI p-value for the interaction of the tax and information treatments
-Replication note: The code provided below was the same code used to produce the RI p-values that appear in the paper. Your
	results may differ slightly from what is reported in the text because of the stochastic process. The original randomization inference results
	are available from the author upon request. 
-When you use the blora_ri command for analysis, it takes a while to produce tbe output (about 90 minutes on a Macbook Pro 2.7 GHz Intel Core 5)
******************************************/

*Run the user-written command blorasim_ri_embed.ado
	do "blorasim_ri_embed.ado"

capture program drop blora_ri
program blora_ri
version 11.1	
	    syntax varlist [if]
        gettoken var : varlist
        set more off
		
		
		preserve
		# delimit ;
				simulate "blorasim_ri_embed `var'" 
				   	b_y_1r=r(b_y_1r) 
					b_y_1=r(b_y_1) 
		    		se_y_1r=r(se_y_1r) 
            		se_y_1=r(se_y_1) 
           
            		b_y_2r=r(b_y_2r) 
            		b_y_2=r(b_y_2) 
		    		se_y_2r=r(se_y_2r) 
            		se_y_2=r(se_y_2) 
                   
            		b_y_3r=r(b_y_3r) 
            		b_y_3=r(b_y_3) 
		    		se_y_3r=r(se_y_3r) 
            		se_y_3=r(se_y_3) 
           
            		b_y_4r=r(b_y_4r) 
            		b_y_4=r(b_y_4) 
		    		se_y_4r=r(se_y_4r) 
            		se_y_4=r(se_y_4) 
           
            		b_y_5r=r(b_y_5r) 
            		b_y_5=r(b_y_5) 
		    		se_y_5r=r(se_y_5r) 
            		se_y_5=r(se_y_5) 
           
		            b_y_6r=r(b_y_6r) 
        		    b_y_6=r(b_y_6) 
		    		se_y_6r=r(se_y_6r) 
            		se_y_6=r(se_y_6) 
            
            		b_y_7r=r(b_y_7r) 
            		b_y_7=r(b_y_7) 
		    		se_y_7r=r(se_y_7r) 
            		se_y_7=r(se_y_7) 
            		
            ,reps(10000) saving("$ri/blorasim_FINAL_`var'.dta") replace every(1000) ;
# delimit cr
			
    foreach num of numlist 1 2 3 4 5 6 7 {
        g pvi_`num'_tt=abs(b_y_`num')>=abs(b_y_`num'r)
        egen pv_`num'_tt=mean(pvi_`num'_tt)
    }

	drop pvi*

	save "$ri/blorasim_FINAL_`var'.dta", replace
			
	
restore
end	
	
	
	

	
		
************************************************************
*TABLE 2
*See the note above on blora_ri before running the command
************************************************************/

*ATE
	blora_tax_ate q147_learnmore_apbd_REC2 
	blora_tax_ate q146_learnmore_govt_REC2	
	blora_tax_ate q145_scrutinize_REC2
	
	blora_tax_ate pol_act_tot
	blora_tax_ate POST

	blora_tax_ate votefor_1
	blora_tax_ate votefor_3 
	blora_tax_ate GOODGOV

	
*RI p-values	
	blora_ri q147_learnmore_apbd_REC2   
	blora_ri q146_learnmore_govt_REC2
	blora_ri q145_scrutinize_REC2
	blora_ri pol_act_tot
	blora_ri POST
	blora_ri votefor_1
	blora_ri votefor_3 
	blora_ri GOODGOV
	
	
************************************************************
*EFFECT OF TAX CONDITONED ON INFO (Tables in Appendix G, corresponds to Figures 3 and 4 in the main text)
*See Blora_Figures for the code that executes the reproduction of Figures 3 and 4
*See the note above on blora_ri before running the command
************************************************************/

*Regressions for Appendix G and Figure 3 in main text
	blora_tax_cate q141_performance_REC2
	blora_tax_cate q142_satis_apbd_REC2
	blora_tax_cate q144_trust_bupati_REC2
	
*Regressions for Appendix G and Figure 4 in main text
	blora_tax_cate q147_learnmore_apbd_REC2
	blora_tax_cate POST
	blora_tax_cate GOODGOV

*Additional regressions in Appendix G not reported in main text
	blora_tax_cate q143_satis_govt_REC2
    blora_tax_cate q144_trust_dprd_REC2  	
	blora_tax_cate q146_learnmore_govt_REC2
	blora_tax_cate q145_scrutinize_REC2
	blora_tax_cate pol_act_tot
	blora_tax_cate votefor_1
	blora_tax_cate votefor_3
	
	
*RI P-VALUES FOR ALL ABOVE
	blora_ri q141_performance_REC2
	blora_ri q142_satis_apbd_REC2
	blora_ri q144_trust_bupati_REC2
	
	blora_ri q147_learnmore_apbd_REC2
	blora_ri POST
	blora_ri GOODGOV

	blora_ri q143_satis_govt_REC2
    blora_ri q144_trust_dprd_REC2  	
	blora_ri q146_learnmore_govt_REC2
	blora_ri q145_scrutinize_REC2
	blora_ri pol_act_tot
	blora_ri votefor_1
	blora_ri votefor_3


************************************************************
*TABLE 3: MECHANISMS
*Note: q120_avoidloss_REC5 does not appear in Table 3 but is discussed in the text
*See the note above on blora_ri before running the command
************************************************************/

*Main specification
	blora_tax_ate q119_winmore_REC5
	blora_tax_ate q120_avoidloss_REC5
	blora_tax_ate tax_share_prior3 
	blora_tax_ate tax_share2
	blora_tax_ate windfall_share2	
	blora_tax_ate q121_owns_apbd_REC2
	blora_tax_ate q122_apbd_relevant_REC2
	blora_tax_ate q142_satis_apbd_REC2
	blora_tax_ate q144_trust_bupati_REC2
	blora_tax_ate q144_trust_dprd_REC2  	
	blora_tax_ate q123_power_REC2

*RI p-value
	blora_ri q119_winmore_REC5
	blora_ri q120_avoidloss_REC5
	blora_ri tax_share_prior3 
	blora_ri tax_share2
	blora_ri windfall_share2
	blora_ri q121_owns_apbd_REC2
	blora_ri q122_apbd_relevant_REC2
	blora_ri q142_satis_apbd_REC2
	blora_ri q144_trust_bupati_REC2
	blora_ri q144_trust_dprd_REC2  	
	blora_ri q123_power_REC2


/************************************************************
*APPENDIX E: RANDOMIZATION CHECK
************************************************************/

*Demographics
	foreach var of varlist age sex muslim javanese q31_marital_REC2 q32_educ_REC2 q34_newspaper_REC1 numlevel q37_work_REC2 agr tot_mailbox_min3 {
        mean `var', over(Z)
		oneway `var' Z
    }


*Tax experience & political awareness
    foreach var of varlist paytax q51_tax_whopays_REC2 q53_tax_gowhere_REC2 polaware_level2 q84_heard_bupati_REC2 {
        mean `var', over(Z)
		oneway `var' Z
    }

	
/************************************************************
*APPENDIX F: SUMMARY STATS FOR DVS
************************************************************/

est clear
	foreach var of varlist $tax_main_tab2 $tax_mech_tab3 $tax_extra {
		estpost tabstat `var', listwise statistics(mean sd min max count) columns(statistics)
		esttab using "$tables/summary_stats.csv", cells("mean sd min max count") nomtitle nonumber noobs append
	}

	
/************************************************************
*APPENDIX H: ROBUSNESS CHECKS FOR THE MAIN EFFECTS
************************************************************/
	
capture program drop blora_robust	
program blora_robust	
version 11.1

        syntax varlist [if]
        gettoken y controls : varlist
        set more off

	*Regression with controls
	est clear
    eststo: reg `y' taxgrp `controls', vce(hc2)

	*Regression with subdistrict fixed effects (no controls)
	xtset kec_code_num

	eststo: xtreg `y' taxgrp , fe

	*Regression with enumerator fixed effects (no controls)
	xtset enum_num
	eststo: xtreg `y' taxgrp , fe

	qui: estout using "$tables/blora_robust_`y'.xls", replace cells(b(fmt(%9.2f) star) se(par(`"="("'`")""') fmt(%9.2f))) starl(* .10 ** .05  *** .01) drop(`controls' _cons)

end
	
*Main 
	blora_robust q147_learnmore_apbd_REC2 `controls'
	blora_robust q146_learnmore_govt_REC2 `controls'
	blora_robust q145_scrutinize_REC2 `controls'
	blora_robust pol_act_tot `controls'
	blora_robust POST `controls'
	blora_robust votefor_1 `controls'
	blora_robust votefor_3 `controls'
	blora_robust GOODGOV `controls'

*Tax mechanisms
	blora_robust q119_winmore_REC5 `controls'
    blora_robust q120_avoidloss_REC5 `controls'
	blora_robust tax_share_prior3 `controls'
	blora_robust tax_share2 `controls'
	blora_robust windfall_share2 `controls'
	blora_robust q121_owns_apbd_REC2 `controls'
	blora_robust q122_apbd_relevant_REC2 `controls'
	blora_robust q142_satis_apbd_REC2 `controls'
	blora_robust q143_satis_govt_REC2 `controls'
	blora_robust q144_trust_bupati_REC2 `controls'
	blora_robust q144_trust_dprd_REC2 `controls'  	
	blora_robust q123_power_REC2 `controls'
	
	
/************************************************************
*APPENDIX I: MULTINOMIAL LOGIT
************************************************************/
	
*Without controls
est clear
	mlogit GOODGOV i.taxgrp##i.infogrp, robust
		estpost margins, dydx(taxgrp) at(infogrp=(0 1)) predict(outcome(1))
		eststo margins
		estout using "$tables/blora_mlogit_nocontrols.xls", replace cells(b(fmt(%9.2f) star) se(par(`"="("'`")""') fmt(%9.2f)))  starl(* .10 ** .05  *** .01)  nolz 
		
	mlogit GOODGOV i.taxgrp##i.infogrp , robust
		estpost margins, dydx(infogrp) at(taxgrp=(0 1)) predict(outcome(1))
		eststo margins
		estout using "$tables/blora_mlogit_nocontrols.xls", append cells(b(fmt(%9.2f) star) se(par(`"="("'`")""') fmt(%9.2f)))  starl(* .10 ** .05  *** .01)  nolz 
		
	mlogit GOODGOV i.taxgrp##i.infogrp , robust
		estpost margins, dydx(taxgrp) at(infogrp=(0 1)) predict(outcome(-1))
		eststo margins
		estout using "$tables/blora_mlogit_nocontrols.xls", append cells(b(fmt(%9.2f) star) se(par(`"="("'`")""') fmt(%9.2f)))  starl(* .10 ** .05  *** .01)  nolz 
		
	mlogit GOODGOV i.taxgrp##i.infogrp , robust
		estpost margins, dydx(infogrp) at(taxgrp=(0 1)) predict(outcome(-1))
		eststo margins
		estout using "$tables/blora_mlogit_nocontrols.xls", append cells(b(fmt(%9.2f) star) se(par(`"="("'`")""') fmt(%9.2f)))  starl(* .10 ** .05  *** .01)  nolz 
		
	mlogit GOODGOV i.taxgrp##i.infogrp , robust
		estpost margins, dydx(taxgrp) at(infogrp=(0 1)) predict(outcome(0))
		eststo margins
		estout using "$tables/blora_mlogit_nocontrols.xls" , append cells(b(fmt(%9.2f) star) se(par(`"="("'`")""') fmt(%9.2f)))  starl(* .10 ** .05  *** .01)  nolz 
		
	mlogit GOODGOV i.taxgrp##i.infogrp , robust
		estpost margins, dydx(infogrp) at(taxgrp=(0 1)) predict(outcome(0))
		eststo margins
		estout using "$tables/blora_mlogit_nocontrols.xls", append cells(b(fmt(%9.2f) star) se(par(`"="("'`")""') fmt(%9.2f)))  starl(* .10 ** .05  *** .01)  nolz 
		
*With controls	
	est clear
	mlogit GOODGOV i.taxgrp##i.infogrp `controls', robust
		estpost margins, dydx(taxgrp) at(infogrp=(0 1)) predict(outcome(1))
		eststo margins
		estout using "$tables/blora_mlogit_controls.xls", replace cells(b(fmt(%9.2f) star) se(par(`"="("'`")""') fmt(%9.2f)))  starl(* .10 ** .05  *** .01)  nolz 
		
	mlogit GOODGOV i.taxgrp##i.infogrp `controls', robust
		estpost margins, dydx(infogrp) at(taxgrp=(0 1)) predict(outcome(1))
		eststo margins
		estout using "$tables/blora_mlogit_controls.xls", append cells(b(fmt(%9.2f) star) se(par(`"="("'`")""') fmt(%9.2f)))  starl(* .10 ** .05  *** .01)  nolz 
		
	mlogit GOODGOV i.taxgrp##i.infogrp `controls', robust
		estpost margins, dydx(taxgrp) at(infogrp=(0 1)) predict(outcome(-1))
		eststo margins
		estout using "$tables/blora_mlogit_controls.xls", append cells(b(fmt(%9.2f) star) se(par(`"="("'`")""') fmt(%9.2f)))  starl(* .10 ** .05  *** .01)  nolz 
		
	mlogit GOODGOV i.taxgrp##i.infogrp `controls', robust
		estpost margins, dydx(infogrp) at(taxgrp=(0 1)) predict(outcome(-1))
		eststo margins
		estout using "$tables/blora_mlogit_controls.xls", append cells(b(fmt(%9.2f) star) se(par(`"="("'`")""') fmt(%9.2f)))  starl(* .10 ** .05  *** .01)  nolz 
		
	mlogit GOODGOV i.taxgrp##i.infogrp `controls', robust
		estpost margins, dydx(taxgrp) at(infogrp=(0 1)) predict(outcome(0))
		eststo margins
		estout using "$tables/blora_mlogit_controls.xls" , append cells(b(fmt(%9.2f) star) se(par(`"="("'`")""') fmt(%9.2f)))  starl(* .10 ** .05  *** .01)  nolz 
		
	mlogit GOODGOV i.taxgrp##i.infogrp `controls', robust
		estpost margins, dydx(infogrp) at(taxgrp=(0 1)) predict(outcome(0))
		eststo margins
		estout using "$tables/blora_mlogit_controls.xls", append cells(b(fmt(%9.2f) star) se(par(`"="("'`")""') fmt(%9.2f)))  starl(* .10 ** .05  *** .01)  nolz 
		
	
	
/************************************************************
*APPENDIX J: SATISFACTION
*Dissatisfied = 1
************************************************************/
	
	blora_tax_cate GOODGOV if q85_satis_govt_REC2==1
	blora_tax_cate GOODGOV if q85_satis_govt_REC2==0
	
	
/************************************************************
*APPENDIX K: SPILLOVER
************************************************************/

est clear
	foreach var of varlist q147_learnmore_apbd_REC2 POST GOODGOV {
		eststo: reg `var' i.taxgrp##c.picked_up_dh, vce(hc2)
		eststo: reg `var' i.taxgrp##c.spillover2, vce(hc2)
		eststo: reg `var' taxgrp if picked_up_dh==0, vce(hc2)
	}

qui: estout using "$tables/blora_spillover.xls", replace cells(b(fmt(%9.2f) star) se(par(`"="("'`")""') fmt(%9.2f))) starl(* .10 ** .05  *** .01)  nolz 


/************************************************************
*APPENDIX L: REAL TAX EXPERIENCE
************************************************************/

*MAIN OUTCOMES
est clear
	foreach var of varlist q147_learnmore_apbd_REC2 POST GOODGOV {
		foreach item in paytax q51_tax_whopays_REC2 tot_tax_annual3 q57_inc_level_REC2 {
		eststo: reg `var' i.taxgrp##c.`item', vce(hc2)
		}
		}

estout using "$tables/tax_experience.xls", replace cells(b(fmt(%9.2f) star) se(par(`"="("'`")""') fmt(%9.2f))) stats(N) starl(* .10 ** .05  *** .01)  nolz stardrop(_cons) 


/************************************************************
*FDR-ADJUSTED P-VALUES
*Note:
-FDR adjusted q-values are obtained for the ATE of the tax treatment using all hypothesis tests in Table 2 and Table 3 of 
	the main text PLUS additional variables in Appendix G   
-You will only be able to run this code once you have RI p-values for the 20 variables in the global macros
-Replication note: Your q-values might differ slightly from mine if your RI p-values also differ
-Original data and results available from the author on request.  
************************************************************/


*Create a dataset to store p-values
	preserve
	clear
	g pv_5_tt=.
	save "$ri/pvalues_4_fdr.dta", replace
	restore

*Capture RI p-values from 21 simulation datasets produced above using blora_ri.ado
	foreach var of varlist $tax_main_tab2 $tax_mech_tab3 $tax_extra {
		preserve
		use "$ri/blorasim_FINAL_`var'.dta", clear
		keep if _n==1
		keep pv_5_tt
		append using "test.dta", keep(pv_5_tt)
		save "$ri/pvalues_4_fdr.dta", replace
		restore
	}


*Run do file below and paste vector of p-values in pvalues_4_fdr.dta at the prompt
	clear
	do "Do_qvalues.do"
	

*END*	
