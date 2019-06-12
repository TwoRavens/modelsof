use dta\Turnout_District_Level, clear 

twoway (kdensity turnout if year<1920, lwidth(vthin)) (kdensity turnout if year>1920 & year<1930, lwidth(medthick)), ///
title("") xtitle(Turnout) ytitle("") legend(order(1 "1909-1918" 2 "1921-1927"  ) pos(1) ring(0) col(1)) ///
plotregion(lcolor(white) ilcolor(white)) graphregion(fcolor(white)) scheme(s2mono) 
*graph export figures\kdensity_pre_post_v2.tif, replace
*graph export figures\kdensity_pre_post_v2.eps, replace
graph export figures\Figure2.tif, replace
graph export figures\Figure2.eps, replace
