clear matrix
set more off
set matsize 2000
use "Dataset 1995-2011.dta", clear



egen rep_id=group(reporter)
egen par_id=group(partner)
egen rep_par_id=group(reporter partner)


drop if reporter=="Ceuta y Melilla"
drop if partner=="Ceuta y Melilla"

gen island_rep= (reporter=="Illes Balears"|reporter=="Canarias")
gen cat_rep=(reporter=="Illes Balears"|reporter=="Cataluña"|reporter=="Comunidad Valenciana")
gen cat_par=(partner=="Illes Balears"|partner=="Cataluña"|partner=="Comunidad Valenciana")
gen cat=(cat_rep==1&cat_par==1)
gen can_rep=(reporter=="Canarias")
gen ib_rep=(reporter=="Illes Balears")

foreach v of varlist exptotal-dist_air float_rep float_par {
gen ln`v'=ln(`v')
}
gen lndist_road2=lndist_road*lndist_road
gen dist_road2=dist_road*dist_road

*Distance ranges
_pctile dist_road, nq(10)
forvalues z=1/9 {
local d`z'=r(r`z')
dis `d`z''
}
egen dist_rangeb=cut(dist_road), at(0,`d1',`d2',`d3',`d4',`d5',`d6',`d7',`d8',`d9', 2405) icodes
tab dist_rangeb, missing
*replace dist_rangeb=9 if dist_rangeb==.
tab dist_rangeb, gen(rangeb)

local size lngdp_rep lngdp_par lnpop_rep lnpop_par 
local size1 lngdp_rep lngdp_par lnpop_rep lnpop_par lnfloat_rep
local size2 lngdp_rep lngdp_par lnpop_rep lnpop_par tourism_rep
local distance lndist_road lndist_road2 
local distance1 dist_road dist_road2
local distance3 rangeb2-rangeb10
local frictions adjacency coast island
local frictions1 adjacency coast island cat
local fixed i.year i.rep_id i.par_id
local fixed1 i.rep_id*i.year i.par_id*i.year
local MR  mrd mrd2 mra mri mrc

foreach dep of varlist lnexptotal2 lnimptotal2 {


xi: oaxaca `dep' `size' `distance3' `frictions' `fixed' , by(island_rep) noisily vce(cl rep_par_id) detail(Size: `size', Distance: `distance3', Frictions: `frictions', FE:_*)
estimates store m1`dep'

xi: oaxaca `dep' `size' `distance3' `frictions' `fixed' , by(island_rep) noisily weight(1) vce(cl rep_par_id) detail(Size: `size', Distance: `distance3', Frictions: `frictions', FE:_*)
estimates store m1a`dep'
gen sample`dep'_1=e(sample)
xi: reg `dep' `size' `distance3' `frictions' `fixed' if island_rep==0 & sample`dep'_1==1, vce(cl rep_par_id) 
est store `dep'_1a
xi: reg `dep' `size' `distance3' `frictions' `fixed' if island_rep==1 & sample`dep'_1==1, vce(cl rep_par_id) 
est store `dep'_1b

xi: oaxaca `dep' `size' `distance3' `frictions' `fixed' , by(island_rep) noisily weight(0) vce(cl rep_par_id) detail(Size: `size', Distance: `distance3', Frictions: `frictions', FE:_*)
estimates store m1b`dep'
xi: oaxaca `dep' `size' `distance3' `frictions' `fixed' , by(island_rep) noisily weight(0.5) vce(cl rep_par_id) detail(Size: `size', Distance: `distance3', Frictions: `frictions', FE:_*)
estimates store m1c`dep'
xi: oaxaca `dep' `size' `distance3' `frictions' `fixed' , by(island_rep) noisily pooled vce(cl rep_par_id) detail(Size: `size', Distance: `distance3', Frictions: `frictions', FE:_*)
estimates store m1d`dep'


xi: oaxaca `dep' `size1' `distance3' `frictions' `fixed' , by(island_rep) noisily weight(0.5) vce(cl rep_par_id) detail(Size: `size1', Distance: `distance3', Frictions: `frictions' , FE:_*)
estimates store m2`dep'
gen sample`dep'_2=e(sample)
xi: reg `dep' `size1' `distance3' `frictions' `fixed' if island_rep==0 & sample`dep'_2==1, vce(cl rep_par_id) 
est store `dep'_2a
xi: reg `dep' `size1' `distance3' `frictions' `fixed' if island_rep==1 & sample`dep'_2==1, vce(cl rep_par_id) 
est store `dep'_2b

xi: oaxaca `dep' `size2' `distance3' `frictions' `fixed' , by(island_rep) noisily weight(0.5) vce(cl rep_par_id) detail(Size: `size2', Distance: `distance3', Frictions: `frictions' , FE:_*)
estimates store m3`dep'
gen sample`dep'_3=e(sample)
xi: reg `dep' `size2' `distance3' `frictions' `fixed' if island_rep==0 & sample`dep'_3==1, vce(cl rep_par_id) 
est store `dep'_3a
xi: reg `dep' `size2' `distance3' `frictions' `fixed' if island_rep==1 & sample`dep'_3==1, vce(cl rep_par_id) 
est store `dep'_3b

xi: oaxaca `dep' `size' `distance3' `frictions1' `fixed' , by(island_rep) noisily weight(0.5) vce(cl rep_par_id) detail(Size: `size', Distance: `distance3', Frictions: `frictions1' , FE:_*)
estimates store m4`dep'
gen sample`dep'_4=e(sample)
xi: reg `dep' `size' `distance3' `frictions1' `fixed' if island_rep==0 & sample`dep'_4==1, vce(cl rep_par_id) 
est store `dep'_4a
xi: reg `dep' `size' `distance3' `frictions1' `fixed' if island_rep==1 & sample`dep'_4==1, vce(cl rep_par_id) 
est store `dep'_4b


xi: oaxaca `dep' `size' `distance1' `frictions' `fixed', by(island_rep) noisily weight(0.5) vce(cl rep_par_id) detail(Size: `size', Distance: `distance1', Frictions: `frictions' , FE:_*)
estimates store m5`dep'
gen sample`dep'_5=e(sample)
xi: reg `dep' `size' `distance1' `frictions' `fixed' if island_rep==0 & sample`dep'_5==1, vce(cl rep_par_id) 
est store `dep'_5a
xi: reg `dep' `size' `distance1' `frictions' `fixed' if island_rep==1 & sample`dep'_5==1, vce(cl rep_par_id) 
est store `dep'_5b



xi: oaxaca `dep' `size' `distance3' `frictions' `fixed' `MR', by(island_rep) noisily weight(0.5) vce(cl rep_par_id) detail(Size: `size', Distance: `distance3', Frictions: `frictions' , MR: `MR', FE:_*)
estimates store m9`dep'
gen sample`dep'_9=e(sample)
xi: reg `dep' `size' `distance3' `frictions' `fixed' `MR' if island_rep==0 & sample`dep'_1==1, vce(cl rep_par_id) 
est store `dep'_9a
xi: reg `dep' `size' `distance3' `frictions' `fixed' `MR' if island_rep==1 & sample`dep'_1==1, vce(cl rep_par_id) 
est store `dep'_9b



}

estimates clear


