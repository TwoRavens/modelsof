***************************************************************************************************************************
***************************************************************************************************************************
************************************** Heather Elko McKibben & Shaina Western *********************************************
****** analysis for: "Reserved Ratification: An Analysis of States' Entry of Reservations Upon Treaty Ratification"  ******
*************************************** British Journal of Political Science **********************************************
****************************************** analyses run using Stata 14.2 **************************************************
***************************************************************************************************************************
***************************************************************************************************************************

*Set directory
cd "CHOOSE DIRECTORY"

*get data
use McKibben-Western_Reserved Ratification_data.dta, clear



gen res_12 = 0
replace res_12 = 1 if res_1 == 1
replace res_12 = 1 if res_2 == 1

************************************************************************************************************************************************
*************************************MODEL 1A: ANALYZE RATIFICATION OF ANY KIND FOR REGIMES TRANSITIONING FROM MORE REPRESSIVE *****************
************************************************************************************************************************************************
*** Set the data to use in a duration analysis ***
stset duration2, failure(ratindc==1) id(id)
kdensity _t, sort title(Density of Ratification)

*Get baseline survival and hazard

sts graph, survival

sts graph, hazard


*test for proportional hazard assumption
stcox transitional islamiclaw commonlaw lntreatyratifierstodate,  efron cluster(id) 
estat phtest, detail
*islamiclaw and commonlaw violate at .03

*check islamiclaw
*check "islamiclaw"
* adjustment variables held at mean
stphplot, by(islamiclaw) adjust(transitional commonlaw lntreatyratifierstodate) 
* adjustment variables held at zero
stphplot, by(islamiclaw) adjust(transitional commonlaw lntreatyratifierstodate) zero
*looks like lines are not parallel

*check "commonlaw"
* adjustment variables held at mean
stphplot, by(commonlaw) adjust(transitional islamiclaw lntreatyratifierstodate) 
* adjustment variables held at zero
stphplot, by(commonlaw) adjust(transitional islamiclaw lntreatyratifierstodate) zero
*looks like lines are not parallel



gen ln_t= ln(_t+1)
gen lntxislamiclaw = ln_t*islamiclaw
gen lntxcommonlaw = ln_t*commonlaw

*Final Model
stcox transitional islamiclaw commonlaw lntreatyratifierstodate lntxislamiclaw lntxcommonlaw,  efron cluster(id) 


stcurve, survival at1(transitional=0) at2(transitional=1 )

stcurve, hazard at1(transitional=0) at2(transitional=1 )

drop ln_t
drop lntxislamiclaw
drop lntxcommonlaw 



************************************************************************************************************************************************
*************************************MODEL 1B: ANALYZE RATIFICATION WITHOUT SUBSTANTIVE FOR REGIMES TRANSITIONING FROM MORE REPRESSIVE **********
************************************************************************************************************************************************
*** Set the data to use in a duration analysis ***
stset duration2, failure(res_12==1) id(id)
kdensity _t, sort title(Density of Ratification)

*Get baseline survival and hazard
sts graph, survival

sts graph, hazard



*test for proportional hazard assumption
stcox transitional islamiclaw commonlaw lntreatyratifierstodate,  efron cluster(id) 
estat phtest, detail
*none violate at .03 level


*Final Model
stcox transitional islamiclaw commonlaw lntreatyratifierstodate,  efron cluster(id) 

stcurve, survival at1(transitional=0) at2(transitional=1)

stcurve, hazard at1(transitional=0) at2(transitional=1)



************************************************************************************************************************************************
*************************************MODEL 2A: ANALYZE RATIFICATION (OF ANY KIND) FOR REPRESSIVE REGIMES ****************************************
************************************************************************************************************************************************
*** Set the data to use in a duration analysis ***
stset duration2, failure(ratindc==1) id(id)
kdensity _t, sort title(Density of Ratification)




* Generate repressive variable (= repressive or suppressive parcomp in Polity IV data)
gen repressive = 0
replace repressive = 1 if parcomp == 1
replace repressive = 1 if parcomp == 2





stcox repressive islamiclaw commonlaw lntreatyratifierstodate,  efron cluster(id) 

*** Phtest based on residuals 
*** Looking for variables to be above .03 as test is very sensitive
estat phtest, detail
*islamiclaw and commonlaw violate at .03 level



*check "islamiclaw"
* adjustment variables held at mean
stphplot, by(islamiclaw) adjust(repressive commonlaw lntreatyratifierstodate) 
* adjustment variables held at zero
stphplot, by(islamiclaw) adjust(repressive commonlaw lntreatyratifierstodate) zero
*looks like lines are not parallel when others are held at mean

*check "commonlaw"
* adjustment variables held at mean
stphplot, by(commonlaw) adjust(repressive islamiclaw lntreatyratifierstodate) 
* adjustment variables held at zero
stphplot, by(commonlaw) adjust(repressive islamiclaw lntreatyratifierstodate) zero
*looks like lines are not parallel


gen ln_t= ln(_t+1)
gen lntxislamiclaw = ln_t*islamiclaw
gen lntxcommonlaw = ln_t*commonlaw

**FINAL MODEL
stcox repressive islamiclaw commonlaw lntreatyratifierstodate lntxislamiclaw lntxcommonlaw,  efron cluster(id) 


stcurve, survival at1(repressive=0) at2(repressive=1 )

stcurve, hazard at1(repressive=0) at2(repressive=1 )

drop ln_t
drop lntxislamiclaw
drop lntxcommonlaw



*******************************************************************

************************************************************************************************************************************************
*************************************MODEL 2B: ANALYZE RATIFICATION WITH TREATY-QUALIFYING FOR REPRESSIVE REGIMES ******************************
************************************************************************************************************************************************
*** Set the data to use in a duration analysis ***
stset duration2, failure(res_5==1) id(id)
kdensity _t, sort title(Density of Ratification)

*Get baseline hazard
sts graph, survival

sts graph, hazard

***test for proportional hazards assumption
stcox repressive islamiclaw commonlaw lntreatyratifierstodate,  efron cluster(id) 
estat phtest, detail

*no variables violate at .03 level--> final model is original model
stcox repressive islamiclaw commonlaw lntreatyratifierstodate,  efron cluster(id) 

stcurve, survival at1(repressive=0) at2(repressive=1)

stcurve, hazard at1(repressive=0) at2(repressive=1)



************************************************************************************************************************************************
*************************************MODEL 3A: ANALYZE RATIFICATION WITH PROCEDURAL FOR EXECS MORE CONSTRAINED ******************************
************************************************************************************************************************************************
*** Set the data to use in a duration analysis ***
stset duration2, failure(res_3==1) id(id)
kdensity _t, sort title(Density of Ratification)

*Get baseline hazard
sts graph, survival

sts graph, hazard

replace xconst = . if xconst == -88
replace xconst = . if xconst == -77
replace xconst = . if xconst == -66

*more constrained = greater value of xconst from Polity IV data
gen constrainedexec = xconst-1

stcox constrainedexec islamiclaw commonlaw lntreatyratifierstodate,  efron cluster(id) 
estat phtest, detail

*islamiclaw violates at < .03

*** Graphically assess propotional hazards
*** Looking for the lines to be parallel
*check "islamiclaw"
* adjustment variables held at mean
stphplot, by(islamiclaw) adjust(constrainedexec commonlaw lntreatyratifierstodate) 
* adjustment variables held at zero
stphplot, by(islamiclaw) adjust(constrainedexec commonlaw lntreatyratifierstodate) zero
*looks like lines are not parallel when others at mean --> islamiclaw violates


gen ln_t= ln(_t+1)
gen lntxislamiclaw = ln_t*islamiclaw


*FINAL MODEL
stcox constrainedexec islamiclaw commonlaw lntreatyratifierstodate lntxislamiclaw,  efron cluster(id) 


stcurve, survival at1(constrainedexec=0) at2(constrainedexec=6)

stcurve, hazard at1(constrainedexec=0) at2(constrainedexec=6)

drop ln_t
drop lntxislamiclaw




************************************************************************************************************************************************
*************************************MODEL 3B: ANALYZE RATIFICATION WITH ARTICLE-QUALIFYING FOR EXECS MORE CONSTRAINED *************************
************************************************************************************************************************************************
*** Set the data to use in a duration analysis ***
stset duration2, failure(res_4==1) id(id)
kdensity _t, sort title(Density of Ratification)

*Get baseline hazard
sts graph, survival

sts graph, hazard

stcox constrainedexec islamiclaw commonlaw lntreatyratifierstodate,  efron cluster(id) 
estat phtest, detail

*none violate at < .03

*FINAL MODEL
stcox constrainedexec islamiclaw commonlaw lntreatyratifierstodate,  efron cluster(id) 

