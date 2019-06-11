*/ Setup */

capture log close
clear all
set linesize 120
macro drop _all
set more off
set scheme s2color

*/ Change directory and start log file */

cd [INSERT DIRECTORY PATH HERE]

log using "martensclausepaper.log", replace

*/ Experiment #1 */

*/ Create weights */

run AgePartisanshipWeightCreationExp1.do

*/ Load dataset */

insheet using experiment1.csv, comma

*/ ID variable */
gen ID= _n
label variable ID `"Observation ID Number"'

*/ Partisanship */
table q6
gen democrat=0
replace democrat=1 if q6==1
gen republican=0
replace republican=1 if q6==2
gen independentbig=0
replace independentbig=1 if q6==3
gen strongdem=0
replace strongdem=1 if q7==1
gen stronggop=0
replace stronggop=1 if q8==1
gen independentsmall=0
replace independentsmall=1 if q9==3
gen democratbig=democrat
replace democratbig=1 if q9==1
gen republicanbig=republican
replace republicanbig=1 if q9==2
gen partisanship=.
replace partisanship=0 if democrat==1
replace partisanship=1 if republican==1
replace partisanship=2 if independentbig==1
gen partleaners=.
replace partleaners=0 if democratbig==1
replace partleaners=1 if republicanbig==1
replace partleaners=2 if independentsmall==1

label variable democrat `"Democrat: 1 = Yes 0 = No"'
label variable republican `"Republican: 1 = Yes 0 = No"'
label variable independentbig `"Independent (Big): 1 = Yes 0 = No"'
label variable independentsmall `"Independent (Small): 1 = Yes 0 = No"'
label variable strongdem `"Strong Democrat: 1 = Yes 0 = No"'
label variable stronggop `"Strong Republican: 1 = Yes 0 = No"'
label variable democratbig `"Democrat (Incl Leaners): 1 = Yes 0 = No"'
label variable republicanbig `"Republican (Incl Leaners): 1 = Yes 0 = No"'
label variable partisanship `"No Leaners: 0 = Dem, 1 = GOP, 2 = Indep"'
label variable partleaners `"Includes Leaners: 0 = Dem, 1 = GOP, 2 = Indep"'
label define partisanship 0 "Democrat" 1 "Republican" 2 "Independent"
label values partisanship partisanship
label values partleaners partisanship 

*/ Hawkishness */
rename q20 hawkdove
label variable hawkdove `"Foreign Policy Hawkishness"'

*/ Condition Dummies */
gen baselinedummy=0
replace baselinedummy=1 if baseline !=.
label variable baselinedummy `"Baseline Condition: 1 = Yes 0 = No"'
label variable baseline `"Support: Baseline Condition"'

gen defeffective=0
replace defeffective=1 if dnec!=.
label variable defeffective `"D + More Effective Condition: 1 = Yes 0 = No"'
label variable dnec `"Support: D + More Effective Condition"'

gen offeffective=0
replace offeffective=1 if onec!=.
label variable offeffective `"O + More Effective Condition: 1 = Yes 0 = No"'
label variable onec `"Support: O + More Effective Condition"'

gen defnoteffective=0
replace defnoteffective=1 if dnotnec!=.
label variable defnoteffective `"D + Not More Effective Condition: 1 = Yes 0 = No"'
label variable dnotnec `"Support: D + Not More Effective Condition"'

gen offnoteffective=0
replace offnoteffective=1 if onotnec!=.
label variable offnoteffective `"O + Not More Effective Condition: 1 = Yes 0 = No"'
label variable onotnec `"Support: O + Not More Effective Condition"'

gen moreeffective=0
replace moreeffective=1 if (defeffective==1 | offeffective==1)
label variable moreeffective `"Condition: AWS More Effective"'

gen defense=0
replace defense=1 if (defeffective==1 | defnoteffective==1)
label variable defense `"Condition: AWS Defensive"'

