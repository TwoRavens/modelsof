clear
clear matrix
set more off
set mem 5000m 
set matsize 500 
capture log close


use /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/cohorts_87_92_tempcost1.dta, clear

preserve
keep if b_year>=1987 & b_year<=1992


sum lnr if mageb==. 



gen mageb_25_40=1 if mageb>=25 & mageb<=40
replace mageb_25_40=0 if mageb<25 | mageb>40

keep if mageb_25_40==1

*FIGURE 9:


*disp income prior to birth 

gen disp_inc_bb=.
forvalues t=1987/1992 {
local a=`t'-1
replace disp_inc_bb=disp_faminc`a' if b_year==`t'


}

*USD:

replace disp_inc_bb=0 if disp_inc_bb<0
replace disp_inc_bb=disp_inc_bb/6

centile disp_inc_bb, centile(99)
keep if disp_inc_bb<r(c_1)


twoway (histogram disp_inc_bb if eligible==1, start(0) width(2500) color(green)) (histogram disp_inc_bb if eligible==0, start(0) width(2500) fcolor(none) lcolor(black)), legend(order(1 "Eligible" 2 "Ineligible" )) xtitle("Disposable family income in USD") xlabel(0(1000)110000)

restore


***value of leave transfer before tax=cost_direct (after taxÑdeduct tax based on information on different marginal taxes that magne sent over-- 
*vleave and vleave_AT

*disp income prior to birth 

gen disp_inc_bb=.
forvalues t=1987/1992 {
local a=`t'-1
replace disp_inc_bb=disp_faminc`a' if b_year==`t'


}

*USD:

replace disp_inc_bb=0 if disp_inc_bb<0
replace disp_inc_bb=disp_inc_bb/6


centile disp_inc_bb, centile(99)
keep if disp_inc_bb<r(c_1)


gen disp_int=.

forvalues i=0(5000)110000 {
replace disp_int=`i' if disp_inc_bb>=`i' & disp_inc_bb<`i'+5000

}

bys disp_int: egen mvleave=mean(vleave)
bys disp_int: egen mvleave_AT=mean(vleave_AT)

twoway (scatter mvleave disp_int, msize(vsmall) msymbol(circle) mcolor(gs0)) (scatter mvleave_AT disp_int, msize(vsmall) msymbol(circle) mcolor(gs9)), ylabel(0(3000)24000) xlabel(0(1000)110000)

