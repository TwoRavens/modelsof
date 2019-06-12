*Note: Analysis was completed in Stata 13. Please send any questions to aflorearo@gmail.com.


use BellWolford_Replication_Florea.dta

***Table 1: The Delayed Effects of Oil Discovery***
tsset ccode year
xtreg prod discover l.discover l2.discover l3.discover l4.discover l5.discover l6.discover l7.discover l8.discover, fe
xtreg pcgdp discover l.discover l2.discover l3.discover l4.discover l5.discover l6.discover l7.discover l8.discover, fe

*A note on EIA data: The EIA reports reserves in billions of barrels but reports production in thousands of barrels per day. To convert production data to the same scale, which is necessary to create the oil discovery variable, multiply the EIA’s production variable by 365/1000000 and add 1/365th of this for leap years. This converted variable is named “prod” in the dataset. Then, the discovery measure (OilDisc) is created with the following code:

gen OilDisc=reserves-(l.reserves-l.prod)
replace OilDisc=0 if OilDisc<0 & OilDisc~=.
replace OilDisc=ln(OilDisc/l.reserves+1)
replace OilDisc=0 if reserves==0 & l.reserves==0


***Figure 2: Lag Structure Optimization***

logit onset OilDisc loggdp gdpINT lagpcoilprod laglogpop laglogdurable ethfrac relfrac lmtnest lagxpolity if lag8~=., cluster(ccode) robust
estimates store lag0
logit onset OilDisc loggdp gdpINT lagpcoilprod laglogpop laglogdurable ethfrac relfrac lmtnest lagxpolity lag1 if lag8~=., cluster(ccode) robust
estimates store lag1
logit onset OilDisc loggdp gdpINT lagpcoilprod laglogpop laglogdurable ethfrac relfrac lmtnest lagxpolity lag1 lag2 if lag8~=., cluster(ccode) robust
estimates store lag2
logit onset OilDisc loggdp gdpINT lagpcoilprod laglogpop laglogdurable ethfrac relfrac lmtnest lagxpolity lag1 lag2 lag3 if lag8~=., cluster(ccode) robust
estimates store lag3
logit onset OilDisc loggdp gdpINT lagpcoilprod laglogpop laglogdurable ethfrac relfrac lmtnest lagxpolity lag1 lag2 lag3 lag4 if lag8~=., cluster(ccode) robust
estimates store lag4
logit onset OilDisc loggdp gdpINT lagpcoilprod laglogpop laglogdurable ethfrac relfrac lmtnest lagxpolity lag1 lag2 lag3 lag4 lag5 if lag8~=., cluster(ccode) robust
estimates store lag5
logit onset OilDisc loggdp gdpINT lagpcoilprod laglogpop laglogdurable ethfrac relfrac lmtnest lagxpolity lag1 lag2 lag3 lag4 lag5 lag6 if lag8~=., cluster(ccode) robust
estimates store lag6
logit onset OilDisc loggdp gdpINT lagpcoilprod laglogpop laglogdurable ethfrac relfrac lmtnest lagxpolity lag1 lag2 lag3 lag4 lag5 lag6 lag7 if lag8~=., cluster(ccode) robust
estimates store lag7
logit onset OilDisc loggdp gdpINT lagpcoilprod laglogpop laglogdurable ethfrac relfrac lmtnest lagxpolity lag1 lag2 lag3 lag4 lag5 lag6 lag7 lag8 if lag8~=., cluster(ccode) robust
estimates store lag8

estimates table lag0 lag1 lag2 lag3 lag4 lag5 lag6 lag7 lag8, p keep(OilDisc loggdp gdpINT)
estimates stats lag0 lag1 lag2 lag3 lag4 lag5 lag6 lag7 lag8



***Table 2: Logit Models of Civil Conflict Onset
***Table A: Logit Models of Civil War Continuation
*MODEL ONE
logit onset OilDisc loggdp gdpINT lagpcoilprod laglogpop laglogdurable ethfrac relfrac lmtnest lagxpolity lag1 lag2 lag3 lag4 lag5 if lag8~=., cluster(ccode) robust
logit civilwar OilDisc loggdp gdpINT lagpcoilprod laglogpop laglogdurable ethfrac relfrac lmtnest lagxpolity lag1 lag2 lag3 lag4 lag5 if lag8~=., cluster(ccode) robust
logit civilwar OilDisc loggdp gdpINT lagpcoilprod laglogpop laglogdurable ethfrac relfrac lmtnest lagxpolity if lag8~=., cluster(ccode) robust


*MODEL TWO
xtlogit onset OilDisc loggdp gdpINT lagpcoilprod laglogpop laglogdurable ethfrac relfrac lmtnest lagxpolity lag1 lag2 lag3 lag4 lag5 if lag8~=., fe i(ccode)
xtlogit civilwar OilDisc loggdp gdpINT lagpcoilprod laglogpop laglogdurable ethfrac relfrac lmtnest lagxpolity lag1 lag2 lag3 lag4 lag5 if lag8~=., fe i(ccode)

