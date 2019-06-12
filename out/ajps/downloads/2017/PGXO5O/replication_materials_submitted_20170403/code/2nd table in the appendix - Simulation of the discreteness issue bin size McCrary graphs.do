
/* 
Note: Before running the code, change the directory to the folder in which this do file is contained
If you directly open the do file in Stata you don't need to make any change
This script requires the DCdensity.ado file. We have placed it in the code/utilities directory.  
*/   

clear all
set obs 200000
cd ..
cd "output\figures\for_appendix"
cap mkdir temp 

gen n=_n

set seed 12052014
gen r = runiform()

histogram r

gen pop = int(n/400) - 250

/*
cd "D:\Projekte\Size\Dofiles\ADO"

clear all
set obs 200000


gen n=_n

set seed 12052014
gen r = runiform()

histogram r

gen pop = int(r*500) - 250
*/

histogram pop, xline(0) start(-250) width(1) freq graphregion(color(white)) xtitle("Discrete running variable")



gen treat_b =0
gen treat_se = 0
gen treat_x = 0
local j = 0


DCdensity pop, breakpoint(0) b(0.5) generate(Xj Yj r0 fhat se_fhat)
graph save "temp\McCrary_graph_b05.gph", replace
drop Xj Yj r0 fhat se_fhat

DCdensity pop, breakpoint(0) b(1) generate(Xj Yj r0 fhat se_fhat)
graph save "temp\McCrary_graph_b10.gph", replace
drop Xj Yj r0 fhat se_fhat

DCdensity pop, breakpoint(0) b(1.5) generate(Xj Yj r0 fhat se_fhat)
graph save "temp\McCrary_graph_b15.gph", replace
drop Xj Yj r0 fhat se_fhat

DCdensity pop, breakpoint(0) b(2.5) generate(Xj Yj r0 fhat se_fhat)
graph save "temp\McCrary_graph_b25.gph", replace
drop Xj Yj r0 fhat se_fhat



#delimit ;
graph combine 
"temp\McCrary_graph_b05.gph" 
"temp\McCrary_graph_b10.gph"
"temp\McCrary_graph_b15.gph",
graphregion(color(white))
saving("temp\simul-graph-McCrary.gph", replace);

#delimit cr
graph export "temp/simul-graph-McCrary.eps", replace 
!epstopdf "simul-graph-McCrary.eps"

/*graph combine 
"D:\Projekte\Size\Latex\output\figures\Germany\McCrary graph b05.gph" 
"D:\Projekte\Size\Latex\output\figures\Germany\McCrary graph b1.gph"
"D:\Projekte\Size\Latex\output\figures\Germany\McCrary graph b15.gph"
"D:\Projekte\Size\Latex\output\figures\Germany\McCrary graph b25.gph",
graphregion(color(white))
saving("D:\Projekte\Size\Latex\output\figures\Germany\simul-graph-McCrary.gph", replace);

#delimit cr
graph export "D:\Projekte\Size\Latex\output\figures\Germany\simul-graph-McCrary.eps", replace 
!epstopdf "D:\Projekte\Size\Latex\output\figures\Germany\simul-graph-McCrary.eps"
