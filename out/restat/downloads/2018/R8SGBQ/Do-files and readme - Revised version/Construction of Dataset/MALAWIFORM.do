********************************************************************************

********************************************************************************
**THIS DO-FILE PREPARES THE DATA FROM THE MALAWI BUSINESS REGISTRATION IMPACT EVALUATION SURVEY FOR COMBINATION INTO THE MASTER DATASET
**Small Firm Death in Developing Countries
**November 20, 2017
**David McKenzie (dmckenzie@worldbank.org) and Anna Luisa Paffhausen (apaffhausen@worldbank.org)
**The analysis was performed with Stata, version 14.2

*Note:
* This do-file cannot be replicated as part of the underlying raw data needed to replicate this do-file is not (yet) publicly available.

********************************************************************************

********************************************************************************
clear all
cd  "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data"
set more off

********************************************************************************

********************************************************************************
*Baseline variables
********************************************************************************

********************************************************************************

use "Malawi/BRIE_control_group_finalBS.dta", clear

merge 1:1 id using "Malawi/Raw/Cleaned data/BRIE_control_group_cleanedBS.dta", force keepusing(s2q1 s2q4 s2q7 s2q13 s7q14 s7q11_spent_* s8q3 s10q7_b s10q8_b s13q1 s13q5_1 s14q5 s15q1 s15q3 s16q1e_male s16q1e_female s16q1a_elder_m s16q1a_elder_f)

*Country
g country="Malawi"

*Surveyyear
g surveyyear=2012

*Wave
g wave=1

*Treatment status
g treatstatus=0
g control=1

*Local to USD exchange rate at time of survey
*The baseline survey was done between December 2011 and April 2012, so I take February 15 as approx. midpoint
g excrate=0.00591

g excratemonth="2-2012"

********************************************************************************
*Owner and Household characteristics
********************************************************************************

*Gender of owner
*already defined

*Owner has tertiary education
g ownertertiary=(s14q5==16) if s14q5!=. & s14q5!=-9 & s14q5!=-8 & s14q5!=-7 & s14q5!=99

*Has a child under 5 in their household
egen childunder5help=rowtotal(s16q1e_male s16q1e_female),m
g childunder5=(childunder5help>0) if childunder5help!=.

*Has adult aged 65+ in the household
egen adult65andoverhelp=rowtotal(s16q1a_elder_m s16q1a_elder_f),m
g adult65andover=(adult65andoverhelp>0) if adult65andoverhelp!=.

********************************************************************************
*Firm characteristics
********************************************************************************
*Age of the firm in years
rename firm_age agefirm

*Inventories 
*Not sure why there are so many missings, since there are also obs. with s7q14==0. I leave it like that though. 
rename s7q14 inventories

*Firm is in retail trade
rename Retail retail 

*Firm is in manufacturing sector
rename Manufacturing manuf

*Firm is in service sector
rename Services services

