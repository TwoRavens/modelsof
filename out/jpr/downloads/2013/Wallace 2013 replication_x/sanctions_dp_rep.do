*REPLICATION DO FILE FOR "Regime type, issues of contention, and economic sanctions: Re-evaluating the economic peace between democracies"

version 12

*cd to appropriate directory

use "sanctions_dp_rep.dta", clear

tsset dyadcode year, yearly


*Create lagged independent variables
sort ccode1 ccode2 year
by ccode1 ccode2: gen sdem3_lag = sdem3[_n-1]
by ccode1 ccode2: gen tdem3_lag = tdem3[_n-1]
by ccode1 ccode2: gen demdyad3_lag = demdyad3[_n-1]
by ccode1 ccode2: gen sdem7_lag = sdem7[_n-1]
by ccode1 ccode2: gen tdem7_lag = tdem7[_n-1]
by ccode1 ccode2: gen demdyad7_lag = demdyad7[_n-1]
by ccode1 ccode2: gen sdem6_lag = sdem6[_n-1]
by ccode1 ccode2: gen tdem6_lag = tdem6[_n-1]
by ccode1 ccode2: gen demdyad6_lag = demdyad6[_n-1]
by ccode1 ccode2: gen cowally_lag = cowally[_n-1]
by ccode1 ccode2: gen atopally_lag = atopally[_n-1]
by ccode1 ccode2: gen us_lag = us[_n-1]
by ccode1 ccode2: gen relpow_lag = relpow[_n-1]
by ccode1 ccode2: gen relpow96_lag = relpow96[_n-1]
by ccode1 ccode2: gen lnexp_lag = lnexp[_n-1]
by ccode1 ccode2: gen tradedep_lag = tradedep[_n-1]
by ccode1 ccode2: gen us_relpow_lag = us_relpow[_n-1]
by ccode1 ccode2: gen us_relpow96_lag = us_relpow96[_n-1]
by ccode1 ccode2: gen us_demdyad3_lag = us_demdyad3[_n-1]
by ccode1 ccode2: gen us_demdyad7_lag = us_demdyad7[_n-1]
by ccode1 ccode2: gen us_demdyad6_lag = us_demdyad6[_n-1]



*CREATE TEMPORAL DEPENDENCE VARIABLES (RE: BECK, KATZ, AND TUCKER 1998)

*For extended HSE data based on HBM and 1971-1977 cases
btscs sanction year ccode1 ccode2, g(sancyear) nspline(3)
*Rename splines
rename _spline1 sancyear_spline1
rename _spline2 sancyear_spline2
rename _spline3 sancyear_spline3
*Create tsquare and t-cubed terms for alternate method to take into account temporal dependence (Carter and Signorino 2010).
gen sancyeart2 = sancyear^2
gen sancyeart3 = sancyear^3

*Repeat for impose data based on TIES (all issue areas)
*Do same for impose
btscs impose year ccode1 ccode2, g(iyear) nspline(3)
rename _spline1 iyear_spline1
rename _spline2 iyear_spline2
rename _spline3 iyear_spline3
*Alternate measures
gen iyeart2 = iyear^2
gen iyeart3 = iyear^3

*Repeat for security-related impositions
*Generate sanctions onset for TIES security related cases.
gen impose_sec = impose
recode impose_sec 1=0 if securityissue!=1 & securityissue!=.
tab1 impose impose_sec, mis
*Run btscs
btscs impose_sec year ccode1 ccode2, g(iyear_sec) nspline(3)
*Rename splines for this
rename _spline1 iyear_sec_spline1
rename _spline2 iyear_sec_spline2
rename _spline3 iyear_sec_spline3
*Alternate measures
gen iyear_sect2 = iyear_sec^2
gen iyear_sect3 = iyear_sec^3

**Repeat for nonsecurity related impositions
gen impose_nonsec = impose
recode impose_nonsec 1=0 if nonsecurityissue!=1 & nonsecurityissue!=.
tab1 impose impose_nonsec, mis
*Run btscs
btscs impose_nonsec year ccode1 ccode2, g(iyear_nonsec) nspline(3)
*Rename splines for this
rename _spline1 iyear_nonsec_spline1
rename _spline2 iyear_nonsec_spline2
rename _spline3 iyear_nonsec_spline3
*Alternate measures
gen iyear_nonsect2 = iyear_nonsec^2
gen iyear_nonsect3 = iyear_nonsec^3

