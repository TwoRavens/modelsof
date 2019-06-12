/******************************************************************************
*******************************************************************************
	In this .do file, we replicate our in-text anlayses using 
	the interflex command written by Xu, Hainmueller, Mummulo, and 
	Liu. In particular, we replicate our interaction models 
	via their binned interaction estimator to compare the effects
	of proximity at High, Medium, and Low Importance. In so doing, 
	we test the linearity assumption via Wald Tests. 
	
	In text we focus on models that include all interactions at once. 
	The interflex command won't enable that type of model, so instead
	we will estimate each interaction one at a time. 
	
	If you do not have the interflex module, then run the following code: 
	
	ssc install interflex, replace
	ssc install addplot
	ssc install blindschemes
	ssc install estout

*******************************************************************************
******************************************************************************/


clear 
set more off 
cd "C:\Users\Joshua\Dropbox\Work\Isssue Importance and Voting Paper\Dataverse"

			***********************************
			***********************************
			***********************************
			***********1980 ANES TS************
			***********************************
			***********************************
			***********************************

clear
*Data Cleaning
do "Data Cleaning - 1980 ANES TS.do"
set more off


/****tabulation of ideology for control variable****/
tabulate ideol, gen(ideol_)
	
	/*
	interflex doesn't enable the use of Stata prefixes, e.g. i.var or 
	c.var - hence ideology must be split into separate dummies
	*/
	
	/****Models*****/

/*Defense Spending*/

eststo clear

interflex vote defense80prox01 defense80imp_cat01   ///
			spend80prox01 spend80imp_cat01 ///
			abortion80prox01 abortion80imp_cat01 ///
			blackaid80prox01 blackaid80imp_cat01 ///
			unemploy80prox01 unemploy80imp_cat01 ///
			jobs80prox01 jobs80imp_cat01 ///
			russia80prox01 russia80imp_cat01 ///
			pid01 ideol_2 ideol_3 ideol_4 econ01  gender race age01 educ01 income01  ///
					, title(Defense Spending) ///
					xlabel(Importance) dlabel(Proximity) ylabel(Vote)  
		
	est store def
	estadd scalar wald = r(pwald)	
	
	addplot: , ytitle("")
	graph save "def1980_inter", replace
	
/*spending*/


interflex vote 	spend80prox01 spend80imp_cat01   ///
			defense80prox01 defense80imp_cat01  ///
			abortion80prox01 abortion80imp_cat01 ///
			blackaid80prox01 blackaid80imp_cat01 ///
			unemploy80prox01 unemploy80imp_cat01 ///
			jobs80prox01 jobs80imp_cat01 ///
			russia80prox01 russia80imp_cat01 ///
			pid01 ideol_2 ideol_3 ideol_4 econ01  gender race age01 educ01 income01  ///
					,  title(Spending & Services) ///
					xlabel(Importance) dlabel(Proximity) ylabel(Vote) 
	
	est store spend	
	estadd scalar wald = r(pwald)
	addplot: , ytitle("")
	
	graph save "spend1980_inter", replace
		
/*Abortion*/

interflex vote	abortion80prox01 abortion80imp_cat01 ///
		defense80prox01 defense80imp_cat01 ///
			spend80prox01 spend80imp_cat01 ///
			blackaid80prox01 blackaid80imp_cat01 ///
			unemploy80prox01 unemploy80imp_cat01 ///
			jobs80prox01 jobs80imp_cat01 ///
			russia80prox01 russia80imp_cat01 ///
			pid01 ideol_2 ideol_3 ideol_4 econ01  gender race age01 educ01 income01  ///
					,  title(Abortion) ///
					xlabel(Importance) dlabel(Proximity) ylabel(Vote) 
		
		estimates store abor
		estadd scalar wald = r(pwald)
		addplot: , ytitle("")
		graph save "abor1980_inter", replace

/*Aid to Blacks*/

interflex vote 	blackaid80prox01 blackaid80imp_cat01  ///
		defense80prox01 defense80imp_cat01 ///
			spend80prox01 spend80imp_cat01 ///
			abortion80prox01 abortion80imp_cat01 ///
			unemploy80prox01 unemploy80imp_cat01 ///
			jobs80prox01 jobs80imp_cat01 ///
			russia80prox01 russia80imp_cat01 ///
			pid01 ideol_2 ideol_3 ideol_4 econ01  gender race age01 educ01 income01  ///
					,  title(Aid to Blacks) ///
					xlabel(Importance) dlabel(Proximity) ylabel(Vote) 
					
		estimates store blacks
		estadd scalar wald = r(pwald)
		addplot: , ytitle("")
	graph save "blacks1980_inter", replace
	
/*Unemployment*/
	
	interflex vote 	unemploy80prox01 unemploy80imp_cat01  ///
			defense80prox01 defense80imp_cat01  ///
			spend80prox01 spend80imp_cat01 ///
			abortion80prox01 abortion80imp_cat01 ///
			blackaid80prox01 blackaid80imp_cat01 ///
			jobs80prox01 jobs80imp_cat01 ///
			russia80prox01 russia80imp_cat01 ///
			pid01 ideol_2 ideol_3 ideol_4 econ01  gender race age01 educ01 income01  ///
					,  title(Unemployment) ///
					xlabel(Importance) dlabel(Proximity) ylabel(Vote) 
					
				estimates store unemp
		estadd scalar wald = r(pwald)
		addplot: , ytitle("")
		graph save "unemp1980_inter", replace
		
