********************************************************************************

********************************************************************************
**THIS DO-FILE PREPARES THE DATA FROM THE NIGERIA YOUWIN! NATIONAL BUSINESS PLAN COMPETITION IMPACT EVALUATION SURVEY FOR COMBINATION INTO THE MASTER DATASET
**Small Firm Death in Developing Countries
**November 21, 2017
**David McKenzie (dmckenzie@worldbank.org) and Anna Luisa Paffhausen (apaffhausen@worldbank.org)
**The analysis was performed with Stata, version 14.2

*Note:
* This do-file cannot be replicated as the underlying raw data is not available publicly.

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
use "Nigeria YouWiN/BaselineandFirstFollowup.dta", clear

*Keep only if operating a business:
keep if m_q1==1 | h_operatesbusiness=="YES" | m_a3==1

*Keep only if owner operates only one business in each of the rounds
g m_morethanone=(m_c1>1) if m_c1!=. & m_c1!=0
keep if m_morethanone==0

*Country
g country="Nigeria"

*Surveyyear
g surveyyear=2012

*Wave
g wave=1

*Treatment status
g treatstatus=(assigntreat==1)
g control=(assigntreat==0)

*Firm has been assigned to a cash treatment group
g cashtreat=(assigntreat==1)

*Local to USD exchange rate at time of survey
*Survey took place between November 2012 and May 2013, with 50% of the surveys having been conducted by Dec. 8, 2012, so I take December 15, 2012 as approx. midpoint
g excrate=0.00628

g excratemonth="12-2012"


********************************************************************************
*Owner and Household characteristics
********************************************************************************

*Age of owner
rename age ownerage

*Gender of owner
*There is aleady a variable called female in the dataset but since it does not entirely coincide with m_gender, I drop it
drop female
g female=(m_gender==2) if m_gender!=.

*Marital status of owner
g married=(m_p8==1) if m_p8!=.

*Education of owner
**Owner has tertiary education
g ownertertiary=(m_p6==4| m_p6==5) if m_p6!=.

*Subjective wellbeing on Cantril ladder
rename m_p10 subjwell

********************************************************************************
*Firm characteristics
********************************************************************************
*Age of the firm in years
gen ivwmonth = mofd(m_date1)
format ivwmonth %tm

g helpbusstartdate=string(m_c31)+"-"+string(m_c3b) if m_c31!=. & m_c3b!=.
g busstartdate=monthly(helpbusstartdate,"MY")

g agefirm=(ivwmonth-busstartdate)/12 if busstartdate!=.

replace agefirm=round(agefirm,0.5)

*Inventories
rename m_g29 inventories
replace inventories=0 if m_g12==2

*Detailed firm sector (ISIC 2 or 3 digit)
g sector=m_c2_isci_code

*Drop if in agriculture, forestry or fishing
drop if m_c2_isci_code<510

*Firm is in retail trade
g retail=(m_c2_isci_code>=4510 & m_c2_isci_code<=4799) if m_c2_isci_code!=.

*Firm is in manufacturing sector
g manuf=(m_c2_isci_code>=1010 & m_c2_isci_code<=3320) if m_c2_isci_code!=.

*Firm is in service sector
g services=(m_c2_isci_code>=4910 & m_c2_isci_code<=9609) if m_c2_isci_code!=.

*Firm is in other sector
g othersector=((m_c2_isci_code>=510 & m_c2_isci_code<=990) | (m_c2_isci_code>=3510 & m_c2_isci_code<=4390) | (m_c2_isci_code>=9700 & m_c2_isci_code<=9900)) if m_c2_isci_code!=.

*Number of paid employees
replace m_d3ia_current_1=. if m_d3ia_current_1==998 |  m_d3ia_current_1==999 | m_d3ia_current_1==9998 |  m_d3ia_current_1==9999
replace m_d3ib_current_1=. if m_d3ib_current_1==999 | m_d3ib_current_1==9988 | m_d3ib_current_1==9998 | m_d3ib_current_1==9999
egen employees=rowtotal(m_d3ia_current_1 m_d3ib_current_1),m 

