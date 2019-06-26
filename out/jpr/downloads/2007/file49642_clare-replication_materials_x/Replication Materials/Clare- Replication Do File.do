*** This file provides the Stata commands for replicating the results in "Democratization and International Conflict: The Impact of Institutional Legacies" **

*** Frequency Distribution (Table I)***
tab regtype1 init

*** Monadic model of dispute initiation (Table II) ***
use "(path and file name).dta",
zinb init_count stable_dem1 stable_aut1 redem1 redem1_pautdur1 redem1_pdemdur1 growth prop_demsregion1 riots1, inflate(stable_dem1 stable_aut1 redem1 redem1_pautdur1 redem1_pdemdur1 growth prop_demsregion1 riots1) vuong 


*** Model comparison tests (Zero-Inflated Poisson to Zero-Inflated Negative Binomial) ***
zip init_count stable_dem1 stable_aut1 redem1 redem1_pautdur1 redem1_pdemdur1 growth prop_demsregion1 riots1, inflate(stable_dem1 stable_aut1 redem1 redem1_pautdur1 redem1_pdemdur1 growth prop_demsregion1 riots1) vuong nolog
scalar llzip = e(ll)
zinb init_count stable_dem1 stable_aut1 redem1 redem1_pautdur1 redem1_pdemdur1 growth prop_demsregion1 riots1, inflate(stable_dem1 stable_aut1 redem1 redem1_pautdur1 redem1_pdemdur1 growth prop_demsregion1 riots1) nolog
scalar llzinb = e(ll)
scalar lr = -2*(llzip-llzinb)
scalar pvalue = chiprob(1,lr)/2
scalar lnalpha = -.4193847
if (lnalpha < -20) scalar pvalue=1 
di as text "Likelihood ratio test comparing ZIP to ZINB: " as res %8.3f lr as text " Prob>= " as res %5.3f pvalue


*** Dyadic model of dispute initiation (Table III) ***
use "(path and file name).dta",
logit initiate stable_dem1 stable_aut1 redem1 redem1_pautdur1 redem1_pdemdur1 democratizing2 relcap alliance01 prop_demsregion1 growth riots1 peaceyears spline1 spline2 spline3, cluster(dyad)
logit escalate stable_dem1 stable_aut1 redem1 redem1_pautdur1 redem1_pdemdur1 democratizing2 relcap alliance01 prop_demsregion1 growth riots1 
