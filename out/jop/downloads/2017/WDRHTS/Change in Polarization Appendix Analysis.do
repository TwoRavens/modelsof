

*generate polarization change

clear all
cd "Analysis Files"
use "Zingher JOP 2017.dta"
set more off

sort year
keep year dwnom1_difference
collapse (mean) dwnom1_difference, by(year)
egen cong = seq(), from(87) to(113)
drop if year==.
tsset cong
gen polar_change = dwnom1_difference-L2.dwnom1_difference
*twoway connected polar_change year

keep year polar_change
tsset year

tempfile clear
tempfile polar_change
save `polar_change', replace

clear
use "Zingher JOP 2017.dta"

sort year

merge m:1 year using `polar_change', nogen update replace
save "Zingher JOP 2017 Appendix Analysis.dta", replace

replace inter1 = F1_Adj*polar_change
replace inter2 = F2_Adj*polar_change



#delimit;
probit Pres_Vote c.Med_Dist##c.polar_change c.Med_Dist_F2##c.polar_change Latino Black white_southerner female Income age weeklychurch Catholic Jew Union education_6cat policy_mood Mean_Dem_Support Party_Dis if year>=1971; 
outreg2 using tableA2, auto(2) alpha(.05) dec(2)  symbol(*) replace;
sum polar_change if e(sample) ;
		local min = r(min) ;
		local max = r(max) ;
		local interval = ((`max'-`min')/10)  ;
		margins, dydx(Med_Dist) at(polar_change=(`min'(`interval')`max')) vsquish ;

		#delimit ;
		marginsplot, xlabel(`min'(`interval')`max') recastci(rarea) recast(line) 
		ci1opts(color(gs14) fintensity(100) yaxis(2))   
		plot1opts(lwidth(.50) yaxis(2)) 
		xlabel(, format(%9.2fc)) 
		xdimension(polar_change)
		ylabel(0(.25)1, format(%9.2fc) axis(2))
		ytitle("Marginal Effect", axis(2))
		addplot(kdensity polar_change if e(sample), xlab(`min'(`interval')`max') xtitle(Increase in Polarization) color(gs10) lpattern(dash) yaxis(1) yscale(alt off)
		|| function y = 0.00, range(`min' `max') lwidth(.25) yaxis(2)
		)
		legend(off)
		title("")
		subtitle("Vote Choice Econ - Change")
		;
		graph save "VC Econ Change", replace;
		;

		#delimit cr
		
#delimit;
probit Pres_Vote c.Med_Dist##c.polar_change c.Med_Dist_F2##c.polar_change Latino Black white_southerner female Income age weeklychurch Catholic Jew Union education_6cat policy_mood Mean_Dem_Support Party_Dis if year>=1971; 
sum polar_change if e(sample) ;
		local min = r(min) ;
		local max = r(max) ;
		local interval = ((`max'-`min')/10)  ;
		margins, dydx(Med_Dist_F2) at(polar_change=(`min'(`interval')`max')) vsquish ;

		#delimit ;
		marginsplot, xlabel(`min'(`interval')`max') recastci(rarea) recast(line) 
		ci1opts(color(gs14) fintensity(100) yaxis(2))   
		plot1opts(lwidth(.50) yaxis(2)) 
		xlabel(, format(%9.2fc)) 
		xdimension(polar_change)
		ylabel(0(.25)1, format(%9.2fc) axis(2))
		ytitle("Marginal Effect", axis(2))
		addplot(kdensity polar_change if e(sample), xlab(`min'(`interval')`max') xtitle(Increase in Polarization) color(gs10) lpattern(dash) yaxis(1) yscale(alt off)
		|| function y = 0.00, range(`min' `max') lwidth(.25) yaxis(2)
		)
		legend(off)
		title("")
		subtitle("Vote Choice Social - change")
		;
		graph save "VC Social Change", replace;
		;

		#delimit cr
		
#delimit;
regress PID_7 c.Med_Dist##c.polar_change c.Med_Dist_F2##c.polar_change Latino Black white_southerner female Income age weeklychurch Catholic Jew Union education_6cat policy_mood Mean_Dem_Support Party_Dis if year>=1971;
outreg2 using tableA2, auto(2) dec(2) alpha(.05) symbol(*) append;


	sum polar_change if e(sample) ;
		local min = r(min) ;
		local max = r(max) ;
		local name = "Social" ;
		local interval = ((`max'-`min')/10) ;
		margins, dydx(Med_Dist) at(polar_change=(`min'(`interval')`max')) vsquish ;

		#delimit ;
		marginsplot, xlabel(`min'(`interval')`max') recastci(rarea) recast(line) 
		ci1opts(color(gs14) fintensity(100) yaxis(2))   
		plot1opts(lwidth(.50) yaxis(2)) 
		xlabel(, format(%9.2fc)) 
		xdimension(polar_change)
		ylabel(0(.05).25, format(%9.2fc) axis(2))
		ytitle("Marginal Effect", axis(2))
		addplot(kdensity polar_change if e(sample), xlab(`min'(`interval')`max') xtitle(Increase in Polarization) color(gs10) lpattern(dash) yaxis(1) yscale(alt off)
		|| function y = 0.00, range(`min' `max') lwidth(.25) yaxis(2)
		)
		legend(off)
		title("")
		subtitle("PID Econ - change")
        name(Panel_`name', replace) 
		;
		graph save "PID - Econ change", replace;
		;

		#delimit cr
	
		
#delimit;
regress PID_7 c.Med_Dist##c.polar_change c.Med_Dist_F2##c.polar_change Latino Black white_southerner female Income age weeklychurch Catholic Jew Union education_6cat policy_mood Mean_Dem_Support Party_Dis if year>=1971;


	sum polar_change if e(sample) ;
		local min = r(min) ;
		local max = r(max) ;
		local name = "Social" ;
		local interval = ((`max'-`min')/10) ;
		margins, dydx(Med_Dist_F2) at(polar_change=(`min'(`interval')`max')) vsquish ;

		#delimit ;
		marginsplot, xlabel(`min'(`interval')`max') recastci(rarea) recast(line) 
		ci1opts(color(gs14) fintensity(100) yaxis(2))   
		plot1opts(lwidth(.50) yaxis(2)) 
		xlabel(0(.05).25, format(%9.2fc)) 
		xdimension(polar_change)
		ylabel(, format(%9.2fc) axis(2))
		ytitle("Marginal Effect", axis(2))
		addplot(kdensity polar_change if e(sample), xlab(`min'(`interval')`max') xtitle(Increase in Polarization) color(gs10) lpattern(dash) yaxis(1) yscale(alt off)
		|| function y = 0.00, range(`min' `max') lwidth(.25) yaxis(2)
		)
		legend(off)
		title("")
		subtitle("PID Social - change")
        name(Panel_`name', replace) 
		;
		graph save "PID Social- change", replace;
		;

		#delimit cr

graph combine "VC Econ Change" "VC Social Change" "PID - Econ change" "PID Social- change", xsize(6.5)
graph export "Combined Change Figures.pdf", replace 
