********************************************************************************

********************************************************************************
**THIS DO-FILE PREPARES THE DATA FROM THE LOMÉ INFORMAL ENTERPRISE SURVEY FOR COMBINATION INTO THE MASTER DATASET
**Small Firm Death in Developing Countries
**November 21, 2017
**David McKenzie (dmckenzie@worldbank.org) and Anna Luisa Paffhausen (apaffhausen@worldbank.org)
**The analysis was performed with Stata, version 14.2

*Note:
* This do-file cannot be replicated as part of the underlying raw data needed to replicate this do-file is not available publicly.

********************************************************************************

********************************************************************************
clear all
cd  "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data"
set more off


use id_ent ///
	BL_q63 BL_q85b2ii BL_q85b1ii BL_q141a assign_man assign_ent assign_group BL_q41_age BL_q40 BL_q179 BL_years_schooling BL_q154 BL_ravens_score BL_q51 BL_q86*2 BL_q87 BL_q87a BL_q87b BL_q57b_recoded BL_q88 BL_q57b ///
	FU1_p2q1 FU1_p4q24ai FU1_p4q24 FU1_p4q21b2ii FU1_p4q21b1ii FU1_p4q6 FU1_p2q9 FU1_p2q3 FU1_p2q3a FU1_p2q6 ///
	FU2_p2q2 FU2_p2q1 FU2_p4q48ai FU2_p4q48 FU2_p4q32b2ii FU2_p4q32b1ii FU2_p4q7 FU2_p2q10 FU2_p2q4 FU2_p2q4a FU2_p2q7 FU2_p1q22 ///
	FU3_p2q2 FU3_p2q1 FU3_p4q4ai FU3_p4q4 FU3_p4q34b2ii FU3_p4q34b1ii FU3_p4q7 FU3_p2q10 FU3_p2q4 FU3_p2q4a FU3_p2q7 FU3_p1q6 FU3_p5q15a ///
	using "Togo/Master constructed-v2.dta", clear


********************************************************************************

********************************************************************************
*Baseline variables
********************************************************************************

********************************************************************************

*Country
g country="Togo"

*Surveyyear
g surveyyear1=2013

*Treatment status
g treatstatus=(assign_group!=3)
g control=assign_group==3

*Firm has been assigned to business training
g bustraining=(assign_group!=3)

*Local to USD exchange rate at time of survey
*The baseline survey was done between October 2013 and January 2014, with only 4 obs. coming from interviews conducted in 2014, and most (about 80%) having been conducted in November 2013, so I take November 15, 2013 as approx. midpoint
g excrate1=0.00163

g excratemonth1="11-2013"

********************************************************************************
*Owner and Household characteristics
********************************************************************************
*Age of owner
g ownerage1=BL_q41_age

*Gender of owner
g female1=(BL_q40==1)

*Owner is married
g married1=(BL_q179==1) if BL_q179!=.

*Owner's education in years
g educyears1=BL_years_schooling

*Owner has tertiary education
g ownertertiary1=(BL_q154>=9 & BL_q154<=13) if BL_q154!=.

*Raven score of owner
g raven1=BL_ravens_score/12

********************************************************************************
*Firm characteristics
********************************************************************************
*Age of the firm in years
g agefirm1=2013-BL_q51

*Capital stock
egen capitalstock1=rowtotal(BL_q86a2-BL_q86f2),m

*Inventories
g inventories1=BL_q88

*I use BL_q57b_recoded and suppose the value labels remain the same as in the original variable

*Drop if firm is in agriculture, fishing or aquaculture, forrestry, breeding/animal husbandry, charcoal production or milling
drop if BL_q57b_recoded>=1 & BL_q57b_recoded<=22

*Firm is in retail trade
g retail1=((BL_q57b_recoded>=41 & BL_q57b_recoded<=49) | BL_q57b_recoded==411) if BL_q57b_recoded!=999

*Firm is in manufacturing sector
g manuf1=((BL_q57b_recoded>=23 & BL_q57b_recoded<=29) | (BL_q57b_recoded>=71 & BL_q57b_recoded<=79) | (BL_q57b_recoded>=211 & BL_q57b_recoded<=223)) if BL_q57b_recoded!=999

*Firm is in service sector
g services1=((BL_q57b_recoded>=51 & BL_q57b_recoded<=68) | (BL_q57b_recoded>=81 & BL_q57b_recoded<=99) | BL_q57b_recoded==511) if BL_q57b_recoded!=999

