version 14
set more off

***************************************************************************************************
* THIS ROUTINE GENERATES FIGURE A.VI OF WASEEM (2019) RESTAT
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

/* GENERATING TREATMENT DUMMIES */

g				m_09=(`var'<=300000 & year==2009 & treat==1)
g				m_10=(`var'<=350000 & year==2010 & treat==1)
g				t_09=(`var'>400000 & year==2009 & treat==1)
g				trend=1
local			i=1
forvalues		y=2007/2011 {
local			i=`i'+1
replace			trend=`i' if year==`y'
}
g				post=year>2008
g				treat_post=treat*post

/* GENERATING TAX RATE VARIABLES */

matrix 			input tax_rates=(0.5,1,2,3,4,5,7.5,10,12.5,15,19,21,25,0,0,0,0,0,0,0\						///
							     0.25,0.5,0.75,1.5,2.5,3.5,4.5,6,7.5,9,10,11,12.5,14,15,16,17.5,18.5,19,20\						///	
								 0.5,0.75,1.5,2.5,3.5,4.5,6,7.5,9,10,11,12.5,14,15,16,17.5,18.5,19,20,0)
g				t0m=0
local			i=1
foreach 		z in 100 110 125 150 175 200 300 400 500 600 800 1000 1300 { 
				replace t0m=tax_rates[1,`i'] if taxableinc > (`z'*1000) & treat==1 
				local i=`i'+1
}
local 			i=1
foreach			z in 150 200 250 300 350 400 500 600 700 850 950 1050 1200 1500 1700 2000 3150 3700 4450 8400 {
					replace t0m=tax_rates[2,`i'] if taxableinc > (`z'*1000) & year<=2007 & treat==0
					local i=`i'+1
}
local 			i=1
foreach 		z in 180 250 350 400 450 550 650 750 900 1050 1200 1450 1700 1950 2250 2850 3550 4550 8650 {
					replace t0m=tax_rates[3,`i'] if taxableinc > (`z'*1000) & year>2007 & treat==0
					local i=`i'+1
}
replace			t0m=t0m/100
g				t1m=t0m
replace			t1m=0 if taxableinc<=300000 & year==2009 & treat==1
replace			t1m=0 if taxableinc<=350000 & year==2010 & treat==1
local 			i=1
foreach 		z in 180 250 350 400 450 550 650 750 900 1050 1200 1450 1700 1950 2250 2850 3550 4550 8650 {
					replace t1m=tax_rates[3,`i']/100 if taxableinc > (`z'*1000) & year==2007 & treat==0
					local i=`i'+1
}
replace			t1m=0 if taxableinc<=200000 & year==2008 & treat==0
replace			t1m=0 if taxableinc<=300000 & year==2009 & treat==0
replace			t1m=0.075 if taxableinc>400000 & taxableinc<=500000 & treat==1 & year==2009
replace			t1m=0 if taxableinc<=350000 & year==2010 & treat==0
g 				logchangetratem=log((1-t1m)/(1-t0m))

/* ESTIMATING ELASTICITIES */

g				e_b_09=0
g				se_b_09=0
g				e_b_10=0
g				se_b_10=0
forvalues		b=5/15 {
qui				ivregress 2sls logchange i.year (logchangetratem=m_09) m_10 if year<2011 & bin==`b', cluster(regnor)
replace			e_b_09=_b[logchangetratem] if bin==`b'
replace			se_b_09=_se[logchangetratem] if bin==`b'
}
forvalues		b=21/25 {
qui				ivregress 2sls logchange i.year treat (logchangetratem=t_09) m_10 if year<2011 & bin==`b', cluster(regnor)
replace			e_b_09=_b[logchangetratem] if bin==`b'
replace			se_b_09=_se[logchangetratem] if bin==`b'
}
forvalues		b=5/18 {
qui				ivregress 2sls logchange i.year treat (logchangetratem=m_10) m_09 if year<2011 & bin==`b', cluster(regnor)
replace			e_b_10=_b[logchangetratem] if bin==`b'
replace			se_b_10=_se[logchangetratem] if bin==`b'
}
duplicates 		drop bin year treat, force
replace 		bin=bin*`mf'
keep			if treat==1
g				e_b=e_b_09+e_b_10
g				se_b=sqrt(se_b_09^2+se_b_10^2)
g				cil=e_b-1.96*se_b
g				cih=e_b+1.96*se_b

/* GENERATING BINNED SCATTER PLOTS */

#d				;
twoway  		(rarea cil cih bin if bin>100 & bin<=500,sort color(gs13))
				(connected  e_b bin if bin>100 & bin<=500,sort clcolor(red) mcolor(red) msymbol(O) msize(large) lwidth(thick))
				(pcarrowi 40 170 40 100, lcolor(black) mcolor(black))
				(pcarrowi 40 230 40 300, lcolor(black) mcolor(black))
				(pcarrowi 40 300 40 350, lcolor(black) mcolor(black))
				(pcarrowi 40 420 40 400, lcolor(black) mcolor(black))
				(pcarrowi 40 480 40 500, lcolor(black) mcolor(black)),
				xtitle(Self-Employment Income in PKR 000s) xtitle(, alignment(top))
				xlabel(100(50)500)
				xline(300, lcolor(maroon) lwidth(thick) lpattern(longdash))
				xline(350, lcolor(green) lwidth(thick) lpattern(longdash))
				xline(400 500, lpattern(dash) lcolor(gs5))
				ytitle(Elasticity) yscale(titlegap(*10))
				ylabel(-20(20)60)
				text(40 450 "Not-to-zero""tax change")
				text(40 200 "To-zero""tax changes")
				legend(region(style(none)) label(1 "95% Confidence Interval") label(2 "Coefficient") 
				rows(1) order(2 1)) 
				graphregion(fcolor(white) style(none) color(white) margin(0 2 0 2)) bgcolor(white);
				graph export "$project_graph\FigureAVI.eps", replace;
#d 				cr
