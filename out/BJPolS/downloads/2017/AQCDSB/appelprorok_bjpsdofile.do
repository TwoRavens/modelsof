
use bjpsdata


*main paper
*table 1 results
reg lnnoncom  allf tradef   attritdum coindum waraims2 ln_duration finalprop lnnewpop ghdumr77 demdum ln_milfat ad_demdum mpra mprt plzdistdum lntrade euromix, cluster(warnumber)

set more off
*supplement
*table s1
*european identity 
reg lnnoncom eura eurt attritdum coindum waraims2 ln_duration finalprop lnnewpop ghdumr77 demdum ln_milfat ad_demdum mpra mprt plzdistdum lntrade euromix, cluster(warnumber)


*human rights
reg lnnoncom hrightsa  hrightst attritdum coindum waraims2 ln_duration finalprop lnnewpop ghdumr77 demdum ln_milfat ad_demdum mpra mprt plzdistdum lntrade euromix ljiaverage if year>1946, cluster(warnumber)



*table s2
*homophily
reg lnnoncom  allf tradef   attritdum coindum waraims2 ln_duration finalprop lnnewpop ghdumr77 demdum ln_milfat ad_demdum mpra mprt plzdistdum lntrade euromix  rdemmodet rdemmodea, cluster(warnumber)


reg lnnoncom  allf tradef  attritdum coindum waraims2 ln_duration finalprop lnnewpop ghdumr77 demdum ln_milfat ad_demdum mpra mprt plzdistdum lntrade euromix  fazalmodea fazalmodet, cluster(warnumber)


reg lnnoncom  allf tradef  attritdum coindum waraims2 ln_duration finalprop lnnewpop ghdumr77 demdum ln_milfat ad_demdum mpra mprt plzdistdum lntrade euromix  rleghoma rleghomt, cluster(warnumber)


*table s3

*dropped major power ratifier 
reg lnnoncom allf tradef attritdum coindum waraims2 ln_duration finalprop lnnewpop ghdumr77 demdum ln_milfat ad_demdum mpra plzdistdum lntrade euromix if mprt==0 | mpra==0, cluster(warnumber)

*high fatalities wars
reg lnnoncom  allf tradef attritdum coindum waraims2 ln_duration finalprop lnnewpop ghdumr77 demdum ad_demdum mpra mprt plzdistdum lntrade euromix if milfat>= 50000, cluster(warnumber)

*DV=actors
logit actors lnnoncom  allf tradef   attritdum coindum waraims2 ln_duration finalprop lnnewpop ghdumr77 demdum ad_demdum mpra mprt plzdistdum lntrade euromix, cluster(warnumber)

*DV=duration
reg ln_duration allf tradef   attritdum coindum waraims2  finalprop lnnewpop ghdumr77 ln_milfat lnnoncom  demdum ad_demdum mpra mprt plzdistdum lntrade euromix, cluster(warnumber)

*alterntaive measure of major powers.
reg lnnoncom  allf tradef   attritdum coindum waraims2 ln_duration finalprop lnnewpop ghdumr77 demdum ln_milfat ad_demdum mpa mpt plzdistdum lntrade euromix, cluster(warnumber)


*table s4
*interaction terms

*network X treaty status 
reg lnnoncom c.allf##ghdumr77 c.tradef##ghdumr77  attritdum coindum waraims2 ln_duration finalprop lnnewpop demdum ln_milfat ad_demdum mpra mprt plzdistdum lntrade euromix, cluster(warnumber)

*finalprop X network variables 
reg lnnoncom  c.allf##c.finalprop c.tradef##c.finalprop   attritdum coindum waraims2 ln_duration finalprop lnnewpop ghdumr77 demdum ln_milfat ad_demdum mpra mprt plzdistdum lntrade euromix, cluster(warnumber)

*table s5

*drop wars with coalitions
reg lnnoncom  allf tradef   attritdum coindum waraims2 ln_duration finalprop lnnewpop ghdumr77 demdum ln_milfat ad_demdum mpra mprt plzdistdum lntrade euromix if actors==0, cluster(warnumber)

*control for wars with multiple actors
reg lnnoncom  allf tradef   attritdum coindum waraims2 ln_duration finalprop lnnewpop ghdumr77 demdum ln_milfat ad_demdum mpra mprt plzdistdum lntrade euromix actors, cluster(warnumber)

*correlated coalitins (randomly drop one side)
reg lnnoncom  allf tradef   attritdum coindum waraims2 ln_duration finalprop lnnewpop ghdumr77 demdum ln_milfat ad_demdum mpra mprt plzdistdum lntrade euromix if drop==1, cluster(warnumber)

