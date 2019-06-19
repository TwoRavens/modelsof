version 14
set more off
set seed 1234

***************************************************************************************************
* THIS ROUTINE GENERATES FIGURE A.X PANEL A OF WASEEM (2019) RESTAT
***************************************************************************************************

use				"$project_data\ExemptionCutoff_06_11.dta",clear

/* BINNING DATA */

local			var="seinc"
local			lbound=80000
local			ubound=500000
local 			binsize=20000
local 			nbin=(`ubound'-`lbound')/`binsize'			
local 			mf=`binsize'/1000							
keep 			`var' regnor year treat regnor
g 				double z0=`var'
g 				z1=F1.`var'
g 				logchange=log(z1/z0)
keep			if seinc>0 & seinc<.
bys				year treat:cumul seinc, g(cdf)
keep 			if z0>80000 & z0<=500000
qui				sum logchange,d
drop			if (logchange<r(p1) | logchange>r(p99))
g 				bin=ceil(`var'/`binsize')
replace 		bin=bin*`mf'

/* GENERATING BINNED SCATTER PLOTS (DIFFERENCE-IN-DIFFERENCES) */

forvalues		y=2008/2010 {
				local m=substr("`y'",3,2)
g				treat_`m'=(year==`y' & treat==1)
g				cdellogincdd_`m'=0
g				se_`m'=0
g				cil_`m'=0
g				cih_`m'=0
}
g				cdellogincdd_0910=0
g				se_0910=0
g				trend=1
local			i=1
forvalues		y=2007/2011 {
local			i=`i'+1
replace			trend=`i' if year==`y'
}
g				treat_after=(treat==1 & year>2008)
forvalues		b=100(20)500 {
					qui reg logchange trend treat treat_09 treat_10 if bin==`b', cluster(regnor)
					forvalues y=2009/2010 {
						local m=substr("`y'",3,2)
						replace cdellogincdd_`m'=_b[treat_`m'] if bin==`b'
						replace cil_`m'=_b[treat_`m']-1.96*_se[treat_`m'] if bin==`b'
						replace cih_`m'=_b[treat_`m']+1.96*_se[treat_`m'] if bin==`b'
					}
					qui lincom treat_09+treat_10
					replace cdellogincdd_0910=r(estimate) if bin==`b'
					replace se_0910=r(se) if bin==`b'
}

* AGGREGATE

g 				cil_0910=cdellogincdd_0910-1.96*se_0910 
g 				cih_0910=cdellogincdd_0910+1.96*se_0910 
bys 			bin year treat:egen avgcdf=mean(cdf)
bys				bin year treat:g index=_n
#d				;
twoway  		(rarea cil_0910 cih_0910 bin if bin>80 & bin<=500 & index==1,sort color(gs13))
				(connected  cdellogincdd_0910 bin if bin>80 & bin<=500 & index==1,sort clcolor(red) mcolor(red) msymbol(O) msize(large) lwidth(thick))
				(line  avgcdf bin if bin>80 & bin<=500 & year==2009 & treat==1 & index==1,sort clcolor(black) mcolor(black) msymbol(O) msize(large) lpattern(dash) yaxis(2))
				(pcarrowi -0.3 170 -0.3 100, lcolor(black) mcolor(black))
				(pcarrowi -0.3 230 -0.3 300, lcolor(black) mcolor(black))
				(pcarrowi -0.3 300 -0.3 350, lcolor(black) mcolor(black)),
				xtitle(Self-Employment Income in PKR 000s) xtitle(, alignment(top))
				xlabel(100(50)500)
				xline(300, lcolor(maroon) lwidth(thick) lpattern(longdash))
				xline(350, lcolor(green) lwidth(thick) lpattern(longdash))
				ytitle(Difference-in-Differences Coefficient) yscale(titlegap(*10))
				ylabel(-0.4(0.2)0.6) ytitle(Baseline CDF of Self-Employment Income, axis(2))
				text(-0.3 200 "To-zero""tax changes")
				legend(region(style(none)) label(1 "95% CI") label(2 "Coefficient") 
				label(6 "Baseline CDF") rows(1) order(2 1 6)) 
				graphregion(fcolor(white) style(none) color(white) margin(0 2 0 2)) bgcolor(white);
graph 			export "$project_graph\FigureAXPanelA.eps", replace;

				
