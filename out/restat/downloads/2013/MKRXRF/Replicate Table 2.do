* this do file generates the results in Table 2 from Siminski (2013) 'Employment Effects of Army Service and Veterans’ Compensation: Evidence from the Australian Vietnam-Era Conscription Lotteries' The Review of Economics and Statistics 95(1): 87–97.

********************************** FIRST STAGE *******************************************************************************

* the first stage data is a frequency weighted file of men (at the times of each ballot) in each combination of birth cohort, ballot outcome (binary), army status (binary), and deployment to Vietnam (binary)
use first_stage, clear

* generate birth cohort dummies 
tabulate cohort, gen(c)

* create birth-cohort specific ballot-outcome IVs
forvalues bcohort = 1/16 {
g z`bcohort' = ballot*c`bcohort'
}
* conduct overidentified army service first stage regression
quietly reg armserv c2-c16 z1-z16 [fw=fweight], robust
est store r_over
test z1 z2 z3 z4 z5 z6 z7 z8 z9 z10 z11 z12 z13 z14 z15 z16
* result of first stage f- test: F = 3973
* keep predicted value
predict double parm

* now just identified version
quietly reg armserv c2-c16 ballot [fw=fweight], robust
est store r_just
test ballot
* keep predicted value
predict double parm2

* conduct overidentified deployment first stage regression
quietly reg vietnam c2-c16 z1-z16 [fw=fweight], robust
est store v_over
test z1 z2 z3 z4 z5 z6 z7 z8 z9 z10 z11 z12 z13 z14 z15 z16
* result of first stage f- test: F = 927
* keep predicted value
predict double pvet

* now just identified version
quietly reg vietnam c2-c16 ballot [fw=fweight], robust
est store v_just
* keep predicted value
predict double pvet2

* run the Angrist-Pischke multivariate-F - step 1 - keep fitted values from one of the 1st stage regressions
quietly reg armserv c2-c16 z1-z16 [fw=fweight], robust
predict rhat
* regress the other endogenous variable on these fitted values and exogenous covariates and keep the residuals
quietly reg vietnam rhat c2-c16 [fw=fweight], robust
predict vresid, residuals
* step 2 regress those residuals on the instruments and exogenous covariates and run an F-test on the instruments
quietly reg vresid z1-z16 c2-c16 [fw=fweight], robust
test z1 z2 z3 z4 z5 z6 z7 z8 z9 z10 z11 z12 z13 z14 z15 z16
* F-stat = 1781

* now repeat for the other variable
* Angrist pischke step 1 - keep fitted values from one of the 1st stage regressions
quietly reg vietnam c2-c16 z1-z16 [fw=fweight], robust
predict vhat
* regress the other endogenous variable on these fitted values and exogenous covariates and keep the residuals
quietly reg armserv vhat c2-c16 [fw=fweight], robust
predict rresid, residuals
* step 2 regress those residuals on the instruments and exogenous covariates and run an F-test on the instruments
quietly reg rresid z1-z16 c2-c16 [fw=fweight], robust
test z1 z2 z3 z4 z5 z6 z7 z8 z9 z10 z11 z12 z13 z14 z15 z16
* F-stat = 931

* now keep predicted values - which are constant within birth cohort/ballot outcome combinations - to be merged onto second stage data later
collapse (mean) parm parm2 pvet pvet2, by(cohort ballot)
save predicted_1st_stage, replace

********************************** REDUCED FORM *******************************************************************************

* the (main) second stage database is a frequency weighted file of men (at 2006) in each combination of birth cohort, ballot outcome (binary) and employment (binary)
use second_stage_employ_census, clear

tabulate cohort, gen(c)
* create birth-cohort specific ballot-outcome IVs
forvalues bcohort = 1/16 {
	g z`bcohort' = ballot*c`bcohort'
	}

* reduced form - 1 IV
quietly reg emp c2-c16 ballot [fw=fweight], robust
est store rf_1

* reduced form - 16 IVs
quietly reg emp c2-c16 z1-z16 [fw=fweight], robust
est store rf_16

esttab r_just v_just rf_1 using Table2.rtf, b(%9.4f) se(%9.4f) parentheses  scalar(N) mtitles wide compress replace keep(ballot)
esttab r_over v_over rf_16 using Table2.rtf, b(%9.4f) se(%9.4f) parentheses  scalar(N) mtitles wide compress append keep(z*)
