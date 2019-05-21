** Title: Economic Reasoning with a Racial Hue: Is the Immigration Consensus Purely Race Neutral? **
*** Hainmueller/Hopkins 2015 AJPS Replication
*** Author: Ben Newman and Neil Malhotra
*** Date: November 3, 2017

*/ Load in Data */

use hhdata.dta, clear


// We first collapse all the high-skilled jobs into a single category (doctor, computer programmer, research scientist) //

gen featjob2 = featjob
recode featjob2 (1=1) (2=2)(3=3)(4=4) (5=5) (6=6) (7=7) (9=8)  (8=9) (10=9) (11=9)

**** We next create a measure of ethnocentrism which  is the average FT score for Hispanics, above or equal to 50/below 50

gen avg = (w1_q5)/1  /* w1_q6 is Immigrants, w1_q5 is Hispanics */
gen subset = avg>=50 if avg!=.  /* subset ==1 for LP individuals, subset==0 for HP individuals */



/// OCCUPATION 

// Create matrix for occupation results

mat results = J(8,4,0)


// Germany (High Prejudice)

qui: reg chosen_immigrant i.featgender i.feated##i.featjob2 i.featlang i.featexp ib3.featplans i.feattrips [pweight=weight2] if featcountry==1&subset==0,  cl(caseid)

