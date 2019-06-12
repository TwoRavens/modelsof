****************************
*All analysis in Stata 14.1*
****************************

*clear contents

clear

*load data 

use "/Users/goelzhauser/Box Sync/Research/classifying selection institutions/sppq replication/figure3.dta"

*set delimiter

#delimit;

*install package 'eclplot' to create plot;

*ssc install eclplot;

*create ordering variable for placement of results within the plot;

gen order=.;

*collects results from the cgp models;

replace order=1 if _id==1|_id==2|_id==3;

*collects results from the standard retention models;

replace order=2 if _id==4|_id==5|_id==6;

*create positioning variable for location of results within models;

gen position=.;

*collect results comparing retention and reappointment;

replace position=1 if order==1 & _id==1 & var=="appointed_cgp";
replace position=1 if order==2 & _id==4 & var=="reappointed";

*collect results comparing retention and nonpartisan election;

replace position=2 if order==1 & _id==1 & var=="nonpartisan_cgp";
replace position=2 if order==2 & _id==4 & var=="nonpartisan";

*collect results comparing retention and partisan election;

replace position=3 if order==1 & _id==1 & var=="partisan_cgp";
replace position=3 if order==2 & _id==4 & var=="partisan";

*collect results comparing reappointment and nonpartisan election;

replace position=4 if order==1 & _id==2 & var=="nonpartisan_cgp";
replace position=4 if order==2 & _id==5 & var=="nonpartisan";

*collect results comparing reappointment and partisan election;

replace position=5 if order==1 & _id==2 & var=="partisan_cgp";
replace position=5 if order==2 & _id==5 & var=="partisan";

*collect results comparing reappointment and partisan election;

replace position=6 if order==1 & _id==3 & var=="partisan_cgp";
replace position=6 if order==2 & _id==6 & var=="partisan";


*create figure 3;

eclplot coef ci_lower ci_upper position, 
	horizontal rplottype(rspike)
	xline(0, lpattern(dash))
	supby(order,spaceby(.15))
	estopts1(mcolor(black) msymbol(smcircle_hollow))
	estopts2(mcolor(black) msymbol(smcircle))
	ciopts1(lcolor(gray))
	ciopts2(lcolor(gray))
	xlabel(-1 -.5 0 .5 1)
	xtitle("OLS Coefficient", margin(medsmall))
	ytitle("", margin(medsmall))
		ylabel(	1 `" "Retention vs. Reappointed" "' 
			2 `" "Retention vs. Nonpartisan" "' 
			3 `" "Retention vs. Partisan" "'
			4 `" "Reappointed vs. Nonpartisan" "'
			5 `" "Reappointed vs. Partisan" "'
			6 `" "Nonpartisan vs. Partisan" "'
			)
	legend(order(2 "Choi, Gulati & Posner (2010)" 4 "Standard Retention") size(small));