*Total workers
rename m_d3ie totalworkers
replace totalworkers=. if totalworkers==998 | totalworkers==999

*Business profits in last month
rename m_g92 profits
replace profits=. if profits==998 | profits==999 | profits==9998 | profits==9999

*Business sales in last month
rename m_g52 sales
replace sales=. if sales==998 | sales==9998 | sales==9999

*Hours worked in self-employment in last month
*based on hours worked  in last week
g hours=m_d1a*(30/7) if m_d1a!=998

*based on hours worked  in a normal week
g hoursnormal=m_d1b*(30/7) if m_d1b!=998

********************************************************************************
*Competition facing firm
********************************************************************************
*Number of competitors (here: in same G.N.)
rename m_c10 competition1
replace competition1=. if competition1==998 | competition1==999 

*Customers could replace them within a day
g competition2=(m_c13==1) if m_c13!=.

********************************************************************************
keep 	uid ///
		country surveyyear wave treatstatus control cashtreat excrate excratemonth ///
		ownerage female married ownertertiary subjwell ///
		agefirm sector inventories retail manuf services employees totalworkers profits sales hours hoursnormal ///
		competition1 competition2
		
foreach var of varlist surveyyear wave excrate excratemonth ///
				ownerage female married ownertertiary ///
				agefirm inventories retail manuf services sector{
rename `var' `var'1
}

save NGYOUWIN1, replace

********************************************************************************

********************************************************************************
*Panel variables
********************************************************************************

********************************************************************************
*Round 2 
use "Nigeria YouWiN/BaselineandFirstFollowup.dta", clear

*Keep only if operating a business:
keep if m_q1==1 | h_operatesbusiness=="YES" | m_a3==1
*Drop if in agriculture, forestry or fishing
drop if m_c2_isci_code<510
merge 1:1 uid using "Nigeria YouWiN/SecondFollowup.dta", keep(1 3) nogenerate

*Keep only if owner operates only one business in each of the rounds
g m_morethanone=(m_c1>1) if m_c1!=. & m_c1!=0
g s_morethanone=(s_b1>1) if s_b1!=. & s_b1!=0
keep if m_morethanone==0
drop  if s_sc==1 & s_morethanone!=0

*Survival
g survival=(s_a3==1) if s_a3!=. & s_a3!=3
*Did not survive, if not operating a business
replace survival=0 if s_sc==2
*Did not survive, if business is younger than the one reported in previous survey
gen ivwmonth = mofd(m_date1)
format ivwmonth %tm
g s_startyear=2013 if s_b3==1
replace s_startyear=s_b3 if s_b3!=1 & s_b3!=2
g s_helpbusstartdate=string(s_b3_b)+"-"+string(s_startyear) if s_b3_b!=. & s_startyear!=. 
g s_busstartdate=monthly(s_helpbusstartdate,"MY")
g m_helpbusstartdate=string(m_c31)+"-"+string(m_c3b) if m_c31!=. & m_c3b!=.
g m_busstartdate=monthly(m_helpbusstartdate,"MY")
format *_busstartdate %tm

replace survival=1 if s_sc==1 & s_busstartdate==.
replace survival=0 if s_sc==1 & s_busstartdate!=. & s_busstartdate!=m_busstartdate
replace survival=1 if s_sc==1 & s_busstartdate!=. & s_busstartdate==m_busstartdate

*s_bc1 does not add any new information to survival. it was only asked if owner did not operate a business (s_sc==2), in which case survival is coded as zero
			
*New firm started since last survey
*Did not start a new firm, if not operating a business
g newfirmstarted=0 if s_sc==2 | s_a3==2
replace newfirmstarted=0 if (s_sc==1 & s_busstartdate==.) | (s_sc==1 & s_busstartdate!=. & s_busstartdate==m_busstartdate)
replace newfirmstarted=1 if s_sc==1 & s_busstartdate!=. & s_busstartdate!=m_busstartdate

*Operating a new firm
g operatingnewfirm=newfirmstarted

*Attrition
g attrit=(survival==.)

