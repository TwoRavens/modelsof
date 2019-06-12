********************************************************************************

********************************************************************************
**THIS DO-FILE PREPARES THE DATA FROM THE GHANA MICROENTERPRISE SURVEY FOR COMBINATION INTO THE MASTER DATASET
**Small Firm Death in Developing Countries
**November 20, 2017
**David McKenzie (dmckenzie@worldbank.org) and Anna Luisa Paffhausen (apaffhausen@worldbank.org)
**The analysis was performed with Stata, version 14.2

*Note:
* This do-file cannot be replicated as part of the underlying raw data needed to replicate this do-file is not available publicly.

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

use "Ghana Flypaper/GhanaBaselineMultiple.dta",clear

keep SHENO questionheading roster_1 roster_3 child_gender child_age
keep if questionheading=="child_counter" | questionheading=="Roster_HouseholdID"
g gender=roster_1 if roster_1!="" & roster_1!="."
replace gender=child_gender if child_gender!="" & child_gender!="."
g age=roster_3 if roster_3!=.
destring child_age, force gen(child_agehelp)
drop if SHENO=="140701707" & gender==""
drop if SHENO=="110601214" & gender==""
replace child_agehelp=0 if 	  child_age=="0.10mth"	///
							| child_age=="1 month"	///
							| child_age=="10 months"	///
							| child_age=="10mth"	///
							| child_age=="11months"	///
							| child_age=="1month"	///
							| child_age=="2 months"	///
							| child_age=="2mounths"	///
							| child_age=="3 MTHS"	///
							| child_age=="3 months"	///
							| child_age=="3month"	///
							| child_age=="3weeks"	///
							| child_age=="4 months"	///
							| child_age=="4months"	///
							| child_age=="4mounths"	///
							| child_age=="5 MONTHS"	///
							| child_age=="5 months"	///
							| child_age=="5 months one week" ///
							| child_age=="5 months one week." ///
							| child_age=="5months" ///
							| child_age=="6 months" ///
							| child_age=="6month" ///
							| child_age=="6months" ///
							| child_age=="7 MONTHS" ///
							| child_age=="7 months" ///
							| child_age=="8 Months" ///
							| child_age=="8 month" ///
							| child_age=="8MONTHS" ///
							| child_age=="9months" ///
							| child_age=="9mths" ///
							| child_age=="ONE WEEK OLD" ///
							| child_age=="aweek baby" ///
							| child_age=="not up to a month" ///
							| child_age=="not up to a year" ///
							| child_age=="one month"

replace child_agehelp=1.5 if 	  child_age=="1 1/2"	///							
								| child_age=="1y 6m"
								
replace child_agehelp=2.5 if 	  child_age=="2.5years"	///							
								| child_age=="2YRS  6MNTHHS"
								
replace child_agehelp=4 if 	 	  child_age=="4 years" ///
								| child_age=="4th chd  4yrs"
								
replace child_agehelp=6 if 	 child_age=="3rd chd   6yrs"								

replace child_agehelp=10 if 	 child_age=="2nd chd [Twins] 10"								

replace child_agehelp=10 if 	 child_age=="5th  chd  1/"								

replace child_agehelp=16 if 	  child_age=="16 years" ///
								| child_age=="1st chd 16"
						
								
replace age=child_agehelp if child_agehelp!=.
replace age=3 if age==2005

*Although I risk droping some of twin or more / other pairs, I drop duplicates in gender and age for each household
duplicates drop SHENO age gender, force

keep SHENO age 
bysort SHENO: egen hhmember=seq()
reshape wide age, i(SHENO) j(hhmember)

rename SHENO sheno 
destring sheno, replace

merge 1:m sheno using "Ghana Flypaper/ReplicationDataGhanaJDE.dta",  keepusing(age wave HouseholdSize Children*) 
keep if wave==1

foreach var of varlist age*{
replace `var'=floor(`var')
} 

*Has child under 5
egen childunder5=anymatch(age age1-age14), values(0/4)

*Has child aged 5 to 12
egen childaged5to12=anymatch(age age1-age14), values(5/11)

