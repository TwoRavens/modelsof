
***Table 1***
use "/Users/mhall11/Documents/SLU/Research/TwoCourtsProject/Data/TwoCourts.dta", clear
drop if decisionDirection==3
keep if decisionType==1|decisionType==6|decisionType==7

logit decisionDirection c.zcourt c.zmood##i.lat##i.nyt c.zcong##i.lat##i.nyt i.naturalCourt##i.nyt##i.lat, r

test zmood + 1.lat#c.zmood + c.zmood#1.nyt + 1.lat#c.zmood#1.nyt = 0

test zcong + 1.lat#c.zcong + c.zcong#1.nyt + 1.lat#c.zcong#1.nyt = 0

logit decisionDirection c.zcourt c.zmood##i.lat c.zcong##i.lat i.naturalCourt##i.lat if nyt==1, r

test zmood + 1.lat#c.zmood = 0

test zcong + 1.lat#c.zcong = 0

margins, at(lat==1 zmood=(-2(.2)2)) at(lat==0 zmood=(-2(.2)2)) vsquish level(95) noestimcheck
marginsplot, ylin(0) scheme(s1mono)

margins, at(lat==1 zcong=(-2(.2)2)) at(lat==0 zcong=(-2(.2)2)) vsquish level(95) noestimcheck
marginsplot, ylin(0) scheme(s1mono)

logit decisionDirection c.zcourt c.zmood c.zcong i.naturalCourt if nyt==1 & lat==0, r

logit decisionDirection c.zcourt c.zmood c.zcong i.naturalCourt if nyt==1 & lat==1, r



***Table 2***
use "/Users/mhall11/Documents/SLU/Research/TwoCourtsProject/Data/TwoCourts.dta", clear

logit strike c.JCSPredProb c.FloorMedianOverModel c.constraintp##i.lat c.moodstrike##i.lat if statchal==1 , r

logit strike JCSPredProb FloorMedianOverModel c.constraintp##i.lat c.moodstrike##i.lat ConstraintDist PresCourtDist SJchairDist HJchairDist bills sgsupp amisupp amiopp if statchal==1, r

margins, at(lat==1 moodstrike=(-2(.2)2)) at(lat==0 moodstrike =(-2(.2)2)) vsquish level(95) noestimcheck
marginsplot, ylin(0) scheme(s1mono)

margins, at(lat==1 constraintp=(0(.005).09)) at(lat==0 constraintp =(0(.005).09)) vsquish level(95) noestimcheck
marginsplot, ylin(0) scheme(s1mono)

test moodstrike + 1.lat#c.moodstrike = 0

test constraintp + 1.lat#c.constraintp = 0

logit strike JCSPredProb FloorMedianOverModel c.constraintp c.moodstrike ConstraintDist PresCourtDist SJchairDist HJchairDist bills sgsupp amisupp amiopp if statchal==1 & lat==0, r

logit strike JCSPredProb FloorMedianOverModel c.constraintp c.moodstrike ConstraintDist PresCourtDist SJchairDist HJchairDist bills sgsupp amisupp amiopp if statchal==1 & lat==1, r





***Appendix 1: Robustness Checks***
use "/Users/mhall11/Documents/SLU/Research/TwoCourtsProject/Data/TwoCourts.dta", clear
drop if decisionDirection==3
keep if decisionType==1|decisionType==6|decisionType==7

logit decisionDirection c.zmood##i.lat c.zcong##i.lat i.naturalCourt##i.lat if nyt==1, r
test zmood + 1.lat#c.zmood = 0

logit decisionDirection c.zcourt##i.lat c.zmood##i.lat c.zcong##i.lat i.naturalCourt##i.lat if nyt==1 & issueArea!=1, r
test zmood + 1.lat#c.zmood = 0

logit decisionDirection c.zcourt##i.lat c.zmood##i.lat c.zcong##i.lat i.naturalCourt##i.lat if nyt==1 & issueArea!=2, r
test zmood + 1.lat#c.zmood = 0

logit decisionDirection c.zcourt##i.lat c.zmood##i.lat c.zcong##i.lat i.naturalCourt##i.lat if nyt==1 & issueArea!=1 & issueArea!=2, r
test zmood + 1.lat#c.zmood = 0


use "/Users/mhall11/Documents/SLU/Research/TwoCourtsProject/Data/TwoCourts.dta", clear

logit strike JCSPredProb FloorMedianOverModel c.constraintp##i.lat c.moodstrike##i.lat ConstraintDist PresCourtDist SJchairDist HJchairDist bills sgsupp amisupp amiopp if statchal==1 & issueArea!=1, r

