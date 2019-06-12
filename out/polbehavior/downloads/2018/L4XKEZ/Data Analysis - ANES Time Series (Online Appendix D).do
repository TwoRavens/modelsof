/*******************************************************************************
The following .do file contains the code necessary to generate the analyses
reported in Online Appendix D. In these analyses we try and correct for skew
in the importance measures by first constructing the respondent's mean
importance rating across all items and substracting the mean from each
individual item. 

Some additional STATA modules need to be installed to run this code: 
	
 ssc install parmest
 ssc install combomarginsplot
 ssc install estout
 ssc install blindschemes
 
 *******************************************************************************/

clear
set more off
cd "C:\Users\Joshua\Dropbox\Work\Isssue Importance and Voting Paper\Dataverse"
	/*
	update this to run the code. make sure that all the data and data 
	cleaning files are in the same folder
	*/



				***********************************
				***********************************
				***********************************
				***********1980 ANES TS************
				***********************************
				***********************************
				***********************************

*Data Cleaning
do "Data Cleaning - 1980 ANES TS.do"
set more off

/******Create Corrected Importance Measures****/

/*Mean Importance*/
egen imp_mean = rowmean(abortion80imp_cat  blackaid80imp_cat   ///
	defense80imp_cat  jobs80imp_cat  russia80imp_cat  spend80imp_cat  unemploy80imp_cat )

foreach var in abortion80imp_cat  blackaid80imp_cat  ///
		defense80imp_cat  jobs80imp_cat  russia80imp_cat  spend80imp_cat  unemploy80imp_cat  {
		gen `var'_corr = `var' - imp_mean
		summ `var'_corr 
		gen `var'_corr01 = (`var'_corr - r(min))/(r(max)-r(min))
		}
	
/********Interaction Models*******/
	
*Interaction Models, Marginal Effects, and LR Tests
eststo clear
estimates clear
*Defense
	eststo: logit vote c.defense80prox01##c.defense80imp_cat_corr01 spend80prox01 abortion80prox01 blackaid80prox01 ///
	unemploy80prox01 jobs80prox01 russia80prox01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 

	/*Wald Test*/
	testparm c.defense80imp_cat_corr01 c.defense80prox01#c.defense80imp_cat_corr01

	/*Interactions*/
	margins, dydx(defense80prox01) at(defense80imp_cat_corr01=(0(0.25)1))
	marginsplot, yline(0, lpattern(dash)) xtitle("") xlabel(0 "Min" 1 "Max") title("Defense: 1980", size(medsmall)) scheme(plottig) ytitle("") 	 ///
	  text(0.55 0.25 "Z=0.61; Wald: p = 0.68", size(vsmall) justification(right) size(vsmall) ) ylabel(-0.6(0.2)0.6) 


		graph save "Defense1980C", replace		
		
*Spend
eststo: logit vote defense80prox01 c.spend80prox01##c.spend80imp_cat_corr01 abortion80prox01 blackaid80prox01 ///
		unemploy80prox01 jobs80prox01 russia80prox01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 

	*Wald Test 
		testparm c.spend80imp_cat_corr01 c.spend80prox01#c.spend80imp_cat_corr01
	*Margins
		margins, dydx(spend80prox01) at(spend80imp_cat_corr01=(0(0.25)1)) 
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Spending:1980, size(medsmall)) scheme(plottig) ///
			yline(0, lpattern(dash)) text(0.55 0.25 "Z=1.51; Wald: p = 0.26", size(vsmall) size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6) 
			
		graph save "Spend1980C", replace


*Abortion
	eststo: logit vote defense80prox01 spend80prox01 c.abortion80prox01##c.abortion80imp_cat_corr01 blackaid80prox01 ///
		unemploy80prox01 jobs80prox01 russia80prox01 pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 
	
	*LR Test 
		testparm c.abortion80imp_cat_corr01 c.abortion80prox01#c.abortion80imp_cat_corr01
	*Margins
		margins, dydx(abortion80prox01) at(abortion80imp_cat_corr01=(0(0.25)1)) 
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Abortion:1980, size(medsmall)) scheme(plottig) ///
			yline(0, lpattern(dash)) text(0.55 0.25 "Z=-1.46; Wald: p = 0.17", size(vsmall) size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6) 
			
		graph save "Abortion1980C", replace
		
*Aid to Blacks
		eststo: logit vote defense80prox01 spend80prox01 abortion80prox01 c.blackaid80prox01##c.blackaid80imp_cat_corr01 ///
			unemploy80prox01 jobs80prox01 russia80prox01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 
		
		*Wald Test
			testparm c.blackaid80imp_cat_corr01 c.blackaid80prox01#c.blackaid80imp_cat_corr01
		*Margins
			margins, dydx(blackaid80prox01) at(blackaid80imp_cat_corr01=(0(0.25)1)) 
			marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Aid Blacks:1980, size(medsmall)) scheme(plottig) ///
				yline(0, lpattern(dash)) text(0.55 0.25 "Z=0.85; Wald: p = 0.64", size(vsmall) size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6) 
				
				 
			graph save "BlackAid1980C", replace
			

*Unemployment
		eststo: logit vote defense80prox01 spend80prox01 abortion80prox01 blackaid80prox01 ///
			c.unemploy80prox01##c.unemploy80imp_cat_corr01 jobs80prox01 russia80prox01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income0
		
		*Wald Test 
			testparm c.unemploy80imp_cat_corr01 c.unemploy80prox01#c.unemploy80imp_cat_corr01
		*Margins
			margins, dydx(unemploy80prox01) at(unemploy80imp_cat_corr01=(0(0.25)1))
			marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Unemployment:1980, size(medsmall)) scheme(plottig) ///
				yline(0, lpattern(dash)) text(0.55 0.25 "Z=-0.23; Wald: p = 0.95", size(vsmall) size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6) 
				
			graph save "Unemploy1980C", replace

*Jobs
		eststo: logit vote defense80prox01 spend80prox01 abortion80prox01 blackaid80prox01 unemploy80prox01 ///
			c.jobs80prox01##c.jobs80imp_cat_corr01 russia80prox01 pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 

		*LR Test 
			testparm c.jobs80imp_cat_corr01 c.jobs80prox01#c.jobs80imp_cat_corr01
			
		*Margins
			margins, dydx(jobs80prox01) at(jobs80imp_cat_corr01=(0(0.25)1)) 
			marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Jobs:1980, size(medsmall)) scheme(plottig) ///
				yline(0, lpattern(dash)) text(0.55 0.25 "Z=1.87; Wald: p = 0.13", size(vsmall) size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6) 
				
				
			graph save "Jobs1980C", replace
			
