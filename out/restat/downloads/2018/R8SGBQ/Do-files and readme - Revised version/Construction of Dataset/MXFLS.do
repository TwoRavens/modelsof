********************************************************************************

********************************************************************************
**THIS DO-FILE PREPARES THE DATA FROM THE MEXICAN FAMILY LIFE SURVEY FOR COMBINATION INTO THE MASTER DATASET
**Small Firm Death in Developing Countries
**March 18, 2018
**David McKenzie (dmckenzie@worldbank.org) and Anna Luisa Paffhausen (apaffhausen@worldbank.org)
**The analysis was performed with Stata, version 14.2

*Notes:
* The underlying raw data needed to replicate this do-file is available online at: http://www.ennvih-mxfls.org/english/index.html.
* To replicate this do-file:
* 1) Go to http://www.ennvih-mxfls.org/english/index.html
* 2) Download the following data folders in Stata format: hh02dta_all, hh05dta_all, and hh09dta_all (All databases)
* 3) Change the directory in the do-file 
* 4) Change the paths to the data you are using and for saving the datasets that are created in this do-file
*    Make sure the final dataset (MXFLS_masterfc.dta) is saved in the folder “Do-files and readme/Construction of Dataset/Data for combination”


********************************************************************************

********************************************************************************
clear all
*TO DO: change directory 
/*EXAMPLE:*/
cd  "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data"
/**/
set more off

********************************************************************************
*This program replaces codes for "not applicable," "refused," "don't know," and "missing responses"
********************************************************************************
program replacetomissings
syntax varlist
tempvar digits
gen `digits'=length(string(`varlist'))
sum `digits', detail
local maxdigits=`r(max)'

local substr="9"

tempvar stringvar
tostring `varlist', generate(`stringvar')

replace `varlist'=. if `maxdigits'==1 &  (`stringvar'=="5" | `stringvar'=="6" | `stringvar'=="7" | `stringvar'=="8" | `stringvar'=="9")    

forvalues i=2/20{
local n2=`i'-1
replace `varlist'=. if `maxdigits'==`i' &  substr(`stringvar',1,`n2')=="`substr'" & (substr(`stringvar',-1,1)=="5" | substr(`stringvar',-1,1)=="6" | substr(`stringvar',-1,1)=="7" | substr(`stringvar',-1,1)=="8" | substr(`stringvar',-1,1)=="9")    
local substr="`substr'"+"9"
}

end
********************************************************************************

clear
*TO DO: change path to where you saved the following file "hh02dta_bc/c_ls.dta"
/*EXAMPLE:*/
use "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 1/hh02dta_bc/c_ls.dta
/**/

********************************************************************************
*Baseline variables
********************************************************************************
g country="Mexico"

********************************************************************************
*Baseline owner characteristics
********************************************************************************

keep country folio ls ls02_1 ls02_2 ls04 ls05_1 ls09 ls10 ls11 ls14 ls15

*Age of owner
g ownerage=ls02_2 if ls02_1==1
replace ownerage=0 if ls02_1==2 | ls02_1==2  
/*
Code for ls02_1:
1.	Years
2.	Months
3.	Days
8.	DK
*/

*Child under 5 in household
g under5=0
replace under5=. if ls02_2==. | ls02_2==8 
replace under5=1 if (ls02_2<5 & ls02_1==1) | ls02_1==2 | ls02_1==2 
bysort folio: egen childunder5=max(under5)
drop under5

*Child aged 5 to 12 in household
g aged5to12=0
replace aged5to12=. if ls02_2==. | ls02_2==8 
replace aged5to12=1 if ls02_2>=5 & ls02_2<12 & ls02_1==1
bysort folio: egen childaged5to12=max(aged5to12)
drop aged5to12

*Has adult aged 65+ in the household
g is65orover=0
replace is65orover=. if ls02_2==. | ls02_2==8 
replace is65orover=1 if ls02_2>=65 & ls02_2!=. & ls02_1==1
bysort folio: egen adult65andover=max(is65orover)
drop is65orover

drop ls02_1 ls02_2

*Owner is female
g female=(ls04==3)
drop ls04

*Owner is married
g married=(ls10==5)
replace married=. if ls10==.
drop ls10

*Owner has tertiary education
g ownertertiary=(ls14==9 | ls14==10)
replace ownertertiary=. if ls14==98 | ls14==.

*Years of education
g educyears=0 if ls14==1 | ls14==2
*Elementary school
replace educyears=ls15 if ls14==3 & ls15!=8
*Secondary school
replace educyears=6+ls15 if (ls14==4 | ls14==5) & ls15!=8
*High School
replace educyears=9+ls15 if (ls14==6 | ls14==7) & ls15!=8
*Tertiary
replace educyears=12+ls15 if (ls14==8 | ls14==9) & ls15!=8
replace educyears=16+ls15 if (ls14==10) & ls15!=8

*Sources:	https://en.wikipedia.org/wiki/Education_in_Mexico
*			http://www.oas.org/udse/gestion/ges_rela20a.html
drop ls14 ls15

gen str8 help1 = string(folio, "%08.0f")
gen str2 help2 = string(ls, "%02.0f")
gen pid_link = help1 + help2
drop help*

*TO DO: decide whether you need/want to change path for saving MXFLS
/* */
save MXFLS, replace
/**/

*TO DO: change path to where you saved the following file "hh02dta_bea/ea_eca.dta"
/*EXAMPLE:*/
merge 1:1 folio ls using "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 1/hh02dta_bea/ea_eca.dta", nogenerate
/**/

*Raven progressive matrices score
*I compute the score as the percentage of correct answers for questions eca01 - eca12

replace eca01=(eca01==8) if eca01!=.
replace eca02=(eca02==4) if eca02!=.
replace eca03=(eca03==5) if eca03!=.
replace eca04=(eca04==1) if eca04!=.
replace eca05=(eca05==2) if eca05!=.
replace eca06=(eca06==5) if eca06!=.
replace eca07=(eca07==6) if eca07!=.
replace eca08=(eca08==3) if eca08!=.
replace eca09=(eca09==7) if eca09!=.
replace eca10=(eca10==8) if eca10!=.
replace eca11=(eca11==7) if eca11!=.
replace eca12=(eca12==6) if eca12!=.

egen raven=rowtotal(eca01-eca12),m
replace raven=raven/12

drop eca01-eca12

*TO DO: decide whether you need/want to change path for saving MXFLS
/**/
save MXFLS, replace
/**/
********************************************************************************
*Baseline firm characteristics
********************************************************************************
*TO DO: change path to where you saved the following file "hh02dta_b2/ii_nna.dta"
/*EXAMPLE:*/
merge m:1 folio using "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 1/hh02dta_b2/ii_nna.dta", nogenerate
/**/
replace nna02=0 if nna01==3

*Household operates a non-farm business
g hhbus=(nna01==1) & nna01!=.
drop nna01

*TO DO: decide whether you need/want to change path for saving MXFLS
/**/
save MXFLS, replace
/**/

clear
*Get the date of the book 2 interview:
*TO DO: change path to where you saved the following file "hh02dta_b2/ii_conpor.dta"
/*EXAMPLE:*/
use "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 1/hh02dta_b2/ii_conpor.dta"
/**/
/*Since for each folio, there are 6 lines for up to 6 interviews, I only keep those
 in which the interview actually took place. If the questionnaire was completed in more than 1 visit,
 I take the date of the last inverview*/
keep if (min==minfin & visita==1)| (visita!=1 & min!=0 & min!=.)

keep folio mes

g help=string(mes)+"-2002"

g interviewmonth2002=monthly(help,"MY")

keep folio interviewmonth2002

*TO DO: change path to where you saved the following file "hh02dta_b2/ii_nna1.dta"
/*EXAMPLE:*/
merge 1:m folio using "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 1/hh02dta_b2/ii_nna1.dta", nogenerate
/**/
*TO DO: change path to where you saved the following file "hh02dta_b2/ii_nna.dta"
/*EXAMPLE:*/
merge m:1 folio using "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 1/hh02dta_b2/ii_nna.dta", nogenerate
/**/

*Age of the firm in years
g help=string(nna05_21)+"-"+string(nna05_22)
g startofbus=monthly(help,"MY")
replace startofbus=yearly(string(nna05_22),"Y") if nna05_21==. & nna05_1==1

g agefirm=(interviewmonth2002-startofbus)/12

/*Although the b2-interviews were conducted between March and July 2002,
 I use 2002.00 as the interviewdate for the yearly start dates of the businesses,
 as I don't know when exactly the businesses started in the start year and hence
 treat all as if they had started in January of that year.*/
replace agefirm=(2002-startofbus) if nna05_21==. & nna05_1==1
g x_agefirm=.
replace x_agefirm=1 if nna05_21!=. & nna05_1==1
replace x_agefirm=0 if nna05_21==. & nna05_1==1

/*There are three observations for which I don't have an interviewmonth, which 
 leads to missing values for startofbus. Therefore I disregard the information on
 the startmonth and compute the age of the firm on a yearly scale for these 3 businesses*/
replace agefirm=(2002-nna05_22) if startofbus!=. & interviewmonth2002==.
replace x_agefirm=0 if startofbus!=. & interviewmonth2002==.

/*Somehow there are some observations for firms created in 2002, for which I get
 negative ages of the firm, so I replace them with zero.*/
replace x_agefirm=0 if agefirm<0
replace agefirm=(2002-nna05_22) if agefirm<0 

*TO DO: change path to where you saved the following file "hh02dta_b2/ii_se.dta"
/*EXAMPLE:*/
merge m:1 folio using "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 1/hh02dta_b2/ii_se.dta", nogenerate
/**/

*Family member ill in last month
/*There is no way of knowing whether the illness or accident happened in the previous month,
since only the year is asked, but not the month.
-> I consider illnesses that happened in the same year as the year of the survey, i.e. 2002*/
g familyill=(se01b==1 & se02ba_2==2002)
replace familyill=. if se01b==. 

*Owner ill in the last month
/*I only know the relationship to the respondent of the person having been ill
 with this information I can try to construct this variable once I have identified the business owners.*/
 
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

*Number of paid employees
*We assume that all people working in the business in addition to the household members are paid
* -> employees = nna19_21 + household members
/* Given that I cannot know exactly how many household members work in the business and if they are
 paid or unpaid, I combine the information on houseold members working in the business with
 the information from the employment module in book 3a later*/
 
/*But first, remove household members working in the business from NNA19, if they
 are the decision takers of the business. (In these cases they are considered as the 
 business owners rather than workers)*/

