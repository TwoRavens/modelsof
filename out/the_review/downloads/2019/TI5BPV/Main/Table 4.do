*******************
***TABLE 4 PANEL A
*******************

capture log close
clear 
cd "C:\Users\jenny\Dropbox\Replication Office-selling\Main"
log using Table4, replace


use main_part1, clear

*Conditioning on sold offices

keep if appoint==0

gen int1 = rep50*cumwar

*COLUMN 1

#delimit ;
xtreg noble int* obyear1-obyear5 gov_reb i.year, fe;
sum noble if e(sample);
local mean = r(mean);
outreg2 int*  using  tab4, tex replace pvalue bdec(3) tdec(3) nocons  noni 
adds("Clusters", e(N_g), "Mean DV", `mean');
# delimit cr

*COLUMN 2

#delimit ;
xtreg orden int* obyear1-obyear5 gov_reb i.year, fe;
sum orden if e(sample);
local mean = r(mean);
outreg2 int* using  tab4, tex append pvalue bdec(3) tdec(3) nocons  noni 
adds("Clusters", e(N_g), "Mean DV", `mean');
# delimit cr

*COLUMN 3

#delimit ;
xtreg military int* obyear1-obyear5 gov_reb i.year, fe;
sum military if e(sample);
local mean = r(mean);
outreg2 int* using  tab4, tex append pvalue bdec(3) tdec(3) nocons  noni 
adds("Clusters", e(N_g), "Mean DV", `mean');
# delimit cr

log close