*Has elderly member in household
egen helpmaxage=rowmax(age age1-age14)
su helpmaxage
egen adult65andover=anymatch(age age1-age14), values(65/`r(max)')

*If HouseholdSize==0 & _merge==2 -> childunder5 and childaged5to12 should be 0
*If HouseholdSize>0 & _merge==2 -> childunder5 and childaged5to12 should be .
foreach var of varlist childunder5 childaged5to12{
replace `var'=0 if HouseholdSize==0 & _merge==2
replace `var'=. if HouseholdSize>0 & _merge==2
}

keep sheno childunder5 childaged5to12 adult65andover
save SLMS1fromhhroster, replace 

use "Ghana Flypaper/ReplicationDataGhanaJDE.dta",clear
bysort sheno: egen maxraven=max(raven)
keep sheno maxraven wave married age firmage most_imp_comp_1km num_comp_neighborhood ladder_now digitspan female PaidEmployees educ_years cashtreat assigntreat HouseholdSize expend_total finalsales finalprofits hourslastweek inventories1 totalK
rename maxraven raven 
replace raven=raven/12

keep if wave==1

rename sheno SHENO
tostring SHENO, replace

merge 1:1 SHENO using "Ghana Flypaper/GhanaBaselineSingle_la.dta", nogenerate keep(3)

*Country
g country="Ghana"

*Surveyyear
g surveyyear=2008

*Wave
*already defined

*Treatment status
g treatstatus=(assigntreat==1)
g control=(assigntreat==0)

*Firm has been assigned to a cash treatment group
*already defined

*Local to USD exchange rate at time of survey
*Survey took place in October and November 2008, so I take October 31, 2008 as approx. midpoint
g excrate=0.84435

g excrateold=0.00008

g excratemonth="10-2008"


********************************************************************************
*Owner and Household characteristics
********************************************************************************

*Age of owner
rename age ownerage

*Gender of owner
*already defined

*Marital status of owner
*already defined

*Education of owner
**Owner's education in years
rename educ_years educyears

**Owner has tertiary education
g ownertertiary=(personal_8=="Polytechnic" | personal_8=="University") if personal_8!=""

*Has child under 5
*In SLMS1fromhhroster.dta

*Has child aged 5 to 12
*In SLMS1fromhhroster.dta

*Has elderly member in household
*In SLMS1fromhhroster.dta

*Household expenditure per capita
g hhsize=HouseholdSize+1
*Given that total hh expenditures are given for a quarter:
replace expend_total=expend_total*4
g pcexpend=expend_total/hhsize

*Digit span recall of owner
*already defined

*Raven score of owner
*already defined

*Subjective wellbeing on Cantril ladder
rename ladder_now subjwell

********************************************************************************
*Firm characteristics
********************************************************************************
*Age of the firm in years
rename firmage agefirm

*Capital stock
g capitalstock=totalK-inventories1

*Inventories
rename inventories1 inventories

*Firm is in retail trade
g retail=(business_1b=="Trade / retail" | business_1b=="Shop")

*Firm is in manufacturing sector
g manuf=(business_1b=="Manufacturing" | business_1b=="Sewing, tailoring and footwear" | business_1b=="Repair")

*Firm is in service sector
g services=(business_1b=="Food preparation" | business_1b=="Food preparation / restaurants" | business_1b=="Hair and beauty care")

*Firm is in other sector
g othersector=(business_1b=="Construction" | business_1b=="Other")

*Number of paid employees
rename PaidEmployees employees

*Business profits in last month
rename finalprofits profits

*Business sales in last month
rename finalsales sales

*Hours worked in self-employment in last month
*based on hours worked  in last week
g hours=hourslastweek*(30/7)

*based on hours worked  in a normal week
destring business_7c, gen(hoursnormal) force
replace hoursnormal=112 if business_7c=="112MINUTES"
replace hoursnormal=37.5 if business_7c=="37 1/2"
replace hoursnormal=hoursnormal*(30/7)

*Labor earnings from all labor, including the business, in last month
destring income_14, gen(laborincome) force
replace laborincome=0 if income_14=="NO" | income_14=="No" | income_14=="n" | income_14=="n0" | income_14=="no" | income_14=="noo" | income_14=="noo" | income_14=="no     GH 0"
replace laborincome=0 if income_14=="Yes    Ghc 60"
egen laborincome2=rowtotal(laborincome profits), m
drop laborincome
rename laborincome2 laborincome

********************************************************************************
*Competition facing firm
********************************************************************************
*Number of competitors (here: in same G.N.)
rename num_comp_neighborhood competition1

*Customers could replace them within a day
g competition2=(competition_6=="A day or less.") if competition_6!=""

*Most important competitor is within 1 km
rename most_imp_comp_1km competition3

********************************************************************************
destring SHENO, gen(sheno)

merge 1:1 sheno using SLMS1fromhhroster, nogenerate

keep 	SHENO sheno ///
		country surveyyear wave treatstatus control cashtreat excrate excrateold excratemonth ///
		ownerage female married educyears ownertertiary childunder5 childaged5to12 adult65andover pcexpend digitspan raven subjwell ///
		agefirm capitalstock inventories retail manuf services employees profits sales hours hoursnormal ///
		competition1 competition2 competition3

foreach var of varlist surveyyear wave excrate excrateold excratemonth ///
				ownerage female married educyears ownertertiary childunder5 childaged5to12 adult65andover digitspan raven subjwell ///
				agefirm capitalstock inventories retail manuf services {
rename `var' `var'1
}

