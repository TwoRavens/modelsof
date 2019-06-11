set more off

/*table 1, except for latin american knowledge - see file LA Knowledge_Study2*/

oprobit know1 english 
reg american english
reg latino english
reg origin english

reg republican english
reg obama1 english
reg ideology english


/*figure 1, use intercepts and coefficient for english*/


/*table 2, columns C and D*/

reg avglogus english meanslowUS ages edu prefspan

reg avglogus english meanslowUS engmeanUS ages edu prefspan, robust


/*table 3, columns C and D*/

probit refuseUS2 english meanslowUS ages edu prefspan
probit refuseUS2 english meanslowUS engmeanUS ages edu prefspan, robust


/*table 4*/

medeff (regress anxious english) (regress american english anxious), mediate(anxious) treat(english) sims(1000) seed(3) level (90)

medeff (regress anxious english) (regress latino english anxious), mediate(anxious) treat(english) sims(1000) seed(3) level (90)

gen know2=(know1/3)
summ know2

medeff (regress anxious english) (regress know2 english anxious), mediate(anxious) treat(english) sims(1000) seed(3) level (90)

medeff (regress efficacy english) (regress american english efficacy), mediate(efficacy) treat(english) sims(1000) seed(3) level (90)

medeff (regress efficacy english) (regress latino english efficacy), mediate(efficacy) treat(english) sims(1000) seed(3) level (90)

medeff (regress efficacy english) (regress know2 english efficacy), mediate(efficacy) treat(english) sims(1000) seed(3) level (90)


**********************
*  SI results ********
**********************

/*table A*/

tab native 

tab citizen 

tab mexican 

tab border 

tab male 

summ age, detail

summ educ, detail

summ inc, detail

summ partyid, detail


/*table B*/

probit english native citizen mexican border male age educ inc partyid

test native citizen mexican border male age educ inc partyid


/*table C*/

tab native english, chi2
tab citizen english, chi2
tab mexican english, chi2
tab border english, chi2
tab male english, chi2
tab educ english, chi2
tab partyid english, chi2

gen age42=0
recode age42 (0=1) if age>=42
tab age42 english, chi2

gen inc11=0
recode inc11 (0=1) if inc>=11
tab inc11 english,chi2


/*table E*/

medeff (regress avglogus english) (regress know2 english avglogus), mediate(avglogus) treat(english) sims(1000) seed(3) level (90)


/*table F*/

tab anxious if english==1
tab anxious if english==0
tab anxious english, chi2

tab angry if english==1
tab angry if english==0
tab angry english, chi2

tab pride if english==1
tab pride if english==0
tab pride english, chi2

tab efficacy if english==1
tab efficacy if english==0
tab efficacy english, chi2


/*table G*/

gen prefeng=0
recode prefeng (0=1) if prefspan==0
tab prefeng

gen engprefeng=(english*prefeng)

oprobit know1 english prefeng engprefeng, robust

reg american english prefeng engprefeng, robust

reg latino english prefeng engprefeng, robust

reg origin english prefeng engprefeng, robust

reg obama1 english prefeng engprefeng, robust

reg ideology english prefeng engprefeng, robust

reg republican english prefeng engprefeng, robust


/*table H*/

gen engnative=(english*native)

oprobit know1 english native engnative, robust

reg american english native engnative, robust

reg latino english native engnative, robust

reg origin english native engnative, robust

reg obama1 english native engnative, robust

reg ideology english native engnative, robust

reg republican english native engnative, robust


