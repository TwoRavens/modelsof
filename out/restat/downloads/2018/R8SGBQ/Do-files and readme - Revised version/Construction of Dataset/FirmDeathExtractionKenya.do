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
cd "C:\Users\wb200090\Box Sync\WED Data\DavidFilesdontdelete\CombinedData\"

use "Round2\FullCombinedDatar2r3.dta", clear
cd  "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/Kenya GET Ahead"

use "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Kenya data/FullCombinedDatar2r3.dta", clear

*** drop those not in study
drop if notinbaseline==1

* Survivorship defined in R2 and R3
**** Survey response rates and survival *********
* Interviewed
gen interviewed=consent==1
replace interviewed=ss_consent==1 if round==3
egen anyinterview=max(interviewed), by(respid)

* Survives
* Round 2 data
gen survives=1 if stillinbiz==1
replace survives=0 if stillinbiz==2
* individuals who died are not in business
replace survives=0 if reasonattr=="6"
replace survives=1 if sec2_3==1
replace survives=0 if sec2_3==3|sec2_3==2
* individuals who claim never to have run a business 
replace survives=0 if sec2_2_=="-777"
replace survives=0 if reasonattr_a=="BUSY AND CLOSED BUSINES"

** new firm started 
gen newfirmstarted2=sec2_3==2
replace newfirmstarted2=. if sec2_3==.

gen dead=reasonattr=="6"
replace dead=1 if ss_reasonattr==6
replace dead=1 if ss_remarks=="THE RESPONDENT IS DECEASED."
* Round 3 data
replace survives=1 if ss_stillinbiz==1 
replace survives=0 if ss_stillinbiz==2
replace survives=1 if ss_sec2_3_==1
replace survives=0 if ss_sec2_3_==3|ss_sec2_3_==2
replace newfirmstarted2=1 if ss_sec2_3_==2
replace newfirmstarted2=0 if ss_sec2_3_==1 | ss_sec2_3_==3 

* individuals who died are not in business
replace survives=0 if ss_reasonattr==6
replace survives=0 if ss_reasonattr_a=="LEFT BUSSINESS NOW ON EMPLOYEMENT"
replace survives=0 if ss_reasonattr_a=="SHE IS MARRIED AND  NOT CONDUCTING ANY BUSINESS  REFUSED TO PARTICIPATE."
replace survives=0 if ss_reasonattr_a=="SHE SAID THAT SHE IS JUST NOT INTRESTED AND HAD LEFT BUSINESS FOR HOUSE MAID  JOB."
replace survives=0 if ss_reasonattr_a=="LEFT BUSSINESS NOW ON EMPLOYEMENT"
* individuals who went to saudi arabia not in business
replace survives=0 if ss_remarks=="WENT TO SAUDI ARABIA"
replace survives=0 if ss_remarks=="THE RESPONDENT IS DECEASED."
gen ss_remark_str=substr(ss_remarks, 1, 90)
replace survives=0 if ss_remark_str=="THE HUSBAND DID NOT ALLOW US TO COMMUNICATE WITH THE RESPONDENT, HE SAID HE CLOSED THE BUS"
replace survives=0 if ss_remark_str=="CLOSED BUSINES AND WENT TO MOMBASA"
replace survives=0 if ss_remark_str=="WENT TO SAUDI ARABIA."
replace survives=0 if ss_remark_str=="THE RESPONDENTS NUMBER IS OFF, BUSINESS CLOSED, ALTERNATIVE NUMBER(SPOUSE) NOT PROVIDING R"
replace survives=0 if ss_remark_str=="THE RESPONDENT CLOSED BUSINESS, HAS RESCHEDULED INTERVIEW SEVERAL TIMES, AND WHEN TRIED FO"
gen dataonsurvival=survives~=.
egen anysurvivaldata=max(dataonsurvival), by(respid)

