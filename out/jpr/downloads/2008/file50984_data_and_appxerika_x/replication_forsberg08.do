* This file replicates the results in:
* Forsberg, Erika. 2008. "Polarization and Ethnic Conflict in a Widened Strategic Setting”
* Journal of Peace Research, 45(2).
* copy as do-file and use with the dataset "replication_forsbergjpr08.dta"
*****************************************************************************

set more off 

*generate dyad id*
gen dyadID=(cow_a*1000)+cow_b
label variable dyadID "Identifyer of dyad of state A and state B"

*gen case identifier*
generate caseID = _n


**************************************
*MAIN MODELS, REPORTED IN ARTICLE*
**************************************



* table I: descriptive statistics*
su beconset bparity  ckinfear ckinparity bgdpex lnbgdpex bpopex lnbpop bpolex sqbpolity awar aterritorial proximate boundarylength

*table II*
*Model 1*
logit beconset bparity llnbgdpex llnbpop lbpolex lsqbpolity laterritorial decay, cluster(cow_a) 
test lbpolex lsqbpolity
listcoef

*Model 2*
logit beconset bparity ckinfear llnbgdpex llnbpop lbpolex lsqbpolity laterritorial decay, cluster(cow_a) 
test lbpolex lsqbpolity
listcoef

*Model 3*
logit beconset bparity ckinfear ckinparity llnbgdpex llnbpop lbpolex lsqbpolity laterritorial decay, cluster(cow_a) 
test lbpolex lsqbpolity
listcoef

*Model 4*
logit beconset ckinfear bparity llnbgdpex llnbpop lbpolex lsqbpolity laterritorial lawar boundarylength proximate decay, cluster(cow_a) 
test lbpolex lsqbpolity
listcoef

*additive effect of kin and polarization*
logit beconset ckinfear bparity llnbgdpex llnbpop lbpolex lsqbpolity aterritorial decay, cluster(cow_a) 
prvalue, x(ckinfear=1 bparity=1) rest(mean) 
prvalue, x(ckinfear=0 bparity=0) rest(mean) 
prvalue, x(ckinfear=1 bparity=0) rest(mean) 
prvalue, x(ckinfear=0 bparity=1) rest(mean) 

*additional info for table III*
quietly logit beconset bparity ckinfear llnbgdpex llnbpop lbpolex lsqbpolity laterritorial decay, cluster(cow_a) 
prvalue, x(bparity=1) rest(mean)
prvalue, x(bparity=0) rest(mean)
prvalue, x(ckinfear=1) rest(mean)
prvalue, x(ckinfear=0) rest(mean)
prvalue, x(llnbgdpex=max) rest(mean)
prvalue, x(llnbgdpex=min) rest(mean)
prvalue, x(lbpolex=max) rest(mean)
prvalue, x(lbpolex=min) rest(mean)
prvalue, x(llnbpop=max) rest(mean)
prvalue, x(llnbpop=min) rest(mean)

****************************************
*ONLINE APPENDIX*
****************************************

*cross-tabs*
tab beconset bparity, chi2 column
tab beconset ckinfear, chi2 column

* regional concentration of kin groups, other variables as Model 2 above*
logit beconset kingroupcon2or3 bparity llnbgdpex lsqbpolity lbpolex llnbpop laterritorial decay, cluster(cow_a) 
logit beconset kingroupcon2 bparity llnbgdpex lsqbpolity lbpolex llnbpop laterritorial decay, cluster(cow_a) 
logit beconset kingroupcon3 bparity llnbgdpex lsqbpolity lbpolex llnbpop laterritorial decay, cluster(cow_a) 

*control for refugees*
*a. stock of refugees*
logit beconset bparity lrefugees llnbgdpex llnbpop lbpolex lsqbpolity laterritorial decay, cluster(cow_a) 
logit beconset bparity lrefugees ckinfear llnbgdpex llnbpop lbpolex lsqbpolity laterritorial decay, cluster(cow_a) 
logit beconset bparity lrefugees ckinfear ckinparity llnbgdpex llnbpop lbpolex lsqbpolity laterritorial decay, cluster(cow_a) 
logit beconset ckinfear lrefugees bparity llnbgdpex llnbpop lbpolex lsqbpolity laterritorial lawar boundarylength proximate decay, cluster(cow_a) 
*b. flows of refugees*
logit beconset bparity lrefuflow llnbgdpex llnbpop lbpolex lsqbpolity laterritorial decay, cluster(cow_a) 
logit beconset bparity lrefuflow ckinfear llnbgdpex llnbpop lbpolex lsqbpolity laterritorial decay, cluster(cow_a) 
logit beconset bparity lrefuflow ckinfear ckinparity llnbgdpex llnbpop lbpolex lsqbpolity laterritorial decay, cluster(cow_a) 
logit beconset ckinfear lrefuflow bparity llnbgdpex llnbpop lbpolex lsqbpolity laterritorial lawar boundarylength proximate decay, cluster(cow_a) 

