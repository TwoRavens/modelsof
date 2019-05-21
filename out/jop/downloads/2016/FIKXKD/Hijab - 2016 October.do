		
*********************************************************************************
*********************************************************************************
** 																  			   **
** 		 This file replicates the analyses in the paper and appendix of 	   **
** 						Daniel M. Bulter and Margit Tavits 				       **
**  "Does the Hijab Increase Representatives’ Perceptions of Social Distance?" **
** 							Journal of Politics			 					   **
** 																  			   **
*********************************************************************************
*********************************************************************************


clear
cd "~/Dropbox/Butler_Tavits/Writing/Hijab/Final/Replication Folder/"
set more off

use "HijabSurveyData.dta"

 
				
*************
** Table 1 **
*************
	** Create factors for DVs
		factor dv_const_1  dv_const_2  dv_const_3, pcf
			predict dv_represent_scale
		factor dv_const_4 dv_const_5, pcf
			predict dv_ethnic_coop_scale
		gen approve_scale=dv_const_6 
		
	** Results
	xi: reg dv_represent_scale tr_wearhijab hijab_muslim off_bosnia off_female  elected tenure i.intid if q1!=95
		outreg2 using "Hijab_Items_scale", dec(2) word label se replace
		lincom tr_wearhijab + hijab_muslim
	xi: reg dv_ethnic_coop_scale tr_wearhijab hijab_muslim off_bosnia off_female  elected tenure i.intid if q1!=95
		outreg2 using "Hijab_Items_scale", dec(2) word label se append
		lincom tr_wearhijab + hijab_muslim
	xi: reg approve_scale tr_wearhijab hijab_muslim off_bosnia off_female  elected tenure i.intid if q1!=95
		outreg2 using "Hijab_Items_scale", dec(2) word label se append
		lincom tr_wearhijab + hijab_muslim

	

**************
** Appendix **
**************	


********************************************************************************************************
** Table OA2.1. Randomization Check: Assignment to Treatment is Unrelated to Pre-Treatment Covariates **
********************************************************************************************************
	probit tr_wearhijab off_female i.q1 elected tenure RSentity if q1!=95
		outreg2 using "Hijab_balance", dec(3) word label se replace

		

**********************************************************************************************
** Table OA3.1 The Effect of Hijab on Perceived Social Distance in Representation by Gender **
**********************************************************************************************	
		gen hijab_fem = tr_wearhijab*off_female
	xi: reg dv_represent_scale tr_wearhijab  hijab_fem  off_female off_bosnia  elected tenure i.intid if q1!=95
		outreg2 using "Hijab_Items_Gender", dec(2) word label se replace
		lincom tr_wearhijab + hijab_fem
	xi: reg dv_ethnic_coop_scale tr_wearhijab  hijab_fem  off_female off_bosnia  elected tenure i.intid if q1!=95
		outreg2 using "Hijab_Items_Gender", dec(2) word label se append
		lincom tr_wearhijab + hijab_fem
	xi: reg approve_scale tr_wearhijab  hijab_fem  off_female off_bosnia  elected tenure i.intid if q1!=95
		outreg2 using "Hijab_Items_Gender", dec(2) word label se append
		lincom tr_wearhijab + hijab_fem

		
********************************************************************
** Table OA3.2. Including Interviewer Characteristics as Controls **
********************************************************************	
		gen int_bosniak= int_ethnicity==3
		gen int_woman=int_gender==2
	
	reg dv_represent_scale tr_wearhijab hijab_muslim off_bosnia off_female  elected tenure int_woman int_bosniak if q1!=95
		outreg2 using "Interviewer_characteristics", dec(2) word label se replace
		lincom tr_wearhijab + hijab_muslim
	reg dv_ethnic_coop_scale tr_wearhijab hijab_muslim off_bosnia off_female  elected tenure int_woman int_bosniak  if q1!=95
		outreg2 using "Interviewer_characteristics", dec(2) word label se append
		lincom tr_wearhijab + hijab_muslim
	reg approve_scale tr_wearhijab hijab_muslim off_bosnia off_female  elected tenure int_woman int_bosniak  if q1!=95
		outreg2 using "Interviewer_characteristics", dec(2) word label se append
		lincom tr_wearhijab + hijab_muslim
	
	
*********************************************************
** Table OA3.3. The Average Effect for All Respondents **
*********************************************************	
	xi: reg dv_represent_scale tr_wearhijab off_bosnia off_female  elected tenure i.intid if q1!=95
		outreg2 using "Hijab_Items_ATE_OA", dec(2) word label se replace
	xi: reg dv_ethnic_coop_scale tr_wearhijab off_bosnia off_female  elected tenure i.intid if q1!=95
		outreg2 using "Hijab_Items_ATE_OA", dec(2) word label se append
	xi: reg approve_scale tr_wearhijab  off_bosnia off_female  elected tenure i.intid if q1!=95
		outreg2 using "Hijab_Items_ATE_OA", dec(2) word label se append
			

*****************************************************
** Table OA4.1. Bivariate Correlations Among Items **
*****************************************************
	corr dv_const_1  dv_const_2  dv_const_3 dv_const_4 dv_const_5 dv_const_6
	
*************************************************************
** Table OA4.2. Factor Loadings for Full Battery of Items  **
*************************************************************
	factor dv_const_1  dv_const_2  dv_const_3 dv_const_4 dv_const_5 dv_const_6, pcf
			
	
	
	
	
