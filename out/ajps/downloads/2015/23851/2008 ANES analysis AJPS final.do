***testing the illegal immigrtaion scale
 alpha  feillimmig controlillimmig immicneg immigillwork if whitenonhisp==1, std 

**table 1
 **basic ses
  regress  ptyid7 alphaillimmig7  educ income unemp age female married union jewish catholic protestant  if whitenonhisp==1
 **with  issues
  regress  ptyid7 alphaillimmig7  educ income unemp age female married union jewish catholic protestant libcon3  spendterror iraqgood afghan economy presjob richtax welfarespend gayrights religimp  if whitenonhisp==1
 ***with issues and feelings toward blacks 
regress  ptyid7 alphaillimmig7  educ income unemp age female married union jewish catholic protestant libcon3  spendterror iraqgood afghan economy presjob richtax welfarespend gayrights religimp blkspecfav blksgenslav blksdeserve blkstryhard  if whitenonhisp==1
 **with issues and other races
  regress  ptyid7 alphaillimmig7  educ income unemp age female married union jewish catholic protestant libcon3  spendterror iraqgood afghan economy presjob richtax welfarespend gayrights religimp feblacks fewhites feasians if whitenonhisp==1
 

***figure one - DV=vote
  logit  votedemreppres alphaillimmig7 educ income unemp age female married union jewish catholic protestant libcon3 ptyid7 spendterror iraqgood afghan economy presjob richtax welfarespend gayrights religimp feblacks fewhites feasians if whitenonhisp==1
  logit   votepresintend alphaillimmig7 educ income unemp age female married union jewish catholic protestant libcon3 ptyid7 spendterror iraqgood afghan economy presjob richtax welfarespend gayrights religimp feblacks fewhites feasians if whitenonhisp==1
 