foreach x in 1a 1b 1c 1d 1e 1f 1g 1h 1i 1j{
replace nna18_`x'=0 if nna18_`x'!=. & nna18_`x'==nna14_`x'
}
 
*Business profits in last month
g profits=.
replace profits=nna22_12 if  nna22_1==2
*Since profits are given for past 12 months:
replace profits=profits/12
drop nna22_12 nna22_1
 
*Business sales in last month
g sales=.
replace sales=nna21_2 if  nna21_1==1
*Since sales are given for past 12 months:
replace sales=sales/12
drop nna21_2 nna21_1

keep folio wave interviewmonth2002 startofbus agefirm x_agefirm familyill se03ba_1 se03bb_1 se03bc_1 profits sales nna14* nna18* nna19* nna01 nna02

g tbdropped=(nna01==1 & nna02>1) if nna01!=.

/*Since the data is in long format in case a hh operates more than one business I drop
 duplicates in folio tbdropped to be able to merge the 2002 with the 2005 data later
*/
duplicates drop folio tbdropped, force

*TO DO: change path to where you saved the following file "MXFLS.dta"
/*EXAMPLE:*/
merge 1:m folio using MXFLS, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving MXFLS
/**/
save MXFLS, replace
/**/

clear
*TO DO: change path to where you saved the following file "hh02dta_b2/ii_portad.dta"
/*EXAMPLE:*/
use "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 1/hh02dta_b2/ii_portad.dta"
/**/

rename ls respondent_ls

keep folio respondent_ls

*TO DO: change path to where you saved the following file "MXFLS.dta"
/*EXAMPLE:*/
merge 1:m folio using MXFLS, nogenerate
/**/

*Identify the business owners
/*The section on the non-farm business does not ask who is the business owner, but which hh
 members took the most important decisions regarding the business. I use this to determine
 whether an individual is the business owner*/

g businessowner=.
replace businessowner=1 if ls==respondent_ls & nna14_1a==1
replace businessowner=0 if businessowner==. & nna01==1


/*ls11 gives the ls/id of the spouse, which I can use to identify the business owner if he/she
 is the respondent's spouse
 Note that, according to the codebook, ls11==1 means that the spouse died or doesn’t live in the household,
 but from the data it seems that ls11==1 however is the ls/id of the spouse. Also, the questionnaire gives
 "51." as being the code for "does not live in the household", so I treat ls11==1 as if it were the ls of the spouse*/

g help=ls11 if ls==respondent
bysort folio: egen help2=total(help), m

replace businessowner=1 if ls==help2 & nna14_1b==2

drop help*

*Identify the household members working in the businesses
*In the case the respondent is the business owner as well as the household head:
g help=(ls==respondent_ls & businessowner==1 & ls05_1==1)
bysort folio: egen help2=total(help), m


g hhbus_worker=.
replace hhbus_worker=1 if help2==1 & ((nna18_1b==2 & ls05_1==2) | (nna18_1c==3 & ls05_1==3) | (nna18_1d==4 & ls05_1==6) | (nna18_1e==5 & ls05_1==7) | (nna18_1f==6 & ls05_1==8) | (nna18_1g==7 & ls05_1==9) | (nna18_1h==8 & ls09==1) | (nna18_1i==9 & ls05_1!=1 & ls05_1!=2 & ls05_1!=3  & ls05_1!=6  & ls05_1!=7  & ls05_1!=8  & ls05_1!=9))

drop help*

*In the case the respondent is the business owner and the spouse of the household head:
g help=(ls==respondent_ls & businessowner==1 & ls05_1==2)
bysort folio: egen help2=total(help), m

replace hhbus_worker=1 if help2==1 & ((nna18_1b==2 & ls05_1==1) | (nna18_1c==3 & ls05_1==3) | (nna18_1d==4 & ls05_1==7) | (nna18_1e==5 & ls05_1==6) | (nna18_1f==6 & ls05_1==9) | (nna18_1g==7 & ls05_1==8) | (nna18_1h==8 & ls09==1) | (nna18_1i==9 & ls05_1!=1 & ls05_1!=2 & ls05_1!=3  & ls05_1!=6  & ls05_1!=7  & ls05_1!=8  & ls05_1!=9))


*In the case that no household member has been working in the business
replace hhbus_worker=0 if hhbus==1 & nna18_1j==10

drop help*

*Owner ill in the last month
g resp_bo=(nna14_1a==1)
replace resp_bo=. if nna14_1j==98 | nna01!=1


g spouse_bo=(nna14_1b==2)
replace spouse_bo=. if nna14_1j==98 | nna01!=1

g ownerill`i'=.
replace ownerill=1 if resp_bo==1 & familyill==1 & (se03ba_1==1 | se03bb_1==1 | se03bc_1==1)
replace ownerill=1 if spouse_bo==2 & familyill==1 & (se03ba_1==2 | se03bb_1==2 | se03bc_1==2)
replace ownerill=0 if ownerill==. & nna01==1

drop se* nna14* nna18* nna01 nna02 

*TO DO: decide whether you need/want to change path for saving MXFLS
/**/
save MXFLS, replace
/**/

*TO DO: change path to where you saved the following file "hh02dta_b3a/iiia_tb.dta"
/*EXAMPLE:*/
merge 1:1 folio ls using "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 1/hh02dta_b3a/iiia_tb.dta", nogenerate
/**/
keep folio-ownerill tb02 tb05 tb32p tb32s tb27p tb28p tb35a_2

rename tb32p tb31p
rename tb32s tb31s
rename tb27p tb26p_2
rename tb28p tb27p_2


*Add the proxy information
*TO DO: change path to where you saved the following file "hh02dta_b3a/iiia_tb.dta"
/*EXAMPLE:*/
merge 1:1 folio ls using "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 1/hh02dta_bx/p_tb.dta", update nogenerate
/**/
keep folio-ownerill tb02 tb05 tb31p tb31s tb26p_2 tb27p_2 tb35a_2

rename tb31p tb32p 
rename tb31s tb32s
rename tb26p_2 tb27p 
rename tb27p_2 tb28p 

*Hours worked in self-employment in last month
g selfemployed=(tb32p==5 | tb32p==6) if (tb32p!=. | tb05!=8) & (tb32p!=. | tb05!=.)

g hours=tb27p*(30/7) if selfemployed==1
label var hours "based on hours worked during the past week"

g hoursnormal=tb28p*(30/7) if selfemployed==1
label var hoursnormal "based on hours worked during a normal week"

*Worked as wage worker in last month
g wageworker=(tb32p==3) if (tb32p!=. | tb05!=8) & (tb32p!=. | tb05!=.)

*Labor earnings in last month
g laborincome=wageworker*tb35a_2

*Retired
g retired=(tb02==6) if tb02!=.

*Employees
/*I use the information from the employment module of Book 3A to calculate the
 number of paid household members.
 For this I assume that a household member having been identified as working in
 the business, is a paid worker, if in his/her primary or secondary job he/she is neither: 
 - a family worker in a hh owned business, without remuneration; nor
 - a boss, employer, or business proprietor; nor
 - a self-employed worker (with or without non-remunerated worker)
 Since we focus on non-agricultural businesses, an individual, having been identified
 as working in the business, is judged to be a paid worker in such a household business
 if in his/her primary or secondary job he/she is a non-agricultural worker or employee
 and in the other is either the same, or:
 - a peasant on his/her plot; or
 - a rural laborer, or land peon (agricultural worker); or
 - a worker without remuneration from a business or company that is not owned by the HH
*/
g paidhhworker=0 if  hhbus_worker==1
replace paidhhworker=1 if hhbus_worker==1 & ((tb32p==3 & tb32s!=2 & tb32s!=5  & tb32s!=6) | (tb32s==3 & tb32p!=2 & tb32p!=5 & tb32p!=6))


bysort folio: egen numofpaidhhworkers= total(paidhhworker), m


*Now, finally, the number of paid employees
egen employees=rowtotal(numofpaidhhworkers nna19_2), m


drop tb02_1-tb35a_2 nna19* numofpaidhhworkers* paidhhworker*

*TO DO: decide whether you need/want to change path for saving MXFLS
/**/
save MXFLS, replace
/**/
*Household consumption
clear
*TO DO: change path to where you saved the following file "hh02dta_b1/i_cs.dta"
/*EXAMPLE:*/
use "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 1/hh02dta_b1/i_cs.dta"
/**/
*TO DO: change path to where you saved the following file "hh02dta_b1/i_cs1.dta"
/*EXAMPLE:*/
merge 1:1 folio using "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 1/hh02dta_b1/i_cs1.dta", nogenerate
/**/
# delimit ;
egen weeklyfoodconsump=rowtotal(cs02a_12 cs02a_22 cs02a_32 cs02a_42 cs02a_52 cs02a_62 cs02a_72 cs02a_82 cs02b_12 cs02b_22 cs02b_32 cs02b_42 cs02b_52 cs02c_12 cs02c_22 cs02c_32 cs02c_42 cs02c_52 cs02c_62 cs02c_72 cs02d_12 cs02d_22 cs02d_32 cs02d_42 cs02e_12 cs02e_22 cs02e_32
								cs04a_12 cs04a_22 cs04a_32 cs04a_42 cs04a_52 cs04a_62 cs04a_72 cs04a_82 cs04b_12 cs04b_22 cs04b_32 cs04b_42 cs04b_52 cs04c_12 cs04c_22 cs04c_32 cs04c_42 cs04c_52 cs04c_62 cs04c_72 cs04d_12 cs04d_22 cs04d_32 cs04d_42 cs04e_22 cs04e_32 cs04e_42 cs04e_52 cs04e_62 cs04e_72 cs04e_82 cs04e_92 cs04e_102 cs04e_112 cs04e_122 cs04e_132
								cs15a-cs15j
								),m
;

# delimit cr

replace cs06_2=0 if cs05==3

replace weeklyfoodconsump=weeklyfoodconsump-cs06_2

egen monthlynonfoodexp=rowtotal(cs16a_2 cs16b_2 cs16c_2 cs16d_2 cs16e_2 cs16f_2 cs16g_2 cs16h_2 cs16i_2 cs18_2), m

replace cs20_2=0 if cs19==3

replace monthlynonfoodexp=monthlynonfoodexp-cs20_2

# delimit ;
egen quarterlynonfoodexp=rowtotal(cs22a_2 cs22b_2 cs22c_2 cs22d_2 cs22e_2 cs22f_2 cs22g_2 cs22h_2
									cs24a_2 cs24b_2 cs24c_2 cs24d_2 cs24e_2 cs24f_2 cs24g_2 cs24h_2
									),m
;
# delimit cr

replace cs26_2=0 if cs25==3
 
replace quarterlynonfoodexp=quarterlynonfoodexp-cs26_2

egen yearlynonfoodexp=rowtotal(cs27a_2 cs27b_2 cs27c_2 cs27d_2 cs27e_2 cs27f_2 cs29_2),m

replace cs31_2=0 if cs30==3

replace yearlynonfoodexp=yearlynonfoodexp-cs31_2

foreach var of varlist cs34a_12 cs34a_22 cs34a_32 cs35a_12 cs35a_22 cs35a_32 cs36a_12 cs36a_22 cs36a_32{
replace `var'=0 if cs32==5
}

/*I assume that with current school period, the whole year is referred to for questions cs34 and cs35
	(Although the questionnaire only says "present school period", the codebook says "school year")
*/
egen yearlyeducexp =rowtotal(cs34a_12 cs34a_22 cs34a_32 cs35a_12 cs35a_22 cs35a_32),m

egen monthlyeducexp=rowtotal(cs36a_12 cs36a_22 cs36a_32),m



replace weeklyfoodconsump=52*weeklyfoodconsump
replace monthlynonfoodexp=12*monthlynonfoodexp
replace quarterlynonfoodexp=4*quarterlynonfoodexp
replace monthlyeducexp=12*monthlyeducexp
egen hh_exp=rowtotal(yearlynonfoodexp yearlyeducexp weeklyfoodconsump monthlynonfoodexp quarterlynonfoodexp monthlyeducexp), missing

keep folio hh_exp

*TO DO: decide whether you need/want to change path for saving consumpexp
/**/
save consumpexp, replace
/**/

clear
*TO DO: change path to where you saved the following file "hh02dta_bc/c_ls.dta"
/*EXAMPLE:*/
use "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 1/hh02dta_bc/c_ls.dta
/**/
bysort folio: egen hhsize=total(ls09==1), m

keep folio hhsize
duplicates drop

*TO DO: change path to where you saved the following file "consumpexp.dta"
/*EXAMPLE:*/
merge 1:1 folio using consumpexp, nogenerate
/**/

g pcexpend=hh_exp/hhsize

keep folio pcexpend

*TO DO: change path to where you saved the following file "MXFLS.dta"
/*EXAMPLE:*/
merge 1:m folio using MXFLS, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving MXFLS
/**/
save MXFLS, replace
/**/

/* Since it doen't say anywhere what the period of the 1st round survey was,
	I use the information from the control book to calculate the approximate midpoint of
	the survey, which I need for the exchange rate.
*/

clear
*TO DO: change path to where you saved the following file "hh02dta_bc/c_conpor.dta"
/*EXAMPLE:*/
use "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 1/hh02dta_bc/c_conpor.dta
/**/

g help=string(dia)+"-"+string(mes)+"-2002"

g interviewdate=daily(help,"DMY")
format interviewdate %d
su interviewdate,detail
list interviewdate if interviewdate==r(p50)
* -> The midpoint is May 13, 2002

clear
*TO DO: change path to where you saved the following file "MXFLS"
/*EXAMPLE:*/
use MXFLS
/**/

/*According to oanda.com, the MXN to USD exchange rate on May 13, 2002 was 0.10510.
	(https://www.oanda.com/lang/de/currency/converter/)
*/
g excrate=0.10510

g excratemonth="5-2002"

g surveyyear=2002

*TO DO: decide whether you need/want to change path for saving MXFLS
/**/
save MXFLS, replace
/**/

* Include information on interview results for books used to construct MXFLS
clear

*TO DO: change path to where you saved the following file "MXFLS"
/*EXAMPLE:*/
use "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 1/hh02dta_bc/c_portad.dta
/**/
keep folio rel reh 
foreach var of varlist rel reh{
rename `var' bc_`var'
}

drop if folio==.
duplicates drop

*TO DO: change path to where you saved the following file "hh02dta_b1/i_portad.dta"
/*EXAMPLE:*/
merge 1:1 folio using "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 1/hh02dta_b1/i_portad.dta
/**/
keep folio bc* rel

rename rel b1_rel

*TO DO: change path to where you saved the following file "hh02dta_b2/ii_portad.dta"
/*EXAMPLE:*/
merge 1:1 folio using "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 1/hh02dta_b2/ii_portad.dta
/**/
keep folio b* rel

rename rel b2_rel

*TO DO: change path to where you saved the following file "MXFLS.dta"
/*EXAMPLE:*/
merge 1:m folio using MXFLS, keep(2 3) nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving MXFLS
/**/
save MXFLS, replace
/**/

clear
*TO DO: change path to where you saved the following file "hh02dta_b3a/iiia_portad.dta"
/*EXAMPLE:*/
use "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 1/hh02dta_b3a/iiia_portad.dta
/**/

keep folio ls rel

rename rel b3a_rel

*TO DO: change path to where you saved the following file "hh02dta_bea/ea_portad.dta"
/*EXAMPLE:*/
merge 1:1 folio ls using "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 1/hh02dta_bea/ea_portad.dta
/**/

keep folio ls b* rel

rename rel bea_rel

*TO DO: change path to where you saved the following file "MXFLS.dta"
/*EXAMPLE:*/
merge 1:1 folio ls using MXFLS, keep(2 3) nogenerate
/**/
*TO DO: decide whether you need/want to change path for saving MXFLS
/**/
save MXFLS, replace
/**/
********************************************************************************
*Round 2
********************************************************************************

clear
*TO DO: change path to where you saved the following file "hh05dta_bc/c_ls.dta"
/*EXAMPLE:*/
use "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 2/hh05dta_bc/c_ls.dta
/**/

*Owner died between survey rounds
g dead=(ls01a==0) if ls01a!=.

keep folio ls ls01a ls05_1 ls11 dead pid_link

*TO DO: decide whether you need/want to change path for saving MXFLS2
/**/
save MXFLS2, replace
/**/

clear
*Get the date of the book 2 interview:
*TO DO: change path to where you saved the following file "hh05dta_b2/ii_conpor.dta"
/*EXAMPLE:*/
use "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 2/hh05dta_b2/ii_conpor.dta"
/**/
/*I only keep those in which the interview was complete. If the questionnaire was completed in more than 1 visit,
 I take the date of the inverview at which it was coded to be complete*/
keep if rev==20 
/*Since there is still one duplicate in terms of folio, for which rev=20 seems to
 have been given in a case in which there was no interview (hours==0 & min==0),
 I drop this observation
*/
drop in 4315

keep folio mes anio

g help=string(mes)+"-200"+string(anio)

g interviewmonth2005_07=monthly(help,"MY")

keep folio interviewmonth2005_07 anio

*TO DO: change path to where you saved the following file "hh05dta_b2/ii_nna1.dta"
/*EXAMPLE:*/
merge 1:m folio using "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 2/hh05dta_b2/ii_nna1.dta", nogenerate
/**/
*TO DO: change path to where you saved the following file "hh05dta_b2/ii_nna.dta"
/*EXAMPLE:*/
merge m:1 folio using "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 2/hh05dta_b2/ii_nna.dta", nogenerate
/**/

*Household operates a non-form business
g hhbus=(nna01==1) & nna01!=.

replace nna02=0 if nna01==3

*Age of the firm in years and date of the business start
g help=string(nna05_21)+"-"+string(nna05_22)
g startofbus=monthly(help,"MY")
replace startofbus=yearly(string(nna05_22),"Y") if nna05_21==. & nna05_1==1

g agefirm=(interviewmonth2005_07-startofbus)/12

/*I use 2005.00, 2006.00 and 2007.00 as the interviewdate for the yearly start dates of the businesses,
 as I don't know when exactly the businesses started in the start year and hence
 treat all as if they had started in January of that year.*/
forvalues i=5/7{ 
replace agefirm=(200`i'-startofbus) if nna05_21==. & nna05_1==1 & anio==`i'
}

g x_agefirm=.
replace x_agefirm=1 if nna05_21!=. & nna05_1==1
replace x_agefirm=0 if nna05_21==. & nna05_1==1

/*There are five observations for which I do not know the interviewyear and one
	observation for which I do not know the year of the business start. I hence 
	set x_agefirm as missing here:
*/
replace x_agefirm=. if  x_agefirm==1 & agefirm==.

/*Somehow there are some observations for firms created in 2005, for which I get
 negative ages of the firm, so I replace them with zero.*/
replace x_agefirm=0 if agefirm<0
replace agefirm=(2005-nna05_22) if agefirm<0 

*Survey round number
g wave=2

*Number of paid employees
*We assume that all people working in the business in addition to the household members are paid
* -> employees = nna19_21 + household members
/* Given that I cannot know exactly how many household members work in the business and if they are
 paid or unpaid, I combine the information on houseold members working in the business with
 the information from the employment module in book 3a later*/
 
/*But first, remove household members working in the business from NNA19, if they
 are the decision takers of the business. (In these cases they are considered as the 
 business owners rather than workers)*/

foreach x in 1a 1b 1c 1d 1e 1f 1g 1h 1i 1j{
replace nna18_`x'=0 if nna18_`x'!=. & nna18_`x'==nna14_`x'
}
 
*Business profits in last month
g profits=.
replace profits=nna22_12 if  nna22_1==2
*Since profits are given for past 12 months:
replace profits=profits/12
drop nna22_12 nna22_1
 
*Business sales in last month
g sales=.
replace sales=nna21_2 if  nna21_1==1
*Since sales are given for past 12 months:
replace sales=sales/12
drop nna21_2 nna21_1

keep folio interviewmonth2005_07 hhbus startofbus agefirm x_agefirm profits sales nna14* nna18* nna19* nna01 nna02 wave

g tbdropped=(nna01==1 & nna02>1) if nna01!=.

/*Since the data is in long format in case a hh operates more than one business I drop
 duplicates in folio tbdropped to be able to merge the 2002 with the 2005 data later
*/
duplicates drop folio tbdropped, force

*TO DO: change path to where you saved the following file "MXFLS2.dta"
/*EXAMPLE:*/
merge 1:m folio using MXFLS2, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving MXFLS2
/**/
save MXFLS2, replace
/**/

*TO DO: change path to where you saved the following file "hh05dta_b2/ii_se.dta"
/*EXAMPLE:*/
merge m:1 folio using "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 2/hh05dta_b2/ii_se.dta", nogenerate
/**/

*Family member ill in last month
/*There is no way of knowing whether the illness or accident happened in the previous month,
since only the year is asked, but not the month.
-> I consider illnesses that happened in the same year as the year of the survey, i.e. 2002*/
g familyill=(se01b==1 & se02ba_2==2005)
replace familyill=. if se01b==. 

*Owner ill in the last month
g resp_bo=(nna14_1a==1)
replace resp_bo=. if nna14_1j==98 | nna01!=1

g spouse_bo=(nna14_1b==2)
replace spouse_bo=. if nna14_1j==98 | nna01!=1

g ownerill`i'=.
replace ownerill=1 if resp_bo==1 & familyill==1 & (se03ba_1==1 | se03bb_1==1 | se03bc_1==1)
replace ownerill=1 if spouse_bo==2 & familyill==1 & (se03ba_1==2 | se03bb_1==2 | se03bc_1==2)
replace ownerill=0 if ownerill==. & nna01==1

drop se*  

*TO DO: decide whether you need/want to change path for saving MXFLS2
/**/
save MXFLS2, replace
/**/

clear
*TO DO: change path to where you saved the following file "hh05dta_b2/ii_portad.dta"
/*EXAMPLE:*/
use "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 2/hh05dta_b2/ii_portad.dta"
/**/

rename ls respondent_ls

keep folio respondent_ls

*TO DO: change path to where you saved the following file "MXFLS2.dta"
/*EXAMPLE:*/
merge 1:m folio using MXFLS2, nogenerate
/**/

*Identify the business owners
/*The section on the non-farm business does not ask who is the business owner, but which hh
 members took the most important decisions regarding the business. I use this to determine
 whether an individual is the business owner*/

g businessowner=.
replace businessowner=1 if ls==respondent_ls & nna14_1a==1
replace businessowner=0 if businessowner==. & nna01==1



/*ls11 gives the ls/id of the spouse, which I can use to identify the business owner if he/she
 is the respondent's spouse
 Note that, according to the codebook, ls11==1 means that the spouse died or doesn’t live in the household,
 but from the data it seems that ls11==1 however is the ls/id of the spouse. Also, the questionnaire gives
 "51." as being the code for "does not live in the household", so I treat ls11==1 as if it were the ls of the spouse*/

g help=ls11 if ls==respondent
bysort folio: egen help2=total(help), m

g spouse_ls="0"+string(help2) if help2<10
replace spouse_ls=string(help2) if help2>=10

replace businessowner=1 if ls==spouse_ls & nna14_1b==2

drop help*

*Identify the household members working in the businesses
*In the case the respondent is the business owner as well as the household head:
g help=(ls==respondent_ls & businessowner==1 & ls05_1==1)
bysort folio: egen help2=total(help), m

g hhbus_worker=.
replace hhbus_worker=1 if help2==1 & ((nna18_1b==2 & ls05_1==2) | (nna18_1c==3 & ls05_1==3) | (nna18_1d==4 & ls05_1==6) | (nna18_1e==5 & ls05_1==7) | (nna18_1f==6 & ls05_1==8) | (nna18_1g==7 & ls05_1==9) | (nna18_1h==8 & (ls01a==1 | ls01a==4)) | (nna18_1i==9 & ls05_1!=1 & ls05_1!=2 & ls05_1!=3  & ls05_1!=6  & ls05_1!=7  & ls05_1!=8  & ls05_1!=9))


drop help*

*In the case the respondent is the business owner and the spouse of the household head:
g help=(ls==respondent_ls & businessowner==1 & ls05_1==2)
bysort folio: egen help2=total(help), m


replace hhbus_worker=1 if help2==1 & ((nna18_1b==2 & ls05_1==1) | (nna18_1c==3 & ls05_1==3) | (nna18_1d==4 & ls05_1==7) | (nna18_1e==5 & ls05_1==6) | (nna18_1f==6 & ls05_1==9) | (nna18_1g==7 & ls05_1==8) | (nna18_1h==8 & (ls01a==1 | ls01a==4)) | (nna18_1i==9 & ls05_1!=1 & ls05_1!=2 & ls05_1!=3  & ls05_1!=6  & ls05_1!=7  & ls05_1!=8  & ls05_1!=9))

*In the case that no household member has been working in the business
replace hhbus_worker=0 if hhbus==1 & nna18_1j==10


drop help*

drop nna14* nna18* nna01 nna02

*TO DO: decide whether you need/want to change path for saving MXFLS2
/**/
save MXFLS2, replace
/**/

*TO DO: change path to where you saved the following file "hh05dta_b3a/iiia_tb.dta"
/*EXAMPLE:*/
merge 1:1 folio ls using "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 2/hh05dta_b3a/iiia_tb.dta", nogenerate
/**/

keep folio-hhbus_worker tb02 tb05 tb32p tb32s tb27p tb28p tb35a_2

rename tb32p tb31p
rename tb32s tb31s
rename tb27p tb26p_2
rename tb28p tb27p_2

*TO DO: change path to where you saved the following file "hh05dta_bx/p_tb.dta"
/*EXAMPLE:*/
merge 1:1 folio ls using "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 2/hh05dta_bx/p_tb.dta", nogenerate update
/**/

rename tb31p tb32p 
rename tb31s tb32s
rename tb26p_2 tb27p 
rename tb27p_2 tb28p 

*Hours worked in self-employment in last month
g selfemployed=(tb32p==5 | tb32p==6)  if (tb32p!=. | tb05!=8) & (tb32p!=. | tb05!=.)

g hours=tb27p*(30/7) if selfemployed==1
label var hours "based on hours worked during the past week"

g hoursnormal=tb28p*(30/7) if selfemployed==1
label var hoursnormal "based on hours worked during a normal week"

*Worked as wage worker in last month
g wageworker=(tb32p==3) if (tb32p!=. | tb05!=8) & (tb32p!=. | tb05!=.)

*Labor earnings in last month
g laborincome=wageworker*tb35a_2

*Retired
g retired=(tb02==6) if tb02!=.

*Employees
/*I use the information from the employment module of Book 3A to calculate the
 number of paid household members.
 For this I assume that a household member having been identified as working in
 the business, is a paid worker, if in his/her primary or secondary job he/she is neither: 
 - a family worker in a hh owned business, without remuneration; nor
 - a boss, employer, or business proprietor; nor
 - a self-employed worker (with or without non-remunerated worker)
 Since we focus on non-agricultural businesses, an individual, having been identified
 as working in the business, is judged to be a paid worker in such a household business
 if in his/her primary or secondary job he/she is a non-agricultural worker or employee
 and in the other is either the same, or:
 - a peasont on his/her plot; or
 - a rural laborer, or land peon (agricultural worker); or
 - a worker without remuneration from a business or company that is not owned by the HH
*/
g paidhhworker=0 if  hhbus_worker==1
replace paidhhworker=1 if hhbus_worker==1 & ((tb32p==3 & tb32s!=2 & tb32s!=5  & tb32s!=6) | (tb32s==3 & tb32p!=2 & tb32p!=5 & tb32p!=6))

bysort folio: egen numofpaidhhworkers= total(paidhhworker), m


*Now, finally, the number of paid employees
egen employees=rowtotal(numofpaidhhworkers nna19_2), m


drop tb02_1-tb38p nna19* numofpaidhhworkers* paidhhworker*

*TO DO: decide whether you need/want to change path for saving MXFLS2
/**/
save MXFLS2, replace
/**/

*Household consumption
clear
*TO DO: change path to where you saved the following file "hh05dta_b1/i_cs.dta"
/*EXAMPLE:*/
use "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 2/hh05dta_b1/i_cs.dta"
/**/
*TO DO: change path to where you saved the following file "hh05dta_b1/i_cs1.dta"
/*EXAMPLE:*/
merge 1:1 folio using "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 2/hh05dta_b1/i_cs1.dta", nogenerate
/**/

# delimit ;
egen weeklyfoodconsump=rowtotal(cs02a_12 cs02a_22 cs02a_32 cs02a_42 cs02a_52 cs02a_62 cs02a_72 cs02a_82 cs02b_12 cs02b_22 cs02b_32 cs02b_42 cs02b_52 cs02c_12 cs02c_22 cs02c_32 cs02c_42 cs02c_52 cs02c_62 cs02c_72 cs02c_82 cs02d_12 cs02d_22 cs02d_32 cs02d_42 cs02d_52 cs02e_12 cs02e_22 cs02e_32
								cs04a_12 cs04a_22 cs04a_32 cs04a_42 cs04a_52 cs04a_62 cs04a_72 cs04a_82 cs04b_12 cs04b_22 cs04b_32 cs04b_42 cs04b_52 cs04c_12 cs04c_22 cs04c_32 cs04c_42 cs04c_52 cs04c_62 cs04c_72 cs04c_82 cs04d_12 cs04d_22 cs04d_32 cs04d_42 cs04e_22 cs04e_32 cs04e_42 cs04e_52 cs04e_62 cs04e_72 cs04e_82 cs04e_92 cs04e_102 cs04e_112 cs04e_122 cs04e_132
								cs15a-cs15j
								),m
;

# delimit cr

replace cs06_2=0 if cs05==3

replace weeklyfoodconsump=weeklyfoodconsump-cs06_2

egen monthlynonfoodexp=rowtotal(cs16a_2 cs16b_2 cs16c_2 cs16d_2 cs16e_2 cs16f_2 cs16g_2 cs16h_2 cs16i_2 cs18_2), m

replace cs20_2=0 if cs19==3

replace monthlynonfoodexp=monthlynonfoodexp-cs20_2

# delimit ;
egen quarterlynonfoodexp=rowtotal(cs22a_2 cs22b_2 cs22c_2 cs22d_2 cs22e_2 cs22f_2 cs22g_2 cs22h_2
									cs24a_2 cs24b_2 cs24c_2 cs24d_2 cs24e_2 cs24f_2 cs24g_2 cs24h_2
									),m
;
# delimit cr

replace cs26_2=0 if cs25==3
 
replace quarterlynonfoodexp=quarterlynonfoodexp-cs26_2

egen yearlynonfoodexp=rowtotal(cs27a_2 cs27b_2 cs27c_2 cs27d_2 cs27e_2 cs27f_2 cs29_2),m

replace cs31_2=0 if cs30==3

replace yearlynonfoodexp=yearlynonfoodexp-cs31_2

foreach var of varlist cs34a_12 cs34a_22 cs34a_32 cs35a_12 cs35a_22 cs35a_32 cs36a_12 cs36a_22 cs36a_32{
replace `var'=0 if cs32==3
}

/*I assume that with current school period, the whole year is referred to for questions cs34 and cs35
	(Although the questionnaire only says "present school period", the codebook says "school year")
*/
egen yearlyeducexp =rowtotal(cs34a_12 cs34a_22 cs34a_32 cs35a_12 cs35a_22 cs35a_32),m

egen monthlyeducexp=rowtotal(cs36a_12 cs36a_22 cs36a_32),m



replace weeklyfoodconsump=52*weeklyfoodconsump
replace monthlynonfoodexp=12*monthlynonfoodexp
replace quarterlynonfoodexp=4*quarterlynonfoodexp
replace monthlyeducexp=12*monthlyeducexp
egen hh_exp=rowtotal(yearlynonfoodexp yearlyeducexp weeklyfoodconsump monthlynonfoodexp quarterlynonfoodexp monthlyeducexp), missing

keep folio hh_exp

*TO DO: decide whether you need/want to change path for saving consumpexp
/**/
save consumpexp, replace
/**/

clear
*TO DO: change path to where you saved the following file "hh05dta_bc/c_ls.dta"
/*EXAMPLE:*/
use "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 2/hh05dta_bc/c_ls.dta
/**/

bysort folio: egen hhsize=total(ls01a==1 | ls01a==4), m

keep folio hhsize
duplicates drop

*TO DO: change path to where you saved the following file "consumpexp.dta"
/*EXAMPLE:*/
merge 1:1 folio using consumpexp, nogenerate
/**/

g pcexpend=hh_exp/hhsize

keep folio pcexpend

*TO DO: change path to where you saved the following file "MXFLS2.dta"
/*EXAMPLE:*/
merge 1:m folio using MXFLS2, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving MXFLS2
/**/
save MXFLS2, replace
/**/

/* Since it doen't say anywhere what the exact period of the 2nd round survey was,
	I use the information from the control book to calculate the approximate midpoint of
	the survey, which I need for the exchange rate.
*/

clear
*TO DO: change path to where you saved the following file "hh05dta_bc/c_conpor.dta"
/*EXAMPLE:*/
use "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 2/hh05dta_bc/c_conpor.dta
/**/

/*Since there is no variable on the day of the interview, I can only compute the interview date on a 
 monthly basis*/
g help=string(mes)+"-200"+string(anio)

g interviewdate=monthly(help,"MY")
format interviewdate %tm
su interviewdate,detail
list interviewdate if interviewdate==r(p50)
* -> The midpoint is July, 2005 -> I take July 15, 2005 as midpoint

clear
*TO DO: change path to where you saved the following file "MXFLS2.dta"
/*EXAMPLE:*/
use MXFLS2
/**/

/*According to oanda.com, the MXN to USD exchange rate on July 15, 2005 was 0.09374.
	(https://www.oanda.com/lang/de/currency/converter/)
*/
g excrate=0.09374

g excratemonth="7-2005"

/*Although the survey ran from 2005 until 2007 I code the surveyyear as 2005, since this is being done with 
 the files provided from MXFLS*/
g surveyyear=2005

*TO DO: decide whether you need/want to change path for saving MXFLS2
/**/
save MXFLS2, replace
/**/

* Include information on interview results for books used to construct MXFLS2
clear

*TO DO: change path to where you saved the following file "hh05dta_bc/c_portad.dta"
/*EXAMPLE:*/
use "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 2/hh05dta_bc/c_portad.dta
/**/
keep folio rel reh 
foreach var of varlist rel reh{
rename `var' bc_`var'
}

drop if folio==""
duplicates drop

*TO DO: change path to where you saved the following file "hh05dta_b1/i_portad.dta"
/*EXAMPLE:*/
merge 1:1 folio using "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 2/hh05dta_b1/i_portad.dta
/**/

keep folio bc* rel

rename rel b1_rel

*TO DO: change path to where you saved the following file "hh05dta_b2/ii_portad.dta"
/*EXAMPLE:*/
merge 1:1 folio using "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 2/hh05dta_b2/ii_portad.dta
/**/

keep folio b* rel

rename rel b2_rel

*TO DO: change path to where you saved the following file "MXFLS2.dta"
/*EXAMPLE:*/
merge 1:m folio using MXFLS2, keep(2 3) nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving MXFLS2
/**/
save MXFLS2, replace
/**/

clear
*TO DO: change path to where you saved the following file "hh05dta_b3a/iiia_portad.dta"
/*EXAMPLE:*/
use "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 2/hh05dta_b3a/iiia_portad.dta
/**/
keep folio ls rel

rename rel b3a_rel

*TO DO: change path to where you saved the following file "hh05dta_bea/ea_portad.dta"
/*EXAMPLE:*/
merge 1:1 folio ls using "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 2/hh05dta_bea/ea_portad.dta
/**/

keep folio ls b* rel

rename rel bea_rel

*TO DO: change path to where you saved the following file "MXFLS2.dta"
/*EXAMPLE:*/
merge 1:1 folio ls using MXFLS2, keep(2 3) nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving MXFLS2
/**/
save MXFLS2, replace
/**/


/*Drop those individuals who are coded as not living in the household in 2002 
and have missing pid_links. They appear in the dataset with their new folio and ls
(and pid_link that can be merged with wave 1) and ls01a=4, indicating that they are
new household members. By dropping them, I do not loose these individuals.*/ 
drop if pid_link==""

/*There is still one pid_link which is a duplicate. It seems it is also the case that
 the individual is not living in the origin household anymore, so I drop the obs. that
 belongs to the old household (folio ls: 04098000 03).*/
 
duplicates tag pid_link, gen(dupl_pid_link) 
drop if dupl_pid_link>0 & substr(folio,8,1)=="0"

drop dupl

*TO DO: decide whether you need/want to change path for saving MXFLS2
/**/
save MXFLS2, replace 
/**/

*Baseline variables

clear
*TO DO: change path to where you saved the following file "hh05dta_bc/c_ls.dta"
/*EXAMPLE:*/
use "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 2/hh05dta_bc/c_ls.dta
/**/

keep folio ls ls02_1 ls02_2 ls04 ls10 ls14 ls15

*Age of owner
g ownerage=ls02_2 if ls02_1==1
replace ownerage=0 if ls02_1==2 | ls02_1==2  
/*
Code for ls02_1:
1.	Years
2.	Months
3.	Days
8.	DK
*/

*Child under 5 in household
g under5=0
replace under5=. if ls02_2==. | ls02_2==8 
replace under5=1 if (ls02_2<5 & ls02_1==1) | ls02_1==2 | ls02_1==2 
bysort folio: egen childunder5=max(under5)
drop under5

*Child aged 5 to 12 in household
g aged5to12=0
replace aged5to12=. if ls02_2==. | ls02_2==8 
replace aged5to12=1 if ls02_2>=5 & ls02_2<12 & ls02_1==1
bysort folio: egen childaged5to12=max(aged5to12)
drop aged5to12

*Has adult aged 65+ in the household
g is65orover=0
replace is65orover=. if ls02_2==. | ls02_2==8 
replace is65orover=1 if ls02_2>=65 & ls02_2!=. & ls02_1==1
bysort folio: egen adult65andover=max(is65orover)
drop is65orover

drop ls02_1 ls02_2

*Owner is female
g female=(ls04==3)
drop ls04

*Owner is married
g married=(ls10==5)
replace married=. if ls10==.
drop ls10

*Owner has tertiary education
g ownertertiary=(ls14==9 | ls14==10)
replace ownertertiary=. if ls14==98 | ls14==.

*Years of education
g educyears=0 if ls14==1 | ls14==2
*Elementary school
replace educyears=ls15 if ls14==3 & ls15!=8
*Secondary school
replace educyears=6+ls15 if (ls14==4 | ls14==5) & ls15!=8
*High School
replace educyears=9+ls15 if (ls14==6 | ls14==7) & ls15!=8
*Tertiary
replace educyears=12+ls15 if (ls14==8 | ls14==9) & ls15!=8
replace educyears=16+ls15 if (ls14==10) & ls15!=8

*I assume trade schools also start after high shool
drop ls14 ls15

*gen str8 help1 = string(folio, "%08.0f")
*gen str2 help2 = string(ls, "%02.0f")
*gen pid_link = help1 + help2
*drop help*

gen pid_link = folio + ls

*TO DO: change path to where you saved the following file "hh05dta_bea/ea_eca.dta"
/*EXAMPLE:*/
merge 1:1 folio ls using "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 2/hh05dta_bea/ea_eca.dta", nogenerate
/**/

*Raven progressive matrices score
*I compute the score as the percentage of correct answers for questions eca01 - eca12

replace eca01=(eca01==8) if eca01!=.
replace eca02=(eca02==4) if eca02!=.
replace eca03=(eca03==5) if eca03!=.
replace eca04=(eca04==1) if eca04!=.
replace eca05=(eca05==2) if eca05!=.
replace eca06=(eca06==5) if eca06!=.
replace eca07=(eca07==6) if eca07!=.
replace eca08=(eca08==3) if eca08!=.
replace eca09=(eca09==7) if eca09!=.
replace eca10=(eca10==8) if eca10!=.
replace eca11=(eca11==7) if eca11!=.
replace eca12=(eca12==6) if eca12!=.

egen raven=rowtotal(eca01-eca12),m
replace raven=raven/12

drop eca01-eca12

*TO DO: change path to where you saved the following file "MXFLS2.dta"
/*EXAMPLE:*/
merge 1:1 folio ls pid_link using MXFLS2, keep(2 3) nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving MXFLS2
/**/
save MXFLS2, replace
/**/
********************************************************************************
*Merge round 1 with round 2 to create survival, newfirmstarted and attrition variables
********************************************************************************

*Survival and newfirmstarted
*First get relevant information on hh businesses from round 1
clear
*Get the date of the book 2 interview:
*TO DO: change path to where you saved the following file "hh02dta_b2/ii_conpor.dta"
/*EXAMPLE:*/
use "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 1/hh02dta_b2/ii_conpor.dta"
/**/
/*Since for each folio, there are 6 lines for up to 6 interviews, I only keep those
 in which the interview actually took place. If the questionnaire was completed in more than 1 visit,
 I take the date of the last inverview*/
keep if (min==minfin & visita==1)| (visita!=1 & min!=0 & min!=.)

keep folio mes

g help=string(mes)+"-2002"

g interviewmonth2002=monthly(help,"MY")

keep folio interviewmonth2002

*TO DO: change path to where you saved the following file "hh02dta_b2/ii_portad.dta"
/*EXAMPLE:*/
merge 1:1 folio using "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 1/hh02dta_b2/ii_portad.dta", nogenerate
/**/

keep folio ls interviewmonth2002

*TO DO: change path to where you saved the following file "hh02dta_bc/c_ls.dta"
/*EXAMPLE:*/
merge 1:1 folio ls using "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 1/hh02dta_bc/c_ls.dta", nogenerate keep(master match)
/**/

keep folio ls interviewmonth2002 ls05_1

*Create the respondents pid_link
gen str8 help1 = string(folio, "%08.0f")
gen str2 help2 = string(ls, "%02.0f")
gen resp_pid_link = help1 + help2

drop help*

*TO DO: change path to where you saved the following file "hh02dta_b2/ii_nna1.dta"
/*EXAMPLE:*/
merge 1:m folio using "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 1/hh02dta_b2/ii_nna1.dta", nogenerate
/**/
*TO DO: change path to where you saved the following file "hh02dta_b2/ii_nna.dta"
/*EXAMPLE:*/
merge m:1 folio using "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 1/hh02dta_b2/ii_nna.dta", nogenerate
/**/
*Date of the business start
g help=string(nna05_21)+"-"+string(nna05_22)
g startofbus=monthly(help,"MY")
replace startofbus=yearly(string(nna05_22),"Y") if nna05_21==. & nna05_1==1
rename nna05_21 startmonth
rename nna05_22 startyear

keep folio nna01 nna02 nna08 nna11_2 nna14* nna15 nna16_11 nna16_12 nna18* interviewmonth2002 start* resp_pid_link ls05_1

rename nna16_11 soldmonth
rename nna16_12 closedmonth

/*From User's Guide 2005 (p.22):
 In contrast to MxFLS-2, the folio from the first survey round is numeric and in
 order to carry out the adding and combination of both databases, it is necessary
 to have the same format for both folios.  
*/
rename folio numfolio
gen str8 folio=string(numfolio,"%08.0f")
drop numfolio 

/* Don't need that anymore, since we will only consider hh business if a hh ownes
 only one business
bysort folio: egen nt_num=seq() if nna02>1 & nna02!=.
replace nt_num=1 if nna01==1 & nna02==1
replace nt_num=0 if nna01!=1
*/

replace nna02=0 if nna01==3

g tbdropped=(nna01==1 & nna02>1) if nna01!=.

/*Since the data is in long format in case a hh operates more than one business I drop
 duplicates in folio tbdropped to be able to merge the 2002 with the 2005 data later
*/
duplicates drop folio tbdropped, force


foreach var of varlist nna01 nna02 nna08 nna11_2 nna14_1a-nna14_1j nna15 nna18_1a-nna18_1j startofbus startmonth startyear soldmonth closedmonth resp_pid_link  ls05_1 tbdropped{
rename `var' `var'_2002
}

/* Don't need that anymore, since we will only consider hh business if a hh ownes
 only one business
reshape wide startofbus_2002 startmonth_2002 startyear_2002 soldmonth_2002 closedmonth_2002 nna08_2002 nna11_2_2002 nna14_1a_2002-nna14_1j_2002 nna15_2002, i(folio) j(nt_num)
*/
*TO DO: decide whether you need/want to change path for saving survivalnf2002
/**/
save survivalnf2002, replace
/**/

*Get relevant information on hh businesses from round 2
clear
*Get the date of the book 2 interview:
*TO DO: change path to where you saved the following file "hh05dta_b2/ii_conpor.dta"
/*EXAMPLE:*/
use "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 2/hh05dta_b2/ii_conpor.dta"
/**/
/*I only keep those in which the interview was complete. If the questionnaire was completed in more than 1 visit,
 I take the date of the inverview at which it was coded to be complete*/
keep if rev==20 
/*Since there is still one duplicate in terms of folio, for which rev=20 seems to
 have been given in a case in which there was no interview (hours==0 & min==0),
 I drop this observation
*/
drop in 4315

keep folio mes anio

g help=string(mes)+"-200"+string(anio)

g interviewmonth2005=monthly(help,"MY")

replace anio=2000+anio

keep folio interviewmonth2005 anio

*TO DO: change path to where you saved the following file "hh05dta_b2/ii_portad.dta"
/*EXAMPLE:*/
merge 1:m folio using "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 2/hh05dta_b2/ii_portad.dta", nogenerate
/**/
keep folio ls interviewmonth2005 anio

*TO DO: change path to where you saved the following file "hh05dta_bc/c_ls.dta"
/*EXAMPLE:*/
merge 1:1 folio ls using "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 2/hh05dta_bc/c_ls.dta", nogenerate keep(master match)
/**/
rename pid_link resp_pid_link

keep folio interviewmonth2005 anio resp_pid_link ls05_1

*TO DO: change path to where you saved the following file "hh05dta_b2/ii_nna1.dta"
/*EXAMPLE:*/
merge 1:m folio using "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 2/hh05dta_b2/ii_nna1.dta", nogenerate
/**/
*TO DO: change path to where you saved the following file "hh05dta_b2/ii_nna.dta"
/*EXAMPLE:*/
merge m:1 folio using "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 2/hh05dta_b2/ii_nna.dta", nogenerate
/**/
*Date of the business start
g help=string(nna05_21)+"-"+string(nna05_22)
g startofbus=monthly(help,"MY")
replace startofbus=yearly(string(nna05_22),"Y") if nna05_21==. & nna05_1==1
rename nna05_21 startmonth
rename nna05_22 startyear

keep folio nna01 nna02 nna08 nna11_2 nna15 nna14_1a-nna14_1j nna16_11 nna16_12 nna18_1a-nna18_1j interviewmonth2005 anio start* resp_pid_link ls05_1 

rename nna16_11 soldmonth
rename nna16_12 closedmonth

replace nna02=0 if nna01==3

g tbdropped=(nna01==1 & nna02>1) if nna01!=.

/*Since the data is in long format in case a hh operates more than one business I drop
 duplicates in folio tbdropped to be able to merge the 2002 with the 2005 data later
*/
duplicates drop folio tbdropped, force


foreach var of varlist nna01 nna02 nna08 nna11_2 nna14_1a-nna14_1j nna15 nna18_1a-nna18_1j startofbus startmonth startyear soldmonth closedmonth resp_pid_link  ls05_1 tbdropped anio{
rename `var' `var'_2005
}
*TO DO: decide whether you need/want to change path for saving survivalnf2005
/**/
save survivalnf2005, replace
/**/

clear
*TO DO: change path to where you saved the following file "survivalnf2002.dta"
/*EXAMPLE:*/
use survivalnf2002
/**/
*TO DO: change path to where you saved the following file "survivalnf2005.dta"
/*EXAMPLE:*/
merge 1:1 folio using survivalnf2005
/**/

g survival2005=0 if nna01_2002==1 & nna01_2005==3 & tbdropped_2002==0 & tbdropped_2005==0
g newfirmstarted2005=0 if nna01_2002==1 & nna01_2005==3 & tbdropped_2002==0 & tbdropped_2005==0

*Single business in 2002 and no more than 1 business in 2005:

/*A firm is coded as surviving in 2005 if the household had one firm in 2002 and
 one firm in 2005, and the startdates are identical*/
replace survival2005=1 if nna01_2002==1 & nna01_2005==1 & nna02_2002==1 & nna02_2005==1 & startyear_2002==startyear_2005 & startyear_2005!=. & startyear_2002!=. 


/* A firm is coded as as a new firm if the startdate in 2005 was given as being after 2002.
	Survival is coded as missing in that case*/
replace newfirmstarted2005=1 if nna01_2002==1 & nna01_2005==1 & nna02_2002==1 & nna02_2005==1 & startyear_2002!=startyear_2005 & startyear_2005>=2002 & startyear_2005!=. & startyear_2002!=. 
replace newfirmstarted2005=0 if nna01_2002==1 & nna01_2005==1 & nna02_2002==1 & nna02_2005==1 & startyear_2002==startyear_2005 & startyear_2005!=. & startyear_2002!=. 
replace newfirmstarted2005=1 if nna01_2002==3 & nna01_2005==1 &  nna02_2005==1 & startyear_2005>=2002 & startyear_2005!=. & tbdropped_2002==0 & tbdropped_2005==0
replace newfirmstarted2005=0 if nna01_2002==3 & nna01_2005==1 &  nna02_2005==1 & startyear_2005<2002 & startyear_2005!=. & tbdropped_2002==0 & tbdropped_2005==0


/*If at least one owner (person(s) taking the most important decisions regarding
 the business) remains the same across both waves, and the startyear in 2005 is 
 different to the one indicated in 2002 but the 2005-startyear is not a year after 2001,
 I code the business as surviving. If the startyear in 2005 is given as being 2002 or later,
 I code the business as newfirm*/
*In case the respondent is the same in both waves (resp_pid_link_2002==resp_pid_link_2005)
replace survival2005=1 	if	nna01_2002==1 & nna01_2005==1					/// 
						&	nna02_2002==1 & nna02_2005==1	 				/// 
						/*&	startyear_2002!=.*/								/// 
						&	startyear_2005<2002								/// 	
						& 	startyear_2002!=startyear_2005					/// 
						/*&	abs(startyear_2005-startyear_2002)<=2*/		 	/// 
						&	(nna14_1a_2002==nna14_1a_2005				 	/// 
						|	nna14_1b_2002==nna14_1b_2005				 	/// 
						|	nna14_1c_2002==nna14_1c_2005				 	/// 
						|	nna14_1d_2002==nna14_1d_2005				 	/// 
						|	nna14_1e_2002==nna14_1e_2005				 	/// 
						|	nna14_1f_2002==nna14_1f_2005				 	/// 
						|	nna14_1g_2002==nna14_1g_2005				 	/// 
						|	nna14_1h_2002==nna14_1h_2005				 	/// 
						|	nna14_1i_2002==nna14_1i_2005				 	/// 
						|	nna14_1j_2002==nna14_1j_2005)				 	/// 
						&	resp_pid_link_2002==resp_pid_link_2005				

replace newfirmstarted2005=1 	if	nna01_2002==1 & nna01_2005==1					/// 
								&	nna02_2002==1 & nna02_2005==1	 				/// 
								&	startyear_2005>=2002							/// 	
								&	startyear_2005!=.								/// 															
								& 	startyear_2002!=startyear_2005					/// 
								&	(nna14_1a_2002==nna14_1a_2005				 	/// 
								|	nna14_1b_2002==nna14_1b_2005				 	/// 
								|	nna14_1c_2002==nna14_1c_2005				 	/// 
								|	nna14_1d_2002==nna14_1d_2005				 	/// 
								|	nna14_1e_2002==nna14_1e_2005				 	/// 
								|	nna14_1f_2002==nna14_1f_2005				 	/// 
								|	nna14_1g_2002==nna14_1g_2005				 	/// 
								|	nna14_1h_2002==nna14_1h_2005				 	/// 
								|	nna14_1i_2002==nna14_1i_2005				 	/// 
								|	nna14_1j_2002==nna14_1j_2005)				 	/// 
								&	resp_pid_link_2002==resp_pid_link_2005	

replace newfirmstarted2005=0 	if	nna01_2002==1 & nna01_2005==1					/// 
								&	nna02_2002==1 & nna02_2005==1	 				/// 
								&	startyear_2005<2002								/// 	
								& 	startyear_2002!=startyear_2005					/// 
								&	(nna14_1a_2002==nna14_1a_2005				 	/// 
								|	nna14_1b_2002==nna14_1b_2005				 	/// 
								|	nna14_1c_2002==nna14_1c_2005				 	/// 
								|	nna14_1d_2002==nna14_1d_2005				 	/// 
								|	nna14_1e_2002==nna14_1e_2005				 	/// 
								|	nna14_1f_2002==nna14_1f_2005				 	/// 
								|	nna14_1g_2002==nna14_1g_2005				 	/// 
								|	nna14_1h_2002==nna14_1h_2005				 	/// 
								|	nna14_1i_2002==nna14_1i_2005				 	/// 
								|	nna14_1j_2002==nna14_1j_2005)				 	/// 
								&	resp_pid_link_2002==resp_pid_link_2005	
						
*In case there are different respondents in both waves (resp_pid_link_2002==resp_pid_link_2005)
*Spouses
replace survival2005=1 if	nna01_2002==1 & nna01_2005==1					 /// 
						&	nna02_2002==1 & nna02_2005==1					 /// 	
						/*&	startyear_20021!=.*/							 /// 
						&	startyear_2005<2002								 /// 
						& 	startyear_2002!=startyear_2005					 /// 
						/*&	abs(startyear_2005-startyear_2002)<=2*/			 /// 
						&	((ls05_1_2002==1 & ls05_1_2005==2)				 /// 
						|	(ls05_1_2002==2 & ls05_1_2005==1))				 /// 
						&	resp_pid_link_2002!=resp_pid_link_2005

replace newfirmstarted2005=1 	if	nna01_2002==1 & nna01_2005==1					 /// 
								&	nna02_2002==1 & nna02_2005==1					 /// 	
								&	startyear_2005>=2002							 /// 
								&	startyear_2005!=.								 /// 															
								& 	startyear_2002!=startyear_2005					 /// 
								&	((ls05_1_2002==1 & ls05_1_2005==2)				 /// 
								|	(ls05_1_2002==2 & ls05_1_2005==1))				 /// 
								&	resp_pid_link_2002!=resp_pid_link_2005

replace newfirmstarted2005=0 	if	nna01_2002==1 & nna01_2005==1					 /// 
								&	nna02_2002==1 & nna02_2005==1					 /// 	
								&	startyear_2005<2002								 /// 
								& 	startyear_2002!=startyear_2005					 /// 
								&	((ls05_1_2002==1 & ls05_1_2005==2)				 /// 
								|	(ls05_1_2002==2 & ls05_1_2005==1))				 /// 
								&	resp_pid_link_2002!=resp_pid_link_2005

/*There is one case in which the respondent in 2002, who is also the business owner,
 is the son/daughter in law of the hh head, while in 2005 the son/daughter of the hh
 head is the respondent and indicates his/her spouse as the business owner*/
replace survival2005=1 if	nna01_2002==1 & nna01_2005==1					 /// 
						&	nna02_2002==1 & nna02_2005==1					 /// 	
						&	startyear_2005<2002								 /// 	
						& 	startyear_2002!=startyear_2005					 /// 
						&	(ls05_1_2002==5 & ls05_1_2005==3)				 /// 
						&	nna14_1a_2002==1								 /// 
						& 	nna14_1b_2005==2								 ///
						&	resp_pid_link_2002!=resp_pid_link_2005							

replace newfirmstarted2005=1 	if	nna01_2002==1 & nna01_2005==1					 /// 
								&	nna02_2002==1 & nna02_2005==1					 /// 	
								&	startyear_2005>=2002							 /// 	
								&	startyear_2005!=.								 /// 															
								& 	startyear_2002!=startyear_2005					 /// 
								&	(ls05_1_2002==5 & ls05_1_2005==3)				 /// 
								&	nna14_1a_2002==1								 /// 
								& 	nna14_1b_2005==2								 ///
								&	resp_pid_link_2002!=resp_pid_link_2005	

replace newfirmstarted2005=0 	if	nna01_2002==1 & nna01_2005==1					 /// 
								&	nna02_2002==1 & nna02_2005==1					 /// 	
								&	startyear_2005<2002								 /// 	
								& 	startyear_2002!=startyear_2005					 /// 
								&	(ls05_1_2002==5 & ls05_1_2005==3)				 /// 
								&	nna14_1a_2002==1								 /// 
								& 	nna14_1b_2005==2								 ///
								&	resp_pid_link_2002!=resp_pid_link_2005
						
*Parents and kids
replace survival2005=1 	if	nna01_2002==1 & nna01_2005==1					 /// 
						&	nna02_2002==1 & nna02_2005==1					 /// 
						/*&	startyear_2002!=.*/								 /// 
						&	startyear_2005<2002								 /// 
						& 	startyear_2002!=startyear_2005					 /// 
						/*&	abs(startyear_2005-startyear_2002)<=2*/			 /// 
						&	((ls05_1_2002==1 & ls05_1_2005==3)				 /// 
						|	(ls05_1_2002==2 & ls05_1_2005==3)				 /// 
						|	(ls05_1_2002==3 & ls05_1_2005==1)				 /// 
						|	(ls05_1_2002==3 & ls05_1_2005==2))				 /// 
						&	nna14_1h_2002==nna14_1h_2005					 ///
						&	resp_pid_link_2002!=resp_pid_link_2005

replace newfirmstarted2005=1 	if	nna01_2002==1 & nna01_2005==1					 /// 
								&	nna02_2002==1 & nna02_2005==1					 /// 
								&	startyear_2005>=2002							 /// 
								&	startyear_2005!=.								 /// 							
								& 	startyear_2002!=startyear_2005					 /// 
								&	((ls05_1_2002==1 & ls05_1_2005==3)				 /// 
								|	(ls05_1_2002==2 & ls05_1_2005==3)				 /// 
								|	(ls05_1_2002==3 & ls05_1_2005==1)				 /// 
								|	(ls05_1_2002==3 & ls05_1_2005==2))				 /// 
								&	nna14_1h_2002==nna14_1h_2005					 ///
								&	resp_pid_link_2002!=resp_pid_link_2005

replace newfirmstarted2005=0 	if	nna01_2002==1 & nna01_2005==1					 /// 
								&	nna02_2002==1 & nna02_2005==1					 /// 
								&	startyear_2005<2002								 /// 
								& 	startyear_2002!=startyear_2005					 /// 
								&	((ls05_1_2002==1 & ls05_1_2005==3)				 /// 
								|	(ls05_1_2002==2 & ls05_1_2005==3)				 /// 
								|	(ls05_1_2002==3 & ls05_1_2005==1)				 /// 
								|	(ls05_1_2002==3 & ls05_1_2005==2))				 /// 
								&	nna14_1h_2002==nna14_1h_2005					 ///
								&	resp_pid_link_2002!=resp_pid_link_2005

/* There is one case in which the son/daughter of the hh head is the respondent in 2002
 and indicates that he/she and his/her spouse are running the business, in 2005 the grandson/
 granddaughter of the hh head is the respondent and indicates that his/her parents run the
 business*/
replace survival2005=1 if	nna01_2002==1 & nna01_2005==1					 /// 
						&	nna02_2002==1 & nna02_2005==1					 /// 
						&	startyear_2005<2002 							 /// 	
						& 	startyear_2002!=startyear_2005					 /// 
						&	(ls05_1_2002==3 & ls05_1_2005==10)				 ///
						&	nna14_1a_2002==1								 ///
						&	nna14_1b_2002==2								 ///
						&	nna14_1d_2005==4								 ///						
						&	resp_pid_link_2002!=resp_pid_link_2005

replace newfirmstarted2005=1 	if	nna01_2002==1 & nna01_2005==1					 /// 
								&	nna02_2002==1 & nna02_2005==1					 /// 
								&	startyear_2005>=2002 							 /// 	
								&	startyear_2005!=.								 /// 							
								& 	startyear_2002!=startyear_2005					 /// 
								&	(ls05_1_2002==3 & ls05_1_2005==10)				 ///
								&	nna14_1a_2002==1								 ///
								&	nna14_1b_2002==2								 ///
								&	nna14_1d_2005==4								 ///						
								&	resp_pid_link_2002!=resp_pid_link_2005

replace newfirmstarted2005=0 	if	nna01_2002==1 & nna01_2005==1					 /// 
								&	nna02_2002==1 & nna02_2005==1					 /// 
								&	startyear_2005<2002 							 /// 	
								& 	startyear_2002!=startyear_2005					 /// 
								&	(ls05_1_2002==3 & ls05_1_2005==10)				 ///
								&	nna14_1a_2002==1								 ///
								&	nna14_1b_2002==2								 ///
								&	nna14_1d_2005==4								 ///						
								&	resp_pid_link_2002!=resp_pid_link_2005

/* There is one case in which the respondents in 2002 and 2005 are siblings and both
 indicate their parents as the business owner*/
replace survival2005=1 if	nna01_2002==1 & nna01_2005==1					 /// 
						&	nna02_2002==1 & nna02_2005==1					 /// 
						&	startyear_2005<2002								 /// 							
						& 	startyear_2002!=startyear_2005					 /// 
						&	(ls05_1_2002==8 & ls05_1_2005==1)				 ///
						&	nna14_1d_2002==4								 ///
						&	nna14_1d_2005==4								 ///						
						&	resp_pid_link_2002!=resp_pid_link_2005	
						
replace newfirmstarted2005=1 	if	nna01_2002==1 & nna01_2005==1					 /// 
								&	nna02_2002==1 & nna02_2005==1					 /// 
								&	startyear_2005>=2002							 /// 							
								&	startyear_2005!=.								 /// 							
								& 	startyear_2002!=startyear_2005					 /// 
								&	(ls05_1_2002==8 & ls05_1_2005==1)				 ///
								&	nna14_1d_2002==4								 ///
								&	nna14_1d_2005==4								 ///						
								&	resp_pid_link_2002!=resp_pid_link_2005							

replace newfirmstarted2005=0 	if	nna01_2002==1 & nna01_2005==1					 /// 
								&	nna02_2002==1 & nna02_2005==1					 /// 
								&	startyear_2005<2002								 /// 							
								& 	startyear_2002!=startyear_2005					 /// 
								&	(ls05_1_2002==8 & ls05_1_2005==1)				 ///
								&	nna14_1d_2002==4								 ///
								&	nna14_1d_2005==4								 ///						
								&	resp_pid_link_2002!=resp_pid_link_2005									
*Inlaws
/* There is one case in which the household head was the respondent in 2002 and 
 indicated his/her spouse as the business owner, while in 2005 the son/daughter
 in law was the respondent and indicated that his/her parent(s) in law was/were
 the owners of the hh business*/					
replace survival2005=1 if	nna01_2002==1 & nna01_2005==1					 /// 
						&	nna02_2002==1 & nna02_2005==1					 ///  
						&	startyear_2005<2002							 	 /// 	
						& 	startyear_2002!=startyear_2005					 /// 
						&	(ls05_1_2002==1 & ls05_1_2005==5)				 ///
						&	nna14_1b_2002==2								 ///
						&	nna14_1e_2005==5								 ///
						&	resp_pid_link_2002!=resp_pid_link_2005

replace newfirmstarted2005=1 	if	nna01_2002==1 & nna01_2005==1					 /// 
								&	nna02_2002==1 & nna02_2005==1					 ///  
								&	startyear_2005>=2002						 	 /// 	
								&	startyear_2005!=.								 /// 							
								& 	startyear_2002!=startyear_2005					 /// 
								&	(ls05_1_2002==1 & ls05_1_2005==5)				 ///
								&	nna14_1b_2002==2								 ///
								&	nna14_1e_2005==5								 ///
								&	resp_pid_link_2002!=resp_pid_link_2005

replace newfirmstarted2005=0 	if	nna01_2002==1 & nna01_2005==1					 /// 
								&	nna02_2002==1 & nna02_2005==1					 ///  
								&	startyear_2005<2002							 	 /// 	
								& 	startyear_2002!=startyear_2005					 /// 
								&	(ls05_1_2002==1 & ls05_1_2005==5)				 ///
								&	nna14_1b_2002==2								 ///
								&	nna14_1e_2005==5								 ///
								&	resp_pid_link_2002!=resp_pid_link_2005

/* There is one case where in 2002 the spouse of the hh head was the respondent and
 he/she indicated his/her parent(s) as the business owner(s), while in 2005 a parent
 in law of the hh head was the respondent and indicated him-/herself as the business
 owner*/

replace survival2005=1 if	nna01_2002==1 & nna01_2005==1					 /// 
						&	nna02_2002==1 & nna02_2005==1					 ///  
						&	startyear_2005<2002								 /// 							
						& 	startyear_2002!=startyear_2005					 /// 
						&	(ls05_1_2002==2 & ls05_1_2005==7)				 ///
						&	nna14_1d_2002==4								 ///
						&	nna14_1a_2005==1								 ///
						&	resp_pid_link_2002!=resp_pid_link_2005

replace newfirmstarted2005=1	if	nna01_2002==1 & nna01_2005==1					 /// 
								&	nna02_2002==1 & nna02_2005==1					 ///  
								&	startyear_2005>=2002							 /// 							
								&	startyear_2005!=.								 /// 							
								& 	startyear_2002!=startyear_2005					 /// 
								&	(ls05_1_2002==2 & ls05_1_2005==7)				 ///
								&	nna14_1d_2002==4								 ///
								&	nna14_1a_2005==1								 ///
								&	resp_pid_link_2002!=resp_pid_link_2005
								
replace newfirmstarted2005=0	if	nna01_2002==1 & nna01_2005==1					 /// 
								&	nna02_2002==1 & nna02_2005==1					 ///  
								&	startyear_2005<2002								 /// 							
								& 	startyear_2002!=startyear_2005					 /// 
								&	(ls05_1_2002==2 & ls05_1_2005==7)				 ///
								&	nna14_1d_2002==4								 ///
								&	nna14_1a_2005==1								 ///
								&	resp_pid_link_2002!=resp_pid_link_2005

/*There is one household in which the 2002 hh head, who was the respondent in 2002 and
 who also indicated him-/herself and his/her spouse as the business owner, is deceased
 in 2005. In 2005 the former spouse of the 2002 hh head is the new hh head and indicates
 him-/herself as the business owner, together with his/her spouse (although there
 is non in the 2005 hh roster*/
replace survival2005=1 if	nna01_2002==1 & nna01_2005==1					 /// 
						&	nna02_2002==1 & nna02_2005==1					 ///  
						&	startyear_2005<2002							 	 /// 	
						& 	startyear_2002!=startyear_2005					 /// 
						&	(ls05_1_2002==1 & ls05_1_2005==1)				 ///
						&	nna14_1a_2002==1								 ///
						&	nna14_1b_2002==2								 ///
						&	nna14_1a_2005==1								 ///
						&	nna14_1b_2005==2								 ///
						&	resp_pid_link_2002!=resp_pid_link_2005

replace newfirmstarted2005=1	if	nna01_2002==1 & nna01_2005==1					 /// 
								&	nna02_2002==1 & nna02_2005==1					 ///  
								&	startyear_2005>=2002							 /// 
								&	startyear_2005!=.								 /// 							
								& 	startyear_2002!=startyear_2005					 /// 
								&	(ls05_1_2002==1 & ls05_1_2005==1)				 ///
								&	nna14_1a_2002==1								 ///
								&	nna14_1b_2002==2								 ///
								&	nna14_1a_2005==1								 ///
								&	nna14_1b_2005==2								 ///
								&	resp_pid_link_2002!=resp_pid_link_2005

replace newfirmstarted2005=0	if	nna01_2002==1 & nna01_2005==1					 /// 
								&	nna02_2002==1 & nna02_2005==1					 ///  
								&	startyear_2005<2002								 /// 
								& 	startyear_2002!=startyear_2005					 /// 
								&	(ls05_1_2002==1 & ls05_1_2005==1)				 ///
								&	nna14_1a_2002==1								 ///
								&	nna14_1b_2002==2								 ///
								&	nna14_1a_2005==1								 ///
								&	nna14_1b_2005==2								 ///
								&	resp_pid_link_2002!=resp_pid_link_2005

keep folio newfirmstarted2005 survival2005	
*TO DO: decide whether you need/want to change path for saving survivalnf0205
/*		*/				
save survivalnf0205, replace
/**/
********************************************************************************
*Round 3
********************************************************************************

clear
*TO DO: change path to where you saved the following file "hh09dta_bc/c_ls.dta"
/*EXAMPLE:*/
use "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 3/hh09dta_bc/c_ls.dta
/**/

*Remove duplicates in folio and ls
/*There are 16 duplicates in folio and ls. It appears that this is the case for some
 individuals who used to live in the household in 2002 but not in 2005 (ls01a==3 & ls19==3).
 They appear twice, once with ls01a==3 & ls19==3 and missings on all other variables, and
 once with ls01a!=3 & ls19!=3 and values for the other variables, so I drop the duplicate 
 observations, which have ls01a==3 & ls19==3:
*/
duplicates tag folio ls, gen(dupl)
drop if dupl!=0 & ls01a==3 & ls19==3

*Owner died between survey rounds
g dead=(ls01a==0) if ls01a!=.

keep folio ls ls01a ls05_1 ls11 dead pid

*TO DO: decide whether you need/want to change path for saving MXFLS3
/*	*/
save MXFLS3, replace
/**/

clear
*Get the date of the book 2 interview:
*TO DO: change path to where you saved the following file "hh09dta_b2/ii_conpor.dta"
/*EXAMPLE:*/
use "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 3/hh09dta_b2/ii_conpor.dta"
/**/
/*I only keep those in which the interview was complete. If the questionnaire was completed in more than 1 visit,
 I take the date of the inverview at which it was coded to be complete*/
keep if rev==20 & hrsprox==.

keep folio mes anio

g help=string(mes)+"-200"+string(anio) if anio<10
replace help=string(mes)+"-20"+string(anio) if anio>=10


g interviewmonth2009_13=monthly(help,"MY")

keep folio interviewmonth2009_13 anio

*TO DO: change path to where you saved the following file "hh09dta_b2/ii_nna1.dta"
/*EXAMPLE:*/
merge 1:m folio using "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 3/hh09dta_b2/ii_nna1.dta", nogenerate
/**/
*TO DO: change path to where you saved the following file "hh09dta_b2/ii_nna.dta"
/*EXAMPLE:*/
merge m:1 folio using "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 3/hh09dta_b2/ii_nna.dta", nogenerate
/**/
*Household operates a non-form business
g hhbus=(nna01==1) & nna01!=.

*Age of the firm in years and date of the business start
g help=string(nna05_21)+"-"+string(nna05_22)
g startofbus=monthly(help,"MY")
replace startofbus=yearly(string(nna05_22),"Y") if nna05_21==. & nna05_1==1

g agefirm=(interviewmonth2009_13-startofbus)/12

/*I use 2009.00, 2010.00, 2011.00, 2012.00 and 2013.00 as the interviewdate for
 the yearly start dates of the businesses, as I don't know when exactly the businesses
 started in the start year and hence treat all as if they had started in January of that year.*/
forvalues i=9/13{ 
replace agefirm=(200`i'-startofbus) if nna05_21==. & nna05_1==1 & anio==`i' & anio<10
replace agefirm=(20`i'-startofbus) if nna05_21==. & nna05_1==1 & anio==`i' & anio>=10
}

g x_agefirm=.
replace x_agefirm=1 if nna05_21!=. & nna05_22!=. & anio!=. & nna05_1==1
replace x_agefirm=0 if nna05_21==. & nna05_22!=. & anio!=. & nna05_1==1

*Survey round number
g wave=3

*Number of paid employees
*We assume that all people working in the business in addition to the household members are paid
* -> employees = nna19_21 + household members
/* Given that I cannot know exactly how many household members work in the business and if they are
 paid or unpaid, I combine the information on houseold members working in the business with
 the information from the employment module in book 3a later*/
 
/*But first, remove household members working in the business from NNA19, if they
 are the decision takers of the business. (In these cases they are considered as the 
 business owners rather than workers)*/

foreach x in 1a 1b 1c 1d 1e 1f 1g 1h 1i 1j{
replace nna18_`x'=0 if nna18_`x'!=. & nna18_`x'==nna14_`x'
}
 
*Business profits in last month
g profits=.
replace profits=nna22_12 if  nna22_1==2
*Since profits are given for past 12 months:
replace profits=profits/12
drop nna22_12 nna22_1
 
*Business sales in last month
/*Although the coding for nna21_2 says "Quantity business produce last month before closed",
 I assume that it is as in the rounds before, the sales of the past 12 months since this is
 also what is being asked in question NNA21 of the questionnaire (Book 2 - Section NNA)*/
g sales=.
replace sales=nna21_2 if  nna21_1==1
*Since sales are given for past 12 months:
replace sales=sales/12
drop nna21_2 nna21_1

keep folio interviewmonth2009_13 hhbus startofbus agefirm x_agefirm profits sales nna14* nna18* nna19* nna01 nna02 wave

g tbdropped=(nna01==1 & nna02>1) if nna01!=.

/*Since the data is in long format in case a hh operates more than one business I drop
 duplicates in folio tbdropped to be able to merge the 2002 with the 2005 data later
*/
duplicates drop folio tbdropped, force

*TO DO: change path to where you saved the following file "MXFLS3.dta"
/*EXAMPLE:*/
merge 1:m folio using MXFLS3, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving MXFLS3
/**/	
save MXFLS3, replace
/**/

*TO DO: change path to where you saved the following file "hh09dta_b2/ii_se.dta"
/*EXAMPLE:*/
merge m:1 folio using "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 3/hh09dta_b2/ii_se.dta", nogenerate
/**/

gen date = dofm(interviewmonth2009_13)
gen ivyear=year(date)

*Family member ill in last month
/*There is no way of knowing whether the illness or accident happened in the previous month,
since only the year is asked, but not the month.
-> I consider illnesses that happened in the same year as the year of the survey, i.e. 2002*/
g familyill=(se01b==1 & se02ba_2==ivyear)
replace familyill=. if se01b==. 

*Owner ill in the last month
g resp_bo=(nna14_1a==1)
replace resp_bo=. if nna14_1j==98 | nna01!=1

g spouse_bo=(nna14_1b==2)
replace spouse_bo=. if nna14_1j==98 | nna01!=1

g ownerill`i'=.
replace ownerill=1 if resp_bo==1 & familyill==1 & (se03ba_1==1 | se03bb_1==1 | se03bc_1==1)
replace ownerill=1 if spouse_bo==2 & familyill==1 & (se03ba_1==2 | se03bb_1==2 | se03bc_1==2)
replace ownerill=0 if ownerill==. & nna01==1

drop se*  

*TO DO: decide whether you need/want to change path for saving MXFLS3
/*	*/
save MXFLS3, replace
/**/

clear
*TO DO: change path to where you saved the following file "hh09dta_b2/ii_portad.dta"
/*EXAMPLE:*/
use "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 3/hh09dta_b2/ii_portad.dta"
/**/

rename ls respondent_ls

keep folio respondent_ls

*TO DO: change path to where you saved the following file "MXFLS3.dta"
/*EXAMPLE:*/
merge 1:m folio using MXFLS3, nogenerate
/**/

*Identify the business owners
/*The section on the non-farm business does not ask who is the business owner, but which hh
 members took the most important decisions regarding the business. I use this to determine
 whether an individual is the business owner*/

g businessowner=.
replace businessowner=1 if ls==respondent_ls & nna14_1a==1
replace businessowner=0 if businessowner==. & nna01==1


/*ls11 gives the ls/id of the spouse, which I can use to identify the business owner if he/she
 is the respondent's spouse
*/

g help=ls11 if ls==respondent & ls11!=51 & ls11!=53
bysort folio: egen help2=total(help), m

g spouse_ls="0"+string(help2) if help2<10
replace spouse_ls=string(help2) if help2>=10

replace businessowner=1 if ls==spouse_ls & nna14_1b==2

drop help*

*Identify the household members working in the businesses
*In the case the respondent is the business owner as well as the household head:
g help=(ls==respondent_ls & businessowner==1 & ls05_1==1)
bysort folio: egen help2=total(help), m


g hhbus_worker=.
replace hhbus_worker=1 if help2==1 & ((nna18_1b==2 & ls05_1==2) | (nna18_1c==3 & ls05_1==3) | (nna18_1d==4 & ls05_1==6) | (nna18_1e==5 & ls05_1==7) | (nna18_1f==6 & ls05_1==8) | (nna18_1g==7 & ls05_1==9) | (nna18_1h==8 & (ls01a==1 | ls01a==4)) | (nna18_1i==9 & ls05_1!=1 & ls05_1!=2 & ls05_1!=3  & ls05_1!=6  & ls05_1!=7  & ls05_1!=8  & ls05_1!=9))

drop help*

*In the case the respondent is the business owner and the spouse of the household head:
g help=(ls==respondent_ls & businessowner==1 & ls05_1==2)
bysort folio: egen help2=total(help), m

replace hhbus_worker=1 if help2==1 & ((nna18_1b==2 & ls05_1==1) | (nna18_1c==3 & ls05_1==3) | (nna18_1d==4 & ls05_1==7) | (nna18_1e==5 & ls05_1==6) | (nna18_1f==6 & ls05_1==9) | (nna18_1g==7 & ls05_1==8) | (nna18_1h==8 & (ls01a==1 | ls01a==4)) | (nna18_1i==9 & ls05_1!=1 & ls05_1!=2 & ls05_1!=3  & ls05_1!=6  & ls05_1!=7  & ls05_1!=8  & ls05_1!=9))


*In the case that no household member has been working in the business
replace hhbus_worker=0 if hhbus==1 & nna18_1j==10


drop help*

drop nna14* nna18* nna01 nna02

*TO DO: decide whether you need/want to change path for saving MXFLS3
/*	*/
save MXFLS3, replace
/**/

*TO DO: change path to where you saved the following file "hh09dta_b3a/iiia_tb.dta"
/*EXAMPLE:*/
merge 1:1 folio ls using "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 3/hh09dta_b3a/iiia_tb.dta", nogenerate
/**/

keep folio-hhbus_worker tb02 tb05 tb32p tb32s tb27p tb28p tb35a_2

*TO DO: change path to where you saved the following file "hh09dta_bx/p_tb.dta"
/*EXAMPLE:*/
merge 1:1 folio ls using "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 3/hh09dta_bx/p_tb.dta", nogenerate update 
/**/

*Hours worked in self-employment in last month
g selfemployed=(tb32p==5 | tb32p==6) if (tb32p!=. | tb05!=8) & (tb32p!=. | tb05!=.)

g hours=tb27p*(30/7) if selfemployed==1
label var hours "based on hours worked during the past week"

g hoursnormal=tb28p*(30/7) if selfemployed==1
label var hoursnormal "based on hours worked during a normal week"

*Worked as wage worker in last month
g wageworker=(tb32p==3)  if (tb32p!=. | tb05!=8) & (tb32p!=. | tb05!=.)

*Labor earnings in last month
g laborincome=wageworker*tb35a_2

*Retired
g retired=(tb02_1==6) if tb02!=.

*Employees
/*I use the information from the employment module of Book 3A to calculate the
 number of paid household members.
 For this I assume that a household member having been identified as working in
 the business, is a paid worker, if in his/her primary or secondary job he/she is neither: 
 - a family worker in a hh owned business, without remuneration; nor
 - a boss, employer, or business proprietor; nor
 - a self-employed worker (with or without non-remunerated worker)
 Since we focus on non-agricultural businesses, an individual, having been identified
 as working in the business, is judged to be a paid worker in such a household business
 if in his/her primary or secondary job he/she is a non-agricultural worker or employee
 and in the other is either the same, or:
 - a peasont on his/her plot; or
 - a rural laborer, or land peon (agricultural worker); or
 - a worker without remuneration from a business or company that is not owned by the HH
*/
g paidhhworker=0 if  hhbus_worker==1
replace paidhhworker=1 if hhbus_worker==1 & ((tb32p==3 & tb32s!=2 & tb32s!=5  & tb32s!=6) | (tb32s==3 & tb32p!=2 & tb32p!=5 & tb32p!=6))


bysort folio: egen numofpaidhhworkers= total(paidhhworker), m


*Now, finally, the number of paid employees
egen employees=rowtotal(numofpaidhhworkers nna19_2), m



drop tb02_1-tb39p nna19* numofpaidhhworkers* paidhhworker*

*TO DO: decide whether you need/want to change path for saving MXFLS3
/*	*/
save MXFLS3, replace
/**/

*Household consumption
clear
*TO DO: change path to where you saved the following file "hh09dta_b1/i_cs.dta"
/*EXAMPLE:*/
use "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 3/hh09dta_b1/i_cs.dta"
/**/
*TO DO: change path to where you saved the following file "hh09dta_b1/i_cs1.dta"
/*EXAMPLE:*/
merge 1:1 folio using "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 3/hh09dta_b1/i_cs1.dta", nogenerate
/**/


# delimit ;
egen weeklyfoodconsump=rowtotal(cs02a_12 cs02a_22 cs02a_32 cs02a_42 cs02a_52 cs02a_62 cs02a_72 cs02a_82 cs02b_12 cs02b_22 cs02b_32 cs02b_42 cs02b_52 cs02c_12 cs02c_22 cs02c_32 cs02c_42 cs02c_52 cs02c_62 cs02c_72 cs02c_82 cs02d_12 cs02d_22 cs02d_32 cs02d_42 cs02e_12 cs02e_22 cs02e_32
								cs04a_12 cs04a_22 cs04a_32 cs04a_42 cs04a_52 cs04a_62 cs04a_72 cs04a_82 cs04b_12 cs04b_22 cs04b_32 cs04b_42 cs04b_52 cs04c_12 cs04c_22 cs04c_32 cs04c_42 cs04c_52 cs04c_62 cs04c_72 cs04c_82 cs04d_12 cs04d_22 cs04d_32 cs04d_42 cs04d_52 cs04e_12 cs04e_22 cs04e_32 cs04e_42 cs04e_52 cs04e_62 cs04e_72 cs04e_82 cs04e_92 cs04e_102 cs04e_112 cs04e_122 cs04e_132
								cs15a-cs15j
								),m
;

# delimit cr



replace cs06_2=0 if cs05==3

replace weeklyfoodconsump=weeklyfoodconsump-cs06_2

egen monthlynonfoodexp=rowtotal(cs16a_2 cs16b_2 cs16c_2 cs16d_2 cs16e_2 cs16f_2 cs16g_2 cs16h_2 cs16i_2 cs18_2), m

replace cs20_2=0 if cs19==3

replace monthlynonfoodexp=monthlynonfoodexp-cs20_2

# delimit ;
egen quarterlynonfoodexp=rowtotal(cs22a_2 cs22b_2 cs22c_2 cs22d_2 cs22e_2 cs22f_2 cs22g_2 cs22h_2
									cs24a_2 cs24b_2 cs24c_2 cs24d_2 cs24e_2 cs24f_2 cs24g_2 cs24h_2
									),m
;
# delimit cr


replace cs26_2=0 if cs25==3
 
replace quarterlynonfoodexp=quarterlynonfoodexp-cs26_2

egen yearlynonfoodexp=rowtotal(cs27a_2 cs27b_2 cs27c_2 cs27d_2 cs27e_2 cs27f_2 cs29_2),m

replace cs31_2=0 if cs30==3

replace yearlynonfoodexp=yearlynonfoodexp-cs31_2

foreach var of varlist cs34a_12 cs34a_22 cs34a_32 cs35a_12 cs35a_22 cs35a_32 cs36a_12 cs36a_22 cs36a_32{
replace `var'=0 if cs32==3
}

/*I assume that with current school period, the whole year is referred to for questions cs34 and cs35
	(Although the questionnaire only says "present school period", the codebook says "school year")
*/
egen yearlyeducexp =rowtotal(cs34a_12 cs34a_22 cs34a_32 cs35a_12 cs35a_22 cs35a_32),m

egen monthlyeducexp=rowtotal(cs36a_12 cs36a_22 cs36a_32),m



replace weeklyfoodconsump=52*weeklyfoodconsump
replace monthlynonfoodexp=12*monthlynonfoodexp
replace quarterlynonfoodexp=4*quarterlynonfoodexp
replace monthlyeducexp=12*monthlyeducexp
egen hh_exp=rowtotal(yearlynonfoodexp yearlyeducexp weeklyfoodconsump monthlynonfoodexp quarterlynonfoodexp monthlyeducexp), missing

keep folio hh_exp

*TO DO: decide whether you need/want to change path for saving consumpexp
/**/
save consumpexp, replace
/**/

clear
*TO DO: change path to where you saved the following file "hh09dta_bc/c_ls.dta"
/*EXAMPLE:*/
use "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 3/hh09dta_bc/c_ls.dta
/**/

*Remove duplicates in folio and ls
/*There are 16 duplicates in folio and ls. It appears that this is the case for some
 individuals who used to live in the household in 2002 but not in 2005 (ls01a==3 & ls19==3).
 They appear twice, once with ls01a==3 & ls19==3 and missings on all other variables, and
 once with ls01a!=3 & ls19!=3 and values for the other variables, so I drop the duplicate 
 observations, which have ls01a==3 & ls19==3:
*/
duplicates tag folio ls, gen(dupl)
drop if dupl!=0 & ls01a==3 & ls19==3

bysort folio: egen hhsize=total(ls01a==1 | ls01a==4 | ls01a==5 | ls01a==6 ), m

keep folio hhsize
duplicates drop

*TO DO: change path to where you saved the following file "consumpexp.dta"
/*EXAMPLE:*/
merge 1:1 folio using consumpexp, nogenerate
/**/

g pcexpend=hh_exp/hhsize

keep folio pcexpend

*TO DO: change path to where you saved the following file "MXFLS3.dta"
/*EXAMPLE:*/
merge 1:m folio using MXFLS3, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving MXFLS3
/**/
save MXFLS3, replace
/**/

/* Since it doen't say anywhere what the exact period of the 3rd round survey was,
	I use the information from the control book to calculate the approximate midpoint of
	the survey, which I need for the exchange rate.
*/

clear
*TO DO: change path to where you saved the following file "hh09dta_bc/c_conpor.dta"
/*EXAMPLE:*/
use "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 3/hh09dta_bc/c_conpor.dta
/**/

/*Since there is no variable on the day of the interview, I can only compute the interview date on a 
 monthly basis*/
g help=string(mes)+"-200"+string(anio) if anio<10
replace help=string(mes)+"-20"+string(anio) if anio>=10

g interviewdate=monthly(help,"MY")
format interviewdate %tm
su interviewdate,detail
list interviewdate if interviewdate==r(p50)
* -> The midpoint is November, 2009 -> I take November 15, 2009 as midpoint

clear
*TO DO: change path to where you saved the following file "MXFLS3.dta"
/*EXAMPLE:*/
use MXFLS3
/**/

/*According to oanda.com, the MXN to USD exchange rate on November 15, 2009 was 0.07657.
	(https://www.oanda.com/lang/de/currency/converter/)
*/
g excrate=0.07657

g excratemonth="11-2009"

/*Although the survey ran from 2009 until 2013 I code the surveyyear as 2009, since this is being done with 
 the files provided from MXFLS*/
g surveyyear=2009

*TO DO: decide whether you need/want to change path for saving MXFLS3
/**/
save MXFLS3, replace
/**/

* Include information on interview results for books used to construct MXFLS3
clear

*TO DO: change path to where you saved the following file "hh09dta_bc/c_portad.dta"
/*EXAMPLE:*/
use "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 3/hh09dta_bc/c_portad.dta
/**/
keep folio rel reh 
foreach var of varlist rel reh{
rename `var' bc_`var'
}

drop if folio==""
duplicates drop

*TO DO: change path to where you saved the following file "hh09dta_b1/i_portad.dta"
/*EXAMPLE:*/
merge 1:1 folio using "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 3/hh09dta_b1/i_portad.dta
/**/

keep folio bc* rel

rename rel b1_rel

*TO DO: change path to where you saved the following file "hh09dta_b2/ii_portad.dta"
/*EXAMPLE:*/
merge 1:1 folio using "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 3/hh09dta_b2/ii_portad.dta
/**/

keep folio b* rel

rename rel b2_rel

*TO DO: change path to where you saved the following file "MXFLS3.dta"
/*EXAMPLE:*/
merge 1:m folio using MXFLS3, keep(2 3) nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving MXFLS3
/**/
save MXFLS3, replace
/**/

clear
*TO DO: change path to where you saved the following file "hh09dta_b3a/iiia_portad.dta"
/*EXAMPLE:*/
use "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 3/hh09dta_b3a/iiia_portad.dta
/**/
keep folio ls rel

rename rel b3a_rel

*TO DO: change path to where you saved the following file "hh09dta_bea/ea_portad.dta"
/*EXAMPLE:*/
merge 1:1 folio ls using "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 3/hh09dta_bea/ea_portad.dta
/**/
keep folio ls b* rel

rename rel bea_rel

*TO DO: change path to where you saved the following file "MXFLS3.dta"
/*EXAMPLE:*/
merge 1:1 folio ls using MXFLS3, keep(2 3) nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving MXFLS3
/**/
save MXFLS3, replace
/**/

duplicates tag pid, gen(dupl)

/*In order to drop duplicates, I drop those observations that are duplicates and
 have ls01a==3, which only indicates that they were living in the household in 2002
 but not in 2005. These individuals appear again in the data set with their code for
 2009*/
drop if dupl!=0 & ls01a==3

/*There remain 9 pid_links which are duplicates. I drop them, as I cannot find out
what is going on here and they are only very few:*/
drop dupl
duplicates tag pid, gen(dupl)

drop if dupl!=0

/*Given that pid_link has a different format in round 3, I change it to be able to
merge the round 3 data on it with the data from rounds 1 and 2:*/

rename pid_link origpid_link

g pid_link=substr(origpid_link,1,6)+substr(origpid_link,9,4)

/*I now have six duplicate observations. These are pids from split-off households
 that split off twice once in round 2 and another time in round 3). As I can only
 link those hhs and pids that have split off in round 3, I drop the duplicates that
 are round 3 split offs:*/
 
drop dupl

duplicates tag pid, gen(dupl)

drop if dupl!=0 & substr(origpid_link,7,1)=="C"
 
*TO DO: decide whether you need/want to change path for saving MXFLS3
/**/
save MXFLS3, replace
/**/

*Baseline variables

clear
*TO DO: change path to where you saved the following file "hh09dta_bc/c_ls.dta"
/*EXAMPLE:*/
use "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 3/hh09dta_bc/c_ls.dta
/**/

keep folio ls ls02_1 ls02_2 ls04 ls10 ls14 ls15

*Age of owner
g ownerage=ls02_2 if ls02_1==1
replace ownerage=0 if ls02_1==2 | ls02_1==2  
/*
Code for ls02_1:
1.	Years
2.	Months
3.	Days
8.	DK
*/

*Child under 5 in household
g under5=0
replace under5=. if ls02_2==. | ls02_2==8 
replace under5=1 if (ls02_2<5 & ls02_1==1) | ls02_1==2 | ls02_1==2 
bysort folio: egen childunder5=max(under5)
drop under5

*Child aged 5 to 12 in household
g aged5to12=0
replace aged5to12=. if ls02_2==. | ls02_2==8 
replace aged5to12=1 if ls02_2>=5 & ls02_2<12 & ls02_1==1
bysort folio: egen childaged5to12=max(aged5to12)
drop aged5to12

*Has adult aged 65+ in the household
g is65orover=0
replace is65orover=. if ls02_2==. | ls02_2==8 
replace is65orover=1 if ls02_2>=65 & ls02_2!=. & ls02_1==1
bysort folio: egen adult65andover=max(is65orover)
drop is65orover

drop ls02_1 ls02_2

*Owner is female
g female=(ls04==3)
drop ls04

*Owner is married
g married=(ls10==5)
replace married=. if ls10==.
drop ls10

*Owner has tertiary education
g ownertertiary=(ls14==9 | ls14==10)
replace ownertertiary=. if ls14==98 | ls14==.

*Years of education
g educyears=0 if ls14==1 | ls14==2
*Elementary school
replace educyears=ls15 if ls14==3 & ls15!=8
*Secondary school
replace educyears=6+ls15 if (ls14==4 | ls14==5) & ls15!=8
*High School
replace educyears=9+ls15 if (ls14==6 | ls14==7) & ls15!=8
*Tertiary
replace educyears=12+ls15 if (ls14==8 | ls14==9) & ls15!=8
replace educyears=16+ls15 if (ls14==10) & ls15!=8

drop ls14 ls15

gen pid_link = folio + ls

*There are 16 obs. which are duplicate pairs of which one of the pair has missings in a couple of the variables. I drop these
duplicates tag folio ls pid_link, gen(dupl)
egen rowmiss=rowmiss(_all) if dupl>0
bysort folio ls pid_link: egen maxrowmiss=max(rowmiss) if dupl>0

drop if dupl>0 & maxrowmiss==rowmiss

drop dupl rowmiss maxrowmiss

*TO DO: change path to where you saved the following file "hh09dta_bea/ea_eca.dta"
/*EXAMPLE:*/
merge 1:1 folio ls using "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 3/hh09dta_bea/ea_eca.dta", nogenerate
/**/

*Raven progressive matrices score
*I compute the score as the percentage of correct answers for questions eca01 - eca12

replace eca01=(eca01==8) if eca01!=.
replace eca02=(eca02==4) if eca02!=.
replace eca03=(eca03==5) if eca03!=.
replace eca04=(eca04==1) if eca04!=.
replace eca05=(eca05==2) if eca05!=.
replace eca06=(eca06==5) if eca06!=.
replace eca07=(eca07==6) if eca07!=.
replace eca08=(eca08==3) if eca08!=.
replace eca09=(eca09==7) if eca09!=.
replace eca10=(eca10==8) if eca10!=.
replace eca11=(eca11==7) if eca11!=.
replace eca12=(eca12==6) if eca12!=.

egen raven=rowtotal(eca01-eca12),m
replace raven=raven/12

drop eca01-eca12

*TO DO: change path to where you saved the following file "MXFLS3.dta"
/*EXAMPLE:*/
merge 1:1 folio ls pid_link using MXFLS3, keep(2 3) nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving MXFLS3
/**/
save MXFLS3, replace
/**/

********************************************************************************
*Merge round 1 with round 3, and round 2 with round 3 to create survival, newfirmstarted
********************************************************************************

*Survival and newfirmstarted
*Relevant information on hh businesses from round 2 comes from survivalnf2005

*Get relevant information on hh businesses from round 3
clear
*Get the date of the book 3 interview:
*TO DO: change path to where you saved the following file "hh09dta_b2/ii_conpor.dta"
/*EXAMPLE:*/
use "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 3/hh09dta_b2/ii_conpor.dta"
/**/

/*I only keep those in which the interview was complete. If the questionnaire was completed in more than 1 visit,
 I take the date of the inverview at which it was coded to be complete*/
keep if rev==20 & hrsprox==.

keep folio mes anio

g help=string(mes)+"-200"+string(anio) if anio<10
replace help=string(mes)+"-20"+string(anio) if anio>=10


g interviewmonth2009=monthly(help,"MY")

replace anio=2000+anio

keep folio interviewmonth2009 anio

*TO DO: change path to where you saved the following file "hh09dta_b2/ii_portad.dta"
/*EXAMPLE:*/
merge 1:m folio using "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 3/hh09dta_b2/ii_portad.dta", nogenerate
/**/

keep folio ls interviewmonth2009 anio

*TO DO: change path to where you saved the following file "hh09dta_bc/c_ls.dta"
/*EXAMPLE:*/
merge 1:m folio ls using "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 3/hh09dta_bc/c_ls.dta", nogenerate keep(master match)
/**/

/*I drop those observations which only contain the information that the person used
 to live in the household in 2002 but not in 2005, since they are duplicates in 
 terms of folio and have missings on all other variables (which is not the case for 
 their duplicates)*/
duplicates tag folio ls, gen(dupl)
drop if ls01a==3 & dupl!=0

rename pid_link resp_pid_link

keep folio interviewmonth2009 anio resp_pid_link ls05_1

*TO DO: change path to where you saved the following file "hh09dta_b2/ii_nna1.dta"
/*EXAMPLE:*/
merge 1:m folio using "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 3/hh09dta_b2/ii_nna1.dta", nogenerate
/**/
*TO DO: change path to where you saved the following file "hh09dta_b2/ii_nna.dta"
/*EXAMPLE:*/
merge m:1 folio using "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/MXFLS/Round 3/hh09dta_b2/ii_nna.dta", nogenerate
/**/

*Date of the business start
g help=string(nna05_21)+"-"+string(nna05_22)
g startofbus=monthly(help,"MY")
replace startofbus=yearly(string(nna05_22),"Y") if nna05_21==. & nna05_1==1
rename nna05_21 startmonth
rename nna05_22 startyear

keep folio nna01 nna02 nna08 nna11_2 nna15 nna14_1a-nna14_1j nna16_11 nna16_12 interviewmonth2009 anio start* resp_pid_link ls05_1 

rename nna16_11 soldmonth
rename nna16_12 closedmonth

replace nna02=0 if nna01==2

g tbdropped=(nna01==1 & nna02>1) if nna01!=.

/*Since the data is in long format in case a hh operates more than one business I drop
 duplicates in folio tbdropped to be able to merge the 2002 with the 2005 data later
*/
duplicates drop folio tbdropped, force


foreach var of varlist nna01 nna02 nna08 nna11_2 nna14_1a-nna14_1j nna15 startofbus startmonth startyear soldmonth closedmonth resp_pid_link  ls05_1 tbdropped anio{
rename `var' `var'_2009
}


/*Given that the folio is comprised differently in 2009 than in 2005 and 2002
 (see http://www.ennvih-mxfls.org/english/faq.html), I need to create a folio for 2009
 that I can use to merge the 2009 data with that of 2005:
*/

rename folio origfolio

g folio=substr(origfolio,1,6)+substr(origfolio,9,2)


*Same holds for pid_link:

rename resp_pid_link_2009  resp_orig_pid_link_2009 

g  resp_pid_link_2009=substr(resp_orig_pid_link_2009,1,6)+substr(resp_orig_pid_link_2009,9,4)

*TO DO: decide whether you need/want to change path for saving survivalnf2009
/**/
save survivalnf2009, replace
/**/

*Survival and newfirmstarted from round 1 to round 3
clear 
*TO DO: change path to where you saved the following file "survivalnf2002.dta"
/*EXAMPLE:*/
use survivalnf2002
/**/
*TO DO: change path to where you saved the following file "survivalnf2009.dta"
/*EXAMPLE:*/
merge 1:m folio using survivalnf2009
/**/

g survival0209=0 if nna01_2002==1 & nna01_2009==2 & tbdropped_2002==0 & tbdropped_2009==0
g newfirmstarted0209=0 if nna01_2002==1 & nna01_2009==2 & tbdropped_2002==0 & tbdropped_2009==0

*Single business in 2002 and no more than 1 business in 2009:

/*A firm is coded as surviving in 2002 if the household had one firm in 2002 and
 one firm in 2009, and the startdates are identical*/
replace survival0209=1 if nna01_2002==1 & nna01_2009==1 & nna02_2002==1 & nna02_2009==1 & startyear_2002==startyear_2009 & startyear_2009!=. & startyear_2002!=. 

/* A firm is coded as as a new firm if the startdate in round 3 was given as being after the startdate in round 1.
	Survival is coded as missing in that case*/
replace newfirmstarted0209=1 if nna01_2002==1 & nna01_2009==1 & nna02_2002==1 & nna02_2009==1 & startyear_2002!=startyear_2009 & startyear_2009>=2002 & startyear_2009!=. 
replace newfirmstarted0209=0 if nna01_2002==1 & nna01_2009==1 & nna02_2002==1 & nna02_2009==1 & startyear_2002==startyear_2009 & startyear_2009!=. & startyear_2002!=. 
replace newfirmstarted0209=1 if nna01_2002==3 & nna01_2009==1 &  nna02_2009==1 & startyear_2009>=2002 & startyear_2009!=. & tbdropped_2002==0 & tbdropped_2009==0
replace newfirmstarted0209=0 if nna01_2002==3 & nna01_2009==1 &  nna02_2009==1 & startyear_2009<2002 & startyear_2009!=. & tbdropped_2002==0 & tbdropped_2009==0

/*If at least one owner (person(s) taking the most important decisions regarding
 the business) remains the same across both waves, and the startyear in 2009 is 
 different to the one indicated in 2002 but the 2009-startyear is a not after the 
 2001, I code the business as surviving. If the startyear in 2009 
 is given as being later, I code the business as newfirm*/
 
*In case the respondent is the same in both waves (resp_pid_link_2002==resp_pid_link_2009)
replace survival0209=1 	if	nna01_2002==1 & nna01_2009==1					/// 
						&	nna02_2002==1 & nna02_2009==1	 				/// 
						&	startyear_2009<2002								/// 	
						& 	startyear_2002!=startyear_2009					/// 
						&	(nna14_1a_2002==nna14_1a_2009				 	/// 
						|	nna14_1b_2002==nna14_1b_2009				 	/// 
						|	nna14_1c_2002==nna14_1c_2009				 	/// 
						|	nna14_1d_2002==nna14_1d_2009				 	/// 
						|	nna14_1e_2002==nna14_1e_2009				 	/// 
						|	nna14_1f_2002==nna14_1f_2009				 	/// 
						|	nna14_1g_2002==nna14_1g_2009				 	/// 
						|	nna14_1h_2002==nna14_1h_2009				 	/// 
						|	nna14_1i_2002==nna14_1i_2009				 	/// 
						|	nna14_1j_2002==nna14_1j_2009)				 	/// 
						&	resp_pid_link_2002==resp_pid_link_2009				

replace newfirmstarted0209=1 	if	nna01_2002==1 & nna01_2009==1					/// 
								&	nna02_2002==1 & nna02_2009==1	 				/// 
								&	startyear_2009>=2002							/// 	
								&	startyear_2009!=.								/// 															
								& 	startyear_2002!=startyear_2009					/// 
								&	(nna14_1a_2002==nna14_1a_2009				 	/// 
								|	nna14_1b_2002==nna14_1b_2009				 	/// 
								|	nna14_1c_2002==nna14_1c_2009				 	/// 
								|	nna14_1d_2002==nna14_1d_2009				 	/// 
								|	nna14_1e_2002==nna14_1e_2009				 	/// 
								|	nna14_1f_2002==nna14_1f_2009				 	/// 
								|	nna14_1g_2002==nna14_1g_2009				 	/// 
								|	nna14_1h_2002==nna14_1h_2009				 	/// 
								|	nna14_1i_2002==nna14_1i_2009				 	/// 
								|	nna14_1j_2002==nna14_1j_2009)				 	/// 
								&	resp_pid_link_2002==resp_pid_link_2009	

replace newfirmstarted0209=0 	if	nna01_2002==1 & nna01_2009==1					/// 
								&	nna02_2002==1 & nna02_2009==1	 				/// 
								&	startyear_2009<2002						/// 	
								& 	startyear_2002!=startyear_2009					/// 
								&	(nna14_1a_2002==nna14_1a_2009				 	/// 
								|	nna14_1b_2002==nna14_1b_2009				 	/// 
								|	nna14_1c_2002==nna14_1c_2009				 	/// 
								|	nna14_1d_2002==nna14_1d_2009				 	/// 
								|	nna14_1e_2002==nna14_1e_2009				 	/// 
								|	nna14_1f_2002==nna14_1f_2009				 	/// 
								|	nna14_1g_2002==nna14_1g_2009				 	/// 
								|	nna14_1h_2002==nna14_1h_2009				 	/// 
								|	nna14_1i_2002==nna14_1i_2009				 	/// 
								|	nna14_1j_2002==nna14_1j_2009)				 	/// 
								&	resp_pid_link_2002==resp_pid_link_2009	
						
*In case there are different respondents in both waves (resp_pid_link_2002==resp_pid_link_2005)
*Spouses
replace survival0209=1 if	nna01_2002==1 & nna01_2009==1					 /// 
						&	nna02_2002==1 & nna02_2009==1					 /// 	
						&	startyear_2009<2002						 /// 
						& 	startyear_2002!=startyear_2009					 /// 
						&	((ls05_1_2002==1 & ls05_1_2009==2)				 /// 
						|	(ls05_1_2002==2 & ls05_1_2009==1))				 /// 
						&	resp_pid_link_2002!=resp_pid_link_2009

replace newfirmstarted0209=1 	if	nna01_2002==1 & nna01_2009==1					 /// 
								&	nna02_2002==1 & nna02_2009==1					 /// 	
								&	startyear_2009>=2002							 /// 
								&	startyear_2009!=.								 /// 															
								& 	startyear_2002!=startyear_2009					 /// 
								&	((ls05_1_2002==1 & ls05_1_2009==2)				 /// 
								|	(ls05_1_2002==2 & ls05_1_2009==1))				 /// 
								&	resp_pid_link_2002!=resp_pid_link_2009

replace newfirmstarted0209=0 	if	nna01_2002==1 & nna01_2009==1					 /// 
								&	nna02_2002==1 & nna02_2009==1					 /// 	
								&	startyear_2009<2002								 /// 
								& 	startyear_2002!=startyear_2009					 /// 
								&	((ls05_1_2002==1 & ls05_1_2009==2)				 /// 
								|	(ls05_1_2002==2 & ls05_1_2009==1))				 /// 
								&	resp_pid_link_2002!=resp_pid_link_2009
				
*Parents and kids
replace survival0209=1 	if	nna01_2002==1 & nna01_2009==1					 /// 
						&	nna02_2002==1 & nna02_2009==1					 /// 
						&	startyear_2009<2002								 /// 
						& 	startyear_2002!=startyear_2009					 /// 
						&	((ls05_1_2002==1 & ls05_1_2009==3)				 /// 
						|	(ls05_1_2002==2 & ls05_1_2009==3)				 /// 
						|	(ls05_1_2002==3 & ls05_1_2009==1)				 /// 
						|	(ls05_1_2002==3 & ls05_1_2009==2))				 /// 
						&	nna14_1h_2002==nna14_1h_2009					 ///
						&	resp_pid_link_2002!=resp_pid_link_2009

replace newfirmstarted0209=1 	if	nna01_2002==1 & nna01_2009==1					 /// 
								&	nna02_2002==1 & nna02_2009==1					 /// 
								&	startyear_2009>=2002							 /// 
								&	startyear_2009!=.								 /// 							
								& 	startyear_2002!=startyear_2009					 /// 
								&	((ls05_1_2002==1 & ls05_1_2009==3)				 /// 
								|	(ls05_1_2002==2 & ls05_1_2009==3)				 /// 
								|	(ls05_1_2002==3 & ls05_1_2009==1)				 /// 
								|	(ls05_1_2002==3 & ls05_1_2009==2))				 /// 
								&	nna14_1h_2002==nna14_1h_2009					 ///
								&	resp_pid_link_2002!=resp_pid_link_2009

replace newfirmstarted0209=0 	if	nna01_2002==1 & nna01_2009==1					 /// 
								&	nna02_2002==1 & nna02_2009==1					 /// 
								&	startyear_2009<2002								 /// 
								& 	startyear_2002!=startyear_2009					 /// 
								&	((ls05_1_2002==1 & ls05_1_2009==3)				 /// 
								|	(ls05_1_2002==2 & ls05_1_2009==3)				 /// 
								|	(ls05_1_2002==3 & ls05_1_2009==1)				 /// 
								|	(ls05_1_2002==3 & ls05_1_2009==2))				 /// 
								&	nna14_1h_2002==nna14_1h_2009					 ///
								&	resp_pid_link_2002!=resp_pid_link_2009

								
								
/*There are two observations which are duplicates in terms of folio but not in 
 terms of origfolio. I drop the duplicate in the case the household was formed in 
 2009, since this information is of no interest.*/
duplicates tag folio, gen(dupl) 
drop if dupl!=0 & substr(origfolio,7,1)=="C"


keep folio newfirmstarted0209 survival0209								

*TO DO: decide whether you need/want to change path for saving survivalnf0209
/**/
save survivalnf0209, replace
/**/


*Survival and newfirmstarted from round 2 to round 3
clear
*TO DO: change path to where you saved the following file "survivalnf2005.dta"
/*EXAMPLE:*/
use survivalnf2005
/**/
*TO DO: change path to where you saved the following file "survivalnf2009.dta"
/*EXAMPLE:*/
merge 1:m folio using survivalnf2009
/**/
g survival0509=0 if nna01_2005==1 & nna01_2009==2 & tbdropped_2005==0 & tbdropped_2009==0
g newfirmstarted0509=0 if nna01_2005==1 & nna01_2009==2 & tbdropped_2005==0 & tbdropped_2009==0

*Single business in 2005 and no more than 1 business in 2009:

/*A firm is coded as surviving in 2005 if the household had one firm in 2005 and
 one firm in 2009, and the startdates are identical*/
replace survival0509=1 if nna01_2005==1 & nna01_2009==1 & nna02_2005==1 & nna02_2009==1 & startyear_2005==startyear_2009 & startyear_2009!=. & startyear_2005!=. 


/* A firm is coded as as a new firm if the startdate in round 3 was given as being after the startdate in round 2.
	Survival is coded as missing in that case*/
replace newfirmstarted0509=1 if nna01_2005==1 & nna01_2009==1 & nna02_2005==1 & nna02_2009==1 & startyear_2005!=startyear_2009 & startyear_2009>=anio_2005 & startyear_2009!=. 
replace newfirmstarted0509=0 if nna01_2005==1 & nna01_2009==1 & nna02_2005==1 & nna02_2009==1 & startyear_2005==startyear_2009 & startyear_2009!=. & startyear_2005!=. 
replace newfirmstarted0509=1 if nna01_2005==3 & nna01_2009==1 &  nna02_2009==1 & startyear_2009>=anio_2005 & startyear_2009!=. & tbdropped_2005==0 & tbdropped_2009==0
replace newfirmstarted0509=0 if nna01_2005==3 & nna01_2009==1 &  nna02_2009==1 & startyear_2009<anio_2005 & startyear_2009!=. & tbdropped_2005==0 & tbdropped_2009==0


/*If at least one owner (person(s) taking the most important decisions regarding
 the business) remains the same across both waves, and the startyear in 2009 is 
 different to the one indicated in 2005 but the 2009-startyear is a year after the 
 2005-interviewdate, I code the business as surviving. If the startyear in 2009 
 is given as being later, I code the business as newfirm*/
*In case the respondent is the same in both waves (resp_pid_link_2005==resp_pid_link_2009)
replace survival0509=1 	if	nna01_2005==1 & nna01_2009==1					/// 
						&	nna02_2005==1 & nna02_2009==1	 				/// 
						&	startyear_2009<anio_2005						/// 	
						& 	startyear_2005!=startyear_2009					/// 
						&	(nna14_1a_2005==nna14_1a_2009				 	/// 
						|	nna14_1b_2005==nna14_1b_2009				 	/// 
						|	nna14_1c_2005==nna14_1c_2009				 	/// 
						|	nna14_1d_2005==nna14_1d_2009				 	/// 
						|	nna14_1e_2005==nna14_1e_2009				 	/// 
						|	nna14_1f_2005==nna14_1f_2009				 	/// 
						|	nna14_1g_2005==nna14_1g_2009				 	/// 
						|	nna14_1h_2005==nna14_1h_2009				 	/// 
						|	nna14_1i_2005==nna14_1i_2009				 	/// 
						|	nna14_1j_2005==nna14_1j_2009)				 	/// 
						&	resp_pid_link_2005==resp_pid_link_2009				

replace newfirmstarted0509=1 	if	nna01_2005==1 & nna01_2009==1					/// 
								&	nna02_2005==1 & nna02_2009==1	 				/// 
								&	startyear_2009>=anio_2005						/// 	
								&	startyear_2009!=.								/// 															
								& 	startyear_2005!=startyear_2009					/// 
								&	(nna14_1a_2005==nna14_1a_2009				 	/// 
								|	nna14_1b_2005==nna14_1b_2009				 	/// 
								|	nna14_1c_2005==nna14_1c_2009				 	/// 
								|	nna14_1d_2005==nna14_1d_2009				 	/// 
								|	nna14_1e_2005==nna14_1e_2009				 	/// 
								|	nna14_1f_2005==nna14_1f_2009				 	/// 
								|	nna14_1g_2005==nna14_1g_2009				 	/// 
								|	nna14_1h_2005==nna14_1h_2009				 	/// 
								|	nna14_1i_2005==nna14_1i_2009				 	/// 
								|	nna14_1j_2005==nna14_1j_2009)				 	/// 
								&	resp_pid_link_2005==resp_pid_link_2009	

replace newfirmstarted0509=0 	if	nna01_2005==1 & nna01_2009==1					/// 
								&	nna02_2005==1 & nna02_2009==1	 				/// 
								&	startyear_2009<anio_2005						/// 	
								& 	startyear_2005!=startyear_2009					/// 
								&	(nna14_1a_2005==nna14_1a_2009				 	/// 
								|	nna14_1b_2005==nna14_1b_2009				 	/// 
								|	nna14_1c_2005==nna14_1c_2009				 	/// 
								|	nna14_1d_2005==nna14_1d_2009				 	/// 
								|	nna14_1e_2005==nna14_1e_2009				 	/// 
								|	nna14_1f_2005==nna14_1f_2009				 	/// 
								|	nna14_1g_2005==nna14_1g_2009				 	/// 
								|	nna14_1h_2005==nna14_1h_2009				 	/// 
								|	nna14_1i_2005==nna14_1i_2009				 	/// 
								|	nna14_1j_2005==nna14_1j_2009)				 	/// 
								&	resp_pid_link_2005==resp_pid_link_2009	
						
*In case there are different respondents in both waves (resp_pid_link_2002==resp_pid_link_2005)
*Spouses
replace survival0509=1 if	nna01_2005==1 & nna01_2009==1					 /// 
						&	nna02_2005==1 & nna02_2009==1					 /// 	
						&	startyear_2009<anio_2005						 /// 
						& 	startyear_2005!=startyear_2009					 /// 
						&	((ls05_1_2005==1 & ls05_1_2009==2)				 /// 
						|	(ls05_1_2005==2 & ls05_1_2009==1))				 /// 
						&	resp_pid_link_2005!=resp_pid_link_2009

replace newfirmstarted0509=1 	if	nna01_2005==1 & nna01_2009==1					 /// 
								&	nna02_2005==1 & nna02_2009==1					 /// 	
								&	startyear_2009>=anio_2005						 /// 
								&	startyear_2009!=.								 /// 															
								& 	startyear_2005!=startyear_2009					 /// 
								&	((ls05_1_2005==1 & ls05_1_2009==2)				 /// 
								|	(ls05_1_2005==2 & ls05_1_2009==1))				 /// 
								&	resp_pid_link_2005!=resp_pid_link_2009

replace newfirmstarted0509=0 	if	nna01_2005==1 & nna01_2009==1					 /// 
								&	nna02_2005==1 & nna02_2009==1					 /// 	
								&	startyear_2009<anio_2005						 /// 
								& 	startyear_2005!=startyear_2009					 /// 
								&	((ls05_1_2005==1 & ls05_1_2009==2)				 /// 
								|	(ls05_1_2005==2 & ls05_1_2009==1))				 /// 
								&	resp_pid_link_2005!=resp_pid_link_2009
				
*Parents and kids
replace survival0509=1 	if	nna01_2005==1 & nna01_2009==1					 /// 
						&	nna02_2005==1 & nna02_2009==1					 /// 
						&	startyear_2009<anio_2005						 /// 
						& 	startyear_2005!=startyear_2009					 /// 
						&	((ls05_1_2005==1 & ls05_1_2009==3)				 /// 
						|	(ls05_1_2005==2 & ls05_1_2009==3)				 /// 
						|	(ls05_1_2005==3 & ls05_1_2009==1)				 /// 
						|	(ls05_1_2005==3 & ls05_1_2009==2))				 /// 
						&	nna14_1h_2005==nna14_1h_2009					 ///
						&	resp_pid_link_2005!=resp_pid_link_2009

replace newfirmstarted0509=1 	if	nna01_2005==1 & nna01_2009==1					 /// 
								&	nna02_2005==1 & nna02_2009==1					 /// 
								&	startyear_2009>=anio_2005						 /// 
								&	startyear_2009!=.								 /// 							
								& 	startyear_2005!=startyear_2009					 /// 
								&	((ls05_1_2005==1 & ls05_1_2009==3)				 /// 
								|	(ls05_1_2005==2 & ls05_1_2009==3)				 /// 
								|	(ls05_1_2005==3 & ls05_1_2009==1)				 /// 
								|	(ls05_1_2005==3 & ls05_1_2009==2))				 /// 
								&	nna14_1h_2005==nna14_1h_2009					 ///
								&	resp_pid_link_2005!=resp_pid_link_2009

replace newfirmstarted0509=0 	if	nna01_2005==1 & nna01_2009==1					 /// 
								&	nna02_2005==1 & nna02_2009==1					 /// 
								&	startyear_2009<anio_2005						 /// 
								& 	startyear_2005!=startyear_2009					 /// 
								&	((ls05_1_2005==1 & ls05_1_2009==3)				 /// 
								|	(ls05_1_2005==2 & ls05_1_2009==3)				 /// 
								|	(ls05_1_2005==3 & ls05_1_2009==1)				 /// 
								|	(ls05_1_2005==3 & ls05_1_2009==2))				 /// 
								&	nna14_1h_2005==nna14_1h_2009					 ///
								&	resp_pid_link_2005!=resp_pid_link_2009

								
								
/*There are two observations which are duplicates in terms of folio but not in 
 terms of origfolio. I drop the duplicate in the case the household was formed in 
 2009, since this information is of no interest.*/
duplicates tag folio, gen(dupl) 
drop if dupl!=0 & substr(origfolio,7,1)=="C"

keep folio newfirmstarted0509 survival0509								

*TO DO: decide whether you need/want to change path for saving survivalnf0509
/**/
save survivalnf0509, replace
/**/

********************************************************************************
*Merge the datasets to create the MXFLS_master dataset
********************************************************************************

clear 
*TO DO: change path to where you saved the following file "MXFLS.dta"
/*EXAMPLE:*/
use MXFLS
/**/

order 	folio ls pid_link ls09 businessowner hhbus_worker ///
		interviewmonth2002 ///
		bc_reh bc_rel b1_rel b2_rel b3a_rel bea_rel ///
		surveyyear ///
		country ///
		ownerage female married ownertertiary educyears childunder5 childaged5to12 adult65andover raven	///
		agefirm x_agefirm familyill ownerill ///
		wave ///
		tbdropped ///
		hhbus ///
		employees profits sales selfemployed hours* wageworker laborincome retired pcexpend excrate excratemonth


format interviewmonth2002 %tm 
*(The interviewmonth refers to the month the interview for book two was taken)

drop respondent_ls-ls11 resp_bo-spouse_bo

foreach var of varlist 	folio ls businessowner ///
						bc_reh bc_rel b1_rel b2_rel b3a_rel bea_rel ///
						surveyyear ///
						ownerage female married ownertertiary educyears childunder5 childaged5to12 adult65andover raven	///
						agefirm x_agefirm familyill ownerill ///
						wave ///
						tbdropped ///
						hhbus ///
						employees profits sales hours hoursnormal wageworker laborincome retired pcexpend excrate excratemonth ///
						hhbus_worker selfemployed{
rename `var' `var'2002
} 

*There is one pid_link missing so I create it:
replace pid_link=string(folio2002, "%08.0f")+string(ls2002, "%02.0f") if pid_link==""

*TO DO: change path to where you saved the following file "MXFLS2.dta"
/*EXAMPLE:*/
merge 1:1 pid_link using MXFLS2, generate(merge1)
/**/

g attrit=(merge1==1)

order 	folio ls attrit dead businessowner hhbus_worker ///
		interviewmonth2005_07 ///
		bc_reh bc_rel b1_rel b2_rel b3a_rel bea_rel ///
		surveyyear ///
		ownerage female married ownertertiary educyears childunder5 childaged5to12 adult65andover raven	///
		agefirm x_agefirm familyill ownerill ///
		wave ///
		tbdropped ///
		hhbus ///
		employees profits sales selfemployed hours hoursnormal  wageworker laborincome retired pcexpend excrate excratemonth ///
		, after(excratemonth2002)

format interviewmonth2005_07 %tm 
*(The interviewmonth refers to the month the interview for book two was taken)
		
drop respondent_ls-ls11 spouse_ls 

foreach var of 	varlist		folio ls attrit dead businessowner ///
							bc_reh bc_rel b1_rel b2_rel b3a_rel bea_rel ///
							surveyyear ///
							ownerage female married ownertertiary educyears childunder5 childaged5to12 adult65andover raven	///
							agefirm x_agefirm familyill ownerill ///
							wave ///
							tbdropped ///
							hhbus ///
							employees profits sales hours hoursnormal  wageworker laborincome retired pcexpend excrate excratemonth ///
							hhbus_worker selfemployed{
rename `var' `var'2005
} 


/*In order to be able to merge this information with the one from the survivalnf dataset,
I need to create a var "folio" out of folio2002 that is string(folio2002, "%08.0f") and that
is only "active" if the folio remains the same between 2002 and 2005:*/

g test=string(folio2002, "%08.0f")
g folio=folio2005 if folio2005==test

*TO DO: change path to where you saved the following file "survivalnf0205.dta"
/*EXAMPLE:	*/				
merge m:1 folio using survivalnf0205, nogenerate keep(1 3)	
/**/

drop folio

*TO DO: change path to where you saved the following file "MXFLS3.dta"
/*EXAMPLE:*/
merge 1:1 pid_link using MXFLS3, keep(1 3) generate(merge2)
/**/

g attrit0509=(merge2==1)
g attrit=((merge1==1 | merge1==3) & merge2==1)


order 	folio ls attrit0509 attrit dead businessowner hhbus_worker ///
		interviewmonth2009_13 ///
		bc_reh bc_rel b1_rel b2_rel b3a_rel bea_rel ///
		surveyyear ///
		ownerage female married ownertertiary educyears childunder5 childaged5to12 adult65andover raven	///
		agefirm x_agefirm familyill ownerill ///
		wave ///
		tbdropped ///
		hhbus ///
		employees profits sales selfemployed hours hoursnormal  wageworker laborincome retired pcexpend excrate excratemonth ///
		, after(newfirmstarted2005)

format interviewmonth2009_13 %tm 
		
drop respondent_ls-spouse_ls dupl

foreach var of 	varlist	folio ls attrit dead businessowner ///
						bc_reh bc_rel b1_rel b2_rel b3a_rel bea_rel ///
						surveyyear ///
						ownerage female married ownertertiary educyears childunder5 childaged5to12 adult65andover raven	///
						agefirm x_agefirm familyill ownerill ///
						wave ///
						tbdropped ///
						hhbus ///
						employees profits sales hours hoursnormal  wageworker laborincome retired pcexpend excrate excratemonth ///
						hhbus_worker selfemployed{
rename `var' `var'2009
} 

/*In order to be able to merge this information with the one from the survivalnf0209
 dataset, I need to create a var "folio" that is only active if the folio remains
 the same in 2002 and 2009:*/

rename folio2009 origfolio2009

g folio2009=substr(origfolio2009,1,6)+substr(origfolio2009,9,2)
 
g folio=folio2009 if test==folio2009
				
*TO DO: change path to where you saved the following file "survivalnf0209.dta"
/*EXAMPLE:	*/			
merge m:1 folio using survivalnf0209, nogenerate keep(1 3)	
/**/

/*In order to be able to merge this information with the one from the survivalnf0509
 dataset, I need to create a var "folio" that is only active if the folio remains
 the same in 2005 and 2009:*/
drop folio
g folio=folio2009 if folio2005==folio2009

*TO DO: change path to where you saved the following file "survivalnf0509.dta"
/*EXAMPLE:*/	
merge m:1 folio using survivalnf0509, nogenerate keep(1 3)
/**/

drop  folio

*TO DO: decide whether you need/want to change path for saving MXFLS_master
/**/
save MXFLS_master, replace
/**/

*keep only obs. from years 2005 and 2009 and 2010:
rename interviewmonth2005_07 interviewmonth2005
rename interviewmonth2009_13 interviewmonth2009
foreach x in 2002 2005 2009{
gen date`x' = dofm(interviewmonth`x')
gen ivyear`x'=year(date`x')
}
drop date*

drop if ivyear2005==2006 | ivyear2005==2007 | ivyear2009==2011 | ivyear2009==2012 | ivyear2009==2013

*TO DO: decide whether you need/want to change path for saving MXFLS_master
/**/
save MXFLS_master, replace
/**/

********************************************************************************
*Cleaning it up:
********************************************************************************
*Keep if the household operated a household in at least one of the three rounds
keep if hhbus2002==1 |  hhbus2005==1 | hhbus2009==1 

*Drop if the household operated more than one business in any of the three rounds:
drop if tbdropped2002==1 | tbdropped2005==1 | tbdropped2009==1

*Keep the business owners:
keep if businessowner2002==1 |  businessowner2005==1 | businessowner2009==1 

/*Replace missings for businessowners if the household is not operating a household
 business in that round:*/
foreach x in 2002 2005 2009{
replace businessowner`x'=0 if hhbus`x'==0 & businessowner`x'==.
}

/*Flag if businesses are jointly operated and appear more than once, since they appear
with different owners*/

foreach x in 2002 2005 2009{
duplicates tag folio`x' businessowner`x' agefirm`x' x_agefirm`x' employees`x' profits`x' sales`x' if hhbus`x'==1, gen(totalowners`x')

replace totalowners`x'=totalowners`x'+1

g jointbus`x'=(totalowners`x'>1) if hhbus`x'==1
}

*Generate a joint survival variable for survival from round 1 to round 3
rename survival0209 survival2009

*TO DO: decide whether you need/want to change path for saving MXFLS_master
/**/
save MXFLS_master, replace
/**/

*Identify the individual businesses
keep folio2002 folio2005 folio2009 origfolio2009
duplicates drop

*TO DO: decide whether you need/want to change path for saving helpMXFLS_master
/**/
save helpMXFLS_master, replace
/**/

g strfolio2002=string(folio2002, "%08.0f")

g splitoff2005=0 if strfolio2002==folio2005 & strfolio2002!="" & folio2005!=""
replace splitoff2005=1 if strfolio2002!=folio2005 & strfolio2002!="" & folio2005!=""

g splitoff2009=0 if  folio2005==folio2009 & folio2005!="" & folio2009!=""
replace splitoff2009=1 if folio2005!=folio2009 & folio2005!="" & folio2009!=""

*TO DO: change path to where you saved the following file "MXFLS_master.dta"
/*EXAMPLE:*/
merge 1:m folio2002 folio2005 folio2009 using MXFLS_master, nogenerate
/**/

*Replace values of previous waves to missing if household is a splitoff household
ds *2002, has(type numeric)
foreach var of varlist `r(varlist)' {
replace `var'=. if splitoff2005==1 | splitoff2009==1
}
ds *2002, not(type numeric) 
foreach var of varlist `r(varlist)'{
replace `var'="" if splitoff2005==1 | splitoff2009==1
}


*Replace values if previous waves to missing if household is a splitoff household
ds *2005, has(type numeric)
foreach var of varlist `r(varlist)' {
replace `var'=. if splitoff2009==1
}

ds *2005, not(type numeric) 
foreach var of varlist `r(varlist)'{
replace `var'="" if splitoff2009==1
}


*Generate firm (and owner) identification number in survey
*Firm identification

egen help2002=group(folio2002 agefirm2002 x_agefirm2002 employees2002 profits2002 sales2002) if hhbus2002==1, missing
egen help2005=group(folio2005 agefirm2005 x_agefirm2005 employees2005 profits2005 sales2005) if hhbus2005==1, missing
egen help2009=group(folio2009 agefirm2009 x_agefirm2009 employees2009 profits2009 sales2009) if hhbus2009==1, missing
egen help=group(help2002 help2005 help2009), m

*Create a variable for inclusion of jointly operated businesses only once:

*For business operated by only one hh_member (1221 obs.):
duplicates tag help, gen(dupl_hhfirm)
g incl=1 if dupl_hhfirm==0


g female=female2002
replace female=female2005 if female==. & female2005!=.
replace female=female2009 if female==. & female2009!=.

drop female2*

/*Given that there are jointly owned firms, I create a new variable,
 that has three categories: male (base category), female and jointly operated*/
foreach x in 2002 2005 2009{
g mfj`x'=female if jointbus`x'==0
replace mfj`x'=2 if jointbus`x'==1
}

*TO DO: decide whether you need/want to change path for MXFLS_master
/**/
save MXFLS_master, replace
/**/

drop splitoff2005 splitoff2009 origfolio2009 strfolio2002 splitoff2005 splitoff2009 ls2002 ls09 hhbus_worker2002 bc_reh2002 bc_rel2002 b1_rel2002 b2_rel2002 b3a_rel2002 bea_rel2002 tbdropped* ls2005 bc_reh2005-bea_rel2005 resp_bo spouse_bo merge1 test ls2009 bc_reh2009-bea_rel2009 merge2 ivyear* interviewmonth* tbdropped* merge* help* hhbus_worker*
destring folio2005 folio2009, replace
egen hhid=rowmax(folio2002-folio2009)
drop folio2002-folio2009


quietly: reshape long wave surveyyear ownerage familyill ownerill married ownertertiary educyears childunder5 childaged5to12 adult65andover raven pcexpend excrate excratemonth selfemployed hours hoursnormal wageworker laborincome retired hhbus agefirm x_agefirm employees sales profits jointbus dead mfj, i(hhid pid_link) j(survey)

			
*keep if household operates a business in any round
keep if hhbus==1


*keep the businessowners:

keep if businessowner2002==1 | businessowner2005==1 | businessowner2009==1

*keep if firm has an owner in the sample
foreach x in businessowner2002 businessowner2005 businessowner2009{
bysort hhid: egen total`x'=total(`x')
}

g test=0
foreach x in 2002 2005 2009{
replace test=1 if surveyyear==`x' & totalbusinessowner`x'>=1
}

drop if test==0
drop test


*3 years		
g attrit_3yrs=.
g survival_3yrs=.
g newfirmstarted_3yrs=.


foreach x in attrit survival newfirmstarted{
replace `x'_3yrs=`x'2005 if surveyyear==2002
drop `x'2005
}

*4.5 years
g attrit_4p5yrs=.
g survival_4p5yrs=.
g newfirmstarted_4p5yrs=.


foreach x in attrit survival newfirmstarted{
replace `x'_4p5yrs=`x'0509 if surveyyear==2005
drop `x'0509
}

rename newfirmstarted0209 newfirmstarted2009

*7.5 years		
g attrit_7p5yrs=.
g survival_7p5yrs=.
g newfirmstarted_7p5yrs=.


foreach x in attrit survival newfirmstarted{
replace `x'_7p5yrs=`x'2009 if surveyyear==2002
drop `x'2009
}

*For creation of hhfirmids and inconsistency checks

sort hhid surveyyear
bysort hhid: egen help1=min(surveyyear)
order surveyyear help1, after(survey)
g help21=surveyyear-help1
order help21, after(help1)

g help1_1=newfirmstarted_3yrs if help21==0 & surveyyear==2002
replace help1_1=newfirmstarted_4p5yrs if help21==0 & surveyyear==2005

g help1_2=newfirmstarted_7p5yrs if help21==0 & surveyyear==2002
order help1_2, after(help1_1)

replace help21=1 if help21==3 & surveyyear==2005 & help1==2002
replace help21=1 if help21==4 & surveyyear==2009 & help1==2005
replace help21=2 if help21==7

forvalues i=1/2{
bysort hhid: egen help21_`i'=total(help1_`i'), m
}

