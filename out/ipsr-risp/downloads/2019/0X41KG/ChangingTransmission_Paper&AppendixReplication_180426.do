***
* Replication Do File ror:
* Changing the Transmission Belt. The Programme-to-Policy Link in Italy between 
* the First and Second Republic
* Prepared by Shaun Bevan
* Last Updated: 30.04.2018

***************************************************************
*** use data_risp_cbb.dta file
***************************************************************

***************************************************************
*** Generating interaction variables
***************************************************************
gen maj_w1st = maj_w * first_rep
gen maj_w2nd = maj_w * second_rep

gen maj1st = maj * first_rep
gen maj2nd = maj * second_rep

gen opp_main1st = opp_main * first_rep
gen opp_main2nd = opp_main * second_rep

gen opp_main_w1st = opp_main_w * first_rep
gen opp_main_w2nd = opp_main_w * second_rep

***************************************************************
*** Rescaling controls for small effect sizes
***************************************************************
replace rile_score = rile_score/100000000
replace effpar_leg = effpar_leg/100000000
replace gov_sup = gov_sup/100000000


***************************************************************
*** Time Series Setting the Data
***************************************************************
tsset major_topic year_ts


***************************************************************
***************************************************************
*** Note Change to a Writable Working Directory ***
***************************************************************
***************************************************************


***************************************************************
*** Table 2 & 3 Analyses - Weighted 
***************************************************************

*** Creates and erases old versions of a temporary dta file (postfile)  
*** containing coefficients and stand errors
tempname agg
cap erase agg.dta

postfile `agg' est se/* 
*/ using agg.dta

*** Table 1: All Laws analyses, includes outreg table creation and linear 
*** combinations to calculate marginal effects for Table 2
xtpcse agenda_agg maj_w maj_w1st maj_w2nd opp_main_w opp_main_w1st /*
*/ opp_main_w2nd first_rep second_rep gov_sup effpar_leg rile_score
outreg using aggexec, replace se starlevels(10 5 1 .1) sigsymbols(+,*,**, ***)
lincom maj_w + maj_w1st
post `agg' (r(estimate)) (r(se))
lincom maj_w + maj_w2nd
post `agg' (r(estimate)) (r(se)) 
lincom opp_main_w + opp_main_w1st
post `agg' (r(estimate)) (r(se)) 
lincom opp_main_w + opp_main_w2nd
post `agg' (r(estimate)) (r(se))

*** Closes the temporary dta file (postfile)
postclose `agg'

*** Creates and erases old versions of a temporary dta file (postfile)  
*** containing coefficients and stand errors
tempname exec
cap erase exec.dta

postfile `exec' est se/* 
*/ using exec.dta

*** Table 1: Executive Sponsored Laws analyses, includes outreg table creation 
*** and linear combinations to calculate marginal effects for Table 2
xtpcse agenda_exec_agg maj_w maj_w1st maj_w2nd opp_main_w opp_main_w1st /*
*/ opp_main_w2nd first_rep second_rep gov_sup effpar_leg rile_score
outreg using aggexec, merge se starlevels(10 5 1 .1) sigsymbols(+,*,**, ***)
lincom maj_w + maj_w1st
post `exec' (r(estimate)) (r(se))
lincom maj_w + maj_w2nd
post `exec' (r(estimate)) (r(se))
lincom opp_main_w + opp_main_w1st
post `exec' (r(estimate)) (r(se))
lincom opp_main_w + opp_main_w2nd
post `exec' (r(estimate)) (r(se))

*** Closes the temporary dta file (postfile)
postclose `exec'


***************************************************************
*** Appendix Table A3 & A4 Analyses Unweighted
***************************************************************


*** Creates and erases old versions of a temporary dta file (postfile)  
*** containing coefficients and stand errors
tempname majagg
cap erase majagg.dta

postfile `majagg' est se/* 
*/ using majagg.dta

*** Table A3: All Laws, includes outreg table creation 
*** and linear combinations to calculate marginal effects for Table A4
xtpcse agenda_agg maj maj1st maj2nd opp_main opp_main1st opp_main2nd first_rep /*
*/ second_rep gov_sup effpar_leg rile_score
outreg using now, replace se starlevels(10 5 1 .1) sigsymbols(+,*,**, ***)
lincom maj + maj1st
post `majagg' (r(estimate)) (r(se))
lincom maj + maj2nd
post `majagg' (r(estimate)) (r(se))
lincom opp_main + opp_main1st
post `majagg' (r(estimate)) (r(se))
lincom opp_main + opp_main2nd
post `majagg' (r(estimate)) (r(se))

*** Closes the temporary dta file (postfile)
postclose `majagg'