*** Sales in the Last Week
* round 2
gen salesweek=sec5_8_
* cleaning
replace salesweek=. if sec5_8_==-999|sec5_8_==-888|sec5_8_==-555|sec5_8_==-666|(sec5_8_>0.9 & sec5_8_<1)
* sales are zero if they were closed that day
replace salesweek=0 if sec5_8_==-444|(sec5_8_>0.4 & sec5_8_<0.5)
replace salesweek=. if salesweek<0
* replace with range answers if only answered those
replace salesweek=500 if salesweek==. & sec5_8a==1
replace salesweek=1250 if salesweek==. & sec5_8a==2
replace salesweek=1750 if salesweek==. & sec5_8a==3
replace salesweek=2250 if salesweek==. & sec5_8a==4
replace salesweek=2750 if salesweek==. & sec5_8a==5
replace salesweek=3500 if salesweek==. & sec5_8a==6
replace salesweek=4500 if salesweek==. & sec5_8a==7
replace salesweek=6000 if salesweek==. & sec5_8a==8
replace salesweek=8500 if salesweek==. & sec5_8a==9
sum salesweek if salesweek>=10000 & salesweek~=., de
gen medsalesw=r(p50)
replace salesweek=medsalesw if salesweek==. & sec5_8a==10
* sales are then zero for firms which don't survive
replace salesweek=0 if survives==0
label var salesweek "Sales in last week, first follow-up"
* truncate at 99th percentile, as per pre-analysis plan
sum salesweek, de
replace salesweek=r(p99) if salesweek>r(p99) & salesweek~=.
* round 3
replace salesweek=ss_sec5_8_ if round==3
* cleaning
replace salesweek=. if (ss_sec5_8_==-999|ss_sec5_8_==-888|ss_sec5_8_==-555|ss_sec5_8_==-666) & round==3
* sales are zero if they were closed that week
replace salesweek=0 if ss_sec5_8_==-444 & round==3
replace salesweek=. if salesweek<0 & round==3
* replace with range answers if only answered those
replace salesweek=500 if salesweek==. & ss_sec5_8a==1 & round==3
replace salesweek=1250 if salesweek==. & ss_sec5_8a==2 & round==3
replace salesweek=1750 if salesweek==. & ss_sec5_8a==3 & round==3
replace salesweek=2250 if salesweek==. & ss_sec5_8a==4 & round==3
replace salesweek=2750 if salesweek==. & ss_sec5_8a==5 & round==3
replace salesweek=3500 if salesweek==. & ss_sec5_8a==6 & round==3
replace salesweek=4500 if salesweek==. & ss_sec5_8a==7 & round==3
replace salesweek=6000 if salesweek==. & ss_sec5_8a==8 & round==3
replace salesweek=8500 if salesweek==. & ss_sec5_8a==9 & round==3
sum salesweek if salesweek>=10000 & salesweek~=. & round==3, de
replace medsalesw=r(p50) if round==3
replace salesweek=medsalesw if salesweek==. & ss_sec5_8a==10 & round==3
* sales are then zero for firms which don't survive
replace salesweek=0 if survives==0
label var salesweek "Sales in last week"
* truncate at 99th percentile, as per pre-analysis plan
sum salesweek if round==3, de
replace salesweek=r(p99) if salesweek>r(p99) & salesweek~=. & round==3

