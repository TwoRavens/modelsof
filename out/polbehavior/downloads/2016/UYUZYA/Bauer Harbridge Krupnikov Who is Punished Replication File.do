//Replication file for "Who is Punished? 
//Conditions Affecting Voter Evaluations of Legislators who Do Not Compromise"
//Nichole Bauer, Laurel Harbridge, Yanna Krupnikov

**Treatment Codes 
**1 = Compromise, woman of your pid
**2 = No compromise, woman of your pid
**5 = Compromise, woman of NOT your pid
**6 = No compromise, woman of NOT your pid
**3 = Compromise, man of your pid
**4 = No compromise, man of your pid
**7 = Compromise, man of NOT your pid
**8 = No compromise, man of NOT your pid


/////////////////////////////////////////////////
//              Study 1: Energy                //
/////////////////////////////////////////////////
//load Bauer_Harbridge_Krupnikov_study_1_energy.dta

//Note on outcome variables: fave_unfave, constituents, leadership are original variables; 
//fave_unfave1, constituents1, leadership1 are re-coded versions from 0-1, with 1 indcating highest agreement with question/statement

///////////////////////////////////////////////////////////////
//Descriptives of who punishes more/less for not compromising//
///////////////////////////////////////////////////////////////
gen female = 0
replace female=1 if gender==2
tab female

gen no_comp = .
replace no_comp=0 if treat==1 | treat==5 | treat==3 | treat==7
replace no_comp=1 if treat==2 | treat==6 | treat==4 | treat==8

**favorability
reg fave_unfave1 no_comp republican no_comp##republican if treat==1 | treat==2 | treat==5 | treat==6 | treat==3 | treat==4 |treat==7 | treat==8
** effect of not compromising is lower among Republicans

reg fave_unfave1 no_comp female no_comp##female if treat==1 | treat==2 | treat==5 | treat==6 | treat==3 | treat==4 |treat==7 | treat==8
** no difference in effect of not compromising among men versus women

**Randomization check with a multinomial logit: 

mlogit treat female educ income self_ideo


/////////////////////////////////////
// Cost of Not Compromising and DID//
/////////////////////////////////////
//With 0-1 scale of DV
//diff-in-diff
//ttesti  [N from result 1] [difference from result 1] [std dev from pooled result 1] [N from result 2] [difference from result 2] [std dev from pooled result 2], unequal

**fav_unfav1
//Table 2 (and Appendix A6.1)
*Own PID, female versus male
ttest fave_unfave1 if ((treat==1|treat==2)), by(treat)
ttest fave_unfave1 if ((treat==3|treat==4)), by(treat) 
ttesti 208 .117123 .2104224 199 .0626599 .2044778, unequal

*Other PID, female versus male
ttest fave_unfave1 if ((treat==5|treat==6)), by(treat) 
ttest fave_unfave1 if ((treat==7|treat==8)), by(treat) 
ttesti 194 .1288363 .2560351 207 .1787316 .2578217, unequal

//Table 3 (and Appendix A6.2)
**female, own PID versus other PID
*female, own PID
ttest fave_unfave1 if ((treat==1|treat==2)), by(treat) 
*female, other PID
ttest fave_unfave1 if ((treat==5|treat==6)), by(treat) 
ttesti  208 0.117123 0.2104224 194 0.1299363 0.2560351, unequal

*male, own PID versus other PID
*male, own PID
ttest fave_unfave1 if ((treat==3|treat==4)), by(treat) 
*male, other PID
ttest fave_unfave1 if ((treat==7|treat==8)), by(treat) 
ttesti  199 .0626599  .2044778 207 .1787316 .2578217, unequal



**Bailey is a good rep of constituents
//Appendix A6.1
*Own PID, female versus male
ttest constituents1 if ((treat==1|treat==2)), by(treat)
ttest constituents1 if ((treat==3|treat==4)), by(treat) 
ttesti 213 .0857975 .2230773 203  .0581165 .2249909, unequal

*Other PID, female versus male
ttest constituents1 if ((treat==5|treat==6)), by(treat) 
ttest constituents1 if ((treat==7|treat==8)), by(treat) 
ttesti 199 .0844862 .2561462 213 .1223478 .2563603, unequal

//Table 3 (and Appendix A6.2)
**female, own PID versus other PID
ttest constituents1 if ((treat==1|treat==2)), by(treat) 
ttest constituents1 if ((treat==5|treat==6)), by(treat) 
ttesti 213 .0857975 .2230773 199 .0844862 .2561462, unequal

*male, own PID versus other PID
ttest constituents1 if ((treat==3|treat==4)), by(treat) 
ttest constituents1 if ((treat==7|treat==8)), by(treat) 
ttesti 203 .0581165 .2249909 213 .1223478 .2563603, unequal