*Reason for closing business
gen reasonclosure=s_bc4
replace reasonclosure=4 if s_bc4==3
replace reasonclosure=7 if s_bc4==5
replace reasonclosure=9 if s_bc4==6
replace reasonclosure=12 if s_bc4==4

replace reasonclosure=1 if s_bc4_other=="the running cost was expensive" | s_bc4_other=="lack of financing" | s_bc4_other=="Insufficient fund" | s_bc4_other=="Insufficiency  Capital" | uid==104171
* s_bc4_other="Did not reach their requirements due to lack of fianc� to get up to three trailer load of cement at a strech." for uid==104171
replace reasonclosure=5 if s_bc4_other=="Relocated with my husband"
replace reasonclosure=11 if s_bc4_other=="Hazard"

label define closereason 1 "making a loss" 2 "sickness" 3 "care for family" 4 "better wage job" 5 "migrate abroad" 6 "married" 7 "shut down by govt." 8 "taken from me" 9 "other" 10 "better business opportunity" 11 "catastrophe" 12 "I found the work too tiring or hours too long"
label values reasonclosure closereason

*Owner died between survey rounds
g dead=(s_a1==5) if s_a1!=.

*Number of paid employees
egen employees=rowtotal(s_ef3_1 s_ef3_2), m

*Total workers
g totalworkers=s_ef3_5
replace totalworkers=s_a4 if totalworkers==. & s_a4!=. & s_a4!=998 & s_a4!=999

*Business profits in last month
rename s_bf9 profits

*Business sales in last month
rename s_bf5 sales

*Hours worked in self-employment in last month
*based on hours worked  in last week
g hours=s_ef1a*(30/7)  

*based on hours worked  in a normal week
g hoursnormal=s_ef1b*(30/7) 

*Worked as wage worker in last month 
*It is however strange that all obs have zero here, although the coding allows only for values from 1 to 6
g wageworker=(s_nb1==1) if s_nb1!=.

*Labor earnings from all labor, including the business, in last month
egen laborincome=rowtotal(s_nb6 profits), m

*Subjective wellbeing on Cantril ladder
rename s_p10 subjwell

*Digit span recall of owner
g digitspan=3 if s_q13a==2 
replace digitspan=4 if s_q13a==1 & s_q13b==2
replace digitspan=5 if s_q13b==1 & s_q13c==2
replace digitspan=6 if s_q13c==1 & s_q13d==2
replace digitspan=7 if s_q13d==1 & s_q13e==2
replace digitspan=8 if s_q13e==1 & s_q13f==2
replace digitspan=9 if s_q13f==1 & s_q13g==2
replace digitspan=10 if s_q13g==1 & s_q13h==2
replace digitspan=11 if s_q13h==1

*Raven score of owner
gen raven1=s_c1==8
gen raven2=s_c2==2
gen raven3=s_c3==3
gen raven4=s_c4==8
gen raven5=s_c5==7
gen raven6=s_c6==4
gen raven7=s_c7==5
gen raven8=s_c8==1
gen raven9=s_c9==7
gen raven10=s_c10==6
gen raven11=s_c11==1
gen raven12=s_c12==2
egen raven=rsum(raven1-raven12)
replace raven=. if s_c1==. | s_c2==. | s_c3==. | s_c4==. | s_c5==. | s_c6==. | s_c7==. | s_c8==.| s_c9==. | s_c10==. | s_c11==. | s_c12==.
replace raven=raven/12

*Excrate and excratemonth
*Survey took place between October 2013 and February 2014, with 50% of the surveys having been conducted approx. by Nov. 4, 2013, so I take November 15, 2013 as approx. midpoint
g excrate=0.00623
g excratemonth="11-2013" 

*Surveyyear
g surveyyear=2013

*Wave
g wave=2


keep 	uid ///
		surveyyear wave ///
		excrate excratemonth ///
		employees totalworkers profits sales hours hoursnormal wageworker laborincome ///
		survival newfirmstarted operatingnewfirm s_busstartdate m_busstartdate attrit reasonclosure dead ///
		subjwell ///
		digitspan raven