*Russia
		eststo: logit vote defense80prox01 spend80prox01 abortion80prox01 blackaid80prox01 unemploy80prox01 jobs80prox01 ///
			c.russia80prox01##c.russia80imp_cat_corr01 pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 

	
		*LR Test 
			testparm c.russia80imp_cat_corr01 c.russia80prox01#c.russia80imp_cat_corr01
		*Margins
			margins, dydx(russia80prox01) at(russia80imp_cat_corr01=(0(0.25)1)) 
			marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Russia:1980, size(medsmall)) scheme(plottig) ///
				yline(0, lpattern(dash)) text(0.55 0.25 "Z=1.00; Wald: p = 0.61", size(vsmall) size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6) 
				
			graph save "Russia1980C", replace
			

*Table
esttab using 1980_Interactions_CORR.rtf, replace se pr2 aic bic onecell ///
		star(+ 0.10 * 0.05 ** 0.01) label nobaselevels ///
		title({\b Table XX.} Subjective Importance and Proximity Voting - 1980 TS) ///
		mtitle("Defense" "Spend" "Abortion" "Aid to Blacks" "Unempl." "Jobs" "Russia")
	eststo clear
			
/*Figure*/
graph combine "Defense1980C" "Spend1980C" "Abortion1980C" "BlackAid1980C" ///
	"Unemploy1980C" "Jobs1980C" "Russia1980C" , scheme(plottig) title("1980 ANES - Corrected Importance", size(medsmall)) 

graph save "1980 ANES - Corrected Analyses", replace
graph export "1980 ANES - Corrected Analyses.png", replace


	
							
					***********************************
					***********************************
					***********************************
					***********1984 ANES TS************
					***********************************
					***********************************
					***********************************

clear
*Data Cleaning
do "Data Cleaning - 1984 ANES TS.do"
set more off

/****Corrected****/
egen imp_mean = rowmean(spend84imp jobs84imp central84imp women84imp)

foreach var in spend84imp jobs84imp central84imp women84imp {
	gen `var'_corr = `var' - imp_mean
	summar `var'_corr
	gen `var'_corr01 = (`var'_corr - r(min))/(r(max)-r(min))
	}

eststo clear

***Interaction Models
*Spend
eststo clear
eststo: logit vote c.spend84prox01##c.spend84imp_corr01 jobs84prox01 central84prox01 women84prox01 pid01 i.ideol ///
		econ01  i.gender i.race age01 educ01 income01
	
	*Test Parm
		testparm c.spend84imp_corr01 c.spend84prox01#c.spend84imp_corr01
	
	*Margins
		margins, dydx(spend84prox01) at(spend84imp_corr01=(0(0.25)1))  saving(1984_spend, replace)
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Spend:1984, size(medsmall)) scheme(plottig) ///
		yline(0, lpattern(dash))  text(0.55 0.25 "Z=1.49; Wald: p = 0.15", size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6) 

		graph save "Spend1984C", replace
											
				
*Jobs
eststo: logit vote spend84prox01 c.jobs84prox01##c.jobs84imp_corr01 central84prox01 women84prox01 ///
	pid01 i.ideol econ01  i.gender i.race age01 educ01 income01


	*LR Test
		testparm c.jobs84imp_corr01 c.jobs84prox01#c.jobs84imp_corr01


	*Margins
		margins, dydx(jobs84prox01) at(jobs84imp_corr01=(0(0.25)1))  saving(1984_jobs, replace)
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Jobs:1984, size(medsmall)) scheme(plottig) ///
		yline(0, lpattern(dash))  text(0.55 0.25 "Z=-0.36; Wald: p = 0.72", size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6) 
		
		graph save "Jobs1984C", replace


*Central		
eststo: logit vote spend84prox01 c.jobs84prox01 c.central84prox01##c.central84imp_corr01 women84prox01 ///
	pid01 i.ideol econ01 i.gender i.race age01 educ01 income01

	*LR Test
		testparm c.central84imp_corr01 c.central84prox01#c.central84imp_corr01


	*Margins
		margins, dydx(central84prox01) at(central84imp_corr01=(0(0.25)1))  saving(1984_central, replace)
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(C.America:1984, size(medsmall)) scheme(plottig) ///
		yline(0, lpattern(dash))  text(0.55 0.25 "Z=1.29; Wald: p = 0.43", size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6) 
		
		graph save "Central1984C", replace
		

*Women
eststo: logit vote spend84prox01 c.jobs84prox01 c.central84prox01 c.women84prox01##c.women84imp_corr01  ///
	pid01 i.ideol econ01 i.gender i.race age01 educ01 income01 

	*LR Test
		testparm c.women84imp_corr01 c.women84prox01#c.women84imp_corr01

	*Margins
		margins, dydx(women84prox01) at(women84imp_corr01=(0(0.25)1))  saving(1984_women, replace)
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Women:1984, size(medsmall)) scheme(plottig) ///
		yline(0, lpattern(dash)) text(0.55 0.25 "Z=1.77; Wald: p = 0.16", size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6) 
		
		graph save "Women1984C", replace

				*Table
			esttab using 1984_Interactions_CORR.rtf, replace se pr2 aic bic onecell ///
				star(+ 0.10 * 0.05 ** 0.01) label nobaselevels ///
				mtitle("Spending" "Jobs" "Central" "Woman") ///
				title({\b Table XX.} "Subjective Importance and Proximity Voting - 1984 TS (Corrected)")

			eststo clear	
		
/*Graph*/
graph combine "Spend1984C" "Jobs1984C"  "Central1984C" "Women1984C" , title("1984 ANES", size(medsmall)) scheme(plottig) 


graph save "ANES 1984 Corrected", replace
graph export "ANES 1984 Corrected.png", replace

		
		
				***********************************
				***********************************
				***********************************
				***********1996 ANES TS************
				***********************************
				***********************************
				***********************************
				***********************************

clear
*Data cleaning
do "Data Cleaning - 1996 ANES TS.do"
set more off

/****Corrected Importance****/
egen imp_mean = rowmean(spend96imp defense96imp blackaid96imp abortion96imp enviro96imp)

foreach var in spend96imp defense96imp blackaid96imp abortion96imp enviro96imp {
	gen `var'_corr = `var' - imp_mean
	summ `var'_corr 
	gen `var'_corr01 = (`var'_corr - r(min))/(r(max)-r(min))
	}


*Interaction Models
*Spend
eststo clear
estimates clear
eststo: logit vote c.spend96prox01##c.spend96imp_corr01 c.defense96prox01 c.blackaid96prox01 c.abortion96prox01 ///
	c.enviro96prox01 pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01  [pweight=V960003]

	testparm c.spend96imp_corr01 c.spend96prox01#c.spend96imp_corr01

