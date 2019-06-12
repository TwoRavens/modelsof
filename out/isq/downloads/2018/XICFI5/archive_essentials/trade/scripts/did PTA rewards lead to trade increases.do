** run the trade models on the matched sample where I find positive effects on BITs

clear
set more off

use "pta/madedata/mahmatches_iccprpta_Ratifiers.dta", clear
*`HRA'name_1==1 & `HRA'name_2==0
xtset dyadid
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g ///

logit pta012345 treated l1* `lags', cluster(dyadid) l(90)

gen inmysample=e(sample)
keep if inmysample==1

keep name_1 name_2 year treated pta012345 strata
save "trade/madedata/obs from iccpr pta regression.dta", replace



use "pta/madedata/mahmatches_art22pta_Ratifiers.dta", clear
*`HRA'name_1==1 & `HRA'name_2==0
xtset dyadid
local lags l2polity2_04 l3polity2_04 l4polity2_04 l5polity2_04 ///
  l2ptadum_new l3ptadum_new l4ptadum_new l5ptadum_new /// /*existing pta*/
  l2llntradenew l3llntradenew l4llntradenew l5llntradenew ///
  l2llnGDP_gled08 l3llnGDP_gled08 l4llnGDP_gled08 l5llnGDP_gled08  ///
  l2ldGDP_gled08V2 l3ldGDP_gled08V2 l4ldGDP_gled08V2 l5ldGDP_gled08V2 ///
  l2llnGDPratio_g l3llnGDPratio_g l4llnGDPratio_g l5llnGDPratio_g ///

logit pta012345 treated l1* `lags', cluster(dyadid) l(90)
gen inmysample=e(sample)
keep if inmysample==1
keep name_1 name_2 year treated pta012345 strata
save "trade/madedata/obs from art22 pta regression.dta", replace


** load the trade data -- ICCPR
use "trade/madedata/iccprRatEpisodeDat.dta", clear
merge 1:1 name_1 name_2 year using "trade/madedata/obs from iccpr pta regression.dta"
** This merge seems weird, even though I made the trade data from scratch, some are missing
keep if _merge==3
reg imports012345 treated 
reg imports012345 treated l1*
reg imports012345 treated l1* if pta012345==1
reg imports012345 pta012345#treated l1*

** load the trade data -- art22
use "trade/madedata/art22RatEpisodeDat.dta", clear
merge 1:1 name_1 name_2 year using "trade/madedata/obs from art22 pta regression.dta"
** This merge seems weird, even though I made the trade data from scratch, some are missing
keep if _merge==3
reg imports012345 treated 
reg imports012345 treated l1*
reg imports012345 treated l1* if pta012345==1
reg imports012345 pta012345#treated l1*

