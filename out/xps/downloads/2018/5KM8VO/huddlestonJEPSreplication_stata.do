/**************************
Author: R. Joseph Huddleston
Affiliation: Seton Hall University
Project: Replication file for "Think Ahead"
Prepared for the Journal of Experimental Political Science
Last updated 7/3/2018

Notes: 
This file preps data for graphics and tests in R, as well as
provides one table in the main body of the text and several
tables in the appendix.

This contains data from 4 experimental rounds. The main body uses
data from the first round, conducted in October 2015. 
The appendix section on the reputation prompt also uses data from 
rounds 3 and 4. This is all detailed in the the paper and appendix. 
These experiments also served other projects. 
Thus, reviewers may note a bit of data 
cleaning in this file. 

Please direct questions to 
R. Joseph Huddleston: joeyhuddleston@gmail.com (institutional email pending)
**************************/

clear
set more off

cap cd "INSERT WORKING DIRECTORY HERE"
log using "huddlestonJEPSlogstata", text replace
log on

// huddlestonJEPS is the full data file, from which all tests and figures 
// are derived
cap use "huddlestonJEPS.dta"

// This generates a simplified dataframe JEPSr, used in several points
// below and in the R file. 
keep cost costfirst vignette approve round reput repfirst treatgroup costrep

label define costl 0 "Tomz Prompt" 1 "Open Cost Prompt"
label values costfirst costl
label define repl 0 "Tomz Prompt" 1 "Open Rep Prompt"
label values repfirst repl
drop if vignette==4 //This drops "partial intervention" observations

// This specifies full control and treat conditions for Figure 4 in appendix
// "treatgroup" was a directly manipulated casualties and reputation variable
// for a different test in round 4 (March 2017). 
// Groups 3 and 8 are effective controls, so they are included in 
// the reputation analysis in the appendix, but not the main text's tests.
replace costfirst=0 if treatgroup==3 | treatgroup==8
replace repfirst=0 if repfirst==. & reputation!=. & costf==0
replace repfirst=1 if round==3 & costfirst==1

// This saves the simplified file.
saveold JEPSr.dta, replace

// This preps the data for Figures 1 and 2
// Then exports the data graphs generated in the R file
// This is just October 2015 respondents (First round)
keep if (costfirst==0 & vignette<4 & round==1) | ///
 (costfirst==1 & vignette<4 & round==1)
saveold costfirstgraph_r, replace // For analysis and plot, move to R file



// Tests for Table 1
// Comparing "absolute audience costs" across treatment, casualties
// October 2015 respondents
clear
use "JEPSr.dta"

// Disapprove strongly, control
cap gen bs=0
replace bs=1 if approve==1
ttest bs if costfirst==0 & round ==1 & vign<3, by(vign)
// disapprove somewhat, control
cap gen bd=0
replace bd=1 if approve==2
ttest bd if costfirst==0 & vign<3 & round ==1, by(vign)
// disapprove strongly, cost prompt first
cap gen be=0
replace be=1 if approve==1
ttest be if costfirst==1 & round ==1 & vign<3 & costrep!=0, by(vign)
//disapprove somewhat, cost prompt first
cap gen bf=0
replace bf=1 if approve==2
ttest bf if costfirst==1 & round ==1 & vign<3 & costrep!=0, by(vign)



// Generate R file of predicted values for Figure 3
// Logit model with demographic controls
// Full slate of logit and probit tests comes next
clear
cap use "huddlestonJEPS.dta"
keep if round==1 //limit to October 2015 respondents
set more off
// Specify the reference category
char vignette[omit]2
// Generate predictions for R file for Figure 3, empty threat 
ologit approve i.age i.gender b4.party i.edu i.race ///
costfirst if vign==1 //all demographics
predict emp1 emp2 emp3 emp4 emp5 emp6 emp7
// Generate a series of variables with mean predicted probabilities of 
// self-assignment to each ordinal approval level
// across control and treat conditions
foreach v of varlist emp1-emp7{
egen `v'_a= mean(`v') if costf==0 // mean predictions for control observations
egen `v'_b= mean(`v') if costf==1 // mean predictions for treated observations
egen `v'_c= mean(`v'_a) // mean prediction for all control
egen `v'_d= mean(`v'_b) // mean prediction for all treated
gen `v'_11=`v'_d-`v'_c // difference in effect due to casualties prime
}
drop *_a *_b *_c *_d
// Generate predictions for R file for Figure 3, follow through
ologit approve i.age i.gender b4.party i.edu i.race ///
costfirst if vign==3 & gender<3
predict fol1 fol2 fol3 fol4 fol5 fol6 fol7
foreach v of varlist fol1-fol7{
egen `v'_a= mean(`v') if costf==0
egen `v'_b= mean(`v') if costf==1
egen `v'_c= mean(`v'_a)
egen `v'_d= mean(`v'_b)
gen `v'_11=`v'_d-`v'_c
}
drop *_a *_b *_c *_d

keep *_11 // keep only the values for effect of casualties prime
keep in 1 // Keep one row with all values
// Rename to simplify
rename emp1 emp1
rename emp2 emp2
rename emp3 emp3
rename emp4 emp4
rename emp5 emp5
rename emp6 emp6
rename emp7 emp7
rename fol1 fol1
rename fol2 fol2
rename fol3 fol3
rename fol4 fol4
rename fol5 fol5
rename fol6 fol6
rename fol7 fol7
// reshape long to get a file compatible with R ggplot
gen id="id"
reshape long emp fol, i(id) j(order)
label define app 1 "Strongly Disapprove" 2 "Disapprove" 3 "Lean Disapprove" ///
4 "Neutral" 5 "Lean Approve" 6 "Approve" 7 "Strongly Approve"
label values order app
drop id
// Export dataframe for visualization in R
saveold likertapprovepredictgraphcontrol, replace



