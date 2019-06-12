********************************************************************************

********************************************************************************
**THIS DO-FILE PREPARES THE DATA FROM THE NIGERIA GENERAL HOUSEHOLD SURVEY FOR COMBINATION INTO THE MASTER DATASET
**Small Firm Death in Developing Countries
**March 14, 2018
**David McKenzie (dmckenzie@worldbank.org) and Anna Luisa Paffhausen (apaffhausen@worldbank.org)
**The analysis was performed with Stata, version 14.2

*Notes:
* The underlying raw data needed to replicate this do-file is available in the World Bank's Microdata Catalogue.
* To replicate this do-file:
* 1) For the 2010-2011 rounds, go to http://microdata.worldbank.org/index.php/catalog/1002, for the 2012-2013 rounds, go to http://microdata.worldbank.org/index.php/catalog/1952
* 2) Download the data files in Stata format (For the 2010-2011 rounds: http://microdata.worldbank.org/index.php/catalog/1002/download/40238; For the 2012-2013 rounds: http://microdata.worldbank.org/index.php/catalog/1952/download/40239)
*	 You will need the household files only.
* 3) Change the directory in the do-file 
* 4) Change the paths to the data you are using and for saving the datasets that are created in this do-file
*    Make sure the final dataset (NGLSMSISA_masterfc) is saved in the folder “Do-files and readme/Construction of Dataset/Data for combination”

********************************************************************************

********************************************************************************
clear all
*TO DO: change directory 
/*EXAMPLE:*/
cd  "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data"
/**/
set more off

********************************************************************************

********************************************************************************
*Round 1 (Wave 1 - post-planting)
********************************************************************************

********************************************************************************


********************************************************************************
*Owner and Household characteristics
********************************************************************************
*TO DO: change path to where you saved the following file "sect1_plantingw1.dta"
/*EXAMPLE:*/
use "Nigeria LSMS-ISA/Wave 1 - post planting/sect1_plantingw1.dta", clear
/**/

*Country
g country="Nigeria"

*Wave
g wave=1

*Year survey took place
g surveyyear=2010

*Age of owner
g ownerage=s1q4

*Gender of owner
g female=(s1q2==2) if s1q2!=.

*Child under 5 in household
g under5=0
replace under5=. if s1q4==. 
replace under5=1 if s1q4<5 
bysort hhid: egen childunder5=max(under5)
drop under5

*Child aged 5 to 12 in household
g aged5to12=0
replace aged5to12=. if  s1q4==. 
replace aged5to12=1 if  s1q4>=5 & s1q4<12
bysort hhid: egen childaged5to12=max(aged5to12)
drop aged5to12

*Has adult aged 65+ in the household
g is65orover=0
replace is65orover=. if s1q4==. 
replace is65orover=1 if s1q4>=65 & s1q4!=. 
bysort hhid: egen adult65andover=max(is65orover)
drop is65orover

*Marital status of owner (I consider monogamous and polygamous marriages)
g married=(s1q8==1 | s1q8==2) if s1q8!=.

*Household size
bysort hhid: egen hhsize=total(s1q7),m

keep hhid indiv country-hhsize

*TO DO: decide whether you need/want to change path for saving NGLSMSISA_oh
/**/
save NGLSMSISA_oh, replace
/**/

*Household consumption
*TO DO: change path to where you saved the following file "sect7a_plantingw1.dta"
/*EXAMPLE:*/
use "Nigeria LSMS-ISA/Wave 1 - post planting/sect7a_plantingw1.dta", clear
/**/
bysort hhid: egen weeklyfood_a=total(s7q2), m

keep hhid weeklyfood_a
duplicates drop

*TO DO: decide whether you need/want to change path for saving consumpexp
/**/
save consumpexp, replace
/**/

*TO DO: change path to where you saved the following file "sect7b_plantingw1.dta"
/*EXAMPLE:*/
use "Nigeria LSMS-ISA/Wave 1 - post planting/sect7b_plantingw1.dta", clear
/**/

bysort hhid: egen weeklyfood_b=total(s7bq4), m
/*This only includes food that was purchased. For own production, gifts and food
 from other sources, there are no monetary values given, only the quantities.
 11.37 percent of the items listed here came from own production, and 1.69 % from
 gifts. But I don't know what is the distribution for households.*/

keep hhid weeklyfood_b
duplicates drop

*TO DO: change path to where you saved the following file "consumpexp.dta"
/*EXAMPLE:*/
merge 1:1 hhid using consumpexp, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving consumpexp
/**/
save consumpexp, replace
/**/

*TO DO: change path to where you saved the following file "sect81_plantingw1.dta"
/*EXAMPLE:*/
use "Nigeria LSMS-ISA/Wave 1 - post planting/sect81_plantingw1.dta", clear
/**/

bysort hhid: egen weeklyconsumpexp=total(s8q2), m

keep hhid weeklyconsumpexp
duplicates drop

*TO DO: change path to where you saved the following file "consumpexp.dta"
/*EXAMPLE:*/
merge 1:1 hhid using consumpexp, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving consumpexp
/**/
save consumpexp, replace
/**/

*TO DO: change path to where you saved the following file "sect82_plantingw1.dta"
/*EXAMPLE:*/
use "Nigeria LSMS-ISA/Wave 1 - post planting/sect82_plantingw1.dta", clear
/**/

bysort hhid: egen monthlyconsumpexp=total(s8q4), m

keep hhid monthlyconsumpexp
duplicates drop

*TO DO: change path to where you saved the following file "consumpexp.dta"
/*EXAMPLE:*/
merge 1:1 hhid using consumpexp, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving consumpexp
/**/
save consumpexp, replace
/**/

*TO DO: change path to where you saved the following file "sect83_plantingw1.dta"
/*EXAMPLE:*/
use "Nigeria LSMS-ISA/Wave 1 - post planting/sect83_plantingw1.dta", clear
/**/

bysort hhid: egen semiannconsumpexp=total(s8q6), m

keep hhid semiannconsumpexp
duplicates drop

*TO DO: change path to where you saved the following file "consumpexp.dta"
/*EXAMPLE:*/
merge 1:1 hhid using consumpexp, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving consumpexp
/**/
save consumpexp, replace
/**/

*TO DO: change path to where you saved the following file "sect84_plantingw1.dta"
/*EXAMPLE:*/
use "Nigeria LSMS-ISA/Wave 1 - post planting/sect84_plantingw1.dta", clear
/**/

bysort hhid: egen yearlyconsumpexp=total(s8q8), m

keep hhid yearlyconsumpexp
duplicates drop

*TO DO: change path to where you saved the following file "consumpexp.dta"
/*EXAMPLE:*/
merge 1:1 hhid using consumpexp, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving consumpexp
/**/
save consumpexp, replace
/**/

replace semiannconsumpexp=2*semiannconsumpexp
replace monthlyconsumpexp=12*monthlyconsumpexp
replace weeklyconsumpexp=52*weeklyconsumpexp
replace weeklyfood_b=52*weeklyfood_b
replace weeklyfood_a=52*weeklyfood_a

egen hh_exp=rowtotal(yearlyconsumpexp semiannconsumpexp monthlyconsumpexp weeklyconsumpexp weeklyfood_b weeklyfood_a), m

keep hhid hh_exp

*TO DO: decide whether you need/want to change path for saving consumpexp
/**/
save consumpexp, replace
/**/

*TO DO: change path to where you saved the following file "NGLSMSISA_oh.dta"
/*EXAMPLE:*/
merge 1:m hhid using NGLSMSISA_oh, nogenerate
/**/

g pcexpend=hh_exp/hhsize

drop hh_exp hhsize

*Exchange rate
/* The post-planting survey for wave 1 was conducted from August to October 2010,
	so I take Sept. 15 as the approximate mid-point of the survey.*/
/*According to oanda.com, the NGN to USD exchange rate on September 15, 2010 was 0.00652.
	(https://www.oanda.com/lang/de/currency/converter/)
*/
g excrate=0.00652

g excratemonth="9-2010"

*TO DO: decide whether you need/want to change path for saving NGLSMSISA_oh
/**/
save NGLSMSISA_oh, replace
/**/

*TO DO: change path to where you saved the following file "sect2_plantingw1.dta"
/*EXAMPLE:*/
merge 1:1 hhid indiv using "Nigeria LSMS-ISA/Wave 1 - post planting/sect2_plantingw1.dta"
/**/

*Education of owner
*(I consider the following degrees obtained as highest degree obtained:
*BA/BSc./HND - Bachelor of Arts/Bachelor of Science/Higher National Diploma are obtained after three (3), four (4), five (5) or six (6) years of university or polytechnic education
*Technical or Professional Diploma - It refers to a Diploma Certificate obtained from any Polytechnic or University.
*Masters: Refers to any Masters degree - It is the second degree obtained in the university after Bachelors (first degree). Examples include Master of Science (MSc), Masters of Business Administration (MBA).
*Doctorate: Refers to PhD - Doctor of Philosophy is the third level degree obtainable in the university after Masters
*(from interviewer instruction manual))
g ownertertiary=(s2q8==9 | s2q8==10 | s2q8==11 | s2q8==12) if s2q8!=.

*Years of education
*Sources:	https://www.nuffic.nl/en/publications/find-a-publication/education-system-nigeria.pdf
*			https://www.tandfonline.com/doi/abs/10.1080/0022062760080206?journalCode=cjeh20
*			http://microdata.worldbank.org/index.php/catalog/2163/datafile/F2/V190
*			http://education.stateuniversity.com/pages/1108/Nigeria-TEACHING-PROFESSION.html
g educyears=0 if s2q7==0 | s2q7==1 | s2q7==2
replace educyears=1 if s2q7==11
replace educyears=2 if s2q7==12
replace educyears=3 if s2q7==13
replace educyears=4 if s2q7==14
replace educyears=5 if s2q7==15
replace educyears=6 if s2q7==16 | s2q7==27
replace educyears=7 if s2q7==21
replace educyears=8 if s2q7==22
replace educyears=9 if s2q7==23 | s2q7==33
replace educyears=10 if s2q7==24
replace educyears=11 if s2q7==25 | (s2q7==31 & s2q8==7)
replace educyears=12 if s2q7==26 | s2q7==28 | (s2q7==31 & s2q8==6) | s2q7==32
replace educyears=15  if s2q7==34 | (s2q7==31 & s2q8==8)
replace educyears=16  if s2q7==42 | s2q7==41 
replace educyears=18  if s2q8==11 & educyears==.
replace educyears=21  if s2q8==12 & educyears==.
*I do not consider quaranic, quaranic integrated and adult education

replace educyears=0 if educyears==. & s2q8==1
replace educyears=6 if educyears==. & s2q8==2
replace educyears=9 if educyears==. & (s2q8==3 | s2q8==5) 
replace educyears=11 if educyears==. & s2q8==7
replace educyears=12 if educyears==. & (s2q8==4 | s2q8==6)
replace educyears=15 if educyears==. & s2q8==8
replace educyears=16 if educyears==. & s2q8==9

keep hhid-excratemonth ownertertiary educyears

*TO DO: decide whether you need/want to change path for saving NGLSMSISA_oh
/**/
save NGLSMSISA_oh, replace
/**/

*TO DO: change path to where you saved the following file "sect3_plantingw1.dta"
/*EXAMPLE:*/
merge 1:1 hhid indiv using "Nigeria LSMS-ISA/Wave 1 - post planting/sect3_plantingw1.dta"
/**/

*Hours worked in self-employment in last month
g selfemployed=(s3q6==1) if s3q6!=.

g hours=s3q18*(30/7) if selfemployed==1

*Worked as wage worker (in last week, instead of last month, since this is not being asked)
g wageworker=(s3q4==1) if s3q4!=.

*Labor earnings in last month
g laborincome=s3q21a if s3q21b==5
replace laborincome=s3q21a*8*20 if s3q21b==1
replace laborincome=s3q21a*20 if s3q21b==2
replace laborincome=s3q21a*4 if s3q21b==3
replace laborincome=s3q21a*2 if s3q21b==4
replace laborincome=s3q21a/3 if s3q21b==6
replace laborincome=s3q21a/6 if s3q21b==7
replace laborincome=s3q21a/12 if s3q21b==8

*Retired
g retired=(s3q9==3) if s3q9!=.

keep hhid-ownertertiary educyears selfemployed-retired

*TO DO: decide whether you need/want to change path for saving NGLSMSISA_oh
/**/
save NGLSMSISA_oh, replace
/**/
********************************************************************************
*Firm characteristics
********************************************************************************

*TO DO: change path to where you saved the following file "sect6_plantingw1.dta"
/*EXAMPLE:*/
use "Nigeria LSMS-ISA/Wave 1 - post planting/sect6_plantingw1.dta", clear
/**/

*Household operates a business
g hhbus=(s6q1==1) if s6q1!=.

*Urban enterprises
g urban=(sector==1) if sector!=.
drop sector

*Sector of the firm:
*Exclude activities like "crop and animal production, hunting and related service activities", "forestry and logging", and "fishing and aquaculture"
replace hhbus=0 if s6q2==1 | s6q2==2 | s6q2==3
replace hhbus=. if s6q2==.
g nonfarm=(s6q2!=1 & s6q2!=2 & s6q2!=3) if s6q2!=.


*Firm is in retail trade
g retail=(s6q2==45 | s6q2==46 | s6q2==47) if s6q2!=.

*Firm is in manufacturing sector
g manuf=(s6q2==10 | s6q2==11 | s6q2==12 | s6q2==13 | s6q2==14 | s6q2==15 | s6q2==16 | s6q2==17 | s6q2==19 | s6q2==20 | s6q2==21 | s6q2==22 | s6q2==23 | s6q2==24 | s6q2==25 | s6q2==26 | s6q2==27 | s6q2==28 | s6q2==29 | s6q2==30 | s6q2==31 | s6q2==32) if s6q2!=.

*Firm is in service sector
g services=(s6q2==18 | s6q2==49 | s6q2==50 | s6q2==51 | s6q2==52 | s6q2==53 | s6q2==55 | s6q2==56 | s6q2==58 | s6q2==59 | s6q2==60 | s6q2==61 | s6q2==62 | s6q2==63 | s6q2==64 | s6q2==65 | s6q2==66 | s6q2==68 | s6q2==69 | s6q2==70 | s6q2==71 | s6q2==72 | s6q2==73 | s6q2==74 | s6q2==75 | s6q2==77 | s6q2==78 | s6q2==79 | s6q2==80 | s6q2==81 | s6q2==82 | s6q2==84 | s6q2==85 | s6q2==86 | s6q2==87 | s6q2==88 | s6q2==90 | s6q2==91 | s6q2==92 | s6q2==93 | s6q2==95 | s6q2==96) if s6q2!=.

*Firm is in other sector
g othersector=(s6q2==5 | s6q2==6 | s6q2==7 | s6q2==8 | s6q2==9 | s6q2==36 | s6q2==37 | s6q2==38 | s6q2==39 | s6q2==41 | s6q2==42 | s6q2==43 | s6q2==94 | s6q2==97 | s6q2==99)

g sector=s6q2

*Unclear
replace manuf=. if s6q2==98
replace services=. if s6q2==98

*Age of the firm in years
replace s6q8b=s6q8b/12 if s6q8b!=. & s6q8b<12
g agefirm=s6q8a
replace agefirm=agefirm + s6q8b if s6q8b!=. & s6q8b<12

*Capital stock
g capitalstock=s6q21

*Inventories
g inventories=s6q22+s6q23

*Number of paid employees
g help1=(s6q10a!=.)
g help2=(s6q10b!=.)
g help3=help1+help2
egen employees=rowtotal(help3 s6q11a s6q11b),m
drop help*

*Sales
g sales=s6q24

*Expenditures
egen expenses=rowtotal(s6q25a-s6q25h),m

*Profits
g profits=sales-expenses

keep hhid entid  s6q3a-s6q5 hhbus-profits

rename s6q3a s6q31
rename s6q3b s6q32

*Multiple firms per household
bysort hhid: egen help=total(entid)
g morethanonefirm=(help>1) if help!=.
drop help

*Drop duplicates if multiple business:
/*Since the data is in long format in case a hh operates more than one business I drop
 duplicates in folio morethanonefirm to be able to merge the data later. Given that I
 exclude households operating morethanonefirm later anyways, this is okay.
*/

duplicates drop hhid morethanonefirm, force

reshape long s6q3, i(hhid entid) j(help)
*drop if s6q3==.
*drop help

bysort hhid: egen help1=seq() if s6q3!=.

*Jointly operated businesses
bysort hhid: egen help2=max(help1)
g jointbus=(help2>1) if help2!=.

drop help1 help2

*Businessowner
rename s6q3 businessowner

*Manager
g manager=(businessowner==s6q4a | businessowner==s6q4b) if (s6q4a!=. |  s6q4b!=.) & businessowner!=.

reshape wide businessowner manager, i(hhid entid) j(help)

rename s6q5 respbus

*TO DO: decide whether you need/want to change path for saving  NGLSMSISA_f
/**/
save NGLSMSISA_f, replace
/**/

*TO DO: change path to where you saved the following file "NGLSMSISA_oh.dta"
/*EXAMPLE:*/
use NGLSMSISA_oh, clear
/**/

*TO DO: change path to where you saved the following file "NGLSMSISA_f.dta"
/*EXAMPLE:*/
merge m:1 hhid using NGLSMSISA_f
/**/

/*I assume that households for which there is no information in the firm dataset, 
did not operate a firm*/
replace hhbus=0 if _merge==1
drop _merge

foreach var of varlist wave-jointbus{
rename `var' `var'_1
}

/*If hhbus_1 is missing but there is an entid-id, the hh should be operating a business,
so I code hhbus_1=1 in these cases, if the corresponding enterprise is a nonfarm enterprise:*/

replace hhbus_1=1 if hhbus_1==. & entid!=. & nonfarm==1

*TO DO: decide whether you need/want to change path for saving  NGLSMSISA
/**/
save NGLSMSISA, replace
/**/
********************************************************************************

********************************************************************************
*Round 2 (Wave 1 - post-harvest)
********************************************************************************

