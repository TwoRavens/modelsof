********************************************************************************

********************************************************************************
**THIS DO-FILE PREPARES THE DATA FROM THE SRI LANKA INFORMAL ENTERPRISES SURVEY FOR COMBINATION INTO THE MASTER DATASET
**Small Firm Death in Developing Countries
**March 12, 2018
**David McKenzie (dmckenzie@worldbank.org) and Anna Luisa Paffhausen (apaffhausen@worldbank.org)
**The analysis was performed with Stata, version 14.2

*Notes:
* The underlying raw data needed to replicate this do-file is available in the World Bank's Microdata Catalogue.
* To replicate this do-file:
* 1) Go to http://microdata.worldbank.org/index.php/catalog/1063
* 2) Download the data files in Stata format (http://microdata.worldbank.org/index.php/catalog/1063/download/21156)
* 3) Change the directory in the do-file 
* 4) Change the paths to the data you are using and for saving the datasets that are created in this do-file
*    Make sure the final dataset (SKLINFORMALITY_masterfc) is saved in the folder “Do-files and readme/Construction of Dataset/Data for combination”

********************************************************************************

********************************************************************************
clear all
*TO DO: change directory 
*EXAMPLE:
cd  "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data"

set more off

********************************************************************************

********************************************************************************
*Baseline variables
********************************************************************************

********************************************************************************

*TO DO: change path to where you saved the following file "informalityanon_baseline.dta"
/*EXAMPLE:
use "Sri Lanka informality/informalityanon_baseline.dta"
*/

*Country
g country="Sri Lanka"

*Surveyyear
g surveyyear=2008

*Wave
g wave=1


*Treatment status
g treatstatus=(control==0)


*Local to USD exchange rate at time of survey
*Survey took place in December 2008, so I take December 15, 2008 as approx. midpoint
g excrate=0.00885

g excratemonth="12-2008"


********************************************************************************
*Owner and Household characteristics
********************************************************************************

*Age of owner
rename q2_4 ownerage

*Gender of owner
g female=(q1_17==2) if q1_17!=.

*Marital status of owner
g married=(q1_18==2)

*Education of owner
**Owner's education in years
gen educyears=q2_1
replace educyears=q2_2 if q2_1>=14 & q2_1<18

**Owner has tertiary education
g ownertertiary=(q2_1==15 | q2_1==16 | q2_1==17)

*Digit span recall of owner
g digitspan=3 if q12_2a==2 
replace digitspan=4 if q12_2a==1
replace digitspan=5 if q12_2b==1 
replace digitspan=6 if q12_2c==1
replace digitspan=7 if q12_2d==1
replace digitspan=8 if q12_2e==1
replace digitspan=9 if q12_2f==1
replace digitspan=10 if q12_2g==1
replace digitspan=11 if q12_2h==1


********************************************************************************
*Firm characteristics
********************************************************************************
*Age of the firm in years
g ivwmonth=monthly(excratemonth,"MY")

g helpbusstartdate=string(q1_10m)+"-"+string(q1_10y) if q1_10m!=99 & q1_10m!=. & q1_10y!=999 & q1_10y!=99 & q1_10y!=.
g busstartdate=monthly(helpbusstartdate,"MY")

g agefirm=(ivwmonth-busstartdate)/12 if ivwmonth!=. & busstartdate!=.

replace agefirm=surveyyear-q1_10y if agefirm==. & q1_10y!=. & q1_10y!=999 & q1_10y!=99

replace agefirm=round(agefirm,0.5)

*Capital stock
g capitalstock=q5_1a7

*Inventories
*already in dataset

*Firm is in retail trade
*already in dataset

*Firm is in manufacturing sector
*already in dataset

*Firm is in service sector
*already in dataset

*Detailed firm sector (ISIC 2 or 3 digit)
rename q1_2 sector

*Employees
rename paidemployees employees

*Number of permanent and/or full-time workers
rename fulltimeemployees fulltimeworkers

*Profits
*already in dataset

