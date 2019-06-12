/*Recreating the results for "The Political Relevance of Irrelevant Events"
Created by Ethan C. Busby
5-20-16

First load, the data (input the full file path)*/
use "...NCAA football championship data.dta", clear

*Analyses from the main paper
*Difference in before and after for OSU on the DVs
ttest papprove if osu==1, by(condition)
ttest collsat if osu==1, by(condition)

*Difference in before and after for Oregon on the DVs
ttest papprove if Oreg==1, by(condition)
ttest collsat if Oreg==1, by(condition)

*Statement about UO being more Democratic than OSU
tab pid osu, col

*Alphas of the emotion items
alpha elated enthus proud interested
alpha sad afraid angry hatred bitter contempt worried anxious resent
alpha afraid worried anxious
alpha sad angry hatred bitter contempt resent

*Compare this to the negative positive version
ttest pospan , by(condition), if osu==1
ttest negpan , by(condition), if osu==1
ttest pospan , by(condition), if Oreg==1
ttest negpan , by(condition), if Oreg==1

*Over time effects for presidential approval
bys condition: ttest papprove=T2PAPPROVE

*Analyses from the Appendix
*T2 response rates:
bys condition: count if T2PAPPROVE!=. | T2ECONSTAT!=. | T2COLLSAT!=.
tab condition
*Sample demographics
tab female
tab white
tab pid
mean(pid)
mean(income)
mean(age)
*Logits to assess balance
*Generate a variable for the condition that isn't a string
gen cond2=1 if condition=="POSTOREGON"
replace cond2=2 if condition=="POSTOSU"
replace cond2=3 if condition=="PREOREGON"
replace cond2=4 if condition=="PREOSU"
label define cond2 1 "POST UO" 2 "POST OSU" 3 "PRE UO" 4 "PRE OSU"
label values cond2 cond2
*The logit models, by school
logit Post i.female i.white i.pid i.income age if osu==1
logit Post i.female i.white i.pid i.income age if Oreg==1

*Difference in before and after for OSU on economic state
ttest econstat if osu==1, by(condition)

*Difference in before and after for Oregon on economic state
ttest econstat if Oreg==1, by(condition)

*Percentage of people who watched the championship game
tab wchamp osu, col

*Facebook posting; both methods give the same result
ttest post, by(condition), if osu==1
ttest post, by(condition), if Oreg==1
prtest post, by(cond2), if osu==1
prtest post, by(cond2), if Oreg==1

*Do the effects at T1 hold when we restrict the analysis to just those who respond
*In T2?
*Difference in before and after groups for OSU
ttest papprove if osu==1 & T2PAPPROVE!=. , by(condition)

*Difference in before and after groups for Oregon
ttest papprove if Oreg==1 & T2PAPPROVE!=., by(condition)

*If we use the T1 estimates for the whole sample, the effects over time are the same
*Presidential approval
*Pre OSU
ttesti 87 4.18 1.61 58 3.98 1.62
*Post OSU
ttesti 109 4.63 1.84 69 4.03 1.34
*Pre UO
ttesti 105 4.56 1.50 53 4.6 1.59
*Post UO
 ttesti 113 4.12 1.78 61 4.57 1.54

*Over time correlations
bys condition: pwcorr papprove T2PAPPROVE econstat T2ECON collsat T2COLL if osu==1
bys condition: pwcorr papprove T2PAPPROVE econstat T2ECON collsat T2COLL if Oreg==1

*Are they statistically different from one another?
prtesti  58 0.58 69 0.45 // OSU PAP
prtesti  53 0.50 61 0.38 //UO PAP
prtesti  58 0.46 69 0.38 // OSU ES
prtesti  55 0.53 61 0.37 //UO ES
prtesti  56 0.24 66 0.33 // OSU CS
prtesti  55 0.42 61  0.32 //UO CS

*Over time effects for college satisfaction
bys condition: ttest collsat=T2COLLSAT
*Do the effects at T1 hold when we restrict the analysis to just those who respond
*In T2?
*Difference in before and after groups for OSU on the three DVs
ttest collsat if osu==1 & T2COLL!=., by(condition)

