********************************************************************************

********************************************************************************
**THIS DO-FILE PREPARES THE DATA FROM THE UGANDA WOMEN'S INCOME GENERATING SUPPORT IMPACT EVALUATION SURVEY FOR COMBINATION INTO THE MASTER DATASET
**Small Firm Death in Developing Countries
**November 21, 2017
**David McKenzie (dmckenzie@worldbank.org) and Anna Luisa Paffhausen (apaffhausen@worldbank.org)
**The analysis was performed with Stata, version 14.2

*Notes:
* The underlying raw data needed to replicate this do-file is available at Harvard Dataverse.
* To replicate this do-file:
* 1) Go to https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi%3A10.7910/DVN/QA0R1O
* 2) Download the folder Data.zip
* 3) Change the directory in the do-file 
* 4) Change the paths to the data you are using and for saving the datasets that are created in this do-file
*    Make sure the final dataset (UGWINGSfc) is saved in the folder “Do-files and readme/Construction of Dataset/Data for combination”

********************************************************************************

********************************************************************************
clear all
*TO DO: change directory 
/*EXAMPLE:
cd  "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data"
*/
set more off

********************************************************************************

clear
*TO DO: change path to where you saved the following file "raw_WINGS.dta"
/*EXAMPLE:
use partid sample_p1 sample_p2 new_sample_p2 replaced_p1 dropped_p1 replaced_p2 replaced_whom replaced_by_whom ///
	assigned_p1 assigned_p1_gd assigned_p2_Wplus assigned_p2_fu0 assigned_p2_fu2 assigned_p2_fu5 assigned_p2_fu_any ///
	died ///
	fu_fudate fu_q1ofactivebusinesses fu_business1 fu_business2 fu_business3 fu_business4 fu_q3 fu_q4 fu_q4below16 fu_q5 fu_q5below16 fu_q6 fu_q7 fu_q12a fu_q12b1 ///
	biztype1 biztype2 biztype ///
	fu_assignment treated_p1 treated_p1_gd treated_p2 treated_p2_Wplus treated_p2_fu0 treated_p2_fu2 treated_p2_fu5 treated_p2_fu_any ///
	partner_bas age_bas female_bas edu_bas ///
	hhsize_bas ///
	date_bas month_bas day_bas year_bas ///
	actnb_bas ///
	comp_bas govt_bas ///
	date_p1e month_p1e day_p1e year_p1e ///
	partner_p1e ///
	actnb_p1e ///
	consagg_p1e consaggpercap2_p1e consfoodpercap2_p1e consalcoholpercap2_p1e consnonfoodpercap2_p1e conseducpercap2_p1e conscomfortpercap2_p1e ///
	found_p1e ///
	hh_children1_p1e hh_children2_p1e ///
	comp_p1e compcash4w_p1e compprofit4w_p1e ///
	govt_p1e govt4w_p1e govtcash4w_p1e govtprofit4w_p1e ///
	bizstart_p1e bizop_p1e biznow_p1e ///
	found_p2e ///
	partner_p2e ///
	comp_p2e compcash4w_p2e compprofit4w_p2e ///
	govt_p2e govtcash4w_p2e govtprofit4w_p2e ///
	bizstart_p2e bizop_p2e biznow_p2e ///
	bizhours_p2e ///
	date_p2e month_p2e day_p2e year_p2e ///
	actnb_p2e ///
	consagg_p2e consaggpercap2_p2e consfoodpercap2_p2e consalcoholpercap2_p2e consnonfoodpercap2_p2e conseducpercap2_p2e conscomfortpercap2_p2e ///
	igastart_p2e igaop_p2e igaop2_p2e igaopall_p2e ///
	_merge* ///
 using  "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/Uganda WINGS/Data/raw_WINGS.dta"
*/

******************************************************************************** 
 
*Generate an indicator for treated individuals
/*From documentation:
In October 2009, 60 communities were randomly chosen to have all of their nominated residents receive the program and cash. 
We refer to this period as Phase 1. 16 months later, the other 60 received the treatment (Phase 2).
*/

g treatstatus_1=(treated_p1==1) if treated_p1!=.
g control_1=(treated_p1==0) if treated_p1!=.
*The way I understand the experiment, by round 3 all should have been treated (either in phase 1 or phase 2, but tab treated_p1 treated_p2,m does give 8 never treated individuals and 104 missings)
*-> I code it as if all had been ever treated by round 3 
g treatstatus_2=1
g control_2=0
g treatstatus_3=1
g control_3=0

*Since the treatment was a combination of cash grant and business training, I code both variables in the same way:
g cashtreat_1=(treated_p1==1) if treated_p1!=.
g bustraining_1=(treated_p1==1) if treated_p1!=.

g cashtreat_2=1
g bustraining_2=1

g cashtreat_3=1
g bustraining_3=1

*Country
g country="Uganda"

*Baseline variables

*Age of owner (only asked at baseline)
rename age_bas ownerage

*Gender of owner
rename female_bas female

