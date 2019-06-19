/*This table uses whether the student wants loans as a dependent variable (5a) 
and reruns our preferred specifications for students who correctly anticipated where they would live
when they filled out their FAFSA (5b) */
/* Note: Formerly Table 6 in previous iterations of the paper */

log using table5_restat.txt, text replace

use mergedcleaned04, clear
append using mergedcleaned00

gen dummy04 = year == 2004

/* localres = residence
   c04092 = residence expectation in '04
   c089 = residence expectation in '00
*/

gen correctexpect = ((localres == 1 & c04092 ==1) |(localres ==2 & c04092 ==2))
replace correctexpect = 1 if (localres==1 & c089==1) | (localres==2 & c089==2)
replace correctexpect = . if year==2004 & (c04092 == -9 | c04092 ==.) 
replace correctexpect = . if year==2000 & (c089== -9 | c089==.)

/* c04038 = interested in loans in '04
   c039 = interested in loans in '00
*/

gen wantloans =  c04038==1
replace wantloans = 1 if c039==1
replace wantloans = . if year==2004 & (c04038 ==. | c04038 == -9)
replace wantloans = . if year==2000 & (c039==. | c039== -9)


/* TABLE 5a */

gen exp_offcampus = c04092 == 2 | c089==2
gen exp_morethantuit = morethantuit
gen exp_getarefund =  exp_offcampus *exp_morethantuit

foreach var of varlist  exp_offcampus exp_getarefund exp_morethantuit{
	replace `var' = . if year==2004 & c04092 == -9 | c04092 == 3
	replace `var' = . if year==2000 & c089 == -9 | c089 ==3
}

reg wantloans exp_offcampus exp_morethantuit exp_getarefund dummy04, robust
outreg using table5a_9903.txt, replace coefastr se 10pct
areg wantloans exp_offcampus exp_morethantuit exp_getarefund female black asian hisp raceoth parhelp_nonmiss nontuithelp_nonmiss parhelp_miss nontuithelp_miss dummy04, absorb(uglvl2) robust
outreg using table5a_9903.txt, append coefastr se 10pct


/* TABLE 5b */
/* first use those who correctly predicted where they would live */
reg allnone offcampus morethantuit getarefund dummy04 if correctexpect == 1, robust
outreg using table5b_9903.txt, replace coefastr se 10pct

areg allnone offcampus morethantuit getarefund female black asian hisp raceoth parhelp_nonmiss nontuithelp_nonmiss parhelp_miss nontuithelp_miss dummy04 if correctexpect == 1, absorb(uglvl2) robust
outreg using table5b_9903.txt, append coefastr se 10pct

/* now use those who predicted incorrectly */
reg allnone offcampus morethantuit getarefund dummy04 if correctexpect == 0, robust
outreg using table5b_9903.txt, append coefastr se 10pct

areg allnone offcampus morethantuit getarefund female black asian hisp raceoth parhelp_nonmiss nontuithelp_nonmiss parhelp_miss nontuithelp_miss dummy04 if correctexpect == 0, absorb(uglvl2) robust
outreg using table5b_9903.txt, append coefastr se 10pct

log close