stcurve, survival at1(constrainedexec=0) at2(constrainedexec=6)

stcurve, hazard at1(constrainedexec=0) at2(constrainedexec=6)


************************************************************************************************************************************************
*************************************MODEL 4A: ANALYZE RATIFICATION WITH PROCEDURAL FOR EXECS FACING MORE POWERFUL LEGISLATURE ****************
************************************************************************************************************************************************
*** Set the data to use in a duration analysis ***
stset duration2, failure(res_3==1) id(id)
kdensity _t, sort title(Density of Ratification)


stcox polconiii islamiclaw commonlaw lntreatyratifierstodate,  efron cluster(id) 
estat phtest, detail

*islamiclaw violates at < .03

*** Graphically assess propotional hazards
*** Looking for the lines to be parallel
*check "islamiclaw"
* adjustment variables held at mean
stphplot, by(islamiclaw) adjust(polconiii commonlaw lntreatyratifierstodate) 
* adjustment variables held at zero
stphplot, by(islamiclaw) adjust(polconiii commonlaw lntreatyratifierstodate) zero
*looks like lines are not parallel when others at mean --> islamiclaw violates


gen ln_t= ln(_t+1)
gen lntxislamiclaw = ln_t*islamiclaw


*FINAL MODEL
stcox polconiii islamiclaw commonlaw lntreatyratifierstodate lntxislamiclaw,  efron cluster(id) 

stcurve, survival at1(polconiii=0) at2(polconiii=.72)

stcurve, hazard at1(polconiii=0) at2(polconiii=.72)


drop ln_t
drop lntxislamiclaw



************************************************************************************************************************************************
*************************************MODEL 4B: ANALYZE RATIFICATION WITH ARTICLE-QUALIFYING FOR EXECS FACING MORE POWERFUL LEGISLATURE *********
************************************************************************************************************************************************
*** Set the data to use in a duration analysis ***
stset duration2, failure(res_4==1) id(id)
kdensity _t, sort title(Density of Ratification)


stcox polconiii islamiclaw commonlaw lntreatyratifierstodate, efron cluster(id) 
estat phtest, detail

*none violate at < .03
stcox polconiii islamiclaw commonlaw lntreatyratifierstodate, efron cluster(id) 

stcurve, survival at1(polconiii=0) at2(polconiii=.72)

stcurve, hazard at1(polconiii=0) at2(polconiii=.72)


************************************************************************************************************************************************
*************************************MODEL 5A: ANALYZE RATIFICATION WITH PROCEDURAL FOR EXECS FACING MORE INDEPENDENT JUDICIARY ****************
************************************************************************************************************************************************
*** Set the data to use in a duration analysis ***
stset duration2, failure(res_3==1) id(id)
kdensity _t, sort title(Density of Ratification)

*Get baseline hazard
sts graph

stcox lji islamiclaw commonlaw lntreatyratifierstodate,  efron cluster(id) 
estat phtest, detail

*islamiclaw and commonlaw and modified violates at < .03

*** Graphically assess propotional hazards
*** Looking for the lines to be parallel
*check "islamiclaw"
* adjustment variables held at mean
stphplot, by(islamiclaw) adjust(lji commonlaw lntreatyratifierstodate) 
* adjustment variables held at zero
stphplot, by(islamiclaw) adjust(lji commonlaw lntreatyratifierstodate) zero
*looks like lines are not parallel when others at mean

*check "commonlaw"
* adjustment variables held at mean
stphplot, by(commonlaw) adjust(lji islamiclaw lntreatyratifierstodate) 
* adjustment variables held at zero
stphplot, by(commonlaw) adjust(lji islamiclaw lntreatyratifierstodate) zero
*looks like lines are not parallel 


gen ln_t= ln(_t+1)
gen lntxislamiclaw = ln_t*islamiclaw
gen lntxcommonlaw = ln_t*commonlaw

**FINAL MODEL
stcox lji islamiclaw commonlaw lntreatyratifierstodate lntxislamiclaw lntxcommonlaw,  efron cluster(id) 

stcurve, survival at1(lji=.0102) at2(lji=.9953)

stcurve, hazard at1(lji=.0102) at2(lji=.9953)

drop ln_t
drop lntxislamiclaw
drop lntxcommonlaw



************************************************************************************************************************************************
*************************************MODEL 5B: ANALYZE RATIFICATION WITH ARTICLE-QUALIFYING FOR EXECS FACING MORE INDEPENDENT JUDICIARY ****************
************************************************************************************************************************************************
*** Set the data to use in a duration analysis ***
stset duration2, failure(res_4==1) id(id)
kdensity _t, sort title(Density of Ratification)

*Get baseline hazard
sts graph

stcox lji islamiclaw commonlaw lntreatyratifierstodate,  efron cluster(id) 
estat phtest, detail

*no variables violate at < .03

**FINAL MODEL
stcox lji islamiclaw commonlaw lntreatyratifierstodate,  efron cluster(id) 

stcurve, survival at1(lji=.0102) at2(lji=.9953)

stcurve, hazard at1(lji=.0102) at2(lji=.9953)









use McKibben-Western_Reserved Ratification_data.dta, clear

gen res_12 = 0
replace res_12 = 1 if res_1 == 1
replace res_12 = 1 if res_2 == 1


**************************************************************************************************************************************************************
**************************************************************************************************************************************************************
************************************************************** "a" SET OF MODELS: HECKMAN PROBIT MODELS ******************************************************
**************************************************************************************************************************************************************
**************************************************************************************************************************************************************




************************************************************************************************************************************************
*************************************MODEL 1Aa: ANALYZE RATIFICATION OF ANY KIND FOR REGIMES TRANSITIONING FROM MORE REPRESSIVE *****************
************************************************************************************************************************************************

*generate transitional variable (where transitional is only those coming from a more repressive regime)

probit ratindc transitional islamiclaw commonlaw lntreatyratifierstodate, cluster(id)
*transitional + but not significant


************************************************************************************************************************************************
*************************************MODEL 1Ba: ANALYZE RATIFICATION WITHOUT SUBSTANTIVE FOR REGIMES TRANSITIONING FROM MORE REPRESSIVE **********
************************************************************************************************************************************************


*heckman probit.  selection equation = ratificiation, 2nd equation = no entry of a substantive reservation
heckprob res_12 transitional, select(ratindc = islamiclaw commonlaw lntreatyratifierstodate) cluster(id)

************************************************************************************************************************************************
*************************************MODEL 2Aa: ANALYZE RATIFICATION (OF ANY KIND) FOR REPRESSIVE REGIMES ****************************************
************************************************************************************************************************************************

* Generate repressive variable (= repressive or suppressive parcomp in Polity IV data)
gen repressive = 0
replace repressive = 1 if parcomp == 1
replace repressive = 1 if parcomp == 2


probit ratindc repressive islamiclaw commonlaw lntreatyratifierstodate, cluster(id)




************************************************************************************************************************************************
*************************************MODEL 2Ba: ANALYZE RATIFICATION WITH TREATY-QUALIFYING FOR REPRESSIVE REGIMES ******************************
************************************************************************************************************************************************

*heckman probit.  selection equation = ratificiation, 2nd equation = entry of treatyqualifying reservation
heckprob res_5 repressive, select(ratindc = islamiclaw commonlaw lntreatyratifierstodate) cluster(id)




************************************************************************************************************************************************
*************************************MODEL 3Aa: ANALYZE RATIFICATION WITH PROCEDURAL FOR EXECS MORE CONSTRAINED ******************************
************************************************************************************************************************************************

replace xconst = . if xconst == -88
replace xconst = . if xconst == -77
replace xconst = . if xconst == -66

*more constrained = greater value of xconst from Polity IV data
gen constrainedexec = xconst

*heckman probit.  selection equation = ratificiation, 2nd equation = entry of procedural reservation
heckprob res_3 constrainedexec, select(ratindc = islamiclaw commonlaw lntreatyratifierstodate) cluster(id)


************************************************************************************************************************************************
*************************************MODEL 3Ba: ANALYZE RATIFICATION WITH ARTICLE-QUALIFYING FOR EXECS MORE CONSTRAINED *************************
************************************************************************************************************************************************


*heckman probit.  selection equation = ratificiation, 2nd equation = entry of article-qualifying reservation
heckprob res_4 constrainedexec, select(ratindc = islamiclaw commonlaw lntreatyratifierstodate) cluster(id)



************************************************************************************************************************************************
*************************************MODEL 4Aa: ANALYZE RATIFICATION WITH PROCEDURAL FOR EXECS FACING MORE POWERFUL LEGISLATURE ****************
************************************************************************************************************************************************


