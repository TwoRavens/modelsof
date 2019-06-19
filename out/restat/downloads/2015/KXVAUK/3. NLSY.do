

*notes requires restricted NLSY geocode data

clear all

use NLSYdata

eststo clear




eststo: reg c ma $spec1 if g>7&a>16&a<24 ,  vce(bootstrap, reps(200))

eststo: reg c ma  $spec2  if g>7&a>16&a<24,  vce(bootstrap, reps(200))


eststo: reg c1 ma  $spec1  if g>7&a>16&a<24 ,  vce(bootstrap, reps(200))

eststo: reg c1 ma  $spec2  if g>7&a>16&a<24,  vce(bootstrap, reps(200))


eststo: reg c2 ma    $spec1  ,  vce(bootstrap, reps(200))

eststo: reg c2 ma  $spec2 ,  vce(bootstrap, reps(200))


esttab using collegeoutcomesNLSY.tex, label replace se keep(ma)  star(* .1 ** .05 *** .01)
