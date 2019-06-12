*REPLICATION DO FILE FOR "Martial Law? Military Experience, International Law, and Support for Torture"

version 12 

*CD to relevant directory


*ANALYSIS FROM 1ST EXPERIMENT (INTERNATIONAL LAW)
use "torture_law.dta", clear


*Relable some of variables for presentation purposes
*Treatments
lab var treaty "International Law"
lab var insurgent "Insurgent"
lab var reciprocity "Reciprocity"
*Relabel variable as "Veteran" rather than original "Military" since use this label in tables and figures.
lab var military "Veteran"
*Interaction
lab var military_treaty "Veteran x International Law"
*Other Explanatory variables
lab var ideology "Political Ideology"
lab var partyid7 "Partisanship"
lab var ppagecat "Age"
lab var ppeducat "Education"
lab var male "Male"
lab var security "Security Issues"


*Summary statistics for international law experiment
*All
sum torture7 treaty insurgent reciprocity military ideology partyid7 ppagecat ppeducat male security white black hispanic
*Civilian
sum torture7 treaty insurgent reciprocity military ideology partyid7 ppagecat ppeducat male security white black hispanic if military==0
*Military
sum torture7 treaty insurgent reciprocity military ideology partyid7 ppagecat ppeducat male security white black hispanic if military==1


*Set level for confidence intervals to 90% given relatively small number of observations for veterans,
*	especially after taking into account experimental groupings.
set level 90


*Sample: Civilian vs. Military
tab military, mis


*Overall attitudes toward torture
proportion torture2
*Civil vs. Military
prtest torture2, by(military)



*TABLE 1
*Base model with treatments
ologit torture7 military treaty insurgent reciprocity ideology partyid7 ppagecat ppeducat male security white black hispanic, nolog
eststo
*Military interaction model
ologit torture7 military treaty  military_treaty insurgent reciprocity ideology partyid7 ppagecat ppeducat male security white black hispanic, nolog
eststo
*Command to produce table output
esttab using table1, csv replace b(3) se star (* 0.10 ** 0.05 *** 0.01) ///
	pr2(2) scalars("ll Log Likelihood" "chi2 Chi-squared") compress nogaps label ///
	title("Table 1. Ordered Logit Analysis of Support for Torture (International Law Experiment)") ///
	mtitles("Baseline" "Interaction") ///
	nonotes addnotes("Standard errors in parentheses." "* p<.10; ** p<.05; *** p<.01." "Cutpoints for ordered logit models not shown.")
eststo clear



*FIGURE 1
*Substantive effects for independent variables from baseline model
*Use version of DV where 3 values for agree/disagree are collapsed
estsimp ologit torture3 military treaty insurgent reciprocity ideology partyid7 ppagecat ppeducat male security white black hispanic, nolog
*Set treatments to 0 and all explanatory variables to their median values (white to 1 and other race variables to 0)
setx  (treaty insurgent reciprocity) 0 (ideology partyid7 ppagecat ppeducat male security military) median ///
	(white) 1 (black hispanic) 0
*Estimate probability support torture for civilians
setx military 0
simqi, prval(2)
*For veterans
setx military 1
simqi, prval(2)
*Calculate first difference
setx military 0 
simqi, fd(prval(2)) changex(military 0 1)

*Generate overall figure for substantive effects of all variables
*Use standard grayscale scheme
set scheme s1mono
*Use plotfds command
*Version where continuous variables are changed from one standard deviation below their means to one standard deviation above.
plotfds, continuous(ideology partyid7 ppagecat ppeducat) ///
	discrete(military treaty insurgent reciprocity male security white black hispanic) ///
	sort(military treaty insurgent reciprocity ideology partyid7 ppagecat ppeducat male security white black hispanic) ///
	outcome(2) clevel(90) nosetx label ///
	xline(0, lcolor(gs12)) msymbol(O) msize(medium) mcolor(black) ylabel(, labsize(small)) /// 
	xlabel(, grid) ///
	title("Fig 1. Substantive Effects for Determinants of Support for Torture (International Law Experiment)", ///
	size(small) position(7)) ///
	note("Notes: Results based on Model 1 from Table 1. Values represent first differences" ///
	"for the effect of each variable on the probability of reporting any level of support" ///
	"for torture (either strongly agree, agree, or somewhat agree), while holding treatment" ///
	"variables at 0 and all other independent variables at their medians. Continuous variables" ///
	"are changed from one standard deviation below their mean to one standard deviation above," ///
	"while dichotomous variables (indicated by a *) change from 0 to 1. Horizontal lines" ///
	"indicate 90% confidence intervals.") 



