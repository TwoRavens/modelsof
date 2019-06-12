/*******************************************************************************
"SCARCITY WITHOUT LEVIATHAN: The Violent Effects of Cocaine Supply Shortages
in the Mexican Drug War"
J.C. Castillo, D. Mejia, P. Restrepo
*********************************************************************************

This do file produces:
FIGURE 2:	Monthly deviations from their trend for cocaine seizures in Colombia
			and the homicide rate in Mexico.
			
Before running: set the path to current folder at line 19			
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

*Homicide rate in Mexico
gen homicides=homSIMBAD

*Cocaine Seizures in Colombia
gen supplyShock=100*log(cocaincCol)

*Generate dataset for Figure 2
collapse `tscontrols' supplyShock (sum) homicides poblacion, by(timeTS)
gen tasa = homicides/poblacion * 100000 * 12
gen log_tasa=100*log(tasa)	
tsset timeTS

*Time series variation in homicide rate
reg log_tasa `tscontrols' if  timeTS >= ym(2006,12), robust
predict variation if  timeTS >= ym(2006,12), resid
reg variation l.variation

*Time series variation in cocaine seizures
reg supplyShock `tscontrols' if  timeTS >= ym(2006,12), robust
predict variationProd if  timeTS >= ym(2006,12), resid
reg variationProd l.variationProd

label variable variation     `"Monthly variation of the homicide rate in Mexico (right axis)"'
label variable variationProd `"Monthly variation of cocaine seizures in Colombia (left axis)"'

/********************************************************************/

/*Plot and save Figure 2*/
twoway (tsline variationProd if  timeTS >= ym(2006,12), lcolor(gs6)) (tsline variation if  timeTS >= ym(2006,12), ///
lcolor(black) lpattern(dash) yaxis(2)), ytitle(Log deviations from trend, axis(1)) /// 
ytitle(Log deviations from trend, axis(2)) xtitle("") ///
legend(on rows(2) region(lcolor(none)) )  ///
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) ///
plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) xmtick(minmax)  xlabel(563(6)612) ylabel(#6, glwidth(thin) glcolor(gs14)) ysize(4) xsize(8)
graph export Figures/Figure2.eps, as(eps)   replace
