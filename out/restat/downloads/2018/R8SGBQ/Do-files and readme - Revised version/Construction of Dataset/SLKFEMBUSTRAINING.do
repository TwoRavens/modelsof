********************************************************************************

********************************************************************************
**THIS DO-FILE PREPARES THE DATA FROM THE SRI LANKA IMPACT EVALUATION SURVEY OF BUSINESS TRAINING FOR WOMEN FOR COMBINATION INTO THE MASTER DATASET
**Small Firm Death in Developing Countries
**March 12, 2018
**David McKenzie (dmckenzie@worldbank.org) and Anna Luisa Paffhausen (apaffhausen@worldbank.org)
**The analysis was performed with Stata, version 14.2

*Note:
* This do-file cannot be replicated as part of the underlying raw data needed to replicate this do-file is not (yet) available publicly.

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
*Use r1 and r2 for current owners and r2 for potential owners so that we have those potential owners who operated a business by r2 in the baseline

********************************************************************************
*R1 current
*TO DO: change path to where you saved the following file "/R1_current.dta"
/*
use "Sri Lanka Business Training/R1_current.dta", clear
*/
********************************************************************************

*Country
g country="Sri Lanka"

*Surveyyear
g surveyyear=2009

*Wave
g wave=1

*Treatment status
g treatstatus=(treatgroup==2 | treatgroup==3)

*Business training treatment
g bustraining=(treatgroup==2)

********************************************************************************
*Owner and Household characteristics
********************************************************************************

*Age of owner
rename q1_13 ownerage

*Gender of owner
g female=(q1_14==2)

*Marital status of owner
g married=(q1_15==2)

*Education of owner
**Owner's education in years 
gen educyears=q2_1
replace educyears=q2_2 if q2_1>=14 & q2_1<18

**Owner has tertiary education
g ownertertiary=(q2_1==15 | q2_1==16 | q2_1==17)

*Has child under 5
forvalues i=2/12{
local j=`i'-1
order q3_15d_`i', after(q3_15d_`j')
}
egen childunder5=anymatch(q3_15d_1-q3_15d_12), values(0/4)

*Has child aged 5 to 12
egen childaged5to12=anymatch(q3_15d_1-q3_15d_12), values(5/11)

*Has elderly member in household
foreach var of varlist q3_15d_1-q3_15d_12{
replace `var'=. if `var'==999
}
egen helpmaxage=rowmax(q3_15d_1-q3_15d_12)
su helpmaxage
egen adult65andover=anymatch(q3_15d_1-q3_15d_12), values(65/`r(max)')

*Digit span recall of owner
gen digitspan=3 if q12_2a==2
replace digitspan=4 if q12_2b==2
replace digitspan=5 if q12_2c==2
replace digitspan=6 if q12_2d==2
replace digitspan=7 if q12_2e==2
replace digitspan=8 if q12_2f==2
replace digitspan=9 if q12_2g==2
replace digitspan=10 if q12_2h==2
replace digitspan=11 if q12_2h==1

*Raven score of owner
mvencode q11_4_1-q11_4_12, mv(0)
gen raven1=q11_4_1==8
gen raven2=q11_4_2==4
gen raven3=q11_4_3==5
gen raven4=q11_4_4==1
gen raven5=q11_4_5==2
gen raven6=q11_4_6==5
gen raven7=q11_4_7==6
gen raven8=q11_4_8==3
gen raven9=q11_4_9==7
gen raven10=q11_4_10==8
gen raven11=q11_4_10==7
gen raven12=q11_4_12==6
 
egen raven=rsum(raven1-raven12)
replace raven=raven/12


********************************************************************************
*Firm characteristics
********************************************************************************
*Age of the firm in years (I use the time of the r2 survey)
g helpivwdate="9"+"-"+"2009"
g ivwmonth=monthly(helpivwdate,"MY")

g date_yy=2009

g helpbusstartdate=string(q1_10m)+"-"+string(q1_10y) if q1_10m!=99 & q1_10y!=99
g busstartdate=monthly(helpbusstartdate,"MY")

g agefirm=(ivwmonth-busstartdate)/12 if busstartdate!=.

replace agefirm=date_yy-q1_10y if agefirm==. & q1_10y!=. & q1_10y!=99

replace agefirm=round(agefirm,0.5)

*Code it based on ISIC rev. 3
tostring q1_2, replace
g q1_2h=substr(q1_2, 1,2)
destring q1_2h, replace

*Firm is in retail trade
g retail=(q1_2h>=50 & q1_2h<=54) if q1_2h!=.

*Firm is in manufacturing sector
g manuf=(q1_2h>=15 & q1_2h<=37) if q1_2h!=.

*Firm is in service sector
g services=(q1_2h>=55 & q1_2h<=93) if q1_2h!=.

*Firm is in other sector
g othersector=((q1_2h>=10 & q1_2h<=14) | (q1_2h>=40 & q1_2h<=45) | (q1_2h>=95 & q1_2h<=99)) if q1_2h!=.

rename q1_2 sector
destring sector, replace

*Employees
gen p_spouse = q1_12b_1 if q1_12e_1==1 | q1_12e_1==2
gen p_child = q1_12b_2 if q1_12e_2==1 | q1_12e_2==2
gen p_sibling = q1_12b_3 if q1_12e_3==1 | q1_12e_3==2
gen p_parent = q1_12b_4 if q1_12e_4==1 | q1_12e_4==2
gen p_other_relative = q1_12b_5 if q1_12e_5==1 | q1_12e_5==2
gen p_non_relative = q1_12b_6 if q1_12e_6==1 | q1_12e_6==2
gen up_spouse = q1_12b_1 if q1_12e_1==3 
gen up_child = q1_12b_2 if q1_12e_2==3
gen up_sibling = q1_12b_3 if q1_12e_3==3
gen up_parent = q1_12b_4 if q1_12e_4==3
gen up_other_relative = q1_12b_5 if q1_12e_5==3
gen up_non_relative = q1_12b_6 if q1_12e_6==3

foreach x in p_spouse p_child p_sibling p_parent p_other_relative p_non_relative up_spouse up_child up_sibling up_parent up_other_relative up_non_relative {
recode `x' (.=0)
}

gen employees = p_spouse+p_child+p_sibling+p_parent+p_other_relative+p_non_relative
gen totalworkersworkers = up_spouse+up_child+up_sibling+up_parent+up_other_relative+up_non_relative+employees


********************************************************************************
*Competition facing firm
********************************************************************************
*Number of competitors (here: in same G.N.)
replace q8_1=. if q8_1==999
rename q8_1 competition1

********************************************************************************

