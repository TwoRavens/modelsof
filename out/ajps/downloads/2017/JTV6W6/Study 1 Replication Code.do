clear all
set more off
set seed 77007

*set working directory to folder containing data files
use "Study 1 Replication Data.dta", clear


*disease treatments
gen HD = 0
gen HA = 0
recode HD 0=1 if (treat_rand1==3 | treat_rand1==4)
recode HA 0=1 if (treat_rand1==2 | treat_rand1==4)
gen trv_cond = treat_rand1

label variable trv_cond "Experimental Condition"
label define condl 1 "LA, LD" 2 "HA, LD" 3 "LA, HD" 4 "HA, HD"
label values trv_cond condl

label define hd 0 "Low Disgust" 1 "High Disgust"
label values HD hd

label define ha 0 "Low Anxiety" 1 "High Anxiety"
label values HA ha

*timer
gen Treattime = page_article_timing
recode Treattime 180/1000000=180

*disease emotions
rename Q11_1 disgusted
rename Q11_2 grossed
rename Q11_3 repulsed
rename Q11_4 afraid
rename Q11_5 anxious
rename Q11_6 worried
recode disgusted 8/9=.
recode grossed 8/9=.
recode repulsed 8/9=.
recode afraid 8/9=.
recode anxious 8/9=.
recode worried 8/9=.

*knowledge
gen knowsymp = Q12_1 /* fatigue */
recode knowsymp 1=1 2/9=0
gen knowspread = Q13
recode knowspread 2/9=0
gen knowcure = Q14
recode knowcure 1=0 2=1 3/9=0
gen knowsum = (knowsymp + knowspread + knowcure)

*knowledge of treatment-specific symptoms
gen knowldsymp1 = Q12_2 /* headaches */
gen knowhdsymp1 = Q12_3 /* diarrhea */
gen knowldsymp2 = Q12_4 /* joint pain */
gen knowhdsymp2 = Q12_5 /* boils */
recode knowldsymp1 1=1 2/9=0
recode knowldsymp2 1=1 2/9=0
recode knowhdsymp1 1=1 2/9=0
recode knowhdsymp2 1=1 2/9=0

*additive index of treatment-specific symptoms
gen knowldsymps = knowldsymp1 + knowldsymp2
replace knowldsymps=. if HD==1
gen knowhdsymps = knowhdsymp1 + knowhdsymp2
replace knowhdsymps=. if HD==0
egen knowtrtsymps = rowfirst(knowldsymps knowhdsymps)
gen knowtrtsymps2 = knowtrtsymps
recode knowtrtsymps2 0/1=0 2=1

*placebo symptoms
gen knowplacsymp1 = Q12_6
gen knowplacsymp2 = Q12_7
recode knowplacsymp1 1=1 2/9=0
recode knowplacsymp2 1=1 2/9=0
gen knowplacs = knowplacsymp1 + knowplacsymp2

*info search - request email info
gen search = Q15
recode search 2=0 8/9=.

*search details
gen search_countries = Q16_1
gen search_states = Q16_2
gen search_contract = Q16_3
gen search_who = Q16_4
gen search_deaths = Q16_5
gen search_cure = Q16_6
gen search_symptoms = Q16_7
recode search_countries 1=1 2/9=0
recode search_states  1=1 2/9=0
recode search_contract 1=1 2/9=0
recode search_who  1=1 2/9=0
recode search_deaths 1=1 2/9=0
recode search_cure  1=1 2/9=0
recode search_symptoms 1=1 2/9=0
gen searchcount = (search_countries + search_states + search_contract + search_who + search_deaths + search_cure + search_symptoms)
replace searchcount=. if search==.

*search likelihood
gen lookup = Q17_6
recode lookup 8/9=.
gen discuss = Q17_7
recode discuss 8/9=.
gen lookup4 = lookup - 1
gen discuss4 = discuss - 1


************
* analysis *
************

*suspicion of experimental treatment
tab suspicion
tab suspicion trv_cond, chi2 col

*table a1. factor structure of emotional responses
factor disgusted grossed repulsed afraid anxious worried, ml factors(2)
rotate, promax 
predict fdisgust fanxiety

*emotion reliability
alpha disgusted grossed repulsed
alpha afraid anxious worried

*manipulation checks
ttest fdisgust, by(HD)
ttest fanxiety, by(HD)

ttest fanxiety, by(HA)
ttest fdisgust, by(HA)


** Knowledge **

*H1 - knowledge of treatment symptoms
tab knowtrtsymps HD, col chi2

*H2 - knowledge of fatigue symptom
tab knowsymp HD, col chi2

*H2 - general disease knowledge
tab knowcure
tab knowspread
tab knowcure HD, col chi2
tab knowspread HD, col chi2

*Figure 1

*Anxiety and knowledge
tab knowsymp HA, col chi2
tab knowtrtsymps HA, col chi2
tab knowspread HA, col chi2
tab knowcure HA, col chi2