save GHANAFLYP1, replace

********************************************************************************

********************************************************************************
*Panel variables
********************************************************************************

********************************************************************************#
*Round 2 
use "Ghana Flypaper/ReplicationDataGhanaJDE.dta",clear
keep sheno wave PaidEmployees HouseholdSize expend_total finalsales finalprofits hourslastweek stillownbusiness changedbusinesslocation changedlineofbusiness closedbusiness attrited

keep if wave==2

rename sheno SHENO
tostring SHENO, replace

merge 1:m SHENO using "Ghana Flypaper/GhanaRound2Single_la.dta", keep (1 3)

duplicates tag SHENO, gen(duplsheno)
g shenointroyes=(introduction_1=="Yes")
bysort SHENO: egen duplshenointroyes=total(shenointroyes)

drop if duplsheno>0 & duplshenointroyes==1 & shenointroyes==0

*Take the most recent for the other duplicates and drop the less recent
drop if SHENO=="110601604" & questionnaire_date=="2009-02-10"
drop if SHENO=="111000508" & questionnaire_date=="2009-02-07"
drop if SHENO=="150204203" & questionnaire_date=="2009-02-13"
drop if SHENO=="160402616" & questionnaire_date=="2009-02-03"
drop if SHENO=="300105904" & questionnaire_date=="2009-02-06"

********************************************************************************#

*Survival
g survival=1 if introduction_6=="Yes" & changedlineofbusiness==0
replace survival=0 if changedlineofbusiness==1 & introduction_10=="Business is closed down" | introduction_10=="not allowed to do business involed  with fire[preg" | introduction_10=="now into different business" | introduction_10=="she gave birth in december, 2008 & temporary out" | introduction_10=="went on break before x'mas"
replace survival=1 if changedlineofbusiness==1 & introduction_10=="Now run by another family member" | introduction_10=="Operating the same business" 

*Main activity after closing business
label define mainactivity 	1 "Working for a wage" ///
							2 "Looking for work" ///
							3 "Operating a different business" ///
							4 "Housework or looking after children" ///
							5 "Other"

g mainactivity=3 if introduction_11=="Operating a different business" | introduction_11=="pure water selling"
replace mainactivity=4 if introduction_11=="still breastfeeding a 2 mmonth child" 
replace mainactivity=5 if introduction_11=="about to re-start the previous business" 

label values mainactivity mainactivity	

*New firm started since last survey
g newfirmstarted=(changedlineofbusiness==1 & mainactivity==3) if changedlineofbusiness!=. | mainactivity!=.				

*Number of paid employees
rename PaidEmployees employees

*Business profits in last month
rename finalprofits profits

*Business sales in last month
rename finalsales sales

*Hours worked in self-employment in last month
*based on hours worked  in last week
g hours=hourslastweek*(30/7) 

*Household expenditure per capita
g hhsize=HouseholdSize+1
*Given that total hh expenditures are given for a quarter:
replace expend_total=expend_total*4
g pcexpend=expend_total/hhsize

*Firm attrits from survey
rename attrited attrit

*Excrate and excratemonth
*Survey took place February 2009, so I take February 15, 2009 as approx. midpoint
g excrate=0.72088
g excrateold=0.00007 

g excratemonth="2-2009" 

*Surveyyear
g surveyyear=2009


