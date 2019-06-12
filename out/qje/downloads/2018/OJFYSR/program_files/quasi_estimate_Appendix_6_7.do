*
**This file carries out the ancillary analysis summarized
**in  Appendix Table 7 and Appendix Figure 1.

*input: sec_dirpath/QUASI_cmb_est.dta, 
*output: quasi_cost_het.tex

clear all
capture log close
clear matrix
program drop _all
set more off

global p_spec "4"

**************************************************************
**Set Directory Paths Here: sec_dirpath is for 
**confidential data while home_dirpath is for all other input.
**Output is for .tex table output.
**************************************************************



global sec_dirpath "T:\Efficiency\WAP\data"
global home_dirpath "T:Dropbox\WAP"
*global output "C:/Users/TEMP/Dropbox/wap/Brian Checks/Annotated Code/Output"
global output "T:\WAP_FINAL\WAP_Appendix_Final\tables_figures"

capture log close


*First, edit psweight_4.dta file in preparation for merge with QUASI_cmb_est data
*cd "$home_dirpath/Brian Checks/Annotated Code/Input"
cd "T:\WAP_FINAL\WAP_Appendix_Final\data_files"	

		use psweight_4.dta, clear
		
			keep walt_id cons_hh_id WAP pscore ps_w block
			sort cons_hh_id
			tempfile temp
			save tempdata, replace
			clear

**************Savings versus costs
  use "$sec_dirpath/QUASI_cmb_est.dta", replace

			capture drop _merge
			drop if BTU==.
			drop if BTU==0
			sort cons_hh_id 
			merge cons_hh_id using tempdata
			
****************MERGE RATE

gen CONT_IND=1
replace CONT_IND=0 if iwc_contractor==""
preserve
keep if WAP==1
keep cons_hh_id fwhhid CONT_IND
duplicates drop
tab CONT_IND
* 16% merge rate
**************************

restore
* treatment effect heterogeneity along the cost dimension
* We originally estimated several specifications. Results qualitatively consistent across specifications. 
* Appendix highlights estimates from regressing expenditures on discretized investment costs.
		  			 
		* areg bill  D COST_INT  _Iyear_* _Im_AXyea* [pw=ps_w], absorb(id) robust cluster(fwhhid)

	* Generate coefficient estimates reported in Appendix Table A7
		 
		 areg bill  D COST_CAT_INT*  _Iyear_* _Im_AXyea* [pw=ps_w], absorb(id) robust cluster(fwhhid)
		 coefplot, drop(_cons _Im* _Iyear*) xline(0) xtitle (Percentage change in average monthly energy consumption)
		
	   	 *areg lnbill  D COST_CAT_INT*  _Iyear_* _Im_AXyea* [pw=ps_w], absorb(id) robust cluster(fwhhid)
		 *coefplot, drop(_cons _Im* _Iyear*) xline(0)  xtitle (Percentage change in monthly energy bill) 	
		 *areg BTU  D COST_CAT_INT*  _Iyear_* _Im_AXyea* [pw=ps_w], absorb(id) robust cluster(fwhhid)
		 *coefplot, drop(_cons _Im* _Iyear*) xline(0) xtitle (Change in average monthly energy consumption)
		
         preserve
		 
	* Summarize costs by category - These are reported in Appendix Table 7	
		 keep COST_CAT* cost walt_id cons_hh_id WAP bill
		 
		 keep if WAP==1
		 drop if bill==.
		 drop if bill==0
		 drop bill
		 duplicates drop
		 
		 foreach i of num 1/4 {
		 table COST_CAT_`i', c(mean cost sd cost)
		 }
		 
		 restore

 /**********************
	 * experienced contractor
	 Look at how realization rates vary with our measure of experience. 
     Category 1: >50 jobs
     Category 2: 20-45 jobs
   Category 3: <20 jobs*/
*************************
	 capture drop EXP_CAT*
	 
	 gen EXPC_CAT1=0 
	 replace EXPC_CAT1=1 if EXP_COUNT>50.1 & EXP_COUNT<200
	 gen EXPC_CAT2=0
	 replace EXPC_CAT2=1 if EXP_COUNT<50
	 replace EXPC_CAT2=0 if EXP_COUNT<20
	 gen EXPC_CAT3=0
	 replace EXPC_CAT3=1 if EXP_COUNT<20
	 replace EXPC_CAT3=0 if EXP_COUNT==0
	 
	 foreach x in 1 2 3{
	 gen PROJ_CAT`x'=PROJ_mmbtu*EXPC_CAT`x'
	 }
	 
	 gen EXP_PROJ=D_EXPCON_DUM*PROJ_mmbtu
  
  *log on
  keep if CONT_IND==1
	
	
	areg BTU PROJ_CAT1 PROJ_CAT2 PROJ_CAT3  _Iyear_* _Im_AXyea*  [pw=ps_w], absorb(id) robust cluster(fwhhid)
	coefplot, drop(_cons _Iyear* _Im*) xline(0) xtitle (Realization rate)
    test PROJ_CAT1=PROJ_CAT2=PROJ_CAT3
	
	gen negBTU=-BTU
	
	xtreg negBTU PROJ_CAT1 PROJ_CAT2 PROJ_CAT3 _Iyear_* _Im_AXyea*  [pw=ps_w], fe vce(robust)
	*coefplot, drop(_cons _Iyear* _Im_AXyea*) xline(0) xtitle (Realization rate)
	coefplot, drop(_cons _Iyear* _Im*) xtitle("Savings realization rate") ///
	 coeflabels(PROJ_CAT1 = "> 50 jobs" PROJ_CAT2 = "20-50 jobs" PROJ_CAT3 = "< 20 jobs") ///
	 recast(bar)  barwidth(0.25) citop ci(95 spike box) ciopts(recast(rcap)) ///
	 xlabel(0(0.1)0.5) 
	 
	 graph export "T:\WAP_FINAL\WAP_Appendix_Final\tables_figures\experience.pdf", as(pdf) replace
	
	test PROJ_CAT1=PROJ_CAT2=PROJ_CAT3
	
