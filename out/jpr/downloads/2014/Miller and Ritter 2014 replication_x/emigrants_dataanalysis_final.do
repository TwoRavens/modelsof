***************************************************
** Data Analysis for 
** Emigrants and the Onset of Civil Conflict
**
** Gina Miller
** glmiller1118@gmail.com
** &
** Emily Hencken Ritter
** eritter@ucmerced.edu
**
** File name: emigrants_dataanalysis_final.do
** Purpose: Estimations for reporting in the manuscript, plus robustness checks
** Input file(s): diaspora_state_1960-2009.dta
** Output file(s): hyptable_all.tex
**
** Last updated: August 8, 2013
**
***************************************************

clear
clear matrix
set mem 700m
cd "/Users/emilyritter/Dropbox/Active projects/Diasporas/Data" // Office
*cd "/Users/erhritter/Dropbox/Active projects/Diasporas/Data"  // Laptop

/*
**********

Do emigrants_datamanagement_final.do to create dataset diaspora_state_1960-2009.dta

**********
*/


/*
**************

Model to test hypothesis 1: As a larger proportion of emigrants from a given state of origin live in states with higher rights protections 
than the state of origin, civil war will be more likely to occur in the state of origin.

Reported models:
probit onset relrepweight colony prevcw5yr lngdppc, vce(cluster ccode)
probit onset l2.relrepweight colony prevcw5yr lngdppc, vce(cluster ccode)

More lags for robustness:
probit onset l.relrepweight colony prevcw5yr lngdppc, vce(cluster ccode)
probit onset l3.relrepweight colony prevcw5yr lngdppc, vce(cluster ccode)

**************
*/

use diaspora_state_1960-2009.dta, clear
set more off

probit onset relrepweight
probit onset l.relrepweight
probit onset l2.relrepweight 
probit onset l3.relrepweight 
* As Relative Repression increases, CWOnset is more likely at the 95% level of confidence for lags 0-3.

probit onset relrepweight colony prevcw5yr lngdppc lnwdipop, vce(cluster ccode)
probit onset l.relrepweight colony prevcw5yr lngdppc lnwdipop, vce(cluster ccode)
probit onset l2.relrepweight colony prevcw5yr lngdppc lnwdipop, vce(cluster ccode)
probit onset l3.relrepweight colony prevcw5yr lngdppc lnwdipop, vce(cluster ccode)
*Relative rights is significant in the year of comparison, not lagged, if we include population

probit onset relrepweight colony prevcw5yr lngdppc, vce(cluster ccode)
probit onset l.relrepweight colony prevcw5yr lngdppc, vce(cluster ccode)
probit onset l2.relrepweight colony prevcw5yr lngdppc, vce(cluster ccode)
probit onset l3.relrepweight colony prevcw5yr lngdppc, vce(cluster ccode)
*Relative rights is significant in all years if we do not control for domestic population. Makes sense, since so highly correlated with migrants living abroad.
*Reported in paper. 

probit onset relrepweight homephysint colony prevcw5yr lngdppc, vce(cluster ccode)
probit onset l.relrepweight l.homephysint colony prevcw5yr lngdppc, vce(cluster ccode)
probit onset l2.relrepweight l2.homephysint colony prevcw5yr lngdppc, vce(cluster ccode)
probit onset l3.relrepweight l3.homephysint colony prevcw5yr lngdppc, vce(cluster ccode)
*Controlling for the home state's level of repression makes it fall apart. Makes sense, since relrepweight is a function of the home state's
*level of repression. Highly correlated (-0.7241). Leave out.

xtset ccode year
xtprobit onset relrepweight colony prevcw5yr lngdppc
xtprobit onset l.relrepweight colony prevcw5yr lngdppc
xtprobit onset l2.relrepweight colony prevcw5yr lngdppc
xtprobit onset l3.relrepweight colony prevcw5yr lngdppc
*Same results (though L1 is 90% confidence instead of 95%) with a random-effects probit

