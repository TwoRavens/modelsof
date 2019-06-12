***we have sociodemographic weights for each survey
svyset [pw=POST_WEIGHT1]

******************************************************
******************************************************
*** The syntax below conducts tests for each survey **
*** in the same order as they appear in the  *********
****journal article. These were used to generate *****
****Figure 1 and some lements of Table A6. . *********
******************************************************


***Marseille municipal***Marseille municipal***Marseille municipal
svy: logit voted  i.exp_complx if ELECID==23
margins exp_complx, post
margins, coeflegend
lincom _b[1.exp_complx] -  _b[0bn.exp_complx], level(95)
lincom _b[1.exp_complx] -  _b[0bn.exp_complx], level(99)
gen effectsize=(r(estimate)) in 1

***Paris municipal***Paris municipal***Paris municipal
svy: logit voted  i.exp_complx if ELECID==22
margins exp_complx, post
margins, coeflegend
lincom _b[1.exp_complx] -  _b[0bn.exp_complx], level(95)
lincom _b[1.exp_complx] -  _b[0bn.exp_complx], level(99)
replace effectsize=(r(estimate)) in 2

*** Catalonia regional*** Catalonia regional*** Catalonia regional
svy: logit voted  i.exp_complx if ELECID==8
margins exp_complx, post
margins, coeflegend
lincom _b[1.exp_complx] -  _b[0bn.exp_complx], level(95)
lincom _b[1.exp_complx] -  _b[0bn.exp_complx], level(99)
replace effectsize=(r(estimate)) in 3

***Lucerne regional***Lucerne regional***Lucerne regional
svy: logit voted  i.exp_complx if ELECID==2
margins exp_complx, post
margins, coeflegend
lincom _b[1.exp_complx] -  _b[0bn.exp_complx], level(95)
lincom _b[1.exp_complx] -  _b[0bn.exp_complx], level(99)
replace effectsize=(r(estimate)) in 4

***Zurich regrional***Zurich regrional***Zurich regrional
svy: logit voted  i.exp_complx if ELECID==4
margins exp_complx, post
margins, coeflegend
lincom _b[1.exp_complx] -  _b[0bn.exp_complx], level(95)
lincom _b[1.exp_complx] -  _b[0bn.exp_complx], level(99)
replace effectsize=(r(estimate)) in 5

*** Quebec regional*** Quebec regional*** Quebec regional
svy: logit voted  i.exp_complx if ELECID==15
margins exp_complx, post
margins, coeflegend
lincom _b[1.exp_complx] -  _b[0bn.exp_complx], level(95)
lincom _b[1.exp_complx] -  _b[0bn.exp_complx], level(99)
replace effectsize=(r(estimate)) in 6

*** Lower Saxony regional*** Lower Saxony regional*** Lower Saxony regional
svy: logit voted  i.exp_complx if ELECID==11
margins exp_complx, post
margins, coeflegend
lincom _b[1.exp_complx] -  _b[0bn.exp_complx], level(95)
lincom _b[1.exp_complx] -  _b[0bn.exp_complx], level(99)
replace effectsize=(r(estimate)) in 7

*** Ontario regional*** Ontario regional*** Ontario regional
svy: logit voted  i.exp_complx if ELECID==14
margins exp_complx, post
margins, coeflegend
lincom _b[1.exp_complx] -  _b[0bn.exp_complx], level(95)
lincom _b[1.exp_complx] -  _b[0bn.exp_complx], level(99)
replace effectsize=(r(estimate)) in 8

*** Provence national*** Provence national*** Provence national
svy: logit voted  i.exp_complx if ELECID==6
margins exp_complx, post
margins, coeflegend
lincom _b[1.exp_complx] -  _b[0bn.exp_complx], level(95)
lincom _b[1.exp_complx] -  _b[0bn.exp_complx], level(99)
replace effectsize=(r(estimate)) in 9

***IDF national***IDF national***IDF national
svy: logit voted  i.exp_complx if ELECID==5
margins exp_complx, post
margins, coeflegend
lincom _b[1.exp_complx] -  _b[0bn.exp_complx], level(95)
lincom _b[1.exp_complx] -  _b[0bn.exp_complx], level(99)
replace effectsize=(r(estimate)) in 10

*** Catalonia national*** Catalonia national*** Catalonia national
svy: logit voted  i.exp_complx if ELECID==7
margins exp_complx, post
margins, coeflegend
lincom _b[1.exp_complx] -  _b[0bn.exp_complx], level(95)
lincom _b[1.exp_complx] -  _b[0bn.exp_complx], level(99)
replace effectsize=(r(estimate)) in 11