*Placebo symptoms
tab knowplacs HD, col chi2
tab knowplacs HA, col chi2

*table a2. 
ologit knowtrtsymps HD HA
logit knowsymp HD HA
logit knowcure HD HA
logit knowspread HD HA


** Info Search **

*email request - main effects
tab search
tab search HA, col chi2
tab search HD, col chi2

*amt of info requested - main effects
ttest searchcount, by(HA)
ttest searchcount, by(HD)

*self-reported search - main effects
ttest lookup4, by(HA)
ttest lookup4, by(HD)
ttest discuss4, by(HA)
ttest discuss4, by(HD)

*search - disgust among high anxiety conditions only
tab search HD if HA==1, col chi2
ttest searchcount if HA==1, by(HD)
ttest lookup4 if HA==1, by(HD)
ttest discuss4 if HA==1, by(HD)

*search - anxiety among low disgust conditions only
tab search HA if HD==0, col chi2
ttest searchcount if HD==0, by(HA)
ttest lookup4 if HD==0, by(HA)
ttest discuss4 if HD==0, by(HA)

*table a3.
logit search HD HA
logit search HD##HA
ologit searchcount HD HA
ologit searchcount HD##HA
ologit lookup4 HD HA
ologit lookup4 HD##HA
ologit discuss4 HD HA
ologit discuss4 HD##HA



** Figure 1 **

*treatment symptoms
gen ktmean=.
gen ktlo=.
gen kthi=.

proportion knowtrtsymps2 if HD==0
replace ktmean=.607 if HD==0
replace ktlo=.563 if HD==0
replace kthi=.649 if HD==0

proportion knowtrtsymps2 if HD==1
replace ktmean=.703 if HD==1
replace ktlo=.662 if HD==1
replace kthi=.742 if HD==1

*fatigue
gen kfmean=.
gen kflo=.
gen kfhi=.

proportion knowsymp if HD==0
replace kfmean=.780 if HD==0
replace kflo=.741 if HD==0
replace kfhi=.815 if HD==0

proportion knowsymp if HD==1
replace kfmean=.694 if HD==1
replace kflo=.652 if HD==1
replace kfhi=.732 if HD==1

*no cure
gen kcmean=.
gen kclo=.
gen kchi=.

proportion knowcure if HD==0
replace kcmean=.957 if HD==0
replace kclo=.935 if HD==0
replace kchi=.972 if HD==0

proportion knowcure if HD==1
replace kcmean=.951 if HD==1
replace kclo=.928 if HD==1
replace kchi=.967 if HD==1

*spread
gen ksmean=.
gen kslo=.
gen kshi=.

proportion knowspread if HD==0
replace ksmean=.788 if HD==0
replace kslo=.750 if HD==0
replace kshi=.822 if HD==0

proportion knowspread if HD==1
replace ksmean=.798 if HD==1
replace kslo=.760 if HD==1
replace kshi=.830 if HD==1

set scheme s1mono
graph twoway (scatter ktmean HD,  legend(off)) (rcap ktlo kthi HD, col(gs5) ylab(.5(.1)1) xsc(range(-.5 1.5)) xlab(0 "Low Disgust" 1 "High Disgust") xtitle("") subtitle("Treatment Symptoms") saving(EbolaS2_knowtrt.gph, replace))
graph twoway (scatter kfmean HD,  legend(off)) (rcap kflo kfhi HD, col(gs5) ylab(.5(.1)1) xsc(range(-.5 1.5)) xlab(0 "Low Disgust" 1 "High Disgust") xtitle("") subtitle("Fatigue") saving(EbolaS2_knowfatigue.gph, replace))
graph twoway (scatter kcmean HD,  legend(off)) (rcap kclo kchi HD, col(gs5) ylab(.5(.1)1) xsc(range(-.5 1.5)) xlab(0 "Low Disgust" 1 "High Disgust") xtitle("") subtitle("No Cure") saving(EbolaS2_knowcure.gph, replace))
graph twoway (scatter ksmean HD,  legend(off)) (rcap kslo kshi HD, col(gs5) ylab(.5(.1)1) xsc(range(-.5 1.5)) xlab(0 "Low Disgust" 1 "High Disgust") xtitle("") subtitle("Transmission Method") saving(EbolaS2_knowspread.gph, replace))
graph combine EbolaS2_knowtrt.gph EbolaS2_knowfatigue.gph EbolaS2_knowcure.gph EbolaS2_knowspread.gph, graphregion(color(white)) saving(Figure1.emf, replace)


** Figure 2 **

*Info Request Graph
gen lo =.
gen hi=.
replace lo=.171 if HA==0 & HD==0
replace lo=.291 if HA==1 & HD==0
replace lo=.222 if HA==0 & HD==1
replace lo=.198 if HA==1 & HD==1
replace hi=.281 if HA==0 & HD==0
replace hi=.406 if HA==1 & HD==0
replace hi=.332 if HA==0 & HD==1
replace hi=.306 if HA==1 & HD==1
gen searchmean=.
replace searchmean=.221 if HA==0 & HD==0
replace searchmean=.346 if HA==1 & HD==0
replace searchmean=.273  if HA==0 & HD==1
replace searchmean=.248  if HA==1 & HD==1

