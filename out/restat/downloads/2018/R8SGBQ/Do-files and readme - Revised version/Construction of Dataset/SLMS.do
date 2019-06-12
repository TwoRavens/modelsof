********************************************************************************

********************************************************************************
**THIS DO-FILE PREPARES THE DATA FROM THE SRI LANKA MICROENTERPRISE SURVEY FOR COMBINATION INTO THE MASTER DATASET
**Small Firm Death in Developing Countries
**November 21, 2017
**David McKenzie (dmckenzie@worldbank.org) and Anna Luisa Paffhausen (apaffhausen@worldbank.org)
**The analysis was performed with Stata, version 14.2

*Note:
* This do-file cannot be replicated as part of the underlying raw data needed to replicate this do-file is not (yet) available publicly.

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

use "SLMS/SLMSMaster_web.dta",clear

keep sheno wave age cash digitspan ednyears ednyearsFIRM evertreat gender hhsize inv married prof raven trtmnt_type
keep if wave==1

merge 1:1 sheno using "SLMS/SLMSround1.dta", keep(3) nogenerate

g oldsheno=sheno

tostring sheno, format("%03.0f") replace
replace sheno="H"+sheno

rename q* fq*

merge 1:1 sheno using "SLMS/SLMS_HHround1_labeled", keep(1 3) nogenerate

*Country
g country="Sri Lanka"

*Surveyyear
g surveyyear=2005

*Wave
*already defined

*Treatment status
g treatstatus=(evertreat!=0)
g control=(evertreat==0)

*Firm has been assigned to a cash treatment group
g cashtreat=(cash==1)

*Local to USD exchange rate at time of survey
*Survey took place in December 2008, so I take December 15, 2008 as approx. midpoint
g excrate=0.01004

g excratemonth="4-2005"


********************************************************************************
*Owner and Household characteristics
********************************************************************************

*Age of owner
rename age ownerage

*Gender of owner
g female=(gender==2) 

*Marital status of owner
*already defined

*Education of owner
**Owner's education in years
rename ednyears educyears

**Owner has tertiary education
g ownertertiary=(ednyearsFIRM==15 | ednyearsFIRM==16 | ednyearsFIRM==17)

*Has child under 5
forvalues i=2/10{
local j=`i'-1
order q1_4_`i', after(q1_4_`j')
}
egen childunder5=anymatch(q1_4_1-q1_4_10), values(0/4)

*Has child aged 5 to 12
egen childaged5to12=anymatch(q1_4_1-q1_4_10), values(5/11)

*Has elderly member in household
egen helpmaxage=rowmax(q1_4_1-q1_4_10)
su helpmaxage
egen adult65andover=anymatch(q1_4_1-q1_4_10), values(65/`r(max)')

*Household expenditure per capita
*Given that the minimum values of q4_1* are larger than 0, I assume that missings mean no spending
egen weeklyexp=rowtotal(q4_1a q4_1b)
egen monthlyexp=rowtotal(q4_2a q4_2b q4_2c q4_2d q4_2e q4_2f q4_2g q4_2h q4_2i)
egen semiannuallyexp=rowtotal(q4_3a q4_3b)
egen yearlyexp=rowtotal(q4_4a q4_4b q4_4c)

g pcexpend=(52*weeklyexp+12*monthlyexp+2*semiannuallyexp+yearlyexp)/hhsize

*Digit span recall of owner
*already defined

*Raven score of owner
replace raven=raven/12


********************************************************************************
*Firm characteristics
********************************************************************************
*Age of the firm in years
g helpivwdate="4"+"-"+"2005"
g ivwmonth=monthly(helpivwdate,"MY")

g date_yy=2005

g helpbusstartdate=string(fq1_20a)+"-"+string(fq1_20b) if fq1_20a!=95 & fq1_20a!=97 & fq1_20a!=99 & fq1_20b!=99
g busstartdate=monthly(helpbusstartdate,"MY")

g agefirm=(ivwmonth-busstartdate)/12 if busstartdate!=.

replace agefirm=date_yy-fq1_20b if agefirm==. & fq1_20b!=. & fq1_20b!=99

replace agefirm=round(agefirm,0.5)

*Capital stock
g capitalstock=fq1_36_7

*Inventories
rename inv inventories

*Firm is in retail trade
g retail=(fqt2!=.)

*Firm is in manufacturing sector
g manuf=(fqm2!=.)

*Firm is in service sector
g services=(fqs2!=. )

*Number of paid employees
g employees=fq1_26_1

*Business profits in last month
g profits=fq2_8

*Business sales in last month
egen sales=rowtotal(fqm2 fqt2 fqs2)

*Hours worked in self-employment in last month
*based on hours worked  in last week
g hours=fq1_23a*(30/7) 

*based on hours worked  in a normal week
g hoursnormal=fq1_23b*(30/7) 


********************************************************************************
keep 	sheno ///
		country surveyyear wave treatstatus control cashtreat excrate excratemonth ///
		ownerage female married educyears ownertertiary childunder5 childaged5to12 adult65andover pcexpend digitspan raven ///
		agefirm capitalstock inventories retail manuf services employees profits sales hours hoursnormal 

foreach var of varlist surveyyear wave excrate excratemonth ///
				ownerage female married educyears ownertertiary childunder5 childaged5to12 adult65andover digitspan raven ///
				agefirm capitalstock inventories retail manuf services {
rename `var' `var'1
}
replace sheno=substr(sheno, 2, 3)	
destring sheno, replace
save SLMS1, replace


********************************************************************************

	
********************************************************************************

********************************************************************************
*Panel variables
********************************************************************************

********************************************************************************
*Round 2 
use "SLMS/SLMSround2.dta", clear
********************************************************************************

*Survival
g survival=(b1_1==1 | b1_1==3 ) if b1_1!=.

*Main activity after closing business
label define mainactivity 	1 "Working for a wage" ///
							2 "Looking for work" ///
							3 "Operating a different business" ///
							4 "Housework or looking after children"

g mainactivity=b1_13 if b1_13!=.
label values mainactivity mainactivity							

*New firm started since last survey
g newfirmstarted=((b1_1==2 | b1_1==4) & mainactivity==3) if mainactivity!=.

*Reason for closing business
gen reasonclosure=b1_6
replace reasonclosure=3 if b1_6==4
replace reasonclosure=4 if b1_6==3
replace reasonclosure=10 if b1_6==5
replace reasonclosure=9 if b1_6==6

label define closereason 1 "making a loss" 2 "sickness" 3 "care for family" 4 "better wage job" 5 "migrate abroad" 6 "married" 7 "shut down by govt." 8 "taken from me" 9 "other" 10 "better business opportunity"
label values reasonclosure closereason

*Sales in last month
egen salesslms=rowtotal(bm3_2 bt3_2 bs3_2)
replace b3_4=0 if b3_4==.
rename b3_4 sales

*Profits in last month
rename prof profits

*Hours worked in self-employment in last month
*based on hours worked  in last week
g hours=b2_4*(30/7) 

*Worked as wage worker in last month
g wageworker=(b3_10==1) if b3_10!=.
replace wageworker=1 if mainactivity==1

