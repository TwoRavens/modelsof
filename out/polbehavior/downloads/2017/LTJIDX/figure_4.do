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


foreach x in A B C D E {
capture gen player_`x'="`x'"
}


*** 5 Period intervals

* Treatment 1 - LIT
twoway ///
	(scatter m5all_fin_y m5all_fin_x if marker5==1 & period==1 & type==1 & groupid==101, msymbol(O) mlcolor(black) mfcolor(gs0) msize(large) aspect(0.5604396)) ///
	(scatter m5all_fin_y m5all_fin_x if marker5==1 & period==6 & type==1 & groupid==101, msymbol(T) mlcolor(black) mfcolor(gs4) msize(large)) ///
	(scatter m5all_fin_y m5all_fin_x if marker5==1 & period==11 & type==1 & groupid==101, msymbol(D) mlcolor(black) mfcolor(gs8) msize(large)) ///
	(scatter m5all_fin_y m5all_fin_x if marker5==1 & period==16 & type==1 & groupid==101, msymbol(S) mlcolor(black) mfcolor(gs12) msize(large)) ///
	(function y=(71.34545 + sqrt(7.913765^2 -(x - 60.8)^2)) if period==1 & type==1 & groupid==101, lpattern(solid) lcolor(gs0) n(100000) range(20 111) color(black)) /// 
	(function y=(71.34545 - sqrt(7.913765^2 -(x - 60.8)^2)) if period==1 & type==1 & groupid==101, lpattern(solid) lcolor(gs0) n(100000) range(20 111) color(black)) ///
	(function y=(66.61818 + sqrt(4.289228^2 -(x - 50.14545)^2)) if period==6 & type==1 & groupid==101, lpattern(dash) lcolor(gs0) n(100000) range(20 111) color(black)) /// 
	(function y=(66.61818 - sqrt(4.289228^2 -(x - 50.14545)^2)) if period==6 & type==1 & groupid==101, lpattern(dash) lcolor(gs0) n(100000) range(20 111) color(black)) ///
	(function y=(68.50909 + sqrt(6.02053^2 -(x - 52.98182)^2)) if period==11 & type==1 & groupid==101, lpattern(dash) lcolor(gs0) n(100000) range(20 111) color(black)) /// 
	(function y=(68.50909 - sqrt(6.02053^2 -(x - 52.98182)^2)) if period==11 & type==1 & groupid==101, lpattern(dash) lcolor(gs0) n(100000) range(20 111) color(black)) ///
	(function y=(69.70909 + sqrt(6.413753^2 -(x - 50.87273)^2)) if period==16 & type==1 & groupid==101, lpattern(dash) lcolor(gs0) n(100000) range(20 111) color(black)) /// 
	(function y=(69.70909 - sqrt(6.413753^2 -(x - 50.87273)^2)) if period==16 & type==1 & groupid==101, lpattern(dash) lcolor(gs0) n(100000) range(20 111) color(black)) ///
	(scatter opt_y1 opt_x1 if type==1 & period==1 & groupid==101, mcolor(black) msize(medium) msymbol(o) mlabel(player_A) mlabcolor(black) mlabsize(medium) mlabposition(6)) ///
	(scatter opt_y2 opt_x2 if type==2 & period==1 & groupid==101, mcolor(black) msize(medium) msymbol(o) mlabel(player_B) mlabcolor(black) mlabsize(medium) mlabposition(9)) ///
	(scatter opt_y3 opt_x3 if type==3 & period==1 & groupid==101, mcolor(black) msize(medium) msymbol(o) mlabel(player_C) mlabcolor(black) mlabsize(medium) mlabposition(9)) ///
	(scatter opt_y4 opt_x4 if type==4 & period==1 & groupid==101, mcolor(black) msize(medium) msymbol(o) mlabel(player_D) mlabcolor(black) mlabsize(medium) mlabposition(7)) ///
	(scatter opt_y5 opt_x5 if type==5 & period==1 & groupid==101, mcolor(black) msize(medium) msymbol(o) mlabel(player_E) mlabcolor(black) mlabsize(medium) mlabposition(11)) ///
	if treatment==1, ///     
		legend(label(1 "{bf:Period 1-5}" "Mean outcome: 60.8 | 71.3" "Standard error of mean outcome: 3.96" "Distance of mean outcome to core: {bf:12.27}" " ") ///
				label(2 "{bf:Period 6-10}" "Mean outcome: 50.1 | 66.6" "Standard error of mean outcome: 2.14" "Distance of mean outcome to core: 1.79" " ") ///
				label(3 "{bf:Period 11-15}" "Mean outcome: 53.0 | 68.6" "Standard error of mean outcome: 4.01" "Distance of mean outcome to core: 4.01" " ") ///
				label(4 "{bf:Period 16-20}" "Mean outcome: 50.9 | 69.7" "Standard error of mean outcome: 2.54" "Distance of mean outcome to core: 2.54" " ") ///
			size(vsmall) order(1 2 3 4) pos(3) rows(4)) ///
		title(`"{bf: (A) Low-Inequality Treatment (LIT)}"', size(medsmall) color(black)) ///
		ytitle("") ///
		yscale(range(50 101)) ylabel(50 (10) 100, labsize(small) grid glwidth(vthin)) ///    
		xscale(range(20 111)) xlabel(20 (10) 110, labsize(small) grid glwidth(vthin)) /// 
		graphregion(color(white) margin(vsmall)) ///
		plotregion(lcolor(black) lwidth(medthick) margin(vsmall)) ///
		name(LIT_5per, replace)

* Treatment 2 - HIT
twoway ///
	(scatter m5all_fin_y m5all_fin_x if marker5==1 & period==1 & type==1 & groupid==201, msymbol(O) mlcolor(black) mfcolor(gs0) msize(large) aspect(0.5604396)) ///
	(scatter m5all_fin_y m5all_fin_x if marker5==1 & period==6 & type==1 & groupid==201, msymbol(T) mlcolor(black) mfcolor(gs4) msize(large)) ///
	(scatter m5all_fin_y m5all_fin_x if marker5==1 & period==11 & type==1 & groupid==201, msymbol(D) mlcolor(black) mfcolor(gs8) msize(large)) ///
	(scatter m5all_fin_y m5all_fin_x if marker5==1 & period==16 & type==1 & groupid==201, msymbol(S) mlcolor(black) mfcolor(gs12) msize(large)) ///
	(function y=(69.68333 + sqrt(8.586805^2 -(x - 52.5)^2)) if period==1 & type==1 & groupid==201, lpattern(dash) lcolor(gs0) n(100000) range(20 111) color(black)) /// 
	(function y=(69.68333 - sqrt(8.586805^2 -(x - 52.5)^2)) if period==1 & type==1 & groupid==201, lpattern(dash) lcolor(gs0) n(100000) range(20 111) color(black)) ///
	(function y=(68.38333 + sqrt(4.580858^2 -(x - 53.61666)^2)) if period==6 & type==1 & groupid==201, lpattern(solid) lcolor(gs0) n(100000) range(20 111) color(black)) /// 
	(function y=(68.38333 - sqrt(4.580858^2 -(x - 53.61666)^2)) if period==6 & type==1 & groupid==201, lpattern(solid) lcolor(gs0) n(100000) range(20 111) color(black)) ///
	(function y=(68.31667 + sqrt(8.364287^2 -(x - 60.95)^2)) if period==11 & type==1 & groupid==201, lpattern(solid) lcolor(gs0) n(100000) range(20 111) color(black)) /// 
	(function y=(68.31667 - sqrt(8.364287^2 -(x - 60.95)^2)) if period==11 & type==1 & groupid==201, lpattern(solid) lcolor(gs0) n(100000) range(20 111) color(black)) ///
	(function y=(70.58334 + sqrt(8.360567^2 -(x - 64.55)^2)) if period==16 & type==1 & groupid==201, lpattern(solid) lcolor(gs0) n(100000) range(20 111) color(black)) /// 
	(function y=(70.58334 - sqrt(8.360567^2 -(x - 64.55)^2)) if period==16 & type==1 & groupid==201, lpattern(solid) lcolor(gs0) n(100000) range(20 111) color(black)) ///
	(scatter opt_y1 opt_x1 if type==1 & period==1 & groupid==201, mcolor(black) msize(medium) msymbol(o) mlabel(player_A) mlabcolor(black) mlabsize(medium) mlabposition(6)) ///
	(scatter opt_y2 opt_x2 if type==2 & period==1 & groupid==201, mcolor(black) msize(medium) msymbol(o) mlabel(player_B) mlabcolor(black) mlabsize(medium) mlabposition(9)) ///
	(scatter opt_y3 opt_x3 if type==3 & period==1 & groupid==201, mcolor(black) msize(medium) msymbol(o) mlabel(player_C) mlabcolor(black) mlabsize(medium) mlabposition(9)) ///
	(scatter opt_y4 opt_x4 if type==4 & period==1 & groupid==201, mcolor(black) msize(medium) msymbol(o) mlabel(player_D) mlabcolor(black) mlabsize(medium) mlabposition(7)) ///
	(scatter opt_y5 opt_x5 if type==5 & period==1 & groupid==201, mcolor(black) msize(medium) msymbol(o) mlabel(player_E) mlabcolor(black) mlabsize(medium) mlabposition(11)) ///
	if treatment==2, ///     
		legend(label(1 "{bf:Period 1-5}" "Mean outcome: 52.5 | 69.7" "Standard error of mean outcome: 4.29" "Distance of mean outcome to core: 3.88" " ") ///
				label(2 "{bf:Period 6-10}" "Mean outcome: 53.6 | 68.4" "Standard error of mean outcome: 2.29" "Distance of mean outcome to core: {bf:4.63}" " ") ///
				label(3 "{bf:Period 11-15}" "Mean outcome: 61.0 | 68.3" "Standard error of mean outcome: 4.36" "Distance of mean outcome to core: {bf:11.95}" " ") ///
				label(4 "{bf:Period 16-20}" "Mean outcome: 64.6 | 70.6" "Standard error of mean outcome: 4.18" "Distance of mean outcome to core: {bf:15.76}" " ") ///
			size(vsmall) order(1 2 3 4) pos(3) rows(4)) ///
		title(`"{bf: (B) High-Inequality Treatment (HIT)}"', size(medsmall) color(black)) ///
		ytitle("") ///
		yscale(range(50 101)) ylabel(50 (10) 100, labsize(small) grid glwidth(vthin)) ///    
		xscale(range(20 111)) xlabel(20 (10) 110, labsize(small) grid glwidth(vthin)) /// 
		graphregion(color(white) margin(vsmall)) ///
		plotregion(lcolor(black) lwidth(medthick) margin(vsmall)) ///
		name(HIT_5per, replace)

* Treatment 3 - MT		
twoway ///
	(scatter m5all_fin_y m5all_fin_x if marker5==1 & period==1 & type==1 & groupid==301, msymbol(O) mlcolor(black) mfcolor(gs0) msize(large) aspect(0.5604396)) ///
	(scatter m5all_fin_y m5all_fin_x if marker5==1 & period==6 & type==1 & groupid==301, msymbol(T) mlcolor(black) mfcolor(gs4) msize(large)) ///
	(scatter m5all_fin_y m5all_fin_x if marker5==1 & period==11 & type==1 & groupid==301, msymbol(D) mlcolor(black) mfcolor(gs8) msize(large)) ///
	(scatter m5all_fin_y m5all_fin_x if marker5==1 & period==16 & type==1 & groupid==301, msymbol(S) mlcolor(black) mfcolor(gs12) msize(large)) ///
	(function y=(72.45 + sqrt(5.873662^2 -(x - 51.76667)^2)) if period==1 & type==1 & groupid==301, lpattern(dash) lcolor(gs0) n(100000) range(20 111) color(black)) /// 
	(function y=(72.45 - sqrt(5.873662^2 -(x - 51.76667)^2)) if period==1 & type==1 & groupid==301, lpattern(dash) lcolor(gs0) n(100000) range(20 111) color(black)) ///
	(function y=(70.25 + sqrt(4.499496^2 -(x - 51.66667)^2)) if period==6 & type==1 & groupid==301, lpattern(dash) lcolor(gs0) n(100000) range(20 111) color(black)) /// 
	(function y=(70.25 - sqrt(4.499496^2 -(x - 51.66667)^2)) if period==6 & type==1 & groupid==301, lpattern(dash) lcolor(gs0) n(100000) range(20 111) color(black)) ///
	(function y=(68.33334 + sqrt(7.614137^2 -(x - 56.18333)^2)) if period==11 & type==1 & groupid==301, lpattern(dash) lcolor(gs0) n(100000) range(20 111) color(black)) /// 
	(function y=(68.33334 - sqrt(7.614137^2 -(x - 56.18333)^2)) if period==11 & type==1 & groupid==301, lpattern(dash) lcolor(gs0) n(100000) range(20 111) color(black)) ///
	(function y=(68.78333 + sqrt(6.885345^2 -(x - 53.65)^2)) if period==16 & type==1 & groupid==301, lpattern(dash) lcolor(gs0) n(100000) range(20 111) color(black)) /// 
	(function y=(68.78333 - sqrt(6.885345^2 -(x - 53.65)^2)) if period==16 & type==1 & groupid==301, lpattern(dash) lcolor(gs0) n(100000) range(20 111) color(black)) ///
	(scatter opt_y1 opt_x1 if type==1 & period==1 & groupid==301, mcolor(black) msize(medium) msymbol(o) mlabel(player_A) mlabcolor(black) mlabsize(medium) mlabposition(6)) ///
	(scatter opt_y2 opt_x2 if type==2 & period==1 & groupid==301, mcolor(black) msize(medium) msymbol(o) mlabel(player_B) mlabcolor(black) mlabsize(medium) mlabposition(9)) ///
	(scatter opt_y3 opt_x3 if type==3 & period==1 & groupid==301, mcolor(black) msize(medium) msymbol(o) mlabel(player_C) mlabcolor(black) mlabsize(medium) mlabposition(9)) ///
	(scatter opt_y4 opt_x4 if type==4 & period==1 & groupid==301, mcolor(black) msize(medium) msymbol(o) mlabel(player_D) mlabcolor(black) mlabsize(medium) mlabposition(7)) ///
	(scatter opt_y5 opt_x5 if type==5 & period==1 & groupid==301, mcolor(black) msize(medium) msymbol(o) mlabel(player_E) mlabcolor(black) mlabsize(medium) mlabposition(11)) ///
	if treatment==3, ///     
		legend(label(1 "{bf:Period 1-5}" "Mean outcome: 51.8 | 72.5" "Standard error of mean outcome: 2.94" "Distance of mean outcome to core: 5.24" " ") ///
				label(2 "{bf:Period 6-10}" "Mean outcome: 51.7 | 70.3" "Standard error of mean outcome: 2.25" "Distance of mean outcome to core: 3.49" " ") ///
				label(3 "{bf:Period 11-15}" "Mean outcome: 56.2 | 68.3" "Standard error of mean outcome: 3.81" "Distance of mean outcome to core: 7.19" " ") ///
				label(4 "{bf:Period 16-20}" "Mean outcome: 53.7 | 68.8" "Standard error of mean outcome: 3.44" "Distance of mean outcome to core: 4.72" " ") ///
			size(vsmall) order(1 2 3 4) pos(3) rows(4)) ///
		title(`"{bf: (C) Misery Treatment (MT)}"', size(medsmall) color(black)) ///
		ytitle("") ///
		yscale(range(50 101)) ylabel(50 (10) 100, labsize(small) grid glwidth(vthin)) ///    
		xscale(range(20 111)) xlabel(20 (10) 110, labsize(small) grid glwidth(vthin)) /// 
		graphregion(color(white) margin(vsmall)) ///
		plotregion(lcolor(black) lwidth(medthick) margin(vsmall)) ///
		name(MT_5per, replace)

graph combine LIT_5per HIT_5per MT_5per, ///
	graphregion(color(white) margin(vsmall)) ///
	cols(1) ///
	note("{it:Note:}" "Circles in the plots have a radius of two standard errors of mean decisions in five-period intervals."  "Solid circels in the plots and bold entries in the legends indicate significant differences from the core.", size(vsmall))
graph display, ysize(7.9) xsize(6) scale(.9)
graph export "Figure_4.png", width(3000) replace