gen offense=0
replace offense=1 if (offeffective==1 | offnoteffective==1)
label variable offense `"Condition: AWS Offensive"'

*/ DV */
gen support=.
replace support=baseline if baseline!=.
replace support=dnec if dnec!=.
replace support=onec if onec!=.
replace support=dnotnec if dnotnec!=.
replace support=onotnec if onotnec!=.

label variable support `"Support use of force"'
label define support 1 "Strongly Support" 2 "Support" 3 "Neither Support Nor Oppose" 4 "Oppose" 5 "Strongly Oppose"
label values support support

gen supportbinary=0
replace supportbinary=1 if (support==1 | support ==2)
label variable supportbinary `"Support use of force: 1 = Yes 0 = No"'
replace supportbinary=. if support==.

gen opposebinary=0
replace opposebinary=1 if (support==4 | support==5)
label variable opposebinary `"Oppose use of force: 1 = Yes 0 = No"'
replace opposebinary=. if oppose==.

*/ Other IVs */
gen military=0
replace military=1 if q42==1
label variable military `"Military Service: 1 = Yes 0 = No"'

gen male=0
replace male=1 if q46==1
label variable male `"Male: 1 = Yes 0 = No"'

rename q52 age
gen age2=.
replace age2=1 if age==1
replace age2=1 if age==2
replace age2=2 if age==3
replace age2=3 if age==4
replace age2=4 if age==5
replace age2=5 if age==6
replace age2=6 if age==7
label variable age `"Age"'
label variable age2 `"Age"'
label define age 1 "18-19" 2 "20-29" 3 "30-39" 4 "40-49" 5 "50-59" 6 "60-69" 7 "Older than 69"
label values age age
label define age2 1 "18-29" 2 "30-39" 3 "40-49" 4 "50-59" 5 "60-69" 6 "Older than 69"
label values age2 age2

rename q54 education
label variable education `"Education"'

*/ Other robotic/drones variables */
gen robotusagebinary=0
replace robotusagebinary=1 if (usage==1 | usage==2 | usage==3)
replace robotusagebinary=. if usage==.
label variable robotusagebinary `"Robot Usage: 1 = Yes, 0 = No"'
rename usage robotusage
label variable robotusage `"General Robot Usage"'
label define robotusage 1 "Yes, at home" 2 "Yes, at work" 3 "Yes, at home and at work" 4 "No" 5 "Don't know"
label values robotusage robotusage

gen robotviewsbinary=0
replace robotviewsbinary=1 if (views==1 | views==2)
replace robotviewsbinary=. if views==.
label variable robotviews `"Positive Robot Views: 1 = Yes 0 = No"'
rename views robotviews
label variable robotviews `"General Robot Views"'
label define robotviews 1 "Very positive" 2 "Somewhat positive" 3 "Neither positive nor negative" 4 "Somewhat negative" 5 "Very negative"
label values robotviews robotviews

replace awsnow=0 if awsnow==2
label variable awsnow `"Thinks US has AWS now: 1 = Yes 0 = No"'

replace awsdrones=0 if awsdrones==2
replace awsdrones=1 if awsdrones==3
label variable awsdrones `"Knows AWS is not a drone: 1 = Yes 0 = No"'

gen awsinfo=0
replace awsinfo=1 if (awsnow==0 | awsdrones==1)
replace awsinfo=2 if (awsnow==0 & awsdrones==1)
label variable awsinfo `"Informed about US AWS in SQ: 2 = Yes, 1 = Partial, 0 = No"'

rename drones dronestrikes
label variable dronestrikes `"View of US drone strikes, 1=Strongly approve to 5=Strongly disapprove"'

gen dronestrikesbinary=0
replace dronestrikesbinary=1 if (dronestrikes==1 | dronestrikes==2)
label variable dronestrikesbinary `"Supports US drone strikes: 1 = Yes 0 = No"'

gen oppose=.
replace oppose=1 if ((support==4 & defeffective==1) | (support==5 & defeffective==1))
replace oppose=0 if ((support==3 & defeffective==1) | (support==2 & defeffective==1) |  (support==1 & defeffective==1))
label variable oppose "Opposes Developing AWS Even When Defensive + More Effective: 1 = Yes, 0 = No"

