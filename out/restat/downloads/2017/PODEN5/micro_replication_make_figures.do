
/* Figures Replication */

/* UI - men (baseline) Figure 2 */

use manui_logit_stateFE_output_fullsamp.dta, clear

lab def years -8 "-7+"
lab def years -6 "-6-5", add
lab def years -4 "-4-3", add
lab def years -2 "-2-1", add
lab def years 0 "0-1", add
lab def years 2 "2-3", add
lab def years 4 "4-5", add
lab def years 6 "6-7", add
lab def years 8 "8-9", add
lab def years 10 "10+", add

label values timeUI years

label variable timeUI "Years before/after unemployment"
gen ci95 = beta + (se*1.96)
gen ci5 = beta - (se*1.96)

twoway (line ci95 timeUI, yline(0, lcolor(black) lwidth(vthin)) lcolor(black) lpattern(dash) legend(off) yscale(range(-.01 .02)) ylabel(-.01(.005).02) xscale(range(-8 10)) xlabel(-8 -6 -4 -2 0 2 4 6 8 10, valuelabel) ytitle("Bankruptcy Probability") subtitle("")) (connected beta timeUI, lcolor(black) msymbol(O) mcolor(black) msize(small)) (line ci5 timeUI, lcolor(black) lpattern(dash) graphregion(color(white)) bgcolor(white) scheme(s2mono))
graph export man_ui_nostateFE_rep.pdf, replace

/* UI - women (baseline) Figure 3 */

use femui_logit_nostateFE_rep.dta, clear

lab def years -8 "-7+"
lab def years -6 "-6-5", add
lab def years -4 "-4-3", add
lab def years -2 "-2-1", add
lab def years 0 "0-1", add
lab def years 2 "2-3", add
lab def years 4 "4-5", add
lab def years 6 "6-7", add
lab def years 8 "8-9", add
lab def years 10 "10+", add

label values timeUI years

label variable timeUI "Years before/after unemployment"
gen ci95 = beta + (se*1.96)
gen ci5 = beta - (se*1.96)

twoway (line ci95 timeUI, yline(0, lcolor(black) lwidth(vthin)) lcolor(black) lpattern(dash) legend(off) yscale(range(-.03 .02)) ylabel(-.03(.01).02) xscale(range(-8 10)) xlabel(-8 -6 -4 -2 0 2 4 6 8 10, valuelabel) ytitle("Bankruptcy Probability") subtitle("")) (connected beta timeUI, lcolor(black) msymbol(O) mcolor(black) msize(small)) (line ci5 timeUI, lcolor(black) lpattern(dash) graphregion(color(white)) bgcolor(white) scheme(s2mono))
graph export fem_ui_nostateFE_rep.pdf, replace

/* Men UI financial benefit split Figure 4 */

use manui_logit_finbengt0_nostateFE_rep.dta, clear
append using manui_logit_finbenlt0_nostateFE_rep.dta

lab def years -8 "-7+"
lab def years -6 "-6-5", add
lab def years -4 "-4-3", add
lab def years -2 "-2-1", add
lab def years 0 "0-1", add
lab def years 2 "2-3", add
lab def years 4 "4-5", add
lab def years 6 "6-7", add
lab def years 8 "8-9", add
lab def years 10 "10+", add

label values timeUI years

label variable timeUI "Years before/after unemployment"
gen ci95 = beta + (se*1.96)
gen ci5 = beta - (se*1.96)

twoway (line beta timeUI if finben==0, legend(label(1 "No Financial Benefit") label(2 "Positive Financial Benefit")) yline(0, lcolor(black) lwidth(vthin)) lcolor(black) lwidth(thick) lpattern(dot) yscale(range(-.02 .02)) ylabel(-.02(.01).02) ytitle("Bankruptcy Probability") xscale(range(-8 10)) xlabel(-8 -6 -4 -2 0 2 4 6 8 10, valuelabel) subtitle("")) (connected beta timeUI if finben==1, lcolor(black) msymbol(O) mcolor(black) msize(small) graphregion(color(white)) bgcolor(white) scheme(s2mono))
graph export manui_byfinben_nostateFE_rep.pdf, replace

/* Men UI debt split Figure 5 */
use manui_logit_debtsgt40_nostateFE_rep.dta, clear
append using manui_logit_debtslt40_nostateFE_rep.dta

lab def years -8 "-7+"
lab def years -6 "-6-5", add
lab def years -4 "-4-3", add
lab def years -2 "-2-1", add
lab def years 0 "0-1", add
lab def years 2 "2-3", add
lab def years 4 "4-5", add
lab def years 6 "6-7", add
lab def years 8 "8-9", add
lab def years 10 "10+", add

label values timeUI years

label variable timeUI "Years before/after unemployment"
gen ci95 = beta + (se*1.96)
gen ci5 = beta - (se*1.96)

