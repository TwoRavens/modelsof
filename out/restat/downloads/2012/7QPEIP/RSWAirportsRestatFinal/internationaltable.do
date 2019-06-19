
#delimit ;
clear all;
set mem 200m;
set matsize 1200;
version 10;
set more off;
set scheme s1mono;
use data\internationaltable-final.dta;

***************************************************************;
**** THIS FILE ANALYSES THE INTERNATIONAL DATA REPORTED IN ****;
**** SECTION 6.1 IN THE PAPER                              ****;
***************************************************************;

* Graph data;

lab var mshare_1_air_37 "Market Share 1937";

* Reg with Frankfurt;

reg mshare_1_air_decker_02 mshare_1_air_37 , robust noconstant;
test _b[mshare_1_air_37]=1;

reg mshare_1_air_decker_02 mshare_1_air_37 , robust;
predict fitted_cur,xb;

twoway (scatter mshare_1_air_decker_02 mshare_1_air_37 , msymbol(Oh) )
(scatter mshare_1_air_decker_02 mshare_1_air_37, msymbol(i) mlabel(country) mlabposition(12) )
(scatter mshare_1_air_37 mshare_1_air_37, c(l) msymbol(i) ),
legend(order (1 3) lab(1 "Actual Market Share") lab(3 "Linear Prediction"))
ytitle("Market Share 2002",margin(medium))
title("Market Share of Largest 1937 Airport in 1937 and 2002",margin(medium));

