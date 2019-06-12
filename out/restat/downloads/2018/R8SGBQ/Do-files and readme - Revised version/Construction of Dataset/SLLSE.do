********************************************************************************

********************************************************************************
**THIS DO-FILE PREPARES THE DATA FROM THE SRI LANKA LONGITUDINAL SURVEY OF ENTERPRISES FOR COMBINATION INTO THE MASTER DATASET
**Small Firm Death in Developing Countries
**March 12, 2018
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
*Some cleaning

use "SLLSE/FirmDeathDataSLLSE.dta", clear
duplicates report respondent_id
*One duplicate in respondent_id
duplicates report
*there are no duplicates in all variables

foreach var of varlist control-attrit11{
duplicates report `var' if respondent_id==3298
}
*Duplicates are in profits8 sales8 hours8 laborincome8
list profits8 sales8 hours8 laborincome8 if respondent_id==3298

*I drop the duplicate respondent_id obs. for which profits8, sales8 and hours8 are missing and laborincome8 is 0
drop if respondent_id==3298 & profits8==.

save "SLLSE/FirmDeathDataSLLSEclean.dta", replace

********************************************************************************

********************************************************************************
*Baseline variables
********************************************************************************

********************************************************************************

use "SLLSE/booster_oct08.dta",clear

rename *, upper

tostring Q1_1, replace

forvalues i=8/9{

replace Q1_`i'M="1" if Q1_`i'M=="January"
replace Q1_`i'M="2" if Q1_`i'M=="February"
replace Q1_`i'M="3" if Q1_`i'M=="March"
replace Q1_`i'M="4" if Q1_`i'M=="April"
replace Q1_`i'M="5" if Q1_`i'M=="May"
replace Q1_`i'M="6" if Q1_`i'M=="June" | Q1_`i'M=="june"
replace Q1_`i'M="7" if Q1_`i'M=="July" | Q1_`i'M=="july"
replace Q1_`i'M="8" if Q1_`i'M=="August" | Q1_`i'M==" August"
replace Q1_`i'M="9" if Q1_`i'M=="September"
replace Q1_`i'M="10" if Q1_`i'M=="October"
replace Q1_`i'M="11" if Q1_`i'M=="November"
replace Q1_`i'M="12" if Q1_`i'M=="December"
 
destring Q1_`i'M, replace
replace  Q1_`i'M=. if Q1_`i'M>12

}
 
rename Q8_10 Q8_10booster
rename Q8_21 Q8_21booster

tostring Q13_1 Q13_2 Q13_3, replace

append using "SLLSE/SLSE NSF Round1 Raw.dta"

*Remove duplicates in SHENO
duplicates report SHENO
*Two shenos for which we have duplicates
duplicates report
*there are no duplicates in all variables
duplicates example SHENO

*Data cleaning
foreach var of varlist BOOSTER-Q16_8{
quietly: duplicates tag SHENO `var' if SHENO==13 | SHENO==3632, gen(dupl_`var')
list `var' if dupl_`var'==0 & SHENO==13
list `var' if dupl_`var'==0 & SHENO==3632
quietly: drop dupl_`var'
}
*Obs. 845 of SHENO==13 seems to have less information (missings in  Q7_1* except for Q7_1B7, for which it has 9 and the other obs. 0) so I drop this one
drop in 845

*Obs. 630 of SHENO==3632 has missings in Q12_2_8-Q12_2_11 which are used to construct raven, so I drop this one, although the two obs. have a number of variables for which they have differing values
drop in 630


*Country
g country="Sri Lanka"

*Surveyyear
g surveyyear=2008

*Wave
g wave=1


*Survey took place between in October 2008, so I take October 15, 2008 as approx. midpoint
g excrate=0.00924 
g excratemonth="10-2008" 

********************************************************************************
*Owner and Household characteristics
********************************************************************************

*Age of owner
rename Q1_20 ownerage

*Gender of owner
g female=(Q1_21==2)

*Marital status of owner
g married=(Q1_22==2)

*Education of owner
**Owner's education in years (only if university or higher!)
gen educyears=Q2_1
replace educyears=Q2_2 if Q2_1>=14 & Q2_1<18

**Owner has tertiary education
g ownertertiary=(Q2_1==15 | Q2_1==16 | Q2_1==17)

*Has child under 5
forvalues i=2/12{
local j=`i'-1
order Q4_5_`i', after(Q4_5_`j')
}
egen childunder5=anymatch(Q4_5_1-Q4_5_12), values(0/4)

*Has child aged 5 to 12
egen childaged5to12=anymatch(Q4_5_1-Q4_5_12), values(5/11)

