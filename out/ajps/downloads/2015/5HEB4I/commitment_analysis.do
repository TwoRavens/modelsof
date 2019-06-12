*STATA DO FILE FOR ANALYSIS OF MAIN SURVEY EXPERIMENT - "BACKING OUT OR BACKING IN? COMMITMENT AND CONSISTENCY IN AUDIENCE COSTS THEORY"



*** PART I: PRELIMINARIES
clear all
set more off
version 13

*Set to relevant work directory where replication files are saved.
*For example:
cd "C:\Users\EndUser\Dropbox\Commitment and Consistency\Manuscript\AJPS Submission\Replication Files\AJPS Replication Files\"

*Open data set for main survey
use "commitment.dta", clear



**** PART II: MAIN RESULTS

**TABLE 1 summarizing number of respondents for each experimental group.
tab group


**TABLES 2 AND 3: Domestic Political Consequences of Being Inconsistent
proportion approve23, over(group)

*Table 2a) Stay out vs. Back out
prtesti 369 0.5149051  372 .2876344

*Table 2b) Go in  vs. Back in
prtesti 365 .5260274  372 0.4112903

*Table 3a) Stay out vs. Back out/New Info
prtesti 369 0.5149051  378 .6534392

*Table 3b) Go in vs. Back in/New info
prtesti 365 .5260274  370 .5108108



**FIGURE 3: Potential Motives Underlying the Consequences of Inconsistency
	*The output is saved to the data file "commitment_figure3.dta".
	*The do file "commitment_figure3.do" includes the commands to generate Figure 3.

*The analysis focuses on first differences (treatment effects) for inconsistency involving each of the two types of commitment.
	*Positive commitment (Back down vs. Stay out)
	*Negative commitment (Back in vs. Stay in)

*Competence*	
tab competence, mis
tab competence, mis nol
*Create 3-category version (0 = incompentent; 1 = neither; 2 = competent)
gen competence3 = competence
recode competence3 (1/2=0) (3=1) (4/5=2)
tab competence3, mis
lab var competence3 "Competence"

proportion competence3, over(group)
*Focus on percent believing president "incompetent," so in same direction (negative effect of inconsistency) as other mediators below.
*Stay out vs. Back out
prtesti 369 .1273713 372 .4301075
*Stay out vs. Back out/New info
prtesti 369 .1273713 378 .2037037 
*Go in  vs. Back in
prtesti 365 .0739726 372 .1586022
*GO in  vs. Back in/New info
prtesti 365 .0739726 370 .172973

*Reputation*
tab reputation, mis
tab reputation, mis nol
*Create 3-category version (0 = Hurt; 1 = No difference; 2 = Help)
gen reputation3 = reputation
recode reputation3 (1/2=0) (3=1) (4/5=2)
tab reputation3, mis
lab var reputation3 "Reputation"

proportion reputation3, over(group)
*Focus on percentages for "Hurt" reputation
*Stay out vs. Back out
prtesti 369 .2737127  372 .5887097
*Stay out vs. Back out/New info
prtesti 369 .2737127 378 .3756614 
*Go in  vs. Back in
prtesti 365 .2684932  372 .3413978
*Go in  vs. Back in/New info
prtesti 365 .2684932  370  .3378378

*Crebility of U.S. promises*
*Likelihood other countries will believe future U.S. promises
tab credib, mis
tab credib, mis nol
*Create 2-category version (0 = Unlikely; 1 = Likely)
gen credib2 = credib
recode credib2 (1/2=0) (3/4=1)
tab credib2, mis
lab var credib2 "Credibility of U.S. Promises"

proportion credib2, over(group)
*Focus on percentage that think "less likely" other countries will believe U.S. promises
*Stay out vs. Back out
prtesti 369 .3468835  372 .6962366
*Stay out vs. Back out/New info
prtesti 369 .3468835 378 .5185185
*Go in  vs. Back in
prtesti 365 .0794521  372 .4112903
*Go in  vs. Back in/New info
prtesti 365 .0794521  370  .3216216



*** PART III: RESULTS IN FOOTNOTES

**Results in FN.13**
* Command for Balance Tests
mlogit group male agecat educ registered voter partyid7 military activist


