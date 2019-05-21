**********************************************************************************************************************************************************
***Do file for Thomas, Jakana. 2014. "Rewarding Bad Behavior: How Governments Respond to Terrorism in Civil War." American Journal of Political Science ***
**********************************************************************************************************************************************************
use "JThomas_AJPS.dta", clear

**Table 1: "Logistic Regression of the Effect of Terrorism (t-1) on Negotiations**
*Model 1*
logit negotiations l.count_success rebel_strength_new maingroup explicit_rebel_support_new polity2 lnbd number_episode num_months_episode territory ethnowar thirdparty groupnum lngdp , robust cluster(conflictid)

**Table 2: "Negative Binomial Regressions of the Effect of Terrorism (t-1) on Concessions"**
*Model 2*
nbreg strong_number_of_concessions l.count_success rebel_strength_new maingroup explicit_rebel_support_new polity2 lnbd number_episode num_months_episode thirdparty territory ethnowar groupnum lngdp, robust cluster(conflictid)
*Model 3*
nbreg weak_number_ofconcessions l.count_success rebel_strength_new maingroup explicit_rebel_support_new polity2 lnbd number_episode num_months_episode thirdparty territory ethnowar groupnum lngdp, robust cluster(conflictid)
*Model 4*
nbreg pol_strong_number_of_concessions l.count_success rebel_strength_new maingroup explicit_rebel_support_new polity2 lnbd number_episode num_months_episode thirdparty territory ethnowar groupnum lngdp , robust cluster(conflictid)

**Figures 2: Predicted Probabilities of Negotiations: Number of Terror Attacks, Rebel Strength and Length of Episode"** 
**Figure 2a:*
use "JThomas_AJPS.dta", clear
tsset dyadid startcount
logit negotiations l.count_success rebel_strength_new maingroup explicit_rebel_support_new polity2 lnbd number_episode num_months_episode territory ethnowar thirdparty groupnum lngdp , robust cluster(conflictid)
estat sum
clear
set obs 49
gen rebel_strength_new=1.89
gen explicit_rebel_support_new=1
gen maingroup=1
gen num_months_episode= 35.91
gen polity2=-3.32
gen lnbd=5.71
gen number_episode= 1.22
gen intensity=1
gen territory=0
gen ethnowar=1
gen thirdparty=1
gen groupnum= 1.72
gen lngdp=22.246
gen laggediv=_n-1
sort  laggediv
save "figure1sim.dta", replace
use "JThomas_AJPS.dta"
logit negotiations laggediv rebel_strength_new maingroup explicit_rebel_support_new polity2 lnbd number_episode num_months_episode territory ethnowar thirdparty groupnum lngdp , robust cluster(conflictid)
use "figure1sim.dta", clear
predict Probhat
predict xb,xb
predict errors, stdp
gen Lindex=xb-(1.96)*errors
gen Uindex=xb+(1.96)*errors
gen L_prob=exp(Lindex)/(1+exp(Lindex))
gen U_prob=exp(Uindex)/(1+exp(Uindex))
twoway (rspike U_prob L_prob  laggediv, lcolor(black) lpattern(solid)) (line Probhat  laggediv, lcolor(black) lpattern(solid) lwidth(medthick)), ytitle(Predicted Pr(Negotiations)) xtitle(Number of Terror Attacks in Month) legend(off) graphregion(margin(vsmall))


