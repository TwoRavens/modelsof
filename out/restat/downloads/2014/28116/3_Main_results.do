clear all
version 13.1
**********************************************
***Table 4: Imported Tariff and Exported Price
*********************************************
use Merge.final.fpc.dta, clear
drop if wage_d==.|N_d==.
reg price_d duty_d i.year, cluster(FRDM)
est store reg01
reg price_d duty_d TFP_d K_L_d l_d wage_d N_d i.year, cluster(FRDM)
est store reg02
reg price_d duty_d TFP_d K_L_d l_d wage_d N_d HHI i.year, cluster(FRDM)
est store reg03

use Merge.final.fp.dta, clear
reg price_d duty_d i.year if wage_d!=.&N_d!=., cluster(FRDM)
est store reg04
reg price_d duty_d TFP_d K_L_d l_d wage_d N_d i.year, cluster(FRDM)
est store reg05
reg price_d duty_d TFP_d K_L_d l_d wage_d N_d HHI i.year, cluster(FRDM)
est store reg06
duplicates drop year FRDM, force
reg pi_d duty_d i.year if wage_d!=.&N_d!=., cluster(FRDM)
est store reg07
reg pi_d duty_d TFP_d K_L_d l_d wage_d N_d i.year, cluster(FRDM)
est store reg08
reg pi_d duty_d TFP_d K_L_d l_d wage_d N_d HHI i.year, cluster(FRDM)
est store reg09
esttab reg01 reg02 reg03 reg04 reg05 reg06 reg07 reg08 reg09 using Table4.tex, replace se(3) b(3) stats(N  r2 r2_a F p, fmt(%10.3g)) starlevels(* 0.1 ** 0.05 *** 0.01) keep(duty_d TFP_d K_L_d l_d wage_d N_d HHI)
esttab reg01 reg02 reg03 reg04 reg05 reg06 reg07 reg08 reg09 using Table4.csv, replace se(3) b(3) stats(N  r2 r2_a F p, fmt(%10.3g)) starlevels(* 0.1 ** 0.05 *** 0.01) keep(duty_d TFP_d K_L_d l_d wage_d N_d HHI)

***************************************
*Imported Tariff and Exported Quality
***************************************
use Merge.final.fpc.dta, clear
drop if wage_d==.|N_d==.
reg quality5_d duty_d i.year, cluster(FRDM)
est store reg01
reg quality5_d duty_d TFP_d K_L_d l_d wage_d N_d HHI i.year, cluster(FRDM)
est store reg02
reg quality10_d duty_d i.year, cluster(FRDM)
est store reg03
reg quality10_d duty_d TFP_d K_L_d l_d wage_d N_d HHI i.year, cluster(FRDM)
est store reg04
reg quality_d duty_d i.year, cluster(FRDM)
est store reg05
reg quality_d duty_d TFP_d K_L_d l_d wage_d N_d HHI i.year, cluster(FRDM)
est store reg06
esttab reg01 reg02 reg03 reg04 reg05 reg06 using Table5.tex, replace se(3) b(3) stats(N  r2 r2_a F p, fmt(%10.3g)) starlevels(* 0.1 ** 0.05 *** 0.01) keep(duty_d TFP_d K_L_d l_d wage_d N_d HHI)
esttab reg01 reg02 reg03 reg04 reg05 reg06 using Table5.csv, replace se(3) b(3) stats(N  r2 r2_a F p, fmt(%10.3g)) starlevels(* 0.1 ** 0.05 *** 0.01) keep(duty_d TFP_d K_L_d l_d wage_d N_d HHI)


***************************************
*Role of Quality Differentiation
***************************************
use Merge.final.fpc.dta, clear
drop if wage_d==.
drop if N_d==.
gen duty_int=duty_d*diff
reg price_d duty_d TFP_d K_L_d l_d wage_d N_d HHI i.year if diff==0, cluster(FRDM)
est store reg01
reg price_d duty_d TFP_d K_L_d l_d wage_d N_d HHI i.year if diff==1, cluster(FRDM)
est store reg02
reg price_d duty_d duty_int TFP_d K_L_d l_d wage_d N_d HHI i.year, cluster(FRDM)
est store reg03
reg quality_d duty_d TFP_d K_L_d l_d wage_d N_d HHI i.year if diff==0, cluster(FRDM)
est store reg04
reg quality_d duty_d TFP_d K_L_d l_d wage_d N_d HHI i.year if diff==1, cluster(FRDM)
est store reg05
reg quality_d duty_d duty_int TFP_d K_L_d l_d wage_d N_d HHI i.year, cluster(FRDM)
est store reg06

use Merge.final.fp.dta, clear
drop if wage_d==.
drop if N_d==.
gen duty_int=duty_d*diff
reg price_d duty_d TFP_d K_L_d l_d wage_d N_d HHI i.year if diff==0, cluster(FRDM)
est store reg07
reg price_d duty_d TFP_d K_L_d l_d wage_d N_d HHI i.year if diff==1, cluster(FRDM)
est store reg08
reg price_d duty_d duty_int TFP_d K_L_d l_d wage_d N_d HHI i.year, cluster(FRDM)
est store reg09

