*Description: This file generates estimates in Table 7 of the online appendix.

*Preliminaries: You need to have the following data files in your current directory
*	1. data3d.txt
*	2. data2d.txt

clear
set more off

log using table07.log, replace

*---------------------------------------------
*** Table 8, Col. (1): The Benchmark Case ***
*---------------------------------------------

*** Import data ***
insheet c1 c1a c1b c2 cwp gap1 gap2 industry inst1_f inst2_ip inst3_t instf_1 instf_2 instf_3 instf_4 no_of_firms pat rnd rndint year empty using data3d.txt, tab
drop empty
drop if year<1976
drop if year>2001

*** Label variables ***
label var c1 "Competition (1 - LI)"
label var c1a "c1 allowing for LI as low as -1"
label var c1b "c1 based on median LI"
label var c2 "Competition (1 - H)"
label var cwp "Citation-weighted Patents"
label var gap1 "Technological Gap based on Labor Productivity"
label var gap2 "Technological Gap based on TFP"
label var industry "2-Digit SIC codes"
label var inst1_f "Freight as percentage of Import Value"
label var inst2_ip "Import Penetration"
label var inst3_t "Tariffs as percentage of Import Value"
label var instf_1 "Weighted Forex 1"
label var instf_2 "Weighted Forex 2"
label var instf_3 "Weighted Forex 3"
label var instf_4 "Weighted Forex 4"
label var no_of_firms "Number of Firms"
label var pat "Patents"
label var rnd "Research and Development Expenditure"
label var rndint "Research Intensity"
label var year "Year"

*** Generate time and industry dummies ***
tabulate industry, gen(ii)
tabulate year, gen(d)

*** Generate competition squared
gen c1sq = c1^2

* first stage
reg c1 instf_1 d* ii*
test instf_1
predict c1_cf, resid

* regression with control function
nbreg cwp c1 c1sq c1_cf d* ii*, vce(cluster industry)
test c1 c1sq

*--------------------------------------------
*** Table 8, Col. (2): The Poisson Model ***
*--------------------------------------------
poisson cwp c1 c1sq c1_cf d* ii*, vce(cluster industry)
test c1 c1sq

*--------------------------------------------------------------------
*** Table 8, Col. (3): An Alternative Definition of Competition ***
*			      	(Allow for LI as low as -1)
*--------------------------------------------------------------------
*** Generate competition squared
gen c1asq = c1a^2

* first stage
reg c1a instf_1 d* ii*
test instf_1
predict c1a_cf, resid

* regression with control function
nbreg cwp c1a c1asq c1a_cf d* ii*, vce(cluster industry)

test c1a c1asq

*--------------------------------------------------------------------
*** Table 8, Col. (4): An Alternative Definition of Competition ***
*			      (Use median of 1-LI instead of mean)
*--------------------------------------------------------------------
*** Generate competition squared
gen c1bsq = c1b^2

* first stage
reg c1b instf_1 d* ii*
test instf_1
predict c1b_cf, resid

* regression with control function
nbreg cwp c1b c1bsq c1b_cf d* ii*, vce(cluster industry)

test c1b c1bsq

*-----------------------------------------------------------
*** Table 8, Col. (5): Patents as the measure of innovation ***
*-----------------------------------------------------------
* regression with control function
nbreg pat c1 c1sq c1_cf d* ii*, vce(cluster industry)

test c1 c1sq

*-----------------------------------------------------------
*** Table 8, Col. (6): R&D as the measure of innovation ***
*-----------------------------------------------------------
*** First-stage regression ***
regress c1 instf_1 d* ii*
test instf_1
predict c1hat
gen c1hatsq = c1hat^2

*** Second-stage regression ***
regress rnd c1hat c1hatsq d* ii*, vce(cluster industry)
test c1hat c1hatsq

*--------------------------------------------
*** Table 8, Col. (7): Two-digit Data ***
*--------------------------------------------
clear

*** Import data ***
insheet c1 c1a c1b c2 cwp gap1 gap2 industry inst1_f inst2_ip inst3_t instf_1 instf_2 instf_3 instf_4 no_of_firms pat rnd rndint year empty using data2d.txt, tab
drop empty
drop if year<1976
drop if year>2001

*** Label variables ***
label var c1 "Competition (1 - LI)"
label var c1a "c1 allowing for LI as low as -1"
label var c1b "c1 based on median LI"
label var c2 "Competition (1 - H)"
label var cwp "Citation-weighted Patents"
label var gap1 "Technological Gap based on Labor Productivity"
label var gap2 "Technological Gap based on TFP"
label var industry "2-Digit SIC codes"
label var inst1_f "Freight as percentage of Import Value"
label var inst2_ip "Import Penetration"
label var inst3_t "Tariffs as percentage of Import Value"
label var instf_1 "Weighted Forex 1"
label var instf_2 "Weighted Forex 2"
label var instf_3 "Weighted Forex 3"
label var instf_4 "Weighted Forex 4"
label var no_of_firms "Number of Firms"
label var pat "Patents"
label var rnd "Research and Development Expenditure"
label var rndint "Research Intensity"
label var year "Year"

*** Generate time and industry dummies ***
tabulate industry, gen(ii)
tabulate year, gen(d)

*** Generate competition squared
gen c1sq = c1^2

* first stage
reg c1 instf_1 d* ii*
test instf_1
predict c1_cf, resid

* regression with control function
nbreg cwp c1 c1sq c1_cf d* ii*, vce(cluster industry)

test c1 c1sq
*---------------------------------------------------------------------------
log close


