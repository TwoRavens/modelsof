version 14
set more off

***************************************************************************************************
* THIS PROGRAM GENERATES FIGURE II PANELS A-B OF WASEEM (2019) RESTAT
***************************************************************************************************

use				"$project_data\ExemptionCutoff_06_11.dta",clear	

/* BINNING DATA */

local			var="seinc"
local			lbound=80000
local			ubound=500000
local 			binsize=20000
local 			nbin=(`ubound'-`lbound')/`binsize'			
local 			mf=`binsize'/1000							
g 				double z0=`var'
g 				z1=F1.`var'
g 				logchange=log(z1/z0)
keep 			if z0>80000 & z0<=500000
qui				sum logchange,d
drop			if (logchange<r(p1) | logchange>r(p99))
g 				bin=ceil(`var'/`binsize')
bys 			bin year treat:egen avglogchange=mean(logchange)
duplicates 		drop bin year treat, force
replace 		bin=bin*`mf'

/* GENERATING BINNED SCATTER PLOTS */

#d				;
twoway  		(connected  avglogchange bin if  year==2006 & treat==1 & bin>80 & bin<=500,sort clcolor(teal) mcolor(teal) msymbol(hs) lwidth(thick))
				(connected  avglogchange bin if  year==2007 & treat==1 & bin>80 & bin<=500,sort clcolor(brown) mcolor(brown) msymbol(d) lwidth(thick))
				(connected  avglogchange bin if  year==2008 & treat==1 & bin>80 & bin<=500,sort clcolor(navy) mcolor(navy) msymbol(s) lwidth(thick))
				(connected  avglogchange bin if  year==2009 & treat==1 & bin>80 & bin<=500,sort clcolor(maroon) mcolor(maroon) msymbol(t) lwidth(thick))
				(connected  avglogchange bin if  year==2010 & treat==1 & bin>80 & bin<=500,sort clcolor(green) mcolor(green) msymbol(o) lwidth(thick))
				(pcarrowi -0.3 170 -0.3 100, lcolor(black) mcolor(black))
				(pcarrowi -0.3 230 -0.3 300, lcolor(black) mcolor(black))
				(pcarrowi -0.3 300 -0.3 350, lcolor(black) mcolor(black))
				(pcarrowi 0.3 420 0.3 400, lcolor(black) mcolor(black))
				(pcarrowi 0.3 480 0.3 500, lcolor(black) mcolor(black)),
				xtitle(Self-Employment Income in PKR 000s) xtitle(, alignment(top))
				xlabel(100(50)500)
				xline(300, lcolor(maroon) lwidth(thick) lpattern(longdash))
				xline(350, lcolor(green) lwidth(thick) lpattern(longdash))
				xline(400 500, lpattern(dash) lcolor(gs5))
				text(0.3 450 "Not-to-zero""tax change")
				text(-0.3 200 "To-zero""tax changes")
				ytitle(Average Log Change in Income) yscale(titlegap(*10))
				ylabel(-0.4(0.2)0.4)
				legend(region(style(none)) label(1 "2006") label(2 "2007") label(3 "2008")
				label(4 "2009") label(5 "2010") rows(1) order(1 2 3 4 5)) 
				graphregion(fcolor(white) style(none) color(white) margin(0 2 0 2)) bgcolor(white);
graph 			export "$project_graph\FigureIIPanelA.eps", replace;


#d				;
twoway  		(connected  avglogchange bin if  year==2006 & treat==0 & bin>80 & bin<=500,sort clcolor(teal) mcolor(teal) msymbol(hs) lwidth(thick))
				(connected  avglogchange bin if  year==2007 & treat==0 & bin>80 & bin<=500,sort clcolor(brown) mcolor(brown) msymbol(d) lwidth(thick))
				(connected  avglogchange bin if  year==2008 & treat==0 & bin>80 & bin<=500,sort clcolor(navy) mcolor(navy) msymbol(s) lwidth(thick))
				(connected  avglogchange bin if  year==2009 & treat==0 & bin>80 & bin<=500,sort clcolor(maroon) mcolor(maroon) msymbol(t) lwidth(thick))
				(connected  avglogchange bin if  year==2010 & treat==0 & bin>80 & bin<=500,sort clcolor(green) mcolor(green) msymbol(o) lwidth(thick)),
				xtitle(Self-Employment Income in PKR 000s) xtitle(, alignment(top))
				xlabel(100(50)500)
				xline(300, lcolor(maroon) lwidth(thick) lpattern(longdash))
				xline(350, lcolor(green) lwidth(thick) lpattern(longdash))
				xline(400 500, lpattern(dash) lcolor(gs5))
				ytitle(Average Log Change in Income) yscale(titlegap(*10))
				ylabel(-0.4(0.2)0.4)
				legend(region(style(none)) label(1 "2006") label(2 "2007") label(3 "2008")
				label(4 "2009") label(5 "2010") rows(1) order(1 2 3 4 5)) 
				graphregion(fcolor(white) style(none) color(white) margin(0 2 0 2)) bgcolor(white);
graph 			export "$project_graph\FigureIIPanelB.eps", replace;

