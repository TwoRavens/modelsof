*McDonald Karol Mason - "'An Inherited Money Dude from Queens County’: How Unseen Candidate Characteristics Affect Voter Perceptions"
*Political Behavior
*Replication Code

***DATA***

*Aug 2016 SSI Poll
use "Aug 2016 SSI replication.dta", clear

*Oct 2017 UMD Critical Issues Poll
use "Oct 2017 CI replication.dta", clear

*June 2018 UMD Critical Issues Poll
use "June 2018 CI replication.dta", clear

*Nov 2018 Amazon MTurk Survey
use "Nov 2018 MTurk replication.dta", clear

***FIGURE 1***

*2016 SSI
tab trumpdadwealth [aw=pid_wt]

*2017 Critical Issues Poll
tab trumpwealth [aw=weight1]

*2018 Critical Issues Poll
tab Q54A [aw=Weight]

***TABLE 1***

*2016 SSI

probit polknow5correct democrat polinterest educ age faminc male

***FIGURE 2 & TABLE A1***

*2016 SSI

probit polknow5correct i.democrat2party polknow
margins democrat2party, at (polknow=(0(1)4)) asobserved
marginsplot, recastci(rarea) 

***MEDIATION ANALYSES: FIGURE 3 & TABLES A2-A4***

*2017 Critical Issues Poll

medeff (regress trumpcaresstand trumpwealth pid7 pdemage pdemed hdemhhinc male white) (regress trumpappstand trumpwealth trumpcaresstand pid7 pdemage pdemed hdemhhinc male white) , treat(trumpwealth) mediate(trumpcaresstand) sims(1000) seed(1) level(99), [pw=weight1]
medeff (regress trumpgoodatbizstand trumpwealth pid7 pdemage pdemed hdemhhinc male white) (regress trumpappstand trumpwealth trumpgoodatbizstand pid7 pdemage pdemed hdemhhinc male white) , treat(trumpwealth) mediate(trumpgoodatbizstand) sims(1000) seed(1) level(99), [pw=weight1]

***EXPERIMENTAL ANALYSES: FIGURES 4-5 & TABLE A5A-Table A5B

*2018 Critical Issues Poll

*Figure 4

bysort pid3: reg trumpcaresstand treatmentcond [aw=Weight] if questioncond!=1

*Figure 5

bysort pid3: reg trumpbizstand treatmentcond [aw=Weight] if questioncond!=1

*2018 MTurk Survey

reg trumpjobstand treatment
reg trumpcaresstand treatment
reg trumpbizstand treatment

***RANDOMIZATION CHECKS: TABLE A6a-A6b***

*June 2018 UMD Critical Issues Poll - Among Democrats

probit treatedvscontrol white [pw=Weight] if pid3==1
probit treatedvscontrol male [pw=Weight] if pid3==1
probit treatedvscontrol faminc [pw=Weight] if pid3==1
probit treatedvscontrol age [pw=Weight] if pid3==1
probit treatedvscontrol educ [pw=Weight] if pid3==1
probit treatedvscontrol white male faminc age educ [pw=Weight] if pid3==1

*June 2018 UMD Critical Issues Poll - Among Republicans

probit treatedvscontrol white [pw=Weight] if pid3==3
probit treatedvscontrol male [pw=Weight] if pid3==3
probit treatedvscontrol faminc [pw=Weight] if pid3==3
probit treatedvscontrol age [pw=Weight] if pid3==3
probit treatedvscontrol educ [pw=Weight] if pid3==3
probit treatedvscontrol white male faminc age educ [pw=Weight] if pid3==3

*Nov 2018 MTurk Survey

probit treatment pid7 white male faminc age educ

***FREQUENCIES***

*2016 SSI

tab pid3
tab agecat
tab edu4cat
tab race
tab male
tab faminc3

**2017 Critical Issues Poll

tab pid3
tab agecat
tab edu4cat
tab race
tab male
tab faminc3

*2018 Critical Issues Poll

tab pid3
tab agecat
tab edu4cat
tab race
tab male
tab faminc3

