clear
set more off


if regexm(c(os),"Mac") == 1 {
	cd "~/Dropbox/Corporate Returns to Campaign Contributions/JOP/qpq_replication"
	}
	else if regexm(c(os),"Windows") == 1 {
	cd "~\Dropbox\Corporate Returns to Campaign Contributions\JOP/qpq_replication"
}


********************************************************************************
************ FIGURE 1: MAIN RD RESULT *********************************************
********************************************************************************

use "qpq_main_dataset", clear

replace CAR_minus1_1 = CAR_minus1_1 - 1

g vsbin = floor(voteshare*400)/400 + .00125
areg CAR_minus1_1 victory rv rv_victory if abs(rv) < .05, absorb(constant) cluster(cycle)
predict p1
replace p1 = . if victory == 0
predict p0
replace p0 = . if victory == 1
predict sterr, stdp
g upper1 = p1 + invttail(e(df_r),.025)*sterr
g upper0 = p0 + invttail(e(df_r),.025)*sterr
g lower1 = p1 - invttail(e(df_r),.025)*sterr
g lower0 = p0 - invttail(e(df_r),.025)*sterr
egen mean_CAR = mean(CAR_minus1_1), by(vsbin)
sort voteshare
graph twoway (scatter mean_CAR vsbin, graphregion(color(white)) bgcolor(white)) ///
(line p1 p0 upper1 upper0 lower1 lower0 voteshare, graphregion(color(white)) bgcolor(white)) ///
if abs(rv) < .05, xline(.5) graphregion(color(white)) bgcolor(white)


********************************************************************************
************ FIGURE 2: ACROSS BANDWIDTHS ***************************************
********************************************************************************

use "qpq_main_dataset", clear

matrix B = J(60, 4, .)
forvalues i = .005(.005).3 {
local row = `i'*200
qui:areg CAR_minus1_1 victory rv rv_victory if abs(rv) < `i', absorb(constant) cluster(cycle)
matrix B[`row', 1] = _b[victory]
matrix B[`row', 2] = _b[victory] + _se[victory]*invttail(e(df_r),.025)
matrix B[`row', 3] = _b[victory] - _se[victory]*invttail(e(df_r),.025)
matrix B[`row', 4] = `i'
disp `i'
}
svmat B
graph twoway line B*, yline(0) graphregion(color(white)) bgcolor(white)


********************************************************************************
************ FIGURE 3: LONG RUN  ***********************************************
********************************************************************************

use "qpq_main_dataset", clear

postfile tablet coef upper lower Days using "fig3", replace
forvalues i = 1/100 {
qui: areg CAR_minus1_`i' victory rv rv_victory if abs(rv) < .05, absorb(constant) cluster(cycle)
post tablet (_b[victory]) (_b[victory] + _se[victory]*invttail(e(df_r),.025)) (_b[victory] - _se[victory]*invttail(e(df_r),.025)) (`i') 
disp `i'
}
postclose tablet
clear
use "fig3"
graph twoway line coef upper lower Days, yline(0) graphregion(color(white)) bgcolor(white)