*Firm is in other sector
g othersector1=(BL_q57b_recoded>=31 & BL_q57b_recoded<=37) if BL_q57b_recoded!=999

*Detailed firm sector (ISIC 2 or 3 digit) - (but not sure if it's these are really ISIC codes)
rename BL_q57b_recoded sector1

*Total workers
rename BL_q63 totalworkers

*Business profits in last month
rename BL_q85b2ii profits 

*Business sales in last month
rename BL_q85b1ii sales

*Subjective wellbeing on Cantril ladder
rename BL_q141a subjwell08l

********************************************************************************

********************************************************************************

********************************************************************************
*Panel variables
********************************************************************************

********************************************************************************

********************************************************************************
*Round 2 

*Survival
g survival2=(FU1_p2q1==1) if FU1_p2q1!=.

*Main activity after closing business
*Main activity after closing business
label define mainactivity 	1 "Working for a wage" ///
							2 "Looking for work" ///
							3 "Operating a different business" ///
							4 "Housework or looking after children" ///
							5 "Other"

g mainactivity2=1 if FU1_p2q9==1 | FU1_p2q9==2 
replace mainactivity2=2 if FU1_p2q9==8
replace mainactivity2=3 if FU1_p2q9==3 | FU1_p2q9==4 
replace mainactivity2=5 if FU1_p2q9==5 | FU1_p2q9==6 | FU1_p2q9==7 | FU1_p2q9==9 | FU1_p2q9==10 | FU1_p2q9==11 | FU1_p2q9==12 | FU1_p2q9==13

label values mainactivity2 mainactivity

*New firm started since last survey
g newfirmstarted2=(mainactivity2==3) if mainactivity2!=.

*Reason for closing business
gen reasonclosure2=1 if FU1_p2q3==2 | FU1_p2q3==3 | FU1_p2q3==4 | FU1_p2q3==5 
replace reasonclosure2=2 if FU1_p2q3==6 | FU1_p2q6==8
replace reasonclosure2=3 if FU1_p2q3==7 | FU1_p2q6==3
replace reasonclosure2=4 if FU1_p2q3==9 | FU1_p2q6==2
replace reasonclosure2=8 if FU1_p2q6==7
replace reasonclosure2=9 if FU1_p2q3==1 | FU1_p2q3==10 | FU1_p2q3==11 | FU1_p2q3==12 | FU1_p2q6==4 | FU1_p2q6==5 | FU1_p2q6==6 | FU1_p2q6==9 | FU1_p2q6==10
replace reasonclosure2=10 if FU1_p2q3==8 | FU1_p2q6==1

label define closereason 1 "making a loss" 2 "sickness" 3 "care for family" 4 "better wage job" 5 "migrate abroad" 6 "married" 7 "shut down by govt." 8 "taken from me" 9 "other" 10 "better business opportunity" 11 "catastrophe"
label values reasonclosure2 closereason

replace reasonclosure=2 if FU1_p2q3a=="PROBLEME DE MALADIE ET DE GESTION DES FINANCE" | FU1_p2q3a=="PROBLEME D'INFRASTRUCTURE ET DE MALADIE" | FU1_p2q3a=="probleme de maladie et de finance"
replace reasonclosure=3 if FU1_p2q3a=="grossesse"
replace reasonclosure=11 if FU1_p2q3a=="les voleurs ont cambriole mon entreprise lors"

*Owner is retired from work
g retired2=(FU1_p2q9==12) if FU1_p2q9!=.
replace retired2=0 if survival==1

*Number of paid employees
rename FU1_p4q24ai employees2

*Total workers
rename FU1_p4q24  totalworkers2

*Business profits in last month
rename FU1_p4q21b2ii profits2

*Business sales in last month
rename FU1_p4q21b1ii sales2

*Hours worked in self-employment in last month
*based on hours worked in a normal week
g hoursnormal2=FU1_p4q6*(30/7)

*Worked as wage worker in last month
g wageworker2=(FU1_p2q9==1 | FU1_p2q9==2) if FU1_p2q9!=.


*Excrate and excratemonth
*Survey took place in Sept. 2014, so I take Sept. 15, 2014 as approx. midpoint
g excrate2=0.00198
g excratemonth2="9-2014" 

*Surveyyear
g surveyyear2=2014


********************************************************************************
*Round 3

*Survival
g survival3=(FU2_p2q2==1) if FU2_p2q2!=.

*I suppose that, if a new firm was started by round2, the questions regarding continuation refer to that business, so I recode survival to be from baseline in this case
replace survival3=0 if survival2==0 & survival3==1 & newfirmstarted2==1

*Main activity after closing business
g mainactivity3=1 if FU2_p2q10==1 | FU2_p2q10==2 
replace mainactivity3=2 if FU2_p2q10==8
replace mainactivity3=3 if FU2_p2q10==3 | FU2_p2q10==4 
replace mainactivity3=5 if FU2_p2q10==5 | FU2_p2q10==6 | FU2_p2q10==7 | FU2_p2q10==9 | FU2_p2q10==10 | FU2_p2q10==11 | FU2_p2q10==12 | FU2_p2q10==13

label values mainactivity3 mainactivity

*New firm started since last survey
g newfirmstarted3=(mainactivity3==3) if mainactivity3!=.

*Reason for closing business
gen reasonclosure3=1 if FU2_p2q4==2 | FU2_p2q4==3 | FU2_p2q4==4 | FU2_p2q4==5 
replace reasonclosure3=2 if FU2_p2q4==6 | FU2_p2q7==8
replace reasonclosure3=3 if FU2_p2q4==7 | FU2_p2q7==3
replace reasonclosure3=4 if FU2_p2q4==9 | FU2_p2q7==2
replace reasonclosure3=8 if FU2_p2q7==7
replace reasonclosure3=9 if FU2_p2q4==1 | FU2_p2q4==10 | FU2_p2q4==11 | FU2_p2q4==12 | FU2_p2q7==4 | FU2_p2q7==5 | FU2_p2q7==6 | FU2_p2q7==9 | FU2_p2q7==10
replace reasonclosure3=10 if FU2_p2q4==8 | FU2_p2q7==1

replace reasonclosure3=1 if FU2_p2q4a=="J'AI PERDU DE L'ARGENT"
replace reasonclosure3=3 if FU2_p2q4a=="parce que je suis enceinte et je ne supporte plus la chaleur du feu"
replace reasonclosure3=9 if FU2_p2q4a=="A CAUSE DES TRAVAUX D'AMENAGEMENT URBAINS" 
replace reasonclosure3=11 if FU2_p2q4a=="vol dans boutique"

label values reasonclosure3 closereason


*Owner is retired from work
g retired3=(FU2_p2q10==12) if FU2_p2q10!=.
replace retired3=0 if survival3==1

*Number of paid employees
rename FU2_p4q48ai employees3

*Total workers
rename FU2_p4q48 totalworkers3

*Business profits in last month
rename FU2_p4q32b2ii profits3

*Business sales in last month
rename FU2_p4q32b1ii sales3

*Hours worked in self-employment in last month
*based on hours worked in a normal week
g hoursnormal3=FU2_p4q7*(30/7)

*Worked as wage worker in last month
g wageworker3=(FU2_p2q10==1 |FU2_p2q10==2) if FU2_p2q10!=.


*Excrate and excratemonth
*Survey took place in Jan. 2015, so I take Jan. 15, 2015 as approx. midpoint
g excrate3=0.00180
g excratemonth3="1-2015" 

*Surveyyear
g surveyyear3=2015

********************************************************************************
*Round 4

*Survival
*g survival4=(FU3_p2q2!=2) if FU3_p2q2!=.
g survival4=(FU3_p2q2==1) if FU3_p2q2!=.

*I suppose that, if a new firm was started by round2 or round3, the questions regarding continuation refer to that business, so I recode survival to be from baseline in these cases
replace survival4=0 if (newfirmstarted2==1 | newfirmstarted3==1) & survival3==0 & survival4==1
replace survival4=. if (newfirmstarted2==. & newfirmstarted3==.) & survival3==0 & survival4==1

*Main activity after closing business
g mainactivity4=1 if FU3_p2q10==1 | FU3_p2q10==2 
replace mainactivity4=2 if FU3_p2q10==8
replace mainactivity4=3 if FU3_p2q10==3 | FU3_p2q10==4 
replace mainactivity4=5 if FU3_p2q10==5 | FU3_p2q10==6 | FU3_p2q10==7 | FU3_p2q10==9 | FU3_p2q10==10 | FU3_p2q10==11 | FU3_p2q10==12 | FU3_p2q10==13

label values mainactivity4 mainactivity

*New firm started since last survey
g newfirmstarted4=(mainactivity4==3) if mainactivity4!=.

*Reason for closing business
gen reasonclosure4=1 if FU3_p2q4==2 | FU3_p2q4==3 | FU3_p2q4==4 | FU3_p2q4==5 
replace reasonclosure4=2 if FU3_p2q4==6 | FU3_p2q7==8
replace reasonclosure4=3 if FU3_p2q4==7 | FU3_p2q7==3
replace reasonclosure4=4 if FU3_p2q4==9 | FU3_p2q7==2
replace reasonclosure4=8 if FU3_p2q7==7
replace reasonclosure4=9 if FU3_p2q4==1 | FU3_p2q4==10 | FU3_p2q4==11 | FU3_p2q4==12 | FU3_p2q7==4 | FU3_p2q7==5 | FU3_p2q7==6 | FU3_p2q7==9 | FU3_p2q7==10
replace reasonclosure4=10 if FU3_p2q4==8 | FU3_p2q7==1

replace reasonclosure4=11 if FU3_p2q4a=="LES VOLEURS ONT VOLE TOUT DANS LA BOUTIQUE ET LA CHAMBRE A COUCHER"

label values reasonclosure4 closereason

*Owner is retired from work
g retired4=(FU3_p2q10==12) if FU3_p2q10!=.
replace retired4=0 if survival4==1

*Number of paid employees
rename FU3_p4q4ai employees4

*Total workers
rename FU3_p4q4 totalworkers4

*Business profits in last month
rename FU3_p4q34b2ii profits4

*Business sales in last month
rename FU3_p4q34b1ii sales4

*Hours worked in self-employment in last month
*based on hours worked in a normal week
g hoursnormal4=FU3_p4q7*(30/7)

*Worked as wage worker in last month
g wageworker4=(FU3_p2q10==1 | FU3_p2q10==2) if FU3_p2q10!=.

*Subjective wellbeing on Cantril ladder
rename FU3_p5q15a subjwell08l4


*Excrate and excratemonth
*Survey took place in Sept. 2015, so I take Sept. 15, 2015 as approx. midpoint
g excrate4=0.00173
g excratemonth4="9-2015" 

*Surveyyear
g surveyyear4=2015
 
********************************************************************************
*Round 5
merge 1:1 id_ent using "Togo/FU4_FINAL.dta", keep(1 3) nogenerate

*Survival
*g survival5=(p2q2!=2) if p2q2!=.
g survival5=(p2q2==1) if p2q2!=.
*I suppose that, if a new firm was started by round2 or round3, the questions regarding continuation refer to that business, so I recode survival to be from baseline in these cases
replace survival5=0 if (newfirmstarted2==1 | newfirmstarted3==1 | newfirmstarted4==1) & survival4==0 & survival5==1
replace survival5=. if (newfirmstarted2==. & newfirmstarted3==. & newfirmstarted4==.) & survival4==0 & survival5==1

*Main activity after closing business
g mainactivity5=1 if p2q10==1 | p2q10==2 
replace mainactivity5=2 if p2q10==8
replace mainactivity5=3 if p2q10==3 | p2q10==4 
replace mainactivity5=5 if p2q10==5 | p2q10==6 | p2q10==7 | p2q10==9 | p2q10==10 | p2q10==11 | p2q10==12 | p2q10==13

label values mainactivity5 mainactivity

*New firm started since last survey
g newfirmstarted5=(mainactivity5==3) if mainactivity5!=.

*Reason for closing business
gen reasonclosure5=1 if p2q4==2 | p2q4==3 | p2q4==4 | p2q4==5 
replace reasonclosure5=2 if p2q4==6 | p2q7==8
replace reasonclosure5=3 if p2q4==7 | p2q7==3
replace reasonclosure5=4 if p2q4==9 | p2q7==2
replace reasonclosure5=8 if  p2q7==7
replace reasonclosure5=9 if p2q4==1 | p2q4==10 | p2q4==11 | p2q4==12 | p2q7==4 | p2q7==5 | p2q7==6 | p2q7==9 | p2q7==10
replace reasonclosure5=10 if p2q4==8 | p2q7==1

replace reasonclosure5=1 if p2q4a=="MANQUE DE RESSOURCES HUMAINES ET FINANCIERES" | p2q4a=="MANQUE DE MOYENS FINANCIERS" | p2q4a=="L'ENTREPRENEUR A PERDU TOUT SON CAPITAL"
replace reasonclosure5=2 if p2q4a=="LES POUSSIERES DE CHARBONS LA RENDAIT MALADE"
replace reasonclosure5=11 if p2q4a=="ON A CAMBRIOLE MA BOUTIQUE" | p2q4a=="L'ENTREPRISE A ETE CAMBRIOLEE" | p2q4a=="VOL DE MES MARCHANDISES"

label values reasonclosure5 closereason

*Owner is retired from work
g retired5=(p2q10==12) if p2q10!=.
replace retired5=0 if survival5==1

*Number of paid employees
rename p3q5ai employees5

*Total workers
rename p3q5 totalworkers5

*Business profits in last month
rename p3q39b2ii profits5

*Business sales in last month
rename p3q39b1ii sales5

*Hours worked in self-employment in last month
*based on hours worked in a normal week
g hoursnormal5=p3q8*(30/7)

*Worked as wage worker in last month
g wageworker5=(p2q10==1 | p2q10==2) if p2q10!=.

*Subjective wellbeing on Cantril ladder
rename p4q9a subjwell08l5

*Excrate and excratemonth
*Survey took place in Sept. 2016, so I take Sept. 15, 2016 as approx. midpoint
g excrate5=0.00170
g excratemonth5="9-2016" 

*Surveyyear
g surveyyear5=2016

********************************************************************************

keep id_ent ///
	 country surveyyear* treatstatus control bustraining excrate* ///
	 ownerage female married educyears ownertertiary raven ///
	 agefirm capitalstock inventories retail manuf services othersector sector ///
	 totalworkers* profits* sales* subjwell08l* ///
	 survival* mainactivity* newfirmstarted* reasonclosure* retired* /// 
	 employees* hoursnormal* wageworker* ///
	 FU1_p2q3 FU1_p2q6 *p2q4 *p2q7 FU1_p2q9 *p2q10 

rename p2q4 p2q4_orig
	 
save TOGOINF_masterfc, replace	 

*Generate attrition
use id_ent BL_q57b_recoded using "Togo/Master constructed-v2.dta", clear
drop if BL_q57b_recoded>=1 & BL_q57b_recoded<=22
merge 1:1 id_ent using "Togo/Baseline survey no identity", keep(1 3)
	 
keep id_ent _merge

merge 1:1 id_ent using "Togo/September 2014 data PADSP no identity", keep(1 3) gen(_merge2)
g attrit2=_merge2==1

keep id_ent attrit2 _merge

merge 1:1 id_ent using "Togo/Final data for January 2015", keep(1 3) gen(_merge3)
g attrit3=_merge3==1

keep id_ent attrit* _merge

merge 1:1 id_ent using "Togo/IF SEPTEMBER 2015_DeID", keep(1 3) gen(_merge4)
g attrit4=_merge4==1

keep id_ent attrit* _merge

merge 1:1 id_ent using "Togo/FU4_FINAL", keep(1 3) gen(_merge5)
g attrit5=_merge5==1

keep id_ent attrit* _merge

merge 1:1 id_ent using TOGOINF_masterfc, nogenerate

save TOGOINF_masterfc, replace	

*Recode information on survival for attriters (I assume the codes remained the same)
import excel "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/Togo/EXTRA_Survival.xlsx", sheet("INTERVIEW_MISSING") cellrange(A1:U160) firstrow clear
rename Id id_ent
merge 1:1 id_ent using TOGOINF_masterfc, keep(2 3) nogenerate

*Survival
replace survival5=1 if p2q2=="1"
replace survival5=0 if p2q2=="2" | p2q2=="3"
*I suppose that, if a new firm was started by round2 or round3, the questions regarding continuation refer to that business, so I recode survival to be from baseline in these cases
replace survival5=0 if (newfirmstarted2==1 | newfirmstarted3==1 | newfirmstarted4==1) & survival4==0 & survival5==1
replace survival5=. if (newfirmstarted2==. & newfirmstarted3==. & newfirmstarted4==.) & survival4==0 & survival5==1

*Owner died between rounds
g died5=(p2q2=="deces" | p2q4=="deces")
replace died5=.  if p2q2=="." & attrit5==1

*Reason for closing business
replace reasonclosure5=1 if p2q4=="2" | p2q4=="3" | p2q4=="4" | p2q4=="5" 
replace reasonclosure5=2 if p2q4=="6"
replace reasonclosure5=3 if p2q4=="7"
replace reasonclosure5=4 if p2q4=="9"
replace reasonclosure5=10 if p2q4=="8"
replace reasonclosure5=9 if p2q4=="1" | p2q4=="10" | p2q4=="11" | p2q4=="12" | p2q4=="deces" | p2q4=="le proprietaire a repris les locaux"

*Main activity after closing business
replace mainactivity5=1 if p2q10==1 | p2q10==2 
replace mainactivity5=2 if p2q10==8
replace mainactivity5=3 if p2q10==3 | p2q10==4 
replace mainactivity5=5 if p2q10==5 | p2q10==6 | p2q10==7 | p2q10==9 | p2q10==10 | p2q10==11 | p2q10==12 | p2q10==13

*Total workers
replace totalworkers5=p3q5 if p3q5!=.

*Sales in last month
replace sales5=p3q39b1ii if p3q39b1ii!=.

*Profits in last month
replace profits5=p3q39b2ii if p3q39b2ii!=.

drop B-entreprise p2q5a p2q5b p3q5-_merge


*Recode attrit in case there is a value for survival (2 obs. at baseline and 1 obs. in FU1)
forvalues i=2/5{
replace attrit`i'=0 if survival`i'!=.
}


quietly: reshape long 	surveyyear excrate excratemonth ///
						capitalstock inventories agefirm retail manuf services othersector sector ///
						ownerage female married educyears ownertertiary raven ///
						, ///
						i(id) j(survey)
g wave=survey

foreach x in profits sales totalworkers subjwell08l {
replace `x'=. if wave!=1
}	

*No need to recode survival, as it is already coded from baseline

*Only keep if business is operating
forvalues i=2/5{
drop if survival`i'!=1 & wave==`i'
}

foreach x in survival newfirmstarted attrit retired totalworkers employees reasonclosure mainactivity sales profits hoursnormal wageworker  {
g `x'_10mths=`x'2 if wave==1
drop `x'2
g `x'_1p167yrs=`x'3 if wave==1
drop `x'3
g `x'_1p833yrs=`x'4 if wave==1
drop `x'4
g `x'_2p833yrs=`x'5 if wave==1
drop `x'5
}

foreach x in subjwell08l{
g `x'_1p833yrs=`x'4 if wave==1
drop `x'4
g `x'_2p833yrs=`x'5 if wave==1
drop `x'5
}

tostring survey, replace
replace survey="BL-"+string(surveyyear) if wave==1
replace survey="R-"+string(surveyyear) if wave==2 
replace survey="R-"+string(surveyyear)+"-1" if wave==3 
replace survey="R-"+string(surveyyear)+"-1"  if wave==4 
replace survey="L-"+string(surveyyear) if wave==5


g lastround=(wave==5)

*Generate owner, household and business id (which are the same here)
foreach var in ownerid firmid householdid{
egen `var'=group(id_ent)
tostring `var', format("%04.0f") replace
replace `var'="TOGOINF"+"-"+`var'
}

g surveyname="TOGOINF"

save TOGOINF_masterfc, replace

/*********************************************************************************
NOTE ON CODING OF SURVIVAL
The question used to code survival was "Do you still work for this company?" and 
had three options:
(1) Yes
(2) No, because the company was closed down
(3) No, for another reason 
Survival was coded as zero for answer==2 | answer==3, and as 1 for answer==1. 

After the second follow up survey, before this question used to code survival, a variable 
was created that captured the status of this question for the previous survey.
Generally it captured:
(1) Surveyed in previous survey (or any of the previous surveys for later rounds) and still had a business
(2) Surveyed in previous survey (or any of the previous surveys for later rounds) but didn’t have a business anymore
(3) Wasn't surveyed since baseline

I assume that answer==2 captures both those businesses that have been closed and those
where the owner was not working for it anymore due to other reasons.
The survey introduced a skip pattern, so that the question used to code survival was not asked, if
the status of the previous survey(s) was "owner did not have a business anymore". I thought of coding survival based on the value of the
previous survey in the cases in which the value was missing. However, the information from the
previous surveys and the status of the following survey did not coincide in a few cases. Furthermore,
this way I would rule out temporary closure, which is still possible if survival is left as missing, as
it is captured in the bounds.
I decided hence to only use the information from each survey and to disregard the retrospective information 
(although I understand that this should have been done by the interviewer based on information from the 
previous survey so it should be identical).
As a result, there are missing values for survival in a given round, although there
was no attrition, because the question used to code it was not asked in this round.
*********************************************************************************/
