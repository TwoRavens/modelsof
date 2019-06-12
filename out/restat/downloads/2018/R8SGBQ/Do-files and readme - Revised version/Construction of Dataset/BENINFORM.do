********************************************************************************

********************************************************************************
**THIS DO-FILE PREPARES THE DATA FROM THE CONTONOU INFORMAL ENTERPRISE SURVEY FOR COMBINATION INTO THE MASTER DATASET
**Small Firm Death in Developing Countries
**November 20, 2017
**David McKenzie (dmckenzie@worldbank.org) and Anna Luisa Paffhausen (apaffhausen@worldbank.org)
**The analysis was performed with Stata, version 14.2

*Notes:
* The underlying raw data needed to replicate this do-file is available in the World Bank's Microdata Catalogue.
* To replicate this do-file:
* 1) Go to http://microdata.worldbank.org/index.php/catalog/2793/
* 2) Download the data files in Stata format (http://microdata.worldbank.org/index.php/catalog/2793/download/39704)
* 3) Change the directory in the do-file 
* 4) Change the paths to the data you are using and for saving the datasets that are created in this do-file (BENINFORM1, BENINFORM2, BENINFORM3, and BENINFORM_masterfc)
*    Make sure the final dataset (BENINFORM_masterfc) is saved in the folder “Do-files and readme/Construction of Dataset/Data for combination”

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
*TO DO: change path to where you saved the following file "listing_data_an.dta"
/*EXAMPLE:
use "Benin/listing_data_an.dta",clear
*/

*Keep only study data
keep if  sample_final==1

*Country
g country="Benin"

*Surveyyear
g surveyyear=2014

*Wave
g wave=1

*Treatment status
g treatstatus=(group!=0)
g control=(group==0)


*Local to USD exchange rate at time of survey
*Survey took place in March and April 2014, so I take March 31, 2014 as approx. midpoint
g excrate=0.00210

g excratemonth="3-2014"

********************************************************************************
*Owner and Household characteristics
********************************************************************************

*Age of owner
rename lis_d7 ownerage
*There are some few obs. with age=7 | 8 | 9 which seems strange but for now I keep them

*Gender of owner
g female=(lis_d6==2)


********************************************************************************
*Firm characteristics
********************************************************************************
*Age of the firm in years
*Since for 2 years and older there are only ranges given, I create a new variable:
label define firmagerangesBenin 1 "Less than 1 year" ///
								2 "Between 1 and 2 years" ///
								3 "Between 2 and 5 years" ///
								4 "More than 5 years" ///
								9 "Don't know"

rename lis_e7 agefirmBeninr

label values agefirmBeninr firmagerangesBenin

g agefirm=0 if agefirmBeninr==1
replace agefirm=1 if agefirmBeninr==2

*Firm is in retail trade
g retail=(lis_b3==3) if lis_b3!=. & lis_b3!=9
replace retail=1 if (lis_e2==501 | lis_e2==502) & (lis_b3==. | lis_b3==9)

*Firm is in manufacturing sector
g manuf=(lis_b3==1) if lis_b3!=. & lis_b3!=9
replace manuf=1 if (lis_e2==904 | lis_e2==930 | lis_e2==954) & (lis_b3==. | lis_b3==9)

*Firm is in service sector
g services=(lis_b3==2) if lis_b3!=. & lis_b3!=9
replace services=1 if (lis_e2==1102 | lis_e2==1808) & (lis_b3==. | lis_b3==9)

*Firm is in other sector
g othersector=(lis_b3==4) if lis_b3!=. & lis_b3!=9
replace othersector=1 if (lis_e2==701 | lis_e2==1900) & (lis_b3==. | lis_b3==9)

*Not sure if it is ISIC but I code it just in case:
g sector=lis_e2 

*Number of total workers
rename lis_e21 totalworkers

*Business profits in last month
rename lis_e34 profits

*Business sales in last month
g sales=lis_e33*4


********************************************************************************

keep 	ID_firm_anonym ///
		country surveyyear wave treatstatus control excrate excratemonth ///
		ownerage female ///
		agefirmBeninr agefirm retail manuf services sector totalworkers profits sales

foreach var of varlist surveyyear wave excrate excratemonth ///
				ownerage female ///
				agefirmBeninr agefirm retail manuf services sector {
rename `var' `var'1
}
*TO DO: decide whether you need/want to change path for saving BENINFORM1
/*
save BENINFORM1, replace
*/

********************************************************************************

********************************************************************************
*Panel variables
********************************************************************************

********************************************************************************#
*Round 2 
*TO DO: change path to where you saved the following file "midline_data_an.dta"
/*EXAMPLE:
use "Benin/midline_data_an.dta", clear
*/
*Surveyyear
g surveyyear=2015

*Wave
g wave=2

