


*******************************************************************************************************************
*******************************************************************************************************************
*** Replication material for "Cultural Distance and International Conflict" by Vincenzo Bove and Gunes Gokmen
*** August 17, 2015
*******************************************************************************************************************
*******************************************************************************************************************


*********************************
*** Load "Replication Data_1.dta"
*********************************

program drop _all
macro drop _all
global opt ",robust cluster(dyad)"
global controlgrav "ldis contig larea colony comlng"
global controlbarb   "peace allied votcol pol totwar diswar"
global trade "ltrl lopenl ztl fta_f gatt"
global oldwar "con1 con2 con3 con4 con5 con6 con7 con8 con9 con10 con11 con12 con13 con14 con15 con16 con17 con18 con19 con20"
global time "yr1-yr51"




************
*** Table 1
************
*\ Note: Summary Statistic are produced for the samples that are used in Table 3 regressions.

sum lbi intlbi lKoguts lMine lCDi if e(sample)


************ 
*** Table 2
************

pwcorr lbi intlbi, sig
pwcorr lbi lKoguts , sig
pwcorr lbi lMine , sig
pwcorr lbi lCDi , sig
pwcorr intlbi lKoguts , sig
pwcorr intlbi lMine , sig
pwcorr intlbi lCDi , sig
pwcorr lKoguts lMine , sig
pwcorr lKoguts lCDi , sig
pwcorr lMine lCDi , sig 


************
*** Table 3
************

logit mid lbi  $controlgrav $controlbarb $trade $time $oldwar $opt 
*** Note: to get the standardized marginal effect over the mean probablity of conflict (using average marginal effects) run the following
margins, dydx(lbi)
su mid if e(sample)==1
display .0013687/.0053945*100

logit mid intlbi $controlgrav $controlbarb $trade $time $oldwar $opt 
*** Note: to get the standardized marginal effect over the mean probablity of conflict (using average marginal effects) run the following
margins, dydx(intlbi)
su mid if e(sample)==1
display .0035812/.0055127*100

logit mid lKoguts  $controlgrav $controlbarb $trade $time $oldwar $opt 
*** Note: to get the standardized marginal effect over the mean probablity of conflict (using average marginal effects) run the following
margins, dydx(lKoguts)
su mid if e(sample)==1
display .0009104/.0066779*100

logit mid lMine  $controlgrav $controlbarb $trade $time $oldwar $opt 
*** Note: to get the standardized marginal effect over the mean probablity of conflict (using average marginal effects) run the following
margins, dydx(lMine)
su mid if e(sample)==1
display .0007058/.0066779*100

logit mid lCDi $controlgrav $controlbarb $trade $time $oldwar $opt 
*** Note: to get the standardized marginal effect over the mean probablity of conflict (using average marginal effects) run the following
margins, dydx(lCDi)
su mid if e(sample)==1
display .0076464/.0059107*100


************
*** Table 4
************

logit mid lbi  $controlgrav $controlbarb $trade $time $oldwar  if majpow==1 | contig==1 $opt 
*** Note: to get the standardized marginal effect over the mean probablity of conflict (using average marginal effects) run the following
margins, dydx(lbi)
su mid if e(sample)==1
display .0066791/.0305444*100

logit mid intlbi $controlgrav $controlbarb $trade $time $oldwar if majpow==1 | contig==1 $opt
*** Note: to get the standardized marginal effect over the mean probablity of conflict (using average marginal effects) run the following
margins, dydx(intlbi)
su mid if e(sample)==1
display .0245572/.0319224*100

logit mid lKoguts  $controlgrav $controlbarb $trade $time $oldwar if majpow==1| contig==1 $opt
*** Note: to get the standardized marginal effect over the mean probablity of conflict (using average marginal effects) run the following
margins, dydx(lKoguts)
su mid if e(sample)==1
display .0036165/.0308624*100

logit mid lMine  $controlgrav $controlbarb $trade $time $oldwar if majpow==1 | contig==1 $opt
*** Note: to get the standardized marginal effect over the mean probablity of conflict (using average marginal effects) run the following
margins, dydx(lMine)
su mid if e(sample)==1
display .0024198/.0308624*100

logit mid lCDi $controlgrav $controlbarb $trade $time $oldwar if majpow==1 | contig==1 $opt
*** Note: to get the standardized marginal effect over the mean probablity of conflict (using average marginal effects) run the following
margins, dydx(lCDi)
su mid if e(sample)==1
display .0606124/.0258065*100


************
*** Table 5
************

probit mid lbi  $controlgrav $controlbarb $trade $time $oldwar $opt 
*** Note: to get the standardized marginal effect over the mean probablity of conflict (using average marginal effects) run the following
margins, dydx(lbi)
su mid if e(sample)==1
display .0009326/.0053945*100

probit mid intlbi $controlgrav $controlbarb $trade $time $oldwar $opt 
*** Note: to get the standardized marginal effect over the mean probablity of conflict (using average marginal effects) run the following
margins, dydx(intlbi)
su mid if e(sample)==1
display .0031079/.0055127*100

probit mid lKoguts  $controlgrav $controlbarb $trade $time $oldwar $opt 
*** Note: to get the standardized marginal effect over the mean probablity of conflict (using average marginal effects) run the following
margins, dydx(lKoguts)
su mid if e(sample)==1
display .0008189/.0066779*100

