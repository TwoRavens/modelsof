/*******************************************************************************
The following .do file contains the code necessary to generate the ANES
Time Series Analyses reported in-text (Figures 1 and 2; Online Appendix B
which has the model results; and Figure OC2 which provides an analysis
of proximity effects in the ANES TS). 

Some additional STATA modules need to be installed to run this code: 
	
 ssc install parmest
 ssc install combomarginsplot
 ssc install estout
 
 
The code progresses as follows: Survey by survey it loads/cleans the data, 
runs the models where all interactions are included at once, then runs
models where the interactions are done issue by issue. In so doing it 
creates graphs that will be combined later into Figures 1 and 2, etc., and 
also uses parmest to create data files with estimates for further analysis. It
then finishes with code creating the figures. 
*******************************************************************************/

cd "C:\Users\Joshua\Dropbox\Work\Isssue Importance and Voting Paper\Dataverse\"
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

/***********************
Loading/Cleaning
***********************/

do "Data Cleaning - 1980 ANES TS.do"

log using anes1980.log, replace
set more off


/************************
All Interactions at once
************************/

/**Models**/
eststo clear
eststo: logit vote pid01 i.ideol econ01  i.gender i.race ///
		age01 educ01 income01 
eststo: logit vote defense80prox01 spend80prox01 abortion80prox01 blackaid80prox01 unemploy80prox01 ///
	jobs80prox01 russia80prox01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01			
eststo: logit vote c.defense80prox01##c.defense80imp_cat01 c.spend80prox01##c.spend80imp_cat01 c.abortion80prox01##c.abortion80imp_cat01 ///
	c.blackaid80prox01##c.blackaid80imp_cat01 c.unemploy80prox01##c.unemploy80imp_cat01 c.jobs80prox01##c.jobs80imp_cat01 ///
	c.russia80prox01##c.russia80imp_cat01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 
			
*Wald Test
	testparm c.defense80imp_cat01 c.defense80prox01#c.defense80imp_cat01 ///
		c.spend80imp_cat01 c.spend80prox01#c.spend80imp_cat01 ///
		c.abortion80imp_cat01 c.abortion80prox01#c.abortion80imp_cat01 ///
		c.blackaid80imp_cat01 c.blackaid80prox01#c.blackaid80imp_cat01 ///
		c.unemploy80imp_cat01 c.unemploy80prox01#c.unemploy80imp_cat01 ///
		 c.jobs80imp_cat01 c.jobs80prox01#c.jobs80imp_cat01 ///
		c.russia80imp_cat01 c.russia80prox01#c.russia80imp_cat01
					
*margins for later graphing as part of Figure 1
margins, dydx(defense80prox01) at(defense80imp_cat01=(0  .3333333  .6666667   1)) saving(1980ALL_defense, replace) 
marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Defense:1980, size(medsmall)) scheme(s1mono) ///
	yline(0, lpattern(dash))
graph save "Defense1980ALL", replace


margins, dydx(blackaid80prox01) at(blackaid80imp_cat01=(0  .3333333  .6666667   1)) saving(1980ALL_blackaid, replace)
marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Aid Blacks:1980, size(medsmall)) scheme(s1mono) ///
	yline(0, lpattern(dash))
graph save "BlackAid1980ALL", replace

margins, dydx(spend80prox01) at(spend80imp_cat01=(0  .3333333  .6666667   1)) saving(1980ALL_spend, replace)
marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Spending:1980, size(medsmall)) scheme(s1mono) ///
	yline(0, lpattern(dash))
graph save "Spend1980ALL", replace

margins, dydx(abortion80prox01) at(abortion80imp_cat01=(0  .3333333  .6666667   1)) saving(1980ALL_abortion, replace)
marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Abortion:1980, size(medsmall)) scheme(s1mono) ///
	yline(0, lpattern(dash))
graph save "Abortion1980ALL", replace
				
margins, dydx(unemploy80prox01) at(unemploy80imp_cat01=(0  .3333333  .6666667   1)) saving(1980ALL_unemploy, replace)
marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Unemployment:1980, size(medsmall)) scheme(s1mono) ///
	yline(0, lpattern(dash))
graph save "Unemploy1980ALL", replace
				
margins, dydx(jobs80prox01) at(jobs80imp_cat01=(0  .3333333  .6666667   1)) saving(1980ALL_jobs, replace)
marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Jobs:1980, size(medsmall)) scheme(s1mono) ///
	yline(0, lpattern(dash))
graph save "Jobs1980ALL", replace

margins, dydx(russia80prox01) at(russia80imp_cat01=(0  .3333333  .6666667   1)) saving(1980ALL_russia, replace)
marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Russia:1980, size(medsmall)) scheme(s1mono) ///
	yline(0, lpattern(dash))
graph save "Russia1980ALL", replace
								
/*Comparing proximity at high and low importance; parmest is used to save the estimates;
this necessitates the use of the post command and thus running the model again
in retrospect, this imght have been easier with a foreach loop :) 
*/
			
margins if defense80imp_cat01 >=0 & defense80imp_cat01 <=0.35, dydx(defense80prox01)  post
	parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(def80_lowALL.dta, replace)
					
logit vote c.defense80prox01##c.defense80imp_cat01 c.spend80prox01##c.spend80imp_cat01 c.abortion80prox01##c.abortion80imp_cat01 ///
c.blackaid80prox01##c.blackaid80imp_cat01 c.unemploy80prox01##c.unemploy80imp_cat01 c.jobs80prox01##c.jobs80imp_cat01 ///
c.russia80prox01##c.russia80imp_cat01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 

margins if defense80imp_cat01 >=0.36 & defense80imp_cat01 <=1, dydx(defense80prox01)  post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(def80_highALL.dta, replace)

*spending
logit vote c.defense80prox01##c.defense80imp_cat01 c.spend80prox01##c.spend80imp_cat01 c.abortion80prox01##c.abortion80imp_cat01 ///
c.blackaid80prox01##c.blackaid80imp_cat01 c.unemploy80prox01##c.unemploy80imp_cat01 c.jobs80prox01##c.jobs80imp_cat01 ///
c.russia80prox01##c.russia80imp_cat01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 

