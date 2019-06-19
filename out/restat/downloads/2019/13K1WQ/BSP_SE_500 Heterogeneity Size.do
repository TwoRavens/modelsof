version 14
set more off
set matsize 11000

***************************************************************************************************
* THIS ROUTINE GENERATES FIGURE A.XI PANELS A OF WASEEM (2019) RESTAT
***************************************************************************************************

use				"$project_data\ExemptionCutoff_06_11.dta",clear
keep			regnor year seinc employee incfrsalary nsale
keep			if employee==0
sort			regnor year
local 			var="seinc"
local			lbound=80000
local			ubound=500000

/* BINNING DATA */

local 			binsize=20000
local 			nbin=(`ubound'-`lbound')/`binsize'			
local 			mf=`binsize'/1000							
g 				bin=ceil(`var'/`binsize')
replace 		bin=bin*`mf'

/* LOG CHANGE IN EARNINGS */

g 				double z0=`var'
g 				z1=F1.`var'
g 				logchange=log(z1/z0)
keep 			if z0>80000 & z0<=500000
qui				sum logchange,d
drop			if (logchange<r(p1) | logchange>r(p99)) & year<2011

/* MEDIAN */

keep			if nsale>0 & nsale<.
preserve
g				xtc=0
forvalues		y=2008/2010 {
qui				sum nsale if year==`y',d
replace			xtc=1 if nsale>r(p50) & year==`y' 
}

bys 			bin year xtc:egen avglogchange=mean(logchange)
duplicates 		drop bin year xtc, force
#d				;
twoway  		(connected  avglogchange bin if  year==2008 & xtc==1 & bin>80 & bin<=500,sort clcolor(navy) mcolor(navy) msymbol(s) lwidth(thick))
				(connected  avglogchange bin if  year==2008 & xtc==0 & bin>80 & bin<=500,sort clcolor(blue) mcolor(blue) msymbol(s) lwidth(thick))
				(connected  avglogchange bin if  year==2009 & xtc==1 & bin>80 & bin<=500,sort clcolor(maroon) mcolor(maroon) msymbol(s) lwidth(thick))
				(connected  avglogchange bin if  year==2009 & xtc==0 & bin>80 & bin<=500,sort clcolor(red) mcolor(red) msymbol(s) lwidth(thick)),
				xtitle(Self-Employment Income in PKR 000s) xtitle(, alignment(top))
				xlabel(100(50)500)
				xline(300, lcolor(maroon) lwidth(thick) lpattern(longdash))
				xline(350, lcolor(green) lwidth(thick) lpattern(longdash))
				ytitle(Average Log Change in Income) yscale(titlegap(*10))
				ylabel(-0.4(0.2)0.4)
				legend(region(style(none)) label(1 "Above Median (2008)") label(2 "Below Median (2008)") 
				label(3 "Above Median (2009)") label(4 "Below Median (2009)") rows(2)) 
				graphregion(fcolor(white) style(none) color(white) margin(0 2 0 2)) bgcolor(white);
				graph export "$project_graph\FigureAXIPanelA.eps", replace;
#d 				cr
restore