foreach var of varlist 	surveyyear wave ///
						excrate  excratemonth ///
						employees totalworkers profits sales hours hoursnormal wageworker laborincome ///
						survival newfirmstarted operatingnewfirm attrit reasonclosure dead ///
						subjwell {
rename `var' `var'2
}	

save NGYOUWIN2, replace

********************************************************************************#
*Round 3
use "Nigeria YouWiN/BaselineandFirstFollowup.dta", clear

*Keep only if operating a business:
keep if m_q1==1 | h_operatesbusiness=="YES" | m_a3==1
*Drop if in agriculture, forestry or fishing
drop if m_c2_isci_code<510

merge 1:1 uid using "Nigeria YouWiN/ThirdFollowup.dta", keep(1 3) nogenerate

*Keep only if owner operates only one business in each of the rounds
g m_morethanone=(m_c1>1) if m_c1!=. & m_c1!=0
g t_morethanone=(t_b1>1) if t_b1!=. & t_b1!=0
keep if m_morethanone==0
drop  if t_sc==1 & t_morethanone!=0


*Survival
g survival=(t_a3==1) if t_a3!=. & t_a3!=3
*Did not survive, if not operating a business
replace survival=0 if t_sc==2
*Did not survive, if business is younger than the one reported in previous survey
gen ivwmonth = mofd(m_date1)
format ivwmonth %tm
g t_startyear=2014 if t_b3==1
g t_helpbusstartdate=string(t_b3b)+"-"+string(t_startyear) if t_b3b!=. & t_startyear!=. 
g t_busstartdate=monthly(t_helpbusstartdate,"MY")
g m_helpbusstartdate=string(m_c31)+"-"+string(m_c3b) if m_c31!=. & m_c3b!=.
g m_busstartdate=monthly(m_helpbusstartdate,"MY")
format *_busstartdate %tm

replace survival=1 if t_sc==1 & t_busstartdate==.
replace survival=0 if t_sc==1 & t_busstartdate!=. & t_busstartdate!=m_busstartdate
replace survival=1 if t_sc==1 & t_busstartdate!=. & t_busstartdate==m_busstartdate

*t_bc1 does not add any new information to survival. it was only asked if owner did not operate a business (t_sc==2), in which case survival is coded as zero
		
*New firm started since last survey
*Did not start a new firm, if not operating a business
g newfirmstarted=0 if t_sc==2 | t_a3==2
replace newfirmstarted=0 if (t_sc==1 & t_busstartdate==.) | (t_sc==1 & t_busstartdate!=. & t_busstartdate==m_busstartdate)
replace newfirmstarted=1 if t_sc==1 & t_busstartdate!=. & t_busstartdate!=m_busstartdate

*Attrition
g attrit=(survival==.)

*Reason for closing business
gen reasonclosure=t_bc4
replace reasonclosure=4 if t_bc4==3
replace reasonclosure=7 if t_bc4==5
replace reasonclosure=9 if t_bc4==6
replace reasonclosure=12 if t_bc4==4

replace reasonclosure=1 if t_tbc4c6==7 | t_tbc4c6==10
replace reasonclosure=3 if t_tbc4c6==17 
replace reasonclosure=5 if t_tbc4c6==11 
replace reasonclosure=10 if t_tbc4c6==12 
replace reasonclosure=11 if t_tbc4c6==4 | t_tbc4c6==8 

label define closereason 1 "making a loss" 2 "sickness" 3 "care for family" 4 "better wage job" 5 "migrate abroad" 6 "married" 7 "shut down by govt." 8 "taken from me" 9 "other" 10 "better business opportunity" 11 "catastrophe" 12 "I found the work too tiring or hours too long"
label values reasonclosure closereason

*Owner died between survey rounds
g dead=(t_a1==5) if t_a1!=.

*Number of paid employees
egen employees=rowtotal(t_ef3_1 t_ef3_2) if t_ef3_1!=999 & t_ef3_2!=999, m

*Total workers
g totalworkers=t_ef3_5 if t_ef3_5!=999
replace totalworkers=t_a4 if totalworkers==. & t_a4!=. & t_a4!=998 

*Business profits in last month
rename t_bf9 profits

