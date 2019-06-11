****************************
*All analysis in Stata 14.1*
****************************

*clear contents

clear

*load data 

use "/Users/goelzhauser/Box Sync/Research/classifying selection institutions/sppq replication/figure2.dta"

*set delimiter

#delimit;

*install package 'eclplot' to create plot;

*ssc install eclplot;

*create ordering variable for placement of results within the plot;

gen order=.;

*collects results from the cgp models;

replace order=1 if _id==1|_id==2|_id==3;

*collects results from the shepherd models;

replace order=2 if _id==4|_id==5|_id==6;

*collects results from the book of the states models;

replace order=3 if _id==7|_id==8|_id==9;

*collects results from the american judicature society models;

replace order=4 if _id==10|_id==11|_id==12;

*collects results from the formal merit selection models;

replace order=5 if _id==13|_id==14|_id==15;

*collects results from the voluntary merit selection models;

replace order=6 if _id==16|_id==17|_id==18;

*create positioning variable for location of results within models;

gen position=.;

*collect results comparing merit selection and appointment;

replace position=1 if order==1 & _id==1 & var=="appointed_cgp";
replace position=1 if order==2 & _id==4 & var=="appointed_s";
replace position=1 if order==3 & _id==7 & var=="appointed_bos";
replace position=1 if order==4 & _id==10 & var=="appointed_ajs";
replace position=1 if order==5 & _id==13 & var=="appointed_formal";
replace position=1 if order==6 & _id==16 & var=="appointed_voluntary";

*collect results comparing merit selection and nonpartisan election;

replace position=2 if order==1 & _id==1 & var=="nonpartisan_cgp";
replace position=2 if order==2 & _id==4 & var=="nonpartisan_s";
replace position=2 if order==3 & _id==7 & var=="nonpartisan_bos";
replace position=2 if order==4 & _id==10 & var=="nonpartisan_ajs";
replace position=2 if order==5 & _id==13 & var=="nonpartisan_formal";
replace position=2 if order==6 & _id==16 & var=="nonpartisan_voluntary";

*collect results comparing merit selection and partisan election;

replace position=3 if order==1 & _id==1 & var=="partisan_cgp";
replace position=3 if order==2 & _id==4 & var=="partisan_s";
replace position=3 if order==3 & _id==7 & var=="partisan_bos";
replace position=3 if order==4 & _id==10 & var=="partisan_ajs";
replace position=3 if order==5 & _id==13 & var=="partisan_formal";
replace position=3 if order==6 & _id==16 & var=="partisan_voluntary";

*collect results comparing appointment and nonpartisan election;

replace position=4 if order==1 & _id==2 & var=="nonpartisan_cgp";
replace position=4 if order==2 & _id==5 & var=="nonpartisan_s";
replace position=4 if order==3 & _id==8 & var=="nonpartisan_bos";
replace position=4 if order==4 & _id==11 & var=="nonpartisan_ajs";
replace position=4 if order==5 & _id==14 & var=="nonpartisan_formal";
replace position=4 if order==6 & _id==17 & var=="nonpartisan_voluntary";

*collect results comparing appointment and partisan election;

replace position=5 if order==1 & _id==2 & var=="partisan_cgp";
replace position=5 if order==2 & _id==5 & var=="partisan_s";
replace position=5 if order==3 & _id==8 & var=="partisan_bos";
replace position=5 if order==4 & _id==11 & var=="partisan_ajs";
replace position=5 if order==5 & _id==14 & var=="partisan_formal";
replace position=5 if order==6 & _id==17 & var=="partisan_voluntary";

*collect results comparing nonpartisan and partisan election;

replace position=6 if order==1 & _id==3 & var=="partisan_cgp";
replace position=6 if order==2 & _id==6 & var=="partisan_s";
replace position=6 if order==3 & _id==9 & var=="partisan_bos";
replace position=6 if order==4 & _id==12 & var=="partisan_ajs";
replace position=6 if order==5 & _id==15 & var=="partisan_formal";
replace position=6 if order==6 & _id==18 & var=="partisan_voluntary";


*create figure 2;

eclplot coef ci_lower ci_upper position, 
	horizontal rplottype(rspike)
	xline(0, lpattern(dash))
	supby(order,spaceby(.15))
	estopts1(mcolor(black) msymbol(smcircle_hollow))
	estopts2(mcolor(black) msymbol(smdiamond_hollow))
	estopts3(mcolor(black) msymbol(smtriangle_hollow))
	estopts4(mcolor(black) msymbol(smsquare_hollow))
	estopts5(mcolor(black) msymbol(smplus))
	estopts6(mcolor(black) msymbol(smx))
	ciopts1(lcolor(gray))
	ciopts2(lcolor(gray))
	ciopts3(lcolor(gray))
	ciopts4(lcolor(gray))
	ciopts5(lcolor(gray))
	ciopts6(lcolor(gray))
	xlabel(-1 -.5 0 .5 1)
	xtitle("OLS Coefficient", margin(medsmall))
	ytitle("", margin(medsmall))
		ylabel(	1 `" "Merit vs. Appointed" "' 
			2 `" "Merit vs. Nonpartisan" "' 
			3 `" "Merit vs. Partisan" "'
			4 `" "Appointed vs. Nonpartisan" "'
			5 `" "Appointed vs. Partisan" "'
			6 `" "Nonpartisan vs. Partisan" "'
			)
	legend(order(2 "Choi, Gulati & Posner (2010)" 4 "Shepherd (2009)" 6 "Book of the States" 8 "American Judicature Society" 10 "Formal" 12 "Formal and Voluntary") size(small));

