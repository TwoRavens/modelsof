/*******************************************************************************
"SCARCITY WITHOUT LEVIATHAN: The Violent Effects of Cocaine Supply Shortages
in the Mexican Drug War"
J.C. Castillo, D. Mejia, P. Restrepo
*********************************************************************************

This do file produces:
FIGURE 8: 	Yearly cocaine production in Colombia net of seizures and yearly cocaine
			prices ar reported by STRIDE. 

- Production is in hundred metric tons per quarter
- Prices are in dollars per pure gram in wholesale transactions

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

/********************************/
/*Generate dataset for Figure 8 */
keep if timeTS>=ym(2007,1)

collapse (mean) prodNetaCol (mean) price  (min) timeTS, by(year)
tsset timeTS

label variable price  `"Cocaine retail prices from STRIDE"'
label variable prodNetaCol `"Yearly cocaine production net of seizures"'
replace prodNetaCol=100*prodNetaCol*12

/********************************************************************/
/*Plot and save Figure 8*/
twoway (tsline prodNetaCol, lcolor(black) lpattern(dash)) (tsline price, ///
yaxis(2) lcolor(black) lpattern(solid)), ytitle(Metric tons)             ///
ytitle(Dollars per gram, axis(2)) xtitle(Year) legend(on rows(2) region(lcolor(none))) ///
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))   ///
plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
graph export Figures/Figure8.eps, as(eps) preview(off) replace