**Figure 2b:**
use "JThomas_AJPS.dta", clear
logit negotiations laggediv rebel_strength_new maingroup explicit_rebel_support_new polity2 lnbd number_episode num_months_episode territory ethnowar thirdparty groupnum lngdp , robust cluster(conflictid)
estat sumclearset obs 5
gen explicit_rebel_support_new=1
gen maingroup=1
gen num_months_episode= 35.91
gen polity2=-3.32
gen lnbd=5.71
gen number_episode= 1.22
gen intensity=1
gen territory=0
gen ethnowar=1
gen thirdparty=1
gen groupnum= 1.72
gen lngdp=22.246
gen laggediv=.308gen rebel_strength_new=_n-1sort  rebel_strength_newsave "figure2sim.dta",replace
use "JThomas_AJPS.dta", clear
logit negotiations laggediv rebel_strength_new maingroup explicit_rebel_support_new polity2 lnbd number_episode num_months_episode territory ethnowar thirdparty groupnum lngdp , robust cluster(conflictid)
use "figure2sim.dta", clear
predict Probhatpredict xb,xbpredict errors, stdpgen Lindex=xb-(1.96)*errorsgen Uindex=xb+(1.96)*errorsgen L_prob=exp(Lindex)/(1+exp(Lindex))gen U_prob=exp(Uindex)/(1+exp(Uindex))
twoway (rarea U_prob L_prob rebel_strength_new, lcolor(gray) lpattern(solid)) (line Probhat  rebel_strength_new, lcolor(black) lpattern(solid) lwidth(medthick)), ytitle(Predicted Pr(Negotiations)) xtitle(Rebel Relative Strength) legend(off) graphregion(margin(vsmall))**** figure 2c***
use "JThomas_AJPS.dta", clear
logit negotiations laggediv rebel_strength_new maingroup explicit_rebel_support_new polity2 lnbd number_episode num_months_episode territory ethnowar thirdparty groupnum lngdp , robust cluster(conflictid)
estat sumclearset obs 192
gen explicit_rebel_support_new=1
gen maingroup=1
gen polity2=-3.32
gen lnbd=5.71
gen number_episode= 1.22
gen intensity=1
gen territory=0
gen ethnowar=1
gen thirdparty=1
gen groupnum= 1.72
gen lngdp=22.246
gen laggediv=.308gen rebel_strength_new= 1.85
gen num_months_episode=_n-1sort num_months_episode
save "figure3sim.dta", replace
use "JThomas_AJPS.dta", clear
logit negotiations laggediv rebel_strength_new maingroup explicit_rebel_support_new polity2 lnbd number_episode num_months_episode territory ethnowar thirdparty groupnum lngdp , robust cluster(conflictid)
use "figure3sim.dta", clear
predict Probhatpredict xb,xbpredict errors, stdpgen Lindex=xb-(1.96)*errorsgen Uindex=xb+(1.96)*errorsgen L_prob=exp(Lindex)/(1+exp(Lindex))gen U_prob=exp(Uindex)/(1+exp(Uindex))
twoway (rarea U_prob L_prob num_months_episode, lcolor(black) lpattern(solid)) (line Probhat  num_months_episode, lcolor(black) lpattern(solid) lwidth(medthick)), ytitle(Predicted Pr(Negotiations)) xtitle(Number of Months in Conflict Episode) legend(off) graphregion(margin(vsmall))************************************************************************************************************************************************************************************************ Tables found in the Supplemental Appendix for Jakana Thomas. 2014. "Rewarding Bad Behavior: How Governments Respond to Terrorism in Civil War." American Journal of Political Science ***
*********************************************************************************************************************************************************************************************use "JThomas_AJPS.dta", clear
**Table 3**
*Model 5*
logit negotiations l.lnterrorism rebel_strength_new maingroup explicit_rebel_support_new polity2 lnbd number_episode num_months_episode territory ethnowar thirdparty groupnum lngdp , robust cluster(conflictid)
*Model 6*
logit negotiations l.terrorism2 rebel_strength_new maingroup explicit_rebel_support_new polity2 lnbd number_episode num_months_episode territory ethnowar thirdparty groupnum lngdp , robust cluster(conflictid)
*Model 7*
logit negotiations l.terrorism3 rebel_strength_new maingroup explicit_rebel_support_new polity2 lnbd number_episode num_months_episode territory ethnowar thirdparty groupnum lngdp , robust cluster(conflictid)
*Model 8*
logit negotiations l.count_state rebel_strength_new maingroup explicit_rebel_support_new polity2 lnbd number_episode num_months_episode territory ethnowar thirdparty groupnum lngdp , robust cluster(conflictid)
*Model 9*
logit negotiations l.count_state_success rebel_strength_new maingroup explicit_rebel_support_new polity2 lnbd number_episode num_months_episode territory ethnowar thirdparty groupnum lngdp , robust cluster(conflictid)
*Model 10*
logit negotiations l.not_state_terrorism rebel_strength_new maingroup explicit_rebel_support_new polity2 lnbd number_episode num_months_episode territory ethnowar thirdparty groupnum lngdp , robust cluster(conflictid)