*Margins
	margins, dydx(spend96prox01) at(spend96imp_corr01=(0(0.25)1))  saving(1996_spend, replace)
	marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Spend:1996, size(medsmall)) scheme(plottig) ///
	yline(0, lpattern(dash)) text(0.55 0.35 "Z=2.42; Wald: p = 0.04", size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6) 
	
	
	graph save "Spend1996C", replace

*Defense
eststo: logit vote c.spend96prox01 c.defense96prox01##c.defense96imp_corr01 c.blackaid96prox01 c.abortion96prox01 c.enviro96prox01 ///
	pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 [pweight=V960003]

	testparm  c.defense96imp_corr01 c.defense96prox01#c.defense96imp_corr01

*Margins
	margins, dydx(defense96prox01) at(defense96imp_corr01=(0(0.25)1))  saving(1996_defense, replace)
	marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Defense:1996, size(medsmall)) scheme(plottig) ///
	yline(0, lpattern(dash)) text(0.55 0.35 "Z=2.92; Wald: p = 0.01", size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6) 
	
	graph save "Defense1996C", replace
	
*Aid to Blacks
eststo: logit vote c.spend96prox01 c.defense96prox01 c.blackaid96prox01##c.blackaid96imp_corr01 c.abortion96prox01 c.enviro96prox01 ///
	pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01  [pweight=V960003]

	testparm c.blackaid96imp_corr01 c.blackaid96prox01#c.blackaid96imp_corr01 

*Margins
	margins, dydx(blackaid96prox01) at(blackaid96imp_corr01=(0(0.25)1))  saving(1996_blackaid, replace)
	marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Aid Blacks:1996, size(medsmall)) scheme(plottig) ///
	yline(0, lpattern(dash)) text(0.55 0.35 "Z=0.52; Wald: p = 0.34", size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6) 
	
	graph save "Aid Blacks1996C", replace
						

*Abortion
eststo: logit vote c.spend96prox01 c.defense96prox01 c.blackaid96prox01 c.abortion96prox01##c.abortion96imp_corr01 c.enviro96prox01 ///
	pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01  [pweight=V960003]

	testparm c.abortion96imp_corr01 c.abortion96prox01#c.abortion96imp_corr01

*Margins
	margins, dydx(abortion96prox01) at(abortion96imp_corr01=(0(0.25)1))  saving(1996_abortion, replace)
	marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Abortion:1996, size(medsmall)) scheme(plottig) ///
	yline(0, lpattern(dash)) text(0.55 0.35 "Z=0.96; Wald: p = 0.63", size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6) 
	
	graph save "Abortion1996C", replace
		
*Environment
eststo: logit vote c.spend96prox01 c.defense96prox01 c.blackaid96prox01 c.abortion96prox01 c.enviro96prox01##c.enviro96imp_corr01  ///
	pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01  [pweight=V960003]

	testparm c.enviro96imp_corr01 c.enviro96prox01#c.enviro96imp_corr01

*Margins
	margins, dydx(enviro96prox01) at(enviro96imp_corr01=(0(0.25)1))  saving(1996_enviro, replace)
	marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Enviro:1996, size(medsmall)) scheme(plottig) ///
	yline(0, lpattern(dash)) text(0.55 0.35 "Z=-0.88; Wald: p = 0.68", size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6) 
	
	graph save "Enviro1996C", replace
		
		
						
*Table
esttab using 1996_Interactions.rtf, replace se pr2 aic bic onecell ///
		star(+ 0.10 * 0.05 ** 0.01) label nobaselevels addnote(Results are weighted:V960003) ///
		title({\b Table XX.} Subjective Importance and Proximity Voting - 1996 TS)

					
/*Figure*/
graph combine 	"Spend1996C"  "Defense1996C" "Aid Blacks1996C" "Abortion1996C" "Enviro1996C" , ///
	title("1996 ANES", size(medsmall)) scheme(plottig)  
	
graph save "ANES 1996 Corrected", replace
graph export "ANES 1996 Corrected.png", replace


							
					***********************************
					***********************************
					***********************************
					***********2000 ANES TS************
					***********************************
					***********************************
					***********************************

clear
do "Data Cleaning - 2000 ANES TS.do"
set more off

/***Corrected Importance****/

egen imp_mean = rowmean(abortion2000imp guns2000imp regulation2000imp)

foreach var in abortion2000imp guns2000imp regulation2000imp {
	gen `var'_corr = `var' - imp_mean
	summ `var'_corr
	gen `var'_corr01 = (`var'_corr - r(min))/(r(max)-r(min))
	}
	
		
*Interaction Models*
*Abortion
eststo clear
eststo: logit vote c.abortion2000prox01##c.abortion2000imp_corr01 c.guns2000prox01 c.regulation2000prox01 pid01 i.ideol econ01 ///
	i.gender i.race age01 educ01 income01  [pweight = V000002a]
	
	*Wald Test
	testparm c.abortion2000imp_corr01 c.abortion2000prox01#c.abortion2000imp_corr01
	
	*Margins
		margins, dydx(abortion2000prox01) at(abortion2000imp_corr01=(0(0.25)1)) saving(2000_abortion, replace)
		
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Abortion:2000, size(medsmall)) scheme(plottig) ///
		yline(0, lpattern(dash))  text(0.55 0.25 "Z=2.45; Wald: p = 0.05", size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6) 
		
		
		graph save "Abortion2000C", replace
			
*Guns
eststo: logit vote c.abortion2000prox01 c.guns2000prox01##c.guns2000imp_corr01 c.regulation2000prox01 pid01 i.ideol econ01 ///
	i.gender i.race age01 educ01 income01  [pweight = V000002a]
	
	*Wald Test
	testparm c.guns2000imp_corr01 c.guns2000prox01#c.guns2000imp_corr01
	
	*Margins
		margins, dydx(guns2000prox01) at(guns2000imp_corr01=(0(0.25)1)) saving(2000_guns, replace)
		
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Guns:2000, size(medsmall)) scheme(plottig) ///
		yline(0, lpattern(dash)) text(0.55 0.25 "Z=-0.20; Wald: p = 0.64", size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6)
		
		graph save "Guns2000C", replace
	


*Regulation
eststo: logit vote c.abortion2000prox01 c.guns2000prox01 c.regulation2000prox01##c.regulation2000imp_corr01 pid01 i.ideol econ01 ///
	i.gender i.race  age01 educ01 income01  [pweight = V000002a]
	
	*Wald Test
	testparm c.regulation2000imp_corr01 c.regulation2000prox01#c.regulation2000imp_corr01
	
	*Margins
		margins, dydx(regulation2000prox01) at(regulation2000imp_corr01=(0(0.25)1)) saving(2000_regulation, replace)
		
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Env.Regulation:2000, size(medsmall)) scheme(plottig) ///
		yline(0, lpattern(dash)) text(0.55 0.25 "Z=-0.91; Wald: p = 0.32", size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6)
		
		graph save "Env.Regulation2000C", replace
		