/*Jobs*/
interflex vote 	jobs80prox01 jobs80imp_cat01  ///
			defense80prox01 defense80imp_cat01  ///
			spend80prox01 spend80imp_cat01 ///
			abortion80prox01 abortion80imp_cat01 ///
			blackaid80prox01 blackaid80imp_cat01 ///
			unemploy80prox01 unemploy80imp_cat01 ///
			russia80prox01 russia80imp_cat01 ///
			pid01 ideol_2 ideol_3 ideol_4 econ01  gender race age01 educ01 income01  ///
					,  title(Jobs & SOL) ///
					xlabel(Importance) dlabel(Proximity) ylabel(Vote) 
			
			estimates store jobs
		estadd scalar wald = r(pwald)
		addplot: , ytitle("")
			
			graph save "jobs1980_inter", replace
					
/*Russia*/
interflex vote 	russia80prox01 russia80imp_cat01  ///
			defense80prox01 defense80imp_cat01 ///
			spend80prox01 spend80imp_cat01 ///
			abortion80prox01 abortion80imp_cat01 ///
			blackaid80prox01 blackaid80imp_cat01 ///
			unemploy80prox01 unemploy80imp_cat01 ///
			jobs80prox01 jobs80imp_cat01 ///
			pid01 ideol_2 ideol_3 ideol_4 econ01  gender race age01 educ01 income01  ///
					,  title(Russia) ///
					xlabel(Importance) dlabel(Proximity) ylabel(Vote) 
	
	
		estimates store russia
		estadd scalar wald = r(pwald)

		
	addplot: , ytitle("")		
			graph save "russia1980_inter", replace
	
/***Table of observations and Wald tests*/
esttab def spend abor blacks unemp jobs russia using WALD.rtf, onecell label replace ///
	mtitles("Defense" "Spending" "Abortion" "Aid to Blacks" "Unemployment" "Jobs" "Russia") ///
	scalars(wald)
	
/*Graphs*/
graph combine "def1980_inter" "spend1980_inter" "abor1980_inter" "unemp1980_inter" "blacks1980_inter" ///
		"jobs1980_inter" "russia1980_inter", ycommon title(1980 Binned Interactions)
		
graph display Graph , scheme(plotplain)

graph save "1980 interflex", replace
graph export "1980 interflex.png", replace


		
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

tabulate ideol, gen(ideol_)
	
eststo clear

interflex vote spend84prox01 spend84imp01 ///
	jobs84prox01 jobs84imp01 ///
	central84prox01 central84imp01 ///
	women84prox01 women84imp01 ///
	pid01 ideol_2 ideol_3 ideol_4 econ01  gender race age01 educ01 income01 ///
		, title(Spending) xlabel(Importance) dlabel(Proximity) ylabel(Vote)
	
	estimates store spend84
	estadd scalar wald = r(pwald)

	addplot: , ytitle("")		
	graph save "spend84", replace
	
interflex vote jobs84prox01 jobs84imp01 /// 
	spend84prox01 spend84imp01 ///
	central84prox01 central84imp01 ///
	women84prox01 women84imp01 ///
	pid01 ideol_2 ideol_3 ideol_4 econ01  gender race age01 educ01 income01 ///
		, title(Jobs) xlabel(Importance) dlabel(Proximity) ylabel(Vote)
	
	estimates store jobs84
	estadd scalar wald = r(pwald)

		
	addplot: , ytitle("")		
	graph save "jobs84", replace
	
	
interflex vote central84prox01 central84imp01 ///
	spend84prox01 spend84imp01 ///
	jobs84prox01 jobs84imp01 ///
	women84prox01 women84imp01 ///
	pid01 ideol_2 ideol_3 ideol_4 econ01  gender race age01 educ01 income01 ///
		, title(Central America) xlabel(Importance) dlabel(Proximity) ylabel(Vote)
		
	estimates store central84
	estadd scalar wald = r(pwald)

		
	addplot: , ytitle("")		
	graph save "central84", replace
	

interflex vote women84prox01 women84imp01 ///
	spend84prox01 spend84imp01 ///
	jobs84prox01 jobs84imp01 ///
	central84prox01 central84imp01 ///
	pid01 ideol_2 ideol_3 ideol_4 econ01  gender race age01 educ01 income01 ///
		, title(Women) xlabel(Importance) dlabel(Proximity) ylabel(Vote)
	
	estimates store women84
	estadd scalar wald = r(pwald)

		
	addplot: , ytitle("")		
	graph save "women84", replace

esttab spend84 jobs84 central84 women84 using wald84.rtf, onecell label replace ///
	mtitles("Spending" "Jobs" "Central A." "Women") ///
	scalars(wald)
	

graph combine "spend84" "jobs84" "central84" "women84", ycommon title(1984 Binned Interactions)	
graph display Graph , scheme(plotplain)

graph save "1984 interflex", replace
graph export "1984 interflex.png", replace

	
			***********************************
			***********************************
			***********************************
			***********1996 ANES TS************
			***********************************
			***********************************
			***********************************