*Survival
g survival=0 if mid_c5==2
replace survival=0 if mid_c1==3
replace survival=1 if mid_c5==1
replace survival=1 if mid_e2==1
replace survival=1 if mid_e2==2 & mid_e2_2==1
replace survival=0 if mid_e2==2 & mid_e2_2==2

*New firm started since last survey
g newfirmstarted=1 if mid_e2==2 & mid_e2_2==2
replace newfirmstarted=0 if survival==1 | mid_c1==3 | mid_c5==2

*Owner died between survey rounds
g died=(mid_c1==6)

*Number of total workers
egen totalworkers=rowtotal(mid_e11_a mid_e12_a mid_e13_a mid_e14_a), m
replace totalworkers=. if totalworkers<0
replace totalworkers=mid_c6 if totalworkers==. & mid_c6!=-99 & mid_c6!=-77

*Business profits in last month
rename mid_g17 profits
replace profits=. if profits==-99 | profits==-77

*Business sales in last month
g sales=mid_g16*4
replace sales=. if sales==-99 | sales==-77

*Hours worked in self-employment in last month
*based on hours worked  in last week
g hours=mid_e3*(30/7) if mid_e3!=-99 & mid_e3!=-77

*based on hours worked in normal week
g hoursnormal=mid_e4*(30/7) if mid_e4!=99 & mid_e4!=-77

*Subjective wellbeing on Cantril ladder
rename mid_m1 subjwell
replace subjwell=. if subjwell<0

*Education of owner
**Owner's education in years
rename mid_d24 educyears
replace educyears=. if educyears<0

*Firm attrits from survey
g attrit=(mid_c1!=3 & mid_c1!=.)

*Local to USD exchange rate at time of survey
*According to mid_b4_1m, survey took place in March, April and May 2015, so I take April 15, 2015 as approx. midpoint
g excrate=0.00161

g excratemonth="4-2015"


keep 	ID_firm_anonym ///
		surveyyear wave ///
		excrate excratemonth ///
		totalworkers profits sales hours hoursnormal ///
		survival newfirmstarted attrit died ///
		subjwell educyears


foreach var of varlist 	surveyyear wave ///
						excrate excratemonth ///
						totalworkers profits sales hours hoursnormal ///
						survival newfirmstarted attrit died ///
						subjwell educyears {
rename `var' `var'2
}	

*TO DO: decide whether you need/want to change path for saving BENINFORM2
/*
save BENINFORM2, replace
*/

********************************************************************************#
*Round 3
*TO DO: change path to where you saved the following file "endline_data_an.dta"
/*EXAMPLE:
use "Benin/endline_data_an.dta", clear
*/

*Surveyyear
g surveyyear=2016

*Wave
g wave=3

*Survival
g survival=0 if end_C1==4
replace survival=0 if end_C3B==2
replace survival=1 if end_C3B==1
replace survival=1 if end_E2==1
replace survival=1 if end_E2==2 & end_E2_2==1
replace survival=0 if end_E2==2 & end_E2_2==2

*New firm started since last survey
g newfirmstarted=1 if (end_E2==2 & end_E2_2==2) | end_C8==1 | end_C8==2
replace newfirmstarted=0 if survival==1 | ((end_C1==4 | end_C3B==2) & (end_C8!=1 & end_C8!=2 & end_C8!=.) )

*Reason for closing business
gen reasonclosure=end_C6
replace reasonclosure=3 if end_C6==5
replace reasonclosure=4 if end_C6==3
replace reasonclosure=10 if end_C6==4
replace reasonclosure=5 if end_C6==6
replace reasonclosure=9 if end_C6==12

replace reasonclosure=1 if end_C6A=="PAS ASSEZ DE CLIENTS" |  end_C6A=="ET AUGMENTATION  DES  CHARGES" | end_C6A=="MEVENTE" | end_C6A=="FUTE DU TUYEAU DE LA SONEB ET LES FACTURES DE MONTANT ENORME VENAIENT" | ID_firm_anonym=="F0607"| ID_firm_anonym=="F7543"| ID_firm_anonym=="F3604"| ID_firm_anonym=="F2956"
replace reasonclosure=2 if ID_firm_anonym=="F9373"
replace reasonclosure=4 if ID_firm_anonym=="F7957"
replace reasonclosure=5 if ID_firm_anonym=="F4897" | ID_firm_anonym=="F5672"


label define closereason 1 "making a loss" 2 "sickness" 3 "care for family" 4 "better wage job" 5 "migrate abroad" 6 "married" 7 "shut down by govt." 8 "taken from me" 9 "other" 10 "better business opportunity" 11 "catastrophe"
label values reasonclosure closereason

*Main activity after closing business
label define mainactivity 	1 "Working for a wage" ///
							2 "Looking for work" ///
							3 "Operating a different business" ///
							4 "Housework or looking after children" ///
							5 "Unemployed" ///
							6 "Working in a family business, unpaid"