*** Madrid national*** Madrid national*** Madrid national
svy: logit voted  i.exp_complx if ELECID==9
margins exp_complx, post
margins, coeflegend
lincom _b[1.exp_complx] -  _b[0bn.exp_complx], level(95)
lincom _b[1.exp_complx] -  _b[0bn.exp_complx], level(99)
replace effectsize=(r(estimate)) in 12

***lucerne national***lucerne national***lucerne national
svy: logit voted  i.exp_complx if ELECID==1
margins exp_complx, post
margins, coeflegend
lincom _b[1.exp_complx] -  _b[0bn.exp_complx], level(95)
lincom _b[1.exp_complx] -  _b[0bn.exp_complx], level(99)
replace effectsize=(r(estimate)) in 13

***Zurich national***Zurich national***Zurich national
svy: logit voted  i.exp_complx if ELECID==3
margins exp_complx, post
margins, coeflegend
lincom _b[1.exp_complx] -  _b[0bn.exp_complx], level(95)
lincom _b[1.exp_complx] -  _b[0bn.exp_complx], level(99)
replace effectsize=(r(estimate)) in 14

***Provence europe***Provence europe***Provence europe
svy: logit voted  i.exp_complx if ELECID==16
margins exp_complx, post
margins, coeflegend
lincom _b[1.exp_complx] -  _b[0bn.exp_complx], level(95)
lincom _b[1.exp_complx] -  _b[0bn.exp_complx], level(99)
replace effectsize=(r(estimate)) in 15

***IDF europe***IDF europe***IDF europe
svy: logit voted  i.exp_complx if ELECID==17
margins exp_complx, post
margins, coeflegend
lincom _b[1.exp_complx] -  _b[0bn.exp_complx], level(95)
lincom _b[1.exp_complx] -  _b[0bn.exp_complx], level(99)
replace effectsize=(r(estimate)) in 16

***Catalonia europe***Catalonia europe***Catalonia europe
svy: logit voted  i.exp_complx if ELECID==20
margins exp_complx, post
margins, coeflegend
lincom _b[1.exp_complx] -  _b[0bn.exp_complx], level(95)
lincom _b[1.exp_complx] -  _b[0bn.exp_complx], level(99)
replace effectsize=(r(estimate)) in 17

***Madrid europe***Madrid europe***Madrid europe
svy: logit voted  i.exp_complx if ELECID==21
margins exp_complx, post
margins, coeflegend
lincom _b[1.exp_complx] -  _b[0bn.exp_complx], level(95)
lincom _b[1.exp_complx] -  _b[0bn.exp_complx], level(99)
replace effectsize=(r(estimate)) in 18

***Lower Saxony europe***Lower Saxony europe***Lower Saxony europe
svy: logit voted  i.exp_complx if ELECID==18
margins exp_complx, post
margins, coeflegend
lincom _b[1.exp_complx] -  _b[0bn.exp_complx], level(95)
lincom _b[1.exp_complx] -  _b[0bn.exp_complx], level(99)
replace effectsize=(r(estimate)) in 19

***all experiments pooled***all experiments pooled***all experiments pooled
svy: logit voted  i.exp_complx
margins exp_complx, post
margins, coeflegend
lincom _b[1.exp_complx] -  _b[0bn.exp_complx]

***mean effect***mean effect***mean effect
ttest effectsize == 0



***Table 2

xtset ELECID
**Model 1 
xtlogit voted i.exp_complx
**Model 2
xtlogit voted i.exp_complx##c.actual_to i.exp_complx##c.participation_rate  i.exp_complx i.exp_complx##c.attrition_rate  i.exp_complx##i.LEVEL
**Model 3
xtlogit voted i.exp_complx##c.actual_to i.exp_complx##c.participation_rate  i.exp_complx i.exp_complx##c.attrition_rate  i.exp_complx##i.LEVEL i.exp_complx##i.female i.exp_complx##i.tertiary  i.exp_complx##c.age  i.exp_complx##i.mobilized i.exp_complx##i.duty_to_vote i.exp_complx##c.interest
**Model 4
xtlogit voted i.exp_complx##c.actual_to i.exp_complx##c.participation_rate  i.exp_complx i.exp_complx##c.attrition_rate  i.exp_complx##i.LEVEL i.exp_complx##i.female i.exp_complx##i.tertiary  i.exp_complx##c.age  i.exp_complx##i.mobilized i.exp_complx##i.duty_to_vote i.exp_complx##c.interest i.exp_complx##i.decision i.exp_complx##i.closeness



