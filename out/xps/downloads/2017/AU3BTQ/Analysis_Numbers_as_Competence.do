**************************************************************************************************************************************************
***Analyses for the manuscript "Politicians Appear More Competent When Using Numerical Rhethoric" (mediation analyses conducted in R)*************
**************************************************************************************************************************************************
***Written for STATA 14 **************************************************************************************************************************
**************************************************************************************************************************************************
***The do file requires the packages "estout", "combomarginsplot" and "oparallel"*****************************************************************
**************************************************************************************************************************************************



***************************************************************************************************************************************************
***Getting the data********************************************************************************************************************************
***************************************************************************************************************************************************
clear all
set more off, permanently 
cd "C:\Numbers_as_competence\"
import excel "C:\Numbers_as_competence\survey_data_for_numbers_as_competence.xlsx", sheet("Sheet1") firstrow
*Dataset contain data from conducted survey and background data from Epinion*

***************************************************************************************************************************************************
***Attaching labels********************************************************************************************************************************
***************************************************************************************************************************************************
label variable	Respondent_Serial	        "Serial_number"
label variable	DataCollection_StartTime	"Interview start"
label variable	DataCollection_FinishTime	"Interview end"
label variable	q1	                        "Party Choice"
label variable	q2	                        "Left Right Self Placement?"
label variable	q3	                        "Interest in Politics"
label variable	q4_group	                "Experimental stimuli"
label variable	q4_1_resp	                "How well does the word intelligent describe politician A?"
label variable	q4_2_resp	                "How well does the word intelligent describe politician  B?"
label variable	q4_response_                "Second	- The number of seconds the respondents are looking on this text (Q4)"
label variable	q5_1_resp	                "How well does the word competent describe politician A?"
label variable	q5_2_resp	                "How well does the word competent describe politician B?"
label variable	q6_1_resp	                "How well does the word credible describe politician A?"
label variable	q6_2_resp	                "How well does the word credible describe politician B?"
label variable	q7_1_resp	                "How well does the word knowledgeable describe politician A?"
label variable	q7_2_resp	                "How well does the word knowledgeable describe politician B?"
label variable	q8_1_resp	                "How well does the word likeable describe politician A?"
label variable	q8_2_resp	                "How well does the word likeable describe politician B?"
label variable	q9_1_resp	                "How well does the word conscientious describe politician A?"
label variable	q9_2_resp	                "How well does the word conscientious describe politician B?"
label variable	q10_1_resp	                "How well does the word friendly describe politician A?"
label variable	q10_2_resp	                "How well does the word friendly describe politician B?"
label variable	q11_1_resp	                "How well does the word caring describe politician A?"
label variable	q11_2_resp	                "How well does the word caring describe politician B?"
label variable	q12     	                "Which one of the two politicians would you rather vote for?"
label variable	q13	                        "Are you opposed to or in favor of genetically modified foods?"
label variable	q14	                        "Do you remember whether the politicians used numbers in their discussion?"
label variable	q15a	                    "Politician A mentioned a specific number for what the cultivation of genetically modified foods would mean for the use of pesticides. Do you remember what it was?"
label variable	q15b	                    "Politician B mentioned a specific number for what the cultivation of genetically modified foods would mean for the use of pesticides. Do you remember what it was?"
label variable	q15c	                    "Politician A mentioned that the cultivation of genetically modified foods would have consequences for the use of pesticides. Do you remember what it was?"
label variable	Alder	                    "Age"
label variable	Uddannelse	                "Education"
label variable	Køn	                        "Gender"
label variable	Region	                    "Region"
label variable	Alder_kat	                "Age Category"

label define gender 0 "Male" 1 "Female"
label values Køn gender

label define education 1 "Lower secondary" 2 "Vocational" 3 "Upper secondary" 4 "short/medium tertiary" 5 "long term tertiary"
label values Uddannelse education


label define party 	1 "Social Democrats" 2 "Social Liberals" 3 "Conservative People's Party" ///
					4 "Socialist People's party" 5 "Liberal Alliance" 6 "Christian Democrats" ///
					7 "Danish People's party" 8 "Liberals" 9 "The Red-Green Alliance" 10 "Alternative" ///
					11 "Other Party / Non-party Candidate" 12 "Will not vote" 13 "Casting blank ballot" 14 "Don't know"
label values q1 party

label define GM_attitude 1 "Very strongly opposed" 2 "Strongly opposed" 3 "Opposed" 4 "Neither opposed nor in favor" ///
                         5 "In favor" 6 "Strongly in favor" 7 "Very strongly in favor" 8 "Don't know" 
label values q13 GM_attitude
						 
						 
label define use_of_numbers 1 "Only A" 2 "Only B" 3 "Both A and B" 4 "Neither A nor B" 5 "Don't know"
label values q14 use_of_numbers 


