** This script runs the models on the matched data
** Run in Stata 12.1

** I assume that the current working directory is the archive main directory

capture mkdir "aid/results"

log using "aid/results/5_aid models other stuff.smcl", replace

set more off


*****************************************
** subset by allies
*****************************************

cd "aid/madedata"

** ICCPR
use "mahmatches_iccpraid.dta", clear
xtset dyadid
reg aidpc012345 treated l1* if l1alliance==1, cluster(dyadid) l(90)
local lags ///
  l2physint l3physint l4physint l5physint ///
  l2aidpc l3aidpc l4aidpc l5aidpc ///
  l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
  l2ln_population l3ln_population l4ln_population l5ln_population ///
  l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
  l2war l3war l4war l5war   
reg aidpc012345 treated l1* `lags' if l1alliance==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab year if e(sample)==1

** OPT1
use "mahmatches_opt1aid.dta", clear
xtset dyadid
reg aidpc012345 treated l1* if l1alliance==1, cluster(dyadid) l(90)
local lags ///
  l2physint l3physint l4physint l5physint ///
  l2aidpc l3aidpc l4aidpc l5aidpc ///
  l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
  l2ln_population l3ln_population l4ln_population l5ln_population ///
  l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
  l2war l3war l4war l5war   
reg aidpc012345 treated l1* `lags' if l1alliance==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab year if e(sample)==1

** CAT
use "mahmatches_cataid.dta", clear
xtset dyadid
reg aidpc012345 treated l1* if l1alliance==1, cluster(dyadid) l(90)
local lags ///
  l2physint l3physint l4physint l5physint ///
  l2aidpc l3aidpc l4aidpc l5aidpc ///
  l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
  l2ln_population l3ln_population l4ln_population l5ln_population ///
  l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
  l2war l3war l4war l5war   
reg aidpc012345 treated l1* `lags' if l1alliance==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab year if e(sample)==1

** ART22
use "mahmatches_art22aid.dta", clear
xtset dyadid
reg aidpc012345 treated l1* if l1alliance==1, cluster(dyadid) l(90)
local lags ///
  l2physint l3physint l4physint l5physint ///
  l2aidpc l3aidpc l4aidpc l5aidpc ///
  l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
  l2ln_population l3ln_population l4ln_population l5ln_population ///
  l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
  l2war l3war l4war l5war   
reg aidpc012345 treated l1* `lags' if l1alliance==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab year if e(sample)==1


*******************************************
** subset by major trading partners
*******************************************