*Table
esttab using 2000_Interactions.rtf, replace se pr2 aic bic onecell ///
		star(+ 0.10 * 0.05 ** 0.01) label nobaselevels addnote(Results are weighted:V000002a) ///
		title({\b Table XX} - Subjective Importance and Proximity Voting - 2000TS) ///
		mtitle("Abortion" "Guns" "Env. Regulation")
		
eststo clear
					
/*Figure*/
graph combine "Abortion2000C" "Guns2000C" "Env.Regulation2000C", scheme(plottig) title("2000 ANES", size(medsmall))

graph save "2000 ANES (Corrected)", replace
graph export "2000 ANES (Corrected).png", replace
		
	
						***********************************
						***********************************
						***********************************
						***********2004 ANES TS************
						***********************************
						***********************************
						***********************************

clear
do "Data Cleaning - 2004 ANES TS.do"
set more off

	
/*Correcting Importance*/
egen imp_mean = rowmean(defense2004imp spend2004imp jobs2004imp blackaid2004imp envirojobs2004imp guns2004imp womenrole2004imp)

foreach var in defense2004imp spend2004imp jobs2004imp blackaid2004imp envirojobs2004imp guns2004imp womenrole2004imp {
	gen `var'_corr = `var' - imp_mean
	summ `var'_corr 
	gen `var'_corr01 = (`var'_corr - r(min))/(r(max)-r(min))
	}


*Interaction Models
*Defense
eststo clear
eststo: logit vote c.defense2004prox01##c.defense2004imp_corr01 c.spend2004prox01 c.jobs2004prox01 c.blackaid2004prox01 c.envirojobs2004prox01 ///
	c.guns2004prox101 c.womenrole2004prox01 ///
	pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 [pweight = V040102	]

		*Wald test
			testparm c.defense2004imp_corr01 c.defense2004prox01#c.defense2004imp_corr01
			
		*margins
			margins, dydx(defense2004prox01) at(defense2004imp_corr01=(0(0.25)1)) saving(2004_defense, replace)
			
			marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Defense:2004, size(medsmall)) scheme(plottig) ///
			yline(0, lpattern(dash)) text(0.55 0.35 "Z=0.88; Wald: p = 0.47", size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6)
			
			graph save "Defense2004C", replace
		


*Spend
eststo: logit vote c.defense2004prox01 c.spend2004prox01##c.spend2004imp_corr01 c.jobs2004prox01 c.blackaid2004prox01 c.envirojobs2004prox01 ///
	c.guns2004prox101 c.womenrole2004prox01 ///
	pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 [pweight = V040102	]

		*Wald test
			testparm c.spend2004imp_corr01 c.spend2004prox01#c.spend2004imp_corr01
			
		*margins
			margins, dydx(spend2004prox01) at(spend2004imp_corr01=(0(0.25)1)) saving(2004_spend, replace)
			
			marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Spend:2004, size(medsmall)) scheme(plottig) ///
			yline(0, lpattern(dash)) text(0.55 0.35 "Z=0.60; Wald: p = 0.70", size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6)
			
			graph save "Spend2004C", replace
		
	

*jobs
eststo: logit vote c.defense2004prox01 c.spend2004prox01 c.jobs2004prox01##c.jobs2004imp_corr01 c.blackaid2004prox01 c.envirojobs2004prox01 ///
	c.guns2004prox101 c.womenrole2004prox01 ///
	pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 [pweight = V040102	]

		*Wald test
			testparm c.jobs2004imp_corr01 c.jobs2004prox01#c.jobs2004imp_corr01
			
		*margins
			margins, dydx(jobs2004prox01) at(jobs2004imp_corr01=(0(0.25)1)) saving(2004_jobs, replace)
			
			marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Jobs:2004, size(medsmall)) scheme(plottig) ///
			yline(0, lpattern(dash)) text(0.55 0.35 "Z=0.10; Wald: p = 0.99", size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6)
			
			graph save "Jobs2004C", replace
			

*Blackaid
eststo: logit vote c.defense2004prox01 c.spend2004prox01 c.jobs2004prox01 c.blackaid2004prox01##c.blackaid2004imp_corr01 c.envirojobs2004prox01 ///
	c.guns2004prox101 c.womenrole2004prox01 ///
	pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 [pweight = V040102	]

		*Wald test
			testparm c.blackaid2004imp_corr01 c.blackaid2004prox01#c.blackaid2004imp_corr01
			
		*margins

			margins, dydx(blackaid2004prox01) at(blackaid2004imp_corr01=(0(0.25)1)) saving(2004_blackaid, replace)
			
			marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Aid to Blacks:2004, size(medsmall)) scheme(plottig) ///
			yline(0, lpattern(dash)) text(0.55 0.35 "Z=1.17; Wald: p = 0.33", size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6)
			
			graph save "AidBlacks2004C", replace
		


*Envirojobs
eststo: logit vote c.defense2004prox01 c.spend2004prox01 c.jobs2004prox01 c.blackaid2004prox01 c.envirojobs2004prox01##c.envirojobs2004imp_corr01 ///
	c.guns2004prox101 c.womenrole2004prox01 ///
	pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 [pweight = V040102	]

		*Wald test
			testparm c.envirojobs2004imp_corr01 c.envirojobs2004prox01#c.envirojobs2004imp_corr01
			
		*margins
			margins, dydx(envirojobs2004prox01) at(envirojobs2004imp_corr01=(0(0.25)1)) saving(2004_envirojobs, replace)
			
			marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Enviro vs Jobs:2004, size(medsmall)) scheme(plottig) ///
			yline(0, lpattern(dash)) text(0.55 0.35 "Z=-0.45; Wald: p = 0.85", size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6)
			
			graph save "EnviroJobs2004C", replace
			
		

*Guns
eststo: logit vote c.defense2004prox01 c.spend2004prox01 c.jobs2004prox01 c.blackaid2004prox01 c.envirojobs2004prox01 ///
	c.guns2004prox101##c.guns2004imp_corr01 c.womenrole2004prox01 ///
	pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 [pweight = V040102	]

		*Wald test
			testparm c.guns2004imp_corr01 c.guns2004prox101#c.guns2004imp_corr01
			
		*margins
			margins, dydx(guns2004prox101) at(guns2004imp_corr01=(0(0.25)1)) saving(2004_guns, replace)
			
			marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Guns:2004, size(medsmall)) scheme(plottig) ///
			yline(0, lpattern(dash))  text(0.55 0.35 "Z=0.60; Wald: p = 0.51", size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6)
			
			graph save "Guns2004C", replace
			


