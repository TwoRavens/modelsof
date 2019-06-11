*Matthew Fails & Byungwon Woo
*"Unpacking Autocracy: Political Regimes and IMF Program Participation" (forthcoming at International Interactions)
*June 2014

/*INTRODUCTORY NOTES ///
Dataset is titled "UnpackingAutocracy.dta"
This code contains the following components:
	1) Data and variable description
	2) Creation of relevant variables and interaction terms
	3) Code for particular empirical results in main text
	4) Code to create Tables 1-3 (i.e. Main Results)
	5) Code to create relevant tables in Appendix (Tables A2-A13)
*/

*must have dataset "UnpackingAutocracy.dta" open

 
***************
*1) Data and variable maintance & description
***************

version 11
set more off

tsset ccode year

sum	
des 	

*Perhaps some variable sources listed here

***************
*2) Creation of relevant variables and interaction terms
***************

*Note - democracies are baseline category, so interactions are only created with the three varieties of autocracy included in the anlaysis

*Interaction with total reserves in months of imports
gen resXparty = reserves_mths*gwf_party
gen resXpers = reserves_mths*gwf_personal
gen resXmil = reserves_mths*gwf_military

*Interaction with total debt service as % of exports of goods, services and income
gen debtXparty = debtserv_exports*gwf_party
gen debtXpers = debtserv_exports*gwf_personal
gen debtXmil = debtserv_exports*gwf_military

*Interaction with negative growth year dummy variable
gen negXparty = grw_neg*gwf_party
gen negXpers = grw_neg*gwf_personal
gen negXmil = grw_neg*gwf_military

*Interaction with current account balance as % of GDP
gen cabXparty = CurrentAccBal_percentGDP*gwf_party
gen cabXpers = CurrentAccBal_percentGDP*gwf_personal
gen cabXmil = CurrentAccBal_percentGDP*gwf_military

*Interaction with measure of sovereignty cost (binary variable of past IMF participation)
gen partyXsov = gwf_party*previousimf
gen persXsov = gwf_personal*previousimf
gen milXsov = gwf_military*previousimf


***************
*3) Code for particular empirical results in main text
**************

*for note on page 6 regarding average propensity to participate

tab signed_imf if demoid==1
tab signed_imf if demoid!=1

tab signed_imf if gwf_party==1
tab signed_imf if gwf_personal==1
tab signed_imf if gwf_military==1

*for note on page 8 regarding average age of regimes
sum gwf_spell if gwf_party == 1 
sum gwf_spell if gwf_personal == 1 
sum gwf_spell if gwf_military == 1 


***************
*4) Code to create Tables 1-3 (i.e. Main Results)
***************

*Table 1

logit signed_imf lagunderimf reserves_mths resXparty resXmil resXpers debtserv_exports debtXparty debtXmil debtXpers CurrentAccBal_percentGDP cabXparty cabXpers cabXmil grw_neg negXparty negXmil negXpers previousimf partyXsov milXsov persXsov gwf_party gwf_personal gwf_military lngdppc lngdp s2un duration, cluster(ccode)

*code to get sample mean values for variables, to use in simulations
sum lagunderimf reserves_mths debtserv_exports CurrentAccBal_percentGDP grw_neg lngdppc lngdp s2un duration previousimf 

*Tables 2 & 3
*Simulation Results (Note that these are presented by regime type, rather than by Table)
estsimp logit signed_imf lagunderimf reserves_mths resXparty resXmil resXpers debtserv_exports debtXparty debtXmil debtXpers CurrentAccBal_percentGDP cabXparty cabXpers cabXmil grw_neg negXparty negXmil negXpers previousimf partyXsov milXsov persXsov gwf_party gwf_personal gwf_military lngdppc lngdp s2un duration, cluster(ccode)

*DEMOCRACIES (BASELINE / EXCLUDED CATEGORY)*
*Table 2, Col 1
setx lagunderimf 0.5 reserves_mths 3.3 resXparty 0 resXmil 0 resXpers 0 debtserv_exports 18 debtXparty 0 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -4.9 cabXparty 0 cabXpers 0 cabXmil 0 grw_neg 0.3 negXparty 0 negXmil 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 0 previousimf 0.8 partyXsov 0 milXsov 0 persXsov 0 duration 17.5
simqi, prval(1)
*Table 2, Col 2
setx lagunderimf 0.5 reserves_mths 1 resXparty 0 resXmil 0 resXpers 0 debtserv_exports 100 debtXparty 0 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers 0 cabXmil 0 grw_neg 0.8 negXparty 0 negXmil 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 0 previousimf 0.8 partyXsov 0 milXsov 0 persXsov 0 duration 17.5
simqi, prval(1)
*Table 2, Col 3
simqi, fd(prval(1)) changex(reserves_mths 3.3 1 debtserv_exports 17.6 100  CurrentAccBal_percentGDP -5.1 -10  grw_neg 0.3 0.8)
*Table 3, Col 1
setx lagunderimf 0 reserves_mths 1 resXparty 0 resXmil 0 resXpers 0 debtserv_exports 100 debtXparty 0 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers 0 cabXmil 0 grw_neg 0.8 negXparty 0 negXmil 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 0 previousimf 0 partyXsov 0 milXsov 0 persXsov 0 duration 17.5
simqi, prval(1)
*Table 3, Col 2
setx lagunderimf 1 reserves_mths 1 resXparty 0 resXmil 0 resXpers 0 debtserv_exports 100 debtXparty 0 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers 0 cabXmil 0 grw_neg 0.8 negXparty 0 negXmil 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 0 previousimf 1 partyXsov 0 milXsov 0 persXsov 0 duration 17.5
simqi, prval(1)
*Table 3, Col 3
simqi, fd(prval(1)) changex(previousimf 0 1 lagunderimf 0 1)

*PARTY BASED AUTOCRACIES*
*Table 2, Col 1
setx lagunderimf 0.5 reserves_mths 3.3 resXparty 3.3 resXmil 0 resXpers 0 debtserv_exports 18 debtXparty 17.6 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -4.9 cabXparty -5.1 cabXpers 0 cabXmil 0 grw_neg 0.3 negXparty 0.3 negXmil 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 1 gwf_personal 0 gwf_military 0 previousimf 0.8 partyXsov 0.8 milXsov 0 persXsov 0 duration 17.5
simqi, prval(1)
*Table 2, Col 2
setx lagunderimf 0.5 reserves_mths 1 resXparty 1 resXmil 0 resXpers 0 debtserv_exports 100 debtXparty 100 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty -10 cabXpers 0 cabXmil 0 grw_neg 0.8 negXparty 0.8 negXmil 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 1 gwf_personal 0 gwf_military 0 previousimf 0.8 partyXsov 0.8 milXsov 0 persXsov 0 duration 17.5
simqi, prval(1)
*Table 2, Col 3
simqi, fd(prval(1)) changex(reserves_mths 3.3 1 resXparty 3.3 1 debtserv_exports 17.6 100 debtXparty 17.6 100 CurrentAccBal_percentGDP -5.1 -10 cabXparty -5.1 -10 grw_neg 0.3 0.8 negXparty 0.3 0.8)
*Table 3, Col 1
setx lagunderimf 0 reserves_mths 1 resXparty 1 resXmil 0 resXpers 0 debtserv_exports 100 debtXparty 100 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty -10 cabXpers 0 cabXmil 0 grw_neg 0.8 negXparty 0.8 negXmil 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 1 gwf_personal 0 gwf_military 0 previousimf 0 partyXsov 0 milXsov 0 persXsov 0 duration 17.5
simqi, prval(1)
*Table 3, Col 2
setx lagunderimf 1 reserves_mths 1 resXparty 1 resXmil 0 resXpers 0 debtserv_exports 100 debtXparty 100 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty -10 cabXpers 0 cabXmil 0 grw_neg 0.8 negXparty 0.8 negXmil 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 1 gwf_personal 0 gwf_military 0 previousimf 1 partyXsov 1 milXsov 0 persXsov 0 duration 17.5
simqi, prval(1)
*Table 3, Col 3
simqi, fd(prval(1)) changex(previousimf 0 1 lagunderimf 0 1 partyXsov 0 1)

*PERSONALIST AUTOCRACIES*

*Table 2, Col 1
setx lagunderimf 0.5 reserves_mths 3.3 resXparty 0 resXmil 0 resXpers 3.3 debtserv_exports 18 debtXparty 0 debtXmil 0 debtXpers 17.6 CurrentAccBal_percentGDP -4.9 cabXparty 0 cabXpers -5.1 cabXmil 0 grw_neg 0.3 negXparty 0 negXmil 0 negXpers 0.3 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 1 gwf_military 0 previousimf 0.8 partyXsov 0 milXsov 0 persXsov 0.8 duration 17.5
simqi, prval(1)
*Table 2, Col 2
setx lagunderimf 0.5 reserves_mths 1 resXparty 0 resXmil 0 resXpers 1 debtserv_exports 100 debtXparty 0 debtXmil 0 debtXpers 100 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers -10 cabXmil 0 grw_neg 0.8 negXparty 0 negXmil 0 negXpers 0.8 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 1 gwf_military 0 previousimf 0.8 partyXsov 0 milXsov 0 persXsov 0.8 duration 17.5
simqi, prval(1)
*Table 2, Col 3
simqi, fd(prval(1)) changex(reserves_mths 3.3 1 resXpers 3.3 1 debtserv_exports 17.6 100 debtXpers 17.6 100 CurrentAccBal_percentGDP -5.1 -10 cabXpers -5.1 -10 grw_neg 0.3 0.8 negXpers 0.3 0.8)
*Table 3, Col 1
setx lagunderimf 0 reserves_mths 1 resXparty 0 resXmil 0 resXpers 1 debtserv_exports 100 debtXparty 0 debtXmil 0 debtXpers 100 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers -10 cabXmil 0 grw_neg 0.8 negXparty 0 negXmil 0 negXpers 0.8 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 1 gwf_military 0 previousimf 0 partyXsov 0 milXsov 0 persXsov 0 duration 17.5
simqi, prval(1)
*Table 3, Col 2
setx lagunderimf 1 reserves_mths 1 resXparty 0 resXmil 0 resXpers 1 debtserv_exports 100 debtXparty 0 debtXmil 0 debtXpers 100 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers -10 cabXmil 0 grw_neg 0.8 negXparty 0 negXmil 0 negXpers 0.8 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 1 gwf_military 0 previousimf 1 partyXsov 0 milXsov 0 persXsov 1 duration 17.5
simqi, prval(1)
*Table 3, Col 3
simqi, fd(prval(1)) changex(previousimf 0 1 lagunderimf 0 1 persXsov 0 1)