*FIGURE 2
*Test treaty effect based on civilian-veteran status
*Substantive effects using full interaction model (other variables set to median values; insurgent and reciprocity set to 0)
estsimp ologit torture3 military treaty military_treaty insurgent reciprocity ideology partyid7 ppagecat ppeducat male security white black hispanic, ///
	nolog dropsims
setx (treaty insurgent reciprocity military_treaty) 0 (ideology partyid7 ppagecat ppeducat male security military) median ///
	(white) 1 (black hispanic) 0
*Civilians
setx military 0 
simqi, fd(pr) changex(treaty 0 1)
*Repeat with 90% instead of 95% confidence intervals
simqi, fd(prval(2)) changex(treaty 0 1) level(90)
*Military 
setx military 1
simqi, fd(pr) changex(treaty 0 1 military_treaty 0 1)
simqi, fd(prval(2)) changex(treaty 0 1 military_treaty 0 1) level(90)

/*
*Save the generated values into a separate Stata data set

*Run the following commands to generate Figure 2

use "civmil_torture_figure2.dta", clear

*Create numerical values for groups so that seperate
gen group2 = group
*Since only 2 groups in this figure, rescale accordingly so even.
recode group2 (2=2) (3=4)

*Determine max-min values for Y-axis on figure
sum percent upperci lowerci

*Graph command
twoway ///
	(rcap lowerci upperci group2 if ci_level==90, lcolor(gs7)) ///
	(scatter percent group2 if ci_level==90, msymbol(O) mlcolor(black) msize(medlarge) mfcolor(black)), ///
	yscale(range (-0.15 0.15)) ylabel(-0.15(0.05)0.15, grid labsize(small)) ///
	xscale(range (0 6)) ///
	yline(0, lcolor(gs12)) ///
	ytitle("Change in Predicted Probability:" "Agree to Use Torture", size(small)) ///
	xtitle("Group", size(small)) ///
	legend(off) ///
	scheme(s1mono) ///
	xlabel(2 "Civilians" 4 "Veterans", labsize(small)) ///
	note("Notes: Results are generated from Model 2 in Table 1. Y-axis measures the first difference" ///
	"between the international law treatment and control groups on the probability of reporting any" ///
	"level of support for torture (either strongly agree, agree, or somewhat agree). First differences" ///
	"are calculated with the other treatments set to 0 and all other independent variables set to their" ///
	"medians. Vertical lines indicate 90% confidence intervals.") ///
	title("Fig 2. Effect of International Law on Support for Torture, by Civilian-Veteran Status", position(7) size(small)) 
*/




*ANALYSIS FROM 2ND EXPERIMENT (INTERNATIONAL LEGALIZATION)

use "torture_legalization.dta", clear

*Relable some of variables for presentation purposes
*Treatments
lab var obligation "Obligation"
lab var precision "Precision"
lab var delegation "Delegation"
*Relabel variable as "Veteran" rather than original "Military" since use this label in tables and figures.
lab var military "Veteran"
*Interactions
lab var military_obligation "Veteran x Obligation"
lab var military_precision "Veteran x Precision"
lab var military_delegation "Veteran x Delegation"
*Other Explanatory variables
lab var ideology "Political Ideology"
lab var partyid7 "Partisanship"
lab var ppagecat "Age"
lab var ppeducat "Education"
lab var male "Male"
lab var security "Security Issues"


*Summary statistics for legalization experiment
*All participants
sum torture7 obligation precision delegation military ideology partyid7 ppagecat ppeducat male security white black hispanic
*Civilians
sum torture7 obligation precision delegation military ideology partyid7 ppagecat ppeducat male security white black hispanic if military==0
*Military
sum torture7 obligation precision delegation military ideology partyid7 ppagecat ppeducat male security white black hispanic if military==1