************************************************************************************************************************************************
***Recoding/Creating variables******************************************************************************************************************
************************************************************************************************************************************************

****************
***Covariates***
****************

*Gender*
gen female=Køn
label values female gender 
recode female (.=0), gen(female2)  //missing are set to 0 (female2 only used as covariate in mediation analyses)
label values female2 gender 


*Age*
recode Alder (0=.), gen(age)

*Education*
gen education=Uddannelse
recode education (.=6 "missing"), gen(education2)
label values education education
recode education (1 2 3=0) (4 5=1), gen(college)
recode education (1 2 3=0) (4 5=1) (else=0), gen(college2) //missing are set to 0 (only used as covariate in mediation analyses)


*Party Choice
gen party=q1
label values party party
 
	recode party (3 5 6 7 8=1) (else=0), gen(blue) //these variables divide the parties into the two "blocks" (not used in analyses)
	recode party (1 2 4 9 10=1)(else=0), gen(red)
	label define red 0 "Not center-left" 1 "Center-left"
	label values red red
	
*Left-Right
gen rightwing_withmissing=(q2-1)/10
recode rightwing_withmissing (1.1=.), gen(rightwing) 
recode rightwing_withmissing (1.1=.5), gen(rightwing2) //missing are set to middle (rigthwing2 only used as covariate in mediation analyses)

*Interest*
gen interest_withmissing=(q3-1)/10
recode interest_withmissing (1.1=.), gen(interest)
recode interest_withmissing (1.1=.5), gen(interest2) //missing are set to middle (interest2 only used as covariate in mediation analyses)


****************
***Conditions***
****************

recode q4_group (1 5=1 "1no_numbers") (2 6=2 "2pro_numbers") (3 7=3 "3con_numbers") (4 8=4 "4both_numbers"), gen(condition)
recode q4_group (1 3 5 7=0) (2 4 6 8=1), gen(pro_using_numbers)
recode q4_group (1 2 5 6=0) (3 4 7 8=1), gen(con_using_numbers)

tab SurveyStatus condition, chi //drop-off does not differ significantly between experimental conditions 
	//Note: this analyses can only be run before dropping the incompletes

	recode condition (2=1) (3=0) (else=.), gen(binary_numbers) //these variables are not used in analyses
	recode condition (2=1) (1=0) (else=.), gen(pro_versus_none)
	recode condition (3=1) (1=0) (else=.), gen(con_versus_none)
	recode condition (4=1) (1=0) (else=.), gen(both_versus_none)

*dropping incompletes
drop if SurveyStatus==1 //Large majority of drop-out was right at beginning og survey: Among the 267 incompletes, only 10 respondents answered all items for competence and warmth

*************************
***Dependent variables***
*************************

*intelligent	   
gen pro_intelligent=.
replace pro_intelligent=q4_1_resp if q4_group<5 
replace pro_intelligent=q4_2_resp if q4_group>4

gen con_intelligent=.
replace con_intelligent=q4_2_resp if q4_group<5 
replace con_intelligent=q4_1_resp if q4_group>4


*competent
gen pro_competent=.
replace pro_competent=q5_1_resp if q4_group<5 
replace pro_competent=q5_2_resp if q4_group>4

gen con_competent=.
replace con_competent=q5_2_resp if q4_group<5 
replace con_competent=q5_1_resp if q4_group>4


*credible
gen pro_credible=.
replace pro_credible=q6_1_resp if q4_group<5 
replace pro_credible=q6_2_resp if q4_group>4

gen con_credible=.
replace con_credible=q6_2_resp if q4_group<5 
replace con_credible=q6_1_resp if q4_group>4


*knowledgeable
gen pro_knowledgeable=.
replace pro_knowledgeable=q7_1_resp if q4_group<5 
replace pro_knowledgeable=q7_2_resp if q4_group>4

gen con_knowledgeable=.
replace con_knowledgeable=q7_2_resp if q4_group<5 
replace con_knowledgeable=q7_1_resp if q4_group>4


*likeable
gen pro_likeable=.
replace pro_likeable=q8_1_resp if q4_group<5 
replace pro_likeable=q8_2_resp if q4_group>4

gen con_likeable=.
replace con_likeable=q8_2_resp if q4_group<5 
replace con_likeable=q8_1_resp if q4_group>4


*conscientious
gen pro_conscientious=.
replace pro_conscientious=q9_1_resp if q4_group<5 
replace pro_conscientious=q9_2_resp if q4_group>4

gen con_conscientious=.
replace con_conscientious=q9_2_resp if q4_group<5 
replace con_conscientious=q9_1_resp if q4_group>4


*friendly
gen pro_friendly=.
replace pro_friendly=q10_1_resp if q4_group<5 
replace pro_friendly=q10_2_resp if q4_group>4