********************************************************************************
*TO DO: change path to where you saved the following file "sect1_harvestw1.dta"
/*EXAMPLE:*/
use "Nigeria LSMS-ISA/Wave 1 - post-harvest/sect1_harvestw1.dta", clear
/**/

*Wave
g wave=2

*Year survey took place
g surveyyear=2011

*Age of owner
g ownerage=s1q4

*Gender of owner
g female=(s1q2==2) if s1q2!=.

*Child under 5 in household
g under5=0
replace under5=. if s1q4==. 
replace under5=1 if s1q4<5 
bysort hhid: egen childunder5=max(under5)
drop under5

*Child aged 5 to 12 in household
g aged5to12=0
replace aged5to12=. if  s1q4==. 
replace aged5to12=1 if  s1q4>=5 & s1q4<12
bysort hhid: egen childaged5to12=max(aged5to12)
drop aged5to12

*Has adult aged 65+ in the household
g is65orover=0
replace is65orover=. if s1q4==. 
replace is65orover=1 if s1q4>=65 & s1q4!=. 
bysort hhid: egen adult65andover=max(is65orover)
drop is65orover

*Marital status of owner (I consider monogamous and polygamous marriages)
g married=(s1q7==1 | s1q7==2) if s1q7!=.

*Household size
g help=(s1q5==1 | (s1q13==1 & s1q19==1))
bysort hhid: egen hhsize=total(help),m
drop help

*Owner died between survey rounds
g dead=(s1q19==2 & s1q33==11) if s1q33!=.

keep hhid indiv wave-dead

*TO DO: decide whether you need/want to change path for saving NGLSMSISA_oh2
/**/
save NGLSMSISA_oh2, replace
/**/

*Household consumption
*TO DO: change path to where you saved the following file "sect10a_harvestw1.dta"
/*EXAMPLE:*/
use "Nigeria LSMS-ISA/Wave 1 - post-harvest/sect10a_harvestw1.dta", clear
/**/

bysort hhid: egen weeklyfood_a=total(s10aq2), m

keep hhid weeklyfood_a
duplicates drop

*TO DO: decide whether you need/want to change path for saving consumpexp
/**/
save consumpexp, replace
/**/

*TO DO: change path to where you saved the following file "sect10b_harvestw1.dta"
/*EXAMPLE:*/
use "Nigeria LSMS-ISA/Wave 1 - post-harvest/sect10b_harvestw1.dta", clear
/**/

bysort hhid: egen weeklyfood_b=total(s10bq4), m
/*This only includes food that was purchased. For own production, gifts and food
 from other sources, there are no monetary values given, only the quantities.*/

keep hhid weeklyfood_b
duplicates drop

*TO DO: change path to where you saved the following file "consumpexp.dta"
/*EXAMPLE:*/
merge 1:1 hhid using consumpexp, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving consumpexp
/**/
save consumpexp, replace
/**/

*TO DO: change path to where you saved the following file "sect11a_harvestw1.dta"
/*EXAMPLE:*/
use "Nigeria LSMS-ISA/Wave 1 - post-harvest/sect11a_harvestw1.dta", clear
/**/

bysort hhid: egen weeklyconsumpexp=total(s11aq2), m

keep hhid weeklyconsumpexp
duplicates drop

*TO DO: change path to where you saved the following file "consumpexp.dta"
/*EXAMPLE:*/
merge 1:1 hhid using consumpexp, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving consumpexp
/**/
save consumpexp, replace
/**/

*TO DO: change path to where you saved the following file "sect11b_harvestw1.dta"
/*EXAMPLE:*/
use "Nigeria LSMS-ISA/Wave 1 - post-harvest/sect11b_harvestw1.dta", clear
/**/

bysort hhid: egen monthlyconsumpexp=total(s11bq4), m

keep hhid monthlyconsumpexp
duplicates drop

*TO DO: change path to where you saved the following file "consumpexp.dta"
/*EXAMPLE:*/
merge 1:1 hhid using consumpexp, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving consumpexp
/**/
save consumpexp, replace
/**/

*TO DO: change path to where you saved the following file "sect11c_harvestw1.dta"
/*EXAMPLE:*/
use "Nigeria LSMS-ISA/Wave 1 - post-harvest/sect11c_harvestw1.dta", clear
/**/

bysort hhid: egen semiannconsumpexp=total(s11cq6), m

keep hhid semiannconsumpexp
duplicates drop

*TO DO: change path to where you saved the following file "consumpexp.dta"
/*EXAMPLE:*/
merge 1:1 hhid using consumpexp, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving consumpexp
/**/
save consumpexp, replace
/**/

*TO DO: change path to where you saved the following file "sect11d_harvestw1.dta"
/*EXAMPLE:*/
use "Nigeria LSMS-ISA/Wave 1 - post-harvest/sect11d_harvestw1.dta", clear
/**/

bysort hhid: egen yearlyconsumpexp=total(s11dq8), m

keep hhid yearlyconsumpexp
duplicates drop

*TO DO: change path to where you saved the following file "consumpexp.dta"
/*EXAMPLE:*/
merge 1:1 hhid using consumpexp, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving consumpexp
/**/
save consumpexp, replace
/**/

replace semiannconsumpexp=2*semiannconsumpexp
replace monthlyconsumpexp=12*monthlyconsumpexp
replace weeklyconsumpexp=52*weeklyconsumpexp
replace weeklyfood_b=52*weeklyfood_b
replace weeklyfood_a=52*weeklyfood_a

egen hh_exp=rowtotal(yearlyconsumpexp semiannconsumpexp monthlyconsumpexp weeklyconsumpexp weeklyfood_b weeklyfood_a), m

keep hhid hh_exp

*TO DO: decide whether you need/want to change path for saving consumpexp
/**/
save consumpexp, replace
/**/

*TO DO: change path to where you saved the following file "NGLSMSISA_oh2"
/*EXAMPLE:*/
merge 1:m hhid using NGLSMSISA_oh2, nogenerate
/**/

g pcexpend=hh_exp/hhsize

drop hh_exp hhsize

*Exchange rate
/* The post-harvest survey for wave 1 was conducted from February to April 2011,
	so I take March 15 as the approximate mid-point of the survey.*/
/*According to oanda.com, the NGN to USD exchange rate on March 15, 2011 was 0.00641.
	(https://www.oanda.com/lang/de/currency/converter/)
*/
g excrate=0.00641

g excratemonth="3-2011"


*TO DO: decide whether you need/want to change path for saving NGLSMSISA_oh2
/**/
save NGLSMSISA_oh2, replace
/**/

*TO DO: change path to where you saved the following file "sect2a_harvestw1.dta"
/*EXAMPLE:*/
merge 1:1 hhid indiv using "Nigeria LSMS-ISA/Wave 1 - post-harvest/sect2a_harvestw1.dta"
/**/

*Education of owner
*(I consider the following degrees obtained as highest degree obtained:
*BA/BSc./HND - Bachelor of Arts/Bachelor of Science/Higher National Diploma are obtained after three (3), four (4), five (5) or six (6) years of university or polytechnic education
*Technical or Professional Diploma - It refers to a Diploma Certificate obtained from any Polytechnic or University.
*Masters: Refers to any Masters degree - It is the second degree obtained in the university after Bachelors (first degree). Examples include Master of Science (MSc), Masters of Business Administration (MBA).
*Doctorate: Refers to PhD - Doctor of Philosophy is the third level degree obtainable in the university after Masters
*(from interviewer instruction manual))
g ownertertiary=(s2aq10==9 | s2aq10==10 | s2aq10==11 | s2aq10==12) if s2aq10!=.


*Years of education
*Sources:	https://www.nuffic.nl/en/publications/find-a-publication/education-system-nigeria.pdf
*			https://www.tandfonline.com/doi/abs/10.1080/0022062760080206?journalCode=cjeh20
*			http://microdata.worldbank.org/index.php/catalog/2163/datafile/F2/V190
*			http://education.stateuniversity.com/pages/1108/Nigeria-TEACHING-PROFESSION.html
g educyears=0 if s2aq9==0 | s2aq9==1 | s2aq9==2
replace educyears=1 if s2aq9==11
replace educyears=2 if s2aq9==12
replace educyears=3 if s2aq9==13
replace educyears=4 if s2aq9==14
replace educyears=5 if s2aq9==15
replace educyears=6 if s2aq9==16 | s2aq9==27
replace educyears=7 if s2aq9==21
replace educyears=8 if s2aq9==22
replace educyears=9 if s2aq9==23 | s2aq9==33
replace educyears=10 if s2aq9==24
replace educyears=11 if s2aq9==25 | (s2aq9==31 & s2aq10==7)
replace educyears=12 if s2aq9==26 | s2aq9==28 | (s2aq9==31 & s2aq10==6) | s2aq9==32
replace educyears=15  if s2aq9==34 | (s2aq9==31 & s2aq10==8)
replace educyears=16  if s2aq9==42 | s2aq9==41 
replace educyears=18  if s2aq10==11 & educyears==.
replace educyears=21  if s2aq10==12 & educyears==.
*I do not consider quaranic, quaranic integrated and adult education

replace educyears=0 if educyears==. & s2aq10==1
replace educyears=6 if educyears==. & s2aq10==2
replace educyears=9 if educyears==. & (s2aq10==3 | s2aq10==5) 
replace educyears=11 if educyears==. & s2aq10==7
replace educyears=12 if educyears==. & (s2aq10==4 | s2aq10==6)
replace educyears=15 if educyears==. & s2aq10==8
replace educyears=16 if educyears==. & s2aq10==9


keep hhid-excratemonth ownertertiary educyears

*TO DO: decide whether you need/want to change path for saving NGLSMSISA_oh2
/**/
save NGLSMSISA_oh2, replace
/**/

*TO DO: change path to where you saved the following file "sect3a_harvestw1.dta"
/*EXAMPLE:*/
merge 1:1 hhid indiv using "Nigeria LSMS-ISA/Wave 1 - post-harvest/sect3a_harvestw1.dta"
/**/

*Hours worked in self-employment in last month
g selfemployed=(s3aq3==1) if s3aq3!=.

g hours=s3aq15*(30/7) if selfemployed==1

*Worked as wage worker (in last week, instead of last month, since this is not being asked)
g wageworker=(s3aq1==1) if s3aq1!=.

*Labor earnings in last month
g laborincome=s3aq18a if s3aq18b==5
replace laborincome=s3aq18a*8*20 if s3aq18b==1
replace laborincome=s3aq18a*20 if s3aq18b==2
replace laborincome=s3aq18a*4 if s3aq18b==3
replace laborincome=s3aq18a*2 if s3aq18b==4
replace laborincome=s3aq18a/3 if s3aq18b==6
replace laborincome=s3aq18a/6 if s3aq18b==7
replace laborincome=s3aq18a/12 if s3aq18b==8

*Retired
g retired=(s3aq6==3) if s3aq6!=.

keep hhid-ownertertiary educyears selfemployed-retired

*TO DO: decide whether you need/want to change path for saving NGLSMSISA_oh2
/**/
save NGLSMSISA_oh2, replace
/**/

*TO DO: change path to where you saved the following file "sect4a_harvestw1.dta"
/*EXAMPLE:*/
merge 1:1 hhid indiv using "Nigeria LSMS-ISA/Wave 1 - post-harvest/sect4a_harvestw1.dta", nogenerate
/**/

g help=(s4aq3==1 | s4aq3==2) if s4aq3!=.
bysort hhid: egen familyill=max(help)

rename s4aq3 ill

keep hhid-ownertertiary educyears selfemployed-retired ill familyill

*TO DO: decide whether you need/want to change path for saving NGLSMSISA_oh2
/**/
save NGLSMSISA_oh2, replace
/**/
********************************************************************************
*Firm characteristics
********************************************************************************
*TO DO: change path to where you saved the following file "sect9_harvestw1.dta"
/*EXAMPLE:*/
use "Nigeria LSMS-ISA/Wave 1 - post-harvest/sect9_harvestw1.dta", clear
/**/

*Survival 2
*I consider those businesses as closed, that are closed permanently, temporarily, or seasonally
g survival2=(s9q3==1) if s9q2==1 & s9q3!=.

*Reason for closure
rename s9q4 reasonforclosure

rename s9q4b otherreasonforclosure

*New firm started
g newfirmstarted=(s9q2==2) if s9q2!=.

*Urban enterprises
g urban=(sector==1) if sector!=.
drop sector

*Sector of the firm:
*Exclude activities like "crop and animal production, hunting and related service activities", "forestry and logging", and "fishing and aquaculture"
g nonfarm=(s9q1a!=1 & s9q1a!=2 & s9q1a!=3) if s9q1a!=.

*Firm is in retail trade
g retail=(s9q1a==45 | s9q1a==46 | s9q1a==47) if s9q1a!=.

*Firm is in manufacturing sector
g manuf=(s9q1a==10 | s9q1a==11 | s9q1a==12 | s9q1a==13 | s9q1a==14 | s9q1a==15 | s9q1a==16 | s9q1a==17 | s9q1a==19 | s9q1a==20 | s9q1a==21 | s9q1a==22 | s9q1a==23 | s9q1a==24 | s9q1a==25 | s9q1a==26 | s9q1a==27 | s9q1a==28 | s9q1a==29 | s9q1a==30 | s9q1a==31 | s9q1a==32) if s9q1a!=.

*Firm is in service sector
g services=(s9q1a==18 | s9q1a==49 | s9q1a==50 | s9q1a==51 | s9q1a==52 | s9q1a==53 | s9q1a==55 | s9q1a==56 | s9q1a==58 | s9q1a==59 | s9q1a==60 | s9q1a==61 | s9q1a==62 | s9q1a==63 | s9q1a==64 | s9q1a==65 | s9q1a==66 | s9q1a==68 | s9q1a==69 | s9q1a==70 | s9q1a==71 | s9q1a==72 | s9q1a==73 | s9q1a==74 | s9q1a==75 | s9q1a==77 | s9q1a==78 | s9q1a==79 | s9q1a==80 | s9q1a==81 | s9q1a==82 | s9q1a==84 | s9q1a==85 | s9q1a==86 | s9q1a==87 | s9q1a==88 | s9q1a==90 | s9q1a==91 | s9q1a==92 | s9q1a==93 | s9q1a==95 | s9q1a==96) if s9q1a!=.

*Firm is in other sector
g othersector=(s9q1a==5 | s9q1a==6 | s9q1a==7 | s9q1a==8 | s9q1a==9 | s9q1a==36 | s9q1a==37 | s9q1a==38 | s9q1a==39 | s9q1a==41 | s9q1a==42 | s9q1a==43 | s9q1a==94 | s9q1a==97 | s9q1a==99)

g sector=s9q1a

*Unclear
replace manuf=. if s9q1a==98
replace services=. if s9q1a==98

*Age of the firm in years
*Not given anymore

*Capital stock
g capitalstock=s9q24

*Inventories
g inventories=s9q25+s9q26

*Number of paid employees
g help1=(s9q13a!=.)
g help2=(s9q13b!=.)
g help3=(s9q13c!=.)

g help4=help1+help2+help3
egen employees=rowtotal(help4 s9q14a s9q14b),m
drop help*

*Sales
g sales=s9q27

*Expenditures
egen expenses=rowtotal(s9q28a-s9q28h),m

*Profits
g profits=sales-expenses

keep hhid entid /*entid2011*/ s9q1b s9q2 s9q3 reasonforclosure otherreasonforclosure s9q5a-s9q9 survival2-profits

rename s9q5a s9q51
rename s9q5b s9q52


*Multiple firms per household
/*I consider those firms that are operating or new (as new firms should not have been
	asked this question) - Missings are disregard*/
g help=(s9q3==1 | (s9q2==2 & s9q3==.))
bysort hhid: egen help2=total(help)
g morethanonefirm2=(help2>1)
drop help help2

duplicates drop hhid morethanonefirm, force


reshape long s9q5, i(hhid entid) j(help)

bysort hhid: egen help1=seq() if s9q5!=.

*Jointly operated businesses
bysort hhid: egen help2=max(help1)
g jointbus=(help2>1) if help2!=.

drop help1 help2

*Businessowner
rename s9q5 businessowner

*Manager
g manager=(businessowner==s9q6a | businessowner==s9q6b) if (s9q6a!=. |  s9q6b!=.) & businessowner!=.

reshape wide businessowner manager, i(hhid entid) j(help)

rename s9q9 respbus

*TO DO: decide whether you need/want to change path for saving NGLSMSISA_f2
/**/
save NGLSMSISA_f2, replace
/**/

*TO DO: change path to where you saved the following file "NGLSMSISA_oh2"
/*EXAMPLE:*/
use NGLSMSISA_oh2, clear
/**/

*TO DO: change path to where you saved the following file "NGLSMSISA_f2"
/*EXAMPLE:*/
merge m:1 hhid using NGLSMSISA_f2
/**/

*I assume that households who do not appear in the firm dataset don't operate a business
g hhbus=0 if _merge==1
replace hhbus=1 if _merge!=1 & (s9q3==1 | (s9q2==2 & s9q3==.))
replace hhbus=0 if _merge!=1 & (s9q3==2 | s9q3==3 | s9q3==4)
replace hhbus=0 if nonfarm==0
replace hhbus=. if nonfarm==.


drop _merge

foreach var of varlist wave-hhbus{
rename `var' `var'_2
}

*TO DO: decide whether you need/want to change path for saving NGLSMSISA2
/**/
save NGLSMSISA2, replace
/**/

********************************************************************************

********************************************************************************
*Round 3 (Wave 2 - post-planting)
********************************************************************************

********************************************************************************
*TO DO: change path to where you saved the following file "sect1_plantingw2.dta"
/*EXAMPLE:*/
use "Nigeria LSMS-ISA/Wave 2 - post planting/sect1_plantingw2.dta", clear
/**/

*Wave
g wave=3

*Year survey took place
g surveyyear=2012

*Age of owner
g ownerage=s1q6

*Gender of owner
g female=(s1q2==2) if s1q2!=.

*Child under 5 in household
g under5=0
replace under5=. if s1q6==. 
replace under5=1 if s1q6<5 
bysort hhid: egen childunder5=max(under5)
drop under5

*Child aged 5 to 12 in household
g aged5to12=0
replace aged5to12=. if  s1q6==. 
replace aged5to12=1 if  s1q6>=5 & s1q6<12
bysort hhid: egen childaged5to12=max(aged5to12)
drop aged5to12

