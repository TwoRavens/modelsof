***Bargaining, Bias and Peace Brokers: The Do-File

*generate cubic splines
btscs paterm1 year dyadid, gen(nopayrs) nspline(3) f

*generate logged GDP
gen loggdp=ln(rgdp96pc)

*generate duration (DYAD) square
gen dyaddursq=dyaddur*dyaddur

*generate duration (CONFLICT) square
gen confldursq=confldur*confldur

*Model 1: Effect of Types of Mediators
probit paterm1 biasgov biasreb biasnon, cl(dyadid) nolog
**outreg using XXX, coefastr se 

*Robustness check on Model 1: clustering on country, not dyad.
probit paterm1 biasgov biasreb biasnon, cl(statenum) nolog

*MODEL 2: Effect of Types of Mediators, with inclusion of control-variables 
probit paterm1 biasgov biasreb biasnon medp5 war govtarmy dyaddur dyadnr1 loggdp terr polity2 nopayrs _spline1 _spline2 _spline3, cl(dyadid) nolog
**outreg using XXX, coefastr se append
test _spline1 _spline2 _spline3

*Robustness check on Model 2: clustering on country, not dyad.
probit paterm1 biasgov biasreb biasnon medp5 war govtarmy confldur dyadnr1 loggdp terr polity2 nopayrs _spline1 _spline2 _spline3, cl(statenum) nolog
test _spline1 _spline2 _spline3

*Specification test on model 2: Conflict Duration, instead of Dyad Duration
probit paterm1 biasgov biasreb biasnon medp5 war govtarmy confldur dyadnr1 loggdp terr polity2 nopayrs _spline1 _spline2 _spline3, cl(dyadid) nolog

*Specification test on model 2: Squared ConflictDuration (testing for non-linear duration)
probit paterm1 biasgov biasreb biasnon medp5 war govtarmy dyaddur dyaddursq dyadnr1 loggdp terr polity2 nopayrs _spline1 _spline2 _spline3, cl(dyadid) nolog

*Specification test on model 2: Squared DyadDuration (testing for non-linear duration)
probit paterm1 biasgov biasreb biasnon medp5 war govtarmy dyaddur dyaddursq dyadnr1 loggdp terr polity2 nopayrs _spline1 _spline2 _spline3, cl(dyadid) nolog

*MODEL 3: Specified Types of Mediators (and combinations)
probit paterm1 biasgov3 biasreb3 biasnon2 biasboth biasgov4 biasreb4, cl(dyadid) nolog
**outreg using XXX, coefastr se append

*Robustness check on Model 3: clustering on country, not dyad.
probit paterm1 biasgov3 biasreb3 biasnon2 biasboth biasgov4 biasreb4, cl(statenum) nolog

*MODEL 4: Specified Types of Mediators (and combinations), with inclusion of control-variables
probit paterm1 biasgov3 biasreb3 biasnon2 biasboth biasgov4 biasreb4 war govtarmy dyaddur dyadnr1 loggdp terr polity2 nopayrs _spline1 _spline2 _spline3, cl(dyadid) nolog
**outreg using XXX, coefastr se append
test _spline1 _spline2 _spline3

*Robustness check on Model 4: clustering on country, not dyad.
probit paterm1 biasgov3 biasreb3 biasnon2 biasboth biasgov4 biasreb4 war govtarmy dyaddur dyadnr1 loggdp terr polity2 nopayrs _spline1 _spline2 _spline3, cl(statenum) nolog
test _spline1 _spline2 _spline3

*MODEL 5: Negotiations as dependent variable. Specified Types of Mediators (and combinations), with inclusion of control-variables
probit nego biasgov3 biasreb3 biasnon2 biasboth biasgov4 biasreb4 war govtarmy dyaddur dyadnr1 loggdp terr polity2, cl(dyadid) nolog
**outreg using XXX, coefastr se append

*Another specification of mediators on Negotiations as dependent variable (note that there seems to be no difference between types of mediators) 
probit nego biasgov biasreb biasnon medp5 war  govtarmy dyaddur dyadnr1 loggdp terr polity2, cl(dyadid) nolog

*MODEL 6: Where to different types of mediators mediate? 
**Government-biased mediation. 
probit biasgov war  govtarmy dyaddur dyadnr1 loggdp terr polity2, cl(dyadid) nolog
**outreg using XXX, coefastr se append
**Rebel-biased mediation.
probit biasreb war  govtarmy dyaddur dyadnr1 loggdp terr polity2, cl(dyadid) nolog
**outreg using XXX, coefastr se append


