*=======================================================================================================
* deliberators’ perceptions of the quality of deliberation 
*=======================================================================================================
use MiCHAT_political, clear

preserve

drop if round<4
drop if dd==0

for any postq91 postq104 postq105 postq106 postq107 postq108 postq109  postq110 postq111: gen X_rev = 6-X

alpha postq91_rev postq104_rev postq105_rev postq106_rev ///
  postq107_rev postq108_rev postq109_rev  postq110_rev postq111_rev ///
  postq98 postq99 postq100 postq101 postq103
		
*
* A group-level mean for each of the 22 deliberating groups on this index, 
* to see if on average some groups were rated higher or lower on the quality of discussion.
*
egen index = rowmean(postq91_rev postq104_rev postq105_rev postq106_rev ///
  postq107_rev postq108_rev postq109_rev  postq110_rev postq111_rev ///
  postq98 postq99 postq100 postq101 postq103)

tabstat index, stat(mean) 
tabstat index, by(GAME) stat(mean) 

* To get group level means from 22 groups.
drop if index==.  // just so that the person with missing index does not become the first obs.
bysort GAME: gen order=_n
sum index if order==1

restore

* POWER CONSIDERATION
codebook game if round==4 /* 44 CHAT groups */
tab game dd if round==4 /* 44 CHAT groups */
codebook game if round==4 & dd /* 22 CHAT groups */
codebook game if round==4 & dd==0 /* 22 CHAT groups */

*=======================================================================================================
* ANALYSES FOR "Does Deliberation Mobilize?" 
* Round 4: Not at all willing = 1, Extremely willing = 5
* In the next 6 months, how willing would you be to do any of the following activities?
* PRE: 74-75=partcularistic resistance; 76-82=activity in the past 6mos; 84-86=discuss
* POST: 74-75=particularistic resistance; 76-82=activity;                83-85=discuss; 86=vote
*=======================================================================================================
use MiCHAT_political, clear
tabstat postq76-postq82 postq83-postq85 postq86 postq74-postq75 if dd==1 & round==4, stat(mean sd) f(%4.1f) 
tabstat postq76-postq82 postq83-postq85 postq86 postq74-postq75 if dd==0 & round==4, stat(mean sd) f(%4.1f) 

* Activity
for any 76 77 78 79 80 81 82: ttest postqX if round==4, by(dd) \ /*
  */ xtreg postqX dd if round==4, i(GAME) \ /*  
  */ xtreg postqX dd i.preqX if round==4, i(GAME) level(90)

* Discussions
for X in any 83 84 85 \ Y in any 84 85 86: ttest postqX if round==4, by(dd) \ /*
  */ xtreg postqX dd if round==4, i(GAME) \ /*
  */ xtreg postqX dd preqY if round==4, i(GAME) level(90)
		
* Vote (post86): R1 and R4 data range are different, do not use longitudinal data
ttest postq86 if round==4, by(dd)
xtreg postq86 dd i.preq83 if round==4, i(GAME) level(90)

* preq74 and preq75 are 1/2 yes/no type responses
for any 74 75: ttest postqX if round==4, by(dd) \ /*
  */ xtreg postqX dd i.preqX if round==4, i(GAME) level(90)

manova postq74-postq86 =dd if round==4 
		
*-------------------------------------------------------------------------------------------------------
* CONDITIONAL ANALYSES (STRATIFIED)
* No deliberation effect for any of the items: See if that is the case in subgroups. 
* PRE: 74-75=partcularistic resistance; 76-82=activity in the past 6mos; 84-86=discuss
* POST: 74-75=particularistic resistance; 76-82=activity;                83-85=discuss; 86=vote
*-------------------------------------------------------------------------------------------------------
* 1) those who were politically active to begin with vs. not: 
*    preq83 (1=yes, voted in 2012; 2=no, did not participate)
*    turns out 46 gave no response.
*    So look at the between-arm difference in those whose preq83=1 (yes), 2 (no), and 3 (missing).
*    if no and missing are not different, combine them as one group.
*    Create something like Table 5.
* Since round 4 questions are different than round 1 question, do not use change.
*-------------------------------------------------------------------------------------------------------
drop if nosurvey==1

count  if preq83==. & round==1
tab preq83 dd if round==1, row

tab voted dd if round==1, m
tab voted dd if round==4, m

*-------------------------------------------------------------------------------
* Activity Items

