*****************************************************************************************************************
*THIS PROGRAM DOES A MONTE CARLO OF OUR FOC AND OF THE REMAINING SOBIAS UNDER VARIOUS DISTRIBUTINOAL ASSUMPTIONS*
*****************************************************************************************************************

***SETUP***

clear
timer clear
set more off
set type double
set scheme s1mono

global path="C:\data"				/* path output files */
set seed 10101					/* number for random number generator */
global numobs "10000"				/* number of observations */
global numsims "20000"				/* number of simulations */
global distribution "rbeta(25,25)"		/* distribution: uniform(), rnormal(0,x) x=variance, rbeta(a,b) a,b=parameters */
global alpha "25"					/* parameter a of the beta distribution */
global beta "25"					/* parameter b of the beta distribution */
global variance "0.25"				/* variance of the lognormal distribution */
global distri "beta"				/* mention distribution function: uniform, lognormal or beta */

***DEFINE AUXILIARY PROGRAM TO CALCULATE THE CONCENTRATION INDEX***

capture program drop conind
program define conind, rclass
syntax varname [if] [in], rnk(varname) wght(varname)

tempvar cumw cumw_1 cumwr cumwr_1 frnk temp meanlhs lhs rhs1 rhs2
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

	regress `lhs' `rhs1' `rhs2' if `touse', noconstant robust cluster(`rhs2')
}

mat ci=e(b)
return scalar ci=ci[1,2]
mat seci=e(V)
return scalar seci=(seci[2,2])^0.5
return scalar obs=e(N)
end

***AUXILIARY PROGRAM THAT DESCRIBES THE MONTE CARLO***

capture program drop ginisim
program define ginisim, rclass
drop _all
set obs $numobs
gen pweight=1
if "$distribution"=="uniform()" {
	gen y=$distribution
	return scalar zmean=0.5
	return scalar zvar=1/12
}
else if "$distri"=="lognormal" {
	gen y=$distribution
	replace  y=exp(y)
	return scalar zmean=exp(0.5*$variance)
	return scalar zvar=((exp(0.5*$variance))^2)*(exp($variance)-1)
}
else {
	gen y=$distribution
	return scalar zmean=$alpha/($alpha+$beta)
	return scalar zvar=($alpha*$beta)/((($alpha+$beta)^2)*($alpha+$beta+1))
	return scalar zskew=(2*($beta-$alpha)*sqrt($alpha+$beta+1))/(($alpha+$beta+2)*sqrt($alpha*$beta))
	return scalar zkurt=3+6*($alpha^3-($alpha^2)*(2*$beta-1)+($beta^2)*($beta+1)-2*$alpha*$beta*($beta+2))/($alpha*$beta*($alpha+$beta+2)*($alpha+$beta+3))
}
summarize y, detail
return scalar ymean=r(mean)
return scalar yvar=r(Var)
return scalar yskew=r(skewness)
return scalar ykurt=r(kurtosis)
quietly {
	conind y, rnk(y) wght(pweight)
	return scalar gini_full=r(ci)
	return scalar gini_se_full=r(seci)
	foreach num of numlist 50 40 30 20 15/2 {
		xtile dy=y [aw=pweight], nq(`num')
		conind y, rnk(dy) wght(pweight)
		return scalar gini_`num'=r(ci)
		return scalar gini_se_`num'=r(seci)
		drop dy
	}
}
end

local a="$distribution"
local b="$numobs"
timer on 1
simulate zmean=r(zmean) zvar=r(zvar) zskew=r(zskew) zkurt=r(zkurt) ymean=r(ymean) yvar=r(yvar) yskew=r(yskew) ykurt=r(ykurt) gini_full=r(gini_full) /*
	*/ gini_se_full=r(gini_se_full) gini_50=r(gini_50) gini_se_50=r(gini_se_50) gini_40=r(gini_40) gini_se_40=r(gini_se_40) gini_30=r(gini_30) /*
	*/ gini_se_30=r(gini_se_30) gini_20=r(gini_20) gini_se_20=r(gini_se_20) gini_15=r(gini_15) gini_se_15=r(gini_se_15) /*
	*/ gini_14=r(gini_14) gini_se_14=r(gini_se_14) gini_13=r(gini_13) gini_se_13=r(gini_se_13) gini_12=r(gini_12) /*
	*/ gini_se_12=r(gini_se_12) gini_11=r(gini_11) gini_se_11=r(gini_se_11) gini_10=r(gini_10) gini_se_10=r(gini_se_10) /*
	*/ gini_9=r(gini_9) gini_se_9=r(gini_se_9) gini_8=r(gini_8) gini_se_8=r(gini_se_8) gini_7=r(gini_7) /*
	*/ gini_se_7=r(gini_se_7) gini_6=r(gini_6) gini_se_6=r(gini_se_6) gini_5=r(gini_5) gini_se_5=r(gini_se_5) /*
	*/ gini_4=r(gini_4) gini_se_4=r(gini_se_4) gini_3=r(gini_3) gini_se_3=r(gini_se_3) gini_2=r(gini_2) /*
	*/ gini_se_2=r(gini_se_2), reps($numsims) saving($path\_mc_`a'_`b'.dta, replace every(10) double): ginisim
timer off 1
timer list 1

***MAKE GRAPH***

clear
set obs $numobs
gen y=$distribution
if "$distri"=="lognormal" {
	replace y=exp(y)
}
histogram y, normal
local a="$distribution"
local b="$numobs"
graph export "_mc_`a'_`b'.wmf", replace as(wmf)