**Table 4**
*Model 11*
nbreg strong_number_of_concessions l.lnterrorism rebel_strength_new maingroup explicit_rebel_support_new polity2 lnbd number_episode num_months_episode territory ethnowar thirdparty groupnum lngdp , robust cluster(conflictid)
*Model 12*
nbreg strong_number_of_concessions l.terrorism2 rebel_strength_new maingroup explicit_rebel_support_new polity2 lnbd number_episode num_months_episode territory ethnowar thirdparty groupnum lngdp , robust cluster(conflictid)
*Model 13*
nbreg strong_number_of_concessions l.terrorism3 rebel_strength_new maingroup explicit_rebel_support_new polity2 lnbd number_episode num_months_episode territory ethnowar thirdparty groupnum lngdp , robust cluster(conflictid)
*Model 14*
nbreg strong_number_of_concessions l.count_state rebel_strength_new maingroup explicit_rebel_support_new polity2 lnbd number_episode num_months_episode territory ethnowar thirdparty groupnum lngdp , robust cluster(conflictid)
*Model 15*
nbreg strong_number_of_concessions l.count_state_success rebel_strength_new maingroup explicit_rebel_support_new polity2 lnbd number_episode num_months_episode territory ethnowar thirdparty groupnum lngdp , robust cluster(conflictid)
*Model 16*
nbreg strong_number_of_concessions l.not_state_terrorism rebel_strength_new maingroup explicit_rebel_support_new polity2 lnbd number_episode num_months_episode territory ethnowar thirdparty groupnum lngdp , robust cluster(conflictid)

**Table 5**
*Model 17*
logit negotiations count_success rebel_strength_new maingroup explicit_rebel_support_new polity2 lnbd number_episode num_months_episode territory ethnowar thirdparty groupnum lngdp , robust cluster(conflictid)
*Model 18*
logit f.negotiations count_success rebel_strength_new maingroup explicit_rebel_support_new polity2 lnbd number_episode num_months_episode territory ethnowar thirdparty groupnum lngdp , robust cluster(conflictid)
*Model 19*
logit f.negotiations l.negotiations count_success rebel_strength_new maingroup explicit_rebel_support_new polity2 lnbd number_episode num_months_episode territory ethnowar thirdparty groupnum lngdp , robust cluster(conflictid)
*Model 20*
logit negotiations l2.count_success rebel_strength_new maingroup explicit_rebel_support_new polity2 lnbd number_episode num_months_episode territory ethnowar thirdparty groupnum lngdp , robust cluster(conflictid)
*Model 21*
logit negotiations l3. count_success rebel_strength_new maingroup explicit_rebel_support_new polity2 lnbd number_episode num_months_episode territory ethnowar thirdparty groupnum lngdp , robust cluster(conflictid)

**Table 6**
*Model 22*
nbreg strong_number_of_concessions count_success rebel_strength_new maingroup explicit_rebel_support_new polity2 lnbd number_episode num_months_episode territory ethnowar thirdparty groupnum lngdp , robust cluster(conflictid)
*Model 23*
nbreg f.strong_number_of_concessions count_success rebel_strength_new maingroup explicit_rebel_support_new polity2 lnbd number_episode num_months_episode territory ethnowar thirdparty groupnum lngdp , robust cluster(conflictid)
*Model 24*
nbreg f.strong_number_of_concessions l.strong_number_of_concession count_success rebel_strength_new maingroup explicit_rebel_support_new polity2 lnbd number_episode num_months_episode territory ethnowar thirdparty groupnum lngdp , robust cluster(conflictid)
*Model 25*
nbreg strong_number_of_concessions l2.count_success rebel_strength_new maingroup explicit_rebel_support_new polity2 lnbd number_episode num_months_episode territory ethnowar thirdparty groupnum lngdp , robust cluster(conflictid)
*Model 26*
nbreg strong_number_of_concessions l3.count_success rebel_strength_new maingroup explicit_rebel_support_new polity2 lnbd number_episode num_months_episode territory ethnowar thirdparty groupnum lngdp , robust cluster(conflictid)

