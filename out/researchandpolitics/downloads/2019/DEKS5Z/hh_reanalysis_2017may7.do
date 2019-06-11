// May 7, 2017
// Hainmueller/Hopkins 2015 AJPS for "Explaining Immigration Preferences: Disentangling Skill and Prevalence (Online Appendix 6a)


cd "C:\~" // change working directory

use repdata.dta, clear

set more off

reg chosen_immigrant i.featgender i.feated##i.featjob i.featlang ib6.featcountry##i.featreason i.featexp ib3.featplans i.feattrips [pweight=weight2] ,  cl(caseid)  // Original HH Regression


/// OCCUPATION 

// We first collapse all the high-skilled jobs into a single category (financial analyst, computer programmer, research scientist, doctor) and all the low-skilled jobs into another category ( Janitor, Waiter, Child Care Provider, Gardener, Construction Worker.   Teacher and nurse are not assigned //

gen featjob2 = featjob
recode featjob2 (1=1) (2=1)(3=1)(4=1) (6=1) (7=2) (9=2) (5=3) (8=3) (10=3) (11=3)


reg chosen_immigrant i.featgender i.feated##i.featjob2 i.featlang ib6.featcountry##i.featreason i.featexp ib3.featplans i.feattrips [pweight=weight2] ,  cl(caseid)

foreach x of numlist 3 {
lincom  (`x'.featjob2 *0    + (`x'.featjob2 + 2.feated#`x'.featjob2) *0   + /// 
                             (`x'.featjob2 + 3.feated#`x'.featjob2) *0   + ///
                             (`x'.featjob2 + 4.feated#`x'.featjob2) *0   + ///
							 (`x'.featjob2 + 5.feated#`x'.featjob2) *1/3   + ///
							 (`x'.featjob2 + 6.feated#`x'.featjob2) *1/3   + ///
							 (`x'.featjob2 + 7.feated#`x'.featjob2) *1/3 )	 
}

// Pooled skill premium: 0.08

// High-Skill Countries of Origin 

reg chosen_immigrant i.featgender i.feated##i.featjob2 i.featlang i.featexp ib3.featplans i.feattrips [pweight=weight2] if featcountry==1|featcountry==2|featcountry==4|featcountry==6|featcountry==7,  cl(caseid)

foreach x of numlist 3 {
lincom  (`x'.featjob2 *0    + (`x'.featjob2 + 2.feated#`x'.featjob2) *0   + /// 
                             (`x'.featjob2 + 3.feated#`x'.featjob2) *0   + ///
                             (`x'.featjob2 + 4.feated#`x'.featjob2) *0   + ///
							 (`x'.featjob2 + 5.feated#`x'.featjob2) *1/3   + ///
							 (`x'.featjob2 + 6.feated#`x'.featjob2) *1/3   + ///
							 (`x'.featjob2 + 7.feated#`x'.featjob2) *1/3 )	 
}

// Skill premium: 0.041

// Low-Skilled Countries of Origin

reg chosen_immigrant i.featgender i.feated##i.featjob2 i.featlang i.featexp ib3.featplans i.feattrips [pweight=weight2] if featcountry==3|featcountry==5|featcountry==8|featcountry==9|featcountry==10,  cl(caseid)

foreach x of numlist 3 {
lincom  (`x'.featjob2 *0    + (`x'.featjob2 + 2.feated#`x'.featjob2) *0   + /// 
                             (`x'.featjob2 + 3.feated#`x'.featjob2) *0   + ///
                             (`x'.featjob2 + 4.feated#`x'.featjob2) *0   + ///
							 (`x'.featjob2 + 5.feated#`x'.featjob2) *1/3   + ///
							 (`x'.featjob2 + 6.feated#`x'.featjob2) *1/3   + ///
							 (`x'.featjob2 + 7.feated#`x'.featjob2) *1/3 )	 
}


// Skill premium: 0.123

// EDUCATION

gen feated2 = feated
recode feated2 (1=1) (2=1)(3=1)(4=1) (5=2) (6=2) (7=2)

reg chosen_immigrant i.featgender i.feated2##i.featjob i.featlang ib6.featcountry##i.featreason i.featexp ib3.featplans i.feattrips [pweight=weight2] ,  cl(caseid)

foreach x of numlist 2(1)2 {
lincom  (`x'.feated2 * 1/7  + (`x'.feated2 + `x'.feated#2.featjob)  * 1/7 + /// 
                             (`x'.feated2 + `x'.feated2#3.featjob)  * 1/7 + ///
                             (`x'.feated2 + `x'.feated2#4.featjob)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#5.featjob)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#6.featjob)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#7.featjob)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#8.featjob)  * 0 )	
} 

// Overall effect: .11

// High-Skill Countries of Origin

reg chosen_immigrant i.featgender i.feated2##i.featjob i.featlang ib6.featcountry##i.featreason i.featexp ib3.featplans i.feattrips [pweight=weight2]  if featcountry==1|featcountry==2|featcountry==4|featcountry==6|featcountry==7,  cl(caseid)

foreach x of numlist 2(1)2 {
lincom  (`x'.feated2 * 1/7  + (`x'.feated2 + `x'.feated#2.featjob)  * 1/7 + /// 
                             (`x'.feated2 + `x'.feated2#3.featjob)  * 1/7 + ///
                             (`x'.feated2 + `x'.feated2#4.featjob)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#5.featjob)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#6.featjob)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#7.featjob)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#8.featjob)  * 0 )	
} 

// Skill premium: .136

// Low-Skilled Countries of Origin
 
reg chosen_immigrant i.featgender i.feated2##i.featjob i.featlang ib6.featcountry##i.featreason i.featexp ib3.featplans i.feattrips [pweight=weight2]  if featcountry==3|featcountry==5|featcountry==8|featcountry==9|featcountry==10,  cl(caseid)

foreach x of numlist 2(1)2 {
lincom  (`x'.feated2 * 1/7  + (`x'.feated2 + `x'.feated#2.featjob)  * 1/7 + /// 
                             (`x'.feated2 + `x'.feated2#3.featjob)  * 1/7 + ///
                             (`x'.feated2 + `x'.feated2#4.featjob)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#5.featjob)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#6.featjob)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#7.featjob)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#8.featjob)  * 0 )	
} 

// skill premium: .075










