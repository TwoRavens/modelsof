*************************************************************
* The Corrosive Effect of Corruption in Trust in Politicians
* Last updated: 17/04/2017
*************************************************************

* Introduce path where files have been saved" 
cd ""




* Data management: Lines 16-97
* Figures and tables included in paper: Lines 101-152
* Appendixes tables and figures: Lines 153-386
version 13.1
******************
* Loading dataset
******************
use ess_6_spain.dta, clear

******************
* Data management
******************
* Generating the D_exposure_barcenas variable
gen D_exposure_barcenas = . 
tab1 inwdds inwmms   
recode D_exposure_barcenas (.=0) if inwmms == 1 & inwdds < 31
recode D_exposure_barcenas (.=1) if inwmms > 1 
recode D_exposure_barcenas (.=1) if inwmms == 1 & inwdds == 31
recode D_exposure_barcenas (1=.) if inwmms > 2

* Time variable for the months of January and February
gen time = inwdds 
replace time = . if D_exposure_barcenas == . 
replace time = (time - 31) if D_exposure_barcenas == 0
replace time = 0 if time == 31


* Time variable for the whole survey fieldwork period 
tab1 inwdds inwmms   
gen time_whole=time
replace time_whole= 28 + inwdds if inwmms==3
replace time_whole= 59 + inwdds if inwmms==4
replace time_whole= 89 + inwdds if inwmms==5

* Alternative D_exposure_barcenas variable considering the whole survey fieldwork (to study decay of the D_exposure_barcenas effect)
gen treatment1 = . 
tab1 inwdds inwmms   
recode treatment1 (.=0) if inwmms == 1 & inwdds < 31
recode treatment1 (.=1) if inwmms > 1 
recode treatment1 (.=1) if inwmms == 1 & inwdds == 31


* Time variable with positive values for the whole fieldwork period (for simulation)
gen fieldwork_time = time_whole + 8 

* Dummies for party voted to 
tab prtvtces, m gen(party_voted)

* Recoding activty variabe and generating dummies
recode mnactic (4=3) (6=5) (8=5), gen(employment)
ta employment, gen(activity_rec_)
label def employment 1"Paid Work" 2"In education" 3"Unemployed" 5"Out of labor market" 9"Other"
label val employment employment
rename activity_rec_1 emp_paid_work
rename activity_rec_2 emp_in_education
rename activity_rec_3 emp_unemployed
rename activity_rec_4 emp_out_labor
rename activity_rec_5 emp_other


* Elections winner variable (coded 1 for PP voters)
gen election_winner =party_voted1

* Number of times a respondent refused to answer to the survey (reachability bias). From ESS paradata
foreach var of varlist outnic1-outnic69{
	recode `var' (1=0) (2=1) (3/13=.)
}
egen refusals = rowtotal(outnic1-outnic69)

* Voting and abstention 
recode vote (3=.) (2=0)

* Encoding regions 
encode region, gen(regionnum)

* Identifying regions that are only present in D_exposure_barcenas = 1 
gen region_treatment = 0
forval i = 1/18{
	sum D_exposure_barcenas if regionnum == `i'
	recode region_treatment (0=1) if `r(mean)' < 1 & regionnum == `i'
}


* Saving the recoded dataset to run simulations 
save ess_6_spain_recoded.dta, replace 



																		  *************
***********************************************
* Table 1: Balance tests D_exposure_barcenas Vs. control 
***********************************************
* T-tests
foreach var of varlist eduyrs gndr agea emp_paid_work emp_in_education emp_unemployed emp_out_labor election_winner  {
	sum `var' if D_exposure_barcenas != .
	ttest `var', by(D_exposure_barcenas)
}

**************************
* Figure 1: Google trends 
**************************
preserve
use g_trends.dta, clear
graph twoway (line caso_barcenas_searches day, xline(19389) xlabel(19359 19390 19418 19449 19479, format("%td")) ///
xtitle("Month") ytitle("Relative Google searches") graphregion(color(white)))
restore 

