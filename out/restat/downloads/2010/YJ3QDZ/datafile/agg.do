cap log close
log using agg.log, replace
set more off

clear
set mem 300m

** Analysis for aggregate China exports
*   

#delimit ;

use d:\__exports\data\comtrade\chinaexports\chinaexports9598, clear;


** Shock index;
gen shockindex = erchange_official + 1;


** Unit values;
gen unitval = val/quant;


** Log values;
for any
val unitval quant shockindex
:
gen lX=ln(X)
;


** Change variables;
for any
val unitval quant
: 
bysort ctname hs6dig (year):  gen chlX = lX- lX[_n-1]
;


** Value in 1995;
for any
val unitval quant
:
gen a=X if year==1995 \
egen X95=max(a), by(ctname hs6dig) \
drop a
;


** Regressions;

keep if year==1998;


for any 
val unitval quant
:
reg chlX lshockindex [aw=val95], cluster(wdi_name) \
areg chlX lshockindex [aw=val95], a(hs6dig) cluster(wdi_name) \
;


log close;
