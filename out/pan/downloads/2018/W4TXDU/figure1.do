clear all

do "a_delta.do"

do "a_delta_z.do"

do "a_delta_wx.do"

do "a_delta_wy.do"

clear all

matrix bias_2sls = . 
matrix t_first = .
matrix delta = .

local i = 0
qui while `i' < 11 {
local a = `i'/10
use `a'_delta.dta, replace
replace b_2sls = b_2sls - 1
qui su b_2sls, de
matrix bias_2sls = ( bias_2sls \ r(p50)  ) 
qui su t_first, de
matrix t_first = ( t_first \ r(p50)  ) 
matrix delta = ( delta \ `a' )
local i = `i' + 1
}

drop _all

matrix bias_2sls_wx = . 
matrix t_first_wx = .
matrix delta_wx = .

local i = 0
qui while `i' < 11 {
local a = `i'/10
use `a'_delta_wx.dta, replace
replace b_2sls = b_2sls - 1
qui su b_2sls, de
matrix bias_2sls_wx = ( bias_2sls_wx \ r(p50) ) 
qui su t_first, de
matrix t_first_wx = ( t_first_wx \ r(p50)  ) 
matrix delta_wx = ( delta_wx \ `a' )
local i = `i' + 1
}

drop _all

matrix bias_2sls_wy = . 
matrix t_first_wy = .
matrix delta_wy = .

local i = 0
qui while `i' < 11 {
local a = `i'/10
use `a'_delta_wy.dta, replace
replace b_2sls = b_2sls - 1
qui su b_2sls, de
matrix bias_2sls_wy = ( bias_2sls_wy \ r(p50)  ) 
qui su t_first, de
matrix t_first_wy = ( t_first_wy \ r(p50)  ) 
matrix delta_wy = ( delta_wy \ `a' )
local i = `i' + 1
}

drop _all

matrix bias_2sls_z = . 
matrix t_first_z = .
matrix delta_z = .

local i = 0
qui while `i' < 11 {
local a = `i'/10
use `a'_delta_z.dta, replace
replace b_2sls = b_2sls - 1
qui su b_2sls, de
matrix bias_2sls_z = ( bias_2sls_z \ r(p50)  ) 
qui su t_first, de
matrix t_first_z = ( t_first_z \ r(p50)  ) 
matrix delta_z = ( delta_z \ `a' )
local i = `i' + 1
}

drop _all

set more off
svmat bias_2sls
svmat t_first
svmat delta

svmat bias_2sls_wx
svmat t_first_wx
svmat delta_wx

svmat bias_2sls_wy
svmat t_first_wy
svmat delta_wy

svmat bias_2sls_z
svmat t_first_z
svmat delta_z

twoway scatter bias_2sls1 delta1 || scatter bias_2sls_wx delta1 || scatter bias_2sls_wy delta1 || scatter bias_2sls_z delta1, subtitle("2SLS, median absolute bias", ring(1) box width(140)) scheme(lean1) ytitle("Bias") xtitle("Corr(u,e)") yline(0, lpattern(dash)) ylabel(0(.25).75) yscale(r(-.1,.75)) legend(size(small) order(4 "i.i.d. instrument" 1 "spatial instrument" 2 "spatial instrument" "& spatial outcome" 3 "Spatial instrument" "& spillovers")) xsize(6.5) ysize(4)
graph export "merged_median-bias.pdf", as(pdf) replace