*******APPENDIX****************APPENDIX*********
*******APPENDIX****************APPENDIX*********
*******APPENDIX****************APPENDIX*********
*******APPENDIX****************APPENDIX*********
*******APPENDIX****************APPENDIX*********

*Table A6*Table A6*Table A6*Table A6*Table A6
*Table A6*Table A6*Table A6*Table A6*Table A6

***Marseille municipal***Marseille municipal
svy: tab voted_simple if ELECID==23
svy: tab voted_complx if ELECID==23
***Paris municipal***Paris municipal
svy: tab voted_simple if ELECID==22
svy: tab voted_complx if ELECID==22
*** Provence national*** Provence national
svy: tab voted_simple if ELECID==6
svy: tab voted_complx if ELECID==6
***IDF national***IDF national
svy: tab voted_simple if ELECID==5
svy: tab voted_complx if ELECID==5
***Provence europe***Provence europe
svy: tab voted_simple if ELECID==16
svy: tab voted_complx if ELECID==16
***IDF europe***IDF europe
svy: tab voted_simple if ELECID==17
svy: tab voted_complx if ELECID==17
*** Catalonia regional*** Catalonia regional
svy: tab voted_simple if ELECID==8
svy: tab voted_complx if ELECID==8
*** Catalonia national*** Catalonia national
svy: tab voted_simple if ELECID==7
svy: tab voted_complx if ELECID==7
*** Madrid national*** Madrid national
svy: tab voted_simple if ELECID==9
svy: tab voted_complx if ELECID==9
***Catalonia europe***Catalonia europe
svy: tab voted_simple if ELECID==20
svy: tab voted_complx if ELECID==20
***Madrid europe***Madrid europe
svy: tab voted_simple if ELECID==21
svy: tab voted_complx if ELECID==21
***Lucerne regional***Lucerne regional
svy: tab voted_simple if ELECID==2
svy: tab voted_complx if ELECID==2
***Zurich regrional***Zurich regrional
svy: tab voted_simple if ELECID==4
svy: tab voted_complx if ELECID==4
***lucerne national***lucerne national
svy: tab voted_simple if ELECID==1
svy: tab voted_complx if ELECID==1
***Zurich national***Zurich national
svy: tab voted_simple if ELECID==3
svy: tab voted_complx if ELECID==3
*** Lower Saxony regional*** Lower Saxony regional
svy: tab voted_simple if ELECID==11
svy: tab voted_complx if ELECID==11
replace effectsize=(r(estimate)) in 18
***Lower Saxony europe***Lower Saxony europe
svy: tab voted_simple if ELECID==18
svy: tab voted_complx if ELECID==18
*** Quebec regional*** Quebec regional
svy: tab voted_simple if ELECID==15
svy: tab voted_complx if ELECID==15
*** Ontario regional*** Ontario regional
svy: tab voted_simple if ELECID==14
svy: tab voted_complx if ELECID==14

*RANDOMIZATION CHECK

svyset [pw=POST_WEIGHT1]

********************************************************
***Table A7***Table A7***Table A7***Table A7***Table A7
***Table A7***Table A7***Table A7***Table A7***Table A7
***MARSEILLE MUNICIPAL ELECID=23***MARSEILLE MUNICIPAL ELECID=23
***interest in this election
svy: tab interest_wdk if exp_complx==0 & ELECID==23
svy: tab interest_wdk if exp_complx==1 & ELECID==23
svy: tab interest_wdk exp_complx if ELECID==23, col

**duty to vote in municipal elections
svy: tab duty_dum_wdk if exp_complx==0 & ELECID==23
svy: tab duty_dum_wdk if exp_complx==1 & ELECID==23
svy: tab duty_dum_wdk exp_complx if ELECID==23, col

**educ
svy: tab educ if exp_complx==0 & ELECID==23
svy: tab educ if exp_complx==1 & ELECID==23
svy: tab educ exp_complx if ELECID==23, col

**agecat
svy: tab agecat if exp_complx==0 & ELECID==23
svy: tab agecat if exp_complx==1 & ELECID==23
svy: tab agecat exp_complx if ELECID==23, col

**female
svy: tab female if exp_complx==0 & ELECID==23
svy: tab female if exp_complx==1 & ELECID==23
svy: tab female exp_complx if ELECID==23, col

