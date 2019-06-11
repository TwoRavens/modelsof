

/// This do file provides the syntax to replicate the analyses used for Bittner and Goodyear-Grant’s Political Behavior article, 
/// “Sex Isn’t Gender: Reforming Concepts and Measurements in the Study of Public Opinion,” using Stata 14.2.
/// for more information or with any questions, contact Bittner at: abittner@mun.ca 


cd "/Users/amandabittner1/Dropbox/professional/Research/Better than Sex/Political Behavior/replication/"


use sixprovs.dta, clear

///Figure 1
histogram selfplacegen, percent
histogram selfplacegen, percent by(woman)


///Numbers discussed, linked to data presented in Figure 1 and Table 1
gen gen50=selfplacegen
recode gen50 0/49=0 51/100=0 50=1
tab gen50

gen genmid40=selfplacegen
recode genmid40 0/39=0 40/60=1 61/100=0
tab genmid40

gen genpoles=selfplacegen
recode genpoles 1/99=0 0=1 100=1
tab genpoles

gen matchinggenpoles=genpoles
replace matchinggenpoles=0 if gencrossers==1
tab matchinggenpoles

gen poles10=selfplacegen
recode poles10 0/10=1 11/89=0 90/100=1
tab poles10

gen matchinggen10poles=poles10
replace matchinggen10poles=0 if gencrossers==1
tab matchinggen10poles



///Groups created for Table 1

gen fivegencategories=selfplacegen
recode fivegencategories 0=1 1/49=2 50=3 51/99=4 100=5
tab fivegencategories

tab fivegencategories woman

gen gen1=fivegencategories
recode gen1 2/5=0
tab gen1

gen gen2=fivegencategories
recode gen2 1=0 2=1 3/5=0

gen gen3=fivegencategories
recode gen3 1/2=0 3=1 4/5=0

gen gen4=fivegencategories
recode gen4 1/3=0 4=1 5=0

gen gen5=fivegencategories
recode gen5 1/4=0 5=1

tab gen1
tab gen2
tab gen3
tab gen4
tab gen5




///coding for multivariate models
gen religious=religiousity
recode religious 0/.4=0 .6/1=1
tab religious

gen highincome25=income
recode highincome25 0/.5=0 .75/1=1
tab highincome25

gen oldest=agecategory
recode oldest 1/2=0 3=1

gen youngest=agecategory
recode youngest 2/3=0




///Figure 2, combined bar graphs

logit gen1 i.woman i.degreeholder i.fulltimework i.union i.partnered i.religious i.highincome25 i.oldest i.NL i.MB i.AB i.QC i.BC
est store gen1
margins, dydx(degreeholder fulltimework partnered religious highincome25 oldest) saving(gen1, replace)
marginsplot, horizontal recast(bar) ytitle(Socio-Demographic Factors) xscale(range(-0.1 0.1)) xlabel(-0.1(0.05)0.1) title(Gender Group A (0)) xtitle(Linear Prediction) name(gen1plot, replace)

logit gen2 i.woman i.degreeholder i.fulltimework i.union i.partnered i.religious i.highincome25 i.oldest i.NL i.MB i.AB i.QC i.BC
est store gen2
margins, dydx(degreeholder fulltimework partnered religious highincome25 oldest) saving(gen2, replace)
marginsplot, horizontal recast(bar) ytitle(Socio-Demographic Factors) xscale(range(-0.1 0.1)) xlabel(-0.1(0.05)0.1) title(Gender Group B (1-49)) xtitle(Linear Prediction) name(gen2plot, replace)

logit gen3 i.woman i.degreeholder i.fulltimework i.union i.partnered i.religious i.highincome25 i.oldest i.NL i.MB i.AB i.QC i.BC
est store gen3
margins, dydx(degreeholder fulltimework partnered religious highincome25 oldest) saving(gen3, replace)
marginsplot, horizontal recast(bar) ytitle(Socio-Demographic Factors) xscale(range(-0.1 0.1)) xlabel(-0.1(0.05)0.1) title(Gender Group C (50)) xtitle(Linear Prediction) name(gen3plot, replace)

