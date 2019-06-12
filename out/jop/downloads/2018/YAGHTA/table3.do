// Table3: Placebo Test

** Set the working directory to where the repliction files are located
cd "/Users/johnkuk/Dropbox/14_GSR/Zoli/Voter ID Law/rebuttal/finalcode"

clear all
set more off

use "jop_replication.dta", clear


// Did state ever adopt strict ID
egen IDstate = max(stricty), by(state)
gen blackIDstate = black * IDstate
gen hispanicIDstate = hispanic * IDstate
gen asianIDstate = asian * IDstate
gen mixedraceIDstate = mixedrace * IDstate

// Does state currently have strict ID
gen AlreadyIDstate = stricty


// Only keep 2008-2012 elections
drop if year == 2006 | year == 2014


** General Election


// Drops Virginia 
drop if state == "Virginia"


** Placebo test  (general elections)
logit votegenval IDstate blackIDstate hispanicIDstate asianIDstate mixedraceIDstate   /*
*/ black hispanic asian mixedrace foreignb firstgen age educ inc male married childrenz unionz /*
*/ unemp  ownhome protestant catholic jewish atheist days_before_election early_in_person vote_by_mail /*
*/ no_excuse_absence_ presidentialelectionyear gubernatorialelectionyear senateelectionyear marginpnew y2008  /*
*/ i.inputstate  if voteregpre==1 & AlreadyIDstate == 0 [pw=weight], cluster(inputstate)
outreg2 IDstate blackIDstate hispanicIDstate asianIDstate mixedraceIDstate using "placebo.xls", replace dec(3) 10pct
margins, dydx(IDstate blackIDstate hispanicIDstate asianIDstate mixedraceIDstate)


//
// Primary Election
// 

// Drops Louisiana (primary elections)
drop if state == "Louisiana"

logit voteprival IDstate blackIDstate hispanicIDstate asianIDstate mixedraceIDstate   /*
*/ black hispanic asian mixedrace foreignb firstgen age educ inc male married childrenz unionz /*
*/ unemp  ownhome protestant catholic jewish atheist days_before_election early_in_person vote_by_mail /*
*/ no_excuse_absence_ presidentialelectionyear gubernatorialelectionyear senateelectionyear marginpnew y2008 y2010 y2012 /*
*/ i.inputstate if voteregpre==1 & AlreadyIDstate == 0 [pw=weight], cluster(inputstate)

outreg2 IDstate blackIDstate hispanicIDstate asianIDstate mixedraceIDstate using "placebo.xls", append dec(3) 10pct
