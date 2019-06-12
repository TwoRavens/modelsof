
use "MattesRodriguezISQ.dta", replace


**************************
**DESCRIPTIVE STATISTICS** 
**************************

*** Frequencies of Different Regime Type Dyads (Table I, column 1)
sum dyad if jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=.
tab jointdem if jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=.
tab spsp if jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=.
tab milmil if jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=.
tab perper if jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=.
tab spdem if jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=.
tab mildem if jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=.
tab perdem if jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=.
tab spmil if jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=.
tab spper if jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=.
tab milper if jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=.
tab other if jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=.

*** Mean Goldstein Cooperation Scores (Table I, column 2)
sum Goldstein if jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=.
sum Goldstein if jointdem==1 & jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=.
sum Goldstein if spsp==1 & jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=.
sum Goldstein if milmil==1 & jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=.
sum Goldstein if perper==1 & jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=.
sum Goldstein if spdem==1 & jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=.
sum Goldstein if mildem==1 & jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=.
sum Goldstein if perdem==1 & jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=.
sum Goldstein if spmil==1 & jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=.
sum Goldstein if spper==1 & jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=.
sum Goldstein if milper==1 & jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=.
sum Goldstein if other==1 & jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=.

*** International Cooperation Dummy= 1 (Table I, column 3)
tab coopdum if jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=.
tab coopdum if jointdem==1 & jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=.
tab coopdum if spsp==1 & jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=.
tab coopdum if milmil==1 & jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=.
tab coopdum if perper==1 & jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=.
tab coopdum if spdem==1 & jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=.
tab coopdum if mildem==1 & jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=.
tab coopdum if perdem==1 & jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=.
tab coopdum if spmil==1 & jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=.
tab coopdum if spper==1 & jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=.
tab coopdum if milper==1 & jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=.
tab coopdum if othermil==1 & jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=.

*** Decriptive statistics for control variables
tab maj if jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=.
sum dist if jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=.
tab jointwlth if jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=.
tab ATOPallydum if jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=.
tab jstable if jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=.


*****************
**MAIN ANALYSIS**
*****************

**** T-Tests (using Goldstein Cooperation Scale)
*1*Comparison of joint dem dyads to joint sp dyadsgen jointdem_spsp=.replace jointdem_spsp=1 if jointdem==1 replace jointdem_spsp=0 if spsp==1ttest Goldstein if jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=., by (jointdem_spsp) unpaired unequal 

*2*Comparison of joint dem dyads to joint mil dyadsgen jointdem_milmil=.replace jointdem_milmil=1 if jointdem==1replace jointdem_milmil=0 if milmil==1ttest Goldstein if jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=., by (jointdem_milmil) unpaired unequal*3*Comparison of joint dem dyads to joint per dyadsgen jointdem_perper=.replace jointdem_perper=1 if jointdem==1replace jointdem_perper=0 if perper==1ttest Goldstein if jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=., by (jointdem_perper) unpaired unequal*4*Comparison of joint sp dyads to joint mil dyadsgen spsp_milmil=.replace spsp_milmil=1 if spsp==1replace spsp_milmil=0 if milmil==1ttest Goldstein if jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=., by (spsp_milmil) unpaired unequal*5*Comparison of joint sp dyads to joint per dyadsgen spsp_perper=.replace spsp_perper=1 if spsp==1replace spsp_perper=0 if perper==1ttest Goldstein if jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=., by (spsp_perper) unpaired unequal*6*Comparison of joint mil dyads to joint per dyadsgen milmil_perper=.replace milmil_perper=1 if milmil==1replace milmil_perper=0 if perper==1ttest Goldstein if jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=., by (milmil_perper) unpaired unequal*7*Comparison of spdem dyads to mildem dyadsgen spdem_mildem=.replace spdem_mildem=1 if spdem==1replace spdem_mildem=0 if mildem==1ttest Goldstein if jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=., by (spdem_mildem) unpaired unequal*8*Comparison of spdem dyads to perdem dyadsgen spdem_perdem=.replace spdem_perdem=1 if spdem==1replace spdem_perdem=0 if perdem==1ttest Goldstein if jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=., by (spdem_perdem) unpaired unequal*9*Comparison of mildem dyads to perdem dyadsgen mildem_perdem=.replace mildem_perdem=1 if mildem==1replace mildem_perdem=0 if perdem==1ttest Goldstein if jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=., by (mildem_perdem) unpaired unequal*10*Comparison of spmil dyads to spper dyadsgen spmil_spper=.replace spmil_spper=1 if spmil==1replace spmil_spper=0 if spper==1ttest Goldstein if jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=., by (spmil_spper) unpaired unequal*11*Comparison of spmil dyads to milper dyadsgen spmil_milper=.replace spmil_milper=1 if spmil==1replace spmil_milper=0 if milper==1ttest Goldstein if jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=., by (spmil_milper) unpaired unequal*12*Comparison of spper dyads to milper dyadsgen spper_milper=.replace spper_milper=1 if spper==1replace spper_milper=0 if milper==1ttest Goldstein if jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=., by (spper_milper) unpaired unequal

