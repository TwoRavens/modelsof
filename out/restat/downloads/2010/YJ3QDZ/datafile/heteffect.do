cap log close
local filename=`"heteffect"'
log using `filename'.log, replace

clear 
set memory 300m
set more off
set matsize 1000

#delimit ;

set seed 123456789;


local outcomes_main = `"
lprod_ols_mod lprod_levpet_mod 
"';


use regdata2000_9800samp, clear ;

for any
chlexport
shockindex_std sh_pci sh_hkfr sh_for sh_caplab sh_sales sh_lprod_lp_mod 
:
gen X_pci = X * lwgdp_pcap_std  \
gen X_hkfr = X * hkfr_std  \
gen X_for = X * for_sh95_std \
gen X_caplab = X * lcaplab95_std \
gen X_sales = X * lsales_income95_std \
gen X_lprod_lp_mod = X * lprod_levpet_mod95_std \
;

 

;;;
** REGRESSIONS **;;
;;;

gen random=uniform();

reg random
chlexport 
chlexport_pci
chlexport_hkfr
chlexport_for
chlexport_caplab
chlexport_sales
chlexport_lprod_lp_mod
;
outreg
chlexport 
chlexport_pci
chlexport_hkfr
chlexport_for
chlexport_caplab
chlexport_sales
chlexport_lprod_lp_mod
using `filename', se bdec(3) 3aster replace
;



foreach var in `outcomes_main' {;


xi: ivreg ch`var'
(chlexport 
chlexport_pci
= 
shockindex_std sh_pci sh_hkfr sh_for sh_caplab sh_sales sh_lprod_lp_mod 
shockindex_std_pci sh_pci_pci sh_hkfr_pci sh_for_pci sh_caplab_pci sh_sales_pci sh_lprod_lp_mod_pci 
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
;
testparm chlexport 
chlexport_pci
;
outreg
chlexport 
chlexport_pci
using `filename', se bdec(3) 3aster append
;


xi: ivreg ch`var'
(chlexport 
chlexport_pci
chlexport_hkfr
chlexport_for
chlexport_caplab
chlexport_sales
chlexport_lprod_lp_mod
= 
shockindex_std sh_pci sh_hkfr sh_for sh_caplab sh_sales sh_lprod_lp_mod 
shockindex_std_pci sh_pci_pci sh_hkfr_pci sh_for_pci sh_caplab_pci sh_sales_pci sh_lprod_lp_mod_pci 
shockindex_std_hkfr sh_pci_hkfr sh_hkfr_hkfr sh_for_hkfr sh_caplab_hkfr sh_sales_hkfr sh_lprod_lp_mod_hkfr 
shockindex_std_for sh_pci_for sh_hkfr_for sh_for_for sh_caplab_for sh_sales_for sh_lprod_lp_mod_for 
shockindex_std_caplab sh_pci_caplab sh_hkfr_caplab sh_for_caplab sh_caplab_caplab sh_sales_caplab sh_lprod_lp_mod_caplab 
shockindex_std_sales sh_pci_sales sh_hkfr_sales sh_for_sales sh_caplab_sales sh_sales_sales sh_lprod_lp_mod_sales 
shockindex_std_lprod_lp_mod sh_pci_lprod_lp_mod sh_hkfr_lprod_lp_mod sh_for_lprod_lp_mod sh_caplab_lprod_lp_mod sh_sales_lprod_lp_mod sh_lprod_lp_mod_lprod_lp_mod 
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
;
testparm chlexport 
chlexport_pci
chlexport_hkfr
chlexport_for
chlexport_caplab
chlexport_sales
chlexport_lprod_lp_mod
;
outreg
chlexport 
chlexport_pci
chlexport_hkfr
chlexport_for
chlexport_caplab
chlexport_sales
chlexport_lprod_lp_mod
using `filename', se bdec(3) 3aster append
;


};


log close; 