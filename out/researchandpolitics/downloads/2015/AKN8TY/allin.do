*Replication code for "Going All-In," Michael G. Miller, 2015 Research and Politics Article
*State Names are Converted to Numbers to Obscur Identifying Information
*Logit Models of No Work
logit nowork i.female state1-state18, vce(robust)
est store logit1
logit nowork i.female i.canord democrat openseat black hispanic canpartyperc06  logdp percurban loghhi state1-state18, vce(robust)
est store logit2
logit nowork i.female i.canord i.female##i.canord democrat openseat black hispanic canpartyperc06  logdp percurban loghhi state1-state18, vce(robust)
est store logit3
*Logit Models of Less Than Full Time
logit nopt i.female state1-state18, vce(robust)
est store logit4
logit nopt i.female i.canord democrat openseat black hispanic canpartyperc06  logdp percurban loghhi state1-state18, vce(robust)
est store logit5
logit nopt i.female i.canord i.female##i.canord democrat openseat black hispanic canpartyperc06  logdp percurban loghhi state1-state18, vce(robust)
est store logit6
outreg2 [logit1 logit2 logit3 logit4 logit5 logit6] using work.xls, replace alpha(.05) e(all) symbol(*) dec(3)
*Models of Total Time & Predicted Probabilities
nbreg timeround female if exp==0 & incumbent==0, vce(robust)
est store t1
nbreg timeround i.female democrat openseat mmd parttime fulltime canpartyperc06 logdp state1-state18 if exp==0 & incumbent==0, dispersion(mean) vce(robust)
est store t2
margins, atmeans over(female)
nbreg timeround female if exp==1 & incumbent==0, vce(robust)
est store t3
nbreg timeround i.female democrat openseat mmd parttime fulltime canpartyperc06 logdp state1-state18 if exp==1 & incumbent==0, dispersion(mean) vce(robust)
est store t4
margins, atmeans over(female)
nbreg timeround female if incumbent==1, vce(robust)
est store t5
nbreg timeround i.female democrat openseat mmd parttime fulltime canpartyperc06 logdp state1-state18 if incumbent==1, dispersion(mean) vce(robust)
est store t6
margins, atmeans over(female)
nbreg timeround female, vce(robust)
est store t7
nbreg timeround i.female democrat openseat mmd parttime fulltime canpartyperc06 logdp incumbent exp state1-state18, dispersion(mean) vce(robust)
est store t8
margins, atmeans over(female)
outreg2 [t7 t8 t1 t2 t3 t4 t5 t6] using totaltime.xls, replace alpha(.05) e(all) symbol(*) dec(3)