table dd voted if round==4, c(mean Q76 sd Q76 n Q77 mean Q77 sd Q77) f(%4.1f) 
for any 76 77: mixed QX i.R4##i.dd || game: || playerID: if voted==0, residual(independent, by(dd)) \ lincom _b[1.R4] + _b[1.R4#1.dd]
for any 76 77: mixed QX i.R4##i.dd || game: || playerID: if voted==1, residual(independent, by(dd)) \ lincom _b[1.R4] + _b[1.R4#1.dd]
for any 76 77: mixed QX i.R4##i.dd || game: || playerID: if voted==2, residual(independent, by(dd)) \ lincom _b[1.R4] + _b[1.R4#1.dd]

table dd voted if round==4, c(mean Q78 sd Q78 n Q79 mean Q79 sd Q79) f(%4.1f) 
for any 78 79: mixed QX i.R4##i.dd || game: || playerID: if voted==0, residual(independent, by(dd))
for any 78 79: mixed QX i.R4##i.dd || game: || playerID: if voted==1, residual(independent, by(dd)) 
for any 78 79: mixed QX i.R4##i.dd || game: || playerID: if voted==2, residual(independent, by(dd))

table dd voted if round==4, c(mean Q80 sd Q80) f(%4.1f) 
for any 80: mixed QX i.R4##i.dd || game: || playerID: if voted==0, residual(independent, by(dd))
for any 80: mixed QX i.R4##i.dd || game: || playerID: if voted==1, residual(independent, by(dd)) 
for any 80: mixed QX i.R4##i.dd || game: || playerID: if voted==2, residual(independent, by(dd))

table dd voted if round==4, c(mean Q81 sd Q81) f(%4.1f) 
for any 81: mixed QX i.R4##i.dd || game: || playerID: if voted==0, residual(independent, by(dd))
for any 81: mixed QX i.R4##i.dd || game: || playerID: if voted==1, residual(independent, by(dd)) 
for any 81: mixed QX i.R4##i.dd || game: || playerID: if voted==2, residual(independent, by(dd))

table dd voted if round==4, c(mean Q82 sd Q82) f(%4.1f) 
for any 0 1 2: mixed Q82 i.R4##i.dd || game: || playerID: if voted==X, residual(independent, by(dd)) \ more
* Above fits, but try below.
for any 1: reg Q82 dd if round==4 & voted==X \ more

* FINAL
for any 76 77 78 79 80 81 82: ttest postqX if round==4 & voted==0, by(dd) \ mixed postqX dd i.preqX  || game: if round==4 & voted==0, level(90) \ more

for any 76 77 78 79 80 81 82: ttest postqX if round==4 & voted==1, by(dd) \ mixed postqX dd i.preqX  || game: if round==4 & voted==1, level(90) \ more

for any 76 77 78 79 80 81 82: ttest postqX if round==4 & voted==2, by(dd) \ mixed postqX dd i.preqX  || game: if round==4 & voted==2, level(90) \ more

*-------------------------------------------------------------------------------
* Activate Discusssion Items

table dd voted if round==4, c(n Q83 mean Q83 sd Q83) f(%4.1f) 
for any 0 1 2: mixed postq83 dd || game: if voted==X & round==4, residual(independent, by(dd)) \ /*
  */ mixed postq83 dd preq84 || game: if voted==X & round==4, residual(independent, by(dd)) \ more

* FINAL for postq83
for any 0 1 2: ttest postq83 if voted==X & round==4, by(dd) \ mixed postq83 dd preq84 || game: if voted==X & round==4, level(90)

*-----------------------		
table dd voted if round==4, c(n Q84 mean Q84 sd Q84) f(%4.1f) 
for any 0 1 2: mixed postq84 dd || game: if voted==X & round==4, residual(independent, by(dd)) \ /*
  */ mixed postq84 dd preq85 || game: if voted==X & round==4, residual(independent, by(dd)) \ more		
		
for any 0 1 2: ttest postq84 if voted==X & round==4, by(dd) \ mixed postq84 dd preq85 || game: if voted==X & round==4, residual(independent, by(dd))

* FINAL for postq84
for any 0 1 2: ttest postq84 if voted==X & round==4, by(dd) \ mixed postq84 dd preq85 || game: if voted==X & round==4, level(90)

* Above results are so different from the crude mean by dd at round 4
* Baseline data are different between dd=1 vs. 0?

