log using Log_analysis_MTurk_data.txt, text replace

**************************************************************************************************************************************************
***Analysis of MTurk data for "Pedersen & Mutz: Attitudes toward Economic Inequality: The Illusory Agreement" *************************************
**************************************************************************************************************************************************
***Written for STATA 14 **************************************************************************************************************************
**************************************************************************************************************************************************


******************************************************
***Installing required packages and setting schemes***
******************************************************
ssc install cortesti // This installs the "cortesti" package 
ssc install estout // This installs the "estout" package 
set scheme s1mono
graph set window fontface "Garamond"


**********************
***Getting the data***
**********************
*** Run this do-file on the data file "Economic_inequality_and_Anchoring.dta" 


*************************
***Setting up the data***
*************************

*Attaching variable labels*
label variable V1	"ResponseID"
label variable V2	"ResponseSet"
label variable V3	"Name"
label variable V4	"ExternalDataReference"
label variable V5	"EmailAddress"
label variable V6	"IPAddress"
label variable V7	"Status"
label variable V8	"StartDate"
label variable V9	"EndDate"
label variable V10	"Finished"
label variable MTurkCode	"MTurkCode"
label variable Metainfo_1_TEXT	"Browser Meta Info-Browser"
label variable Metainfo_2_TEXT	"Browser Meta Info-Version"
label variable Metainfo_3_TEXT	"Browser Meta Info-Operating System"
label variable Metainfo_4_TEXT	"Browser Meta Info-Screen Resolution"
label variable Metainfo_5_TEXT	"Browser Meta Info-Flash Version"
label variable Metainfo_6_TEXT	"Browser Meta Info-Java Support"
label variable Metainfo_7_TEXT	"Browser Meta Info-User Agent"
label variable Q61	"Thank you for taking part in this survey. Upon completing the / survey you will receive a code allo..."
label variable Age	"Please tell us your age as of your last birthday"
label variable Gender	"Are you ..."
label variable Education	"What is the highest level of education that you have completed?"
label variable Class	"If you were asked to use one of these five names for your /  socio-economic class, which would you..."
label variable Partyid	"Generally speaking, do you usually think of yourself as a /  Republican, Democrat, Independent, or..."
label variable demstrweak	"Would you call yourself a strong Democrat or not a very strong / Democrat?"
label variable repstrweak	"Would you call yourself a strong Republican or not a very strong / Republican?"
label variable leaning	"Do you think of yourself as closer to the Republican or /  Democratic Party?"
label variable LR	"In politics, people sometimes talk of 'left' and 'right.' Where / would you place yourself on a sca..."
label variable C1_actual_1_1_TEXT	"We would like to know how much money you think people /  actually earn. Please write in how much yo...-How much do you think a CEO (chief executive officer) of a large national corporation actually earns?"
label variable C1_actual_2_1_TEXT	"We would like to know how much money you think people /  actually earn. Please write in how much yo...-How much do you think an average employee actually earns?"
label variable C1_a_time_1	"Timing-First Click"
label variable C1_a_time_2	"Timing-Last Click"
label variable C1_a_time_3	"Timing-Page Submit"
label variable C1_a_time_4	"Timing-Click Count"
label variable C1_ideal_1_1_TEXT	"Next, we would like to know how much money you think people ought / to be paid. How much do you thi...-How much do you think a CEO (chief executive officer) of a large national corporation should earn?"
label variable C1_ideal_2_1_TEXT	"Next, we would like to know how much money you think people ought / to be paid. How much do you thi...-How much do you think an average employee should earn?"
label variable C1_i_time_1	"Timing-First Click"
label variable C1_i_time_2	"Timing-Last Click"
label variable C1_i_time_3	"Timing-Page Submit"
label variable C1_i_time_4	"Timing-Click Count"
label variable C2_ideal_1_1_TEXT	"We would like to know how much money you think people ought to be /  paid. How much do you think th...-How much do you think a CEO (chief executive officer) of a large national corporation should earn?"
label variable C2_ideal_2_1_TEXT	"We would like to know how much money you think people ought to be /  paid. How much do you think th...-How much do you think an average employee should earn?"
label variable C2_i_time_1	"Timing-First Click"
label variable C2_i_time_2	"Timing-Last Click"
label variable C2_i_time_3	"Timing-Page Submit"
label variable C2_i_time_4	"Timing-Click Count"
label variable C2_actual_1_1_TEXT	"Next, we would like to know how much money you think people /  actually earn. Please write in how m...-How much do you think a CEO (chief executive officer) of a large national corporation actually earns?"
label variable C2_actual_2_1_TEXT	"Next, we would like to know how much money you think people /  actually earn. Please write in how m...-How much do you think an average employee actually earns?"
label variable C2_a_time_1	"Timing-First Click"
label variable C2_a_time_2	"Timing-Last Click"
label variable C2_a_time_3	"Timing-Page Submit"
label variable C2_a_time_4	"Timing-Click Count"
label variable C3_actual	"We would like to know how much more money you think a CEO (chief /  executive officer) of a large n..."
label variable C3_a_time_1	"Timing-First Click"
label variable C3_a_time_2	"Timing-Last Click"
label variable C3_a_time_3	"Timing-Page Submit"
label variable C3_a_time_4	"Timing-Click Count"
label variable C3_ideal	"Next, we would like to know how much more money you think the CEO /  (chief executive officer) of a..."
label variable C3_i_time_1	"Timing-First Click"
label variable C3_i_time_2	"Timing-Last Click"
label variable C3_i_time_3	"Timing-Page Submit"
label variable C3_i_time_4	"Timing-Click Count"
label variable C4_ideal	"We would like to know how much more money you think a CEO (chief / executive officer) of a large na..."
label variable C4_i_time_1	"Timing-First Click"
label variable C4_i_time_2	"Timing-Last Click"
label variable C4_i_time_3	"Timing-Page Submit"
label variable C4_i_time_4	"Timing-Click Count"
label variable C4_actual	"Next, we would like to know how much more money you think a CEO /  (chief executive officer) of a l..."
label variable C4_a_time_1	"Timing-First Click"
label variable C4_a_time_2	"Timing-Last Click"
label variable C4_a_time_3	"Timing-Page Submit"
label variable C4_a_time_4	"Timing-Click Count"
label variable C5_actual	"We would like to know how much more money you think a CEO (chief /  executive officer) of a large n..."
label variable C5_a_time_1	"Timing-First Click"
label variable C5_a_time_2	"Timing-Last Click"
label variable C5_a_time_3	"Timing-Page Submit"
label variable C5_a_time_4	"Timing-Click Count"
label variable C5_ideal	"Next, we would like to know how much more money you think the CEO /  (chief executive officer) of a..."
label variable C5_i_time_1	"Timing-First Click"
label variable C5_i_time_2	"Timing-Last Click"
label variable C5_i_time_3	"Timing-Page Submit"
label variable C5_i_time_4	"Timing-Click Count"
label variable C5_surpris	"You have estimated that a CEO (chief executive officer actually earns as much as ..."
label variable C5_surp_ti_1	"Timing-First Click"
label variable C5_surp_ti_2	"Timing-Last Click"
label variable C5_surp_ti_3	"Timing-Page Submit"
label variable C5_surp_ti_4	"Timing-Click Count"
label variable C6_ideal_1_1_TEXT	"A CEO (chief executive officer) of a large national corporation /  earns on average $12,259,894 eac...-How much do you think a CEO (chief executive officer) of a large national corporation should earn?"
label variable C6_ideal_2_1_TEXT	"A CEO (chief executive officer) of a large national corporation /  earns on average $12,259,894 eac...-How much do you think an average employee should earn?"
label variable C6_time_1	"Timing-First Click"
label variable C6_time_2	"Timing-Last Click"
label variable C6_time_3	"Timing-Page Submit"
label variable C6_time_4	"Timing-Click Count"
label variable C7_ideal	    "A CEO (chief executive officer) a large national corporation /  earns on average as much as 354 ave..."
label variable C7_time_1	"Timing-First Click"
label variable C7_time_2	"Timing-Last Click"
label variable C7_time_3	"Timing-Page Submit"
label variable C7_time_4	"Timing-Click Count"
label variable C8_ideal	    "In the United States, a CEO (chief executive officer) of a /  large national corporation earns as m..."
label variable C8_time_1	"Timing-First Click"
label variable C8_time_2	"Timing-Last Click"
label variable C8_time_3	"Timing-Page Submit"
label variable C8_time_4	"Timing-Click Count"
label variable C9	"[This is a hidden question, included to make the randomization / work properly. Respondents will..."
label variable Q31_1	"To what extent do you agree or disagree with the following /  statements?-Differences in income in America are far too large."
label variable Q31_2	"To what extent do you agree or disagree with the following /  statements?-The gap between the rich and poor in this country mostly reflects the fact that some people work harder than others."
label variable Q31_3	"To what extent do you agree or disagree with the following /  statements?-In America, anyone who wants to make money can do it if they just try hard enough."
label variable Q31_4	"To what extent do you agree or disagree with the following /  statements?-It is the responsibility of the government to reduce the differences in income between people with high incomes and those with low incomes."
label variable Q31_5	"To what extent do you agree or disagree with the following /  statements?-The government should provide a decent standard of living for the unemployed."
label variable Q31_6	"To what extent do you agree or disagree with the following /  statements?-The government should spend less on benefits for the poor."
label variable Q31_7	"To what extent do you agree or disagree with the following /  statements?-Some inequality is necessary in order to reward those who work hard."
label variable Q32	"Do you think people with high incomes should pay a larger share of / their income in taxes than tho..."
label variable Q33	"Generally, how would you describe taxes in America today for /  those with higher incomes? Taxes..."
label variable Q34	"Is it just or unjust - right or wrong - that /  people with higher incomes can buy better health ca..."
label variable Q35	"Is it just or unjust - right or wrong - that /  people with higher incomes can buy better education..."
label variable Q36	"Is it just or unjust - right or wrong - that /  people with higher incomes are not eligible for the..."
label variable Q49	"Do you think the gap between the rich and the poor in the US is /  getting larger, getting smaller,..."
label variable Q50	"Is the gap between the rich and poor getting a little bit larger /  or a lot larger?"
label variable Q51	"Is the gap between the rich and poor getting a little bit smaller /  or a lot smaller?"
label variable Q37	"The Securities and Exchange Commission, an independent agency of /  the U.S. federal government, re..."
label variable Q38_1	"How much do you favor or oppose  -Lower taxes on corporations to encourage investment and economic growth"
label variable Q38_2	"How much do you favor or oppose  -Higher taxes on corporations to fund programs that help the poor"
label variable Q38_3	"How much do you favor or oppose  -A law that would raise the federal minimum wage"
label variable Q38_4	"How much do you favor or oppose  -The 2010 Affordable Care Act (also known as Obamacare)"
label variable Q38_5	"How much do you favor or oppose  -Cutting programs like food stamps, Medicaid, unemployment insurance and the child tax credit."
label variable Q38_6	"How much do you favor or oppose  -Making federal taxes more progressive, so the rich pay a significantly higher share of their income than the middle class or poor"
label variable Q38_7	"How much do you favor or oppose  -Increasing taxes on higher income people to pay for more government services to the poor"
label variable Q44	    "Do you think people who are poor, and earn below a certain income, / should be required to pay some..."
label variable Q45_1	"To what extent do you agree or disagree with the following /  statements?-Inequality is a particularly severe problem in the United States relative to other countries"
label variable Q45_2	"To what extent do you agree or disagree with the following /  statements?-The gap between the incomes of the rich and poor is unusually large in the United States."
label variable Q52	"In your opinion, are most CEOs (chief executive officers) of large / national corporations paid too..."
label variable Q53	"In your opinion, are employees generally paid too much, about / right, or too little?"
label variable Q46	"Would you say the gap between the rich and the poor in America is / greater than in most other deve..."
label variable Q47	"Is that a little greater than in most other developed countries, or / a lot greater than in most ot..."
label variable Q48	"Is that a little smaller than in most other developed countries, or / a lot smaller than in most ot..."
label variable LocationLatitude	"LocationLatitude"
label variable LocationLongitude	"LocationLongitude"
label variable LocationAccuracy	"LocationAccuracy"