*******
* Substantive Results
*******
use diaspora_state_1960-2009.dta, clear
sort ccode year
*by ccode: gen relrepl2=relrepweight[_n-2]
estsimp probit onset relrepweight colony prevcw5yr lngdppc, vce(cluster ccode)
*reported in paper:
setx relrepweight p25 colony max prevcw5yr max lngdppc p25
simqi, pr
*reported in paper:
setx relrepweight p75 colony max prevcw5yr max lngdppc p25
simqi, pr
setx relrepweight min colony max prevcw5yr max lngdppc p25
simqi, pr
setx relrepweight max colony max prevcw5yr max lngdppc p25
simqi, pr
setx relrepweight mean colony max prevcw5yr min lngdppc p25
simqi, pr
setx relrepweight mean colony max prevcw5yr max lngdppc p25
simqi, pr
setx relrepweight mean colony max prevcw5yr max lngdppc p25
simqi, pr
setx relrepweight mean colony max prevcw5yr max lngdppc p75
simqi, pr

/*
**************

Model to test hypothesis 2: As remittances from abroad increase, the likelihood of civil war onset in the state of origin will increase.

Reported models:
probit onset remit colony prevcw5yr lngdppc, vce(cluster ccode)
probit onset remitlag2 colony prevcw5yr lngdppc, vce(cluster ccode)

Other lags for robustness:
probit onset remitlag1 colony prevcw5yr lngdppc, vce(cluster ccode)
probit onset remitlag3 colony prevcw5yr lngdppc, vce(cluster ccode)
**************
*/

use diaspora_state_1960-2009.dta, clear
*Preliminary models....run for robustness and such below
set more off
probit onset lnrem, vce(robust)
probit onset lnremitlag1, vce(robust)
probit onset lnremitlag2, vce(robust)
probit onset lnremitlag3, vce(robust)
probit onset remit, vce(robust)
probit onset remitlag1, vce(robust)
probit onset remitlag2, vce(robust)
probit onset remitlag3, vce(robust)
*Logged values of remittances struggle to reach significance except L1, but regular remittances work great at all lags
*Not sure logged values make sense here, since that would suggest a far more drastic effect on civil war outcomes at lower values 
*than at higher ones. We have no reason to suspect that to be the case with remittances, though logging does "normalize" the distribution 
*of remittances. 

probit onset remit colony prevcw5yr lngdppc lnwdipop, vce(cluster ccode)
probit onset remitlag1 colony prevcw5yr lngdppc lnwdipop, vce(cluster ccode)
probit onset remitlag2 colony prevcw5yr lngdppc lnwdipop, vce(cluster ccode)
probit onset remitlag3 colony prevcw5yr lngdppc lnwdipop, vce(cluster ccode)
*With the full model, remittances reach 90% significance, but not 95%. But as above, I suspect remittances to be *highly* correlated
*with population, such that the latter's inclusion may not make sense. 

probit onset remit colony prevcw5yr lngdppc, vce(cluster ccode)
probit onset remitlag1 colony prevcw5yr lngdppc, vce(cluster ccode)
probit onset remitlag2 colony prevcw5yr lngdppc, vce(cluster ccode)
probit onset remitlag3 colony prevcw5yr lngdppc, vce(cluster ccode)
*In this model, remittances have a statistically significant positive effect for all lags

probit onset lnrem colony prevcw5yr lngdppc, vce(cluster ccode)
probit onset lnremitlag1 colony prevcw5yr lngdppc, vce(cluster ccode)
probit onset lnremitlag2 colony prevcw5yr lngdppc, vce(cluster ccode)
probit onset lnremitlag3 colony prevcw5yr lngdppc, vce(cluster ccode)
*Logged remittances are ok, though not significant in concurrent year or L2 (90%)

xtset ccode year
xtprobit onset remit colony prevcw5yr lngdppc
xtprobit onset remitlag1 colony prevcw5yr lngdppc
xtprobit onset remitlag2 colony prevcw5yr lngdppc
xtprobit onset remitlag3 colony prevcw5yr lngdppc
*xtprobits are all consistent with the models clustered by state. 

