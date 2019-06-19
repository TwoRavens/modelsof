
set more off
clear all
version 13.1

**********************************************
***Final Code: Robust I-Satistical
**********************************************
***Alternative Measure of Firm-specific Tariff
*********************************************
use Merge.final.fpc.dta, clear
gen duty_int=duty_d*diff
reg price_d duty_d TFP_d K_L_d l_d wage_d N_d HHI i.year, cluster(FRDM)
est store reg07
reg price_d duty_d duty_int TFP_d K_L_d l_d wage_d N_d HHI i.year, cluster(FRDM)
est store reg08
drop duty_d duty_int
rename duty_un duty_d
gen duty_int=duty_d*diff
reg price_d duty_d TFP_d K_L_d l_d wage_d N_d HHI i.year, cluster(FRDM)
est store reg01
reg price_d duty_d duty_int TFP_d K_L_d l_d wage_d N_d HHI i.year, cluster(FRDM)
est store reg02
drop duty_d duty_int
rename duty_exo_d duty_d
gen duty_int=duty_d*diff
reg price_d duty_d TFP_d K_L_d l_d wage_d N_d HHI i.year, cluster(FRDM)
est store reg03
reg price_d duty_d duty_int TFP_d K_L_d l_d wage_d N_d HHI i.year, cluster(FRDM)
est store reg04
drop duty_d duty_int
rename duty_inter_d duty_d
gen duty_int=duty_d*diff
reg price_d duty_d TFP_d K_L_d l_d wage_d N_d HHI i.year, cluster(FRDM)
est store reg05
reg price_d duty_d duty_int TFP_d K_L_d l_d wage_d N_d HHI i.year, cluster(FRDM)
est store reg06
esttab reg01 reg02 reg03 reg04 reg05 reg06 reg07 reg08 using Table9A.tex, replace b(3) se(3) stats(N  r2 r2_a F p, fmt(%10.3g)) starlevels(* 0.1 ** 0.05 *** 0.01) keep(duty_d duty_int TFP_d K_L_d l_d wage_d N_d HHI) order(duty_d duty_int TFP_d)
esttab reg01 reg02 reg03 reg04 reg05 reg06 reg07 reg08 using Table9A.csv, replace b(3) se(3) stats(N  r2 r2_a F p, fmt(%10.3g)) starlevels(* 0.1 ** 0.05 *** 0.01) keep(duty_d duty_int TFP_d K_L_d l_d wage_d N_d HHI) order(duty_d duty_int TFP_d)

use Merge.final.fp.dta, clear
gen duty_int=duty_d*diff
reg price_d duty_d TFP_d K_L_d l_d wage_d N_d HHI i.year, cluster(FRDM)
est store reg07
reg price_d duty_d duty_int TFP_d K_L_d l_d wage_d N_d HHI i.year, cluster(FRDM)
est store reg08
drop duty_d duty_int
rename duty_un duty_d
gen duty_int=duty_d*diff
reg price_d duty_d TFP_d K_L_d l_d wage_d N_d HHI i.year, cluster(FRDM)
est store reg01
reg price_d duty_d duty_int TFP_d K_L_d l_d wage_d N_d HHI i.year, cluster(FRDM)
est store reg02
drop duty_d duty_int
rename duty_exo_d duty_d
gen duty_int=duty_d*diff
reg price_d duty_d TFP_d K_L_d l_d wage_d N_d HHI i.year, cluster(FRDM)
est store reg03
reg price_d duty_d duty_int TFP_d K_L_d l_d wage_d N_d HHI i.year, cluster(FRDM)
est store reg04
drop duty_d duty_int
rename duty_inter_d duty_d
gen duty_int=duty_d*diff
reg price_d duty_d TFP_d K_L_d l_d wage_d N_d HHI i.year, cluster(FRDM)
est store reg05
reg price_d duty_d duty_int TFP_d K_L_d l_d wage_d N_d HHI i.year, cluster(FRDM)
est store reg06
esttab reg01 reg02 reg03 reg04 reg05 reg06 reg07 reg08 using Table9B.tex, replace b(3) se(3) stats(N  r2 r2_a F p, fmt(%10.3g)) starlevels(* 0.1 ** 0.05 *** 0.01) keep(duty_d duty_int TFP_d K_L_d l_d wage_d N_d HHI) order(duty_d duty_int TFP_d)
esttab reg01 reg02 reg03 reg04 reg05 reg06 reg07 reg08 using Table9B.csv, replace b(3) se(3) stats(N  r2 r2_a F p, fmt(%10.3g)) starlevels(* 0.1 ** 0.05 *** 0.01) keep(duty_d duty_int TFP_d K_L_d l_d wage_d N_d HHI) order(duty_d duty_int TFP_d)