keep 	SHENO ///
		surveyyear wave ///
		excrate excrateold excratemonth ///
		employees profits sales hours ///
		pcexpend ///
		survival newfirmstarted attrit mainactivity ///
		introduction_10


foreach var of varlist 	surveyyear wave ///
						excrate  excrateold excratemonth ///
						employees profits sales hours ///
						pcexpend ///
						survival newfirmstarted attrit mainactivity ///
						introduction_10 {
rename `var' `var'2
}	

save GHANAFLYP2, replace


********************************************************************************
*Round 3 
use "Ghana Flypaper/ReplicationDataGhanaJDE.dta",clear
keep sheno wave PaidEmployees HouseholdSize expend_total finalsales finalprofits hourslastweek stillownbusiness changedbusinesslocation changedlineofbusiness closedbusiness attrited

keep if wave==3

rename sheno SHENO
tostring SHENO, replace

merge 1:m SHENO using "Ghana Flypaper/GhanaRound3Single_la.dta", keep (1 3)

duplicates drop

duplicates tag SHENO, gen(duplsheno)
g shenointroyes=(introduction_1=="Yes")
bysort SHENO: egen duplshenointroyes=total(shenointroyes)

drop if duplsheno>0 & duplshenointroyes==1 & shenointroyes==0

duplicates tag SHENO, gen(duplsheno2)

*Take the most recent for the other duplicates and drop the less recent
drop if SHENO=="110803902" & questionnaire_date=="2009-05-08"
drop if SHENO=="111000505" & questionnaire_date=="2009-05-16"

*The remaining cases seem to be duplicates 
duplicates drop SHENO, force

********************************************************************************#

*Survival
g survival=1 if stillownbusiness==1 & changedlineofbusiness==0
replace survival=0 if introduction_10=="Business is closed down" | introduction_10=="I never owned a business (there was a mistake earlier)" | introduction_10=="Modified to become my current business" | introduction_10=="Seasonal at the the product is scared" | introduction_10=="closed for maternity leave" | introduction_10=="now a wage worker"
replace survival=1 if introduction_10=="Now run by another family member" | introduction_10=="still operating but now farming b'cos no contract" 
replace survival=1 if attrition_2=="Yes."
replace survival=0 if attrition_2=="No, the business has closed."


*Main activity after closing business
label define mainactivity 	1 "Working for a wage" ///
							2 "Looking for work" ///
							3 "Operating a different business" ///
							4 "Housework or looking after children" ///
							5 "Other"

g mainactivity=1 if introduction_11=="Wage worker"
replace mainactivity=2 if introduction_11=="Looking for work"
replace mainactivity=3 if introduction_11=="Operating a different business" | introduction_11=="Sells bicycles" | introduction_11=="sellinG water" | introduction_11=="selling eggs"
replace mainactivity=4 if introduction_11=="on maternity leave" 
replace mainactivity=5 if introduction_11=="sick"

label values mainactivity mainactivity	

*New firm started since last survey
g newfirmstarted=(changedlineofbusiness==1 & mainactivity==3) if changedlineofbusiness!=. | mainactivity!=.
*There is one inconsistency which seems to be a new firm, so I recode it
replace newfirmstarted=1 if mainactivity==3 & newfirmstarted!=1	

*Number of paid employees
rename PaidEmployees employees

*Business profits in last month
rename finalprofits profits

*Business sales in last month
rename finalsales sales

*Hours worked in self-employment in last month
*based on hours worked  in last week
g hours=hourslastweek*(30/7) 

*Household expenditure per capita
g hhsize=HouseholdSize+1
*Given that total hh expenditures are given for a quarter:
replace expend_total=expend_total*4
g pcexpend=expend_total/hhsize

*Attrition
*Given that JDE replication file does it:
g attrit=attrited
replace attrit=1 if attrit==.
*Given that I was able to get information for survival from attrition section (attrition_2):
replace attrit=0 if survival!=.
*SHENO="110706003" looks like attritor, so I recode it
replace attrit=1 if SHENO=="110706003"

*Excrate and excratemonth
*Survey took place in May 2009, so I take May 15, 2009 as approx. midpoint
g excrate=0.67893
g excrateold=0.00007 

g excratemonth="5-2009" 

*Surveyyear
g surveyyear=2009


keep 	SHENO ///
		surveyyear wave ///
		excrate excrateold excratemonth ///
		employees profits sales hours ///
		pcexpend ///
		survival newfirmstarted attrit mainactivity ///
		introduction_10


