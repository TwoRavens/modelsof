	capture log close
	clear all
	macro drop _all
	set more off
	version 14.2
	set matsize 11000

******************************************************	
* User written programs: 
	
* ssc install outtable	
* ssc install tabout
* ssc install blindschemes, replace all
* set scheme plotplainblind, permanently

****************************************************** 
*Set working directory 

capture cd "replication_APSR"
		
******************************************************	
*Import updated scorecard data
use "Scorecard_scores.dta", clear
	egen meanscore=rowmean(total_score_2012_2013 total_score_2013_2014 total_score_2014_2015)
		
******************************************************
* merge-in councilor covariates
******************************************************	
merge 1:1 id using "Councilors_covariates_v2.dta"
		drop _merge

******************************************************
* merge-in councilor peer evaluation
******************************************************
merge 1:1 id using "peer_evaluations.dta", 
		drop if _m==2
		drop _m
		egen avescore= rmean(peer_score*) 
		order avescore, b(peer_score1)

******************************************************
* merge-in technocrats evaluation
******************************************************
merge 1:m id using "Technocrats_assessmentB.dta", keepus(index_technocratsA)
		drop if _m==2
		drop _merge	

******************************************************
* merge-in behavioral outcome (school grant apps)
******************************************************	
merge 1:1 id using "School_grant_apps.dta"	
		drop if _m==2
		drop _merge	
		drop if schools==106
		
	gen AppShare=(applicationapp1_ctv+applicationapp2_clv+applicationapp3_itv+applicationapp4_ilv+applicationapp7_cli)/schools
		replace AppShare=1 if AppShare>1 & AppShare!=.
		
	gen AllApp = applicationapp1_ctv+applicationapp2_clv+applicationapp3_itv+applicationapp4_ilv+applicationapp7_cli
		lab var AllApp "Total school grant applications"

	gen CompleteApp = applicationapp1_ctv+applicationapp2_clv+applicationapp7_cli
		lab var CompleteApp "Complete school grant application"
		
******************************************************
* Generate composite outcome index	(Kling et al., 2007)
*****************************************************	
	foreach var in meanscore avescore index_technocratsA AllApp CompleteApp{
	quietly summarize `var' if ID==0
	local `var'_mean= r(mean)
	local `var'_sd= r(sd) 
	gen c_`var' = (`var'-``var'_mean')/``var'_sd'
	qui egen mean_std_`var'=mean(c_`var') if ID==1
	replace c_`var' = mean_std_`var' if ID==1 & c_`var'==.
	replace c_`var' = 0 if ID==0 & c_`var'==.
	qui egen mean_`var'1=mean(`var') if ID==1
	replace `var' = mean_`var'1 if ID==1 & `var'==.
	qui egen mean_`var'0=mean(`var') if ID==0
	replace `var' = mean_`var'0 if ID==0 & `var'==.
	drop mean_`var'0 mean_`var'1 mean_std_`var'
	}
	
egen index_PerformanceA=rowmean(c_meanscore c_avescore c_index_technocratsA c_CompleteApp)
	
******************************************************
* Generate composite outcome index	(Anderson, 2008)
*****************************************************
	* 2. Use Anderaon 2008
	
do "make_index.ado"		
		make_index PerformanceB meanscore avescore index_technocratsA CompleteApp

		lab var index_PerformanceA "Performance mean index"
		lab var index_PerformanceB "Performance weighted mean index"
		su index_PerformanceA index_PerformanceB, de
		corr index_PerformanceA index_PerformanceB
	
********************************************************
* Define covariates
******************************************************
	replace MarginOfVictory2011=-1*MarginOfVictory2011

	gl covs NRM SWC Edu SMS cterms FirstTerm NOfChallengers2011 lpop constit_poverty constit_hhi 
	su $covs

	* assign mean values of control to missing values of covariates (Lin, green and Coppock, 2015))
	foreach y in $covs {
	 egen `y'_mean=mean(`y')
	 gen `y'_miss = `y'==.
	 replace `y' = `y'_mean if `y'==.
	 }

	gen initial_score = total_score_2011_2012

	bys district: egen initial_mean_low=mean(total_score_2011_2012) if competitive ==0
	replace initial_score = initial_mean_low if initial_score==. & competitive ==0
	
	bys district: egen initial_mean_high=mean(total_score_2011_2012) if competitive ==1
	replace initial_score = initial_mean_high if initial_score==. & competitive ==1
	gen initial_score_miss = total_score_2011_2012==.
	
	gl controls NRM SWC Edu SMS  FirstTerm NOfChallengers2011 lpop constit_poverty  FirstTerm_miss NOfChallengers2011_miss constit_hhi lpop_miss constit_poverty_miss constit_hhi_miss 
	su $controls
	 