*Do same for alternate version of security which includes drug trafficking
gen impose_sec2 = impose
recode impose_sec2 1=0 if securityissue2!=1 & securityissue2!=.
tab1 impose impose_sec2, mis
*Run btscs
btscs impose_sec2 year ccode1 ccode2, g(iyear_sec2) nspline(3)
*Rename splines for this
rename _spline1 iyear_sec2_spline1
rename _spline2 iyear_sec2_spline2
rename _spline3 iyear_sec2_spline3
*Alternate measures
gen iyear_sec2t2 = iyear_sec2^2
gen iyear_sec2t3 = iyear_sec2^3

**Repeat for alternate version of non-security related impositions, which excludes drug trafficking
gen impose_nonsec2 = impose
recode impose_nonsec2 1=0 if nonsecurityissue2!=1 & nonsecurityissue2!=.
tab1 impose impose_nonsec2, mis
*Run btscs
btscs impose_nonsec2 year ccode1 ccode2, g(iyear_nonsec2) nspline(3)
*Rename splines for this
rename _spline1 iyear_nonsec2_spline1
rename _spline2 iyear_nonsec2_spline2
rename _spline3 iyear_nonsec2_spline3
*Alternate measures
gen iyear_nonsec2t2 = iyear_nonsec2^2
gen iyear_nonsec2t3 = iyear_nonsec2^3



*TABLE 1: Comparison of HSEO and TIES sanctions onsets, 1971Ð2000
*Commands to generate frequencies and percentages of each type of sanctions onset from HSEO and TIES data.

*HSEO cases
tab sanction, mis

*TIES cases
*All
tab impose, mis
*Security Related
tab impose_sec, mis
*Non-Security Related
tab impose_nonsec, mis

*By US initiator (repeat for each type of sanctions onset)
tab sanction us, mis row
tab impose us, mis row
tab impose_sec us, mis row
tab impose_nonsec us, mis row



*TABLE 2: Democracy and economic sanctions, 1971Ð2000 (HSEO data)
*Model without US
relogit sanction demdyad7_lag sdem7_lag tdem7_lag lnexp_lag relpow_lag cowally_lag ///
	sancyear sancyear_spline1 sancyear_spline2 sancyear_spline3, cluster(dyadcode)
*Model with US
relogit sanction demdyad7_lag sdem7_lag tdem7_lag lnexp_lag relpow_lag cowally_lag us_lag ///
	sancyear sancyear_spline1 sancyear_spline2 sancyear_spline3, cluster(dyadcode)
*Add US interactions 
relogit sanction demdyad7_lag sdem7_lag tdem7_lag lnexp_lag relpow_lag cowally_lag us_lag us_demdyad7_lag us_relpow_lag ///
	sancyear sancyear_spline1 sancyear_spline2 sancyear_spline3, cluster(dyadcode)
*Add trade dependence
relogit sanction demdyad7_lag sdem7_lag tdem7_lag lnexp_lag relpow_lag cowally_lag us_lag us_demdyad7_lag us_relpow_lag tradedep_lag ///
	sancyear sancyear_spline1 sancyear_spline2 sancyear_spline3, cluster(dyadcode)



*TABLE 3: Democracy and economic sanctions, 1971-2000 (TIES data; all onsets)
*Model without US
relogit impose demdyad7_lag sdem7_lag tdem7_lag lnexp_lag relpow_lag cowally_lag ///
	iyear iyear_spline1 iyear_spline2 iyear_spline3, cluster(dyadcode)
*Model with US
relogit impose demdyad7_lag sdem7_lag tdem7_lag lnexp_lag relpow_lag cowally_lag us_lag ///
	iyear iyear_spline1 iyear_spline2 iyear_spline3, cluster(dyadcode)
*Add US interactions 
relogit impose demdyad7_lag sdem7_lag tdem7_lag lnexp_lag relpow_lag cowally_lag us_lag us_demdyad7_lag us_relpow_lag ///
	iyear iyear_spline1 iyear_spline2 iyear_spline3, cluster(dyadcode)
*Add trade dependence
relogit impose demdyad7_lag sdem7_lag tdem7_lag lnexp_lag relpow_lag cowally_lag us_lag us_demdyad7_lag us_relpow_lag tradedep_lag ///
	iyear iyear_spline1 iyear_spline2 iyear_spline3, cluster(dyadcode)



