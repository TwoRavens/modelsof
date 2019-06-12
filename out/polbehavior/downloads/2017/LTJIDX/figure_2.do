******************************************************************************************
******************************************************************************************
**		Date: July 2017																	**
**																						**
**		Replication files for article													**
**		DO INDIVIDUALS VALUE DISTRIBUTIONAL FAIRNESS? 									**
**		HOW INEQUALITY AFFECTS MAJORITY DECISIONS										**
**		in: Political Behavior															**
**																						**
**		Author: JAN SAUERMANN															**
**				Cologne Center for Comparative Politics									**
**				University of Cologne													**
**																						**
**																						**
**		Note: 	Before running this file, please run file "data_reading.do"				**
**				Complete analysis can be run from file "Analyses_Political_Behavior.do".**
**																	 					**
**																						**
******************************************************************************************
******************************************************************************************



foreach x in A B C D E{
capture gen player_`x'="`x'"
}

*** Ideal-points
twoway ///
	(function y = -10.4 + (16/10)*x , range(30 80) lcolor(gs10) lpattern(dash) lwidth(medium)) ///
	(function y = 80.25 - (1/4)*x , range(20 120) lcolor(gs10) lpattern(dash) lwidth(medium)) ///
	(scatter opt_y1 opt_x1 if type==1 & period==1 & groupid==101, mcolor(black) msize(large) msymbol(lgx) mlabel(player_A) mlabcolor(black) mlabposition(6) mlabsize(medlarge)) ///
	(scatter opt_y2 opt_x2 if type==2 & period==1 & groupid==101, mcolor(black) msize(large) msymbol(lgx) mlabel(player_B) mlabcolor(black) mlabposition(7) mlabsize(medlarge)) ///
	(scatter opt_y3 opt_x3 if type==3 & period==1 & groupid==101, mcolor(black) msize(large) msymbol(lgx) mlabel(player_C) mlabcolor(black) mlabposition(9) mlabsize(medlarge)) ///
	(scatter opt_y4 opt_x4 if type==4 & period==1 & groupid==101, mcolor(black) msize(large) msymbol(lgx) mlabel(player_D) mlabcolor(black) mlabposition(1) mlabsize(medlarge)) ///
	(scatter opt_y5 opt_x5 if type==5 & period==1 & groupid==101, mcolor(black) msize(large) msymbol(lgx) mlabel(player_E) mlabcolor(black) mlabposition(3) mlabsize(medlarge)), ///
		title("{bf: (A) Location of ideal points}", color(black) size(medsmall)) ///
		ytitle("Y", size(small)) ///
		xtitle("X", size(small)) ///
		legend(off) ///
		yscale(range(0 150)) ylabel(0 (10) 150, labsize(vsmall) grid glwidth(thin)) ///    
		xscale(range(0 200)) xlabel(0 (10) 200, labsize(vsmall) grid glwidth(thin)) ///    
		graphregion(color(white) margin(medium)) ///
		plotregion(lcolor(black) lwidth(medium) margin(0)) ///
		xsize(4) ysize(3.2) ///
		name(idealpoints, replace)



*** Payout-Functions
forvalues i=-200(25)200 {
  local lab : display abs(`i')
  local xlabs `"`xlabs' `i' "`lab'""'
}
display `"label string: [`xlabs']"'

twoway ///
	(function y=(0.75*(1000*(exp(-abs(0-x)/125)))+(0.25)*(1000*(exp(-((abs(0-x))^2)/7200)))), range(-200 200) plotregion(margin(0)) color(black) clwidth(*1.2)) ///
	(function y=(0.5*(1000*(exp(-abs(0-x)/25)))+(0.5)*(1000*(exp(-((abs(0-x))^2)/1800)))), range(-200 200) plotregion(margin(0)) color(black) clwidth(*1.2)), ///
	legend(off) xlabel(0 (0.1) 1, labsize(small)) ylabel(0(0.1)1, labsize(small) nogrid) ///
	ytitle("Tokens", size(small)) ///
	xtitle("Distance to ideal point", size(small)) ///
	yscale(range(0 1000)) ylabel(0 (100) 1000, labsize(vsmall) grid glwidth(thin)) ///    
	xscale(range(-200 200)) xlabel(`xlabs', labsize(vsmall) nogrid) ///   
	text(140 60 "Steep payout function ({it:f}2)", placement(e) color(black) size(small)) ///
	text(650 60 "Flat payout function ({it:f}1)", placement(e) color(black) size(small)) ///
	title("{bf: (B) Shape of payout functions}", color(black) size(medsmall)) ///
	graphregion(color(white) margin(medium)) xsize(4) fysize(50) ///
	name(functions, replace)


graph combine idealpoints functions, ///
	graphregion(color(white) margin(vsmall)) ///
	rows(2) xsize(4) ysize(5.5)
graph export "Figure_2.png", width(4000) replace