*Has adult aged 65+ in the household
g is65orover=0
replace is65orover=. if s1q6==. 
replace is65orover=1 if s1q6>=65 & s1q6!=. 
bysort hhid: egen adult65andover=max(is65orover)
drop is65orover

*Marital status of owner (I consider monogamous and polygamous marriages)
g married=(s1q8==1 | s1q8==2) if s1q8!=.

*Household size
g help=(s1q5==1 | (s1q14==1 & s1q15==1))
bysort hhid: egen hhsize=total(help),m
drop help

*Owner died between survey rounds
g dead=(s1q14==2 & s1q29==11) if s1q29!=.

keep hhid indiv wave-dead

*TO DO: decide whether you need/want to change path for saving NGLSMSISA_oh3
/**/
save NGLSMSISA_oh3, replace
/**/

*Household consumption
*TO DO: change path to where you saved the following file "sect7a_plantingw2.dta"
/*EXAMPLE:*/
use "Nigeria LSMS-ISA/Wave 2 - post planting/sect7a_plantingw2.dta", clear
/**/

bysort hhid: egen weeklyfood_a=total(s7aq2), m

keep hhid weeklyfood_a
duplicates drop

*TO DO: decide whether you need/want to change path for saving consumpexp
/**/
save consumpexp, replace
/**/

*TO DO: change path to where you saved the following file "sect7b_plantingw2.dta"
/*EXAMPLE:*/
use "Nigeria LSMS-ISA/Wave 2 - post planting/sect7b_plantingw2.dta", clear
/**/

bysort hhid: egen weeklyfood_b=total(s7bq4), m
/*This only includes food that was purchased. For own production, gifts and food
 from other sources, there are no monetary values given, only the quantities.*/

keep hhid weeklyfood_b
duplicates drop

*TO DO: change path to where you saved the following file "consumpexp.dta"
/*EXAMPLE:*/
merge 1:1 hhid using consumpexp, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving NGLSMSISA2
/**/
save consumpexp, replace
/**/

*TO DO: change path to where you saved the following file "sect8a_plantingw2.dta"
/*EXAMPLE:*/
use "Nigeria LSMS-ISA/Wave 2 - post planting/sect8a_plantingw2.dta", clear
/**/

bysort hhid: egen weeklyconsumpexp=total(s8q2), m

keep hhid weeklyconsumpexp
duplicates drop

*TO DO: change path to where you saved the following file "consumpexp.dta"
/*EXAMPLE:*/
merge 1:1 hhid using consumpexp, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving consumpexp
/**/
save consumpexp, replace
/**/

*TO DO: change path to where you saved the following file "sect8b_plantingw2.dta"
/*EXAMPLE:*/
use "Nigeria LSMS-ISA/Wave 2 - post planting/sect8b_plantingw2.dta", clear
/**/

bysort hhid: egen monthlyconsumpexp=total(s8q4), m

keep hhid monthlyconsumpexp
duplicates drop

*TO DO: change path to where you saved the following file "sect8b_plantingw2.dta"
/*EXAMPLE:*/
merge 1:1 hhid using consumpexp, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving consumpexp
/**/
save consumpexp, replace
/**/

*TO DO: change path to where you saved the following file "sect8c_plantingw2.dta"
/*EXAMPLE:*/
use "Nigeria LSMS-ISA/Wave 2 - post planting/sect8c_plantingw2.dta", clear
/**/

bysort hhid: egen semiannconsumpexp=total(s8q6), m

keep hhid semiannconsumpexp
duplicates drop

*TO DO: change path to where you saved the following file "consumpexp.dta"
/*EXAMPLE:*/
merge 1:1 hhid using consumpexp, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving consumpexp
/**/
save consumpexp, replace
/**/

*TO DO: change path to where you saved the following file "sect8d_plantingw2.dta"
/*EXAMPLE:*/
use "Nigeria LSMS-ISA/Wave 2 - post planting/sect8d_plantingw2.dta", clear
/**/

bysort hhid: egen yearlyconsumpexp=total(s8q8), m

keep hhid yearlyconsumpexp
duplicates drop

*TO DO: change path to where you saved the following file "consumpexp.dta"
/*EXAMPLE:*/
merge 1:1 hhid using consumpexp, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving consumpexp
/**/
save consumpexp, replace
/**/

*TO DO: change path to where you saved the following file "sect8e_plantingw2.dta"
/*EXAMPLE:*/
use "Nigeria LSMS-ISA/Wave 2 - post planting/sect8e_plantingw2.dta", clear
/**/

bysort hhid: egen yearlyconsumpexp2=total(s8q10), m

keep hhid yearlyconsumpexp2
duplicates drop

*TO DO: change path to where you saved the following file "consumpexp.dta"
/*EXAMPLE:*/
merge 1:1 hhid using consumpexp, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving consumpexp
/**/
save consumpexp, replace
/**/

replace semiannconsumpexp=2*semiannconsumpexp
replace monthlyconsumpexp=12*monthlyconsumpexp
replace weeklyconsumpexp=52*weeklyconsumpexp
replace weeklyfood_b=52*weeklyfood_b
replace weeklyfood_a=52*weeklyfood_a

egen hh_exp=rowtotal(yearlyconsumpexp yearlyconsumpexp2 semiannconsumpexp monthlyconsumpexp weeklyconsumpexp weeklyfood_b weeklyfood_a), m

keep hhid hh_exp

*TO DO: decide whether you need/want to change path for saving consumpexp
/**/
save consumpexp, replace
/**/

*TO DO: change path to where you saved the following file "NGLSMSISA_oh3.dta"
/*EXAMPLE:*/
merge 1:m hhid using NGLSMSISA_oh3, nogenerate
/**/

g pcexpend=hh_exp/hhsize

drop hh_exp hhsize

*Exchange rate
/* The post-harvest survey for wave 1 was conducted from September to November 2012,
	so I take Oct. 15 as the approximate mid-point of the survey.*/
/*According to oanda.com, the NGN to USD exchange rate on Oct. 15, 2012 was 0.00626.
	(https://www.oanda.com/lang/de/currency/converter/)
*/
g excrate=0.00626

g excratemonth="10-2012"

*TO DO: decide whether you need/want to change path for saving NGLSMSISA_oh3
/**/
save NGLSMSISA_oh3, replace
/**/

*TO DO: change path to where you saved the following file "sect2_plantingw2.dta"
/*EXAMPLE:*/
merge 1:1 hhid indiv using "Nigeria LSMS-ISA/Wave 2 - post planting/sect2_plantingw2.dta"
/**/

*Education of owner
*(I consider the following degrees obtained as highest degree obtained:
*BA/BSc./HND - Bachelor of Arts/Bachelor of Science/Higher National Diploma are obtained after three (3), four (4), five (5) or six (6) years of university or polytechnic education
*Technical or Professional Diploma - It refers to a Diploma Certificate obtained from any Polytechnic or University.
*Masters: Refers to any Masters degree - It is the second degree obtained in the university after Bachelors (first degree). Examples include Master of Science (MSc), Masters of Business Administration (MBA).
*Doctorate: Refers to PhD - Doctor of Philosophy is the third level degree obtainable in the university after Masters
*(from interviewer instruction manual))
g ownertertiary=(s2q9==9 | s2q9==10 | s2q9==11 | s2q9==12) if s2q9!=.

*Years of education
*Sources:	https://www.nuffic.nl/en/publications/find-a-publication/education-system-nigeria.pdf
*			https://www.tandfonline.com/doi/abs/10.1080/0022062760080206?journalCode=cjeh20
*			http://microdata.worldbank.org/index.php/catalog/2163/datafile/F2/V190
*			http://education.stateuniversity.com/pages/1108/Nigeria-TEACHING-PROFESSION.html
g educyears=0 if s2q8==0 | s2q8==1 | s2q8==2
replace educyears=1 if s2q8==11
replace educyears=2 if s2q8==12
replace educyears=3 if s2q8==13
replace educyears=4 if s2q8==14
replace educyears=5 if s2q8==15
replace educyears=6 if s2q8==16 | s2q8==27
replace educyears=7 if s2q8==21
replace educyears=8 if s2q8==22
replace educyears=9 if s2q8==23 | s2q8==33
replace educyears=10 if s2q8==24
replace educyears=11 if s2q8==25 | (s2q8==31 & s2q9==7)
replace educyears=12 if s2q8==26 | s2q8==28 | (s2q8==31 & s2q9==6) | s2q8==32
replace educyears=15  if s2q8==34 | (s2q8==31 & s2q9==8)
replace educyears=16  if s2q8==42 | s2q8==41 
replace educyears=18  if s2q9==11 & educyears==.
replace educyears=21  if s2q9==12 & educyears==.
*I do not consider quaranic, quaranic integrated and adult education

replace educyears=0 if educyears==. & s2q9==1
replace educyears=6 if educyears==. & s2q9==2
replace educyears=9 if educyears==. & (s2q9==3 | s2q9==5) 
replace educyears=11 if educyears==. & s2q9==7
replace educyears=12 if educyears==. & (s2q9==4 | s2q9==6)
replace educyears=15 if educyears==. & s2q9==8
replace educyears=16 if educyears==. & s2q9==9

keep hhid-excratemonth ownertertiary educyears

*TO DO: decide whether you need/want to change path for saving NGLSMSISA_oh3
/**/
save NGLSMSISA_oh3, replace
/**/

*TO DO: change path to where you saved the following file "sect3a_plantingw2.dta"
/*EXAMPLE:*/
merge 1:1 hhid indiv using "Nigeria LSMS-ISA/Wave 2 - post planting/sect3a_plantingw2.dta"
/**/

*Hours worked in self-employment in last month
g selfemployed=(s3aq6==1) if s3aq6!=.

g hours=s3aq18*(30/7) if selfemployed==1

*Worked as wage worker (in last week, instead of last month, since this is not being asked)
g wageworker=(s3aq4==1) if s3aq4!=.

*Labor earnings in last month
g laborincome=s3aq21a if s3aq21b==5
replace laborincome=s3aq21a*8*20 if s3aq21b==1
replace laborincome=s3aq21a*20 if s3aq21b==2
replace laborincome=s3aq21a*4 if s3aq21b==3
replace laborincome=s3aq21a*2 if s3aq21b==4
replace laborincome=s3aq21a/3 if s3aq21b==6
replace laborincome=s3aq21a/6 if s3aq21b==7
replace laborincome=s3aq21a/12 if s3aq21b==8

*Retired
g retired=(s3aq9==3) if s3aq9!=.

keep hhid-ownertertiary educyears selfemployed-retired

*TO DO: decide whether you need/want to change path for saving NGLSMSISA_oh3
/**/
save NGLSMSISA_oh3, replace
/**/

********************************************************************************
*Firm characteristics
********************************************************************************
*TO DO: change path to where you saved the following file "sect6_plantingw2.dta"
/*EXAMPLE:*/
use "Nigeria LSMS-ISA/Wave 2 - post planting/sect6_plantingw2.dta", clear
/**/

*Survival 2
*I only consider those businesses as closed, that are closed permanently, temporarily, or seasonally
g survival2=(s6q3==1) if  s6q2==1 & s6q3!=.

*Reason for closure
rename s6q4 reasonforclosure

rename s6q4b otherreasonforclosure

*New firm started
g newfirmstarted=(s6q2==2) if s6q2!=.

*Urban enterprises
g urban=(sector==1) if sector!=.
drop sector

*Sector of the firm:
*Exclude activities like "crop and animal production, hunting and related service activities", "forestry and logging", and "fishing and aquaculture"
g nonfarm=(s6q1a!=1 & s6q1a!=2 & s6q1a!=3) if s6q1a!=.

*Firm is in retail trade
g retail=(s6q1a==45 | s6q1a==46 | s6q1a==47) if s6q1a!=.

*Firm is in manufacturing sector
g manuf=(s6q1a==10 | s6q1a==11 | s6q1a==12 | s6q1a==13 | s6q1a==14 | s6q1a==15 | s6q1a==16 | s6q1a==17 | s6q1a==19 | s6q1a==20 | s6q1a==21 | s6q1a==22 | s6q1a==23 | s6q1a==24 | s6q1a==25 | s6q1a==26 | s6q1a==27 | s6q1a==28 | s6q1a==29 | s6q1a==30 | s6q1a==31 | s6q1a==32) if s6q1a!=.

*Firm is in service sector
g services=(s6q1a==18 | s6q1a==49 | s6q1a==50 | s6q1a==51 | s6q1a==52 | s6q1a==53 | s6q1a==55 | s6q1a==56 | s6q1a==58 | s6q1a==59 | s6q1a==60 | s6q1a==61 | s6q1a==62 | s6q1a==63 | s6q1a==64 | s6q1a==65 | s6q1a==66 | s6q1a==68 | s6q1a==69 | s6q1a==70 | s6q1a==71 | s6q1a==72 | s6q1a==73 | s6q1a==74 | s6q1a==75 | s6q1a==77 | s6q1a==78 | s6q1a==79 | s6q1a==80 | s6q1a==81 | s6q1a==82 | s6q1a==84 | s6q1a==85 | s6q1a==86 | s6q1a==87 | s6q1a==88 | s6q1a==90 | s6q1a==91 | s6q1a==92 | s6q1a==93 | s6q1a==95 | s6q1a==96) if s6q1a!=.

*Firm is in other sector
g othersector=(s6q1a==5 | s6q1a==6 | s6q1a==7 | s6q1a==8 | s6q1a==9 | s6q1a==36 | s6q1a==37 | s6q1a==38 | s6q1a==39 | s6q1a==41 | s6q1a==42 | s6q1a==43 | s6q1a==94 | s6q1a==97 | s6q1a==99)

g sector=s6q1a

*Unclear
replace manuf=. if s6q1a==98
replace services=. if s6q1a==98

*Age of the firm in years
*Not given anymore

*Capital stock
g capitalstock=s6q27

*Inventories
g inventories=s6q28+s6q29

*Number of paid employees
g help1=(s6q14a!=.)
g help2=(s6q14b!=.)
g help3=(s6q14c!=.)

g help4=help1+help2+help3
egen employees=rowtotal(help4 s6q15a s6q15b),m
drop help*

*Sales
g sales=s6q30

*Expenditures
egen expenses=rowtotal(s6q31a-s6q31j),m

*Profits
g profits=sales-expenses

keep hhid entid s6q1b s6q2 s6q3  reasonforclosure otherreasonforclosure s6q5a-s6q10 survival-profits

rename s6q5a s6q51
rename s6q5b s6q52

*Multiple firms per household
/*I consider those firms that are operating or new (as new firms should not have been
	asked this question) - Missings are disregarded*/
g help=(s6q3==1 | (s6q2==2 & s6q3==.))
bysort hhid: egen help2=total(help)
g morethanonefirm2=(help2>1)
drop help help2

duplicates drop hhid morethanonefirm, force

reshape long s6q5, i(hhid entid) j(help)

bysort hhid: egen help1=seq() if s6q5!=.

*Jointly operated businesses
bysort hhid: egen help2=max(help1)
g jointbus=(help2>1) if help2!=.

drop help1 help2

*Businessowner
rename s6q5 businessowner

*Manager
g manager=(businessowner==s6q7a | businessowner==s6q7b) if (s6q7a!=. |  s6q7b!=.) & businessowner!=.

reshape wide businessowner manager, i(hhid entid) j(help)

rename s6q10 respbus

*TO DO: decide whether you need/want to change path for saving NGLSMSISA_f3
/**/
save NGLSMSISA_f3, replace
/**/

*TO DO: change path to where you saved the following file "NGLSMSISA_oh3"
/*EXAMPLE:*/
use NGLSMSISA_oh3, clear
/**/

*TO DO: change path to where you saved the following file "NGLSMSISA_f3"
/*EXAMPLE:*/
merge m:1 hhid using NGLSMSISA_f3
/**/

*I assume that households who do not appear in the firm dataset don't operate a business
g hhbus=0 if _merge==1
replace hhbus=1 if _merge!=1 & (s6q3==1 | (s6q2==2 & s6q3==.))
replace hhbus=0 if _merge!=1 & (s6q3==2 | s6q3==3 | s6q3==4)
replace hhbus=0 if nonfarm==0
replace hhbus=. if nonfarm==.

drop _merge

foreach var of varlist wave-hhbus{
rename `var' `var'_3
}

*TO DO: decide whether you need/want to change path for saving NGLSMSISA3
/**/
save NGLSMSISA3, replace
/**/
********************************************************************************

********************************************************************************
*Round 4 (Wave 2 - post-harvest)
********************************************************************************

********************************************************************************
*TO DO: change path to where you saved the following file "sect1_harvestw2"
/*EXAMPLE:*/
use "Nigeria LSMS-ISA/Wave 2 - post harvest/sect1_harvestw2", clear
/**/

*Wave
g wave=4

*Year survey took place
g surveyyear=2013

*Age of owner
g ownerage=s1q4

*Gender of owner
g female=(s1q2==2) if s1q2!=.

*Child under 5 in household
g under5=0
replace under5=. if s1q4==. 
replace under5=1 if s1q4<5 
bysort hhid: egen childunder5=max(under5)
drop under5

*Child aged 5 to 12 in household
g aged5to12=0
replace aged5to12=. if  s1q4==. 
replace aged5to12=1 if  s1q4>=5 & s1q4<12
bysort hhid: egen childaged5to12=max(aged5to12)
drop aged5to12

*Has adult aged 65+ in the household
g is65orover=0
replace is65orover=. if s1q4==. 
replace is65orover=1 if s1q4>=65 & s1q4!=. 
bysort hhid: egen adult65andover=max(is65orover)
drop is65orover

*Marital status of owner (I consider monogamous and polygamous marriages)
g married=(s1q7==1 | s1q7==2) if s1q7!=.

*Household size
g help=(s1q5==1 | (s1q13==1 & s1q14==1))
bysort hhid: egen hhsize=total(help),m
drop help

*Owner died between survey rounds
g dead=(s1q14==2 & s1q28==11) if s1q28!=.

keep hhid indiv wave-dead

*TO DO: decide whether you need/want to change path for saving NGLSMSISA_oh4
/**/
save NGLSMSISA_oh4, replace
/**/