clear
*Data cleaning
do "Data Cleaning - 1996 ANES TS.do"
set more off

	
tab ideol, gen(ideol_)

/*spend*/	
interflex vote spend96prox01 spend96imp01 ///
		defense96prox01 defense96imp01 ///
		blackaid96prox01 blackaid96imp01 ///
		abortion96prox01 abortion96imp01 ///
		enviro96prox01 enviro96imp01 ///
		pid01 ideol_2 ideol_3 ideol_4 econ01  gender race age01 educ01 income01 ///
		,	title(Spending) xlabel(Importance) dlabel(Proximity) ylabel(Vote)  
	

	estimates store spend96
	estadd scalar wald = r(pwald)

		
	addplot: , ytitle("")		
	graph save "spend96", replace

/*defense*/


interflex vote 	defense96prox01 defense96imp01 ///
	spend96prox01 spend96imp01 ///
		blackaid96prox01 blackaid96imp01 ///
		abortion96prox01 abortion96imp01 ///
		enviro96prox01 enviro96imp01 ///
		pid01 ideol_2 ideol_3 ideol_4 econ01  gender race age01 educ01 income01 ///
		,	title(Defense Spending) xlabel(Importance) dlabel(Proximity) ylabel(Vote)  
	

	estimates store def96
	estadd scalar wald = r(pwald)

		
	addplot: , ytitle("")		
	graph save "def96", replace
	
/*blackaid*/

interflex vote 		blackaid96prox01 blackaid96imp01 ///
		spend96prox01 spend96imp01 ///
		defense96prox01 defense96imp01 ///
		abortion96prox01 abortion96imp01 ///
		enviro96prox01 enviro96imp01 ///
		pid01 ideol_2 ideol_3 ideol_4 econ01  gender race age01 educ01 income01 ///
		,	title(Aid Blacks) xlabel(Importance) dlabel(Proximity) ylabel(Vote)  
	

	estimates store black96
	estadd scalar wald = r(pwald)

		
	addplot: , ytitle("")		
	graph save "black96", replace

/*abortion*/
			interflex vote 		abortion96prox01 abortion96imp01 ///
			spend96prox01 spend96imp01 ///
		defense96prox01 defense96imp01 ///
		blackaid96prox01 blackaid96imp01 ///
		enviro96prox01 enviro96imp01 ///
		pid01 ideol_2 ideol_3 ideol_4 econ01  gender race age01 educ01 income01 ///
		,	title(Abortion) xlabel(Importance) dlabel(Proximity) ylabel(Vote)  
	

	estimates store abor96
	estadd scalar wald = r(pwald)

		
	addplot: , ytitle("")		
	graph save "abor96", replace	
		
	/*enviro*/	
	
	interflex vote 			enviro96prox01 enviro96imp01 ///
		abortion96prox01 abortion96imp01 ///
			spend96prox01 spend96imp01 ///
		defense96prox01 defense96imp01 ///
		blackaid96prox01 blackaid96imp01 ///
		pid01 ideol_2 ideol_3 ideol_4 econ01  gender race age01 educ01 income01 ///
		,	title(Environment) xlabel(Importance) dlabel(Proximity) ylabel(Vote)  
	

	estimates store env96
	estadd scalar wald = r(pwald)

		
	addplot: , ytitle("")		
	graph save "env96", replace	
	

esttab spend96 def96  black96  abor96 env96 using wald96.rtf, onecell label replace ///
	scalars(wald) ///
	mtitles("Spending" "Def Spending" "Aid Blacks" "Abortion" "Environment") 


graph combine "spend96" "def96" "black96" "abor96" "env96", ycommon title(1996 Binned Interactions)	
graph display Graph , scheme(plotplain)

graph save "1996 interflex", replace
graph export "1996 interflex.png", replace



	
				***********************************
				***********************************
				***********************************
				***********2000 ANES TS************
				***********************************
				***********************************
				***********************************

*Data cleaning
clear
do "Data Cleaning - 2000 ANES TS.do"
set more off


tab ideol, gen(ideol_)

/*abortion*/
interflex vote abortion2000prox01 abortion2000imp01  ///
		guns2000prox01 guns2000imp01 ///
		regulation2000prox01 regulation2000imp01 ///
		pid01 ideol_2 ideol_3 ideol_4 econ01  gender race age01 educ01 income01 ///
		,	title(Abortion) xlabel(Importance) dlabel(Proximity) ylabel(Vote)  
	
	estimates store abor00
	estadd scalar wald = r(pwald)
	addplot: , ytitle("")		
	graph save "abor00", replace	
	


/*guns*/
interflex vote 		guns2000prox01 guns2000imp01 ///
			abortion2000prox01 abortion2000imp01  ///
		regulation2000prox01 regulation2000imp01 ///
		pid01 ideol_2 ideol_3 ideol_4 econ01  gender race age01 educ01 income01 ///
		,	title(Abortion) xlabel(Importance) dlabel(Proximity) ylabel(Vote)  
	
	estimates store guns00
	estadd scalar wald = r(pwald)
	addplot: , ytitle("")		
	graph save "guns00", replace	
	