twoway (line beta timeUI if debtgt40==0, legend(label(1 "Bottom Three Debt Quartiles") label(2 "Top Debt Quartile")) yline(0, lcolor(black) lwidth(vthin)) lcolor(black) lwidth(thick) lpattern(dot) yscale(range(-.02 .02)) ylabel(-.02(.01).02) ytitle("Bankruptcy Probability") xscale(range(-8 10)) xlabel(-8 -6 -4 -2 0 2 4 6 8 10, valuelabel) subtitle("")) (connected beta timeUI if debtgt40==1, lcolor(black) msymbol(O) mcolor(black) msize(small) graphregion(color(white)) bgcolor(white) scheme(s2mono))
graph export manui_bydebt40_nostateFE_rep.pdf, replace

/* divorce Figure 6 */

use div_logit_nostateFE_rep.dta, clear

lab def years -8 "-7+"
lab def years -6 "-6-5", add
lab def years -4 "-4-3", add
lab def years -2 "-2-1", add
lab def years 0 "0-1", add
lab def years 2 "2-3", add
lab def years 4 "4-5", add
lab def years 6 "6-7", add
lab def years 8 "8-9", add
lab def years 10 "10+", add

label values timeUI years

label variable timeUI "Years before/after divorce"
gen ci95 = beta + (se*1.96)
gen ci5 = beta - (se*1.96)

twoway (line ci95 timeUI, yline(0, lcolor(black) lwidth(vthin)) lcolor(black) lpattern(dash) legend(off) yscale(range(-.01 .01)) ylabel(-.01(.005).01) xscale(range(-8 10)) xlabel(-8 -6 -4 -2 0 2 4 6 8 10, valuelabel) ytitle("Bankruptcy Probability") subtitle("")) (connected beta timeUI, lcolor(black) msymbol(O) mcolor(black) msize(small)) (line ci5 timeUI, lcolor(black) lpattern(dash) graphregion(color(white)) bgcolor(white) scheme(s2mono))
graph export div_nostateFE_rep.pdf, replace


/* disability Figure 7 */

use health_logit_nostateFE_rep.dta, clear

lab def years -8 "-7+"
lab def years -6 "-6-5", add
lab def years -4 "-4-3", add
lab def years -2 "-2-1", add
lab def years 0 "0-1", add
lab def years 2 "2-3", add
lab def years 4 "4-5", add
lab def years 6 "6-7", add
lab def years 8 "8-9", add
lab def years 10 "10+", add

label values timeUI years

label variable timeUI "Years before/after disability"
gen ci95 = beta + (se*1.96)
gen ci5 = beta - (se*1.96)

twoway (line ci95 timeUI, yline(0, lcolor(black) lwidth(vthin)) lcolor(black) lpattern(dash) legend(off) yscale(range(-.015 .015)) ylabel(-.015(.005).015) xscale(range(-8 10)) xlabel(-8 -6 -4 -2 0 2 4 6 8 10, valuelabel) ytitle("Bankruptcy Probability") subtitle("")) (connected beta timeUI, lcolor(black) msymbol(O) mcolor(black) msize(small)) (line ci5 timeUI, lcolor(black) lpattern(dash) graphregion(color(white)) bgcolor(white) scheme(s2mono))
graph export dis_nostateFE_rep.pdf, replace

/* divorce finben split Figure 8 */
use div_logit_finbengt0_nostateFE_rep.dta, clear
append using div_logit_finbenlt0_nostateFE_rep.dta

lab def years -8 "-7+"
lab def years -6 "-6-5", add
lab def years -4 "-4-3", add
lab def years -2 "-2-1", add
lab def years 0 "0-1", add
lab def years 2 "2-3", add
lab def years 4 "4-5", add
lab def years 6 "6-7", add
lab def years 8 "8-9", add
lab def years 10 "10+", add

label values timediv years

label variable timediv "Years before/after divorce"
gen ci95 = beta + (se*1.96)
gen ci5 = beta - (se*1.96)

twoway (line beta timediv if finben==0, legend(label(1 "No Financial Benefit") label(2 "Positive Financial Benefit")) yline(0, lcolor(black) lwidth(vthin)) lcolor(black) lwidth(thick) lpattern(dot) yscale(range(-.02 .02)) ylabel(-.02(.01).02) ytitle("Bankruptcy Probability") xscale(range(-8 10)) xlabel(-8 -6 -4 -2 0 2 4 6 8 10, valuelabel) subtitle("")) (connected beta timediv if finben==1, lcolor(black) msymbol(O) mcolor(black) msize(small) graphregion(color(white)) bgcolor(white) scheme(s2mono))
graph export div_byfinben_nostateFE_rep.pdf, replace


/* disability finben split Figure 9 */
use dis_logit_finbengt0_nostateFE_rep.dta, clear
append using dis_logit_finbenlt0_nostateFE_rep.dta

lab def years -8 "-7+"
lab def years -6 "-6-5", add
lab def years -4 "-4-3", add
lab def years -2 "-2-1", add
lab def years 0 "0-1", add
lab def years 2 "2-3", add
lab def years 4 "4-5", add
lab def years 6 "6-7", add
lab def years 8 "8-9", add
lab def years 10 "10+", add

label values timedis years