*Household consumption
*TO DO: change path to where you saved the following file "sect10a_harvestw2.dta"
/*EXAMPLE:*/
use "Nigeria LSMS-ISA/Wave 2 - post harvest/sect10a_harvestw2.dta", clear
/**/

bysort hhid: egen weeklyfood_a=total(s10aq2), m

keep hhid weeklyfood_a
duplicates drop

*TO DO: decide whether you need/want to change path for saving consumpexp
/**/
save consumpexp, replace
/**/

*TO DO: change path to where you saved the following file "sect10b_harvestw2.dta"
/*EXAMPLE:*/
use "Nigeria LSMS-ISA/Wave 2 - post harvest/sect10b_harvestw2.dta", clear
/**/

bysort hhid: egen weeklyfood_b=total(s10bq4), m
/*This only includes food that was purchased. For own production, gifts and food
 from other sources, there are no monetary values given, only the quantities.*/

keep hhid weeklyfood_b
duplicates drop

*TO DO: change path to where you saved the following file "consumpexp.dta"
/*EXAMPLE:*/
merge 1:1 hhid using consumpexp, nogenerate
/**/


*TO DO: decide whether you need/want to change path for saving consumpexp
/**/
save consumpexp, replace
/**/

*TO DO: change path to where you saved the following file "sect11a_harvestw2.dta"
/*EXAMPLE:*/
use "Nigeria LSMS-ISA/Wave 2 - post harvest/sect11a_harvestw2.dta", clear
/**/

bysort hhid: egen weeklyconsumpexp=total(s11aq2), m

keep hhid weeklyconsumpexp
duplicates drop

*TO DO: change path to where you saved the following file "consumpexp.dta"
/*EXAMPLE*/
merge 1:1 hhid using consumpexp, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving consumpexp
/**/
save consumpexp, replace
/**/

*TO DO: change path to where you saved the following file "sect11b_harvestw2.dta"
/*EXAMPLE*/
use "Nigeria LSMS-ISA/Wave 2 - post harvest/sect11b_harvestw2.dta", clear
/**/

bysort hhid: egen monthlyconsumpexp=total(s11bq4), m

keep hhid monthlyconsumpexp
duplicates drop

*TO DO: change path to where you saved the following file "consumpexp.dta"
/*EXAMPLE*/
merge 1:1 hhid using consumpexp, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving consumpexp
/**/
save consumpexp, replace
/**/

*TO DO: change path to where you saved the following file "sect11c_harvestw2.dta"
/*EXAMPLE*/
use "Nigeria LSMS-ISA/Wave 2 - post harvest/sect11c_harvestw2.dta", clear
/**/

bysort hhid: egen semiannconsumpexp=total(s11cq6), m

keep hhid semiannconsumpexp
duplicates drop

*TO DO: change path to where you saved the following file "consumpexp.dta"
/*EXAMPLE*/
merge 1:1 hhid using consumpexp, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving consumpexp
/**/
save consumpexp, replace
/**/

*TO DO: change path to where you saved the following file "sect11d_harvestw2.dta"
/*EXAMPLE*/
use "Nigeria LSMS-ISA/Wave 2 - post harvest/sect11d_harvestw2.dta", clear
/**/

bysort hhid: egen yearlyconsumpexp=total(s11dq8), m

keep hhid yearlyconsumpexp
duplicates drop

*TO DO: change path to where you saved the following file "consumpexp.dta"
/*EXAMPLE*/
merge 1:1 hhid using consumpexp, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving consumpexp
/**/
save consumpexp, replace
/**/

*TO DO: change path to where you saved the following file "sect11e_harvestw2.dta"
/*EXAMPLE*/
use "Nigeria LSMS-ISA/Wave 2 - post harvest/sect11e_harvestw2.dta", clear
/**/

bysort hhid: egen yearlyconsumpexp2=total(s11eq10), m

keep hhid yearlyconsumpexp2
duplicates drop

*TO DO: change path to where you saved the following file "consumpexp.dta"
/*EXAMPLE*/
merge 1:1 hhid using consumpexp, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving consumpexp
/**/
save consumpexp, replace
/**/

replace semiannconsumpexp=2*semiannconsumpexp
replace monthlyconsumpexp=12*monthlyconsumpexp
replace weeklyconsumpexp=52*weeklyconsumpexp
replace weeklyfood_b=52*weeklyfood_b
replace weeklyfood_a=52*weeklyfood_a

egen hh_exp=rowtotal(yearlyconsumpexp yearlyconsumpexp2 semiannconsumpexp monthlyconsumpexp weeklyconsumpexp weeklyfood_b weeklyfood_a), m

keep hhid hh_exp

*TO DO: decide whether you need/want to change path for saving consumpexp
/**/
save consumpexp, replace
/**/

*TO DO: change path to where you saved the following file "NGLSMSISA_oh4.dta"
/*EXAMPLE*/
merge 1:m hhid using NGLSMSISA_oh4, nogenerate
/**/

g pcexpend=hh_exp/hhsize

drop hh_exp hhsize

*Exchange rate
/* The post-harvest survey for wave 1 was conducted from February to April 2013,
	so I take March 15 as the approximate mid-point of the survey.*/
/*According to oanda.com, the NGN to USD exchange rate on March 15, 2013 was 0.00627.
	(https://www.oanda.com/lang/de/currency/converter/)
*/
g excrate=0.00627

g excratemonth="3-2013"

*TO DO: decide whether you need/want to change path for saving NGLSMSISA_oh4
/**/
save NGLSMSISA_oh4, replace
/**/

*TO DO: change path to where you saved the following file "sect2a_harvestw2.dta"
/*EXAMPLE*/
merge 1:1 hhid indiv using "Nigeria LSMS-ISA/Wave 2 - post harvest/sect2a_harvestw2.dta"
/**/

*Education of owner
*(I consider the following degrees obtained as highest degree obtained:
*BA/BSc./HND - Bachelor of Arts/Bachelor of Science/Higher National Diploma are obtained after three (3), four (4), five (5) or six (6) years of university or polytechnic education
*Technical or Professional Diploma - It refers to a Diploma Certificate obtained from any Polytechnic or University.
*Masters: Refers to any Masters degree - It is the second degree obtained in the university after Bachelors (first degree). Examples include Master of Science (MSc), Masters of Business Administration (MBA).
*Doctorate: Refers to PhD - Doctor of Philosophy is the third level degree obtainable in the university after Masters
*(from interviewer instruction manual))
g ownertertiary=(s2aq10==9 | s2aq10==10 | s2aq10==11 | s2aq10==12) if s2aq10!=.

*Years of education
*Sources:	https://www.nuffic.nl/en/publications/find-a-publication/education-system-nigeria.pdf
*			https://www.tandfonline.com/doi/abs/10.1080/0022062760080206?journalCode=cjeh20
*			http://microdata.worldbank.org/index.php/catalog/2163/datafile/F2/V190
*			http://education.stateuniversity.com/pages/1108/Nigeria-TEACHING-PROFESSION.html
g educyears=0 if s2aq9==0 | s2aq9==1 | s2aq9==2
replace educyears=1 if s2aq9==11
replace educyears=2 if s2aq9==12
replace educyears=3 if s2aq9==13
replace educyears=4 if s2aq9==14
replace educyears=5 if s2aq9==15
replace educyears=6 if s2aq9==16 | s2aq9==27
replace educyears=7 if s2aq9==21
replace educyears=8 if s2aq9==22
replace educyears=9 if s2aq9==23 | s2aq9==33
replace educyears=10 if s2aq9==24
replace educyears=11 if s2aq9==25 | (s2aq9==31 & s2aq10==7)
replace educyears=12 if s2aq9==26 | s2aq9==28 | (s2aq9==31 & s2aq10==6) | s2aq9==32
replace educyears=15  if s2aq9==34 | (s2aq9==31 & s2aq10==8)
replace educyears=16  if s2aq9==42 | s2aq9==41 
replace educyears=18  if s2aq10==11 & educyears==.
replace educyears=21  if s2aq10==12 & educyears==.
*I do not consider quaranic, quaranic integrated and adult education

replace educyears=0 if educyears==. & s2aq10==1
replace educyears=6 if educyears==. & s2aq10==2
replace educyears=9 if educyears==. & (s2aq10==3 | s2aq10==5) 
replace educyears=11 if educyears==. & s2aq10==7
replace educyears=12 if educyears==. & (s2aq10==4 | s2aq10==6)
replace educyears=15 if educyears==. & s2aq10==8
replace educyears=16 if educyears==. & s2aq10==9

keep hhid-excratemonth ownertertiary educyears

*TO DO: decide whether you need/want to change path for saving NGLSMSISA_oh4
/**/
save NGLSMSISA_oh4, replace
/**/

*TO DO: change path to where you saved the following file "sect3a_harvestw2.dta"
/*EXAMPLE*/
merge 1:1 hhid indiv using "Nigeria LSMS-ISA/Wave 2 - post harvest/sect3a_harvestw2.dta"
/**/

*Hours worked in self-employment in last month
g selfemployed=(s3aq3==1) if s3aq3!=.

g hours=s3aq15*(30/7) if selfemployed==1

*Worked as wage worker (in last week, instead of last month, since this is not being asked)
g wageworker=(s3aq1==1) if s3aq1!=.

*Labor earnings in last month
g laborincome=s3aq18a1 if s3aq18a2==5
replace laborincome=s3aq18a1*8*20 if s3aq18a2==1
replace laborincome=s3aq18a1*20 if s3aq18a2==2
replace laborincome=s3aq18a1*4 if s3aq18a2==3
replace laborincome=s3aq18a1*2 if s3aq18a2==4
replace laborincome=s3aq18a1/3 if s3aq18a2==6
replace laborincome=s3aq18a1/6 if s3aq18a2==7
replace laborincome=s3aq18a1/12 if s3aq18a2==8

*Retired
g retired=(s3aq6==3) if s3aq6!=.

keep hhid-ownertertiary educyears selfemployed-retired


*TO DO: decide whether you need/want to change path for saving NGLSMSISA_oh4
/**/
save NGLSMSISA_oh4, replace
/**/

*TO DO: change path to where you saved the following file "sect4a_harvestw2.dta"
/*EXAMPLE*/
merge 1:1 hhid indiv using "Nigeria LSMS-ISA/Wave 2 - post harvest/sect4a_harvestw2.dta", nogenerate
/**/

g help=(s4aq3==1 | s4aq3==2) if s4aq3!=.
bysort hhid: egen familyill=max(help)

rename s4aq3 ill

keep hhid-ownertertiary educyears selfemployed-retired ill familyill

*TO DO: decide whether you need/want to change path for saving NGLSMSISA_oh4
/**/
save NGLSMSISA_oh4, replace
/**/

********************************************************************************
*Firm characteristics
********************************************************************************
*TO DO: change path to where you saved the following file "sect9_harvestw2.dta"
/*EXAMPLE*/
use "Nigeria LSMS-ISA/Wave 2 - post harvest/sect9_harvestw2.dta", clear
/**/

*Survival 2
*I consider those businesses as closed, that are closed permanently, temporarily, or seasonally
g survival2=(s9q3==1) if s9q2==1 & s9q3!=.

*Reason for closure
rename s9q4 reasonforclosure

rename s9q4b otherreasonforclosure

*New firm started
g newfirmstarted=(s9q2==2) if s9q2!=.

*Urban enterprises
g urban=(sector==1) if sector!=.
drop sector

*Sector of the firm:
*Exclude activities like "crop and animal production, hunting and related service activities", "forestry and logging", and "fishing and aquaculture"
g nonfarm=(s9q1b!=1 & s9q1b!=2 & s9q1b!=3) if s9q1b!=.

*Firm is in retail trade
g retail=(s9q1b==45 | s9q1b==46 | s9q1b==47) if s9q1b!=.

*Firm is in manufacturing sector
g manuf=(s9q1b==10 | s9q1b==11 | s9q1b==12 | s9q1b==13 | s9q1b==14 | s9q1b==15 | s9q1b==16 | s9q1b==17 | s9q1b==19 | s9q1b==20 | s9q1b==21 | s9q1b==22 | s9q1b==23 | s9q1b==24 | s9q1b==25 | s9q1b==26 | s9q1b==27 | s9q1b==28 | s9q1b==29 | s9q1b==30 | s9q1b==31 | s9q1b==32) if s9q1b!=.

*Firm is in service sector
g services=(s9q1b==18 | s9q1b==49 | s9q1b==50 | s9q1b==51 | s9q1b==52 | s9q1b==53 | s9q1b==55 | s9q1b==56 | s9q1b==58 | s9q1b==59 | s9q1b==60 | s9q1b==61 | s9q1b==62 | s9q1b==63 | s9q1b==64 | s9q1b==65 | s9q1b==66 | s9q1b==68 | s9q1b==69 | s9q1b==70 | s9q1b==71 | s9q1b==72 | s9q1b==73 | s9q1b==74 | s9q1b==75 | s9q1b==77 | s9q1b==78 | s9q1b==79 | s9q1b==80 | s9q1b==81 | s9q1b==82 | s9q1b==84 | s9q1b==85 | s9q1b==86 | s9q1b==87 | s9q1b==88 | s9q1b==90 | s9q1b==91 | s9q1b==92 | s9q1b==93 | s9q1b==95 | s9q1b==96) if s9q1b!=.

*Firm is in other sector
g othersector=(s9q1b==5 | s9q1b==6 | s9q1b==7 | s9q1b==8 | s9q1b==9 | s9q1b==36 | s9q1b==37 | s9q1b==38 | s9q1b==39 | s9q1b==41 | s9q1b==42 | s9q1b==43 | s9q1b==94 | s9q1b==97 | s9q1b==99)

g sector=s9q1b

*Unclear
replace manuf=. if s9q1b==98
replace services=. if s9q1b==98

*Age of the firm in years
*Not given anymore

*Capital stock
g capitalstock=s9q24

*Inventories
g inventories=s9q25+s9q26

*Number of paid employees
g help1=(s9q13a!=.)
g help2=(s9q13b!=.)
g help3=(s9q13c!=.)

g help4=help1+help2+help3
egen employees=rowtotal(help4 s9q14a s9q14b),m
drop help*

*Sales
g sales=s9q27

*Expenditures
egen expenses=rowtotal(s9q28a-s9q28j),m

*Profits
g profits=sales-expenses

keep hhid entid s9q1c s9q2 s9q3 reasonforclosure otherreasonforclosure s9q5a1-s9q9 survival-profits

rename s9q5a1 s9q51
rename s9q5a2 s9q52

*Multiple firms per household
/*I consider those firms that are operating or new (as new firms should not have been
	asked this question) - Missings are disregard*/
g help=(s9q3==1 | (s9q2==2 & s9q3==.))
bysort hhid: egen help2=total(help)
g morethanonefirm2=(help2>1)
drop help help2

duplicates drop hhid morethanonefirm, force


reshape long s9q5, i(hhid entid) j(help)

bysort hhid: egen help1=seq() if s9q5!=.

*Jointly operated businesses
bysort hhid: egen help2=max(help1)
g jointbus=(help2>1) if help2!=.

drop help1 help2

*Businessowner
rename s9q5 businessowner

*Manager
g manager=(businessowner==s9q6a | businessowner==s9q6b) if (s9q6a!=. |  s9q6b!=.) & businessowner!=.

reshape wide businessowner manager, i(hhid entid) j(help)

rename s9q9 respbus

*TO DO: decide whether you need/want to change path for saving NGLSMSISA_f4
/**/
save NGLSMSISA_f4, replace
/**/

*TO DO: change path to where you saved the following file "NGLSMSISA_oh4.dta"
/*EXAMPLE*/
use NGLSMSISA_oh4, clear
/**/

*TO DO: change path to where you saved the following file "NGLSMSISA_f4.dta"
/*EXAMPLE*/
merge m:1 hhid using NGLSMSISA_f4
/**/

*I assume that households who do not appear in the firm dataset don't operate a business
g hhbus=0 if _merge==1
replace hhbus=1 if _merge!=1 & (s9q3==1 | (s9q2==2 & s9q3==.))
replace hhbus=0 if _merge!=1 & (s9q3==2 | s9q3==3 | s9q3==4)
replace hhbus=0 if nonfarm==0
replace hhbus=. if nonfarm==.

drop _merge

foreach var of varlist wave-hhbus{
rename `var' `var'_4
}

*TO DO: decide whether you need/want to change path for saving NGLSMSISA4
/**/
save NGLSMSISA4, replace
/**/

********************************************************************************

********************************************************************************
* Merge different rounds and create attrition-variables
********************************************************************************

********************************************************************************
*TO DO: change path to where you saved the following file "NGLSMSISA.dta"
/*EXAMPLE*/
use NGLSMSISA, clear
/**/
*TO DO: change path to where you saved the following file "NGLSMSISA2.dta"
/*EXAMPLE*/
merge 1:1 hhid indiv using NGLSMSISA2
/**/
*TO DO: change path to where you saved the following file "NGLSMSISA3.dta"
/*EXAMPLE*/
merge 1:1 hhid indiv using NGLSMSISA3, gen(_merge2)
/**/
*TO DO: change path to where you saved the following file "NGLSMSISA4.dta"
/*EXAMPLE*/
merge 1:1 hhid indiv using NGLSMSISA4, gen(_merge3)
/**/

*Attrition from round to round
g attrit_20102011=(_merge==1) if _merge!=2 & _merge!=.
g attrit_20112012=(_merge2==1) if _merge2!=2 & _merge2!=. & _merge!=1 & _merge!=.
g attrit_20122013=(_merge3==1) if _merge3!=2 & _merge3!=. & _merge2!=1 & _merge2!=.

