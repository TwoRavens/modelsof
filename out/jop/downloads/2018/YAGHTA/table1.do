*** Table 1
*** Compares HLN and GM main regression results

** Set the working directory to where the repliction files are located
cd "/Users/johnkuk/Dropbox/14_GSR/Zoli/Voter ID Law/rebuttal/finalcode"
use "jop_replication.dta", clear

**
** general elections first
**


** HLN 2017 Table 1
regress votegenval stricty newstrict blackstricty hispstricty asianstricty mixedracestricty /*
*/ black hispanic asian mixedrace foreignb firstgen age educ inc male married childrenz unionz /*
*/ unemp ownhome protestant catholic jewish atheist /*
*/ days_before_election early_in_person vote_by_mail no_excuse_absence_ /*
*/ presidentialelectionyear  gubernatorialelectionyear senateelectionyear marginpnew /*
*/ y2006 y2008 y2010 if voteregpre==1   [pw=weight] ,  cluster(inputstate)
outreg2 hispstricty using "Table1.xls", replace dec(3) 10pct


** Democrats Only
regress votegenval stricty newstrict blackstricty hispstricty asianstricty mixedracestricty /*
*/ black hispanic asian mixedrace foreignb firstgen age educ inc male married childrenz unionz /*
*/ unemp ownhome protestant catholic jewish atheist /*
*/ days_before_election early_in_person vote_by_mail no_excuse_absence_ /*
*/ presidentialelectionyear gubernatorialelectionyear senateelectionyear marginpnew /*
*/ y2006 y2008 y2010 if voteregpre==1 & dem==1 [pw=weight] ,  cluster(inputstate)
outreg2 hispstricty using "Table1.xls", append dec(3) 10pct


** Extra political controls
regress votegenval stricty newstrict blackstricty hispstricty asianstricty mixedracestricty /*
*/ black hispanic asian mixedrace foreignb firstgen age educ inc male married childrenz unionz /*
*/ unemp ownhome protestant catholic jewish atheist /*
*/ days_before_election early_in_person vote_by_mail no_excuse_absence_ /*
*/ presidentialelectionyear gubernatorialelectionyear senateelectionyear  marginpnew /*
*/ y2006 y2008 y2010 spending dem_house dem_senate dempnew dem_governor /*
*/ if voteregpre==1   [pw=weight] ,  cluster(inputstate)
outreg2 hispstricty using "Table1.xls", append dec(3) 10pct

** Extra demographic controls
regress votegenval stricty newstrict blackstricty hispstricty asianstricty mixedracestricty /*
*/ black hispanic asian mixedrace foreignb firstgen age educ inc male married childrenz unionz /*
*/unemp ownhome protestant catholic jewish atheist /*
*/ days_before_election early_in_person vote_by_mail no_excuse_absence_ /*
*/ presidentialelectionyear gubernatorialelectionyear senateelectionyear  marginpnew /*
*/ y2006 y2008 y2010  church_attendence born_again relig_importance news_interest /*
*/ if voteregpre==1   [pw=weight] ,  cluster(inputstate)
outreg2 hispstricty using "Table1.xls", append dec(3) 10pct

** Control South
regress votegenval stricty newstrict blackstricty hispstricty asianstricty mixedracestricty /*
*/ black hispanic asian mixedrace foreignb firstgen age educ inc male married childrenz unionz /*
*/ unemp ownhome protestant catholic jewish atheist /*
*/ days_before_election early_in_person vote_by_mail no_excuse_absence_ /*
*/ presidentialelectionyear gubernatorialelectionyear senateelectionyear marginpnew /*
*/ y2006 y2008 y2010 southz if voteregpre==1  [pw=weight] ,  cluster(inputstate)
outreg2 hispstricty using "Table1.xls", append dec(3) 10pct


*** Table A9 with sample weight, cluster se
regress votegenval stricty newstrict blackstricty hispstricty asianstricty mixedracestricty  /*
*/ black hispanic asian mixedrace foreignb firstgen age educ inc male married childrenz unionz /*
*/ unemp ownhome protestant catholic jewish atheist  days_before_election early_in_person vote_by_mail /*
*/ no_excuse_absence_ presidentialelectionyear gubernatorialelectionyear senateelectionyear marginpnew  /*
*/ y2006 y2008 y2010 i.inputstate /*
*/ if voteregpre==1 [pw=weight] ,  cluster(inputstate)
outreg2 hispstricty using "Table1.xls", append dec(3) 10pct


** replicate GM models

