**************************************************
*
* Paul Musgrave and Yu-Ming Liou
* rpm47@georgetown.edu and yl254@georgetown.edu
* 
* Created 27 February 2016
*
**************************************************

**************************************************
* Stata Housekeeping
**************************************************

clear all
capture log close
set more off


version 11.1

*  Change to your valid directory path
cd "/Users/paulmusgrave/Dropbox/0001 Academic Projects/Ongoing/0127 Oil Islam Women/ISQ Accepted Submission/Replication/Data"

use ISQFINALXSDataforStata.dta, clear

cd "../Drafts/Tables"

lab var age15_64 "Pct Age 15--64"


**************************************************
* Generating new analyses
**************************************************


order avgflfp19932002 avgflfp20002009 OIPC9302 ///
OIPC0009 OIPC6372 avggdppc19932002 avggdppc20002009 ///
avgpolity0009 logGDPcap6372 polity6372 islam6372 ///
age1564_6372 laborfemaleMOD6372 logGDP1993 logGDP2000 ///
OIPC9302_1k OIPC0009_1k OIPC6372_1k OIPC6372_me, last

/*
* * * * * * * * * * * * * * * * * * * * * * * * * 
* Define Ross Table 4 (p. 114, 2008 article) macros
* These are also on Ross 2012, p. 142
* * * * * * * * * * * * * * * * * * * * * * * * * 

* This first set of models directly reproduce
* Ross's models from p. 142, with the exception
* of model #4a, which uses the standard
* World Bank definition of FLFP. Ross derogates
* this; note that it does inflate the impact
* of oil relative to Ross's definition.

local p142base_1 logGDPcap_2000 me_nafr_2000
local p142base_2 logGDPcap_2000 me_nafr_2000 oil_gas_valuePOPred
local p142base_3 logGDPcap_2000 me_nafr_2000 oil_gas_valuePOPred islam_2000 
local p142base_4a logGDPcap_2000 me_nafr_2000 oil_gas_valuePOPred islam_2000 avgflfp19932002
local p142base_4 logGDPcap_2000 me_nafr_2000 oil_gas_valuePOPred islam_2000 laborfemaleMOD_2000
local p142base_5 logGDPcap_2000 me_nafr_2000 oil_gas_valuePOPred islam_2000 polity_2000

* The second set of models updates the data
* from Ross's models above for the period 
* 2000-2009 for use with the smoking DV.

* Note that we do NOT update Islam. It's
* a slow-moving variable.

* Note also that logGDP2000 IS the 
* properly adjusted variable. It's just 
* named after an earlier, dumber convention.

local p142late_1 logGDP2000 me_nafr_2000
local p142late_2 logGDP2000 me_nafr_2000 OIPC0009_1k
local p142late_3 logGDP2000 me_nafr_2000 OIPC0009_1k islam_2000
local p142late_4 logGDP2000 me_nafr_2000 OIPC0009_1k islam_2000 avgflfp20002009
local p142late_5 logGDP2000 me_nafr_2000 OIPC0009_1k islam_2000 avgpolity0009

* The third set of models retrodates the data
* from Ross's models above for the period 
* 1963-1972. These are part of the 'harsh'
* replications which tend to assert that the
* causal factors are in the relationship between
* oil and selectorate theory, not in the short-run
* economic channel Ross propounds.

* Note here that we CAN use Ross's measure, so we do.

local p142early_1 logGDPcap6372 me_nafr_2000
local p142early_2 logGDPcap6372 me_nafr_2000 OIPC6372_1k
local p142early_3 logGDPcap6372 me_nafr_2000 OIPC6372_1k islam6372
local p142early_4 logGDPcap6372 me_nafr_2000 OIPC6372_1k islam6372 laborfemaleMOD6372
local p142early_5 logGDPcap6372 me_nafr_2000 OIPC6372_1k islam6372 polity6372


* * * * * * * * * * * * * * * * * * * * * * * * * 
* Define Models for Ross p. 140
* * * * * * * * * * * * * * * * * * * * * * * * * 

* Note that these include LogGDP Squared
* That's Ross's choice, not ours, and it's our job 
* to replicate first, which we do

local p140base_1 logGDPcap_2000 logGDPcap2 age15_64 
local p140base_2 logGDPcap_2000 logGDPcap2 age15_64 oil_gas_valuePOPred
local p140base_3 logGDPcap_2000 logGDPcap2 age15_64 oil_gas_valuePOPred ///
		commie_2000 me_nafr_2000 islam_2000
local p140base_4 logGDPcap_2000 logGDPcap2 age15_64 oil_gas_valuePOPred ///
		commie_2000 me_nafr_2000 islam_2000 oil_gas_valuePOPred_me

* Now with lagged coavariates
* (We don't need a "late" version of these models
* because we're not running them in conjunction
* with the smoking DVs).

* Note that commie stays the same, since all the countries
* listed there for which it's meaningful were ACTUALLY
* Communist at the time.	

lab var commie_2000 "Communist"

gen logGDPcap6372_sq = logGDPcap6372 * logGDPcap6372
lab var logGDPcap6372_sq "GDP pc 63-72 squared"

local p140early_1 logGDPcap6372 logGDPcap6372_sq age1564_6372 
local p140early_2 logGDPcap6372 logGDPcap6372_sq age1564_6372 OIPC6372_1k
local p140early_3 logGDPcap6372 logGDPcap6372_sq age1564_6372 OIPC6372_1k ///
		commie_2000 me_nafr_2000 islam_2000
local p140early_4 logGDPcap6372 logGDPcap6372_sq age1564_6372 OIPC6372_1k ///
		commie_2000 me_nafr_2000 islam_2000 OIPC6372_me


* Now an alternative from Ross (2008) WITHOUT islam as
* a control. Note that this keeps the naming convention
* but is from a different source.
local p140base_5 logGDPcap_2000 logGDPcap2 age15_64 oil_gas_valuePOPred ///
		commie_2000 me_nafr_2000

local p140early_5 logGDPcap6372 logGDPcap6372_sq age1564_6372 OIPC6372_1k ///
		commie_2000 me_nafr_2000

* These do not include the squared term, because
* as we have explained elsewhere we're unconvinced
* that it's a good way to deal with the problem it
* claims.

local p140alt_1 logGDPcap_2000 age15_64 
local p140alt_2 logGDPcap_2000 age15_64 oil_gas_valuePOPred
local p140alt_3 logGDPcap_2000 age15_64 oil_gas_valuePOPred ///
		commie_2000 me_nafr_2000 islam_2000
local p140alt_4 logGDPcap_2000 age15_64 oil_gas_valuePOPred ///
		commie_2000 me_nafr_2000 islam_2000 oil_gas_valuePOPred_me

* Now with lagged coavariates

local p140altearly_1 logGDPcap6372 age1564_6372 
local p140altearly_2 logGDPcap6372 age1564_6372 OIPC6372_1k
local p140altearly_3 logGDPcap6372 age1564_6372 OIPC6372_1k ///
		commie_2000 me_nafr_2000 islam_2000
local p140altearly_4 logGDPcap6372 age1564_6372 OIPC6372_1k ///
		commie_2000 me_nafr_2000 islam_2000 OIPC6372_me

* Now an alternative from Ross (2008) WITHOUT islam as
* a control. Note that this keeps the naming convention
* but is from a different source.

local p140alt_5 logGDPcap_2000 age15_64 oil_gas_valuePOPred ///
		commie_2000 me_nafr_2000
		
local p140altearly_5 logGDPcap6372 age1564_6372 OIPC6372_1k ///
		commie_2000 me_nafr_2000
*/		

