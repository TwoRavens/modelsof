clear all
set maxvar 30000
use FNIdataset, clear

gen postwar=(birthyear>=1917)   
gen inter=postwar*german
replace yrsusa1_pop=. if yrsusa1_pop==0
gen arrivalyr_pop=year-yrsusa1_pop

* drop if father was not in US when child was born
gen yrsusatbrth_pop=birthyear-arrivalyr_pop
drop if yrsusatbrth_pop<0

* regressions
estimates clear
reg FNI i.birthyear i.ethnicgroup inter, cluster(ethnicgroup)
eststo m1
reg FNI i.birthyear i.ethnicgroup inter if arrivalyr_pop!=., cluster(ethnicgroup)
eststo m2
reg FNI i.birthyear i.ethnicgroup i.arrivalyr_pop inter , cluster(ethnicgroup)
eststo m3

esttab m* using "TableD3.csv", star(* 0.1 ** 0.05 *** 0.01) replace	cells(b(fmt(a3) star) se(par)) stats(N r2) keep(inter) 