probit mid lMine  $controlgrav $controlbarb $trade $time $oldwar $opt 
*** Note: to get the standardized marginal effect over the mean probablity of conflict (using average marginal effects) run the following
margins, dydx(lMine)
su mid if e(sample)==1
display .0006255/.0066779*100

probit mid lCDi $controlgrav $controlbarb $trade $time $oldwar $opt 
*** Note: to get the standardized marginal effect over the mean probablity of conflict (using average marginal effects) run the following
margins, dydx(lCDi)
su mid if e(sample)==1
display .0058642/.0059107*100 


************
*** Table 6
************ 

reg mid lbi  $controlgrav $controlbarb $trade $time $oldwar $opt 
*** Note: to get the standardized marginal effect over the mean probablity of conflict (using average marginal effects) run the following
su mid if e(sample)==1
display -.0011654/.0053945*100

reg mid intlbi $controlgrav $controlbarb $trade $time $oldwar $opt 
*** Note: to get the standardized marginal effect over the mean probablity of conflict (using average marginal effects) run the following
su mid if e(sample)==1
display .0004503/.0055127*100

reg mid lKoguts  $controlgrav $controlbarb $trade $time $oldwar $opt 
*** Note: to get the standardized marginal effect over the mean probablity of conflict (using average marginal effects) run the following
su mid if e(sample)==1
display .0012759/.0066779*100

reg mid lMine  $controlgrav $controlbarb $trade $time $oldwar $opt 
*** Note: to get the standardized marginal effect over the mean probablity of conflict (using average marginal effects) run the following
su mid if e(sample)==1
display .0008305/.0066779*100

reg mid lCDi $controlgrav $controlbarb $trade $time $oldwar $opt 
*** Note: to get the standardized marginal effect over the mean probablity of conflict (using average marginal effects) run the following
su mid if e(sample)==1
display .008089/.0050819*100


************
*** Table 7
************
*** Note: Load "Replication Data_2.dta"

global GGcontrols "logdist contig  mindem lnmgdp deplo relpow majpow alliance mcpy mcpy1 mcpy2 mcpy3"
 
logit mid  lbi $GGcontrols , robust cluster(pairid)
*** Note: to get the standardized marginal effect over the mean probablity of conflict (using average marginal effects) run the following
margins, dydx(lbi)
su mid if e(sample)==1
display .0036633/.0055379*100

logit mid  intlbi $GGcontrols , robust cluster(pairid)
*** Note: to get the standardized marginal effect over the mean probablity of conflict (using average marginal effects) run the following
margins, dydx(intlbi)
su mid if e(sample)==1
display .0064624/.0055236*100

logit mid  lKoguts $GGcontrols  , robust cluster(pairid)
*** Note: to get the standardized marginal effect over the mean probablity of conflict (using average marginal effects) run the following
margins, dydx(lKoguts)
su mid if e(sample)==1
display .0020385/.0088813*100

logit mid  lMine $GGcontrols , robust cluster(pairid)
*** Note: to get the standardized marginal effect over the mean probablity of conflict (using average marginal effects) run the following
margins, dydx(lMine)
su mid if e(sample)==1
display .0017686/.0088813*100

logit mid  lCDi $GGcontrols , robust cluster(pairid) 
*** Note: to get the standardized marginal effect over the mean probablity of conflict (using average marginal effects) run the following
margins, dydx(lCDi)
su mid if e(sample)==1
display .0117349/.0111748*100


********************
*** Appendix Tables
********************


**************
*** Table A.1
**************

summarize mid ldis contig larea colony comlng peace allied votcol pol totwar diswar ltrl lopenl ztl fta_f gatt if e(sample) *\ using "Replication Data_1.dta"
summarize mindem lnmgdp deplo relpow majpow if e(sample) *\ using "Replication Data_2.dta"

**************
*** Table A.2
**************

program drop _all
macro drop _all
global opt ",robust cluster(dyad)"
global controlgrav "ldis contig larea colony comlng"
global controlbarb   "peace allied votcol pol totwar diswar"
global trade "ltrl lopenl ztl fta_f gatt"
global oldwar "con1 con2 con3 con4 con5 con6 con7 con8 con9 con10 con11 con12 con13 con14 con15 con16 con17 con18 con19 con20"
global time "yr1-yr51"

logit mid lbi  $controlgrav $controlbarb $trade $time $oldwar $opt 

logit mid intlbi $controlgrav $controlbarb $trade $time $oldwar $opt 

logit mid lKoguts  $controlgrav $controlbarb $trade $time $oldwar $opt 

logit mid lMine  $controlgrav $controlbarb $trade $time $oldwar $opt 

logit mid lCDi $controlgrav $controlbarb $trade $time $oldwar $opt 


**************
*** Table A.3
**************

global GGcontrols "logdist contig  mindem lnmgdp deplo relpow majpow alliance mcpy mcpy1 mcpy2 mcpy3"
 
logit mid  lbi $GGcontrols , robust cluster(pairid)

logit mid  intlbi $GGcontrols , robust cluster(pairid)

logit mid  lKoguts $GGcontrols  , robust cluster(pairid)

logit mid  lMine $GGcontrols , robust cluster(pairid)

logit mid  lCDi $GGcontrols , robust cluster(pairid) 