*Business sales in last month
rename t_bf5 sales

*Hours worked in self-employment in last month
*based on hours worked  in last week
g hours=t_ef1_1*(30/7)

*based on hours worked  in a normal week
g hoursnormal=t_ef1_2*(30/7)

*Worked as wage worker in last month 
*Not sure why there are obs. with t_nb1_1==3 and t_nb1_1==6, since the options given should only have been 0 and 1 and these also don't appear in any of the other categories, so I code them as missing
g wageworker=(t_nb1_1==1) if t_nb1_1!=. & t_nb1_1!=3 & t_nb1_1!=6

*Labor earnings from all labor, including the business, in last month
egen laborincome=rowtotal(t_nb6 profits), m

*Excrate and excratemonth
g t_date=daily(t_resp_10,"DMY")
format t_date %td
su t_date, detail
*Survey took place between September 2014 and February 2015, with 50% of the surveys having been conducted approx. by Oct. 31, 2014, so I take October 31, 2014 as approx. midpoint
g excrate=0.00592
g excratemonth="10-2014" 

*Surveyyear
g surveyyear=2014

*Wave
g wave=3

keep 	uid t_sc ///
		surveyyear wave ///
		excrate excratemonth ///
		employees totalworkers profits sales hours hoursnormal wageworker laborincome ///
		survival newfirmstarted t_busstartdate attrit reasonclosure dead 


foreach var of varlist 	surveyyear wave ///
						excrate  excratemonth ///
						employees totalworkers profits sales hours hoursnormal wageworker laborincome ///
						survival newfirmstarted attrit reasonclosure dead {
rename `var' `var'3
}	

save NGYOUWIN3, replace

********************************************************************************#
*Round 4
use "Nigeria YouWiN/BaselineandFirstFollowup.dta", clear

*Keep only if operating a business:
keep if m_q1==1 | h_operatesbusiness=="YES" | m_a3==1
*Drop if in agriculture, forestry or fishing
drop if m_c2_isci_code<510

rename uid RESIDi

merge 1:1 RESIDi using "Nigeria YouWiN/NYES - FACE2FACE-09-12-2016.dta", keep(1 3) nogenerate

rename RESIDi UIDnumber

merge 1:1 UIDnumber using "Nigeria YouWiN/NYES -CATI-09-12-2016.dta", keep(1 3) nogenerate

*Keep only if owner operates only one business in each of the rounds
g m_morethanone=(m_c1>1) if m_c1!=. & m_c1!=0
g t_morethanone=(B1>1) if B1!=. & B1!=0
keep if m_morethanone==0
drop  if sc==1 & t_morethanone!=0

*Survival
g survival=(A3==1) if A3!=. & A3!=3
*Did not survive, if not operating a business
replace survival=0 if sc==2
*Did not survive, if business is younger than the one reported in previous survey
gen ivwmonth = mofd(m_date1)
format ivwmonth %tm
g t_startyear=B3a if B3a==2015 |  B3a==2016
g t_helpbusstartdate=string(B3b)+"-"+string(t_startyear) if B3b!=. & t_startyear!=. 
g t_busstartdate=monthly(t_helpbusstartdate,"MY")
g m_helpbusstartdate=string(m_c31)+"-"+string(m_c3b) if m_c31!=. & m_c3b!=.
g m_busstartdate=monthly(m_helpbusstartdate,"MY")
format *_busstartdate %tm

replace survival=1 if sc==1 & t_busstartdate==. & B3a!=.
replace survival=0 if sc==1 & t_busstartdate!=. & t_busstartdate!=m_busstartdate & B3a!=.
replace survival=1 if sc==1 & t_busstartdate!=. & t_busstartdate==m_busstartdate & B3a!=.

replace t_startyear=Q9_2 if Q9_2==2015 |  Q9_2==2016
replace t_helpbusstartdate=string(Q9_1)+"-"+string(t_startyear) if Q9_1!=. & t_startyear!=. & t_helpbusstartdate==""
replace t_busstartdate=monthly(t_helpbusstartdate,"MY") if t_helpbusstartdate!="" & t_busstartdate==.

