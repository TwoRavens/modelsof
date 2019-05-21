**HOUSEHOLD-LEVEL DATA SET; EXPERIMENTAL RESULTS*

use Zambian_household_dataset.dta, clear

**MAIN ARTICLE**

*EFFECTS DISPLAYED IN FIGURE 1*

ttest voteMP if chiefMPimportant==0, by(treatment) unequal
ttest voteMP if chiefMPimportant==1, by(treatment) unequal

ttest voteMP if chiefchangetreat==0, by(treatment) unequal
ttest voteMP if chiefchangetreat==1, by(treatment) unequal

ttest voteMP if normreciprocity==0, by(treatment) unequal
ttest voteMP if normreciprocity==1, by(treatment) unequal

ttest voteMP if activenormreciprocity==0, by(treatment) unequal
ttest voteMP if activenormreciprocity==1, by(treatment) unequal

**EFFECTS DISPLAYED IN FIGURE 2*

ttest voteMP if chiefMPimportant_diffcut==0, by(treatment) unequal
ttest voteMP if chiefMPimportant_diffcut==1, by(treatment) unequal

ttest voteMP if benefitsviachief==0, by(treatment) unequal
ttest voteMP if benefitsviachief==1, by(treatment) unequal

ttest voteMP if chiefMPimportant==0 & researchsite==1, by(treatment) unequal
ttest voteMP if chiefMPimportant==1 & researchsite==1, by(treatment) unequal

ttest voteMP if chiefMPimportant==0 & researchsite==2, by(treatment) unequal
ttest voteMP if chiefMPimportant==1 & researchsite==2, by(treatment) unequal

**EFFECTS DISPLAYED IN FIGURE 3*

ttest voteMP if chiefMPimportant==0 & finprim==0, by(treatment) unequal
ttest voteMP if chiefMPimportant==1 & finprim==0, by(treatment) unequal
ttest voteMP if chiefMPimportant==0 & finprim==1, by(treatment) unequal
ttest voteMP if chiefMPimportant==1 & finprim==1, by(treatment) unequal

ttest voteMP if chiefMPimportant==0 & radio==0, by(treatment) unequal
ttest voteMP if chiefMPimportant==1 & radio==0, by(treatment) unequal
ttest voteMP if chiefMPimportant==0 & radio==1, by(treatment) unequal
ttest voteMP if chiefMPimportant==1 & radio==1, by(treatment) unequal

ttest voteMP if chiefMPimportant==0 & partymember==0, by(treatment) unequal
ttest voteMP if chiefMPimportant==1 & partymember==0, by(treatment) unequal
ttest voteMP if chiefMPimportant==0 & partymember==1, by(treatment) unequal
ttest voteMP if chiefMPimportant==1 & partymember==1, by(treatment) unequal

ttest voteMP if chiefMPimportant==0 & chiefstribe==0, by(treatment) unequal
ttest voteMP if chiefMPimportant==1 & chiefstribe==0, by(treatment) unequal
ttest voteMP if chiefMPimportant==0 & chiefstribe==1, by(treatment) unequal
ttest voteMP if chiefMPimportant==1 & chiefstribe==1, by(treatment) unequal

**TABLE 4**

logit chiefMPimportant female age radio agriculture noincome partymember if treatment!=.

logit chiefMPimportant female age radio agriculture noincome partymember finprim chiefstribe if treatment!=.

****************************

**SUPPLEMENTARY INFORMATION**

**TABLE 7**
**SEE RESULTS UNDER FIGURE 1 ABOVE**
**NOTE: DIFFERENCES IN EFFECTS ACROSS DEMOGRAPHIC GROUPS AND STANDARD ERRORS OF THESE DIFFERENCES WERE CALCULATED MANUALLY**

**TABLE 8**

