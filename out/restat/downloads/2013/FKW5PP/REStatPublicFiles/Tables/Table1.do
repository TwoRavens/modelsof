cd C:\DataFiles\Research-Papers\Immigration\Kato\REStatPublicFiles\Tables
*Rename directory according to own folder name.
clear
set more off
capture log close
log using Table1.log, text replace

set mem 500m
set matsize 3000

/*************************************************************************
Takao Kato & Chad Sparber
"Quotas and Quality: The Effect of H-1B Visa Restrictions 
   on the Pool of Prospective Undergraduate Students from Abroad"

Stata do-file for Table 1
This file summarizes SAT score by Type and Tier of school.

SAT Data Acquisition and Defined Binding Dates available in:
C:\DataFiles\Research-Papers\Immigration\Kato\REStatPublicFiles\CleanedSAT

Drop unranked schools 
*******************************************************************************/





/*************************************
Research Universities
*************************************/
use C:\DataFiles\Research-Papers\Immigration\Kato\REStatPublicFiles\CleanedSAT\CleanSAT.dta, clear
keep if type=="Research"
drop if gentier==4
sum sat if tier=="Top_25"
sum sat if tier=="Top_50" 
sum sat if tier=="Top_100" 
sum sat if tier=="Other_Tier_1"
sum sat if tier=="Tier_3"
sum sat if tier=="Tier_4"





/*************************************
Liberal Arts Schools
*************************************/
use C:\DataFiles\Research-Papers\Immigration\Kato\REStatPublicFiles\CleanedSAT\CleanSAT.dta, clear
keep if type=="LiberalArts"
drop if gentier==4
sum sat if tier=="Top_10" | tier=="Top_25"
sum sat if tier=="Top_50" 
sum sat if tier=="Top_100" 
sum sat if tier=="Other_Tier_1"
sum sat if tier=="Tier_3"
sum sat if tier=="Tier_4"





/*************************************
Masters Granting Universities
*************************************/
use C:\DataFiles\Research-Papers\Immigration\Kato\REStatPublicFiles\CleanedSAT\CleanSAT.dta, clear
keep if type=="Masters"
drop if gentier==4
sum sat if tier=="Top_10" 
sum sat if tier=="Top_25" 
sum sat if tier=="Other_Tier_1"
sum sat if tier=="Tier_3"
sum sat if tier=="Tier_4"





/*************************************
Baccalaureate Colleges
*************************************/
use C:\DataFiles\Research-Papers\Immigration\Kato\REStatPublicFiles\CleanedSAT\CleanSAT.dta, clear
keep if type=="Baccalaureate"
drop if gentier==4
sum sat if tier=="Top_10" 
sum sat if tier=="Top_25" 
sum sat if tier=="Other_Tier_1"
sum sat if tier=="Tier_3"
sum sat if tier=="Tier_4"























capture log close

exit

