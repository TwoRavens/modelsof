clear all
set memo 100m
capture log close

log using tpmaster, replace text

cd "C:\Users\rujia\Dropbox\Replication\treatyports"



/***This file generate figures 2A-2D***
***notes on data
***data/4waves: average population over time
data/AverageGDPper.dta: average gdp per capita over time
data/AverageGDPlog.dta: average log (gdp per capita) over time
*/

use data/4waves.dta, clear

label var controlgroup Control


#delimit ;


graph twoway (connect wave1 year, ms(s) mcolor(black) lcolor(black))
(connect wave2 year, ms(+) mcolor(black) lcolor(black))  
(connect wave3 year, ms(oh) mcolor(black) lcolor(black)) 
(connect wave4 year, ms(dh) mcolor(black) lcolor(black)) 
(connect controlgroup year, ms(o) lc(maroon) mc(maroon) lpattern(dash) mcolor(black) lcolor(black)), 
graphregion(color(white))
xline(1842 1860 1870 1880) 
legend (row (2)) 
text(1200 1830  "wave 1")  
text(1200 1856  "2") 
text(1200 1866  "3") 
text(1200 1876  "4") 
text(1200 2001  "wave 1") 
text(650 2001  "wave 2")
text(370 2001  "wave 3") 
text(870 1999  "wave 4") 
xtitle (year) ytitle (POPU);

graph export draft/Figure2A.png, replace;


graph twoway (connect treatyports year, ms(diamond) msize(vsmall)  mcolor(black) lcolor(black))
(connect controlgroup year, ms(oh) lpattern(dash)  mcolor(black) lcolor(black)),
graphregion(color(white))
xline(1842 1949 1980) legend (row (1)) 
text(900 1800  "closed")  
text(900 1900  "forced to open") 
text(900 1965  "closed") 
text(900 1990  "open") 
xtitle (year) ytitle (POPU);
graph export draft/Figure2B.png, replace;

******

use data/AverageGDPper.dta, clear;
graph twoway (connect treatyports year, ms(diamond) msize(vsmall)  mcolor(black) lcolor(black))
(connect control year, ms(oh) lpattern(dash) mcolor(black) lcolor(black)),
graphregion(color(white))
xtitle (year) ytitle (GDP per capita);
graph export draft/Figure2C.png, replace;



use data/AverageGDPlog.dta, clear;
graph twoway (connect treatyports year, ms(diamond) msize(vsmall)  mcolor(black) lcolor(black))
(connect control year, ms(oh) lpattern(dash) mcolor(black) lcolor(black)),
graphregion(color(white))
xtitle (year) ytitle (log (GDP per capita));
graph export draft/Figure2D.png, replace;
