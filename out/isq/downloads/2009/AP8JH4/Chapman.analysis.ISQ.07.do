************************************************************************************************
**7-25-2005								         **
**Terry Chapman							         **
**Emory University							         **
**This file contains the final commands for analysis in Chapman's July 2005        **
**paper on endogeneity in the relationship between civic institutions and violence **
**Analyses performed in STATA 9				                     **
************************************************************************************************

*Ordered Probit
estsimp oprobit violence civicindex1 ethnicid ideol ideol2 income age gender educ lifsatis conf_natgov lngdppc lag5count [pweight=v236], robust cluster(nation)
estsimp oprobit violence civicindex1 ethnicid int1 ideol ideol2 income age gender educ lifsatis conf_natgov lngdppc lag5count [pweight=v236], robust cluster(nation)

*Fixed country effects*
estsimp oprobit violence civicindex1 ethnicid ideol ideol2 income age gender educ lifsatis conf_natgov cdum* [pweight=v236], robust cluster(nation)
estsimp oprobit violence civicindex1 ethnicid int1 ideol ideol2 income age gender educ lifsatis conf_natgov cdum* [pweight=v236], robust cluster(nation)

*2SLS
ivreg  violence ethnicid ideol income age gender educ lifsatis conf_natgov lngdppc lag5count (civicindex1=ethnicid ideol income age gender educ lifsatis conf_natgov lngdppc lag5count  avgciv) [weight=v236], robust cluster(nation) first

*2 stage ordered probit
reg civicindex1 ethnicid ideol income age gender educ lifsatis conf_natgov lngdppc lag5count avgciv [pweight=v236], robust cluster(nation)
predict civindpr, xb
set seed 10
bootstrap, reps (500): "oprobit" vilence civindpr ethnicid ideol income age gender educ lifsatis conf_natgov lngdppc lag5count, robust cluster(nation)

*Fixed effects on predicting civicindex equation*
reg civicindex1 ethnicid ideol income age gender educ lifsatis conf_natgov avgciv cdum* [pweight=v236], robust cluster(nation)
predict civindpr, xb
bootstrap, reps(100): "oprobit" violence civindpr ethnicid ideol income age gender educ lifsatis conf_natgov lngdppc lag5count, robust cluster(nation)