* control for conflict before obs period*
logit beconset bparity llnbgdpex lsqbpolity lbpolex llnbpop laterritorial previous decay, cluster(cow_a) 
logit beconset bparity ckinfear llnbgdpex lsqbpolity lbpolex llnbpop  laterritorial previous decay, cluster(cow_a) 
logit beconset ckinparity bparity ckinfear llnbgdpex lsqbpolity lbpolex llnbpop laterritorial previous decay, cluster(cow_a) 
logit beconset bparity ckinfear llnbgdpex lsqbpolity lbpolex llnbpop  laterritorial previous lawar proximate boundarylength decay, cluster(cow_a) 

* alternative dependent variable*
logit beconset2 bparity llnbgdpex lsqbpolity lbpolex llnbpop laterritorial decay, cluster(cow_a) 
logit beconset2 bparity ckinfear llnbgdpex lsqbpolity lbpolex llnbpop  laterritorial decay, cluster(cow_a) 
logit beconset2 bparity ckinfear ckinparity llnbgdpex lsqbpolity lbpolex llnbpop laterritorial decay, cluster(cow_a) 
logit beconset2 bparity ckinfear llnbgdpex lsqbpolity lbpolex llnbpop  laterritorial lawar proximate boundarylength decay, cluster(cow_a) 

*Schneider & Wiesehomeier's measure of polarization*
logit beconset bparitysw llnbgdpex llnbpop lbpolex lsqbpolity laterritorial decay, cluster(cow_a) 
logit beconset bparitysw ckinfear llnbgdpex llnbpop lbpolex lsqbpolity laterritorial decay, cluster(cow_a) 
gen ckinparitysw = bparitysw*ckinfear
logit beconset bparitysw ckinfear ckinparitysw llnbgdpex llnbpop lbpolex lsqbpolity laterritorial decay, cluster(cow_a) 
logit beconset ckinfear bparitysw llnbgdpex llnbpop lbpolex lsqbpolity laterritorial lawar boundarylength proximate decay, cluster(cow_a) 

* Reynal-Querol's data of polarization*
logit beconset polrqb llnbgdpex llnbpop lbpolex lsqbpolity laterritorial decay, cluster(cow_a) 
logit beconset polrqb ckinfear llnbgdpex llnbpop lbpolex lsqbpolity laterritorial decay, cluster(cow_a) 
gen ckinparityRQ = polrqb*ckinfear
logit beconset polrqb  ckinfear ckinparityRQ llnbgdpex llnbpop lbpolex lsqbpolity laterritorial decay, cluster(cow_a) 
logit beconset ckinfear polrqb llnbgdpex llnbpop lbpolex lsqbpolity laterritorial lawar boundarylength proximate decay, cluster(cow_a) 

*inteff evaluation of Model 3's interaction effect*
logit beconset bparity ckinfear ckinparity llnbgdpex llnbpop lbpolex lsqbpolity laterritorial decay, cluster(cow_a) 
inteff beconset bparity ckinfear ckinparity llnbgdpex llnbpop lbpolex lsqbpolity laterritorial decay, savedata(C:\jprinteff, replace) savegraph1(C:\jprgraph1, replace) savegraph2(C:\jprgraph2, replace)

*alternatives for temporal depencence*
*1 Beck, Katz & Tucker*
logit beconset bparity llnbgdpex llnbpop lbpolex lsqbpolity laterritorial peaceyrs _spline1 _spline2 _spline3, cluster(cow_a) 
logit beconset bparity ckinfear llnbgdpex llnbpop lbpolex lsqbpolity laterritorial peaceyrs _spline1 _spline2 _spline3, cluster(cow_a) 
logit beconset bparity ckinfear ckinparity llnbgdpex llnbpop lbpolex lsqbpolity laterritorial peaceyrs _spline1 _spline2 _spline3, cluster(cow_a) 
logit beconset ckinfear bparity llnbgdpex llnbpop lbpolex lsqbpolity laterritorial lawar boundarylength proximate peaceyrs _spline1 _spline2 _spline3, cluster(cow_a) 