logit gen4 i.woman i.degreeholder i.fulltimework i.union i.partnered i.religious i.highincome25 i.oldest i.NL i.MB i.AB i.QC i.BC
est store gen4
margins, dydx(degreeholder fulltimework partnered religious highincome25 oldest) saving(gen4, replace)
marginsplot, horizontal recast(bar) ytitle(Socio-Demographic Factors) xscale(range(-0.1 0.1)) xlabel(-0.1(0.05)0.1) title(Gender Group D (51-99)) xtitle(Linear Prediction) name(gen4plot, replace)

logit gen5 i.woman i.degreeholder i.fulltimework i.union i.partnered i.religious i.highincome25 i.oldest i.NL i.MB i.AB i.QC i.BC
est store gen5
margins, dydx(degreeholder fulltimework partnered religious highincome25 oldest) saving(gen5, replace)
marginsplot, horizontal recast(bar) ytitle(Socio-Demographic Factors) xscale(range(-0.1 0.1)) xlabel(-0.1(0.05)0.1) title(Gender Group E (100)) xtitle(Linear Prediction) name(gen5plot, replace)

graph combine gen1plot gen2plot gen3plot gen4plot gen5plot


///note: after this, used graph editor to change look of the combined graph





///Figure 3
reg abortion c.woman c.degreeholder c.fulltimework c.union c.partnered c.religious c.highincome25 c.oldest c.NL c.MB c.AB c.QC c.BC
est store abortion
margins, dydx(woman) saving(abortion, replace)

reg samesexmarriage c.woman c.degreeholder c.fulltimework c.union c.partnered c.religious c.highincome25 c.oldest c.NL c.MB c.AB c.QC c.BC
est store samesexmarriage
margins, dydx(woman) saving(samesexmarriage, replace)

reg govinvolvement woman c.woman c.degreeholder c.fulltimework c.union c.partnered c.religious c.highincome25 c.oldest c.NL c.MB c.AB c.QC c.BC
est store govinvolvement
margins, dydx(woman) saving(govinvolvement, replace)

reg healthcarespending c.woman c.degreeholder c.fulltimework c.union c.partnered c.religious c.highincome25 c.oldest c.NL c.MB c.AB c.QC c.BC
est store healthcarespending
margins, dydx(woman) saving(healthcarespending, replace)

reg welfarespending c.woman c.degreeholder c.fulltimework c.union c.partnered c.religious c.highincome25 c.oldest c.NL c.MB c.AB c.QC c.BC
est store welfarespending
margins, dydx(woman) saving(welfarespending, replace)

reg layoffwomen c.woman c.degreeholder c.fulltimework c.union c.partnered c.religious c.highincome25 c.oldest c.NL c.MB c.AB c.QC c.BC
est store layoffwomen
margins, dydx(woman) saving(layoffwomen, replace)

reg socialprogs c.woman c.degreeholder c.fulltimework c.union c.partnered c.religious c.highincome25 c.oldest c.NL c.MB c.AB c.QC c.BC
est store socialprogs
margins, dydx(woman) saving(socialprogs, replace)

reg discrimjobs c.woman c.degreeholder c.fulltimework c.union c.partnered c.religious c.highincome25 c.oldest c.NL c.MB c.AB c.QC c.BC
est store discrimjobs
margins, dydx(woman) saving(discrimjobs, replace)

reg adaptmoral c.woman c.degreeholder c.fulltimework c.union c.partnered c.religious c.highincome25 c.oldest c.NL c.MB c.AB c.QC c.BC
est store adaptmoral
margins, dydx(woman) saving(adaptmoral, replace)

reg tradfamvalues c.woman c.degreeholder c.fulltimework c.union c.partnered c.religious c.highincome25 c.oldest c.NL c.MB c.AB c.QC c.BC
est store tradfamvalues
margins, dydx(woman) saving(tradfamvalues, replace)

reg wantworkfindjob c.woman c.degreeholder c.fulltimework c.union c.partnered c.religious c.highincome25 c.oldest c.NL c.MB c.AB c.QC c.BC
est store wantworkfindjob
margins, dydx(woman) saving(wantworkfindjob, replace)

