********************************************************************************

********************************************************************************
**THIS DO-FILE PREPARES THE DATA FROM THE TOWNSEND THAI SURVEY FOR COMBINATION INTO THE MASTER DATASET
**Small Firm Death in Developing Countries
**March 14, 2018
**David McKenzie (dmckenzie@worldbank.org) and Anna Luisa Paffhausen (apaffhausen@worldbank.org)
**The analysis was performed with Stata, version 14.2

*Notes:
* The underlying raw data needed to replicate this do-file is available at Harvard Dataverse.
* To replicate this do-file:
* 1) Go to https://dataverse.harvard.edu/dataverse.xhtml?alias=rtownsend
* 2) Download the files contained in the folder Townsend Thai Project Initial Household Survey, 1997 (Robert M. Townsend, 2009, "Townsend Thai Project Initial Household Survey, 1997", hdl:1902.1/10672, Harvard Dataverse, V2, UNF:3:Jd0uzR0AYf9mWWOE0SnK1A==),
*	 and in the folders Townsend Thai Project Household Annual Resurvey, 1998-2014 (from 2008 on urban and rural)
* 3) Change the directory in the do-file 
* 4) Change the paths to the data you are using and for saving the datasets that are created in this do-file
*    Make sure the final dataset (TTHAImasterfc) is saved in the folder “Do-files and readme/Construction of Dataset/Data for combination”

********************************************************************************

********************************************************************************

*TO DO: change directory 
/*EXAMPLE:*/
clear all
cd  "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data"
set more off
/**/

********************************************************************************

********************************************************************************
*Baseline variables
********************************************************************************

********************************************************************************


********************************************************************************
*Owner and Household characteristics
********************************************************************************

*TO DO: change path to where you saved the following file "j05.dta" of the 1997 baseline
/*EXAMPLE:*/
use "Townsend Thai Project/1997/j05.dta"
/**/

*TO DO: change path to where you saved the following file "master.dta" of the 1997 baseline
/*EXAMPLE:*/
merge m:1 newid using "Townsend Thai Project/1997/master.dta", keep(3)
/**/

*Age of owner
g ownerage=hc5

*Gender of owner
g female=(hc4==3) if hc4!=.

*Education of owner
g ownertertiary=(hc7==47 | hc7==49 | hc7==51 | hc7==53) if hc7!=. & hc7!=-999 & hc7!=-888

*Years of education
*I assume the number is the years of education and calculate 6 years for primary and 6 years for secondary
*Sources: 	https://en.wikipedia.org/wiki/Education_in_Thailand
*			http://open_jicareport.jica.go.jp/pdf/11548013.pdf
g educyears=0 if hc7==1
replace educyears=1 if hc7==2
replace educyears=2 if hc7==5
replace educyears=3 if hc7==7
replace educyears=4 if hc7==9
replace educyears=5 if hc7==11
replace educyears=6 if hc7==13
replace educyears=7 if hc7==15
replace educyears=7 if hc7==17
replace educyears=8 if hc7==19
replace educyears=9 if hc7==21
replace educyears=10 if hc7==23 | hc7==33
replace educyears=11 if hc7==25 | hc7==35
replace educyears=12 if hc7==27 | hc7==37
replace educyears=13 if hc7==29 | hc7==39 | hc7==43 | hc7==47
replace educyears=14 if hc7==31 | hc7==41 | hc7==45 | hc7==49
replace educyears=15 if hc7==51
replace educyears=16 if hc7==53


*Child under 5 in household
g under5=0
replace under5=. if hc5==. 
replace under5=1 if hc5<5 
bysort newid: egen childunder5=max(under5)
drop under5

*Child aged 5 to 12 in household
g aged5to12=0
replace aged5to12=. if  hc5==. 
replace aged5to12=1 if  hc5>=5 &  hc5<12
bysort newid: egen childaged5to12=max(aged5to12)
drop aged5to12

*Has adult aged 65+ in the household
g is65orover=0
replace is65orover=. if hc5==. 
replace is65orover=1 if hc5>=65 & hc5!=. 
bysort newid: egen adult65andover=max(is65orover)
drop is65orover

*Marital status of owner
*Since the marital status is only given for household heads, I can only compute it for head and their spouses
g help=1 if hc3==1 | hc3==3 
g married=(cvr11==3) if help==1 & cvr11!=-8
drop help

keep newid line_id hc_id hc1 ba* ex* in10b ownerage-married

*Country
g country="Thailand"

*TO DO: decide whether you need/want to change path for saving TTHAI
/**/
save TTHAI, replace
/**/

********************************************************************************
*Firm characteristics
********************************************************************************

/*Although there are also some baseline firm characteristics, I collect them when
collecting the panel variables for the firms, as for firms entering after the baseline,
 the values will be only available later.*/


*******************************************************************************

********************************************************************************
*Panel variables
********************************************************************************

********************************************************************************

********************************************************************************
*Round 1
********************************************************************************
 
*Survey round number
g wave=1

*Year survey took place
g surveyyear=1997

*Household operates a business
g hhbus=(ba1==1) if ba1!=.
drop ba1

*Household entirely owns household business
replace ba2=0 if hhbus==0

g enf_bus=(ba6==1) if ba6!=. & ba6!=-8

/*I will only consider household enterprises if the household operates only one 
enterprise and if this enterprise is entirely owned by the household:*/
g tbdropped=(ba2>1) if (ba2!=. & ba2!=-8) | enf_bus!=1

*Since the questionnaire mixes non-farm and farm enterprises:
g nonfarm=(ba3a==1 | ba3a==3 | ba3a==5 | ba3a==15 | ba3a==17 | ba3a==19) if hhbus==1 & ba3a!=-88

replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="A TOMTOM SHOW"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="BOXING CAMP OWNER" 
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="BUS SERVICE"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="CLOTHES WASHER" 
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="CONSTRUCT FOR FILL LAND"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="CONSTRUCTION BUSINESS"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="CONSTRUCTION EQUIPMENT SELLING"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="CONTRACT FOR CONSTRUCTION"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="CONTRACT FOR LAND FILLING"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="DOING CANNED YOUNG BAMBOO SHOOT"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="DRINKING WATER PRODUCER" 
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="EARTHEN JAR FACTORY" 
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="EMBROIDER CLOTH"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="EMBROIDER CLOTH BUSINESS"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="EMBROIDER CLOTH LABOR"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="GARAGE"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="HAIR CUT SHOP"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="HAVE HOUSE FOR RENT"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="HOUSE FOR RENT"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="MAKE FERNITURE (CUPBOARD)"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="MAKE SMALL MEAT BALL STICK"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="MAKE UMBRELLA FOR SALE"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="MAKEING BLOOM"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="MAKEING SILK"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="MOSQUITO-NET SETTING"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="OIL STATION"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="PICTURE FRAME SHOP"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="PLASTIC FLOWER MAKING"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="REPAIR SHOP FOR T.V. AND RADIO"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="ROOMS FOR RENT"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="ROW HOUSE FOR RENT"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="SELL PADDY"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="SELL THING WITH ELEPHANT"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="SELLER"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="SEWING"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="SEWING CLOTH"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="SEWING CLOTH LABER"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="SEWING CLOTHES"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="SEWING CLOTHS"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="SEWING MACHING"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="SHOE REPAIR"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="SILK WEAVING"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="SNOOKER"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="SOIL SELL" 
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="STORE FOR SELL BANANA FRY AND MEAT BALLS FRY" 
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="T.V.-RADIO REPAIR SHOP"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="THAO NOODLE BUSINESS"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="TO DO THE RESIDENCE"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="TO SELL PANTS IN THE MARKET"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="TOWNHOUSE FOR RENT"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="TWO ROOMS FOR RENT"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="WEAVING LABOR" 
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="WEAVING SILK"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="WEVE CLOTH"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao=="WEVING LOINCLOTH FOR BATHING W/G BATHROOM"												

replace hhbus=0 if nonfarm==0
replace hhbus=. if nonfarm==. & hhbus!=0

*Type of business
g typeofbus=ba3a if hhbus==1

*Sector of the firm:
*Firm is in retail trade
g retail=(ba3a==1 | ba3a==17) if hhbus==1
replace retail=1 if hhbus==1 & ba3a==21 & (ba3ao=="CONSTRUCTION EQUIPMENT SELLING" | ba3ao=="OIL STATION" | ba3ao=="SELL PADDY" | ba3ao=="SELL THING WITH ELEPHANT" | ba3ao=="SELLER" | ba3ao=="TO SELL PANTS IN THE MARKET")

*Firm is in manufacturing sector
g manuf=(ba3a==21 & (ba3ao=="DOING CANNED YOUNG BAMBOO SHOOT" | ba3ao=="DRINKING WATER PRODUCER" |  ba3ao=="EMBROIDER CLOTH" | ba3ao=="EMBROIDER CLOTH BUSINESS" | ba3ao=="EMBROIDER CLOTH LABOR" | ba3ao=="EARTHEN JAR FACTORY" | ba3ao=="MAKE FERNITURE (CUPBOARD)" | ba3ao=="MAKE UMBRELLA FOR SALE" | ba3ao=="MAKEING SILK" | ba3ao=="PLASTIC FLOWER MAKING" | ba3ao=="SILK WEAVING" | ba3ao=="WEAVING LABOR"  | ba3ao=="WEAVING SILK" | ba3ao=="WEVE CLOTH" | ba3ao=="WEVING LOINCLOTH FOR BATHING W/G BATHROOM")) if hhbus==1

*Firm is in service sector
g services=(ba3a==3 | ba3a==5 | ba3a==15 | ba3a==19) if hhbus==1
replace services=1 if hhbus==1 & ba3a==21 & (ba3ao=="BOXING CAMP OWNER" | ba3ao=="BUS SERVICE" | ba3ao=="CLOTHES WASHER" | ba3ao=="HAIR CUT SHOP" | ba3ao=="HAVE HOUSE FOR RENT" | ba3ao=="HOUSE FOR RENT" | ba3ao=="REPAIR SHOP FOR T.V. AND RADIO" | ba3ao=="ROOMS FOR RENT" | ba3ao=="ROW HOUSE FOR RENT" | ba3ao=="SEWING" | ba3ao=="SEWING CLOTH LABER" | ba3ao=="SEWING CLOTHES" | ba3ao=="SEWING CLOTHS" | ba3ao=="SEWING MACHING" | ba3ao=="SHOE REPAIR" | ba3ao=="SNOOKER" | ba3ao=="STORE FOR SELL BANANA FRY AND MEAT BALLS FRY" | ba3ao=="T.V.-RADIO REPAIR SHOP" | ba3ao=="THAO NOODLE BUSINESS" | ba3ao=="TO DO THE RESIDENCE" | ba3ao=="TOWNHOUSE FOR RENT" | ba3ao=="TWO ROOMS FOR RENT")

*Firm is in other sector
g othersector=(retail==0 & manuf==0 & services==0) if hhbus==1 

*Unclear
replace othersector=. if hhbus==1  & (ba3ao=="A TOMTOM SHOW" | ba3ao=="MAKE SMALL MEAT BALL STICK" | ba3ao=="MAKEING BLOOM" | ba3ao=="PICTURE FRAME SHOP")
replace services=. if hhbus==1  & (ba3ao=="A TOMTOM SHOW" | ba3ao=="MAKE SMALL MEAT BALL STICK" | ba3ao=="MAKEING BLOOM" | ba3ao=="PICTURE FRAME SHOP")
replace manuf=. if hhbus==1  & (ba3ao=="A TOMTOM SHOW" | ba3ao=="MAKE SMALL MEAT BALL STICK" | ba3ao=="MAKEING BLOOM" | ba3ao=="PICTURE FRAME SHOP")
replace retail=. if hhbus==1  & (ba3ao=="A TOMTOM SHOW" | ba3ao=="MAKE SMALL MEAT BALL STICK" | ba3ao=="MAKEING BLOOM" | ba3ao=="PICTURE FRAME SHOP")


*Age of the firm in years
replace ba4=. if ba4==-888
g agefirm=ba4 if hhbus==1 

*Number of paid employees
g employees=ba12 if hhbus==1 &  ba12!=-88

g totalworkers=ba9 if hhbus==1 & ba9!=-88

*Business expenses in last month
replace in10b=. if in10b==-8888888
g expenses=in10b/12 

keep newid line_id hc_id hc1 ex5-ex9 ownerage-expenses 

*TO DO: decide whether you need/want to change path for saving TTHAI
/**/
save TTHAI, replace
/**/

*TO DO: change path to where you saved the following file "j24tb1.dta" of the 1997 baseline
/*EXAMPLE:*/
use "Townsend Thai Project/1997/j24tb1.dta", clear
/**/

*Business sales in last month
keep if in_id==14 | in_id==15 | in_id==16 | in_id==17 | in_id==18 | in_id==19 | in_id==20 | in_id==21 | in_id==23 | in_id==29      
replace in4=0 if in2==3 | in2==-8
*I assume the following are codes for missing values:
replace in4=. if in4==-9999999 | in4==-8888888
bysort newid: egen sales=total(in4), m
*Since sales are given for past 12 months:
replace sales=sales/12

keep newid sales
duplicates drop


*TO DO: change path to where you saved the following file "TTHAI.dta"
/*EXAMPLE:*/
merge 1:m newid using TTHAI, nogenerate
/**/

g profits=sales-expenses if hhbus==1

*TO DO: decide whether you need/want to change path for saving TTHAI
/**/
save TTHAI, replace
/**/

*TO DO: change path to where you saved the following file "j07tab.dta" of the 1997 baseline
/*EXAMPLE:*/
use "Townsend Thai Project/1997/j07tab.dta", clear
/**/

g businessowner=(oc1b==1) if oc1b!=.

/*I code individuals as wage workers if the type of employment reported is either:
 - employee - daily wages, or
 - employee - monthly wages, or
 - government worker.
 I do not consider individuals to be wage workers if the type of employment reported is either:
 - owner of business, or
 - unpaid family worker, or
 - employee - piece rate, in house, or
 - employee - piece rate, out of house, or
 - other.
*/

*Worked as wage worker in last month
g wageworker=(oc1b==5 | oc1b==7 | oc1b==13) if oc1b!=.

*Labor earnings in last month
g laborincome=oc1c if oc1b==7 | oc1b==13
*For government workers it is not clear if the wages are given on a daily or monthly frequency, but I assume from the values that they are monthly
*In case wages are given for a daily frequency, I multiply them with 20 to have monthly wages:
replace laborincome=oc1c*20 if oc1b==5

*Retired
/*In 1999 oc1a==1 is given for inactive or retired. Given that there is not a label
 for retired in 1997, I assume that this is captured in this category too.*/
g retired=(oc1a==1) if oc1a!=.b & oc1a!=.x & oc1a!=.y

keep newid oc_id businessowner wageworker laborincome retired
rename oc_id hc_id

*TO DO: change path to where you saved the following file "TTHAI.dta"
/*EXAMPLE:*/
merge 1:1 newid hc_id using TTHAI, nogenerate
/**/

g hhbusowner=(businessowner==1) if hhbus==1

drop businessowner

duplicates tag newid hhbusowner if hhbus==1 & hhbusowner==1, gen(totalowners)
replace totalowners=totalowners+1

g jointbus=(totalowners>1) if hhbus==1 & totalowners!=.

*TO DO: decide whether you need/want to change path for saving TTHAI
/**/
save TTHAI, replace
/**/

*Household consumption
*TO DO: change path to where you saved the following file "j23tb1.dta" of the 1997 baseline
/*EXAMPLE:*/
use "Townsend Thai Project/1997/j23tb1.dta", clear
/**/
*I assume that -999999 and -888888 are codes for missing values:
replace ex4=. if ex4==-999999 | ex4==-888888

bysort newid: egen monthlyexp=total(ex4),m

keep newid monthlyexp
duplicates drop

*TO DO: change path to where you saved the following file "TTHAI.dta"
/*EXAMPLE:*/
merge 1:m newid using TTHAI, nogenerate
/**/

replace monthlyexp=12*monthlyexp
egen hh_exp=rowtotal(monthlyexp ex5-ex9), missing

g pcexpend=hh_exp/hc1

drop monthlyexp hh_exp hc1 ex5-ex9

*Exchange rate for approximate midpoint of survey period
/*According to the documentation, the data was collected in May 1997, so I use May 15
 as approximate midpoint for the exchange rate*/

g excrate=0.03906

g excratemonth="5-1997"


foreach var of varlist wageworker laborincome retired sales ownerage ownertertiary educyears childunder5 childaged5to12 adult65andover married wave surveyyear hhbus enf_bus tbdropped nonfarm typeofbus retail manuf services othersector agefirm employees totalworkers expenses profits hhbusowner totalowners jointbus pcexpend excrate excratemonth{ 
rename `var' `var'_1997
} 

*TO DO: decide whether you need/want to change path for saving TTHAI
/**/
save TTHAI, replace
/**/

/*Since the information on provinces (changwats) and subcounties (tambons) has been
 dropped and it seems that this is the ony way of knowing which households were 
 assigned to be followed/resurveyed in 1998, I retrieve this information from the ids.*/
 
g province=substr(newid, 1,2)
g subcounty=substr(newid, 1,6)

*TO DO: decide whether you need/want to change path for saving TTHAI
/**/
save TTHAI, replace
/**/

/*In each of the four survey provinces or changwats, four subcounties or tambons 
selected at random from the 12 irugubak tanvibs if tge criss-sectional 1997 survey
 were resurveyed. (From information on annual resurvey at http://cier.uchicago.edu/data/annual-resurvey.shtml)*/

/*In 1998, the following subcounties(changwats appear): 
072136
072436
072643
072729
272930
272931
273238
273240
492624
492838
493141
493235
532135
532636
532938
533139
*/

*So I keep only those observations having these subcounties:

keep if 	subcounty=="072136" ///
		|	subcounty=="072436" ///
		|	subcounty=="072643" ///
		|	subcounty=="072729" ///
		|	subcounty=="272930" ///
		|	subcounty=="272931" ///
		|	subcounty=="273238" ///
		|	subcounty=="273240" ///
		|	subcounty=="492624" ///
		|	subcounty=="492838" ///
		|	subcounty=="493141" ///
		|	subcounty=="493235" ///
		|	subcounty=="532135" ///
		|	subcounty=="532636" ///
		|	subcounty=="532938" ///
		|	subcounty=="533139" 

		
*TO DO: decide whether you need/want to change path for saving TTHAI
/**/
save TTHAI, replace
/**/
 
********************************************************************************
*Round 2
********************************************************************************
*TO DO: change path to where you saved the following file "hc_t.dta" of the 1998 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/1998/hc_t.dta", clear
/**/
*TO DO: change path to where you saved the following file "master.dta" of the 1998 annual household resurvey
/*EXAMPLE:*/
merge m:1 newid using "Townsend Thai Project/1998/master.dta", keep(3)
/**/

*Age of owner
g ownerage=hc5

*Gender of owner
g female=(hc4==3) if hc4!=.

*Education of owner
g ownertertiary=(hc7==47 | hc7==49 | hc7==51 | hc7==53) if hc7!=. & hc7!=-999 & hc7!=-888

*Years of education
*I assume the number is the years of education and calculate 6 years for primary and 6 years for secondary
*Sources: 	https://en.wikipedia.org/wiki/Education_in_Thailand
*			http://open_jicareport.jica.go.jp/pdf/11548013.pdf
g educyears=0 if hc7==1 | hc7==3 | hc7==5 | hc7==7 | hc7==9
replace educyears=1 if hc7==11
replace educyears=2 if hc7==13
replace educyears=3 if hc7==15
replace educyears=4 if hc7==17
replace educyears=5 if hc7==19
replace educyears=6 if hc7==21
replace educyears=7 if hc7==23
replace educyears=7 if hc7==25
replace educyears=8 if hc7==27
replace educyears=9 if hc7==29
replace educyears=10 if hc7==31 | hc7==41
replace educyears=11 if hc7==33 | hc7==43
replace educyears=12 if hc7==35 | hc7==45
replace educyears=13 if hc7==37 | hc7==47 | hc7==51 | hc7==55
replace educyears=14 if hc7==39 | hc7==49 | hc7==53 | hc7==57
replace educyears=15 if hc7==59
replace educyears=16 if hc7==61

*Child under 5 in household
g under5=0
replace under5=. if hc5==. 
replace under5=1 if hc5<5 
bysort newid: egen childunder5=max(under5)
drop under5

*Child aged 5 to 12 in household
g aged5to12=0
replace aged5to12=. if  hc5==. 
replace aged5to12=1 if  hc5>=5 &  hc5<12
bysort newid: egen childaged5to12=max(aged5to12)
drop aged5to12

*Has adult aged 65+ in the household
g is65orover=0
replace is65orover=. if hc5==. 
replace is65orover=1 if hc5>=65 & hc5!=. 
bysort newid: egen adult65andover=max(is65orover)
drop is65orover

*Marital status of owner
*Since the marital status is only given for household heads, I can only compute it for head and their spouses
g help=1 if hc3==1 | hc3==3 
g married=(cvr11==3) if help==1 & cvr11!=-8
drop help


*Survey round number
g wave=2

*Year survey took place
g surveyyear=1998

*Business closure in past 12 months
g hhbusclosure=(ba1a==1) if ba1a==1 | ba1a==3

*I keep the open ended reasons for closure as for now to be able to decide later on appropriate coding
forvalues i=1/4{
rename ba1c`i' reasonforclosure`i'
}

g typeofbusclosed=ba1b

*Household operates a business
g hhbus=(ba1d==1) if ba1d!=. & ba1d!=-8

*Household entirely owns household business
replace ba2=0 if hhbus==0

g enf_bus=(ba6==1) if ba6!=. & ba6!=-8

/*I will only consider household enterprises if the household operates only one 
enterprise and if this enterprise is entirely owned by the household:*/
g tbdropped=(ba2>1) if (ba2!=. & ba2!=-8) | enf_bus!=1

*Since the questionnaire mixes non-farm and farm enterprises:
g nonfarm=(ba3a==1 | ba3a==3 | ba3a==5 | ba3a==15 | ba3a==17 | ba3a==19) if hhbus==1 & ba3a!=-88

replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="10 WHEEL EMPLOYED DRIVER"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="6 WHEEL TRUCT DRIVER"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="A BARBER"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="BROOM MAKING"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="BRUSS BAND FOR HIRE"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="BUS DRIVER"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="BUY UNUSED THING"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="CHACOAL"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="CLOTH KNITTING"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="CLOTH MAKING"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="CLOTH WEAVING"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="CONSTRUCTION BUSINESS"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="DIRECT SALE"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="DRESSMAKER"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="DRIVING SUGAR CANE TRUCK"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="ELECTRIC EQUIPMENTS REPAIR SERVICE"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="ELECTRICIAN"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="EMBROIDERER"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="FISHING ROD MAKER"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="GARAGE"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="HANDICRAFT"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="HANDICRAFT(BASKET)"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="HIRED DRIVER (THE HEAD OF FAMILY'S VEHICLE)"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="HIRED MOTOR TRICYCLE DRIVER."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="IRON WORKER SHOP"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MAKE A PART OF WARDROBE."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MAKE BASKETWORK"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MAKE BLOOM HANDLES"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MAKE BROOM"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MAKE THATCHED-ROOF"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MAKING BAMBOO CHICKEN COOP"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MAKING DESIGN ON THE BLOOM HANDLE"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MAKING SWEET ROLL FOR SALE"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MAKING THE DESIGN ON BLOOM HANDLES"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MAKING+REPAIRING CLOTH"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MERCHANDISE"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MOTOR TRICYCLE SERVICE"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MOTORCYCLE SERVICE"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MOTORCYCLE-SERVICE"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="NOODLES SHOP"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="PRODUCING BOTTLED DRINKING WATER"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="RENT-OUT AMPHIFIER"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="REPAIR SHOP FOR ELECTRICITY EQUIPMENTS."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="REPAIRING SHOES SERVICE"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="ROOM FOR RENT"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="SALE CHARCOAL"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="SCHOOL BUS DRIVER"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="SELL GAS"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="SELL LOTTERY TICKET"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="SELL STANLESS POT"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="SELL TREE (STEM)"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="SELLING AT SCHOOL"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="SEWING CLOTHES (AT HOME)"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="SILK WEAVING"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="TAKE EMPLOYMENT FOR MAKING BLOOM HANDLES"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="TRICYCLE DRIVER"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="TRUCK BUSINESS,LOADING THE AGRICULTURAL THINGS" 
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="TRUCK DRIVER"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="TRUCK DRIVER, DELIVER CHICKEN-FOOD."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="VAN FOR RENT"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="VILLAGE DOCTOR"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="WELDER SHOP"


replace hhbus=0 if nonfarm==0
replace hhbus=. if nonfarm==. & hhbus!=0

*Type of business
g typeofbus=ba3a if hhbus==1

*Sector of the firm:
*Firm is in retail trade
g retail=(ba3a==1 | ba3a==17) if hhbus==1
replace retail=1 if hhbus==1 & ba3a==21 & (ba3ao2=="DIRECT SALE" | ba3ao2=="MERCHANDISE" | ba3ao2=="SALE CHARCOAL" | ba3ao2=="SELL GAS" | ba3ao2=="SELL LOTTERY TICKET" | ba3ao2=="SELL STANLESS POT" | ba3ao2=="SELL TREE (STEM)" | ba3ao2=="SELLING AT SCHOOL")

*Firm is in manufacturing sector
g manuf=(ba3a==21 & (ba3ao2=="BROOM MAKING" | ba3ao2=="CLOTH KNITTING" | ba3ao2=="CLOTH MAKING" | ba3ao2=="CLOTH WEAVING" | ba3ao2=="DRESSMAKER" | ba3ao2=="EMBROIDERER" | ba3ao2=="FISHING ROD MAKER"  | ba3ao2=="HANDICRAFT"  | ba3ao2=="HANDICRAFT(BASKET)" | ba3ao2=="IRON WORKER SHOP" | ba3ao2=="MAKE A PART OF WARDROBE." | ba3ao2=="MAKE BASKETWORK" | ba3ao2=="MAKE BROOM" | ba3ao2=="MAKE THATCHED-ROOF" | ba3ao2=="MAKING BAMBOO CHICKEN COOP" | ba3ao2=="MAKING+REPAIRING CLOTH" | ba3ao2=="PRODUCING BOTTLED DRINKING WATER" | ba3ao2=="SEWING CLOTHES (AT HOME)" | ba3ao2=="SILK WEAVING" | ba3ao2=="WELDER SHOP")) if hhbus==1

*Firm is in service sector
g services=(ba3a==3 | ba3a==5 | ba3a==15 | ba3a==19) if hhbus==1
replace services=1 if hhbus==1 & ba3a==21 & (ba3ao2=="10 WHEEL EMPLOYED DRIVER" | ba3ao2=="6 WHEEL TRUCT DRIVER" | ba3ao2=="A BARBER" | ba3ao2=="BRUSS BAND FOR HIRE" | ba3ao2=="BUS DRIVER" | ba3ao2=="DRIVING SUGAR CANE TRUCK" | ba3ao2=="ELECTRIC EQUIPMENTS REPAIR SERVICE"| ba3ao2=="ELECTRICIAN" | ba3ao2=="HIRED DRIVER (THE HEAD OF FAMILY'S VEHICLE)" | ba3ao2=="HIRED MOTOR TRICYCLE DRIVER." | ba3ao2=="MAKING SWEET ROLL FOR SALE" | ba3ao2=="MOTOR TRICYCLE SERVICE" | ba3ao2=="MOTORCYCLE SERVICE" | ba3ao2=="MOTORCYCLE-SERVICE" | ba3ao2=="NOODLES SHOP" | ba3ao2=="RENT-OUT AMPHIFIER" | ba3ao2=="REPAIR SHOP FOR ELECTRICITY EQUIPMENTS." | ba3ao2=="REPAIRING SHOES SERVICE" | ba3ao2=="ROOM FOR RENT" | ba3ao2=="SCHOOL BUS DRIVER"| ba3ao2=="TRICYCLE DRIVER" | ba3ao2=="TRUCK BUSINESS,LOADING THE AGRICULTURAL THINGS" | ba3ao2=="TRUCK DRIVER" | ba3ao2=="TRUCK DRIVER, DELIVER CHICKEN-FOOD." | ba3ao2=="VAN FOR RENT" | ba3ao2=="VILLAGE DOCTOR")

*Firm is in other sector
g othersector=(retail==0 & manuf==0 & services==0) if hhbus==1 

replace othersector=. if hhbus==1 & (ba3ao2=="BUY UNUSED THING" | ba3ao2=="CHACOAL" | ba3ao2=="MAKE BLOOM HANDLES" | ba3ao2=="MAKING DESIGN ON THE BLOOM HANDLE" | ba3ao2=="MAKING THE DESIGN ON BLOOM HANDLES" | ba3ao2=="TAKE EMPLOYMENT FOR MAKING BLOOM HANDLES")
replace services=. if hhbus==1 & (ba3ao2=="BUY UNUSED THING" | ba3ao2=="CHACOAL" | ba3ao2=="MAKE BLOOM HANDLES" | ba3ao2=="MAKING DESIGN ON THE BLOOM HANDLE" | ba3ao2=="MAKING THE DESIGN ON BLOOM HANDLES" | ba3ao2=="TAKE EMPLOYMENT FOR MAKING BLOOM HANDLES")
replace manuf=. if hhbus==1 & (ba3ao2=="BUY UNUSED THING" | ba3ao2=="CHACOAL" | ba3ao2=="MAKE BLOOM HANDLES" | ba3ao2=="MAKING DESIGN ON THE BLOOM HANDLE" | ba3ao2=="MAKING THE DESIGN ON BLOOM HANDLES" | ba3ao2=="TAKE EMPLOYMENT FOR MAKING BLOOM HANDLES")
replace retail=. if hhbus==1 & (ba3ao2=="BUY UNUSED THING" | ba3ao2=="CHACOAL" | ba3ao2=="MAKE BLOOM HANDLES" | ba3ao2=="MAKING DESIGN ON THE BLOOM HANDLE" | ba3ao2=="MAKING THE DESIGN ON BLOOM HANDLES" | ba3ao2=="TAKE EMPLOYMENT FOR MAKING BLOOM HANDLES")


*Age of the firm in years
replace ba4=. if ba4==-88
g agefirm=ba4 if hhbus==1 

*Number of paid employees
g employees=ba12 if hhbus==1 &  ba12!=-88

g totalworkers=ba9 if hhbus==1 & ba9!=-88

*Business expenses in last month
replace in10b=. if in10b==-8888888
g expenses=in10b/12 

keep newid line_id hc1 ex5-ex9 reasonforclosure* ownerage-expenses 

*TO DO: decide whether you need/want to change path for saving TTHAI2
/**/
save TTHAI2, replace
/**/

*TO DO: change path to where you saved the following file "n_t1.dta" of the 1998 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/1998/in_t1.dta", clear
/**/

*Business sales in last month
keep if in_id==14 | in_id==15 | in_id==16 | in_id==17 | in_id==18 | in_id==19 | in_id==20 | in_id==21 | in_id==23 | in_id==29      
replace in4=0 if in2==3 | in2==-8
replace in4=. if in4==-8888888
bysort newid: egen sales=total(in4), m
*Since sales are given for past 12 months:
replace sales=sales/12

keep newid sales
duplicates drop

*TO DO: change path to where you saved the following file "TTHAI2.dta"
/*EXAMPLE:*/
merge 1:m newid using TTHAI2, nogenerate
/**/

g profits=sales-expenses if hhbus==1

*TO DO: decide whether you need/want to change path for saving TTHAI2
/**/
save TTHAI2, replace
/**/

*TO DO: change path to where you saved the following file "hc_t.dta" of the 1998 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/1998/hc_t.dta", clear
/**/
keep newid hc_id
rename hc_id oc_id

*TO DO: change path to where you saved the following file "oc_t.dta" of the 1998 annual household resurvey
/*EXAMPLE:*/
merge 1:1 newid oc_id using "Townsend Thai Project/1998/oc_t.dta", nogenerate
/**/

g businessowner=(oc1b==1) if oc1b!=. & oc1b!=-8

/*I code individuals as wage workers if the type of employment reported is either:
 - employee - daily wages, or
 - employee - monthly wages, or
 - government worker.
 I do not consider individuals to be wage workers if the type of employment reported is either:
 - owner of business, or
 - unpaid family worker, or
 - employee - piece rate, in house, or
 - employee - piece rate, out of house, or
 - other.
*/

*Worked as wage worker in last month
g wageworker=(oc1b==5 | oc1b==7 | oc1b==13) if oc1b!=. & oc1b!=-8

*Labor earnings in last month
*Replace missing values:
replace oc1c=. if oc1c<0
g laborincome=oc1c if oc1b==7 | oc1b==13
*For government workers it is not clear if the wages are given on a daily or monthly frequency, but I assume from the values that they are monthly
*In case wages are given for a daily frequency, I multiply them with 20 to have monthly wages:
replace laborincome=oc1c*20 if oc1b==5

*Retired
g retired=(oc1a==1) if  oc1a!=-8 

keep newid oc_id businessowner wageworker laborincome retired

rename oc_id line_id

*TO DO: change path to where you saved the following file "TTHAI2.dta"
/*EXAMPLE:*/
merge 1:1 newid line_id using TTHAI2, nogenerate
/**/

g hhbusowner=(businessowner==1) if hhbus==1 & businessowner!=.

drop businessowner

duplicates tag newid hhbusowner if hhbus==1 & hhbusowner==1, gen(totalowners)
replace totalowners=totalowners+1

g jointbus=(totalowners>1) if hhbus==1 & totalowners!=.

*TO DO: decide whether you need/want to change path for saving TTHAI2
/**/
save TTHAI2, replace
/**/

*Household consumption
*TO DO: change path to where you saved the following file "ex_t.dta" of the 1998 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/1998/ex_t.dta", clear
/**/
*I assume that -999999 and -888888 are codes for missing values:
replace ex4=. if ex4==-88888

bysort newid: egen monthlyexp=total(ex4),m

keep newid monthlyexp
duplicates drop

*TO DO: change path to where you saved the following file "TTHAI2.dta"
/*EXAMPLE:*/
merge 1:m newid using TTHAI2, nogenerate
/**/

replace monthlyexp=12*monthlyexp
egen hh_exp=rowtotal(monthlyexp ex5-ex9), missing

g pcexpend=hh_exp/hc1

drop monthlyexp hh_exp hc1 ex5-ex9


*Exchange rate for approximate midpoint of survey period
/*According to the documentation, the data was collected in May 1998, so I use May 15
 as approximate midpoint for the exchange rate*/

g excrate=0.02571

g excratemonth="5-1998"


foreach var of varlist wageworker laborincome retired sales reasonforclosure1-reasonforclosure4 ownerage ownertertiary educyears childunder5 childaged5to12 adult65andover married wave surveyyear hhbusclosure typeofbusclosed hhbus enf_bus tbdropped nonfarm typeofbus retail manuf services othersector agefirm employees totalworkers expenses profits hhbusowner totalowners jointbus pcexpend excrate excratemonth{ 
rename `var' `var'_1998
} 

rename line_id hc_id

*TO DO: decide whether you need/want to change path for saving TTHAI2
/**/
save TTHAI2, replace
/**/

/*Since the information on provinces (changwats) and subcounties (tambons) has been
 dropped and it seems that this is the ony way of knowing which households were 
 assigned to be followed/resurveyed in 1998, I retrieve this information from the ids.*/
 
g province=substr(newid, 1,2)
g subcounty=substr(newid, 1,6)

*TO DO: decide whether you need/want to change path for saving TTHAI2
/**/
save TTHAI2, replace
/**/

*TO DO: decide whether you need/want to change path for saving TTHAI
/**/
use TTHAI, clear
/**/

*TO DO: change path to where you saved the following file "TTHAI2.dta"
/*EXAMPLE:*/
merge 1:1 newid hc_id using TTHAI2, update
/**/

*TO DO: decide whether you need/want to change path for saving TTHAImaster
/**/
save TTHAImaster, replace
/**/
********************************************************************************
*Round 3
********************************************************************************
*TO DO: change path to where you saved the following file "hc2_t.dta" of the 1999 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/1999/hc2_t.dta", clear
/**/
*TO DO: change path to where you saved the following file "master.dta" of the 1999 annual household resurvey
/*EXAMPLE:*/
merge m:1 newid using "Townsend Thai Project/1999/master.dta", keep(3)
/**/

*Age of owner
g ownerage=hc5

*Gender of owner
g female=(hc4==3) if hc4!=.

*Education of owner
g ownertertiary=(hc7==47 | hc7==49 | hc7==51 | hc7==53) if hc7!=. & hc7!=-999 & hc7!=-888

*Years of education
*I assume the number is the years of education and calculate 6 years for primary and 6 years for secondary
*Sources: 	https://en.wikipedia.org/wiki/Education_in_Thailand
*			http://open_jicareport.jica.go.jp/pdf/11548013.pdf
g educyears=0 if hc7==1 | hc7==3 | hc7==5 | hc7==7 | hc7==9
replace educyears=1 if hc7==11
replace educyears=2 if hc7==13
replace educyears=3 if hc7==15
replace educyears=4 if hc7==17
replace educyears=5 if hc7==19
replace educyears=6 if hc7==21
replace educyears=7 if hc7==23
replace educyears=7 if hc7==25
replace educyears=8 if hc7==27
replace educyears=9 if hc7==29
replace educyears=10 if hc7==31 | hc7==41
replace educyears=11 if hc7==33 | hc7==43
replace educyears=12 if hc7==35 | hc7==45
replace educyears=13 if hc7==37 | hc7==47 | hc7==51 | hc7==55
replace educyears=14 if hc7==39 | hc7==49 | hc7==53 | hc7==57
replace educyears=15 if hc7==59
replace educyears=16 if hc7==61

*Child under 5 in household
g under5=0
replace under5=. if hc5==. 
replace under5=1 if hc5<5 
bysort newid: egen childunder5=max(under5)
drop under5

*Child aged 5 to 12 in household
g aged5to12=0
replace aged5to12=. if  hc5==. 
replace aged5to12=1 if  hc5>=5 &  hc5<12
bysort newid: egen childaged5to12=max(aged5to12)
drop aged5to12

*Has adult aged 65+ in the household
g is65orover=0
replace is65orover=. if hc5==. 
replace is65orover=1 if hc5>=65 & hc5!=. 
bysort newid: egen adult65andover=max(is65orover)
drop is65orover

*Marital status of owner
*Since the marital status is only given for household heads, I can only compute it for head and their spouses
g help=1 if hc3==1 | hc3==3 
g married=(cvr11==3) if help==1 & cvr11!=-8
drop help

*Survey round number
g wave=3

*Year survey took place
g surveyyear=1999

*Business closure in past 12 months
g hhbusclosure=(ba1a==1) if ba1a==1 | ba1a==3

/*Although the questionnaire asks for reasons, the business was closed (question ba1c),
this variable is not in the dataset and also not in the codebook file*/

g typeofbusclosed=ba1b

*Household operates a business
g hhbus=(ba1d==1) if ba1d!=.

*Household entirely owns household business
replace ba2=0 if hhbus==0

g enf_bus=(ba6==1) if ba6!=.

*Household entirely owns household business
*Business founded in last 12 months:
g newfirmquex=(ba21a==1) if ba21a!=.

/*I will only consider household enterprises if the household operates only one 
enterprise and if this enterprise is entirely owned by the household:*/
g tbdropped=(ba2>1) if (ba2!=. & ba2!=-8) | enf_bus!=1

*Since the questionnaire mixes non-farm and farm enterprises:
g nonfarm=(ba3a==1 | ba3a==3 | ba3a==5 | ba3a==15 | ba3a==17 | ba3a==19) if hhbus==1 & ba3a!=.

replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="- DRIVING FOR EMPLOYMENT."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="- ELECTRICIAN"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="- HIRED MOTORCYCLE RIDER."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="- MAKING BROOMSTICKS."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="- MAKING CHICKEN COOP."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="- MAKING CLOTH"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="- MOTORCYCLE RIDER"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="- VAN FOR HIRE."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="- WORK AS SEWING CLOTHES."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="10 WHEELS TRUCK FOR HIRE"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="A SELLING FOOD AT SCHOOL."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="A SERVICE SCHOOL VAN DRIVER"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="A SEWING SERVICE."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="A SHOP FOR REPAIRING ELECTRIC EQUIPMENT."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="BASKETRY"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="BASKETRY HANDICRAFT MAKER"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="BEING 10 WHEEL DRIVER"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="BEING A MOTORCYCLIST SERVICE."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="BROKER FOR CORN SEED PLANTING"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="BUS DRIVER"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="CLOTH MAKING SHOP"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="CLOTH WEAVING"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="CONSTRUCTION BUSINESS"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="CONSTRUCTION BUSINESS."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="CUT & POLISH GEMS"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="DELIVERY SUGGAR-CANE"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="DRIVER OF TRI-MOTERCYCLE"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="DRIVING TRI-MOTORCYCLE FOR HIRING."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="EMBROIDARY SHIRT COLLARS."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="EMBROIDERER"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="FISH ROD MAKING"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="FOOD & SWEETS SELLING"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="FURNITURE WORKER"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="GURBAGE RECYCLING."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="HANDICRAFT"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="ICE-CREAM VENDOR"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="KNITTING"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="KNITTING A SHIRT COLLAR"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MAKE SELL SWEET"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MAKING BROOMS"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MAKING BROOMS FOR SALE."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MAKING BROOMSTICKS"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MAKING CAKE FOR SALE."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MAKING CHOP-STICK"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MAKING CHOP-STICK FOR SALE."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MAKING HAMMOCK FOR SALE."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MAKING IRON LETTICE"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MAKING WOOD CHOP-STICK."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MIDDLE-MAN OF SELLING OLDITEMS BUSINESS."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MIDDLE-MERCHANT OF SELLING OLD ITEMS."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MOTORCYCLE FOR HIRE"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MUSICAL SET FOR MENT"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MUSICIAN"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="PETROL STATION"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="PLANTS SELLING BUSINESS."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="PRDUCE DRINKING WATER (BOTTLE)"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="REPAIRING ELECTRIC APPLICANTS."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="SELL SWEET."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="SELLING FUEL"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="SELLING LOTTERIES."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="SELLING VEGETABLE."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="SEWING CLOTHES"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="SEWING EMPLOYEE"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="SEWING THATCH"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="SHOES REPAIR AMN"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="TEACHER IN EXTRA PERIOD"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="TRUCK DRIVER."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="TRUCK FOR HIRE"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="VENDOR"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="WEAVING"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="WEAVING SILK MATERIAL"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="YOUNG BAMBOO PACKED IN TIN"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="YOUNG BAMBOO PACKED IN TIN."

replace hhbus=0 if nonfarm==0
replace hhbus=. if nonfarm==. & hhbus!=0

*Type of business
g typeofbus=ba3a if hhbus==1

*Sector of the firm:
*Firm is in retail trade
g retail=(ba3a==1 | ba3a==17) if hhbus==1
replace retail=1 if hhbus==1 & ba3a==21 & (ba3ao2=="MIDDLE-MAN OF SELLING OLDITEMS BUSINESS." | ba3ao2=="MIDDLE-MERCHANT OF SELLING OLD ITEMS." | ba3ao2=="PETROL STATION" | ba3ao2=="PLANTS SELLING BUSINESS." | ba3ao2=="SELLING FUEL" | ba3ao2=="SELLING LOTTERIES." | ba3ao2=="SELLING VEGETABLE." | ba3ao2=="VENDOR")

*Firm is in manufacturing sector
g manuf=(ba3a==21 & (ba3ao2=="- MAKING BROOMSTICKS." | ba3ao2=="- MAKING CHICKEN COOP." | ba3ao2=="- MAKING CLOTH" | ba3ao2=="- WORK AS SEWING CLOTHES." | ba3ao2=="A SEWING SERVICE." | ba3ao2=="BASKETRY" | ba3ao2=="BASKETRY HANDICRAFT MAKER" | ba3ao2=="CLOTH MAKING SHOP" | ba3ao2=="CLOTH WEAVING"  | ba3ao2=="CUT & POLISH GEMS"  | ba3ao2=="EMBROIDARY SHIRT COLLARS." | ba3ao2=="EMBROIDERER" | ba3ao2=="FISH ROD MAKING" | ba3ao2=="FURNITURE WORKER" | ba3ao2=="HANDICRAFT" | ba3ao2=="KNITTING" | ba3ao2=="KNITTING A SHIRT COLLAR" | ba3ao2=="MAKING BROOMS" | ba3ao2=="MAKING BROOMS FOR SALE." | ba3ao2=="MAKING BROOMSTICKS" | ba3ao2=="MAKING CHOP-STICK" | ba3ao2=="MAKING CHOP-STICK FOR SALE." | ba3ao2=="MAKING HAMMOCK FOR SALE." | ba3ao2=="MAKING IRON LETTICE" | ba3ao2=="MAKING WOOD CHOP-STICK." | ba3ao2=="PRDUCE DRINKING WATER (BOTTLE)" | ba3ao2=="SEWING CLOTHES" | ba3ao2=="SEWING EMPLOYEE" | ba3ao2=="SEWING THATCH" | ba3ao2=="WEAVING" | ba3ao2=="WEAVING SILK MATERIAL" | ba3ao2=="YOUNG BAMBOO PACKED IN TIN" | ba3ao2=="YOUNG BAMBOO PACKED IN TIN.")) if hhbus==1

*Firm is in service sector
g services=(ba3a==3 | ba3a==5 | ba3a==15 | ba3a==19) if hhbus==1
replace services=1 if hhbus==1 & ba3a==21 & (ba3ao2=="- DRIVING FOR EMPLOYMENT." | ba3ao2=="- ELECTRICIAN" | ba3ao2=="- HIRED MOTORCYCLE RIDER." | ba3ao2=="- MOTORCYCLE RIDER" | ba3ao2=="- VAN FOR HIRE." | ba3ao2=="10 WHEELS TRUCK FOR HIRE"| ba3ao2=="A SELLING FOOD AT SCHOOL." | ba3ao2=="A SERVICE SCHOOL VAN DRIVER" | ba3ao2=="A SHOP FOR REPAIRING ELECTRIC EQUIPMENT." | ba3ao2=="BEING 10 WHEEL DRIVER" | ba3ao2=="BEING A MOTORCYCLIST SERVICE." | ba3ao2=="BROKER FOR CORN SEED PLANTING" | ba3ao2=="BUS DRIVER" | ba3ao2=="DELIVERY SUGGAR-CANE" | ba3ao2=="DRIVER OF TRI-MOTERCYCLE" | ba3ao2=="DRIVING TRI-MOTORCYCLE FOR HIRING." | ba3ao2=="FOOD & SWEETS SELLING" | ba3ao2=="ICE-CREAM VENDOR" | ba3ao2=="MAKE SELL SWEET" | ba3ao2=="MAKING CAKE FOR SALE." | ba3ao2=="MOTORCYCLE FOR HIRE" | ba3ao2=="MUSICAL SET FOR MENT" | ba3ao2=="MUSICIAN"| ba3ao2=="REPAIRING ELECTRIC APPLICANTS." | ba3ao2=="SELL SWEET." | ba3ao2=="SHOES REPAIR AMN" | ba3ao2=="TEACHER IN EXTRA PERIOD" | ba3ao2=="TRUCK DRIVER." | ba3ao2=="TRUCK FOR HIRE")

*Firm is in other sector
g othersector=(retail==0 & manuf==0 & services==0) if hhbus==1 


*Age of the firm in years
replace ba4=. if ba4==-99 
g agefirm=ba4 if hhbus==1 

*Number of paid employees
g employees=ba12 if hhbus==1 

g totalworkers=ba9 if hhbus==1 


*Business expenses in last month
g expenses=in10b/12 

keep newid line_id hc1 ex5-ex9 ownerage-expenses 

*TO DO: decide whether you need/want to change path for saving TTHAI3
/**/
save TTHAI3, replace
/**/

*TO DO: change path to where you saved the following file "in1_t.dta" of the 1999 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/1999/in1_t.dta", clear
/**/

rename in2_id in_id

*Business sales in last month
keep if in_id==14 | in_id==15 | in_id==16 | in_id==17 | in_id==18 | in_id==19 | in_id==20 | in_id==21 | in_id==23 | in_id==29      
replace in4=0 if in2==3
replace in4=. if in4==-8888888
bysort newid: egen sales=total(in4), m
*Since sales are given for past 12 months:
replace sales=sales/12

keep newid sales
duplicates drop

*TO DO: change path to where you saved the following file "TTHAI3.dta"
/*EXAMPLE:*/
merge 1:m newid using TTHAI3, nogenerate
/**/

g profits=sales-expenses if hhbus==1

*TO DO: decide whether you need/want to change path for saving TTHAI3
/**/
save TTHAI3, replace
/**/

*TO DO: change path to where you saved the following file "hc2_t.dta" of the 1999 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/1999/hc2_t.dta", clear
/**/
keep newid hc_id

*TO DO: change path to where you saved the following file "oc1.dta" of the 1999 annual household resurvey
/*EXAMPLE:*/
merge 1:1 newid hc_id using "Townsend Thai Project/1999/oc1.dta", nogenerate
/**/

g businessowner=(oc1b==1) if oc1b!=. & oc1b!=-88

/*I code individuals as wage workers if the type of employment reported is either:
 - employee - daily wages, or
 - employee - monthly wages, or
 - government worker.
 I do not consider individuals to be wage workers if the type of employment reported is either:
 - owner of business, or
 - unpaid family worker, or
 - employee - piece rate, in house, or
 - employee - piece rate, out of house, or
 - other.
*/

*Worked as wage worker in last month
g wageworker=(oc1b==5 | oc1b==7 | oc1b==13) if oc1b!=. & oc1b!=-88

*Labor earnings in last month
*Replace missing values:
replace oc1c=. if oc1c<0
g laborincome=oc1c if oc1b==7 | oc1b==13
*For government workers it is not clear if the wages are given on a daily or monthly frequency, but I assume from the values that they are monthly
*In case wages are given for a daily frequency, I multiply them with 20 to have monthly wages:
replace laborincome=oc1c*20 if oc1b==5

*Retired
g retired=(oc1a==1) if  oc1a!=-88 &  oc1a!=-99

keep newid hc_id businessowner wageworker laborincome retired

rename hc_id line_id

*TO DO: change path to where you saved the following file "TTHAI3.dta"
/*EXAMPLE:*/
merge 1:1 newid line_id using TTHAI3, nogenerate 
/**/
g hhbusowner=(businessowner==1) if hhbus==1 & businessowner!=.

drop businessowner

duplicates tag newid hhbusowner if hhbus==1 & hhbusowner==1, gen(totalowners)
replace totalowners=totalowners+1

g jointbus=(totalowners>1) if hhbus==1 & totalowners!=.

*TO DO: decide whether you need/want to change path for saving TTHAI3
/**/
save TTHAI3, replace
/**/

*Household consumption
*TO DO: change path to where you saved the following file "ex_t.dta" of the 1999 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/1999/ex_t.dta", clear
/**/
replace ex4=. if ex4==-88888

bysort newid: egen monthlyexp=total(ex4),m

keep newid monthlyexp
duplicates drop

*TO DO: change path to where you saved the following file "TTHAI3.dta"
/*EXAMPLE:*/
merge 1:m newid using TTHAI3, nogenerate
/**/

replace monthlyexp=12*monthlyexp
egen hh_exp=rowtotal(monthlyexp ex5-ex9), missing

g pcexpend=hh_exp/hc1

drop monthlyexp hh_exp hc1 ex5-ex9


*Exchange rate for approximate midpoint of survey period
/*According to the documentation, the data was collected in May 1999, so I use May 15
 as approximate midpoint for the exchange rate*/

g excrate=0.02681

g excratemonth="5-1999"


foreach var of varlist wageworker laborincome retired sales ownerage ownertertiary educyears childunder5 childaged5to12 adult65andover married wave surveyyear hhbusclosure typeofbusclosed hhbus enf_bus newfirmquex tbdropped nonfarm typeofbus retail manuf services othersector agefirm employees totalworkers expenses profits hhbusowner totalowners jointbus pcexpend excrate excratemonth{ 
rename `var' `var'_1999
} 

rename line_id hc_id

*TO DO: decide whether you need/want to change path for saving TTHAI3
/**/
save TTHAI3, replace
/**/

********************************************************************************
*Merge round 3 to TTHAImaster 
********************************************************************************
*TO DO: change path to where you saved the following file "TTHAImaster.dta"
/*EXAMPLE:*/
use TTHAImaster, clear
/**/

*TO DO: change path to where you saved the following file "TTHAI3.dta"
/*EXAMPLE:*/
merge 1:1 newid hc_id using TTHAI3, gen(_merge2) update
/**/

*TO DO: decide whether you need/want to change path for saving TTHAImaster
/**/
save TTHAImaster, replace
/**/

********************************************************************************
*Round 4
********************************************************************************
*Start with ba file
*TO DO: change path to where you saved the following file "hh00_13ba.dta" of the 2000 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2000/hh00_13ba.dta", clear
/**/

*Survey round number
g wave=4

*Year survey took place
g surveyyear=2000

*Business closure in past 12 months
g hhbusclosure=(ba1a==1) if ba1a==1 | ba1a==3

/*Although the questionnaire asks for reasons, the business was closed (question ba1c),
this variable is not in the dataset and also not in the codebook file*/
replace ba1b=. if ba1b==.c
g typeofbusclosed=ba1b

*I keep the open ended reasons for closure as for now to be able to decide later on appropriate coding
rename ba1c reasonforclosure

*Household operates a business
g hhbus=(ba1d==1) if ba1d!=.c

*TO DO: decide whether you need/want to change path for saving TTHAI4
/**/
save TTHAI4, replace 
/**/
*TO DO: change path to where you saved the following file "hh00_13ba_tab1.dta" of the 2000 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2000/hh00_13ba_tab1.dta", clear
/**/

/*Only keep the information for the first business as I will only consider businesses
 of households who have only one business:*/
keep if bnumber==1

*TO DO: change path to where you saved the following file "TTHAI4.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI4, nogenerate
/**/

*Household entirely owns household business
replace ba2=0 if hhbus==0

g enf_bus=(ba6==1) if ba6!=.

*Household entirely owns household business
*Business founded in last 12 months:
g newfirmquex=(ba21a==1) if ba21a!=.

/*I will only consider household enterprises if the household operates only one 
enterprise and if this enterprise is entirely owned by the household:*/
g tbdropped=(ba2>1) if ba2!=.c | enf_bus!=1

*Since the questionnaire mixes non-farm and farm enterprises:
g nonfarm=(ba3a==1 | ba3a==3 | ba3a==5 | ba3a==15 | ba3a==17 | ba3a==19) if hhbus==1 & ba3a!=.c

replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="ARTISAN"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="BAMBOO HANDICRAFT FOR FISHING"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="BOUGHT THE OLD GOODS TO SALE AS A SECOND HAND."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="BUY THE OLD GOODS FOR SELL."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="BUYING AND SELLING OLD THINGS"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="CLOTH MAKING"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="CONSTRUCTION"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="CONSTRUCTION BUSINESS"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="COOKING CAKE FOR SALE"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="CUT RUBY"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="DEVELOP LAND LOCATION BUSINESS (FILL IN THE SOIL)"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="DIRECT-SALE OF MISTEEN COSMETIC."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="DIRECT-SALE ON COSMETIC BUSINESS."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="DRESSMAKER"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="DRIVE PICK-UP CAR TO DELIVER STUDENTS."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="DRIVER TO DELIVER CHICKEN-FOOD."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="DRIVER TO DELIVER SUGAR-CANE"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="DRIVER TO TRANSPORT STUDENTS"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="DRIVING HIRED MOTORCYCLE"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="EMBROIDERY"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="EMBROIDERY WORK"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="EMPLOYEE-DRIVER TO TRANSPORT FERTILIZER."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="HIRED MOTORCYCLE"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="HIRED TO ARRANGE THE LABOUR TO BUILD SOMETHING."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="HIRED-TRICYCLE DRIVER"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="HIRED-TRICYCLES DRIVER"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="ICE CUBE SHOP"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="LOCAL HANDICRAFT"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MAKE BOILED THE YOUNG BAMBOO SHOOT IN THE CAN."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MAKE BROOM STICKS"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MAKE BROOMS"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MAKE FISHERY EQUIPMENTS"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MAKE GRASS-ROOF"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MAKE MANGO-DESSERT TO SELL"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MAKE THE GRASS-ROOF."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MAKER BOILED THE YOUNG BAMBOO SHOOT."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MAKING BROOM"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MAKING CHOP STICKS"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MAKING DRINKING WATER"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MAKING FOODS SHELF. SIDEBOARD"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MAKING IRON DOOR AND WINDOW"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MAKING ROOF-SHEET FROM PALM LEAVES"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MAKING SWEET"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MAKING THE BOILED YOUNG BAMBOO SHOOTS IN THE CAN."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MAKING THE MOLDED FIGURE BY THE METAL."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MIDDLE-MERCHANT OF OLD-ITEMS BUSINESS."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="MIDDLE-MERCHANT OF SELLING MANGOES BUSINESS"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="OPEN THE SHOP IN THE SCHOOL."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="POLISHING GEMS"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="REPAIR SHOES"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="REPAIRING ELECTRIC STUFFS"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="ROOM FOR RENT"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="SELL BOILED BEAN AND CORN."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="SELL FRESH VEGETABLES"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="SELL ICE-CREAM"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="SELL PETROL"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="SELL THE VEGETABLES"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="SELLING"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="SELLING FLOWER, DECORATING TREE"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="SELLING JAR"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="SELLING LOCAL SWEET"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="SELLING LOTTERY"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="SILK WEAVING"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="SNOOKER CLUB (SNOOKER TABLE)"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="SOUND EQUIPMENTS FOR HIRING"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="TAILING SHOP"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="THE BRASS BAND SERVICE."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="TO BE HIRED TO DELIVER FERTILIZER."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="TO BE HIRED TO DELIVER SUGAR-CANE BUSINESS."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="TO BE HIRED TO DRIVE 6 WHEELS TRUCK BUSINESS"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="TRUCK DRIVER"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="VAN SERVICE"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="VENDING"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="WEAVE THAI-LOCAL CLOTH"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="WIRE THE ELECTRICITY IN BUILDING."
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="WORK AS CONSTRUCTION WORKER."

replace hhbus=0 if nonfarm==0
replace hhbus=. if nonfarm==. & hhbus!=0

*Type of business
replace ba3a=. if ba3a==.c
g typeofbus=ba3a if hhbus==1

*Sector of the firm:
*Firm is in retail trade
g retail=(ba3a==1 | ba3a==17) if hhbus==1
replace retail=1 if hhbus==1 & ba3a==21 & (ba3ao2=="BOUGHT THE OLD GOODS TO SALE AS A SECOND HAND." | ba3ao2=="BUY THE OLD GOODS FOR SELL." | ba3ao2=="BUYING AND SELLING OLD THINGS" | ba3ao2=="DIRECT-SALE OF MISTEEN COSMETIC." | ba3ao2=="DIRECT-SALE ON COSMETIC BUSINESS." | ba3ao2=="MIDDLE-MERCHANT OF OLD-ITEMS BUSINESS." | ba3ao2=="MIDDLE-MERCHANT OF SELLING MANGOES BUSINESS"| ba3ao2=="SELL FRESH VEGETABLES" | ba3ao2=="SELLING" | ba3ao2=="SELLING FLOWER, DECORATING TREE" | ba3ao2=="SELLING JAR" | ba3ao2=="SELLING LOTTERY" | ba3ao2=="SELL PETROL" | ba3ao2=="SELL THE VEGETABLES" | ba3ao2=="VENDING")

*Firm is in manufacturing sector
g manuf=(ba3a==21 & (ba3ao2=="ARTISAN" | ba3ao2=="CLOTH MAKING" | ba3ao2=="CUT RUBY" | ba3ao2=="DRESSMAKER"  | ba3ao2=="EMBROIDERY" | ba3ao2=="EMBROIDERY WORK" | ba3ao2=="LOCAL HANDICRAFT" | ba3ao2=="MAKE BROOM STICKS"  | ba3ao2=="MAKE BROOMS" | ba3ao2=="MAKE FISHERY EQUIPMENTS" | ba3ao2=="MAKE GRASS-ROOF" | ba3ao2=="MAKE THE GRASS-ROOF." | ba3ao2=="MAKING BROOM" | ba3ao2=="MAKING CHOP STICKS" | ba3ao2=="MAKING DRINKING WATER" | ba3ao2=="MAKING FOODS SHELF. SIDEBOARD" | ba3ao2=="MAKING IRON DOOR AND WINDOW" | ba3ao2=="MAKING ROOF-SHEET FROM PALM LEAVES" | ba3ao2=="MAKING THE BOILED YOUNG BAMBOO SHOOTS IN THE CAN." | ba3ao2=="MAKING THE MOLDED FIGURE BY THE METAL." | ba3ao2=="POLISHING GEMS" | ba3ao2=="SILK WEAVING" | ba3ao2=="TAILING SHOP" | ba3ao2=="WEAVE THAI-LOCAL CLOTH")) if hhbus==1

*Firm is in service sector
g services=(ba3a==3 | ba3a==5 | ba3a==15 | ba3a==19) if hhbus==1
replace services=1 if hhbus==1 & ba3a==21 & (ba3ao2=="COOKING CAKE FOR SALE"| ba3ao2=="DRIVE PICK-UP CAR TO DELIVER STUDENTS." | ba3ao2=="DRIVER TO DELIVER CHICKEN-FOOD." | ba3ao2=="DRIVER TO DELIVER SUGAR-CANE" | ba3ao2=="DRIVER TO TRANSPORT STUDENTS" | ba3ao2=="DRIVING HIRED MOTORCYCLE" | ba3ao2=="HIRED MOTORCYCLE" | ba3ao2=="HIRED-TRICYCLE DRIVER" | ba3ao2=="HIRED-TRICYCLES DRIVER" | ba3ao2=="MAKE MANGO-DESSERT TO SELL"  | ba3ao2=="MAKING SWEET" | ba3ao2=="REPAIR SHOES" | ba3ao2=="REPAIRING ELECTRIC STUFFS" | ba3ao2=="ROOM FOR RENT" | ba3ao2=="SELL BOILED BEAN AND CORN." | ba3ao2=="SELL ICE-CREAM" | ba3ao2=="SELLING LOCAL SWEET" | ba3ao2=="SNOOKER CLUB (SNOOKER TABLE)" | ba3ao2=="SOUND EQUIPMENTS FOR HIRING" | ba3ao2=="TO BE HIRED TO DELIVER FERTILIZER." | ba3ao2=="TO BE HIRED TO DELIVER SUGAR-CANE BUSINESS." | ba3ao2=="TO BE HIRED TO DRIVE 6 WHEELS TRUCK BUSINESS" | ba3ao2=="TRUCK DRIVER" | ba3ao2=="VAN SERVICE" | ba3ao2=="WIRE THE ELECTRICITY IN BUILDING.")

*Firm is in other sector
g othersector=(retail==0 & manuf==0 & services==0) if hhbus==1 

replace othersector=. if hhbus==1  & ba3a==21 & (ba3ao2=="ICE CUBE SHOP" | ba3ao2=="MAKER BOILED THE YOUNG BAMBOO SHOOT."| ba3ao2=="OPEN THE SHOP IN THE SCHOOL.")
replace services=. if hhbus==1  & ba3a==21 & (ba3ao2=="ICE CUBE SHOP" | ba3ao2=="MAKER BOILED THE YOUNG BAMBOO SHOOT." | ba3ao2=="OPEN THE SHOP IN THE SCHOOL.")
replace manuf=. if hhbus==1  & ba3a==21 & (ba3ao2=="ICE CUBE SHOP" | ba3ao2=="MAKER BOILED THE YOUNG BAMBOO SHOOT." | ba3ao2=="OPEN THE SHOP IN THE SCHOOL.")
replace retail=. if hhbus==1  & ba3a==21 & (ba3ao2=="ICE CUBE SHOP" | ba3ao2=="MAKER BOILED THE YOUNG BAMBOO SHOOT." |  ba3ao2=="OPEN THE SHOP IN THE SCHOOL.")

*Age of the firm in years
replace ba4=. if ba4==-99 
g agefirm=ba4 if hhbus==1 

*Number of paid employees
g employees=ba12 if hhbus==1 

g totalworkers=ba9 if hhbus==1 

keep newid reasonforclosure wave-totalworkers
*TO DO: decide whether you need/want to change path for saving TTHAI4
/**/
save TTHAI4, replace
/**/

*TO DO: change path to where you saved the following file "hh00_16in_tab1.dta" of the 2000 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2000/hh00_16in_tab1.dta", clear
/**/

*Business sales in last month
keep if number=="N" | number=="O" | number=="P" | number=="Q" | number=="R" | number=="S" | number=="U" | number=="AA"
replace in4=0 if in2==3
replace in4=. if in4==.c
bysort newid: egen sales=total(in4), m
*Since sales are given for past 12 months:
replace sales=sales/12

keep newid sales
duplicates drop


*TO DO: change path to where you saved the following file "TTHAI4.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI4, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving TTHAI4
/**/
save TTHAI4, replace
/**/

*TO DO: change path to where you saved the following file "hh00_16in.dta" of the 2000 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2000/hh00_16in.dta", clear
/**/

g expenses=in10b/12 

keep newid expenses

*TO DO: change path to where you saved the following file "TTHAI4.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI4, nogenerate
/**/

g profits=sales-expenses if hhbus==1

*TO DO: decide whether you need/want to change path for saving TTHAI4
/**/
save TTHAI4, replace
/**/

*TO DO: change path to where you saved the following file "hh00_01cvr.dta" of the 2000 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2000/hh00_01cvr.dta", clear
/**/

*Marital status of owner
*Since the marital status is only given for household heads, I can only compute it for head and their spouses
g help=1 if cvr7==1 | cvr7==3 
g married=(cvr11==3) if help==1 & cvr11!=-8
drop help

keep newid married

*TO DO: change path to where you saved the following file "TTHAI4.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI4, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving TTHAI4
/**/
save TTHAI4, replace
/**/

*TO DO: change path to where you saved the following file "hh00_04hc_tab1.dta" of the 2000 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2000/hh00_04hc_tab1.dta", clear
/**/

*Age of owner
g ownerage=hc5

*Gender of owner
g female=(hc4==3) if hc4!=.

*Education of owner
g ownertertiary=(hc7==47 | hc7==49 | hc7==51 | hc7==53) if hc7!=. & hc7!=-999 & hc7!=-888

*Years of education
*I assume the number is the years of education and calculate 6 years for primary and 6 years for secondary
*Sources: 	https://en.wikipedia.org/wiki/Education_in_Thailand
*			http://open_jicareport.jica.go.jp/pdf/11548013.pdf
g educyears=0 if hc7==1 | hc7==3 | hc7==5 | hc7==7 | hc7==9
replace educyears=1 if hc7==11
replace educyears=2 if hc7==13
replace educyears=3 if hc7==15
replace educyears=4 if hc7==17
replace educyears=5 if hc7==19
replace educyears=6 if hc7==21
replace educyears=7 if hc7==23
replace educyears=7 if hc7==25
replace educyears=8 if hc7==27
replace educyears=9 if hc7==29
replace educyears=10 if hc7==31 | hc7==41
replace educyears=11 if hc7==33 | hc7==43
replace educyears=12 if hc7==35 | hc7==45
replace educyears=13 if hc7==37 | hc7==47 | hc7==51 | hc7==55
replace educyears=14 if hc7==39 | hc7==49 | hc7==53 | hc7==57
replace educyears=15 if hc7==59
replace educyears=16 if hc7==61

*Child under 5 in household
g under5=0
replace under5=. if hc5==. 
replace under5=1 if hc5<5 
bysort newid: egen childunder5=max(under5)
drop under5

*Child aged 5 to 12 in household
g aged5to12=0
replace aged5to12=. if  hc5==. 
replace aged5to12=1 if  hc5>=5 &  hc5<12
bysort newid: egen childaged5to12=max(aged5to12)
drop aged5to12

*Has adult aged 65+ in the household
g is65orover=0
replace is65orover=. if hc5==. 
replace is65orover=1 if hc5>=65 & hc5!=. 
bysort newid: egen adult65andover=max(is65orover)
drop is65orover

keep newid number ownerage-adult65andover

*TO DO: change path to where you saved the following file "hh00_05oc_tab1.dta" of the 2000 annual household resurvey
/*EXAMPLE:*/
merge 1:1 newid number using "Townsend Thai Project/2000/hh00_05oc_tab1.dta", nogenerate
/**/

g businessowner=(oc1b==1) if oc1b!=. & oc1b!=.c & oc1b!=.b

/*I code individuals as wage workers if the type of employment reported is either:
 - employee - daily wages, or
 - employee - monthly wages, or
 - government worker.
 I do not consider individuals to be wage workers if the type of employment reported is either:
 - owner of business, or
 - unpaid family worker, or
 - employee - piece rate, in house, or
 - employee - piece rate, out of house, or
 - other.
*/

*Worked as wage worker in last month
g wageworker=(oc1b==5 | oc1b==7 | oc1b==13) if oc1b!=. & oc1b!=.c & oc1b!=.b

*Labor earnings in last month
*Replace missing values:
replace oc1c=. if oc1c==.b | oc1c==.c | oc1c==.y
g laborincome=oc1c if oc1b==7 | oc1b==13
*For government workers it is not clear if the wages are given on a daily or monthly frequency, but I assume from the values that they are monthly
*In case wages are given for a daily frequency, I multiply them with 20 to have monthly wages:
replace laborincome=oc1c*20 if oc1b==5

*Retired
g retired=(oc1a==1) if  oc1a!=.

keep newid number ownerage- adult65andover businessowner wageworker laborincome retired

*TO DO: change path to where you saved the following file "TTHAI4.dta"
/*EXAMPLE:*/
merge m:1 newid using TTHAI4, nogenerate 
/**/

g hhbusowner=(businessowner==1) if hhbus==1 & businessowner!=.

drop businessowner

duplicates tag newid hhbusowner if hhbus==1 & hhbusowner==1, gen(totalowners)
replace totalowners=totalowners+1

g jointbus=(totalowners>1) if hhbus==1 & totalowners!=.

*TO DO: decide whether you need/want to change path for saving TTHAI4
/**/
save TTHAI4, replace
/**/

*Household consumption
*TO DO: change path to where you saved the following file "hh00_04hc.dta" of the 2000 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2000/hh00_04hc.dta", clear
/**/
keep newid hc1

*TO DO: change path to where you saved the following file "hh00_15ex.dta" of the 2000 annual household resurvey
/*EXAMPLE:*/
merge 1:1 newid using "Townsend Thai Project/2000/hh00_15ex.dta", nogenerate
/**/
*TO DO: change path to where you saved the following file "hh00_15ex_tab1.dta" of the 2000 annual household resurvey
/*EXAMPLE:*/
merge 1:m newid using "Townsend Thai Project/2000/hh00_15ex_tab1.dta", nogenerate 
/**/
replace ex4=. if ex4==.b | ex4==.c | ex4==.y

bysort newid: egen monthlyexp=total(ex4),m

keep newid monthlyexp hc1 ex5-ex9
duplicates drop

replace monthlyexp=12*monthlyexp
egen hh_exp=rowtotal(monthlyexp ex5-ex9), missing

g pcexpend=hh_exp/hc1

drop monthlyexp hh_exp hc1 ex5-ex9

*TO DO: change path to where you saved the following file "TTHAI4.dta"
/*EXAMPLE:*/
merge 1:m newid using TTHAI4, nogenerate 
/**/

*Exchange rate for approximate midpoint of survey period
/*According to the documentation, the data was collected in May 2000, so I use May 15
 as approximate midpoint for the exchange rate*/

g excrate=0.02569

g excratemonth="5-2000"


foreach var of varlist ownerage ownertertiary educyears married childunder5 childaged5to12 adult65andover wageworker laborincome retired sales reasonforclosure wave surveyyear hhbusclosure typeofbusclosed hhbus enf_bus newfirmquex tbdropped nonfarm typeofbus retail manuf services othersector agefirm employees totalworkers expenses profits hhbusowner totalowners jointbus pcexpend excrate excratemonth{ 
rename `var' `var'_2000
} 

rename number hc_id
*TO DO: decide whether you need/want to change path for saving TTHAI4
/**/
save TTHAI4, replace
/**/

*TO DO: change path to where you saved the following file "TTHAImaster.dta"
/*EXAMPLE:*/
use TTHAImaster,clear
/**/

*TO DO: change path to where you saved the following file "TTHAI4.dta"
/*EXAMPLE:*/
merge 1:1 newid hc_id using TTHAI4, gen(_merge3) update
/**/

*TO DO: decide whether you need/want to change path for saving TTHAImaster
/**/
save TTHAImaster, replace
/**/
********************************************************************************
*Round 5
********************************************************************************
*TO DO: change path to where you saved the following file "hh01_13ba.dta" of the 2001 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2001/hh01_13ba.dta", clear
/**/

*Survey round number
g wave=5

*Year survey took place
g surveyyear=2001

*Business closure in past 12 months
g hhbusclosure=(ba1a==1) if (ba1a==1 | ba1a==3) & ba1a!=.c

/*Although the questionnaire asks for reasons, the business was closed (question ba1c),
this variable is not in the dataset and also not in the codebook file*/
replace ba1b=. if ba1b==.c
g typeofbusclosed=ba1b

*I keep the open ended reasons for closure as for now to be able to decide later on appropriate coding
rename ba1c reasonforclosure

*Household operates a business
g hhbus=(ba1d==1) if ba1d!=.c

*TO DO: decide whether you need/want to change path for saving TTHAI5
/**/
save TTHAI5, replace 
/**/

*TO DO: change path to where you saved the following file "hh01_13ba_tab1.dta" of the 2001 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2001/hh01_13ba_tab1.dta", clear
/**/

/*Only keep the information for the first business as I will only consider businesses
 of households who have only one business:*/
keep if bnumber==1

*TO DO: change path to where you saved the following file "TTHAI5.dta" 
/*EXAMPLE:*/
merge 1:1 newid using TTHAI5, nogenerate
/**/

*Household entirely owns household business
replace ba2=0 if hhbus==0

g enf_bus=(ba6==1) if ba6!=.

*Household entirely owns household business
*Business founded in last 12 months:
g newfirmquex=(ba21a==1) if ba21a!=.

/*I will only consider household enterprises if the household operates only one 
enterprise and if this enterprise is entirely owned by the household:*/
g tbdropped=(ba2>1) if ba2!=.c | enf_bus!=1

*Since the questionnaire mixes non-farm and farm enterprises:
g nonfarm=(ba3a==1 | ba3a==3 | ba3a==5 | ba3a==15 | ba3a==17 | ba3a==19) if hhbus==1 & ba3a!=.c

replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="10 wheels truck driver"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="artisan, basket, fish cage"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="canned bamboo"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="cloth decorating"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="cloth making"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="construction"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="cutting and polishing factory"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="direct selling"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="direct selling cosmetic"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="furniture making"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="gems polishing"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="handicraft"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="hiring for transportation of fertilizer"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="hiring for transportation of sugar cane"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="land-fill service"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making babecued stick"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making broom"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making broom from coconut leaves"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making canned bamboo"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making cloth"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making container of replicated flowers"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making floor-mat"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making garland"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making grass-roof"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making military uniform"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making replicated statue from steel"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making roof structure, fence, door"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making stick for broom"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making sweet"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="motor-tricycle driver"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="motor-tricycle for hiring"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="motorcycle driver for hiring"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="music band for hiring"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="painting service"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="pick-up truck driver for transportation of factory labor"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="purchasing and selling old things"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="repairing electric applicants"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="room for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="selling boiled peanut and corn"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="selling flowers and decorated trees"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="selling foods in school"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="selling fresh milk"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="selling gasoline"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="selling icecream"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="selling jar"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="selling lottery"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="selling sweet"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="selling vegetables"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="shoes reparing"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="silk weaving"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="snooker"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="tailor shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="trading"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="transportation of school students"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="truck driver for distribution of chicken feeds"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="truck driver for distribution of fertilizer"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="truck driver for suagr cane"

replace hhbus=0 if nonfarm==0
replace hhbus=. if nonfarm==. & hhbus!=0

*Type of business
replace ba3a=. if ba3a==.c
g typeofbus=ba3a if hhbus==1

*Sector of the firm:
*Firm is in retail trade
g retail=(ba3a==1 | ba3a==17) if hhbus==1
replace retail=1 if hhbus==1 & ba3a==21 & (ba3ao2=="direct selling" | ba3ao2=="direct selling cosmetic" | ba3ao2=="purchasing and selling old things"| ba3ao2=="selling flowers and decorated trees" | ba3ao2=="selling fresh milk" | ba3ao2=="selling gasoline" | ba3ao2=="selling icecream" | ba3ao2=="selling jar" | ba3ao2=="selling lottery" | ba3ao2=="selling vegetables" | ba3ao2=="trading")

*Firm is in manufacturing sector
g manuf=(ba3a==21 & (ba3ao2=="artisan, basket, fish cage" | ba3ao2=="canned bamboo" | ba3ao2=="cloth decorating" | ba3ao2=="cloth making" | ba3ao2=="cutting and polishing factory" | ba3ao2=="furniture making" | ba3ao2=="gems polishing" | ba3ao2=="handicraft"| ba3ao2=="making broom" | ba3ao2=="making broom from coconut leaves" | ba3ao2=="making canned bamboo" | ba3ao2=="making cloth" | ba3ao2=="making container of replicated flowers" | ba3ao2=="making floor-mat" | ba3ao2=="making garland" | ba3ao2=="making grass-roof" | ba3ao2=="making military uniform" | ba3ao2=="making replicated statue from steel" | ba3ao2=="making roof structure, fence, door" | ba3ao2=="making stick for broom" | ba3ao2=="silk weaving" | ba3ao2=="tailor shop")) if hhbus==1

*Firm is in service sector
g services=(ba3a==3 | ba3a==5 | ba3a==15 | ba3a==19) if hhbus==1
replace services=1 if hhbus==1 & ba3a==21 & (ba3ao2=="10 wheels truck driver" | ba3ao2=="hiring for transportation of fertilizer" | ba3ao2=="hiring for transportation of sugar cane" | ba3ao2=="making sweet" | ba3ao2=="motor-tricycle driver" | ba3ao2=="motor-tricycle for hiring" | ba3ao2=="motorcycle driver for hiring" | ba3ao2=="music band for hiring" | ba3ao2=="pick-up truck driver for transportation of factory labor" | ba3ao2=="repairing electric applicants" | ba3ao2=="room for rent"  | ba3ao2=="selling boiled peanut and corn"  | ba3ao2=="selling foods in school"  | ba3ao2=="selling sweet" |  ba3ao2=="shoes reparing" | ba3ao2=="snooker" | ba3ao2=="transportation of school students" | ba3ao2=="truck driver for distribution of chicken feeds" | ba3ao2=="truck driver for distribution of fertilizer" | ba3ao2=="truck driver for suagr cane")

*Firm is in other sector
g othersector=(retail==0 & manuf==0 & services==0) if hhbus==1 

replace othersector=. if hhbus==1  & ba3ao2=="making babecued stick"
replace services=. if hhbus==1  & ba3ao2=="making babecued stick"
replace manuf=. if hhbus==1  & ba3ao2=="making babecued stick"
replace retail=. if hhbus==1  & ba3ao2=="making babecued stick"


*Age of the firm in years
replace ba4=. if ba4==-99 
g agefirm=ba4 if hhbus==1 

*Number of paid employees
g employees=ba12 if hhbus==1 

g totalworkers=ba9 if hhbus==1 

keep newid reasonforclosure wave-totalworkers
*TO DO: decide whether you need/want to change path for saving TTHAI5
/**/
save TTHAI5, replace
/**/

*TO DO: change path to where you saved the following file "hh01_16in_tab1.dta" of the 2001 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2001/hh01_16in_tab1.dta", clear
/**/

*Business sales in last month
keep if number=="N" | number=="O" | number=="P" | number=="Q" | number=="R" | number=="S" | number=="U" | number=="AA"
replace in4=0 if in2==3
replace in4=. if in4==.c
bysort newid: egen sales=total(in4), m
*Since sales are given for past 12 months:
replace sales=sales/12

keep newid sales
duplicates drop

*TO DO: change path to where you saved the following file "TTHAI5.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI5, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving TTHAI5
/**/
save TTHAI5, replace
/**/

*TO DO: change path to where you saved the following file "hh01_16in.dta" of the 2001 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2001/hh01_16in.dta", clear
/**/

g expenses=in10b/12 

keep newid expenses

*TO DO: change path to where you saved the following file "TTHAI5.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI5, nogenerate
/**/

g profits=sales-expenses if hhbus==1

*TO DO: decide whether you need/want to change path for saving TTHAI5
/**/
save TTHAI5, replace
/**/

*TO DO: change path to where you saved the following file "hh01_01cvr.dta" of the 2001 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2001/hh01_01cvr.dta", clear
/**/

*Marital status of owner
*Since the marital status is only given for household heads, I can only compute it for head and their spouses
g help=1 if cvr7==1 | cvr7==3 
g married=(cvr11==3) if help==1 & cvr11!=-8
drop help

keep newid married

*TO DO: change path to where you saved the following file "TTHAI5.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI5, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving TTHAI5
/**/
save TTHAI5, replace
/**/

*TO DO: change path to where you saved the following file "hh01_04hc_tab1.dta" of the 2001 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2001/hh01_04hc_tab1.dta", clear
/**/

*Age of owner
g ownerage=hc5

*Gender of owner
g female=(hc4==3) if hc4!=.

*Education of owner
g ownertertiary=(hc7==47 | hc7==49 | hc7==51 | hc7==53) if hc7!=. & hc7!=-999 & hc7!=-888

*Years of education
*I assume the number is the years of education and calculate 6 years for primary and 6 years for secondary
*Sources: 	https://en.wikipedia.org/wiki/Education_in_Thailand
*			http://open_jicareport.jica.go.jp/pdf/11548013.pdf
g educyears=0 if hc7==1 | hc7==3 | hc7==5 | hc7==7 | hc7==9
replace educyears=1 if hc7==11
replace educyears=2 if hc7==13
replace educyears=3 if hc7==15
replace educyears=4 if hc7==17
replace educyears=5 if hc7==19
replace educyears=6 if hc7==21
replace educyears=7 if hc7==23
replace educyears=7 if hc7==25
replace educyears=8 if hc7==27
replace educyears=9 if hc7==29
replace educyears=10 if hc7==31 | hc7==41
replace educyears=11 if hc7==33 | hc7==43
replace educyears=12 if hc7==35 | hc7==45
replace educyears=13 if hc7==37 | hc7==47 | hc7==51 | hc7==55
replace educyears=14 if hc7==39 | hc7==49 | hc7==53 | hc7==57
replace educyears=15 if hc7==59
replace educyears=16 if hc7==61

*Child under 5 in household
g under5=0
replace under5=. if hc5==. 
replace under5=1 if hc5<5 
bysort newid: egen childunder5=max(under5)
drop under5

*Child aged 5 to 12 in household
g aged5to12=0
replace aged5to12=. if  hc5==. 
replace aged5to12=1 if  hc5>=5 &  hc5<12
bysort newid: egen childaged5to12=max(aged5to12)
drop aged5to12

*Has adult aged 65+ in the household
g is65orover=0
replace is65orover=. if hc5==. 
replace is65orover=1 if hc5>=65 & hc5!=. 
bysort newid: egen adult65andover=max(is65orover)
drop is65orover

keep newid number ownerage-adult65andover

*TO DO: change path to where you saved the following file "hh01_05oc_tab1.dta" of the 2001 annual household resurvey
/*EXAMPLE:*/
merge 1:1 newid number using "Townsend Thai Project/2001/hh01_05oc_tab1.dta", nogenerate
/**/

g businessowner=(oc1b==1) if oc1b!=. & oc1b!=.c & oc1b!=.b

/*I code individuals as wage workers if the type of employment reported is either:
 - employee - daily wages, or
 - employee - monthly wages, or
 - government worker.
 I do not consider individuals to be wage workers if the type of employment reported is either:
 - owner of business, or
 - unpaid family worker, or
 - employee - piece rate, in house, or
 - employee - piece rate, out of house, or
 - other.
*/

*Worked as wage worker in last month
g wageworker=(oc1b==5 | oc1b==7 | oc1b==13) if oc1b!=. & oc1b!=.c & oc1b!=.b

*Labor earnings in last month
*Replace missing values:
replace oc1c=. if oc1c==.b | oc1c==.c | oc1c==.y
g laborincome=oc1c if oc1b==7 | oc1b==13
*For government workers it is not clear if the wages are given on a daily or monthly frequency, but I assume from the values that they are monthly
*In case wages are given for a daily frequency, I multiply them with 20 to have monthly wages:
replace laborincome=oc1c*20 if oc1b==5

*Retired
g retired=(oc1a==1) if  oc1a!=.

keep newid number ownerage-adult65andover businessowner wageworker laborincome retired

*TO DO: change path to where you saved the following file "TTHAI5.dta"
/*EXAMPLE:*/
merge m:1 newid using TTHAI5, nogenerate 
/**/

g hhbusowner=(businessowner==1) if hhbus==1 & businessowner!=.

drop businessowner

duplicates tag newid hhbusowner if hhbus==1 & hhbusowner==1, gen(totalowners)
replace totalowners=totalowners+1

g jointbus=(totalowners>1) if hhbus==1 & totalowners!=.

*TO DO: decide whether you need/want to change path for saving TTHAI5
/**/
save TTHAI5, replace
/**/

*Household consumption
*TO DO: change path to where you saved the following file "hh01_04hc.dta" of the 2001 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2001/hh01_04hc.dta", clear
/**/
keep newid hc1

*TO DO: change path to where you saved the following file "hh01_15ex.dta" of the 2001 annual household resurvey
/*EXAMPLE:*/
merge 1:1 newid using "Townsend Thai Project/2001/hh01_15ex.dta", nogenerate
/**/
*TO DO: change path to where you saved the following file "hh01_15ex_tab1.dta" of the 2001 annual household resurvey
/*EXAMPLE:*/
merge 1:m newid using "Townsend Thai Project/2001/hh01_15ex_tab1.dta", nogenerate
/**/
replace ex4=. if ex4==.b | ex4==.c | ex4==.y

bysort newid: egen monthlyexp=total(ex4),m

keep newid monthlyexp hc1 ex5-ex9
duplicates drop

replace monthlyexp=12*monthlyexp
egen hh_exp=rowtotal(monthlyexp ex5-ex9), missing

g pcexpend=hh_exp/hc1

drop monthlyexp hh_exp hc1 ex5-ex9

*TO DO: change path to where you saved the following file "TTHAI5.dta"
/*EXAMPLE:*/
merge 1:m newid using TTHAI5, nogenerate
/**/

*Exchange rate for approximate midpoint of survey period
/*According to the documentation, the data was collected in May 2001, so I use May 15
 as approximate midpoint for the exchange rate*/

g excrate=0.02193

g excratemonth="5-2001"


foreach var of varlist ownerage ownertertiary educyears married childunder5 childaged5to12 adult65andover wageworker laborincome retired sales reasonforclosure wave surveyyear hhbusclosure typeofbusclosed hhbus enf_bus newfirmquex tbdropped nonfarm typeofbus retail manuf services othersector agefirm employees totalworkers expenses profits hhbusowner totalowners jointbus pcexpend excrate excratemonth{ 
rename `var' `var'_2001
} 

rename number hc_id
*TO DO: decide whether you need/want to change path for saving TTHAI5
/**/
save TTHAI5, replace
/**/

*TO DO: change path to where you saved the following file "TTHAImaster.dta"
/*EXAMPLE:*/
use TTHAImaster,clear
/**/

*TO DO: change path to where you saved the following file "TTHAI5"
/*EXAMPLE:*/
merge 1:1 newid hc_id using TTHAI5, gen(_merge4) update
/**/

*TO DO: decide whether you need/want to change path for saving TTHAImaster
/**/
save TTHAImaster, replace
/**/

********************************************************************************
*Round 6
********************************************************************************
*TO DO: change path to where you saved the following file "hh02_13ba.dta" of the 2002 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2002/hh02_13ba.dta", clear
/**/

*Survey round number
g wave=6

*Year survey took place
g surveyyear=2002

*Business closure in past 12 months
g hhbusclosure=(ba1a==1) if (ba1a==1 | ba1a==3) & ba1a!=.c

/*Although the questionnaire asks for reasons, the business was closed (question ba1c),
this variable is not in the dataset and also not in the codebook file*/
replace ba1b=. if ba1b==.c
g typeofbusclosed=ba1b

*I keep the open ended reasons for closure as for now to be able to decide later on appropriate coding
rename ba1c reasonforclosure

*Household operates a business
g hhbus=(ba1d==1) if ba1d!=.c

*TO DO: decide whether you need/want to change path for saving TTHAI6
/**/
save TTHAI6, replace 
/**/

*TO DO: change path to where you saved the following file "hh02_13ba_tab1.dta" of the 2002 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2002/hh02_13ba_tab1.dta", clear
/**/

/*Only keep the information for the first business as I will only consider businesses
 of households who have only one business:*/
keep if bnumber==1

merge 1:1 newid using TTHAI6, nogenerate

*Household entirely owns household business
replace ba2=0 if hhbus==0

g enf_bus=(ba6==1) if ba6!=.

*Household entirely owns household business
*Business founded in last 12 months:
g newfirmquex=(ba21a==1) if ba21a!=.

/*I will only consider household enterprises if the household operates only one 
enterprise and if this enterprise is entirely owned by the household:*/
g tbdropped=(ba2>1) if ba2!=.c | enf_bus!=1

*Since the questionnaire mixes non-farm and farm enterprises:
g nonfarm=(ba3a==1 | ba3a==3 | ba3a==5 | ba3a==15 | ba3a==17 | ba3a==19) if hhbus==1 & ba3a!=.c

replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="artcian"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="artician"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buying old things"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buying-selling old things"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="canned bamboo shoot"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="constracting for construction"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="constracting for filling land"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="constracting for making iron works(roof,door)"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="cutting germs"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="direct sale business"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="direct sale cosmetics"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="driver of delivery students"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="driver of delivery workers"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="drivery food for chicken"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="embroidering clothes"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="food vendor"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="furnishing factory"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="hired for delivery fertilizer"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="hired for delivery sugar cane,cassava"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="hired of delivery fertilizer"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="hired of delivery sugar cane"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="hired of motorcycle driver"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="hired of ten-wheels truck driver"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="hired of tricycle driver"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="local handicraft"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="local handicraft from wood"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making broom"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making broom's haddle"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making cake"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making canned bamboo shoot"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making chicken's coop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making clothes"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making dessert"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making furniture"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making garland"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making grass-roof for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making iron door"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making sticks for roasted chicken"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making stripes on broom's haddle"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="music band for hiring"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="nitting clothes service"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="rent room"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="repairing electric equipment"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="repairing shoes"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of boiled groundnut and corn"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of cosmetic"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of cupboard and wardrobe"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of decorated plant"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of dessert"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of fruits"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of goods"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of jar"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of lottery"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of mango"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of oil"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of old things"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of silk"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of vegetables"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sawing wood"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="snooker table"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="tailor"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="transporting student"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="video game shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="weaving fishnet"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="weaving invented silk"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="weaving silk colth"

replace hhbus=0 if nonfarm==0
replace hhbus=. if nonfarm==. & hhbus!=0

*Type of business
replace ba3a=. if ba3a==.c
g typeofbus=ba3a if hhbus==1

*Sector of the firm:
*Firm is in retail trade
g retail=(ba3a==1 | ba3a==17) if hhbus==1
replace retail=1 if hhbus==1 & ba3a==21 & (ba3ao2=="buying old things" | ba3ao2=="buying-selling old things" | ba3ao2=="direct sale business" | ba3ao2=="direct sale cosmetics" | ba3ao2=="sale of cosmetic" | ba3ao2=="sale of cupboard and wardrobe" | ba3ao2=="sale of decorated plant" | ba3ao2=="sale of fruits" | ba3ao2=="sale of goods" | ba3ao2=="sale of jar" | ba3ao2=="sale of lottery" | ba3ao2=="sale of mango" | ba3ao2=="sale of oil" | ba3ao2=="sale of old things" | ba3ao2=="sale of silk" | ba3ao2=="sale of vegetables")

*Firm is in manufacturing sector
g manuf=(ba3a==21 & (ba3ao2=="canned bamboo shoot" | ba3ao2=="constracting for making iron works(roof,door)" | ba3ao2=="cutting germs" | ba3ao2=="embroidering clothes" | ba3ao2=="furnishing factory" | ba3ao2=="local handicraft" | ba3ao2=="local handicraft from wood" | ba3ao2=="making broom" | ba3ao2=="making broom's haddle" | ba3ao2=="making canned bamboo shoot" | ba3ao2=="making chicken's coop" | ba3ao2=="making clothes" | ba3ao2=="making furniture" | ba3ao2=="making garland" | ba3ao2=="making grass-roof for sale" | ba3ao2=="making iron door" | ba3ao2=="making sticks for roasted chicken" | ba3ao2=="making stripes on broom's haddle" | ba3ao2=="nitting clothes service" |  ba3ao2=="tailor" | ba3ao2=="weaving fishnet" | ba3ao2=="weaving invented silk" | ba3a==21 & ba3ao2=="weaving silk colth")) if hhbus==1

*Firm is in service sector
g services=(ba3a==3 | ba3a==5 | ba3a==15 | ba3a==19) if hhbus==1
replace services=1 if hhbus==1 & ba3a==21 & (ba3ao2=="driver of delivery students" | ba3ao2=="driver of delivery workers" | ba3ao2=="drivery food for chicken" | ba3ao2=="food vendor" | ba3ao2=="hired for delivery fertilizer" | ba3ao2=="hired for delivery sugar cane,cassava" | ba3ao2=="hired of delivery fertilizer" | ba3ao2=="hired of delivery sugar cane" | ba3ao2=="hired of motorcycle driver" | ba3ao2=="hired of ten-wheels truck driver" | ba3ao2=="hired of tricycle driver"  | ba3ao2=="making cake" | ba3ao2=="making dessert" | ba3ao2=="music band for hiring" |  ba3ao2=="rent room" | ba3ao2=="repairing electric equipment" | ba3ao2=="repairing shoes" | ba3ao2=="sale of boiled groundnut and corn" | ba3ao2=="sale of dessert" | ba3ao2=="snooker table" | ba3ao2=="transporting student")

*Firm is in other sector
g othersector=(retail==0 & manuf==0 & services==0) if hhbus==1 

replace othersector=. if hhbus==1 & (ba3ao2=="artcian" | ba3ao2=="artician" | ba3ao2=="sawing wood" | ba3ao2=="video game shop")
replace services=. if hhbus==1 & (ba3ao2=="artcian" | ba3ao2=="artician" | ba3ao2=="sawing wood" | ba3ao2=="video game shop")
replace manuf=. if hhbus==1 & (ba3ao2=="artcian" | ba3ao2=="artician" | ba3ao2=="sawing wood" | ba3ao2=="video game shop")
replace retail=. if hhbus==1 & (ba3ao2=="artcian" | ba3ao2=="artician" | ba3ao2=="sawing wood" | ba3ao2=="video game shop")

*Age of the firm in years
replace ba4=. if ba4==-99 
g agefirm=ba4 if hhbus==1 

*Number of paid employees
replace ba12=. if ba12==.c
g employees=ba12 if hhbus==1 

g totalworkers=ba9 if hhbus==1 

keep newid reasonforclosure wave-totalworkers
*TO DO: decide whether you need/want to change path for saving TTHAI6
/**/
save TTHAI6, replace
/**/

*TO DO: change path to where you saved the following file "hh02_16in_tab1.dta" of the 2002 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2002/hh02_16in_tab1.dta", clear
/**/

*Business sales in last month
keep if number=="N" | number=="O" | number=="P" | number=="Q" | number=="R" | number=="S" | number=="U" | number=="AA"
replace in4=0 if in2==3
replace in4=. if in4==.c
bysort newid: egen sales=total(in4), m
*Since sales are given for past 12 months:
replace sales=sales/12

keep newid sales
duplicates drop

*TO DO: change path to where you saved the following file "TTHAI6.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI6, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving TTHAI6
/**/
save TTHAI6, replace
/**/

*TO DO: change path to where you saved the following file "hh02_16in.dta" of the 2002 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2002/hh02_16in.dta", clear
/**/

g expenses=in10b/12 

keep newid expenses

*TO DO: change path to where you saved the following file "TTHAI6.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI6, nogenerate
/**/

g profits=sales-expenses if hhbus==1

*TO DO: decide whether you need/want to change path for saving TTHAI6
/**/
save TTHAI6, replace
/**/

*TO DO: change path to where you saved the following file "hh02_01cvr.dta" of the 2002 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2002/hh02_01cvr.dta", clear
/**/

*Marital status of owner
*Since the marital status is only given for household heads, I can only compute it for head and their spouses
g help=1 if cvr7==1 | cvr7==3 
g married=(cvr11==3) if help==1 & cvr11!=-8
drop help

keep newid married

*TO DO: change path to where you saved the following file "TTHAI6.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI6, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving TTHAI6
/**/
save TTHAI6, replace
/**/

*TO DO: change path to where you saved the following file "hh02_04hc_tab1.dta" of the 2002 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2002/hh02_04hc_tab1.dta", clear
/**/

*Age of owner
g ownerage=hc5

*Gender of owner
g female=(hc4==3) if hc4!=.

*Education of owner
g ownertertiary=(hc7==47 | hc7==49 | hc7==51 | hc7==53) if hc7!=. & hc7!=-999 & hc7!=-888

*Years of education
*I assume the number is the years of education and calculate 6 years for primary and 6 years for secondary
*Sources: 	https://en.wikipedia.org/wiki/Education_in_Thailand
*			http://open_jicareport.jica.go.jp/pdf/11548013.pdf
g educyears=0 if hc7==1 | hc7==3 | hc7==5 | hc7==7 | hc7==9
replace educyears=1 if hc7==11
replace educyears=2 if hc7==13
replace educyears=3 if hc7==15
replace educyears=4 if hc7==17
replace educyears=5 if hc7==19
replace educyears=6 if hc7==21
replace educyears=7 if hc7==23
replace educyears=7 if hc7==25
replace educyears=8 if hc7==27
replace educyears=9 if hc7==29
replace educyears=10 if hc7==31 | hc7==41
replace educyears=11 if hc7==33 | hc7==43
replace educyears=12 if hc7==35 | hc7==45
replace educyears=13 if hc7==37 | hc7==47 | hc7==51 | hc7==55
replace educyears=14 if hc7==39 | hc7==49 | hc7==53 | hc7==57
replace educyears=15 if hc7==59
replace educyears=16 if hc7==61

*Child under 5 in household
g under5=0
replace under5=. if hc5==. 
replace under5=1 if hc5<5 
bysort newid: egen childunder5=max(under5)
drop under5

*Child aged 5 to 12 in household
g aged5to12=0
replace aged5to12=. if  hc5==. 
replace aged5to12=1 if  hc5>=5 &  hc5<12
bysort newid: egen childaged5to12=max(aged5to12)
drop aged5to12

*Has adult aged 65+ in the household
g is65orover=0
replace is65orover=. if hc5==. 
replace is65orover=1 if hc5>=65 & hc5!=. 
bysort newid: egen adult65andover=max(is65orover)
drop is65orover

keep newid number ownerage-adult65andover

*TO DO: change path to where you saved the following file "hh02_05oc_tab1.dta" of the 2002 annual household resurvey
/*EXAMPLE:*/
merge 1:1 newid number using "Townsend Thai Project/2002/hh02_05oc_tab1.dta", nogenerate
/**/

g businessowner=(oc1b==1) if oc1b!=. & oc1b!=.c & oc1b!=.b

/*I code individuals as wage workers if the type of employment reported is either:
 - employee - daily wages, or
 - employee - monthly wages, or
 - government worker.
 I do not consider individuals to be wage workers if the type of employment reported is either:
 - owner of business, or
 - unpaid family worker, or
 - employee - piece rate, in house, or
 - employee - piece rate, out of house, or
 - other.
*/

*Worked as wage worker in last month
g wageworker=(oc1b==5 | oc1b==7 | oc1b==13) if oc1b!=. & oc1b!=.c & oc1b!=.b

*Labor earnings in last month
*Replace missing values:
replace oc1c=. if oc1c==.b | oc1c==.c | oc1c==.y
g laborincome=oc1c if oc1b==7 | oc1b==13
*For government workers it is not clear if the wages are given on a daily or monthly frequency, but I assume from the values that they are monthly
*In case wages are given for a daily frequency, I multiply them with 20 to have monthly wages:
replace laborincome=oc1c*20 if oc1b==5

*Retired
g retired=(oc1a==1) if  oc1a!=.

keep newid number ownerage female ownertertiary educyears childunder5 childaged5to12 adult65andover businessowner wageworker laborincome retired

*TO DO: change path to where you saved the following file "TTHAI6.dta"
/*EXAMPLE:*/
merge m:1 newid using TTHAI6, nogenerate 
/**/

g hhbusowner=(businessowner==1) if hhbus==1 & businessowner!=.

drop businessowner

duplicates tag newid hhbusowner if hhbus==1 & hhbusowner==1, gen(totalowners)
replace totalowners=totalowners+1

g jointbus=(totalowners>1) if hhbus==1 & totalowners!=.

*TO DO: decide whether you need/want to change path for saving TTHAI6
/**/
save TTHAI6, replace
/**/

*Household consumption
*TO DO: change path to where you saved the following file "hh02_04hc.dta" of the 2002 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2002/hh02_04hc.dta", clear
/**/
keep newid hc1

*TO DO: change path to where you saved the following file "hh02_15ex.dta" of the 2002 annual household resurvey
/*EXAMPLE:*/
merge 1:1 newid using "Townsend Thai Project/2002/hh02_15ex.dta", nogenerate
/**/
*TO DO: change path to where you saved the following file "hh02_15ex_tab1.dta" of the 2002 annual household resurvey
/*EXAMPLE:*/
merge 1:m newid using "Townsend Thai Project/2002/hh02_15ex_tab1.dta", nogenerate
/**/
replace ex4=. if ex4==.b | ex4==.c | ex4==.y

bysort newid: egen monthlyexp=total(ex4),m

keep newid monthlyexp hc1 ex5-ex9
duplicates drop

replace monthlyexp=12*monthlyexp
egen hh_exp=rowtotal(monthlyexp ex5-ex9), missing

g pcexpend=hh_exp/hc1

drop monthlyexp hh_exp hc1 ex5-ex9

*TO DO: change path to where you saved the following file "TTHAI6.dta"
/*EXAMPLE:*/
merge 1:m newid using TTHAI6, nogenerate
/**/

*Exchange rate for approximate midpoint of survey period
/*According to the documentation, the data was collected in May 2002, so I use May 15
 as approximate midpoint for the exchange rate*/

g excrate=0.02328

g excratemonth="5-2002"


foreach var of varlist ownerage ownertertiary educyears married childunder5 childaged5to12 adult65andover wageworker laborincome retired sales reasonforclosure wave surveyyear hhbusclosure typeofbusclosed hhbus enf_bus newfirmquex tbdropped nonfarm typeofbus retail manuf services othersector agefirm employees totalworkers expenses profits hhbusowner totalowners jointbus pcexpend excrate*{ 
rename `var' `var'_2002
} 

rename number hc_id
*TO DO: decide whether you need/want to change path for saving TTHAI6
/**/
save TTHAI6, replace
/**/
*TO DO: change path to where you saved the following file "TTHAImaster"
/*EXAMPLE:*/
use TTHAImaster,clear
/**/
*TO DO: change path to where you saved the following file "TTHAI6"
/*EXAMPLE:*/
merge 1:1 newid hc_id using TTHAI6, gen(_merge5) update
/**/
*TO DO: decide whether you need/want to change path for saving TTHAI6
/**/
save TTHAImaster, replace
/**/
********************************************************************************
*Round 7
********************************************************************************
*TO DO: change path to where you saved the following file "hh03_13ba.dta" of the 2003 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2003/hh03_13ba.dta", clear
/**/

*Survey round number
g wave=7

*Year survey took place
g surveyyear=2003

*Business closure in past 12 months
g hhbusclosure=(ba1a==1) if (ba1a==1 | ba1a==3) & ba1a!=.c

/*Although the questionnaire asks for reasons, the business was closed (question ba1c),
this variable is not in the dataset and also not in the codebook file*/
replace ba1b=. if ba1b==.c
g typeofbusclosed=ba1b

*I keep the open ended reasons for closure as for now to be able to decide later on appropriate coding
rename ba1c reasonforclosure

*Household operates a business
g hhbus=(ba1d==1) if ba1d!=.c

*TO DO: decide whether you need/want to change path for saving TTHAI7
/**/
save TTHAI7, replace 
/**/

*TO DO: change path to where you saved the following file "hh03_13ba_tab1.dta" of the 2003 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2003/hh03_13ba_tab1.dta", clear
/**/

/*Only keep the information for the first business as I will only consider businesses
 of households who have only one business:*/
keep if bnumber==1

*TO DO: change path to where you saved the following file "TTHAI7.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI7, nogenerate
/**/

*Household entirely owns household business
replace ba2=0 if hhbus==0

g enf_bus=(ba6==1) if ba6!=.

*Household entirely owns household business
*Business founded in last 12 months:
g newfirmquex=(ba21a==1) if ba21a!=.

/*I will only consider household enterprises if the household operates only one 
enterprise and if this enterprise is entirely owned by the household:*/
g tbdropped=(ba2>1) if ba2!=.c | enf_bus!=1

*Since the questionnaire mixes non-farm and farm enterprises:
g nonfarm=(ba3a==1 | ba3a==3 | ba3a==5 | ba3a==15 | ba3a==17 | ba3a==19) if hhbus==1 & ba3a!=.c

replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="artisan"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="brass band service"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buy-sale  old thing"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buying lod things"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="canned bamboo shoot"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="contracting  for construction"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="contracting construction"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="contracting for construction"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="contracting for land filling"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="direct sell"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="direct sell(cosmetics)"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="driving motorcycle for hiring"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="driving tricycle for hiring"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="furnishing factory"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="installing electric equipments in ritual"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making broom"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making chicken coop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making clothes"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making foods shelf. Sideboard"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making furniture"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making grass-roof sheet for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making handicraft"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making invented flower"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making iron door"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making manure"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making spit chicken"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making stick-gun for fish hunting"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="polishing gems"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="repairing clothes"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="repairing electric stuffs"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="repairing shoes"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="room for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of Rotee"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of bamboo shoots"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of bean and corn"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of chacoal"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of decorating flower,tree"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of dessert"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of fruit"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of grilled chicken"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of handicraft"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of lottery"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of oil"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of old thing"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of silk"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="six wheels and tractor for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="snooker table"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="tailor"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="ten-wheeled truck for hiring"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="transporting gas"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="transporting pick up truck"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="transporting poultry's food"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="transporting school students"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="transporting sugar cane"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="transporting sugar cane,cassava"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="transporting sugar fertilizer"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="transporting worker"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="vdo/cd shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="weaving basket"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="weaving invented silk"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="weaving silk"

replace hhbus=0 if nonfarm==0
replace hhbus=. if nonfarm==. & hhbus!=0

*Type of business
replace ba3a=. if ba3a==.c
g typeofbus=ba3a if hhbus==1

*Sector of the firm:
*Firm is in retail trade
g retail=(ba3a==1 | ba3a==17) if hhbus==1
replace retail=1 if hhbus==1 & ba3a==21 & (ba3ao2=="buy-sale  old thing" | ba3ao2=="buying lod things" | ba3ao2=="direct sell" | ba3ao2=="direct sell(cosmetics)"  |  ba3ao2=="sale of bamboo shoots" | ba3ao2=="sale of bean and corn" | ba3ao2=="sale of chacoal" | ba3ao2=="sale of decorating flower,tree" | ba3ao2=="sale of fruit" | ba3ao2=="sale of handicraft" | ba3ao2=="sale of lottery" | ba3ao2=="sale of oil" | ba3ao2=="sale of old thing" | ba3ao2=="sale of silk")

*Firm is in manufacturing sector
g manuf=(ba3a==21 & (ba3ao2=="artisan" | ba3ao2=="furnishing factory" | ba3ao2=="making broom" | ba3ao2=="making chicken coop" | ba3ao2=="making clothes" | ba3ao2=="making foods shelf. Sideboard" | ba3ao2=="making furniture" | ba3ao2=="making grass-roof sheet for sale" | ba3ao2=="making handicraft" | ba3ao2=="making invented flower" | ba3ao2=="making iron door" | ba3ao2=="making manure" | ba3ao2=="making stick-gun for fish hunting" | ba3ao2=="tailor" | ba3ao2=="weaving basket" | ba3ao2=="weaving invented silk" | ba3ao2=="weaving silk")) if hhbus==1

*Firm is in service sector
g services=(ba3a==3 | ba3a==5 | ba3a==15 | ba3a==19) if hhbus==1
replace services=1 if hhbus==1 & ba3a==21 & (ba3ao2=="brass band service" | ba3ao2=="driving motorcycle for hiring" | ba3ao2=="driving tricycle for hiring" | ba3ao2=="making spit chicken" | ba3ao2=="plowing service" | ba3ao2=="polishing gems" | ba3ao2=="repairing clothes" | ba3ao2=="repairing electric stuffs" | ba3ao2=="repairing shoes" | ba3ao2=="room for rent" | ba3ao2=="sale of dessert" | ba3ao2=="sale of grilled chicken" |  ba3ao2=="six wheels and tractor for rent" | ba3ao2=="snooker table" | ba3ao2=="ten-wheeled truck for hiring" | ba3ao2=="transporting gas" | ba3ao2=="transporting pick up truck" | ba3ao2=="transporting poultry's food" | ba3ao2=="transporting school students" | ba3ao2=="transporting sugar cane" | ba3ao2=="transporting sugar cane,cassava" | ba3ao2=="transporting sugar fertilizer" | ba3ao2=="transporting worker")

*Firm is in other sector
g othersector=(retail==0 & manuf==0 & services==0) if hhbus==1 

replace othersector=. if hhbus==1 & (ba3ao2=="installing electric equipments in ritual" | ba3ao2=="sale of Rotee" |  ba3ao2=="vdo/cd shop")
replace services=. if hhbus==1 & (ba3ao2=="installing electric equipments in ritual" | ba3ao2=="sale of Rotee" |  ba3ao2=="vdo/cd shop")
replace manuf=. if hhbus==1 & (ba3ao2=="installing electric equipments in ritual" | ba3ao2=="sale of Rotee" |  ba3ao2=="vdo/cd shop")
replace retail=. if hhbus==1 & (ba3ao2=="installing electric equipments in ritual" | ba3ao2=="sale of Rotee" |  ba3ao2=="vdo/cd shop")


*Age of the firm in years
replace ba4=. if ba4==-99 
g agefirm=ba4 if hhbus==1 

*Number of paid employees
replace ba12=. if ba12==.c
g employees=ba12 if hhbus==1 

g totalworkers=ba9 if hhbus==1 

keep newid reasonforclosure wave-totalworkers
*TO DO: decide whether you need/want to change path for saving TTHAI7
/**/
save TTHAI7, replace
/**/

*TO DO: change path to where you saved the following file "hh03_16in_tab1.dta" of the 2003 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2003/hh03_16in_tab1.dta", clear
/**/

*Business sales in last month
keep if number=="N" | number=="O" | number=="P" | number=="Q" | number=="R" | number=="S" | number=="U" | number=="AA"
replace in4=0 if in2==3
replace in4=. if in4==.c
bysort newid: egen sales=total(in4), m
*Since sales are given for past 12 months:
replace sales=sales/12

keep newid sales
duplicates drop

*TO DO: change path to where you saved the following file "TTHAI7.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI7, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving TTHAI7
/**/
save TTHAI7, replace
/**/

*TO DO: change path to where you saved the following file "hh03_16in.dta" of the 2003 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2003/hh03_16in.dta", clear
/**/

g expenses=in10b/12 

keep newid expenses

*TO DO: change path to where you saved the following file "TTHAI7.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI7, nogenerate
/**/

g profits=sales-expenses if hhbus==1

*TO DO: decide whether you need/want to change path for saving TTHAI7
/**/
save TTHAI7, replace
/**/

*TO DO: change path to where you saved the following file "hh03_01cvr.dta" of the 2003 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2003/hh03_01cvr.dta", clear
/**/

*Marital status of owner
*Since the marital status is only given for household heads, I can only compute it for head and their spouses
g help=1 if cvr7==1 | cvr7==3 
g married=(cvr11==3) if help==1 & cvr11!=-8
drop help

keep newid married

*TO DO: change path to where you saved the following file "TTHAI7.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI7, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving TTHAI7
/**/
save TTHAI7, replace
/**/

*TO DO: change path to where you saved the following file "hh03_04hc_tab1.dta" of the 2003 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2003/hh03_04hc_tab1.dta", clear
/**/

*Age of owner
g ownerage=hc5

*Gender of owner
g female=(hc4==3) if hc4!=.

*Education of owner
g ownertertiary=(hc7==47 | hc7==49 | hc7==51 | hc7==53) if hc7!=. & hc7!=-999 & hc7!=-888

*Years of education
*I assume the number is the years of education and calculate 6 years for primary and 6 years for secondary
*Sources: 	https://en.wikipedia.org/wiki/Education_in_Thailand
*			http://open_jicareport.jica.go.jp/pdf/11548013.pdf
g educyears=0 if hc7==1 | hc7==3 | hc7==5 | hc7==7 | hc7==9
replace educyears=1 if hc7==11
replace educyears=2 if hc7==13
replace educyears=3 if hc7==15
replace educyears=4 if hc7==17
replace educyears=5 if hc7==19
replace educyears=6 if hc7==21
replace educyears=7 if hc7==23
replace educyears=7 if hc7==25
replace educyears=8 if hc7==27
replace educyears=9 if hc7==29
replace educyears=10 if hc7==31 | hc7==41
replace educyears=11 if hc7==33 | hc7==43
replace educyears=12 if hc7==35 | hc7==45
replace educyears=13 if hc7==37 | hc7==47 | hc7==51 | hc7==55
replace educyears=14 if hc7==39 | hc7==49 | hc7==53 | hc7==57
replace educyears=15 if hc7==59
replace educyears=16 if hc7==61

*Child under 5 in household
g under5=0
replace under5=. if hc5==. 
replace under5=1 if hc5<5 
bysort newid: egen childunder5=max(under5)
drop under5

*Child aged 5 to 12 in household
g aged5to12=0
replace aged5to12=. if  hc5==. 
replace aged5to12=1 if  hc5>=5 &  hc5<12
bysort newid: egen childaged5to12=max(aged5to12)
drop aged5to12

*Has adult aged 65+ in the household
g is65orover=0
replace is65orover=. if hc5==. 
replace is65orover=1 if hc5>=65 & hc5!=. 
bysort newid: egen adult65andover=max(is65orover)
drop is65orover

keep newid number ownerage-adult65andover

*TO DO: change path to where you saved the following file "hh03_05oc_tab1.dta" of the 2003 annual household resurvey
/*EXAMPLE:*/
merge 1:1 newid number using "Townsend Thai Project/2003/hh03_05oc_tab1.dta", nogenerate
/**/

g businessowner=(oc1b==1) if oc1b!=. & oc1b!=.c & oc1b!=.b

/*I code individuals as wage workers if the type of employment reported is either:
 - employee - daily wages, or
 - employee - monthly wages, or
 - government worker.
 I do not consider individuals to be wage workers if the type of employment reported is either:
 - owner of business, or
 - unpaid family worker, or
 - employee - piece rate, in house, or
 - employee - piece rate, out of house, or
 - other.
*/

*Worked as wage worker in last month
g wageworker=(oc1b==5 | oc1b==7 | oc1b==13) if oc1b!=. & oc1b!=.c & oc1b!=.b

*Labor earnings in last month
*Replace missing values:
replace oc1c=. if oc1c==.b | oc1c==.c | oc1c==.y
g laborincome=oc1c if oc1b==7 | oc1b==13
*For government workers it is not clear if the wages are given on a daily or monthly frequency, but I assume from the values that they are monthly
*In case wages are given for a daily frequency, I multiply them with 20 to have monthly wages:
replace laborincome=oc1c*20 if oc1b==5

*Retired
g retired=(oc1a==1) if  oc1a!=.

keep newid number ownerage-adult65andover businessowner wageworker laborincome retired

*TO DO: change path to where you saved the following file "TTHAI7.dta"
/*EXAMPLE:*/
merge m:1 newid using TTHAI7, nogenerate 
/**/

g hhbusowner=(businessowner==1) if hhbus==1 & businessowner!=.

drop businessowner

duplicates tag newid hhbusowner if hhbus==1 & hhbusowner==1, gen(totalowners)
replace totalowners=totalowners+1

g jointbus=(totalowners>1) if hhbus==1 & totalowners!=.

*TO DO: decide whether you need/want to change path for saving TTHAI7
/**/
save TTHAI7, replace
/**/

*Household consumption
*TO DO: change path to where you saved the following file "hh03_04hc.dta" of the 2003 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2003/hh03_04hc.dta", clear
/**/
keep newid hc1

*TO DO: change path to where you saved the following file "hh03_15ex.dta" of the 2003 annual household resurvey
/*EXAMPLE:*/
merge 1:1 newid using "Townsend Thai Project/2003/hh03_15ex.dta", nogenerate
/**/

*TO DO: change path to where you saved the following file "hh03_15ex_tab1.dta" of the 2003 annual household resurvey
/*EXAMPLE:*/
merge 1:m newid using "Townsend Thai Project/2003/hh03_15ex_tab1.dta", nogenerate
/**/

replace ex4=. if ex4==.b | ex4==.c | ex4==.y

bysort newid: egen monthlyexp=total(ex4),m

keep newid monthlyexp hc1 ex5-ex9
duplicates drop

replace monthlyexp=12*monthlyexp
egen hh_exp=rowtotal(monthlyexp ex5-ex9), missing

g pcexpend=hh_exp/hc1

drop monthlyexp hh_exp hc1 ex5-ex9

*TO DO: change path to where you saved the following file "TTHAI7.dta"
/*EXAMPLE:*/
merge 1:m newid using TTHAI7, nogenerate
/**/

*Exchange rate for approximate midpoint of survey period
/*According to the documentation, the data was collected in May 2003, so I use May 15
 as approximate midpoint for the exchange rate*/

g excrate=0.02368

g excratemonth="5-2003"


foreach var of varlist ownerage ownertertiary educyears married childunder5 childaged5to12 adult65andover wageworker laborincome retired sales reasonforclosure wave surveyyear hhbusclosure typeofbusclosed hhbus enf_bus newfirmquex tbdropped nonfarm typeofbus retail manuf services othersector agefirm employees totalworkers expenses profits hhbusowner totalowners jointbus pcexpend excrate*{ 
rename `var' `var'_2003
} 

rename number hc_id
*TO DO: decide whether you need/want to change path for saving TTHAI7
/**/
save TTHAI7, replace
/**/

*TO DO: change path to where you saved the following file "TTHAImaster.dta"
/*EXAMPLE:*/
use TTHAImaster,clear
/**/

*TO DO: change path to where you saved the following file "TTHAI7.dta"
/*EXAMPLE:*/
merge 1:1 newid hc_id using TTHAI7, gen(_merge6) update
/**/

*TO DO: decide whether you need/want to change path for saving TTHAImaster
/**/
save TTHAImaster, replace
/**/
********************************************************************************
*Round 8
********************************************************************************
*TO DO: change path to where you saved the following file "hh04_13ba.dta" of the 2004 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2004/hh04_13ba.dta", clear
/**/
*Survey round number
g wave=8

*Year survey took place
g surveyyear=2004

*Business closure in past 12 months
g hhbusclosure=(ba1a==1) if (ba1a==1 | ba1a==3) & ba1a!=.c

/*Although the questionnaire asks for reasons, the business was closed (question ba1c),
this variable is not in the dataset and also not in the codebook file*/
replace ba1b=. if ba1b==.c
g typeofbusclosed=ba1b

*I keep the open ended reasons for closure as for now to be able to decide later on appropriate coding
rename ba1c reasonforclosure

*Household operates a business
g hhbus=(ba1d==1) if ba1d!=.c

*TO DO: decide whether you need/want to change path for saving TTHAI8
/**/
save TTHAI8, replace 
/**/

*TO DO: change path to where you saved the following file "hh04_13ba_tab1.dta" of the 2004 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2004/hh04_13ba_tab1.dta", clear
/**/

/*Only keep the information for the first business as I will only consider businesses
 of households who have only one business:*/
keep if bnumber==1

*TO DO: change path to where you saved the following file "TTHAI8.dta" 
/*EXAMPLE:*/
merge 1:1 newid using TTHAI8, nogenerate
/**/

*Household entirely owns household business
replace ba2=0 if hhbus==0

g enf_bus=(ba6==1) if ba6!=.

*Household entirely owns household business
*Business founded in last 12 months:
g newfirmquex=(ba21a==1) if ba21a!=.

/*I will only consider household enterprises if the household operates only one 
enterprise and if this enterprise is entirely owned by the household:*/
g tbdropped=(ba2>1) if ba2!=.c | enf_bus!=1

*Since the questionnaire mixes non-farm and farm enterprises:
g nonfarm=(ba3a==1 | ba3a==3 | ba3a==5 | ba3a==15 | ba3a==17 | ba3a==19) if hhbus==1 & ba3a!=.c

replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buying old candles"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buying old things"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buying-selling old thing"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="canned bamboo shoot"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="coffee shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="contracting for construction"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="contracting for doing iron(iron door)"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="contracting for washing box"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="cooking gas delivery service"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="copying service"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="direct sale business"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="driving 10 wheels truck for hiring"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="driving 6 wheels truck for hiring"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="driving motorcycle for transporting passenger"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="driving tri-motorcycle for transporting passenger"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="embroider clothes"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="filling land service"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="gas station"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="handicraft made from wood"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="installing lights in ritual"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="lathe house"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making bended iron door"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making broom"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making chicken coop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making clothes"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making compost"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making garland"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making grass-roof sheet for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making handicraft"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making handicraft made from wood"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making handle of broom"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making invented flower"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making roof-sheet from palm leaves"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making stick-gun for fishing for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making stripes on broom"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="music band service"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="polishing gems"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="rent room"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="repairing electric equipment"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="room for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of beverage"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of boiled peanut and corn"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of charcoal"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of decorative plant"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of food"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of fruit"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of fuel oil"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of furniture"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of grocery goods"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of lottery"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of old thing"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of silk"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of sweet"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="shoes repairing"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="snooker table"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="tailor"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="transporting farm produce"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="transporting fertilizer"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="transporting poultry's food"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="transporting students"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="transporting sugar cane,cassava"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="transporting workers"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="truck for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="weaving invented silk"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="wweaving silk"

replace hhbus=0 if nonfarm==0
replace hhbus=. if nonfarm==. & hhbus!=0

*Type of business
replace ba3a=. if ba3a==.c
g typeofbus=ba3a if hhbus==1

*Sector of the firm:
*Firm is in retail trade
g retail=(ba3a==1 | ba3a==17) if hhbus==1
replace retail=1 if hhbus==1 & ba3a==21 & (ba3ao2=="buying old things" | ba3ao2=="buying-selling old thing" | ba3ao2=="direct sale business" | ba3ao2=="gas station" | ba3ao2=="sale of charcoal" | ba3ao2=="sale of decorative plant" | ba3ao2=="sale of fruit" | ba3ao2=="sale of fuel oil" | ba3ao2=="sale of furniture" | ba3ao2=="sale of grocery goods" | ba3ao2=="sale of lottery" | ba3ao2=="sale of old thing" | ba3ao2=="sale of silk")

*Firm is in manufacturing sector
g manuf=(ba3a==21 & (ba3ao2=="canned bamboo shoot" | ba3ao2=="contracting for doing iron(iron door)" | ba3ao2=="embroider clothes" | ba3ao2=="handicraft made from wood" | ba3ao2=="making bended iron door" | ba3ao2=="making broom" | ba3ao2=="making chicken coop" | ba3ao2=="making clothes" | ba3ao2=="making garland" | ba3ao2=="making grass-roof sheet for sale" | ba3ao2=="making handicraft" | ba3ao2=="making handicraft made from wood" | ba3ao2=="making handle of broom" | ba3ao2=="making invented flower" | ba3ao2=="making roof-sheet from palm leaves" | ba3ao2=="making stick-gun for fishing for sale" | ba3ao2=="making stripes on broom" | ba3ao2=="polishing gems" | ba3ao2=="tailor" | ba3ao2=="weaving invented silk" | ba3ao2=="wweaving silk")) if hhbus==1
 
*Firm is in service sector
g services=(ba3a==3 | ba3a==5 | ba3a==15 | ba3a==19) if hhbus==1
replace services=1 if hhbus==1 & ba3a==21 & (ba3ao2=="coffee shop" | ba3ao2=="contracting for washing box" | ba3ao2=="cooking gas delivery service" | ba3ao2=="copying service" | ba3ao2=="driving 10 wheels truck for hiring" | ba3ao2=="driving 6 wheels truck for hiring" | ba3ao2=="driving motorcycle for transporting passenger" | ba3ao2=="driving tri-motorcycle for transporting passenger" | ba3ao2=="music band service" | ba3ao2=="rent room" | ba3ao2=="repairing electric equipment" | ba3ao2=="room for rent" | ba3ao2=="sale of boiled peanut and corn"  | ba3ao2=="sale of food" | ba3ao2=="sale of sweet" | ba3ao2=="shoes repairing" | ba3ao2=="snooker table" | ba3ao2=="transporting farm produce" | ba3ao2=="transporting fertilizer" | ba3ao2=="transporting poultry's food" | ba3ao2=="transporting students" | ba3ao2=="transporting sugar cane,cassava" | ba3ao2=="transporting workers" | ba3ao2=="truck for rent")

*Firm is in other sector
g othersector=(retail==0 & manuf==0 & services==0) if hhbus==1 

replace othersector=. if hhbus==1 & (ba3ao2=="buying old candles" | ba3ao2=="installing lights in ritual"  | ba3ao2=="sale of beverage")
replace services=. if hhbus==1 & (ba3ao2=="buying old candles" | ba3ao2=="installing lights in ritual"  | ba3ao2=="sale of beverage")
replace manuf=. if hhbus==1 & (ba3ao2=="buying old candles" | ba3ao2=="installing lights in ritual"  | ba3ao2=="sale of beverage")
replace retail=. if hhbus==1 & (ba3ao2=="buying old candles" | ba3ao2=="installing lights in ritual"  | ba3ao2=="sale of beverage")

*Age of the firm in years
replace ba4=. if ba4==-99 
g agefirm=ba4 if hhbus==1 

*Number of paid employees
replace ba12=. if ba12==.c
g employees=ba12 if hhbus==1 

g totalworkers=ba9 if hhbus==1 

keep newid reasonforclosure wave-totalworkers

*TO DO: decide whether you need/want to change path for saving TTHAI8
/**/
save TTHAI8, replace
/**/

*TO DO: change path to where you saved the following file "hh04_16in_tab1.dta" of the 2004 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2004/hh04_16in_tab1.dta", clear
/**/
*Business sales in last month
keep if number=="N" | number=="O" | number=="P" | number=="Q" | number=="R" | number=="S" | number=="U" | number=="AA"
replace in4=0 if in2==3
replace in4=. if in4==.c
bysort newid: egen sales=total(in4), m
*Since sales are given for past 12 months:
replace sales=sales/12

keep newid sales
duplicates drop

*TO DO: change path to where you saved the following file "TTHAI8.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI8, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving TTHAI8
/**/
save TTHAI8, replace
/**/

*TO DO: change path to where you saved the following file "hh04_16in.dta" of the 2004 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2004/hh04_16in.dta", clear
/**/

g expenses=in10b/12 

keep newid expenses

*TO DO: change path to where you saved the following file "TTHAI8.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI8, nogenerate
/**/

g profits=sales-expenses if hhbus==1

*TO DO: decide whether you need/want to change path for saving TTHAI8
/**/
save TTHAI8, replace
/**/

*TO DO: change path to where you saved the following file "hh04_01cvr.dta" of the 2004 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2004/hh04_01cvr.dta", clear
/**/

*Marital status of owner
*Since the marital status is only given for household heads, I can only compute it for head and their spouses
g help=1 if cvr7==1 | cvr7==3 
g married=(cvr11==3) if help==1 & cvr11!=-8
drop help

keep newid married

*TO DO: change path to where you saved the following file "TTHAI8.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI8, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving TTHAI8
/**/
save TTHAI8, replace
/**/

*TO DO: change path to where you saved the following file "hh04_04hc_tab1.dta" of the 2004 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2004/hh04_04hc_tab1.dta", clear
/**/

*Age of owner
g ownerage=hc5

*Gender of owner
g female=(hc4==3) if hc4!=.

*Education of owner
g ownertertiary=(hc7==47 | hc7==49 | hc7==51 | hc7==53) if hc7!=. & hc7!=-999 & hc7!=-888

*Years of education
*I assume the number is the years of education and calculate 6 years for primary and 6 years for secondary
*Sources: 	https://en.wikipedia.org/wiki/Education_in_Thailand
*			http://open_jicareport.jica.go.jp/pdf/11548013.pdf
g educyears=0 if hc7==1 | hc7==3 | hc7==5 | hc7==7 | hc7==9
replace educyears=1 if hc7==11
replace educyears=2 if hc7==13
replace educyears=3 if hc7==15
replace educyears=4 if hc7==17
replace educyears=5 if hc7==19
replace educyears=6 if hc7==21
replace educyears=7 if hc7==23
replace educyears=7 if hc7==25
replace educyears=8 if hc7==27
replace educyears=9 if hc7==29
replace educyears=10 if hc7==31 | hc7==41
replace educyears=11 if hc7==33 | hc7==43
replace educyears=12 if hc7==35 | hc7==45
replace educyears=13 if hc7==37 | hc7==47 | hc7==51 | hc7==55
replace educyears=14 if hc7==39 | hc7==49 | hc7==53 | hc7==57
replace educyears=15 if hc7==59
replace educyears=16 if hc7==61

*Child under 5 in household
g under5=0
replace under5=. if hc5==. 
replace under5=1 if hc5<5 
bysort newid: egen childunder5=max(under5)
drop under5

*Child aged 5 to 12 in household
g aged5to12=0
replace aged5to12=. if  hc5==. 
replace aged5to12=1 if  hc5>=5 &  hc5<12
bysort newid: egen childaged5to12=max(aged5to12)
drop aged5to12

*Has adult aged 65+ in the household
g is65orover=0
replace is65orover=. if hc5==. 
replace is65orover=1 if hc5>=65 & hc5!=. 
bysort newid: egen adult65andover=max(is65orover)
drop is65orover

keep newid number ownerage-adult65andover

*TO DO: change path to where you saved the following file "hh04_05oc_tab1.dta" of the 2004 annual household resurvey
/*EXAMPLE:*/
merge 1:1 newid number using "Townsend Thai Project/2004/hh04_05oc_tab1.dta", nogenerate
/**/

g businessowner=(oc1b==1) if oc1b!=. & oc1b!=.c & oc1b!=.b

/*I code individuals as wage workers if the type of employment reported is either:
 - employee - daily wages, or
 - employee - monthly wages, or
 - government worker.
 I do not consider individuals to be wage workers if the type of employment reported is either:
 - owner of business, or
 - unpaid family worker, or
 - employee - piece rate, in house, or
 - employee - piece rate, out of house, or
 - other.
*/

*Worked as wage worker in last month
g wageworker=(oc1b==5 | oc1b==7 | oc1b==13) if oc1b!=. & oc1b!=.c & oc1b!=.b

*Labor earnings in last month
*Replace missing values:
replace oc1c=. if oc1c==.b | oc1c==.c | oc1c==.y
g laborincome=oc1c if oc1b==7 | oc1b==13
*For government workers it is not clear if the wages are given on a daily or monthly frequency, but I assume from the values that they are monthly
*In case wages are given for a daily frequency, I multiply them with 20 to have monthly wages:
replace laborincome=oc1c*20 if oc1b==5

*Retired
g retired=(oc1a==1) if  oc1a!=.

keep newid number ownerage-adult65andover businessowner wageworker laborincome retired

*TO DO: change path to where you saved the following file "TTHAI8.dta"
/*EXAMPLE:*/
merge m:1 newid using TTHAI8, nogenerate 
/**/

g hhbusowner=(businessowner==1) if hhbus==1 & businessowner!=.

drop businessowner

duplicates tag newid hhbusowner if hhbus==1 & hhbusowner==1, gen(totalowners)
replace totalowners=totalowners+1

g jointbus=(totalowners>1) if hhbus==1 & totalowners!=.

*TO DO: decide whether you need/want to change path for saving TTHAI8
/**/
save TTHAI8, replace
/**/

*Household consumption
*TO DO: change path to where you saved the following file "hh04_04hc.dta" of the 2004 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2004/hh04_04hc.dta", clear
/**/
keep newid hc1

*TO DO: change path to where you saved the following file "hh04_15ex.dta" of the 2004 annual household resurvey
/*EXAMPLE:*/
merge 1:1 newid using "Townsend Thai Project/2004/hh04_15ex.dta", nogenerate
/**/
*TO DO: change path to where you saved the following file "hh04_15ex_tab1.dta" of the 2004 annual household resurvey
/*EXAMPLE:*/
merge 1:m newid using "Townsend Thai Project/2004/hh04_15ex_tab1.dta", nogenerate
/**/
replace ex4=. if ex4==.b | ex4==.c | ex4==.y

bysort newid: egen monthlyexp=total(ex4),m

keep newid monthlyexp hc1 ex5-ex9
duplicates drop

replace monthlyexp=12*monthlyexp
egen hh_exp=rowtotal(monthlyexp ex5-ex9), missing

g pcexpend=hh_exp/hc1

drop monthlyexp hh_exp hc1 ex5-ex9

*TO DO: change path to where you saved the following file "TTHAI8.dta" 
/*EXAMPLE:*/
merge 1:m newid using TTHAI8, nogenerate
/**/

*Exchange rate for approximate midpoint of survey period
/*According to the documentation, the data was collected in May 2004, so I use May 15
 as approximate midpoint for the exchange rate*/

g excrate=0.02443

g excratemonth="5-2004"


foreach var of varlist ownerage ownertertiary educyears married childunder5 childaged5to12 adult65andover wageworker laborincome retired sales reasonforclosure wave surveyyear hhbusclosure typeofbusclosed hhbus enf_bus newfirmquex tbdropped nonfarm typeofbus retail manuf services othersector agefirm employees totalworkers expenses profits hhbusowner totalowners jointbus pcexpend excrate*{ 
rename `var' `var'_2004
} 

rename number hc_id
*TO DO: decide whether you need/want to change path for saving TTHAI8
/**/
save TTHAI8, replace
/**/

*TO DO: change path to where you saved the following file "TTHAImaster.dta" 
/*EXAMPLE:*/
use TTHAImaster,clear
/**/

*TO DO: change path to where you saved the following file "TTHAI8.dta" 
/*EXAMPLE:*/
merge 1:1 newid hc_id using TTHAI8, gen(_merge7) update
/**/

*TO DO: decide whether you need/want to change path for saving TTHAImaster
/**/
save TTHAImaster, replace
/**/
********************************************************************************
*Round 9
********************************************************************************
*TO DO: change path to where you saved the following file "hh05_13ba.dta" of the 2005 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2005/hh05_13ba.dta", clear
/**/
*Survey round number
g wave=9

*Year survey took place
g surveyyear=2005

*Business closure in past 12 months
g hhbusclosure=(ba1a==1) if (ba1a==1 | ba1a==3) & ba1a!=.c

/*Although the questionnaire asks for reasons, the business was closed (question ba1c),
this variable is not in the dataset and also not in the codebook file*/
replace ba1b=. if ba1b==.c
g typeofbusclosed=ba1b

*I keep the open ended reasons for closure as for now to be able to decide later on appropriate coding
rename ba1c reasonforclosure

*Household operates a business
g hhbus=(ba1d==1) if ba1d!=.c

*TO DO: decide whether you need/want to change path for saving TTHAI9
/**/
save TTHAI9, replace 
/**/

*TO DO: change path to where you saved the following file "hh05_13ba_tab1.dta" of the 2005 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2005/hh05_13ba_tab1.dta", clear
/**/

/*Only keep the information for the first business as I will only consider businesses
 of households who have only one business:*/
keep if bnumber==1

*TO DO: change path to where you saved the following file "TTHAI9.dta" 
/*EXAMPLE:*/
merge 1:1 newid using TTHAI9, nogenerate
/**/

*Household entirely owns household business
replace ba2=. if ba2==.c
replace ba2=0 if hhbus==0

g enf_bus=(ba6==1) if ba6!=.

*Household entirely owns household business
*Business founded in last 12 months:
g newfirmquex=(ba21a==1) if ba21a!=.

/*I will only consider household enterprises if the household operates only one 
enterprise and if this enterprise is entirely owned by the household:*/
g tbdropped=(ba2>1) if ba2!=.c | enf_bus!=1

*Since the questionnaire mixes non-farm and farm enterprises:
g nonfarm=(ba3a==1 | ba3a==3 | ba3a==5 | ba3a==15 | ba3a==17 | ba3a==19) if hhbus==1 & ba3a!=.c

replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="brass band service"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buying and selling farm produces"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buying cotton"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buying old candle"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buying old things"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buying plastic"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="canned bamboo shoot"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="contracting for construction"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="contracting for painting of building"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="driving motorcycle for transportation of passenger"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="driving tri-motorcycle for transportation of passenger"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="eletone-musical band"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="equipment in arranging party for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="gas station"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="hired as a bus driver"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="hired as a ten-wheeled truck driver"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="hired as driver for transporting goods"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="house for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="land filling service"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="makinf para rubber"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making Roman post and making pattern"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making blanket and carpet"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making broom"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making clothes"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making grass-roof for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making house posts"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making iron door and window"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making loundspeaker and hi fi for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making para rubber"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making socks"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="metal furnishing factory"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="music band"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="pharmarcy"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="plowing service and transporting fuel oil"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="producing clothes"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="room for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sae of fuel oil"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale od boiled groundnut and corn"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of (cosmetic)Mistean"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of canned bamboo shoot"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of charcoal"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of clothes"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of cosmetic(Giffarine)"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of fruits"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of goods by pick-up truck"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of herbical medicine"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of local musical instrument and artisan"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of lottery"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of sweet"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sheet"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="snooker table for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="ten-wheels truck for hiring"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="transfigure wood"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="transporting goods"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="transporting student"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="transporting truck for hiring"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="washing boxes of chicks"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="weaving basket"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="weaving chicken coop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="weaving hat"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="wood handicraft"

replace hhbus=0 if nonfarm==0
replace hhbus=. if nonfarm==. & hhbus!=0

*Type of business
replace ba3a=. if ba3a==.c
g typeofbus=ba3a if hhbus==1

*Sector of the firm:
*Firm is in retail trade
g retail=(ba3a==1 | ba3a==17) if hhbus==1
replace retail=1 if hhbus==1 & ba3a==21 & (ba3ao2=="buying and selling farm produces"| ba3ao2=="buying old things" | ba3ao2=="direct sale" | ba3ao2=="gas station" | ba3ao2=="sale of (cosmetic)Mistean" | ba3ao2=="sale of canned bamboo shoot" | ba3ao2=="sale of charcoal" | ba3ao2=="sale of clothes" | ba3ao2=="sale of cosmetic(Giffarine)" | ba3ao2=="sale of fruits" | ba3ao2=="sale of goods by pick-up truck" | ba3ao2=="sale of herbical medicine" | ba3ao2=="sale of local musical instrument and artisan" | ba3ao2=="sale of lottery")

*Firm is in manufacturing sector
g manuf=(ba3a==21 & (ba3ao2=="canned bamboo shoot" | ba3ao2=="makinf para rubber" | ba3ao2=="making blanket and carpet" | ba3ao2=="making broom" | ba3ao2=="making clothes" | ba3ao2=="making grass-roof for sale" | ba3ao2=="making iron door and window" | ba3ao2=="making para rubber" | ba3ao2=="making socks" | ba3ao2=="metal furnishing factory" | ba3ao2=="producing clothes" | ba3ao2=="transfigure wood" | ba3ao2=="weaving basket" | ba3ao2=="weaving chicken coop" | ba3ao2=="weaving hat" | ba3ao2=="wood handicraft")) if hhbus==1
  
*Firm is in service sector
g services=(ba3a==3 | ba3a==5 | ba3a==15 | ba3a==19) if hhbus==1
replace services=1 if hhbus==1 & ba3a==21 & (ba3ao2=="brass band service" | ba3ao2=="driving motorcycle for transportation of passenger" | ba3ao2=="driving tri-motorcycle for transportation of passenger" | ba3ao2=="eletone-musical band" | ba3ao2=="equipment in arranging party for rent" | ba3ao2=="hired as a bus driver" | ba3ao2=="hired as a ten-wheeled truck driver" | ba3ao2=="hired as driver for transporting goods" | ba3ao2=="house for rent" | ba3ao2=="making loundspeaker and hi fi for rent" | ba3ao2=="music band" | ba3ao2=="plowing service and transporting fuel oil" | ba3ao2=="room for rent" | ba3ao2=="sale od boiled groundnut and corn" | ba3ao2=="sale of sweet" | ba3ao2=="snooker table for rent" | ba3ao2=="ten-wheels truck for hiring" | ba3ao2=="transporting goods" | ba3ao2=="transporting student" | ba3ao2=="transporting truck for hiring"| ba3ao2=="washing boxes of chicks")

*Firm is in other sector
g othersector=(retail==0 & manuf==0 & services==0) if hhbus==1 

replace othersector=. if hhbus==1 & (ba3ao2=="buying old candle" | ba3ao2=="buying plastic" | ba3ao2=="making Roman post and making pattern" | ba3ao2=="making house posts" | ba3ao2=="sheet")
replace services=. if hhbus==1 & (ba3ao2=="buying old candle" | ba3ao2=="buying plastic" | ba3ao2=="making Roman post and making pattern" | ba3ao2=="making house posts" | ba3ao2=="sheet")
replace manuf=. if hhbus==1 & (ba3ao2=="buying old candle" | ba3ao2=="buying plastic" | ba3ao2=="making Roman post and making pattern" | ba3ao2=="making house posts" | ba3ao2=="sheet")
replace retail=. if hhbus==1 & (ba3ao2=="buying old candle" | ba3ao2=="buying plastic" | ba3ao2=="making Roman post and making pattern" | ba3ao2=="making house posts" | ba3ao2=="sheet")


*Age of the firm in years
replace ba4=. if ba4==.b
g agefirm=ba4 if hhbus==1 

*Number of paid employees
replace ba12=. if ba12==.c
g employees=ba12 if hhbus==1 

g totalworkers=ba9 if hhbus==1 

keep newid reasonforclosure wave-totalworkers

*TO DO: decide whether you need/want to change path for saving TTHAI9
/**/
save TTHAI9, replace
/**/

*TO DO: change path to where you saved the following file "hh05_16in_tab1.dta" of the 2005 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2005/hh05_16in_tab1.dta", clear
/**/
*Business sales in last month
keep if number=="N" | number=="O" | number=="P" | number=="Q" | number=="R" | number=="S" | number=="U" | number=="AA"
replace in4=0 if in2==3
replace in4=. if in4==.c
bysort newid: egen sales=total(in4), m
*Since sales are given for past 12 months:
replace sales=sales/12

keep newid sales
duplicates drop

*TO DO: change path to where you saved the following file "TTHAI9.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI9, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving TTHAI9
/**/
save TTHAI9, replace
/**/

*TO DO: change path to where you saved the following file "hh05_16in.dta" of the 2005 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2005/hh05_16in.dta", clear
/**/

g expenses=in10b/12 

keep newid expenses

*TO DO: change path to where you saved the following file "TTHAI9.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI9, nogenerate
/**/

g profits=sales-expenses if hhbus==1

*TO DO: decide whether you need/want to change path for saving TTHAI9
/**/
save TTHAI9, replace
/**/

*TO DO: change path to where you saved the following file "hh04_01cvr.dta" of the 2005 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2004/hh04_01cvr.dta", clear
/**/

*Marital status of owner
*Since the marital status is only given for household heads, I can only compute it for head and their spouses
g help=1 if cvr7==1 | cvr7==3 
g married=(cvr11==3) if help==1 & cvr11!=-8
drop help

keep newid married

*TO DO: change path to where you saved the following file "TTHAI9.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI9, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving TTHAI9
/**/
save TTHAI9, replace
/**/

*TO DO: change path to where you saved the following file "hh05_04hc_tab1.dta" of the 2005 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2005/hh05_04hc_tab1.dta", clear
/**/

*Age of owner
g ownerage=hc5

*Gender of owner
g female=(hc4==3) if hc4!=.

*Education of owner
g ownertertiary=(hc7==47 | hc7==49 | hc7==51 | hc7==53) if hc7!=. & hc7!=-999 & hc7!=-888

*Years of education
*I assume the number is the years of education and calculate 6 years for primary and 6 years for secondary
*Sources: 	https://en.wikipedia.org/wiki/Education_in_Thailand
*			http://open_jicareport.jica.go.jp/pdf/11548013.pdf
g educyears=0 if hc7==1 | hc7==3 | hc7==5 | hc7==7 | hc7==9
replace educyears=1 if hc7==11
replace educyears=2 if hc7==13
replace educyears=3 if hc7==15
replace educyears=4 if hc7==17
replace educyears=5 if hc7==19
replace educyears=6 if hc7==21
replace educyears=7 if hc7==23
replace educyears=7 if hc7==25
replace educyears=8 if hc7==27
replace educyears=9 if hc7==29
replace educyears=10 if hc7==31 | hc7==41
replace educyears=11 if hc7==33 | hc7==43
replace educyears=12 if hc7==35 | hc7==45
replace educyears=13 if hc7==37 | hc7==47 | hc7==51 | hc7==55
replace educyears=14 if hc7==39 | hc7==49 | hc7==53 | hc7==57
replace educyears=15 if hc7==59
replace educyears=16 if hc7==61

*Child under 5 in household
g under5=0
replace under5=. if hc5==. 
replace under5=1 if hc5<5 
bysort newid: egen childunder5=max(under5)
drop under5

*Child aged 5 to 12 in household
g aged5to12=0
replace aged5to12=. if  hc5==. 
replace aged5to12=1 if  hc5>=5 &  hc5<12
bysort newid: egen childaged5to12=max(aged5to12)
drop aged5to12

*Has adult aged 65+ in the household
g is65orover=0
replace is65orover=. if hc5==. 
replace is65orover=1 if hc5>=65 & hc5!=. 
bysort newid: egen adult65andover=max(is65orover)
drop is65orover

keep newid number ownerage-adult65andover

*TO DO: change path to where you saved the following file "hh05_05oc_tab1.dta" of the 2005 annual household resurvey
/*EXAMPLE:*/
merge 1:1 newid number using "Townsend Thai Project/2005/hh05_05oc_tab1.dta", nogenerate
/**/

g businessowner=(oc1b==1) if oc1b!=. & oc1b!=.c & oc1b!=.b

/*I code individuals as wage workers if the type of employment reported is either:
 - employee - daily wages, or
 - employee - monthly wages, or
 - government worker.
 I do not consider individuals to be wage workers if the type of employment reported is either:
 - owner of business, or
 - unpaid family worker, or
 - employee - piece rate, in house, or
 - employee - piece rate, out of house, or
 - other.
*/

*Worked as wage worker in last month
g wageworker=(oc1b==5 | oc1b==7 | oc1b==13) if oc1b!=. & oc1b!=.c & oc1b!=.b

*Labor earnings in last month
*Replace missing values:
replace oc1c=. if oc1c==.b | oc1c==.c | oc1c==.y
g laborincome=oc1c if oc1b==7 | oc1b==13
*For government workers it is not clear if the wages are given on a daily or monthly frequency, but I assume from the values that they are monthly
*In case wages are given for a daily frequency, I multiply them with 20 to have monthly wages:
replace laborincome=oc1c*20 if oc1b==5

*Retired
g retired=(oc1a==1) if  oc1a!=.

keep newid number ownerage-adult65andover businessowner wageworker laborincome retired

*TO DO: change path to where you saved the following file "TTHAI9.dta" 
/*EXAMPLE:*/
merge m:1 newid using TTHAI9, nogenerate 
/**/

g hhbusowner=(businessowner==1) if hhbus==1 & businessowner!=.

drop businessowner

duplicates tag newid hhbusowner if hhbus==1 & hhbusowner==1, gen(totalowners)
replace totalowners=totalowners+1

g jointbus=(totalowners>1) if hhbus==1 & totalowners!=.

*TO DO: decide whether you need/want to change path for saving TTHAI9
/**/
save TTHAI9, replace
/**/

*Household consumption
*TO DO: change path to where you saved the following file "hh05_04hc.dta" of the 2005 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2005/hh05_04hc.dta", clear
/**/
keep newid hc1

*TO DO: change path to where you saved the following file "hh05_15ex.dta" of the 2005 annual household resurvey
/*EXAMPLE:*/
merge 1:1 newid using "Townsend Thai Project/2005/hh05_15ex.dta", nogenerate
/**/
*TO DO: change path to where you saved the following file "hh05_15ex_tab1.dta" of the 2005 annual household resurvey
/*EXAMPLE:*/
merge 1:m newid using "Townsend Thai Project/2005/hh05_15ex_tab1.dta", nogenerate
/**/
replace ex4=. if ex4==.b | ex4==.c | ex4==.y

bysort newid: egen monthlyexp=total(ex4),m

keep newid monthlyexp hc1 ex5-ex9
duplicates drop

replace monthlyexp=12*monthlyexp
egen hh_exp=rowtotal(monthlyexp ex5-ex9), missing

g pcexpend=hh_exp/hc1

drop monthlyexp hh_exp hc1 ex5-ex9

*TO DO: change path to where you saved the following file "TTHAI9.dta"
/*EXAMPLE:*/
merge 1:m newid using TTHAI9, nogenerate
/**/

*Exchange rate for approximate midpoint of survey period
/*According to the documentation, the data was collected in May 2005, so I use May 15
 as approximate midpoint for the exchange rate*/

g excrate=0.02529

g excratemonth="5-2005"


foreach var of varlist ownerage ownertertiary educyears married childunder5 childaged5to12 adult65andover wageworker laborincome retired sales reasonforclosure wave surveyyear hhbusclosure typeofbusclosed hhbus enf_bus newfirmquex tbdropped nonfarm typeofbus retail manuf services othersector agefirm employees totalworkers expenses profits hhbusowner totalowners jointbus pcexpend excrate*{ 
rename `var' `var'_2005
} 

rename number hc_id
*TO DO: decide whether you need/want to change path for saving TTHAI9
/**/
save TTHAI9, replace
/**/

*TO DO: change path to where you saved the following file "TTHAImaster"
/*EXAMPLE:*/
use TTHAImaster,clear
/**/

*TO DO: change path to where you saved the following file "TTHAI9.dta"
/*EXAMPLE:*/
merge 1:1 newid hc_id using TTHAI9, gen(_merge8) update
/**/

*TO DO: decide whether you need/want to change path for saving TTHAImaster
/**/
save TTHAImaster, replace
/**/
********************************************************************************
*Round 10
********************************************************************************
*TO DO: change path to where you saved the following file "hh06_13ba.dta" of the 2006 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2006/hh06_13ba.dta", clear
/**/

*Survey round number
g wave=10

*Year survey took place
g surveyyear=2006

*Business closure in past 12 months
g hhbusclosure=(ba1a==1) if (ba1a==1 | ba1a==3) & ba1a!=.c

/*Although the questionnaire asks for reasons, the business was closed (question ba1c),
this variable is not in the dataset and also not in the codebook file*/
replace ba1b=. if ba1b==.c
g typeofbusclosed=ba1b

*I keep the open ended reasons for closure as for now to be able to decide later on appropriate coding
rename ba1c reasonforclosure

*Household operates a business
g hhbus=(ba1d==1) if ba1d!=.c

*TO DO: decide whether you need/want to change path for saving TTHAI10
/**/
save TTHAI10, replace 
/**/

*TO DO: change path to where you saved the following file "hh06_13ba_tab1.dta" of the 2006 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2006/hh06_13ba_tab1.dta", clear
/**/

/*Only keep the information for the first business as I will only consider businesses
 of households who have only one business:*/
keep if bnumber==1

*TO DO: change path to where you saved the following file "TTHAI10.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI10, nogenerate
/**/

*Household entirely owns household business
replace ba2=. if ba2==.c
replace ba2=0 if hhbus==0

g enf_bus=(ba6==1) if ba6!=.

*Household entirely owns household business
*Business founded in last 12 months:
g newfirmquex=(ba21a==1) if ba21a!=.

/*I will only consider household enterprises if the household operates only one 
enterprise and if this enterprise is entirely owned by the household:*/
g tbdropped=(ba2>1) if ba2!=.c | enf_bus!=1

*Since the questionnaire mixes non-farm and farm enterprises:
g nonfarm=(ba3a==1 | ba3a==3 | ba3a==5 | ba3a==15 | ba3a==17 | ba3a==19) if hhbus==1 & ba3a!=.c

replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="arranging for set up electric-light and sound speakers service"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buying -selling husk"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buying old things"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="collecting old things for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="contracting for construction"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="contracting for painting"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="direct sale business"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="driving a tri-cycle for hiring"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="driving farm tractor and 6-wheels truck for hiring"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="driving motorcycle for transporting passengerg"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="driving ten-wheels truck for hiring"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="driving truck for transporting students"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="game shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="gas station"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="hired as a tricycle driver"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="hired as a wood cutter"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="house-moving service"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making Khao-Dan"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making broom"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making canned bamboo shoot"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making chicken coop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making clothes"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making concrete pole"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making frog pond"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making garland"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making grass-roof sheet for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making handicraft from wood"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making iron door"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making stick for roasted chicken"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="music band"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="musical band"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="photo-shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="pick-up truck for hiring"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="rent room"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="renting equipments for party"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="repairing clothes service"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="repairing computer"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="repairing electrical applicants shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of betel leaves"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of boiled corn and groundnut"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of fuel oil"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of old things"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of papaya salad"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of papaya salad and fried meatball"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of transfigured teak"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="selling and buying used candles"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="shoes repairing shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="six-wheels truck for hiring"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="snooker table for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="tailor's"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="ten-wheels truck for hiring"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="transporting animal food service"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="transporting cassava"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="transporting cassava starch"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="transporting farm product service"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="washing machine service"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="weaving fishnet"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="weaving local cloth for sale"

replace hhbus=0 if nonfarm==0
replace hhbus=. if nonfarm==. & hhbus!=0

*Type of business
replace ba3a=. if ba3a==.c
g typeofbus=ba3a if hhbus==1

*Sector of the firm:
*Firm is in retail trade
g retail=(ba3a==1 | ba3a==17) if hhbus==1
replace retail=1 if hhbus==1 & ba3a==21 & (ba3ao2=="buying -selling husk" | ba3ao2=="buying old things" | ba3ao2=="collecting old things for sale" | ba3ao2=="direct sale business" | ba3ao2=="gas station" | ba3ao2=="sale of betel leaves" | ba3ao2=="sale of fuel oil" | ba3ao2=="sale of old things" | ba3ao2=="sale of transfigured teak" | ba3ao2=="selling and buying used candles")

*Firm is in manufacturing sector
g manuf=(ba3a==21 & (ba3ao2=="making broom" | ba3ao2=="making canned bamboo shoot" | ba3ao2=="making chicken coop" | ba3ao2=="making clothes" | ba3ao2=="making garland" | ba3ao2=="making grass-roof sheet for sale" | ba3ao2=="making handicraft from wood" | ba3ao2=="making iron door" | ba3ao2=="making stick for roasted chicken" | ba3ao2=="tailor's" | ba3ao2=="weaving fishnet" | ba3ao2=="weaving local cloth for sale")) if hhbus==1  
  
*Firm is in service sector
g services=(ba3a==3 | ba3a==5 | ba3a==15 | ba3a==19) if hhbus==1
replace services=1 if hhbus==1 & ba3a==21 & (ba3ao2=="arranging for set up electric-light and sound speakers service" | ba3ao2=="driving a tri-cycle for hiring" | ba3ao2=="driving farm tractor and 6-wheels truck for hiring" | ba3ao2=="driving motorcycle for transporting passengerg" | ba3ao2=="driving ten-wheels truck for hiring" | ba3ao2=="driving truck for transporting students" | ba3ao2=="hired as a tricycle driver" | ba3ao2=="house-moving service" | ba3ao2=="music band" | ba3ao2=="musical band" | ba3ao2=="photo-shop" | ba3ao2=="pick-up truck for hiring" | ba3ao2=="plowing service and transporting product" | ba3ao2=="rent room" | ba3ao2=="renting equipments for party" | ba3ao2=="repairing clothes service" | ba3ao2=="repairing computer" | ba3ao2=="repairing electrical applicants shop" | ba3ao2=="sale of boiled corn and groundnut" | ba3ao2=="sale of papaya salad" | ba3ao2=="sale of papaya salad and fried meatball" | ba3ao2=="shoes repairing shop" | ba3ao2=="six-wheels truck for hiring" | ba3ao2=="snooker table for rent" | ba3ao2=="ten-wheels truck for hiring" | ba3ao2=="transporting animal food service" | ba3ao2=="transporting cassava" | ba3ao2=="transporting cassava starch" | ba3ao2=="transporting farm product service" | ba3ao2=="washing machine service")

*Firm is in other sector
g othersector=(retail==0 & manuf==0 & services==0) if hhbus==1 

replace othersector=. if hhbus==1 & (ba3ao2=="game shop" | ba3ao2=="hired as a wood cutter" | ba3ao2=="making Khao-Dan") 
replace services=. if hhbus==1 & (ba3ao2=="game shop" | ba3ao2=="hired as a wood cutter" | ba3ao2=="making Khao-Dan") 
replace manuf=. if hhbus==1 & (ba3ao2=="game shop" | ba3ao2=="hired as a wood cutter" | ba3ao2=="making Khao-Dan") 
replace retail=. if hhbus==1 & (ba3ao2=="game shop" | ba3ao2=="hired as a wood cutter" | ba3ao2=="making Khao-Dan") 


*Age of the firm in years
replace ba4=. if ba4==.b
g agefirm=ba4 if hhbus==1 

*Number of paid employees
replace ba12=. if ba12==.c
g employees=ba12 if hhbus==1 

g totalworkers=ba9 if hhbus==1 

keep newid reasonforclosure wave-totalworkers
*TO DO: decide whether you need/want to change path for saving TTHAI10
/**/
save TTHAI10, replace
/**/

*TO DO: change path to where you saved the following file "hh06_16in_tab1.dta" of the 2006 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2006/hh06_16in_tab1.dta", clear
/**/
*Business sales in last month
keep if number=="N" | number=="O" | number=="P" | number=="Q" | number=="R" | number=="S" | number=="U" | number=="AA"
replace in4=0 if in2==3
replace in4=. if in4==.c
bysort newid: egen sales=total(in4), m
*Since sales are given for past 12 months:
replace sales=sales/12

keep newid sales
duplicates drop

*TO DO: change path to where you saved the following file "TTHAI10.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI10, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving TTHAI10
/**/
save TTHAI10, replace
/**/

*TO DO: change path to where you saved the following file "hh06_16in.dta" of the 2006 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2006/hh06_16in.dta", clear
/**/

g expenses=in10b/12 

keep newid expenses

*TO DO: change path to where you saved the following file "TTHAI10.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI10, nogenerate
/**/

g profits=sales-expenses if hhbus==1

*TO DO: decide whether you need/want to change path for saving TTHAI10
/**/
save TTHAI10, replace
/**/

*TO DO: change path to where you saved the following file "hh05_01cvr.dta" of the 2006 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2005/hh05_01cvr.dta", clear
/**/

*Marital status of owner
*Since the marital status is only given for household heads, I can only compute it for head and their spouses
g help=1 if cvr7==1 | cvr7==3 
g married=(cvr11==3) if help==1 & cvr11!=-8
drop help

keep newid married

*TO DO: change path to where you saved the following file "TTHAI10.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI10, nogenerate
/**/


*TO DO: decide whether you need/want to change path for saving TTHAI10
/**/
save TTHAI10, replace
/**/

*TO DO: change path to where you saved the following file "hh06_04hc_tab1.dta" of the 2006 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2006/hh06_04hc_tab1.dta", clear
/**/

*Age of owner
g ownerage=hc5

*Gender of owner
g female=(hc4==3) if hc4!=.

*Education of owner
g ownertertiary=(hc7==47 | hc7==49 | hc7==51 | hc7==53) if hc7!=. & hc7!=-999 & hc7!=-888

*Years of education
*I assume the number is the years of education and calculate 6 years for primary and 6 years for secondary
*Sources: 	https://en.wikipedia.org/wiki/Education_in_Thailand
*			http://open_jicareport.jica.go.jp/pdf/11548013.pdf
g educyears=0 if hc7==1 | hc7==3 | hc7==5 | hc7==7 | hc7==9
replace educyears=1 if hc7==11
replace educyears=2 if hc7==13
replace educyears=3 if hc7==15
replace educyears=4 if hc7==17
replace educyears=5 if hc7==19
replace educyears=6 if hc7==21
replace educyears=7 if hc7==23
replace educyears=7 if hc7==25
replace educyears=8 if hc7==27
replace educyears=9 if hc7==29
replace educyears=10 if hc7==31 | hc7==41
replace educyears=11 if hc7==33 | hc7==43
replace educyears=12 if hc7==35 | hc7==45
replace educyears=13 if hc7==37 | hc7==47 | hc7==51 | hc7==55
replace educyears=14 if hc7==39 | hc7==49 | hc7==53 | hc7==57
replace educyears=15 if hc7==59
replace educyears=16 if hc7==61

*Child under 5 in household
g under5=0
replace under5=. if hc5==. 
replace under5=1 if hc5<5 
bysort newid: egen childunder5=max(under5)
drop under5

*Child aged 5 to 12 in household
g aged5to12=0
replace aged5to12=. if  hc5==. 
replace aged5to12=1 if  hc5>=5 &  hc5<12
bysort newid: egen childaged5to12=max(aged5to12)
drop aged5to12

*Has adult aged 65+ in the household
g is65orover=0
replace is65orover=. if hc5==. 
replace is65orover=1 if hc5>=65 & hc5!=. 
bysort newid: egen adult65andover=max(is65orover)
drop is65orover

keep newid number ownerage-adult65andover

*TO DO: change path to where you saved the following file "hh06_05oc_tab1.dta" of the 2006 annual household resurvey
/*EXAMPLE:*/
merge 1:1 newid number using "Townsend Thai Project/2006/hh06_05oc_tab1.dta", nogenerate
/**/

g businessowner=(oc1b==1) if oc1b!=. & oc1b!=.c & oc1b!=.b

/*I code individuals as wage workers if the type of employment reported is either:
 - employee - daily wages, or
 - employee - monthly wages, or
 - government worker.
 I do not consider individuals to be wage workers if the type of employment reported is either:
 - owner of business, or
 - unpaid family worker, or
 - employee - piece rate, in house, or
 - employee - piece rate, out of house, or
 - other.
*/

*Worked as wage worker in last month
g wageworker=(oc1b==5 | oc1b==7 | oc1b==13) if oc1b!=. & oc1b!=.c & oc1b!=.b

*Labor earnings in last month
*Replace missing values:
replace oc1c=. if oc1c==.b | oc1c==.c | oc1c==.y
g laborincome=oc1c if oc1b==7 | oc1b==13
*For government workers it is not clear if the wages are given on a daily or monthly frequency, but I assume from the values that they are monthly
*In case wages are given for a daily frequency, I multiply them with 20 to have monthly wages:
replace laborincome=oc1c*20 if oc1b==5

*Retired
g retired=(oc1a==1) if  oc1a!=.

keep newid number ownerage-adult65andover businessowner wageworker laborincome retired

*TO DO: change path to where you saved the following file "TTHAI10.dta"
/*EXAMPLE:*/
merge m:1 newid using TTHAI10, nogenerate 
/**/

g hhbusowner=(businessowner==1) if hhbus==1 & businessowner!=.

drop businessowner

duplicates tag newid hhbusowner if hhbus==1 & hhbusowner==1, gen(totalowners)
replace totalowners=totalowners+1

g jointbus=(totalowners>1) if hhbus==1 & totalowners!=.

*TO DO: decide whether you need/want to change path for saving TTHAI10
/**/
save TTHAI10, replace
/**/

*Household consumption
*TO DO: change path to where you saved the following file "hh06_04hc.dta" of the 2006 annual household resurvey
/*EXAMPLE:*/
use "Townsend Thai Project/2006/hh06_04hc.dta", clear
/**/
keep newid hc1

*TO DO: change path to where you saved the following file "hh06_15ex.dta" of the 2006 annual household resurvey
/*EXAMPLE:*/
merge 1:1 newid using "Townsend Thai Project/2006/hh06_15ex.dta", nogenerate
/**/
*TO DO: change path to where you saved the following file "hh06_15ex_tab1.dta" of the 2006 annual household resurvey
/*EXAMPLE:*/
merge 1:m newid using "Townsend Thai Project/2006/hh06_15ex_tab1.dta", nogenerate
/**/
replace ex4=. if ex4==.b | ex4==.c | ex4==.y

bysort newid: egen monthlyexp=total(ex4),m

keep newid monthlyexp hc1 ex5-ex9
duplicates drop

replace monthlyexp=12*monthlyexp
egen hh_exp=rowtotal(monthlyexp ex5-ex9), missing

g pcexpend=hh_exp/hc1

drop monthlyexp hh_exp hc1 ex5-ex9

*TO DO: change path to where you saved the following file "TTHAI10.dta"
/*EXAMPLE:*/
merge 1:m newid using TTHAI10, nogenerate
/**/

*Exchange rate for approximate midpoint of survey period
/*According to the documentation, the data was collected in May 2006, so I use May 15
 as approximate midpoint for the exchange rate*/

g excrate=0.02628

g excratemonth="5-2006"


foreach var of varlist ownerage ownertertiary educyears married childunder5 childaged5to12 adult65andover wageworker laborincome retired sales reasonforclosure wave surveyyear hhbusclosure typeofbusclosed hhbus enf_bus newfirmquex tbdropped nonfarm typeofbus retail manuf services othersector agefirm employees totalworkers expenses profits hhbusowner totalowners jointbus pcexpend excrate*{ 
rename `var' `var'_2006
} 

rename number hc_id

*TO DO: decide whether you need/want to change path for saving TTHAI10
/**/
save TTHAI10, replace
/**/

*TO DO: change path to where you saved the following file "TTHAImaster.dta"
/*EXAMPLE:*/
use TTHAImaster,clear
/**/
*TO DO: decide whether you need/want to change path for saving TTHAI10

/**/
merge 1:1 newid hc_id using TTHAI10, gen(_merge9) update
/**/

*TO DO: decide whether you need/want to change path for saving TTHAImaster
/**/
save TTHAImaster, replace
/**/

********************************************************************************
*Round 11
********************************************************************************
*TO DO: change path to where you saved the following file "hh07_13ba.txt" of the 2007 annual household resurvey
/*EXAMPLE:*/
import delimited "Townsend Thai Project/2007/hh07_13ba.txt", encoding(ISO-8859-1) clear
/**/

*Survey round number
g wave=11

*Year survey took place
g surveyyear=2007

*Business closure in past 12 months
g hhbusclosure=(ba1a==1) if (ba1a==1 | ba1a==3) & ba1a!=.

/*Although the questionnaire asks for reasons, the business was closed (question ba1c),
this variable is not in the dataset and also not in the codebook file*/
g typeofbusclosed=ba1b

*I keep the open ended reasons for closure as for now to be able to decide later on appropriate coding
rename ba1c reasonforclosure

*Household operates a business
g hhbus=(ba1d==1) if ba1d!=.

*TO DO: decide whether you need/want to change path for saving TTHAI11
/**/
save TTHAI11, replace 
/**/

*TO DO: change path to where you saved the following file "hh07_13ba_tab1.txt" of the 2007 annual household resurvey
/*EXAMPLE:*/
import delimited "Townsend Thai Project/2007/hh07_13ba_tab1.txt", encoding(ISO-8859-1) clear
/**/

/*Only keep the information for the first business as I will only consider businesses
 of households who have only one business:*/
keep if bnumber==1

*TO DO: change path to where you saved the following file "TTHAI11.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI11, nogenerate
/**/

*Household entirely owns household business
replace ba2=0 if hhbus==0

g enf_bus=(ba6==1) if ba6!=.

*Household entirely owns household business
*Business founded in last 12 months:
g newfirmquex=(ba21a==1) if ba21a!=.

/*I will only consider household enterprises if the household operates only one 
enterprise and if this enterprise is entirely owned by the household:*/
g tbdropped=(ba2>1) if ba2!=. | enf_bus!=1

*Since the questionnaire mixes non-farm and farm enterprises:
g nonfarm=(ba3a==1 | ba3a==3 | ba3a==5 | ba3a==15 | ba3a==17 | ba3a==19) if hhbus==1 & ba3a!=.

replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="10-wheels truck and tractor for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="10-wheels truck for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="6-wheels truck for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Animal foods tranportation for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Car-care service"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Construction contractor"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Drive a vehicle for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Fill lands with soils"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Let houses for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Let musical instruments for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Let party accessories for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Let rooms for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Let snooker tables for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Let stereoes for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Make cloth flowers"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Make clothes"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Make dolls"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Make dress"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Make floor mats"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Make mops"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Make wooden sticks for barbecued chicken"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Music band"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Petrol station"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Process teak"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Produce metal doors"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Produce roman pillars"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Ready-made food producer"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Repair clothes"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Repair shoes"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Ride a taxi-motorcycle"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Self service laundry"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Sell foods"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Sew cloth"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Tie vetiver grass for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Trade antiques"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Trade paddy husk"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Trade stones and sand"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Tree cutting for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Tricycle for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Truck for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Vehicle for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Weave cloth for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Wooden handicraft products"

replace hhbus=0 if nonfarm==0
replace hhbus=. if nonfarm==. & hhbus!=0

*Type of business
g typeofbus=ba3a if hhbus==1

*Sector of the firm:
*Firm is in retail trade
g retail=(ba3a==1 | ba3a==17) if hhbus==1
replace retail=1 if hhbus==1 & ba3a==21 & (ba3ao2=="Petrol station"| ba3ao2=="Tie vetiver grass for sale" | ba3ao2=="Trade antiques" | ba3ao2=="Trade paddy husk" | ba3ao2=="Trade stones and sand")

*Firm is in manufacturing sector
g manuf=(ba3a==21 & (ba3ao2=="Make cloth flowers" | ba3ao2=="Make clothes" | ba3ao2=="Make dolls" | ba3ao2=="Make dress" | ba3ao2=="Make floor mats" | ba3ao2=="Make mops" | ba3ao2=="Make wooden sticks for barbecued chicken" | ba3ao2=="Process teak" | ba3ao2=="Produce metal doors" | ba3ao2=="Produce roman pillars" | ba3ao2=="Sew cloth" | ba3ao2=="Weave cloth for sale")) if hhbus==1  
  
*Firm is in service sector
g services=(ba3a==3 | ba3a==5 | ba3a==15 | ba3a==19) if hhbus==1
replace services=1 if hhbus==1 & ba3a==21 & (ba3ao2=="10-wheels truck and tractor for hire" | ba3ao2=="10-wheels truck for hire" | ba3ao2=="6-wheels truck for hire" | ba3ao2=="Animal foods tranportation for hire" | ba3ao2=="Car-care service" | ba3ao2=="Drive a vehicle for hire" | ba3ao2=="Let houses for rent" | ba3ao2=="Let musical instruments for rent" | ba3ao2=="Let party accessories for rent" | ba3ao2=="Let rooms for rent" | ba3ao2=="Let snooker tables for rent" | ba3ao2=="Let stereoes for rent" | ba3ao2=="Music band" | ba3ao2=="Ready-made food producer" |  ba3ao2=="Repair clothes" | ba3ao2=="Repair shoes" | ba3ao2=="Ride a taxi-motorcycle" | ba3ao2=="Self service laundry"  | ba3ao2=="Sell foods" | ba3ao2=="Tree cutting for hire" | ba3ao2=="Tricycle for hire" | ba3ao2=="Truck for hire" | ba3ao2=="Vehicle for hire") 

*Firm is in other sector
g othersector=(retail==0 & manuf==0 & services==0) if hhbus==1 

replace othersector=. if hhbus==1 & ba3ao2=="Wooden handicraft products"
replace services=. if hhbus==1 & ba3ao2=="Wooden handicraft products"
replace manuf=. if hhbus==1 & ba3ao2=="Wooden handicraft products"
replace retail=. if hhbus==1 & ba3ao2=="Wooden handicraft products"


*Age of the firm in years
g agefirm=ba4 if hhbus==1 

*Number of paid employees
g employees=ba12 if hhbus==1 

g totalworkers=ba9 if hhbus==1 

keep newid reasonforclosure wave-totalworkers

*TO DO: decide whether you need/want to change path for saving TTHAI11
/**/
save TTHAI11, replace
/**/

*TO DO: change path to where you saved the following file "hh07_16in_tab1.txt" of the 2007 annual household resurvey
/*EXAMPLE:*/
import delimited "Townsend Thai Project/2007/hh07_16in_tab1.txt", encoding(ISO-8859-1) clear
/**/

*Business sales in last month
keep if number=="N" | number=="O" | number=="P" | number=="Q" | number=="R" | number=="S" | number=="U" | number=="AA"
replace in4=0 if in2==3
bysort newid: egen sales=total(in4), m
*Since sales are given for past 12 months:
replace sales=sales/12

keep newid sales
duplicates drop

*TO DO: change path to where you saved the following file "TTHAI11.dta" 
/*EXAMPLE:*/
merge 1:1 newid using TTHAI11, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving TTHAI11
/**/
save TTHAI11, replace
/**/

*TO DO: change path to where you saved the following file "hh07_16in.txt" of the 2007 annual household resurvey
/*EXAMPLE:*/
import delimited "Townsend Thai Project/2007/hh07_16in.txt", encoding(ISO-8859-1) clear
/**/

g expenses=in10b/12 

keep newid expenses

*TO DO: change path to where you saved the following file "TTHAI11.dta" 
/*EXAMPLE:*/
merge 1:1 newid using TTHAI11, nogenerate
/**/

g profits=sales-expenses if hhbus==1

*TO DO: decide whether you need/want to change path for saving TTHAI11
/**/
save TTHAI11, replace
/**/


*TO DO: change path to where you saved the following file "hh07_01cvr.txt" of the 2007 annual household resurvey
/*EXAMPLE:*/
import delimited "Townsend Thai Project/2007/hh07_01cvr.txt", encoding(ISO-8859-1) clear
/**/

*Marital status of owner
*Since the marital status is only given for household heads, I can only compute it for head and their spouses
g help=1 if cvr7==1 | cvr7==3 
g married=(cvr11==3) if help==1 & cvr11!=-8
drop help

keep newid married

*TO DO: change path to where you saved the following file "TTHAI11.dta" 
/*EXAMPLE:*/
merge 1:1 newid using TTHAI11, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving TTHAI11
/**/
save TTHAI11, replace
/**/

*TO DO: change path to where you saved the following file "hh07_05oc_tab1.txt" of the 2007 annual household resurvey
/*EXAMPLE:*/
import delimited "Townsend Thai Project/2007/hh07_05oc_tab1.txt", encoding(ISO-8859-1) clear
/**/

*TO DO: decide whether you need/want to change path for saving "hh07_05oc_tab1.dta"
/**/
save "Townsend Thai Project/2007/hh07_05oc_tab1.dta", replace
/**/

*TO DO: change path to where you saved the following file "hh07_04hc_tab1.txt" of the 2007 annual household resurvey
/*EXAMPLE:*/
import delimited "Townsend Thai Project/2007/hh07_04hc_tab1.txt", encoding(ISO-8859-1) clear
/**/

*Age of owner
g ownerage=hc5

*Gender of owner
g female=(hc4==3) if hc4!=.

*Education of owner
g ownertertiary=(hc7==47 | hc7==49 | hc7==51 | hc7==53) if hc7!=. & hc7!=-999 & hc7!=-888

*Years of education
*I assume the number is the years of education and calculate 6 years for primary and 6 years for secondary
*Sources: 	https://en.wikipedia.org/wiki/Education_in_Thailand
*			http://open_jicareport.jica.go.jp/pdf/11548013.pdf
g educyears=0 if hc7==1 | hc7==3 | hc7==5 | hc7==7 | hc7==9
replace educyears=1 if hc7==11
replace educyears=2 if hc7==13
replace educyears=3 if hc7==15
replace educyears=4 if hc7==17
replace educyears=5 if hc7==19
replace educyears=6 if hc7==21
replace educyears=7 if hc7==23
replace educyears=7 if hc7==25
replace educyears=8 if hc7==27
replace educyears=9 if hc7==29
replace educyears=10 if hc7==31 | hc7==41
replace educyears=11 if hc7==33 | hc7==43
replace educyears=12 if hc7==35 | hc7==45
replace educyears=13 if hc7==37 | hc7==47 | hc7==51 | hc7==55
replace educyears=14 if hc7==39 | hc7==49 | hc7==53 | hc7==57
replace educyears=15 if hc7==59
replace educyears=16 if hc7==61

*Child under 5 in household
g under5=0
replace under5=. if hc5==. 
replace under5=1 if hc5<5 
bysort newid: egen childunder5=max(under5)
drop under5

*Child aged 5 to 12 in household
g aged5to12=0
replace aged5to12=. if  hc5==. 
replace aged5to12=1 if  hc5>=5 &  hc5<12
bysort newid: egen childaged5to12=max(aged5to12)
drop aged5to12

*Has adult aged 65+ in the household
g is65orover=0
replace is65orover=. if hc5==. 
replace is65orover=1 if hc5>=65 & hc5!=. 
bysort newid: egen adult65andover=max(is65orover)
drop is65orover

keep newid number ownerage-adult65andover

*TO DO: change path to where you saved the following file "hh07_05oc_tab1.dta" of the 2007 annual household resurvey
/*EXAMPLE:*/
merge 1:1 newid number using "Townsend Thai Project/2007/hh07_05oc_tab1.dta", nogenerate
/**/

g businessowner=(oc1b==1) if oc1b!=. 

/*I code individuals as wage workers if the type of employment reported is either:
 - employee - daily wages, or
 - employee - monthly wages, or
 - government worker.
 I do not consider individuals to be wage workers if the type of employment reported is either:
 - owner of business, or
 - unpaid family worker, or
 - employee - piece rate, in house, or
 - employee - piece rate, out of house, or
 - other.
*/

*Worked as wage worker in last month
g wageworker=(oc1b==5 | oc1b==7 | oc1b==13) if oc1b!=.

*Labor earnings in last month
*Replace missing values:
g laborincome=oc1c if oc1b==7 | oc1b==13
*For government workers it is not clear if the wages are given on a daily or monthly frequency, but I assume from the values that they are monthly
*In case wages are given for a daily frequency, I multiply them with 20 to have monthly wages:
replace laborincome=oc1c*20 if oc1b==5

*Retired
g retired=(oc1a==1) if  oc1a!=.

keep newid number ownerage-adult65andover businessowner wageworker laborincome retired

*TO DO: change path to where you saved the following file "TTHAI11.dta"
/*EXAMPLE:*/
merge m:1 newid using TTHAI11, nogenerate 
/**/

g hhbusowner=(businessowner==1) if hhbus==1 & businessowner!=.

drop businessowner

duplicates tag newid hhbusowner if hhbus==1 & hhbusowner==1, gen(totalowners)
replace totalowners=totalowners+1

g jointbus=(totalowners>1) if hhbus==1 & totalowners!=.

*TO DO: decide whether you need/want to change path for saving "TTHAI11.dta"
/**/
save TTHAI11, replace
/**/

*Household consumption
*TO DO: change path to where you saved the following file "hh07_15ex.txt" of the 2007 annual household resurvey
/*EXAMPLE:*/
import delimited "Townsend Thai Project/2007/hh07_15ex.txt", encoding(ISO-8859-1) clear
/**/

*TO DO: decide whether you need/want to change path for saving "hh07_15ex.dta"
/**/
save "Townsend Thai Project/2007/hh07_15ex.dta", replace
/**/

*TO DO: change path to where you saved the following file "hh07_15ex_tab1.txt" of the 2007 annual household resurvey
/*EXAMPLE:*/
import delimited "Townsend Thai Project/2007/hh07_15ex_tab1.txt", encoding(ISO-8859-1) clear
/**/

*TO DO: decide whether you need/want to change path for saving "hh07_15ex_tab1.dta"
/**/
save "Townsend Thai Project/2007/hh07_15ex_tab1.dta", replace
/**/

*TO DO: change path to where you saved the following file "hh07_04hc.txt" of the 2007 annual household resurvey
/*EXAMPLE:*/
import delimited "Townsend Thai Project/2007/hh07_04hc.txt", encoding(ISO-8859-1) clear
/**/

keep newid hc1

*TO DO: change path to where you saved the following file "hh07_15ex.dta" of the 2007 annual household resurvey
/*EXAMPLE:*/
merge 1:1 newid using "Townsend Thai Project/2007/hh07_15ex.dta", nogenerate
/**/

*TO DO: change path to where you saved the following file "hh07_15ex_tab1.dta" of the 2007 annual household resurvey
/*EXAMPLE:*/
merge 1:m newid using "Townsend Thai Project/2007/hh07_15ex_tab1.dta", nogenerate
/**/

replace ex4=. if ex4==.b | ex4==.c | ex4==.y

bysort newid: egen monthlyexp=total(ex4),m

keep newid monthlyexp hc1 ex5-ex9
duplicates drop

replace monthlyexp=12*monthlyexp
egen hh_exp=rowtotal(monthlyexp ex5-ex9), missing

g pcexpend=hh_exp/hc1

drop monthlyexp hh_exp hc1 ex5-ex9

*TO DO: change path to where you saved the following file "TTHAI11.dta" 
/*EXAMPLE:*/
merge 1:m newid using TTHAI11, nogenerate
/**/

*Exchange rate for approximate midpoint of survey period
/*There is no documentation for the 2007 survey round but I assume that for this round
 wthe data was also collected in May, so I use May 15 as approximate midpoint for the exchange rate*/

g excrate=0.02991

g excratemonth="5-2007"


foreach var of varlist ownerage ownertertiary educyears married childunder5 childaged5to12 adult65andover wageworker laborincome retired sales reasonforclosure wave surveyyear hhbusclosure typeofbusclosed hhbus enf_bus newfirmquex tbdropped nonfarm typeofbus retail manuf services othersector agefirm employees totalworkers expenses profits hhbusowner totalowners jointbus pcexpend excrate*{ 
rename `var' `var'_2007
} 

rename number hc_id

tostring newid, replace format(%12.0f)
replace newid="0"+newid if strlen(newid)==11

*TO DO: decide whether you need/want to change path for saving "TTHAI11.dta"
/**/
save TTHAI11, replace
/**/

*TO DO: change path to where you saved the following file "TTHAImaster.dta" 
/*EXAMPLE:*/
use TTHAImaster,clear
/**/

*TO DO: change path to where you saved the following file "TTHAI11.dta" 
/*EXAMPLE:*/
merge 1:1 newid hc_id using TTHAI11, gen(_merge10) update
/**/

*TO DO: decide whether you need/want to change path for saving "TTHAImaster.dta"
/**/
save TTHAImaster, replace
/**/

********************************************************************************
*Round 12 - Rural sample
********************************************************************************
*TO DO: change path to where you saved the following file "hh08_13ba.txt" of the 2008 annual household resurvey (rural sample)
/*EXAMPLE:*/
import delimited "Townsend Thai Project/2008/hh08_13ba.txt", encoding(ISO-8859-1) clear
/**/

*Survey round number
g wave=12

*Year survey took place
g surveyyear=2008

*Business closure in past 12 months
g hhbusclosure=(ba1a==1) if (ba1a==1 | ba1a==3) & ba1a!=.

/*Although the questionnaire asks for reasons, the business was closed (question ba1c),
this variable is not in the dataset and also not in the codebook file*/
g typeofbusclosed=ba1b

*I keep the open ended reasons for closure as for now to be able to decide later on appropriate coding
rename ba1c reasonforclosure

*Household operates a business
g hhbus=(ba1d==1) if ba1d!=.

*TO DO: decide whether you need/want to change path for saving "TTHAI12.dta"
/**/
save TTHAI12, replace 
/**/

*TO DO: change path to where you saved the following file "hh08_13ba_tab1.txt" of the 2008 annual household resurvey (rural sample)
/*EXAMPLE:*/
import delimited "Townsend Thai Project/2008/hh08_13ba_tab1.txt", encoding(ISO-8859-1) clear
/**/

/*Only keep the information for the first business as I will only consider businesses
 of households who have only one business:*/
keep if bnumber==1

*TO DO: change path to where you saved the following file "TTHAI12.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI12, nogenerate
/**/

*Household entirely owns household business
replace ba2=0 if hhbus==0

g enf_bus=(ba6==1) if ba6!=.

*Household entirely owns household business
*Business founded in last 12 months:
g newfirmquex=(ba21a==1) if ba21a!=.

/*I will only consider household enterprises if the household operates only one 
enterprise and if this enterprise is entirely owned by the household:*/
g tbdropped=(ba2>1) if ba2!=. | enf_bus!=1

*Since the questionnaire mixes non-farm and farm enterprises:
g nonfarm=(ba3a==1 | ba3a==3 | ba3a==5 | ba3a==15 | ba3a==17 | ba3a==19) if hhbus==1 & ba3a!=.

replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="10-wheels truck for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="6-wheels truck for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Brass band"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Car-care service"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Construction contractor"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Garbage vehicle business"
replace nonfarm=. if hhbus==1 & ba3a==21 & ba3ao2=="Hitting tom-tom for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Let houses for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Let party accessories for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Let rooms for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Let snooker tables for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Make cloth flowers"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Make clothes"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Make dolls"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Minibus for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Music band"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Petrol station"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Produce grill doors"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Produce roman pillars"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="School van"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Service trucks sent rocks, soil"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Sew cloth"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Sewing foot scraper"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Taxi-motorcycle"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Tractor and truck for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Trade antiques"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Transport soil"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Tricycle for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Truck for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Wooden handicraft products"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="car wash"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="cutting wood"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="direct sale business"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="electone band"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="embroidery"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="engined tricycle for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="hired 6 wheels truck"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="make a broom"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="make iron for robber prevention"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making blooms for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="painting for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell steamed rice"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="shoes repair shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="snooker table"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to do cloth making"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to repair cloth"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="transportation services for students"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="transportation services for workers"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="wood handicraft"

replace hhbus=0 if nonfarm==0
replace hhbus=. if nonfarm==. & hhbus!=0

*Type of business
g typeofbus=ba3a if hhbus==1

*Sector of the firm:
*Firm is in retail trade
g retail=(ba3a==1 | ba3a==17) if hhbus==1
replace retail=1 if hhbus==1 & ba3a==21 & ( ba3ao2=="Petrol station" | ba3ao2=="Trade antiques" | ba3ao2=="direct sale business")

*Firm is in manufacturing sector
g manuf=(ba3a==21 & (ba3ao2=="Make cloth flowers" | ba3ao2=="Make clothes" | ba3ao2=="Make dolls" | ba3ao2=="Produce grill doors" | ba3ao2=="Produce roman pillars" | ba3ao2=="embroidery" | ba3ao2=="make a broom" | ba3ao2=="make iron for robber prevention" | ba3ao2=="to do cloth making" | ba3ao2=="wood handicraft" )) if hhbus==1  
   
*Firm is in service sector
g services=(ba3a==3 | ba3a==5 | ba3a==15 | ba3a==19) if hhbus==1
replace services=1 if hhbus==1 & ba3a==21 & (ba3ao2=="10-wheels truck for hire" | ba3a==21 & ba3ao2=="6-wheels truck for hire" | ba3ao2=="Brass band" | ba3ao2=="Car-care service"| ba3ao2=="Let houses for rent" | ba3ao2=="Let party accessories for rent" | ba3ao2=="Let rooms for rent" | ba3ao2=="Let snooker tables for rent" | ba3ao2=="Minibus for hire" | ba3ao2=="Music band" | ba3ao2=="School van" | ba3ao2=="Taxi-motorcycle" | ba3ao2=="Tractor and truck for hire" | ba3ao2=="Transport soil" | ba3ao2=="Tricycle for hire" | ba3ao2=="Truck for hire" | ba3ao2=="car wash" | ba3ao2=="electone band" | ba3ao2=="engined tricycle for hire" | ba3ao2=="hired 6 wheels truck" | ba3ao2=="sell steamed rice" | ba3ao2=="shoes repair shop" | ba3ao2=="snooker table" | ba3ao2=="to repair cloth" | ba3ao2=="transportation services for students" | ba3ao2=="transportation services for workers")

*Firm is in other sector
g othersector=(retail==0 & manuf==0 & services==0) if hhbus==1 

replace othersector=. if hhbus==1 & (ba3ao2=="Service trucks sent rocks, soil" | ba3ao2=="Wooden handicraft products" | ba3ao2=="cutting wood" | ba3ao2=="making blooms for sale" )
replace services=. if hhbus==1 & (ba3ao2=="Service trucks sent rocks, soil" | ba3ao2=="Wooden handicraft products" | ba3ao2=="cutting wood" | ba3ao2=="making blooms for sale" )
replace manuf=. if hhbus==1 & (ba3ao2=="Service trucks sent rocks, soil" | ba3ao2=="Wooden handicraft products" | ba3ao2=="cutting wood" | ba3ao2=="making blooms for sale" )
replace retail=. if hhbus==1 & (ba3ao2=="Service trucks sent rocks, soil" | ba3ao2=="Wooden handicraft products" | ba3ao2=="cutting wood" | ba3ao2=="making blooms for sale" )


*Age of the firm in years
g agefirm=ba4 if hhbus==1 

*Number of paid employees
g employees=ba12 if hhbus==1 

g totalworkers=ba9 if hhbus==1 

keep newid reasonforclosure wave-totalworkers

*TO DO: decide whether you need/want to change path for saving "TTHAI12.dta"
/**/
save TTHAI12, replace
/**/

*TO DO: change path to where you saved the following file "hh08_16in_tab1.txt" of the 2008 annual household resurvey (rural sample)
/*EXAMPLE:*/
import delimited "Townsend Thai Project/2008/hh08_16in_tab1.txt", encoding(ISO-8859-1) clear
/**/

*Business sales in last month
keep if number=="N" | number=="O" | number=="P" | number=="Q" | number=="R" | number=="S" | number=="U" | number=="AA"
replace in4=0 if in2==3
bysort newid: egen sales=total(in4), m
*Since sales are given for past 12 months:
replace sales=sales/12

keep newid sales
duplicates drop

*TO DO: change path to where you saved the following file "TTHAI12.dta" 
/*EXAMPLE:*/
merge 1:1 newid using TTHAI12, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving "TTHAI12.dta"
/**/
save TTHAI12, replace
/**/

*TO DO: change path to where you saved the following file "hh08_16in.txt" of the 2008 annual household resurvey (rural sample)
/*EXAMPLE:*/
import delimited "Townsend Thai Project/2008/hh08_16in.txt", encoding(ISO-8859-1) clear
/**/

g expenses=in10b/12 

keep newid expenses

*TO DO: change path to where you saved the following file "TTHAI12.dta" 
/*EXAMPLE:*/
merge 1:1 newid using TTHAI12, nogenerate
/**/

g profits=sales-expenses if hhbus==1

*TO DO: decide whether you need/want to change path for saving "TTHAI12.dta"
/**/
save TTHAI12, replace
/**/

*TO DO: change path to where you saved the following file "hh08_01cvr.txt" of the 2008 annual household resurvey (rural sample)
/*EXAMPLE:*/
import delimited "Townsend Thai Project/2008/hh08_01cvr.txt", encoding(ISO-8859-1) clear
/**/

*Marital status of owner
*Since the marital status is only given for household heads, I can only compute it for head and their spouses
g help=1 if cvr7==1 | cvr7==3 
g married=(cvr11==3) if help==1 & cvr11!=-8
drop help

keep newid married

*TO DO: change path to where you saved the following file "TTHAI12.dta" 
/*EXAMPLE:*/
merge 1:1 newid using TTHAI12, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving "TTHAI12.dta"
/**/
save TTHAI12, replace
/**/

*TO DO: change path to where you saved the following file "hh08_05oc_tab1.txt" of the 2008 annual household resurvey (rural sample)
/*EXAMPLE:*/
import delimited "Townsend Thai Project/2008/hh08_05oc_tab1.txt", encoding(ISO-8859-1) clear
/**/

*TO DO: decide whether you need/want to change path for saving "hh08_05oc_tab1.dta"
/**/
save "Townsend Thai Project/2008/hh08_05oc_tab1.dta", replace
/**/

*TO DO: change path to where you saved the following file "hh08_04hc_tab1.txt" of the 2008 annual household resurvey (rural sample)
/*EXAMPLE:*/
import delimited "Townsend Thai Project/2008/hh08_04hc_tab1.txt", encoding(ISO-8859-1) clear
/**/

*Age of owner
g ownerage=hc5

*Gender of owner
g female=(hc4==3) if hc4!=.

*Education of owner
g ownertertiary=(hc7==47 | hc7==49 | hc7==51 | hc7==53) if hc7!=. & hc7!=-999 & hc7!=-888

*Years of education
*I assume the number is the years of education and calculate 6 years for primary and 6 years for secondary
*Sources: 	https://en.wikipedia.org/wiki/Education_in_Thailand
*			http://open_jicareport.jica.go.jp/pdf/11548013.pdf
g educyears=0 if hc7==1 | hc7==3 | hc7==5 | hc7==7 | hc7==9
replace educyears=1 if hc7==11
replace educyears=2 if hc7==13
replace educyears=3 if hc7==15
replace educyears=4 if hc7==17
replace educyears=5 if hc7==19
replace educyears=6 if hc7==21
replace educyears=7 if hc7==23
replace educyears=7 if hc7==25
replace educyears=8 if hc7==27
replace educyears=9 if hc7==29
replace educyears=10 if hc7==31 | hc7==41
replace educyears=11 if hc7==33 | hc7==43
replace educyears=12 if hc7==35 | hc7==45
replace educyears=13 if hc7==37 | hc7==47 | hc7==51 | hc7==55
replace educyears=14 if hc7==39 | hc7==49 | hc7==53 | hc7==57
replace educyears=15 if hc7==59
replace educyears=16 if hc7==61

*Child under 5 in household
g under5=0
replace under5=. if hc5==. 
replace under5=1 if hc5<5 
bysort newid: egen childunder5=max(under5)
drop under5

*Child aged 5 to 12 in household
g aged5to12=0
replace aged5to12=. if  hc5==. 
replace aged5to12=1 if  hc5>=5 &  hc5<12
bysort newid: egen childaged5to12=max(aged5to12)
drop aged5to12

*Has adult aged 65+ in the household
g is65orover=0
replace is65orover=. if hc5==. 
replace is65orover=1 if hc5>=65 & hc5!=. 
bysort newid: egen adult65andover=max(is65orover)
drop is65orover

*TO DO: change path to where you saved the following file "hh08_05oc_tab1.dta" of the 2008 annual household resurvey (rural sample)
/*EXAMPLE:*/
merge 1:1 newid number using "Townsend Thai Project/2008/hh08_05oc_tab1.dta", nogenerate
/**/

g businessowner=(oc1b==1) if oc1b!=. 

/*I code individuals as wage workers if the type of employment reported is either:
 - employee - daily wages, or
 - employee - monthly wages, or
 - government worker.
 I do not consider individuals to be wage workers if the type of employment reported is either:
 - owner of business, or
 - unpaid family worker, or
 - employee - piece rate, in house, or
 - employee - piece rate, out of house, or
 - other.
*/

*Worked as wage worker in last month
g wageworker=(oc1b==5 | oc1b==7 | oc1b==13) if oc1b!=.

*Labor earnings in last month
*Replace missing values:
g laborincome=oc1c if oc1b==7 | oc1b==13
*For government workers it is not clear if the wages are given on a daily or monthly frequency, but I assume from the values that they are monthly
*In case wages are given for a daily frequency, I multiply them with 20 to have monthly wages:
replace laborincome=oc1c*20 if oc1b==5

*Retired
g retired=(oc1a==1) if  oc1a!=.

keep newid number ownerage-adult65andover businessowner wageworker laborincome retired

*TO DO: change path to where you saved the following file "TTHAI12.dta"
/*EXAMPLE:*/
merge m:1 newid using TTHAI12, nogenerate 
/**/

g hhbusowner=(businessowner==1) if hhbus==1 & businessowner!=.

drop businessowner

duplicates tag newid hhbusowner if hhbus==1 & hhbusowner==1, gen(totalowners)
replace totalowners=totalowners+1

g jointbus=(totalowners>1) if hhbus==1 & totalowners!=.

*TO DO: decide whether you need/want to change path for saving "TTHAI12.dta"
/**/
save TTHAI12, replace
/**/

*Household consumption
*TO DO: change path to where you saved the following file "hh08_15ex.txt" of the 2008 annual household resurvey (rural sample)
/*EXAMPLE:*/
import delimited "Townsend Thai Project/2008/hh08_15ex.txt", encoding(ISO-8859-1) clear
/**/
*TO DO: decide whether you need/want to change path for saving "hh08_15ex.dta"
/**/
save "Townsend Thai Project/2008/hh08_15ex.dta", replace
/**/

*TO DO: change path to where you saved the following file "hh08_15ex_tab1.txt" of the 2008 annual household resurvey (rural sample)
/*EXAMPLE:*/
import delimited "Townsend Thai Project/2008/hh08_15ex_tab1.txt", encoding(ISO-8859-1) clear
/**/
*TO DO: decide whether you need/want to change path for saving "hh08_15ex_tab1.dta"
/**/
save "Townsend Thai Project/2008/hh08_15ex_tab1.dta", replace
/**/

*TO DO: change path to where you saved the following file "hh08_04hc.txt" of the 2008 annual household resurvey (rural sample)
/*EXAMPLE:*/
import delimited "Townsend Thai Project/2008/hh08_04hc.txt", encoding(ISO-8859-1) clear
/**/
keep newid hc1

*TO DO: change path to where you saved the following file "hh08_15ex.dta" of the 2008 annual household resurvey (rural sample)
/*EXAMPLE:*/
merge 1:1 newid using "Townsend Thai Project/2008/hh08_15ex.dta", nogenerate
/**/

*TO DO: change path to where you saved the following file "hh08_15ex_tab1.dta" of the 2008 annual household resurvey (rural sample)
/*EXAMPLE:*/
merge 1:m newid using "Townsend Thai Project/2008/hh08_15ex_tab1.dta", nogenerate
/**/

replace ex4=. if ex4==.b | ex4==.c | ex4==.y

bysort newid: egen monthlyexp=total(ex4),m

keep newid monthlyexp hc1 ex5-ex9
duplicates drop

replace monthlyexp=12*monthlyexp
egen hh_exp=rowtotal(monthlyexp ex5-ex9), missing

g pcexpend=hh_exp/hc1

drop monthlyexp hh_exp hc1 ex5-ex9

*TO DO: change path to where you saved the following file "TTHAI12.dta"
/*EXAMPLE:*/
merge 1:m newid using TTHAI12, nogenerate
/**/

*Exchange rate for approximate midpoint of survey period
/*There is no documentation for the 2008 survey round but I assume that for this round
 wthe data was also collected in May, so I use May 15 as approximate midpoint for the exchange rate*/

g excrate=0.03063

g excratemonth="5-2008"


foreach var of varlist ownerage ownertertiary educyears married childunder5 childaged5to12 adult65andover wageworker laborincome retired sales reasonforclosure wave surveyyear hhbusclosure typeofbusclosed hhbus enf_bus newfirmquex tbdropped nonfarm typeofbus retail manuf services othersector agefirm employees totalworkers expenses profits hhbusowner totalowners jointbus pcexpend excrate*{ 
rename `var' `var'_2008
} 

rename number hc_id

tostring newid, replace format(%12.0f)
replace newid="0"+newid if strlen(newid)==11

*TO DO: decide whether you need/want to change path for saving "TTHAI12.dta"
/**/
save TTHAI12, replace
/**/
********************************************************************************
*Round 12 - Urban sample
********************************************************************************
*TO DO: change path to where you saved the following file "hh08_13ba.dta" of the 2008 annual household resurvey (urban sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2008/Urban/hh08_13ba.dta", clear
/**/

*Survey round number
g wave=12

*Year survey took place
g surveyyear=2008

*Business closure in past 12 months
g hhbusclosure=(ba1a==1) if (ba1a==1 | ba1a==3) & ba1a!=.c

/*Although the questionnaire asks for reasons, the business was closed (question ba1c),
this variable is not in the dataset and also not in the codebook file*/
g typeofbusclosed=ba1b

*I keep the open ended reasons for closure as for now to be able to decide later on appropriate coding
rename ba1c reasonforclosure

*Household operates a business
g hhbus=(ba1d==1) if ba1d!=.c

*TO DO: decide whether you need/want to change path for saving "TTHAI12u.dta"
/**/
save TTHAI12u, replace 
/**/

*TO DO: change path to where you saved the following file "hh08_13ba_tab1.dta" of the 2008 annual household resurvey (urban sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2008/Urban/hh08_13ba_tab1.dta", clear
/**/

/*Only keep the information for the first business as I will only consider businesses
 of households who have only one business:*/
keep if bnumber==1

*TO DO: change path to where you saved the following file "TTHAI12u.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI12u, nogenerate
/**/

*Household entirely owns household business
replace ba2=0 if hhbus==0

g enf_bus=(ba6==1) if ba6!=.

*Household entirely owns household business
*Business founded in last 12 months:
g newfirmquex=(ba21a==1) if ba21a!=.

/*I will only consider household enterprises if the household operates only one 
enterprise and if this enterprise is entirely owned by the household:*/
g tbdropped=(ba2>1) if ba2!=.c | enf_bus!=1

*Since the questionnaire mixes non-farm and farm enterprises:
g nonfarm=(ba3a==1 | ba3a==3 | ba3a==5 | ba3a==15 | ba3a==17 | ba3a==19) if hhbus==1 & ba3a!=.c

replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="10-wheels truck for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="6 wheels truck for soil carrying"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Arrange vans' queqe"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Clothes making shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Construction contractor"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Drive a pick-up for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Fill lands with soils"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Install gutters"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Khanom Peer (a kind of sweets) shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Land filling contractor"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Laundry service"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Laundry service shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Let houses for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Let rooms for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Make banners and boards"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Make bird cages for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Make clothes"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Printing shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Produce bricks/blocks"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Produce drinking water for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Produce furnitures"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Produce grills"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Produce herb juice"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Repair electric appliances"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="School van"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Self service laundry"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Sell and repair boiler and exhuast pipes"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Sew cloth"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Som Tam(a kind of Thai food) shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Taxi-motorcycle"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Thai traditional massage"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Trade antiques"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Tricycle for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Van for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Vehicle care taking service"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Vehicle for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="bicycle and spare parts shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buy and sell buddha image"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="car audio set up"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="car pad making shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="cook sweet tamarine"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="curtain making"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="dormitory/student hostel"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="flowers arrangement shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="furniture repair"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="furniture shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="glass panel set up"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="hire movie"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="hired 6 wheels truck"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="hired car for articles transfer"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="hired motercycle and hired pick-up car"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="hired pickup car"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="hired taxi"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="hired tricycle"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="hired van"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="ice shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="lathe shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="laundry"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="laundry shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="make furniture to sell"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="make wood furniture"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="mobile phone accessory shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="movie present car"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="musical playing"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="open air movie show"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="repair and making exhaust pipe shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="repair mobile phone shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="second-hand car tent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell baked clay pottery"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell cloth and shoe"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell coffin"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell food"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell furniture"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell government lottery"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell second-hand motercycle"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell sweets"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="snooker table"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to attach and repair house"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to cook sweets"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to do advertising signboard"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to do advertising spot record"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to do all kinds of iron work"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to do banquet"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to do cloth making"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to do cloth sewing"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to do decoration"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to do electricity line( an electrician)"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to do glass and aluminium set up"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to do house electricity line"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to do iron making for robber prevention"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to do laundry"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to do ready cooked food"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to hammer iron"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to machine wood work"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to make curtain and set up"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to make frame of buddha image"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to make iron hook"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to make strove"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to repair air condition"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to repair car electricity system"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to repair cloth"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to sell ready cooked food"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to suck water in toilet"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="traditonal song and dance drama"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="tutor room"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="typing and photo copy"

replace hhbus=0 if nonfarm==0
replace hhbus=. if nonfarm==. & hhbus!=0

*Type of business
replace ba3a=. if ba3a==.c
g typeofbus=ba3a if hhbus==1

*Sector of the firm:
*Firm is in retail trade
g retail=(ba3a==1 | ba3a==17) if hhbus==1
replace retail=1 if hhbus==1 & ba3a==21 & (ba3ao2=="Trade antiques" | ba3ao2=="bicycle and spare parts shop" | ba3ao2=="furniture shop" | ba3ao2=="mobile phone accessory shop" | ba3ao2=="sell baked clay pottery" | ba3ao2=="sell cloth and shoe" | ba3ao2=="sell furniture" | ba3ao2=="sell government lottery" | ba3ao2=="sell second-hand motercycle")


*Firm is in manufacturing sector
g manuf=(ba3a==21 & (ba3ao2=="Clothes making shop" | ba3ao2=="Make banners and boards" | ba3ao2=="Make bird cages for sale" | ba3ao2=="Make clothes" | ba3ao2=="Produce bricks/blocks" | ba3ao2=="Produce drinking water for sale" | ba3ao2=="Produce furnitures" | ba3ao2=="Produce grills" | ba3ao2=="Produce herb juice" | ba3ao2=="Sew cloth" | ba3ao2=="curtain making" | ba3ao2=="make furniture to sell" | ba3ao2=="make wood furniture" | ba3ao2=="to do advertising signboard" | ba3ao2=="to do all kinds of iron work" | ba3ao2=="to do cloth making" | ba3ao2=="to do cloth sewing" |  ba3ao2=="to do iron making for robber prevention" | ba3ao2=="to make curtain and set up" | ba3ao2=="to make frame of buddha image" | ba3ao2=="to make iron hook")) if hhbus==1  
   
*Firm is in service sector
g services=(ba3a==3 | ba3a==5 | ba3a==15 | ba3a==19) if hhbus==1
replace services=1 if hhbus==1 & ba3a==21 & (ba3ao2=="10-wheels truck for hire" | ba3ao2=="6 wheels truck for soil carrying" | ba3ao2=="Drive a pick-up for hire" | ba3ao2=="Khanom Peer (a kind of sweets) shop" | ba3ao2=="Laundry service" | ba3ao2=="Laundry service shop" | ba3ao2=="Let houses for rent" | ba3ao2=="Let rooms for rent" | ba3ao2=="Som Tam(a kind of Thai food) shop" | ba3ao2=="sell food" | ba3ao2=="Printing shop" | ba3ao2=="Repair electric appliances" | ba3ao2=="School van" | ba3ao2=="Self service laundry" | ba3ao2=="Sell and repair boiler and exhuast pipes" | ba3ao2=="Taxi-motorcycle" | ba3ao2=="Thai traditional massage" | ba3ao2=="Tricycle for hire" | ba3ao2=="Van for hire" | ba3ao2=="Vehicle care taking service" | ba3ao2=="Vehicle for hire" | ba3ao2=="car audio set up" | ba3ao2=="cook sweet tamarine" | ba3ao2=="dormitory/student hostel" | ba3ao2=="furniture repair" | ba3ao2=="hire movie" | ba3ao2=="hired 6 wheels truck" | ba3ao2=="hired car for articles transfer" | ba3ao2=="hired motercycle and hired pick-up car" | ba3ao2=="hired pickup car" | ba3ao2=="hired taxi" | ba3ao2=="hired tricycle" | ba3ao2=="hired van" | ba3ao2=="laundry" | ba3ao2=="laundry shop" | ba3ao2=="musical playing" | ba3ao2=="open air movie show" | ba3ao2=="repair and making exhaust pipe shop" | ba3ao2=="repair mobile phone shop" | ba3ao2=="sell food" | ba3ao2=="sell sweets" | ba3ao2=="snooker table" | ba3ao2=="to cook sweets" | ba3ao2=="to do advertising spot record" | ba3ao2=="to do banquet" | ba3ao2=="to do electricity line( an electrician)" | ba3ao2=="to do house electricity line" | ba3ao2=="to do laundry" | ba3ao2=="to do ready cooked food" | ba3ao2=="to repair air condition" | ba3ao2=="to repair car electricity system" | ba3ao2=="to repair cloth" | ba3ao2=="to sell ready cooked food" | ba3ao2=="traditonal song and dance drama" | ba3ao2=="tutor room" | ba3ao2=="typing and photo copy")

*Firm is in other sector
g othersector=(retail==0 & manuf==0 & services==0) if hhbus==1 

replace othersector=. if hhbus==1 & (ba3ao2=="Arrange vans' queqe" | ba3ao2=="flowers arrangement shop" | ba3ao2=="glass panel set up" | ba3ao2=="ice shop" | ba3ao2=="lathe shop" | ba3ao2=="movie present car" | ba3ao2=="second-hand car tent" | ba3ao2=="to do decoration" | ba3ao2=="to do glass and aluminium set up" | ba3ao2=="to hammer iron" | ba3ao2=="to machine wood work" | ba3ao2=="to make strove")
replace service=. if hhbus==1 & (ba3ao2=="Arrange vans' queqe"| ba3ao2=="flowers arrangement shop" | ba3ao2=="glass panel set up" | ba3ao2=="ice shop" | ba3ao2=="lathe shop" | ba3ao2=="movie present car" | ba3ao2=="second-hand car tent" | ba3ao2=="to do decoration" | ba3ao2=="to do glass and aluminium set up" | ba3ao2=="to hammer iron" | ba3ao2=="to machine wood work" | ba3ao2=="to make strove")
replace manuf=. if hhbus==1 & (ba3ao2=="Arrange vans' queqe" | ba3ao2=="flowers arrangement shop" | ba3ao2=="glass panel set up" | ba3ao2=="ice shop" | ba3ao2=="lathe shop" | ba3ao2=="movie present car" | ba3ao2=="second-hand car tent" | ba3ao2=="to do decoration" | ba3ao2=="to do glass and aluminium set up" | ba3ao2=="to hammer iron" | ba3ao2=="to machine wood work" | ba3ao2=="to make strove")
replace retail=. if hhbus==1 & (ba3ao2=="Arrange vans' queqe" | ba3ao2=="flowers arrangement shop" | ba3ao2=="glass panel set up" | ba3ao2=="ice shop" | ba3ao2=="lathe shop" | ba3ao2=="movie present car" | ba3ao2=="second-hand car tent" | ba3ao2=="to do decoration" | ba3ao2=="to do glass and aluminium set up" | ba3ao2=="to hammer iron" | ba3ao2=="to machine wood work" | ba3ao2=="to make strove")


*Age of the firm in years
g agefirm=ba4 if hhbus==1 

*Number of paid employees
replace ba12=. if ba12==.c
g employees=ba12 if hhbus==1 

g totalworkers=ba9 if hhbus==1 

keep newid reasonforclosure wave-totalworkers

*TO DO: decide whether you need/want to change path for saving "TTHAI12u.dta"
/**/
save TTHAI12u, replace
/**/

*TO DO: change path to where you saved the following file "hh08_16in_tab1.dta" of the 2008 annual household resurvey (urban sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2008/Urban/hh08_16in_tab1.dta", clear
/**/

*Business sales in last month
keep if number=="N" | number=="O" | number=="P" | number=="Q" | number=="R" | number=="S" | number=="U" | number=="AA"
replace in4=0 if in2==3
bysort newid: egen sales=total(in4), m
*Since sales are given for past 12 months:
replace sales=sales/12

keep newid sales
duplicates drop

*TO DO: change path to where you saved the following file "TTHAI12u.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI12u, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving "TTHAI12u.dta"
/**/
save TTHAI12u, replace
/**/

*TO DO: change path to where you saved the following file "hh08_16in.dta" of the 2008 annual household resurvey (urban sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2008/Urban/hh08_16in.dta", clear
/**/

g expenses=in10b/12 

keep newid expenses

*TO DO: change path to where you saved the following file "TTHAI12u.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI12u, nogenerate
/**/

g profits=sales-expenses if hhbus==1

*TO DO: decide whether you need/want to change path for saving "TTHAI12u.dta"
/**/
save TTHAI12u, replace
/**/

*TO DO: change path to where you saved the following file "hh08_01cvr.dta" of the 2008 annual household resurvey (urban sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2008/Urban/hh08_01cvr.dta", clear
/**/

*Marital status of owner
*Since the marital status is only given for household heads, I can only compute it for head and their spouses
g help=1 if cvr7==1 | cvr7==3 
g married=(cvr11==3) if help==1 & cvr11!=-8
drop help

keep newid married

*TO DO: change path to where you saved the following file "TTHAI12u.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI12u, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving "TTHAI12u.dta"
/**/
save TTHAI12u, replace
/**/

*TO DO: change path to where you saved the following file "hh08_04hc_tab1.dta" of the 2008 annual household resurvey (urban sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2008/Urban/hh08_04hc_tab1.dta", clear
/**/

*Age of owner
g ownerage=hc5

*Gender of owner
g female=(hc4==3) if hc4!=.

*Education of owner
g ownertertiary=(hc7==47 | hc7==49 | hc7==51 | hc7==53) if hc7!=. & hc7!=-999 & hc7!=-888

*Years of education
*I assume the number is the years of education and calculate 6 years for primary and 6 years for secondary
*Sources: 	https://en.wikipedia.org/wiki/Education_in_Thailand
*			http://open_jicareport.jica.go.jp/pdf/11548013.pdf
g educyears=0 if hc7==1 | hc7==3 | hc7==5 | hc7==7 | hc7==9
replace educyears=1 if hc7==11
replace educyears=2 if hc7==13
replace educyears=3 if hc7==15
replace educyears=4 if hc7==17
replace educyears=5 if hc7==19
replace educyears=6 if hc7==21
replace educyears=7 if hc7==23
replace educyears=7 if hc7==25
replace educyears=8 if hc7==27
replace educyears=9 if hc7==29
replace educyears=10 if hc7==31 | hc7==41
replace educyears=11 if hc7==33 | hc7==43
replace educyears=12 if hc7==35 | hc7==45
replace educyears=13 if hc7==37 | hc7==47 | hc7==51 | hc7==55
replace educyears=14 if hc7==39 | hc7==49 | hc7==53 | hc7==57
replace educyears=15 if hc7==59
replace educyears=16 if hc7==61

*Child under 5 in household
g under5=0
replace under5=. if hc5==. 
replace under5=1 if hc5<5 
bysort newid: egen childunder5=max(under5)
drop under5

*Child aged 5 to 12 in household
g aged5to12=0
replace aged5to12=. if  hc5==. 
replace aged5to12=1 if  hc5>=5 &  hc5<12
bysort newid: egen childaged5to12=max(aged5to12)
drop aged5to12

*Has adult aged 65+ in the household
g is65orover=0
replace is65orover=. if hc5==. 
replace is65orover=1 if hc5>=65 & hc5!=. 
bysort newid: egen adult65andover=max(is65orover)
drop is65orover

*TO DO: change path to where you saved the following file "hh08_05oc_tab1.dta" of the 2008 annual household resurvey (urban sample)
/*EXAMPLE:*/
merge 1:1 newid number using "Townsend Thai Project/2008/Urban/hh08_05oc_tab1.dta", nogenerate
/**/

g businessowner=(oc1b==1) if oc1b!=. & oc1b!=.c 

/*I code individuals as wage workers if the type of employment reported is either:
 - employee - daily wages, or
 - employee - monthly wages, or
 - government worker.
 I do not consider individuals to be wage workers if the type of employment reported is either:
 - owner of business, or
 - unpaid family worker, or
 - employee - piece rate, in house, or
 - employee - piece rate, out of house, or
 - other.
*/

*Worked as wage worker in last month
g wageworker=(oc1b==5 | oc1b==7 | oc1b==13) if oc1b!=. & oc1b!=.c 

*Labor earnings in last month
*Replace missing values:
g laborincome=oc1c if oc1b==7 | oc1b==13
*For government workers it is not clear if the wages are given on a daily or monthly frequency, but I assume from the values that they are monthly
*In case wages are given for a daily frequency, I multiply them with 20 to have monthly wages:
replace laborincome=oc1c*20 if oc1b==5

*Retired
g retired=(oc1a==1) if  oc1a!=.

keep newid number ownerage-adult65andover businessowner wageworker laborincome retired

*TO DO: change path to where you saved the following file "TTHAI12u.dta"
/*EXAMPLE:*/
merge m:1 newid using TTHAI12u, nogenerate 
/**/

g hhbusowner=(businessowner==1) if hhbus==1 & businessowner!=.

drop businessowner

duplicates tag newid hhbusowner if hhbus==1 & hhbusowner==1, gen(totalowners)
replace totalowners=totalowners+1

g jointbus=(totalowners>1) if hhbus==1 & totalowners!=.

*TO DO: decide whether you need/want to change path for saving "TTHAI12u.dta"
/**/
save TTHAI12u, replace
/**/

*Household consumption

*TO DO: change path to where you saved the following file "hh08_04hc.dta" of the 2008 annual household resurvey (urban sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2008/Urban/hh08_04hc.dta", clear
/**/
keep newid hc1

*TO DO: change path to where you saved the following file "hh08_15ex.dta" of the 2008 annual household resurvey (urban sample)
/*EXAMPLE:*/
merge 1:1 newid using "Townsend Thai Project/2008/Urban/hh08_15ex.dta", nogenerate
/**/

*TO DO: change path to where you saved the following file "hh08_15ex_tab1.dta" of the 2008 annual household resurvey (urban sample)
/*EXAMPLE:*/
merge 1:m newid using "Townsend Thai Project/2008/Urban/hh08_15ex_tab1.dta", nogenerate
/**/

replace ex4=. if ex4==.b | ex4==.c | ex4==.y

bysort newid: egen monthlyexp=total(ex4),m

keep newid monthlyexp hc1 ex5-ex9
duplicates drop

replace monthlyexp=12*monthlyexp
egen hh_exp=rowtotal(monthlyexp ex5-ex9), missing

g pcexpend=hh_exp/hc1

drop monthlyexp hh_exp hc1 ex5-ex9

*TO DO: change path to where you saved the following file "TTHAI12u.dta"
/*EXAMPLE:*/
merge 1:m newid using TTHAI12u, nogenerate
/**/

*Exchange rate for approximate midpoint of survey period
/*There is no documentation for the 2008 survey round but I assume that for this round
 wthe data was also collected in May, so I use May 15 as approximate midpoint for the exchange rate*/

g excrate=0.03063

g excratemonth="5-2008"


foreach var of varlist ownerage ownertertiary educyears married childunder5 childaged5to12 adult65andover wageworker laborincome retired sales reasonforclosure wave surveyyear hhbusclosure typeofbusclosed hhbus enf_bus newfirmquex tbdropped nonfarm typeofbus retail manuf services othersector agefirm employees totalworkers expenses profits hhbusowner totalowners jointbus pcexpend excrate*{ 
rename `var' `var'_2008
} 

rename number hc_id

*TO DO: decide whether you need/want to change path for saving "TTHAI12u.dta"
/**/
save TTHAI12u, replace
/**/
********************************************************************************

*TO DO: change path to where you saved the following file "TTHAI12.dta"
/*EXAMPLE:*/
append using TTHAI12, gen(help)
/**/

generate urban=(help==0)
drop help

*TO DO: decide whether you need/want to change path for saving "TTHAI12.dta"
/**/
save TTHAI12, replace
/**/

********************************************************************************

*TO DO: decide whether you need/want to change path for saving "TTHAImaster.dta"
/**/
use TTHAImaster,clear
/**/

*TO DO: change path to where you saved the following file "TTHAI12.dta"
/*EXAMPLE:*/
merge 1:1 newid hc_id using TTHAI12, gen(_merge11) update
/**/

replace urban=0 if urban==.

*TO DO: decide whether you need/want to change path for saving "TTHAImaster.dta"
/**/
save TTHAImaster, replace
/**/

********************************************************************************
*Round 13 - Rural sample
********************************************************************************
*TO DO: change path to where you saved the following file "hh09_13ba.txt" of the 2009 annual household resurvey (rural sample)
/*EXAMPLE:*/
import delimited "Townsend Thai Project/2009/hh09_13ba.txt", encoding(ISO-8859-1) clear
/**/

*Survey round number
g wave=13

*Year survey took place
g surveyyear=2009

*Business closure in past 12 months
g hhbusclosure=(ba1a==1) if (ba1a==1 | ba1a==3) & ba1a!=.

/*Although the questionnaire asks for reasons, the business was closed (question ba1c),
this variable is not in the dataset and also not in the codebook file*/
g typeofbusclosed=ba1b

*I keep the open ended reasons for closure as for now to be able to decide later on appropriate coding
rename ba1c reasonforclosure

*Household operates a business
g hhbus=(ba1d==1) if ba1d!=.

*TO DO: decide whether you need/want to change path for saving "TTHAI13.dta"
/**/
save TTHAI13, replace 
/**/

*TO DO: change path to where you saved the following file "hh09_13ba_tab1.txt" of the 2009 annual household resurvey (rural sample)
/*EXAMPLE:*/
import delimited "Townsend Thai Project/2009/hh09_13ba_tab1.txt", encoding(ISO-8859-1) clear
/**/

/*Only keep the information for the first business as I will only consider businesses
 of households who have only one business:*/
keep if bnumber==1

*TO DO: change path to where you saved the following file "TTHAI13.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI13, nogenerate
/**/

*Household entirely owns household business
replace ba2=0 if hhbus==0

g enf_bus=(ba6==1) if ba6!=.

*Household entirely owns household business
*Business founded in last 12 months:
g newfirmquex=(ba21a==1) if ba21a!=.

/*I will only consider household enterprises if the household operates only one 
enterprise and if this enterprise is entirely owned by the household:*/
g tbdropped=(ba2>1) if ba2!=. | enf_bus!=1

*Since the questionnaire mixes non-farm and farm enterprises:
g nonfarm=(ba3a==1 | ba3a==3 | ba3a==5 | ba3a==15 | ba3a==17 | ba3a==19) if hhbus==1 & ba3a!=.

replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="10-wheels truck for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="6-wheels truck for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Car-care service"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Construction contractor"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Let houses for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Let stereoes for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Make dolls"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Petrol station"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Purchase rubber wood"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Sew cloth"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Taxi-motorcycle"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Trade antiques"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Truck for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Van for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Wooden handicraft products"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="basketwork, weaving"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buying and selling eucalyptus woods"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buying and selling junks"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buying rubber bits and pieces"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="canned bamboo shoots"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="car care shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="clothes repair"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="coined fuel filler machine"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="computer shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="craftwork from coconut shells"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="direct sale business"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="embroidery and design"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="engined tricycle for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="fuels station"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="kluai-thod and drinks shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="laundry"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making blooms for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making coconut juice for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making doors with curved steel"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making food for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making mosquito net and curved steel"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="molding Roman poles"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="music band"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="musical playing"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="ornament flowers garden"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="painting for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="selling blankets"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="selling cube ice"
replace nonfarm=. if hhbus==1 & ba3a==21 & ba3ao2=="selling khao-taen"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="selling oil"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sewing clothes for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="shoes repair shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="six-wheel truck"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="snooker table/s for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="soil loading truck"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="tents, stage, electronic appliances for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to do cloth making"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="transportation services for students"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="transportation services for workers"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="tricycle for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="tube fuels station"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="weaving mattress for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="wood handicraft"

replace hhbus=0 if nonfarm==0
replace hhbus=. if nonfarm==. & hhbus!=0

*Type of business
g typeofbus=ba3a if hhbus==1

*Sector of the firm:
*Firm is in retail trade
g retail=(ba3a==1 | ba3a==17) if hhbus==1
replace retail=1 if hhbus==1 & ba3a==21 & (ba3ao2=="Petrol station" | ba3ao2=="Trade antiques" | ba3ao2=="buying and selling eucalyptus woods" | ba3ao2=="direct sale business" | ba3ao2=="fuels station" | ba3ao2=="selling blankets" | ba3ao2=="selling cube ice" | ba3ao2=="selling oil" | ba3ao2=="tube fuels station")

*Firm is in manufacturing sector
g manuf=(ba3a==21 & (ba3ao2=="Make dolls" | ba3ao2=="Sew cloth"| ba3ao2=="basketwork, weaving" | ba3ao2=="canned bamboo shoots" | ba3ao2=="craftwork from coconut shells"  | ba3ao2=="embroidery and design" | ba3ao2=="making doors with curved steel" | ba3ao2=="making mosquito net and curved steel" | ba3ao2=="molding Roman poles" | ba3ao2=="sewing clothes for sale" | ba3ao2=="to do cloth making" | ba3ao2=="weaving mattress for sale" | ba3ao2=="wood handicraft")) if hhbus==1  
   
*Firm is in service sector
g services=(ba3a==3 | ba3a==5 | ba3a==15 | ba3a==19) if hhbus==1
replace services=1 if hhbus==1 & ba3a==21 & (ba3ao2=="10-wheels truck for hire" |  ba3ao2=="6-wheels truck for hire" | ba3ao2=="Car-care service" | ba3ao2=="Taxi-motorcycle" | ba3ao2=="Truck for hire" | ba3ao2=="Van for hire" | ba3ao2=="car care shop" | ba3ao2=="clothes repair" | ba3ao2=="engined tricycle for hire" | ba3ao2=="large four-wheel ploughing truck for hire" |  ba3ao2=="laundry"  | ba3ao2=="making food for sale" | ba3ao2=="music band" | ba3ao2=="musical playing"|  ba3ao2=="shoes repair shop" | ba3ao2=="six-wheel truck" | ba3ao2=="snooker table/s for rent" | ba3ao2=="soil loading truck" | ba3ao2=="tents, stage, electronic appliances for rent" | ba3ao2=="transportation services for students" | ba3ao2=="transportation services for workers" | ba3ao2=="tricycle for hire")

*Firm is in other sector
g othersector=(retail==0 & manuf==0 & services==0) if hhbus==1 

replace othersector=. if hhbus==1 & (ba3ao2=="Purchase rubber wood" | ba3ao2=="Wooden handicraft products" | ba3ao2=="buying and selling junks" | ba3ao2=="buying rubber bits and pieces" | ba3ao2=="coined fuel filler machine" | ba3ao2=="computer shop" | ba3ao2=="kluai-thod and drinks shop" | ba3ao2=="making blooms for sale"  | ba3ao2=="making coconut juice for sale"  | ba3ao2=="ornament flowers garden")
replace services=. if hhbus==1 & (ba3ao2=="Purchase rubber wood" | ba3ao2=="Wooden handicraft products" | ba3ao2=="buying and selling junks" | ba3ao2=="buying rubber bits and pieces" | ba3ao2=="coined fuel filler machine" | ba3ao2=="computer shop" | ba3ao2=="kluai-thod and drinks shop" | ba3ao2=="making blooms for sale"  | ba3ao2=="making coconut juice for sale"  | ba3ao2=="ornament flowers garden")
replace manuf=. if hhbus==1 & (ba3ao2=="Purchase rubber wood" | ba3ao2=="Wooden handicraft products" | ba3ao2=="buying and selling junks" | ba3ao2=="buying rubber bits and pieces" | ba3ao2=="coined fuel filler machine" | ba3ao2=="computer shop" | ba3ao2=="kluai-thod and drinks shop" | ba3ao2=="making blooms for sale"  | ba3ao2=="making coconut juice for sale"  | ba3ao2=="ornament flowers garden")
replace retail=. if hhbus==1 & (ba3ao2=="Purchase rubber wood" | ba3ao2=="Wooden handicraft products" | ba3ao2=="buying and selling junks" | ba3ao2=="buying rubber bits and pieces" | ba3ao2=="coined fuel filler machine" | ba3ao2=="computer shop" | ba3ao2=="kluai-thod and drinks shop" | ba3ao2=="making blooms for sale"  | ba3ao2=="making coconut juice for sale"  | ba3ao2=="ornament flowers garden")

*Age of the firm in years
g agefirm=ba4 if hhbus==1 

*Number of paid employees
g employees=ba12 if hhbus==1 

g totalworkers=ba9 if hhbus==1 

keep newid reasonforclosure wave-totalworkers

*TO DO: decide whether you need/want to change path for saving "TTHAI13.dta"
/**/
save TTHAI13, replace
/**/

*TO DO: change path to where you saved the following file "hh09_16in_tab1.txt" of the 2009 annual household resurvey (rural sample)
/*EXAMPLE:*/
import delimited "Townsend Thai Project/2009/hh09_16in_tab1.txt", encoding(ISO-8859-1) clear
/**/

*Business sales in last month
keep if number=="N" | number=="O" | number=="P" | number=="Q" | number=="R" | number=="S" | number=="U" | number=="AA"
replace in4=0 if in2==3
bysort newid: egen sales=total(in4), m
*Since sales are given for past 12 months:
replace sales=sales/12

keep newid sales
duplicates drop

*TO DO: change path to where you saved the following file "TTHAI13.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI13, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving "TTHAI13.dta"
/**/
save TTHAI13, replace
/**/

*TO DO: change path to where you saved the following file "hh09_16in.txt" of the 2009 annual household resurvey (rural sample)
/*EXAMPLE:*/
import delimited "Townsend Thai Project/2009/hh09_16in.txt", encoding(ISO-8859-1) clear
/**/

g expenses=in10b/12 

keep newid expenses

*TO DO: change path to where you saved the following file "TTHAI13.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI13, nogenerate
/**/

g profits=sales-expenses if hhbus==1

*TO DO: decide whether you need/want to change path for saving "TTHAI13.dta"
/**/
save TTHAI13, replace
/**/

*TO DO: change path to where you saved the following file "h09_01cvr.txt" of the 2009 annual household resurvey (rural sample)
/*EXAMPLE:*/
import delimited "Townsend Thai Project/2009/hh09_01cvr.txt", encoding(ISO-8859-1) clear
/**/

*Marital status of owner
*Since the marital status is only given for household heads, I can only compute it for head and their spouses
g help=1 if cvr7==1 | cvr7==3 
g married=(cvr11==3) if help==1 & cvr11!=-8
drop help

keep newid married

*TO DO: change path to where you saved the following file "TTHAI13.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI13, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving "TTHAI13.dta"
/**/
save TTHAI13, replace
/**/

*TO DO: change path to where you saved the following file "hh09_05oc_tab1.txt" of the 2009 annual household resurvey (rural sample)
/*EXAMPLE:*/
import delimited "Townsend Thai Project/2009/hh09_05oc_tab1.txt", encoding(ISO-8859-1) clear
/**/
*TO DO: decide whether you need/want to change path for saving "Thh09_05oc_tab1.dta"
/**/
save "Townsend Thai Project/2009/hh09_05oc_tab1.dta", replace
/**/
*TO DO: change path to where you saved the following file "hh09_04hc_tab1.txt" of the 2009 annual household resurvey (rural sample)
/*EXAMPLE:*/
import delimited "Townsend Thai Project/2009/hh09_04hc_tab1.txt", encoding(ISO-8859-1) clear
/**/

*Age of owner
g ownerage=hc5

*Gender of owner
g female=(hc4==3) if hc4!=.

*Education of owner
g ownertertiary=(hc7==47 | hc7==49 | hc7==51 | hc7==53) if hc7!=. & hc7!=-999 & hc7!=-888

*Years of education
*I assume the number is the years of education and calculate 6 years for primary and 6 years for secondary
*Sources: 	https://en.wikipedia.org/wiki/Education_in_Thailand
*			http://open_jicareport.jica.go.jp/pdf/11548013.pdf
g educyears=0 if hc7==1 | hc7==3 | hc7==5 | hc7==7 | hc7==9
replace educyears=1 if hc7==11
replace educyears=2 if hc7==13
replace educyears=3 if hc7==15
replace educyears=4 if hc7==17
replace educyears=5 if hc7==19
replace educyears=6 if hc7==21
replace educyears=7 if hc7==23
replace educyears=7 if hc7==25
replace educyears=8 if hc7==27
replace educyears=9 if hc7==29
replace educyears=10 if hc7==31 | hc7==41
replace educyears=11 if hc7==33 | hc7==43
replace educyears=12 if hc7==35 | hc7==45
replace educyears=13 if hc7==37 | hc7==47 | hc7==51 | hc7==55
replace educyears=14 if hc7==39 | hc7==49 | hc7==53 | hc7==57
replace educyears=15 if hc7==59
replace educyears=16 if hc7==61

*Child under 5 in household
g under5=0
replace under5=. if hc5==. 
replace under5=1 if hc5<5 
bysort newid: egen childunder5=max(under5)
drop under5

*Child aged 5 to 12 in household
g aged5to12=0
replace aged5to12=. if  hc5==. 
replace aged5to12=1 if  hc5>=5 &  hc5<12
bysort newid: egen childaged5to12=max(aged5to12)
drop aged5to12

*Has adult aged 65+ in the household
g is65orover=0
replace is65orover=. if hc5==. 
replace is65orover=1 if hc5>=65 & hc5!=. 
bysort newid: egen adult65andover=max(is65orover)
drop is65orover

*TO DO: change path to where you saved the following file "hh09_05oc_tab1.dta" of the 2009 annual household resurvey (rural sample)
/*EXAMPLE:*/
merge 1:1 newid number using "Townsend Thai Project/2009/hh09_05oc_tab1.dta", nogenerate
/**/

g businessowner=(oc1b==1) if oc1b!=. 

/*I code individuals as wage workers if the type of employment reported is either:
 - employee - daily wages, or
 - employee - monthly wages, or
 - government worker.
 I do not consider individuals to be wage workers if the type of employment reported is either:
 - owner of business, or
 - unpaid family worker, or
 - employee - piece rate, in house, or
 - employee - piece rate, out of house, or
 - other.
*/

*Worked as wage worker in last month
g wageworker=(oc1b==5 | oc1b==7 | oc1b==13) if oc1b!=.

*Labor earnings in last month
*Replace missing values:
g laborincome=oc1c if oc1b==7 | oc1b==13
*For government workers it is not clear if the wages are given on a daily or monthly frequency, but I assume from the values that they are monthly
*In case wages are given for a daily frequency, I multiply them with 20 to have monthly wages:
replace laborincome=oc1c*20 if oc1b==5

*Retired
g retired=(oc1a==1) if  oc1a!=.

keep newid number ownerage-adult65andover businessowner wageworker laborincome retired

*TO DO: change path to where you saved the following file "TTHAI13.dta"
/*EXAMPLE:*/
merge m:1 newid using TTHAI13, nogenerate 
/**/

g hhbusowner=(businessowner==1) if hhbus==1 & businessowner!=.

drop businessowner

duplicates tag newid hhbusowner if hhbus==1 & hhbusowner==1, gen(totalowners)
replace totalowners=totalowners+1

g jointbus=(totalowners>1) if hhbus==1 & totalowners!=.

*TO DO: decide whether you need/want to change path for saving "TTHAI13.dta"
/**/
save TTHAI13, replace
/**/

*Household consumption
*TO DO: change path to where you saved the following file "hh09_15ex.txt" of the 2009 annual household resurvey (rural sample)
/*EXAMPLE:*/
import delimited "Townsend Thai Project/2009/hh09_15ex.txt", encoding(ISO-8859-1) clear
/**/
*TO DO: decide whether you need/want to change path for saving "hh09_15ex.dta"
/**/
save "Townsend Thai Project/2009/hh09_15ex.dta", replace
/**/

*TO DO: change path to where you saved the following file "hh09_15ex_tab1.txt" of the 2009 annual household resurvey (rural sample)
/*EXAMPLE:*/
import delimited "Townsend Thai Project/2009/hh09_15ex_tab1.txt", encoding(ISO-8859-1) clear
/**/
*TO DO: decide whether you need/want to change path for saving "hh09_15ex_tab1.dta"
/**/
save "Townsend Thai Project/2009/hh09_15ex_tab1.dta", replace
/**/

*TO DO: change path to where you saved the following file "hh09_04hc.txt" of the 2009 annual household resurvey (rural sample)
/*EXAMPLE:*/
import delimited "Townsend Thai Project/2009/hh09_04hc.txt", encoding(ISO-8859-1) clear
/**/
keep newid hc1

*TO DO: change path to where you saved the following file "hh09_15ex.dta" of the 2009 annual household resurvey (rural sample)
/*EXAMPLE:*/
merge 1:1 newid using "Townsend Thai Project/2009/hh09_15ex.dta", nogenerate
/**/

*TO DO: change path to where you saved the following file "hh09_15ex_tab1.dta" of the 2009 annual household resurvey (rural sample)
/*EXAMPLE:*/
merge 1:m newid using "Townsend Thai Project/2009/hh09_15ex_tab1.dta", nogenerate
/**/

replace ex4=. if ex4==.b | ex4==.c | ex4==.y

bysort newid: egen monthlyexp=total(ex4),m

keep newid monthlyexp hc1 ex5-ex9
duplicates drop

replace monthlyexp=12*monthlyexp
egen hh_exp=rowtotal(monthlyexp ex5-ex9), missing

g pcexpend=hh_exp/hc1

drop monthlyexp hh_exp hc1 ex5-ex9

*TO DO: change path to where you saved the following file "TTHAI13.dta"
/*EXAMPLE:*/
merge 1:m newid using TTHAI13, nogenerate
/**/

*Exchange rate for approximate midpoint of survey period
/*There is no documentation for the 2009 survey round but I assume that for this round
 wthe data was also collected in May, so I use May 15 as approximate midpoint for the exchange rate*/

g excrate=0.02885

g excratemonth="5-2009"


foreach var of varlist ownerage ownertertiary educyears married childunder5 childaged5to12 adult65andover wageworker laborincome retired sales reasonforclosure wave surveyyear hhbusclosure typeofbusclosed hhbus enf_bus newfirmquex tbdropped nonfarm typeofbus retail manuf services othersector agefirm employees totalworkers expenses profits hhbusowner totalowners jointbus pcexpend excrate*{ 
rename `var' `var'_2009
} 

rename number hc_id

tostring newid, replace format(%12.0f)
replace newid="0"+newid if strlen(newid)==11

*TO DO: decide whether you need/want to change path for saving "TTHAI13.dta"
/**/
save TTHAI13, replace
/**/

********************************************************************************
*Round 13 - Urban sample
********************************************************************************
*TO DO: change path to where you saved the following file "hh09_13ba.dta" of the 2009 annual household resurvey (urban sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2009/Urban/hh09_13ba.dta", clear
/**/

*Survey round number
g wave=13

*Year survey took place
g surveyyear=2009

*Business closure in past 12 months
g hhbusclosure=(ba1a==1) if (ba1a==1 | ba1a==3) & ba1a!=.c

/*Although the questionnaire asks for reasons, the business was closed (question ba1c),
this variable is not in the dataset and also not in the codebook file*/
replace ba1b=. if ba1b==.c
g typeofbusclosed=ba1b

*I keep the open ended reasons for closure as for now to be able to decide later on appropriate coding
rename ba1c reasonforclosure

*Household operates a business
g hhbus=(ba1d==1) if ba1d!=.c

*TO DO: decide whether you need/want to change path for saving "TTHAI13u.dta"
/**/
save TTHAI13u, replace 
/**/

*TO DO: change path to where you saved the following file "hh09_13ba_tab1.dta" of the 2009 annual household resurvey (urban sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2009/Urban/hh09_13ba_tab1.dta", clear
/**/

/*Only keep the information for the first business as I will only consider businesses
 of households who have only one business:*/
keep if bnumber==1

*TO DO: change path to where you saved the following file "TTHAI13u.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI13u, nogenerate
/**/

*Household entirely owns household business
replace ba2=0 if hhbus==0

g enf_bus=(ba6==1) if ba6!=.

*Household entirely owns household business
*Business founded in last 12 months:
g newfirmquex=(ba21a==1) if ba21a!=.

/*I will only consider household enterprises if the household operates only one 
enterprise and if this enterprise is entirely owned by the household:*/
g tbdropped=(ba2>1) if ba2!=. | enf_bus!=1

*Since the questionnaire mixes non-farm and farm enterprises:
g nonfarm=(ba3a==1 | ba3a==3 | ba3a==5 | ba3a==15 | ba3a==17 | ba3a==19) if hhbus==1 & ba3a!=.c

replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="10-wheels truck for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="6-wheels truck for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Clothes making shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Construction contractor"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Give tution"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Install curtains"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Install gutters"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Khanom Peer (a kind of sweets) shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Land filling contractor"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Laundry service"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Laundry service shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Let houses for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Let rooms for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Make banners and boards"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Make clothes"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Northeastern style singer"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Photocopier shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Printing shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Produce bricks/blocks"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Produce drinking water for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Produce furnitures"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Produce grill doors"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Produce grills"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Repair electric appliances"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="School van"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Sell foods"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Sew cloth"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Taxi-motorcycle"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Tea shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Thai traditional massage"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Tricycle for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Van for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Vehicle care taking service"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="air conditioner selling and repair shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="aluminum works"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="bicycle spare parts shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="blackhole car"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="building houses for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="bus"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buying and selling junks"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buying and selling rice"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buying and selling small buddha images"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="cages for fighting cocks"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="car accessory shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="car audio set up"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="car care shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="car pad making shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="car painting"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="cinematograph"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="clothes repair"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="computer repairing"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="curtain making"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="curved steel maker"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="delivering vegetables in the market"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="dormitory/student hostel"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="dress maker"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="dress making shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="dried flowers shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="drug store"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="farm equipment shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="fixing glasses and aluminum"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="fuels and drinks shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="furnitures"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="gas and mechanical equipments shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="gas and shoes shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="gas shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="hired taxi"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="hired van"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="ice producing shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="ice shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="install and repair air conditioners"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="iron smith"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="iron welder"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="iron welding"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="karaoke shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="laundry"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making bakery for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making bird cages for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making bread for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making cages for chicken and birds for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making food for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making processed tamarind for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making ready meals for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making stove for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="mo-hom clothes shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="molding Roman poles"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="motorcycle repair and spare parts shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="motorcycle repair shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="motorcycle with trailer for deliver things"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="optical shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="ornament flowers shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="phone repairing"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="photocopying and typing shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="recording commercial spots"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell baked clay pottery"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell coffin"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell sweets"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="selling  gifts and souvenirs"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="selling and repair watches"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="selling antiques"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="selling auto parts"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="selling curry seasoning and fresh coconut milk"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="selling electronic appliances"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="selling foods"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="selling fried meatballs"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="selling groceries"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="selling kha-nom and drinks"
replace nonfarm=. if hhbus==1 & ba3a==21 & ba3ao2=="selling kha-nom-jeen"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="selling khao-nio-nung (steamed sticky rice)"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="selling minced chilli, minced roasted peanuts, minced roasted rice"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="selling shoes"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="selling used cars"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sewing clothes"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sewing mo-hom clothes"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sewing shoulder bags"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="showing movies in open air theatre"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="snooker table"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="students transportation services van"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="take-home curries for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="take-home foods for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="tea shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="ten-wheel truck"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to do iron making for robber prevention"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to do laundry"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to make frame of buddha image"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to repair cloth"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to suck water in toilet"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="traditional massage"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="tricycle"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="truck"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="welding shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="wood lathing"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="writing signboards"

replace hhbus=0 if nonfarm==0
replace hhbus=. if nonfarm==. & hhbus!=0

*Type of business
g typeofbus=ba3a if hhbus==1

*Sector of the firm:
*Firm is in retail trade
g retail=(ba3a==1 | ba3a==17) if hhbus==1
replace retail=1 if hhbus==1 & ba3a==21 & (ba3ao2=="buying and selling rice" | ba3ao2=="buying and selling small buddha images" | ba3ao2=="car accessory shop" | ba3ao2=="farm equipment shop" | ba3ao2=="gas and mechanical equipments shop" | ba3ao2=="gas and shoes shop" | ba3ao2=="gas shop" | ba3ao2=="mo-hom clothes shop" | ba3ao2=="optical shop" | ba3ao2=="sell baked clay pottery" | ba3ao2=="sell coffin" | ba3ao2=="selling  gifts and souvenirs" | ba3ao2=="selling antiques" | ba3ao2=="selling auto parts"  | ba3ao2=="selling groceries" | ba3ao2=="selling electronic appliances" | ba3ao2=="selling groceries" | ba3ao2=="selling shoes" | ba3ao2=="selling used cars")

*Firm is in manufacturing sector
g manuf=(ba3a==21 & (ba3ao2=="Clothes making shop" | ba3ao2=="Make banners and boards" | ba3ao2=="Make clothes" | ba3ao2=="Produce bricks/blocks" | ba3ao2=="Produce furnitures" | ba3ao2=="Produce grill doors" | ba3ao2=="Produce grills" | ba3ao2=="Sew cloth" | ba3ao2=="aluminum works" | ba3ao2=="curtain making" | ba3ao2=="curved steel maker" | ba3ao2=="dress maker" | ba3ao2=="dress making shop" | ba3ao2=="iron smith" | ba3ao2=="iron welder" | ba3ao2=="iron welding" | ba3ao2=="making bird cages for sale" | ba3ao2=="making cages for chicken and birds for sale" | ba3ao2=="molding Roman poles" | ba3ao2=="sewing clothes" | ba3ao2=="sewing mo-hom clothes" | ba3ao2=="sewing shoulder bags" | ba3ao2=="to do iron making for robber prevention" | ba3ao2=="to make frame of buddha image" | ba3ao2=="welding shop")) if hhbus==1  

*Firm is in service sector
g services=(ba3a==3 | ba3a==5 | ba3a==15 | ba3a==19) if hhbus==1
replace services=1 if hhbus==1 & ba3a==21 & (ba3ao2=="10-wheels truck for hire" | ba3ao2=="6-wheels truck for hire" | ba3ao2=="Give tution" | ba3ao2=="Install curtains" | ba3ao2=="Khanom Peer (a kind of sweets) shop" | ba3ao2=="Laundry service" | ba3ao2=="Laundry service shop" | ba3ao2=="Let houses for rent" | ba3ao2=="Let rooms for rent" | ba3ao2=="Northeastern style singer" | ba3ao2=="Photocopier shop" | ba3ao2=="Printing shop" | ba3ao2=="Repair electric appliances" | ba3ao2=="School van" | ba3ao2=="Sell foods" | ba3ao2=="Taxi-motorcycle" | ba3ao2=="Tea shop" | ba3ao2=="Thai traditional massage" | ba3ao2=="Tricycle for hire" | ba3ao2=="Van for hire" | ba3ao2=="Vehicle care taking service" | ba3ao2=="bus" | ba3ao2=="car care shop" | ba3ao2=="cinematograph" | ba3ao2=="clothes repair" | ba3ao2=="computer repairing" | ba3ao2=="delivering vegetables in the market" | ba3ao2=="dormitory/student hostel" | ba3ao2=="hired taxi" | ba3ao2=="hired van" | ba3ao2=="install and repair air conditioners" | ba3ao2=="karaoke shop" | ba3ao2=="laundry" | ba3ao2=="making bakery for sale" | ba3ao2=="making bread for sale" | ba3ao2=="making food for sale" | ba3ao2=="making processed tamarind for sale" | ba3ao2=="making ready meals for sale" | ba3ao2=="motorcycle with trailer for deliver things" | ba3ao2=="phone repairing" | ba3ao2=="photocopying and typing shop" | ba3ao2=="recording commercial spots" | ba3ao2=="sell sweets" | ba3ao2=="selling foods" | ba3ao2=="selling fried meatballs" | ba3ao2=="selling khao-nio-nung (steamed sticky rice)" | ba3ao2=="selling minced chilli, minced roasted peanuts, minced roasted rice" | ba3ao2=="showing movies in open air theatre" | ba3ao2=="snooker table" | ba3ao2=="students transportation services van" | ba3ao2=="take-home curries for sale" | ba3ao2=="take-home foods for sale" | ba3ao2=="tea shop" | ba3ao2=="ten-wheel truck" | ba3ao2=="to do laundry" | ba3ao2=="to repair cloth" | ba3ao2=="traditional massage" | ba3ao2=="tricycle" | ba3ao2=="truck")

*Firm is in other sector
g othersector=(retail==0 & manuf==0 & services==0) if hhbus==1 

replace othersector=. if hhbus==1 & (ba3ao2=="air conditioner selling and repair shop" | ba3ao2=="blackhole car" | ba3ao2=="buying and selling junks" | ba3ao2=="cages for fighting cocks" | ba3ao2=="car pad making shop" | ba3ao2=="dried flowers shop" | ba3ao2=="fixing glasses and aluminum" | ba3ao2=="fuels and drinks shop" | ba3ao2=="furnitures" | ba3ao2=="ice shop" | ba3ao2=="optical shop" | ba3ao2=="ornament flowers shop" | ba3ao2=="selling curry seasoning and fresh coconut milk" | ba3ao2=="selling kha-nom and drinks"| ba3ao2=="wood lathing" | ba3ao2=="writing signboards")
replace services=. if hhbus==1 & (ba3ao2=="air conditioner selling and repair shop" | ba3ao2=="blackhole car" | ba3ao2=="buying and selling junks" | ba3ao2=="cages for fighting cocks" | ba3ao2=="car pad making shop" | ba3ao2=="dried flowers shop" | ba3ao2=="fixing glasses and aluminum" | ba3ao2=="fuels and drinks shop" | ba3ao2=="furnitures" | ba3ao2=="ice shop" | ba3ao2=="optical shop" | ba3ao2=="ornament flowers shop" | ba3ao2=="selling curry seasoning and fresh coconut milk" | ba3ao2=="selling kha-nom and drinks" | ba3ao2=="wood lathing" | ba3ao2=="writing signboards")
replace manuf=. if hhbus==1 & (ba3ao2=="air conditioner selling and repair shop" | ba3ao2=="blackhole car" | ba3ao2=="buying and selling junks" | ba3ao2=="cages for fighting cocks" | ba3ao2=="car pad making shop" | ba3ao2=="dried flowers shop" | ba3ao2=="fixing glasses and aluminum" | ba3ao2=="fuels and drinks shop" | ba3ao2=="furnitures" | ba3ao2=="ice shop" | ba3ao2=="optical shop" | ba3ao2=="ornament flowers shop" | ba3ao2=="selling curry seasoning and fresh coconut milk" | ba3ao2=="selling kha-nom and drinks" | ba3ao2=="wood lathing" | ba3ao2=="writing signboards")
replace retail=. if hhbus==1 & (ba3ao2=="air conditioner selling and repair shop" | ba3ao2=="blackhole car" | ba3ao2=="buying and selling junks" | ba3ao2=="cages for fighting cocks" | ba3ao2=="car pad making shop" | ba3ao2=="dried flowers shop" | ba3ao2=="fixing glasses and aluminum" | ba3ao2=="fuels and drinks shop" | ba3ao2=="furnitures" | ba3ao2=="ice shop" | ba3ao2=="optical shop" | ba3ao2=="ornament flowers shop" | ba3ao2=="selling curry seasoning and fresh coconut milk" | ba3ao2=="selling kha-nom and drinks" | ba3ao2=="wood lathing" | ba3ao2=="writing signboards")


*Age of the firm in years
g agefirm=ba4 if hhbus==1 

*Number of paid employees
replace ba12=. if ba12==.c
g employees=ba12 if hhbus==1 

g totalworkers=ba9 if hhbus==1 

keep newid reasonforclosure wave-totalworkers

*TO DO: decide whether you need/want to change path for saving "TTHAI13u.dta"
/**/
save TTHAI13u, replace
/**/ 
 
*TO DO: change path to where you saved the following file "hh09_16in_tab1.dta" of the 2009 annual household resurvey (urban sample)
/*EXAMPLE: */
use "Townsend Thai Project/2009/Urban/hh09_16in_tab1.dta", clear
/**/

*Business sales in last month
keep if number=="N" | number=="O" | number=="P" | number=="Q" | number=="R" | number=="S" | number=="U" | number=="AA"
replace in4=0 if in2==3
bysort newid: egen sales=total(in4), m
*Since sales are given for past 12 months:
replace sales=sales/12

keep newid sales
duplicates drop

*TO DO: change path to where you saved the following file "TTHAI13u.dta" 
/*EXAMPLE:*/
merge 1:1 newid using TTHAI13u, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving "TTHAI13u.dta"
/**/
save TTHAI13u, replace
/**/

*TO DO: change path to where you saved the following file "hh09_16in.dta" of the 2009 annual household resurvey (urban sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2009/Urban/hh09_16in.dta", clear
/**/

g expenses=in10b/12 

keep newid expenses

*TO DO: change path to where you saved the following file "TTHAI13u.dta" 
/*EXAMPLE:*/
merge 1:1 newid using TTHAI13u, nogenerate
/**/

g profits=sales-expenses if hhbus==1

*TO DO: decide whether you need/want to change path for saving "TTHAI13u.dta"
/**/
save TTHAI13u, replace
/**/

*TO DO: change path to where you saved the following file "hh09_01cvr.dta" of the 2009 annual household resurvey (urban sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2009/Urban/hh09_01cvr.dta", clear
/**/

*Marital status of owner
*Since the marital status is only given for household heads, I can only compute it for head and their spouses
g help=1 if cvr7==1 | cvr7==3 
g married=(cvr11==3) if help==1 & cvr11!=-8
drop help

keep newid married

*TO DO: change path to where you saved the following file "TTHAI13u.dta" 
/*EXAMPLE:*/
merge 1:1 newid using TTHAI13u, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving "TTHAI13u.dta"
/**/
save TTHAI13u, replace
/**/

*TO DO: change path to where you saved the following file "hh09_04hc_tab1.dta" of the 2009 annual household resurvey (urban sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2009/Urban/hh09_04hc_tab1.dta", clear
/**/

*Age of owner
g ownerage=hc5

*Gender of owner
g female=(hc4==3) if hc4!=.

*Education of owner
g ownertertiary=(hc7==47 | hc7==49 | hc7==51 | hc7==53) if hc7!=. & hc7!=-999 & hc7!=-888

*Years of education
*I assume the number is the years of education and calculate 6 years for primary and 6 years for secondary
*Sources: 	https://en.wikipedia.org/wiki/Education_in_Thailand
*			http://open_jicareport.jica.go.jp/pdf/11548013.pdf
g educyears=0 if hc7==1 | hc7==3 | hc7==5 | hc7==7 | hc7==9
replace educyears=1 if hc7==11
replace educyears=2 if hc7==13
replace educyears=3 if hc7==15
replace educyears=4 if hc7==17
replace educyears=5 if hc7==19
replace educyears=6 if hc7==21
replace educyears=7 if hc7==23
replace educyears=7 if hc7==25
replace educyears=8 if hc7==27
replace educyears=9 if hc7==29
replace educyears=10 if hc7==31 | hc7==41
replace educyears=11 if hc7==33 | hc7==43
replace educyears=12 if hc7==35 | hc7==45
replace educyears=13 if hc7==37 | hc7==47 | hc7==51 | hc7==55
replace educyears=14 if hc7==39 | hc7==49 | hc7==53 | hc7==57
replace educyears=15 if hc7==59
replace educyears=16 if hc7==61

*Child under 5 in household
g under5=0
replace under5=. if hc5==. 
replace under5=1 if hc5<5 
bysort newid: egen childunder5=max(under5)
drop under5

*Child aged 5 to 12 in household
g aged5to12=0
replace aged5to12=. if  hc5==. 
replace aged5to12=1 if  hc5>=5 &  hc5<12
bysort newid: egen childaged5to12=max(aged5to12)
drop aged5to12

*Has adult aged 65+ in the household
g is65orover=0
replace is65orover=. if hc5==. 
replace is65orover=1 if hc5>=65 & hc5!=. 
bysort newid: egen adult65andover=max(is65orover)
drop is65orover

*TO DO: change path to where you saved the following file "hh09_05oc_tab1.dta" of the 2009 annual household resurvey (urban sample)
/*EXAMPLE:*/
merge 1:1 newid number using "Townsend Thai Project/2009/Urban/hh09_05oc_tab1.dta", nogenerate
/**/

g businessowner=(oc1b==1) if oc1b!=. & oc1b!=.c 

/*I code individuals as wage workers if the type of employment reported is either:
 - employee - daily wages, or
 - employee - monthly wages, or
 - government worker.
 I do not consider individuals to be wage workers if the type of employment reported is either:
 - owner of business, or
 - unpaid family worker, or
 - employee - piece rate, in house, or
 - employee - piece rate, out of house, or
 - other.
*/

*Worked as wage worker in last month
g wageworker=(oc1b==5 | oc1b==7 | oc1b==13) if oc1b!=. & oc1b!=.c 

*Labor earnings in last month
*Replace missing values:
g laborincome=oc1c if oc1b==7 | oc1b==13
*For government workers it is not clear if the wages are given on a daily or monthly frequency, but I assume from the values that they are monthly
*In case wages are given for a daily frequency, I multiply them with 20 to have monthly wages:
replace laborincome=oc1c*20 if oc1b==5

*Retired
g retired=(oc1a==1) if  oc1a!=.

keep newid number ownerage-adult65andover businessowner wageworker laborincome retired

*TO DO: change path to where you saved the following file "TTHAI13u.dta"
/*EXAMPLE:*/
merge m:1 newid using TTHAI13u, nogenerate 
/**/

g hhbusowner=(businessowner==1) if hhbus==1 & businessowner!=.

drop businessowner

duplicates tag newid hhbusowner if hhbus==1 & hhbusowner==1, gen(totalowners)
replace totalowners=totalowners+1

g jointbus=(totalowners>1) if hhbus==1 & totalowners!=.

*TO DO: decide whether you need/want to change path for saving "TTHAI13u.dta"
/**/
save TTHAI13u, replace
/**/

*Household consumption
*TO DO: change path to where you saved the following file "hh09_04hc.dta" of the 2009 annual household resurvey (urban sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2009/Urban/hh09_04hc.dta", clear
/**/
keep newid hc1

*TO DO: change path to where you saved the following file "hh09_15ex.dta" of the 2009 annual household resurvey (urban sample)
/*EXAMPLE:*/
merge 1:1 newid using "Townsend Thai Project/2009/Urban/hh09_15ex.dta", nogenerate
/**/
*TO DO: change path to where you saved the following file "hh09_15ex_tab1.dta" of the 2009 annual household resurvey (urban sample)
/*EXAMPLE:*/
merge 1:m newid using "Townsend Thai Project/2009/Urban/hh09_15ex_tab1.dta", nogenerate
/**/
replace ex4=. if ex4==.b | ex4==.c | ex4==.y

bysort newid: egen monthlyexp=total(ex4),m

keep newid monthlyexp hc1 ex5-ex9
duplicates drop

replace monthlyexp=12*monthlyexp
egen hh_exp=rowtotal(monthlyexp ex5-ex9), missing

g pcexpend=hh_exp/hc1

drop monthlyexp hh_exp hc1 ex5-ex9

*TO DO: change path to where you saved the following file "TTHAI13u.dta" 
/*EXAMPLE:*/
merge 1:m newid using TTHAI13u, nogenerate
/**/

*Exchange rate for approximate midpoint of survey period
/*There is no documentation for the 2009 survey round but I assume that for this round
 the data was also collected in May, so I use May 15 as approximate midpoint for the exchange rate*/

g excrate=0.02885

g excratemonth="5-2009"


foreach var of varlist wageworker ownerage ownertertiary educyears married childunder5 childaged5to12 adult65andover laborincome retired sales reasonforclosure wave surveyyear hhbusclosure typeofbusclosed hhbus enf_bus newfirmquex tbdropped nonfarm typeofbus retail manuf services othersector agefirm employees totalworkers expenses profits hhbusowner totalowners jointbus pcexpend excrate*{ 
rename `var' `var'_2009
} 

rename number hc_id

*TO DO: decide whether you need/want to change path for saving "TTHAI13u.dta"
/**/
save TTHAI13u, replace
/**/
********************************************************************************
*TO DO: change path to where you saved the following file "TTHAI13.dta" 
/*EXAMPLE:*/
append using TTHAI13, gen(help)
/**/

*TO DO: decide whether you need/want to change path for saving "TTHAI13.dta"
/**/
save TTHAI13, replace
/**/
********************************************************************************
*TO DO: change path to where you saved the following file "TTHAImaster.dta" 
/*EXAMPLE:*/
use TTHAImaster,clear
/**/

*TO DO: change path to where you saved the following file "TTHAI13.dta" 
/*EXAMPLE:*/
merge 1:1 newid hc_id using TTHAI13, gen(_merge12) update
/**/

replace urban=1 if help==0 & urban==.
replace urban=0 if help==1 & urban==.
drop help

*TO DO: decide whether you need/want to change path for saving "TTHAImaster.dta"
/**/
save TTHAImaster, replace
/**/

********************************************************************************
*Round 14 - Rural sample
********************************************************************************
*TO DO: change path to where you saved the following file "hh10_13ba.txt" of the 2010 annual household resurvey (rural sample)
/*EXAMPLE:*/
import delimited "Townsend Thai Project/2010/hh10_13ba.txt", encoding(ISO-8859-1) clear
/**/

*Survey round number
g wave=14

*Year survey took place
g surveyyear=2010

*Business closure in past 12 months
g hhbusclosure=(ba1a==1) if (ba1a==1 | ba1a==3) & ba1a!=.

/*Although the questionnaire asks for reasons, the business was closed (question ba1c),
this variable is not in the dataset and also not in the codebook file*/
g typeofbusclosed=ba1b

*I keep the open ended reasons for closure as for now to be able to decide later on appropriate coding
rename ba1c reasonforclosure

*Household operates a business
g hhbus=(ba1d==1) if ba1d!=.

*TO DO: decide whether you need/want to change path for saving "TTHAI14.dta"
/**/
save TTHAI14, replace 
/**/

*TO DO: change path to where you saved the following file "hh10_13ba_tab1.txt" of the 2010 annual household resurvey (rural sample)
/*EXAMPLE:*/
import delimited "Townsend Thai Project/2010/hh10_13ba_tab1.txt", encoding(ISO-8859-1) clear
/**/

/*Only keep the information for the first business as I will only consider businesses
 of households who have only one business:*/
keep if bnumber==1

*TO DO: change path to where you saved the following file "TTHAI14.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI14, nogenerate
/**/

*Household entirely owns household business
replace ba2=0 if hhbus==0

g enf_bus=(ba6==1) if ba6!=.

*Household entirely owns household business
*Business founded in last 12 months:
g newfirmquex=(ba21a==1) if ba21a!=.

/*I will only consider household enterprises if the household operates only one 
enterprise and if this enterprise is entirely owned by the household:*/
g tbdropped=(ba2>1) if ba2!=. | enf_bus!=1

*Since the questionnaire mixes non-farm and farm enterprises:
g nonfarm=(ba3a==1 | ba3a==3 | ba3a==5 | ba3a==15 | ba3a==17 | ba3a==19) if hhbus==1 & ba3a!=.

replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="10-wheels truck for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="6-wheel truck for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="6-wheels truck for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Construction contractor"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Let houses for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Let snooker tables for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Make clothes"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Make dolls"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Petrol station"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Photocopier shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Produce roman pillars"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Purchase rubber wood"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Repair clothes"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Sew cloth"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Taxi-motorcycle"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Trade antiques"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Tricycle for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Van for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Wooden handicraft products"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="amplifiers and lights for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="basketwork, weaving"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="bottled fuels"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buying and selling junks"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buying rubber bits and pieces"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="car wash"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="clothes repair"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="craftwork from coconut shells"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="dress maker"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="dressmaker/tailor"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="embroidery"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="engined tricycle for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="farm output transporting truck for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="fasten thatches for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="games shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="make artificial flowers for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="make broomsticks"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making blooms for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making iron frame roofs for cars"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making mosquito net and curved steel"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="motorcycle for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="music band"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="painting for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="produce traditional medicines for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="recap tyres of bicycles and motorcycles"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell drinking water"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell firewoods"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell orchids"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell ornamental plants"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell sweets"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="selling clothes"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="selling oil"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sew pillow cases for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="shoes repair shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="snooker table"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="snooker table/s for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="soil loading truck"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="traditional massage"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="transportation services for workers"

replace hhbus=0 if nonfarm==0
replace hhbus=. if nonfarm==. & hhbus!=0

*Type of business
g typeofbus=ba3a if hhbus==1

*Sector of the firm:
*Firm is in retail trade
g retail=(ba3a==1 | ba3a==17) if hhbus==1
replace retail=1 if hhbus==1 & ba3a==21 & (ba3ao2=="Petrol station" | ba3ao2=="Trade antiques" |  ba3ao2=="sell drinking water" | ba3ao2=="sell firewoods" | ba3ao2=="sell orchids" | ba3ao2=="sell ornamental plants"| ba3ao2=="selling clothes" | ba3ao2=="selling oil")

*Firm is in manufacturing sector
g manuf=(ba3a==21 & (ba3ao2=="Make clothes" | ba3ao2=="Make dolls" | ba3ao2=="Produce roman pillars" |  ba3ao2=="Sew cloth" | ba3ao2=="basketwork, weaving" | ba3ao2=="craftwork from coconut shells" | ba3ao2=="dress maker" | ba3ao2=="dressmaker/tailor" | ba3ao2=="embroidery" | ba3ao2=="make artificial flowers for sale" | ba3ao2=="make broomsticks" | ba3ao2=="making iron frame roofs for cars" | ba3ao2=="making mosquito net and curved steel" | ba3ao2=="sew pillow cases for sale")) if hhbus==1  
   
*Firm is in service sector
g services=(ba3a==3 | ba3a==5 | ba3a==15 | ba3a==19) if hhbus==1
replace services=1 if hhbus==1 & ba3a==21 & (ba3ao2=="10-wheels truck for hire" | ba3ao2=="6-wheel truck for hire" | ba3ao2=="6-wheels truck for hire" | ba3ao2=="Let houses for rent" | ba3ao2=="Let snooker tables for rent" | ba3ao2=="Repair clothes" | ba3ao2=="Taxi-motorcycle" | ba3ao2=="Tricycle for hire" | ba3ao2=="Van for hire" | ba3ao2=="amplifiers and lights for rent" | ba3ao2=="car wash" | ba3ao2=="clothes repair" | ba3ao2=="engined tricycle for hire" | ba3ao2=="farm output transporting truck for rent" | ba3ao2=="large 4-wheel tractor for hire" | ba3ao2=="motorcycle for hire" | ba3ao2=="music band" | ba3ao2=="sell sweets" | ba3ao2=="shoes repair shop" | ba3ao2=="snooker table" | ba3ao2=="snooker table/s for rent" | ba3ao2=="traditional massage" | ba3ao2=="transportation services for workers")

*Firm is in other sector
g othersector=(retail==0 & manuf==0 & services==0) if hhbus==1 

replace othersector=. if  hhbus==1  & (ba3ao2=="Purchase rubber wood" | ba3ao2=="Wooden handicraft products" | ba3ao2=="bottled fuels" | ba3ao2=="buying and selling junks" | ba3ao2=="buying rubber bits and pieces" | ba3ao2=="fasten thatches for sale" | ba3ao2=="games shop" | ba3ao2=="making blooms for sale" | ba3ao2=="produce traditional medicines for sale")
replace services=. if  hhbus==1  & (ba3ao2=="Purchase rubber wood" | ba3ao2=="Wooden handicraft products" | ba3ao2=="bottled fuels" | ba3ao2=="buying and selling junks" | ba3ao2=="buying rubber bits and pieces" | ba3ao2=="fasten thatches for sale" | ba3ao2=="games shop" | ba3ao2=="making blooms for sale" | ba3ao2=="produce traditional medicines for sale")
replace manuf=. if  hhbus==1  & (ba3ao2=="Purchase rubber wood" | ba3ao2=="Wooden handicraft products" | ba3ao2=="bottled fuels" | ba3ao2=="buying and selling junks" | ba3ao2=="buying rubber bits and pieces" | ba3ao2=="fasten thatches for sale" | ba3ao2=="games shop" | ba3ao2=="making blooms for sale" | ba3ao2=="produce traditional medicines for sale")
replace retail=. if  hhbus==1  & (ba3ao2=="Purchase rubber wood" | ba3ao2=="Wooden handicraft products" | ba3ao2=="bottled fuels" | ba3ao2=="buying and selling junks" | ba3ao2=="buying rubber bits and pieces" | ba3ao2=="fasten thatches for sale" | ba3ao2=="games shop" | ba3ao2=="making blooms for sale" | ba3ao2=="produce traditional medicines for sale")


*Age of the firm in years
g agefirm=ba4 if hhbus==1 

*Number of paid employees
g employees=ba12 if hhbus==1 

g totalworkers=ba9 if hhbus==1 

keep newid reasonforclosure wave-totalworkers

*TO DO: decide whether you need/want to change path for saving "TTHAI14.dta"
/**/
save TTHAI14, replace
/**/


*TO DO: change path to where you saved the following file "hh10_16in_tab1.txt" of the 2010 annual household resurvey (rural sample)
/*EXAMPLE:*/
import delimited "Townsend Thai Project/2010/hh10_16in_tab1.txt", encoding(ISO-8859-1) clear
/**/

*Business sales in last month
keep if number=="N" | number=="O" | number=="P" | number=="Q" | number=="R" | number=="S" | number=="U" | number=="AA"
replace in4=0 if in2==3
bysort newid: egen sales=total(in4), m
*Since sales are given for past 12 months:
replace sales=sales/12

keep newid sales
duplicates drop

merge 1:1 newid using TTHAI14, nogenerate

*TO DO: decide whether you need/want to change path for saving "TTHAI14.dta"
/**/
save TTHAI14, replace
/**/

*TO DO: change path to where you saved the following file "hh10_16in.txt" of the 2010 annual household resurvey (rural sample)
/*EXAMPLE:*/
import delimited "Townsend Thai Project/2010/hh10_16in.txt", encoding(ISO-8859-1) clear
/**/

g expenses=in10b/12 

keep newid expenses

*TO DO: change path to where you saved the following file "TTHAI14.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI14, nogenerate
/**/

g profits=sales-expenses if hhbus==1

*TO DO: decide whether you need/want to change path for saving "TTHAI14.dta"
/**/
save TTHAI14, replace
/**/

*TO DO: change path to where you saved the following file "hh10_01cvr.txt" of the 2010 annual household resurvey (rural sample)
/*EXAMPLE:*/
import delimited "Townsend Thai Project/2010/hh10_01cvr.txt", encoding(ISO-8859-1) clear
/**/

*Marital status of owner
*Since the marital status is only given for household heads, I can only compute it for head and their spouses
g help=1 if cvr7==1 | cvr7==3 
g married=(cvr11==3) if help==1 & cvr11!=-8
drop help

keep newid married

*TO DO: change path to where you saved the following file "TTHAI14.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI14, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving "TTHAI14.dta"
/**/
save TTHAI14, replace
/**/

*TO DO: change path to where you saved the following file "hh10_01cvr.txt" of the 2010 annual household resurvey (rural sample)
/*EXAMPLE:*/
import delimited "Townsend Thai Project/2010/hh10_05oc_tab1.txt", encoding(ISO-8859-1) clear
/**/

*TO DO: decide whether you need/want to change path for saving "hh10_05oc_tab1.dta"
/**/
save "Townsend Thai Project/2010/hh10_05oc_tab1.dta", replace
/**/

*TO DO: change path to where you saved the following file "hh10_04hc_tab1.txt" of the 2010 annual household resurvey (rural sample)
/*EXAMPLE:*/
import delimited "Townsend Thai Project/2010/hh10_04hc_tab1.txt", encoding(ISO-8859-1) clear
/**/

*Age of owner
g ownerage=hc5

*Gender of owner
g female=(hc4==3) if hc4!=.

*Education of owner
g ownertertiary=(hc7==47 | hc7==49 | hc7==51 | hc7==53) if hc7!=. & hc7!=-999 & hc7!=-888

*Years of education
*I assume the number is the years of education and calculate 6 years for primary and 6 years for secondary
*Sources: 	https://en.wikipedia.org/wiki/Education_in_Thailand
*			http://open_jicareport.jica.go.jp/pdf/11548013.pdf
g educyears=0 if hc7==1 | hc7==3 | hc7==5 | hc7==7 | hc7==9
replace educyears=1 if hc7==11
replace educyears=2 if hc7==13
replace educyears=3 if hc7==15
replace educyears=4 if hc7==17
replace educyears=5 if hc7==19
replace educyears=6 if hc7==21
replace educyears=7 if hc7==23
replace educyears=7 if hc7==25
replace educyears=8 if hc7==27
replace educyears=9 if hc7==29
replace educyears=10 if hc7==31 | hc7==41
replace educyears=11 if hc7==33 | hc7==43
replace educyears=12 if hc7==35 | hc7==45
replace educyears=13 if hc7==37 | hc7==47 | hc7==51 | hc7==55
replace educyears=14 if hc7==39 | hc7==49 | hc7==53 | hc7==57
replace educyears=15 if hc7==59
replace educyears=16 if hc7==61

*Child under 5 in household
g under5=0
replace under5=. if hc5==. 
replace under5=1 if hc5<5 
bysort newid: egen childunder5=max(under5)
drop under5

*Child aged 5 to 12 in household
g aged5to12=0
replace aged5to12=. if  hc5==. 
replace aged5to12=1 if  hc5>=5 &  hc5<12
bysort newid: egen childaged5to12=max(aged5to12)
drop aged5to12

*Has adult aged 65+ in the household
g is65orover=0
replace is65orover=. if hc5==. 
replace is65orover=1 if hc5>=65 & hc5!=. 
bysort newid: egen adult65andover=max(is65orover)
drop is65orover

*TO DO: change path to where you saved the following file "hh10_05oc_tab1.dta" of the 2010 annual household resurvey (rural sample)
/*EXAMPLE:*/
merge 1:1 newid number using "Townsend Thai Project/2010/hh10_05oc_tab1.dta", nogenerate
/**/

g businessowner=(oc1b==1) if oc1b!=. 

/*I code individuals as wage workers if the type of employment reported is either:
 - employee - daily wages, or
 - employee - monthly wages, or
 - government worker.
 I do not consider individuals to be wage workers if the type of employment reported is either:
 - owner of business, or
 - unpaid family worker, or
 - employee - piece rate, in house, or
 - employee - piece rate, out of house, or
 - other.
*/

*Worked as wage worker in last month
g wageworker=(oc1b==5 | oc1b==7 | oc1b==13) if oc1b!=.

*Labor earnings in last month
*Replace missing values:
g laborincome=oc1c if oc1b==7 | oc1b==13
*For government workers it is not clear if the wages are given on a daily or monthly frequency, but I assume from the values that they are monthly
*In case wages are given for a daily frequency, I multiply them with 20 to have monthly wages:
replace laborincome=oc1c*20 if oc1b==5

*Retired
g retired=(oc1a==1) if  oc1a!=.

keep newid number ownerage-adult65andover businessowner wageworker laborincome retired

*TO DO: change path to where you saved the following file "TTHAI14.dta"
/*EXAMPLE:*/
merge m:1 newid using TTHAI14, nogenerate 
/**/

g hhbusowner=(businessowner==1) if hhbus==1 & businessowner!=.

drop businessowner

duplicates tag newid hhbusowner if hhbus==1 & hhbusowner==1, gen(totalowners)
replace totalowners=totalowners+1

g jointbus=(totalowners>1) if hhbus==1 & totalowners!=.

*TO DO: decide whether you need/want to change path for saving "TTHAI14.dta"
/**/
save TTHAI14, replace
/**/

*Household consumption
*TO DO: change path to where you saved the following file "hh10_15ex.txt" of the 2010 annual household resurvey (rural sample)
/*EXAMPLE:*/
import delimited "Townsend Thai Project/2010/hh10_15ex.txt", encoding(ISO-8859-1) clear
/**/
*TO DO: decide whether you need/want to change path for saving "hh10_15ex.dta"
/**/
save "Townsend Thai Project/2010/hh10_15ex.dta", replace
/**/
*TO DO: change path to where you saved the following file "hh10_15ex.txt" of the 2010 annual household resurvey (rural sample)
/*EXAMPLE:*/
import delimited "Townsend Thai Project/2010/hh10_15ex_tab1.txt", encoding(ISO-8859-1) clear
/**/
*TO DO: decide whether you need/want to change path for saving "hh10_15ex_tab1.dta"
/**/
save "Townsend Thai Project/2010/hh10_15ex_tab1.dta", replace
/**/
*TO DO: change path to where you saved the following file "hh10_04hc.txt" of the 2010 annual household resurvey (rural sample)
/*EXAMPLE:*/
import delimited "Townsend Thai Project/2010/hh10_04hc.txt", encoding(ISO-8859-1) clear
/**/
keep newid hc1

*TO DO: change path to where you saved the following file "hh10_15ex.dta" of the 2010 annual household resurvey (rural sample)
/*EXAMPLE:*/
merge 1:1 newid using "Townsend Thai Project/2010/hh10_15ex.dta", nogenerate
/**/
*TO DO: change path to where you saved the following file "hh10_15ex_tab1.dta" of the 2010 annual household resurvey (rural sample)
/*EXAMPLE:*/
merge 1:m newid using "Townsend Thai Project/2010/hh10_15ex_tab1.dta", nogenerate
/**/
replace ex4=. if ex4==.b | ex4==.c | ex4==.y

bysort newid: egen monthlyexp=total(ex4),m

keep newid monthlyexp hc1 ex5-ex9
duplicates drop

replace monthlyexp=12*monthlyexp
egen hh_exp=rowtotal(monthlyexp ex5-ex9), missing

g pcexpend=hh_exp/hc1

drop monthlyexp hh_exp hc1 ex5-ex9

*TO DO: change path to where you saved the following file "TTHAI14.dta"
/*EXAMPLE:*/
merge 1:m newid using TTHAI14, nogenerate
/**/

*Exchange rate for approximate midpoint of survey period
/*There is no documentation for the 2010 survey round but I assume that for this round
 wthe data was also collected in May, so I use May 15 as approximate midpoint for the exchange rate*/

g excrate=0.03078

g excratemonth="5-2010"


foreach var of varlist ownerage ownertertiary educyears married childunder5 childaged5to12 adult65andover wageworker laborincome retired sales reasonforclosure wave surveyyear hhbusclosure typeofbusclosed hhbus enf_bus newfirmquex tbdropped nonfarm typeofbus retail manuf services othersector agefirm employees totalworkers expenses profits hhbusowner totalowners jointbus pcexpend excrate*{ 
rename `var' `var'_2010
} 

rename number hc_id

tostring newid, replace format(%12.0f)
replace newid="0"+newid if strlen(newid)==11

*TO DO: decide whether you need/want to change path for saving "TTHAI14.dta"
/**/
save TTHAI14, replace
/**/

********************************************************************************
*Round 14 - Urban sample
********************************************************************************
*TO DO: change path to where you saved the following file "hh10_13ba.dta" of the 2010 annual household resurvey (urban sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2010/Urban/hh10_13ba.dta", clear
/**/

*Survey round number
g wave=14

*Year survey took place
g surveyyear=2010

*Business closure in past 12 months
g hhbusclosure=(ba1a==1) if (ba1a==1 | ba1a==3) & ba1a!=.c

/*Although the questionnaire asks for reasons, the business was closed (question ba1c),
this variable is not in the dataset and also not in the codebook file*/
replace ba1b=. if ba1b==.c
g typeofbusclosed=ba1b

*I keep the open ended reasons for closure as for now to be able to decide later on appropriate coding
rename ba1c reasonforclosure

*Household operates a business
g hhbus=(ba1d==1) if ba1d!=.c


*TO DO: decide whether you need/want to change path for saving "TTHAI14u.dta"
/**/
save TTHAI14u, replace 
/**/

*TO DO: change path to where you saved the following file "hh10_13ba_tab1.dta" of the 2010 annual household resurvey (urban sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2010/Urban/hh10_13ba_tab1.dta", clear
/**/

/*Only keep the information for the first business as I will only consider businesses
 of households who have only one business:*/
keep if bnumber==1

*TO DO: change path to where you saved the following file "TTHAI14u.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI14u, nogenerate
/**/

*Household entirely owns household business
replace ba2=0 if hhbus==0

g enf_bus=(ba6==1) if ba6!=.

*Household entirely owns household business
*Business founded in last 12 months:
g newfirmquex=(ba21a==1) if ba21a!=.

/*I will only consider household enterprises if the household operates only one 
enterprise and if this enterprise is entirely owned by the household:*/
g tbdropped=(ba2>1) if ba2!=. | enf_bus!=1

*Since the questionnaire mixes non-farm and farm enterprises:
g nonfarm=(ba3a==1 | ba3a==3 | ba3a==5 | ba3a==15 | ba3a==17 | ba3a==19) if hhbus==1 & ba3a!=.c

replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="10-wheels truck for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="6 wheels truck for soil carrying"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Chinese dining set"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Clothes making shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Construction contractor"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Electric appliance repairing shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Give tution"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Install car stereoes"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Install gutters"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Laundry service"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Laundry service shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Let houses for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Let rooms for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Make banners and boards"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Make clothes"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Mo Hom products shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Petrol station"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Photocopier shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Printing shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Produce furnitures"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Produce grill doors"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Produce roman pillars"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Repair electric appliances"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Ride a taxi-motorcycle"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="School van"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Sell foods"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Sew cloth"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Som Tam(a kind of Thai food) shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Taxi-motorcycle"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Tea shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Thai traditional massage"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Trade antiques"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Tricycle for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Van for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Vehicle care taking service"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="aluminum works"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="amulet frame shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="antique shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="aquariums"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="blackhole car"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="bus for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buy-sell amulets"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buy-sell betel leaves and betel nuts"
replace nonfarm=1 if hhbus==. & ba3a==21 & ba3ao2=="buy-sell kha nom"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buy-sell paddy"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buy-sell para rubber woods"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buying and selling small buddha images"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buying used vegetable oil"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="car accessory shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="car pad making shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="car painting"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="cesspool drainage"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="cinematograph"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="computer repair shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="curtain making"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="deliver vegetables"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="dormitory/student hostel"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="dress making shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="dressmaker (tailor)"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="drug store"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="fixing glasses and aluminum"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="furniture shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="gas shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="goat curries"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="ice producing shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="install and repair air conditioners"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="iron smith"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="iron welder"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="iron welding garage"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="karaoke shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="lathe shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="laundry"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="laundry shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="make gift boxes"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="make iron and aluminum doors"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making bakery for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making bird cages for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making food for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="miniature houses for merit making"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="motorcycle for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="motorcycle parts shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="motorcycle with side trailer"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="movies showing"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="paddy transport truck for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="phone repairing"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="recording commercial spots"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="repair and sell motorcycle parts"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="repair electric appliances"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sculture maker"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell Mo Hom products"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell and repair watches"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell baked clay pottery"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell bakeries"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell chilli paste"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell clothes in dozen"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell coffin"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell curries"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell drinking water"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell drinks and soft drinks"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell electric appliances"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell flowers"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell fruits"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell furniture"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell ice"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell local foods"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell ornament flowers"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell shells"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell soft drinks"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell tobacco"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell toys"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell vegetables"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="selling auto parts"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="selling foods"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="selling fried meatballs"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="selling groceries"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="selling khao-nio-nung (steamed sticky rice)"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="selling used cars"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sewing bags"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sewing clothes for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sewing thatches for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="showing movies in open air theatre"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="small local rockets"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="snooker table"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="students transportation services van"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="take-home curries for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="taxi"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="ten-wheel truck"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to cook sweets"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to do iron making for robber prevention"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to make strove"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="traditional massage"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="traditional medicines shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="tricycle for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="unbrellas and chairs for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="welder"

replace hhbus=0 if nonfarm==0
replace hhbus=. if nonfarm==. & hhbus!=0

*Type of business
replace ba3a=. if ba3a==.c
g typeofbus=ba3a if hhbus==1

*Sector of the firm:
*Firm is in retail trade
g retail=(ba3a==1 | ba3a==17) if hhbus==1
replace retail=1 if hhbus==1 & ba3a==21 & (ba3ao2=="Mo Hom products shop" | ba3ao2=="Petrol station" | ba3ao2=="Trade antiques" | ba3ao2=="antique shop" | ba3ao2=="buy-sell paddy" | ba3ao2=="buy-sell para rubber woods" | ba3ao2=="buying and selling small buddha images" | ba3ao2=="car accessory shop" | ba3ao2=="furniture shop" | ba3ao2=="gas shop" | ba3ao2=="motorcycle parts shop" | ba3ao2=="paddy transport truck for sale" | ba3ao2=="sell Mo Hom products" | ba3ao2=="sell and repair watches" | ba3ao2=="sell baked clay pottery" | ba3ao2=="sell clothes in dozen" | ba3ao2=="sell coffin" | ba3ao2=="sell drinking water" | ba3ao2=="sell electric appliances" | ba3ao2=="sell flowers" | ba3ao2=="sell fruits" | ba3ao2=="sell furniture" | ba3ao2=="sell ornament flowers" | ba3ao2=="sell tobacco" | ba3ao2=="sell toys" | ba3ao2=="sell vegetables" | ba3ao2=="selling auto parts" | ba3ao2=="selling groceries" | ba3ao2=="selling used cars")

*Firm is in manufacturing sector
g manuf=(ba3a==21 & (ba3ao2=="Clothes making shop" | ba3ao2=="Make banners and boards" | ba3ao2=="Make clothes" | ba3ao2=="Produce furnitures" | ba3ao2=="Produce grill doors" | ba3ao2=="Produce roman pillars" | ba3ao2=="Sew cloth" | ba3ao2=="aluminum works" | ba3ao2=="curtain making" | ba3ao2=="dress making shop" | ba3ao2=="dressmaker (tailor)" | ba3ao2=="iron smith" | ba3ao2=="iron welder" | ba3ao2=="iron welding garage" | ba3ao2=="make iron and aluminum doors" | ba3ao2=="sculture maker" | ba3ao2=="sewing clothes for sale" | ba3ao2=="sewing thatches for sale" | ba3ao2=="to do iron making for robber prevention" | ba3ao2=="welder")) if hhbus==1  

*Firm is in service sector
g services=(ba3a==3 | ba3a==5 | ba3a==15 | ba3a==19) if hhbus==1
replace services=1 if hhbus==1 & ba3a==21 & (ba3ao2=="10-wheels truck for hire" | ba3ao2=="6 wheels truck for soil carrying" | ba3ao2=="Electric appliance repairing shop" | ba3ao2=="Give tution" | ba3ao2=="Laundry service" | ba3ao2=="Laundry service shop" | ba3ao2=="Let houses for rent" | ba3ao2=="Let rooms for rent"| ba3ao2=="Paddy thrashing truck" | ba3ao2=="Photocopier shop" | ba3ao2=="Printing shop" | ba3ao2=="Repair electric appliances" | ba3ao2=="Ride a taxi-motorcycle" | ba3ao2=="School van" | ba3ao2=="Sell foods" | ba3ao2=="Som Tam(a kind of Thai food) shop" | ba3ao2=="Taxi-motorcycle" | ba3ao2=="Tea shop" | ba3ao2=="Thai traditional massage" | ba3ao2=="Tricycle for hire" | ba3ao2=="Van for hire" | ba3ao2=="Vehicle care taking service" | ba3ao2=="bus for hire" | ba3ao2=="cinematograph" | ba3ao2=="computer repair shop" | ba3ao2=="deliver vegetables" | ba3ao2=="dormitory/student hostel" | ba3ao2=="goat curries" | ba3ao2=="install and repair air conditioners" | ba3ao2=="karaoke shop" | ba3ao2=="laundry" | ba3ao2=="laundry shop" | ba3ao2=="making bakery for sale" | ba3ao2=="making food for sale" | ba3ao2=="motorcycle for hire" | ba3ao2=="motorcycle with side trailer" | ba3ao2=="movies showing" | ba3ao2=="phone repairing" | ba3ao2=="recording commercial spots" | ba3ao2=="repair electric appliances" | ba3ao2=="sell bakeries" | ba3ao2=="sell curries" | ba3ao2=="sell drinks and soft drinks" | ba3ao2=="sell local foods" | ba3ao2=="selling foods" | ba3ao2=="selling fried meatballs" | ba3ao2=="selling khao-nio-nung (steamed sticky rice)" | ba3ao2=="showing movies in open air theatre" | ba3ao2=="snooker table" | ba3ao2=="students transportation services van" | ba3ao2=="take-home curries for sale" | ba3ao2=="taxi" | ba3ao2=="ten-wheel truck" | ba3ao2=="to cook sweets" | ba3ao2=="traditional massage" | ba3ao2=="tricycle for hire" | ba3ao2=="unbrellas and chairs for rent")

*Firm is in other sector
g othersector=(retail==0 & manuf==0 & services==0) if hhbus==1 

replace othersector=. if hhbus==1 & (ba3ao2=="Chinese dining set" | ba3ao2=="amulet frame shop" | ba3ao2=="aquariums" | ba3ao2=="blackhole car" | ba3ao2=="buying used vegetable oil" | ba3ao2=="car pad making shop" | ba3ao2=="fixing glasses and aluminum" | ba3ao2=="lathe shop" | ba3ao2=="make gift boxes" | ba3ao2=="miniature houses for merit making" | ba3ao2=="sell chilli paste" | ba3ao2=="sell ice" | ba3ao2=="sell soft drinks" | ba3ao2=="small local rockets" | ba3ao2=="to make strove" | ba3ao2=="traditional medicines shop")
replace services=. if hhbus==1 & (ba3ao2=="Chinese dining set" | ba3ao2=="amulet frame shop" | ba3ao2=="aquariums" | ba3ao2=="blackhole car" | ba3ao2=="buying used vegetable oil" | ba3ao2=="car pad making shop" | ba3ao2=="fixing glasses and aluminum" | ba3ao2=="lathe shop" | ba3ao2=="make gift boxes" | ba3ao2=="miniature houses for merit making" | ba3ao2=="sell chilli paste" | ba3ao2=="sell ice" | ba3ao2=="sell soft drinks" | ba3ao2=="small local rockets" | ba3ao2=="to make strove" | ba3ao2=="traditional medicines shop")
replace manuf=. if hhbus==1 & (ba3ao2=="Chinese dining set" | ba3ao2=="amulet frame shop" | ba3ao2=="aquariums" | ba3ao2=="blackhole car" | ba3ao2=="buying used vegetable oil" | ba3ao2=="car pad making shop" | ba3ao2=="fixing glasses and aluminum" | ba3ao2=="lathe shop" | ba3ao2=="make gift boxes" | ba3ao2=="miniature houses for merit making" | ba3ao2=="sell chilli paste" | ba3ao2=="sell ice" | ba3ao2=="sell soft drinks" | ba3ao2=="small local rockets" | ba3ao2=="to make strove" | ba3ao2=="traditional medicines shop")
replace retail=. if hhbus==1 & (ba3ao2=="Chinese dining set" | ba3ao2=="amulet frame shop" | ba3ao2=="aquariums" | ba3ao2=="blackhole car" | ba3ao2=="buying used vegetable oil" | ba3ao2=="car pad making shop" | ba3ao2=="fixing glasses and aluminum" | ba3ao2=="lathe shop" | ba3ao2=="make gift boxes" | ba3ao2=="miniature houses for merit making" | ba3ao2=="sell chilli paste" | ba3ao2=="sell ice" | ba3ao2=="sell soft drinks" | ba3ao2=="small local rockets" | ba3ao2=="to make strove" | ba3ao2=="traditional medicines shop")


*Age of the firm in years
g agefirm=ba4 if hhbus==1 

*Number of paid employees
replace ba12=. if ba12==.c
g employees=ba12 if hhbus==1 

g totalworkers=ba9 if hhbus==1 

keep newid reasonforclosure wave-totalworkers
*TO DO: decide whether you need/want to change path for saving "TTHAI14u.dta"
/**/
save TTHAI14u, replace
/**/

*TO DO: change path to where you saved the following file "hh10_16in_tab1.dta" of the 2010 annual household resurvey (urban sample)
/*EXAMPLE: */
use "Townsend Thai Project/2010/Urban/hh10_16in_tab1.dta", clear
/**/

*Business sales in last month
keep if number=="N" | number=="O" | number=="P" | number=="Q" | number=="R" | number=="S" | number=="U" | number=="AA"
replace in4=0 if in2==3
bysort newid: egen sales=total(in4), m
*Since sales are given for past 12 months:
replace sales=sales/12

keep newid sales
duplicates drop

*TO DO: change path to where you saved the following file "TTHAI14u.dta" 
/*EXAMPLE: */
merge 1:1 newid using TTHAI14u, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving "TTHAI14u.dta"
/**/
save TTHAI14u, replace
/**/

*TO DO: change path to where you saved the following file "hh10_16in.dta" of the 2010 annual household resurvey (urban sample)
/*EXAMPLE: */
use "Townsend Thai Project/2010/Urban/hh10_16in.dta", clear
/**/

g expenses=in10b/12 

keep newid expenses

*TO DO: change path to where you saved the following file "TTHAI14u.dta" 
/*EXAMPLE: */
merge 1:1 newid using TTHAI14u, nogenerate
/**/

g profits=sales-expenses if hhbus==1

*TO DO: decide whether you need/want to change path for saving "TTHAI14u.dta"
/**/
save TTHAI14u, replace
/**/

*TO DO: change path to where you saved the following file "hh10_01cvr.dta" of the 2010 annual household resurvey (urban sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2010/Urban/hh10_01cvr.dta", clear
/**/

*Marital status of owner
*Since the marital status is only given for household heads, I can only compute it for head and their spouses
g help=1 if cvr7==1 | cvr7==3 
g married=(cvr11==3) if help==1 & cvr11!=-8
drop help

keep newid married

*TO DO: change path to where you saved the following file "TTHAI14u.dta" 
/*EXAMPLE: */
merge 1:1 newid using TTHAI14u, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving "TTHAI14u.dta"
/**/
save TTHAI14u, replace
/**/

*TO DO: change path to where you saved the following file "hh10_04hc_tab1.dta" of the 2010 annual household resurvey (urban sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2010/Urban/hh10_04hc_tab1.dta", clear
/**/

*Age of owner
g ownerage=hc5

*Gender of owner
g female=(hc4==3) if hc4!=.

*Education of owner
g ownertertiary=(hc7==47 | hc7==49 | hc7==51 | hc7==53) if hc7!=. & hc7!=-999 & hc7!=-888

*Years of education
*I assume the number is the years of education and calculate 6 years for primary and 6 years for secondary
*Sources: 	https://en.wikipedia.org/wiki/Education_in_Thailand
*			http://open_jicareport.jica.go.jp/pdf/11548013.pdf
g educyears=0 if hc7==1 | hc7==3 | hc7==5 | hc7==7 | hc7==9
replace educyears=1 if hc7==11
replace educyears=2 if hc7==13
replace educyears=3 if hc7==15
replace educyears=4 if hc7==17
replace educyears=5 if hc7==19
replace educyears=6 if hc7==21
replace educyears=7 if hc7==23
replace educyears=7 if hc7==25
replace educyears=8 if hc7==27
replace educyears=9 if hc7==29
replace educyears=10 if hc7==31 | hc7==41
replace educyears=11 if hc7==33 | hc7==43
replace educyears=12 if hc7==35 | hc7==45
replace educyears=13 if hc7==37 | hc7==47 | hc7==51 | hc7==55
replace educyears=14 if hc7==39 | hc7==49 | hc7==53 | hc7==57
replace educyears=15 if hc7==59
replace educyears=16 if hc7==61

*Child under 5 in household
g under5=0
replace under5=. if hc5==. 
replace under5=1 if hc5<5 
bysort newid: egen childunder5=max(under5)
drop under5

*Child aged 5 to 12 in household
g aged5to12=0
replace aged5to12=. if  hc5==. 
replace aged5to12=1 if  hc5>=5 &  hc5<12
bysort newid: egen childaged5to12=max(aged5to12)
drop aged5to12

*Has adult aged 65+ in the household
g is65orover=0
replace is65orover=. if hc5==. 
replace is65orover=1 if hc5>=65 & hc5!=. 
bysort newid: egen adult65andover=max(is65orover)
drop is65orover

*TO DO: change path to where you saved the following file "hh10_05oc_tab1.dta" of the 2010 annual household resurvey (urban sample)
/*EXAMPLE:*/
merge 1:1 newid number using "Townsend Thai Project/2010/Urban/hh10_05oc_tab1.dta", nogenerate
/**/

g businessowner=(oc1b==1) if oc1b!=. & oc1b!=.c 

/*I code individuals as wage workers if the type of employment reported is either:
 - employee - daily wages, or
 - employee - monthly wages, or
 - government worker.
 I do not consider individuals to be wage workers if the type of employment reported is either:
 - owner of business, or
 - unpaid family worker, or
 - employee - piece rate, in house, or
 - employee - piece rate, out of house, or
 - other.
*/

*Worked as wage worker in last month
g wageworker=(oc1b==5 | oc1b==7 | oc1b==13) if oc1b!=. & oc1b!=.c 

*Labor earnings in last month
*Replace missing values:
g laborincome=oc1c if oc1b==7 | oc1b==13
*For government workers it is not clear if the wages are given on a daily or monthly frequency, but I assume from the values that they are monthly
*In case wages are given for a daily frequency, I multiply them with 20 to have monthly wages:
replace laborincome=oc1c*20 if oc1b==5

*Retired
g retired=(oc1a==1) if  oc1a!=.

keep newid number ownerage-adult65andover businessowner wageworker laborincome retired

*TO DO: change path to where you saved the following file "TTHAI14u.dta" 
/*EXAMPLE:*/
merge m:1 newid using TTHAI14u, nogenerate 
/**/

g hhbusowner=(businessowner==1) if hhbus==1 & businessowner!=.

drop businessowner

duplicates tag newid hhbusowner if hhbus==1 & hhbusowner==1, gen(totalowners)
replace totalowners=totalowners+1

g jointbus=(totalowners>1) if hhbus==1 & totalowners!=.

*TO DO: decide whether you need/want to change path for saving "TTHAI14u.dta"
/**/
save TTHAI14u, replace
/**/

*Household consumption
*TO DO: change path to where you saved the following file "hh10_04hc.dta" of the 2010 annual household resurvey (urban sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2010/Urban/hh10_04hc.dta", clear
/**/
keep newid hc1

*TO DO: change path to where you saved the following file "hh10_15ex.dta" of the 2010 annual household resurvey (urban sample)
/*EXAMPLE:*/
merge 1:1 newid using "Townsend Thai Project/2010/Urban/hh10_15ex.dta", nogenerate
/**/
*TO DO: change path to where you saved the following file "hh10_15ex_tab1.dta" of the 2010 annual household resurvey (urban sample)
/*EXAMPLE:*/
merge 1:m newid using "Townsend Thai Project/2010/Urban/hh10_15ex_tab1.dta", nogenerate
/**/
replace ex4=. if ex4==.b | ex4==.c | ex4==.y

bysort newid: egen monthlyexp=total(ex4),m

keep newid monthlyexp hc1 ex5-ex9
duplicates drop

replace monthlyexp=12*monthlyexp
egen hh_exp=rowtotal(monthlyexp ex5-ex9), missing

g pcexpend=hh_exp/hc1

drop monthlyexp hh_exp hc1 ex5-ex9

*TO DO: change path to where you saved the following file "TTHAI14u.dta"
/*EXAMPLE:*/
merge 1:m newid using TTHAI14u, nogenerate
/**/

*Exchange rate for approximate midpoint of survey period
/*There is no documentation for the 2010 survey round but I assume that for this round
 wthe data was also collected in May, so I use May 15 as approximate midpoint for the exchange rate*/

g excrate=0.03078

g excratemonth="5-2010"


foreach var of varlist ownerage ownertertiary educyears married childunder5 childaged5to12 adult65andover wageworker laborincome retired sales reasonforclosure wave surveyyear hhbusclosure typeofbusclosed hhbus enf_bus newfirmquex tbdropped nonfarm typeofbus retail manuf services othersector agefirm employees totalworkers expenses profits hhbusowner totalowners jointbus pcexpend excrate*{ 
rename `var' `var'_2010
} 

rename number hc_id

*TO DO: decide whether you need/want to change path for saving "TTHAI14u.dta"
/**/
save TTHAI14u, replace
/**/
********************************************************************************
*TO DO: change path to where you saved the following file "TTHAI14.dta"
/*EXAMPLE:*/
append using TTHAI14, gen(help)
/**/

*TO DO: decide whether you need/want to change path for saving "TTHAI14.dta"
/**/
save TTHAI14, replace
/**/

********************************************************************************
*TO DO: change path to where you saved the following file "TTHAImaster.dta"
/*EXAMPLE:*/
use TTHAImaster,clear
/**/

*TO DO: change path to where you saved the following file "TTHAI14.dta"
/*EXAMPLE*/
merge 1:1 newid hc_id using TTHAI14, gen(_merge13) update
/**/

replace urban=1 if help==0 & urban==.
replace urban=0 if help==1 & urban==.
drop help

*TO DO: decide whether you need/want to change path for saving "TTHAImaster.dta"
/**/
save TTHAImaster, replace
/**/

********************************************************************************
*Round 15 - Rural sample
********************************************************************************
*TO DO: change path to where you saved the following file "hh11_13ba.dta" of the 2011 annual household resurvey (rural sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2011/hh11_13ba.dta", clear
/**/

*Survey round number
g wave=15

*Year survey took place
g surveyyear=2011

*Business closure in past 12 months
g hhbusclosure=(ba1a==1) if (ba1a==1 | ba1a==3) & ba1a!=.c

/*Although the questionnaire asks for reasons, the business was closed (question ba1c),
this variable is not in the dataset and also not in the codebook file*/
replace ba1b=. if ba1b==.c
g typeofbusclosed=ba1b

*I keep the open ended reasons for closure as for now to be able to decide later on appropriate coding
rename ba1c reasonforclosure

*Household operates a business
g hhbus=(ba1d==1) if ba1d!=.c

*TO DO: decide whether you need/want to change path for saving "TTHAI15.dta"
/**/
save TTHAI15, replace 
/**/

*TO DO: change path to where you saved the following file "hh11_13ba_tab1.dta" of the 2011 annual household resurvey (rural sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2011/hh11_13ba_tab1.dta", clear
/**/

/*Only keep the information for the first business as I will only consider businesses
 of households who have only one business:*/
keep if bnumber==1

*TO DO: change path to where you saved the following file "TTHAI15.dta" 
/*EXAMPLE:*/
merge 1:1 newid using TTHAI15, nogenerate
/**/

*Household entirely owns household business
replace ba2=0 if hhbus==0

g enf_bus=(ba6==1) if ba6!=.

*Household entirely owns household business
*Business founded in last 12 months:
g newfirmquex=(ba21a==1) if ba21a!=.

/*I will only consider household enterprises if the household operates only one 
enterprise and if this enterprise is entirely owned by the household:*/
g tbdropped=(ba2>1) if ba2!=.c | enf_bus!=1

*Since the questionnaire mixes non-farm and farm enterprises:
g nonfarm=(ba3a==1 | ba3a==3 | ba3a==5 | ba3a==15 | ba3a==17 | ba3a==19) if hhbus==1 & ba3a!=.c

replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="10-wheel truck for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="10-wheels truck for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="18-wheel truck for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="6-wheel truck for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Construction contractor"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Let houses for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Make clothes"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Make dolls"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Petrol station"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Photocopier shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Produce roman pillars"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Purchase rubber wood"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Sell foods"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Sew cloth"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Sewing blanket"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Sewing blanket for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Sewing pillow cases for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Sewing pillowcase"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Sewing socks and gloves for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Taxi-motorcycle"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Trade antiques"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Tricycle for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Truck for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Tyre service"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Van for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Water trucks for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Wooden handicraft products"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="almshouse"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="bottled fuels"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buying and selling junks"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buying rubber bits and pieces"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="car wash"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="clothes repair"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="craftwork from coconut shells"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="dress maker"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="dressmaker/tailor"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="electrical and Offer stereo system for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="embroidery"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="engined tricycle for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="farm output transporting truck for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="fasten thatches for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="made of wreath structure"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="made steamed stuff bun for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making blooms for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making mosquito net and curved steel"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="music band"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="produce traditional medicines for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of  drinks"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of antiques"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of food seasoning"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell government lottery"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="selling oil"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sew doormat"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sewing clothes for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sewing mo-hom clothes for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="shoes repair"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="shoes repair shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="snooker table"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="snooker table/s for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="soil loading truck"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to do laundry"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="traditional massage"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="transportation services for workers"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="weave sticky rice basket"

replace hhbus=0 if nonfarm==0
replace hhbus=. if nonfarm==. & hhbus!=0

*Type of business
g typeofbus=ba3a if hhbus==1

*Sector of the firm:
*Firm is in retail trade
g retail=(ba3a==1 | ba3a==17) if hhbus==1
replace retail=1 if hhbus==1 & ba3a==21 & (ba3ao2=="Trade antiques" | ba3ao2=="Petrol station" | ba3ao2=="Water trucks for sale" | ba3ao2=="sale of antiques" | ba3ao2=="sell government lottery" | ba3ao2=="selling oil")

*Firm is in manufacturing sector
g manuf=(ba3a==21 & (ba3ao2=="Make clothes" | ba3ao2=="Make dolls" | ba3ao2=="Produce roman pillars" | ba3ao2=="Sewing blanket for sale" | ba3ao2=="Sewing pillow cases for sale" | ba3ao2=="Sewing pillowcase" | ba3ao2=="Sewing socks and gloves for sale" | ba3ao2=="craftwork from coconut shells" | ba3ao2=="dress maker" | ba3ao2=="dressmaker/tailor" | ba3ao2=="embroidery" | ba3ao2=="fasten thatches for sale" | ba3ao2=="making mosquito net and curved steel" | ba3ao2=="sew doormat" | ba3ao2=="sewing clothes for sale" | ba3ao2=="sewing mo-hom clothes for sale" | ba3ao2=="weave sticky rice basket")) if hhbus==1  
   
*Firm is in service sector
g services=(ba3a==3 | ba3a==5 | ba3a==15 | ba3a==19) if hhbus==1
replace services=1 if hhbus==1 & ba3a==21 & (ba3ao2=="10-wheel truck for hire" | ba3ao2=="10-wheels truck for hire" | ba3ao2=="18-wheel truck for hire" | ba3ao2=="6-wheel truck for hire" | ba3ao2=="Let houses for rent" | ba3ao2=="Photocopier shop" | ba3ao2=="Sell foods" | ba3ao2=="Taxi-motorcycle" | ba3ao2=="Tricycle for hire" | ba3ao2=="Truck for hire" | ba3ao2=="Tyre service" | ba3ao2=="Van for hire" | ba3ao2=="car wash" | ba3ao2=="clothes repair" | ba3ao2=="electrical and Offer stereo system for rent" | ba3ao2=="engined tricycle for hire" | ba3ao2=="farm output transporting truck for rent" | ba3ao2=="made steamed stuff bun for sale" | ba3ao2=="music band" | ba3ao2=="sale of  drinks" | ba3ao2=="shoes repair" | ba3ao2=="shoes repair shop" | ba3ao2=="snooker table" | ba3ao2=="snooker table/s for rent" | ba3ao2=="to do laundry" | ba3ao2=="traditional massage" | ba3ao2=="transportation services for workers")

*Firm is in other sector
g othersector=(retail==0 & manuf==0 & services==0) if hhbus==1 

replace othersector=. if hhbus==1 & (ba3ao2=="Purchase rubber wood" | ba3ao2=="Wooden handicraft products" | ba3ao2=="almshouse" | ba3ao2=="bottled fuels" | ba3ao2=="buying and selling junks" | ba3ao2=="buying rubber bits and pieces" | ba3ao2=="made of wreath structure" | ba3ao2=="making blooms for sale" | ba3ao2=="sale of food seasoning")
replace services=. if hhbus==1 & (ba3ao2=="Purchase rubber wood"| ba3ao2=="Wooden handicraft products" | ba3ao2=="almshouse" | ba3ao2=="bottled fuels" | ba3ao2=="buying and selling junks" | ba3ao2=="buying rubber bits and pieces" | ba3ao2=="made of wreath structure" | ba3ao2=="making blooms for sale" | ba3ao2=="sale of food seasoning")
replace manuf=. if hhbus==1 & (ba3ao2=="Purchase rubber wood" | ba3ao2=="Wooden handicraft products" | ba3ao2=="almshouse" | ba3ao2=="bottled fuels" | ba3ao2=="buying and selling junks" | ba3ao2=="buying rubber bits and pieces" | ba3ao2=="made of wreath structure" | ba3ao2=="making blooms for sale" | ba3ao2=="sale of food seasoning")
replace retail=. if hhbus==1 & (ba3ao2=="Purchase rubber wood" | ba3ao2=="Wooden handicraft products" | ba3ao2=="almshouse" | ba3ao2=="bottled fuels" | ba3ao2=="buying and selling junks" | ba3ao2=="buying rubber bits and pieces" | ba3ao2=="made of wreath structure" | ba3ao2=="making blooms for sale" | ba3ao2=="sale of food seasoning")


*Age of the firm in years
g agefirm=ba4 if hhbus==1 

*Number of paid employees
replace ba12=. if ba12==.b | ba12==.c
g employees=ba12 if hhbus==1

replace ba9=. if ba9==.b
g totalworkers=ba9 if hhbus==1 

keep newid reasonforclosure wave-totalworkers
*TO DO: decide whether you need/want to change path for saving "TTHAI15.dta"
/**/
save TTHAI15, replace
/**/

*TO DO: change path to where you saved the following file "hh11_16in_tab1.dta" of the 2011 annual household resurvey (rural sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2011/hh11_16in_tab1.dta", clear
/**/

*Business sales in last month
keep if number=="N" | number=="O" | number=="P" | number=="Q" | number=="R" | number=="S" | number=="U" | number=="AA"
replace in4=0 if in2==3
bysort newid: egen sales=total(in4), m
*Since sales are given for past 12 months:
replace sales=sales/12

keep newid sales
duplicates drop

*TO DO: change path to where you saved the following file "TTHAI15.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI15, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving "TTHAI15.dta"
/**/
save TTHAI15, replace
/**/

*TO DO: change path to where you saved the following file "hh11_16in.dta" of the 2011 annual household resurvey (rural sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2011/hh11_16in.dta", clear
/**/

g expenses=in10b/12 

keep newid expenses

*TO DO: change path to where you saved the following file "TTHAI15.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI15, nogenerate
/**/

g profits=sales-expenses if hhbus==1

*TO DO: decide whether you need/want to change path for saving "TTHAI15.dta"
/**/
save TTHAI15, replace
/**/

*TO DO: change path to where you saved the following file "hh11_01cvr.dta" of the 2011 annual household resurvey (rural sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2011/hh11_01cvr.dta", clear
/**/

*Marital status of owner
*Since the marital status is only given for household heads, I can only compute it for head and their spouses
g help=1 if cvr7==1 | cvr7==3 
g married=(cvr11==3) if help==1 & cvr11!=-8
drop help

keep newid married

*TO DO: change path to where you saved the following file "TTHAI15.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI15, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving "TTHAI15.dta"
/**/
save TTHAI15, replace
/**/

*TO DO: change path to where you saved the following file "hh11_04hc_tab1.dta" of the 2011 annual household resurvey (rural sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2011/hh11_04hc_tab1.dta", clear
/**/

*Age of owner
g ownerage=hc5

*Gender of owner
g female=(hc4==3) if hc4!=.

*Education of owner
g ownertertiary=(hc7==47 | hc7==49 | hc7==51 | hc7==53) if hc7!=. & hc7!=-999 & hc7!=-888

*Years of education
*I assume the number is the years of education and calculate 6 years for primary and 6 years for secondary
*Sources: 	https://en.wikipedia.org/wiki/Education_in_Thailand
*			http://open_jicareport.jica.go.jp/pdf/11548013.pdf
g educyears=0 if hc7==1 | hc7==3 | hc7==5 | hc7==7 | hc7==9
replace educyears=1 if hc7==11
replace educyears=2 if hc7==13
replace educyears=3 if hc7==15
replace educyears=4 if hc7==17
replace educyears=5 if hc7==19
replace educyears=6 if hc7==21
replace educyears=7 if hc7==23
replace educyears=7 if hc7==25
replace educyears=8 if hc7==27
replace educyears=9 if hc7==29
replace educyears=10 if hc7==31 | hc7==41
replace educyears=11 if hc7==33 | hc7==43
replace educyears=12 if hc7==35 | hc7==45
replace educyears=13 if hc7==37 | hc7==47 | hc7==51 | hc7==55
replace educyears=14 if hc7==39 | hc7==49 | hc7==53 | hc7==57
replace educyears=15 if hc7==59
replace educyears=16 if hc7==61

*Child under 5 in household
g under5=0
replace under5=. if hc5==. 
replace under5=1 if hc5<5 
bysort newid: egen childunder5=max(under5)
drop under5

*Child aged 5 to 12 in household
g aged5to12=0
replace aged5to12=. if  hc5==. 
replace aged5to12=1 if  hc5>=5 &  hc5<12
bysort newid: egen childaged5to12=max(aged5to12)
drop aged5to12

*Has adult aged 65+ in the household
g is65orover=0
replace is65orover=. if hc5==. 
replace is65orover=1 if hc5>=65 & hc5!=. 
bysort newid: egen adult65andover=max(is65orover)
drop is65orover

*TO DO: change path to where you saved the following file "hh11_05oc_tab1.dta" of the 2011 annual household resurvey (rural sample)
/*EXAMPLE:*/
merge 1:1 newid number using "Townsend Thai Project/2011/hh11_05oc_tab1.dta", nogenerate
/**/

g businessowner=(oc1b==1) if oc1b!=. & oc1b!=.c 

/*I code individuals as wage workers if the type of employment reported is either:
 - employee - daily wages, or
 - employee - monthly wages, or
 - government worker.
 I do not consider individuals to be wage workers if the type of employment reported is either:
 - owner of business, or
 - unpaid family worker, or
 - employee - piece rate, in house, or
 - employee - piece rate, out of house, or
 - other.
*/

*Worked as wage worker in last month
g wageworker=(oc1b==5 | oc1b==7 | oc1b==13) if oc1b!=.

*Labor earnings in last month
*Replace missing values:
g laborincome=oc1c if oc1b==7 | oc1b==13
*For government workers it is not clear if the wages are given on a daily or monthly frequency, but I assume from the values that they are monthly
*In case wages are given for a daily frequency, I multiply them with 20 to have monthly wages:
replace laborincome=oc1c*20 if oc1b==5

*Retired
g retired=(oc1a==1) if  oc1a!=.

keep newid number ownerage-adult65andover businessowner wageworker laborincome retired

*TO DO: change path to where you saved the following file "TTHAI15.dta"
/*EXAMPLE:*/
merge m:1 newid using TTHAI15, nogenerate 
/**/

g hhbusowner=(businessowner==1) if hhbus==1 & businessowner!=.

drop businessowner

duplicates tag newid hhbusowner if hhbus==1 & hhbusowner==1, gen(totalowners)
replace totalowners=totalowners+1

g jointbus=(totalowners>1) if hhbus==1 & totalowners!=.

*TO DO: decide whether you need/want to change path for saving "TTHAI15.dta"
/**/
save TTHAI15, replace
/**/

*Household consumption
*TO DO: change path to where you saved the following file "hh11_04hc.dta" of the 2011 annual household resurvey (rural sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2011/hh11_04hc.dta", clear
/**/
keep newid hc1

*TO DO: change path to where you saved the following file "hh11_15ex.dta" of the 2011 annual household resurvey (rural sample)
/*EXAMPLE:*/
merge 1:1 newid using "Townsend Thai Project/2011/hh11_15ex.dta", nogenerate
/**/

*TO DO: change path to where you saved the following file "hh11_15ex_tab1.dta" of the 2011 annual household resurvey (rural sample)
/*EXAMPLE:*/
merge 1:m newid using "Townsend Thai Project/2011/hh11_15ex_tab1.dta", nogenerate
/**/

replace ex4=. if ex4==.b | ex4==.c | ex4==.y

bysort newid: egen monthlyexp=total(ex4),m

keep newid monthlyexp hc1 ex5-ex9
duplicates drop

replace monthlyexp=12*monthlyexp
egen hh_exp=rowtotal(monthlyexp ex5-ex9), missing

g pcexpend=hh_exp/hc1

drop monthlyexp hh_exp hc1 ex5-ex9

*TO DO: change path to where you saved the following file "TTHAI15.dta"
/*EXAMPLE:*/
merge 1:m newid using TTHAI15, nogenerate
/**/

*Exchange rate for approximate midpoint of survey period
/*There is no documentation for the 2011 survey round but I assume that for this round
 wthe data was also collected in May, so I use May 15 as approximate midpoint for the exchange rate*/

g excrate=0.03249

g excratemonth="5-2011"


foreach var of varlist ownerage ownertertiary educyears married childunder5 childaged5to12 adult65andover wageworker laborincome retired sales reasonforclosure wave surveyyear hhbusclosure typeofbusclosed hhbus enf_bus newfirmquex tbdropped nonfarm typeofbus retail manuf services othersector agefirm employees totalworkers expenses profits hhbusowner totalowners jointbus pcexpend excrate*{ 
rename `var' `var'_2011
} 

rename number hc_id

*TO DO: decide whether you need/want to change path for saving "TTHAI15.dta"
/**/
save TTHAI15, replace
/**/

********************************************************************************
*Round 15 - Urban sample
********************************************************************************
*TO DO: change path to where you saved the following file "hh11_13ba.dta" of the 2011 annual household resurvey (urban sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2011/Urban/hh11_13ba.dta", clear
/**/

*Survey round number
g wave=15

*Year survey took place
g surveyyear=2011

*Business closure in past 12 months
g hhbusclosure=(ba1a==1) if (ba1a==1 | ba1a==3) & ba1a!=.c

/*Although the questionnaire asks for reasons, the business was closed (question ba1c),
this variable is not in the dataset and also not in the codebook file*/
replace ba1b=. if ba1b==.c
g typeofbusclosed=ba1b

*I keep the open ended reasons for closure as for now to be able to decide later on appropriate coding
rename ba1c reasonforclosure

*Household operates a business
g hhbus=(ba1d==1) if ba1d!=.c

*TO DO: decide whether you need/want to change path for saving "TTHAI15u.dta"
/**/
save TTHAI15u, replace 
/**/

*TO DO: change path to where you saved the following file "hh11_13ba_tab1.dta" of the 2011 annual household resurvey (urban sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2011/Urban/hh11_13ba_tab1.dta", clear
/**/

/*Only keep the information for the first business as I will only consider businesses
 of households who have only one business:*/
keep if bnumber==1

*TO DO: change path to where you saved the following file "TTHAI15u.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI15u, nogenerate
/**/

*Household entirely owns household business
replace ba2=0 if hhbus==0

g enf_bus=(ba6==1) if ba6!=.

*Household entirely owns household business
*Business founded in last 12 months:
g newfirmquex=(ba21a==1) if ba21a!=.

/*I will only consider household enterprises if the household operates only one 
enterprise and if this enterprise is entirely owned by the household:*/
g tbdropped=(ba2>1) if ba2!=.c | enf_bus!=1

*Since the questionnaire mixes non-farm and farm enterprises:
g nonfarm=(ba3a==1 | ba3a==3 | ba3a==5 | ba3a==15 | ba3a==17 | ba3a==19) if hhbus==1 & ba3a!=.c

replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="10-wheels truck for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="6-wheels truck for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Bus service"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Chinese dining set"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Clothes making shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Construction contractor"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Electric appliance repairing shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Give tution"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Install car stereoes"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Install gutters"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Land filling contractor"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Laundry service"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Laundry service shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Let houses for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Let rooms for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Made of mosquito wire screen"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Make clothes"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Make dress"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Make wooden clocks"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Making interlockingblock for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Native handicrafts"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Peripheral side of the motorcycle"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Petrol station"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Printing shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Produce furnitures"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Produce grill doors"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Produce herb juice"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Purchase - sale of black crabs"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Ready-made food producer"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Repair electric appliances"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Ride a taxi-motorcycle"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Sale of motorcycles parts"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Sales of herbal medicines"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="School van"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Sew cloth"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Taxi"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Taxi-motorcycle"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Tea shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Thai (traditional) costume/dress for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="The prepaid mobile phone"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Tire sales"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Trade antiques"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Trading teak wood"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Tricycle for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Truck for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Van for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Vehicle care taking service"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Vehicle for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Wooden handicraft products"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="advertisement car"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="amulet frame shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="aquariums"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="bicycle repair"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="blackhole car"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="bladesmith"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="building houses for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="bus for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buying and selling small buddha images"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="car accessory shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="car pad making shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="car painting"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="cesspool drainage"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="coin-inserted fuel filler"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="cook sweet tamarine"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="curtain making"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="deliver vegetables"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="dormitory/student hostel"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="dress maker"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="dress making shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="electrician"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="fixing glasses and aluminum"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="furniture shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="games and internet caf?"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="gas shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="glass panel set up"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="hired motercycle and hired pick-up car"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="hired tricycle"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="ice producing shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="iron smith"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="iron welder"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="iron welding garage"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="karaoke shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="laundry"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making food for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making stove for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="mobile phone accessory shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="motorcycle for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="motorcycle repair shop and spare parts shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="motorcycle with side trailer"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="pharmacy"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="phone repairing"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="recording commercial spots"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="rented book shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="repair and sell motorcycle parts"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of Mho Hom cloth(sale of Mho Hom cloth(a kind of local cloth)"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of Tea"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of boiled nuts"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of ice-cream"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sale of no-mai-dong (fermented bamboo shoot)"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sculture maker"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell and repair watches"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell baked clay pottery"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell coffin"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell electric appliances"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell junks"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell local foods"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell toys"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="selling auto parts"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="selling used cars"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="showing movies in open air theatre"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="slaughterhouse"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="snooker table"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to cook sweets"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to do iron making for robber prevention"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to do laundry"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to repair air condition"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="traditional massage"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="traditional medicines shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="tricycle for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="unbrellas and chairs for rent"

replace hhbus=0 if nonfarm==0
replace hhbus=. if nonfarm==. & hhbus!=0

*Type of business
replace ba3a=. if ba3a==.c
g typeofbus=ba3a if hhbus==1

*Sector of the firm:
*Firm is in retail trade
g retail=(ba3a==1 | ba3a==17) if hhbus==1
replace retail=1 if hhbus==1 & ba3a==21 & (ba3ao2=="Petrol station" | ba3ao2=="Purchase - sale of black crabs" | ba3ao2=="Sale of motorcycles parts" | ba3ao2=="Tire sales" | ba3ao2=="Trade antiques" | ba3ao2=="Trading teak wood" | ba3ao2=="buying and selling small buddha images" | ba3ao2=="car accessory shop" | ba3ao2=="furniture shop" | ba3ao2=="gas shop" | ba3ao2=="mobile phone accessory shop" | ba3ao2=="sale of Mho Hom cloth(sale of Mho Hom cloth(a kind of local cloth)" | ba3ao2=="sell and repair watches" | ba3ao2=="sell coffin" | ba3ao2=="sell electric appliances" |  ba3ao2=="sell toys" | ba3ao2=="selling auto parts" | ba3ao2=="selling used cars")

*Firm is in manufacturing sector
g manuf=(ba3a==21 & (ba3ao2=="Clothes making shop" | ba3ao2=="Make clothes" | ba3ao2=="Make dress" | ba3ao2=="Make wooden clocks" | ba3ao2=="Making interlockingblock for sale" | ba3ao2=="Produce furnitures" | ba3ao2=="Produce grill doors" | ba3ao2=="Produce herb juice" | ba3ao2=="Sew cloth" | ba3ao2=="bladesmith" | ba3ao2=="curtain making" |  ba3ao2=="dress maker" | ba3ao2=="dress making shop" | ba3ao2=="iron smith" | ba3ao2=="iron welder" | ba3ao2=="iron welding garage" | ba3ao2=="making stove for sale" | ba3ao2=="sculture maker" | ba3ao2=="slaughterhouse" | ba3ao2=="to do iron making for robber prevention")) if hhbus==1  
 
*Firm is in service sector
g services=(ba3a==3 | ba3a==5 | ba3a==15 | ba3a==19) if hhbus==1
replace services=1 if hhbus==1 & ba3a==21 & (ba3ao2=="10-wheels truck for hire" | ba3ao2=="6-wheels truck for hire" | ba3ao2=="Bus service" | ba3ao2=="Electric appliance repairing shop" | ba3ao2=="Give tution" | ba3ao2=="Laundry service" | ba3ao2=="Laundry service shop" | ba3ao2=="Let houses for rent" | ba3ao2=="Let rooms for rent" | ba3ao2=="Printing shop" | ba3ao2=="Ready-made food producer" | ba3ao2=="Repair electric appliances" | ba3ao2=="Ride a taxi-motorcycle" | ba3ao2=="School van" | ba3ao2=="Taxi" | ba3ao2=="Taxi-motorcycle" | ba3ao2=="Tea shop" | ba3ao2=="Thai (traditional) costume/dress for rent" | ba3ao2=="Tricycle for hire" | ba3ao2=="Truck for hire" | ba3ao2=="Van for hire" | ba3ao2=="Vehicle care taking service" | ba3ao2=="Vehicle for hire" | ba3ao2=="advertisement car" | ba3ao2=="bicycle repair" | ba3ao2=="bus for hire" | ba3ao2=="cook sweet tamarine" | ba3ao2=="deliver vegetables" | ba3ao2=="dormitory/student hostel" | ba3ao2=="electrician" | ba3ao2=="games and internet caf?" | ba3ao2=="hired motercycle and hired pick-up car" | ba3ao2=="hired tricycle" | ba3ao2=="karaoke shop" | ba3ao2=="laundry" | ba3ao2=="making food for sale" | ba3ao2=="motorcycle for hire" | ba3ao2=="phone repairing" | ba3ao2=="recording commercial spots" | ba3ao2=="rented book shop" | ba3ao2=="sale of Tea" | ba3ao2=="sale of boiled nuts" | ba3ao2=="sale of ice-cream" | ba3ao2=="sale of no-mai-dong (fermented bamboo shoot)" | ba3ao2=="sell local foods" | ba3ao2=="showing movies in open air theatre" | ba3ao2=="snooker table" | ba3ao2=="to cook sweets" | ba3ao2=="to do laundry" | ba3ao2=="to repair air condition" | ba3ao2=="traditional massage" | ba3ao2=="tricycle for hire" | ba3ao2=="unbrellas and chairs for rent")

*Firm is in other sector
g othersector=(retail==0 & manuf==0 & services==0) if hhbus==1 

replace othersector=. if hhbus==1 & (ba3ao2=="Chinese dining set" | ba3ao2=="Made of mosquito wire screen" | ba3ao2=="Native handicrafts" | ba3ao2=="Peripheral side of the motorcycle" | ba3ao2=="Sales of herbal medicines" | ba3ao2=="The prepaid mobile phone" | ba3ao2=="Wooden handicraft products" | ba3ao2=="amulet frame shop" | ba3ao2=="aquariums" | ba3ao2=="blackhole car" | ba3ao2=="car pad making shop" | ba3ao2=="coin-inserted fuel filler" | ba3ao2=="fixing glasses and aluminum" | ba3ao2=="glass panel set up" | ba3ao2=="motorcycle with side trailer" | ba3ao2=="sale of Tea" | ba3ao2=="sell junks" | ba3ao2=="traditional medicines shop")
replace services=. if hhbus==1 & (ba3ao2=="Chinese dining set" | ba3ao2=="Made of mosquito wire screen" | ba3ao2=="Native handicrafts" | ba3ao2=="Peripheral side of the motorcycle" | ba3ao2=="Sales of herbal medicines" | ba3ao2=="The prepaid mobile phone" | ba3ao2=="Wooden handicraft products" | ba3ao2=="amulet frame shop" | ba3ao2=="aquariums" | ba3ao2=="blackhole car" | ba3ao2=="car pad making shop" | ba3ao2=="coin-inserted fuel filler" | ba3ao2=="fixing glasses and aluminum" | ba3ao2=="glass panel set up" | ba3ao2=="motorcycle with side trailer" | ba3ao2=="sale of Tea" | ba3ao2=="sell junks" | ba3ao2=="traditional medicines shop")
replace manuf=. if hhbus==1 & (ba3ao2=="Chinese dining set" | ba3ao2=="Made of mosquito wire screen" | ba3ao2=="Native handicrafts" | ba3ao2=="Peripheral side of the motorcycle" | ba3ao2=="Sales of herbal medicines" | ba3ao2=="The prepaid mobile phone" | ba3ao2=="Wooden handicraft products" | ba3ao2=="amulet frame shop" | ba3ao2=="aquariums" | ba3ao2=="blackhole car" | ba3ao2=="car pad making shop" | ba3ao2=="coin-inserted fuel filler" | ba3ao2=="fixing glasses and aluminum" | ba3ao2=="glass panel set up" | ba3ao2=="motorcycle with side trailer" | ba3ao2=="sale of Tea" | ba3ao2=="sell junks" | ba3ao2=="traditional medicines shop")
replace retail=. if hhbus==1 & (ba3ao2=="Chinese dining set" | ba3ao2=="Made of mosquito wire screen" | ba3ao2=="Native handicrafts" | ba3ao2=="Peripheral side of the motorcycle" | ba3ao2=="Sales of herbal medicines" | ba3ao2=="The prepaid mobile phone" | ba3ao2=="Wooden handicraft products" | ba3ao2=="amulet frame shop" | ba3ao2=="aquariums" | ba3ao2=="blackhole car" | ba3ao2=="car pad making shop" | ba3ao2=="coin-inserted fuel filler" | ba3ao2=="fixing glasses and aluminum" | ba3ao2=="glass panel set up" | ba3ao2=="motorcycle with side trailer" | ba3ao2=="sale of Tea" | ba3ao2=="sell junks" | ba3ao2=="traditional medicines shop")


*Age of the firm in years
g agefirm=ba4 if hhbus==1 

*Number of paid employees
replace ba12=. if ba12==.b | ba12==.c
g employees=ba12 if hhbus==1

replace ba9=. if ba9==.b
g totalworkers=ba9 if hhbus==1 

keep newid reasonforclosure wave-totalworkers

*TO DO: decide whether you need/want to change path for saving "TTHAI15u.dta"
/**/
save TTHAI15u, replace
/**/

*TO DO: change path to where you saved the following file "hh11_16in_tab1.dta" of the 2011 annual household resurvey (urban sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2011/Urban/hh11_16in_tab1.dta", clear
/**/

*Business sales in last month
keep if number=="N" | number=="O" | number=="P" | number=="Q" | number=="R" | number=="S" | number=="U" | number=="AA"
replace in4=0 if in2==3
bysort newid: egen sales=total(in4), m
*Since sales are given for past 12 months:
replace sales=sales/12

keep newid sales
duplicates drop

*TO DO: change path to where you saved the following file "TTHAI15u.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI15u, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving "TTHAI15u.dta"
/**/
save TTHAI15u, replace
/**/

*TO DO: change path to where you saved the following file "hh11_16in.dta" of the 2011 annual household resurvey (urban sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2011/Urban/hh11_16in.dta", clear
/**/

g expenses=in10b/12 

keep newid expenses

*TO DO: change path to where you saved the following file "TTHAI15u.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI15u, nogenerate
/**/

g profits=sales-expenses if hhbus==1

*TO DO: decide whether you need/want to change path for saving "TTHAI15u.dta"
/**/
save TTHAI15u, replace
/**/


*TO DO: change path to where you saved the following file "hh11_01cvr.dta" of the 2011 annual household resurvey (urban sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2011/Urban/hh11_01cvr.dta", clear
/**/

*Marital status of owner
*Since the marital status is only given for household heads, I can only compute it for head and their spouses
g help=1 if cvr7==1 | cvr7==3 
g married=(cvr11==3) if help==1 & cvr11!=-8
drop help

keep newid married

*TO DO: change path to where you saved the following file "TTHAI15u.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI15u, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving "TTHAI15u.dta"
/**/
save TTHAI15u, replace
/**/

*TO DO: change path to where you saved the following file "hh11_04hc_tab1.dta" of the 2011 annual household resurvey (urban sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2011/Urban/hh11_04hc_tab1.dta", clear
/**/

*Age of owner
g ownerage=hc5

*Gender of owner
g female=(hc4==3) if hc4!=.

*Education of owner
g ownertertiary=(hc7==47 | hc7==49 | hc7==51 | hc7==53) if hc7!=. & hc7!=-999 & hc7!=-888

*Years of education
*I assume the number is the years of education and calculate 6 years for primary and 6 years for secondary
*Sources: 	https://en.wikipedia.org/wiki/Education_in_Thailand
*			http://open_jicareport.jica.go.jp/pdf/11548013.pdf
g educyears=0 if hc7==1 | hc7==3 | hc7==5 | hc7==7 | hc7==9
replace educyears=1 if hc7==11
replace educyears=2 if hc7==13
replace educyears=3 if hc7==15
replace educyears=4 if hc7==17
replace educyears=5 if hc7==19
replace educyears=6 if hc7==21
replace educyears=7 if hc7==23
replace educyears=7 if hc7==25
replace educyears=8 if hc7==27
replace educyears=9 if hc7==29
replace educyears=10 if hc7==31 | hc7==41
replace educyears=11 if hc7==33 | hc7==43
replace educyears=12 if hc7==35 | hc7==45
replace educyears=13 if hc7==37 | hc7==47 | hc7==51 | hc7==55
replace educyears=14 if hc7==39 | hc7==49 | hc7==53 | hc7==57
replace educyears=15 if hc7==59
replace educyears=16 if hc7==61

*Child under 5 in household
g under5=0
replace under5=. if hc5==. 
replace under5=1 if hc5<5 
bysort newid: egen childunder5=max(under5)
drop under5

*Child aged 5 to 12 in household
g aged5to12=0
replace aged5to12=. if  hc5==. 
replace aged5to12=1 if  hc5>=5 &  hc5<12
bysort newid: egen childaged5to12=max(aged5to12)
drop aged5to12

*Has adult aged 65+ in the household
g is65orover=0
replace is65orover=. if hc5==. 
replace is65orover=1 if hc5>=65 & hc5!=. 
bysort newid: egen adult65andover=max(is65orover)
drop is65orover

*TO DO: change path to where you saved the following file "hh11_05oc_tab1.dta" of the 2011 annual household resurvey (urban sample)
/*EXAMPLE:*/
merge 1:1 newid number using "Townsend Thai Project/2011/Urban/hh11_05oc_tab1.dta", nogenerate
/**/

g businessowner=(oc1b==1) if oc1b!=. & oc1b!=.c 

/*I code individuals as wage workers if the type of employment reported is either:
 - employee - daily wages, or
 - employee - monthly wages, or
 - government worker.
 I do not consider individuals to be wage workers if the type of employment reported is either:
 - owner of business, or
 - unpaid family worker, or
 - employee - piece rate, in house, or
 - employee - piece rate, out of house, or
 - other.
*/

*Worked as wage worker in last month
g wageworker=(oc1b==5 | oc1b==7 | oc1b==13) if oc1b!=.

*Labor earnings in last month
*Replace missing values:
g laborincome=oc1c if oc1b==7 | oc1b==13
*For government workers it is not clear if the wages are given on a daily or monthly frequency, but I assume from the values that they are monthly
*In case wages are given for a daily frequency, I multiply them with 20 to have monthly wages:
replace laborincome=oc1c*20 if oc1b==5

*Retired
g retired=(oc1a==1) if  oc1a!=.

keep newid number ownerage-adult65andover businessowner wageworker laborincome retired

*TO DO: change path to where you saved the following file "TTHAI15u.dta"
/*EXAMPLE:*/
merge m:1 newid using TTHAI15u, nogenerate 
/**/

g hhbusowner=(businessowner==1) if hhbus==1 & businessowner!=.

drop businessowner

duplicates tag newid hhbusowner if hhbus==1 & hhbusowner==1, gen(totalowners)
replace totalowners=totalowners+1

g jointbus=(totalowners>1) if hhbus==1 & totalowners!=.

*TO DO: decide whether you need/want to change path for saving "TTHAI15u.dta"
/**/
save TTHAI15u, replace
/**/

*Household consumption
*TO DO: change path to where you saved the following file "hh11_04hc.dta" of the 2011 annual household resurvey (urban sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2011/Urban/hh11_04hc.dta", clear
/**/

keep newid hc1

*TO DO: change path to where you saved the following file "hh11_15ex.dta" of the 2011 annual household resurvey (urban sample)
/*EXAMPLE:*/
merge 1:1 newid using "Townsend Thai Project/2011/Urban/hh11_15ex.dta", nogenerate
/**/

*TO DO: change path to where you saved the following file "hh11_15ex_tab1.dta" of the 2011 annual household resurvey (urban sample)
/*EXAMPLE:*/
merge 1:m newid using "Townsend Thai Project/2011/Urban/hh11_15ex_tab1.dta", nogenerate
/**/

replace ex4=. if ex4==.b | ex4==.c | ex4==.y

bysort newid: egen monthlyexp=total(ex4),m

keep newid monthlyexp hc1 ex5-ex9
duplicates drop

replace monthlyexp=12*monthlyexp
egen hh_exp=rowtotal(monthlyexp ex5-ex9), missing

g pcexpend=hh_exp/hc1

drop monthlyexp hh_exp hc1 ex5-ex9

*TO DO: change path to where you saved the following file "TTHAI15u.dta" 
/*EXAMPLE:*/
merge 1:m newid using TTHAI15u, nogenerate
/**/

*Exchange rate for approximate midpoint of survey period
/*There is no documentation for the 2011 survey round but I assume that for this round
 wthe data was also collected in May, so I use May 15 as approximate midpoint for the exchange rate*/

g excrate=0.03249

g excratemonth="5-2011"


foreach var of varlist ownerage ownertertiary educyears married childunder5 childaged5to12 adult65andover wageworker laborincome retired sales reasonforclosure wave surveyyear hhbusclosure typeofbusclosed hhbus enf_bus newfirmquex tbdropped nonfarm typeofbus retail manuf services othersector agefirm employees totalworkers expenses profits hhbusowner totalowners jointbus pcexpend excrate*{ 
rename `var' `var'_2011
} 

rename number hc_id

*TO DO: decide whether you need/want to change path for saving "TTHAI15u.dta"
/**/
save TTHAI15u, replace
/**/
********************************************************************************
*TO DO: change path to where you saved the following file "TTHAI15u.dta" 
/*EXAMPLE:*/
append using TTHAI15, gen(help)
/**/

*TO DO: decide whether you need/want to change path for saving "TTHAI15.dta"
/**/
save TTHAI15, replace
/**/

********************************************************************************
*TO DO: change path to where you saved the following file "TTHAImaster.dta" 
/*EXAMPLE:*/
use TTHAImaster,clear
/**/

*TO DO: change path to where you saved the following file "TTHAI15.dta" 
/*EXAMPLE:*/
merge 1:1 newid hc_id using TTHAI15, gen(_merge14) update
/**/

replace urban=1 if help==0 & urban==.
replace urban=0 if help==1 & urban==.
drop help

*TO DO: decide whether you need/want to change path for saving "TTHAImaster.dta"
/**/
save TTHAImaster, replace 
/**/

********************************************************************************
*Round 16 - Rural sample
********************************************************************************
*TO DO: change path to where you saved the following file "hh12_13ba.dta" of the 2012 annual household resurvey (rural sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2012/hh12_13ba.dta", clear
/**/

*Survey round number
g wave=16

*Year survey took place
g surveyyear=2012

*Business closure in past 12 months
g hhbusclosure=(ba1a==1) if (ba1a==1 | ba1a==3) & ba1a!=.c

/*Although the questionnaire asks for reasons, the business was closed (question ba1c),
this variable is not in the dataset and also not in the codebook file*/
replace ba1b=. if ba1b==.c
g typeofbusclosed=ba1b

*I keep the open ended reasons for closure as for now to be able to decide later on appropriate coding
rename ba1c reasonforclosure

*Household operates a business
g hhbus=(ba1d==1) if ba1d!=.c

*TO DO: decide whether you need/want to change path for saving "TTHAI16.dta"
/**/
save TTHAI16, replace 
/**/

*TO DO: change path to where you saved the following file "h12_13ba_tab1.dta" of the 2012 annual household resurvey (rural sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2012/hh12_13ba_tab1.dta", clear
/**/

/*Only keep the information for the first business as I will only consider businesses
 of households who have only one business:*/
keep if bnumber==1

*TO DO: change path to where you saved the following file "TTHAI16.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI16, nogenerate
/**/

*Household entirely owns household business
replace ba2=0 if hhbus==0

g enf_bus=(ba6==1) if ba6!=.

*Household entirely owns household business
*Business founded in last 12 months:
g newfirmquex=(ba21a==1) if ba21a!=.

/*I will only consider household enterprises if the household operates only one 
enterprise and if this enterprise is entirely owned by the household:*/
g tbdropped=(ba2>1) if ba2!=.c | enf_bus!=1

*Since the questionnaire mixes non-farm and farm enterprises:
g nonfarm=(ba3a==1 | ba3a==3 | ba3a==5 | ba3a==15 | ba3a==17 | ba3a==19) if hhbus==1 & ba3a!=.c

replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="10-wheels truck for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Construction contractor"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Let houses for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Let rooms for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Level lands for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Make clothes"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Make dolls"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Petrol station"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Photocopier shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Produce roman pillars"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Sew cloth"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Trade antiques"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Tricycle for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Truck for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Van for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Wooden handicraft products"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="band for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="building houses for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buy rubber woods"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buying and selling junks"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="car wash garage"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="commuting student car"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="construct frog pond"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="craftwork from coconut shells"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="drive 6-wheel truck"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="electric appliances and amplifier for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="embroidery"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="games shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="goods transporting truck for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="macro truck"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="make traditional medicines for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="make wreath frames"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making amulet plastic frames for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making blooms for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making steel roof for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="mend and change tyres for motorcycles"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="mend and repair clothes for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="motorcycle for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="paint car and pick-up car"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sew blankets for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sew doormat for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="shoes repair shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="snooker table"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="snooker table/s for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="tailor"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to repair cloth"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="traditional massage"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="transport soil and sand"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="transportation services for workers"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="truck for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="tube fuel station"

replace hhbus=0 if nonfarm==0
replace hhbus=. if nonfarm==. & hhbus!=0

*Type of business
g typeofbus=ba3a if hhbus==1

*Sector of the firm:
*Firm is in retail trade
g retail=(ba3a==1 | ba3a==17) if hhbus==1
replace retail=1 if hhbus==1 & ba3a==21 & (ba3ao2=="Petrol station" | ba3ao2=="Trade antiques" | ba3ao2=="tube fuel station")

*Firm is in manufacturing sector
g manuf=(ba3a==21 & (ba3ao2=="Make clothes" | ba3ao2=="Make dolls" | ba3ao2=="Produce roman pillars" | ba3ao2=="Sew cloth" | ba3ao2=="craftwork from coconut shells"  | ba3ao2=="embroidery" | ba3ao2=="make wreath frames" | ba3ao2=="making amulet plastic frames for hire" | ba3ao2=="making steel roof for hire" | ba3ao2=="sew blankets for sale" | ba3ao2=="sew doormat for sale" | ba3ao2=="tailor")) if hhbus==1  
   
*Firm is in service sector
g services=(ba3a==3 | ba3a==5 | ba3a==15 | ba3a==19) if hhbus==1
replace services=1 if hhbus==1 & ba3a==21 & (ba3ao2=="10-wheels truck for hire" | ba3ao2=="4-wheel tractor for hire" | ba3ao2=="Let houses for rent" | ba3ao2=="Let rooms for rent" | ba3ao2=="Photocopier shop" | ba3ao2=="Tricycle for hire" | ba3ao2=="Truck for hire" | ba3ao2=="Van for hire" | ba3ao2=="band for hire" |  ba3ao2=="car wash garage" | ba3ao2=="commuting student car" | ba3ao2=="drive 6-wheel truck" | ba3ao2=="electric appliances and amplifier for rent" | ba3ao2=="goods transporting truck for hire" |  ba3ao2=="macro truck" | ba3ao2=="mend and change tyres for motorcycles" | ba3ao2=="mend and repair clothes for hire" | ba3ao2=="motorcycle for hire" | ba3ao2=="paint car and pick-up car" |  ba3ao2=="shoes repair shop" | ba3ao2=="snooker table" | ba3ao2=="snooker table/s for rent" |  ba3ao2=="to repair cloth" | ba3ao2=="traditional massage" | ba3ao2=="transportation services for workers" | ba3ao2=="truck for rent")

*Firm is in other sector
g othersector=(retail==0 & manuf==0 & services==0) if hhbus==1 

replace othersector=. if hhbus==1 & (ba3ao2=="Wooden handicraft products" | ba3ao2=="buy rubber woods" | ba3ao2=="buying and selling junks" | ba3ao2=="games shop" | ba3ao2=="macro truck" | ba3ao2=="making blooms for sale")
replace services=. if hhbus==1 & (ba3ao2=="Wooden handicraft products" | ba3ao2=="buy rubber woods" | ba3ao2=="buying and selling junks" | ba3ao2=="games shop" | ba3ao2=="macro truck" | ba3ao2=="making blooms for sale")
replace manuf=. if hhbus==1 & (ba3ao2=="Wooden handicraft products" | ba3ao2=="buy rubber woods" | ba3ao2=="buying and selling junks" | ba3ao2=="games shop" | ba3ao2=="macro truck" | ba3ao2=="making blooms for sale")
replace retail=. if hhbus==1 & (ba3ao2=="Wooden handicraft products" | ba3ao2=="buy rubber woods" | ba3ao2=="buying and selling junks" | ba3ao2=="games shop" | ba3ao2=="macro truck" | ba3ao2=="making blooms for sale")

*Age of the firm in years
g agefirm=ba4 if hhbus==1 

*Number of paid employees
replace ba12=. if ba12==.b | ba12==.c
g employees=ba12 if hhbus==1

replace ba9=. if ba9==.b
g totalworkers=ba9 if hhbus==1 

keep newid reasonforclosure wave-totalworkers
*TO DO: decide whether you need/want to change path for saving "TTHAI16.dta"
/**/
save TTHAI16, replace
/**/

*TO DO: change path to where you saved the following file "hh12_16in_tab1.dta" of the 2012 annual household resurvey (rural sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2012/hh12_16in_tab1.dta", clear
/**/

*Business sales in last month
keep if number=="N" | number=="O" | number=="P" | number=="Q" | number=="R" | number=="S" | number=="U" | number=="AA"
replace in4=0 if in2==3
bysort newid: egen sales=total(in4), m
*Since sales are given for past 12 months:
replace sales=sales/12

keep newid sales
duplicates drop

*TO DO: change path to where you saved the following file "TTHAI16.dta" 
/*EXAMPLE:*/
merge 1:1 newid using TTHAI16, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving "TTHAI16.dta"
/**/
save TTHAI16, replace
/**/

*TO DO: change path to where you saved the following file "hh12_16in.dta" of the 2012 annual household resurvey (rural sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2012/hh12_16in.dta", clear
/**/

g expenses=in10b/12 

keep newid expenses

*TO DO: change path to where you saved the following file "TTHAI16.dta" 
/*EXAMPLE:*/
merge 1:1 newid using TTHAI16, nogenerate
/**/

g profits=sales-expenses if hhbus==1

*TO DO: decide whether you need/want to change path for saving "TTHAI16.dta"
/**/
save TTHAI16, replace
/**/

*TO DO: change path to where you saved the following file "hh12_01cvr.dta" of the 2012 annual household resurvey (rural sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2012/hh12_01cvr.dta", clear
/**/

*Marital status of owner
*Since the marital status is only given for household heads, I can only compute it for head and their spouses
g help=1 if cvr7==1 | cvr7==3 
g married=(cvr11==3) if help==1 & cvr11!=-8
drop help

keep newid married

*TO DO: change path to where you saved the following file "TTHAI16.dta" 
/*EXAMPLE:*/
merge 1:1 newid using TTHAI16, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving "TTHAI16.dta"
/**/
save TTHAI16, replace
/**/

*TO DO: change path to where you saved the following file "hh12_04hc_tab1.dta" of the 2012 annual household resurvey (rural sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2012/hh12_04hc_tab1.dta", clear
/**/

*Age of owner
g ownerage=hc5

*Gender of owner
g female=(hc4==3) if hc4!=.

*Education of owner
g ownertertiary=(hc7==47 | hc7==49 | hc7==51 | hc7==53) if hc7!=. & hc7!=-999 & hc7!=-888

*Years of education
*I assume the number is the years of education and calculate 6 years for primary and 6 years for secondary
*Sources: 	https://en.wikipedia.org/wiki/Education_in_Thailand
*			http://open_jicareport.jica.go.jp/pdf/11548013.pdf
g educyears=0 if hc7==1 | hc7==3 | hc7==5 | hc7==7 | hc7==9
replace educyears=1 if hc7==11
replace educyears=2 if hc7==13
replace educyears=3 if hc7==15
replace educyears=4 if hc7==17
replace educyears=5 if hc7==19
replace educyears=6 if hc7==21
replace educyears=7 if hc7==23
replace educyears=7 if hc7==25
replace educyears=8 if hc7==27
replace educyears=9 if hc7==29
replace educyears=10 if hc7==31 | hc7==41
replace educyears=11 if hc7==33 | hc7==43
replace educyears=12 if hc7==35 | hc7==45
replace educyears=13 if hc7==37 | hc7==47 | hc7==51 | hc7==55
replace educyears=14 if hc7==39 | hc7==49 | hc7==53 | hc7==57
replace educyears=15 if hc7==59
replace educyears=16 if hc7==61

*Child under 5 in household
g under5=0
replace under5=. if hc5==. 
replace under5=1 if hc5<5 
bysort newid: egen childunder5=max(under5)
drop under5

*Child aged 5 to 12 in household
g aged5to12=0
replace aged5to12=. if  hc5==. 
replace aged5to12=1 if  hc5>=5 &  hc5<12
bysort newid: egen childaged5to12=max(aged5to12)
drop aged5to12

*Has adult aged 65+ in the household
g is65orover=0
replace is65orover=. if hc5==. 
replace is65orover=1 if hc5>=65 & hc5!=. 
bysort newid: egen adult65andover=max(is65orover)
drop is65orover

*TO DO: change path to where you saved the following file "hh12_05oc_tab1.dta" of the 2012 annual household resurvey (rural sample)
/*EXAMPLE:*/
merge 1:1 newid number using "Townsend Thai Project/2012/hh12_05oc_tab1.dta", nogenerate
/**/

g businessowner=(oc1b==1) if oc1b!=. & oc1b!=.c 

/*I code individuals as wage workers if the type of employment reported is either:
 - employee - daily wages, or
 - employee - monthly wages, or
 - government worker.
 I do not consider individuals to be wage workers if the type of employment reported is either:
 - owner of business, or
 - unpaid family worker, or
 - employee - piece rate, in house, or
 - employee - piece rate, out of house, or
 - other.
*/

*Worked as wage worker in last month
g wageworker=(oc1b==5 | oc1b==7 | oc1b==13) if oc1b!=. & oc1b!=.c 

*Labor earnings in last month
*Replace missing values:
g laborincome=oc1c if oc1b==7 | oc1b==13
*For government workers it is not clear if the wages are given on a daily or monthly frequency, but I assume from the values that they are monthly
*In case wages are given for a daily frequency, I multiply them with 20 to have monthly wages:
replace laborincome=oc1c*20 if oc1b==5

*Retired
g retired=(oc1a==1) if  oc1a!=.

keep newid number ownerage-adult65andover businessowner wageworker laborincome retired

*TO DO: change path to where you saved the following file "TTHAI16.dta" 
/*EXAMPLE:*/
merge m:1 newid using TTHAI16, nogenerate 
/**/

g hhbusowner=(businessowner==1) if hhbus==1 & businessowner!=.

drop businessowner

duplicates tag newid hhbusowner if hhbus==1 & hhbusowner==1, gen(totalowners)
replace totalowners=totalowners+1

g jointbus=(totalowners>1) if hhbus==1 & totalowners!=.

*TO DO: decide whether you need/want to change path for saving "TTHAI16.dta"
/**/
save TTHAI16, replace
/**/

*Household consumption
*TO DO: change path to where you saved the following file "hh12_04hc.dta" of the 2012 annual household resurvey (rural sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2012/hh12_04hc.dta", clear
/**/
keep newid hc1

*TO DO: change path to where you saved the following file "hh12_15ex.dta" of the 2012 annual household resurvey (rural sample)
/*EXAMPLE:*/
merge 1:1 newid using "Townsend Thai Project/2012/hh12_15ex.dta", nogenerate
/**/

*TO DO: change path to where you saved the following file "hh12_15ex_tab1.dta" of the 2012 annual household resurvey (rural sample)
/*EXAMPLE:*/
merge 1:m newid using "Townsend Thai Project/2012/hh12_15ex_tab1.dta", nogenerate
/**/

replace ex4=. if ex4==.b | ex4==.c | ex4==.y

bysort newid: egen monthlyexp=total(ex4),m

keep newid monthlyexp hc1 ex5-ex9
duplicates drop

replace monthlyexp=12*monthlyexp
egen hh_exp=rowtotal(monthlyexp ex5-ex9), missing

g pcexpend=hh_exp/hc1

drop monthlyexp hh_exp hc1 ex5-ex9

*TO DO: change path to where you saved the following file "TTHAI16.dta"
/*EXAMPLE:*/
merge 1:m newid using TTHAI16, nogenerate
/**/

*Exchange rate for approximate midpoint of survey period
/*There is no documentation for the 2012 survey round but I assume that for this round
 the data was also collected in May, so I use May 15 as approximate midpoint for the exchange rate*/

g excrate=0.03194

g excratemonth="5-2012"


foreach var of varlist ownerage ownertertiary educyears married childunder5 childaged5to12 adult65andover wageworker laborincome retired sales reasonforclosure wave surveyyear hhbusclosure typeofbusclosed hhbus enf_bus newfirmquex tbdropped nonfarm typeofbus retail manuf services othersector agefirm employees totalworkers expenses profits hhbusowner totalowners jointbus pcexpend excrate*{ 
rename `var' `var'_2012
} 

rename number hc_id

*TO DO: decide whether you need/want to change path for saving "TTHAI16.dta"
/**/
save TTHAI16, replace
/**/

********************************************************************************
*Round 16 - Urban sample
********************************************************************************
*TO DO: change path to where you saved the following file "hh12_13ba.dta" of the 2012 annual household resurvey (urban sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2012/Urban/hh12_13ba.dta", clear
/**/

*Survey round number
g wave=16

*Year survey took place
g surveyyear=2012

*Business closure in past 12 months
g hhbusclosure=(ba1a==1) if (ba1a==1 | ba1a==3) & ba1a!=.c

/*Although the questionnaire asks for reasons, the business was closed (question ba1c),
this variable is not in the dataset and also not in the codebook file*/
replace ba1b=. if ba1b==.c
g typeofbusclosed=ba1b

*I keep the open ended reasons for closure as for now to be able to decide later on appropriate coding
rename ba1c reasonforclosure

*Household operates a business
g hhbus=(ba1d==1) if ba1d!=.c

*TO DO: decide whether you need/want to change path for saving "TTHAI16u"
/**/
save TTHAI16u, replace 
/**/

*TO DO: change path to where you saved the following file "hh12_13ba_tab1.dta" of the 2012 annual household resurvey (urban sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2012/Urban/hh12_13ba_tab1.dta", clear
/**/

/*Only keep the information for the first business as I will only consider businesses
 of households who have only one business:*/
keep if bnumber==1

*TO DO: change path to where you saved the following file "TTHAI16u"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI16u, nogenerate
/**/

*Household entirely owns household business
replace ba2=0 if hhbus==0

g enf_bus=(ba6==1) if ba6!=.

*Household entirely owns household business
*Business founded in last 12 months:
g newfirmquex=(ba21a==1) if ba21a!=.

/*I will only consider household enterprises if the household operates only one 
enterprise and if this enterprise is entirely owned by the household:*/
g tbdropped=(ba2>1) if ba2!=.c | enf_bus!=1

*Since the questionnaire mixes non-farm and farm enterprises:
g nonfarm=(ba3a==1 | ba3a==3 | ba3a==5 | ba3a==15 | ba3a==17 | ba3a==19) if hhbus==1 & ba3a!=.c

replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="10-wheel truck for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="6-wheel car for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Thai costumes for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="advertisement car"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="aquarium"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="backhoe tractor"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="blacksmith"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="bus for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buy junks"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buy used oil"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buy-sell betel nuts and phlu leaves"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buy-sell buddha images"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buy-sell para rubber wood"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="car accessory shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="car for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="car parking"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="car seat shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="chinese dinner table arrangement"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="clothes making shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="coating buddha images"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="commuting car for students"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="computer repair shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="construction sub-contractor"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="cook foods for delivery"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="cooking gas shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="digging soil for land filling"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="dormitory"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="drain cesspool for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="drive car for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="drive car to deliver vegetables in the market"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="fill up mobile phones"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="furnitures shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="games and internet services shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="handicrafts made from coconut shells"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="hotel"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="house for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="icehouse"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="install car amplifier"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="install glasses"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="install glasses and aluminum"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="install gutters"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="install trailer for motorcycle"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="iron welder"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="karaoke shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="laundry"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="laundry for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="laundry shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="make Roman poles"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="make bricks for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="make chacoal stove"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="make curved steel"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="make curved steel door"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="make furnitures"
replace nonfarm=. if hhbus==1 & ba3a==21 & ba3ao2=="make kha nom"
replace nonfarm=. if hhbus==1 & ba3a==21 & ba3ao2=="make kha nom Thai"
replace nonfarm=. if hhbus==1 & ba3a==21 & ba3ao2=="make kha nom for delivery"
replace nonfarm=. if hhbus==1 & ba3a==21 & ba3ao2=="make kha nom for sale"
replace nonfarm=. if hhbus==1 & ba3a==21 & ba3ao2=="make ma kham kaeo"
replace nonfarm=. if hhbus==1 & ba3a==21 & ba3ao2=="make ruan than for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="make sam rong juice"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="make steel door"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="make steel sheets"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="make wooden clocks"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="make wooden furnitures"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="motorcycle and pick-up car for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="motorcycle for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="motorcycle with sided trailer for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="open-air movie showing"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="paint pick up car"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="parts for cars and motorcycles shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="printing house"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="record commercial spot"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="repair and instal air conditioner"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="repair and sell motorcycle parts"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="repair electric appliances"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="repair engines"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="repair phones"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="room for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell a la carte"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell and repair watches"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell car parts"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell car tyres"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell coffins"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell earthenwares"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell electric appliances / equipments"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell furnitures"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell gifts and souvenirs"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell herbal medicines"
replace nonfarm=. if hhbus==1 & ba3a==21 & ba3ao2=="sell khao man kai"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell local foods"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell motorcycle parts"
replace nonfarm=. if hhbus==1 & ba3a==21 & ba3ao2=="sell mu sa te"
replace nonfarm=. if hhbus==1 & ba3a==21 & ba3ao2=="sell mu wan"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell ornaments"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell seafoods"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell soft drinks"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell sushi"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell take-home curries"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell toys"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell used cars"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sewing"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sewing clothes"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sewing curtains"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="snooker table"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="tailor"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="tailor shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="traditional massage"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="traditional medicines shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="tricycle for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="umbrellas - chairs for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="van for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="welding shop"

replace hhbus=0 if nonfarm==0
replace hhbus=. if nonfarm==. & hhbus!=0

*Type of business
replace ba3a=. if ba3a==.c
g typeofbus=ba3a if hhbus==1

*Sector of the firm:
*Firm is in retail trade
g retail=(ba3a==1 | ba3a==17) if hhbus==1
replace retail=1 if hhbus==1 & ba3a==21 & (ba3ao2=="buy-sell betel nuts and phlu leaves" | ba3ao2=="buy-sell buddha images" | ba3ao2=="buy-sell para rubber wood" | ba3ao2=="car accessory shop" | ba3ao2=="car seat shop" | ba3ao2=="cooking gas shop" | ba3ao2=="fill up mobile phones" | ba3ao2=="furnitures shop" | ba3ao2=="parts for cars and motorcycles shop" | ba3ao2=="sell and repair watches" | ba3ao2=="sell car parts" | ba3ao2=="sell car tyres" | ba3ao2=="sell coffins" | ba3ao2=="sell earthenwares" | ba3ao2=="sell electric appliances / equipments" | ba3ao2=="sell furnitures" | ba3ao2=="sell gifts and souvenirs" | ba3ao2=="sell motorcycle parts" | ba3ao2=="sell ornaments" | ba3ao2=="sell toys" | ba3ao2=="sell used cars")

*Firm is in manufacturing sector
g manuf=(ba3a==21 & (ba3ao2=="blacksmith" | ba3ao2=="clothes making shop" | ba3ao2=="iron welder" | ba3ao2=="make Roman poles" | ba3ao2=="make bricks for sale" | ba3ao2=="make chacoal stove" | ba3ao2=="make curved steel" | ba3ao2=="make curved steel door" | ba3ao2=="make furnitures" | ba3ao2=="make steel door" | ba3ao2=="make steel sheets" | ba3ao2=="make wooden clocks" | ba3ao2=="make wooden furnitures" | ba3ao2=="sewing" | ba3ao2=="sewing clothes" | ba3ao2=="sewing curtains" | ba3ao2=="tailor" | ba3ao2=="tailor shop" | ba3ao2=="welding shop")) if hhbus==1  
 
*Firm is in service sector
g services=(ba3a==3 | ba3a==5 | ba3a==15 | ba3a==19) if hhbus==1
replace services=1 if hhbus==1 & ba3a==21 & (ba3ao2=="10-wheel truck for hire" | ba3ao2=="6-wheel car for hire" | ba3ao2=="Thai costumes for rent" | ba3ao2=="advertisement car" | ba3ao2=="bus for hire" | ba3ao2=="car for rent" | ba3ao2=="car parking" | ba3ao2=="commuting car for students" | ba3ao2=="computer repair shop" | ba3ao2=="cook foods for delivery" | ba3ao2=="dormitory" | ba3ao2=="drive car for hire" | ba3ao2=="drive car to deliver vegetables in the market" | ba3ao2=="games and internet services shop" | ba3ao2=="hotel" | ba3ao2=="house for rent" | ba3ao2=="laundry" | ba3ao2=="laundry for hire" | ba3ao2=="laundry shop" | ba3ao2=="motorcycle and pick-up car for hire" | ba3ao2=="motorcycle for hire" | ba3ao2=="motorcycle with sided trailer for hire" | ba3ao2=="open-air movie showing" | ba3ao2=="printing house" | ba3ao2=="record commercial spot" | ba3ao2=="repair and instal air conditioner" | ba3ao2=="repair electric appliances" | ba3ao2=="repair phones" | ba3ao2=="room for rent" | ba3ao2=="sell local foods" | ba3ao2=="sell sushi" | ba3ao2=="sell take-home curries" | ba3ao2=="snooker table" | ba3ao2=="traditional massage" | ba3ao2=="tricycle for hire" | ba3ao2=="umbrellas - chairs for rent" | ba3ao2=="van for hire")

*Firm is in other sector
g othersector=(retail==0 & manuf==0 & services==0) if hhbus==1 

replace othersector=. if hhbus==1 & (ba3ao2=="aquarium" | ba3ao2=="buy junks" | ba3ao2=="buy used oil" | ba3ao2=="chinese dinner table arrangement" | ba3ao2=="coating buddha images" | ba3ao2=="handicrafts made from coconut shells" | ba3ao2=="install glasses" | ba3ao2=="install glasses and aluminum" | ba3ao2=="paint pick up car" | ba3ao2=="sell a la carte" | ba3ao2=="sell herbal medicines" | ba3ao2=="sell seafoods" | ba3ao2=="sell soft drinks" | ba3ao2=="traditional medicines shop")
replace services=. if hhbus==1 & (ba3ao2=="aquarium" | ba3ao2=="buy junks" | ba3ao2=="buy used oil" | ba3ao2=="chinese dinner table arrangement" | ba3ao2=="coating buddha images" | ba3ao2=="handicrafts made from coconut shells" | ba3ao2=="install glasses" | ba3ao2=="install glasses and aluminum" | ba3ao2=="paint pick up car" | ba3ao2=="sell a la carte" | ba3ao2=="sell herbal medicines" | ba3ao2=="sell seafoods" | ba3ao2=="sell soft drinks" | ba3ao2=="traditional medicines shop")
replace manuf=. if hhbus==1 & (ba3ao2=="aquarium" | ba3ao2=="buy junks" | ba3ao2=="buy used oil" | ba3ao2=="chinese dinner table arrangement" | ba3ao2=="coating buddha images" | ba3ao2=="handicrafts made from coconut shells" | ba3ao2=="install glasses" | ba3ao2=="install glasses and aluminum" | ba3ao2=="paint pick up car" | ba3ao2=="sell a la carte" | ba3ao2=="sell herbal medicines" | ba3ao2=="sell seafoods" | ba3ao2=="sell soft drinks" | ba3ao2=="traditional medicines shop")
replace retail=. if hhbus==1 & (ba3ao2=="aquarium" | ba3ao2=="buy junks" | ba3ao2=="buy used oil" | ba3ao2=="chinese dinner table arrangement" | ba3ao2=="coating buddha images" | ba3ao2=="handicrafts made from coconut shells" | ba3ao2=="install glasses" | ba3ao2=="install glasses and aluminum" | ba3ao2=="paint pick up car" | ba3ao2=="sell a la carte" | ba3ao2=="sell herbal medicines" | ba3ao2=="sell seafoods" | ba3ao2=="sell soft drinks" | ba3ao2=="traditional medicines shop")


*Age of the firm in years
g agefirm=ba4 if hhbus==1 

*Number of paid employees
replace ba12=. if ba12==.b | ba12==.c
g employees=ba12 if hhbus==1

replace ba9=. if ba9==.b
g totalworkers=ba9 if hhbus==1 

keep newid reasonforclosure wave-totalworkers
*TO DO: decide whether you need/want to change path for saving "TTHAI16u"
/**/
save TTHAI16u, replace
/**/

*TO DO: change path to where you saved the following file "hh12_16in_tab1.dta" of the 2012 annual household resurvey (urban sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2012/Urban/hh12_16in_tab1.dta", clear
/**/

*Business sales in last month
keep if number=="N" | number=="O" | number=="P" | number=="Q" | number=="R" | number=="S" | number=="U" | number=="AA"
replace in4=0 if in2==3
bysort newid: egen sales=total(in4), m
*Since sales are given for past 12 months:
replace sales=sales/12

keep newid sales
duplicates drop

*TO DO: change path to where you saved the following file "TTHAI16u.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI16u, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving "TTHAI16u"
/**/
save TTHAI16u, replace
/**/

*TO DO: change path to where you saved the following file "hh12_16in.dta" of the 2012 annual household resurvey (urban sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2012/Urban/hh12_16in.dta", clear
/**/

g expenses=in10b/12 

keep newid expenses

*TO DO: change path to where you saved the following file "TTHAI16u.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI16u, nogenerate
/**/

g profits=sales-expenses if hhbus==1

*TO DO: decide whether you need/want to change path for saving "TTHAI16u"
/**/
save TTHAI16u, replace
/**/

*TO DO: change path to where you saved the following file "hh12_01cvr.dta" of the 2012 annual household resurvey (urban sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2012/Urban/hh12_01cvr.dta", clear
/**/

*Marital status of owner
*Since the marital status is only given for household heads, I can only compute it for head and their spouses
g help=1 if cvr7==1 | cvr7==3 
g married=(cvr11==3) if help==1 & cvr11!=-8
drop help

keep newid married

*TO DO: change path to where you saved the following file "TTHAI16u.dta" 
/*EXAMPLE:*/
merge 1:1 newid using TTHAI16u, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving "TTHAI16u"
/* */
save TTHAI16u, replace
/**/

*TO DO: change path to where you saved the following file "hh12_04hc_tab1.dta" of the 2012 annual household resurvey (urban sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2012/Urban/hh12_04hc_tab1.dta", clear
/**/

*Age of owner
g ownerage=hc5

*Gender of owner
g female=(hc4==3) if hc4!=.

*Education of owner
g ownertertiary=(hc7==47 | hc7==49 | hc7==51 | hc7==53) if hc7!=. & hc7!=-999 & hc7!=-888

*Years of education
*I assume the number is the years of education and calculate 6 years for primary and 6 years for secondary
*Sources: 	https://en.wikipedia.org/wiki/Education_in_Thailand
*			http://open_jicareport.jica.go.jp/pdf/11548013.pdf
g educyears=0 if hc7==1 | hc7==3 | hc7==5 | hc7==7 | hc7==9
replace educyears=1 if hc7==11
replace educyears=2 if hc7==13
replace educyears=3 if hc7==15
replace educyears=4 if hc7==17
replace educyears=5 if hc7==19
replace educyears=6 if hc7==21
replace educyears=7 if hc7==23
replace educyears=7 if hc7==25
replace educyears=8 if hc7==27
replace educyears=9 if hc7==29
replace educyears=10 if hc7==31 | hc7==41
replace educyears=11 if hc7==33 | hc7==43
replace educyears=12 if hc7==35 | hc7==45
replace educyears=13 if hc7==37 | hc7==47 | hc7==51 | hc7==55
replace educyears=14 if hc7==39 | hc7==49 | hc7==53 | hc7==57
replace educyears=15 if hc7==59
replace educyears=16 if hc7==61

*Child under 5 in household
g under5=0
replace under5=. if hc5==. 
replace under5=1 if hc5<5 
bysort newid: egen childunder5=max(under5)
drop under5

*Child aged 5 to 12 in household
g aged5to12=0
replace aged5to12=. if  hc5==. 
replace aged5to12=1 if  hc5>=5 &  hc5<12
bysort newid: egen childaged5to12=max(aged5to12)
drop aged5to12

*Has adult aged 65+ in the household
g is65orover=0
replace is65orover=. if hc5==. 
replace is65orover=1 if hc5>=65 & hc5!=. 
bysort newid: egen adult65andover=max(is65orover)
drop is65orover

*TO DO: change path to where you saved the following file "hh12_05oc_tab1.dta" of the 2012 annual household resurvey (urban sample)
/*EXAMPLE:*/
merge 1:1 newid number using "Townsend Thai Project/2012/Urban/hh12_05oc_tab1.dta", nogenerate
/**/

g businessowner=(oc1b==1) if oc1b!=. & oc1b!=.c 

/*I code individuals as wage workers if the type of employment reported is either:
 - employee - daily wages, or
 - employee - monthly wages, or
 - government worker.
 I do not consider individuals to be wage workers if the type of employment reported is either:
 - owner of business, or
 - unpaid family worker, or
 - employee - piece rate, in house, or
 - employee - piece rate, out of house, or
 - other.
*/

*Worked as wage worker in last month
g wageworker=(oc1b==5 | oc1b==7 | oc1b==13) if oc1b!=.

*Labor earnings in last month
*Replace missing values:
g laborincome=oc1c if oc1b==7 | oc1b==13
*For government workers it is not clear if the wages are given on a daily or monthly frequency, but I assume from the values that they are monthly
*In case wages are given for a daily frequency, I multiply them with 20 to have monthly wages:
replace laborincome=oc1c*20 if oc1b==5

*Retired
g retired=(oc1a==1) if  oc1a!=.

keep newid number ownerage-adult65andover businessowner wageworker laborincome retired

*TO DO: change path to where you saved the following file "TTHAI16u.dta"
/*EXAMPLE:*/
merge m:1 newid using TTHAI16u, nogenerate 
/**/

g hhbusowner=(businessowner==1) if hhbus==1 & businessowner!=.

drop businessowner

duplicates tag newid hhbusowner if hhbus==1 & hhbusowner==1, gen(totalowners)
replace totalowners=totalowners+1

g jointbus=(totalowners>1) if hhbus==1 & totalowners!=.

*TO DO: decide whether you need/want to change path for saving "TTHAI16u"
/* */
save TTHAI16u, replace
/**/

*Household consumption
*TO DO: change path to where you saved the following file "hh12_04hc.dta" of the 2012 annual household resurvey (urban sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2012/Urban/hh12_04hc.dta", clear
/**/
keep newid hc1

*TO DO: change path to where you saved the following file "hh12_15ex.dta" of the 2012 annual household resurvey (urban sample)
/*EXAMPLE:*/
merge 1:1 newid using "Townsend Thai Project/2012/Urban/hh12_15ex.dta", nogenerate
/**/

*TO DO: change path to where you saved the following file "hh12_15ex_tab1.dta" of the 2012 annual household resurvey (urban sample)
/*EXAMPLE:*/
merge 1:m newid using "Townsend Thai Project/2012/Urban/hh12_15ex_tab1.dta", nogenerate
/**/

replace ex4=. if ex4==.b | ex4==.c | ex4==.y

bysort newid: egen monthlyexp=total(ex4),m

keep newid monthlyexp hc1 ex5-ex9
duplicates drop

replace monthlyexp=12*monthlyexp
egen hh_exp=rowtotal(monthlyexp ex5-ex9), missing

g pcexpend=hh_exp/hc1

drop monthlyexp hh_exp hc1 ex5-ex9

*TO DO: change path to where you saved the following file "TTHAI16u.dta"
/*EXAMPLE:*/
merge 1:m newid using TTHAI16u, nogenerate
/**/

*Exchange rate for approximate midpoint of survey period
/*There is no documentation for the 2012 survey round but I assume that for this round
 wthe data was also collected in May, so I use May 15 as approximate midpoint for the exchange rate*/

g excrate=0.03194

g excratemonth="5-2012"


foreach var of varlist ownerage ownertertiary educyears married childunder5 childaged5to12 adult65andover wageworker laborincome retired sales reasonforclosure wave surveyyear hhbusclosure typeofbusclosed hhbus enf_bus newfirmquex tbdropped nonfarm typeofbus retail manuf services othersector agefirm employees totalworkers expenses profits hhbusowner totalowners jointbus pcexpend excrate*{ 
rename `var' `var'_2012
} 

rename number hc_id

*TO DO: decide whether you need/want to change path for saving "TTHAI16u"
/* */
save TTHAI16u, replace
/**/
********************************************************************************
*TO DO: change path to where you saved the following file "TTHAI16.dta"
/*EXAMPLE:*/
append using TTHAI16, gen(help)
/**/

*TO DO: decide whether you need/want to change path for saving "TTHAI16"
/* */
save TTHAI16, replace
/**/
********************************************************************************
*TO DO: change path to where you saved the following file "TTHAImaster.dta"
/*EXAMPLE:*/
use TTHAImaster,clear
/**/

*TO DO: change path to where you saved the following file "TTHAI16.dta"
/*EXAMPLE:*/
merge 1:1 newid hc_id using TTHAI16, gen(_merge15) update
/**/

replace urban=1 if help==0 & urban==.
replace urban=0 if help==1 & urban==.
drop help

*TO DO: decide whether you need/want to change path for saving "TTHAImaster"
/* */
save TTHAImaster, replace 
/**/
********************************************************************************
*Round 17 - Rural sample
********************************************************************************
*TO DO: change path to where you saved the following file "hh13_13ba.dta" of the 2013 annual household resurvey (rural sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2013/hh13_13ba.dta", clear
/**/

*Survey round number
g wave=17

*Year survey took place
g surveyyear=2013

*Business closure in past 12 months
g hhbusclosure=(ba1a==1) if (ba1a==1 | ba1a==3) & ba1a!=.c

/*Although the questionnaire asks for reasons, the business was closed (question ba1c),
this variable is not in the dataset and also not in the codebook file*/
replace ba1b=. if ba1b==.c
g typeofbusclosed=ba1b

*I keep the open ended reasons for closure as for now to be able to decide later on appropriate coding
rename ba1c reasonforclosure

*Household operates a business
g hhbus=(ba1d==1) if ba1d!=.c

*TO DO: decide whether you need/want to change path for saving "TTHAI17"
/* */
save TTHAI17, replace 
/**/

*TO DO: change path to where you saved the following file "hh13_13ba_tab1.dta" of the 2013 annual household resurvey (rural sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2013/hh13_13ba_tab1.dta", clear
/**/

/*Only keep the information for the first business as I will only consider businesses
 of households who have only one business:*/
keep if bnumber==1

*TO DO: change path to where you saved the following file "TTHAI17.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI17, nogenerate
/**/

*Household entirely owns household business
replace ba2=0 if hhbus==0

g enf_bus=(ba6==1) if ba6!=.

*Household entirely owns household business
*Business founded in last 12 months:
g newfirmquex=(ba21a==1) if ba21a!=.

/*I will only consider household enterprises if the household operates only one 
enterprise and if this enterprise is entirely owned by the household:*/
g tbdropped=(ba2>1) if ba2!=.c | enf_bus!=1

*Since the questionnaire mixes non-farm and farm enterprises:
g nonfarm=(ba3a==1 | ba3a==3 | ba3a==5 | ba3a==15 | ba3a==17 | ba3a==19) if hhbus==1 & ba3a!=.c

replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="10-wheels truck for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="4-wheel tractor for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="6-wheel tractor for hire"
*replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Burn wood to be charcoal for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Construction contractor"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Laundry service"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Let houses for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Let rooms for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Make clothes"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Make dolls"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Petrol station"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Photocopier shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Produce roman pillars"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Purchase rubber wood"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="School van"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Self service laundry"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Sew cloth"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Soils loading truck for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Trade antiques"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Tricycle for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Truck for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Van for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Vehicle for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Wooden handicraft products"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="amplifier for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="backhoe truck"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buying and selling junks"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buying fresh latex"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="car wash"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="colouring cars and pick-up"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="commuting van for workers"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="craftwork from coconut shells"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="cut cloths"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="drive 6-wheel truck"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="drive commuting car for students"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="drive commuting car for workers"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="embroidery"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="games shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="install iron and stainless for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="knitting socks for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="laundry"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="make amulet frames"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="make traditional medicines for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="make wreath frames"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making blooms for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making steel roof for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="ornamental flowers"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell nam phrik (chilli paste)"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell ready meals"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sew clothes for wholesale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sew doormats for sell"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sewing clothes for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="shoes repair shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="snooker table/s for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="tailor"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to repair cloth"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="traditional massage"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="transportation services for students"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="tube fuel station"

replace hhbus=0 if nonfarm==0
replace hhbus=. if nonfarm==. & hhbus!=0


*Type of business
g typeofbus=ba3a if hhbus==1

*Sector of the firm:
*Firm is in retail trade
g retail=(ba3a==1 | ba3a==17) if hhbus==1
replace retail=1 if hhbus==1 & ba3a==21 & (ba3ao2=="Petrol station" | ba3ao2=="Trade antiques" | ba3ao2=="tube fuel station")

*Firm is in manufacturing sector
g manuf=(ba3a==21 & (ba3ao2=="Make clothes" |  ba3ao2=="Make dolls" | ba3ao2=="Produce roman pillars" | ba3ao2=="Sew cloth" | ba3ao2=="craftwork from coconut shells" | ba3ao2=="embroidery" | ba3ao2=="knitting socks for sale" | ba3ao2=="make amulet frames" | ba3ao2=="make wreath frames" | ba3ao2=="making steel roof for hire" |  ba3ao2=="sew clothes for wholesale" | ba3ao2=="sew doormats for sell" | ba3ao2=="sewing clothes for sale" | ba3ao2=="tailor")) if hhbus==1  
 
*Firm is in service sector
g services=(ba3a==3 | ba3a==5 | ba3a==15 | ba3a==19) if hhbus==1
replace services=1 if hhbus==1 & ba3a==21 & (ba3ao2=="10-wheels truck for hire" | ba3ao2=="6-wheel tractor for hire" | ba3ao2=="Laundry service" | ba3ao2=="Let houses for rent" | ba3ao2=="Let rooms for rent" | ba3ao2=="Photocopier shop" | ba3ao2=="School van" | ba3ao2=="Self service laundry" | ba3ao2=="Tricycle for hire" | ba3ao2=="Truck for hire" | ba3ao2=="Van for hire" | ba3ao2=="Vehicle for hire" | ba3ao2=="amplifier for rent" | ba3ao2=="car wash" | ba3ao2=="colouring cars and pick-up" | ba3ao2=="commuting van for workers" | ba3ao2=="drive 6-wheel truck" | ba3ao2=="drive commuting car for students" | ba3ao2=="drive commuting car for workers" | ba3ao2=="laundry" | ba3ao2=="sell ready meals" | ba3ao2=="shoes repair shop" | ba3ao2=="snooker table/s for rent" | ba3ao2=="to repair cloth" | ba3ao2=="traditional massage" | ba3ao2=="transportation services for students")

*Firm is in other sector
g othersector=(retail==0 & manuf==0 & services==0) if hhbus==1 

replace othersector=. if hhbus==1 & (ba3ao2=="Purchase rubber wood" | ba3ao2=="Wooden handicraft products" | ba3ao2=="buying and selling junks" | ba3ao2=="buying fresh latex" | ba3ao2=="cut cloths" | ba3ao2=="games shop" | ba3ao2=="install iron and stainless for hire" | ba3ao2=="making blooms for sale" | ba3ao2=="sell nam phrik (chilli paste)")
replace services=. if hhbus==1 & (ba3ao2=="Purchase rubber wood" | ba3ao2=="Wooden handicraft products" | ba3ao2=="buying and selling junks" | ba3ao2=="buying fresh latex" | ba3ao2=="cut cloths" | ba3ao2=="games shop" | ba3ao2=="install iron and stainless for hire" | ba3ao2=="making blooms for sale" | ba3ao2=="sell nam phrik (chilli paste)")
replace manuf=. if hhbus==1 & (ba3ao2=="Purchase rubber wood" | ba3ao2=="Wooden handicraft products" | ba3ao2=="buying and selling junks" | ba3ao2=="buying fresh latex" | ba3ao2=="cut cloths" | ba3ao2=="games shop" | ba3ao2=="install iron and stainless for hire" | ba3ao2=="making blooms for sale" | ba3ao2=="sell nam phrik (chilli paste)")
replace retail=. if hhbus==1 & (ba3ao2=="Purchase rubber wood" | ba3ao2=="Wooden handicraft products" | ba3ao2=="buying and selling junks" | ba3ao2=="buying fresh latex" | ba3ao2=="cut cloths" | ba3ao2=="games shop" | ba3ao2=="install iron and stainless for hire" | ba3ao2=="making blooms for sale" | ba3ao2=="sell nam phrik (chilli paste)")

*Age of the firm in years
g agefirm=ba4 if hhbus==1 

*Number of paid employees
replace ba12=. if ba12==.b | ba12==.c
g employees=ba12 if hhbus==1

g totalworkers=ba9 if hhbus==1 

keep newid reasonforclosure wave-totalworkers
*TO DO: decide whether you need/want to change path for saving "TTHAI17"
/* */
save TTHAI17, replace
/**/

*TO DO: change path to where you saved the following file "hh13_16in_tab1.dta" of the 2013 annual household resurvey (rural sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2013/hh13_16in_tab1.dta", clear
/**/

*Business sales in last month
keep if number=="N" | number=="O" | number=="P" | number=="Q" | number=="R" | number=="S" | number=="U" | number=="AA"
replace in4=0 if in2==3
bysort newid: egen sales=total(in4), m
*Since sales are given for past 12 months:
replace sales=sales/12

keep newid sales
duplicates drop

*TO DO: change path to where you saved the following file "TTHAI17.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI17, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving "TTHAI17"
/* */
save TTHAI17, replace
/**/

*TO DO: change path to where you saved the following file "hh13_16in.dta.dta" of the 2013 annual household resurvey (rural sample)
/*EXAMPLE:*/
use "Townsend Thai Project/2013/hh13_16in.dta", clear
/**/

g expenses=in10b/12 

keep newid expenses

*TO DO: change path to where you saved the following file "TTHAI17.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI17, nogenerate
/**/

g profits=sales-expenses if hhbus==1

*TO DO: decide whether you need/want to change path for saving "TTHAI17"
/* */
save TTHAI17, replace
/**/

*TO DO: change path to where you saved the following file "hh13_01cvr.dta" of the 2013 annual household resurvey (rural sample)
/*EXAMPLE: */
use "Townsend Thai Project/2013/hh13_01cvr.dta", clear
/**/

*Marital status of owner
*Since the marital status is only given for household heads, I can only compute it for head and their spouses
g help=1 if cvr7==1 | cvr7==3 
g married=(cvr11==3) if help==1 & cvr11!=-8
drop help

keep newid married

*TO DO: change path to where you saved the following file "TTHAI17.dta"
/*EXAMPLE:*/
merge 1:1 newid using TTHAI17, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving "TTHAI17"
/* */
save TTHAI17, replace
/**/

*TO DO: change path to where you saved the following file "hh13_04hc_tab1.dta" of the 2013 annual household resurvey (rural sample)
/*EXAMPLE*/
use "Townsend Thai Project/2013/hh13_04hc_tab1.dta", clear
/**/

*Age of owner
g ownerage=hc5

*Gender of owner
g female=(hc4==3) if hc4!=.

*Education of owner
g ownertertiary=(hc7==47 | hc7==49 | hc7==51 | hc7==53) if hc7!=. & hc7!=-999 & hc7!=-888

*Years of education
*I assume the number is the years of education and calculate 6 years for primary and 6 years for secondary
*Sources: 	https://en.wikipedia.org/wiki/Education_in_Thailand
*			http://open_jicareport.jica.go.jp/pdf/11548013.pdf
g educyears=0 if hc7==1 | hc7==3 | hc7==5 | hc7==7 | hc7==9
replace educyears=1 if hc7==11
replace educyears=2 if hc7==13
replace educyears=3 if hc7==15
replace educyears=4 if hc7==17
replace educyears=5 if hc7==19
replace educyears=6 if hc7==21
replace educyears=7 if hc7==23
replace educyears=7 if hc7==25
replace educyears=8 if hc7==27
replace educyears=9 if hc7==29
replace educyears=10 if hc7==31 | hc7==41
replace educyears=11 if hc7==33 | hc7==43
replace educyears=12 if hc7==35 | hc7==45
replace educyears=13 if hc7==37 | hc7==47 | hc7==51 | hc7==55
replace educyears=14 if hc7==39 | hc7==49 | hc7==53 | hc7==57
replace educyears=15 if hc7==59
replace educyears=16 if hc7==61

*Child under 5 in household
g under5=0
replace under5=. if hc5==. 
replace under5=1 if hc5<5 
bysort newid: egen childunder5=max(under5)
drop under5

*Child aged 5 to 12 in household
g aged5to12=0
replace aged5to12=. if  hc5==. 
replace aged5to12=1 if  hc5>=5 &  hc5<12
bysort newid: egen childaged5to12=max(aged5to12)
drop aged5to12

*Has adult aged 65+ in the household
g is65orover=0
replace is65orover=. if hc5==. 
replace is65orover=1 if hc5>=65 & hc5!=. 
bysort newid: egen adult65andover=max(is65orover)
drop is65orover

*TO DO: change path to where you saved the following file "hh13_05oc_tab1.dta" of the 2013 annual household resurvey (rural sample)
/*EXAMPLE*/
merge 1:1 newid number using "Townsend Thai Project/2013/hh13_05oc_tab1.dta", nogenerate
/**/

g businessowner=(oc1b==1) if oc1b!=. & oc1b!=.c 

/*I code individuals as wage workers if the type of employment reported is either:
 - employee - daily wages, or
 - employee - monthly wages, or
 - government worker.
 I do not consider individuals to be wage workers if the type of employment reported is either:
 - owner of business, or
 - unpaid family worker, or
 - employee - piece rate, in house, or
 - employee - piece rate, out of house, or
 - other.
*/

*Worked as wage worker in last month
g wageworker=(oc1b==5 | oc1b==7 | oc1b==13) if oc1b!=. & oc1b!=.c 

*Labor earnings in last month
*Replace missing values:
g laborincome=oc1c if oc1b==7 | oc1b==13
*For government workers it is not clear if the wages are given on a daily or monthly frequency, but I assume from the values that they are monthly
*In case wages are given for a daily frequency, I multiply them with 20 to have monthly wages:
replace laborincome=oc1c*20 if oc1b==5

*Retired
g retired=(oc1a==1) if  oc1a!=.

keep newid number ownerage-adult65andover businessowner wageworker laborincome retired

*TO DO: change path to where you saved the following file "TTHAI17.dta"
/*EXAMPLE*/
merge m:1 newid using TTHAI17, nogenerate 
/**/

g hhbusowner=(businessowner==1) if hhbus==1 & businessowner!=.

drop businessowner

duplicates tag newid hhbusowner if hhbus==1 & hhbusowner==1, gen(totalowners)
replace totalowners=totalowners+1

g jointbus=(totalowners>1) if hhbus==1 & totalowners!=.

*TO DO: decide whether you need/want to change path for saving "TTHAI17"
/**/
save TTHAI17, replace
/**/

*Household consumption
*TO DO: change path to where you saved the following file "hh13_04hc.dta" of the 2013 annual household resurvey (rural sample)
/*EXAMPLE*/
use "Townsend Thai Project/2013/hh13_04hc.dta", clear
/**/
keep newid hc1

*TO DO: change path to where you saved the following file "hh13_15ex.dta" of the 2013 annual household resurvey (rural sample)
/*EXAMPLE*/
merge 1:1 newid using "Townsend Thai Project/2013/hh13_15ex.dta", nogenerate
/**/
*TO DO: change path to where you saved the following file "hh13_15ex_tab1.dta" of the 2013 annual household resurvey (rural sample)
/*EXAMPLE*/
merge 1:m newid using "Townsend Thai Project/2013/hh13_15ex_tab1.dta", nogenerate
/**/
replace ex4=. if ex4==.b | ex4==.c | ex4==.y

bysort newid: egen monthlyexp=total(ex4),m

keep newid monthlyexp hc1 ex5-ex9
duplicates drop

replace monthlyexp=12*monthlyexp
egen hh_exp=rowtotal(monthlyexp ex5-ex9), missing

g pcexpend=hh_exp/hc1

drop monthlyexp hh_exp hc1 ex5-ex9

*TO DO: change path to where you saved the following file "TTHAI17.dta" of the 2013 annual household resurvey (rural sample)
/*EXAMPLE*/
merge 1:m newid using TTHAI17, nogenerate
/**/

*Exchange rate for approximate midpoint of survey period
/*There is no documentation for the 2013 survey round but I assume that for this round
 the data was also collected in May, so I use May 15 as approximate midpoint for the exchange rate*/

g excrate=0.03368

g excratemonth="5-2013"


foreach var of varlist ownerage ownertertiary educyears married childunder5 childaged5to12 adult65andover wageworker laborincome retired sales reasonforclosure wave surveyyear hhbusclosure typeofbusclosed hhbus enf_bus newfirmquex tbdropped nonfarm typeofbus retail manuf services othersector agefirm employees totalworkers expenses profits hhbusowner totalowners jointbus pcexpend excrate*{ 
rename `var' `var'_2013
} 

rename number hc_id

*TO DO: decide whether you need/want to change path for saving "TTHAI17"
/**/
save TTHAI17, replace
/**/

********************************************************************************
*Round 17 - Urban sample
********************************************************************************
*TO DO: change path to where you saved the following file "hh13_13ba.dta" of the 2013 annual household resurvey (urban sample)
/*EXAMPLE*/
use "Townsend Thai Project/2013/Urban/hh13_13ba.dta", clear
/**/

*Survey round number
g wave=17

*Year survey took place
g surveyyear=2013

*Business closure in past 12 months
g hhbusclosure=(ba1a==1) if (ba1a==1 | ba1a==3) & ba1a!=.c

/*Although the questionnaire asks for reasons, the business was closed (question ba1c),
this variable is not in the dataset and also not in the codebook file*/
replace ba1b=. if ba1b==.c
g typeofbusclosed=ba1b

*I keep the open ended reasons for closure as for now to be able to decide later on appropriate coding
rename ba1c reasonforclosure

*Household operates a business
g hhbus=(ba1d==1) if ba1d!=.c

*TO DO: decide whether you need/want to change path for saving "TTHAI17u"
/**/
save TTHAI17u, replace 
/**/

*TO DO: change path to where you saved the following file "hh13_13ba_tab1.dta" of the 2013 annual household resurvey (urban sample)
/*EXAMPLE*/
use "Townsend Thai Project/2013/Urban/hh13_13ba_tab1.dta", clear
/**/

/*Only keep the information for the first business as I will only consider businesses
 of households who have only one business:*/
keep if bnumber==1

*TO DO: change path to where you saved the following file "TTHAI17u"
/*EXAMPLE*/
merge 1:1 newid using TTHAI17u, nogenerate
/**/

*Household entirely owns household business
replace ba2=0 if hhbus==0

g enf_bus=(ba6==1) if ba6!=.

*Household entirely owns household business
*Business founded in last 12 months:
g newfirmquex=(ba21a==1) if ba21a!=.

/*I will only consider household enterprises if the household operates only one 
enterprise and if this enterprise is entirely owned by the household:*/
g tbdropped=(ba2>1) if ba2!=.c | enf_bus!=1

*Since the questionnaire mixes non-farm and farm enterprises:
g nonfarm=(ba3a==1 | ba3a==3 | ba3a==5 | ba3a==15 | ba3a==17 | ba3a==19) if hhbus==1 & ba3a!=.c

replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="10-wheels truck for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Clothes making shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Construction contractor"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Install car stereoes"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Install gutters"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Laundry service"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Laundry service shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Let houses for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Let rooms for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Make bags"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Make banners and boards"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Make clothes"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Make wooden clocks"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Minibus for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Printing shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Produce furnitures"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Purchase rubber wood"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Repair electric appliances"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="School van"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Self service laundry"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Sew cloth"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Taxi"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Taxi-motorcycle"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Thai classical music band for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Trade antiques"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Tricycle for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Van for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Vehicle care taking service"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="aquariums"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="blackhole car"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="books for rent shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="build house for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="bus for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buy-sell amulets"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buy-sell used cars"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buying and selling junks"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buying and selling small buddha images"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="car pad making shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="carpenter"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="cesspool for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="chinese foods dining arrangement"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="coffee shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="commercial announcement car"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="computer repair shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="computer repairing"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="construction sub-contractor"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="curtain making"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="curved iron"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="cut iron"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="dormitory/student hostel"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="dress making shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="electricity appliances"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="employee commuting car"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="fixing glasses and aluminum"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="furnitures maker"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="furnitures shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="games and internet services shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="glass installation services"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="hired car for articles transfer"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="home improvement services"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="ice producing shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="install and repair air conditioners"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="install curved iron"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="iron welder"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="iron welding shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="karaoke shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="laundry"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="make bricks for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="make cigarettes from sugar palm leaves"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="make stove"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making food for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="mobile phone fill-up services"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="motorcycle for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="motorcycle with side-trailer for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="painter"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="produce parts of wood furnitures"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="recording commercial spots"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="repair and sell parts of motorcycles"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell accessories for gardening"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell and repair watches"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell bakery"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell coffin"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell desserts and drinks"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell furniture"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell gas"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell gifts and souvenirs"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell herbal medicines"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell kai yang 5 dao (5-star roasted chicken)"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell parts of motorcycles"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell small local jets"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell tea and tori"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="selling auto parts"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="selling used cars"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sew bags"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="shop selling car parts and motorcycle parts"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="showing movies in open air theatre"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="snooker table"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="soil transporting truck for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="student commuting car"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="tailor"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to cook sweets"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to do iron making for robber prevention"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to do laundry"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to hammer iron"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to make frame of buddha image"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="traditional massage"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="truck"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="umbrellas - chairs for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="van"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="vegetables delivery car for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="wood handicraft"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="wood lathing"

replace hhbus=0 if nonfarm==0
replace hhbus=. if nonfarm==. & hhbus!=0


*Type of business
g typeofbus=ba3a if hhbus==1

*Sector of the firm:
*Firm is in retail trade
g retail=(ba3a==1 | ba3a==17) if hhbus==1
replace retail=1 if hhbus==1 & ba3a==21 & (ba3ao2=="Trade antiques" |  ba3ao2=="buy-sell amulets" | ba3ao2=="buy-sell used cars" | ba3ao2=="buying and selling small buddha images" | ba3ao2=="furnitures shop" |  ba3ao2=="mobile phone fill-up services" | ba3ao2=="sell accessories for gardening" | ba3ao2=="sell and repair watches" | ba3ao2=="sell coffin" | ba3ao2=="sell furniture" | ba3ao2=="sell gas" | ba3ao2=="sell gifts and souvenirs" | ba3ao2=="sell parts of motorcycles" | ba3ao2=="sell small local jets" |  ba3ao2=="selling auto parts" | ba3ao2=="selling used cars" | ba3ao2=="shop selling car parts and motorcycle parts")

*Firm is in manufacturing sector
g manuf=(ba3a==21 & (ba3ao2=="Clothes making shop" | ba3ao2=="Make bags" | ba3ao2=="Make banners and boards" | ba3ao2=="Make clothes"  | ba3ao2=="Make wooden clocks" | ba3ao2=="Produce furnitures" | ba3ao2=="Sew cloth" | ba3ao2=="carpenter" | ba3ao2=="curtain making" | ba3ao2=="dress making shop"  | ba3ao2=="furnitures maker"  | ba3ao2=="iron welder" | ba3ao2=="iron welding shop" | ba3ao2=="make bricks for sale"  | ba3ao2=="make cigarettes from sugar palm leaves" | ba3ao2=="make stove" | ba3ao2=="produce parts of wood furnitures"  | ba3ao2=="sew bags" | ba3ao2=="tailor" | ba3ao2=="to do iron making for robber prevention" | ba3ao2=="to make frame of buddha image")) if hhbus==1  

*Firm is in service sector
g services=(ba3a==3 | ba3a==5 | ba3a==15 | ba3a==19) if hhbus==1
replace services=1 if hhbus==1 & ba3a==21 & (ba3ao2=="10-wheels truck for hire" | ba3ao2=="Laundry service" | ba3ao2=="Laundry service shop" | ba3ao2=="Let houses for rent" | ba3ao2=="Let rooms for rent" | ba3ao2=="Minibus for hire" | ba3ao2=="Printing shop" | ba3ao2=="Repair electric appliances" | ba3ao2=="School van" | ba3ao2=="Self service laundry" | ba3ao2=="Taxi" | ba3ao2=="Taxi-motorcycle" | ba3ao2=="Thai classical music band for hire" | ba3ao2=="Tricycle for hire" | ba3ao2=="Van for hire" | ba3ao2=="Vehicle care taking service" | ba3ao2=="books for rent shop" | ba3ao2=="bus for hire" | ba3ao2=="cesspool for hire" | ba3ao2=="coffee shop" | ba3ao2=="commercial announcement car" | ba3ao2=="computer repair shop" | ba3ao2=="computer repairing" | ba3ao2=="dormitory/student hostel" | ba3ao2=="employee commuting car" | ba3ao2=="games and internet services shop" | ba3ao2=="hired car for articles transfer" | ba3ao2=="install and repair air conditioners" | ba3ao2=="karaoke shop" | ba3ao2=="laundry" | ba3ao2=="making food for sale" | ba3ao2=="motorcycle for hire" | ba3ao2=="motorcycle with side-trailer for hire"| ba3ao2=="recording commercial spots" | ba3ao2=="sell desserts and drinks" | ba3ao2=="sell kai yang 5 dao (5-star roasted chicken)" | ba3ao2=="showing movies in open air theatre" | ba3ao2=="snooker table" | ba3ao2=="student commuting car" | ba3ao2=="to cook sweets" | ba3ao2=="to do laundry" | ba3ao2=="traditional massage" | ba3ao2=="truck" | ba3ao2=="umbrellas - chairs for rent" | ba3ao2=="van" | ba3ao2=="vegetables delivery car for hire")

*Firm is in other sector
g othersector=(retail==0 & manuf==0 & services==0) if hhbus==1 

replace othersector=. if hhbus==1 & (ba3ao2=="wood handicraft" | ba3ao2=="fixing glasses and aluminum" | ba3ao2=="glass installation services"  | ba3ao2=="install curved iron" | ba3ao2=="painter" | ba3ao2=="sell bakery" | ba3ao2=="Purchase rubber wood" | ba3ao2=="aquariums" | ba3ao2=="blackhole car" | ba3ao2=="chinese foods dining arrangement" | ba3ao2=="curved iron" | ba3ao2=="cut iron" | ba3ao2=="electricity appliances" |  ba3ao2=="home improvement services" | ba3ao2=="sell herbal medicines" | ba3ao2=="sell tea and tori" | ba3ao2=="to hammer iron" | ba3ao2=="wood lathing")
replace services=. if hhbus==1 & (ba3ao2=="wood handicraft" | ba3ao2=="fixing glasses and aluminum" | ba3ao2=="glass installation services"  | ba3ao2=="install curved iron" | ba3ao2=="painter" | ba3ao2=="sell bakery" | ba3ao2=="Purchase rubber wood" | ba3ao2=="aquariums" | ba3ao2=="blackhole car" | ba3ao2=="chinese foods dining arrangement" | ba3ao2=="curved iron" | ba3ao2=="cut iron" | ba3ao2=="electricity appliances" |  ba3ao2=="home improvement services" | ba3ao2=="sell herbal medicines" | ba3ao2=="sell tea and tori" | ba3ao2=="to hammer iron" | ba3ao2=="wood lathing")
replace manuf=. if hhbus==1 & (ba3ao2=="wood handicraft" | ba3ao2=="fixing glasses and aluminum" | ba3ao2=="glass installation services"  | ba3ao2=="install curved iron" | ba3ao2=="painter" | ba3ao2=="sell bakery" | ba3ao2=="Purchase rubber wood" | ba3ao2=="aquariums" | ba3ao2=="blackhole car" | ba3ao2=="chinese foods dining arrangement" | ba3ao2=="curved iron" | ba3ao2=="cut iron" | ba3ao2=="electricity appliances" |  ba3ao2=="home improvement services" | ba3ao2=="sell herbal medicines" | ba3ao2=="sell tea and tori" | ba3ao2=="to hammer iron" | ba3ao2=="wood lathing")
replace retail=. if hhbus==1 & (ba3ao2=="wood handicraft" | ba3ao2=="fixing glasses and aluminum" | ba3ao2=="glass installation services"  | ba3ao2=="install curved iron" | ba3ao2=="painter" | ba3ao2=="sell bakery" | ba3ao2=="Purchase rubber wood" | ba3ao2=="aquariums" | ba3ao2=="blackhole car" | ba3ao2=="chinese foods dining arrangement" | ba3ao2=="curved iron" | ba3ao2=="cut iron" | ba3ao2=="electricity appliances" |  ba3ao2=="home improvement services" | ba3ao2=="sell herbal medicines" | ba3ao2=="sell tea and tori" | ba3ao2=="to hammer iron" | ba3ao2=="wood lathing")

*Age of the firm in years
g agefirm=ba4 if hhbus==1 

*Number of paid employees
replace ba12=. if ba12==.b | ba12==.c
g employees=ba12 if hhbus==1

g totalworkers=ba9 if hhbus==1 

keep newid reasonforclosure wave-totalworkers

*TO DO: decide whether you need/want to change path for saving "TTHAI17u"
/**/
save TTHAI17u, replace
/**/

*TO DO: change path to where you saved the following file "hh13_16in_tab1.dta" of the 2013 annual household resurvey (urban sample)
/*EXAMPLE*/
use "Townsend Thai Project/2013/Urban/hh13_16in_tab1.dta", clear
/**/

*Business sales in last month
keep if number=="N" | number=="O" | number=="P" | number=="Q" | number=="R" | number=="S" | number=="U" | number=="AA"
replace in4=0 if in2==3
bysort newid: egen sales=total(in4), m
*Since sales are given for past 12 months:
replace sales=sales/12

keep newid sales
duplicates drop

*TO DO: change path to where you saved the following file "TTHAI17u.dta"
/*EXAMPLE*/
merge 1:1 newid using TTHAI17u, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving "TTHAI17u"
/**/
save TTHAI17u, replace
/**/

*TO DO: change path to where you saved the following file "hh13_16in.dta" of the 2013 annual household resurvey (urban sample)
/*EXAMPLE*/
use "Townsend Thai Project/2013/Urban/hh13_16in.dta", clear
/**/

g expenses=in10b/12 

keep newid expenses

*TO DO: change path to where you saved the following file "TTHAI17u.dta" 
/*EXAMPLE*/
merge 1:1 newid using TTHAI17u, nogenerate
/**/

g profits=sales-expenses if hhbus==1

*TO DO: decide whether you need/want to change path for saving "TTHAI17u"
/**/
save TTHAI17u, replace
/**/

*TO DO: change path to where you saved the following file "hh13_01cvr.dta" of the 2013 annual household resurvey (urban sample)
/*EXAMPLE*/
use "Townsend Thai Project/2013/Urban/hh13_01cvr.dta", clear
/**/

*Marital status of owner
*Since the marital status is only given for household heads, I can only compute it for head and their spouses
g help=1 if cvr7==1 | cvr7==3 
g married=(cvr11==3) if help==1 & cvr11!=-8
drop help

keep newid married

*TO DO: change path to where you saved the following file "TTHAI17u.dta" 
/*EXAMPLE*/
merge 1:1 newid using TTHAI17u, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving "TTHAI17u"
/**/
save TTHAI17u, replace
/**/

*TO DO: change path to where you saved the following file "hh13_04hc_tab1.dta" of the 2013 annual household resurvey (urban sample)
/*EXAMPLE*/
use "Townsend Thai Project/2013/Urban/hh13_04hc_tab1.dta", clear
/**/

*Age of owner
g ownerage=hc5

*Gender of owner
g female=(hc4==3) if hc4!=.

*Education of owner
g ownertertiary=(hc7==47 | hc7==49 | hc7==51 | hc7==53) if hc7!=. & hc7!=-999 & hc7!=-888

*Years of education
*I assume the number is the years of education and calculate 6 years for primary and 6 years for secondary
*Sources: 	https://en.wikipedia.org/wiki/Education_in_Thailand
*			http://open_jicareport.jica.go.jp/pdf/11548013.pdf
g educyears=0 if hc7==1 | hc7==3 | hc7==5 | hc7==7 | hc7==9
replace educyears=1 if hc7==11
replace educyears=2 if hc7==13
replace educyears=3 if hc7==15
replace educyears=4 if hc7==17
replace educyears=5 if hc7==19
replace educyears=6 if hc7==21
replace educyears=7 if hc7==23
replace educyears=7 if hc7==25
replace educyears=8 if hc7==27
replace educyears=9 if hc7==29
replace educyears=10 if hc7==31 | hc7==41
replace educyears=11 if hc7==33 | hc7==43
replace educyears=12 if hc7==35 | hc7==45
replace educyears=13 if hc7==37 | hc7==47 | hc7==51 | hc7==55
replace educyears=14 if hc7==39 | hc7==49 | hc7==53 | hc7==57
replace educyears=15 if hc7==59
replace educyears=16 if hc7==61

*Child under 5 in household
g under5=0
replace under5=. if hc5==. 
replace under5=1 if hc5<5 
bysort newid: egen childunder5=max(under5)
drop under5

*Child aged 5 to 12 in household
g aged5to12=0
replace aged5to12=. if  hc5==. 
replace aged5to12=1 if  hc5>=5 &  hc5<12
bysort newid: egen childaged5to12=max(aged5to12)
drop aged5to12

*Has adult aged 65+ in the household
g is65orover=0
replace is65orover=. if hc5==. 
replace is65orover=1 if hc5>=65 & hc5!=. 
bysort newid: egen adult65andover=max(is65orover)
drop is65orover

*TO DO: change path to where you saved the following file "hh13_05oc_tab1.dta" of the 2013 annual household resurvey (urban sample)
/*EXAMPLE*/
merge 1:1 newid number using "Townsend Thai Project/2013/Urban/hh13_05oc_tab1.dta", nogenerate
/**/

g businessowner=(oc1b==1) if oc1b!=. & oc1b!=.c 

/*I code individuals as wage workers if the type of employment reported is either:
 - employee - daily wages, or
 - employee - monthly wages, or
 - government worker.
 I do not consider individuals to be wage workers if the type of employment reported is either:
 - owner of business, or
 - unpaid family worker, or
 - employee - piece rate, in house, or
 - employee - piece rate, out of house, or
 - other.
*/

*Worked as wage worker in last month
g wageworker=(oc1b==5 | oc1b==7 | oc1b==13) if oc1b!=. & oc1b!=.c 

*Labor earnings in last month
*Replace missing values:
g laborincome=oc1c if oc1b==7 | oc1b==13
*For government workers it is not clear if the wages are given on a daily or monthly frequency, but I assume from the values that they are monthly
*In case wages are given for a daily frequency, I multiply them with 20 to have monthly wages:
replace laborincome=oc1c*20 if oc1b==5

*Retired
g retired=(oc1a==1) if  oc1a!=.

keep newid number ownerage-adult65andover businessowner wageworker laborincome retired

*TO DO: change path to where you saved the following file "TTHAI17u.dta" 
/*EXAMPLE*/
merge m:1 newid using TTHAI17u, nogenerate 
/**/

g hhbusowner=(businessowner==1) if hhbus==1 & businessowner!=.

drop businessowner

duplicates tag newid hhbusowner if hhbus==1 & hhbusowner==1, gen(totalowners)
replace totalowners=totalowners+1

g jointbus=(totalowners>1) if hhbus==1 & totalowners!=.

*TO DO: decide whether you need/want to change path for saving "TTHAI17u"
/**/
save TTHAI17u, replace
/**/

*Household consumption
*TO DO: change path to where you saved the following file "hh13_04hc.dta" of the 2013 annual household resurvey (urban sample)
/*EXAMPLE*/
use "Townsend Thai Project/2013/Urban/hh13_04hc.dta", clear
/**/
keep newid hc1

*TO DO: change path to where you saved the following file "hh13_15ex.dta" of the 2013 annual household resurvey (urban sample)
/*EXAMPLE*/
merge 1:1 newid using "Townsend Thai Project/2013/Urban/hh13_15ex.dta", nogenerate
/**/
*TO DO: change path to where you saved the following file "hh13_15ex_tab1.dta" of the 2013 annual household resurvey (urban sample)
/*EXAMPLE*/
merge 1:m newid using "Townsend Thai Project/2013/Urban/hh13_15ex_tab1.dta", nogenerate
/**/
replace ex4=. if ex4==.b | ex4==.c | ex4==.y

bysort newid: egen monthlyexp=total(ex4),m

keep newid monthlyexp hc1 ex5-ex9
duplicates drop

replace monthlyexp=12*monthlyexp
egen hh_exp=rowtotal(monthlyexp ex5-ex9), missing

g pcexpend=hh_exp/hc1

drop monthlyexp hh_exp hc1 ex5-ex9

*TO DO: change path to where you saved the following file "TTHAI17u.dta"
/*EXAMPLE*/
merge 1:m newid using TTHAI17u, nogenerate
/**/

*Exchange rate for approximate midpoint of survey period
/*There is no documentation for the 2013 survey round but I assume that for this round
 the data was also collected in May, so I use May 15 as approximate midpoint for the exchange rate*/

g excrate=0.03368

g excratemonth="5-2013"


foreach var of varlist ownerage ownertertiary educyears married childunder5 childaged5to12 adult65andover wageworker laborincome retired sales reasonforclosure wave surveyyear hhbusclosure typeofbusclosed hhbus enf_bus newfirmquex tbdropped nonfarm typeofbus retail manuf services othersector agefirm employees totalworkers expenses profits hhbusowner totalowners jointbus pcexpend excrate*{ 
rename `var' `var'_2013
}



rename number hc_id

*TO DO: decide whether you need/want to change path for saving "TTHAI17u"
/**/
save TTHAI17u, replace
/**/

********************************************************************************
*TO DO: change path to where you saved the following file "TTHAI17.dta"
/*EXAMPLE*/
append using TTHAI17, gen(help)
/**/

*TO DO: decide whether you need/want to change path for saving "TTHAI17"
/**/
save TTHAI17, replace
/**/

********************************************************************************
*TO DO: change path to where you saved the following file "TTHAImaster.dta"
/*EXAMPLE*/
use TTHAImaster,clear
/**/

*TO DO: change path to where you saved the following file "TTHAI17.dta"
/*EXAMPLE*/
merge 1:1 newid hc_id using TTHAI17, gen(_merge16) update
/**/

replace urban=1 if help==0 & urban==.
replace urban=0 if help==1 & urban==.
drop help

*TO DO: decide whether you need/want to change path for saving "TTHAImaster"
/**/
save TTHAImaster, replace
/**/

********************************************************************************
*Round 18 - Rural Sample
********************************************************************************
*TO DO: change path to where you saved the following file "hh14_13ba.dta" of the 2014 annual household resurvey (rural sample)
/*EXAMPLE*/
use "Townsend Thai Project/2014/hh14_13ba.dta", clear
/**/

*Survey round number
g wave=18

*Year survey took place
g surveyyear=2014

*Business closure in past 12 months
g hhbusclosure=(ba1a==1) if (ba1a==1 | ba1a==3) & ba1a!=.c

/*Although the questionnaire asks for reasons, the business was closed (question ba1c),
this variable is not in the dataset and also not in the codebook file*/
replace ba1b=. if ba1b==.c
g typeofbusclosed=ba1b

*I keep the open ended reasons for closure as for now to be able to decide later on appropriate coding
rename ba1c reasonforclosure

*Household operates a business
g hhbus=(ba1d==1) if ba1d!=.c

*TO DO: decide whether you need/want to change path for saving "TTHAI18"
/**/
save TTHAI18, replace 
/**/

*TO DO: change path to where you saved the following file "hh14_13ba_tab1.dta" of the 2014 annual household resurvey (rural sample)
/*EXAMPLE*/
use "Townsend Thai Project/2014/hh14_13ba_tab1.dta", clear
/**/

/*Only keep the information for the first business as I will only consider businesses
 of households who have only one business:*/
keep if bnumber==1

*TO DO: change path to where you saved the following file "TTHAI18.dta"
/*EXAMPLE*/
merge 1:1 newid using TTHAI18, nogenerate
/**/

*Household entirely owns household business
replace ba2=0 if hhbus==0

g enf_bus=(ba6==1) if ba6!=.

*Household entirely owns household business
*Business founded in last 12 months:
g newfirmquex=(ba21a==1) if ba21a!=.

/*I will only consider household enterprises if the household operates only one 
enterprise and if this enterprise is entirely owned by the household:*/
g tbdropped=(ba2>1) if ba2!=.c | enf_bus!=1

*Since the questionnaire mixes non-farm and farm enterprises:
g nonfarm=(ba3a==1 | ba3a==3 | ba3a==5 | ba3a==15 | ba3a==17 | ba3a==19) if hhbus==1 & ba3a!=.c

replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="10-wheels truck for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="6-wheels truck for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Clothes making shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Construction contractor"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Laundry service"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Let houses for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Let rooms for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Let stereoes for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Make clothes"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Make dolls"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Petrol station"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Produce roman pillars"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Self service laundry"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Sell foods"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Sew cloth"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Sewing foot scraper"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Soils loading truck for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Tricycle for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Truck for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Van for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Wooden handicraft products"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="amplifier for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="amplifier for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="amulet frame for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="back-hoe truck"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="bubbles throwing and gun shooting shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buy latex"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buy para rubber woods"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buying and selling junks"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="car repair shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="car wash"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="craftwork from coconut shells"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="craftworks made from coconut shells"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="dress maker"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="drive 6-wheel truck"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="drive car for commuting students"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="drive car for commuting workers"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="embroidery"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="fasten elephant grasses for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="games shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="laundry"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="make curved iron and aluminum for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="make flower wreath frames"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="make iron roof frame for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="make traditional medicines for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making blooms for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="ornamental plants"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="paint car and pick-up car"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="plastic bags recycle"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell nam-phrik"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell sweets"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sew Korean style clothes"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="shoes repair shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="snooker table/s for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to repair cloth"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="traditional massage"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="transportation services for students"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="truck for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="tube fuel station"

replace hhbus=0 if nonfarm==0
replace hhbus=. if nonfarm==. & hhbus!=0


*Type of business
replace ba3a=. if ba3a==.c
g typeofbus=ba3a if hhbus==1

*Sector of the firm:
*Firm is in retail trade
g retail=(ba3a==1 | ba3a==17) if hhbus==1
replace retail=1 if hhbus==1 & ba3a==21 & (ba3ao2=="Petrol station" | ba3ao2=="tube fuel station")

*Firm is in manufacturing sector
g manuf=(ba3a==21 & (ba3ao2=="Clothes making shop" | ba3ao2=="Make clothes" | ba3ao2=="Make dolls" | ba3ao2=="Produce roman pillars" | ba3ao2=="Sew cloth" | ba3ao2=="Sewing foot scraper" | ba3ao2=="craftwork from coconut shells" | ba3ao2=="craftworks made from coconut shells" | ba3ao2=="dress maker" | ba3ao2=="embroidery" | ba3ao2=="make curved iron and aluminum for hire" | ba3ao2=="make iron roof frame for hire" | ba3ao2=="make traditional medicines for sale" | ba3ao2=="sew Korean style clothes")) if hhbus==1  
 
*Firm is in service sector
g services=(ba3a==3 | ba3a==5 | ba3a==15 | ba3a==19) if hhbus==1
replace services=1 if hhbus==1 & ba3a==21 & (ba3ao2=="10-wheels truck for hire" | ba3ao2=="6-wheels truck for hire" | ba3ao2=="Let houses for rent" | ba3ao2=="Let rooms for rent" | ba3ao2=="Let stereoes for rent" | ba3ao2=="Self service laundry" | ba3ao2=="Sell foods" | ba3ao2=="Tricycle for hire" | ba3ao2=="Truck for hire" | ba3ao2=="Van for hire" | ba3ao2=="amplifier for hire" | ba3ao2=="amplifier for rent" | ba3ao2=="bubbles throwing and gun shooting shop" | ba3ao2=="car wash" | ba3ao2=="drive 6-wheel truck" | ba3ao2=="drive car for commuting students" | ba3ao2=="drive car for commuting workers" | ba3ao2=="fasten elephant grasses for sale" | ba3ao2=="laundry" | ba3ao2=="paint car and pick-up car" | ba3ao2=="sell sweets" | ba3ao2=="shoes repair shop" | ba3ao2=="snooker table/s for rent" | ba3ao2=="to repair cloth" | ba3ao2=="traditional massage" | ba3ao2=="transportation services for students" | ba3ao2=="truck for rent")

*Firm is in other sector
g othersector=(retail==0 & manuf==0 & services==0) if hhbus==1 

replace othersector=. if hhbus==1 & (ba3ao2=="Wooden handicraft products" | ba3ao2=="amulet frame for hire" | ba3ao2=="buy latex" | ba3ao2=="buy para rubber woods" | ba3ao2=="buying and selling junks" | ba3ao2=="games shop" | ba3ao2=="make flower wreath frames" | ba3ao2=="making blooms for sale" | ba3ao2=="ornamental plants" | ba3ao2=="sell nam-phrik")
replace services=. if hhbus==1 & (ba3ao2=="Wooden handicraft products" | ba3ao2=="amulet frame for hire" | ba3ao2=="buy latex" | ba3ao2=="buy para rubber woods" | ba3ao2=="buying and selling junks" | ba3ao2=="games shop" | ba3ao2=="make flower wreath frames" | ba3ao2=="making blooms for sale" | ba3ao2=="ornamental plants" | ba3ao2=="sell nam-phrik")
replace manuf=. if hhbus==1 & (ba3ao2=="Wooden handicraft products" | ba3ao2=="amulet frame for hire" | ba3ao2=="buy latex" | ba3ao2=="buy para rubber woods" | ba3ao2=="buying and selling junks" | ba3ao2=="games shop" | ba3ao2=="make flower wreath frames" | ba3ao2=="making blooms for sale" | ba3ao2=="ornamental plants" | ba3ao2=="sell nam-phrik")
replace retail=. if hhbus==1 & (ba3ao2=="Wooden handicraft products" | ba3ao2=="amulet frame for hire" | ba3ao2=="buy latex" | ba3ao2=="buy para rubber woods" | ba3ao2=="buying and selling junks" | ba3ao2=="games shop" | ba3ao2=="make flower wreath frames" | ba3ao2=="making blooms for sale" | ba3ao2=="ornamental plants" | ba3ao2=="sell nam-phrik")


*Age of the firm in years
g agefirm=ba4 if hhbus==1 

*Number of paid employees
replace ba12=. if ba12==.b | ba12==.c
g employees=ba12 if hhbus==1

g totalworkers=ba9 if hhbus==1 

keep newid reasonforclosure wave-totalworkers
*TO DO: decide whether you need/want to change path for saving "TTHAI18"
/**/
save TTHAI18, replace
/**/

*TO DO: change path to where you saved the following file "hh14_16in_tab1.dta" of the 2014 annual household resurvey (rural sample)
/*EXAMPLE*/
use "Townsend Thai Project/2014/hh14_16in_tab1.dta", clear
/**/

*Business sales in last month
keep if number=="N" | number=="O" | number=="P" | number=="Q" | number=="R" | number=="S" | number=="U" | number=="AA"
replace in4=0 if in2==3
bysort newid: egen sales=total(in4), m
*Since sales are given for past 12 months:
replace sales=sales/12

keep newid sales
duplicates drop

*TO DO: change path to where you saved the following file "TTHAI18.dta" 
/*EXAMPLE*/
merge 1:1 newid using TTHAI18, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving "TTHAI18"
/**/
save TTHAI18, replace
/**/

*TO DO: change path to where you saved the following file "hh14_16in.dta" of the 2014 annual household resurvey (rural sample)
/*EXAMPLE*/
use "Townsend Thai Project/2014/hh14_16in.dta", clear
/**/

g expenses=in10b/12 

keep newid expenses

*TO DO: change path to where you saved the following file "TTHAI18.dta" 
/*EXAMPLE*/
merge 1:1 newid using TTHAI18, nogenerate
/**/

g profits=sales-expenses if hhbus==1

*TO DO: decide whether you need/want to change path for saving "TTHAI18"
/**/
save TTHAI18, replace
/**/

*TO DO: change path to where you saved the following file "hh14_01cvr.dta" of the 2014 annual household resurvey (rural sample)
/*EXAMPLE*/
use "Townsend Thai Project/2014/hh14_01cvr.dta", clear
/**/

*Marital status of owner
*Since the marital status is only given for household heads, I can only compute it for head and their spouses
g help=1 if cvr7==1 | cvr7==3 
g married=(cvr11==3) if help==1 & cvr11!=-8
drop help

keep newid married

*TO DO: change path to where you saved the following file "TTHAI18.dta" 
/*EXAMPLE*/
merge 1:1 newid using TTHAI18, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving "TTHAI18"
/**/
save TTHAI18, replace
/**/

*TO DO: change path to where you saved the following file "hh14_04hc_tab1.dta" of the 2014 annual household resurvey (rural sample)
/*EXAMPLE*/
use "Townsend Thai Project/2014/hh14_04hc_tab1.dta", clear
/**/

*Age of owner
g ownerage=hc5

*Gender of owner
g female=(hc4==3) if hc4!=.

*Education of owner
g ownertertiary=(hc7==47 | hc7==49 | hc7==51 | hc7==53) if hc7!=. & hc7!=-999 & hc7!=-888

*Years of education
*I assume the number is the years of education and calculate 6 years for primary and 6 years for secondary
*Sources: 	https://en.wikipedia.org/wiki/Education_in_Thailand
*			http://open_jicareport.jica.go.jp/pdf/11548013.pdf
g educyears=0 if hc7==1 | hc7==3 | hc7==5 | hc7==7 | hc7==9
replace educyears=1 if hc7==11
replace educyears=2 if hc7==13
replace educyears=3 if hc7==15
replace educyears=4 if hc7==17
replace educyears=5 if hc7==19
replace educyears=6 if hc7==21
replace educyears=7 if hc7==23
replace educyears=7 if hc7==25
replace educyears=8 if hc7==27
replace educyears=9 if hc7==29
replace educyears=10 if hc7==31 | hc7==41
replace educyears=11 if hc7==33 | hc7==43
replace educyears=12 if hc7==35 | hc7==45
replace educyears=13 if hc7==37 | hc7==47 | hc7==51 | hc7==55
replace educyears=14 if hc7==39 | hc7==49 | hc7==53 | hc7==57
replace educyears=15 if hc7==59
replace educyears=16 if hc7==61

*Child under 5 in household
g under5=0
replace under5=. if hc5==. 
replace under5=1 if hc5<5 
bysort newid: egen childunder5=max(under5)
drop under5

*Child aged 5 to 12 in household
g aged5to12=0
replace aged5to12=. if  hc5==. 
replace aged5to12=1 if  hc5>=5 &  hc5<12
bysort newid: egen childaged5to12=max(aged5to12)
drop aged5to12

*Has adult aged 65+ in the household
g is65orover=0
replace is65orover=. if hc5==. 
replace is65orover=1 if hc5>=65 & hc5!=. 
bysort newid: egen adult65andover=max(is65orover)
drop is65orover

*TO DO: change path to where you saved the following file "hh14_05oc_tab1.dta" of the 2014 annual household resurvey (rural sample)
/*EXAMPLE*/
merge 1:1 newid number using "Townsend Thai Project/2014/hh14_05oc_tab1.dta", nogenerate
/**/

g businessowner=(oc1b==1) if oc1b!=. & oc1b!=.c 

/*I code individuals as wage workers if the type of employment reported is either:
 - employee - daily wages, or
 - employee - monthly wages, or
 - government worker.
 I do not consider individuals to be wage workers if the type of employment reported is either:
 - owner of business, or
 - unpaid family worker, or
 - employee - piece rate, in house, or
 - employee - piece rate, out of house, or
 - other.
*/

*Worked as wage worker in last month
g wageworker=(oc1b==5 | oc1b==7 | oc1b==13) if oc1b!=. & oc1b!=.c 

*Labor earnings in last month
*Replace missing values:
g laborincome=oc1c if oc1b==7 | oc1b==13
*For government workers it is not clear if the wages are given on a daily or monthly frequency, but I assume from the values that they are monthly
*In case wages are given for a daily frequency, I multiply them with 20 to have monthly wages:
replace laborincome=oc1c*20 if oc1b==5

*Retired
g retired=(oc1a==1) if  oc1a!=.

keep newid number ownerage-adult65andover businessowner wageworker laborincome retired

*TO DO: change path to where you saved the following file "TTHAI18" 
/*EXAMPLE*/
merge m:1 newid using TTHAI18, nogenerate 
/**/

g hhbusowner=(businessowner==1) if hhbus==1 & businessowner!=.

drop businessowner

duplicates tag newid hhbusowner if hhbus==1 & hhbusowner==1, gen(totalowners)
replace totalowners=totalowners+1

g jointbus=(totalowners>1) if hhbus==1 & totalowners!=.

*TO DO: decide whether you need/want to change path for saving "TTHAI18"
/**/
save TTHAI18, replace
/**/

*Household consumption
*TO DO: change path to where you saved the following file "hh14_04hc.dta" of the 2014 annual household resurvey (rural sample)
/*EXAMPLE*/
use "Townsend Thai Project/2014/hh14_04hc.dta", clear
/**/

keep newid hc1

*TO DO: change path to where you saved the following file "hh14_15ex.dta" of the 2014 annual household resurvey (rural sample)
/*EXAMPLE*/
merge 1:1 newid using "Townsend Thai Project/2014/hh14_15ex.dta", nogenerate
/**/
*TO DO: change path to where you saved the following file "hh14_15ex_tab1.dta" of the 2014 annual household resurvey (rural sample)
/*EXAMPLE*/
merge 1:m newid using "Townsend Thai Project/2014/hh14_15ex_tab1.dta", nogenerate
/**/
replace ex4=. if ex4==.b | ex4==.c | ex4==.y

bysort newid: egen monthlyexp=total(ex4),m

keep newid monthlyexp hc1 ex5-ex9
duplicates drop

replace monthlyexp=12*monthlyexp
egen hh_exp=rowtotal(monthlyexp ex5-ex9), missing

g pcexpend=hh_exp/hc1

drop monthlyexp hh_exp hc1 ex5-ex9

*TO DO: change path to where you saved the following file "TTHAI18.dta" 
/*EXAMPLE*/
merge 1:m newid using TTHAI18, nogenerate
/**/

*Exchange rate for approximate midpoint of survey period
/*There is no documentation for the 2014 survey round but I assume that for this round
 the data was also collected in May, so I use May 15 as approximate midpoint for the exchange rate*/

g excrate=0.03074

g excratemonth="5-2014"


foreach var of varlist ownerage ownertertiary educyears married childunder5 childaged5to12 adult65andover wageworker laborincome retired sales reasonforclosure wave surveyyear hhbusclosure typeofbusclosed hhbus enf_bus newfirmquex tbdropped nonfarm typeofbus retail manuf services othersector agefirm employees totalworkers expenses profits hhbusowner totalowners jointbus pcexpend excrate*{ 
rename `var' `var'_2014
} 

rename number hc_id

*TO DO: decide whether you need/want to change path for saving "TTHAI18"
/**/
save TTHAI18, replace
/**/

********************************************************************************
*Round 18 - Urban Sample
********************************************************************************
*TO DO: change path to where you saved the following file "hh14_13ba.dta" of the 2014 annual household resurvey (urban sample)
/*EXAMPLE*/
use "Townsend Thai Project/2014/Urban/hh14_13ba.dta", clear
/**/

*Survey round number
g wave=18

*Year survey took place
g surveyyear=2014

*Business closure in past 12 months
g hhbusclosure=(ba1a==1) if (ba1a==1 | ba1a==3) & ba1a!=.c

/*Although the questionnaire asks for reasons, the business was closed (question ba1c),
this variable is not in the dataset and also not in the codebook file*/
replace ba1b=. if ba1b==.c
g typeofbusclosed=ba1b

*I keep the open ended reasons for closure as for now to be able to decide later on appropriate coding
rename ba1c reasonforclosure

*Household operates a business
g hhbus=(ba1d==1) if ba1d!=.c

*TO DO: decide whether you need/want to change path for saving "TTHAI18u"
/**/
save TTHAI18u, replace 
/**/

*TO DO: change path to where you saved the following file "hh14_13ba_tab1.dta" of the 2014 annual household resurvey (urban sample)
/*EXAMPLE*/
use "Townsend Thai Project/2014/Urban/hh14_13ba_tab1.dta", clear
/**/

/*Only keep the information for the first business as I will only consider businesses
 of households who have only one business:*/
keep if bnumber==1

*TO DO: change path to where you saved the following file "TTHAI18u" 
/*EXAMPLE*/
merge 1:1 newid using TTHAI18u, nogenerate
/**/

*Household entirely owns household business
replace ba2=0 if hhbus==0

g enf_bus=(ba6==1) if ba6!=.

*Household entirely owns household business
*Business founded in last 12 months:
g newfirmquex=(ba21a==1) if ba21a!=.

/*I will only consider household enterprises if the household operates only one 
enterprise and if this enterprise is entirely owned by the household:*/
g tbdropped=(ba2>1) if ba2!=.c | enf_bus!=1

*Since the questionnaire mixes non-farm and farm enterprises:
g nonfarm=(ba3a==1 | ba3a==3 | ba3a==5 | ba3a==15 | ba3a==17 | ba3a==19) if hhbus==1 & ba3a!=.c

replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="10-wheels truck for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Clothes making shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Construction contractor"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Electric appliance repairing shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Install car stereoes"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Install gutters"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Land filling contractor"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Laundry service"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Laundry service shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Let houses for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Let rooms for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Make clothes"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Printing shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Produce furnitures"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Produce herb juice"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Repair electric appliances"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="School van"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Self service laundry"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Sew cloth"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Taxi"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Taxi-motorcycle"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Tricycle for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Truck for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Van for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="Vehicle care taking service"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="amulet framing, buy-sell amulets"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="aquarium"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="arrange Chinese dining sets"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="blackhole car"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="bus for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="buy-sell amulets"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="car for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="car paint shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="chairs and unbrellas for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="clean up toilet for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="clothes ironing"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="computer repairing"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="curtain making"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="curved iron"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="cut cloths"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="cut iron for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="delivery service for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="dormitory/student hostel"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="dress making shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="drive car to deliver vegetables in the market"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="drive commuting van for students"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="fixing glasses and aluminum"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="games shop and internet services"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="glasses installation"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="ice producing shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="install and repair air conditioners"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="iron lathing, welding shop"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="iron welder"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="karaoke"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="laundry"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="make car seats"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="make cigarrettes from chak leaves"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="make coffin and donated home"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="make curved iron doors"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="make local jet"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="make pra-san bricks for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="make watches from teak"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="making food for sale"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="motorcycle for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="produce parts of furnitures"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="recording commercial spots"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="repair and rent out amplifier"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="repair and sell parts for motorcycles"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="repair bicycles"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="repair computer"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="repair electricity system"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="ride tricycle for hire"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell and repair watches"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell coffin"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell furniture"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell ornamental trees"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell parts for motorcycles"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="sell parts of bicycles and motorcycles"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="selling auto parts"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="selling electronic appliances"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="selling used cars"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="showing movies in open air theatre"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="side-trailer for motorcycle"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="snooker table"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="tailor, dress maker"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to cook sweets"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to do iron making for robber prevention"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to do laundry"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to hammer iron"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to make frame of buddha image"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to make strove"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="to repair cloth"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="traditional massage"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="tricycle for rent"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="vinyl sign board"
replace nonfarm=1 if hhbus==1 & ba3a==21 & ba3ao2=="wood lathe"

replace hhbus=0 if nonfarm==0
replace hhbus=. if nonfarm==. & hhbus!=0


*Type of business
replace ba3a=. if ba3a==.c
g typeofbus=ba3a if hhbus==1

*Sector of the firm:
*Firm is in retail trade
g retail=(ba3a==1 | ba3a==17) if hhbus==1
replace retail=1 if hhbus==1 & ba3a==21 & (ba3ao2=="buy-sell amulets" | ba3ao2=="sell and repair watches" | ba3ao2=="sell coffin" | ba3ao2=="sell furniture" | ba3ao2=="sell ornamental trees" | ba3ao2=="sell parts for motorcycles" | ba3ao2=="sell parts of bicycles and motorcycles" | ba3ao2=="selling auto parts" | ba3ao2=="selling electronic appliances" | ba3ao2=="selling used cars")

*Firm is in manufacturing sector
g manuf=(ba3a==21 & (ba3ao2=="Clothes making shop" | ba3ao2=="Make clothes" | ba3ao2=="Produce furnitures" | ba3ao2=="Produce herb juice" | ba3ao2=="Sew cloth" | ba3ao2=="curtain making" | ba3ao2=="dress making shop" | ba3ao2=="cut iron for hire" | ba3ao2=="iron lathing, welding shop" | ba3ao2=="iron welder" | ba3ao2=="make car seats" | ba3ao2=="make cigarrettes from chak leaves" | ba3ao2=="make coffin and donated home" | ba3ao2=="make curved iron doors" | ba3ao2=="make local jet" | ba3ao2=="make watches from teak" | ba3ao2=="produce parts of furnitures" | ba3ao2=="tailor, dress maker" | ba3ao2=="to do iron making for robber prevention" | ba3ao2=="to make frame of buddha image")) if hhbus==1  

*Firm is in service sector
g services=(ba3a==3 | ba3a==5 | ba3a==15 | ba3a==19) if hhbus==1
replace services=1 if hhbus==1 & ba3a==21 & (ba3ao2=="10-wheels truck for hire" | ba3ao2=="Electric appliance repairing shop" | ba3ao2=="Laundry service" | ba3ao2=="Laundry service shop" | ba3ao2=="Let houses for rent" | ba3ao2=="Let rooms for rent" | ba3ao2=="Printing shop" | ba3ao2=="Repair electric appliances" | ba3ao2=="School van" | ba3ao2=="Self service laundry" | ba3ao2=="Taxi" | ba3ao2=="Taxi-motorcycle" | ba3ao2=="Tricycle for hire" | ba3ao2=="Truck for hire" | ba3ao2=="Van for hire" | ba3ao2=="Vehicle care taking service" | ba3ao2=="bus for rent" | ba3ao2=="car for hire" | ba3ao2=="chairs and unbrellas for rent" | ba3ao2=="clean up toilet for hire" | ba3ao2=="clothes ironing" | ba3ao2=="computer repairing" | ba3ao2=="delivery service for hire" | ba3ao2=="dormitory/student hostel" | ba3ao2=="drive car to deliver vegetables in the market" | ba3ao2=="drive commuting van for students" | ba3ao2=="games shop and internet services" | ba3ao2=="install and repair air conditioners" | ba3ao2=="karaoke" | ba3ao2=="laundry" | ba3ao2=="making food for sale" | ba3ao2=="motorcycle for hire" | ba3ao2=="ploughing for hire" | ba3ao2=="recording commercial spots" | ba3ao2=="repair and rent out amplifier" | ba3ao2=="repair and sell parts for motorcycles" | ba3ao2=="repair bicycles" | ba3ao2=="repair computer" | ba3ao2=="repair electricity system" | ba3ao2=="ride tricycle for hire" | ba3ao2=="showing movies in open air theatre" | ba3ao2=="snooker table" | ba3ao2=="to cook sweets" | ba3ao2=="to do laundry" | ba3ao2=="to repair cloth" | ba3ao2=="traditional massage" | ba3ao2=="tricycle for rent")
*Firm is in other sector
g othersector=(retail==0 & manuf==0 & services==0) if hhbus==1 

replace othersector=. if hhbus==1 & (ba3ao2=="amulet framing, buy-sell amulets" | ba3ao2=="aquarium" | ba3ao2=="arrange Chinese dining sets" | ba3ao2=="cut cloths" | ba3ao2=="curved iron" | ba3ao2=="fixing glasses and aluminum" | ba3ao2=="glasses installation" | ba3ao2=="side-trailer for motorcycle" | ba3ao2=="to hammer iron" | ba3ao2=="to make strove" | ba3ao2=="vinyl sign board" | ba3ao2=="wood lathe")
replace services=. if hhbus==1 & (ba3ao2=="amulet framing, buy-sell amulets" | ba3ao2=="aquarium" | ba3ao2=="arrange Chinese dining sets" | ba3ao2=="cut cloths" | ba3ao2=="curved iron" | ba3ao2=="fixing glasses and aluminum" | ba3ao2=="glasses installation" | ba3ao2=="side-trailer for motorcycle" | ba3ao2=="to hammer iron" | ba3ao2=="to make strove" | ba3ao2=="vinyl sign board" | ba3ao2=="wood lathe")
replace manuf=. if hhbus==1 & (ba3ao2=="amulet framing, buy-sell amulets" | ba3ao2=="aquarium" | ba3ao2=="arrange Chinese dining sets" | ba3ao2=="cut cloths" | ba3ao2=="curved iron" | ba3ao2=="fixing glasses and aluminum" | ba3ao2=="glasses installation" | ba3ao2=="side-trailer for motorcycle" | ba3ao2=="to hammer iron" | ba3ao2=="to make strove" | ba3ao2=="vinyl sign board" | ba3ao2=="wood lathe")
replace retail=. if hhbus==1 & (ba3ao2=="amulet framing, buy-sell amulets" | ba3ao2=="aquarium" | ba3ao2=="arrange Chinese dining sets" | ba3ao2=="cut cloths" | ba3ao2=="curved iron" | ba3ao2=="fixing glasses and aluminum" | ba3ao2=="glasses installation" | ba3ao2=="side-trailer for motorcycle" | ba3ao2=="to hammer iron" | ba3ao2=="to make strove" | ba3ao2=="vinyl sign board" | ba3ao2=="wood lathe")


*Age of the firm in years
g agefirm=ba4 if hhbus==1 

*Number of paid employees
replace ba12=. if ba12==.b | ba12==.c
g employees=ba12 if hhbus==1

g totalworkers=ba9 if hhbus==1 

keep newid reasonforclosure wave-totalworkers
*TO DO: decide whether you need/want to change path for saving "TTHAI18u"
/**/
save TTHAI18u, replace
/**/

*TO DO: change path to where you saved the following file "hh14_16in_tab1.dta" of the 2014 annual household resurvey (urban sample)
/*EXAMPLE*/
use "Townsend Thai Project/2014/Urban/hh14_16in_tab1.dta", clear
/**/

*Business sales in last month
keep if number=="N" | number=="O" | number=="P" | number=="Q" | number=="R" | number=="S" | number=="U" | number=="AA"
replace in4=0 if in2==3
bysort newid: egen sales=total(in4), m
*Since sales are given for past 12 months:
replace sales=sales/12

keep newid sales
duplicates drop

*TO DO: change path to where you saved the following file "TTHAI18u.dta" 
/*EXAMPLE*/
merge 1:1 newid using TTHAI18u, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving "TTHAI18u"
/**/
save TTHAI18u, replace
/**/

*TO DO: change path to where you saved the following file "hh14_16in.dta" of the 2014 annual household resurvey (urban sample)
/*EXAMPLE*/
use "Townsend Thai Project/2014/Urban/hh14_16in.dta", clear
/**/

g expenses=in10b/12 

keep newid expenses

*TO DO: change path to where you saved the following file "TTHAI18u.dta" 
/*EXAMPLE*/
merge 1:1 newid using TTHAI18u, nogenerate
/**/

g profits=sales-expenses if hhbus==1

*TO DO: decide whether you need/want to change path for saving "TTHAI18u"
/**/
save TTHAI18u, replace
/**/

*TO DO: change path to where you saved the following file "hh14_01cvr.dta" of the 2014 annual household resurvey (urban sample)
/*EXAMPLE*/
use "Townsend Thai Project/2014/Urban/hh14_01cvr.dta", clear
/**/

*Marital status of owner
*Since the marital status is only given for household heads, I can only compute it for head and their spouses
g help=1 if cvr7==1 | cvr7==3 
g married=(cvr11==3) if help==1 & cvr11!=-8
drop help

keep newid married

*TO DO: change path to where you saved the following file "TTHAI18u.dta" 
/*EXAMPLE*/
merge 1:1 newid using TTHAI18u, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving "TTHAI18u"
/**/
save TTHAI18u, replace
/**/

*TO DO: change path to where you saved the following file "hh14_04hc_tab1.dta" of the 2014 annual household resurvey (urban sample)
/*EXAMPLE*/
use "Townsend Thai Project/2014/Urban/hh14_04hc_tab1.dta", clear
/**/

*Age of owner
g ownerage=hc5

*Gender of owner
g female=(hc4==3) if hc4!=.

*Education of owner
g ownertertiary=(hc7==47 | hc7==49 | hc7==51 | hc7==53) if hc7!=. & hc7!=-999 & hc7!=-888

*Years of education
*I assume the number is the years of education and calculate 6 years for primary and 6 years for secondary
*Sources: 	https://en.wikipedia.org/wiki/Education_in_Thailand
*			http://open_jicareport.jica.go.jp/pdf/11548013.pdf
g educyears=0 if hc7==1 | hc7==3 | hc7==5 | hc7==7 | hc7==9
replace educyears=1 if hc7==11
replace educyears=2 if hc7==13
replace educyears=3 if hc7==15
replace educyears=4 if hc7==17
replace educyears=5 if hc7==19
replace educyears=6 if hc7==21
replace educyears=7 if hc7==23
replace educyears=7 if hc7==25
replace educyears=8 if hc7==27
replace educyears=9 if hc7==29
replace educyears=10 if hc7==31 | hc7==41
replace educyears=11 if hc7==33 | hc7==43
replace educyears=12 if hc7==35 | hc7==45
replace educyears=13 if hc7==37 | hc7==47 | hc7==51 | hc7==55
replace educyears=14 if hc7==39 | hc7==49 | hc7==53 | hc7==57
replace educyears=15 if hc7==59
replace educyears=16 if hc7==61

*Child under 5 in household
g under5=0
replace under5=. if hc5==. 
replace under5=1 if hc5<5 
bysort newid: egen childunder5=max(under5)
drop under5

*Child aged 5 to 12 in household
g aged5to12=0
replace aged5to12=. if  hc5==. 
replace aged5to12=1 if  hc5>=5 &  hc5<12
bysort newid: egen childaged5to12=max(aged5to12)
drop aged5to12

*Has adult aged 65+ in the household
g is65orover=0
replace is65orover=. if hc5==. 
replace is65orover=1 if hc5>=65 & hc5!=. 
bysort newid: egen adult65andover=max(is65orover)
drop is65orover

*TO DO: change path to where you saved the following file "hh14_05oc_tab1.dta" of the 2014 annual household resurvey (urban sample)
/*EXAMPLE*/
merge 1:1 newid number using "Townsend Thai Project/2014/Urban/hh14_05oc_tab1.dta", nogenerate
/**/

g businessowner=(oc1b==1) if oc1b!=. & oc1b!=.c 

/*I code individuals as wage workers if the type of employment reported is either:
 - employee - daily wages, or
 - employee - monthly wages, or
 - government worker.
 I do not consider individuals to be wage workers if the type of employment reported is either:
 - owner of business, or
 - unpaid family worker, or
 - employee - piece rate, in house, or
 - employee - piece rate, out of house, or
 - other.
*/

*Worked as wage worker in last month
g wageworker=(oc1b==5 | oc1b==7 | oc1b==13) if oc1b!=. & oc1b!=.c 

*Labor earnings in last month
*Replace missing values:
g laborincome=oc1c if oc1b==7 | oc1b==13
*For government workers it is not clear if the wages are given on a daily or monthly frequency, but I assume from the values that they are monthly
*In case wages are given for a daily frequency, I multiply them with 20 to have monthly wages:
replace laborincome=oc1c*20 if oc1b==5

*Retired
g retired=(oc1a==1) if  oc1a!=.

keep newid number ownerage-adult65andover businessowner wageworker laborincome retired

*TO DO: change path to where you saved the following file "TTHAI18u.dta" 
/*EXAMPLE*/
merge m:1 newid using TTHAI18u, nogenerate 
/**/

g hhbusowner=(businessowner==1) if hhbus==1 & businessowner!=.

drop businessowner

duplicates tag newid hhbusowner if hhbus==1 & hhbusowner==1, gen(totalowners)
replace totalowners=totalowners+1

g jointbus=(totalowners>1) if hhbus==1 & totalowners!=.

*TO DO: decide whether you need/want to change path for saving "TTHAI18u"
/**/
save TTHAI18u, replace
/**/

*Household consumption
*TO DO: change path to where you saved the following file "hh14_04hc.dta" of the 2014 annual household resurvey (urban sample)
/*EXAMPLE*/
use "Townsend Thai Project/2014/Urban/hh14_04hc.dta", clear
/**/
keep newid hc1
*TO DO: change path to where you saved the following file "hh14_15ex.dta" of the 2014 annual household resurvey (urban sample)
/*EXAMPLE*/
merge 1:1 newid using "Townsend Thai Project/2014/Urban/hh14_15ex.dta", nogenerate
/**/
*TO DO: change path to where you saved the following file "hh14_15ex_tab1.dta" of the 2014 annual household resurvey (urban sample)
/*EXAMPLE*/
merge 1:m newid using "Townsend Thai Project/2014/Urban/hh14_15ex_tab1.dta", nogenerate
/**/
replace ex4=. if ex4==.b | ex4==.c | ex4==.y

bysort newid: egen monthlyexp=total(ex4),m

keep newid monthlyexp hc1 ex5-ex9
duplicates drop

replace monthlyexp=12*monthlyexp
egen hh_exp=rowtotal(monthlyexp ex5-ex9), missing

g pcexpend=hh_exp/hc1

drop monthlyexp hh_exp hc1 ex5-ex9

*TO DO: change path to where you saved the following file "TTHAI18u.dta"
/*EXAMPLE*/
merge 1:m newid using TTHAI18u, nogenerate
/**/

*Exchange rate for approximate midpoint of survey period
/*There is no documentation for the 2014 survey round but I assume that for this round
 the data was also collected in May, so I use May 15 as approximate midpoint for the exchange rate*/

g excrate=0.03074

g excratemonth="5-2014"


foreach var of varlist ownerage ownertertiary educyears married childunder5 childaged5to12 adult65andover wageworker laborincome retired sales reasonforclosure wave surveyyear hhbusclosure typeofbusclosed hhbus enf_bus newfirmquex tbdropped nonfarm typeofbus retail manuf services othersector agefirm employees totalworkers expenses profits hhbusowner totalowners jointbus pcexpend excrate*{ 
rename `var' `var'_2014
} 

rename number hc_id

*TO DO: decide whether you need/want to change path for saving "TTHAI18u"
/**/
save TTHAI18u, replace
/**/

********************************************************************************

*TO DO: change path to where you saved the following file "TTHAI18.dta"
/*EXAMPLE*/
append using TTHAI18, gen(help)
/**/

*TO DO: decide whether you need/want to change path for saving "TTHAI18"
/**/
save TTHAI18, replace
/**/

********************************************************************************
*TO DO: change path to where you saved the following file "TTHAImaster.dta"
/*EXAMPLE*/
use TTHAImaster,clear
/**/

*TO DO: change path to where you saved the following file "TTHAI18.dta"
/*EXAMPLE*/
merge 1:1 newid hc_id using TTHAI18, gen(_merge17) update
/**/

replace urban=1 if help==0 & urban==.
replace urban=0 if help==1 & urban==.
drop help

*TO DO: decide whether you need/want to change path for saving "TTHAImaster"
/**/
save TTHAImaster, replace
/**/

/*Given that there are jointly owned firms, I create a new variable,
 that has three categories: male (base category), female and jointly operated*/
forvalues x=1997(1)2014{
g mfj_`x'=female if jointbus_`x'==0
replace mfj_`x'=2 if jointbus_`x'==1
}

*TO DO: decide whether you need/want to change path for saving "TTHAImaster"
/**/
save TTHAImaster, replace
/**/

********************************************************************************

********************************************************************************
*Construct attrition 
********************************************************************************

********************************************************************************


********************************************************************************
*Attrition:
********************************************************************************

*Over one year
g attrit_19971998=(_merge==1) if _merge!=2 & _merge!=.
g attrit_19981999=(_merge2==1) if _merge2!=2 & _merge2!=. & _merge!=1 & _merge!=.
g attrit_19992000=(_merge3==1) if _merge3!=2 & _merge3!=. & _merge2!=1 & _merge2!=.
g attrit_20002001=(_merge4==1) if _merge4!=2 & _merge4!=. & _merge3!=1 & _merge3!=.
g attrit_20012002=(_merge5==1) if _merge5!=2 & _merge5!=. & _merge4!=1 & _merge4!=.
g attrit_20022003=(_merge6==1) if _merge6!=2 & _merge6!=. & _merge5!=1 & _merge5!=.
g attrit_20032004=(_merge7==1) if _merge7!=2 & _merge7!=. & _merge6!=1 & _merge6!=.
g attrit_20042005=(_merge8==1) if _merge8!=2 & _merge8!=. & _merge7!=1 & _merge7!=.
g attrit_20052006=(_merge9==1) if _merge9!=2 & _merge9!=. & _merge8!=1 & _merge8!=.
g attrit_20062007=(_merge10==1) if _merge10!=2 & _merge10!=. & _merge9!=1  & _merge9!=.
g attrit_20072008=(_merge11==1) if _merge11!=2 & _merge11!=. & _merge10!=1 & _merge10!=.
g attrit_20082009=(_merge12==1) if _merge12!=2 & _merge12!=. & _merge11!=1 & _merge11!=.
g attrit_20092010=(_merge13==1) if _merge13!=2 & _merge13!=. & _merge12!=1 & _merge12!=.
g attrit_20102011=(_merge14==1) if _merge14!=2 & _merge14!=. & _merge13!=1 & _merge13!=.
g attrit_20112012=(_merge15==1) if _merge15!=2 & _merge15!=. & _merge14!=1 & _merge14!=.
g attrit_20122013=(_merge16==1) if _merge16!=2 & _merge16!=. & _merge15!=1 & _merge15!=.
g attrit_20132014=(_merge17==1) if _merge17!=2 & _merge17!=. & _merge16!=1 & _merge16!=.

*Over two years
g attrit_19971999=(_merge2==1) if _merge2!=2 & _merge2!=. & _merge!=2 & _merge!=.
g attrit_19982000=(_merge3==1) if _merge3!=2 & _merge3!=. & _merge2!=2 & _merge2!=. & _merge!=1 & _merge!=.
g attrit_19992001=(_merge4==1) if _merge4!=2 & _merge4!=. & _merge3!=2 & _merge3!=. & _merge2!=1 & _merge2!=.
g attrit_20002002=(_merge5==1) if _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=1 & _merge3!=. 
g attrit_20012003=(_merge6==1) if _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=1 & _merge4!=. 
g attrit_20022004=(_merge7==1) if _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=1 & _merge5!=. 
g attrit_20032005=(_merge8==1) if _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=1 & _merge6!=. 
g attrit_20042006=(_merge9==1) if _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=1 & _merge7!=. 
g attrit_20052007=(_merge10==1) if _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=1 & _merge8!=. 
g attrit_20062008=(_merge11==1) if _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=1 & _merge9!=. 
g attrit_20072009=(_merge12==1) if _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=1 & _merge10!=. 
g attrit_20082010=(_merge13==1) if _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=1 & _merge11!=. 
g attrit_20092011=(_merge14==1) if _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=1 & _merge12!=. 
g attrit_20102012=(_merge15==1) if _merge15!=2 & _merge15!=. & _merge14!=2 & _merge14!=. & _merge13!=1 & _merge13!=. 
g attrit_20112013=(_merge16==1) if _merge16!=2 & _merge16!=. & _merge15!=2 & _merge15!=. & _merge14!=1 & _merge14!=. 
g attrit_20122014=(_merge17==1) if _merge17!=2 & _merge17!=. & _merge16!=2 & _merge16!=. & _merge15!=1 & _merge15!=. 

*Over three years 
g attrit_19972000=(_merge3==1) if _merge3!=2 & _merge3!=. & _merge2!=2 & _merge2!=. & _merge!=2 & _merge!=.
g attrit_19982001=(_merge4==1) if _merge4!=2 & _merge4!=. & _merge3!=2 & _merge3!=. & _merge2!=2 & _merge2!=. & _merge!=1 & _merge!=.
g attrit_19992002=(_merge5==1) if _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=2 & _merge3!=. & _merge2!=1 & _merge2!=.
g attrit_20002003=(_merge6==1) if _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=1 & _merge3!=. 
g attrit_20012004=(_merge7==1) if _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=1 & _merge4!=. 
g attrit_20022005=(_merge8==1) if _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=1 & _merge5!=. 
g attrit_20032006=(_merge9==1) if _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=1 & _merge6!=.
g attrit_20042007=(_merge10==1) if _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=1 & _merge7!=.
g attrit_20052008=(_merge11==1) if _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=1 & _merge8!=.
g attrit_20062009=(_merge12==1) if _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=1 & _merge9!=.
g attrit_20072010=(_merge13==1) if _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=1 & _merge10!=.
g attrit_20082011=(_merge14==1) if _merge14!=2 & _merge14!=. &_merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=1 & _merge11!=.
g attrit_20092012=(_merge15==1) if _merge15!=2 & _merge15!=. & _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=1 & _merge12!=.
g attrit_20102013=(_merge16==1) if _merge16!=2 & _merge16!=. & _merge15!=2 & _merge15!=. & _merge14!=2 & _merge14!=. & _merge13!=1 & _merge13!=.
g attrit_20112014=(_merge17==1) if _merge17!=2 & _merge17!=. & _merge16!=2 & _merge16!=. & _merge15!=2 & _merge15!=. & _merge14!=1 & _merge14!=.

*Over four years 
g attrit_19972001=(_merge4==1) if _merge4!=2 & _merge4!=. & _merge3!=2 & _merge3!=. & _merge2!=2 & _merge2!=. & _merge!=2 & _merge!=.
g attrit_19982002=(_merge5==1) if _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=2 & _merge3!=. & _merge2!=2  & _merge2!=. & _merge!=1 & _merge!=.
g attrit_19992003=(_merge6==1) if _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=2 & _merge3!=. & _merge2!=1 & _merge2!=.
g attrit_20002004=(_merge7==1) if _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=1 & _merge3!=.
g attrit_20012005=(_merge8==1) if _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=1 & _merge4!=.
g attrit_20022006=(_merge9==1) if _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=1 & _merge5!=.
g attrit_20032007=(_merge10==1) if _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=1 & _merge6!=.
g attrit_20042008=(_merge11==1) if _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=1 & _merge7!=.
g attrit_20052009=(_merge12==1) if _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=1 & _merge8!=.
g attrit_20062010=(_merge13==1) if _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=1 & _merge9!=.
g attrit_20072011=(_merge14==1) if _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=1 & _merge10!=.
g attrit_20082012=(_merge15==1) if _merge15!=2 & _merge15!=. & _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=1 & _merge11!=.
g attrit_20092013=(_merge16==1) if _merge16!=2 & _merge16!=. & _merge15!=2 & _merge15!=. & _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=1 & _merge12!=.
g attrit_20102014=(_merge17==1) if _merge17!=2 & _merge17!=. & _merge16!=2 & _merge16!=. & _merge15!=2 & _merge15!=. & _merge14!=2 & _merge14!=. & _merge13!=1 & _merge13!=.

*Over five years 
g attrit_19972002=(_merge5==1) if _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=2 & _merge3!=. & _merge2!=2 & _merge2!=. & _merge!=2 & _merge!=.
g attrit_19982003=(_merge6==1) if _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=2 & _merge3!=. & _merge2!=2 & _merge2!=. & _merge!=1 & _merge!=.
g attrit_19992004=(_merge7==1) if _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=2 & _merge3!=. & _merge2!=1 & _merge2!=.
g attrit_20002005=(_merge8==1) if _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=1 & _merge3!=.
g attrit_20012006=(_merge9==1) if _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=1 & _merge4!=.
g attrit_20022007=(_merge10==1) if _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=1 & _merge5!=.
g attrit_20032008=(_merge11==1) if _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=1 & _merge6!=.
g attrit_20042009=(_merge12==1) if _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=1 & _merge7!=.
g attrit_20052010=(_merge13==1) if _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=1 & _merge8!=.
g attrit_20062011=(_merge14==1) if _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=1 & _merge9!=.
g attrit_20072012=(_merge15==1) if _merge15!=2 & _merge15!=. & _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=1 & _merge10!=.
g attrit_20082013=(_merge16==1) if _merge16!=2 & _merge16!=. & _merge15!=2 & _merge15!=. & _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=1 & _merge11!=.
g attrit_20092014=(_merge17==1) if _merge17!=2 & _merge17!=. & _merge16!=2 & _merge16!=. & _merge15!=2 & _merge15!=. & _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=1 & _merge12!=.

*Over six years 
g attrit_19972003=(_merge6==1) if _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=2 & _merge3!=. & _merge2!=2 & _merge2!=. & _merge!=2 & _merge!=.
g attrit_19982004=(_merge7==1) if _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=2 & _merge3!=. & _merge2!=2 & _merge2!=. & _merge!=1 & _merge!=.
g attrit_19992005=(_merge8==1) if _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=2 & _merge3!=. & _merge2!=1 & _merge2!=.
g attrit_20002006=(_merge9==1) if _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=1 & _merge3!=.
g attrit_20012007=(_merge10==1) if _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=1 & _merge4!=.
g attrit_20022008=(_merge11==1) if _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=1 & _merge5!=.
g attrit_20032009=(_merge12==1) if _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=1 & _merge6!=.
g attrit_20042010=(_merge13==1) if _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=1 & _merge7!=.
g attrit_20052011=(_merge14==1) if _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=1 & _merge8!=.
g attrit_20062012=(_merge15==1) if _merge15!=2 & _merge15!=. & _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=1 & _merge9!=.
g attrit_20072013=(_merge16==1) if _merge16!=2 & _merge16!=. & _merge15!=2 & _merge15!=. & _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=1 & _merge10!=.
g attrit_20082014=(_merge17==1) if _merge17!=2 & _merge17!=. & _merge16!=2 & _merge16!=. & _merge15!=2 & _merge15!=. & _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=1 & _merge11!=.

*Over seven years 
g attrit_19972004=(_merge7==1) if _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=2 & _merge3!=. & _merge2!=2 & _merge2!=. & _merge!=2 & _merge!=.
g attrit_19982005=(_merge8==1) if _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=2 & _merge3!=. & _merge2!=2 & _merge2!=. & _merge!=1 & _merge!=.
g attrit_19992006=(_merge9==1) if _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=2 & _merge3!=. & _merge2!=1 & _merge2!=.
g attrit_20002007=(_merge10==1) if _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=1 & _merge3!=.
g attrit_20012008=(_merge11==1) if _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=1 & _merge4!=.
g attrit_20022009=(_merge12==1) if _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=1 & _merge5!=.
g attrit_20032010=(_merge13==1) if _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=1 & _merge6!=.
g attrit_20042011=(_merge14==1) if _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=1 & _merge7!=.
g attrit_20052012=(_merge15==1) if _merge15!=2 & _merge15!=. & _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=1 & _merge8!=.
g attrit_20062013=(_merge16==1) if _merge16!=2 & _merge16!=. & _merge15!=2 & _merge15!=. & _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=1 & _merge9!=.
g attrit_20072014=(_merge17==1) if _merge17!=2 & _merge17!=. & _merge16!=2 & _merge16!=. & _merge15!=2 & _merge15!=. & _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=1 & _merge10!=.

*Over eight years 
g attrit_19972005=(_merge8==1) if _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=2 & _merge3!=. & _merge2!=2 & _merge2!=. & _merge!=2 & _merge!=.
g attrit_19982006=(_merge9==1) if _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=2 & _merge3!=. & _merge2!=2 & _merge2!=. & _merge!=1 & _merge!=.
g attrit_19992007=(_merge10==1) if _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=2 & _merge3!=. & _merge2!=1 & _merge2!=.
g attrit_20002008=(_merge11==1) if _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=1 & _merge3!=.
g attrit_20012009=(_merge12==1) if _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=1 & _merge4!=.
g attrit_20022010=(_merge13==1) if _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=1 & _merge5!=.
g attrit_20032011=(_merge14==1) if _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=1 & _merge6!=.
g attrit_20042012=(_merge15==1) if _merge15!=2 & _merge15!=. & _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=1 & _merge7!=.
g attrit_20052013=(_merge16==1) if _merge16!=2 & _merge16!=. & _merge15!=2 & _merge15!=. & _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=1 & _merge8!=.
g attrit_20062014=(_merge17==1) if _merge17!=2 & _merge17!=. & _merge16!=2 & _merge16!=. & _merge15!=2 & _merge15!=. & _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=1 & _merge9!=.

*Over nine years 
g attrit_19972006=(_merge9==1) if _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=2 & _merge3!=. & _merge2!=2 & _merge2!=. & _merge!=2 & _merge!=.
g attrit_19982007=(_merge10==1) if _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=2 & _merge3!=. & _merge2!=2 & _merge2!=. & _merge!=1 & _merge!=.
g attrit_19992008=(_merge11==1) if _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=2 & _merge3!=. & _merge2!=1 & _merge2!=.
g attrit_20002009=(_merge12==1) if _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=1 & _merge3!=.
g attrit_20012010=(_merge13==1) if _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=1 & _merge4!=.
g attrit_20022011=(_merge14==1) if _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. &_merge5!=1 & _merge5!=.
g attrit_20032012=(_merge15==1) if _merge15!=2 & _merge15!=. & _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=1 & _merge6!=.
g attrit_20042013=(_merge16==1) if _merge16!=2 & _merge16!=. & _merge15!=2 & _merge15!=. & _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=1 & _merge7!=.
g attrit_20052014=(_merge17==1) if _merge17!=2 & _merge17!=. & _merge16!=2 & _merge16!=. & _merge15!=2 & _merge15!=. & _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=1 & _merge8!=.

*Over ten years 
g attrit_19972007=(_merge10==1) if _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=2 & _merge3!=. & _merge2!=2 & _merge2!=. & _merge!=2 & _merge!=.
g attrit_19982008=(_merge11==1) if _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=2 & _merge3!=. & _merge2!=2 & _merge2!=. & _merge!=1 & _merge!=.
g attrit_19992009=(_merge12==1) if _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=2 & _merge3!=. & _merge2!=1 & _merge2!=.
g attrit_20002010=(_merge13==1) if _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=1 & _merge3!=.
g attrit_20012011=(_merge14==1) if _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=1 & _merge4!=.
g attrit_20022012=(_merge15==1) if _merge15!=2 & _merge15!=. & _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=1 & _merge5!=.
g attrit_20032013=(_merge16==1) if _merge16!=2 & _merge16!=. & _merge15!=2 & _merge15!=. & _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=1 & _merge6!=.
g attrit_20042014=(_merge17==1) if _merge17!=2 & _merge17!=. & _merge16!=2 & _merge16!=. & _merge15!=2 & _merge15!=. & _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=1 & _merge7!=.

*Over eleven years 
g attrit_19972008=(_merge11==1) if _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=2 & _merge3!=. & _merge2!=2 & _merge2!=. & _merge!=2 & _merge!=.
g attrit_19982009=(_merge12==1) if _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=2 & _merge3!=. & _merge2!=2 & _merge2!=. & _merge!=1 & _merge!=.
g attrit_19992010=(_merge13==1) if _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=2 & _merge3!=. & _merge2!=1 & _merge2!=.
g attrit_20002011=(_merge14==1) if _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=1 & _merge3!=.
g attrit_20012012=(_merge15==1) if _merge15!=2 & _merge15!=. & _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=1 & _merge4!=.
g attrit_20022013=(_merge16==1) if _merge16!=2 & _merge16!=. & _merge15!=2 & _merge15!=. & _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=1 & _merge5!=.
g attrit_20032014=(_merge17==1) if _merge17!=2 & _merge17!=. & _merge16!=2 & _merge16!=. & _merge15!=2 & _merge15!=. & _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=1 & _merge6!=.

*Over twelve years 
g attrit_19972009=(_merge12==1) if _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=2 & _merge3!=. & _merge2!=2 & _merge2!=. &  _merge!=2 & _merge!=.
g attrit_19982010=(_merge13==1) if _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=2 & _merge3!=. & _merge2!=2 & _merge2!=. & _merge!=1 & _merge!=.
g attrit_19992011=(_merge14==1) if _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=2 & _merge3!=. & _merge2!=1 & _merge2!=.
g attrit_20002012=(_merge15==1) if _merge15!=2 & _merge15!=. & _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=1 & _merge3!=.
g attrit_20012013=(_merge16==1) if _merge16!=2 & _merge16!=. & _merge15!=2 & _merge15!=. & _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=1 & _merge4!=.
g attrit_20022014=(_merge17==1) if _merge17!=2 & _merge17!=. & _merge16!=2 & _merge16!=. & _merge15!=2 & _merge15!=. & _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=1 & _merge5!=.

*Over 13 years 
g attrit_19972010=(_merge13==1) if _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=2 & _merge3!=. & _merge2!=2 & _merge2!=. & _merge!=2 & _merge!=.
g attrit_19982011=(_merge14==1) if _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=2 & _merge3!=. & _merge2!=2 & _merge2!=. & _merge!=1 & _merge!=.
g attrit_19992012=(_merge15==1) if _merge15!=2 & _merge15!=. & _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=2 & _merge3!=. & _merge2!=1 & _merge2!=.
g attrit_20002013=(_merge16==1) if _merge16!=2 & _merge16!=. & _merge15!=2 & _merge15!=. & _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=1 & _merge3!=.
g attrit_20012014=(_merge17==1) if _merge17!=2 & _merge17!=. & _merge16!=2 & _merge16!=. & _merge15!=2 & _merge15!=. & _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=1 & _merge4!=.

*Over 14 years 
g attrit_19972011=(_merge14==1) if _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=2 & _merge3!=. & _merge2!=2 & _merge2!=. & _merge!=2 & _merge!=.
g attrit_19982012=(_merge15==1) if _merge15!=2 & _merge15!=. & _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=2 & _merge3!=. & _merge2!=2 & _merge2!=. & _merge!=1 & _merge!=.
g attrit_19992013=(_merge16==1) if _merge16!=2 & _merge16!=. & _merge15!=2 & _merge15!=. & _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=2 & _merge3!=. & _merge2!=1 & _merge2!=.
g attrit_20002014=(_merge17==1) if _merge17!=2 & _merge17!=. & _merge16!=2 & _merge16!=. & _merge15!=2 & _merge15!=. & _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=1 & _merge3!=.

*Over 15 years 
g attrit_19972012=(_merge15==1) if _merge15!=2 & _merge15!=. & _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=2 & _merge3!=. & _merge2!=2 & _merge2!=. & _merge!=2 & _merge!=.
g attrit_19982013=(_merge16==1) if _merge16!=2 & _merge16!=. & _merge15!=2 & _merge15!=. & _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=2 & _merge3!=. & _merge2!=2 & _merge2!=. & _merge!=1 & _merge!=.
g attrit_19992014=(_merge17==1) if _merge17!=2 & _merge17!=. & _merge16!=2 & _merge16!=. & _merge15!=2 & _merge15!=. & _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=2 & _merge3!=. & _merge2!=1 & _merge2!=.

*Over 15 years 
g attrit_19972013=(_merge16==1) if _merge16!=2 & _merge16!=. & _merge15!=2 & _merge15!=. & _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=2 & _merge3!=. & _merge2!=2 & _merge2!=. & _merge!=2 & _merge!=.
g attrit_19982014=(_merge17==1) if _merge17!=2 & _merge17!=. & _merge16!=2 & _merge16!=. & _merge15!=2 & _merge15!=. & _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=2 & _merge3!=. & _merge2!=2 & _merge2!=. & _merge!=1 & _merge!=.

*Over 16 years 
g attrit_19972014=(_merge17==1) if _merge17!=2 & _merge17!=. & _merge16!=2 & _merge16!=. & _merge15!=2 & _merge15!=. & _merge14!=2 & _merge14!=. & _merge13!=2 & _merge13!=. & _merge12!=2 & _merge12!=. & _merge11!=2 & _merge11!=. & _merge10!=2 & _merge10!=. & _merge9!=2 & _merge9!=. & _merge8!=2 & _merge8!=. & _merge7!=2 & _merge7!=. & _merge6!=2 & _merge6!=. & _merge5!=2 & _merge5!=. & _merge4!=2 & _merge4!=. & _merge3!=2 & _merge3!=. & _merge2!=2 & _merge2!=. & _merge!=2 & _merge!=.

*TO DO: decide whether you need/want to change path for saving "TTHAImaster"
/**/
save TTHAImaster, replace
/**/

********************************************************************************
*Survival over one year
********************************************************************************
*TO DO: change path to where you saved the following file "TTHAImaster.dta"
/*EXAMPLE*/
use TTHAImaster,clear
/**/

set more off
forvalues i=1997(1)2013{
local j=`i'+1
g survival_`i'`j'=0 if hhbus_`i'==1 & hhbus_`j'==0 & tbdropped_`i'==0 & tbdropped_`j'==0
g newfirmstarted_`i'`j'=0 if hhbus_`i'==1 &  hhbus_`j'==0 & tbdropped_`i'==0 & tbdropped_`j'==0

/*A firm is coded as surviving in 1998 if the household had one firm in 1997 and
 one firm in 1998, and the ages of of the businesses correspond*/
replace survival_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'==agefirm_`j'-1 & agefirm_`i'!=. & agefirm_`j'!=.

/* A firm is coded as as a new firm if the startdate in 1998 was given as being after 1997.
	Survival is coded as missing in that case*/
replace newfirmstarted_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'!=agefirm_`j'-1 & agefirm_`j'<=1
replace newfirmstarted_`i'`j'=0 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'==agefirm_`j'-1 & agefirm_`i'!=. & agefirm_`j'!=. 
replace newfirmstarted_`i'`j'=1 if hhbus_`i'==0 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`j'<=1
replace newfirmstarted_`i'`j'=0 if hhbus_`i'==0 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`j'>1 & agefirm_`j'!=.

/*If the sector of the business remains the same across both waves, but the ages of 
the businesses do not coincide, I code the business as surviving.*/
replace survival_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'!=agefirm_`j'-1 & agefirm_`j'>1 & agefirm_`j'!=. & ((retail_`i'==retail_`j' & retail_`i'==1)| (manuf_`i'==manuf_`j' & manuf_`i'==1) | (services_`i'==services_`j' & services_`i'==1)| (othersector_`i'==othersector_`j' & othersector_`i'==1)) 

/*There remain seven households which have different firm ages, but they are over 
1 year in 1998, and different business sectors.*/
/* If at least one owner remains the same across both waves, and firm ages and 
business sectors do not coincide ,I code the business as surviving.*/
egen help1=rowtotal(hhbusowner_`i' hhbusowner_`j') if (hhbus_`i'==1 | hhbus_`j'==1 ) & tbdropped_`i'==0 & tbdropped_`j'==0 & survival_`i'`j'==. & newfirmstarted_`i'`j'==.
bysort newid: egen help2=max(help1) if (hhbus_`i'==1 | hhbus_`j'==1 ) & tbdropped_`i'==0 & tbdropped_`j'==0 & survival_`i'`j'==. & newfirmstarted_`i'`j'==.
replace survival_`i'`j'=1 if help2==2
drop help*


*Create a variable for inclusion of jointly operated businesses only once:
*If the household operates a business at baseline and the individual is owner in each of the two rounds considered
egen help1=rowtotal(hhbusowner_`i' hhbusowner_`j') if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
bysort newid: egen help2=max(help1) if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
g help3=(help1==help2) if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
duplicates tag newid help3 if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1), gen(dupl)
g incl_`i'`j'=1 if dupl==0 & help3==1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
replace incl_`i'`j'=0 if dupl==0 & help3==0 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)

sort newid hc_id
bysort newid: egen help4=seq() if dupl>0 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1) 
replace incl_`i'`j'=1 if help4==1 & help3==1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
replace incl_`i'`j'=0 if help4>1 & help4!=. & help3!=1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)

drop help* dupl

*TO DO: decide whether you need/want to change path for saving "TTHAImasterfc"
/**/
save TTHAImasterfc, replace
/**/
}

********************************************************************************
*Survival over two years
********************************************************************************
 
set more off
forvalues i=1997(1)2012{
local j=`i'+2
g survival_`i'`j'=0 if hhbus_`i'==1 & hhbus_`j'==0 & tbdropped_`i'==0 & tbdropped_`j'==0
g newfirmstarted_`i'`j'=0 if hhbus_`i'==1 &  hhbus_`j'==0 & tbdropped_`i'==0 & tbdropped_`j'==0

/*A firm is coded as surviving in 1998 if the household had one firm in 1997 and
 one firm in 1998, and the ages of of the businesses are correspond*/
replace survival_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'==agefirm_`j'-2 & agefirm_`i'!=. & agefirm_`j'!=.

/* A firm is coded as as a new firm if the startdate in 1998 was given as being after 1997.
	Survival is coded as missing in that case*/
replace newfirmstarted_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'!=agefirm_`j'-2 & agefirm_`j'<=2
replace newfirmstarted_`i'`j'=0 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'==agefirm_`j'-2 & agefirm_`i'!=. & agefirm_`j'!=. 
replace newfirmstarted_`i'`j'=1 if hhbus_`i'==0 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`j'<=2
replace newfirmstarted_`i'`j'=0 if hhbus_`i'==0 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`j'>2 & agefirm_`j'!=.

/*If the sector of the business remains the same across both waves, but the ages of 
the businesses do not coincide, I code the business as surviving.*/
replace survival_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'!=agefirm_`j'-2 & agefirm_`j'>2 & agefirm_`j'!=. & ((retail_`i'==retail_`j' & retail_`i'==1)| (manuf_`i'==manuf_`j' & manuf_`i'==1) | (services_`i'==services_`j' & services_`i'==1)| (othersector_`i'==othersector_`j' & othersector_`i'==1)) 

/*There remain seven households which have different firm ages, but they are over 
1 year in 1998, and different business sectors.*/
/* If at least one owner remains the same across both waves, and firm ages and 
business sectors do not coincide ,I code the business as surviving.*/
egen help1=rowtotal(hhbusowner_`i' hhbusowner_`j') if (hhbus_`i'==1 | hhbus_`j'==1 ) & tbdropped_`i'==0 & tbdropped_`j'==0 & survival_`i'`j'==. & newfirmstarted_`i'`j'==.
bysort newid: egen help2=max(help1) if (hhbus_`i'==1 | hhbus_`j'==1 ) & tbdropped_`i'==0 & tbdropped_`j'==0 & survival_`i'`j'==. & newfirmstarted_`i'`j'==.
replace survival_`i'`j'=1 if help2==2
drop help*


*Create a variable for inclusion of jointly operated businesses only once:
*If the household operates a business at baseline and the individual is owner in each of the two rounds considered
egen help1=rowtotal(hhbusowner_`i' hhbusowner_`j') if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
bysort newid: egen help2=max(help1) if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
g help3=(help1==help2) if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
duplicates tag newid help3 if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1), gen(dupl)
g incl_`i'`j'=1 if dupl==0 & help3==1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
replace incl_`i'`j'=0 if dupl==0 & help3==0 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)

sort newid hc_id
bysort newid: egen help4=seq() if dupl>0 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1) 
replace incl_`i'`j'=1 if help4==1 & help3==1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
replace incl_`i'`j'=0 if help4>1 & help4!=. & help3!=1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)

drop help* dupl

*TO DO: decide whether you need/want to change path for saving "TTHAImasterfc"
/**/
save TTHAImasterfc, replace
/**/
}

********************************************************************************
*Survival over three years
********************************************************************************

set more off
forvalues i=1997(1)2011{
local j=`i'+3
g survival_`i'`j'=0 if hhbus_`i'==1 & hhbus_`j'==0 & tbdropped_`i'==0 & tbdropped_`j'==0
g newfirmstarted_`i'`j'=0 if hhbus_`i'==1 &  hhbus_`j'==0 & tbdropped_`i'==0 & tbdropped_`j'==0

/*A firm is coded as surviving in 1998 if the household had one firm in 1997 and
 one firm in 1998, and the ages of of the businesses are correspond*/
replace survival_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'==agefirm_`j'-3 & agefirm_`i'!=. & agefirm_`j'!=.

/* A firm is coded as as a new firm if the startdate in 1998 was given as being after 1997.
	Survival is coded as missing in that case*/
replace newfirmstarted_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'!=agefirm_`j'-3 & agefirm_`j'<=3
replace newfirmstarted_`i'`j'=0 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'==agefirm_`j'-3 & agefirm_`i'!=. & agefirm_`j'!=. 
replace newfirmstarted_`i'`j'=1 if hhbus_`i'==0 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`j'<=3
replace newfirmstarted_`i'`j'=0 if hhbus_`i'==0 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`j'>3 & agefirm_`j'!=.

/*If the sector of the business remains the same across both waves, but the ages of 
the businesses do not coincide, I code the business as surviving.*/
replace survival_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'!=agefirm_`j'-3 & agefirm_`j'>3 & agefirm_`j'!=. & ((retail_`i'==retail_`j' & retail_`i'==1)| (manuf_`i'==manuf_`j' & manuf_`i'==1) | (services_`i'==services_`j' & services_`i'==1)| (othersector_`i'==othersector_`j' & othersector_`i'==1)) 

/*There remain seven households which have different firm ages, but they are over 
1 year in 1998, and different business sectors.*/
/* If at least one owner remains the same across both waves, and firm ages and 
business sectors do not coincide ,I code the business as surviving.*/
egen help1=rowtotal(hhbusowner_`i' hhbusowner_`j') if (hhbus_`i'==1 | hhbus_`j'==1 ) & tbdropped_`i'==0 & tbdropped_`j'==0 & survival_`i'`j'==. & newfirmstarted_`i'`j'==.
bysort newid: egen help2=max(help1) if (hhbus_`i'==1 | hhbus_`j'==1 ) & tbdropped_`i'==0 & tbdropped_`j'==0 & survival_`i'`j'==. & newfirmstarted_`i'`j'==.
replace survival_`i'`j'=1 if help2==2
drop help*


*Create a variable for inclusion of jointly operated businesses only once:
*If the household operates a business at baseline and the individual is owner in each of the two rounds considered
egen help1=rowtotal(hhbusowner_`i' hhbusowner_`j') if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
bysort newid: egen help2=max(help1) if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
g help3=(help1==help2) if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
duplicates tag newid help3 if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1), gen(dupl)
g incl_`i'`j'=1 if dupl==0 & help3==1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
replace incl_`i'`j'=0 if dupl==0 & help3==0 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)

sort newid hc_id
bysort newid: egen help4=seq() if dupl>0 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1) 
replace incl_`i'`j'=1 if help4==1 & help3==1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
replace incl_`i'`j'=0 if help4>1 & help4!=. & help3!=1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)

drop help* dupl

*TO DO: decide whether you need/want to change path for saving "TTHAImasterfc"
/**/
save TTHAImasterfc, replace
/**/
}

********************************************************************************
*Survival over four years
********************************************************************************

set more off
forvalues i=1997(1)2010{
local j=`i'+4
g survival_`i'`j'=0 if hhbus_`i'==1 & hhbus_`j'==0 & tbdropped_`i'==0 & tbdropped_`j'==0
g newfirmstarted_`i'`j'=0 if hhbus_`i'==1 &  hhbus_`j'==0 & tbdropped_`i'==0 & tbdropped_`j'==0

/*A firm is coded as surviving in 1998 if the household had one firm in 1997 and
 one firm in 1998, and the ages of of the businesses are correspond*/
replace survival_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'==agefirm_`j'-4 & agefirm_`i'!=. & agefirm_`j'!=.

/* A firm is coded as as a new firm if the startdate in 1998 was given as being after 1997.
	Survival is coded as missing in that case*/
replace newfirmstarted_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'!=agefirm_`j'-4 & agefirm_`j'<=4
replace newfirmstarted_`i'`j'=0 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'==agefirm_`j'-4 & agefirm_`i'!=. & agefirm_`j'!=. 
replace newfirmstarted_`i'`j'=1 if hhbus_`i'==0 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`j'<=4
replace newfirmstarted_`i'`j'=0 if hhbus_`i'==0 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`j'>4 & agefirm_`j'!=.

/*If the sector of the business remains the same across both waves, but the ages of 
the businesses do not coincide, I code the business as surviving.*/
replace survival_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'!=agefirm_`j'-4 & agefirm_`j'>4 & agefirm_`j'!=. & ((retail_`i'==retail_`j' & retail_`i'==1)| (manuf_`i'==manuf_`j' & manuf_`i'==1) | (services_`i'==services_`j' & services_`i'==1)| (othersector_`i'==othersector_`j' & othersector_`i'==1)) 

/*There remain seven households which have different firm ages, but they are over 
1 year in 1998, and different business sectors.*/
/* If at least one owner remains the same across both waves, and firm ages and 
business sectors do not coincide ,I code the business as surviving.*/
egen help1=rowtotal(hhbusowner_`i' hhbusowner_`j') if (hhbus_`i'==1 | hhbus_`j'==1 ) & tbdropped_`i'==0 & tbdropped_`j'==0 & survival_`i'`j'==. & newfirmstarted_`i'`j'==.
bysort newid: egen help2=max(help1) if (hhbus_`i'==1 | hhbus_`j'==1 ) & tbdropped_`i'==0 & tbdropped_`j'==0 & survival_`i'`j'==. & newfirmstarted_`i'`j'==.
replace survival_`i'`j'=1 if help2==2
drop help*

*Create a variable for inclusion of jointly operated businesses only once:
*If the household operates a business at baseline and the individual is owner in each of the two rounds considered
egen help1=rowtotal(hhbusowner_`i' hhbusowner_`j') if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
bysort newid: egen help2=max(help1) if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
g help3=(help1==help2) if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
duplicates tag newid help3 if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1), gen(dupl)
g incl_`i'`j'=1 if dupl==0 & help3==1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
replace incl_`i'`j'=0 if dupl==0 & help3==0 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)

sort newid hc_id
bysort newid: egen help4=seq() if dupl>0 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1) 
replace incl_`i'`j'=1 if help4==1 & help3==1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
replace incl_`i'`j'=0 if help4>1 & help4!=. & help3!=1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)

drop help* dupl

*TO DO: decide whether you need/want to change path for saving "TTHAImasterfc"
/**/
save TTHAImasterfc, replace
/**/
}

********************************************************************************
*Survival over five years 
********************************************************************************
set more off
forvalues i=1997(1)2009{
local j=`i'+5
g survival_`i'`j'=0 if hhbus_`i'==1 & hhbus_`j'==0 & tbdropped_`i'==0 & tbdropped_`j'==0
g newfirmstarted_`i'`j'=0 if hhbus_`i'==1 &  hhbus_`j'==0 & tbdropped_`i'==0 & tbdropped_`j'==0

/*A firm is coded as surviving in 1998 if the household had one firm in 1997 and
 one firm in 1998, and the ages of of the businesses are correspond*/
replace survival_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'==agefirm_`j'-5 & agefirm_`i'!=. & agefirm_`j'!=.

/* A firm is coded as as a new firm if the startdate in 1998 was given as being after 1997.
	Survival is coded as missing in that case*/
replace newfirmstarted_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'!=agefirm_`j'-5 & agefirm_`j'<=5
replace newfirmstarted_`i'`j'=0 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'==agefirm_`j'-5 & agefirm_`i'!=. & agefirm_`j'!=. 
replace newfirmstarted_`i'`j'=1 if hhbus_`i'==0 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`j'<=5
replace newfirmstarted_`i'`j'=0 if hhbus_`i'==0 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`j'>5 & agefirm_`j'!=.

/*If the sector of the business remains the same across both waves, but the ages of 
the businesses do not coincide, I code the business as surviving.*/
replace survival_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'!=agefirm_`j'-5 & agefirm_`j'>5 & agefirm_`j'!=. & ((retail_`i'==retail_`j' & retail_`i'==1)| (manuf_`i'==manuf_`j' & manuf_`i'==1) | (services_`i'==services_`j' & services_`i'==1)| (othersector_`i'==othersector_`j' & othersector_`i'==1)) 

/*There remain seven households which have different firm ages, but they are over 
1 year in 1998, and different business sectors.*/
/* If at least one owner remains the same across both waves, and firm ages and 
business sectors do not coincide ,I code the business as surviving.*/
egen help1=rowtotal(hhbusowner_`i' hhbusowner_`j') if (hhbus_`i'==1 | hhbus_`j'==1 ) & tbdropped_`i'==0 & tbdropped_`j'==0 & survival_`i'`j'==. & newfirmstarted_`i'`j'==.
bysort newid: egen help2=max(help1) if (hhbus_`i'==1 | hhbus_`j'==1 ) & tbdropped_`i'==0 & tbdropped_`j'==0 & survival_`i'`j'==. & newfirmstarted_`i'`j'==.
replace survival_`i'`j'=1 if help2==2
drop help*

*Create a variable for inclusion of jointly operated businesses only once:
*If the household operates a business at baseline and the individual is owner in each of the two rounds considered
egen help1=rowtotal(hhbusowner_`i' hhbusowner_`j') if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
bysort newid: egen help2=max(help1) if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
g help3=(help1==help2) if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
duplicates tag newid help3 if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1), gen(dupl)
g incl_`i'`j'=1 if dupl==0 & help3==1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
replace incl_`i'`j'=0 if dupl==0 & help3==0 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)

sort newid hc_id
bysort newid: egen help4=seq() if dupl>0 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1) 
replace incl_`i'`j'=1 if help4==1 & help3==1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
replace incl_`i'`j'=0 if help4>1 & help4!=. & help3!=1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)

drop help* dupl

*TO DO: decide whether you need/want to change path for saving "TTHAImasterfc"
/**/
save TTHAImasterfc, replace
/**/
}

	
********************************************************************************
*Survival over six years
********************************************************************************
set more off
forvalues i=1997(1)2008{
local j=`i'+6
g survival_`i'`j'=0 if hhbus_`i'==1 & hhbus_`j'==0 & tbdropped_`i'==0 & tbdropped_`j'==0
g newfirmstarted_`i'`j'=0 if hhbus_`i'==1 &  hhbus_`j'==0 & tbdropped_`i'==0 & tbdropped_`j'==0

/*A firm is coded as surviving in 1998 if the household had one firm in 1997 and
 one firm in 1998, and the ages of of the businesses are correspond*/
replace survival_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'==agefirm_`j'-6 & agefirm_`i'!=. & agefirm_`j'!=.

/* A firm is coded as as a new firm if the startdate in 1998 was given as being after 1997.
	Survival is coded as missing in that case*/
replace newfirmstarted_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'!=agefirm_`j'-6 & agefirm_`j'<=6
replace newfirmstarted_`i'`j'=0 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'==agefirm_`j'-6 & agefirm_`i'!=. & agefirm_`j'!=. 
replace newfirmstarted_`i'`j'=1 if hhbus_`i'==0 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`j'<=6
replace newfirmstarted_`i'`j'=0 if hhbus_`i'==0 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`j'>6 & agefirm_`j'!=.

/*If the sector of the business remains the same across both waves, but the ages of 
the businesses do not coincide, I code the business as surviving.*/
replace survival_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'!=agefirm_`j'-6 & agefirm_`j'>6 & agefirm_`j'!=. & ((retail_`i'==retail_`j' & retail_`i'==1)| (manuf_`i'==manuf_`j' & manuf_`i'==1) | (services_`i'==services_`j' & services_`i'==1)| (othersector_`i'==othersector_`j' & othersector_`i'==1)) 

/*There remain seven households which have different firm ages, but they are over 
1 year in 1998, and different business sectors.*/
/* If at least one owner remains the same across both waves, and firm ages and 
business sectors do not coincide ,I code the business as surviving.*/
egen help1=rowtotal(hhbusowner_`i' hhbusowner_`j') if (hhbus_`i'==1 | hhbus_`j'==1 ) & tbdropped_`i'==0 & tbdropped_`j'==0 & survival_`i'`j'==. & newfirmstarted_`i'`j'==.
bysort newid: egen help2=max(help1) if (hhbus_`i'==1 | hhbus_`j'==1 ) & tbdropped_`i'==0 & tbdropped_`j'==0 & survival_`i'`j'==. & newfirmstarted_`i'`j'==.
replace survival_`i'`j'=1 if help2==2
drop help*

*Create a variable for inclusion of jointly operated businesses only once:
*If the household operates a business at baseline and the individual is owner in each of the two rounds considered
egen help1=rowtotal(hhbusowner_`i' hhbusowner_`j') if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
bysort newid: egen help2=max(help1) if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
g help3=(help1==help2) if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
duplicates tag newid help3 if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1), gen(dupl)
g incl_`i'`j'=1 if dupl==0 & help3==1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
replace incl_`i'`j'=0 if dupl==0 & help3==0 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)

sort newid hc_id
bysort newid: egen help4=seq() if dupl>0 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1) 
replace incl_`i'`j'=1 if help4==1 & help3==1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
replace incl_`i'`j'=0 if help4>1 & help4!=. & help3!=1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)

drop help* dupl

*TO DO: decide whether you need/want to change path for saving "TTHAImasterfc"
/**/
save TTHAImasterfc, replace
/**/
}
	
********************************************************************************
*Survival over seven years
********************************************************************************

set more off
forvalues i=1997(1)2007{
local j=`i'+7
g survival_`i'`j'=0 if hhbus_`i'==1 & hhbus_`j'==0 & tbdropped_`i'==0 & tbdropped_`j'==0
g newfirmstarted_`i'`j'=0 if hhbus_`i'==1 &  hhbus_`j'==0 & tbdropped_`i'==0 & tbdropped_`j'==0

/*A firm is coded as surviving in 1998 if the household had one firm in 1997 and
 one firm in 1998, and the ages of of the businesses are correspond*/
replace survival_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'==agefirm_`j'-7 & agefirm_`i'!=. & agefirm_`j'!=.

/* A firm is coded as as a new firm if the startdate in 1998 was given as being after 1997.
	Survival is coded as missing in that case*/
replace newfirmstarted_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'!=agefirm_`j'-7 & agefirm_`j'<=7
replace newfirmstarted_`i'`j'=0 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'==agefirm_`j'-7 & agefirm_`i'!=. & agefirm_`j'!=. 
replace newfirmstarted_`i'`j'=1 if hhbus_`i'==0 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`j'<=7
replace newfirmstarted_`i'`j'=0 if hhbus_`i'==0 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`j'>7 & agefirm_`j'!=.

/*If the sector of the business remains the same across both waves, but the ages of 
the businesses do not coincide, I code the business as surviving.*/
replace survival_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'!=agefirm_`j'-7 & agefirm_`j'>7 & agefirm_`j'!=. & ((retail_`i'==retail_`j' & retail_`i'==1)| (manuf_`i'==manuf_`j' & manuf_`i'==1) | (services_`i'==services_`j' & services_`i'==1)| (othersector_`i'==othersector_`j' & othersector_`i'==1)) 

/*There remain seven households which have different firm ages, but they are over 
1 year in 1998, and different business sectors.*/
/* If at least one owner remains the same across both waves, and firm ages and 
business sectors do not coincide ,I code the business as surviving.*/
egen help1=rowtotal(hhbusowner_`i' hhbusowner_`j') if (hhbus_`i'==1 | hhbus_`j'==1 ) & tbdropped_`i'==0 & tbdropped_`j'==0 & survival_`i'`j'==. & newfirmstarted_`i'`j'==.
bysort newid: egen help2=max(help1) if (hhbus_`i'==1 | hhbus_`j'==1 ) & tbdropped_`i'==0 & tbdropped_`j'==0 & survival_`i'`j'==. & newfirmstarted_`i'`j'==.
replace survival_`i'`j'=1 if help2==2
drop help*

*Create a variable for inclusion of jointly operated businesses only once:
*If the household operates a business at baseline and the individual is owner in each of the two rounds considered
egen help1=rowtotal(hhbusowner_`i' hhbusowner_`j') if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
bysort newid: egen help2=max(help1) if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
g help3=(help1==help2) if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
duplicates tag newid help3 if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1), gen(dupl)
g incl_`i'`j'=1 if dupl==0 & help3==1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
replace incl_`i'`j'=0 if dupl==0 & help3==0 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)

sort newid hc_id
bysort newid: egen help4=seq() if dupl>0 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1) 
replace incl_`i'`j'=1 if help4==1 & help3==1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
replace incl_`i'`j'=0 if help4>1 & help4!=. & help3!=1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)

drop help* dupl

*TO DO: decide whether you need/want to change path for saving "TTHAImasterfc"
/**/
save TTHAImasterfc, replace
/**/
}

********************************************************************************
*Survival over eight years
********************************************************************************
set more off
forvalues i=1997(1)2006{
local j=`i'+8
g survival_`i'`j'=0 if hhbus_`i'==1 & hhbus_`j'==0 & tbdropped_`i'==0 & tbdropped_`j'==0
g newfirmstarted_`i'`j'=0 if hhbus_`i'==1 &  hhbus_`j'==0 & tbdropped_`i'==0 & tbdropped_`j'==0

/*A firm is coded as surviving in 1998 if the household had one firm in 1997 and
 one firm in 1998, and the ages of of the businesses are correspond*/
replace survival_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'==agefirm_`j'-8 & agefirm_`i'!=. & agefirm_`j'!=.

/* A firm is coded as as a new firm if the startdate in 1998 was given as being after 1997.
	Survival is coded as missing in that case*/
replace newfirmstarted_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'!=agefirm_`j'-8 & agefirm_`j'<=8
replace newfirmstarted_`i'`j'=0 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'==agefirm_`j'-8 & agefirm_`i'!=. & agefirm_`j'!=. 
replace newfirmstarted_`i'`j'=1 if hhbus_`i'==0 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`j'<=8
replace newfirmstarted_`i'`j'=0 if hhbus_`i'==0 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`j'>8 & agefirm_`j'!=.

/*If the sector of the business remains the same across both waves, but the ages of 
the businesses do not coincide, I code the business as surviving.*/
replace survival_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'!=agefirm_`j'-8 & agefirm_`j'>8 & agefirm_`j'!=. & ((retail_`i'==retail_`j' & retail_`i'==1)| (manuf_`i'==manuf_`j' & manuf_`i'==1) | (services_`i'==services_`j' & services_`i'==1)| (othersector_`i'==othersector_`j' & othersector_`i'==1)) 

/*There remain seven households which have different firm ages, but they are over 
1 year in 1998, and different business sectors.*/
/* If at least one owner remains the same across both waves, and firm ages and 
business sectors do not coincide ,I code the business as surviving.*/
egen help1=rowtotal(hhbusowner_`i' hhbusowner_`j') if (hhbus_`i'==1 | hhbus_`j'==1 ) & tbdropped_`i'==0 & tbdropped_`j'==0 & survival_`i'`j'==. & newfirmstarted_`i'`j'==.
bysort newid: egen help2=max(help1) if (hhbus_`i'==1 | hhbus_`j'==1 ) & tbdropped_`i'==0 & tbdropped_`j'==0 & survival_`i'`j'==. & newfirmstarted_`i'`j'==.
replace survival_`i'`j'=1 if help2==2
drop help*


*Create a variable for inclusion of jointly operated businesses only once:
*If the household operates a business at baseline and the individual is owner in each of the two rounds considered
egen help1=rowtotal(hhbusowner_`i' hhbusowner_`j') if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
bysort newid: egen help2=max(help1) if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
g help3=(help1==help2) if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
duplicates tag newid help3 if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1), gen(dupl)
g incl_`i'`j'=1 if dupl==0 & help3==1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
replace incl_`i'`j'=0 if dupl==0 & help3==0 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)

sort newid hc_id
bysort newid: egen help4=seq() if dupl>0 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1) 
replace incl_`i'`j'=1 if help4==1 & help3==1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
replace incl_`i'`j'=0 if help4>1 & help4!=. & help3!=1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)

drop help* dupl

*TO DO: decide whether you need/want to change path for saving "TTHAImasterfc"
/**/
save TTHAImasterfc, replace
/**/
}

********************************************************************************
*Survival over nine years
********************************************************************************
set more off
forvalues i=1997(1)2005{
local j=`i'+9
g survival_`i'`j'=0 if hhbus_`i'==1 & hhbus_`j'==0 & tbdropped_`i'==0 & tbdropped_`j'==0
g newfirmstarted_`i'`j'=0 if hhbus_`i'==1 &  hhbus_`j'==0 & tbdropped_`i'==0 & tbdropped_`j'==0

/*A firm is coded as surviving in 1998 if the household had one firm in 1997 and
 one firm in 1998, and the ages of of the businesses are correspond*/
replace survival_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'==agefirm_`j'-9 & agefirm_`i'!=. & agefirm_`j'!=.

/* A firm is coded as as a new firm if the startdate in 1998 was given as being after 1997.
	Survival is coded as missing in that case*/
replace newfirmstarted_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'!=agefirm_`j'-9 & agefirm_`j'<=9
replace newfirmstarted_`i'`j'=0 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'==agefirm_`j'-9 & agefirm_`i'!=. & agefirm_`j'!=. 
replace newfirmstarted_`i'`j'=1 if hhbus_`i'==0 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`j'<=9
replace newfirmstarted_`i'`j'=0 if hhbus_`i'==0 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`j'>9 & agefirm_`j'!=.

/*If the sector of the business remains the same across both waves, but the ages of 
the businesses do not coincide, I code the business as surviving.*/
replace survival_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'!=agefirm_`j'-9 & agefirm_`j'>9 & agefirm_`j'!=. & ((retail_`i'==retail_`j' & retail_`i'==1)| (manuf_`i'==manuf_`j' & manuf_`i'==1) | (services_`i'==services_`j' & services_`i'==1)| (othersector_`i'==othersector_`j' & othersector_`i'==1)) 

/*There remain seven households which have different firm ages, but they are over 
1 year in 1998, and different business sectors.*/
/* If at least one owner remains the same across both waves, and firm ages and 
business sectors do not coincide ,I code the business as surviving.*/
egen help1=rowtotal(hhbusowner_`i' hhbusowner_`j') if (hhbus_`i'==1 | hhbus_`j'==1 ) & tbdropped_`i'==0 & tbdropped_`j'==0 & survival_`i'`j'==. & newfirmstarted_`i'`j'==.
bysort newid: egen help2=max(help1) if (hhbus_`i'==1 | hhbus_`j'==1 ) & tbdropped_`i'==0 & tbdropped_`j'==0 & survival_`i'`j'==. & newfirmstarted_`i'`j'==.
replace survival_`i'`j'=1 if help2==2
drop help*

*Create a variable for inclusion of jointly operated businesses only once:
*If the household operates a business at baseline and the individual is owner in each of the two rounds considered
egen help1=rowtotal(hhbusowner_`i' hhbusowner_`j') if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
bysort newid: egen help2=max(help1) if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
g help3=(help1==help2) if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
duplicates tag newid help3 if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1), gen(dupl)
g incl_`i'`j'=1 if dupl==0 & help3==1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
replace incl_`i'`j'=0 if dupl==0 & help3==0 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)

sort newid hc_id
bysort newid: egen help4=seq() if dupl>0 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1) 
replace incl_`i'`j'=1 if help4==1 & help3==1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
replace incl_`i'`j'=0 if help4>1 & help4!=. & help3!=1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)

drop help* dupl

*TO DO: decide whether you need/want to change path for saving "TTHAImasterfc"
/**/
save TTHAImasterfc, replace
/**/
}

********************************************************************************
*Survival over ten years
********************************************************************************
set more off
forvalues i=1997(1)2004{
local j=`i'+10
g survival_`i'`j'=0 if hhbus_`i'==1 & hhbus_`j'==0 & tbdropped_`i'==0 & tbdropped_`j'==0
g newfirmstarted_`i'`j'=0 if hhbus_`i'==1 &  hhbus_`j'==0 & tbdropped_`i'==0 & tbdropped_`j'==0

/*A firm is coded as surviving in 1998 if the household had one firm in 1997 and
 one firm in 1998, and the ages of of the businesses are correspond*/
replace survival_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'==agefirm_`j'-10 & agefirm_`i'!=. & agefirm_`j'!=.

/* A firm is coded as as a new firm if the startdate in 1998 was given as being after 1997.
	Survival is coded as missing in that case*/
replace newfirmstarted_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'!=agefirm_`j'-10 & agefirm_`j'<=10
replace newfirmstarted_`i'`j'=0 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'==agefirm_`j'-10 & agefirm_`i'!=. & agefirm_`j'!=. 
replace newfirmstarted_`i'`j'=1 if hhbus_`i'==0 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`j'<=10
replace newfirmstarted_`i'`j'=0 if hhbus_`i'==0 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`j'>10 & agefirm_`j'!=.

/*If the sector of the business remains the same across both waves, but the ages of 
the businesses do not coincide, I code the business as surviving.*/
replace survival_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'!=agefirm_`j'-10 & agefirm_`j'>10 & agefirm_`j'!=. & ((retail_`i'==retail_`j' & retail_`i'==1)| (manuf_`i'==manuf_`j' & manuf_`i'==1) | (services_`i'==services_`j' & services_`i'==1)| (othersector_`i'==othersector_`j' & othersector_`i'==1)) 

/*There remain seven households which have different firm ages, but they are over 
1 year in 1998, and different business sectors.*/
/* If at least one owner remains the same across both waves, and firm ages and 
business sectors do not coincide ,I code the business as surviving.*/
egen help1=rowtotal(hhbusowner_`i' hhbusowner_`j') if (hhbus_`i'==1 | hhbus_`j'==1 ) & tbdropped_`i'==0 & tbdropped_`j'==0 & survival_`i'`j'==. & newfirmstarted_`i'`j'==.
bysort newid: egen help2=max(help1) if (hhbus_`i'==1 | hhbus_`j'==1 ) & tbdropped_`i'==0 & tbdropped_`j'==0 & survival_`i'`j'==. & newfirmstarted_`i'`j'==.
replace survival_`i'`j'=1 if help2==2
drop help*

*Create a variable for inclusion of jointly operated businesses only once:
*If the household operates a business at baseline and the individual is owner in each of the two rounds considered
egen help1=rowtotal(hhbusowner_`i' hhbusowner_`j') if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
bysort newid: egen help2=max(help1) if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
g help3=(help1==help2) if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
duplicates tag newid help3 if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1), gen(dupl)
g incl_`i'`j'=1 if dupl==0 & help3==1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
replace incl_`i'`j'=0 if dupl==0 & help3==0 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)

sort newid hc_id
bysort newid: egen help4=seq() if dupl>0 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1) 
replace incl_`i'`j'=1 if help4==1 & help3==1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
replace incl_`i'`j'=0 if help4>1 & help4!=. & help3!=1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)

drop help* dupl

*TO DO: decide whether you need/want to change path for saving "TTHAImasterfc"
/**/
save TTHAImasterfc, replace
/**/
}

********************************************************************************
*Survival over eleven years
********************************************************************************
set more off
forvalues i=1997(1)2003{
local j=`i'+11
g survival_`i'`j'=0 if hhbus_`i'==1 & hhbus_`j'==0 & tbdropped_`i'==0 & tbdropped_`j'==0
g newfirmstarted_`i'`j'=0 if hhbus_`i'==1 &  hhbus_`j'==0 & tbdropped_`i'==0 & tbdropped_`j'==0

/*A firm is coded as surviving in 1998 if the household had one firm in 1997 and
 one firm in 1998, and the ages of of the businesses are correspond*/
replace survival_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'==agefirm_`j'-11 & agefirm_`i'!=. & agefirm_`j'!=.

/* A firm is coded as as a new firm if the startdate in 1998 was given as being after 1997.
	Survival is coded as missing in that case*/
replace newfirmstarted_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'!=agefirm_`j'-11 & agefirm_`j'<=11
replace newfirmstarted_`i'`j'=0 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'==agefirm_`j'-11 & agefirm_`i'!=. & agefirm_`j'!=. 
replace newfirmstarted_`i'`j'=1 if hhbus_`i'==0 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`j'<=11
replace newfirmstarted_`i'`j'=0 if hhbus_`i'==0 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`j'>11 & agefirm_`j'!=.

/*If the sector of the business remains the same across both waves, but the ages of 
the businesses do not coincide, I code the business as surviving.*/
replace survival_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'!=agefirm_`j'-11 & agefirm_`j'>11 & agefirm_`j'!=. & ((retail_`i'==retail_`j' & retail_`i'==1)| (manuf_`i'==manuf_`j' & manuf_`i'==1) | (services_`i'==services_`j' & services_`i'==1)| (othersector_`i'==othersector_`j' & othersector_`i'==1)) 

/*There remain seven households which have different firm ages, but they are over 
1 year in 1998, and different business sectors.*/
/* If at least one owner remains the same across both waves, and firm ages and 
business sectors do not coincide ,I code the business as surviving.*/
egen help1=rowtotal(hhbusowner_`i' hhbusowner_`j') if (hhbus_`i'==1 | hhbus_`j'==1 ) & tbdropped_`i'==0 & tbdropped_`j'==0 & survival_`i'`j'==. & newfirmstarted_`i'`j'==.
bysort newid: egen help2=max(help1) if (hhbus_`i'==1 | hhbus_`j'==1 ) & tbdropped_`i'==0 & tbdropped_`j'==0 & survival_`i'`j'==. & newfirmstarted_`i'`j'==.
replace survival_`i'`j'=1 if help2==2
drop help*

*Create a variable for inclusion of jointly operated businesses only once:
*If the household operates a business at baseline and the individual is owner in each of the two rounds considered
egen help1=rowtotal(hhbusowner_`i' hhbusowner_`j') if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
bysort newid: egen help2=max(help1) if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
g help3=(help1==help2) if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
duplicates tag newid help3 if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1), gen(dupl)
g incl_`i'`j'=1 if dupl==0 & help3==1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
replace incl_`i'`j'=0 if dupl==0 & help3==0 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)

sort newid hc_id
bysort newid: egen help4=seq() if dupl>0 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1) 
replace incl_`i'`j'=1 if help4==1 & help3==1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
replace incl_`i'`j'=0 if help4>1 & help4!=. & help3!=1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)

drop help* dupl

*TO DO: decide whether you need/want to change path for saving "TTHAImasterfc"
/**/
save TTHAImasterfc, replace
/**/
}


********************************************************************************
*Survival over twelve years
********************************************************************************
set more off
forvalues i=1997(1)2002{
local j=`i'+12
g survival_`i'`j'=0 if hhbus_`i'==1 & hhbus_`j'==0 & tbdropped_`i'==0 & tbdropped_`j'==0
g newfirmstarted_`i'`j'=0 if hhbus_`i'==1 &  hhbus_`j'==0 & tbdropped_`i'==0 & tbdropped_`j'==0

/*A firm is coded as surviving in 1998 if the household had one firm in 1997 and
 one firm in 1998, and the ages of of the businesses are correspond*/
replace survival_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'==agefirm_`j'-12 & agefirm_`i'!=. & agefirm_`j'!=.

/* A firm is coded as as a new firm if the startdate in 1998 was given as being after 1997.
	Survival is coded as missing in that case*/
replace newfirmstarted_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'!=agefirm_`j'-12 & agefirm_`j'<=12
replace newfirmstarted_`i'`j'=0 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'==agefirm_`j'-12 & agefirm_`i'!=. & agefirm_`j'!=. 
replace newfirmstarted_`i'`j'=1 if hhbus_`i'==0 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`j'<=12
replace newfirmstarted_`i'`j'=0 if hhbus_`i'==0 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`j'>12 & agefirm_`j'!=.

/*If the sector of the business remains the same across both waves, but the ages of 
the businesses do not coincide, I code the business as surviving.*/
replace survival_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'!=agefirm_`j'-12 & agefirm_`j'>12 & agefirm_`j'!=. & ((retail_`i'==retail_`j' & retail_`i'==1)| (manuf_`i'==manuf_`j' & manuf_`i'==1) | (services_`i'==services_`j' & services_`i'==1)| (othersector_`i'==othersector_`j' & othersector_`i'==1)) 

/*There remain seven households which have different firm ages, but they are over 
1 year in 1998, and different business sectors.*/
/* If at least one owner remains the same across both waves, and firm ages and 
business sectors do not coincide ,I code the business as surviving.*/
egen help1=rowtotal(hhbusowner_`i' hhbusowner_`j') if (hhbus_`i'==1 | hhbus_`j'==1 ) & tbdropped_`i'==0 & tbdropped_`j'==0 & survival_`i'`j'==. & newfirmstarted_`i'`j'==.
bysort newid: egen help2=max(help1) if (hhbus_`i'==1 | hhbus_`j'==1 ) & tbdropped_`i'==0 & tbdropped_`j'==0 & survival_`i'`j'==. & newfirmstarted_`i'`j'==.
replace survival_`i'`j'=1 if help2==2
drop help*


*Create a variable for inclusion of jointly operated businesses only once:
*If the household operates a business at baseline and the individual is owner in each of the two rounds considered
egen help1=rowtotal(hhbusowner_`i' hhbusowner_`j') if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
bysort newid: egen help2=max(help1) if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
g help3=(help1==help2) if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
duplicates tag newid help3 if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1), gen(dupl)
g incl_`i'`j'=1 if dupl==0 & help3==1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
replace incl_`i'`j'=0 if dupl==0 & help3==0 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)

sort newid hc_id
bysort newid: egen help4=seq() if dupl>0 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1) 
replace incl_`i'`j'=1 if help4==1 & help3==1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
replace incl_`i'`j'=0 if help4>1 & help4!=. & help3!=1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)

drop help* dupl

*TO DO: decide whether you need/want to change path for saving "TTHAImasterfc"
/**/
save TTHAImasterfc, replace
/**/
}

********************************************************************************
*Survival over thirteen years
********************************************************************************
set more off
forvalues i=1997(1)2001{
local j=`i'+13
g survival_`i'`j'=0 if hhbus_`i'==1 & hhbus_`j'==0 & tbdropped_`i'==0 & tbdropped_`j'==0
g newfirmstarted_`i'`j'=0 if hhbus_`i'==1 &  hhbus_`j'==0 & tbdropped_`i'==0 & tbdropped_`j'==0

/*A firm is coded as surviving in 1998 if the household had one firm in 1997 and
 one firm in 1998, and the ages of of the businesses are correspond*/
replace survival_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'==agefirm_`j'-13 & agefirm_`i'!=. & agefirm_`j'!=.

/* A firm is coded as as a new firm if the startdate in 1998 was given as being after 1997.
	Survival is coded as missing in that case*/
replace newfirmstarted_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'!=agefirm_`j'-13 & agefirm_`j'<=13
replace newfirmstarted_`i'`j'=0 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'==agefirm_`j'-13 & agefirm_`i'!=. & agefirm_`j'!=. 
replace newfirmstarted_`i'`j'=1 if hhbus_`i'==0 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`j'<=13
replace newfirmstarted_`i'`j'=0 if hhbus_`i'==0 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`j'>13 & agefirm_`j'!=.

/*If the sector of the business remains the same across both waves, but the ages of 
the businesses do not coincide, I code the business as surviving.*/
replace survival_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'!=agefirm_`j'-13 & agefirm_`j'>13 & agefirm_`j'!=. & ((retail_`i'==retail_`j' & retail_`i'==1)| (manuf_`i'==manuf_`j' & manuf_`i'==1) | (services_`i'==services_`j' & services_`i'==1)| (othersector_`i'==othersector_`j' & othersector_`i'==1)) 

/*There remain seven households which have different firm ages, but they are over 
1 year in 1998, and different business sectors.*/
/* If at least one owner remains the same across both waves, and firm ages and 
business sectors do not coincide ,I code the business as surviving.*/
egen help1=rowtotal(hhbusowner_`i' hhbusowner_`j') if (hhbus_`i'==1 | hhbus_`j'==1 ) & tbdropped_`i'==0 & tbdropped_`j'==0 & survival_`i'`j'==. & newfirmstarted_`i'`j'==.
bysort newid: egen help2=max(help1) if (hhbus_`i'==1 | hhbus_`j'==1 ) & tbdropped_`i'==0 & tbdropped_`j'==0 & survival_`i'`j'==. & newfirmstarted_`i'`j'==.
replace survival_`i'`j'=1 if help2==2
drop help*

*Create a variable for inclusion of jointly operated businesses only once:
*If the household operates a business at baseline and the individual is owner in each of the two rounds considered
egen help1=rowtotal(hhbusowner_`i' hhbusowner_`j') if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
bysort newid: egen help2=max(help1) if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
g help3=(help1==help2) if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
duplicates tag newid help3 if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1), gen(dupl)
g incl_`i'`j'=1 if dupl==0 & help3==1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
replace incl_`i'`j'=0 if dupl==0 & help3==0 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)

sort newid hc_id
bysort newid: egen help4=seq() if dupl>0 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1) 
replace incl_`i'`j'=1 if help4==1 & help3==1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
replace incl_`i'`j'=0 if help4>1 & help4!=. & help3!=1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)

drop help* dupl

*TO DO: decide whether you need/want to change path for saving "TTHAImasterfc"
/**/
save TTHAImasterfc, replace
/**/
}


********************************************************************************
*Survival over fourteen years
********************************************************************************
set more off
forvalues i=1997(1)2000{
local j=`i'+14
g survival_`i'`j'=0 if hhbus_`i'==1 & hhbus_`j'==0 & tbdropped_`i'==0 & tbdropped_`j'==0
g newfirmstarted_`i'`j'=0 if hhbus_`i'==1 &  hhbus_`j'==0 & tbdropped_`i'==0 & tbdropped_`j'==0

/*A firm is coded as surviving in 1998 if the household had one firm in 1997 and
 one firm in 1998, and the ages of of the businesses are correspond*/
replace survival_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'==agefirm_`j'-14 & agefirm_`i'!=. & agefirm_`j'!=.

/* A firm is coded as as a new firm if the startdate in 1998 was given as being after 1997.
	Survival is coded as missing in that case*/
replace newfirmstarted_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'!=agefirm_`j'-14 & agefirm_`j'<=14
replace newfirmstarted_`i'`j'=0 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'==agefirm_`j'-14 & agefirm_`i'!=. & agefirm_`j'!=. 
replace newfirmstarted_`i'`j'=1 if hhbus_`i'==0 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`j'<=14
replace newfirmstarted_`i'`j'=0 if hhbus_`i'==0 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`j'>14 & agefirm_`j'!=.

/*If the sector of the business remains the same across both waves, but the ages of 
the businesses do not coincide, I code the business as surviving.*/
replace survival_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'!=agefirm_`j'-14 & agefirm_`j'>14 & agefirm_`j'!=. & ((retail_`i'==retail_`j' & retail_`i'==1)| (manuf_`i'==manuf_`j' & manuf_`i'==1) | (services_`i'==services_`j' & services_`i'==1)| (othersector_`i'==othersector_`j' & othersector_`i'==1)) 

/*There remain seven households which have different firm ages, but they are over 
1 year in 1998, and different business sectors.*/
/* If at least one owner remains the same across both waves, and firm ages and 
business sectors do not coincide ,I code the business as surviving.*/
egen help1=rowtotal(hhbusowner_`i' hhbusowner_`j') if (hhbus_`i'==1 | hhbus_`j'==1 ) & tbdropped_`i'==0 & tbdropped_`j'==0 & survival_`i'`j'==. & newfirmstarted_`i'`j'==.
bysort newid: egen help2=max(help1) if (hhbus_`i'==1 | hhbus_`j'==1 ) & tbdropped_`i'==0 & tbdropped_`j'==0 & survival_`i'`j'==. & newfirmstarted_`i'`j'==.
replace survival_`i'`j'=1 if help2==2
drop help*

*Create a variable for inclusion of jointly operated businesses only once:
*If the household operates a business at baseline and the individual is owner in each of the two rounds considered
egen help1=rowtotal(hhbusowner_`i' hhbusowner_`j') if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
bysort newid: egen help2=max(help1) if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
g help3=(help1==help2) if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
duplicates tag newid help3 if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1), gen(dupl)
g incl_`i'`j'=1 if dupl==0 & help3==1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
replace incl_`i'`j'=0 if dupl==0 & help3==0 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)

sort newid hc_id
bysort newid: egen help4=seq() if dupl>0 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1) 
replace incl_`i'`j'=1 if help4==1 & help3==1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
replace incl_`i'`j'=0 if help4>1 & help4!=. & help3!=1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)

drop help* dupl

*TO DO: decide whether you need/want to change path for saving "TTHAImasterfc"
/**/
save TTHAImasterfc, replace
/**/
}


********************************************************************************
*Survival over fifteen years
********************************************************************************
set more off
forvalues i=1997(1)1999{
local j=`i'+15
g survival_`i'`j'=0 if hhbus_`i'==1 & hhbus_`j'==0 & tbdropped_`i'==0 & tbdropped_`j'==0
g newfirmstarted_`i'`j'=0 if hhbus_`i'==1 &  hhbus_`j'==0 & tbdropped_`i'==0 & tbdropped_`j'==0

/*A firm is coded as surviving in 1998 if the household had one firm in 1997 and
 one firm in 1998, and the ages of of the businesses are correspond*/
replace survival_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'==agefirm_`j'-15 & agefirm_`i'!=. & agefirm_`j'!=.

/* A firm is coded as as a new firm if the startdate in 1998 was given as being after 1997.
	Survival is coded as missing in that case*/
replace newfirmstarted_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'!=agefirm_`j'-15 & agefirm_`j'<=15
replace newfirmstarted_`i'`j'=0 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'==agefirm_`j'-15 & agefirm_`i'!=. & agefirm_`j'!=. 
replace newfirmstarted_`i'`j'=1 if hhbus_`i'==0 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`j'<=15
replace newfirmstarted_`i'`j'=0 if hhbus_`i'==0 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`j'>15 & agefirm_`j'!=.

/*If the sector of the business remains the same across both waves, but the ages of 
the businesses do not coincide, I code the business as surviving.*/
replace survival_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'!=agefirm_`j'-15 & agefirm_`j'>15 & agefirm_`j'!=. & ((retail_`i'==retail_`j' & retail_`i'==1)| (manuf_`i'==manuf_`j' & manuf_`i'==1) | (services_`i'==services_`j' & services_`i'==1)| (othersector_`i'==othersector_`j' & othersector_`i'==1)) 

/*There remain seven households which have different firm ages, but they are over 
1 year in 1998, and different business sectors.*/
/* If at least one owner remains the same across both waves, and firm ages and 
business sectors do not coincide ,I code the business as surviving.*/
egen help1=rowtotal(hhbusowner_`i' hhbusowner_`j') if (hhbus_`i'==1 | hhbus_`j'==1 ) & tbdropped_`i'==0 & tbdropped_`j'==0 & survival_`i'`j'==. & newfirmstarted_`i'`j'==.
bysort newid: egen help2=max(help1) if (hhbus_`i'==1 | hhbus_`j'==1 ) & tbdropped_`i'==0 & tbdropped_`j'==0 & survival_`i'`j'==. & newfirmstarted_`i'`j'==.
replace survival_`i'`j'=1 if help2==2
drop help*


*Create a variable for inclusion of jointly operated businesses only once:
*If the household operates a business at baseline and the individual is owner in each of the two rounds considered
egen help1=rowtotal(hhbusowner_`i' hhbusowner_`j') if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
bysort newid: egen help2=max(help1) if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
g help3=(help1==help2) if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
duplicates tag newid help3 if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1), gen(dupl)
g incl_`i'`j'=1 if dupl==0 & help3==1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
replace incl_`i'`j'=0 if dupl==0 & help3==0 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)

sort newid hc_id
bysort newid: egen help4=seq() if dupl>0 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1) 
replace incl_`i'`j'=1 if help4==1 & help3==1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
replace incl_`i'`j'=0 if help4>1 & help4!=. & help3!=1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)

drop help* dupl

*TO DO: decide whether you need/want to change path for saving "TTHAImasterfc"
/**/
save TTHAImasterfc, replace
/**/
}

********************************************************************************
*Survival over sixteen years
********************************************************************************
set more off
forvalues i=1997(1)1998{
local j=`i'+16
g survival_`i'`j'=0 if hhbus_`i'==1 & hhbus_`j'==0 & tbdropped_`i'==0 & tbdropped_`j'==0
g newfirmstarted_`i'`j'=0 if hhbus_`i'==1 &  hhbus_`j'==0 & tbdropped_`i'==0 & tbdropped_`j'==0

/*A firm is coded as surviving in 1998 if the household had one firm in 1997 and
 one firm in 1998, and the ages of of the businesses are correspond*/
replace survival_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'==agefirm_`j'-16 & agefirm_`i'!=. & agefirm_`j'!=.

/* A firm is coded as as a new firm if the startdate in 1998 was given as being after 1997.
	Survival is coded as missing in that case*/
replace newfirmstarted_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'!=agefirm_`j'-16 & agefirm_`j'<=16
replace newfirmstarted_`i'`j'=0 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'==agefirm_`j'-16 & agefirm_`i'!=. & agefirm_`j'!=. 
replace newfirmstarted_`i'`j'=1 if hhbus_`i'==0 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`j'<=16
replace newfirmstarted_`i'`j'=0 if hhbus_`i'==0 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`j'>16 & agefirm_`j'!=.

/*If the sector of the business remains the same across both waves, but the ages of 
the businesses do not coincide, I code the business as surviving.*/
replace survival_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'!=agefirm_`j'-16 & agefirm_`j'>16 & agefirm_`j'!=. & ((retail_`i'==retail_`j' & retail_`i'==1)| (manuf_`i'==manuf_`j' & manuf_`i'==1) | (services_`i'==services_`j' & services_`i'==1)| (othersector_`i'==othersector_`j' & othersector_`i'==1)) 

/*There remain seven households which have different firm ages, but they are over 
1 year in 1998, and different business sectors.*/
/* If at least one owner remains the same across both waves, and firm ages and 
business sectors do not coincide ,I code the business as surviving.*/
egen help1=rowtotal(hhbusowner_`i' hhbusowner_`j') if (hhbus_`i'==1 | hhbus_`j'==1 ) & tbdropped_`i'==0 & tbdropped_`j'==0 & survival_`i'`j'==. & newfirmstarted_`i'`j'==.
bysort newid: egen help2=max(help1) if (hhbus_`i'==1 | hhbus_`j'==1 ) & tbdropped_`i'==0 & tbdropped_`j'==0 & survival_`i'`j'==. & newfirmstarted_`i'`j'==.
replace survival_`i'`j'=1 if help2==2
drop help*


*Create a variable for inclusion of jointly operated businesses only once:
*If the household operates a business at baseline and the individual is owner in each of the two rounds considered
egen help1=rowtotal(hhbusowner_`i' hhbusowner_`j') if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
bysort newid: egen help2=max(help1) if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
g help3=(help1==help2) if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
duplicates tag newid help3 if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1), gen(dupl)
g incl_`i'`j'=1 if dupl==0 & help3==1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
replace incl_`i'`j'=0 if dupl==0 & help3==0 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)

sort newid hc_id
bysort newid: egen help4=seq() if dupl>0 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1) 
replace incl_`i'`j'=1 if help4==1 & help3==1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
replace incl_`i'`j'=0 if help4>1 & help4!=. & help3!=1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)

drop help* dupl

*TO DO: decide whether you need/want to change path for saving "TTHAImasterfc"
/**/
save TTHAImasterfc, replace
/**/
}


********************************************************************************
*Survival over seventeen years
********************************************************************************
set more off
local i=1997
local j=`i'+17
g survival_`i'`j'=0 if hhbus_`i'==1 & hhbus_`j'==0 & tbdropped_`i'==0 & tbdropped_`j'==0
g newfirmstarted_`i'`j'=0 if hhbus_`i'==1 &  hhbus_`j'==0 & tbdropped_`i'==0 & tbdropped_`j'==0

/*A firm is coded as surviving in 1998 if the household had one firm in 1997 and
 one firm in 1998, and the ages of of the businesses are correspond*/
replace survival_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'==agefirm_`j'-17 & agefirm_`i'!=. & agefirm_`j'!=.

/* A firm is coded as as a new firm if the startdate in 1998 was given as being after 1997.
	Survival is coded as missing in that case*/
replace newfirmstarted_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'!=agefirm_`j'-17 & agefirm_`j'<=17
replace newfirmstarted_`i'`j'=0 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'==agefirm_`j'-17 & agefirm_`i'!=. & agefirm_`j'!=. 
replace newfirmstarted_`i'`j'=1 if hhbus_`i'==0 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`j'<=17
replace newfirmstarted_`i'`j'=0 if hhbus_`i'==0 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`j'>17 & agefirm_`j'!=.

/*If the sector of the business remains the same across both waves, but the ages of 
the businesses do not coincide, I code the business as surviving.*/
replace survival_`i'`j'=1 if hhbus_`i'==1 & hhbus_`j'==1 & tbdropped_`i'==0 & tbdropped_`j'==0 & agefirm_`i'!=agefirm_`j'-17 & agefirm_`j'>17 & agefirm_`j'!=. & ((retail_`i'==retail_`j' & retail_`i'==1)| (manuf_`i'==manuf_`j' & manuf_`i'==1) | (services_`i'==services_`j' & services_`i'==1)| (othersector_`i'==othersector_`j' & othersector_`i'==1)) 

/*There remain seven households which have different firm ages, but they are over 
1 year in 1998, and different business sectors.*/
/* If at least one owner remains the same across both waves, and firm ages and 
business sectors do not coincide ,I code the business as surviving.*/
egen help1=rowtotal(hhbusowner_`i' hhbusowner_`j') if (hhbus_`i'==1 | hhbus_`j'==1 ) & tbdropped_`i'==0 & tbdropped_`j'==0 & survival_`i'`j'==. & newfirmstarted_`i'`j'==.
bysort newid: egen help2=max(help1) if (hhbus_`i'==1 | hhbus_`j'==1 ) & tbdropped_`i'==0 & tbdropped_`j'==0 & survival_`i'`j'==. & newfirmstarted_`i'`j'==.
replace survival_`i'`j'=1 if help2==2
drop help*


*Create a variable for inclusion of jointly operated businesses only once:
*If the household operates a business at baseline and the individual is owner in each of the two rounds considered
egen help1=rowtotal(hhbusowner_`i' hhbusowner_`j') if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
bysort newid: egen help2=max(help1) if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
g help3=(help1==help2) if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
duplicates tag newid help3 if hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1), gen(dupl)
g incl_`i'`j'=1 if dupl==0 & help3==1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
replace incl_`i'`j'=0 if dupl==0 & help3==0 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)

sort newid hc_id
bysort newid: egen help4=seq() if dupl>0 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1) 
replace incl_`i'`j'=1 if help4==1 & help3==1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)
replace incl_`i'`j'=0 if help4>1 & help4!=. & help3!=1 & hhbus_`i'==1 & (hhbusowner_`i'==1 | hhbusowner_`j'==1)

drop help* dupl

*TO DO: decide whether you need/want to change path for saving "TTHAImasterfc"
/**/
save TTHAImasterfc, replace
/**/

*RESHAPE:
drop _merge* subcounty province line_id
order newid hc_id country

quietly: reshape long wageworker_ laborincome_ retired_ sales_ ownerage_ educyears_ ownertertiary_ mfj_ childunder5_ childaged5to12_ adult65andover_ married_ wave_ surveyyear_ hhbus_ newfirmquex_ enf_bus_ nonfarm_ typeofbus_ retail_ manuf_ services_ othersector_ agefirm_ employees_ totalworkers_ expenses_ profits_  totalowners_ jointbus_ pcexpend_ excrate_ excratemonth_, i(newid hc_id) j(survey)

foreach x in wageworker laborincome retired sales ownerage ownertertiary educyears mfj childunder5 childaged5to12 adult65andover married wave surveyyear hhbus newfirmquex enf_bus nonfarm typeofbus retail manuf services othersector agefirm employees totalworkers expenses profits totalowners jointbus pcexpend excrate excratemonth{
rename `x'_ `x'
}

set more off
*Generate a variable that gives the reason for closure for the business that has been closed
*(Given that this question is only asked in the subsequent round, I need to code it back to the round in which the business that will be closed, is reported)
g hhbusclosure=.
g typeofbusclosed=.
forvalues i=1998/2014{
local j=`i'-1
replace hhbusclosure=hhbusclosure_`i' if surveyyear==`j'
replace typeofbusclosed=typeofbusclosed_`i' if surveyyear==`j'
drop hhbusclosure_`i' typeofbusclosed_`i'
}

rename reasonforclosure1_1998 reasonforclosure_1998

g reasonforclosure=""
foreach i in 1998 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014{
local j=`i'-1
replace reasonforclosure=reasonforclosure_`i' if surveyyear==`j'
drop reasonforclosure_`i'
}
forvalues k=2/4{
g reasonforclosure`k'=""
replace reasonforclosure`k'=reasonforclosure`k'_1998 if surveyyear==1997
drop reasonforclosure`k'_1998
}

*TO DO: decide whether you need/want to change path for saving "TTHAImasterfc"
/**/
save TTHAImasterfc, replace
/**/

*Keep if household operates a business at (respective) baseline 	
keep if hhbus==1 & nonfarm==1
*Drop if household operates more than one business in any of the rounds
drop if tbdropped_1997==1 | tbdropped_1998==1 | tbdropped_1999==1 | tbdropped_2000==1 | tbdropped_2001==1 | tbdropped_2002==1 | tbdropped_2003==1 | tbdropped_2004==1 | tbdropped_2005==1 | tbdropped_2006==1 | tbdropped_2007==1 | tbdropped_2008==1 | tbdropped_2009==1 | tbdropped_2010==1 | tbdropped_2011==1 | tbdropped_2012==1 | tbdropped_2013==1 | tbdropped_2014==1
*Keep the businessowners:
keep if hhbusowner_1997==1 | hhbusowner_1998==1 | hhbusowner_1999==1 | hhbusowner_2000==1 | hhbusowner_2001==1 | hhbusowner_2002==1 | hhbusowner_2003==1 | hhbusowner_2004==1 | hhbusowner_2005==1 | hhbusowner_2006==1 | hhbusowner_2007==1 | hhbusowner_2008==1 | hhbusowner_2009==1 | hhbusowner_2010==1 | hhbusowner_2011==1 | hhbusowner_2012==1 | hhbusowner_2013==1


g attrit_1yr=.
g survival_1yr=.
g newfirmstarted_1yr=.
g help_1yr=.

forvalues i=1997(1)2013{
local j=`i'+1
replace attrit_1yr=attrit_`i'`j' if surveyyear==`i'
replace survival_1yr=survival_`i'`j'  if surveyyear==`i'
replace newfirmstarted_1yr=newfirmstarted_`i'`j'  if surveyyear==`i'

replace help_1yr=1 if ((tbdropped_`i'==1 | tbdropped_`i'==.) | ((tbdropped_`j'==1 | tbdropped_`j'==.) & attrit_`i'`j'==0)) & surveyyear==`i'


drop attrit_`i'`j' survival_`i'`j' newfirmstarted_`i'`j' incl_`i'`j' 
}



forvalues k=2(1)16{

g attrit_`k'yrs=.
g survival_`k'yrs=.
g newfirmstarted_`k'yrs=.
g help_`k'yrs=.


local l=2014-`k'
forvalues i=1997(1)`l'{
local j=`i'+`k'
replace attrit_`k'yrs=attrit_`i'`j' if surveyyear==`i'
replace survival_`k'yrs=survival_`i'`j' if surveyyear==`i'
replace newfirmstarted_`k'yrs=newfirmstarted_`i'`j' if surveyyear==`i'

replace help_`k'yrs=1 if ((tbdropped_`i'==1 | tbdropped_`i'==.) | ((tbdropped_`j'==1 | tbdropped_`j'==.) & attrit_`i'`j'==0)) & surveyyear==`i'


drop attrit_`i'`j' survival_`i'`j' newfirmstarted_`i'`j' incl_`i'`j' 
}
}

g attrit_17yrs=.
g survival_17yrs=.
g newfirmstarted_17yrs=.
g help_17yrs=.

replace attrit_17yrs=attrit_19972014 if surveyyear==1997
replace survival_17yrs=survival_19972014 if surveyyear==1997
replace newfirmstarted_17yrs=newfirmstarted_19972014 if surveyyear==1997

replace help_17yrs=1 if ((tbdropped_1997==1 | tbdropped_1997==.) | ((tbdropped_2014==1 | tbdropped_2014==.) & attrit_19972014==0)) & surveyyear==1997


drop attrit_19972014 survival_19972014 newfirmstarted_19972014 incl_19972014 /*help_19972014*/

drop if help_1yr==1 | help_2yrs==1 | help_3yrs==1 | help_4yrs==1 | help_5yrs==1 | help_6yrs==1 | help_7yrs==1 | help_8yrs==1 | help_9yrs==1 | help_10yrs==1 | help_11yrs==1 | help_12yrs==1 | help_13yrs==1 | help_14yrs==1 | help_15yrs==1 | help_16yrs==1 | help_17yrs==1


*(per definition) I should not need these anymore
drop tbdropped* 

replace country="Thailand" if country==""


*Apparently the coding did not pick this up, so I am correcting for it:

replace newfirmstarted_1yr=0 if survival_1yr==1

forvalues i=2/17{
replace  newfirmstarted_`i'yrs=0 if survival_`i'yrs==1 
}

*TO DO: decide whether you need/want to change path for saving "TTHAImasterfc"
/**/
save TTHAImasterfc, replace
/**/

duplicates tag newid surveyyear, gen(dupl)
bysort newid: egen totaldupl=total(dupl)
order totaldupl, after(hc_id)
g incl=1 if totaldupl==0

*Generate firmid
*Check for inconsistencies in coding depending on baseline year for a given household/firm:
sort newid surveyyear
bysort newid: egen help1=min(surveyyear)
order surveyyear help1, after(survey)
g help21=surveyyear-help1
order help21, after(help1)

g help1_1=newfirmstarted_1yr if help21==0
g period_1=1 if help21==0


forvalues i=2/17{
g help1_`i'=newfirmstarted_`i'yrs if help21==0
}

forvalues i=1/17{
bysort newid: egen help21_`i'=total(help1_`i'), m
}

g sameaszero1=1 if help21==0
forvalues i=1/16{
replace sameaszero1=1 if help21==`i' & help21_`i'==0
replace sameaszero1=0 if help21==`i' & help21_`i'>=1 & help21_`i'!=.
}

order sameaszero1, after(hc_id) 

forvalues i=2/16{
local j=`i'-1
sort newid surveyyear
bysort newid: egen help`i'=min(surveyyear) if help2`j'!=0 & help2`j'!=.
g help2`i'=surveyyear-help`i'
order help2`i', after(help2`j')

g help`i'_1=newfirmstarted_1yr if help2`i'==0
g period_`i'=`i' if help2`i'==0
order period_`i', after(period_`j')

forvalues k=2/17{
g help`i'_`k'=newfirmstarted_`k'yrs if help2`i'==0
}

forvalues k=1/17{
bysort newid: egen help2`i'_`k'=total(help`i'_`k'), m
}

g sameaszero`i'=1 if help2`i'==0
forvalues k=1/16{
replace sameaszero`i'=1 if help2`i'==`k' & help2`i'_`k'==0
replace sameaszero`i'=0 if help2`i'==`k' & help2`i'_`k'>=1 & help2`i'_`k'!=.
}

order sameaszero`i', after(sameaszero`j') 
}

egen period=rowtotal(period_1-period_16),m
order period, after(hc_id)
bysort newid: egen maxperiod=max(period)
order maxperiod, after(period)

*To check for inconsistencies:

*In case survival and newfirm have both missings
egen helpcheck=rowmiss(sameaszero1)
bysort newid: egen helpcheck2=total(helpcheck)
g check=(helpcheck2>0 & helpcheck2!=.)
drop helpcheck helpcheck2
forvalues i=2/16{
egen helpcheck=rowmiss(sameaszero`i') if period>=`i'
bysort newid: egen helpcheck2=total(helpcheck) if period>=`i'
replace check=1 if helpcheck2>0 & helpcheck2!=. & period>=`i'
drop helpcheck helpcheck2
}

order check, after(hc_id)

*In case there is a switch from being same firm to different and then to same firm again
forvalues i=1/16{
bysort newid: egen helpcheck=total(sameaszero`i'/(dupl+1))
g helpcheck2_`i'=1 if sameaszero`i'==0 & helpcheck>=(period-`i'+1)
drop helpcheck
}
egen rthelpcheck2=rowtotal(helpcheck2_1-helpcheck2_16),m
order rthelpcheck2, after(maxperiod)

tab rthelpcheck2
egen rthelpcheck3=anymatch(rthelpcheck2), values(1 2 3 4 5)
order rthelpcheck3, after(rthelpcheck2)

bysort newid:egen rthelpcheck4=max(rthelpcheck3)
order rthelpcheck4, after(rthelpcheck3)

replace check=1 if rthelpcheck4==1

drop rthelpcheck* helpcheck2*

*For inconsistencies over different time horizons depending on the baseline year but with the follow-up year being constant
*- maxperiod needs to be larger than 2 (for 1 and 2 periods there cannot be inconsistencies with implications for coding of the hhfirm)
g helpcheck=.
forvalues i=3/16{
local j=`i'-1
local k=`i'-2
replace helpcheck=1 if sameaszero`k'>sameaszero`j' & sameaszero`k'!=. & sameaszero`j'!=. & period>=`i'
}
order helpcheck, before(sameaszero1)

*There seem to be no 1 to 0 inconsistencies in the data. All . to 1 or 0 inconsistencies are already picked up by check.
*TO DO: decide whether you need/want to change path for saving "TTHAImasterfc"
/**/
save TTHAImasterfc, replace
/**/

*THERE IS A PROBLEM WITH CHECK, AS IT IS NOT GOING OVER THE WHOLE HOUSEHOLD IN A COUPLE OF CASES, SO I CORRECT THAT
bysort newid: egen maxcheck=max(check)
replace check=maxcheck
drop maxcheck

*TO DO: decide whether you need/want to change path for saving "TTHAImasterfc"
/**/
save TTHAImasterfc, replace
/**/

*CHECK IF CHECK==1
*keep if check==1

*Do it manually
order surveyyear, after(period)
*newid="072436580937"
*appears to be owner changes that are driving the coding but it looks rather as being one firm where owners change and age of the firm is not reported well.
forvalues i=1/16{
replace sameaszero`i'=1 if sameaszero`i'==0 & newid=="072436580937"
}
foreach x in 2008 2010 2011 2012 2013 2014{
local i=`x'-1998
replace survival_`i'yrs=1 if newid=="072436580937" & surveyyear==1998
replace newfirmstarted_`i'yrs=0 if newid=="072436580937" & surveyyear==1998
}
foreach x in 2008 2010 2011 2012 2013 2014{
local i=`x'-1999
replace survival_`i'yrs=1 if newid=="072436580937" & surveyyear==1999
replace newfirmstarted_`i'yrs=0 if newid=="072436580937" & surveyyear==1999
}
foreach x in 2008 2010 2011 2012 2013 2014{
local i=`x'-2000
replace survival_`i'yrs=1 if newid=="072436580937" & surveyyear==2000
replace newfirmstarted_`i'yrs=0 if newid=="072436580937" & surveyyear==2000
}
foreach x in 2008 2010 2011 2012 2013 2014{
local i=`x'-2001
replace survival_`i'yrs=1 if newid=="072436580937" & surveyyear==2001
replace newfirmstarted_`i'yrs=0 if newid=="072436580937" & surveyyear==2001
}

foreach x in 2010 2012 2013 2014{
local i=`x'-2002
replace survival_`i'yrs=1 if newid=="072436580937" & surveyyear==2002
replace newfirmstarted_`i'yrs=0 if newid=="072436580937" & surveyyear==2002
}

foreach x in 2010 2012 2013 2014{
local i=`x'-2003
replace survival_`i'yrs=1 if newid=="072436580937" & surveyyear==2003
replace newfirmstarted_`i'yrs=0 if newid=="072436580937" & surveyyear==2003
}

foreach j in 2004 2005 2006 2007 2008{
foreach x in 2012 2013 2014{
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="072436580937" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="072436580937" & surveyyear==`j'
}
}

foreach x in 2012 2014{
local i=`x'-2010
replace survival_`i'yrs=1 if newid=="072436580937" & surveyyear==2010
replace newfirmstarted_`i'yrs=0 if newid=="072436580937" & surveyyear==2010
}



replace check=0 if newid=="072436580937" 

*newid="072643640911"
*It is unclear to which of the two firms the firm in the last period is referring to. I suppose it refers to the most recent business.
forvalues i=1/2{
replace sameaszero`i'=0 if sameaszero`i'==1 & newid=="072643640911" & surveyyear==2014
}
foreach j in 1999 2000{
local i=2014-`j'
replace survival_`i'yrs=0 if newid=="072643640911" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="072643640911" & surveyyear==`j'
}
replace check=0 if newid=="072643640911" 

*newid="072729570961"
*In 2009 the business has been closed so I code newfirmstarted from 2009 on
forvalues i=1/3{
replace sameaszero`i'=0 if sameaszero`i'==1 & newid=="072729570961" & surveyyear>=2009
}
foreach j in 2006 2007{
foreach x in 2009 2013{
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="072729570961" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="072729570961" & surveyyear==`j'
}
}
local i=2013-2008
replace survival_`i'yrs=0 if newid=="072729570961" & surveyyear==2008
replace newfirmstarted_`i'yrs=1 if newid=="072729570961" & surveyyear==2008

local i=2009-2008
replace survival_`i'yr=0 if newid=="072729570961" & surveyyear==2008
replace newfirmstarted_`i'yr=1 if newid=="072729570961" & surveyyear==2008

local i=2010-2009
replace survival_`i'yr=0 if newid=="072729570961" & surveyyear==2009
replace newfirmstarted_`i'yr=0 if newid=="072729570961" & surveyyear==2009

forvalues x =2011/2013{
local j=2009
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="072729570961" & surveyyear==2009
}

replace check=0 if newid=="072729570961"

*newid=072729610970 - looks like it's all the same business
local newid=`"072729610970"'
replace sameaszero1=1 if sameaszero1==0 & newid=="`newid'"

foreach x in 2004 2006{
local i=`x'-2002
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==2002
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==2002
}

replace survival_1yr=1 if newid=="`newid'" & surveyyear==2002
replace newfirmstarted_1yr=0 if newid=="`newid'"  & surveyyear==2002

replace check=0 if newid=="`newid'"

*newid=072729630911 - it`s a different business in 2008 but from then the same
local newid=`"072729630911"'
replace sameaszero1=0 if sameaszero1==1 & newid=="`newid'" & surveyyear>=2008
forvalues i=2/3{
replace sameaszero`i'=1 if sameaszero`i'==0 & newid=="`newid'"
}

foreach x in 2009 2010 2012 2013{
local i=`x'-2007
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==2007
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==2007
}

foreach j in 2008 2009{
local i=2011-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}

replace check=0 if newid=="`newid'"

*newid=072729630977 - business closure after 1999, 2002 and after 2005
local newid=`"072729630977"'
forvalues i=1/4{
replace sameaszero`i'=0 if sameaszero`i'==1 & newid=="`newid'" & surveyyear==2005
}
forvalues i=3/4{
replace sameaszero`i'=0 if sameaszero`i'==1 & newid=="`newid'" & surveyyear==2002
}
foreach j in 1997 1999 2001 2002{
forvalues x=2004/2014{
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
}
foreach j in 2001 2002{
local x=2005
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=. if newid=="`newid'" & surveyyear==`j'
}


replace check=0 if newid=="`newid'"

*newid=162827590927 - it`s probably a coding mistake in sector in 2013 -> I treat it as the same business
local newid=`"162827590927"'
replace sameaszero2=1 if sameaszero2==. & newid=="`newid'"
local i=2013-2009
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==2009
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==2009
replace check=0 if newid=="`newid'"

*newid=163029600911 - maybe a coding mistake in sector in 2012? -> I treat it as the same business
local newid=`"163029600911"'
replace sameaszero5=1 if sameaszero5==. & newid=="`newid'" & surveyyear==2014
local i=2014-2012
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==2012
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==2012
replace check=0 if newid=="`newid'"


*newid=163029600979 - the business in 2012 is a different business (different sector, owner and age of the firm)
local newid=`"163029600979"'
forvalues i=1/4{
replace sameaszero`i'=0 if newid=="`newid'" & surveyyear==2012
}
replace sameaszero5=0 if sameaszero5==. & newid=="`newid'" & surveyyear>2012

*I code it as survival anyways, although it is a different firm, but if it survives to 2013 then it also survived to 2012
foreach j in 2008 2009 2010{
local i=2012-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
local i=2012-2011
replace survival_`i'yr=1 if newid=="`newid'" & surveyyear==2011
replace newfirmstarted_`i'yr=0 if newid=="`newid'" & surveyyear==2011

*For the second business I don't know
local i=2013-2012
replace survival_`i'yr=. if newid=="`newid'" & surveyyear==2012
replace newfirmstarted_`i'yr=. if newid=="`newid'" & surveyyear==2012
local i=2014-2012
replace survival_`i'yrs=. if newid=="`newid'" & surveyyear==2012
replace newfirmstarted_`i'yrs=. if newid=="`newid'" & surveyyear==2012

replace check=0 if newid=="`newid'"


*newid=164245640927 -> since owner stays the same and no business is closed or newly established, I code it as the same business, despite inconsistencies in age and sector
local newid=`"164245640927"'
replace sameaszero1=1 if sameaszero1==0 & newid=="`newid'"
local i=2011-2008
replace survival_`i'yrs=. if newid=="`newid'" & surveyyear==2008
replace newfirmstarted_`i'yrs=. if newid=="`newid'" & surveyyear==2008
replace check=0 if newid=="`newid'"

*newid=164245640950 - might be a coding mistake in sector -> I code it as the same business
local newid=`"164245640950"'
replace sameaszero4=1 if sameaszero4==. & newid=="`newid'" & surveyyear==2012
local i=2012-2011
replace survival_`i'yr=1 if newid=="`newid'" & surveyyear==2011
replace newfirmstarted_`i'yr=0 if newid=="`newid'" & surveyyear==2011
replace check=0 if newid=="`newid'"

*newid=243029620921 - it's two different businesses with the first business closing from 2009 to 2010, and it seems the second has been operating for a while already
local newid=`"243029620921"'
forvalues i= 1/2{
replace sameaszero`i'=0 if sameaszero`i'==. & newid=="`newid'" & surveyyear>=2010
}
forvalues x=2010/2014{
local i=`x'-2008
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==2008
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==2008
}
local i=2010-2009
replace survival_`i'yr=0 if newid=="`newid'" & surveyyear==2009
replace newfirmstarted_`i'yr=0 if newid=="`newid'" & surveyyear==2009
forvalues x=2011/2014{
local i=`x'-2009
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==2009
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==2009
}
replace check=0 if newid=="`newid'"


*newid=243029620925 - I code it as the same business; the owner changes might be driving the inconsistencies but from age and sector it looks like the same and over the whole period the household never closed the business or opened a new one
local newid=`"243029620925"'
forvalues i=1/7{
local j=2008+`i'-1
replace sameaszero`i'=1 if newid=="`newid'" & surveyyear>`j'
}
foreach x in 2010 2012 2013 2014{
local i=`x'-2008
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==2008
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==2008
}
local i=2014-2009
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==2009
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==2009
foreach x in 2013 2014{
foreach j in 2010 2011{
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
}
local i=2014-2012
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==2012
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==2012
local i=2013-2012
replace survival_`i'yr=1 if newid=="`newid'" & surveyyear==2012
replace newfirmstarted_`i'yr=0 if newid=="`newid'" & surveyyear==2012
replace check=0 if newid=="`newid'"


*newid=243545520927 - I code it as the same business (owner and sector stay the same and the firm is never closed or a new one opened)
local newid=`"243545520927"'
replace sameaszero1=1 if sameaszero1==0 & newid=="`newid'" 
foreach x in 2011 2012{
local i=`x'-2008
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==2008
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==2008
}
replace check=0 if newid=="`newid'"

*newid=243545520942 - The business in 2009 is a different business (different owner and sector)
local newid=`"243545520942"'
replace sameaszero1=0 if sameaszero1==. & newid=="`newid'" 
replace sameaszero2=0 if sameaszero2==. & newid=="`newid'" & surveyyear>2009
*Since the original business survives, I code it as surviving for the year 2009 in which it is not reported on
local i=2009-2008
replace survival_`i'yr=1 if newid=="`newid'" & surveyyear==2008
replace newfirmstarted_`i'yr=0 if newid=="`newid'" & surveyyear==2008
*For the business that is being reported in 2009 I leave both survival and newfirmstarted as missing, given that I don't know what happened to this business
replace check=0 if newid=="`newid'"

*newid=243545540949 - seems to be the same firm with owner change and (coding?) inconsistencies in age of the firm and sector
local newid=`"243545540949"'
replace sameaszero2=1 if sameaszero2==. & newid=="`newid'" & surveyyear>2009
forvalues x=2012/2014{
local i=`x'-2009
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==2009
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==2009
}
replace check=0 if newid=="`newid'"

*newid=243545540977 - looks like two businesses are reported but one of them does not have an owner assigned so I drop this second business
local newid=`"243545540977"'
drop if  newid=="`newid'" & surveyyear==2008
replace sameaszero1=1 if newid=="`newid'"
replace sameaszero2=. if newid=="`newid'"
replace period=1 if newid=="`newid'"
replace maxperiod=1 if newid=="`newid'"
replace check=0 if newid=="`newid'"

*newid=243545580911 - two different businesses
local newid=`"243545580911"'
replace sameaszero3=0 if newid=="`newid'" & surveyyear==2014
local i=2014-2010
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==2010
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==2010
replace check=0 if newid=="`newid'"

*newid=243545650981 - looks like a coding mistake for the sector in 2013 (owner stays the same and age is consistent) -> same business
local newid=`"243545650981"'
replace sameaszero2=1 if newid=="`newid'" & surveyyear==2013
local i=2014-2009
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==2009
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==2009
replace check=0 if newid=="`newid'"

*newid=243545680950 - same business
local newid=`"243545680950"'
replace sameaszero1=1 if newid=="`newid'" & surveyyear==2010
local i=2010-2008
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==2008
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==2008
replace check=0 if newid=="`newid'"

*newid=243545680989 - new firm in 2012 and given that owner and sector stay the same I code it as the continuation of the new firm in the later periods
local newid=`"243545680989"'
forvalues i=1/4{
replace sameaszero`i'=0 if newid=="`newid'" & surveyyear>2012
}
foreach j in 2008 2009 2010 2011{
foreach x in 2013 2014{
local i=`x'-`j'
replace survival_`i'yrs=. if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}
}
replace check=0 if newid=="`newid'"

*newid=272930650873 - I code it as the same business. Owners do not coincide but that might be an owner change, age of the firm is okay and sector stays the same
local newid=`"272930650873"'
replace sameaszero1=1 if newid=="`newid'" & surveyyear==2012
local i=2012-2011
replace survival_`i'yr=1 if newid=="`newid'" & surveyyear==2011
replace newfirmstarted_`i'yr=0 if newid=="`newid'" & surveyyear==20011
replace check=0 if newid=="`newid'"

*newid=272930650926 - new business in 2002 but from that it is the same
local newid=`"272930650926"'
replace sameaszero1=0 if newid=="`newid'" & surveyyear>=2002
forvalues i=2/5{
replace sameaszero`i'=1 if newid=="`newid'" & surveyyear>=2005
}
foreach x in 2009 2014{
local i=`x'-2000
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==2000
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==2000
}
foreach j in 2002 2003 2004 2005{
foreach x in 2007 2008 2009 2010 2011 2012 2013 2014{
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
}
local i=2006-2003
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==2003
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==2003
replace check=0 if newid=="`newid'"

*newid=272931630821 - looks like it is the same business (maybe a mistake in coding of business owner?)
local newid=`"272931630821"'
forvalues i=1/3{
replace sameaszero`i'=1 if newid=="`newid'" & surveyyear>=2011
}
replace sameaszero4=1 if newid=="`newid'" & surveyyear>=2012
foreach x in 2011 2012{
local i=`x'- 2009
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==2009
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==2009
}
local i=2012-2010
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==2010
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==2010

local i=2011-2010
replace survival_`i'yr=1 if newid=="`newid'" & surveyyear==2010
replace newfirmstarted_`i'yr=0 if newid=="`newid'" & surveyyear==2010

foreach x in 2013 2014{
local i=`x'-2011
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==2011
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==2011
}

local i=2014-2012
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==2012
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==2012

local i=2013-2012
replace survival_`i'yr=1 if newid=="`newid'" & surveyyear==2012
replace newfirmstarted_`i'yr=0 if newid=="`newid'" & surveyyear==2012
replace check=0 if newid=="`newid'"

*newid=273238570927 - looks like it is the same business from sector and ownership and age of firm is never very small and there is no firm reported to be closed or started as new -> code it as the same firm
local newid=`"273238570927"'
forvalues i=1/6{
replace sameaszero`i'=1 if newid=="`newid'" & surveyyear>=2009
}
foreach x in 2009 2010{
foreach j in 1998 1999 2000 {
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
}
foreach j in 2001 2002 2003{
local i=2009-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
replace check=0 if newid=="`newid'"

*newid=273238660941 - owner change seems to be driving inconsistencies -> I code the new business that is operating from 2010 as surviving throughout the rest of the period
local newid=`"273238660941"'
replace sameaszero1=0 if newid=="`newid'" & surveyyear==2013
replace sameaszero2=1 if newid=="`newid'" & surveyyear==2014

local i=2013-2004
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==2004
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==2004

local i=2014-2010
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==2010
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==2010

replace check=0 if newid=="`newid'"

*newid=273240530958 -> same firm (age is imperfectly reported)
local newid=`"273240530958"'
forvalues i=1/2{
replace sameaszero`i'=1 if sameaszero`i'==0 & newid=="`newid'" 
}
foreach x in 2011 2012{
local i=`x'-2007
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==2007
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==2007
}
local i=2012-2008
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==2008
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==2008
replace check=0 if newid=="`newid'"

*newid=273240620968 -> I code the firm appearing from 2011 on as the continuation of the newly established firm in 2011
local newid=`"273240620968"'
replace sameaszero1=0 if newid=="`newid'" & surveyyear>=2012
foreach x in 2012 2013{
local i=`x'-2008
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==2008
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==2008
}
replace check=0 if newid=="`newid'"

*newid=273240650902 - two different businesses
local newid=`"273240650902"'
drop if newid=="`newid'" & hhbusowner_1997==0  & surveyyear==1997
replace sameaszero1=1 if newid=="`newid'" & surveyyear==1998
replace sameaszero2=. if newid=="`newid'" & surveyyear==1998
replace period=1 if newid=="`newid'" & surveyyear==1998
replace maxperiod=1 if newid=="`newid'" & surveyyear==1998
replace check=0 if newid=="`newid'"

*newid=273240650941 - the business in 2013 is a continuation of the new business founded in 2006
local newid=`"273240650941"'
forvalues i= 1/2{
replace sameaszero`i'=0 if newid=="`newid'" & surveyyear==2013
}
forvalues j=2002/2003{
local i=2013-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}
replace check=0 if newid=="`newid'"

*newid=311945650902 - I code it as the same business as the business is never closed or a new one created and age of firm, although inconsistent, is in line with that
local newid=`"311945650902"'
replace sameaszero1=1 if newid=="`newid'"
foreach x in 2010 2012 2013{
local i=`x'-2008
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==2008
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==2008
}
replace check=0 if newid=="`newid'"

*newid=311945650925 - the business reported in 2008 is closed and from 2011 a new one is reported
local newid=`"311945650925"'
replace sameaszero1=0 if newid=="`newid'" & surveyyear>=2012
foreach x in 2012 2013 2014{
local i=`x'-2008
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==2008
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==2008
}
replace check=0 if newid=="`newid'"

*newid=313545520977 -> same firm (age of firm is probably reported imperfectly)
local newid=`"313545520977"'
forvalues i=1/2{
replace sameaszero`i'=1 if newid=="`newid'" &  sameaszero`i'==0
}
forvalues j=2008/2009{
local i=2012-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
replace check=0 if newid=="`newid'"

*newid=313545540940 - new business created in 2009 and another new one created in 2010 and two businesses closed
local newid=`"313545540940"'
forvalues i=1/2{
replace sameaszero`i'=0 if newid=="`newid'" &  surveyyear>=2011
}
foreach x in 2011 2012 2013 2014{
forvalues j=2008/2009{
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}
}
*Using the information from hhbusclosure I can improve the coding of survival:
forvalues j=2008/2009{
replace survival_1yr=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_1yr=1 if newid=="`newid'" & surveyyear==`j'
}
replace survival_2yrs=0 if newid=="`newid'" & surveyyear==2008
replace newfirmstarted_2yrs=1 if newid=="`newid'" & surveyyear==2008
replace check=0 if newid=="`newid'"

*newid=313545570940 - same business (age of firm is probably reported imperfectly)
local newid=`"313545570940"'
replace sameaszero1=1 if newid=="`newid'" 
local i=2013-2008
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==2008
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==2008
replace check=0 if newid=="`newid'"

*newid=313545590927 - same business (age of firm might be reported imperfectly)
local newid=`"313545590927"'
forvalues i=1/6{
replace sameaszero`i'=1 if newid=="`newid'"  & surveyyear==2014
}
forvalues j=2008/2012{
local i=2014-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
local j=2013
local i=2014-`j'
replace survival_`i'yr=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace check=0 if newid=="`newid'"

*newid=313545660920 - same business (age of firm probably reported imperfectly)
local newid=`"313545660920"'
forvalues i=1/2{
replace sameaszero`i'=1 if newid=="`newid'"  & surveyyear==2012
}
forvalues j=2008/2009{
local i=2012-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
replace check=0 if newid=="`newid'"

*newid=313545660958 - firm in 2009 is closed, and I code the frim operating from 2012 to 2014 as the same firm given that sector is the same, firm is not reported to have been closed and also not to be a new one
local newid=`"313545660958"'
replace sameaszero1=0 if newid=="`newid'"  & surveyyear==2014

forvalues x=2011/2014{
local j=2009
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
local j=2009
local x=2010
local i=`x'-`j'
replace survival_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=0 if newid=="`newid'" & surveyyear==`j'

foreach x in 2012 2013 2014{
local j=2009
local i=`x'-`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}

replace check=0 if newid=="`newid'"

*newid=313545660979 - two different firms, and the firm from 2008 is closed by 2009
local newid=`"313545660979"'
drop if newid=="`newid'" & hhbusowner_2008==0  & surveyyear==2008
drop if newid=="`newid'" & hhbusowner_2009==.  & surveyyear==2009
replace survival_1yr=0 if  newid=="`newid'" & surveyyear==2008

replace sameaszero1=1 if newid=="`newid'" & surveyyear==2009
replace sameaszero2=. if newid=="`newid'" & surveyyear==2009
replace period=1 if newid=="`newid'" & surveyyear==2009
replace maxperiod=1 if newid=="`newid'" 
replace check=0 if newid=="`newid'"

*newid=313736590950 - looks like age of the firm has been reported imperfectly -> same firm given that business is never closed or a new one is opened and owner and sector stay the same
local newid=`"313736590950"'
forvalues i=1/5{
replace sameaszero`i'=1 if newid=="`newid'" & surveyyear==2013
}
forvalues j=2008/2011{
local i=2013-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
local j=2012
local i=2013-`j'
replace survival_`i'yr=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace check=0 if newid=="`newid'"

*newid=332629620961 - many inconsistencies -> I assume that the business from 2008 is the one being referred to as closed in the follow-up round; and I code the business reported in 2012 as a different business given that owner, age of the firm and sector do not coincide
local newid=`"332629620961"'
forvalues i=1/4{
replace sameaszero`i'=0 if newid=="`newid'" & surveyyear>=2012
}
local j=2008
local i=2009-`j'
replace survival_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=1 if newid=="`newid'" & surveyyear==`j'
forvalues x=2010/2011{
local j=2008
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}
forvalues x=2012/2014{
local j=2008
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
forvalues x=2012/2014{
forvalues j=2009/2010{
replace survival_`i'yrs=. if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
}
forvalues x=2013/2014{
local j=2011
local i=`x'-`j'
replace survival_`i'yrs=. if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
local j=2011
local x=2012
local i=`x'-`j'
replace survival_`i'yr=. if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace check=0 if newid=="`newid'"

*newid=333545490950 - I drop the business reported in 2008 since noone is owning it; then we have 3 different businesses
local newid=`"333545490950"'
drop if newid=="`newid'" & surveyyear==2008
forvalues i=2/7{
replace period=`i'-1 if newid=="`newid'" & period==`i'
local j=`i'-1
replace sameaszero`j'=sameaszero`i' if newid=="`newid'"
}
replace sameaszero7=. if newid=="`newid'"

replace maxperiod=6 if newid=="`newid'"
replace sameaszero3=0 if sameaszero3==. & newid=="`newid'" & surveyyear>=2012
*I code the business being reported in 2012-2013 as a new business
forvalues x=2012/2014{
forvalues j=2009/2010{
local i=`x'-`j'
replace survival_`i'yrs=. if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}
}
forvalues x=2013/2014{
local j=2011
local i=`x'-`j'
replace survival_`i'yrs=. if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}
local x=2012
local j=2011
local i=`x'-`j'
replace survival_`i'yr=. if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=1 if newid=="`newid'" & surveyyear==`j'
local x=2014
local j=2012
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
local j=2013
local x=2014
local i=`x'-`j'
replace survival_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=1 if newid=="`newid'" & surveyyear==`j'
replace check=0 if newid=="`newid'"

*newid=333545490967 - two different businesses
local newid=`"333545490967"'
forvalues i=1/2{
replace sameaszero`i'=0 if newid=="`newid'" & surveyyear>=2010
}
forvalues x=2010/2014{
local j=2008
local i=`x'-`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
forvalues x=2011/2014{
local j=2009
local i=`x'-`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
local x=2010
local j=2009
local i=`x'-`j'
replace newfirmstarted_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace check=0 if newid=="`newid'"

*newid=333545490989 - I code it as the same business
local newid=`"333545490989"'
replace sameaszero1=1 if newid=="`newid'" 
replace sameaszero2=1 if newid=="`newid'" & surveyyear>=2012

local j=2008
local x=2009
local i=`x'-`j'
replace survival_`i'yr=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=0 if newid=="`newid'" & surveyyear==`j'

forvalues x=2012/2014{
local j=2009
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
replace check=0 if newid=="`newid'"

*newid=333545510982 -> two different businesses (different owners, sectors and firm ages)
local newid=`"333545510982"'
replace sameaszero1=0 if sameaszero1==. & newid=="`newid'" 

local x=2010
local j=2008
local i=`x'-`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'

local x=2009
local j=2008
local i=`x'-`j'
replace newfirmstarted_`i'yr=0 if newid=="`newid'" & surveyyear==`j'

replace check=0 if newid=="`newid'"

*newid=492624540977 - looks like age of the firm has been misrecorded in 2010 -> same firm
local newid=`"492624540977"'
forvalues i=1/2{
replace sameaszero`i'=1 if sameaszero`i'==0 &  newid=="`newid'" 
}
forvalues j=2002/2003{
local x=2010
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
replace check=0 if newid=="`newid'"

*newid=492624650927 - looks like age of the firm has been reported imperfectly -> same firm
local newid=`"492624650927"'
forvalues i=1/4{
replace sameaszero`i'=1 if sameaszero`i'==0 & newid=="`newid'"
}
foreach x in 2009 2011{
local j=1998
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
forvalues j=1999/2001{
local x=2011
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
replace check=0 if newid=="`newid'"

*newid=492624650971 - since noone is the owner of the business reported in 2005, I drop it; for the rest we have closure and a new firm in the subsequent period
local newid=`"492624650971"'
drop if newid=="`newid'" & surveyyear==2005 & hhbusowner_2005==0
replace maxperiod=4 if newid=="`newid'" 

foreach x in 2003 2004{
local j=2001
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}
local x=2004
local j=2002
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
local x=2003
local j=2002
local i=`x'-`j'
replace survival_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=1 if newid=="`newid'" & surveyyear==`j'
replace check=0 if newid=="`newid'"

*newid=492838600950 - inconsistencies might be due to owner changes -> I code it as the same business 
local newid=`"492838600950"'
forvalues i=1/2{
replace sameaszero`i'=1 if sameaszero`i'==0 & newid=="`newid'"
}
foreach j in 1999 2000{
local x=2005
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
replace check=0 if newid=="`newid'"

*newid=492838640905 -> I code it as the same business
local newid=`"492838640905"'
foreach i in 1 3{
replace sameaszero`i'=1 if newid=="`newid'" & surveyyear>=2005
}
foreach j in 1998 2000{
local x=2005
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
forvalues x=2006/2008{
local j=2000
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
replace check=0 if newid=="`newid'"


*newid=492838650908 ->same business
local newid=`"492838650908"'
replace sameaszero1=1 if newid=="`newid'"

local x=2003
local j=1997
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace check=0 if newid=="`newid'"


*newid=492838650921 ->four different businesses; unsure about the business reported in 2008, I code is as another different business
local newid=`"492838650921"'
forvalues i=3/4{
replace sameaszero`i'=0 if newid=="`newid'" & surveyyear==2008
}

local x=2008
local j=2005
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'

local x=2008
local j=2006
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace check=0 if newid=="`newid'"

*newid=492838650927 - since noone is the owner of the business reported in 1998 and 1999, I drop it.
local newid=`"492838650927"'
forvalues x=1998/1999{
drop if  newid=="`newid'" & surveyyear==`x' & hhbusowner_`x'==0
}
forvalues i=3/5{
replace period=`i'-2 if period==`i' &  newid=="`newid'"
local j=`i'-2
replace sameaszero`j'=sameaszero`i' if newid=="`newid'"
}
forvalues i=4/5{
replace sameaszero`i'=. if newid=="`newid'"
}
replace maxperiod=3 if newid=="`newid'"

replace check=0 if newid=="`newid'"

*newid=492838650940 - because of the owner, I code the businesses with different sectors and ages as the same, given that none is closed or newly established
local newid=`"492838650940"'
replace sameaszero1=1 if newid=="`newid'" & surveyyear==2001
replace sameaszero2=1 if newid=="`newid'" & surveyyear==2001

forvalues j=1998/1999{
local x=2001
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
*Given that the firm reported in 2001 dies over one year, I code survival=0 for the other baseline years with 2002 as follow-up year too
replace check=0 if newid=="`newid'"
forvalues x=2002/2003{
forvalues j=1998/2000{
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
}
replace check=0 if newid=="`newid'"

*newid=493141600956 - same firm (probably driven by imperfectly reported age of the firm)
local newid=`"493141600956"'
forvalues i=1/4{
replace sameaszero`i'=1 if newid=="`newid'" & surveyyear==2005
}
forvalues j=1998/2001{
local x=2005
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
replace period=17 if period==. & newid=="`newid'"
replace maxperiod=17 if newid=="`newid'"
replace check=0 if newid=="`newid'"

*newid=493141600997 - I code the firm in 2009 as the same as in 2008, given that the owner stays the same and in 2009 no new firm creation or closure of the previous round is reported
local newid=`"493141600997"'
replace sameaszero1=0 if surveyyear==2009 & newid=="`newid'"
local j=2005
local x=2009
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace check=0 if newid=="`newid'"

*newid=493141610956 - I code the firm from 2008 on as the same firm, although the sector changes and firm ages do not overlap, but the owner stays the same and in 2009 no business closure or opening of a new business is reported
local newid=`"493141610956"'
replace sameaszero8=0 if surveyyear>=2008 & newid=="`newid'"
forvalues i=9/11{
replace sameaszero`i'=1 if sameaszero`i'==0 & newid=="`newid'"
}

forvalues x=2008/2014{
local j=2006
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}
forvalues j=2008/2010{
local x=2013
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
replace check=0 if newid=="`newid'"

*newid=493141610968 - two business closures. I code the businesses reported in 1997 and 1998 as te same given that the owners stay the same, none is new and non is closed
local newid=`"493141610968"'
forvalues i=1/2{
replace sameaszero`i'=0 if newid=="`newid'" & surveyyear>=1999
}
forvalues i=3/4{
replace sameaszero`i'=0 if newid=="`newid'" & surveyyear>=2001
}
forvalues x=1999/2002{
local j=1997
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
forvalues x=2000/2002{
local j=1998
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
local x=1999
local j=1998
local i=`x'-`j'
replace survival_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
forvalues x=2001/2002{
local j=1999
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
local x=2001
local j=2000
local i=`x'-`j'
replace survival_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace check=0 if newid=="`newid'"

*newid=493235570975 -> I code it as the same business given that owner stays the same and age is also in line and especially given that no new firm start has been reported
local newid=`"493235570975"'
replace sameaszero1=1 if newid=="`newid'"
local x=2011
local j=2004
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'

replace check=0 if newid=="`newid'"

*newid=493235650727 - business closure and opening of a new business from 2012 to 2013
local newid=`"493235650727"'
replace sameaszero3=0 if newid=="`newid'" & surveyyear==2014
local j=2012
local x=2014
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
*Using the information from hhbusclosure, I can improve the coding for survival from rounds 1-3 to round 4
forvalues j=2010/2011{
local x=2013
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}
local x=2013
local j=2012
local i=`x'-`j'
replace survival_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=1 if newid=="`newid'" & surveyyear==`j'
replace check=0 if newid=="`newid'"

*newid=542822650904 -> I code it as the same business
local newid=`"542822650904"'
forvalues i=1/3{
replace sameaszero`i'=1 if newid=="`newid'" & surveyyear==2013
}
forvalues j=2009/2011{
local x=2013
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
replace check=0 if newid=="`newid'"

*newid=542822650925 -> I code it as the same business, given that owner stays the same and business is never closed or a new one opened (maybe a coding mistake of the sector in 2012)
local newid=`"542822650925"'
replace sameaszero4=1 if newid=="`newid'" & surveyyear==2014
local j=2012
local x=2014
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace check=0 if newid=="`newid'"

*newid=542833600911 - looks like the same business (ownerchange might be driving inconsistencies in reporting age of the firm in 2012) -> same business
local newid=`"542833600911"'
foreach i in 1 3{
replace sameaszero`i'=1 if newid=="`newid'" & surveyyear==2011
}
foreach j in 2006 2008{
local x=2011
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
replace check=0 if newid=="`newid'"

*newid=542838650968 -> age of firm seems to be misreported in 2009, since owner and sector stay the same I code it as the continuation of the newly established business 
local newid=`"542838650968"'
replace sameaszero1=0 if  newid=="`newid'" & surveyyear>=2007
replace sameaszero2=1 if  newid=="`newid'" & surveyyear>=2008
replace sameaszero3=1 if  newid=="`newid'" & surveyyear>=2011
forvalues x=2009/2014{
local j=2006
local i=`x'-`j'
replace survival_`i'yrs=. if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}
forvalues x=2011/2012{
local j=2007
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
forvalues x=2011/2012{
local j=2008
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
replace check=0 if newid=="`newid'"

*newid=542844590904 - age is reported very inconsistently, but from newfirmquex, owners and age of the firm, it seems that the firm created in 2011 is a different one than the ones reported in 2005 (which is closed subsequently),and from 2007 to 2013
*the firms reported in 2005 and 2011 are different firms from the one reported form 2007 to 2013
local newid=`"542844590904"'
replace sameaszero1=0 if newid=="`newid'" & surveyyear>=2007
replace sameaszero3=1 if newid=="`newid'" & surveyyear==2010
replace sameaszero3=0 if newid=="`newid'" & surveyyear==2011
replace sameaszero6=0 if newid=="`newid'" & surveyyear>2011
forvalues x=2007/2010{
local j=2005
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
forvalues x=2012/2013{
local j=2005
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=. if newid=="`newid'" & surveyyear==`j'
}
local x=2011
local j=2005
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'

local x=2010
local j=2008
local i=`x'-`j'
replace survival_`i'yr=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace check=0 if newid=="`newid'"

*newid=542844590968 - I code the business as the same business given that owner stays the same and there is neve a new one opened (although one business is reported to have been closed from 2010 to 2011, the business in 2012 could be a continuation)
local newid=`"542844590968"'
forvalues i=1/2{
replace sameaszero`i'=1 if  sameaszero`i'==0 & newid=="`newid'"
}
foreach x in 2007 2008 2009 2010 2012 2013{
local j=2005
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}

local j=2006
local x=2013
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'

replace check=0 if newid=="`newid'"

*newid=542844590977 - I code it as the same business, given that owner stays the same and there is never a new firm created or a firm closed (although there are many inconsistencies in age of the firm and sector)
local newid=`"542844590977"'
forvalues i=1/3{
replace sameaszero`i'=1 if  sameaszero`i'==0 & newid=="`newid'"
}
forvalues x=2011/2012{
forvalues j=2005/2006{
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
}
local x=2009
local j=2005
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
local x=2012
local j=2007
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'

replace check=0 if newid=="`newid'"

*newid=542844590981 -> I code it as the same business, given that owner stays the same and there is never a new firm created or a firm closed
local newid=`"542844590981"'
replace sameaszero1=1 if  sameaszero1==0 & newid=="`newid'"
local x=2010
local j=2005
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace check=0 if newid=="`newid'"

*newid=542844620904 -> same firm, given that owner stays the same and business is never closed or a new one created
local newid=`"542844620904"'
replace sameaszero4=1 if surveyyear==2014 & newid=="`newid'"
local x=2014
local j=2008
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace check=0 if newid=="`newid'"

*newid=542844620911 -> I code it as the same firm until 2014, given that owner and sector stay the same and no new firm is reported
local newid=`"542844620911"'
forvalues i=1/3{
replace sameaszero`i'=1 if surveyyear==2010 & newid=="`newid'"
}
replace sameaszero4=1 if surveyyear>=2011 & surveyyear!=2014 & newid=="`newid'"
forvalues j=2005/2007{
forvalues x=2010/2013{
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
}

local j=2010
local x=2011
local i=`x'-`j'
replace survival_`i'yr=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
forvalues x=2012/2013{
local j=2010
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
replace check=0 if newid=="`newid'"

*newid=542844620942 -> I code it as the same firm 
local newid=`"542844620942"'
replace sameaszero2=1 if surveyyear==2010 & newid=="`newid'"
local x=2010
local j=2006
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'

*replace survival=0 from 2006 on
local x=2007
local j=2006
local i=`x'-`j'
replace survival_`i'yr=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace check=0 if newid=="`newid'"

*newid=542844620956 -> same firm 
local newid=`"542844620956"'
replace sameaszero1=1 if sameaszero1==. & newid=="`newid'"
local x=2009
local j=2005
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace check=0 if newid=="`newid'"

*newid=542844620968 -> same firm, given that owner and sector stay the same, business is never reported to be closed and no new business is created 
local newid=`"542844620968"'
replace sameaszero1=1 if sameaszero1==. & newid=="`newid'"
replace sameaszero3=1 if sameaszero3==. & newid=="`newid'" & surveyyear>=2010
forvalues i=1/4{
replace sameaszero`i'=1 if sameaszero`i'==0 & newid=="`newid'"
}
foreach x in 2009 2012{
local j=2007
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
forvalues j=2008/2010 {
local x=2012
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
local j=2009
local x=2011
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
local j=2009
local x=2010
local i=`x'-`j'
replace survival_`i'yr=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace check=0 if newid=="`newid'"

*newid=542929530928 -> I code the business  founded in 2011 as continuing, given that owner and sector stay the same
local newid=`"542929530928"'
replace sameaszero1=0 if surveyyear>=2012 & newid=="`newid'"
forvalues x=2012/2013{
local j=2008
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}
replace check=0 if newid=="`newid'"

*newid=542929530956 - two different businesses with one being closed
local newid=`"542929530956"'
replace sameaszero1=0 if surveyyear>=2013 & newid=="`newid'"
forvalues x=2013/2014{
local j=2011
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
replace check=0 if newid=="`newid'"

*newid=543024540921 -> same business
local newid=`"543024540921"'
replace sameaszero1=1 if sameaszero1==. & newid=="`newid'"
local x=2011
local j=2008
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'


replace check=0 if newid=="`newid'"

*newid=543129540927 -> I code firms based on sector, given that ages are very inconsistent and owners change
local newid=`"543129540927"'
replace sameaszero1=0 if surveyyear>=2010  & newid=="`newid'"
replace sameaszero2=0 if surveyyear>=2010  & newid=="`newid'"
replace sameaszero3=0 if surveyyear>=2012  & newid=="`newid'"
forvalues j=2008/2009{
local x=2013
local i=`x'-`j'
replace survival_`i'yrs=. if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}
forvalues x=2012/2014{
local j=2010
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}

replace check=0 if newid=="`newid'"

*newid=543129540940 - firm closure from 2010 to 2011
local newid=`"543129540940"'
forvalues i=1/3{
replace sameaszero`i'=0 if surveyyear>=2011  & newid=="`newid'"
}
forvalues j=2008/2010{
local x=2014
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}
forvalues x=2012/2013{
local j=2010
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}
forvalues j=2008/2009{
local x=2011
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}
local j=2010
local x=2011
local i=`x'-`j'
replace survival_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=1 if newid=="`newid'" & surveyyear==`j'
replace check=0 if newid=="`newid'"

*newid=543129540949 - I code it as the same business
local newid=`"543129540949"'
forvalues i=2/3{
replace sameaszero`i'=1 if surveyyear>=2013 & newid=="`newid'"
}
local x=2013
local j=2010
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'

local j=2013
local x=2014
local i=`x'-`j'
replace survival_`i'yr=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=0 if newid=="`newid'" & surveyyear==`j'


replace check=0 if newid=="`newid'"


*newid=543129630958 -> I code it as the same business as owner stays the same, firm is never reported to be closed and no new firm is reported
local newid=`"543129630958"'
forvalues i=1/3{
replace sameaszero`i'=1 if surveyyear>=2012 & newid=="`newid'"
}
foreach x in 2012 2014{
local j=2009
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
local x=2012
local j=2009
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
local j=2011
local x=2012
local i=`x'-`j'
replace survival_`i'yr=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace check=0 if newid=="`newid'"

*newid=543545510979 -> same business (seems as if age of the firm is reported imperfectly)
local newid=`"543545510979"'
replace sameaszero1=1 if surveyyear==2010 & newid=="`newid'"

local x=2010
local j=2008
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace check=0 if newid=="`newid'"

*newid=543545590923 - the business reported in 2008 is closed by 2009 and I code the two businesses reported in 2009 and 2010 as the same given that no further closure or opening are reported
local newid=`"543545590923"'
replace sameaszero1=0 if surveyyear==2010 & newid=="`newid'"
replace sameaszero2=1 if surveyyear==2010 & newid=="`newid'"
local x=2010
local j=2008
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
local x=2009
local j=2008
local i=`x'-`j'
replace survival_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=1 if newid=="`newid'" & surveyyear==`j'
local x=2010
local j=2009
local i=`x'-`j'
replace survival_`i'yr=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace check=0 if newid=="`newid'"


*newid=543545600923 -> I code it as the same business since owner stays the same and there is never a closure or opening reported
local newid=`"543545600923"'
forvalues i=1/2{
replace sameaszero`i'=1 if surveyyear==2012 & newid=="`newid'"
}
forvalues j=2008/2009{
local x=2012
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
replace check=0 if newid=="`newid'"


*newid=543545650923 -> same firm given that owner and sector stay the same and no closure or opening ever reported
local newid=`"543545650923"'
replace sameaszero1=1 if newid=="`newid'"
local x=2013
local j=2008
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace check=0 if newid=="`newid'"

*newid=543545650940 -> business closed from 2011 to 2013 and new one opened 
local newid=`"543545650940"'
forvalues i=1/3{
replace sameaszero`i'=0 if newid=="`newid'" & surveyyear==2014
}

forvalues x=2012/2014{
foreach j in 2008 2009{
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}
}
local x=2010
local j=2009
local i=`x'-`j'
replace survival_`i'yr=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=0 if newid=="`newid'" & surveyyear==`j'

local x=2010
local j=2008
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'

local x=2012
local j=2011
local i=`x'-`j'
replace survival_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=0 if newid=="`newid'" & surveyyear==`j'

replace check=0 if newid=="`newid'"

*newid=543545660968 - different owner in 2008 and 2014 and the remaining
*-> I code it as the same business
local newid=`"543545660968"'
forvalues i=2/4{
replace sameaszero`i'=1 if newid=="`newid'" & surveyyear==2014
}
forvalues j=2011/2012 {
local  x=2014
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}

*newid=543545660989 -> same firm (looks like it's only imperfect reporting of age of the firm)
local newid=`"543545660989"'
replace sameaszero1=1 if newid=="`newid'"
local j=2008 
local x=2013
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace check=0 if newid=="`newid'"

*newid=912129620940 -> I code it as the same business
local newid=`"912129620940"'
forvalues i=1/3{
replace sameaszero`i'=1 if sameaszero`i'==0 & newid=="`newid'"
}

foreach x in 2006 2007 2010 2011 2012 2013 2014{
local j=2004
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
local j=2004
local x=2005
local i=`x'-`j'
replace survival_`i'yr=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=0 if newid=="`newid'" & surveyyear==`j'

foreach x in 2007 2010 2011 2012 2013 2014{
local j=2005
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
local j=2005
local x=2006
local i=`x'-`j'
replace survival_`i'yr=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
forvalues x=2010/2014{
local j=2007
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}

replace check=0 if newid=="`newid'"

*newid=912136570950 -> same business (probably only imperfect reporting in age of the firm)
local newid=`"912136570950"'
forvalues i=1/3{
replace sameaszero`i'=1 if sameaszero`i'==0 & newid=="`newid'"
}
forvalues j=2005/2007{
local x=2012
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
local x=2013
local j=2005
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace check=0 if newid=="`newid'"

*newid=912136570977 - many inconsistencies
*-> I code it as the same business given that no closure or opening is ever reported
local newid=`"912136570977"'
forvalues i=1/2{
replace sameaszero`i'=1 if newid=="`newid'" & surveyyear>=2007
}
foreach x in 2007 2009 2010 2011{
local j=2004
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
foreach x in 2007 2009 2010 2011{
local j=2005
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}

replace check=0 if newid=="`newid'"

*newid=912929630977 ->same business
local newid=`"912929630977"'
forvalues i=1/2{
replace sameaszero`i'=1 if newid=="`newid'" & sameaszero`i'==0
}
foreach x in 2010 2014{
local j=2008
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
local x=2014
local j=2009
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace check=0 if newid=="`newid'"

*newid=913129650918 -> I code it as the same business since the owner stays the same
local newid=`"913129650918"'
forvalues i=1/3{
replace sameaszero`i'=1 if newid=="`newid'" & sameaszero`i'==0
}
forvalues j=2009/2011{
local x=2013
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
replace check=0 if newid=="`newid'"

*newid=913545570936 - business is closed from 2012 to 2013 and a new one is opened in 2013
local newid=`"913545570936"'
replace sameaszero2=0 if newid=="`newid'" & surveyyear==2014
forvalues x=2013/2014{
local j=2011
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}
local x=2014
local j=2012
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
local x=2013
local j=2012
local i=`x'-`j'
replace survival_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=1 if newid=="`newid'" & surveyyear==`j'
replace check=0 if newid=="`newid'"

*newid=913545570967 - same business given that owner and sector stay the same (looks like imperfections in reporting of age of firm)
local newid=`"913545570967"'
forvalues i=1/2{
replace sameaszero`i'=1 if newid=="`newid'" & sameaszero`i'==0
}
forvalues x=2012/2014{
forvalues j=2008/2009{
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
}
replace check=0 if newid=="`newid'"

*newid=913545610977 - closure from 2011 to 2012 and new firm opened in 2012
local newid=`"913545610977"'
forvalues i=1/3{
replace sameaszero`i'=0 if newid=="`newid'" & surveyyear==2013
}
forvalues x=2012/2013{
forvalues j=2009/2010{
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}
}
local x=2013
local j=2011
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
local x=2012
local j=2011
local i=`x'-`j'
replace survival_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=1 if newid=="`newid'" & surveyyear==`j'
replace check=0 if newid=="`newid'"

*newid=913545630893 - closure from 2011 to 2012 and new firm opened in 2012
local newid=`"913545630893"'
replace sameaszero1=0 if newid=="`newid'" & surveyyear>=2010
replace sameaszero2=0 if newid=="`newid'" & surveyyear==2014
forvalues x=2010/2014{
local j=2008
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}
forvalues x=2013/2014{
local j=2010
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=. if newid=="`newid'" & surveyyear==`j'
}
replace check=0 if newid=="`newid'"

*TO DO: decide whether you need/want to change path for saving "TTHAImasterfc"
/**/
save TTHAImasterfc.dta, replace
/**/

*Check if I can improve the coding of survival in cases in which the business has been closed
*Check and improve the cases in which typeofbus==typeofbusclosed & survival_1yr==1 & hhbusclosure==1

*If business closure reported and consecutive years -> different businesses / new firm
*If age leaps I go with the consistent coding and closure will describe temporary closure

*newid=162827610981 - closure from 2011 to 2012 and I code the firm from 2012 on as new firm 
local newid=`"162827610981"'
replace sameaszero1=0 if newid=="`newid'" & surveyyear>2011
forvalues x=2013/2014{
local j=2011
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}
local x=2012
local j=2011
local i=`x'-`j'
replace survival_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=1 if newid=="`newid'" & surveyyear==`j'

*newid=243545540940 I code it as two different businesses
local newid=`"243545540940"'
forvalues i=1/4{
replace sameaszero`i'=0 if newid=="`newid'" & surveyyear>2011
}
forvalues j=2008/2010{
forvalues x=2012/2014{
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
}
forvalues x=2013/2014{
local j=2011
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
local j=2011
local x=2012
local i=`x'-`j'
replace survival_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=0 if newid=="`newid'" & surveyyear==`j'

*newid=273240530929 - I keep it as it is

*newid=493235590902 - I code it as two different businesses
local newid=`"493235590902"'
forvalues i=3/4{
replace sameaszero`i'=0 if newid=="`newid'" & surveyyear==2006
}
local x=2006
local j=2004
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'

local j=2005
local x=2006
local i=`x'-`j'
replace survival_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=0 if newid=="`newid'" & surveyyear==`j'


*I just need to improve the coding to 2014
local newid=`"542844620911"'
foreach j in 2005 2006 2007 2010 2011 2012{
local x=2014
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}
local x=2014
local j=2013
local i=`x'-`j'
replace survival_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=1 if newid=="`newid'" & surveyyear==`j'


*newid=543129630967 - I code the closure and the business reported from 2012 on as a different business
local newid=`"543129630967"'
forvalues i=1/4{
replace sameaszero`i'=0 if newid=="`newid'" & surveyyear>2011
}
forvalues x=2012/2014{
forvalues j=2008/2010{
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
}
forvalues x=2013/2014{
local j=2011
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
local x=2012
local j=2011
local i=`x'-`j'
replace survival_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=0 if newid=="`newid'" & surveyyear==`j'



*Check and improve the cases in which typeofbus==typeofbusclosed & survival_1yr==. & hhbusclosure==1
*newid=072136530950 - two different businesses
local newid=`"072136530950"'
local x=2006
local j=2005
local i=`x'-`j'
replace survival_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=0 if newid=="`newid'" & surveyyear==`j'

*newid=072136660923 - business closure between 2007 and 2008
local newid=`"072136660923"'
forvalues x=2008/2010{
local j=2006
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}
forvalues x=2009/2010{
local j=2007
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}
local x=2008
local j=2007
local i=`x'-`j'
replace survival_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=1 if newid=="`newid'" & surveyyear==`j'

*newid=072643640979 - three different businesses
local newid=`"072643640979"'
local x=2003
local j=2000
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
local x=2004
local j=2000
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
local x=2004
local j=2003
local i=`x'-`j'
replace survival_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=0 if newid=="`newid'" & surveyyear==`j'

*newid=161945570902 - business closure
local newid=`"161945570902"'
local x=2012
local j=2011
local i=`x'-`j'
replace survival_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=1 if newid=="`newid'" & surveyyear==`j'
forvalues x=2012/2014{
forvalues j=2008/2010{
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}
}
forvalues x=2013/2014{
local j=2011
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}

*newid=161945640911 - business closure
local newid=`"161945640911"'
forvalues x=2010/2011{
local j=2008
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}
local x=2011
local j=2009
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
local x=2010
local j=2009
local i=`x'-`j'
replace survival_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=1 if newid=="`newid'" & surveyyear==`j'

*newid=162827620977 - business closure
local newid=`"162827620977"'
forvalues x=2010/2012{
local j=2008
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}
local x=2009
local j=2008
local i=`x'-`j'
replace survival_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=1 if newid=="`newid'" & surveyyear==`j'

*newid=162827620989 - business closure
local newid=`"162827620989"'
forvalues x=2012/2014{
forvalues j=2008/2010{
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}
}
forvalues x=2013/2014{
local j=2011
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}
local j=2011
local x=2012
local i=`x'-`j'
replace survival_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=1 if newid=="`newid'" & surveyyear==`j'

*newid=163029640893 - business closure
local newid=`"163029640893"'
forvalues j=2008/2012{
local x=2014
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}
local x=2014
local j=2013
local i=`x'-`j'
replace survival_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=1 if newid=="`newid'" & surveyyear==`j'

*newid=163545540956 - business closure
local newid=`"163545540956"'
forvalues x=2012/2014{
local j=2010
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}
local j=2010
local x=2011
local i=`x'-`j'
replace survival_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=1 if newid=="`newid'" & surveyyear==`j'

*newid=163545590958 - business closure
local newid=`"163545590958"'
forvalues j=2009/2011{
local x=2013
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}
local j=2012
local x=2013
local i=`x'-`j'
replace survival_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=1 if newid=="`newid'" & surveyyear==`j'

*newid=163545610956 - business closure
local newid=`"163545610956"'
forvalues j=2008/2009{
forvalues x=2011/2014{
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}
}
forvalues x=2012/2014{
local j=2010
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}
local j=2010
local x=2011
local i=`x'-`j'
replace survival_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=1 if newid=="`newid'" & surveyyear==`j'

*newid=243029620967 - business closure from 2010 to 2011
local newid=`"243029620967"'
forvalues x=2011/2014{
local j=2009
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}
forvalues x=2012/2014{
local j=2010
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}
local j=2010
local x=2011
local i=`x'-`j'
replace survival_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=1 if newid=="`newid'" & surveyyear==`j'

*newid=243545520936 - business closure 
local newid=`"243545520936"'
forvalues j=2009/2012{
local x=2014
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}
local j=2013
local x=2014
local i=`x'-`j'
replace survival_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=1 if newid=="`newid'" & surveyyear==`j'

*newid=243545570904 - business closure 
local newid=`"243545570904"'
forvalues j=2008/2011{
forvalues x=2013/2014{
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}
}
local j=2012
local x=2014
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
local j=2012
local x=2013
local i=`x'-`j'
replace survival_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=1 if newid=="`newid'" & surveyyear==`j'

*newid=332629590942 - business closure 
local newid=`"332629590942"'
forvalues x=2010/2014{
local j=2008
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}
local j=2008
local x=2009
local i=`x'-`j'
replace survival_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=1 if newid=="`newid'" & surveyyear==`j'

*newid=332729590911 - business closure 
local newid=`"332729590911"'
forvalues j=2008/2010{
forvalues x=2012/2014{
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}
}
forvalues x=2013/2014{
local j=2011
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}
local x=2012
local j=2011
local i=`x'-`j'
replace survival_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=1 if newid=="`newid'" & surveyyear==`j'

*newid=333545620913 - business closure 
local newid=`"333545620913"'
forvalues j=2008/2009{
forvalues x=2011/2014{
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}
}
forvalues x=2012/2014{
local j=2010
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}
local x=2011
local j=2010
local i=`x'-`j'
replace survival_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=1 if newid=="`newid'" & surveyyear==`j'

*newid=333545640927 - business closure 
local newid=`"333545640927"'
forvalues j=2008/2009{
forvalues x=2011/2014{
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}
}
forvalues x=2012/2014{
local j=2010
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}
local x=2011
local j=2010
local i=`x'-`j'
replace survival_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=1 if newid=="`newid'" & surveyyear==`j'

*newid=492838650921 - business closure in 2000
local newid=`"492838650921"'
forvalues x=2002/2014{
local j=2000
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
local x=2001
local j=2000
local i=`x'-`j'
replace survival_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=1 if newid=="`newid'" & surveyyear==`j'

*newid=493141610928 - business closure from 2003 to 2004
local newid=`"493141610928"'
forvalues j=2000/2002{
local x=2004
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}
local x=2004
local j=2003
local i=`x'-`j'
replace survival_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=1 if newid=="`newid'" & surveyyear==`j'

*newid=493141650981 - business closure from 1998 to 1999
local newid=`"493141650981"'
local x=1999
local j=1997
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
local x=1999
local j=1998
local i=`x'-`j'
replace survival_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=1 if newid=="`newid'" & surveyyear==`j'

*newid=493235590948 - business closure from 2003 to 2004
local newid=`"493235590948"'
forvalues j=1998/2001{
local x=2004
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
}
local j=2003
local x=2004
local i=`x'-`j'
replace survival_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=1 if newid=="`newid'" & surveyyear==`j'

*TO DO: decide whether you need/want to change path for saving "TTHAImasterfc"
/*
save TTHAImasterfc.dta, replace
*/

*Since I dropped some observations:
drop dupl totaldupl
duplicates tag newid surveyyear, gen(dupl)
bysort newid: egen totaldupl=total(dupl)
order totaldupl, after(hc_id)
replace incl=1 if totaldupl==0

*There remain a few inconsistent cases if period>2 and the follow-up round is the same
forvalues i=1/16{
bysort newid: egen newhelpcheck`i'=total(sameaszero`i'/(dupl+1))
}
g newhelpcheck=0
forvalues i=3/16{
local j=`i'-1
local k=`i'-2
replace newhelpcheck=1 if newhelpcheck`k'==newhelpcheck`j' & sameaszero`k'<sameaszero`j' & sameaszero`k'!=. & newhelpcheck`k'!=1 & sameaszero`j'!=. & newhelpcheck`j'!=1 & period>=`i'
}
bysort newid: egen maxnewhelpcheck=max(newhelpcheck)

*newid=072643630927 - business is the same from 2011 to 2012
local newid=`"072643630927"'
replace sameaszero1=1 if newid=="`newid'" & sameaszero1==0
local x=2012
local j=2010
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'

*newid=162827620925 -> same firm since owner and sector stay the same and never business closure or opening of a new one reported
local newid=`"162827620925"'
forvalues i=1/2{
replace sameaszero`i'=1 if newid=="`newid'" & sameaszero`i'==0
}
forvalues x=2012/2014{
local j=2009
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
forvalues x=2013/2014{
local j=2010
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}

*newid=163545520936-> same firm 
local newid=`"163545520936"'
replace sameaszero1=1 if newid=="`newid'" & sameaszero1==0
local j=2008
local x=2011
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'

*newid=241945570902-> same firm 
local newid=`"241945570902"'
forvalues i=1/2{
replace sameaszero`i'=1 if newid=="`newid'" & sameaszero`i'==0
}
forvalues j=2008/2009{
local x=2014
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
*newid=241945570928-> same firm 
local newid=`"241945570928"'
forvalues i=1/2{
replace sameaszero`i'=1 if newid=="`newid'" & sameaszero`i'==0
}
forvalues j=2008/2009{
local x=2014
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
*newid=241945570936-> same firm 
local newid=`"241945570936"'
replace sameaszero1=1 if newid=="`newid'" & sameaszero1==0
local j=2008
local x=2014
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'

*newid=243029540927-> same firm 
local newid=`"243029540927"'
forvalues i=1/2{
replace sameaszero`i'=1 if newid=="`newid'" & sameaszero`i'==0
}
forvalues j=2009/2010{
local x=2014
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}

*newid=313545540975 - business is the same from 2012 to 2014
local newid=`"313545540975"'
replace sameaszero1=1 if newid=="`newid'" & sameaszero1==0
local x=2014
local j=2012
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'

*newid=313545570977-> same firm 
local newid=`"313545570977"'
forvalues i=1/2{
replace sameaszero`i'=1 if newid=="`newid'" & sameaszero`i'==0
}
forvalues j=2008/2009{
local x=2013
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}

*newid=492838600873-> same firm 
local newid=`"492838600873"'
forvalues i=1/3{
replace sameaszero`i'=1 if newid=="`newid'" & sameaszero`i'==0
}
forvalues x=2011/2014{
local j=2008
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
forvalues x=2012/2014{
local j=2009
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
local j=2010
local x=2014
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'

*newid=493141610941-> same firm 
local newid=`"493141610941"'
forvalues i=1/3{
replace sameaszero`i'=1 if newid=="`newid'" & sameaszero`i'==0
}
forvalues j=1998/2000{
local x=2005
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}

*newid=533139610936-> business closed from 2000 t0 2001 and another one closed from 2003 to 2004 and another closed in 2007
*looks like temporary closure
local newid=`"533139610936"'
forvalues i=1/5{
replace sameaszero`i'=1 if newid=="`newid'" & sameaszero`i'==0
}

foreach j in 1997 1998 1999 2000 2003 2005{
local x=2007
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}

local j=2006
local x=2007
local i=`x'-`j'
replace survival_`i'yr=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=0 if newid=="`newid'" & surveyyear==`j'

*newid=542822590904 - same firm
local newid=`"542822590904"'
replace sameaszero1=1 if newid=="`newid'" & sameaszero1==0
local x=2014
local j=2008
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'

*newid=542844590921 - code as same firm
local newid=`"542844590921"'
forvalues i=1/3{
replace sameaszero`i'=1 if newid=="`newid'" & sameaszero`i'==0
}
forvalues j=2007/2009{
local x=2014
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}

*newid=543024540949 - same firm
local newid=`"543024540949"'
replace sameaszero1=1 if newid=="`newid'" & sameaszero1==0
local x=2014
local j=2008
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'

*newid=543545600927 - given that business is not said to be closed from 2013 to 2014, owner and sector stay the same, I code it as the continuation of the business (might be imperfect reporting of age of the firm)
local newid=`"543545600927"'
forvalues i=1/5{
replace sameaszero`i'=1 if newid=="`newid'" & sameaszero`i'==0
}
forvalues j=2008/2012{
local x=2014
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}

*newid=543545600940 - same business
local newid=`"543545600940"'
replace sameaszero1=1 if newid=="`newid'" & sameaszero1==0
local x=2011
local j=2008
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'

*newid=543545600968 - code as same business
local newid=`"543545600968"'
forvalues i=1/2{
replace sameaszero`i'=1 if newid=="`newid'" & sameaszero`i'==0
}
forvalues j=2008/2009{
local x=2014
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}

*newid=543545650921 - I code the business reported in 2009 as dying and the one in 2013 as a new one
local newid=`"543545650921"'
replace sameaszero2=0 if newid=="`newid'" & surveyyear==2013
local j=2009
local x=2013
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'

*newid=912129610911 - code as same
local newid=`"912129610911"'
forvalues i=1/2{
replace sameaszero`i'=1 if newid=="`newid'" & sameaszero`i'==0
}
forvalues j=2007/2008{
local x=2014
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}

*newid=912136600949 -> I code it as the same firm since owner stays the same and business is never reported to have been closed or to be a newly openend business
local newid=`"912136600949"'
forvalues i=1/4{
replace sameaszero`i'=1 if newid=="`newid'" & sameaszero`i'==0
}
forvalues j=2009/2012{
local x=2014
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}

*newid=912136600989 -> same firm (probably misreporting in age of the firm; owner and sector remain the same)
local newid=`"912136600989"'
forvalues i=1/2{
replace sameaszero`i'=1 if newid=="`newid'" & sameaszero`i'==0
}
forvalues j=2008/2009{
local x=2011
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}

*newid=912929610925 - same firm
local newid=`"912929610925"'
forvalues i=1/2{
replace sameaszero`i'=1 if newid=="`newid'" & sameaszero`i'==0
}
forvalues j=2008/2009{
local x=2014
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}

*newid=913545570904-> 3 different firms since owner and sector and age do not coincide
local newid=`"913545570904"'
replace sameaszero2=0 if  newid=="`newid'" & surveyyear==2013
forvalues x=2012/2014{
local j=2010
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
local j=2012
local x=2013
local i=`x'-`j'
replace survival_`i'yr=. if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
local j=2012
local x=2014
local i=`x'-`j'
replace survival_`i'yrs=. if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'


*I just need to change coding from 2008 to 2014 to survival
local newid=`"913545630989"'
replace sameaszero1=1 if newid=="`newid'" & sameaszero1==0
local x=2014
local j=2008
local i=`x'-`j'
replace survival_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'


*I check if there are cases in which newfirmstarted has been incorrectly coded because the firm was 1 year old
g anohelpcheck=0
replace anohelpcheck=1 if agefirm==1 & newfirmquex!=1 & period!=1
bysort newid: egen maxanohelpcheck=max(anohelpcheck)


*newid=072136530950-> same firm
local newid=`"072136530950"'
replace sameaszero1=1 if  newid=="`newid'" & sameaszero1==0
local j=2005
local x=2006
local i=`x'-`j'
replace survival_`i'yr=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=0 if newid=="`newid'" & surveyyear==`j'

*newid=072436600951 -> same firm
local newid=`"072436600951"'
replace sameaszero1=1 if  newid=="`newid'" & sameaszero1==0
local j=2002
local x=2003
local i=`x'-`j'
replace survival_`i'yr=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
local j=2002
local x=2004
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'

*newid=072729570949 - same firm from 2005 to 2008; the firm from 2010 is closed in 2011
local newid=`"072729570949"'
replace sameaszero2=1 if  newid=="`newid'" & sameaszero1==0 & surveyyear<=2008
replace sameaszero6=0 if  newid=="`newid'" & surveyyear==2014
local j=2005
local x=2006
local i=`x'-`j'
replace survival_`i'yr=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
forvalues x=2007/2008{
local j=2005
local i=`x'-`j'
replace survival_`i'yr=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
}
local j=2010
local x=2011
local i=`x'-`j'
replace survival_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
forvalues x=2012/2014{
local j=2010
local i=`x'-`j'
replace survival_`i'yr=0 if newid=="`newid'" & surveyyear==`j'
}

*newid=072729610970 - correctly coded

*newid=072729630977 - complicated case; given that I already worked on the inconsistencies for this household (see above), I leave it as it is

*newid=072729650873 - correctly coded

*newid=072729650941 - correctly coded

*newid=072729650981 - correctly coded

*newid=161945570902 - correctly coded

*newid=161945570925 - correctly coded

*newid=162827610940 - correctly coded

*newid=162827610977 - correctly coded

*newid=162827610981 - correctly coded

*newid=162827620958 - correctly coded

*newid=163545520927 - correctly coded

*newid=163545540956 - correctly coded

*newid=163545610956 - correctly coded

*newid=164245640968 - correctly coded

*newid=241945570904 - correctly coded

*newid=243029540927 -> same business
local newid=`"243029540927"'
forvalues i=1/2{
replace sameaszero`i'=1 if  newid=="`newid'" & sameaszero`i'==0
}
forvalues j=2009/2010{
local x=2014
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}

*newid=243029540940 - correctly coded

*newid=243029540949 - correctly coded

*newid=243029620967 - correctly coded

*newid=243545520902 - correctly coded

*newid=243545530950 - correctly coded

*newid=243545570904 - correctly coded

*newid=243545580911 - correctly coded

*newid=243545650936 - correctly coded

*newid=272930650926 - correctly coded

*newid=273238660936 -> same business
local newid=`"273238660936"'
forvalues i=1/2{
replace sameaszero`i'=1 if  newid=="`newid'" & sameaszero`i'==0
}
forvalues j=2007/2008{
forvalues x=2010/2011{
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
}

*newid=273240650941 - correctly coded

*newid=313736590950 - correctly coded

*newid=492624540977 - correctly coded

*newid=492624630962 - correctly coded

*newid=492624650937 - correctly coded

*newid=492624650971 - correctly coded

*newid=492838590905 - correctly coded

*newid=493141600924 - correctly coded

*newid=493141610928 - correctly coded

*newid=493141610940 - correctly coded

*newid=532636590936 - correctly coded

*newid=532938660936 - correctly coded

*newid=542838650968 - correctly coded

*newid=543545650940 - correctly coded


*If a firm is coded to be dead once, it should be so for all subsequent periods too:
replace survival_2yrs=0 if survival_1yr==0 & survival_2yrs==.
forvalues i=3/17{
local j=`i'-1
replace survival_`i'yrs=0 if survival_`j'yrs==0 & survival_`i'yrs==.
}


*newid=543545600961 -> code it as the same firm
local newid=`"543545600961"'
forvalues i=1/2{
replace sameaszero`i'=1 if  newid=="`newid'" & sameaszero`i'==0
}
forvalues j=2008/2009{
forvalues x=2013/2014{
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
}
*newid=333545490968 -> code it as the same firm
local newid=`"333545490968"'
replace sameaszero1=1 if  newid=="`newid'" & sameaszero1==0
forvalues x=2013/2014{
local j=2008
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}

*newid=242142590923 -> code it as the same firm
local newid=`"242142590923"'
forvalues i=1/2{
replace sameaszero`i'=1 if  newid=="`newid'" & sameaszero`i'==0
}
forvalues j=2008/2009{
forvalues x=2012/2014{
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
}
*newid=493235640911 -> code it as the same firm from 2008 on
local newid=`"493235640911"'
forvalues i=3/4{
replace sameaszero`i'=1 if  newid=="`newid'" & sameaszero`i'==0
}
forvalues j=2008/2009{
forvalues x=2013/2014{
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
}

*newid=912929590934 -> code it as the same firm from 2008 on
local newid=`"912929590934"'
forvalues i=1/2{
replace sameaszero`i'=1 if  newid=="`newid'" & sameaszero`i'==0
}
forvalues j=2008/2009{
forvalues x=2013/2014{
local i=`x'-`j'
replace survival_`i'yrs=1 if newid=="`newid'" & surveyyear==`j'
replace newfirmstarted_`i'yrs=0 if newid=="`newid'" & surveyyear==`j'
}
}

*TO DO: decide whether you need/want to change path for saving "TTHAImasterfc"
/**/
save TTHAImasterfc, replace
/**/

*Generate firmid for the clear cases 
sort newid surveyyear
egen helphhfirmid1=group(newid sameaszero1) if sameaszero1==1
forvalues i=2/16{
local j=`i'-1
egen helphhfirmid`i'=group(newid sameaszero`i') if sameaszero`j'==0 & sameaszero`i'==1
}

egen hhfirmid=group(newid helphhfirmid1-helphhfirmid16), m
order hhfirmid, after(hc_id)

*correct hhfirmid for some cases which are not so straightforward:
*newid=163029600979 - the business in 2012 is a different business (different sector, owner and age of the firm)
su hhfirmid
local help=`r(max)'
replace  hhfirmid=`help'+1 if newid=="163029600979" & surveyyear==2012

*newid=542844590904 - the firms reported in 2005 and 2011 are different firms from the one reported form 2007 to 2013
su hhfirmid
local help=`r(max)'
replace  hhfirmid=`help'+1 if newid=="542844590904" & surveyyear==2005
su hhfirmid
local help=`r(max)'
replace  hhfirmid=`help'+1 if newid=="542844590904" & surveyyear==2011

*TO DO: decide whether you need/want to change path for saving "TTHAImasterfc"
/**/
save TTHAImasterfc, replace
/**/

forvalues i=1997/2013{
local j=`i'+1
order hhbusowner_`j', after(hhbusowner_`i')
}

*Now decide on the owner - depending on the years in which the same hhfirmid is reported
keep if incl!=1
keep newid hc_id hhfirmid totaldupl surveyyear hhbusowner*

g hlpsvyear1=surveyyear

reshape wide hlpsvyear1, i(newid hc_id hhfirmid) j(surveyyear)

forvalues i=1997/2014{
replace hlpsvyear1`i'=(hlpsvyear1`i'!=.)
replace hhbusowner_`i'=hhbusowner_`i'*hlpsvyear1`i'
}
egen totalownership=rowtotal(hhbusowner_1997-hhbusowner_2014)
bysort hhfirmid: egen maxtotalownership=max(totalownership)
g hlpincl=(maxtotalownership==totalownership)
duplicates tag hhfirmid hlpincl, gen(duplhlpincl)
g incl=.
*In case there are no duplicates in maximum ownership
replace incl=(hlpincl==1) if duplhlpincl==0
bysort hhfirmid: egen helpinclonemaxo=total(incl)
replace incl=0 if incl==. & helpinclonemaxo==1

*duplicates in terms of owner/person:
duplicates tag newid hc_id, gen(duplperson)

*If person only appears once, chose owner with the lowest hc_id (this will choose the household head if he/she is among the owners)
bysort hhfirmid: egen testincl=total(incl)
bysort hhfirmid: egen totalduplperson=total(duplperson)
sort hhfirmid newid hc_id
bysort hhfirmid: egen minhc_id=min(hc_id)
g helpminhc_id=(minhc_id==hc_id)
replace incl=(helpminhc_id==1) if duplhlpincl>0 &  duplhlpincl!=. & duplperson==0 & totalduplperson==0 & test!=1
drop test

*If person appears more than once, is already included for another business and is one of the persons with maximum ownership, I choose this owner
bysort hhfirmid: egen testincl=total(incl)
g helpmultfirms=hc_id if duplperson>0 & duplperson!=. & incl==1 
*depends on the number included of firms per household
bysort newid: egen counthelpmultfirms=count(helpmultfirms)
bysort newid: egen totalhelpmultfirms=total(helpmultfirms) if count==1
replace incl=1 if hlpincl==1 & hc_id==totalhelpmultfirms & duplperson>0 & duplperson!=. & incl==. & count==1 & test!=1
drop test

*If there are more than one firm per household included, but maxowner is the same for all of them:
bysort hhfirmid: egen testincl=total(incl)
egen helphelpmultfirms=group(newid helpmultfirms) if count>1 & count!=.
bysort newid: egen mdevhelphelpmultfirms=mdev(helphelpmultfirms) if count>1 & count!=.
bysort newid: egen totalhelpmultfirms2=total(helpmultfirms) if count>1 & count!=. & mdevhelphelpmultfirms==0
replace totalhelpmultfirms2=totalhelpmultfirms2/count if count>1 & count!=. & mdevhelphelpmultfirms==0
replace incl=1 if hlpincl==1 & hc_id==totalhelpmultfirms2 & duplperson>0 & duplperson!=. & incl==. & count>1 & count!=1 & test!=1
drop testincl

bysort hhfirmid: egen testincl=total(incl)

*I replace incl=0 if incl=. but testincl==1:
replace incl=0 if incl==. & testincl==1

*Otherwise I choose person with maximum ownership 
replace incl=(hlpincl==1) if duplhlpincl==0 & incl==.

*And if more than one have maximum ownership for the same business, I choose the one with the lowest hc_id
bysort hhfirmid: egen newminhc_id=min(hc_id) if incl==.
g newhelpminhc_id=(newminhc_id==hc_id) if incl==.
replace incl=(newhelpminhc_id==1) if incl==. 

*I check if all household firms are included:
drop test
bysort hhfirmid: egen testincl=total(incl)

*-> all hhfirmids have one single member that is to be included

keep newid hc_id hhfirmid incl hlpsvyear11997-hlpsvyear12014

reshape long hlpsvyear1, i(newid hc_id hhfirmid) j(surveyyear)
keep if hlpsvyear1==1
drop hlpsvyear1

*TO DO: decide whether you need/want to change path for saving "TTHAImasterfchlp"
/**/
save TTHAImasterfchlp, replace
/**/

*TO DO: change path to where you saved the following file "TTHAImasterfc"
/*EXAMPLE:*/
use TTHAImasterfc, clear
/**/

*TO DO: change path to where you saved the following file "TTHAImasterfchlp"
/*EXAMPLE:*/
merge 1:1 newid hc_id hhfirmid surveyyear using TTHAImasterfchlp, update
/**/

*TO DO: decide whether you need/want to change path for saving "TTHAImasterfc"
/**/
save TTHAImasterfc, replace
/**/

*test if for a given household owners change depending on hhfirmid
bysort newid: egen mdevhc_id=mdev(hc_id) if incl==1
tab mdev
*-> there are less than 5% of households in the sample for which firm owners change depending on hhfirmid 
* only in these cases, newfirmstarted might have been calculated imperfectly

keep if incl==1

*Generate owner id, since, if the same owner opens a new firm, that should be accounted for:
egen ownerid=group(newid hc_id)

*Household id: a household appears multiple times with different businesses if the businesses are either new and old ones or if they are different businesses
egen householdid=group(newid)

tostring survey, replace
replace survey="BL-"+survey if survey=="1997"
replace survey="R-"+survey if survey!="BL-1997" & survey!="2014"
replace survey="L-"+survey if survey=="2014"

g lastround=(surveyyear==2014)

drop totaldupl check period* maxperiod helpcheck sameaszero* help* hhbusowner* nonfarm dupl newhelpcheck* maxnewhelpcheck anohelpcheck maxanohelpcheck helphhfirmid* _merge mdevhc_id incl

*TO DO: decide whether you need/want to change path for saving "TTHAImasterfc"
/**/
save TTHAImasterfc, replace
/**/

*Make ids look nicer
foreach x of varlist hhfirmid ownerid householdid{
tostring `x', format("%04.0f") replace
replace `x'="TTHAI"+"-"+`x'
}

rename hhfirmid firmid

*TO DO: Make sure the final dataset "TTHAImasterfc.dta" is saved in the folder “Do-files and readme/Construction of Dataset/Data for combination”
/**/
save TTHAImasterfc, replace
/**/