logit strike JCSPredProb FloorMedianOverModel c.constraintp##i.lat c.moodstrike##i.lat ConstraintDist PresCourtDist SJchairDist HJchairDist bills sgsupp amisupp amiopp if statchal==1 & issueArea!=1, r

logit strike JCSPredProb FloorMedianOverModel c.constraintp##i.lat c.moodstrike##i.lat ConstraintDist PresCourtDist SJchairDist HJchairDist bills sgsupp amisupp amiopp if statchal==1 & issueArea!=2, r

logit strike JCSPredProb FloorMedianOverModel c.constraintp##i.lat c.moodstrike##i.lat ConstraintDist PresCourtDist SJchairDist HJchairDist bills sgsupp amisupp amiopp if statchal==1 & issueArea!=1 & issueArea!=2, r


***Appendix 2: Aggregate Decision Making***
use "/Users/mhall11/Documents/SLU/Research/TwoCourtsProject/Data/TwoCourts.dta", clear
drop if decisionDirection==3
keep if decisionType==1|decisionType==6|decisionType==7
collapse (mean) decisionDirection zsc_med zcourt zmood zcong zrelreglib perchcpi unem policylib def_budg homicide inequality if decisionDirection!=3, by (term lat)
xtset lat term
replace decisionDirection=decisionDirection*100

reg d.decisionDirection c.l.decisionDirection##i.lat c.d.zmood##i.lat c.l.zmood##i.lat c.d.zcourt##i.lat c.l.zcourt##i.lat, cluster(term)

use "/Users/mhall11/Documents/SLU/Research/TwoCourtsProject/Data/TwoCourts.dta", clear
drop if decisionDirection==3
keep if decisionType==1|decisionType==6|decisionType==7
collapse (mean) decisionDirection zsc_med zcourt zmood zcong zrelreglib perchcpi unem policylib def_budg homicide inequality if decisionDirection!=3 & nyt!=1, by (term lat)
xtset lat term
replace decisionDirection=decisionDirection*100

reg d.decisionDirection c.l.decisionDirection##i.lat c.d.zmood##i.lat c.l.zmood##i.lat c.d.zcourt##i.lat c.l.zcourt##i.lat, cluster(term)

***VAR Granger Test***
use "/Users/mhall11/Documents/SLU/Research/TwoCourtsProject/Data/TwoCourts.dta", clear
drop if decisionDirection==3
keep if decisionType==1|decisionType==6|decisionType==7
collapse (mean) decisionDirection zsc_med zcourt zmood zrelreglib perchcpi unem policylib def_budg homicide inequality if decisionDirection!=3, by (term lat)
xtset lat term
replace decisionDirection=decisionDirection*100

var decisionDirection zmood zcourt if lat==0,lags(1/4)
vargranger

var decisionDirection zmood zcourt if lat==1,lags(1/4)
vargranger

use "/Users/mhall11/Documents/SLU/Research/TwoCourtsProject/Data/TwoCourts.dta", clear
drop if decisionDirection==3
keep if decisionType==1|decisionType==6|decisionType==7
collapse (mean) decisionDirection zsc_med zcourt zmood zrelreglib perchcpi unem policylib def_budg homicide inequality if decisionDirection!=3 & nyt==1, by (term lat)
xtset lat term
replace decisionDirection=decisionDirection*100

var decisionDirection zmood zcourt if lat==0,lags(1/4)
vargranger

var decisionDirection zmood zcourt if lat==1,lags(1/4)
vargranger

***Appendix 3 Conditional Marginal Effects***
use "/Users/mhall11/Documents/SLU/Research/TwoCourtsProject/Data/TwoCourts.dta", clear
drop if decisionDirection==3
keep if decisionType==1|decisionType==6|decisionType==7

logit decisionDirection c.zcourt c.zmood##i.lat c.zcong##i.lat i.naturalCourt##i.lat if nyt==1, r

margins, at(lat==1 zmood=(-2(.2)2)) at(lat==0 zmood=(-2(.2)2)) vsquish level(95) noestimcheck atmeans
marginsplot, ylin(0) scheme(s1mono)

margins, at(lat==1 zcong=(-2(.2)2)) at(lat==0 zcong=(-2(.2)2)) vsquish level(95) noestimcheck atmeans
marginsplot, ylin(0) scheme(s1mono)


use "/Users/mhall11/Documents/SLU/Research/TwoCourtsProject/Data/TwoCourts.dta", clear

