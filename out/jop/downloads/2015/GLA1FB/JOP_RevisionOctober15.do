gen whitedem_treatments = .
replace whitedem_treatments = 0 if whitedem_whites ==1 
replace whitedem_treatments =1 if whitedem_diverse ==1 
replace whitedem_treatments =2 if whitedem_blacks ==1  

gen whiterepub_treatments = .
replace whiterepub_treatments =0 if whiterepub_whites ==1 
replace whiterepub_treatments = 1 if whiterepub_diverse ==1  
replace whiterepub_treatments =2 if whiterepub_blacks ==1 


*****Table 2--Ordered Logit Models for Democratic Treatments with Marginal Effects********

ologit votegregdavis i.whitedem_treatments gender educ income pid7 south [pweight = weight] 
margins, atmeans dydx(i.whitedem_treatments) predict(outcome(#3))

ologit fair_gregdavis i.whitedem_treatments gender educ income pid7 south [pweight = weight] 
margins, atmeans dydx(i.whitedem_treatments) predict(outcome(#3))

ologit gregdavis_redcrim i.whitedem_treatments gender educ income pid7 south [pweight = weight] 
margins, atmeans dydx(i.whitedem_treatments) predict(outcome(#3))

ologit davis_affirmact i.whitedem_treatments gender educ income pid7 south [pweight = weight] 
margins, atmeans dydx(i.whitedem_treatments) predict(outcome(#3))

ologit blacksoverwhites i.whitedem_treatments gender educ income pid7 south [pweight = weight] 
margins, atmeans dydx(i.whitedem_treatments) predict(outcome(#3))


*****Table 3--Ordered Logit Models for Republican Treatments with Marginal Effects********

ologit votegregdavis i.whiterepub_treatments gender educ income pid7 south [pweight = weight] 
margins, atmeans dydx(i.whiterepub_treatments) predict(outcome(#3))

ologit fair_gregdavis i.whiterepub_treatments gender educ income pid7 south [pweight = weight] 
margins, atmeans dydx(i.whiterepub_treatments) predict(outcome(#3))


ologit gregdavis_redcrim i.whiterepub_treatments gender educ income pid7 south [pweight = weight] 
margins, atmeans dydx(i.whiterepub_treatments) predict(outcome(#3))


ologit davis_affirmact i.whiterepub_treatments gender educ income pid7 south [pweight = weight] 
margins, atmeans dydx(i.whiterepub_treatments) predict(outcome(#3))


ologit blacksoverwhites i.whiterepub_treatments gender educ income pid7 south [pweight = weight] 
margins, atmeans dydx(i.whiterepub_treatments) predict(outcome(#3))


*******Table 4----Orderd Logit Models for Democratic Treatments Interacted with Racial Resentment******

ologit votegregdavis pid7 educ south gender income  c.raceresentscale##whitedem_treatments [pweight = weight]
margins i.whitedem_treatments, at(raceresentscale=(.318(.145).9)) predict(outcome(#4))
***GRAPH NAME: A1
marginsplot, xdimension(raceresentscale) bydimension(whitedem_treatments)

ologit fair_gregdavis pid7 educ south gender income c.raceresentscale##whitedem_treatments [pweight = weight]
margins i.whitedem_treatments, at(raceresentscale=(.318(.145).9)) predict(outcome(#3))
***GRAPH NAME: A3
marginsplot, xdimension(raceresentscale) bydimension(whitedem_treatments)

ologit gregdavis_redcrim pid7 educ south gender income c.raceresentscale##whitedem_treatments [pweight = weight]
margins i.whitedem_treatments, at(raceresentscale=(.318(.145).9)) predict(outcome(#3))
***GRAPH NAME: A7
marginsplot, xdimension(raceresentscale) bydimension(whitedem_treatments)


ologit davis_affirmact pid7 educ south gender income c.raceresentscale##whitedem_treatments [pweight = weight]
margins i.whitedem_treatments, at(raceresentscale=(.318(.145).9)) predict(outcome(#1))


ologit blacksoverwhites pid7 educ south gender income  c.raceresentscale##whitedem_treatments [pweight = weight]
margins i.whitedem_treatments, at(raceresentscale=(.318(.145).9)) predict(outcome(#1))



ologit votegregdavis pid7 educ south gender income  c.raceresentscale##whitedem_treatments [pweight = weight]
estimates store r1
ologit fair_gregdavis pid7 educ income south gender c.raceresentscale##whitedem_treatments [pweight = weight]
estimates store r2
ologit davis_affirmact pid7 educ income south gender  c.raceresentscale##whitedem_treatments [pweight = weight]
estimates store r3
ologit gregdavis_redcrim pid7 educ income south gender c.raceresentscale##whitedem_treatments [pweight = weight]
estimates store r4
ologit blacksoverwhites pid7 educ income south gender  c.raceresentscale##whitedem_treatments [pweight = weight]
estimates store r5


*******Table 5----Orderd Logit Models for Republican Treatments Interacted with Racial Resentment******

ologit votegregdavis pid7 educ south gender income  c.raceresentscale##whiterepub_treatments [pweight = weight]
margins i.whiterepub_treatments, at(raceresentscale=(.318(.145).9)) predict(outcome(#4))

ologit fair_gregdavis pid7 educ south gender income c.raceresentscale##whiterepub_treatments [pweight = weight]
margins i.whiterepub_treatments, at(raceresentscale=(.318(.145).9)) predict(outcome(#3))

ologit gregdavis_redcrim pid7 educ south gender income c.raceresentscale##whiterepub_treatments [pweight = weight]
margins i.whiterepub_treatments, at(raceresentscale=(.318(.145).9)) predict(outcome(#3))


ologit davis_affirmact pid7 educ south gender income c.raceresentscale##whiterepub_treatments [pweight = weight]
margins i.whiterepub_treatments, at(raceresentscale=(.318(.145).9)) predict(outcome(#1))


ologit blacksoverwhites pid7 educ south gender income  c.raceresentscale##whiterepub_treatments [pweight = weight]
margins i.whiterepub_treatments, at(raceresentscale=(.318(.145).9)) predict(outcome(#1))

ologit votegregdavis pid7 educ south gender income  c.raceresentscale##whiterepub_treatments [pweight = weight]
estimates store r1
ologit fair_gregdavis pid7 educ income south gender c.raceresentscale##whiterepub_treatments [pweight = weight]
estimates store r2
ologit davis_affirmact pid7 educ income south gender  c.raceresentscale##whiterepub_treatments [pweight = weight]
estimates store r3
ologit gregdavis_redcrim pid7 educ income south gender c.raceresentscale##whiterepub_treatments [pweight = weight]
estimates store r4
ologit blacksoverwhites pid7 educ income south gender  c.raceresentscale##whiterepub_treatments [pweight = weight]
estimates store r5

*******Table 6----Sobel-Goodman Mediation Test******
sgmediation votegregdavis, mv (stereotype) iv (raceresentscale)

sgmediation votegregdavis, mv (fair_gregdavis) iv (raceresentscale)

sgmediation votegregdavis, mv (blacksoverwhites) iv (raceresentscale)


****Table B1--Ordered Logit Models for Democratic Treatments with Marginal Effects Without Control Variables********

ologit votegregdavis i.whitedem_treatments [pweight = weight] 
margins, atmeans dydx(i.whitedem_treatments) predict(outcome(#3))

ologit fair_gregdavis i.whitedem_treatments  [pweight = weight] 
margins, atmeans dydx(i.whitedem_treatments) predict(outcome(#3))

ologit gregdavis_redcrim i.whitedem_treatments [pweight = weight] 
margins, atmeans dydx(i.whitedem_treatments) predict(outcome(#3))

ologit davis_affirmact i.whitedem_treatments [pweight = weight] 
margins, atmeans dydx(i.whitedem_treatments) predict(outcome(#3))

ologit blacksoverwhites i.whitedem_treatments  [pweight = weight] 
margins, atmeans dydx(i.whitedem_treatments) predict(outcome(#3))


*****Table B2--Ordered Logit Models for Republican Treatments with Marginal Effects Without Control Variables********

ologit votegregdavis i.whiterepub_treatments [pweight = weight] 
margins, atmeans dydx(i.whiterepub_treatments) predict(outcome(#3))

ologit fair_gregdavis i.whiterepub_treatments [pweight = weight] 
margins, atmeans dydx(i.whiterepub_treatments) predict(outcome(#3))


ologit gregdavis_redcrim i.whiterepub_treatments [pweight = weight] 
margins, atmeans dydx(i.whiterepub_treatments) predict(outcome(#3))


ologit davis_affirmact i.whiterepub_treatments [pweight = weight] 
margins, atmeans dydx(i.whiterepub_treatments) predict(outcome(#3))


ologit blacksoverwhites i.whiterepub_treatments [pweight = weight] 
margins, atmeans dydx(i.whiterepub_treatments) predict(outcome(#3))


*******Table B3----Ordered Logit Models for Democratic Treatments Interacted with Racial Resentment Without Control Variables******

ologit votegregdavis c.raceresentscale##whitedem_treatments [pweight = weight]

ologit fair_gregdavis c.raceresentscale##whitedem_treatments [pweight = weight]

ologit gregdavis_redcrim c.raceresentscale##whitedem_treatments [pweight = weight]


ologit davis_affirmact c.raceresentscale##whitedem_treatments [pweight = weight]


ologit blacksoverwhites c.raceresentscale##whitedem_treatments [pweight = weight]





*******Table B4----Ordered Logit Models for Republican Treatments Interacted with Racial Resentment Without Control Variables******

ologit votegregdavis c.raceresentscale##whiterepub_treatments [pweight = weight]

ologit fair_gregdavis  c.raceresentscale##whiterepub_treatments [pweight = weight]

ologit gregdavis_redcrim  c.raceresentscale##whiterepub_treatments [pweight = weight]

ologit davis_affirmact c.raceresentscale##whiterepub_treatments [pweight = weight]

ologit blacksoverwhites  c.raceresentscale##whiterepub_treatments [pweight = weight]

*******Table B5: Ordered Logit Models by Treatment Interacted With Racial Resentment:WHITE DEM CANDIDATES FOR DEMOCRATIC RESPONDENTS******

ologit votegregdavis pid7 educ south gender income  c.raceresentscale##whitedem_treatments if pid7<.5 [pweight = weight]


ologit fair_gregdavis pid7 educ south gender income c.raceresentscale##whitedem_treatments if pid7<.5 [pweight = weight]


ologit davis_affirmact pid7 educ south gender income c.raceresentscale##whitedem_treatments if pid7<.5 [pweight = weight]


ologit gregdavis_redcrim pid7 educ south gender income c.raceresentscale##whitedem_treatments if pid7<.5 [pweight = weight]

ologit blacksoverwhites pid7 educ south gender income  c.raceresentscale##whitedem_treatments if pid7<.5 [pweight = weight]

*******Table B5: Ordered Logit Models by Treatment Interacted With Racial Resentment:WHITE DEM CANDIDATES FOR REPUBLICAN RESPONDENTS******

ologit votegregdavis pid7 educ south gender income  c.raceresentscale##whitedem_treatments if pid7>.5 [pweight = weight]

ologit votegregdavis pid7 educ south gender income  c.raceresentscale##whitedem_treatments if pid7>.5 [pweight = weight]

ologit fair_gregdavis pid7 educ south gender income c.raceresentscale##whitedem_treatments if pid7>.5 [pweight = weight]

ologit davis_affirmact pid7 educ south gender income c.raceresentscale##whitedem_treatments if pid7>.5 [pweight = weight]

ologit gregdavis_redcrim pid7 educ south gender income c.raceresentscale##whitedem_treatments if pid7>.5 [pweight = weight]

ologit blacksoverwhites pid7 educ south gender income  c.raceresentscale##whitedem_treatments if pid7>.5 [pweight = weight]

**************Table B6: Ordered Logit Models by Treatment Interacted With Racial Resentment:WHITE REPUBLICAN CANDIDATES FOR REPUBLICAN RESPONDENTS******
ologit votegregdavis pid7 educ south gender income  c.raceresentscale##whiterepub_treatments if pid7>.5 [pweight = weight]

ologit fair_gregdavis pid7 educ south gender income  c.raceresentscale##whiterepub_treatments if pid7>.5 [pweight = weight]

ologit davis_affirmact pid7 educ south gender income   c.raceresentscale##whiterepub_treatments if pid7>.5 [pweight = weight]


ologit gregdavis_redcrim pid7 educ south gender income   c.raceresentscale##whiterepub_treatments if pid7>.5 [pweight = weight]

ologit blacksoverwhites pid7 educ south gender income   c.raceresentscale##whiterepub_treatments if pid7>.5 [pweight = weight]



**************Table B6: Ordered Logit Models by Treatment Interacted With Racial Resentment:WHITE REPUBLICAN CANDIDATES FOR DEMOCRATIC RESPONDENTS******
ologit votegregdavis pid7 educ south gender income  c.raceresentscale##whiterepub_treatments if pid7<.5 [pweight = weight]


ologit fair_gregdavis pid7 educ south gender income  c.raceresentscale##whiterepub_treatments if pid7<.5 [pweight = weight]


ologit davis_affirmact pid7 educ south gender income   c.raceresentscale##whiterepub_treatments if pid7<.5 [pweight = weight]

ologit gregdavis_redcrim pid7 educ south gender income  c.raceresentscale##whiterepub_treatments if pid7<.5 [pweight = weight]


ologit blacksoverwhites pid7 educ south gender income   c.raceresentscale##whiterepub_treatments if pid7<.5 [pweight = weight]


*********************SUMMARY STATS GRAPHS*****************

*****FIGURE B1**********
**GRAPH NAME: S1
graph bar if treatments==0, over(votegregdavis)
**GRAPH NAME: S2
graph bar  if treatments==1, over(votegregdavis)
**GRAPH NAME: S3
graph bar  if treatments==2, over(votegregdavis)
**GRAPH NAME: S4
graph bar if treatments==3, over(votegregdavis)
**GRAPH NAME: S5
graph bar if treatments==4, over(votegregdavis)
**GRAPH NAME: S6
graph bar if treatments==5, over(votegregdavis)

*******FIGURE B2***********
**GRAPH NAME: F1
graph bar if treatments==0, over(fair_gregdavis)
**GRAPH NAME: F2
graph bar  if treatments==1, over(fair_gregdavis)
**GRAPH NAME: F3
graph bar  if treatments==2, over(fair_gregdavis)
**GRAPH NAME: F4
graph bar if treatments==3, over(fair_gregdavis)
**GRAPH NAME: F5
graph bar if treatments==4, over(fair_gregdavis)
**GRAPH NAME: F6
graph bar if treatments==5, over(fair_gregdavis)

*******FIGURE B3*************
**GRAPH NAME: AF1
graph bar if treatments==0, over(davis_affirmact)
**GRAPH NAME: AF2
graph bar  if treatments==1, over(davis_affirmact)
**GRAPH NAME: AF3
graph bar  if treatments==2, over(davis_affirmact)
**GRAPH NAME: AF4
graph bar if treatments==3, over(davis_affirmact)
**GRAPH NAME: AF5WWEEEEEWE2222223323232
graph bar if treatments==4, over(davis_affirmact)
**GRAPH NAME: AF6
graph bar if treatments==5, over(davis_affirmact)

*************FIGURE B4***************
**GRAPH NAME: R1
graph bar if treatments==0, over(gregdavis_redcrim)
**GRAPH NAME: R2
graph bar  if treatments==1, over(gregdavis_redcrim)
**GRAPH NAME: R3
graph bar  if treatments==2, over(gregdavis_redcrim)
**GRAPH NAME: R4
graph bar if treatments==3, over(gregdavis_redcrim)
**GRAPH NAME: R5
graph bar if treatments==4, over(gregdavis_redcrim)
**GRAPH NAME: R6
graph bar if treatments==5, over(gregdavis_redcrim)

***************FIGURE B5*****************
**GRAPH NAME: BW1
graph bar if treatments==0, over(blacksoverwhites)
**GRAPH NAME: BW2
graph bar  if treatments==1, over(blacksoverwhites)
**GRAPH NAME: BW3
graph bar  if treatments==2, over(blacksoverwhites)
**GRAPH NAME: BW4
graph bar if treatments==3, over(blacksoverwhites)
**GRAPH NAME: BW5
graph bar if treatments==4, over(blacksoverwhites)
**GRAPH NAME: BW6
graph bar if treatments==5, over(blacksoverwhites)