*Has elderly member in household
foreach var of varlist Q4_5_1-Q4_5_12{
replace `var'=. if `var'==999
}
egen helpmaxage=rowmax(Q4_5_1-Q4_5_12)
su helpmaxage
egen adult65andover=anymatch(Q4_5_1-Q4_5_12), values(65/`r(max)')

*Digit span recall of owner
g digitspan=3 if Q13_4A==2 
replace digitspan=4 if Q13_4A==1 & Q13_4B==2
replace digitspan=5 if Q13_4B==1 & Q13_4C==2
replace digitspan=6 if Q13_4C==1 & Q13_4D==2
replace digitspan=7 if Q13_4D==1 & Q13_4E==2
replace digitspan=8 if Q13_4E==1 & Q13_4F==2
replace digitspan=9 if Q13_4F==1 & Q13_4G==2
replace digitspan=10 if Q13_4G==1 & Q13_4H==2
replace digitspan=11 if Q13_4H==1

*Raven score of owner
gen raven1=Q12_2_1==8
gen raven2=Q12_2_2==4
gen raven3=Q12_2_3==5
gen raven4=Q12_2_4==1
gen raven5=Q12_2_5==2
gen raven6=Q12_2_6==5
gen raven7=Q12_2_7==6
gen raven8=Q12_2_8==3
gen raven9=Q12_2_9==7
gen raven10=Q12_2_10==8
gen raven11=Q12_2_10==7
gen raven12=Q12_2_12==6
 
egen raven=rsum(raven1-raven12)
replace raven=raven/12


********************************************************************************
*Firm characteristics
********************************************************************************
*Age of the firm in years
g helpivwdate="10"+"-"+"2008"
g ivwmonth=monthly(helpivwdate,"MY")

g date_yy=2008

g helpbusstartdate=string(Q1_9M)+"-"+string(Q1_9Y) if Q1_9M!=99 & Q1_9Y!=9999 & Q1_9Y!=99
g busstartdate=monthly(helpbusstartdate,"MY")

g agefirm=(ivwmonth-busstartdate)/12 if busstartdate!=.
replace agefirm=0 if agefirm<0

replace agefirm=date_yy-Q1_9Y if agefirm==. & Q1_9Y!=. & Q1_9Y!=9999 & Q1_9Y!=99

replace agefirm=round(agefirm,0.5)

*Capital stock
g capitalstock=Q7_1A7

*Inventories
g inventories=Q7_3
replace inventories=0 if Q7_2==2

*Code it based on ISIC rev. 3
destring Q1_1, replace
tostring Q1_1, replace
g Q1_1h=substr(Q1_1, 1,2)
destring Q1_1h, replace

*Firm is in retail trade
g retail=(Q1_1h>=50 & Q1_1h<=54) if Q1_1h!=.

*Firm is in manufacturing sector
g manuf=(Q1_1h>=15 & Q1_1h<=37) if Q1_1h!=.

*Firm is in service sector
g services=(Q1_1h>=55 & Q1_1h<=93) if Q1_1h!=.

*Firm is in other sector
g othersector=((Q1_1h>=10 & Q1_1h<=14) | (Q1_1h>=40 & Q1_1h<=45) | (Q1_1h>=95 & Q1_1h<=99)) if Q1_1h!=.

rename Q1_1 sector
destring sector, replace

*Employees
egen employees=rowtotal(Q1_13B1 Q1_13B2), m


*Profits in last month
rename Q7_10 profits

*Sales in last month
rename Q7_5 sales

*Hours worked in self-employment in last month
*based on hours worked  in last week
g hours=Q1_2A*(30/7) 

*based on hours worked  in a normal week
g hoursnormal=Q1_2B*(30/7) 

*subjective well-being on a cantril ladder
g subjwell=Q11_1 if Q11_1!=99


********************************************************************************
*Competition facing firm
********************************************************************************
*Number of competitors (here: in same G.N.)
replace Q10_2=. if Q10_2==999
rename Q10_2 competition1

*Customers could replace them within a day
g competition2=(Q10_9==1) if Q10_9!=9

*Most important competitor is within 1 km (here: in same G.N.)
g competition3=(Q10_4==1) if Q10_4!=9

********************************************************************************
replace BOOSTER=0 if BOOSTER==.
keep 	SHENO BOOSTER ///
		country surveyyear wave excrate excratemonth ///
		ownerage female married educyears ownertertiary childunder5 childaged5to12 adult65andover digitspan raven ///
		agefirm capitalstock inventories retail manuf services othersector sector employees profits sales hours hoursnormal subjwell ///
		competition1 competition2 competition3 

foreach var of varlist 	surveyyear wave excrate excratemonth ///
						ownerage female married educyears ownertertiary childunder5 childaged5to12 adult65andover digitspan raven ///
						agefirm capitalstock inventories retail manuf services othersector sector employees profits sales hours hoursnormal subjwell ///
						competition1 competition2 competition3{
						rename `var' `var'1
						}		

