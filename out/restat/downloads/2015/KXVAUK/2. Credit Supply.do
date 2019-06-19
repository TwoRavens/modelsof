clear all

use mortdata_g

set seed 987654321

eststo: reg lnfees MAbranch i.state i.year, vce(bootstrap, reps(200))

eststo: reg lnrrate MAbranch i.state i.year, vce(bootstrap, reps(200))

esttab using bankdata1.tex, label replace se keep(MAbranch _cons)  star(* .1 ** .05 *** .01)
 
 
clear all

use bankdata

set seed 987654321

eststo clear

eststo: reg lnvol MAbranch i.state i.year, vce(bootstrap, reps(200))

esttab using bankdata2.tex, label replace se keep(MAbranch _cons)  star(* .1 ** .05 *** .01)