gen con_friendly=.
replace con_friendly=q10_2_resp if q4_group<5 
replace con_friendly=q10_1_resp if q4_group>4


*caring
gen pro_caring=.
replace pro_caring=q11_1_resp if q4_group<5 
replace pro_caring=q11_2_resp if q4_group>4

gen con_caring=.
replace con_caring=q11_2_resp if q4_group<5 
replace con_caring=q11_1_resp if q4_group>4



recode pro_intelligent pro_competent pro_credible pro_knowledgeable pro_likeable pro_conscientious pro_friendly pro_caring ///
       con_intelligent con_competent con_credible con_knowledgeable con_likeable con_conscientious con_friendly con_caring ///
	   (6=.) /* 6 is "don't know" */
	   
*Relative scales*	  
gen pro_more_intelligent=pro_intelligent-con_intelligent
gen pro_more_competent=pro_competent-con_competent
gen pro_more_credible=pro_credible-con_credible
gen pro_more_knowledgeable=pro_knowledgeable-con_knowledgeable
gen pro_more_likeable=pro_likeable-con_likeable
gen pro_more_conscientious=pro_conscientious-con_conscientious
gen pro_more_friendly=pro_friendly-con_friendly
gen pro_more_caring=pro_caring-con_caring


*Creating the scales for strength and warmth (The term strength is used to avoid confusion between comptence as item and overall trait)
factor pro_intelligent pro_competent pro_credible pro_knowledgeable pro_likeable pro_conscientious pro_friendly pro_caring
rotate /*factor analysis with varimax rotation clearly shows that strength-items and warmth-items load on two factors*/
factor con_intelligent con_competent con_credible con_knowledgeable con_likeable con_conscientious con_friendly con_caring
rotate /*factor analysis with varimax rotation clearly shows that strength-items and warmth-items load on two factors */

alpha pro_intelligent pro_competent pro_credible pro_knowledgeable , item gen(pro_strength_unstandardized) min(2)
gen pro_strength=(pro_strength_unstandardized-1)/4
alpha con_intelligent con_competent con_credible con_knowledgeable , item gen(con_strength_unstandardized) min(2)
gen con_strength=(con_strength_unstandardized-1)/4
gen pro_higher_strength=pro_strength-con_strength 

	gen pro_higher_strength_yes_no=.
	replace pro_higher_strength_yes_no=-1 if pro_strength<con_strength
	replace pro_higher_strength_yes_no= 0 if pro_strength==con_strength
	replace pro_higher_strength_yes_no= 1 if pro_strength>con_strength

alpha pro_likeable pro_conscientious pro_friendly pro_caring, item gen(pro_warmth_unstandardized) min(2)
gen pro_warmth=(pro_warmth_unstandardized-1)/4
alpha con_likeable con_conscientious con_friendly con_caring , item gen(con_warmth_unstandardized) min(2)
gen con_warmth=(con_warmth_unstandardized-1)/4
gen pro_higher_warmth=pro_warmth-con_warmth

	gen pro_higher_warmth_yes_no=.
	replace pro_higher_warmth_yes_no=-1 if pro_warmth<con_warmth
	replace pro_higher_warmth_yes_no= 0 if pro_warmth==con_warmth
	replace pro_higher_warmth_yes_no= 1 if pro_warmth>con_warmth


*voting 
gen voting_pro=. // voting-variables used in earlier manuscript version
	recode voting_pro (.=1.00) if q12==1 & q4_group<5 
	recode voting_pro (.=0.75) if q12==2 & q4_group<5 
	recode voting_pro (.=0.25) if q12==3 & q4_group<5 
	recode voting_pro (.=0.00) if q12==4 & q4_group<5 

	recode voting_pro (.=1.00) if q12==4 & q4_group>4 
	recode voting_pro (.=0.75) if q12==3 & q4_group>4 
	recode voting_pro (.=0.25) if q12==2 & q4_group>4 
	recode voting_pro (.=0.00) if q12==1 & q4_group>4
	
gen voting_pro_binary=. // voting-variables used in earlier manuscript version
	recode voting_pro_binary (.=1) if q12==1 & q4_group<5 
	recode voting_pro_binary (.=1) if q12==2 & q4_group<5 
	recode voting_pro_binary (.=0) if q12==3 & q4_group<5 
	recode voting_pro_binary (.=0) if q12==4 & q4_group<5 

	recode voting_pro_binary (.=1) if q12==4 & q4_group>4 
	recode voting_pro_binary (.=1) if q12==3 & q4_group>4 
	recode voting_pro_binary (.=0) if q12==2 & q4_group>4 
	recode voting_pro_binary (.=0) if q12==1 & q4_group>4 

	recode voting_pro_binary (0=1) (1=0), gen(voting_con_binary)


