
********************************************************************************************************
*THIS DO-FILE REPLICATES APPENDIX TABLE 4 IN:                                                  			   
* PATRICIA FUNK: 							                       	
* "HOW ACCURATE ARE SURVEYED PREFERENCES FOR PUBLIC POLICIES? EVIDENCE FROM
* A UNIQUE INSTITUTIONAL SETUP"                                                                                         
********************************************************************************************************

global data ="[your path]"


clear all
set more off
set matsize 2000


use "$data\VOX_prepared", clear 


preserve

#delimit;
collapse survey_bias  cooprate revrate Pro_Integration  Pro_Immigration Contra_Immigration Contra_Military   
Pro_Environmenta Contra_Nuclear  Budget_Balance  Direct_Democracy  Pro_Health_Liberal Contra_Health_Liberal  Pro_Redistribution Pro_Retirement_Age  Contra_Retirement_Age Pro_Gender Pro_Liberal, by(votenr); 

#delimit cr
 
sum survey_bias  cooprate revrate if Pro_Integration==1
sum survey_bias  cooprate revrate if  Pro_Immigration==1
sum survey_bias  cooprate revrate if  Contra_Immigration==1
sum survey_bias  cooprate revrate if  Contra_Military==1
sum survey_bias  cooprate revrate if  Pro_Environment==1
sum survey_bias  cooprate revrate if  Contra_Nuclear==1
sum survey_bias  cooprate revrate if   Budget_Balance==1
sum survey_bias  cooprate revrate if  Direct_Democracy==1
sum survey_bias  cooprate revrate if   Pro_Health_Liberal==1
sum survey_bias  cooprate revrate if  Contra_Health_Liberal==1
sum survey_bias  cooprate revrate if Pro_Redistribution==1
sum survey_bias  cooprate revrate if  Pro_Retirement_Age==1
sum survey_bias  cooprate revrate if   Contra_Retirement_Age==1
sum survey_bias  cooprate revrate if  Pro_Gender==1
sum survey_bias  cooprate revrate if  Pro_Liberal==1


restore