*MILITARY REGIMES*
*Table 2, Col 1
setx lagunderimf 0.5 reserves_mths 3.3 resXparty 0 resXmil 3.3 resXpers 0 debtserv_exports 18 debtXparty 0 debtXmil 17.6 debtXpers 0 CurrentAccBal_percentGDP -4.9 cabXparty 0 cabXpers 0 cabXmil -5.1 grw_neg 0.3 negXparty 0 negXmil 0.3 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 1 previousimf 0.8 partyXsov 0 milXsov 0.8 persXsov 0 duration 17.5
simqi, prval(1)
*Table 2, Col 2
setx lagunderimf 0.5 reserves_mths 1 resXparty 0 resXmil 1 resXpers 0 debtserv_exports 100 debtXparty 0 debtXmil 100 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers 0 cabXmil -10 grw_neg 0.8 negXparty 0 negXmil 0.8 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 1 previousimf 0.8 partyXsov 0 milXsov 0.8 persXsov 0 duration 17.5
simqi, prval(1)
*Table 2, Col 3
simqi, fd(prval(1)) changex(reserves_mths 3.3 1 resXmil 3.3 1 debtserv_exports 17.6 100 debtXmil 17.6 100 CurrentAccBal_percentGDP -5.1 -10 cabXmil -5.1 -10 grw_neg 0.3 0.8 negXmil 0.3 0.8)
*Table 3, Col 1
setx lagunderimf 0 reserves_mths 1 resXparty 0 resXmil 1 resXpers 0 debtserv_exports 100 debtXparty 0 debtXmil 100 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers 0 cabXmil -10 grw_neg 0.8 negXparty 0 negXmil 0.8 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 1 previousimf 0 partyXsov 0 milXsov 0 persXsov 0 duration 17.5
simqi, prval(1)
*Table 3, Col 2
setx lagunderimf 1 reserves_mths 1 resXparty 0 resXmil 1 resXpers 0 debtserv_exports 100 debtXparty 0 debtXmil 100 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers 0 cabXmil -10 grw_neg 0.8 negXparty 0 negXmil 0.8 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 1 previousimf 1 partyXsov 0 milXsov 1 persXsov 0 duration 17.5
simqi, prval(1)
*Table 3, Col 3
simqi, fd(prval(1)) changex(previousimf 0 1 lagunderimf 0 1 milXsov 0 1)

***************
*5) Code to create relevant tables in Appendix (Tables A2-A13)
***************

*Table A2 - Sensitivity analysis using 0 and 1 as the simulated values for 'grow_neg' (Negative growth year binary variable); set to 0 in Col 1, then set to 1 in all simulations with economic crisis

*DEMOCRACIES (BASELINE / EXCLUDED CATEGORY)*
*Col 1
setx lagunderimf 0.5 reserves_mths 3.3 resXparty 0 resXmil 0 resXpers 0 debtserv_exports 18 debtXparty 0 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -4.9 cabXparty 0 cabXpers 0 cabXmil 0 grw_neg 0 negXparty 0 negXmil 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 0 previousimf 0.8 partyXsov 0 milXsov 0 persXsov 0 duration 17.5
simqi, prval(1)
*Col 2
setx lagunderimf 0.5 reserves_mths 1 resXparty 0 resXmil 0 resXpers 0 debtserv_exports 100 debtXparty 0 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers 0 cabXmil 0 grw_neg 1 negXparty 0 negXmil 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 0 previousimf 0.8 partyXsov 0 milXsov 0 persXsov 0 duration 17.5
simqi, prval(1)
*Col 3
simqi, fd(prval(1)) changex(reserves_mths 3.3 1 debtserv_exports 17.6 100  CurrentAccBal_percentGDP -5.1 -10  grw_neg 0 1)
*Col 4
setx lagunderimf 0 reserves_mths 1 resXparty 0 resXmil 0 resXpers 0 debtserv_exports 100 debtXparty 0 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers 0 cabXmil 0 grw_neg 1 negXparty 0 negXmil 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 0 previousimf 0 partyXsov 0 milXsov 0 persXsov 0 duration 17.5
simqi, prval(1)
*Col 5
setx lagunderimf 1 reserves_mths 1 resXparty 0 resXmil 0 resXpers 0 debtserv_exports 100 debtXparty 0 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers 0 cabXmil 0 grw_neg 1 negXparty 0 negXmil 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 0 previousimf 1 partyXsov 0 milXsov 0 persXsov 0 duration 17.5
simqi, prval(1)
*Col 6
simqi, fd(prval(1)) changex(previousimf 0 1 lagunderimf 0 1)


*PARTY BASED AUTOCRACIES*
*Col 1
setx lagunderimf 0.5 reserves_mths 3.3 resXparty 3.3 resXmil 0 resXpers 0 debtserv_exports 18 debtXparty 17.6 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -4.9 cabXparty -5.1 cabXpers 0 cabXmil 0 grw_neg 0 negXparty 0 negXmil 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 1 gwf_personal 0 gwf_military 0 previousimf 0.8 partyXsov 0.8 milXsov 0 persXsov 0 duration 17.5
simqi, prval(1)
*Col 2
setx lagunderimf 0.5 reserves_mths 1 resXparty 1 resXmil 0 resXpers 0 debtserv_exports 100 debtXparty 100 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty -10 cabXpers 0 cabXmil 0 grw_neg 1 negXparty 1 negXmil 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 1 gwf_personal 0 gwf_military 0 previousimf 0.8 partyXsov 0.8 milXsov 0 persXsov 0 duration 17.5
simqi, prval(1)
*Col 3
simqi, fd(prval(1)) changex(reserves_mths 3.3 1 resXparty 3.3 1 debtserv_exports 17.6 100 debtXparty 17.6 100 CurrentAccBal_percentGDP -5.1 -10 cabXparty -5.1 -10 grw_neg 0 1 negXparty 0 1)
*Col 4
setx lagunderimf 0 reserves_mths 1 resXparty 1 resXmil 0 resXpers 0 debtserv_exports 100 debtXparty 100 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty -10 cabXpers 0 cabXmil 0 grw_neg 1 negXparty 1 negXmil 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 1 gwf_personal 0 gwf_military 0 previousimf 0 partyXsov 0 milXsov 0 persXsov 0 duration 17.5
simqi, prval(1)
*Col 5
setx lagunderimf 1 reserves_mths 1 resXparty 1 resXmil 0 resXpers 0 debtserv_exports 100 debtXparty 100 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty -10 cabXpers 0 cabXmil 0 grw_neg 1 negXparty 1 negXmil 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 1 gwf_personal 0 gwf_military 0 previousimf 1 partyXsov 1 milXsov 0 persXsov 0 duration 17.5
simqi, prval(1)
*Col 6
simqi, fd(prval(1)) changex(previousimf 0 1 lagunderimf 0 1 partyXsov 0 1)

*PERSONALIST AUTOCRACIES*
*Col 1
setx lagunderimf 0.5 reserves_mths 3.3 resXparty 0 resXmil 0 resXpers 3.3 debtserv_exports 18 debtXparty 0 debtXmil 0 debtXpers 17.6 CurrentAccBal_percentGDP -4.9 cabXparty 0 cabXpers -5.1 cabXmil 0 grw_neg 01 negXparty 0 negXmil 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 1 gwf_military 0 previousimf 0.8 partyXsov 0 milXsov 0 persXsov 0.8 duration 17.5
simqi, prval(1)
*Col 2
setx lagunderimf 0.5 reserves_mths 1 resXparty 0 resXmil 0 resXpers 1 debtserv_exports 100 debtXparty 0 debtXmil 0 debtXpers 100 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers -10 cabXmil 0 grw_neg 1 negXparty 0 negXmil 0 negXpers 1 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 1 gwf_military 0 previousimf 0.8 partyXsov 0 milXsov 0 persXsov 0.8 duration 17.5
simqi, prval(1)
*Col 3
simqi, fd(prval(1)) changex(reserves_mths 3.3 1 resXpers 3.3 1 debtserv_exports 17.6 100 debtXpers 17.6 100 CurrentAccBal_percentGDP -5.1 -10 cabXpers -5.1 -10 grw_neg 0 1 negXpers 0 1)
*Col 4
setx lagunderimf 0 reserves_mths 1 resXparty 0 resXmil 0 resXpers 1 debtserv_exports 100 debtXparty 0 debtXmil 0 debtXpers 100 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers -10 cabXmil 0 grw_neg 1 negXparty 0 negXmil 0 negXpers 1 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 1 gwf_military 0 previousimf 0 partyXsov 0 milXsov 0 persXsov 0 duration 17.5
simqi, prval(1)
*Col 5
setx lagunderimf 1 reserves_mths 1 resXparty 0 resXmil 0 resXpers 1 debtserv_exports 100 debtXparty 0 debtXmil 0 debtXpers 100 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers -10 cabXmil 0 grw_neg 1 negXparty 0 negXmil 0 negXpers 1 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 1 gwf_military 0 previousimf 1 partyXsov 0 milXsov 0 persXsov 1 duration 17.5
simqi, prval(1)
*Col 6
simqi, fd(prval(1)) changex(previousimf 0 1 lagunderimf 0 1 persXsov 0 1)