*TABLE 4: Democracy and economic sanctions, 1971-2000 (TIES data; security related onsets)
*Model without US
relogit impose_sec demdyad7_lag sdem7_lag tdem7_lag lnexp_lag relpow_lag cowally_lag ///
	iyear_sec iyear_sec_spline1 iyear_sec_spline2 iyear_sec_spline3, cluster(dyadcode)
*Model with US
relogit impose_sec demdyad7_lag sdem7_lag tdem7_lag lnexp_lag relpow_lag cowally_lag us_lag ///
	iyear_sec iyear_sec_spline1 iyear_sec_spline2 iyear_sec_spline3, cluster(dyadcode)
*Add US interactions
relogit impose_sec demdyad7_lag sdem7_lag tdem7_lag lnexp_lag relpow_lag cowally_lag us_lag us_demdyad7_lag us_relpow_lag ///
	iyear_sec iyear_sec_spline1 iyear_sec_spline2 iyear_sec_spline3, cluster(dyadcode)
*Add trade dependence
relogit impose_sec demdyad7_lag sdem7_lag tdem7_lag lnexp_lag relpow_lag cowally_lag us_lag us_demdyad7_lag us_relpow_lag tradedep_lag ///
	iyear_sec iyear_sec_spline1 iyear_sec_spline2 iyear_sec_spline3, cluster(dyadcode)



*TABLE 5: Democracy and economic sanctions, 1971Ð2000 (TIES data; non-security related onsets)
*Model without US
relogit impose_nonsec demdyad7_lag sdem7_lag tdem7_lag lnexp_lag relpow_lag cowally_lag ///
	iyear_nonsec iyear_nonsec_spline1 iyear_nonsec_spline2 iyear_nonsec_spline3, cluster(dyadcode)
*Model with US
relogit impose_nonsec demdyad7_lag sdem7_lag tdem7_lag lnexp_lag relpow_lag cowally_lag us_lag ///
	iyear_nonsec iyear_nonsec_spline1 iyear_nonsec_spline2 iyear_nonsec_spline3, cluster(dyadcode)
*Add US interactions
relogit impose_nonsec demdyad7_lag sdem7_lag tdem7_lag lnexp_lag relpow_lag cowally_lag us_lag us_demdyad7_lag us_relpow_lag ///
	iyear_nonsec iyear_nonsec_spline1 iyear_nonsec_spline2 iyear_nonsec_spline3, cluster(dyadcode)
*Add trade dependence
relogit impose_nonsec demdyad7_lag sdem7_lag tdem7_lag lnexp_lag relpow_lag cowally_lag us_lag us_demdyad7_lag us_relpow_lag tradedep_lag ///
	iyear_nonsec iyear_nonsec_spline1 iyear_nonsec_spline2 iyear_nonsec_spline3, cluster(dyadcode)



*TABLES 6 AND 7 -> SUBSTANTIVE EFFECTS
*Commands to generate values for the substantive effects of regime type and the other independent variables
*	 on the probability of each type of sanctions onset.
*The commands below are general and should be repeated for each type of sanctions onset
*	(i.e. HSEO; TIES impose all onsets; TIES security related; TIES non-security related).

*First, run fully specified Model 4 for a given each type of sanctions onset
/*
*HSEO
relogit sanction demdyad7_lag sdem7_lag tdem7_lag lnexp_lag relpow_lag cowally_lag us_lag us_demdyad7_lag us_relpow_lag tradedep_lag ///
	sancyear sancyear_spline1 sancyear_spline2 sancyear_spline3, cluster(dyadcode)
*All TIES
relogit impose demdyad7_lag sdem7_lag tdem7_lag lnexp_lag relpow_lag cowally_lag us_lag us_demdyad7_lag us_relpow_lag tradedep_lag ///
	iyear iyear_spline1 iyear_spline2 iyear_spline3, cluster(dyadcode)
*Security Related TIES
relogit impose_sec demdyad7_lag sdem7_lag tdem7_lag lnexp_lag relpow_lag cowally_lag us_lag us_demdyad7_lag us_relpow_lag tradedep_lag ///
	iyear_sec iyear_sec_spline1 iyear_sec_spline2 iyear_sec_spline3, cluster(dyadcode)
*Non-Security Related TIES
relogit impose_nonsec demdyad7_lag sdem7_lag tdem7_lag lnexp_lag relpow_lag cowally_lag us_lag us_demdyad7_lag us_relpow_lag tradedep_lag ///
	iyear_nonsec iyear_nonsec_spline1 iyear_nonsec_spline2 iyear_nonsec_spline3, cluster(dyadcode)
*/