*Womenrole
eststo: logit vote c.defense2004prox01 c.spend2004prox01 c.jobs2004prox01 c.blackaid2004prox01 c.envirojobs2004prox01 ///
	c.guns2004prox101 c.womenrole2004prox01##c.womenrole2004imp_corr01 ///
	pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 [pweight = V040102	]

		*Wald test
			testparm c.womenrole2004imp_corr01 c.womenrole2004prox01#c.womenrole2004imp_corr01
			
		*margins
			margins, dydx(womenrole2004prox01) at(womenrole2004imp_corr01=(0(0.25)1)) saving(2004_womenrole, replace)
			
			marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Role of  Women:2004, size(medsmall)) scheme(plottig) ///
			yline(0, lpattern(dash)) text(0.55 0.35 "Z=0.14; Wald: p = 0.44", size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6)
			
			
			graph save "Women2004C", replace
			
					

*Table
esttab using 2004_Interactions.rtf, replace se pr2 aic bic onecell ///
	star(+ 0.10 * 0.05 ** 0.01) label nobaselevels addnote(Results are weighted:V040102) ///
	title({\b Table XX.} Subjective Importance and Proximity Voting - 2004 TS)
eststo clear
				
/*Figure*/
graph combine "Defense2004C"  "Spend2004C" "Jobs2004C" "AidBlacks2004C" "EnviroJobs2004C" "Guns2004C" "Women2004C" ///
	, title("2004 ANES", size(medsmall)) scheme(plottig) 
	
graph save "2004 ANES (Corrected)", replace
graph export "2004 ANES (Corrected).png", replace

		
		
						***********************************
						***********************************
						***********************************
						***********2008 ANES TS (F1)*******
						***********************************
						***********************************
						***********************************

clear
set more off
do "Data Cleaning - 2008 ANES TS.do"
set more off

	
/*Correcting Importance*/
egen imp_mean = rowmean(spend2008impold spend2008impnew defense2008impold defense2008impnew health2008imp universal2008imp jobs2008imp citizenship2008imp blackaid2008impold blackaid2008impnew envirojobs2008imp emission2008imp women2008imp)

foreach var in spend2008impold spend2008impnew defense2008impold defense2008impnew health2008imp universal2008imp jobs2008imp citizenship2008imp blackaid2008impold blackaid2008impnew envirojobs2008imp emission2008imp women2008imp {
	gen `var'_corr = `var' - imp_mean
	summ `var'_corr 
	gen `var'_corr01 = (`var'_corr - r(min))/(r(max)-r(min))
	}


*Interaction Models
*Defense
eststo clear
eststo: logit vote c.defense2008proxold01##c.defense2008impold_corr01 c.spend2008proxold01 c.jobs2008prox01 c.blackaid2008prox01 c.envirojobs2008prox01 ///
c.health2008prox01 c.women2008prox01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01    [pweight=V080102]

*Wald Test
	testparm c.defense2008impold_corr01 c.defense2008proxold01#c.defense2008impold_corr01

*Margins
	margins, dydx(defense2008proxold01) at(defense2008impold_corr01=(0(0.25)1)) saving(2008f1_defense, replace)
	
	marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Defense:2008 (Form 1), size(medsmall)) scheme(plottig) ///
		yline(0, lpattern(dash)) text(0.65 0.35 "Z=0.47; Wald: p = 0.43", size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6)
		
		graph save "Defense2008F1C", replace


*Spend
eststo: logit vote c.defense2008proxold01 c.spend2008proxold01##c.spend2008impold_corr01 c.jobs2008prox01 c.blackaid2008prox01 c.envirojobs2008prox01 ///
c.health2008prox01 c.women2008prox01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01    [pweight=V080102]

*Wald Test
	testparm c.spend2008impold_corr01 c.spend2008proxold01#c.spend2008impold_corr01

*Margins
	margins, dydx(spend2008proxold01) at(spend2008impold_corr01=(0(0.25)1)) saving(2008f1_spend, replace)
	
	marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Spend:2008 (Form 1), size(medsmall)) scheme(plottig) ///
		yline(0, lpattern(dash)) text(0.55 0.35 "Z=2.92; Wald: p = 0.01", size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6)
		
		graph save "Spend2008F1C", replace	
		
*Jobs
eststo: logit vote c.defense2008proxold01 c.spend2008proxold01 c.jobs2008prox01##c.jobs2008imp_corr01 c.blackaid2008prox01 c.envirojobs2008prox01 ///
c.health2008prox01 c.women2008prox01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01    [pweight=V080102]

*Wald Test
	testparm c.jobs2008imp_corr01 c.jobs2008prox01#c.jobs2008imp_corr01

*Margins
	margins, dydx(jobs2008prox01) at(jobs2008imp_corr01=(0(0.25)1)) saving(2008f1_jobs, replace)
	
	marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Jobs & SOL:2008 (Form 1), size(medsmall)) scheme(plottig) ///
		yline(0, lpattern(dash)) text(0.55 0.35 "Z=0.70; Wald: p = 0.67", size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6)
		
		
		graph save "Jobs2008F1C", replace

				
*BlackAid
eststo: logit vote c.defense2008proxold01 c.spend2008proxold01 c.jobs2008prox01 c.blackaid2008prox01##c.blackaid2008impold_corr01 c.envirojobs2008prox01 ///
c.health2008prox01 c.women2008prox01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01    [pweight=V080102]

*Wald Test
	testparm c.blackaid2008impold_corr01 c.blackaid2008prox01#c.blackaid2008impold_corr01

*Margins
	margins, dydx(blackaid2008prox01) at(blackaid2008impold_corr01=(0(0.25)1)) saving(2008f1_blackaid, replace)
	
	marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Aid to Blacks:2008 (Form 1), size(medsmall)) scheme(plottig) ///
		yline(0, lpattern(dash)) text(0.55 0.35 "Z=2.24; Wald: p = 0.03", size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6)
		
		graph save "AidBlacks2008F1C", replace


*EnviroJobs
eststo: logit vote c.defense2008proxold01 c.spend2008proxold01 c.jobs2008prox01 c.blackaid2008prox01 c.envirojobs2008prox01##c.envirojobs2008imp_corr01 ///
c.health2008prox01 c.women2008prox01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01    [pweight=V080102]

*Wald Test
	testparm c.envirojobs2008imp_corr01 c.envirojobs2008prox01#c.envirojobs2008imp_corr01

