/*******************************************************************************
"SCARCITY WITHOUT LEVIATHAN: The Violent Effects of Cocaine Supply Shortages
in the Mexican Drug War"
J.C. Castillo, D. Mejia, P. Restrepo
*********************************************************************************

This do file produces:
FIGURE 1: 	Yearly homicide rate in Mexico (data from INEGI), drug-related homicide 
			rate in Mexico (data from Mexico's President's Office), and yearly cocaine production
			net of seizures in Colombia (UNODC)
			
Before running: set the path to current folder at line 20
*******************************************************************************/

clear all
set matsize 5000
set more off

*Set local folder
local folder /*SET THE PATH TO CURRENT FOLDER HERE*/

*Set working directory
cd `folder'
use dta\CastilloMejiaRestrepo.dta

/*Generate dataset for Figure 1 */
collapse prodNetaCol (sum) homSIMBAD tothomicideB poblacion, by(year)
tsset year

/*Annualized homicide rate in Mexico*/
gen tasa_homSIMBAD= homSIMBAD/poblacion * 100000 * 12 

/*Annualized drug-related homicide rate in Mexico*/
gen tasa_tothomicideB= tothomicideB/poblacion * 100000 * 12 

replace prodNetaCol=12*100*prodNetaCol

label variable tasa_homSIMBAD `"Homicide rate in Mexico (left axis)"'
label variable tasa_tothomicideB `"Drug-related homicide rate in Mexico (left axis)"'
label variable prodNetaCol `"Colombian cocaine production net of seizures (right axis)"'



/********************************************************************/

/*Plot and save Figure 1*/
twoway (connected tasa_homSIMBAD year, lcolor(gs8) mcolor(gs8) msymbol(circle) lpattern(dash_dot)) ///
       (connected tasa_tothomicideB year if year>=2007, lcolor(black) mcolor(black) msymbol(triangle) lpattern(dash)) ///
	   (connected prodNetaCol year, lcolor(pink) mcolor(pink) msymbol(diamond) yaxis(2) ), ///
ytitle(Yearly homicides per 100.000 pop., axis(1)) ytitle(Production (in tons), axis(2))  xtitle("") legend(on cols(2) region(lcolor(none))) ///
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) ///
plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) ylabel(#6, glwidth(thin) glcolor(white)) xlabel(2003(1)2010) ysize(4) xsize(8) legend(on rows(3))
graph export Figures/Figure1.eps, as(eps) preview(off) replace 