*heckman probit.  selection equation = ratificiation, 2nd equation = entry of procedural reservation
heckprob res_3 polconiii, select(ratindc = islamiclaw commonlaw lntreatyratifierstodate) cluster(id)



************************************************************************************************************************************************
*************************************MODEL 4Ba: ANALYZE RATIFICATION WITH ARTICLE-QUALIFYING FOR EXECS FACING MORE POWERFUL LEGISLATURE ****************
************************************************************************************************************************************************

*heckman probit.  selection equation = ratificiation, 2nd equation = entry of article-qualifying reservation
heckprob res_4 polconiii, select(ratindc = islamiclaw commonlaw lntreatyratifierstodate) cluster(id)



************************************************************************************************************************************************
*************************************MODEL 5Aa: ANALYZE RATIFICATION WITH PROCEDURAL FOR EXECS FACING MORE INDEPENDENT JUDICIARY ****************
************************************************************************************************************************************************


*heckman probit.  selection equation = ratificiation, 2nd equation = entry of procedural reservation
heckprob res_3 lji, select(ratindc = islamiclaw commonlaw lntreatyratifierstodate) cluster(id)



************************************************************************************************************************************************
*************************************MODEL 5Ba: ANALYZE RATIFICATION WITH ARTICLE-QUALIFYING FOR EXECS FACING MORE INDEPENDENT JUDICIARY ****************
************************************************************************************************************************************************

*heckman probit.  selection equation = ratificiation, 2nd equation = entry of article-qualifying reservation
heckprob res_4 lji, select(ratindc = islamiclaw commonlaw lntreatyratifierstodate) cluster(id)






use McKibben-Western_Reserved Ratification_data.dta, clear

gen res_12 = 0
replace res_12 = 1 if res_1 == 1
replace res_12 = 1 if res_2 == 1

*********************************************************************************************************************************************
*********************************************************************************************************************************************
************************************************ "b" SET OF MODELS: INCLUDE LNTREATYRATIFIERSTODATE AND PHYSINT *****************************
*********************************************************************************************************************************************
*********************************************************************************************************************************************


************************************************************************************************************************************************
*************************************MODEL 1Ab: ANALYZE RATIFICATION OF ANY KIND FOR REGIMES TRANSITIONING FROM MORE REPRESSIVE *****************
************************************************************************************************************************************************
*** Set the data to use in a duration analysis ***
stset duration2, failure(ratindc==1) id(id)
kdensity _t, sort title(Density of Ratification)

*Get baseline hazard
sts graph


*test for proportional hazard assumption
stcox transitional islamiclaw commonlaw lntreatyratifierstodate physint,  efron cluster(id) 
estat phtest, detail
*islamiclaw and commonlaw and lntreatyratifiers violate at .03

*check islamiclaw
*check "islamiclaw"
* adjustment variables held at mean
stphplot, by(islamiclaw) adjust(transitional commonlaw lntreatyratifierstodate physint) 
* adjustment variables held at zero
stphplot, by(islamiclaw) adjust(transitional commonlaw lntreatyratifierstodate physint) zero
*looks like lines are not parallel when others are at mean

*check "commonlaw"
* adjustment variables held at mean
stphplot, by(commonlaw) adjust(transitional islamiclaw lntreatyratifierstodate physint) 
* adjustment variables held at zero
stphplot, by(commonlaw) adjust(transitional islamiclaw lntreatyratifierstodate physint) zero
*looks like lines are not parallel


*check "lntreatyratifierstodate"
* adjustment variables held at mean
stphplot, by(lntreatyratifierstodate) adjust(transitional islamiclaw commonlaw physint) 
* adjustment variables held at zero
stphplot, by(lntreatyratifierstodate) adjust(transitional islamiclaw commonlaw physint) zero
*looks like lines are parallel

gen ln_t= ln(_t+1)
gen lntxislamiclaw = ln_t*islamiclaw
gen lntxcommonlaw = ln_t*commonlaw

*Final Model
stcox transitional islamiclaw commonlaw lntreatyratifierstodate physint lntxislamiclaw lntxcommonlaw,  efron cluster(id) 

drop ln_t
drop lntxislamiclaw
drop lntxcommonlaw


************************************************************************************************************************************************
*************************************MODEL 1Bb: ANALYZE RATIFICATION WITHOUT SUBSTANTIVE FOR REGIMES TRANSITIONING FROM MORE REPRESSIVE **********
************************************************************************************************************************************************
*** Set the data to use in a duration analysis ***
stset duration2, failure(res_12==1) id(id)
kdensity _t, sort title(Density of Ratification)

*Get baseline hazard
sts graph


*test for proportional hazard assumption
stcox transitional islamiclaw commonlaw lntreatyratifierstodate physint,  efron cluster(id) 
estat phtest, detail
*lntreatyratifierstodate violate at .03 level

*check "lntreatyratifierstodate"
* adjustment variables held at mean
stphplot, by(lntreatyratifierstodate) adjust(transitional islamiclaw commonlaw physint) 
* adjustment variables held at zero
stphplot, by(lntreatyratifierstodate) adjust(transitional islamiclaw commonlaw physint) zero
*looks like lines are parallel


*Final Model
stcox transitional islamiclaw commonlaw lntreatyratifierstodate physint,  efron cluster(id) 


************************************************************************************************************************************************
*************************************MODEL 2Ab: ANALYZE RATIFICATION (OF ANY KIND) FOR REPRESSIVE REGIMES ****************************************
************************************************************************************************************************************************
*** Set the data to use in a duration analysis ***
stset duration2, failure(ratindc==1) id(id)
kdensity _t, sort title(Density of Ratification)

*Get baseline hazard
sts graph

* Generate repressive variable (= repressive or suppressive parcomp in Polity IV data)
gen repressive = 0
replace repressive = 1 if parcomp == 1
replace repressive = 1 if parcomp == 2




stcox repressive islamiclaw commonlaw lntreatyratifierstodate physint,  efron cluster(id) 

*** Phtest based on residuals 
*** Looking for variables to be above .03 as test is very sensitive
estat phtest, detail
*islamiclaw and commonlaw and lntreatyratifierstodate violate at .03 level



*check "islamiclaw"
* adjustment variables held at mean
stphplot, by(islamiclaw) adjust(repressive commonlaw lntreatyratifierstodate physint) 
* adjustment variables held at zero
stphplot, by(islamiclaw) adjust(repressive commonlaw lntreatyratifierstodate physint) zero
*looks like lines are not parallel when others are held at mean

*check "commonlaw"
* adjustment variables held at mean
stphplot, by(commonlaw) adjust(repressive islamiclaw lntreatyratifierstodate physint) 
* adjustment variables held at zero
stphplot, by(commonlaw) adjust(repressive islamiclaw lntreatyratifierstodate physint) zero
*looks like lines are not parallel

*check "lntreatyratifierstodate"
* adjustment variables held at mean
stphplot, by(lntreatyratifierstodate) adjust(repressive islamiclaw commonlaw physint) 
* adjustment variables held at zero
stphplot, by(lntreatyratifierstodate) adjust(repressive islamiclaw commonlaw physint) zero
*looks like lines are parallel


gen ln_t= ln(_t+1)
gen lntxislamiclaw = ln_t*islamiclaw
gen lntxcommonlaw = ln_t*commonlaw

**FINAL MODEL
stcox repressive islamiclaw commonlaw lntreatyratifierstodate physint lntxislamiclaw lntxcommonlaw,  efron cluster(id) 

drop ln_t
drop lntxislamiclaw
drop lntxcommonlaw



************************************************************************************************************************************************
*************************************MODEL 2Bb: ANALYZE RATIFICATION WITH TREATY-QUALIFYING FOR REPRESSIVE REGIMES ******************************
************************************************************************************************************************************************
*** Set the data to use in a duration analysis ***
stset duration2, failure(res_5==1) id(id)
kdensity _t, sort title(Density of Ratification)

*Get baseline hazard
sts graph

***test for proportional hazards assumption
stcox repressive islamiclaw commonlaw lntreatyratifierstodate physint,  efron cluster(id) 
estat phtest, detail
*lntreatyratifierstodate violate at .03 level

*check "lntreatyratifierstodate"
* adjustment variables held at mean
stphplot, by(lntreatyratifierstodate) adjust(repressive islamiclaw commonlaw physint) 
* adjustment variables held at zero
stphplot, by(lntreatyratifierstodate) adjust(repressive islamiclaw commonlaw physint) zero
*looks like lines are parallel

stcox repressive islamiclaw commonlaw lntreatyratifierstodate physint,  efron cluster(id) 