foreach var of varlist 	surveyyear wave ///
						excrate  excrateold excratemonth ///
						employees profits sales hours ///
						pcexpend ///
						survival newfirmstarted attrit mainactivity ///
						introduction_10 {
rename `var' `var'3
}	

save GHANAFLYP3, replace


********************************************************************************
*Round 4
use "Ghana Flypaper/ReplicationDataGhanaJDE.dta",clear
keep sheno wave PaidEmployees HouseholdSize expend_total finalsales finalprofits hourslastweek stillownbusiness changedbusinesslocation changedlineofbusiness closedbusiness attrited

keep if wave==4

rename sheno SHENO
tostring SHENO, replace

merge 1:m SHENO using "Ghana Flypaper/GhanaRound4Single_la.dta", keep (1 3)


duplicates tag SHENO, gen(duplsheno)
g shenointroyes=(introduction_1=="Yes")
bysort SHENO: egen duplshenointroyes=total(shenointroyes)

drop if duplsheno>0 & duplshenointroyes==1 & shenointroyes==0

*I keep the one obs. of the duplicates where the owner did not agree to be interviewe; this is also the one that is consistent with the information on firm closure from the master dataset
drop if SHENO=="110101604" & introduction_2=="No"
********************************************************************************

*Survival
g survival=1 if stillownbusiness==1 & changedlineofbusiness==0
replace survival=0 if introduction_10=="Business is closed down" | introduction_10=="closed down and now selling tea" | introduction_10=="Modified to become my current business" | introduction_10=="pinneaple is scarce, lm now selling provisions but"
replace survival=1 if introduction_10=="Now run by another family member"
replace survival=1 if attrition_2=="Yes."
replace survival=1 if attrition_2=="No, the business is now operated by someone else."
replace survival=0 if attrition_2=="No, the business has closed."


*Main activity after closing business
label define mainactivity 	1 "Working for a wage" ///
							2 "Looking for work" ///
							3 "Operating a different business" ///
							4 "Housework or looking after children" ///
							5 "Other"

g mainactivity=1 if introduction_11=="Wage worker"
replace mainactivity=2 if introduction_11=="Looking for work"
replace mainactivity=3 if introduction_11=="Operating a different business" | introduction_11=="selling provisions"
replace mainactivity=4 if introduction_11=="Housework or looking after children" 
replace mainactivity=5 if introduction_11=="sick since april" | introduction_11=="bereaved" | introduction_11=="wants to travel,doing nothing at the moment"

label values mainactivity mainactivity	

*New firm started since last survey
g newfirmstarted=(changedlineofbusiness==1 & mainactivity==3) if changedlineofbusiness!=. | mainactivity!=.	

*Number of paid employees
rename PaidEmployees employees

*Business profits in last month
rename finalprofits profits

*Business sales in last month
rename finalsales sales

*Hours worked in self-employment in last month
*based on hours worked  in last week
g hours=hourslastweek*(30/7) 

*Household expenditure per capita
g hhsize=HouseholdSize+1
*Given that total hh expenditures are given for a quarter:
replace expend_total=expend_total*4
g pcexpend=expend_total/hhsize

*Given that JDE replication file does it:
g attrit=attrited
replace attrit=1 if attrit==.
*Given that I was able to get information for survival from attrition section (attrition_2):
replace attrit=0 if survival!=.


*Excrate and excratemonth
*Survey took place in August 2009, so I take August 15, 2009 as approx. midpoint
g excrate=0.67568
g excrateold=0.00007 

g excratemonth="8-2009" 

*Surveyyear
g surveyyear=2009


keep 	SHENO ///
		surveyyear wave ///
		excrate excrateold excratemonth ///
		employees profits sales hours ///
		pcexpend ///
		survival newfirmstarted attrit mainactivity ///
		introduction_10


foreach var of varlist 	surveyyear wave ///
						excrate  excrateold excratemonth ///
						employees profits sales hours ///
						pcexpend ///
						survival newfirmstarted attrit mainactivity ///
						introduction_10 {
rename `var' `var'4
}	

save GHANAFLYP4, replace

********************************************************************************
*Round 5
use "Ghana Flypaper/ReplicationDataGhanaJDE.dta",clear
keep sheno wave PaidEmployees HouseholdSize expend_total finalsales finalprofits hourslastweek stillownbusiness changedbusinesslocation changedlineofbusiness closedbusiness attrited

