version 14
set more off

***************************************************************************************************
* THIS ROUTINE GENERATES FIGURE III PANELS A-B OF WASEEM (2019) RESTAT
***************************************************************************************************

use				"$project_data\ExemptionCutoff_06_11.dta",clear		
drop			if employee==0

/* BINNING DATA */

local 			var="taxableincome"
local 			ubound=500000
local 			lbound=80000								
local 			binsize=20000
local 			nbin=(`ubound'-`lbound')/`binsize'			
local 			mf=`binsize'/1000							
g 				double z0=`var'
g 				z1=F1.`var'
g 				logchange=log(z1/z0)
keep 			if z0>80000 & z0<=700000
qui				sum logchange,d
drop			if (logchange<r(p1) | logchange>r(p99))
g 				bin=ceil(`var'/`binsize')
bys 			bin year:egen avglogchange=mean(logchange)
duplicates 		drop bin year, force
replace 		bin=bin*`mf'

/* GENERATING BEFORE-AFTER BINNED SCATTER PLOTS */

#d				;
twoway			(connected  avglogchange bin if  year==2006 & bin>=140 & bin<=700,sort clcolor(teal) mcolor(teal) msymbol(hs) lwidth(thick))
				(connected  avglogchange bin if  year==2007 & bin>=140 & bin<=700,sort clcolor(brown) mcolor(brown) msymbol(d) lwidth(thick))
				(connected  avglogchange bin if  year==2008 & bin>=140 & bin<=700,sort clcolor(navy) mcolor(navy) msymbol(s) lwidth(thick)),
				xtitle(Wage Income in PKR 000s) xtitle(, alignment(top)) 
				xlabel(150(100)650)
				xline(150, lcolor(teal) lwidth(thick) lpattern(longdash))
				xline(180, lcolor(brown) lwidth(thick) lpattern(longdash))
				xline(200, lcolor(navy) lwidth(thick) lpattern(longdash))
				ytitle(Average Log Change in Income) yscale(titlegap(*10))
				ylabel(-0.2(0.2)0.6)
				legend(region(style(none)) label(1 "2006") label(2 "2007") label(3 "2008") rows(1)) 
				graphregion(fcolor(white) style(none) color(white) margin(0 2 0 2)) bgcolor(white);
				graph export "$project_graph\FigureIIIPanelA.eps", replace;
#d				cr

#d				;
twoway			(connected  avglogchange bin if  year==2008 & bin>=140 & bin<=700,sort clcolor(navy) mcolor(navy) msymbol(s) lwidth(thick))
				(connected  avglogchange bin if  year==2009 & bin>=140 & bin<=700,sort clcolor(maroon) mcolor(maroon) msymbol(t) lwidth(thick))
				(connected  avglogchange bin if  year==2010 & bin>=140 & bin<=700,sort clcolor(green) mcolor(green) msymbol(o) lwidth(thick)),
				xtitle(Wage Income in PKR 000s) xtitle(, alignment(top)) 
				xlabel(150(100)650)
				xline(200, lcolor(navy) lwidth(thick) lpattern(longdash))
				xline(300, lcolor(maroon) lwidth(thick) lpattern(longdash))
				xline(350, lcolor(green) lwidth(thick) lpattern(longdash))
				ytitle(Average Log Change in Income) yscale(titlegap(*10))
				ylabel(-0.2(0.2)0.6)
				legend(region(style(none)) label(1 "2008") label(2 "2009") label(3 "2010") rows(1)) 
				graphregion(fcolor(white) style(none) color(white) margin(0 2 0 2)) bgcolor(white);
				graph export "$project_graph\FigureIIIPanelB.eps", replace;
#d 				cr
