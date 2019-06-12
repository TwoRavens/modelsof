********************************************************************************
*Plot all results
********************************************************************************




*plot all survival estimates in a single graph
grc1leg order1_B.gph order2_B.gph order3_B.gph order4_B.gph order5_B.gph, /* 
*/		col(1) subtitle("Original model") saving(col1, replace) /* 
*/		leg(order1_B.gph) ycommon
grc1leg order1.gph order2.gph order3.gph order4.gph order5.gph, col(1) /* 
*/		subtitle("Restricted model") saving(col2, replace) leg(order1.gph) /*
*/		ycommon
grc1leg col1.gph col2.gph, ycommon /* 
*/		xcommon leg(col2.gph) l2("Proportion of cases still at peace") /* 
*/		b2("Days at peace", ring(0) size(small)) ring(5) col(2) 
graph display, ysize(10)
graph export Beardsley_survival_atmean_strata_wRP.pdf, as(pdf) replace


*plot difference in survival estimate
twoway line sdiff* _t if _t<3650 & order==1, sort yline(0, lp(dot) lc(black)) /* 
*/		lpattern(solid shortdash shortdash) lc(black black black) legend(off) /* 
*/		xtitle("Days at peace") ytitle("Difference in survival") 
graph export Beardsley_sdiff_atmean.pdf, as(pdf) replace



