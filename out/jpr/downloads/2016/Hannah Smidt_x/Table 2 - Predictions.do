
**********************************************************
**** Table II Predictions of counts of violent events ****
set more off
clear
version 13.0


use "AnalysisData_JPR.dta", clear


**** Predicting government sponsored violence
set seed 1234
#delimit ;
estsimp nbreg RepressionPost largemonitored  
fraud largemonitored_fraud 
OppViolPostD OppViolPre RepressionPre 
polity2lag polity2lag2 NELDA24
netoda_ln ln_gdpcaplag ln_pop media_bias,  cluster(ccode);

#delimit cr


* Observers*fraud
#delimit ;
setx largemonitored 0 OppViolPostD mean
fraud 0 largemonitored_fraud 0 OppViolPre mean RepressionPre mean
polity2lag mean polity2lag2 mean NELDA24 mean
netoda_ln mean ln_gdpcaplag mean ln_pop mean media_bias mean ;
#delimit cr
simqi, ev genev(ev_00) //no monitors, no fraud

setx largemonitored 1*1
simqi, ev genev(ev_10) // monitors, no fraud


setx largemonitored 0*0 fraud 1*1
simqi, ev genev(ev_01) //no monitors, fraud


setx largemonitored 1*1 largemonitored_fraud 1*1
simqi, ev genev(ev_11) //no monitors, no fraud

gen fd0=ev_10-ev_00
gen fd1=ev_11-ev_01
sum fd0, d
sum fd1, d


* post-electoral opposition violence
capture drop fd* ev*
#delimit ;
setx largemonitored 0 OppViolPostD 0
fraud 0 largemonitored_fraud 0 OppViolPre mean RepressionPre mean
polity2lag mean polity2lag2 mean NELDA24 mean
netoda_ln mean ln_gdpcaplag mean ln_pop mean media_bias mean ;
#delimit cr
simqi, ev genev(ev0)

setx OppViolPostD 1*1
simqi, ev genev(ev1)

gen fd=ev1-ev0
sum fd, d


* pre-electoral opposition violence
capture drop fd* ev*
#delimit ;
setx largemonitored 0 OppViolPostD mean
fraud 0 largemonitored_fraud 0 OppViolPre mean RepressionPre mean
polity2lag mean polity2lag2 mean NELDA24 mean
netoda_ln mean ln_gdpcaplag mean ln_pop mean media_bias mean ;
#delimit cr
simqi, ev genev(ev0)

sum OppViolPre
local SD = r(mean) + r(sd)
setx OppViolPre `SD'*`SD'
simqi, ev genev(ev1)

gen fd=ev1-ev0
sum fd, d


* pre-electoral repression
capture drop fd* ev*
#delimit ;
setx largemonitored 0 OppViolPostD mean
fraud 0 largemonitored_fraud 0 OppViolPre mean RepressionPre mean
polity2lag mean polity2lag2 mean NELDA24 mean
netoda_ln mean ln_gdpcaplag mean ln_pop mean media_bias mean ;
#delimit cr
simqi, ev genev(ev0)

sum RepressionPre
local SD = r(mean) + r(sd)
setx RepressionPre `SD'*`SD'
simqi, ev genev(ev1)

gen fd=ev1-ev0
sum fd, d




* Polity IV Score
capture drop fd* ev*
#delimit ;
setx largemonitored 0 OppViolPostD mean
fraud 0 largemonitored_fraud 0 OppViolPre mean RepressionPre mean
polity2lag mean polity2lag2 mean NELDA24 0 
netoda_ln mean ln_gdpcaplag mean ln_pop mean media_bias mean ;
#delimit cr
simqi, ev genev(ev0)

sum polity2lag
local SD = r(mean) + r(sd)
setx polity2lag `SD'*`SD'
sum polity2lag2
local SD = r(mean) + r(sd)
setx polity2lag2 `SD'*`SD'
simqi, ev genev(ev1)


gen fd=ev1-ev0
sum fd, d

* ODA logged
capture drop fd* ev*
#delimit ;
setx largemonitored 0 OppViolPostD mean
fraud 0 largemonitored_fraud 0 OppViolPre mean RepressionPre mean
polity2lag mean polity2lag2 mean NELDA24 mean
netoda_ln mean ln_gdpcaplag mean ln_pop mean media_bias mean ;
#delimit cr
simqi, ev genev(ev0)

sum netoda_ln
local SD = r(mean) + r(sd)
setx netoda_ln `SD'*`SD'
simqi, ev genev(ev1)

gen fd=ev1-ev0
sum fd, d


* GDP, logged, lag 1 yr  (from mean to +1 SD)
capture drop fd* ev*
#delimit ;
setx largemonitored 0 OppViolPostD mean
fraud 0 largemonitored_fraud 0 OppViolPre mean RepressionPre mean
polity2lag mean polity2lag2 mean NELDA24 mean
netoda_ln mean ln_gdpcaplag mean ln_pop mean media_bias mean ;
#delimit cr
simqi, ev genev(ev0)

