

log using "pta/results/5_pta other stuff.smcl", replace

set more off

*****************************************
** subset by allies
*****************************************

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
 
 
*****************************************
** subset by allies
*****************************************

use "mahmatches_iccprpta.dta", clear
xtset dyadid
logit pta012345 treated l1* if latopally==1, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g ///

logit pta012345 treated l1* `lags' if latopally==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1

use "mahmatches_iccprpta_Ratifiers.dta", clear
*`HRA'name_1==1 & `HRA'name_2==0
xtset dyadid
logit pta012345 treated l1* if latopally==1, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g ///

logit pta012345 treated l1* `lags' if latopally==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1



use "mahmatches_opt1pta.dta", clear
xtset dyadid

sum distance, detail
drop l1llnGDP_gled08  
logit pta012345 treated l1* if latopally==1, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g ///

logit pta012345 treated l1* `lags' if latopally==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1



use "mahmatches_opt1pta_Ratifiers.dta", clear
xtset dyadid

sum distance, detail
logit pta012345 treated l1* if latopally==1, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g
logit pta012345 treated l1* `lags' if latopally==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1





use "mahmatches_catpta.dta", clear
xtset dyadid

sum distance, detail
logit pta012345 treated l1* if latopally==1, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g
logit pta012345 treated l1* `lags' if latopally==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1

use "mahmatches_catpta_Ratifiers.dta", clear
xtset dyadid

sum distance, detail
logit pta012345 treated l1* if latopally==1, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g
logit pta012345 treated l1* `lags' if latopally==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1




use "mahmatches_art22pta.dta", clear
xtset dyadid

sum distance, detail
logit pta012345 treated l1* if latopally==1, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g
logit pta012345 treated l1* `lags' if latopally==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1

use "mahmatches_art22pta_Ratifiers.dta", clear
xtset dyadid

sum distance, detail
drop l1larmconflict
logit pta012345 treated l1* if latopally==1, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g
logit pta012345 treated l1* `lags' if latopally==1, cluster(dyadid) l(90)

tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1


*******************************************
** subset by major trading partners
*******************************************
 
 

 
use "mahmatches_iccprpta.dta", clear
xtset dyadid
_pctile llntradenew, p(50)
gen tmp = llntradenew > `r(r1)'
logit pta012345 treated l1* if tmp==1, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g ///

logit pta012345 treated l1* `lags' if tmp==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1

use "mahmatches_iccprpta_Ratifiers.dta", clear
*`HRA'name_1==1 & `HRA'name_2==0
xtset dyadid
_pctile llntradenew, p(50)
gen tmp = llntradenew > `r(r1)'
logit pta012345 treated l1* if tmp==1, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g ///

logit pta012345 treated l1* `lags' if tmp==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1



use "mahmatches_opt1pta.dta", clear
xtset dyadid
_pctile llntradenew, p(50)
gen tmp = llntradenew > `r(r1)'
sum distance, detail
drop l1llnGDP_gled08  
logit pta012345 treated l1* if tmp==1, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g ///

logit pta012345 treated l1* `lags' if tmp==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1



use "mahmatches_opt1pta_Ratifiers.dta", clear
xtset dyadid
_pctile llntradenew, p(50)
gen tmp = llntradenew > `r(r1)'
sum distance, detail
logit pta012345 treated l1* if tmp==1, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g
logit pta012345 treated l1* `lags' if tmp==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1




use "mahmatches_catpta.dta", clear
xtset dyadid
_pctile llntradenew, p(50)
gen tmp = llntradenew > `r(r1)'
sum distance, detail
logit pta012345 treated l1* if tmp==1, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g
logit pta012345 treated l1* `lags' if tmp==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1

use "mahmatches_catpta_Ratifiers.dta", clear
xtset dyadid
_pctile llntradenew, p(50)
gen tmp = llntradenew > `r(r1)'
sum distance, detail
logit pta012345 treated l1* if tmp==1, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g
logit pta012345 treated l1* `lags' if tmp==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1




use "mahmatches_art22pta.dta", clear
xtset dyadid
_pctile llntradenew, p(50)
gen tmp = llntradenew > `r(r1)'
sum distance, detail
logit pta012345 treated l1* if tmp==1, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g
logit pta012345 treated l1* `lags' if tmp==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1

use "mahmatches_art22pta_Ratifiers.dta", clear
xtset dyadid
_pctile llntradenew, p(50)
gen tmp = llntradenew > `r(r1)'
sum distance, detail
drop l1larmconflict
logit pta012345 treated l1* if tmp==1, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g
*logit pta012345 treated l1* `lags' if tmp==1, cluster(dyadid) l(90)
* does not converge

tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1


*******************************************
** Europe on ex-colonies and US w LA
*******************************************

**********************************
** US aid to Latin America
**********************************