*Set baseline values for independent variables.
*	(Dichotomous variables at their medians; continuous variables at their means; temporal dependence variables to zero).
setx median
setx lnexp_lag mean relpow_lag mean tradedep_lag mean
/*
*Set temporal variables to 0 -> command differs depending on the type of sanctions onset used as the 
*	dependent variable.
*HSEO
setx sancyear_spline1 0 sancyear_spline2 0 sancyear_spline3 0 sancyear 0
*All TIES
setx iyear_spline1 0 iyear_spline2 0 iyear_spline3 0 iyear 0
*Security Related TIES
setx iyear_sec_spline1 0 iyear_sec_spline2 0 iyear_sec_spline3 0 iyear_sec 0
*Non-Security Related TIES
setx iyear_nonsec_spline1 0 iyear_nonsec_spline2 0 iyear_nonsec_spline3 0 iyear_nonsec 0
*/

*Generate baseline predicted probability of relevant type of sanctions onset.
relogitq

*TABLE 6: Predicted probability of economic sanction, by regime type combination
*Testing absolute probabilities by different combinations of regime type (Sender-Target)
*Democracy-Democracy
setx (sdem7_lag tdem7_lag demdyad7_lag) 1
relogitq
*Democracy-Autocracy
setx sdem7_lag 1 tdem7_lag 0 demdyad7_lag 0
relogitq
*Autocracy-Democracy
setx sdem7_lag 0 tdem7_lag 1 demdyad7_lag 0
relogitq
*Autocracy-Autocracy
setx (sdem7_lag tdem7_lag demdyad7_lag) 0
relogitq
*Test for whether changes between combinations is statistically significant
*From Dem-Aut to Dem-Dem
setx sdem7_lag 1
relogitq, fd(pr) changex(tdem7_lag 0 1 demdyad7_lag 0 1)
*From Aut-Aut to Dem-Dem
setx sdem7_lag 0
relogitq, fd(pr) changex(sdem7_lag 0 1 tdem7_lag 0 1 demdyad7_lag 0 1)
*From Aut-Aut to Aut-Dem
setx sdem7_lag 0
relogitq, fd(pr) changex(tdem7_lag 0 1)

*TABLE 7: Predicted probabilities of economic sanctions for other explanatory variables
*Percent change in risk of economic sanctions calculated by dividing the first difference for each independent 
*	variable by the baseline predicted probability of sanctions onset, and then multiplied by 100.
*95% confidence intervals generated by calculating similar percent change values for the upper and lower
*	estimate of each first difference.
*Exports
summarize lnexp_lag
*mean = 1.013746    sd = 1.755653 	1sd above mean = 2.769399 
relogitq, fd(pr) changex(lnexp_lag mean 2.769399) 
*Relative power
summarize relpow_lag
*mean = -.0197032    s = 5.231337	1sd above mean = 5.2116338
relogitq, fd(pr) changex(relpow_lag mean 5.2116338)
*Alliance
relogitq, fd(pr) changex(cowally_lag 0 1)
*USA -> note that for USA also need to change democratic sender from 0 to 1 since US is a democracy
relogitq, fd(pr) changex(us_lag 0 1 sdem7_lag 0 1)
*Trade dependence
summarize tradedep_lag
*mean = 0.0000041 sd = .0181644		1sd above mean = 0.0181685
relogitq, fd(pr) changex(tradedep_lag mean 0.0181685)





*ROBUSTNESS CHECKS
*Note: Unless otherwise stated and for ease of presentation, robustness checks are only reported for the 
*	fully specified model of each type of sanctions onset, which includes all explanatory variables along
*	with US interactions and trade dependence.


*USING ALTERNATIVE CARTER AND SIGNORINO (2010) METHOD TO CONTROL FOR TEMPORAL DEPENDENCE
*HSEO
relogit sanction demdyad7_lag sdem7_lag tdem7_lag lnexp_lag relpow_lag cowally_lag us_lag us_demdyad7_lag us_relpow_lag tradedep_lag ///
	sancyear sancyeart2 sancyeart3, cluster(dyadcode)
