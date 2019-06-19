cap log close
local filename=`"predshock"'
log using `filename'.log, replace

/* The following is using generated regression dataset to do analysis */
clear 
set memory 300m
set more off
set matsize 1000

#delimit ;



;;;
** REGRESSIONS**;;
;;;



use regdata1998_9800samp, clear ;

for any 
chlexport shockindex 
:
drop if X==.;


for any
lwgdp_pcap_std for_sh95_std lcaplab95_std
dest_exportshare_95 
size
ltrade_value96 ltrade_value93
lexport95 lexport94_mod
lsales_income95 lsales_income94_mod
export95_sales_income95fr export94_sales_income94fr_mod
salesyn94 
exportyn94 
export95_sales_income95_1 
: drop if X==.
;



gen chltrade_prov_ind9396 = ltrade_value96 - ltrade_value93;
gen chltrade_prov_ind9395 = ltrade_value95 - ltrade_value93;
gen chlexport9495 = lexport95 - lexport94_mod;
gen chlsales9495 = lsales_income95 - lsales_income94_mod;
gen chexport_sales9495 = export95_sales_income95fr - export94_sales_income94fr_mod;





xi: reg shockindex 
lsales_income95 chlsales9495 salesyn94 
lexport95 chlexport9495 exportyn94 
ltrade_value95 chltrade_prov_ind9395
export95_sales_income95fr chexport_sales9495 
export95_sales_income95_1 
dest_exportshare_95 
lwgdp_pcap for_sh95 lcaplab95
;
outreg
lsales_income95 chlsales9495 salesyn94 
lexport95 chlexport9495 exportyn94 
ltrade_value95 chltrade_prov_ind9395
export95_sales_income95fr chexport_sales9495 
export95_sales_income95_1 
dest_exportshare_95 
lwgdp_pcap for_sh95 lcaplab95
using `filename', se bdec(3) 3aster replace;



xi: areg shockindex 
lsales_income95 chlsales9495 salesyn94 
lexport95 chlexport9495 exportyn94 
ltrade_value95 chltrade_prov_ind9395
export95_sales_income95fr chexport_sales9495 
export95_sales_income95_1 
dest_exportshare_95 
lwgdp_pcap for_sh95 lcaplab95
, a(prov_ind) 
;
outreg
lsales_income95 chlsales9495 salesyn94 
lexport95 chlexport9495 exportyn94 
ltrade_value95 chltrade_prov_ind9395
export95_sales_income95fr chexport_sales9495 
export95_sales_income95_1 
dest_exportshare_95 
lwgdp_pcap for_sh95 lcaplab95
using `filename', se bdec(3) 3aster append;




log close; 