g sameaszero1=1 if help21==0
forvalues i=1/2{
replace sameaszero1=1 if help21==`i' & help21_`i'==0
replace sameaszero1=0 if help21==`i' & help21_`i'>=1 & help21_`i'!=.
}

local i=2
local j=`i'-1
sort hhid surveyyear
bysort hhid: egen help`i'=min(surveyyear) if help2`j'!=0 & help2`j'!=.
g help2`i'=surveyyear-help`i'


g help2_1=newfirmstarted_4p5yrs if help22==0 & surveyyear==2005

g help2_2=.

local i=2
forvalues k=1/2{
bysort hhid: egen help2`i'_`k'=total(help`i'_`k'), m
}

replace help22=1 if help22==4

local i=2
g sameaszero`i'=1 if help2`i'==0
forvalues k=1/2{
replace sameaszero`i'=1 if help2`i'==`k' & help2`i'_`k'==0
replace sameaszero`i'=0 if help2`i'==`k' & help2`i'_`k'>=1 & help2`i'_`k'!=.
}


*Check for inconsistencies:

g period_1=1 if help21==0
local i=2
g period_`i'=`i' if help2`i'==0


g period_3=3 if surveyyear==2009 & period_1==. & period_2==.

egen period=rowtotal(period_1-period_3),m
order period, after(pid_link)
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
local i=2
egen helpcheck=rowmiss(sameaszero`i') if period>=`i'
bysort hhid: egen helpcheck2=total(helpcheck) if period>=`i'
replace check=1 if helpcheck2>0 & helpcheck2!=. & period>=`i'
drop helpcheck helpcheck2

*TO DO: decide whether you need/want to change path for MXFLS_masterfc
/**/
save MXFLS_masterfc, replace
/**/

*For check=1
*If for the period survival has been coded -> this will determine sameaszero
tab survival_3yrs help1_1 if maxperiod==3 & surveyyear==2002, m
tab survival_7p5yrs help1_2 if maxperiod==3 & surveyyear==2002, m
tab survival_4p5yrs help2_1 if maxperiod==3 & period==2 & surveyyear==2005, m


tab survival_3yrs help1_1 if maxperiod==2 & surveyyear==2002, m
tab survival_4p5yrs help1_1 if maxperiod==2 & period==1 & surveyyear==2005, m

*There are no such cases!

order sameaszero1 sameaszero2, after(surveyyear)


*Rules
*If firm in t+1 or t+2 younger than t+x - t -> newfirmstarted
g minsvy=help1
bysort hhid: egen maxsvy=max(surveyyear)

g hlpnf0205=1 if maxperiod==3 & period==2 & surveyyear==2005 & agefirm<3 & sameaszero1==.
replace hlpnf0205=1 if maxperiod==2 & period==2 & surveyyear==2005 & agefirm<3 & sameaszero1==.
g hlpnf0209=1 if maxperiod==3 & period==3 & surveyyear==2009 & agefirm<7.5 &  sameaszero1==.
replace hlpnf0209=1 if maxperiod==2 & period==2 & surveyyear==2009 & minsvy==2002 & agefirm<7.5 & sameaszero1==.
g hlpnf0509=1 if maxperiod==2 & period==2 & surveyyear==2009 & minsvy==2005 & agefirm<4.5 & sameaszero1==.
replace hlpnf0509=1 if maxperiod==3 & period==2 & surveyyear==2005 & agefirm<4.5 &  sameaszero2==.

foreach x in nf0205 nf0209 nf0509{
bysort hhid: egen `x'=total(hlp`x')
replace `x'=(`x' >= 1) if `x'!=.
}

replace sameaszero1=0 if sameaszero1==. & maxperiod==3 & period==2 & surveyyear==2005 & agefirm<3 & nf0205==1
replace newfirmstarted_3yrs=1 if  newfirmstarted_3yrs!=1 & maxperiod==3 & period==1 & surveyyear==2002 & nf0205==1
replace sameaszero1=0 if sameaszero1==. & maxperiod==2 & period==2 & surveyyear==2005 & agefirm<3 & nf0205==1
replace newfirmstarted_3yrs=1 if  newfirmstarted_3yrs!=1 & maxperiod==2 & period==1 & surveyyear==2002 & nf0205==1
replace sameaszero1=0 if sameaszero1==. & maxperiod==3 & period==3 & surveyyear==2009 & agefirm<7.5 & nf0209==1
replace newfirmstarted_7p5yrs=1 if newfirmstarted_7p5yrs!=1 & maxperiod==3 & period==1 & surveyyear==2002 & nf0209==1
replace sameaszero1=0 if sameaszero1==. & maxperiod==2 & period==2 & surveyyear==2009 & minsvy==2002  & agefirm<7.5 & nf0209==1
replace newfirmstarted_7p5yrs=1 if newfirmstarted_7p5yrs!=1 & maxperiod==2 & period==1 & surveyyear==2002 & minsvy==2002 & nf0209==1
replace sameaszero1=0 if sameaszero1==. & maxperiod==2 & period==2 & surveyyear==2009 & agefirm<4.5 & nf0509==1
replace newfirmstarted_4p5yrs=1 if newfirmstarted_4p5yrs!=1 & maxperiod==2 & period==1 & surveyyear==2005 & nf0509==1
replace sameaszero2=0 if sameaszero2==. & maxperiod==3 & period==3 & surveyyear==2009 & agefirm<4.5 & nf0509==1
replace newfirmstarted_4p5yrs=1 if newfirmstarted_4p5yrs!=1 & maxperiod==3 & period==2 & surveyyear==2005 & nf0509==1

*There are still 78 obs. with sameaszero1==.
*Out of these, 62 obs. have sameaszero1=. because agefirm==. 

*I drop them if they have missings in age, since this is important in determining survival or newfirmstart
g hlptbdropped=(sameaszero1==. & agefirm==.)
bysort hhid: egen tbdropped=max(hlptbdropped)
drop if tbdropped==1
drop tbdropped

egen test=group(hhid) if sameaszero1==. & agefirm!=.

* 16 obs. / 9 hhids have sameaszero1==. due to other reasons, such as sector and/or owner changes

order agefirm businessowner2002 businessowner2005 businessowner2009, after(sameaszero2)

*-> code them manually
*hhid=757000 -> same firm
local hhid=757000 
replace sameaszero1=1 if hhid==`hhid' & surveyyear==2009
replace newfirmstarted_7p5yrs=0 if hhid==`hhid' & surveyyear==2002
replace survival_7p5yrs=1 if hhid==`hhid' & surveyyear==2002

*hhid=767000 -> code as new firm in 2005
local hhid=767000
replace sameaszero1=0 if hhid==`hhid' & surveyyear==2005
replace newfirmstarted_3yrs=0 if hhid==`hhid' & surveyyear==2002
replace survival_3yrs=1 if hhid==`hhid' & surveyyear==2002

*hhid=969000 -> code as two diff business since ages don't coincide and owners also don't
local hhid=969000
replace sameaszero1=0 if hhid==`hhid' & surveyyear==2005

*hhid=5523006 -> code as same firm
local hhid=5523006
replace sameaszero1=1 if hhid==`hhid' & surveyyear==2009
replace newfirmstarted_4p5yrs=0 if hhid==`hhid' & surveyyear==2005
replace survival_4p5yrs=1 if hhid==`hhid' & surveyyear==2005

*hhid=5754000 -> might be temp closure -> I code it as a new firm in 2009
local hhid=5754000
replace sameaszero1=0 if hhid==`hhid' & surveyyear==2009
replace newfirmstarted_7p5yrs=1 if hhid==`hhid' & surveyyear==2002
replace survival_7p5yrs=0 if hhid==`hhid' & surveyyear==2002

*hhid=7460000  -> code as two diff business since ages don't coincide and owners also don't
local hhid=7460000 
replace sameaszero1=0 if hhid==`hhid' & surveyyear==2005

*hhid=7692000 -> might be temp closure -> I code it as a new firm in 2009
local hhid=7460000 
replace sameaszero1=0 if hhid==`hhid' & surveyyear==2009
replace newfirmstarted_7p5yrs=1 if hhid==`hhid' & surveyyear==2002
replace survival_7p5yrs=0 if hhid==`hhid' & surveyyear==2002

*hhid=8530000 -> same firm
local hhid=8530000
replace sameaszero1=1 if hhid==`hhid' & surveyyear==2009
replace newfirmstarted_7p5yrs=0 if hhid==`hhid' & surveyyear==2002
replace survival_7p5yrs=1 if hhid==`hhid' & surveyyear==2002

*hhid=9969001 -> might be temp closure -> I code it as a new firm in 2009
local hhid=9969001
replace sameaszero1=0 if hhid==`hhid' & surveyyear==2009
replace newfirmstarted_7p5yrs=1 if hhid==`hhid' & surveyyear==2002
replace survival_7p5yrs=0 if hhid==`hhid' & surveyyear==2002

*TO DO: decide whether you need/want to change path for MXFLS_masterfc
/**/
save MXFLS_masterfc, replace
/**/

*In case there is a switch from being same firm to different and then to same firm again
forvalues i=1/2{
bysort hhid: egen helpcheck=total(sameaszero`i'/(dupl+1))
g helpcheck2_`i'=1 if sameaszero`i'==0 & helpcheck>=(period-`i'+1)
drop helpcheck
}
egen rthelpcheck2=rowtotal(helpcheck2_1-helpcheck2_2),m
order rthelpcheck2, after(maxperiod)