*Margins
	margins, dydx(envirojobs2008prox01) at(envirojobs2008imp_corr01=(0(0.25)1)) saving(2008f1_envirojobs, replace)
	
	marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Env. vs. Jobs:2008 (Form 1), size(medsmall)) scheme(plottig) ///
		yline(0, lpattern(dash))  text(0.55 0.35 "Z=0.97; Wald: p = 0.04", size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6)
		
		graph save "EnviroJobs2008F1C", replace


*Health 
eststo: logit vote c.defense2008proxold01 c.spend2008proxold01 c.jobs2008prox01 c.blackaid2008prox01 c.envirojobs2008prox01 ///
c.health2008prox01##c.health2008imp_corr01 c.women2008prox01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01    [pweight=V080102]

*Wald Test
	testparm c.health2008imp_corr01 c.health2008prox01#c.health2008imp_corr01

*Margins
	margins, dydx(health2008prox01) at(health2008imp_corr01=(0(0.25)1)) saving(2008f1_health, replace)
	
	marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Gov. Health Ins.:2008 (Form 1), size(medsmall)) scheme(plottig) ///
		yline(0, lpattern(dash))  text(0.55 0.35 "Z=0.51; Wald: p = 0.87", size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6)
		
		graph save "Health2008F1C", replace



*Women
eststo: logit vote c.defense2008proxold01 c.spend2008proxold01 c.jobs2008prox01 c.blackaid2008prox01 c.envirojobs2008prox01 ///
c.health2008prox01 c.women2008prox01##c.women2008imp_corr01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01    [pweight=V080102]

*Wald Test
	testparm c.women2008imp_corr01 c.women2008prox01#c.women2008imp_corr01

*Margins
	margins, dydx(women2008prox01) at(women2008imp_corr01=(0(0.25)1)) saving(2008f1_women, replace)
	
	marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Role of Women:2008 (Form 1), size(medsmall)) scheme(plottig) ///
		yline(0, lpattern(dash)) text(0.55 0.35 "Z=3.72; Wald: p = 0.001", size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6)
		graph save "Women2008F1C", replace



*Table
esttab using 2008_F1_Interactions.rtf, replace se pr2 aic bic onecell ///
	star(+ 0.10 * 0.05 ** 0.01) label nobaselevels addnote(Results are weighted:V080102) ///
	title({\b Table XX.} "Subjective Importance and Proximity Voting - 2008TS (Form 1)") ///
	mtitle("Defense" "Spending" "Jobs" "AidBlacks" "Envion." "Health" "Women")
eststo clear

/*Figure*/
graph combine "Defense2008F1C" "Spend2008F1C" "Jobs2008F1C" "AidBlacks2008F1C" "EnviroJobs2008F1C" "Health2008F1C" "Women2008F1C" 			///
	, title("2008 ANES (Form 1)", size(medsmall)) scheme(plottig)

graph save "2008 F1", replace
graph export "2008 F1.png", replace


			
					***********************************
					***********************************
					***********************************
					***********2008 ANES TS (F2)*******
					***********************************
					***********************************
					***********************************

*Data cleaning
clear
do "Data Cleaning - 2008 ANES TS.do"
set more off

	
/*Correcting Importance*/
egen imp_mean = rowmean(spend2008impold spend2008impnew defense2008impold defense2008impnew health2008imp universal2008imp jobs2008imp citizenship2008imp blackaid2008impold blackaid2008impnew envirojobs2008imp emission2008imp women2008imp)

foreach var in spend2008impold spend2008impnew defense2008impold defense2008impnew health2008imp universal2008imp jobs2008imp citizenship2008imp blackaid2008impold blackaid2008impnew envirojobs2008imp emission2008imp women2008imp {
	gen `var'_corr = `var' - imp_mean
	summ `var'_corr 
	gen `var'_corr01 = (`var'_corr - r(min))/(r(max)-r(min))
	}

*Interaction Models
*Defense
eststo clear
eststo: logit vote c.defense2008proxnew01##c.defense2008impnew_corr01 c.spend2008proxnew01 ///
			blackaid2008prox01 emission2008prox01 universal2008prox01 citizenship2008prox01 ///			
			pid01 i.ideol econ01  i.gender i.race age01 educ01 income01    [pweight=V080102]

*Wald Test
	testparm c.defense2008impnew_corr01 c.defense2008proxnew01#c.defense2008impnew_corr01

*Margins
	margins, dydx(defense2008proxnew01) at(defense2008impnew_corr01=(0(0.25)1)) saving(2008f2_defense, replace)
	
	marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Defense:2008 (Form 2), size(medsmall)) scheme(plottig) ///
		yline(0, lpattern(dash)) text(0.55 0.25 "Z=1.47; Wald: p = 0.28", size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6)
		
		graph save "Defense2008F2C", replace



*Spend
eststo: logit vote c.defense2008proxnew01 c.spend2008proxnew01##c.spend2008impnew_corr01 ///
			c.blackaid2008prox01 c.emission2008prox01 c.universal2008prox01 c.citizenship2008prox01 ///			
			pid01 i.ideol econ01  i.gender i.race age01 educ01 income01    [pweight=V080102]

*Wald Test
	testparm c.spend2008impnew_corr01 c.spend2008proxnew01#c.spend2008impnew_corr01

*Margins
	margins, dydx(spend2008proxnew01) at(spend2008impnew_corr01=(0(0.25)1)) saving(2008f2_spend, replace)
	
	marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Spend:2008 (Form 2), size(medsmall)) scheme(plottig) ///
		yline(0, lpattern(dash)) text(0.55 0.35 "Z=0.28; Wald: p = 0.90", size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6)
		
		graph save "Spend2008F2C", replace


*Black Aid
eststo: logit vote c.defense2008proxnew01 c.spend2008proxnew01 ///
			c.blackaid2008prox01##c.blackaid2008impnew_corr01 c.emission2008prox01 c.universal2008prox01 c.citizenship2008prox01 ///			
			pid01 i.ideol econ01  i.gender i.race age01 educ01 income01    [pweight=V080102]

*Wald Test
	testparm c.blackaid2008impnew_corr01 c.blackaid2008prox01#c.blackaid2008impnew_corr01

*Margins
	margins, dydx(blackaid2008prox01) at(blackaid2008impnew_corr01=(0(0.25)1)) saving(2008f2_blackaid, replace)
	
	marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Aid to Blacks:2008 (Form 2), size(medsmall)) scheme(plottig) ///
		yline(0, lpattern(dash)) text(0.55 0.35 "Z=1.09; Wald: p = 0.05", size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6)
		
		
		graph save "BlackAid2008F2C", replace


