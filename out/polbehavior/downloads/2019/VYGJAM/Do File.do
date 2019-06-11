******************************************************************************
* Pre-Test 1 (N=500)
******************************************************************************

*load data
use "Pretest1.dta", clear

*how much do participants support these values? (we want an even distribution)
sum freedom_expression speech_protection transparency dishonesty ///
material_support teaching_fishing compromise ground_standing ///
retaliation no_revenge

*does this differ by party?
ttest compromise, by(partydummy)
ttest ground_standing, by(partydummy)

*do participants associate these values with political parties? (value 
*needs to be associated with neither party)
sum freedom_party speech_party transparency_party dishonesty_party ///
material_party teaching_party compromise_party ground_party retaliation_party ///
revenge_party

*do participants see these values as potential political values?
sum freedom_pol speech_pol transparency_pol dishonesty_pol material_pol ///
teaching_pol compromise_pol ground_pol retaliation_pol revenge_pol

*do participants see these values as potential values?
sum freedom_val speech_val transparency_val dishonesty_val material_val ///
teaching_val compromise_val ground_val retaliation_val revenge_val

*what is the most positively viewed group?
sum trump_supporters trump_opposers trump_positives trump_negatives ///
balanceds loyals indies moderates knowledgeables
*those who listen to balanced news

******************************************************************************
* Pre-Test 2 (N=166)
******************************************************************************

*load data
use "Pretest2.dta", clear

*values viewed as most opposed are revenge, compromise, honesty, speech
tab1 speech_compatible honesty_compatible support_compatible ///
compromise_compatible revenge_compatible

*values viewed as most split are: compromise, support, honesty
tab1 speech_choice honesty_choice support_choice compromise_choice ///
revenge_choice

*but does this change by these PID, PID strength, and/or PID strength & type?
tab compromise_compatible partydummy, chi2
tab compromise_choice partydummy, chi2
tab compromise_compatible strength, chi2
tab compromise_choice strength, chi2
tab compromise_compatible partisanship, chi2
tab compromise_choice partisanship, chi2

******************************************************************************
* Survey Experiment on Mturk
******************************************************************************

*load data
use "Experiment.dta", clear

*does compromise endorsement differ by treatment? 
ttest full_var, by(treat)

*does the treatment effect differ by levels of self-monitoring (as median split)?
ttest full_var if sm<12, by(treat) //high self-monitoring
ttest full_var if sm>=12, by(treat) //low self-monitoring
*figure
cibar full_var, over1(treat) over2(low_vs_high) level(95) ///
barcolor(erose emerald) graphopts(title(" ") ///
legend(order(1 "No Cue" 2 "Cue")) ylabel(0 1, nogrid noticks) ///
graphregion(fcolor(white)) ytitle("Compromise Endorsement")  ///
xlabel(1.5 "Low Self-Monitors" 4.2 "High Self-Monitors"))

*but are these statistically diferent from each other?
logit full_var i.treat##i.low_vs_high
margins, dydx(treat) by(i.low_vs_high)
*figure
marginsplot, yline(0)  ciopts(lpattern(solid)) recast(scatter) ///
ylabel(.5 (1) -.5) graphregion(fcolor(white)) title("") ///
xtitle("Self-Monitoring") ytitle("Marginal Effect of Social Cue") ///
graphregion(fcolor(white)) plotopts(lcolor(black)) ci1opts(lcol(black))

*do we see the same trend when we look at self-monitoring as continuous?
logit full_var i.treat##c.selfmonitoring
margins, dydx(treat) by(c.selfmonitoring)
*figure
marginsplot, yline(0)  ciopts(lpattern(solid)) recast(scatter) ///
ylabel(1 (1) -1, nogrid noticks) graphregion(fcolor(white)) title("") ///
xtitle("Self-Monitoring") ytitle("Marginal Effect of Social Cue") ///
graphregion(fcolor(white)) plotopts(lcolor(black)) ci1opts(lcol(black))

*does including controls change anything? (self-monitoring is measured rather
*than manipulated)
logit full_var i.treat##i.low_vs_high education race age female media discuss ///
interest ideology partisanship
logit full_var i.treat##c.selfmonitoring education race age female media discuss ///
interest ideology partisanship

*do we see the same trends with just democrats?
preserve
drop if partydummy != 1
ttest full_var if sm<12, by(treat) //high sm
ttest full_var if sm>=12, by(treat) //low sm
cibar full_var, over1(treat) over2(low_vs_high) level(95) ///
barcolor(emidblue edkblue) graphopts(title("") ///
legend(order(1 "No Cue" 2 "Cue")) ylabel(0 1, nogrid noticks) ///
graphregion(fcolor(white)) ytitle("Compromise Endorsement")  ///
xlabel(1.5 "Low Self-Monitors" 4.2 "High Self-Monitors"))
restore

*do we see the same trends with just republicans?
preserve
drop if partydummy != 0
ttest full_var if sm<12, by(treat) //high sm
ttest full_var if sm>=12, by(treat) //low sm
cibar full_var, over1(treat) over2(low_vs_high) level(95) ///
barcolor(erose maroon) graphopts(title("") ///
legend(order(1 "No Cue" 2 "Cue")) ylabel(0 1, nogrid noticks) ///
graphregion(fcolor(white)) ytitle("Compromise Endorsement")  ///
xlabel(1.5 "Low Self-Monitors" 4.2 "High Self-Monitors"))
restore

******************************************************************************
* ANES 2000 Observational Analysis
******************************************************************************

*load data
use "ANES.dta", clear

*main model
logit congruence2 homonet
logit congruence2 homonet age income male white black hispanic church education ///
ideology strength interest media discuss knowledge
*predicted probabilities
margins, at(homonet=(0 1))
mlincom 2-1

*Mutz and Mondak
logit congruence2 newhomonet age income male white black hispanic church education ///
ideology strength interest media discuss knowledge
*predicted probabilities
margins, at(newhomonet=(0 1))
mlincom 2-1

*PID strength
logit congruence2 i.homonet##c.strength age income male white black hispanic church education ///
ideology interest media discuss knowledge

*additional controls: religion and occupation
logit congruence2 homonet age income male white black hispanic church education ///
strength ideology interest media discuss knowledge i.occupation i.religion

*continuous iv
logit congruence2 congnet age income male white black hispanic church education ///
strength ideology interest media discuss knowledge

*continuous dv
reg valuecongruence homonet age income male white black hispanic church education ///
ideology strength interest media discuss knowledge, robust




