********************************************************************************

********************************************************************************
**THIS DO-FILE PREPARES THE DATA FROM THE KENYA GET AHEAD BUSINESS TRAINING PROGRAM IMPACT EVALUATION SURVEY FOR COMBINATION INTO THE MASTER DATASET
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


use "Kenya GET Ahead/AllBaselineKenyaPublicUse.dta"


*Country
g country="Kenya"

*Surveyyear
g surveyyear=2013

*Wave
g wave=1


*Treatment status
g treatstatus=(rgroup==3)

*Firm has been assigned to business training
rename treated bustraining


*Local to USD exchange rate at time of survey
*Survey took place between June 3, 2013 and November 1, 2013, so I take August 15, 2013 as approx. midpoint
g excrate=0.00969

g excratemonth="8-2013"

********************************************************************************
*Owner and Household characteristics
********************************************************************************

*Age of owner
rename b_s1_15a ownerage

*Gender of owner
g female=(b_business_owner_gender==4 | b_business_owner_gender==5)

*Marital status of owner
g married=(b_s1_18==2)

*Education of owner
**Owner's education in years
rename b_s1_17 educyears

**Owner has tertiary education
g ownertertiary=(b_s1_16==14 | b_s1_16==15 | b_s1_16==16 | b_s1_16==17 | b_s1_16==18)

*Has child under 5
egen childunder5=anymatch(b_s1_30_01-b_s1_30_12), values(0/4)

*Has child aged 5 to 12
egen childaged5to12=anymatch(b_s1_30_01-b_s1_30_12), values(5/11)

*Has elderly member in household
foreach var of varlist b_s1_30_01-b_s1_30_12{
replace `var'=. if `var'>=555
}
egen helpmaxage=rowmax(b_s1_30_01-b_s1_30_12)
su helpmaxage
egen adult65andover=anymatch(b_s1_30_01-b_s1_30_12), values(65/`r(max)')

*Digit span recall of owner
g digitspan=3 if b_s13_1_a==2 
replace digitspan=4 if b_s13_1_a==1 & b_s13_1_b==2
replace digitspan=5 if b_s13_1_b==1 & b_s13_1_c==2
replace digitspan=6 if b_s13_1_c==1 & b_s13_1_d==2
replace digitspan=7 if b_s13_1_d==1 & b_s13_1_e==2
replace digitspan=8 if b_s13_1_e==1 & b_s13_1_f==2
replace digitspan=9 if b_s13_1_f==1 & b_s13_1_g==2
replace digitspan=10 if b_s13_1_g==1 & b_s13_1_h==2
replace digitspan=11 if b_s13_1_h==1

*Raven score of owner
replace b_s12_1_total_b=. if b_s12_1_total_b>12
g raven=b_s12_1_total_b/12

********************************************************************************
*Firm characteristics
********************************************************************************
*Age of the firm in years
replace date_yy=2013 if date_yy!=2013
replace b_s1_10_year=. if b_s1_10_year==999 | b_s1_10_year==888 | b_s1_10_year==0 | b_s1_10_year==99

g helpivwdate=string(date_mm)+"-"+string(date_yy)
g ivwmonth=monthly(helpivwdate,"MY")

g helpbusstartdate=string(b_s1_10_month)+"-"+string(b_s1_10_year) if b_s1_10_month!=999 & b_s1_10_year!=888
g busstartdate=monthly(helpbusstartdate,"MY")

g agefirm=(ivwmonth-busstartdate)/12 if ivwmonth!=. & busstartdate!=.
replace agefirm=0 if agefirm<0

replace agefirm=date_yy-b_s1_10_year if agefirm==. & date_yy!=. & b_s1_10_year!=.

replace agefirm=2013-b_s1_10_year if agefirm==. & b_s1_10_year!=.
replace agefirm=round(agefirm,0.5)

*Capital stock
g capitalstock=b_s5_1a_7

*Inventories
g inventories=b_s5_3
replace inventories=0 if b_s5_2==2

*Firm is in retail trade
g retail=(b_business_nature==3) if b_business_nature!=5

*Firm is in manufacturing sector
g manuf=(b_business_nature==1) if b_business_nature!=5

*Firm is in service sector
g services=(b_business_nature==2) if b_business_nature!=5

*Employees
replace numemployees=. if numemployees==999
rename numemployees employees

*Profits
rename b_s5_7 profits
replace profits=profits*(30/7) 

*Sales
rename b_s5_6b sales
replace sales=sales*(30/7) 

*Hours worked in self-employment in last month
*based on hours worked  in last week
replace b_s1_5_a=. if b_s1_5_a==888
g hours=b_s1_5_a*(30/7) 

*based on hours worked  in a normal week
replace b_s1_5_b=. if b_s1_5_b==999
g hoursnormal=b_s1_5_b*(30/7) 

*Worked as wage worker in last month
g wageworker=(b_s5_15==1) if b_s5_15!=9

*Labor income
rename b_s5_15b laborincome
replace laborincome=laborincome+profits

********************************************************************************
*Competition facing firm
********************************************************************************
*Number of competitors
replace b_s8_1=. if b_s8_1==999
rename b_s8_1 competition1

********************************************************************************
*Reason for starting business
********************************************************************************
rename b_s6_1d startreason


********************************************************************************
keep 	respondent_id ///
		country surveyyear wave treatstatus bustraining excrate excratemonth ///
		ownerage female married educyears ownertertiary childunder5 childaged5to12 adult65andover digitspan raven ///
		agefirm capitalstock inventories retail manuf services employees profits sales hours hoursnormal wageworker laborincome ///
		competition1 ///
		startreason

foreach var of varlist surveyyear wave treatstatus bustraining excrate excratemonth ///
		ownerage female married educyears ownertertiary childunder5 childaged5to12 adult65andover digitspan raven ///
		agefirm capitalstock inventories retail manuf services employees profits sales hours hoursnormal wageworker laborincome ///
		competition1 ///
		startreason {
rename `var' `var'1
}		
save KENYAGETAHEAD1, replace

