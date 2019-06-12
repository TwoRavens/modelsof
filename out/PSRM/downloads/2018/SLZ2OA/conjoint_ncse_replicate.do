set more off

log using "conjoint_ncse_replicate.txt", text replace

use "conjoint_ncse.dta", clear

****************************************
*** TABLES AND FIGURES IN MANUSCRIPT ***
****************************************

*** Table 2: Respondent Characteristics
tabstat res_male res_age res_ccp res_rank res_leader res_interviewer, s(n mean sd min max) c(s)


*** Figure 2: Effects of Candidate Attributes on Probability of Selection
*** (coefficients estimated in Stata; figure plotted in R)
clear matrix
foreach x of varlist male ccp eliteuniv postgrad prize workexp fatherjob {
qui reg win i.`x', cl(ObsID)
mat    coef = e(b)
mat    varr = vecdiag(e(V))
matmap varr se , m(sqrt(@))
mat    coef = coef' , se'
scalar R = rowsof(coef)-1
mat    coef = coef[1..R,1..2]
matrix resmat = nullmat(resmat) \ coef
}
matrix list resmat
mat2txt , matrix(resmat) saving(results/fig_2.txt) replace
matrix drop resmat


*** Figure 3: Effects of Candidate Attributes on Rating of Being “Suitable & Qualified”
*** (coefficients estimated in Stata; figure plotted in R)
foreach x of varlist male ccp eliteuniv postgrad prize workexp fatherjob {
qui reg match i.`x', cl(ObsID)
mat    coef = e(b)
mat    varr = vecdiag(e(V))
matmap varr se , m(sqrt(@))
mat    coef = coef' , se'
scalar R = rowsof(coef)-1
mat    coef = coef[1..R,1..2]
matrix resmat = nullmat(resmat) \ coef
}
matrix list resmat
mat2txt , matrix(resmat) saving(results/fig_3.txt) replace
matrix drop resmat


*** Figure 4: Effects of Candidate Attributes on Ratings of Specific Competence Qualities
*** (coefficients estimated in Stata; figure plotted in R)
foreach x of varlist male ccp eliteuniv postgrad prize workexp fatherjob {
qui reg leader i.`x', cl(ObsID)
mat    coef = e(b)
mat    varr = vecdiag(e(V))
matmap varr se , m(sqrt(@))
mat    coef = coef' , se'
scalar R = rowsof(coef)-1
mat    coef = coef[1..R,1..2]
matrix resmat = nullmat(resmat) \ coef
}
matrix list resmat
mat2txt , matrix(resmat) saving(results/fig_4a.txt) replace
matrix drop resmat

foreach x of varlist male ccp eliteuniv postgrad prize workexp fatherjob {
qui reg implement i.`x', cl(ObsID)
mat    coef = e(b)
mat    varr = vecdiag(e(V))
matmap varr se , m(sqrt(@))
mat    coef = coef' , se'
scalar R = rowsof(coef)-1
mat    coef = coef[1..R,1..2]
matrix resmat = nullmat(resmat) \ coef
}
matrix list resmat
mat2txt , matrix(resmat) saving(results/fig_4b.txt) replace
matrix drop resmat



**************************************
*** TABLES AND FIGURES IN APPENDIX ***
**************************************


*** Table A1: Respondent Characteristics by Sampling Subgroup
tabstat res_male res_age res_ccp res_rank res_leader res_interviewer if online==0, s(n mean sd min max) c(s)
tabstat res_male res_age res_ccp res_rank res_leader res_interviewer if online==1, s(n mean sd min max) c(s)


