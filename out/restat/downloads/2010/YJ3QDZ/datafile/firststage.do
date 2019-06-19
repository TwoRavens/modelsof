cap log close
local filename=`"firststage"'
log using `filename'.log, replace

clear 
set memory 300m
set more off
set matsize 1000

#delimit ;


;;;
** REGRESSIONS **;;
;;;

use regdata1998, clear;
reg chlexport shockindex_std;
outreg 
shockindex_std
using `filename', se bdec(3) 3aster replace;




for any 1998 2000
:
use regdataX, clear \
xi: areg chlexport
shockindex_std
lwgdp_pcap_std hkfr_std for_sh95_std lcaplab95_std lsales_income95_std lprod_levpet_mod95_std
dest_exportshare_95 
for_sh95 
i.size
ltrade_value96 ltrade_value93
lexport95 lexport94_mod
lsales_income94_mod
export95_sales_income95fr export94_sales_income94fr_mod
salesyn94 
exportyn94 
export95_sales_income95_1 
, a(prov_ind) cluster(first_countryname)
\ testparm shockindex_std 
\ outreg 
shockindex_std
using `filename', se bdec(3) 3aster append addstat(F-test,r(F),p-value,r(p))
\
xi: areg chlexport
shockindex_std sh_pci sh_hkfr sh_for sh_caplab sh_sales sh_lprod_lp_mod
lwgdp_pcap_std hkfr_std for_sh95_std lcaplab95_std lsales_income95_std lprod_levpet_mod95_std
dest_exportshare_95 
for_sh95 
i.size
ltrade_value96 ltrade_value93
lexport95 lexport94_mod
lsales_income94_mod
export95_sales_income95fr export94_sales_income94fr_mod
salesyn94 
exportyn94 
export95_sales_income95_1 
, a(prov_ind) cluster(first_countryname)
\ lincom shockindex_std - 1*sh_for 
\ lincom shockindex_std - 2*sh_for 
\testparm shockindex_std sh_*
\ outreg 
shockindex_std sh_pci sh_hkfr sh_for sh_caplab sh_sales sh_lprod_lp_mod
using `filename', se bdec(3) 3aster append addstat(F-test,r(F),p-value,r(p))
\
predict chlexport_pred if e(sample), xb \
su chlexport_pred, d \
\
gen chlexport_shockdriven = 
shockindex_std * _b[shockindex_std] +
shockindex_std * lwgdp_pcap_std * _b[sh_pci] +
shockindex_std * hkfr_std * _b[sh_hkfr] +
shockindex_std * for_sh95_std * _b[sh_for] +
shockindex_std * lcaplab95_std * _b[sh_caplab] +
shockindex_std * lsales_income95_std * _b[sh_sales] +
shockindex_std * lprod_levpet_mod95_std * _b[sh_lprod_lp_mod] 
if e(sample)
\
su chlexport_shockdriven, d 
;



;


for any 1998 2000
:
use regdataX_9800samp, clear \
xi: areg chlexport
shockindex_std
lwgdp_pcap_std hkfr_std for_sh95_std lcaplab95_std lsales_income95_std lprod_levpet_mod95_std
dest_exportshare_95 
for_sh95 
i.size
ltrade_value96 ltrade_value93
lexport95 lexport94_mod
lsales_income94_mod
export95_sales_income95fr export94_sales_income94fr_mod
salesyn94 
exportyn94 
export95_sales_income95_1 
, a(prov_ind) cluster(first_countryname)
\
testparm shockindex_std 
\ outreg 
shockindex_std
using `filename', se bdec(3) 3aster append addstat(F-test,r(F),p-value,r(p))
\
xi: areg chlexport
shockindex_std sh_pci sh_hkfr sh_for sh_caplab sh_sales sh_lprod_lp_mod
lwgdp_pcap_std hkfr_std for_sh95_std lcaplab95_std lsales_income95_std lprod_levpet_mod95_std
dest_exportshare_95 
for_sh95 
i.size
ltrade_value96 ltrade_value93
lexport95 lexport94_mod
lsales_income94_mod
export95_sales_income95fr export94_sales_income94fr_mod
salesyn94 
exportyn94 
export95_sales_income95_1 
, a(prov_ind) cluster(first_countryname)
\ lincom shockindex_std - 1*sh_for 
\ lincom shockindex_std - 2*sh_for 
\testparm shockindex_std sh_*
\ outreg 
shockindex_std sh_pci sh_hkfr sh_for sh_caplab sh_sales sh_lprod_lp_mod
using `filename', se bdec(3) 3aster append addstat(F-test,r(F),p-value,r(p))
\
predict chlexport_pred if e(sample), xb \
su chlexport_pred, d \
\
gen chlexport_shockdriven = 
shockindex_std * _b[shockindex_std] +
shockindex_std * lwgdp_pcap_std * _b[sh_pci] +
shockindex_std * hkfr_std * _b[sh_hkfr] +
shockindex_std * for_sh95_std * _b[sh_for] +
shockindex_std * lcaplab95_std * _b[sh_caplab] +
shockindex_std * lsales_income95_std * _b[sh_sales] +
shockindex_std * lprod_levpet_mod95_std * _b[sh_lprod_lp_mod] 
if e(sample)
\
su chlexport_shockdriven, d 
;


log close; 