/*I will not use hhbus_2-_4 to improve coding of survival in cases in which it is
 missing, since it is already coded adequately:
Example for round1-round2:
If survival2_2 is missing:
- in the majority of cases there is no information on business closure, so I don't
	know if the business is still operating or has been closed (this includes observations
	which were only in the hh dataset and not in the firm dataset, although they should appear
	in the firm dataset, given that hhbus_1 was 1 there)
- in a few cases, information is given on closure but the enterprise is a "new one",
	so I don't know if the information refers to the old business
In sum, either the business reported in round 2 is
- a new business and so I do not know what happened to the business from round 1
- an original business but there information on closure/operation is missing
- missing information either because of a missing value for the variable or because there is no
	observation for this household in the firm dataset
see:	
tab survival2_2 if hhbus_1==1 & nonfarm_1==1 & attrit_20102011==0, m
tab hhbus_2 if survival2_2==. & hhbus_1==1 & nonfarm_1==1 & attrit_20102011==0,m
list hhbus_2 entid_1 s9q1b_2 s9q2_2 s9q3_2 if survival2_2==. & hhbus_1==1 & nonfarm_1==1 & attrit_20102011==0
 */
 
*-> One year survival stays the same

/*But given that sometimes the sector of the business given in the subsequent round 
	changes, although it is said to be an original one, I replace survival in these cases.*/
	
replace survival2_2=. if sector_1!=sector_2
replace survival2_3=. if sector_2!=sector_3
replace survival2_4=. if sector_3!=sector_4


*Attrition over 1.5 years (18 months)
g attrit_20102012=(_merge2==1) if _merge2!=2 & _merge2!=. & _merge!=2 & _merge!=.
g attrit_20112013=(_merge3==1) if _merge3!=2 & _merge3!=. & _merge2!=2 & _merge2!=. & _merge!=1 & _merge!=.


