* This file produces Figure 2 in the text and Figures A2.4 and A2.5 and Table A2.8 in the web appendix
clear
capture log close
cd C:\learning
log using learningresults.log, replace

*Proces simulation data
insheet treatment match G coope0 coope1 coope2 coope3 coope4 coope5 coope6 coope7 coope8 coope9 coope10 coope11 coope12 coope13 coope14 foo using simulationresults.txt, tab
gen lowlimit90 = 0 if coope0>49
replace lowlimit90 = 1/14 if coope0<50 & coope0+coope1>49
replace lowlimit90 = 2/14 if coope0+coope1<50 & coope0+coope1+coope2>49
replace lowlimit90 = 3/14 if coope0+coope1+coope2<50 & coope0+coope1+coope2+coope3>49
replace lowlimit90 = 4/14 if coope0+coope1+coope2+coope3<50 & coope0+coope1+coope2+coope3+coope4>49
replace lowlimit90 = 5/14 if coope0+coope1+coope2+coope3+coope4<50 & coope0+coope1+coope2+coope3+coope4+coope5>49
replace lowlimit90 = 6/14 if coope0+coope1+coope2+coope3+coope4+coope5<50 & coope0+coope1+coope2+coope3+coope4+coope5+coope6>49
replace lowlimit90 = 7/14 if coope0+coope1+coope2+coope3+coope4+coope5+coope6<50 & coope0+coope1+coope2+coope3+coope4+coope5+coope6+coope7>49
replace lowlimit90 = 8/14 if coope0+coope1+coope2+coope3+coope4+coope5+coope6+coope7<50 & coope0+coope1+coope2+coope3+coope4+coope5+coope6+coope7+coope8>49
replace lowlimit90 = 9/14 if coope0+coope1+coope2+coope3+coope4+coope5+coope6+coope7+coope8<50 & coope0+coope1+coope2+coope3+coope4+coope5+coope6+coope7+coope8+coope9>49
replace lowlimit90 = 10/14 if coope0+coope1+coope2+coope3+coope4+coope5+coope6+coope7+coope8+coope9<50 & coope0+coope1+coope2+coope3+coope4+coope5+coope6+coope7+coope8+coope9+coope10>49
replace lowlimit90 = 11/14 if coope0+coope1+coope2+coope3+coope4+coope5+coope6+coope7+coope8+coope9+coope10<50 & coope0+coope1+coope2+coope3+coope4+coope5+coope6+coope7+coope8+coope9+coope10+coope11>49
replace lowlimit90 = 12/14 if coope0+coope1+coope2+coope3+coope4+coope5+coope6+coope7+coope8+coope9+coope10+coope11<50 & coope0+coope1+coope2+coope3+coope4+coope5+coope6+coope7+coope8+coope9+coope10+coope11+coope12>49
replace lowlimit90 = 13/14 if coope0+coope1+coope2+coope3+coope4+coope5+coope6+coope7+coope8+coope9+coope10+coope11+coope12<50 & coope0+coope1+coope2+coope3+coope4+coope5+coope6+coope7+coope8+coope9+coope10+coope11+coope12+coope13>49
replace lowlimit90 = 14/14 if coope0+coope1+coope2+coope3+coope4+coope5+coope6+coope7+coope8+coope9+coope10+coope11+coope12+coope13<50 & coope0+coope1+coope2+coope3+coope4+coope5+coope6+coope7+coope8+coope9+coope10+coope11+coope12+coope13+coope14>49

