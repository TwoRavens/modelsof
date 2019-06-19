version 14
set more off

***************************************************************************************************
* THIS ROUTINE GENERATES FIGURE A.X PANEL B OF WASEEM (2019) RESTAT
***************************************************************************************************

use				"$project_data\ExemptionCutoff_06_11.dta",clear		

/* BINNING DATA */

local 			var="taxableincome"
local 			binsize=20000
local 			ubound=700000
local 			lbound=140000								
local 			nbin=(`ubound'-`lbound')/`binsize'			
local 			mf=`binsize'/1000							
keep 			`var' regnor year taxableinc employee incfrbusiness
g 				double z0=`var'
g 				z1=F1.`var'
g 				logchange=log(z1/z0)
bys				year:cumul taxableinc if taxableinc>0 & taxableinc<., g(cdf)
keep 			if z0>80000 & z0<=700000
qui				sum logchange,d
drop			if (logchange<r(p1) | logchange>r(p99))
g 				bin=ceil(`var'/`binsize')
replace 		bin=bin*`mf'
bys				bin year employee:g index=_n

/* TREATMENT DUMMIES */

g				exse09=(incfrbusiness<=300000 & year==2009 & employee==0)
g				exse10=(incfrbusiness<=350000 & year==2010 & employee==0)
forvalues		y=2007/2010 {
				local m=substr("`y'",3,2)
g 				y`m'=(year==`y')
}
g				beta=0
g				se=0
g				cil=0
g				cih=0
drop			index
bys				bin year:g index=_n

/* RUNNING THE REGRESSION */

qui				reg logchange i.year,cluster(regnor) 
predict			resid,re
forvalues		y=2007/2010 {
local			m=substr("`y'",3,2)
forvalues		b=140(20)700 {
				qui reg resid y`m' employee ex* if bin==`b',cluster(regnor)
				replace beta=_b[y`m'] if bin==`b' & year==`y' 
				replace se=_se[y`m'] if bin==`b' & year==`y'
				replace cil=_b[y`m']-1.96*_se[y`m'] if bin==`b' & year==`y' 
				replace cih=_b[y`m']+1.96*_se[y`m'] if bin==`b' & year==`y' 
				}
}


/* 2010 */

bys 			bin year:egen avgcdf=mean(cdf)
#d				;
twoway  		(rarea cil cih bin if bin>=140 & bin<=700 & index==1 & year==2009,sort color(gs13))
				(connected  beta bin if bin>=140 & bin<=700 & index==1 & year==2009,sort clcolor(red) mcolor(red) msymbol(O) msize(large) lwidth(thick))
				(line  avgcdf bin if bin>=140 & bin<=700 & year==2009 & index==1,sort clcolor(black) mcolor(black) msymbol(O) msize(large) lpattern(dash) yaxis(2))
				(pcarrowi -0.075 220 -0.075 200, lcolor(black) mcolor(black))
				(pcarrowi -0.075 280 -0.075 300, lcolor(black) mcolor(black)),
				xtitle(Wage Income in PKR 000s) xtitle(, alignment(top))
				xlabel(150(100)700)
				xline(200, lcolor(navy) lwidth(thick) lpattern(longdash))
				xline(300, lcolor(maroon) lwidth(thick) lpattern(longdash))
				text(-0.08 250 "To-zero""tax change")
				ytitle(Baseline CDF of Wage Income, axis(2))
				ytitle(Difference-in-Differences Coefficient) yscale(titlegap(*10))
				ylabel(-0.2(0.1)0.2)
				legend(region(style(none)) label(1 "95% Confidence Interval") label(2 "Coefficient") 
				label(6 "Baseline CDF") rows(1) order(2 1 6)) 
				graphregion(fcolor(white) style(none) color(white) margin(0 2 0 2)) bgcolor(white);
				graph export "$project_graph\FigureAXPanelB.eps", replace;
#d 				cr
