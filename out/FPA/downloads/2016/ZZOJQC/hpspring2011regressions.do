 #delimit;
 set more off;
 
 /*	************************************************************	*/
/*     	File Name:	hpspring2011regressions.do			*/
/*     	Date:   	December 15, 2013 				*/
/*      Author: 	Nicholas F. Martini				*/
/*      Purpose:	This file replicates the lybia results 	*/
/*					Tables 3 and 4										*/
/*      Input File: 	hpspring2011.dta			*/
/*	************************************************************	*/

***Table 3***/

factor fp1a fp2a fp3a fp4a, ipf
rotate,  varimax blanks (.4)


/***Table 4***/

#delimit;
logit fp5 c.mi c.ci pid7pt ideol7pt income educ nonwhite  
	attenda evang  female  age knowla [pweight= wgt_state_abb], robust ;
outreg2 using Sp11_fp5, side alpha(.01,.05) sym (**,*) dec(3) excel replace;
precalc;

margins, at((mean) _all mi=(-.75 0 .79 ) nonwhite=0 evang=0  female=1);
margins, at((mean) _all ci=(-.76 0 .77) nonwhite=0 evang=0  female=1);
margins, at((mean) _all ideol7pt=(1 4 7) nonwhite=0 evang=0  female=1);







/***correlations***/

#delimit;
cor mi  pid7pt 	[aw = wgt_state_abb];
cor  ci pid7pt 	[aw = wgt_state_abb];
cor mi   ideol7pt	[aw = wgt_state_abb];
cor  ci  ideol7pt	[aw = wgt_state_abb];
cor  pid7pt  ideol7pt	[aw = wgt_state_abb];




/***getting mean and +/1 1SD of MI and CI for sub effects***/
#delimit;
sum mi if  ci != . &  pid7pt != . &  ideol7pt != . &  income != . &  educ != . &  nonwhite != . &  
attenda!= . &  evang != . & female  != . &  age != . &  knowla != . ;

#delimit;
sum ci if  mi != . &  pid7pt != . &  ideol7pt != . &  income != . &  educ != . &  nonwhite != . &  
attenda!= . &  evang != . & female  != . &  age != . &  knowla != . ;

