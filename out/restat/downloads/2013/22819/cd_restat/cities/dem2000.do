**************************************************************************************
*			Do-file to compute gini coefficients at city level           *
*                                 from census 2000                              *
**************************************************************************************

clear
cap log close
set mem 100m

global census00="C:\Users\HW462587\Documents\Leah\census 2000 - 2\dc_dec_2000_sf3_u_data1"



** 2000 ***

clear
use "$census00"

drop if   p076001==.
drop  p076001

rename geo_id2 fips_s
gen year=1999

keep fips_s year share65 mean_income share_black share_hisp poverty_rate population


save "C:\Users\HW462587\Documents\Leah\census 2000 - 2\dem00", replace