* Round 2
*** Average weekly profits over last 2 weeks
gen prof1=sec5_9_
replace prof1=. if prof1==-999|prof1==-888|prof1==-555|(prof1>0.8 & prof1<1)
replace prof1=0 if prof1==-444|(prof1>0.4 & prof1<0.5)
replace prof1=250 if prof1==. & sec5_9a==1
replace prof1=750 if prof1==. & sec5_9a==2
replace prof1=1250 if prof1==. & sec5_9a==3
replace prof1=1750 if prof1==. & sec5_9a==4
replace prof1=2250 if prof1==. & sec5_9a==5
replace prof1=2750 if prof1==. & sec5_9a==6
replace prof1=3500 if prof1==. & sec5_9a==7
replace prof1=4500 if prof1==. & sec5_9a==8
replace prof1=6000 if prof1==. & sec5_9a==9
replace prof1=8500 if prof1==. & sec5_9a==10
replace prof1=12500 if prof1==. & sec5_9a==11
sum prof1 if prof1>=15000 & prof1~=., de
replace prof1=r(p50) if prof1==. & sec5_9a==12
replace prof1=0 if survives==0
gen prof2=sec5_9b
replace prof2=. if prof2==-999|prof2==-888|prof2==-555|(prof2>0.8 & prof2<1)
replace prof2=0 if prof2==-444|(prof2>0.4 & prof2<0.5)
replace prof2=250 if prof2==. & sec5_9bi==1
replace prof2=750 if prof2==. & sec5_9bi==2
replace prof2=1250 if prof2==. & sec5_9bi==3
replace prof2=1750 if prof2==. & sec5_9bi==4
replace prof2=2250 if prof2==. & sec5_9bi==5
replace prof2=2750 if prof2==. & sec5_9bi==6
replace prof2=3500 if prof2==. & sec5_9bi==7
replace prof2=4500 if prof2==. & sec5_9bi==8
replace prof2=6000 if prof2==. & sec5_9bi==9
replace prof2=8500 if prof2==. & sec5_9bi==10
replace prof2=12500 if prof2==. & sec5_9bi==11
sum prof2 if prof2>=15000 & prof2~=., de
replace prof2=r(p50) if prof2==. & sec5_9bi==12
replace prof2=0 if survives==0

gen profitsweek=(prof1 + prof2)/2 if prof1~=. & prof2~=.
replace profitsweek=prof1 if prof2==.
replace profitsweek=prof2 if prof1==.
sum profitsweek, de
replace profitsweek=r(p99) if profitsweek>r(p99) & profitsweek~=.
label var profitsweek "Average weekly profits over last 2 weeks, first follow-up"
* round 3
replace prof1=ss_sec5_9_ if round==3
replace prof1=. if (prof1==-999|prof1==-888|prof1==-555) & round==3
replace prof1=0 if prof1==-444 & round==3
replace prof1=250 if prof1==. & ss_sec5_9a==1 & round==3
replace prof1=750 if prof1==. & ss_sec5_9a==2 & round==3
replace prof1=1250 if prof1==. & ss_sec5_9a==3 & round==3
replace prof1=1750 if prof1==. & ss_sec5_9a==4 & round==3
replace prof1=2250 if prof1==. & ss_sec5_9a==5 & round==3
replace prof1=2750 if prof1==. & ss_sec5_9a==6 & round==3
replace prof1=3500 if prof1==. & ss_sec5_9a==7 & round==3
replace prof1=4500 if prof1==. & ss_sec5_9a==8 & round==3
replace prof1=6000 if prof1==. & ss_sec5_9a==9 & round==3
replace prof1=8500 if prof1==. & ss_sec5_9a==10 & round==3
replace prof1=12500 if prof1==. & ss_sec5_9a==11 & round==3
sum prof1 if prof1>=15000 & prof1~=. & round==3, de
replace prof1=r(p50) if prof1==. & ss_sec5_9a==12 & round==3
replace prof1=0 if survives==0 
replace profitsweek=prof1 if round==3
sum profitsweek if round==3, de
replace profitsweek=r(p99) if profitsweek>r(p99) & profitsweek~=. & round==3
label var profitsweek "Weekly profits"

gen incomefromwork=profitsweek
replace incomefromwork=ss_sec3_13_ if round==3 & ss_sec3_13_>=0 & ss_sec3_13_~=.
replace incomefromwork=sec3_13 if round==2 & sec3_13>=0 & sec3_13~=.
replace incomefromwork=incomefromwork+sec5_21 if sec5_21>0 & round==2 & sec5_21~=.
replace incomefromwork=incomefromwork+sec5_23b if sec5_23b>0 & round==2 & sec5_23b~=.
label var incomefromwork "Income from all work"

gen control=r1_treated~=1
label var control "In control group"
cap drop respondent_id
rename respid respondent_id
gen surveyyear2=2014
rename salesweek sales2
rename profitsweek profits2
rename incomefromwork laborincome2
gen excrate2=87.8