keep if wave==5

rename sheno SHENO
tostring SHENO, replace

merge 1:m SHENO using "Ghana Flypaper/GhanaRound5Single_la.dta", keep (1 3)

duplicates drop

duplicates tag SHENO, gen(duplsheno)
g shenointroyes=(introduction_1=="Yes")
bysort SHENO: egen duplshenointroyes=total(shenointroyes)

drop if duplsheno>0 & duplshenointroyes==1 & shenointroyes==0

duplicates tag SHENO, gen(duplsheno2)

drop if SHENO=="110101604" & questionnaire_date=="2009-11-30"
drop if SHENO=="110305410" & questionnaire_date=="2009-11-30"
drop if SHENO=="110701605" & questionnaire_date=="2009-11-10"
drop if SHENO=="120201406" & questionnaire_date=="2009-11-02"
drop if SHENO=="120500305" & questionnaire_date=="2009-11-04"
drop if SHENO=="140500403" & assets_3b==""
drop if SHENO=="150102501" & assets_3b==""
drop if SHENO=="150102502" & assets_3b==""
drop if SHENO=="150102503" & assets_3b==""
drop if SHENO=="150102510" & assets_3b==""
drop if SHENO=="150107202" & assets_3b==""
drop if SHENO=="150107203" & assets_3b==""
drop if SHENO=="150107213" & assets_3b==""
drop if SHENO=="150404503" & assets_3b==""
drop if SHENO=="150404504" & reciprocity_2==""
drop if SHENO=="150404511" & assets_3b==""
drop if SHENO=="150405415" & assets_3b==""
drop if SHENO=="150503804" & reciprocity_2==""
drop if SHENO=="150503807" & reciprocity_2==""
drop if SHENO=="150503810" & reciprocity_2==""
drop if SHENO=="300108803" & assets_3b==""
drop if SHENO=="300108806" & assets_3b==""
drop if SHENO=="300300506" & reciprocity_2==""
drop if SHENO=="300300517" & reciprocity_2==""
drop if SHENO=="300301305" & assets_3b==""
drop if SHENO=="300301306" & assets_3b==""
drop if SHENO=="301041202" & assets_3b==""

********************************************************************************

*Survival
g survival=1 if stillownbusiness==1 & changedlineofbusiness==0
replace survival=0 if introduction_10=="Business is closed down" | introduction_10=="I HAVE STOPPED" | introduction_10=="Modified to become my current business" | introduction_10=="move to another business" | introduction_10=="I never owned a business (there was a mistake earlier)"
replace survival=1 if introduction_10=="Now run by another family member" | introduction_10=="Operating the same business"
replace survival=1 if attrition_2=="Yes."
replace survival=0 if attrition_2=="No, the business has closed."
replace survival=. if attrition_2=="Don't know." & SHENO!="150102507"
*Looks like this business survived:
replace survival=1 if SHENO=="160202312"

*Main activity after closing business
label define mainactivity 	1 "Working for a wage" ///
							2 "Looking for work" ///
							3 "Operating a different business" ///
							4 "Housework or looking after children" ///
							5 "Other"

g mainactivity=1 if introduction_11=="Wage worker"
replace mainactivity=2 if introduction_11=="Looking for work"
replace mainactivity=3 if introduction_11=="Operating a different business" 
replace mainactivity=4 if introduction_11=="Housework or looking after children" 
replace mainactivity=5 if introduction_11=="Sick has given Birth" | introduction_11=="preparing to start the same business"

label values mainactivity mainactivity	

*New firm started since last survey
g newfirmstarted=(changedlineofbusiness==1 & mainactivity==3) if changedlineofbusiness!=. | mainactivity!=.	

*Number of paid employees
rename PaidEmployees employees

*Business profits in last month
rename finalprofits profits

*Business sales in last month
rename finalsales sales

*Hours worked in self-employment in last month
*based on hours worked  in last week
g hours=hourslastweek*(30/7) 

*Household expenditure per capita
g hhsize=HouseholdSize+1
*Given that total hh expenditures are given for a quarter:
replace expend_total=expend_total*4
g pcexpend=expend_total/hhsize

