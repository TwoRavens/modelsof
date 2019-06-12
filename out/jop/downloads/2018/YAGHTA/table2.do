*** Table2
*** Compares dropping and nondropping 2006 all 2008 VA (2008 LA VA for primary)

clear all

** Set the working directory to where the repliction files are located

cd "/Users/johnkuk/Dropbox/14_GSR/Zoli/Voter ID Law/rebuttal/finalcode"
use "jop_replication.dta", clear



// Table A9
regress votegenval stricty newstrict blackstricty hispstricty asianstricty mixedracestricty  /*
*/ black hispanic asian mixedrace foreignb firstgen age educ inc male married childrenz unionz /*
*/ unemp  ownhome protestant catholic jewish atheist  days_before_election early_in_person vote_by_mail /*
*/ no_excuse_absence_ presidentialelectionyear gubernatorialelectionyear senateelectionyear marginpnew  /*
*/  y2006 y2008 y2010 i.inputstate if voteregpre==1 [pw=weight],  cluster(inputstate)
outreg2 hispstricty using "Table2.xls", replace dec(3) 10pct


** replicate GM models (general elections)

// drop 2006 (all) and 2008 (VA)
gen goodstate = 1
replace goodstate = 0 if year == 2006
replace goodstate = 0 if state == "Virginia" & year == 2008


regress votegenval stricty blackstricty hispstricty asianstricty mixedracestricty  /*
*/ black hispanic asian mixedrace foreignb firstgen age educ inc male married childrenz unionz /*
*/ unemp  ownhome protestant catholic jewish atheist  days_before_election early_in_person vote_by_mail /*
*/ no_excuse_absence_ presidentialelectionyear gubernatorialelectionyear senateelectionyear marginpnew  /*
*/ y2008 y2010 i.inputstate if voteregpre==1 & goodstate == 1 [pw=weight], cluster(inputstate)
outreg2 hispstricty using "Table2.xls", append dec(3) 10pct




*** Primary elections
use "jop_replication.dta", clear

regress voteprival stricty newstrict blackstricty hispstricty asianstricty mixedracestricty  /*
*/ black hispanic asian mixedrace foreignb firstgen age educ inc male married childrenz unionz /*
*/ unemp  ownhome protestant catholic jewish atheist  days_before_election early_in_person vote_by_mail /*
*/ no_excuse_absence_ presidentialelectionyear gubernatorialelectionyear senateelectionyear marginpnew  /*
*/  y2006 y2008 y2010 i.inputstate if voteregpre==1 [pw=weight],  cluster(inputstate)
outreg2 blackstricty hispstricty asianstricty mixedracestricty using "Table2.xls", append dec(3)  10pct


// drop 2006 all and 2008 LA and VA

gen goodstate = 1
replace goodstate = 0 if state == "Louisiana"
replace goodstate = 0 if state == "Virginia"
replace goodstate = 0 if year == 2006

regress voteprival stricty blackstricty hispstricty asianstricty mixedracestricty  /*
*/ black hispanic asian mixedrace foreignb firstgen age educ inc male married childrenz unionz /*
*/ unemp  ownhome protestant catholic jewish atheist  days_before_election early_in_person vote_by_mail /*
*/ no_excuse_absence_ presidentialelectionyear gubernatorialelectionyear senateelectionyear marginpnew  /*
*/ y2008 y2010 i.inputstate if voteregpre==1 & goodstate == 1 [pw=weight], cluster(inputstate)
outreg2 blackstricty hispstricty asianstricty mixedracestricty using "Table2.xls", append dec(3)  10pct