*******
* Substantive Results
*******
use diaspora_state_1960-2009.dta, clear
estsimp probit onset remit colony prevcw5yr lngdppc, vce(cluster ccode)
setx remit p25 colony max prevcw5yr max lngdppc p25
simqi, pr
setx remit p75 colony max prevcw5yr max lngdppc p25
simqi, pr
setx remit p10 colony max prevcw5yr max lngdppc p25
simqi, pr
setx remit p90 colony max prevcw5yr max lngdppc p25
simqi, pr
setx remit p5 colony max prevcw5yr max lngdppc p25
simqi, pr
setx remit p95 colony max prevcw5yr max lngdppc p25
simqi, pr
setx remit min colony max prevcw5yr max lngdppc p25
simqi, pr
setx remit max colony max prevcw5yr max lngdppc p25
simqi, pr
estsimp probit onset remitlag2 colony prevcw5yr lngdppc, vce(cluster ccode)
setx remitlag2 p25 colony max prevcw5yr max lngdppc p25
simqi, pr
setx remitlag2 p75 colony max prevcw5yr max lngdppc p25
simqi, pr
setx remitlag1 min colony max prevcw5yr max lngdppc p25
simqi, pr
setx remitlag1 max colony max prevcw5yr max lngdppc p25
simqi, pr
setx remitlag1 p10 colony max prevcw5yr max lngdppc p25
simqi, pr
setx remitlag1 p90 colony max prevcw5yr max lngdppc p25
simqi, pr
setx remitlag1 mean colony max prevcw5yr min lngdppc p25
simqi, pr
setx remitlag1 mean colony max prevcw5yr max lngdppc p25
simqi, pr
setx remitlag1 mean colony max prevcw5yr max lngdppc p25
simqi, pr
setx remitlag1 mean colony max prevcw5yr max lngdppc p75
simqi, pr

/*
**************

Model to test hypothesis 3: As increasing numbers of migrants have access to INGOs in their host states, the likelihood of 
civil war onset in the state of origin will decrease.

Remember: 
label var hrolm_filled "Smith & Weist HRO local membership in home states"
label var migswHROlm1 "Smith & Weist HRO local membership in host states (ln) relative to prop of migrant stock"
label var migswHROlm2 "Smith & Weist HRO local membership in host states relative to prop of migrant stock"
label var migswHROlm3 "Smith & Weist HRO local membership in host states (binary) relative to prop of migrant stock"

**************
*/

use diaspora_state_1960-2009.dta, clear
*prelims:
probit onset migswHROlm1, vce(cluster ccode)
probit onset migswHROlm2, vce(cluster ccode)
probit onset migswHROlm3, vce(cluster ccode)
probit onset migswHROlm1 colony prevcw5yr lngdppc lnwdipop, vce(cluster ccode)
probit onset migswHROlm2 colony prevcw5yr lngdppc lnwdipop, vce(cluster ccode)
probit onset migswHROlm3 colony prevcw5yr lngdppc lnwdipop, vce(cluster ccode)
probit onset migswHROlm1 colony prevcw5yr lngdppc, vce(cluster ccode)
probit onset migswHROlm2 colony prevcw5yr lngdppc, vce(cluster ccode)
probit onset migswHROlm3 colony prevcw5yr lngdppc, vce(cluster ccode)
*Not so good for the variants of the S&W data in the concurrent year

probit onset migswHROlm1 colony prevcw5yr lngdppc, vce(cluster ccode)
probit onset l.migswHROlm1 colony prevcw5yr lngdppc, vce(cluster ccode)
probit onset l2.migswHROlm1 colony prevcw5yr lngdppc, vce(cluster ccode)
probit onset l3.migswHROlm1 colony prevcw5yr lngdppc, vce(cluster ccode)

probit onset migswHROlm2 colony prevcw5yr lngdppc, vce(cluster ccode)
probit onset l.migswHROlm2 colony prevcw5yr lngdppc, vce(cluster ccode)
probit onset l2.migswHROlm2 colony prevcw5yr lngdppc, vce(cluster ccode)
probit onset l3.migswHROlm2 colony prevcw5yr lngdppc, vce(cluster ccode)

probit onset migswHROlm3 colony prevcw5yr lngdppc, vce(cluster ccode)
probit onset l.migswHROlm3 colony prevcw5yr lngdppc, vce(cluster ccode)
probit onset l2.migswHROlm3 colony prevcw5yr lngdppc, vce(cluster ccode)
probit onset l3.migswHROlm3 colony prevcw5yr lngdppc, vce(cluster ccode)
*So conceptually, migswHROlm2 makes the most sense given our expectations, but none of these models are significant