*MILITARY REGIMES*
*Col 1
setx lagunderimf 0.5 reserves_mths 3.3 resXparty 0 resXmil 3.3 resXpers 0 debtserv_exports 18 debtXparty 0 debtXmil 17.6 debtXpers 0 CurrentAccBal_percentGDP -4.9 cabXparty 0 cabXpers 0 cabXmil -5.1 grw_neg 0 negXparty 0 negXmil 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 1 previousimf 0.8 partyXsov 0 milXsov 0.8 persXsov 0 duration 17.5
simqi, prval(1)
*Col 2
setx lagunderimf 0.5 reserves_mths 1 resXparty 0 resXmil 1 resXpers 0 debtserv_exports 100 debtXparty 0 debtXmil 100 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers 0 cabXmil -10 grw_neg 1 negXparty 0 negXmil 1 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 1 previousimf 0.8 partyXsov 0 milXsov 0.8 persXsov 0 duration 17.5
simqi, prval(1)
*Col 3
simqi, fd(prval(1)) changex(reserves_mths 3.3 1 resXmil 3.3 1 debtserv_exports 17.6 100 debtXmil 17.6 100 CurrentAccBal_percentGDP -5.1 -10 cabXmil -5.1 -10 grw_neg 0 1 negXmil 0 1)
*Col 4
setx lagunderimf 0 reserves_mths 1 resXparty 0 resXmil 1 resXpers 0 debtserv_exports 100 debtXparty 0 debtXmil 100 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers 0 cabXmil -10 grw_neg 1 negXparty 0 negXmil 1 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 1 previousimf 0 partyXsov 0 milXsov 0 persXsov 0 duration 17.5
simqi, prval(1)
*Col 5
setx lagunderimf 1 reserves_mths 1 resXparty 0 resXmil 1 resXpers 0 debtserv_exports 100 debtXparty 0 debtXmil 100 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers 0 cabXmil -10 grw_neg 1 negXparty 0 negXmil 1 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 1 previousimf 1 partyXsov 0 milXsov 1 persXsov 0 duration 17.5
simqi, prval(1)
*Col 6
simqi, fd(prval(1)) changex(previousimf 0 1 lagunderimf 0 1 milXsov 0 1)


*Tables A3 & A4 - Using only "Pure" Party and Military Regimes

*create "pure" GWF variables (see codebook for GWF and supporting article)
gen pure_party = 0
replace pure_party = 1 if gwf_regimetype == "party-based"
label var pure_party "GWF party, no hybrids"

gen pure_mil = 0
replace pure_mil = 1 if gwf_regimetype == "military"
label var pure_mil "GWF military, no hybrids"

tab pure_party
tab gwf_party

tab pure_mil
tab gwf_military

*not necessary to create pure_personal, as the variable gwf_personal already excludes personalist hybrids

gen puresample = 1 
replace puresample = 0 if gwf_party == 1 & pure_party!=1
replace puresample = 0 if gwf_military == 1 & pure_mil!=1


label var puresample "sample of observations that are democracies, pure_party, personalist, or Pure_military regimes - excludes monarchies and hybrid party and militaries"

*Create interactions with four econ variables and these
gen resXpp = reserves_mths*pure_party
gen resXpm = reserves_mths*pure_mil
gen debtXpp = debtserv_exports*pure_party
gen debtXpm = debtserv_exports*pure_mil
gen cabXpp = CurrentAccBal_percentGDP*pure_party
gen cabXpm = CurrentAccBal_percentGDP*pure_mil
gen negXpp = grw_neg*pure_party
gen negXpm = grw_neg*pure_mil
gen sovXpp = previousimf*pure_party
gen sovXpm = previousimf*pure_mil

**Estimate the model, substituting these new dummy vars and interactions for party and military regimes
logit signed_imf lagunderimf reserves_mths resXpp resXpm resXpers debtserv_exports debtXpp debtXpm debtXpers CurrentAccBal_percentGDP cabXpp cabXpm cabXpers grw_neg negXpp negXpm negXpers previousimf sovXpp sovXpm persXsov pure_party pure_mil gwf_personal lngdppc lngdp s2un duration if puresample==1, cluster(ccode)

drop b*

estsimp logit signed_imf lagunderimf reserves_mths resXpp resXpm resXpers debtserv_exports debtXpp debtXpm debtXpers CurrentAccBal_percentGDP cabXpp cabXpm cabXpers grw_neg negXpp negXpm negXpers previousimf sovXpp sovXpm persXsov pure_party pure_mil gwf_personal lngdppc lngdp s2un duration if puresample==1, cluster(ccode)

*DEMOCRACIES (BASELINE / EXCLUDED CATEGORY)*
*Col 1 
setx lagunderimf 0.5 reserves_mths 3.3 resXpp 0 resXpm 0 resXpers 0 debtserv_exports 18 debtXpp 0 debtXpm 0 debtXpers 0 CurrentAccBal_percentGDP -4.9 cabXpp 0 cabXpers 0 cabXpm 0 grw_neg 0.3 negXpp 0 negXpm 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 pure_party 0 gwf_personal 0 pure_mil 0 previousimf 0.8 sovXpp 0 sovXpm 0 persXsov 0 duration 17.5
simqi, prval(1)
*Col 2
setx lagunderimf 0.5 reserves_mths 1 resXpp 0 resXpm 0 resXpers 0 debtserv_exports 100 debtXpp 0 debtXpm 0 debtXpers 0 CurrentAccBal_percentGDP -10 cabXpp 0 cabXpers 0 cabXpm 0 grw_neg 0.8 negXpp 0 negXpm 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 pure_party 0 gwf_personal 0 pure_mil 0 previousimf 0.8 sovXpp 0 sovXpm 0 persXsov 0 duration 17.5
simqi, prval(1)
*Col 3
simqi, fd(prval(1)) changex(reserves_mths 3.3 1 debtserv_exports 17.6 100  CurrentAccBal_percentGDP -5.1 -10  grw_neg 0.3 0.8)
*Col 4
setx lagunderimf 0 reserves_mths 1 resXpp 0 resXpm 0 resXpers 0 debtserv_exports 100 debtXpp 0 debtXpm 0 debtXpers 0 CurrentAccBal_percentGDP -10 cabXpp 0 cabXpers 0 cabXpm 0 grw_neg 0.8 negXpp 0 negXpm 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 pure_party 0 gwf_personal 0 pure_mil 0 previousimf 0 sovXpp 0 sovXpm 0 persXsov 0 duration 17.5
simqi, prval(1)
*Col 5
setx lagunderimf 1 reserves_mths 1 resXpp 0 resXpm 0 resXpers 0 debtserv_exports 100 debtXpp 0 debtXpm 0 debtXpers 0 CurrentAccBal_percentGDP -10 cabXpp 0 cabXpers 0 cabXpm 0 grw_neg 0.8 negXpp 0 negXpm 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 pure_party 0 gwf_personal 0 pure_mil 0 previousimf 1 sovXpp 0 sovXpm 0 persXsov 0 duration 17.5
simqi, prval(1)
*Col 6
simqi, fd(prval(1)) changex(previousimf 0 1 lagunderimf 0 1)

*PARTY BASED AUTOCRACIES*
*Col 1
setx lagunderimf 0.5 reserves_mths 3.3 resXpp 3.3 resXpm 0 resXpers 0 debtserv_exports 18 debtXpp 17.6 debtXpm 0 debtXpers 0 CurrentAccBal_percentGDP -4.9 cabXpp -5.1 cabXpers 0 cabXpm 0 grw_neg 0.3 negXpp 0.3 negXpm 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 pure_party 1 gwf_personal 0 pure_mil 0 previousimf 0.8 sovXpp 0.8 sovXpm 0 persXsov 0 duration 17.5
simqi, prval(1)
*Col 2
setx lagunderimf 0.5 reserves_mths 1 resXpp 1 resXpm 0 resXpers 0 debtserv_exports 100 debtXpp 100 debtXpm 0 debtXpers 0 CurrentAccBal_percentGDP -10 cabXpp -10 cabXpers 0 cabXpm 0 grw_neg 0.8 negXpp 0.8 negXpm 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 pure_party 1 gwf_personal 0 pure_mil 0 previousimf 0.8 sovXpp 0.8 sovXpm 0 persXsov 0 duration 17.5
simqi, prval(1)
*Col 3
simqi, fd(prval(1)) changex(reserves_mths 3.3 1 resXpp 3.3 1 debtserv_exports 17.6 100 debtXpp 17.6 100 CurrentAccBal_percentGDP -5.1 -10 cabXpp -5.1 -10 grw_neg 0.3 0.8 negXpp 0.3 0.8)
*Col 4
setx lagunderimf 0 reserves_mths 1 resXpp 1 resXpm 0 resXpers 0 debtserv_exports 100 debtXpp 100 debtXpm 0 debtXpers 0 CurrentAccBal_percentGDP -10 cabXpp -10 cabXpers 0 cabXpm 0 grw_neg 0.8 negXpp 0.8 negXpm 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 pure_party 1 gwf_personal 0 pure_mil 0 previousimf 0 sovXpp 0 sovXpm 0 persXsov 0 duration 17.5
simqi, prval(1)
*Col 5
setx lagunderimf 1 reserves_mths 1 resXpp 1 resXpm 0 resXpers 0 debtserv_exports 100 debtXpp 100 debtXpm 0 debtXpers 0 CurrentAccBal_percentGDP -10 cabXpp -10 cabXpers 0 cabXpm 0 grw_neg 0.8 negXpp 0.8 negXpm 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 pure_party 1 gwf_personal 0 previousimf 1 sovXpp 1 sovXpm 0 persXsov 0 duration 17.5
simqi, prval(1)
*Col 6
simqi, fd(prval(1)) changex(previousimf 0 1 lagunderimf 0 1 sovXpp 0 1)