reg womenhofc c.woman c.degreeholder c.fulltimework c.union c.partnered c.religious c.highincome25 c.oldest c.NL c.MB c.AB c.QC c.BC
est store womenhofc
margins, dydx(woman) saving(womenhofc, replace)

combomarginsplot abortion samesexmarriage govinvolvement healthcarespending welfarespending layoffwomen socialprogs discrimjobs adaptmoral tradfamvalues wantworkfindjob womenhofc, ///
horizontal recast(bar)  xscale(range(-0.05 0.2)) xlabel(-0.05(0.05)0.2) xtitle(Linear Prediction) title(Impact of Sex on Attitudes) ///
labels("Abortion" "Same Sex marriage" "Government Involvement" "Healthcare Spending" "Welfare Spending" "Layoff women with husbands" "Effect of Social Programs" "Effect of Discrimination on Job-Getting" "Adapt ideas of moral behavior" "Traditional Family Values" "Want work can find job" "Women in legislature") ///
name(attitudes, replace)


///note: after this, used graph editor to change look of the combined graph






///Figure 4
reg abortion i.selfplacegen i.ideology c.degreeholder c.fulltimework c.union c.partnered c.religious c.highincome25 c.oldest c.NL c.MB c.AB c.QC c.BC
est store abortion
margins, dydx(selfplacegen)
marginsplot, recast(line) recastci(rarea) ytitle("Impact of Gender on Attitudes") xtitle("Gender Self-Placement") title(Abortion)   xsize(8) ysize(4) saving(abortion, replace)

reg samesexmarriage i.selfplacegen i.ideology c.degreeholder c.fulltimework c.union c.partnered c.religious c.highincome25 c.oldest c.NL c.MB c.AB c.QC c.BC
est store samesexmarriage
margins, dydx(selfplacegen)
marginsplot, recast(line) recastci(rarea) ytitle("Impact of Gender on Attitudes") xtitle("Gender Self-Placement") title(Same Sex Marriage)   xsize(8) ysize(4) saving(samesexmarriage, replace)

reg govinvolvement i.selfplacegen i.ideology c.degreeholder c.fulltimework c.union c.partnered c.religious c.highincome25 c.oldest c.NL c.MB c.AB c.QC c.BC
est store govinvolvement
margins, dydx(selfplacegen)
marginsplot, recast(line) recastci(rarea) ytitle("Impact of Gender on Attitudes") xtitle("Gender Self-Placement") title(Government Involvement)   xsize(8) ysize(4) saving(govinvolvement, replace)

reg healthcarespending i.selfplacegen i.ideology c.degreeholder c.fulltimework c.union c.partnered c.religious c.highincome25 c.oldest c.NL c.MB c.AB c.QC c.BC
est store healthcarespending
margins, dydx(selfplacegen)
marginsplot, recast(line) recastci(rarea) ytitle("Impact of Gender on Attitudes") xtitle("Gender Self-Placement") title(Healthcare Spending)   xsize(8) ysize(4) saving(healthcarespending, replace)

reg welfarespending i.selfplacegen i.ideology c.degreeholder c.fulltimework c.union c.partnered c.religious c.highincome25 c.oldest c.NL c.MB c.AB c.QC c.BC
est store welfarespending
margins, dydx(selfplacegen)
marginsplot, recast(line) recastci(rarea) ytitle("Impact of Gender on Attitudes") xtitle("Gender Self-Placement") title(Welfare Spending)   xsize(8) ysize(4) saving(welfarespending, replace)

reg layoffwomen i.selfplacegen i.ideology c.degreeholder c.fulltimework c.union c.partnered c.religious c.highincome25 c.oldest c.NL c.MB c.AB c.QC c.BC
est store layoffwomen
margins, dydx(selfplacegen)
marginsplot, recast(line) recastci(rarea) ytitle("Impact of Gender on Attitudes") xtitle("Gender Self-Placement") title(Layoff women with husbands)   xsize(8) ysize(4) saving(layoffwomen, replace)