*Survival over two years
*(Survival can only be computed over two years, using information from previous year's round)
*2010 to 2012
*Survival_2yrs=1 if hhbus_1==1 & business reported in round 2 is original business & business reported in round 3 is same as in round 2 & survival2_3==1
g survival_20102012=1 if hhbus_1==1 & s9q1b_2==entid_1 & entid_1!=. & s9q1b_2!=. & s6q1b_3==entid_2 & entid_2!=. & s6q1b_3!=. & survival2_3==1 & sector_1==sector_3
*Survival_2yrs=0 if hhbus_1==1 & business reported in round 2 is original business & business reported in round 3 is same as in round 2 & survival2_3==0
replace survival_20102012=0 if hhbus_1==1 & s9q1b_2==entid_1 & entid_1!=. & s9q1b_2!=. & s6q1b_3==entid_2 & entid_2!=. & s6q1b_3!=. & survival2_3==0 & sector_1==sector_3
*If it is a new activity in round 3 and in round 2 it has been closed, I code two year survival as zero:
*(If the business was operating in round 2 and a new activity is reported in round 3, I cannot know if the business survived.
replace survival_20102012=0 if hhbus_1==1 & s9q1b_2==entid_1 & entid_1!=. & s9q1b_2!=. & survival2_2==0 & s6q2_3==2 & sector_1==sector_2
*If in round 2 the business has been closed, and in round 3 there is no business reported, I code two year survival as zero:
replace survival_20102012=0 if hhbus_1==1 & s9q1b_2==entid_1 & entid_1!=. & s9q1b_2!=. & survival2_2==0 & hhbus_3==0 & sector_1==sector_2


*2011 to 2013
g survival_20112013=1 if hhbus_2==1 & s6q1b_3==entid_2 & entid_2!=. & s6q1b_3!=. & s9q1c_4==entid_3 & entid_3!=. & s9q1c_4!=. & survival2_4==1 & sector_2==sector_4
replace survival_20112013=0 if hhbus_2==1 & s6q1b_3==entid_2 & entid_2!=. & s6q1b_3!=. & s9q1c_4==entid_3 & entid_3!=. & s9q1c_4!=. & survival2_4==0 & sector_2==sector_4
replace survival_20112013=0 if hhbus_2==1 & s6q1b_3==entid_2 & entid_2!=. & s6q1b_3!=. & survival2_3==0 & s9q2_4==2 & sector_2==sector_3
replace survival_20112013=0 if hhbus_2==1 & s6q1b_3==entid_2 & entid_2!=. & s6q1b_3!=. & survival2_3==0 & hhbus_4==0 & sector_2==sector_3


*What I did not do (because additional gain not so clear, given that few information is available and start dates are missing later on): link round t and round t+2 through sector or owners in case round t+1 information is missing

*New firm start over two years
*No change is needed. Just compute it over two years


*Attrition over 2.5 years
g attrit_20102013=(_merge3==1) if _merge3!=2 & _merge3!=. & _merge2!=2 & _merge2!=. & _merge!=2 & _merge!=.


*Survival over 2.5 years
*2010 to 2013
g survival_20102013=1 if hhbus_1==1 & s9q1b_2==entid_1 & entid_1!=. & s9q1b_2!=. & s6q1b_3==entid_2 & entid_2!=. & s6q1b_3!=. & s9q1c_4==entid_3 & entid_3!=. & s9q1c_4!=. & survival2_4==1 & sector_1==sector_4
replace survival_20102013=0 if hhbus_1==1 & s9q1b_2==entid_1 & entid_1!=. & s9q1b_2!=. & s6q1b_3==entid_2 & entid_2!=. & s6q1b_3!=. & s9q1c_4==entid_3 & entid_3!=. & s9q1c_4!=. & survival2_4==0 & sector_1==sector_4
replace survival_20102013=0 if hhbus_1==1 & s9q1b_2==entid_1 & entid_1!=. & s9q1b_2!=. & s6q1b_3==entid_2 & entid_2!=. & s6q1b_3!=. & survival2_3==0 & (s9q2_4==2 | hhbus_4==0) & sector_1==sector_3
replace survival_20102013=0 if hhbus_1==1 & s9q1b_2==entid_1 & entid_1!=. & s9q1b_2!=. & survival2_2==0 & (s6q2_3==2 | hhbus_3==0) & (hhbus_4==0 | s9q2_4==2 | (s9q1c_4==entid_3 & entid_3!=. & s9q1c_4!=. & sector_3==sector_4)) & sector_1==sector_2


*Identify the business owners:
*In case the business reported is not jointly owned / operated
g hlp1=1 if (indiv==businessowner1_1 | indiv==businessowner2_1 | indiv== businessowner1_2 | indiv==businessowner2_2 | indiv==businessowner1_3 | indiv==businessowner2_3 | indiv==businessowner1_4 | indiv==businessowner2_4) & jointbus_1!=1 & jointbus_2!=1 & jointbus_3!=1 & jointbus_4!=1
 
duplicates tag hhid hlp1 if hlp1==1, gen(hlp2) 

*For unique cases 
g incl=(hlp2==0)


*Create a variable for inclusion of jointly operated businesses and businesses with different owners in different rounds:
*Decide on owner if business is a joint business
*If owner is manager and respondent
g help_1=((indiv==businessowner1_1 & manager1_1==1 & respbus_1==indiv) | (indiv==businessowner2_1 & manager2_1==1 & respbus_1==indiv)) if (jointbus_1==1 | (hlp2!=0 & hlp2!=.)) & hhbus_1==1 & indiv!=.
g help_2=((indiv==businessowner1_2 & manager1_2==1 & respbus_2==indiv) | (indiv==businessowner2_2 & manager2_2==1 & respbus_2==indiv)) if (jointbus_2==1 | (hlp2!=0 & hlp2!=.)) & hhbus_2==1 & indiv!=.
g help_3=((indiv==businessowner1_3 & manager1_3==1 & respbus_3==indiv) | (indiv==businessowner2_3 & manager2_3==1 & respbus_3==indiv)) if (jointbus_3==1 | (hlp2!=0 & hlp2!=.)) & hhbus_3==1 & indiv!=.
g help_4=((indiv==businessowner1_4 & manager1_4==1 & respbus_4==indiv) | (indiv==businessowner2_4 & manager2_4==1 & respbus_4==indiv)) if (jointbus_4==1 | (hlp2!=0 & hlp2!=.)) & hhbus_4==1 & indiv!=.

*If the respondent is a neither a businessowner nor a manager and respondent's and businessowner' (and manager's) ids not equal to zero, choose the individual who is the businessowner and manager
replace help_1=1 if ((indiv==businessowner1_1 & manager1_1==1) | (indiv==businessowner2_1 & manager2_1==1)) & ((respbus_1!=businessowner1_1 & respbus_1!=businessowner2_1) | respbus_1==0) & (jointbus_1==1 | (hlp2!=0 & hlp2!=.)) & hhbus_1==1 & indiv!=.
replace help_2=1 if ((indiv==businessowner1_2 & manager1_2==1) | (indiv==businessowner2_2 & manager2_2==1)) & ((respbus_2!=businessowner1_2 & respbus_2!=businessowner2_2) | respbus_2==0) & (jointbus_2==1 | (hlp2!=0 & hlp2!=.)) & hhbus_2==1 & indiv!=.
replace help_3=1 if ((indiv==businessowner1_3 & manager1_3==1) | (indiv==businessowner2_3 & manager2_3==1)) & ((respbus_3!=businessowner1_3 & respbus_3!=businessowner2_3) | respbus_3==0) & (jointbus_3==1 | (hlp2!=0 & hlp2!=.)) & hhbus_3==1 & indiv!=.
replace help_4=1 if ((indiv==businessowner1_4 & manager1_4==1) | (indiv==businessowner2_4 & manager2_4==1)) & ((respbus_4!=businessowner1_4 & respbus_4!=businessowner2_4) | respbus_4==0) & (jointbus_4==1 | (hlp2!=0 & hlp2!=.)) & hhbus_4==1 & indiv!=.

*If no information on manager or no one is identified as the manager, choose the individual who is businessowner and reporting:
replace help_1=1 if ((indiv==businessowner1_1 & respbus_1==indiv) | (indiv==businessowner2_1 & respbus_1==indiv)) & ((manager1_1==0 | manager1_1==.) & (manager2_1==0 | manager2_1==.)) & (jointbus_1==1 | (hlp2!=0 & hlp2!=.)) & hhbus_1==1 & indiv!=.
replace help_2=1 if ((indiv==businessowner1_2 & respbus_2==indiv) | (indiv==businessowner2_2 & respbus_2==indiv)) & ((manager1_2==0 | manager1_2==.) & (manager2_2==0 | manager2_2==.)) & (jointbus_2==1 | (hlp2!=0 & hlp2!=.)) & hhbus_2==1 & indiv!=.
replace help_3=1 if ((indiv==businessowner1_3 & respbus_3==indiv) | (indiv==businessowner2_3 & respbus_3==indiv)) & ((manager1_3==0 | manager1_3==.) & (manager2_3==0 | manager2_3==.)) & (jointbus_3==1 | (hlp2!=0 & hlp2!=.)) & hhbus_3==1 & indiv!=.
replace help_4=1 if ((indiv==businessowner1_4 & respbus_4==indiv) | (indiv==businessowner2_4 & respbus_4==indiv)) & ((manager1_4==0 | manager1_4==.) & (manager2_4==0 | manager2_4==.)) & (jointbus_4==1 | (hlp2!=0 & hlp2!=.)) & hhbus_4==1 & indiv!=.

*If no information on manager and respondent, I choose the individual who is the businessowner:
replace help_1=1 if (indiv==businessowner1_1 | indiv==businessowner2_1) & ((manager1_1==0 | manager1_1==.) & (manager2_1==0 | manager2_1==.) ) & ((respbus_1!=businessowner1_1 | respbus_1==.) & (respbus_1!=businessowner2_1 | respbus_1==.)) & (jointbus_1==1 | (hlp2!=0 & hlp2!=.)) & hhbus_1==1 & indiv!=.
replace help_2=1 if (indiv==businessowner1_2 | indiv==businessowner2_2) & ((manager1_2==0 | manager1_2==.) & (manager2_2==0 | manager2_2==.) ) & ((respbus_2!=businessowner1_2 | respbus_2==.) & (respbus_2!=businessowner2_2 | respbus_2==.)) & (jointbus_2==1 | (hlp2!=0 & hlp2!=.)) & hhbus_2==1 & indiv!=.
replace help_3=1 if (indiv==businessowner1_3 | indiv==businessowner2_3) & ((manager1_3==0 | manager1_3==.) & (manager2_3==0 | manager2_3==.) ) & ((respbus_3!=businessowner1_3 | respbus_3==.) & (respbus_3!=businessowner2_3 | respbus_3==.)) & (jointbus_3==1 | (hlp2!=0 & hlp2!=.)) & hhbus_3==1 & indiv!=.
replace help_4=1 if (indiv==businessowner1_4 | indiv==businessowner2_4) & ((manager1_4==0 | manager1_4==.) & (manager2_4==0 | manager2_4==.) ) & ((respbus_4!=businessowner1_4 | respbus_4==.) & (respbus_4!=businessowner2_4 | respbus_4==.)) & (jointbus_4==1 | (hlp2!=0 & hlp2!=.)) & hhbus_4==1 & indiv!=.

*If no information is given at all on businessowner, manager, and respondent, choose the household head as businessowner.
*(The household head will always be the individual with the line number 1, i.e. person listed in the first row)
replace help_1=1 if businessowner1_1==. & businessowner2_1==. & manager1_1==. & manager2_1==. & respbus_1==. & indiv==1 & (jointbus_1==1 | (hlp2!=0 & hlp2!=.)) & hhbus_1==1 & indiv!=.
replace help_2=1 if businessowner1_2==. & businessowner2_2==. & manager1_2==. & manager2_2==. & respbus_2==. & indiv==1 & (jointbus_2==1 | (hlp2!=0 & hlp2!=.)) & hhbus_2==1 & indiv!=.
replace help_3=1 if businessowner1_3==. & businessowner2_3==. & manager1_3==. & manager2_3==. & respbus_3==. & indiv==1 & (jointbus_3==1 | (hlp2!=0 & hlp2!=.)) & hhbus_3==1 & indiv!=.
replace help_4=1 if businessowner1_4==. & businessowner2_4==. & manager1_4==. & manager2_4==. & respbus_4==. & indiv==1 & (jointbus_4==1 | (hlp2!=0 & hlp2!=.)) & hhbus_4==1 & indiv!=.

*If one owner is manager but not respondent, and the other is respondent but not manager, I choose the one who is the manager
replace help_1=1 if ((indiv==businessowner1_1 & manager1_1==1 & respbus_1!=indiv & manager2_1!=1) | (indiv==businessowner2_1 & manager2_1==1 & respbus_1!=indiv & manager1_1!=1)) & (jointbus_1==1 | (hlp2!=0 & hlp2!=.)) & hhbus_1==1 & indiv!=.
replace help_2=1 if ((indiv==businessowner1_2 & manager1_2==1 & respbus_2!=indiv & manager2_2!=1) | (indiv==businessowner2_2 & manager2_2==1 & respbus_2!=indiv & manager1_2!=1)) & (jointbus_2==1 | (hlp2!=0 & hlp2!=.)) & hhbus_2==1 & indiv!=.
replace help_3=1 if ((indiv==businessowner1_3 & manager1_3==1 & respbus_3!=indiv & manager2_3!=1) | (indiv==businessowner2_3 & manager2_3==1 & respbus_3!=indiv & manager1_3!=1)) & (jointbus_3==1 | (hlp2!=0 & hlp2!=.)) & hhbus_3==1 & indiv!=.
replace help_4=1 if ((indiv==businessowner1_4 & manager1_4==1 & respbus_4!=indiv & manager2_4!=1) | (indiv==businessowner2_4 & manager2_4==1 & respbus_4!=indiv & manager1_4!=1)) & (jointbus_4==1 | (hlp2!=0 & hlp2!=.)) & hhbus_4==1 & indiv!=.


keep if morethanonefirm_1!=1 & morethanonefirm2_2!=1 & morethanonefirm2_3!=1 & morethanonefirm2_4!=1 
*keep if incl==1

*TO DO: decide whether you need/want to change path for saving NGLSMSISA_master
/**/
save NGLSMSISA_master,replace
/**/

*For the combined analysis

*RESHAPE:

g status_2=s9q3_2
g status_3=s6q3_3 
g status_4=s9q3_4

g hhbusclosure_2=(status_2!=1) if status_2!=. 
g hhbusclosure_3=(status_3!=1) if status_3!=.
g hhbusclosure_4=(status_4!=1) if status_4!=.

g sectorofbusclosed_2=sector_2 if hhbusclosure_2==1
g sectorofbusclosed_3=sector_3 if hhbusclosure_3==1
g sectorofbusclosed_4=sector_4 if hhbusclosure_4==1

g newfirmquex_2=(s9q2_2==2) if s9q2_2!=.
g newfirmquex_3=(s6q2_3==2) if s6q2_3!=.
g newfirmquex_4=(s9q2_4==2) if s9q2_4!=.
  
  
forvalues i=1/4{
rename help_`i' businessowner_`i'
}

*I generate this variable to be able to look at the contemporaneous correlation between illness of the family and closure, given that closure will be coded up and I drop observations for closed businesses

g familyilltplus1_1=familyill_2
g familyilltplus1_3=familyill_4

drop _merge* s6q4a_1 s6q4b_1 s9q1b_2-s9q3_2 s9q6a_2-s9q8b_2 s6q1b_3 s6q2_3 s6q3_3 s6q6a_3-s6q9b_3 s9q1c_4 s9q2_4 s9q3_4 s9q5b1_4-s9q8b_4 hlp2 entid* ill*

replace country="Nigeria" if country==""

quietly: reshape long wave_ surveyyear_ ownerage_ female_ childunder5_ childaged5to12_ adult65andover_ married_ pcexpend_ excrate_ excratemonth_ ownertertiary_ educyears_ selfemployed_ hours_ wageworker_ laborincome_ retired_ hhbus_ urban_ nonfarm_ retail_ manuf_ services_ othersector_ sector_ agefirm_ capitalstock_ inventories_ employees_ sales_ expenses_ profits_ morethanonefirm_ jointbus_ dead_ familyill_ familyilltplus1_ status_ newfirmquex_, i(hhid indiv) j(survey)

foreach x in wave surveyyear ownerage female childunder5 childaged5to12 adult65andover married pcexpend excrate excratemonth ownertertiary educyears selfemployed hours wageworker laborincome retired hhbus urban nonfarm retail manuf services othersector sector agefirm capitalstock inventories employees sales expenses profits morethanonefirm jointbus dead familyill familyilltplus1 status newfirmquex{
rename `x'_ `x'
}


set more off
*Generate a variable that gives the reason for closure for the business that has been closed
*(Given that this question is only asked in the subsequent round, I need to code it back to the round in which the business that will be closed, is reported)
g hhbusclosure=.
g sectorofbusclosed=.

forvalues i=2/4{
local j=`i'-1
replace hhbusclosure=hhbusclosure_`i' if survey==`j'
replace sectorofbusclosed=sectorofbusclosed_`i' if survey==`j'
drop hhbusclosure_`i' sectorofbusclosed_`i'
}


g reasonforclosure=.
g otherreasonforclosure=""
forvalues i=2/4{
local j=`i'-1
replace reasonforclosure=reasonforclosure_`i' if survey==`j'
replace otherreasonforclosure=otherreasonforclosure_`i' if survey==`j'
drop reasonforclosure_`i'
}

*Given that in TTHAI reasonforclosure is string and not coded, I have to rename this variable here

rename reasonforclosure reasonforclosureNG
rename otherreasonforclosure otherreasonforclosureNG

*businessowner1_ manager1_ businessowner2_ manager2_ respbus_1 
			
*keep if household operates a business in any round
keep if hhbus==1 & nonfarm==1

*Drop if household operates more than one business in any of the rounds
*already done before
*So I don't need these vars:
drop morethanonefirm*

*Keep the businessowners:
*Given that businessowner_* only have values if incl==0 and only if in that period the hh operated a joint business but this can be different over periods:
g newhlp1=1 if (indiv==businessowner1_1 | indiv==businessowner2_1) & jointbus!=1 & surveyyear==2010
replace newhlp1=1 if (indiv==businessowner1_2 | indiv==businessowner2_2) & jointbus!=1 & surveyyear==2011
replace newhlp1=1 if (indiv==businessowner1_3 | indiv==businessowner2_3) & jointbus!=1 & surveyyear==2012
replace newhlp1=1 if (indiv==businessowner1_4 | indiv==businessowner2_4) & jointbus!=1 & surveyyear==2013
replace newhlp1=0 if newhlp1==.
bysort hhid indiv: egen maxnewhlp1=max(newhlp1)

keep if businessowner_1==1 | businessowner_2==1 | businessowner_3==1 | businessowner_4==1 | incl==1 | maxnewhlp1==1
*I keep obs. if indiv is either businessowner or respondent in one wave, given that there are very few obs. which don't have resp. nor manager but resp.
/*looks like this has also been done already
keep if businessowner1_1==indiv | businessowner2_1==indiv | respbus_1==indiv ///
		| businessowner1_2==indiv | businessowner2_2==indiv | respbus_2==indiv /// 
		| businessowner1_3==indiv | businessowner2_3==indiv | respbus_3==indiv ///			
		| businessowner1_4==indiv | businessowner2_4==indiv | respbus_4==indiv 		
*/
			
rename survival2_2 survival_20102011
rename survival2_3 survival_20112012
rename survival2_4 survival_20122013


*For two years and 2.5 years there are inconsistencies in survival and newfirmstarted, although not many (5-7% of obs.)
*reason: creation of a new firm without providing information on what happened to the old firm that was operating in the previous round
*I correct them, coding survival as missing in that case as I cannot be sure what happened to the firm reported before the new one opened (this is how I did it and it made sense for the Thai data, but here it might actually be okay too to code survival as 0):

foreach k in 2 3{
local j=`k'+2008
local x=`k'+2+2008
replace survival_`j'`x'=. if survival_`j'`x'==1 & newfirmstarted_`k'==1
}
replace survival_20102013=. if survival_20102013==1 & newfirmstarted_2==1 | newfirmstarted_3==1


*Period = 6 months

g attrit_6mths=.
g survival_6mths=.
g newfirmstarted_6mths=.


foreach i in 1 3{
local k=`i'+1
local j=`i'+1+2009
local i=`i'+2009
replace attrit_6mths=attrit_`i'`j' if surveyyear==`i'
replace survival_6mths=survival_`i'`j'  if surveyyear==`i'
replace newfirmstarted_6mths=newfirmstarted_`k'  if surveyyear==`i'

}

*Period = 18 months

g attrit_18mths=attrit_20112012  if surveyyear==2011
g survival_18mths=survival_20112012  if surveyyear==2011
g newfirmstarted_18mths=newfirmstarted_3 if surveyyear==2011


*Period = 2 years

g attrit_2yrs=.
g survival_2yrs=.
g newfirmstarted_2yrs=.


foreach i in 1 2{
local k=`i'+2
local l=`i'+1
local m=`i'+1+2009
local j=`i'+2+2009
local i=`i'+2009
replace attrit_2yrs=attrit_`i'`j' if surveyyear==`i'
replace survival_2yrs=survival_`i'`j'  if surveyyear==`i'
replace newfirmstarted_2yrs=newfirmstarted_`k' if surveyyear==`i' /*& survival_`i'`m'==1 newfirmstarted_`l'!=1 */ 
*For newfirmstarted I also use the information on newfirmstarted from the period in between, conditional on the new firm surviving to the respective follow-up round
replace newfirmstarted_2yrs=newfirmstarted_`l' if survival_`m'`j'==1 & surveyyear==`i'

}

*Period = 2.5 years / 30 months
g attrit_30mths=attrit_20102013  if surveyyear==2010
g survival_30mths=survival_20102013  if surveyyear==2010
g newfirmstarted_30mths=newfirmstarted_4 if surveyyear==2010 /*(survival_20102012==1 | (survival_20102011==1 & survival_20112012==1)) newfirmstarted_3!=1 & newfirmstarted_2!=1 */
*For newfirmstarted I also use the information on newfirmstarted from the periods in between, conditional on the new firm surviving to 2013
replace newfirmstarted_30mths=newfirmstarted_3 if survival_20122013==1 & surveyyear==2010 & newfirmstarted_2!=1 
replace newfirmstarted_30mths=newfirmstarted_2 if (survival_20112013==1 | (survival_20112012==1 & survival_20122013==1)) & surveyyear==2010


*There remain 8 obs. with missings in newfirmstarted over 2 yrs and over 2.5 yrs - 
*reason: missings in hhbus status and original/new firm in one round
*I change them to newfirmstarted=0 too since only in that case the coding for the subsequent periods makes sense too and it seems reasonable from looking at the data for that round that the firms reported after survey _2 (where the 8 missings appear) are the sames as reported in period _1
*I also code newfirmstarted from _1 to _2 as 0 in these cases

foreach x in 2yrs 30mths{
replace newfirmstarted_`x'=0 if newfirmstarted_`x'==. & survival_`x' == 1
replace newfirmstarted_6mths=0 if newfirmstarted_`x'==. & survival_`x' == 1 & surveyyear==2010
}

sort hhid surveyyear
bysort hhid: egen help1=min(surveyyear)
order surveyyear help1, after(survey)
g help21=surveyyear-help1
order help21, after(help1)

g help1_1=newfirmstarted_6mths if help21==0 & surveyyear==2010
replace help1_1=newfirmstarted_18mths if help21==0 & surveyyear==2011
replace help1_1=newfirmstarted_6mths if help21==0 & surveyyear==2012


g help1_2=newfirmstarted_2yrs if help21==0 & surveyyear==2010 | surveyyear==2011

g help1_3=newfirmstarted_30mths if help21==0 & surveyyear==2010


forvalues i=1/3{
bysort hhid: egen help21_`i'=total(help1_`i'), m
}

g sameaszero1=1 if help21==0
forvalues i=1/3{
replace sameaszero1=1 if help21==`i' & help21_`i'==0
replace sameaszero1=0 if help21==`i' & help21_`i'>=1 & help21_`i'!=.
}

forvalues i=2/3{
local j=`i'-1
sort hhid surveyyear
bysort hhid: egen help`i'=min(surveyyear) if help2`j'!=0 & help2`j'!=.
g help2`i'=surveyyear-help`i'
}

g help2_1=newfirmstarted_18mths if help22==0 & surveyyear==2011
replace help2_1=newfirmstarted_6mths if help22==0 & surveyyear==2012

g help3_1=newfirmstarted_6mths if help23==0 & surveyyear==2012

g help2_2=newfirmstarted_2yrs if help22==0 & surveyyear==2011

g help3_2=.
g help2_3=.
g help3_3=.

forvalues i=2/3{
forvalues k=1/3{
bysort hhid: egen help2`i'_`k'=total(help`i'_`k'), m
}
}
forvalues i=2/3{
g sameaszero`i'=1 if help2`i'==0
forvalues k=1/3{
replace sameaszero`i'=1 if help2`i'==`k' & help2`i'_`k'==0
replace sameaszero`i'=0 if help2`i'==`k' & help2`i'_`k'>=1 & help2`i'_`k'!=.
}
}


forvalues i=1/3{
replace sameaszero`i'=1 if hhid==280047 & surveyyear==2013
}

*Check for inconsistencies:
*The inconsistency for hhid=360054 is due to a sector change -> I have to recode sameaszero manually for the id

g period_1=1 if help21==0
forvalues i=2/3{
g period_`i'=`i' if help2`i'==0
}

g period_4=4 if surveyyear==2013 & period_1==. & period_2==. & period_3==.

egen period=rowtotal(period_1-period_4),m
order period, after(indiv)
bysort hhid: egen maxperiod=max(period)
order maxperiod, after(period)

*For decision on inclusion of owners if businesses are jointly operated
drop incl
duplicates tag hhid surveyyear, gen(dupl)
bysort hhid: egen totaldupl=total(dupl)
g incl=1 if totaldupl==0


*In case survival and newfirm have both missings
egen helpcheck=rowmiss(sameaszero1)
bysort hhid: egen helpcheck2=total(helpcheck)
g check=(helpcheck2>0 & helpcheck2!=.)
drop helpcheck helpcheck2
forvalues i=2/3{
egen helpcheck=rowmiss(sameaszero`i') if period>=`i'
bysort hhid: egen helpcheck2=total(helpcheck) if period>=`i'
replace check=1 if helpcheck2>0 & helpcheck2!=. & period>=`i'
drop helpcheck helpcheck2
}

*-> no missings in sameaszero1, sameaszero2 and sameaszero3


*In case there is a switch from being same firm to different and then to same firm again
forvalues i=1/3{
bysort hhid: egen helpcheck=total(sameaszero`i'/(dupl+1))
g helpcheck2_`i'=1 if sameaszero`i'==0 & helpcheck>=(period-`i'+1)
drop helpcheck
}
egen rthelpcheck2=rowtotal(helpcheck2_1-helpcheck2_3),m
order rthelpcheck2, after(maxperiod)

tab rthelpcheck2
egen rthelpcheck3=anymatch(rthelpcheck2), values(1 2)
order rthelpcheck3, after(rthelpcheck2)

bysort hhid:egen rthelpcheck4=max(rthelpcheck3)
order rthelpcheck4, after(rthelpcheck3)

replace check=1 if rthelpcheck4==1

drop rthelpcheck* helpcheck2*


bysort hhid: egen totalnfqux=total(newfirmquex)
bysort hhid: egen mdevsector=mdev(sector)
bysort hhid: egen totalmdevsector=total(mdevsector)
replace totalnfqux=(totalnfqux>0)
replace totalmdevsector=(totalmdevsector>0)

*TO DO: decide whether you need/want to change path for saving NGLSMSISA_masterfc
/**/
save NGLSMSISA_masterfc,replace
/**/

*Sector changes are driving these inconsistencies

*Check the owners! 
*keep if totalnfqux==1 & totalmdevsector==1 & check==1
order hhid indiv surveyyear sector businessowner_1 businessowner_2 businessowner_3 businessowner_4 sameaszero1 sameaszero2 sameaszero3 
order hhbusclosure newfirmquex, before(surveyyear)
order survival_6mths newfirmstarted_6mths survival_18mths newfirmstarted_18mths survival_2yrs newfirmstarted_2yrs survival_30mths newfirmstarted_30mths, after(sameaszero3)
sort hhid surveyyear indiv

*hhid=20014 - different owners but owner and sector are consistent -> two different firms
local hhid=20014
forvalues i=1/2{
replace sameaszero`i'=0 if hhid==`hhid' & surveyyear==2013
}

*hhid=30146 - owner stays the same throughout sector change -> I code it as the same firm and since firm is not reported to have closed or newly created, I also code survival=1
local hhid=30146
replace sameaszero1=1 if hhid==`hhid' & surveyyear>=2012 & sameaszero1==0

replace survival_6mths=1 if surveyyear==2012 & hhid==`hhid'
replace newfirmstarted_30mths=1 if surveyyear==2010 & hhid==`hhid'


*hhid=80077 - firm in 2011 is closed, and given that sector in 2013 is different and indiv is only bo through resp_4, I code it as a different firm
local hhid=80077
replace sameaszero1=0 if hhid==`hhid' & surveyyear==2013

*I don't code survival_18mths starting from 2011 to 2012 as zero since it probably has missing because the sector reported in 2012 did not coincide with the one reported in 2011

*hhid=100020 - same firm given that bo stays the same and no firm closure or newfirm reported
local hhid=100020
replace sameaszero1=0 if hhid==`hhid' & surveyyear==2013

replace survival_6mths=1 if surveyyear==2012 & hhid==`hhid'
replace newfirmstarted_30mths=1 if surveyyear==2010 & hhid==`hhid'

*hhid=140057 - same firm given that bo stays the same and no firm closure or newfirm reported
local hhid=140057
replace sameaszero1=0 if hhid==`hhid' & surveyyear==2013

replace survival_2yrs=1 if surveyyear==2011 & hhid==`hhid'
replace survival_6mths=1 if surveyyear==2012 & hhid==`hhid'

replace newfirmstarted_30mths=1 if surveyyear==2010 & hhid==`hhid'

*hhid=170099 - owner stays the same throughout sector change -> I code it as the same firm and since firm is not reported to have closed or newly created, I also code survival=1
local hhid=170099
replace sameaszero1=0 if hhid==`hhid' & surveyyear>=2012

foreach x in 18mths 2yrs{
replace survival_`x'=1 if surveyyear==2011 & hhid==`hhid'
}

replace newfirmstarted_2yrs=1 if surveyyear==2010 & hhid==`hhid'
replace newfirmstarted_30mths=1 if surveyyear==2010 & hhid==`hhid'

*hhid=200031 - owner stays the same throughout sector change -> I code it as the same firm and since firm is not reported to have closed or newly created, I also code survival=1
local hhid=200031
forvalues i=1/2{
replace sameaszero`i'=0 if hhid==`hhid' & surveyyear==2013
}
replace survival_6mths=1 if surveyyear==2012 & hhid==`hhid'
replace newfirmstarted_30mths=1 if surveyyear==2010 & hhid==`hhid'

*hhid=200164 - owner stays the same throughout sector change -> I code it as the same firm and since firm is not reported to have closed or newly created, I also code survival=1
local hhid=200164
replace sameaszero1=0 if hhid==`hhid' & surveyyear==2013
replace survival_6mths=1 if surveyyear==2012 & hhid==`hhid'
replace newfirmstarted_30mths=1 if surveyyear==2010 & hhid==`hhid'

*hhid=220082 - owner stays the same throughout sector change -> I code it as the same firm and since firm is not reported to have closed or newly created, I also code survival=1
local hhid=220082
replace sameaszero1=0 if hhid==`hhid' & surveyyear>=2012
foreach x in 18mths 2yrs{
replace survival_`x'=1 if surveyyear==2011 & hhid==`hhid'
}
replace newfirmstarted_2yrs=1 if surveyyear==2010 & hhid==`hhid'
replace newfirmstarted_30mths=1 if surveyyear==2010 & hhid==`hhid'

*hhid=220117 - owner stays the same throughout sector change -> I code it as the same firm and since firm is not reported to have closed or newly created, I also code survival=1
local hhid=220117
forvalues i=1/2{
replace sameaszero`i'=0 if hhid==`hhid' & surveyyear==2013
}

replace survival_6mths=1 if surveyyear==2012 & hhid==`hhid'
replace newfirmstarted_30mths=1 if surveyyear==2010 & hhid==`hhid'

*hhid=250001 - owner stays the same throughout sector change -> I code it as the same firm and since firm is not reported to have closed or newly created, I also code survival=1
local hhid=250001
replace sameaszero1=0 if hhid==`hhid' & surveyyear>=2011
replace survival_18mths=1 if surveyyear==2011 & hhid==`hhid'
replace newfirmstarted_2yrs=1 if surveyyear==2011 & hhid==`hhid'

*hhid=250004 - owner stays the same throughout sector change -> I code it as the same firm and since firm is not reported to have closed or newly created, I also code survival=1
local hhid=250004
replace sameaszero1=0 if hhid==`hhid' & surveyyear>=2012
foreach x in 18mths 2yrs{
replace survival_`x'=1 if surveyyear==2011 & hhid==`hhid'
}
replace newfirmstarted_2yrs=1 if surveyyear==2010 & hhid==`hhid'
replace newfirmstarted_30mths=1 if surveyyear==2010 & hhid==`hhid'

*hhid=270041 - owner stays the same throughout sector change -> I code it as the same firm and since firm is not reported to have closed or newly created, I also code survival=1
local hhid=270041
replace sameaszero1=0 if hhid==`hhid' & surveyyear>=2012
foreach x in 18mths 2yrs{
replace survival_`x'=1 if surveyyear==2011 & hhid==`hhid'
}
replace newfirmstarted_2yrs=1 if surveyyear==2010 & hhid==`hhid'
replace newfirmstarted_30mths=1 if surveyyear==2010 & hhid==`hhid'

*hhid=290042 - owner stays the same throughout sector change -> I code it as the same firm and since firm is not reported to have closed or newly created, I also code survival=1
local hhid=290042
forvalues i=1/2{
replace sameaszero`i'=0 if hhid==`hhid' & surveyyear==2013
}

replace survival_6mths=1 if surveyyear==2012 & hhid==`hhid'
replace newfirmstarted_30mths=1 if surveyyear==2010 & hhid==`hhid'

*hhid=290111 - different owners but owner and sector are consistent -> two different firms
local hhid=290111
replace sameaszero1=0 if hhid==`hhid' & surveyyear==2013
replace survival_6mths=1 if surveyyear==2012 & hhid==`hhid'

*hhid=290138 - owner stays the same throughout sector change -> I code it as the same firm and since firm is not reported to have closed or newly created, I also code survival=1
local hhid=290138
replace sameaszero1=0 if hhid==`hhid' & surveyyear>=2012
foreach x in 18mths 2yrs{
replace survival_`x'=1 if surveyyear==2011 & hhid==`hhid'
}
replace newfirmstarted_2yrs=1 if surveyyear==2010 & hhid==`hhid'
replace newfirmstarted_30mths=1 if surveyyear==2010 & hhid==`hhid'

*hhid=330060 - owner stays the same throughout sector change -> I code it as the same firm and since firm is not reported to have closed or newly created, I also code survival=1
local hhid=330060
replace sameaszero1=0 if hhid==`hhid' & surveyyear>=2012
foreach x in 18mths 2yrs{
replace survival_`x'=1 if surveyyear==2011 & hhid==`hhid'
}
replace newfirmstarted_2yrs=1 if surveyyear==2010 & hhid==`hhid'
replace newfirmstarted_30mths=1 if surveyyear==2010 & hhid==`hhid'

*hhid=340015 - two different firms given that owners and sectors differ + the firm is coded as the same from 2012 to 2013 as owner stays the same and no closure or creation of new firm is reported
local hhid=340015
replace sameaszero1=0 if hhid==`hhid' & surveyyear==2013
replace survival_6mths=1 if surveyyear==2012 & hhid==`hhid'
replace newfirmstarted_2yrs=. if surveyyear==2010 & hhid==`hhid'
replace newfirmstarted_30mths=. if surveyyear==2010 & hhid==`hhid'

*hhid=350092 - owner stays the same throughout sector change (actually it might be a coding mistake in sector in 2012) -> I code it as the same firm and since firm is not reported to have closed or newly created, I also code survival=1
local hhid=350092
replace sameaszero1=0 if hhid==`hhid' & surveyyear>=2012
foreach x in 18mths 2yrs{
replace survival_`x'=1 if surveyyear==2011 & hhid==`hhid'
}
replace survival_6mths=1 if surveyyear==2012 & hhid==`hhid'

replace newfirmstarted_2yrs=1 if surveyyear==2010 & hhid==`hhid'
replace newfirmstarted_30mths=1 if surveyyear==2010 & hhid==`hhid'

*hhid=360009 - two different firms given that owners and sectors differ + the firm is coded as the same from 2012 to 2013 as owner stays the same and no closure or creation of new firm is reported
local hhid=360009
forvalues i=1/2{
replace sameaszero`i'=0 if hhid==`hhid' & surveyyear>=2013
}

replace survival_6mths=1 if surveyyear==2012 & hhid==`hhid'
replace newfirmstarted_2yrs=. if (surveyyear==2010 | surveyyear==2011) & hhid==`hhid'
replace newfirmstarted_18mths=. if surveyyear==2011 & hhid==`hhid'
replace newfirmstarted_30mths=. if surveyyear==2010 & hhid==`hhid'

*hhid=360018 - very inconsistent -> I code it as three different businesses
local hhid=360018
replace sameaszero1=0 if hhid==`hhid' & surveyyear>=2011
replace sameaszero2=0 if hhid==`hhid' & surveyyear>=2012
replace newfirmstarted_2yrs=. if (surveyyear==2010 | surveyyear==2011) & hhid==`hhid'
replace newfirmstarted_18mths=. if surveyyear==2011 & hhid==`hhid'
replace newfirmstarted_30mths=. if surveyyear==2010 & hhid==`hhid'

*hhid=360054 - owner stays the same throughout sector change -> I code it as the same firm and since firm is not reported to have closed or newly created, I also code survival=1
local hhid=360054
replace sameaszero1=0 if hhid==`hhid' & surveyyear==2012
replace newfirmstarted_2yrs=1 if surveyyear==2010 & hhid==`hhid'
replace survival_18mths=1 if surveyyear==2011 & hhid==`hhid'

*TO DO: decide whether you need/want to change path for saving NGLSMSISA_masterfc
/**/
save NGLSMSISA_masterfc,replace
/**/

*Check sector changes if no new firm has been created (does not appear as an inconsistency)
*keep if totalnfqux==0 & totalmdevsector==1 

*hhid=10035 -> two different firms 
local hhid=10035
replace sameaszero1=0 if hhid==`hhid' & surveyyear==2012
replace newfirmstarted_18mths=. if surveyyear==2011 & hhid==`hhid'

*hhid=10108 -> two different firms 
local hhid=10108
replace sameaszero1=0 if hhid==`hhid' & surveyyear==2012
replace newfirmstarted_2yrs=. if surveyyear==2010 & hhid==`hhid'

*hhid=20016 -> code as two different firms 
local hhid=20016
replace sameaszero1=0 if hhid==`hhid' & surveyyear==2013

*hhid=20025 -> same firm since no closure or opening reported and owner stays the same throughout sector change 
local hhid=20025
replace survival_18mths=1 if surveyyear==2011 & hhid==`hhid'
replace survival_2yrs=1 if surveyyear==2011 & hhid==`hhid'

*hhid=20050 -> two different firms (firm of 2010 is closed from 2010 to 2011)
local hhid=20050
replace sameaszero1=0 if hhid==`hhid' & surveyyear>=2012

*hhid=20069 -> two different firms (firm of 2010 and 2011 is closed from 2011 to 2012)
local hhid=20069
forvalues i=1/2{
replace sameaszero`i'=0 if hhid==`hhid' & surveyyear==2013
}

*hhid=20080 -> same firm
local hhid=20080
replace survival_30mths=1 if surveyyear==2010 & hhid==`hhid'
replace survival_2yrs=1 if surveyyear==2011 & hhid==`hhid'
replace survival_6mths=1 if surveyyear==2012 & hhid==`hhid'

*hhid=20100 -> same firm
local hhid=20100
replace survival_2yrs=1 if surveyyear==2010 & hhid==`hhid'
replace survival_30mths=1 if surveyyear==2010 & hhid==`hhid'
replace survival_18mths=1 if surveyyear==2011 & hhid==`hhid'
replace survival_2yrs=1 if surveyyear==2011 & hhid==`hhid'

*hhid=20106 -> same firm
local hhid=20106
replace survival_30mths=1 if surveyyear==2010 & hhid==`hhid'
replace survival_2yrs=1 if surveyyear==2011 & hhid==`hhid'
replace survival_6mths=1 if surveyyear==2012 & hhid==`hhid'

*hhid=20110 -> same firm
local hhid=20110
replace survival_30mths=1 if surveyyear==2010 & hhid==`hhid'
replace survival_18mths=1 if surveyyear==2011 & hhid==`hhid'
replace survival_2yrs=1 if (surveyyear==2011 | surveyyear==2010) & hhid==`hhid'
replace survival_6mths=1 if surveyyear==2012 & hhid==`hhid'

*hhid=30018 -> two different firms
local hhid=30018
replace sameaszero1=0 if hhid==`hhid' & surveyyear>=2012

*hhid=30053 -> same firm
local hhid=30053
replace survival_30mths=1 if surveyyear==2010 & hhid==`hhid'
replace survival_2yrs=1 if surveyyear==2011 & hhid==`hhid'
replace survival_6mths=1 if surveyyear==2012 & hhid==`hhid'

*hhid=30083 -> same firm
local hhid=30083
replace survival_2yrs=1 if surveyyear==2010 & hhid==`hhid'
replace survival_18mths=1 if surveyyear==2011 & hhid==`hhid'

*hhid=30090 -> same firm
local hhid=30090
replace survival_30mths=1 if surveyyear==2010 & hhid==`hhid'
replace survival_2yrs=1 if (surveyyear==2010 | surveyyear==2011) & hhid==`hhid'
replace survival_18mths=1 if surveyyear==2011 & hhid==`hhid'

*DO IT GENERALLY:

*Rules:
*If no year gap, owner stays the same and no firm is closed -> same firm 
*-> recode survival

*If no year gap and owner changes and sector changes coincide -> different firms
*-> recode sameaszero, newfirmstarted=.

*If year gap and no closure or closure and bo same or not -> different firms
*-> recode sameaszero, newfirmstarted=.



*Generate dummy for year change
rename help1 minsvy1
bysort hhid: egen minsvy2=max(help2)
bysort hhid: egen minsvy3=max(help3)
bysort hhid: egen maxsvy=max(surveyyear)

g yeargap=.
replace yeargap=0 if maxperiod==4 
replace yeargap=0 if maxperiod==3 & ((minsvy1==2010 & maxsvy==2012) | (minsvy1==2011 & maxsvy==2013))
replace yeargap=0 if maxperiod==2 & ((minsvy1==2010 & maxsvy==2011) | (minsvy1==2011 & maxsvy==2012) | (minsvy1==2012 & maxsvy==2013))
replace yeargap=1 if yeargap!=0 

*Replace businessowner_* for incl=1 cases
egen bomiss=rowtotal(businessowner_1 businessowner_2 businessowner_3 businessowner_4),m
egen bomisshelp=rownonmiss(businessowner_1 businessowner_2 businessowner_3 businessowner_4)
replace bomiss=. if bomisshelp<maxperiod

*If owner is manager and respondent
replace businessowner_1=((indiv==businessowner1_1 & manager1_1==1 & respbus_1==indiv) | (indiv==businessowner2_1 & manager2_1==1 & respbus_1==indiv)) if bomiss==.
replace businessowner_2=((indiv==businessowner1_2 & manager1_2==1 & respbus_2==indiv) | (indiv==businessowner2_2 & manager2_2==1 & respbus_2==indiv)) if bomiss==.
replace businessowner_3=((indiv==businessowner1_3 & manager1_3==1 & respbus_3==indiv) | (indiv==businessowner2_3 & manager2_3==1 & respbus_3==indiv)) if bomiss==.
replace businessowner_4=((indiv==businessowner1_4 & manager1_4==1 & respbus_4==indiv) | (indiv==businessowner2_4 & manager2_4==1 & respbus_4==indiv)) if bomiss==.

*If the respondent is a neither a businessowner nor a manager and respondent's and businessowner' (and manager's) ids not equal to zero, choose the individual who is the businessowner and manager
replace businessowner_1=1 if ((indiv==businessowner1_1 & manager1_1==1) | (indiv==businessowner2_1 & manager2_1==1)) & ((respbus_1!=businessowner1_1 & respbus_1!=businessowner2_1) | respbus_1==0) & bomiss==.
replace businessowner_2=1 if ((indiv==businessowner1_2 & manager1_2==1) | (indiv==businessowner2_2 & manager2_2==1)) & ((respbus_2!=businessowner1_2 & respbus_2!=businessowner2_2) | respbus_2==0) & bomiss==.
replace businessowner_3=1 if ((indiv==businessowner1_3 & manager1_3==1) | (indiv==businessowner2_3 & manager2_3==1)) & ((respbus_3!=businessowner1_3 & respbus_3!=businessowner2_3) | respbus_3==0) & bomiss==.
replace businessowner_4=1 if ((indiv==businessowner1_4 & manager1_4==1) | (indiv==businessowner2_4 & manager2_4==1)) & ((respbus_4!=businessowner1_4 & respbus_4!=businessowner2_4) | respbus_4==0) & bomiss==.

*If no information on manager or no one is identified as the manager, choose the individual who is businessowner and reporting:
replace businessowner_1=1 if ((indiv==businessowner1_1 & respbus_1==indiv) | (indiv==businessowner2_1 & respbus_1==indiv)) & ((manager1_1==0 | manager1_1==.) & (manager2_1==0 | manager2_1==.)) & bomiss==.
replace businessowner_2=1 if ((indiv==businessowner1_2 & respbus_2==indiv) | (indiv==businessowner2_2 & respbus_2==indiv)) & ((manager1_2==0 | manager1_2==.) & (manager2_2==0 | manager2_2==.)) & bomiss==.
replace businessowner_3=1 if ((indiv==businessowner1_3 & respbus_3==indiv) | (indiv==businessowner2_3 & respbus_3==indiv)) & ((manager1_3==0 | manager1_3==.) & (manager2_3==0 | manager2_3==.)) & bomiss==.
replace businessowner_4=1 if ((indiv==businessowner1_4 & respbus_4==indiv) | (indiv==businessowner2_4 & respbus_4==indiv)) & ((manager1_4==0 | manager1_4==.) & (manager2_4==0 | manager2_4==.)) & bomiss==.

*If no information on manager and respondent, I choose the individual who is the businessowner:
replace businessowner_1=1 if (indiv==businessowner1_1 | indiv==businessowner2_1) & ((manager1_1==0 | manager1_1==.) & (manager2_1==0 | manager2_1==.) ) & ((respbus_1!=businessowner1_1 | respbus_1==.) & (respbus_1!=businessowner2_1 | respbus_1==.)) & bomiss==.
replace businessowner_2=1 if (indiv==businessowner1_2 | indiv==businessowner2_2) & ((manager1_2==0 | manager1_2==.) & (manager2_2==0 | manager2_2==.) ) & ((respbus_2!=businessowner1_2 | respbus_2==.) & (respbus_2!=businessowner2_2 | respbus_2==.)) & bomiss==.
replace businessowner_3=1 if (indiv==businessowner1_3 | indiv==businessowner2_3) & ((manager1_3==0 | manager1_3==.) & (manager2_3==0 | manager2_3==.) ) & ((respbus_3!=businessowner1_3 | respbus_3==.) & (respbus_3!=businessowner2_3 | respbus_3==.)) & bomiss==.
replace businessowner_4=1 if (indiv==businessowner1_4 | indiv==businessowner2_4) & ((manager1_4==0 | manager1_4==.) & (manager2_4==0 | manager2_4==.) ) & ((respbus_4!=businessowner1_4 | respbus_4==.) & (respbus_4!=businessowner2_4 | respbus_4==.)) & bomiss==.

*If no information is given at all on businessowner, manager, and respondent, choose the household head as businessowner.
*(The household head will always be the individual with the line number 1, i.e. person listed in the first row)
replace businessowner_1=1 if businessowner1_1==. & businessowner2_1==. & manager1_1==. & manager2_1==. & respbus_1==. & indiv==1 & bomiss==.
replace businessowner_2=1 if businessowner1_2==. & businessowner2_2==. & manager1_2==. & manager2_2==. & respbus_2==. & indiv==1 & bomiss==.
replace businessowner_3=1 if businessowner1_3==. & businessowner2_3==. & manager1_3==. & manager2_3==. & respbus_3==. & indiv==1 & bomiss==.
replace businessowner_4=1 if businessowner1_4==. & businessowner2_4==. & manager1_4==. & manager2_4==. & respbus_4==. & indiv==1 & bomiss==.

*If one owner is manager but not respondent, and the other is respondent but not manager, I choose the one who is the manager
replace businessowner_1=1 if ((indiv==businessowner1_1 & manager1_1==1 & respbus_1!=indiv & manager2_1!=1) | (indiv==businessowner2_1 & manager2_1==1 & respbus_1!=indiv & manager1_1!=1)) & bomiss==.
replace businessowner_2=1 if ((indiv==businessowner1_2 & manager1_2==1 & respbus_2!=indiv & manager2_2!=1) | (indiv==businessowner2_2 & manager2_2==1 & respbus_2!=indiv & manager1_2!=1)) & bomiss==.
replace businessowner_3=1 if ((indiv==businessowner1_3 & manager1_3==1 & respbus_3!=indiv & manager2_3!=1) | (indiv==businessowner2_3 & manager2_3==1 & respbus_3!=indiv & manager1_3!=1)) & bomiss==.
replace businessowner_4=1 if ((indiv==businessowner1_4 & manager1_4==1 & respbus_4!=indiv & manager2_4!=1) | (indiv==businessowner2_4 & manager2_4==1 & respbus_4!=indiv & manager1_4!=1)) & bomiss==.

*If no year gap, owner stays the same and no firm is closed -> same firm 
*-> recode survival
*If 4 periods:
replace survival_30mths=1 if surveyyear==2010 & yeargap==0 & maxperiod==4 & businessowner_1 == businessowner_2 == businessowner_3 == businessowner_4 & totalnfqux==0 & totalmdevsector==1 
replace survival_2yrs=1 if (surveyyear==2010 | surveyyear==2011) & yeargap==0 & maxperiod==4 & businessowner_1 == businessowner_2 == businessowner_3 == businessowner_4 & totalnfqux==0 & totalmdevsector==1 
replace survival_18mths=1 if surveyyear==2011 & yeargap==0 & maxperiod==4 & businessowner_1 == businessowner_2 == businessowner_3 == businessowner_4 & totalnfqux==0 & totalmdevsector==1 
replace survival_6mths=1 if (surveyyear==2010 | surveyyear==2012) & yeargap==0 & maxperiod==4 & businessowner_1 == businessowner_2 == businessowner_3 == businessowner_4 & totalnfqux==0 & totalmdevsector==1 

*If 3 periods:
replace survival_2yrs=1 if surveyyear==2010 & yeargap==0 & maxperiod==3 & minsvy1==2010 & businessowner_1 == businessowner_2 == businessowner_3 & totalnfqux==0 & totalmdevsector==1 
replace survival_18mths=1 if surveyyear==2011 & yeargap==0 & maxperiod==3 & minsvy1==2010  & businessowner_1 == businessowner_2 == businessowner_3 & totalnfqux==0 & totalmdevsector==1 
replace survival_6mths=1 if surveyyear==2010 & yeargap==0 & maxperiod==3 & minsvy1==2010 & businessowner_1 == businessowner_2 == businessowner_3 & totalnfqux==0 & totalmdevsector==1 

replace survival_2yrs=1 if surveyyear==2011 & yeargap==0 & maxperiod==3 & minsvy1==2011 &  businessowner_2 == businessowner_3 == businessowner_4 & totalnfqux==0 & totalmdevsector==1 
replace survival_18mths=1 if surveyyear==2011 & yeargap==0 & maxperiod==3 & minsvy1==2011  & businessowner_2 == businessowner_3 == businessowner_4 & totalnfqux==0 & totalmdevsector==1 
replace survival_6mths=1 if surveyyear==2012 & yeargap==0 & maxperiod==3 & minsvy1==2011 & businessowner_2 == businessowner_3 == businessowner_4 & totalnfqux==0 & totalmdevsector==1 

*If 2 periods:
replace survival_6mths=1 if surveyyear==2010 & yeargap==0 & maxperiod==2 & minsvy1==2010 & businessowner_1 == businessowner_2 & totalnfqux==0 & totalmdevsector==1 

replace survival_18mths=1 if surveyyear==2011 & yeargap==0 & maxperiod==2 & minsvy1==2011  & businessowner_2 == businessowner_3 & totalnfqux==0 & totalmdevsector==1 

replace survival_6mths=1 if surveyyear==2012 & yeargap==0 & maxperiod==2 & minsvy1==2012 & businessowner_3 == businessowner_4 & totalnfqux==0 & totalmdevsector==1 


*If year gap and no closure or closure and bo same or not -> different firms
*-> recode sameaszero, newfirmstarted=.

g difftonext=minsvy2-minsvy1 if period==1
replace difftonext=minsvy3-minsvy2 if period==2 

g stdifftonext="6mths" if difftonext==1 & surveyyear==2010
replace stdifftonext="2yrs" if difftonext==2 & surveyyear==2010
replace stdifftonext="30mths" if difftonext==3 & surveyyear==2010
replace stdifftonext="18mths" if difftonext==1 & surveyyear==2011
replace stdifftonext="2yrs" if difftonext==2 & surveyyear==2011
replace stdifftonext="6mths" if difftonext==1 & surveyyear==2012


count if yeargap==1 & totalnfqux==0 & totalmdevsector==1
tab maxperiod if yeargap==1 &  totalnfqux==0 & totalmdevsector==1

*If maxperiod==2
replace sameaszero1=0 if maxperiod==2 & surveyyear!=minsvy1 & totalnfqux==0 & totalmdevsector==1 & yeargap==1
foreach x in 2yrs 30mths{
replace newfirmstarted_`x'=. if maxperiod==2 & totalnfqux==0 & totalmdevsector==1 & yeargap==1 & period==1 & stdifftonext=="`x'"
}

forvalues i = 1/4{
g sectorhelp`i'=sector if period==`i'
replace sectorhelp`i'=0 if sectorhelp`i'==.
bysort hhid: egen maxsectorhelp`i'=max(sectorhelp`i')
}
g sectorswitch=(maxsectorhelp1!=maxsectorhelp2) if period==2
replace sectorswitch=(maxsectorhelp2!=maxsectorhelp3) if period==3 & maxperiod>2
replace sectorswitch=(maxsectorhelp3!=maxsectorhelp4) if period==4 & maxperiod>3

*If maxperiod==3
g sectorswitchsazhelpin2=(period==2 & sectorswitch==1)
g sectorswitchsazhelpin3=(period==3 & sectorswitch==1)
bysort hhid:egen sssazhelpin2=total(sectorswitchsazhelpin2)
bysort hhid:egen sssazhelpin3=total(sectorswitchsazhelpin3)

forvalues i=2/3{
replace sssazhelpin`i'=1 if sssazhelpin`i'>0 & sssazhelpin`i'!=.
}

replace sameaszero1=0 if maxperiod==3 & surveyyear!=minsvy1 & totalnfqux==0 & totalmdevsector==1 & yeargap==1 & period==2 & sssazhelpin2==1
replace sameaszero1=0 if maxperiod==3 & surveyyear!=minsvy1 & totalnfqux==0 & totalmdevsector==1 & yeargap==1 & period==3 & (sssazhelpin2==1 | sssazhelpin3==1) 
replace sameaszero2=0 if maxperiod==3 & surveyyear!=minsvy1 & totalnfqux==0 & totalmdevsector==1 & yeargap==1 & period==3 & sssazhelpin3==1

foreach x in 6mths 18mths 2yrs 30mths{
replace newfirmstarted_`x'=. if maxperiod==3 & totalnfqux==0 & totalmdevsector==1 & yeargap==1 & period==1 & stdifftonext=="`x'" & sssazhelpin2==1
replace newfirmstarted_`x'=. if maxperiod==3 & totalnfqux==0 & totalmdevsector==1 & yeargap==1 & period==1 & stdifftonext=="`x'" & sssazhelpin3==1
replace newfirmstarted_`x'=. if maxperiod==3 & totalnfqux==0 & totalmdevsector==1 & yeargap==1 & period==2 & stdifftonext=="`x'" & sssazhelpin3==1
}

*If owner changes and sector changes coincide and no year gap -> different firms
*-> recode sameaszero, newfirmstarted=.
g bosame4=(businessowner_1 == businessowner_2 == businessowner_3 == businessowner_4)
g bosame3_2010=(businessowner_1 == businessowner_2 == businessowner_3)
g bosame3_2011=(businessowner_2 == businessowner_3 == businessowner_4)
g bosame2_2010=(businessowner_1 == businessowner_2)
g bosame2_2011=(businessowner_2 == businessowner_3)
g bosame2_2012=(businessowner_3 == businessowner_4)

count if yeargap==0 & totalnfqux==0 & totalmdevsector==1 & maxperiod==4 & bosame4!=1
tab bosame4 if maxperiod==4 & yeargap==0 & totalnfqux==0 & totalmdevsector==1 
count if maxperiod==3 & (bosame3_2010==0 | bosame3_2011==0) & yeargap==0 & totalnfqux==0 & totalmdevsector==1 
count if maxperiod==2 & (bosame2_2010==0 | bosame2_2011==0 | bosame2_2012==0) & yeargap==0 & totalnfqux==0 & totalmdevsector==1 

*Check them manually: 
*4 periods:
list hhid if yeargap==0 & totalnfqux==0 & totalmdevsector==1 & maxperiod==4 & bosame4!=1
*hhid=50101 -> same firm
*hhid=60004 -> same firm
*hhid=170035 -> same firm
*hhid=180108 -> same firm
*hhid=200078 -> same firm
*hhid=210050 -> same firm
*hhid=250017 -> same firm
*hhid=250044 -> same firm
*hhid=260002 -> same firm
*hhid=280050 -> same firm
*hhid=310075 -> different firm
*hhid=320173 -> same firm

foreach x in 50101 60004 170035 180108 200078 210050 250017 250044 260002 280050 320173{
replace survival_30mths=1 if surveyyear==2010 & hhid==`x'
replace survival_2yrs=1 if (surveyyear==2010 | surveyyear==2011) & hhid==`x'
replace survival_18mths=1 if surveyyear==2011 & hhid==`x'
replace survival_6mths=1 if (surveyyear==2010 | surveyyear==2012) & hhid==`x'
}

*hhid=310075 -> two different businesses, one in 2010 and 2011 and the other in 2012 and 2013
local hhid=310075
forvalues i=1/2{
replace sameaszero`i'=0 if hhid==`hhid' & surveyyear>=2012
}

*3 periods:
list hhid if yeargap==0 & totalnfqux==0 & totalmdevsector==1 & maxperiod==3 & bosame3_2010==0 & minsvy1==2010
*hhid=140122 -> different firms
*hhid=340075 -> different firms

list hhid if yeargap==0 & totalnfqux==0 & totalmdevsector==1 & maxperiod==3 & bosame3_2011==0 & minsvy1==2011
*hhid=330075 -> different firms
*hhid=360021 -> different firms

*hhid=140122 -> two different businesses, one in 2010 and 2011 and the other in 2012
local hhid=140122
forvalues i=1/2{
replace sameaszero`i'=0 if hhid==`hhid' & surveyyear==2012
}

*hhid=340075 -> two different businesses, one in 2010 and 2011 and the other in 2012 and 2013
local hhid=340075
forvalues i=1/2{
replace sameaszero`i'=0 if hhid==`hhid' & surveyyear==2012
}

*hhid=330075 -> two different businesses, one in 2011 and the other in 2012 and 2013
local hhid=330075
forvalues i=1/2{
replace sameaszero`i'=0 if hhid==`hhid' & surveyyear>=2012
}
*Somehow survival has been coded positive from 2011 to 2012 and 2013 so I recode it
replace survival_18mths=. if surveyyear==2011 & hhid==`hhid'
replace survival_2yrs=. if surveyyear==2011 & hhid==`hhid'

list hhid if yeargap==0 & totalnfqux==0 & totalmdevsector==1 & maxperiod==2 & bosame2_2010==0 & minsvy1==2010
*none

list hhid if yeargap==0 & totalnfqux==0 & totalmdevsector==1 & maxperiod==2 & bosame2_2011==0 & minsvy1==2011
*hhid=10035 -> different firms (already coded above)

list hhid if yeargap==0 & totalnfqux==0 & totalmdevsector==1 & maxperiod==2 & bosame2_2012==0 & minsvy1==2012
*hhid=340042 -> same business
replace survival_6mths=1 if surveyyear==2012 & hhid==340042 

*hhid=60036 -> different businesses
local hhid=60036
replace sameaszero1=0 if hhid==`hhid' & surveyyear==2012



*For inconsistencies over different time horizons depending on the baseline year but with the follow-up year being constant
*- maxperiod needs to be larger than 2 (for 1 and 2 periods there cannot be inconsistencies with implications for coding of the hhfirm)
forvalues i=1/3{
bysort hhid: egen newhelpcheck`i'=total(sameaszero`i'/(dupl+1))
}
g newhelpcheck=0
forvalues i=3/4{
local j=`i'-1
local k=`i'-2
replace newhelpcheck=1 if newhelpcheck`k'==newhelpcheck`j' & sameaszero`k'<sameaszero`j' & sameaszero`k'!=. & newhelpcheck`k'!=1 & sameaszero`j'!=. & newhelpcheck`j'!=1 & period>=`i'
}
bysort hhid: egen maxnewhelpcheck=max(newhelpcheck)