use "iccprRatEpisodeDat.dta", clear
xtset dyadid
rename name_2 countryname
run "../scripts/Make world bank geographic regions.09.03.07.do"
rename countryname name_2
tab pta012345 treated if name_1=="United States of America" & region_Latin==1
/*logit pta012345 treated l1* if name_1=="United States of America" & region_Latin==1, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g ///

logit pta012345 treated l1* `lags' if name_1=="United States of America" & region_Latin==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1
*/


use "opt1RatEpisodeDat.dta", clear
xtset dyadid
rename name_2 countryname
run "../scripts/Make world bank geographic regions.09.03.07.do"
rename countryname name_2
tab pta012345 treated if name_1=="United States of America" & region_Latin==1
logit pta012345 treated l1* if name_1=="United States of America" & region_Latin==1, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g ///

*logit pta012345 treated l1* `lags' if name_1=="United States of America" & region_Latin==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1


use "catRatEpisodeDat.dta", clear
xtset dyadid
rename name_2 countryname
run "../scripts/Make world bank geographic regions.09.03.07.do"
rename countryname name_2
tab pta012345 treated if name_1=="United States of America" & region_Latin==1
/* logit pta012345 treated l1* if name_1=="United States of America" & region_Latin==1, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g
logit pta012345 treated l1* `lags' if name_1=="United States of America" & region_Latin==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1
*/

use "art22RatEpisodeDat.dta", clear
xtset dyadid
rename name_2 countryname
run "../scripts/Make world bank geographic regions.09.03.07.do"
rename countryname name_2
tab pta012345 treated if name_1=="United States of America" & region_Latin==1
logit pta012345 treated l1* if name_1=="United States of America" & region_Latin==1, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g
*logit pta012345 treated l1* `lags' if name_1=="United States of America" & region_Latin==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1


********************************
** Europe with former colonies
********************************

use "iccprRatEpisodeDat.dta", clear
xtset dyadid
tab pta012345 treated if fmrcol_new==1
/*
logit pta012345 treated l1* if fmrcol_new==1, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g ///

logit pta012345 treated l1* `lags' if fmrcol_new==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1
*/


use "opt1RatEpisodeDat.dta", clear
xtset dyadid
tab pta012345 treated if fmrcol_new==1
/*
logit pta012345 treated l1* if fmrcol_new==1, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g ///

*logit pta012345 treated l1* `lags' if name_1=="United States of America" & region_Latin==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1
*/


use "catRatEpisodeDat.dta", clear
xtset dyadid
tab pta012345 treated if fmrcol_new==1
/* logit pta012345 treated l1* if name_1=="United States of America" & region_Latin==1, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g
logit pta012345 treated l1* `lags' if name_1=="United States of America" & region_Latin==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1
*/

use "art22RatEpisodeDat.dta", clear
xtset dyadid
tab pta012345 treated if fmrcol_new==1
/*
logit pta012345 treated l1* if name_1=="United States of America" & region_Latin==1, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g
*logit pta012345 treated l1* `lags' if name_1=="United States of America" & region_Latin==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1
*/


*******************************************
* The effect on transition countries -- they should be most susceptible to external legitimation?
*******************************************

insheet using "../rawdata/regime type.csv", comma clear
rename name countryname
run "../scripts/Standardize Country Names.do"
run "../scripts/Standardize Country Codes.do"
drop if countrycode_g=="Country Code (Gleditsch)"
*gen name_1="France"
gen name_2=countryname
drop countryname
save "../junk/beth regime type for merge.dta", replace

use "mahmatches_iccprpta.dta", clear
xtset dyadid
merge m:m name_2 year using "../junk/beth regime type for merge.dta"
drop if name_1==""
egen tmp = max(trans7), by(name_2)
logit pta012345 treated l1* if tmp==1, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g ///

logit pta012345 treated l1* `lags' if tmp==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1

use "mahmatches_iccprpta_Ratifiers.dta", clear
*`HRA'name_1==1 & `HRA'name_2==0
xtset dyadid
merge m:m name_2 year using "../junk/beth regime type for merge.dta"
drop if name_1==""
egen tmp = max(trans7), by(name_2)
logit pta012345 treated l1* if tmp==1, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g ///

logit pta012345 treated l1* `lags' if tmp==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1



use "mahmatches_opt1pta.dta", clear
xtset dyadid
merge m:m name_2 year using "../junk/beth regime type for merge.dta"
drop if name_1==""
egen tmp = max(trans7), by(name_2)
sum distance, detail
drop l1llnGDP_gled08  
logit pta012345 treated l1* if tmp==1, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g ///

logit pta012345 treated l1* `lags' if tmp==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1



use "mahmatches_opt1pta_Ratifiers.dta", clear
xtset dyadid
merge m:m name_2 year using "../junk/beth regime type for merge.dta"
drop if name_1==""
egen tmp = max(trans7), by(name_2)
sum distance, detail
logit pta012345 treated l1* if tmp==1, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g
logit pta012345 treated l1* `lags' if tmp==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1



use "mahmatches_catpta.dta", clear
xtset dyadid
merge m:m name_2 year using "../junk/beth regime type for merge.dta"
drop if name_1==""
egen tmp = max(trans7), by(name_2)
sum distance, detail
logit pta012345 treated l1* if tmp==1, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g
logit pta012345 treated l1* `lags' if tmp==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1

