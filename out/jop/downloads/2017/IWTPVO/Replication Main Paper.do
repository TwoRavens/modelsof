
**********************************************************************************
****Replication Code: Pav‹o, Nara. "Why We DonÕt Just Throw The Rascals Out" *****
**********************************************************************************

**************
**Main Paper**
**************

*************************************************************
*Table 1: LACK OF CHOICE OPTION AND CORRUPTION VOTING 
*************************************************************

    ***********************
	** LAPOP Brazil 2006 **
	***********************

logit honesty cynicism  age  education income male urban pol_interest salience_cor
eststo
esttab using 2.tex, star(+ 0.10 * 0.05 ** 0.01 *** 0.001) se(3)
eststo clear


*************************************************************
*Table 2: THE DETERMINANTS OF CYNICISM
*************************************************************

    ***************
	** CSES 2006 **
	***************

* Model 2
xtmelogit noneonly cpi  age income male partyage regimeage presidential if problem==1 & polityIV>6  || C1003:  ,
eststo
* Model 3
xtmelogit noneonly cpi education politicalinformation closeparty  polarization  age income male partyage regimeage presidential if problem==1 & polityIV>6  || C1003:  ,
eststo
esttab using 1.tex, star(* 0.05 ** 0.01 *** 0.001) se(3)
eststo clear


*************************************************************
*Table 3: TREATMENT EFFECTS
*************************************************************

    ********************
	** Qualtrics 2016 **
	********************
	
reg tolerance_sum corruption_treatment	
