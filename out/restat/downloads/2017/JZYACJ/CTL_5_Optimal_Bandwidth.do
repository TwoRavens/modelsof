
local inout Census_Tax_Linkage\Data

use "`inout'\CensusTax.dta", clear

sort census06 id year
keep if age>=25 & age<68

drop if sex==.
drop if province==.
drop if marst==.

replace value=0 if value==.
replace penadj=0 if penadj==.

gen female=(sex==2)
gen married=(marst==1|marst==2)
gen has_dues=(dues>0)
gen agesq=age^2

replace naics=trunc(naics/1000)

*Drops outliers
gen out_sample=0
foreach x of varlist empinc rspcont rspwd penadj {
	summarize `x', detail
	replace out_sample=1 if `x'>r(p99)
}
keep if out_sample==0
drop out_sample

local counter=1991
gen contlimit=.
foreach x of numlist 11500 12500 12500 13500 14500 13500 13500 13500 13500 13500 13500 13500 15500 16500 18000 19000 20000 21000 22000 23000 {
	replace contlimit=`x' if year==`counter'
	local counter=`counter'+1
}

local counter=1991
gen cqppympe=.
foreach x of numlist 30500 32200 33400 34400 34900 35400 35800 36900 37400 37600 38300 39100 39900 40500 41100 42100 43700 44900 46300 47200 {
	replace cqppympe=`x' if year==`counter'
	local counter=`counter'+1
}

replace empinc=empinc-cqppympe
gen kink=(empinc>=0)
gen empinc_kink=empinc*kink

keep if penadj>0 & rspcont>0
keep if dues>0

by census06 id: gen penadjl=penadj[_n-1]
keep if (penadjl+rspcont)<contlimit

gen othinc=totinc-(empinc+cqppympe)

*-----------------------------
*1) Input bandwidth of $47,200
*-----------------------------

keep if empinc>=-47200 & empinc<47200

rdbwselect rspcont empinc, deriv(1)
rdbwselect penadj empinc, deriv(1)

*-----------------------------
*2) Input bandwidth of $30,500
*-----------------------------

keep if empinc>=-30500 & empinc<30500

rdbwselect rspcont empinc, deriv(1)
rdbwselect penadj empinc, deriv(1)

*----------------------------
*3) Replicate primary results
*----------------------------

keep if empinc>=-9000 & empinc<9000

local covars age agesq female married i.province i.naics othinc value disability

qui reg rspcont empinc empinc_kink `covars'
est store savreg
qui reg penadj empinc empinc_kink `covars'
est store rppreg
suest savreg rppreg, cl(id)
nlcom [savreg_mean]_b[empinc_kink]/[rppreg_mean]_b[empinc_kink]

clear

exit