*Sales
*already in dataset

*Hours worked in self-employment in last month
*based on hours worked  in last week
g hours=q1_3a*(30/7) 

*based on hours worked  in a normal week
g hoursnormal=q1_3b*(30/7) 

********************************************************************************
*Competition facing firm
********************************************************************************
*Number of competitors
replace q8_1=. if q8_1==999
rename q8_1 competition1

********************************************************************************
keep 	sheno ///
		country surveyyear wave treatstatus excrate excratemonth ///
		ownerage female married educyears ownertertiary digitspan ///
		agefirm capitalstock inventories retail manuf services sector employees fulltimeworkers profits sales hours hoursnormal ///
		competition1 

foreach var of varlist surveyyear wave treatstatus excrate excratemonth ///
		ownerage female married educyears ownertertiary digitspan ///
		agefirm capitalstock inventories retail manuf services sector employees fulltimeworkers profits sales hours hoursnormal ///
		competition1  {
rename `var' `var'1
}	



*TO DO: decide whether you need/want to change path for saving SKLINFORMALITY1
/*
save SKLINFORMALITY1, replace
*/

********************************************************************************

********************************************************************************
*Panel variables
********************************************************************************

********************************************************************************
*Round 2
*TO DO: change path to where you saved the following file "informalityanon_aug2010.dta"
/*EXAMPLE:
use "Sri Lanka informality/informalityanon_aug2010.dta", clear
*/
********************************************************************************

*Surveyyear
g surveyyear=2010

*Wave
g wave=2

*Local to USD exchange rate at time of survey
*Survey took place in August 2010 so I take Aug. 15, 2010 as approx. midpoint
g excrate=0.00890
g excratemonth="8-2010"
						

*Profits in last month
rename q2_8 profits
replace profits=. if profits==999

*Sales in last month
rename q2_6a sales
replace sales=. if sales==999

*Number of paid employees
egen employees=rowtotal(q1_15_1 q1_15_2),m

*Hours worked in self-employment in last month - old business
*based on hours worked  in last week
g hours=q1_13a*(30/7) 

*based on hours worked  in a normal week
g hoursnormal=q1_13b*(30/7) 

*Survival
g survival=(q1_1c==1)

gen reasonclosure=q1_1f
replace reasonclosure=4 if q1_1f==3
replace reasonclosure=3 if q1_1f==4
replace reasonclosure=9 if q1_1f==5
label define closereason 1 "making a loss" 2 "sickness" 3 "care for family" 4 "better wage job" 5 "migrate abroad" 6 "married" 7 "shut down by govt." 8 "taken from me" 9 "other"
label values reasonclosure closereason

*specification of "other reason" not found

*New firm started since last survey
g newfirmstarted=(q1_1d!=4 & q1_1d!=.)

*Attrition
*TO DO: change path to where you saved the following file "informalityattritorindicator.dta"
/*EXAMPLE:
merge 1:1 sheno using "Sri Lanka informality/InformalityAttritorindicator.dta"
*/
g attrit=attritor

*Use information on reasons for attrition to recode survival and code died
replace survival=0 if ifnotreasoncode==4 | ifnotreasoncode==5

g died=(ifnotreasoncode==1)

keep 	sheno ///
		surveyyear wave excrate excratemonth ///
		profits sales employees hours hoursnormal ///
		survival reasonclosure newfirmstarted attrit died


foreach var of varlist 	surveyyear wave excrate excratemonth ///
						profits sales employees hours hoursnormal ///
						survival reasonclosure newfirmstarted attrit died{
rename `var' `var'2
}	

replace wave2=2 if wave2==.
replace surveyyear2=2010 if surveyyear2==.

*TO DO: decide whether you need/want to change path for saving SKLINFORMALITY2
/*
save SKLINFORMALITY2, replace
*/

********************************************************************************
*Round 3
*TO DO: change path to where you saved the following file "informalityanon_march2011.dta"
/*EXAMPLE:
use "Sri Lanka informality/informalityanon_march2011.dta", clear
*/
********************************************************************************

