capture log close
log using "GeographicOpportunity.log", replace


/* 
Stata do file that replicates analysis in 

Kathryn Furlong, Nils Petter Gleditsch, and Håvard Hegre, 2006
"Geographic Opportunity and Neomalthusian Willingness: Boundaries, Shared Rivers, and Conflict"

International Interactions, 32(1):(1-30)


*/

/* Stata version 6*/

clear
set memory 120000
use "rivers_replication_ii.dta"


/* Robust estimations */

* Table 1
logit mid1 riverbor, cluster(dyadID)
logit mid1 onedemo zerodemo transit, cluster(dyadID)
logit mid1 majorpow, cluster(dyadID) 
logit mid1 encons, cluster(dyadID) 
logit mid1 alliance, cluster(dyadID) 
logit mid1 mdecay43, cluster(dyadID)

logit mid1 ln_len, cluster(dyadID)

logit mid1 riverbor if (onedemo == 1 | zerodem == 1), cluster(dyadID)
logit mid1 riverbor if encons<-1.458, cluster(dyadID)

logit mid1 ln_len if (onedemo == 1 | zerodem == 1), cluster(dyadID)
logit mid1 ln_len if encons<-1.458, cluster(dyadID)
logit mid1 riverbor if ln_len > 6.23, cluster(dyadID)

logit mid1 twolow onelow, cluster(dyadID)



* Table 2, Model 1; Temporal dependence modeled with decaying function, alfa = 4.329,
logit mid1 riverbor onedemo zerodemo transit majorpow encons alliance mdecay43 ln_len if year <= 1992, cluster(dyadID)
* Table 2, Model 2
logit mid1 rivnumbe onedemo zerodemo transit majorpow encons alliance mdecay43 ln_len if year <= 1992, cluster(dyadID)

* Table 3, Model 1
logit mid1 riverbor onedemo zerodemo transit majorpow encons alliance mdecay43 ln_len if year >= 1980 & year <= 1992 & twolow ~=. & onelow ~=. & zerolow ~=., cluster(dyadID)
* Table 3, Model 2
logit mid1 river1 river2 river3 river4 onedemo zerodemo transit majorpow encons alliance mdecay43 ln_len if year >= 1980 & year <= 1992 & twolow ~=. & onelow ~=. & zerolow ~=., cluster(dyadID)

* Table 4, Model 1
logit mid1 riverbor somelow onedemo zerodemo transit majorpow encons alliance mdecay43 ln_len if year >= 1980 & year <= 1992, cluster(dyadID)
* Table 4, Model 2
logit mid1 riverbor somelow rivlow onedemo zerodemo transit majorpow encons alliance mdecay43 ln_len  if year >= 1980 & year <= 1992, cluster(dyadID)

/* Running Clarify */
/* Note: Clarify produces output from a set of random draws. Results will therefore vary from run to run, 
	and an exact replication of printed results is not possible */

/* Model 1:*/
capture drop b*
estsimp logit mid1 riverbor onedemo zerodemo transit majorpow encons alliance mdecay43 ln_len if year <= 1992, cluster(dyadID)
setx riverbor 0 onedemo 0 zerodemo 0 transit 0 majorpow 0 encons mean alliance 0 mdecay43 0 ln_len mean
simqi, pr 
setx riverbor 1 onedemo 0 zerodemo 0 transit 0 majorpow 0 encons mean alliance 0 mdecay43 0 ln_len mean
simqi, pr 
setx riverbor 0 onedemo 0 zerodemo 0 transit 0 majorpow 0 encons mean alliance 0 mdecay43 0 ln_len 6.23
simqi, pr 
setx riverbor 0 onedemo 0 zerodemo 0 transit 0 majorpow 0 encons mean alliance 0 mdecay43 0 ln_len 7.23
simqi, pr 
setx riverbor 0 onedemo 0 zerodemo 0 transit 0 majorpow 0 encons mean alliance 0 mdecay43 -.63 ln_len mean
simqi, pr 



