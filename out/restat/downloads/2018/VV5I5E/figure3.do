/*******************************************************************************
"SCARCITY WITHOUT LEVIATHAN: The Violent Effects of Cocaine Supply Shortages
in the Mexican Drug War"
J.C. Castillo, D. Mejia, P. Restrepo
*********************************************************************************

This do file produces:
FIGURE 3: Estimates of seizures on violence over time

Response of the homicide rate in Mexican municipalities at different distances 
from the US to a 10% increase in cocaine seizures in Colombia.

Before running: set the path to current folder at line 21
*******************************************************************************/

clear all
set matsize 5000
set more off

*Set local folder
local folder /*SET THE PATH TO CURRENT FOLDER HERE*/

*Set working directory
cd `folder'
use dta\CastilloMejiaRestrepo.dta

tab year if  timeTS >= ym(2006,12), gen(yy)
local tscontrols t t2 t3  yy2 yy3 yy4 yy5

gen homicides=homSIMBAD
gen supplyShock=10*log(cocaincCol)

/********************************************************************/
/***  Effects of Seizures on violence over time  - All Mexico    ****/
*********************************************************************/
preserve
collapse `tscontrols' supplyShock unemp IGAE (sum) homicides poblacion, by(timeTS)

*Homicide rate in Mexico
gen tasa = homicides/poblacion * 100000 * 12
gen log_tasa=100*log(tasa)	
tsset timeTS

*Event Study estimates - all Mexico*
reg log_tasa f(1/6).supplyShock supplyShock l(1/6).supplyShock `tscontrols' if  timeTS >= ym(2006,12), robust
parmest,format(estimate min95 max95) saving(dta\dyn_all, replace)
restore


/********************************************************************/
/***  Effects of Seizures on violence over time  - Q1 & Q2       ****/
/********************************************************************/
preserve
keep if q12==1
collapse `tscontrols' supplyShock unemp IGAE (sum) homicides poblacion, by(timeTS)

*Homicide rate in Q1 & Q2
gen tasa = homicides/poblacion * 100000 * 12
gen log_tasa=100*log(tasa)	
tsset timeTS

*Event Study estimates - Q1 & Q2*
reg log_tasa  f(1/6).supplyShock supplyShock l(1/6).supplyShock `tscontrols' if  timeTS >= ym(2006,12), robust
parmest,format(estimate min95 max95) saving(dta\dyn_q12, replace)
restore


/********************************************************************/
/***  Effects of Seizures on violence over time  - Q1            ****/
/********************************************************************/
preserve
keep if q1==1
collapse `tscontrols' supplyShock unemp IGAE (sum) homicides poblacion, by(timeTS)

*Homicide rate in Q1
gen tasa = homicides/poblacion * 100000 * 12
gen log_tasa=100*log(tasa)	
tsset timeTS

*Event Study estimates - Q1*
reg log_tasa  f(1/6).supplyShock supplyShock l(1/6).supplyShock `tscontrols' if  timeTS >= ym(2006,12), robust
parmest,format(estimate min95 max95) saving(dta\dyn_q1, replace)
restore

/********************************************************************/

/*Plot and save Figure 3*/
use dta\dyn_all, clear
gen obs=_n
gen type="All municipalities"
keep if obs<=13
gen time=obs-7 if obs>=7
replace time=-obs if obs<7
sort time

rename estimate est_all
rename min95 min95_all
rename max95 max95_all
keep time *_all 
replace time=time-0.2
save dta\dyn_all.dta, replace

use dta\dyn_q12, clear
gen obs=_n
gen type="Quintiles 1 and 2"
keep if obs<=13
gen time=obs-7 if obs>=7
replace time=-obs if obs<7
sort time

rename estimate est_q12
rename min95 min95_q12
rename max95 max95_q12
keep time *_q12
replace time=time
*+0.2
save dta\dyn_q12.dta, replace

use dta\dyn_q1, clear
gen obs=_n
gen type="First Quintile"
keep if obs<=13
gen time=obs-7 if obs>=7
replace time=-obs if obs<7
sort time

rename estimate est_q1
rename min95 min95_q1
rename max95 max95_q1
keep time *_q1 
replace time=time+0.2
*+0.4
save dta\dyn_q1.dta, replace

append using dta\dyn_all.dta
append using dta\dyn_q12.dta

keep if time!=.
sort time

twoway  (bar est_all time, fcolor(white) lcolor(black) lwidth(thin) barwidth(0.15))  (rcap min95_all max95_all time, lwidth(thin) lcolor(gs10)) ///
        (bar est_q12 time, fcolor(gs10%50) lcolor(black) lwidth(thin) barwidth(0.15))  (rcap min95_q12 max95_q12 time, lwidth(thin) lcolor(gs10)) /// 
		(bar est_q1 time, fcolor(gs0%50) lcolor(black) lwidth(thin) barwidth(0.15))   (rcap min95_q1 max95_q1 time, lwidth(thin) lcolor(gs10)), ///
title(Estimates of seizures on violence over time) ytitle(Homicide rate change in log points) xtitle(Months relative to event)   ///
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(black) ifcolor(white) ilcolor(white)) /// 
ylabel(-2 -1 0 1 2 3, glwidth(thin) glcolor(gs12)) xlabel(-6(1)6) ///
legend(on rows(3) order(1 "Estimates for all Mexican municipalities" 3 "Estimates for municipalities in quintiles 1 and 2" 5 "Estimates for municipalities in the first quintile") region(lcolor(none)))
graph export Figures/Figure3.eps, as(eps)   replace
