 #delimit;
 set more off;
 
 /*	************************************************************	*/
/*     	File Name:	hpfall2010regressions.do			*/
/*     	Date:   	December 15, 2013 				*/
/*      Author: 	Nicholas F. Martini				*/
/*      Purpose:	This file replicates the afghanistan results 	*/
/*					Tables 1 and 2										*/
/*      Input File: 	hpfall2010.dta			*/
/*	************************************************************	*/


/***Table 1 - factor analysis table***/

factor fp1a fp2a fp3a fp4a, ipf;
rotate,  varimax blanks (.4);



/****************Table 2**********************/

#delimit;
mlogit afgh1b mi ci pid7pt id7pt cas1alog2 cas2same cas2dec afgh3win incomea educa nonwhite attenda 
evang female  ageyrs knowla [pweight= wgt_state_abb], robust;

outreg2 using F10_base, side alpha(.01,.05) sym (**,*) dec(3) excel replace;

predict pred1 pred2 pred3 if e(sample), pr;

gen afghpred=.;
label variable afghpred "prediction based on mlogit model for afgh1b";
replace afghpred = 1 if pred1 > pred2 & pred1 > pred3 ;
replace afghpred = 2 if pred2 > pred1 & pred2 > pred3 ;
replace afghpred = 3 if pred3 > pred1 & pred3 > pred2 ;

gen afghcor =.;
label variable afghcor "if prediction is correct for mlogit on afghcor - sum to get % pred cor";
replace afghcor =1 if (afghpred== afgh1b );
replace afghcor =0 if (afghpred!=afgh1b );
replace afghcor =. if (afghpred==.);
replace afghcor =. if (afgh1b ==.);


sum afghcor ;

#delimit;
tab afgh1b if  ci != . &  pid7pt != . &  id7pt != . &  cas1alog2 != . &  cas2same != . &  cas2dec != . &  afgh3win != . &  incomea != . &  
educa != . &  nonwhite != . &  attenda!= . &  evang != .  &    female  != . &  ageyrs != . &  knowla != . &  mi != . ;


drop  pred1 pred2 pred3 afghpred afghcor;



#delimit;
margins, at( (mean) _all mi = (-.77 0 .77) nonwhite=0 evang=0  female=1 afgh3win=0 cas2same=0 cas2dec=0 ) predict(outcome(3));
margins, at( (mean) _all pid7pt =(1 4 7) nonwhite=0 evang=0  female=1 afgh3win=0 cas2same=0 cas2dec=0 ) predict(outcome(3));
margins, at( (mean) _all cas2dec=(0 1) nonwhite=0 evang=0  female=1 afgh3win=0 cas2same=0  ) predict(outcome(3));
margins, at( (mean) _all nonwhite=0 evang=0  female=1 afgh3win=(0 1) cas2same=0 cas2dec=0 ) predict(outcome(3));
margins, at( (mean) _all educa =(1 4 7) nonwhite=0 evang=0 female=1 afgh3win=0 cas2same=0 cas2dec=0 ) predict(outcome(3));
margins, at( (mean) _all nonwhite=0 evang= (0 1) female=1 afgh3win=0 cas2same=0 cas2dec=0 ) predict(outcome(3));



#delimit;
margins, at( (mean) _all mi = (-.77 0 .77) nonwhite=0 evang=0  female=1 afgh3win=0 cas2same=0 cas2dec=0 ) predict(outcome(1));
margins, at( (mean) _all pid7pt =(1 4 7) nonwhite=0 evang=0  female=1 afgh3win=0 cas2same=0 cas2dec=0 ) predict(outcome(1));
margins, at( (mean) _all cas2dec=(0 1) nonwhite=0 evang=0  female=1 afgh3win=0 cas2same=0  ) predict(outcome(1));
margins, at( (mean) _all nonwhite=0 evang=0  female=1 afgh3win=(0 1) cas2same=0 cas2dec=0 ) predict(outcome(1));
margins, at( (mean) _all educa =(1 4 7) nonwhite=0 evang=0 female=1 afgh3win=0 cas2same=0 cas2dec=0 ) predict(outcome(1));
margins, at( (mean) _all nonwhite=0 evang= (0 1) female=1 afgh3win=0 cas2same=0 cas2dec=0 ) predict(outcome(1));









/****correlations***/
#delimit;
cor mi  pid7pt  [aw = wgt_state_abb];
cor  ci pid7pt  [aw = wgt_state_abb];
cor mi   id7pt [aw = wgt_state_abb];
cor ci  id7pt [aw = wgt_state_abb];
cor pid7pt  id7pt [aw = wgt_state_abb];



/****descriptive stats***/
#delimit;
sum afgh1b mi ci pid7pt id7pt cas1alog2 cas2same cas2dec afgh3win incomea educa nonwhite attenda 
evang female  ageyrs knowla;


/***getting mean and +/1 1SD of MI for sub effects***/
#delimit;
sum mi if  ci != . &  pid7pt != . &  id7pt != . &  cas1alog != . &  cas2same != . &  cas2dec != . &  afgh3win != . &  incomea != . &  
educa != . &  nonwhite != . &  attenda!= . &  evang != . &    female  != . &  ageyrs != . &  knowla != . &  afgh1b != . ;