************************************************************************************************************************************************
*************************************MODEL 3Ab: ANALYZE RATIFICATION WITH PROCEDURAL FOR EXECS MORE CONSTRAINED ******************************
************************************************************************************************************************************************
*** Set the data to use in a duration analysis ***
stset duration2, failure(res_3==1) id(id)
kdensity _t, sort title(Density of Ratification)

*Get baseline hazard
sts graph

replace xconst = . if xconst == -88
replace xconst = . if xconst == -77
replace xconst = . if xconst == -66

*more constrained = greater value of xconst from Polity IV data
gen constrainedexec = xconst

stcox constrainedexec islamiclaw commonlaw lntreatyratifierstodate physint,  efron cluster(id) 
estat phtest, detail

*islamiclaw and lntreatyratifierstodate violates at < .03

*** Graphically assess propotional hazards
*** Looking for the lines to be parallel
*check "islamiclaw"
* adjustment variables held at mean
stphplot, by(islamiclaw) adjust(constrainedexec commonlaw lntreatyratifierstodate physint) 
* adjustment variables held at zero
stphplot, by(islamiclaw) adjust(constrainedexec commonlaw lntreatyratifierstodate physint) zero
*looks like lines are not parallel when others at mean --> islamiclaw violates


*check "lntreatyratifierstodate"
* adjustment variables held at mean
stphplot, by(lntreatyratifierstodate) adjust(constrainedexec islamiclaw commonlaw physint) 
* adjustment variables held at zero
stphplot, by(lntreatyratifierstodate) adjust(constrainedexec islamiclaw commonlaw physint) zero
*looks like lines are parallel 

gen ln_t= ln(_t+1)
gen lntxislamiclaw = ln_t*islamiclaw


*FINAL MODEL
stcox constrainedexec islamiclaw commonlaw lntreatyratifierstodate physint lntxislamiclaw,  efron cluster(id) 

drop ln_t
drop lntxislamiclaw




************************************************************************************************************************************************
*************************************MODEL 3Bb: ANALYZE RATIFICATION WITH ARTICLE-QUALIFYING FOR EXECS MORE CONSTRAINED *************************
************************************************************************************************************************************************
*** Set the data to use in a duration analysis ***
stset duration2, failure(res_4==1) id(id)
kdensity _t, sort title(Density of Ratification)

*Get baseline hazard
sts graph

stcox constrainedexec islamiclaw commonlaw lntreatyratifierstodate physint,  efron cluster(id) 
estat phtest, detail

*none violate at < .03

*FINAL MODEL
stcox constrainedexec islamiclaw commonlaw lntreatyratifierstodate physint,  efron cluster(id) 



************************************************************************************************************************************************
*************************************MODEL 4Ab: ANALYZE RATIFICATION WITH PROCEDURAL FOR EXECS FACING MORE POWERFUL LEGISLATURE ****************
************************************************************************************************************************************************
*** Set the data to use in a duration analysis ***
stset duration2, failure(res_3==1) id(id)
kdensity _t, sort title(Density of Ratification)

*Get baseline hazard
sts graph

stcox polconiii islamiclaw commonlaw lntreatyratifierstodate physint,  efron cluster(id) 
estat phtest, detail

*islamiclaw commonlaw and lntreatyratifierstodate violates at < .03

*** Graphically assess propotional hazards
*** Looking for the lines to be parallel
*check "islamiclaw"
* adjustment variables held at mean
stphplot, by(islamiclaw) adjust(polconiii commonlaw lntreatyratifierstodate physint) 
* adjustment variables held at zero
stphplot, by(islamiclaw) adjust(polconiii commonlaw lntreatyratifierstodate physint) zero
*looks like lines are not parallel when others at mean --> islamiclaw violates


*check "commonlaw"
* adjustment variables held at mean
stphplot, by(commonlaw) adjust(polconiii islamiclaw lntreatyratifierstodate physint) 
* adjustment variables held at zero
stphplot, by(commonlaw) adjust(polconiii islamiclaw lntreatyratifierstodate physint) zero
*looks like lines are not parallel when others at mean


*check "lntreatyratifierstodate"
* adjustment variables held at mean
stphplot, by(lntreatyratifierstodate) adjust(polconiii islamiclaw commonlaw physint) 
* adjustment variables held at zero
stphplot, by(lntreatyratifierstodate) adjust(polconiii islamiclaw commonlaw physint) zero
*looks like lines are parallel 


gen ln_t= ln(_t+1)
gen lntxislamiclaw = ln_t*islamiclaw
gen lntxcommonlaw = ln_t*commonlaw


*FINAL MODEL
stcox polconiii islamiclaw commonlaw lntreatyratifierstodate physint lntxislamiclaw lntxcommonlaw,  efron cluster(id) 

drop ln_t
drop lntxislamiclaw
drop lntxcommonlaw


************************************************************************************************************************************************
*************************************MODEL 4Bb: ANALYZE RATIFICATION WITH ARTICLE-QUALIFYING FOR EXECS FACING MORE POWERFUL LEGISLATURE ****************
************************************************************************************************************************************************
*** Set the data to use in a duration analysis ***
stset duration2, failure(res_4==1) id(id)
kdensity _t, sort title(Density of Ratification)

*Get baseline hazard
sts graph

stcox polconiii islamiclaw commonlaw lntreatyratifierstodate physint,  efron cluster(id) 
estat phtest, detail

*none violate at < .03

stcox polconiii islamiclaw commonlaw lntreatyratifierstodate physint,  efron cluster(id) 

************************************************************************************************************************************************
*************************************MODEL 5Ab: ANALYZE RATIFICATION WITH PROCEDURAL FOR EXECS FACING MORE INDEPENDENT JUDICIARY ****************
************************************************************************************************************************************************
*** Set the data to use in a duration analysis ***
stset duration2, failure(res_3==1) id(id)
kdensity _t, sort title(Density of Ratification)

*Get baseline hazard
sts graph

stcox lji islamiclaw commonlaw lntreatyratifierstodate physint,  efron cluster(id) 
estat phtest, detail

*islamiclaw and lntreatyratifers violates at < .03

*** Graphically assess propotional hazards
*** Looking for the lines to be parallel
*check "islamiclaw"
* adjustment variables held at mean
stphplot, by(islamiclaw) adjust(lji commonlaw lntreatyratifierstodate physint) 
* adjustment variables held at zero
stphplot, by(islamiclaw) adjust(lji commonlaw lntreatyratifierstodate physint) zero
*looks like lines are not parallel when others at mean

*check "lntreatyratifierstodate"
* adjustment variables held at mean
stphplot, by(lntreatyratifierstodate) adjust(lji islamiclaw commonlaw physint) 
* adjustment variables held at zero
stphplot, by(lntreatyratifierstodate) adjust(lji islamiclaw commonlaw physint) zero
*looks like lines are parallel 

gen ln_t= ln(_t+1)
gen lntxislamiclaw = ln_t*islamiclaw

**FINAL MODEL
stcox lji islamiclaw commonlaw lntreatyratifierstodate physint lntxislamiclaw,  efron cluster(id) 

drop ln_t
drop lntxislamiclaw


************************************************************************************************************************************************
*************************************MODEL 5Bb: ANALYZE RATIFICATION WITH ARTICLE-QUALIFYING FOR EXECS FACING MORE INDEPENDENT JUDICIARY ****************
************************************************************************************************************************************************
*** Set the data to use in a duration analysis ***
stset duration2, failure(res_4==1) id(id)
kdensity _t, sort title(Density of Ratification)

*Get baseline hazard
sts graph

stcox lji islamiclaw commonlaw lntreatyratifierstodate physint,  efron cluster(id) 
estat phtest, detail

*no variables violate at < .03

**FINAL MODEL
stcox lji islamiclaw commonlaw lntreatyratifierstodate physint,  efron cluster(id) 








************************************************************************************************************************************************
************************************************************************************************************************************************
************************************************ "c" SET OF MODELS: INCLUDE LNTREATYRATIFIERSTODATE AND NEW_EMPINX *****************************
************************************************************************************************************************************************
************************************************************************************************************************************************

use McKibben-Western_Reserved Ratification_data.dta, clear

gen res_12 = 0
replace res_12 = 1 if res_1 == 1
replace res_12 = 1 if res_2 == 1


************************************************************************************************************************************************
*************************************MODEL 1Ac: ANALYZE RATIFICATION OF ANY KIND FOR REGIMES TRANSITIONING FROM MORE REPRESSIVE *****************
************************************************************************************************************************************************
*** Set the data to use in a duration analysis ***
stset duration2, failure(ratindc==1) id(id)
kdensity _t, sort title(Density of Ratification)

*Get baseline hazard
sts graph