*Labor earnings from all labor, including the business, in last month
g monthlywagelaborincome=bx5*(30/7)
replace monthlywagelaborincome=b3_10_3*(30/7) if b3_10_3!=.
egen laborincome=rowtotal(monthlywagelaborincome profits), m

*Number of paid employees
rename b2_9a1 employees
replace employees=. if employees==995 | employees==996

*Excrate and excratemonth
*Survey took place in July 2005, so I take July 15, 2005 as approx. midpoint
g excrate=0.00996
g excratemonth="7-2005" 

*Surveyyear
g surveyyear=2005

*Wave
g wave=2 

keep 	sheno ///
		surveyyear wave ///
		excrate excratemonth ///
		profits sales hours wageworker laborincome employees ///
		survival newfirmstarted mainactivity reasonclosure

foreach var of varlist 	surveyyear wave ///
						excrate excratemonth ///
						profits sales hours wageworker laborincome employees ///
						survival newfirmstarted mainactivity reasonclosure{
rename `var' `var'2
}	

save SLMS2, replace


********************************************************************************
*Round 3 
use "SLMS/SLMSround3_labeled.dta", clear
********************************************************************************
*Survival
g survival=(c1_1==1 | c1_1==3 ) if c1_1!=.


*Main activity after closing business
label define mainactivity 	1 "Working for a wage" ///
							2 "Looking for work" ///
							3 "Operating a different business" ///
							4 "Housework or looking after children"

g mainactivity=c1_13 if c1_13!=.
label values mainactivity mainactivity		

*New firm started since last survey
g newfirmstarted=((c1_1==2 | c1_1==4) & mainactivity==3) if mainactivity!=.

*Reason for closing business
gen reasonclosure=c1_6
replace reasonclosure=3 if c1_6==4
replace reasonclosure=4 if c1_6==3
replace reasonclosure=10 if c1_6==5
replace reasonclosure=9 if c1_6==6

label define closereason 1 "making a loss" 2 "sickness" 3 "care for family" 4 "better wage job" 5 "migrate abroad" 6 "married" 7 "shut down by govt." 8 "taken from me" 9 "other" 10 "better business opportunity"
label values reasonclosure closereason

*Sales in last month
egen salesslms=rowtotal(cm3_2 ct3_2 cs3_2)
replace c3_4=0 if c3_4==.
rename c3_4 sales

*Profits in last month
rename c3_5b profits

*Hours worked in self-employment in last month
*based on hours worked  in last week
g hours=c2_4*(30/7) 

*Worked as wage worker in last month
g wageworker=(c3_9_1==1) if c3_9_1!=.
replace wageworker=1 if mainactivity==1

*Labor earnings from all labor, including the business, in last month
g monthlywagelaborincome=cx5*(30/7)
replace monthlywagelaborincome=c3_9_3*(30/7) if c3_9_3!=.
egen laborincome=rowtotal(monthlywagelaborincome profits), m

*Number of paid employees
rename c2_9a1 employees
replace employees=. if employees==995 | employees==996

*Excrate and excratemonth
*Survey took place in October 2005, so I take October 15, 2005 as approx. midpoint
g excrate=0.00985
g excratemonth="10-2005" 

*Surveyyear
g surveyyear=2005

*Wave
g wave=3

*Subjective wellbeing on Cantril ladder
rename c5_6 subjwell9l

keep 	sheno ///
		surveyyear wave ///
		excrate excratemonth ///
		profits sales hours wageworker laborincome employees ///
		survival newfirmstarted mainactivity reasonclosure ///
		subjwell9l

foreach var of varlist 	surveyyear wave ///
						excrate excratemonth ///
						profits sales hours wageworker laborincome employees ///
						survival newfirmstarted mainactivity reasonclosure ///
						subjwell9l{
rename `var' `var'3
}	

save SLMS3, replace


********************************************************************************
*Round 4 
use "SLMS/SLMSround4.dta", clear
********************************************************************************
*Survival
g survival=(d1_1==1 | d1_1==3 ) if d1_1!=.


*Main activity after closing business
label define mainactivity 	1 "Working for a wage" ///
							2 "Looking for work" ///
							3 "Operating a different business" ///
							4 "Housework or looking after children"

g mainactivity=d1_13 if d1_13!=.
label values mainactivity mainactivity		

*New firm started since last survey
g newfirmstarted=((d1_1==2 | d1_1==4) & mainactivity==3) if mainactivity!=.

*Reason for closing business
gen reasonclosure=d1_6
replace reasonclosure=3 if d1_6==4
replace reasonclosure=4 if d1_6==3
replace reasonclosure=10 if d1_6==5
replace reasonclosure=9 if d1_6==6

label define closereason 1 "making a loss" 2 "sickness" 3 "care for family" 4 "better wage job" 5 "migrate abroad" 6 "married" 7 "shut down by govt." 8 "taken from me" 9 "other" 10 "better business opportunity"
label values reasonclosure closereason

*Sales in last month
egen salesslms=rowtotal(dm3_2 dt3_2 ds3_2)
replace d3_4=0 if d3_4==.
rename d3_4 sales

*Profits in last month
rename prof profits

*Hours worked in self-employment in last month
*based on hours worked  in last week
g hours=d2_4*(30/7) 

*Worked as wage worker in last month
g wageworker=(d3_9_1==1) if d3_9_1!=.
replace wageworker=1 if mainactivity==1

*Labor earnings from all labor, including the business, in last month
g monthlywagelaborincome=dx5*(30/7)
replace monthlywagelaborincome=d3_9_3*(30/7) if d3_9_3!=.
egen laborincome=rowtotal(monthlywagelaborincome profits), m

*Number of paid employees
rename d2_9a1 employees
replace employees=. if employees==995 | employees==996

*Excrate and excratemonth
*Survey took place in January 2006, so I take January 15, 2006 as approx. midpoint
g excrate=0.00978
g excratemonth="1-2006" 

*Surveyyear
g surveyyear=2006

*Wave
g wave=4

keep 	sheno ///
		surveyyear wave ///
		excrate excratemonth ///
		profits sales hours wageworker laborincome employees ///
		survival newfirmstarted mainactivity reasonclosure

foreach var of varlist 	surveyyear wave ///
						excrate excratemonth ///
						profits sales hours wageworker laborincome employees ///
						survival newfirmstarted mainactivity reasonclosure{
rename `var' `var'4
}	

save SLMS4, replace

********************************************************************************
*Round 5
use "SLMS/SLMSMaster_web.dta",clear
keep if wave==5
keep sheno hhsize
merge 1:1 sheno using "SLMS/SLMSround5_labeled.dta", nogenerate keep(3)
merge 1:1 sheno using  "SLMS/SLMS_HHround5_labeled.dta", nogenerate keep(3)
********************************************************************************

*Survival
g survival=(e1_1==1 | e1_1==3 ) if e1_1!=.


*Main activity after closing business
label define mainactivity 	1 "Working for a wage" ///
							2 "Looking for work" ///
							3 "Operating a different business" ///
							4 "Housework or looking after children"

g mainactivity=e1_13 if e1_13!=.
label values mainactivity mainactivity		

