/* randomize assignment of dema and demb for symmetry.*/
use dpost

set seed 1
gen r=uniform()
gen x5=dema
gen x6=demb
replace x5=demb if r>=.5
replace x6=dema if r>=.5

set seed 6
replace r=uniform()
replace dema=x5
replace demb=x6
replace dema=x6 if r>=.5
replace demb=x5 if r>=.5

sort year

keep year disp contig ally sq aysm dema demb py
save apsr.dta,replace