reg socialprogs i.selfplacegen i.ideology c.degreeholder c.fulltimework c.union c.partnered c.religious c.highincome25 c.oldest c.NL c.MB c.AB c.QC c.BC
est store socialprogs
margins, dydx(selfplacegen)
marginsplot, recast(line) recastci(rarea) ytitle("Impact of Gender on Attitudes") xtitle("Gender Self-Placement") title(Effect of Social Programs)   xsize(8) ysize(4) saving(socialprogs, replace)

reg discrimjobs i.selfplacegen i.ideology c.degreeholder c.fulltimework c.union c.partnered c.religious c.highincome25 c.oldest c.NL c.MB c.AB c.QC c.BC
est store discrimjobs
margins, dydx(selfplacegen)
marginsplot, recast(line) recastci(rarea) ytitle("Impact of Gender on Attitudes") xtitle("Gender Self-Placement") title(Job Discrimination)   xsize(8) ysize(4) saving(discrimjobs, replace)

reg adaptmoral i.selfplacegen i.ideology c.degreeholder c.fulltimework c.union c.partnered c.religious c.highincome25 c.oldest c.NL c.MB c.AB c.QC c.BC
est store adaptmoral
margins, dydx(selfplacegen)
marginsplot, recast(line) recastci(rarea) ytitle("Impact of Gender on Attitudes") xtitle("Gender Self-Placement") title(Adapt Ideas of Moral Behavior)   xsize(8) ysize(4) saving(adaptmoral, replace)

reg tradfamvalues i.selfplacegen i.ideology c.degreeholder c.fulltimework c.union c.partnered c.religious c.highincome25 c.oldest c.NL c.MB c.AB c.QC c.BC
est store tradfamvalues
margins, dydx(selfplacegen)
marginsplot, recast(line) recastci(rarea) ytitle("Impact of Gender on Attitudes") xtitle("Gender Self-Placement") title(Traditional Family Values)   xsize(8) ysize(4) saving(tradfamvalues, replace)

reg wantworkfindjob i.selfplacegen i.ideology c.degreeholder c.fulltimework c.union c.partnered c.religious c.highincome25 c.oldest c.NL c.MB c.AB c.QC c.BC
est store wantworkfindjob
margins, dydx(selfplacegen)
marginsplot, recast(line) recastci(rarea) ytitle("Impact of Gender on Attitudes") xtitle("Gender Self-Placement") title(Want Work Can Find a Job)   xsize(8) ysize(4) saving(wantworkfindjob, replace)

reg womenhofc i.selfplacegen i.ideology c.degreeholder c.fulltimework c.union c.partnered c.religious c.highincome25 c.oldest c.NL c.MB c.AB c.QC c.BC 
est store womenhofc
margins, dydx(selfplacegen)
marginsplot, recast(line) recastci(rarea) ytitle("Impact of Gender on Attitudes") xtitle("Gender Self-Placement") title(Women in Legislature)   xsize(8) ysize(4) saving(womenhofc, replace)

reg ideology i.selfplacegen c.degreeholder c.fulltimework c.union c.partnered c.religious c.highincome25 c.oldest c.NL c.MB c.AB c.QC c.BC
est store ideology
margins, dydx(selfplacegen)
marginsplot, recast(line) recastci(rarea) ytitle("Impact of Gender on Attitudes") xtitle("Gender Self-Placement") title(Left-Right Self-Placement)   xsize(8) ysize(4) saving(ideology, replace)


graph combine abortion.gph samesexmarriage.gph govinvolvement.gph healthcarespending.gph welfarespending.gph /*
*/ layoffwomen.gph discrimjobs.gph socialprogs.gph adaptmoral.gph tradfamvalues.gph wantworkfindjob.gph womenhofc.gph


///Used graph editor for each figure individually, and then again once graphs were combined into a single figure




///Figure 5
reg abortion i.selfplacegen##c.woman i.ideology c.degreeholder c.fulltimework c.union c.partnered c.religious c.highincome25 c.oldest c.NL c.MB c.AB c.QC c.BC
est store abortion
margins i.selfplacegen, dydx(woman)
marginsplot, recast(line) recastci(rarea) ytitle("Impact of Sex on Attitudes") xtitle("Gender Self-Placement") title(Abortion)   xsize(8) ysize(4) saving(abortion2, replace)

