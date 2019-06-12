* Power, Preferences, and Bargaining
* Replication File
* Scott Wolford
* 18 September 2012

* This file reproduces the commands necessary to generate the results in Table
* 1, as well as Figures 2 and 3, in Stata 12.

use ccasr3isq_data.dta

* Model 1
* note that "interact" is underlinep*divvar1

probit coal2 underlinep divvar1 interact cinc1 targ_cinc number1 number1squared disparity1 maxdem1 mindist1 targ_allies targ_polity targ_landborders usa1 revisionist allies1 unsc1 cw, robust cluster(crisis)

* Model 2

probit coal2 underlinep divvar1 interact cinc1 targ_cinc number1 number1squared disparity1 maxdem1 mindist1 targ_allies targ_polity targ_landborders usa1 revisionist allies1 unsc1 cw brexit war, robust cluster(crisis)

* Figure 2

use ccasr3isq_data.dta

probit coal2 underlinep divvar1 interact cinc1 targ_cinc number1 number1squared disparity1 maxdem1 mindist1 targ_allies targ_polity targ_landborders usa1 revisionist allies1 unsc1 cw, robust cluster(crisis)

inteff coal2 underlinep divvar1 interact cinc1 targ_cinc number1 number1squared disparity1 maxdem1 mindist1 targ_allies targ_polity targ_landborders usa1 revisionist allies1 unsc1 cw, savedata(inteffs)

clear

use inteffs

twoway (scatter _probit_z _probit_phat, sort), ytitle(Z-Statistic of Ineractive Effect) yscale(range(-4 4)) yline(-1.96 0 1.96, lcolor(gs10)) ylabel(-4 -2 0 2 4) xtitle(Predicted Probability of Opposition)

graph save Graph inteff.gph, replace

clear

* Figure 3

use ccasr3isq_data.dta

* first, a powerful coalition

probit coal2 underlinep divvar1 interact cinc1 targ_cinc number1 number1squared disparity1 maxdem1 mindist1 targ_allies targ_polity targ_landborders usa1 revisionist allies1 unsc1 cw, robust cluster(crisis)

predictnl phat_powerful=normal(_b[_cons] + _b[underlinep]*(.9298628) + _b[divvar1]*divvar1 + _b[interact]*(.9298628*divvar1) + _b[cinc1]*(.1) + _b[targ_cinc]*(.03) + _b[number1]*(2) + _b[number1squared]*(4) + _b[disparity1]*(.06) + _b[maxdem1]*(2.7) + _b[mindist1]*(143) + _b[targ_allies]*(3) + _b[targ_polity]*(-2) + _b[targ_landborders]*(5) + _b[usa1]*(0) + _b[revisionist]*(0) + _b[allies1]*(.211) + _b[unsc1]*(0) + _b[cw]*(1)), ci(lo95 hi95) l(95)

twoway (histogram divvar1 if number1>1, fraction fintensity(20) lwidth(none)) (line phat_powerful divvar1, sort lcolor(black)) (line lo95 divvar1 if lo95>0, sort lcolor(black) lpattern(dash)) (line hi95 divvar1, sort lcolor(black) lpattern(dash)), ytitle(Predicted Probability of Opposition) xtitle(Diversity of Coalitional Interests) subtitle(Powerful Coalition) legend(off)

graph save Graph powerfulcoalition.gph, replace

clear

* second, a weak coalition

use ccasr3isq_data.dta

probit coal2 underlinep divvar1 interact cinc1 targ_cinc number1 number1squared disparity1 maxdem1 mindist1 targ_allies targ_polity targ_landborders usa1 revisionist allies1 unsc1 cw, robust cluster(crisis)

predictnl phat_weak=normal(_b[_cons] + _b[underlinep]*(.21) + _b[divvar1]*divvar1 + _b[interact]*(.21*divvar1) + _b[cinc1]*(.02) + _b[targ_cinc]*(0.0752381) + _b[number1]*(2) + _b[number1squared]*(4) + _b[disparity1]*(.06) + _b[maxdem1]*(2.7) + _b[mindist1]*(143) + _b[targ_allies]*(3) + _b[targ_polity]*(-2) + _b[targ_landborders]*(5) + _b[usa1]*(0) + _b[revisionist]*(0) + _b[allies1]*(.211) + _b[unsc1]*(0) + _b[cw]*(1)), ci(lo95 hi95) l(95)

twoway (histogram divvar1 if number1>1, fraction fintensity(20) lwidth(none)) (line phat_weak divvar1, sort lcolor(black)) (line lo95 divvar1 if lo95>0, sort lcolor(black) lpattern(dash)) (line hi95 divvar1 if hi95<1, sort lcolor(black) lpattern(dash)), ytitle(Predicted Probability of Opposition) xtitle(Diversity of Coalitional Interests) subtitle(Weak Coalition) legend(off)

graph save Graph weakcoalition.gph, replace

clear
