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
**		Note: 	Before running this file, please run file "incentives_policy_space.do"	**
**				Complete analysis can be run from file "Analyses_Political_Behavior.do".**
**																	 					**
**																						**
******************************************************************************************
******************************************************************************************

* Plots: Average payouts


// LIT
twoway ///
	(contour t1avg_points y x, scolor(white) ecolor(gs4) crule(linear) ccuts(0 (25) 850)) ///	
	(scatter t1_opt_y1 t1_opt_x1 if x==100 & y==100, mcolor(black) msize(medium) msymbol(o) mlabel(player_A) mlabcolor(black) mlabposition(6) mlabsize(medium)) ///
	(scatter t1_opt_y2 t1_opt_x2 if x==100 & y==100, mcolor(black) msize(medium) msymbol(o) mlabel(player_B) mlabcolor(black) mlabposition(7) mlabsize(medium)) ///
	(scatter t1_opt_y3 t1_opt_x3 if x==100 & y==100, mcolor(black) msize(medium) msymbol(o) mlabel(player_C) mlabcolor(black) mlabposition(9) mlabsize(medium)) ///
	(scatter t1_opt_y4 t1_opt_x4 if x==100 & y==100, mcolor(black) msize(medium) msymbol(o) mlabel(player_D) mlabcolor(black) mlabposition(1) mlabsize(medium)) ///
	(scatter t1_opt_y5 t1_opt_x5 if x==100 & y==100, mcolor(black) msize(medium) msymbol(o) mlabel(player_E) mlabcolor(black) mlabposition(3) mlabsize(medium)) ///
	if (x>9 & x<121 & y>39 & y<111), ///
	zlabel(0 (50) 850, labsize(vsmall)) ///
	clegend( title("Average" "number" "of tokens", size(vsmall)) width(4) forcesize region(margin(vsmall)) bmargin(vsmall)) ///
	ztitle("") ///
	ytitle("") ///
	xtitle("") ///
	scheme(s1mono) ///
	yscale(range(40 110)) ylabel(40 (10) 110, nogrid labsize(small)) ///    
	xscale(range(10 120)) xlabel(10 (10) 120, nogrid labsize(small)) ///
	title(`"{bf: (A) Low-Inequality Treatment (LIT)}"', size(medsmall) color(black)) ///
    legend(off) ///
	aspect(0.636364) ///
	graphregion(color(white) margin(vsmall)) ///
	plotregion(margin(vsmall)) ///
	name(LIT_polspa_avg, replace)


// HIT
twoway ///
	(contour t2avg_points y x, scolor(white) ecolor(gs4) crule(linear) ccuts(0 (25) 850)) ///	
	(scatter t2_opt_y1 t2_opt_x1 if x==100 & y==100, mcolor(black) msize(medium) msymbol(o) mlabel(player_A) mlabcolor(black) mlabposition(6) mlabsize(medium)) ///
	(scatter t2_opt_y2 t2_opt_x2 if x==100 & y==100, mcolor(black) msize(medium) msymbol(o) mlabel(player_B) mlabcolor(black) mlabposition(7) mlabsize(medium)) ///
	(scatter t2_opt_y3 t2_opt_x3 if x==100 & y==100, mcolor(black) msize(medium) msymbol(o) mlabel(player_C) mlabcolor(black) mlabposition(9) mlabsize(medium)) ///
	(scatter t2_opt_y4 t2_opt_x4 if x==100 & y==100, mcolor(black) msize(medium) msymbol(o) mlabel(player_D) mlabcolor(black) mlabposition(1) mlabsize(medium)) ///
	(scatter t2_opt_y5 t2_opt_x5 if x==100 & y==100, mcolor(black) msize(medium) msymbol(o) mlabel(player_E) mlabcolor(black) mlabposition(3) mlabsize(medium)) ///
	if (x>9 & x<121 & y>39 & y<111), ///
	zlabel(0 (50) 850, labsize(vsmall)) ///
	clegend( title("Average" "number" "of tokens", size(vsmall)) width(4) forcesize region(margin(vsmall)) bmargin(tiny)) ///
	ztitle("") ///
	ytitle("") ///
	xtitle("") ///
	scheme(s1mono) ///
	yscale(range(40 110)) ylabel(40 (10) 110, nogrid labsize(small)) ///    
	xscale(range(10 120)) xlabel(10 (10) 120, nogrid labsize(small)) ///
	title(`"{bf: (B) High-Inequality Treatment (HIT)}"', size(medsmall) color(black)) ///
    legend(off) ///
	aspect(0.636364) ///
	graphregion(color(white) margin(vsmall)) ///
	plotregion(margin(vsmall)) ///
	name(HIT_polspa_avg, replace)


// MT
twoway ///
	(contour t3avg_points y x, scolor(white) ecolor(gs4) crule(linear) ccuts(0 (25) 850)) ///	
	(scatter t3_opt_y1 t3_opt_x1 if x==100 & y==100, mcolor(black) msize(medium) msymbol(o) mlabel(player_A) mlabcolor(black) mlabposition(6) mlabsize(medium)) ///
	(scatter t3_opt_y2 t3_opt_x2 if x==100 & y==100, mcolor(black) msize(medium) msymbol(o) mlabel(player_B) mlabcolor(black) mlabposition(7) mlabsize(medium)) ///
	(scatter t3_opt_y3 t3_opt_x3 if x==100 & y==100, mcolor(black) msize(medium) msymbol(o) mlabel(player_C) mlabcolor(black) mlabposition(9) mlabsize(medium)) ///
	(scatter t3_opt_y4 t3_opt_x4 if x==100 & y==100, mcolor(black) msize(medium) msymbol(o) mlabel(player_D) mlabcolor(black) mlabposition(1) mlabsize(medium)) ///
	(scatter t3_opt_y5 t3_opt_x5 if x==100 & y==100, mcolor(black) msize(medium) msymbol(o) mlabel(player_E) mlabcolor(black) mlabposition(3) mlabsize(medium)) ///
	if (x>9 & x<121 & y>39 & y<111), ///
	zlabel(0 (50) 850, labsize(vsmall)) ///
	clegend( title("Average" "number" "of tokens", size(vsmall)) width(4) forcesize region(margin(vsmall)) bmargin(tiny)) ///
	ztitle("") ///
	ytitle("") ///
	xtitle("") ///
	scheme(s1mono) ///
	yscale(range(40 110)) ylabel(40 (10) 110, nogrid labsize(small)) ///    
	xscale(range(10 120)) xlabel(10 (10) 120, nogrid labsize(small)) ///
	title(`"{bf: (C) Misery Treatment (MT)}"', size(medsmall) color(black)) ///
    legend(off) ///
	aspect(0.636364) ///
	graphregion(color(white) margin(vsmall)) ///
	plotregion(margin(vsmall)) ///
	name(MT_polspa_avg, replace)



graph combine LIT_polspa_avg ///
			HIT_polspa_avg ///
			MT_polspa_avg, ///
			imargin(tiny) rows(3) xsize(3.5) ysize(7) iscale(1) graphregion(color(white) margin(vsmall))
graph export "fig_supp_A.png", width(2000) replace