*Firm attrits from survey
g attrit=attrited
*Given that JDE replication file does it:
replace attrit=1 if attrit==.
*Given that I was able to get information for survival from attrition section (attrition_2):
replace attrit=0 if survival!=.

*Excrate and excratemonth
*Survey took place in November 2009, so I take November 15, 2009 as approx. midpoint
g excrate=0.69142
g excrateold=0.00007

g excratemonth="11-2009" 

*Surveyyear
g surveyyear=2009


keep 	SHENO ///
		surveyyear wave ///
		excrate excrateold excratemonth ///
		employees profits sales hours ///
		pcexpend ///
		survival newfirmstarted attrit mainactivity ///
		introduction_10


foreach var of varlist 	surveyyear wave ///
						excrate  excrateold excratemonth ///
						employees profits sales hours ///
						pcexpend ///
						survival newfirmstarted attrit mainactivity ///
						introduction_10 {
rename `var' `var'5
}	

save GHANAFLYP5, replace


********************************************************************************
*Round 6
use "Ghana Flypaper/ReplicationDataGhanaJDE.dta",clear
keep sheno wave PaidEmployees HouseholdSize expend_total finalsales finalprofits hourslastweek stillownbusiness changedbusinesslocation changedlineofbusiness closedbusiness attrited

keep if wave==6

rename sheno SHENO
tostring SHENO, replace

merge 1:m SHENO using "Ghana Flypaper/GhanaRound6Single_la.dta", keep (1 3)

duplicates tag SHENO, gen(duplsheno)
g shenointroyes=(introduction_1=="Yes")
bysort SHENO: egen duplshenointroyes=total(shenointroyes)

drop if duplsheno>0 & duplshenointroyes==1 & shenointroyes==0

duplicates tag SHENO, gen(duplsheno2)

drop if SHENO=="110706004" & questionnaire_date=="2010-02-16"
drop if SHENO=="160300106" & questionnaire_date=="2010-02-12"
drop if SHENO=="300105901" & questionnaire_date=="2010-02-12"

********************************************************************************

*Survival
g survival=1 if stillownbusiness==1 & changedlineofbusiness==0
replace survival=0 if introduction_10=="Business is closed down"  | introduction_10=="Given birth" | introduction_10=="Hospitalised" | introduction_10=="Modified to become my current business" | introduction_10=="Now sales pure water" | introduction_10=="business suspended respondent pregnant" | introduction_10=="on hold because i have given birth" | introduction_10=="respondent is sick business will restart very soon" | introduction_10=="selling another product"
replace survival=1 if attrition_2=="Yes." | attrition_2=="No, the business is now operated by someone else."
replace survival=0 if attrition_2=="No, the business has closed."

*Main activity after closing business
label define mainactivity 	1 "Working for a wage" ///
							2 "Looking for work" ///
							3 "Operating a different business" ///
							4 "Housework or looking after children" ///
							5 "Other"

g mainactivity=1 if introduction_11=="Wage worker"
replace mainactivity=3 if introduction_11=="Operating a different business" 
replace mainactivity=4 if introduction_11=="Housework or looking after children" 
replace mainactivity=5 if introduction_11=="am in labour" | introduction_11=="apprentice,learning how to lay floor tiles" | introduction_11=="food preparation" | introduction_11=="no work,she is sick for sometime now." | introduction_11=="not working recovering from illness .will start wo" | introduction_11=="sick in the house"

label values mainactivity mainactivity	

*New firm started since last survey
g newfirmstarted=(changedlineofbusiness==1 & mainactivity==3) if changedlineofbusiness!=. | mainactivity!=.	

*Number of paid employees
rename PaidEmployees employees

*Business profits in last month
rename finalprofits profits

*Business sales in last month
rename finalsales sales

*Hours worked in self-employment in last month
*based on hours worked  in last week
g hours=hourslastweek*(30/7) 

*Household expenditure per capita
g hhsize=HouseholdSize+1
*Given that total hh expenditures are given for a quarter:
replace expend_total=expend_total*4
g pcexpend=expend_total/hhsize

*Firm attrits from survey
g attrit=attrited
*Given that JDE replication file does it:
replace attrit=1 if attrit==.
*These actually look like attrition:
replace attrit=1 if attritionmarker2==1
*Given that I was able to get information for survival from attrition section (attrition_2):
replace attrit=0 if survival!=.