* * * * * * * * * * * * * * * * * * * * * * * * * 
* Demonstrating the importance of non-democratic
* states to Ross's arguments
* * * * * * * * * * * * * * * * * * * * * * * * * 

* First, we are going to recode countries as 
* missing if they have not established a parliament
* accoridng to Ross (2012)

gen female_seats_MOD = female_seats_2000
replace female_seats_MOD = . if polity_2000 == -10

*Replicate Ross
xi: reg female_seats_2000 logGDPcap_2000 me_nafr oil_gas_valuePOPred islam_2000, robust
eststo rossrepli

*Use our modified variable (Dropping -10s)

*Column 1: controls only
xi: reg female_seats_MOD logGDPcap_2000 me_nafr, robust
eststo rossrepli2

*Column 2: add oil
xi: reg female_seats_MOD logGDPcap_2000 me_nafr oil_gas_valuePOPred, robust
*outreg2 using table.doc if year==2000, nolabel append
eststo rossrepli3

*Column 3: add islam_2000
xi: reg female_seats_MOD logGDPcap_2000 me_nafr oil_gas_valuePOPred islam_2000, robust
eststo rossrepli4

*Column 4: add FLFP
xi: reg female_seats_MOD logGDPcap_2000 me_nafr oil_gas_valuePOPred islam_2000 ///
laborfemaleMOD_2000, robust
eststo rossrepli5