keep 	sheno ///
		country surveyyear wave treatstatus bustraining ///
		ownerage female married educyears ownertertiary childunder5 childaged5to12 adult65andover digitspan raven ///
		agefirm retail manuf services othersector sector employees totalworkers ///
		competition1 q5_1a_7

*TO DO: decide whether you need/want to change path for saving SKLINFORMALITY1
/*		
save SLKFEMBUSTRAINING1_1, replace	
*/	
********************************************************************************
*R2 current
/*
merge 1:1 sheno using "Sri Lanka Business Training/R2_current.dta", nogenerate keep(3)
*/
********************************************************************************

*Survey took place between in September 2009, so I take September 15, 2009 as approx. midpoint
g excrate=0.00870 
g excratemonth="9-2009" 

*Generate a variable that indicates who will not be part of our baseline sample
*Those businesses that were operating a different business than the one on the cover in January 2009
g notpartofBL=(q1_1a==1)
*Those that are not alive / changed business line from r1 to r2
replace notpartofBL=(q1_1c==2 | q1_1c==4)

*Profits in last month
replace q7_8=. if q7_8==999 
rename q7_8 profits

*Sales in last month
rename q7_5 sales

*Hours worked in self-employment in last month
*based on hours worked  in last week
g hours=q6_5a*(30/7) 

*based on hours worked  in a normal week
g hoursnormal=q6_5b*(30/7) 

*Capital stock
g capitalstock=q5_1a_7 + q6_1a_7

*Inventories
replace q7_2=. if q7_2==999
g inventories=q7_2
replace inventories=0 if q7_1==2

********************************************************************************

keep 	sheno notpartofBL ///
		country surveyyear wave treatstatus bustraining ///
		ownerage female married educyears ownertertiary childunder5 childaged5to12 adult65andover digitspan raven ///
		agefirm retail manuf services othersector sector employees totalworkers ///
		competition1 ///
		excrate excratemonth ///
		profits sales hours hoursnormal capitalstock inventories

*TO DO: decide whether you need/want to change path for saving SLKFEMBUSTRAINING1_1
/*
save SLKFEMBUSTRAINING1_1, replace		
*/
********************************************************************************
*R1 potential
/*
use "Sri Lanka Business Training/R1_potential.dta", clear
*/
********************************************************************************

*Country
g country="Sri Lanka"

*Surveyyear
g surveyyear=2009

*Wave
g wave=1

*Treatment status
g treatstatus=(treatgroup==2 | treatgroup==3)

*Business training treatment
g bustraining=(treatgroup==2)


********************************************************************************
*Owner and Household characteristics
********************************************************************************

*Age of owner
rename q1_10 ownerage

*Gender of owner
g female=(q1_11==2)

*Marital status of owner
g married=(q1_12==2)

*Education of owner
**Owner's education in years
gen educyears=q2_1
replace educyears=q2_2 if q2_1>=14 & q2_1<18

**Owner has tertiary education
g ownertertiary=(q2_1==15 | q2_1==16 | q2_1==17)

*Has child under 5
forvalues i=2/12{
local j=`i'-1
order q3_15d_`i', after(q3_15d_`j')
}
egen childunder5=anymatch(q3_15d_1-q3_15d_12), values(0/4)

*Has child aged 5 to 12
egen childaged5to12=anymatch(q3_15d_1-q3_15d_12), values(5/11)

*Has elderly member in household
egen helpmaxage=rowmax(q3_15d_1-q3_15d_12)
su helpmaxage
egen adult65andover=anymatch(q3_15d_1-q3_15d_12), values(65/`r(max)')

*Digit span recall of owner
destring q12_2b q12_2e, replace
gen digitspan=3 if q12_2a==2
replace digitspan=4 if q12_2b==2
replace digitspan=5 if q12_2c==2
replace digitspan=6 if q12_2d==2
replace digitspan=7 if q12_2e==2
replace digitspan=8 if q12_2f==2
replace digitspan=9 if q12_2g==2
replace digitspan=10 if q12_2h==2
replace digitspan=11 if q12_2h==1

*Raven score of owner
mvencode q11_4_1-q11_4_12, mv(0)
gen raven1=q11_4_1==8
gen raven2=q11_4_2==4
gen raven3=q11_4_3==5
gen raven4=q11_4_4==1
gen raven5=q11_4_5==2
gen raven6=q11_4_6==5
gen raven7=q11_4_7==6
gen raven8=q11_4_8==3
gen raven9=q11_4_9==7
gen raven10=q11_4_10==8
gen raven11=q11_4_10==7
gen raven12=q11_4_12==6
 
egen raven=rsum(raven1-raven12)
replace raven=raven/12

********************************************************************************
*Competition facing firm
********************************************************************************
*Number of competitors (here: in same G.N.)
replace q8_1=. if q8_1==999
rename q8_1 competition1
rename q1_1 plannedsector

keep 	sheno ///
		country surveyyear wave treatstatus bustraining ///
		ownerage female married educyears ownertertiary childunder5 childaged5to12 adult65andover digitspan raven ///
		competition1 plannedsector

/*		
save SLKFEMBUSTRAINING1_2, replace	
*/	
********************************************************************************
*R2 potential
/*
merge 1:1 sheno using "Sri Lanka Business Training/R2_potential.dta", nogenerate keep(3)
*/
********************************************************************************

*Survey took place between in September 2009, so I take September 15, 2009 as approx. midpoint
g excrate=0.00870 
g excratemonth="9-2009" 

*Keep if operating a business/in self-employment
keep if q1_2==4


********************************************************************************
*Firm characteristics
********************************************************************************
*Age of the firm in years (I use the time of the r2 survey)
g helpivwdate="9"+"-"+"2009"
g ivwmonth=monthly(helpivwdate,"MY")

g date_yy=2009

g helpbusstartdate=string(q3_10m)+"-"+string(q3_10y)
g busstartdate=monthly(helpbusstartdate,"MY")

g agefirm=(ivwmonth-busstartdate)/12 if busstartdate!=.

replace agefirm=date_yy-q3_10y if agefirm==.

replace agefirm=round(agefirm,0.5)

*Code it based on ISIC rev. 3
tostring q3_2, replace
g q3_2h=substr(q3_2, 1,2)
destring q3_2h, replace

*Firm is in retail trade
g retail=(q3_2h>=50 & q3_2h<=54) if q3_2h!=.

*Firm is in manufacturing sector
g manuf=(q3_2h>=15 & q3_2h<=37) if q3_2h!=.

*Firm is in service sector
g services=(q3_2h>=55 & q3_2h<=93) if q3_2h!=.

*Firm is in other sector
g othersector=((q3_2h>=10 & q3_2h<=14) | (q3_2h>=40 & q3_2h<=45) | (q3_2h>=95 & q3_2h<=99)) if q3_2h!=.

rename q3_2 sector
destring sector, replace

*Employees
gen p_spouse = q3_13b_1 if q3_13e_1==1 | q3_13e_1==2
gen p_child = q3_13b_2 if q3_13e_2==1 | q3_13e_2==2
gen p_sibling = q3_13b_3 if q3_13e_3==1 | q3_13e_3==2
gen p_parent = q3_13b_4 if q3_13e_4==1 | q3_13e_4==2
gen p_other_relative = q3_13b_5 if q3_13e_5==1 | q3_13e_5==2
gen p_non_relative = q3_13b_6 if q3_13e_6==1 | q3_13e_6==2
gen up_spouse = q3_13b_1 if q3_13e_1==3 
gen up_child = q3_13b_2 if q3_13e_2==3
gen up_sibling = q3_13b_3 if q3_13e_3==3
gen up_parent = q3_13b_4 if q3_13e_4==3
gen up_other_relative = q3_13b_5 if q3_13e_5==3
gen up_non_relative = q3_13b_6 if q3_13e_6==3

foreach x in p_spouse p_child p_sibling p_parent p_other_relative p_non_relative up_spouse up_child up_sibling up_parent up_other_relative up_non_relative {
recode `x' (.=0)
}