logit strike JCSPredProb FloorMedianOverModel c.constraintp##i.lat c.moodstrike##i.lat ConstraintDist PresCourtDist SJchairDist HJchairDist bills sgsupp amisupp amiopp if statchal==1, r

margins, at(lat==1 moodstrike=(-2(.2)2)) at(lat==0 moodstrike =(-2(.2)2)) vsquish level(95) noestimcheck atmeans
marginsplot, ylin(0) scheme(s1mono)

margins, at(lat==1 constraintp=(0(.005).09)) at(lat==0 constraintp =(0(.005).09)) vsquish level(95) noestimcheck atmeans
marginsplot, ylin(0) scheme(s1mono)

***Appendix 4: Non-Salient Cases***
logit decisionDirection c.zcourt c.zmood##i.lat c.zcong##i.lat i.naturalCourt##i.lat if nyt!=1, r

margins, at(lat==1 zmood=(-2(.2)2)) at(lat==0 zmood=(-2(.2)2)) vsquish level(95) noestimcheck
marginsplot, ylin(0) scheme(s1mono)

margins, at(lat==1 zcong=(-2(.2)2)) at(lat==0 zcong=(-2(.2)2)) vsquish level(95) noestimcheck
marginsplot, ylin(0) scheme(s1mono)


****Appendix 5: Alternative Coding Models****
use "/Users/mhall11/Documents/SLU/Research/TwoCourtsProject/Data/TwoCourts.dta", clear
drop if decisionDirection==3
keep if decisionType==1|decisionType==6|decisionType==7

logit decisionDirection c.zcourt c.zmood##i.lat c.zcong##i.lat i.naturalCourt##i.lat if nyt==1, r

test zmood + 1.lat#c.zmood = 0
test zcong + 1.lat#c.zcong = 0

use "/Users/mhall11/Documents/SLU/Research/TwoCourtsProject/Data/TwoCourts.dta", clear

logit strike JCSPredProb FloorMedianOverModel c.constraintp##i.lat c.moodstrike##i.lat ConstraintDist PresCourtDist SJchairDist HJchairDist bills sgsupp amisupp amiopp if statchal==1, r

test moodstrike + 1.lat#c.moodstrike = 0
test constraintp + 1.lat#c.constraintp = 0

***Unions***
replace lat=1 if issueArea==7
replace lat=1 if usCite=="467 U.S. 883"
replace lat=1 if usCite=="424 U.S. 351"
replace lat=1 if usCite=="465 U.S. 271"
replace lat=1 if usCite=="441 U.S. 463"
replace lat=1 if usCite=="425 U.S. 238"
replace lat=1 if usCite=="389 U.S. 217"
replace lat=1 if usCite=="377 U.S. 1"
replace lat=1 if usCite=="424 U.S. 507"
replace lat=1 if usCite=="339 U.S. 382"
replace lat=1 if usCite=="339 U.S. 846"
replace lat=1 if usCite=="395 U.S. 210"
replace lat=1 if usCite=="376 U.S. 775"
replace lat=1 if usCite=="361 U.S. 363"
replace lat=1 if usCite=="397 U.S. 655"
replace lat=1 if usCite=="374 U.S. 74"
replace lat=1 if usCite=="344 U.S. 375"

***Economic Regulation***
replace lat=0 if issue>80215 & issue<80345

***Taxes***
replace lat=1 if issue==80100|issue==100060|issue==100110|issue==120010|issue==120020|issue==120030|issue==120040
replace lat=1 if usCite=="416 U.S. 351"
replace lat=1 if usCite=="460 U.S. 575"
replace lat=1 if usCite=="544 U.S. 550"
replace lat=1 if usCite=="533 U.S. 405"
replace lat=1 if usCite=="493 U.S. 378"
replace lat=1 if usCite=="455 U.S. 252"
replace lat=1 if usCite=="489 U.S. 1"
replace lat=1 if usCite=="397 U.S. 664"
replace lat=1 if usCite=="506 U.S. 9"
replace lat=1 if usCite=="404 U.S. 412"
replace lat=1 if usCite=="387 U.S. 456"
replace lat=1 if usCite=="501 U.S. 868"
replace lat=1 if usCite=="489 U.S. 353"

***Title VII, EEOC cases***
replace lat=1 if issue==20060
replace lat=1 if issue==20070
replace lat=1 if issue==20140
replace lat=1 if usCite=="414 U.S. 86"
replace lat=1 if usCite=="493 U.S. 182"


