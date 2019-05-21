

* rpvh 6/18/2014

*THERE ARE COMMANDS IN THIS FILE THAT DO NOT RUN ON VERSIONS PRIOR TO STATA 13* 
****THERE ARE COMMANDS IN THIS FILE THAT REQUIRE THE INSTALLATION OF TABOUT****

*******************TABLES AND FIGURES FOR EXPERIMENT 2**************************
* This do file produces the data for tables and figures for experiment 2 that
* appear in the paper and the Online Appendix.  Running the entire code will
* produce tab delimited text files for each table that you can import into a
* spreadsheet program like Excel.  The comments in this .do file explain the 
* of the formatting of the tables it produces and how to paste them into the
* Excel spreadsheet "Tables for Experiment 2" to replicate the contents and 
* formatting of the original tables.
* 
* The easiest way to view these comments is to run this file and look at the 
* "study2replication.log" file that it creates.  All of the commands are run
* quietly, so only the comments are visible in that log file.
*
* This .do file repeatedly calls the main data file for the study. You need to 
* change the working directory to the directory where the data file is before
* running the code.   The synatax is cd "[path]."  

*cd "[path]"

log using "study2replication.log", replace
*********************************TABLE 3****************************************
* The code below produces the output for Table 3 and saves it in a tab-delimited 
* text file called "table3output.txt" in the working folder. To produce a 
* replica of Table 3, first import "table3output.txt" into Excel, copy the 
* entire contents of the imported table, and then paste them into the 
* "Table 3 Output" tab of the Excel file titled "Tables for Experiment 2." Place 
* the top left cell at row A, column 1, and this will update the linked 
* formatted table in the tab "Table 3" 
quietly{
clear all
do "study2replication_makedata.do"

clear all
set more off
use "study2replication.dta"


*************************** DATA PREP AND RECODES ******************************


* replace letter labels with desciptive labels, first element contains senators position second element contains respondents
label define letter 1 "Pro to Pro" 2 "Pro to Anti" 3 "Anti to Pro" 4 "Anti to Anti" 5 "Pro to All" 6 "Anti to All"
label values firstletter letter
label values secondletter letter

* generate dummies for each type of letter
tab firstletter, gen(firstletter_dum)
ren firstletter_dum1 pro_pro_1
ren firstletter_dum2 pro_anti_1
ren firstletter_dum3 anti_pro_1
ren firstletter_dum4 anti_anti_1
ren firstletter_dum5 pro_all_1
ren firstletter_dum6 anti_all_1

*change and scaling of polarity of agreement so higher numbers mean more agreement
recode firstsen_agree 1=4 2=3 3=2 4=1
recode secondsen_agree 1=4 2=3 3=2 4=1
label define agree_withsen 1 "Strongly disagree"  4 "Strongly agree"
label values firstsen_agree agree_withsen
label values secondsen_agree agree_withsen

*change polarity of vote likelihood so higher numbers mean higher vote likelihood
recode firstsen_votefor 1=5 2=4 3=3 4=2 5=1
recode secondsen_votefor 1=5 2=4 3=3 4=2 5=1
label define votefor 1 "Not likely at all" 2 "Not too likely" 3 "Somewhat likely" 4 "Very likely" 5 "Extremely likely", replace
label values firstsen_votefor votefor
label values secondsen_votefor votefor

*generate a variable for perceived agreement based on whether the respondents own position matches their assessment of
*the senator's general position and their perception of how the senator voted.
gen firstsen_perceive_agree = 1 if (firstsen_position==1 & (preLetterSupport==1|preLetterSupport==2))|(firstsen_position==2 & (preLetterSupport==3|preLetterSupport==4))
replace firstsen_perceive_agree = 0 if (firstsen_position==2 & (preLetterSupport==1|preLetterSupport==2))|(firstsen_position==1 & (preLetterSupport==3|preLetterSupport==4))
gen firstsen_perceive_voted_agree = 1 if (firstsen_voted==1 & (preLetterSupport==1|preLetterSupport==2))|(firstsen_voted==2 & (preLetterSupport==3|preLetterSupport==4))
replace firstsen_perceive_voted_agree = 0 if (firstsen_voted==2 & (preLetterSupport==1|preLetterSupport==2))|(firstsen_voted==1 & (preLetterSupport==3|preLetterSupport==4))

*change polarity of trait scores so higher numbers mean higher trait evaluation
label define trait 0 "Not well at all"  1 "Extremely well"
foreach trait in honest leader knowledge openminded hardworking {
recode firstsen_`trait' 1=1 2=.75 3=.5 4=.25 5=0
recode secondsen_`trait' 1=1 2=.75 3=.5 4=.25 5=0
label values firstsen_`trait' trait
label values secondsen_`trait' trait
}

* generate a variable indicating whether the respondent is correct about the general position of the senator
gen firstsen_position_correct = 0 if (firstsen_position == 1 & (firstletter==3|firstletter==4|firstletter==6)) 
replace firstsen_position_correct = 0 if (firstsen_position == 2 & (firstletter==1|firstletter==2|firstletter==5))
replace firstsen_position_correct = 1 if (firstsen_position == 2 & (firstletter==3|firstletter==4|firstletter==6))
replace firstsen_position_correct = 1 if (firstsen_position == 1 & (firstletter==1|firstletter==2|firstletter==5))
label variable firstsen_position_correct "Correct about Senator's General Position"
label define correct 0 "Incorrect" 1 "Correct"
label values firstsen_position_correct correct

* generate a variable indication whether the respondent is correct about the immigration reform roll call cast by the senator
gen firstsen_roll_correct = 0 if (firstsen_voted == 1 & (firstletter==3|firstletter==4|firstletter==6)) 
replace firstsen_roll_correct = 0 if (firstsen_voted == 2 & (firstletter==1|firstletter==2|firstletter==5))
replace firstsen_roll_correct = 1 if (firstsen_voted == 2 & (firstletter==3|firstletter==4|firstletter==6))
replace firstsen_roll_correct = 1 if (firstsen_voted == 1 & (firstletter==1|firstletter==2|firstletter==5))
label variable firstsen_roll_correct "Correct about Senator's Roll Call Vote"
label values firstsen_roll_correct correct

* change the polarity of the certainty variable and rescale so it spans 0 to 1 and can be in same table as correctness variables
recode firstsen_certainty 5=0 4=.25 3=.50 2=.75 1=1
label define certainty_rescale 1 "Extremely certain" 0 "Not certain at all"
label values firstsen_certainty certainty_rescale

*generate dummy variables that are interactions between letter types and respondent pre-treatment positions on immigration for use in saturated models
foreach letter in pro_pro_1 pro_anti_1 anti_pro_1 anti_anti_1 pro_all_1 anti_all_1 {
	gen `letter'ss=cond(preLetterSupport==1 & `letter'==1 ,1,0)
	gen `letter'ws=cond(preLetterSupport==2 & `letter'==1 ,1,0)
	gen `letter'wo=cond(preLetterSupport==3 & `letter'==1 ,1,0)
	gen `letter'so=cond(preLetterSupport==4 & `letter'==1 ,1,0)
	}


gen tTreat_SPos = cond(firstletter==3|firstletter==4|firstletter==6, 1, 0)
gen tTreat_LTarget = 1 if (firstletter==1|firstletter==3)
replace tTreat_LTarget = 2 if (firstletter==2|firstletter==4)
replace tTreat_LTarget = 3 if (firstletter==5|firstletter==6)
label var tTreat_SPos "Senator's Position"
label define tTreat_SPos 0 "Pro-Immigration" 1 "Anti-Immigration"
label values tTreat_SPos tTreat_SPos
label var tTreat_LTarget "Letter Tailored For"
label define tTreat_LTarget 1 "Pro-Immigration Constituents" 2 "Anti-Immigration Constituents" 3 "Untailored Letter"
label values tTreat_LTarget tTreat_LTarget
tabout tTreat_LTarget tTreat_SPos using table3output.txt, sum cells(N preLetterSupport) f(0c) ptotal(none)  h3(nil) replace
import delimited table3output.txt, clear
drop v4
export delimited table3output.txt, delim(tab) novarnames replace
}



******************************* TABLE 4 ****************************************
* The code below estimates the saturated models and saves the weighted combined 
* estimates into a tab delimited text file called "table4output.txt".  That file 
* contains the means and confidence intervals for each variable in the order
* that they appear in Table 4 in the text.  To produce a replica of Table 4, 
* first import "table4output.txt" into Excel, copy the entire contents of the 
* imported table, and then paste them into the "Table 4 Output" tab of the Excel
* file titled "Tables for Experiment 2." Place the top left cell at row A, 
* column 1, and this will update the linked formatted table in the tab "Table 4" 
quietly{
clear all
do "study2replication_makedata.do"

clear all
set more off
use "study2replication.dta"


*************************** DATA PREP AND RECODES ******************************


* replace letter labels with desciptive labels, first element contains senators position second element contains respondents
label define letter 1 "Pro to Pro" 2 "Pro to Anti" 3 "Anti to Pro" 4 "Anti to Anti" 5 "Pro to All" 6 "Anti to All"
label values firstletter letter
label values secondletter letter

* generate dummies for each type of letter
tab firstletter, gen(firstletter_dum)
ren firstletter_dum1 pro_pro_1
ren firstletter_dum2 pro_anti_1
ren firstletter_dum3 anti_pro_1
ren firstletter_dum4 anti_anti_1
ren firstletter_dum5 pro_all_1
ren firstletter_dum6 anti_all_1

*change and scaling of polarity of agreement so higher numbers mean more agreement
recode firstsen_agree 1=4 2=3 3=2 4=1
recode secondsen_agree 1=4 2=3 3=2 4=1
label define agree_withsen 1 "Strongly disagree"  4 "Strongly agree"
label values firstsen_agree agree_withsen
label values secondsen_agree agree_withsen

*change polarity of vote likelihood so higher numbers mean higher vote likelihood
recode firstsen_votefor 1=5 2=4 3=3 4=2 5=1
recode secondsen_votefor 1=5 2=4 3=3 4=2 5=1
label define votefor 1 "Not likely at all" 2 "Not too likely" 3 "Somewhat likely" 4 "Very likely" 5 "Extremely likely", replace
label values firstsen_votefor votefor
label values secondsen_votefor votefor

*generate a variable for perceived agreement based on whether the respondents own position matches their assessment of
*the senator's general position and their perception of how the senator voted.
gen firstsen_perceive_agree = 1 if (firstsen_position==1 & (preLetterSupport==1|preLetterSupport==2))|(firstsen_position==2 & (preLetterSupport==3|preLetterSupport==4))
replace firstsen_perceive_agree = 0 if (firstsen_position==2 & (preLetterSupport==1|preLetterSupport==2))|(firstsen_position==1 & (preLetterSupport==3|preLetterSupport==4))
gen firstsen_perceive_voted_agree = 1 if (firstsen_voted==1 & (preLetterSupport==1|preLetterSupport==2))|(firstsen_voted==2 & (preLetterSupport==3|preLetterSupport==4))
replace firstsen_perceive_voted_agree = 0 if (firstsen_voted==2 & (preLetterSupport==1|preLetterSupport==2))|(firstsen_voted==1 & (preLetterSupport==3|preLetterSupport==4))

*change polarity of trait scores so higher numbers mean higher trait evaluation
label define trait 0 "Not well at all"  1 "Extremely well"
foreach trait in honest leader knowledge openminded hardworking {
recode firstsen_`trait' 1=1 2=.75 3=.5 4=.25 5=0
recode secondsen_`trait' 1=1 2=.75 3=.5 4=.25 5=0
label values firstsen_`trait' trait
label values secondsen_`trait' trait
}

* generate a variable indicating whether the respondent is correct about the general position of the senator
gen firstsen_position_correct = 0 if (firstsen_position == 1 & (firstletter==3|firstletter==4|firstletter==6)) 
replace firstsen_position_correct = 0 if (firstsen_position == 2 & (firstletter==1|firstletter==2|firstletter==5))
replace firstsen_position_correct = 1 if (firstsen_position == 2 & (firstletter==3|firstletter==4|firstletter==6))
replace firstsen_position_correct = 1 if (firstsen_position == 1 & (firstletter==1|firstletter==2|firstletter==5))
label variable firstsen_position_correct "Correct about Senator's General Position"
label define correct 0 "Incorrect" 1 "Correct"
label values firstsen_position_correct correct

* generate a variable indication whether the respondent is correct about the immigration reform roll call cast by the senator
gen firstsen_roll_correct = 0 if (firstsen_voted == 1 & (firstletter==3|firstletter==4|firstletter==6)) 
replace firstsen_roll_correct = 0 if (firstsen_voted == 2 & (firstletter==1|firstletter==2|firstletter==5))
replace firstsen_roll_correct = 1 if (firstsen_voted == 2 & (firstletter==3|firstletter==4|firstletter==6))
replace firstsen_roll_correct = 1 if (firstsen_voted == 1 & (firstletter==1|firstletter==2|firstletter==5))
label variable firstsen_roll_correct "Correct about Senator's Roll Call Vote"
label values firstsen_roll_correct correct

* change the polarity of the certainty variable and rescale so it spans 0 to 1 and can be in same table as correctness variables
recode firstsen_certainty 5=0 4=.25 3=.50 2=.75 1=1
label define certainty_rescale 1 "Extremely certain" 0 "Not certain at all"
label values firstsen_certainty certainty_rescale

*generate dummy variables that are interactions between letter types and respondent pre-treatment positions on immigration for use in saturated models
foreach letter in pro_pro_1 pro_anti_1 anti_pro_1 anti_anti_1 pro_all_1 anti_all_1 {
	gen `letter'ss=cond(preLetterSupport==1 & `letter'==1 ,1,0)
	gen `letter'ws=cond(preLetterSupport==2 & `letter'==1 ,1,0)
	gen `letter'wo=cond(preLetterSupport==3 & `letter'==1 ,1,0)
	gen `letter'so=cond(preLetterSupport==4 & `letter'==1 ,1,0)
	}


* initiate variables that will contain the results of various linear combinations of coefficients from the saturated model
gen str Tdv = ""
gen str Ttarget = ""
gen str Trespondent = ""
gen Testimate = .
gen Tse = .
gen TestLB = .
gen TestUB = .
gen Tdf = .
gen TDvND_estimate = .
gen TDvND_se = .
gen TDvND_lb = .
gen TDvND_ub = .
gen TDvNA_estimate = .
gen TDvNA_se = .
gen TDvNA_lb = .
gen TDvNA_ub = .

local row = 1 
foreach dv in agree therm votefor /*honest leader knowledge openminded hardworking perceive_agree perceive_voted_agree*/ {
display "`dv'"
regress firstsen_`dv' pro_pro_1ss pro_pro_1ws pro_pro_1wo pro_pro_1so pro_anti_1ss pro_anti_1ws pro_anti_1wo pro_anti_1so anti_pro_1ss anti_pro_1ws anti_pro_1wo anti_pro_1so anti_anti_1ss anti_anti_1ws anti_anti_1wo anti_anti_1so pro_all_1ss pro_all_1ws pro_all_1wo pro_all_1so anti_all_1ss anti_all_1ws anti_all_1wo anti_all_1so /*if senparty==1| if senparty==2*/, nocons
	foreach target in agree_target agree_notarget agree_mistarget disagree_target disagree_notarget disagree_mistarget{
		foreach respondent in  /*s o*/ a /*m e*/{
			* weights for estimates only including immigration reform supporters
			if "`respondent'" == "s"{
				local w1=.31 /* weight for strong supporters of immigration reform, .22 in sample, .31 among strong and weak supporters */
				local w2=.69 /* weight for weak supporters of immigration reform, .5 in sample, .69 among strong and weak supporters */
				local w3= 0 /* weight for strong opponents of immigration reform, .09 in sample, .32 among strong and weak opponents*/
				local w4= 0 /* weight for weak opponents of immigration reform, .19 in sample, .68 among strong and weak opponents */
				}
			* weights for estimates only including immigration reform opponents
			if "`respondent'" == "o"{
				local w1=0 /* weight for strong supporters of immigration reform, .22 in sample, .31 among strong and weak supporters */
				local w2=0 /* weight for weak supporters of immigration reform, .5 in sample, .69 among strong and weak supporters */
				local w3=.68 /* weight for weak opponents of immigration reform, .19 in sample, .68 among strong and weak opponents */
				local w4=.32 /* weight for strong opponents of immigration reform, .09 in sample, .32 among strong and weak opponents*/
				}
			* weights for estimates only including all respondents who took positions on immmigrating reform
			* these are the weights that we use in Table 4
			if "`respondent'" == "a"{
			    local w1=.22 /* weight for strong supporters of immigration reform, .22 in sample */
				local w2=.5 /* weight for weak supporters of immigration reform, .5 in sample */
				local w3=.19 /* weight for weak opponents of immigration reform, .19 in sample */
				local w4=.09 /* weight for strong opponents of immigration reform, .09 in sample */
				}
			* weights for estimates only including only respondents who took weak positions on either side of the issue
			if "`respondent'" == "m"{
			    local w1= 0 /* weight for strong supporters of immigration reform, .71 among strong suppoters and opponents */
				local w2=.72 /* weight for weak supporters of immigration reform, .72 among weak supporters and opponents */
				local w3=.28 /* weight for weak opponents of immigration reform, .28 among weak supporters and opponents */
				local w4= 0 /* weight for strong opponents of immigration reform, .29 among strong suppoters and opponents */
				}
			* weights for estimates only including only respondents who took strong positions on either side of the issue
			if "`respondent'" == "e"{
			    local w1= .71 /* weight for strong supporters of immigration reform, .71 among strong suppoters and opponents */
				local w2= 0/* weight for weak supporters of immigration reform, .72 among weak supporters and opponents */
				local w3= 0 /* weight for weak opponents of immigration reform, .28 among weak supporters and opponents */
				local w4= .29 /* weight for strong opponents of immigration reform, .29 among strong suppoters and opponents */
				}
				if "`target'" == "agree_target" {
					local letter1 = "pro_pro"
					local letter2 = "anti_anti"
					}
				if "`target'" == "agree_notarget" {
					local letter1 = "pro_all"
					local letter2 = "anti_all"
					}
				if "`target'" == "agree_mistarget" {
					local letter1 = "pro_anti"
					local letter2 = "anti_pro"
					}
				if "`target'" == "disagree_target" {
					local letter1 = "anti_pro"
					local letter2 = "pro_anti"
					}
				if "`target'" == "disagree_notarget" {
					local letter1 = "anti_all"
					local letter2 = "pro_all"
					}
				if "`target'" == "disagree_mistarget" {
					local letter1 = "anti_anti"
					local letter2 = "pro_pro"
					}
				lincom `w1'*`letter1'_1ss+`w2'*`letter1'_1ws + `w3'*`letter2'_1wo+`w4'*`letter2'_1so
				replace Tdv = "`dv'" in `row'
				replace Ttarget = "`target'" in `row'
				replace Trespondent = "`respondent'" in `row'
				replace Testimate = r(estimate) in `row'
				replace Tse = r(se) in `row'
				replace Tdf = r(df) in `row' 
				local row = `row' + 1
				}
			}
		}

		replace TestLB = Testimate - 1.96*(Tse)
		replace TestUB = Testimate + 1.96*(Tse)
	

keep Tdv Ttarget Testimate TestLB TestUB
keep in 1/18
ren Tdv DV
ren Ttarget Treatment 
ren Testimate Mean
ren TestLB LowerBound
ren TestUB UpperBound
replace Treatment="Agree - Targeted Toward" if Treatment=="agree_target"
replace Treatment="Agree - Not Targeted" if Treatment=="agree_notarget"
replace Treatment="Agree - Targeted Away" if Treatment=="agree_mistarget"
replace Treatment="Disagree - Targeted Toward" if Treatment=="disagree_target"
replace Treatment="Disagree - Not Targeted" if Treatment=="disagree_notarget"
replace Treatment="Disagree - Targeted Away" if Treatment=="disagree_mistarget"
export delimited table4output.txt, delim(tab) replace
}
******************************* FIGURE 1 ***************************************
* The code below produces the estimates that are needed to replicate Figure 1
* It saves these estimates in a file called "figure1output.txt".  The dependent
* variable for each row is indicated by the contents of the variable DV
* The estimates for the first panel are contained in variables starting with
* TDvND (Targeted Toward-Disagree vs. Not Targeted-Disagree)
* and the estimates for the second panel are contained in the variables
* starting with TDvNA (Targeted Toward-Disagree vs. Not Targeted-Agreee).  To
* produce a more readable version of this table, first import 
* "figure1output.txt" into Excel, copy the entire contents of the imported 
* table, and then paste them into the "Figure 1 Output" tab of the Excel
* file titled "Tables for Experiment 2." Place the top left cell at row A, 
* column 1, and this will update the linked table in the tab "Figure 1"
quietly{
clear all
do "study2replication_makedata.do"

clear all
set more off
use "study2replication.dta"


*************************** DATA PREP AND RECODES ******************************


* replace letter labels with desciptive labels, first element contains senators position second element contains respondents
label define letter 1 "Pro to Pro" 2 "Pro to Anti" 3 "Anti to Pro" 4 "Anti to Anti" 5 "Pro to All" 6 "Anti to All"
label values firstletter letter
label values secondletter letter

* generate dummies for each type of letter
tab firstletter, gen(firstletter_dum)
ren firstletter_dum1 pro_pro_1
ren firstletter_dum2 pro_anti_1
ren firstletter_dum3 anti_pro_1
ren firstletter_dum4 anti_anti_1
ren firstletter_dum5 pro_all_1
ren firstletter_dum6 anti_all_1

*change and scaling of polarity of agreement so higher numbers mean more agreement
recode firstsen_agree 1=4 2=3 3=2 4=1
recode secondsen_agree 1=4 2=3 3=2 4=1
label define agree_withsen 1 "Strongly disagree"  4 "Strongly agree"
label values firstsen_agree agree_withsen
label values secondsen_agree agree_withsen

*change polarity of vote likelihood so higher numbers mean higher vote likelihood
recode firstsen_votefor 1=5 2=4 3=3 4=2 5=1
recode secondsen_votefor 1=5 2=4 3=3 4=2 5=1
label define votefor 1 "Not likely at all" 2 "Not too likely" 3 "Somewhat likely" 4 "Very likely" 5 "Extremely likely", replace
label values firstsen_votefor votefor
label values secondsen_votefor votefor

*generate a variable for perceived agreement based on whether the respondents own position matches their assessment of
*the senator's general position and their perception of how the senator voted.
gen firstsen_perceive_agree = 1 if (firstsen_position==1 & (preLetterSupport==1|preLetterSupport==2))|(firstsen_position==2 & (preLetterSupport==3|preLetterSupport==4))
replace firstsen_perceive_agree = 0 if (firstsen_position==2 & (preLetterSupport==1|preLetterSupport==2))|(firstsen_position==1 & (preLetterSupport==3|preLetterSupport==4))
gen firstsen_perceive_voted_agree = 1 if (firstsen_voted==1 & (preLetterSupport==1|preLetterSupport==2))|(firstsen_voted==2 & (preLetterSupport==3|preLetterSupport==4))
replace firstsen_perceive_voted_agree = 0 if (firstsen_voted==2 & (preLetterSupport==1|preLetterSupport==2))|(firstsen_voted==1 & (preLetterSupport==3|preLetterSupport==4))

*change polarity of trait scores so higher numbers mean higher trait evaluation
label define trait 0 "Not well at all"  1 "Extremely well"
foreach trait in honest leader knowledge openminded hardworking {
recode firstsen_`trait' 1=1 2=.75 3=.5 4=.25 5=0
recode secondsen_`trait' 1=1 2=.75 3=.5 4=.25 5=0
label values firstsen_`trait' trait
label values secondsen_`trait' trait
}

* generate a variable indicating whether the respondent is correct about the general position of the senator
gen firstsen_position_correct = 0 if (firstsen_position == 1 & (firstletter==3|firstletter==4|firstletter==6)) 
replace firstsen_position_correct = 0 if (firstsen_position == 2 & (firstletter==1|firstletter==2|firstletter==5))
replace firstsen_position_correct = 1 if (firstsen_position == 2 & (firstletter==3|firstletter==4|firstletter==6))
replace firstsen_position_correct = 1 if (firstsen_position == 1 & (firstletter==1|firstletter==2|firstletter==5))
label variable firstsen_position_correct "Correct about Senator's General Position"
label define correct 0 "Incorrect" 1 "Correct"
label values firstsen_position_correct correct

* generate a variable indication whether the respondent is correct about the immigration reform roll call cast by the senator
gen firstsen_roll_correct = 0 if (firstsen_voted == 1 & (firstletter==3|firstletter==4|firstletter==6)) 
replace firstsen_roll_correct = 0 if (firstsen_voted == 2 & (firstletter==1|firstletter==2|firstletter==5))
replace firstsen_roll_correct = 1 if (firstsen_voted == 2 & (firstletter==3|firstletter==4|firstletter==6))
replace firstsen_roll_correct = 1 if (firstsen_voted == 1 & (firstletter==1|firstletter==2|firstletter==5))
label variable firstsen_roll_correct "Correct about Senator's Roll Call Vote"
label values firstsen_roll_correct correct

* change the polarity of the certainty variable and rescale so it spans 0 to 1 and can be in same table as correctness variables
recode firstsen_certainty 5=0 4=.25 3=.50 2=.75 1=1
label define certainty_rescale 1 "Extremely certain" 0 "Not certain at all"
label values firstsen_certainty certainty_rescale

*generate dummy variables that are interactions between letter types and respondent pre-treatment positions on immigration for use in saturated models
foreach letter in pro_pro_1 pro_anti_1 anti_pro_1 anti_anti_1 pro_all_1 anti_all_1 {
	gen `letter'ss=cond(preLetterSupport==1 & `letter'==1 ,1,0)
	gen `letter'ws=cond(preLetterSupport==2 & `letter'==1 ,1,0)
	gen `letter'wo=cond(preLetterSupport==3 & `letter'==1 ,1,0)
	gen `letter'so=cond(preLetterSupport==4 & `letter'==1 ,1,0)
	}