*PERSONALIST AUTOCRACIES*
*Col 1
setx lagunderimf 0.5 reserves_mths 3.3 resXpp 0 resXpm 0 resXpers 3.3 debtserv_exports 18 debtXpp 0 debtXpm 0 debtXpers 17.6 CurrentAccBal_percentGDP -4.9 cabXpp 0 cabXpers -5.1 cabXpm 0 grw_neg 0.3 negXpp 0 negXpm 0 negXpers 0.3 lngdppc 6.9 lngdp 22.6 s2un 0.1 pure_party 0 gwf_personal 1 pure_mil 0 previousimf 0.8 sovXpp 0 sovXpm 0 persXsov 0.8 duration 17.5
simqi, prval(1)
*Col 2
setx lagunderimf 0.5 reserves_mths 1 resXpp 0 resXpm 0 resXpers 1 debtserv_exports 100 debtXpp 0 debtXpm 0 debtXpers 100 CurrentAccBal_percentGDP -10 cabXpp 0 cabXpers -10 cabXpm 0 grw_neg 0.8 negXpp 0 negXpm 0 negXpers 0.8 lngdppc 6.9 lngdp 22.6 s2un 0.1 pure_party 0 gwf_personal 1 pure_mil 0 previousimf 0.8 sovXpp 0 sovXpm 0 persXsov 0.8 duration 17.5
simqi, prval(1)
*Col 3
simqi, fd(prval(1)) changex(reserves_mths 3.3 1 resXpers 3.3 1 debtserv_exports 17.6 100 debtXpers 17.6 100 CurrentAccBal_percentGDP -5.1 -10 cabXpers -5.1 -10 grw_neg 0.3 0.8 negXpers 0.3 0.8)
*Col 4
setx lagunderimf 0 reserves_mths 1 resXpp 0 resXpm 0 resXpers 1 debtserv_exports 100 debtXpp 0 debtXpm 0 debtXpers 100 CurrentAccBal_percentGDP -10 cabXpp 0 cabXpers -10 cabXpm 0 grw_neg 0.8 negXpp 0 negXpm 0 negXpers 0.8 lngdppc 6.9 lngdp 22.6 s2un 0.1 pure_party 0 gwf_personal 1 pure_mil 0 previousimf 0 sovXpp 0 sovXpm 0 persXsov 0 duration 17.5
simqi, prval(1)
*Col 5
setx lagunderimf 1 reserves_mths 1 resXpp 0 resXpm 0 resXpers 1 debtserv_exports 100 debtXpp 0 debtXpm 0 debtXpers 100 CurrentAccBal_percentGDP -10 cabXpp 0 cabXpers -10 cabXpm 0 grw_neg 0.8 negXpp 0 negXpm 0 negXpers 0.8 lngdppc 6.9 lngdp 22.6 s2un 0.1 pure_party 0 gwf_personal 1 pure_mil 0 previousimf 1 sovXpp 0 sovXpm 0 persXsov 1 duration 17.5
simqi, prval(1)
*Col 6
simqi, fd(prval(1)) changex(previousimf 0 1 lagunderimf 0 1 persXsov 0 1)

*MILITARY REGIMES*
*Col 1
setx lagunderimf 0.5 reserves_mths 3.3 resXpp 0 resXpm 3.3 resXpers 0 debtserv_exports 18 debtXpp 0 debtXpm 17.6 debtXpers 0 CurrentAccBal_percentGDP -4.9 cabXpp 0 cabXpers 0 cabXpm -5.1 grw_neg 0.3 negXpp 0 negXpm 0.3 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 pure_party 0 gwf_personal 0 pure_mil 1 previousimf 0.8 sovXpp 0 sovXpm 0.8 persXsov 0 duration 17.5
simqi, prval(1)
*Col 2
setx lagunderimf 0.5 reserves_mths 1 resXpp 0 resXpm 1 resXpers 0 debtserv_exports 100 debtXpp 0 debtXpm 100 debtXpers 0 CurrentAccBal_percentGDP -10 cabXpp 0 cabXpers 0 cabXpm -10 grw_neg 0.8 negXpp 0 negXpm 0.8 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 pure_party 0 gwf_personal 0 pure_mil 1 previousimf 0.8 sovXpp 0 sovXpm 0.8 persXsov 0 duration 17.5
simqi, prval(1)
*Col 3
simqi, fd(prval(1)) changex(reserves_mths 3.3 1 resXpm 3.3 1 debtserv_exports 17.6 100 debtXpm 17.6 100 CurrentAccBal_percentGDP -5.1 -10 cabXpm -5.1 -10 grw_neg 0.3 0.8 negXpm 0.3 0.8)
*Col 4
setx lagunderimf 0 reserves_mths 1 resXpp 0 resXpm 1 resXpers 0 debtserv_exports 100 debtXpp 0 debtXpm 100 debtXpers 0 CurrentAccBal_percentGDP -10 cabXpp 0 cabXpers 0 cabXpm -10 grw_neg 0.8 negXpp 0 negXpm 0.8 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 pure_party 0 gwf_personal 0 pure_mil 1 previousimf 0 sovXpp 0 sovXpm 0 persXsov 0 duration 17.5
simqi, prval(1)
*Col 5
setx lagunderimf 1 reserves_mths 1 resXpp 0 resXpm 1 resXpers 0 debtserv_exports 100 debtXpp 0 debtXpm 100 debtXpers 0 CurrentAccBal_percentGDP -10 cabXpp 0 cabXpers 0 cabXpm -10 grw_neg 0.8 negXpp 0 negXpm 0.8 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 pure_party 0 gwf_personal 0 pure_mil 1 previousimf 1 sovXpp 0 sovXpm 1 persXsov 0 duration 17.5
simqi, prval(1)
*Col 6
simqi, fd(prval(1)) changex(previousimf 0 1 lagunderimf 0 1 sovXpm 0 1)


*Table A5 & A6 - Controlling for resource revenue and FDI inflows

logit signed_imf lagunderimf reserves_mths resXparty resXmil resXpers debtserv_exports debtXparty debtXmil debtXpers CurrentAccBal_percentGDP cabXparty cabXpers cabXmil grw_neg negXparty negXmil negXpers previousimf partyXsov milXsov persXsov gwf_party gwf_personal gwf_military lngdppc lngdp s2un oil_gas_valuePOP_2000 in_pctgdp duration, cluster(ccode)

drop b*

estsimp logit signed_imf lagunderimf reserves_mths resXparty resXmil resXpers debtserv_exports debtXparty debtXmil debtXpers CurrentAccBal_percentGDP cabXparty cabXpers cabXmil grw_neg negXparty negXmil negXpers previousimf partyXsov milXsov persXsov gwf_party gwf_personal gwf_military lngdppc lngdp s2un oil_gas_valuePOP_2000 in_pctgdp duration, cluster(ccode)

*DEMOCRACIES (BASELINE / EXCLUDED CATEGORY)*
*Col 1 
setx lagunderimf 0.5 reserves_mths 3.3 resXparty 0 resXmil 0 resXpers 0 debtserv_exports 17.6 debtXparty 0 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -5.1 cabXparty 0 cabXpers 0 cabXmil 0 grw_neg 0.3 negXparty 0 negXmil 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 0 previousimf 0.8 partyXsov 0 milXsov 0 persXsov 0 oil_gas_valuePOP_2000 110.7 in_pctgdp 2.6 duration 17.3
simqi, prval(1)
*Col 2
setx lagunderimf 0.5 reserves_mths 1 resXparty 0 resXmil 0 resXpers 0 debtserv_exports 100 debtXparty 0 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers 0 cabXmil 0 grw_neg 0.8 negXparty 0 negXmil 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 0 previousimf 0.8 partyXsov 0 milXsov 0 persXsov 0 oil_gas_valuePOP_2000 110.7 in_pctgdp 2.6 duration 17.3
simqi, prval(1)
*Col 3
simqi, fd(prval(1)) changex(reserves_mths 3.3 1 debtserv_exports 17.6 100  CurrentAccBal_percentGDP -5.1 -10  grw_neg 0.3 0.8)
*Col 4
setx lagunderimf 0 reserves_mths 1 resXparty 0 resXmil 0 resXpers 0 debtserv_exports 100 debtXparty 0 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers 0 cabXmil 0 grw_neg 0.8 negXparty 0 negXmil 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 0 previousimf 0 partyXsov 0 milXsov 0 persXsov 0 oil_gas_valuePOP_2000 110.7 in_pctgdp 2.6 duration 17.3
simqi, prval(1)
*Col 5
setx lagunderimf 1 reserves_mths 1 resXparty 0 resXmil 0 resXpers 0 debtserv_exports 100 debtXparty 0 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers 0 cabXmil 0 grw_neg 0.8 negXparty 0 negXmil 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 0 previousimf 1 partyXsov 0 milXsov 0 persXsov 0 oil_gas_valuePOP_2000 110.7 in_pctgdp 2.6 duration 17.3
simqi, prval(1)
*Col 6
simqi, fd(prval(1)) changex(previousimf 0 1 lagunderimf 0 1)