egen msurvive=max(survives), by(respondent_id)
replace survives=msurvive if round==2 & survives==.
egen mstartnew=max(newfirmstarted2), by(respondent_id)
replace newfirmstarted2=mstartnew if round==2 & newfirmstarted2==.
egen msales=max(sales2), by(respondent_id)
replace sales2=msales if round==2 & sales2==.
egen mlaborinc=max(laborincome2), by(respondent_id)
replace laborincome2=mlaborinc if round==2 & laborincome2==.
egen mprofits=max(profits2), by(respondent_id)
replace profits2=mprofits if round==2 & profits==.
keep if round==2
rename survives survival2
cap drop attrit
gen attrit2=survival2==.
keep respondent_id surveyyear2 control b_interview_date1 survival2 attrit2 newfirmstarted2 sec3_* sales2 profits2 laborincome2 excrate2
save "KenyaFirmDeathR2.dta", replace


use "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Kenya data/cleanedr4.dta", clear



* Interviewed
gen interviewed=consent==1

* Survives
gen survives=1 if sec2_3_==1
replace survives=0 if sec2_3_==3|sec2_3_==2
replace survives=0 if sec2_3_==5
gen newfirmstarted3=sec2_3_==2
replace newfirmstarted3=. if sec2_3_==.
* use attrition section for those who don't answer currently in business question
* those who died are not in business
replace survives=0 if reasonattr==6
replace survives=1 if survives==. & ownbiz==1
replace survives=0 if survives==. & ownbiz==0
replace survives=1 if survives==. & i_ownbiz==1
replace survives=0 if survives==. & i_ownbiz==0
replace survives=0 if survives==. & reasonattr_i=="BUSSINESS PERMANETLY CLOSED"
replace survives=0 if survives==. & reasonattr_i=="IN PRISON"
replace survives=0 if survives==. & reasonattr_i=="RESPONDENT LOCKED AWAY IN PRISON TILL 2017"
gen dataonsurvival=survives~=.
gen dead=reasonattr==6

***** Data on sales and profits

*** Sales in the Last Week
gen salesweek=sec5_8a
* cleaning
replace salesweek=. if sec5_8a==-999|sec5_8a==-888|sec5_8a==-555|sec5_8a==-666|(sec5_8a>0.9 & sec5_8a<1)
* sales are zero if they were closed that day
replace salesweek=0 if sec5_8a==-444|(sec5_8a>0.4 & sec5_8a<0.5)|sec5_8a==-44
replace salesweek=. if salesweek<0
* replace with best estimate when prompted
replace salesweek=sec5_8b if salesweek==. & sec5_8b>=0 & sec5_8b~=.
* replace with range answers if only answered those
replace salesweek=0 if salesweek==. & sec5_8c==0
replace salesweek=500 if salesweek==. & sec5_8c==1
replace salesweek=1250 if salesweek==. & sec5_8c==2
replace salesweek=1750 if salesweek==. & sec5_8c==3
replace salesweek=2250 if salesweek==. & sec5_8c==4
replace salesweek=2750 if salesweek==. & sec5_8c==5
replace salesweek=3500 if salesweek==. & sec5_8c==6
replace salesweek=4500 if salesweek==. & sec5_8c==7
replace salesweek=6000 if salesweek==. & sec5_8c==8
replace salesweek=8500 if salesweek==. & sec5_8c==9
replace salesweek=11000 if salesweek==. & sec5_8c==10
replace salesweek=13000 if salesweek==. & sec5_8c==11
replace salesweek=15000 if salesweek==. & sec5_8c==12
replace salesweek=17000 if salesweek==. & sec5_8c==13
replace salesweek=19000 if salesweek==. & sec5_8c==14
sum salesweek if salesweek>=20000 & salesweek~=., de
gen medsalesw=r(p50)
replace salesweek=medsalesw if salesweek==. & sec5_8c==15

* sales are then zero for firms which don't survive
replace salesweek=0 if survives==0
label var salesweek "Sales in last week, first follow-up"
* truncate at 99th percentile, as per pre-analysis plan
sum salesweek, de
replace salesweek=r(p99) if salesweek>r(p99) & salesweek~=.