gen employees = p_spouse+p_child+p_sibling+p_parent+p_other_relative+p_non_relative
gen totalworkersworkers = up_spouse+up_child+up_sibling+up_parent+up_other_relative+up_non_relative+employees


*Profits last month
replace q5_9=. if q5_9==999 
rename q5_9 profits

*Sales last month
rename q5_6 sales

*Hours worked in self-employment in last month
*based on hours worked  in last week
replace q3_5a=. if q3_5a==999
g hours=q3_5a*(30/7) 

*based on hours worked  in a normal week
replace q3_5b=. if q3_5b==999
g hoursnormal=q3_5b*(30/7) 

*Capital stock
g capitalstock=q5_1a_7

*Inventories
g inventories=q5_3
replace inventories=0 if q5_2==2

********************************************************************************
*Competition facing firm
********************************************************************************
*Replace competition so that it is only given if actual sector == current sector
replace competition1=. if sector!=plannedsector

keep 	sheno ///
		country surveyyear wave treatstatus bustraining ///
		ownerage female married educyears ownertertiary childunder5 childaged5to12 adult65andover digitspan raven ///
		agefirm retail manuf services othersector sector employees totalworkers ///
		competition1 ///
		excrate excratemonth ///
		profits sales hours hoursnormal capitalstock inventories					

/*		
save SLKFEMBUSTRAINING1_2, replace
*/
/*
append using SLKFEMBUSTRAINING1_1, generate(current)
*/
foreach var of varlist 	surveyyear ///
						ownerage female married educyears ownertertiary childunder5 childaged5to12 adult65andover digitspan raven ///
						agefirm retail manuf services othersector sector employees totalworkers ///
						competition1 ///
						excrate excratemonth ///
						profits sales hours hoursnormal capitalstock inventories	{
rename `var' `var'1
}	

/*
save SLKFEMBUSTRAINING1, replace
*/
********************************************************************************
/*
import excel "Sri Lanka Business Training/Gender R1-R6 Panel Tracking Survival 151215 DH.xls", sheet("R2") firstrow clear

merge 1:1 sheno using "SLKFEMBUSTRAINING1.dta", keep(1 3)
*/
egen testnonmiss=rowmiss(ownerage-inventories)


g BL=(Complete1Incomplete2Dropp==1 & (Group=="A" | Group=="B")) | ((Group=="A" | Group=="B") & Complete1Incomplete2Dropp==2 & testnonmiss<32)
replace BL=0 if notpartofBL==1

keep 	sheno BL ///
		country surveyyear wave treatstatus bustraining ///
		ownerage female married educyears ownertertiary childunder5 childaged5to12 adult65andover digitspan raven ///
		agefirm retail manuf services othersector sector employees totalworkers ///
		competition1 ///
		excrate* ///
		profits sales hours* capitalstock inventories		
/*
save SLKFEMBUSTRAINING1, replace
*/	
********************************************************************************

********************************************************************************
*Panel variables
********************************************************************************

********************************************************************************#
*Round 2 - current (includes current of R1 and R2 and potential owners who opened business by R2)
/*
import excel "Sri Lanka Business Training/Gender R1-R6 Panel Tracking Survival 151215 DH.xls", sheet("R3") firstrow clear

merge 1:1 sheno using "Sri Lanka Business Training/R3_current.dta", nogenerate keep(1 3)
*/
********************************************************************************#

*Survival
g survival=(q1_1g==1 | q1_1g==3 | q1_1g==5 | q1_1g==6) if q1_1g!=.
replace survival=0 if IfnotReasoncode==4 | IfnotReasoncode==5

*Main activity after closing business
label define mainactivity 	1 "Working for a wage" ///
							2 "Looking for work" ///
							3 "Operating a different business" ///
							4 "Housework or looking after children"

g mainactivity=q1_13 if q1_13!=5
label values mainactivity mainactivity							

*Reason for closure
*In question 2.9 business owners were asked to give the two main reasons for closure -> I only consider answers if they gave only one reason
g reasonclosure=4 if q2_9_1==1 & q2_9_4!=1 & q2_9_7!=1 & q2_9_8!=1 & q2_9_9!=1 
replace reasonclosure=4 if q2_9_2==1 & q2_9_4!=1 & q2_9_7!=1 & q2_9_8!=1 & q2_9_9!=1
replace reasonclosure=4 if q2_9_3==1 & q2_9_4!=1 & q2_9_7!=1 & q2_9_8!=1 & q2_9_9!=1 
replace reasonclosure=4 if q2_9_5==1 & q2_9_4!=1 & q2_9_7!=1 & q2_9_8!=1 & q2_9_9!=1 
replace reasonclosure=4 if q2_9_6==1 & q2_9_4!=1 & q2_9_7!=1 & q2_9_8!=1 & q2_9_9!=1 
replace reasonclosure=1 if q2_9_4==1 & q2_9_1!=1 & q2_9_2!=1 & q2_9_3!=1 & q2_9_5!=1 & q2_9_6!=1 & q2_9_7!=1 & q2_9_8!=1 & q2_9_9!=1
replace reasonclosure=3 if q2_9_8==1 & q2_9_1!=1 & q2_9_2!=1 & q2_9_3!=1 & q2_9_5!=1 & q2_9_6!=1 & q2_9_7!=1 & q2_9_4!=1 & q2_9_9!=1
replace reasonclosure=6 if q2_9_7==1 & q2_9_1!=1 & q2_9_2!=1 & q2_9_3!=1 & q2_9_5!=1 & q2_9_6!=1 & q2_9_4!=1 & q2_9_8!=1 & q2_9_9!=1
replace reasonclosure=9 if q2_9_9==1 & q2_9_1!=1 & q2_9_2!=1 & q2_9_3!=1 & q2_9_5!=1 & q2_9_6!=1 & q2_9_4!=1 & q2_9_8!=1 & q2_9_7!=1