*Marital status of owner
rename partner_bas married_1
rename partner_p1e married_2
rename partner_p2e married_3


*Education of owner (only asked at baseline)
rename edu_bas educyears

*Has child under 5 (only asked in p1e)
rename hh_children1_p1e childunder5

*Has child under 5 to 15 (only asked in p1e)
/*(Note that in the other surveys we used 5 to 12 but here there is no way to 
construct it and the variable is already given for the age range 5 to 15)*/
rename hh_children2_p1e childaged5to12

********************************************************************************

*Wave 1 (Baseline)

*Worked as wage worker in last month
/*Of all the potential activities asked for in the questionnaire, I decided to code
 an individual as wageworker if he/she either worked as an employee in a company or
 had a government job or political position in the last four weeks.*/
*Not sure if having worked as a health or NGO worker also falls in this category - as for now I have not included it
g wageworker_1=(comp_bas==1 | govt_bas==1) if comp_bas!=. &  govt_bas!=.

*Survey Year
replace year_bas=2000+year_bas if year_bas<2000
g surveyyear_1=year_bas

*Local to USD exchange rate at time of survey
split date_bas, parse(" ") generate(help)
replace date_bas=help1
drop help*

g interviewdate_1=daily(date_bas,"MD20Y")

*The median interviewdate of the baseline is May 12, 2009 
/*According to oanda.com, the UGX to USD exchange rate on May 12, 2009 was 0,00045.
	(https://www.oanda.com/lang/de/currency/converter/)*/

g excrate_1=0.00045

g excratemonth_1="5-2009"


********************************************************************************

*Wave 2 (Phase 1 Endline / Midline)

*Worked as wage worker in last month
/*Of all the potential activities asked for in the questionnaire, I decided to code
 an individual as wageworker if he/she either worked as an employee in a company or
 had a government job or political position in the last four weeks.*/
g wageworker_2=(comp_p1e==1 | govt_p1e==1) if comp_p1e!=. &  govt_p1e!=.

*Labor Earnings
/*The questionnaire asks for the amount of cash earned from each activity reported, as 
well as profits. For wage work I am not sure which of the two to choose. In most cases they
are the same but there are however also zero profits reported. Since I am also not sure about
the concept of profits the respondents have for these type of activities, I use the amount of cash to 
determine labor income.*/
g laborincome_2=compcash4w_p1e if wageworker_2==1

*Attrition
g attrit_2=(_merge_Midline==1) if _merge_Midline!=.

*Owner died between survey rounds
/*Although there is a variable called "died" I cannot understand, what exactly is
 captured with this variable. There also appears to be no way to calculate this 
 variable so cases in which the owner/respondent died should be captured in attrition.*/

*Started a new firm since previous survey round
g newfirmstarted_2=(bizstart_p1e>0) if bizstart_p1e!=.

*Firm is in existence
/*The questionnaires asks first, how many small businesses have been started / tried 
to start since the last survey and then how many of these are still being operated.
I code survival=1 if at least one of those businesses is still active and zero if none.*/
g survives_2=(newfirmstarted_2==1 &  bizop_p1e>0) if newfirmstarted_2!=. 

*Household expenditure per capita
rename consaggpercap2_p1e pcexpend_2

*Local to USD exchange rate at time of survey
*The median interviewdate of the midline is December 3, 2010 
/*According to oanda.com, the UGX to USD exchange rate on December 3, 2010 was 0,00043.
	(https://www.oanda.com/lang/de/currency/converter/)*/

g excrate_2=0.00043

g excratemonth_2="12-2010"

*Survey Year
g surveyyear_2=year_p1e
	
*Age of firm
g interviewdate_2=daily(date_p1e,"MD20Y")

g timesincelastivw_2=interviewdate_2-interviewdate_1

*I calculate the maximum possible age of the firm
g agefirm_2=(timesincelastivw_2)/365

********************************************************************************
*Wave 3 (Phase 2 Endline)

*Worked as wage worker in last month
/*Of all the potential activities asked for in the questionnaire, I decided to code
 an individual as wageworker if he/she either worked as an employee in a company or
 had a government job or political position in the last four weeks.*/
g wageworker_3=(comp_p2e==1 | govt_p2e==1) if comp_p2e!=. &  govt_p2e!=.

*Labor Earnings
/*The questionnaire asks for the amount of cash earned from each activity reported, as 
well as profits. For wage work I am not sure which of the two to choose. In most cases they
are the same but there are however also zero profits reported. Since I am also not sure about
the concept of profits the respondents have for these type of activities, I use the amount of cash to 
determine labor income.*/
g laborincome_3=compcash4w_p2e if wageworker_3==1

*Attrition
g attrit_3=(_merge_Endline==1) if _merge_Endline!=. & _merge_Endline!=2

*Owner died between survey rounds
/*Although there is a variable called "died" I cannot understand, what exactly is
 captured with this variable. There also appears to be no way to calculate this 
 variable so cases in which the owner/respondent died should be captured in attrition.*/