*New firm started since last survey
g newfirmstarted=((e1_1==2 | e1_1==4) & mainactivity==3) if mainactivity!=.

*Reason for closing business
gen reasonclosure=e1_6
replace reasonclosure=3 if e1_6==4
replace reasonclosure=4 if e1_6==3
replace reasonclosure=10 if e1_6==5
replace reasonclosure=9 if e1_6==6

label define closereason 1 "making a loss" 2 "sickness" 3 "care for family" 4 "better wage job" 5 "migrate abroad" 6 "married" 7 "shut down by govt." 8 "taken from me" 9 "other" 10 "better business opportunity"
label values reasonclosure closereason

*Sales in last month
egen salesslms=rowtotal(em3_2 et3_2 es3_2)
replace e3_4=0 if e3_4==.
rename e3_4 sales

*Profits in last month
rename prof profits

*Hours worked in self-employment in last month
*based on hours worked  in last week
g hours=e2_4*(30/7) 

*Worked as wage worker in last month
g wageworker=(e3_9_1==1) if e3_9_1!=.
replace wageworker=1 if mainactivity==1

*Labor earnings from all labor, including the business, in last month
g monthlywagelaborincome=ex5*(30/7)
replace monthlywagelaborincome=e3_9_3*(30/7) if e3_9_3!=.
egen laborincome=rowtotal(monthlywagelaborincome profits), m

*Number of paid employees
rename e2_9a1 employees
replace employees=. if employees==995 | employees==996

*Excrate and excratemonth
*Survey took place in April 2006 so I take April 15, 2006 as approx. midpoint
g excrate=0.00974
g excratemonth="4-2006" 

*Surveyyear
g surveyyear=2006

*Wave
g wave=5

*Household expenditure per capita
egen weeklyexp=rowtotal(q1_1a q1_1b)
egen monthlyexp=rowtotal(q1_2a q1_2b q1_2c q1_2d q1_2e q1_2f q1_2g q1_2h q1_2i)
egen semiannuallyexp=rowtotal(q1_3a q1_3b)
egen yearlyexp=rowtotal(q1_4a q1_4b q1_4c)

g pcexpend=(52*weeklyexp+12*monthlyexp+2*semiannuallyexp+yearlyexp)/hhsize


keep 	sheno ///
		surveyyear wave ///
		excrate excratemonth ///
		profits sales hours wageworker laborincome employees ///
		survival newfirmstarted mainactivity reasonclosure ///
		pcexpend

foreach var of varlist 	surveyyear wave ///
						excrate excratemonth ///
						profits sales hours wageworker laborincome employees ///
						survival newfirmstarted mainactivity reasonclosure ///
						pcexpend{
rename `var' `var'5
}	

save SLMS5, replace


********************************************************************************
*Round 6 
use "SLMS/SLMSround6.dta", clear
********************************************************************************

*Survival
g survival=(f1_1==1 | f1_1==3 ) if f1_1!=.


*Main activity after closing business
label define mainactivity 	1 "Working for a wage" ///
							2 "Looking for work" ///
							3 "Operating a different business" ///
							4 "Housework or looking after children"

g mainactivity=f1_13 if f1_13!=.
label values mainactivity mainactivity		

*New firm started since last survey
g newfirmstarted=((f1_1==2 | f1_1==4) & mainactivity==3) if mainactivity!=.

*Reason for closing business
gen reasonclosure=f1_6
replace reasonclosure=3 if f1_6==4
replace reasonclosure=4 if f1_6==3
replace reasonclosure=10 if f1_6==5
replace reasonclosure=9 if f1_6==6

label define closereason 1 "making a loss" 2 "sickness" 3 "care for family" 4 "better wage job" 5 "migrate abroad" 6 "married" 7 "shut down by govt." 8 "taken from me" 9 "other" 10 "better business opportunity"
label values reasonclosure closereason

*Sales in last month
egen salesslms=rowtotal(fm3_2 ft3_2 fs3_2)
replace f3_4=0 if f3_4==.
rename f3_4 sales

*Profits in last month
rename prof profits

*Hours worked in self-employment in last month
*based on hours worked  in last week
g hours=f2_4*(30/7) 

*Worked as wage worker in last month
g wageworker=(f3_9_1==1) if f3_9_1!=.
replace wageworker=1 if mainactivity==1

*Labor earnings from all labor, including the business, in last month
g monthlywagelaborincome=fx5*(30/7)
replace monthlywagelaborincome=f3_9_3*(30/7) if f3_9_3!=.
egen laborincome=rowtotal(monthlywagelaborincome profits), m

*Number of paid employees
rename f2_9a1 employees
replace employees=. if employees==995 | employees==996

*Excrate and excratemonth
*Survey took place in July 2006 so I take July 15, 2006 as approx. midpoint
g excrate=0.00961
g excratemonth="7-2006" 

*Surveyyear
g surveyyear=2006

*Wave
g wave=6


keep 	sheno ///
		surveyyear wave ///
		excrate excratemonth ///
		profits sales hours wageworker laborincome employees ///
		survival newfirmstarted mainactivity reasonclosure

foreach var of varlist 	surveyyear wave ///
						excrate excratemonth ///
						profits sales hours wageworker laborincome employees ///
						survival newfirmstarted mainactivity reasonclosure {
rename `var' `var'6
}	

save SLMS6, replace


********************************************************************************
*Round 7
use "SLMS/SLMSround7.dta", clear
********************************************************************************

*Survival
g survival=(g1_1==1 | g1_1==3 ) if g1_1!=.


*Main activity after closing business
label define mainactivity 	1 "Working for a wage" ///
							2 "Looking for work" ///
							3 "Operating a different business" ///
							4 "Housework or looking after children"

g mainactivity=g1_13 if g1_13!=.
label values mainactivity mainactivity		

*New firm started since last survey
g newfirmstarted=((g1_1==2 | g1_1==4) & mainactivity==3) if mainactivity!=.

*Reason for closing business
gen reasonclosure=g1_6
replace reasonclosure=3 if g1_6==4
replace reasonclosure=4 if g1_6==3
replace reasonclosure=10 if g1_6==5
replace reasonclosure=9 if g1_6==6

label define closereason 1 "making a loss" 2 "sickness" 3 "care for family" 4 "better wage job" 5 "migrate abroad" 6 "married" 7 "shut down by govt." 8 "taken from me" 9 "other" 10 "better business opportunity"
label values reasonclosure closereason

*Sales in last month
egen salesslms=rowtotal(gm3_2 gt3_2 gs3_2)
replace g3_4=0 if g3_4==.
rename g3_4 sales

*Profits in last month
rename prof profits

*Hours worked in self-employment in last month
*based on hours worked  in last week
g hours=g2_4*(30/7) 

*Worked as wage worker in last month
g wageworker=(g3_9_1==1) if g3_9_1!=.
replace wageworker=1 if mainactivity==1

*Labor earnings from all labor, including the business, in last month
g monthlywagelaborincome=gx5*(30/7)
replace monthlywagelaborincome=g3_9_3*(30/7) if g3_9_3!=.
egen laborincome=rowtotal(monthlywagelaborincome profits), m