g mainactivity=1 if end_C8==3 | end_C8==4 | end_C8==5 | end_C8==6
replace mainactivity=3 if end_C8==1 | end_C8==2 | newfirmstarted==1
replace mainactivity=4 if end_C7==3
replace mainactivity=5 if end_C7==4
replace mainactivity=6 if end_C7==2
replace mainactivity=2 if end_C13==1 | end_C13==2

label values mainactivity mainactivity	

replace newfirmstarted=0 if mainactivity!=3 & mainactivity!=.

*Worked as wage worker in last month
g wageworker=(mainactivity==1) if end_C8!=. | mainactivity!=.

*Owner died between survey rounds
g died=(end_C1==6)

*Number of total workers
egen totalworkers=rowtotal(end_E6_A end_E7_A end_E8_A end_E9_A), m

*Business profits in last month
rename end_G17 profits
replace profits=. if profits==-99 | profits==-88 | profits==-77

*Labor earnings from all labor, including the business, in last month
g monthlywagelaborincome=end_C11*(30/7) if end_C11!=-99 & end_C11!=-77
egen laborincome=rowtotal(monthlywagelaborincome profits), m

*Business sales in last month
g sales=end_G16*4
replace sales=. if end_G16==-99 | end_G16==-77

*Hours worked in self-employment in last month
*based on hours worked  in last week
g hours=end_E3*(30/7) if end_E3!=-99 & end_E3!=-77

*based on hours worked in normal week
g hoursnormal=end_E4*(30/7) if end_E4!=-99 & end_E4!=-77

*Subjective wellbeing on Cantril ladder
rename end_L1 subjwell
replace subjwell=. if subjwell<0

*Firm attrits from survey
g attrit=(end_C1!=4 & end_C1!=.)

*Local to USD exchange rate at time of survey
*According to end_B4_1M, survey took place in May and June 2016, so I take May 31, 2016 as approx. midpoint
g excrate=0.00168

g excratemonth="5-2016"


keep 	ID_firm_anonym ///
		surveyyear wave ///
		excrate excratemonth ///
		totalworkers profits sales hours hoursnormal ///
		wageworker laborincome ///
		survival newfirmstarted attrit died reasonclosure mainactivity ///
		subjwell


foreach var of varlist 	surveyyear wave ///
						excrate excratemonth ///
						totalworkers profits sales hours hoursnormal ///
						wageworker laborincome ///
						survival newfirmstarted attrit died reasonclosure mainactivity ///
						subjwell {
rename `var' `var'3
}	

*TO DO: decide whether you need/want to change path for saving BENINFORM3
/*EXAMPLE:
save BENINFORM3, replace
*/
********************************************************************************

********************************************************************************
*Merge rounds 1-3 together
********************************************************************************

********************************************************************************
*TO DO: change path to where you saved the following file "BENINFORM1.dta"
/*EXAMPLE
use BENINFORM1, clear
*/

*TO DO: change path to where you saved the following files "BENINFORM2.dta", "BENINFORM3.dta"
/*
EXAMPLE
forvalues i=2/3{
merge 1:1 ID_firm_anonym using BENINFORM`i', nogenerate
}
*/
quietly: reshape long 	surveyyear wave excrate excratemonth ///
						ownerage female educyears ///
						agefirmBeninr agefirm retail manuf services sector ///
						, ///
						i(ID_firm_anonym) j(survey)
							
foreach x in profits sales totalworkers {
replace `x'=. if wave!=1
}	

*Recode survival, so that it gives survival since baseline, assuming that so far it has been coded from round to round
replace survival3=0 if survival2==0 & survival3==1 & newfirmstarted2==1

*Only keep if business is operating
forvalues i=2/3{
drop if survival`i'!=1 & wave==`i'
}

foreach x in survival newfirmstarted attrit totalworkers hours hoursnormal subjwell profits sales died {
g `x'_1p083yrs=`x'2 if wave==1
drop `x'2
g `x'_2p167yrs=`x'3 if wave==1
drop `x'3
}	

foreach x in reasonclosure mainactivity wageworker laborincome {
g `x'_2p167yrs=`x'3 if wave==1
drop `x'3
}

*Somehow survey receives a value label which then prevents me from doing the tostring so I work around it this way:
rename survey surveyuseless
g survey=surveyuseless
drop surveyuseless

tostring survey, replace
replace survey="BL-"+string(surveyyear) if wave==1
replace survey="R-"+string(surveyyear) if wave==2 
replace survey="L-"+string(surveyyear) if wave==3 

g lastround=(wave==3)

*Generate owner, household and business id (which are the same here)
foreach var in ownerid firmid householdid{
egen `var'=group(ID_firm_anonym)
tostring `var', format("%04.0f") replace
replace `var'="BENINFORM"+"-"+`var'
}

g surveyname="BENINFORM"

*TO DO: Make sure the final dataset "BENINFORM_masterfc.dta" is saved in the folder “Do-files and readme/Construction of Dataset/Data for combination”
/*
save BENINFORM_masterfc, replace
*/				