replace reasonclosure=1 if q2_12==1
replace reasonclosure=2 if q2_12==2
replace reasonclosure=4 if q2_12==3
replace reasonclosure=3 if q2_12==4
replace reasonclosure=10 if q2_12==5
replace reasonclosure=5 if q2_12==6
replace reasonclosure=6 if q2_12==7
replace reasonclosure=9 if q2_12==8

label define closereason 1 "making a loss" 2 "sickness" 3 "care for family" 4 "better wage job" 5 "migrate abroad" 6 "married" 7 "shut down by govt." 8 "taken from me" 9 "other" 10 "better business opportunity" 11 "catastrophe"

label values reasonclosure closereason

*New firm started since last survey
g newfirmstarted=q1_13==3 | q1_13==5 if q1_13!=.

*Sales in last month
rename q7_5 sales

*Profits in last month
rename q7_8 profits

*Hours worked in self-employment in last month - old business
*based on hours worked  in last week
g hours=q6_5a*(30/7) 

*based on hours worked  in a normal week
g hoursnormal=q6_5b*(30/7) 

*Hours worked in self-employment in last month - new business
*based on hours worked  in last week
replace hours=q3_2a*(30/7) if hours==.

*based on hours worked  in a normal week
replace hoursnormal=q3_2b*(30/7) if hoursnormal==.

*Labor earnings from all labor, including the business, in last month
g monthlywagelaborincome=q2_5*(30/7)
egen laborincome=rowtotal(monthlywagelaborincome profits), m

*Firm attrits from survey
g attrit=(Complete1Incomplete2Dropp!=1)

*Excrate and excratemonth
*Survey took place between in January 2010, so I take January 15, 2010 as approx. midpoint
g excrate=0.00873 
g excratemonth="1-2010" 

*Surveyyear
g surveyyear=2010


keep 	sheno ///
		surveyyear ///
		excrate excratemonth ///
		profits sales hours hoursnormal laborincome ///
		survival newfirmstarted attrit mainactivity reasonclosure q2_9* q2_12


foreach var of varlist 	surveyyear ///
						excrate excratemonth ///
						profits sales hours hoursnormal laborincome ///
						survival newfirmstarted attrit mainactivity reasonclosure q2_9* q2_12{
rename `var' `var'2
}	

/*
save SLKFEMBUSTRAINING2, replace
*/

********************************************************************************
*Round 3 - current, single business (includes current of R1 and R2 and potential owners who opened business by R2)
/*
import excel "Sri Lanka Business Training/Gender R1-R6 Panel Tracking Survival 151215 DH.xls", sheet("R4") firstrow clear

merge 1:1 sheno using "Sri Lanka Business Training/R4_current.dta", keep(1 3)
*/
********************************************************************************

g in_single_q=_merge==3
drop _merge

*Survival
g survival=(q1_1c==1 | q1_1c==3 | q1_1c==5 | q1_1c==6) if q1_1c!=.
replace survival=0 if IfnotReasoncode==4 | IfnotReasoncode==5

*Main activity after closing business
label define mainactivity 	1 "Working for a wage" ///
							2 "Looking for work" ///
							3 "Operating a different business" ///
							4 "Housework or looking after children"

g mainactivity=q1_13 if q1_13!=5
label values mainactivity mainactivity		

*Reason for closure
*In question 2.9 business owners were asked to give the two main reasons for closure -> I only consider answers if they gave only one reason
g reasonclosure=4 if q2_9_1==1 & q2_9_4!=1 & q2_9_7!=1 & q2_9_8!=1 & q2_9_9!=1 
replace reasonclosure=4 if q2_9_2==1 & q2_9_4!=1 & q2_9_7!=1 & q2_9_8!=1 & q2_9_9!=1
replace reasonclosure=4 if q2_9_3==1 & q2_9_4!=1 & q2_9_7!=1 & q2_9_8!=1 & q2_9_9!=1 
replace reasonclosure=4 if q2_9_5==1 & q2_9_4!=1 & q2_9_7!=1 & q2_9_8!=1 & q2_9_9!=1 
replace reasonclosure=4 if q2_9_6==1 & q2_9_4!=1 & q2_9_7!=1 & q2_9_8!=1 & q2_9_9!=1 
replace reasonclosure=1 if q2_9_4==1 & q2_9_1!=1 & q2_9_2!=1 & q2_9_3!=1 & q2_9_5!=1 & q2_9_6!=1 & q2_9_7!=1 & q2_9_8!=1 & q2_9_9!=1
replace reasonclosure=3 if q2_9_8==1 & q2_9_1!=1 & q2_9_2!=1 & q2_9_3!=1 & q2_9_5!=1 & q2_9_6!=1 & q2_9_7!=1 & q2_9_4!=1 & q2_9_9!=1
replace reasonclosure=6 if q2_9_7==1 & q2_9_1!=1 & q2_9_2!=1 & q2_9_3!=1 & q2_9_5!=1 & q2_9_6!=1 & q2_9_4!=1 & q2_9_8!=1 & q2_9_9!=1
replace reasonclosure=9 if q2_9_9==1 & q2_9_1!=1 & q2_9_2!=1 & q2_9_3!=1 & q2_9_5!=1 & q2_9_6!=1 & q2_9_4!=1 & q2_9_8!=1 & q2_9_7!=1

replace reasonclosure=1 if q2_12==1
replace reasonclosure=2 if q2_12==2
replace reasonclosure=4 if q2_12==3
replace reasonclosure=3 if q2_12==4
replace reasonclosure=10 if q2_12==5
replace reasonclosure=5 if q2_12==6
replace reasonclosure=6 if q2_12==7
replace reasonclosure=9 if q2_12==8

label define closereason 1 "making a loss" 2 "sickness" 3 "care for family" 4 "better wage job" 5 "migrate abroad" 6 "married" 7 "shut down by govt." 8 "taken from me" 9 "other" 10 "better business opportunity" 11 "catastrophe"

label values reasonclosure closereason
					

*New firm started since last survey
g newfirmstarted=q1_13==3 | q1_13==5 if q1_13!=.

