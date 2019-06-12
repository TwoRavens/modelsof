


/* Table 1: Cross-tabs */
set more off
gen massunrestAhigh2 = .
replace massunrestAhigh2 = 1 if massunrestA >= 2 & massunrestA != .
replace massunrestAhigh2 = 0 if massunrestA < 2

egen powercats = cut(powerratio), at(0,.4,.6,1) icodes
tab powercats
bysort powercats: tab massunrestAhigh2 inithostt1 ///
	if mzongo == 0 & mzjoanyi == 0 & mzjoanyt == 0 & year > 1945 ///
	& pol_rel == 1, exp chi

/* Table 2: Probit Regression Results, 1946-2000 */

* Model 1
probit inithostt1 massunrestA powerratio mu1xpr c.w1##c.w2 ///
	lndist allies sglo hostpy* ///
	if mzongo == 0 & mzjoanyi == 0 & mzjoanyt == 0 & year > 1945 & pol_rel == 1, cluster(ddyadid) nolog

* Model 2
probit inithostt1 massunrestA milratio mu1xmr c.w1##c.w2 ///
	lndist allies sglo hostpy* ///
	if mzongo == 0 & mzjoanyi == 0 & mzjoanyt == 0 & year > 1945 & pol_rel == 1, cluster(ddyadid) nolog

* Model 3
probit initfatalt1 massunrestA powerratio mu1xpr c.w1##c.w2 ///
	lndist allies sglo fatpy* ///
	if mzongo == 0 & mzjoanyi == 0 & mzjoanyt == 0 & pol_rel == 1, cluster(ddyadid) nolog
	
* Model 4
probit initfatalt1 massunrestA milratio mu1xmr c.w1##c.w2 ///
	lndist allies sglo fatpy* ///
	if mzongo == 0 & mzjoanyi == 0 & mzjoanyt == 0 & year > 1945 & pol_rel == 1, cluster(ddyadid) nolog

/* Marginal Effect Plots: Figure 1 and 2 */
/* Using Model 1. Graphs edited in Stata editor */

// Marginal effect of massunrestA as powerratio increases - Figure 1
set more off

probit inithostt1 c.massunrestA##c.powerratio c.w1##c.w2 ///
	lndist allies sglo hostpy* ///
	if mzongo == 0 & mzjoanyi == 0 & mzjoanyt == 0 & year > 1945 & pol_rel == 1, cluster(ddyadid) nolog
	
margins, dydx(massunrestA) at(powerratio=(0(.1)1) w1=0.5 w2=0.5 lndist=8.25 ///
	allies=0 sglo=0.75 hostpy=40.01977 hostpy1=-48459.51 hostpy2=-94837.07 hostpy3=-130571)

marginsplot, level(95)


// Marginal effect of powerratio as massunrestA increases - Figure 2
set more off
	
probit inithostt1 c.powerratio##c.massunrestA c.w1##c.w2 ///
	lndist allies sglo hostpy* ///
	if mzongo == 0 & mzjoanyi == 0 & mzjoanyt == 0 & year > 1945 & pol_rel == 1, cluster(ddyadid) nolog
	
margins, dydx(powerratio) at(massunrestA=(0(.25)4) w1=0.5 w2=0.5 lndist=8.25 ///
	allies=0 sglo=0.75 hostpy=40.01977 hostpy1=-48459.51 hostpy2=-94837.07 hostpy3=-130571)

marginsplot, level(95)

/* Table 3: Clarify Results using Model 1 */

// Model 1

* run the model
set more off

set seed 32301
estsimp probit inithostt1 massunrestA powerratio mu1xpr ///
	w1 w2 w1xw2 lndist allies sglo hostpy* ///
	if mzongo == 0 & mzjoanyi == 0 & mzjoanyt == 0 & year > 1945 & pol_rel == 1, cluster(ddyadid) nolog sims(10000)

// Scenario 1: low weak
setx massunrestA 0 powerratio 0.1 mu1xpr 0 allies 0 w1 0.5 w2 0.5 w1xw2 0.25 (sglo lndist hostpy*)mean
simqi, prval(1) genpr(S1)
label var S1 "low weak"

// Scenario 2: low strong
setx massunrestA 0 powerratio 0.9 mu1xpr 0 allies 0 w1 0.5 w2 0.5 w1xw2 0.25 (sglo lndist hostpy*)mean
simqi, prval(1) genpr(S2)
label var S2 "low strong"

// Scenario 3: high weak
setx massunrestA 4 powerratio 0.1 mu1xpr 0.1*4 allies 0 w1 0.5 w2 0.5 w1xw2 0.25 (sglo lndist hostpy*)mean
simqi, prval(1) genpr(S3)
label var S3 "high weak"

// Scenario 4: high strong
setx massunrestA 4 powerratio 0.9 mu1xpr 0.9*4 allies 0 w1 0.5 w2 0.5 w1xw2 0.25 (sglo lndist hostpy*)mean
simqi, prval(1) genpr(S4)
label var S4 "high strong"


// First differences

gen fd_muS3S1 = S3 - S1
centile fd_muS3S1, centile(5 25 75 95)
mean fd_muS3S1

gen fd_muS4S2 = S4 - S2
centile fd_muS4S2, centile(5 25 75 95)
mean fd_muS4S2

gen fd_muS4S3 = S4 - S3
centile fd_muS4S3, centile(5 25 75 95)
mean fd_muS4S3

/* Table 4: Robustness Models */

* Model 5
probit mzinitterrt1 massunrestA powerratio mu1xpr c.w1##c.w2 ///
	lndist allies sglo terrmidpy* if polrel == 1 & year > 1945, cluster(ddyadid) nolog

* Model 6
probit mzinitfatalterrt1 massunrestA powerratio mu1xpr c.w1##c.w2 ///
	lndist allies sglo fatalterrmidpy* if polrel == 1 & year > 1945, cluster(ddyadid) nolog
