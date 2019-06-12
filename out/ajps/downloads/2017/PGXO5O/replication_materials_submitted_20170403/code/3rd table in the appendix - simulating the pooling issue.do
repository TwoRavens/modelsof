
/* 
Note: Before running the code, change the directory to the folder in which this do file is contained
If you directly open the do file in Stata you don't need to make any change
This script requires the DCdensity.ado file. We have placed it in the code/utilities directory.  
*/   

clear all
cd ..
cd "output\figures\for_appendix"
cap mkdir temp

set obs 10500

gen n=_n

drop if n<500

gen thresh = int((n+500)/1000)*1000

gen ratio = ((n-thresh)/thresh) * 100

preserve
drop if abs(ratio)>0.5
#delimit;
histogram ratio
, xline(0) start(-0.5) width(0.01) ytick(0(5)15) 
freq graphregion(color(white)) xtitle("Distribution of the pooled data")
saving("temp\simul-pooling-hist.gph", replace);

#delimit cr
graph export "temp\simul-pooling-hist.eps", replace 
!epstopdf "temp\simul-pooling-hist.eps"

restore


save "temp\simul_pooled_data.dta", replace

append using "temp\simul_pooled_data.dta"
append using "temp\simul_pooled_data.dta"
append using "temp\simul_pooled_data.dta"
append using "temp\simul_pooled_data.dta"
append using "temp\simul_pooled_data.dta"
append using "temp\simul_pooled_data.dta"
append using "temp\simul_pooled_data.dta"
append using "temp\simul_pooled_data.dta"
append using "temp\simul_pooled_data.dta"
append using "temp\simul_pooled_data.dta"
append using "temp\simul_pooled_data.dta"
append using "temp\simul_pooled_data.dta"
append using "temp\simul_pooled_data.dta"
append using "temp\simul_pooled_data.dta"
append using "temp\simul_pooled_data.dta"
append using "temp\simul_pooled_data.dta"
append using "temp\simul_pooled_data.dta"
append using "temp\simul_pooled_data.dta"
append using "temp\simul_pooled_data.dta"


*drop if abs(ratio)>5
*cd "D:\Projekte\Size\Dofiles\ADO"
*DCdensity ratio, breakpoint(0) b(0.1) generate(Xj Yj r0 fhat se_fhat)


gen treat_b =0
gen treat_se = 0
gen treat_x = 0
local j = 0

*drop if abs(ratio)>5

forvalues x = 0.009999(0.01)0.21 {
local j = `j' + 1
local k = 10*`x'

DCdensity ratio, breakpoint(-0.005) b(`x') h(`k') generate(Xj Yj r0 fhat se_fhat)
replace treat_x = `x' in `j'
replace treat_b = r(theta) in `j' 
replace treat_se = r(se) in `j' 
drop Xj Yj r0 fhat se_fhat
}

keep in 1/20

gen high = treat_b + 1.96 * treat_se
gen low = treat_b - 1.96 * treat_se


#delimit;
graph twoway 
scatter treat_b treat_x ||
rcap high low treat_x || ,
legend(off) ytitle( "Estimated McCrary statistic" " ") scheme(s2color)
xtitle( "Different bin size" ) yline(0) graphregion(color(white)) 
saving("temp\simul-binsize-pooled-graph.gph", replace);
;

#delimit cr

graph export "temp\simul-binsize-pooled-graph.eps", replace 
!epstopdf "temp\simul-binsize-pooled-graph.eps"


/* Graph combine with the right panel of fig 2 */

#delimit ;
graph combine 
"temp\simul-pooling-hist.gph" 
"temp\simul-binsize-pooled-graph.gph",
graphregion(color(white))
saving("temp\simul-graph-pooled-combine.gph", replace);


#delimit cr
graph export "temp\simul-graph-pooled-combine.eps", replace 
!epstopdf "simul-graph-pooled-combine.eps"
