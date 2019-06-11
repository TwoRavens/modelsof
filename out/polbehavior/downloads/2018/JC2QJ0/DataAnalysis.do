***Data Analysis Replication File for Political Behavior

***Data
use "/Users/kevinmullinix/Documents/Kevin/Dissertation/PolarChallenge/Spinoff/PB/Mullinix_PolBeh_Replication/Mullinix_PolBeh_Data.dta"

***Original party variable [PIDrep]. Recode to dichotomous [party2] Dem=0, Rep=1. Leaners as partisans
tab PIDrep
*gen party2=.
*replace party2=0 if PIDrep==1
*replace party2=0 if PIDrep==2
*replace party2=0 if PIDrep==3
*replace party2=1 if PIDrep==5
*replace party2=1 if PIDrep==6
*replace party2=1 if PIDrep==7
tab party2

****Experimental Group. Condition held constant between two studies.
tab SalesExpCondition
tab SSAExpCondition
*Renumber experimental condition to correspond to group numbering in Table 1 in the paper.
*gen group=.
*replace group=1 if SalesExpCondition==1
*replace group=2 if SalesExpCondition==2
*replace group=3 if SalesExpCondition==3
*replace group=4 if SalesExpCondition==7
*replace group=5 if SalesExpCondition==5
*replace group=6 if SalesExpCondition==9
*replace group=7 if SalesExpCondition==4
*replace group=8 if SalesExpCondition==8
*replace group=9 if SalesExpCondition==6
*replace group=10 if SalesExpCondition==10
tab group
*When motivations pull in same direction (plus control)
*gen tandemgroup=.
*replace tandemgroup=1 if group==1
*replace tandemgroup=3 if group==3
*replace tandemgroup=4 if group==4
*replace tandemgroup=5 if group==5
*replace tandemgroup=6 if group==6
tab tandemgroup
*When motivations compete (plus control)
*gen competegroup=.
*replace competegroup=1 if group==1
*replace competegroup=7 if group==7
*replace competegroup=8 if group==8
*replace competegroup=9 if group==9
*replace competegroup=10 if group==10
tab competegroup

*******************************************
******Tests in order presented in paper
*******************************************

*******************************************
****When Motivations Pull in Same Direction

***Party Endorsement
*Republicans
ttest SalesSupport if(party2==1 & group==1 | party2==1 & group==3), by(group) 
ttest SSASupport if(party2==1 & group==1 | party2==1 & group==3), by(group) 
*Democrats
ttest SalesSupport if(party2==0 & group==1 | party2==0 & group==3), by(group) 
ttest SSASupport if(party2==0 & group==1 | party2==0 & group==3), by(group) 

***Polarization
*Republicans
ttest SalesSupport if(party2==1 & group==3 | party2==1 & group==5), by(group)
ttest SSASupport if(party2==1 & group==3 | party2==1 & group==5), by(group)
ttest SalesSupport if(party2==1 & group==4 | party2==1 & group==6), by(group)
ttest SSASupport if(party2==1 & group==4 | party2==1 & group==6), by(group)
*Democrats
ttest SalesSupport if(party2==0 & group==3 | party2==0 & group==5), by(group)
ttest SSASupport if(party2==0 & group==3 | party2==0 & group==5), by(group)
ttest SalesSupport if(party2==0 & group==4 | party2==0 & group==6), by(group)
ttest SSASupport if(party2==0 & group==4 | party2==0 & group==6), by(group)

***Issue Importance
*Republicans
ttest SalesSupport if(party2==1 & group==5 | party2==1 & group==6), by(group)
ttest SSASupport if(party2==1 & group==5 | party2==1 & group==6), by(group)
ttest SalesSupport if(party2==1 & group==3 | party2==1 & group==4), by(group)
ttest SSASupport if(party2==1 & group==3 | party2==1 & group==4), by(group)
*Democrats
ttest SalesSupport if(party2==0 & group==5 | party2==0 & group==6), by(group)
ttest SSASupport if(party2==0 & group==5 | party2==0 & group==6), by(group)
ttest SalesSupport if(party2==0 & group==3 | party2==0 & group==4), by(group)
ttest SSASupport if(party2==0 & group==3 | party2==0 & group==4), by(group)

***Multiple group comparisons
*Republicans
anova SalesSupport tandemgroup if(party2==1)
oneway SalesSupport tandemgroup if(party2==1), bonferroni
anova SSASupport tandemgroup if(party2==1)
oneway SSASupport tandemgroup if(party2==1), bonferroni

*Democrats
anova SalesSupport tandemgroup if(party2==0)
oneway SalesSupport tandemgroup if(party2==0), bonferroni
anova SSASupport tandemgroup if(party2==0)
oneway SSASupport tandemgroup if(party2==0), bonferroni

*******************************************
****When Motivations Compete

***Party Endorsement
*Republicans
ttest SalesSupport if(party2==1 & group==1 | party2==1 & group==7), by(group)
ttest SSASupport if(party2==1 & group==1 | party2==1 & group==7), by(group)
*Democrats
ttest SalesSupport if(party2==0 & group==1 | party2==0 & group==7), by(group)
ttest SSASupport if(party2==0 & group==1 | party2==0 & group==7), by(group)