margins if spend80imp_cat01 >=0 & spend80imp_cat01 <=0.35, dydx(spend80prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(spend80_lowALL.dta, replace)

logit vote c.defense80prox01##c.defense80imp_cat01 c.spend80prox01##c.spend80imp_cat01 c.abortion80prox01##c.abortion80imp_cat01 ///
c.blackaid80prox01##c.blackaid80imp_cat01 c.unemploy80prox01##c.unemploy80imp_cat01 c.jobs80prox01##c.jobs80imp_cat01 ///
c.russia80prox01##c.russia80imp_cat01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 

margins if spend80imp_cat01 >=0.36 & spend80imp_cat01 <=1, dydx(spend80prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(spend80_highALL.dta, replace)

*abortion
logit vote c.defense80prox01##c.defense80imp_cat01 c.spend80prox01##c.spend80imp_cat01 c.abortion80prox01##c.abortion80imp_cat01 ///
c.blackaid80prox01##c.blackaid80imp_cat01 c.unemploy80prox01##c.unemploy80imp_cat01 c.jobs80prox01##c.jobs80imp_cat01 ///
c.russia80prox01##c.russia80imp_cat01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 

margins if abortion80imp_cat01 >=0 & abortion80imp_cat01 <=0.35, dydx(abortion80prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(abo80_lowALL.dta, replace)

logit vote c.defense80prox01##c.defense80imp_cat01 c.spend80prox01##c.spend80imp_cat01 c.abortion80prox01##c.abortion80imp_cat01 ///
c.blackaid80prox01##c.blackaid80imp_cat01 c.unemploy80prox01##c.unemploy80imp_cat01 c.jobs80prox01##c.jobs80imp_cat01 ///
c.russia80prox01##c.russia80imp_cat01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 

margins if abortion80imp_cat01 >=0.36 & abortion80imp_cat01 <=1, dydx(abortion80prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(abo80_highALL.dta, replace)

	
*aid to blacks
logit vote c.defense80prox01##c.defense80imp_cat01 c.spend80prox01##c.spend80imp_cat01 c.abortion80prox01##c.abortion80imp_cat01 ///
c.blackaid80prox01##c.blackaid80imp_cat01 c.unemploy80prox01##c.unemploy80imp_cat01 c.jobs80prox01##c.jobs80imp_cat01 ///
c.russia80prox01##c.russia80imp_cat01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 
			
margins if blackaid80imp_cat01 >=0 & blackaid80imp_cat01 <=0.35, dydx(blackaid80prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(aidblacks80_lowALL.dta, replace)

logit vote c.defense80prox01##c.defense80imp_cat01 c.spend80prox01##c.spend80imp_cat01 c.abortion80prox01##c.abortion80imp_cat01 ///
c.blackaid80prox01##c.blackaid80imp_cat01 c.unemploy80prox01##c.unemploy80imp_cat01 c.jobs80prox01##c.jobs80imp_cat01 ///
c.russia80prox01##c.russia80imp_cat01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 

margins if blackaid80imp_cat01 >=0.36 & blackaid80imp_cat01 <=1, dydx(blackaid80prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(aidblacks80_highALL.dta, replace)

			
*unemployment
logit vote c.defense80prox01##c.defense80imp_cat01 c.spend80prox01##c.spend80imp_cat01 c.abortion80prox01##c.abortion80imp_cat01 ///
c.blackaid80prox01##c.blackaid80imp_cat01 c.unemploy80prox01##c.unemploy80imp_cat01 c.jobs80prox01##c.jobs80imp_cat01 ///
c.russia80prox01##c.russia80imp_cat01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 

margins if unemploy80imp_cat01 >=0 & unemploy80imp_cat01 <=0.35, dydx(unemploy80prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(unemploy80_lowALL.dta, replace)

logit vote c.defense80prox01##c.defense80imp_cat01 c.spend80prox01##c.spend80imp_cat01 c.abortion80prox01##c.abortion80imp_cat01 ///
c.blackaid80prox01##c.blackaid80imp_cat01 c.unemploy80prox01##c.unemploy80imp_cat01 c.jobs80prox01##c.jobs80imp_cat01 ///
c.russia80prox01##c.russia80imp_cat01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 

margins if unemploy80imp_cat01 >=0.36 & unemploy80imp_cat01 <=1, dydx(unemploy80prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(unemploy80_highALL.dta, replace)
		
				
*jobs
logit vote c.defense80prox01##c.defense80imp_cat01 c.spend80prox01##c.spend80imp_cat01 c.abortion80prox01##c.abortion80imp_cat01 ///
c.blackaid80prox01##c.blackaid80imp_cat01 c.unemploy80prox01##c.unemploy80imp_cat01 c.jobs80prox01##c.jobs80imp_cat01 ///
c.russia80prox01##c.russia80imp_cat01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 

margins if jobs80imp_cat01 >=0 & jobs80imp_cat01 <=0.35, dydx(jobs80prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(jobs80_lowALL.dta, replace)

logit vote c.defense80prox01##c.defense80imp_cat01 c.spend80prox01##c.spend80imp_cat01 c.abortion80prox01##c.abortion80imp_cat01 ///
c.blackaid80prox01##c.blackaid80imp_cat01 c.unemploy80prox01##c.unemploy80imp_cat01 c.jobs80prox01##c.jobs80imp_cat01 ///
c.russia80prox01##c.russia80imp_cat01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 

margins if jobs80imp_cat01 >=0.36 & jobs80imp_cat01 <=1, dydx(jobs80prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(jobs80_highALL.dta, replace)


*russia
logit vote c.defense80prox01##c.defense80imp_cat01 c.spend80prox01##c.spend80imp_cat01 c.abortion80prox01##c.abortion80imp_cat01 ///
c.blackaid80prox01##c.blackaid80imp_cat01 c.unemploy80prox01##c.unemploy80imp_cat01 c.jobs80prox01##c.jobs80imp_cat01 ///
c.russia80prox01##c.russia80imp_cat01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 

margins if russia80imp_cat01 >=0 & russia80imp_cat01 <=0.35, dydx(russia80prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(russia80_lowALL.dta, replace)

logit vote c.defense80prox01##c.defense80imp_cat01 c.spend80prox01##c.spend80imp_cat01 c.abortion80prox01##c.abortion80imp_cat01 ///
c.blackaid80prox01##c.blackaid80imp_cat01 c.unemploy80prox01##c.unemploy80imp_cat01 c.jobs80prox01##c.jobs80imp_cat01 ///
c.russia80prox01##c.russia80imp_cat01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 

margins if russia80imp_cat01 >=0.36 & russia80imp_cat01 <=1, dydx(russia80prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(russia80_highALL.dta, replace)
	
			
/******Creating the Table*******/
esttab using 1980_Interactions_ALL.rtf, replace se pr2 aic bic onecell ///
	star(+ 0.10 * 0.05 ** 0.01) label nobaselevels ///
	title({\b Table XX.} Subjective Importance and Proximity Voting - 1980 TS) 
	
eststo clear

	
/*****************************
Interactions, one at a time
*****************************/	

/*Missing Variables
	This code was initially present to facilitate the use of 
	likelihood ratio tests to compare the models (which require
	the samenumber of observations). However, we ultimately 
	went with Wald tests in all cases because these could 
	be used with weighted models results. The nmiss filter
	is only present in the initial base and proximity models
	below. 
**/
		
egen nmiss = rowmiss(pid01 ideol econ01  gender race age01 educ01 income01 ///	
			defense80prox01 spend80prox01 abortion80prox01 blackaid80prox01 unemploy80prox01 ///
			jobs80prox01 russia80prox01)
					
*Base Model
	eststo clear
	eststo: logit vote pid01 i.ideol econ01  i.gender i.race ///
		age01 educ01 income01 if nmiss == 0
		
*Proximity Model; AME of Proximity
eststo: logit vote defense80prox01 spend80prox01 abortion80prox01 blackaid80prox01 unemploy80prox01 ///
		jobs80prox01 russia80prox01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 if nmiss == 0
	
*Wald Test
	testparm defense80prox01 spend80prox01 abortion80prox01 blackaid80prox01 unemploy80prox01 ///
			jobs80prox01 russia80prox01

*Margins
	margins, dydx(*) saving(1980_allame, replace)

	margins, dydx(defense80prox01 spend80prox01 abortion80prox01 blackaid80prox01 unemploy80prox01 jobs80prox01 russia80prox01) ///
			saving(1980_proxame, replace)
		

*Table for Base and Proximity Models
	esttab using 1980_Base_Prox.rtf, replace se pr2 aic bic onecell ///
		star(+ 0.10 * 0.05 ** 0.01) label nobaselevels ///
		title({\b Table XX.} Base & Proximity Models - 1980 TS)

	eststo clear
	
*Interaction Models, Marginal Effects, and LR Tests
eststo clear
estimates clear
*Defense
eststo: logit vote c.defense80prox01##c.defense80imp_cat01 spend80prox01 abortion80prox01 blackaid80prox01 ///
	unemploy80prox01 jobs80prox01 russia80prox01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 

	*Wald Test
		testparm c.defense80imp_cat01 c.defense80prox01#c.defense80imp_cat01
	*Margins
		margins, dydx(defense80prox01) at(defense80imp_cat01=(0  .3333333  .6666667   1)) saving(1980_defense, replace) 
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Defense:1980, size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
		graph save "Defense1980", replace
	
	*Useing parmest to collect high/low statistics*
			margins if defense80imp_cat01 >=0 & defense80imp_cat01 <=0.35, dydx(defense80prox01)  post
			parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(def80_low.dta, replace)
			
			logit vote c.defense80prox01##c.defense80imp_cat01 spend80prox01 abortion80prox01 blackaid80prox01 ///
				unemploy80prox01 jobs80prox01 russia80prox01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 
					
			margins if defense80imp_cat01 >=0.36 & defense80imp_cat01 <=1, dydx(defense80prox01)  post
			parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(def80_high.dta, replace)
				
*Spend
eststo: logit vote defense80prox01 c.spend80prox01##c.spend80imp_cat01 abortion80prox01 blackaid80prox01 ///
		unemploy80prox01 jobs80prox01 russia80prox01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 

	*LR Test 
		testparm c.spend80imp_cat01 c.spend80prox01#c.spend80imp_cat01
	*Margins
		margins, dydx(spend80prox01) at(spend80imp_cat01=(0  .3333333  .6666667   1)) saving(1980_spend, replace)
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Spending:1980, size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
		graph save "Spend1980", replace
		
	*Using parmest to collect high/low statistics
		margins if spend80imp_cat01 >=0 & spend80imp_cat01 <=0.35, dydx(spend80prox01) post
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(spend80_low.dta, replace)

		logit vote defense80prox01 c.spend80prox01##c.spend80imp_cat01 abortion80prox01 blackaid80prox01 ///
		unemploy80prox01 jobs80prox01 russia80prox01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 
		
		margins if spend80imp_cat01 >=0.36 & spend80imp_cat01 <=1, dydx(spend80prox01) post
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(spend80_high.dta, replace)

*Abortion
	eststo: logit vote defense80prox01 spend80prox01 c.abortion80prox01##c.abortion80imp_cat01 blackaid80prox01 ///
		unemploy80prox01 jobs80prox01 russia80prox01 pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 
	
	*LR Test 
		testparm c.abortion80imp_cat01 c.abortion80prox01#c.abortion80imp_cat01
	*Margins
		margins, dydx(abortion80prox01) at(abortion80imp_cat01=(0  .3333333  .6666667   1)) saving(1980_abortion, replace)
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Abortion:1980, size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
		graph save "Abortion1980", replace
		
	*high/low
		margins if abortion80imp_cat01 >=0 & abortion80imp_cat01 <=0.35, dydx(abortion80prox01) post
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(abo80_low.dta, replace)

		logit vote defense80prox01 spend80prox01 c.abortion80prox01##c.abortion80imp_cat01 blackaid80prox01 ///
		unemploy80prox01 jobs80prox01 russia80prox01 pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 
	
		margins if abortion80imp_cat01 >=0.36 & abortion80imp_cat01 <=1, dydx(abortion80prox01) post
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(abo80_high.dta, replace)

		
*Aid to Blacks
	eststo: logit vote defense80prox01 spend80prox01 abortion80prox01 c.blackaid80prox01##c.blackaid80imp_cat01 ///
		unemploy80prox01 jobs80prox01 russia80prox01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 
	
	
	*Wald Test
		testparm c.blackaid80imp_cat01 c.blackaid80prox01#c.blackaid80imp_cat01
	*Margins
		margins, dydx(blackaid80prox01) at(blackaid80imp_cat01=(0  .3333333  .6666667   1)) saving(1980_blackaid, replace)
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Aid Blacks:1980, size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
		graph save "BlackAid1980", replace
		
	*high vs. low
		margins if blackaid80imp_cat01 >=0 & blackaid80imp_cat01 <=0.35, dydx(blackaid80prox01) post
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(aidblacks80_low.dta, replace)

		logit vote defense80prox01 spend80prox01 abortion80prox01 c.blackaid80prox01##c.blackaid80imp_cat01 ///
		unemploy80prox01 jobs80prox01 russia80prox01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 
	
		margins if blackaid80imp_cat01 >=0.36 & blackaid80imp_cat01 <=1, dydx(blackaid80prox01)  post
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(aidblacks80_high.dta, replace)


*Unemployment
	eststo: logit vote defense80prox01 spend80prox01 abortion80prox01 blackaid80prox01 ///
		c.unemploy80prox01##c.unemploy80imp_cat01 jobs80prox01 russia80prox01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income0
	
	*Wald Test 
		testparm c.unemploy80imp_cat01 c.unemploy80prox01#c.unemploy80imp_cat01
	*Margins
		margins, dydx(unemploy80prox01) at(unemploy80imp_cat01=(0  .3333333  .6666667   1)) saving(1980_unemploy, replace)
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Unemployment:1980, size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
		graph save "Unemploy1980", replace
	
	*high vs. low
		margins if unemploy80imp_cat01 >=0 & unemploy80imp_cat01 <=0.35, dydx(unemploy80prox01) post
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(unemploy80_low.dta, replace)
		
		logit vote defense80prox01 spend80prox01 abortion80prox01 blackaid80prox01 ///
		c.unemploy80prox01##c.unemploy80imp_cat01 jobs80prox01 russia80prox01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income0
	
		margins if unemploy80imp_cat01 >=0.36 & unemploy80imp_cat01 <=1, dydx(unemploy80prox01) post
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(unemploy80_high.dta, replace)


*Jobs
	eststo: logit vote defense80prox01 spend80prox01 abortion80prox01 blackaid80prox01 unemploy80prox01 ///
		c.jobs80prox01##c.jobs80imp_cat01 russia80prox01 pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 

	*LR Test 
		testparm c.jobs80imp_cat01 c.jobs80prox01#c.jobs80imp_cat01
		
	*Margins
		margins, dydx(jobs80prox01) at(jobs80imp_cat01=(0  .3333333  .6666667   1)) saving(1980_jobs, replace)
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Jobs:1980, size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
		graph save "Jobs1980", replace
		
	*high vs. low
		margins if jobs80imp_cat01 >=0 & jobs80imp_cat01 <=0.35, dydx(jobs80prox01) post
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(jobs80_low.dta, replace)

		logit vote defense80prox01 spend80prox01 abortion80prox01 blackaid80prox01 unemploy80prox01 ///
		c.jobs80prox01##c.jobs80imp_cat01 russia80prox01 pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 

		margins if jobs80imp_cat01 >=0.36 & jobs80imp_cat01 <=1, dydx(jobs80prox01) post
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(jobs80_high.dta, replace)

*Russia
	eststo: logit vote defense80prox01 spend80prox01 abortion80prox01 blackaid80prox01 unemploy80prox01 jobs80prox01 ///
		c.russia80prox01##c.russia80imp_cat01 pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 


	*LR Test 
		testparm c.russia80imp_cat01 c.russia80prox01#c.russia80imp_cat01
	*Margins
		margins, dydx(russia80prox01) at(russia80imp_cat01=(0  .3333333  .6666667   1)) saving(1980_russia, replace)
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Russia:1980, size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
		graph save "Russia1980", replace
		
	*high vs. low
		margins if russia80imp_cat01 >=0 & russia80imp_cat01 <=0.35, dydx(russia80prox01) post
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(russia80_low.dta, replace)

		logit vote defense80prox01 spend80prox01 abortion80prox01 blackaid80prox01 unemploy80prox01 jobs80prox01 ///
		c.russia80prox01##c.russia80imp_cat01 pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 

		margins if russia80imp_cat01 >=0.36 & russia80imp_cat01 <=1, dydx(russia80prox01) post
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(russia80_high.dta, replace)

*Big ugly table
esttab using 1980_Interactions.rtf, replace se pr2 aic bic onecell ///
		star(+ 0.10 * 0.05 ** 0.01) label nobaselevels ///
		title({\b Table XX.} Subjective Importance and Proximity Voting - 1980 TS)
eststo clear
	

capture log close


		
					***********************************
					***********************************
					***********************************
					***********1984 ANES TS************
					***********************************
					***********************************
					***********************************

clear

/********Data Cleaning*****/
	do "Data Cleaning - 1984 ANES TS.do"
	set more off
	log using anes1984.log, replace
		
		
/**************************
All interactions at once
**************************/		
		
	
eststo clear
eststo: logit vote pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 
eststo: logit vote spend84prox01 jobs84prox01 central84prox01 women84prox01 pid01 ///
		i.ideol econ01  i.gender i.race age01 educ01 income01 
eststo: logit vote c.spend84prox01##c.spend84imp01 c.jobs84prox01##c.jobs84imp01 c.central84prox01##c.central84imp01 ///
		c.women84prox01##c.women84imp01 pid01 i.ideol econ01 i.gender i.race age01 educ01 income01 
	
*Wald Test
testparm  c.spend84imp01 c.spend84prox01#c.spend84imp01 ///
	c.jobs84imp01 c.jobs84prox01#c.jobs84imp01 ///
	c.central84imp01 c.central84prox01#c.central84imp01 ///
	c.women84imp01 c.women84prox01#c.women84imp01 
					
*Margins

	margins, dydx(spend84prox01) at(spend84imp01=(0  .3333333  .6666667   1))  saving(1984ALL_spend, replace)
	marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Spend:1984, size(medsmall)) scheme(s1mono) ///
	yline(0, lpattern(dash))
	graph save "Spend1984ALL", replace

	margins, dydx(jobs84prox01) at(jobs84imp01=(0  .3333333  .6666667   1))  saving(1984ALL_jobs, replace)
	marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Jobs:1984, size(medsmall)) scheme(s1mono) ///
	yline(0, lpattern(dash))
	graph save "Jobs1984ALL", replace
	
	margins, dydx(central84prox01) at(central84imp01=(0  .3333333  .6666667   1))  saving(1984ALL_central, replace)
	marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(C.America:1984, size(medsmall)) scheme(s1mono) ///
	yline(0, lpattern(dash))
	graph save "Central1984ALL", replace

	margins, dydx(women84prox01) at(women84imp01=(0  .3333333  .6666667   1))  saving(1984ALL_women, replace)
	marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Women:1984, size(medsmall)) scheme(s1mono) ///
	yline(0, lpattern(dash))
	graph save "Women1984ALL", replace
											
*high vs low comparisons						

*spending
	margins if spend84imp01 >=0 & spend84imp01 <=0.35, dydx(spend84prox01) post
	parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(spend84_lowALL.dta, replace)

	logit vote c.spend84prox01##c.spend84imp01 c.jobs84prox01##c.jobs84imp01 c.central84prox01##c.central84imp01 ///
	c.women84prox01##c.women84imp01 pid01 i.ideol econ01 i.gender i.race age01 educ01 income01 

	margins if spend84imp01 >=0.36 & spend84imp01 <=1, dydx(spend84prox01) post
	parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(spend84_highALL.dta, replace)

						
*jobs

	logit vote c.spend84prox01##c.spend84imp01 c.jobs84prox01##c.jobs84imp01 c.central84prox01##c.central84imp01 ///
c.women84prox01##c.women84imp01 pid01 i.ideol econ01 i.gender i.race age01 educ01 income01 

	margins if jobs84imp01 >=0 & jobs84imp01 <=0.35, dydx(jobs84prox01) post
	parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(jobs84_lowALL.dta, replace)

	logit vote c.spend84prox01##c.spend84imp01 c.jobs84prox01##c.jobs84imp01 c.central84prox01##c.central84imp01 ///
c.women84prox01##c.women84imp01 pid01 i.ideol econ01 i.gender i.race age01 educ01 income01 


	margins if jobs84imp01 >=0.36 & jobs84imp01 <=1, dydx(jobs84prox01) post
	parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(jobs84_highALL.dta, replace)

*central
	logit vote c.spend84prox01##c.spend84imp01 c.jobs84prox01##c.jobs84imp01 c.central84prox01##c.central84imp01 ///
	c.women84prox01##c.women84imp01 pid01 i.ideol econ01 i.gender i.race age01 educ01 income01 

	margins if central84imp01 >=0 & central84imp01 <=0.35, dydx(central84prox01) post
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(central84_lowALL.dta, replace)

		logit vote c.spend84prox01##c.spend84imp01 c.jobs84prox01##c.jobs84imp01 c.central84prox01##c.central84imp01 ///
	c.women84prox01##c.women84imp01 pid01 i.ideol econ01 i.gender i.race age01 educ01 income01 


		margins if central84imp01 >=0.36 & central84imp01 <=1, dydx(central84prox01) post
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(central84_highALL.dta, replace)
		
*women

logit vote c.spend84prox01##c.spend84imp01 c.jobs84prox01##c.jobs84imp01 c.central84prox01##c.central84imp01 ///
	c.women84prox01##c.women84imp01 pid01 i.ideol econ01 i.gender i.race age01 educ01 income01 

margins if women84imp01 >=0 & women84imp01 <=0.35, dydx(women84prox01) post
	parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(women84_lowALL.dta, replace)


logit vote c.spend84prox01##c.spend84imp01 c.jobs84prox01##c.jobs84imp01 c.central84prox01##c.central84imp01 ///
	c.women84prox01##c.women84imp01 pid01 i.ideol econ01 i.gender i.race age01 educ01 income01 

	margins if women84imp01 >=0.36 & women84imp01 <=1, dydx(women84prox01) post
	parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(women84_highALL.dta, replace)


/***Table***/
esttab using 1984_Interactions_ALL.rtf, replace se pr2 aic bic onecell ///
	star(+ 0.10 * 0.05 ** 0.01) label nobaselevels ///
	title({\b Table XX.} Subjective Importance and Proximity Voting - 1984 TS)

eststo clear	
			
		
/**************************
One at a time
**************************/				

*Missing Variables
		egen nmis = rowmiss(pid01 ideol econ01  gender race age01 educ01 income01 ///
			spend84prox01 jobs84prox01 central84prox01 women84prox01)
				
*Base Model vs. Proximity Model
	estimates clear
	eststo clear
	eststo: logit vote pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 if nmis == 0
	eststo: logit vote spend84prox01 jobs84prox01 central84prox01 women84prox01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 if nmis == 0
		
	*Wald Test
		testparm spend84prox01 jobs84prox01 central84prox01 women84prox01

	*Margins
	margins, dydx(spend84prox01 jobs84prox01 central84prox01 women84prox01) saving(1984_proxame, replace)
	margins, dydx(*) saving(1984_allame, replace)

	/*Table*/	
	esttab using 1984_Base_Prox.rtf, replace se pr2 aic bic onecell ///
			star(+ 0.10 * 0.05 ** 0.01) label nobaselevels ///
			title({\b Table XX.} Base & Proximity Models - 1984 TS)
	eststo clear
	estimates clear
			
*Interaction Models
	*Spend
		eststo clear
		eststo: logit vote c.spend84prox01##c.spend84imp01 jobs84prox01 central84prox01 women84prox01 pid01 i.ideol ///
				econ01  i.gender i.race age01 educ01 income01
			
			*Test Parm
				testparm c.spend84imp01 c.spend84prox01#c.spend84imp01
			
			*Margins
				margins, dydx(spend84prox01) at(spend84imp01=(0  .3333333  .6666667   1))  saving(1984_spend, replace)
				marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Spend:1984, size(medsmall)) scheme(s1mono) ///
				yline(0, lpattern(dash))
				graph save "Spend1984", replace
					
				*High vs. low
				margins if spend84imp01 >=0 & spend84imp01 <=0.35, dydx(spend84prox01) post
				parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(spend84_low.dta, replace)

				
				logit vote c.spend84prox01##c.spend84imp01 jobs84prox01 central84prox01 women84prox01 pid01 i.ideol ///
				econ01  i.gender i.race age01 educ01 income01
				margins if spend84imp01 >=0.36 & spend84imp01 <=1, dydx(spend84prox01) post
				parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(spend84_high.dta, replace)

	*Jobs
		eststo: logit vote spend84prox01 c.jobs84prox01##c.jobs84imp01 central84prox01 women84prox01 ///
			pid01 i.ideol econ01  i.gender i.race age01 educ01 income01
	
	
			*LR Test
				testparm c.jobs84imp01 c.jobs84prox01#c.jobs84imp01
		
			*Margins
				margins, dydx(jobs84prox01) at(jobs84imp01=(0  .3333333  .6666667   1))  saving(1984_jobs, replace)
				marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Jobs:1984, size(medsmall)) scheme(s1mono) ///
				yline(0, lpattern(dash))
				graph save "Jobs1984", replace
			
			*high vs. low
				margins if jobs84imp01 >=0 & jobs84imp01 <=0.35, dydx(jobs84prox01) post
				parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(jobs84_low.dta, replace)

				logit vote spend84prox01 c.jobs84prox01##c.jobs84imp01 central84prox01 women84prox01 ///
				pid01 i.ideol econ01  i.gender i.race age01 educ01 income01
	
				margins if jobs84imp01 >=0.36 & jobs84imp01 <=1, dydx(jobs84prox01) post
				parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(jobs84_high.dta, replace)

	*Central		
		eststo: logit vote spend84prox01 c.jobs84prox01 c.central84prox01##c.central84imp01 women84prox01 ///
		pid01 i.ideol econ01 i.gender i.race age01 educ01 income01
				
			*LR Test
				testparm c.central84imp01 c.central84prox01#c.central84imp01
	
		
			*Margins
				margins, dydx(central84prox01) at(central84imp01=(0  .3333333  .6666667   1))  saving(1984_central, replace)
				marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(C.America:1984, size(medsmall)) scheme(s1mono) ///
				yline(0, lpattern(dash))
				graph save "Central1984", replace
					
			*high vs. low
				margins if central84imp01 >=0 & central84imp01 <=0.35, dydx(central84prox01) post
				parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(central84_low.dta, replace)

				
				logit vote spend84prox01 c.jobs84prox01 c.central84prox01##c.central84imp01 women84prox01 ///
				pid01 i.ideol econ01 i.gender i.race age01 educ01 income01
		
				margins if central84imp01 >=0.36 & central84imp01 <=1, dydx(central84prox01) post
				parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(central84_high.dta, replace)
	
	*Women
		eststo: logit vote spend84prox01 c.jobs84prox01 c.central84prox01 c.women84prox01##c.women84imp01  ///
			pid01 i.ideol econ01 i.gender i.race age01 educ01 income01 
		
			*LR Test
				testparm c.women84imp01 c.women84prox01#c.women84imp01
		
			*Margins
				margins, dydx(women84prox01) at(women84imp01=(0  .3333333  .6666667   1))  saving(1984_women, replace)
				marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Women:1984, size(medsmall)) scheme(s1mono) ///
				yline(0, lpattern(dash))
				graph save "Women1984", replace
					
					
			*High vs. low
				margins if women84imp01 >=0 & women84imp01 <=0.35, dydx(women84prox01) saving(1984womenlow, replace)
				parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(women84_low.dta, replace)

				logit vote spend84prox01 c.jobs84prox01 c.central84prox01 c.women84prox01##c.women84imp01  ///
				pid01 i.ideol econ01 i.gender i.race age01 educ01 income01 
				margins if women84imp01 >=0.36 & women84imp01 <=1, dydx(women84prox01) post
				parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(women84_high.dta, replace) 
				
*Table
esttab using 1984_Interactions.rtf, replace se pr2 aic bic onecell ///
	star(+ 0.10 * 0.05 ** 0.01) label nobaselevels ///
	title({\b Table XX.} Subjective Importance and Proximity Voting - 1984 TS)

eststo clear
				
			
			
capture log close
		
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
log using anes1996.log, replace
	
/***********************
All interactions at once
***********************/

eststo clear
eststo: logit vote pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 if nmis == 0 [pweight=V960003]
eststo: logit vote spend96prox01 defense96prox01 blackaid96prox01 abortion96prox01 enviro96prox01 pid01 ///
	i.ideol econ01  i.gender i.race  age01 educ01 income01 if nmis == 0 [pweight=V960003]
eststo: logit vote c.spend96prox01##c.spend96imp01 c.defense96prox01##c.defense96imp01 c.blackaid96prox01##c.blackaid96imp01 ///
	c.abortion96prox01##c.abortion96imp01 c.enviro96prox01##c.enviro96imp01  ///
	pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01  [pweight=V960003]

*Wald Test
testparm c.spend96imp01 c.spend96prox01#c.spend96imp01 c.defense96imp01 c.defense96prox01#c.defense96imp01 c.blackaid96imp01 c.blackaid96prox01#c.blackaid96imp01 ///
	c.abortion96imp01 c.abortion96prox01#c.abortion96imp01 c.enviro96imp01 c.enviro96prox01#c.enviro96imp01

*Margins
margins, dydx(spend96prox01) at(spend96imp01=(0(0.25)1))  saving(1996ALL_spend, replace)
						marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Spend:1996, size(medsmall)) scheme(s1mono) ///
						yline(0, lpattern(dash))
						graph save "Spend1996ALL", replace
											
margins, dydx(defense96prox01) at(defense96imp01=(0(0.25)1))  saving(1996ALL_defense, replace)
						marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Defense:1996, size(medsmall)) scheme(s1mono) ///
						yline(0, lpattern(dash))
						graph save "Defense1996ALL", replace

											
margins, dydx(blackaid96prox01) at(blackaid96imp01=(0(0.25)1))  saving(1996ALL_blackaid, replace)
						marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Aid Blacks:1996, size(medsmall)) scheme(s1mono) ///
						yline(0, lpattern(dash))
						graph save "Aid Blacks1996ALL", replace


margins, dydx(abortion96prox01) at(abortion96imp01=(0(0.25)1))  saving(1996ALL_abortion, replace)
						marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Abortion:1996, size(medsmall)) scheme(s1mono) ///
						yline(0, lpattern(dash))
						graph save "Abortion1996ALL", replace


	margins, dydx(enviro96prox01) at(enviro96imp01=(0(0.25)1))  saving(1996ALL_enviro, replace)
						marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Enviro:1996, size(medsmall)) scheme(s1mono) ///
						yline(0, lpattern(dash))
						graph save "Enviro1996ALL", replace

/**comparing high vs low**/			
											
*spending
logit vote c.spend96prox01##c.spend96imp01 c.defense96prox01##c.defense96imp01 c.blackaid96prox01##c.blackaid96imp01 ///
	c.abortion96prox01##c.abortion96imp01 c.enviro96prox01##c.enviro96imp01  ///
	pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01  [pweight=V960003]

	margins if spend96imp01 >=0 & spend96imp01 <=0.5, dydx(spend96prox01) post
	parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(spend96_lowALL.dta, replace)

	
	logit vote c.spend96prox01##c.spend96imp01 c.defense96prox01##c.defense96imp01 c.blackaid96prox01##c.blackaid96imp01 ///
	c.abortion96prox01##c.abortion96imp01 c.enviro96prox01##c.enviro96imp01  ///
	pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01  [pweight=V960003]


	margins if spend96imp01 ==1, dydx(spend96prox01) post
	parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(spend96_highALL.dta, replace)

*defense
	logit vote c.spend96prox01##c.spend96imp01 c.defense96prox01##c.defense96imp01 c.blackaid96prox01##c.blackaid96imp01 ///
	c.abortion96prox01##c.abortion96imp01 c.enviro96prox01##c.enviro96imp01  ///
	pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01  [pweight=V960003]

	margins if defense96imp01 >=0 & defense96imp01 <=0.5, dydx(defense96prox01) post
	parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(defense96_lowALL.dta, replace)

	
	logit vote c.spend96prox01##c.spend96imp01 c.defense96prox01##c.defense96imp01 c.blackaid96prox01##c.blackaid96imp01 ///
	c.abortion96prox01##c.abortion96imp01 c.enviro96prox01##c.enviro96imp01  ///
	pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01  [pweight=V960003]


	margins if defense96imp01 ==1, dydx(defense96prox01) post
	parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(defense96_highALL.dta, replace)


*aid to blacks
	logit vote c.spend96prox01##c.spend96imp01 c.defense96prox01##c.defense96imp01 c.blackaid96prox01##c.blackaid96imp01 ///
	c.abortion96prox01##c.abortion96imp01 c.enviro96prox01##c.enviro96imp01  ///
	pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01  [pweight=V960003]

	margins if blackaid96imp01 >=0 & blackaid96imp01 <=0.5, dydx(blackaid96prox01) post
	parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(aidblacks96_lowALL.dta, replace)

	
	logit vote c.spend96prox01##c.spend96imp01 c.defense96prox01##c.defense96imp01 c.blackaid96prox01##c.blackaid96imp01 ///
	c.abortion96prox01##c.abortion96imp01 c.enviro96prox01##c.enviro96imp01  ///
	pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01  [pweight=V960003]

	margins if blackaid96imp01 ==1, dydx(blackaid96prox01) post 
	parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(aidblacks96_highALL.dta, replace)


*abortion
	logit vote c.spend96prox01##c.spend96imp01 c.defense96prox01##c.defense96imp01 c.blackaid96prox01##c.blackaid96imp01 ///
	c.abortion96prox01##c.abortion96imp01 c.enviro96prox01##c.enviro96imp01  ///
	pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01  [pweight=V960003]

	margins if abortion96imp01 >=0 & abortion96imp01 <=0.5, dydx(abortion96prox01) post
	parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(abo96_lowALL.dta, replace)

	logit vote c.spend96prox01##c.spend96imp01 c.defense96prox01##c.defense96imp01 c.blackaid96prox01##c.blackaid96imp01 ///
	c.abortion96prox01##c.abortion96imp01 c.enviro96prox01##c.enviro96imp01  ///
	pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01  [pweight=V960003]


	margins if abortion96imp01 ==1, dydx(abortion96prox01) post
	parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(abo96_highALL.dta, replace)
	
*environment
	logit vote c.spend96prox01##c.spend96imp01 c.defense96prox01##c.defense96imp01 c.blackaid96prox01##c.blackaid96imp01 ///
	c.abortion96prox01##c.abortion96imp01 c.enviro96prox01##c.enviro96imp01  ///
	pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01  [pweight=V960003]

	margins if enviro96imp01 >=0 & enviro96imp01 <=0.5, dydx(enviro96prox01) post
	parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(enviro96_lowALL.dta, replace)

	
	logit vote c.spend96prox01##c.spend96imp01 c.defense96prox01##c.defense96imp01 c.blackaid96prox01##c.blackaid96imp01 ///
	c.abortion96prox01##c.abortion96imp01 c.enviro96prox01##c.enviro96imp01  ///
	pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01  [pweight=V960003]

	margins if enviro96imp01 ==1, dydx(enviro96prox01) post
	parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(enviro96_highALL.dta, replace)			

*Table
esttab using 1996_Interactions_ALL.rtf, replace se pr2 aic bic onecell ///
	star(+ 0.10 * 0.05 ** 0.01) label nobaselevels ///
	title({\b Table XX.} Subjective Importance and Proximity Voting - 1996 TS)

	eststo clear	

/*******************
One by One
*******************/

*missing
egen nmis = rowmiss(pid01 ideol econ01  gender race  age01 educ01 income01 ///
	spend96prox01 defense96prox01 blackaid96prox01 abortion96prox01 enviro96prox01)
	
set more off
/***Base Model vs. Proximity Models***/
	estimates clear
	eststo clear
	eststo: logit vote pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 if nmis == 0 [pweight=V960003]
	eststo: logit vote spend96prox01 defense96prox01 blackaid96prox01 abortion96prox01 enviro96prox01 pid01 ///
		i.ideol econ01  i.gender i.race  age01 educ01 income01 if nmis == 0 [pweight=V960003]
		margins, dydx( spend96prox01 defense96prox01 blackaid96prox01 abortion96prox01 enviro96prox01) saving(1996_proxame, replace)
		margins, dydx(*) saving(1996_allame, replace)
		
	*Wald Test
	test  spend96prox01 defense96prox01 blackaid96prox01 abortion96prox01 enviro96prox01
	
	*Table
	esttab using 1996_Base_Prox.rtf, replace se pr2 aic bic onecell ///
				star(+ 0.10 * 0.05 ** 0.01) label nobaselevels addnote(Results are weighted:V960003) ///
		title({\b Table XX.} Base and Proximity Models - 1996 TS)

	eststo clear
	estimates clear
		
/***Interaction Models**/
*Spend
	eststo clear
	estimates clear
	eststo: logit vote c.spend96prox01##c.spend96imp01 c.defense96prox01 c.blackaid96prox01 c.abortion96prox01 ///
		c.enviro96prox01 pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01  [pweight=V960003]
		
		testparm c.spend96imp01 c.spend96prox01#c.spend96imp01
		
		*Margins
			margins, dydx(spend96prox01) at(spend96imp01=(0(0.25)1))  saving(1996_spend, replace)
			marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Spend:1996, size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
			graph save "Spend1996", replace
		
		*High vs. Low		
			margins if spend96imp01 >=0 & spend96imp01 <=0.5, dydx(spend96prox01) post
			parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(spend96_low.dta, replace)

			
			logit vote c.spend96prox01##c.spend96imp01 c.defense96prox01 c.blackaid96prox01 c.abortion96prox01 ///
				c.enviro96prox01 pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01  [pweight=V960003]
		
			margins if spend96imp01 ==1, dydx(spend96prox01) post
			parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(spend96_high.dta, replace)
			
*Defense
		eststo: logit vote c.spend96prox01 c.defense96prox01##c.defense96imp01 c.blackaid96prox01 c.abortion96prox01 c.enviro96prox01 ///
			pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 [pweight=V960003]
	
		testparm  c.defense96imp01 c.defense96prox01#c.defense96imp01
	
		*Margins
			margins, dydx(defense96prox01) at(defense96imp01=(0(0.25)1))  saving(1996_defense, replace)
			marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Defense:1996, size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
			graph save "Defense1996", replace
			
		*high vs. low
			margins if defense96imp01 >=0 & defense96imp01 <=0.5, dydx(defense96prox01) post
			parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(defense96_low.dta, replace)

			
			logit vote c.spend96prox01 c.defense96prox01##c.defense96imp01 c.blackaid96prox01 c.abortion96prox01 c.enviro96prox01 ///
			pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 [pweight=V960003]
	
			margins if defense96imp01 ==1, dydx(defense96prox01) post
			parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(defense96_high.dta, replace)

*Aid to Blacks
		eststo: logit vote c.spend96prox01 c.defense96prox01 c.blackaid96prox01##c.blackaid96imp01 c.abortion96prox01 c.enviro96prox01 ///
			pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01  [pweight=V960003]
		
		testparm c.blackaid96imp01 c.blackaid96prox01#c.blackaid96imp01 
		
		*Margins
			margins, dydx(blackaid96prox01) at(blackaid96imp01=(0(0.25)1))  saving(1996_blackaid, replace)
			marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Aid Blacks:1996, size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
			graph save "Aid Blacks1996", replace
								
								
			*High vs. low
			margins if blackaid96imp01 >=0 & blackaid96imp01 <=0.5, dydx(blackaid96prox01) post
			parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(aidblacks96_low.dta, replace)

			
			logit vote c.spend96prox01 c.defense96prox01 c.blackaid96prox01##c.blackaid96imp01 c.abortion96prox01 c.enviro96prox01 ///
			pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01  [pweight=V960003]
			margins if blackaid96imp01 ==1, dydx(blackaid96prox01) post 
			parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(aidblacks96_high.dta, replace)

*Abortion
		eststo: logit vote c.spend96prox01 c.defense96prox01 c.blackaid96prox01 c.abortion96prox01##c.abortion96imp01 c.enviro96prox01 ///
			pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01  [pweight=V960003]
		
		testparm c.abortion96imp01 c.abortion96prox01#c.abortion96imp01
	
		*Margins
			margins, dydx(abortion96prox01) at(abortion96imp01=(0(0.25)1))  saving(1996_abortion, replace)
			marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Abortion:1996, size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
			graph save "Abortion1996", replace
				
		*High vs. low
			margins if abortion96imp01 >=0 & abortion96imp01 <=0.5, dydx(abortion96prox01) post
			parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(abo96_low.dta, replace)

			logit vote c.spend96prox01 c.defense96prox01 c.blackaid96prox01 c.abortion96prox01##c.abortion96imp01 c.enviro96prox01 ///
			pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01  [pweight=V960003]
		
			margins if abortion96imp01 ==1, dydx(abortion96prox01) post
			parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(abo96_high.dta, replace)

*Environment
		eststo: logit vote c.spend96prox01 c.defense96prox01 c.blackaid96prox01 c.abortion96prox01 c.enviro96prox01##c.enviro96imp01  ///
			pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01  [pweight=V960003]
		
		testparm c.enviro96imp01 c.enviro96prox01#c.enviro96imp01
		
		
		*Margins
			margins, dydx(enviro96prox01) at(enviro96imp01=(0(0.25)1))  saving(1996_enviro, replace)
			marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Enviro:1996, size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
			graph save "Enviro1996", replace
				
		*High vs. low
			margins if enviro96imp01 >=0 & enviro96imp01 <=0.5, dydx(enviro96prox01) post
			parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(enviro96_low.dta, replace)

			
			logit vote c.spend96prox01 c.defense96prox01 c.blackaid96prox01 c.abortion96prox01##c.abortion96imp01 c.enviro96prox01 ///
			pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01  [pweight=V960003]
			margins if enviro96imp01 ==1, dydx(enviro96prox01) post
			parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(enviro96_high.dta, replace)

											
*Table
esttab using 1996_Interactions.rtf, replace se pr2 aic bic onecell ///
		star(+ 0.10 * 0.05 ** 0.01) label nobaselevels addnote(Results are weighted:V960003) ///
		title({\b Table XX.} Subjective Importance and Proximity Voting - 1996 TS)

eststo clear
		

		
capture log close
			
		
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
	log using anes2000.log, replace
	set more off
	
/********************
All interactions at
once
********************/

eststo clear
eststo clear
eststo: logit vote pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 [pweight = V000002a]
eststo: logit vote abortion2000prox01 guns2000prox01 regulation2000prox01 pid01 i.ideol econ01 ///
		i.gender i.race age01 educ01 income01  [pweight = V000002a]
eststo: logit vote c.abortion2000prox01##c.abortion2000imp01 c.guns2000prox01##c.guns2000imp01 c.regulation2000prox01##c.regulation2000imp01 pid01 i.ideol econ01 ///
	i.gender i.race  age01 educ01 income01  [pweight = V000002]
	

*Wald tests
testparm c.abortion2000imp01 c.abortion2000prox01#c.abortion2000imp01 c.guns2000imp01 c.guns2000prox01#c.guns2000imp01	c.regulation2000imp01 c.regulation2000prox01#c.regulation2000imp01
					
*Interactions
	margins, dydx(abortion2000prox01) at(abortion2000imp01=(0(0.25)1)) saving(2000_abortionALL, replace)
	
	marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Abortion:2000, size(medsmall)) scheme(s1mono) ///
	yline(0, lpattern(dash))
	graph save "Abortion2000(ALL)", replace
	
	margins, dydx(guns2000prox01) at(guns2000imp01=(0(0.25)1)) saving(2000_gunsALL, replace)
	
	marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Guns:2000, size(medsmall)) scheme(s1mono) ///
	yline(0, lpattern(dash))
	graph save "Guns2000(ALL)", replace

	margins, dydx(regulation2000prox01) at(regulation2000imp01=(0(0.25)1)) saving(2000_regulationALL, replace)
	
	marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Env.Regulation:2000, size(medsmall)) scheme(s1mono) ///
	yline(0, lpattern(dash))
	graph save "Env.Regulation2000(ALL)", replace
						