*MODEL THREE
logit onset OilDisc loggdp lagpcoilprod laglogpop laglogdurable ethfrac relfrac lmtnest lagxpolity lag1 lag2 lag3 lag4 lag5 if lag8~=. & loggdp<7.1, cluster(ccode) robust
logit civilwar OilDisc loggdp lagpcoilprod laglogpop laglogdurable ethfrac relfrac lmtnest lagxpolity lag1 lag2 lag3 lag4 lag5 if lag8~=. & loggdp<7.1, cluster(ccode) robust

*MODEL FOUR
logit onset OilDisc loggdp lagpcoilprod laglogpop laglogdurable ethfrac relfrac lmtnest lagxpolity lag1 lag2 lag3 lag4 lag5 if lag8~=. & loggdp>7.1, cluster(ccode) robust
logit civilwar OilDisc loggdp lagpcoilprod laglogpop laglogdurable ethfrac relfrac lmtnest lagxpolity lag1 lag2 lag3 lag4 lag5 if lag8~=. & loggdp>7.1, cluster(ccode) robust


*MODEL FIVE
logit onsetwar OilDisc loggdp gdpINT lagpcoilprod laglogpop laglogdurable ethfrac relfrac lmtnest lagxpolity lag1 lag2 lag3 lag4 lag5 if lag8~=., cluster(ccode) robust
logit civilwar OilDisc loggdp gdpINT lagpcoilprod laglogpop laglogdurable ethfrac relfrac lmtnest lagxpolity lag1 lag2 lag3 lag4 lag5 if lag8~=., cluster(ccode) robust



***Claims in Discussion of Results (Predicted Probabilities) and Data for Figure 3

estsimp logit onset OilDisc loggdp gdpINT lagpcoilprod laglogpop laglogdurable ethfrac relfrac lmtnest lagxpolity lag1 lag2 lag3 lag4 lag5 if lag8~=., cluster(ccode) robust

setx mean
*@100 pc
setx loggdp 4.615
simqi, fd(pr) changex(OilDisc 0 .1 gdpINT 0 4.615*.1) level(90)
simqi, fd(pr) changex(OilDisc 0 .405 gdpINT 0 4.615*.405) level(90)

*@500 pc
setx loggdp 6.214 OilDisc 0 gdpINT 0
simqi, level(90)
simqi, fd(pr) changex(OilDisc 0 .1 gdpINT 0 6.214*.1) level(90)
simqi, fd(pr) changex(OilDisc 0 .405 gdpINT 0 6.214*.405) level(90)


*@1000 pc
setx loggdp 6.908 OilDisc 0 gdpINT 0
simqi, level(90)
simqi, fd(pr) changex(OilDisc 0 .695 gdpINT 0 6.908*.695) level(90)

setx loggdp 6.688
simqi, fd(pr) changex(OilDisc 0 1 gdpINT 0 6.688) level(90)

setx loggdp 8.365
simqi, fd(pr) changex(OilDisc 0 1 gdpINT 0 8.365) level(90)

setx loggdp 9.98
simqi, fd(pr) changex(OilDisc 0 1 gdpINT 0 9.98) level(90)


***Robustness (Table 3)
***Table B: Civil War Continuation


*FOOD CONTROL (Model 6)
logit onset OilDisc loggdp gdpINT kcal_day lagpcoilprod laglogpop laglogdurable ethfrac relfrac lmtnest lagxpolity lag1 lag2 lag3 lag4 lag5 if lag8~=., cluster(ccode) robust
logit civilwar OilDisc loggdp gdpINT kcal_day lagpcoilprod laglogpop laglogdurable ethfrac relfrac lmtnest lagxpolity lag1 lag2 lag3 lag4 lag5 if lag8~=., cluster(ccode) robust


*FOOD INT (Model 7)
logit onset OilDisc loggdp foodINT kcal_day lagpcoilprod laglogpop laglogdurable ethfrac relfrac lmtnest lagxpolity lag1 lag2 lag3 lag4 lag5 if lag8~=., cluster(ccode) robust
logit civilwar OilDisc loggdp foodINT kcal_day lagpcoilprod laglogpop laglogdurable ethfrac relfrac lmtnest lagxpolity lag1 lag2 lag3 lag4 lag5 if lag8~=., cluster(ccode) robust


*POLITY INT (Model 8)
logit onset OilDisc loggdp xpolityINT kcal_day lagpcoilprod laglogpop laglogdurable ethfrac relfrac lmtnest lagxpolity lag1 lag2 lag3 lag4 lag5 if lag8~=., cluster(ccode) robust
logit civilwar OilDisc loggdp xpolityINT kcal_day lagpcoilprod laglogpop laglogdurable ethfrac relfrac lmtnest lagxpolity lag1 lag2 lag3 lag4 lag5 if lag8~=., cluster(ccode) robust


*DURABLE INT (Model 9)
logit onset OilDisc loggdp durableINT kcal_day lagpcoilprod laglogpop laglogdurable ethfrac relfrac lmtnest lagxpolity lag1 lag2 lag3 lag4 lag5 if lag8~=., cluster(ccode) robust
logit civilwar OilDisc loggdp durableINT kcal_day lagpcoilprod laglogpop laglogdurable ethfrac relfrac lmtnest lagxpolity lag1 lag2 lag3 lag4 lag5 if lag8~=., cluster(ccode) robust