* initiate variables that will contain the results of various linear combinations of coefficients from the saturated model
gen str Tdv = ""
gen str Ttarget = ""
gen str Trespondent = ""
gen Testimate = .
gen Tse = .
gen TestLB = .
gen TestUB = .
gen Tdf = .
gen TDvND_estimate = .
gen TDvND_se = .
gen TDvND_lb = .
gen TDvND_ub = .
gen TDvNA_estimate = .
gen TDvNA_se = .
gen TDvNA_lb = .
gen TDvNA_ub = .

local row = 1 
foreach dv in agree therm votefor /*honest leader knowledge openminded hardworking perceive_agree perceive_voted_agree*/ {
display "`dv'"
regress firstsen_`dv' pro_pro_1ss pro_pro_1ws pro_pro_1wo pro_pro_1so pro_anti_1ss pro_anti_1ws pro_anti_1wo pro_anti_1so anti_pro_1ss anti_pro_1ws anti_pro_1wo anti_pro_1so anti_anti_1ss anti_anti_1ws anti_anti_1wo anti_anti_1so pro_all_1ss pro_all_1ws pro_all_1wo pro_all_1so anti_all_1ss anti_all_1ws anti_all_1wo anti_all_1so /*if senparty==1| if senparty==2*/, nocons
	foreach target in agree_target agree_notarget agree_mistarget disagree_target disagree_notarget disagree_mistarget{
		foreach respondent in  /*s o*/ a /*m e*/{
			* weights for estimates only including immigration reform supporters
			if "`respondent'" == "s"{
				local w1=.31 /* weight for strong supporters of immigration reform, .22 in sample, .31 among strong and weak supporters */
				local w2=.69 /* weight for weak supporters of immigration reform, .5 in sample, .69 among strong and weak supporters */
				local w3= 0 /* weight for strong opponents of immigration reform, .09 in sample, .32 among strong and weak opponents*/
				local w4= 0 /* weight for weak opponents of immigration reform, .19 in sample, .68 among strong and weak opponents */
				}
			* weights for estimates only including immigration reform opponents
			if "`respondent'" == "o"{
				local w1=0 /* weight for strong supporters of immigration reform, .22 in sample, .31 among strong and weak supporters */
				local w2=0 /* weight for weak supporters of immigration reform, .5 in sample, .69 among strong and weak supporters */
				local w3=.68 /* weight for weak opponents of immigration reform, .19 in sample, .68 among strong and weak opponents */
				local w4=.32 /* weight for strong opponents of immigration reform, .09 in sample, .32 among strong and weak opponents*/
				}
			* weights for estimates only including all respondents who took positions on immmigrating reform
			* these are the weights that we use in Table 4
			if "`respondent'" == "a"{
			    local w1=.22 /* weight for strong supporters of immigration reform, .22 in sample */
				local w2=.5 /* weight for weak supporters of immigration reform, .5 in sample */
				local w3=.19 /* weight for weak opponents of immigration reform, .19 in sample */
				local w4=.09 /* weight for strong opponents of immigration reform, .09 in sample */
				}
			* weights for estimates only including only respondents who took weak positions on either side of the issue
			if "`respondent'" == "m"{
			    local w1= 0 /* weight for strong supporters of immigration reform, .71 among strong suppoters and opponents */
				local w2=.72 /* weight for weak supporters of immigration reform, .72 among weak supporters and opponents */
				local w3=.28 /* weight for weak opponents of immigration reform, .28 among weak supporters and opponents */
				local w4= 0 /* weight for strong opponents of immigration reform, .29 among strong suppoters and opponents */
				}
			* weights for estimates only including only respondents who took strong positions on either side of the issue
			if "`respondent'" == "e"{
			    local w1= .71 /* weight for strong supporters of immigration reform, .71 among strong suppoters and opponents */
				local w2= 0/* weight for weak supporters of immigration reform, .72 among weak supporters and opponents */
				local w3= 0 /* weight for weak opponents of immigration reform, .28 among weak supporters and opponents */
				local w4= .29 /* weight for strong opponents of immigration reform, .29 among strong suppoters and opponents */
				}
				if "`target'" == "agree_target" {
					local letter1 = "pro_pro"
					local letter2 = "anti_anti"
					}
				if "`target'" == "agree_notarget" {
					local letter1 = "pro_all"
					local letter2 = "anti_all"
					}
				if "`target'" == "agree_mistarget" {
					local letter1 = "pro_anti"
					local letter2 = "anti_pro"
					}
				if "`target'" == "disagree_target" {
					local letter1 = "anti_pro"
					local letter2 = "pro_anti"
					}
				if "`target'" == "disagree_notarget" {
					local letter1 = "anti_all"
					local letter2 = "pro_all"
					}
				if "`target'" == "disagree_mistarget" {
					local letter1 = "anti_anti"
					local letter2 = "pro_pro"
					}
				lincom `w1'*`letter1'_1ss+`w2'*`letter1'_1ws + `w3'*`letter2'_1wo+`w4'*`letter2'_1so
				replace Tdv = "`dv'" in `row'
				replace Ttarget = "`target'" in `row'
				replace Trespondent = "`respondent'" in `row'
				replace Testimate = r(estimate) in `row'
				replace Tse = r(se) in `row'
				replace Tdf = r(df) in `row' 
				 
			    *first panel in figure 1
				dis "tests hypothesis that compensating letter to opposing constituents is different that constitent letter to opposing constituents."
				lincom (`w1'*anti_pro_1ss+`w2'*anti_pro_1ws +`w3'*pro_anti_1wo+`w4'*pro_anti_1so) - (`w1'*anti_all_1ss+`w2'*anti_all_1ws +`w3'*pro_all_1wo+`w4'*pro_all_1so)
				replace TDvND_estimate = r(estimate) in `row'
				replace TDvND_se = r(se) in `row'
				*second panel in figure 1
				dis "tests hypothesis that compensating letter to opposing constituents is different from constitent letter to agreeable constituents."
				lincom (`w1'*anti_pro_1ss+`w2'*anti_pro_1ws + `w3'*pro_anti_1wo+`w4'*pro_anti_1so) - (`w1'*pro_all_1ss+`w2'*pro_all_1ws +`w3'*anti_all_1wo+`w4'*anti_all_1so)
				replace TDvNA_estimate = r(estimate) in `row'
				replace TDvNA_se = r(se) in `row'
				local row = `row' + 1
				}
			}
		}

		replace TDvND_lb = TDvND_estimate - 1.96*(TDvND_se)
		replace TDvND_ub = TDvND_estimate + 1.96*(TDvND_se)
		replace TDvNA_lb = TDvNA_estimate - 1.96*(TDvNA_se)
		replace TDvNA_ub = TDvNA_estimate + 1.96*(TDvNA_se)
		
		* rescales the results for the variable agree onto 0-1
		replace TDvND_estimate = TDvND_estimate/3 if Tdv=="agree"
		replace TDvND_se=TDvND_se/3 if Tdv=="agree"
		replace TDvND_lb = TDvND_lb/3 if Tdv=="agree"
		replace TDvND_ub = TDvND_ub/3 if Tdv=="agree"
		replace TDvNA_estimate = TDvNA_estimate/3 if Tdv=="agree"
		replace TDvNA_se=TDvNA_se/3 if Tdv=="agree"
		replace TDvNA_lb = TDvNA_lb/3 if Tdv=="agree"
		replace TDvNA_ub = TDvNA_ub/3 if Tdv=="agree"

		* rescales the results for the feeling thermometer onto 0-1
		replace TDvND_estimate = TDvND_estimate/100 if Tdv=="therm"
		replace TDvND_se=TDvND_se/100 if Tdv=="therm"
		replace TDvND_lb = TDvND_lb/100 if Tdv=="therm"
		replace TDvND_ub = TDvND_ub/100 if Tdv=="therm"
		replace TDvNA_estimate = TDvNA_estimate/100 if Tdv=="therm"
		replace TDvNA_se=TDvNA_se/100 if Tdv=="therm"
		replace TDvNA_lb = TDvNA_lb/100 if Tdv=="therm"
		replace TDvNA_ub = TDvNA_ub/100 if Tdv=="therm"
		
		* rescales the results for the variable voterfor onto 0-1
		replace TDvND_estimate = TDvND_estimate/4 if Tdv=="votefor"
		replace TDvND_se=TDvND_se/4 if Tdv=="votefor"
		replace TDvND_lb = TDvND_lb/4 if Tdv=="votefor"
		replace TDvND_ub = TDvND_ub/4 if Tdv=="votefor"
		replace TDvNA_estimate = TDvNA_estimate/4 if Tdv=="votefor"
		replace TDvNA_se=TDvNA_se/4 if Tdv=="votefor"
		replace TDvNA_lb = TDvNA_lb/4 if Tdv=="votefor"
		replace TDvNA_ub = TDvNA_ub/4 if Tdv=="votefor"
		
		keep Tdv TDvND_estimate TDvND_lb TDvND_ub TDvNA_estimate TDvNA_lb TDvNA_ub
		keep in 1/18
		drop in 14/18
		drop in 7/11
		drop in 1/5
		ren Tdv DV
		ren TDvND_estimate TDvND_mean
		ren TDvNA_estimate TDvNA_mean
		export delimited figure1output.txt, delim(tab) replace
}	
******************************* TABLE 5 ****************************************
* Table 5 based on linear combinations of coefficients in a series
* of regressions.   The code below quietly runs the regressions and then
* reports the linear combinations that are reported in the cells of the table. 
* The code below produces the output for Table 5 and saves it in a tab-delimited 
* text file called "table5output.txt" in the working folder. To produce a 
* replica of Table 5, first import "table5output.txt" into Excel, copy the 
* entire contents of the imported table, and then paste them into the 
* "Table 5 Output" tab of the Excel file titled "Tables for Experiment 2." 
* Place the top left cell at row A, column 1, and this will update the linked 
* formatted table in the tab "Table 5" 	
quietly{
clear all
do "study2replication_makedata.do"

clear all
set more off
use "study2replication.dta"


*************************** DATA PREP AND RECODES ******************************


* replace letter labels with desciptive labels, first element contains senators position second element contains respondents
label define letter 1 "Pro to Pro" 2 "Pro to Anti" 3 "Anti to Pro" 4 "Anti to Anti" 5 "Pro to All" 6 "Anti to All"
label values firstletter letter
label values secondletter letter

* generate dummies for each type of letter
tab firstletter, gen(firstletter_dum)
ren firstletter_dum1 pro_pro_1
ren firstletter_dum2 pro_anti_1
ren firstletter_dum3 anti_pro_1
ren firstletter_dum4 anti_anti_1
ren firstletter_dum5 pro_all_1
ren firstletter_dum6 anti_all_1

*change and scaling of polarity of agreement so higher numbers mean more agreement
recode firstsen_agree 1=4 2=3 3=2 4=1
recode secondsen_agree 1=4 2=3 3=2 4=1
label define agree_withsen 1 "Strongly disagree"  4 "Strongly agree"
label values firstsen_agree agree_withsen
label values secondsen_agree agree_withsen

*change polarity of vote likelihood so higher numbers mean higher vote likelihood
recode firstsen_votefor 1=5 2=4 3=3 4=2 5=1
recode secondsen_votefor 1=5 2=4 3=3 4=2 5=1
label define votefor 1 "Not likely at all" 2 "Not too likely" 3 "Somewhat likely" 4 "Very likely" 5 "Extremely likely", replace
label values firstsen_votefor votefor
label values secondsen_votefor votefor

*generate a variable for perceived agreement based on whether the respondents own position matches their assessment of
*the senator's general position and their perception of how the senator voted.
gen firstsen_perceive_agree = 1 if (firstsen_position==1 & (preLetterSupport==1|preLetterSupport==2))|(firstsen_position==2 & (preLetterSupport==3|preLetterSupport==4))
replace firstsen_perceive_agree = 0 if (firstsen_position==2 & (preLetterSupport==1|preLetterSupport==2))|(firstsen_position==1 & (preLetterSupport==3|preLetterSupport==4))
gen firstsen_perceive_voted_agree = 1 if (firstsen_voted==1 & (preLetterSupport==1|preLetterSupport==2))|(firstsen_voted==2 & (preLetterSupport==3|preLetterSupport==4))
replace firstsen_perceive_voted_agree = 0 if (firstsen_voted==2 & (preLetterSupport==1|preLetterSupport==2))|(firstsen_voted==1 & (preLetterSupport==3|preLetterSupport==4))

*change polarity of trait scores so higher numbers mean higher trait evaluation
label define trait 0 "Not well at all"  1 "Extremely well"
foreach trait in honest leader knowledge openminded hardworking {
recode firstsen_`trait' 1=1 2=.75 3=.5 4=.25 5=0
recode secondsen_`trait' 1=1 2=.75 3=.5 4=.25 5=0
label values firstsen_`trait' trait
label values secondsen_`trait' trait
}

* generate a variable indicating whether the respondent is correct about the general position of the senator
gen firstsen_position_correct = 0 if (firstsen_position == 1 & (firstletter==3|firstletter==4|firstletter==6)) 
replace firstsen_position_correct = 0 if (firstsen_position == 2 & (firstletter==1|firstletter==2|firstletter==5))
replace firstsen_position_correct = 1 if (firstsen_position == 2 & (firstletter==3|firstletter==4|firstletter==6))
replace firstsen_position_correct = 1 if (firstsen_position == 1 & (firstletter==1|firstletter==2|firstletter==5))
label variable firstsen_position_correct "Correct about Senator's General Position"
label define correct 0 "Incorrect" 1 "Correct"
label values firstsen_position_correct correct

* generate a variable indication whether the respondent is correct about the immigration reform roll call cast by the senator
gen firstsen_roll_correct = 0 if (firstsen_voted == 1 & (firstletter==3|firstletter==4|firstletter==6)) 
replace firstsen_roll_correct = 0 if (firstsen_voted == 2 & (firstletter==1|firstletter==2|firstletter==5))
replace firstsen_roll_correct = 1 if (firstsen_voted == 2 & (firstletter==3|firstletter==4|firstletter==6))
replace firstsen_roll_correct = 1 if (firstsen_voted == 1 & (firstletter==1|firstletter==2|firstletter==5))
label variable firstsen_roll_correct "Correct about Senator's Roll Call Vote"
label values firstsen_roll_correct correct

* change the polarity of the certainty variable and rescale so it spans 0 to 1 and can be in same table as correctness variables
recode firstsen_certainty 5=0 4=.25 3=.50 2=.75 1=1
label define certainty_rescale 1 "Extremely certain" 0 "Not certain at all"
label values firstsen_certainty certainty_rescale

*generate dummy variables that are interactions between letter types and respondent pre-treatment positions on immigration for use in saturated models
foreach letter in pro_pro_1 pro_anti_1 anti_pro_1 anti_anti_1 pro_all_1 anti_all_1 {
	gen `letter'ss=cond(preLetterSupport==1 & `letter'==1 ,1,0)
	gen `letter'ws=cond(preLetterSupport==2 & `letter'==1 ,1,0)
	gen `letter'wo=cond(preLetterSupport==3 & `letter'==1 ,1,0)
	gen `letter'so=cond(preLetterSupport==4 & `letter'==1 ,1,0)
	}