***Effect of Polarization under Low Issue Importance
*Republicans
ttest SalesSupport if(party2==1 & group==7 | party2==1 & group==9), by(group)
ttest SSASupport if(party2==1 & group==7 | party2==1 & group==9), by(group)
*Democrats
ttest SalesSupport if(party2==0 & group==7 | party2==0 & group==9), by(group)
ttest SSASupport if(party2==0 & group==7 | party2==0 & group==9), by(group)

***Effect of Issue importance under Low Polarization
*Republicans
ttest SalesSupport if(party2==1 & group==1 | party2==1 & group==8), by(group)
ttest SSASupport if(party2==1 & group==1 | party2==1 & group==8), by(group)
ttest SalesSupport if(party2==1 & group==7 | party2==1 & group==8), by(group)
ttest SSASupport if(party2==1 & group==7 | party2==1 & group==8), by(group)
*Democrats
ttest SalesSupport if(party2==0 & group==1 | party2==0 & group==8), by(group)
ttest SSASupport if(party2==0 & group==1 | party2==0 & group==8), by(group)
ttest SalesSupport if(party2==0 & group==7 | party2==0 & group==8), by(group)
ttest SSASupport if(party2==0 & group==7 | party2==0 & group==8), by(group)

***When both Polarization and Issue Importance are High
*Republicans
ttest SalesSupport if(party2==1 & group==1 | party2==1 & group==10), by(group)
ttest SSASupport if(party2==1 & group==1 | party2==1 & group==10), by(group)
ttest SalesSupport if(party2==1 & group==9 | party2==1 & group==10), by(group)
ttest SSASupport if(party2==1 & group==9 | party2==1 & group==10), by(group)
ttest SalesSupport if(party2==1 & group==8 | party2==1 & group==10), by(group)
ttest SSASupport if(party2==1 & group==8 | party2==1 & group==10), by(group)
*Democrats
ttest SalesSupport if(party2==0 & group==1 | party2==0 & group==10), by(group)
ttest SSASupport if(party2==0 & group==1 | party2==0 & group==10), by(group)
ttest SalesSupport if(party2==0 & group==9 | party2==0 & group==10), by(group)
ttest SSASupport if(party2==0 & group==9 | party2==0 & group==10), by(group)
ttest SalesSupport if(party2==0 & group==8 | party2==0 & group==10), by(group)
ttest SSASupport if(party2==0 & group==8 | party2==0 & group==10), by(group)

***Multiple group comparisons
*Republicans
anova SalesSupport competegroup if(party2==1)
oneway SalesSupport competegroup if(party2==1), bonferroni
anova SSASupport competegroup if(party2==1)
oneway SSASupport competegroup if(party2==1), bonferroni

*Democrats
anova SalesSupport competegroup if(party2==0)
oneway SalesSupport competegroup if(party2==0), bonferroni
anova SSASupport competegroup if(party2==0)
oneway SSASupport competegroup if(party2==0), bonferroni


***Tabular results (for Supporting Information)
tabstat SalesSupport if(party2==0), by(group) stats(mean semean sd n)
tabstat SalesSupport if(party2==1), by(group) stats(mean semean sd n)
tabstat SSASupport if(party2==0), by(group) stats(mean semean sd n)
tabstat SSASupport if(party2==1), by(group) stats(mean semean sd n)


*Power analysis
power twomeans 6.5 (5 5.5), n(90 100 110 120) sd(1.5) graph

****Other variables

*Sales importance
tabstat SalesImport, by(group) stats(mean semean sd n)

*Sales Argument in FAVOR
tabstat SalesArgFavor if(party2==0), by(group) stats(mean semean sd n)
tabstat SalesArgFavor if(party2==1), by(group) stats(mean semean sd n)

*Sales Argument Opposed
tabstat SalesArgOppose if(party2==0), by(group) stats(mean semean sd n)
tabstat SalesArgOppose if(party2==1), by(group) stats(mean semean sd n)

*SSA Importance
tabstat SSAImport, by(group) stats(mean semean sd n)

*SSA Argument Opposed
tabstat SSAArgOppose if(party2==1), by(group) stats(mean semean sd n)
tabstat SSAArgOppose if(party2==0), by(group) stats(mean semean sd n)

*SSA Argument in FAVOR
tabstat SSAArgFavor if(party2==1), by(group) stats(mean semean sd n)
tabstat SSAArgFavor if(party2==0), by(group) stats(mean semean sd n)

***party importance
tabstat PartyImport, by(group) stats(mean semean sd n)

***Demographics
tab Age
tab PIDrep
*gen party3=.
*replace party3=0 if PIDrep==1
*replace party3=0 if PIDrep==2
*replace party3=0 if PIDrep==3
*replace party3=1 if PIDrep==4
*replace party3=2 if PIDrep==5
*replace party3=2 if PIDrep==6
*replace party3=2 if PIDrep==7
tab party3
tab Gender
tab Education
tab Income
tab Race
tab Ideology
*gen ideo3=.
*replace ideo3=0 if Ideology==1
*replace ideo3=0 if Ideology==2
*replace ideo3=0 if Ideology==3
*replace ideo3=1 if Ideology==4
*replace ideo3=2 if Ideology==5
*replace ideo3=2 if Ideology==6
*replace ideo3=2 if Ideology==7
tab ideo3

