*******************
***TABLE 1 PANEL A
*******************

capture log close
clear 
cd "C:\Users\jenny\Dropbox\Replication Office-selling\Main"
log using Table1, replace


*Column 1

use main_part1, clear

gen int1 = rep50*cumwar

#delimit ;
xtreg lrprice1 int1 obyear1-obyear5 i.year if audiencia=="Lima", fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tab1A, tex replace pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean') ;
# delimit cr


*Column 2 

use main_part1, clear

gen int1 = rep50*cumwar

#delimit ;
xtreg lrprice1 int* obyear1-obyear5 gov_reb i.year if audiencia=="Lima", fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tab1A, tex append pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr


*Column 3

use main_part1, clear

gen int1 = rep50*cumwar

#delimit ;
xtreg lrprice1 int* obyear1-obyear5 gov_reb i.year, fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tab1A, tex append pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr



*******************
***TABLE 1 PANEL B
*******************

*Column 1


use main_part1, clear

gen int1 = rep50*war

#delimit ;
xtreg lrprice1 int* obyear1-obyear5 i.year if audiencia=="Lima", fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tab1B, tex replace pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr

keep if audiencia=="Lima"


*Column 2

use main_part1, clear

gen int1 = rep50*war

#delimit ;
xtreg lrprice1 int* obyear1-obyear5 gov_reb i.year if audiencia=="Lima", fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tab1B, tex append pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr

*Column 3

use main_part1, clear

gen int1 = rep50*war


#delimit ;
xtreg lrprice1 int* obyear1-obyear5 gov_reb i.year, fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tab1B, tex append pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr


*******************
***TABLE 1 PANEL C
*******************

*Column 1

use main_part1, clear

gen int1 = lreparto2*cumwar

#delimit ;
xtreg lrprice1 int* obyear1-obyear5 i.year if audiencia=="Lima", fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tab1C, tex replace pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr


*Column 2

use main_part1, clear

gen int1 = lreparto2*cumwar

#delimit ;
xtreg lrprice1 int* obyear1-obyear5 gov_reb i.year if audiencia=="Lima", fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tab1C, tex append pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr


*Column 3 

use main_part1, clear

gen int1 = lreparto2*cumwar

#delimit ;
xtreg lrprice1 int* obyear1-obyear5 gov_reb i.year, fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tab1C, tex append pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr



log close

