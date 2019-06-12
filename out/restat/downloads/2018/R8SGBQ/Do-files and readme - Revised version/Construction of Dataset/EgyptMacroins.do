********************************************************************************

********************************************************************************
**THIS DO-FILE PREPARES THE DATA FROM THE EGYPT MACROINSURANCE FOR MICROENTERPRISE SURVEY FOR COMBINATION INTO THE MASTER DATASET
**Small Firm Death in Developing Countries
**November 20, 2017
**David McKenzie (dmckenzie@worldbank.org) and Anna Luisa Paffhausen (apaffhausen@worldbank.org)
**The analysis was performed with Stata, version 14.2

*Notes:
* The underlying raw data needed to replicate this do-file is available in the World Bank's Microdata Catalogue.
* To replicate this do-file:
* 1) Go to http://microdata.worldbank.org/index.php/catalog/2063
* 2) Download the data files in Stata format (http://microdata.worldbank.org/index.php/catalog/2063/download/31371)
* 3) Change the directory in the do-file 
* 4) Change the paths to the data you are using and for saving the datasets that are created in this do-file (EgyptMacroins, and EGYPTMACROINS_masterfc)
*    Make sure the final dataset (EGYPTMACROINS_masterfc) is saved in the folder “Do-files and readme/Construction of Dataset/Data for combination”


********************************************************************************

********************************************************************************
clear all
*TO DO: change directory 
/*EXAMPLE:
cd  "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data"
*/
set more off

********************************************************************************

********************************************************************************
*Baseline variables
********************************************************************************

******************************************************************************** 

*TO DO: change path to where you saved the following file "MacroinsuranceforMicroentrepreneurs.dta"
/*EXAMPLE:
use "Egypt macroinsurance/MacroinsuranceforMicroentrepreneurs.dta",clear
*/
********************************************************************************

*Cleaning
drop if b_RESULT==.
********************************************************************************

*Country
g country="Egypt"

*Surveyyear
g surveyyear=2012

*Wave
g wave=1

*Treatment status
g treatstatus=treat
g control=(treat==0)

*Local to USD exchange rate at time of survey
*Survey took place between in March 2012, so I take March 15, 2012 as approx. midpoint
g excrate=0.16524
g excratemonth="3-2012"



********************************************************************************
*Owner and Household characteristics
********************************************************************************
replace b_YEAR=2012 if b_YEAR==.
replace b_MONTH=3 if b_MONTH==.


*Age of owner
g helpivwdate=string(b_DAY)+"-"+string(b_MONTH)+"-"+string(b_YEAR)
g ivwdate=daily(helpivwdate,"DMY")


g birthdatestring=string(b_103DAY)+"-"+string(b_103MON)+"-"+string(b_103YEAR) 
g birthdate=daily(birthdatestring,"DMY")

g ownerage=(ivwdate-birthdate)/365 if birthdate!=.

replace ownerage=. if ownerage<0

replace ownerage=b_YEAR-b_103YEAR if ownerage==. & b_103YEAR!=. & b_103YEAR!=9998

replace ownerage=floor(ownerage)

*Gender of owner
*female already exists

*Marital status of owner
g married=(b_104==1) if b_104!=.

*Education of owner
**Owner has tertiary education
g ownertertiary=(b_106==5 | b_106==6) if b_106!=.

*Household expenditure per capita
g pcexpend=((b_1201_10*52)+(b_1202_13*12)+b_1203_11)/b_108 if b_108!=. & b_1201_10!=. & b_1202_13!=. & b_1203_11!=.


********************************************************************************
*Firm characteristics
********************************************************************************
*Age of the firm in years
g helpivwdate2=string(b_MONTH)+"-"+string(b_YEAR)
g ivwmonth=monthly(helpivwdate2,"MY")

g helpbusstartdate=string(b_202MON)+"-"+string(b_202YEAR) if b_202MON!=99 & b_202MON!=98 & b_202MON!=. & b_202YEAR!=9999 & b_202YEAR!=9998 & b_202YEAR!=.
g busstartdate=monthly(helpbusstartdate,"MY")

g agefirm=(ivwmonth-busstartdate)/12 if busstartdate!=.

replace agefirm=b_YEAR-b_202YEAR if agefirm==. & b_202YEAR!=9999 & b_202YEAR!=9998 & b_202YEAR!=.

replace agefirm=round(agefirm,0.5)

*Capital stock
forvalues i = 2/9{
local j=`i'-1
order b_508_`i', after(b_508_`j')
}
egen capitalstock=rowtotal(b_508_1-b_508_9),m

*Inventories
g inventories=b_509A
replace inventories=0 if b_509==2

*Firm is in retail trade
drop if b_202==1 | b_202==2 | b_202==3
g retail=(b_202==47 ) if b_202!=. &  b_202!=0

*Firm is in manufacturing sector
g manuf=(b_202==10 | b_202==11 | b_202==12 | b_202==13 | b_202==14 | b_202==15 | b_202==16 | b_202==17 | b_202==19 | b_202==20 | b_202==21 | b_202==22 | b_202==23 | b_202==24 | b_202==25 | b_202==26 | b_202==27 | b_202==28 | b_202==29 | b_202==30 | b_202==31 | b_202==32) if b_202!=. &  b_202!=0

*Firm is in service sector
g services=(b_202==18 | b_202==33 | b_202==49 | b_202==50 | b_202==51 | b_202==52 | b_202==53 | b_202==55 | b_202==56 | b_202==58 | b_202==59 | b_202==60 | b_202==61 | b_202==62 | b_202==63 | b_202==64 | b_202==65 | b_202==66 | b_202==68 | b_202==69 | b_202==70 | b_202==71 | b_202==72 | b_202==73 | b_202==74 | b_202==75 | b_202==77 | b_202==78 | b_202==79 | b_202==80 | b_202==81 | b_202==82 | b_202==84 | b_202==85 | b_202==86 | b_202==87 | b_202==88 | b_202==90 | b_202==91 | b_202==92 | b_202==93 | b_202==94 | b_202==95 | b_202==96) if b_202!=. &  b_202!=0