tab rthelpcheck2
egen rthelpcheck3=anymatch(rthelpcheck2), values(1)
order rthelpcheck3, after(rthelpcheck2)

*bysort hhid:egen rthelpcheck4=max(rthelpcheck3)
*order rthelpcheck4, after(rthelpcheck3)

g check2=1 if rthelpcheck3==1

drop rthelpcheck* helpcheck2*

*3 obs. / 2 hhs
*hhid=8903000 -> code as same firm
local hhid=8903000
replace sameaszero1=1 if hhid==`hhid' & surveyyear==2005
replace newfirmstarted_3yrs=0 if hhid==`hhid' & surveyyear==2002
replace survival_3yrs=1 if hhid==`hhid' & surveyyear==2002

*hhid=9971000 -> code as same firm
local hhid=9971000 
replace sameaszero1=1 if hhid==`hhid' & surveyyear==2005
replace newfirmstarted_3yrs=0 if hhid==`hhid' & surveyyear==2002
replace survival_3yrs=1 if hhid==`hhid' & surveyyear==2002

*TO DO: decide whether you need/want to change path for MXFLS_masterfc
/**/
save MXFLS_masterfc, replace
/**/

*For inconsistencies over different time horizons depending on the baseline year but with the follow-up year being constant
*- maxperiod needs to be larger than 2 (for 1 and 2 periods there cannot be inconsistencies with implications for coding of the hhfirm)
forvalues i=1/2{
bysort hhid: egen newhelpcheck`i'=total(sameaszero`i'/(dupl+1))
}
g newhelpcheck=0
local i=3
local j=`i'-1
local k=`i'-2
replace newhelpcheck=1 if newhelpcheck`k'==newhelpcheck`j' & sameaszero`k'<sameaszero`j' & sameaszero`k'!=. & newhelpcheck`k'!=1 & sameaszero`j'!=. & newhelpcheck`j'!=1 & period>=`i'