*Number of paid employees
rename g2_9a1 employees
replace employees=. if employees==995 | employees==996

*Excrate and excratemonth
*Survey took place in October 2006 so I take October 15, 2006 as approx. midpoint
g excrate=0.00942
g excratemonth="10-2006" 

*Surveyyear
g surveyyear=2006

*Wave
g wave=7


keep 	sheno ///
		surveyyear wave ///
		excrate excratemonth ///
		profits sales hours wageworker laborincome employees ///
		survival newfirmstarted mainactivity reasonclosure

foreach var of varlist 	surveyyear wave ///
						excrate excratemonth ///
						profits sales hours wageworker laborincome employees ///
						survival newfirmstarted mainactivity reasonclosure {
rename `var' `var'7
}	

save SLMS7, replace

********************************************************************************
*Round 8
use "SLMS/SLMSround8.dta", clear
********************************************************************************

*Survival
g survival=(h1_1==1 | h1_1==3 ) if h1_1!=.


*Main activity after closing business
label define mainactivity 	1 "Working for a wage" ///
							2 "Looking for work" ///
							3 "Operating a different business" ///
							4 "Housework or looking after children"

g mainactivity=h1_13 if h1_13!=.
label values mainactivity mainactivity		

*New firm started since last survey
g newfirmstarted=((h1_1==2 | h1_1==4) & mainactivity==3) if mainactivity!=.

*Reason for closing business
gen reasonclosure=h1_6
replace reasonclosure=3 if h1_6==4
replace reasonclosure=4 if h1_6==3
replace reasonclosure=10 if h1_6==5
replace reasonclosure=9 if h1_6==6

label define closereason 1 "making a loss" 2 "sickness" 3 "care for family" 4 "better wage job" 5 "migrate abroad" 6 "married" 7 "shut down by govt." 8 "taken from me" 9 "other" 10 "better business opportunity"
label values reasonclosure closereason

*Sales in last month
egen salesslms=rowtotal(hm3_2 ht3_2 hs3_2)
replace h3_4=0 if h3_4==.
rename h3_4 sales

*Profits in last month
rename prof profits

*Hours worked in self-employment in last month
*based on hours worked  in last week
g hours=h2_4*(30/7) 

*Worked as wage worker in last month
g wageworker=(h3_9_1==1) if h3_9_1!=.
replace wageworker=1 if mainactivity==1

*Labor earnings from all labor, including the business, in last month
g monthlywagelaborincome=hx5*(30/7)
replace monthlywagelaborincome=h3_9_3*(30/7) if h3_9_3!=.
egen laborincome=rowtotal(monthlywagelaborincome profits), m

*Number of paid employees
rename h2_9a1 employees
replace employees=. if employees==995 | employees==996

*Excrate and excratemonth
*Survey took place in January 2007 so I take January 15, 2007 as approx. midpoint
g excrate=0.00921
g excratemonth="1-2007" 

*Surveyyear
g surveyyear=2007

*Wave
g wave=8


keep 	sheno ///
		surveyyear wave ///
		excrate excratemonth ///
		profits sales hours wageworker laborincome employees ///
		survival newfirmstarted mainactivity reasonclosure

foreach var of varlist 	surveyyear wave ///
						excrate excratemonth ///
						profits sales hours wageworker laborincome employees ///
						survival newfirmstarted mainactivity reasonclosure {
rename `var' `var'8
}	

save SLMS8, replace


********************************************************************************
*Round 9
use "SLMS/SLMSMaster_web.dta",clear
keep if wave==9
keep sheno hhsize
merge 1:1 sheno using "SLMS/SLMSround9.dta", nogenerate keep(3)
merge 1:1 sheno using  "SLMS/SLMS_HHround9_labeled.dta", keep(1 3)
********************************************************************************

*Survival
g survival=(i1_1==1 | i1_1==3 ) if i1_1!=.


*Main activity after closing business
label define mainactivity 	1 "Working for a wage" ///
							2 "Looking for work" ///
							3 "Operating a different business" ///
							4 "Housework or looking after children"

g mainactivity=i1_13 if i1_13!=.
label values mainactivity mainactivity		

*New firm started since last survey
g newfirmstarted=((i1_1==2 | i1_1==4) & mainactivity==3) if mainactivity!=.

*Reason for closing business
gen reasonclosure=i1_6
replace reasonclosure=3 if i1_6==4
replace reasonclosure=4 if i1_6==3
replace reasonclosure=10 if i1_6==5
replace reasonclosure=9 if i1_6==6

label define closereason 1 "making a loss" 2 "sickness" 3 "care for family" 4 "better wage job" 5 "migrate abroad" 6 "married" 7 "shut down by govt." 8 "taken from me" 9 "other" 10 "better business opportunity"
label values reasonclosure closereason

*Sales in last month
egen salesslms=rowtotal(im3_2 it3_2 is3_2)
replace i3_4=0 if i3_4==.
rename i3_4 sales

*Profits in last month
rename prof profits

*Hours worked in self-employment in last month
*based on hours worked  in last week
g hours=i2_4*(30/7) 

*Worked as wage worker in last month
g wageworker=(i3_9_1==1) if i3_9_1!=.
replace wageworker=1 if mainactivity==1

*Labor earnings from all labor, including the business, in last month
g monthlywagelaborincome=ix5*(30/7)
replace monthlywagelaborincome=i3_9_3*(30/7) if i3_9_3!=.
egen laborincome=rowtotal(monthlywagelaborincome profits), m

*Number of paid employees
rename i2_9a1 employees
replace employees=. if employees==995 | employees==996

*Excrate and excratemonth
*Survey took place in April 2007 so I take April 15, 2007 as approx. midpoint
g excrate=0.00916
g excratemonth="4-2007" 

*Surveyyear
g surveyyear=2007

*Wave
g wave=9

*Household expenditure per capita
egen weeklyexp=rowtotal(c1_1a c1_1b) if _merge!=1
egen monthlyexp=rowtotal(c1_2a c1_2b c1_2c c1_2d c1_2e c1_2f c1_2g c1_2h c1_2i c1_2j) if _merge!=1
egen semiannuallyexp=rowtotal(c1_3a c1_3b) if _merge!=1
egen yearlyexp=rowtotal(c1_4a c1_4b c1_4c) if _merge!=1

g pcexpend=(52*weeklyexp+12*monthlyexp+2*semiannuallyexp+yearlyexp)/hhsize


keep 	sheno ///
		surveyyear wave ///
		excrate excratemonth ///
		profits sales hours wageworker laborincome employees ///
		survival newfirmstarted mainactivity reasonclosure ///
		pcexpend

foreach var of varlist 	surveyyear wave ///
						excrate excratemonth ///
						profits sales hours wageworker laborincome employees ///
						survival newfirmstarted mainactivity reasonclosure ///
						pcexpend{
rename `var' `var'9
}	

save SLMS9, replace

********************************************************************************
*Round 10
use "SLMS/SLMSround10.dta", clear
********************************************************************************

*Survival
g survival=(j1_1==1 | j1_1==3 ) if j1_1!=.