*dropping irelevant variables (meta-data etc.)*
drop ResponseID V2 V3 V4 V5 V6 V7 V10 V10 MTurkCode Metainfo_1_TEXT Metainfo_2_TEXT Metainfo_3_TEXT Metainfo_4_TEXT Metainfo_5_TEXT Metainfo_6_TEXT Metainfo_7_TEXT Q61 LocationLatitude LocationLongitude LocationAccuracy

*Creating and attaching value labels to DVs*
label define agree_disagree_labels 1 "Strongly Agree" 2 "Agree" 3 "Neither Agree nor Disagree" 4 "Disagree"  5 "Strongly disagree"
label values Q31_1 agree_disagree_labels
label values Q31_2 agree_disagree_labels
label values Q31_3 agree_disagree_labels
label values Q31_4 agree_disagree_labels
label values Q31_5 agree_disagree_labels
label values Q31_6 agree_disagree_labels 
label values Q31_7 agree_disagree_labels

label define share_labels  1 "Much larger share" 2 "Larger" 3 "The same share" 4 "Smaller" 5 "Much smaller share"
label values Q32 share_labels

label define highorlow_labels 1 "Much to high" 2 "Too high" 3 "About right" 4 "Too low" 5 "Much too low"
label values Q33 highorlow_labels