/* Model 2: */
capture drop b*
estsimp logit mid1 rivnumbe onedemo zerodemo transit majorpow encons alliance mdecay43 ln_len if year <= 1992, cluster(dyadID)
setx rivnumbe 0 onedemo 0 zerodemo 0 transit 0 majorpow 0 encons mean alliance 0 mdecay43 0 ln_len mean
simqi, pr 
setx rivnumbe 7 onedemo 0 zerodemo 0 transit 0 majorpow 0 encons mean alliance 0 mdecay43 0 ln_len mean
simqi, pr 

/* Model 4: */
capture drop b*
estsimp logit mid1 river1 river2 river3 river4 onedemo zerodemo transit majorpow encons alliance mdecay43 ln_len if year >= 1980 & year <= 1992 & twolow ~=. & onelow ~=. & zerolow ~=., cluster(dyadID)
setx river1 0 river2 0 river3 0 river4 0 onedemo 0 zerodemo 0 transit 0 majorpow 0 encons mean alliance 0 mdecay43 0 ln_len mean
simqi, pr 
setx river1 1 river2 0 river3 0 river4 0 onedemo 0 zerodemo 0 transit 0 majorpow 0 encons mean alliance 0 mdecay43 0 ln_len mean
simqi, pr 
setx river1 0 river2 1 river3 0 river4 0 onedemo 0 zerodemo 0 transit 0 majorpow 0 encons mean alliance 0 mdecay43 0 ln_len mean
simqi, pr 
setx river1 0 river2 0 river3 1 river4 0 onedemo 0 zerodemo 0 transit 0 majorpow 0 encons mean alliance 0 mdecay43 0 ln_len mean
simqi, pr 
setx river1 0 river2 0 river3 0 river4 1 onedemo 0 zerodemo 0 transit 0 majorpow 0 encons mean alliance 0 mdecay43 0 ln_len mean
simqi, pr 
 
/* Model 6: */
capture drop b*
estsimp logit mid1 riverbor somelow rivlow onedemo zerodemo transit majorpow encons alliance mdecay43 ln_len  if year >= 1980 & year <= 1992, cluster(dyadID)
setx riverbor 0 somelow 0 rivlow 0 onedemo 0 zerodemo 0 transit 0 majorpow 0 encons mean alliance 0 mdecay43 0 ln_len mean
simqi, pr 
setx riverbor 0 somelow 1 rivlow 0 onedemo 0 zerodemo 0 transit 0 majorpow 0 encons mean alliance 0 mdecay43 0 ln_len mean
simqi, pr 
setx riverbor 1 somelow 0 rivlow 0 onedemo 0 zerodemo 0 transit 0 majorpow 0 encons mean alliance 0 mdecay43 0 ln_len mean
simqi, pr 
setx riverbor 1 somelow 1 rivlow 1 onedemo 0 zerodemo 0 transit 0 majorpow 0 encons mean alliance 0 mdecay43 0 ln_len mean
simqi, pr 


/* Some interaction terms */
* Based on Table 2, Model 1
capture drop lenencons
gen lenencons = lnlencen*enconscen
logit mid1 riverbor onedemo zerodemo transit majorpow encons alliance mdecay43 ln_len lenencons if year <= 1992
vce, corr

gen lenonedem = lnlencen*onedemo
gen lenzerodem = lnlencen*zerodemo
logit mid1 riverbor onedemo zerodemo transit majorpow encons alliance mdecay43 ln_len lenonedem lenzerodem if year <= 1992
vce, corr

gen lenriverbor = lnlencen*riverbor
logit mid1 riverbor onedemo zerodemo transit majorpow encons alliance mdecay43 ln_len lenriverbor if year <= 1992
vce, corr

/* Rerunning with a higher fatality threshold*/
* Based on Table 2, Model 1
logit mid25 riverbor onedemo zerodemo transit majorpow encons alliance mdecay43 ln_len  if year <= 1992
vce, corr


/* Running with COW wars as dependent variable */
* Table 2, Model l 1; Temporal dependence modeled with decaying function, alfa = 4.329,
logit waronset riverbor onedemo zerodemo transit majorpow encons alliance mdecay43 ln_len if year <= 1992, cluster(dyadID)
* Table 2, Model 2
logit waronset rivnumbe onedemo zerodemo transit majorpow encons alliance mdecay43 ln_len if year <= 1992, cluster(dyadID)