gen upplimit90 = 1 if coope14>49
replace upplimit90 = 13/14 if coope14<50 & coope13+coope14>49
replace upplimit90 = 12/14 if coope13+coope14<50 & coope12+coope13+coope14>49
replace upplimit90 = 11/14 if coope12+coope13+coope14<50 & coope11+coope12+coope13+coope14>49
replace upplimit90 = 10/14 if coope11+coope12+coope13+coope14<50 & coope10+coope11+coope12+coope13+coope14>49
replace upplimit90 = 9/14 if coope10+coope11+coope12+coope13+coope14<50 & coope9+coope10+coope11+coope12+coope13+coope14>49
replace upplimit90 = 8/14 if coope9+coope10+coope11+coope12+coope13+coope14<50 & coope8+coope9+coope10+coope11+coope12+coope13+coope14>49
replace upplimit90 = 7/14 if coope8+coope9+coope10+coope11+coope12+coope13+coope14<50 & coope7+coope8+coope9+coope10+coope11+coope12+coope13+coope14>49
replace upplimit90 = 6/14 if coope7+coope8+coope9+coope10+coope11+coope12+coope13+coope14<50 & coope6+coope7+coope8+coope9+coope10+coope11+coope12+coope13+coope14>49
replace upplimit90 = 5/14 if coope6+coope7+coope8+coope9+coope10+coope11+coope12+coope13+coope14<50 & coope5+coope6+coope7+coope8+coope9+coope10+coope11+coope12+coope13+coope14>49
replace upplimit90 = 4/14 if coope5+coope6+coope7+coope8+coope9+coope10+coope11+coope12+coope13+coope14<50 & coope4+coope5+coope6+coope7+coope8+coope9+coope10+coope11+coope12+coope13+coope14>49
replace upplimit90 = 3/14 if coope4+coope5+coope6+coope7+coope8+coope9+coope10+coope11+coope12+coope13+coope14<50 & coope3+coope4+coope5+coope6+coope7+coope8+coope9+coope10+coope11+coope12+coope13+coope14>49
replace upplimit90 = 2/14 if coope3+coope4+coope5+coope6+coope7+coope8+coope9+coope10+coope11+coope12+coope13+coope14<50 & coope2+coope3+coope4+coope5+coope6+coope7+coope8+coope9+coope10+coope11+coope12+coope13+coope14>49
replace upplimit90 = 1/14 if coope2+coope3+coope4+coope5+coope6+coope7+coope8+coope9+coope10+coope11+coope12+coope13+coope14<50 & coope1+coope2+coope3+coope4+coope5+coope6+coope7+coope8+coope9+coope10+coope11+coope12+coope13+coope14>49
replace upplimit90 = 0 if coope1+coope2+coope3+coope4+coope5+coope6+coope7+coope8+coope9+coope10+coope11+coope12+coope13+coope14<50 & coope0+coope1+coope2+coope3+coope4+coope5+coope6+coope7+coope8+coope9+coope10+coope11+coope12+coope13+coope14>49

sort treatment match
save simulationresults, replace

*Cross (uses only estimates from other treatments)
clear
insheet treatment match G coope0 coope1 coope2 coope3 coope4 coope5 coope6 coope7 coope8 coope9 coope10 coope11 coope12 coope13 coope14 foo using simulationresultscross.txt, tab
gen lowlimit90 = 0 if coope0>49
replace lowlimit90 = 1/14 if coope0<50 & coope0+coope1>49
replace lowlimit90 = 2/14 if coope0+coope1<50 & coope0+coope1+coope2>49
replace lowlimit90 = 3/14 if coope0+coope1+coope2<50 & coope0+coope1+coope2+coope3>49
replace lowlimit90 = 4/14 if coope0+coope1+coope2+coope3<50 & coope0+coope1+coope2+coope3+coope4>49
replace lowlimit90 = 5/14 if coope0+coope1+coope2+coope3+coope4<50 & coope0+coope1+coope2+coope3+coope4+coope5>49
replace lowlimit90 = 6/14 if coope0+coope1+coope2+coope3+coope4+coope5<50 & coope0+coope1+coope2+coope3+coope4+coope5+coope6>49
replace lowlimit90 = 7/14 if coope0+coope1+coope2+coope3+coope4+coope5+coope6<50 & coope0+coope1+coope2+coope3+coope4+coope5+coope6+coope7>49
replace lowlimit90 = 8/14 if coope0+coope1+coope2+coope3+coope4+coope5+coope6+coope7<50 & coope0+coope1+coope2+coope3+coope4+coope5+coope6+coope7+coope8>49
replace lowlimit90 = 9/14 if coope0+coope1+coope2+coope3+coope4+coope5+coope6+coope7+coope8<50 & coope0+coope1+coope2+coope3+coope4+coope5+coope6+coope7+coope8+coope9>49
replace lowlimit90 = 10/14 if coope0+coope1+coope2+coope3+coope4+coope5+coope6+coope7+coope8+coope9<50 & coope0+coope1+coope2+coope3+coope4+coope5+coope6+coope7+coope8+coope9+coope10>49
replace lowlimit90 = 11/14 if coope0+coope1+coope2+coope3+coope4+coope5+coope6+coope7+coope8+coope9+coope10<50 & coope0+coope1+coope2+coope3+coope4+coope5+coope6+coope7+coope8+coope9+coope10+coope11>49
replace lowlimit90 = 12/14 if coope0+coope1+coope2+coope3+coope4+coope5+coope6+coope7+coope8+coope9+coope10+coope11<50 & coope0+coope1+coope2+coope3+coope4+coope5+coope6+coope7+coope8+coope9+coope10+coope11+coope12>49
replace lowlimit90 = 13/14 if coope0+coope1+coope2+coope3+coope4+coope5+coope6+coope7+coope8+coope9+coope10+coope11+coope12<50 & coope0+coope1+coope2+coope3+coope4+coope5+coope6+coope7+coope8+coope9+coope10+coope11+coope12+coope13>49
replace lowlimit90 = 14/14 if coope0+coope1+coope2+coope3+coope4+coope5+coope6+coope7+coope8+coope9+coope10+coope11+coope12+coope13<50 & coope0+coope1+coope2+coope3+coope4+coope5+coope6+coope7+coope8+coope9+coope10+coope11+coope12+coope13+coope14>49