*test for proportional hazard assumption
stcox transitional islamiclaw commonlaw lntreatyratifierstodate new_empinx,  efron cluster(id) 
estat phtest, detail
*islamiclaw and commonlaw and lntreatyratifierstodate violate at .03

*check islamiclaw
*check "islamiclaw"
* adjustment variables held at mean
stphplot, by(islamiclaw) adjust(transitional commonlaw lntreatyratifierstodate new_empinx) 
* adjustment variables held at zero
stphplot, by(islamiclaw) adjust(transitional commonlaw lntreatyratifierstodate new_empinx) zero
*looks like lines are not parallel when others are at mean

*check "commonlaw"
* adjustment variables held at mean
stphplot, by(commonlaw) adjust(transitional islamiclaw lntreatyratifierstodate new_empinx) 
* adjustment variables held at zero
stphplot, by(commonlaw) adjust(transitional islamiclaw lntreatyratifierstodate new_empinx) zero
*looks like lines are not parallel


*check "lntreatyratifierstodate"
* adjustment variables held at mean
stphplot, by(lntreatyratifierstodate) adjust(transitional islamiclaw commonlaw new_empinx) 
* adjustment variables held at zero
stphplot, by(lntreatyratifierstodate) adjust(transitional islamiclaw commonlaw new_empinx) zero
*looks like lines are parallel



gen ln_t= ln(_t+1)
gen lntxislamiclaw = ln_t*islamiclaw
gen lntxcommonlaw = ln_t*commonlaw

*Final Model
stcox transitional islamiclaw commonlaw lntreatyratifierstodate new_empinx lntxislamiclaw lntxcommonlaw,  efron cluster(id) 

drop ln_t
drop lntxislamiclaw
drop lntxcommonlaw


************************************************************************************************************************************************
*************************************MODEL 1Bc: ANALYZE RATIFICATION WITHOUT SUBSTANTIVE FOR REGIMES TRANSITIONING FROM MORE REPRESSIVE **********
************************************************************************************************************************************************
*** Set the data to use in a duration analysis ***
stset duration2, failure(res_12==1) id(id)
kdensity _t, sort title(Density of Ratification)

*Get baseline hazard
sts graph


*test for proportional hazard assumption
stcox transitional islamiclaw commonlaw lntreatyratifierstodate new_empinx,  efron cluster(id) 
estat phtest, detail
*lntreatyratifierstodate violate at .03 level

*check "lntreatyratifierstodate"
* adjustment variables held at mean
stphplot, by(lntreatyratifierstodate) adjust(transitional islamiclaw commonlaw new_empinx) 
* adjustment variables held at zero
stphplot, by(lntreatyratifierstodate) adjust(transitional islamiclaw commonlaw new_empinx) zero
*looks like lines are parallel


*Final Model
stcox transitional islamiclaw commonlaw lntreatyratifierstodate new_empinx,  efron cluster(id) 



************************************************************************************************************************************************
*************************************MODEL 2Ac: ANALYZE RATIFICATION (OF ANY KIND) FOR REPRESSIVE REGIMES ****************************************
************************************************************************************************************************************************
*** Set the data to use in a duration analysis ***
stset duration2, failure(ratindc==1) id(id)
kdensity _t, sort title(Density of Ratification)

*Get baseline hazard
sts graph

* Generate repressive variable (= repressive or suppressive parcomp in Polity IV data)
gen repressive = 0
replace repressive = 1 if parcomp == 1
replace repressive = 1 if parcomp == 2




stcox repressive islamiclaw commonlaw lntreatyratifierstodate new_empinx,  efron cluster(id) 

*** Phtest based on residuals 
*** Looking for variables to be above .03 as test is very sensitive
estat phtest, detail
*islamiclaw and commonlaw and lntreatyratifierstodate violate at .03 level



*check "islamiclaw"
* adjustment variables held at mean
stphplot, by(islamiclaw) adjust(repressive commonlaw lntreatyratifierstodate new_empinx) 
* adjustment variables held at zero
stphplot, by(islamiclaw) adjust(repressive commonlaw lntreatyratifierstodate new_empinx) zero
*looks like lines are not parallel when others are held at mean

*check "commonlaw"
* adjustment variables held at mean
stphplot, by(commonlaw) adjust(repressive islamiclaw lntreatyratifierstodate new_empinx) 
* adjustment variables held at zero
stphplot, by(commonlaw) adjust(repressive islamiclaw lntreatyratifierstodate new_empinx) zero
*looks like lines are not parallel

*check "lntreatyratifierstodate"
* adjustment variables held at mean
stphplot, by(lntreatyratifierstodate) adjust(repressive islamiclaw commonlaw new_empinx) 
* adjustment variables held at zero
stphplot, by(lntreatyratifierstodate) adjust(repressive islamiclaw commonlaw new_empinx) zero
*looks like lines are parallel


gen ln_t= ln(_t+1)
gen lntxislamiclaw = ln_t*islamiclaw
gen lntxcommonlaw = ln_t*commonlaw

**FINAL MODEL
stcox repressive islamiclaw commonlaw lntreatyratifierstodate new_empinx lntxislamiclaw lntxcommonlaw,  efron cluster(id) 

drop ln_t
drop lntxislamiclaw
drop lntxcommonlaw



************************************************************************************************************************************************
*************************************MODEL 2Bc: ANALYZE RATIFICATION WITH TREATY-QUALIFYING FOR REPRESSIVE REGIMES ******************************
************************************************************************************************************************************************
*** Set the data to use in a duration analysis ***
stset duration2, failure(res_5==1) id(id)
kdensity _t, sort title(Density of Ratification)

*Get baseline hazard
sts graph

***test for proportional hazards assumption
stcox repressive islamiclaw commonlaw lntreatyratifierstodate new_empinx,  efron cluster(id) 
estat phtest, detail
*none violate at .03 level


stcox repressive islamiclaw commonlaw lntreatyratifierstodate new_empinx,  efron cluster(id) 





************************************************************************************************************************************************
*************************************MODEL 3Ac: ANALYZE RATIFICATION WITH PROCEDURAL FOR EXECS MORE CONSTRAINED ******************************
************************************************************************************************************************************************
*** Set the data to use in a duration analysis ***
stset duration2, failure(res_3==1) id(id)
kdensity _t, sort title(Density of Ratification)

*Get baseline hazard
sts graph

replace xconst = . if xconst == -88
replace xconst = . if xconst == -77
replace xconst = . if xconst == -66

*more constrained = greater value of xconst from Polity IV data
gen constrainedexec = xconst

stcox constrainedexec islamiclaw commonlaw lntreatyratifierstodate new_empinx,  efron cluster(id) 
estat phtest, detail

*constrainedexec islamiclaw and lntreatyratifierstodate and new_empinx violates at < .03

*** Graphically assess proportional hazards
*** Looking for the lines to be parallel


*check "constrainedexec"
* adjustment variables held at mean
stphplot, by(constrainedexec) adjust(islamiclaw commonlaw lntreatyratifierstodate new_empinx) 
* adjustment variables held at zero
stphplot, by(constrainedexec) adjust(islamiclaw commonlaw lntreatyratifierstodate new_empinx) zero
*looks like lines are parallel


*check "islamiclaw"
* adjustment variables held at mean
stphplot, by(islamiclaw) adjust(constrainedexec commonlaw lntreatyratifierstodate new_empinx) 
* adjustment variables held at zero
stphplot, by(islamiclaw) adjust(constrainedexec commonlaw lntreatyratifierstodate new_empinx) zero
*looks like lines are not parallel when others at mean --> islamiclaw violates


*check "lntreatyratifierstodate"
* adjustment variables held at mean
stphplot, by(lntreatyratifierstodate) adjust(constrainedexec islamiclaw commonlaw new_empinx) 
* adjustment variables held at zero
stphplot, by(lntreatyratifierstodate) adjust(constrainedexec islamiclaw commonlaw new_empinx) zero
*looks like lines are parallel 


*check "new_empinx"
* adjustment variables held at mean
stphplot, by(new_empinx) adjust(constrainedexec islamiclaw commonlaw lntreatyratifierstodate) 
* adjustment variables held at zero
stphplot, by(new_empinx) adjust(constrainedexec islamiclaw commonlaw lntreatyratifierstodate) zero
*looks like lines are parallel

gen ln_t= ln(_t+1)
gen lntxislamiclaw = ln_t*islamiclaw


*FINAL MODEL
stcox constrainedexec islamiclaw commonlaw lntreatyratifierstodate new_empinx lntxislamiclaw,  efron cluster(id) 

drop ln_t
drop lntxislamiclaw