*Set level for confidence intervals to 90% since relatively small number of observations for veterans,
*	especially after taking into account experimental groupings.
set level 90


*Sample: Civilian vs. Military
tab military, mis

*Overall attitudes toward torture
proportion torture2
*Civil vs. Military
prtest torture2, by(military)


*TABLE 1
*Baseline
ologit torture7 military obligation precision delegation ideology partyid7 ppagecat ppeducat male security white black hispanic, nolog
eststo
*Interactions -> each one at a time
*Obligation
ologit torture7 military obligation precision delegation military_obligation ///
	ideology partyid7 ppagecat ppeducat male security white black hispanic, nolog
eststo
*Precision
ologit torture7 military obligation precision delegation military_precision ///
	ideology partyid7 ppagecat ppeducat male security white black hispanic, nolog
eststo
*Delegation
ologit torture7 military obligation precision delegation military_delegation ///
	ideology partyid7 ppagecat ppeducat male security white black hispanic, nolog
eststo
*Command to produce table output
esttab using table1, csv replace b(3) se star (* 0.10 ** 0.05 *** 0.01) ///
	pr2(2) scalars("ll Log Likelihood" "chi2 Chi-squared") compress nogaps label ///
	title("Table 2. Ordered Logit Analysis of Support for Torture (International Legalization Experiment)") ///
	mtitles("Baseline" "Obligation Interaction" "Precision Interaction" "Delegation Interaction") ///
	nonotes addnotes("Standard errors in parentheses." "* p<.10; ** p<.05; *** p<.01." "Cutpoints for ordered logit models not shown.")
eststo clear


*FIGURE 3
*Substantive effects for independent variables from baseline model
estsimp ologit torture3 military obligation precision delegation ideology partyid7 ppagecat ppeducat male security white black hispanic, nolog
*Set obligation to 1 (since low obligation-high delegation combo does not exist), other treatments to 0 
*	and all explanatory variables to their median values (white to 1 and other race variables to 0)
setx obligation 1 (precision delegation) 0 (ideology partyid7 ppagecat ppeducat male security military) median ///
	(white) 1 (black hispanic) 0
*Estimate probability support torture for civilians
setx military 0
simqi, prval(2)
*For veterans
setx military 1
simqi, prval(2)
*Calculate first difference
setx military 0 
simqi, fd(prval(2)) changex(military 0 1)

*Generate overall figure for substantive effects of all variables
*Use standard grayscale scheme
set scheme s1mono
*Use plotfds command
plotfds, continuous(ideology partyid7 ppagecat ppeducat) ///
	discrete(military obligation precision delegation male security white black hispanic) ///
	sort(military obligation precision delegation ideology partyid7 ppagecat ppeducat male security white black hispanic) ///
	outcome(2) clevel(90) nosetx label ///
	xline(0, lcolor(gs12)) msymbol(O) msize(medium) mcolor(black) ylabel(, labsize(small)) /// 
	xlabel(-0.2(0.05)0.1, grid) ///
	note("Results based on Model 1 from Table 2. Values represent first differences" ///
	"for the effect of each variable on the probability of reporting any level of support" ///
	"for torture (either strongly agree, agree, or somewhat agree), while holding obligation" ///
	"as high, precision and delegation as low, and all other independent variables at their" ///
	"medians. Continuous variables are changed from one standard deviation below their mean" ///
	"to one standard deviation above, while dichotomous variables (indicated by a *) change" ///
	"from 0 to 1. Horizontal lines indicate 90% confidence intervals.") ///
	title("Fig 3. Substantive Effects for Determinants of Support for Torture (International Legalization Experiment)", ///
	size(small) position(7))



*FIGURE 4
*Test legalization effects based on civilian-veteran status
*Run interaction models for each legalization component

*Obligation
estsimp ologit torture3 obligation precision delegation ideology partyid7 ppagecat ppeducat male security ///
	military military_obligation white black hispanic, nolog