/*regulation*/
	interflex vote 	regulation2000prox01 regulation2000imp01 ///
			guns2000prox01 guns2000imp01 ///
			abortion2000prox01 abortion2000imp01  ///
		pid01 ideol_2 ideol_3 ideol_4 econ01  gender race age01 educ01 income01 ///
		,	title(Env. Regulation) xlabel(Importance) dlabel(Proximity) ylabel(Vote)  
	
	estimates store env00
	estadd scalar wald = r(pwald)
	addplot: , ytitle("")		
	graph save "env00", replace	
	
	
esttab abor00 guns00 env00 using wald00.rtf, onecell label replace ///
	scalars(wald) ///
	mtitles("Abortion" "Guns" "Env. Regulation") 


graph combine "abor00" "guns00" "env00", ycommon title(2000 Binned Interactions)	
graph display Graph , scheme(plotplain)

graph save "2000 interflex", replace
graph export "2000 interflex.png", replace

				***********************************
				***********************************
				***********************************
				***********2004 ANES TS************
				***********************************
				***********************************
				***********************************

*Data cleaning
clear
do "Data Cleaning - 2004 ANES TS.do"
set more off

tab ideol, gen(ideol_)

	
/*defense*/
interflex vote defense2004prox01 defense2004imp01 ///
				spend2004prox01 spend2004imp01 ///
				jobs2004prox01 jobs2004imp01  ///
				blackaid2004prox01 blackaid2004imp01 ///
				envirojobs2004prox01 envirojobs2004imp01 ///
				guns2004prox101 guns2004imp01 ///
				womenrole2004prox01 womenrole2004imp01 ///
		pid01 ideol_2 ideol_3 econ01  gender race  age01 educ01 income01 ///
			,	title(Defense Spending) xlabel(Importance) dlabel(Proximity) ylabel(Vote)  
	
	estimates store def04
	estadd scalar wald = r(pwald)
	addplot: , ytitle("")		
	graph save "def04", replace	

/*spend*/
interflex vote 				spend2004prox01 spend2004imp01 ///
 defense2004prox01 defense2004imp01 ///
				jobs2004prox01 jobs2004imp01  ///
				blackaid2004prox01 blackaid2004imp01 ///
				envirojobs2004prox01 envirojobs2004imp01 ///
				guns2004prox101 guns2004imp01 ///
				womenrole2004prox01 womenrole2004imp01 ///
		pid01 ideol_2 ideol_3 econ01  gender race  age01 educ01 income01 ///
			,	title(Spending) xlabel(Importance) dlabel(Proximity) ylabel(Vote)  
	
	estimates store spend04
	estadd scalar wald = r(pwald)
	addplot: , ytitle("")		
	graph save "spend04", replace	

/*jobs*/
interflex vote 				jobs2004prox01 jobs2004imp01  ///
		defense2004prox01 defense2004imp01 ///
				spend2004prox01 spend2004imp01 ///
				blackaid2004prox01 blackaid2004imp01 ///
				envirojobs2004prox01 envirojobs2004imp01 ///
				guns2004prox101 guns2004imp01 ///
				womenrole2004prox01 womenrole2004imp01 ///
		pid01 ideol_2 ideol_3 econ01  gender race  age01 educ01 income01 ///
			,	title(Jobs) xlabel(Importance) dlabel(Proximity) ylabel(Vote)  
	
	estimates store jobs04
	estadd scalar wald = r(pwald)
	addplot: , ytitle("")		
	graph save "jobs04", replace	
	
/*blackaid*/
interflex vote				blackaid2004prox01 blackaid2004imp01 ///
		defense2004prox01 defense2004imp01 ///
				spend2004prox01 spend2004imp01 ///
				jobs2004prox01 jobs2004imp01  ///
				envirojobs2004prox01 envirojobs2004imp01 ///
				guns2004prox101 guns2004imp01 ///
				womenrole2004prox01 womenrole2004imp01 ///
		pid01 ideol_2 ideol_3 econ01  gender race  age01 educ01 income01 ///
			,	title(Aid Blacks) xlabel(Importance) dlabel(Proximity) ylabel(Vote)  
	
	estimates store black04
	estadd scalar wald = r(pwald)
	addplot: , ytitle("")		
	graph save "black04", replace	
	
/*enviro*/
interflex vote 				envirojobs2004prox01 envirojobs2004imp01 ///
			defense2004prox01 defense2004imp01 ///
				spend2004prox01 spend2004imp01 ///
				jobs2004prox01 jobs2004imp01  ///
				blackaid2004prox01 blackaid2004imp01 ///
				guns2004prox101 guns2004imp01 ///
				womenrole2004prox01 womenrole2004imp01 ///
		pid01 ideol_2 ideol_3 econ01  gender race  age01 educ01 income01 ///
			,	title(Environment) xlabel(Importance) dlabel(Proximity) ylabel(Vote)  
	
	estimates store env04
	estadd scalar wald = r(pwald)
	addplot: , ytitle("")		
	graph save "env04", replace	
	
/*guns*/
interflex vote 				guns2004prox101 guns2004imp01 ///
		defense2004prox01 defense2004imp01 ///
				spend2004prox01 spend2004imp01 ///
				jobs2004prox01 jobs2004imp01  ///
				blackaid2004prox01 blackaid2004imp01 ///
				envirojobs2004prox01 envirojobs2004imp01 ///
				womenrole2004prox01 womenrole2004imp01 ///
		pid01 ideol_2 ideol_3 econ01  gender race  age01 educ01 income01 ///
			,	title(Guns) xlabel(Importance) dlabel(Proximity) ylabel(Vote)  
	
	estimates store guns04
	estadd scalar wald = r(pwald)
	addplot: , ytitle("")		
	graph save "guns04", replace	
	