***	CAPA NATIONAL ELECID=6***CAPA NATIONAL ELECID=6
***interest in this election
svy: tab interest_wdk if exp_complx==0 & ELECID==6
svy: tab interest_wdk if exp_complx==1 & ELECID==6
svy: tab interest_wdk exp_complx if ELECID==6, col

**duty to vote in municipal elections
svy: tab duty_dum_wdk if exp_complx==0 & ELECID==6
svy: tab duty_dum_wdk if exp_complx==1 & ELECID==6
svy: tab duty_dum_wdk exp_complx if ELECID==6, col

**educ
svy: tab educ if exp_complx==0 & ELECID==6
svy: tab educ if exp_complx==1 & ELECID==6
svy: tab educ exp_complx if ELECID==6, col

**agecat
svy: tab agecat if exp_complx==0 & ELECID==6
svy: tab agecat if exp_complx==1 & ELECID==6
svy: tab agecat exp_complx if ELECID==6, col

**female
svy: tab female if exp_complx==0 & ELECID==6
svy: tab female if exp_complx==1 & ELECID==6
svy: tab female exp_complx if ELECID==6, col

***	CAPA EUROPE ELECID=16***CAPA EUROPE ELECID=16
***interest in this election
svy: tab interest_wdk if exp_complx==0 & ELECID==16
svy: tab interest_wdk if exp_complx==1 & ELECID==16
svy: tab interest_wdk exp_complx if ELECID==16, col

**duty to vote in municipal elections
svy: tab duty_dum_wdk if exp_complx==0 & ELECID==16
svy: tab duty_dum_wdk if exp_complx==1 & ELECID==16
svy: tab duty_dum_wdk exp_complx if ELECID==16, col

**educ
svy: tab educ if exp_complx==0 & ELECID==16
svy: tab educ if exp_complx==1 & ELECID==16
svy: tab educ exp_complx if ELECID==16, col

**agecat
svy: tab agecat if exp_complx==0 & ELECID==16
svy: tab agecat if exp_complx==1 & ELECID==16
svy: tab agecat exp_complx if ELECID==16, col

**female
svy: tab female if exp_complx==0 & ELECID==16
svy: tab female if exp_complx==1 & ELECID==16
svy: tab female exp_complx if ELECID==16, col


********************************************************
***Table A8***Table A8***Table A8***Table A8***Table A8
***Table A8***Table A8***Table A8***Table A8***Table A8
***	PARIS MUNICIAPL ELECID=22
***interest in this election
svy: tab interest_wdk if exp_complx==0 & ELECID==22
svy: tab interest_wdk if exp_complx==1 & ELECID==22
svy: tab interest_wdk exp_complx if ELECID==22, col

**duty to vote in municipal elections
svy: tab duty_dum_wdk if exp_complx==0 & ELECID==22
svy: tab duty_dum_wdk if exp_complx==1 & ELECID==22
svy: tab duty_dum_wdk exp_complx if ELECID==22, col

**educ
svy: tab educ if exp_complx==0 & ELECID==22
svy: tab educ if exp_complx==1 & ELECID==22
svy: tab educ exp_complx if ELECID==22, col

**agecat
svy: tab agecat if exp_complx==0 & ELECID==22
svy: tab agecat if exp_complx==1 & ELECID==22
svy: tab agecat exp_complx if ELECID==22, col

**female
svy: tab female if exp_complx==0 & ELECID==22
svy: tab female if exp_complx==1 & ELECID==22
svy: tab female exp_complx if ELECID==22, col

***	IDF NATINAL ELECID=5
***interest in this election
svy: tab interest_wdk if exp_complx==0 & ELECID==5
svy: tab interest_wdk if exp_complx==1 & ELECID==5
svy: tab interest_wdk exp_complx if ELECID==5, col

**duty to vote in municipal elections
svy: tab duty_dum_wdk if exp_complx==0 & ELECID==5
svy: tab duty_dum_wdk if exp_complx==1 & ELECID==5
svy: tab duty_dum_wdk exp_complx if ELECID==5, col

**educ
svy: tab educ if exp_complx==0 & ELECID==5
svy: tab educ if exp_complx==1 & ELECID==5
svy: tab educ exp_complx if ELECID==5, col

**agecat
svy: tab agecat if exp_complx==0 & ELECID==5
svy: tab agecat if exp_complx==1 & ELECID==5
svy: tab agecat exp_complx if ELECID==5, col