gen str target = ""
replace target = "Not Targeted" in 1
replace target = "Toward Disagree" in 2
replace target = "Not Targeted - Toward Disagree" in 3

/*analysis whether respondent was correct about senator's position for Column 1 of Table 5*/
gen position_correct = .
gen position_correct_lb = .
gen position_correct_ub = .
quietly reg firstsen_position_correct pro_pro_1 anti_anti_1 pro_all_1 anti_all_1 pro_anti_1 anti_pro_1, nocons
* letter not targeted (column 1, row 1)
lincom .5*pro_all_1 + .5*anti_all_1
replace position_correct = r(estimate)*100 in 1
* letter targeted toward voter who disagrees (column 1, row 2)
lincom .5*pro_anti_1 + .5*anti_pro_1 
replace position_correct = r(estimate)*100 in 2
* difference between letters and confidence interval (column 1, rows 3 and 4)
lincom (.5*pro_all_1 + .5*anti_all_1) - (.5*pro_anti_1 + .5*anti_pro_1)
replace position_correct = r(estimate)*100 in 3
replace position_correct_lb = (r(estimate) - 1.96*r(se))*100 in 3
replace position_correct_ub = (r(estimate) + 1.96*r(se))*100 in 3

/*analysis whether respondent was correct about senator's roll call vote for Column 2 of Table 5*/
gen roll_correct = .
gen roll_correct_lb = .
gen roll_correct_ub = .
quietly reg firstsen_roll_correct pro_pro_1 anti_anti_1 pro_all_1 anti_all_1 pro_anti_1 anti_pro_1, nocons
* letter not targeted (column 2, row 1)
lincom .5*pro_all_1 + .5*anti_all_1
replace roll_correct = r(estimate)*100 in 1
* letter targeted toward voter who disagrees (column 2, row 2)
lincom .5*pro_anti_1 + .5*anti_pro_1 
replace roll_correct = r(estimate)*100 in 2
* difference between letters and confidence interval (column 2, rows 3 and 4)
lincom (.5*pro_all_1 + .5*anti_all_1) - (.5*pro_anti_1 + .5*anti_pro_1)
replace roll_correct = r(estimate)*100 in 3
replace roll_correct_lb = (r(estimate) - 1.96*r(se))*100 in 3
replace roll_correct_ub = (r(estimate) + 1.96*r(se))*100 in 3

/*analysis of certainty about senator's position for Column 3 of Table 5*/
gen certainty = .
gen certainty_lb = .
gen certainty_ub = .
quietly reg firstsen_certainty pro_pro_1 anti_anti_1 pro_all_1 anti_all_1 pro_anti_1 anti_pro_1, nocons
* letter not targeted (column 3, row 1)
lincom .5*pro_all_1 + .5*anti_all_1
replace certainty = r(estimate)*100 in 1
* letter targeted toward voter who disagrees (column 3, row 2)
lincom .5*pro_anti_1 + .5*anti_pro_1 
replace certainty = r(estimate)* 100 in 2
* difference between letters and confidence interval (column 2, rows 3 and 4)
lincom (.5*pro_all_1 + .5*anti_all_1) - (.5*pro_anti_1 + .5*anti_pro_1)
replace certainty = r(estimate)*100 in 3
replace certainty_lb = (r(estimate) - 1.96*r(se))*100 in 3
replace certainty_ub = (r(estimate) + 1.96*r(se))*100 in 3

keep target position_correct position_correct_lb position_correct_ub roll_correct roll_correct_lb roll_correct_ub certainty certainty_lb certainty_ub
keep in 1/3
export delimited table5output.txt, delim(tab) replace
}

****************************** TABLE 6 *****************************************
* The regression below is the basis for the top three rows in Table 6.
* The regression is followed by commands the execute the hypothesis tests 
* presented in rows 5 and 6 of Table 6.
* The code below produces the output for Table 6 and saves it in a tab-delimited 
* text file called "table6output.txt" in the working folder. To produce a 
* replica of Table 6, first import "table6output.txt" into Excel, copy the 
* entire contents of the imported table, and then paste them into the 
* "Table 6 Output" tab of the Excel file titled "Tables for Experiment 2." 
* Place the top left cell at row A, column 1, and this will update the linked 
* formatted table in the tab "Table 6" 	
quietly{
clear all
do "study2replication_makedata.do"

clear all
set more off
use "study2replication.dta"


*************************** DATA PREP AND RECODES ******************************


* replace letter labels with desciptive labels, first element contains senators position second element contains respondents
label define letter 1 "Pro to Pro" 2 "Pro to Anti" 3 "Anti to Pro" 4 "Anti to Anti" 5 "Pro to All" 6 "Anti to All"
label values firstletter letter
label values secondletter letter

* generate dummies for each type of letter
tab firstletter, gen(firstletter_dum)
ren firstletter_dum1 pro_pro_1
ren firstletter_dum2 pro_anti_1
ren firstletter_dum3 anti_pro_1
ren firstletter_dum4 anti_anti_1
ren firstletter_dum5 pro_all_1
ren firstletter_dum6 anti_all_1

*change and scaling of polarity of agreement so higher numbers mean more agreement
recode firstsen_agree 1=4 2=3 3=2 4=1
recode secondsen_agree 1=4 2=3 3=2 4=1
label define agree_withsen 1 "Strongly disagree"  4 "Strongly agree"
label values firstsen_agree agree_withsen
label values secondsen_agree agree_withsen

*change polarity of vote likelihood so higher numbers mean higher vote likelihood
recode firstsen_votefor 1=5 2=4 3=3 4=2 5=1
recode secondsen_votefor 1=5 2=4 3=3 4=2 5=1
label define votefor 1 "Not likely at all" 2 "Not too likely" 3 "Somewhat likely" 4 "Very likely" 5 "Extremely likely", replace
label values firstsen_votefor votefor
label values secondsen_votefor votefor

*generate a variable for perceived agreement based on whether the respondents own position matches their assessment of
*the senator's general position and their perception of how the senator voted.
gen firstsen_perceive_agree = 1 if (firstsen_position==1 & (preLetterSupport==1|preLetterSupport==2))|(firstsen_position==2 & (preLetterSupport==3|preLetterSupport==4))
replace firstsen_perceive_agree = 0 if (firstsen_position==2 & (preLetterSupport==1|preLetterSupport==2))|(firstsen_position==1 & (preLetterSupport==3|preLetterSupport==4))
gen firstsen_perceive_voted_agree = 1 if (firstsen_voted==1 & (preLetterSupport==1|preLetterSupport==2))|(firstsen_voted==2 & (preLetterSupport==3|preLetterSupport==4))
replace firstsen_perceive_voted_agree = 0 if (firstsen_voted==2 & (preLetterSupport==1|preLetterSupport==2))|(firstsen_voted==1 & (preLetterSupport==3|preLetterSupport==4))

*change polarity of trait scores so higher numbers mean higher trait evaluation
label define trait 0 "Not well at all"  1 "Extremely well"
foreach trait in honest leader knowledge openminded hardworking {
recode firstsen_`trait' 1=1 2=.75 3=.5 4=.25 5=0
recode secondsen_`trait' 1=1 2=.75 3=.5 4=.25 5=0
label values firstsen_`trait' trait
label values secondsen_`trait' trait
}

* generate a variable indicating whether the respondent is correct about the general position of the senator
gen firstsen_position_correct = 0 if (firstsen_position == 1 & (firstletter==3|firstletter==4|firstletter==6)) 
replace firstsen_position_correct = 0 if (firstsen_position == 2 & (firstletter==1|firstletter==2|firstletter==5))
replace firstsen_position_correct = 1 if (firstsen_position == 2 & (firstletter==3|firstletter==4|firstletter==6))
replace firstsen_position_correct = 1 if (firstsen_position == 1 & (firstletter==1|firstletter==2|firstletter==5))
label variable firstsen_position_correct "Correct about Senator's General Position"
label define correct 0 "Incorrect" 1 "Correct"
label values firstsen_position_correct correct

* generate a variable indication whether the respondent is correct about the immigration reform roll call cast by the senator
gen firstsen_roll_correct = 0 if (firstsen_voted == 1 & (firstletter==3|firstletter==4|firstletter==6)) 
replace firstsen_roll_correct = 0 if (firstsen_voted == 2 & (firstletter==1|firstletter==2|firstletter==5))
replace firstsen_roll_correct = 1 if (firstsen_voted == 2 & (firstletter==3|firstletter==4|firstletter==6))
replace firstsen_roll_correct = 1 if (firstsen_voted == 1 & (firstletter==1|firstletter==2|firstletter==5))
label variable firstsen_roll_correct "Correct about Senator's Roll Call Vote"
label values firstsen_roll_correct correct

* change the polarity of the certainty variable and rescale so it spans 0 to 1 and can be in same table as correctness variables
recode firstsen_certainty 5=0 4=.25 3=.50 2=.75 1=1
label define certainty_rescale 1 "Extremely certain" 0 "Not certain at all"
label values firstsen_certainty certainty_rescale

*generate dummy variables that are interactions between letter types and respondent pre-treatment positions on immigration for use in saturated models
foreach letter in pro_pro_1 pro_anti_1 anti_pro_1 anti_anti_1 pro_all_1 anti_all_1 {
	gen `letter'ss=cond(preLetterSupport==1 & `letter'==1 ,1,0)
	gen `letter'ws=cond(preLetterSupport==2 & `letter'==1 ,1,0)
	gen `letter'wo=cond(preLetterSupport==3 & `letter'==1 ,1,0)
	gen `letter'so=cond(preLetterSupport==4 & `letter'==1 ,1,0)
	}

	
gen letter_type = "Targeted to Disagree" in 1
replace letter_type = "95% CI" in 2
replace letter_type = "Not Targeted" in 3
replace letter_type = "95% CI" in 4
replace letter_type = "Targeted to Agree" in 5
replace letter_type = "95% CI" in 6
replace letter_type = "Disagree - Not Targeted" in 7
replace letter_type = "95% CI" in 8
replace letter_type = "Disagree - Agree" in 9
replace letter_type = "95% CI" in 10
gen pro_immigration = .
gen pro_immigration_ub = .
gen anti_immigration = .
gen anti_immigration_ub = .

reg firstsen_ideology pro_anti_1 pro_all_1 pro_pro_1 anti_pro_1 anti_all_1 anti_anti_1, nocons

* first row in left column
lincom pro_anti_1
replace pro_immigration = r(estimate) in 1
replace pro_immigration = (r(estimate) - 1.96*r(se)) in 2
replace pro_immigration_ub = (r(estimate) + 1.96*r(se)) in 2

* second row in left column
lincom pro_all_1
replace pro_immigration = r(estimate) in 3
replace pro_immigration = (r(estimate) - 1.96*r(se)) in 4
replace pro_immigration_ub = (r(estimate) + 1.96*r(se)) in 4

* third row in left column
lincom pro_pro_1
replace pro_immigration = r(estimate) in 5
replace pro_immigration = (r(estimate) - 1.96*r(se)) in 6
replace pro_immigration_ub = (r(estimate) + 1.96*r(se)) in 6

* fourth row in left coulumn*
lincom pro_anti_1-pro_all_1 
replace pro_immigration = r(estimate) in 7
replace pro_immigration = (r(estimate) - 1.96*r(se)) in 8
replace pro_immigration_ub = (r(estimate) + 1.96*r(se)) in 8

* fifth row in left coulumn*
lincom pro_anti_1-pro_pro_1 
replace pro_immigration = r(estimate) in 9
replace pro_immigration = (r(estimate) - 1.96*r(se)) in 10
replace pro_immigration_ub = (r(estimate) + 1.96*r(se)) in 10

* first row in right column
lincom anti_pro_1
replace anti_immigration = r(estimate) in 1
replace anti_immigration = (r(estimate) - 1.96*r(se)) in 2
replace anti_immigration_ub = (r(estimate) + 1.96*r(se)) in 2

* second row in right column
lincom anti_all_1
replace anti_immigration = r(estimate) in 3
replace anti_immigration = (r(estimate) - 1.96*r(se)) in 4
replace anti_immigration_ub = (r(estimate) + 1.96*r(se)) in 4

* third row in right column
lincom anti_anti_1
replace anti_immigration = r(estimate) in 5
replace anti_immigration = (r(estimate) - 1.96*r(se)) in 6
replace anti_immigration_ub = (r(estimate) + 1.96*r(se)) in 6

* fourth row in right coulumn*
lincom anti_pro_1-anti_all_1 
replace anti_immigration = r(estimate) in 7
replace anti_immigration = (r(estimate) - 1.96*r(se)) in 8
replace anti_immigration_ub = (r(estimate) + 1.96*r(se)) in 8

* fifth row in right coulumn*
lincom anti_pro_1-anti_anti_1 
replace anti_immigration = r(estimate) in 9
replace anti_immigration = (r(estimate) - 1.96*r(se)) in 10
replace anti_immigration_ub = (r(estimate) + 1.96*r(se)) in 10

keep letter_type pro_immigration pro_immigration_ub anti_immigration anti_immigration_ub
keep in 1/10
export delimited table6output.txt, delim(tab) replace
}