*Search Count Graph
gen clo=.
gen chi=.
gen cmean=.
mean searchcount if HA==0 & HD==0
replace cmean=1.15 if HA==0 & HD==0
replace clo=.835 if HA==0 & HD==0
replace chi=1.462 if HA==0 & HD==0 

mean searchcount if HA==1 & HD==0
replace cmean=1.68 if HA==1 & HD==0
replace clo=1.356 if HA==1 & HD==0
replace chi=1.997 if HA==1 & HD==0 

mean searchcount if HA==0 & HD==1
replace cmean=1.348 if HA==0 & HD==1
replace clo=1.040 if HA==0 & HD==1
replace chi=1.656 if HA==0 & HD==1 

mean searchcount if HA==1 & HD==1
replace cmean=1.348 if HA==1 & HD==1
replace clo=1.030 if HA==1 & HD==1
replace chi=1.666 if HA==1 & HD==1 

*Lookup Graph
gen llo=.
gen lhi=.
gen lmean=.
mean lookup4 if HA==0 & HD==0
replace lmean=1.448 if HA==0 & HD==0
replace llo=1.276 if HA==0 & HD==0
replace lhi=1.621 if HA==0 & HD==0 

mean lookup4 if HA==1 & HD==0
replace lmean=1.698 if HA==1 & HD==0
replace llo=1.542 if HA==1 & HD==0
replace lhi=1.855 if HA==1 & HD==0 

mean lookup4 if HA==0 & HD==1
replace lmean=1.588 if HA==0 & HD==1
replace llo=1.430 if HA==0 & HD==1
replace lhi=1.747 if HA==0 & HD==1 

mean lookup4 if HA==1 & HD==1
replace lmean=1.412 if HA==1 & HD==1
replace llo=1.251 if HA==1 & HD==1
replace lhi=1.573 if HA==1 & HD==1 

*Discuss Graph
gen dlo=.
gen dhi=.
gen dmean=.
mean discuss4 if HA==0 & HD==0
replace dmean=1.212 if HA==0 & HD==0
replace dlo=1.058 if HA==0 & HD==0
replace dhi=1.365 if HA==0 & HD==0 

mean discuss4 if HA==1 & HD==0
replace dmean=1.444 if HA==1 & HD==0
replace dlo=1.291 if HA==1 & HD==0
replace dhi=1.598 if HA==1 & HD==0 

mean discuss4 if HA==0 & HD==1
replace dmean=1.273 if HA==0 & HD==1
replace dlo=1.127 if HA==0 & HD==1
replace dhi=1.419 if HA==0 & HD==1 

mean discuss4 if HA==1 & HD==1
replace dmean=1.108 if HA==1 & HD==1
replace dlo=0.973 if HA==1 & HD==1
replace dhi=1.243 if HA==1 & HD==1 

graph twoway (scatter searchmean HD,  legend(off)) (rcap lo hi HD, col(gs5)), ///
 by(HA, legend(off) note("") noiy subtitle("Request Information")) ylab(0(.1).5, nogrid) xsc(range(-.4 1.4)) xlab(0 "Low Disgust" 1 "High Disgust") ///
 xtitle("") saving(EbolaS2_search.gph, replace)
graph twoway (scatter cmean HD,  legend(off)) (rcap clo chi HD, col(gs5)), ///
 by(HA, legend(off) note("") noiy subtitle("Amount of Information")) ylab(0(.5)2.5, nogrid) xsc(range(-.4 1.4)) xlab(0 "Low Disgust" 1 "High Disgust") ///
 xtitle("") saving(EbolaS2_count.gph, replace)
graph twoway (scatter lmean HD,  legend(off)) (rcap llo lhi HD, col(gs5)), ///
 by(HA, legend(off) note("") noiy subtitle("Self-Report: Look Up Information")) ylab(0(.5)2, nogrid) xsc(range(-.4 1.4)) xlab(0 "Low Disgust" 1 "High Disgust") ///
 xtitle("") saving(EbolaS2_lookup.gph, replace)
graph twoway (scatter dmean HD,  legend(off)) (rcap dlo dhi HD, col(gs5)), ///
 by(HA, legend(off) note("") noiy subtitle("Self-Report: Discuss Topic")) ylab(0(.5)2, nogrid) xsc(range(-.4 1.4)) xlab(0 "Low Disgust" 1 "High Disgust") ///
 xtitle("") saving(EbolaS2_discuss.gph, replace)
graph combine EbolaS2_search.gph EbolaS2_count.gph EbolaS2_lookup.gph EbolaS2_discuss.gph, graphregion(color(white)) imargin(1 1 1 1) saving(Figure2.emf, replace)
 
 