**female
svy: tab female if exp_complx==0 & ELECID==5
svy: tab female if exp_complx==1 & ELECID==5
svy: tab female exp_complx if ELECID==5, col

***	IDF EUROPE ELECID=17
***interest in this election
svy: tab interest_wdk if exp_complx==0 & ELECID==17
svy: tab interest_wdk if exp_complx==1 & ELECID==17
svy: tab interest_wdk exp_complx if ELECID==17, col

**duty to vote in municipal elections
svy: tab duty_dum_wdk if exp_complx==0 & ELECID==17
svy: tab duty_dum_wdk if exp_complx==1 & ELECID==17
svy: tab duty_dum_wdk exp_complx if ELECID==17, col

**educ
svy: tab educ if exp_complx==0 & ELECID==17
svy: tab educ if exp_complx==1 & ELECID==17
svy: tab educ exp_complx if ELECID==17, col

**agecat
svy: tab agecat if exp_complx==0 & ELECID==17
svy: tab agecat if exp_complx==1 & ELECID==17
svy: tab agecat exp_complx if ELECID==17, col

**female
svy: tab female if exp_complx==0 & ELECID==17
svy: tab female if exp_complx==1 & ELECID==17
svy: tab female exp_complx if ELECID==17, col

********************************************************
***Table A9***Table A9***Table A9***Table A9***Table A9
***Table A9***Table A9***Table A9***Table A9***Table A9
***	CATALONIA REGIONAL ELECID=8
***interest in this election
svy: tab interest_wdk if exp_complx==0 & ELECID==8
svy: tab interest_wdk if exp_complx==1 & ELECID==8
svy: tab interest_wdk exp_complx if ELECID==8, col

**duty to vote in municipal elections
svy: tab duty_dum_wdk if exp_complx==0 & ELECID==8
svy: tab duty_dum_wdk if exp_complx==1 & ELECID==8
svy: tab duty_dum_wdk exp_complx if ELECID==8, col

**educ
svy: tab educ if exp_complx==0 & ELECID==8
svy: tab educ if exp_complx==1 & ELECID==8
svy: tab educ exp_complx if ELECID==8, col

**agecat
svy: tab agecat if exp_complx==0 & ELECID==8
svy: tab agecat if exp_complx==1 & ELECID==8
svy: tab agecat exp_complx if ELECID==8, col

**female
svy: tab female if exp_complx==0 & ELECID==8
svy: tab female if exp_complx==1 & ELECID==8
svy: tab female exp_complx if ELECID==8, col

***	CATALONIA national ELECID=7
***interest in this election
svy: tab interest_wdk if exp_complx==0 & ELECID==7
svy: tab interest_wdk if exp_complx==1 & ELECID==7
svy: tab interest_wdk exp_complx if ELECID==7, col

**duty to vote in municipal elections
svy: tab duty_dum_wdk if exp_complx==0 & ELECID==7
svy: tab duty_dum_wdk if exp_complx==1 & ELECID==7
svy: tab duty_dum_wdk exp_complx if ELECID==7, col

**educ
svy: tab educ if exp_complx==0 & ELECID==7
svy: tab educ if exp_complx==1 & ELECID==7
svy: tab educ exp_complx if ELECID==7, col

**agecat
svy: tab agecat if exp_complx==0 & ELECID==7
svy: tab agecat if exp_complx==1 & ELECID==7
svy: tab agecat exp_complx if ELECID==7, col

**female
svy: tab female if exp_complx==0 & ELECID==7
svy: tab female if exp_complx==1 & ELECID==7
svy: tab female exp_complx if ELECID==7, col

***	CATALONIA europe ELECID=20
***interest in this election
svy: tab interest_wdk if exp_complx==0 & ELECID==20
svy: tab interest_wdk if exp_complx==1 & ELECID==20
svy: tab interest_wdk exp_complx if ELECID==20, col

**duty to vote in municipal elections
svy: tab duty_dum_wdk if exp_complx==0 & ELECID==20
svy: tab duty_dum_wdk if exp_complx==1 & ELECID==20
svy: tab duty_dum_wdk exp_complx if ELECID==20, col

**educ
svy: tab educ if exp_complx==0 & ELECID==20
svy: tab educ if exp_complx==1 & ELECID==20
svy: tab educ exp_complx if ELECID==20, col

**agecat
svy: tab agecat if exp_complx==0 & ELECID==20
svy: tab agecat if exp_complx==1 & ELECID==20
svy: tab agecat exp_complx if ELECID==20, col