replace survival=1 if Q7==1 & t_busstartdate==. & Q9_2 !=. & survival==.
replace survival=0 if Q7==1 & t_busstartdate!=. & t_busstartdate!=m_busstartdate & Q9_2!=. & survival==.
replace survival=1 if Q7==1 & t_busstartdate!=. & t_busstartdate==m_busstartdate & Q9_2!=. & survival==.

		
*New firm started since last survey
*Did not start a new firm, if not operating a business
g newfirmstarted=0 if sc==2 | A3==2 | Q7==2
replace newfirmstarted=0 if ((sc==1 & t_busstartdate==.) | (sc==1 & t_busstartdate!=. & t_busstartdate==m_busstartdate)) & B3a!=.
replace newfirmstarted=1 if sc==1 & t_busstartdate!=. & t_busstartdate!=m_busstartdate & B3a!=.

replace newfirmstarted=0 if ((Q7==1 & t_busstartdate==.) | (Q7==1 & t_busstartdate!=. & t_busstartdate==m_busstartdate)) & Q9_2!=.
replace newfirmstarted=1 if Q7==1 & t_busstartdate!=. & t_busstartdate!=m_busstartdate & Q9_2!=.

*Attrition
g attrit=(survival==.)

*Reason for closing business
gen reasonclosure=BC7
replace reasonclosure=10 if BC7==9
replace reasonclosure=9 if BC7==10
replace reasonclosure=12 if BC7==11

label define closereason 1 "making a loss" 2 "sickness" 3 "care for family" 4 "better wage job" 5 "migrate abroad" 6 "married" 7 "shut down by govt." 8 "taken from me" 9 "other" 10 "better business opportunity" 11 "catastrophe" 12 "I found the work too tiring or hours too long"
label values reasonclosure closereason

*Owner died between survey rounds
g dead=(A1==5) if A1!=.

*Number of paid employees
egen employees=rowtotal(EF3_1  EF3_2), m
egen employeesCATI=rowtotal(Q10_1 Q10_2), m
replace employees=employeesCATI if employees==.

*Total workers
g totalworkers=EF3_5
replace totalworkers=A4 if totalworkers==. & A4!=998 
replace totalworkers=Q10_5 if totalworkers==. 

*Business profits in last month
rename BF9 profits
replace profits=Q14 if profits==.

*Business sales in last month
rename BF5 sales
replace sales=Q12 if sales==.

*Hours worked in self-employment in last month
*based on hours worked  in last week
g hours=EF1_1*(30/7)

*based on hours worked  in a normal week
g hoursnormal=EF1_2*(30/7)

*Worked as wage worker in last month 
g wageworker=(NB1_1==1) if NB1_1!=. 
replace wageworker=1 if Q17==1

*Labor earnings from all labor, including the business, in last month
egen laborincome=rowtotal(NB6 profits), m
egen laborincomeCATI=rowtotal(Q20 profits), m
replace laborincome=laborincomeCATI if laborincome==.

*Subjective wellbeing on Cantril ladder
rename SW10_1 subjwell

*Excrate and excratemonth
g t_date=daily(RESP_10,"DMY")
format t_date %td
su t_date, detail
*Survey took place between July 2016 and November 2016, with 50% of the surveys having been conducted approx. by Aug. 18, 2016, so I take August 15, 2016 as approx. midpoint
g excrate=0.00311
g excratemonth="8-2016" 

*Surveyyear
g surveyyear=2016

*Wave
g wave=4

rename UIDnumber uid

keep 	uid sc ///
		surveyyear wave ///
		excrate excratemonth ///
		employees totalworkers profits sales hours hoursnormal wageworker laborincome subjwell ///
		survival newfirmstarted m_busstartdate attrit reasonclosure dead 


foreach var of varlist 	surveyyear wave ///
						excrate  excratemonth ///
						employees totalworkers profits sales hours hoursnormal wageworker laborincome subjwell ///
						survival newfirmstarted m_busstartdate attrit reasonclosure dead {
rename `var' `var'4
}	

save NGYOUWIN4, replace

********************************************************************************
*Merge rounds 1-4 together
********************************************************************************

