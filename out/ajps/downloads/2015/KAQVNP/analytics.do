/* 

%READ THIS FIRST%

This syntax file replicates the analyses in Alan M. Jacobs and J. Scott Matthews, "Policy Attitudes in Institutional Context:
Rules, Uncertainty and the Mass Politics of Investment," American Journal of Political Science, n.d., and in the paper's
supporting information.  For further information, see "readme.txt".

The analyses in this syntax file are presented in the order in which they appear in the paper. Analyses in the supporting information
follow. To generate the analyses, the following files should be located in the current working directory:

policy blueprint coding.do
institutional vignette coding.do
policy blueprint data.dta
institutional vignette data.dta


%Policy Blueprint Experiment%

This command installs the OUTREG2 module, which is used to create the paper's tables.*/

net install outreg2

/* This command creates the variables for analysis by calling the coding file for this study. */

do "policy blueprint coding.do"

/* This command computes the mean of the support index, reported in the "Institutional effects" subsection of the "Policy Blueprint Experiment"
section of the paper. */

sum index if integ==1 & t5==0

/* These commands estimate the regressions reported in Table 2, and also generates that table as a Word document. */

reg index lg ac if integ==1 & t5==0
outreg2 using table2, lab word noaster dec(3) replace ti(Table 2. Policy Blueprint Experiment: Institutional Effects on Social-investment Support) 
reg index lg ac t5 lg_t5 ac_t5 if integ==1
outreg2 using table2, lab word noaster dec(3) append
reg index lg ac cntrl capac lg_cntrl lg_capac ac_cntrl ac_capac if t5==0
outreg2 using table2, lab word noaster dec(3) append
reg index lg ac lessgov lg_lessgov ac_lessgov if integ==1 & t5==0
outreg2 using table2, lab word noaster dec(3) append sortvar(lg ac t5 lg_t5 ac_t5 cntrl capac lg_cntrl lg_capac ac_cntrl ac_capac lessgov lg_lessgov ac_lessgov)

/*

%Institutional Vignette Experiments%

This command creates the variables for analysis by calling the coding file for this study. */

do "institutional vignette coding.do"

/* This command computes the mean of the social investment support measure, reported in the "Institutional effects" subsection of the "Institutional
Vignette Studies" section of the paper. */

sum wtp

/* These commands estimate the regressions reported in Table 3, and also generates that table as a Word document. */

reg wtp inshi if mod2==2 | mod2==3
outreg2 using table3, lab word noaster dec(3) replace ti(Table 3. Institutional Vignette Experiments: Electoral Insulation) 
reg wtp inshi lessgov inshi_lessgov if mod2==2 | mod2==3
outreg2 using table3, lab word noaster dec(3) append

/* These commands estimate the regressions reported in Table 4, and also generates that table as a Word document. */

reg wtp cnsthi if mod2>4
outreg2 using table4, lab word noaster dec(3) replace ti(Table 4. Institutional Vignette Experiments: Constraint) 
reg wtp cnsthi lessgov cnsthi_lessgov if mod2>4
outreg2 using table4, lab word noaster dec(3) append

/* These commands estimate the regressions reported in Table 5, and also generates that table as a Word document. */

reg spnd_uncert cnsthi cnsthi_lessgov lessgov if mod2>4 
outreg2 using table5, lab word noaster dec(3) replace ti(Table 5. Institutional Vignette Experiments: Mediation Analysis) 
reg spnd_uncert inshi inshi_lessgov lessgov if mod2==2 | mod2==3 
outreg2 using table5, lab word noaster dec(3) append sortvar(cnsthi cnsthi_lessgov inshi inshi_lessgov lessgov)

/*

%Supporting Information%

These two commands create the variables analyzed in the Policy Blueprint study and then compute the mean of the institutional
confidence measure, discussed in the "Institutional effects" subsection of the paper and reported in the supporting
information. */

do "policy blueprint coding.do"

sum trust_lg-trust_ml

/* These two commands create the variables analyzed in the Institutional Vignette studies and then compute the mean of 
the political-uncertainty index, reported in the supporting information. */

do "institutional vignette coding.do"

sum spnd_uncert if (mod2==2 | mod2==3) | (mod2>4)

