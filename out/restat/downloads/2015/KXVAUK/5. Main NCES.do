clear all
use NCESdata
 
eststo clear
 
eststo:  reg enrolled MA i.year i.state,  vce(bootstrap, reps(200))
 
eststo:  reg enrolled denovo i.year i.state,  vce(bootstrap, reps(200))

esttab using nces.tex, label replace se keep(MAbranch denovo)  star(* .1 ** .05 *** .01)