*2 Carter & Signorino*
logit beconset bparity llnbgdpex llnbpop lbpolex lsqbpolity laterritorial t t2 t3, cluster(cow_a) 
logit beconset bparity ckinfear llnbgdpex llnbpop lbpolex lsqbpolity laterritorial t t2 t3, cluster(cow_a) 
logit beconset bparity ckinfear ckinparity llnbgdpex llnbpop lbpolex lsqbpolity laterritorial t t2 t3, cluster(cow_a) 
logit beconset ckinfear bparity llnbgdpex llnbpop lbpolex lsqbpolity laterritorial lawar boundarylength proximate t t2 t3, cluster(cow_a) 

*Alternative clustering of standard errors (on state B)*
logit beconset bparity llnbgdpex llnbpop lbpolex lsqbpolity laterritorial decay, cluster(cow_b) 
logit beconset bparity ckinfear llnbgdpex llnbpop lbpolex lsqbpolity laterritorial decay, cluster(cow_b) 
logit beconset bparity ckinfear ckinparity llnbgdpex llnbpop lbpolex lsqbpolity laterritorial decay, cluster(cow_b) 
logit beconset ckinfear bparity llnbgdpex llnbpop lbpolex lsqbpolity laterritorial lawar boundarylength proximate decay, cluster(cow_b) 

* identifying influential cases*
quietly logit beconset ckinfear bparity llnbgdpex llnbpop lbpolex lsqbpolity laterritorial decay, cluster(cow_a) 
predict dbeta, dbeta
scatter dbeta caseID, mlab(caseID)

*regressions without obs with dbeta>0.3*
logit beconset bparity llnbgdpex llnbpop lbpolex lsqbpolity laterritorial decay if dbeta<.3, cluster(cow_a) 
logit beconset bparity ckinfear llnbgdpex llnbpop lbpolex lsqbpolity laterritorial decay if dbeta<.3, cluster(cow_a) 
logit beconset bparity ckinfear ckinparity llnbgdpex llnbpop lbpolex lsqbpolity laterritorial decay if dbeta<.3, cluster(cow_a) 
logit beconset ckinfear bparity llnbgdpex llnbpop lbpolex lsqbpolity laterritorial lawar boundarylength proximate decay if dbeta<.3, cluster(cow_a) 

*regressions without obs with dbeta>0.2*
logit beconset bparity llnbgdpex llnbpop lbpolex lsqbpolity laterritorial decay if dbeta<.2, cluster(cow_a) 
logit beconset bparity ckinfear llnbgdpex llnbpop lbpolex lsqbpolity laterritorial decay if dbeta<.2, cluster(cow_a) 
logit beconset bparity ckinfear ckinparity llnbgdpex llnbpop lbpolex lsqbpolity laterritorial decay if dbeta<.2, cluster(cow_a) 
logit beconset ckinfear bparity llnbgdpex llnbpop lbpolex lsqbpolity laterritorial lawar boundarylength proximate decay if dbeta<.2, cluster(cow_a) 


*Alternative estimators*

*1. rare events logit*
relogit beconset bparity llnbgdpex llnbpop lbpolex lsqbpolity laterritorial decay, cluster(cow_a) 
relogit beconset bparity ckinfear llnbgdpex llnbpop lbpolex lsqbpolity laterritorial decay, cluster(cow_a) 
relogit beconset bparity ckinfear ckinparity llnbgdpex llnbpop lbpolex lsqbpolity laterritorial decay, cluster(cow_a) 
relogit beconset ckinfear bparity llnbgdpex llnbpop lbpolex lsqbpolity laterritorial lawar boundarylength proximate decay, cluster(cow_a) 

*2. cox regression*
drop _d _t _t0
stset exit, origin(time inityear) enter(time entry) exit(time .) id(dyadID) failure(beconset)

stcox bparity llnbgdpex llnbpop lbpolex lsqbpolity laterritorial, cluster(cow_a) strata(spellseq) efron nolog
stcox bparity ckinfear llnbgdpex llnbpop lbpolex lsqbpolity laterritorial, cluster(cow_a) strata(spellseq) efron nolog
stcox bparity ckinfear ckinparity llnbgdpex llnbpop lbpolex lsqbpolity laterritorial, cluster(cow_a) strata(spellseq) efron nolog
stcox bparity ckinfear llnbgdpex llnbpop lbpolex lsqbpolity laterritorial lawar boundarylength proximate, cluster(cow_a) strata(spellseq) efron nolog

*****************************************