*********************TABLES IN THE ONLINE MATERIALS ****************************
* To access the output for any one appendix run the code for that appendix
* only.   To do that highlight the text explaining the appendix, the collapsed
* code below it that is being run quietly, an any addition code before the tex
* that explains the next appendix.   If you want to be sure you are getting 
* everything, you can run the first line of the text explaining the next 
* appendix.  The code for the later appendicies will overwrite the code for the
* earlier ones if you run more than one appendix at a time.  

************************** Appendix 7 ********************************
* This uses the qualtrics data and 2008 NES data to produce tables that compare
* the demographics of the two data sets.  It produces a table and saves it to a
* tab-delimited text file called "tableA7output.txt".  To produce a 
* replica of Table A7, first import "tableA7output.txt" into Excel, copy the 
* entire contents of the imported table, and then paste them into the 
* "Table A7 Output" tab of the Excel file titled "Tables for Experiment 2." 
* Place the top left cell at row A, column 1, and this will update the linked 
* formatted table in the tab "Table A7." The code was written by nm, and 
* updated by rvh on 6/19/14 to produce the table automatically.
quietly{
clear all
do "study2replication_makedata.do"

clear all
set more off
use "study2replication.dta"

gen agecat = .
recode agecat (.=1) if age>=18&age<=29
recode agecat (.=2) if age>=30&age<=39
recode agecat (.=3) if age>=40&age<=49
recode agecat (.=4) if age>=50&age<=64
recode agecat (.=5) if age>=65
drop age
ren agecat age
replace education = education + 1
recode race 3/6= 2 
recode pid 1=0 2=1 3=2
gen sample = 1
*keep if preLetterSupport~=.
keep sample gender age race education pid

save samples.dta, replace

clear all
use "anes_timeseries_2008.dta"
gen agecat = .
recode agecat (.=1) if V083215x>=18&V083215x<=29
recode agecat (.=2) if V083215x>=30&V083215x<=39
recode agecat (.=3) if V083215x>=40&V083215x<=49
recode agecat (.=4) if V083215x>=50&V083215x<=64
recode agecat (.=5) if V083215x>=65


ren  V081101 gender
ren agecat age
replace V083251a = . if V083251a <= 0
ren V083251a race
recode race 10/40=2 50=1 81/84=2 85=1 *=.
replace V083218x = . if V083218x<=-1 
ren V083218x education
replace V083098x = . if V083098x<=-1 
ren V083098x pid
gen sample = 2

keep sample gender age race education pid
append using samples.dta

label variable sample "Sample"
label define sample 1 "MTurk Study" 2 "2008 ANES"
label values sample sample
save samples.dta, replace

label variable age "Age"
label define age 1 "18-29" 2 "30-39" 3 "40-49" 4 "50-64" 5 "65+"
label values age age

label variable gender "Gender"
label define gender 1 "Male" 2 "Female", replace
label values gender gender

replace education =. if education == 0
replace education = 2 if education < 2
label variable education "Education"
label define education 2 "Less than High School" 3 "High School Diploma" 4 "Some College" 5 "Associate's Degree" 6 "Bachelor's Degree" 7 "Graduate Degree", replace
label values education education

label variable race "Race"
label define race 1 "White" 2 "Non-White", replace
label values race race

label variable pid "Party ID"
label define pid 0 "Strong Democrat" 1 "Not Strong Democrat" 2 "Lean Democrat" 3 "Independent" 4 "Lean Republican" 5 "Not Strong Republican" 6 "Strong Republican", replace
label values pid pid
tabout gender age race education pid sample using tableA7output.txt, cells(col) format(1c) ptotal(none) h3(nil) npos(row) nlab(Sample Size) replace
}

