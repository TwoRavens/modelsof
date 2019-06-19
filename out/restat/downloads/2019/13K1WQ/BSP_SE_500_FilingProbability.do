version 14
set more off

***************************************************************************************************
* THIS ROUTINE GENERATES FIGURE A.II OF WASEEM (2019) RESTAT
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
g 				filer=(z1<.)
keep 			if z0>80000 & z0<=500000
g 				bin=ceil(`var'/`binsize')
bys 			bin year treat:egen avgfilingprob=mean(filer)
duplicates 		drop bin year treat, force
replace 		bin=bin*`mf'

/* GENERATING BINNED SCATTER PLOTS */

#d				;
twoway  		(connected  avgfilingprob bin if  year==2006 & treat==1 & bin>80 & bin<=500,sort clcolor(teal) mcolor(teal) msymbol(hs) lwidth(thick))
				(connected  avgfilingprob bin if  year==2007 & treat==1 & bin>80 & bin<=500,sort clcolor(brown) mcolor(brown) msymbol(d) lwidth(thick))
				(connected  avgfilingprob bin if  year==2008 & treat==1 & bin>80 & bin<=500,sort clcolor(navy) mcolor(navy) msymbol(s) lwidth(thick))
				(connected  avgfilingprob bin if  year==2009 & treat==1 & bin>80 & bin<=500,sort clcolor(maroon) mcolor(maroon) msymbol(t) lwidth(thick))
				(connected  avgfilingprob bin if  year==2010 & treat==1 & bin>80 & bin<=500,sort clcolor(green) mcolor(green) msymbol(o) lwidth(thick))
				(pcarrowi 0.4 170 0.4 100, lcolor(black) mcolor(black))
				(pcarrowi 0.4 230 0.4 300, lcolor(black) mcolor(black))
				(pcarrowi 0.4 300 0.4 350, lcolor(black) mcolor(black))
				(pcarrowi 0.4 420 0.4 400, lcolor(black) mcolor(black))
				(pcarrowi 0.4 480 0.4 500, lcolor(black) mcolor(black)),
				xtitle(Self-Employment Income in PKR 000s) xtitle(, alignment(top))
				xlabel(100(50)500)
				xline(300, lcolor(maroon) lwidth(thick) lpattern(longdash))
				xline(350, lcolor(green) lwidth(thick) lpattern(longdash))
				xline(400 500, lpattern(dash) lcolor(gs5))
				text(0.4 450 "Not-to-zero""tax change")
				text(0.4 200 "To-zero""tax changes")
				ytitle(Prob [{it:Files}{sub:{it:t+1}} | {it:Filed}{sub:{it:t}}]) yscale(titlegap(*10))
				ylabel(0(0.2)1)
				legend(region(style(none)) label(1 "2006") label(2 "2007") label(3 "2008")
				label(4 "2009") label(5 "2010") rows(1) order(1 2 3 4 5)) 
				graphregion(fcolor(white) style(none) color(white) margin(0 2 0 2)) bgcolor(white);
graph 			export "$project_graph\FigureAII.eps", replace;
