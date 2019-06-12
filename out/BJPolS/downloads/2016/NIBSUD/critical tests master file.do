cd "your/local/directory/"
clear all
set more off
clear matrix
*** Set scenario positions:

* Comparison 1, Scenario 1:
global A = -3
global V = -1
global B = 1
* Comparison 1, Scenario 2:
global Ac = -5
global Vc = -3
global Bc = -1
do criticaltest
* Comparison 2, Scenario 1:
global A = 3
global V = 1
global B = -1
* Comparison 2, Scenario 2:
global Ac = 5
global Vc = 3
global Bc = 1
do criticaltest
* Comparison 3, Scenario 1:
global A = -3
global V = -1
global B = 0
* Comparison 3, Scenario 2:
global Ac = -4
global Vc = -2
global Bc = -1
do criticaltest
* Comparison 4, Scenario 1:
global A = 3
global V = 1
global B = 0
* Comparison 4, Scenario 2:
global Ac = 4
global Vc = 2
global Bc = 1
do criticaltest

*** Make a dataset of the results:
clear
svmat out
rename out1 A
rename out2 V
rename out3 B
rename out4 b
rename out5 se

gen upper = b + (se*1.96)
gen lower = b - (se*1.96)

gen scenario = _n
mat list out
saveold "diffdiff.dta", replace
eclplot b upper lower scenario, hori scale(2) ysize(1) ylabel(1/4, grid) xsize(5) plotregion(margin(l+0 r+0 t+3 b+3)) xscale(range(-3/3)) xlabel(-3/3, grid) xline(0, lpattern(dash)) xtitle("Differences in Differences: Treatment Scenario(PTV(A)-PTV(B)) - Control Scenario(PTV(A)-PTV(B))") ytitle("Comparison") 