*Firm is in other sector
g othersector=(b_202==5 | b_202==6 | b_202==7 | b_202==8 | b_202==9 | b_202==35 | b_202==36 | b_202==37 | b_202==38 | b_202==39 | b_202==41 | b_202==42 | b_202==43 | b_202==45 | b_202==46 | b_202==97 | b_202==98 | b_202==99) if b_202!=. &  b_202!=0

*Sector
g sector=b_202 if b_202!=. &  b_202!=0


*Employees
egen employees=rowtotal(b_210A_1 b_210B_1), m

*Number of permanent and/or full-time workers
egen fulltimeworkers=rowtotal(b_210A_1 b_210A_2), m

*Profits in last month
rename b_605_1 profits

*Sales in last month
rename b_604_1 sales

*Hours worked in self-employment in last month
*based on hours worked  in last week
g hours=b_212A*(30/7) if b_212A!=999 & b_212A!=.

*based on hours worked  in a normal week
g hoursnormal=b_211A*(30/7) if b_211A!=999 & b_211A!=.

********************************************************************************
foreach var of varlist 	surveyyear wave excrate excratemonth ///
						ownerage female married ownertertiary pcexpend ///
						agefirm capitalstock inventories retail manuf services sector employees fulltimeworkers profits sales hours hoursnormal ///
						{
						rename `var' `var'1
						}	
						
*TO DO: decide whether you need/want to change path for saving EgyptMacroins
/*
save EgyptMacroins, replace	
*/					
********************************************************************************

********************************************************************************
*Panel variables, first and only follow-up
********************************************************************************

********************************************************************************

*Surveyyear
g surveyyear=2012

*Wave
g wave=2

*Local to USD exchange rate at time of survey
*Survey took place in October and November, but in November the interviews were conducted in the first 7 days, so I take Oct. 15, 2012 as approx. midpoint
g excrate=0.16076
g excratemonth="10-2012"
						
replace m_YEAR=2012 if m_YEAR==.

*Profits in last month
rename m_903_1 profits
replace profits=. if profits==99997 | profits==99998

*Sales in last month
rename m_901_1 sales
replace sales=. if sales==99997 | sales==99998

*Labor income
egen laborincome=rowtotal(m_306 profits), m

*Wage worker
g wageworker=(m_301==1) if  m_301!=.

*Reason for closing the business
label define reasonforclosure 1 "Too risky and too much uncertainty" 2 "Lack of credit" 3 "Not profitable" 6 "Other reason"
g reasonforclosure=m_206 if m_206!=9
label values reasonforclosure reasonforclosure	

*Main activity after closing business
label define mainactivity 	1 "Working for a wage" ///
							2 "Looking for work" ///
							3 "Operating a different business" ///
							4 "Housework or looking after children" ///
							5 "Other"

rename m_207 mainactivity
replace mainactivity=5 if mainactivity==6
label values mainactivity mainactivity							

*Household expenditure per capita
g pcexpend=((m_1301_10*52)+(m_1302_13*12)+(m_1303_11*2))/b_108 if b_108!=. & m_1301_10!=. & m_1302_13!=. & m_1303_11!=.

*Owner died between survey rounds
g dead=(m_103==8) if m_103!=. & m_103!=98
*Check code for attrition! m_RESULT==3

*Survival
gen survival=1 if m_102==1| m_102==3| m_102==4
replace survival=0 if m_102==2
replace survival=1 if m_205==2
replace survival=0 if m_205==1
*What about if m_RESULT==3 (not even sure this means that owner died)

*New firm started
g newfirmstarted=(mainactivity==3 & m_208==1) if mainactivity!=.

*Attrition
g attrit=(survival==.)

foreach var of varlist 	surveyyear wave excrate excratemonth ///
						profits sales laborincome wageworker reasonforclosure mainactivity pcexpend dead survival newfirmstarted attrit ///
						{
						rename `var' `var'2
						}	
		
keep clientid country treatstatus control *1 *2 
drop x* b_* m_*

*TO DO: decide whether you need/want to change path for saving EgyptMacroins
/*
save EgyptMacroins, replace						
*/
quietly: reshape long 	surveyyear wave excrate excratemonth ///
						ownerage female married ownertertiary pcexpend ///
						agefirm capitalstock inventories retail manuf services sector employees fulltimeworkers profits sales hours hoursnormal, ///
						i(clientid) j(survey)


*Only keep if business is operating
drop if survival2!=1 & wave==2

foreach x in survival newfirmstarted attrit mainactivity reasonforclosure dead laborincome wageworker{
g `x'_6mths=`x'2 if wave==1
drop `x'2
}	

tostring survey, replace
replace survey="BL-"+string(surveyyear) if wave==1
replace survey="L-"+string(surveyyear) if wave==2

g lastround=(wave==2)

*Generate owner, household and business id (which are the same here)
foreach var in ownerid firmid householdid{
egen `var'=group(clientid)
tostring `var', format("%04.0f") replace
replace `var'="EGYPTMACROINS"+"-"+`var'
}

g surveyname="EGYPTMACROINS"

*TO DO: Make sure the final dataset "EGYPTMACROINS_masterfc" is saved in the folder “Do-files and readme/Construction of Dataset/Data for combination”
/*
save EGYPTMACROINS_masterfc, replace
*/										