// drop 2006 (all) and 2008 (VA)
gen goodstate = 1
replace goodstate = 0 if year == 2006
replace goodstate = 0 if state == "Virginia" & year == 2008

*** Table A9 with sample weight, cluster se and exclude 2006 all 2008 VA
regress votegenval stricty blackstricty hispstricty asianstricty mixedracestricty  /*
*/ black hispanic asian mixedrace foreignb firstgen age educ inc male married childrenz unionz /*
*/ unemp ownhome protestant catholic jewish atheist  days_before_election early_in_person vote_by_mail /*
*/ no_excuse_absence_ presidentialelectionyear gubernatorialelectionyear senateelectionyear marginpnew  /*
*/ y2008 y2010 i.inputstate /*
*/ if voteregpre==1 & goodstate==1 [pw=weight] ,  cluster(inputstate)
outreg2 hispstricty using "Table1.xls", append dec(3) 10pct

// don't condition on voteregpre, drop 2006 all 2008 VA include newstrict
regress votegenval stricty blackstricty hispstricty asianstricty mixedracestricty  /*
*/ black hispanic asian mixedrace foreignb firstgen age educ inc male married childrenz unionz /*
*/ unemp ownhome protestant catholic jewish atheist  days_before_election early_in_person vote_by_mail /*
*/ no_excuse_absence_ presidentialelectionyear gubernatorialelectionyear senateelectionyear marginpnew  /*
*/ y2008 y2010 i.inputstate /*
*/ if goodstate==1 [pw=weight] ,  cluster(inputstate)
outreg2 hispstricty using "Table1.xls", append dec(3) 10pct


// + replace missings w/ zeros
replace votegenval = 0 if missing(votegenval)
regress votegenval stricty blackstricty hispstricty asianstricty mixedracestricty  /*
*/ black hispanic asian mixedrace foreignb firstgen age educ inc male married childrenz unionz /*
*/ unemp  ownhome protestant catholic jewish atheist  days_before_election early_in_person vote_by_mail /*
*/ no_excuse_absence_ presidentialelectionyear gubernatorialelectionyear senateelectionyear marginpnew  /*
*/  y2008 y2010 i.inputstate if goodstate == 1  [pw=weight], cluster(inputstate)
outreg2 hispstricty using "Table1.xls", append dec(3) 10pct




**
** primary elections
**

use "jop_replication.dta", clear

** HLN 2017 Table 1
regress voteprival stricty newstrict blackstricty hispstricty asianstricty mixedracestricty /*
*/ black hispanic asian mixedrace foreignb firstgen age educ inc male married childrenz unionz /*
*/ unemp ownhome protestant catholic jewish atheist /*
*/ days_before_election early_in_person vote_by_mail no_excuse_absence_ /*
*/ presidentialelectionyear gubernatorialelectionyear senateelectionyear marginpnew /*
*/ y2006 y2008 y2010 if voteregpre==1   [pw=weight] ,  cluster(inputstate)
outreg2 blackstricty hispstricty asianstricty mixedracestricty using "Table1.xls", append dec(3) 10pct

** Democrats only
regress voteprival stricty newstrict blackstricty hispstricty asianstricty mixedracestricty /*
*/ black hispanic asian mixedrace foreignb firstgen age educ inc male married childrenz unionz /*
*/ unemp ownhome protestant catholic jewish atheist /*
*/ days_before_election early_in_person vote_by_mail no_excuse_absence_ /*
*/ presidentialelectionyear gubernatorialelectionyear senateelectionyear marginpnew /*
*/ y2006 y2008 y2010 if voteregpre==1 & dem==1 [pw=weight] ,  cluster(inputstate)
outreg2 blackstricty hispstricty asianstricty mixedracestricty using "Table1.xls", append dec(3) 10pct

** Extra political controls
regress voteprival stricty newstrict blackstricty hispstricty asianstricty mixedracestricty /*
*/ black hispanic asian mixedrace foreignb firstgen age educ inc male married childrenz unionz /*
*/ unemp ownhome protestant catholic jewish atheist /*
*/ days_before_election early_in_person vote_by_mail no_excuse_absence_ /*
*/ presidentialelectionyear gubernatorialelectionyear senateelectionyear  marginpnew /*
*/ y2006 y2008 y2010 spending dem_house dem_senate dempnew dem_governor /*
*/ if voteregpre==1   [pw=weight] ,  cluster(inputstate)
outreg2 blackstricty hispstricty asianstricty mixedracestricty using "Table1.xls", append dec(3) 10pct

