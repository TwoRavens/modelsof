clear all
set maxvar 30000
use FNIdataset_women, clear

gen postwar=(birthyear>=1917)   
gen inter=postwar*german

* create linear trend 
sum birthyear, det
local minyear=r(min)
local maxyear=r(max)-r(min)
gen t=birthyear-`minyear'+1

drop if ethnicgroup==.

* deviation of index from ethnicity-specific pre-war trend
reg FNI i.ethnicgroup#c.t if birthyear<1914
predict res, res

* regressions
estimates clear
reg FNI postwar german inter, ro
eststo m1
reg FNI postwar german inter t, ro
eststo m2
reg FNI i.birthyear german inter t, ro
eststo m3
reg FNI i.birthyear i.ethnicgroup inter, cluster(ethnicgroup)
eststo m4
reg res i.birthyear i.ethnicgroup inter, cluster(ethnicgroup)
eststo m5
reg res i.birthyear i.ethnicgroup  i.bpl inter, cluster(ethnicgroup)
eststo m6

esttab m* using "TableD2.csv", star(* 0.1 ** 0.05 *** 0.01) replace ///
		cells(b(fmt(a3) star) se(par)) stats(N r2) keep(postwar german inter)
