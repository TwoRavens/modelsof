*-------------------------------------------------------------------------------
* Heterogenous Relative Government Spending Multipliers in the Era Surrounding the Great Recession
* Forthcoming in the Review of Economics and Statistics
* by Marco Bernardini, Selien De Schryder and Gert Peersman (fall 2018)
*
* This file generates figure 2
*-------------------------------------------------------------------------------

////////////////////////////////////////////////////////////////////////////////
* 1) SETTINGS
////////////////////////////////////////////////////////////////////////////////
****************************
* housekeeping and loading *
****************************

* settings
clear all // clear memory 
cls // clear results window
set more off // do not display the "more" message
set graphics off // do (not) show graphics in STATA
adopath ++ PLUS


***********
* figure  *
***********

graph combine	${path}output\2_lin_BP.gph ///
				${path}output\2_lin_BP_Fstat.gph, ///
c(2) nodraw name(figA,replace) imargin(vsmall) ///iscale(*.8) /// 
graphregion(color(white) margin(0 5 0 0)) ///
plotregion(color(white) margin(zero)) xsize(7) ysize(7)				

graph combine	figA ///
				${path}output\2_lin_BP_gy.gph, ///
r(2) name(figB,replace) imargin(vsmall) ///iscale(*.8) /// 
graphregion(color(white) margin(0 5 0 0)) ///
plotregion(color(white) margin(zero)) xsize(7) ysize(7)

graph export "${path}output\2_comb_BP.eps", replace