table dd voted if round==1, c(mean Q84 sd Q84) f(%4.1f) 
for any 0 1 2: reg Q84 dd if voted==X & inlist(round,4) \ more

*----------------------
table dd voted if round==4, c(n postq85 mean postq85 sd postq85) f(%4.1f) 
for any 0 1 2: mixed postq85 dd || game: if voted==X & round==4, residual(independent, by(dd)) \ /*
  */ mixed postq85 dd preq86 || game: if voted==X & round==4, residual(independent, by(dd)) \ more		

* FINAL for postq85
for any 0 1 2: ttest postq85 if voted==X & round==4, by(dd) \ mixed postq85 dd preq86 || game: if voted==X & round==4, level(90)
		
*-------------------------------------------------------------------------------
* preq83 is where voted came from. 
* Do not adjust for baseline when analyzing postq86 (about vote) - analyses are stratified by it.
table dd voted if round==4, c(mean postq86 sd postq86) f(%4.1f) 
for any 0 1 2: mixed postq86 dd || game: if voted==X & inlist(round,4), residual(independent, by(dd))
for any 0 1 2: reg postq86 dd if voted==X & inlist(round,4) \ more

* FINAL
for any 0 1 2: ttest postq86 if voted==X & round==4, by(dd) \ mixed postq86 dd || game: if voted==X & round==4, level(90)

*-------------------------------------------------------------------------------
* Particularistic Resistance Items
* 
table dd voted if round==4, c(mean Q74 sd Q74 n Q75 mean Q75 sd Q75) f(%4.1f) 
for any 74 75: mixed QX i.R4##i.dd || game: || playerID: if voted==0, residual(independent, by(dd)) \ lincom _b[1.R4] + _b[1.R4#1.dd]
for any 74 75: mixed QX i.R4##i.dd || game: || playerID: if voted==1, residual(independent, by(dd)) \ lincom _b[1.R4] + _b[1.R4#1.dd]
for any 74 75: mixed QX i.R4##i.dd || game: || playerID: if voted==2, residual(independent, by(dd)) \ lincom _b[1.R4] + _b[1.R4#1.dd]

* FINAL postq74
for any 0 1 2: ttest postq74 if voted==X & round==4, by(dd) \ mixed postq74 dd i.preq74 || game: if voted==X & round==4, level(90)

* FINAL postq75
for any 0 1 2: ttest postq75 if voted==X & round==4, by(dd) \ mixed postq75 dd i.preq75 || game: if voted==X & round==4, level(90)

* INTERACTIONS OF VOTED BY DD
* Using all three voting categories, but do not adjust for baseline.
for any 74 75 76 77 78 79 80 81 82 83 84 85: mixed QX i.dd##i.voted || game: ///
   if inlist(round,1,4), residual(independent, by(dd)) \ more 
for any 84: mixed QX i.dd##i.voted || game: ///
   if inlist(round,1,4), residual(independent, by(dd)) \ more 
test _b[1.dd#1.voted]=_b[1.dd#2.voted]=0
 
*-------------------------------------------------------------------------------------------------------
* 2) postQ74 and postQ75 with the sample split into people who said yes to preQ74 or preQ75 
*   vs. people who said no to both to see if there was any effect 
*   on the willingness to contact/file a complaint against their insurance provider 
*   based on whether in the last six months they had contacted or filed a complaint 
*   against their insurance provider.
*-------------------------------------------------------------------------------------------------------
gen past6mos = preq74==1 | preq75==1
tab past6mos if round==1 & nosurvey!=1

table dd past6mos if round==4, c(n Q74 mean Q74 sd Q74) f(%4.1f) 
for any 0 1: mixed postq74 dd || game: if past6mos==X & round==4, level(90) \ more

table dd past6mos if round==4, c(n Q75 mean Q75 sd Q75) f(%4.1f) 
for any 0 1: mixed postq75 dd || game: if past6mos==X & round==4, level(90) \ more

* Do not want to use data from both rounds because it is stratified by it, but try it.
for any 74 75: mixed QX i.dd##i.past6mos || game: if inlist(round,1,4), residual(independent, by(dd))  

*=======================================================================================================
* post Q87 and Q88: About CHAT
*=======================================================================================================
tab postq87 dd if round==4, chi
ttest postq87 if round==4, by(dd)

tab postq88 dd if round==4, chi
ttest postq88 if round==4, by(dd)