// Full tests for Figure 3, Tables 4a and 4b in appendix
// October 2015 respondents
// Logit for predicted change in approval
// Probit and demographic robustness checks
clear
cap use "huddlestonJEPS.dta"
keep if round==1
set more off
char vignette[omit]2
// All logit models reported in Table 4a in appendix

// Empty Threat scenario
// Base logit
ologit approve costfirst if vign==1
// Robust to probit
oprobit approve costfirst if vign==1
// Robust to controls
oprobit approve i.age i.gender i.party i.edu i.race ///
costfirst if vign==1

// Stay Out scenario
// Base Logit
ologit approve costfirst if vign==2

// Follow Through scenario
// Base logit
ologit approve costfirst if vign==3
// Robust to probit
oprobit approve costfirst if vign==3 
// Robust to controls
oprobit approve i.age i.gender i.party i.edu i.race ///
costfirst if vign==3



// Figure 4 in Appendix
// Data for R reputation prompt graphs
// Oct. 2015, Dec. 2016, and March 2017 respondents
clear
use "JEPSr.dta"
keep if (costfirst==0 & repfirst==0 & vignette<3) | ///
 (repfirst==1 & costrep!=1 & vignette<3)
keep if treatgroup==.|treatg==3|treatg==8
saveold repfirstgraph_r, replace



// Tables 5a and 5b, Testing parallel assumptions
// In these tests you want p>.05, explained in text
clear
cap use "huddlestonJEPS.dta"
keep if round==1
// Table 5a in appendix: Empty Threat scenario
quietly ologit approve costfirst if vign==1
oparallel
// Table 5b in appendix: Follow Through scenario
quietly ologit approve costfirst if vign==3
oparallel 



// Table 6 in appendix
// Demographics per round
clear
use "huddlestonJEPS.dta"
tab party if round!=2 & (treatgroup==.|treatgroup==3|treatgroup==8)
tab latino if round!=2 & (treatgroup==.|treatgroup==3|treatgroup==8)
tab race if round!=2 & (treatgroup==.|treatgroup==3|treatgroup==8)
tab gender if round!=2 & (treatgroup==.|treatgroup==3|treatgroup==8)
tab marry if round!=2 & (treatgroup==.|treatgroup==3|treatgroup==8)
tab age if round!=2 & (treatgroup==.|treatgroup==3|treatgroup==8)
tab edu if round!=2 & (treatgroup==.|treatgroup==3|treatgroup==8)
tab income if round!=2 & (treatgroup==.|treatgroup==3|treatgroup==8)
// Oct 2015
tab party if round==1
tab latino if round==1
tab race if round==1
tab gender if round==1
tab marry if round==1
tab age if round==1
tab edu if round==1
tab income if round==1
// Dec 2016
tab party if round==3
tab latino if round==3
tab race if round==3
tab gender if round==3
tab marry if round==3
tab age if round==3
tab edu if round==3
tab income if round==3
// March 2017
tab party if round==4 & (treatgroup==3|treatgroup==8)
tab latino if round==4 & (treatgroup==3|treatgroup==8)
tab race if round==4 & (treatgroup==3|treatgroup==8)
tab gender if round==4 &  (treatgroup==3|treatgroup==8)
tab marry if round==4 &  (treatgroup==3|treatgroup==8)
tab age if round==4 & (treatgroup==3|treatgroup==8)
tab edu if round==4 &  (treatgroup==3|treatgroup==8)
tab income if round==4 & (treatgroup==3|treatgroup==8)



// Table 7 in appendix
// N of each comparison
// Control and Cost Prime
clear 
use costfirstgraph_r
tab costf vign
// Control and Reputation Prime
clear 
use repfirstgraph_r
tab repf round if vign==1
tab repf round if vign==2



// Table 8a, control for partisanship
clear
use "huddlestonJEPS.dta"
tab party
// Republicans
ttest approv if party>5 & vign==1 & round==1, by(costfirst)
ttest approv if party>5 & vign==2 & round==1, by(costfirst)
ttest approv if party>5 & vign==3 & round==1, by(costfirst)
// Republicans and leaners
ttest approv if party>4 & vign==1 & round==1, by(costfirst)
ttest approv if party>4 & vign==2 & round==1, by(costfirst)
ttest approv if party>4 & vign==3 & round==1, by(costfirst)
// Democrats
ttest approv if party<3 & vign==1 & round==1, by(costfirst)
ttest approv if party<3 & vign==2 & round==1, by(costfirst)
ttest approv if party<3 & vign==3 & round==1, by(costfirst)
// Democrats and leaners
ttest approv if party<4 & vign==1 & round==1, by(costfirst)
ttest approv if party<4 & vign==2 & round==1, by(costfirst)
ttest approv if party<4 & vign==3 & round==1, by(costfirst)
// Independents
ttest approv if party==4 & vign==1 & round==1, by(costfirst)
ttest approv if party==4 & vign==2 & round==1, by(costfirst)
ttest approv if party==4 & vign==3 & round==1, by(costfirst)
// Independents, including leaners
ttest approv if party>2 & party<6 & vign==1 & round==1, by(costfirst)
ttest approv if party>2 & party<6 & vign==2 & round==1, by(costfirst)
ttest approv if party>2 & party<6 & vign==3 & round==1, by(costfirst)



//Test for Table 8b, logit with control for party
clear
cap use "huddlestonJEPS.dta"
keep if round==1
set more off
ologit approve b4.party costfirst if vign==1 //just party
ologit approve b4.party costfirst if vign==3 //just party

log close