gen voting_pro2=. //this variable includes don't know as a middle category as requested by Reviewer 2

	recode voting_pro2 (.=0.50) if q12==5 /*this line sets don't know's at middle*/

	recode voting_pro2 (.=1.00) if q12==1 & q4_group<5 
	recode voting_pro2 (.=0.75) if q12==2 & q4_group<5 
	recode voting_pro2 (.=0.25) if q12==3 & q4_group<5 
	recode voting_pro2 (.=0.00) if q12==4 & q4_group<5 

	recode voting_pro2 (.=1.00) if q12==4 & q4_group>4 
	recode voting_pro2 (.=0.75) if q12==3 & q4_group>4 
	recode voting_pro2 (.=0.25) if q12==2 & q4_group>4 
	recode voting_pro2 (.=0.00) if q12==1 & q4_group>4 


*GMO attitude
recode q13 (8=.), gen(GM_positive_unstandardized)
label values GM_positive_unstandardized GM_attitude
gen GM_positive=(GM_positive_unstandardized-4)/3
gen GM_opposition_binary=.
recode GM_opposition_binary (.=1) if GM_positive<0
recode GM_opposition_binary (.=0) if GM_positive==0
recode GM_opposition_binary (.=0) if GM_positive>0


recode q13 (8=4), gen(GM_positive_unstandardized2) //this variable includes don't know as a middle category as requested by Reviewer 2
	label values GM_positive_unstandardized2 GM_attitude
	gen GM_positive2=(GM_positive_unstandardized2-4)/3
	gen GM_opposition_binary2=.
	gen GM_attitude=abs(GM_positive2)
	recode GM_opposition_binary2 (.=1) if GM_positive2<0
	recode GM_opposition_binary2 (.=0) if GM_positive2==0
	recode GM_opposition_binary2 (.=0) if GM_positive2>0

*recall of politicans' use of numbers
gen recall_numberuse=0

recode recall_numberuse (0=.) if q14==.

recode recall_numberuse (0=1) if q14==1 & q4_group==2
recode recall_numberuse (0=1) if q14==1 & q4_group==7

recode recall_numberuse (0=1) if q14==2 & q4_group==3
recode recall_numberuse (0=1) if q14==2 & q4_group==6

recode recall_numberuse (0=1) if q14==3 & q4_group==4
recode recall_numberuse (0=1) if q14==3 & q4_group==8

recode recall_numberuse (0=1) if q14==4 & q4_group==1
recode recall_numberuse (0=1) if q14==4 & q4_group==5

*recall of correct "number"
gen correct_recall=0
recode correct_recall (0=.) if q15a==. & q15b==. & q15c==1

recode correct_recall (0=1) if q15a==2 & q4_group==2
recode correct_recall (0=1) if q15a==2 & q4_group==4
recode correct_recall (0=1) if q15a==3 & q4_group==7

recode correct_recall (0=1) if q15b==3 & q4_group==3
recode correct_recall (0=1) if q15b==2 & q4_group==6
recode correct_recall (0=1) if q15b==2 & q4_group==8

recode correct_recall (0=1) if q15c==6 & q4_group==1
recode correct_recall (0=1) if q15c==3 & q4_group==5


*Completion time, entire survey
gen survey_second= (DataCollection_FinishTime-DataCollection_StartTime)/1000
gen survey_second_log=ln(survey_second)

*Completion time, questions on intelligence (first question after stimuli)*
gen intelligence_second=q4_response_second
gen intelligence_second_log=ln(intelligence_second)
egen float intelligence_second_cut = cut(intelligence_second), group(4)
egen float intelligence_second_cut2 = cut(intelligence_second), group(2)
egen float intelligence_second_cut3 = cut(intelligence_second), group(3)
egen float intelligence_second_cut5 = cut(intelligence_second), group(5)
egen float intelligence_second_cut10 = cut(intelligence_second), group(10)


*********************************
***dropping obsolete variables***
*********************************
drop Respondent_Serial q1 q2 q3 q4_1_resp q4_2_resp q5_1_resp q5_2_resp q6_1_resp q6_2_resp ///
     q7_1_resp q7_2_resp q8_1_resp q9_2_resp  q10_1_resp q10_2_resp q11_1_resp q11_2_resp q12 q13
	 
***************************************	 
***Dropping respondents without principle DV's***	 
***************************************
drop if pro_strength==.
drop if con_strength==.
drop if pro_warmth==.
drop if con_warmth==.

	
***Exporting as CSV-file***
outsheet using "C:\Numbers_as_competence\numbers_as_competence_for_R.csv", comma replace
	
***********************************************************************************************************************************************
***Analysis************************************************************************************************************************************
***********************************************************************************************************************************************