gen upplimit90 = 1 if coope14>49
replace upplimit90 = 13/14 if coope14<50 & coope13+coope14>49
replace upplimit90 = 12/14 if coope13+coope14<50 & coope12+coope13+coope14>49
replace upplimit90 = 11/14 if coope12+coope13+coope14<50 & coope11+coope12+coope13+coope14>49
replace upplimit90 = 10/14 if coope11+coope12+coope13+coope14<50 & coope10+coope11+coope12+coope13+coope14>49
replace upplimit90 = 9/14 if coope10+coope11+coope12+coope13+coope14<50 & coope9+coope10+coope11+coope12+coope13+coope14>49
replace upplimit90 = 8/14 if coope9+coope10+coope11+coope12+coope13+coope14<50 & coope8+coope9+coope10+coope11+coope12+coope13+coope14>49
replace upplimit90 = 7/14 if coope8+coope9+coope10+coope11+coope12+coope13+coope14<50 & coope7+coope8+coope9+coope10+coope11+coope12+coope13+coope14>49
replace upplimit90 = 6/14 if coope7+coope8+coope9+coope10+coope11+coope12+coope13+coope14<50 & coope6+coope7+coope8+coope9+coope10+coope11+coope12+coope13+coope14>49
replace upplimit90 = 5/14 if coope6+coope7+coope8+coope9+coope10+coope11+coope12+coope13+coope14<50 & coope5+coope6+coope7+coope8+coope9+coope10+coope11+coope12+coope13+coope14>49
replace upplimit90 = 4/14 if coope5+coope6+coope7+coope8+coope9+coope10+coope11+coope12+coope13+coope14<50 & coope4+coope5+coope6+coope7+coope8+coope9+coope10+coope11+coope12+coope13+coope14>49
replace upplimit90 = 3/14 if coope4+coope5+coope6+coope7+coope8+coope9+coope10+coope11+coope12+coope13+coope14<50 & coope3+coope4+coope5+coope6+coope7+coope8+coope9+coope10+coope11+coope12+coope13+coope14>49
replace upplimit90 = 2/14 if coope3+coope4+coope5+coope6+coope7+coope8+coope9+coope10+coope11+coope12+coope13+coope14<50 & coope2+coope3+coope4+coope5+coope6+coope7+coope8+coope9+coope10+coope11+coope12+coope13+coope14>49
replace upplimit90 = 1/14 if coope2+coope3+coope4+coope5+coope6+coope7+coope8+coope9+coope10+coope11+coope12+coope13+coope14<50 & coope1+coope2+coope3+coope4+coope5+coope6+coope7+coope8+coope9+coope10+coope11+coope12+coope13+coope14>49
replace upplimit90 = 0 if coope1+coope2+coope3+coope4+coope5+coope6+coope7+coope8+coope9+coope10+coope11+coope12+coope13+coope14<50 & coope0+coope1+coope2+coope3+coope4+coope5+coope6+coope7+coope8+coope9+coope10+coope11+coope12+coope13+coope14>49

sort treatment match
save simulationresultscross, replace

*Simulation results
use datdf1, clear
keep if round==1
collapse coop, by (treatment match)
sort treatment match
merge treatment match using simulationresults

