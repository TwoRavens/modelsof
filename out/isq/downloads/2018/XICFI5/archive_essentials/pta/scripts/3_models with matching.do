** estimate the main models and save the results
** This script assumes that the current working dir is the top level of the archive

capture mkdir "pta/results"
log using "pta/results/3_pta models w matching.smcl", replace

set more off

cd "pta/madedata"

** principled lags
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
 /* l2polconiiiA l3polconiiiA l4polconiiiA l5polconiiiA*/ /// /* veto points */
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2larmconflict l3larmconflict l4larmconflict l5larmconflict  ///
 /* l2latopally l3latopally l4latopally l5latopally */ ///
  /*l2fmrcol_new l3fmrcol_new l4fmrcol_new l5fmrcol_new /* former colony -- collinear */ */ ///
 /* l2lcontig_new l3lcontig_new l4lcontig_new l5lcontig_new */ ///
  /* l2lndistance l3lndistance l4lndistance l5lndistance /// /* collinear */ */ ///
 /* l2lheg_new l3lheg_new l4lheg_new l5lheg_new */ /// /* hegemony -- changes the estimate some, but still neg */ 
  /*l2pcw89 l3pcw89 l4pcw89 l5pcw89 /*post cold war -- REVERSES ESTIMATE */  */  /// 
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g ///
  l2onsetperc2 l3onsetperc2 l4onsetperc2 l5onsetperc2 ///  /* % dyads ratifying PTA */
 /* l2lnewgatt l3lnewgatt l4lnewgatt l5lnewgatt /* GATT/WTO */ */
 

use "mahmatches_iccprpta.dta", clear
xtset dyadid
logit pta012345 treated l1*, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g ///

logit pta012345 treated l1* `lags', cluster(dyadid) l(90)
tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1

use "mahmatches_iccprpta_Ratifiers.dta", clear
*`HRA'name_1==1 & `HRA'name_2==0
xtset dyadid
logit pta012345 treated l1*, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g ///

logit pta012345 treated l1* `lags', cluster(dyadid) l(90)
cd "../results"
outreg2 using fulltable, word replace 2aster 
cd "../madedata"
tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1

  ** quantities of interest
capture drop l1fmrcol_new
estsimp logit pta012345 treated l1* `lags', cluster(dyadid) l(90)
set seed 1234
setx  (treated) 0 (l1* `lags') median
simqi, pr listx level(90)
setx  (treated) 1 (l1* `lags') median
simqi, pr listx level(90)
simqi, fd(pr) listx changex(treated 0 1) level(90)

** for the table of m values
simqi, fd(pr) listx changex(treated 0 1) level(98)
simqi, fd(pr) listx changex(treated 0 1) level(90)
simqi, fd(pr) listx changex(treated 0 1) level(80)
simqi, fd(pr) listx changex(treated 0 1) level(70)
simqi, fd(pr) listx changex(treated 0 1) level(60)
simqi, fd(pr) listx changex(treated 0 1) level(50)


use "mahmatches_opt1pta.dta", clear
xtset dyadid

sum distance, detail
drop l1llnGDP_gled08  
logit pta012345 treated l1*, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g ///

logit pta012345 treated l1* `lags', cluster(dyadid) l(90)
tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1



use "mahmatches_opt1pta_Ratifiers.dta", clear
xtset dyadid

sum distance, detail
logit pta012345 treated l1*, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g
logit pta012345 treated l1* `lags', cluster(dyadid) l(90)
cd "../results"
outreg2 using fulltable, word append 2aster 
cd "../madedata"
tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1

  ** quantities of interest
drop l1larmconflict
estsimp logit pta012345 treated l1* `lags', cluster(dyadid) l(90)
set seed 1234
setx  (treated) 0 (l1* `lags') median
simqi, pr listx level(90)
setx  (treated) 1 (l1* `lags') median
simqi, pr listx level(90)
simqi, fd(pr) listx changex(treated 0 1) level(90)

** for the table of m values
simqi, fd(pr) listx changex(treated 0 1) level(98)
simqi, fd(pr) listx changex(treated 0 1) level(90)
simqi, fd(pr) listx changex(treated 0 1) level(80)
simqi, fd(pr) listx changex(treated 0 1) level(70)
simqi, fd(pr) listx changex(treated 0 1) level(60)
simqi, fd(pr) listx changex(treated 0 1) level(50)



use "mahmatches_catpta.dta", clear
xtset dyadid

sum distance, detail
logit pta012345 treated l1*, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g
logit pta012345 treated l1* `lags', cluster(dyadid) l(90)
tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1

use "mahmatches_catpta_Ratifiers.dta", clear
xtset dyadid

sum distance, detail
logit pta012345 treated l1*, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g
logit pta012345 treated l1* `lags', cluster(dyadid) l(90)
cd "../results"
outreg2 using fulltable, word append 2aster 
cd "../madedata"
tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1

  ** quantities of interest
drop l1fmrcol_new l1larmconflict
estsimp logit pta012345 treated l1* `lags', cluster(dyadid) l(90)
set seed 1234
setx  (treated) 0 (l1* `lags') median
simqi, pr listx level(90)
setx  (treated) 1 (l1* `lags') median
simqi, pr listx level(90)
simqi, fd(pr) listx changex(treated 0 1) level(90)

** for the table of m values
simqi, fd(pr) listx changex(treated 0 1) level(98)
simqi, fd(pr) listx changex(treated 0 1) level(90)
simqi, fd(pr) listx changex(treated 0 1) level(80)
simqi, fd(pr) listx changex(treated 0 1) level(70)
simqi, fd(pr) listx changex(treated 0 1) level(60)
simqi, fd(pr) listx changex(treated 0 1) level(50)




use "mahmatches_art22pta.dta", clear
xtset dyadid

sum distance, detail
logit pta012345 treated l1*, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g
logit pta012345 treated l1* `lags', cluster(dyadid) l(90)
tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1

use "mahmatches_art22pta_Ratifiers.dta", clear
xtset dyadid

sum distance, detail
drop l1larmconflict
logit pta012345 treated l1*, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g
logit pta012345 treated l1* `lags', cluster(dyadid) l(90)
cd "../results"
outreg2 using fulltable, word append 2aster 
cd "../madedata"
tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1

  ** quantities of interest
drop l1fmrcol_new
estsimp logit pta012345 treated l1* `lags', cluster(dyadid) l(90)
set seed 1234
setx  (treated) 0 (l1* `lags') median
simqi, pr listx level(90)
setx  (treated) 1 (l1* `lags') median
simqi, pr listx level(90)
simqi, fd(pr) listx changex(treated 0 1) level(90)

** for the table of m values
simqi, fd(pr) listx changex(treated 0 1) level(98)
simqi, fd(pr) listx changex(treated 0 1) level(90)
simqi, fd(pr) listx changex(treated 0 1) level(80)
simqi, fd(pr) listx changex(treated 0 1) level(70)
simqi, fd(pr) listx changex(treated 0 1) level(60)
simqi, fd(pr) listx changex(treated 0 1) level(50)


cd "../.."

log close
