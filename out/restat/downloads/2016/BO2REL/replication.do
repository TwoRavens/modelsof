/* Replication file for "Test Score Measurement and the Black-White Test Score 
Gap" by Jeffrey Penney. This program produces Table 2 in the paper.

This program requires the user-written command "rifreg" to be installed. It can 
be obtained here:

http://faculty.arts.ubc.ca/nfortin/datahead.html 

Fk denotes the fall of the kindergarten grade, Sk denotes the spring of the
kindergarten grade, S1 denotes the spring of first grade, etc. */

// ===== setup =====

capture log close
set more off
clear all

global SOURCE "enter desired working directory here (where the replication files are)"
cd $SOURCE

log using "replication.smcl", replace

use "replication.dta"

// generate vectors where results will be stored
foreach j in math read {
foreach k in Fk Sk S1 S3 S5 8 {
generate `j'`k'_OLS = .
label variable `j'`k'_OLS "OLS estimate for `j' in Grade `k'"
generate `j'`k'_UQR = .
label variable `j'`k'_UQR "Unconditional quantile regression estimate for `j' in Grade `k'"
generate `j'`k'_norm = .
label variable `j'`k'_norm "Proposed normalization estimate for `j' in Grade `k'"
}
}
// generate variable to contain results
egen results = fill(1 2 3)

// ===== regressions =====

// obtain the OLS coefficient estimates
foreach j in math read {
foreach k in Fk Sk S1 S3 S5 8 {
regress z`j'`k' black hispanic asian other ses books books2 female ///
	kinderage teenmom thirtymom wicFk bweight, vce(robust)
replace `j'`k'_OLS = _b[black] in 1	
}
}
// unconditional quantile regressions
foreach j in math read {
foreach k in Fk Sk S1 S3 S5 8 {
rifreg z`j'`k' black hispanic asian other ses books books2 female ///
	kinderage teenmom thirtymom wicFk bweight, q(0.5)
// retrieve the z-normalized UQR coefficient for blacks
replace `j'`k'_UQR = _b[black] in 1
// retrieve the proposed normalization coefficient for blacks
replace `j'`k'_norm = _b[black]/e(rmse) in 1
}
}
// ===== results =====

// keep the first observation, which contains all the results
drop if results>1

// keep relevant variables
keep mathFk_OLS mathSk_OLS mathS1_OLS mathS3_OLS mathS5_OLS math8_OLS ///
	mathFk_UQR mathSk_UQR mathS1_UQR mathS3_UQR mathS5_UQR math8_UQR ///
	mathFk_norm mathSk_norm mathS1_norm mathS3_norm mathS5_norm math8_norm ///
	readFk_OLS readSk_OLS readS1_OLS readS3_OLS readS5_OLS read8_OLS ///
	readFk_UQR readSk_UQR readS1_UQR readS3_UQR readS5_UQR read8_UQR ///
	readFk_norm readSk_norm readS1_norm readS3_norm readS5_norm read8_norm
	
log close