*Sales in last month
rename q7_5 sales

*Profits in last month
replace q7_8=. if q7_8==999
rename q7_8 profits

*Hours worked in self-employment in last month 
*based on hours worked  in last week
replace q6_5a=q6_5a*(30/7) 
replace q3_2a=q3_2a*(30/7) 
egen hours=rowtotal(q6_5a q3_2a),m


*based on hours worked  in a normal week
replace q6_5b=q6_5b*(30/7) 
replace q3_2b=q3_2b*(30/7) 
egen hoursnormal=rowtotal(q6_5b q3_2b),m


*Labor earnings from all labor, including the business, in last month
g monthlywagelaborincome=q2_5*(30/7)
egen laborincome=rowtotal(monthlywagelaborincome profits), m

*Firm attrits from survey
g attrit=(Complete1Incomplete2Dropp!=1)

*Excrate and excratemonth
*Survey took place between in September 2010, so I take September 15, 2010 as approx. midpoint
g excrate=0.00888
g excratemonth="9-2010" 

*Surveyyear
g surveyyear=2010


keep 	sheno in_single_q ///
		surveyyear ///
		excrate excratemonth ///
		profits sales hours hoursnormal laborincome ///
		survival newfirmstarted attrit mainactivity reasonclosure q2_9* q2_12


foreach var of varlist 	surveyyear ///
						excrate excratemonth ///
						profits sales hours hoursnormal laborincome ///
						survival newfirmstarted attrit mainactivity reasonclosure q2_9* q2_12{
rename `var' `var'3
}	

/*
save SLKFEMBUSTRAINING3_1, replace
*/

********************************************************************************
*Round 3 - multiple businesses (includes current of R1 and R2 and potential owners who opened business by R2)
/*
import excel "Sri Lanka Business Training/Gender R1-R6 Panel Tracking Survival 151215 DH.xls", sheet("R4") firstrow clear

merge 1:1 sheno using "Sri Lanka Business Training/R4_multi.dta", keep(1 3)
*/
********************************************************************************

g in_multi_q=_merge==3
drop _merge

*Survival
g survival=1 if q1_6==5 | q1_6==6 | q1_6==7
replace survival=0 if q1_6==1 | q1_6==2 | q1_6==3 | q1_6==4

replace survival=0 if IfnotReasoncode==4 | IfnotReasoncode==5

*Main activity after closing business
label define mainactivity 	1 "Working for a wage" ///
							2 "Looking for work" ///
							3 "Operating a different business" ///
							4 "Housework or looking after children"

g mainactivity=q1_6 if q1_6!=5 & q1_6!=6 & q1_6!=7
label values mainactivity mainactivity							

*Reason for closure
*In question 2.9 business owners were asked to give the two main reasons for closure -> I only consider answers if they gave only one reason
g reasonclosure=4 if q2_9_1==1 & q2_9_4!=1 & q2_9_7!=1 & q2_9_8!=1 & q2_9_9!=1 
replace reasonclosure=4 if q2_9_2==1 & q2_9_4!=1 & q2_9_7!=1 & q2_9_8!=1 & q2_9_9!=1
replace reasonclosure=4 if q2_9_3==1 & q2_9_4!=1 & q2_9_7!=1 & q2_9_8!=1 & q2_9_9!=1 
replace reasonclosure=4 if q2_9_5==1 & q2_9_4!=1 & q2_9_7!=1 & q2_9_8!=1 & q2_9_9!=1 
replace reasonclosure=4 if q2_9_6==1 & q2_9_4!=1 & q2_9_7!=1 & q2_9_8!=1 & q2_9_9!=1 
replace reasonclosure=1 if q2_9_4==1 & q2_9_1!=1 & q2_9_2!=1 & q2_9_3!=1 & q2_9_5!=1 & q2_9_6!=1 & q2_9_7!=1 & q2_9_8!=1 & q2_9_9!=1
replace reasonclosure=3 if q2_9_8==1 & q2_9_1!=1 & q2_9_2!=1 & q2_9_3!=1 & q2_9_5!=1 & q2_9_6!=1 & q2_9_7!=1 & q2_9_4!=1 & q2_9_9!=1
replace reasonclosure=6 if q2_9_7==1 & q2_9_1!=1 & q2_9_2!=1 & q2_9_3!=1 & q2_9_5!=1 & q2_9_6!=1 & q2_9_4!=1 & q2_9_8!=1 & q2_9_9!=1
replace reasonclosure=9 if q2_9_9==1 & q2_9_1!=1 & q2_9_2!=1 & q2_9_3!=1 & q2_9_5!=1 & q2_9_6!=1 & q2_9_4!=1 & q2_9_8!=1 & q2_9_7!=1

replace reasonclosure=1 if q2_12==1
replace reasonclosure=2 if q2_12==2
replace reasonclosure=4 if q2_12==3
replace reasonclosure=3 if q2_12==4
replace reasonclosure=10 if q2_12==5
replace reasonclosure=5 if q2_12==6
replace reasonclosure=6 if q2_12==7
replace reasonclosure=9 if q2_12==8

label define closereason 1 "making a loss" 2 "sickness" 3 "care for family" 4 "better wage job" 5 "migrate abroad" 6 "married" 7 "shut down by govt." 8 "taken from me" 9 "other" 10 "better business opportunity" 11 "catastrophe"

label values reasonclosure closereason
	
*New firm started since last survey
g newfirmstarted=(q1_6==3 | q1_6==5 | q1_6==6) if  q1_6!=.

*Sales in last month
rename q7_5 sales

*Profits in last month
rename q7_8 profits

*Hours worked in self-employment in last month 
*based on hours worked  in last week
forvalues i=1/3{
replace q6_5a_b`i'=q6_5a_b`i'*(30/7) 
}
replace q3_2a=q3_2a*(30/7) 
egen hours=rowtotal(q6_5a_b1 q6_5a_b2 q6_5a_b3 q3_2a),m


*based on hours worked  in a normal week
forvalues i=1/3{
replace q6_5b_b`i'=q6_5b_b`i'*(30/7) 
}
replace q3_2b=q3_2b*(30/7) 
egen hoursnormal=rowtotal(q6_5b_b1 q6_5b_b2 q6_5b_b3 q3_2b),m


*Labor earnings from all labor, including the business, in last month
g monthlywagelaborincome=q2_5*(30/7)
egen laborincome=rowtotal(monthlywagelaborincome profits), m

*Firm attrits from survey
g attrit=(Complete1Incomplete2Dropp!=1)