bysort hhid: egen maxnewhelpcheck=max(newhelpcheck)

*18 obs./ 3 households

*hhid=2246000 -> same firm
*hhid=4334000 -> same firm
*hhid=5690000 -> code as same firm

foreach x in 2246000 4334000 5690000{
local hhid=`x'
replace sameaszero1=1 if hhid==`hhid' & surveyyear==2009
replace newfirmstarted_7p5yrs=0 if hhid==`hhid' & surveyyear==2002
replace survival_7p5yrs=1 if hhid==`hhid' & surveyyear==2002
}

*TO DO: decide whether you need/want to change path for MXFLS_masterfc
/**/
save MXFLS_masterfc, replace
/**/

*Generate firmid for the clear cases 
sort hhid surveyyear
egen helphhfirmid1=group(hhid sameaszero1) if sameaszero1==1
local i=2
local j=`i'-1
egen helphhfirmid`i'=group(hhid sameaszero`i') if sameaszero`j'==0 & sameaszero`i'==1


egen hhfirmid=group(hhid helphhfirmid1-helphhfirmid2), m
order hhfirmid, after(pid_link)

*TO DO: decide whether you need/want to change path for MXFLS_masterfc
/**/
save MXFLS_masterfc, replace
/**/

*Now decide on the owner - depending on the years in which the same hhfirmid is reported
keep if incl!=1
keep hhid pid_link hhfirmid totaldupl surveyyear businessowner* 