**Rise in leadership
**0=highly unlikely, 1=highly likely
//Appendix A6.1
*Own PID, female versus male
ttest leadership1 if (treat==1|treat==2), by(treat)
ttest leadership1 if (treat==3|treat==4), by(treat) 
ttesti  211 .1261468 .2394584 204 .0399038 .2356009, unequal

*Other PID, female versus male
ttest leadership1 if (treat==5|treat==6), by(treat) 
ttest leadership1 if (treat==7|treat==8), by(treat) 
ttesti  198 .0982882 .2798279 212 .131402 .2602065, unequal

//Appendix A6.2
**female, own PID versus other PID
*female, own PID
ttest leadership1 if (treat==1|treat==2), by(treat) 
*female, other PID
ttest leadership1 if (treat==5|treat==6), by(treat)  
ttesti  211 .1261468 .2394584 198 .0982882 .2798279, unequal

*male, own PID versus other PID
*male, own PID
ttest leadership1 if (treat==3|treat==4), by(treat)  
*male, other PID
ttest leadership1 if (treat==7|treat==8), by(treat)
ttesti  204 .0399038 .2356009 212 .131402 .2602065, unequal


///////////////////////////////////////////
//Check outcome if don't reach compromise//
///////////////////////////////////////////
*1=dems pass, 2=reps pass, 3=gridlock
replace outcome=. if outcome==-99
tab outcome treat
//Overall, 177 said Dems pass, 116 said Reps pass, 522 said Gridlock

///////////////////////////////
//Web Appendix 4 Sample ///////
//////////////////////////////

tab female

**education is measured categorically, 1=no HS, 2=HS, 3=some college, 4=AA, 5=BA, 
**6=graduate or professional degree
tab educ

**income is measured categorically, 1=<10k, 2=10k-20k, 3=20-30K, 4=30-40k,
**5=40-50k, 6=50-75k, 7=75-100k, 8=100-150, 9=150k or more
tab income

sum self_ideo

///////////////////////////////
//Web Appendix 5 Group Means//
//////////////////////////////

ttest fave_unfave1 if (treat==1|treat==2), by(treat)
ttest fave_unfave1 if (treat==3|treat==4), by(treat)
ttest fave_unfave1 if (treat==5|treat==6), by(treat)
ttest fave_unfave1 if (treat==7|treat==8), by(treat)

ttest constituents1 if (treat==1|treat==2), by(treat)
ttest constituents1 if (treat==3|treat==4), by(treat)
ttest constituents1 if (treat==5|treat==6), by(treat)
ttest constituents1 if (treat==7|treat==8), by(treat)

ttest leadership1 if (treat==1|treat==2), by(treat)
ttest leadership1 if (treat==3|treat==4), by(treat)
ttest leadership1 if (treat==5|treat==6), by(treat)
ttest leadership1 if (treat==7|treat==8), by(treat)

clear

/////////////////////////////////////////////////
//      Study 2: Early Childhood Education     //
/////////////////////////////////////////////////
//load Bauer_Harbridge_Krupnikov_study_2_early_childhood_education.dta

//Note on outcome variables: fave_unfave, constituents, leadership are original variables; 
//fave_unfave1, constituents1, leadership1 are re-coded versions from 0-1, with 1 indcating highest agreement with question/statement


///////////////////////////////////////////////////////////////
//Descriptives of who punishes more/less for not compromising//
///////////////////////////////////////////////////////////////
gen female = 0
replace female=1 if gender==2

gen no_comp = .
replace no_comp=0 if treat==1 | treat==5 | treat==3 | treat==7
replace no_comp=1 if treat==2 | treat==6 | treat==4 | treat==8

**favorability
reg fave_unfave1 no_comp republican no_comp##republican if treat==1 | treat==2 | treat==5 | treat==6 | treat==3 | treat==4 |treat==7 | treat==8
** effect of not compromising is lower among Republicans

reg fave_unfave1 no_comp female no_comp##female if treat==1 | treat==2 | treat==5 | treat==6 | treat==3 | treat==4 |treat==7 | treat==8
** no difference in effect of not compromising among men versus women

**Randomization check with a multinomial logit: 

mlogit treat female educ income self_ideo


/////////////////////////////////////
// Cost of Not Compromising and DID//
/////////////////////////////////////
//With 0-1 coding of DV
//diff-in-diff
//ttesti  [N from result 1] [difference from result 1] [std dev from pooled result 1] [N from result 2] [difference from result 2] [std dev from pooled result 2], unequal

**fav_unfav1
//Table 2 (and Appendix A6.1)
*Own PID, female versus male
ttest fave_unfave1 if (treat==1|treat==2), by(treat)
ttest fave_unfave1 if (treat==3|treat==4), by(treat) 
ttesti  195 .0521951 .2259425 197 .1219759 .225912, unequal