sum ln_gdpcaplag 
local SD = r(mean) + r(sd)
setx ln_gdpcaplag `SD'*`SD'
simqi, ev genev(ev1)

gen fd=ev1-ev0
sum fd, d


* Population size, logged (from mean to +1 SD)
capture drop fd* ev*
#delimit ;
setx largemonitored 0 OppViolPostD mean
fraud 0 largemonitored_fraud 0 OppViolPre mean RepressionPre mean
polity2lag mean polity2lag2 mean NELDA24 mean
netoda_ln mean ln_gdpcaplag mean ln_pop mean media_bias mean ;
#delimit cr
simqi, ev genev(ev0)

sum ln_pop
local SD = r(mean) + r(sd)
setx ln_pop `SD'*`SD'
simqi, ev genev(ev1)

gen fd=ev1-ev0
sum fd, d


* Media reports (from mean to +1 SD)
capture drop fd* 
capture drop ev*
#delimit ;
setx largemonitored 0 OppViolPostD mean
fraud 0 largemonitored_fraud 0 OppViolPre mean RepressionPre mean
polity2lag mean polity2lag2 mean NELDA24 0 
netoda_ln mean ln_gdpcaplag mean ln_pop mean media_bias mean ;
#delimit cr
simqi, ev genev(ev0)

sum media_bias
local SD = r(mean) + r(sd)
setx media_bias `SD'*`SD'
simqi, ev genev(ev1)

gen fd=ev1-ev0
sum fd, d




** Predicting opposition-sposored violence
capture drop b*
set seed 1234
#delimit ;
estsimp nbreg OppViolPost largemonitored 
fraud largemonitored_fraud RepressionPostD 
OppViolPre RepressionPre 
polity2lag polity2lag2 NELDA24
netoda_ln ln_gdpcaplag ln_pop media_bias,  cluster(ccode) ;
#delimit cr



* Observers*fraud
capture drop ev_* 
capture drop fd0 fd1
#delimit ;
setx largemonitored 0 RepressionPostD mean
fraud 0 largemonitored_fraud 0 OppViolPre mean RepressionPre mean
polity2lag mean polity2lag2 mean NELDA24 mean
netoda_ln mean ln_gdpcaplag mean ln_pop mean media_bias mean ;
#delimit cr
simqi, ev genev(ev_00) //no monitors, no fraud

setx largemonitored 1*1
simqi, ev genev(ev_10) // monitors, no fraud


setx largemonitored 0*0 fraud 1*1
simqi, ev genev(ev_01) //no monitors, fraud


setx largemonitored 1*1 fraud 1*1 largemonitored_fraud 1*1
simqi, ev genev(ev_11) //monitors, fraud

gen fd0=ev_10-ev_00
gen fd1=ev_11-ev_01
sum fd0, d
sum fd1, d


* Post-electoral repression
capture drop ev_* 
capture drop fd0 fd1
capture drop fd
#delimit ;
setx largemonitored 0 RepressionPostD 0
fraud 0 largemonitored_fraud 0 OppViolPre mean RepressionPre mean
polity2lag mean polity2lag2 mean NELDA24 mean
netoda_ln mean ln_gdpcaplag mean ln_pop mean media_bias mean ;
#delimit cr
simqi, ev genev(ev_0) 

setx RepressionPostD 1*1
simqi, ev genev(ev_1) 

gen fd=ev1-ev0
sum fd, d


* Pre-electoral repression
capture drop ev_1 ev_0
capture drop fd0 fd1
capture drop fd
#delimit ;
setx largemonitored 0 RepressionPostD mean
fraud 0 largemonitored_fraud 0 OppViolPre mean RepressionPre 0
polity2lag mean polity2lag2 mean NELDA24 mean
netoda_ln mean ln_gdpcaplag mean ln_pop mean media_bias mean ;
#delimit cr
simqi, ev genev(ev_0) 

setx RepressionPre 1*1
simqi, ev genev(ev_1) 

gen fd=ev1-ev0
sum fd, d


* Polity IV Score
capture drop ev1 ev0
capture drop fd
#delimit ;
setx largemonitored 0 RepressionPostD mean
fraud 0 largemonitored_fraud 0 OppViolPre mean RepressionPre mean
polity2lag mean polity2lag2 mean NELDA24 mean
netoda_ln mean ln_gdpcaplag mean ln_pop mean media_bias mean ;
#delimit cr
simqi, ev genev(ev0)

sum polity2lag
local SD = r(mean) + r(sd)
setx polity2lag `SD'*`SD'
simqi, ev genev(ev1)


gen fd=ev1-ev0
sum fd, d
