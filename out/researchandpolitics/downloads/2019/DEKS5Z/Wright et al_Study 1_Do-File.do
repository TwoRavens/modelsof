// Reanalysis of Wright et al. data (Study 1)
// May 7, 2017
// Online Appendix 6a
// "Explaining Immigration Preferences: Disentangling Skill and Prevalence"

cd "C:\~"  // change working directory
use study1immiglevel.dta, clear

// Separate out immigrants into those predominantly high skill and low skill
gen highskill=.
replace highskill=1 if origin==1 | origin==2 | origin==3 | origin==4 | origin ==7
replace highskill=0 if origin==5 | origin==6 | origin==8 | origin==9 | origin==10
tab origin if highskill==1
tab origin if highskill==0

// Run Wright et al. regressions on subsamples (estimate of skill premium compares highest educational category to lowest educational category) 
reg immig i.educ1 i.fs1 i.jobperf1 i.prof1 i.rel1 i.yrsus1 i.lang1 [pweight=weight] if usborn==1 & highskill==1, cluster(caseid)
reg immig i.educ1 i.fs1 i.jobperf1 i.prof1 i.rel1 i.yrsus1 i.lang1 [pweight=weight] if usborn==1 & highskill==0, cluster(caseid)