g hlpsvyear1=surveyyear

reshape wide hlpsvyear1, i(hhid pid_link hhfirmid) j(surveyyear)

foreach i in 2002 2005 2009{
replace hlpsvyear1`i'=(hlpsvyear1`i'!=.)
replace businessowner`i'=businessowner`i'*hlpsvyear1`i'
}
egen totalownership=rowtotal(businessowner2002-businessowner2009)
bysort hhfirmid: egen maxtotalownership=max(totalownership)
g hlpincl=(maxtotalownership==totalownership)
duplicates tag hhfirmid hlpincl, gen(duplhlpincl)
g incl=.
*In case there are no duplicates in maximum ownership
replace incl=(hlpincl==1) if duplhlpincl==0
bysort hhfirmid: egen helpinclonemaxo=total(incl)
replace incl=0 if incl==. & helpinclonemaxo==1

*duplicates in terms of owner/person:
duplicates tag hhid pid_link, gen(duplperson)


*If person only appears once, choose owner with the lowest hc_id (this will choose the household head if he/she is among the owners)
bysort hhfirmid: egen testincl=total(incl)
bysort hhfirmid: egen totalduplperson=total(duplperson)
sort hhfirmid hhid pid_link
g pid=substr(pid_link, 7 ,4)
destring pid, replace
bysort hhfirmid: egen minhc_id=min(pid) if duplhlpincl>0 &  duplhlpincl!=.
g helpminhc_id=(minhc_id==pid)
replace incl=(helpminhc_id==1) if duplhlpincl>0 &  duplhlpincl!=. & duplperson==0 & totalduplperson==0 & test!=1
drop test

