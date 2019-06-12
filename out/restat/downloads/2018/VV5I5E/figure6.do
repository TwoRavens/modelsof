/*******************************************************************************
"SCARCITY WITHOUT LEVIATHAN: The Violent Effects of Cocaine Supply Shortages
in the Mexican Drug War"
J.C. Castillo, D. Mejia, P. Restrepo
*********************************************************************************

This do file produces:
FIGURE 6: Estimates of seizures on violence over time

Before running: Set the path to current folder at line 18
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

/****************************************************************/
/***  Estimates of heterogeneous impact by cartel presence   ****/
/****************************************************************/ 

/***No PAN support****/
*************************
preserve
keep if dPANsupport==0
collapse `tscontrols' supplyShock unemp IGAE (sum) homicides poblacion, by(timeTS)

/*Homicide rate in Mexico*/
gen tasa = homicides/poblacion * 100000 * 12
gen log_tasa=100*log(tasa)	
tsset timeTS

*Event Study estimates - Low PAN support*
reg log_tasa f(1/6).supplyShock supplyShock l(1/6).supplyShock `tscontrols' if  timeTS >= ym(2006,12), robust
parmest,format(estimate min95 max95) saving(dta/dyn1, replace)
restore


/***High PAN support****/
*************************

preserve
keep if dPANsupport==1
collapse `tscontrols' supplyShock unemp IGAE (sum) homicides poblacion, by(timeTS)

/*Homicide rate in Mexico*/
gen tasa = homicides/poblacion * 100000 * 12
gen log_tasa=100*log(tasa)	
tsset timeTS

*Event Study estimates - High PAN support*
reg log_tasa  f(1/6).supplyShock supplyShock l(1/6).supplyShock `tscontrols' if  timeTS >= ym(2006,12), robust
parmest,format(estimate min95 max95) saving(dta/dyn2, replace)
restore

/********************************/
/*Generate dataset for Figure 6 */

forvalues j=1(1)2{
use dta/dyn`j', clear
gen obs=_n
keep if obs<=13
gen time=obs-7 if obs>=7
replace time=-obs if obs<7
sort time

replace time=time+(`j'-1.5)*0.2

rename estimate est_`j'
rename min95 min95_`j'
rename max95 max95_`j'
keep time *_`j'
save dta/dyn`j'.dta, replace
}

append using dta/dyn1.dta


keep if time!=.
sort time


/************************/
/*Plot and save Figure 6*/

twoway  (bar est_1 time, fcolor(white) lcolor(black) lwidth(thin) barwidth(0.15))  					 (rcap min95_1 max95_1 time,  lwidth(thin) lcolor(gs10)) ///
		(bar est_2 time, fcolor(gs10%50) lcolor(black) lwidth(thin) barwidth(0.15))  	 (rcap min95_2 max95_2 time,  lwidth(thin) lcolor(gs10)), ///
title(Estimates of seizures on violence over time) ytitle(Homicide rate change in log points) xtitle(Months relative to event)   ///
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(black) ifcolor(white) ilcolor(white)) /// 
ylabel(-2 -1 0 1 2 3, glwidth(thin) glcolor(gs12)) xlabel(-6(1)6) ///
legend(on rows(2) order(1 "Estimates for municipalities with low PAN support" 3 "Estimates for municipalities with high PAN support") region(lcolor(none)))
graph export Figures/Figure6.eps, as(eps)   replace