/*Question 1.6 was not asked if there is no change in the lines of business 
(i.e. answers to 1.2a B1 and 1.2a B2 are 2) and no change in the business location 
(i.e. answers to 1.2b B1 and 1.2b B2 are 2) and not closed either of the businesses 
operating in Jan 2010 (i.e. answers to 1.2c B1 and 1.2c B2 are 2) and not started 
any new business since Jan 2010 (i.e. answer to 1.2d is 2) then go to section 6.
(see questionnaire) -> recode survival and newfirmstarted in these cases */

replace survival=1 if survival==. & attrit==0 & in_==1
replace newfirmstarted=0 if newfirmstarted==. & attrit==0 & in_==1


*Excrate and excratemonth
*Survey took place between in September 2010, so I take September 15, 2010 as approx. midpoint
g excrate=0.00888
g excratemonth="9-2010" 

*Surveyyear
g surveyyear=2010


keep 	sheno in_multi_q ///
		surveyyear ///
		excrate excratemonth ///
		profits sales hours hoursnormal laborincome ///
		survival newfirmstarted attrit mainactivity reasonclosure q2_9* q2_12


foreach var of varlist 	surveyyear ///
						excrate excratemonth ///
						profits sales hours hoursnormal laborincome ///
						survival newfirmstarted attrit mainactivity reasonclosure q2_9* q2_12{
rename `var' `var'3
}	

/*
save SLKFEMBUSTRAINING3_2, replace

append using SLKFEMBUSTRAINING3_1
*/

g in_help=in_multi_q if in_multi_q!=.
replace in_help=in_single_q if in_single_q!=.

bysort sheno: egen in_helptotal=total(in_help)

duplicates drop sheno if in_helptotal==0 & in_help==0, force

drop if in_helptotal==1 & in_help==0

g multi3=in_multi_q==1 if in_helptotal!=0

drop in_*

/*
save SLKFEMBUSTRAINING3, replace
*/
********************************************************************************
*Round 4 - current, single business (includes current of R1 and R2 and potential owners who opened business by R2)
/*
import excel "Sri Lanka Business Training/Gender R1-R6 Panel Tracking Survival 151215 DH.xls", sheet("R5") firstrow clear

merge 1:1 sheno using "Sri Lanka Business Training/R5_current.dta", keep(1 3)
*/
********************************************************************************

g in_single_q=_merge==3
drop _merge

*Survival
gen survival=1 if qf4==1|qf4==3|qf4==4
replace survival=0 if qf4==2
replace survival=(q1_1c==1 | q1_1c==3 | q1_1c==5 | q1_1c==6) if q1_1c!=.
replace survival=0 if IfnotReasoncode==4 | IfnotReasoncode==5

*Main activity after closing business
label define mainactivity 	1 "Working for a wage" ///
							2 "Looking for work" ///
							3 "Operating a different business" ///
							4 "Housework or looking after children"

g mainactivity=q1_13 if q1_13!=5
label values mainactivity mainactivity	


*Reason for closure
*In question 2.9 business owners were asked to give the two main reasons for closure -> I only consider answers if they gave only one reason
g reasonclosure=4 if q2_9_1==1 & q2_9_4!=1 & q2_9_7!=1 & q2_9_8!=1 & q2_9_9!=1 
replace reasonclosure=4 if q2_9_2==1 & q2_9_4!=1 & q2_9_7!=1 & q2_9_8!=1 & q2_9_9!=1
replace reasonclosure=4 if q2_9_3==1 & q2_9_4!=1 & q2_9_7!=1 & q2_9_8!=1 & q2_9_9!=1 
replace reasonclosure=4 if q2_9_5==1 & q2_9_4!=1 & q2_9_7!=1 & q2_9_8!=1 & q2_9_9!=1 
replace reasonclosure=4 if q2_9_6==1 & q2_9_4!=1 & q2_9_7!=1 & q2_9_8!=1 & q2_9_9!=1 
replace reasonclosure=1 if q2_9_4==1 & q2_9_1!=1 & q2_9_2!=1 & q2_9_3!=1 & q2_9_5!=1 & q2_9_6!=1 & q2_9_7!=1 & q2_9_8!=1 & q2_9_9!=1
replace reasonclosure=3 if q2_9_8==1 & q2_9_1!=1 & q2_9_2!=1 & q2_9_3!=1 & q2_9_5!=1 & q2_9_6!=1 & q2_9_7!=1 & q2_9_4!=1 & q2_9_9!=1
replace reasonclosure=6 if q2_9_7==1 & q2_9_1!=1 & q2_9_2!=1 & q2_9_3!=1 & q2_9_5!=1 & q2_9_6!=1 & q2_9_4!=1 & q2_9_8!=1 & q2_9_9!=1
replace reasonclosure=9 if q2_9_9==1 & q2_9_1!=1 & q2_9_2!=1 & q2_9_3!=1 & q2_9_5!=1 & q2_9_6!=1 & q2_9_4!=1 & q2_9_8!=1 & q2_9_7!=1

replace reasonclosure=1 if q2_12==1
replace reasonclosure=2 if q2_12==2
replace reasonclosure=4 if q2_12==3
replace reasonclosure=3 if q2_12==4
replace reasonclosure=10 if q2_12==5
replace reasonclosure=5 if q2_12==6
replace reasonclosure=6 if q2_12==7
replace reasonclosure=9 if q2_12==8

label define closereason 1 "making a loss" 2 "sickness" 3 "care for family" 4 "better wage job" 5 "migrate abroad" 6 "married" 7 "shut down by govt." 8 "taken from me" 9 "other" 10 "better business opportunity" 11 "catastrophe"

label values reasonclosure closereason
							

*New firm started since last survey
g newfirmstarted=q1_13==3 | q1_13==5 if q1_13!=.

*Sales in last month
rename q7_5a sales

*Profits in last month
replace q7_8a=. if q7_8a==999
rename q7_8a profits

*Hours worked in self-employment in last month 
*based on hours worked  in last week
g hours=q7_0a_a*(30/7)

*based on hours worked  in a normal week
replace q7_0a_b=. if  q7_0a_b==999
gen hoursnormal=q7_0a_b*(30/7)


*Labor earnings from all labor, including the business, in last month
g monthlywagelaborincome=q2_5*(30/7)
egen laborincome=rowtotal(monthlywagelaborincome profits), m

*Firm attrits from survey
g attrit=(Complete1Incomplete2Dropp!=1 & (qf4==5 | qf4==.))
replace attrit=0 if survival!=.

*Excrate and excratemonth
*Survey took place in June 2011, so I take June 15, 2011 as approx. midpoint
g excrate=0.00912
g excratemonth="6-2011" 

*Surveyyear
g surveyyear=2011