*If person appears more than once, is already included for another business and is one of the persons with maximum ownership, I choose this owner
bysort hhfirmid: egen testincl=total(incl)
g helpmultfirms=pid if duplperson>0 & duplperson!=. & incl==1 
*depends on the number included of firms per household
bysort hhid: egen counthelpmultfirms=count(helpmultfirms)
bysort hhid: egen totalhelpmultfirms=total(helpmultfirms) if count==1
replace incl=1 if hlpincl==1 & pid==totalhelpmultfirms & duplperson>0 & duplperson!=. & incl==. & count==1 & test!=1
drop test

*If there are more than one firm per household included, but maxowner is the same for all of them:
bysort hhfirmid: egen testincl=total(incl)
egen helphelpmultfirms=group(hhid helpmultfirms) if count>1 & count!=.
bysort hhid: egen mdevhelphelpmultfirms=mdev(helphelpmultfirms) if count>1 & count!=.
bysort hhid: egen totalhelpmultfirms2=total(helpmultfirms) if count>1 & count!=. & mdevhelphelpmultfirms==0
replace totalhelpmultfirms2=totalhelpmultfirms2/count if count>1 & count!=. & mdevhelphelpmultfirms==0
replace incl=1 if hlpincl==1 & pid==totalhelpmultfirms2 & duplperson>0 & duplperson!=. & incl==. & count>1 & count!=1 & test!=1
drop testincl

