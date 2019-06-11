**** Politics of Beauty Replication Code *****
*use "POB_ReplicationData.dta"

********** Results ********** 

**** Using weighted data ****
svyset [pweight = weight]

**** First page of results, in text analysis of difference between males and females ****
** t-test gender difference - control condition **
svy: mean attractrate if conditions==1, over(gender)
lincom [attractrate]0 - [attractrate]1

**** Cross-tabs of manipulation checks ****

** Female in the control condition **
tab mancheck if gender==1 & conditions==1
** Female in the Obama condition **
tab mancheck if gender==1 & conditions==2
** Female in the Romney condition **
tab mancheck if gender==1 & conditions==3

** Male in the control condition **
tab mancheck if gender==0 & conditions==1
** Male in the Obama condition **
tab mancheck if gender==0 & conditions==2
** Male in the Romney condition **
tab mancheck if gender==0 & conditions==3


**** Figure 2A  (Female Mean Rating of Attractiveness by Condition) ****
** Also includes subsequent analyses run from this Figure **

** Baseline condition **
svy: mean attractrate if conditions==1 & gender ==1 , over(pid2)
lincom [attractrate]0 - [attractrate]1
** Obama condition **
svy: mean attractrate if conditions==2 & gender ==1 , over(pid2)
lincom [attractrate]0 - [attractrate]1
** Romney condition **
svy: mean attractrate if conditions==3 & gender ==1 , over(pid2)
lincom [attractrate]0 - [attractrate]1


**** Figure 2B  (Male Mean Rating of Attractiveness by Condition) ****
** Also includes subsequent analyses run from this Figure **

** Baseline condition ** 
svy: mean attractrate if conditions==1 & gender == 0 , over(pid2)
lincom [attractrate]0 - [attractrate]1
** Obama condition **
svy: mean attractrate if conditions==2 & gender == 0 , over(pid2)
lincom [attractrate]0 - [attractrate]1
** Romney condition **
svy: mean attractrate if conditions==3 & gender == 0 , over(pid2)
lincom [attractrate]0 - [attractrate]1