*13*Comparison of jointdem to spdem
gen jointdem_spdem=.replace jointdem_spdem=1 if jointdem==1replace jointdem_spdem=0 if spdem==1ttest Goldstein if jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=., by (jointdem_spdem) unpaired unequal

*14*Comparison of jointdem to mildem
gen jointdem_mildem=.replace jointdem_mildem=1 if jointdem==1replace jointdem_mildem=0 if mildem==1ttest Goldstein if jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=., by (jointdem_mildem) unpaired unequal

*15*Comparison of jointdem to perdem
gen jointdem_perdem=.replace jointdem_perdem=1 if jointdem==1replace jointdem_perdem=0 if perdem==1ttest Goldstein if jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=., by (jointdem_perdem) unpaired unequal

*16*Comparison of spsp to spdem
gen spsp_spdem=.replace spsp_spdem=1 if spsp==1replace spsp_spdem=0 if spdem==1ttest Goldstein if jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=., by (spsp_spdem) unpaired unequal

*17*Comparison of spsp to spmil
gen spsp_spmil=.replace spsp_spmil=1 if spsp==1replace spsp_spmil=0 if spmil==1ttest Goldstein if jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=., by (spsp_spmil) unpaired unequal

*18*Comparison of spsp to spper
gen spsp_spper=.replace spsp_spper=1 if spsp==1replace spsp_spper=0 if spper==1ttest Goldstein if jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=., by (spsp_spper) unpaired unequal

*19*Comparison of milmil to mildem
gen milmil_mildem=.replace milmil_mildem=1 if milmil==1replace milmil_mildem=0 if mildem==1ttest Goldstein if jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=., by (milmil_mildem) unpaired unequal

*20*Comparison of milmil to spmil
gen milmil_spmil=.replace milmil_spmil=1 if milmil==1replace milmil_spmil=0 if spmil==1ttest Goldstein if jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=., by (milmil_spmil) unpaired unequal

*21*Comparison of milmil to milper
gen milmil_milper=.replace milmil_milper=1 if milmil==1replace milmil_milper=0 if milper==1ttest Goldstein if jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=., by (milmil_milper) unpaired unequal

*22*Comparison of perper to perdem
gen perper_perdem=.replace perper_perdem=1 if perper==1replace perper_perdem=0 if perdem==1ttest Goldstein if jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=., by (perper_perdem) unpaired unequal

*23*Comparison of perper to spper
gen perper_spper=.replace perper_spper=1 if perper==1replace perper_spper=0 if spper==1ttest Goldstein if jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=., by (perper_spper) unpaired unequal

*24*Comparison of perper to milper
gen perper_milper=.replace perper_milper=1 if perper==1replace perper_milper=0 if milper==1ttest Goldstein if jointdem!=. & spsp!=. & jointwlth!=. & ATOPallydum!=. & jstable!=. & dist!=. & maj!=., by (perper_milper) unpaired unequal


**** GEE Models (Table 2)
xtset dyad year

** Goldstein Cooperation Scale (Table 2, Column 1)
xtgee Goldstein spsp milmil perper spdem mildem perdem spmil spper milper other jointwlth jstable ATOPallydum dist maj, robust c(ar 1)

*Wald Test- Pure Dyads
test spsp-perper=0
test spsp-milmil=0
test perper-milmil=0
*Wald Test- Mixed Dem-Aut Dyads
test spdem-perdem=0
test mildem-perdem=0
test spdem-mildem=0
*Wald Test- Mixed Aut Dyads
test milper-spper=0
test milper-spmil=0
test spmil-spper=0
*Wald Test- Comparison of preferred partners by dyad type
test spsp-spdem=0
test spsp-spmil=0
test spsp-spper=0
test spdem-spmil=0
test spdem-spper=0
test milmil-mildem=0
test milmil-spmil=0
test milmil-milper=0
test mildem-spmil=0
test mildem-milper=0
test perper-perdem=0
test perper-milper=0
test perper-spper=0
test perdem-milper=0
test perdem-spper=0

** International Cooperation Dummy (Table 2, Column 2)
xtgee coopdum spsp perper spdem mildem perdem spmil spper milper othermil jointwlth jstable ATOPallydum dist maj, robust f(bin) l(logit) c(ar1)

