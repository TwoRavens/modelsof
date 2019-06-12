* Stata/MP 13.1 for Mac (64-bit Intel)

* Change directory to location where replication files have been downloaded

use "AppendixC.dta", clear

**** Online Appendix C ****

*** Table 8: Combined Indicators ***
*Rescale Indicators
su prestige_RR2, meanonly 
gen prestige_rs = (prestige_RR2 - r(min)) / (r(max) - r(min)) 
summarize prestige_rs
su prox_RR2, meanonly 
gen prox_rs = (prox_RR2 - r(min)) / (r(max) - r(min)) 
summarize prox_rs

correlate  prox_RR2 prestige_RR2

*Table 8
nbreg citeCount prox_rs prestige_rs citedElected2 citingElected2 citingLA citedLA s2sCites2 citedTortScore, cluster(citingCourt)
estimates store m1
nbreg crimCiteCount prox_rs prestige_rs citedElected2 citingElected2 citingLA citedLA citedTortScore s2sCitesCrim2 , cluster(citingCourt)
estimates store criminal
nbreg civilCiteCount prox_rs prestige_rs citedElected2 citingElected2 citingLA citedLA citedTortScore s2sCitesCivil2 , cluster(citingCourt)
estimates store civil
estout m1 criminal civil, cells("b(star fmt(3)) se") starlevels(* 0.05) stats( N)  varlabels(_cons Constant) 

**Regular Factor Analysis Robustness Check
**Mentioned, but results not provided in the appendix
factor ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil gb1 gb2 gb3 gb4 gb5 gb6 gb7 sameMethodF, factors(1)
predict proxFA
factor citedSquireProf citedLegCapS citedPopMil, factors(1)
predict prestigeFA
su prestigeFA, meanonly 
gen prestigeFA_rs = (prestigeFA - r(min)) / (r(max) - r(min)) 
summarize prestigeFA_rs
su proxFA, meanonly 
gen proxFA_rs = (proxFA - r(min)) / (r(max) - r(min)) 
summarize proxFA_rs

nbreg citeCount proxFA_rs prestigeFA_rs citedElected2 citingElected2 citingLA citedLA s2sCites2 citedTortScore, cluster(citingCourt)
estimates store m1
nbreg crimCiteCount proxFA_rs prestigeFA_rs citedElected2 citingElected2 citingLA citedLA citedTortScore s2sCitesCrim2 , cluster(citingCourt)
estimates store criminal
nbreg civilCiteCount proxFA_rs prestigeFA_rs citedElected2 citingElected2 citingLA citedLA citedTortScore s2sCitesCivil2 , cluster(citingCourt)
estimates store civil
estout m1 criminal civil, cells("b(star fmt(3)) se") starlevels(* 0.05) stats( N)  varlabels(_cons Constant) 

correlate  prox_RR2 proxFA
correlate  prestige_RR2 prestigeFA


