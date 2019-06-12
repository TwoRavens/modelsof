
* Non-parametric Analysis

use book-basedata-replication, clear

*replicate Beardsleys graph with non-parametric hazard estimate
sts graph if _t<3650, hazard by(med2) ci saving(bh.gph) title("") /*
*/		subtitle("a) Smoothed hazard estimates") xtitle("Days at peace") /*
*/		ci2(fc(none) lc(black) lp(shortdash)) plot2(lc(black) fi(inten100)) /*
*/		ci1(fc(gs14) lc(gs14)) plot1(lc(gs10) fi(inten100))

*calculate Kaplan-Meier survival function
sts graph if _t<3650, by(med2) ci saving(km.gph) title("") /*
*/		subtitle("b) Kaplan-Meier survival estimates") xtitle("Days at peace") /*
*/		ci2(fc(none) lc(black) lp(shortdash)) plot2(lc(black) fi(inten100)) /*
*/		ci1(fc(gs14) lc(gs14)) plot1(lc(gs10) fi(inten100)) /*
*/		legend(order(5 6) label(5 "No mediation") label(6 "Mediation") /*
*/		region(lwidth(none)) row(1)) 

grc1leg bh.gph km.gph, leg(km.gph)
graph display, ysize(3) 
graph export Beardsley_nonparametric.pdf, as(pdf) replace
erase km.gph
erase bh.gph