reg samesexmarriage i.selfplacegen##c.woman i.ideology c.degreeholder c.fulltimework c.union c.partnered c.religious c.highincome25 c.oldest c.NL c.MB c.AB c.QC c.BC
est store samesexmarriage
margins i.selfplacegen, dydx(woman)
marginsplot, recast(line) recastci(rarea) ytitle("Impact of Sex on Attitudes") xtitle("Gender Self-Placement") title(Same Sex Marriage)   xsize(8) ysize(4) saving(samesexmarriage2, replace)

reg govinvolvement i.selfplacegen##c.woman i.ideology c.degreeholder c.fulltimework c.union c.partnered c.religious c.highincome25 c.oldest c.NL c.MB c.AB c.QC c.BC
est store govinvolvement
margins i.selfplacegen, dydx(woman)
marginsplot, recast(line) recastci(rarea) ytitle("Impact of Sex on Attitudes") xtitle("Gender Self-Placement") title(Government Involvement)   xsize(8) ysize(4) saving(govinvolvement2, replace)

reg healthcarespending i.selfplacegen##c.woman  i.ideology c.degreeholder c.fulltimework c.union c.partnered c.religious c.highincome25 c.oldest c.NL c.MB c.AB c.QC c.BC
est store healthcarespending
margins i.selfplacegen, dydx(woman)
marginsplot, recast(line) recastci(rarea) ytitle("Impact of Sex on Attitudes") xtitle("Gender Self-Placement") title(Healthcare Spending)   xsize(8) ysize(4) saving(healthcarespending2, replace)

reg welfarespending i.selfplacegen##c.woman i.ideology c.degreeholder c.fulltimework c.union c.partnered c.religious c.highincome25 c.oldest c.NL c.MB c.AB c.QC c.BC
est store welfarespending
margins i.selfplacegen, dydx(woman)
marginsplot, recast(line) recastci(rarea) ytitle("Impact of Sex on Attitudes") xtitle("Gender Self-Placement") title(Welfare Spending)   xsize(8) ysize(4) saving(welfarespending2, replace)

reg layoffwomen i.selfplacegen##c.woman i.ideology c.degreeholder c.fulltimework c.union c.partnered c.religious c.highincome25 c.oldest c.NL c.MB c.AB c.QC c.BC
est store layoffwomen
margins i.selfplacegen, dydx(woman)
marginsplot, recast(line) recastci(rarea) ytitle("Impact of Sex on Attitudes") xtitle("Gender Self-Placement") title(Layoff women with husbands)   xsize(8) ysize(4) saving(layoffwomen2, replace)

reg socialprogs i.selfplacegen##c.woman i.ideology c.degreeholder c.fulltimework c.union c.partnered c.religious c.highincome25 c.oldest c.NL c.MB c.AB c.QC c.BC
est store socialprogs
margins i.selfplacegen, dydx(woman)
marginsplot, recast(line) recastci(rarea) ytitle("Impact of Sex on Attitudes") xtitle("Gender Self-Placement") title(Effect of Social Programs)   xsize(8) ysize(4) saving(socialprogs2, replace)

reg discrimjobs i.selfplacegen##c.woman  i.ideology c.degreeholder c.fulltimework c.union c.partnered c.religious c.highincome25 c.oldest c.NL c.MB c.AB c.QC c.BC
est store discrimjobs
margins i.selfplacegen, dydx(woman)
marginsplot, recast(line) recastci(rarea) ytitle("Impact of Sex on Attitudes") xtitle("Gender Self-Placement") title(Job Discrimination)   xsize(8) ysize(4) saving(discrimjobs2, replace)

reg adaptmoral i.selfplacegen##c.woman  i.ideology c.degreeholder c.fulltimework c.union c.partnered c.religious c.highincome25 c.oldest c.NL c.MB c.AB c.QC c.BC
est store adaptmoral
margins i.selfplacegen, dydx(woman)
marginsplot, recast(line) recastci(rarea) ytitle("Impact of Sex on Attitudes") xtitle("Gender Self-Placement") title(Adapt Ideas of Moral Behavior)   xsize(8) ysize(4) saving(adaptmoral2, replace)