*Comparing High vs. Low
							
*abortion
logit vote c.abortion2000prox01##c.abortion2000imp01 c.guns2000prox01##c.guns2000imp01 c.regulation2000prox01##c.regulation2000imp01 pid01 i.ideol econ01 ///
i.gender i.race  age01 educ01 income01  [pweight = V000002]


margins if abortion2000imp01 >=0 & abortion2000imp01 <=0.5, dydx(abortion2000prox01) post 
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(abo00_lowALL.dta, replace)

logit vote c.abortion2000prox01##c.abortion2000imp01 c.guns2000prox01##c.guns2000imp01 c.regulation2000prox01##c.regulation2000imp01 pid01 i.ideol econ01 ///
i.gender i.race  age01 educ01 income01  [pweight = V000002]

margins if abortion2000imp01 ==1, dydx(abortion2000prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(abo00_highALL.dta, replace)


*guns
logit vote c.abortion2000prox01##c.abortion2000imp01 c.guns2000prox01##c.guns2000imp01 c.regulation2000prox01##c.regulation2000imp01 pid01 i.ideol econ01 ///
i.gender i.race  age01 educ01 income01  [pweight = V000002]


margins if guns2000imp01 >=0 & guns2000imp01 <=0.5, dydx(guns2000prox01) post 
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(guns00_lowALL.dta, replace)

logit vote c.abortion2000prox01##c.abortion2000imp01 c.guns2000prox01##c.guns2000imp01 c.regulation2000prox01##c.regulation2000imp01 pid01 i.ideol econ01 ///
i.gender i.race  age01 educ01 income01  [pweight = V000002]

margins if guns2000imp01 ==1, dydx(guns2000prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(guns00_highALL.dta, replace)


*regulation
logit vote c.abortion2000prox01##c.abortion2000imp01 c.guns2000prox01##c.guns2000imp01 c.regulation2000prox01##c.regulation2000imp01 pid01 i.ideol econ01 ///
i.gender i.race  age01 educ01 income01  [pweight = V000002]

margins if regulation2000imp01 >=0 & regulation2000imp01 <=0.25, dydx(regulation2000prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(reg00_lowALL.dta, replace)


logit vote c.abortion2000prox01##c.abortion2000imp01 c.guns2000prox01##c.guns2000imp01 c.regulation2000prox01##c.regulation2000imp01 pid01 i.ideol econ01 ///
i.gender i.race  age01 educ01 income01  [pweight = V000002]

margins if regulation2000imp01 >=0.75 & regulation2000imp01 <= 1, dydx(regulation2000prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(reg00_highALL.dta, replace)

*Table

		esttab using 2000_Interactions_ALL.rtf, replace se pr2 aic bic onecell ///
				star(+ 0.10 * 0.05 ** 0.01) label nobaselevels addnote(Results are weighted:V000002a) ///
				title({\b Table XX.} Subjective Imporance and Proximity Voting - 2000TS)
		eststo clear
	
	
	
/*********************
One by One
*********************/
	
*Missing Variables
egen nmis = rowmiss(pid01 ideol econ01  gender race age01 educ01 income01 ///	
				abortion2000prox01 guns2000prox01 regulation2000prox01)


set more off
*Base Model vs. Proximity
	eststo clear
	eststo: logit vote pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 if nmis == 0 [pweight = V000002a]
	eststo: logit vote abortion2000prox01 guns2000prox01 regulation2000prox01 pid01 i.ideol econ01 ///
		i.gender i.race age01 educ01 income01 if nmis == 0 [pweight = V000002a]
		
		testparm abortion2000prox01 guns2000prox01 regulation2000prox01
		margins, dydx( abortion2000prox01 guns2000prox01 regulation2000prox01 ) saving(2000_proxame, replace)
		margins, dydx(*) saving(2000_allame, replace)
	esttab using 2000_Base_Prox.rtf, replace se pr2 aic bic onecell ///
				star(+ 0.10 * 0.05 ** 0.01) label nobaselevels addnote(Results are weighted:V000002a) ///
				title({\b Table XX} Base and Proximity Model - 2000 TS)
	eststo clear
	estimates clear
		
*Interaction Models*
*Abortion
	eststo clear
	eststo: logit vote c.abortion2000prox01##c.abortion2000imp01 c.guns2000prox01 c.regulation2000prox01 pid01 i.ideol econ01 ///
		i.gender i.race age01 educ01 income01  [pweight = V000002a]
		
		*Wald Test
		testparm c.abortion2000imp01 c.abortion2000prox01#c.abortion2000imp01
		
		*Margins
			margins, dydx(abortion2000prox01) at(abortion2000imp01=(0(0.25)1)) saving(2000_abortion, replace)
			
			marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Abortion:2000, size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
			graph save "Abortion2000", replace
				
			*High vs. Low
			margins if abortion2000imp01 >=0 & abortion2000imp01 <=0.5, dydx(abortion2000prox01) post 
			parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(abo00_low.dta, replace)

			logit vote c.abortion2000prox01##c.abortion2000imp01 c.guns2000prox01 c.regulation2000prox01 pid01 i.ideol econ01 ///
			i.gender i.race age01 educ01 income01  [pweight = V000002a]
			margins if abortion2000imp01 ==1, dydx(abortion2000prox01) post
			parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(abo00_high.dta, replace)


*Guns
	eststo: logit vote c.abortion2000prox01 c.guns2000prox01##c.guns2000imp01 c.regulation2000prox01 pid01 i.ideol econ01 ///
		i.gender i.race age01 educ01 income01  [pweight = V000002a]
		
		*Wald Test
		testparm c.guns2000imp01 c.guns2000prox01#c.guns2000imp01
		
		*Margins
			margins, dydx(guns2000prox01) at(guns2000imp01=(0(0.25)1)) saving(2000_guns, replace)
			
			marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Guns:2000, size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
			graph save "Guns2000", replace
			
			*high vs. low
			margins if guns2000imp01 >=0 & guns2000imp01 <=0.5, dydx(guns2000prox01) post 
			parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(guns00_low.dta, replace)

			logit vote c.abortion2000prox01 c.guns2000prox01##c.guns2000imp01 c.regulation2000prox01 pid01 i.ideol econ01 ///
				i.gender i.race age01 educ01 income01  [pweight = V000002a]
			margins if guns2000imp01 ==1, dydx(guns2000prox01) post
			parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(guns00_high.dta, replace)


*Regulation
	eststo: logit vote c.abortion2000prox01 c.guns2000prox01 c.regulation2000prox01##c.regulation2000imp01 pid01 i.ideol econ01 ///
		i.gender i.race  age01 educ01 income01  [pweight = V000002a]
		
		*Wald Test
		testparm c.regulation2000imp01 c.regulation2000prox01#c.regulation2000imp01
		
		*Margins
			margins, dydx(regulation2000prox01) at(regulation2000imp01=(0(0.25)1)) saving(2000_regulation, replace)
			
			marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Env.Regulation:2000, size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
			graph save "Env.Regulation2000", replace
			
		*High vs. low
			margins if regulation2000imp01 >=0 & regulation2000imp01 <=0.25, dydx(regulation2000prox01) post
			parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(reg00_low.dta, replace)

			
			logit vote c.abortion2000prox01 c.guns2000prox01 c.regulation2000prox01##c.regulation2000imp01 pid01 i.ideol econ01 ///
				i.gender i.race  age01 educ01 income01  [pweight = V000002a]
			margins if regulation2000imp01 >=0.75 & regulation2000imp01 <= 1, dydx(regulation2000prox01) post
			parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(reg00_high.dta, replace)


*Table
esttab using 2000_Interactions.rtf, replace se pr2 aic bic onecell ///
		star(+ 0.10 * 0.05 ** 0.01) label nobaselevels addnote(Results are weighted:V000002a) ///
		title({\b Table XX} - Subjective Importance and Proximity Voting - 2000TS)
eststo clear

				
capture log close
			
		
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
	log using anes2004.log, replace

	
/*********************
All interactions 
at once
*********************/

eststo clear
eststo: logit vote pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 [pweight = V040102	]
eststo: logit vote defense2004prox01 spend2004prox01 jobs2004prox01 blackaid2004prox01 envirojobs2004prox01 guns2004prox101 womenrole2004prox01 ///
	pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 [pweight = V040102	]
eststo: logit vote c.defense2004prox01##c.defense2004imp01 c.spend2004prox01##c.spend2004imp01 c.jobs2004prox01##c.jobs2004imp01 ///
		c.blackaid2004prox01##c.blackaid2004imp01 c.envirojobs2004prox01##c.envirojobs2004imp01 ///
		c.guns2004prox101##c.guns2004imp01 c.womenrole2004prox01##c.womenrole2004imp01 ///
		pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 [pweight = V040102	]

*Wald
testparm c.defense2004imp01 c.defense2004prox01#c.defense2004imp01 c.spend2004imp01 c.spend2004prox01#c.spend2004imp01 ///
	c.jobs2004imp01 c.jobs2004prox01#c.jobs2004imp01  c.blackaid2004imp01 c.blackaid2004prox01#c.blackaid2004imp01 ///
	c.envirojobs2004imp01 c.envirojobs2004prox01#c.envirojobs2004imp01 c.guns2004imp01 c.guns2004prox101#c.guns2004imp01 ///
	c.womenrole2004imp01 c.womenrole2004prox01#c.womenrole2004imp01
		
*Margins
		margins, dydx(defense2004prox01) at(defense2004imp01=(0(0.25)1)) saving(2004_defenseALL, replace)
			marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Defense:2004, size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
			graph save "Defense2004ALL", replace
		
		
		margins, dydx(spend2004prox01) at(spend2004imp01=(0(0.25)1)) saving(2004_spendALL, replace)
			marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Spend:2004, size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
			graph save "Spend2004ALL", replace
		
		margins, dydx(jobs2004prox01) at(jobs2004imp01=(0(0.25)1)) saving(2004_jobsALL, replace)
			marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Jobs:2004, size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
			graph save "Jobs2004ALL", replace
		
		margins, dydx(blackaid2004prox01) at(blackaid2004imp01=(0(0.25)1)) saving(2004_blackaidALL, replace)
			marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Aid to Blacks:2004, size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
			graph save "AidBlacks2004ALL", replace
			
		margins, dydx(envirojobs2004prox01) at(envirojobs2004imp01=(0(0.25)1)) saving(2004_envirojobsALL, replace)
			marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Enviro vs Jobs:2004, size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
			graph save "EnviroJobs2004ALL", replace
		margins, dydx(guns2004prox101) at(guns2004imp01=(0(0.25)1)) saving(2004_gunsALL, replace)
			marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Guns:2004, size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
			graph save "Guns2004ALL", replace
		
		margins, dydx(womenrole2004prox01) at(womenrole2004imp01=(0(0.25)1)) saving(2004_womenroleALL, replace)
			marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Role of  Women:2004, size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
			graph save "Women2004ALL", replace
							
/***High vs. Low***/
							
*defense
margins if defense2004imp01 >=0 & defense2004imp01 <=0.5, dydx(defense2004prox01) post 
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(def04_lowALL.dta, replace)

logit vote c.defense2004prox01##c.defense2004imp01 c.spend2004prox01##c.spend2004imp01 c.jobs2004prox01##c.jobs2004imp01 ///
c.blackaid2004prox01##c.blackaid2004imp01 c.envirojobs2004prox01##c.envirojobs2004imp01 ///
c.guns2004prox101##c.guns2004imp01 c.womenrole2004prox01##c.womenrole2004imp01 ///
pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 [pweight = V040102	]

margins if defense2004imp01 ==1, dydx(defense2004prox01) post 
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(def04_highALL.dta, replace)


*spending
logit vote c.defense2004prox01##c.defense2004imp01 c.spend2004prox01##c.spend2004imp01 c.jobs2004prox01##c.jobs2004imp01 ///
c.blackaid2004prox01##c.blackaid2004imp01 c.envirojobs2004prox01##c.envirojobs2004imp01 ///
c.guns2004prox101##c.guns2004imp01 c.womenrole2004prox01##c.womenrole2004imp01 ///
pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 [pweight = V040102	]


margins if spend2004imp01 >=0 & spend2004imp01 <=0.5, dydx(spend2004prox01) post 
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(spend04_lowALL.dta, replace)

logit vote c.defense2004prox01##c.defense2004imp01 c.spend2004prox01##c.spend2004imp01 c.jobs2004prox01##c.jobs2004imp01 ///
c.blackaid2004prox01##c.blackaid2004imp01 c.envirojobs2004prox01##c.envirojobs2004imp01 ///
c.guns2004prox101##c.guns2004imp01 c.womenrole2004prox01##c.womenrole2004imp01 ///
pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 [pweight = V040102	]

margins if spend2004imp01 ==1, dydx(spend2004prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(spend04_highALL.dta, replace)

*jobs
logit vote c.defense2004prox01##c.defense2004imp01 c.spend2004prox01##c.spend2004imp01 c.jobs2004prox01##c.jobs2004imp01 ///
c.blackaid2004prox01##c.blackaid2004imp01 c.envirojobs2004prox01##c.envirojobs2004imp01 ///
c.guns2004prox101##c.guns2004imp01 c.womenrole2004prox01##c.womenrole2004imp01 ///
pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 [pweight = V040102	]

margins if jobs2004imp01 >=0 & jobs2004imp01 <=0.5, dydx(jobs2004prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(jobs04_lowALL.dta, replace)

logit vote c.defense2004prox01##c.defense2004imp01 c.spend2004prox01##c.spend2004imp01 c.jobs2004prox01##c.jobs2004imp01 ///
c.blackaid2004prox01##c.blackaid2004imp01 c.envirojobs2004prox01##c.envirojobs2004imp01 ///
c.guns2004prox101##c.guns2004imp01 c.womenrole2004prox01##c.womenrole2004imp01 ///
pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 [pweight = V040102	]

margins if jobs2004imp01 ==1, dydx(jobs2004prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(jobs04_highALL.dta, replace)


*aid to blacks
logit vote c.defense2004prox01##c.defense2004imp01 c.spend2004prox01##c.spend2004imp01 c.jobs2004prox01##c.jobs2004imp01 ///
c.blackaid2004prox01##c.blackaid2004imp01 c.envirojobs2004prox01##c.envirojobs2004imp01 ///
c.guns2004prox101##c.guns2004imp01 c.womenrole2004prox01##c.womenrole2004imp01 ///
pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 [pweight = V040102	]

margins if blackaid2004imp01 >=0 & blackaid2004imp01 <=0.25, dydx(blackaid2004prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(aidblacks04_lowALL.dta, replace)

logit vote c.defense2004prox01##c.defense2004imp01 c.spend2004prox01##c.spend2004imp01 c.jobs2004prox01##c.jobs2004imp01 ///
c.blackaid2004prox01##c.blackaid2004imp01 c.envirojobs2004prox01##c.envirojobs2004imp01 ///
c.guns2004prox101##c.guns2004imp01 c.womenrole2004prox01##c.womenrole2004imp01 ///
pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 [pweight = V040102	]

margins if blackaid2004imp01 >=0.75 & blackaid2004imp01 <=1, dydx(blackaid2004prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(aidblacks04_highALL.dta, replace)

*environment vs jobs					
logit vote c.defense2004prox01##c.defense2004imp01 c.spend2004prox01##c.spend2004imp01 c.jobs2004prox01##c.jobs2004imp01 ///
c.blackaid2004prox01##c.blackaid2004imp01 c.envirojobs2004prox01##c.envirojobs2004imp01 ///
c.guns2004prox101##c.guns2004imp01 c.womenrole2004prox01##c.womenrole2004imp01 ///
pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 [pweight = V040102	]

margins if envirojobs2004imp01 >=0 & envirojobs2004imp01 <=0.5, dydx(envirojobs2004prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(enviro04_lowALL.dta, replace)

logit vote c.defense2004prox01##c.defense2004imp01 c.spend2004prox01##c.spend2004imp01 c.jobs2004prox01##c.jobs2004imp01 ///
c.blackaid2004prox01##c.blackaid2004imp01 c.envirojobs2004prox01##c.envirojobs2004imp01 ///
c.guns2004prox101##c.guns2004imp01 c.womenrole2004prox01##c.womenrole2004imp01 ///
pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 [pweight = V040102	]

margins if envirojobs2004imp01 ==1, dydx(envirojobs2004prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(enviro04_highALL.dta, replace)

*guns
logit vote c.defense2004prox01##c.defense2004imp01 c.spend2004prox01##c.spend2004imp01 c.jobs2004prox01##c.jobs2004imp01 ///
c.blackaid2004prox01##c.blackaid2004imp01 c.envirojobs2004prox01##c.envirojobs2004imp01 ///
c.guns2004prox101##c.guns2004imp01 c.womenrole2004prox01##c.womenrole2004imp01 ///
pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 [pweight = V040102	]

margins if guns2004imp01 >=0 & guns2004imp01 <=0.5, dydx(guns2004prox101) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(guns04_lowALL.dta, replace)

logit vote c.defense2004prox01##c.defense2004imp01 c.spend2004prox01##c.spend2004imp01 c.jobs2004prox01##c.jobs2004imp01 ///
c.blackaid2004prox01##c.blackaid2004imp01 c.envirojobs2004prox01##c.envirojobs2004imp01 ///
c.guns2004prox101##c.guns2004imp01 c.womenrole2004prox01##c.womenrole2004imp01 ///
pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 [pweight = V040102	]

margins if guns2004imp01 ==1, dydx(guns2004prox101) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(guns04_highALL.dta, replace)

*role of women
logit vote c.defense2004prox01##c.defense2004imp01 c.spend2004prox01##c.spend2004imp01 c.jobs2004prox01##c.jobs2004imp01 ///
c.blackaid2004prox01##c.blackaid2004imp01 c.envirojobs2004prox01##c.envirojobs2004imp01 ///
c.guns2004prox101##c.guns2004imp01 c.womenrole2004prox01##c.womenrole2004imp01 ///
pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 [pweight = V040102	]

margins if womenrole2004imp01 >=0 & womenrole2004imp01 <=0.5, dydx(womenrole2004prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(women04_lowALL.dta, replace)

logit vote c.defense2004prox01##c.defense2004imp01 c.spend2004prox01##c.spend2004imp01 c.jobs2004prox01##c.jobs2004imp01 ///
c.blackaid2004prox01##c.blackaid2004imp01 c.envirojobs2004prox01##c.envirojobs2004imp01 ///
c.guns2004prox101##c.guns2004imp01 c.womenrole2004prox01##c.womenrole2004imp01 ///
pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 [pweight = V040102	]

margins if womenrole2004imp01 ==1, dydx(womenrole2004prox01)  post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(women04_highALL.dta, replace)

					
					
*Table
esttab using 2004_Interactions_ALL.rtf, replace se pr2 aic bic onecell ///
	star(+ 0.10 * 0.05 ** 0.01) label nobaselevels addnote(Results are weighted:V040102) ///
	title({\b Table XX} Subjective Importance and Proximity - 2004 TS)
eststo clear


/********************
One by one
********************/
*Missing Variables for Base vs. Proximity  Comparison
	
egen nmis = rowmiss(pid01 ideol econ01  gender race  age01 educ01 income01 ///	 
	defense2004prox01 spend2004prox01 jobs2004prox01 blackaid2004prox01 ///
	envirojobs2004prox01 guns2004prox101 womenrole2004prox01)
			
*Base vs. Proximity
eststo clear
eststo: logit vote pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 if nmis == 0 [pweight = V040102	]
eststo: logit vote defense2004prox01 spend2004prox01 jobs2004prox01 blackaid2004prox01 envirojobs2004prox01 guns2004prox101 womenrole2004prox01 ///
	pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 if nmis == 0 [pweight = V040102	]

		testparm defense2004prox01 spend2004prox01 jobs2004prox01 blackaid2004prox01 ///
			envirojobs2004prox01 guns2004prox101 womenrole2004prox01
		
		margins, dydx(defense2004prox01 spend2004prox01 jobs2004prox01 blackaid2004prox01 ///
			envirojobs2004prox01 guns2004prox101 womenrole2004prox01) saving(2004_proxame, replace)
		margins, dydx(*) saving(2004_allame, replace)

esttab using 2004_Base_Prox.rtf, replace se pr2 aic bic onecell ///
	star(+ 0.10 * 0.05 ** 0.01) label nobaselevels addnote(Results are weighted:V040102) ///
	title({\b Table XX.} Base & Proximity Models - 2004 TS)
	eststo clear
	estimates clear
			
*Interaction Models
*Defense
eststo clear
eststo: logit vote c.defense2004prox01##c.defense2004imp01 c.spend2004prox01 c.jobs2004prox01 c.blackaid2004prox01 c.envirojobs2004prox01 ///
	c.guns2004prox101 c.womenrole2004prox01 ///
	pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 [pweight = V040102	]

		*Wald test
			testparm c.defense2004imp01 c.defense2004prox01#c.defense2004imp01
			
		*margins
			margins, dydx(defense2004prox01) at(defense2004imp01=(0(0.25)1)) saving(2004_defense, replace)
			
			marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Defense:2004, size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
			graph save "Defense2004", replace
			
		*High vs. Low
			margins if defense2004imp01 >=0 & defense2004imp01 <=0.5, dydx(defense2004prox01) post 
			parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(def04_low.dta, replace)

			
			logit vote c.defense2004prox01##c.defense2004imp01 c.spend2004prox01 c.jobs2004prox01 c.blackaid2004prox01 c.envirojobs2004prox01 ///
				c.guns2004prox101 c.womenrole2004prox01 ///
				pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 [pweight = V040102	]
			margins if defense2004imp01 ==1, dydx(defense2004prox01) post 
			parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(def04_high.dta, replace)


*Spend
eststo: logit vote c.defense2004prox01 c.spend2004prox01##c.spend2004imp01 c.jobs2004prox01 c.blackaid2004prox01 c.envirojobs2004prox01 ///
	c.guns2004prox101 c.womenrole2004prox01 ///
	pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 [pweight = V040102	]

		*Wald test
			testparm c.spend2004imp01 c.spend2004prox01#c.spend2004imp01
			
		*margins
			margins, dydx(spend2004prox01) at(spend2004imp01=(0(0.25)1)) saving(2004_spend, replace)
			
			marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Spend:2004, size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
			graph save "Spend2004", replace
		
		*High vs. Low
			margins if spend2004imp01 >=0 & spend2004imp01 <=0.5, dydx(spend2004prox01) post 
			parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(spend04_low.dta, replace)

			logit vote c.defense2004prox01 c.spend2004prox01##c.spend2004imp01 c.jobs2004prox01 c.blackaid2004prox01 c.envirojobs2004prox01 ///
				c.guns2004prox101 c.womenrole2004prox01 ///
				pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 [pweight = V040102	]
	  
			margins if spend2004imp01 ==1, dydx(spend2004prox01) post
			parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(spend04_high.dta, replace)


*jobs
eststo: logit vote c.defense2004prox01 c.spend2004prox01 c.jobs2004prox01##c.jobs2004imp01 c.blackaid2004prox01 c.envirojobs2004prox01 ///
	c.guns2004prox101 c.womenrole2004prox01 ///
	pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 [pweight = V040102	]

		*Wald test
			testparm c.jobs2004imp01 c.jobs2004prox01#c.jobs2004imp01
			
		*margins
			margins, dydx(jobs2004prox01) at(jobs2004imp01=(0(0.25)1)) saving(2004_jobs, replace)
			
			marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Jobs:2004, size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
			graph save "Jobs2004", replace
			
		*high vs. low 
			margins if jobs2004imp01 >=0 & jobs2004imp01 <=0.5, dydx(jobs2004prox01) post
			parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(jobs04_low.dta, replace)

			logit vote c.defense2004prox01 c.spend2004prox01 c.jobs2004prox01##c.jobs2004imp01 c.blackaid2004prox01 c.envirojobs2004prox01 ///
				c.guns2004prox101 c.womenrole2004prox01 ///
				pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 [pweight = V040102	]
	  
			margins if jobs2004imp01 ==1, dydx(jobs2004prox01) post
			parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(jobs04_high.dta, replace)


*Blackaid
eststo: logit vote c.defense2004prox01 c.spend2004prox01 c.jobs2004prox01 c.blackaid2004prox01##c.blackaid2004imp01 c.envirojobs2004prox01 ///
	c.guns2004prox101 c.womenrole2004prox01 ///
	pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 [pweight = V040102	]

		*Wald test
			testparm c.blackaid2004imp01 c.blackaid2004prox01#c.blackaid2004imp01
			
		*margins
			logit vote c.defense2004prox01 c.spend2004prox01 c.jobs2004prox01 c.blackaid2004prox01##c.blackaid2004imp01 c.envirojobs2004prox01 ///
				c.guns2004prox101 c.womenrole2004prox01 ///
				pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 [pweight = V040102	]
			margins, dydx(blackaid2004prox01) at(blackaid2004imp01=(0(0.25)1)) saving(2004_blackaid, replace)
			
			marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Aid to Blacks:2004, size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
			graph save "AidBlacks2004", replace
			
		*high vs. low
			margins if blackaid2004imp01 >=0 & blackaid2004imp01 <=0.25, dydx(blackaid2004prox01) post
			parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(aidblacks04_low.dta, replace)

			
			logit vote c.defense2004prox01 c.spend2004prox01 c.jobs2004prox01 c.blackaid2004prox01##c.blackaid2004imp01 c.envirojobs2004prox01 ///
				c.guns2004prox101 c.womenrole2004prox01 ///
				pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 [pweight = V040102	]

			margins if blackaid2004imp01 >=0.75 & blackaid2004imp01 <=1, dydx(blackaid2004prox01) post
			parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(aidblacks04_high.dta, replace)



*Envirojobs
eststo: logit vote c.defense2004prox01 c.spend2004prox01 c.jobs2004prox01 c.blackaid2004prox01 c.envirojobs2004prox01##c.envirojobs2004imp01 ///
	c.guns2004prox101 c.womenrole2004prox01 ///
	pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 [pweight = V040102	]

		*Wald test
			testparm c.envirojobs2004imp01 c.envirojobs2004prox01#c.envirojobs2004imp01
			
		*margins
			margins, dydx(envirojobs2004prox01) at(envirojobs2004imp01=(0(0.25)1)) saving(2004_envirojobs, replace)
			
			marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Enviro vs Jobs:2004, size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
			graph save "EnviroJobs2004", replace
			
		*high vs. low 						
			margins if envirojobs2004imp01 >=0 & envirojobs2004imp01 <=0.5, dydx(envirojobs2004prox01) post
			parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(enviro04_low.dta, replace)

			
			 logit vote c.defense2004prox01 c.spend2004prox01 c.jobs2004prox01 c.blackaid2004prox01 c.envirojobs2004prox01##c.envirojobs2004imp01 ///
			c.guns2004prox101 c.womenrole2004prox01 ///
			pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 [pweight = V040102	]

			margins if envirojobs2004imp01 ==1, dydx(envirojobs2004prox01) post
			parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(enviro04_high.dta, replace)


*Guns
eststo: logit vote c.defense2004prox01 c.spend2004prox01 c.jobs2004prox01 c.blackaid2004prox01 c.envirojobs2004prox01 ///
	c.guns2004prox101##c.guns2004imp01 c.womenrole2004prox01 ///
	pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 [pweight = V040102	]

		*Wald test
			testparm c.guns2004imp01 c.guns2004prox101#c.guns2004imp01
			
		*margins
			margins, dydx(guns2004prox101) at(guns2004imp01=(0(0.25)1)) saving(2004_guns, replace)
			
			marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Guns:2004, size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
			graph save "Guns2004", replace
			
		*High vs. low
			margins if guns2004imp01 >=0 & guns2004imp01 <=0.5, dydx(guns2004prox101) post
			parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(guns04_low.dta, replace)
			
			
			logit vote c.defense2004prox01 c.spend2004prox01 c.jobs2004prox01 c.blackaid2004prox01 c.envirojobs2004prox01 ///
				c.guns2004prox101##c.guns2004imp01 c.womenrole2004prox01 ///
				pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 [pweight = V040102	]
			margins if guns2004imp01 ==1, dydx(guns2004prox101) post
			parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(guns04_high.dta, replace)



*Womenrole
eststo: logit vote c.defense2004prox01 c.spend2004prox01 c.jobs2004prox01 c.blackaid2004prox01 c.envirojobs2004prox01 ///
	c.guns2004prox101 c.womenrole2004prox01##c.womenrole2004imp01 ///
	pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 [pweight = V040102	]

		*Wald test
			testparm c.womenrole2004imp01 c.womenrole2004prox01#c.womenrole2004imp01
			
		*margins
			margins, dydx(womenrole2004prox01) at(womenrole2004imp01=(0(0.25)1)) saving(2004_womenrole, replace)
			
			marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Role of  Women:2004, size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
			graph save "Women2004", replace
			
		*high vs. low
			margins if womenrole2004imp01 >=0 & womenrole2004imp01 <=0.5, dydx(womenrole2004prox01) post
			parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(women04_low.dta, replace)
			
			logit vote c.defense2004prox01 c.spend2004prox01 c.jobs2004prox01 c.blackaid2004prox01 c.envirojobs2004prox01 ///
					c.guns2004prox101 c.womenrole2004prox01##c.womenrole2004imp01 ///
					pid01 i.ideol econ01  i.gender i.race  age01 educ01 income01 [pweight = V040102	]
			margins if womenrole2004imp01 ==1, dydx(womenrole2004prox01)  post
			parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(women04_high.dta, replace)


*Table
esttab using 2004_Interactions.rtf, replace se pr2 aic bic onecell ///
	star(+ 0.10 * 0.05 ** 0.01) label nobaselevels addnote(Results are weighted:V040102) ///
	title({\b Table XX.} Subjective Importance and Proximity Voting - 2004 TS)
eststo clear

		
capture log close
						
		
							***********************************
							***********************************
							***********************************
							***********2008 ANES TS (Form 1)***
							***********************************
							***********************************
							***********************************

*Data cleaning
clear
do "Data Cleaning - 2008 ANES TS.do"
set more off
log using anes2008f1.log, replace
set more off

/***************************
All interactions
***************************/

eststo clear
eststo: logit vote pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 [pweight=V080102]
eststo: logit vote defense2008proxold01 spend2008proxold01 jobs2008prox01 blackaid2008prox01 envirojobs2008prox01 ///
	health2008prox01 women2008prox01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01  [pweight=V080102]
eststo: logit vote c.defense2008proxold01##c.defense2008impold01 c.spend2008proxold01##c.spend2008impold01 c.jobs2008prox01##c.jobs2008imp01 ///
		c.blackaid2008prox01##c.blackaid2008impold01 c.envirojobs2008prox01##c.envirojobs2008imp01 ///
		c.health2008prox01##c.health2008imp01 c.women2008prox01##c.women2008imp01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01  [pweight=V080102]
		
*Wald Test
testparm c.defense2008impold01 c.defense2008proxold01#c.defense2008impold01 ///
			c.spend2008impold01 c.spend2008proxold01#c.spend2008impold01 ///
			c.jobs2008imp01 c.jobs2008prox01#c.jobs2008imp01 ///
			c.blackaid2008impold01 c.blackaid2008prox01#c.blackaid2008impold01 ///
			c.envirojobs2008imp01 c.envirojobs2008prox01#c.envirojobs2008imp01 ///
			c.health2008imp01 c.health2008prox01#c.health2008imp01 ///
			c.women2008imp01 c.women2008prox01#c.women2008imp01
*Margins

margins, dydx(defense2008proxold01) at(defense2008impold01=(0(0.25)1)) saving(2008f1_defenseALL, replace)
	
	marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Defense:2008(F1), size(medsmall)) scheme(s1mono) ///
		yline(0, lpattern(dash))
		graph save "Defense2008F1ALL", replace

margins, dydx(spend2008proxold01) at(spend2008impold01=(0(0.25)1)) saving(2008f1_spendALL, replace)
marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Spend:2008 (Form 1), size(medsmall)) scheme(s1mono) ///
	yline(0, lpattern(dash))
	graph save "Spend2008F1ALL", replace
	
	
margins, dydx(jobs2008prox01) at(jobs2008imp01=(0(0.25)1)) saving(2008f1_jobsALL, replace)

marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Jobs:2008 (Form 1), size(medsmall)) scheme(s1mono) ///
	yline(0, lpattern(dash))
	graph save "Jobs2008F1ALL", replace	
	
	
margins, dydx(blackaid2008prox01) at(blackaid2008impold01=(0(0.25)1)) saving(2008f1_blackaidALL, replace)
			
marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Aid to Blacks:2008 (Form 1), size(medsmall)) scheme(s1mono) ///
	yline(0, lpattern(dash))
	graph save "AidBlacks2008F1ALL", replace
	
margins, dydx(envirojobs2008prox01) at(envirojobs2008imp01=(0(0.25)1)) saving(2008f1_envirojobsALL, replace)
			
marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Env. vs. Jobs:2008 (Form 1), size(medsmall)) scheme(s1mono) ///
	yline(0, lpattern(dash))
	graph save "EnviroJobs2008F1ALL", replace

	
margins, dydx(health2008prox01) at(health2008imp01=(0(0.25)1)) saving(2008f1_healthALL, replace)
			
marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Gov. Health Ins.:2008 (Form 1), size(medsmall)) scheme(s1mono) ///
	yline(0, lpattern(dash))
	graph save "Health2008F1ALL", replace
	
margins, dydx(women2008prox01) at(women2008imp01=(0(0.25)1)) saving(2008f1_womenALL, replace)
			
marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Role of Women:2008 (Form 1), size(medsmall)) scheme(s1mono) ///
	yline(0, lpattern(dash))
	graph save "Women2008F1ALL", replace		
						
/****High vs. Low******/
*defense
margins if defense2008impold01 >=0 & defense2008impold01 <=0.5, dydx(defense2008proxold01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(def08_lowALL.dta, replace)

logit vote c.defense2008proxold01##c.defense2008impold01 c.spend2008proxold01##c.spend2008impold01 c.jobs2008prox01##c.jobs2008imp01 ///
c.blackaid2008prox01##c.blackaid2008impold01 c.envirojobs2008prox01##c.envirojobs2008imp01 ///
c.health2008prox01##c.health2008imp01 c.women2008prox01##c.women2008imp01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01  [pweight=V080102]

margins if defense2008impold01 ==1, dydx(defense2008proxold01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(def08_highALL.dta, replace)

*spend
logit vote c.defense2008proxold01##c.defense2008impold01 c.spend2008proxold01##c.spend2008impold01 c.jobs2008prox01##c.jobs2008imp01 ///
c.blackaid2008prox01##c.blackaid2008impold01 c.envirojobs2008prox01##c.envirojobs2008imp01 ///
c.health2008prox01##c.health2008imp01 c.women2008prox01##c.women2008imp01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01  [pweight=V080102]

margins if spend2008impold01 >=0 & spend2008impold01 <=0.5, dydx(spend2008proxold01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(spend08_lowALL.dta, replace)

logit vote c.defense2008proxold01##c.defense2008impold01 c.spend2008proxold01##c.spend2008impold01 c.jobs2008prox01##c.jobs2008imp01 ///
c.blackaid2008prox01##c.blackaid2008impold01 c.envirojobs2008prox01##c.envirojobs2008imp01 ///
c.health2008prox01##c.health2008imp01 c.women2008prox01##c.women2008imp01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01  [pweight=V080102]

margins if spend2008impold01 ==1, dydx(spend2008proxold01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(spend08_highALL.dta, replace)

*jobs
logit vote c.defense2008proxold01##c.defense2008impold01 c.spend2008proxold01##c.spend2008impold01 c.jobs2008prox01##c.jobs2008imp01 ///
c.blackaid2008prox01##c.blackaid2008impold01 c.envirojobs2008prox01##c.envirojobs2008imp01 ///
c.health2008prox01##c.health2008imp01 c.women2008prox01##c.women2008imp01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01  [pweight=V080102]

margins if jobs2008imp01 >=0 & jobs2008imp01 <=0.50, dydx(jobs2008prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(jobs08_lowALL.dta, replace)


logit vote c.defense2008proxold01##c.defense2008impold01 c.spend2008proxold01##c.spend2008impold01 c.jobs2008prox01##c.jobs2008imp01 ///
c.blackaid2008prox01##c.blackaid2008impold01 c.envirojobs2008prox01##c.envirojobs2008imp01 ///
c.health2008prox01##c.health2008imp01 c.women2008prox01##c.women2008imp01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01  [pweight=V080102]

margins if jobs2008imp01 ==1, dydx(jobs2008prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(jobs08_highALL.dta, replace)

*aid to blacks
logit vote c.defense2008proxold01##c.defense2008impold01 c.spend2008proxold01##c.spend2008impold01 c.jobs2008prox01##c.jobs2008imp01 ///
c.blackaid2008prox01##c.blackaid2008impold01 c.envirojobs2008prox01##c.envirojobs2008imp01 ///
c.health2008prox01##c.health2008imp01 c.women2008prox01##c.women2008imp01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01  [pweight=V080102]

margins if blackaid2008impold01 >=0 & blackaid2008impold01 <=0.25, dydx(blackaid2008prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(aidblacks08_lowALL.dta, replace)

logit vote c.defense2008proxold01##c.defense2008impold01 c.spend2008proxold01##c.spend2008impold01 c.jobs2008prox01##c.jobs2008imp01 ///
c.blackaid2008prox01##c.blackaid2008impold01 c.envirojobs2008prox01##c.envirojobs2008imp01 ///
c.health2008prox01##c.health2008imp01 c.women2008prox01##c.women2008imp01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01  [pweight=V080102]

margins if blackaid2008impold01 >=0.75 & blackaid2008impold01 <=1, dydx(blackaid2008prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(aidblacks08_highALL.dta, replace)

*environment vs jobs
logit vote c.defense2008proxold01##c.defense2008impold01 c.spend2008proxold01##c.spend2008impold01 c.jobs2008prox01##c.jobs2008imp01 ///
c.blackaid2008prox01##c.blackaid2008impold01 c.envirojobs2008prox01##c.envirojobs2008imp01 ///
c.health2008prox01##c.health2008imp01 c.women2008prox01##c.women2008imp01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01  [pweight=V080102]

margins if envirojobs2008imp01 >=0 & envirojobs2008imp01 <=0.25, dydx(envirojobs2008prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(enviro08_lowALL.dta, replace)

logit vote c.defense2008proxold01##c.defense2008impold01 c.spend2008proxold01##c.spend2008impold01 c.jobs2008prox01##c.jobs2008imp01 ///
c.blackaid2008prox01##c.blackaid2008impold01 c.envirojobs2008prox01##c.envirojobs2008imp01 ///
c.health2008prox01##c.health2008imp01 c.women2008prox01##c.women2008imp01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01  [pweight=V080102]

margins if envirojobs2008imp01 >=0.75 & envirojobs2008imp01 <=1, dydx(envirojobs2008prox01) post
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(enviro08_highALL.dta, replace)

*health insurance				
logit vote c.defense2008proxold01##c.defense2008impold01 c.spend2008proxold01##c.spend2008impold01 c.jobs2008prox01##c.jobs2008imp01 ///
c.blackaid2008prox01##c.blackaid2008impold01 c.envirojobs2008prox01##c.envirojobs2008imp01 ///
c.health2008prox01##c.health2008imp01 c.women2008prox01##c.women2008imp01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01  [pweight=V080102]

margins if health2008imp01 >=0 & health2008imp01 <=0.50, dydx(health2008prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(health08_lowALL.dta, replace)

logit vote c.defense2008proxold01##c.defense2008impold01 c.spend2008proxold01##c.spend2008impold01 c.jobs2008prox01##c.jobs2008imp01 ///
c.blackaid2008prox01##c.blackaid2008impold01 c.envirojobs2008prox01##c.envirojobs2008imp01 ///
c.health2008prox01##c.health2008imp01 c.women2008prox01##c.women2008imp01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01  [pweight=V080102]

margins if health2008imp01 ==1, dydx(health2008prox01) post
	parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(health08_highALL.dta, replace)

*women
logit vote c.defense2008proxold01##c.defense2008impold01 c.spend2008proxold01##c.spend2008impold01 c.jobs2008prox01##c.jobs2008imp01 ///
c.blackaid2008prox01##c.blackaid2008impold01 c.envirojobs2008prox01##c.envirojobs2008imp01 ///
c.health2008prox01##c.health2008imp01 c.women2008prox01##c.women2008imp01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01  [pweight=V080102]

margins if women2008imp01 >=0 & women2008imp01 <=0.50, dydx(women2008prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(women08_lowALL.dta, replace)

logit vote c.defense2008proxold01##c.defense2008impold01 c.spend2008proxold01##c.spend2008impold01 c.jobs2008prox01##c.jobs2008imp01 ///
c.blackaid2008prox01##c.blackaid2008impold01 c.envirojobs2008prox01##c.envirojobs2008imp01 ///
c.health2008prox01##c.health2008imp01 c.women2008prox01##c.women2008imp01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01  [pweight=V080102]

margins if women2008imp01 ==1, dydx(women2008prox01) post
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(women08_highALL.dta, replace)


							
*Table
	esttab using 2008__F1_Interactions_ALL.rtf, replace se pr2 aic bic onecell ///
	star(+ 0.10 * 0.05 ** 0.01) label nobaselevels addnote(Results are weighted:V080102) ///
	title({\b Table XX.} "Subjective Importance and Proximity Voting - 2008TS (Form 1)")
eststo clear



/*************************
One By One
**************************/
*Missing Data for Base vs. Proximity Comparison
egen nmis = rowmiss(pid01 ideol econ01  gender race age01 educ01 income01 ///
		defense2008proxold01 spend2008proxold01 jobs2008prox01 blackaid2008prox01 envirojobs2008prox01 health2008prox01 women2008prox01)	

*Base vs. Proximity
eststo clear
eststo: logit vote pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 if nmis == 0 [pweight=V080102]
eststo: logit vote defense2008proxold01 spend2008proxold01 jobs2008prox01 blackaid2008prox01 envirojobs2008prox01 ///
		health2008prox01 women2008prox01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 if nmis == 0  [pweight=V080102]

		testparm defense2008proxold01 spend2008proxold01 jobs2008prox01 blackaid2008prox01 envirojobs2008prox01 ///
			health2008prox01 women2008prox01
		
		margins, dydx(defense2008proxold01 spend2008proxold01 jobs2008prox01 blackaid2008prox01 envirojobs2008prox01 ///
			health2008prox01 women2008prox01) saving(2008_proxame, replace)
		
		margins, dydx(*) saving(2008_allame, replace)

esttab using 2008_F1_Base_Prox.rtf, replace se pr2 aic bic onecell ///
	star(+ 0.10 * 0.05 ** 0.01) label nobaselevels addnote(Results are weighted:V080102) ///
	title({\b Table XX.} "Base and Proximity Models - 2008TS (Form 1)")
eststo clear
estimates clear
			

*Interaction Models
*Defense
eststo clear
eststo: logit vote c.defense2008proxold01##c.defense2008impold01 c.spend2008proxold01 c.jobs2008prox01 c.blackaid2008prox01 c.envirojobs2008prox01 ///
	c.health2008prox01 c.women2008prox01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 if nmis == 0  [pweight=V080102]

	*Wald Test
		testparm c.defense2008impold01 c.defense2008proxold01#c.defense2008impold01
	
	*Margins
		margins, dydx(defense2008proxold01) at(defense2008impold01=(0(0.25)1)) saving(2008f1_defense, replace)
		
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Defense:2008 (Form 1), size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
			graph save "Defense2008F1", replace
	
	*high vs. low
		margins if defense2008impold01 >=0 & defense2008impold01 <=0.5, dydx(defense2008proxold01) post
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(def08_low.dta, replace)

		
		logit vote c.defense2008proxold01##c.defense2008impold01 c.spend2008proxold01 c.jobs2008prox01 c.blackaid2008prox01 c.envirojobs2008prox01 ///
		c.health2008prox01 c.women2008prox01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 if nmis == 0  [pweight=V080102]

		margins if defense2008impold01 ==1, dydx(defense2008proxold01) saving(2008f1defensehigh, replace)
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(def08_high.dta, replace)


*Spend
eststo: logit vote c.defense2008proxold01 c.spend2008proxold01##c.spend2008impold01 c.jobs2008prox01 c.blackaid2008prox01 c.envirojobs2008prox01 ///
	c.health2008prox01 c.women2008prox01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 if nmis == 0  [pweight=V080102]

	*Wald Test
		testparm c.spend2008impold01 c.spend2008proxold01#c.spend2008impold01
	
	*Margins
		margins, dydx(spend2008proxold01) at(spend2008impold01=(0(0.25)1)) saving(2008f1_spend, replace)
		
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Spend:2008 (Form 1), size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
			graph save "Spend2008F1", replace
	
		*High vs. low
		margins if spend2008impold01 >=0 & spend2008impold01 <=0.5, dydx(spend2008proxold01) post
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(spend08_low.dta, replace)

		
		logit vote c.defense2008proxold01 c.spend2008proxold01##c.spend2008impold01 c.jobs2008prox01 c.blackaid2008prox01 c.envirojobs2008prox01 ///
				c.health2008prox01 c.women2008prox01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 if nmis == 0  [pweight=V080102]
			margins if spend2008impold01 ==1, dydx(spend2008proxold01) saving(2008f1spendhigh, replace)
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(spend08_high.dta, replace)

			
			
*Jobs
eststo: logit vote c.defense2008proxold01 c.spend2008proxold01 c.jobs2008prox01##c.jobs2008imp01 c.blackaid2008prox01 c.envirojobs2008prox01 ///
	c.health2008prox01 c.women2008prox01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 if nmis == 0  [pweight=V080102]

	*Wald Test
		testparm c.jobs2008imp01 c.jobs2008prox01#c.jobs2008imp01
	
	*Margins
		margins, dydx(jobs2008prox01) at(jobs2008imp01=(0(0.25)1)) saving(2008f1_jobs, replace)
		
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Jobs & SOL:2008 (Form 1), size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
			graph save "Jobs2008F1", replace
	
	*high vs. low
		margins if jobs2008imp01 >=0 & jobs2008imp01 <=0.50, dydx(jobs2008prox01) post
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(jobs08_low.dta, replace)

		eststo: logit vote c.defense2008proxold01 c.spend2008proxold01 c.jobs2008prox01##c.jobs2008imp01 c.blackaid2008prox01 c.envirojobs2008prox01 ///
			c.health2008prox01 c.women2008prox01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 if nmis == 0  [pweight=V080102]
		margins if jobs2008imp01 ==1, dydx(jobs2008prox01) saving(2008f1jobshigh, replace)
					parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(jobs08_high.dta, replace)

					
*BlackAid
eststo: logit vote c.defense2008proxold01 c.spend2008proxold01 c.jobs2008prox01 c.blackaid2008prox01##c.blackaid2008impold01 c.envirojobs2008prox01 ///
	c.health2008prox01 c.women2008prox01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 if nmis == 0  [pweight=V080102]

	*Wald Test
		testparm c.blackaid2008impold01 c.blackaid2008prox01#c.blackaid2008impold01
	
	*Margins
		margins, dydx(blackaid2008prox01) at(blackaid2008impold01=(0(0.25)1)) saving(2008f1_blackaid, replace)
		
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Aid to Blacks:2008 (Form 1), size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
			graph save "AidBlacks2008F1", replace
	
	*high vs. low 
		margins if blackaid2008impold01 >=0 & blackaid2008impold01 <=0.25, dydx(blackaid2008prox01) post
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(aidblacks08_low.dta, replace)

		logit vote c.defense2008proxold01 c.spend2008proxold01 c.jobs2008prox01 c.blackaid2008prox01##c.blackaid2008impold01 c.envirojobs2008prox01 ///
			c.health2008prox01 c.women2008prox01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 if nmis == 0  [pweight=V080102]

		margins if blackaid2008impold01 >=0.75 & blackaid2008impold01 <=1, dydx(blackaid2008prox01) saving(2008f1blackaidhigh, replace)
					parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(aidblacks08_high.dta, replace)

*EnviroJobs
eststo: logit vote c.defense2008proxold01 c.spend2008proxold01 c.jobs2008prox01 c.blackaid2008prox01 c.envirojobs2008prox01##c.envirojobs2008imp01 ///
	c.health2008prox01 c.women2008prox01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 if nmis == 0  [pweight=V080102]

	*Wald Test
		testparm c.envirojobs2008imp01 c.envirojobs2008prox01#c.envirojobs2008imp01
	
	*Margins
		margins, dydx(envirojobs2008prox01) at(envirojobs2008imp01=(0(0.25)1)) saving(2008f1_envirojobs, replace)
		
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Env. vs. Jobs:2008 (Form 1), size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
			graph save "EnviroJobs2008F1", replace
	
	*high vs. low
		margins if envirojobs2008imp01 >=0 & envirojobs2008imp01 <=0.25, dydx(envirojobs2008prox01) post
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(enviro08_low.dta, replace)

		logit vote c.defense2008proxold01 c.spend2008proxold01 c.jobs2008prox01 c.blackaid2008prox01 c.envirojobs2008prox01##c.envirojobs2008imp01 ///
			c.health2008prox01 c.women2008prox01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 if nmis == 0  [pweight=V080102]

		margins if envirojobs2008imp01 >=0.75 & envirojobs2008imp01 <=1, dydx(envirojobs2008prox01) post
					parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(enviro08_high.dta, replace)


*Health 
eststo: logit vote c.defense2008proxold01 c.spend2008proxold01 c.jobs2008prox01 c.blackaid2008prox01 c.envirojobs2008prox01 ///
	c.health2008prox01##c.health2008imp01 c.women2008prox01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 if nmis == 0  [pweight=V080102]

	*Wald Test
		testparm c.health2008imp01 c.health2008prox01#c.health2008imp01
	
	*Margins
		margins, dydx(health2008prox01) at(health2008imp01=(0(0.25)1)) saving(2008f1_health, replace)
		
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Gov. Health Ins.:2008 (Form 1), size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
			graph save "Health2008F1", replace
	
	*High vs. low				
		margins if health2008imp01 >=0 & health2008imp01 <=0.50, dydx(health2008prox01) post
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(health08_low.dta, replace)

		logit vote c.defense2008proxold01 c.spend2008proxold01 c.jobs2008prox01 c.blackaid2008prox01 c.envirojobs2008prox01 ///
			c.health2008prox01##c.health2008imp01 c.women2008prox01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 if nmis == 0  [pweight=V080102]
		margins if health2008imp01 ==1, dydx(health2008prox01) saving(2008f1healthhigh, replace)
				parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(health08_high.dta, replace)

*Women
eststo: logit vote c.defense2008proxold01 c.spend2008proxold01 c.jobs2008prox01 c.blackaid2008prox01 c.envirojobs2008prox01 ///
	c.health2008prox01 c.women2008prox01##c.women2008imp01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 if nmis == 0  [pweight=V080102]

	*Wald Test
		testparm c.women2008imp01 c.women2008prox01#c.women2008imp01
	
	*Margins
		margins, dydx(women2008prox01) at(women2008imp01=(0(0.25)1)) saving(2008f1_women, replace)
		
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Role of Women:2008 (Form 1), size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
			graph save "Women2008F1", replace
	
	*high vs. low
		margins if women2008imp01 >=0 & women2008imp01 <=0.50, dydx(women2008prox01) post
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(women08_low.dta, replace)

		logit vote c.defense2008proxold01 c.spend2008proxold01 c.jobs2008prox01 c.blackaid2008prox01 c.envirojobs2008prox01 ///
			c.health2008prox01 c.women2008prox01##c.women2008imp01 pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 if nmis == 0  [pweight=V080102]

		margins if women2008imp01 ==1, dydx(women2008prox01) saving(2008f1womenhigh, replace)
					parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(women08_high.dta, replace)

*Table
	esttab using 2008_F1_Interactions.rtf, replace se pr2 aic bic onecell ///
		star(+ 0.10 * 0.05 ** 0.01) label nobaselevels addnote(Results are weighted:V080102) ///
		title({\b Table XX.} "Subjective Importance and Proximity Voting - 2008TS (Form 1)")
	eststo clear
		
	
capture log close								
		
									
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
log using anes2008f2.log, replace
set more off

/*************************
All interactions at once
**************************/
eststo clear
eststo: logit vote pid01 i.ideol econ01  i.gender i.race age01 educ01 income01  [pweight=V080102]
eststo: logit vote defense2008proxnew01 spend2008proxnew01 blackaid2008prox01 emission2008prox01 universal2008prox01 citizenship2008prox01 ///
				pid01 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight=V080102]

eststo: logit vote c.defense2008proxnew01##c.defense2008impnew01 c.spend2008proxnew01##c.spend2008impnew01 ///
			c.blackaid2008prox01##c.blackaid2008impnew01 c.emission2008prox01##c.emission2008imp01 ///
			c.universal2008prox01##c.universal2008imp01 c.citizenship2008prox01##c.citizenship2008imp01 ///			
			pid01 i.ideol econ01  i.gender i.race age01 educ01 income01    [pweight=V080102]

*Wald Test
testparm c.defense2008impnew01 c.defense2008proxnew01#c.defense2008impnew01 ///
	c.spend2008impnew01 c.spend2008proxnew01#c.spend2008impnew01 ///
	c.blackaid2008impnew01 c.blackaid2008prox01#c.blackaid2008impnew01 ///
	c.emission2008imp01 c.emission2008prox01#c.emission2008imp01 ///
	c.universal2008imp01 c.universal2008prox01#c.universal2008imp01 ///
	c.citizenship2008imp01 c.citizenship2008prox01#c.citizenship2008imp01
	
*Margins
margins, dydx(defense2008proxnew01) at(defense2008impnew01=(0(0.25)1)) saving(2008f2ALL_defense, replace)
marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Defense:2008 (Form 2), size(medsmall)) scheme(s1mono) ///
	yline(0, lpattern(dash))
	graph save "Defense2008F2ALL", replace


margins, dydx(spend2008proxnew01) at(spend2008impnew01=(0(0.25)1)) saving(2008f2ALL_spend, replace)
marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Spend:2008 (Form 2), size(medsmall)) scheme(s1mono) ///
yline(0, lpattern(dash))
graph save "Spend2008F2ALL", replace

margins, dydx(blackaid2008prox01) at(blackaid2008impnew01=(0(0.25)1)) saving(2008f2ALL_blackaid, replace)
marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Aid to Blacks:2008 (Form 2), size(medsmall)) scheme(s1mono) ///
yline(0, lpattern(dash))
graph save "BlackAid2008F2ALL", replace						

margins, dydx(emission2008prox01) at(emission2008imp01=(0(0.25)1)) saving(2008f2ALL_emission, replace)
marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Plant Emissions:2008 (Form 2), size(medsmall)) scheme(s1mono) ///
yline(0, lpattern(dash))
graph save "Emission2008F2ALL", replace

margins, dydx(universal2008prox01) at(universal2008imp01=(0(0.25)1)) saving(2008f2ALL_universal, replace)
marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Univ. Health Care:2008 (Form 2), size(medsmall)) scheme(s1mono) ///
yline(0, lpattern(dash))
graph save "Universal2008F2ALL", replace

margins, dydx(citizenship2008prox01) at(citizenship2008imp01=(0(0.25)1)) saving(2008f2ALL_citizenship, replace)
marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Path Citizenship:2008 (Form 2), size(medsmall)) scheme(s1mono) ///
yline(0, lpattern(dash))
graph save "Path2008F2ALL", replace

/****HIGH VS. LOW****/
*defense
margins if defense2008impnew01 >=0 & defense2008impnew01 <=0.5, dydx(defense2008proxnew01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(def08f2_lowALL.dta, replace)

logit vote c.defense2008proxnew01##c.defense2008impnew01 c.spend2008proxnew01##c.spend2008impnew01 ///
c.blackaid2008prox01##c.blackaid2008impnew01 c.emission2008prox01##c.emission2008imp01 ///
c.universal2008prox01##c.universal2008imp01 c.citizenship2008prox01##c.citizenship2008imp01 ///			
pid01 i.ideol econ01  i.gender i.race age01 educ01 income01    [pweight=V080102]

margins if defense2008impnew01 ==1, dydx(defense2008proxnew01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(def08f2_highALL.dta, replace)

*spending
logit vote c.defense2008proxnew01##c.defense2008impnew01 c.spend2008proxnew01##c.spend2008impnew01 ///
c.blackaid2008prox01##c.blackaid2008impnew01 c.emission2008prox01##c.emission2008imp01 ///
c.universal2008prox01##c.universal2008imp01 c.citizenship2008prox01##c.citizenship2008imp01 ///			
pid01 i.ideol econ01  i.gender i.race age01 educ01 income01    [pweight=V080102]
margins if spend2008impnew01 >=0 & spend2008impnew01 <=0.5, dydx(spend2008proxnew01) post 
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(spend08f2_lowALL.dta, replace)

logit vote c.defense2008proxnew01##c.defense2008impnew01 c.spend2008proxnew01##c.spend2008impnew01 ///
c.blackaid2008prox01##c.blackaid2008impnew01 c.emission2008prox01##c.emission2008imp01 ///
c.universal2008prox01##c.universal2008imp01 c.citizenship2008prox01##c.citizenship2008imp01 ///			
pid01 i.ideol econ01  i.gender i.race age01 educ01 income01    [pweight=V080102]
margins if spend2008impnew01 ==1, dydx(spend2008proxnew01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(spend08f2_highALL.dta, replace)

*aid to blacks
logit vote c.defense2008proxnew01##c.defense2008impnew01 c.spend2008proxnew01##c.spend2008impnew01 ///
c.blackaid2008prox01##c.blackaid2008impnew01 c.emission2008prox01##c.emission2008imp01 ///
c.universal2008prox01##c.universal2008imp01 c.citizenship2008prox01##c.citizenship2008imp01 ///			
pid01 i.ideol econ01  i.gender i.race age01 educ01 income01    [pweight=V080102]
margins if blackaid2008impnew01 >=0 & blackaid2008impnew01 <=0.25, dydx(blackaid2008prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(aidblacks08f2_lowALL.dta, replace)

logit vote c.defense2008proxnew01##c.defense2008impnew01 c.spend2008proxnew01##c.spend2008impnew01 ///
c.blackaid2008prox01##c.blackaid2008impnew01 c.emission2008prox01##c.emission2008imp01 ///
c.universal2008prox01##c.universal2008imp01 c.citizenship2008prox01##c.citizenship2008imp01 ///			
pid01 i.ideol econ01  i.gender i.race age01 educ01 income01    [pweight=V080102]
margins if blackaid2008impnew01 >=0.75 & blackaid2008impnew01 <=1, dydx(blackaid2008prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(aidblacks08f2_highALL.dta, replace)

*emissions
logit vote c.defense2008proxnew01##c.defense2008impnew01 c.spend2008proxnew01##c.spend2008impnew01 ///
c.blackaid2008prox01##c.blackaid2008impnew01 c.emission2008prox01##c.emission2008imp01 ///
c.universal2008prox01##c.universal2008imp01 c.citizenship2008prox01##c.citizenship2008imp01 ///			
pid01 i.ideol econ01  i.gender i.race age01 educ01 income01    [pweight=V080102]
margins if emission2008imp01 >=0 & emission2008imp01 <=0.25, dydx(emission2008prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(emission08_lowALL.dta, replace)

logit vote c.defense2008proxnew01##c.defense2008impnew01 c.spend2008proxnew01##c.spend2008impnew01 ///
c.blackaid2008prox01##c.blackaid2008impnew01 c.emission2008prox01##c.emission2008imp01 ///
c.universal2008prox01##c.universal2008imp01 c.citizenship2008prox01##c.citizenship2008imp01 ///			
pid01 i.ideol econ01  i.gender i.race age01 educ01 income01    [pweight=V080102]
margins if emission2008imp01 >=0.75 & emission2008imp01 <=1, dydx(emission2008prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(emission08_highALL.dta, replace)

*universal health care
logit vote c.defense2008proxnew01##c.defense2008impnew01 c.spend2008proxnew01##c.spend2008impnew01 ///
c.blackaid2008prox01##c.blackaid2008impnew01 c.emission2008prox01##c.emission2008imp01 ///
c.universal2008prox01##c.universal2008imp01 c.citizenship2008prox01##c.citizenship2008imp01 ///			
pid01 i.ideol econ01  i.gender i.race age01 educ01 income01    [pweight=V080102]
margins if universal2008imp01 >=0 & universal2008imp01 <=0.5, dydx(universal2008prox01) post 
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(univ08_lowALL.dta, replace)

logit vote c.defense2008proxnew01##c.defense2008impnew01 c.spend2008proxnew01##c.spend2008impnew01 ///
c.blackaid2008prox01##c.blackaid2008impnew01 c.emission2008prox01##c.emission2008imp01 ///
c.universal2008prox01##c.universal2008imp01 c.citizenship2008prox01##c.citizenship2008imp01 ///			
pid01 i.ideol econ01  i.gender i.race age01 educ01 income01    [pweight=V080102]
margins if universal2008imp01 ==1, dydx(universal2008prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(univ08_highALL.dta, replace)

*citizenship
logit vote c.defense2008proxnew01##c.defense2008impnew01 c.spend2008proxnew01##c.spend2008impnew01 ///
c.blackaid2008prox01##c.blackaid2008impnew01 c.emission2008prox01##c.emission2008imp01 ///
c.universal2008prox01##c.universal2008imp01 c.citizenship2008prox01##c.citizenship2008imp01 ///			
pid01 i.ideol econ01  i.gender i.race age01 educ01 income01    [pweight=V080102]
margins if citizenship2008imp01 >=0 & citizenship2008imp01 <=0.25, dydx(citizenship2008prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(citi08_lowALL.dta, replace)

logit vote c.defense2008proxnew01##c.defense2008impnew01 c.spend2008proxnew01##c.spend2008impnew01 ///
c.blackaid2008prox01##c.blackaid2008impnew01 c.emission2008prox01##c.emission2008imp01 ///
c.universal2008prox01##c.universal2008imp01 c.citizenship2008prox01##c.citizenship2008imp01 ///			
pid01 i.ideol econ01  i.gender i.race age01 educ01 income01    [pweight=V080102]
margins if citizenship2008imp01 >=0.75 & citizenship2008imp01 <=1, dydx(citizenship2008prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(citi08_highALL.dta, replace)

					

*Table
							
	esttab using 2008__F2_Interactions_ALL.rtf, replace se pr2 aic bic onecell ///
	star(+ 0.10 * 0.05 ** 0.01) label nobaselevels addnote(Results are weighted:V080102) ///
	title({\b Table XX.} "Subjective Importance and Proximity Voting - 2008TS (Form 2)")
eststo clear
		



/*************************
One by one
*************************/
*Missing Data for Base vs. Proximity Comparison
egen nmis = rowmiss(pid01 ideol econ01  gender race age01 educ01 income01 ///
		defense2008proxnew01 spend2008proxnew01 blackaid2008prox01 emission2008prox01 universal2008prox01 citizenship2008prox01)

*Base vs. Proximity
eststo clear
eststo: logit vote pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 if nmis == 0 [pweight=V080102]
eststo: logit vote defense2008proxnew01 spend2008proxnew01 blackaid2008prox01 emission2008prox01 universal2008prox01 citizenship2008prox01 ///
					pid01 i.ideol econ01  i.gender i.race age01 educ01 income01 if nmis == 0  [pweight=V080102]

		testparm defense2008proxnew01 spend2008proxnew01 blackaid2008prox01 emission2008prox01 ///
			universal2008prox01 citizenship2008prox01
		
		margins, dydx(defense2008proxnew01 spend2008proxnew01 blackaid2008prox01 emission2008prox01 ///
			universal2008prox01 citizenship2008prox01) saving(2008f2_proxame, replace)
		
		margins, dydx(*) saving(2008f2_allame, replace)

esttab using 2008_F2_Base_Prox.rtf, replace se pr2 aic bic onecell ///
	star(+ 0.10 * 0.05 ** 0.01) label nobaselevels addnote(Results are weighted:V080102) ///
	title({\b Table XX.} "Base and Proximity Models - 2008TS (Form 2)")
eststo clear
estimates clear
			

*Interaction Models
*Defense
eststo clear
eststo: logit vote c.defense2008proxnew01##c.defense2008impnew01 c.spend2008proxnew01 ///
				blackaid2008prox01 emission2008prox01 universal2008prox01 citizenship2008prox01 ///			
				pid01 i.ideol econ01  i.gender i.race age01 educ01 income01    [pweight=V080102]

	*Wald Test
		testparm c.defense2008impnew01 c.defense2008proxnew01#c.defense2008impnew01
	
	*Margins
		margins, dydx(defense2008proxnew01) at(defense2008impnew01=(0(0.25)1)) saving(2008f2_defense, replace)
		
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Defense:2008 (Form 2), size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
			graph save "Defense2008F2", replace
	
	*high vs. low
		margins if defense2008impnew01 >=0 & defense2008impnew01 <=0.5, dydx(defense2008proxnew01) post
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(def08f2_low.dta, replace)

		logit vote c.defense2008proxnew01##c.defense2008impnew01 c.spend2008proxnew01 ///
				blackaid2008prox01 emission2008prox01 universal2008prox01 citizenship2008prox01 ///			
				pid01 i.ideol econ01  i.gender i.race age01 educ01 income01    [pweight=V080102]	
		margins if defense2008impnew01 ==1, dydx(defense2008proxnew01) post
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(def08f2_high.dta, replace)


*Spend
eststo: logit vote c.defense2008proxnew01 c.spend2008proxnew01##c.spend2008impnew01 ///
				c.blackaid2008prox01 c.emission2008prox01 c.universal2008prox01 c.citizenship2008prox01 ///			
				pid01 i.ideol econ01  i.gender i.race age01 educ01 income01    [pweight=V080102]

	*Wald Test
		testparm c.spend2008impnew01 c.spend2008proxnew01#c.spend2008impnew01
	
	*Margins
		margins, dydx(spend2008proxnew01) at(spend2008impnew01=(0(0.25)1)) saving(2008f2_spend, replace)
		
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Spend:2008 (Form 2), size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
			graph save "Spend2008F2", replace
	
	*high vs. low
		margins if spend2008impnew01 >=0 & spend2008impnew01 <=0.5, dydx(spend2008proxnew01) post 
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(spend08f2_low.dta, replace)

		logit vote c.defense2008proxnew01 c.spend2008proxnew01##c.spend2008impnew01 ///
				c.blackaid2008prox01 c.emission2008prox01 c.universal2008prox01 c.citizenship2008prox01 ///			
				pid01 i.ideol econ01  i.gender i.race age01 educ01 income01    [pweight=V080102]					
		margins if spend2008impnew01 ==1, dydx(spend2008proxnew01) post
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(spend08f2_high.dta, replace)

		

*Black Aid
	eststo: logit vote c.defense2008proxnew01 c.spend2008proxnew01 ///
				c.blackaid2008prox01##c.blackaid2008impnew01 c.emission2008prox01 c.universal2008prox01 c.citizenship2008prox01 ///			
				pid01 i.ideol econ01  i.gender i.race age01 educ01 income01    [pweight=V080102]

	*Wald Test
		testparm c.blackaid2008impnew01 c.blackaid2008prox01#c.blackaid2008impnew01
	
	*Margins
		margins, dydx(blackaid2008prox01) at(blackaid2008impnew01=(0(0.25)1)) saving(2008f2_blackaid, replace)
		
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Aid to Blacks:2008 (Form 2), size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
			graph save "BlackAid2008F2", replace
	
	*high vs. low
		margins if blackaid2008impnew01 >=0 & blackaid2008impnew01 <=0.25, dydx(blackaid2008prox01) post
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(aidblacks08f2_low.dta, replace)
		
				
		logit vote c.defense2008proxnew01 c.spend2008proxnew01 ///
				c.blackaid2008prox01##c.blackaid2008impnew01 c.emission2008prox01 c.universal2008prox01 c.citizenship2008prox01 ///			
				pid01 i.ideol econ01  i.gender i.race age01 educ01 income01    [pweight=V080102]
		margins if blackaid2008impnew01 >=0.75 & blackaid2008impnew01 <=1, dydx(blackaid2008prox01) post
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(aidblacks08f2_high.dta, replace)


*Emissions
	eststo: logit vote c.defense2008proxnew01 c.spend2008proxnew01 ///
				c.blackaid2008prox01 c.emission2008prox01##c.emission2008imp01 c.universal2008prox01 c.citizenship2008prox01 ///			
				pid01 i.ideol econ01  i.gender i.race age01 educ01 income01    [pweight=V080102]

	*Wald Test
		testparm c.emission2008imp01 c.emission2008prox01#c.emission2008imp01
	
	*Margins
		margins, dydx(emission2008prox01) at(emission2008imp01=(0(0.25)1)) saving(2008f2_emission, replace)
		
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Plant Emissions:2008 (Form 2), size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
			graph save "Emission2008F2", replace
	
	*high vs. low
		margins if emission2008imp01 >=0 & emission2008imp01 <=0.25, dydx(emission2008prox01) post
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(emission08_low.dta, replace)

		logit vote c.defense2008proxnew01 c.spend2008proxnew01 ///
				c.blackaid2008prox01 c.emission2008prox01##c.emission2008imp01 c.universal2008prox01 c.citizenship2008prox01 ///			
				pid01 i.ideol econ01  i.gender i.race age01 educ01 income01    [pweight=V080102]

		margins if emission2008imp01 >=0.75 & emission2008imp01 <=1, dydx(emission2008prox01) post
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(emission08_high.dta, replace)

*Universal Health
	eststo: logit vote c.defense2008proxnew01 c.spend2008proxnew01 ///
			c.blackaid2008prox01 c.emission2008prox01 c.universal2008prox01##c.universal2008imp01 c.citizenship2008prox01 ///			
			pid01 i.ideol econ01  i.gender i.race age01 educ01 income01    [pweight=V080102]

	*Wald Test
		testparm c.universal2008imp01 c.universal2008prox01#c.universal2008imp01
	
	*Margins
		margins, dydx(universal2008prox01) at(universal2008imp01=(0(0.25)1)) saving(2008f2_universal, replace)
		
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Univ. Health Care:2008 (Form 2), size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
			graph save "Universal2008F2", replace
	
	*high vs. low
		margins if universal2008imp01 >=0 & universal2008imp01 <=0.5, dydx(universal2008prox01) post 
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(univ08_low.dta, replace)

		logit vote c.defense2008proxnew01 c.spend2008proxnew01 ///
			c.blackaid2008prox01 c.emission2008prox01 c.universal2008prox01##c.universal2008imp01 c.citizenship2008prox01 ///			
			pid01 i.ideol econ01  i.gender i.race age01 educ01 income01    [pweight=V080102]

		margins if universal2008imp01 ==1, dydx(universal2008prox01) post
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(univ08_high.dta, replace)

*Citizenship
	eststo: logit vote c.defense2008proxnew01 c.spend2008proxnew01 ///
			c.blackaid2008prox01 c.emission2008prox01 c.universal2008prox01 c.citizenship2008prox01##c.citizenship2008imp01 ///			
			pid01 i.ideol econ01  i.gender i.race age01 educ01 income01    [pweight=V080102]

	*Wald Test
		testparm c.citizenship2008imp01 c.citizenship2008prox01#c.citizenship2008imp01
	
	*Margins
		margins, dydx(citizenship2008prox01) at(citizenship2008imp01=(0(0.25)1)) saving(2008f2_citizenship, replace)
		
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Path Citizenship:2008 (Form 2), size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
			graph save "Path2008F2", replace
	
	*high vs low
		margins if citizenship2008imp01 >=0 & citizenship2008imp01 <=0.25, dydx(citizenship2008prox01) post
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(citi08_low.dta, replace)

		logit vote c.defense2008proxnew01 c.spend2008proxnew01 ///
			c.blackaid2008prox01 c.emission2008prox01 c.universal2008prox01 c.citizenship2008prox01##c.citizenship2008imp01 ///			
			pid01 i.ideol econ01  i.gender i.race age01 educ01 income01    [pweight=V080102]
		margins if citizenship2008imp01 >=0.75 & citizenship2008imp01 <=1, dydx(citizenship2008prox01) post 
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(citi08_high.dta, replace)

*Table
esttab using 2008_F2_Interactions.rtf, replace se pr2 aic bic onecell ///
		star(+ 0.10 * 0.05 ** 0.01) label nobaselevels addnote(Results are weighted:V080102) ///
		title({\b Table XX.} "Subjective Importance and Proximity Voting - 2008TS)")
	eststo clear
					
					
						
capture log close
		
		
		
			
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
	log using anes2008PA.log, replace
	set more off
	

/*************************
All interactions at once
*************************/
		
eststo clear
eststo: logit vote pid1001 i.ideol econ01  i.gender i.race  age01 educ01 income01   [pweight = WGTL11]
eststo: logit vote samesex10prox01 richtaxes10prox01 drugs10prox01 medic10prox01 habeas10prox01 phone10prox01 illeg10prox01 path10prox01 withdraw10prox01 ///
	pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight = WGTL11]
eststo: logit vote c.samesex10prox01##c.samesex10imp01 c.richtaxes10prox01##c.richtaxes10imp01 c.drugs10prox01##c.drugs10imp01 c.medic10prox01##c.medic10imp01 ///
	c.habeas10prox01##c.habeas10imp01 c.phone10prox01##c.phone10imp01 c.illeg10prox01##c.illeg10imp01 c.path10prox01##c.path10imp01 ///
	c.withdraw10prox01##c.withdraw10imp01 pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight = WGTL11]
	
*Wald Test				
	testparm c.samesex10imp01 c.samesex10prox01#c.samesex10imp01 ///
		c.richtaxes10imp01 c.richtaxes10prox01#c.richtaxes10imp01 ///
		c.drugs10imp01 c.drugs10prox01#c.drugs10imp01 ///
		c.medic10imp01 c.medic10prox01#c.medic10imp01 ///
		c.habeas10imp01 c.habeas10prox01#c.habeas10imp01 ///
		c.phone10imp01 c.phone10prox01#c.phone10imp01 ///
		c.illeg10imp01 c.illeg10prox01#c.illeg10imp01 ///
		c.path10imp01 c.path10prox01#c.path10imp01 ///
		c.withdraw10imp01 c.withdraw10prox01#c.withdraw10imp01

*Margins
	margins, dydx(samesex10prox01) at(samesex10imp01=(0(0.25)1)) saving(2008PAALLALL_samesex, replace)
	marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Same Sex Marriage:2008 Panel, size(medsmall)) scheme(s1mono) ///
		yline(0, lpattern(dash))
		graph save "SameSex2008PAALL", replace

	margins, dydx(richtaxes10prox01) at(richtaxes10imp01=(0(0.25)1)) saving(2008PAALLALL_richtaxes, replace)
	marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Taxes the Rich:2008 Panel, size(medsmall)) scheme(s1mono) ///
		yline(0, lpattern(dash))
		graph save "RichTaxes2008PAALL", replace
		
	margins, dydx(drugs10prox01) at(drugs10imp01=(0(0.25)1)) saving(2008PAALLALL_drugs, replace)
	marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Senior Drug Payment:2008 Panel, size(medsmall)) scheme(s1mono) ///
		yline(0, lpattern(dash))
		graph save "Drugs2008PAALL", replace						
		
	margins, dydx(medic10prox01) at(medic10imp01=(0(0.25)1)) saving(2008PAALLALL_medic, replace)
	marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title("Univ. Health Care:2008 Panel", size(medsmall)) scheme(s1mono) ///
		yline(0, lpattern(dash))
		graph save "Medic2008PAALL", replace						
		
	margins, dydx(habeas10prox01) at(habeas10imp01=(0(0.25)1)) saving(2008PAALLALL_habeas, replace)
	marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title("Terrorist Habeas Rights:2008 Panel", size(medsmall)) scheme(s1mono) ///
		yline(0, lpattern(dash))
		graph save "Habeas2008PAALL", replace					
		
	margins, dydx(phone10prox01) at(phone10imp01=(0(0.25)1)) saving(2008PAALLALL_phone, replace)
	marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title("Wiretaps:2008 Panel", size(medsmall)) scheme(s1mono) ///
		yline(0, lpattern(dash))
		graph save "Phone2008PAALL", replace						
		
		
	margins, dydx(illeg10prox01) at(illeg10imp01=(0(0.25)1)) saving(2008PAALLALL_illeg, replace)
	
	marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title("Work Stay Ill.Imm:2008 Panel", size(medsmall)) scheme(s1mono) ///
		yline(0, lpattern(dash))
		graph save "Illeg2008PAALL", replace					
		
	margins, dydx(path10prox01) at(path10imp01=(0(0.25)1)) saving(2008PAALLALL_path, replace)
	marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title("Path to Citi.:2008 Panel", size(medsmall)) scheme(s1mono) ///
		yline(0, lpattern(dash))
		graph save "Path2008PAALL", replace


	margins, dydx(withdraw10prox01) at(withdraw10imp01=(0(0.25)1)) saving(2008PAALLALL_withdraw, replace)
	marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title("Iraq Withdrawal:2008 Panel", size(medsmall)) scheme(s1mono) ///
		yline(0, lpattern(dash))
		graph save "Withdraw2008PAALL", replace
					
*High vs. Low
				
*same sex marriage

margins if samesex10imp01 >=0 & samesex10imp01 <=0.25, dydx(samesex10prox01) post 
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(samesex08_lowALL.dta, replace)

logit vote c.samesex10prox01##c.samesex10imp01 c.richtaxes10prox01##c.richtaxes10imp01 c.drugs10prox01##c.drugs10imp01 c.medic10prox01##c.medic10imp01 ///
c.habeas10prox01##c.habeas10imp01 c.phone10prox01##c.phone10imp01 c.illeg10prox01##c.illeg10imp01 c.path10prox01##c.path10imp01 ///
c.withdraw10prox01##c.withdraw10imp01 pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight = WGTL11]

margins if samesex10imp01 >=0.75 & samesex10imp01 <=1, dydx(samesex10prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(samesex08_highALL.dta, replace)

*Taxing the Rich
logit vote c.samesex10prox01##c.samesex10imp01 c.richtaxes10prox01##c.richtaxes10imp01 c.drugs10prox01##c.drugs10imp01 c.medic10prox01##c.medic10imp01 ///
c.habeas10prox01##c.habeas10imp01 c.phone10prox01##c.phone10imp01 c.illeg10prox01##c.illeg10imp01 c.path10prox01##c.path10imp01 ///
c.withdraw10prox01##c.withdraw10imp01 pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight = WGTL11]


margins if richtaxes10imp01 >=0 & richtaxes10imp01 <=0.25, dydx(richtaxes10prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(taxes08_lowALL.dta, replace)

logit vote c.samesex10prox01##c.samesex10imp01 c.richtaxes10prox01##c.richtaxes10imp01 c.drugs10prox01##c.drugs10imp01 c.medic10prox01##c.medic10imp01 ///
c.habeas10prox01##c.habeas10imp01 c.phone10prox01##c.phone10imp01 c.illeg10prox01##c.illeg10imp01 c.path10prox01##c.path10imp01 ///
c.withdraw10prox01##c.withdraw10imp01 pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight = WGTL11]

margins if richtaxes10imp01 >=0.75 & richtaxes10imp01 <=1, dydx(richtaxes10prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(taxes08_highALL.dta, replace)


*drugs
logit vote c.samesex10prox01##c.samesex10imp01 c.richtaxes10prox01##c.richtaxes10imp01 c.drugs10prox01##c.drugs10imp01 c.medic10prox01##c.medic10imp01 ///
c.habeas10prox01##c.habeas10imp01 c.phone10prox01##c.phone10imp01 c.illeg10prox01##c.illeg10imp01 c.path10prox01##c.path10imp01 ///
c.withdraw10prox01##c.withdraw10imp01 pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight = WGTL11]


margins if drugs10imp01 >=0 & drugs10imp01 <=0.25, dydx(drugs10prox01) post 
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(drugs08_lowALL.dta, replace)

logit vote c.samesex10prox01##c.samesex10imp01 c.richtaxes10prox01##c.richtaxes10imp01 c.drugs10prox01##c.drugs10imp01 c.medic10prox01##c.medic10imp01 ///
c.habeas10prox01##c.habeas10imp01 c.phone10prox01##c.phone10imp01 c.illeg10prox01##c.illeg10imp01 c.path10prox01##c.path10imp01 ///
c.withdraw10prox01##c.withdraw10imp01 pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight = WGTL11]

margins if drugs10imp01 >=0.75 & drugs10imp01 <=1, dydx(drugs10prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(drugs08_highALL.dta, replace)

*medical care
logit vote c.samesex10prox01##c.samesex10imp01 c.richtaxes10prox01##c.richtaxes10imp01 c.drugs10prox01##c.drugs10imp01 c.medic10prox01##c.medic10imp01 ///
c.habeas10prox01##c.habeas10imp01 c.phone10prox01##c.phone10imp01 c.illeg10prox01##c.illeg10imp01 c.path10prox01##c.path10imp01 ///
c.withdraw10prox01##c.withdraw10imp01 pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight = WGTL11]

margins if medic10imp01 >=0 & medic10imp01 <=0.5, dydx(medic10prox01) post 
	parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(medic08_lowALL.dta, replace)

logit vote c.samesex10prox01##c.samesex10imp01 c.richtaxes10prox01##c.richtaxes10imp01 c.drugs10prox01##c.drugs10imp01 c.medic10prox01##c.medic10imp01 ///
c.habeas10prox01##c.habeas10imp01 c.phone10prox01##c.phone10imp01 c.illeg10prox01##c.illeg10imp01 c.path10prox01##c.path10imp01 ///
c.withdraw10prox01##c.withdraw10imp01 pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight = WGTL11]

margins if medic10imp01 ==1, dydx(medic10prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(medic08_highALL.dta, replace)

*habeas
logit vote c.samesex10prox01##c.samesex10imp01 c.richtaxes10prox01##c.richtaxes10imp01 c.drugs10prox01##c.drugs10imp01 c.medic10prox01##c.medic10imp01 ///
c.habeas10prox01##c.habeas10imp01 c.phone10prox01##c.phone10imp01 c.illeg10prox01##c.illeg10imp01 c.path10prox01##c.path10imp01 ///
c.withdraw10prox01##c.withdraw10imp01 pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight = WGTL11]

margins if habeas10imp01 >=0 & habeas10imp01 <=0.25, dydx(habeas10prox01) post
	parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(habeas08_lowALL.dta, replace)

logit vote c.samesex10prox01##c.samesex10imp01 c.richtaxes10prox01##c.richtaxes10imp01 c.drugs10prox01##c.drugs10imp01 c.medic10prox01##c.medic10imp01 ///
c.habeas10prox01##c.habeas10imp01 c.phone10prox01##c.phone10imp01 c.illeg10prox01##c.illeg10imp01 c.path10prox01##c.path10imp01 ///
c.withdraw10prox01##c.withdraw10imp01 pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight = WGTL11]

margins if habeas10imp01 >=0.75 & habeas10imp01 <=1, dydx(habeas10prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(habeas08_highALL.dta, replace)

*phone tapping
logit vote c.samesex10prox01##c.samesex10imp01 c.richtaxes10prox01##c.richtaxes10imp01 c.drugs10prox01##c.drugs10imp01 c.medic10prox01##c.medic10imp01 ///
c.habeas10prox01##c.habeas10imp01 c.phone10prox01##c.phone10imp01 c.illeg10prox01##c.illeg10imp01 c.path10prox01##c.path10imp01 ///
c.withdraw10prox01##c.withdraw10imp01 pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight = WGTL11]

margins if phone10imp01 >=0 & phone10imp01 <=0.25, dydx(phone10prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(phone08_lowALL.dta, replace)

logit vote c.samesex10prox01##c.samesex10imp01 c.richtaxes10prox01##c.richtaxes10imp01 c.drugs10prox01##c.drugs10imp01 c.medic10prox01##c.medic10imp01 ///
c.habeas10prox01##c.habeas10imp01 c.phone10prox01##c.phone10imp01 c.illeg10prox01##c.illeg10imp01 c.path10prox01##c.path10imp01 ///
c.withdraw10prox01##c.withdraw10imp01 pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight = WGTL11]

margins if phone10imp01 >=0.75 & phone10imp01 <=1, dydx(phone10prox01) post
	parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(phone08_highALL.dta, replace)


*illegal immigrant work stay
logit vote c.samesex10prox01##c.samesex10imp01 c.richtaxes10prox01##c.richtaxes10imp01 c.drugs10prox01##c.drugs10imp01 c.medic10prox01##c.medic10imp01 ///
c.habeas10prox01##c.habeas10imp01 c.phone10prox01##c.phone10imp01 c.illeg10prox01##c.illeg10imp01 c.path10prox01##c.path10imp01 ///
c.withdraw10prox01##c.withdraw10imp01 pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight = WGTL11]

margins if illeg10imp01 >=0 & illeg10imp01 <=0.25, dydx(illeg10prox01) post 
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(ill08_lowALL.dta, replace)

logit vote c.samesex10prox01##c.samesex10imp01 c.richtaxes10prox01##c.richtaxes10imp01 c.drugs10prox01##c.drugs10imp01 c.medic10prox01##c.medic10imp01 ///
c.habeas10prox01##c.habeas10imp01 c.phone10prox01##c.phone10imp01 c.illeg10prox01##c.illeg10imp01 c.path10prox01##c.path10imp01 ///
c.withdraw10prox01##c.withdraw10imp01 pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight = WGTL11]

margins if illeg10imp01 >=0.75 & illeg10imp01 <=1, dydx(illeg10prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(ill08_highALL.dta, replace)

*path to citizenship
logit vote c.samesex10prox01##c.samesex10imp01 c.richtaxes10prox01##c.richtaxes10imp01 c.drugs10prox01##c.drugs10imp01 c.medic10prox01##c.medic10imp01 ///
c.habeas10prox01##c.habeas10imp01 c.phone10prox01##c.phone10imp01 c.illeg10prox01##c.illeg10imp01 c.path10prox01##c.path10imp01 ///
c.withdraw10prox01##c.withdraw10imp01 pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight = WGTL11]

margins if path10imp01 >=0 & path10imp01 <=0.25, dydx(path10prox01) post 
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(path08_lowALL.dta, replace)

logit vote c.samesex10prox01##c.samesex10imp01 c.richtaxes10prox01##c.richtaxes10imp01 c.drugs10prox01##c.drugs10imp01 c.medic10prox01##c.medic10imp01 ///
c.habeas10prox01##c.habeas10imp01 c.phone10prox01##c.phone10imp01 c.illeg10prox01##c.illeg10imp01 c.path10prox01##c.path10imp01 ///
c.withdraw10prox01##c.withdraw10imp01 pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight = WGTL11]

margins if path10imp01 >=0.75 & path10imp01 <=1, dydx(path10prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(path08_highALL.dta, replace)

*iraq withdrawal
logit vote c.samesex10prox01##c.samesex10imp01 c.richtaxes10prox01##c.richtaxes10imp01 c.drugs10prox01##c.drugs10imp01 c.medic10prox01##c.medic10imp01 ///
c.habeas10prox01##c.habeas10imp01 c.phone10prox01##c.phone10imp01 c.illeg10prox01##c.illeg10imp01 c.path10prox01##c.path10imp01 ///
c.withdraw10prox01##c.withdraw10imp01 pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight = WGTL11]

margins if withdraw10imp01 >=0 & withdraw10imp01 <=0.25, dydx(withdraw10prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(withdraw08_lowALL.dta, replace)

logit vote c.samesex10prox01##c.samesex10imp01 c.richtaxes10prox01##c.richtaxes10imp01 c.drugs10prox01##c.drugs10imp01 c.medic10prox01##c.medic10imp01 ///
c.habeas10prox01##c.habeas10imp01 c.phone10prox01##c.phone10imp01 c.illeg10prox01##c.illeg10imp01 c.path10prox01##c.path10imp01 ///
c.withdraw10prox01##c.withdraw10imp01 pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight = WGTL11]

margins if withdraw10imp01 >=0.75 & withdraw10imp01 <=1, dydx(withdraw10prox01) post
parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(withdraw08_highALL.dta, replace)
			
*Table
						
esttab using 2008__PA_Interactions_ALL.rtf, replace se pr2 aic bic onecell ///
	star(+ 0.10 * 0.05 ** 0.01) label nobaselevels addnote(Results are weighted:WGTL11) ///
	title({\b Table XX.} "Subjective Importance and Proximity - 2008-2009 Panel")
eststo clear	
	
	
	
/************************
One by One
************************/
*Missing Data for Base vs. Proximity
egen nmis = rowmiss(pid1001 ideol econ01 gender race  age01 educ01 income01 ///
	samesex10prox01 richtaxes10prox01 drugs10prox01 medic10prox01 habeas10prox01 ///
	phone10prox01 illeg10prox01 path10prox01 withdraw10prox01)


*Base vs. Proximity
eststo clear
eststo: logit vote pid1001 i.ideol econ01  i.gender i.race  age01 educ01 income01 if nmis == 0 [pweight = WGTL11]
eststo: logit vote samesex10prox01 richtaxes10prox01 drugs10prox01 medic10prox01 habeas10prox01 phone10prox01 illeg10prox01 path10prox01 withdraw10prox01 ///
	pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01 if nmis == 0 [pweight = WGTL11]
			
		*Wald
			testparm samesex10prox01 richtaxes10prox01 drugs10prox01 medic10prox01 habeas10prox01 ///
					phone10prox01 illeg10prox01 path10prox01 withdraw10prox01			
					
		*Margins
			margins, dydx(samesex10prox01 richtaxes10prox01 drugs10prox01 medic10prox01 habeas10prox01 ///
					phone10prox01 illeg10prox01 path10prox01 withdraw10prox01) saving(2008pa_proxame, replace)
									
			margins, dydx(*) saving(2008pa_allame, replace)
		
esttab using 2008_PA_Base_Prox.rtf, replace se pr2 aic bic onecell ///
	star(+ 0.10 * 0.05 ** 0.01) label nobaselevels addnote(Results are weighted: WGTL11) ///
	title({\b Table XX.} "Base and Proximity Models - 2008-2009 Panel")
eststo clear
estimates clear
	

*Interaction Models
*Same Sex Marriage
eststo clear
eststo: logit vote c.samesex10prox01##c.samesex10imp01 c.richtaxes10prox01 c.drugs10prox01 c.medic10prox01 ///
					c. habeas10prox01 c.phone10prox01 c.illeg10prox01 c.path10prox01 c.withdraw10prox01 ///
				pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight = WGTL11]
				
		*Wald Test
			testparm c.samesex10imp01 c.samesex10prox01#c.samesex10imp01
		
		*Margins
			
		margins, dydx(samesex10prox01) at(samesex10imp01=(0(0.25)1)) saving(2008pa_samesex, replace)
		
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title("Same Sex Marriage:2008 Panel", size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
			graph save "SameSex2008PA", replace
	
	*high vs. low
	
		margins if samesex10imp01 >=0 & samesex10imp01 <=0.25, dydx(samesex10prox01) post 
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(samesex08_low.dta, replace)
		
		logit vote c.samesex10prox01##c.samesex10imp01 c.richtaxes10prox01 c.drugs10prox01 c.medic10prox01 ///
					c. habeas10prox01 c.phone10prox01 c.illeg10prox01 c.path10prox01 c.withdraw10prox01 ///
				pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight = WGTL11]
		
		margins if samesex10imp01 >=0.75 & samesex10imp01 <=1, dydx(samesex10prox01) post
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(samesex08_high.dta, replace)



*Taxing the Rich
eststo: logit vote c.samesex10prox01 c.richtaxes10prox01##c.richtaxes10imp01 c.drugs10prox01 c.medic10prox01 ///
				c. habeas10prox01 c.phone10prox01 c.illeg10prox01 c.path10prox01 c.withdraw10prox01 ///
				pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight = WGTL11]
				
		*Wald Test
			testparm c.richtaxes10imp01 c.richtaxes10prox01#c.richtaxes10imp01
		
		*Margins
			
		margins, dydx(richtaxes10prox01) at(richtaxes10imp01=(0(0.25)1)) saving(2008pa_richtaxes, replace)
		
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Taxes the Rich:2008 Panel, size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
			graph save "RichTaxes2008PA", replace
	
	*high vs. low
		margins if richtaxes10imp01 >=0 & richtaxes10imp01 <=0.25, dydx(richtaxes10prox01) post
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(taxes08_low.dta, replace)

		logit vote c.samesex10prox01 c.richtaxes10prox01##c.richtaxes10imp01 c.drugs10prox01 c.medic10prox01 ///
				c. habeas10prox01 c.phone10prox01 c.illeg10prox01 c.path10prox01 c.withdraw10prox01 ///
				pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight = WGTL11]
									
		margins if richtaxes10imp01 >=0.75 & richtaxes10imp01 <=1, dydx(richtaxes10prox01) post
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(taxes08_high.dta, replace)


*Drugs
eststo: logit vote c.samesex10prox01 c.richtaxes10prox01 c.drugs10prox01##c.drugs10imp01 c.medic10prox01 ///
				c. habeas10prox01 c.phone10prox01 c.illeg10prox01 c.path10prox01 c.withdraw10prox01 ///
				pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight = WGTL11]
				
		*Wald Test
			testparm c.drugs10imp01 c.drugs10prox01#c.drugs10imp01
		
		*Margins
			
		margins, dydx(drugs10prox01) at(drugs10imp01=(0(0.25)1)) saving(2008pa_drugs, replace)
		
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Senior Drug Payment:2008 Panel, size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
			graph save "Drugs2008PA", replace
	
	*high vs. low
		margins if drugs10imp01 >=0 & drugs10imp01 <=0.25, dydx(drugs10prox01) post 
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(drugs08_low.dta, replace)

		 logit vote c.samesex10prox01 c.richtaxes10prox01 c.drugs10prox01##c.drugs10imp01 c.medic10prox01 ///
				c. habeas10prox01 c.phone10prox01 c.illeg10prox01 c.path10prox01 c.withdraw10prox01 ///
				pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight = WGTL11]
		margins if drugs10imp01 >=0.75 & drugs10imp01 <=1, dydx(drugs10prox01) post
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(drugs08_high.dta, replace)



*Medic
eststo: logit vote c.samesex10prox01 c.richtaxes10prox01 c.drugs10prox01 c.medic10prox01##c.medic10imp01 ///
				c. habeas10prox01 c.phone10prox01 c.illeg10prox01 c.path10prox01 c.withdraw10prox01 ///
				pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight = WGTL11]
				
		*Wald Test
			testparm c.medic10imp01 c.medic10prox01#c.medic10imp01
		
		*Margins
			
		margins, dydx(medic10prox01) at(medic10imp01=(0(0.25)1)) saving(2008pa_medic, replace)
		
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title("Universal Health Care:2008 Panel", size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
			graph save "Medic2008PA", replace

		*high vs. low
		margins if medic10imp01 >=0 & medic10imp01 <=0.5, dydx(medic10prox01) post 
							parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(medic08_low.dta, replace)

		logit vote c.samesex10prox01 c.richtaxes10prox01 c.drugs10prox01 c.medic10prox01##c.medic10imp01 ///
				c. habeas10prox01 c.phone10prox01 c.illeg10prox01 c.path10prox01 c.withdraw10prox01 ///
				pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight = WGTL11]
				
							
		margins if medic10imp01 ==1, dydx(medic10prox01) post
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(medic08_high.dta, replace)


*Habeas
	eststo: logit vote c.samesex10prox01 c.richtaxes10prox01 c.drugs10prox01 c.medic10prox01 ///
				c.habeas10prox01##c.habeas10imp01 c.phone10prox01 c.illeg10prox01 c.path10prox01 c.withdraw10prox01 ///
				pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight = WGTL11]
				
		*Wald Test
			testparm c.habeas10imp01 c.habeas10prox01#c.habeas10imp01
		
		*Margins
			
		margins, dydx(habeas10prox01) at(habeas10imp01=(0(0.25)1)) saving(2008pa_habeas, replace)
		
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title(Habeas Rights:2008 Panel, size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
			graph save "Habeas2008PA", replace
	*high s. low
		margins if habeas10imp01 >=0 & habeas10imp01 <=0.25, dydx(habeas10prox01) post
							parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(habeas08_low.dta, replace)

		logit vote c.samesex10prox01 c.richtaxes10prox01 c.drugs10prox01 c.medic10prox01 ///
				c.habeas10prox01##c.habeas10imp01 c.phone10prox01 c.illeg10prox01 c.path10prox01 c.withdraw10prox01 ///
				pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight = WGTL11]
		margins if habeas10imp01 >=0.75 & habeas10imp01 <=1, dydx(habeas10prox01) post
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(habeas08_high.dta, replace)

		
*Phone
	eststo: logit vote c.samesex10prox01 c.richtaxes10prox01 c.drugs10prox01 c.medic10prox01 ///
				c.habeas10prox01 c.phone10prox01##c.phone10imp01 c.illeg10prox01 c.path10prox01 c.withdraw10prox01 ///
				pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight = WGTL11]
				
		*Wald Test
			testparm c.phone10imp01 c.phone10prox01#c.phone10imp01
		*Margins
			
		margins, dydx(phone10prox01) at(phone10imp01=(0(0.25)1)) saving(2008pa_phone, replace)
		
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title("Wiretaps:2008 Panel", size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
			graph save "Phone2008PA", replace
	
		*high vs. low
		
		margins if phone10imp01 >=0 & phone10imp01 <=0.25, dydx(phone10prox01) post
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(phone08_low.dta, replace)

		logit vote c.samesex10prox01 c.richtaxes10prox01 c.drugs10prox01 c.medic10prox01 ///
				c.habeas10prox01 c.phone10prox01##c.phone10imp01 c.illeg10prox01 c.path10prox01 c.withdraw10prox01 ///
				pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight = WGTL11]
		margins if phone10imp01 >=0.75 & phone10imp01 <=1, dydx(phone10prox01) post
							parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(phone08_high.dta, replace)



*Illeg
eststo: logit vote c.samesex10prox01 c.richtaxes10prox01 c.drugs10prox01 c.medic10prox01 ///
				c.habeas10prox01 c.phone10prox01 c.illeg10prox01##c.illeg10imp01 c.path10prox01 c.withdraw10prox01 ///
				pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight = WGTL11]
				
		*Wald Test
			testparm c.illeg10imp01 c.illeg10prox01#c.illeg10imp01
		
		*Margins
			
		margins, dydx(illeg10prox01) at(illeg10imp01=(0(0.25)1)) saving(2008pa_illeg, replace)
		
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title("Work Stay:2008 Panel", size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
			graph save "Illeg2008PA", replace
	
		margins if illeg10imp01 >=0 & illeg10imp01 <=0.25, dydx(illeg10prox01) post 
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(ill08_low.dta, replace)

		logit vote c.samesex10prox01 c.richtaxes10prox01 c.drugs10prox01 c.medic10prox01 ///
				c.habeas10prox01 c.phone10prox01 c.illeg10prox01##c.illeg10imp01 c.path10prox01 c.withdraw10prox01 ///
				pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight = WGTL11]
				
		margins if illeg10imp01 >=0.75 & illeg10imp01 <=1, dydx(illeg10prox01) post
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(ill08_high.dta, replace)

		
*Path
eststo: logit vote c.samesex10prox01 c.richtaxes10prox01 c.drugs10prox01 c.medic10prox01 ///
				c.habeas10prox01 c.phone10prox01 c.illeg10prox01 c.path10prox01##c.path10imp01 c.withdraw10prox01 ///
				pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight = WGTL11]
				
		*Wald Test
			testparm c.path10imp01 c.path10prox01#c.path10imp01
		
		*Margins
			
		margins, dydx(path10prox01) at(path10imp01=(0(0.25)1)) saving(2008pa_path, replace)
		
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title("Path to Citizenship:2008 Panel", size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
			graph save "Path2008PA", replace

		*high vs. low 
		margins if path10imp01 >=0 & path10imp01 <=0.25, dydx(path10prox01) post 
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(path08_low.dta, replace)

		logit vote c.samesex10prox01 c.richtaxes10prox01 c.drugs10prox01 c.medic10prox01 ///
				c.habeas10prox01 c.phone10prox01 c.illeg10prox01 c.path10prox01##c.path10imp01 c.withdraw10prox01 ///
				pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight = WGTL11]

		margins if path10imp01 >=0.75 & path10imp01 <=1, dydx(path10prox01) post
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(path08_high.dta, replace)



*Withdraw
	eststo: logit vote c.samesex10prox01 c.richtaxes10prox01 c.drugs10prox01 c.medic10prox01 ///
				c.habeas10prox01 c.phone10prox01 c.illeg10prox01 c.path10prox01 c.withdraw10prox01##c.withdraw10imp01 ///
				pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight = WGTL11]
				
		*Wald Test
			testparm c.withdraw10imp01 c.withdraw10prox01#c.withdraw10imp01
		
		*Margins
			
		margins, dydx(withdraw10prox01) at(withdraw10imp01=(0(0.25)1)) saving(2008pa_withdraw, replace)
		
		marginsplot, ytitle("") xtitle("") xlabel(0 "Min" 1 "Max") title("Iraq Withdrawl:2008 Panel", size(medsmall)) scheme(s1mono) ///
			yline(0, lpattern(dash))
			graph save "Withdraw2008PA", replace

		*high vs. low 
		margins if withdraw10imp01 >=0 & withdraw10imp01 <=0.25, dydx(withdraw10prox01) post
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(withdraw08_low.dta, replace)

		
		logit vote c.samesex10prox01 c.richtaxes10prox01 c.drugs10prox01 c.medic10prox01 ///
				c.habeas10prox01 c.phone10prox01 c.illeg10prox01 c.path10prox01 c.withdraw10prox01##c.withdraw10imp01 ///
				pid1001 i.ideol econ01  i.gender i.race age01 educ01 income01   [pweight = WGTL11]
				
		margins if withdraw10imp01 >=0.75 & withdraw10imp01 <=1, dydx(withdraw10prox01) post
		parmest, format(estimate min95 max95) ev(_N _N_subp) es(N) saving(withdraw08_high.dta, replace)



*Table
	esttab using 2008_PA_Interactions.rtf, replace se pr2 aic bic onecell ///
		star(+ 0.10 * 0.05 ** 0.01) label nobaselevels addnote(Results are weighted:WGTL11) ///
		title({\b Table XX.} "Subjective Importance and Proximity - 2008-2009 (Panel)")
	eststo clear
					
			
			

		
						
capture log close


								***********************************
								***********************************
								***********************************
								***********Combined Proximity******
								***********Results*****************
								***********************************
								***********************************
								***********************************		

clear
append using "1980_proxame.dta" "1984_proxame.dta" "1996_proxame.dta" ///
	"2000_proxame.dta" "2004_proxame.dta" "2008_proxame.dta" "2008f2_proxame.dta" "2008pa_proxame.dta"

drop _term _at _atopt
rename _margin ame
rename _se se
rename _statistic z
rename _pvalue p 
rename _ci_lb low
rename _ci_ub high
save "Proximity Effects - ANES.dta", replace
clear


								***********************************
								***********************************
								***********************************
								***********Figures*****************
								***********************************
								***********************************
								***********************************		


*Interactions: Figures 1 & 2

graph combine "Defense1980ALL" "Spend1980ALL" "Abortion1980ALL" "BlackAid1980ALL" "Unemploy1980ALL" "Jobs1980ALL" "Russia1980ALL" ///
		"Spend1984ALL" "Jobs1984ALL"  "Central1984ALL" "Women1984ALL" ///
		"Spend1996ALL"  "Defense1996ALL" "Aid Blacks1996ALL" "Abortion1996ALL" "Enviro1996ALL" ///
		"Abortion2000(ALL)" "Guns2000(ALL)" "Env.Regulation2000(ALL)" ///
		"Defense2004ALL"  "Spend2004ALL" "Jobs2004ALL" "AidBlacks2004ALL" "EnviroJobs2004ALL" , scheme(s1mono) rows(4) ycommon 
		
		
		graph save "Interactions (all inc model, first 24 ycommon).gph", replace
		graph export "Interactions (all inc model, first 24 ycommon).png", replace


		
	graph combine 	"Guns2004ALL" "Women2004ALL" ///
		"Defense2008F1ALL" "Spend2008F1ALL" "Jobs2008F1ALL" "AidBlacks2008F1ALL" "EnviroJobs2008F1ALL" "Health2008F1ALL" "Women2008F1ALL" 			///
		"Defense2008F2ALL" "Spend2008F2ALL" "BlackAid2008F2ALL" "Emission2008F2ALL" "Universal2008F2ALL" "Path2008F2ALL" ///
		"SameSex2008PAALL" "RichTaxes2008PAALL" "Drugs2008PAALL" "Medic2008PAALL" "Habeas2008PAALL" "Phone2008PAALL" "Illeg2008PAALL" ///
		"Path2008PAALL" "Withdraw2008PAALL", scheme(s1mono) rows(4) ycommon

	graph save "Interactions (all inc model, second 24 ycommon ycommon).gph", replace
	graph export "Interactions (all inc model, second 24 ycommon ycommon).png", replace

			
*Proximity: Figure OC2

combomarginsplot 1980_proxame 1984_proxame 1996_proxame 2000_proxame ///
	2004_proxame 2008_proxame 2008f2_proxame 2008pa_proxame , ///
	by(_filenumber) scheme(s1mono) ///
	labels("1980" "1984" "1996" "2000" "2004" "2008 (Form 1)" "2008 (Form 2)" "2008 (Panel)") ///
	yline(0, lpattern(dash)) recast(scatter) xtitle("") xlabel("") ///
	byopts(title("Average Marginal Effects" "of Relative Proximity with 95% CI"))
	
	graph save "Proximity Combined.gph", replace
	graph export "Proximity Combined.png", replace
	
	
combomarginsplot 1980_proxame 1984_proxame 1996_proxame 2000_proxame ///
	2004_proxame 2008_proxame 2008f2_proxame 2008pa_proxame , ///
	by(_filenumber) scheme(s1mono) horizontal ///
	labels("1980" "1984" "1996" "2000" "2004" "2008 (Form 1)" "2008 (Form 2)" "2008 (Panel)") ///
	xline(0, lpattern(dash)) recast(scatter) xtitle("") ytitle("") ylabel("") ///
	byopts(title("Average Marginal Effects" "of Relative Proximity with 95% CI") rows(2))

	graph save "Proximity Combined (horizontal).gph", replace
	graph export "Proximity Combined (horizontal).png", replace	
		
		
		
		
		
		
	
				
	