*Column 5: add polity_2000
xi: reg female_seats_MOD logGDPcap_2000 me_nafr oil_gas_valuePOPred islam_2000 ///
polity_2000, robust
eststo rossrepli6

*Column 6: add Proportional representation
xi: reg female_seats_MOD logGDPcap_2000 me_nafr oil_gas_valuePOPred islam_2000 ///
polity_2000 PR_MOD, robust
eststo rossrepli7


* Different approach ('female seats'=missing if Polity = -9 or -10)
gen female_seats_MOD2 = female_seats_2000 
replace female_seats_MOD2 = . if polity_2000 <= -9

*Column 1: controls only
xi: reg female_seats_MOD2 logGDPcap_2000 me_nafr, robust
eststo rossautoc1

*Column 2: add oil
xi: reg female_seats_MOD2 logGDPcap_2000 me_nafr oil_gas_valuePOPred, robust
*outreg2 using table.doc if year==2000, nolabel append
eststo rossautoc2

*Column 3: add islam_2000
xi: reg female_seats_MOD2 logGDPcap_2000 me_nafr oil_gas_valuePOPred islam_2000, robust
eststo rossautoc3

*Column 4: add FLFP
xi: reg female_seats_MOD2 logGDPcap_2000 me_nafr oil_gas_valuePOPred islam_2000 ///
laborfemaleMOD_2000, robust
eststo rossautoc4

*Column 5: add polity_2000
xi: reg female_seats_MOD2  logGDPcap_2000 me_nafr oil_gas_valuePOPred islam_2000 ///
polity_2000, robust
eststo rossautoc5

*Column 6: add Proportional representation
xi: reg female_seats_MOD2 logGDPcap_2000 me_nafr oil_gas_valuePOPred islam_2000 ///
polity_2000 PR_MOD, robust
eststo rossautoc6



* * * * * * * * * * * * * * * * * * * * * * * * * 
* Tables
* * * * * * * * * * * * * * * * * * * * * * * * * 

 
 esttab rossrepli2 rossrepli3 rossrepli4 rossrepli5 rossrepli6 rossrepli7 ////
using ISQFINALAppendixTable02.tex, ///
replace lab se star(+ 0.10 * 0.05 ** 0.01 *** 0.001) ///
mtitles("1" "2" "3" "4" "5" "6") ///
substitute({table} {sidewaystable}) compress ////
title ("Replicating Ross's Parliamentary Models Without Arab Oil Monarchies (Drop -10s)" \label{tab:Arab}) ///
addnotes("These models present Ross's models without countries" ///
"that have a Polity score of -10---countries that do not have meaningful parliaments, but which Ross's original models " ///
"included with values of zero (instead of missing) for share of females in parliament. Since there are no parliaments," ///
"we drop these countries in these estimations.") 

 

 esttab  rossautoc1 rossautoc2 rossautoc3 rossautoc4 rossautoc5 rossautoc6  ////
using ISQFINALAppendixTable03.tex, ///
replace lab se star(+ 0.10 * 0.05 ** 0.01 *** 0.001) ///
mtitles("1" "2" "3" "4" "5" "6") ///
substitute({table} {sidewaystable}) compress ////
title ("Replicating Ross's Parliamentary Models Without Arab Oil Monarchies (Drop -9s and -10s)" \label{tab:Arab}) ///
addnotes("These models present Ross's models without countries" ///
"that have a Polity score of -10 or -9---countries that do not have meaningful parliaments, but which Ross's original models " ///
"included with values of zero (instead of missing) for share of females in parliament. Since there are no parliaments," ///
"we drop these countries in these estimations.") 

**************************************************
* Stata Housekeeping
**************************************************

capture