*********************************
* Figure 2: Descriptive evidence 
*********************************
graph twoway (hist time, discrete yscale(alt)) (lpoly trstplt time if D_exposure_barcenas==0,kernel(gau) bwidth(2) yaxis(2) yscale(alt axis(2))) ///
(lpoly trstplt time if D_exposure_barcenas==1,kernel(gau)  bwidth(2) yaxis(2)) 

*************************************************************************
* Table 2: Regression analysis for basic D_exposure_barcenas effects (H1)
*************************************************************************
* Model-1
reg trstplt i.D_exposure_barcenas
* Model-2
reg trstplt i.D_exposure_barcenas i.election_winner i.gndr eduyrs agea i.employment i.regionnum 
* Model-3
reg trstplt i.D_exposure_barcenas##i.election_winner i.gndr eduyrs agea i.employment  i.regionnum 


*********************************************************************************
* Figure 3: Regression analysis for decay of the D_exposure_barcenas effect (H2)
*********************************************************************************
*Decay of the effect over time
forvalues i = 0(5)95 {
display `i'
reg trstplt i.treatment1 i.election_winner i.gndr eduyrs agea i.employment i.regionnum  if time_whole< 7 + `i'
}

* Footnote 5 (balance tests for the enlarged treatment group that includes the whole survey fieldwork)
foreach var of varlist eduyrs gndr agea emp_paid_work emp_in_education emp_unemployed emp_out_labor election_winner  {
	sum `var' if treatment1 != .
	ttest `var', by(treatment1)
}

																		*******************

**************
* Appendix B
**************																		
																		
* Testing the effects with two control groups measuring those interviewed in February and afterwards
gen barcenas_3_groups = . 

recode barcenas_3_groups (.=0) if inwmms == 1 & inwdds < 31
recode barcenas_3_groups (.=1) if inwmms == 1 & inwdds == 31
recode barcenas_3_groups (.=1) if inwmms == 2 
recode barcenas_3_groups (.=2) if inwmms > 2 


reg trstplt i.barcenas_3_groups i.election_winner i.gndr eduyrs agea i.employment i.regionnum 

* Figure A1

margins, at(barcenas_3_groups=(0 1 2))

marginsplot, horizontal recast(scatter)

																		
********************************
* Appendix C: Robustness checks
********************************
* Table A2 model 4: Results controlling for the number of refusals (reachability)
reg trstplt i.D_exposure_barcenas i.election_winner i.gndr refusals  eduyrs agea i.employment i.regionnum


* Table A2 models 5 and 6: Results including only those regions that can be found in both D_exposure_barcenas and control group 
	* Model 5
reg trstplt i.D_exposure_barcenas i.election_winner i.gndr eduyrs agea i.employment i.regionnum if region_treatment == 1 

	* Model 6
reg trstplt i.D_exposure_barcenas##i.election_winner  i.gndr eduyrs agea i.employment i.regionnum if region_treatment == 1 

	* Check of the results of the decay of the D_exposure_barcenas effect (only commented in appendix but not presented) 
forvalues i = 0(5)95 {
display `i'
reg trstplt i.treatment1 i.election_winner i.gndr eduyrs agea i.employment i.regionnum if time_whole< 7 + `i' & region_treatment == 1 
}

* Table A3: Inclusions of regions in D_exposure_barcenas and control groups
tab regionnum region_treatment

* Table A5: The effect of the D_exposure_barcenas on variables that should not be related to it 
	* Model-7: Trust in the UN
reg trstun D_exposure_barcenas i.gndr eduyrs agea i.employment i.election_winner i.regionnum

	* Model-8: Gov't poverty reduction
reg gvctzpv D_exposure_barcenas i.gndr eduyrs agea i.employment i.election_winner i.regionnum

** Alternative estimation methods: Matching: 

	* Table A7: Coarsened exact matching
	
	* Model 13