*Main activity after closing business
label define mainactivity 	1 "Working for a wage" ///
							2 "Looking for work" ///
							3 "Operating a different business" ///
							4 "Housework or looking after children"

g mainactivity=j1_13 if j1_13!=.
label values mainactivity mainactivity		

*New firm started since last survey
g newfirmstarted=((j1_1==2 | j1_1==4) & mainactivity==3) if mainactivity!=.

*Reason for closing business
gen reasonclosure=j1_6
replace reasonclosure=3 if j1_6==4
replace reasonclosure=4 if j1_6==3
replace reasonclosure=10 if j1_6==5
replace reasonclosure=9 if j1_6==6

label define closereason 1 "making a loss" 2 "sickness" 3 "care for family" 4 "better wage job" 5 "migrate abroad" 6 "married" 7 "shut down by govt." 8 "taken from me" 9 "other" 10 "better business opportunity"
label values reasonclosure closereason

*Sales in last month
egen salesslms=rowtotal(jm3_2 jt3_2 js3_2)
replace j3_4=0 if j3_4==.
rename j3_4 sales

*Profits in last month
rename prof profits

*Hours worked in self-employment in last month
*based on hours worked  in last week
g hours=j2_4*(30/7) 

*Worked as wage worker in last month
g wageworker=(j3_9_1==1) if j3_9_1!=.
replace wageworker=1 if mainactivity==1

*Labor earnings from all labor, including the business, in last month
g monthlywagelaborincome=jx5*(30/7)
replace monthlywagelaborincome=j3_9_3*(30/7) if j3_9_3!=.
egen laborincome=rowtotal(monthlywagelaborincome profits), m

*Number of paid employees
rename j2_9a1 employees
replace employees=. if employees==995 | employees==996

*Excrate and excratemonth
*Survey took place in October 2007 so I take October 15, 2007 as approx. midpoint
g excrate=0.00864
g excratemonth="10-2007" 

*Surveyyear
g surveyyear=2007

*Wave
g wave=10

keep 	sheno ///
		surveyyear wave ///
		excrate excratemonth ///
		profits sales hours wageworker laborincome employees ///
		survival newfirmstarted mainactivity reasonclosure

foreach var of varlist 	surveyyear wave ///
						excrate excratemonth ///
						profits sales hours wageworker laborincome employees ///
						survival newfirmstarted mainactivity reasonclosure {
rename `var' `var'10
}	

save SLMS10, replace


********************************************************************************
*Round 11
use "SLMS/SLMSMaster_web.dta",clear
keep if wave==11
keep sheno hhsize
merge 1:1 sheno using "SLMS/SLMSround11.dta", nogenerate keep(3)
merge 1:1 sheno using  "SLMS/SLMS_HHround11_labeled.dta", keep(1 3)
********************************************************************************

*Survival
g survival=(k1_1==1 | k1_1==3 ) if k1_1!=.


*Main activity after closing business
label define mainactivity 	1 "Working for a wage" ///
							2 "Looking for work" ///
							3 "Operating a different business" ///
							4 "Housework or looking after children"

g mainactivity=k1_13 if k1_13!=.
label values mainactivity mainactivity		

*New firm started since last survey
g newfirmstarted=((k1_1==2 | k1_1==4) & mainactivity==3) if mainactivity!=.

*Reason for closing business
gen reasonclosure=k1_6
replace reasonclosure=3 if k1_6==4
replace reasonclosure=4 if k1_6==3
replace reasonclosure=10 if k1_6==5
replace reasonclosure=9 if k1_6==6

label define closereason 1 "making a loss" 2 "sickness" 3 "care for family" 4 "better wage job" 5 "migrate abroad" 6 "married" 7 "shut down by govt." 8 "taken from me" 9 "other" 10 "better business opportunity"
label values reasonclosure closereason

*Sales in last month
egen salesslms=rowtotal(km3_2 kt3_2 ks3_2)
replace k3_4=0 if k3_4==.
rename k3_4 sales

*Profits in last month
rename prof profits

*Hours worked in self-employment in last month
*based on hours worked  in last week
g hours=k2_4*(30/7) 

*Worked as wage worker in last month
g wageworker=(k3_9_1==1) if k3_9_1!=.
replace wageworker=1 if mainactivity==1

*Labor earnings from all labor, including the business, in last month
g monthlywagelaborincome=kx5*(30/7)
replace monthlywagelaborincome=k3_9_3*(30/7) if k3_9_3!=.
egen laborincome=rowtotal(monthlywagelaborincome profits), m

*Number of paid employees
rename k2_9a1 employees
replace employees=. if employees==995 | employees==996

*Excrate and excratemonth
*Survey took place in April 2008 so I take April 15, 2008 as approx. midpoint
g excrate=0.00925
g excratemonth="4-2008" 

*Surveyyear
g surveyyear=2008

*Wave
g wave=11

*Household expenditure per capita
egen weeklyexp=rowtotal(k1_1a k1_1b) if _merge!=1
egen monthlyexp=rowtotal(k1_2a k1_2b k1_2c k1_2d k1_2e k1_2f k1_2g k1_2h k1_2i k1_2j) if _merge!=1
egen semiannuallyexp=rowtotal(k1_3a k1_3b) if _merge!=1
egen yearlyexp=rowtotal(k1_4a k1_4b k1_4c) if _merge!=1

g pcexpend=(52*weeklyexp+12*monthlyexp+2*semiannuallyexp+yearlyexp)/hhsize


keep 	sheno ///
		surveyyear wave ///
		excrate excratemonth ///
		profits sales hours wageworker laborincome employees ///
		survival newfirmstarted mainactivity reasonclosure ///
		pcexpend

foreach var of varlist 	surveyyear wave ///
						excrate excratemonth ///
						profits sales hours wageworker laborincome employees ///
						survival newfirmstarted mainactivity reasonclosure ///
						pcexpend{
rename `var' `var'11
}	

save SLMS11, replace


********************************************************************************
*Round 12
use "SLMS/SLMSround12.dta", clear
********************************************************************************

*Survival
g survival=(q1_1c==1 | q1_1c==3 | q1_1c==5 | q1_1c==6) if q1_1c!=.


*Main activity after closing business
label define mainactivity 	1 "Working for a wage" ///
							2 "Looking for work" ///
							3 "Operating a different business" ///
							4 "Housework or looking after children" ///
							5 "Operating a new business along with the old one"

g mainactivity=q1_13 if q1_13!=.
label values mainactivity mainactivity		

*New firm started since last survey
g newfirmstarted=((q1_1c==2 | q1_1c==4 | q1_1c==5 | q1_1c==6) & (mainactivity==3 | mainactivity==5)) if mainactivity!=.

*Sales in last month
rename q7_6 sales

*Profits in last month
rename q7_9 profits

*Hours worked in self-employment in last month
*based on hours worked in last week
g hours=q5_4a*(30/7) 

*based on hours worked in a normal week
g hoursnormal=q5_4b*(30/7) 

*Worked as wage worker in last month
g wageworker=mainactivity==1

*Labor earnings from all labor, including the business, in last month
g monthlywagelaborincome=q2_5*(30/7)
egen laborincome=rowtotal(monthlywagelaborincome profits), m

