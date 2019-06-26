**** Variables Constuction
gen lpeacekpr=log(peacekeepers+1)
gen lgdppc=log(gdppop) 
gen lpop=log(pop)
gen lopen=log(open)
gen lmpersl=log(militarypersonl)
gen shmissn= shareofmissions

xi i.did
tsset did period

****  GMM
ivreg2 lpeacekpr (wlpeacekprs = wlgdppop wlpop wlopen wlmilpersnl wpko wshmissn) ///
    lgdppc lpop lopen lmpersl pko shmissn _Idid*, small gmm2s bw(3) kernel(bartlett) robust  
est store fe1

****  LSDV
xtreg lpeacekpr lgdppc lpop lopen lmpersl pko shmissn i.period, fe cluster(did) 
est store fe2

esttab fe*, b(3) t(3) stats(N) star(* 0.10 ** 0.05 *** 0.01) keep(wlpeacekprs lgdppc lpop lopen lmpersl pko shmissn)