*PARTY BASED AUTOCRACIES*
*Col 1
setx lagunderimf 0.5 reserves_mths 3.3 resXparty 3.3 resXmil 0 resXpers 0 debtserv_exports 17.6 debtXparty 17.6 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -5.1 cabXparty -5.1 cabXpers 0 cabXmil 0 grw_neg 0.3 negXparty 0.3 negXmil 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 1 gwf_personal 0 gwf_military 0 previousimf 0.8 partyXsov 0.8 milXsov 0 persXsov 0 oil_gas_valuePOP_2000 110.7 in_pctgdp 2.6 duration 17.3
simqi, prval(1)
*Col 2
setx lagunderimf 0.5 reserves_mths 1 resXparty 1 resXmil 0 resXpers 0 debtserv_exports 100 debtXparty 100 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty -10 cabXpers 0 cabXmil 0 grw_neg 0.8 negXparty 0.8 negXmil 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 1 gwf_personal 0 gwf_military 0 previousimf 0.8 partyXsov 0.8 milXsov 0 persXsov 0 oil_gas_valuePOP_2000 110.7 in_pctgdp 2.6 duration 17.3
simqi, prval(1)
*Col 3
simqi, fd(prval(1)) changex(reserves_mths 3.3 1 resXparty 3.3 1 debtserv_exports 17.6 100 debtXparty 17.6 100 CurrentAccBal_percentGDP -5.1 -10 cabXparty -5.1 -10 grw_neg 0.3 0.8 negXparty 0.3 0.8)
*Col 4
setx lagunderimf 0 reserves_mths 1 resXparty 1 resXmil 0 resXpers 0 debtserv_exports 100 debtXparty 100 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty -10 cabXpers 0 cabXmil 0 grw_neg 0.8 negXparty 0.8 negXmil 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 1 gwf_personal 0 gwf_military 0 previousimf 0 partyXsov 0 milXsov 0 persXsov 0 oil_gas_valuePOP_2000 110.7 in_pctgdp 2.6 duration 17.3
simqi, prval(1)
*Col 5
setx lagunderimf 1 reserves_mths 1 resXparty 1 resXmil 0 resXpers 0 debtserv_exports 100 debtXparty 100 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty -10 cabXpers 0 cabXmil 0 grw_neg 0.8 negXparty 0.8 negXmil 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 1 gwf_personal 0 gwf_military 0 previousimf 1 partyXsov 1 milXsov 0 persXsov 0 oil_gas_valuePOP_2000 110.7 in_pctgdp 2.6 duration 17.3
simqi, prval(1)
*Col 6
simqi, fd(prval(1)) changex(previousimf 0 1 lagunderimf 0 1 partyXsov 0 1)

*PERSONALIST AUTOCRACIES*
*Col 1
*mean values of all variables, with constituent term and personalist interactions set to specified values, personalist dummy set to 1
setx lagunderimf 0.5 reserves_mths 3.3 resXparty 0 resXmil 0 resXpers 3.3 debtserv_exports 17.6 debtXparty 0 debtXmil 0 debtXpers 17.6 CurrentAccBal_percentGDP -5.1 cabXparty 0 cabXpers -5.1 cabXmil 0 grw_neg 0.3 negXparty 0 negXmil 0 negXpers 0.3 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 1 gwf_military 0 previousimf 0.8 partyXsov 0 milXsov 0 persXsov 0.8 oil_gas_valuePOP_2000 110.7 in_pctgdp 2.6 duration 17.3
simqi, prval(1)
*Col 2
setx lagunderimf 0.5 reserves_mths 1 resXparty 0 resXmil 0 resXpers 1 debtserv_exports 100 debtXparty 0 debtXmil 0 debtXpers 100 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers -10 cabXmil 0 grw_neg 0.8 negXparty 0 negXmil 0 negXpers 0.8 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 1 gwf_military 0 previousimf 0.8 partyXsov 0 milXsov 0 persXsov 0.8 oil_gas_valuePOP_2000 110.7 in_pctgdp 2.6 duration 17.3
simqi, prval(1)
*Col 3
simqi, fd(prval(1)) changex(reserves_mths 3.3 1 resXpers 3.3 1 debtserv_exports 17.6 100 debtXpers 17.6 100 CurrentAccBal_percentGDP -5.1 -10 cabXpers -5.1 -10 grw_neg 0.3 0.8 negXpers 0.3 0.8)
*Col 4
setx lagunderimf 0 reserves_mths 1 resXparty 0 resXmil 0 resXpers 1 debtserv_exports 100 debtXparty 0 debtXmil 0 debtXpers 100 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers -10 cabXmil 0 grw_neg 0.8 negXparty 0 negXmil 0 negXpers 0.8 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 1 gwf_military 0 previousimf 0 partyXsov 0 milXsov 0 persXsov 0 oil_gas_valuePOP_2000 110.7 in_pctgdp 2.6 duration 17.3
simqi, prval(1)
*Col 5
setx lagunderimf 1 reserves_mths 1 resXparty 0 resXmil 0 resXpers 1 debtserv_exports 100 debtXparty 0 debtXmil 0 debtXpers 100 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers -10 cabXmil 0 grw_neg 0.8 negXparty 0 negXmil 0 negXpers 0.8 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 1 gwf_military 0 previousimf 1 partyXsov 0 milXsov 0 persXsov 1 oil_gas_valuePOP_2000 110.7 in_pctgdp 2.6 duration 17.3
simqi, prval(1)
*Col 6
simqi, fd(prval(1)) changex(previousimf 0 1 lagunderimf 0 1 persXsov 0 1)

*MILITARY REGIMES*
*Col 1
setx lagunderimf 0.5 reserves_mths 3.3 resXparty 0 resXmil 3.3 resXpers 0 debtserv_exports 17.6 debtXparty 0 debtXmil 17.6 debtXpers 0 CurrentAccBal_percentGDP -5.1 cabXparty 0 cabXpers 0 cabXmil -5.1 grw_neg 0.3 negXparty 0 negXmil 0.3 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 1 previousimf 0.8 partyXsov 0 milXsov 0.8 persXsov 0 oil_gas_valuePOP_2000 110.7 in_pctgdp 2.6 duration 17.3
simqi, prval(1)
*Col 2
setx lagunderimf 0.5 reserves_mths 1 resXparty 0 resXmil 1 resXpers 0 debtserv_exports 100 debtXparty 0 debtXmil 100 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers 0 cabXmil -10 grw_neg 0.8 negXparty 0 negXmil 0.8 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 1 previousimf 0.8 partyXsov 0 milXsov 0.8 persXsov 0 oil_gas_valuePOP_2000 110.7 in_pctgdp 2.6 duration 17.3
simqi, prval(1)
*Col 3
simqi, fd(prval(1)) changex(reserves_mths 3.3 1 resXmil 3.3 1 debtserv_exports 17.6 100 debtXmil 17.6 100 CurrentAccBal_percentGDP -5.1 -10 cabXmil -5.1 -10 grw_neg 0.3 0.8 negXmil 0.3 0.8)
*Col 4
setx lagunderimf 0 reserves_mths 1 resXparty 0 resXmil 1 resXpers 0 debtserv_exports 100 debtXparty 0 debtXmil 100 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers 0 cabXmil -10 grw_neg 0.8 negXparty 0 negXmil 0.8 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 1 previousimf 0 partyXsov 0 milXsov 0 persXsov 0 oil_gas_valuePOP_2000 110.7 in_pctgdp 2.6 duration 17.3
simqi, prval(1)
*Col 5
setx lagunderimf 1 reserves_mths 1 resXparty 0 resXmil 1 resXpers 0 debtserv_exports 100 debtXparty 0 debtXmil 100 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers 0 cabXmil -10 grw_neg 0.8 negXparty 0 negXmil 0.8 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 1 previousimf 1 partyXsov 0 milXsov 1 persXsov 0 oil_gas_valuePOP_2000 110.7 in_pctgdp 2.6 duration 17.3
simqi, prval(1)
*Col 6
simqi, fd(prval(1)) changex(previousimf 0 1 lagunderimf 0 1 milXsov 0 1)

drop b*


*Table A7 - Split Sample Esimates, main model specification

logit signed_imf reserves_mths debtserv_exports CurrentAccBal_percentGDP grw_neg previousimf lagunderimf lngdppc lngdp s2un duration if demoid == 1, cluster(ccode)

logit signed_imf reserves_mths debtserv_exports CurrentAccBal_percentGDP grw_neg previousimf lagunderimf lngdppc lngdp s2un duration if gwf_party == 1, cluster(ccode)

logit signed_imf reserves_mths debtserv_exports CurrentAccBal_percentGDP grw_neg previousimf lagunderimf lngdppc lngdp s2un duration if gwf_personal == 1, cluster(ccode)

logit signed_imf reserves_mths debtserv_exports CurrentAccBal_percentGDP grw_neg previousimf lagunderimf lngdppc lngdp s2un duration if gwf_military == 1, cluster(ccode)


*Table A8 & A9 - Main Results clustered on 'regimes'

*create a new identifying vaiable that separates out regimes ( only relevant for non-democracies)

gen newclusterid = autoc_reg_id if autoc_reg_id!=.
replace newclusterid = ccode if autoc_reg_id==.

tsset newclusterid year

**Estimate the model and create table of regression results
logit signed_imf lagunderimf reserves_mths resXparty resXmil resXpers debtserv_exports debtXparty debtXmil debtXpers CurrentAccBal_percentGDP cabXparty cabXpers cabXmil grw_neg negXparty negXmil negXpers previousimf partyXsov milXsov persXsov gwf_party gwf_personal gwf_military lngdppc lngdp s2un duration, cluster(newclusterid)

*Estimate the main model in clarify
estsimp logit signed_imf lagunderimf reserves_mths resXparty resXmil resXpers debtserv_exports debtXparty debtXmil debtXpers CurrentAccBal_percentGDP cabXparty cabXpers cabXmil grw_neg negXparty negXmil negXpers previousimf partyXsov milXsov persXsov gwf_party gwf_personal gwf_military lngdppc lngdp s2un duration, cluster(newclusterid)