*Started a new firm since previous survey round
g newfirmstarted_3=(bizstart_p2e>0) if bizstart_p2e!=.

*Firm is in existence
/*The questionnaires asks first, how many small businesses have been started / tried 
to start since the last survey and then how many of these are still being operated.
I code survival=1 if at least one of those businesses is still active and zero if none.*/
g survives_3=(newfirmstarted_3==1 &  bizop_p2e>0) if newfirmstarted_3!=. 

*Household expenditure per capita
rename consaggpercap2_p2e pcexpend_3

*Local to USD exchange rate at time of survey
*The median interviewdate of the midline is July 2, 2012 
/*According to oanda.com, the UGX to USD exchange rate on July 2, 2012  was 0,00040.
	(https://www.oanda.com/lang/de/currency/converter/)*/

g excrate_3=0.00040

g excratemonth_3="7-2012"

*Survey Year
g surveyyear_3=year_p2e
	
*Age of firm
g interviewdate_3=daily(date_p2e,"MD20Y")

g timesincelastivw_3=interviewdate_3-interviewdate_2

*I calculate the maximum possible age of the firm
g agefirm_3=(timesincelastivw_3)/365


rename sample_p1 sample_2
rename sample_p2 sample_3

*TO DO: decide whether you need/want to change path for saving UGWINGS
/*EXAMPLE:
save UGWINGS, replace
*/
********************************************************************************
*Prepare for combination with other datasets
********************************************************************************

*Make sure I have those 1800 phase-1 participants and 904 phase-2 participants that are referred to in the documentation

keep if sample_2==1 | sample_3==1

keep partid sample_* treatstatus_* control_* cashtreat_* bustraining_* country ownerage female married* educyears childunder5 childaged5to12 wageworker_* surveyyear_* interviewdate_* excrate_* excratemonth_* laborincome_* attrit_* newfirmstarted_* survives_* bizstart_p1e bizstart_p2e

rename ownerage ownerage_1
rename educyears educyears_1
rename childunder5 childunder5_2
rename childaged5to12 childaged5to12_2
rename survives_* survival_*

g notinthirdroundUG=(sample_3==0)

quietly: reshape long treatstatus_ control_ cashtreat_ bustraining_ ownerage_ educyears_ childunder5_ childaged5to12_ wageworker_ surveyyear_ excrate_ excratemonth_ laborincome_ married_ , i(partid) j(survey)

foreach x in treatstatus control cashtreat bustraining ownerage educyears childunder5 childaged5to12 wageworker surveyyear excrate excratemonth laborincome married{
rename `x'_ `x'
}

*Since the mean of interviewdates falls into December of 2010, I replace surveyyear=2010 for all round_2 obs.
replace surveyyear=2010 if survey==2 & surveyyear==2011

*Also, given that there are missings in surveyyear I replace them:
replace surveyyear=2009 if survey==1
replace surveyyear=2010 if survey==2
replace surveyyear=2012 if survey==3


*In order to drop observations 
g tbdropped=((attrit_2==1 & survey==2)| (attrit_3==1 & survey==3))

*Generate a "fake" hhbus-variable so I know if the observations is actually counted for survival or newfirmstart or only for attrition (and in that case I don't know if a business was even started)
g hhbus=(bizstart_p1e>0) if survey==1 &  bizstart_p1e!=.
replace hhbus=(bizstart_p2e>0) if survey==2 &  bizstart_p2e!=.

*18 months
g attrit_18mths=.
g survival_18mths=.
g newfirmstarted_18mths=.


foreach x in attrit survival newfirmstarted{
replace `x'_18mths=`x'_2 if surveyyear==2009
drop `x'_2
replace `x'_18mths=`x'_3 if surveyyear==2010
drop `x'_3
}

*Drop observations if owner attrited from the survey, or no follow-up (or baseline) given per construction
drop if tbdropped==1 | (sample_2==0 & sample_3==1 & survey==1) | (sample_3==0 & survey==3)

g wave=survey

*Generate household and owner ids
egen firmid=group(partid surveyyear) if hhbus==1

egen ownerid=group(partid) if hhbus==1

*Since we only have one firm per household
g householdid=ownerid

*Make the ids look nicer
foreach x of varlist firmid ownerid householdid{
tostring `x', format("%04.0f") replace
replace `x'="UGWINGS"+"-"+`x' if `x'!="."
}

tostring survey, replace
replace survey="BL-"+"2009" if survey=="1"
replace survey="L-"+"2010" if survey=="2" & sample_3==0
replace survey="BL-"+"2010" if survey=="2" & sample_3==1
replace survey="L-"+"2012" if survey=="3"

g lastround=(survey=="L-2010" | survey=="L-2012")

drop bizstart_p1e bizstart_p2e interviewdate_1 interviewdate_2 interviewdate_3 tbdropped


*TO DO: Make sure the final dataset "UGWINGSfc.dta" is saved in the folder “Do-files and readme/Construction of Dataset/Data for combination”
/*
save UGWINGSfc, replace
*/