*Number of paid employees
gen p_spouse = q5_6b_1 if q5_6e_1==1 | q5_6e_1==2
gen p_child = q5_6b_2 if q5_6e_2==1 | q5_6e_2==2
gen p_sibling = q5_6b_3 if q5_6e_3==1 | q5_6e_3==2
gen p_parent = q5_6b_4 if q5_6e_4==1 | q5_6e_4==2
gen p_parentsinlaw = q5_6b_5 if q5_6e_5==1 | q5_6e_5==2
gen p_other_relative = q5_6b_6 if q5_6e_6==1 | q5_6e_6==2
gen p_non_relative = q5_6b_7 if q5_6e_7==1 | q5_6e_7==2

foreach x in p_spouse p_child p_sibling p_parent p_parentsinlaw p_other_relative p_non_relative {
recode `x' (.=0)
}

gen employees = p_spouse+p_child+p_sibling+p_parent+p_parentsinlaw+p_other_relative+p_non_relative

*Excrate and excratemonth
*Survey took place in June 2010 so I take June 15, 2010 as approx. midpoint
g excrate=0.00879
g excratemonth="6-2010" 

*Surveyyear
g surveyyear=2010

*Wave
g wave=12

*Subjective wellbeing on Cantril ladder
rename q9_1 subjwell

keep 	sheno ///
		surveyyear wave ///
		excrate excratemonth ///
		profits sales hours hoursnormal wageworker laborincome employees ///
		survival newfirmstarted mainactivity ///
		subjwell

foreach var of varlist 	surveyyear wave ///
						excrate excratemonth ///
						profits sales hours hoursnormal wageworker laborincome employees ///
						survival newfirmstarted mainactivity ///
						subjwell{
rename `var' `var'12
}	

save SLMS12, replace

********************************************************************************
*Round 13
use "SLMS/SLMSround13.dta", clear
********************************************************************************

*Survival
g survival=(q1_1c==1 | q1_1c==3 | q1_1c==5 | q1_1c==6) if q1_1c!=.


*Main activity after closing business
label define mainactivity 	1 "Working for a wage" ///
							2 "Looking for work" ///
							3 "Operating a different business" ///
							4 "Housework or looking after children" ///
							5 "Operating a new business along with the old one"

g mainactivity=q1_13 if q1_13!=.
label values mainactivity mainactivity		

*New firm started since last survey
g newfirmstarted=((q1_1c==2 | q1_1c==4 | q1_1c==5 | q1_1c==6) & (mainactivity==3 | mainactivity==5)) if mainactivity!=.

*Sales in last month
rename q7_6 sales

*Profits in last month
rename q7_9 profits

*Hours worked in self-employment in last month
*based on hours worked in last week
g hours=q5_4a*(30/7) 

*based on hours worked in a normal week
g hoursnormal=q5_4b*(30/7) 

*Worked as wage worker in last month
g wageworker=mainactivity==1

*Labor earnings from all labor, including the business, in last month
g monthlywagelaborincome=q2_5*(30/7)
egen laborincome=rowtotal(monthlywagelaborincome profits), m

*Number of paid employees
gen p_spouse = q5_6b_1 if q5_6e_1==1 | q5_6e_1==2
gen p_child = q5_6b_2 if q5_6e_2==1 | q5_6e_2==2
gen p_sibling = q5_6b_3 if q5_6e_3==1 | q5_6e_3==2
gen p_parent = q5_6b_4 if q5_6e_4==1 | q5_6e_4==2
gen p_parentsinlaw = q5_6b_5 if q5_6e_5==1 | q5_6e_5==2
gen p_other_relative = q5_6b_6 if q5_6e_6==1 | q5_6e_6==2
gen p_non_relative = q5_6b_7 if q5_6e_7==1 | q5_6e_7==2

foreach x in p_spouse p_child p_sibling p_parent p_parentsinlaw p_other_relative p_non_relative {
recode `x' (.=0)
}

gen employees = p_spouse+p_child+p_sibling+p_parent+p_parentsinlaw+p_other_relative+p_non_relative

*Excrate and excratemonth
*Survey took place in December 2010 so I take December 15, 2010 as approx. midpoint
g excrate=0.00901
g excratemonth="12-2010" 

*Surveyyear
g surveyyear=2010

*Wave
g wave=13

*Subjective wellbeing on Cantril ladder
rename q9_1 subjwell

keep 	sheno ///
		surveyyear wave ///
		excrate excratemonth ///
		profits sales hours hoursnormal wageworker laborincome employees ///
		survival newfirmstarted mainactivity ///
		subjwell

foreach var of varlist 	surveyyear wave ///
						excrate excratemonth ///
						profits sales hours hoursnormal wageworker laborincome employees ///
						survival newfirmstarted mainactivity ///
						subjwell{
rename `var' `var'13
}	

save SLMS13, replace

********************************************************************************
*Round 14
use "SLMS/SLMS R14 Sep 2015 HH Roster cleaned dataset v2 20160202.dta", clear
*Generate hhsize
bysort sheno: egen hhsizehlp=total(q10_4_11) if q10_4_11==1
bysort sheno: egen hhsize=max( hhsizehlp)
keep sheno hhsize
duplicates drop

merge 1:1 sheno using "SLMS/SLMS R14 Sep 2015 cleaned dataset v2 20160202.dta", nogenerate
********************************************************************************

*Survival
gen survival=1 if qf_4==1|qf_4==3|qf_4==4
replace survival=0 if qf_4==2
replace survival=1 if q1_4==1
replace survival=0 if q1_4==2
replace survival=0 if q4_11_b==1 | q4_11_e==1
gen neveroperate=q1_6==3

gen reasonclosure=q2_2d
replace reasonclosure=9 if q2_2d==10
replace reasonclosure=10 if q2_2d==9
label define closereason 1 "making a loss" 2 "sickness" 3 "care for family" 4 "better wage job" 5 "migrate abroad" 6 "married" 7 "shut down by govt." 8 "taken from me" 9 "other" 10 "better business idea"
label values reasonclosure closereason

gen mainactivity=1 if q3_2<=2
replace mainactivity=2 if mainactivity==. & q3_8==1

*New firm start can only be coded for the main business
g helplastivwdate="12"+"-"+"2010"
g lastivwmonth=monthly(helplastivwdate,"MY")

g helpbusstartdate=string(q4_3_m)+"-"+string(q4_3_y) if q4_3_m!=999 & q4_3_y!=999
g busstartdate=monthly(helpbusstartdate,"MY")

g newfirmstarted=(busstartdate>lastivwmonth) if busstartdate!=.
replace newfirmstarted=(q4_3_y > 2010) if q4_3_y!=. & busstartdate==.
replace newfirmstarted=1 if q4_11_b==1 | q4_11_c==1 | q4_11_e==1

*If not operating a business, no firm start
replace newfirmstarted=0 if q1_4==2

replace mainactivity=3 if mainactivity==. & newfirmstarted==1


*Worked as wage worker in last month
g wageworker=q4_7==1
replace wageworker=1 if mainactivity==1

