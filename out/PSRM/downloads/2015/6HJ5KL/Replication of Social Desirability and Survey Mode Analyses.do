
********Replication of Social Desirability and Survey Mode Analyses*****
use "racial attitudes replication.dta", clear

******Table 5: Social Desirability and Survey Mode******
*********(a) Racial Attitudes and Survey Mode Among Whites*********
tab q79 source if xppracem==1,nofreq col chi
tab q80 source if xppracem==1,nofreq col chi
tab q81 source if xppracem==1,nofreq col chi
*********(b) Race, Reports of Interpersonal Interaction, and Survey Mode Among Whites****
ttest own_race1 if xppracem==1,by(source)
ttest own_race2 if xppracem==1,by(source)
ttest own_race3 if xppracem==1,by(source)

******Table S-7: Survey Mode and Racial Attitudes******
reg q79 source ppage i.ppeducat ppgender i.ppreg4 ppmsacat if xppracem==1 
est store ols79
mlogit q80 source ppage i.ppeducat ppgender i.ppreg4 ppmsacat if xppracem==1 
est store ml80
reg q81 source ppage i.ppeducat ppgender i.ppreg4 ppmsacat if xppracem==1 
est store ols81
est table ols79 ml80 ols81, b(%3.2f)se stats(N rmse ll) 

******Table S-8: Survey Mode and Self-Reports of Interracial Interaction******
logit own_race1 source ppage i.ppeducat ppgender i.ppreg4 ppmsacat if xppracem==1
est store own1
logit own_race2 source ppage i.ppeducat ppgender i.ppreg4 ppmsacat if xppracem==1
est store own2
logit own_race3 source ppage i.ppeducat ppgender i.ppreg4 ppmsacat if xppracem==1
est store own3
est table own1 own2 own3, b(%3.2f)se stats(N) equations(1) 
est restore own1
lroc,nog
est restore own2
lroc,nog
est restore own3
lroc,nog

***Replication of Analyses with Survey Weights Applied***
******Apply survey weights for within racial group analyses********
svyset _n [pweight=weight2_NEW], strata(groups) vce(linearized) singleunit(missing)
******Survey Mode and Racial Attitudes, Weighted Regressions******
svy: reg q79 source ppage i.ppeducat ppgender i.ppreg4 ppmsacat if xppracem==1 
est store wols79
svy: mlogit q80 source ppage i.ppeducat ppgender i.ppreg4 ppmsacat if xppracem==1 
est store wml80
svy: reg q81 source ppage i.ppeducat ppgender i.ppreg4 ppmsacat if xppracem==1 
est store wols81
est table wols79 wml80 wols81, b(%3.2f)se stats(N rmse ll) 

******Survey Mode and Self-Reports of Interracial Interaction, Weighted Logit Models******
svy: logit own_race1 source ppage i.ppeducat ppgender i.ppreg4 ppmsacat if xppracem==1
est store wown1
svy: logit own_race2 source ppage i.ppeducat ppgender i.ppreg4 ppmsacat if xppracem==1
est store wown2
svy: logit own_race3 source ppage i.ppeducat ppgender i.ppreg4 ppmsacat if xppracem==1
est store wown3
est table wown1 wown2 wown3, b(%3.2f)se stats(N) equations(1) 
