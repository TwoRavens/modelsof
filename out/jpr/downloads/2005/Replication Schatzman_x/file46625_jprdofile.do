**************************************JPR Political Challenge********************************************
*version 8.0
set more off
use "C:\Documents and Settings\xina\Desktop\jprdata.dta"
log using jpr, replace
pwcorr rebellion polity calorchg unplchg ecocrisis hdii ginii capavg3 sdnew usinfluence demagedum rnlag
pwcorr colprotst polity1 calorchg unplchg ecocrisis hdii ginii capavg3 sdnew usinfluence demagedum pnlag corrupti

*to examine shape of count variables
hist rebellion
sum rebellion, d
nbvargr rebellion
hist colprotst
sum colprotst, d
nbvargr colprotst
*both right skewed, variance much greater than mean, dvs more closely fit nbreg --negative binomial

*run as poisson to examine if applicable to count data
poisson rebellion polity calorchg unplchg ecocrisis capavg3 sdnew usinfluence demagedum rnlag
*to perform goodness-of-fit test with deviance statistic
poisgof
poisson colprotst polity calorchg unplchg ecocrisis capavg3 sdnew usinfluence demagedum pnlag corrupti ginii
poisgof
*large chi-square value indicating poisson inappropriate for models--nbreg given overdispersion

*to run negative binomial on rebellion (N102)
nbreg rebellion polity1 polity2 calorchg unplchg ecocrisis hdii ginii capavg3 sdnew usinfluence demagedum rnlag, robust
*perform Wald test of linear hypotheses
test polity1 polity2 
nbreg rebellion polity calorchg unplchg ecocrisis hdii ginii capavg3 sdnew usinfluence demagedum rnlag
estimates table, stats( chi2 N ll) se(%9.3f) style(nolines)
estimates table, stats( chi2 N ll) star(.05 .01 .001) style(nolines)
outreg using "C:\Publications\JPR\pc.doc", nolabel replace se 

*to examine substantive effects with clarify
estsimp nbreg rebellion polity calorchg unplchg ecocrisis hdii ginii capavg3 sdnew usinfluence demagedum rnlag
setx mean
simqi
*to examine change in E(Y)of variables of interest given change from mean to +1 SD
sum polity hdii capavg3 sdnew rnlag
simqi, fd(ev) changex(polity 3.782 9.754)
simqi, fd(ev) changex(hdii .695 .781)
simqi, fd(ev) changex(capavg3 4.41 5.739)
simqi, fd(ev) changex(sdnew 2.868 3.880)

*to run negative binomial on protest (N=94)
nbreg colprotst polity1 polity2 calorchg unplchg ecocrisis hdii ginii capavg3 sdnew usinfluence demagedum pnlag corrupti
*perform Wald test of linear hypotheses
test polity1 polity2 
nbreg colprotst polity1 polity2 polity3 calorchg unplchg ecocrisis hdii ginii capavg3 sdnew usinfluence demagedum pnlag corrupti
*perform Wald test of linear hypotheses
test polity1 polity2 polity3
estimates table, stats( chi2 N ll) se(%9.3f) style(nolines)
estimates table, stats( chi2 N ll) star(.05 .01 .001) style(nolines)
outreg using "C:\Publications\JPR\pc.doc", nolabel append se 

*to examine substantive effects with clarify
drop  b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13
estsimp nbreg colprotst polity1 polity2 polity3 calorchg unplchg ecocrisis hdii ginii capavg3 sdnew usinfluence demagedum pnlag corrupti
setx mean
simqi
simqi, genev(predval)
*to examine change in E(Y) given change from mean to +1 SD
sum polity1 polity2 polity3 sdnew
simqi, fd(ev) changex(polity1 14.782 20.754 polity2 254.02 402.364 polity3 4625.282 7794.701)
simqi, fd(ev) changex(sdnew 2.868 3.88)
drop  b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 

*to run as ols and check vif values for intercorrelations
regress rebellion polity calorchg unplchg ecocrisis hdii ginii capavg3 sdnew usinfluence demagedum rnlag
vif
regress colprotst polity calorchg unplchg ecocrisis hdii ginii capavg3 sdnew usinfluence demagedum pnlag corrupti
vif