*********************************
***Description of participants***
*********************************

tab female
sum Alder, detail
tab college
sum rightwing, detail


*******************************************
***effects on perceptions of politicians***
*******************************************

***Strength***
anova pro_higher_strength i.condition  

reg pro_strength i.condition
eststo pro_strength, refresh
margins, over(condition) pwcompare(effects)
margins, over(condition)

reg con_strength i.condition
eststo con_strength, refresh
margins, over(condition) pwcompare(effects)
margins, over(condition)

reg pro_higher_strength i.condition 
eststo pro_higher_strength, refresh 
margins, over(condition) pwcompare(effects)
margins, over(condition)

ttest pro_strength=con_strength if condition==1
ttest pro_strength=con_strength if condition==2
ttest pro_strength=con_strength if condition==3
ttest pro_strength=con_strength if condition==4

***This is table 1 in the paper***
esttab pro_strength con_strength pro_higher_strength /*using effectsonstrength.rtf*/, type r2 b(2) se(2) compress replace ///
       mtitles("Strength of Pro" "Strength of Con" "Strength differential")  ///
       note("Notes: OLS regression coefficients (and standard errors)") ///
	   refcat(1b.condition "Condition 1: No numbers", label(ref.cat.) ) ///
	   coeflabels(2.condition "Condition 2: Pro using numbers" 3.condition "Condition 3: Con using numbers" 4.condition "Condition 4: Both using numbers" _cons "Constant")  

 
*elaborating on effect sizes*  
proportion pro_higher_strength_yes_no, over(condition)


***FIGURE 1 IN THE PAPER***
estimates restore pro_strength
margins, over(condition) saving(pro_strength, replace)
estimates restore con_strength
margins , over(condition)saving(con_strength, replace) 
combomarginsplot pro_strength con_strength, bydimension(condition, elabel(1 `" "Condition 1:" "No numbers" "' ///
2 `" "Condition 2:" "Pro using numbers" "' 3 `" "Condition 3:" "Con using numbers" "' 4 `" "Condition 4:" "Both using numbers" "')) plotopts(barwidth(0.7)) recast(bar) ///
				 byopts(rows(1)) ylabel(0(0.1)0.7, gmin grid) xlabel(1 "Pro" 2 "Con") scheme(s1mono)  ///
				 xtitle("") ytitle("Competence") 
		 

				 
***Warmth***

anova pro_higher_warmth i.condition 

reg pro_warmth i.condition
eststo pro_warmth, refresh
margins, over(condition) pwcompare(effects)
margins, over(condition)

reg con_warmth i.condition
eststo con_warmth, refresh
margins, over(condition) pwcompare(effects)
margins, over(condition) 

reg pro_higher_warmth i.condition
eststo pro_higher_warmth, refresh
margins, over(condition) pwcompare(effects)
margins, over(condition)

ttest pro_warmth=con_warmth if condition==1
ttest pro_warmth=con_warmth if condition==2
ttest pro_warmth=con_warmth if condition==3
ttest pro_warmth=con_warmth if condition==4

***This is table 2 in the paper***
esttab pro_warmth con_warmth pro_higher_warmth /*using effectsonwarmth.rtf*/, type r2 b(2) se(2) compress replace ///
       mtitles("Warmth of Pro" "Warmth of Con" "Warmth differential")  ///
       note("Notes: OLS regression coefficients (and standard errors)") ///
	   refcat(1b.condition "Condition 1: No numbers", label(ref.cat.) ) ///
	   coeflabels(2.condition "Condition 2: Pro using numbers" 3.condition "Condition 3: Con using numbers" 4.condition "Condition 4: Both using numbers" _cons "Constant")  


***FIGURE 2 IN THE PAPER***
estimates restore pro_warmth
margins, over(condition) saving(pro_warmth, replace)
estimates restore con_warmth
margins, over(condition) saving(con_warmth, replace) 
combomarginsplot pro_warmth con_warmth, bydimension(condition, elabel(1 `" "Condition 1:" "No numbers" "' ///
2 `" "Condition 2:" "Pro using numbers" "' 3 `" "Condition 3:" "Con using numbers" "' 4 `" "Condition 4:" "Both using numbers" "')) plotopts(barwidth(0.7)) recast(bar) ///
				 byopts(rows(1)) ylabel(0(0.1)0.7, gmin grid) xlabel(1 "Pro" 2 "Con") scheme(s1mono)  ///
				 xtitle("") ytitle("Warmth")


**************************************** 
***Effects on attitude toward GM food***
****************************************