****************
** Figure OA5 **
****************	

	save "temp.dta", replace
		
	********************
	** Representation **
	********************
	set more off
	tempfile t1 t2 
	xi: reg dv_represent_scale tr_wearhijab hijab_muslim off_bosnia off_female  elected tenure i.intid if q1!=95
		lincomest tr_wearhijab
			parmest,label saving(`t1',replace)
	xi: reg dv_represent_scale tr_wearhijab hijab_muslim off_bosnia off_female  elected tenure i.intid if q1!=95
		lincomest tr_wearhijab + hijab_muslim
			parmest,label saving(`t2',replace)
		dsconcat `t1' `t2' 
		
	gen tr_number = _n
		expand 2
	bysort tr_number: gen yy=_n 

	gen range_report=estimate-1.64*stderr if yy==1
		replace range_report=estimate+1.64*stderr if yy==2
	gen range_95=min95 if yy==1
		replace range_95=max95 if yy==2
	
	#delimit;
	twoway (scatter estimate tr_number, mcolor(black) msize(large)) 
		(line range_95 tr_number if  tr_number==1, lcolor(black))
		(line range_95 tr_number  if tr_number==2, lcolor(black)) 
		(line range_report tr_number if  tr_number==1, lcolor(black) lwidth(thick))
		(line range_report tr_number  if tr_number==2, lcolor(black) lwidth(thick)) 
		, graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) legend(off) xsc(range(.5(1)2.5))
		 xlabel(1 "Sample:" 1   "Non-Muslims"  2 "Sample:" 2 "Muslims" , angle(horizontal) alternate) ytitle("") ylabel( , angle(horizontal)) 
		xtitle(" " "Hijab Treatment Effect") ytitle(Representation Score)
		;
		graph export "represent_results.png", replace;
	#delimit cr;	
		
		

	************************
	** Ethnic Cooperation **
	************************
	use "temp.dta", clear
	set more off
	tempfile u1 u2 
	xi: reg dv_ethnic_coop_scale tr_wearhijab hijab_muslim off_bosnia off_female  elected tenure i.intid if q1!=95
		lincomest tr_wearhijab
			parmest,label saving(`u1',replace)
	xi: reg dv_ethnic_coop_scale tr_wearhijab hijab_muslim off_bosnia off_female  elected tenure i.intid if q1!=95
		lincomest tr_wearhijab + hijab_muslim
			parmest,label saving(`u2',replace)
		dsconcat `u1' `u2' 
		
	gen tr_number = _n
		expand 2
	bysort tr_number: gen yy=_n 

	gen range_report=estimate-1.64*stderr if yy==1
		replace range_report=estimate+1.64*stderr if yy==2
	gen range_95=min95 if yy==1
		replace range_95=max95 if yy==2
	
	
	#delimit;
	twoway (scatter estimate tr_number, mcolor(black) msize(large)) 
		(line range_95 tr_number if  tr_number==1, lcolor(black))
		(line range_95 tr_number  if tr_number==2, lcolor(black)) 
		(line range_report tr_number if  tr_number==1, lcolor(black) lwidth(thick))
		(line range_report tr_number  if tr_number==2, lcolor(black) lwidth(thick)) 
		, graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) legend(off) xsc(range(.5(1)2.5))
		 xlabel(1 "Sample:" 1   "Non-Muslims"  2 "Sample:" 2 "Muslims" , angle(horizontal) alternate) ytitle("") ylabel( , angle(horizontal)) 
		xtitle(" " "Hijab Treatment Effect") ytitle(Ethnic Cooperation Score)
		;
		graph export "cooperation_results.png", replace;
	#delimit cr;	
		
			
	**************
	** Approval **
	**************
	use "temp.dta", clear
	set more off
	tempfile w1 w2 
	xi: reg dv_ethnic_coop_scale tr_wearhijab hijab_muslim off_bosnia off_female  elected tenure i.intid if q1!=95
		lincomest tr_wearhijab
			parmest,label saving(`w1',replace)
	xi: reg dv_ethnic_coop_scale tr_wearhijab hijab_muslim off_bosnia off_female  elected tenure i.intid if q1!=95
		lincomest tr_wearhijab + hijab_muslim
			parmest,label saving(`w2',replace)
		dsconcat `w1' `w2' 
		
	gen tr_number = _n
		expand 2
	bysort tr_number: gen yy=_n 

	gen range_report=estimate-1.64*stderr if yy==1
		replace range_report=estimate+1.64*stderr if yy==2
	gen range_95=min95 if yy==1
		replace range_95=max95 if yy==2
	
	
	#delimit;
	twoway (scatter estimate tr_number, mcolor(black) msize(large)) 
		(line range_95 tr_number if  tr_number==1, lcolor(black))
		(line range_95 tr_number  if tr_number==2, lcolor(black)) 
		(line range_report tr_number if  tr_number==1, lcolor(black) lwidth(thick))
		(line range_report tr_number  if tr_number==2, lcolor(black) lwidth(thick)) 
		, graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) legend(off) xsc(range(.5(1)2.5))
		 xlabel(1 "Sample:" 1   "Non-Muslims"  2 "Sample:" 2 "Muslims" , angle(horizontal) alternate) ytitle("") ylabel( , angle(horizontal)) 
		xtitle(" " "Hijab Treatment Effect") ytitle(Approval Score)
		;
		graph export "approval_results.png", replace;
	#delimit cr;		
	
	
	
