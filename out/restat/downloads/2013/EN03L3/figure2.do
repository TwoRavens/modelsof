*This file creates Figure 2
use "$output/regloop10end.dta", clear

preserve
keep if subgroup1==1

cap drop expvar
cap drop yhat0
cap drop yhat1
gen expvar=positive

*Check common support condition!
*number of points at which you graph the density
global B=500
*generate series of decimals from 0 to 1
gen x0=(_n-1)/($B-1)
summ expvar
summ pscore
replace x0=. if _n>$B
*focus support of graph on area with y-values~=0
replace x0=r(min)+x0*(r(max)-r(min))
count if pscore==.

*graphs
kdensity pscore if expvar==0, nograph
local h0=r(bwidth)
di `h0'
*forces bandwidth to be 1/4 the original size
local h=`h0'/4
kdensity pscore if expvar==0, nograph at(x0) gen(yhat0) width(`h')

kdensity pscore if expvar==1, nogr
local h1=r(bwidth)
di `h1'
local h=`h1'/4
kdensity pscore if expvar==1, nograph at(x0) gen(yhat1) width(`h')

lab var yhat0 HIVnegative
lab var yhat1 HIVpositive
twoway (line yhat0 yhat1 x0, clpat(dash) ytitle(Density) xtitle(Propensity Score))

graph export "$output/figure2.pdf", as(pdf) replace