label define justorunjust_labels 1 "Very Just, definitely right" 2 "Somewaht just, right" 3 "Neither just nor unjust, mixed feelings" 4 "Somewhat unjust, wrong" 5 "Very unjust, definitely wrong"
label values Q34 justorunjust_labels
label values Q35 justorunjust_labels
label values Q36 justorunjust_labels

label define favororoppose_labels 1 "Strongly favor" 2 "Favor" 3 "Neitehr favor nor oppose" 4 "Oppose" 5 "Strongly oppose"
label values Q37 favororoppose_labels 
label values Q38_1 favororoppose_labels 
label values Q38_2 favororoppose_labels 
label values Q38_3 favororoppose_labels 
label values Q38_4 favororoppose_labels 
label values Q38_5 favororoppose_labels 
label values Q38_6 favororoppose_labels 
label values Q38_7 favororoppose_labels  

label define poortaxes_labels 1 "Should pay some taxes" 2 "should be excempt from taxes"
label values Q44 poortaxes_labels

*Total time of survey
gen time_survey_seconds=((V9-V8)/1000)

*Female*
recode Gender (2=1 "Female") (1=0 "Male"), gen(Female)
drop Gender

*Education / College degree*
label define Education_labels 1 "Less than high School" 2 "High school" 3 "Some college" 4 "Two Years College" 5 "Bachelor's degree" 6 "Graduate degree"
label values Education Education_labels
recode Education (1 2 3=0 "No college degree") (4 5 6=1 "College degree"), gen(College)