*Surveyyear
g surveyyear=2011

*Wave
g wave=3

*Local to USD exchange rate at time of survey
*Survey took place in March 2011 so I take March 15, 2011 as approx. midpoint
g excrate=0.00907
g excratemonth="3-2011"

*Profits in last month
rename q2_7a profits
replace profits=. if profits==999

*Sales in last month
rename q2_6a sales
replace sales=. if sales==999 

*Number of paid employees
egen employees=rowtotal(q1_5_1 q1_5_2),m

*Hours worked in self-employment in last month - old business
*based on hours worked  in last week
g hours=q1_4a*(30/7) 

*based on hours worked  in a normal week
g hoursnormal=q1_4b*(30/7) 

*Survival
g survival=(q1_1a==1)

gen reasonclosure=q1_1d
replace reasonclosure=4 if q1_1d==3
replace reasonclosure=3 if q1_1d==4
replace reasonclosure=9 if q1_1d==5
label define closereason 1 "making a loss" 2 "sickness" 3 "care for family" 4 "better wage job" 5 "migrate abroad" 6 "married" 7 "shut down by govt." 8 "taken from me" 9 "other"
label values reasonclosure closereason

replace reasonclosure=. if reasonclosure==999

*New firm started since last survey
g newfirmstarted=(q1_1b!=4 & q1_1b!=.)

*Attrition
*TO DO: change path to where you saved the following file "informalityanon_march2011.dta"
/*EXAMPLE:
merge 1:1 sheno using "Sri Lanka informality/informalityattritorindicator.dta"
*/

g attrit=_merge==2

keep 	sheno ///
		surveyyear wave excrate excratemonth ///
		profits sales employees hours hoursnormal ///
		survival reasonclosure newfirmstarted attrit /*died*/


foreach var of varlist 	surveyyear wave excrate excratemonth ///
						profits sales employees hours hoursnormal ///
						survival reasonclosure newfirmstarted attrit /*died*/{
rename `var' `var'3
}	

replace wave3=3 if wave3==.
replace surveyyear3=2011 if surveyyear3==.

*TO DO: decide whether you need/want to change path for saving SKLINFORMALITY3
/*
save SKLINFORMALITY3, replace
*/
		
********************************************************************************
*Round 4
*TO DO: change path to where you saved the following file "informalityanon_dec2011.dta"
/*EXAMPLE:
use "Sri Lanka informality/informalityanon_dec2011.dta", clear
*/
********************************************************************************

*Surveyyear
g surveyyear=2011

*Wave
g wave=4

*Local to USD exchange rate at time of survey
*Survey took place in December 2011 so I take Dec. 15, 2011 as approx. midpoint
g excrate=0.00877
g excratemonth="12-2011"

*Profits in last month
rename q2_7a profits
replace profits=. if profits==999

*Sales in last month
rename q2_6a sales
replace sales=. if sales==999 

*Number of paid employees
egen employees=rowtotal(q1_5_1 q1_5_2),m

*Hours worked in self-employment in last month - old business
*based on hours worked  in last week
g hours=q1_4a*(30/7) 

*based on hours worked  in a normal week
g hoursnormal=q1_4b*(30/7) 

*Survival
g survival=(q1_1a==1) if q1_1a!=.
replace survival=1 if qf4==1 | qf4==3 | qf4==4
replace survival=0 if qf4==2

gen reasonclosure=q1_1d
replace reasonclosure=4 if q1_1d==3
replace reasonclosure=3 if q1_1d==4
replace reasonclosure=9 if q1_1d==5
label define closereason 1 "making a loss" 2 "sickness" 3 "care for family" 4 "better wage job" 5 "migrate abroad" 6 "married" 7 "shut down by govt." 8 "taken from me" 9 "other"
label values reasonclosure closereason

*New firm started since last survey
g newfirmstarted=(q1_1b_2_1!=.)
replace newfirmstarted=1 if qf5_2==1

*Attrition
g attrit=(qf4==5 & survival==.)