foreach x of numlist 9 {
lincom  (`x'.featjob2 *0    + (`x'.featjob2 + 2.feated#`x'.featjob2) *0   + /// 
                             (`x'.featjob2 + 3.feated#`x'.featjob2) *0   + ///
                             (`x'.featjob2 + 4.feated#`x'.featjob2) *0   + ///
							 (`x'.featjob2 + 5.feated#`x'.featjob2) *1/3   + ///
							 (`x'.featjob2 + 6.feated#`x'.featjob2) *1/3   + ///
							 (`x'.featjob2 + 7.feated#`x'.featjob2) *1/3 )	 
}

mat results[1,1] = 1
mat results[1,2] = 1
mat results[1,3] = r(estimate)
mat results[1,4] = r(se)

// Germany (Low Prejudice)

qui: reg chosen_immigrant i.featgender i.feated##i.featjob2 i.featlang i.featexp ib3.featplans i.feattrips [pweight=weight2] if featcountry==1&subset==1,  cl(caseid)

foreach x of numlist 9 {
lincom  (`x'.featjob2 *0    + (`x'.featjob2 + 2.feated#`x'.featjob2) *0   + /// 
                             (`x'.featjob2 + 3.feated#`x'.featjob2) *0   + ///
                             (`x'.featjob2 + 4.feated#`x'.featjob2) *0   + ///
							 (`x'.featjob2 + 5.feated#`x'.featjob2) *1/3   + ///
							 (`x'.featjob2 + 6.feated#`x'.featjob2) *1/3   + ///
							 (`x'.featjob2 + 7.feated#`x'.featjob2) *1/3 )	 
}

mat results[2,1] = 2
mat results[2,2] = 1
mat results[2,3] = r(estimate)
mat results[2,4] = r(se)


// France (High Prejudice)

qui: reg chosen_immigrant i.featgender i.feated##i.featjob2 i.featlang i.featexp ib3.featplans i.feattrips [pweight=weight2] if featcountry==2&subset==0,  cl(caseid)

foreach x of numlist 9 {
lincom  (`x'.featjob2 *0    + (`x'.featjob2 + 2.feated#`x'.featjob2) *0   + /// 
                             (`x'.featjob2 + 3.feated#`x'.featjob2) *0   + ///
                             (`x'.featjob2 + 4.feated#`x'.featjob2) *0   + ///
							 (`x'.featjob2 + 5.feated#`x'.featjob2) *1/3   + ///
							 (`x'.featjob2 + 6.feated#`x'.featjob2) *1/3   + ///
							 (`x'.featjob2 + 7.feated#`x'.featjob2) *1/3 )	 
}

mat results[3,1] = 1
mat results[3,2] = 2
mat results[3,3] = r(estimate)
mat results[3,4] = r(se)

// France (Low Prejudice)

qui: reg chosen_immigrant i.featgender i.feated##i.featjob2 i.featlang i.featexp ib3.featplans i.feattrips [pweight=weight2] if featcountry==2&subset==1,  cl(caseid)

foreach x of numlist 9 {
lincom  (`x'.featjob2 *0    + (`x'.featjob2 + 2.feated#`x'.featjob2) *0   + /// 
                             (`x'.featjob2 + 3.feated#`x'.featjob2) *0   + ///
                             (`x'.featjob2 + 4.feated#`x'.featjob2) *0   + ///
							 (`x'.featjob2 + 5.feated#`x'.featjob2) *1/3   + ///
							 (`x'.featjob2 + 6.feated#`x'.featjob2) *1/3   + ///
							 (`x'.featjob2 + 7.feated#`x'.featjob2) *1/3 )	 
}

mat results[4,1] = 2
mat results[4,2] = 2
mat results[4,3] = r(estimate)
mat results[4,4] = r(se)

// Poland (High Prejudice)

qui: reg chosen_immigrant i.featgender i.feated##i.featjob2 i.featlang i.featexp ib3.featplans i.feattrips [pweight=weight2] if featcountry==5&subset==0,  cl(caseid)

foreach x of numlist 9 {
lincom  (`x'.featjob2 *0    + (`x'.featjob2 + 2.feated#`x'.featjob2) *0   + /// 
                             (`x'.featjob2 + 3.feated#`x'.featjob2) *0   + ///
                             (`x'.featjob2 + 4.feated#`x'.featjob2) *0   + ///
							 (`x'.featjob2 + 5.feated#`x'.featjob2) *1/3   + ///
							 (`x'.featjob2 + 6.feated#`x'.featjob2) *1/3   + ///
							 (`x'.featjob2 + 7.feated#`x'.featjob2) *1/3 )	 
}

mat results[5,1] = 1
mat results[5,2] = 3
mat results[5,3] = r(estimate)
mat results[5,4] = r(se)

// Poland (Low Prejudice)

qui: reg chosen_immigrant i.featgender i.feated##i.featjob2 i.featlang i.featexp ib3.featplans i.feattrips [pweight=weight2] if featcountry==5&subset==1,  cl(caseid)

foreach x of numlist 9 {
lincom  (`x'.featjob2 *0    + (`x'.featjob2 + 2.feated#`x'.featjob2) *0   + /// 
                             (`x'.featjob2 + 3.feated#`x'.featjob2) *0   + ///
                             (`x'.featjob2 + 4.feated#`x'.featjob2) *0   + ///
							 (`x'.featjob2 + 5.feated#`x'.featjob2) *1/3   + ///
							 (`x'.featjob2 + 6.feated#`x'.featjob2) *1/3   + ///
							 (`x'.featjob2 + 7.feated#`x'.featjob2) *1/3 )	 
}

mat results[6,1] = 2
mat results[6,2] = 3
mat results[6,3] = r(estimate)
mat results[6,4] = r(se)

// Mexico (High Prejudice)

qui: reg chosen_immigrant i.featgender i.feated##i.featjob2 i.featlang i.featexp ib3.featplans i.feattrips [pweight=weight2] if featcountry==3&subset==0,  cl(caseid)

foreach x of numlist 9 {
lincom  (`x'.featjob2 *0    + (`x'.featjob2 + 2.feated#`x'.featjob2) *0   + /// 
                             (`x'.featjob2 + 3.feated#`x'.featjob2) *0   + ///
                             (`x'.featjob2 + 4.feated#`x'.featjob2) *0   + ///
							 (`x'.featjob2 + 5.feated#`x'.featjob2) *1/3   + ///
							 (`x'.featjob2 + 6.feated#`x'.featjob2) *1/3   + ///
							 (`x'.featjob2 + 7.feated#`x'.featjob2) *1/3 )	 
}

mat results[7,1] = 1
mat results[7,2] = 4
mat results[7,3] = r(estimate)
mat results[7,4] = r(se)

// Mexico (Low Prejudice)

qui: reg chosen_immigrant i.featgender i.feated##i.featjob2 i.featlang i.featexp ib3.featplans i.feattrips [pweight=weight2] if featcountry==3&subset==1,  cl(caseid)

foreach x of numlist 9 {
lincom  (`x'.featjob2 *0    + (`x'.featjob2 + 2.feated#`x'.featjob2) *0   + /// 
                             (`x'.featjob2 + 3.feated#`x'.featjob2) *0   + ///
                             (`x'.featjob2 + 4.feated#`x'.featjob2) *0   + ///
							 (`x'.featjob2 + 5.feated#`x'.featjob2) *1/3   + ///
							 (`x'.featjob2 + 6.feated#`x'.featjob2) *1/3   + ///
							 (`x'.featjob2 + 7.feated#`x'.featjob2) *1/3 )	 
}

mat results[8,1] = 2
mat results[8,2] = 4
mat results[8,3] = r(estimate)
mat results[8,4] = r(se)

mat2txt, matrix(results) saving(occupation) replace


// ALL WHITE COUNTRIES

// White (High Prejudice)

qui: reg chosen_immigrant i.featgender i.feated##i.featjob2 i.featlang i.featexp ib3.featplans i.feattrips [pweight=weight2] if (featcountry==1|featcountry==2|featcountry==5)&subset==0,  cl(caseid)

foreach x of numlist 9 {
lincom  (`x'.featjob2 *0    + (`x'.featjob2 + 2.feated#`x'.featjob2) *0   + /// 
                             (`x'.featjob2 + 3.feated#`x'.featjob2) *0   + ///
                             (`x'.featjob2 + 4.feated#`x'.featjob2) *0   + ///
							 (`x'.featjob2 + 5.feated#`x'.featjob2) *1/3   + ///
							 (`x'.featjob2 + 6.feated#`x'.featjob2) *1/3   + ///
							 (`x'.featjob2 + 7.feated#`x'.featjob2) *1/3 )	 
}



// White (Low Prejudice)

qui: reg chosen_immigrant i.featgender i.feated##i.featjob2 i.featlang i.featexp ib3.featplans i.feattrips [pweight=weight2] if (featcountry==1|featcountry==2|featcountry==5)&subset==1,  cl(caseid)

foreach x of numlist 9 {
lincom  (`x'.featjob2 *0    + (`x'.featjob2 + 2.feated#`x'.featjob2) *0   + /// 
                             (`x'.featjob2 + 3.feated#`x'.featjob2) *0   + ///
                             (`x'.featjob2 + 4.feated#`x'.featjob2) *0   + ///
							 (`x'.featjob2 + 5.feated#`x'.featjob2) *1/3   + ///
							 (`x'.featjob2 + 6.feated#`x'.featjob2) *1/3   + ///
							 (`x'.featjob2 + 7.feated#`x'.featjob2) *1/3 )	 
}







// EDUCATION




gen feated2 = feated
recode feated2 (1=1) (2=1) (3=1) (4=1) (5=2) (6=2) (7=3)


mat results = J(8,4,0)


// Germany (High Prejudice)

qui: reg chosen_immigrant i.featgender i.feated2##i.featjob2 i.featlang i.featexp ib3.featplans i.feattrips [pweight=weight2] if featcountry==1&subset==0,  cl(caseid)

foreach x of numlist 3(1)3 {
lincom  (`x'.feated2 * 1/7  + (`x'.feated2 + `x'.feated2#2.featjob2)  * 1/7 + /// 
                             (`x'.feated2 + `x'.feated2#3.featjob2)  * 1/7 + ///
                             (`x'.feated2 + `x'.feated2#4.featjob2)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#5.featjob2)  * 0 + ///
							 (`x'.feated2 + `x'.feated2#6.featjob2)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#7.featjob2)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#8.featjob2)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#9.featjob2)  * 0 )
}

mat results[1,1] = 1
mat results[1,2] = 1
mat results[1,3] = r(estimate)
mat results[1,4] = r(se)

// Germany (Low Prejudice)

qui: reg chosen_immigrant i.featgender i.feated2##i.featjob2 i.featlang i.featexp ib3.featplans i.feattrips [pweight=weight2] if featcountry==1&subset==1,  cl(caseid)

foreach x of numlist 3(1)3 {
lincom  (`x'.feated2 * 1/7  + (`x'.feated2 + `x'.feated2#2.featjob2)  * 1/7 + /// 
                             (`x'.feated2 + `x'.feated2#3.featjob2)  * 1/7 + ///
                             (`x'.feated2 + `x'.feated2#4.featjob2)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#5.featjob2)  * 0 + ///
							 (`x'.feated2 + `x'.feated2#6.featjob2)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#7.featjob2)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#8.featjob2)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#9.featjob2)  * 0 )
}

mat results[2,1] = 2
mat results[2,2] = 1
mat results[2,3] = r(estimate)
mat results[2,4] = r(se)


// France (High Prejudice)

qui: reg chosen_immigrant i.featgender i.feated2##i.featjob2 i.featlang i.featexp ib3.featplans i.feattrips [pweight=weight2] if featcountry==2&subset==0,  cl(caseid)

foreach x of numlist 3(1)3 {
lincom  (`x'.feated2 * 1/7  + (`x'.feated2 + `x'.feated2#2.featjob2)  * 1/7 + /// 
                             (`x'.feated2 + `x'.feated2#3.featjob2)  * 1/7 + ///
                             (`x'.feated2 + `x'.feated2#4.featjob2)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#5.featjob2)  * 0 + ///
							 (`x'.feated2 + `x'.feated2#6.featjob2)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#7.featjob2)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#8.featjob2)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#9.featjob2)  * 0 )
}

mat results[3,1] = 1
mat results[3,2] = 2
mat results[3,3] = r(estimate)
mat results[3,4] = r(se)

// France (Low Prejudice)

qui: reg chosen_immigrant i.featgender i.feated2##i.featjob2 i.featlang i.featexp ib3.featplans i.feattrips [pweight=weight2] if featcountry==2&subset==1,  cl(caseid)

foreach x of numlist 3(1)3 {
lincom  (`x'.feated2 * 1/7  + (`x'.feated2 + `x'.feated2#2.featjob2)  * 1/7 + /// 
                             (`x'.feated2 + `x'.feated2#3.featjob2)  * 1/7 + ///
                             (`x'.feated2 + `x'.feated2#4.featjob2)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#5.featjob2)  * 0 + ///
							 (`x'.feated2 + `x'.feated2#6.featjob2)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#7.featjob2)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#8.featjob2)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#9.featjob2)  * 0 )
}

mat results[4,1] = 2
mat results[4,2] = 2
mat results[4,3] = r(estimate)
mat results[4,4] = r(se)

// Poland (High Prejudice)

qui: reg chosen_immigrant i.featgender i.feated2##i.featjob2 i.featlang i.featexp ib3.featplans i.feattrips [pweight=weight2] if featcountry==5&subset==0,  cl(caseid)

foreach x of numlist 3(1)3 {
lincom  (`x'.feated2 * 1/7  + (`x'.feated2 + `x'.feated2#2.featjob2)  * 1/7 + /// 
                             (`x'.feated2 + `x'.feated2#3.featjob2)  * 1/7 + ///
                             (`x'.feated2 + `x'.feated2#4.featjob2)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#5.featjob2)  * 0 + ///
							 (`x'.feated2 + `x'.feated2#6.featjob2)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#7.featjob2)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#8.featjob2)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#9.featjob2)  * 0 )
}

mat results[5,1] = 1
mat results[5,2] = 3
mat results[5,3] = r(estimate)
mat results[5,4] = r(se)

// Poland (Low Prejudice)

qui: reg chosen_immigrant i.featgender i.feated2##i.featjob2 i.featlang i.featexp ib3.featplans i.feattrips [pweight=weight2] if featcountry==5&subset==1,  cl(caseid)

foreach x of numlist 3(1)3 {
lincom  (`x'.feated2 * 1/7  + (`x'.feated2 + `x'.feated2#2.featjob2)  * 1/7 + /// 
                             (`x'.feated2 + `x'.feated2#3.featjob2)  * 1/7 + ///
                             (`x'.feated2 + `x'.feated2#4.featjob2)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#5.featjob2)  * 0 + ///
							 (`x'.feated2 + `x'.feated2#6.featjob2)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#7.featjob2)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#8.featjob2)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#9.featjob2)  * 0 )
}

mat results[6,1] = 2
mat results[6,2] = 3
mat results[6,3] = r(estimate)
mat results[6,4] = r(se)

// Mexico (High Prejudice)

qui: reg chosen_immigrant i.featgender i.feated2##i.featjob2 i.featlang i.featexp ib3.featplans i.feattrips [pweight=weight2] if featcountry==3&subset==0,  cl(caseid)

foreach x of numlist 3(1)3 {
lincom  (`x'.feated2 * 1/7  + (`x'.feated2 + `x'.feated2#2.featjob2)  * 1/7 + /// 
                             (`x'.feated2 + `x'.feated2#3.featjob2)  * 1/7 + ///
                             (`x'.feated2 + `x'.feated2#4.featjob2)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#5.featjob2)  * 0 + ///
							 (`x'.feated2 + `x'.feated2#6.featjob2)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#7.featjob2)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#8.featjob2)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#9.featjob2)  * 0 )
}

mat results[7,1] = 1
mat results[7,2] = 4
mat results[7,3] = r(estimate)
mat results[7,4] = r(se)

// Mexico (Low Prejudice)

qui: reg chosen_immigrant i.featgender i.feated2##i.featjob2 i.featlang i.featexp ib3.featplans i.feattrips [pweight=weight2] if featcountry==3&subset==1,  cl(caseid)

foreach x of numlist 3(1)3 {
lincom  (`x'.feated2 * 1/7  + (`x'.feated2 + `x'.feated2#2.featjob2)  * 1/7 + /// 
                             (`x'.feated2 + `x'.feated2#3.featjob2)  * 1/7 + ///
                             (`x'.feated2 + `x'.feated2#4.featjob2)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#5.featjob2)  * 0 + ///
							 (`x'.feated2 + `x'.feated2#6.featjob2)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#7.featjob2)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#8.featjob2)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#9.featjob2)  * 0 )
}

mat results[8,1] = 2
mat results[8,2] = 4
mat results[8,3] = r(estimate)
mat results[8,4] = r(se)

mat2txt, matrix(results) saving(education) replace



// White Country (High Prejudice)

qui: reg chosen_immigrant i.featgender i.feated2##i.featjob2 i.featlang i.featexp ib3.featplans i.feattrips [pweight=weight2] if (featcountry==1|featcountry==2|featcountry==5)&subset==0,  cl(caseid)

foreach x of numlist 3(1)3 {
lincom  (`x'.feated2 * 1/7  + (`x'.feated2 + `x'.feated2#2.featjob2)  * 1/7 + /// 
                             (`x'.feated2 + `x'.feated2#3.featjob2)  * 1/7 + ///
                             (`x'.feated2 + `x'.feated2#4.featjob2)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#5.featjob2)  * 0 + ///
							 (`x'.feated2 + `x'.feated2#6.featjob2)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#7.featjob2)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#8.featjob2)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#9.featjob2)  * 0 )
}


// White Country (Low Prejudice)

qui: reg chosen_immigrant i.featgender i.feated2##i.featjob2 i.featlang i.featexp ib3.featplans i.feattrips [pweight=weight2] if (featcountry==1|featcountry==2|featcountry==5)&subset==1,  cl(caseid)

foreach x of numlist 3(1)3 {
lincom  (`x'.feated2 * 1/7  + (`x'.feated2 + `x'.feated2#2.featjob2)  * 1/7 + /// 
                             (`x'.feated2 + `x'.feated2#3.featjob2)  * 1/7 + ///
                             (`x'.feated2 + `x'.feated2#4.featjob2)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#5.featjob2)  * 0 + ///
							 (`x'.feated2 + `x'.feated2#6.featjob2)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#7.featjob2)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#8.featjob2)  * 1/7 + ///
							 (`x'.feated2 + `x'.feated2#9.featjob2)  * 0 )
}





