esttab reg01 reg02 reg03 reg04 reg05 reg06 reg07 reg08 reg09 using Table6A.tex, replace b(3) se(3) stats(N  r2 r2_a F p, fmt(%10.3g)) starlevels(* 0.1 ** 0.05 *** 0.01) keep(duty_d duty_int TFP_d K_L_d l_d wage_d N_d HHI) order(duty_d duty_int TFP_d)
esttab reg01 reg02 reg03 reg04 reg05 reg06 reg07 reg08 reg09 using Table6A.csv, replace b(3) se(3) stats(N  r2 r2_a F p, fmt(%10.3g)) starlevels(* 0.1 ** 0.05 *** 0.01) keep(duty_d duty_int TFP_d K_L_d l_d wage_d N_d HHI) order(duty_d duty_int TFP_d)


use Merge.final.fpc.dta, clear
drop if wage_d==.
drop if N_d==.
egen var1=pctile(var), p(50)
gen index=0 if var>var1
replace index=1 if index==.
gen duty_int=duty_d*index
reg price_d duty_d TFP_d K_L_d l_d wage_d N_d HHI i.year if index==0, cluster(FRDM)
est store reg01
reg price_d duty_d TFP_d K_L_d l_d wage_d N_d HHI i.year if index==1, cluster(FRDM)
est store reg02
reg price_d duty_d duty_int TFP_d K_L_d l_d wage_d N_d HHI i.year, cluster(FRDM)
est store reg03
reg quality_d duty_d TFP_d K_L_d l_d wage_d N_d HHI i.year if index==0, cluster(FRDM)
est store reg04
reg quality_d duty_d TFP_d K_L_d l_d wage_d N_d HHI i.year if index==1, cluster(FRDM)
est store reg05
reg quality_d duty_d duty_int TFP_d K_L_d l_d wage_d N_d HHI i.year, cluster(FRDM)
est store reg06

use Merge.final.fp.dta, clear
drop if wage_d==.
drop if N_d==.
egen var1=pctile(var), p(50)
gen index=0 if var>var1
replace index=1 if index==.
gen duty_int=duty_d*index
reg price_d duty_d TFP_d K_L_d l_d wage_d N_d HHI i.year if index==0, cluster(FRDM)
est store reg07
reg price_d duty_d TFP_d K_L_d l_d wage_d N_d HHI i.year if index==1, cluster(FRDM)
est store reg08
reg price_d duty_d duty_int TFP_d K_L_d l_d wage_d N_d HHI i.year, cluster(FRDM)
est store reg09

esttab reg01 reg02 reg03 reg04 reg05 reg06 reg07 reg08 reg09 using Table6B.tex, replace b(3) se(3) stats(N  r2 r2_a F p, fmt(%10.3g)) starlevels(* 0.1 ** 0.05 *** 0.01) keep(duty_d duty_int TFP_d K_L_d l_d wage_d N_d HHI) order(duty_d duty_int TFP_d)
esttab reg01 reg02 reg03 reg04 reg05 reg06 reg07 reg08 reg09 using Table6B.csv, replace b(3) se(3) stats(N  r2 r2_a F p, fmt(%10.3g)) starlevels(* 0.1 ** 0.05 *** 0.01) keep(duty_d duty_int TFP_d K_L_d l_d wage_d N_d HHI) order(duty_d duty_int TFP_d)

use Merge.final.fpc.dta, clear
drop if wage_d==.
drop if N_d==.
drop if GK_ind==.
bysort year: egen GK_indm=pctile(GK_ind), p(50)
gen index=0 if GK_ind>=GK_indm
replace index=1 if index==.
gen duty_int=duty_d*index
reg price_d duty_d TFP_d K_L_d l_d wage_d N_d HHI i.year if index==0, cluster(FRDM)
est store reg01
reg price_d duty_d TFP_d K_L_d l_d wage_d N_d HHI i.year if index==1, cluster(FRDM)
est store reg02
reg price_d duty_d duty_int TFP_d K_L_d l_d wage_d N_d HHI i.year, cluster(FRDM)
est store reg03
reg quality_d duty_d TFP_d K_L_d l_d wage_d N_d HHI i.year if index==0, cluster(FRDM)
est store reg04
reg quality_d duty_d TFP_d K_L_d l_d wage_d N_d HHI i.year if index==1, cluster(FRDM)
est store reg05
reg quality_d duty_d duty_int TFP_d K_L_d l_d wage_d N_d HHI i.year, cluster(FRDM)
est store reg06