*Owner died between survey rounds
g died=(qf5_8==1)

*Worked as wage worker in last month
g wageworker=(qf5_3==1) if qf5_3!=.



keep 	sheno ///
		surveyyear wave excrate excratemonth ///
		profits sales employees hours hoursnormal ///
		survival reasonclosure newfirmstarted attrit died wageworker


foreach var of varlist 	surveyyear wave excrate excratemonth ///
						profits sales employees hours hoursnormal ///
						survival reasonclosure newfirmstarted attrit died wageworker{
rename `var' `var'4
}	

*TO DO: decide whether you need/want to change path for saving SKLINFORMALITY4
/*
save SKLINFORMALITY4, replace		
*/

********************************************************************************

********************************************************************************
*Merge rounds 1-4 together
********************************************************************************

********************************************************************************
*TO DO: change path to where you saved the following file "SKLINFORMALITY1.dta"
/*EXAMPLE:
use SKLINFORMALITY1, clear
*/

*TO DO: change path to where you saved the following file "SKLINFORMALITY2.dta"
/*EXAMPLE:
merge 1:1 sheno using SKLINFORMALITY2, nogenerat
*/

*TO DO: change path to where you saved the following file "SKLINFORMALITY3.dta"
/*EXAMPLE:
merge 1:1 sheno using SKLINFORMALITY3, nogenerate
*/

*TO DO: change path to where you saved the following file "SKLINFORMALITY4.dta"
/*EXAMPLE:
merge 1:1 sheno using SKLINFORMALITY4, nogenerate
*/

foreach x in  treatstatus profits sales hours hoursnormal employees{
rename `x'1 `x'
}

quietly: reshape long 	surveyyear wave excrate excratemonth ///
						ownerage female married educyears ownertertiary digitspan ///
						agefirm capitalstock inventories retail manuf services sector fulltimeworkers ///
						competition1, ///
						i(sheno) j(survey)

foreach x in  treatstatus profits sales hours hoursnormal employees{
replace `x'=. if wave!=1
}						

*Recode survival, which has so far been coded from round to round so that it gives survival since baseline
replace survival4=0 if survival2==1 & survival3==0 & newfirmstarted3==1
replace survival4=0 if survival2==0 & survival3==1 & newfirmstarted2==1
replace survival4=0 if survival2==0 & survival3==0 & newfirmstarted3==1
replace survival3=0 if survival2==0 & survival3==1 & newfirmstarted2==1

*Only keep if business is operating
forvalues i=2/4{
drop if survival`i'!=1 & wave==`i'
}


foreach x in sales profits survival reasonclosure newfirmstarted employees hours hoursnormal attrit{
g `x'_1yr8mths=`x'2 if wave==1
drop `x'2
g `x'_2p25yrs=`x'3 if wave==1
drop `x'3
g `x'_3yrs=`x'4 if wave==1
drop `x'4
}	

 
foreach x in died {
g `x'_1yr8mths=`x'2 if wave==1
drop `x'2
g `x'_3yrs=`x'4 if wave==1
drop `x'4
}

g wageworker_3yrs=wageworker4 if wave==1
drop wageworker4


tostring survey, replace
replace survey="BL-"+string(surveyyear) if wave==1
replace survey="R-"+string(surveyyear) if wave==2 
replace survey="R-"+string(surveyyear) if wave==3 
replace survey="L-"+string(surveyyear) if wave==4

g lastround=(wave==4)

*Generate owner, household and business id (which are the same here)
foreach var in ownerid firmid householdid{
egen `var'=group(sheno)
tostring `var', format("%04.0f") replace
replace `var'="SKLINFORMALITY"+"-"+`var'
}

g control=(treatstatus==0)

g surveyname="SLKINFORMALITY"


*TO DO: Make sure the final dataset "SKLINFORMALITY_masterfc.dta" is saved in the folder “Do-files and readme/Construction of Dataset/Data for combination”
/*
save SKLINFORMALITY_masterfc,replace
*/
