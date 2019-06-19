*-------------------------------------------------------------------------------
* Heterogenous Relative Government Spending Multipliers in the Era Surrounding the Great Recession
* Forthcoming in the Review of Economics and Statistics
* by Marco Bernardini, Selien De Schryder and Gert Peersman (fall 2018)
*
* This file generates figure 3
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

graph combine	${path}output\3_lin_NS_C.gph ///
				${path}output\3_lin_NS_Fstat.gph, ///
c(2) name(figA,replace) title("(a) scaled federal spending",size(medsmall)) imargin(vsmall) ///iscale(*.8) /// 
graphregion(color(white) margin(0 5 0 0)) ///
plotregion(color(white) margin(zero)) xsize(7) ysize(7)

// create a blank graph
twoway scatteri 1 1,               ///
       msymbol(i)                  ///
       ylab("") xlab("")           ///
       ytitle("") xtitle("")       ///
       yscale(off) xscale(off)     ///
graphregion(color(white) margin(0 5 0 0)) ///
plotregion(color(white) margin(zero)) xsize(7) ysize(7) ///
name(blank, replace) nodraw

graph combine	${path}output\3_lin_MG_C.gph blank, ///
c(2) name(figB,replace) title("(b) mean group estimator",size(medsmall)) imargin(vsmall) ///iscale(*.8) /// 
graphregion(color(white) margin(0 5 0 0)) ///
plotregion(color(white) margin(zero)) xsize(7) ysize(7)

graph combine	figA figB, ///
r(2) name(fig,replace) imargin(vsmall) ///iscale(*.8) /// 
graphregion(color(white) margin(0 5 0 0)) ///
plotregion(color(white) margin(zero)) xsize(7) ysize(7)				

graph export "${path}output\3_comb.eps", replace	
