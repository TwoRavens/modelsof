

* Replication of original model and tests of proportional hazards


*replicate core Cox Model from Beardsley (2011, chapter 5)
eststo, title(original Cox): stcox med2 med2_t prevcris2 viol2 crisdur2 jointdem victory2 contig2 /*
*/ prevcris2_t viol2_t crisdur2_t jointdem_t victory2_t contig2_t if _t<3650, /*
*/ strata(order5) cluster(dyadno) efron nohr

*->works perfectly, but model does not satisfy proportional hazards assumption
estat phtest, detail

/*
moreover, the time interaction seem incorrect and not always necessary, based on  
a reestimation using Stata's build in tvc() option for time-varying covariates
*/
stcox med2 prevcris2 viol2 crisdur2 jointdem victory2 contig2 /*
*/  if _t<3650, tvc(med2 prevcris2 viol2 crisdur2 jointdem victory2 contig2) /*
*/ strata(order5) cluster(dyadno) efron nohr

*unfortunately, we cannot test the proportional hazards assumption after tvc()
capture noisily estat phtest, detail

*so I use the manual work around
stsplit, at(failures)

*recalculate the interaction with time
foreach var in med2 prevcris2 viol2 crisdur2 jointdem victory2 contig2 {
replace `var'_t= `var'*_t
}

*estimat the model with only mediation as time-varying covariates
eststo, title(restricted Cox): stcox med2 med2_t prevcris2 viol2 crisdur2 jointdem victory2 contig2 /*
*/     if _t<3650, /*
*/ strata(order5) cluster(dyadno) efron nohr

*estimated this way, the model satisfies the proportional hazard assumption
estat phtest, detail

/*
since the test based on Schoenfeld residuals may be sensitive in the case of 
stratification, I test again for each stratum
*/

*order5=1
quietly stcox med2 med2_t prevcris2 viol2 crisdur2 jointdem victory2 contig2 /*
*/ if _t<3650 & order5==1, cluster(dyadno) efron nohr
estat phtest, detail

*order5=2
quietly stcox med2 med2_t prevcris2 viol2 crisdur2 jointdem victory2 contig2 /*
*/ if _t<3650 & order5==2, cluster(dyadno) efron nohr
estat phtest, detail

*order5=3
quietly stcox med2 med2_t prevcris2 viol2 crisdur2 jointdem victory2 contig2 /*
*/ if _t<3650 & order5==3, cluster(dyadno) efron nohr
estat phtest, detail

*order5=4
quietly stcox med2 med2_t prevcris2 viol2 crisdur2 jointdem victory2 contig2 /*
*/ if _t<3650 & order5==4, cluster(dyadno) efron nohr
estat phtest, detail

*order5=5
quietly stcox med2 med2_t prevcris2 viol2 crisdur2 jointdem victory2 contig2 /*
*/ if _t<3650 & order5==5, cluster(dyadno) efron nohr
estat phtest, detail

*->proportional hazard assumption seems ok in all strata