**Table 7**
*Model 27*
logit negotiations l.count_success rebel_strength_new maingroup explicit_rebel_support_new polity2 lnbd number_episode num_months_episode intensity territory ethnowar thirdparty groupnum lngdp if count_success<=15, robust cluster(conflictid)
*Model 28*
nbreg strong_number_of_concessions l.count_success rebel_strength_new maingroup explicit_rebel_support_new polity2 lnbd number_episode num_months_episode intensity territory ethnowar thirdparty groupnum lngdp if count_success<=15, robust cluster(conflictid)

**Table 8**
*Model 29*
logit negotiations l.count_success , robust cluster(conflictid)
*Model 30*
nbreg strong_number_of_concessions l.count_success , robust cluster(conflictid)

**Table 9**
*Model 31*
logit negotiations l.count_success rebel_strength_new maingroup explicit_rebel_support_new polity2 lnbd number_episode num_months_episode territory ethnowar thirdparty groupnum gdppercapitaconstant2005us , robust cluster(conflictid)
*Model 32*
logit negotiations l.count_success rebel_strength_new maingroup explicit_rebel_support_new polity2 lnbd number_episode num_months_episode territory ethnowar thirdparty groupnum gdp25per , robust cluster(conflictid)
*Model 33*
logit negotiations l.count_success rebel_strength_new maingroup explicit_rebel_support_new polity2 lnbd number_episode num_months_episode territory ethnowar thirdparty groupnum gdpcurrentus , robust cluster(conflictid)
*Model 34*
logit negotiations l.count_success rebel_strength_new maingroup explicit_rebel_support_new polity2 lnbd number_episode num_months_episode territory ethnowar thirdparty groupnum lngdp intensity , robust cluster(conflictid)
*Model 35*
nbreg strong_number_of_concessions l.count_success rebel_strength_new maingroup explicit_rebel_support_new polity2 lnbd number_episode num_months_episode thirdparty territory ethnowar groupnum gdppercapitaconstant2005us , robust cluster(conflictid)
*Model 36*
nbreg strong_number_of_concessions l.count_success rebel_strength_new maingroup explicit_rebel_support_new polity2 lnbd number_episode num_months_episode thirdparty territory ethnowar groupnum gdp25per , robust cluster(conflictid)
*Model 37*
nbreg strong_number_of_concessions l.count_success rebel_strength_new maingroup explicit_rebel_support_new polity2 lnbd number_episode num_months_episode thirdparty territory ethnowar groupnum gdpcurrentus , robust cluster(conflictid)
*Model 38*
nbreg strong_number_of_concessions l.count_success rebel_strength_new maingroup explicit_rebel_support_new polity2 lnbd number_episode num_months_episode thirdparty territory ethnowar groupnum lngdp intensity , robust cluster(conflictid)

**Table 10**
collapse (max) negotiations (sum) count_success (sum)strong_number_of_concession (max)rebel_strength_new (max)maingroup (max)explicit_rebel_support_new (max)polity2 (max)lnbd (max)number_episode (max)num_months_episode (max)territory (max)ethnowar (max)thirdparty (max)groupnum (max)lngdp conflictid, by (dyadid year)
*Model 39*
logit negotiations count_success rebel_strength_new maingroup explicit_rebel_support_new polity2 lnbd number_episode num_months_episode territory ethnowar thirdparty groupnum lngdp , robust cluster(conflictid)
*Model 40*
nbreg strong_number_of_concessions count_success rebel_strength_new maingroup explicit_rebel_support_new polity2 lnbd number_episode num_months_episode thirdparty territory ethnowar groupnum lngdp, robust cluster(conflictid)

***Figure 4***
use "JThomas_AJPS.dta", clear
nbreg strong_number_of_concessions laggediv rebel_strength_new maingroup explicit_rebel_support_new polity2 lnbd number_episode num_months_episode thirdparty territory ethnowar groupnum lngdp, robust cluster(conflictid)
margins, predict () at((median) _all laggediv =(0 5 10 15 20 25 30 35 40 45 50)) level(95) 
marginsplot
margins, predict () at((median) _all rebel_strength_new =(1 2 3 4 5)) level(95) 
marginsplot
margins, predict () at((median) _all num_months_episode =(0 50 100 150 200)) level(95) 