ttest female if treatment!=., by(treatment) unequal 
ttest over35 if treatment!=., by(treatment) unequal 
ttest finprim if treatment!=., by(treatment) unequal 
ttest literacy if treatment!=., by(treatment) unequal 
ttest agriculture if treatment!=., by(treatment) unequal 
ttest chiefstribe if treatment!=., by(treatment) unequal 
ttest partymember if treatment!=., by(treatment) unequal 
ttest radio if treatment!=., by(treatment) unequal 
ttest religion if treatment!=., by(treatment) unequal 
ttest noincome if treatment!=., by(treatment) unequal 
ttest farmgroup if treatment!=., by(treatment) unequal 
ttest royalfamily if treatment!=., by(treatment) unequal 
ttest benefitsfromchief if treatment!=., by(treatment) unequal 
ttest newspaper if treatment!=., by(treatment) unequal

**TABLE 9**

ttest voteMP if MPimportant==0 & chiefimportant==0, by(treatment) unequal
ttest voteMP if MPimportant==0 & chiefimportant==1, by(treatment) unequal
ttest voteMP if MPimportant==1 & chiefimportant==0, by(treatment) unequal
ttest voteMP if MPimportant==1 & chiefimportant==1, by(treatment) unequal

**FIGURE 2**

ttest voteMP_noisy if chiefMPimportant==0, by(treatment) unequal
ttest voteMP_noisy if chiefMPimportant==1, by(treatment) unequal

**FIGURE 3**

ttest voteMP if chiefMPimportant==0 & dontknowcorrectview==1, by(treatment) unequal
ttest voteMP if chiefMPimportant==1 & dontknowcorrectview==1, by(treatment) unequal

**FIGURE 4 [SEE BELOW]**

**FIGURE 5**

ttest voteMP if chiefhightrust==0, by(treatment) unequal
ttest voteMP if chiefhightrust==1, by(treatment) unequal

**FIGURE 6**

ttest voteMP if MPtrust==0, by(treatment) unequal
ttest voteMP if MPtrust==1, by(treatment) unequal

**FIGURE 7**

ttest voteMP if chiefstribe==0, by(treatment) unequal
ttest voteMP if chiefstribe==1, by(treatment) unequal

**FIGURE 4**

gen chiefMPimportant_m1=0 if chiefMPimportant==0
replace chiefMPimportant_m1=1 if chiefMPimportant==1
replace chiefMPimportant_m1=1 if chiefMPimportant==. & voteMP==0 & treatment==1
replace chiefMPimportant_m1=0 if chiefMPimportant==. & voteMP==0 & treatment==0
replace chiefMPimportant_m1=0 if chiefMPimportant==. & voteMP==1 & treatment==1
replace chiefMPimportant_m1=1 if chiefMPimportant==. & voteMP==1 & treatment==0

gen voteMP_m1=0 if voteMP==0
replace voteMP_m1=1 if voteMP==1
replace voteMP_m1=1 if chiefMPimportant==0 & voteMP==. & treatment==1
replace voteMP_m1=0 if chiefMPimportant==0 & voteMP==. & treatment==0
replace voteMP_m1=0 if chiefMPimportant==1 & voteMP==. & treatment==1
replace voteMP_m1=1 if chiefMPimportant==1 & voteMP==. & treatment==0
replace voteMP_m1=1 if chiefMPimportant==. & voteMP==. & treatment==0
replace chiefMPimportant_m1=1 if chiefMPimportant==. & voteMP==. & treatment==0
replace voteMP_m1=0 if chiefMPimportant==. & voteMP==. & treatment==1
replace chiefMPimportant_m1=1 if chiefMPimportant==. & voteMP==. & treatment==1

ttest voteMP_m1 if chiefMPimportant_m1==0, by(treatment) unequal
ttest voteMP_m1 if chiefMPimportant_m1==1, by(treatment) unequal

************************************************************************

gen chiefchangetreat_m2=0 if chiefchangetreat==0
replace chiefchangetreat_m2=1 if chiefchangetreat==1
replace chiefchangetreat_m2=0 if chiefchangetreat==. & voteMP==0 & treatment==1
replace chiefchangetreat_m2=1 if chiefchangetreat==. & voteMP==0 & treatment==0
replace chiefchangetreat_m2=1 if chiefchangetreat==. & voteMP==1 & treatment==1
replace chiefchangetreat_m2=0 if chiefchangetreat==. & voteMP==1 & treatment==0