***Original analysis, without "don't knows"***
	anova GM_positive i.condition //no effect

	tab GM_positive condition, col

	reg GM_positive i.condition
	eststo GM_positive, refresh
	margins, over(condition) pwcompare(effects)
	margins, over(condition)
	*marginsplot, bydimension(condition, elabel(1 `" "Condition 1:" "No numbers" "' /// //This plot is not used in the paper
	*             2 `" "Condition 2:" "Pro using numbers" "' 3 `" "Condition 3:" "Con using numbers" "' 4 `" "Condition 4:" "Both using numbers" "')) plotopts(barwidth(0.4)) recast(bar) ///
	*			 byopts(rows(1)) ylabel(-.4(0.1)0.4, gmin grid) scheme(s1mono)  ///
	*			 xtitle("") ytitle("Attitude on GM food")  yline(0, lwidth(thick) lcolor(gs14) extend)

	reg GM_positive_unstandardized i.condition
	eststo GM_positive_unstandardized, refresh
	margins, over(condition) pwcompare(effects)
	margins, over(condition)
	*marginsplot, bydimension(condition, elabel(1 `" "Condition 1:" "No numbers" "' /// //This plot is not used in the paper
	*             2 `" "Condition 2:" "Pro using numbers" "' 3 `" "Condition 3:" "Con using numbers" "' 4 `" "Condition 4:" "Both using numbers" "')) plotopts(barwidth(0.4)) recast(bar) ///
	*			 byopts(rows(1))  scheme(s1mono)  ///
	*			 xtitle("") title("") ytitle("")   ///
	*			 ylabel(1 "Very strongly opposed" 2 "Strongly opposed" 3 "Opposed" 4 "Neither opposed nor in favor" ///
	 *            5 "In favor" 6 "Strongly in favor" 7 "Very strongly in favor", angle(horizontal) labsize(small) grid gmin gmax) 

	esttab GM_positive /*using effectsonGM.rtf*/, type r2 b(2) se(2) compress replace ///
		   mtitles("GM attitude")  ///
		   note("Notes: OLS regression coefficients (and standard errors)") ///
		   refcat(1b.condition "Condition 1: No numbers", label(ref.cat.) ) ///
		   coeflabels(2.condition "Condition 2: Pro using numbers" 3.condition "Condition 3: Con using numbers" 4.condition "Condition 4: Both using numbers" _cons "Constant")  

***Including Don't Knows, as requested by reviewer 2***
anova GM_positive2 i.condition //no effect

tab GM_positive2 condition, col