* define sample
	gen sample=0
	replace sample=1 if NRM!=. & SWC!=. & Edu!=. & SMS!=. & FirstTerm!=. & NOfChallengers2011!=. & lpop!=. & constit_poverty!=. & constit_hhi!=. & competitive!=.

* create var capturing whether the councilor's baseline scorer was above the district median

	bysort distid : egen median_by_dist = median(initial_score) 
	gen HighP = cond(missing(initial_score), ., (initial_score > median_by_dist))
	lab var HighP "Initial score above median" 

* Majority distance: alternative measure of competitivness
	gen kcomp= -1*(VoteShare2011-.5)
	egen medianK = median(kcomp) 
	gen kcompB = cond(missing(kcomp), ., (kcomp > medianK))
	
	gl controls NRM SWC Edu FirstTerm NOfChallengers2011 VoteShare2011 initial_score lpop constit_poverty constit_hhi
	su $controls
	
	gl IVs ID MarginOfVictory2011 competitive kcomp kcompB
	su $IV
	
	gl outcomes index_PerformanceA index_PerformanceB total_score_2012_2013 total_score_2013_2014 total_score_2014_2015 avescore index_technocratsA CompleteApp AllApp
	su $outcome 
	
lab var SWC "Special Women Councilor"
lab var NRM "NRM"
lab var Edu "Post-secondary education"
lab var FirstTerm "First-term councilor"
lab var initial_score "Total score (2011-2012)"
lab var lpop" Constituency population (log)"
lab var constit_poverty "Poverty Index (constituency)"
lab var constit_hhi "Ethnic fractionalization (constituency)"

lab var VoteShare2011 "Incumbent vote share (2011)"
lab var MarginOfVictory2011 "Margin of victory"
lab var competitive "Margin of victory (binary)"
lab var NOfChallengers2011 "Number of challengers (2011)"
lab var ID "ID treatment"
lab var kcompB "Majority distance (binary)"
lab var kcomp "Majority distance"
lab var avescore "Mean peer evaluation"

lab var total_score_2011_2012 "Baseline score (2011-2012)"
lab var total_score_2012_2013 "Total score (2012-2013)"
lab var total_score_2013_2014 "Total score (2013-2014)"
lab var total_score_2014_2015 "Total score (2014-2015)"
lab var index_technocratsA "Technocrats' mean assessment"

*********************************
* Table 3 Paper (descriptive stats)
*********************************
sutex $outcomes $IVs $controls, labels minmax digits(2)
		
******************************************************
* bring-in technocrats evaluation
******************************************************
preserve
use "Technocrats_assessment.dta", clear

lab var tech_q1 "Office visits"
lab var tech_q2 "Knowledgeable"
lab var tech_q3 "Monitoring"
lab var tech_q4 "Effort"

sutex mindex_tech tech_q1 tech_q2 tech_q3 tech_q4, labels minmax digits(2)
restore

******************************************************************************************
* Councilor Characteristics (Table 2 appendix)
******************************************************************************************
tabout party tribe mandate using "tables/table2SI.tex", cells(freq col) style(tex) f(0c 1p) replace
 
 ******************************************************
* bring-in meeting monitoring data 
******************************************************
preserve
use "ACODE_IDmeeting_Monitoring.dta", clear

 ******************************************************
* delivery of community meetings (table 3 appendix)
******************************************************
lab var idq15 "Councilor Roles and Duties"
lab var idq16 "Roles Councilors Should NOT Play"
lab var idq17 "Meaning of Scorecard Scores"
lab var idq18 "Presentation of Scores - Regular Councilor"
lab var idq19 "Presentation of Scores - Special Woman Councilor"
lab var idq20 "Interactive Activity to Practice Reading Scores"
lab var idq21 "Public Service Standards - Health"
lab var idq22 "Public Service Standards - Education"
lab var idq23 "Interactive Activity about Public Service Standards"

tabout idq15 idq16 idq17 idq18 idq19 idq20 idq21 idq22 idq23 using "tables/table3SI.tex", cells(freq col) oneway style(tex) f(0c 1p) replace

******************************************************
* exit poll knowledge of score (table 4 appendix)
******************************************************
 lab var idscore "Knowledge of Regular Councilor Score"
 lab var idq31 "Knowledge of Special Woman Councilor Score"
 
 recode idscore idq31 (-66 3=0)(2=1)(1=2)
 lab define accurate 0 "DK/missing" 1 "Inaccurate score/range" 2 "Accurate score/range", modify
 lab value idscore accurate
 lab value idq31 accurate
 
 tabout idscore idq31 using "tables/table4SI.tex", cells(freq col) oneway style(tex) f(0c 1p) replace