probit onset migswHROlm2 colony prevcw5yr lngdppc if year>1970, vce(cluster ccode) 
probit onset l.migswHROlm2 colony prevcw5yr lngdppc if year>1970, vce(cluster ccode)
probit onset l2.migswHROlm2 colony prevcw5yr lngdppc if year>1970, vce(cluster ccode)
probit onset l3.migswHROlm2 colony prevcw5yr lngdppc if year>1970, vce(cluster ccode)
probit onset migswHROlm2 colony prevcw5yr lngdppc if year>1980, vce(cluster ccode) 
probit onset l.migswHROlm2 colony prevcw5yr lngdppc if year>1980, vce(cluster ccode)
probit onset l2.migswHROlm2 colony prevcw5yr lngdppc if year>1980, vce(cluster ccode)
probit onset l3.migswHROlm2 colony prevcw5yr lngdppc if year>1980, vce(cluster ccode)
*Whoa. Interesting. If we limit the analysis to 1980 on, lots of significance. Could indicate a big shift in the way INGOs are 
*used/work starting in the 80s (internet/communication). Not crazy. 

probit onset migswHROlm1 colony prevcw5yr lngdppc if year>1980, vce(cluster ccode) 
probit onset l.migswHROlm1 colony prevcw5yr lngdppc if year>1980, vce(cluster ccode)
probit onset l2.migswHROlm1 colony prevcw5yr lngdppc if year>1980, vce(cluster ccode)
probit onset l3.migswHROlm1 colony prevcw5yr lngdppc if year>1980, vce(cluster ccode)

*Hafner-Burton and Tsutsui data:
probit onset migingoabroad colony prevcw5yr lngdppc if year>1980, vce(cluster ccode)
probit onset migingoslag1 colony prevcw5yr lngdppc if year>1980, vce(cluster ccode)
probit onset migingoslag2 colony prevcw5yr lngdppc if year>1980, vce(cluster ccode)
*not as good, but similar idea. 

xtset ccode year
xtprobit onset migswHROlm2 colony prevcw5yr lngdppc if year>1980
xtprobit onset l1.migswHROlm2 colony prevcw5yr lngdppc if year>1980
xtprobit onset l2.migswHROlm2 colony prevcw5yr lngdppc if year>1980
xtprobit onset l3.migswHROlm2 colony prevcw5yr lngdppc if year>1980
*less significance with the RE probit, but same idea



**Try combining into one model
use diaspora_state_1960-2009.dta, clear
probit onset relrepweight remit migswHROlm2 colony prevcw5yr lngdppc, vce(robust)
su year if e(sample)
probit onset l2.relrepweight remitlag2 l2.migswHROlm2 colony prevcw5yr lngdppc, vce(robust)
eststo combine 
* BEAUTIFUL

probit onset migingoabroad colony prevcw5yr lngdppc, vce(robust)
probit onset migingoabroad colony lngdppc, vce(robust)
probit onset migingoslag1 colony prevcw5yr lngdppc, vce(robust)
probit onset migingoslag2 colony prevcw5yr lngdppc, vce(robust)

*******
* Substantive Results
*******
use diaspora_state2, clear
estsimp probit onset migswHROlm1 colony prevcw5yr lngdppc, vce(robust)
setx migswHROlm1 p25 colony max prevcw5yr max lngdppc p25
simqi, pr
setx migswHROlm1 p75 colony max prevcw5yr max lngdppc p25
simqi, pr
setx migswHROlm1 p10 colony max prevcw5yr max lngdppc p25
simqi, pr
setx migswHROlm1 p90 colony max prevcw5yr max lngdppc p25
simqi, pr
setx migswHROlm1 mean colony max prevcw5yr min lngdppc p25
simqi, pr
setx migswHROlm1 mean colony max prevcw5yr max lngdppc p25
simqi, pr
setx migswHROlm1 mean colony max prevcw5yr max lngdppc p25
simqi, pr
setx migswHROlm1 mean colony max prevcw5yr max lngdppc p75
simqi, pr