********************************************************************************
use NGYOUWIN1, clear
forvalues i=2/4{
merge 1:1 uid using NGYOUWIN`i', nogenerate
}

merge 1:1 uid using "Nigeria YouWiN/BaselineandFirstFollowup.dta", keepusing(m_c1) keep(1 3) nogenerate
merge 1:1 uid using "Nigeria YouWiN/SecondFollowup.dta", keepusing(s_b1 s_sc) keep(1 3) nogenerate
merge 1:1 uid using "Nigeria YouWiN/ThirdFollowup.dta", keepusing(t_b1 t_sc) keep(1 3) nogenerate
rename uid RESIDi
merge 1:1 RESIDi using "Nigeria YouWiN/NYES - FACE2FACE-09-12-2016.dta", keepusing(B1 sc) keep(1 3) nogenerate
g m_morethanone=(m_c1>1) if m_c1!=. & m_c1!=0
keep if m_morethanone==0
g s_morethanone=(s_b1>1) if s_b1!=. & s_b1!=0
drop  if s_sc==1 & s_morethanone!=0 
g t_morethanone=(t_b1>1) if t_b1!=. & t_b1!=0
drop  if t_sc==1 & t_morethanone!=0
g f_morethanone=(B1>1) if B1!=. & B1!=0
drop  if sc==1 & f_morethanone!=0
rename RESIDi uid 

*Recode survival and code operatingnewfirm
/*Survival has been coded erroneosly in some cases, as startdate has only been 
asked if the business was created in the survey year. Since coding was 1 if startdate 
was missing, firms that have been started between baseline and round 2 would have been coded 
as surviving in round 3, although it is actually the new firm that is surviving
*/

g operatingnewfirm3=(newfirmstarted2==1 & survival3==1) | newfirmstarted3==1 if attrit3==0

replace survival3=0 if survival2==0 & newfirmstarted2==1 &  m_busstartdate<s_busstartdate & attrit3==0

replace operatingnewfirm3=1 if survival2==0 & survival3==1

g operatingnewfirm4=(operatingnewfirm3==1 & survival4==1) | newfirmstarted4==1 if attrit4==0

replace survival4=0 if survival3==0 & newfirmstarted4==1 &  m_busstartdate4<t_busstartdate & attrit4==0

replace operatingnewfirm4=1 if survival3==0 & survival4==1

drop *busstartdate t_sc sc s_sc

quietly: reshape long 	surveyyear wave excrate excratemonth ///
						inventories ///
						ownerage female married ownertertiary ///
						agefirm retail manuf services sector ///
						, ///
						i(uid) j(survey)

foreach x in profits sales hours hoursnormal totalworkers employees competition1 competition2 subjwell digitspan raven {
replace `x'=. if wave!=1
}	
*No need to recode survival, as it is already coded from baseline


*Only keep if business is operating
forvalues i=2/4{
drop if survival`i'!=1 & wave==`i'
}

foreach x in survival newfirmstarted operatingnewfirm attrit dead totalworkers employees reasonclosure sales profits wageworker laborincome {
g `x'_11mths=`x'2 if wave==1
drop `x'2
g `x'_1p833yrs=`x'3 if wave==1
drop `x'3
g `x'_3p667yrs=`x'4 if wave==1
drop `x'4
}

foreach x in subjwell{
g `x'_11mths=`x'2 if wave==1
drop `x'2
g `x'_3p667yrs=`x'4 if wave==1
drop `x'4
}

tostring survey, replace
replace survey="BL-"+string(surveyyear) if wave==1
replace survey="R-"+string(surveyyear) if wave==2 
replace survey="R-"+string(surveyyear) if wave==3 
replace survey="L-"+string(surveyyear) if wave==4 

g lastround=(wave==4)

*Generate owner, household and business id (which are the same here)
foreach var in ownerid firmid householdid{
egen `var'=group(uid)
tostring `var', format("%04.0f") replace
replace `var'="NGYOUWIN"+"-"+`var'
}

g surveyname="NGYOUWIN"

save NGYOUWIN_masterfc, replace
				
