*******************
***TABLE 9
*******************

capture log close
clear 
cd "C:\Users\jenny\Dropbox\Replication Office-selling\Main"
log using Table9, replace

use main_panel, clear

gen int1 = meanprice*ofsell
gen int2 = minpriceh*ofsell

*COLUMN 1

#delimit ;
xtreg gov_reb int1 int2 ofsell obyear* i.year, fe;
sum gov_reb if e(sample);
local mean = r(mean);
outreg2 int* using tab9, tex replace pvalue bdec(3) tdec(3) nocons noni 
adds("Clusters", e(N_g), "Mean DV", `mean') ;
# delimit cr

*COLUMN 2

gen int3 = meanprice*ofsell
gen int4 = firstpriceh*ofsell

#delimit ;
xtreg gov_reb int3 int4 ofsell obyear* i.year, fe;
sum gov_reb if e(sample);
local mean = r(mean);
outreg2 int* using tab9, tex append pvalue bdec(3) tdec(3) nocons noni 
adds("Clusters", e(N_g), "Mean DV", `mean');
# delimit cr

*COLUMN 3

gen int5 = soldpc*ofsell

#delimit ;
xtreg gov_reb int5 ofsell obyear* i.year, fe;
sum gov_reb if e(sample);
local mean = r(mean);
outreg2 int* using tab9, tex append pvalue bdec(3) tdec(3) nocons noni 
adds("Clusters", e(N_g), "Mean DV", `mean');
# delimit cr

log close