bysort hhfirmid: egen testincl=total(incl)

*I replace incl=0 if incl=. but testincl==1:
replace incl=0 if incl==. & testincl==1

*Otherwise I choose person with maximum ownership 
replace incl=(hlpincl==1) if duplhlpincl==0 & incl==.

*And if more than one have maximum ownership for the same business, I choose the one with the lowest hc_id
bysort hhfirmid: egen newminhc_id=min(pid) if incl==.
g newhelpminhc_id=(newminhc_id==pid) if incl==.
replace incl=(newhelpminhc_id==1) if incl==. 

*I check if all household firms are included:
drop test
bysort hhfirmid: egen testincl=total(incl)
tab test

keep hhid pid_link hhfirmid incl hlpsvyear12002-hlpsvyear12009

reshape long hlpsvyear1, i(hhid pid_link hhfirmid) j(surveyyear)
keep if hlpsvyear1==1
drop hlpsvyear1

*TO DO: decide whether you need/want to change path for MXFLS_masterfchlp
/**/
save MXFLS_masterfchlp, replace
/**/

*TO DO: change path to where you saved the following file "MXFLS_masterfc.dta"
/*EXAMPLE:*/
use MXFLS_masterfc, clear
/**/

*TO DO: change path to where you saved the following file "MXFLS_masterfchlp.dta"
/*EXAMPLE:*/
merge 1:1 hhid pid_link hhfirmid surveyyear using MXFLS_masterfchlp, update
/**/

*TO DO: decide whether you need/want to change path for MXFLS_masterfc
/**/
save MXFLS_masterfc,replace
/**/

*test if for a given household owners change depending on hhfirmid
g pid=substr(pid_link, 7 ,4)
destring pid, replace
bysort hhid: egen mdevhc_id=mdev(pid) if incl==1
tab mdevhc_id
*-> there are about 3% of households in the sample for which firm owners change depending on hhfirmid 
* only in these cases, newfirmstarted might have been calculated imperfectly

keep if incl==1

*Generate owner id, since, if the same owner opens a new firm, that should be accounted for:
egen ownerid=group(hhid pid)

*Household id: a household appears multiple times with different businesses if the businesses are either new and old ones or if they are different businesses
egen householdid=group(hhid)

tostring survey, replace
replace survey="BL-"+survey if survey=="2002"
replace survey="R-"+survey if survey!="BL-2002" & survey!="2009"
replace survey="L-"+survey if survey=="2005"

g lastround=(surveyyear==2009)


drop businessowner* sameaszero* period* maxperiod minsvy* newhelpcheck* newhelpcheck maxnewhelpcheck helphhfirmid* _merge mdevhc_id help* dupl totaldupl incl check maxsvy totalowners* dupl_hhfirm totalbusinessowner* hlpnf* nf* hlptbdropped test check2
                                         
*Make the ids look nicer
foreach x of varlist hhfirmid ownerid householdid{
tostring `x', format("%04.0f") replace
replace `x'="MXFLS"+"-"+`x'
}

rename hhfirmid firmid

*If a firm is coded to be dead once, it should be so for all subsequent periods too:
replace survival_7p5yrs=0 if survival_3yrs==0 & survival_7p5yrs==. & surveyyear==2002

*TO DO: Make sure the final dataset "MXFLS_masterfc.dta" is saved in the folder “Do-files and readme/Construction of Dataset/Data for combination”
/**/
save MXFLS_masterfc,replace
/**/