**female
svy: tab female if exp_complx==0 & ELECID==20
svy: tab female if exp_complx==1 & ELECID==20
svy: tab female exp_complx if ELECID==20, col

********************************************************
***Table A10***Table A10***Table A10***Table A10***Table A10
***Table A10***Table A10***Table A10***Table A10***Table A10
***MADRID NATIONAL  ELECID=9
***interest in this election
svy: tab interest_wdk if exp_complx==0 & ELECID==9
svy: tab interest_wdk if exp_complx==1 & ELECID==9
svy: tab interest_wdk exp_complx if ELECID==9, col

**duty to vote in municipal elections
svy: tab duty_dum_wdk if exp_complx==0 & ELECID==9
svy: tab duty_dum_wdk if exp_complx==1 & ELECID==9
svy: tab duty_dum_wdk exp_complx if ELECID==9, col

**educ
svy: tab educ if exp_complx==0 & ELECID==9
svy: tab educ if exp_complx==1 & ELECID==9
svy: tab educ exp_complx if ELECID==9, col

**agecat
svy: tab agecat if exp_complx==0 & ELECID==9
svy: tab agecat if exp_complx==1 & ELECID==9
svy: tab agecat exp_complx if ELECID==9, col

**female
svy: tab female if exp_complx==0 & ELECID==9
svy: tab female if exp_complx==1 & ELECID==9
svy: tab female exp_complx if ELECID==9, col

***MADRID EUROPE  ELECID=21
***interest in this election
svy: tab interest_wdk if exp_complx==0 & ELECID==21
svy: tab interest_wdk if exp_complx==1 & ELECID==21
svy: tab interest_wdk exp_complx if ELECID==21, col

**duty to vote in municipal elections
svy: tab duty_dum_wdk if exp_complx==0 & ELECID==21
svy: tab duty_dum_wdk if exp_complx==1 & ELECID==21
svy: tab duty_dum_wdk exp_complx if ELECID==21, col

**educ
svy: tab educ if exp_complx==0 & ELECID==21
svy: tab educ if exp_complx==1 & ELECID==21
svy: tab educ exp_complx if ELECID==21, col

**agecat
svy: tab agecat if exp_complx==0 & ELECID==21
svy: tab agecat if exp_complx==1 & ELECID==21
svy: tab agecat exp_complx if ELECID==21, col

**female
svy: tab female if exp_complx==0 & ELECID==21
svy: tab female if exp_complx==1 & ELECID==21
svy: tab female exp_complx if ELECID==21, col

********************************************************
***Table A11***Table A11***Table A11***Table A11***Table A11
***Table A11***Table A11***Table A11***Table A11***Table A11
**LUCERNE CANTONAL  ELECID=2
***interest in this election
svy: tab interest_wdk if exp_complx==0 & ELECID==2
svy: tab interest_wdk if exp_complx==1 & ELECID==2
svy: tab interest_wdk exp_complx if ELECID==2, col

**duty to vote in municipal elections
svy: tab duty_dum_wdk if exp_complx==0 & ELECID==2
svy: tab duty_dum_wdk if exp_complx==1 & ELECID==2
svy: tab duty_dum_wdk exp_complx if ELECID==2, col

**educ
svy: tab educ if exp_complx==0 & ELECID==2
svy: tab educ if exp_complx==1 & ELECID==2
svy: tab educ exp_complx if ELECID==2, col

**agecat
svy: tab agecat if exp_complx==0 & ELECID==2
svy: tab agecat if exp_complx==1 & ELECID==2
svy: tab agecat exp_complx if ELECID==2, col

**female
svy: tab female if exp_complx==0 & ELECID==2
svy: tab female if exp_complx==1 & ELECID==2
svy: tab female exp_complx if ELECID==2, col
 
****LUCERNE NATIONAL  ELECID=1
***interest in this election
svy: tab interest_wdk if exp_complx==0 & ELECID==1
svy: tab interest_wdk if exp_complx==1 & ELECID==1
svy: tab interest_wdk exp_complx if ELECID==1, col

**duty to vote in municipal elections
svy: tab duty_dum_wdk if exp_complx==0 & ELECID==1
svy: tab duty_dum_wdk if exp_complx==1 & ELECID==1
svy: tab duty_dum_wdk exp_complx if ELECID==1, col

**educ
svy: tab educ if exp_complx==0 & ELECID==1
svy: tab educ if exp_complx==1 & ELECID==1
svy: tab educ exp_complx if ELECID==1, col

