** This script runs the models on the matched data
** Run in Stata 12.1

** I assume that the current working directory is the archive main directory

capture mkdir "aid/results"
log using "aid/results/3_aid models with matching.smcl", replace

set more off

cd "aid/madedata"

** ICCPR
use "mahmatches_iccpraid.dta", clear
xtset dyadid
reg aidpc012345 treated l1*, cluster(dyadid) l(90)
local lags ///
  l2physint l3physint l4physint l5physint ///
  l2aidpc l3aidpc l4aidpc l5aidpc ///
  l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
  l2ln_population l3ln_population l4ln_population l5ln_population ///
  l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
  l2war l3war l4war l5war   
reg aidpc012345 treated l1* `lags', cluster(dyadid) l(90)
tab treated if e(sample)==1
tab year if e(sample)==1

use "mahmatches_iccpraid_Ratifiers.dta", clear
xtset dyadid
reg aidpc012345 treated l1*, cluster(dyadid) l(90)
local lags ///
  l2physint l3physint l4physint l5physint ///
  l2aidpc l3aidpc l4aidpc l5aidpc ///
  l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
  l2ln_population l3ln_population l4ln_population l5ln_population ///
  l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
  l2war l3war l4war l5war   
reg aidpc012345 treated l1* `lags', cluster(dyadid) l(90)
cd "../results"
outreg2 using fulltable, word replace 2aster 
cd "../madedata"
tab treated if e(sample)==1
tab year if e(sample)==1

** OPT1
use "mahmatches_opt1aid.dta", clear
xtset dyadid
reg aidpc012345 treated l1*, cluster(dyadid) l(90)
local lags ///
  l2physint l3physint l4physint l5physint ///
  l2aidpc l3aidpc l4aidpc l5aidpc ///
  l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
  l2ln_population l3ln_population l4ln_population l5ln_population ///
  l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
  l2war l3war l4war l5war   
reg aidpc012345 treated l1* `lags', cluster(dyadid) l(90)
tab treated if e(sample)==1

use "mahmatches_opt1aid_Ratifiers.dta", clear
xtset dyadid
reg aidpc012345 treated l1*, cluster(dyadid) l(90)
local lags ///
  l2physint l3physint l4physint l5physint ///
  l2aidpc l3aidpc l4aidpc l5aidpc ///
  l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
  l2ln_population l3ln_population l4ln_population l5ln_population ///
  l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
  l2war l3war l4war l5war   
reg aidpc012345 treated l1* `lags', cluster(dyadid) l(90)
cd "../results"
outreg2 using fulltable, word append 2aster 
cd "../madedata"
tab treated if e(sample)==1
tab year if e(sample)==1


** cat
use "mahmatches_cataid.dta", clear
xtset dyadid
reg aidpc012345 treated l1*, cluster(dyadid) l(90)
local lags ///
  l2physint l3physint l4physint l5physint ///
  l2aidpc l3aidpc l4aidpc l5aidpc ///
  l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
  l2ln_population l3ln_population l4ln_population l5ln_population ///
  l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
  l2war l3war l4war l5war   
reg aidpc012345 treated l1* `lags', cluster(dyadid) l(90)
tab treated if e(sample)==1

use "mahmatches_cataid_Ratifiers.dta", clear
xtset dyadid
reg aidpc012345 treated l1*, cluster(dyadid) l(90)
local lags ///
  l2physint l3physint l4physint l5physint ///
  l2aidpc l3aidpc l4aidpc l5aidpc ///
  l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
  l2ln_population l3ln_population l4ln_population l5ln_population ///
  l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
  l2war l3war l4war l5war   
reg aidpc012345 treated l1* `lags', cluster(dyadid) l(90)
cd "../results"
outreg2 using fulltable, word append 2aster 
cd "../madedata"
tab treated if e(sample)==1
tab year if e(sample)==1


** art22
use "mahmatches_art22aid.dta", clear
xtset dyadid
reg aidpc012345 treated l1*, cluster(dyadid) l(90)
local lags ///
  l2physint l3physint l4physint l5physint ///
  l2aidpc l3aidpc l4aidpc l5aidpc ///
  l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
  l2ln_population l3ln_population l4ln_population l5ln_population ///
  l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
  l2war l3war l4war l5war   
reg aidpc012345 treated l1* `lags', cluster(dyadid) l(90)
tab treated if e(sample)==1
tab year if e(sample)==1

use "mahmatches_art22aid_Ratifiers.dta", clear
xtset dyadid
reg aidpc012345 treated l1*, cluster(dyadid) l(90)
local lags ///
  l2physint l3physint l4physint l5physint ///
  l2aidpc l3aidpc l4aidpc l5aidpc ///
  l2ln_rgdpc l3ln_rgdpc l4ln_rgdpc l5ln_rgdpc ///
  l2ln_population l3ln_population l4ln_population l5ln_population ///
  l2ln_trade l3ln_trade l4ln_trade l5ln_trade ///
  l2war l3war l4war l5war   
reg aidpc012345 treated l1* `lags', cluster(dyadid) l(90)
cd "../results"
outreg2 using fulltable, word append 2aster 
cd "../madedata" 
tab treated if e(sample)==1
tab year if e(sample)==1

** change the directory back
cd "../..


log close
