capture log close

do tests_bootstrap99q_QTEcomparisons.do

capture program drop test_ezop
do tests_ezop_bootstrap99_QTE_DISTRIBUTION_02.do

noi test_ezop, qmin(5) qmax(95) groups(10) myfile("data_merged") qte

use data_graph.dta, clear
foreach var of varlist PVALdomF0 PVALdomF1 PVALdomQTE PVALeqF0 PVALeqF1 PVALeqQTE {
	drop if Gdomt == .
	keep Gdomt Gdomd `var'
	gen scale_`var'_ = 1 if `var'>=0 & `var'<=0.05
	replace scale_`var'_ = 2 if `var'>0.05 & `var'<=0.1
	replace scale_`var'_ = 3 if `var'>0.1 & `var'<=0.5
	replace scale_`var'_ = 4 if `var'>0.5 & `var'<=1
	replace scale_`var'_ = 5 if `var'==.
	gen id = _n
	rename Gdomt Gdomt`var'_
	rename Gdomd Gdomd`var'_
	drop `var'
	reshape wide Gdomt`var'_ Gdomd`var'_, i(id) j(scale_`var'_)
	local usedata "usedata`var'"
	tempfile `usedata'
	save ``usedata'', replace
	use data_graph.dta, clear
}
use `usedataPVALdomF0', clear
local vars "PVALdomF1 PVALdomQTE PVALeqF0 PVALeqF1 PVALeqQTE"
foreach varn of local vars {
	merge 1:1 id using `usedata`varn'', nogen
}
save data_graph2.dta, replace

local vars ""
local l1 "Gdomt Gdomd"
local l2 "PVALdomF0 PVALdomF1 PVALdomQTE PVALeqF0 PVALeqF1 PVALeqQTE"
local l3 "1 2 3 4 5 " 
foreach x1 of local l1 {
	foreach x2 of local l2 {
		foreach x3 of local l3 {
			local vars "`vars' `x1'`x2'_`x3'"
		}
	}
}
display  "`vars'"
foreach var of local vars {
	capture gen `var' = .
}

cap egen GdomtPVALeqF0_ACCEPT = rowtotal(GdomtPVALeqF0_2 GdomtPVALeqF0_3 GdomtPVALeqF0_4), m
cap egen GdomtPVALeqF1_ACCEPT = rowtotal(GdomtPVALeqF1_2 GdomtPVALeqF1_3 GdomtPVALeqF1_4), m
cap egen GdomtPVALeqQTE_ACCEPT = rowtotal(GdomtPVALeqQTE_2 GdomtPVALeqQTE_3 GdomtPVALeqQTE_4), m
cap egen GdomdPVALeqF0_ACCEPT = rowtotal(GdomdPVALeqF0_2 GdomdPVALeqF0_3 GdomdPVALeqF0_4), m
cap egen GdomdPVALeqF1_ACCEPT = rowtotal(GdomdPVALeqF1_2 GdomdPVALeqF1_3 GdomdPVALeqF1_4), m
cap egen GdomdPVALeqQTE_ACCEPT = rowtotal(GdomdPVALeqQTE_2 GdomdPVALeqQTE_3 GdomdPVALeqQTE_4), m

label define labgroups 1 "1%-10%" 2 "10%-20%" 3 "20%-30%" 4 "30%-40%" 5 "40%-50%" 6 "50%-60%" 7 "60%-70%" 8 "70%-80%" 9 "80%-90%" 10 "90%-99%"
label define labgroups2 1 "D1" 2 "D2" 3 "D3" 4 "D4" 5 "D5" 6 "D6" 7 "D7" 8 "D8" 9 "D9" 10 "D10"
label values Gdom*  labgroups
label values Gdom*  labgroups2


**************************************************************************
*		GRAPH 1: joint tests for F0
**************************************************************************

local optplus "ytitle("H0: Dominant distributions (by family income deciles)", size(small) color(black)) xtitle("H0: Dominated distributions (by family income deciles)", size(small) color(black)) yscale(range(0.5 10.5)) yscale(line extend fextend) ylabel(1(1)10, labels labsize(vsmall) angle(stdarrow) labgap(small) valuelabel grid glwidth(vvvthin) glcolor(gs9) glpattern(solid) gmin nogextend) xscale(range(0.5 10.5)) xscale(extend fextend) xlabel(1(1)10, labels labsize(vsmall) angle(stdarrow) labgap(tiny) valuelabel grid glwidth(vvvthin) glcolor(gs8) gmin gmax nogextend) legend(on cols(3) rows(2) size(small) color(black) position(6) label(1 "0<= Pvalue <= 5%") label(2 "5%< Pvalue <=10%" ) label(3 "10%< Pvalue <=50%" ) label(4 " Pvalue >50%" ) label(5 "Inconclusive" "(a crossing in distributions)" ) label(6 "Accept equality at 5%" ) ) graphregion(fcolor(white) lcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))"
twoway 		(scatter GdomdPVALdomF0_1  GdomtPVALdomF0_1, mcolor(gs14) msize(huge) msymbol(square)) ///
	(scatter GdomdPVALdomF0_2  GdomtPVALdomF0_2, mcolor(gs11) msize(huge) msymbol(square)) ///
	(scatter GdomdPVALdomF0_3  GdomtPVALdomF0_3, mcolor(gs8) msize(huge) msymbol(square)) ///
	(scatter GdomdPVALdomF0_4  GdomtPVALdomF0_4, mcolor(gs5) msize(huge) msymbol(square)) ///	
	(scatter GdomdPVALdomF0_5  GdomtPVALdomF0_5, mcolor(black) msize(huge) msymbol(square_hollow)) ///	
	(scatter GdomdPVALeqF0_ACCEPT  GdomtPVALeqF0_ACCEPT if GdomdPVALeqF0_ACCEPT!=0 | GdomtPVALeqF0_ACCEPT != 0, mcolor(black) msize(medsmall) msymbol(circle)) ///	
	, `optplus'
*graph export graphs\joint_test_F0.png, replace wid(918) hei(668)



**************************************************************************
*		GRAPH 2: joint tests for F1
**************************************************************************

local optplus "ytitle("H0: Dominant distributions (by family income deciles)", size(small) color(black)) xtitle("H0: Dominated distributions (by family income deciles)", size(small) color(black)) yscale(range(0.5 10.5)) yscale(line extend fextend) ylabel(1(1)10, labels labsize(vsmall) angle(stdarrow) labgap(small) valuelabel grid glwidth(vvvthin) glcolor(gs9) glpattern(solid) gmin nogextend) xscale(range(0.5 10.5)) xscale(extend fextend) xlabel(1(1)10, labels labsize(vsmall) angle(stdarrow) labgap(tiny) valuelabel grid glwidth(vvvthin) glcolor(gs8) gmin gmax nogextend) legend(on cols(3) rows(2) size(small) color(black) position(6) label(1 "0<= Pvalue <= 5%") label(2 "5%< Pvalue <=10%" ) label(3 "10%< Pvalue <=50%" ) label(4 " Pvalue >50%" ) label(5 "Inconclusive" "(a crossing in distributions)" ) label(6 "Accept equality at 5%" ) ) graphregion(fcolor(white) lcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))"
twoway 		(scatter GdomdPVALdomF1_1  GdomtPVALdomF1_1, mcolor(gs14) msize(huge) msymbol(square)) ///
	(scatter GdomdPVALdomF1_2  GdomtPVALdomF1_2, mcolor(gs11) msize(huge) msymbol(square)) ///
	(scatter GdomdPVALdomF1_3  GdomtPVALdomF1_3, mcolor(gs8) msize(huge) msymbol(square)) ///
	(scatter GdomdPVALdomF1_4  GdomtPVALdomF1_4, mcolor(gs5) msize(huge) msymbol(square)) ///	
	(scatter GdomdPVALdomF1_5  GdomtPVALdomF1_5, mcolor(black) msize(huge) msymbol(square_hollow)) ///	
	(scatter GdomdPVALeqF1_ACCEPT  GdomtPVALeqF1_ACCEPT if GdomdPVALeqF0_ACCEPT!=0 | GdomtPVALeqF0_ACCEPT != 0, mcolor(black) msize(medsmall) msymbol(circle)) ///	
	, `optplus'
*graph export graphs\joint_test_F1.png, replace wid(918) hei(668)


**************************************************************************
*		GRAPH 3: joint tests for QTE
**************************************************************************

local optplus "ytitle("H0: Dominant QTE distrib. (by family income deciles)", size(small) color(black)) xtitle("H0: Dominated QTE distrib. (by family income deciles)", size(small) color(black)) yscale(range(0.5 10.5)) yscale(line extend fextend) ylabel(1(1)10, labels labsize(vsmall) angle(stdarrow) labgap(small) valuelabel grid glwidth(vvvthin) glcolor(gs9) glpattern(solid) gmin nogextend) xscale(range(0.5 10.5)) xscale(extend fextend) xlabel(1(1)10, labels labsize(vsmall) angle(stdarrow) labgap(tiny) valuelabel grid glwidth(vvvthin) glcolor(gs8) gmin gmax nogextend) legend(on cols(3) rows(2) size(small) color(black) position(6) label(1 "0<= Pvalue <= 5%") label(2 "5%< Pvalue <=10%" ) label(3 "10%< Pvalue <=50%" ) label(4 " Pvalue >50%" ) label(5 "Inconclusive") label(6 "Accept equality at 5%" ) ) graphregion(fcolor(white) lcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))"
twoway 		(scatter GdomdPVALdomQTE_1  GdomtPVALdomQTE_1, mcolor(gs14) msize(huge) msymbol(square)) ///
	(scatter GdomdPVALdomQTE_2  GdomtPVALdomQTE_2, mcolor(gs11) msize(huge) msymbol(square)) ///
	(scatter GdomdPVALdomQTE_3  GdomtPVALdomQTE_3, mcolor(gs8) msize(huge) msymbol(square)) ///
	(scatter GdomdPVALdomQTE_4  GdomtPVALdomQTE_4, mcolor(gs5) msize(huge) msymbol(square)) ///	
	(scatter GdomdPVALdomQTE_5  GdomtPVALdomQTE_5, mcolor(black) msize(huge) msymbol(square_hollow)) ///	
	(scatter GdomdPVALeqQTE_ACCEPT  GdomtPVALeqQTE_ACCEPT if GdomdPVALeqF0_ACCEPT!=0 | GdomtPVALeqF0_ACCEPT != 0, mcolor(black) msize(medsmall) msymbol(circle)) ///	
	, `optplus'
*graph export graphs\joint_test_GAPcurve.png, replace wid(918) hei(668)


**************************************************************************
*		GRAPH 4: ALL in one
**************************************************************************

local optplus0 "ytitle("H0: Dominant distributions (by family income deciles)", size(small) color(black)) xtitle("H0: Dominated distributions (by family income deciles)", size(small) color(black)) yscale(range(0.5 10.5)) yscale(line extend fextend) ylabel(1(1)10, labels labsize(vsmall) angle(stdarrow) labgap(small) valuelabel grid glwidth(vvvthin) glcolor(gs9) glpattern(solid) gmin nogextend) xscale(range(0.5 10.5)) xscale(extend fextend) xlabel(1(1)10, labels labsize(vsmall) angle(stdarrow) labgap(tiny) valuelabel grid glwidth(vvvthin) glcolor(gs8) gmin gmax nogextend) legend(off) graphregion(fcolor(white) lcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))"
local optplus1 "ytitle("H0: Dominant QTE distrib. (by family income deciles)", size(small) color(black)) xtitle("H0: Dominated QTE distrib. (by family income deciles)", size(small) color(black)) yscale(range(0.5 10.5)) yscale(line extend fextend) ylabel(1(1)10, labels labsize(vsmall) angle(stdarrow) labgap(small) valuelabel grid glwidth(vvvthin) glcolor(gs9) glpattern(solid) gmin nogextend) xscale(range(0.5 10.5)) xscale(extend fextend) xlabel(1(1)10, labels labsize(vsmall) angle(stdarrow) labgap(tiny) valuelabel grid glwidth(vvvthin) glcolor(gs8) gmin gmax nogextend) legend(off) graphregion(fcolor(white) lcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))"
local optplus "ytitle("H0: Dominant QTE distrib. (by family income deciles)", size(small) color(black)) xtitle("H0: Dominated QTE distrib. (by family income deciles)", size(small) color(black)) yscale(range(0.5 10.5)) yscale(line extend fextend) ylabel(1(1)10, labels labsize(vsmall) angle(stdarrow) labgap(small) valuelabel grid glwidth(vvvthin) glcolor(gs9) glpattern(solid) gmin nogextend) xscale(range(0.5 10.5)) xscale(extend fextend) xlabel(1(1)10, labels labsize(vsmall) angle(stdarrow) labgap(tiny) valuelabel grid glwidth(vvvthin) glcolor(gs8) gmin gmax nogextend) legend(on cols(1) rows(6) size(small) color(black) position(3) label(1 "0<= Pvalue <= 5%") label(2 "5%< Pvalue <=10%" ) label(3 "10%< Pvalue <=50%" ) label(4 " Pvalue >50%" ) label(5 "Inconclusive") label(6 "Accept equality at 5%" ) ) graphregion(fcolor(white) lcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))"
twoway 		(scatter GdomdPVALdomF0_1  GdomtPVALdomF0_1, mcolor(gs14) msize(huge) msymbol(square)) ///
	(scatter GdomdPVALdomF0_2  GdomtPVALdomF0_2, mcolor(gs11) msize(huge) msymbol(square)) ///
	(scatter GdomdPVALdomF0_3  GdomtPVALdomF0_3, mcolor(gs8) msize(huge) msymbol(square)) ///
	(scatter GdomdPVALdomF0_4  GdomtPVALdomF0_4, mcolor(gs5) msize(huge) msymbol(square)) ///	
	(scatter GdomdPVALdomF0_5  GdomtPVALdomF0_5, mcolor(black) msize(huge) msymbol(square_hollow)) ///	
	(scatter GdomdPVALeqF0_ACCEPT  GdomtPVALeqF0_ACCEPT if GdomdPVALeqF0_ACCEPT!=0 | GdomtPVALeqF0_ACCEPT != 0, mcolor(black) msize(small) msymbol(circle)) ///	
	, `optplus0' title({bf: "Rank dominance joint tests, counterfactuals"},  position(0)) name(dom0, replace) nodraw
twoway 		(scatter GdomdPVALdomF1_1  GdomtPVALdomF1_1, mcolor(gs14) msize(huge) msymbol(square)) ///
	(scatter GdomdPVALdomF1_2  GdomtPVALdomF1_2, mcolor(gs11) msize(huge) msymbol(square)) ///
	(scatter GdomdPVALdomF1_3  GdomtPVALdomF1_3, mcolor(gs8) msize(huge) msymbol(square)) ///
	(scatter GdomdPVALdomF1_4  GdomtPVALdomF1_4, mcolor(gs5) msize(huge) msymbol(square)) ///	
	(scatter GdomdPVALdomF1_5  GdomtPVALdomF1_5, mcolor(black) msize(huge) msymbol(square_hollow)) ///	
	(scatter GdomdPVALeqF1_ACCEPT  GdomtPVALeqF1_ACCEPT if GdomdPVALeqF0_ACCEPT!=0 | GdomtPVALeqF0_ACCEPT != 0, mcolor(black) msize(small) msymbol(circle)) ///	
	, `optplus1' title({bf: "Rank dominance joint tests, actuals"},  position(0)) name(dom1, replace) nodraw
twoway 		(scatter GdomdPVALdomQTE_1  GdomtPVALdomQTE_1, mcolor(gs14) msize(huge) msymbol(square)) ///
	(scatter GdomdPVALdomQTE_2  GdomtPVALdomQTE_2, mcolor(gs11) msize(huge) msymbol(square)) ///
	(scatter GdomdPVALdomQTE_3  GdomtPVALdomQTE_3, mcolor(gs8) msize(huge) msymbol(square)) ///
	(scatter GdomdPVALdomQTE_4  GdomtPVALdomQTE_4, mcolor(gs5) msize(huge) msymbol(square)) ///	
	(scatter GdomdPVALdomQTE_5  GdomtPVALdomQTE_5, mcolor(black) msize(huge) msymbol(square_hollow)) ///	
	(scatter GdomdPVALeqQTE_ACCEPT  GdomtPVALeqQTE_ACCEPT if GdomdPVALeqF0_ACCEPT!=0 | GdomtPVALeqF0_ACCEPT != 0, mcolor(black) msize(small) msymbol(circle)) ///	
	, `optplus' title({bf: "Gap curves dominance joint test"},  position(0)) name(gap, replace) nodraw
graph combine dom0 dom1 gap, rows(2) graphregion(fcolor(white) lcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
*graph export graphs\joint_test_ALL.png, replace wid(918) hei(668)

local optplus0 "ytitle("H0: Dominant distributions (by family income deciles)", size(small) color(black)) xtitle("H0: Dominated distributions (by family income deciles)", size(small) color(black)) yscale(range(0.5 10.5)) yscale(line extend fextend) ylabel(1(1)10, labels labsize(vsmall)  labgap(small) valuelabel grid glwidth(vvvthin) glcolor(gs9) glpattern(solid) gmin nogextend) xscale(range(0.5 10.5)) xscale(extend fextend) xlabel(1(1)10, labels labsize(vsmall)  labgap(tiny) valuelabel grid glwidth(vvvthin) glcolor(gs8) gmin gmax nogextend) legend(off) graphregion(fcolor(white) lcolor(white) margin(l-1 r-1 )) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))  aspectratio(1) ysize(4) xsize(4)"
local optplus1 "ytitle("H0: Dominant distributions (by family income deciles)", size(small) color(black)) xtitle("H0: Dominated distributions (by family income deciles)", size(small) color(black)) yscale(range(0.5 10.5)) yscale(line extend fextend) ylabel(1(1)10, labels labsize(vsmall)  labgap(small) valuelabel grid glwidth(vvvthin) glcolor(gs9) glpattern(solid) gmin nogextend) xscale(range(0.5 10.5)) xscale(extend fextend) xlabel(1(1)10, labels labsize(vsmall)  labgap(tiny) valuelabel grid glwidth(vvvthin) glcolor(gs8) gmin gmax nogextend) legend(off) graphregion(fcolor(white) lcolor(white) margin(l-1 r-1 )) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) aspectratio(1) ysize(4) xsize(4) "
local optplus "ytitle("H0: Dominant QTE distrib. (by family income deciles)", size(small) color(black)) xtitle("H0: Dominated QTE distrib. (by family income deciles)", size(small) color(black)) yscale(range(0.5 10.5)) yscale(line extend fextend) ylabel(1(1)10, labels labsize(vsmall) labgap(small) valuelabel grid glwidth(vvvthin) glcolor(gs9) glpattern(solid) gmin nogextend) xscale(range(0.5 10.5)) xscale(extend fextend) xlabel(1(1)10, labels labsize(vsmall)  labgap(tiny) valuelabel grid glwidth(vvvthin) glcolor(gs8) gmin gmax nogextend) legend(on order( - "P-value range:" 1 2 3 4 5 6) cols(1) rows(7) size(vsmall)  color(black) position(3) rowgap(5)  label(1 "[0 - 5%]") label(2 "(5% - 10%]") label(3 "(10% - 50%]" ) label(4 " > 50%" ) label(5 "Inconclusive") label(6 "Accept equality" "at 5%" ) width(22) height(80)) graphregion(fcolor(white) lcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) aspectratio(1) ysize(4) xsize(5.2)"
twoway 		(scatter GdomdPVALdomF0_1  GdomtPVALdomF0_1, mcolor(gs14) msize(huge) msymbol(square)) ///
	(scatter GdomdPVALdomF0_2  GdomtPVALdomF0_2, mcolor(gs11) msize(huge) msymbol(square)) ///
	(scatter GdomdPVALdomF0_3  GdomtPVALdomF0_3, mcolor(gs8) msize(huge) msymbol(square)) ///
	(scatter GdomdPVALdomF0_4  GdomtPVALdomF0_4, mcolor(gs5) msize(huge) msymbol(square)) ///	
	(scatter GdomdPVALdomF0_5  GdomtPVALdomF0_5, mcolor(black) msize(huge) msymbol(square_hollow)) ///	
	(scatter GdomdPVALeqF0_ACCEPT  GdomtPVALeqF0_ACCEPT if GdomdPVALeqF0_ACCEPT!=0 | GdomtPVALeqF0_ACCEPT != 0, mcolor(black) msize(small) msymbol(circle)) ///	
	, `optplus0' 
*graph export joint_test_F0nol.png, replace wid(1500) hei(1500)
graph export joint_test_F0nol.pdf, replace 
twoway 		(scatter GdomdPVALdomF1_1  GdomtPVALdomF1_1, mcolor(gs14) msize(huge) msymbol(square)) ///
	(scatter GdomdPVALdomF1_2  GdomtPVALdomF1_2, mcolor(gs11) msize(huge) msymbol(square)) ///
	(scatter GdomdPVALdomF1_3  GdomtPVALdomF1_3, mcolor(gs8) msize(huge) msymbol(square)) ///
	(scatter GdomdPVALdomF1_4  GdomtPVALdomF1_4, mcolor(gs5) msize(huge) msymbol(square)) ///	
	(scatter GdomdPVALdomF1_5  GdomtPVALdomF1_5, mcolor(black) msize(huge) msymbol(square_hollow)) ///	
	(scatter GdomdPVALeqF1_ACCEPT  GdomtPVALeqF1_ACCEPT if GdomdPVALeqF0_ACCEPT!=0 | GdomtPVALeqF0_ACCEPT != 0, mcolor(black) msize(small) msymbol(circle)) ///	
	, `optplus1' 
*graph export joint_test_F1nol.png, replace wid(1500) hei(1500)
graph export joint_test_F1nol.pdf, replace 
twoway 		(scatter GdomdPVALdomQTE_1  GdomtPVALdomQTE_1, mcolor(gs14) msize(huge) msymbol(square)) ///
	(scatter GdomdPVALdomQTE_2  GdomtPVALdomQTE_2, mcolor(gs11) msize(huge) msymbol(square)) ///
	(scatter GdomdPVALdomQTE_3  GdomtPVALdomQTE_3, mcolor(gs8) msize(huge) msymbol(square)) ///
	(scatter GdomdPVALdomQTE_4  GdomtPVALdomQTE_4, mcolor(gs5) msize(huge) msymbol(square)) ///	
	(scatter GdomdPVALdomQTE_5  GdomtPVALdomQTE_5, mcolor(black) msize(huge) msymbol(square_hollow)) ///	
	(scatter GdomdPVALeqQTE_ACCEPT  GdomtPVALeqQTE_ACCEPT if GdomdPVALeqF0_ACCEPT!=0 | GdomtPVALeqF0_ACCEPT != 0, mcolor(black) msize(small) msymbol(circle)) ///	
	, `optplus' 
*graph export joint_test_QTEnol.png, replace wid(1950) hei(1500)
graph export joint_test_QTEnol.pdf, replace 