/* These commands create the variables analyzed in the Policy Blueprint study, estimate the regressions reported in Table A1 
in the supporting information, and then generates that table as a Word document. */

do "policy blueprint coding.do"

set more off
for any pk: ren X cont \ ren lg_X lg_cont \ ren ac_X ac_cont
for any cont \ any Control: la var X "Y" \ la var lg_X "Loc. Govt. * Y" \ la var ac_X "Army Corps * Y"
reg index $x cont lg_cont ac_cont if integ==1 & t5==0
outreg2 using tablea1, lab word noaster dec(3) replace ct(Control: $pk) ti(Table A1. Policy Blueprint Experiment: Moderation by Anti-government Beliefs Robustness Tests) 
drop cont lg_cont ac_cont
foreach i of var inc degree black drivmins ln_drivmins woman {
	for any `i': ren X cont \ ren lg_X lg_cont \ ren ac_X ac_cont
	for any cont \ any Control: la var X "Y" \ la var lg_X "Loc. Govt. * Y" \ la var ac_X "Army Corps * Y"
	reg index $x cont lg_cont ac_cont if integ==1 & t5==0
	outreg2 using tablea1, ct(Control: $`i') lab word noaster dec(3) append 
	drop cont lg_cont ac_cont
}

/* These commands create the variables analyzed in the Institutional Vignette studies, estimate the regressions reported in Table A2 
in the supporting information, and then generates that table as a Word document. */

do "institutional vignette coding.do"

set more off
for any pkscale: ren X cont \ ren cnsthi_X cnsthi_cont
for any cont \ any Control: la var X "Y" \ la var cnsthi_X "$cnsthi * Y" 
reg wtp cnsthi lessgov cnsthi_lessgov cont cnsthi_cont if mod2>4
outreg2 using tablea2, lab word noaster dec(3) replace ct(Control: $pkscale) ti(Table A2. Constraint Vignette Experiment: Moderation by Anti-government Beliefs Robustness Tests) 
drop cont cnsthi_cont
foreach i of var income degree black woman {
	for any `i': ren X cont \ ren cnsthi_X cnsthi_cont
	for any cont \ any Control: la var X "Y" \ la var cnsthi_X "$cnsthi * Y" 
	reg wtp cnsthi lessgov cnsthi_lessgov cont cnsthi_cont if mod2>4
	outreg2 using tablea2, ct(Control: $`i') lab word noaster dec(3) append 
	drop cont cnsthi_cont
}

/* These commands create the variables analyzed in the Institutional Vignette studies, estimate the regressions reported in Table A3 
in the supporting information, and then generates that table as a Word document. */

do "institutional vignette coding.do"

set more off
for any income: ren X cont \ ren cnsthi_X cnsthi_cont
for any cont \ any Control: la var X "Y" \ la var cnsthi_X "$cnsthi * Y" 
reg spnd_uncert  cnsthi lessgov cnsthi_lessgov cont cnsthi_cont if mod2>4
outreg2 using tablea3, lab word noaster dec(3) replace ct(Control: $income) ti("Table A3. Constraint Vignette Experiment, Mediation Analysis: Moderation by Anti-government Beliefs Robustness Tests") 
drop cont cnsthi_cont
foreach i of var degree black woman {
	for any `i': ren X cont \ ren cnsthi_X cnsthi_cont
	for any cont \ any Control: la var X "Y" \ la var cnsthi_X "$cnsthi * Y" 
	reg spnd_uncert  cnsthi lessgov cnsthi_lessgov cont cnsthi_cont if mod2>4
	outreg2 using tablea3, ct(Control: $`i') lab word noaster dec(3) append 
	drop cont cnsthi_cont
}

/* These commands create the variables analyzed in both studies, estimate the regressions reported in Table A4 in the 
supporting information, and then generate that table as a Word document. */

do "policy blueprint coding.do"

reg index $x nepcurr rpid dpid woman if integ==1 & t5==0
outreg2 using tablea4, lab word noaster dec(3) replace ct(Policy Blueprint Study) ti(Table A4. Substantive Importance of the Effects) 

do "institutional vignette coding.do"

reg wtp lessgov cnsthi cnsthi_lessgov egalr pep black pkscale if mod2>4
outreg2 using tablea4, lab word noaster dec(3) append ct(Constraint Vignette Study)