merge 1:1 respondent_id using "Kenya GET Ahead/KenyaFirmDeathPanel.dta", nogenerate

rename bustraining1 bustraining
rename treatstatus1 treatstatus

g excratemonth2="8-2014"
g excratemonth3="4-2016"

forvalues i=2/3{
replace excrate`i'=1/excrate`i'
}

replace attrit3=(attrit3==0)


foreach var of varlist sales1 sales2 sales3 profits2 profits3 laborincome2 laborincome3{
replace `var'=`var'*(30/7)
}

*Generate main activity after closing business
g mainactivity2=1 if sec3_8_=="1"
replace mainactivity2=2 if sec3_8_=="2"
replace mainactivity2=3 if newfirmstarted2==1
replace mainactivity2=4 if sec3_8_=="3"
replace mainactivity2=5 if sec3_8_=="other"

g mainactivity3=1 if r3_sec3_10==1
replace mainactivity3=2 if r3_sec3_10==2
replace mainactivity3=3 if newfirmstarted3==1
replace mainactivity3=4 if r3_sec3_10==3
replace mainactivity3=5 if r3_sec3_10==4


label define mainactivity 	1 "Working for a wage" ///
							2 "Looking for work" ///
							3 "Operating a different business" ///
							4 "Housework or looking after children" ///
							5 "Other"

label values mainactivity* mainactivity	

*For  sec3_14_ business owners were asked to give the two main reasons for closure -> I only consider answers if they gave only one reason
g reasonclosure2=1 if sec3_14_=="4" | sec3_16_=="1"
replace reasonclosure2=2 if sec3_16_=="2"
replace reasonclosure2=3 if sec3_16_=="4"
replace reasonclosure2=4 if sec3_14_=="1" | sec3_14_=="1 2" | sec3_14_=="1 3" | sec3_14_=="3" | sec3_14_=="6" | sec3_16_=="3"  
replace reasonclosure2=5 if sec3_16_=="6"  
replace reasonclosure2=6 if sec3_16_=="7"
replace reasonclosure2=8 if sec3_16_=="8"
replace reasonclosure2=9 if sec3_14_=="other" | sec3_16_=="other"
replace reasonclosure2=10 if sec3_16_=="5"
replace reasonclosure2=11 if sec3_16_=="9"

