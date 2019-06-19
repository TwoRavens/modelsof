***********************************	Title: hivlabormaster.do*	Date: 18 February 2008; edited 25 Feb 2011*	Author: Zoe McLaren*	Description: *		1. Produces paper results starting from original data files.**********************************
clear all
clear matrix
version 8

global dr ""  /*main directory*/ global data ""  /*save new data here*/global syntax "" /*do files*/
global stata "" /*original data folder*/
global output "" /*output files saved here*/do "$syntax/merge04.do" 
	*Runs vp04.do which cleans household data 
			*Input data: vpfwgt.dta
	*Runs indiv04.do (subfiles: aux_vars_ZAF.do, child_ZAF.do, youngchild_ZAF.do) to clean individual data
			*Input files: adultyouth2004.dta, child2004.dta, paref32004.dta
	do "$syntax/labor04.do"  
	*Creates new variables for analysis.
			*Input file: hhindiv04.dta

*Creates Tables 1, 2 and 3
do "$syntax/table1.do"

*Creates Figure 1
do "$syntax/figure1.do"

*Creates Table 4 and Table 6
do "$syntax/hivlabor_5.do" 
	*Performs main analysis (subfiles: regloop10.do, hivlabor_bootstrap3.do)
			*Input files: hhindiv04_labor.dta, bed_stata2.dta, viralload_stata2.dta

*Creates Figure 2
do "$syntax/figure2.do"

*Creates Table 5
do "$syntax/table5.do"
	
*Creates Tables 7 and 8
*Rerun analysis with different samples to create appendix tables
do "$syntax/hivlabor_5a1.do"  
		* This calls regloop10a1.do and hivlabor_bootstrap3.do
do "$syntax/hivlabor_5a2.do"  
		* This calls regloop10a2.do and hivlabor_bootstrap3.do

exit
