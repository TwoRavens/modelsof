*
* National Leaders, Political Security, and the Formation of Military Coalitions
* Scott Wolford and Emily Hencken Ritter
* International Studies Quarterly
* Replication files
* 11 September 2015

* This do-file contains all code necessary to replicate the empirical models
* in both the aforementioned article in ISQ and the supplementary appendix.

* FILES
*	WR_formation_LC.dta - contains all variables needed to run analysis, as well
*		as identifying ICB crisis and directed crisis numbers

* MAIN ANALYSES

* Table 2: Empirical Models of Coalition Formation in Crises,  1951-1999
clear
use WR_formation_LC.dta

* Model 1: probit
probit join LinsecYoung difTPv difLPv cinc_ell cinc_tee cinc_pee LPallies unsupport LTdist PTdist demL demP PinsecYoung pcw Lmaj, cluster(crisno)

* Model 2: heteroskedastic probit
hetprobit join LinsecYoung difTPv difLPv cinc_ell cinc_tee cinc_pee LPallies unsupport LTdist PTdist demL demP PinsecYoung pcw Lmaj, cluster(crisno) het(LinsecYoung)

clear

* FIGURE 3
* Predicted probability of coalition formation by (a) principal belligerentÕs job insecurity and (b) preference divergence between target and potential partner

clear

set obs 101

gen difLPv=1.01 // mean
*gen difLPv=.29 // 25%
*gen difLPv=1.7 // 75%
gen difTPv=1.1
gen cinc_ell=.017
gen cinc_tee=.016
gen cinc_pee=.016
gen LPallies=0
gen unsupport=0
gen LTdist=1
gen PTdist=1
gen demL=0
gen demP=0
gen PinsecYoung=.17
gen pcw=0
gen Lmaj=0

gen LinsecYoung=_n-1
replace LinsecYoung=LinsecYoung/100

save hetsim_Linsec.dta, replace
*save hetsim_Linsec25.dta, replace
*save hetsim_Linsec75.dta, replace

clear

use formation_LC.dta

quietly: hetprobit join LinsecYoung difTPv difLPv cinc_ell cinc_tee cinc_pee LPallies unsupport LTdist PTdist demL demP PinsecYoung pcw Lmaj, cluster(crisno) het(LinsecYoung)

use hetsim_Linsec.dta

predict probhat
predict XBeta, xb
*predict seXB, stdp
predict seXB, sigma
gen varZ=seXB^2
*predictnl varZ2=xb(#2)

gen Lindex=XBeta-invnorm(0.975)*seXB
gen Uindex=XBeta+invnorm(0.975)*seXB
gen L_prob=normal(Lindex/exp(varZ))
gen U_prob=normal(Uindex/exp(varZ))
*gen L_prob=exp(Lindex)/(1+exp(Lindex))
*gen U_prob=exp(Uindex)/(1+exp(Uindex))

gen byhand=normal(XBeta/exp(varZ))

twoway  (line L_prob LinsecYoung, sort lcolor(black) lpattern(dash)) (line U_prob LinsecYoung, sort lcolor(black) lpattern(dash)) (line byhand LinsecYoung, sort lcolor(black)) if LinsecYoung>0, legend(off) ytitle(Predicted Probability of Coalition Formation) xtitle(Leader L's Probability of Losing Office)

graph save Graph insecurity.gph, replace

clear
use formation_LC.dta

quietly: hetprobit join LinsecYoung difTPv difLPv cinc_ell cinc_tee cinc_pee LPallies unsupport LTdist PTdist demL demP PinsecYoung pcw Lmaj, cluster(crisno) het(LinsecYoung)

*estat summ

clear

set obs 101

gen LinsecYoung=.17
gen difLPv=1.01 // mean
*gen difLPv=.29 // 25%
*gen difLPv=1.7 // 75%
gen cinc_ell=.017
gen cinc_tee=.016
gen cinc_pee=.016
gen LPallies=0
gen unsupport=0
gen LTdist=1
gen PTdist=1
gen demL=0
gen demP=0
gen PinsecYoung=.17
gen pcw=0
gen Lmaj=0

gen difTPv=_n-1
replace difTPv=difTPv/20

save hetsim_difTPv.dta, replace

clear

use formation_LC.dta

quietly: hetprobit join LinsecYoung difTPv difLPv cinc_ell cinc_tee cinc_pee LPallies unsupport LTdist PTdist demL demP PinsecYoung pcw Lmaj, cluster(crisno) het(LinsecYoung)

use hetsim_difTPv.dta

predict probhat
predict XBeta, xb
predict seXB, stdp
gen varZ=seXB^2
*predictnl varZ2=xb(#2)

gen Lindex=XBeta-invnorm(0.975)*seXB
gen Uindex=XBeta+invnorm(0.975)*seXB
gen L_prob=normal(Lindex/exp(varZ))
gen U_prob=normal(Uindex/exp(varZ))
*gen L_prob=exp(Lindex)/(1+exp(Lindex))
*gen U_prob=exp(Uindex)/(1+exp(Uindex))

gen byhand=normal(XBeta/exp(varZ))

twoway  (line L_prob difTPv, sort lcolor(black) lpattern(dash)) (line U_prob difTPv, sort lcolor(black) lpattern(dash)) (line byhand difTPv, sort lcolor(black)) if LinsecYoung<=.8, legend(off) ytitle(Predicted Probability of Coalition Formation) xtitle(Preference Divergence Between P and T)

graph save Graph divergencePT.gph, replace

clear

graph combine insecurity.gph divergencePT.gph, ycommon

graph save Graph insec_divPT.gph, replace

clear

* SUPPLEMENTARY ANALYSES

* Table A2: Empirical Models of Coalition Formation in Crises using UNGA Affinity Scores, 1951-1999
clear
use WR_formation_LC.dta

* Model 1: probit
probit join LinsecYoung affPT affLP cinc_ell cinc_tee cinc_pee LPallies unsupport LTdist PTdist demL demP PinsecYoung pcw Lmaj, cluster(crisno)

* Model 2: heteroskedastic probit
hetprobit join LinsecYoung affPT affLP cinc_ell cinc_tee cinc_pee LPallies unsupport LTdist PTdist demL demP PinsecYoung pcw Lmaj, cluster(crisno) het(LinsecYoung)

clear

* Table A4: Empirical Models of Coalition Formation in Crises by Regime Type,  1951-1999
clear
use WR_formation_LC.dta

* Model 1: democracy
hetprobit join LinsecYoung difTPv difLPv cinc_ell cinc_tee cinc_pee LPallies unsupport LTdist PTdist demP PinsecYoung pcw Lmaj if demL==1, cluster(crisno) het(LinsecYoung)

* Model 2: nondemocracy
hetprobit join LinsecYoung difTPv difLPv cinc_ell cinc_tee cinc_pee LPallies unsupport LTdist PTdist demP PinsecYoung pcw Lmaj if demL==0, cluster(crisno) het(LinsecYoung)

* Model 3: indicators
probit join difTPv difLPv cinc_ell cinc_tee cinc_pee LPallies unsupport LTdist PTdist demL demP pcw Lmaj, cluster(crisno)

clear