** ICCPR
use "mahmatches_iccpraid.dta", clear
xtset dyadid
_pctile ln_trade, p(50)
egen midlow = min(ln_trade>`r(r1)'), by(strata)
reg aidpc012345 treated l1* if midlow==1, cluster(dyadid) l(90)
capture drop midlow
local lags ///
  l2physint l3physint l4physint l5physint ///
  l2aidpc l3aidpc l4aidpc l5aidpc ///
  l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
  l2ln_population l3ln_population l4ln_population l5ln_population ///
  l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
  l2war l3war l4war l5war
_pctile ln_trade, p(50)
egen midlow = min(ln_trade>`r(r1)'), by(strata)
reg aidpc012345 treated l1* `lags' if midlow==1, cluster(dyadid) l(90)
capture drop midlow
tab treated if e(sample)==1
tab year if e(sample)==1

** OPT1
use "mahmatches_opt1aid.dta", clear
xtset dyadid
_pctile ln_trade, p(50)
egen midlow = min(ln_trade>`r(r1)'), by(strata)
reg aidpc012345 treated l1* if midlow==1, cluster(dyadid) l(90)
capture drop midlow
local lags ///
  l2physint l3physint l4physint l5physint ///
  l2aidpc l3aidpc l4aidpc l5aidpc ///
  l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
  l2ln_population l3ln_population l4ln_population l5ln_population ///
  l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
  l2war l3war l4war l5war  
_pctile ln_trade, p(50)
egen midlow = min(ln_trade>`r(r1)'), by(strata)
reg aidpc012345 treated l1* `lags' if midlow==1, cluster(dyadid) l(90)
capture drop midlow
tab treated if e(sample)==1
tab year if e(sample)==1

** CAT
use "mahmatches_cataid.dta", clear
xtset dyadid
_pctile ln_trade, p(50)
egen midlow = min(ln_trade>`r(r1)'), by(strata)
reg aidpc012345 treated l1* if midlow==1, cluster(dyadid) l(90)
capture drop midlow
local lags ///
  l2physint l3physint l4physint l5physint ///
  l2aidpc l3aidpc l4aidpc l5aidpc ///
  l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
  l2ln_population l3ln_population l4ln_population l5ln_population ///
  l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
  l2war l3war l4war l5war   
_pctile ln_trade, p(50)
egen midlow = min(ln_trade>`r(r1)'), by(strata)
reg aidpc012345 treated l1* `lags' if midlow==1, cluster(dyadid) l(90)
capture drop midlow
tab treated if e(sample)==1
tab year if e(sample)==1

** ART22
use "mahmatches_art22aid.dta", clear
xtset dyadid
_pctile ln_trade, p(50)
egen midlow = min(ln_trade>`r(r1)'), by(strata)
reg aidpc012345 treated l1* if midlow==1, cluster(dyadid) l(90)
capture drop midlow
local lags ///
  l2physint l3physint l4physint l5physint ///
  l2aidpc l3aidpc l4aidpc l5aidpc ///
  l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
  l2ln_population l3ln_population l4ln_population l5ln_population ///
  l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
  l2war l3war l4war l5war   
_pctile ln_trade, p(50)
egen midlow = min(ln_trade>`r(r1)'), by(strata)
reg aidpc012345 treated l1* `lags' if midlow==1, cluster(dyadid) l(90)
capture drop midlow
tab treated if e(sample)==1
tab year if e(sample)==1


*******************************************
** Europe on ex-colonies and US w LA
*******************************************

**********************************
** US aid to Latin America
**********************************

** ICCPR
use "mahmatches_iccpraid.dta", clear
xtset dyadid
egen tmp = max(name_1=="United States" & region_Latin==1), by(strata)
edit name_1 name_2 region_Latin tmp strata if tmp==1
** Can't use the matched data sets here!

use "iccprRatEpisodeDat.dta", clear
xtset dyadid year
reg aidpc012345 treated l1* if name_1=="United States" & region_Latin==1, cluster(dyadid) l(90)
local lags ///
    l2physint l3physint l4physint l5physint ///
    l2aidpc l3aidpc l4aidpc l5aidpc ///
    l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
    l2ln_population l3ln_population l4ln_population l5ln_population ///
    l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
    l2war l3war l4war l5war   
reg aidpc012345 treated l1* `lags' if name_1=="United States" & region_Latin==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab year if e(sample)==1	
	
use "opt1RatEpisodeDat.dta", clear
xtset dyadid year
reg aidpc012345 treated l1* if name_1=="United States" & region_Latin==1, cluster(dyadid) l(90)
local lags ///
    l2physint l3physint l4physint l5physint ///
    l2aidpc l3aidpc l4aidpc l5aidpc ///
    l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
    l2ln_population l3ln_population l4ln_population l5ln_population ///
    l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
    l2war l3war l4war l5war   
reg aidpc012345 treated l1* `lags' if name_1=="United States" & region_Latin==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab year if e(sample)==1
	
use "catRatEpisodeDat.dta", clear
xtset dyadid year
reg aidpc012345 treated l1* if name_1=="United States" & region_Latin==1, cluster(dyadid) l(90)
local lags ///
    l2physint l3physint l4physint l5physint ///
    l2aidpc l3aidpc l4aidpc l5aidpc ///
    l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
    l2ln_population l3ln_population l4ln_population l5ln_population ///
    l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
    l2war l3war l4war l5war   
reg aidpc012345 treated l1* `lags' if name_1=="United States" & region_Latin==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab year if e(sample)==1

use "art22RatEpisodeDat.dta", clear
xtset dyadid year
reg aidpc012345 treated l1* if name_1=="United States" & region_Latin==1, cluster(dyadid) l(90)
local lags ///
    l2physint l3physint l4physint l5physint ///
    l2aidpc l3aidpc l4aidpc l5aidpc ///
    l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
    l2ln_population l3ln_population l4ln_population l5ln_population ///
    l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
    l2war l3war l4war l5war   
reg aidpc012345 treated l1* `lags' if name_1=="United States" & region_Latin==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab year if e(sample)==1


********************************
** Europe with former colonies
********************************

** ICCPR
use "mahmatches_iccpraid.dta", clear
xtset dyadid
egen tmp = max(dyad_colony), by(strata)
edit name_1 name_2 region_Latin tmp strata if tmp==1
** Can't use the matched data sets here!

use "iccprRatEpisodeDat.dta", clear
xtset dyadid year
reg aidpc012345 treated l1* if dyad_colony==1, cluster(dyadid) l(90)
local lags ///
    l2physint l3physint l4physint l5physint ///
    l2aidpc l3aidpc l4aidpc l5aidpc ///
    l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
    l2ln_population l3ln_population l4ln_population l5ln_population ///
    l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
    l2war l3war l4war l5war   
reg aidpc012345 treated l1* `lags' if dyad_colony==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab year if e(sample)==1	
	
use "opt1RatEpisodeDat.dta", clear
xtset dyadid year
reg aidpc012345 treated l1* if dyad_colony==1, cluster(dyadid) l(90)
local lags ///
    l2physint l3physint l4physint l5physint ///
    l2aidpc l3aidpc l4aidpc l5aidpc ///
    l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
    l2ln_population l3ln_population l4ln_population l5ln_population ///
    l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
    l2war l3war l4war l5war   
reg aidpc012345 treated l1* `lags' if dyad_colony==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab year if e(sample)==1
	
use "catRatEpisodeDat.dta", clear
xtset dyadid year
reg aidpc012345 treated l1* if dyad_colony==1, cluster(dyadid) l(90)
local lags ///
    l2physint l3physint l4physint l5physint ///
    l2aidpc l3aidpc l4aidpc l5aidpc ///
    l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
    l2ln_population l3ln_population l4ln_population l5ln_population ///
    l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
    l2war l3war l4war l5war   
reg aidpc012345 treated l1* `lags' if dyad_colony==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab year if e(sample)==1

use "art22RatEpisodeDat.dta", clear
xtset dyadid year
reg aidpc012345 treated l1* if dyad_colony==1, cluster(dyadid) l(90)
local lags ///
    l2physint l3physint l4physint l5physint ///
    l2aidpc l3aidpc l4aidpc l5aidpc ///
    l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
    l2ln_population l3ln_population l4ln_population l5ln_population ///
    l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
    l2war l3war l4war l5war   
reg aidpc012345 treated l1* `lags' if dyad_colony==1, cluster(dyadid) l(90)
tab treated if e(sample)==1
tab year if e(sample)==1


	

*******************************************
* The effect on transition countries -- they should be most susceptible to external legitimation?
*******************************************
** This data set was compiled by Beth Simmons for her 2009 Book
insheet using "../rawdata/regime type.csv", comma clear
rename name countryname
run "../scripts/Standardize Country Names.do"
run "../scripts/Standardize Country Codes.do"
drop if countrycode_g=="Country Code (Gleditsch)"
*gen name_1="France"
gen name_2=countryname
drop countryname
save "../madedata/beth regime type for merge.dta", replace

** ICCPR
use "mahmatches_iccpraid.dta", clear
merge m:m name_2 year using "../madedata/beth regime type for merge.dta"
drop if name_1==""
egen trans = max(trans7), by(name_2)
xtset dyadid
_pctile ln_rgdpc, p(50)
** indicator == 1 if both in a matched pair are below the cutoff
egen tmp = max(trans), by(strata)
reg aidpc012345 treated l1* if tmp==1, cluster(dyadid) l(90)
capture drop tmp
local lags ///
  l2physint l3physint l4physint l5physint ///
  l2aidpc l3aidpc l4aidpc l5aidpc ///
  l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
  l2ln_population l3ln_population l4ln_population l5ln_population ///
  l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
  l2war l3war l4war l5war
_pctile ln_rgdpc, p(50)
** indicator == 1 if both in a matched pair are below the cutoff
egen tmp = min(ln_rgdpc<`r(r1)'), by(strata)
reg aidpc012345 treated l1* `lags' if tmp==1, cluster(dyadid) l(90)
capture drop tmp
tab treated if e(sample)==1
tab year if e(sample)==1


** OPT1
use "mahmatches_opt1aid.dta", clear
merge m:m name_2 year using "../madedata/beth regime type for merge.dta"
drop if name_1==""
egen trans = max(trans7), by(name_2)
xtset dyadid
_pctile ln_rgdpc, p(50)
egen tmp = min(ln_rgdpc<`r(r1)'), by(strata)
reg aidpc012345 treated l1* if tmp==1, cluster(dyadid) l(90)
capture drop tmp
local lags ///
  l2physint l3physint l4physint l5physint ///
  l2aidpc l3aidpc l4aidpc l5aidpc ///
  l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
  l2ln_population l3ln_population l4ln_population l5ln_population ///
  l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
  l2war l3war l4war l5war  
_pctile ln_rgdpc, p(50)
egen tmp = min(ln_rgdpc<`r(r1)'), by(strata)
reg aidpc012345 treated l1* `lags' if tmp==1, cluster(dyadid) l(90)
capture drop tmp
tab treated if e(sample)==1
tab year if e(sample)==1

** CAT
use "mahmatches_cataid.dta", clear
merge m:m name_2 year using "../madedata/beth regime type for merge.dta"
drop if name_1==""
egen trans = max(trans7), by(name_2)
xtset dyadid
_pctile ln_rgdpc, p(50)
egen tmp = min(ln_rgdpc<`r(r1)'), by(strata)
reg aidpc012345 treated l1* if tmp==1, cluster(dyadid) l(90)
capture drop tmp
local lags ///
  l2physint l3physint l4physint l5physint ///
  l2aidpc l3aidpc l4aidpc l5aidpc ///
  l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
  l2ln_population l3ln_population l4ln_population l5ln_population ///
  l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
  l2war l3war l4war l5war   
_pctile ln_rgdpc, p(50)
egen tmp = min(ln_rgdpc<`r(r1)'), by(strata)
reg aidpc012345 treated l1* `lags' if tmp==1, cluster(dyadid) l(90)
capture drop tmp
tab treated if e(sample)==1
tab year if e(sample)==1

** ART22
use "mahmatches_art22aid.dta", clear
merge m:m name_2 year using "../madedata/beth regime type for merge.dta"
drop if name_1==""
egen trans = max(trans7), by(name_2)
xtset dyadid
_pctile ln_rgdpc, p(50)
egen tmp = min(ln_rgdpc<`r(r1)'), by(strata)
reg aidpc012345 treated l1* if tmp==1, cluster(dyadid) l(90)
capture drop tmp
local lags ///
  l2physint l3physint l4physint l5physint ///
  l2aidpc l3aidpc l4aidpc l5aidpc ///
  l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
  l2ln_population l3ln_population l4ln_population l5ln_population ///
  l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
  l2war l3war l4war l5war   
_pctile ln_rgdpc, p(50)
egen tmp = min(ln_rgdpc<`r(r1)'), by(strata)
reg aidpc012345 treated l1* `lags' if tmp==1, cluster(dyadid) l(90)
capture drop tmp
tab treated if e(sample)==1
tab year if e(sample)==1



*******************************************
** subset by middle and low income (bottom 50 %)
*******************************************

** ICCPR
use "mahmatches_iccpraid.dta", clear
xtset dyadid
_pctile ln_rgdpc, p(50)
** indicator == 1 if both in a matched pair are below the cutoff
egen midlow = min(ln_rgdpc<`r(r1)'), by(strata)
reg aidpc012345 treated l1* if midlow==1, cluster(dyadid) l(90)
capture drop midlow
local lags ///
  l2physint l3physint l4physint l5physint ///
  l2aidpc l3aidpc l4aidpc l5aidpc ///
  l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
  l2ln_population l3ln_population l4ln_population l5ln_population ///
  l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
  l2war l3war l4war l5war
_pctile ln_rgdpc, p(50)
** indicator == 1 if both in a matched pair are below the cutoff
egen midlow = min(ln_rgdpc<`r(r1)'), by(strata)
reg aidpc012345 treated l1* `lags' if midlow==1, cluster(dyadid) l(90)
capture drop midlow
tab treated if e(sample)==1
tab year if e(sample)==1

** OPT1
use "mahmatches_opt1aid.dta", clear
xtset dyadid
_pctile ln_rgdpc, p(50)
egen midlow = min(ln_rgdpc<`r(r1)'), by(strata)
reg aidpc012345 treated l1* if midlow==1, cluster(dyadid) l(90)
capture drop midlow
local lags ///
  l2physint l3physint l4physint l5physint ///
  l2aidpc l3aidpc l4aidpc l5aidpc ///
  l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
  l2ln_population l3ln_population l4ln_population l5ln_population ///
  l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
  l2war l3war l4war l5war  
_pctile ln_rgdpc, p(50)
egen midlow = min(ln_rgdpc<`r(r1)'), by(strata)
reg aidpc012345 treated l1* `lags' if midlow==1, cluster(dyadid) l(90)
capture drop midlow
tab treated if e(sample)==1
tab year if e(sample)==1

** CAT
use "mahmatches_cataid.dta", clear
xtset dyadid
_pctile ln_rgdpc, p(50)
egen midlow = min(ln_rgdpc<`r(r1)'), by(strata)
reg aidpc012345 treated l1* if midlow==1, cluster(dyadid) l(90)
capture drop midlow
local lags ///
  l2physint l3physint l4physint l5physint ///
  l2aidpc l3aidpc l4aidpc l5aidpc ///
  l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
  l2ln_population l3ln_population l4ln_population l5ln_population ///
  l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
  l2war l3war l4war l5war   
_pctile ln_rgdpc, p(50)
egen midlow = min(ln_rgdpc<`r(r1)'), by(strata)
reg aidpc012345 treated l1* `lags' if midlow==1, cluster(dyadid) l(90)
capture drop midlow
tab treated if e(sample)==1
tab year if e(sample)==1

** ART22
use "mahmatches_art22aid.dta", clear
xtset dyadid
_pctile ln_rgdpc, p(50)
egen midlow = min(ln_rgdpc<`r(r1)'), by(strata)
reg aidpc012345 treated l1* if midlow==1, cluster(dyadid) l(90)
capture drop midlow
local lags ///
  l2physint l3physint l4physint l5physint ///
  l2aidpc l3aidpc l4aidpc l5aidpc ///
  l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
  l2ln_population l3ln_population l4ln_population l5ln_population ///
  l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
  l2war l3war l4war l5war   
_pctile ln_rgdpc, p(50)
egen midlow = min(ln_rgdpc<`r(r1)'), by(strata)
reg aidpc012345 treated l1* `lags' if midlow==1, cluster(dyadid) l(90)
capture drop midlow
tab treated if e(sample)==1
tab year if e(sample)==1

cd "../.."

log close