*Labor earnings from all labor, including the business, in last month
gen laborincome=0
replace laborincome=q3_7*(30/7) if q3_7~=. 
replace laborincome=laborincome+q4_9*(30/7) if q4_9~=.

*Hours worked in self-employment in last month
gen hours=q5_6_a*(30/7)
gen hoursnormal=q5_6_b*(30/7)

*Number of paid employees
egen employees=rowtotal(q5_9_a q5_9_b)

*Business sales in last month
gen sales=q6_5a if q6_5a~=999

*Business profits in last month
gen profits=q6_6a if q6_6a~=999
replace laborincome=laborincome+profits if profits~=.

*Surveyyear
gen surveyyear=2015

*Wave
g wave=14

*Excrate and excratemonth
*Survey took place in September 2015, so I take September 15, 2015 as approx. midpoint
g excrate=0.00704
g excratemonth="9-2015" 

*Subjective wellbeing on Cantril ladder
rename q9_1 subjwell

*Household expenditure per capita
egen weeklyexp=rowtotal(q12_1_a q12_1_b), m
egen monthlyexp=rowtotal(q12_2_a q12_2_b q12_2_c q12_2_d q12_2_e q12_2_f q12_2_g q12_2_h q12_2_i q12_2_j q12_2_k q12_2_l), m
egen semiannuallyexp=rowtotal(q12_3_a q12_3_b q12_3_c), m 
egen yearlyexp=rowtotal(q12_4_a q12_4_b q12_4_c q12_4_d q12_4_e q12_4_f), m

g pcexpend=(52*weeklyexp+12*monthlyexp+2*semiannuallyexp+yearlyexp)/hhsize

*Firm attrits from survey
g attrit=(survival==.)


keep 	sheno ///
		surveyyear wave ///
		excrate excratemonth ///
		profits sales hours hoursnormal wageworker laborincome employees ///
		survival newfirmstarted mainactivity reasonclosure ///
		subjwell ///
		pcexpend ///
		attrit

foreach var of varlist 	surveyyear wave ///
						excrate excratemonth ///
						profits sales hours hoursnormal wageworker laborincome employees ///
						survival newfirmstarted mainactivity reasonclosure ///
						subjwell ///
						pcexpend ///
						attrit{
rename `var' `var'14
}	

save SLMS14, replace

********************************************************************************
*Round 15
use "SLMS/SLMS R15 March 2016 Dataset 20160707.dta", clear
********************************************************************************

*Survival
gen survival=1 if qf_4==1|qf_4==3|qf_4==4
replace survival=0 if qf_4==2
replace survival=1 if q1_4==1
replace survival=0 if q1_4==2
replace survival=0 if q4_11b==1 | q4_11e==1
gen neveroperate=q1_6==3


gen reasonclosure=q2_2d
replace reasonclosure=9 if q2_2d==10
replace reasonclosure=10 if q2_2d==9
label define closereason 1 "making a loss" 2 "sickness" 3 "care for family" 4 "better wage job" 5 "migrate abroad" 6 "married" 7 "shut down by govt." 8 "taken from me" 9 "other" 10 "better business idea"
label values reasonclosure closereason

gen mainactivity=1 if q3_2<=2
replace mainactivity=2 if mainactivity==. & q3_8==1

*New firm start can only be coded for the main business
g helplastivwdate="9"+"-"+"2015"
g lastivwmonth=monthly(helplastivwdate,"MY")

g helpbusstartdate=string(q4_3m)+"-"+string(q4_3y) if q4_3m!=999 & q4_3y!=999 & q4_3y!=996
g busstartdate=monthly(helpbusstartdate,"MY")

g newfirmstarted=(busstartdate>lastivwmonth) if busstartdate!=.
replace newfirmstarted=(q4_3y > 2015) if q4_3y!=. & busstartdate==.
replace newfirmstarted=1 if q4_11b==1 | q4_11c==1 | q4_11e==1

*If not operating a business, no firm start
replace newfirmstarted=0 if q1_4==2

replace mainactivity=3 if mainactivity==. & newfirmstarted==1

*Worked as wage worker in last month
g wageworker=q4_7==1
replace wageworker=1 if mainactivity==1

*Labor earnings from all labor, including the business, in last month
gen laborincome=0
replace laborincome=q3_7*(30/7) if q3_7~=. 
replace laborincome=laborincome+q4_9*(30/7) if q4_9~=.

*Hours worked in self-employment in last month
gen hours=q5_7a*(30/7)
gen hoursnormal=q5_7b*(30/7)

*Number of paid employees
egen employees=rowtotal(q5_10a q5_10b)

*Business sales in last month
gen sales=q6_5a if q6_5a~=996

*Business profits in last month
gen profits=q6_6a if q6_6a~=996
replace laborincome=laborincome+profits if profits~=.

*Surveyyear
gen surveyyear=2016

*Wave
g wave=15

*Excrate and excratemonth
*Survey took place in March 2016, so I take March 15, 2016 as approx. midpoint
g excrate=0.00677
g excratemonth="3-2016" 

*Subjective wellbeing on Cantril ladder
rename q9_1 subjwell

*Firm attrits from survey
g attrit=(survival==.)


keep 	sheno ///
		surveyyear wave ///
		excrate excratemonth ///
		profits sales hours hoursnormal wageworker laborincome employees ///
		survival newfirmstarted mainactivity reasonclosure ///
		subjwell ///
		attrit

foreach var of varlist 	surveyyear wave ///
						excrate excratemonth ///
						profits sales hours hoursnormal wageworker laborincome employees ///
						survival newfirmstarted mainactivity reasonclosure ///
						subjwell ///
						attrit{
rename `var' `var'15
}	

save SLMS15, replace


********************************************************************************

********************************************************************************
*Merge rounds 1-15 together
********************************************************************************

********************************************************************************

forvalues i=2/13{
use SLMS1, clear
merge 1:1 sheno using SLMS`i'
g attrit`i'=_merge==1
drop _merge
replace wave`i'=`i' if wave`i'==.
save SLMS`i', replace
}

use SLMS1, clear
forvalues i=2/15{
merge 1:1 sheno using SLMS`i', nogenerate
}


quietly: reshape long 	surveyyear wave excrate excratemonth ///
						capitalstock inventories ///
						ownerage female married educyears ownertertiary childunder5 childaged5to12 adult65andover digitspan raven ///
						agefirm retail manuf services ///
						, ///
						i(sheno) j(survey)
		