*All Sanctions
relogit impose demdyad7_lag sdem7_lag tdem7_lag lnexp_lag relpow_lag cowally_lag us_lag us_demdyad7_lag us_relpow_lag tradedep_lag ///
	iyear iyeart2 iyeart3, cluster(dyadcode)
*Security related sanctions
relogit impose_sec demdyad7_lag sdem7_lag tdem7_lag lnexp_lag relpow_lag cowally_lag us_lag us_demdyad7_lag us_relpow_lag tradedep_lag ///
	iyear_sec iyear_sect2 iyear_sect3, cluster(dyadcode)
*Non-Security Related Sanctions
relogit impose_nonsec demdyad7_lag sdem7_lag tdem7_lag lnexp_lag relpow_lag cowally_lag us_lag us_demdyad7_lag us_relpow_lag tradedep_lag ///
	iyear_nonsec iyear_nonsect2 iyear_nonsect3, cluster(dyadcode)



*ALTERNATIVE VERSION OF SECURITY-RELATED SANCTIONS THAT INCLUDES DRUG TRAFFICKING
*TIES security related sanctions (with drug trafficking)
relogit impose_sec2 demdyad7_lag sdem7_lag tdem7_lag lnexp_lag relpow_lag cowally_lag us_lag us_demdyad7_lag us_relpow_lag tradedep_lag ///
	iyear_sec2 iyear_sec2_spline1 iyear_sec2_spline2 iyear_sec2_spline3, cluster(dyadcode)
*TIES non-security related (without drug trafficking)
relogit impose_nonsec2 demdyad7_lag sdem7_lag tdem7_lag lnexp_lag relpow_lag cowally_lag us_lag us_demdyad7_lag us_relpow_lag tradedep_lag ///
	iyear_nonsec2 iyear_nonsec2_spline1 iyear_nonsec2_spline2 iyear_nonsec2_spline3, cluster(dyadcode) 



*LIMIT TO SANCTIONS-RELEVANT DYADS (SIMILAR TO COX AND DRURY)
*HSEO Cases
relogit sanction demdyad7_lag sdem7_lag tdem7_lag lnexp_lag relpow_lag cowally_lag us_lag us_demdyad7_lag us_relpow_lag tradedep_lag ///
	sancyear sancyear_spline1 sancyear_spline2 sancyear_spline3 if sanctRelDyad==1, cluster(dyadcode)
*All TIES Sanctions
relogit impose demdyad7_lag sdem7_lag tdem7_lag lnexp_lag relpow_lag cowally_lag us_lag us_demdyad7_lag us_relpow_lag tradedep_lag ///
	iyear iyear_spline1 iyear_spline2 iyear_spline3 if sanctRelDyad==1, cluster(dyadcode)
*Security related sanctions
relogit impose_sec demdyad7_lag sdem7_lag tdem7_lag lnexp_lag relpow_lag cowally_lag us_lag us_demdyad7_lag us_relpow_lag tradedep_lag ///
	iyear_sec iyear_sec_spline1 iyear_sec_spline2 iyear_sec_spline3 if sanctRelDyad==1, cluster(dyadcode)
*Non-Security Related Sanctions
relogit impose_nonsec demdyad7_lag sdem7_lag tdem7_lag lnexp_lag relpow_lag cowally_lag us_lag us_demdyad7_lag us_relpow_lag tradedep_lag ///
	iyear_nonsec iyear_nonsec_spline1 iyear_nonsec_spline2 iyear_nonsec_spline3 if sanctRelDyad==1, cluster(dyadcode)



*RERUN WITH POLITY CUTOFF OF 6
*HSEO
relogit sanction demdyad6_lag sdem6_lag tdem6_lag lnexp_lag relpow_lag cowally_lag us_lag us_demdyad6_lag us_relpow_lag tradedep_lag ///
	sancyear sancyear_spline1 sancyear_spline2 sancyear_spline3, cluster(dyadcode)
*All TIES
relogit impose demdyad6_lag sdem6_lag tdem6_lag lnexp_lag relpow_lag cowally_lag us_lag us_demdyad6_lag us_relpow_lag tradedep_lag ///
	iyear iyear_spline1 iyear_spline2 iyear_spline3, cluster(dyadcode)
