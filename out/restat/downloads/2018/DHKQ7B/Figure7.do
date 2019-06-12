clear
set more off
pwd 
cd "[INSERT LOCAL DIRECTORY HERE]"

** select data necessary for estimation
import delimited "datavssimulation.csv"


rename v1 donated_amount
rename v2 default
rename v3 simulation10
rename v4 simulation20
rename v5 simulation50
save _data/datavssimulation, replace

twoway__histogram_gen donated_amount if default==10,  start(-0.5) width(1) gen(donation10 x10)
twoway__histogram_gen simulation10,  start(-0.5) width(1) gen (simulation10rel x10s)
twoway__histogram_gen donated_amount if default==20,  start(-0.5) width(1) gen(donation20 x20)
twoway__histogram_gen simulation20,  start(-0.5) width(1) gen (simulation20rel x20s)
twoway__histogram_gen donated_amount if default==50,  start(-0.5) width(1) gen(donation50 x50)
twoway__histogram_gen simulation50,  start(-0.5) width(1) gen (simulation50rel x50s)

graph twoway (bar donation10 x10 if inrange(x10,0,100), barwidth(2.5) fcolor(gs10) lcolor(gs10)) ///
(bar simulation10rel x10s if inrange(x10s,0,100),  fcolor(none) lcolor(0) lwidth(medium) barwidth(2.5)) ,  ///
 graphregion(color(none)) bgcolor(white) xlabel(0 10 20 50 100, labs(3)) ///
 yline(0, lcolor(black)) ylabel(0[.1].3, nogrid labs(3))  ///
 xtitle(Donated Amount, si(3)) ytitle("Relative Frequency", si(3)) title("10")  legend(cols(1) size(vsmall) ///
 order(1 "Data" 2 "Simulation" )) name(g1, replace ) nodraw

graph twoway (bar donation20 x20 if inrange(x20,0,100), barwidth(2.5) fcolor(gs10) lcolor(gs10)) ///
(bar simulation20rel x20s if inrange(x20s,0,100),  fcolor(none) lcolor(0)  lwidth(medium) barwidth(2.5)) ,  ///
 graphregion(color(none)) bgcolor(white)  xlabel(0 10 20 50 100, labs(3)) ///
 yline(0, lcolor(black)) ylabel(0[.1].3, nogrid labs(3))  ///
 xtitle(Donated Amount, si(3)) ytitle("Relative Frequency", si(3)) title("20") ///
 legend(order(1 "Data" 2 "Simulation" )) name(g2, replace) nodraw

graph twoway (bar donation50 x50 if inrange(x50,0,100), barwidth(2.5) fcolor(gs10) lcolor(gs10)) ///
(bar simulation50rel x50s if inrange(x50s,0,100),  fcolor(none) lcolor(0)  lwidth(medium) barwidth(2.5)) ,  ///
 graphregion(color(none)) bgcolor(white) xlabel(0 10 20 50 100, labs(3)) ///
 yline(0, lcolor(black)) ylabel(0[.1].3, nogrid labs(3))  ///
 xtitle(Donated Amount, si(3)) ytitle("Relative Frequency", si(3)) title("50")  ///
 legend(order(1 "Data" 2 "Simulation" )) name(g3, replace) nodraw

grc1leg g1 g2 g3, legendfrom(g1) ring(0) position(5) graphregion(color(white)) ///
		xcommon ycommon altshrink scale(1.6)
graph export Figure7.pdf, as(pdf) replace


