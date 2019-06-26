use "ToRegressionModels.dta", clear
gen singlemale = (total==1) & (females==0)
gen py = PY-1964

*xi: nbreg citations i.py peace war conflict violen singlemale 
*xi: nbreg citations i.peace*i.py war conflict violen singlemale 
*xi: nbreg citations peace i.war*py conflict violen singlemale 
*xi: nbreg citations peace war i.conflict*py violen singlemale 
*xi: nbreg citations peace war conflict i.violen*py singlemale 

xi i.peace*i.py
drop _IpeaXpy_1_1
drop _IpeaXpy_1_23
capture drop b*
estsimp nbreg citations _I* war conflict violen singlemale

setx war 0
setx conflict 0
setx violen 0
setx singlemale 0
capture drop i
gen i = _n
capture drop peace_cnt 
capture drop nonpeace_cnt
gen peace_cnt = .
gen nonpeace_cnt = .
forvalues i = 1(1)48 {
	setx _I* 0
	setx _Ipy_`i' 1
	setx _Ipeace_1 1
	capture setx _IpeaXpy_1_`i' 1
	*setx
	capture drop ev
	simqi, genev(ev)
	*sum ev
	_pctile ev, p(5, 50, 95)
	replace peace_cnt = `r(r2)' if _n == `i'
	setx _I* 0
	setx _Ipy_`i' 1
	setx _Ipeace_1 0
	capture drop ev
	simqi, genev(ev)
	*sum ev
	_pctile ev, p(5, 50, 95)
	replace nonpeace_cnt = `r(r2)' if _n == `i'
	*scatterreplace peace = peace - nonpeace
}
gen peace_diff = peace_cnt - nonpeace_cnt
keep peace_diff i
drop if peace_diff == .
sort i
save "peacediff.dta", replace


use "ToRegressionModels.dta", clear
gen singlemale = (total==1) & (females==0)
gen py = PY-1964

xi i.war*i.py
capture drop _IwarXpy_1_6
capture drop b*
estsimp nbreg citations _I* peace conflict violen singlemale

setx peace 0
setx conflict 0
setx violen 0
setx singlemale 0
capture drop i
gen i = _n
capture drop war_cnt 
capture drop nonwar_cnt
gen war_cnt = .
gen nonwar_cnt = .
forvalues i = 1(1)48 {
	setx _I* 0
	setx _Ipy_`i' 1
	setx _Iwar_1 1
	capture setx _IwarXpy_1_`i' 1
	*setx
	capture drop ev
	simqi, genev(ev)
	*sum ev
	_pctile ev, p(5, 50, 95)
	replace war_cnt = `r(r2)' if _n == `i'
	setx _I* 0
	setx _Ipy_`i' 1
	setx _Iwar_1 0
	capture drop ev
	simqi, genev(ev)
	*sum ev
	_pctile ev, p(5, 50, 95)
	replace nonwar_cnt = `r(r2)' if _n == `i'
	*scatterreplace peace = peace - nonpeace
}
gen war_diff = war_cnt - nonwar_cnt
keep war_diff i
drop if war_diff == .
sort i
save "wardiff.dta", replace

use "ToRegressionModels.dta", clear
gen singlemale = (total==1) & (females==0)
gen py = PY-1964

xi i.conflict*i.py
capture drop _IconXpy_1_8
capture drop _IconXpy_1_10
capture drop b*
estsimp nbreg citations _I* peace war violen singlemale

setx peace 0
setx war 0
setx violen 0
setx singlemale 0
capture drop i
gen i = _n
capture drop con_cnt 
capture drop noncon_cnt 
gen con_cnt  = .
gen noncon_cnt  = .
forvalues i = 1(1)48 {
	setx _I* 0
	setx _Ipy_`i' 1
	setx _Iconflict_1 1
	capture setx _IconXpy_1_`i' 1
	*setx
	capture drop ev
	simqi, genev(ev)
	*sum ev
	_pctile ev, p(5, 50, 95)
	replace con_cnt = `r(r2)' if _n == `i'
	setx _I* 0
	setx _Ipy_`i' 1
	setx _Iconflict_1 0
	capture drop ev
	simqi, genev(ev)
	*sum ev
	_pctile ev, p(5, 50, 95)
	replace noncon_cnt = `r(r2)' if _n == `i'
	*scatterreplace peace = peace - nonpeace
}

gen con_diff = con_cnt - noncon_cnt
keep con_diff i
drop if con_diff == .
sort i
save "condiff.dta", replace

use "ToRegressionModels.dta", clear
gen singlemale = (total==1) & (females==0)
gen py = PY-1964

xi i.violen*i.py
capture drop _IvioXpy_1_2
capture drop _IvioXpy_1_3
capture drop _IvioXpy_1_4
capture drop _IvioXpy_1_11
capture drop _IvioXpy_1_16
capture drop _IvioXpy_1_23
capture drop b*
estsimp nbreg citations _I* peace war conflict singlemale

setx peace 0
setx war 0
setx conflict 0
setx singlemale 0
capture drop i
gen i = _n
capture drop vio_cnt 
capture drop nonvio_cnt 
gen vio_cnt  = .
gen nonvio_cnt  = .
forvalues i = 1(1)48 {
	setx _I* 0
	setx _Ipy_`i' 1
	setx _Iviolen_1 1
	capture setx _IvioXpy_1_`i' 1
	*setx
	capture drop ev
	simqi, genev(ev)
	*sum ev
	_pctile ev, p(5, 50, 95)
	replace vio_cnt = `r(r2)' if _n == `i'
	setx _I* 0
	setx _Ipy_`i' 1
	setx _Iviolen_1 0
	capture drop ev
	simqi, genev(ev)
	*sum ev
	_pctile ev, p(5, 50, 95)
	replace nonvio_cnt = `r(r2)' if _n == `i'
	*scatterreplace peace = peace - nonpeace
}
gen vio_diff = vio_cnt - nonvio_cnt
keep vio_diff i
drop if vio_diff == .
sort i
save "viodiff.dta", replace

clear
use "viodiff.dta"
merge 1:1 i using "condiff.dta"
drop _merge
merge 1:1 i using "peacediff.dta"
drop _merge
merge 1:1 i using "wardiff.dta"
drop _merge