*DEMOCRACIES (BASELINE / EXCLUDED CATEGORY)*
*Col 1
setx lagunderimf 0.5 reserves_mths 3.3 resXparty 0 resXmil 0 resXpers 0 debtserv_exports 18 debtXparty 0 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -4.9 cabXparty 0 cabXpers 0 cabXmil 0 grw_neg 0.3 negXparty 0 negXmil 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 0 previousimf 0.8 partyXsov 0 milXsov 0 persXsov 0 duration 17.5
simqi, prval(1)
*Col 2
setx lagunderimf 0.5 reserves_mths 1 resXparty 0 resXmil 0 resXpers 0 debtserv_exports 100 debtXparty 0 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers 0 cabXmil 0 grw_neg 0.8 negXparty 0 negXmil 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 0 previousimf 0.8 partyXsov 0 milXsov 0 persXsov 0 duration 17.5
simqi, prval(1)
*Col 3
simqi, fd(prval(1)) changex(reserves_mths 3.3 1 debtserv_exports 17.6 100  CurrentAccBal_percentGDP -5.1 -10  grw_neg 0.3 0.8)
*Col 4
setx lagunderimf 0 reserves_mths 1 resXparty 0 resXmil 0 resXpers 0 debtserv_exports 100 debtXparty 0 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers 0 cabXmil 0 grw_neg 0.8 negXparty 0 negXmil 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 0 previousimf 0 partyXsov 0 milXsov 0 persXsov 0 duration 17.5
simqi, prval(1)
*Col 5
setx lagunderimf 1 reserves_mths 1 resXparty 0 resXmil 0 resXpers 0 debtserv_exports 100 debtXparty 0 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers 0 cabXmil 0 grw_neg 0.8 negXparty 0 negXmil 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 0 previousimf 1 partyXsov 0 milXsov 0 persXsov 0 duration 17.5
simqi, prval(1)
*Col 6
simqi, fd(prval(1)) changex(previousimf 0 1 lagunderimf 0 1)


*PARTY BASED AUTOCRACIES*
*Col 1
setx lagunderimf 0.5 reserves_mths 3.3 resXparty 3.3 resXmil 0 resXpers 0 debtserv_exports 18 debtXparty 17.6 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -4.9 cabXparty -5.1 cabXpers 0 cabXmil 0 grw_neg 0.3 negXparty 0.3 negXmil 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 1 gwf_personal 0 gwf_military 0 previousimf 0.8 partyXsov 0.8 milXsov 0 persXsov 0 duration 17.5
simqi, prval(1)
*Col 2
setx lagunderimf 0.5 reserves_mths 1 resXparty 1 resXmil 0 resXpers 0 debtserv_exports 100 debtXparty 100 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty -10 cabXpers 0 cabXmil 0 grw_neg 0.8 negXparty 0.8 negXmil 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 1 gwf_personal 0 gwf_military 0 previousimf 0.8 partyXsov 0.8 milXsov 0 persXsov 0 duration 17.5
simqi, prval(1)
*Col 3
simqi, fd(prval(1)) changex(reserves_mths 3.3 1 resXparty 3.3 1 debtserv_exports 17.6 100 debtXparty 17.6 100 CurrentAccBal_percentGDP -5.1 -10 cabXparty -5.1 -10 grw_neg 0.3 0.8 negXparty 0.3 0.8)
*Col 4
setx lagunderimf 0 reserves_mths 1 resXparty 1 resXmil 0 resXpers 0 debtserv_exports 100 debtXparty 100 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty -10 cabXpers 0 cabXmil 0 grw_neg 0.8 negXparty 0.8 negXmil 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 1 gwf_personal 0 gwf_military 0 previousimf 0 partyXsov 0 milXsov 0 persXsov 0 duration 17.5
simqi, prval(1)
*Col 5
setx lagunderimf 1 reserves_mths 1 resXparty 1 resXmil 0 resXpers 0 debtserv_exports 100 debtXparty 100 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty -10 cabXpers 0 cabXmil 0 grw_neg 0.8 negXparty 0.8 negXmil 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 1 gwf_personal 0 gwf_military 0 previousimf 1 partyXsov 1 milXsov 0 persXsov 0 duration 17.5
simqi, prval(1)
*Col 6
simqi, fd(prval(1)) changex(previousimf 0 1 lagunderimf 0 1 partyXsov 0 1)


*PERSONALIST AUTOCRACIES*
*Col 1
setx lagunderimf 0.5 reserves_mths 3.3 resXparty 0 resXmil 0 resXpers 3.3 debtserv_exports 18 debtXparty 0 debtXmil 0 debtXpers 17.6 CurrentAccBal_percentGDP -4.9 cabXparty 0 cabXpers -5.1 cabXmil 0 grw_neg 0.3 negXparty 0 negXmil 0 negXpers 0.3 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 1 gwf_military 0 previousimf 0.8 partyXsov 0 milXsov 0 persXsov 0.8 duration 17.5
simqi, prval(1)
*Col 2
setx lagunderimf 0.5 reserves_mths 1 resXparty 0 resXmil 0 resXpers 1 debtserv_exports 100 debtXparty 0 debtXmil 0 debtXpers 100 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers -10 cabXmil 0 grw_neg 0.8 negXparty 0 negXmil 0 negXpers 0.8 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 1 gwf_military 0 previousimf 0.8 partyXsov 0 milXsov 0 persXsov 0.8 duration 17.5
simqi, prval(1)
*Col 3
simqi, fd(prval(1)) changex(reserves_mths 3.3 1 resXpers 3.3 1 debtserv_exports 17.6 100 debtXpers 17.6 100 CurrentAccBal_percentGDP -5.1 -10 cabXpers -5.1 -10 grw_neg 0.3 0.8 negXpers 0.3 0.8)
*Col 4
setx lagunderimf 0 reserves_mths 1 resXparty 0 resXmil 0 resXpers 1 debtserv_exports 100 debtXparty 0 debtXmil 0 debtXpers 100 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers -10 cabXmil 0 grw_neg 0.8 negXparty 0 negXmil 0 negXpers 0.8 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 1 gwf_military 0 previousimf 0 partyXsov 0 milXsov 0 persXsov 0 duration 17.5
simqi, prval(1)
*Col 5
setx lagunderimf 1 reserves_mths 1 resXparty 0 resXmil 0 resXpers 1 debtserv_exports 100 debtXparty 0 debtXmil 0 debtXpers 100 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers -10 cabXmil 0 grw_neg 0.8 negXparty 0 negXmil 0 negXpers 0.8 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 1 gwf_military 0 previousimf 1 partyXsov 0 milXsov 0 persXsov 1 duration 17.5
simqi, prval(1)
*Col 6
simqi, fd(prval(1)) changex(previousimf 0 1 lagunderimf 0 1 persXsov 0 1)


*MILITARY REGIMES*
*Col 1
setx lagunderimf 0.5 reserves_mths 3.3 resXparty 0 resXmil 3.3 resXpers 0 debtserv_exports 18 debtXparty 0 debtXmil 17.6 debtXpers 0 CurrentAccBal_percentGDP -4.9 cabXparty 0 cabXpers 0 cabXmil -5.1 grw_neg 0.3 negXparty 0 negXmil 0.3 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 1 previousimf 0.8 partyXsov 0 milXsov 0.8 persXsov 0 duration 17.5
simqi, prval(1)
*Col 2
setx lagunderimf 0.5 reserves_mths 1 resXparty 0 resXmil 1 resXpers 0 debtserv_exports 100 debtXparty 0 debtXmil 100 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers 0 cabXmil -10 grw_neg 0.8 negXparty 0 negXmil 0.8 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 1 previousimf 0.8 partyXsov 0 milXsov 0.8 persXsov 0 duration 17.5
simqi, prval(1)
*Col 3
simqi, fd(prval(1)) changex(reserves_mths 3.3 1 resXmil 3.3 1 debtserv_exports 17.6 100 debtXmil 17.6 100 CurrentAccBal_percentGDP -5.1 -10 cabXmil -5.1 -10 grw_neg 0.3 0.8 negXmil 0.3 0.8)
*Col 4
setx lagunderimf 0 reserves_mths 1 resXparty 0 resXmil 1 resXpers 0 debtserv_exports 100 debtXparty 0 debtXmil 100 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers 0 cabXmil -10 grw_neg 0.8 negXparty 0 negXmil 0.8 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 1 previousimf 0 partyXsov 0 milXsov 0 persXsov 0 duration 17.5
simqi, prval(1)
*Col 5
setx lagunderimf 1 reserves_mths 1 resXparty 0 resXmil 1 resXpers 0 debtserv_exports 100 debtXparty 0 debtXmil 100 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers 0 cabXmil -10 grw_neg 0.8 negXparty 0 negXmil 0.8 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 1 previousimf 1 partyXsov 0 milXsov 1 persXsov 0 duration 17.5
simqi, prval(1)
*Col 6
simqi, fd(prval(1)) changex(previousimf 0 1 lagunderimf 0 1 milXsov 0 1)

drop b*


*Tables A10 & A11 - Main results, with continuous measure of economic growth

tsset ccode year

*use of gdppc_grow instead of the binary negative growth year variable
rename gdppc_grow growth
gen growXparty = growth*gwf_party
gen growXpers = growth*gwf_personal
gen growXmil = growth*gwf_military

*Main model, with new growth and interactions substituted
logit signed_imf lagunderimf reserves_mths resXparty resXmil resXpers debtserv_exports debtXparty debtXmil debtXpers CurrentAccBal_percentGDP cabXparty cabXpers cabXmil growth growXparty growXmil growXpers previousimf partyXsov milXsov persXsov gwf_party gwf_personal gwf_military lngdppc lngdp s2un duration, cluster(ccode)

centile growth, centile (10 15 20 25 50) 
centile reserves_mths, centile (10 15 20 25 50)
*use -2.6 as crisis level in variable growth (because this is roughly the 15% of the distribution in the sample, which is about the same for the other variable simulated values, such as reserves)

*Estimate the main model in clarify
estsimp logit signed_imf lagunderimf reserves_mths resXparty resXmil resXpers debtserv_exports debtXparty debtXmil debtXpers CurrentAccBal_percentGDP cabXparty cabXpers cabXmil growth growXparty growXmil growXpers previousimf partyXsov milXsov persXsov gwf_party gwf_personal gwf_military lngdppc lngdp s2un duration, cluster(ccode)