foreach x in  profits sales hours hoursnormal employees pcexpend {
replace `x'=. if wave!=1
}	

*Recode survival, which has so far been coded from round to round so that it gives survival since baseline
*(Given that in round 12, the reference was the baseline, I do not have to recode survival12)
replace survival15=0 if survival12==0 & survival13==0 & survival14==0 & newfirmstarted14==1
replace survival15=0 if survival12==0 & survival13==1 & survival14==0 & newfirmstarted14==1
replace survival15=0 if survival12==1 & survival13==1 & survival14==0 & newfirmstarted14==1
replace survival15=0 if survival12==1 & survival13==1 & survival14==0 & newfirmstarted14==1
replace survival15=0 if survival12==1 & survival13==0 & newfirmstarted13==1
replace survival15=0 if survival12==0 & survival13==0 & newfirmstarted13==1
replace survival15=0 if survival12==0 & survival13==1 & newfirmstarted12==1

replace survival14=0 if survival12==1 & survival13==0 & newfirmstarted13==1
replace survival14=0 if survival12==0 & survival13==0 & newfirmstarted13==1
replace survival14=0 if survival12==0 & survival13==1 & newfirmstarted12==1

replace survival13=0 if survival12==0 & survival13==1 & newfirmstarted12==1

*Given that in round 12, the reference was the baseline, I do not have to recode survival12

replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & newfirmstarted4==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival11=0 if survival2==1 & survival3==0 & newfirmstarted3==1
replace survival11=0 if survival2==0 & survival3==0 & newfirmstarted3==1
replace survival11=0 if survival2==0 & survival3==1 & newfirmstarted2==1

replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & newfirmstarted4==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival10=0 if survival2==1 & survival3==0 & newfirmstarted3==1
replace survival10=0 if survival2==0 & survival3==0 & newfirmstarted3==1
replace survival10=0 if survival2==0 & survival3==1 & newfirmstarted2==1

replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & newfirmstarted4==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival9=0 if survival2==1 & survival3==0 & newfirmstarted3==1
replace survival9=0 if survival2==0 & survival3==0 & newfirmstarted3==1
replace survival9=0 if survival2==0 & survival3==1 & newfirmstarted2==1

replace survival8=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival8=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival8=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival8=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival8=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival8=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival8=0 if survival2==0 & survival3==0 & survival4==0 & newfirmstarted4==1
replace survival8=0 if survival2==0 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival8=0 if survival2==1 & survival3==0 & newfirmstarted3==1
replace survival8=0 if survival2==0 & survival3==0 & newfirmstarted3==1
replace survival8=0 if survival2==0 & survival3==1 & newfirmstarted2==1

replace survival7=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival7=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival7=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival7=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival7=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival7=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival7=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival7=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival7=0 if survival2==0 & survival3==0 & survival4==0 & newfirmstarted4==1
replace survival7=0 if survival2==0 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival7=0 if survival2==1 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival7=0 if survival2==1 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival7=0 if survival2==1 & survival3==0 & newfirmstarted3==1
replace survival7=0 if survival2==0 & survival3==0 & newfirmstarted3==1
replace survival7=0 if survival2==0 & survival3==1 & newfirmstarted2==1

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
forvalues i=2/15{
drop if survival`i'!=1 & wave==`i'
}

foreach x in survival newfirmstarted attrit mainactivity laborincome profits sales employees{
g `x'_3mths=`x'2 if wave==1
drop `x'2
g `x'_6mths=`x'3 if wave==1
drop `x'3
g `x'_9mths=`x'4 if wave==1
drop `x'4
g `x'_1yr=`x'5 if wave==1
drop `x'5
g `x'_1p25yrs=`x'6 if wave==1
drop `x'6
g `x'_18mths=`x'7 if wave==1
drop `x'7
g `x'_1p75yrs=`x'8 if wave==1
drop `x'8
g `x'_2yrs=`x'9 if wave==1
drop `x'9
g `x'_30mths=`x'10 if wave==1
drop `x'10
g `x'_3yrs=`x'11 if wave==1
drop `x'11
g `x'_5p17yrs=`x'12 if wave==1
drop `x'12
g `x'_5p67yrs=`x'13 if wave==1
drop `x'13
g `x'_10p416yrs=`x'14 if wave==1
drop `x'14
g `x'_10p916yrs=`x'15 if wave==1
drop `x'15
}	

foreach x in reasonclosure{
g `x'_3mths=`x'2 if wave==1
drop `x'2
g `x'_6mths=`x'3 if wave==1
drop `x'3
g `x'_9mths=`x'4 if wave==1
drop `x'4
g `x'_1yr=`x'5 if wave==1
drop `x'5
g `x'_1p25yrs=`x'6 if wave==1
drop `x'6
g `x'_18mths=`x'7 if wave==1
drop `x'7
g `x'_1p75yrs=`x'8 if wave==1
drop `x'8
g `x'_2yrs=`x'9 if wave==1
drop `x'9
g `x'_30mths=`x'10 if wave==1
drop `x'10
g `x'_3yrs=`x'11 if wave==1
drop `x'11
g `x'_10p416yrs=`x'14 if wave==1
drop `x'14
g `x'_10p916yrs=`x'15 if wave==1
drop `x'15
}

foreach x in hoursnormal subjwell{
g `x'_5p17yrs=`x'12 if wave==1
drop `x'12
g `x'_5p67yrs=`x'13 if wave==1
drop `x'13
g `x'_10p416yrs=`x'14 if wave==1
drop `x'14
g `x'_10p916yrs=`x'15 if wave==1
drop `x'15
}

foreach x in pcexpend{
g `x'_1yr=`x'5 if wave==1
drop `x'5
g `x'_2yrs=`x'9 if wave==1
drop `x'9
g `x'_3yrs=`x'11 if wave==1
drop `x'11
g `x'_10p416yrs=`x'14 if wave==1
drop `x'14
}

foreach x in subjwell9l{
g `x'_6mths=`x'3 if wave==1
drop `x'3
}

replace surveyyear=2005 if wave==1 | wave==2 | wave==3
replace surveyyear=2006 if wave==4 | wave==5 | wave==6 | wave==7
replace surveyyear=2007 if wave==8 | wave==9 | wave==10
replace surveyyear=2008 if wave==11 
replace surveyyear=2010 if wave==12 | wave==13
replace surveyyear=2015 if wave==14  
replace surveyyear=2016 if wave==15  


tostring survey, replace
replace survey="BL-"+string(surveyyear) if wave==1
replace survey="R-"+string(surveyyear)+"-1" if wave==2 
replace survey="R-"+string(surveyyear)+"-2" if wave==3 
replace survey="R-"+string(surveyyear)+"-1" if wave==4
replace survey="R-"+string(surveyyear)+"-2" if wave==5
replace survey="R-"+string(surveyyear)+"-3" if wave==6
replace survey="R-"+string(surveyyear)+"-4" if wave==7
replace survey="R-"+string(surveyyear)+"-1" if wave==8
replace survey="R-"+string(surveyyear)+"-2" if wave==9
replace survey="R-"+string(surveyyear)+"-3" if wave==10
replace survey="R-"+string(surveyyear) if wave==11
replace survey="R-"+string(surveyyear)+"-1" if wave==12
replace survey="R-"+string(surveyyear)+"-2" if wave==13
replace survey="R-"+string(surveyyear) if wave==14
replace survey="L-"+string(surveyyear) if wave==15

g lastround=(wave==15)

*Generate owner, household and business id (which are the same here)
foreach var in ownerid firmid householdid{
egen `var'=group(sheno)
tostring `var', format("%04.0f") replace
replace `var'="SLMS"+"-"+`var'
}

g surveyname="SLMS"

save SLMS_masterfc,replace
				
