 
/* Alastair Smith and Jim Vreeland: What is the effect of IMF programs on leader survival?  */ 
/* Project: how do IMF agreements affect political survival */
/* September 2003 */ 
/* The file uses IMF leader level data that has been modified by selection_2_route_IMF_dataprep.do **/
/* This file calls programs_for_MLE_MCMC_est.do which as the routines for MLE and MCMC procedures*/
#delimit ; 
 clear ;
set mem 200m;
set more off; 
version 6;
cd c:\al2002\imf\ ;

use working_IMF_select;


/**********************************************/
/**************** ANALYSES ********************/
/**********************************************/

capture log close;
log using 2routeIMF.log,append;
gen tenure=_t; 
gen Wtenure=W*tenure; 
gen shortT=tenure<2 &tenure~=.;
gen WshortT=W*shortT;
gen Wpostlegelec=W*postlegelec; gen Wprelegelec=W*prelegelec; 
gen Wchan_reserves=W*chan_reserves;
gen WMexchan=W*Mexchan;
gen WQch_inflation=W*Qch_inflation;
gen WQinflation=W*Qinflation;
gen Wyear=W*year; 

gen one1=1; gen one2=1; gen W2=W; gen eS2=eS; 
/* X1 corresponds to a descretionary loan. */
/* postlegelec Wpostlegelec shortT WshortT W eS tenure Wtenure m_till_el m_since_el 
      system yrsoffc multple dateleg dateexec exelec state state author  */
label var multple "Able to run again=1, term limited =0";
gen Wmultple=W*multple;
gen Wauthor=W*author; 
gen Wstate=W*state; 
gen Wm_till_el=W*m_till_el;
gen Wm_since_el=W*m_since_el;
gen lveto=ln(1+veto);
gen Wlveto=W*lveto;
/* Jim Vreeland cases-- from IMF book  */ 
gen Y1jim=0; replace Y1jim = 1 if UNDER==1 &((year==1975&ccode==775)|(year==1977&ccode==290) |
	(year==1979&ccode==290)|(year==1977&ccode==290)|(year==1983&ccode==290)|(year==1984&ccode==290)|
	(year==1969&ccode==640)|(year==1970&ccode==640)|
	(year==1973&ccode==165)|(year>=1975&year<=1984&ccode==165)|(year>=1986&year<=1987&ccode==165)|
	(year==1990&ccode==165));
gen Y2jim=0;  replace Y2jim=1 if UNDER==1 &( (ccode==434&year==1989)|
	(ccode==484&year>=1986&year<=1988)|(ccode==484&year==1990)|(ccode==437&year>=1981&year<=1990)|
	(ccode==481&year>=1978&year<=1988)|(ccode==404&year==1987)|(ccode==110&year==1982)|
	(ccode==620&year==1981)|(ccode==620&year==1983)|(ccode==620&year==1985)|
	 (ccode==620&year==1986)| (ccode==580&year==1980)|(ccode==580&year==1981)|
	(ccode==95&year==1982)|(ccode==95&year==1983)|(ccode==433&year==1982)|
	(ccode==433&year==1985)|(ccode==433&year==1986)|(ccode==520&year==1985) |	
	(ccode==625&year>=1982&year<=1985)|(ccode==500&year==1981) );
replace year=year-1975; 
gen wyear=W*year;
replace Wyear=wyear;
replace Qinflation =Qinflation /100;
replace WQinflation =WQinflation/100; 
replace cummul =ln(cummul+1);
replace Wcummul =ln(cummul+1)*W;
replace ConflictIndex=ConflictIndex/1000;
gen WConflictIndex=W*ConflictIndex;
#delimit;

 
/***********************************************************************************/
/******** SETUP PARAMETERS FOR THE ESTIMATE ****************************************/
/***********************************************************************************/
global y  UNDER ;  /* insert dependent variable here */ 
global x1  one1 W   tenure Wtenure year wyear cummul Wcummul WB_growth WB_growthW ; /* act Wact 
	 BANKSBIGACT WBANKSBIGACT ; */  /*   ConflictIndex WConflictIndex    */ ;
 /*insert independent variable here */ 
global x2  one2 W2  debtserv Wdebtserv Mexchan  WMexchan chan_reserves Wchan_reserves logMresIm WlogMresIm WB_growth WB_growthW ;

global x1  one1 W  eS tenure Wtenure year cummul  WB_growth  ; 
global x2  one2 W2 eS2 debtserv  chan_reserves logMresIm Mexchan ;
global x2  one2 W2 eS2 debtserv   logMresIm Mexchan ;

capture drop y1 y2;
gen y1=(UNDER==1 & NNEED<2 ); 
gen y2=(NNEED>=5 & UNDER==1);
/*
capture drop y1 y2;
gen y1=(UNDER==1 & NNEED<2 ); 
gen y2=(NNEED>=5 & UNDER==1);

gen y1=(UNDER==1 & NNEED<2 ); 
gen y1_0=(UNDER==1 & NEED>3 & Wprelegelec >=.75 ); 
gen y2=(NNEED>=5 & UNDER==1); */
gen y2_0=(NNEED<2 &UNDER==1); /* gen y2_0=(NNEED<2 &UNDER==1);*/
/* USE VREELAND IMF CODING OF EXTREMES */
 replace y1 =Y1jim; replace y2=Y2jim;  /* jim vreeland (2002, 2003)*/ 
 replace y1=1 if (NNEED<1 &UNDER==1& sample==1); 
replace y2=1 if (UNDER==1& NNEED>5 &sample==1); /* extreme need or no need cases */

global case1 y1;
global case2 y2;
global k1 : word count $x1; /* number of parameters in x1 */
global k2 : word count $x2; /* number of parameters in x1 */

#delimit;
/* define MLE procedures needed */ 

do mcmc\programs_for_MLE_MCMC_est.do; 

#delimit; 

capture log close;

 MCMC_IMF; 
log using output_PA_30oct2003 , replace; 
 MCMC_IMF_out; 

#delimit;

ml model lf p2route_partial ("$x1",nocons) ("$x2", nocons)  if sample==1     ;
ml maximize, ; 
gen esample=e(sample); 
mat start1=e(b);
tab y1 y2  if sample==1;
tab y1 y2  if UNDER==1 ;
tab y1 y2  if UNDER==1 &sample ==1; 
tab y1 y2  if UNDER==1 &sample ==1 & esample==1; 

ml model lf p2route ("$x1",nocons) ("$x2", nocons)  if sample==1     ;
ml init start1;
ml maximize, difficult ; 


#delimit;
ml model lf throbit ("$x1",nocons) ("$x2", nocons) /tau1 / tau2   if sample==1     ;
ml init /tau1 =-1.5;
ml init /tau2 =-1.5;
ml maximize, difficult; 

#delimit;
