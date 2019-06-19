set more off
clear all
version 13.1

************************************************
*Table 1 and Figure 1
** Note: fp denotes firm-product; fpc denotes firm-product-country
***********************************************
*table:
use Merge.final.fp.dta, clear // firm-product
bysort year: sum price, detail
sum price_d, detail

use Merge.final.fpc.dta, clear // firm-product-country
bysort year: sum price, detail
sum price_d, detail

*****************
*Figure
use Merge.final.fp.dta, clear
keep if year==2001|year==2006
keep year FRDM HS6 quant price diff
bysort FRDM HS6: gen t=_N
keep if t==2

bysort year: sum price, detail
bysort FRDM HS6: egen price_m=mean(price)
gen epison=price-price_m
bysort year: egen epison1=pctile(epison), p(2)
bysort year: egen epison2=pctile(epison), p(98)
keep if epison>=epison1&epison<=epison2
twoway (kdensity epison if year==2001, xlabel(-1(0.5)1) ylabel(0(0.5)1.5) lcolor(blue) lpattern(solid) lwidth(thick)) (kdensity epison if year==2006, lcolor(red) lpattern(longdash) lwidth(thick)), xtitle("Export Price (HS6)") ytitle("Density") legend(lab(1 "2001") lab(2 "2006"))
graph save price_exp, replace

use Merge.final.fpc.dta, clear
keep if year==2001|year==2006
keep year FRDM HS6 coun_aim price diff
bysort FRDM HS6 coun_aim: gen t=_N
keep if t==2

bysort year: sum price, detail
bysort FRDM HS6 coun_aim: egen price_m=mean(price)
gen epison=price-price_m
bysort year: egen epison1=pctile(epison), p(2)
bysort year: egen epison2=pctile(epison), p(98)
keep if epison>=epison1&epison<=epison2
twoway (kdensity epison if year==2001, xlabel(-1 (0.5)1) ylabel(0(0.5)1.5) lcolor(blue) lpattern(solid) lwidth(thick)) (kdensity epison if year==2006, lcolor(red) lpattern(longdash) lwidth(thick)), xtitle("Export Price (HS6-Country)") ytitle("Density") legend(lab(1 "2001") lab(2 "2006"))
graph save price_exp_country, replace

graph combine price_exp.gph price_exp_country.gph
graph save final_HS, replace // this is Figure 1



************************************************
*Table 2 and Figure 2
***********************************************
*table:
use Merge.final.fp.dta, clear
sum price_d, detail
bysort diff: sum price_d, detail

use Merge.final.fpc.dta, clear
sum price_d, detail
bysort diff: sum price_d, detail

******************************
*Figure
use Merge.final.fp.dta, clear
keep if year==2001|year==2006
keep year FRDM HS6 quant price diff
bysort FRDM HS6: gen t=_N
keep if t==2

preserve 
bysort year: sum price, detail
bysort FRDM HS6: egen price_m=mean(price)
gen epison=price-price_m
bysort year: egen epison1=pctile(epison), p(2)
bysort year: egen epison2=pctile(epison), p(98)
keep if epison>=epison1&epison<=epison2
twoway (kdensity epison if year==2001&diff==1, xlabel(-1(0.5)1) lcolor(blue) lpattern(solid) lwidth(thick)) (kdensity epison if year==2006&diff==1, lcolor(red) lpattern(longdash) lwidth(thick)), xtitle("Export Price (HS6)") ytitle("Density") legend(lab(1 "2001") lab(2 "2006"))
graph save price_exp_homo, replace
restore

preserve 
bysort year: sum price, detail
bysort FRDM HS6: egen price_m=mean(price)
gen epison=price-price_m
bysort year: egen epison1=pctile(epison), p(2)
bysort year: egen epison2=pctile(epison), p(98)
keep if epison>=epison1&epison<=epison2
twoway (kdensity epison if year==2001&diff==0, xlabel(-1(0.5)1) ylabel(0(0.5)1.5) lcolor(blue) lpattern(solid) lwidth(thick)) (kdensity epison if year==2006&diff==0, lcolor(red) lpattern(longdash) lwidth(thick)), xtitle("Export Price (HS6)") ytitle("Density") legend(lab(1 "2001") lab(2 "2006"))
graph save price_exp_diff, replace
restore

*product--country
use Merge.final.fpc.dta, clear
keep if year==2001|year==2006
keep year FRDM HS6 coun_aim price diff
bysort FRDM HS6 coun_aim: gen t=_N
keep if t==2

preserve
bysort year: sum price, detail
bysort FRDM HS6 coun_aim: egen price_m=mean(price)
gen epison=price-price_m
bysort year: egen epison1=pctile(epison), p(2)
bysort year: egen epison2=pctile(epison), p(98)
keep if epison>=epison1&epison<=epison2
twoway (kdensity epison if year==2001&diff==1, xlabel(-1 (0.5)1) lcolor(blue) lpattern(solid) lwidth(thick)) (kdensity epison if year==2006&diff==1, lcolor(red) lpattern(longdash) lwidth(thick)), xtitle("Export Price (HS6-Country)") ytitle("Density") legend(lab(1 "2001") lab(2 "2006"))
graph save price_exp_country_homo, replace
restore

preserve
bysort year: sum price, detail
bysort FRDM HS6 coun_aim: egen price_m=mean(price)
gen epison=price-price_m
bysort year: egen epison1=pctile(epison), p(2)
bysort year: egen epison2=pctile(epison), p(98)
keep if epison>=epison1&epison<=epison2
twoway (kdensity epison if year==2001&diff==0, xlabel(-1 (0.5)1) ylabel(0(0.5)1.5) lcolor(blue) lpattern(solid) lwidth(thick)) (kdensity epison if year==2006&diff==0, lcolor(red) lpattern(longdash) lwidth(thick)), xtitle("Export Price (HS6-Country)") ytitle("Density") legend(lab(1 "2001") lab(2 "2006"))
graph save price_exp_country_diff, replace
restore

graph combine price_exp_diff.gph price_exp_country_diff.gph price_exp_homo.gph price_exp_country_homo.gph 
graph save final_exp_diff_Merge, replace  // this is Figure 2
*********************************
*Table 3
**********************************
use tariff.MNF_applied_rate.HS6.dta, clear
tsset HS6 year
bysort HS6: gen duty_d5=f5.duty-duty
sum duty_d5
gen HS4=floor(HS6/100)
gen HS2=floor(HS6/10000)
bysort year HS4: egen duty1=mean(duty)
bysort year HS2: egen duty2=mean(duty)
duplicates drop year HS4, force
tsset HS4 year
bysort HS4: gen duty1_d5=f5.duty1-duty1
sum duty1_d5
duplicates drop year HS2, force
tsset HS2 year
bysort HS2: gen duty2_d5=f5.duty2-duty2
sum duty2_d5


use Merge.final.fpc.dta, clear
keep if N_d!=.&wage_d!=.
duplicates drop year FRDM, force
sum duty_d duty_un duty_exo_d duty_inter_d 
