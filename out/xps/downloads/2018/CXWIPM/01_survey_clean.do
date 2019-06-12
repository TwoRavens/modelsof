
set more off

/*
NOTE ON SURVEY DATA: About 6000 people were surveyed at baseline.  
Another 6000 were treated (publicly or privately), but were not surveyed
About 3000 are in the sample at endline
*/

*keep endlineeq6 endlineeq3 condition block typet3 typet4 surveycb29 surveycb31 surveycb33 overall_departememt surveycb19 surveycb18 dosage commune urban quartier

**** Treatment variables ********
	
tab condition, missing

	gen control=0 if condition=="T1T4"|condition=="T1T3"|condition=="T2T3"|condition=="T2T4"
	replace control=1 if condition=="Control + Survey"
	tab control ,missing
	
* create treatment indicator
gen treatment=0
replace treatment=1 if control!=1
tab treatment, missing

** indicators for treatment conditions
encode condition, gen(condition_numeric) // private is 2 and 4, public is 3 and 5, control is 1
tab condition_numeric, missing 	

* some people were treated but not surveyed
generate nosurvey=0
replace nosurvey=1 if typet3==3 | typet4==2

gen infoonly=.
replace infoonly=1 if condition=="T1T3" | condition=="T1T4"
replace infoonly=0 if condition=="T2T3" | condition=="T2T4" | control==1
tab infoonly, missing

gen civics=.
replace civics=1 if condition=="T2T3" | condition=="T2T4"
replace civics=0 if condition=="T1T3" | condition=="T1T4" | control==1
tab civics, missing

**** Indicator for block
replace block = 4 if dosage==0 // villages in low dose all in same block

egen blid = group(commune block)  // generate block that combines block/commune


****** DV: vote for incumbent at endline
* also do self reported turnout (for appendix)

tab endlineeq6
recode endlineeq6 (98 99 = .), gen(incumbent_vote)

recode endlineeq3 (98 99 3= .), gen(turnout)

***********************************************
** Define "good" information, relative to priors
	** If don't know, we code based on whether legislator was better or worse than local
	** If priors = information, we code based on whether prior was negative or positive
		* rational is information would strengthen belief in prior if the same

recode surveycb29 (99=.) (4=1) (3=2) (2=3) (1=4), gen (performanceplenary) 
recode surveycb31 (99=.) (4=1) (3=2) (2=3) (1=4), gen (performancecommittee) 
recode surveycb33 (99=.) (4=1) (3=2) (2=3) (1=4), gen (performanceboth) 
		
tab performanceboth, missing // this is the prior on overall performance, ranging from 1 (worst prior) to 4 (best prior)
rename overall_departememt overall_departement
tab overall_departement, missing // this is the info we provided, ranging from 1 (best perf) to 4 (worst perf)
recode overall_departement (99=.) (4=1) (3=2) (2=3) (1=4), gen (overall_dept_recode)
gen goodnewsrelative2=1 if (performanceboth==1 & overall_dept_recode>1) | (performanceboth==2 & overall_dept_recode>2) | (performanceboth==3 & overall_dept_recode>2) | (performanceboth==4 & overall_dept_recode==4)
replace goodnewsrelative2=0 if (performanceboth==1 & overall_dept_recode==1) | (performanceboth==2 & overall_dept_recode<3) | (performanceboth==3 & overall_dept_recode<3) | (performanceboth==4 & overall_dept_recode<4)
replace goodnewsrelative2=1 if (performanceboth==. & overall_dept_recode==3) | (performanceboth==. & overall_dept_recode==4)
replace goodnewsrelative2=0 if (performanceboth==. & overall_dept_recode==2) | (performanceboth==. & overall_dept_recode==1)
tab goodnewsrelative2, missing
summarize goodnewsrelative2

** Also create good news measure that corresponds with Admin
	* not conditional on priors

gen goodnews = 0 if overall_dept_recode==1 | overall_dept_recode==2
	replace goodnews = 1 if overall_dept_recode==3 | overall_dept_recode==4


********************************************
** Create dummy indicators for each Prior category (to use as control)
capture tab surveycb33, gen(p)	 // overall prior -- will include control that also has indicator for don't knows
label variable p1 "Prior --- Much better"
label variable p2 "Prior --- A little better"
label variable p3 "Prior --- A little worse"
label variable p4 "Prior --- Much worse"
label variable p5 "Prior --- Do not know"

****************************************************
** ***** Measure of of prior vote for incumbent (partisanship) 

** Merge in information about the incumbent's political party
tempfile temp2
save `temp2', replace

insheet using "communes.csv", names clear
rename commune_key commune
rename party incumbent_party2011

sort commune

merge 1:m commune  using `temp2'

tab incumbent_party2011
tab surveycb19

generate votedincumbent2011=0 if surveycb18==1
replace votedincumbent2011=1 if surveycb19=="FCBE" & incumbent_party=="FCBE"
replace votedincumbent2011=1 if surveycb19=="Cauris" & incumbent_party=="FCBE"
replace votedincumbent2011=1 if surveycb19=="UN" & incumbent_party=="UN"
replace votedincumbent2011=1 if surveycb19=="G13" & incumbent_party=="G13"
replace votedincumbent2011=1 if surveycb19=="AFU" & incumbent_party=="AFU"
replace votedincumbent2011=1 if surveycb19=="UPR" & incumbent_party=="FE UPR"

label var votedincumbent2011 "2011 Incumbent Vote"

	recode  surveycb33 (1 2 = 1) (3 4 =0) (99 = .), gen(overall_prior)
	label variable overall_prio "Positive Overall Prior"

label variable urban "Urban"
label var treatment "Treatment"
******************
