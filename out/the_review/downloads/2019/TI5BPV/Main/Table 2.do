*******************
***TABLE 2 
*******************

capture log close
clear 
cd "C:\Users\jenny\Dropbox\Replication Office-selling\Main"
log using Table2, replace

use main_part1, clear

*Indicator for year immediately before a war

gen p1 = 0
replace p1 = 1 if yearfromwar==-1 
tab p1

*Indicator for two years immediately before a war

gen p2 = 0
replace p2 = 1 if yearfromwar==-2 
tab p2

*Indicator for three years immediately before a war

gen p3 = 0
replace p3 = 1 if yearfromwar==-3
tab p3 

*Indicator for four years immediately before a war

gen p4 = 0
replace p4 = 1 if yearfromwar<=-4
tab p4 


*Indicator for first year at war

gen w1 = 0
replace w1 = 1 if yearfromwar == 1
tab w1

*Indicator for two years at war

gen w2 = 0
replace w2 = 1 if yearfromwar == 2


*Indicator for three years at war

gen w3 = 0
replace w3 = 1 if yearfromwar == 3 

*Indicator for four years at war

gen w4 = 0
replace w4 = 1 if yearfromwar >= 4

*omitted category: p1, year immediately before a war

gen int2 = rep50*p4
gen int3 = rep50*p3
gen int4 = rep50*p2


gen int5 = rep50*w1
gen int6 = rep50*w2
gen int7 = rep50*w3
gen int8 = rep50*w4


*COLUMN 1

#delimit ;
xtreg lrprice1 int* obyear1-obyear5 i.year if audiencia=="Lima", fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tab2, tex replace pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr


*COLUMN 2

#delimit ;
xtreg lrprice1 int* obyear1-obyear5 gov_reb i.year if audiencia=="Lima", fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tab2, tex append pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr


*COLUMN 3

#delimit ;
xtreg lrprice1 int* obyear1-obyear5 gov_reb i.year, fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tab2, tex append pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr


log close
