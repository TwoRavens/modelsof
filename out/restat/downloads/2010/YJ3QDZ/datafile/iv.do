cap log close
local filename=`"iv"'
log using `filename'.log, replace

clear 
set memory 300m
set more off
set matsize 1000

#delimit ;

set seed 123456789;

local outcomes_main = `"
lprod_ols_mod lprod_levpet_mod 
lemployee lf_asset_net_value 
lcapital_labor 
lwage_payable_employeefr ope_profit_totalassetfr 
lsales_income lsales_income_employeefr 
linter_input 
for_sh
"';



;;;
** EXPORTS, DIFFERENT SAMPLES **;;
;;;


for any 1998 
:
use regdataX, clear \
gen random=uniform() \

reg random
chlexport 
\
outreg
chlexport 
using `filename'_diffsamp, se bdec(3) 3aster replace
;




foreach var in `outcomes_main' {;

for any 1998 2000
:
use regdataX, clear \
xi: ivreg ch`var'
(chlexport = 
shockindex_std sh_pci sh_hkfr sh_for sh_caplab sh_sales sh_lprod_lp_mod
)
lwgdp_pcap_std hkfr_std for_sh95_std lcaplab95_std lprod_levpet_mod95_std
dest_exportshare_95 
for_sh95 
i.size
ltrade_value96 ltrade_value93
lexport95 lexport94_mod
lsales_income95 lsales_income94_mod
export95_sales_income95fr export94_sales_income94fr_mod
salesyn94 
exportyn94 
export95_sales_income95_1 
i.prov_ind
, cluster(first_countryname)
\ lincom chlexport
\
outreg
chlexport 
using `filename'_diffsamp, se bdec(3) 3aster append
;

};





;;;
** 	EXPORTS, SAME SAMP **;;
;;;


for any 1998 
:
use regdataX_9800samp, clear \
gen random=uniform() \

reg random
chlexport 
\
outreg
chlexport 
using `filename'_9800samp, se bdec(3) 3aster replace
;




foreach var in `outcomes_main' {;

for any 1998 2000
:
use regdataX_9800samp, clear \
xi: ivreg ch`var'
(chlexport = 
shockindex_std sh_pci sh_hkfr sh_for sh_caplab sh_sales sh_lprod_lp_mod
)
lwgdp_pcap_std hkfr_std for_sh95_std lcaplab95_std lprod_levpet_mod95_std
dest_exportshare_95 
for_sh95 
i.size
ltrade_value96 ltrade_value93
lexport95 lexport94_mod
lsales_income95 lsales_income94_mod
export95_sales_income95fr export94_sales_income94fr_mod
salesyn94 
exportyn94 
export95_sales_income95_1 
i.prov_ind
, cluster(first_countryname)
\ lincom chlexport
\
outreg
chlexport 
using `filename'_9800samp, se bdec(3) 3aster append
;

};







log close; 