*Other PID, female versus male
ttest fave_unfave1 if (treat==5|treat==6), by(treat) 
ttest fave_unfave1 if (treat==7|treat==8), by(treat) 
ttesti 197 .1750344 .2453277 194 .1660641 .2642429, unequal

//Table 3 (and Appendix A6.2)
**female, own PID versus other PID
*female, own PID
ttest fave_unfave1 if (treat==1|treat==2), by(treat) 
*female, other PID
ttest fave_unfave1 if (treat==5|treat==6), by(treat) 
ttesti  195 .0521951 .2259425  197 .1750344 .2453277, unequal

*male, own PID versus other PID
*male, own PID
ttest fave_unfave1 if (treat==3|treat==4), by(treat) 
*male, other PID
ttest fave_unfave1 if (treat==7|treat==8), by(treat) 
ttesti  197 .1219759 .225912 194 .1660641 .2642429 , unequal


**Bailey a good rep of constituents
//Appendix A6.1
*Own PID, female versus male
ttest constituents1 if (treat==1|treat==2), by(treat)
ttest constituents1 if (treat==3|treat==4), by(treat) 
ttesti  197 .0714492 .2268015 201 .1451881 .2427332 , unequal

*Other PID, female versus male
ttest constituents1 if (treat==5|treat==6), by(treat) 
ttest constituents1 if (treat==7|treat==8), by(treat) 
ttesti 201 .1753663 .2642477 199 .1228485 .2511958, unequal

//Appendix A6.2
**female, own PID versus other PID
*female, own PID
ttest constituents1 if (treat==1|treat==2), by(treat) 
*female, other PID
ttest constituents1 if (treat==5|treat==6), by(treat) 
ttesti  197 .0714492  .2268015  201 .1753663 .2642477, unequal

*male, own PID versus other PID
*male, own PID
ttest constituents1 if (treat==3|treat==4), by(treat) 
*male, other PID
ttest constituents1 if (treat==7|treat==8), by(treat) 
ttesti  201 .1451881 .2427332  199 .1228485 .2511958, unequal


**Rise in leadership
**0=highly unlikley, 1=highly likely
//Appendix A6.1
*Own PID, female versus male
ttest leadership1 if (treat==1|treat==2), by(treat)
ttest leadership1 if (treat==3|treat==4), by(treat) 
ttesti 197 .0592146 .2366009 200 .11 .2513656, unequal

*Other PID, female versus male
ttest leadership1 if (treat==5|treat==6), by(treat) 
ttest leadership1 if (treat==7|treat==8), by(treat) 
ttesti 200 .1 .2533197 199 .1225253 .24354, unequal

//Appendix A6.2
**female, own PID versus other PID
*female, own PID
ttest leadership1 if (treat==1|treat==2), by(treat) 
*female, other PID
ttest leadership1 if (treat==5|treat==6), by(treat)  
ttesti 197 .0592146 .2366009  200 .1 .2533197, unequal

*male, own PID versus other PID
*male, own PID
ttest leadership1 if (treat==3|treat==4), by(treat) 
*male, other PID
ttest leadership1 if (treat==7|treat==8), by(treat) 
ttesti 200 .11 .2513656 199 .1225253 .24354, unequal



///////////////////////////////////////////
//Check outcome if don't reach compromise//
///////////////////////////////////////////
*1=dems pass, 2=reps pass, 3=gridlock
replace outcome=. if outcome==-99
tab outcome treat 
//Overall, 169 said Dems pass, 132 said Reps pass, 484 said Gridlock


///////////////////////////////
//Web Appendix 4 Sample ///////
//////////////////////////////

tab female

**education is measured categorically, 1=no HS, 2=HS, 3=some college, 4=AA, 5=BA, 
**6=graduate or professional degree
tab educ

**income is measured categorically, 1=<10k, 2=10k-20k, 3=20-30K, 4=30-40k,
**5=40-50k, 6=50-75k, 7=75-100k, 8=100-150, 9=150k or more
tab income

sum self_ideo


///////////////////////////////
//Web Appendix 5 Group Means//
//////////////////////////////

ttest fave_unfave1 if (treat==1|treat==2), by(treat)
ttest fave_unfave1 if (treat==3|treat==4), by(treat)
ttest fave_unfave1 if (treat==5|treat==6), by(treat)
ttest fave_unfave1 if (treat==7|treat==8), by(treat)

ttest constituents1 if (treat==1|treat==2), by(treat)
ttest constituents1 if (treat==3|treat==4), by(treat)
ttest constituents1 if (treat==5|treat==6), by(treat)
ttest constituents1 if (treat==7|treat==8), by(treat)

ttest leadership1 if (treat==1|treat==2), by(treat)
ttest leadership1 if (treat==3|treat==4), by(treat)
ttest leadership1 if (treat==5|treat==6), by(treat)
ttest leadership1 if (treat==7|treat==8), by(treat)

