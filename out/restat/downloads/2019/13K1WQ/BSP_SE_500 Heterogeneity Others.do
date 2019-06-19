version 14
set more off
set matsize 11000

***************************************************************************************************
* THIS ROUTINE GENERATES FIGURE A.XI PANELS B-F OF WASEEM (2019) RESTAT
***************************************************************************************************

//* DEFINING TIME VARIABLE */		

use				"$project_data\ExemptionCutoff_06_11.dta",clear
keep			regnor year seinc employee incfrsalary nsale manuf regfor_sales medium_code birth_foundation_date
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

/* MANUFACTURERS */

keep			if nsale>0 & nsale<.
preserve
g				xtc=0
forvalues		y=2008/2010 {
replace			xtc=1 if manuf>0 & manuf<. & year==`y' 
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
				legend(region(style(none)) label(1 "Manufacturers (2008)") label(2 "Non-Manufacturers (2008)") 
				label(3 "Manufacturers (2009)") label(4 "Non-Manufacturers (2009)") rows(2)) 
				graphregion(fcolor(white) style(none) color(white) margin(0 2 0 2)) bgcolor(white);
				graph export "$project_graph\FigureAXIPanelC.eps", replace;
#d 				cr
restore

/* REGULAR TAX FILERS */

preserve
bys				regnor:g nreturns=_N
g				xtc=(nreturns==6)
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
				legend(region(style(none)) label(1 "Regular Tax Filers (2008)") label(2 "Others (2008)") 
				label(3 "Regular Tax Filers (2009)") label(4 "Others (2009)") rows(2)) 
				graphregion(fcolor(white) style(none) color(white) margin(0 2 0 2)) bgcolor(white);
				graph export "$project_graph\FigureAXIPanelD.eps", replace;
#d 				cr
restore

/* VAT-REGISTERED */

preserve
g				xtc=(regfor_sales==1)
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
				legend(region(style(none)) label(1 "VAT-Registered (2008)") label(2 "Others (2008)") 
				label(3 "VAT-Registered (2009)") label(4 "Others (2009)") rows(2)) 
				graphregion(fcolor(white) style(none) color(white) margin(0 2 0 2)) bgcolor(white);
				graph export "$project_graph\FigureAXIPanelE.eps", replace;
#d 				cr
restore

/* ELECTRONIC RETURN FILERS */

preserve
g 				ereturn=(medium_code==5)
bys 			regno:egen n_ereturns=sum(ereturn)
g 				xtc=(n_ereturn>0)
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
				legend(region(style(none)) label(1 "Electronic Return Filers (2008)") label(2 "Others (2008)") 
				label(3 "Electronic Return Filers (2009)") label(4 "Others (2009)") rows(2)) 
				graphregion(fcolor(white) style(none) color(white) margin(0 2 0 2)) bgcolor(white);
				graph export "$project_graph\FigureAXIPanelF.eps", replace;
#d 				cr
restore

/* YOUNG VS. OLD TAXPAYERS */

preserve
g 				birthdate = date(birth_foundation_date, "DMY")			
g 				birthyear=year(birthdate)
g 				age_birth=2009-birthyear								
g				xtc=0
qui				sum age_birth,d
replace			xtc=1 if age_birth>r(p50) 
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
				graph export "$project_graph\FigureAXIPanelB.eps", replace;
#d 				cr
restore