************************************************************************************************************************************************
*************************************MODEL 3Bc: ANALYZE RATIFICATION WITH ARTICLE-QUALIFYING FOR EXECS MORE CONSTRAINED *************************
************************************************************************************************************************************************
*** Set the data to use in a duration analysis ***
stset duration2, failure(res_4==1) id(id)
kdensity _t, sort title(Density of Ratification)

*Get baseline hazard
sts graph

stcox constrainedexec islamiclaw commonlaw lntreatyratifierstodate new_empinx,  efron cluster(id) 
estat phtest, detail

*none violate at < .03

*FINAL MODEL
stcox constrainedexec islamiclaw commonlaw lntreatyratifierstodate new_empinx,  efron cluster(id) 



************************************************************************************************************************************************
*************************************MODEL 4Ac: ANALYZE RATIFICATION WITH PROCEDURAL FOR EXECS FACING MORE POWERFUL LEGISLATURE ****************
************************************************************************************************************************************************
*** Set the data to use in a duration analysis ***
stset duration2, failure(res_3==1) id(id)
kdensity _t, sort title(Density of Ratification)

*Get baseline hazard
sts graph

stcox polconiii islamiclaw commonlaw lntreatyratifierstodate new_empinx,  efron cluster(id) 
estat phtest, detail

*polconiii commonlaw lntreatyratifierstodate and new_empinx violates at < .03

*** Graphically assess propotional hazards
*** Looking for the lines to be parallel


*check "polconiii"
* adjustment variables held at mean
stphplot, by(polconiii) adjust(islamiclaw commonlaw lntreatyratifierstodate new_empinx) 
* adjustment variables held at zero
stphplot, by(polconiii) adjust(islamiclaw commonlaw lntreatyratifierstodate new_empinx) zero
*looks like lines are parallel


*check "commonlaw"
* adjustment variables held at mean
stphplot, by(commonlaw) adjust(polconiii islamiclaw lntreatyratifierstodate new_empinx) 
* adjustment variables held at zero
stphplot, by(commonlaw) adjust(polconiii islamiclaw lntreatyratifierstodate new_empinx) zero
*looks like lines are not parallel when others at mean --> commonlaw violates


*check "lntreatyratifierstodate"
* adjustment variables held at mean
stphplot, by(lntreatyratifierstodate) adjust(polconiii islamiclaw commonlaw new_empinx) 
* adjustment variables held at zero
stphplot, by(lntreatyratifierstodate) adjust(polconiii islamiclaw commonlaw new_empinx) zero
*looks like lines are parallel 


*check "new_empinx"
* adjustment variables held at mean
stphplot, by(new_empinx) adjust(polconiii islamiclaw commonlaw lntreatyratifierstodate) 
* adjustment variables held at zero
stphplot, by(new_empinx) adjust(polconiii islamiclaw commonlaw lntreatyratifierstodate) zero
*looks like lines are parallel

gen ln_t= ln(_t+1)
gen lntxcommonlaw = ln_t*commonlaw


*FINAL MODEL
stcox polconiii islamiclaw commonlaw lntreatyratifierstodate new_empinx lntxcommonlaw,  efron cluster(id) 

drop ln_t
drop lntxcommonlaw



************************************************************************************************************************************************
*************************************MODEL 4Bc: ANALYZE RATIFICATION WITH ARTICLE-QUALIFYING FOR EXECS FACING MORE POWERFUL LEGISLATURE ****************
************************************************************************************************************************************************
*** Set the data to use in a duration analysis ***
stset duration2, failure(res_4==1) id(id)
kdensity _t, sort title(Density of Ratification)

*Get baseline hazard
sts graph

stcox polconiii islamiclaw commonlaw lntreatyratifierstodate new_empinx,  efron cluster(id) 
estat phtest, detail

*none violate at < .03

stcox polconiii islamiclaw commonlaw lntreatyratifierstodate new_empinx,  efron cluster(id) 

************************************************************************************************************************************************
*************************************MODEL 5Ac: ANALYZE RATIFICATION WITH PROCEDURAL FOR EXECS FACING MORE INDEPENDENT JUDICIARY ****************
************************************************************************************************************************************************
*** Set the data to use in a duration analysis ***
stset duration2, failure(res_3==1) id(id)
kdensity _t, sort title(Density of Ratification)

*Get baseline hazard
sts graph

stcox lji islamiclaw commonlaw lntreatyratifierstodate new_empinx,  efron cluster(id) 
estat phtest, detail

*lji and lntreatyratifierstodate and new_empinx violates at < .03

*** Graphically assess propotional hazards
*** Looking for the lines to be parallel
*can't check "lji" - not enough variables
*--> put in interaction just in case

*check "new_empinx" 
* adjustment variables held at mean
stphplot, by(new_empinx) adjust(lji islamiclaw commonlaw lntreatyratifierstodate) 
* adjustment variables held at zero
stphplot, by(new_empinx) adjust(lji islamiclaw commonlaw lntreatyratifierstodate) zero
*looks like lines are parallel


*check "lntreatyratifierstodate" 
* adjustment variables held at mean
stphplot, by(lntreatyratifierstodate) adjust(lji islamiclaw commonlaw new_empinx) 
* adjustment variables held at zero
stphplot, by(lntreatyratifierstodate) adjust(lji islamiclaw commonlaw new_empinx) zero
*looks like lines are parallel

gen ln_t= ln(_t+1)
gen lntxlji = ln_t*lji

**FINAL MODEL
stcox lji islamiclaw commonlaw lntreatyratifierstodate new_empinx lntxlji,  efron cluster(id) 
**lji needs interaction graph:


*** Combined Coefficient Analysis for lji variable
mat list e(b)
mat def V = e(V)
mat list V 

*calculate quartiles*
xtile ljirat_quartiles=lji if duration2==1, n(4)

*gen combined coef*
gen combcoef_ljirat = _b[lji] + ln(_t)*_b[lntxlji]

*calculate standard error of combined coef 
*variance of first term+variance of second term+2*covariance)
gen se_combcoef_ljirat = sqrt(V[1,1] + (ln(_t))^2*V[6,6] +2*ln(_t)*V[6,1])

*calculate 95% confidence intervals*
gen combcoef_lo_ljirat = combcoef_ljirat -1.96*se_combcoef_ljirat
gen combcoef_hi_ljirat = combcoef_ljirat+1.96*se_combcoef_ljirat
*chart effect with confidence bounds*
twoway line combcoef_ljirat combcoef_lo_ljirat combcoef_hi_ljirat _t, sort
drop ljirat_quartiles combcoef_ljirat se_combcoef_ljirat combcoef_lo_ljirat combcoef_hi_ljirat

*lji + and significant at .05 for first 40 years, then insignificant after that

drop ln_t
drop lntxlji



************************************************************************************************************************************************
*************************************MODEL 5Bc: ANALYZE RATIFICATION WITH ARTICLE-QUALIFYING FOR EXECS FACING MORE INDEPENDENT JUDICIARY ****************
************************************************************************************************************************************************
*** Set the data to use in a duration analysis ***
stset duration2, failure(res_4==1) id(id)
kdensity _t, sort title(Density of Ratification)

*Get baseline hazard
sts graph

stcox lji islamiclaw commonlaw lntreatyratifierstodate new_empinx,  efron cluster(id) 
estat phtest, detail

*no variables violate at < .03

**FINAL MODEL
stcox lji islamiclaw commonlaw lntreatyratifierstodate new_empinx,  efron cluster(id) 








use McKibben-Western_Reserved Ratification_data.dta, clear

gen res_12 = 0
replace res_12 = 1 if res_1 == 1
replace res_12 = 1 if res_2 == 1


************************************************************************************************************************************************
************************************************************************************************************************************************
**************************************************************** "d" SET OF MODELS: FRAILTY MODELS *********************************************
************************************************************************************************************************************************
************************************************************************************************************************************************



************************************************************************************************************************************************
*************************************MODEL 1Ad: ANALYZE RATIFICATION OF ANY KIND FOR REGIMES TRANSITIONING FROM MORE REPRESSIVE ****************
************************************************************************************************************************************************
*** Set the data to use in a duration analysis ***
stset duration2, failure(ratindc==1) id(id)
kdensity _t, sort title(Density of Ratification)

*Get baseline hazard
sts graph


*test for proportional hazard assumption
stcox transitional islamiclaw commonlaw lntreatyratifierstodate,  efron frailty(gamma) shared(treatynumber) 
estat phtest, detail
*islamiclaw violates at .03

*check islamiclaw
*check "islamiclaw"
* adjustment variables held at mean
stphplot, by(islamiclaw) adjust(transitional commonlaw lntreatyratifierstodate) 
* adjustment variables held at zero
stphplot, by(islamiclaw) adjust(transitional commonlaw lntreatyratifierstodate) zero
*looks like lines are not parallel