*DEMOCRACIES (BASELINE / EXCLUDED CATEGORY)*
*Col 1
setx lagunderimf 0.5 reserves_mths 3.3 resXparty 0 resXmil 0 resXpers 0 debtserv_exports 18 debtXparty 0 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -4.9 cabXparty 0 cabXpers 0 cabXmil 0 growth 1.8 growXparty 0 growXmil 0 growXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 0 previousimf 0.8 partyXsov 0 milXsov 0 persXsov 0 duration 17.5
simqi, prval(1)
*Col 2
setx lagunderimf 0.5 reserves_mths 1 resXparty 0 resXmil 0 resXpers 0 debtserv_exports 100 debtXparty 0 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers 0 cabXmil 0 growth -2.6 growXparty 0 growXmil 0 growXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 0 previousimf 0.8 partyXsov 0 milXsov 0 persXsov 0 duration 17.5
simqi, prval(1)
*Col 3
simqi, fd(prval(1)) changex(reserves_mths 3.3 1 debtserv_exports 17.6 100  CurrentAccBal_percentGDP -5.1 -10  growth 1.8 -2.6)
*Col 4
setx lagunderimf 0 reserves_mths 1 resXparty 0 resXmil 0 resXpers 0 debtserv_exports 100 debtXparty 0 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers 0 cabXmil 0 growth -2.6 growXparty 0 growXmil 0 growXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 0 previousimf 0 partyXsov 0 milXsov 0 persXsov 0 duration 17.5
simqi, prval(1)
*Col 5
setx lagunderimf 1 reserves_mths 1 resXparty 0 resXmil 0 resXpers 0 debtserv_exports 100 debtXparty 0 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers 0 cabXmil 0 growth -2.6 growXparty 0 growXmil 0 growXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 0 previousimf 1 partyXsov 0 milXsov 0 persXsov 0 duration 17.5
simqi, prval(1)
*Col 6
simqi, fd(prval(1)) changex(previousimf 0 1 lagunderimf 0 1)

*PARTY BASED AUTOCRACIES*
*Col 1
setx lagunderimf 0.5 reserves_mths 3.3 resXparty 3.3 resXmil 0 resXpers 0 debtserv_exports 18 debtXparty 17.6 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -4.9 cabXparty -5.1 cabXpers 0 cabXmil 0 growth 1.8 growXparty 1.8 growXmil 0 growXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 1 gwf_personal 0 gwf_military 0 previousimf 0.8 partyXsov 0.8 milXsov 0 persXsov 0 duration 17.5
simqi, prval(1)
*Col 2
setx lagunderimf 0.5 reserves_mths 1 resXparty 1 resXmil 0 resXpers 0 debtserv_exports 100 debtXparty 100 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty -10 cabXpers 0 cabXmil 0 growth -2.6 growXparty -2.6 growXmil 0 growXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 1 gwf_personal 0 gwf_military 0 previousimf 0.8 partyXsov 0.8 milXsov 0 persXsov 0 duration 17.5
simqi, prval(1)
*Col 3
simqi, fd(prval(1)) changex(reserves_mths 3.3 1 resXparty 3.3 1 debtserv_exports 17.6 100 debtXparty 17.6 100 CurrentAccBal_percentGDP -5.1 -10 cabXparty -5.1 -10 growth 1.8 -2.6 growXparty 1.80 -2.6)
*Col 4
setx lagunderimf 0 reserves_mths 1 resXparty 1 resXmil 0 resXpers 0 debtserv_exports 100 debtXparty 100 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty -10 cabXpers 0 cabXmil 0 growth -2.6 growXparty -2.6 growXmil 0 growXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 1 gwf_personal 0 gwf_military 0 previousimf 0 partyXsov 0 milXsov 0 persXsov 0 duration 17.5
simqi, prval(1)
*Col 5
setx lagunderimf 1 reserves_mths 1 resXparty 1 resXmil 0 resXpers 0 debtserv_exports 100 debtXparty 100 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty -10 cabXpers 0 cabXmil 0 growth -2.6 growXparty -2.6 growXmil 0 growXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 1 gwf_personal 0 gwf_military 0 previousimf 1 partyXsov 1 milXsov 0 persXsov 0 duration 17.5
simqi, prval(1)
*Col 6
simqi, fd(prval(1)) changex(previousimf 0 1 lagunderimf 0 1 partyXsov 0 1)

*PERSONALIST AUTOCRACIES*
*Col 1
setx lagunderimf 0.5 reserves_mths 3.3 resXparty 0 resXmil 0 resXpers 3.3 debtserv_exports 18 debtXparty 0 debtXmil 0 debtXpers 17.6 CurrentAccBal_percentGDP -4.9 cabXparty 0 cabXpers -5.1 cabXmil 0 growth 1.8 growXparty 0 growXmil 0 growXpers 1.8 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 1 gwf_military 0 previousimf 0.8 partyXsov 0 milXsov 0 persXsov 0.8 duration 17.5
simqi, prval(1)
*Col 2
setx lagunderimf 0.5 reserves_mths 1 resXparty 0 resXmil 0 resXpers 1 debtserv_exports 100 debtXparty 0 debtXmil 0 debtXpers 100 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers -10 cabXmil 0 growth -2.6 growXparty 0 growXmil 0 growXpers -2.6 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 1 gwf_military 0 previousimf 0.8 partyXsov 0 milXsov 0 persXsov 0.8 duration 17.5
simqi, prval(1)
*Col 3
simqi, fd(prval(1)) changex(reserves_mths 3.3 1 resXpers 3.3 1 debtserv_exports 17.6 100 debtXpers 17.6 100 CurrentAccBal_percentGDP -5.1 -10 cabXpers -5.1 -10 growth 1.8 -2.6 growXpers 1.8 -2.6)
*Col 4
setx lagunderimf 0 reserves_mths 1 resXparty 0 resXmil 0 resXpers 1 debtserv_exports 100 debtXparty 0 debtXmil 0 debtXpers 100 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers -10 cabXmil 0 growth -2.6 growXparty 0 growXmil 0 growXpers -2.6 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 1 gwf_military 0 previousimf 0 partyXsov 0 milXsov 0 persXsov 0 duration 17.5
simqi, prval(1)
*Col 5
setx lagunderimf 1 reserves_mths 1 resXparty 0 resXmil 0 resXpers 1 debtserv_exports 100 debtXparty 0 debtXmil 0 debtXpers 100 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers -10 cabXmil 0 growth -2.6 growXparty 0 growXmil 0 growXpers -2.6 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 1 gwf_military 0 previousimf 1 partyXsov 0 milXsov 0 persXsov 1 duration 17.5
simqi, prval(1)
*Col 6
simqi, fd(prval(1)) changex(previousimf 0 1 lagunderimf 0 1 persXsov 0 1)

*MILITARY REGIMES*
*Col 1
setx lagunderimf 0.5 reserves_mths 3.3 resXparty 0 resXmil 3.3 resXpers 0 debtserv_exports 18 debtXparty 0 debtXmil 17.6 debtXpers 0 CurrentAccBal_percentGDP -4.9 cabXparty 0 cabXpers 0 cabXmil -5.1 growth 1.8 growXparty 0 growXmil 1.8 growXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 1 previousimf 0.8 partyXsov 0 milXsov 0.8 persXsov 0 duration 17.5
simqi, prval(1)
*Col 2
setx lagunderimf 0.5 reserves_mths 1 resXparty 0 resXmil 1 resXpers 0 debtserv_exports 100 debtXparty 0 debtXmil 100 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers 0 cabXmil -10 growth -2.6 growXparty 0 growXmil -2.6 growXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 1 previousimf 0.8 partyXsov 0 milXsov 0.8 persXsov 0 duration 17.5
simqi, prval(1)
*Col 3
simqi, fd(prval(1)) changex(reserves_mths 3.3 1 resXmil 3.3 1 debtserv_exports 17.6 100 debtXmil 17.6 100 CurrentAccBal_percentGDP -5.1 -10 cabXmil -5.1 -10 growth 1.8 -2.6 growXmil 1.80 -2.6)
*Col 4
setx lagunderimf 0 reserves_mths 1 resXparty 0 resXmil 1 resXpers 0 debtserv_exports 100 debtXparty 0 debtXmil 100 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers 0 cabXmil -10 growth -2.6 growXparty 0 growXmil -2.6 growXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 1 previousimf 0 partyXsov 0 milXsov 0 persXsov 0 duration 17.5
simqi, prval(1)
*Col 5
setx lagunderimf 1 reserves_mths 1 resXparty 0 resXmil 1 resXpers 0 debtserv_exports 100 debtXparty 0 debtXmil 100 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers 0 cabXmil -10 growth -2.6 growXparty 0 growXmil -2.6 growXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 1 previousimf 1 partyXsov 0 milXsov 1 persXsov 0 duration 17.5
simqi, prval(1)
*Col 6
simqi, fd(prval(1)) changex(previousimf 0 1 lagunderimf 0 1 milXsov 0 1)


drop b*


*Tables A12 & A13 - Main results, with dummy variable for post-Bretton Woods era (1972 onward)

gen collapse = 0
replace collapse = 1 if year>=1972
label var collapse "Post Bretton Woods Dummy Variable"

logit signed_imf lagunderimf reserves_mths resXparty resXmil resXpers debtserv_exports debtXparty debtXmil debtXpers CurrentAccBal_percentGDP cabXparty cabXpers cabXmil grw_neg negXparty negXmil negXpers previousimf partyXsov milXsov persXsov gwf_party gwf_personal gwf_military lngdppc lngdp s2un duration collapse, cluster(ccode)