*Wald Test- Pure Dyads
test spsp-perper=0
*Wald Test- Mixed Dem-Aut Dyads
test spdem-perdem=0
test mildem-perdem=0
test spdem-mildem=0
*Wald Test- Mixed Aut Dyads
test milper-spper=0
test milper-spmil=0
test spmil-spper=0
*Wald Test- Comparison of preferred partners by dyad type
test spsp-spdem=0
test spsp-spmil=0
test spsp-spper=0
test spdem-spmil=0
test spdem-spper=0
test mildem-spmil=0
test mildem-spper=0
test perper-perdem=0
test perper-milper=0
test perper-spper=0
test perdem-milper=0
test perdem-spper=0

*Predicted Probabilities
*Single-party-Democracy Cooperation
margins, predict(mu) at((zero) _all spdem=1 dist= 8.198425)
*Personalist-Democracy Cooperation
margins, predict(mu) at((zero) _all perdem=1 dist= 8.198425)


****************************************
**ROBUSTNESS CHECKS AND OTHER ANALYSES**
****************************************

**** Joint Democracy as a Predictor of International Cooperation
xtgee Goldstein jointdem jointwlth jstable ATOPallydum dist maj, robust c(ar 1) 
xtgee coopdum jointdem jointwlth jstable ATOPallydum dist maj, robust f(bin) l(logit) c(ar1)

**** Natural Log of the Goldstein Cooperation Score
gen Goldsteinlog= log(Goldstein + 1)
xtgee Goldsteinlog spsp milmil perper spdem mildem perdem spmil spper milper other jointwlth jstable ATOPallydum dist maj, robust c(ar 1)

**** Rare Events Logit of the International Cooperation Dummy
relogit coopdum spsp perper spdem mildem perdem spmil spper milper othermil jointwlth jstable ATOPallydum dist maj, cluster(dyad)

**** Dropping the “Shared Alliance” Variable
xtgee Goldstein spsp milmil perper spdem mildem perdem spmil spper milper other jointwlth jstable dist maj, robust c(ar 1)
xtgee coopdum spsp perper spdem mildem perdem spmil spper milper othermil jointwlth jstable dist maj, robust f(bin) l(logit) c(ar1)

**** Dropping the “Major Power” Variable
xtgee Goldstein spsp milmil perper spdem mildem perdem spmil spper milper other jointwlth jstable ATOPallydum dist, robust c(ar 1)
xtgee coopdum spsp perper spdem mildem perdem spmil spper milper othermil jointwlth jstable ATOPallydum dist, robust f(bin) l(logit) c(ar1)

**** Three-Year Threshold for Jointly Stable Dyads
xtgee Goldstein spsp milmil perper spdem mildem perdem spmil spper milper other jointwlth jstable3yr ATOPallydum dist maj, robust c(ar 1)
xtgee coopdum spsp perper spdem mildem perdem spmil spper milper othermil jointwlth jstable3yr ATOPallydum dist maj, robust f(bin) l(logit) c(ar1)

**** Including Alliance Portfolio Similarity (s score)
*w/ Shared Alliance
xtgee Goldstein spsp milmil perper spdem mildem perdem spmil spper milper other jointwlth jstable ATOPallydum dist maj s_un_glo, robust c(ar 1)
xtgee coopdum spsp perper spdem mildem perdem spmil spper milper othermil jointwlth jstable ATOPallydum dist maj s_un_glo, robust f(bin) l(logit) c(ar1)
*w/out Shared Alliance
xtgee Goldstein spsp milmil perper spdem mildem perdem spmil spper milper other jointwlth jstable dist maj s_un_glo, robust c(ar 1)
xtgee coopdum spsp perper spdem mildem perdem spmil spper milper othermil jointwlth jstable dist maj s_un_glo, robust f(bin) l(logit) c(ar1)

**** Including Dyads Composed of Dynastic Monarchies
xtgee Goldstein spsp milmil perper dyndyn spdem mildem perdem dyndem spmil spper spdyn milper mildyn perdyn otherdyn jointwlth jstable ATOPallydum dist maj, robust c(ar 1)
xtgee coopdum spsp perper dyndyn spdem mildem perdem dyndem spmil spper spdyn milper mildyn perdyn otherdynmil jointwlth jstable ATOPallydum dist maj, robust f(bin) l(logit) c(ar 1)

**** Replacing Geddes Regime Types with Bueno de Mesquita et al.’s (2003) measure of W and W/S
xtgee Goldstein minW_S jointwlth jstable ATOPallydum dist maj, robust c(ar 1) 
xtgee Goldstein minW jointwlth jstable ATOPallydum dist maj, robust c(ar 1) 
xtgee coopdum minW_S jointwlth jstable ATOPallydum dist maj, robust f(bin) l(logit) c(ar1)
xtgee coopdum minW jointwlth jstable ATOPallydum dist maj, robust f(bin) l(logit) c(ar1)