********************************************
***Industry Input/Output Tariff
*********************************************
use Merge.final.fpc.dta, clear
gen duty_int=duty_in_d*diff
gen duty_out_int=duty_out_d*diff
drop if price_d==.
reg price_d duty_out_d TFP_d K_L_d l_d wage_d N_d HHI i.year, cluster(HS6)
est store reg01
reg price_d duty_in_d TFP_d K_L_d l_d wage_d N_d HHI i.year, cluster(HS6)
est store reg02
reg price_d duty_in_d duty_out_d TFP_d K_L_d l_d wage_d N_d HHI i.year, cluster(HS6)
est store reg03
reg price_d duty_in_d duty_int TFP_d K_L_d l_d wage_d N_d HHI i.year, cluster(HS6)
est store reg04
*Product
use Merge.final.fp.dta, clear
gen duty_int=duty_in_d*diff
gen duty_out_int=duty_out_d*diff
drop if price_d==.
reg price_d duty_out_d TFP_d K_L_d l_d wage_d N_d HHI i.year, cluster(HS6)
est store reg05
reg price_d duty_in_d TFP_d K_L_d l_d wage_d N_d HHI i.year, cluster(HS6)
est store reg06
reg price_d duty_in_d duty_out_d TFP_d K_L_d l_d wage_d N_d HHI i.year, cluster(HS6)
est store reg07
reg price_d duty_in_d duty_int TFP_d K_L_d l_d wage_d N_d HHI i.year, cluster(HS6)
est store reg08
esttab reg01 reg02 reg03 reg04 reg05 reg06 reg07 reg08 using Table10.tex, replace b(3) se(3) stats(N  r2 r2_a F p, fmt(%10.3g)) starlevels(* 0.1 ** 0.05 *** 0.01) keep(duty_in_d duty_out_d duty_int)
esttab reg01 reg02 reg03 reg04 reg05 reg06 reg07 reg08 using Table10.csv, replace b(3) se(3) stats(N  r2 r2_a F p, fmt(%10.3g)) starlevels(* 0.1 ** 0.05 *** 0.01) keep(duty_in_d duty_out_d duty_int)

**********************************************
*Large Smaple using whole custom data
**********************************************

use custom.final.fpc.dta, clear
keep if N_d!=.
gen duty_int=duty_d*diff
xi: reg price_d duty_d duty_int i.year, cluster(company) 
est store reg01
drop duty_d duty_int
rename duty_un duty_d
gen duty_int=duty_d*diff
xi: reg price_d duty_d duty_int i.year, cluster(company) 
est store reg02
drop duty_d duty_int
rename duty_exo_d duty_d
gen duty_int=duty_d*diff
xi: reg price_d duty_d duty_int i.year, cluster(company) 
est store reg03
drop duty_d duty_int
rename duty_inter_d duty_d
gen duty_int=duty_d*diff
xi: reg price_d duty_d duty_int i.year, cluster(company) 
est store reg04
drop duty_d duty_int
rename duty_in_d duty_d
gen duty_int=duty_d*diff
xi: reg price_d duty_d duty_int i.year, cluster(company) 
est store reg05
esttab reg01 reg02 reg03 reg04 reg05 using Table11A.tex, replace b(3) se(3) stats(N  r2 r2_a F p, fmt(%10.3g)) starlevels(* 0.1 ** 0.05 *** 0.01) keep(duty_d duty_int)
esttab reg01 reg02 reg03 reg04 reg05 using Table11A.csv, replace b(3) se(3) stats(N  r2 r2_a F p, fmt(%10.3g)) starlevels(* 0.1 ** 0.05 *** 0.01) keep(duty_d duty_int)