*Somehow the coding of sameaszero1 in 2012 is incorrect but survival and newfirmstarted are okay
*hhid=60036
*hhid=80102
*hhid=130041 
*hhid=140016
*hhid=200012
*hhid=280042 recode also survial 2 yrs from 2010
foreach x in 60036 80102 130041 140016 200012 280042{
replace sameaszero1=1 if hhid==`x' & surveyyear==2012
}

local hhid=280042
replace survival_2yrs=1 if hhid==`hhid' & surveyyear==2010
replace survival_18mths=1 if hhid==`hhid' & surveyyear==2011

*Different:
*hhid=360009 -> sameaszero1 needs to be 0 for 2012 and sameaszero2 needs to be coded 1 for 2013
local hhid=360009
replace sameaszero1=0 if hhid==`hhid' & surveyyear==2012
replace sameaszero2=1 if hhid==`hhid' & surveyyear==2013




*Generate firmid for the clear cases 
sort hhid surveyyear
egen helphhfirmid1=group(hhid sameaszero1) if sameaszero1==1
forvalues i=2/3{
local j=`i'-1
egen helphhfirmid`i'=group(hhid sameaszero`i') if sameaszero`j'==0 & sameaszero`i'==1
}

egen hhfirmid=group(hhid helphhfirmid1-helphhfirmid3), m
order hhfirmid, after(indiv)

*TO DO: decide whether you need/want to change path for saving NGLSMSISA_masterfc
/**/
save NGLSMSISA_masterfc,replace
/**/

*Now decide on the owner - depending on the years in which the same hhfirmid is reported
keep if incl!=1
keep hhid indiv hhfirmid totaldupl surveyyear businessowner_* 

g hlpsvyear1=surveyyear

reshape wide hlpsvyear1, i(hhid indiv hhfirmid) j(surveyyear)

forvalues i=2010/2013{
local j=`i'-2009
replace hlpsvyear1`i'=(hlpsvyear1`i'!=.)
replace businessowner_`j'=businessowner_`j'*hlpsvyear1`i'
}
egen totalownership=rowtotal(businessowner_1-businessowner_4)
bysort hhfirmid: egen maxtotalownership=max(totalownership)
g hlpincl=(maxtotalownership==totalownership)
duplicates tag hhfirmid hlpincl, gen(duplhlpincl)
g incl=.
*In case there are no duplicates in maximum ownership
replace incl=(hlpincl==1) if duplhlpincl==0
bysort hhfirmid: egen helpinclonemaxo=total(incl)
replace incl=0 if incl==. & helpinclonemaxo==1