preserve 
drop if	eduyrs == . | agea ==. | election_winner == . | emp_paid_work == . | emp_in_education == . | emp_unemployed == . | emp_out_labor == . | emp_other == . | D_exposure_barcenas == . 
imb gndr eduyrs agea election_winner emp_paid_work emp_in_education emp_unemployed emp_out_labor emp_other, treatment(D_exposure_barcenas)
cem gndr eduyrs agea election_winner emp_paid_work emp_in_education emp_unemployed emp_out_labor emp_other, treatment(D_exposure_barcenas)
reg trstplt D_exposure_barcenas [iweight = cem_weights]
restore

	* Model 14
preserve 
drop if	eduyrs == . | agea ==. | election_winner == . | emp_paid_work == . | emp_in_education == . | emp_unemployed == . | emp_out_labor == . | emp_other == . | D_exposure_barcenas == . 
drop if region_treatment != 1
imb gndr eduyrs agea election_winner emp_paid_work emp_in_education emp_unemployed emp_out_labor emp_other, treatment(D_exposure_barcenas)
cem gndr eduyrs agea election_winner emp_paid_work emp_in_education emp_unemployed emp_out_labor emp_other, treatment(D_exposure_barcenas)
reg trstplt D_exposure_barcenas [iweight = cem_weights]
restore


	* Table A8: Entropy balancing

ebalance D_exposure_barcenas gndr eduyrs agea ib9.employment election_winner,  targets(1) generate(balance1)

ebalance D_exposure_barcenas gndr eduyrs agea ib9.employment election_winner if region_treatment == 1,  targets(1) generate(balance2)


	* Model 15
reg trstplt D_exposure_barcenas [pweight = balance1] 

	* Model 16
reg trstplt D_exposure_barcenas if region_treatment == 1 [pweight = balance2]



** Alternative estimation methods: RDD: Table A9 
rd trstplt time , gr noscatter cluster(regionnum) 