**agecat
svy: tab agecat if exp_complx==0 & ELECID==1
svy: tab agecat if exp_complx==1 & ELECID==1
svy: tab agecat exp_complx if ELECID==1, col

**female
svy: tab female if exp_complx==0 & ELECID==1
svy: tab female if exp_complx==1 & ELECID==1
svy: tab female exp_complx if ELECID==1, col


**ZURICH CANTONAL  ELECID=4
***interest in this election
svy: tab interest_wdk if exp_complx==0 & ELECID==4
svy: tab interest_wdk if exp_complx==1 & ELECID==4
svy: tab interest_wdk exp_complx if ELECID==4, col

**duty to vote in municipal elections
svy: tab duty_dum_wdk if exp_complx==0 & ELECID==4
svy: tab duty_dum_wdk if exp_complx==1 & ELECID==4
svy: tab duty_dum_wdk exp_complx if ELECID==4, col

**educ
svy: tab educ if exp_complx==0 & ELECID==4
svy: tab educ if exp_complx==1 & ELECID==4
svy: tab educ exp_complx if ELECID==4, col

**agecat
svy: tab agecat if exp_complx==0 & ELECID==4
svy: tab agecat if exp_complx==1 & ELECID==4
svy: tab agecat exp_complx if ELECID==4, col

**female
svy: tab female if exp_complx==0 & ELECID==4
svy: tab female if exp_complx==1 & ELECID==4
svy: tab female exp_complx if ELECID==4, col

****ZURICH NATIONAL  ELECID=3
***interest in this election
svy: tab interest_wdk if exp_complx==0 & ELECID==3
svy: tab interest_wdk if exp_complx==1 & ELECID==3
svy: tab interest_wdk exp_complx if ELECID==3, col

**duty to vote in municipal elections
svy: tab duty_dum_wdk if exp_complx==0 & ELECID==3
svy: tab duty_dum_wdk if exp_complx==1 & ELECID==3
svy: tab duty_dum_wdk exp_complx if ELECID==3, col

**educ
svy: tab educ if exp_complx==0 & ELECID==3
svy: tab educ if exp_complx==1 & ELECID==3
svy: tab educ exp_complx if ELECID==3, col

**agecat
svy: tab agecat if exp_complx==0 & ELECID==3
svy: tab agecat if exp_complx==1 & ELECID==3
svy: tab agecat exp_complx if ELECID==3, col

**female
svy: tab female if exp_complx==0 & ELECID==3
svy: tab female if exp_complx==1 & ELECID==3
svy: tab female exp_complx if ELECID==3, col

********************************************************
***Table A12***Table A12***Table A12***Table A12***Table A12
***Table A12***Table A12***Table A12***Table A12***Table A12
****Lower Saxony  CANTONAL  ELECID=11
***interest in this election
svy: tab interest_wdk if exp_complx==0 & ELECID==11
svy: tab interest_wdk if exp_complx==1 & ELECID==11
svy: tab interest_wdk exp_complx if ELECID==11, col

**duty to vote in municipal elections
svy: tab duty_dum_wdk if exp_complx==0 & ELECID==11
svy: tab duty_dum_wdk if exp_complx==1 & ELECID==11
svy: tab duty_dum_wdk exp_complx if ELECID==11, col

**educ
svy: tab educ if exp_complx==0 & ELECID==11
svy: tab educ if exp_complx==1 & ELECID==11
svy: tab educ exp_complx if ELECID==11, col

**agecat
svy: tab agecat if exp_complx==0 & ELECID==11
svy: tab agecat if exp_complx==1 & ELECID==11
svy: tab agecat exp_complx if ELECID==11, col

**female
svy: tab female if exp_complx==0 & ELECID==11
svy: tab female if exp_complx==1 & ELECID==11
svy: tab female exp_complx if ELECID==11, col

****Lower Saxony EUROPEAN ELECID=18
***interest in this election
svy: tab interest_wdk if exp_complx==0 & ELECID==18
svy: tab interest_wdk if exp_complx==1 & ELECID==18
svy: tab interest_wdk exp_complx if ELECID==18, col

**duty to vote in municipal elections
svy: tab duty_dum_wdk if exp_complx==0 & ELECID==18
svy: tab duty_dum_wdk if exp_complx==1 & ELECID==18
svy: tab duty_dum_wdk exp_complx if ELECID==18, col