rename SHENO sheno
rename BOOSTER booster
save SLLSE1, replace

merge 1:1 sheno using "SLLSE/SLSE NSF Round2 Raw.dta", nogenerate
drop wave

*Only keep those firms that report no changes since baseline
keep if booster==1 | (booster==0 & (q1_1==1 | q1_1==3))

*Replace values of profits, sales, capital stock and inventories
replace profits=. if booster==0
replace profits=q7_10 if booster==0

replace sales=. if booster==0
replace sales=q7_5 if booster==0

replace capitalstock=. if booster==0
replace capitalstock=q7_1ap7 if booster==0

replace inventories=. if booster==0
replace inventories=q7_3 if booster==0
replace inventories=0  if booster==0 & q7_2==2

rename sheno respondent_id

keep 	respondent_id booster ///
		country surveyyear wave excrate1 excratemonth ///
		ownerage female married educyears ownertertiary childunder5 childaged5to12 adult65andover digitspan raven ///
		agefirm capitalstock inventories retail manuf services othersector sector employees profits sales hours1 hoursnormal subjwell ///
		competition1 competition2 competition3 

save SLLSE1, replace

merge 1:1 respondent_id using "SLLSE/FirmDeathDataSLLSEclean.dta", nogenerate keep(matched)

g treatstatus=(control==0)

forvalues i=2/11{
g excratemonth`i'=string(surveymonth`i') + "-" + string(surveyyear`i')
}

*excrate2 at April 15, 2009:
g excrate2=0.00862
*excrate3 at October 15, 2009:
g excrate3=0.00870
*excrate4 at April 15, 2010:
g excrate4=0.00878
*excrate5 at October 15, 2010:
g excrate5=0.00894
*excrate6 at April 15, 2011:
g excrate6=0.00905
*excrate7 at October 15, 2011:
g excrate7=0.00906
*excrate8 at April 15, 2012:
g excrate8=0.00772
*excrate9 at October 15, 2012:
g excrate9=0.00762
*excrate10 at April 15, 2013:
g excrate10=0.00797
*excrate11 at April 15, 2014:
g excrate11=0.00765



quietly: reshape long 	surveyyear wave excrate excratemonth ///
						ownerage female married educyears ownertertiary childunder5 childaged5to12 adult65andover digitspan raven ///
						agefirm capitalstock inventories retail manuf services othersector sector /*employees profits sales hours hoursnormal subjwell*/ ///
						competition1 competition2 competition3, ///
						i(respondent_id) j(survey)
						
replace wave=survey

*Recode survival, which has so far been coded from round to round so that it gives survival since baseline

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


foreach x in employees profits sales hours hoursnormal subjwell {
rename `x'1 `x'
replace `x'=. if wave!=1
}	

*Only keep if business is operating
forvalues i=2/11{
drop if survival`i'!=1 & wave==`i'
}