gen ln_t= ln(_t+1)
gen lntxislamiclaw = ln_t*islamiclaw

*Final Model
stcox transitional islamiclaw commonlaw lntreatyratifierstodate lntxislamiclaw,  efron frailty(gamma) shared(treatynumber) 


drop ln_t
drop lntxislamiclaw



************************************************************************************************************************************************
*************************************MODEL 1Bd: ANALYZE RATIFICATION WITHOUT SUBSTANTIVE FOR REGIMES TRANSITIONING FROM MORE REPRESSIVE **********
************************************************************************************************************************************************
*** Set the data to use in a duration analysis ***
stset duration2, failure(res_12==1) id(id)
kdensity _t, sort title(Density of Ratification)

*Get baseline hazard
sts graph


*test for proportional hazard assumption
stcox transitional islamiclaw commonlaw lntreatyratifierstodate,  efron frailty(gamma) shared(treatynumber) 
estat phtest, detail
*none violate at .03 level


*Final Model
stcox transitional islamiclaw commonlaw lntreatyratifierstodate,  efron frailty(gamma) shared(treatynumber)  



************************************************************************************************************************************************
*************************************MODEL 2Ad: ANALYZE RATIFICATION (OF ANY KIND) FOR REPRESSIVE REGIMES ****************************************
************************************************************************************************************************************************
*** Set the data to use in a duration analysis ***
stset duration2, failure(ratindc==1) id(id)
kdensity _t, sort title(Density of Ratification)

*Get baseline hazard
sts graph

* Generate repressive variable (= repressive or suppressive parcomp in Polity IV data)
gen repressive = 0
replace repressive = 1 if parcomp == 1
replace repressive = 1 if parcomp == 2




stcox repressive islamiclaw commonlaw lntreatyratifierstodate,  efron frailty(gamma) shared(treatynumber)  

*** Phtest based on residuals 
*** Looking for variables to be above .03 as test is very sensitive
estat phtest, detail
*islamiclaw and commonlaw violate at .03 level



*check "islamiclaw"
* adjustment variables held at mean
stphplot, by(islamiclaw) adjust(repressive commonlaw lntreatyratifierstodate) 
* adjustment variables held at zero
stphplot, by(islamiclaw) adjust(repressive commonlaw lntreatyratifierstodate) zero
*looks like lines are not parallel when others are held at mean

*check "commonlaw"
* adjustment variables held at mean
stphplot, by(commonlaw) adjust(repressive islamiclaw lntreatyratifierstodate) 
* adjustment variables held at zero
stphplot, by(commonlaw) adjust(repressive islamiclaw lntreatyratifierstodate) zero
*looks like lines are not parallel


gen ln_t= ln(_t+1)
gen lntxislamiclaw = ln_t*islamiclaw
gen lntxcommonlaw = ln_t*commonlaw

**FINAL MODEL
stcox repressive islamiclaw commonlaw lntreatyratifierstodate lntxislamiclaw lntxcommonlaw,  efron frailty(gamma) shared(treatynumber) 


drop ln_t
drop lntxislamiclaw
drop lntxcommonlaw



*******************************************************************

************************************************************************************************************************************************
*************************************MODEL 2Bd: ANALYZE RATIFICATION WITH TREATY-QUALIFYING FOR REPRESSIVE REGIMES ******************************
************************************************************************************************************************************************
*** Set the data to use in a duration analysis ***
stset duration2, failure(res_5==1) id(id)
kdensity _t, sort title(Density of Ratification)

*Get baseline hazard
sts graph

***test for proportional hazards assumption
stcox repressive islamiclaw commonlaw lntreatyratifierstodate,  efron frailty(gamma) shared(treatynumber)  
estat phtest, detail
*lntreatyratifierstodate violates at .03


*check "lntreatyratifierstodate" 
* adjustment variables held at mean
stphplot, by(lntreatyratifierstodate) adjust(lji islamiclaw commonlaw new_empinx) 
* adjustment variables held at zero
stphplot, by(lntreatyratifierstodate) adjust(lji islamiclaw commonlaw new_empinx) zero
*looks like lines are parallel


stcox repressive islamiclaw commonlaw lntreatyratifierstodate,  efron frailty(gamma) shared(treatynumber)  





************************************************************************************************************************************************
*************************************MODEL 3Ad: ANALYZE RATIFICATION WITH PROCEDURAL FOR EXECS MORE CONSTRAINED ******************************
************************************************************************************************************************************************
*** Set the data to use in a duration analysis ***
stset duration2, failure(res_3==1) id(id)
kdensity _t, sort title(Density of Ratification)

*Get baseline hazard
sts graph

replace xconst = . if xconst == -88
replace xconst = . if xconst == -77
replace xconst = . if xconst == -66

*more constrained = greater value of xconst from Polity IV data
gen constrainedexec = xconst

stcox constrainedexec islamiclaw commonlaw lntreatyratifierstodate,  efron frailty(gamma) shared(treatynumber) forceshared 
estat phtest, detail

*islamiclaw violates at < .03

*** Graphically assess propotional hazards
*** Looking for the lines to be parallel
*check "islamiclaw"
* adjustment variables held at mean
stphplot, by(islamiclaw) adjust(constrainedexec commonlaw lntreatyratifierstodate) 
* adjustment variables held at zero
stphplot, by(islamiclaw) adjust(constrainedexec commonlaw lntreatyratifierstodate) zero
*looks like lines are not parallel when others at mean --> islamiclaw violates


gen ln_t= ln(_t+1)
gen lntxislamiclaw = ln_t*islamiclaw


*FINAL MODEL
stcox constrainedexec islamiclaw commonlaw lntreatyratifierstodate lntxislamiclaw,  efron frailty(gamma) shared(treatynumber) forceshared

drop ln_t
drop lntxislamiclaw




************************************************************************************************************************************************
*************************************MODEL 3Bd: ANALYZE RATIFICATION WITH ARTICLE-QUALIFYING FOR EXECS MORE CONSTRAINED *************************
************************************************************************************************************************************************
*** Set the data to use in a duration analysis ***
stset duration2, failure(res_4==1) id(id)
kdensity _t, sort title(Density of Ratification)

*Get baseline hazard
sts graph

stcox constrainedexec islamiclaw commonlaw lntreatyratifierstodate,  efron frailty(gamma) shared(treatynumber) forceshared
estat phtest, detail

*none violate at < .03

*FINAL MODEL
stcox constrainedexec islamiclaw commonlaw lntreatyratifierstodate,  efron frailty(gamma) shared(treatynumber) forceshared




************************************************************************************************************************************************
*************************************MODEL 4Ad: ANALYZE RATIFICATION WITH PROCEDURAL FOR EXECS FACING MORE POWERFUL LEGISLATURE ****************
************************************************************************************************************************************************
*** Set the data to use in a duration analysis ***
stset duration2, failure(res_3==1) id(id)
kdensity _t, sort title(Density of Ratification)

*Get baseline hazard
sts graph

stcox polconiii islamiclaw commonlaw lntreatyratifierstodate,  efron frailty(gamma) shared(treatynumber) forceshared
estat phtest, detail

*islamiclaw and commonlaw violates at < .03

*** Graphically assess propotional hazards
*** Looking for the lines to be parallel
*check "islamiclaw"
* adjustment variables held at mean
stphplot, by(islamiclaw) adjust(polconiii commonlaw lntreatyratifierstodate) 
* adjustment variables held at zero
stphplot, by(islamiclaw) adjust(polconiii commonlaw lntreatyratifierstodate) zero
*looks like lines are not parallel when others at mean --> islamiclaw violates


*check "commonlaw"
* adjustment variables held at mean
stphplot, by(commonlaw) adjust(polconiii islamiclaw lntreatyratifierstodate) 
* adjustment variables held at zero
stphplot, by(commonlaw) adjust(polconiii islamiclaw lntreatyratifierstodate) zero
*looks like lines are not parallel



gen ln_t= ln(_t+1)
gen lntxislamiclaw = ln_t*islamiclaw
gen lntxcommonlaw = ln_t*commonlaw

*FINAL MODEL
stcox polconiii islamiclaw commonlaw lntreatyratifierstodate lntxislamiclaw lntxcommonlaw,  efron frailty(gamma) shared(treatynumber) forceshared  

drop ln_t
drop lntxislamiclaw
drop lntxcommonlaw



************************************************************************************************************************************************
*************************************MODEL 4Bd: ANALYZE RATIFICATION WITH ARTICLE-QUALIFYING FOR EXECS FACING MORE POWERFUL LEGISLATURE *********
************************************************************************************************************************************************
*** Set the data to use in a duration analysis ***
stset duration2, failure(res_4==1) id(id)
kdensity _t, sort title(Density of Ratification)