label variable timedis "Years before/after disability"
gen ci95 = beta + (se*1.96)
gen ci5 = beta - (se*1.96)

twoway (line beta timedis if finben==0, legend(label(1 "No Financial Benefit") label(2 "Positive Financial Benefit")) yline(0, lcolor(black) lwidth(vthin)) lcolor(black) lwidth(thick) lpattern(dot) yscale(range(-.02 .02)) ylabel(-.02(.01).02) ytitle("Bankruptcy Probability") xscale(range(-8 10)) xlabel(-8 -6 -4 -2 0 2 4 6 8 10, valuelabel) subtitle("")) (connected beta timedis if finben==1, lcolor(black) msymbol(O) mcolor(black) msize(small) graphregion(color(white)) bgcolor(white) scheme(s2mono))
graph export dis_byfinben_nostateFE_rep.pdf, replace


/* married vs. single - appendix figure 1 */
use manui_logit_married_nostateFE_rep.dta, clear
append using manui_logit_single_nostateFE_rep.dta

lab def years -8 "-7+"
lab def years -6 "-6-5", add
lab def years -4 "-4-3", add
lab def years -2 "-2-1", add
lab def years 0 "0-1", add
lab def years 2 "2-3", add
lab def years 4 "4-5", add
lab def years 6 "6-7", add
lab def years 8 "8-9", add
lab def years 10 "10+", add

label values timeUI years

label variable timeUI "Years before/after unemployment"
gen ci95 = beta + (se*1.96)
gen ci5 = beta - (se*1.96)

twoway (line beta timeUI if married==0, legend(label(1 "Single") label(2 "Married")) yline(0, lcolor(black) lwidth(vthin)) lcolor(black) lwidth(thick) lpattern(dot) yscale(range(-.02 .02)) ylabel(-.02(.01).02) ytitle("Bankruptcy Probability") xscale(range(-8 10)) xlabel(-8 -6 -4 -2 0 2 4 6 8 10, valuelabel) subtitle("")) (connected beta timeUI if married==1, lcolor(black) msymbol(O) mcolor(black) msize(small) graphregion(color(white)) bgcolor(white) scheme(s2mono))
graph export manui_by_married_nostateFE_rep.pdf, replace

/* income split - appendix figure 2 */
use manui_logit_lastincgt_nostateFE_rep.dta, clear
append using manui_logit_lastinclt_nostateFE_rep.dta

lab def years -8 "-7+"
lab def years -6 "-6-5", add
lab def years -4 "-4-3", add
lab def years -2 "-2-1", add
lab def years 0 "0-1", add
lab def years 2 "2-3", add
lab def years 4 "4-5", add
lab def years 6 "6-7", add
lab def years 8 "8-9", add
lab def years 10 "10+", add

label values timeUI years

label variable timeUI "Years before/after unemployment"
gen ci95 = beta + (se*1.96)
gen ci5 = beta - (se*1.96)

twoway (line beta timeUI if lastincgt==0, legend(label(1 "Below Median Income") label(2 "Above Median Income")) yline(0, lcolor(black) lwidth(vthin)) lcolor(black) lwidth(thick) lpattern(dot) yscale(range(-.02 .02)) ylabel(-.02(.01).02) ytitle("Bankruptcy Probability") xscale(range(-8 10)) xlabel(-8 -6 -4 -2 0 2 4 6 8 10, valuelabel) subtitle("")) (connected beta timeUI if lastincgt==1, lcolor(black) msymbol(O) mcolor(black) msize(small) graphregion(color(white)) bgcolor(white) scheme(s2mono))
graph export manui_by_income_nostateFE_rep.pdf, replace

/* by chapter - appendix figure 3 */
use manui_logit_b7_nostateFE_rep.dta, clear
append using manui_logit_b13_nostateFE_rep.dta

lab def years -8 "-7+"
lab def years -6 "-6-5", add
lab def years -4 "-4-3", add
lab def years -2 "-2-1", add
lab def years 0 "0-1", add
lab def years 2 "2-3", add
lab def years 4 "4-5", add
lab def years 6 "6-7", add
lab def years 8 "8-9", add
lab def years 10 "10+", add

label values timeUI years

label variable timeUI "Years before/after unemployment"
gen ci95 = beta + (se*1.96)
gen ci5 = beta - (se*1.96)

twoway (line beta timeUI if b7==0, legend(label(1 "Chapter 13") label(2 "Chapter 7")) yline(0, lcolor(black) lwidth(vthin)) lcolor(black) lwidth(thick) lpattern(dot) yscale(range(-.02 .02)) ylabel(-.02(.01).02) ytitle("Bankruptcy Probability") xscale(range(-8 10)) xlabel(-8 -6 -4 -2 0 2 4 6 8 10, valuelabel) subtitle("")) (connected beta timeUI if b7==1, lcolor(black) msymbol(O) mcolor(black) msize(small) graphregion(color(white)) bgcolor(white) scheme(s2mono))
graph export manui_by_chapter_nostateFE_rep.pdf, replace

log close
