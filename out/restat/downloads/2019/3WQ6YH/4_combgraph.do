*-------------------------------------------------------------------------------
* Heterogenous Relative Government Spending Multipliers in the Era Surrounding the Great Recession
* Forthcoming in the Review of Economics and Statistics
* by Marco Bernardini, Selien De Schryder and Gert Peersman (fall 2018)
*
* This file generates figure 4
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

graph combine	${path}output\4_lin_spillAG_BP.gph ///
				${path}output\4_lin_spilltop_BP.gph ///
				${path}output\4_lin_spilllow_BP.gph, ///
r(3) name(fig,replace) imargin(vsmall) ///iscale(*.8) /// 
graphregion(color(white) margin(0 5 0 0)) ///
plotregion(color(white) margin(zero)) xsize(7) ysize(9)				

graph export "${path}output\4_comb.eps", replace