setx (obligation precision delegation military_obligation) 0 ///
	(ideology partyid7 ppagecat ppeducat male security military) median (white) 1 (black hispanic) 0
*Civilian
setx military 0 
simqi, fd(pr) changex(obligation 0 1)
*Using 90% confidence intervals instead
simqi, fd(pr) changex(obligation 0 1) level(90)
*Military
setx military 1
simqi, fd(pr) changex(obligation 0 1 military_obligation 0 1)
simqi, fd(pr) changex(obligation 0 1 military_obligation 0 1) level(90)

*Precision
estsimp ologit torture3 obligation precision delegation ideology ppagecat partyid7 ppeducat male security ///
	military military_precision white black hispanic, nolog dropsims
setx (obligation precision delegation military_precision) 0 ///
	(ideology partyid7 ppagecat ppeducat male security military) median (white) 1 (black hispanic) 0
*Civilian
setx military 0 
simqi, fd(pr) changex(precision 0 1)
simqi, fd(pr) changex(precision 0 1) level(90)
*Military
*	Note: results slightly weaker (just include 0 in CI's) but in same general direction.
setx military 1
simqi, fd(pr) changex(precision 0 1 military_precision 0 1)
simqi, fd(pr) changex(precision 0 1 military_precision 0 1) level(90)

*Delegation
estsimp ologit torture3 obligation precision delegation ideology ppagecat partyid7 ppeducat male security ///
	military military_delegation white black hispanic, nolog dropsims
*Set obligation to 1 since no cases of high delegation and low precision
setx (precision delegation military_delegation) 0 obligation 1 ///
	(ideology partyid7 ppagecat ppeducat male security military) median (white) 1 (black hispanic) 0
*Civilian
setx military 0 
simqi, fd(pr) changex(delegation 0 1)
simqi, fd(pr) changex(delegation 0 1) level(90)
*Military
setx military 1
simqi, fd(pr) changex(delegation 0 1 military_delegation 0 1)
simqi, fd(pr) changex(delegation 0 1 military_delegation 0 1) level(90)


/*
*Save the generated values into a separate Stata data set

*Run the following commands to generate Figure 4

use "civmil_torture_figure4.dta", clear

*Create new variable that identifies contextgroup uniquely. Have separate space between each group
gen leggroup = group-1 if treatment==1
replace leggroup = group+2 if treatment==2
replace leggroup = group+5 if treatment==3
list leggroup treatment treatment_name group group_name, sepby(treatment)

*Determine max-min values for Y-axis on figure
sum percent upperci lowerci

*Graph command
twoway ///
	(rcap lowerci upperci leggroup if ci_level==90, lcolor(gs7)) ///
	(scatter percent leggroup if group==2 & ci_level==90, msymbol(S) mlcolor(black) msize(medium) mfcolor(black)) ///
	(scatter percent leggroup if group==3 & ci_level==90, msymbol(D) mlcolor(black) msize(medium) mfcolor(white) mlwidth(medthick)), ///
	yscale(range (-0.15 0.15)) ylabel(-0.15(0.05)0.15, grid labsize(small)) ///
	xscale(range (0 9)) ///
	yline(0, lcolor(gs12)) ///
	ytitle("Change in Predicted Probability:" "Agree to Use Torture", size(small)) ///
	xtitle("Dimension of Legalization", size(small)) ///
	legend(label(2 "Civilians") label(3 "Veterans") order(2 3) rows(1) size(small)) ///
	scheme(s1mono) ///
	xlabel(1.5 "Obligation" 4.5 "Precision" 7.5 "Delegation", labsize(small)) ///
	note("Notes: Results are generated from Models 2-4 in Table 2. Y-axis measures the first difference" ///
	"between the treatment and control groups on the probability of reporting any level of support" ///
	"for torture (either strongly agree, agree, or somewhat agree) for each of the obligation, " ///
	"precision, and delegation treatments respectively. First differences are calculated with obligation" ///
	"set to high, precision and delegation to low, and all other independent variables set to their" ///
	"medians. Vertical lines indicate 90% confidence intervals.") ///
	title("Fig 4. Effect of International Legalization on Support for Torture, by Civilian-Veteran Status", position(7) size(small)) 

*/