reg tradfamvalues i.selfplacegen##c.woman i.ideology c.degreeholder c.fulltimework c.union c.partnered c.religious c.highincome25 c.oldest c.NL c.MB c.AB c.QC c.BC
est store tradfamvalues
margins i.selfplacegen, dydx(woman)
marginsplot, recast(line) recastci(rarea) ytitle("Impact of Sex on Attitudes") xtitle("Gender Self-Placement") title(Traditional Family Values)   xsize(8) ysize(4) saving(tradfamvalues2, replace)

reg wantworkfindjob i.selfplacegen##c.woman  i.ideology c.degreeholder c.fulltimework c.union c.partnered c.religious c.highincome25 c.oldest c.NL c.MB c.AB c.QC c.BC
est store wantworkfindjob
margins i.selfplacegen, dydx(woman)
marginsplot, recast(line) recastci(rarea) ytitle("Impact of Sex on Attitudes") xtitle("Gender Self-Placement") title(Want Work Can Find a Job)   xsize(8) ysize(4) saving(wantworkfindjob2, replace)

reg womenhofc i.selfplacegen##c.woman i.ideology c.degreeholder c.fulltimework c.union c.partnered c.religious c.highincome25 c.oldest c.NL c.MB c.AB c.QC c.BC 
est store womenhofc
margins i.selfplacegen, dydx(woman)
marginsplot, recast(line) recastci(rarea) ytitle("Impact of Sex on Attitudes") xtitle("Gender Self-Placement") title(Women in Legislature)   xsize(8) ysize(4) saving(womenhofc2, replace)

reg ideology i.selfplacegen##c.woman  c.degreeholder c.fulltimework c.union c.partnered c.religious c.highincome25 c.oldest c.NL c.MB c.AB c.QC c.BC
est store ideology
margins i.selfplacegen, dydx(woman)
marginsplot, recast(line) recastci(rarea) ytitle("Impact of Sex on Attitudes") xtitle("Gender Self-Placement") title(Left-Right Self-Placement)   xsize(8) ysize(4) saving(ideology2, replace)



graph combine abortion2.gph samesexmarriage2.gph govinvolvement2.gph healthcarespending2.gph welfarespending2.gph /*
*/ layoffwomen2.gph discrimjobs2.gph socialprogs2.gph adaptmoral2.gph tradfamvalues2.gph wantworkfindjob2.gph womenhofc2.gph


///used graph editor for each individual figure, and again once graphs were combined into table of graphs




///Figure 6

reg abortion i.gen1 i.gen2 i.gen4 i.gen5 c.ideology i.degreeholder i.fulltimework i.union i.partnered i.religious i.highincome25 i.oldest i.NL i.MB i.AB i.QC i.BC
est store abortion
margins, dydx(gen1 gen2 gen4 gen5) saving(abortion3, replace)

reg samesexmarriage i.gen1 i.gen2 i.gen4 i.gen5 c.ideology i.degreeholder i.fulltimework i.union i.partnered i.religious i.highincome25 i.oldest i.NL i.MB i.AB i.QC i.BC
est store samesexmarriage
margins, dydx(gen1 gen2 gen4 gen5) saving(samesexmarriage3, replace)

reg govinvolvement i.gen1 i.gen2 i.gen4 i.gen5 c.ideology i.degreeholder i.fulltimework i.union i.partnered i.religious i.highincome25 i.oldest i.NL i.MB i.AB i.QC i.BC
est store govinvolvement
margins, dydx(gen1 gen2 gen4 gen5) saving(govinvolvement3, replace)

reg healthcarespending i.gen1 i.gen2 i.gen4 i.gen5 c.ideology i.degreeholder i.fulltimework i.union i.partnered i.religious i.highincome25 i.oldest i.NL i.MB i.AB i.QC i.BC
est store healthcarespending
margins, dydx(gen1 gen2 gen4 gen5) saving(healthcarespending3, replace)