/*
**************

Models for paper, Hypotheses 1-3

**************
*/
use diaspora_state_1960-2009.dta, clear
drop if year<1981
set more off
probit onset relrepweight colony prevcw5yr lngdppc, vce(cluster ccode)
eststo replag0
rocfit onset relrepweight, continuous(20)
*probit onset l.relrepweight colony prevcw5yr lngdppc, vce(cluster ccode)
*eststo replag1
probit onset l2.relrepweight colony prevcw5yr lngdppc, vce(cluster ccode)
eststo replag2
*probit onset l3.relrepweight colony prevcw5yr lngdppc, vce(cluster ccode)
*eststo replag3
probit onset remit colony prevcw5yr lngdppc, vce(cluster ccode)
rocfit onset remit, continuous(20)
eststo remitlag0
*probit onset remitlag1 colony prevcw5yr lngdppc, vce(cluster ccode)
*eststo remitlag1
probit onset remitlag2 colony prevcw5yr lngdppc, vce(cluster ccode)
eststo remitlag2
*probit onset remitlag3 colony prevcw5yr lngdppc, vce(cluster ccode)
*eststo remitlag3
probit onset migswHROlm1 colony prevcw5yr lngdppc, vce(cluster ccode) 
rocfit onset migswHROlm1, continuous(20)
eststo ingoslag0
*probit onset l.migswHROlm1 colony prevcw5yr lngdppc, vce(cluster ccode)
*eststo ingoslag1
probit onset l2.migswHROlm1 colony prevcw5yr lngdppc, vce(cluster ccode)
eststo ingoslag2
*probit onset l3.migswHROlm1 colony prevcw5yr lngdppc, vce(cluster ccode)
*eststo ingoslag3
probit onset relrepweight remit migswHROlm1 colony prevcw5yr lngdppc, vce(cluster ccode)
eststo combinelag0
probit onset l2.relrepweight remitlag2 l2.migswHROlm1 colony prevcw5yr lngdppc, vce(cluster ccode)
eststo combinelag2

esttab replag0 replag2 remitlag0 remitlag2 ingoslag0 ingoslag2 combinelag0 combinelag2 using hyptable_all.tex, ci(3) scalars("ll Log likelihood" "chi2 Chi-squared") sfmt(3) mtitles("Hypothesis \ref{hyp:repress}" "Hypothesis \ref{hyp:repress}, Lagged" "Hypothesis \ref{hyp:remit}" "Hypothesis \ref{hyp:remit}, Lagged" "Hypothesis \ref{hyp:activity}" "Hypothesis \ref{hyp:activity}, Lagged" "Hypotheses 1 - 3" "Hypotheses 1 - 3, Lagged") star title("Tests of Hypotheses \ref{hyp:remit}-\ref{hyp:activity}"\label{tab:hypsall}) replace
esttab replag0 remitlag0 ingoslag0 combinelag0 using hyptable_lag0.tex, ci(3) scalars("ll Log likelihood" "chi2 Chi-squared") sfmt(3) mtitles("Hypothesis \ref{hyp:repress}" "Hypothesis \ref{hyp:remit}" "Hypothesis \ref{hyp:activity}" "Hypotheses 1 - 3") star title("Tests of Hypotheses \ref{hyp:remit}-\ref{hyp:activity}, Concurrent Year"\label{tab:hypslag0}) replace
esttab replag2 remitlag2 ingoslag2 combinelag2 using hyptable_lag2.tex, ci(3) scalars("ll Log likelihood" "chi2 Chi-squared") sfmt(3) mtitles("Hypothesis \ref{hyp:repress}" "Hypothesis \ref{hyp:remit}" "Hypothesis \ref{hyp:activity}" "Hypotheses 1 - 3") star title("Tests of Hypotheses \ref{hyp:remit}-\ref{hyp:activity, Lagged 2 Years}"\label{tab:hypslag2}) replace




*esttab replag0 replag2 remitnolag remitlag2 hrolag0 hrolag2 combine using hyptable.tex, ci(3) scalars("ll Log likelihood" "chi2 Chi-squared") mtitles("Hypothesis 1" "Hypothesis 1" "Hypothesis 2" "Hypothesis 2" "Hypothesis 3" "Hypothesis 3" "Hypotheses 1 - 3") nostar title("Tests of Hypotheses \ref{hyp:repress}-\ref{hyp:activity}"\label{tab:hyps}) compress
*esttab replag2 remitlag2 hrolag2 combine using hyptable.tex, ci(3) scalars("ll Log likelihood" "chi2 Chi-squared") mtitles("Hypothesis 1" "Hypothesis 2" "Hypothesis 3" "Hypotheses 1 - 3") nostar title("Tests of Hypotheses \ref{hyp:repress}-\ref{hyp:activity}"\label{tab:hyps})
esttab replag2 remitlag3monad ngolag2 using hyptable3.tex, ci(3) scalars("ll Log likelihood" "chi2 Chi-squared") sfmt(3) mtitles("Hypothesis \ref{hyp:repress}" "Hypothesis \ref{hyp:remit}" "Hypothesis \ref{hyp:activity}" "Hypotheses 1 - 3") star title("Tests of Hypotheses \ref{hyp:remit}-\ref{hyp:activity}"\label{tab:hyps}) replace





/*
**************

End of do-file

**************
*/