*Get baseline hazard
sts graph

stcox polconiii islamiclaw commonlaw lntreatyratifierstodate, efron frailty(gamma) shared(treatynumber) forceshared 
estat phtest, detail

*none violate at < .03
stcox polconiii islamiclaw commonlaw lntreatyratifierstodate, efron frailty(gamma) shared(treatynumber) forceshared 

************************************************************************************************************************************************
*************************************MODEL 5Ad: ANALYZE RATIFICATION WITH PROCEDURAL FOR EXECS FACING MORE INDEPENDENT JUDICIARY ****************
************************************************************************************************************************************************
*** Set the data to use in a duration analysis ***
stset duration2, failure(res_3==1) id(id)
kdensity _t, sort title(Density of Ratification)

*Get baseline hazard
sts graph

stcox lji islamiclaw commonlaw lntreatyratifierstodate,  efron frailty(gamma) shared(treatynumber) forceshared
estat phtest, detail

*islamiclaw and commonlaw violates at < .03

*** Graphically assess propotional hazards
*** Looking for the lines to be parallel
*check "islamiclaw"
* adjustment variables held at mean
stphplot, by(islamiclaw) adjust(lji commonlaw lntreatyratifierstodate) 
* adjustment variables held at zero
stphplot, by(islamiclaw) adjust(lji commonlaw lntreatyratifierstodate) zero
*looks like lines are not parallel when others at mean

*check "commonlaw"
* adjustment variables held at mean
stphplot, by(commonlaw) adjust(lji islamiclaw lntreatyratifierstodate) 
* adjustment variables held at zero
stphplot, by(commonlaw) adjust(lji islamiclaw lntreatyratifierstodate) zero
*looks like lines are not parallel 


gen ln_t= ln(_t+1)
gen lntxislamiclaw = ln_t*islamiclaw
gen lntxcommonlaw = ln_t*commonlaw

**FINAL MODEL
stcox lji islamiclaw commonlaw lntreatyratifierstodate lntxislamiclaw lntxcommonlaw,  efron frailty(gamma) shared(treatynumber) forceshared

drop ln_t
drop lntxislamiclaw
drop lntxcommonlaw



************************************************************************************************************************************************
*************************************MODEL 5Bd: ANALYZE RATIFICATION WITH ARTICLE-QUALIFYING FOR EXECS FACING MORE INDEPENDENT JUDICIARY ****************
************************************************************************************************************************************************
*** Set the data to use in a duration analysis ***
stset duration2, failure(res_4==1) id(id)
kdensity _t, sort title(Density of Ratification)

*Get baseline hazard
sts graph

stcox lji islamiclaw commonlaw lntreatyratifierstodate,  efron frailty(gamma) shared(treatynumber) forceshared
estat phtest, detail

*no variables violate at < .03

**FINAL MODEL
stcox lji islamiclaw commonlaw lntreatyratifierstodate,  efron frailty(gamma) shared(treatynumber) forceshared







use McKibben-Western_Reserved Ratification_data.dta, clear

gen res_12 = 0
replace res_12 = 1 if res_1 == 1
replace res_12 = 1 if res_2 == 1


******************************************************************************************************************************************************************************************************
*************************************MODEL 1Ae: ANALYZE RATIFICATION OF ANY KIND FOR REGIMES TRANSITIONING FROM MORE REPRESSIVE (controlling for treaty length and negotiation state)*****************
******************************************************************************************************************************************************************************************************
*** Set the data to use in a duration analysis ***
stset duration2, failure(ratindc==1) id(id)
kdensity _t, sort title(Density of Ratification)

*Get baseline hazard
sts graph


*test for proportional hazard assumption
stcox transitional islamiclaw commonlaw lntreatyratifierstodate lntreatylength negstate,  efron cluster(id) 
estat phtest, detail
*islamiclaw, commonlaw, lntreatyratifierstodate, lntreatylength, and negstate violate at .03

*check "islamiclaw"
* adjustment variables held at mean
stphplot, by(islamiclaw) adjust(transitional commonlaw lntreatyratifierstodate lntreatylength negstate) 
* adjustment variables held at zero
stphplot, by(islamiclaw) adjust(transitional commonlaw lntreatyratifierstodate lntreatylength negstate) zero
*looks like lines are not parallel

*check "commonlaw"
* adjustment variables held at mean
stphplot, by(commonlaw) adjust(transitional islamiclaw lntreatyratifierstodate lntreatylength negstate) 
* adjustment variables held at zero
stphplot, by(commonlaw) adjust(transitional islamiclaw lntreatyratifierstodate lntreatylength negstate) zero
*looks like lines are not parallel

*check "lntreatyratifierstodate"
* adjustment variables held at mean
stphplot, by(lntreatyratifierstodate) adjust(transitional islamiclaw commonlaw lntreatylength negstate) 
* adjustment variables held at zero
stphplot, by(lntreatyratifierstodate) adjust(transitional islamiclaw commonlaw lntreatylength negstate) zero
*looks like lines are largely parallel

*check "lntreatylength"
* adjustment variables held at mean
stphplot, by(lntreatylength) adjust(transitional islamiclaw commonlaw lntreatyratifierstodate negstate) 
* adjustment variables held at zero
stphplot, by(lntreatylength) adjust(transitional islamiclaw commonlaw lntreatyratifierstodate negstate) zero
*looks like lines are largely parallel

*check "negstate"
* adjustment variables held at mean
stphplot, by(negstate) adjust(transitional islamiclaw commonlaw lntreatyratifierstodate lntreatylength) 
* adjustment variables held at zero
stphplot, by(negstate) adjust(transitional islamiclaw commonlaw lntreatyratifierstodate lntreatylength) zero
*looks like lines are not parallel


gen ln_t= ln(_t+1)
gen lntxislamiclaw = ln_t*islamiclaw
gen lntxcommonlaw = ln_t*commonlaw
gen lntxnegstate = ln_t*negstate 

*Final Model
stcox transitional islamiclaw commonlaw lntreatyratifierstodate lntreatylength negstate lntxislamiclaw lntxcommonlaw lntxnegstate,  efron cluster(id) 


drop ln_t
drop lntxislamiclaw
drop lntxcommonlaw 
drop lntxnegstate


************************************************************************************************************************************************
*************************************MODEL 1Be: ANALYZE RATIFICATION WITHOUT SUBSTANTIVE FOR REGIMES TRANSITIONING FROM MORE REPRESSIVE **********
************************************************************************************************************************************************
*** Set the data to use in a duration analysis ***
stset duration2, failure(res_12==1) id(id)
kdensity _t, sort title(Density of Ratification)

*Get baseline hazard
sts graph


*test for proportional hazard assumption
stcox transitional islamiclaw commonlaw lntreatyratifierstodate lntreatylength negstate,  efron cluster(id) 
estat phtest, detail
*lntreatyratifierstodate and negstate violates at .03 level


*check "lntreatyratifierstodate"
* adjustment variables held at mean
stphplot, by(lntreatyratifierstodate) adjust(transitional islamiclaw commonlaw lntreatylength negstate) 
* adjustment variables held at zero
stphplot, by(lntreatyratifierstodate) adjust(transitional islamiclaw commonlaw lntreatylength negstate) zero
*looks like lines are largely parallel

*check "negstate"
* adjustment variables held at mean
stphplot, by(negstate) adjust(transitional islamiclaw commonlaw lntreatyratifierstodate lntreatylength) 
* adjustment variables held at zero
stphplot, by(negstate) adjust(transitional islamiclaw commonlaw lntreatyratifierstodate lntreatylength) zero
*lines not parallel


gen ln_t= ln(_t+1)
gen lntxnegstate = ln_t*negstate 


*Final Model
stcox transitional islamiclaw commonlaw lntreatyratifierstodate lntreatylength negstate lntxnegstate,  efron cluster(id) 


drop ln_t
drop lntxnegstate




***********************************************************************************************************************************************************************************************************************************
*************************************MODEL 1C: ANALYZE RATIFICATION WITH ARTICLE-QUALIFYING RESERVATIONS FOR REGIMES TRANSITIONING FROM MORE REPRESSIVE 
***********************************************************************************************************************************************************************************************************************************
*** Set the data to use in a duration analysis ***
stset duration2, failure(res_4==1) id(id)
kdensity _t, sort title(Density of Ratification)

*Get baseline hazard
sts graph


*test for proportional hazard assumption
stcox transitional islamiclaw commonlaw lntreatyratifierstodate,  efron cluster(id) 
estat phtest, detail
*none violate at .03 level

*Final Model
stcox transitional islamiclaw commonlaw lntreatyratifierstodate,  efron cluster(id) 