*/ Save dataset */
save Experiment1.dta, replace

*/ Figure 1 - actual figure created in Excel */
table support, by(baselinedummy)
table support, by(dnec)
table support, by(dnotnec)
table support, by(onec)
table support, by(onotnec)

*/ Figure 2 */
estimates clear
regress support i.moreeffective i.defense baselinedummy military age republican male hawkdove, robust
eststo m1: margins moreeffective#defense, at( (means) _all baselinedummy=0) post
regress support i.moreeffective i.defense baselinedummy military age republican male hawkdove if (awsinfo==2), robust
eststo m2: margins moreeffective#defense, at( (means) _all baselinedummy=0) post

coefplot m1 m2, drop(_cons) graphregion(color(white) lcolor(white) ilcolor(white)) plotlabels("All Respondents" "Informed Respondents") plotregion(fcolor(white) lcolor(white) ilcolor(white)) xtitle(Predicted Public Support) xscale(titleg(3)) ylabel(, nogrid) grid(n) coeflabel(, wrap(25))
graph save Figure2.gph, replace

*/ Appendix */

*/ Summary statistics */
estimates clear
tabstat support moreeffective defense military age republican male hawkdove robotviewsbinary robotusagebinary dronestrikesbinary awsinfo awsdrones awsnow, stats(n min mean max) columns(s)
estpost summ support moreeffective defense military age republican male hawkdove robotviewsbinary robotusagebinary dronestrikesbinary awsinfo awsdrones awsnow
esttab using AppendixTable1.rtf, replace t(3) cells("mean(fmt(3)) sd min max") nomtitle nonumber label

estimates clear
table partisanship
estpost tabulate partisanship
esttab using AppendixTable2.rtf, replace

estimates clear
table age2
estpost tabulate age2
esttab using AppendixTable3.rtf, replace

*/ Initial regression table: full + only informed */
estimates clear
regress support i.moreeffective i.defense baselinedummy military age republican male hawkdove, robust
estimates store m1
regress support i.moreeffective i.defense baselinedummy military age republican male hawkdove if (awsinfo==2), robust
estimates store m2
coefplot m1 m2, drop(_cons) xline(0) graphregion(color(white) lcolor(white) ilcolor(white)) plotlabels("All Respondents" "Informed Respondents") plotregion(fcolor(white) lcolor(white) ilcolor(white)) xtitle(OLS Regression Coefficients) xscale(titleg(3)) ylabel(, nogrid) grid(n) coeflabel(, wrap(25))
graph save AppendixFigure1.gph, replace

*/ Simple stats table of Figure 2 to create Appendix Figure 2 */
table support if baselinedummy==1 & awsinfo==2
table support if defeffective==1 & awsinfo==2
table support if defnoteffective==1 & awsinfo==2
table support if offeffective==1 & awsinfo==2
table support if offnoteffective==1 & awsinfo==2

*/ Robustness regression table */

estimates clear
regress support moreeffective defense military age republican male hawkdove, robust

estimates store m1

regress support moreeffective defense military age republican male hawkdove robotusagebinary, robust

estimates store m2

regress support moreeffective defense military age republican male hawkdove robotusagebinary dronestrikesbinary awsdrones awsnow, robust

estimates store m3

*/ Merge Weights */

mmerge partleaners using partisanship_dat.dta
mmerge age using age_dat.dta
gen old_wt2=1
survwgt rake old_wt2, by(partleaners) totvars(partisanship_tot) generate(part_wt)
gen old_wt3=1
survwgt rake old_wt3, by(age) totvars(age_tot) generate(age_wt)

regress support moreeffective defense military age republican male hawkdove robotusagebinary dronestrikesbinary awsdrones awsnow [pweight=age_wt], robust

estimates store m4

regress support moreeffective defense military age republican male hawkdove robotusagebinary dronestrikesbinary awsdrones awsnow [pweight=part_wt], robust