*TIES Security Related
relogit impose_sec demdyad6_lag sdem6_lag tdem6_lag lnexp_lag relpow_lag cowally_lag us_lag us_demdyad6_lag us_relpow_lag tradedep_lag ///
	iyear_sec iyear_sec_spline1 iyear_sec_spline2 iyear_sec_spline3, cluster(dyadcode)
*TIES Non-Security Related
relogit impose_nonsec demdyad6_lag sdem6_lag tdem6_lag lnexp_lag relpow_lag cowally_lag us_lag us_demdyad6_lag us_relpow_lag tradedep_lag ///
	iyear_nonsec iyear_nonsec_spline1 iyear_nonsec_spline2 iyear_nonsec_spline3, cluster(dyadcode)



*RERUN WITH POLITY CUTOFF OF 3
*HSEO
relogit sanction demdyad3_lag sdem3_lag tdem3_lag lnexp_lag relpow_lag cowally_lag us_lag us_demdyad3_lag us_relpow_lag tradedep_lag ///
	sancyear sancyear_spline1 sancyear_spline2 sancyear_spline3, cluster(dyadcode)
*All TIES
relogit impose demdyad3_lag sdem3_lag tdem3_lag lnexp_lag relpow_lag cowally_lag us_lag us_demdyad3_lag us_relpow_lag tradedep_lag ///
	iyear iyear_spline1 iyear_spline2 iyear_spline3, cluster(dyadcode)
*TIES Security Related
relogit impose_sec demdyad3_lag sdem3_lag tdem6_lag lnexp_lag relpow_lag cowally_lag us_lag us_demdyad3_lag us_relpow_lag tradedep_lag ///
	iyear_sec iyear_sec_spline1 iyear_sec_spline2 iyear_sec_spline3, cluster(dyadcode)
*TIES Non-Security Related
relogit impose_nonsec demdyad3_lag sdem3_lag tdem3_lag lnexp_lag relpow_lag cowally_lag us_lag us_demdyad3_lag us_relpow_lag tradedep_lag ///
	iyear_nonsec iyear_nonsec_spline1 iyear_nonsec_spline2 iyear_nonsec_spline3, cluster(dyadcode)



*SUBSTITUTE ATOP ALLY CODING FOR COW CODING FOR ALLIANCES
*HSEO
relogit sanction demdyad7_lag sdem7_lag tdem7_lag lnexp_lag relpow_lag atopally_lag us_lag us_demdyad7_lag us_relpow_lag tradedep_lag ///
	sancyear sancyear_spline1 sancyear_spline2 sancyear_spline3, cluster(dyadcode)
*TIES All
relogit impose demdyad7_lag sdem7_lag tdem7_lag lnexp_lag relpow_lag atopally_lag us_lag us_demdyad7_lag us_relpow_lag tradedep_lag ///
	iyear iyear_spline1 iyear_spline2 iyear_spline3, cluster(dyadcode)
*TIES security
relogit impose_sec demdyad7_lag sdem7_lag tdem7_lag lnexp_lag relpow_lag atopally_lag us_lag us_demdyad7_lag us_relpow_lag tradedep_lag ///
	iyear_sec iyear_sec_spline1 iyear_sec_spline2 iyear_sec_spline3, cluster(dyadcode)
*TIES non-security
relogit impose_nonsec demdyad7_lag sdem7_lag tdem7_lag lnexp_lag relpow_lag atopally_lag us_lag us_demdyad7_lag us_relpow_lag tradedep_lag ///
	iyear_nonsec iyear_nonsec_spline1 iyear_nonsec_spline2 iyear_nonsec_spline3, cluster(dyadcode)



*USING RELATIVE POWER MEASURED IN CONSTANT 1996 US$ -> FULL MODELS REPORTED
*HSEO
relogit sanction demdyad7_lag sdem7_lag tdem7_lag lnexp_lag relpow96_lag cowally_lag us_lag us_demdyad7_lag us_relpow96_lag tradedep_lag ///
	sancyear sancyear_spline1 sancyear_spline2 sancyear_spline3, cluster(dyadcode)
*TIES All
relogit impose demdyad7_lag sdem7_lag tdem7_lag lnexp_lag relpow96_lag cowally_lag us_lag us_demdyad7_lag us_relpow96_lag tradedep_lag ///
	iyear iyear_spline1 iyear_spline2 iyear_spline3, cluster(dyadcode)
