cd "your/local/directory/"
clear all
set more off
clear matrix

forvalues vpos = 1/11 {
* Scenario 1:
global V = `vpos' - 6
global A = 3
global B = 5

if (`vpos' >= 6) {
global A = -3
global B = -5
}

* Scenario 2:
global Vc = `vpos' - 6
global Ac = 1
global Bc = 3

if (`vpos' >= 6) {
global Ac = -1
global Bc = -3
}

do testextremeness
}

*** Make a dataset of the results:
clear
svmat out

rename out1 V
rename out2 A
rename out3 B
rename out4 b
rename out5 se

** 95%, two-sided CIs:
gen upper = b + (se*1.96)
gen lower = b - (se*1.96)

gen scenario = _n - 6
saveold "extremeness.dta", replace
eclplot b upper lower scenario,hori scale(2) ysize(1) xsize(5) /// 
	plotregion(margin(l+0 r+0 t+3 b+3)) xscale(range(-3/3)) xlabel(-3/3, grid) /// 
	xline(0, lpattern(dash)) xtitle("Difference in Differences: Treatment Scenario(PTV(A)-PTV(B)) - Control Scenario(PTV(A)-PTV(B))") /// 
	ytitle("Left-Right Self-Placement") 



