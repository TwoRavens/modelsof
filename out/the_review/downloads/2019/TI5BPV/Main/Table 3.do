*******************
***TABLE 3 PANEL A
*******************

capture log close
clear 
cd "C:\Users\jenny\Dropbox\Replication Office-selling\Main"
log using Table3, replace

use main_part1, clear

*COLUMN 1

gen int1 = rep50*cumwar
gen int2 = ldistlima*cumwar

#delimit ;
xtreg lrprice1 int* obyear1-obyear5 gov_reb i.year if audiencia=="Lima", fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int using  tab3A, tex replace pvalue bdec(3) tdec(3) nocons noni adds("Provinces", e(N_g), "Mean DV", `mean') addtext(District \& Year FE, Yes, Bishop Trends, Yes);
# delimit cr


*COLUMN 2

gen int3 = lz*cumwar

#delimit ;
xtreg lrprice1 int* obyear1-obyear5 gov_reb i.year if audiencia=="Lima", fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tab3A, tex append pvalue bdec(3) tdec(3) nocons noni adds("Provinces", e(N_g), "Mean DV", `mean') addtext(District \& Year FE, Yes, Bishop Trends, Yes);
# delimit cr


*COLUMN 3

use main_part1, clear

gen int1 = rep50*cumwar
gen int2 = ldistlima*cumwar
gen int3 = lz*cumwar
gen int4 = bishop*cumwar


#delimit ;
xtreg lrprice1 int* obyear1-obyear5 gov_reb i.year if audiencia=="Lima", fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tab3A, tex append pvalue bdec(3) tdec(3) nocons noni adds("Provinces", e(N_g), "Mean DV", `mean') addtext(District \& Year FE, Yes, Bishop Trends, Yes);
# delimit cr


*******************
***TABLE 3 PANEL B
*******************

use main_part1, clear

*COLUMN 1

gen int1 = rep50*cumwar 

#delimit ;
xtreg lrprice1 int* totalc obyear1-obyear5 i.year if audiencia=="Lima", fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tab3B, tex replace pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr

*COLUMN 2

#delimit ;
xtreg lrprice1 int* totalc gov_reb obyear1-obyear5 i.year if audiencia=="Lima", fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tab3B, tex append pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr

*COLUMN 3

#delimit ;
xtreg lrprice1 int* totalc obyear1-obyear5 gov_reb i.year, fe;
sum lrprice1 if e(sample);
local mean = r(mean);
outreg2 int* using  tab3B, tex append pvalue bdec(3) tdec(3) nocons noni 
adds("Provinces", e(N_g), "Mean DV", `mean');
# delimit cr

log close