*Difference in before and after groups for Oregon on the three DVs
ttest collsat if Oreg==1 & T2COLL!=., by(condition)

*If we use the T1 estimates for the whole sample, the effects over time are the same
*College satis.
*Pre OSU
ttesti 84 5.35 1.69 56 5.7 1.37
*Post OSU
ttesti 104 5.93 1.63 66 5.79 1.41
*Pre UO
ttesti 102 5.24 1.56 55 5.35 1.43
*Post UO
 ttesti 107 4.30 1.75 61 4.79 1.93

*For the state of the economy
bys condition: ttest econstat=T2ECONSTAT
*Do the effects at T1 hold when we restrict the analysis to just those who respond
*In T2?
*Difference in before and after groups for OSU
ttest econstat if osu==1 & T2ECON!=., by(condition)

*Difference in before and after groups for Oregon
ttest econstat if Oreg==1 & T2ECON!=., by(condition)

*If we use the T1 estimates for the whole sample, the effects over time are the same
*Economic state
*Pre OSU
ttesti 86 3.04 1.05 58 3.05 0.98
*Post OSU
ttesti 109 3.38 1.10 69 3.1 1.02
*Pre UO
ttesti 105 2.71 1.03 55 2.89 1.01
*Post UO
 ttesti 113 2.57 0.94 61 2.9 1.03

*Percent who watched the game by condition
tab wchamp condition, col

*Checking the games watched and attended
bys osu: summ gamesa
bys osu: summ gamesw
ttest gamesa if osu==1, by(condition)
ttest gamesw if osu==1, by(condition)
ttest gamesa if Oreg==1, by(condition)
ttest gamesw if Oreg==1, by(condition)

*What predicts T2 response rate?
gen t2=0
replace t2=1 if T2PAPPROVE!=. | T2ECONSTAT!=. |T2COLL!=.
tab t2 
logit t2 i.cond2 i.white i.female age income pid gamesa gamesw wchamp pospan negpan, or
*Let's change the baseline for clarity
logit t2 ib4.cond2 i.white i.female age income pid gamesa gamesw wchamp pospan negpan, or
margins, at(pid=(1(1)7)) atmeans
margins, at(cond2=(1(1)4)) atmeans
*Look at each school separately to see if that changes anything
logit t2 i.cond2 i.white i.female age income pid gamesa gamesw wchamp pospan negpan if Oreg==1, or
logit t2 i.cond2 i.white i.female age income pid gamesa gamesw wchamp pospan negpan if Oreg==0, or
*Thow some interactions in there for good measure
logit t2 ib4.cond2##c.pospan ib4.cond2##c.negpan i.white i.female age income pid gamesa gamesw wchamp, or
margins, dydx(negpan) at(cond2=(1(1)4)) atmeans
marginsplot
margins, dydx(pospan) at(cond2=(1(1)4)) atmeans
marginsplot
margins, dydx(cond2) at(pospan=(1(1)5)) atmeans
marginsplot
margins, dydx(cond2) at(negpan=(1(1)5)) atmeans
marginsplot
margins, dydx(pid) atmeans
margins, at(pid=(1(1)7)) atmeans


*Each variable at a time
replace t2=0
replace t2=1 if T2PAPPROVE!=.
tab t2 
logit t2 i.cond2 i.white i.female age income pid gamesa gamesw wchamp pospan negpan, or
*Let's change the baseline for clarity
logit t2 ib4.cond2 i.white i.female age income pid gamesa gamesw wchamp pospan negpan, or
margins, at(pid=(1(1)7)) atmeans
margins, at(cond2=(1(1)4)) atmeans
*Thow some interactions in there for good measure
logit t2 ib4.cond2##c.pospan ib4.cond2##c.negpan i.white i.female age income pid gamesa gamesw wchamp, or
margins, dydx(negpan) at(cond2=(1(1)4)) atmeans
marginsplot
margins, dydx(pospan) at(cond2=(1(1)4)) atmeans
marginsplot
margins, dydx(cond2) at(pospan=(1(1)5)) atmeans
marginsplot
margins, dydx(cond2) at(negpan=(1(1)5)) atmeans
marginsplot
margins, dydx(pid) atmeans
margins, at(pid=(1(1)7)) atmeans

