*******************************************************************************
*** Description: 	This document provides the code for preparing the 		***
***					Argentina 2017 Legislative Election Survey data		 	***
***					for use in the replication of "Compulsory Voting 		***
***					and PartiesÕ Vote Seeking Strategies," which is 		***
***					authored by Shane P. Singh and appears in the American 	***
***					Journal of Political Science. 							***			
*******************************************************************************

**************
**************
*Set the Version                                                                                                                         
**************
**************
version 13.1




**************
**************
*Import the Data From the TSV File Downloaded from Qualtrics, Which Was Used to Conduct the Survey in Argentina.                                                                                                                       
**************
**************
import delimited "Argentina+2017+Legislative+Election+Survey.tsv"



**************
**************
*Relabel Unique Identifier
**************
**************
label var responseid "respondent identifier"



**************
**************
*Create Birthdate Variable Using %TD Format
**************
**************
gen birth_date = date(birth_date_1, "DMY")
label var birth_date "date of birth, in days since 01jan1960"


**************
**************
*Create Birthdate Variable Using DD/MM/YYYY Format
**************
**************
rename birth_date_1 birth_date_DD_MM_YYYY
label var birth_date_DD_MM_YYYY "date of birth, DD/MM/YYYY"


**************
**************
*Create Election Date Variable in %TD Format
**************
**************
gen election_date_temp = "22/10/2017"
gen election_date = date(election_date_temp, "DMY")
label var election_date "date of October 22, 2017 election, in days, since 01jan1960"
drop election_date_temp


**************
**************
*Create Days from Birth to Election Variable
**************
**************
gen days_old_election = election_date - birth_date
label var days_old_election "Age in days on October 22, 2017"


**************
**************
*Create Days from Age 18 on Election Day Variable
**************
**************
gen days_from_18_election =  days_old_election - 6575 //*According to https://www.timeanddate.com/date/duration.html, there were 6575 days between October 22, 1999  and October 22, 2017. Thus, those who turned 18 on election day were 6575 days old. Verfieid at: http://www.thecalculatorsite.com/misc/days-between-dates.php. 
label var days_from_18_election "Days past age 18 on October 22, 2017"


**************
**************
*Create Age Cutoff for Compulsory Voting Variable
**************
**************
gen CV_birth_date = .
replace CV_birth_date = 1 if days_from_18_election >= 0 
replace CV_birth_date = 0 if days_from_18_election<0
replace CV_birth_date = . if days_from_18_election == . 
replace CV_birth_date = . if days_from_18_election > 730 //*exclude respondents older than 19 on election day.
replace CV_birth_date = . if days_from_18_election < -730 //*exclude respondents younger than 16 on election day.
label var CV_birth_date "respondent was 18 or 19 years old on election day, as defined by reported birth date"


**************
**************
*Create Indicator for Number of Items Selected in Vote Buying List Experiment
**************
**************
gen list_count = .
replace list_count = listexpcontrol_a if listexpcontrol_b == . & listexpturnout == . & listexppositiv == . & listexpnegativ == . //
replace list_count = listexpcontrol_b if listexpcontrol_a == . & listexpturnout == . & listexppositiv == . & listexpnegativ == . //*There are two control groups by design. This is a simple way to inflate the number of individuals assigned to the control within Qualtrics.
replace list_count = listexpturnout if listexpcontrol_a == . & listexpcontrol_b == . & listexppositiv == . & listexpnegativ == . 
replace list_count = listexppositiv if listexpcontrol_a == . & listexpcontrol_b == . & listexpturnout == . & listexpnegativ == . 
replace list_count = listexpnegativ if listexpcontrol_a == . & listexpcontrol_b == . & listexpturnout == . & listexppositiv == . 
replace list_count = . if list_count == 99
label var list_count "number of items selected in vote buying list experiment"


**************
**************
*Create Indicators for the Control and Three Treatment Groups
**************
**************
gen list_exp_control = .
replace list_exp_control = 1 if listexpcontrol_a ~= . | listexpcontrol_b ~= . 
replace list_exp_control = 0 if listexpturnout ~= . | listexppositiv ~= . | listexpnegativ ~= . 
label var list_exp_control "respondent was in control group for list experiment"

gen list_exp_turnout = .
replace list_exp_turnout = 1 if listexpturnout ~= . 
replace list_exp_turnout = 0 if listexpcontrol_a ~= . | listexpcontrol_b ~= .
label var list_exp_turnout "respondent was in turnout buying group for list experiment"

gen list_exp_positive = .
replace list_exp_positive = 1 if listexppositiv ~= . 
replace list_exp_positive = 0 if listexpcontrol_a ~= . | listexpcontrol_b ~= . 
label var list_exp_positive "respondent was in positive vote buying group for list experiment"

gen list_exp_negative = .
replace list_exp_negative = 1 if listexpnegativ ~= . 
replace list_exp_negative = 0 if listexpcontrol_a ~= . | listexpcontrol_b ~= . 
label var list_exp_negative "respondent was in negative vote buying group for list experiment"


**************
**************
*Create Indicator or Valid, Blank, or Null (Spoiled) Voting
**************
**************
replace voted_blank_null = 0 if voted_blank_null == 2
replace voted_blank_null = 1 if voted_blank_null == 1
replace voted_blank_null = 1 if voted_blank_null == 3
replace voted_blank_null = 1 if voted_blank_null == 4
replace voted_blank_null = . if voted_blank_null == 99
label var voted_blank_null "1 if voted for candidate OR cast blank or null/spoiled ballot; 0 otherwise"
rename voted_blank_null valid_blank_or_null_vote

**************
**************
*Recode Education Variable
**************
**************
replace educ = . if educ == 99
label var educ "level of education, from none (1) to postgrad (10)"


**************
**************
*Recode Gender (Female) Variable
**************
**************
rename sex female
replace female = . if female == 99
label var female "1 if female; 0 if male"


**************
**************
*Recode Income Variable
**************
**************
replace income = . if income == 99
label var income "level of income, from none (1) to over 31k pesos/month"



**************
**************
*Drop Respondents the Failed or Skipped Attention Check
**************
**************
drop if filter_quality~=5



**************
************** 
*Drop Variables Not Used in the Analyses and Reorder Them
**************
************** 
drop listexpcontrol_a listexpcontrol_b listexpturnout listexppositiv listexpnegativ filter_quality birth_date election_date birth_date_DD_MM_YYYY




**************
************** 
*Save the Data
**************
**************  
save "Arg2017_AJPS_Replication.dta", replace







	
