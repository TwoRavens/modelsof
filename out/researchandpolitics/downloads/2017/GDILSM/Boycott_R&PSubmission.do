
cd "/Users/kyleendres/Dropbox/boycott/R&P Submission/Data Files"
capture log close
log using boycott_RAPsubmission_R1.txt, replace text

version 14.2
clear all 
matrix drop _all
set more off

** This is a combined Do file prepared for submission to Research and Politics
** The Do file includes code for all 3 datasets: 2016 ANES Pilot, 2016 CCES, and 2017 L2

// 2016 ANES Pilot

use "/Users/kyleendres/Dropbox/boycott/R&P Submission/Data Files/2016ANESPilot_Boycott_Variables.dta"
svyset [pweight = weight]

// Table 1, all survey participants

svy: mean boycott
svy: mean buycott
svy: mean consumerism_any

// Table 1, registered voters only
svy: mean boycott if notregistered==0
svy: mean buycott if notregistered==0
svy: mean consumerism_any if notregistered==0

// Table 2

logit boycott i.rep i.independent i.pid_other pid_intensity pk_sum follow_rev ideology_folded i.race i.gender age agesq educ i.marstat_binary faminc i.notregistered [pweight = weight]

// Table 3
logit buycott i.rep i.independent i.pid_other pid_intensity pk_sum follow_rev ideology_folded i.race i.gender age agesq educ i.marstat_binary faminc i.notregistered [pweight = weight]
// Table 4
logit consumerism_any i.rep i.independent i.pid_other pid_intensity pk_sum follow_rev ideology_folded i.race i.gender age agesq educ i.marstat_binary faminc i.notregistered [pweight = weight]





clear

version 14.2
clear all 
matrix drop _all
set more off
// 2016 CCES
use "/Users/kyleendres/Dropbox/boycott/R&P Submission/Data Files/2016CCES_forRevision.dta"
svyset [pweight = weight]
set more off

** weighted

svy: tab pid7 boycott, row
svy: tab pid7 buycott, row
svy: tab pid7 consumerism_any, row

// Table 1 all survey participants
svy: mean boycott
svy: mean buycott
svy: mean consumerism_any
// Table 1 -  registered voters only
** Restricting to registered voters -- based on self-reports
svy: mean boycott if notregistered==0
svy: mean buycott if notregistered==0
svy: mean consumerism_any if notregistered==0



// logit model Democrats as the Outgroup
// Table 2
logit boycott i.rep i.independent i.pid_other pid_intensity pk_sum follow_rev ideological_intensity i.race i.gender age agesq educ i.marstat_binary faminc i.notregistered [pweight=weight]
logit boycott i.rep i.independent i.pid_other pid_intensity pk_sum follow_rev ideological_intensity socialmedia i.race i.gender age agesq educ i.marstat_binary faminc i.notregistered [pweight=weight]

// Table 3
logit buycott i.rep i.independent i.pid_other pid_intensity pk_sum follow_rev ideological_intensity i.race i.gender age agesq educ i.marstat_binary faminc i.notregistered  [pweight=weight]
logit buycott i.rep i.independent i.pid_other pid_intensity pk_sum follow_rev ideological_intensity socialmedia i.race i.gender age agesq educ i.marstat_binary faminc i.notregistered  [pweight=weight]

// Table 4
logit consumerism_any i.rep i.independent i.pid_other pid_intensity pk_sum follow_rev ideological_intensity i.race i.gender age agesq educ i.marstat_binary faminc i.notregistered  [pweight=weight]
logit consumerism_any i.rep i.independent i.pid_other pid_intensity pk_sum follow_rev ideological_intensity socialmedia  i.race i.gender age agesq educ i.marstat_binary faminc i.notregistered [pweight=weight]


clear
*************** L2 Data    ***************************************************

version 14.2
clear all 
matrix drop _all
set more off
use "/Users/kyleendres/Dropbox/boycott/R&P Submission/Data Files/2017L2_Boycott_Variables.dta" 

// Table 1 
mean boycott
mean buycott
mean boyorbuycott

// Table 2
logit boycott i.republican i.independent i.pid_other pid_intensity ideology_folded pol_interest i.race_black i.race_latino i.race_other i.female educ Voters_Age agesq
// Table 3
logit buycott i.republican i.independent i.pid_other pid_intensity ideology_folded pol_interest i.race_black i.race_latino i.race_other i.female educ Voters_Age agesq
// Table 4
logit boyorbuycott i.republican i.independent i.pid_other pid_intensity ideology_folded pol_interest i.race_black i.race_latino i.race_other i.female educ Voters_Age agesq
// Table 5
** party identity
logit boycott partisan_identity issueideo_folded pol_interest i.race_black i.race_latino i.race_other i.female educ Voters_Age agesq if partisan==1
test partisan_identity = issueideo_folded
mchange partisan_identity issueideo_folded
sum partisan_identity if partisan==1 & boycott!=., detail
sum issueideo_folded if partisan==1 & boycott!=., detail


logit buycott partisan_identity issueideo_folded pol_interest i.race_black i.race_latino i.race_other i.female educ Voters_Age agesq if partisan==1
test partisan_identity = issueideo_folded
mchange partisan_identity issueideo_folded

logit boyorbuycott partisan_identity issueideo_folded pol_interest i.race_black i.race_latino i.race_other i.female educ Voters_Age agesq if partisan==1
test partisan_identity = issueideo_folded
mchange partisan_identity issueideo_folded


// Tables A1, A2, and A3 in appendix
** party strength
logit boycott partystrength issueideo_folded pol_interest i.race_black i.race_latino i.race_other i.female educ Voters_Age agesq if partisan==1
logit buycott partystrength issueideo_folded pol_interest i.race_black i.race_latino i.race_other i.female educ Voters_Age agesq if partisan==1
logit boyorbuycott partystrength issueideo_folded pol_interest i.race_black i.race_latino i.race_other i.female educ Voters_Age agesq if partisan==1

** both
logit boycott partystrength partisan_identity issueideo_folded pol_interest i.race_black i.race_latino i.race_other i.female educ Voters_Age agesq if partisan==1
logit buycott partystrength partisan_identity issueideo_folded pol_interest i.race_black i.race_latino i.race_other i.female educ Voters_Age agesq if partisan==1
logit boyorbuycott partystrength partisan_identity issueideo_folded pol_interest i.race_black i.race_latino i.race_other i.female educ Voters_Age agesq if partisan==1

log close