*Emissions
eststo: logit vote c.defense2008proxnew01 c.spend2008proxnew01 ///
			c.blackaid2008prox01 c.emission2008prox01##c.emission2008imp_corr01 c.universal2008prox01 c.citizenship2008prox01 ///			
			pid01 i.ideol econ01  i.gender i.race age01 educ01 income01    [pweight=V080102]

*Wald Test
	testparm c.emission2008imp_corr01 c.emission2008prox01#c.emission2008imp_corr01

*Margins
	margins, dydx(emission2008prox01) at(emission2008imp_corr01=(0(0.25)1)) saving(2008f2_emission, replace)
	
	marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Plant Emissions:2008 (Form 2), size(medsmall)) scheme(plottig) ///
		yline(0, lpattern(dash)) text(0.55 0.35 "Z=0.69; Wald: p = 0.03", size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6)
		
		graph save "Emission2008F2C", replace


*Universal Health
eststo: logit vote c.defense2008proxnew01 c.spend2008proxnew01 ///
		c.blackaid2008prox01 c.emission2008prox01 c.universal2008prox01##c.universal2008imp_corr01 c.citizenship2008prox01 ///			
		pid01 i.ideol econ01  i.gender i.race age01 educ01 income01    [pweight=V080102]

*Wald Test
	testparm c.universal2008imp_corr01 c.universal2008prox01#c.universal2008imp_corr01

*Margins
	margins, dydx(universal2008prox01) at(universal2008imp_corr01=(0(0.25)1)) saving(2008f2_universal, replace)
	
	marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Univ. Health Care:2008 (Form 2), size(medsmall)) scheme(plottig) ///
		yline(0, lpattern(dash)) text(0.55 0.35 "Z=0.42; Wald: p = 0.64", size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6)
		
		graph save "Universal2008F2C", replace

*Citizenship
eststo: logit vote c.defense2008proxnew01 c.spend2008proxnew01 ///
		c.blackaid2008prox01 c.emission2008prox01 c.universal2008prox01 c.citizenship2008prox01##c.citizenship2008imp_corr01 ///			
		pid01 i.ideol econ01  i.gender i.race age01 educ01 income01    [pweight=V080102]

*Wald Test
	testparm c.citizenship2008imp_corr01 c.citizenship2008prox01#c.citizenship2008imp_corr01

*Margins
	margins, dydx(citizenship2008prox01) at(citizenship2008imp_corr01=(0(0.25)1)) saving(2008f2_citizenship, replace)
	
	marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Path Citizenship:2008 (Form 2), size(medsmall)) scheme(plottig) ///
		yline(0, lpattern(dash)) text(0.55 0.35 "Z=0.68; Wald: p = 0.20", size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6)
		
		graph save "Path2008F2C", replace

	

*Table
esttab using 2008_F2_Interactions.rtf, replace se pr2 aic bic onecell ///
	star(+ 0.10 * 0.05 ** 0.01) label nobaselevels addnote(Results are weighted:V080102) ///
	title({\b Table XX.} "Subjective Importance and Proximity Voting - 2008TS)") ///
	mtitle("Defense" "Spending" "AidBlacks" "Emissions" "Universal" "Path")
	
eststo clear
	
	
/*Figure*/
graph combine "Defense2008F2C" "Spend2008F2C" "BlackAid2008F2C" "Emission2008F2C" "Universal2008F2C" "Path2008F2C" ///
	, scheme(plottig) title("2008 ANES (Form 2)", size(medsmall))

graph save "2008 F2C", replace
graph export "2008 F2C.png", replace

	
			
					***********************************
					***********************************
					***********************************
					***********2008 ANES Panel*********
					***********************************
					***********************************
					***********************************

clear
do "Data Cleaning - 2008 ANES Panel.do"
set more off


	
/*Correcting Importance*/
egen imp_mean = rowmean(samesex10imp richtaxes10imp drugs10imp medic10imp habeas10imp phone10imp illeg10imp path10imp withdraw10imp) 

foreach var in samesex10imp richtaxes10imp drugs10imp medic10imp habeas10imp phone10imp illeg10imp path10imp withdraw10imp {
	gen `var'_corr = `var' - imp_mean
	summ `var'_corr 
	gen `var'_corr01 = (`var'_corr - r(min))/(r(max)-r(min))
	}
	

*Interaction Models
*Same Sex Marriage
eststo clear
eststo: logit vote c.samesex10prox01##c.samesex10imp_corr01 c.richtaxes10prox01 c.drugs10prox01 c.medic10prox01 ///
					c. habeas10prox01 c.phone10prox01 c.illeg10prox01 c.path10prox01 c.withdraw10prox01 ///
				pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight = WGTL11]
				
		*Wald Test
			testparm c.samesex10imp_corr01 c.samesex10prox01#c.samesex10imp_corr01
		
		*Margins
			
		margins, dydx(samesex10prox01) at(samesex10imp_corr01=(0(0.25)1)) saving(2008pa_samesex, replace)
		
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title("Same Sex Marriage:2008 Panel", size(medsmall)) scheme(plottig) ///
			yline(0, lpattern(dash))  text(0.55 0.25 "Z=0.92; Wald: p = 0.45", size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6) 

			graph save "SameSex2008PAC", replace
	
	
*Taxing the Rich
eststo: logit vote c.samesex10prox01 c.richtaxes10prox01##c.richtaxes10imp_corr01 c.drugs10prox01 c.medic10prox01 ///
				c. habeas10prox01 c.phone10prox01 c.illeg10prox01 c.path10prox01 c.withdraw10prox01 ///
				pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight = WGTL11]
				
		*Wald Test
			testparm c.richtaxes10imp_corr01 c.richtaxes10prox01#c.richtaxes10imp_corr01
		
		*Margins
			
		margins, dydx(richtaxes10prox01) at(richtaxes10imp_corr01=(0(0.25)1)) saving(2008pa_richtaxes, replace)
		
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Taxes the Rich:2008 Panel, size(medsmall)) scheme(plottig) ///
			yline(0, lpattern(dash)) text(0.55 0.25 "Z=1.13; Wald: p = 0.22", size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6) 

			graph save "RichTaxes2008PAC", replace
	
	

*Drugs
eststo: logit vote c.samesex10prox01 c.richtaxes10prox01 c.drugs10prox01##c.drugs10imp_corr01 c.medic10prox01 ///
				c. habeas10prox01 c.phone10prox01 c.illeg10prox01 c.path10prox01 c.withdraw10prox01 ///
				pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight = WGTL11]
				
		*Wald Test
			testparm c.drugs10imp_corr01 c.drugs10prox01#c.drugs10imp_corr01
		
		*Margins
			
		margins, dydx(drugs10prox01) at(drugs10imp_corr01=(0(0.25)1)) saving(2008pa_drugs, replace)
		
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Senior Drug Payment:2008 Panel, size(medsmall)) scheme(plottig) ///
			yline(0, lpattern(dash)) text(0.55 0.25 "Z=-0.52; Wald: p = 0.31", size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6) 

			graph save "Drugs2008PAC", replace


