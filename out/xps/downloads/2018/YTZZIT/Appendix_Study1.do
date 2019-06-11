**** This file generates tables and notes found in the Appendices for Study 1.

use "Study1_clean.dta", clear


**** Study Appendix Tables

*** Create Labels for Regression Tables
label var treat "Treatment"
label var pidnewR "Party Identification (Republican $\rightarrow$ Democrat)"
label var ageR "Age"
label var female "Female"
label var incomeR "Income"
label var white "White"
label var religiosity "Religiosity"
label var college "College Degree"
label var rep "Republican"

label var concernR "Concern"
label var problemR "Scope of Problem" 
label var r_immR "Immigration Levels"

global control ageR female incomeR white religiosity college


*** Table A.1 Study 1 Summary Statistics
gen r_imm_R2 = (5-r_imm)

su concern problem r_imm_R2 age female white pidnew rep religiosity college if treat !=.
tab incomeR, gen(inc)
su inc* if treat !=.


*** Generate Table A.2 Study 1 Balance Tests

orth_out $control using balance1_dem.tex if rep == 0, by(treat) se pcompare test latex replace
orth_out $control using balance_rep.tex if rep == 1, by(treat) se pcompare test latex replace


** Data for note on K-Smirnov Tests

ksmirnov r_imm, by(rep)
/*

 0:                  0.0000    1.000
 1:                 -0.2703    0.000
 Combined K-S:       0.2703    0.000

 P-Value < 0.000
*/
ksmirnov concernR, by(rep)
/*
 0:                  0.0000    1.000
 1:                 -0.0729    0.018
 Combined K-S:       0.0729    0.036

 P-Value = 0.036
*/





*** Generate Table B.1 Concern For Trafficking

eststo: reg concernR treat if rep == 1, robust 
eststo: reg concernR treat $control if rep == 1, robust 
eststo: reg concernR treat if rep == 0, robust 
eststo: reg concernR treat $control if rep == 0, robust 
eststo: reg concernR treat rep treat_rep, robust 
eststo: reg concernR treat rep treat_rep $control, robust 
esttab using output_concern_robust.tex, ar2(2) b(2) se(2) starlevels(* 0.1 ** .05 *** .01) label replace
eststo clear


***Generate Table B.2 Scope of Trafficking

eststo: reg problemR treat if rep == 1, robust 
eststo: reg problemR treat $control if rep == 1, robust 
eststo: reg problemR treat if rep == 0, robust 
eststo: reg problemR treat $control if rep == 0, robust 
eststo: reg problemR treat rep treat_rep, robust 
eststo: reg problemR treat rep treat_rep $control, robust 
esttab using output_problem_robust.tex, ar2(2) b(2) se(2) starlevels(* 0.1 ** .05 *** .01) label replace
eststo clear


***Generate Table B.3 Immigration Attitudes 

eststo: reg r_immR treat if rep == 1, robust 
eststo: reg r_immR treat $control if rep == 1, robust 
eststo: reg r_immR treat if rep == 0, robust 
eststo: reg r_immR treat $control if rep == 0, robust 
eststo  : reg r_immR treat rep treat_rep, robust
eststo  : reg r_immR treat rep treat_rep $control, robust 
esttab using output_r_immR_robust.tex, ar2(2) b(2) se(2) starlevels(* 0.1 ** .05 *** .01) label replace
eststo clear


** DID CHECK
set more off
eststo  : reg r_immR treat rep treat_rep, robust
eststo  : reg r_immR treat rep treat_rep $control, robust
esttab using did_study1.tex, ar2 b(3) se(3) starlevels(* 0.1 ** .05 *** .01) label replace
eststo clear