use custom.final.fp.dta, clear
keep if N_d!=.
gen duty_int=duty_d*diff
xi: reg price_d duty_d duty_int i.year, cluster(company) 
est store reg01
drop duty_d duty_int
rename duty_un duty_d
gen duty_int=duty_d*diff
xi: reg price_d duty_d duty_int i.year, cluster(company) 
est store reg02
drop duty_d duty_int
rename duty_exo_d duty_d
gen duty_int=duty_d*diff
xi: reg price_d duty_d duty_int i.year, cluster(company) 
est store reg03
drop duty_d duty_int
rename duty_inter_d duty_d
gen duty_int=duty_d*diff
xi: reg price_d duty_d duty_int i.year, cluster(company) 
est store reg04
drop duty_d duty_int
rename duty_in_d duty_d
gen duty_int=duty_d*diff
xi: reg price_d duty_d duty_int i.year, cluster(company) 
est store reg05
esttab reg01 reg02 reg03 reg04 reg05 using Table11B.tex, replace b(3) se(3) stats(N  r2 r2_a F p, fmt(%10.3g)) starlevels(* 0.1 ** 0.05 *** 0.01) keep(duty_d duty_int)
esttab reg01 reg02 reg03 reg04 reg05 using Table11B.csv, replace b(3) se(3) stats(N  r2 r2_a F p, fmt(%10.3g)) starlevels(* 0.1 ** 0.05 *** 0.01) keep(duty_d duty_int)

*Figure: Firm-product-country
use custom.final.fpc.dta, clear
preserve
keep if year==2001|year==2006
keep year company HS6 coun_aim price diff
bysort company HS6 coun_aim: gen t=_N
keep if t==2
bysort company HS6 coun_aim: egen price_m=mean(price)
gen epison=price-price_m
bysort year: sum epison if diff==1, detail
bysort year: egen epison1=pctile(epison), p(2)
bysort year: egen epison2=pctile(epison), p(98)
keep if epison>=epison1&epison<=epison2
twoway (kdensity epison if year==2001&diff==1, lcolor(blue) lpattern(solid) lwidth(thick)) (kdensity epison if year==2006&diff==1, lcolor(red) lpattern(longdash) lwidth(thick)), xtitle("Export Price (HS6-Country)") ytitle("Density") legend(lab(1 "2001") lab(2 "2006"))
graph save price_exp_country_homo, replace
restore


preserve
keep if year==2001|year==2006
keep year company HS6 coun_aim price diff
bysort company HS6 coun_aim: gen t=_N
keep if t==2
bysort company HS6 coun_aim: egen price_m=mean(price)
gen epison=price-price_m
bysort year: sum epison if diff==0, detail
bysort year: egen epison1=pctile(epison), p(2)
bysort year: egen epison2=pctile(epison), p(98)
keep if epison>=epison1&epison<=epison2
twoway (kdensity epison if year==2001&diff==0, lcolor(blue) lpattern(solid) lwidth(thick)) (kdensity epison if year==2006&diff==0, lcolor(red) lpattern(longdash) lwidth(thick)), xtitle("Export Price (HS6-Country)") ytitle("Density") legend(lab(1 "2001") lab(2 "2006"))
graph save price_exp_country_diff, replace
restore

**********************************
*Figure: product level
use custom.final.fp.dta, clear
preserve
keep if year==2001|year==2006
keep year company HS6 price diff
bysort company HS6: gen t=_N
keep if t==2
bysort company HS6: egen price_m=mean(price)
gen epison=price-price_m
bysort year: sum epison if diff==1, detail
bysort year: egen epison1=pctile(epison), p(2)
bysort year: egen epison2=pctile(epison), p(98)
keep if epison>=epison1&epison<=epison2
twoway (kdensity epison if year==2001&diff==1, xlabel(-1(0.5)1) lcolor(blue) lpattern(solid) lwidth(thick)) (kdensity epison if year==2006&diff==1, lcolor(red) lpattern(longdash) lwidth(thick)), xtitle("Export Price (HS6)") ytitle("Density") legend(lab(1 "2001") lab(2 "2006"))
graph save price_exp_homo, replace
restore