*Excrate and excratemonth
*Survey took place in February 2010, so I take February 15, 2010 as approx. midpoint
g excrate=0.69339
g excrateold=0.00007

g excratemonth="2-2010" 

*Surveyyear
g surveyyear=2010


keep 	SHENO ///
		surveyyear wave ///
		excrate excrateold excratemonth ///
		employees profits sales hours ///
		pcexpend ///
		survival newfirmstarted attrit mainactivity ///
		introduction_10


foreach var of varlist 	surveyyear wave ///
						excrate  excrateold excratemonth ///
						employees profits sales hours ///
						pcexpend ///
						survival newfirmstarted attrit mainactivity ///
						introduction_10 {
rename `var' `var'6
}	

save GHANAFLYP6, replace


********************************************************************************

********************************************************************************
*Merge rounds 1-6 together
********************************************************************************

********************************************************************************
use GHANAFLYP1, clear
forvalues i=2/6{
merge 1:1 SHENO using GHANAFLYP`i', nogenerate
}

*I don't think that the values I am using are in the old currency so I drop them:
drop excrateold*
rename hoursnormal hoursnormal1

quietly: reshape long 	surveyyear wave excrate excratemonth ///
						capitalstock inventories hoursnormal ///
						ownerage female married educyears ownertertiary childunder5 childaged5to12 adult65andover digitspan raven subjwell ///
						agefirm retail manuf services ///
						, ///
						i(sheno) j(survey)
		
foreach x in profits sales hours employees pcexpend competition1 competition2 competition3 {
replace `x'=. if wave!=1
}	

*Recode survival, so that it gives survival since baseline, assuming that so far it has been coded from round to round
replace survival6=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival6=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival6=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival6=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival6=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival6=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival6=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival6=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival6=0 if survival2==0 & survival3==0 & survival4==0 & newfirmstarted4==1
replace survival6=0 if survival2==0 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival6=0 if survival2==1 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival6=0 if survival2==1 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival6=0 if survival2==1 & survival3==0 & newfirmstarted3==1
replace survival6=0 if survival2==0 & survival3==0 & newfirmstarted3==1
replace survival6=0 if survival2==0 & survival3==1 & newfirmstarted2==1

replace survival5=0 if survival2==0 & survival3==0 & survival4==0 & newfirmstarted4==1
replace survival5=0 if survival2==0 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival5=0 if survival2==1 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival5=0 if survival2==1 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival5=0 if survival2==1 & survival3==0 & newfirmstarted3==1
replace survival5=0 if survival2==0 & survival3==0 & newfirmstarted3==1
replace survival5=0 if survival2==0 & survival3==1 & newfirmstarted2==1

replace survival4=0 if survival2==1 & survival3==0 & newfirmstarted3==1
replace survival4=0 if survival2==0 & survival3==0 & newfirmstarted3==1
replace survival4=0 if survival2==0 & survival3==1 & newfirmstarted2==1

replace survival3=0 if survival2==0 & survival3==1 & newfirmstarted2==1


*Only keep if business is operating
forvalues i=2/6{
drop if survival`i'!=1 & wave==`i'
}

foreach x in survival newfirmstarted attrit mainactivity profits sales employees pcexpend introduction_10{
g `x'_4mths=`x'2 if wave==1
drop `x'2
g `x'_7mths=`x'3 if wave==1
drop `x'3
g `x'_10mths=`x'4 if wave==1
drop `x'4
g `x'_1p083yrs=`x'5 if wave==1
drop `x'5
g `x'_1p33yrs=`x'6 if wave==1
drop `x'6
}	


tostring survey, replace
replace survey="BL-"+string(surveyyear) if wave==1
replace survey="R-"+string(surveyyear)+"-1" if wave==2 
replace survey="R-"+string(surveyyear)+"-2" if wave==3 
replace survey="R-"+string(surveyyear)+"-3" if wave==4
replace survey="R-"+string(surveyyear)+"-4" if wave==5
replace survey="L-"+string(surveyyear) if wave==6


g lastround=(wave==6)

*Generate owner, household and business id (which are the same here)
foreach var in ownerid firmid householdid{
egen `var'=group(SHENO)
tostring `var', format("%04.0f") replace
replace `var'="GHANAFLYP"+"-"+`var'
}

g surveyname="GHANAFLYP"

save GHANAFLYP_masterfc, replace
				