*** Profits
*** Average weekly profits over last 2 weeks
gen prof1=sec5_9ai
replace prof1=. if prof1==-999|prof1==-888|prof1==-555|(prof1>0.8 & prof1<1)
replace prof1=0 if prof1==-444|(prof1>0.4 & prof1<0.5)|prof1==-44
replace prof1=sec5_9aii if prof1==. & sec5_9aii>=0 & sec5_9aii~=.
replace prof1=0 if prof1==. & sec5_9aiii==1
replace prof1=250 if prof1==. & sec5_9aiii==2
replace prof1=750 if prof1==. & sec5_9aiii==3
replace prof1=1250 if prof1==. & sec5_9aiii==4
replace prof1=1750 if prof1==. & sec5_9aiii==5
replace prof1=2250 if prof1==. & sec5_9aiii==6
replace prof1=2750 if prof1==. & sec5_9aiii==7
replace prof1=3500 if prof1==. & sec5_9aiii==8
replace prof1=4500 if prof1==. & sec5_9aiii==9
replace prof1=6000 if prof1==. & sec5_9aiii==10
replace prof1=8500 if prof1==. & sec5_9aiii==11
replace prof1=12500 if prof1==. & sec5_9aiii==12
sum prof1 if prof1>=15000 & prof1~=., de
replace prof1=r(p50) if prof1==. & sec5_9aiii==13
replace prof1=0 if survives==0

gen prof2=sec5_9bi
replace prof2=. if prof2==-999|prof2==-888|prof2==-555|(prof2>0.8 & prof2<1)
replace prof2=0 if prof2==-444|(prof2>0.4 & prof2<0.5)|prof2==-44
replace prof2=sec5_9bii if prof2==. & sec5_9bii>=0 & sec5_9bii~=.
replace prof2=0 if prof2==. & sec5_9biii==1
replace prof2=250 if prof2==. & sec5_9biii==2
replace prof2=750 if prof2==. & sec5_9biii==3
replace prof2=1250 if prof2==. & sec5_9biii==4
replace prof2=1750 if prof2==. & sec5_9biii==5
replace prof2=2250 if prof2==. & sec5_9biii==6
replace prof2=2750 if prof2==. & sec5_9biii==7
replace prof2=3500 if prof2==. & sec5_9biii==8
replace prof2=4500 if prof2==. & sec5_9biii==9
replace prof2=6000 if prof2==. & sec5_9biii==10
replace prof2=8500 if prof2==. & sec5_9biii==11
replace prof2=12500 if prof2==. & sec5_9biii==12
sum prof2 if prof2>=15000 & prof2~=., de
replace prof2=r(p50) if prof2==. & sec5_9biii==13
replace prof2=0 if survives==0

gen profitsweek=(prof1 + prof2)/2 if prof1~=. & prof2~=.
replace profitsweek=prof1 if prof2==.
replace profitsweek=prof2 if prof1==.
sum profitsweek, de
replace profitsweek=r(p99) if profitsweek>r(p99) & profitsweek~=.
label var profitsweek "Average weekly profits over last 2 weeks"

gen incomefromwork=profitsweek
replace incomefromwork=sec3_15 if  sec3_15>=0 & sec3_15~=.
replace incomefromwork=incomefromwork+sec5_21 if sec5_21>0 & sec5_21~=.
replace incomefromwork=incomefromwork+sec5_23b if sec5_23b>0 & sec5_23b~=.
label var incomefromwork "Income from all work"

rename respid respondent_id
gen surveyyear3=2016
rename survives survival3
gen attrit3=survival3~=.
rename profitsweek profits3
rename salesweek sales3
rename incomefromwork laborincome3
gen excrate3=100.95 


rename sec3_* r3_sec3_*

keep respondent_id surveyyear3  survival3 attrit3 newfirmstarted3 r3_sec3_* sales3 profits3 laborincome3 excrate3
save "KenyaFirmDeathR3.dta", replace

merge respondent_id using "KenyaFirmDeathR2.dta", sort
tab _merge
drop _merge
sort respondent_id
saveold "KenyaFirmDeathPanel.dta", replace