reg GM_positive2 i.condition
eststo GM_positive2, refresh
margins, over(condition) pwcompare(effects)
margins, over(condition)
*marginsplot, bydimension(condition, elabel(1 `" "Condition 1:" "No numbers" "' /// //This plot is not used in the paper
*             2 `" "Condition 2:" "Pro using numbers" "' 3 `" "Condition 3:" "Con using numbers" "' 4 `" "Condition 4:" "Both using numbers" "')) plotopts(barwidth(0.4)) recast(bar) ///
*			 byopts(rows(1)) ylabel(-.4(0.1)0.4, gmin grid) scheme(s1mono)  ///
*			 xtitle("") ytitle("Attitude on GM food")  yline(0, lwidth(thick) lcolor(gs14) extend)

reg GM_positive_unstandardized2 i.condition
eststo GM_positive_unstandardized2, refresh
margins, over(condition) pwcompare(effects)
margins, over(condition)

***FIGURE 3 IN THE PAPER***
marginsplot, bydimension(condition, elabel(1 `" "Condition 1:" "No numbers" "' ///
             2 `" "Condition 2:" "Pro using numbers" "' 3 `" "Condition 3:" "Con using numbers" "' 4 `" "Condition 4:" "Both using numbers" "'))  ///
			 recast(scatter) plotopts(msize(vlarge)) byopts(rows(1))  scheme(s1mono)  ///
			 xtitle("") title("") ytitle("")   ///
			 ylabel(1 `" "Very strongly" "opposed" "' 2 "Strongly opposed" 3 "Opposed" 4 `" "Neither opposed" "nor in favor" "' ///
             5 "In favor" 6 "Strongly in favor" 7 `" "Very strongly" "in favor" "', angle(stdarrow) labsize(small) grid gmin gmax) 
	
***This is table 3 in the paper***
esttab GM_positive2 /*using effectsonGM.rtf*/, type r2 b(2) se(2) compress replace ///
       mtitles("GM attitude")  ///
       note("Notes: OLS regression coefficients (and standard errors)") ///
	   refcat(1b.condition "Condition 1: No numbers", label(ref.cat.) ) ///
	   coeflabels(2.condition "Condition 2: Pro using numbers" 3.condition "Condition 3: Con using numbers" 4.condition "Condition 4: Both using numbers" _cons "Constant")  
				 

	
*********************************
***effects on voting intention***
*********************************

	//These are analyses conducted with previous version of voting-variable
	kwallis voting_pro, by(condition)
	
	ologit voting_pro i.condition 
	oparallel /*these tests does not indicate that the parallel regression assumption is violated, and ologit is therefore justified*/
	eststo voting_pro, refresh

	margins, predict(outcome(0)   ) by(condition) saving(def_con, replace) 
	margins, predict(outcome(0)   ) by(condition) pwcompare(effects) 

	margins, predict(outcome(0.25)) by(condition) saving(prop_con, replace) 
	margins, predict(outcome(0.25)) by(condition) pwcompare(effects)  

	margins, predict(outcome(.75) ) by(condition) saving(prop_pro, replace) 
	margins, predict(outcome(.75) ) by(condition) pwcompare(effects)

	margins, predict(outcome(1)   ) by(condition) saving(def_pro, replace) 
	margins, predict(outcome(1)   ) by(condition) pwcompare(effects)
	
***This is model 9 in table 4 in the paper***
	esttab voting_pro /*using effectsonvoting.rtf*/, type pr2 b(2) se(2) compress replace /*stardetach*/ ///
		   mtitles("Voting for Pro")  ///
		   note("Notes: Ordered logistic regression coefficients (and standard errors)") ///
		   refcat(1b.condition "Condition 1: No numbers", label(ref.cat.) ) ///
		   coeflabels(2.condition "Condition 2: Pro using numbers" 3.condition "Condition 3: Con using numbers" 4.condition "Condition 4: Both using numbers" )

	***treating the DV as binary
	proportion voting_pro_binary, over(condition)
	tab voting_pro_binary condition, chi col
	logit voting_pro_binary i.condition 
	margins, over(condition) saving(pro_voting, replace)
	logit voting_con_binary i.condition 
	margins, over(condition) saving(con_voting, replace)
*	combomarginsplot pro_voting con_voting, bydimension(condition, elabel(1 `" "Condition 1:" "No numbers" "' ///
*	2 `" "Condition 2:" "Pro using numbers" "' 3 `" "Condition 3:" "Con using numbers" "' 4 `" "Condition 4:" "Both using numbers" "')) plotopts(barwidth(0.7)) recast(bar) ///
*			 byopts(rows(1)) ylabel(0(0.1)1, gmin grid) xlabel(1 "Pro" 2 "Con") scheme(s1mono)  ///
*			 xtitle("") ytitle("Voting")
*	catplot voting_pro_binary, asyvars fraction(condition) by(condition, rows(1) note("") legend(pos(3)  ) )  ///
*						 stack recast(bar) ylabel(0(0.1)1, gmin grid)  blabel(bar, position(inside) format(%3.2f)) ytitle("") legend(col(1) ) 
*	logit voting_pro_binary pro_higher_strength 
*	margins, at(pro_higher_strength=(-.3092707(.3092707).3092707))	 

	***analyzing the DV with OLS
	reg voting_pro i.condition //effect is significant
	
	
***Final analysis: including "don't know" as middle category in the DV as requested by reviewer 2
anova voting_pro2 i.condition //effect is significant
reg voting_pro2 i.condition
eststo voting_pro2, refresh
margins, over(condition) pwcompare(effects)
margins, over(condition) 

