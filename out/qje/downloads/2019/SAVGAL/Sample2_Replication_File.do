*******************************************************************************
*******************************************************************************
*** Title: Every Failed, Try Again, Succeed Better: 
*		   Results from a Randomized Educational Intervention on Grit
*** Authors: Sule Alan, Teodora Boneva, Seda Ertac

*** Notes: This dofile reproduces the results for Sample 2. 
*******************************************************************************
*******************************************************************************
set more off 

*define paths
local path "C:\Data Files"
local path2 "C:\Data Files\Output"
 
*install or load the ritest command
* most recent version can be downloaded at https://raw.githubusercontent.com/simonheb/ritest/master/ritest.ado 
run "`path'\ritest.do"

*open data set 
use "`path'\Sample2_Data.dta", replace
 
*******************************************************************************
*** Table 2: Balancing Table
*******************************************************************************
balancetable grit belief_survey1 grit_survey1 male age raven risk wealth ///
success csize mathscore1 verbalscore1 task_ability  ///
using "`path2'/sample2_table2.tex", replace nonumbers varlabels noobservations pvalues vce(cluster schoolid) ///
ctitles("Control Mean (SD)" "Treatment Mean (SD)" "Difference (p-value)") mean(fmt(%9.2f)) sd(fmt(%9.2f) par([ ])) ///
diff(fmt(%9.2f)) pval(fmt(%9.2f))  