*Socio-economic Class*
label define Class_labels 1 "Upper class" 2 "Upper-middle class" 3 "Middle class" 4 "Working class" 5 "Lower class" 
label values Class Class_labels

*Party ID*
gen Party_ID=0
recode Party_ID (0=7) if repstrweak==1
recode Party_ID (0=6) if repstrweak==2
recode Party_ID (0=5) if leaning==1
recode Party_ID (0=4) if leaning==2
recode Party_ID (0=3) if leaning==3
recode Party_ID(0=2) if demstrweak==2
recode Party_ID (0=1) if demstrweak==1
recode Party_ID (1 2 3=0 "Democrat") (4=1 "Independent") (5 6 7=2 "Republican"), gen(P_ID_DIR) 
drop Partyid repstrweak leaning demstrweak

*Left-Right Self-placement*
label define LR_labels 1 "Extreme left" 2 "Left" 3 "Center left" 4 "Center" 5 "Center Right" 6 "Right" 7 "Extreme right"
label values LR LR_labels

 
*Experimental conditions (Condition 9 is given the value 0 to make it the reference category)*
gen Condition=0
recode Condition (0=1) if C1_i_time_3!=.
recode Condition (0=2) if C2_i_time_3!=.
recode Condition (0=3) if C3_i_time_3!=.
recode Condition (0=4) if C4_i_time_3!=.
recode Condition (0=5) if C5_i_time_3!=.
recode Condition (0=6) if C6_time_3!=.
recode Condition (0=7) if C7_time_3!=.
recode Condition (0=8) if C8_time_3!=.
label define Condition_labels 1 "Actual-ideal numbers" ///
                              2 "Ideal-actual numbers" ///
							  3 "Actual-ideal multiple" ///
							  4 "Ideal-actual multiple" ///
							  5 "Kuklinski correction" ///
							  6 "Actual salary provided" ///
							  7 "Actual multiple provided" ///
							  8 "Cross-national multiple provided" ///
							  0 "Control"