/*women*/
interflex vote 				womenrole2004prox01 womenrole2004imp01 ///
		defense2004prox01 defense2004imp01 ///
				spend2004prox01 spend2004imp01 ///
				jobs2004prox01 jobs2004imp01  ///
				blackaid2004prox01 blackaid2004imp01 ///
				envirojobs2004prox01 envirojobs2004imp01 ///
				guns2004prox101 guns2004imp01 ///
		pid01 ideol_2 ideol_3 econ01  gender race  age01 educ01 income01 ///
			,	title(Women) xlabel(Importance) dlabel(Proximity) ylabel(Vote)  
	
	estimates store wom04
	estadd scalar wald = r(pwald)
	addplot: , ytitle("")		
	graph save "wom04", replace	

esttab def04 spend04 jobs04 black04 env04 guns04 wom04 using wald04.rtf, onecell label replace ///
	scalars(wald) ///
	mtitles("Defense" "Spending" "Jobs" "Aid Blacks" "Environment" "Guns" "Women")  


graph combine "def04" "spend04" "jobs04" "black04" "env04" "guns04" "wom04", ycommon title(2004 Binned Interactions)	
graph display Graph , scheme(plotplain)

graph save "2004 interflex", replace
graph export "2004 interflex.png", replace

	
			***********************************
			***********************************
			***********************************
			***********2008 ANES TS************
			***********************************
			***********************************
			***********************************

*Data cleaning
clear
do "Data Cleaning - 2008 ANES TS.do"
set more off

tab ideol, gen(ideol_)

	
		/****F1****/

interflex vote defense2008proxold01 defense2008impold01 ///
			spend2008proxold01 spend2008impold01 ///
			jobs2008prox01 jobs2008imp01 ///
			blackaid2008prox01 blackaid2008impold01 ///
			envirojobs2008prox01 envirojobs2008imp01 ///
			health2008prox01 health2008imp01 ///
			women2008prox01 women2008imp01 ///
			pid01 ideol_2 ideol_3 ideol_4  econ01  gender race age01 educ01 income01  ///
				,	title(Defense Spending) xlabel(Importance) dlabel(Proximity) ylabel(Vote)  
	
	estimates store def08a
	estadd scalar wald = r(pwald)
	addplot: , ytitle("")		
	graph save "def08a", replace	
		
/*spend*/

interflex vote 			spend2008proxold01 spend2008impold01 ///
defense2008proxold01 defense2008impold01 ///
			jobs2008prox01 jobs2008imp01 ///
			blackaid2008prox01 blackaid2008impold01 ///
			envirojobs2008prox01 envirojobs2008imp01 ///
			health2008prox01 health2008imp01 ///
			women2008prox01 women2008imp01 ///
			pid01 ideol_2 ideol_3 ideol_4  econ01  gender race age01 educ01 income01  ///
				,	title(Spending) xlabel(Importance) dlabel(Proximity) ylabel(Vote)  
	
	estimates store spend08a
	estadd scalar wald = r(pwald)
	addplot: , ytitle("")		
	graph save "spend08a", replace	

/*jobs*/

interflex vote 			jobs2008prox01 jobs2008imp01 ///
		defense2008proxold01 defense2008impold01 ///
			spend2008proxold01 spend2008impold01 ///
			blackaid2008prox01 blackaid2008impold01 ///
			envirojobs2008prox01 envirojobs2008imp01 ///
			health2008prox01 health2008imp01 ///
			women2008prox01 women2008imp01 ///
			pid01 ideol_2 ideol_3 ideol_4  econ01  gender race age01 educ01 income01  ///
				,	title(Jobs) xlabel(Importance) dlabel(Proximity) ylabel(Vote)  
	
	estimates store jobs08a
	estadd scalar wald = r(pwald)
	addplot: , ytitle("")		
	graph save "jobs08a", replace	

/*blackaid*/

interflex vote 			blackaid2008prox01 blackaid2008impold01 ///
	defense2008proxold01 defense2008impold01 ///
			spend2008proxold01 spend2008impold01 ///
			jobs2008prox01 jobs2008imp01 ///
			envirojobs2008prox01 envirojobs2008imp01 ///
			health2008prox01 health2008imp01 ///
			women2008prox01 women2008imp01 ///
			pid01 ideol_2 ideol_3 ideol_4  econ01  gender race age01 educ01 income01  ///
				,	title(Aid Blacks) xlabel(Importance) dlabel(Proximity) ylabel(Vote)  
	
	estimates store blacks08a
	estadd scalar wald = r(pwald)
	addplot: , ytitle("")		
	graph save "blacks08a", replace	
