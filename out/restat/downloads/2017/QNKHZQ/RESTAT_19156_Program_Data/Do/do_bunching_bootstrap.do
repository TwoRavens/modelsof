* Paper: "The Economics of Attribute-Based Regulation: Theory and Evidence from Fuel-Economy Standards"
* Authors: Koichiro Ito and James Sallee 
* Also see "readme.txt" file 

*********************
*** Analysis 
*********************

loc num_bootstrap = 100
foreach uniform in 0 1 {
foreach regime in  1 0 {
foreach kei in 0 1 {

* File write
cap file close dd
file open dd using "TableText/bootstrap`num_bootstrap'_bunching_uniform`uniform'_regime`regime'_kei`kei'.txt", replace write
file write dd "bootstrap"  _tab "notch" _tab "bunch" _tab "dw" _tab "bunch_num "

forval bootstrap = 1/`num_bootstrap' {

global regime = `regime'
global kei = `kei'

* Define global variables 
run Do/do_globalvariables.do 

use DataStata/bootstrap/regime`regime'_kei`kei'_b`bootstrap',clear
 
* Dummy variable for each notch point
foreach notch in $notchlist {
g d_eachnotchpoint_`notch' = weight==`notch'
}

* Left hand side variable for the regression
g lhs = obs

* Iteration process to satisfy the integration constraint
loc iteration = 1
loc adjustment = 0
loc diff_obs = -999
loc sign = 999

save $temp/temp,replace

* Iteration 
while abs(`diff_obs')>1 & `sign'>0 {

use $temp/temp,replace 
*use bsample1,clear

* Adjustment to correct the height of overestimated excess bunching
* I'll change this adjustment by a small increment to find a value that provides convergence of the numbers of observations
* between the actual data and the estimated counterfactual distribution  
if `iteration'~=0 & `diff_obs'<0 loc adjustment = `adjustment' + 0.001 
if `iteration'~=0 & `diff_obs'>0 loc adjustment = `adjustment' - 0.001 

* Fit a polynomial function
qui: xi:reg lhs weight_* if d_notch~=1
cap drop x1b
predict x1b ,xb

qui: save $temp/temp0,replace
* Save the observations that are above the final notch 
keep if weight>$final_notch
qui: save $temp/temp1_notchfinal,replace

* Work with each notch segment separately 
qui: foreach notch  in $notchlist {

use $temp/temp0,clear
keep if weight > ${lst_notch`notch'} & weight<=`notch' 

g original_excess_bunching = obs - x1b if weight==`notch'
qui: sum original_excess_bunching
local excess_bunching =  (1-`adjustment')*r(mean) 
drop original_excess_bunching 

if `excess_bunching'>0 {

if `uniform'==1 {
count if weight < `notch' & weight > ${lst_notch`notch'}
replace lhs = lhs + `excess_bunching'/r(N) if weight < `notch' & weight > ${lst_notch`notch'}
}

if `uniform'==0 {
* Calculate the height distance = x1b (predicted) - lhs (obverved) 
g d_height = x1b - lhs if weight < `notch' & weight > ${lst_notch`notch'}
replace d_height = -99999 if weight==`notch'

* Shift lhs upward to satisfy the integration constraint
forval i = 1/`excess_bunching' {
sort d_height
replace lhs = lhs + 1 if _n==_N & weight < `notch' & weight > ${lst_notch`notch'}
replace d_height = x1b - lhs if weight < `notch' & weight > ${lst_notch`notch'}
replace d_height = -99999 if weight==`notch'
}
drop d_height*
}

* if `excess_bunching'>0
}

g notchsegment = `notch'
g distance_to_notch = `notch'-weight
if `uniform'==1 loc uniform_distance_to_notch_`notch' = (`notch' - ${lst_notch`notch'})/2
qui: save $temp/temp1_notch`notch',replace

* each notch segment 
}

clear
foreach notch  in $notchlist final {
append using $temp/temp1_notch`notch'
}

* Fit a polynomial function
qui: reg lhs weight_* if d_notch~=1
cap drop x1b
predict x1b ,xb

* Calculate total number of observations for lhs and x1b
foreach x in obs x1b {
qui: sum `x'
loc ttl_`x' = r(mean)*r(N)
}
loc diff_obs = `ttl_obs'-`ttl_x1b'

dis "*** b = `bootstrap': adj = `adjustment': diff_obs = `diff_obs' (iteration = `iteration')"
loc sign_iteration`iteration' = sign(`diff_obs')
loc j = `iteration'-1
if `iteration'>1 loc sign = `sign_iteration`iteration''*`sign_iteration`j''
loc iteration = `iteration' + 1

* iteration
}

* Get estimates
order d_eachnotchpoint_* weight_*
reg lhs d_eachnotchpoint_* weight_* 
cap drop xb
predict xb ,xb
g num_buncher = max(0,xb - obs)

foreach notch in $notchlist {

loc bunch_num = _b[d_eachnotchpoint_`notch']
loc bunch = (_b[d_eachnotchpoint_`notch']+_b[_cons]+_b[weight_1]*`notch' + _b[weight_2]*(`notch'^2)+ _b[weight_3]*(`notch'^3) + _b[weight_4]*(`notch'^4) + _b[weight_5]*(`notch'^5)) / (_b[_cons]+_b[weight_1]*`notch' + _b[weight_2]*(`notch'^2) + _b[weight_3]*(`notch'^3)+ _b[weight_4]*(`notch'^4) + _b[weight_5]*(`notch'^5))

if `uniform'==0 sum distance_to_notch [aw=num_buncher] if notchsegment==`notch'
loc dw = r(mean)
if `uniform'==1 loc dw = `uniform_distance_to_notch_`notch'' 

file write dd _n (`bootstrap') _tab (`notch') _tab (`bunch') _tab (`dw') _tab (`bunch_num ')
}

* b = bootstrap
}

file close dd

*kei
}
*regime
}
*uniform
}


*** Save results 

loc num_bootstrap = 100
foreach uniform in 0 1 {
foreach regime in  1 0 {
foreach kei in 0 1 {

insheet using "TableText/bootstrap`num_bootstrap'_bunching_uniform`uniform'_regime`regime'_kei`kei'.txt",clear
collapse (sd) bunch_num bunch dw,by(notch)
save TableText/se_bunching_uniform`uniform'_regime`regime'_kei`kei',replace
}
}
}




*** END
