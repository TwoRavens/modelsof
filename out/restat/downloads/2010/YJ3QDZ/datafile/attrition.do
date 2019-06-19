cap log close
local filename=`"attrition"'
log using `filename'.log, replace

clear 
set memory 300m
set more off
set matsize 1000

#delimit ;


use regdata1998_9800samp, clear;
keep firm_code;
sort firm_code ;
save balsamplist, replace
;


;;;
** ATTRITION **;;
;;;

use regdata1998, clear;
gen random = uniform();
reg chlexport random ;
outreg
random
using `filename', se bdec(3) 3aster replace;


for any 1998 2000
:
use attritdataX, clear \

sort firm_code \
merge firm_code using balsamplist, nokeep \ tab _m \ 
gen inbalsamp=1 if _m==3 \
drop _m\

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
if year==X & inbalsamp==1
, a(prov_ind) cluster(first_countryname)
\ predict chlexport_pred 
\ gen a=1 if e(sample) \
\ egen inX = sum(a), by(firm_code) \ drop a \
\ tab inX if year==1995
\ 

\
\\\ * SELECTION INTO FINAL SAMPLE \\\

xi: areg inX
chlexport_pred
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
if year==1995
, a(prov_ind) cluster(first_countryname)
\ lincom chlexport_pred 
\ 
outreg
chlexport_pred
using `filename', se bdec(3) 3aster append
\
count if sales_income<5000 & year==1995 & e(sample)
\
count if sales_income>=5000 & sales_income~=. & year==1995 & e(sample)
;



for any 1998 2000
:
use attritdataX, clear \

sort firm_code \
merge firm_code using balsamplist, nokeep \ tab _m \ 
gen inbalsamp=1 if _m==3 \
drop _m\

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
if year==X & inbalsamp==1
, a(prov_ind) cluster(first_countryname)

\ testparm shockindex_std sh_pci sh_homog sh_for sh_caplab sh_sales sh_expsh 
\ predict chlexport_pred 
\ gen a=1 if e(sample) \
\ egen inX = sum(a), by(firm_code) \ drop a \
\ tab inX if year==X\
\ 

\
\\\ * SELECTION INTO FINAL SAMPLE, CONDITIONAL ON BEING OBSERVED IN 1998 \\\

xi: areg inX
chlexport_pred
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
if year==X
, a(prov_ind) cluster(first_countryname)
\ lincom chlexport_pred 
\ 
outreg
chlexport_pred
using `filename', se bdec(3) 3aster append;
;

log close; 
erase balsamplist.dta;