*Estimate the main model in clarify
estsimp logit signed_imf lagunderimf reserves_mths resXparty resXmil resXpers debtserv_exports debtXparty debtXmil debtXpers CurrentAccBal_percentGDP cabXparty cabXpers cabXmil grw_neg negXparty negXmil negXpers previousimf partyXsov milXsov persXsov gwf_party gwf_personal gwf_military lngdppc lngdp s2un duration collapse, cluster(ccode)

*DEMOCRACIES (BASELINE / EXCLUDED CATEGORY)*
*Col 1
setx lagunderimf 0.5 reserves_mths 3.3 resXparty 0 resXmil 0 resXpers 0 debtserv_exports 18 debtXparty 0 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -4.9 cabXparty 0 cabXpers 0 cabXmil 0 grw_neg 0.3 negXparty 0 negXmil 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 0 previousimf 0.8 partyXsov 0 milXsov 0 persXsov 0 duration 17.5 collapse 1
simqi, prval(1)
*Col 2
setx lagunderimf 0.5 reserves_mths 1 resXparty 0 resXmil 0 resXpers 0 debtserv_exports 100 debtXparty 0 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers 0 cabXmil 0 grw_neg 0.8 negXparty 0 negXmil 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 0 previousimf 0.8 partyXsov 0 milXsov 0 persXsov 0 duration 17.5 collapse 1
simqi, prval(1)
*Col 3
simqi, fd(prval(1)) changex(reserves_mths 3.3 1 debtserv_exports 17.6 100  CurrentAccBal_percentGDP -5.1 -10  grw_neg 0.3 0.8)
*Col 4
setx lagunderimf 0 reserves_mths 1 resXparty 0 resXmil 0 resXpers 0 debtserv_exports 100 debtXparty 0 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers 0 cabXmil 0 grw_neg 0.8 negXparty 0 negXmil 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 0 previousimf 0 partyXsov 0 milXsov 0 persXsov 0 duration 17.5 collapse 1
simqi, prval(1)
*Col 5
setx lagunderimf 1 reserves_mths 1 resXparty 0 resXmil 0 resXpers 0 debtserv_exports 100 debtXparty 0 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers 0 cabXmil 0 grw_neg 0.8 negXparty 0 negXmil 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 0 previousimf 1 partyXsov 0 milXsov 0 persXsov 0 duration 17.5 collapse 1
simqi, prval(1)
*Col 6
simqi, fd(prval(1)) changex(previousimf 0 1 lagunderimf 0 1)

*PARTY BASED AUTOCRACIES*
*Col 1
setx lagunderimf 0.5 reserves_mths 3.3 resXparty 3.3 resXmil 0 resXpers 0 debtserv_exports 18 debtXparty 17.6 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -4.9 cabXparty -5.1 cabXpers 0 cabXmil 0 grw_neg 0.3 negXparty 0.3 negXmil 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 1 gwf_personal 0 gwf_military 0 previousimf 0.8 partyXsov 0.8 milXsov 0 persXsov 0 duration 17.5 collapse 1
simqi, prval(1)
*Col 2
setx lagunderimf 0.5 reserves_mths 1 resXparty 1 resXmil 0 resXpers 0 debtserv_exports 100 debtXparty 100 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty -10 cabXpers 0 cabXmil 0 grw_neg 0.8 negXparty 0.8 negXmil 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 1 gwf_personal 0 gwf_military 0 previousimf 0.8 partyXsov 0.8 milXsov 0 persXsov 0 duration 17.5 collapse 1
simqi, prval(1)
*Col 3
simqi, fd(prval(1)) changex(reserves_mths 3.3 1 resXparty 3.3 1 debtserv_exports 17.6 100 debtXparty 17.6 100 CurrentAccBal_percentGDP -5.1 -10 cabXparty -5.1 -10 grw_neg 0.3 0.8 negXparty 0.3 0.8)
*Col 4
setx lagunderimf 0 reserves_mths 1 resXparty 1 resXmil 0 resXpers 0 debtserv_exports 100 debtXparty 100 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty -10 cabXpers 0 cabXmil 0 grw_neg 0.8 negXparty 0.8 negXmil 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 1 gwf_personal 0 gwf_military 0 previousimf 0 partyXsov 0 milXsov 0 persXsov 0 duration 17.5 collapse 1
simqi, prval(1)
*Col 5
setx lagunderimf 1 reserves_mths 1 resXparty 1 resXmil 0 resXpers 0 debtserv_exports 100 debtXparty 100 debtXmil 0 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty -10 cabXpers 0 cabXmil 0 grw_neg 0.8 negXparty 0.8 negXmil 0 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 1 gwf_personal 0 gwf_military 0 previousimf 1 partyXsov 1 milXsov 0 persXsov 0 duration 17.5 collapse 1
simqi, prval(1)
*Col 6
simqi, fd(prval(1)) changex(previousimf 0 1 lagunderimf 0 1 partyXsov 0 1)

*PERSONALIST AUTOCRACIES*
*Col 1
setx lagunderimf 0.5 reserves_mths 3.3 resXparty 0 resXmil 0 resXpers 3.3 debtserv_exports 18 debtXparty 0 debtXmil 0 debtXpers 17.6 CurrentAccBal_percentGDP -4.9 cabXparty 0 cabXpers -5.1 cabXmil 0 grw_neg 0.3 negXparty 0 negXmil 0 negXpers 0.3 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 1 gwf_military 0 previousimf 0.8 partyXsov 0 milXsov 0 persXsov 0.8 duration 17.5 collapse 1
simqi, prval(1)
*Col 2
setx lagunderimf 0.5 reserves_mths 1 resXparty 0 resXmil 0 resXpers 1 debtserv_exports 100 debtXparty 0 debtXmil 0 debtXpers 100 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers -10 cabXmil 0 grw_neg 0.8 negXparty 0 negXmil 0 negXpers 0.8 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 1 gwf_military 0 previousimf 0.8 partyXsov 0 milXsov 0 persXsov 0.8 duration 17.5 collapse 1
simqi, prval(1)
*Col 3
simqi, fd(prval(1)) changex(reserves_mths 3.3 1 resXpers 3.3 1 debtserv_exports 17.6 100 debtXpers 17.6 100 CurrentAccBal_percentGDP -5.1 -10 cabXpers -5.1 -10 grw_neg 0.3 0.8 negXpers 0.3 0.8)
*Col 4
setx lagunderimf 0 reserves_mths 1 resXparty 0 resXmil 0 resXpers 1 debtserv_exports 100 debtXparty 0 debtXmil 0 debtXpers 100 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers -10 cabXmil 0 grw_neg 0.8 negXparty 0 negXmil 0 negXpers 0.8 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 1 gwf_military 0 previousimf 0 partyXsov 0 milXsov 0 persXsov 0 duration 17.5 collapse 1
simqi, prval(1)
*Col 5
setx lagunderimf 1 reserves_mths 1 resXparty 0 resXmil 0 resXpers 1 debtserv_exports 100 debtXparty 0 debtXmil 0 debtXpers 100 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers -10 cabXmil 0 grw_neg 0.8 negXparty 0 negXmil 0 negXpers 0.8 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 1 gwf_military 0 previousimf 1 partyXsov 0 milXsov 0 persXsov 1 duration 17.5 collapse 1
simqi, prval(1)
*Col 6
simqi, fd(prval(1)) changex(previousimf 0 1 lagunderimf 0 1 persXsov 0 1)

*MILITARY REGIMES*
*Col 1
setx lagunderimf 0.5 reserves_mths 3.3 resXparty 0 resXmil 3.3 resXpers 0 debtserv_exports 18 debtXparty 0 debtXmil 17.6 debtXpers 0 CurrentAccBal_percentGDP -4.9 cabXparty 0 cabXpers 0 cabXmil -5.1 grw_neg 0.3 negXparty 0 negXmil 0.3 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 1 previousimf 0.8 partyXsov 0 milXsov 0.8 persXsov 0 duration 17.5 collapse 1
simqi, prval(1)
*Col 2
setx lagunderimf 0.5 reserves_mths 1 resXparty 0 resXmil 1 resXpers 0 debtserv_exports 100 debtXparty 0 debtXmil 100 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers 0 cabXmil -10 grw_neg 0.8 negXparty 0 negXmil 0.8 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 1 previousimf 0.8 partyXsov 0 milXsov 0.8 persXsov 0 duration 17.5 collapse 1
simqi, prval(1)
*Col 3
simqi, fd(prval(1)) changex(reserves_mths 3.3 1 resXmil 3.3 1 debtserv_exports 17.6 100 debtXmil 17.6 100 CurrentAccBal_percentGDP -5.1 -10 cabXmil -5.1 -10 grw_neg 0.3 0.8 negXmil 0.3 0.8)
*Col 4
setx lagunderimf 0 reserves_mths 1 resXparty 0 resXmil 1 resXpers 0 debtserv_exports 100 debtXparty 0 debtXmil 100 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers 0 cabXmil -10 grw_neg 0.8 negXparty 0 negXmil 0.8 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 1 previousimf 0 partyXsov 0 milXsov 0 persXsov 0 duration 17.5 collapse 1
simqi, prval(1)
*Col 5
setx lagunderimf 1 reserves_mths 1 resXparty 0 resXmil 1 resXpers 0 debtserv_exports 100 debtXparty 0 debtXmil 100 debtXpers 0 CurrentAccBal_percentGDP -10 cabXparty 0 cabXpers 0 cabXmil -10 grw_neg 0.8 negXparty 0 negXmil 0.8 negXpers 0 lngdppc 6.9 lngdp 22.6 s2un 0.1 gwf_party 0 gwf_personal 0 gwf_military 1 previousimf 1 partyXsov 0 milXsov 1 persXsov 0 duration 17.5 collapse 1
simqi, prval(1)
*Col 6
simqi, fd(prval(1)) changex(previousimf 0 1 lagunderimf 0 1 milXsov 0 1)

drop b*