** Simulation of placebo events: 
program drop _all 
postfile simulation mean using simulation_output.dta, replace
postfile simulation2 n_equal using simulation_output2.dta, replace
postfile simulation3 n_zero using simulation_output3.dta, replace
program randevents
	use ess_6_spain_recoded.dta, clear
	gen n = _n // genearting n to capture the random number assigned always to the first case 
	generate ui = floor((81-8+1)*runiform() + 8) // generating random day for the event between 8 and 81 to ensure that at least there are always 8 day in control and 28 in D_exposure_barcenas
	sum ui if n == 1 // summarizing the random day for the event
	gen random = `r(mean)' // capturing the random day for the event 
	sum random  // summarizing the random day for the event in order to do a historgram of the event days 
	post simulation (r(mean))  // posting into a separate dataset the random day of the event in order to do a histogram with the random days 
	sum random if random >0 & random <8
	post simulation2 (r(N)) 
	sum random if random == 0
	post simulation3 (r(N)) 
	gen fake_treatment = 1 // generating the variable for fake D_exposure_barcenas 
	recode fake_treatment (1=0) if random >= fieldwork_time // recoding the fake D_exposure_barcenas variable into D_exposure_barcenas and control groups
	gen minimum = random - 8 // generating variable so only those interviewed 8 days before of the event are included in the control group
	gen maximum = random + 28 // generating variable so only those interviewed 28 days after the event are included in the D_exposure_barcenas grouo
	recode fake_treatment (0=.) if fieldwork_time < minimum // recoding the D_exposure_barcenas variable so that if tulfills these conditions
	recode fake_treatment (1=.) if fieldwork_time > maximum // recoding the D_exposure_barcenas variable so that it fulfills these conditions 
	reg trstplt fake_treatment i.gndr eduyrs agea i.employment i.election_winner i.regionnum // model estimation 
end 

set seed 546756345 // seed seting 
simulate _b[fake_treatment] _se[fake_treatment], reps(1000): randevents // parameters to store after the simulation  
postclose simulation
postclose simulation2
postclose simulation3

* Table A4: Analysis of the results of the simulation 
gen tstat =  _sim_1 / _sim_2
gen higher =  _sim_1
recode higher (nonmissing = 0) if higher > -0.451
recode higher (nonmissing = 1) if higher <= -0.451
gen higher_sign = higher
recode higher_sign (1=0) if tstat >=-1.96
gen higher_higher = higher
recode higher_higher (1=0) if tstat >= -2.6763878

sum _sim_1 higher higher_sign higher_higher

* Figure A2: Histogram of simulated events
use simulation_output.dta, clear
replace mean = mean - 8 
hist mean 


** Placebo event during the fieldwork of ESS-7: Table A6
use ESS7ES.dta, clear
do ESS_miss.do 

* Generating the treatment variable for the placebo treatment to occurr 8 days after the start of the fieldwork and the control the subsequent 28 days
tab1 inwdds inwmms
tab inwdds inwmms

gen D_exposure_barcenas = . 
tab1 inwdds inwmms   
recode D_exposure_barcenas (.=0) if inwmms == 1 & inwdds < 31
recode D_exposure_barcenas (.=1) if inwmms > 1 
recode D_exposure_barcenas (.=1) if inwmms == 1 & inwdds == 31
recode D_exposure_barcenas (1=.) if inwmms > 2
recode D_exposure_barcenas (1=.) if inwmms == 2 & inwdds > 28

tab D_exposure_barcenas

* Encoding regions 
encode region, gen(regionnum)

* Recoding activty variabe and generating dummies
recode mnactic (4=3) (6=5) (8=5), gen(employment)
ta employment, gen(activity_rec_)
label def employment 1"Paid Work" 2"In education" 3"Unemployed" 5"Out of labor market" 9"Other"
label val employment employment
rename activity_rec_1 emp_paid_work
rename activity_rec_2 emp_in_education
rename activity_rec_3 emp_unemployed
rename activity_rec_4 emp_out_labor
rename activity_rec_5 emp_other


* Election election_winner variable 
gen election_winner = 0
replace election_winner = 1 if prtvtces == 1

* Table A6: Replication using ESS-7
	* Model-9
reg trstplt i.D_exposure_barcenas i.election_winner i.gndr eduyrs agea i.employment i.regionnum

	* Model-10
reg trstplt i.D_exposure_barcenas##i.election_winner i.gndr eduyrs agea i.employment i.regionnum 




** Placebo event during the fieldwork of ESS-7 in Denmark: Table A6
use ESS6DK.dta, clear
do ESS_miss.do 


* Generating the treatment variable for the placebo treatment to occurr 8 days after the start of the fieldwork and the control the subsequent 28 days
tab1 inwdds inwmms
tab inwdds if inwmms == 1
tab inwdds if inwmms == 2

* Generating the treatment variable to cover the same days as in Spain
gen D_exposure_barcenas = . 
replace D_exposure_barcenas = 0 if inwdds >= 23 & inwdds <= 30 & inwmms == 1
replace D_exposure_barcenas = 1 if inwdds == 31 & inwmms == 1
replace D_exposure_barcenas = 1 if inwmms == 2 

* Encoding regions 
encode region, gen(regionnum)

* Recoding activty variabe and generating dummies
recode mnactic (4=3) (6=5) (8=5)(7=.), gen(employment)
ta employment, gen(activity_rec_)
label def employment 1"Paid Work" 2"In education" 3"Unemployed" 5"Out of labor market" 9"Other"
label val employment employment
rename activity_rec_1 emp_paid_work
rename activity_rec_2 emp_in_education
rename activity_rec_3 emp_unemployed
rename activity_rec_4 emp_out_labor
rename activity_rec_5 emp_other

* Election election_winner variable (to make it comparable to Spain only voters of the prime minister party are coded as 1)
gen election_winner = 0
replace election_winner = 1 if 	prtvtcdk == 7

* Table A6: Replication using ESS-6 for Denmark (coinciding fieldwork period) 
	* Model-11
reg trstplt i.D_exposure_barcenas i.election_winner i.gndr eduyrs agea i.employment i.regionnum


	* Model-12
reg trstplt i.D_exposure_barcenas##i.election_winner i.gndr eduyrs agea i.employment i.regionnum 