*occupation cases 
reg lnnoncom  allf tradef  attritdum coindum waraims2 ln_duration finalprop lnnewpop ghdumr77 demdum ln_milfat ad_demdum mpra mprt plzdistdum lntrade euromix if occupation==0, cluster(warnumber)


*table s6

*added us and post45
reg lnnoncom  allf tradef  attritdum coindum waraims2 ln_duration finalprop lnnewpop ghdumr77 demdum ln_milfat ad_demdum mpra mprt plzdistdum lntrade euromix p45 us, cluster(warnumber)

*Adversary controls 
reg lnnoncom  allf tradef   attritdum coindum waraims2 ln_duration finalprop lnnewpop ghdumr77 demdum ln_milfat ad_demdum mpra mprt plzdistdum lntrade euromix coino attrito adwaraims, cluster(warnumber)

*strategic only variables
reg lnnoncom allf tradef attritdum coindum waraims2 ln_duration finalprop lnnewpop mpra mprt ln_milfat, cluster(warnumber)

*dropped strategic controls
reg lnnoncom  allf tradef  finalprop lnnewpop ghdumr77 demdum ln_milfat ad_demdum mpra mprt plzdistdum lntrade euromix, cluster(warnumber)

*adversary major power ratifier
reg lnnoncom  allf tradef   attritdum coindum waraims2 ln_duration finalprop lnnewpop ghdumr77 demdum ln_milfat ad_demdum mpra mprt adv_mpra adv_mprt plzdistdum lntrade euromix, cluster(warnumber)



*table s7 
*new dv
oprobit cat4 allf tradef   attritdum coindum waraims2 ln_duration finalprop lnnewpop ghdumr77 demdum ln_milfat ad_demdum mpra mprt plzdistdum lntrade euromix, cluster(warnumber)

*out of network states
reg lnnoncom allf tradef   attritdum coindum waraims2 ln_duration finalprop lnnewpop ghdumr77 demdum ln_milfat ad_demdum mpra mprt plzdistdum lntrade euromix allyfu10 tradefu10, cluster(warnumber)



*secondary set of results

*trade

use tradebjps



*table s8
*nonratifiers
reg lnttrade lnnoncom5 lndistance cincratio  jointdem majmin majmaj win1 win2 tpop1 tpop2 gdpest gdpest2 if treaty2==0 & year>1902, cluster(dyadid)

*ratifiers
reg lnttrade lnnoncom5 lndistance cincratio  jointdem majmin majmaj win1 win2 tpop1 tpop2 gdpest gdpest2 if treaty2==1 & year>1902, cluster(dyadid)


*table s9
*wto
*nonratifiers
reg lnttrade lnnoncom5 lndistance cincratio  jointdem majmin majmaj win1 win2 tpop1 tpop2 gdpest gdpest2 wto2a wto2b if treaty2==0 & year>1949, cluster(dyadid)

*ratifiers
reg lnttrade lnnoncom5 lndistance cincratio  jointdem majmin majmaj win1 win2 tpop1 tpop2 gdpest gdpest2 wto2a wto2b if treaty2==1 & year>1949, cluster(dyadid)


*table s11
*nonratifiers
reg lnttrade c.lnnoncom5##i.treaty1 lndistance cincratio  jointdem majmin majmaj win1 win2 tpop1 tpop2 gdpest gdpest2 if treaty2==0 & year>1902, cluster(dyadid)

*ratifiers
reg lnttrade c.lnnoncom5##i.treaty1 lndistance cincratio  jointdem majmin majmaj win1 win2 tpop1 tpop2 gdpest gdpest2 if treaty2==1 & year>1902, cluster(dyadid)



*alliance
use allbjps

*table s10
*nonratifiers
probit fail lnnoncom5 lndistance cincratio  jointdem majmin majmaj win1 win2 tpop1 tpop2 n n2 n3 gdpest gdpest2 if treaty2==0 & year>1902, cluster(dyadid)

*ratifiers
probit fail lnnoncom5 lndistance cincratio  jointdem majmin majmaj win1 win2 tpop1 tpop2 n n2 n3 gdpest gdpest2 if treaty2==1 & year>1902, cluster(dyadid)

*interaction term

*table s12
*nonratifiers
probit fail c.lnnoncom5##i.treaty1 lndistance cincratio  jointdem majmin majmaj win1 win2 tpop1 tpop2 n n2 n3 gdpest gdpest2 if treaty2==0 & year>1902, cluster(dyadid)


*ratifiers
probit fail c.lnnoncom5##i.treaty1 lndistance cincratio jointdem majmin majmaj win1 win2 tpop1 tpop2 n n2 n3 gdpest gdpest2 if treaty2==1 & year>1902, cluster(dyadid)