replace t2=0
replace t2=1 if T2ECON!=.
tab t2 
logit t2 i.cond2 i.white i.female age income pid gamesa gamesw wchamp pospan negpan, or
*Let's change the baseline for clarity
logit t2 ib4.cond2 i.white i.female age income pid gamesa gamesw wchamp pospan negpan, or
margins, at(pid=(1(1)7)) atmeans
margins, at(cond2=(1(1)4)) atmeans
*Thow some interactions in there for good measure
logit t2 ib4.cond2##c.pospan ib4.cond2##c.negpan i.white i.female age income pid gamesa gamesw wchamp, or
margins, dydx(negpan) at(cond2=(1(1)4)) atmeans
marginsplot
margins, dydx(pospan) at(cond2=(1(1)4)) atmeans
marginsplot
margins, dydx(cond2) at(pospan=(1(1)5)) atmeans
marginsplot
margins, dydx(cond2) at(negpan=(1(1)5)) atmeans
marginsplot
margins, dydx(pid) atmeans
margins, at(pid=(1(1)7)) atmeans

replace t2=0
replace t2=1 if T2COLL!=.
tab t2 
logit t2 i.cond2 i.white i.female age income pid gamesa gamesw wchamp pospan negpan, or
*Let's change the baseline for clarity
logit t2 ib4.cond2 i.white i.female age income pid gamesa gamesw wchamp pospan negpan, or
margins, at(pid=(1(1)7)) atmeans
margins, at(cond2=(1(1)4)) atmeans
*Thow some interactions in there for good measure
logit t2 ib4.cond2##c.pospan ib4.cond2##c.negpan i.white i.female age income pid gamesa gamesw wchamp, or
margins, dydx(negpan) at(cond2=(1(1)4)) atmeans
marginsplot
margins, dydx(pospan) at(cond2=(1(1)4)) atmeans
marginsplot
margins, dydx(cond2) at(pospan=(1(1)5)) atmeans
marginsplot
margins, dydx(cond2) at(negpan=(1(1)5)) atmeans
marginsplot
margins, dydx(pid) atmeans
margins, at(pid=(1(1)7)) atmeans