** Extra demographic controls
regress voteprival stricty newstrict blackstricty hispstricty asianstricty mixedracestricty /*
*/ black hispanic asian mixedrace foreignb firstgen age educ inc male married childrenz unionz /*
*/unemp ownhome protestant catholic jewish atheist /*
*/ days_before_election early_in_person vote_by_mail no_excuse_absence_ /*
*/ presidentialelectionyear gubernatorialelectionyear senateelectionyear  marginpnew /*
*/ y2006 y2008 y2010  church_attendence born_again relig_importance news_interest /*
*/ if voteregpre==1   [pw=weight] ,  cluster(inputstate)
outreg2 blackstricty hispstricty asianstricty mixedracestricty using "Table1.xls", append dec(3) 10pct

** Control South
regress voteprival stricty newstrict blackstricty hispstricty asianstricty mixedracestricty /*
*/ black hispanic asian mixedrace foreignb firstgen age educ inc male married childrenz unionz /*
*/ unemp ownhome protestant catholic jewish atheist /*
*/ days_before_election early_in_person vote_by_mail no_excuse_absence_ /*
*/ presidentialelectionyear gubernatorialelectionyear senateelectionyear marginpnew /*
*/ y2006 y2008 y2010 southz if voteregpre==1  [pw=weight] ,  cluster(inputstate)
outreg2 blackstricty hispstricty asianstricty mixedracestricty using "Table1.xls", append dec(3) 10pct

*** Table A9 with sample weight, cluster se
regress voteprival stricty newstrict blackstricty hispstricty asianstricty mixedracestricty  /*
*/ black hispanic asian mixedrace foreignb firstgen age educ inc male married childrenz unionz /*
*/ unemp ownhome protestant catholic jewish atheist  days_before_election early_in_person vote_by_mail /*
*/ no_excuse_absence_ presidentialelectionyear gubernatorialelectionyear senateelectionyear marginpnew  /*
*/ y2006 y2008 y2010 i.inputstate /*
*/ if voteregpre==1 [pw=weight] ,  cluster(inputstate)
outreg2 blackstricty hispstricty asianstricty mixedracestricty using "Table1.xls", append dec(3) 10pct


** replicate GM models

// drop 2006 (all) and VA, LA
gen goodstate = 1
replace goodstate = 0 if year == 2006
replace goodstate = 0 if state == "Louisiana"
replace goodstate = 0 if state == "Virginia"


*** Table A9 with sample weight, cluster se and exclude 2006 all VA LA
regress voteprival stricty blackstricty hispstricty asianstricty mixedracestricty  /*
*/ black hispanic asian mixedrace foreignb firstgen age educ inc male married childrenz unionz /*
*/ unemp  ownhome protestant catholic jewish atheist  days_before_election early_in_person vote_by_mail /*
*/ no_excuse_absence_ presidentialelectionyear gubernatorialelectionyear senateelectionyear marginpnew  /*
*/ y2008 y2010 i.inputstate /*
*/ if voteregpre==1 & goodstate==1 [pw=weight] ,  cluster(inputstate)
outreg2 blackstricty hispstricty asianstricty mixedracestricty using "Table1.xls", append dec(3) 10pct


// don't condition on voteregpre, drop 2006 all 2008 VA include newstrict
regress voteprival stricty blackstricty hispstricty asianstricty mixedracestricty  /*
*/ black hispanic asian mixedrace foreignb firstgen age educ inc male married childrenz unionz /*
*/ unemp  ownhome protestant catholic jewish atheist  days_before_election early_in_person vote_by_mail /*
*/ no_excuse_absence_ presidentialelectionyear gubernatorialelectionyear senateelectionyear marginpnew  /*
*/  y2008 y2010 i.inputstate if goodstate == 1  [pw=weight], cluster(inputstate)
outreg2 blackstricty hispstricty asianstricty mixedracestricty using "Table1.xls", append dec(3) 10pct


// + replace missings w/ zeros
replace voteprival = 0 if missing(voteprival)
regress voteprival stricty blackstricty hispstricty asianstricty mixedracestricty  /*
*/ black hispanic asian mixedrace foreignb firstgen age educ inc male married childrenz unionz /*
*/ unemp  ownhome protestant catholic jewish atheist  days_before_election early_in_person vote_by_mail /*
*/ no_excuse_absence_ presidentialelectionyear gubernatorialelectionyear senateelectionyear marginpnew  /*
*/  y2008 y2010 i.inputstate if goodstate == 1  [pw=weight], cluster(inputstate)
outreg2 blackstricty hispstricty asianstricty mixedracestricty using "Table1.xls", append dec(3) 10pct