label values Condition Condition_labels

recode Condition (1 3 5=0 "Actual first, then Ideal") (2 4=1 "Ideal first then Actual") (6 7=2 "Actual provided, then Ideal") (else=.), gen(anchor) 
recode Condition (1 2 6=0 "Dollars") (3 4 5 7 8=1 "Multiples") (else=.), gen(multiple) 
drop if Condition==0 | Condition==5 | Condition==8 //these condition do not contain all the questions used in the analyses, and they are therefore excluded from all analyses
							  
							  
*Ideal - numbers*
destring C6_ideal_1_1_TEXT, replace force //we loose one obsevation here (Someone wrote "2,500,00")
gen Ideal_CEO=max(C1_ideal_1_1_TEXT, C2_ideal_1_1_TEXT, C6_ideal_1_1_TEXT)
gen Ideal_Worker=max(C1_ideal_2_1_TEXT, C2_ideal_2_1_TEXT, C6_ideal_2_1_TEXT)
*Ideal - Multiples
gen Ideal_Ratio_multiple=max(C3_ideal, C4_ideal, C5_ideal, C7_ideal, C8_ideal)
gen Ideal_Ratio_numbers=Ideal_CEO/Ideal_Worker
*Ideal - All
gen Ideal_Ratio_all=max(Ideal_Ratio_multiple, Ideal_Ratio_numbers)
gen Ideal_Ratio_all_log=log(Ideal_Ratio_all)

*Actual - numbers*
destring C1_actual_1_1_TEXT, replace force //we loose one obsevation here
gen Actual_CEO=max(C1_actual_1_1_TEXT, C2_actual_1_1_TEXT)
gen Actual_Worker=max(C1_actual_2_1_TEXT, C2_actual_2_1_TEXT)
*Actual - Multiples*
gen Actual_Ratio_multiple=max(C3_actual, C4_actual, C5_actual)
gen Actual_Ratio_numbers=Actual_CEO/Actual_Worker
*Actual - All
gen Actual_Ratio_all=max(Actual_Ratio_multiple, Actual_Ratio_numbers)
gen Actual_Ratio_all_log=log(Actual_Ratio_all)

gen wantlowerdifferences=.
replace wantlowerdifferences = -1 if Actual_Ratio_all_log < Ideal_Ratio_all_log
replace wantlowerdifferences = 0 if Actual_Ratio_all_log == Ideal_Ratio_all_log
replace wantlowerdifferences = 1 if Actual_Ratio_all_log > Ideal_Ratio_all_log

*Is the gap greater in the US than other countries*
gen LargegapinUS=.
recode LargegapinUS (.=5) if Q47==2
recode LargegapinUS (.=4) if Q47==1
recode LargegapinUS (.=3) if Q46==2
recode LargegapinUS (.=2) if Q48==1
recode LargegapinUS (.=1) if Q48==2
drop Q46 Q47 Q48

*Is the gap in the US getting larger*
gen gapgettinglarger=.
recode gapgettinglarger (.=5) if Q50==2
recode gapgettinglarger (.=4) if Q50==1
recode gapgettinglarger (.=3) if Q49==2
recode gapgettinglarger (.=2) if Q51==1
recode gapgettinglarger (.=1) if Q51==2
drop Q49 Q50 Q51

*Q31_1: Differences in income in America are far too large*
recode Q31_1 (1 2=2) (3=1) (4 5=0), gen(dif_too_large_3)
label define dif_too_large_3 0 "Strongly disagree / Disagree" 1 "Neither Agree nor Disagree" 2 "Strongly Agree /Agree"
label values dif_too_large_3 dif_too_large_3


