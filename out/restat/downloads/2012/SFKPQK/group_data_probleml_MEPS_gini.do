/*##############################################*/
/* MEPS 2000 data						*/
/*##############################################*/

clear
set more off
set memory 500m
set seed 546
set type double

*********************************
*** Programs for the analysis ***
*********************************

capture program drop conind
program define conind, rclass
version 7.0
syntax varname [if] [in], rnk(varname) wght(varname) [dir(string)]

tempvar cumw temp frnk meanlhs lhs rhs1 rhs2 cumw_1 cumlhs cumlhs1 cumwr cumwr_1
tempname sumw sigma2 ci seci

quietly replace `wght'=. if `wght'==0

marksample touse
markout `touse' `rnk' `wght'

gsort -`touse' `rnk'
quietly {
	egen double `sumw'=sum(`wght') if `touse'
	gen double `cumw'=sum(`wght') if `touse'
	gen double `cumw_1'=`cumw'[_n-1] if `touse'
	replace `cumw_1'=0 if `cumw_1'==.
	bys `rnk': egen double `cumwr'=max(`cumw') if `touse'
	bys `rnk': egen double `cumwr_1'=min(`cumw_1') if `touse'
	gen double `frnk'=(`cumwr_1'+0.5*(`cumwr'-`cumwr_1'))/`sumw' if `touse'

	gen double `temp'=(`wght'/`sumw')*((`frnk'-0.5)^2) if `touse'
	egen double `sigma2'=sum(`temp') if `touse'
	replace `temp'=`wght'*`varlist'
	egen double `meanlhs'=sum(`temp') if `touse'
	replace `meanlhs'=`meanlhs'/`sumw'
	gen double `lhs'=2*`sigma2'*(`varlist'/`meanlhs')*sqrt(`wght') if `touse'
	gen double `rhs1'=sqrt(`wght') if `touse'
	gen double `rhs2'=`frnk'*sqrt(`wght') if `touse'

	regress `lhs' `rhs1' `rhs2' if `touse', noconstant vce(bootstrap, reps(1000)) cluster(`rhs2')
	}

mat ci=e(b)
return scalar ci=ci[1,2]
mat seci=e(V)
return scalar seci=(seci[2,2])^0.5
return scalar obs=e(N)
end

capture program drop results
program define results
di in text "{hline 5}{c TT}{hline 10}{c TT}{hline 10}{c TT}{hline 10}{c TT}{hline 10}{c TT}{hline 10}{c TT}{hline 10}" /*
	*/ in text "{c TRC}"
di in text _col(6) "{c |} gini" /*
	*/ _col(17) "{c |} bias" /*
	*/ _col(28) "{c |} s.e." /*
	*/ _col(39) "{c |} Our" /*
	*/ _col(50) "{c |} Our bias" /*
	*/ _col(61) "{c |} covar" /*
	*/ _col(72) "{c |} "
di in text "{hline 5}{c +}{hline 10}{c +}{hline 10}{c +}{hline 10}{c +}{hline 10}{c +}{hline 10}{c +}{hline 10}{c RT}"
di in text "full" _col(6) "{c |}" _col(6) as result income_full /*
	*/ _col(17) as text "{c |}" /*
	*/ _col(28) as text "{c |}" _col(28) as result income_se /*
	*/ _col(39) as text "{c |}" /*
	*/ _col(50) as text "{c |}" /*
	*/ _col(61) as text "{c |}" /*
	*/ _col(72) as text "{c |}"
di in text "{hline 5}{c +}{hline 10}{c +}{hline 10}{c +}{hline 10}{c +}{hline 10}{c +}{hline 10}{c +}{hline 10}{c RT}"
foreach num of numlist 50/2 {
	di in text "`num'" _col(6) "{c |}" _col(7) as result income_`num' /*
		*/ _col(17) as text "{c |}" _col(17) as result 100*(income_`num'/income_full) /*
		*/ _col(28) as text "{c |}" _col(28) as result income_se_`num' /*
		*/ _col(39) as text "{c |}" _col(39) as result income_`num'*((`num'^2)/((`num'^2)-1)) /*
		*/ _col(50) as text "{c |}" _col(50) as result 100*((income_`num'*((`num'^2)/((`num'^2)-1)))/income_full) /*
		*/ _col(61) as text "{c |}" _col(61) as result (income_`num'*((`num'^2)/((`num'^2)-1))-income_full)*(((`num'^2)-1)/(12*(`num'^2))) /*
		*/ _col(72) as text "{c |}"
}
di in text "{hline 5}{c BT}{hline 10}{c BT}{hline 10}{c BT}{hline 10}{c BT}{hline 10}{c BT}{hline 10}{c BT}{hline 10}" /*
	*/ in text "{c BRC}"
end

*******************************************************************
*** path + simulation size + calculation method + loop over size***
*******************************************************************

global path="c:\data"

/* LOAD MEPS 2000 DATA */

use "$path\h50.dta", clear
sort dupersid
save "$path\meps_main_temp.dta", replace

/* Generating modified OECD Eqivalence scale and income */

gen totalinc=ttlp00
gen age_over_14=0
replace age_over_14=1 if age00x>14
gen age_under_14=0
replace age_under_14=1 if age00x<=14

collapse (sum) totalinc age_over_14 age_under_14, by(duid)
sort duid
save "$path\meps_income.dta", replace

use "$path\meps_main_temp.dta", clear
erase "$path\meps_main_temp.dta"
sort duid
joinby duid using "$path\meps_income.dta"
erase "$path\meps_income.dta"

gen oecdscale=0
replace oecdscale=1 if  age_over_14>0
replace oecdscale=oecdscale+(age_over_14-1)*0.5 if age_over_14>=1
replace oecdscale=oecdscale+(age_under_14)*0.3
generate income=totalinc/oecdscale

/* Dropping vars & obs */

gen drop_ind=0
replace drop_ind=1 if  ttlp00x<0
replace drop_ind=1 if age00x<16 /* similar to ECHP */
replace drop_ind=1 if perwt00f==0
drop if drop_ind>0
replace perwt00f=1
keep perwt00f income oecdscale dupersid

*********************************************
*** analysis: aggregated formula, bias ******
*********************************************

quietly {
	conind income, rnk(income) wght(perwt00f)
	scalar income_full=r(ci)
	scalar income_se=r(seci)
	foreach num of numlist 50/2 {
		xtile decinc=income [aw=perwt00f], nq(`num')
		conind income, rnk(decinc) wght(perwt00f)
		scalar income_`num'=r(ci)
		scalar income_se_`num'=r(seci)
		drop decinc
	}
}


log using "$path\US.log", replace
sum income [aw=perwt00f], detail
results
log close