************************** Appendix 8 *********************************
* This appendix presents results in Table 4 broken down by the extremity
* of the position respondents take on immigration. It produces a table and saves 
* it to a tab-delimited text file called  "tableA8output.txt".  Appendix 8 
* contains three tables for different dependent variables. To create replicas 
* first import  "tableA8output.txt" into Excel, copy the entire contents 
* of the imported table, and then paste them into the "Table A8 Output" tab of 
* the Excel file titled "Tables for Experiment 2."  Place the top left cell at 
* row A, column 1. This will update all three of the linked tables in the tabs 
* "Table A8.1, "Table A8.2" and Table A8.3".
quietly{

clear all
do "study2replication_makedata.do"

clear all
set more off
use "study2replication.dta"

* rpvh 6/4/2014

********************* DATA PREP AND RECODES ******************************


* replace letter labels with desciptive labels, first element contains senators position second element contains respondents
label define letter 1 "Pro to Pro" 2 "Pro to Anti" 3 "Anti to Pro" 4 "Anti to Anti" 5 "Pro to All" 6 "Anti to All"
label values firstletter letter
label values secondletter letter

* generate dummies for each type of letter
tab firstletter, gen(firstletter_dum)
ren firstletter_dum1 pro_pro_1
ren firstletter_dum2 pro_anti_1
ren firstletter_dum3 anti_pro_1
ren firstletter_dum4 anti_anti_1
ren firstletter_dum5 pro_all_1
ren firstletter_dum6 anti_all_1

*change and scaling of polarity of agreement so higher numbers mean more agreement
recode firstsen_agree 1=4 2=3 3=2 4=1
recode secondsen_agree 1=4 2=3 3=2 4=1
label define agree_withsen 1 "Strongly disagree"  4 "Strongly agree"
label values firstsen_agree agree_withsen
label values secondsen_agree agree_withsen

*change polarity of vote likelihood so higher numbers mean higher vote likelihood
recode firstsen_votefor 1=5 2=4 3=3 4=2 5=1
recode secondsen_votefor 1=5 2=4 3=3 4=2 5=1
label define votefor 1 "Not likely at all" 2 "Not too likely" 3 "Somewhat likely" 4 "Very likely" 5 "Extremely likely", replace
label values firstsen_votefor votefor
label values secondsen_votefor votefor

*generate a variable for perceived agreement based on whether the respondents own position matches their assessment of
*the senator's general position and their perception of how the senator voted.
gen firstsen_perceive_agree = 1 if (firstsen_position==1 & (preLetterSupport==1|preLetterSupport==2))|(firstsen_position==2 & (preLetterSupport==3|preLetterSupport==4))
replace firstsen_perceive_agree = 0 if (firstsen_position==2 & (preLetterSupport==1|preLetterSupport==2))|(firstsen_position==1 & (preLetterSupport==3|preLetterSupport==4))
gen firstsen_perceive_voted_agree = 1 if (firstsen_voted==1 & (preLetterSupport==1|preLetterSupport==2))|(firstsen_voted==2 & (preLetterSupport==3|preLetterSupport==4))
replace firstsen_perceive_voted_agree = 0 if (firstsen_voted==2 & (preLetterSupport==1|preLetterSupport==2))|(firstsen_voted==1 & (preLetterSupport==3|preLetterSupport==4))

*change polarity of trait scores so higher numbers mean higher trait evaluation
label define trait 0 "Not well at all"  1 "Extremely well"
foreach trait in honest leader knowledge openminded hardworking {
recode firstsen_`trait' 1=1 2=.75 3=.5 4=.25 5=0
recode secondsen_`trait' 1=1 2=.75 3=.5 4=.25 5=0
label values firstsen_`trait' trait
label values secondsen_`trait' trait
}

* generate a variable indicating whether the respondent is correct about the general position of the senator
gen firstsen_position_correct = 0 if (firstsen_position == 1 & (firstletter==3|firstletter==4|firstletter==6)) 
replace firstsen_position_correct = 0 if (firstsen_position == 2 & (firstletter==1|firstletter==2|firstletter==5))
replace firstsen_position_correct = 1 if (firstsen_position == 2 & (firstletter==3|firstletter==4|firstletter==6))
replace firstsen_position_correct = 1 if (firstsen_position == 1 & (firstletter==1|firstletter==2|firstletter==5))
label variable firstsen_position_correct "Correct about Senator's General Position"
label define correct 0 "Incorrect" 1 "Correct"
label values firstsen_position_correct correct

* generate a variable indication whether the respondent is correct about the immigration reform roll call cast by the senator
gen firstsen_roll_correct = 0 if (firstsen_voted == 1 & (firstletter==3|firstletter==4|firstletter==6)) 
replace firstsen_roll_correct = 0 if (firstsen_voted == 2 & (firstletter==1|firstletter==2|firstletter==5))
replace firstsen_roll_correct = 1 if (firstsen_voted == 2 & (firstletter==3|firstletter==4|firstletter==6))
replace firstsen_roll_correct = 1 if (firstsen_voted == 1 & (firstletter==1|firstletter==2|firstletter==5))
label variable firstsen_roll_correct "Correct about Senator's Roll Call Vote"
label values firstsen_roll_correct correct

* change the polarity of the certainty variable and rescale so it spans 0 to 1 and can be in same table as correctness variables
recode firstsen_certainty 5=0 4=.25 3=.50 2=.75 1=1
label define certainty_rescale 1 "Extremely certain" 0 "Not certain at all"
label values firstsen_certainty certainty_rescale

*generate dummy variables that are interactions between letter types and respondent pre-treatment positions on immigration for use in saturated models
foreach letter in pro_pro_1 pro_anti_1 anti_pro_1 anti_anti_1 pro_all_1 anti_all_1 {
	gen `letter'ss=cond(preLetterSupport==1 & `letter'==1 ,1,0)
	gen `letter'ws=cond(preLetterSupport==2 & `letter'==1 ,1,0)
	gen `letter'wo=cond(preLetterSupport==3 & `letter'==1 ,1,0)
	gen `letter'so=cond(preLetterSupport==4 & `letter'==1 ,1,0)
	}
	

* initiate variables that will contain the results of various linear combinations of coefficients from the saturated model
gen str Tdv = ""
gen str Ttarget = ""
gen str Trespondent = ""
gen Testimate = .
gen Tse = .
gen TestLB = .
gen TestUB = .
gen Tdf = .
gen TDvND_estimate = .
gen TDvND_se = .
gen TDvND_lb = .
gen TDvND_ub = .
gen TDvNA_estimate = .
gen TDvNA_se = .
gen TDvNA_lb = .
gen TDvNA_ub = .


local row = 1 
foreach dv in agree therm votefor /*honest leader knowledge openminded hardworking */ {
display "`dv'"
regress firstsen_`dv' pro_pro_1ss pro_pro_1ws pro_pro_1wo pro_pro_1so pro_anti_1ss pro_anti_1ws pro_anti_1wo pro_anti_1so anti_pro_1ss anti_pro_1ws anti_pro_1wo anti_pro_1so anti_anti_1ss anti_anti_1ws anti_anti_1wo anti_anti_1so pro_all_1ss pro_all_1ws pro_all_1wo pro_all_1so anti_all_1ss anti_all_1ws anti_all_1wo anti_all_1so /*if senparty==1| if senparty==2*/, nocons
	foreach target in agree_target agree_notarget agree_mistarget disagree_target disagree_notarget disagree_mistarget{
		foreach respondent in  /*s o a*/m e { /* this selects which respondents to include and how to divide them. s=supproters of reform, o=opponents, a= all respondents, m=respondents with moderate immigration positiions, e=respondents with extreme immigration positions*/
			* weights for estimates only including immigration reform supporters
			if "`respondent'" == "s"{
				local w1=.31 /* weight for strong supporters of immigration reform, .22 in sample, .31 among strong and weak supporters */
				local w2=.69 /* weight for weak supporters of immigration reform, .5 in sample, .69 among strong and weak supporters */
				local w3= 0 /* weight for strong opponents of immigration reform, .09 in sample, .32 among strong and weak opponents*/
				local w4= 0 /* weight for weak opponents of immigration reform, .19 in sample, .68 among strong and weak opponents */
				}
			* weights for estimates only including immigration reform opponents
			if "`respondent'" == "o"{
				local w1=0 /* weight for strong supporters of immigration reform, .22 in sample, .31 among strong and weak supporters */
				local w2=0 /* weight for weak supporters of immigration reform, .5 in sample, .69 among strong and weak supporters */
				local w3=.68 /* weight for weak opponents of immigration reform, .19 in sample, .68 among strong and weak opponents */
				local w4=.32 /* weight for strong opponents of immigration reform, .09 in sample, .32 among strong and weak opponents*/
				}
			* weights for estimates only including all respondents who took positions on immmigrating reform
			* these are the weights that we use in Table 4
			if "`respondent'" == "a"{
			    local w1=.22 /* weight for strong supporters of immigration reform, .22 in sample */
				local w2=.5 /* weight for weak supporters of immigration reform, .5 in sample */
				local w3=.19 /* weight for weak opponents of immigration reform, .19 in sample */
				local w4=.09 /* weight for strong opponents of immigration reform, .09 in sample */
				}
			* weights for estimates only including only respondents who took weak positions on either side of the issue
			if "`respondent'" == "m"{
			    local w1= 0 /* weight for strong supporters of immigration reform, .71 among strong suppoters and opponents */
				local w2=.72 /* weight for weak supporters of immigration reform, .72 among weak supporters and opponents */
				local w3=.28 /* weight for weak opponents of immigration reform, .28 among weak supporters and opponents */
				local w4= 0 /* weight for strong opponents of immigration reform, .29 among strong suppoters and opponents */
				}
			* weights for estimates only including only respondents who took strong positions on either side of the issue
			if "`respondent'" == "e"{
			    local w1= .71 /* weight for strong supporters of immigration reform, .71 among strong suppoters and opponents */
				local w2= 0/* weight for weak supporters of immigration reform, .72 among weak supporters and opponents */
				local w3= 0 /* weight for weak opponents of immigration reform, .28 among weak supporters and opponents */
				local w4= .29 /* weight for strong opponents of immigration reform, .29 among strong suppoters and opponents */
				}
				if "`target'" == "agree_target" {
					local letter1 = "pro_pro"
					local letter2 = "anti_anti"
					}
				if "`target'" == "agree_notarget" {
					local letter1 = "pro_all"
					local letter2 = "anti_all"
					}
				if "`target'" == "agree_mistarget" {
					local letter1 = "pro_anti"
					local letter2 = "anti_pro"
					}
				if "`target'" == "disagree_target" {
					local letter1 = "anti_pro"
					local letter2 = "pro_anti"
					}
				if "`target'" == "disagree_notarget" {
					local letter1 = "anti_all"
					local letter2 = "pro_all"
					}
				if "`target'" == "disagree_mistarget" {
					local letter1 = "anti_anti"
					local letter2 = "pro_pro"
					}
				lincom `w1'*`letter1'_1ss+`w2'*`letter1'_1ws + `w3'*`letter2'_1wo+`w4'*`letter2'_1so
				replace Tdv = "`dv'" in `row'
				replace Ttarget = "`target'" in `row'
				replace Trespondent = "`respondent'" in `row'
				replace Testimate = r(estimate) in `row'
				replace Tse = r(se) in `row'
				replace Tdf = r(df) in `row' 
				
				display "tests hypothesis that compensating letter to opposing constituents is different that constitent letter to opposing constituents."
				lincom (`w1'*anti_pro_1ss+`w2'*anti_pro_1ws +`w3'*pro_anti_1wo+`w4'*pro_anti_1so) - (`w1'*anti_all_1ss+`w2'*anti_all_1ws +`w3'*pro_all_1wo+`w4'*pro_all_1so)
				replace TDvND_estimate = r(estimate) in `row'
				replace TDvND_se = r(se) in `row'
				dis "tests hypothesis that compensating letter to opposing constituents is different from constitent letter to agreeable constituents."
				lincom (`w1'*anti_pro_1ss+`w2'*anti_pro_1ws + `w3'*pro_anti_1wo+`w4'*pro_anti_1so) - (`w1'*pro_all_1ss+`w2'*pro_all_1ws +`w3'*anti_all_1wo+`w4'*anti_all_1so)
				replace TDvNA_estimate = r(estimate) in `row'
				replace TDvNA_se = r(se) in `row'
				local row = `row' + 1
				}
			}
		}
		replace TestLB = Testimate - 1.96*(Tse)
		replace TestUB = Testimate + 1.96*(Tse)
		replace TDvND_lb = TDvND_estimate - 1.96*(TDvND_se)
		replace TDvND_ub = TDvND_estimate + 1.96*(TDvND_se)
		replace TDvNA_lb = TDvNA_estimate - 1.96*(TDvNA_se)
		replace TDvNA_ub = TDvNA_estimate + 1.96*(TDvNA_se)
		
keep Tdv Trespondent Ttarget Testimate TestLB TestUB TDvND_estimate TDvND_lb TDvND_ub TDvNA_estimate TDvNA_lb TDvNA_ub
keep in 1/36
ren Tdv DV
ren Ttarget Treatment
ren Testimate Mean
ren TestLB LowerBound
ren TestUB UpperBound
replace Treatment="Agree - Targeted Toward" if Treatment=="agree_target"
replace Treatment="Agree - Not Targeted" if Treatment=="agree_notarget"
replace Treatment="Agree - Targeted Away" if Treatment=="agree_mistarget"
replace Treatment="Disagree - Targeted Toward" if Treatment=="disagree_target"
replace Treatment="Disagree - Not Targeted" if Treatment=="disagree_notarget"
replace Treatment="Disagree - Targeted Away" if Treatment=="disagree_mistarget"
ren TDvND_estimate TDvND_mean
ren TDvNA_estimate TDvNA_mean
export delimited tableA8output.txt, delim(tab) replace
}



************************** Appendix 10 *********************************
* This appendix presents the resutls of Table 4 broken down by the party of the
* senator who wrote the letter.  The party of the senator was randomly assigned
* and, thus, does not reflect the actual party of the senator in 1/2 of the 
* observations.  The code produces a table and saves it to a tab-delimited text 
* file called  "tableA10output.txt".  In that table the variable SenatorParty 
* indicates the party of the senator(1 = "Republican" 2 = "Democrat"). Appendix
* 10 contains three tables for different dependent variables. To createreplicas 
* first import  "tableA10output.txt" into Excel, copy the entire contents 
* of the imported table, and then paste them into the "Table A10 Output" tab of 
* the Excel file titled "Tables for Experiment 2."  Place the top left cell at 
* row A, column 1. This will update all three of the linked tables in the tabs 
* "Table A10.1, "Table A10.2" and Table A10.3".
quietly{

clear all
do "study2replication_makedata.do"

clear all
set more off
use "study2replication.dta"


* rpvh 6/4/2014

********************* DATA PREP AND RECODES ******************************

* replace letter labels with desciptive labels, first element contains senators position second element contains respondents
label define letter 1 "Pro to Pro" 2 "Pro to Anti" 3 "Anti to Pro" 4 "Anti to Anti" 5 "Pro to All" 6 "Anti to All"
label values firstletter letter
label values secondletter letter

* generate dummies for each type of letter
tab firstletter, gen(firstletter_dum)
ren firstletter_dum1 pro_pro_1
ren firstletter_dum2 pro_anti_1
ren firstletter_dum3 anti_pro_1
ren firstletter_dum4 anti_anti_1
ren firstletter_dum5 pro_all_1
ren firstletter_dum6 anti_all_1

*change and scaling of polarity of agreement so higher numbers mean more agreement
recode firstsen_agree 1=4 2=3 3=2 4=1
recode secondsen_agree 1=4 2=3 3=2 4=1
label define agree_withsen 1 "Strongly disagree"  4 "Strongly agree"
label values firstsen_agree agree_withsen
label values secondsen_agree agree_withsen

*change polarity of vote likelihood so higher numbers mean higher vote likelihood
recode firstsen_votefor 1=5 2=4 3=3 4=2 5=1
recode secondsen_votefor 1=5 2=4 3=3 4=2 5=1
label define votefor 1 "Not likely at all" 2 "Not too likely" 3 "Somewhat likely" 4 "Very likely" 5 "Extremely likely", replace
label values firstsen_votefor votefor
label values secondsen_votefor votefor

*generate a variable for perceived agreement based on whether the respondents own position matches their assessment of
*the senator's general position and their perception of how the senator voted.
gen firstsen_perceive_agree = 1 if (firstsen_position==1 & (preLetterSupport==1|preLetterSupport==2))|(firstsen_position==2 & (preLetterSupport==3|preLetterSupport==4))
replace firstsen_perceive_agree = 0 if (firstsen_position==2 & (preLetterSupport==1|preLetterSupport==2))|(firstsen_position==1 & (preLetterSupport==3|preLetterSupport==4))
gen firstsen_perceive_voted_agree = 1 if (firstsen_voted==1 & (preLetterSupport==1|preLetterSupport==2))|(firstsen_voted==2 & (preLetterSupport==3|preLetterSupport==4))
replace firstsen_perceive_voted_agree = 0 if (firstsen_voted==2 & (preLetterSupport==1|preLetterSupport==2))|(firstsen_voted==1 & (preLetterSupport==3|preLetterSupport==4))

*change polarity of trait scores so higher numbers mean higher trait evaluation
label define trait 0 "Not well at all"  1 "Extremely well"
foreach trait in honest leader knowledge openminded hardworking {
recode firstsen_`trait' 1=1 2=.75 3=.5 4=.25 5=0
recode secondsen_`trait' 1=1 2=.75 3=.5 4=.25 5=0
label values firstsen_`trait' trait
label values secondsen_`trait' trait
}

* generate a variable indicating whether the respondent is correct about the general position of the senator
gen firstsen_position_correct = 0 if (firstsen_position == 1 & (firstletter==3|firstletter==4|firstletter==6)) 
replace firstsen_position_correct = 0 if (firstsen_position == 2 & (firstletter==1|firstletter==2|firstletter==5))
replace firstsen_position_correct = 1 if (firstsen_position == 2 & (firstletter==3|firstletter==4|firstletter==6))
replace firstsen_position_correct = 1 if (firstsen_position == 1 & (firstletter==1|firstletter==2|firstletter==5))
label variable firstsen_position_correct "Correct about Senator's General Position"
label define correct 0 "Incorrect" 1 "Correct"
label values firstsen_position_correct correct

* generate a variable indication whether the respondent is correct about the immigration reform roll call cast by the senator
gen firstsen_roll_correct = 0 if (firstsen_voted == 1 & (firstletter==3|firstletter==4|firstletter==6)) 
replace firstsen_roll_correct = 0 if (firstsen_voted == 2 & (firstletter==1|firstletter==2|firstletter==5))
replace firstsen_roll_correct = 1 if (firstsen_voted == 2 & (firstletter==3|firstletter==4|firstletter==6))
replace firstsen_roll_correct = 1 if (firstsen_voted == 1 & (firstletter==1|firstletter==2|firstletter==5))
label variable firstsen_roll_correct "Correct about Senator's Roll Call Vote"
label values firstsen_roll_correct correct

* change the polarity of the certainty variable and rescale so it spans 0 to 1 and can be in same table as correctness variables
recode firstsen_certainty 5=0 4=.25 3=.50 2=.75 1=1
label define certainty_rescale 1 "Extremely certain" 0 "Not certain at all"
label values firstsen_certainty certainty_rescale

*generate dummy variables that are interactions between letter types and respondent pre-treatment positions on immigration for use in saturated models
foreach letter in pro_pro_1 pro_anti_1 anti_pro_1 anti_anti_1 pro_all_1 anti_all_1 {
	gen `letter'ss=cond(preLetterSupport==1 & `letter'==1 ,1,0)
	gen `letter'ws=cond(preLetterSupport==2 & `letter'==1 ,1,0)
	gen `letter'wo=cond(preLetterSupport==3 & `letter'==1 ,1,0)
	gen `letter'so=cond(preLetterSupport==4 & `letter'==1 ,1,0)
	}
	

* initiate variables that will contain the results of various linear combinations of coefficients from the saturated model
gen Sparty = .
gen str Tdv = ""
gen str Ttarget = ""
gen str Trespondent = ""
gen Testimate = .
gen Tse = .
gen TestLB = .
gen TestUB = .
gen Tdf = .
gen TDvND_estimate = .
gen TDvND_se = .
gen TDvND_lb = .
gen TDvND_ub = .
gen TDvNA_estimate = .
gen TDvNA_se = .
gen TDvNA_lb = .
gen TDvNA_ub = .
gen row = .
local row = 1
forvalues party = 1/2 {
	foreach dv in /*perceive_voted_agree perceive_agree*/ agree therm votefor /*honest leader knowledge openminded hardworking */ {
	display "`dv'"
	regress firstsen_`dv' pro_pro_1ss pro_pro_1ws pro_pro_1wo pro_pro_1so pro_anti_1ss pro_anti_1ws pro_anti_1wo pro_anti_1so anti_pro_1ss anti_pro_1ws anti_pro_1wo anti_pro_1so anti_anti_1ss anti_anti_1ws anti_anti_1wo anti_anti_1so pro_all_1ss pro_all_1ws pro_all_1wo pro_all_1so anti_all_1ss anti_all_1ws anti_all_1wo anti_all_1so if senparty==`party', nocons
		foreach target in agree_target agree_notarget agree_mistarget disagree_target disagree_notarget disagree_mistarget{
			foreach respondent in  /*s o*/ a /* m e */ { /* this selects which respondents to include and how to divide them. s=supproters of reform, o=opponents, a= all respondents, m=respondents with moderate immigration positiions, e=respondents with extreme immigration positions*/
				* weights for estimates only including immigration reform supporters
				if "`respondent'" == "s"{
					local w1=.31 /* weight for strong supporters of immigration reform, .22 in sample, .31 among strong and weak supporters */
					local w2=.69 /* weight for weak supporters of immigration reform, .5 in sample, .69 among strong and weak supporters */
					local w3= 0 /* weight for strong opponents of immigration reform, .09 in sample, .32 among strong and weak opponents*/
					local w4= 0 /* weight for weak opponents of immigration reform, .19 in sample, .68 among strong and weak opponents */
					}
				* weights for estimates only including immigration reform opponents
				if "`respondent'" == "o"{
					local w1=0 /* weight for strong supporters of immigration reform, .22 in sample, .31 among strong and weak supporters */
					local w2=0 /* weight for weak supporters of immigration reform, .5 in sample, .69 among strong and weak supporters */
					local w3=.68 /* weight for weak opponents of immigration reform, .19 in sample, .68 among strong and weak opponents */
					local w4=.32 /* weight for strong opponents of immigration reform, .09 in sample, .32 among strong and weak opponents*/
					}
				* weights for estimates only including all respondents who took positions on immmigrating reform
				* these are the weights that we use in Table 4
				if "`respondent'" == "a"{
					local w1=.22 /* weight for strong supporters of immigration reform, .22 in sample */
					local w2=.5 /* weight for weak supporters of immigration reform, .5 in sample */
					local w3=.19 /* weight for weak opponents of immigration reform, .19 in sample */
					local w4=.09 /* weight for strong opponents of immigration reform, .09 in sample */
					}
				* weights for estimates only including only respondents who took weak positions on either side of the issue
				if "`respondent'" == "m"{
					local w1= 0 /* weight for strong supporters of immigration reform, .71 among strong suppoters and opponents */
					local w2=.72 /* weight for weak supporters of immigration reform, .72 among weak supporters and opponents */
					local w3=.28 /* weight for weak opponents of immigration reform, .28 among weak supporters and opponents */
					local w4= 0 /* weight for strong opponents of immigration reform, .29 among strong suppoters and opponents */
					}
				* weights for estimates only including only respondents who took strong positions on either side of the issue
				if "`respondent'" == "e"{
					local w1= .71 /* weight for strong supporters of immigration reform, .71 among strong suppoters and opponents */
					local w2= 0/* weight for weak supporters of immigration reform, .72 among weak supporters and opponents */
					local w3= 0 /* weight for weak opponents of immigration reform, .28 among weak supporters and opponents */
					local w4= .29 /* weight for strong opponents of immigration reform, .29 among strong suppoters and opponents */
					}
					if "`target'" == "agree_target" {
						local letter1 = "pro_pro"
						local letter2 = "anti_anti"
						}
					if "`target'" == "agree_notarget" {
						local letter1 = "pro_all"
						local letter2 = "anti_all"
						}
					if "`target'" == "agree_mistarget" {
						local letter1 = "pro_anti"
						local letter2 = "anti_pro"
						}
					if "`target'" == "disagree_target" {
						local letter1 = "anti_pro"
						local letter2 = "pro_anti"
						}
					if "`target'" == "disagree_notarget" {
						local letter1 = "anti_all"
						local letter2 = "pro_all"
						}
					if "`target'" == "disagree_mistarget" {
						local letter1 = "anti_anti"
						local letter2 = "pro_pro"
						}
					lincom `w1'*`letter1'_1ss+`w2'*`letter1'_1ws + `w3'*`letter2'_1wo+`w4'*`letter2'_1so
					replace Sparty = `party' in `row'
					replace Tdv = "`dv'" in `row'
					replace Ttarget = "`target'" in `row'
					replace Trespondent = "`respondent'" in `row'
					replace Testimate = r(estimate) in `row'
					replace Tse = r(se) in `row'
					replace Tdf = r(df) in `row' 
					
					display "tests hypothesis that compensating letter to opposing constituents is different that constitent letter to opposing constituents."
					lincom (`w1'*anti_pro_1ss+`w2'*anti_pro_1ws +`w3'*pro_anti_1wo+`w4'*pro_anti_1so) - (`w1'*anti_all_1ss+`w2'*anti_all_1ws +`w3'*pro_all_1wo+`w4'*pro_all_1so)
					replace TDvND_estimate = r(estimate) in `row'
					replace TDvND_se = r(se) in `row'
					dis "tests hypothesis that compensating letter to opposing constituents is different from constitent letter to agreeable constituents."
					lincom (`w1'*anti_pro_1ss+`w2'*anti_pro_1ws + `w3'*pro_anti_1wo+`w4'*pro_anti_1so) - (`w1'*pro_all_1ss+`w2'*pro_all_1ws +`w3'*anti_all_1wo+`w4'*anti_all_1so)
					replace TDvNA_estimate = r(estimate) in `row'
					replace TDvNA_se = r(se) in `row'
					replace row = `row' in `row'
					local row = `row' + 1
					}
				}
			}
		}
		replace TestLB = Testimate - 1.96*(Tse)
		replace TestUB = Testimate + 1.96*(Tse)
		replace TDvND_lb = TDvND_estimate - 1.96*(TDvND_se)
		replace TDvND_ub = TDvND_estimate + 1.96*(TDvND_se)
		replace TDvNA_lb = TDvNA_estimate - 1.96*(TDvNA_se)
		replace TDvNA_ub = TDvNA_estimate + 1.96*(TDvNA_se)
		
keep Tdv Sparty Ttarget Testimate TestLB TestUB TDvND_estimate TDvND_lb TDvND_ub TDvNA_estimate TDvNA_lb TDvNA_ub row
keep in 1/36
ren Tdv DV
ren Ttarget Treatment
ren Sparty SenatorParty
label define SenatorParty 1 "Republican" 2 "Democrat"
ren Testimate Mean
ren TestLB LowerBound
ren TestUB UpperBound
replace Treatment="Agree - Targeted Toward" if Treatment=="agree_target"
replace Treatment="Agree - Not Targeted" if Treatment=="agree_notarget"
replace Treatment="Agree - Targeted Away" if Treatment=="agree_mistarget"
replace Treatment="Disagree - Targeted Toward" if Treatment=="disagree_target"
replace Treatment="Disagree - Not Targeted" if Treatment=="disagree_notarget"
replace Treatment="Disagree - Targeted Away" if Treatment=="disagree_mistarget"
ren TDvND_estimate TDvND_mean
ren TDvNA_estimate TDvNA_mean
replace row = row-18 if row>18
sort row SenatorParty
drop row
export delimited tableA10output.txt, delim(tab) replace
}		
		
		
************************** Appendix 11 *********************************
* This appendix presents results in Table 4 broken down by the position 
* respondents take on immigration (pro or anti). It produces a table and saves 
* it to a tab-delimited text file called  "tableA11output.txt".  Appendix 11 
* contains three tables for different dependent variables. To create replicas 
* first import  "tableA11output.txt" into Excel, copy the entire contents 
* of the imported table, and then paste them into the "Table A11 Output" tab of 
* the Excel file titled "Tables for Experiment 2."  Place the top left cell at 
* row A, column 1. This will update all three of the linked tables in the tabs 
* "Table A11.1, "Table A11.2" and Table A11.3".
quietly{

clear all
do "study2replication_makedata.do"

clear all
set more off
use "study2replication.dta"

* rpvh 6/4/2014

********************* DATA PREP AND RECODES ******************************


* replace letter labels with desciptive labels, first element contains senators position second element contains respondents
label define letter 1 "Pro to Pro" 2 "Pro to Anti" 3 "Anti to Pro" 4 "Anti to Anti" 5 "Pro to All" 6 "Anti to All"
label values firstletter letter
label values secondletter letter

* generate dummies for each type of letter
tab firstletter, gen(firstletter_dum)
ren firstletter_dum1 pro_pro_1
ren firstletter_dum2 pro_anti_1
ren firstletter_dum3 anti_pro_1
ren firstletter_dum4 anti_anti_1
ren firstletter_dum5 pro_all_1
ren firstletter_dum6 anti_all_1

*change and scaling of polarity of agreement so higher numbers mean more agreement
recode firstsen_agree 1=4 2=3 3=2 4=1
recode secondsen_agree 1=4 2=3 3=2 4=1
label define agree_withsen 1 "Strongly disagree"  4 "Strongly agree"
label values firstsen_agree agree_withsen
label values secondsen_agree agree_withsen

*change polarity of vote likelihood so higher numbers mean higher vote likelihood
recode firstsen_votefor 1=5 2=4 3=3 4=2 5=1
recode secondsen_votefor 1=5 2=4 3=3 4=2 5=1
label define votefor 1 "Not likely at all" 2 "Not too likely" 3 "Somewhat likely" 4 "Very likely" 5 "Extremely likely", replace
label values firstsen_votefor votefor
label values secondsen_votefor votefor

*generate a variable for perceived agreement based on whether the respondents own position matches their assessment of
*the senator's general position and their perception of how the senator voted.
gen firstsen_perceive_agree = 1 if (firstsen_position==1 & (preLetterSupport==1|preLetterSupport==2))|(firstsen_position==2 & (preLetterSupport==3|preLetterSupport==4))
replace firstsen_perceive_agree = 0 if (firstsen_position==2 & (preLetterSupport==1|preLetterSupport==2))|(firstsen_position==1 & (preLetterSupport==3|preLetterSupport==4))
gen firstsen_perceive_voted_agree = 1 if (firstsen_voted==1 & (preLetterSupport==1|preLetterSupport==2))|(firstsen_voted==2 & (preLetterSupport==3|preLetterSupport==4))
replace firstsen_perceive_voted_agree = 0 if (firstsen_voted==2 & (preLetterSupport==1|preLetterSupport==2))|(firstsen_voted==1 & (preLetterSupport==3|preLetterSupport==4))

*change polarity of trait scores so higher numbers mean higher trait evaluation
label define trait 0 "Not well at all"  1 "Extremely well"
foreach trait in honest leader knowledge openminded hardworking {
recode firstsen_`trait' 1=1 2=.75 3=.5 4=.25 5=0
recode secondsen_`trait' 1=1 2=.75 3=.5 4=.25 5=0
label values firstsen_`trait' trait
label values secondsen_`trait' trait
}

* generate a variable indicating whether the respondent is correct about the general position of the senator
gen firstsen_position_correct = 0 if (firstsen_position == 1 & (firstletter==3|firstletter==4|firstletter==6)) 
replace firstsen_position_correct = 0 if (firstsen_position == 2 & (firstletter==1|firstletter==2|firstletter==5))
replace firstsen_position_correct = 1 if (firstsen_position == 2 & (firstletter==3|firstletter==4|firstletter==6))
replace firstsen_position_correct = 1 if (firstsen_position == 1 & (firstletter==1|firstletter==2|firstletter==5))
label variable firstsen_position_correct "Correct about Senator's General Position"
label define correct 0 "Incorrect" 1 "Correct"
label values firstsen_position_correct correct

* generate a variable indication whether the respondent is correct about the immigration reform roll call cast by the senator
gen firstsen_roll_correct = 0 if (firstsen_voted == 1 & (firstletter==3|firstletter==4|firstletter==6)) 
replace firstsen_roll_correct = 0 if (firstsen_voted == 2 & (firstletter==1|firstletter==2|firstletter==5))
replace firstsen_roll_correct = 1 if (firstsen_voted == 2 & (firstletter==3|firstletter==4|firstletter==6))
replace firstsen_roll_correct = 1 if (firstsen_voted == 1 & (firstletter==1|firstletter==2|firstletter==5))
label variable firstsen_roll_correct "Correct about Senator's Roll Call Vote"
label values firstsen_roll_correct correct

* change the polarity of the certainty variable and rescale so it spans 0 to 1 and can be in same table as correctness variables
recode firstsen_certainty 5=0 4=.25 3=.50 2=.75 1=1
label define certainty_rescale 1 "Extremely certain" 0 "Not certain at all"
label values firstsen_certainty certainty_rescale

*generate dummy variables that are interactions between letter types and respondent pre-treatment positions on immigration for use in saturated models
foreach letter in pro_pro_1 pro_anti_1 anti_pro_1 anti_anti_1 pro_all_1 anti_all_1 {
	gen `letter'ss=cond(preLetterSupport==1 & `letter'==1 ,1,0)
	gen `letter'ws=cond(preLetterSupport==2 & `letter'==1 ,1,0)
	gen `letter'wo=cond(preLetterSupport==3 & `letter'==1 ,1,0)
	gen `letter'so=cond(preLetterSupport==4 & `letter'==1 ,1,0)
	}
	

* initiate variables that will contain the results of various linear combinations of coefficients from the saturated model
gen str Tdv = ""
gen str Ttarget = ""
gen str Trespondent = ""
gen Testimate = .
gen Tse = .
gen TestLB = .
gen TestUB = .
gen Tdf = .
gen TDvND_estimate = .
gen TDvND_se = .
gen TDvND_lb = .
gen TDvND_ub = .
gen TDvNA_estimate = .
gen TDvNA_se = .
gen TDvNA_lb = .
gen TDvNA_ub = .

local row = 1 
foreach dv in /*perceive_voted_agree perceive_agree*/ agree therm votefor /*honest leader knowledge openminded hardworking */ {
display "`dv'"
regress firstsen_`dv' pro_pro_1ss pro_pro_1ws pro_pro_1wo pro_pro_1so pro_anti_1ss pro_anti_1ws pro_anti_1wo pro_anti_1so anti_pro_1ss anti_pro_1ws anti_pro_1wo anti_pro_1so anti_anti_1ss anti_anti_1ws anti_anti_1wo anti_anti_1so pro_all_1ss pro_all_1ws pro_all_1wo pro_all_1so anti_all_1ss anti_all_1ws anti_all_1wo anti_all_1so /*if senparty==1| if senparty==2*/, nocons
	foreach target in agree_target agree_notarget agree_mistarget disagree_target disagree_notarget disagree_mistarget{
		foreach respondent in  s o /*a m e */{ /* this selects which respondents to include and how to divide them. s=supproters of reform, o=opponents, a= all respondents, m=respondents with moderate immigration positiions, e=respondents with extreme immigration positions*/
			* weights for estimates only including immigration reform supporters
			if "`respondent'" == "s"{
				local w1=.31 /* weight for strong supporters of immigration reform, .22 in sample, .31 among strong and weak supporters */
				local w2=.69 /* weight for weak supporters of immigration reform, .5 in sample, .69 among strong and weak supporters */
				local w3= 0 /* weight for strong opponents of immigration reform, .09 in sample, .32 among strong and weak opponents*/
				local w4= 0 /* weight for weak opponents of immigration reform, .19 in sample, .68 among strong and weak opponents */
				}
			* weights for estimates only including immigration reform opponents
			if "`respondent'" == "o"{
				local w1=0 /* weight for strong supporters of immigration reform, .22 in sample, .31 among strong and weak supporters */
				local w2=0 /* weight for weak supporters of immigration reform, .5 in sample, .69 among strong and weak supporters */
				local w3=.68 /* weight for weak opponents of immigration reform, .19 in sample, .68 among strong and weak opponents */
				local w4=.32 /* weight for strong opponents of immigration reform, .09 in sample, .32 among strong and weak opponents*/
				}
			* weights for estimates only including all respondents who took positions on immmigrating reform
			* these are the weights that we use in Table 4
			if "`respondent'" == "a"{
			    local w1=.22 /* weight for strong supporters of immigration reform, .22 in sample */
				local w2=.5 /* weight for weak supporters of immigration reform, .5 in sample */
				local w3=.19 /* weight for weak opponents of immigration reform, .19 in sample */
				local w4=.09 /* weight for strong opponents of immigration reform, .09 in sample */
				}
			* weights for estimates only including only respondents who took weak positions on either side of the issue
			if "`respondent'" == "m"{
			    local w1= 0 /* weight for strong supporters of immigration reform, .71 among strong suppoters and opponents */
				local w2=.72 /* weight for weak supporters of immigration reform, .72 among weak supporters and opponents */
				local w3=.28 /* weight for weak opponents of immigration reform, .28 among weak supporters and opponents */
				local w4= 0 /* weight for strong opponents of immigration reform, .29 among strong suppoters and opponents */
				}
			* weights for estimates only including only respondents who took strong positions on either side of the issue
			if "`respondent'" == "e"{
			    local w1= .71 /* weight for strong supporters of immigration reform, .71 among strong suppoters and opponents */
				local w2= 0/* weight for weak supporters of immigration reform, .72 among weak supporters and opponents */
				local w3= 0 /* weight for weak opponents of immigration reform, .28 among weak supporters and opponents */
				local w4= .29 /* weight for strong opponents of immigration reform, .29 among strong suppoters and opponents */
				}
				if "`target'" == "agree_target" {
					local letter1 = "pro_pro"
					local letter2 = "anti_anti"
					}
				if "`target'" == "agree_notarget" {
					local letter1 = "pro_all"
					local letter2 = "anti_all"
					}
				if "`target'" == "agree_mistarget" {
					local letter1 = "pro_anti"
					local letter2 = "anti_pro"
					}
				if "`target'" == "disagree_target" {
					local letter1 = "anti_pro"
					local letter2 = "pro_anti"
					}
				if "`target'" == "disagree_notarget" {
					local letter1 = "anti_all"
					local letter2 = "pro_all"
					}
				if "`target'" == "disagree_mistarget" {
					local letter1 = "anti_anti"
					local letter2 = "pro_pro"
					}
				lincom `w1'*`letter1'_1ss+`w2'*`letter1'_1ws + `w3'*`letter2'_1wo+`w4'*`letter2'_1so
				replace Tdv = "`dv'" in `row'
				replace Ttarget = "`target'" in `row'
				replace Trespondent = "`respondent'" in `row'
				replace Testimate = r(estimate) in `row'
				replace Tse = r(se) in `row'
				replace Tdf = r(df) in `row' 
				
				display "tests hypothesis that compensating letter to opposing constituents is different that constitent letter to opposing constituents."
				lincom (`w1'*anti_pro_1ss+`w2'*anti_pro_1ws +`w3'*pro_anti_1wo+`w4'*pro_anti_1so) - (`w1'*anti_all_1ss+`w2'*anti_all_1ws +`w3'*pro_all_1wo+`w4'*pro_all_1so)
				replace TDvND_estimate = r(estimate) in `row'
				replace TDvND_se = r(se) in `row'
				dis "tests hypothesis that compensating letter to opposing constituents is different from constitent letter to agreeable constituents."
				lincom (`w1'*anti_pro_1ss+`w2'*anti_pro_1ws + `w3'*pro_anti_1wo+`w4'*pro_anti_1so) - (`w1'*pro_all_1ss+`w2'*pro_all_1ws +`w3'*anti_all_1wo+`w4'*anti_all_1so)
				replace TDvNA_estimate = r(estimate) in `row'
				replace TDvNA_se = r(se) in `row'
				local row = `row' + 1
				}
			}
		}
		replace TestLB = Testimate - 1.96*(Tse)
		replace TestUB = Testimate + 1.96*(Tse)
		replace TDvND_lb = TDvND_estimate - 1.96*(TDvND_se)
		replace TDvND_ub = TDvND_estimate + 1.96*(TDvND_se)
		replace TDvNA_lb = TDvNA_estimate - 1.96*(TDvNA_se)
		replace TDvNA_ub = TDvNA_estimate + 1.96*(TDvNA_se)
		
keep Tdv Trespondent Ttarget Testimate TestLB TestUB TDvND_estimate TDvND_lb TDvND_ub TDvNA_estimate TDvNA_lb TDvNA_ub
keep in 1/36
ren Tdv DV
ren Ttarget Treatment
ren Testimate Mean
ren TestLB LowerBound
ren TestUB UpperBound
replace Treatment="Agree - Targeted Toward" if Treatment=="agree_target"
replace Treatment="Agree - Not Targeted" if Treatment=="agree_notarget"
replace Treatment="Agree - Targeted Away" if Treatment=="agree_mistarget"
replace Treatment="Disagree - Targeted Toward" if Treatment=="disagree_target"
replace Treatment="Disagree - Not Targeted" if Treatment=="disagree_notarget"
replace Treatment="Disagree - Targeted Away" if Treatment=="disagree_mistarget"
ren TDvND_estimate TDvND_mean
ren TDvNA_estimate TDvNA_mean
export delimited tableA11output.txt, delim(tab) replace
}

************************** Appendix 12 *********************************
* Appendix 12 presents the results for additional dependent variables
* These variables include the senator traits and two agreement measures. It 
* produces a table and saves it to a tab-delimited text file called  
* "tableA12output.txt".  Appendix 12 contains two tables in order to display
* all 6 additional variables. To create replicas first import  
* "tableA12output.txt" into Excel, copy the entire contents of the imported 
* table, and then paste them into the "Table A12 Output" tab of the Excel file 
* titled "Tables for Experiment 2."  Place the top left cell at row A, column 1. 
* This will update the linked tables in tabs "Table A12.1" and "Table A12.2." 
quietly{

clear all
do "study2replication_makedata.do"

clear all
set more off
use "study2replication.dta"

* rpvh 6/4/2014

********************* DATA PREP AND RECODES ******************************


* replace letter labels with desciptive labels, first element contains senators position second element contains respondents
label define letter 1 "Pro to Pro" 2 "Pro to Anti" 3 "Anti to Pro" 4 "Anti to Anti" 5 "Pro to All" 6 "Anti to All"
label values firstletter letter
label values secondletter letter

* generate dummies for each type of letter
tab firstletter, gen(firstletter_dum)
ren firstletter_dum1 pro_pro_1
ren firstletter_dum2 pro_anti_1
ren firstletter_dum3 anti_pro_1
ren firstletter_dum4 anti_anti_1
ren firstletter_dum5 pro_all_1
ren firstletter_dum6 anti_all_1

*change and scaling of polarity of agreement so higher numbers mean more agreement
recode firstsen_agree 1=4 2=3 3=2 4=1
recode secondsen_agree 1=4 2=3 3=2 4=1
label define agree_withsen 1 "Strongly disagree"  4 "Strongly agree"
label values firstsen_agree agree_withsen
label values secondsen_agree agree_withsen

*change polarity of vote likelihood so higher numbers mean higher vote likelihood
recode firstsen_votefor 1=5 2=4 3=3 4=2 5=1
recode secondsen_votefor 1=5 2=4 3=3 4=2 5=1
label define votefor 1 "Not likely at all" 2 "Not too likely" 3 "Somewhat likely" 4 "Very likely" 5 "Extremely likely", replace
label values firstsen_votefor votefor
label values secondsen_votefor votefor

*generate a variable for perceived agreement based on whether the respondents own position matches their assessment of
*the senator's general position and their perception of how the senator voted.
gen firstsen_perceive_agree = 1 if (firstsen_position==1 & (preLetterSupport==1|preLetterSupport==2))|(firstsen_position==2 & (preLetterSupport==3|preLetterSupport==4))
replace firstsen_perceive_agree = 0 if (firstsen_position==2 & (preLetterSupport==1|preLetterSupport==2))|(firstsen_position==1 & (preLetterSupport==3|preLetterSupport==4))
gen firstsen_perceive_voted_agree = 1 if (firstsen_voted==1 & (preLetterSupport==1|preLetterSupport==2))|(firstsen_voted==2 & (preLetterSupport==3|preLetterSupport==4))
replace firstsen_perceive_voted_agree = 0 if (firstsen_voted==2 & (preLetterSupport==1|preLetterSupport==2))|(firstsen_voted==1 & (preLetterSupport==3|preLetterSupport==4))

*change polarity of trait scores so higher numbers mean higher trait evaluation
foreach trait in honest leader knowledge openminded hardworking {
recode firstsen_`trait' 1=5 2=4 4=2 5=1
recode secondsen_`trait' 1=5 2=4 4=2 5=1
}

* generate a variable indicating whether the respondent is correct about the general position of the senator
gen firstsen_position_correct = 0 if (firstsen_position == 1 & (firstletter==3|firstletter==4|firstletter==6)) 
replace firstsen_position_correct = 0 if (firstsen_position == 2 & (firstletter==1|firstletter==2|firstletter==5))
replace firstsen_position_correct = 1 if (firstsen_position == 2 & (firstletter==3|firstletter==4|firstletter==6))
replace firstsen_position_correct = 1 if (firstsen_position == 1 & (firstletter==1|firstletter==2|firstletter==5))
label variable firstsen_position_correct "Correct about Senator's General Position"
label define correct 0 "Incorrect" 1 "Correct"
label values firstsen_position_correct correct

* generate a variable indication whether the respondent is correct about the immigration reform roll call cast by the senator
gen firstsen_roll_correct = 0 if (firstsen_voted == 1 & (firstletter==3|firstletter==4|firstletter==6)) 
replace firstsen_roll_correct = 0 if (firstsen_voted == 2 & (firstletter==1|firstletter==2|firstletter==5))
replace firstsen_roll_correct = 1 if (firstsen_voted == 2 & (firstletter==3|firstletter==4|firstletter==6))
replace firstsen_roll_correct = 1 if (firstsen_voted == 1 & (firstletter==1|firstletter==2|firstletter==5))
label variable firstsen_roll_correct "Correct about Senator's Roll Call Vote"
label values firstsen_roll_correct correct

* change the polarity of the certainty variable and rescale so it spans 0 to 1 and can be in same table as correctness variables
recode firstsen_certainty 5=0 4=.25 3=.50 2=.75 1=1
label define certainty_rescale 1 "Extremely certain" 0 "Not certain at all"
label values firstsen_certainty certainty_rescale

*generate dummy variables that are interactions between letter types and respondent pre-treatment positions on immigration for use in saturated models
foreach letter in pro_pro_1 pro_anti_1 anti_pro_1 anti_anti_1 pro_all_1 anti_all_1 {
	gen `letter'ss=cond(preLetterSupport==1 & `letter'==1 ,1,0)
	gen `letter'ws=cond(preLetterSupport==2 & `letter'==1 ,1,0)
	gen `letter'wo=cond(preLetterSupport==3 & `letter'==1 ,1,0)
	gen `letter'so=cond(preLetterSupport==4 & `letter'==1 ,1,0)
	}
	

* initiate variables that will contain the results of various linear combinations of coefficients from the saturated model
gen str Tdv = ""
gen str Ttarget = ""
gen str Trespondent = ""
gen Testimate = .
gen Tse = .
gen TestLB = .
gen TestUB = .
gen Tdf = .

local row = 1 
foreach dv in knowledge openminded leader honest perceive_voted_agree perceive_agree {
display "`dv'"
regress firstsen_`dv' pro_pro_1ss pro_pro_1ws pro_pro_1wo pro_pro_1so pro_anti_1ss pro_anti_1ws pro_anti_1wo pro_anti_1so anti_pro_1ss anti_pro_1ws anti_pro_1wo anti_pro_1so anti_anti_1ss anti_anti_1ws anti_anti_1wo anti_anti_1so pro_all_1ss pro_all_1ws pro_all_1wo pro_all_1so anti_all_1ss anti_all_1ws anti_all_1wo anti_all_1so /*if senparty==1| if senparty==2*/, nocons
	foreach target in agree_target agree_notarget agree_mistarget disagree_target disagree_notarget disagree_mistarget{
		foreach respondent in  /*s o*/ a /*m e*/{ /* this selects which respondents to include and how to divide them. s=supproters of reform, o=opponents, a= all respondents, m=respondents with moderate immigration positiions, e=respondents with extreme immigration positions*/
			* weights for estimates only including immigration reform supporters
			if "`respondent'" == "s"{
				local w1=.31 /* weight for strong supporters of immigration reform, .22 in sample, .31 among strong and weak supporters */
				local w2=.69 /* weight for weak supporters of immigration reform, .5 in sample, .69 among strong and weak supporters */
				local w3= 0 /* weight for strong opponents of immigration reform, .09 in sample, .32 among strong and weak opponents*/
				local w4= 0 /* weight for weak opponents of immigration reform, .19 in sample, .68 among strong and weak opponents */
				}
			* weights for estimates only including immigration reform opponents
			if "`respondent'" == "o"{
				local w1=0 /* weight for strong supporters of immigration reform, .22 in sample, .31 among strong and weak supporters */
				local w2=0 /* weight for weak supporters of immigration reform, .5 in sample, .69 among strong and weak supporters */
				local w3=.68 /* weight for weak opponents of immigration reform, .19 in sample, .68 among strong and weak opponents */
				local w4=.32 /* weight for strong opponents of immigration reform, .09 in sample, .32 among strong and weak opponents*/
				}
			* weights for estimates only including all respondents who took positions on immmigrating reform
			* these are the weights that we use in Table 4
			if "`respondent'" == "a"{
			    local w1=.22 /* weight for strong supporters of immigration reform, .22 in sample */
				local w2=.5 /* weight for weak supporters of immigration reform, .5 in sample */
				local w3=.19 /* weight for weak opponents of immigration reform, .19 in sample */
				local w4=.09 /* weight for strong opponents of immigration reform, .09 in sample */
				}
			* weights for estimates only including only respondents who took weak positions on either side of the issue
			if "`respondent'" == "m"{
			    local w1= 0 /* weight for strong supporters of immigration reform, .71 among strong suppoters and opponents */
				local w2=.72 /* weight for weak supporters of immigration reform, .72 among weak supporters and opponents */
				local w3=.28 /* weight for weak opponents of immigration reform, .28 among weak supporters and opponents */
				local w4= 0 /* weight for strong opponents of immigration reform, .29 among strong suppoters and opponents */
				}
			* weights for estimates only including only respondents who took strong positions on either side of the issue
			if "`respondent'" == "e"{
			    local w1= .71 /* weight for strong supporters of immigration reform, .71 among strong suppoters and opponents */
				local w2= 0/* weight for weak supporters of immigration reform, .72 among weak supporters and opponents */
				local w3= 0 /* weight for weak opponents of immigration reform, .28 among weak supporters and opponents */
				local w4= .29 /* weight for strong opponents of immigration reform, .29 among strong suppoters and opponents */
				}
				if "`target'" == "agree_target" {
					local letter1 = "pro_pro"
					local letter2 = "anti_anti"
					}
				if "`target'" == "agree_notarget" {
					local letter1 = "pro_all"
					local letter2 = "anti_all"
					}
				if "`target'" == "agree_mistarget" {
					local letter1 = "pro_anti"
					local letter2 = "anti_pro"
					}
				if "`target'" == "disagree_target" {
					local letter1 = "anti_pro"
					local letter2 = "pro_anti"
					}
				if "`target'" == "disagree_notarget" {
					local letter1 = "anti_all"
					local letter2 = "pro_all"
					}
				if "`target'" == "disagree_mistarget" {
					local letter1 = "anti_anti"
					local letter2 = "pro_pro"
					}
				lincom `w1'*`letter1'_1ss+`w2'*`letter1'_1ws + `w3'*`letter2'_1wo+`w4'*`letter2'_1so
				replace Tdv = "`dv'" in `row'
				replace Ttarget = "`target'" in `row'
				replace Trespondent = "`respondent'" in `row'
				replace Testimate = r(estimate) in `row'
				replace Tse = r(se) in `row'
				replace Tdf = r(df) in `row' 
				local row = `row' + 1
				}
			}
		}
		replace TestLB = Testimate - 1.96*(Tse)
		replace TestUB = Testimate + 1.96*(Tse)

		keep Tdv Ttarget Testimate TestLB TestUB 
keep in 1/36
ren Tdv DV
ren Ttarget Treatment
ren Testimate Mean
ren TestLB LowerBound
ren TestUB UpperBound
export delimited tableA12output.txt, delim(tab) replace
}

************************** Appendix 14 *********************************
* Appendix 14 presents the weighted estimates from the Table 4 in the main
* body of the paper along with unweighted estimates for all three
* dependent variables in Table 4 (Agreement, Thermometer, Vote Likeliehood)
* The appendix also presents ordered probit models for the two variables in 
* Table 4 (Agreement, Vote Likeliehood) that are ordinal scales.  The code
* starts with a couple of programs that we use to interpret the ordered probit 
* and calculate confidence intervals for them. It produces a table and saves it 
* to a tab-delimited text file called "tableA14output.txt".  Appendix 14 
* contains three tables (one for each dependent variable). To create replicas 
* first import "tableA14output.txt" into Excel, copy the entire contents of the 
* imported table, and then paste them into the "Table A14 Output" tab of the 
* Excel file titled "Tables for Experiment 2."  Place the top left cell at 
* row A, column 1.  This will update the last two columns in the linked tables 
* in tabs "Table A14.1" and "Table A14.2."  It will update only the last column
* in Table A14.3, because we do not estimate an ordered probit model for that 
* table.   The first column in all three tables is identical to the results 
* presented in Table 4 and we present it again here for convenience.   It is
* updated by pasting the file "table4output.txt" that was created earlier by 
* this .do file into the "Table A4 Output" tab.  Note the ordered probit results
* in the paper are based on 500 reps.   Currently this code is only set to do 5
* reps so it will run more quickly.   To replicate the table chance the option 
* reps(5) in the bootstrap commands below to reps(500)
quietly{

clear all
do "study2replication_makedata.do"

clear all
set more off
use "study2replication.dta"

* rpvh 6/4/2014

*this code defines a program estimating the effect of the treatments on the level of agreement on immigration between the respondent and the senator
*that the respondent self-reports.   It takes the estimated probabilities that respondents will express each level of the dependent variable and collapses
*them into an estimated average response.   We use this program later to generate bootstrap confidence intervals for this average response.  The code
*was created to respond to a referee request that we demonstrate that our OLS based results are robust when we estimate models with ordered probits.
program oprob_agree, rclass
	version 13
	oprobit firstsen_agree agree_target_toward agree_no_target agree_target_away disagree_target_toward disagree_no_target  
	margins, at(agree_target_toward==1 agree_no_target==0 agree_target_away=0 disagree_target_toward=0 disagree_no_target=0) predict(outcome (1))
	matrix b = r(b)
	local one = b[1,1] 
	margins, at(agree_target_toward==1 agree_no_target==0 agree_target_away=0 disagree_target_toward=0 disagree_no_target=0) predict(outcome (2))
	matrix b = r(b)
	local two = b[1,1]
	margins, at(agree_target_toward==1 agree_no_target==0 agree_target_away=0 disagree_target_toward=0 disagree_no_target=0) predict(outcome (3))
	matrix b = r(b)
	local three = b[1,1]
	margins, at(agree_target_toward==1 agree_no_target==0 agree_target_away=0 disagree_target_toward=0 disagree_no_target=0) predict(outcome (4))
	matrix b = r(b)
	local four = b[1,1] 
	return scalar agree_target_toward = `one' + `two'*2 + `three'*3 + `four'*4
	
	margins, at(agree_target_toward==0 agree_no_target==1 agree_target_away=0 disagree_target_toward=0 disagree_no_target=0) predict(outcome (1))
	matrix b = r(b)
	local one = b[1,1] 
	margins, at(agree_target_toward==0 agree_no_target==1 agree_target_away=0 disagree_target_toward=0 disagree_no_target=0) predict(outcome (2))
	matrix b = r(b)
	local two = b[1,1]
	margins, at(agree_target_toward==0 agree_no_target==1 agree_target_away=0 disagree_target_toward=0 disagree_no_target=0) predict(outcome (3))
	matrix b = r(b)
	local three = b[1,1]
	margins, at(agree_target_toward==0 agree_no_target==1 agree_target_away=0 disagree_target_toward=0 disagree_no_target=0) predict(outcome (4))
	matrix b = r(b)
	local four = b[1,1] 
	return scalar agree_no_target = `one' + `two'*2 + `three'*3 + `four'*4
	
	margins, at(agree_target_toward==0 agree_no_target==0 agree_target_away=1 disagree_target_toward=0 disagree_no_target=0) predict(outcome (1))
	matrix b = r(b)
	local one = b[1,1] 
	margins, at(agree_target_toward==0 agree_no_target==0 agree_target_away=1 disagree_target_toward=0 disagree_no_target=0) predict(outcome (2))
	matrix b = r(b)
	local two = b[1,1]
	margins, at(agree_target_toward==0 agree_no_target==0 agree_target_away=1 disagree_target_toward=0 disagree_no_target=0) predict(outcome (3))
	matrix b = r(b)
	local three = b[1,1]
	margins, at(agree_target_toward==0 agree_no_target==0 agree_target_away=1 disagree_target_toward=0 disagree_no_target=0) predict(outcome (4))
	matrix b = r(b)
	local four = b[1,1] 
	return scalar agree_target_away = `one' + `two'*2 + `three'*3 + `four'*4
	
	margins, at(agree_target_toward==0 agree_no_target==0 agree_target_away=0 disagree_target_toward=1 disagree_no_target=0) predict(outcome (1))
	matrix b = r(b)
	local one = b[1,1] 
	margins, at(agree_target_toward==0 agree_no_target==0 agree_target_away=0 disagree_target_toward=1 disagree_no_target=0) predict(outcome (2))
	matrix b = r(b)
	local two = b[1,1]
	margins, at(agree_target_toward==0 agree_no_target==0 agree_target_away=0 disagree_target_toward=1 disagree_no_target=0) predict(outcome (3))
	matrix b = r(b)
	local three = b[1,1]
	margins, at(agree_target_toward==0 agree_no_target==0 agree_target_away=0 disagree_target_toward=1 disagree_no_target=0) predict(outcome (4))
	matrix b = r(b)
	local four = b[1,1] 
	return scalar disagree_target_toward = `one' + `two'*2 + `three'*3 + `four'*4
	
	margins, at(agree_target_toward==0 agree_no_target==0 agree_target_away=0 disagree_target_toward=0 disagree_no_target=1) predict(outcome (1))
	matrix b = r(b)
	local one = b[1,1] 
	margins, at(agree_target_toward==0 agree_no_target==0 agree_target_away=0 disagree_target_toward=0 disagree_no_target=1) predict(outcome (2))
	matrix b = r(b)
	local two = b[1,1]
	margins, at(agree_target_toward==0 agree_no_target==0 agree_target_away=0 disagree_target_toward=0 disagree_no_target=1) predict(outcome (3))
	matrix b = r(b)
	local three = b[1,1]
	margins, at(agree_target_toward==0 agree_no_target==0 agree_target_away=0 disagree_target_toward=0 disagree_no_target=1) predict(outcome (4))
	matrix b = r(b)
	local four = b[1,1] 
	return scalar disagree_no_target= `one' + `two'*2 + `three'*3 + `four'*4
	
	margins, at(agree_target_toward==0 agree_no_target==0 agree_target_away=0 disagree_target_toward=0 disagree_no_target=0) predict(outcome (1))
	matrix b = r(b)
	local one = b[1,1] 
	margins, at(agree_target_toward==0 agree_no_target==0 agree_target_away=0 disagree_target_toward=0 disagree_no_target=0) predict(outcome (2))
	matrix b = r(b)
	local two = b[1,1]
	margins, at(agree_target_toward==0 agree_no_target==0 agree_target_away=0 disagree_target_toward=0 disagree_no_target=0) predict(outcome (3))
	matrix b = r(b)
	local three = b[1,1]
	margins, at(agree_target_toward==0 agree_no_target==0 agree_target_away=0 disagree_target_toward=0 disagree_no_target=0) predict(outcome (4))
	matrix b = r(b)
	local four = b[1,1] 
	return scalar disagree_target_away= `one' + `two'*2 + `three'*3 + `four'*4
	
end

*this code defines a program estimating the effect of the treatments on the probability he respondent will vote for the senator
*that the respondent self-reports.   It takes the estimated probabilities that respondents will express each level of the dependent variable and collapses
*them into an estimated average response.   We use this program later to generate bootstrap confidence intervals for this average response.  The code
*was created to respond to a referee request that we demonstrate that our OLS based results are robust when we estimate models with ordered probits.
	
program oprob_votefor, rclass
	version 13
	oprobit firstsen_votefor agree_target_toward agree_no_target agree_target_away disagree_target_toward disagree_no_target  
	margins, at(agree_target_toward==1 agree_no_target==0 agree_target_away=0 disagree_target_toward=0 disagree_no_target=0) predict(outcome (1))
	matrix b = r(b)
	local one = b[1,1] 
	margins, at(agree_target_toward==1 agree_no_target==0 agree_target_away=0 disagree_target_toward=0 disagree_no_target=0) predict(outcome (2))
	matrix b = r(b)
	local two = b[1,1]
	margins, at(agree_target_toward==1 agree_no_target==0 agree_target_away=0 disagree_target_toward=0 disagree_no_target=0) predict(outcome (3))
	matrix b = r(b)
	local three = b[1,1]
	margins, at(agree_target_toward==1 agree_no_target==0 agree_target_away=0 disagree_target_toward=0 disagree_no_target=0) predict(outcome (4))
	matrix b = r(b)
	local four = b[1,1] 
	margins, at(agree_target_toward==1 agree_no_target==0 agree_target_away=0 disagree_target_toward=0 disagree_no_target=0) predict(outcome (5))
	matrix b = r(b)
	local five = b[1,1] 
	return scalar agree_target_toward = `one' + `two'*2 + `three'*3 + `four'*4 + `five'*5
	
	margins, at(agree_target_toward==0 agree_no_target==1 agree_target_away=0 disagree_target_toward=0 disagree_no_target=0) predict(outcome (1))
	matrix b = r(b)
	local one = b[1,1] 
	margins, at(agree_target_toward==0 agree_no_target==1 agree_target_away=0 disagree_target_toward=0 disagree_no_target=0) predict(outcome (2))
	matrix b = r(b)
	local two = b[1,1]
	margins, at(agree_target_toward==0 agree_no_target==1 agree_target_away=0 disagree_target_toward=0 disagree_no_target=0) predict(outcome (3))
	matrix b = r(b)
	local three = b[1,1]
	margins, at(agree_target_toward==0 agree_no_target==1 agree_target_away=0 disagree_target_toward=0 disagree_no_target=0) predict(outcome (4))
	matrix b = r(b)
	local four = b[1,1] 
	margins, at(agree_target_toward==0 agree_no_target==1 agree_target_away=0 disagree_target_toward=0 disagree_no_target=0) predict(outcome (5))
	matrix b = r(b)
	local five = b[1,1] 
	return scalar agree_no_target = `one' + `two'*2 + `three'*3 + `four'*4 + `five'*5
	
	margins, at(agree_target_toward==0 agree_no_target==0 agree_target_away=1 disagree_target_toward=0 disagree_no_target=0) predict(outcome (1))
	matrix b = r(b)
	local one = b[1,1] 
	margins, at(agree_target_toward==0 agree_no_target==0 agree_target_away=1 disagree_target_toward=0 disagree_no_target=0) predict(outcome (2))
	matrix b = r(b)
	local two = b[1,1]
	margins, at(agree_target_toward==0 agree_no_target==0 agree_target_away=1 disagree_target_toward=0 disagree_no_target=0) predict(outcome (3))
	matrix b = r(b)
	local three = b[1,1]
	margins, at(agree_target_toward==0 agree_no_target==0 agree_target_away=1 disagree_target_toward=0 disagree_no_target=0) predict(outcome (4))
	matrix b = r(b)
	local four = b[1,1] 
	margins, at(agree_target_toward==0 agree_no_target==0 agree_target_away=1 disagree_target_toward=0 disagree_no_target=0) predict(outcome (5))
	matrix b = r(b)
	local five = b[1,1] 
	return scalar agree_target_away = `one' + `two'*2 + `three'*3 + `four'*4 + `five'*5
	
	margins, at(agree_target_toward==0 agree_no_target==0 agree_target_away=0 disagree_target_toward=1 disagree_no_target=0) predict(outcome (1))
	matrix b = r(b)
	local one = b[1,1] 
	margins, at(agree_target_toward==0 agree_no_target==0 agree_target_away=0 disagree_target_toward=1 disagree_no_target=0) predict(outcome (2))
	matrix b = r(b)
	local two = b[1,1]
	margins, at(agree_target_toward==0 agree_no_target==0 agree_target_away=0 disagree_target_toward=1 disagree_no_target=0) predict(outcome (3))
	matrix b = r(b)
	local three = b[1,1]
	margins, at(agree_target_toward==0 agree_no_target==0 agree_target_away=0 disagree_target_toward=1 disagree_no_target=0) predict(outcome (4))
	matrix b = r(b)
	local four = b[1,1] 
	margins, at(agree_target_toward==0 agree_no_target==0 agree_target_away=0 disagree_target_toward= 1 disagree_no_target=0) predict(outcome (5))
	matrix b = r(b)
	local five = b[1,1] 
	return scalar disagree_target_toward = `one' + `two'*2 + `three'*3 + `four'*4 + `five'*5

	
	margins, at(agree_target_toward==0 agree_no_target==0 agree_target_away=0 disagree_target_toward=0 disagree_no_target=1) predict(outcome (1))
	matrix b = r(b)
	local one = b[1,1] 
	margins, at(agree_target_toward==0 agree_no_target==0 agree_target_away=0 disagree_target_toward=0 disagree_no_target=1) predict(outcome (2))
	matrix b = r(b)
	local two = b[1,1]
	margins, at(agree_target_toward==0 agree_no_target==0 agree_target_away=0 disagree_target_toward=0 disagree_no_target=1) predict(outcome (3))
	matrix b = r(b)
	local three = b[1,1]
	margins, at(agree_target_toward==0 agree_no_target==0 agree_target_away=0 disagree_target_toward=0 disagree_no_target=1) predict(outcome (4))
	matrix b = r(b)
	local four = b[1,1] 
	margins, at(agree_target_toward==0 agree_no_target==0 agree_target_away=0 disagree_target_toward=0 disagree_no_target=1) predict(outcome (5))
	matrix b = r(b)
	local five = b[1,1] 
	return scalar disagree_no_target = `one' + `two'*2 + `three'*3 + `four'*4 + `five'*5
	
	margins, at(agree_target_toward==0 agree_no_target==0 agree_target_away=0 disagree_target_toward=0 disagree_no_target=0) predict(outcome (1))
	matrix b = r(b)
	local one = b[1,1] 
	margins, at(agree_target_toward==0 agree_no_target==0 agree_target_away=0 disagree_target_toward=0 disagree_no_target=0) predict(outcome (2))
	matrix b = r(b)
	local two = b[1,1]
	margins, at(agree_target_toward==0 agree_no_target==0 agree_target_away=0 disagree_target_toward=0 disagree_no_target=0) predict(outcome (3))
	matrix b = r(b)
	local three = b[1,1]
	margins, at(agree_target_toward==0 agree_no_target==0 agree_target_away=0 disagree_target_toward=0 disagree_no_target=0) predict(outcome (4))
	matrix b = r(b)
	local four = b[1,1] 
	margins, at(agree_target_toward==0 agree_no_target==0 agree_target_away=0 disagree_target_toward=0 disagree_no_target=0) predict(outcome (5))
	matrix b = r(b)
	local five = b[1,1] 
	return scalar disagree_target_away = `one' + `two'*2 + `three'*3 + `four'*4 + `five'*5
	
end

********************* DATA PREP AND RECODES ******************************


* replace letter labels with desciptive labels, first element contains senators position second element contains respondents
label define letter 1 "Pro to Pro" 2 "Pro to Anti" 3 "Anti to Pro" 4 "Anti to Anti" 5 "Pro to All" 6 "Anti to All"
label values firstletter letter
label values secondletter letter

* generate dummies for each type of letter
tab firstletter, gen(firstletter_dum)
ren firstletter_dum1 pro_pro_1
ren firstletter_dum2 pro_anti_1
ren firstletter_dum3 anti_pro_1
ren firstletter_dum4 anti_anti_1
ren firstletter_dum5 pro_all_1
ren firstletter_dum6 anti_all_1

*change and scaling of polarity of agreement so higher numbers mean more agreement
recode firstsen_agree 1=4 2=3 3=2 4=1
recode secondsen_agree 1=4 2=3 3=2 4=1
label define agree_withsen 1 "Strongly disagree"  4 "Strongly agree"
label values firstsen_agree agree_withsen
label values secondsen_agree agree_withsen

*change polarity of vote likelihood so higher numbers mean higher vote likelihood
recode firstsen_votefor 1=5 2=4 3=3 4=2 5=1
recode secondsen_votefor 1=5 2=4 3=3 4=2 5=1
label define votefor 1 "Not likely at all" 2 "Not too likely" 3 "Somewhat likely" 4 "Very likely" 5 "Extremely likely", replace
label values firstsen_votefor votefor
label values secondsen_votefor votefor

*generate a variable for perceived agreement based on whether the respondents own position matches their assessment of
*the senator's general position and their perception of how the senator voted.
gen firstsen_perceive_agree = 1 if (firstsen_position==1 & (preLetterSupport==1|preLetterSupport==2))|(firstsen_position==2 & (preLetterSupport==3|preLetterSupport==4))
replace firstsen_perceive_agree = 0 if (firstsen_position==2 & (preLetterSupport==1|preLetterSupport==2))|(firstsen_position==1 & (preLetterSupport==3|preLetterSupport==4))
gen firstsen_perceive_voted_agree = 1 if (firstsen_voted==1 & (preLetterSupport==1|preLetterSupport==2))|(firstsen_voted==2 & (preLetterSupport==3|preLetterSupport==4))
replace firstsen_perceive_voted_agree = 0 if (firstsen_voted==2 & (preLetterSupport==1|preLetterSupport==2))|(firstsen_voted==1 & (preLetterSupport==3|preLetterSupport==4))

*change polarity of trait scores so higher numbers mean higher trait evaluation
foreach trait in honest leader knowledge openminded hardworking {
recode firstsen_`trait' 1=5 2=4 4=2 5=1
recode secondsen_`trait' 1=5 2=4 4=2 5=1
}

* generate a variable indicating whether the respondent is correct about the general position of the senator
gen firstsen_position_correct = 0 if (firstsen_position == 1 & (firstletter==3|firstletter==4|firstletter==6)) 
replace firstsen_position_correct = 0 if (firstsen_position == 2 & (firstletter==1|firstletter==2|firstletter==5))
replace firstsen_position_correct = 1 if (firstsen_position == 2 & (firstletter==3|firstletter==4|firstletter==6))
replace firstsen_position_correct = 1 if (firstsen_position == 1 & (firstletter==1|firstletter==2|firstletter==5))
label variable firstsen_position_correct "Correct about Senator's General Position"
label define correct 0 "Incorrect" 1 "Correct"
label values firstsen_position_correct correct

* generate a variable indication whether the respondent is correct about the immigration reform roll call cast by the senator
gen firstsen_roll_correct = 0 if (firstsen_voted == 1 & (firstletter==3|firstletter==4|firstletter==6)) 
replace firstsen_roll_correct = 0 if (firstsen_voted == 2 & (firstletter==1|firstletter==2|firstletter==5))
replace firstsen_roll_correct = 1 if (firstsen_voted == 2 & (firstletter==3|firstletter==4|firstletter==6))
replace firstsen_roll_correct = 1 if (firstsen_voted == 1 & (firstletter==1|firstletter==2|firstletter==5))
label variable firstsen_roll_correct "Correct about Senator's Roll Call Vote"
label values firstsen_roll_correct correct

* change the polarity of the certainty variable and rescale so it spans 0 to 1 and can be in same table as correctness variables
recode firstsen_certainty 5=0 4=.25 3=.50 2=.75 1=1
label define certainty_rescale 1 "Extremely certain" 0 "Not certain at all"
label values firstsen_certainty certainty_rescale

*generate dummy variables that are interactions between letter types and respondent pre-treatment positions on immigration for use in saturated models
foreach letter in pro_pro_1 pro_anti_1 anti_pro_1 anti_anti_1 pro_all_1 anti_all_1 {
	gen `letter'ss=cond(preLetterSupport==1 & `letter'==1 ,1,0)
	gen `letter'ws=cond(preLetterSupport==2 & `letter'==1 ,1,0)
	gen `letter'wo=cond(preLetterSupport==3 & `letter'==1 ,1,0)
	gen `letter'so=cond(preLetterSupport==4 & `letter'==1 ,1,0)
	}

* generate dummy variables for each treatment conditions for the tables that appear in the paper for use in generating
* unweighted estimates
* agree_target_toward
gen agree_target_toward = cond(pro_pro_1ss==1|pro_pro_1ws==1|anti_anti_1wo==1|anti_anti_1so==1, 1,0)
* agree_no_target
gen agree_no_target = cond(pro_all_1ss==1|pro_all_1ws==1|anti_all_1wo==1|anti_all_1so==1, 1,0)
* agree_target_away
gen agree_target_away = cond(pro_anti_1ss==1|pro_anti_1ws==1|anti_pro_1wo==1|anti_pro_1so==1, 1,0)
* disagree_target_toward
gen disagree_target_toward = cond(anti_pro_1ss==1|anti_pro_1ws==1|pro_anti_1wo==1|pro_anti_1so==1, 1,0)
* disagree_no_target
gen disagree_no_target = cond(anti_all_1ss==1|anti_all_1ws==1|pro_all_1wo==1|pro_all_1so==1, 1,0)
* disagree_target_away
gen disagree_target_away = cond(anti_anti_1ss==1|anti_anti_1ws==1|pro_pro_1wo==1|pro_pro_1so==1, 1,0)


* generate treatment variable for each group
gen treatment_group = 1 if agree_target_toward ==1
replace treatment_group = 2 if agree_no_target ==1
replace treatment_group = 3 if agree_target_away ==1
replace treatment_group = 4 if disagree_target_toward ==1
replace treatment_group = 5 if disagree_no_target ==1
replace treatment_group = 6 if disagree_target_away==1

gen depvar = ""
gen treatment = ""
gen uw_reg_estimate = .
gen uw_reg_lb = .
gen uw_reg_ub = .
gen bs_oprobit_estimate = .
gen bs_oprobit_lb = .
gen bs_oprobit_ub = .
* runs regressions that produces an unweighted version of table 4 and generates
* confidence intervals. The results of these regressions are reflected in the 
* second column of Appendix 14a, b, and c.

dis "Appendix 14.1, second column"
reg firstsen_agree agree_target_toward agree_no_target agree_target_away disagree_target_toward disagree_no_target disagree_target_away, nocons /*Appendix 14a, second column*/
replace depvar = "agree" in 1/6
replace treatment = "agree_target_toward" in 1
lincom agree_target_toward
replace uw_reg_estimate = r(estimate) in 1
replace uw_reg_lb = (r(estimate) - 1.96*r(se)) in 1
replace uw_reg_ub = (r(estimate) + 1.96*r(se)) in 1

replace treatment = "agree_no_target" in 2
lincom agree_no_target
replace uw_reg_estimate = r(estimate) in 2
replace uw_reg_lb = (r(estimate) - 1.96*r(se)) in 2
replace uw_reg_ub = (r(estimate) + 1.96*r(se)) in 2

replace treatment = "agree_target_away" in 3
lincom agree_target_away
replace uw_reg_estimate = r(estimate) in 3
replace uw_reg_lb = (r(estimate) - 1.96*r(se)) in 3
replace uw_reg_ub = (r(estimate) + 1.96*r(se)) in 3

replace treatment = "disagree_target_toward" in 4
lincom disagree_target_toward
replace uw_reg_estimate = r(estimate) in 4
replace uw_reg_lb = (r(estimate) - 1.96*r(se)) in 4
replace uw_reg_ub = (r(estimate) + 1.96*r(se)) in 4

replace treatment = "disagree_no_target" in 5
lincom disagree_no_target
replace uw_reg_estimate = r(estimate) in 5
replace uw_reg_lb = (r(estimate) - 1.96*r(se)) in 5
replace uw_reg_ub = (r(estimate) + 1.96*r(se)) in 5

replace treatment = "disagree_target_away" in 6
lincom disagree_target_away
replace uw_reg_estimate = r(estimate) in 6
replace uw_reg_lb = (r(estimate) - 1.96*r(se)) in 6
replace uw_reg_ub = (r(estimate) + 1.96*r(se)) in 6

dis "Appendix 14.2, second column"
reg firstsen_votefor agree_target_toward agree_no_target agree_target_away disagree_target_toward disagree_no_target disagree_target_away, nocons /*Appendix 14b, second column*/
replace depvar = "votefor" in 7/12
replace treatment = "agree_target_toward" in 7
lincom agree_target_toward
replace uw_reg_estimate = r(estimate) in 7
replace uw_reg_lb = (r(estimate) - 1.96*r(se)) in 7
replace uw_reg_ub = (r(estimate) + 1.96*r(se)) in 7

replace treatment = "agree_no_target" in 8
lincom agree_no_target
replace uw_reg_estimate = r(estimate) in 8
replace uw_reg_lb = (r(estimate) - 1.96*r(se)) in 8
replace uw_reg_ub = (r(estimate) + 1.96*r(se)) in 8

replace treatment = "agree_target_away" in 9
lincom agree_target_away
replace uw_reg_estimate = r(estimate) in 9
replace uw_reg_lb = (r(estimate) - 1.96*r(se)) in 9
replace uw_reg_ub = (r(estimate) + 1.96*r(se)) in 9

replace treatment = "disagree_target_toward" in 10
lincom disagree_target_toward
replace uw_reg_estimate = r(estimate) in 10
replace uw_reg_lb = (r(estimate) - 1.96*r(se)) in 10
replace uw_reg_ub = (r(estimate) + 1.96*r(se)) in 10

replace treatment = "disagree_no_target" in 11
lincom disagree_no_target
replace uw_reg_estimate = r(estimate) in 11
replace uw_reg_lb = (r(estimate) - 1.96*r(se)) in 11
replace uw_reg_ub = (r(estimate) + 1.96*r(se)) in 11

replace treatment = "disagree_target_away" in 12
lincom disagree_target_away
replace uw_reg_estimate = r(estimate) in 12
replace uw_reg_lb = (r(estimate) - 1.96*r(se)) in 12
replace uw_reg_ub = (r(estimate) + 1.96*r(se)) in 12

dis "Appendix 14.3, second column"
reg firstsen_therm agree_target_toward agree_no_target agree_target_away disagree_target_toward disagree_no_target disagree_target_away, nocons /*Appendix 14c, second column*/
replace depvar = "therm" in 13/18
replace treatment = "agree_target_toward" in 13
lincom agree_target_toward
replace uw_reg_estimate = r(estimate) in 13
replace uw_reg_lb = (r(estimate) - 1.96*r(se)) in 13
replace uw_reg_ub = (r(estimate) + 1.96*r(se)) in 13

replace treatment = "agree_no_target" in 14
lincom agree_no_target
replace uw_reg_estimate = r(estimate) in 14
replace uw_reg_lb = (r(estimate) - 1.96*r(se)) in 14
replace uw_reg_ub = (r(estimate) + 1.96*r(se)) in 14

replace treatment = "agree_target_away" in 15
lincom agree_target_away
replace uw_reg_estimate = r(estimate) in 15
replace uw_reg_lb = (r(estimate) - 1.96*r(se)) in 15
replace uw_reg_ub = (r(estimate) + 1.96*r(se)) in 15

replace treatment = "disagree_target_toward" in 16
lincom disagree_target_toward
replace uw_reg_estimate = r(estimate) in 16
replace uw_reg_lb = (r(estimate) - 1.96*r(se)) in 16
replace uw_reg_ub = (r(estimate) + 1.96*r(se)) in 16

replace treatment = "disagree_no_target" in 17
lincom disagree_no_target
replace uw_reg_estimate = r(estimate) in 17
replace uw_reg_lb = (r(estimate) - 1.96*r(se)) in 17
replace uw_reg_ub = (r(estimate) + 1.96*r(se)) in 17

replace treatment = "disagree_target_away" in 18
lincom disagree_target_away
replace uw_reg_estimate = r(estimate) in 18
replace uw_reg_lb = (r(estimate) - 1.96*r(se)) in 18
replace uw_reg_ub = (r(estimate) + 1.96*r(se)) in 18

*Runs an ordered probit that replicate column 3 of Appendix 14a using the program
*defined above that interprets the ordered probit and calculates confidence 
*intervals.

*Then estimates the predicted probabilities in each treatment group and the associated confidence intervals base on the probit
}
bootstrap r(agree_target_toward) r(agree_no_target) r(agree_target_away) r(disagree_target_toward) r(disagree_no_target) r(disagree_target_away), reps(5) seed(4567): oprob_agree
quietly {
matrix e = e(b)
matrix ci = e(ci_normal)
replace bs_oprobit_estimate = e[1,1] in 1
replace bs_oprobit_lb = ci[1,1] in 1
replace bs_oprobit_ub = ci[2,1] in 1

replace bs_oprobit_estimate = e[1,2] in 2
replace bs_oprobit_lb = ci[1,2] in 2
replace bs_oprobit_ub = ci[2,2] in 2

replace bs_oprobit_estimate = e[1,3] in 3
replace bs_oprobit_lb = ci[1,3] in 3
replace bs_oprobit_ub = ci[2,3] in 3

replace bs_oprobit_estimate = e[1,4] in 4
replace bs_oprobit_lb = ci[1,4] in 4
replace bs_oprobit_ub = ci[2,4] in 4

replace bs_oprobit_estimate = e[1,5] in 5
replace bs_oprobit_lb = ci[1,5] in 5
replace bs_oprobit_ub = ci[2,5] in 5

replace bs_oprobit_estimate = e[1,6] in 6
replace bs_oprobit_lb = ci[1,6] in 6
replace bs_oprobit_ub = ci[2,6] in 6

*Runs an ordered that replicate column 3 of Appendix 14b using the program
*defined above that interprets the ordered probit and calculates confidence 
*intervals.
}
bootstrap r(agree_target_toward) r(agree_no_target) r(agree_target_away) r(disagree_target_toward) r(disagree_no_target) r(disagree_target_away), reps(5) seed(5678): oprob_votefor
quietly{
matrix e = e(b)
matrix ci = e(ci_normal)
replace bs_oprobit_estimate = e[1,1] in 7
replace bs_oprobit_lb = ci[1,1] in 7
replace bs_oprobit_ub = ci[2,1] in 7

replace bs_oprobit_estimate = e[1,2] in 8
replace bs_oprobit_lb = ci[1,2] in 8
replace bs_oprobit_ub = ci[2,2] in 8

replace bs_oprobit_estimate = e[1,3] in 9
replace bs_oprobit_lb = ci[1,3] in 9
replace bs_oprobit_ub = ci[2,3] in 9

replace bs_oprobit_estimate = e[1,4] in 10
replace bs_oprobit_lb = ci[1,4] in 10
replace bs_oprobit_ub = ci[2,4] in 10

replace bs_oprobit_estimate = e[1,5] in 11
replace bs_oprobit_lb = ci[1,5] in 11
replace bs_oprobit_ub = ci[2,5] in 11

replace bs_oprobit_estimate = e[1,6] in 12
replace bs_oprobit_lb = ci[1,6] in 12
replace bs_oprobit_ub = ci[2,6] in 12

keep depvar treatment uw_reg_estimate uw_reg_lb uw_reg_ub bs_oprobit_estimate bs_oprobit_lb bs_oprobit_ub
keep in 1/18
export delimited tableA14output.txt, delim(tab) replace
}
log close
