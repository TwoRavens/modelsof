
******************************************************************************
******************************************************************************

** National Elections and the Dynamics of International Negotiations - 2016 **

******************************************************************************
******************************************************************************


**************
*** GRAPHS ***
**************


use "Output\NATEL_output.dta"

**Generate confidence interval upper and lower bounds**

gen z95=invnormal(0.975) 

gen cilb_lgpret=coef_lgpret-z95*coef_lgpret_se
gen ciub_lgpret=coef_lgpret+z95*coef_lgpret_se

gen cilb_smpret=coef_smpret-z95*coef_smpret_se
gen ciub_smpret=coef_smpret+z95*coef_smpret_se

gen cilb_lgprent=coef_lgprent-z95*coef_lgprent_se
gen ciub_lgprent=coef_lgprent+z95*coef_lgprent_se

gen cilb_smprent=coef_smprent-z95*coef_smprent_se
gen ciub_smprent=coef_smprent+z95*coef_smprent_se


**Generate relative hazard ratios and confidence intervals**
gen relhaz_lgpret=exp(coef_lgpret)
gen relhaz_lgpret_cilb=exp(cilb_lgpret)
gen relhaz_lgpret_ciub=exp(ciub_lgpret)

gen relhaz_smpret=exp(coef_smpret)
gen relhaz_smpret_cilb=exp(cilb_smpret)
gen relhaz_smpret_ciub=exp(ciub_smpret)

gen relhaz_lgprent=exp(coef_lgprent)
gen relhaz_lgprent_cilb=exp(cilb_lgprent)
gen relhaz_lgprent_ciub=exp(ciub_lgprent)

gen relhaz_smprent=exp(coef_smprent)
gen relhaz_smprent_cilb=exp(cilb_smprent)
gen relhaz_smprent_ciub=exp(ciub_smprent)

save "Output\NATEL_output.dta", replace

**Draw graph large states**
twoway (line relhaz_lgpret Time if Time <= 600, lcolor(black) ) ///
(line relhaz_lgpret_cilb Time if Time <= 600, lcolor(black) lpattern(shortdash) lwidth(vthin)) ///
(line relhaz_lgpret_ciub Time if Time <= 600, lcolor(black) lpattern(shortdash) lwidth(vthin)) ///
(line relhaz_lgprent Time if Time <= 600, lcolor(gray)) ///
(line relhaz_lgprent_cilb Time if Time <= 600, lcolor(gray) lpattern(shortdash) lwidth(vthin)) ///
(line relhaz_lgprent_ciub Time if Time <= 600, lcolor(gray) lpattern(shortdash) lwidth(vthin)), ///
title("Relative hazard in large states") ysize(6) xsize(4.5) ///
legend(region(style(none)) order(1 4) label(1 "Close elections") label(4 "Non-close elections")) ///
xtitle("Time") ytitle("Relative Hazard") yscale(range(0.2 1.2)) ytick(#5)

graph save "Output\Graph2large.gph", replace
graph export "Output\Graph2large.png", as(png) replace

**Draw graph small states**
twoway (line relhaz_smpret Time if Time <= 600, lcolor(black) ) ///
(line relhaz_smpret_cilb Time if Time <= 600, lcolor(black) lpattern(shortdash) lwidth(vthin)) ///
(line relhaz_smpret_ciub Time if Time <= 600, lcolor(black) lpattern(shortdash) lwidth(vthin)) ///
(line relhaz_smprent Time if Time <= 600, lcolor(gray)) ///
(line relhaz_smprent_cilb Time if Time <= 600, lcolor(gray) lpattern(shortdash) lwidth(vthin)) ///
(line relhaz_smprent_ciub Time if Time <= 600, lcolor(gray) lpattern(shortdash) lwidth(vthin)), ///
title("Relative hazard in small states") ysize(6) xsize(4.5) ///
legend(region(style(none)) order(1 4) label(1 "Close elections") label(4 "Non-close elections")) ///
xtitle("Time") ytitle("Relative Hazard") yscale(range(0.2 1.2)) ytick(#5)

graph save "Output\Graph2small.gph", replace
graph export "Output\Graph2small.png", as(png) replace




