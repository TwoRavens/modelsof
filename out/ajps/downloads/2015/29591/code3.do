version 13.1
clear all
set more off


local dvar "turnout support_left2 support_right2 support_left"
foreach out of local dvar {
use data1.dta ,clear
global depvar `out'

xtivreg2 $depvar treatment   xx* time_ref_*  ddbnuXt_* [aweight=weight], fe clu(bnum time_ref)
capture mat drop rrr
matrix   temp = _b[treatment]
matrix   rownames temp = "treatment"
mat rrr = nullmat(rrr) \ temp
		
drop if knum==22
gen knum_count = .
replace knum_count=1 if knum==2
replace knum_count=2 if knum==3
replace knum_count=3 if knum==5
replace knum_count=4 if knum==6
replace knum_count=5 if knum==7
replace knum_count=6 if knum==9
replace knum_count=7 if knum==10
replace knum_count=8 if knum==11
replace knum_count=9 if knum==13
replace knum_count=10 if knum==23
replace knum_count=11 if knum==24

forvalues i = 1/11 {
	forvalues t=-4/4 {
		cap drop placebo_t
		qui gen placebo_t = 0
		qui replace placebo_t = 1 if knum_count==`i' & inrange(year,1925+`t',1939+`t')
		qui replace placebo_t = 1 if knum_count==`i' & inrange(year,1945+`t',1948+`t')
		qui xtivreg2 $depvar placebo_t   xx* time_ref_*  ddbnuXt_*  [aweight=weight], fe clu(bnum time_ref)
		matrix   temp = _b[placebo_t]
		matrix   rownames temp = "control"
        mat rrr = nullmat(rrr) \ temp
		di `i'
		di `t'
		di _b[placebo_t]
		di   ttail(12-2,abs(_b[placebo_t] / _se[placebo_t]))*2
	}
}
mat2txt , matrix(rrr) saving("placebo_$depvar.txt")  replace 
}