estimates store m5

esttab m1 m2 m3 m4 m5 using AppendixTable5.rtf, replace onecell se r2 t(3) scalars(ll) legend label collabels(none) varlabels(_cons Constant) star(* 0.10 ** 0.05 *** 0.01)

estimates clear

*/ Opposes AWS even in favorable condition */
estimates clear
logit oppose military age republican male hawkdove dronestrikesbinary awsdrones awsnow, robust
estimates store m1
esttab m1 using AppendixTable6.rtf, replace onecell se r2 t(3) scalars(ll) legend label collabels(none) varlabels(_cons Constant) star(* 0.10 ** 0.05 *** 0.01)

*/ Reduce to final dataset */
keep moreeffective defense oppose dnec dnotnec onec onotnec offeffective offnoteffective defeffective defnoteffective ID hawkdove age education robotusage robotviews awsinfo dronestrikes democrat republican independentbig strongdem stronggop independentsmall democratbig republicanbig partisanship partleaners support supportbinary opposebinary military male robotusagebinary robotviewsbinary dronestrikesbinary part_wt age_wt awsinfo awsdrones awsnow baseline baselinedummy 

order ID
order hawkdove, after(age)
order baselinedummy defeffective offeffective defnoteffective offnoteffective support supportbinary opposebinary moreeffective defense, after(dnotnec)
save Experiment1.dta, replace

estimates clear
clear

*/ Experiment #2 */

*/ Create weights */

run AgePartisanshipWeightCreationExp2.do

*/ Load dataset */
insheet using experiment2.csv, comma

*/ ID variable */
gen ID= _n
label variable ID `"Observation ID Number"'

*/ Partisanship */
table q6
gen democrat=0
replace democrat=1 if q6==1
gen republican=0
replace republican=1 if q6==2
gen independentbig=0
replace independentbig=1 if q6==3
gen strongdem=0
replace strongdem=1 if q7==1
gen stronggop=0
replace stronggop=1 if q8==1
gen independentsmall=0
replace independentsmall=1 if q9==3
gen democratbig=democrat
replace democratbig=1 if q9==1
gen republicanbig=republican
replace republicanbig=1 if q9==2
gen partisanship=.
replace partisanship=0 if democrat==1
replace partisanship=1 if republican==1
replace partisanship=2 if independentbig==1
gen partleaners=.
replace partleaners=0 if democratbig==1
replace partleaners=1 if republicanbig==1
replace partleaners=2 if independentsmall==1

label variable democrat `"Democrat: 1 = Yes 0 = No"'
label variable republican `"Republican: 1 = Yes 0 = No"'
label variable independentbig `"Independent (Big): 1 = Yes 0 = No"'
label variable independentsmall `"Independent (Small): 1 = Yes 0 = No"'
label variable strongdem `"Strong Democrat: 1 = Yes 0 = No"'
label variable stronggop `"Strong Republican: 1 = Yes 0 = No"'
label variable democratbig `"Democrat (Incl Leaners): 1 = Yes 0 = No"'
label variable republicanbig `"Republican (Incl Leaners): 1 = Yes 0 = No"'
label variable partisanship `"No leaners: 0 = Dem, 1 = GOP, 2 = Indep"'
label variable partleaners `"Includes leaners: 0 = Dem, 1 = GOP, 2 = Indep"'
label define partisanship 0 "Democrat" 1 "Republican" 2 "Independent"
label values partisanship partisanship
label values partleaners partisanship 

*/ Hawkishness */
rename q20 hawkdove
label variable hawkdove `"Foreign Policy Hawkishness"'

*/ Condition Dummies */
rename q38 baselinecondition
gen baselinedummy=0
replace baselinedummy=1 if baselinecondition !=.
label variable baselinecondition `"Support: Baseline Condition"'
label variable baselinedummy `"Baseline Condition: 1 = Yes 0 = No"'