**educ
svy: tab educ if exp_complx==0 & ELECID==18
svy: tab educ if exp_complx==1 & ELECID==18
svy: tab educ exp_complx if ELECID==18, col

**agecat
svy: tab agecat if exp_complx==0 & ELECID==18
svy: tab agecat if exp_complx==1 & ELECID==18
svy: tab agecat exp_complx if ELECID==18, col

**female
svy: tab female if exp_complx==0 & ELECID==18
svy: tab female if exp_complx==1 & ELECID==18
svy: tab female exp_complx if ELECID==18, col

****Quebec provincial ELECID=15
***interest in this election
svy: tab interest_wdk if exp_complx==0 & ELECID==15
svy: tab interest_wdk if exp_complx==1 & ELECID==15
svy: tab interest_wdk exp_complx if ELECID==15, col

**duty to vote in municipal elections
svy: tab duty_dum_wdk if exp_complx==0 & ELECID==15
svy: tab duty_dum_wdk if exp_complx==1 & ELECID==15
svy: tab duty_dum_wdk exp_complx if ELECID==15, col

**educ
svy: tab educ if exp_complx==0 & ELECID==15
svy: tab educ if exp_complx==1 & ELECID==15
svy: tab educ exp_complx if ELECID==15, col

**agecat
svy: tab agecat if exp_complx==0 & ELECID==15
svy: tab agecat if exp_complx==1 & ELECID==15
svy: tab agecat exp_complx if ELECID==15, col

**female
svy: tab female if exp_complx==0 & ELECID==15
svy: tab female if exp_complx==1 & ELECID==15
svy: tab female exp_complx if ELECID==15, col

****Ontario provincial  ELECID=14
***interest in this election
svy: tab interest_wdk if exp_complx==0 & ELECID==14
svy: tab interest_wdk if exp_complx==1 & ELECID==14
svy: tab interest_wdk exp_complx if ELECID==14, col

**duty to vote in municipal elections
svy: tab duty_dum_wdk if exp_complx==0 & ELECID==14
svy: tab duty_dum_wdk if exp_complx==1 & ELECID==14
svy: tab duty_dum_wdk exp_complx if ELECID==14, col

**educ
svy: tab educ if exp_complx==0 & ELECID==14
svy: tab educ if exp_complx==1 & ELECID==14
svy: tab educ exp_complx if ELECID==14, col

**agecat
svy: tab agecat if exp_complx==0 & ELECID==14
svy: tab agecat if exp_complx==1 & ELECID==14
svy: tab agecat exp_complx if ELECID==14, col

**female
svy: tab female if exp_complx==0 & ELECID==14
svy: tab female if exp_complx==1 & ELECID==14
svy: tab female exp_complx if ELECID==14, col



*****Figure A1

xtset ELECID

logit voted i.exp_complx##i.intention
margins exp_complx, at(intention=(0 (1) 5)) 
marginsplot, xscale(range(-0.5 5.5)) ///
xtitle("") xlab(0 `""Certain" "not to vote""' 1 `""Very unlikely" "to vote""' 2 `""Somewhat unlikely" "to vote""' 3 `""Somewhat" "likely to vote""' 4 `""Very likely" "to vote""' 5 `""Certain" "to vote""',labsize(small)) ///
ylabel(, grid glwidth(vthin) glcolor(gs14)  glpattern(shortdash)) ///
ytitle(Pr(Voted=1)) ymtick(.1 .3 .5 .7 .9)



***** Values used to plot Figure A2 
xtlogit voted i.exp_complx##i.intention
margins exp_complx, at(intention=(0 (1) 5))  post
margins, coeflegend
lincom _b[1bn._at#1.exp_complx] - _b[1bn._at#0bn.exp_complx]
lincom _b[2._at#1.exp_complx] -  _b[2._at#0bn.exp_complx]
lincom _b[3._at#1.exp_complx] -  _b[3._at#0bn.exp_complx]
lincom _b[4._at#1.exp_complx] -  _b[4._at#0bn.exp_complx]
lincom _b[5._at#1.exp_complx] -  _b[5._at#0bn.exp_complx]
lincom _b[6._at#1.exp_complx] -  _b[6._at#0bn.exp_complx] 


***Table A13
sum actual_to
sum participation_rate
sum attrition_rate
sum age
sum female
sum tertiary
sum interest
sum mobilized

***Table A14
tab LEVEL

***Table A15
tab duty_to_vote

***Table A16
tab decision

***Table A17
tab closeness