*TIES security
relogit impose_sec demdyad7_lag sdem7_lag tdem7_lag lnexp_lag relpow96_lag cowally_lag us_lag us_demdyad7_lag us_relpow96_lag tradedep_lag ///
	iyear_sec iyear_sec_spline1 iyear_sec_spline2 iyear_sec_spline3, cluster(dyadcode)
*TIES non-security
relogit impose_nonsec demdyad7_lag sdem7_lag tdem7_lag lnexp_lag relpow96_lag cowally_lag us_lag us_demdyad7_lag us_relpow96_lag tradedep_lag ///
	iyear_nonsec iyear_nonsec_spline1 iyear_nonsec_spline2 iyear_nonsec_spline3, cluster(dyadcode)



*ASSESSING GOODNESS OF FIT - ALL TIES SANCTIONS 
*ReLogit does not allow for standard measures of fit in order to focus on reducing estimates of bias.
*As a robustness check, run models using regular logit and then estimated goodness of fit.
*Model without US
logit impose demdyad7_lag sdem7_lag tdem7_lag lnexp_lag relpow_lag cowally_lag ///
	iyear iyear_spline1 iyear_spline2 iyear_spline3, cluster(dyadcode) nolog
est store A
*Model with US
logit impose demdyad7_lag sdem7_lag tdem7_lag lnexp_lag relpow_lag cowally_lag us_lag ///
	iyear iyear_spline1 iyear_spline2 iyear_spline3, cluster(dyadcode) nolog
est store B
*Add US interactions
logit impose demdyad7_lag sdem7_lag tdem7_lag lnexp_lag relpow_lag cowally_lag us_lag us_demdyad7_lag us_relpow_lag ///
	iyear iyear_spline1 iyear_spline2 iyear_spline3, cluster(dyadcode) nolog
est store C
*Add trade dependence
logit impose demdyad7_lag sdem7_lag tdem7_lag lnexp_lag relpow_lag cowally_lag us_lag us_demdyad7_lag us_relpow_lag tradedep_lag ///
	iyear iyear_spline1 iyear_spline2 iyear_spline3, cluster(dyadcode) nolog
est store D
*Comparting goodness of fit 
lrtest A B, stats force
lrtest B C, stats force
lrtest B D, stats force
lrtest C D, stats force



*MULTINOMIAL LOGIT MODEL TO ESTIMATE BOTH SECURITY AND NON-SECURITY RELATED SANCTIONS AT SAME TIME
*Create a unordered categorical variable for "impose" that equals 2 if security related imposition; 1 if non-security related; 0 if no sanction
gen imposecat = impose
replace imposecat = 2 if securityissue==1
tab imposecat, mis
lab var imposecat "Impose (categorical)"
lab define IMPOSECAT3 0 "No sanction" 1 "Non-Security Related" 2 "Security Related"
lab values imposecat IMPOSECAT3
*For temporal dependence, use variables for general impose measure

*Model without US
mlogit imposecat demdyad7_lag sdem7_lag tdem7_lag lnexp_lag relpow_lag cowally_lag ///
	iyear iyear_spline1 iyear_spline2 iyear_spline3, cluster(dyadcode) nolog
*Test for equality of coefficients across security and non-security sanctions
test [1]demdyad7_lag = [2]demdyad7_lag

*Model with US
mlogit imposecat demdyad7_lag sdem7_lag tdem7_lag lnexp_lag relpow_lag cowally_lag us_lag ///
	iyear iyear_spline1 iyear_spline2 iyear_spline3, cluster(dyadcode) nolog
test [1]demdyad7_lag = [2]demdyad7_lag

*Add US interaction 
mlogit imposecat demdyad7_lag sdem7_lag tdem7_lag lnexp_lag relpow_lag cowally_lag us_lag us_demdyad7_lag us_relpow_lag ///
	iyear iyear_spline1 iyear_spline2 iyear_spline3, cluster(dyadcode) nolog
test [1]demdyad7_lag = [2]demdyad7_lag

*Add trade dependence
mlogit imposecat demdyad7_lag sdem7_lag tdem7_lag lnexp_lag relpow_lag cowally_lag us_lag us_demdyad7_lag us_relpow_lag tradedep_lag ///
	iyear iyear_spline1 iyear_spline2 iyear_spline3, cluster(dyadcode) nolog
test [1]demdyad7_lag = [2]demdyad7_lag