keep 	sheno in_single_q ///
		surveyyear ///
		excrate excratemonth ///
		profits sales hours hoursnormal laborincome ///
		survival newfirmstarted attrit mainactivity reasonclosure q2_9* q2_12


foreach var of varlist 	surveyyear ///
						excrate excratemonth ///
						profits sales hours hoursnormal laborincome ///
						survival newfirmstarted attrit mainactivity reasonclosure q2_9* q2_12{
rename `var' `var'4
}	

/*
save SLKFEMBUSTRAINING4_1, replace
*/

********************************************************************************
*Round 4 - multiple businesses (includes current of R1 and R2 and potential owners who opened business by R2)
/*
import excel "Sri Lanka Business Training/Gender R1-R6 Panel Tracking Survival 151215 DH.xls", sheet("R5") firstrow clear

merge 1:1 sheno using "Sri Lanka Business Training/R5_multi.dta", keep(1 3)
*/
********************************************************************************

g in_multi_q=_merge==3
drop _merge

*Survival
gen survival=1 if qf4_1==1
replace survival=1 if qf4_2==1
replace survival=0 if qf4_3==1
replace survival=1 if qf4_4==1
replace survival=1 if qf4_5==1
replace survival=1 if qf4_6==1
replace survival=. if qf4_7==1

replace survival=1 if q1_6==5 | q1_6==6 | q1_6==7
replace survival=0 if q1_6==1 | q1_6==2 | q1_6==3 | q1_6==4

replace survival=0 if IfnotReasoncode==4 | IfnotReasoncode==5


*Main activity after closing business
label define mainactivity 	1 "Working for a wage" ///
							2 "Looking for work" ///
							3 "Operating a different business" ///
							4 "Housework or looking after children"

g mainactivity=q1_6 if q1_6!=5 & q1_6!=6 & q1_6!=7
label values mainactivity mainactivity							

*Reason for closure
*In question 2.9 business owners were asked to give the two main reasons for closure -> I only consider answers if they gave only one reason
g reasonclosure=4 if q2_9_1==1 & q2_9_4!=1 & q2_9_7!=1 & q2_9_8!=1 & q2_9_9!=1 
replace reasonclosure=4 if q2_9_2==1 & q2_9_4!=1 & q2_9_7!=1 & q2_9_8!=1 & q2_9_9!=1
replace reasonclosure=4 if q2_9_3==1 & q2_9_4!=1 & q2_9_7!=1 & q2_9_8!=1 & q2_9_9!=1 
replace reasonclosure=4 if q2_9_5==1 & q2_9_4!=1 & q2_9_7!=1 & q2_9_8!=1 & q2_9_9!=1 
replace reasonclosure=4 if q2_9_6==1 & q2_9_4!=1 & q2_9_7!=1 & q2_9_8!=1 & q2_9_9!=1 
replace reasonclosure=1 if q2_9_4==1 & q2_9_1!=1 & q2_9_2!=1 & q2_9_3!=1 & q2_9_5!=1 & q2_9_6!=1 & q2_9_7!=1 & q2_9_8!=1 & q2_9_9!=1
replace reasonclosure=3 if q2_9_8==1 & q2_9_1!=1 & q2_9_2!=1 & q2_9_3!=1 & q2_9_5!=1 & q2_9_6!=1 & q2_9_7!=1 & q2_9_4!=1 & q2_9_9!=1
replace reasonclosure=6 if q2_9_7==1 & q2_9_1!=1 & q2_9_2!=1 & q2_9_3!=1 & q2_9_5!=1 & q2_9_6!=1 & q2_9_4!=1 & q2_9_8!=1 & q2_9_9!=1
replace reasonclosure=9 if q2_9_9==1 & q2_9_1!=1 & q2_9_2!=1 & q2_9_3!=1 & q2_9_5!=1 & q2_9_6!=1 & q2_9_4!=1 & q2_9_8!=1 & q2_9_7!=1

replace reasonclosure=1 if q2_12==1
replace reasonclosure=2 if q2_12==2
replace reasonclosure=4 if q2_12==3
replace reasonclosure=3 if q2_12==4
replace reasonclosure=10 if q2_12==5
replace reasonclosure=5 if q2_12==6
replace reasonclosure=6 if q2_12==7
replace reasonclosure=9 if q2_12==8

label define closereason 1 "making a loss" 2 "sickness" 3 "care for family" 4 "better wage job" 5 "migrate abroad" 6 "married" 7 "shut down by govt." 8 "taken from me" 9 "other" 10 "better business opportunity" 11 "catastrophe"

label values reasonclosure closereason
							
*New firm started since last survey
g newfirmstarted=(q1_6==3 | q1_6==5 | q1_6==6) if  q1_6!=.

*Sales in last month
rename q7_5a sales

*Profits in last month
rename q7_8a profits

*Hours worked in self-employment in last month 
*based on hours worked  in last week
g hours=q7_0a_a*(30/7)

*based on hours worked  in a normal week
gen hoursnormal=q7_0a_b*(30/7)

*Labor earnings from all labor, including the business, in last month
g monthlywagelaborincome=q2_5*(30/7)
egen laborincome=rowtotal(monthlywagelaborincome profits), m

*Firm attrits from survey
g attrit=(Complete1Incomplete2Dropp!=1 & qf4_1==. & qf4_2==. & qf4_3==. & qf4_4==. & qf4_5==. & qf4_6==.)
replace attrit=0 if survival!=.


/*Question 1.6 was not asked if there is no change in the lines of business 
(i.e. answers to 1.2a B1 and 1.2a B2 are 2) and no change in the business location 
(i.e. answers to 1.2b B1 and 1.2b B2 are 2) and not closed either of the businesses 
operating in Jan 2010 (i.e. answers to 1.2c B1 and 1.2c B2 are 2) and not started 
any new business since Jan 2010 (i.e. answer to 1.2d is 2) then go to section 6.
(see questionnaire) -> recode survival and newfirmstarted in these cases */

replace survival=1 if survival==. & attrit==0 & in_==1
replace newfirmstarted=0 if newfirmstarted==. & attrit==0 & in_==1


*Excrate and excratemonth
*Survey took place in June 2011, so I take June 15, 2011 as approx. midpoint
g excrate=0.00912
g excratemonth="6-2011" 

*Surveyyear
g surveyyear=2011


keep 	sheno in_multi_q ///
		surveyyear ///
		excrate excratemonth ///
		profits sales hours hoursnormal laborincome ///
		survival newfirmstarted attrit mainactivity reasonclosure q2_9* q2_12


