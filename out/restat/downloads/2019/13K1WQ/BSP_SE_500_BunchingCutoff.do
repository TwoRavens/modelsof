version 14
set more off

***************************************************************************************************
* THIS ROUTINE GENERATES FIGURE A.V PANELS A-B OF WASEEM (2019) RESTAT
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
g				zcutoff_10=300000
g				zcutoff_11=350000
g				logchange_cutoff_10=log(zcutoff_10/z0)
g				logchange_cutoff_11=log(zcutoff_11/z0)
keep 			if z0>80000 & z0<=500000
qui				sum logchange,d
drop			if (logchange<r(p1) | logchange>r(p99))
g 				bin=ceil(`var'/`binsize')
bys 			bin year treat:egen avglogchange=mean(logchange)
bys 			bin year treat:egen avglogchange_cutoff_10=mean(logchange_cutoff_10)
bys 			bin year treat:egen avglogchange_cutoff_11=mean(logchange_cutoff_11)
duplicates 		drop bin year treat, force
replace 		bin=bin*`mf'

/* GENERATING BINNED SCATTER PLOTS */

#d				;
twoway  		(connected  avglogchange bin if  year==2008 & treat==1 & bin>80 & bin<=500,sort clcolor(navy) mcolor(navy) msymbol(s) lwidth(thick))
				(connected  avglogchange bin if  year==2009 & treat==1 & bin>80 & bin<=500,sort clcolor(maroon) mcolor(maroon) msymbol(t) lwidth(thick))
				(connected  avglogchange_cutoff_10 bin if  year==2009 & treat==1 & bin>80 & bin<=500,sort clcolor(orange_red) mcolor(orange_red) msymbol(o) lwidth(thick) lpattern(longdash)),
				xtitle(Self-Employment Income in PKR 000s) xtitle(, alignment(top))
				xlabel(100(50)500)
				xline(300, lcolor(maroon) lwidth(thick) lpattern(longdash))
				ytitle(Average Log Change in Income) yscale(titlegap(*10))
				ylabel(-0.4(0.4)1.2)
				legend(region(style(none)) label(1 "2008") label(2 "2009") label(3 "2009 Bunch")
				rows(1) order(1 2 3)) 
				graphregion(fcolor(white) style(none) color(white) margin(0 2 0 2)) bgcolor(white);
graph 			export "$project_graph\FigureAVPanelA.eps", replace;

#d				;
twoway  		(connected  avglogchange bin if  year==2008 & treat==1 & bin>80 & bin<=500,sort clcolor(navy) mcolor(navy) msymbol(s) lwidth(thick))
				(connected  avglogchange bin if  year==2009 & treat==1 & bin>80 & bin<=500,sort clcolor(maroon) mcolor(maroon) msymbol(t) lwidth(thick))
				(connected  avglogchange bin if  year==2010 & treat==1 & bin>80 & bin<=500,sort clcolor(green) mcolor(green) msymbol(o) lwidth(thick))
				(connected  avglogchange_cutoff_11 bin if  year==2010 & treat==1 & bin>80 & bin<=500,sort clcolor(teal) mcolor(teal) msymbol(o) lwidth(thick) lpattern(longdash)),
				xtitle(Self-Employment Income in PKR 000s) xtitle(, alignment(top))
				xlabel(100(50)500)
				xline(350, lcolor(green) lwidth(thick) lpattern(longdash))
				ytitle(Average Log Change in Income) yscale(titlegap(*10))
				ylabel(-0.4(0.4)1.2)
				legend(region(style(none)) label(1 "2008") label(2 "2009") label(3 "2010") label(4 "2010 Bunch")
				rows(1) order(1 2 3 4)) 
				graphregion(fcolor(white) style(none) color(white) margin(0 2 0 2)) bgcolor(white);
graph 			export "$project_graph\FigureAVPanelB.eps", replace;