foreach x in survival newfirmstarted attrit mainactivity reasonforclosure employees profits sales hours  laborincome{
g `x'_6mths=`x'2 if wave==1
drop `x'2
g `x'_1yr=`x'3 if wave==1
drop `x'3
g `x'_18mths=`x'4 if wave==1
drop `x'4
g `x'_2yrs=`x'5 if wave==1
drop `x'5
g `x'_30mths=`x'6 if wave==1
drop `x'6
g `x'_3yrs=`x'7 if wave==1
drop `x'7
g `x'_3p5yrs=`x'8 if wave==1
drop `x'8
g `x'_4yrs=`x'9 if wave==1
drop `x'9
g `x'_4p5yrs=`x'10 if wave==1
drop `x'10
g `x'_5p5yrs=`x'11 if wave==1
drop `x'11
}	

*Recode survival based on Grp01 Question 1_6 reasons for answer option 6_2017-08-22.xls
*Round 3 - October 2009
replace reasonforclosure_1yr=11 if wave==1 & respondent_id==164
replace reasonforclosure_1yr=5 if wave==1 & respondent_id==833
replace reasonforclosure_1yr=4 if wave==1 & respondent_id==1594
replace reasonforclosure_1yr=1 if wave==1 & respondent_id==1674
replace reasonforclosure_1yr=3 if wave==1 & respondent_id==2027
replace reasonforclosure_1yr=11 if wave==1 & respondent_id==3153
replace reasonforclosure_1yr=11 if wave==1 & respondent_id==3181
replace reasonforclosure_1yr=1 if wave==1 & respondent_id==3182
replace reasonforclosure_1yr=1 if wave==1 & respondent_id==3335
replace reasonforclosure_1yr=4 if wave==1 & respondent_id==3372
replace reasonforclosure_1yr=4 if wave==1 & respondent_id==3477
replace reasonforclosure_1yr=1 if wave==1 & respondent_id==3572
replace reasonforclosure_1yr=1 if wave==1 & respondent_id==3658
replace reasonforclosure_1yr=3 if wave==1 & respondent_id==2027
replace reasonforclosure_1yr=12 if wave==1 & respondent_id==3799
*12 is migrate abroad; I will have to recode it later
replace reasonforclosure_1yr=5 if wave==1 & respondent_id==3818

*Round 5 - October 2010
replace reasonforclosure_2yrs=1 if wave==1 & respondent_id==24
replace reasonforclosure_2yrs=5 if wave==1 & respondent_id==831
replace reasonforclosure_2yrs=7 if wave==1 & respondent_id==1075
replace reasonforclosure_2yrs=5 if wave==1 & respondent_id==1458
replace reasonforclosure_2yrs=5 if wave==1 & respondent_id==1473
replace reasonforclosure_2yrs=7 if wave==1 & respondent_id==1560
replace reasonforclosure_2yrs=5 if wave==1 & respondent_id==3026
replace reasonforclosure_2yrs=4 if wave==1 & respondent_id==3096
replace reasonforclosure_2yrs=7 if wave==1 & respondent_id==3393
replace reasonforclosure_2yrs=3 if wave==1 & respondent_id==3427
replace reasonforclosure_2yrs=7 if wave==1 & respondent_id==3454
replace reasonforclosure_2yrs=7 if wave==1 & respondent_id==3722
replace reasonforclosure_2yrs=5 if wave==1 & respondent_id==3828

*Round 6 - April-May 2011
replace reasonforclosure_30mths=1 if wave==1 & respondent_id==182
replace reasonforclosure_30mths=1 if wave==1 & respondent_id==221
replace reasonforclosure_30mths=5 if wave==1 & respondent_id==731
replace reasonforclosure_30mths=5 if wave==1 & respondent_id==1096
replace reasonforclosure_30mths=7 if wave==1 & respondent_id==1708
replace reasonforclosure_30mths=5 if wave==1 & respondent_id==3364
replace reasonforclosure_30mths=2 if wave==1 & respondent_id==3427
replace reasonforclosure_30mths=7 if wave==1 & respondent_id==3449
replace reasonforclosure_30mths=7 if wave==1 & respondent_id==3454
replace reasonforclosure_30mths=5 if wave==1 & respondent_id==3573
replace reasonforclosure_30mths=5 if wave==1 & respondent_id==3632
replace reasonforclosure_30mths=7 if wave==1 & respondent_id==3634

*Round 7 - October 2011
replace reasonforclosure_3yrs=7 if wave==1 & respondent_id==285
replace reasonforclosure_3yrs=1 if wave==1 & respondent_id==1392
replace reasonforclosure_3yrs=5 if wave==1 & respondent_id==1477
replace reasonforclosure_3yrs=12 if wave==1 & respondent_id==1674
replace reasonforclosure_3yrs=1 if wave==1 & respondent_id==2135
replace reasonforclosure_3yrs=1 if wave==1 & respondent_id==3046
replace reasonforclosure_3yrs=1 if wave==1 & respondent_id==3047
replace reasonforclosure_3yrs=5 if wave==1 & respondent_id==3319
replace reasonforclosure_3yrs=11 if wave==1 & respondent_id==3434
replace reasonforclosure_3yrs=12 if wave==1 & respondent_id==3598

*Round 8 - April-May 2012
replace reasonforclosure_3p5yrs=5 if wave==1 & respondent_id==526
replace reasonforclosure_3p5yrs=7 if wave==1 & respondent_id==546
replace reasonforclosure_3p5yrs=4 if wave==1 & respondent_id==720
replace reasonforclosure_3p5yrs=5 if wave==1 & respondent_id==1715
replace reasonforclosure_3p5yrs=12 if wave==1 & respondent_id==2027
replace reasonforclosure_3p5yrs=1 if wave==1 & respondent_id==3068
replace reasonforclosure_3p5yrs=1 if wave==1 & respondent_id==3135
replace reasonforclosure_3p5yrs=12 if wave==1 & respondent_id==3224
replace reasonforclosure_3p5yrs=5 if wave==1 & respondent_id==3302
replace reasonforclosure_3p5yrs=5 if wave==1 & respondent_id==3474
replace reasonforclosure_3p5yrs=5 if wave==1 & respondent_id==3539
replace reasonforclosure_3p5yrs=8 if wave==1 & respondent_id==3752
replace reasonforclosure_3p5yrs=5 if wave==1 & respondent_id==3774
replace reasonforclosure_3p5yrs=5 if wave==1 & respondent_id==3780
replace reasonforclosure_3p5yrs=1 if wave==1 & respondent_id==3782

*Round 9 - October 2012
replace reasonforclosure_4yrs=1 if wave==1 & respondent_id==149
replace reasonforclosure_4yrs=4 if wave==1 & respondent_id==416
replace reasonforclosure_4yrs=5 if wave==1 & respondent_id==1347
replace reasonforclosure_4yrs=12 if wave==1 & respondent_id==3386
replace reasonforclosure_4yrs=3 if wave==1 & respondent_id==3419
replace reasonforclosure_4yrs=5 if wave==1 & respondent_id==3523
replace reasonforclosure_4yrs=5 if wave==1 & respondent_id==3543
replace reasonforclosure_4yrs=5 if wave==1 & respondent_id==3784
replace reasonforclosure_4yrs=7 if wave==1 & respondent_id==3821
replace reasonforclosure_4yrs=5 if wave==1 & respondent_id==3831

*Round 10 - April-May 2013
replace reasonforclosure_4p5yrs=1 if wave==1 & respondent_id==40
replace reasonforclosure_4p5yrs=8 if wave==1 & respondent_id==659
replace reasonforclosure_4p5yrs=7 if wave==1 & respondent_id==813
replace reasonforclosure_4p5yrs=12 if wave==1 & respondent_id==1371
replace reasonforclosure_4p5yrs=5 if wave==1 & respondent_id==1439
replace reasonforclosure_4p5yrs=7 if wave==1 & respondent_id==2053
replace reasonforclosure_4p5yrs=8 if wave==1 & respondent_id==3667

*Round 11 - April-May 2013
replace reasonforclosure_5p5yrs=3 if wave==1 & respondent_id==217
replace reasonforclosure_5p5yrs=1 if wave==1 & respondent_id==305
replace reasonforclosure_5p5yrs=5 if wave==1 & respondent_id==372
replace reasonforclosure_5p5yrs=8 if wave==1 & respondent_id==426
replace reasonforclosure_5p5yrs=3 if wave==1 & respondent_id==952
replace reasonforclosure_5p5yrs=1 if wave==1 & respondent_id==3112
replace reasonforclosure_5p5yrs=5 if wave==1 & respondent_id==3135
replace reasonforclosure_5p5yrs=5 if wave==1 & respondent_id==3150
replace reasonforclosure_5p5yrs=1 if wave==1 & respondent_id==3331
replace reasonforclosure_5p5yrs=5 if wave==1 & respondent_id==3340
replace reasonforclosure_5p5yrs=5 if wave==1 & respondent_id==3388
replace reasonforclosure_5p5yrs=5 if wave==1 & respondent_id==3403
replace reasonforclosure_5p5yrs=1 if wave==1 & respondent_id==3450
replace reasonforclosure_5p5yrs=1 if wave==1 & respondent_id==3464
replace reasonforclosure_5p5yrs=11 if wave==1 & respondent_id==3504
replace reasonforclosure_5p5yrs=5 if wave==1 & respondent_id==3603
replace reasonforclosure_5p5yrs=5 if wave==1 & respondent_id==3612
replace reasonforclosure_5p5yrs=5 if wave==1 & respondent_id==3681
replace reasonforclosure_5p5yrs=5 if wave==1 & respondent_id==3746
replace reasonforclosure_5p5yrs=5 if wave==1 & respondent_id==3756
replace reasonforclosure_5p5yrs=5 if wave==1 & respondent_id==3774



tostring survey, replace
replace survey="BL-"+string(surveyyear) if wave==1
replace survey="R-"+string(surveyyear) if wave>1 & wave<11 
replace survey="L-"+string(surveyyear) if wave==11

g lastround=(wave==11)

*Generate owner, household and business id (which are the same here)
foreach var in ownerid firmid householdid{
egen `var'=group(respondent_id)
tostring `var', format("%04.0f") replace
replace `var'="SLLSE"+"-"+`var'
}
drop booster surveymonth*

g surveyname="SLLSE"

save SLLSE_masterfc,replace
					