*** Table A2: Balance of Attribute Values
** Columns (1) and (4)-(9)
foreach var of varlist male ccp eliteuniv postgrad prize workexp fatherjob {
tabstat res_male res_age res_ccp res_rank res_leader res_interviewer, by(`var') s(n mean)
}
** Column (2)
foreach var of varlist male ccp eliteuniv postgrad prize workexp fatherjob {
tabstat res_male res_age res_ccp res_rank res_leader res_interviewer if online==0, by(`var') s(n mean)
}
** Column (3)
foreach var of varlist male ccp eliteuniv postgrad prize workexp fatherjob {
tabstat res_male res_age res_ccp res_rank res_leader res_interviewer if online==1, by(`var') s(n mean)
}


*** Table A3: Estimated AMCEs on Choice and Rating Outcomes
foreach x of varlist male ccp eliteuniv postgrad prize workexp fatherjob {
reg win i.`x', cl(ObsID)
}
foreach x of varlist male ccp eliteuniv postgrad prize workexp fatherjob {
reg match i.`x', cl(ObsID)
}


*** Table A4: Estimated AMCEs on Specific Competence Qualities
foreach x of varlist male ccp eliteuniv postgrad prize workexp fatherjob {
reg leader i.`x', cl(ObsID)
}
foreach x of varlist male ccp eliteuniv postgrad prize workexp fatherjob {
reg implement i.`x', cl(ObsID)
}


*** Table A5: Correlations across Survey Outcomes
pwcorr win match_win, sig
pwcorr match leader implement, sig


*** Figure A4: Heterogeneous Effects of Candidate Attributes on Probability of Selection
*** (coefficients estimated in Stata; figure plotted in R)

** by gender
foreach x of varlist male ccp eliteuniv postgrad prize workexp fatherjob {
qui reg win i.`x' if res_gender==1, cl(ObsID)
mat    coef = e(b)
mat    varr = vecdiag(e(V))
matmap varr se , m(sqrt(@))
mat    coef = coef' , se'
scalar R = rowsof(coef)-1
mat    coef = coef[1..R,1..2]
matrix resmat = nullmat(resmat) \ coef
}
matrix list resmat
mat2txt , matrix(resmat) saving(results/fig_a4_gender1.txt) replace
matrix drop resmat

foreach x of varlist male ccp eliteuniv postgrad prize workexp fatherjob {
qui reg win i.`x' if res_gender==2, cl(ObsID)
mat    coef = e(b)
mat    varr = vecdiag(e(V))
matmap varr se , m(sqrt(@))
mat    coef = coef' , se'
scalar R = rowsof(coef)-1
mat    coef = coef[1..R,1..2]
matrix resmat = nullmat(resmat) \ coef
}
matrix list resmat
mat2txt , matrix(resmat) saving(results/fig_a4_gender2.txt) replace
matrix drop resmat

** by age
foreach x of varlist male ccp eliteuniv postgrad prize workexp fatherjob {
qui reg win i.`x' if res_age<30, cl(ObsID)
mat    coef = e(b)
mat    varr = vecdiag(e(V))
matmap varr se , m(sqrt(@))
mat    coef = coef' , se'
scalar R = rowsof(coef)-1
mat    coef = coef[1..R,1..2]
matrix resmat = nullmat(resmat) \ coef
}
matrix list resmat
mat2txt , matrix(resmat) saving(results/fig_a4_age1.txt) replace
matrix drop resmat

foreach x of varlist male ccp eliteuniv postgrad prize workexp fatherjob {
qui reg win i.`x' if res_age>29, cl(ObsID)
mat    coef = e(b)
mat    varr = vecdiag(e(V))
matmap varr se , m(sqrt(@))
mat    coef = coef' , se'
scalar R = rowsof(coef)-1
mat    coef = coef[1..R,1..2]
matrix resmat = nullmat(resmat) \ coef
}
matrix list resmat
mat2txt , matrix(resmat) saving(results/fig_a4_age2.txt) replace
matrix drop resmat

** by rank
foreach x of varlist male ccp eliteuniv postgrad prize workexp fatherjob {
qui reg win i.`x' if res_rank==1, cl(ObsID)
mat    coef = e(b)
mat    varr = vecdiag(e(V))
matmap varr se , m(sqrt(@))
mat    coef = coef' , se'
scalar R = rowsof(coef)-1
mat    coef = coef[1..R,1..2]
matrix resmat = nullmat(resmat) \ coef
}
matrix list resmat
mat2txt , matrix(resmat) saving(results/fig_a4_rank1.txt) replace
matrix drop resmat

foreach x of varlist male ccp eliteuniv postgrad prize workexp fatherjob {
qui reg win i.`x' if res_rank>1, cl(ObsID)
mat    coef = e(b)
mat    varr = vecdiag(e(V))
matmap varr se , m(sqrt(@))
mat    coef = coef' , se'
scalar R = rowsof(coef)-1
mat    coef = coef[1..R,1..2]
matrix resmat = nullmat(resmat) \ coef
}
matrix list resmat
mat2txt , matrix(resmat) saving(results/fig_a4_rank2.txt) replace
matrix drop resmat

** by personnel authority
foreach x of varlist male ccp eliteuniv postgrad prize workexp fatherjob {
qui reg win i.`x' if res_leader==1|res_interviewer==1, cl(ObsID)
mat    coef = e(b)
mat    varr = vecdiag(e(V))
matmap varr se , m(sqrt(@))
mat    coef = coef' , se'
scalar R = rowsof(coef)-1
mat    coef = coef[1..R,1..2]
matrix resmat = nullmat(resmat) \ coef
}
matrix list resmat
mat2txt , matrix(resmat) saving(results/fig_a4_authority1.txt) replace
matrix drop resmat

foreach x of varlist male ccp eliteuniv postgrad prize workexp fatherjob {
qui reg win i.`x' if res_leader==0 & res_interviewer==0, cl(ObsID)
mat    coef = e(b)
mat    varr = vecdiag(e(V))
matmap varr se , m(sqrt(@))
mat    coef = coef' , se'
scalar R = rowsof(coef)-1
mat    coef = coef[1..R,1..2]
matrix resmat = nullmat(resmat) \ coef
}
matrix list resmat
mat2txt , matrix(resmat) saving(results/fig_a4_authority2.txt) replace
matrix drop resmat


*** Figure A5: Effects of Candidate Attributes on Probability of Selection with Respondent FEs and REs
*** (coefficients estimated in Stata; figure plotted in R)

foreach x of varlist male ccp eliteuniv postgrad prize workexp fatherjob {
qui xtreg win i.`x', cl(ObsID) i(ObsID) fe
mat    coef = e(b)
mat    varr = vecdiag(e(V))
matmap varr se , m(sqrt(@))
mat    coef = coef' , se'
scalar R = rowsof(coef)-1
mat    coef = coef[1..R,1..2]
matrix resmat = nullmat(resmat) \ coef
}
matrix list resmat
mat2txt , matrix(resmat) saving(results/fig_a5a.txt) replace
matrix drop resmat

foreach x of varlist male ccp eliteuniv postgrad prize workexp fatherjob {
qui xtreg win i.`x', cl(ObsID) i(ObsID) re
mat    coef = e(b)
mat    varr = vecdiag(e(V))
matmap varr se , m(sqrt(@))
mat    coef = coef' , se'
scalar R = rowsof(coef)-1
mat    coef = coef[1..R,1..2]
matrix resmat = nullmat(resmat) \ coef
}
matrix list resmat
mat2txt , matrix(resmat) saving(results/fig_a5b.txt) replace
matrix drop resmat


*** Figure A6: Effects of Candidate Attributes on Probability of Selection for Online and Offline Subgroups
*** (coefficients estimated in Stata; figure plotted in R)

foreach x of varlist male ccp eliteuniv postgrad prize workexp fatherjob {
qui reg win i.`x' if online==1, cl(ObsID)
mat    coef = e(b)
mat    varr = vecdiag(e(V))
matmap varr se , m(sqrt(@))
mat    coef = coef' , se'
scalar R = rowsof(coef)-1
mat    coef = coef[1..R,1..2]
matrix resmat = nullmat(resmat) \ coef
}
matrix list resmat
mat2txt , matrix(resmat) saving(results/fig_a6a.txt) replace
matrix drop resmat

foreach x of varlist male ccp eliteuniv postgrad prize workexp fatherjob {
qui reg win i.`x' if online==0, cl(ObsID)
mat    coef = e(b)
mat    varr = vecdiag(e(V))
matmap varr se , m(sqrt(@))
mat    coef = coef' , se'
scalar R = rowsof(coef)-1
mat    coef = coef[1..R,1..2]
matrix resmat = nullmat(resmat) \ coef
}
matrix list resmat
mat2txt , matrix(resmat) saving(results/fig_a6b.txt) replace
matrix drop resmat


*** Figure A7: Effects of Candidate Attributes on Probability of Selection by Task Number
*** (coefficients estimated in Stata; figure plotted in R)

foreach x of varlist male ccp eliteuniv postgrad prize workexp fatherjob {
qui reg win i.`x' if task==1, cl(ObsID)
mat    coef = e(b)
mat    varr = vecdiag(e(V))
matmap varr se , m(sqrt(@))
mat    coef = coef' , se'
scalar R = rowsof(coef)-1
mat    coef = coef[1..R,1..2]
matrix resmat = nullmat(resmat) \ coef
}
matrix list resmat
mat2txt , matrix(resmat) saving(results/fig_a7_1.txt) replace
matrix drop resmat

foreach x of varlist male ccp eliteuniv postgrad prize workexp fatherjob {
qui reg win i.`x' if task==2, cl(ObsID)
mat    coef = e(b)
mat    varr = vecdiag(e(V))
matmap varr se , m(sqrt(@))
mat    coef = coef' , se'
scalar R = rowsof(coef)-1
mat    coef = coef[1..R,1..2]
matrix resmat = nullmat(resmat) \ coef
}
matrix list resmat
mat2txt , matrix(resmat) saving(results/fig_a7_2.txt) replace
matrix drop resmat

foreach x of varlist male ccp eliteuniv postgrad prize workexp fatherjob {
qui reg win i.`x' if task==3, cl(ObsID)
mat    coef = e(b)
mat    varr = vecdiag(e(V))
matmap varr se , m(sqrt(@))
mat    coef = coef' , se'
scalar R = rowsof(coef)-1
mat    coef = coef[1..R,1..2]
matrix resmat = nullmat(resmat) \ coef
}
matrix list resmat
mat2txt , matrix(resmat) saving(results/fig_a7_3.txt) replace
matrix drop resmat

foreach x of varlist male ccp eliteuniv postgrad prize workexp fatherjob {
qui reg win i.`x' if task==4, cl(ObsID)
mat    coef = e(b)
mat    varr = vecdiag(e(V))
matmap varr se , m(sqrt(@))
mat    coef = coef' , se'
scalar R = rowsof(coef)-1
mat    coef = coef[1..R,1..2]
matrix resmat = nullmat(resmat) \ coef
}
matrix list resmat
mat2txt , matrix(resmat) saving(results/fig_a7_4.txt) replace
matrix drop resmat

foreach x of varlist male ccp eliteuniv postgrad prize workexp fatherjob {
qui reg win i.`x' if task==5, cl(ObsID)
mat    coef = e(b)
mat    varr = vecdiag(e(V))
matmap varr se , m(sqrt(@))
mat    coef = coef' , se'
scalar R = rowsof(coef)-1
mat    coef = coef[1..R,1..2]
matrix resmat = nullmat(resmat) \ coef
}
matrix list resmat
mat2txt , matrix(resmat) saving(results/fig_a7_5.txt) replace
matrix drop resmat


*** Figure A8: Effects of Candidate Attributes on Probability of Selection by Profile Position
*** (coefficients estimated in Stata; figure plotted in R)
foreach x of varlist male ccp eliteuniv postgrad prize workexp fatherjob {
qui reg win i.`x' if profile==1, cl(ObsID)
mat    coef = e(b)
mat    varr = vecdiag(e(V))
matmap varr se , m(sqrt(@))
mat    coef = coef' , se'
scalar R = rowsof(coef)-1
mat    coef = coef[1..R,1..2]
matrix resmat = nullmat(resmat) \ coef
}
matrix list resmat
mat2txt , matrix(resmat) saving(results/fig_a8a.txt) replace
matrix drop resmat

foreach x of varlist male ccp eliteuniv postgrad prize workexp fatherjob {
qui reg win i.`x' if profile==2, cl(ObsID)
mat    coef = e(b)
mat    varr = vecdiag(e(V))
matmap varr se , m(sqrt(@))
mat    coef = coef' , se'
scalar R = rowsof(coef)-1
mat    coef = coef[1..R,1..2]
matrix resmat = nullmat(resmat) \ coef
}
matrix list resmat
mat2txt , matrix(resmat) saving(results/fig_a8b.txt) replace
matrix drop resmat

log close