***Checking the overtime results with multiple imputation***
*Let's tweak the format around a bit so that we can use the estimation commands
*in mi (we can't do ttests in that format, but we can do regression)

*Generate the IDs
gen id=_n

*Time 2 indicator
gen time=1
replace time=2 if T2PAPPROVE!=. | T2ECONSTAT!=. |T2COLL!=.
tab time 

*Difference variables
gen diff_pap=papprove-T2PAPPROVE
gen diff_econ=econstat-T2ECON
gen diff_coll=collsat-T2COLL

*Test it to see if it produces similar results to the ttests
mean diff_pap, over(cond2) level(90)
mean diff_econ, over(cond2) level(90)
mean diff_coll, over(cond2) level(90)

*The significance is the same as the ttest

*Now for the imputation
*First set the data
mi set w
*This is a simpler imputation process that recovers about 130 observatiosn
*It leaves about 30-40 missing due to patterns of missing on the IVs
*The second imputation command does the more complex imputation, which takes more
*computing power and time. Results are similar across both.

mi register imputed diff_pap diff_econ diff_coll
mi register regular condition cond2 Pre Post osu Oreg PreOSU PostOSU PreOreg PostOreg papprove econstat collsat elated enthus proud interested sad afraid angry hatred bitter contempt worried anxious resent pospan negpan post age income female white AFR_AM AS_AM hispanic NAT_AM other pid gamesa gamesw wchamp id
mi impute chained (regress) diff_pap diff_econ diff_coll = cond2 papprove econstat collsat pospan negpan post age income female white pid gamesa gamesw wchamp, rseed(9999) add(200) force replace
*Get the means with 98 and 90 % C.I.--this is to match the p=0.05 and p=0.01 levels in the graphs
*We're looking for how the estimate of the diff is or isn't different from 0
mi estimate, level(98): mean diff_pap, over(cond2)
mi estimate, level(90): mean diff_pap, over(cond2)
mi estimate, level(98): mean diff_econ, over(cond2)
mi estimate, level(90): mean diff_econ, over(cond2)
mi estimate, level(98): mean diff_coll, over(cond2)
mi estimate, level(90): mean diff_coll, over(cond2)

*Impute ALL of the missing variables on all variables. 
*(takes more time and computing power)
mi unregister diff_pap diff_econ diff_coll cond2 papprove econstat collsat pospan negpan post age income female white pid gamesa gamesw wchamp
mi register imputed diff_pap diff_econ diff_coll papprove econstat collsat pospan negpan post age income female white pid gamesa gamesw wchamp
mi register regular cond2
mi impute chained (regress) diff_pap diff_econ diff_coll papprove econstat collsat pospan negpan age income pid gamesa gamesw (logit) post female white wchamp  = i.cond2 , rseed(9999) add(200) 

*Get the means with 98 and 90 % C.I.--this is to match the p=0.05 and p=0.01 levels in the graphs
*We're looking for how the estimate of the diff is or isn't different from 0
mi estimate, level(98): mean diff_pap, over(cond2)
mi estimate, level(90): mean diff_pap, over(cond2)
mi estimate, level(98): mean diff_econ, over(cond2)
mi estimate, level(90): mean diff_econ, over(cond2)
mi estimate, level(98): mean diff_coll, over(cond2)
mi estimate, level(90): mean diff_coll, over(cond2)

*Impute ALL of the missing variables on all variables AND does it separately for 
*each school (takes more time and computing power)
* mi unregister diff_pap diff_econ diff_coll cond2 papprove econstat collsat pospan negpan post age income female white pid gamesa gamesw wchamp
mi register imputed diff_pap diff_econ diff_coll papprove econstat collsat pospan negpan post age income female white pid gamesa gamesw wchamp
mi register regular cond2
mi impute chained (regress) diff_pap diff_econ diff_coll papprove econstat collsat pospan negpan age income pid gamesa gamesw (logit) post female white wchamp  = i.cond2 , rseed(9999) add(190) replace by(osu)

*Get the means with 98 and 90 % C.I.--this is to match the p=0.05 and p=0.01 levels in the graphs
*We're looking for how the estimate of the diff is or isn't different from 0
mi estimate, level(98): mean diff_pap, over(cond2)
mi estimate, level(90): mean diff_pap, over(cond2)
mi estimate, level(98): mean diff_econ, over(cond2)
mi estimate, level(90): mean diff_econ, over(cond2)
mi estimate, level(98): mean diff_coll, over(cond2)
mi estimate, level(90): mean diff_coll, over(cond2)

*Looking at how the results hold up only among those who watched the game
*Difference in before and after groups for OSU on the three DVs
ttest papprove if osu==1 & wchamp==1, by(condition)
ttest econstat if osu==1 & wchamp==1, by(condition)
ttest collsat if osu==1 & wchamp==1, by(condition)

*Difference in before and after groups for Oregon on the three DVs
ttest papprove if Oreg==1 & wchamp==1, by(condition)
ttest econstat if Oreg==1 & wchamp==1, by(condition)
ttest collsat if Oreg==1 & wchamp==1, by(condition)

*Emotions
ttest pospan , by(condition), if osu==1 & wchamp==1
ttest negpan , by(condition), if osu==1 & wchamp==1
ttest pospan , by(condition), if Oreg==1 & wchamp==1
ttest negpan , by(condition), if Oreg==1 & wchamp==1

*Posting on Facebook
ttest post, by(condition), if osu==1 & wchamp==1
ttest post, by(condition), if Oreg==1 & wchamp==1

*Over time effects
bys condition: ttest papprove=T2PAPPROVE if wchamp==1
bys condition: ttest econstat=T2ECONSTAT if wchamp==1
bys condition: ttest collsat=T2COLLSAT if wchamp==1