use Merge.final.fp.dta, clear
drop if wage_d==.
drop if N_d==.
drop if GK_ind==.
bysort year: egen GK_indm=pctile(GK_ind), p(50)
gen index=0 if GK_ind>=GK_indm
replace index=1 if index==.
gen duty_int=duty_d*index
reg price_d duty_d TFP_d K_L_d l_d wage_d N_d HHI i.year if index==0, cluster(FRDM)
est store reg07
reg price_d duty_d TFP_d K_L_d l_d wage_d N_d HHI i.year if index==1, cluster(FRDM)
est store reg08
reg price_d duty_d duty_int TFP_d K_L_d l_d wage_d N_d HHI i.year, cluster(FRDM)
est store reg09

esttab reg01 reg02 reg03 reg04 reg05 reg06 reg07 reg08 reg09 using Table6C.tex, replace b(3) se(3) stats(N  r2 r2_a F p, fmt(%10.3g)) starlevels(* 0.1 ** 0.05 *** 0.01) keep(duty_d duty_int TFP_d K_L_d l_d wage_d N_d HHI) order(duty_d duty_int TFP_d)
esttab reg01 reg02 reg03 reg04 reg05 reg06 reg07 reg08 reg09 using Table6C.csv, replace b(3) se(3) stats(N  r2 r2_a F p, fmt(%10.3g)) starlevels(* 0.1 ** 0.05 *** 0.01) keep(duty_d duty_int TFP_d K_L_d l_d wage_d N_d HHI) order(duty_d duty_int TFP_d)


***************************************
*Extensive Margin
***************************************
use Merge.final.fp.dta, clear
sort pairdummy year
tsset pairdummy year
bysort pairdummy: gen price_dd=price-l5.price
gen indexp=0 if price_d!=.
replace indexp=0 if price_dd!=.
keep year FRDM HS6 indexp
duplicates drop year FRDM HS6, force
save Merge.Export.firm-product.final.d.index.dta, replace

use Merge.final.fpc.dta, clear
sort pairdummy year
tsset pairdummy year
bysort pairdummy: gen price_dd=price-l5.price
gen index=0 if price_d!=.
replace index=0 if price_dd!=.
sort year FRDM HS6
merge m:1 year FRDM HS6 using Merge.Export.firm-product.final.d.index.dta
keep if _merge==3
drop _merge
replace index=1 if indexp==0&index==.
sum price if year==2001&index==0, detail
sum price if year==2001&index==1, detail
sum price if year==2006&index==0, detail
sum price if year==2006&index==1, detail

***************************************
****Table 8
***************************************
preserve
drop if index==.
egen value1=sum(value), by(year FRDM HS6 index)
egen quant1=sum(quant), by(year FRDM HS6 index)
duplicates drop year FRDM HS6 index, force
drop price value quant
rename value1 value 
rename quant1 quant
gen price=log(value/quant)
drop TFP_d K_L_d l_d wage_d N_d price_d pairdummy
egen pairdummy=group(FRDM HS6 index)
replace value=log(value)
sort pairdummy year
tsset pairdummy year
bysort pairdummy: gen N_d=f5.N_imp-N_imp
bysort pairdummy: gen TFP_d=f5.TFP-TFP
bysort pairdummy: gen K_L_d=f5.K_L-K_L 
bysort pairdummy: gen wage_d=f5.wage-wage
bysort pairdummy: gen l_d=f5.l-l
bysort pairdummy: gen price_d=f5.price-price 
****The last two columns in table 7:
bysort index: sum price_d, detail
keep if wage_d!=.&N_d!=.
reg price_d duty_d TFP_d K_L_d l_d wage_d N_d HHI i.year if index==0, cluster(FRDM)
est store reg01
reg price_d duty_d TFP_d K_L_d l_d wage_d N_d HHI i.year if index==1, cluster(FRDM)
est store reg02
reg price_d duty_d TFP_d K_L_d l_d wage_d N_d HHI i.year if index==0&diff==0, cluster(FRDM)
est store reg03
reg price_d duty_d TFP_d K_L_d l_d wage_d N_d HHI i.year if index==1&diff==0, cluster(FRDM)
est store reg04
reg price_d duty_d TFP_d K_L_d l_d wage_d N_d HHI i.year if index==0&diff==1, cluster(FRDM)
est store reg05
reg price_d duty_d TFP_d K_L_d l_d wage_d N_d HHI i.year if index==1&diff==1, cluster(FRDM)
est store reg06
restore
esttab reg01 reg02 reg03 reg04 reg05 reg06 using Table.mechanism.price.fp.tex, replace se(3) b(3) stats(N  r2 r2_a F p, fmt(%10.3g)) starlevels(* 0.1 ** 0.05 *** 0.01) keep(duty_d TFP_d K_L_d l_d wage_d N_d HHI)
esttab reg01 reg02 reg03 reg04 reg05 reg06 using Table.mechanism.price.fp.csv, replace se(3) b(3) stats(N  r2 r2_a F p, fmt(%10.3g)) starlevels(* 0.1 ** 0.05 *** 0.01) keep(duty_d TFP_d K_L_d l_d wage_d N_d HHI)












