***FIGURE 4 IN THE PAPER***
marginsplot, bydimension(condition, elabel(1 `" "Condition 1:" "No numbers" "' 2 `" "Condition 2:" "Pro using numbers" "' 3 `" "Condition 3:" "Con using numbers" "' 4 `" "Condition 4:" "Both using numbers" "')) ///
			 recast(scatter) plotopts(msize(vlarge))scheme(s1mono) ///
			 byopts(rows(1))  yscale(range(0.4 0.6))  ///
			 xtitle("") title("") ytitle("Electoral support for 'Pro'")  

***This is model 8 in table 4 in the paper***
esttab voting_pro2 /*using effectsonvoting2.rtf*/, type r2 b(2) se(2) compress replace  ///
		   mtitles("Voting for Pro")  ///
		   note("Notes: OLS coefficients (and standard errors)") ///
		   refcat(1b.condition "Condition 1: No numbers", label(ref.cat.) ) ///
		   coeflabels(2.condition "Condition 2: Pro using numbers" 3.condition "Condition 3: Con using numbers" 4.condition "Condition 4: Both using numbers" )  

		   
************
***Recall***
************

*recall of use of numbers*
tabstat recall_numberuse, by(condition)
tab q14 q4_group, missing col
tab recall_numberuse condition, col
proportion recall_numberuse

*recall of correct number*
tabstat correct_recall, by(condition)
tab correct_recall q4_group, missing
proportion correct_recall if condition!=1

*Looking into the poor recall*
logit recall_numberuse intelligence_second_log //speeding correlates with negatively with recall
  proportion recall_numberuse, over(intelligence_second_cut)
  proportion recall_numberuse, over(intelligence_second_cut10)
  
  
*********************************************************************************************************  
***Mediation (estimations done in R - these models are just for creating the tables in the manuscript)***  
*********************************************************************************************************

reg pro_higher_strength i.condition female2 age college2 rightwing2 interest2 
eststo m1
reg voting_pro2 i.condition pro_higher_strength female2 age college2 rightwing2 interest2
eststo m2
reg pro_higher_warmth i.condition  female2 age college2 rightwing2 interest2 
eststo m3
reg voting_pro2 i.condition pro_higher_warmth female2 age college2 rightwing2 interest2
eststo m4
reg GM_positive2 i.condition  female2 age college2 rightwing2 interest2 
eststo m5
reg voting_pro2 i.condition GM_positive2 female2 age college2 rightwing2 interest2
eststo m6
reg voting_pro2 i.condition pro_higher_strength pro_higher_warmth GM_positive2 female2 age college2 rightwing2 interest2
eststo m7

***This is table 5 in the paper***
esttab m1 m2 m3 m4 m5 m6 m7 using mediation.rtf, r2 b(2) se(2) compress replace ///
       mtitles("Effect on mediator" "Effect on outcome" "Effect on mediator" "Effect on outcome" "Effect on mediator" "Effect on outcome" "Effect on outcome")  ///
       note(Notes: OLS regression coefficients (and standard errors). Pretreatment variables are included in the models to make the sequential ///
	   ignorability assumption as plausible as the data permit (Imai & Yamamoto 2013)) ///
	   order(female2 age college2 rightwing2 interest2 1.condition 2.condition 3.condition 4.condition pro_higher_strength pro_higher_warmth GM_positive2) ///
	   coeflabels(female2 "Gender (female)" age "Age" college2 "Education (college)" rightwing2 "Left-Rigth self-placement" interest2 "Interest in politics" ///
	   2.condition "Condition 2: Pro using numbers" 3.condition "Condition 3: Con using numbers" 4.condition "Condition 4: Both using numbers" ///
	   pro_higher_strength "Competence" pro_higher_warmth "Warmth" GM_positive2 "GM-attitude (positive)"_cons "Constant")  ///
	   refcat(1.condition "Condition 1: No numbers", label(ref.cat.) ) 
eststo clear	   

***Moderated mediation
reg pro_higher_strength i.condition##c.GM_attitude female2 age college2 rightwing2 interest2 
eststo mo1
	margins, dydx(condition) at(GM_attitude=(0 1))
	margins, dydx(condition) at(GM_attitude=(0 1)) pwcompare(effects)
	
reg voting_pro2 i.condition##c.GM_attitude pro_higher_strength c.pro_higher_strength#c.GM_attitude female2 age college2 rightwing2 interest2
eststo mo2 
	margins, dydx(condition) at(GM_attitude=(0 1))
	margins, dydx(condition) at(GM_attitude=(0 1)) pwcompare(effects)


***This is table 7 in the paper***
esttab mo1 mo2 using mmoderatedmediation.rtf, type r2 b(2) se(2) compress replace  ///
       mtitles("Effect on mediator" "Effect on outcome")  ///
       note(Notes: OLS regression coefficients (and standard errors). Pretreatment variables are included in the models to make the sequential ///
	   ignorability assumption as plausible as the data permit (Imai & Yamamoto 2013)) ///
	   order(female2 age college2 rightwing2 interest2 1.condition 2.condition 3.condition 4.condition GM_attitude 1.condition#c.GM_attitude ///
	   1.condition#c.GM_attitude 2.condition#c.GM_attitude 3.condition#c.GM_attitude 4.condition#c.GM_attitude pro_higher_strength) ///
	   coeflabels(female2 "Gender (female)" college2 "Education (college)" rightwing2 "Left-Right self-placement" interest2 "Interest in politics" ///
	   1.condition "Condition 1: No numbers" 2.condition "Condition 2: Pro using numbers" 3.condition "Condition 3: Con using numbers" 4.condition "Condition 4: Both using numbers" ///
	   pro_higher_strength "Competence" GM_attitude "GM-attitude (folded scale)"_cons "Constant" ///
	   1.condition#c.GM_attitude "Condition 1: No numbers X GM-attitude (folded scale)" 2.condition#c.GM_attitude "Condition 2: Pro using numbers X GM-attitude (folded scale)"  ///
	   3.condition#c.GM_attitude "Condition 3: Con using numbers X GM-attitude (folded scale)" 4.condition#c.GM_attitude "Condition 4: Both using numbers X GM-attitude (folded scale)" ///
	   c.pro_higher_strength#c.GM_attitude "Competence X GM-attitude (folded scale)" )
eststo clear

*************************************************
***End of File***********************************
*************************************************