*  generating new variables 
 foreach var of varlist raven risk belief_survey1 grit_survey1 mathscore1 verbalscore1 task_ability {
	gen `var'_c=`var'
	egen m`var'=mean(`var')
	replace `var'_c=m`var' if `var'_c==. 
	drop m`var'
}
 
* label variables 
label var raven_c "Raven Score"
label var risk_c "Risk Tolerance"
label var belief_survey1_c  "Malleability (pre)" 
label var grit_survey1_c "Perseverance (pre)"
label var mathscore1_c "Math score (pre)" 
label var verbalscore1_c "Verbal score (pre)"
label var task_ability_c "Task Ability"
 
* define vector of control variables for analysis of experimental choices and outcomes
local controls male task_ability_c raven_c risk_c mathscore1_c verbalscore1_c /// 
belief_survey1_c grit_survey1_c inconsistent

***************************************************************************************
*** Table 3: Treatment Effect on Choice of Difficult Task 
* Outcome variables: Difficult R1, R2, R3, R4, R5, All difficult, After Failure (only for imposed and failed), Next week 
***************************************************************************************
 
forvalues i=1/5 {
ritest grit  _b, reps(1000) cluster(schoolid) seed(3): logit choicer`i' grit  `controls'
matrix coeffs=r(p)
scalar b0=coeffs[1,1] /*this saves the permuted p-value of the treatment coefficient */
sum choicer`i' if grit==0
scalar b1=r(mean)
logit choicer`i' grit  `controls', cluster(schoolid)
margins, dydx(grit  `controls' ) post
estimates store a`i'
estadd scalar Pvalue=b0
estadd scalar Cmean=b1
}

* All difficult
ritest grit  _b, reps(1000) cluster(schoolid) seed(3): logit alldiff grit  `controls'
matrix coeffs=r(p)
scalar b0=coeffs[1,1]  
sum alldif if grit==0
scalar b1=r(mean)
logit alldiff grit  `controls', cluster(schoolid)
margins, dydx(grit  `controls') post
estimates store a6
estadd scalar Pvalue=b0
estadd scalar Cmean=b1

*Difficult after failure
preserve 
keep if difficult_imposedr1==1 & successr1==0
ritest grit  _b, reps(1000) cluster(schoolid) seed(3): logit choicer2 grit  `controls' 
restore 
matrix coeffs=r(p)
scalar b0=coeffs[1,1] 
sum choicer2 if difficult_imposedr1==1 & successr1==0 & grit==0
scalar b1=r(mean)
logit choicer2 grit  `controls' if difficult_imposedr1==1 & successr1==0, cluster(schoolid)
margins,  dydx(grit  `controls') post
estimates store a7
estadd scalar Pvalue=b0
estadd scalar Cmean=b1

 *Plan for Next Week:
ritest grit  _b, reps(1000) cluster(schoolid) seed(3): logit choicev2 grit `controls'  
matrix coeffs=r(p)
scalar b0=coeffs[1,1] 
sum choicev2 if grit==0 
scalar b1=r(mean)
logit choicev2 grit `controls' , cluster(schoolid)
margins,  dydx(grit `controls' ) post
estimates store a8
estadd scalar Pvalue=b0
estadd scalar Cmean=b1


#delimit ;
esttab  a1 a2 a3 a4 a5 a6 a7 a8
using "`path2'\sample2_table3.tex", replace label compress  b(%8.3f) se(2) noconstant 
title("Treatment Effect on Choice of Difficult Task") star(* 0.1 ** 0.05 *** 0.01) 
nonotes addnotes("Standard errors clustered at the school level. "
"Reported estimates are marginal effects from logit regressions." )
s(Pvalue Cmean N, labels("Permutation p-value" "Control Mean" N) fmt(3 2 0)) keep(grit)
mtitles ("Round 1" "Round 2" "Round 3" "Round 4" "Round 5" "All"  "Failure" "Next") 
;
#delimit cr
 

***************************************************************************************
*Table 4: Treatment Effect on Success and Payoffs 
* Outcome variables: Success R1 (only for imposed), Payoff R1 (controlling for imposed), R2, R3, R4, R5 
***************************************************************************************

preserve
keep if difficult_imposedr1==1
ritest grit  _b, reps(1000) cluster(schoolid) seed(3): logit successr1 grit `controls' 
restore 
matrix coeffs=r(p)
scalar b0=coeffs[1,1] 
sum successr1 if grit==0 & difficult_imposedr1==1
scalar b1=r(mean)
logit successr1 grit `controls' if difficult_imposedr1==1, cluster(schoolid)
margins, dydx(grit `controls') post
estimates store success1
estadd scalar Pvalue=b0
estadd scalar Cmean=b1

ritest grit  _b, reps(1000) cluster(schoolid) seed(3): reg payoffr1 grit `controls' difficult_imposedr1
matrix coeffs=r(p)
scalar b0=coeffs[1,1] 
sum payoffr1 if grit==0
scalar b1=r(mean)
reg payoffr1 grit `controls' difficult_imposedr1, cluster(schoolid)
estimates store payoff1
estadd scalar Pvalue=b0
estadd scalar Cmean=b1

forvalues i=2/5 {
ritest grit  _b, reps(1000) cluster(schoolid) seed(3): reg payoffr`i' grit `controls'
matrix coeffs=r(p)
scalar b0=coeffs[1,1]  
sum payoffr`i' if grit==0
scalar b1=r(mean)
reg payoffr`i' grit `controls', cluster(schoolid)
estimates store payoff`i'
estadd scalar Pvalue=b0
estadd scalar Cmean=b1
}

#delimit ;
esttab success1 payoff1 payoff2 payoff3 payoff4 payoff5 
using "`path2'\sample2_table4.tex", replace label compress  b(%8.3f) se(2) noconstant 
title("Treatment Effect on Success and Payoffs") star(* 0.1 ** 0.05 *** 0.01) 
nonotes addnotes("Standard errors clustered at the school level.")
s(Pvalue Cmean N, labels("Permutation p-value" "Control Mean" N) fmt(3 2 0))
keep(grit)
mtitles ("Success R1" "Round 1" "Round 2" "Round 3" "Round 4" "Round 5") 
;
#delimit cr
 
 
***************************************************************************************
*Table 5: Success and Payoffs in the Second Visit 
* Outcome variables: Succes imposed, Payoff all, imposed, not imposed. total payoff (1st and 2nd visit), Optimal visit 1, Optimal visit 2
***************************************************************************************

preserve 
keep if difficult_imposedv2==1
ritest grit  _b, reps(1000) cluster(schoolid) seed(3):  logit successv2 grit  `controls' 
restore 
matrix coeffs=r(p)
scalar b0=coeffs[1,1]  
sum successv2 if grit==0 & difficult_imposedv2==1
scalar b1=r(mean)
logit successv2 grit  `controls' if difficult_imposedv2==1, cluster(schoolid)
margins,  dydx(grit  `controls') post
estimates store successv2
estadd scalar Pvalue=b0
estadd scalar Cmean=b1

ritest grit  _b, reps(1000) cluster(schoolid) seed(3):  reg payoffv2 grit  `controls' difficult_imposedv2
matrix coeffs=r(p)
scalar b0=coeffs[1,1]  
sum payoffv2 if grit==0
scalar b1=r(mean)
reg payoffv2 grit  `controls' difficult_imposedv2, cluster(schoolid)
estimates store payoffv2
estadd scalar Pvalue=b0
estadd scalar Cmean=b1

preserve
keep if difficult_imposedv2==1 
ritest grit  _b, reps(1000) cluster(schoolid) seed(3):  reg payoffv2 grit  `controls'  
restore
matrix coeffs=r(p)
scalar b0=coeffs[1,1]  
sum payoffv2 if grit==0 & difficult_imposedv2==1
scalar b1=r(mean)
reg payoffv2 grit  `controls'  if difficult_imposedv2==1, cluster(schoolid)
estimates store spec3
estadd scalar Pvalue=b0
estadd scalar Cmean=b1

preserve 
keep  if difficult_imposedv2==0 
ritest grit  _b, reps(1000) cluster(schoolid) seed(3):  reg payoffv2 grit  `controls'
restore 
matrix coeffs=r(p)
scalar b0=coeffs[1,1]  
sum payoffv2 if grit==0 & difficult_imposedv2==0
scalar b1=r(mean)
reg payoffv2 grit  `controls' if difficult_imposedv2==0, cluster(schoolid)
estimates store spec4
estadd scalar Pvalue=b0
estadd scalar Cmean=b1

ritest grit  _b, reps(1000) cluster(schoolid) seed(3):  reg bothpayoffs grit `controls' 
matrix coeffs=r(p)
scalar b0=coeffs[1,1]  
sum bothpayoffs if grit==0
scalar b1=r(mean)
reg bothpayoffs grit `controls', cluster(schoolid)
estimates store spec5
estadd scalar Pvalue=b0
estadd scalar Cmean=b1

***  Optimality analysis 
*Define variables (visit 1) 

*predict success on difficult task and get expected payoff 
logit successr1 `controls' if difficult_imposedr1==1 & grit==0, cluster(schoolid)
predict successr1hatDC
logit successr1 `controls' if difficult_imposedr1==1 & grit==1, cluster(schoolid)
predict successr1hatDT
gen successr1hatD=successr1hatDT if grit==1
replace successr1hatD=successr1hatDC if grit==0
replace successr1hatD=. if successr1==. 
gen exppayoffD=successr1hatD*4

*predict success on easy task and get expected payoff 
logit successr1 `controls' if difficult_imposedr1==0 & playedr1==0 & grit==0, cluster(schoolid)
predict successr1hatEC
logit successr1 `controls' if difficult_imposedr1==0 & playedr1==0 & grit==1, cluster(schoolid)
predict successr1hatET
gen successr1hatE=successr1hatET if grit==1
replace successr1hatE=successr1hatEC if grit==0
replace successr1hatE=. if successr1==. 
gen exppayoffE=successr1hatE*1

*optimal?
gen opt=1 if exppayoffD>=exppayoffE
replace opt=0 if opt==. 
replace opt=. if exppayoffD==. |exppayoffE==. 

*decision optimal?
gen optdecision=1 if opt==1 & choicer1==1
replace optdecision=1 if opt==0 & choicer1==0
replace optdecision=0 if optdecision==.
replace optdecision=. if choicer1==. | opt==. 

 
***VISIT 2 
*predict success on difficult task and get expected payoff 
logit successv2 `controls' if difficult_imposedv2==1 & grit==0, cluster(schoolid)
predict successv2hatDC
logit successv2 `controls' if difficult_imposedv2==1 & grit==1, cluster(schoolid)
predict successv2hatDT
gen successv2hatD=successv2hatDT if grit==1
replace successv2hatD=successv2hatDC if grit==0
replace successv2hatD=. if successv2==. 
gen exppayoffD2=successv2hatD*4

*predict success on easy task and get expected payoff 
logit successv2 `controls' if difficult_imposedv2==0 & playedv2==0 & grit==0, cluster(schoolid)
predict successv2hatEC
logit successv2 `controls' if difficult_imposedv2==0 & playedv2==0 & grit==1, cluster(schoolid)
predict successv2hatET
gen successv2hatE=successv2hatET if grit==1
replace successv2hatE=successv2hatEC if grit==0
replace successv2hatE=. if successv2==. 
gen exppayoffE2=successv2hatE*1

*optimal?
gen opt2=1 if exppayoffD2>=exppayoffE2
replace opt2=0 if opt2==. 
replace opt2=. if exppayoffD2==. |exppayoffE2==. 

*decision optimal?
gen optdecision2=1 if opt2==1 & choicev2==1
replace optdecision2=1 if opt2==0 & choicev2==0
replace optdecision2=0 if optdecision2==.
replace optdecision2=. if choicev2==. | opt2==. 

*generate table

*visit 1
ritest grit  _b, reps(1000) cluster(schoolid) seed(3): logit optdecision grit `controls'
matrix coeffs=r(p)
scalar b0=coeffs[1,1]  
sum optdecision if grit==0
scalar b1=r(mean)
logit optdecision grit `controls', cluster(schoolid)
margins, dydx(grit `controls') post
estimates store spec11
estadd scalar Pvalue=b0
estadd scalar Cmean=b1

*visit 2
ritest grit  _b, reps(1000) cluster(schoolid) seed(3):  logit optdecision2 grit `controls' 
matrix coeffs=r(p)
scalar b0=coeffs[1,1]  
sum optdecision2 if grit==0
scalar b1=r(mean)
logit optdecision2 grit `controls', cluster(schoolid)
margins, dydx(grit `controls') post
estimates store spec21
estadd scalar Pvalue=b0
estadd scalar Cmean=b1


#delimit ;
esttab  successv2 payoffv2 spec3 spec4 spec5 spec11 spec21
using "`path2'\sample2_table5.tex", replace label compress  b(%8.3f) se(2) noconstant 
title("Success and Payoffs in Second Visit") star(* 0.1 ** 0.05 *** 0.01) 
nonotes addnotes("Standard errors clustered at the school level. * p<0.10, ** p<0.05, *** p<0.01"
"Reported estimates in column 1 are marginal effects from logit regression.")
s(Pvalue Cmean N, labels("Permuted p-value" "Control Mean" N) fmt(3 2 0))
keep(grit)
mtitles ("Imposed" "All" "Imposed" "Not Imposed" "Total" "Visit 1" "Visit 2") 
mgroups("Success" "Payoff" "Max", pattern(1 1 0 0 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) 
;
#delimit cr
 

***************************************************************************************
*Table 6: Effect on grades given by teachers
***************************************************************************************

* define control variables for analysis of grades and test scores
local controls1 male raven_c mathscore1_c verbalscore1_c belief_survey1_c grit_survey1_c csize

ritest grit  _b, reps(1000) cluster(schoolid) seed(3):  reg mathgrade2 grit  `controls1'
matrix coeffs=r(p)
scalar b0=coeffs[1,1]  
sum mathgrade2 if grit==0
scalar b1=r(mean)
reg mathgrade2 grit  `controls1', cluster(schoolid) 
estimates store mathgrade
estadd scalar Pvalue=b0
estadd scalar Cmean=b1

ritest grit  _b, reps(1000) cluster(schoolid) seed(3):  reg verbalgrade2 grit  `controls1'
matrix coeffs=r(p)
scalar b0=coeffs[1,1]  
sum  verbalgrade2 if grit==0
scalar b1=r(mean)
reg  verbalgrade2 grit  `controls1', cluster(schoolid) 
estimates store verbalgrade
estadd scalar Pvalue=b0
estadd scalar Cmean=b1

#delimit ;
esttab mathgrade verbalgrade
using "`path2'\sample2_table6.tex", replace label compress  b(%8.3f) se(2) noconstant 
title("Treatment Effect on Follow-up Grades") star(* 0.1 ** 0.05 *** 0.01) 
nonotes addnotes("Standard errors clustered at the school level." "* p<0.10, ** p<0.05, *** p<0.01") 
s(Pvalue Cmean N r2, labels("Permutation p-value" "Control Mean" N R-Squared) fmt(3 2 0 2))
mtitles ("Math Grade" "Verbal Grade")   keep(grit)
;
#delimit cr


***************************************************************************************
* Table 7: Effect on standardized test measures (accounting for attrition) 
***************************************************************************************

*generate weights 
ge attrit=0 if task_ability~=.  /* students we have in the original sample*/
replace attrit=1 if mathscore3==. & task_ability~=. /* students we couldnt find*/
replace attrit=0 if task_ability==. & mathscore3~=. /* students we find but theye were not in original sample*/
logit attrit `controls1', cluster(schoolid)
predict prob1
ge ipw=1/prob1

* short-run effects
ritest grit  _b, reps(1000) cluster(schoolid)  seed(3) force:  reg mathscore2 grit  `controls1' 
matrix coeffs=r(p)
scalar b0=coeffs[1,1] 
sum mathscore2 if grit==0
scalar b1=r(mean)
reg mathscore2 grit  `controls1' , cluster(schoolid) 
estimates store math_short
estadd scalar Pvalue=b0
estadd scalar Cmean=b1
 
ritest grit  _b, reps(1000) cluster(schoolid)  seed(3) force:  reg verbalscore2 grit  `controls1' 
matrix coeffs=r(p)
scalar b0=coeffs[1,1]  
sum verbalscore2  if grit==0
scalar b1=r(mean)
reg verbalscore2  grit  `controls1', cluster(schoolid) 
estimates store verbal_short
estadd scalar Pvalue=b0
estadd scalar Cmean=b1

*long-run effects (accounting for attrition)
ritest grit  _b, reps(1000) cluster(schoolid)  seed(3) force:  reg mathscore3 grit  `controls1' [aw=ipw]
matrix coeffs=r(p)
scalar b0=coeffs[1,1] 
sum mathscore3 if grit==0
scalar b1=r(mean)
reg mathscore3 grit  `controls1' [aw=ipw] , cluster(schoolid) 
estimates store math_long
estadd scalar Pvalue=b0
estadd scalar Cmean=b1
 
ritest grit  _b, reps(1000) cluster(schoolid)  seed(3) force:  reg verbalscore3 grit  `controls1' [aw=ipw] 
matrix coeffs=r(p)
scalar b0=coeffs[1,1]  
sum verbalscore3 if grit==0
scalar b1=r(mean)
reg verbalscore3 grit  `controls1' [aw=ipw] , cluster(schoolid) 
estimates store verbal_long
estadd scalar Pvalue=b0
estadd scalar Cmean=b1

#delimit ;
esttab math_short verbal_short math_long verbal_long
using "`path2'\sample2_table7.tex", replace label compress  b(%8.3f) se(2) noconstant 
title("Treatment Effect on Follow-up Test Scores - Sample B") star(* 0.1 ** 0.05 *** 0.01) 
nonotes addnotes("Standard errors clustered at the school level." "* p<0.10, ** p<0.05, *** p<0.01")  s(Pvalue Cmean N r2, labels("Permutation p-value" "Control Mean" N R-Squared) fmt(3 2 0 2))
mtitles ("Math Score" "Verbal Score" "Math Score" "Verbal Score")  keep(grit)
mgroups("Sample 2" , pattern(1 0 0 0  ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) 

;
#delimit cr
 
 ***************************************************************************************
* APPENDIX TABLES
***************************************************************************************

***************************************************************************************
* Appendix Table A.17: Treatment effect on survey-based measures
* Outcomes: post-treatment grit (survey) and post-treatment beliefs (survey) 
***************************************************************************************
local controls2 male raven_c mathscore1_c verbalscore1_c belief_survey1_c grit_survey1_c risk_c
 
foreach var in grit_survey2 belief_survey2   {

	if "`var'" == "grit_survey2" {
		local l 1
		 }

	 if "`var'" =="belief_survey2"  {
	local l 2
	 }

ritest grit  _b, reps(1000) cluster(schoolid) seed(3): reg `var' grit `controls2'
matrix coeffs=r(p)
scalar b0=coeffs[1,1]  
sum `var' if grit==0
scalar b1=r(mean)
reg `var' grit `controls2', cluster(schoolid)
estimates store survey`l'
estadd scalar Pvalue=b0
estadd scalar Cmean=b1
}

#delimit ;
esttab survey1 survey2  
using "`path2'\sample2_appendix_tableA17.tex", replace label compress  b(%8.3f) se(2) noconstant 
title("Post-Treatment Survey") star(* 0.1 ** 0.05 *** 0.01) 
nonotes addnotes("Standard errors clustered at the school level." "* p<0.10, ** p<0.05, *** p<0.01")  s(Pvalue Cmean N r2, labels("Permutation p-value" "Control Mean" N R-Squared) fmt(3 2 0 2))
mtitles ("Grit (Survey)" "Beliefs (Survey)") keep(grit)
;
#delimit cr
 
 
 ***************************************************************************************
* Figure 1: Plotting coefficients for comparison 
***************************************************************************************
 
#delimit ;
coefplot 

(math_long , keep(grit)  ciopts(recast(rcap) color(navy))  color(navy) citop color(dknavy)  pstyle(p3))
(verbal_long , keep(grit)  ciopts(recast(rcap) color(navy))  color(navy) citop color(dknavy)  pstyle(p3))
(mathgrade, keep(grit)  ciopts(recast(rcap) color(navy))  color(navy) citop color(dknavy)  pstyle(p3))
(verbalgrade, keep(grit)  ciopts(recast(rcap) color(navy))  color(navy) citop color(dknavy)  pstyle(p3))
(survey1, keep(grit)  ciopts(recast(rcap) color(navy))  color(navy) citop color(dknavy)  pstyle(p3))
(survey2, keep(grit)  ciopts(recast(rcap) color(red)) color(red)  citop color(dkred)  )
(a1, keep(grit)  ciopts(recast(rcap) color(navy))  color(navy) citop color(dknavy)  pstyle(p3))
(a2, keep(grit)  ciopts(recast(rcap) color(navy))  color(navy) citop color(dknavy)  pstyle(p3))
(a3, keep(grit)  ciopts(recast(rcap) color(navy))  color(navy) citop color(dknavy)  pstyle(p3))
(a4, keep(grit)  ciopts(recast(rcap) color(navy))  color(navy) citop color(dknavy)  pstyle(p3))
(a5, keep(grit)  ciopts(recast(rcap) color(navy))  color(navy) citop color(dknavy)  pstyle(p3))
(a7, keep(grit)  ciopts(recast(rcap) color(red)) color(red)  citop color(dkred)  )
(a8, keep(grit)  ciopts(recast(rcap) color(navy))  color(navy) citop color(dknavy)  pstyle(p3))
(payoff1, keep(grit)  ciopts(recast(rcap) color(navy))  color(navy) citop color(dknavy)  pstyle(p3))
(successv2, keep(grit)  ciopts(recast(rcap) color(red)) color(red)  citop color(dkred) )
(payoffv2, keep(grit)  ciopts(recast(rcap) color(red)) color(red)  citop color(dkred) )
(spec5, keep(grit)  ciopts(recast(rcap) color(red)) color(red)  citop color(dkred) )
, horizontal   msymbol(d) cismooth

xtitle(Treatment Effects (with 95% CIs)) 
title("Sample 2")

legend(off)
graphregion(color(white))
xline(0, lcolor(black))
ylabel(0.55 "Math Score" 0.604 "Verbal Score" 0.658 "Math Grade" 0.712 "Verbal Grade" 0.766 "Beliefs (survey)" 0.82 "Grit (survey)" 0.878 "Difficult R1" 0.94 "Difficult R2" 1.0 
"Difficult R3" 1.058 "Difficult R4" 1.11 "Difficult R5" 1.17 "After Failure"  1.225 "Next Week" 1.281 "Payoff Round 1" 
 1.335  "Success Visit 2" 1.39 "Payoff Visit 2" 1.445 "Total Payoff" ) 
name(figure2,replace)
;

#delimit cr
 
graph export "`path2'\sample2_figure1.png", replace
graph save "`path2'\sample2_figure1.pgh", replace

graph combine "`path2'\sample1_figure1.pgh" "`path2'\sample2_figure1.pgh", graphregion(color(white))  
graph export "`path2'\figure1.png", replace
graph export "`path2'\figure1.eps", replace

 
***************************************************************************************
* Figures 2 and 3: Beliefs and Grit 
***************************************************************************************

* belief survey
cap drop res2
reg belief_survey2 `controls2', cluster(schoolid)
predict res2, residuals
ksmirnov res2, by(grit)
twoway (kdensity res2 if grit==0, legend(label(1 "Control")) lcolor(gs0) lpattern(solid)) (kdensity res2 if grit==1, legend(label(2 "Treatment"))  lcolor(gs0) lpattern(dash)) , graphregion(color(white)) xtitle("Residuals") ytitle("Kernel Density")  name(kernel12, replace) title("B: Sample 2")   yscale(range(0 .6))   ylabel(0 (.1) .6)
 graph save "`path2'\sample2_figure2.pgh", replace
 
* grit survey 
cap drop res2
reg grit_survey2 `controls2', cluster(schoolid)
predict res2, residuals
ksmirnov res2, by(grit)
twoway (kdensity res2 if grit==0, legend(label(1 "Control"))  lcolor(gs0) lpattern(solid)) (kdensity res2 if grit==1, legend(label(2 "Treatment"))  lcolor(gs0) lpattern(dash)) , graphregion(color(white)) xtitle("Residuals") ytitle("Kernel Density")  name(kernel22, replace) title("B: Sample 2")   yscale(range(0 .6))   ylabel(0 (.1) .6)
graph save "`path2'\sample2_figure3.pgh", replace
 
 ***Combining with Sample 1 graphs
graph combine "`path2'\sample1_figure2.pgh" "`path2'\sample2_figure2.pgh", graphregion(color(white))  
graph export "`path2'\figure2.png", replace
graph export "`path2'\figure2.eps", replace

graph combine "`path2'\sample1_figure3.pgh" "`path2'\sample2_figure3.pgh", graphregion(color(white))  
graph export "`path2'\figure3.png", replace
graph export "`path2'\figure3.eps", replace

 ***************************************************************************************
* APPENDIX TABLES (cont.)
***************************************************************************************

***************************************************************************************
* Appendix Table A.4: Balancing of Baseline Characteristics in Follow-up Sample 
***************************************************************************************
 
tab grit  if mathscore3!=. | verbalscore3!=. 
balancetable grit belief_survey1 grit_survey1 male age raven risk wealth ///
success csize mathscore1 verbalscore1 task_ability if mathscore3!=. | verbalscore3!=.  ///
using "`path2'/sample2_appendix_tableA4.tex", replace nonumbers varlabels noobservations pvalues vce(cluster schoolid) ///
ctitles("Control Mean (SD)" "Treatment Mean (SD)" "Difference (p-value)") mean(fmt(%9.2f)) sd(fmt(%9.2f) par([ ])) ///
diff(fmt(%9.2f)) pval(fmt(%9.2f))  
 
  
*******************************************************************************
*** Appendix Table A.5: Associations in Control Group 
*******************************************************************************

reg mathscore1 raven alldiff if grit==0, cluster(schoolid)
estimates store spec1
reg mathscore1 raven choicev2 if grit==0, cluster(schoolid)
estimates store spec2

reg verbalscore1 raven alldiff if grit==0, cluster(schoolid)
estimates store spec3
reg verbalscore1 raven choicev2 if grit==0, cluster(schoolid)
estimates store spec4 
 
#delimit ;
esttab  spec1 spec2 spec3 spec4  
using "`path2'\sample2_appendix_tableA5.tex", replace label compress  b(%8.3f) se(2) noconstant 
title("Associations in Control Group") star(* 0.1 ** 0.05 *** 0.01) 
nonotes s(r2  N, labels(R-squared N) fmt(2 0))
mtitles ("Math Score" "Math Score" "Verbal Score" "Verbal Score") 
;
#delimit cr


***************************************************************************************
*** Appendix Table A.6: Treatment Effect on Choice of Difficult Task - No inconsistent students
* Outcome variables: Difficult R1, R2, R3, R4, R5, All difficult, After Failure (only for imposed and failed), Next week 
***************************************************************************************

* define new vector of control variables for analysis of experimental choices and outcomes (do not control for inconsistent)
local controls_new male task_ability_c raven_c risk_c mathscore1_c verbalscore1_c ///
belief_survey1_c grit_survey1_c  

forvalues i=1/5 {
preserve
keep if inconsistent!=1
ritest grit  _b, reps(1000) cluster(schoolid) seed(3): logit choicer`i' grit  `controls_new' 
restore 
matrix coeffs=r(p)
scalar b0=coeffs[1,1]  
sum choicer`i' if grit==0 & inconsistent!=1
scalar b1=r(mean)
logit choicer`i' grit  `controls_new' if inconsistent!=1, cluster(schoolid)
margins, dydx(grit  `controls_new' ) post
estimates store a`i'
estadd scalar Pvalue=b0
estadd scalar Cmean=b1
}

* All difficult
preserve
keep if inconsistent!=1
ritest grit  _b, reps(1000) cluster(schoolid) seed(3): logit alldiff grit  `controls_new'
restore
matrix coeffs=r(p)
scalar b0=coeffs[1,1]  
sum alldif if grit==0 & inconsistent!=1
scalar b1=r(mean)
logit alldiff grit  `controls_new' if inconsistent!=1, cluster(schoolid)
margins, dydx(grit  `controls_new') post
estimates store a6
estadd scalar Pvalue=b0
estadd scalar Cmean=b1

*Difficult after failure
preserve 
keep if difficult_imposedr1==1 & successr1==0 &  inconsistent!=1
ritest grit  _b, reps(1000) cluster(schoolid) seed(3): logit choicer2 grit  `controls_new' 
restore 
matrix coeffs=r(p)
scalar b0=coeffs[1,1] 
sum choicer2 if difficult_imposedr1==1 & successr1==0 & grit==0 & inconsistent!=1
scalar b1=r(mean)
logit choicer2 grit  `controls_new' if difficult_imposedr1==1 & successr1==0 & inconsistent!=1, cluster(schoolid)
margins,  dydx(grit  `controls_new') post
estimates store a7
estadd scalar Pvalue=b0
estadd scalar Cmean=b1

 *Plan for Next Week:
preserve
keep if inconsistent!=1
ritest grit  _b, reps(1000) cluster(schoolid) seed(3): logit choicev2 grit `controls_new'  
restore
matrix coeffs=r(p)
scalar b0=coeffs[1,1] 
sum choicev2 if grit==0 & inconsistent!=1
scalar b1=r(mean)
logit choicev2 grit `controls_new' if inconsistent!=1 , cluster(schoolid)
margins,  dydx(grit `controls_new' ) post
estimates store a8
estadd scalar Pvalue=b0
estadd scalar Cmean=b1


#delimit ;
esttab  a1 a2 a3 a4 a5 a6 a7 a8
using "`path2'\sample2_appendix_tableA6.tex", replace label compress  b(%8.3f) se(2) noconstant 
title("Treatment Effect on Choice of Difficult Task - No Inconsistency") star(* 0.1 ** 0.05 *** 0.01) 
nonotes addnotes("Standard errors clustered at the school level. "
"Reported estimates are marginal effects from logit regressions." )
s(Pvalue Cmean N, labels("Permutation p-value" "Control Mean" N) fmt(3 2 0))
mtitles ("Round 1" "Round 2" "Round 3" "Round 4" "Round 5" "All"  "Failure" "Next") 
keep(grit)
;
#delimit cr


***************************************************************************************
*Appendix Table A.7: Success and Payoffs in the Second Visit  - No inconsistent students
* Outcome variables: Succes imposed, Payoff all, imposed, not imposed. total payoff (1st and 2nd visit), Optimal visit 1, Optimal visit 2
***************************************************************************************

preserve 
keep if difficult_imposedv2==1 & inconsistent!=1
ritest grit  _b, reps(1000) cluster(schoolid) seed(3):  logit successv2 grit  `controls_new' 
restore 
matrix coeffs=r(p)
scalar b0=coeffs[1,1]  
sum successv2 if grit==0 & difficult_imposedv2==1 & inconsistent!=1
scalar b1=r(mean)
logit successv2 grit  `controls_new' if difficult_imposedv2==1 & inconsistent!=1, cluster(schoolid)
margins,  dydx(grit  `controls_new') post
estimates store successv2
estadd scalar Pvalue=b0
estadd scalar Cmean=b1

preserve
keep if inconsistent!=1
ritest grit  _b, reps(1000) cluster(schoolid) seed(3):  reg payoffv2 grit  `controls_new' difficult_imposedv2
restore
matrix coeffs=r(p)
scalar b0=coeffs[1,1]  
sum payoffv2 if grit==0 & inconsistent!=1
scalar b1=r(mean)
reg payoffv2 grit  `controls_new' difficult_imposedv2 if inconsistent!=1, cluster(schoolid)
estimates store payoffv2
estadd scalar Pvalue=b0
estadd scalar Cmean=b1

preserve
keep if difficult_imposedv2==1  & inconsistent!=1
ritest grit  _b, reps(1000) cluster(schoolid) seed(3):  reg payoffv2 grit  `controls_new'  
restore
matrix coeffs=r(p)
scalar b0=coeffs[1,1]  
sum payoffv2 if grit==0 & difficult_imposedv2==1 & inconsistent!=1
scalar b1=r(mean)
reg payoffv2 grit  `controls_new'  if difficult_imposedv2==1 & inconsistent!=1, cluster(schoolid)
estimates store spec3
estadd scalar Pvalue=b0
estadd scalar Cmean=b1

preserve 
keep  if difficult_imposedv2==0  & inconsistent!=1
ritest grit  _b, reps(1000) cluster(schoolid) seed(3):  reg payoffv2 grit  `controls_new'
restore 
matrix coeffs=r(p)
scalar b0=coeffs[1,1]  
sum payoffv2 if grit==0 & difficult_imposedv2==0 & inconsistent!=1
scalar b1=r(mean)
reg payoffv2 grit  `controls_new' if difficult_imposedv2==0 & inconsistent!=1, cluster(schoolid)
estimates store spec4
estadd scalar Pvalue=b0
estadd scalar Cmean=b1

preserve
keep if inconsistent!=1
ritest grit  _b, reps(1000) cluster(schoolid) seed(3):  reg bothpayoffs grit `controls_new' 
restore
matrix coeffs=r(p)
scalar b0=coeffs[1,1]  
sum bothpayoffs if grit==0 & inconsistent!=1
scalar b1=r(mean)
reg bothpayoffs grit `controls_new' if inconsistent!=1, cluster(schoolid)
estimates store spec5
estadd scalar Pvalue=b0
estadd scalar Cmean=b1

preserve
keep if inconsistent!=1
ritest grit  _b, reps(1000) cluster(schoolid) seed(3): logit optdecision grit `controls_new'
restore
matrix coeffs=r(p)
scalar b0=coeffs[1,1]  
sum optdecision if grit==0 & inconsistent!=1
scalar b1=r(mean)
logit optdecision grit `controls_new' if inconsistent!=1, cluster(schoolid)
margins, dydx(grit `controls_new') post
estimates store spec11
estadd scalar Pvalue=b0
estadd scalar Cmean=b1

preserve
keep if inconsistent!=1
ritest grit  _b, reps(1000) cluster(schoolid) seed(3):  logit optdecision2 grit `controls_new' 
restore
matrix coeffs=r(p)
scalar b0=coeffs[1,1]  
sum optdecision2 if grit==0 & inconsistent!=1
scalar b1=r(mean)
logit optdecision2 grit `controls_new' if inconsistent!=1, cluster(schoolid)
margins, dydx(grit `controls_new') post
estimates store spec21
estadd scalar Pvalue=b0
estadd scalar Cmean=b1


#delimit ;
esttab  successv2 payoffv2 spec3 spec4 spec5 spec11 spec21
using "`path2'\sample2_appendix_tableA7.tex", replace label compress  b(%8.3f) se(2) noconstant 
title("Success and Payoffs in Second Visit - No inconsistency") star(* 0.1 ** 0.05 *** 0.01) 
nonotes addnotes("Standard errors clustered at the school level. * p<0.10, ** p<0.05, *** p<0.01"
"Reported estimates in column 1 are marginal effects from logit regression.")
s(Pvalue Cmean N, labels("Permuted p-value" "Control Mean" N) fmt(3 2 0))
keep(grit)
mtitles ("Imposed" "All" "Imposed" "Not Imposed" "Total" "Visit 1" "Visit 2") 
mgroups("Success" "Payoff" "Max", pattern(1 1 0 0 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) 
;
#delimit cr

***************************************************************************************
*** Appendix Table A.8: OLS - Treatment Effect on Choice of Difficult Task 
* Outcome variables: Difficult R1, R2, R3, R4, R5, All difficult, After Failure (only for imposed and failed), Next week 
***************************************************************************************
 
forvalues i=1/5 {
ritest grit  _b, reps(1000) cluster(schoolid) seed(3): reg choicer`i' grit  `controls'
matrix coeffs=r(p)
scalar b0=coeffs[1,1] 
sum choicer`i' if grit==0
scalar b1=r(mean)
reg choicer`i' grit  `controls', cluster(schoolid)
estimates store a`i'
estadd scalar Pvalue=b0
estadd scalar Cmean=b1
}

* All difficult
ritest grit  _b, reps(1000) cluster(schoolid) seed(3): reg alldiff grit  `controls'
matrix coeffs=r(p)
scalar b0=coeffs[1,1]  
sum alldif if grit==0
scalar b1=r(mean)
reg alldiff grit  `controls', cluster(schoolid)
estimates store a6
estadd scalar Pvalue=b0
estadd scalar Cmean=b1

*Difficult after failure
preserve 
keep if difficult_imposedr1==1 & successr1==0
ritest grit  _b, reps(1000) cluster(schoolid) seed(3): reg choicer2 grit  `controls' 
restore 
matrix coeffs=r(p)
scalar b0=coeffs[1,1] 
sum choicer2 if difficult_imposedr1==1 & successr1==0 & grit==0
scalar b1=r(mean)
reg choicer2 grit  `controls' if difficult_imposedr1==1 & successr1==0, cluster(schoolid)
estimates store a7
estadd scalar Pvalue=b0
estadd scalar Cmean=b1

 *Plan for Next Week:
ritest grit  _b, reps(1000) cluster(schoolid) seed(3): reg choicev2 grit `controls'  
matrix coeffs=r(p)
scalar b0=coeffs[1,1] 
sum choicev2 if grit==0 
scalar b1=r(mean)
reg choicev2 grit `controls' , cluster(schoolid)
estimates store a8
estadd scalar Pvalue=b0
estadd scalar Cmean=b1


#delimit ;
esttab  a1 a2 a3 a4 a5 a6 a7 a8
using "`path2'\sample2_appendix_tableA8.tex", replace label compress  b(%8.3f) se(2) noconstant 
title("Treatment Effect on Choice of Difficult Task - OLS") star(* 0.1 ** 0.05 *** 0.01) 
nonotes addnotes("Standard errors clustered at the school level. "
"Reported estimates are from OLS regressions." )
s(Pvalue Cmean N, labels("Permutation p-value" "Control Mean" N) fmt(3 2 0))
mtitles ("Round 1" "Round 2" "Round 3" "Round 4" "Round 5" "All"  "Failure" "Next") 
keep(grit)
;
#delimit cr



***************************************************************************************
*Appendix Table A.9: OLS Success and Payoffs in the Second Visit 
* Outcome variables: Succes imposed, Payoff all, imposed, not imposed. total payoff (1st and 2nd visit), Optimal visit 1, Optimal visit 2
***************************************************************************************

preserve 
keep if difficult_imposedv2==1
ritest grit  _b, reps(1000) cluster(schoolid) seed(3): reg successv2 grit  `controls' 
restore 
matrix coeffs=r(p)
scalar b0=coeffs[1,1]  
sum successv2 if grit==0 & difficult_imposedv2==1
scalar b1=r(mean)
reg successv2 grit  `controls' if difficult_imposedv2==1, cluster(schoolid)
estimates store successv2
estadd scalar Pvalue=b0
estadd scalar Cmean=b1

ritest grit  _b, reps(1000) cluster(schoolid) seed(3):  reg payoffv2 grit  `controls' difficult_imposedv2
matrix coeffs=r(p)
scalar b0=coeffs[1,1]  
sum payoffv2 if grit==0
scalar b1=r(mean)
reg payoffv2 grit  `controls' difficult_imposedv2, cluster(schoolid)
estimates store payoffv2
estadd scalar Pvalue=b0
estadd scalar Cmean=b1

preserve
keep if difficult_imposedv2==1 
ritest grit  _b, reps(1000) cluster(schoolid) seed(3):  reg payoffv2 grit  `controls'  
restore
matrix coeffs=r(p)
scalar b0=coeffs[1,1]  
sum payoffv2 if grit==0 & difficult_imposedv2==1
scalar b1=r(mean)
reg payoffv2 grit  `controls'  if difficult_imposedv2==1, cluster(schoolid)
estimates store spec3
estadd scalar Pvalue=b0
estadd scalar Cmean=b1

preserve 
keep  if difficult_imposedv2==0 
ritest grit  _b, reps(1000) cluster(schoolid) seed(3):  reg payoffv2 grit  `controls'
restore 
matrix coeffs=r(p)
scalar b0=coeffs[1,1]  
sum payoffv2 if grit==0 & difficult_imposedv2==0
scalar b1=r(mean)
reg payoffv2 grit  `controls' if difficult_imposedv2==0, cluster(schoolid)
estimates store spec4
estadd scalar Pvalue=b0
estadd scalar Cmean=b1

ritest grit  _b, reps(1000) cluster(schoolid) seed(3):  reg bothpayoffs grit `controls' 
matrix coeffs=r(p)
scalar b0=coeffs[1,1]  
sum bothpayoffs if grit==0
scalar b1=r(mean)
reg bothpayoffs grit `controls', cluster(schoolid)
estimates store spec5
estadd scalar Pvalue=b0
estadd scalar Cmean=b1

*optimality 
*visit 1
ritest grit  _b, reps(1000) cluster(schoolid) seed(3): reg optdecision grit `controls'
matrix coeffs=r(p)
scalar b0=coeffs[1,1]  
sum optdecision if grit==0
scalar b1=r(mean)
reg optdecision grit `controls', cluster(schoolid)
estimates store spec11
estadd scalar Pvalue=b0
estadd scalar Cmean=b1

*visit 2
ritest grit  _b, reps(1000) cluster(schoolid) seed(3):  reg optdecision2 grit `controls' 
matrix coeffs=r(p)
scalar b0=coeffs[1,1]  
sum optdecision2 if grit==0
scalar b1=r(mean)
reg optdecision2 grit `controls', cluster(schoolid)
estimates store spec21
estadd scalar Pvalue=b0
estadd scalar Cmean=b1


#delimit ;
esttab  successv2 payoffv2 spec3 spec4 spec5 spec11 spec21
using "`path2'\sample2_appendix_tableA9.tex", replace label compress  b(%8.3f) se(2) noconstant 
title("Success and Payoffs in Second Visit - OLS") star(* 0.1 ** 0.05 *** 0.01) 
nonotes addnotes("Standard errors clustered at the school level. * p<0.10, ** p<0.05, *** p<0.01"
"Reported estimates are from OLS regressions.")
s(Pvalue Cmean N, labels("Permuted p-value" "Control Mean" N) fmt(3 2 0))
keep(grit)
mtitles ("Imposed" "All" "Imposed" "Not Imposed" "Total" "Visit 1" "Visit 2") 
mgroups("Success" "Payoff" "Max", pattern(1 1 0 0 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) 
;
#delimit cr

***************************************************************************************
*** Appendix Table A.10: No Controls - Treatment Effect on Choice of Difficult Task 
* Outcome variables: Difficult R1, R2, R3, R4, R5, All difficult, After Failure (only for imposed and failed), Next week 
***************************************************************************************
 
forvalues i=1/5 {
ritest grit  _b, reps(1000) cluster(schoolid) seed(3): logit choicer`i' grit   
matrix coeffs=r(p)
scalar b0=coeffs[1,1]  
sum choicer`i' if grit==0
scalar b1=r(mean)
logit choicer`i' grit, cluster(schoolid)
margins, dydx(grit) post
estimates store a`i'
estadd scalar Pvalue=b0
estadd scalar Cmean=b1
}

* All difficult
ritest grit  _b, reps(1000) cluster(schoolid) seed(3): logit alldiff grit  
matrix coeffs=r(p)
scalar b0=coeffs[1,1]  
sum alldif if grit==0
scalar b1=r(mean)
logit alldiff grit, cluster(schoolid)
margins, dydx(grit) post
estimates store a6
estadd scalar Pvalue=b0
estadd scalar Cmean=b1

*Difficult after failure
preserve 
keep if difficult_imposedr1==1 & successr1==0
ritest grit  _b, reps(1000) cluster(schoolid) seed(3): logit choicer2 grit  
restore 
matrix coeffs=r(p)
scalar b0=coeffs[1,1] 
sum choicer2 if difficult_imposedr1==1 & successr1==0 & grit==0
scalar b1=r(mean)
logit choicer2 grit if difficult_imposedr1==1 & successr1==0, cluster(schoolid)
margins,  dydx(grit) post
estimates store a7
estadd scalar Pvalue=b0
estadd scalar Cmean=b1

 *Plan for Next Week:
ritest grit  _b, reps(1000) cluster(schoolid) seed(3): logit choicev2 grit 
matrix coeffs=r(p)
scalar b0=coeffs[1,1] 
sum choicev2 if grit==0 
scalar b1=r(mean)
logit choicev2 grit, cluster(schoolid)
margins,  dydx(grit) post
estimates store a8
estadd scalar Pvalue=b0
estadd scalar Cmean=b1


#delimit ;
esttab  a1 a2 a3 a4 a5 a6 a7 a8
using "`path2'\sample2_appendix_tableA10.tex", replace label compress  b(%8.3f) se(2) noconstant 
title("Treatment Effect on Choice of Difficult Task - No Controls") star(* 0.1 ** 0.05 *** 0.01) 
nonotes addnotes("Standard errors clustered at the school level. "
"Reported estimates are marginal effects from logit regressions." )
s(Pvalue Cmean N, labels("Permutation p-value" "Control Mean" N) fmt(3 2 0))
mtitles ("Round 1" "Round 2" "Round 3" "Round 4" "Round 5" "All"  "Failure" "Next") 
keep(grit)
;
#delimit cr

 
 ***************************************************************************************
* Appendix Table A.11: No controls - Success and Payoffs in the Second Visit 
* Outcome variables: Succes imposed, Payoff all, imposed, not imposed. total payoff (1st and 2nd visit), Optimal visit 1, Optimal visit 2
***************************************************************************************

preserve 
keep if difficult_imposedv2==1
ritest grit  _b, reps(1000) cluster(schoolid) seed(3):  logit successv2 grit 
restore 
matrix coeffs=r(p)
scalar b0=coeffs[1,1]  
sum successv2 if grit==0 & difficult_imposedv2==1
scalar b1=r(mean)
logit successv2 grit if difficult_imposedv2==1, cluster(schoolid)
margins,  dydx(grit) post
estimates store successv2
estadd scalar Pvalue=b0
estadd scalar Cmean=b1

ritest grit  _b, reps(1000) cluster(schoolid) seed(3):  reg payoffv2 grit   difficult_imposedv2
matrix coeffs=r(p)
scalar b0=coeffs[1,1]  
sum payoffv2 if grit==0
scalar b1=r(mean)
reg payoffv2 grit   difficult_imposedv2, cluster(schoolid)
estimates store payoffv2
estadd scalar Pvalue=b0
estadd scalar Cmean=b1

preserve
keep if difficult_imposedv2==1 
ritest grit  _b, reps(1000) cluster(schoolid) seed(3):  reg payoffv2 grit  
restore
matrix coeffs=r(p)
scalar b0=coeffs[1,1]  
sum payoffv2 if grit==0 & difficult_imposedv2==1
scalar b1=r(mean)
reg payoffv2 grit    if difficult_imposedv2==1, cluster(schoolid)
estimates store spec3
estadd scalar Pvalue=b0
estadd scalar Cmean=b1

preserve 
keep  if difficult_imposedv2==0 
ritest grit  _b, reps(1000) cluster(schoolid) seed(3):  reg payoffv2 grit 
restore 
matrix coeffs=r(p)
scalar b0=coeffs[1,1]  
sum payoffv2 if grit==0 & difficult_imposedv2==0
scalar b1=r(mean)
reg payoffv2 grit   if difficult_imposedv2==0, cluster(schoolid)
estimates store spec4
estadd scalar Pvalue=b0
estadd scalar Cmean=b1

ritest grit  _b, reps(1000) cluster(schoolid) seed(3):  reg bothpayoffs grit  
matrix coeffs=r(p)
scalar b0=coeffs[1,1]  
sum bothpayoffs if grit==0
scalar b1=r(mean)
reg bothpayoffs grit, cluster(schoolid)
estimates store spec5
estadd scalar Pvalue=b0
estadd scalar Cmean=b1

ritest grit  _b, reps(1000) cluster(schoolid) seed(3): logit optdecision grit
matrix coeffs=r(p)
scalar b0=coeffs[1,1]  
sum optdecision if grit==0
scalar b1=r(mean)
logit optdecision grit, cluster(schoolid)
margins, dydx(grit) post
estimates store spec11
estadd scalar Pvalue=b0
estadd scalar Cmean=b1

ritest grit  _b, reps(1000) cluster(schoolid) seed(3):  logit optdecision2 grit 
matrix coeffs=r(p)
scalar b0=coeffs[1,1]  
sum optdecision2 if grit==0
scalar b1=r(mean)
logit optdecision2 grit, cluster(schoolid)
margins, dydx(grit) post
estimates store spec21
estadd scalar Pvalue=b0
estadd scalar Cmean=b1


#delimit ;
esttab  successv2 payoffv2 spec3 spec4 spec5 spec11 spec21
using "`path2'\sample2_appendix_tableA11.tex", replace label compress  b(%8.3f) se(2) noconstant 
title("Success and Payoffs in Second Visit - No Controls") star(* 0.1 ** 0.05 *** 0.01) 
nonotes addnotes("Standard errors clustered at the school level. * p<0.10, ** p<0.05, *** p<0.01"
"Reported estimates in column 1 are marginal effects from logit regression.")
s(Pvalue Cmean N, labels("Permuted p-value" "Control Mean" N) fmt(3 2 0))
mtitles ("Imposed" "All" "Imposed" "Not Imposed" "Total" "Visit 1" "Visit 2") 
keep(grit)
mgroups("Success" "Payoff" "Max", pattern(1 1 0 0 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) 
;
#delimit cr



***************************************************************************************
* Appendix Table A.12: Only Basline Test Scores as Controls - 
* Effect on standardized test measures (accounting for attrition) 
***************************************************************************************
* short-run effects
ritest grit  _b, reps(1000) cluster(schoolid)  seed(3) force:  reg mathscore2 grit mathscore1_c verbalscore1_c 
matrix coeffs=r(p)
scalar b0=coeffs[1,1] 
sum mathscore2 if grit==0
scalar b1=r(mean)
reg mathscore2 grit  mathscore1_c verbalscore1_c  , cluster(schoolid) 
estimates store math_short
estadd scalar Pvalue=b0
estadd scalar Cmean=b1
 
ritest grit  _b, reps(1000) cluster(schoolid)  seed(3) force:  reg verbalscore2 grit  mathscore1_c verbalscore1_c 
matrix coeffs=r(p)
scalar b0=coeffs[1,1]  
sum verbalscore2  if grit==0
scalar b1=r(mean)
reg verbalscore2  grit mathscore1_c verbalscore1_c , cluster(schoolid) 
estimates store verbal_short
estadd scalar Pvalue=b0
estadd scalar Cmean=b1

*long-run effects (accounting for attrition)
ritest grit  _b, reps(1000) cluster(schoolid)  seed(3) force:  reg mathscore3 grit mathscore1_c verbalscore1_c  [aw=ipw]
matrix coeffs=r(p)
scalar b0=coeffs[1,1] 
sum mathscore3 if grit==0
scalar b1=r(mean)
reg mathscore3 grit  mathscore1_c verbalscore1_c  [aw=ipw] , cluster(schoolid) 
estimates store math_long
estadd scalar Pvalue=b0
estadd scalar Cmean=b1
 
ritest grit  _b, reps(1000) cluster(schoolid)  seed(3) force:  reg verbalscore3 grit  mathscore1_c verbalscore1_c  [aw=ipw] 
matrix coeffs=r(p)
scalar b0=coeffs[1,1]  
sum verbalscore3 if grit==0
scalar b1=r(mean)
reg verbalscore3 grit  mathscore1_c verbalscore1_c  [aw=ipw] , cluster(schoolid) 
estimates store verbal_long
estadd scalar Pvalue=b0
estadd scalar Cmean=b1

#delimit ;
esttab math_short verbal_short math_long verbal_long
using "`path2'\sample2_appendix_tableA12.tex", replace label compress  b(%8.3f) se(2) noconstant 
title("Treatment Effect on Follow-up Test Scores - Baseline Scores as Controls") star(* 0.1 ** 0.05 *** 0.01) 
nonotes addnotes("Standard errors clustered at the school level." "* p<0.10, ** p<0.05, *** p<0.01")  s(Pvalue Cmean N r2, labels("Permutation p-value" "Control Mean" N R-Squared) fmt(3 2 0 2))
mtitles ("Math Score" "Verbal Score" "Math Score" "Verbal Score") 
mgroups("Sample B" , pattern(1 0 0 0  ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) 

;
#delimit cr
 
 
**************************************************************************************
* Appendix Table A.14: Romano-Wolf p-values
***************************************************************************************
local controls1 male raven_c mathscore1_c verbalscore1_c belief_survey1_c grit_survey1_c csize
 
rwolf mathscore2 verbalscore2 mathscore3 verbalscore3 mathgrade2 verbalgrade2, /// 
indepvar(grit) controls(`controls1') reps(250) cluster(schoolid) seed(3) vce(cluster schoolid)
 
local controls male task_ability_c raven_c risk_c mathscore1_c verbalscore1_c belief_survey1_c grit_survey1_c inconsistent

rwolf belief_survey2 grit_survey2 confidence_survey2 choicer1 choicer2 choicer3 choicer4 choicer5 avpayoffv1 choicev2 payoffv2, ///
indepvar(grit) controls(`controls') reps(250) cluster(schoolid) seed(3) vce(cluster schoolid)


  