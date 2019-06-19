/* this file makes tables 2 and 3 by running the regression of all/none on getting a refund check */
/* run 2 create extract files before - now create extract files makes all variables */

log using tables23_restat.txt, text replace

set more off
use mergedcleaned04, clear
append using mergedcleaned00

gen dummy04 = year == 2004

/* with a clean sample: no imputed budgets (zbudget==4) and no imputed
stafford amounts (zstafs==8 or zstafs==9) and students who don't live with their parents (localres==3) */

/* TABLE 2 - the basic specification */

/* first column is the eligible subsample */
reg allnone offcampus dummy04 if morethantuit==1, robust
outreg using table2_9903.txt, replace se coefastr 10pct
/* now on full sample */
reg allnone offcampus morethantuit getarefund dummy04 , robust
outreg using table2_9903.txt, append se coefastr 10pct

/* add gender, ethnicity, and grade level */
areg allnone offcampus morethantuit getarefund female black asian hisp raceoth dummy04 , absorb(uglvl2) robust
outreg using table2_9903.txt, append coefastr se 10pct

/* add parental help measures */
areg allnone offcampus morethantuit getarefund female black asian hisp raceoth parhelp_nonmiss nontuithelp_nonmiss parhelp_miss nontuithelp_miss dummy04 , absorb(uglvl2) robust
outreg using table2_9903.txt, append coefastr se 10pct

/* TABLE 3 - Robustness checks */

/* add controls for selectivity, carnegie classification, and urbanicity */
xi: areg allnone offcampus morethantuit getarefund female black asian hisp raceoth parhelp_nonmiss nontuithelp_nonmiss parhelp_miss nontuithelp_miss i.locale /*i.selectcat*/ type_* dummy04 , absorb(uglvl2) robust
outreg using table3_9903.txt, replace coefastr se 10pct

/* take out those controls, control for additional parental help & parental education */
xi: areg allnone offcampus morethantuit getarefund female black asian hisp raceoth parhelp_nonmiss nontuithelp_nonmiss parhelp_miss nontuithelp_miss smartparent dummy04 , absorb(uglvl2) robust
outreg using table3_9903.txt, append coefastr se 10pct

/*
/* include student controls - GPA, has credit card, college major */
xi: areg allnone offcampus morethantuit getarefund female black asian hisp raceoth parhelp_nonmiss parhelp_miss gpa hascc i.majors12 dummy04  , absorb(uglvl2) robust
outreg using table3_9903.txt, append coefastr se 10pct

/* kitchen sink with all school, parent, and student characteristics */ 
xi: areg allnone offcampus morethantuit getarefund female black asian hisp raceoth parhelp_nonmiss nontuithelp_nonmiss parhelp_miss nontuithelp_miss smartparent gpa hascc i.majors12 i.locale i.selectcat type_* dummy04 , absorb(uglvl2) robust
outreg using table3_9903.txt, append coefastr se 10pct
*/

/* now take out the stuff from the last regression,
add the column at the end with institution level FEs
absorb the grade FEs instead of school FEs */
xi: areg allnone offcampus morethantuit getarefund female black asian hisp raceoth parhelp_nonmiss nontuithelp_nonmiss parhelp_miss nontuithelp_miss i.uglvl2 dummy04 , absorb(instid) robust
outreg using table3_9903.txt, append coefastr se 10pct

log close