replace reasonclosure2=1 if sec3_16__other=="LANDLORD HIKED RENT THAT SHE COULD NOT AFFORD" | sec3_16__other=="MOTHER PASSED ON AND SHE WAS THE SOLE SPONSOR OF BUSINESS" | sec3_16__other=="LACK OF CAPITAL" | sec3_16__other=="LACK OF FINANCE FOR THE BUSINESS"
replace reasonclosure2=3 if sec3_14__other=="USED BUSINESS MONEY TO PAY HOSPITAL BILLS FOR A SICK CHILD." | sec3_14__other=="CHILD WAS SICK AND COULD NOT RAISE MONEY FOR HOSPITAL BILL." | sec3_14__other=="SHE WENT TO NURSE HER SON WHO WAS ATTACKED BY DOGS" | sec3_16__other=="MATERNITY LEAVE" | sec3_16__other=="SHE IS ON MATERNITY LEAVE."| sec3_16__other=="TO LOOK AFTER THE BABY" | sec3_16__other=="WAS PREGNANT, WENT FOR MATERNITY LEAVE AND ALSO DUE TO LANDLORDS CONDITIONS. " | sec3_16__other=="MARTERNITY LEAVE" | sec3_16__other=="ON MATERNITY LEAVE"| sec3_16__other=="GAVE BIRTH AND HAD NOBODY TO LOOK AFTER HER BUSINESS."| sec3_16__other=="GAVE BIRTH AND IS STILL IN MARTERNITY LEAVE."| sec3_16__other=="SHE GAVE BIRTH AND IS STILL IN MARTERNITY LEAVE"| sec3_16__other=="MATERNITY LEAVE."| sec3_16__other=="WENT FOR MATERNITY LEAVE"| sec3_16__other=="SHE WENT ON MATERNITY LEAVE"| sec3_16__other=="TO TAKE CARE OF HER GRANDCHILDREN" | sec3_16__other=="WAS OVERWHELMED BY BUSINESS ACTIVITIES WITH  THE PREGNANCY"
replace reasonclosure2=6 if sec3_16__other=="WAS MARRIED"
replace reasonclosure2=11 if sec3_14__other=="THEFT AT BUSINESS PLACE"

g reasonclosure3=1 if r3_sec3_7a==1
replace reasonclosure3=2 if r3_sec3_7a==2
replace reasonclosure3=3 if r3_sec3_7a==4
replace reasonclosure3=4 if r3_sec3_7a==3
replace reasonclosure3=10 if r3_sec3_7a==5
replace reasonclosure3=5 if r3_sec3_7a==6
replace reasonclosure3=6 if r3_sec3_7a==7
replace reasonclosure3=7 if r3_sec3_7a==10
replace reasonclosure3=8 if r3_sec3_7a==8
replace reasonclosure3=9 if r3_sec3_7a==11
replace reasonclosure3=11 if r3_sec3_7a==9

