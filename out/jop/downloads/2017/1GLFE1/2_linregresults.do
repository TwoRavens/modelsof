use  1_gallupdataout.dta, clear

gen election = 0
replace election = 1 if date>=yq(1952,4)
replace election = 2 if date>=yq(1956,4)
replace election = 3 if date>=yq(1960,4)
replace election = 4 if date>=yq(1964,4)
replace election = 5 if date>=yq(1968,4)
replace election = 6 if date>=yq(1972,4)
replace election = 7 if date>=yq(1976,4)
replace election = 8 if date>=yq(1980,4)
replace election = 9 if date>=yq(1984,4)
replace election = 10 if date>=yq(1988,4)
replace election = 11 if date>=yq(1992,4)
replace election = 12 if date>=yq(1996,4)
replace election = 13 if date>=yq(2000,4)
replace election = 14 if date>=yq(2004,4)
replace election = 15 if date>=yq(2008,4)
replace election = 16 if date>=yq(2012,4)

sort election date
by election: gen counter = _n

gen electiondum = 0
replace electiondum=1 if counter==1
replace electiondum=1 if counter==2
sort date
replace electiondum=1 if f.counter==1

xtset, clear
tsset date
sort date
gen partyics =  latentics*party
replace latentapprove = latentapprove*100
gen partyapprove = latentapprove*party
gen ics = latentics
gen approve = latentapprove
gen lagmacro = l.adjusted_gallup
gen lagparty = l.party
gen lagpartyics = l.partyics
gen lagpartyapprove = l.partyapprove


*** Add party change measures from step 1
sort year
merge m:1 year using "1_elitepartychange.dta", keepusing(fpartyideochange fpartyagendachange)
drop if _merge==2
drop _merge

** to put on % scale instead of proportion 
gen mac100 = adjusted_gallup*100
gen lagmac100 = lagmacro*100


****************************
** Partial adjustment model, first column of Table 1
*****************************

** Define ML Regression estimator
** ML regression estimate has same coefficients as OLS, but allows me to draw from  normal distribution to simulate confidence intervals (a.k.a. Clarify)