*data for comment on text about aggregate fit of simulations
gen difference=coop-g
gen absdiff=abs(difference)

gen goodrange=1 if treatment==1 & match<60
replace goodrange=1 if treatment==2 & match<72
replace goodrange=1 if treatment==3 & match<69
replace goodrange=1 if treatment==4 & match<28
replace goodrange=1 if treatment==5 & match<24
replace goodrange=1 if treatment==6 & match<30

sum absdiff if goodrange==1, detail


*Figure 2

twoway (line coop match if treatment==1 & match<=59, title(delta=.5 r=32) subtitle(Neither SGPE nor RD) legend(off) graphregion(color(white)) xtitle("Repeated Game (log scale)") ytitle("Cooperation") yscale(range(0 1)) ylabel(#11) xscale(log) xlabel(1 5 10 20 40 100 300 1000)) (line g match if treatment==1, lpattern(dash)) (line lowlimit90 match if treatment==1,  lpattern(dot) lcolor(cranberry)) (line upplimit90 match if treatment==1, lpattern(dot) lcolor(cranberry)), saving(graphd5r32,replace)
twoway (line coop match if treatment==2 & match<=71, title(delta=.5 r=40) subtitle(SGPE) legend(off) graphregion(color(white)) xtitle("Repeated Game (log scale)") ytitle("Cooperation") yscale(range(0 1)) ylabel(#11) xscale(log) xlabel(1 5 10 20 40 100 300 1000)) (line g match if treatment==2, lpattern(dash)) (line lowlimit90 match if treatment==2,  lpattern(dot) lcolor(cranberry)) (line upplimit90 match if treatment==2, lpattern(dot) lcolor(cranberry)), saving(graphd5r40,replace)
twoway (line coop match if treatment==3 & match<=68, title(delta=.5 r=48) subtitle(SGPE & RD) legend(off) graphregion(color(white)) xtitle("Repeated Game (log scale)") ytitle("Cooperation") yscale(range(0 1)) ylabel(#11) xscale(log) xlabel(1 5 10 20 40 100 300 1000)) (line g match if treatment==3, lpattern(dash)) (line lowlimit90 match if treatment==3,  lpattern(dot) lcolor(cranberry)) (line upplimit90 match if treatment==3, lpattern(dot) lcolor(cranberry)), saving(graphd5r48,replace)
twoway (line coop match if treatment==4 & match<=27, title(delta=.75 r=32) subtitle(SGPE) legend(off) graphregion(color(white)) xtitle("Repeated Game (log scale)") ytitle("Cooperation") yscale(range(0 1)) ylabel(#11) xscale(log) xlabel(1 5 10 20 40 100 300 1000)) (line g match if treatment==4, lpattern(dash)) (line lowlimit90 match if treatment==4,  lpattern(dot) lcolor(cranberry)) (line upplimit90 match if treatment==4, lpattern(dot) lcolor(cranberry)), saving(graphd75r32,replace)
twoway (line coop match if treatment==5 & match<=23, title(delta=.75 r=40) subtitle(SGPE & RD) legend(off) graphregion(color(white)) xtitle("Repeated Game (log scale)") ytitle("Cooperation") yscale(range(0 1)) ylabel(#11) xscale(log) xlabel(1 5 10 20 40 100 300 1000)) (line g match if treatment==5, lpattern(dash)) (line lowlimit90 match if treatment==5,  lpattern(dot) lcolor(cranberry)) (line upplimit90 match if treatment==5, lpattern(dot) lcolor(cranberry)), saving(graphd75r40,replace)
twoway (line coop match if treatment==6 & match<=29, title(delta=.75 r=48) subtitle(SGPE & RD) legend(off) graphregion(color(white)) xtitle("Repeated Game (log scale)") ytitle("Cooperation") yscale(range(0 1)) ylabel(#11) xscale(log) xlabel(1 5 10 20 40 100 300 1000)) (line g match if treatment==6, lpattern(dash)) (line lowlimit90 match if treatment==6,  lpattern(dot) lcolor(cranberry)) (line upplimit90 match if treatment==6, lpattern(dot) lcolor(cranberry)), saving(graphd75r48,replace)

graph combine "graphd5r32" "graphd5r40" "graphd5r48" "graphd75r32" "graphd75r40" "graphd75r48" , graphregion(color(white)) saving("figure2", replace)

graph export figure2.wmf, replace

*Figure A2.4
use simulationresults, clear
keep if match==1
reshape long coope, i(treatment) j(coopingroup)
gen coope1=coope/1000
sort treatment coopingroup
save datcoope1, replace

use simulationresults, clear
keep if match==1000
reshape long coope, i(treatment) j(coopingroup)
replace coope=coope/1000

merge treatment coopingroup using datcoope1

twoway (line coope coopingroup if treatment==1,  title(delta=.5 r=32) subtitle(Neither SGPE nor RD) legend(off) graphregion(color(white)) xtitle("Number of cooperative actions") ytitle("Proportion") yscale(range(0 1)) ylabel(#11) xscale(range(0 14)) xlabel(#15) scale(.7)) (line coope1 coopingroup if treatment==1, lpattern(dash)), saving(graphd5r32,replace) 
twoway (line coope coopingroup if treatment==2,  title(delta=.5 r=40) subtitle(SGPE) legend(off) graphregion(color(white)) xtitle("Number of cooperative actions") ytitle("Proportion") yscale(range(0 1)) ylabel(#11) xscale(range(0 14)) xlabel(#15) scale(.7) xline(10.5)) (line coope1 coopingroup if treatment==2, lpattern(dash)), saving(graphd5r40,replace) 
twoway (line coope coopingroup if treatment==3,  title(delta=.5 r=48) subtitle(SGPE & RD) legend(off) graphregion(color(white)) xtitle("Number of cooperative actions") ytitle("Proportion") yscale(range(0 1)) ylabel(#11) xscale(range(0 14)) xlabel(#15) scale(.7) xline(5.5)) (line coope1 coopingroup if treatment==3, lpattern(dash)), saving(graphd5r48,replace) 
twoway (line coope coopingroup if treatment==4,  title(delta=.75 r=32) subtitle(SGPE) legend(off) graphregion(color(white)) xtitle("Number of cooperative actions") ytitle("Proportion") yscale(range(0 1)) ylabel(#11)  xscale(range(0 14)) xlabel(#15) scale(.7) xline(11.5)) (line coope1 coopingroup if treatment==4, lpattern(dash)), saving(graphd75r32,replace) 
twoway (line coope coopingroup if treatment==5,  title(delta=.75 r=40) subtitle(SGPE & RD) legend(off) graphregion(color(white)) xtitle("Number of cooperative actions") ytitle("Proportion") yscale(range(0 1)) ylabel(#11) xscale(range(0 14)) xlabel(#15) scale(.7) xline(3.5)) (line coope1 coopingroup if treatment==5, lpattern(dash)), saving(graphd75r40,replace)
twoway (line coope coopingroup if treatment==6,  title(delta=.75 r=48) subtitle(SGPE & RD) legend(off) graphregion(color(white)) xtitle("Number of cooperative actions") ytitle("Proportion") yscale(range(0 1)) ylabel(#11) xscale(range(0 14)) xlabel(#15) scale(.7) xline(2.5)) (line coope1 coopingroup if treatment==6, lpattern(dash)), saving(graphd75r48,replace) 

graph combine "graphd5r32" "graphd5r40" "graphd5r48" "graphd75r32" "graphd75r40" "graphd75r48" , graphregion(color(white)) saving("figureA24", replace)

graph export figureA24.wmf, replace


*Figure A2.5
use datdf1, clear
keep if round==1
collapse coop, by (treatment match)
sort treatment match
merge treatment match using simulationresultscross

twoway (line coop match if treatment==1 & match<=59, title(delta=.5 r=32) subtitle(Neither SGPE nor RD) legend(off) graphregion(color(white)) xtitle("Repeated Game (log scale)") ytitle("Cooperation") yscale(range(0 1)) ylabel(#11) xscale(log) xlabel(1 5 10 20 40 100 300 1000)) (line g match if treatment==1, lpattern(dash)) (line lowlimit90 match if treatment==1,  lpattern(dot) lcolor(cranberry)) (line upplimit90 match if treatment==1, lpattern(dot) lcolor(cranberry)), saving(graphd5r32,replace)
twoway (line coop match if treatment==2 & match<=71, title(delta=.5 r=40) subtitle(SGPE) legend(off) graphregion(color(white)) xtitle("Repeated Game (log scale)") ytitle("Cooperation") yscale(range(0 1)) ylabel(#11) xscale(log) xlabel(1 5 10 20 40 100 300 1000)) (line g match if treatment==2, lpattern(dash)) (line lowlimit90 match if treatment==2,  lpattern(dot) lcolor(cranberry)) (line upplimit90 match if treatment==2, lpattern(dot) lcolor(cranberry)), saving(graphd5r40,replace)
twoway (line coop match if treatment==3 & match<=68, title(delta=.5 r=48) subtitle(SGPE & RD) legend(off) graphregion(color(white)) xtitle("Repeated Game (log scale)") ytitle("Cooperation") yscale(range(0 1)) ylabel(#11) xscale(log) xlabel(1 5 10 20 40 100 300 1000)) (line g match if treatment==3, lpattern(dash)) (line lowlimit90 match if treatment==3,  lpattern(dot) lcolor(cranberry)) (line upplimit90 match if treatment==3, lpattern(dot) lcolor(cranberry)), saving(graphd5r48,replace)
twoway (line coop match if treatment==4 & match<=27, title(delta=.75 r=32) subtitle(SGPE) legend(off) graphregion(color(white)) xtitle("Repeated Game (log scale)") ytitle("Cooperation") yscale(range(0 1)) ylabel(#11) xscale(log) xlabel(1 5 10 20 40 100 300 1000)) (line g match if treatment==4, lpattern(dash)) (line lowlimit90 match if treatment==4,  lpattern(dot) lcolor(cranberry)) (line upplimit90 match if treatment==4, lpattern(dot) lcolor(cranberry)), saving(graphd75r32,replace)
twoway (line coop match if treatment==5 & match<=23, title(delta=.75 r=40) subtitle(SGPE & RD) legend(off) graphregion(color(white)) xtitle("Repeated Game (log scale)") ytitle("Cooperation") yscale(range(0 1)) ylabel(#11) xscale(log) xlabel(1 5 10 20 40 100 300 1000)) (line g match if treatment==5, lpattern(dash)) (line lowlimit90 match if treatment==5,  lpattern(dot) lcolor(cranberry)) (line upplimit90 match if treatment==5, lpattern(dot) lcolor(cranberry)), saving(graphd75r40,replace)
twoway (line coop match if treatment==6 & match<=29, title(delta=.75 r=48) subtitle(SGPE & RD) legend(off) graphregion(color(white)) xtitle("Repeated Game (log scale)") ytitle("Cooperation") yscale(range(0 1)) ylabel(#11) xscale(log) xlabel(1 5 10 20 40 100 300 1000)) (line g match if treatment==6, lpattern(dash)) (line lowlimit90 match if treatment==6,  lpattern(dot) lcolor(cranberry)) (line upplimit90 match if treatment==6, lpattern(dot) lcolor(cranberry)), saving(graphd75r48,replace)

graph combine "graphd5r32" "graphd5r40" "graphd5r48" "graphd75r32" "graphd75r40" "graphd75r48" , graphregion(color(white)) saving("figureA25", replace)

graph export figureA25.wmf, replace


*Table A2.8

*ll=. for those that always did C or D 
use learningestimates, clear
replace lamda_v=0 if lamda_v==. & ll~=.

*subjects with constant noise
gen constantnoise=(psi==0|lamda_v==0|psi==1)
replace lamda_f=lamda_f+lamda_v if psi==1

*summary of estimates
table treatment if ll~=., c(mean pg_1 mean learning_delta mean lamda_f)
table treatment if ll~=., c(med pg_1 med learning_delta med lamda_f)

*psi and lamda_v only measure for those that do not have constant noise (otherwise it was imputed to lamda_f)
table treatment if ll~=. & constantnoise==0, c(mean psi mean lamda_v)
table treatment if ll~=. & constantnoise==0, c(med psi med lamda_v)

replace pg_1=1 if ll==. & coop==1
replace pg_1=0 if ll==. & coop==0

table treatment, c(mean pg_1 med pg_1)

gen lamda1=lamda_f+psi*lamda_v
gen lamda50=lamda_f+(psi^50)*lamda_v
table treatment if ll~=., c(mean lamda1 mean lamda50)
table treatment if ll~=., c(med lamda1 med lamda50)

table treatment constantnoise if ll~=., c(count ll)