**Results in FN.21: Bootstrap Standard Errors
** Overall Results
tab group
proportion approve23, over(group)
bys group: sum approve27
proportion approve23, over(group)
local d1 = [Approve]_subpop_4 - [Approve]_subpop_1
di `d1'
preserve
qui { /* Sub-routine that runs the bootstrap and stores the results */
tempname memhold
tempfile results
postfile `memhold' rep1 using `results'
set seed 12345
local i 1
while `i' <=(1000) {
gen freq=1 
bsample, weight(freq)
proportion approve23 [fw=freq], over(group)
local diff1 = [Approve]_subpop_4 - [Approve]_subpop_1
post `memhold' (`diff1')
drop freq 
local i = `i' +1
}
} /* End of quiet */
postclose `memhold' /* Commands to load the stored results */
use `results' , clear
rename rep1 diff1
_pctile diff1, p(2.5,97.5) /* Compute the 0.95 Confidence interval of the difference in proportions*/
local low1 = r(r1)
local hi1 = r(r2)
/* Report the difference in proportions, along with the confidence interval */
di in yellow `d1' in green " [ " in yellow `hi1' in green " , " in yellow `low1' in green " ]"
restore


**Results in FN.23
*Test Differences in Differences
gen approveDDT = 0
replace approveDDT = 1 if approve23==2
gen change_policy = 0 if group==1 | group==2 | group==4 | group==6
replace change_policy = 1 if group==2 | group==4
gen Out_outcome = 0 if group==1 | group==2 | group==4 | group==6
replace Out_outcome = 1 if group==1 | group==4
gen interaction = Out_outcome*change_policy
sum approveDDT if group==1 /* Column 1 of Table 2(a) */
local m1 = r(mean)
sum approveDDT if group==4 /* Column 2 of Table 2(a) */
local m2 = r(mean)
local diff1 = `m2' - `m1' 
di `diff1' /*Note: this should match the `change_policy' coefficient in the following regression */
reg approveDDT change_policy if group==1 | group==4
sum approveDDT if group==2 
local m1 = r(mean)
sum approveDDT if group==6 
local m2 = r(mean)
local diff2 = `m1' - `m2' 
di `diff2' /*Note: this should match the `change_policy' coefficient in the following regression */
reg approveDDT change_policy if group==2 | group==6
di `diff1' - `diff2' /*Note: this should match the interaction term's coefficient in the following regression */
reg approveDDT change_policy Out_outcome interaction
** Note: coefficient on interaction is statistically significant from zero.  This means the difference in differences is statistically significant!


** Results in FN.26 
**TABLES 2 AND 3: Domestic Political Consequences of Being Inconsistent
proportion approve23, over(group)
* Back in v. Back in/New info
prtesti 372 0.4112903  370 .5108108


**Results IN FN.27**
*Analysis for follow-up question in the two baseline inconsistency conditions (Back out / Back in) who did not receive
*	the "new information" prompt on beliefs the president actually received new information.
*Proportion for each group -> sum together the proportions for the "Somewhat likely" and "Very likely" answer options.
tab group
proportion backin_probnewinfo
proportion backout_probnewinfo
*Test for difference in proportions
prtesti 372 0.8521 372 0.7715



*** PART IV: RESULTS IN SUPPLEMENTARY APPENDICES**

*TABLE B.1: Descriptive Statistics for Socio-Demographic Covariates in mTurk Experiment
sum male agecat educ registered voter partyid7 military activist


*TABLE B.2: Variable Means, by Experimental Condition
bys group: sum male agecat educ registered voter partyid7 military activist


*TABLE B.3: Comparison of Characteristics of Current Population Survey (CPS) to mTurk Sample
*	Used in Commitment and Consistency Experiment (June-August 2014)
tab1 male agecat educ military
*Values for the U.S. adult population benchmarks come from the June though August series of the CPS.



***OLS REGRESSION RESULTS PRESENTED IN SUPPLEMENTARY APPENDIX C***
*Create separate binary variable for each experimental condition.
tab group, mis
gen stayout = 0 
replace stayout = 1 if group==1
gen backin = 0
replace backin = 1 if group==2
gen backin_newinfo = 0
replace backin_newinfo = 1 if group==3
gen backout = 0
replace backout = 1 if group==4
gen backout_newinfo = 0
replace backout_newinfo = 1 if group==5
gen goin = 0
replace goin = 1 if group==6
tab1 group stayout-goin, mis


