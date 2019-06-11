// Reanalysis of Wright et al. data (Study 2)
// May 7, 2017
// Online Appendix 6a
// "Explaining Immigration Preferences: Disentangling Skill and Prevalence"

cd "C:\~"  // change working directory
use study2dataforreshape, clear

// Separate out immigrants into those predominantly high skill and low skill
gen highskill=.
replace highskill=1 if origin==1 | origin==3
replace highskill=0 if origin==2 | origin==4 | origin==5
tab origin if highskill==1
tab origin if highskill==0

// Run Wright et al. regressions on subsamples (estimate of skill premium compares highest educational category to lowest educational category) 
reg immig i.educimmig i.job i.ageimmig i.religion i.lang if usborn==1 & highskill==1, cluster(XSURVNUM)
reg immig i.educimmig i.job i.ageimmig i.religion i.lang if usborn==1 & highskill==0, cluster(XSURVNUM)