**** Figure 3 (Differences Between Treatment and Control by Gender and PID ****
** These analyses are relative to the baseline **

** Creating variable for baseline vs condition **
** Baseline == 0, Obama == 1 **
gen obama = . 
replace obama = 0 if conditions == 1
replace obama = 1 if conditions == 2

** Baseline == 0, Romney == 1 **
gen romney = . 
replace romney = 0 if conditions == 1
replace romney = 1 if conditions == 3

** labels **
label variable obama "1 = obama cue"
label variable romney "1 = romney cue"

** Figure 3A: Females **
** obama cue, democrat pid **
svy: mean attractrate if pid2 == 0 & gender == 1 , over(obama)
lincom [attractrate]0 - [attractrate]1
** romney cue, democrat pid **
svy: mean attractrate if pid2 == 0 & gender == 1 , over(romney)
lincom [attractrate]0 - [attractrate]1
** obama cue, republican pid **
svy: mean attractrate if pid2 == 1 & gender == 1 , over(obama)
lincom [attractrate]0 - [attractrate]1
** romney cue, republican pid **
svy: mean attractrate if pid2 == 1 & gender == 1 , over(obama)
lincom [attractrate]0 - [attractrate]1

** Figure 3B: Males **
** obama cue, democrat pid **
svy: mean attractrate if pid2 == 0 & gender == 0 , over(obama)
lincom [attractrate]0 - [attractrate]1
** romney cue, democrat pid **
svy: mean attractrate if pid2 == 0 & gender == 0 , over(romney)
lincom [attractrate]0 - [attractrate]1
** obama cue, republican pid **
svy: mean attractrate if pid2 == 1 & gender == 0 , over(obama)
lincom [attractrate]0 - [attractrate]1
** romney cue, republican pid **
svy: mean attractrate if pid2 == 1 & gender == 0 , over(obama)
lincom [attractrate]0 - [attractrate]1

** Difference in Difference Analyses **

** Democrat Female Inparty - Outparty cue effect **
** Below gives you the effect size, N, and standard error**
svy: mean attractrate if gender == 1 & pid2==0, over(obama)
lincom [attractrate]0 - [attractrate]1
svy: mean attractrate if gender == 1 & pid2==0, over(romney)
lincom [attractrate]0 - [attractrate]1
** Take those statistics and put them into a t-test **
ttesti 180 .6608985 2.44012930506 179 1.087042 3.62393072826

** Republican Female Inparty - Outparty cue effect **
** Below gives you the effect size, N, and standard error**
svy: mean attractrate if gender == 1 & pid2==1, over(obama)
lincom [attractrate]0 - [attractrate]1
svy: mean attractrate if gender == 1 & pid2==1, over(romney)
lincom [attractrate]0 - [attractrate]1
** Take those statistics and put them into a t-test **
ttesti 123 .505745 2.62830521167 121 .8396459 3.4085854

** Democrat Male Inparty - Outparty cue effect **
** Below gives you the effect size, N, and standard error**
svy: mean attractrate if gender == 0 & pid2==0, over(obama)
lincom [attractrate]0 - [attractrate]1
svy: mean attractrate if gender == 0 & pid2==0, over(romney)
lincom [attractrate]0 - [attractrate]1
** Take those statistics (absolute value) and put them into a t-test **
ttesti 129 .038821 3.04774290164 135  1.398955 4.85218275426

** Republican Male Inparty - Outparty cue effect **
** Below gives you the effect size, N, and standard error**
svy: mean attractrate if gender == 0 & pid2==1, over(obama)
lincom [attractrate]0 - [attractrate]1
svy: mean attractrate if gender == 0 & pid2==1, over(romney)
lincom [attractrate]0 - [attractrate]1
** Take those statistics (absolute value) and put them into a t-test **
ttesti 135 .1083175 3.1921229437 134  .7932485 3.45245399841


********** Appendix ********** 

**** Creating Dummy Variables ****
** Conditions **
gen RepIn = 0
replace RepIn = 1 if pid2 == 1 & romney == 1
gen RepOut = 0 
replace RepOut = 1 if pid2==1 & obama == 1
gen DemIn = 0 
replace DemIn = 1 if pid2 == 0 & obama == 1
gen DemOut = 0
replace DemOut = 1 if pid2 == 0 & romney == 1

** labels **
label variable RepIn "1 = Republican & Romney Cue"
label variable RepOut "1 = Republican & Obama Cue"
label variable DemIn "1 = Democrat & Obama Cue"
label variable DemOut "1 = Democrat & Romney Cue"

**** Appendix A ****

** Manipulation Check Analysis with Dummy Variable for Correct Recall **
** Model 1: Female **
svy: ologit attractrate RepIn RepOut DemIn DemOut if gender == 1
** Model 2: Female **
svy: ologit attractrate RepIn RepOut DemIn DemOut recall if gender == 1

** Model 1: Male **
svy: ologit attractrate RepIn RepOut DemIn DemOut if gender == 0
** Model 2: Male **
svy: ologit attractrate RepIn RepOut DemIn DemOut recall if gender == 0

** Manipulation Check Analysis Restricting Analysis to Correct Recall **
** Model 1: Female **
svy: ologit attractrate RepIn RepOut DemIn DemOut if gender == 1
** Model 2: Female **
svy: ologit attractrate RepIn RepOut DemIn DemOut if gender == 1 & recall == 1

** Model 1: Male **
svy: ologit attractrate RepIn RepOut DemIn DemOut if gender == 0
** Model 2: Male **
svy: ologit attractrate RepIn RepOut DemIn DemOut if gender == 0 & recall == 1


**** Appendix B ****
** Same results using Party Registration **

** Correlation between PID and PR **
pwcorr pid2 PR

** Results from Figure 2 Using Party Registration **
** Female **
** Baseline condition **
svy: mean attractrate if conditions==1 & gender ==1 , over(PR)
lincom [attractrate]0 - [attractrate]1
** Obama condition **
svy: mean attractrate if conditions==2 & gender ==1 , over(PR)
lincom [attractrate]0 - [attractrate]1
** Romney condition **
svy: mean attractrate if conditions==3 & gender ==1 , over(PR)
lincom [attractrate]0 - [attractrate]1


** Male **

** Baseline condition ** 
svy: mean attractrate if conditions==1 & gender == 0 , over(PR)
lincom [attractrate]0 - [attractrate]1
** Obama condition **
svy: mean attractrate if conditions==2 & gender == 0 , over(PR)
lincom [attractrate]0 - [attractrate]1
** Romney condition **
svy: mean attractrate if conditions==3 & gender == 0 , over(PR)
lincom [attractrate]0 - [attractrate]1

** Results from Figure 3 using Party Registration **
** Females **
** obama cue, democrat PR **
svy: mean attractrate if PR == 0 & gender == 1 , over(obama)
lincom [attractrate]0 - [attractrate]1
** romney cue, democrat PR **
svy: mean attractrate if PR == 0 & gender == 1 , over(romney)
lincom [attractrate]0 - [attractrate]1
** obama cue, republican PR **
svy: mean attractrate if PR == 1 & gender == 1 , over(obama)
lincom [attractrate]0 - [attractrate]1
** romney cue, republican PR **
svy: mean attractrate if PR == 1 & gender == 1 , over(obama)
lincom [attractrate]0 - [attractrate]1

** Males **
** obama cue, democrat PR **
svy: mean attractrate if PR == 0 & gender == 0 , over(obama)
lincom [attractrate]0 - [attractrate]1
** romney cue, democrat PR **
svy: mean attractrate if PR == 0 & gender == 0 , over(romney)
lincom [attractrate]0 - [attractrate]1
** obama cue, republican PR **
svy: mean attractrate if PR == 1 & gender == 0 , over(obama)
lincom [attractrate]0 - [attractrate]1
** romney cue, republican PR **
svy: mean attractrate if PR == 1 & gender == 0 , over(romney)
lincom [attractrate]0 - [attractrate]1


**** Appendix C ****

** Figure 2 Results using the Unweighted Data **
** Female **
ttest attractrate if conditions == 1 & gender == 1, by(pid2)
ttest attractrate if conditions == 2 & gender == 1, by(pid2)
ttest attractrate if conditions == 3 & gender == 1, by(pid2)

** Male **
ttest attractrate if conditions == 1 & gender == 0, by(pid2)
ttest attractrate if conditions == 2 & gender == 0, by(pid2)
ttest attractrate if conditions == 3 & gender == 0, by(pid2)

** Figure 3 Results using the Unweighted Data **
** Female **
ttest attractrate if gender == 0 & pid2 == 0, by(obama)
ttest attractrate if gender == 0 & pid2 == 0, by(romney)
ttest attractrate if gender == 0 & pid2 == 1, by(obama)
ttest attractrate if gender == 0 & pid2 == 1, by(romney)

** Male **
ttest attractrate if gender == 1 & pid2 == 0, by(obama)
ttest attractrate if gender == 1 & pid2 == 0, by(romney)
ttest attractrate if gender == 1 & pid2 == 1, by(obama)
ttest attractrate if gender == 1 & pid2 == 1, by(romney)