rename q161 milneccondition
gen milnecdummy=0
replace milnecdummy=1 if milneccondition !=.
label variable milneccondition `"Support: Mil Necessity Condition"'
label variable milnecdummy `"Mil Necessity Condition: 1 = Yes 0 = No"'

rename q162 foreigndevcondition
gen foreigndevdummy=0
replace foreigndevdummy=1 if foreigndevcondition !=.
label variable foreigndevcondition `"Support: Foreign Development Condition"'
label variable foreigndevdummy `"Foreign Development Dummy: 1 = Yes 0 = No"'

rename q163 notneccondition
gen notnecdummy=0
replace notnecdummy=1 if notneccondition !=.
label variable notneccondition `"Support: Not Necessity Condition"'
label variable notnecdummy `"Not Necessity Condition: 1 = Yes 0 = No"'

*/ DV */
gen support=.
replace support=baselinecondition if baselinecondition!=.
replace support=milneccondition if milneccondition!=.
replace support=foreigndevcondition if foreigndevcondition!=.
replace support=notneccondition if notneccondition!=.
label variable support `"Support development of AWS"'
label define support 1 "Strongly Support" 2 "Support" 3 "Neither Support Nor Oppose" 4 "Oppose" 5 "Strongly Oppose"
label values support support

gen supportbinary=0
replace supportbinary=1 if (support==1 | support ==2)
label variable supportbinary `"Support AWS: 1 = Yes 0 = No"'
replace supportbinary=. if support==.

gen opposebinary=0
replace opposebinary=1 if (support==4 | support==5)
label variable opposebinary `"Oppose AWS: 1 = Yes 0 = No"'
replace opposebinary=. if oppose==.

*/ Other IVs */
gen military=0
replace military=1 if q42==1
label variable military `"Military Service: 1 = Yes 0 = No"'
gen combat=0
replace combat=1 if q58==1
label variable combat `"Combat: 1 = Yes 0 = No"'

gen male=0
replace male=1 if q46==1
label variable male `"Male: 1 = Yes 0 = No"'

rename q52 age
label variable age `"Age"'
label define age 1 "18-19" 2 "20-29" 3 "30-39" 4 "40-49" 5 "50-59" 6 "60-69" 7 "Older than 69"
label values age age

rename q54 education
label variable education `"Education"'

*/ Other robotic/drones variables */
gen robotusagebinary=0
replace robotusagebinary=1 if (usage==1 | usage==2 | usage==3)
replace robotusagebinary=. if usage==.
label variable robotusagebinary `"Robot Usage: 1 = Yes, 0 = No"'
rename usage robotusage
label variable robotusage `"General Robot Usage"'
label define robotusage 1 "Yes, at home" 2 "Yes, at work" 3 "Yes, at home and at work" 4 "No" 5 "Don't know"
label values robotusage robotusage

gen robotviewsbinary=0
replace robotviewsbinary=1 if (views==1 | views==2)
replace robotviewsbinary=. if views==.
label variable robotviews `"Positive Robot Views: 1 = Yes 0 = No"'
rename views robotviews
label variable robotviews `"General Robot Views"'
label define robotviews 1 "Very positive" 2 "Somewhat positive" 3 "Neither positive nor negative" 4 "Somewhat negative" 5 "Very negative"
label values robotviews robotviews

rename drones awsinfo
replace awsinfo=0 if awsinfo==1
replace awsinfo=1 if awsinfo==2
label variable awsinfo `"Knows AWS is not a drone: 1 = Yes 0 = No"'

rename q35 dronestrikes
label variable dronestrikes `"View of US drone strikes, 1=Strongly approve to 5=Strongly disapprove"'

gen dronestrikesbinary=0
replace dronestrikesbinary=1 if (dronestrikes==1 | dronestrikes==2)
label variable dronestrikesbinary `"Supports US drone strikes: 1 = Yes 0 = No"'

*/ save dataset */
save Experiment2.dta, replace

*/ Basic support levels */
gen condition=0
replace condition=1 if baselinedummy==1
replace condition=2 if milnecdummy==1
replace condition=3 if foreigndevdummy==1
replace condition=4 if notnecdummy==1
tabstat support, by(condition)
label variable condition `"1=Baseline, 2=Mil Nec, 3=Foreign Dev, 4 =Not Nec"'