*duplicates in terms of owner/person:
duplicates tag hhid indiv, gen(duplperson)


*If person only appears once, chose owner with the lowest hc_id (this will choose the household head if he/she is among the owners)
bysort hhfirmid: egen testincl=total(incl)
bysort hhfirmid: egen totalduplperson=total(duplperson)
sort hhfirmid hhid indiv
bysort hhfirmid: egen minhc_id=min(indiv)
g helpminhc_id=(minhc_id==indiv)
replace incl=(helpminhc_id==1) if duplhlpincl>0 &  duplhlpincl!=. & duplperson==0 & totalduplperson==0 & test!=1
drop test

*If person appears more than once, is already included for another business and is one of the persons with maximum ownership, I choose this owner
bysort hhfirmid: egen testincl=total(incl)
g helpmultfirms=indiv if duplperson>0 & duplperson!=. & incl==1 
*depends on the number included of firms per household
bysort hhid: egen counthelpmultfirms=count(helpmultfirms)
bysort hhid: egen totalhelpmultfirms=total(helpmultfirms) if count==1
replace incl=1 if hlpincl==1 & indiv==totalhelpmultfirms & duplperson>0 & duplperson!=. & incl==. & count==1 & test!=1
drop test

*If there are more than one firm per household included, but maxowner is the same for all of them:
bysort hhfirmid: egen testincl=total(incl)
egen helphelpmultfirms=group(hhid helpmultfirms) if count>1 & count!=.
bysort hhid: egen mdevhelphelpmultfirms=mdev(helphelpmultfirms) if count>1 & count!=.
bysort hhid: egen totalhelpmultfirms2=total(helpmultfirms) if count>1 & count!=. & mdevhelphelpmultfirms==0
replace totalhelpmultfirms2=totalhelpmultfirms2/count if count>1 & count!=. & mdevhelphelpmultfirms==0
replace incl=1 if hlpincl==1 & indiv==totalhelpmultfirms2 & duplperson>0 & duplperson!=. & incl==. & count>1 & count!=1 & test!=1
drop testincl

bysort hhfirmid: egen testincl=total(incl)

*I replace incl=0 if incl=. but testincl==1:
replace incl=0 if incl==. & testincl==1

*Otherwise I choose person with maximum ownership 
replace incl=(hlpincl==1) if duplhlpincl==0 & incl==.

*And if more than one have maximum ownership for the same business, I choose the one with the lowest hc_id
bysort hhfirmid: egen newminhc_id=min(indiv) if incl==.
g newhelpminhc_id=(newminhc_id==indiv) if incl==.
replace incl=(newhelpminhc_id==1) if incl==. 

*I check if all household firms are included:
drop test
bysort hhfirmid: egen testincl=total(incl)

*-> all hhfirmids have one single member that is to be included


keep hhid indiv hhfirmid incl hlpsvyear12010-hlpsvyear12013

reshape long hlpsvyear1, i(hhid indiv hhfirmid) j(surveyyear)
keep if hlpsvyear1==1
drop hlpsvyear1

*TO DO: decide whether you need/want to change path for saving NGLSMSISA_masterfchlp
/**/
save NGLSMSISA_masterfchlp, replace
/**/

*TO DO: change path to where you saved the following file "NGLSMSISA_masterfc.dta"
/*EXAMPLE*/
use NGLSMSISA_masterfc, clear
/**/

*TO DO: change path to where you saved the following file "NGLSMSISA_masterfchlp"
/*EXAMPLE*/
merge 1:1 hhid indiv hhfirmid surveyyear using NGLSMSISA_masterfchlp, update
/**/

*TO DO: decide whether you need/want to change path for saving NGLSMSISA_masterfc
/**/
save NGLSMSISA_masterfc,replace
/**/

*test if for a given household owners change depending on hhfirmid
bysort hhid: egen mdevhc_id=mdev(indiv) if incl==1
tab mdevhc_id
*-> there are about 2% of households in the sample for which firm owners change depending on hhfirmid 
* only in these cases, newfirmstarted might have been calculated imperfectly

keep if incl==1

*Generate owner id, since, if the same owner opens a new firm, that should be accounted for:
egen ownerid=group(hhid indiv)

*Household id: a household appears multiple times with different businesses if the businesses are either new and old ones or if they are different businesses
egen householdid=group(hhid)
forvalues i=1/4{
local j=`i'+2009
replace survey=`j' if survey==`i'
}

tostring survey, replace
replace survey="BL-"+survey if survey=="2010"
replace survey="R-"+survey if survey!="BL-2010" & survey!="2013"
replace survey="L-"+survey if survey=="2013"

g lastround=(surveyyear==2013)


drop businessowner_* sameaszero* period* maxperiod minsvy* businessowner1_* manager1_* businessowner2_* manager2_* respbus_* survival_20102011 newfirmstarted_2 newfirmstarted_3 newfirmstarted_4 otherreasonforclosure_* survival_20112012 survival_20122013 attrit_20102011 attrit_20112012 attrit_20122013 attrit_20102012 attrit_20112013 survival_20102012 survival_20112013 attrit_20102013 survival_20102013 hlp1 newhlp1 maxnewhlp1 totalnfqux mdevsector totalmdevsector yeargap bomiss* difftonext stdifftonext sectorhelp* maxsectorhelp* sectorswitch* sssazhelpin* bosame* newhelpcheck* newhelpcheck maxnewhelpcheck helphhfirmid* _merge mdevhc_id help* dupl totaldupl incl check maxsvy

                                         
*Make the ids look nicer
foreach x of varlist hhfirmid ownerid householdid{
tostring `x', format("%04.0f") replace
replace `x'="NGLSMSISA"+"-"+`x'
}

rename hhfirmid firmid

*If a firm is coded to be dead once, it should be so for all subsequent periods too:
replace survival_2yrs=0 if survival_6mths==0 & survival_2yrs==. & surveyyear==2010
replace survival_30mths=0 if survival_2yrs==0 & survival_30mths==. & surveyyear==2010
replace survival_2yrs=0 if survival_18mths==0 & survival_2yrs==. & surveyyear==2011

*TO DO: Make sure the final dataset "NGLSMSISA_masterfc.dta" is saved in the folder “Do-files and readme/Construction of Dataset/Data for combination”
/**/
save NGLSMSISA_masterfc,replace
/**/