/*enviro*/
interflex vote 			envirojobs2008prox01 envirojobs2008imp01 ///
		defense2008proxold01 defense2008impold01 ///
			spend2008proxold01 spend2008impold01 ///
			jobs2008prox01 jobs2008imp01 ///
			blackaid2008prox01 blackaid2008impold01 ///
			health2008prox01 health2008imp01 ///
			women2008prox01 women2008imp01 ///
			pid01 ideol_2 ideol_3 ideol_4  econ01  gender race age01 educ01 income01  ///
				,	title(Environment) xlabel(Importance) dlabel(Proximity) ylabel(Vote)  
	
	estimates store env08a
	estadd scalar wald = r(pwald)
	addplot: , ytitle("")		
	graph save "env08a", replace	

/*health*/

interflex vote 			health2008prox01 health2008imp01 ///
		defense2008proxold01 defense2008impold01 ///
			spend2008proxold01 spend2008impold01 ///
			jobs2008prox01 jobs2008imp01 ///
			blackaid2008prox01 blackaid2008impold01 ///
			envirojobs2008prox01 envirojobs2008imp01 ///
			women2008prox01 women2008imp01 ///
			pid01 ideol_2 ideol_3 ideol_4  econ01  gender race age01 educ01 income01  ///
				,	title(Health Insurance) xlabel(Importance) dlabel(Proximity) ylabel(Vote)  
	
	estimates store health08a
	estadd scalar wald = r(pwald)
	addplot: , ytitle("")		
	graph save "health08a", replace	
/*women*/	
interflex vote 			women2008prox01 women2008imp01 ///
			defense2008proxold01 defense2008impold01 ///
			spend2008proxold01 spend2008impold01 ///
			jobs2008prox01 jobs2008imp01 ///
			blackaid2008prox01 blackaid2008impold01 ///
			envirojobs2008prox01 envirojobs2008imp01 ///
			health2008prox01 health2008imp01 ///
			pid01 ideol_2 ideol_3 ideol_4  econ01  gender race age01 educ01 income01  ///
				,	title(Women) xlabel(Importance) dlabel(Proximity) ylabel(Vote)  
	
	estimates store women08a
	estadd scalar wald = r(pwald)
	addplot: , ytitle("")		
	graph save "women08a", replace		
		

esttab def08a spend08a jobs08a blacks08a env08a health08a women08a using wald08a.rtf, onecell label replace ///
	scalars(wald) ///
	mtitles("Defense" "Spending" "Jobs" "Aid Blacks" "Environment" "Insurnace" "Women")  


graph combine "def08a" "spend08a" "jobs08a" "blacks08a" "env08a" "health08a" "women08a", ycommon title(2008 (pt 1) Binned Interactions)
graph display Graph , scheme(plotplain)

graph save "2008a interflex", replace
graph export "2008a interflex.png", replace
	
		
		
		
			/****F2****/

interflex vote defense2008proxnew01 defense2008impnew01 ///
	spend2008proxnew01 spend2008impnew01 ///
	blackaid2008prox01 blackaid2008impnew01 ///
	emission2008prox01 emission2008imp01 ///
	universal2008prox01 universal2008imp01 ///
	citizenship2008prox01 citizenship2008imp01 ///
		pid01 ideol_2 ideol_3 ideol_4  econ01  gender race age01 educ01 income01  ///
				,	title(Defense) xlabel(Importance) dlabel(Proximity) ylabel(Vote)  
	
	estimates store def08b
	estadd scalar wald = r(pwald)
	addplot: , ytitle("")		
	graph save "def08b", replace
	
	
/*spend*/

interflex vote 	spend2008proxnew01 spend2008impnew01 ///
 defense2008proxnew01 defense2008impnew01 ///
	blackaid2008prox01 blackaid2008impnew01 ///
	emission2008prox01 emission2008imp01 ///
	universal2008prox01 universal2008imp01 ///
	citizenship2008prox01 citizenship2008imp01 ///
		pid01 ideol_2 ideol_3 ideol_4  econ01  gender race age01 educ01 income01  ///
				,	title(Defense) xlabel(Importance) dlabel(Proximity) ylabel(Vote)  
	
	estimates store spend08b
	estadd scalar wald = r(pwald)
	addplot: , ytitle("")		
	graph save "spend08b", replace
	
/*blackaid*/

interflex vote 	blackaid2008prox01 blackaid2008impnew01 ///
	defense2008proxnew01 defense2008impnew01 ///
	spend2008proxnew01 spend2008impnew01 ///
	emission2008prox01 emission2008imp01 ///
	universal2008prox01 universal2008imp01 ///
	citizenship2008prox01 citizenship2008imp01 ///
		pid01 ideol_2 ideol_3 ideol_4  econ01  gender race age01 educ01 income01  ///
				,	title(Aid Blacks) xlabel(Importance) dlabel(Proximity) ylabel(Vote)  
	
	estimates store blacks08b
	estadd scalar wald = r(pwald)
	addplot: , ytitle("")		
	graph save "blacks08b", replace
	
/*emission*/

interflex vote 	emission2008prox01 emission2008imp01 ///
	defense2008proxnew01 defense2008impnew01 ///
	spend2008proxnew01 spend2008impnew01 ///
	blackaid2008prox01 blackaid2008impnew01 ///
	universal2008prox01 universal2008imp01 ///
	citizenship2008prox01 citizenship2008imp01 ///
		pid01 ideol_2 ideol_3 ideol_4  econ01  gender race age01 educ01 income01  ///
				,	title(Emissions) xlabel(Importance) dlabel(Proximity) ylabel(Vote)  
	
	estimates store em08b
	estadd scalar wald = r(pwald)
	addplot: , ytitle("")		
	graph save "em08b", replace
	
