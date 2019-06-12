*Estimates Under Various Identification Assumptions

*Garfield Heights

*********************Table 1********************
use "../Data/Voters_To_Blocks_Nest.dta", replace

reg turnout10 treat, cluster(block_id) ro

*Conditional Geographic Ignorability
*Without Past Turnout
reg turnout10 treat age age_sq PRES_DEM_PCT08 USH_DEM_PCT06 USH_DEM_PCT08 USS_DEM_PCT06 hispanic_pct white_pct ///
black_pct asian_pct house_occ_pct house_vacant_pct turnout08_agg turnout06_agg, cluster(block_id) ro

*********************Table 2 ********************

use "./FullCounty-Balance.dta", replace

sum salepr if treat==1,d
sum salepr if treat==0,d
ksmirnov salepr, by(treat)

*Compare NE GH Heights to the Rest of GH
use "./Within-GH-Balance.dta", replace

sum sale_price if treat==0, detail
sum sale_price if treat==1, detail
ksmirnov sale_price, by(treat)

*Compare to NE GH to Cleveland Subset
use  "./NEGH_Houses_Subset.dta", replace

sum sale_price if treat==0, detail
sum sale_price if treat==1, detail
ksmirnov sale_price, by(treat)


********************Table 3********************
use "NE-Voters_To_Blocks_Nest.dta", replace

*Column 1
reg turnout10 treat, cluster(block_id) ro

*Column 2
regress turnout10 treat age hispanic_pct ///
black_pct house_vacant_pct dem, ro cluster(block_id)