replace reasonclosure3=1 if r3_sec3_7ai=="COMPETITION AND HIGH COST OF RENT." | respondent_id==30370036 | r3_sec3_7ai=="RELOCATED TO ANOTHER PLACE  THAT WAS VERY  FAR FROM THE  BUSINESS, COMMUTING BECOMES EXPENSIVE" | r3_sec3_7ai=="LACK  OF FINANCES" | r3_sec3_7ai=="LACK OF FINANCE"
replace reasonclosure3=2 if r3_sec3_7ai=="HEALTH BILLS CONSUMED ALL THE BUSINESS MONEY"
replace reasonclosure3=3 if r3_sec3_7ai=="ALOT OF EXPENSES IN PAYING SCHOOL FEES FOR 2 OF MY CHILDREN" | r3_sec3_7ai=="SHE WAS TOO TIRED TO LOOK FOR RAW MATERIALS DUE TO PREGNANCY" | r3_sec3_7ai=="SHE LOST HER HUSBAND THROUGH ACCIDENT" | r3_sec3_7ai=="GOING FOR MATERNITY LEAVE" | r3_sec3_7ai=="HER CHILD WAS SICK THUS SHE HAD TO CLOSE HER BUSINESS TO LOOK AFTER HER" | r3_sec3_7ai=="I WAS OVERWHELMED BY MANY RESPONSIBILITIES BOTH AT HOME AND BUSINESS" | r3_sec3_7ai=="TO TAKE CARE OF AN INFANT." | r3_sec3_7ai=="THE SPOUSE WANTED HER TO TAKE CARE OF THE FAMILY INCLUDING LOOKING AFTER THEIR LIVESTOCK." | r3_sec3_7ai=="THE FAMILY MEMBERS GOT SICK THEN SHE USED ALL THE MONEY CAPITAL  ON MEDICAL BILLS" | r3_sec3_7ai=="CLOSED BUSINESS AFTER LOSING A RELATIVE WHO DIED IN NAIROBI AND WAS FORCED TO GO LIVE THE BERIEVED FAMILY FOR SOME TIME."
replace reasonclosure3=4 if r3_sec3_7ai=="WENT TO VISIT A FRIEND IN NAIROBI,AND GOT A WAGE WORK." | r3_sec3_7ai=="RESPONDENT GOT EMPLOYED"
replace reasonclosure3=7 if r3_sec3_7ai=="THE BUSINESS PREMISE WAS BROUGHT DOWN BY THE COUNTY GOVERNMENT FOR ROAD RESERVE."
replace reasonclosure3=11 if r3_sec3_7ai=="THE BUSINESS WAS BROKEN INTO AND EVERYTHING WAS STOLEN" | r3_sec3_7ai=="ALL MY STOCK WAS STOLEN"
 
label define closereason 1 "making a loss" 2 "sickness" 3 "care for family" 4 "better wage job" 5 "migrate abroad" 6 "married" 7 "shut down by govt." 8 "taken from me" 9 "other" 10 "better business opportunity" 11 "catastrophe"

label values reasonclosure* closereason

quietly: reshape long 	surveyyear wave excrate excratemonth ///
						ownerage female married educyears ownertertiary childunder5 childaged5to12 adult65andover digitspan raven ///
						startreason agefirm capitalstock inventories retail manuf services employees profits sales hours hoursnormal wageworker ///
						competition1, ///
						i(respondent_id) j(survey)
						
replace wave=survey

*Since we are using data from 2 follow-up surveys, I seems that the cases which have newfirmstarted2==1 and survival2==1, survived to the first fu and then closed and opened a new one in the second fu, or closed and opened new firm in fu2 and then were coded as surviving in fu2, because this new business continued to be open
replace survival2=0 if newfirmstarted2==1 & survival2==1

replace survival3=0 if survival2==0 & survival3==1 & newfirmstarted2==1

*Only keep if business is operating
drop if survival2!=1 & wave==2
drop if survival3!=1 & wave==3

foreach x in survival newfirmstarted attrit reasonclosure mainactivity laborincome{
g `x'_1yr=`x'2 if wave==1
drop `x'2
g `x'_30mths=`x'3 if wave==1
drop `x'3
}	
rename laborincome1 laborincome

ds sec3_1_-sec3_17_ r3* startreason laborincome, has(type numeric)
foreach var of varlist `r(varlist)'{
replace `var'=. if wave!=1
}
ds sec3_1_-sec3_17_ r3* startreason laborincome, not(type numeric)
foreach var of varlist `r(varlist)'{
replace `var'="" if wave!=1
}


tostring survey, replace
replace survey="BL-"+string(surveyyear) if surveyyear==2013
replace survey="R-"+string(surveyyear) if surveyyear==2014 
replace survey="L-"+string(surveyyear) if surveyyear==2016

g lastround=(surveyyear==2016)

*Generate owner, household and business id (which are the same here)
foreach var in ownerid firmid householdid{
egen `var'=group(respondent_id)
tostring `var', format("%04.0f") replace
replace `var'="KENYAGETAHEAD"+"-"+`var'
}

g surveyname="KENYAGETAHEAD"

save KENYAGETAHEAD_masterfc,replace
					