*Detailed firm sector (ISIC 2 or 3 digit) - (but not sure if it's these are really ISIC codes)
rename s2q1 sector

*Total workers
g totalworkers=s13q1-s13q5_1
replace totalworkers=0 if totalworkers<0

*Business profits in last month
rename s10q7_b profits 

*Business sales in last month
rename s10q8_b sales

*Hours worked in self-employment in last month
*based on hours worked  in last week
g hours=s2q13*(30/7)

*Worked as wage worker in last month
g wageworker=(s15q1==4) if s15q1!=.

*Labor earnings from all labor, including the business, in last month
egen laborincome=rowtotal(profits s15q3), m

********************************************************************************
*Competition facing firm
********************************************************************************
*Number of competitors (here: in same G.N.)
rename s8q3  competition1


********************************************************************************
keep 	id ///
		country surveyyear wave treatstatus control excrate excratemonth ///
		female ownertertiary childunder5 adult65andover ///
		agefirm inventories retail manuf services sector totalworkers profits sales hours wageworker laborincome ///
		competition1 ///
		s2q7

foreach var of varlist surveyyear wave excrate excratemonth ///
				female ownertertiary childunder5 adult65andover ///
				agefirm inventories retail manuf services sector ///
				s2q7 {
rename `var' `var'1
}

save MALAWIFORM1, replace

********************************************************************************


********************************************************************************

********************************************************************************
*Panel variables
********************************************************************************

********************************************************************************
*Round 2 
use "Malawi/Raw/Cleaned data/BRIE_control_group_cleanedFU1.dta", clear
********************************************************************************

*Survival
g survival=(F_s1q1==1)

*Main activity after closing business
*Main activity after closing business
label define mainactivity 	1 "Working for a wage" ///
							2 "Looking for work" ///
							3 "Operating a different business" ///
							4 "Housework or looking after children" ///
							5 "Other"

g mainactivity=1 if F_s1q4==1 | F_s1q4==2 
replace mainactivity=3 if F_s1q4==3 | F_s1q4==4 
replace mainactivity=5 if F_s1q4==5 | F_s1q4==6 | F_s1q4==7 | F_s1q4==8 | F_s1q4==9 | F_s1q4==10 

label values mainactivity mainactivity

*New firm started since last survey
g newfirmstarted=(mainactivity==3) if mainactivity!=.

*Reason for closing business
gen reasonclosure=1 if F_s1q3==3 | F_s1q3==4 | F_s1q3==5 | F_s1q3==6 | F_s1q3==7
replace reasonclosure=2 if F_s1q3==13
replace reasonclosure=3 if F_s1q3==10
replace reasonclosure=4 if F_s1q3==2
replace reasonclosure=7 if F_s1q3==1
replace reasonclosure=8 if F_s1q3==12
replace reasonclosure=10 if F_s1q3==8
replace reasonclosure=9 if F_s1q3==9 | F_s1q3==11 | F_s1q3==96

replace reasonclosure=1 if F_s1q3_specify_for_other=="DEVALUATION OF MONEY"
replace reasonclosure=11 if F_s1q3_specify_for_other=="DESTROYED BY FIRE" | F_s1q3_specify_for_other=="BUSINESS THEFT"


label define closereason 1 "making a loss" 2 "sickness" 3 "care for family" 4 "better wage job" 5 "migrate abroad" 6 "married" 7 "shut down by govt." 8 "taken from me" 9 "other" 10 "better business opportunity" 11 "catastrophe"
label values reasonclosure closereason

*Sales in last month (somehow the variable is called "past week", but it should be month)
rename F_s9q8_past_week_profits sales
replace sales=. if sales==-9

*Profits in last month (somehow the variable is called "past week", but it should be month)
rename F_s9q7_past_week_profits profits 
replace profits=. if profits==-9

*Hours worked in self-employment in last month
*based on hours worked  in last week
g hours=F_s2q5*(30/7) 

*Total workers
g totalworkers=F_s10q1-F_s10q2_1 if F_s10q1!=-9 & F_s10q2_1!=-9

*Worked as wage worker in last month
g wageworker=(F_s1q4==1 | F_s1q4==2 | F_s11q5==4) if F_s11q5!=. | F_s1q4!=.

*Labor earnings from all labor, including the business, in last month
egen laborincome=rowtotal(F_s1q9_past_month_income F_s11q7 profit),m

*Excrate and excratemonth
g ivw_date=daily(F_de_date,"DMY")
format ivw_date %td
su ivw_date, detail
*Survey took place between November 2012 and March 2013, with 50% of interviews having been conducted by Feb. 20, 2013, so I take February 15, 2013 as approx. midpoint
g excrate=0.00274
g excratemonth="2-2013" 

*Surveyyear
g surveyyear=2013

*Wave
g wave=2 
 
keep 	id ///
		surveyyear wave ///
		excrate excratemonth ///
		profits sales hours totalworkers wageworker laborincome ///
		survival newfirmstarted mainactivity reasonclosure F_s1q3 F_s1q4

foreach var of varlist 	surveyyear wave ///
						excrate excratemonth ///
						profits sales hours totalworkers wageworker laborincome ///
						survival newfirmstarted mainactivity reasonclosure{
rename `var' `var'2
}	

save MALAWIFORM2, replace


********************************************************************************
*Round 3
use "Malawi/Raw/Cleaned data/BRIE_control_group_cleanedFU2.dta", clear
********************************************************************************
*Survival
g survival=(F2_s1q1==1)

*Main activity after closing business
*Main activity after closing business
label define mainactivity 	1 "Working for a wage" ///
							2 "Looking for work" ///
							3 "Operating a different business" ///
							4 "Housework or looking after children" ///
							5 "Other"

g mainactivity=1 if F2_s1q4==1 | F2_s1q4==2 
replace mainactivity=3 if F2_s1q4==3 | F2_s1q4==4 
replace mainactivity=5 if F2_s1q4==5 | F2_s1q4==6 | F2_s1q4==7 | F2_s1q4==8 | F2_s1q4==9 | F2_s1q4==10 | F2_s1q4==96  

label values mainactivity mainactivity

*New firm started since last survey
g newfirmstarted=(mainactivity==3) if mainactivity!=.

*Reason for closing business
gen reasonclosure=1 if F2_s1q3==3 | F2_s1q3==4 | F2_s1q3==5 | F2_s1q3==6 | F2_s1q3==7
replace reasonclosure=2 if F2_s1q3==13
replace reasonclosure=3 if F2_s1q3==10
replace reasonclosure=4 if F2_s1q3==2
replace reasonclosure=7 if F2_s1q3==1
replace reasonclosure=8 if F2_s1q3==12
replace reasonclosure=10 if F2_s1q3==8
replace reasonclosure=9 if F2_s1q3==9 | F2_s1q3==11 | F2_s1q3==96

replace reasonclosure=1 if F2_s1q3_specify_for_other=="I HAD MANY DEBT" | F2_s1q3_specify_for_other=="LITTLE PROFIT"
replace reasonclosure=2 if F2_s1q3_specify_for_other=="SICKNESS" | F2_s1q3_specify_for_other=="VERY SICK"
replace reasonclosure=3 if F2_s1q3_specify_for_other=="FAMILY MEMBER WAS ILL" | F2_s1q3_specify_for_other=="SHE WAS NURSING A NEWLY BABY"
replace reasonclosure=11 if F2_s1q3_specify_for_other=="BECAUSE OF THEFT" | F2_s1q3_specify_for_other=="GOT ROBBED" | F2_s1q3_specify_for_other=="SHOP CAUGHT FIRE" | F2_s1q3_specify_for_other=="THEFTY" | F2_s1q3_specify_for_other=="THIEFS BROKE MY SHOP" | F2_s1q3_specify_for_other=="THIEVES BROKE IN TO MY SHOP"

label define closereason 1 "making a loss" 2 "sickness" 3 "care for family" 4 "better wage job" 5 "migrate abroad" 6 "married" 7 "shut down by govt." 8 "taken from me" 9 "other" 10 "better business opportunity" 11 "catastrophe"
label values reasonclosure closereason

*Sales in last month
rename F2_s9q8_past_month_revenues sales

*Profits in last month 
rename F2_s9q7_past_month_profits profits 

*Hours worked in self-employment in last month
*based on hours worked  in last week
g hours=F2_s2q5*(30/7)  

*Total workers
g totalworkers=F2_s10q1-F2_s10q2_1 

*Worked as wage worker in last month
g wageworker=(F2_s1q4==1 | F2_s1q4==2 | F2_s11q5==4) if F2_s11q5!=. | F2_s1q4!=.

*Labor earnings from all labor, including the business, in last month
egen laborincome=rowtotal(F2_s1q9_past_month_income F2_s11q7 profit),m

*Excrate and excratemonth
su F2_dedate, detail
*Survey took place between Oct. 2013 and May 2014, with 50% of interviews having been conducted by Dec. 4, 2013, so I take Dec. 15, 2013 as approx. midpoint
g excrate=0.00235
g excratemonth="12-2013" 

*Surveyyear
g surveyyear=2013

*Wave
g wave=3 
 
keep 	id ///
		surveyyear wave ///
		excrate excratemonth ///
		profits sales hours totalworkers wageworker laborincome ///
		survival newfirmstarted mainactivity reasonclosure F2_s1q3 F2_s1q4

foreach var of varlist 	surveyyear wave ///
						excrate excratemonth ///
						profits sales hours totalworkers wageworker laborincome ///
						survival newfirmstarted mainactivity reasonclosure{
rename `var' `var'3
}	

save MALAWIFORM3, replace


********************************************************************************
*Round 4
use "Malawi/Raw/Cleaned data/BRIE_control_group_cleanedFU3.dta", clear
********************************************************************************
*Survival
g survival=(F3_s1q1==1)

*Main activity after closing business
*Main activity after closing business
label define mainactivity 	1 "Working for a wage" ///
							2 "Looking for work" ///
							3 "Operating a different business" ///
							4 "Housework or looking after children" ///
							5 "Other"

g mainactivity=1 if F3_s1q6==1 | F3_s1q6==2 
replace mainactivity=3 if F3_s1q6==3 | F3_s1q6==4 
replace mainactivity=5 if F3_s1q6==5 | F3_s1q6==6 | F3_s1q6==7 | F3_s1q6==8 | F3_s1q6==9 | F3_s1q6==10 | F3_s1q6==96  

label values mainactivity mainactivity

*New firm started since last survey
g newfirmstarted=(mainactivity==3) if mainactivity!=.

*Reason for closing business
gen reasonclosure=1 if F3_s1q3==3 | F3_s1q3==4 | F3_s1q3==5 | F3_s1q3==6 | F3_s1q3==7
replace reasonclosure=2 if F3_s1q3==13
replace reasonclosure=3 if F3_s1q3==10
replace reasonclosure=4 if F3_s1q3==2
replace reasonclosure=7 if F3_s1q3==1
replace reasonclosure=8 if F3_s1q3==12
replace reasonclosure=10 if F3_s1q3==8
replace reasonclosure=9 if F3_s1q3==9 | F3_s1q3==11 | F3_s1q3==96
replace reasonclosure=11 if F3_s1q3==14

replace reasonclosure=2 if F3_s1q3_specify=="WAS INVOLVED IN CAR ACCIDENT AND SHE HAD BROCKEN ON LEG" | F3_s1q3_specify=="HE WAS FAILING TO GO AND ORDRER THE BUSINESS BECAUSE OF ACCIDENT"
replace reasonclosure=3 if F3_s1q3_specify=="NURCING A FAMILY MEMBER WHO FALL SICK FOR A LONG TIME" | F3_s1q3_specify=="MOTHER PASSED AWAY"
replace reasonclosure=10 if F3_s1q3_specify=="STARTED ANOTHER"
replace reasonclosure=11 if F3_s1q3_specify=="THIEVES STOLE MY GOODS" | F3_s1q3_specify=="THEFT" | F3_s1q3_specify=="SHE WAS ROBBED" | F3_s1q3_specify=="ROBBERS STOLE ALL THE PRODUCTS IN THE SHOP" | F3_s1q3_specify=="GOODS WERE STOLEN"

label define closereason 1 "making a loss" 2 "sickness" 3 "care for family" 4 "better wage job" 5 "migrate abroad" 6 "married" 7 "shut down by govt." 8 "taken from me" 9 "other" 10 "better business opportunity" 11 "catastrophe"
label values reasonclosure closereason

*Sales in last month
rename F3_s9q8_past_month_revenues sales

*Profits in last month 
rename F3_s9q7_past_month_profits profits 

*Hours worked in self-employment in last month
*based on hours worked  in last week
g hours=F3_s2q5*(30/7)

*Total workers
g totalworkers=F3_s10q1-F3_s10q2_1 

*Worked as wage worker in last month
g wageworker=(F3_s1q6==1 | F3_s1q6==2 | F3_s11q8==4) if F3_s11q8!=. | F3_s1q6!=.

*Labor earnings from all labor, including the business, in last month
egen laborincome=rowtotal(F3_s1q15_past_month_income F3_s11q10 profit),m

*Excrate and excratemonth
g ivw_date=daily(F3_de_date,"DMY")
format ivw_date %td
su ivw_date, detail
*Survey took place between Nov. 2014 and April 2015, with 50% of interviews having been conducted by Jan. 7, 2015, so I take Jan. 15, 2015 as approx. midpoint
g excrate=0.00214
g excratemonth="1-2015" 

*Surveyyear
g surveyyear=2015

*Wave
g wave=4 
 
keep 	id ///
		surveyyear wave ///
		excrate excratemonth ///
		profits sales hours totalworkers wageworker laborincome ///
		survival newfirmstarted mainactivity reasonclosure F3_s1q3 F3_s1q6

foreach var of varlist 	surveyyear wave ///
						excrate excratemonth ///
						profits sales hours totalworkers wageworker laborincome ///
						survival newfirmstarted mainactivity reasonclosure{
rename `var' `var'4
}	

save MALAWIFORM4, replace


********************************************************************************
*Round 5
use "Malawi/Raw/Cleaned data/BRIE_control_group_cleanedFU4.dta", clear
********************************************************************************
*Survival
g survival=(F4_s1q1==1)

*Main activity after closing business
*Main activity after closing business
label define mainactivity 	1 "Working for a wage" ///
							2 "Looking for work" ///
							3 "Operating a different business" ///
							4 "Housework or looking after children" ///
							5 "Other"

g mainactivity=1 if F4_s1q6==1 | F4_s1q6==2 
replace mainactivity=3 if F4_s1q6==3 | F4_s1q6==4 
replace mainactivity=4 if F4_s1q6==5 | F4_s1q6==6 | F4_s1q6==7 | F4_s1q6==8 | F4_s1q6==9 | F4_s1q6==10 | F4_s1q6==96  

label values mainactivity mainactivity

*New firm started since last survey
g newfirmstarted=(mainactivity==3) if mainactivity!=.

*Reason for closing business
gen reasonclosure=1 if F4_s1q3==3 | F4_s1q3==4 | F4_s1q3==5 | F4_s1q3==6 | F4_s1q3==7
replace reasonclosure=2 if F4_s1q3==13
replace reasonclosure=3 if F4_s1q3==10
replace reasonclosure=4 if F4_s1q3==2
replace reasonclosure=7 if F4_s1q3==1
replace reasonclosure=8 if F4_s1q3==12
replace reasonclosure=10 if F4_s1q3==8
replace reasonclosure=9 if F4_s1q3==9 | F4_s1q3==11 | F4_s1q3==96
replace reasonclosure=11 if F4_s1q3==14

replace reasonclosure=1 if F4_s1q3_specify=="RENTS WERE TOO EXPENSIVE"
replace reasonclosure=2 if F4_s1q3_specify=="INVOLVED IN ACCEDENTS"
replace reasonclosure=6 if F4_s1q3_specify=="MONEY WAS USED FOR WEEDING CEREMONY"
replace reasonclosure=11 if F4_s1q3_specify=="THIEVES STOLE MY PROPERTIES" | F4_s1q3_specify=="THEFT"

label define closereason 1 "making a loss" 2 "sickness" 3 "care for family" 4 "better wage job" 5 "migrate abroad" 6 "married" 7 "shut down by govt." 8 "taken from me" 9 "other" 10 "better business opportunity" 11 "catastrophe"
label values reasonclosure closereason

*Sales in last month
rename F4_s9q21_past_month_revenues sales

*Profits in last month 
rename F4_s9q20_past_month_profits profits 

*Hours worked in self-employment in last month
*based on hours worked  in last week
g hours=F4_s2q5*(30/7) 

*Total workers
g totalworkers=F4_s10q1-F4_s10q2_1 

*Worked as wage worker in last month
g wageworker=(F4_s1q6==1 | F4_s1q6==2 | F4_s11q6==4) if F4_s11q6!=. | F4_s1q6!=.

*Labor earnings from all labor, including the business, in last month
egen laborincome=rowtotal(F4_s1q15_past_month_income F4_s11q8 profit),m

*Excrate and excratemonth
g ivw_date=daily(F4_de_date,"DMY")
format ivw_date %td
su ivw_date, detail
*Survey took place between July 2015 and January 2016, with 50% of interviews having been conducted by Aug. 26, 2015, so I take Aug. 26, 2015 as approx. midpoint
g excrate=0.00181
g excratemonth="8-2015" 

*Surveyyear
g surveyyear=2015

*Wave
g wave=5
 
keep 	id ///
		surveyyear wave ///
		excrate excratemonth ///
		profits sales hours totalworkers wageworker laborincome ///
		survival newfirmstarted mainactivity reasonclosure F4_s1q3 F4_s1q6

foreach var of varlist 	surveyyear wave ///
						excrate excratemonth ///
						profits sales hours totalworkers wageworker laborincome ///
						survival newfirmstarted mainactivity reasonclosure{
rename `var' `var'5
}	

save MALAWIFORM5, replace


********************************************************************************

********************************************************************************
*Merge rounds 1-3 together
********************************************************************************

********************************************************************************
use MALAWIFORM1, clear
forvalues i=2/5{
merge 1:1 id using MALAWIFORM`i', gen(_merge`i')
}

*Generate attrition
g attrit2=(_merge2==1)
g attrit3=(_merge3==1)
g attrit4=(_merge4==1)
g attrit5=(_merge5==1)

drop _merge*

quietly: reshape long 	surveyyear wave excrate excratemonth ///
						inventories ///
						ownerage female married ownertertiary childunder5 adult65andover ///
						agefirm retail manuf services sector ///
						s2q7 ///
						, ///
						i(id) j(survey)

foreach x in profits sales hours totalworkers wageworker laborincome competition1 {
replace `x'=. if wave!=1
}	

*No need to recode survival, as it is already coded from baseline

*Only keep if business is operating
forvalues i=2/5{
drop if survival`i'!=1 & wave==`i'
}

foreach x in survival newfirmstarted attrit totalworkers reasonclosure mainactivity sales profits wageworker laborincome hours{
g `x'_1yr=`x'2 if wave==1
drop `x'2
g `x'_1p833yrs=`x'3 if wave==1
drop `x'3
g `x'_2p9167yrs=`x'4 if wave==1
drop `x'4
g `x'_3p5yrs=`x'5 if wave==1
drop `x'5
}


tostring survey, replace
replace survey="BL-"+string(surveyyear) if wave==1
replace survey="R-"+string(surveyyear)+"-1" if wave==2 
replace survey="R-"+string(surveyyear)+"-2" if wave==3 
replace survey="R-"+string(surveyyear) if wave==4 
replace survey="L-"+string(surveyyear) if wave==5


g lastround=(wave==5)

*Generate owner, household and business id (which are the same here)
foreach var in ownerid firmid householdid{
egen `var'=group(id)
tostring `var', format("%04.0f") replace
replace `var'="MALAWIFORM"+"-"+`var'
}

g surveyname="MALAWIFORM"

save MALAWIFORM_masterfc, replace
				
