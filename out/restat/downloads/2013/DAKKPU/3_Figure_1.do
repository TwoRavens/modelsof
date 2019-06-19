clear

pause on

cd "C:\RESTAT"

use "SA.dta", clear
replace  bilsa2008= mfnsa2008 if bilsa2009==.& mfnsa2009~=.
replace  bilsa2009= mfnsa2009 if bilsa2009==.& mfnsa2009~=.
keep  ccode name bilsa2008 bilsa2009
rename ccode code
gen changeintariff=bilsa2009-bilsa2008
gen x=1
replace x=0.25
replace x=. if code~="AFG"
replace x=0 if code=="ARG"

drop if code=="FJI"

replace code="" if changeintariff<0 & change~=.
label var  bilsa2009 "Average Tariff in 2009"
label var bilsa2008 "Average Tariff in 2008"
gen pos=12
replace pos=11 if code=="MWI"
replace pos=9 if code=="BRA"
replace pos=9 if code=="ARG"
replace pos=11 if code=="KOR"
set scheme s2color
twoway  (scatter  bilsa2009 bilsa2008, mlabel("code") mlabv(pos) msize(small) mlabsize(vsmall) msymbol(circle_hollow)) (line x x), title(Simple Average Bilateral Tariffs in 2008 vs. 2009) legend(off) ytitle( "Average Tariff in 2009") xtitle("Average Tariff in 2008") graphregion(color(white))