*Creating a scale based on all the nonnumerical questions about inequality*
factor Q31_1 Q31_2 Q31_3 Q31_4 Q31_5 Q31_6 Q31_7 Q32 Q33 Q34 Q35 Q36 Q37 Q38_1 Q38_2 Q38_3 Q38_4 Q38_5 Q38_6 Q38_7 Q44 Q45_1 Q45_2 Q52 Q53 //one factor account for more than 80% of variance
alpha Q31_1 Q31_2 Q31_3 Q31_4 Q31_5 Q31_6 Q31_7 Q32 Q33 Q34 Q35 Q36 Q37 Q38_1 Q38_2 Q38_3 Q38_4 Q38_5 Q38_6 Q38_7 Q44 Q45_1 Q45_2 Q52 Q53, item std gen(alldv)
*scale on inequality that is not explicitly linked to government/taxes
alpha Q31_1 Q31_2 Q31_3 Q31_7 Q34 Q35 Q45_1 Q45_2 Q52 Q53, item std gen(inequality_basic)
*scale on government
alpha Q31_4 Q31_5 Q31_6 Q36 Q37 Q38_3 Q38_4 Q38_5, item std gen(inequality_gov)
*scale on taxes
alpha Q32 Q33 Q38_1 Q38_2 Q38_6 Q38_7 Q44, item std gen(inequality_tax)

***************************************************************************************************************************************************************************************
***ANALYSES****************************************************************************************************************************************************************************
***************************************************************************************************************************************************************************************

*Describing participants (These values are reported in note 5)*
tab Female
sum Age
sum time_survey_seconds, detail