*** Creates and erases old versions of a temporary dta file (postfile)  
*** containing coefficients and stand errors
tempname majexec
cap erase majexec.dta

postfile `majexec' est se/* 
*/ using majexec.dta

*** Table A3: Executive Sponsored Laws, includes outreg table creation 
*** and linear combinations to calculate marginal effects for Table A4
xtpcse agenda_exec_agg maj maj1st maj2nd opp_main opp_main1st opp_main2nd /*
*/ first_rep second_rep gov_sup effpar_leg rile_score
outreg using now, merge se starlevels(10 5 1 .1) sigsymbols(+,*,**, ***)
lincom maj + maj1st
post `majexec' (r(estimate)) (r(se))
lincom maj + maj2nd
post `majexec' (r(estimate)) (r(se))
lincom opp_main + opp_main1st
post `majexec' (r(estimate)) (r(se))
lincom opp_main + opp_main2nd
post `majexec' (r(estimate)) (r(se))

*** Closes the temporary dta file (postfile)
postclose `majexec'

***************************************************************
*** Figure 1
***************************************************************

*** Generates a new mtname variable to use for labelling
gen mtname = ""
replace mtname = "Economy" if major_topic==1
replace mtname = "Civil" if major_topic==2
replace mtname = "Health" if major_topic==3
replace mtname = "Agriculture" if major_topic==4
replace mtname = "Labour" if major_topic==5
replace mtname = "Education" if major_topic==6
replace mtname = "Environment" if major_topic==7
replace mtname = "Energy" if major_topic==8
replace mtname = "Immigration" if major_topic==9
replace mtname = "Transport" if major_topic==10
replace mtname = "Law" if major_topic==12
replace mtname = "Social" if major_topic==13
replace mtname = "Housing" if major_topic==14
replace mtname = "Commerce" if major_topic==15
replace mtname = "Defence" if major_topic==16
replace mtname = "Science" if major_topic==17
replace mtname = "Trade" if major_topic==18
replace mtname = "Foreign" if major_topic==19
replace mtname = "Gov't" if major_topic==20
replace mtname = "Lands" if major_topic==21
replace mtname = "Culture" if major_topic==23

*** Figure 1 - Note a number of minor formatting issues were changed in the 
*** graph editor, such as colors and the bottom left label
tsline agenda_agg maj_w opp_main_w/*
*/ , scheme(s2mono) /*
*/ graphregion(color(white)) lwidth(thin thin thin) /*
*/ xtitle("Year") /*
*/ ytitle("Percent Attention") /*
*/ xtick(1983(1)2012) /*
*/ xlabel(1983(10)2003 2012) /*
*/ xline(1992 1996, noextend lpattern(dash))/*
*/ ytick(0(.05).4) /*
*/ ylabel(0(.1).4) /*
*/ by(major mtname, cols(6) ) /*
*/ legend(rows(1) region( lpattern(blank)) lab(1 "All Laws") /* 
*/ lab(2 "Wgt Maj Agenda") lab(3 "Wgt Main Opp Agenda")) 

***************************************************************
*** Figure A1
***************************************************************

*** Figure A1 - Note a number of minor formatting issues were changed in the 
*** graph editor, such as colors and the bottom left label
tsline agenda_exec maj opp_main/*
*/ , scheme(s2mono) /*
*/ graphregion(color(white)) lwidth(thin thin thin) /*
*/ xtitle("Year") /*
*/ ytitle("Percent Attention") /*
*/ xtick(1983(1)2012) /*
*/ xlabel(1983(10)2003 2012) /*
*/ xline(1992 1996, noextend lpattern(dash))/*
*/ ytick(0(.05).4) /*
*/ ylabel(0(.1).4) /*
*/ by(major mtname, cols(6) ) /*
*/ legend(rows(1) region( lpattern(blank)) lab(1 "Executive Laws") /* 
*/ lab(2 "UnWgt Maj Agenda") lab(3 "Main Opp Agenda")) 
