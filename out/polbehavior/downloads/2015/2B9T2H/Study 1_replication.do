/*table 1, top panel*/

/*english is langauge treatment indicator*/

reg totalknow english

reg nonlatknow english

oprobit latknow english

reg american english

reg latino english

reg nationid english

reg republican english

reg obama english

reg conservative english


/*figure 1, use intercepts and coefficients for english from above results*/


/*table 2, columns A and B*/

reg avglogus english avgslow age educ prefspan

reg avglogus english avgslow engslow age educ prefspan, robust


/*table 3, columns A and B*/

probit refusals01 english avgslow age educ prefspan

probit refusals01 english avgslow engslow age educ prefspan, robust


/*table 4, top panel*/

medeff (regress anxious english) (regress latino english anxious), mediate(anxious) treat(english) sims(1000) seed(3) level (90)
medeff (regress anxious english) (regress latino english anxious), mediate(anxious) treat(english) sims(1000) seed(3) level (80)

medeff (regress anxious english) (regress nationid english anxious), mediate(anxious) treat(english) sims(1000) seed(3) level (90)

medeff (regress anxious english) (regress totalknow english anxious), mediate(anxious) treat(english) sims(1000) seed(3) level (90)

medeff (regress anxious english) (regress nonlatknow english anxious), mediate(anxious) treat(english) sims(1000) seed(3) level (90)


**********************
*  SI results ********
**********************

/*table A*/

tab usborn

tab citizen

tab mexican

tab border

tab male 

summ ages, detail

summ edu, detail

summ income, detail

summ partyid, detail


/* table B*/

probit english usborn citizen mexican border male age educ inc partyid

test usborn citizen mexican border male age educ inc partyid


/*table C*/

tab usborn english, chi2

tab citizen english, chi2

tab mexican english, chi2

tab border english, chi2

tab male english, chi2

tab edu english, chi2

tab partyid english, chi2

gen age42=0
recode age42 (0=1) if ages>=42
tab age42 english, chi2

gen income12=0
recode income12 (0=1) if income>=12
tab income12 english, chi2


/*table E*/

medeff (regress avglogus english) (regress nonlatknow english avglogus), mediate(avglogus) treat(english) sims(1000) seed(3) level (90)


/*table F*/

tab anxious if english==1
tab anxious if english==0
tab anxious english, chi2

tab angry if english==1
tab angry if english==0
tab angry english, chi2

tab proud if english==1
tab proud if english==0
tab proud english, chi2

tab efficacy if english==1
tab efficacy if english==0
tab efficacy english, chi2

/*table G*/

gen prefeng=0
recode prefeng (0=1) if prefspan==0
tab prefeng

gen engprefing=(english*prefeng)

reg nonlatknow english prefeng engprefing, robust
reg american english prefeng engprefing, robust
reg latino english prefeng engprefing, robust
reg nationid english prefeng engprefing, robust
reg obama english prefeng engprefing, robust
reg conservative english prefeng engprefing, robust
reg republican english prefeng engprefing, robust


/*table H*/

gen engnative=(english*usborn)

reg nonlatknow english usborn engnative, robust
reg american english usborn engnative, robust
reg latino english usborn engnative, robust
reg nationid english usborn engnative, robust
reg obama english usborn engnative, robust
reg conservative english usborn engnative, robust
reg republican english usborn engnative, robust