program define hetreg
	args lnf theta1 theta2
	quietly replace `lnf' =-.5*ln(2*_pi)-.5*`theta2'-.5*(($ML_y1-`theta1')^2)/exp(`theta2')
      /* remember $ML_y1 = first dependent variable */

end

ml model lf hetreg (mac100 = lagmac100 party partyics partyapprove) (var: ) if year>1952
ml search
ml max 
est store mle
** Get standard error of square root of variance
nlcom sqrt(exp(_b[var:_cons]))


** R-squared
predict test
sum mac100 if e(sample)
gen sqdev = (mac100 - r(mean))^2 if e(sample)
gen pasqdev = (mac100 - test)^2 if e(sample)
sum sqdev
di r(N)*r(mean)
sum pasqdev
di 1-r(N)*r(mean)/4804.8635
drop test


******************
** ADL, second column of Table C.3
******************

ml model lf hetreg (mac100 = lagmac100 party partyics partyapprove lagparty lagpartyics lagpartyapprove) (var: ) if year>1952
ml search
ml max
est store adl
nlcom sqrt(exp(_b[var:_cons]))

** R-squared
predict test
sum mac100 if e(sample)
gen adlsqdev = (mac100 - test)^2 if e(sample)
sum sqdev
di r(N)*r(mean)
sum adlsqdev
di 1-r(N)*r(mean)/4804.8635
drop test 

*******
** Constituent Term ADL specification, first column in Table C.3
*******
gen lagapprove = abs(lagpartyapprove)
gen lagics = abs(lagpartyics)

ml model lf hetreg (mac100 = lagmac100 party ics approve partyics partyapprove lagapprove lagics lagparty lagpartyics lagpartyapprove ) (var: ) if year>1952
ml search
ml max
test ics approve lagapprove lagics
nlcom sqrt(exp(_b[var:_cons]))

** R-squared
predict test
sum mac100 if e(sample)
gen fulladlsqdev = (mac100 - test)^2 if e(sample)
sum sqdev
di r(N)*r(mean)
sum fulladlsqdev
di 1-r(N)*r(mean)/4804.8635
drop test 


*************************************
** Fractional Integration Estimates, first column in Table C.1
*************************************

arfima mac100 party partyics partyapprove if year>1952, ar(1) 
est store arfima
matrix fibeta = e(b)
nlcom sqrt(_b[sigma2:_cons])
nlcom _b[_cons]*(1-_b[ARFIMA:L.ar])

** R-squared
predict test
sum mac100 if e(sample)
gen fisqdev = (mac100 - test)^2 if e(sample)
sum sqdev
di r(N)*r(mean)
sum fisqdev
di 1-r(N)*r(mean)/4804.8635
drop test


*********************************************
*** Prepare data for MSAR estimation in JAGS
*********************************************
sort date
reg adjusted_gallup lagmacro party partyics partyapprove lagparty lagpartyics lagpartyapprove
gen keep = 1 if e(sample)
drop if keep!=1

keep date election adjusted_gallup lagmacro party partyics partyapprove macrovar lagparty lagpartyics lagpartyapprove
**use instead of above if replicating state-space model in supplemental appendix, need to run code replicating table 2 first
**keep date election adjusted_gallup lagmacro party partyics partyapprove macrovar lagparty lagpartyics lagpartyapprove fpartyideochange fpartyagendachange
*saveold "statespacedata.dta"

saveold "2_forjags.dta", replace 
clear

****************************************
** Simulate Responsiveness Estimates in Figure 4
****************************************

est restore mle


matrix beta = e(b)
matrix vcov = e(V)
set seed 101
drawnorm b1-b6, means(beta) cov(vcov) n(1000)

gen test = (b5 + b2*1 + b3*87 + b4*50)/(1-b1)
gen t1 = b5 + b2*1 + b3*87 + b4*50 + b1*test
gen t2 = b5 + b2*1 + b3*87 + b4*55 + b1*t1 
gen t3 = b5 + b2*1 + b3*87 + b4*55 + b1*t2
gen t4 = b5 + b2*1 + b3*87 + b4*55 + b1*t3
gen t5 = b5 + b2*1 + b3*87 + b4*55 + b1*t4
gen t6 = b5 + b2*1 + b3*87 + b4*55 + b1*t5
gen t7 = b5 + b2*1 + b3*87 + b4*55 + b1*t6
gen t8 = b5 + b2*1 + b3*87 + b4*55 + b1*t7
gen t9 = b5 + b2*1 + b3*87 + b4*55 + b1*t8
gen t10 = b5 + b2*1 + b3*87 + b4*50 + b1*t9
gen t11 = b5 + b2*1 + b3*87 + b4*50 + b1*t10
gen t12 = b5 + b2*1 + b3*87 + b4*50 + b1*t11
gen t13 = b5 + b2*1 + b3*87 + b4*50 + b1*t12

sum t* if test>0 & test<100

gen diff2 = t2-t1
gen diff3 = t3-t1
gen diff4 = t4-t1
gen diff5 = t5-t1
gen diff6 = t6-t1
gen diff7 = t7-t1
gen diff8 = t8-t1
gen diff9 = t9-t1
gen diff10 = t10-t1
gen diff11 = t11-t1
gen diff12 = t12-t1
gen diff13 = t13-t1

sum diff*

centile diff*, centile(2.5 97.5)
saveold "paapprovalsim.dta", replace

clear

****************************************
** Simulate Responsiveness Estimates in Figure C.2
****************************************


est restore adl


matrix beta = e(b)
matrix vcov = e(V)
set seed 101
drawnorm b1-b9, means(beta) cov(vcov) n(1000)

gen test = (b8 + b2*1 + b3*87 + b4*50 + b5*1 + b6*87 + b7*50)/(1-b1)
gen t1 = b8 + b2*1 + b3*87 + b4*50 + b5*1 + b6*87 + b7*50 + b1*test
gen t2 = b8 + b2*1 + b3*87 + b4*55 + b5*1 + b6*87 + b7*50 + b1*t1 
gen t3 = b8 + b2*1 + b3*87 + b4*55 + b5*1 + b6*87 + b7*55 + b1*t2
gen t4 = b8 + b2*1 + b3*87 + b4*55 + b5*1 + b6*87 + b7*55 + b1*t3
gen t5 = b8 + b2*1 + b3*87 + b4*55 + b5*1 + b6*87 + b7*55 + b1*t4
gen t6 = b8 + b2*1 + b3*87 + b4*55 + b5*1 + b6*87 + b7*55 + b1*t5
gen t7 = b8 + b2*1 + b3*87 + b4*55 + b5*1 + b6*87 + b7*55 + b1*t6
gen t8 = b8 + b2*1 + b3*87 + b4*55 + b5*1 + b6*87 + b7*55 + b1*t7
gen t9 = b8 + b2*1 + b3*87 + b4*55 + b5*1 + b6*87 + b7*55 + b1*t8
gen t10 = b8 + b2*1 + b3*87 + b4*50 + b5*1 + b6*87 + b7*55 + b1*t9
gen t11 = b8 + b2*1 + b3*87 + b4*50 + b5*1 + b6*87 + b7*50 + b1*t10
gen t12 = b8 + b2*1 + b3*87 + b4*50 + b5*1 + b6*87 + b7*50 + b1*t11
gen t13 = b8 + b2*1 + b3*87 + b4*50 + b5*1 + b6*87 + b7*50 + b1*t12

sum t* if test>0 & test<100

gen diff2 = t2-t1
gen diff3 = t3-t1
gen diff4 = t4-t1
gen diff5 = t5-t1
gen diff6 = t6-t1
gen diff7 = t7-t1
gen diff8 = t8-t1
gen diff9 = t9-t1
gen diff10 = t10-t1
gen diff11 = t11-t1
gen diff12 = t12-t1
gen diff13 = t13-t1

sum diff*

centile diff*, centile(2.5 97.5)
saveold "adlapprovalsim.dta", replace