******************************************************
* exit poll knowledge of standards and duties (table 5 appendix)
******************************************************
 lab var duties "Number of Councilor Duties Recalled"
 lab var idallstandards "Number of Public Service Standards Recalled"
 lab var idedu "Number of Education Standards Recalled"
 lab var idhealth "Number of Health Standards Recalled"
 lab var idwater "Number of Water Standards Recalled"
 lab var idroads "Number of Roads Standards Recalled"
 
 sutex duties idallstandards idedu idhealth idwater idroads, labels minmax digits(2)
 
******************************************************
* exit poll breakdown knowledge of standards and duties (table 6 appendix)
******************************************************
 lab var idE01 "Max Class Size"
 lab var idE02 "Max Classroom Capacity"
 lab var idE03 "Max Pupiles Sharing Textbooks"
 lab var idE04 "Max Pupils Sharing Desk"
 lab var idE05 "Latrine Child Ratio"
 lab var idE06 "Other Edu Standard"
 lab var idW07 "Access Clean Water"
 lab var idW08 "Distance to Water Source Max"
 lab var idW09 "Working Condition Sources"
 lab var idW10 "Borehole per Person Ratio"
 lab var idW12 "Other Water Standard"
 lab var idR13 "Durable Roads"
 lab var idR14 "Road Maintenance"
 lab var idR15 "Other Roads Standard"
 lab var idH16 "HCII and HCIII min"
 lab var idH17 "Max Distance to HCII"
 lab var idH18 "No Medicine Stockouts"
 lab var idH19 "HC II Staffing Minimum"
 lab var idH20 "HCII Latrine Standard"
 lab var idH21 "Other Health Standard"
 lab var idCD1 "Represents the Community at Council Plenary"
 lab var idCD2 "Visits Subcounty Council Meetings"
 lab var idCD3 "Monitors Public Service Delivery"
 lab var idCD4 "Reports Decisions to the Community"
 lab var idCD5 "By-Laws for Community Development"
 lab var idCD6 "Elicits Community Opinions"
 
 tabstatout idE01 idE02 idE03 idE04 idE05 idE06 idW07 idW08 idW09 idW10 idW12 idR13 idR14 idR15 idH16 idH17 idH18 idH19 idH20 idH21 idCD1 idCD2 idCD3 idCD4 idCD5 idCD6, s(n mean) c(s) 
 tabout
 
 restore
 
******************************************************************************************
* Balance on councilor and constituency pre-treatment covariates, by treatment group
******************************************************************************************
set more off		   
global balance SWC female NRM FirstTerm Edu initial_score VoteShare2011 MarginOfVictory2011 competitive kcomp kcompB NOfChallengers2011 lpop constit_hhi constit_poverty

*********************************
* Table 7 Paper (appenix)
*********************************

mat define baltab = (.,.,.)
foreach var in $balance {
areg ID `var' , abs(district) 
matrix b = e(b)
matrix b0 = b[1,1]
matrix b1 = b[1,2]
local t = _b[`var']/_se[`var']
mat define pval1 = 2*ttail(e(df_r),abs(`t'))  
mat define B = (b1 , b0 , pval1)
mat rownames B = "`var'"
mat define baltab = (baltab \ B)
}

mat colnames baltab = "Control mean centered" "Diff means" "p-value"
mat li baltab
outtable using "tables/balance_table_ID2" ,mat(baltab) replace label f(%9.3f)

*********************************
* Table 8 Paper (appenix)
*********************************
* competitive binary
set more off
global balance2 SWC female NRM FirstTerm Edu initial_score VoteShare2011 MarginOfVictory2011 NOfChallengers2011 lpop constit_hhi constit_poverty

mat define baltab = (.,.,.)
foreach var in $balance2 {
areg competitive `var' , abs(district) 
matrix b = e(b)
matrix b0 = b[1,1]
matrix b1 = b[1,2]
local t = _b[`var']/_se[`var']
mat define pval1 = 2*ttail(e(df_r),abs(`t'))  
mat define B = (b1 , b0 , pval1)
mat rownames B = "`var'"
mat define baltab = (baltab \ B)
}

mat colnames baltab = "Control mean centered" "Diff means" "p-value"
mat li baltab
outtable using "tables/balance_table_comp2" ,mat(baltab) replace label f(%9.3f)