*/ Figure 3 */
table support, by(baselinecondition)
table support, by(notneccondition)
table support, by(milneccondition)
table support, by(foreigndevcondition)
ttest support, by(baselinedummy)
ttest support, by(milnecdummy)
ttest support, by(foreigndevdummy)
ttest support, by(notnecdummy)

*/ Appendix */

*/ Summary statistics */
estimates clear
tabstat support baselinedummy milnecdummy foreigndevdummy military age republican male, stats(n min mean max) columns(s)
estpost summ baselinedummy milnecdummy foreigndevdummy military age republican male hawkdove robotviewsbinary robotusagebinary dronestrikesbinary
esttab using AppendixTable6.rtf, replace t(3) cells("mean(fmt(3)) sd min max") nomtitle nonumber label

table partisanship
estimates clear
estpost tabulate partisanship
esttab using AppendixTable7.rtf, replace label

*/ Appendix Figure 3 */
estimates clear
regress support notnecdummy milnecdummy foreigndevdummy military age republican male hawkdove, robust
estimates store m1
coefplot m1, graphregion(color(white) lcolor(white) ilcolor(white)) xline(0) xtitle(OLS Coefficients, margin(medium)) ylabel(, nogrid) drop(_cons) plotregion(fcolor(white) lcolor(white) ilcolor(white)) 
Graph save AppendixFigure3.gph, replace

*/ Marginal Effects discussed in paper
regress support notnecdummy milnecdummy foreigndevdummy military age republican male hawkdove, robust
margins, at( (means) _all notnecdummy=1 milnecdummy=0 foreigndevdummy=0)
margins, at( (means) _all notnecdummy=0 milnecdummy=1 foreigndevdummy=1)

*/ Appendix Table 8 */
regress support baselinedummy milnecdummy foreigndevdummy military age republican male hawkdove, robust

estimates store m1

regress support baselinedummy milnecdummy foreigndevdummy military age republican male hawkdove robotviewsbinary robotusagebinary, robust

estimates store m2

regress support baselinedummy milnecdummy foreigndevdummy military age republican male hawkdove robotviewsbinary robotusagebinary dronestrikesbinary, robust

estimates store m3

*/ Merge Weights */

mmerge partleaners using partisanship_dat2.dta
mmerge age using age_dat2.dta
gen old_wt2=1
survwgt rake old_wt2, by(partleaners) totvars(partisanship_tot) generate(part_wt)
gen old_wt3=1
survwgt rake old_wt3, by(age) totvars(age_tot) generate(age_wt)

regress support baselinedummy milnecdummy foreigndevdummy military age republican male hawkdove robotviewsbinary robotusagebinary dronestrikesbinary [pweight=age_wt], robust

estimates store m4

regress support baselinedummy milnecdummy foreigndevdummy military age republican male hawkdove robotviewsbinary robotusagebinary dronestrikesbinary [pweight=part_wt], robust

estimates store m5

esttab m1 m2 m3 m4 m5 using AppendixTable8.rtf, replace onecell se r2 t(3) scalars(ll) legend label collabels(none) varlabels(_cons Constant) star(* 0.10 ** 0.05 *** 0.01)

estimates clear

*/ Reduce to final dataset */
keep ID hawkdove baselinecondition milneccondition foreigndevcondition notneccondition age education robotusage robotviews awsinfo dronestrikes democrat republican independentbig strongdem stronggop independentsmall democratbig republicanbig partisanship partleaners baselinedummy milnecdummy foreigndevdummy notnecdummy support supportbinary opposebinary military combat male robotusagebinary robotviewsbinary dronestrikesbinary condition part_wt age_wt
order ID
order baselinecondition milneccondition foreigndevcondition notneccondition, after(partleaners)

save Experiment2.dta, replace

clear

log close
