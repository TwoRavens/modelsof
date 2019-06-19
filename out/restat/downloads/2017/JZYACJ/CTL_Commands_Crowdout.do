
use "Census_Tax_Linkage\Data\CensusTax.dta", clear
merge m:1 census06 id using "Census_Tax_Linkage\Data\Predicted_Education.dta", keep(3) keepusing(hsgrad_plus_hat) nogen

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

replace hlos=-1 if hlos==.
replace hcdd=-1 if hcdd==.

gen hsgrad_plus=(hlos>=6 | hcdd>=2)
gen tradecert_plus=(hlos>=7 | hcdd>=3)
gen somepse_plus=(hlos>=8 | hcdd>=5)
gen univgrad_plus=(hlos>=18 | hcdd>=9)

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

keep if empinc>=-9000 & empinc<9000

gen incgrp=0
local counter=-9000
forvalues i=1(1)17 {
	local counter=`counter'+1000
	replace incgrp=incgrp+1 if empinc>=`counter'
}

save "Census_Tax_Linkage\Data\CensusTax_Crowdout.dta", replace

clear

exit