/*universal*/

interflex vote 	universal2008prox01 universal2008imp01 ///
	defense2008proxnew01 defense2008impnew01 ///
	spend2008proxnew01 spend2008impnew01 ///
	blackaid2008prox01 blackaid2008impnew01 ///
	emission2008prox01 emission2008imp01 ///
	citizenship2008prox01 citizenship2008imp01 ///
		pid01 ideol_2 ideol_3 ideol_4  econ01  gender race age01 educ01 income01  ///
				,	title(Universal HC) xlabel(Importance) dlabel(Proximity) ylabel(Vote)  
	
	estimates store univ08b
	estadd scalar wald = r(pwald)
	addplot: , ytitle("")		
	graph save "univ08b", replace
	
/*citizenship*/

interflex vote 	citizenship2008prox01 citizenship2008imp01 ///
	defense2008proxnew01 defense2008impnew01 ///
	spend2008proxnew01 spend2008impnew01 ///
	blackaid2008prox01 blackaid2008impnew01 ///
	emission2008prox01 emission2008imp01 ///
	universal2008prox01 universal2008imp01 ///
		pid01 ideol_2 ideol_3 ideol_4  econ01  gender race age01 educ01 income01  ///
				,	title(Citizenship) xlabel(Importance) dlabel(Proximity) ylabel(Vote)  
	
	estimates store citi08b
	estadd scalar wald = r(pwald)
	addplot: , ytitle("")		
	graph save "citi08b", replace
	
	
esttab def08b spend08b blacks08b em08b univ08b citi08b using wald08b.rtf, onecell label replace ///
	scalars(wald) ///
	mtitles("Defense" "Spending" "Aid Blacks" "Emissions" "Universal HC" "Citizensihp") 
	
graph combine "def08b" "spend08b" "blacks08b" "em08b" "univ08b" "citi08b", ycommon title(2008 (pt 2) Binned Interactions)
graph display Graph , scheme(plotplain)

graph save "2008b interflex", replace
graph export "2008b interflex.png", replace

			
				***********************************
				***********************************
				***********************************
				***********2008 ANES Panel*********
				***********************************
				***********************************
				***********************************

*Data cleaning
clear
do "Data Cleaning - 2008 ANES Panel.do"
set more off

tab ideol, gen(ideol_)
	
interflex vote samesex10prox01 samesex10imp01 ///
		richtaxes10prox01 richtaxes10imp01 ///
		drugs10prox01 drugs10imp01 ///
		medic10prox01 medic10imp01 ///
		habeas10prox01 habeas10imp01 ///
		phone10prox01 phone10imp01 ///
		illeg10prox01 illeg10imp01 ///
		path10prox01 path10imp01 ///
		withdraw10prox01 withdraw10imp01 ///
		pid1001 ideol_2 ideol_3 econ01 gender race age01 educ01 income01   ///
		,	title(Same Sex Marriage) xlabel(Importance) dlabel(Proximity) ylabel(Vote)  
	
				
	estimates store ss08c
	estadd scalar wald = r(pwald)
	addplot: , ytitle("")		
	graph save "ss08c", replace

/*richtaxes*/
interflex vote 		richtaxes10prox01 richtaxes10imp01 ///
 samesex10prox01 samesex10imp01 ///
		drugs10prox01 drugs10imp01 ///
		medic10prox01 medic10imp01 ///
		habeas10prox01 habeas10imp01 ///
		phone10prox01 phone10imp01 ///
		illeg10prox01 illeg10imp01 ///
		path10prox01 path10imp01 ///
		withdraw10prox01 withdraw10imp01 ///
		pid1001 ideol_2 ideol_3 econ01 gender race age01 educ01 income01   ///
		,	title(Tax Rich) xlabel(Importance) dlabel(Proximity) ylabel(Vote)  
	
				
	estimates store rt08c
	estadd scalar wald = r(pwald)
	addplot: , ytitle("")		
	graph save "rt08c", replace
	
/*drugs*/
interflex vote 		drugs10prox01 drugs10imp01 ///
 samesex10prox01 samesex10imp01 ///
		richtaxes10prox01 richtaxes10imp01 ///
		medic10prox01 medic10imp01 ///
		habeas10prox01 habeas10imp01 ///
		phone10prox01 phone10imp01 ///
		illeg10prox01 illeg10imp01 ///
		path10prox01 path10imp01 ///
		withdraw10prox01 withdraw10imp01 ///
		pid1001 ideol_2 ideol_3 econ01 gender race age01 educ01 income01  ///
		,	title(Drugs) xlabel(Importance) dlabel(Proximity) ylabel(Vote)  
	
				
	estimates store drug08c
	estadd scalar wald = r(pwald)
	addplot: , ytitle("")		
	graph save "drug08c", replace