use "mahmatches_catpta_Ratifiers.dta", clear
xtset dyadid
merge m:m name_2 year using "../junk/beth regime type for merge.dta"
drop if name_1==""
egen tmp = max(trans7), by(name_2)
sum distance, detail
logit pta012345 treated l1* if tmp==1, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g
logit pta012345 treated l1* `lags' if tmp==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1


use "mahmatches_art22pta.dta", clear
xtset dyadid
merge m:m name_2 year using "../junk/beth regime type for merge.dta"
drop if name_1==""
egen tmp = max(trans7), by(name_2)
sum distance, detail
logit pta012345 treated l1* if tmp==1, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g
logit pta012345 treated l1* `lags' if tmp==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1

use "mahmatches_art22pta_Ratifiers.dta", clear
xtset dyadid
merge m:m name_2 year using "../junk/beth regime type for merge.dta"
drop if name_1==""
egen tmp = max(trans7), by(name_2)
sum distance, detail
drop l1larmconflict
logit pta012345 treated l1* if tmp==1, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g
logit pta012345 treated l1* `lags' if tmp==1, cluster(dyadid) l(90)

tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1



*******************************************
** subset by middle and low income (bottom 50 %)
*******************************************

use "mahmatches_iccprpta.dta", clear
xtset dyadid
_pctile llnGDP_gled08, p(50)
** indicator == 1 if both in a matched pair are below the cutoff
egen tmp = min(llnGDP_gled08<`r(r1)'), by(strata)
logit pta012345 treated l1* if tmp==1, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g ///

logit pta012345 treated l1* `lags' if tmp==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1

use "mahmatches_iccprpta_Ratifiers.dta", clear
*`HRA'name_1==1 & `HRA'name_2==0
xtset dyadid
_pctile llnGDP_gled08, p(50)
** indicator == 1 if both in a matched pair are below the cutoff
egen tmp = min(llnGDP_gled08<`r(r1)'), by(strata)
logit pta012345 treated l1* if tmp==1, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g ///

logit pta012345 treated l1* `lags' if tmp==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1


use "mahmatches_opt1pta.dta", clear
xtset dyadid
_pctile llnGDP_gled08, p(50)
** indicator == 1 if both in a matched pair are below the cutoff
egen tmp = min(llnGDP_gled08<`r(r1)'), by(strata)
sum distance, detail
drop l1llnGDP_gled08  
logit pta012345 treated l1* if tmp==1, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g ///

logit pta012345 treated l1* `lags' if tmp==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1



use "mahmatches_opt1pta_Ratifiers.dta", clear
xtset dyadid
_pctile llnGDP_gled08, p(50)
** indicator == 1 if both in a matched pair are below the cutoff
egen tmp = min(llnGDP_gled08<`r(r1)'), by(strata)
sum distance, detail
logit pta012345 treated l1* if tmp==1, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g
logit pta012345 treated l1* `lags' if tmp==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1




use "mahmatches_catpta.dta", clear
xtset dyadid
_pctile llnGDP_gled08, p(50)
** indicator == 1 if both in a matched pair are below the cutoff
egen tmp = min(llnGDP_gled08<`r(r1)'), by(strata)
sum distance, detail
logit pta012345 treated l1* if tmp==1, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g
logit pta012345 treated l1* `lags' if tmp==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1

use "mahmatches_catpta_Ratifiers.dta", clear
xtset dyadid
_pctile llnGDP_gled08, p(50)
** indicator == 1 if both in a matched pair are below the cutoff
egen tmp = min(llnGDP_gled08<`r(r1)'), by(strata)
sum distance, detail
logit pta012345 treated l1* if tmp==1, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g
logit pta012345 treated l1* `lags' if tmp==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1




use "mahmatches_art22pta.dta", clear
xtset dyadid
_pctile llnGDP_gled08, p(50)
** indicator == 1 if both in a matched pair are below the cutoff
egen tmp = min(llnGDP_gled08<`r(r1)'), by(strata)
sum distance, detail
logit pta012345 treated l1* if tmp==1, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g
logit pta012345 treated l1* `lags' if tmp==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1

use "mahmatches_art22pta_Ratifiers.dta", clear
xtset dyadid
_pctile llnGDP_gled08, p(50)
** indicator == 1 if both in a matched pair are below the cutoff
egen tmp = min(llnGDP_gled08<`r(r1)'), by(strata)
sum distance, detail
drop l1larmconflict
logit pta012345 treated l1* if tmp==1, cluster(dyadid) l(90)
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g
logit pta012345 treated l1* `lags' if tmp==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab pta012345 if e(sample)==1
tab year if e(sample)==1


cd "../.."


log close
