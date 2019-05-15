 /*************************************************************************
* A file to prepare Figure 1  "Digging into the Pocketbook"
* by Andrew Healy, Mikael Persson and Erik Snowberg					 	 *
*************************************************************************/
drop _all
clear matrix
clear mata
set mem 200m
set matsize 800
set more 1

* put the correct folder path on next line
 cd "../FIG1/"

/*************************************************************************
* median income					 		*
*************************************************************************/
insheet using "median income.csv", comma case clear

replace medianinc = medianinc * 1000
gen inc_chg = ((medianinc-medianinc[_n-1]) / medianinc[_n-1])*100
drop if year < 2002 | year > 2010

#delimit; 
twoway 
	(connected medianinc year, mlcolor(black) mfcolor(black)) 
	,  
	xline(2006, lpatt(dash) lcolor(green))
	yline(225000, lcolor(gs15))
	title("Median Disposible Income", color(black))
	xtitle("") 
	ytitle("Thousands of SEK")
	ylabel(175000 "175" 200000 "200" 225000 "225", angle(horizontal))
	xlabel("")
	xtick(2002(2)2010)
	legend(off)
	graphregion(color(gs16)) 
	fysize(47.5)
	text(210000 2005.7 "Election", orientation(vertical) color(green))
	name(medInc, replace )
	;

#delimit;
twoway 
	(connected inc_chg year, mlcolor(black) mfcolor(black)) 
	,  
	xline(2006, lpatt(dash) lcolor(green))
	title("Income Growth", color(black))
	xtitle("")
	ytitle("Percent Change")
	ylabel(0 "0" 4 "4%" 8 "8%",angle(horizontal))
	xlabel("")
	xtick(2002(2)2010)
	legend(off)
	graphregion(color(gs16)) 
	fysize(47.5)
	text(6 2005.7 "Election", orientation(vertical) color(green))
	name(incChange, replace )
	;

#delimit;
twoway 
	(connected tax year,  mlcolor(black) mfcolor(black)) 	
	,  
	xline(2006, lpatt(dash) lcolor(green))
	yline(40, lcolor(gs15))
	yline(50, lcolor(gs15))
	title("Average Tax Rate on Mean Income", color(black))
	xtitle("")
	ytitle("Percent")	
	xlabel(2002(2)2010)
	ylabel(40 "40%" 45 "45%" 50 "50%", angle(horizontal))
	legend(off)
	graphregion(color(gs16)) 
	fysize(52.5)
	text(42.5 2005.7 "Election", orientation(vertical) color(green))
	name(taxRate, replace )
	;

#delimit;
twoway 
	(connected unemployment year,  mlcolor(black) mfcolor(black))
	,  
	xline(2006, lpatt(dash) lcolor(green))
	title("Unemployment Rate", color(black)) 
	xtitle("") 
	ytitle("Percent") 
	yline(5, lcolor(gs15))
	yline(10, lcolor(gs15))
	ylabel(5 "5%" 7.5 "7.5%" 10 "10%", angle(horizontal))
	xlabel(2002(2)2010)
	legend(off)
	graphregion(color(gs16)) 
	fysize(52.5)
	text(8.75 2005.7 "Election", orientation(vertical) color(green))
	name(unemployment, replace )
	;


#delimit;
graph combine medInc incChange taxRate unemployment,
	rows(2) cols(2)
	graphregion(color(gs16))
	b1title("Year")
	name(tmp, replace)
	;
#delimit cr
*graph display tmp, xsize(6.5) ysize(3)
graph export summary.eps, fontface(Times) replace