/*medic*/
interflex vote 		medic10prox01 medic10imp01 ///
 samesex10prox01 samesex10imp01 ///
		richtaxes10prox01 richtaxes10imp01 ///
		drugs10prox01 drugs10imp01 ///
		habeas10prox01 habeas10imp01 ///
		phone10prox01 phone10imp01 ///
		illeg10prox01 illeg10imp01 ///
		path10prox01 path10imp01 ///
		withdraw10prox01 withdraw10imp01 ///
		pid1001 ideol_2 ideol_3 econ01 gender race age01 educ01 income01   ///
		,	title(Medical Care) xlabel(Importance) dlabel(Proximity) ylabel(Vote)  
	
				
	estimates store med08c
	estadd scalar wald = r(pwald)
	addplot: , ytitle("")		
	graph save "med08c", replace
	
/*habeas*/
interflex vote 		habeas10prox01 habeas10imp01 ///
    samesex10prox01 samesex10imp01 ///
		richtaxes10prox01 richtaxes10imp01 ///
		drugs10prox01 drugs10imp01 ///
		medic10prox01 medic10imp01 ///
		phone10prox01 phone10imp01 ///
		illeg10prox01 illeg10imp01 ///
		path10prox01 path10imp01 ///
		withdraw10prox01 withdraw10imp01 ///
		pid1001 ideol_2 ideol_3 econ01 gender race age01 educ01 income01   ///
		,	title(Habeas) xlabel(Importance) dlabel(Proximity) ylabel(Vote)  
	
				
	estimates store hab08c
	estadd scalar wald = r(pwald)
	addplot: , ytitle("")		
	graph save "hab08c", replace
/*phone*/
interflex vote 		phone10prox01 phone10imp01 ///
 samesex10prox01 samesex10imp01 ///
		richtaxes10prox01 richtaxes10imp01 ///
		drugs10prox01 drugs10imp01 ///
		medic10prox01 medic10imp01 ///
		habeas10prox01 habeas10imp01 ///
		illeg10prox01 illeg10imp01 ///
		path10prox01 path10imp01 ///
		withdraw10prox01 withdraw10imp01 ///
		pid1001 ideol_2 ideol_3 econ01 gender race age01 educ01 income01  ///
		,	title(Wiretap) xlabel(Importance) dlabel(Proximity) ylabel(Vote)  
	
				
	estimates store ph08c
	estadd scalar wald = r(pwald)
	addplot: , ytitle("")		
	graph save "ph08c", replace
	
/*illeg*/
interflex vote 		illeg10prox01 illeg10imp01 ///
   samesex10prox01 samesex10imp01 ///
		richtaxes10prox01 richtaxes10imp01 ///
		drugs10prox01 drugs10imp01 ///
		medic10prox01 medic10imp01 ///
		habeas10prox01 habeas10imp01 ///
		phone10prox01 phone10imp01 ///
		path10prox01 path10imp01 ///
		withdraw10prox01 withdraw10imp01 ///
		pid1001 ideol_2 ideol_3 econ01 gender race age01 educ01 income01   ///
		,	title(Illeg Imm.) xlabel(Importance) dlabel(Proximity) ylabel(Vote)  
	
				
	estimates store ill08c
	estadd scalar wald = r(pwald)
	addplot: , ytitle("")		
	graph save "ill08c", replace
	
/*path*/
interflex vote 		path10prox01 path10imp01 ///
   samesex10prox01 samesex10imp01 ///
		richtaxes10prox01 richtaxes10imp01 ///
		drugs10prox01 drugs10imp01 ///
		medic10prox01 medic10imp01 ///
		habeas10prox01 habeas10imp01 ///
		phone10prox01 phone10imp01 ///
		illeg10prox01 illeg10imp01 ///
		withdraw10prox01 withdraw10imp01 ///
		pid1001 ideol_2 ideol_3 econ01 gender race age01 educ01 income01   ///
		,	title(Citizenship) xlabel(Importance) dlabel(Proximity) ylabel(Vote)  
	
				
	estimates store path08c
	estadd scalar wald = r(pwald)
	addplot: , ytitle("")		
	graph save "path08c", replace
	
/*withdraw*/
	interflex vote 		withdraw10prox01 withdraw10imp01 ///
   samesex10prox01 samesex10imp01 ///
		richtaxes10prox01 richtaxes10imp01 ///
		drugs10prox01 drugs10imp01 ///
		medic10prox01 medic10imp01 ///
		habeas10prox01 habeas10imp01 ///
		phone10prox01 phone10imp01 ///
		illeg10prox01 illeg10imp01 ///
		path10prox01 path10imp01 ///
		pid1001 ideol_2 ideol_3 econ01 gender race age01 educ01 income01 ///
		,	title(Iraq) xlabel(Importance) dlabel(Proximity) ylabel(Vote)  
	
				
	estimates store with08c
	estadd scalar wald = r(pwald)
	addplot: , ytitle("")		
	graph save "with08c", replace
	
	
	

	
esttab ss08c rt08c drug08c med08c hab08c ph08c ill08c path08c with08c using wald08c.rtf, onecell label replace ///
	scalars(wald) ///
	mtitles("Same Sex Marriage" "Tax Rich" "Drugs" "Medical Care" "Habeas" "Phone Taps" "Ill. Imm" "Citizenship" "Iraq")
	
	
	
	
graph combine "ss08c" "rt08c" "drug08c" "med08c" "hab08c" "ph08c" "ill08c" "path08c" "with08c"
graph display Graph , scheme(plotplain)

graph save "2008c interflex", replace
graph export "2008c interflex.png", replace