*TABLE C.1
*OLS Analysis of Commitments and Consistency, Socio-Demographic Variables Included

*Baseline model
reg approve27 backin backin_newinfo backout backout_newinfo goin
eststo

*With Additional Covariates Included
reg approve27 backin backin_newinfo backout backout_newinfo goin ///
	male agecat educ registered voter partyid7 military activist 
eststo

*Wald tests for equality of relevant coefficients compared to relevant control for treatment conditions.
test backout = 0
test backout_newinfo = 0
test goin = backin
test goin = backin_newinfo

*Generate Table C.1
esttab using table1, csv replace b(3) se star (* 0.10 ** 0.05 *** 0.01) ///
	r2(2) /* scalars("ll Log Likelihood" "chi2 Chi-squared") */ compress nogaps label ///
	title("Table C.1: OLS Analysis of Commitments and Consistency, (Socio-Demographic Variables Included)") ///
	nonotes addnotes("Standard errors in parentheses." "* p<.10; ** p<.05; *** p<.01." ///
	"Baseline group excluded for the experimental conditions is 'Stay Out.'")
eststo clear


*TABLE C.2
*Analysis of Commitments and Consistency, Baseline Model Subsampled by Gender and Education	

*Baseline - All Respondents
reg approve27 backin backin_newinfo backout backout_newinfo goin
eststo

*Gender
tab male, mis
*Men
reg approve27 backin backin_newinfo backout backout_newinfo goin if male==1
eststo
*Women
reg approve27 backin backin_newinfo backout backout_newinfo goin if male==0
eststo

*Education (cutoff for education was based on the median value of the sample)
tab educ, mis
*College degree or higher
reg approve27 backin backin_newinfo backout backout_newinfo goin if educ==4
eststo
*Less than college degree
reg approve27 backin backin_newinfo backout backout_newinfo goin if educ<=3
eststo

*Generate Table C.2
esttab using table1, csv replace b(3) se star (* 0.10 ** 0.05 *** 0.01) ///
	r2(2) /* scalars("ll Log Likelihood" "chi2 Chi-squared") */ compress nogaps label ///
	title("Table #: OLS Analysis of Commitments and Consistency, (Socio-Demographic Variables Included)") ///
	mtitles("Baseline" "Men" "Women" "College Degree or More" "Less than College Degree") ///
	nonotes addnotes("Standard errors in parentheses." "* p<.10; ** p<.05; *** p<.01." ///
	"The cutoff distinguishing the level of education was based on the median value for the sample.")
eststo clear


*TABLE C.3
*Regression Analysis of Potential Mechanisms Underlying the Consequences of 
*	Inconsistency, Socio-Demographic Variables Included

*Competence
reg competence backin backin_newinfo backout backout_newinfo goin ///
	male agecat educ registered voter partyid7 military activist 
eststo
*Wald tests for equality of relevant coefficients
test backout = 0
test backout_newinfo = 0
test goin = backin
test goin = backin_newinfo

*Reputation
reg reputation backin backin_newinfo backout backout_newinfo goin ///
	male agecat educ registered voter partyid7 military activist 
eststo
*Wald tests for equality of relevant coefficients
test backout = 0
test backout_newinfo = 0
test goin = backin
test goin = backin_newinfo

*Credibility
reg credib backin backin_newinfo backout backout_newinfo goin ///
	male agecat educ registered voter partyid7 military activist 
eststo
*Wald tests for equality of relevant coefficients
test backout = 0
test backout_newinfo = 0
test goin = backin
test goin = backin_newinfo

*Generate Table C.3
esttab using table1, csv replace b(3) se star (* 0.10 ** 0.05 *** 0.01) ///
	r2(2) pr2(2) /* scalars("ll Log Likelihood" "chi2 Chi-squared") */ compress nogaps label ///
	title("Table #: OLS Analysis of Commitments and Consistency, (Socio-Demographic Variables Included)") ///
	mtitle("Competence" "Reputation" "Credibility") ///
	nonotes addnotes("Standard errors in parentheses." "* p<.10; ** p<.05; *** p<.01." ///
	"Baseline group excluded for the experimental conditions is 'Stay Out.'")
eststo clear



**END OF REPLICATION ANALYSIS FOR MAIN SURVEY**

