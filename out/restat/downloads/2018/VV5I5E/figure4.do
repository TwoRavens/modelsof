/*******************************************************************************
"SCARCITY WITHOUT LEVIATHAN: The Violent Effects of Cocaine Supply Shortages
in the Mexican Drug War"
J.C. Castillo, D. Mejia, P. Restrepo
*********************************************************************************

This do file produces:
FIGURE 4: 	Response of the homicide rate in Mexican municipalities toa 10% increase
			in cocaine seizures in Colombia as a function of their distance to the 
			US border.
			
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
tab year if  timeTS >= ym(2006,12), gen(yy)
local tscontrols t t2 t3  yy2 yy3 yy4 yy5

gen homicides=homSIMBAD
gen supplyShock=10*log(cocaincCol)

/****************************************************************/
/*** Estimates of heterogeneous impact by distance to border ****/
/****************************************************************/ 

*Set number of bins
local bins=1000
*Set size of the moving window
local size=100


*Allocate observations to bins
_pctile distEntradasPrinc, nq(`bins')
gen bin=0
replace bin=1 if distEntradasPrinc<=r(r1)
forvalues j=2(1)`bins'{
local n=`j'-1
replace bin=`j' if distEntradasPrinc>=r(r`n')&distEntradasPrinc<r(r`j')
}


*Estimate effect of cocaine seizures for each moving window 
local bins2=`bins'-`size'
forvalues j=1(1)`bins2'{


preserve
keep if bin>=`j'&bin<`j'+`size'
collapse distEntradasPrinc `tscontrols' supplyShock unemp IGAE (sum) homicides poblacion, by(timeTS)

gen tasa = homicides/poblacion * 100000 * 12
	gen log_tasa= 100*log(tasa)	
tsset timeTS

quietly: reg log_tasa supplyShock `tscontrols' if  timeTS >= ym(2006,12), robust
parmest,format(estimate min95 max95) saving(dta\dyn, replace)

sum distEntradasPrinc
local avedist=r(mean)

use dta\dyn, clear
keep if parm=="supplyShock"
gen bin=`j'
gen avedist=`avedist'
save file`j', replace

restore
}

preserve

*Generate dataset for the figure appending all the estimates for each moving window
use file1, clear
forvalues j=2(1)`bins2'{
append using file`j'
}

replace avedist=1000*avedist


/********************************************************************/
/*Plot and save Figure 4*/

twoway (line estimate avedist, sort lcolor(black)) (line min95 avedist, sort lcolor(gs10)) (line max95 avedist, sort lcolor(gs10)), ///
ytitle(Increase in violence in log points) xtitle(Distance to entry points in kilometers) ///
ylabel(-2 -1 0 1 2 3, glwidth(thin) glcolor(gs12)) ///
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(black) ifcolor(white) ilcolor(white)) legend(off) xmtick(minmax) ///
xline(507, lpattern(dash)) xline(333, lpattern(dash))
graph export Figures/Figure4.eps, as(eps) preview(off) replace
save dta/nonpar.dta, replace

forval i=1(1)900{ 
erase file`i'.dta
}
restore