*Medic
eststo: logit vote c.samesex10prox01 c.richtaxes10prox01 c.drugs10prox01 c.medic10prox01##c.medic10imp_corr01 ///
				c. habeas10prox01 c.phone10prox01 c.illeg10prox01 c.path10prox01 c.withdraw10prox01 ///
				pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight = WGTL11]
				
		*Wald Test
			testparm c.medic10imp_corr01 c.medic10prox01#c.medic10imp_corr01
		
		*Margins
			
		margins, dydx(medic10prox01) at(medic10imp_corr01=(0(0.25)1)) saving(2008pa_medic, replace)
		
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title("Universal Health Care:2008 Panel", size(medsmall)) scheme(plottig) ///
			yline(0, lpattern(dash)) text(0.55 0.25 "Z=-1.30; Wald: p = 0.0.43", size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6) 

			graph save "Medic2008PAC", replace

		

*Habeas
	eststo: logit vote c.samesex10prox01 c.richtaxes10prox01 c.drugs10prox01 c.medic10prox01 ///
				c.habeas10prox01##c.habeas10imp_corr01 c.phone10prox01 c.illeg10prox01 c.path10prox01 c.withdraw10prox01 ///
				pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight = WGTL11]
				
		*Wald Test
			testparm c.habeas10imp_corr01 c.habeas10prox01#c.habeas10imp_corr01
		
		*Margins
			
		margins, dydx(habeas10prox01) at(habeas10imp_corr01=(0(0.25)1)) saving(2008pa_habeas, replace)
		
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Habeas Rights:2008 Panel, size(medsmall)) scheme(plottig) ///
			yline(0, lpattern(dash)) text(0.55 0.25 "Z=0.51; Wald: p = 0.84", size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6) 

			graph save "Habeas2008PAC", replace
	
		
*Phone
	eststo: logit vote c.samesex10prox01 c.richtaxes10prox01 c.drugs10prox01 c.medic10prox01 ///
				c.habeas10prox01 c.phone10prox01##c.phone10imp_corr01 c.illeg10prox01 c.path10prox01 c.withdraw10prox01 ///
				pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight = WGTL11]
				
		*Wald Test
			testparm c.phone10imp_corr01 c.phone10prox01#c.phone10imp_corr01
		*Margins
			
		margins, dydx(phone10prox01) at(phone10imp_corr01=(0(0.25)1)) saving(2008pa_phone, replace)
		
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title("Wiretaps:2008 Panel", size(medsmall)) scheme(plottig) ///
			yline(0, lpattern(dash)) text(0.55 0.25 "Z=0.66; Wald: p = 0.19", size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6) 

			graph save "Phone2008PAC", replace
	

*Illeg
eststo: logit vote c.samesex10prox01 c.richtaxes10prox01 c.drugs10prox01 c.medic10prox01 ///
				c.habeas10prox01 c.phone10prox01 c.illeg10prox01##c.illeg10imp_corr01 c.path10prox01 c.withdraw10prox01 ///
				pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight = WGTL11]
				
		*Wald Test
			testparm c.illeg10imp_corr01 c.illeg10prox01#c.illeg10imp_corr01
		
		*Margins
			
		margins, dydx(illeg10prox01) at(illeg10imp_corr01=(0(0.25)1)) saving(2008pa_illeg, replace)
		
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title("Work Stay:2008 Panel", size(medsmall)) scheme(plottig) ///
			yline(0, lpattern(dash)) text(0.55 0.25 "Z=-0.65; Wald: p = 0.02", size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6) 

			graph save "Illeg2008PAC", replace
	
		
*Path
eststo: logit vote c.samesex10prox01 c.richtaxes10prox01 c.drugs10prox01 c.medic10prox01 ///
				c.habeas10prox01 c.phone10prox01 c.illeg10prox01 c.path10prox01##c.path10imp_corr01 c.withdraw10prox01 ///
				pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight = WGTL11]
				
		*Wald Test
			testparm c.path10imp_corr01 c.path10prox01#c.path10imp_corr01
		
		*Margins
			
		margins, dydx(path10prox01) at(path10imp_corr01=(0(0.25)1)) saving(2008pa_path, replace)
		
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title("Path to Citizenship:2008 Panel", size(medsmall)) scheme(plottig) ///
			yline(0, lpattern(dash)) text(0.55 0.25 "Z=0.73; Wald: p = 0.03", size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6) 

			graph save "Path2008PAC", replace

		
*Withdraw
	eststo: logit vote c.samesex10prox01 c.richtaxes10prox01 c.drugs10prox01 c.medic10prox01 ///
				c.habeas10prox01 c.phone10prox01 c.illeg10prox01 c.path10prox01 c.withdraw10prox01##c.withdraw10imp_corr01 ///
				pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight = WGTL11]
				
		*Wald Test
			testparm c.withdraw10imp_corr01 c.withdraw10prox01#c.withdraw10imp_corr01
		
		*Margins
			
		margins, dydx(withdraw10prox01) at(withdraw10imp_corr01=(0(0.25)1)) saving(2008pa_withdraw, replace)
		
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title("Iraq Withdrawl:2008 Panel", size(medsmall)) scheme(plottig) ///
			yline(0, lpattern(dash)) text(0.55 0.25 "Z=0.44; Wald: p = 0.07", size(vsmall) justification(right) ) ylabel(-0.6(0.2)0.6) 

			graph save "Withdraw2008PAC", replace

		
*Table
	esttab using 2008_PA_Interactions_CORR.rtf, replace se pr2 aic bic onecell ///
		star(+ 0.10 * 0.05 ** 0.01) label nobaselevels addnote(Results are weighted:WGTL11) ///
		title({\b Table XX.} "Subjective Importance and Proximity - 2008-2009 (Panel)") ///
		mtitles("SS Marriage" "Tax Rich" "Drugs" "Medical" "Habeas" "Wiretap" "Work" "Citizenship" "Iraq")
						
	eststo clear
		
/*Figure*/
graph combine	"SameSex2008PAC" "RichTaxes2008PAC" "Drugs2008PAC" "Medic2008PAC" "Habeas2008PAC" "Phone2008PAC" "Illeg2008PAC" ///
	"Path2008PAC" "Withdraw2008PAC", scheme(plottig) title("2008 ANES Panel", size(medsmall))

graph save "2008 Panel Corr", replace
graph export "2008 Panel Corr.png", replace

		
		
				
		
			
	
