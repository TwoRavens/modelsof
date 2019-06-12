*Table 2
*pooled*
stset t2, failure(intervention)
streg  alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmtpsuccess prevcmtpnosuccess prevcmsuccess prevcmnosuccess prevmid dcontig dpolity cinc , nohr strata(eventtype) cluster(id) distribution(weibull)

*Figure 1
sts graph, hazard by(eventtype) tmax(8000) legend(label(1 "Verbal") label(2 "Diplomatic") label(3 "Economic")) scheme(s2mono)

*Table 2
*economic*
stset t2, failure(economic)
streg  alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmtpsuccess prevcmtpnosuccess prevcmsuccess prevcmnosuccess prevmid dcontig dpolity cinc , nohr strata(eventtype) cluster(id) distribution(weibull)

*Table 2
*diplomatic*
stset t2, failure(diplomatic)
streg  alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmtpsuccess prevcmtpnosuccess prevcmsuccess prevcmnosuccess prevmid dcontig dpolity cinc, nohr strata(eventtype) cluster(id) distribution(weibull)

*Table 2
*verbal*
stset t2, failure(verbal)
streg  alliance1 alliance2 trade1_ds trade2_ds jointdem1 jointdem2 border1 border2 colony prevmidtp nmgmt_lag prevcm prevcmtpsuccess prevcmtpnosuccess prevcmsuccess prevcmnosuccess prevmid dcontig dpolity cinc, nohr strata(eventtype) cluster(id) distribution(weibull)