*Analyzing effect of manipulations (These values are reported in the section "Experimental Results")*
anova Ideal_Ratio_all_log anchor##multiple 
pwcompare anchor##multiple, groups effects


	*Means (and SD) of all 6 conditions (These values are reported in note 8)*
	anova Ideal_Ratio_all_log anchor##multiple 
	margins, over(anchor multiple) cformat(%9.1f)
	
	*Illustration of anchoring effect(used as part of Figure 2 in the paper)*
	anova Ideal_Ratio_all_log anchor##multiple
	margins, over(anchor) asbalanced pwcompare(effects) 
	margins, over(anchor) asbalanced 
	marginsplot, title("Anchoring context") recast(scatter) plotopts(msize(large)) recastci(rspike) ytitle("Ideal Ratio (logged)" " ") ylabel(2(0.5)4, grid gmin gmax) allxlabel xscale(range(-0.5 2.5)) ///
				 xlabel(0 `""Ideal first," "then Actual""' 1`""Actual first," "then Ideal""' 2`""Actual provided," "then Ideal""', labsize(medium)) scheme(s1mono) xtitle("") plotregion(lcolor(none)) fxsize(80) ///
				 graphregion(margin(tiny))
				graph save Exp_Ideal_Anchoring.gph, replace

	*Illustration of ratio bias effect(used as part of Figure 2 in the paper)*
	anova Ideal_Ratio_all_log anchor##multiple
	margins, over(multiple) asbalanced pwcompare(effects) 
	margins, over(multiple) asbalanced
	marginsplot, title("Dollars versus Multiples") recast(scatter) plotopts(msize(large)) recastci(rspike) ytitle("Ideal Ratio (logged)") ylabel(2(0.5)4, grid gmin gmax) allxlabel xscale(range(-0.5 1.5)) ///
				 xlabel(0 `""Dollars" ""g "' 1`""Multiples" ""g "' , labsize(medium))  scheme(s1mono) xtitle("") plotregion(lcolor(none)) fxsize(40) yscale(off) ///
				  graphregion(margin(tiny))
	graph save Exp_Ideal_Multiples.gph, replace

*Combined illustration of anchoring and ratio bias effect(Figure 2 in the paper)*
graph combine "Exp_Ideal_Anchoring.gph" "Exp_Ideal_Multiples.gph", ycommon imargin(0 0 0 0) ///
			  title("Figure 2: The Effect of Anchoring Context and" "Dollars versus Multiples on Ideal Pay Ratios" "(With 95% Confidence Intervals)" " ", size(medlarge)) ///
			  caption(" ""Note: Points represent the average natural log of Ideal Pay Ratios by experimental factors. The three by two analysis of " ///
			  "variance produced two significant main effects, one for Anchoring Context(F(2, 573)=9.43, p<.001), and one for Dollars" ///
			  "versus Multiples (F(1, 574)= 42.22, p<.001). Asking in terms of multiples produces significantly higher Ideal Pay Ratios" ///
			  "than Dollars (p<.001), and providing a common Actual Pay Ratio anchor before asking about the Ideal Pay Ratio produces" ///
			  "a significantly higher Ideal Pay Ratio (p<.01).)", size(small))  
graph export "Figure2.pdf", replace 
erase Exp_Ideal_Anchoring.gph 
erase Exp_Ideal_Multiples.gph


*Analyzing the predictive validity of the ratio measure*************************************************************************************************************  
pwcorr Ideal_Ratio_all_log  alldv, sig obs star(.05)
bysort anchor multiple: pwcorr Ideal_Ratio_all_log  alldv, sig obs star(.05)

bysort anchor : pwcorr Ideal_Ratio_all_log  alldv , sig obs star(.05)
	//Correlations with alldv(n):  
	//Actual first, then Ideal:    0.1304 (203)
	//Ideal first, then Actual:    0.1241 (175)
	//Actual provided, then Ideal: 0.3436 (197)
	cortesti	 0.1304 203 0.1241 175 //Difference in correlations between "Actual first, then Ideal" and "Ideal first, then Actual" is not significant 
	cortesti	 0.1304 203 0.3436 197 //Difference in correlations between "Actual first, then Ideal" and "Actual provided, then Ideal" is significant
	cortesti 	 0.1241 175 0.3436 197 //Difference in correlations between "Ideal first, then Actual" and "Actual provided, then Ideal" is significant
bysort multiple: pwcorr Ideal_Ratio_all_log  alldv , sig obs star(.05)
	//Correlations with alldv(n):  
	//Dollars: 0.2313 (260) 
	//Multiples: 0.1578 (315)
	cortesti 0.2313 260 0.1578 315 //Difference in correlations between "Dollars" and "Multiples" is not significant 

	*Additional test reported in footnote 9 in the paper*
	pwcorr Ideal_Ratio_all_log  LR, sig obs star(.05)
	bysort anchor multiple: pwcorr Ideal_Ratio_all_log  LR, sig obs star(.05)
	bysort anchor : pwcorr Ideal_Ratio_all_log  LR, sig obs star(.05)
	//Correlations with LR(n):  
		//Actual first, then Ideal:    0.1736 (203)
		//Ideal first, then Actual:    0.1245 (175)
		//Actual provided, then Ideal: 0.2776 (197)
		cortesti 0.1736 203	0.1245 175 //Difference in correlations between "Actual first, then Ideal" and "Ideal first, then Actual" is not significant 
		cortesti 0.1736 203	0.2776 197 //Difference in correlations between "Actual first, then Ideal" and "Actual provided, then Ideal" is not significant
		cortesti 0.1245 175	0.2776 197  //Difference in correlations between "Ideal first, then Actual" and "Actual provided, then Ideal" is not significant
	bysort multiple: pwcorr Ideal_Ratio_all_log LR, sig obs star(0.05)
		//Correlations with LR(n):  
		//Dollars: 0.2235 (260) 
		//Multiples: 0.1457 (315)
		cortesti 0.2235 260 0.1457 315 //Difference in correlations between "Dollars" and "Multiples" is not significant 

pwcorr LR alldv, sig obs star(.05) //alldv correlates strongly with LR!

***Illustration of correlations (using a "non-sensical" regression in order to get the right layout)***
	gen cor_alldv=.
	recode cor_alldv (.=0.2210 ) if Condition== 1
	recode cor_alldv (.=0.1115 ) if Condition== 2
	recode cor_alldv (.=0.0468 ) if Condition== 3
	recode cor_alldv (.=0.1385 ) if Condition== 4
	recode cor_alldv (.=0.3901 ) if Condition== 6
	recode cor_alldv (.=0.3339 ) if Condition== 7

	gen cor_alldv2=.
	recode cor_alldv2 (.=0.1304) if anchor==0
	recode cor_alldv2 (.=0.1241) if anchor==1
	recode cor_alldv2 (.=0.3436) if anchor==2
	
	gen cor_alldv3=.
	recode cor_alldv3 (.=0.2313) if multiple==0
	recode cor_alldv3 (.=0.1578) if multiple==1
	
	reg cor_alldv2 i.anchor##i.multiple
	margins, over(anchor) asbalanced 
	marginsplot, title("Anchoring context") recast(bar) plotopts(barwidth(.75)) noci ytitle("Pearson's r" " ") ylabel(0(0.05).4, grid gmin gmax) allxlabel ///
				 xlabel(0 `""Ideal first," "then Actual""' 1`""Actual first," "then Ideal""' 2`""Actual provided," "then Ideal""', labsize(medium)) scheme(s1mono) xtitle("") plotregion(lcolor(none)) fxsize(70) ///
				 graphregion(margin(tiny)) 
	graph save Corr_Anchoring.gph, replace
	
	reg cor_alldv3 i.anchor##i.multiple
	margins, over(multiple) asbalanced
	marginsplot, title("Dollars versus Multiples") recast(bar) plotopts(barwidth(.75)) noci ytitle("Pearson's r") ylabel(0(0.05).4, grid gmin gmax) allxlabel ///
				 xlabel(0 `""Dollars" ""g "' 1`""Multiples" ""g "' , labsize(medium))  scheme(s1mono) xtitle("") plotregion(lcolor(none)) fxsize(40) yscale(off) ///
				 graphregion(margin(tiny))
	graph save Corr_Multiples.gph, replace
	
	*Figure 3 in the paper*
	graph combine "Corr_Anchoring.gph" "Corr_Multiples.gph", ycommon imargin(0 0 0 0) ///
	title("Figure 3: Correlations between Ideal Pay Ratio and Index of" "Attitudes toward Inequality, by Experimental Factors" " ", size(medlarge)) ///
	caption(" " "Note: Bars represent the size of the correlation between the average natural log of the Ideal Pay Ratio and the Index of" ///
	"Attitudes Toward Inequality, by experimental factor.  A test using Fisher's r-to-z transformation (Cox, 2008; Fisher, 1921)" ///
	"confirmed that the correlation in the Actual Provided conditions (r=.34) was significantly higher (p<.05) than the" ///
	"correlations in the Ideal First conditions (r=.13) and the Actual First conditions (r=.12).", size(small))
	graph export "Figure3.pdf", replace 
	erase Corr_Anchoring.gph
	erase Corr_Multiples.gph

	
*TABLE 2 in the paper: testing whether ratios predict attitudes, when controlling for PID and LR
reg alldv LR Party_ID, robust
*eststo m0a
reg alldv LR Party_ID Ideal_Ratio_all_log, robust
*eststo m0b
reg alldv LR Party_ID Ideal_Ratio_all_log if multiple==0, robust
eststo m1
reg alldv LR Party_ID Ideal_Ratio_all_log if multiple==1, robust
eststo m2
reg alldv LR Party_ID Ideal_Ratio_all_log if anchor==0, robust
eststo m3
reg alldv LR Party_ID Ideal_Ratio_all_log if anchor==1, robust
eststo m4
reg alldv LR Party_ID Ideal_Ratio_all_log if anchor==2, robust
eststo m5
esttab 	using table2.rtf, b(2) se(2) r2(3) compress replace ///
		title("TABLE 2: EXTENT TO WHICH RATIOS PREDICT INDEX OF ATTITUDES TOWARD INEQUALITY, AFTER CONTROLLING FOR IDEOLOGY AND PARTY, BY DOLLARS VERSUS MULTIPLES AND ORDER. ") ///
		mtitles(/*"Party ID and LR" "Party ID, LR AND RATIO"*/ "Raw dollars" "Multiples" "Actual first, then Ideal" "Ideal first, then Actual" "Actual provided") ///
		coeflabels(LR "Ideology (Conservative)" Party_ID "Party ID (republican)" Ideal_Ratio_all_log "Ideal ratio(ln)" _cons "Constant") ///
		nonotes  addnotes("Note: Entries are OLS regression coefficients predicting the Index of Attitudes Toward Inequality by experimental conditions, with robust standard errors in parentheses." ///
		"* p<0.05, ** p<0.01, *** p<0.001")
		eststo clear


*********       
*THE END*
*********

log close