foreach var of varlist 	surveyyear ///
						excrate excratemonth ///
						profits sales hours hoursnormal laborincome ///
						survival newfirmstarted attrit mainactivity reasonclosure q2_9* q2_12{
rename `var' `var'4
}	

/*
save SLKFEMBUSTRAINING4_2, replace

append using SLKFEMBUSTRAINING4_1
*/
g in_help=in_multi_q if in_multi_q!=.
replace in_help=in_single_q if in_single_q!=.

bysort sheno: egen in_helptotal=total(in_help)

duplicates drop sheno if in_helptotal==0 & in_help==0, force

drop if in_helptotal==1 & in_help==0

g multi4=in_multi_q==1 if in_helptotal!=0

drop in_*

/*
save SLKFEMBUSTRAINING4, replace
*/
********************************************************************************
*Round 5 - potential and current
/*
import excel "Sri Lanka Business Training/Gender R1-R6 Panel Tracking Survival 151215 DH.xls", sheet("R6") firstrow clear
rename sheno SHENO
merge 1:1 SHENO using "Sri Lanka Business Training/GenderLongTerm.dta", nogenerate keep(1 3)
*/
********************************************************************************

gen surveyyear=2015

*Excrate and excratemonth
*Survey took place in June 2015, so I take June 15, 2015 as approx. midpoint
g excrate=0.00744
g excratemonth="6-2015" 


gen survival=1 if qf_4==1|qf_4==3|qf_4==4
replace survival=0 if qf_4==2
replace survival=1 if q1_1==1
replace survival=0 if q1_1==2
replace survival=0 if q4_4_b==1 | q4_4_e==1
gen neveroperate=q1_3==3

gen reasonclosure=q2_2d
label define closereason 1 "making a loss" 2 "sickness" 3 "care for family" 4 "better wage job" 5 "migrate abroad" 6 "married" 7 "shut down by govt." 8 "taken from me" 9 "other"
label values reasonclosure closereason

gen mainactivity=1 if q3_2<=2
replace mainactivity=2 if mainactivity==. & q3_8==1

*New firm start can only be coded for the main business
g helplastivwdate="6"+"-"+"2011"
g lastivwmonth=monthly(helplastivwdate,"MY")

g helpbusstartdate=string(q4_3_m)+"-"+string(q4_3_y) if q4_3_m!=999 & q4_3_y!=999
g busstartdate=monthly(helpbusstartdate,"MY")

g newfirmstarted=(busstartdate>lastivwmonth) if busstartdate!=.
replace newfirmstarted=(q4_3_y > 2011) if q4_3_y!=. & busstartdate==.
replace newfirmstarted=1 if q4_4_b==1 | q4_4_c==1 | q4_4_e==1

*If not operating a business, no firm start
replace newfirmstarted=0 if q1_1==2


gen laborincome=0
replace laborincome=q3_7*(30/7) if q3_7~=. & q3_7~=999
replace laborincome=laborincome+q4_10*(30/7) if q4_10~=. & q4_10~=999
gen hours=q5_6a*(30/7)
gen hoursnormal=q5_6b*(30/7)


gen employees= q5_9a+q5_9b

gen sales=q6_5a if q6_5a~=999
gen profits=q6_6a if q6_6a~=999
replace laborincome=laborincome+profits if profits~=.

*Firm attrits from survey
g attrit=(Complete1Incomplete2Dropp!=1 & (qf_4==5 | qf_4==.))
replace attrit=0 if survival!=.

rename q4_3_y r6_q4_3_y
rename q4_3_m r6_q4_3_m
rename q4_4* r6_q4_4*

rename SHENO sheno


keep 	sheno ///
		surveyyear ///
		excrate excratemonth ///
		profits sales hours hoursnormal laborincome employees ///
		survival newfirmstarted attrit mainactivity reasonclosure r6*


foreach var of varlist 	surveyyear ///
						excrate excratemonth ///
						profits sales hours hoursnormal laborincome employees ///
						survival newfirmstarted attrit mainactivity reasonclosure r6*{
rename `var' `var'5
}	

/*
save SLKFEMBUSTRAINING5, replace
*/



********************************************************************************

********************************************************************************
*Merge rounds 1-6 together
********************************************************************************

********************************************************************************
/*
use SLKFEMBUSTRAINING1, clear

merge 1:1 sheno using SLKFEMBUSTRAINING2, nogenerate
merge 1:1 sheno using SLKFEMBUSTRAINING3, nogenerate
merge 1:1 sheno using SLKFEMBUSTRAINING4, nogenerate
merge 1:1 sheno using SLKFEMBUSTRAINING5, nogenerate
*/
keep if BL==1

foreach x in profits sales hours hoursnormal employees {
rename `x'1 `x'
}

quietly: reshape long 	surveyyear excrate excratemonth ///
						capitalstock inventories competition1 ///
						ownerage female married educyears ownertertiary childunder5 childaged5to12 adult65andover digitspan raven ///
						agefirm retail manuf services othersector sector totalworkers ///
						multi, ///
						i(sheno) j(survey)
		
replace wave=survey

foreach x in  profits sales hours hoursnormal employees {
replace `x'=. if wave!=1
}	

*Recode survival, which has so far been coded from round to round so that it gives survival since baseline
*(Given that in the last round, the reference was the baseline, I do not have to recode survival5)
replace survival4=0 if survival2==1 & survival3==0 & newfirmstarted3==1
replace survival4=0 if survival2==0 & survival3==1 & newfirmstarted2==1
replace survival4=0 if survival2==0 & survival3==0 & newfirmstarted3==1
replace survival3=0 if survival2==0 & survival3==1 & newfirmstarted2==1


*Only keep if business is operating
forvalues i=2/5{
drop if survival`i'!=1 & wave==`i'
}

foreach x in sales profits survival mainactivity reasonclosure newfirmstarted hours hoursnormal laborincome attrit{
g `x'_4mths=`x'2 if wave==1
drop `x'2
g `x'_1yr=`x'3 if wave==1
drop `x'3
g `x'_1p75yrs=`x'4 if wave==1
drop `x'4
g `x'_5p75yrs=`x'5 if wave==1
drop `x'5
}	

foreach x in employees{
g `x'_5p75yrs=`x'5 if wave==1
drop `x'5
}


ds q2_9* q2_12* r6*, has(type numeric)
foreach var of varlist `r(varlist)'{
replace `var'=. if wave!=1
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
egen `var'=group(sheno)
tostring `var', format("%04.0f") replace
replace `var'="SLKFEMBUSTRAINING"+"-"+`var'
}

g control=(treatstatus==0)

g surveyname="SLKFEMBUSTRAINING"

/*
save SLKFEMBUSTRAINING_masterfc,replace
*/