gen voteMP_m2=0 if voteMP==0
replace voteMP_m2=1 if voteMP==1
replace voteMP_m2=0 if chiefchangetreat==0 & voteMP==. & treatment==1
replace voteMP_m2=1 if chiefchangetreat==0 & voteMP==. & treatment==0
replace voteMP_m2=1 if chiefchangetreat==1 & voteMP==. & treatment==1
replace voteMP_m2=0 if chiefchangetreat==1 & voteMP==. & treatment==0
replace voteMP_m2=0 if chiefchangetreat==. & voteMP==. & treatment==0
replace chiefchangetreat_m2=1 if chiefchangetreat==. & voteMP==. & treatment==0
replace voteMP_m2=1 if chiefchangetreat==. & voteMP==. & treatment==1
replace chiefchangetreat_m2=1 if chiefchangetreat==. & voteMP==. & treatment==1

ttest voteMP_m2 if chiefchangetreat_m2==0, by(treatment) unequal
ttest voteMP_m2 if chiefchangetreat_m2==1, by(treatment) unequal


**********************************************************************************

gen normreciprocity_m3=0 if normreciprocity==0
replace normreciprocity_m3=1 if normreciprocity==1
replace normreciprocity_m3=0 if normreciprocity==. & voteMP==0 & treatment==1
replace normreciprocity_m3=1 if normreciprocity==. & voteMP==0 & treatment==0
replace normreciprocity_m3=1 if normreciprocity==. & voteMP==1 & treatment==1
replace normreciprocity_m3=0 if normreciprocity==. & voteMP==1 & treatment==0

gen voteMP_m3=0 if voteMP==0
replace voteMP_m3=1 if voteMP==1
replace voteMP_m3=0 if normreciprocity==0 & voteMP==. & treatment==1
replace voteMP_m3=1 if normreciprocity==0 & voteMP==. & treatment==0
replace voteMP_m3=1 if normreciprocity==1 & voteMP==. & treatment==1
replace voteMP_m3=0 if normreciprocity==1 & voteMP==. & treatment==0
replace voteMP_m3=0 if normreciprocity==. & voteMP==. & treatment==0
replace normreciprocity_m3=1 if normreciprocity==. & voteMP==. & treatment==0
replace voteMP_m3=1 if normreciprocity==. & voteMP==. & treatment==1
replace normreciprocity_m3=1 if normreciprocity==. & voteMP==. & treatment==1

ttest voteMP_m3 if normreciprocity_m3==0, by(treatment) unequal
ttest voteMP_m3 if normreciprocity_m3==1, by(treatment) unequal


********************************************************************************

gen activenorm_m4=0 if activenormreciprocity==0
replace activenorm_m4=1 if activenormreciprocity==1
replace activenorm_m4=0 if activenormreciprocity==. & voteMP==0 & treatment==1
replace activenorm_m4=1 if activenormreciprocity==. & voteMP==0 & treatment==0
replace activenorm_m4=1 if activenormreciprocity==. & voteMP==1 & treatment==1
replace activenorm_m4=0 if activenormreciprocity==. & voteMP==1 & treatment==0

gen voteMP_m4=0 if voteMP==0
replace voteMP_m4=1 if voteMP==1
replace voteMP_m4=0 if activenormreciprocity==0 & voteMP==. & treatment==1
replace voteMP_m4=1 if activenormreciprocity==0 & voteMP==. & treatment==0
replace voteMP_m4=1 if activenormreciprocity==1 & voteMP==. & treatment==1
replace voteMP_m4=0 if activenormreciprocity==1 & voteMP==. & treatment==0
replace voteMP_m4=0 if activenormreciprocity==. & voteMP==. & treatment==0
replace activenorm_m4=1 if activenormreciprocity==. & voteMP==. & treatment==0
replace voteMP_m4=1 if activenormreciprocity==. & voteMP==. & treatment==1
replace activenorm_m4=1 if activenormreciprocity==. & voteMP==. & treatment==1

ttest voteMP_m4 if activenorm_m4==0, by(treatment) unequal
ttest voteMP_m4 if activenorm_m4==1, by(treatment) unequal

