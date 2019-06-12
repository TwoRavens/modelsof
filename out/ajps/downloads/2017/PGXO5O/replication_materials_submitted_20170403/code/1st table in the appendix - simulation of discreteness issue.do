
/* 
Note: Before running the code, change the directory to the folder in which this do file is contained
If you directly open the do file in Stata you don't need to make any change
This script requires the DCdensity.ado file. We have placed it in the code/utilities directory.  
*/   


* cd /Users/androo/Dropbox/research/pop_thresholds/final_submission/replication_materials/code


clear all
set obs 200000
cd ..
* cd "output/figures/for_appendix"
cd "output\figures\for_appendix"
cap mkdir temp 

gen n=_n

set seed 12052014
gen r = runiform()

histogram r

gen pop = int(n/400) - 250


histogram pop, xline(0) start(-250) width(5) freq graphregion(color(white)) xtitle("Discrete running variable")


gen treat_b =0
gen treat_se = 0
gen treat_x = 0
local j = 0


*DCdensity pop, breakpoint(-0.5) b(1) h(30) generate(Xj Yj r0 fhat se_fhat)

 forvalues x = -1(0.05)0.05 {
local j = `j' + 1

DCdensity pop, breakpoint(`x') h(100) generate(Xj Yj r0 fhat se_fhat)
replace treat_x = `x' in `j'
replace treat_b = r(theta) in `j' 
replace treat_se = r(se) in `j' 
drop Xj Yj r0 fhat se_fhat
}

DCdensity pop, breakpoint(0) h(100) generate(Xj Yj r0 fhat se_fhat)

replace treat_x = 0 in 21
replace treat_b = r(theta) in 21 
replace treat_se = r(se) in 21 

keep in 1/21
drop in 1

gen high = treat_b + 1.96 * treat_se
gen low = treat_b - 1.96 * treat_se


#delimit;
graph twoway 
scatter treat_b treat_x ||
rcap high low treat_x || ,
legend(off) ytitle( "Estimated McCrary statistic" " ") scheme(s2color)
xtitle( "Position of the threshold in the McCrary code" ) yline(0) graphregion(color(white)) 
saving("temp\simul-threshold-graph.gph", replace);
;

#delimit cr

graph export "temp\simul-threshold-graph.eps", replace 
!epstopdf "temp\simul-threshold-graph.eps"



*** Path for the McCrary ADO


clear all
set obs 200000

gen n=_n

gen pop = int(n/400) - 250


histogram pop, xline(0) start(-250) width(1) freq graphregion(color(white)) xtitle("Discrete running variable")



gen treat_b =0
gen treat_se = 0
gen treat_x = 0
local j = 0


*DCdensity pop, breakpoint(0) h(100) generate(Xj Yj r0 fhat se_fhat)

forvalues x = 0.5(0.1)3.1 {
local j = `j' + 1

DCdensity pop, breakpoint(0) b(`x') generate(Xj Yj r0 fhat se_fhat)
replace treat_x = `x' in `j'
replace treat_b = r(theta) in `j' 
replace treat_se = r(se) in `j' 
drop Xj Yj r0 fhat se_fhat
}


*replace treat_x=0 in 11 

keep in 1/26
*drop in 1

gen high = treat_b + 1.96 * treat_se
gen low = treat_b - 1.96 * treat_se


#delimit;
graph twoway 
scatter treat_b treat_x ||
rcap high low treat_x || ,
legend(off) ytitle( "Estimated McCrary statistic" " ") scheme(s2color)
xtitle( "Selecting a bin size" ) yline(0) graphregion(color(white)) 
saving("temp\simul-bin-size-graph.gph", replace);
;

#delimit cr

graph export "temp\simul-bin-size-graph.eps", replace 
!epstopdf "temp\simul-bin-size-graph.eps"


*Graph combine with the right panel of fig 1

#delimit ;
graph combine 
"temp\simul-bin-size-graph.gph" 
"temp\simul-threshold-graph.gph",
graphregion(color(white))
saving("temp\simul-graph-combine.gph", replace);

#delimit cr
graph export "temp/simul-graph-combine.eps", replace 
!epstopdf "simul-graph-combine.eps"