preserve
keep if year==2001|year==2006
keep year company HS6 price diff
bysort company HS6: gen t=_N
keep if t==2
bysort company HS6: egen price_m=mean(price)
gen epison=price-price_m
bysort year: sum epison if diff==0, detail
bysort year: egen epison1=pctile(epison), p(2)
bysort year: egen epison2=pctile(epison), p(98)
keep if epison>=epison1&epison<=epison2
twoway (kdensity epison if year==2001&diff==0, xlabel(-1(0.5)1) lcolor(blue) lpattern(solid) lwidth(thick)) (kdensity epison if year==2006&diff==0, lcolor(red) lpattern(longdash) lwidth(thick)), xtitle("Export Price (HS6)") ytitle("Density") legend(lab(1 "2001") lab(2 "2006"))
graph save price_exp_diff, replace
restore

graph combine price_exp_diff.gph price_exp_country_diff.gph price_exp_homo.gph price_exp_country_homo.gph, cols(2)
graph save final_exp_diff_custom, replace // This is Figure 3

*********************************************
***Variable Markup
*********************************************
use Merge.final.fpc.dta, clear
reg price_d duty_d share_d TFP_d K_L_d l_d wage_d N_d HHI i.year, cluster(FRDM)
est store reg01
reg price_d duty_d share_d TFP_d K_L_d l_d wage_d N_d HHI i.year if diff==0, cluster(FRDM)
est store reg02
xi: ivreg2 price_d duty_d (share_d=duty00s) TFP_d K_L_d l_d wage_d N_d HHI i.year, cluster(FRDM) first
est store reg03
xi: ivreg2 price_d duty_d (share_d=duty00s) TFP_d K_L_d l_d wage_d N_d HHI i.year if diff==0, cluster(FRDM) first
est store reg04
xi: ivreg2 price_d duty_d (share_d=duty_ds) TFP_d K_L_d l_d wage_d N_d HHI i.year, cluster(FRDM) first
est store reg05
xi: ivreg2 price_d duty_d (share_d=duty_ds) TFP_d K_L_d l_d wage_d N_d HHI i.year if diff==0, cluster(FRDM) first
est store reg06
esttab reg01 reg02 reg03 reg04 reg05 reg06 using Table12A.tex, replace se(3) b(3) stats(N  r2 r2_a F p, fmt(%10.3g)) starlevels(* 0.1 ** 0.05 *** 0.01) keep(duty_d share_d TFP_d K_L_d l_d wage_d N_d HHI)
esttab reg01 reg02 reg03 reg04 reg05 reg06 using Table12A.csv, replace se(3) b(3) stats(N  r2 r2_a F p, fmt(%10.3g)) starlevels(* 0.1 ** 0.05 *** 0.01) keep(duty_d share_d TFP_d K_L_d l_d wage_d N_d HHI)

*************************************
use Merge.final.fpc.dta, clear
gen price_dmw=price_d-share_d/(5-1)
reg price_dmw duty_d TFP_d K_L_d l_d wage_d N_d HHI i.year, cluster(FRDM)
est store reg01
reg price_dmw duty_d TFP_d K_L_d l_d wage_d N_d HHI i.year if diff==0, cluster(FRDM)
est store reg02
gen price_dms=price_d-share_d/(10-1)
reg price_dms duty_d TFP_d K_L_d l_d wage_d N_d HHI i.year, cluster(FRDM)
est store reg03
reg price_dms duty_d TFP_d K_L_d l_d wage_d N_d HHI i.year if diff==0, cluster(FRDM)
est store reg04
gen price_dm=price_d-share_d/(sigma_m-1)
reg price_dm duty_d TFP_d K_L_d l_d wage_d N_d HHI i.year, cluster(FRDM)
est store reg05
reg price_dm duty_d TFP_d K_L_d l_d wage_d N_d HHI i.year if diff==0, cluster(FRDM)
est store reg06
esttab reg01 reg02 reg03 reg04 reg05 reg06 using Table12B.tex, replace se(3) b(3) stats(N  r2 r2_a F p, fmt(%10.3g)) starlevels(* 0.1 ** 0.05 *** 0.01) keep(duty_d TFP_d K_L_d l_d wage_d N_d HHI)
esttab reg01 reg02 reg03 reg04 reg05 reg06 using Table12B.csv, replace se(3) b(3) stats(N  r2 r2_a F p, fmt(%10.3g)) starlevels(* 0.1 ** 0.05 *** 0.01) keep(duty_d TFP_d K_L_d l_d wage_d N_d HHI)