reg welfarespending i.gen1 i.gen2 i.gen4 i.gen5 c.ideology i.degreeholder i.fulltimework i.union i.partnered i.religious i.highincome25 i.oldest i.NL i.MB i.AB i.QC i.BC
est store welfarespending
margins, dydx(gen1 gen2 gen4 gen5) saving(welfarespending3, replace)

reg layoffwomen i.gen1 i.gen2 i.gen4 i.gen5 c.ideology i.degreeholder i.fulltimework i.union i.partnered i.religious i.highincome25 i.oldest i.NL i.MB i.AB i.QC i.BC
est store layoffwomen
margins, dydx(gen1 gen2 gen4 gen5) saving(layoffwomen3, replace)

reg socialprogs i.gen1 i.gen2 i.gen4 i.gen5 c.ideology i.degreeholder i.fulltimework i.union i.partnered i.religious i.highincome25 i.oldest i.NL i.MB i.AB i.QC i.BC
est store socialprogs
margins, dydx(gen1 gen2 gen4 gen5) saving(socialprogs3, replace)

reg discrimjobs i.gen1 i.gen2 i.gen4 i.gen5 c.ideology i.degreeholder i.fulltimework i.union i.partnered i.religious i.highincome25 i.oldest i.NL i.MB i.AB i.QC i.BC
est store discrimjobs
margins, dydx(gen1 gen2 gen4 gen5) saving(discrimjobs3, replace)

reg adaptmoral i.gen1 i.gen2 i.gen4 i.gen5 c.ideology i.degreeholder i.fulltimework i.union i.partnered i.religious i.highincome25 i.oldest i.NL i.MB i.AB i.QC i.BC
est store adaptmoral
margins, dydx(gen1 gen2 gen4 gen5) saving(adaptmoral3, replace)

reg tradfamvalues i.gen1 i.gen2 i.gen4 i.gen5 c.ideology i.degreeholder i.fulltimework i.union i.partnered i.religious i.highincome25 i.oldest i.NL i.MB i.AB i.QC i.BC
est store tradfamvalues
margins, dydx(gen1 gen2 gen4 gen5) saving(tradfamvalues3, replace)

reg wantworkfindjob i.gen1 i.gen2 i.gen4 i.gen5 c.ideology i.degreeholder i.fulltimework i.union i.partnered i.religious i.highincome25 i.oldest i.NL i.MB i.AB i.QC i.BC
est store wantworkfindjob
margins, dydx(gen1 gen2 gen4 gen5) saving(wantworkfindjob3, replace)

reg womenhofc i.gen1 i.gen2 i.gen4 i.gen5 c.ideology i.degreeholder i.fulltimework i.union i.partnered i.religious i.highincome25 i.oldest i.NL i.MB i.AB i.QC i.BC
est store womenhofc
margins, dydx(gen1 gen2 gen4 gen5) saving(womenhofc3, replace)

replace ideology=ideology/10
tab ideology

reg ideology i.gen1 i.gen2 i.gen4 i.gen5 i.degreeholder i.fulltimework i.union i.partnered i.religious i.highincome25 i.oldest i.NL i.MB i.AB i.QC i.BC
est store ideology
margins, dydx(gen1 gen2 gen4 gen5) saving(ideology3, replace)

combomarginsplot abortion3 samesexmarriage3 govinvolvement3 healthcarespending3 welfarespending3 layoffwomen3 socialprogs3 discrimjobs3 adaptmoral3 tradfamvalues3 wantworkfindjob3 womenhofc3 ideology3, ///
horizontal recast(dot) ytitle(Gender) xscale(range(-0.2 0.15)) xlabel(-0.2(0.05)0.15) xtitle(Linear Prediction) title(Impact of Sex and Gender on Attitudes) ///
labels("Abortion" "Same Sex marriage" "Government Involvement" "Healthcare Spending" "Welfare Spending" "Layoff women with husbands" "Effect of Social Programs" "Effect of Discrimination on Job-Getting" "Adapt ideas of moral behavior" "Traditional Family Values" "Want work can find job" "Women in legislature" "Left-Right Self-placement") ///
name(attitudes, replace)

///note: after this, used graph editor to change look of the combined graph





