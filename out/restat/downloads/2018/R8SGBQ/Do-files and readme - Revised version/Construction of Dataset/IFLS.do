********************************************************************************

********************************************************************************
**THIS DO-FILE PREPARES THE DATA FROM THE INDONESIAN FAMILY LIFE SURVEY FOR COMBINATION INTO THE MASTER DATASET
**Small Firm Death in Developing Countries
**March 13, 2018
**David McKenzie (dmckenzie@worldbank.org) and Anna Luisa Paffhausen (apaffhausen@worldbank.org)
**The analysis was performed with Stata, version 14.2

*Notes:
* The underlying raw data needed to replicate this do-file is made available by the RAND Corporation.
* To replicate this do-file:
* 1) Go to https://www.rand.org/labor/FLS/IFLS/download.html
* 2) Download the following data folders for IFLS rounds 3-5 in Stata format: hh00_all_dta, hh07_all_dta, and hh14_all_dta
* 3) Change the directory in the do-file 
* 4) Change the paths to the data you are using and for saving the datasets that are created in this do-file
*    Make sure the final dataset "IFLS_masterfc" is saved in the folder “Do-files and readme/Construction of Dataset/Data for combination”
 	

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

*Start with the tracking file for households 1993-2014
clear
*TO DO: change path to where you saved the following file "hh14_all_dta/ptrack.dta"
/*EXAMPLE:*/
use "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/IFLS/Round 5/hh14_all_dta/ptrack.dta"
/**/
keep ar01a_14 ar02_14 sex hhid14 pid14 pidlink hhid07 ar02b_14 ar01b_14 ar01i_14 ar01a_07 ar02_07 ar01b_07 ar02b_07 ar01i_07 pid07 hhid00 pid00 ar01a_00 ar02b_00 ar01b_00 ar01i_00 age_00 res00b3a res00b3b res00b3p res00b4 res00b5 res00us res00ek res97us res97ekm res97ekb member00 hhid93 pid93 hhid97 pid97 case member93 member97 age_93 age_97 ar02_93 ar01a_97 ar01b_97 ar02_97 res93b3 res93b4 res93b5 res93us res97b3a res97b3b res97b3p res97b4 res97b5 hhid98 pid98 member98 member07 bg_dob age_07 bth_month res07b3a res07b3b res07b4 cov8b5 res07b5 res07us res07bek1 res07bek2 died07 contactalive07 res07bp mainresp07 measured07 mnresp93970007 msured93970007 member14 age_14 bth_day bth_year res14b3a res14b3b res14b4 res14b5 res14us res14bek

drop case *93 *97 *98 *93* *97*

*TO DO: decide whether you need/want to change path for saving IFLS_3-5
/**/
save IFLS_3-5, replace
/**/ 

*Round 3 - 2000:
clear
*TO DO: change path to where you saved the following file "hh00dta/htrack.dta"
/*EXAMPLE:*/
use "IFLS/Round 3/hh00dta/htrack.dta"
/**/
keep hhid00 result00 res00*
drop if hhid00==""

*TO DO: change path to where you saved the following file "IFLS_3-5"
/*EXAMPLE:*/
merge 1:m hhid00 using IFLS_3-5, nogenerate keep(2 3)  
/**/

*TO DO: decide whether you need/want to change path for saving IFLS_3-5
/**/
save IFLS_3-5, replace
/**/ 

*Round 4 - 2007:
clear
*TO DO: change path to where you saved the following file "hh07_all_dta/htrack.dta"
/*EXAMPLE:*/
use "IFLS/Round 4/hh07_all_dta/htrack.dta"
/**/
keep hhid07 result07 res07*
drop if hhid07==""

*TO DO: change path to where you saved the following file "IFLS_3-5"
/*EXAMPLE:*/
merge 1:m hhid07 using IFLS_3-5, nogenerate keep(2 3) force
/**/

*TO DO: decide whether you need/want to change path for saving IFLS_3-5
/**/
save IFLS_3-5, replace
/**/ 
*Round 5 - 2014:
clear
*TO DO: change path to where you saved the following file "hh14_all_dta/htrack.dta"
/*EXAMPLE:*/
use "IFLS/Round 5/hh14_all_dta/htrack.dta"
/**/
keep hhid14 result14 res14*
drop if hhid14==""

*TO DO: change path to where you saved the following file "IFLS_3-5"
/*EXAMPLE:*/
merge 1:m hhid14 using IFLS_3-5, nogenerate keep(2 3)
/**/

# delimit ;
order	hhid00 hhid07 hhid14
		res00b1 res00b2 res00bk
		res07b1 res07b2 res07bk
		res14b1 res14b2 res14bk;
# delimit cr

/*Since I'm only interested in those households that were in the sample in round 3
 (which will be my baseline), I drop all observations that have missings for hhid00 
 and pid00:*/
 
drop if hhid00=="" & pid00==. 

/*There are still two duplicates in pidlink, which I drop (the individuals concerned 
are also very young so they should not matter for the household business (owner) sample)*/
duplicates tag pidlink, gen(dupl)

drop if dupl>0

drop dupl

*TO DO: decide whether you need/want to change path for saving IFLS_3-5
/**/
save IFLS_3-5, replace
/**/ 

********************************************************************************

********************************************************************************
*Baseline variables
********************************************************************************

********************************************************************************

*Country
g country="Indonesia"

********************************************************************************
*Owner and Household characteristics
********************************************************************************


*Variables already in the ptrack or htrack files

*Gender of owner
g female=(sex==3)
replace female=. if sex==.

*Age of owner
g ownerage2000=age_00
g ownerage2007=age_07
g ownerage2014=age_14

*TO DO: decide whether you need/want to change path for saving IFLS_3-5
/**/
save IFLS_3-5, replace
/**/ 

*Variables from Round 3
clear
*TO DO: change path to where you saved the following file "hh00dta/bk_ar1.dta"
/*EXAMPLE:*/
use "IFLS/Round 3/hh00dta/bk_ar1.dta"
/**/

*Since there are a couple of nonintegers in age (most for infants under 1):
replace ar09=floor(ar09)

replacetomissings ar09

*Child under 5 in household
g under5=0
replace under5=. if ar09==. 
replace under5=1 if ar09<5 
bysort hhid: egen childunder5=max(under5)
drop under5

*Child aged 5 to 12 in household
g aged5to12=0
replace aged5to12=. if ar09==. 
replace aged5to12=1 if ar09>=5 & ar09<12
bysort hhid: egen childaged5to12=max(aged5to12)
drop aged5to12

*Has adult aged 65+ in the household
g is65orover=0
replace is65orover=. if ar09==. 
replace is65orover=1 if ar09>=65 & ar09!=. 
bysort hhid: egen adult65andover=max(is65orover)
drop is65orover

*Marital status of owner
g married=(ar13==2)
replace married=. if ar13==.

*Education of owner
replacetomissings ar16
g ownertertiary=(ar16==9| ar16==60 | ar16==61 | ar16==62 | ar16==63)
replace ownertertiary=. if ar16==.

replacetomissings ar17
*Years of education
*None
g educyears=0 if (ar16==1 | ar16==90)
*Elementary School
replace educyears=ar17 if (ar16==2 | ar16==72)
replace educyears=6 if ar17==7 & (ar16==2 | ar16==72)
*Junior High
replace educyears=ar17+6 if (ar16==3 | ar16==4 | ar16==73)
replace educyears=3+6 if ar17==7 & (ar16==3 | ar16==4 | ar16==73)
*High School
replace educyears=ar17+9 if (ar16==5 | ar16==6 | ar16==74)
replace educyears=3+9 if ar17==7 & (ar16==5 | ar16==6 | ar16==74)
*Tertiary education
replace educyears=ar17+12 if (ar16==60 | ar16==61)
replace educyears=4+12 if ar17==7 & (ar16==60 | ar16==61)
replace educyears=ar17+16 if (ar16==62)
replace educyears=2+16 if ar17==7 & (ar16==62)
replace educyears=ar17+18 if (ar16==63)
replace educyears=3+16 if ar17==7 & (ar16==63)

*I did not consider: Adult Education A (11), Adult Education B (12), 13 Open University (13), Islamic School (14), School for the Disabled (17), Madrasah (70), Other (10)

*Sources:	https://www.nuffic.nl/en/publications/find-a-publication/education-system-indonesia.pdf
*			https://en.wikipedia.org/wiki/Education_in_Indonesia

keep hhid00 pid00 childunder5-educyears

*TO DO: change path to where you saved the following file "IFLS_3-5.dta"
/*EXAMPLE:*/
merge 1:m hhid00 pid00 using IFLS_3-5, keep(2 3) nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving IFLS_3-5
/**/
save IFLS_3-5, replace
/**/

clear
*TO DO: change path to where you saved the following file "hh00dta/bek.dta""
/*EXAMPLE:*/
use "IFLS/Round 3/hh00dta/bek.dta"
/**/

*Raven progressive matrices score
*I compute the score as the percentage of correct answers for questions ek01-ek12
foreach var of varlist ek1x-ek12x{
replace `var'=(`var'==1) if `var'!=9
replace `var'=. if `var'==9
}

egen raven=rowtotal(ek1x-ek12x),m
replace raven=raven/12

keep pidlink raven

*TO DO: change path to where you saved the following file "IFLS_3-5.dta"
/*EXAMPLE:*/
merge 1:1 pidlink using IFLS_3-5, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving IFLS_3-5
/**/
save IFLS_3-5, replace
/**/

*Family member ill
clear
*TO DO: change path to where you saved the following file "hh00dta/b2_cov.dta"
/*EXAMPLE:*/
use "IFLS/Round 3/hh00dta/b2_cov.dta"
/**/
keep hhid00 ivwmth1

*TO DO: change path to where you saved the following file "hh00dta/b2_ge.dta"
/*EXAMPLE:*/
merge 1:m hhid00 using "IFLS/Round 3/hh00dta/b2_ge.dta", nogenerate keep(2 3)
/**/

keep if getype=="B"
g familyill=(ge01==1 & ge02yr==2000 & (ge02mth==ivwmth1 | ge02mth==ivwmth1-1))
replace familyill=. if ge01==9 | ge02mthx==8 | ge02mthx==9 | ge02yrx==.
keep hhid00 familyill

*TO DO: change path to where you saved the following file "IFLS_3-5"
/*EXAMPLE:*/
merge 1:m hhid00 using IFLS_3-5, keep(2 3) nogenerate
/**/


*TO DO: decide whether you need/want to change path for saving IFLS_3-5
/**/
save IFLS_3-5, replace
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
*Round 3
********************************************************************************


clear
*TO DO: change path to where you saved the following file "hh00dta/b2_cov.dta"
/*EXAMPLE:*/
use "IFLS/Round 3/hh00dta/b2_cov.dta"
/**/

*Survey round number
g wave=1

g surveyyear=2000

g help=string(ivwmth1)+"-2000"

g interviewmonth2000=monthly(help,"MY")

keep hhid00 wave surveyyear rspndnt hhid00 interviewmonth2000

*TO DO: change path to where you saved the following file "hh00dta/b2_nt1.dta"
/*EXAMPLE:*/
merge 1:1 hhid00 using "IFLS/Round 3/hh00dta/b2_nt1.dta", nogenerate
/**/

replace nt01a=0 if nt01==3

*Household operates a non-farm business
g hhbus=(nt01==1) & nt01!=.
drop nt01

*Survival
*later

keep hhid00 rspndnt hhid00 wave surveyyear interviewmonth2000 hhbus nt01a

*TO DO: change path to where you saved the following file "hh00dta/b2_nt2.dta"
/*EXAMPLE:*/
merge 1:m hhid00 using "IFLS/Round 3/hh00dta/b2_nt2.dta", nogenerate
/**/

*Household entirely owns non-farm business
g enf_bus=(nt02==1) if nt02!=.

g tbdropped3=(nt01a>1) if nt01a!=. | enf_bus!=1

/*Since the data is in long format in case a hh operates more than one business I drop
 duplicates in folio tbdropped to be able to merge the 2000 with data at the individual
 level and the 2007 data later
*/
duplicates drop hhid00 tbdropped, force

g help=string(nt15mth)+"-"+string(nt15yr)
g startofbus=monthly(help,"MY")
replace startofbus=yearly(string(nt15yr),"Y") if nt15mtx==8 | nt15mtx==9 | nt15mth==.

g agefirm=(interviewmonth2000-startofbus)/12
/*Although the interviews were conducted in fall 2000, I use 2000.00 as the interviewdate
 for the yearly start dates of the businesses, as I don't know when they started in the
 start year and hence are treating all as if they had started in January of that year.*/
replace agefirm=(2000-startofbus) if nt15mtx==8 | nt15mtx==9 | nt15mth==.
g x_agefirm=.
replace x_agefirm=1 if nt15mtx==1
replace x_agefirm=0 if ( nt15mtx==8 | nt15mtx==9) | (nt15mth==. & nt15mtx==1)

g closeddown=(nt18==3)
replace closeddown=. if nt18==.

drop help

# delimit ;
label define fieldofbus
1 	"Agriculture,forestry,fishing,factory"
2	"Sales"
4	"Electricity,Gas and Water"
5	"Construction"
7	"Transportation and communication"
8	"Finance,insurance,real estate"  
21	"Restaurant, food store"
22	"Industrial: food"
23	"Industrial: garment"
24	"Industrial: other"
25	"Store: outside of food"
31	"Service: Government"       
32	"Service: Teacher"                            
33	"Service: Profesional staff"             
34	"Service: Transportation (becak, ojek, taxi)"
35	"Service: Other (tailor, salon)"
95	"Other";
# delimit cr


rename nt05c fieldofbus
label values fieldofbus fieldofbus 

*Capital stock
foreach x in a b c1 c4 h{
replace nt10`x'=. if nt10`x'x==5 | nt10`x'x==8 | nt10`x'x==9
}
egen capitalstock=rowtotal(nt10a nt10b nt10c1 nt10c4 nt10h), missing
replace capitalstock=. if nt10a==. | nt10b==. | nt10c1==. | nt10c4==. | nt10h==.

*Business sales in last month
g sales=.
replace sales=nt07 if  nt07x==1
*Since sales are given for past 12 months:
replace sales=sales/12
drop nt07 nt07x

*Business profits in last month
g profits=.
replace profits=nt09 if  nt09x==1 |  nt09x==3
*Since profits are given for past 12 months:
replace profits=profits/12
drop nt09 nt09x

*Business expenses in last month
g expenses=.
replace expenses=nt08 if  nt08x==1
*Since expenses are given for past 12 months:
replace expenses=expenses/12
drop nt08 nt08x

*Employment
g employees=.
replace employees=nt23 if nt23x==1

egen totalworkers=rowtotal(nt23 nt22), m
replace totalworkers=. if  nt23x==8 | nt22x==8 | nt23x==. | nt22x==. | nt23==. | nt22==.
drop nt23 nt23x nt22 nt22x

keep rspndnt hhid00 wave surveyyear interviewmonth nt01a hhbus nt05aa0 nt05ab nt15yr fieldofbus enf_bus-totalworkers

*TO DO: change path to where you saved the following file "hh00dta/bk_ar1.dta"
/*EXAMPLE:*/
merge 1:m hhid00 using "IFLS/Round 3/hh00dta/bk_ar1.dta", nogenerate keep(1 3)
/**/

/*Individuals that joined a new household appear twice in the dataset, so I drop them
 if they are coded as not living in the household anymore*/
drop if ar01a==3 


/*There are a still a couple of duplicates left, most of which have the person appearing
 in two households as dead. Since I cannot be sure to which household the person belongs
 in this case, I drop these duplicate observations*/
duplicates tag pidlink, gen(dupl_pidlink)
drop if dupl_pidlink>0 & (ar01a==0 | ar01a==6)

keep hhid00 wave surveyyear pid00 pidlink rspndnt interviewmonth nt01a hhbus nt05aa0 nt05ab nt15yr fieldofbus enf_bus-totalworkers

*Identify the businessowners
*nt05aa0 and nt05ab indicate the household members (pid00) who were primarily responsible for the business
g primarilyresponsible1=0 if hhbus==1
replace primarilyresponsible1=1 if nt05aa0==pid00 

g primarilyresponsible2=0 if hhbus==1
replace primarilyresponsible2=1 if nt05ab==pid00 

keep hhid00 wave surveyyear pid00 pidlink rspndnt hhid00 interviewmonth nt01a hhbus nt05aa0 nt05ab nt15yr fieldofbus enf_bus-primarilyresponsible2

*TO DO: decide whether you need/want to change path for saving IFLS3
/**/
save IFLS3, replace
/**/

clear
*TO DO: change path to where you saved the following file "hh00dta/b3a_tk2.dta"
/*EXAMPLE:*/
use "IFLS/Round 3/hh00dta/b3a_tk2.dta"
/**/
*TO DO: change path to where you saved the following file "hh00dta/b3p_tk2.dta"
/*EXAMPLE:*/
merge 1:1 hhid00 pid00 using "IFLS/Round 3/hh00dta/b3p_tk2.dta", update nogenerate
/**/
*TO DO: change path to where you saved the following file "hh00dta/b3a_tk1.dta"
/*EXAMPLE:*/
merge 1:1 hhid00 pid00 using "IFLS/Round 3/hh00dta/b3a_tk1.dta", nogenerate
/**/
*TO DO: change path to where you saved the following file "hh00dta/b3p_tk1.dta"
/*EXAMPLE:*/
merge 1:1 hhid00 pid00 using "IFLS/Round 3/hh00dta/b3p_tk1.dta", update nogenerate
/**/

/*
From codebook:
If the target respondent could not be interviewed after at least 3 attempts     
  to find him or her, a proxy respondent was asked to complete             
  a subset of the questions in Book 3.  Those questions are in             
  Book 3P.                                                                 
  IT IS IMPORTANT TO COMBINE INFORMATION IN BOOK 3 (A or B) WITH           
  THE PROXY INFORMATION IN BOOK 3P TO OBTAIN A COMPLETE SET OF             
  INDIVIDUAL RESPONSES.

There are 29 observations for pidlinks that appear in both, book A and the proxy book. 
I used the merge with the update option to keep the information from book A and enhance it only with
information from the proxy respondent if information on this variable was missing in book A, since
I assume that the information from the respondent itself will by more acurate.  
*/
  
/* value labels of tk24a
1	Self-employed
2	Self employed with HHmember assistant
3	Self-employed with employee/fixed work
4	Government worker
5	Private worker
6	Unpaid family worker
9	Missing 
*/


*Hours worked in self-employment in last month
g selfemployed=(tk24a==1 |tk24a==2 | tk24a==3) if (tk24a!=. | tk03!=9) & (tk24a!=. | tk03!=.) 


/*Since tk21a and tk22a have fractions, the program replacetomissings does not work‚ rightaway*/
	
foreach var of varlist tk21a tk22a tk25a1{
su `var', detail

}

foreach var of varlist tk21a tk22a tk25a1{
g help`var'=`var' if `var'== int(`var') & `var'x==1
replacetomissings help`var'
replace `var'=help`var' if `var'== int(`var') & `var'x==1
drop help`var'
}
	
	
g hours=tk21a*(30/7) if selfemployed==1
label var hours "based on hours worked during the past week"

g hoursnormal=tk22a*(30/7) if selfemployed==1
label var hoursnormal "based on hours worked during a normal week"

*Worked as wage worker in last month
g wageworker=(tk24a==4 | tk24a==5) if (tk24a!=. | tk03!=9) & (tk24a!=. | tk03!=.) 

*Labor earnings in last month
g laborincome=wageworker*tk25a1


*Retired
g retired=(tk01==5)
replace retired=. if tk01==99

keep hhid00 pid00 selfemployed hours* wageworker laborincome retired

*TO DO: change path to where you saved the following file "IFLS3.dta"
/*EXAMPLE:*/
merge 1:1 hhid00 pid00 using IFLS3, nogenerate 
/**/


*TO DO: decide whether you need/want to change path for saving IFLS3
/**/
save IFLS3, replace
/**/

*Household consumption

clear
*TO DO: change path to where you saved the following file "hh00dta/b1_ks1.dta"
/*EXAMPLE:*/
use "IFLS/Round 3/hh00dta/b1_ks1.dta"
/**/

foreach var of varlist ks02 ks03{
replace `var'=. if `var'x!=1
}

egen help=rowtotal(ks02 ks03), m 
bysort hhid00: egen weeklyfoodconsump=total(help), m

keep hhid00 weeklyfoodconsump
duplicates drop

*TO DO: change path to where you saved the following file "hh00dta/b1_ks0.dta"
/*EXAMPLE:*/
merge 1:1 hhid00 using "IFLS/Round 3/hh00dta/b1_ks0.dta", nogenerate
/**/

replace ks04b=. if ks04bx!=1

*Substract value of food given to person out of HH
replace weeklyfoodconsump=weeklyfoodconsump-ks04b

keep hhid00 weeklyfoodconsump

*TO DO: decide whether you need/want to change path for saving consumpexp
/**/
save consumpexp, replace
/**/

clear
*TO DO: change path to where you saved the following file "hh00dta/b1_ks2.dta"
/*EXAMPLE:*/
use "IFLS/Round 3/hh00dta/b1_ks2.dta"
/**/
replace ks06=. if ks06x!=1

bysort hhid00: egen monthlynonfoodexp=total(ks06), m

keep hhid00 monthlynonfoodexp
duplicates drop

*TO DO: change path to where you saved the following file "hh00dta/b1_ks0.dta"
/*EXAMPLE:*/
merge 1:1 hhid00 using "IFLS/Round 3/hh00dta/b1_ks0.dta", nogenerate
/**/

replace ks07a=. if ks07ax!=1

*Add value of nonfood items consumed that HH self-produced or received from another source
replace monthlynonfoodexp=monthlynonfoodexp+ks07a

keep hhid00 monthlynonfoodexp

*TO DO: change path to where you saved the following file "consumpexp.dta"
/*EXAMPLE:*/
merge 1:1 hhid00 using consumpexp, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving consumpexp
/**/
save consumpexp, replace
/**/

clear
*TO DO: change path to where you saved the following file "hh00dta/b1_ks3.dta"
/*EXAMPLE:*/
use "IFLS/Round 3/hh00dta/b1_ks3.dta"
/**/

foreach var of varlist ks08 ks09a{
replace `var'=. if `var'x!=1
}

egen help=rowtotal(ks08 ks09a), m 
bysort hhid00: egen yearlynonfoodexp=total(help), m

keep hhid00 yearlynonfoodexp
duplicates drop

*TO DO: change path to where you saved the following file "consumpexp.dta"
/*EXAMPLE:*/
merge 1:1 hhid00 using consumpexp, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving consumpexp
/**/
save consumpexp, replace
/**/

clear
*TO DO: change path to where you saved the following file "hh00dta/b1_ks0.dta"
/*EXAMPLE:*/
use "IFLS/Round 3/hh00dta/b1_ks0.dta"
/**/

foreach var of varlist ks10aa ks10ab ks11aa ks11ab ks12aa ks12ab ks12bb{
replace `var'=. if `var'x!=1
}

egen yearlyeducexp=rowtotal(ks10aa ks10ab ks11aa ks11ab ks12aa ks12ab ks12bb),m

keep hhid00 yearlyeducexp

*TO DO: change path to where you saved the following file "consumpexp.dta"
/*EXAMPLE:*/
merge 1:1 hhid00 using consumpexp, nogenerate
/**/
replace monthlynonfoodexp=12*monthlynonfoodexp
replace weeklyfoodconsump=52*weeklyfoodconsump
egen hh_exp=rowtotal(yearlynonfoodexp yearlyeducexp monthlynonfoodexp weeklyfoodconsump), missing

keep hhid00 hh_exp

*TO DO: change path to where you saved the following file "hh00dta/bk_ar0.dta"
/*EXAMPLE:*/
merge 1:1 hhid00 using "IFLS/Round 3/hh00dta/bk_ar0.dta", keep (master match) nogenerate
/**/

g pcexpend=hh_exp/hhsize

keep hhid00 pcexpend

rename pcexpend pcexpend2000

*TO DO: decide whether you need/want to change path for saving consumpexp
/**/
save consumpexp, replace
/**/

*TO DO: change path to where you saved the following file "IFLS3.dta"
/*EXAMPLE:*/
merge 1:m hhid00 using IFLS3, nogenerate keep(match using)
/**/

*TO DO: decide whether you need/want to change path for saving IFLS3
/**/
save IFLS3, replace
/**/

*Exchange rate for approximate midpoint of survey period
/*	From User's Guide Vol. 1 (p. 18):
	"Field work took place largely between late June and the end of October 2000,
	with long distance tracking extending through the end of December 2000."
	From User's Guide Vol. 1 (p. 22):
	"the main fieldwork periods went from June 23 to mid-October 2000 and from
	August 15 to mid-November 2000." 
-> I chose as approximate midpoint of survey: September 15, 2000
*/

g excrate=0.00012
label var excrate "Local to USD exchange rate at time of survey"

g excratemonth="9-2000"

*TO DO: decide whether you need/want to change path for saving IFLS3
/**/
save IFLS3, replace
/**/

*TO DO: change path to where you saved the following file "hh00dta/bk_sc.dta"
/*EXAMPLE:*/
merge m:1 hhid00 using "IFLS/Round 3/hh00dta/bk_sc.dta",  keepusing(sc05) nogenerate keep(match master) 
/**/

g urban=(sc05==1)

drop sc05 

*TO DO: decide whether you need/want to change path for saving IFLS3
/**/
save IFLS3, replace
/**/

********************************************************************************
*Round 4
********************************************************************************

clear
*TO DO: change path to where you saved the following file "hh07_all_dta/b2_cov.dta"
/*EXAMPLE:*/
use "IFLS/Round 4/hh07_all_dta/b2_cov.dta"
/**/

*Survey round number
g wave=2

g surveyyear=2007

*I assume that ivwyr=7 == 2007 and ivwyr=2008
g help=string(ivwmth1)+"-200"+string(ivwyr1)

g interviewmonth2007=monthly(help,"MY")

keep rsnpndnt hhid07 wave surveyyear interviewmonth2007 ivwyr1

*TO DO: change path to where you saved the following file "hh07_all_dta/b2_nt1.dta"
/*EXAMPLE:*/
merge 1:m hhid07 using "IFLS/Round 4/hh07_all_dta/b2_nt1.dta", nogenerate
/**/

replace nt01a=0 if nt01==3

*Household operates a non-farm business
g hhbus=(nt01==1) & nt01!=9
drop nt01

*Survival
*later

keep hhid07 wave surveyyear rsnpndnt interviewmonth2007 ivwyr1 hhbus nt01a

*TO DO: change path to where you saved the following file "hh07_all_dta/b2_nt2.dta"
/*EXAMPLE:*/
merge 1:m hhid07 using "IFLS/Round 4/hh07_all_dta/b2_nt2.dta", nogenerate
/**/

*Household entirely owns non-farm business
g enf_bus=(nt02==1) if nt02!=.

g tbdropped4=(nt01a>1) if nt01a!=. | enf_bus!=1

/*Since the data is in long format in case a hh operates more than one business I drop
 duplicates in folio tbdropped to be able to merge the 2000 with data at the individual
 level and the 2007 data later
*/
duplicates drop hhid07 tbdropped, force

replacetomissings nt15myr
g help=string(nt15mth)+"-"+string(nt15myr)
g startofbus=monthly(help,"MY")
replace startofbus=yearly(string(nt15myr),"Y") if nt15x==8 | nt15x==9 | nt15mth==. | nt15mth==98 | nt15mth==99

g agefirm=(interviewmonth2007-startofbus)/12
/*I use 2008.00 as the interviewdate for the yearly start dates of the businesses,
 as I don't know when they started in the start year and hence are treating all
 as if they had started in January of that year.*/
replace agefirm=(2008-startofbus) if nt15x==8 | nt15x==9 | nt15mth==. | nt15mth==98 | nt15mth==99
g x_agefirm=.
replace x_agefirm=1 if nt15x==1
replace x_agefirm=0 if ( nt15x==8 | nt15x==9 | nt15x==.) | ((nt15mth==. | nt15mth==98 | nt15mth==99) & nt15x==1)

g closeddown=(nt18==3)
replace closeddown=. if nt18==. | nt18==9

drop help


# delimit ;
label define fieldofbus
1 	"Agriculture,forestry,fishing,factory"
2	"Sales"
4	"Electricity,Gas and Water"
5	"Construction"
7	"Transportation and communication"
8	"Finance,insurance,real estate"  
21	"Restaurant, food store"
22	"Industrial: food"
23	"Industrial: garment"
24	"Industrial: other"
25	"Store: outside of food"
31	"Service: Government"       
32	"Service: Teacher"                            
33	"Service: Profesional staff"             
34	"Service: Transportation (becak, ojek, taxi)"
35	"Service: Other (tailor, salon)"
95	"Other";
# delimit cr


rename nt05c fieldofbus
label values fieldofbus fieldofbus 

*Capital stock

foreach x in a b c1 c4 h{
replacetomissings nt10`x'
}

foreach x in a b c1 c4 h{
replace nt10`x'=. if nt10`x'x==7 | nt10`x'x==8 | nt10`x'x==9
replace nt10`x'=0 if nt10`x'x==3
}

foreach x in a b c1 c4 h{
count if nt10`x'!=.
}

egen capitalstock=rowtotal(nt10a nt10b nt10c1 nt10c4 nt10h), missing
replace capitalstock=. if nt10a==. | nt10b==. | nt10c1==. | nt10c4==. | nt10h==.

/*For the capital stock, there were also ranges given for owners who did not want to
give an answer in questions NT10A-NT10H. These however appear to be the minority and so for now 
I do not use these variables, also because they only exist for each item (A-H) individually
and this will not allow me to construct a sum over all the items.*/

*Business sales in last month
g sales=.
replace sales=nt07 if  nt07x==1
*Since sales are given for past 12 months:
replace sales=sales/12


/*In the 4th round, for businesses for which no clear figure on revenues was given
 (the majority of businesses, i. p. all but 29!), questions were asked on whether it was 
 below or above certain thresholds. I combine the information on the exact figures with
 this information to construct dummy variables on the ranges asked. Given that the range
 question was asked in two stages (1st: below or 4 mio. and above, and 2nd below or 2 mio.
 and above, or below or 8 mio. and above, respectively) and that there are some (only two)
 missing values in the second stage, I construct two dummies, one with below or over 4 mio. and
 the other with 4 possible ranges each of 2 mio.
*/
 
g sales_4maa=(nt07a1==1 | nt07>=4000000)
replace sales_4maa=. if nt07==. &  (nt07a1==98 | nt07a1==99 | nt07a1==.)

g sales_2maa4=((nt07a1==2 & nt07a2==21) | (nt07>=2000000 & nt07<4000000))
replace sales_2maa4=. if (nt07a1==. | nt07a1==98 | nt07a1==99) | ( nt07a2==. | nt07a2==18 | nt07a2==28 | nt07a2==99) &  (nt07==.)

g sales_4maa8=((nt07a1==1 & nt07a2==12) | (nt07>=4000000 & nt07<8000000))
replace  sales_4maa8=. if (nt07a1==. | nt07a1==98 | nt07a1==99) | ( nt07a2==. | nt07a2==18 | nt07a2==28 | nt07a2==99) &  (nt07==.)

g sales_8maa=((nt07a1==1 & nt07a2==11) | nt07>=8000000)
replace sales_8maa=. if  (nt07a1==. | nt07a1==98 | nt07a1==99) | ( nt07a2==. | nt07a2==18 | nt07a2==28 | nt07a2==99) &  (nt07==.)
drop nt07 nt07x nt07a1 nt07a2


*Business profits in last month
replacetomissings nt09
g profits=.
replace profits=nt09 if  nt09x==1 |  nt09x==3
replace profits=profits/12
drop nt09 nt09x


*Business expenses in last month
g expenses=.
replace expenses=nt08 if  nt08x==1
*Since expenses are given for past 12 months:
replace expenses=expenses/12

g expenses_4maa=(nt08a1==1 | nt08>=4000000)
replace  expenses_4maa=. if nt08==. &  (nt08a1==. | nt08a1==99 | nt08a1==98)

g expenses_2maa4=((nt08a1==2 & nt08a2==21) | (nt08>=2000000 & nt08<4000000))
replace  expenses_2maa4=. if ((nt08a1==. | nt08a1==98 | nt08a1==99) | (nt08a2==. | nt08a2==99)) &  (nt08==.)

g expenses_4maa8=((nt08a1==1 & nt08a2==12) | (nt08>=4000000 & nt08<8000000))
replace  expenses_4maa8=. if ((nt08a1==. | nt08a1==98 | nt08a1==99) | (nt08a2==. | nt08a2==99)) &  (nt08==.)

g expenses_8maa=((nt08a1==1 & nt08a2==11) | nt08>=8000000)
replace expenses_8maa=. if ((nt08a1==. | nt08a1==98 | nt08a1==99) | (nt08a2==. | nt08a2==99)) &  (nt08==.)
drop nt08 nt08x nt08a1 nt08a2

*Employment
replacetomissings nt23
replacetomissings nt22
g employees=.
replace employees=nt23 if nt23x==1

egen totalworkers=rowtotal(nt23 nt22), m
replace totalworkers=. if  nt23x==8 | nt22x==8 | nt23x==. | nt22x==. | nt23==. | nt22==.
drop nt23 nt23x nt22 nt22x


keep rsnpndnt hhid07 wave surveyyear interviewmonth2007 ivwyr1 nt01a hhbus nt05aa nt05ab fieldofbus nt15x nt15mth nt15myr enf_bus-totalworkers


*TO DO: change path to where you saved the following file "hh07_all_dta/bk_ar1.dta"
/*EXAMPLE:*/
merge 1:m hhid07 using "IFLS/Round 4/hh07_all_dta/bk_ar1.dta", nogenerate keep(1 3)
/**/

drop if ar01a==3 | ar01a==6

/*There are a still a couple of duplicates left, most of which have the person appearing
 in two households as dead. Since I cannot be sure to which household the person belongs
 in this case, I drop these duplicate observations*/
duplicates tag pidlink, gen(dupl_pidlink)
drop if dupl_pidlink>0 & ar01a==0

*There still remain 6 duplicates in pidlink, I deal with:
drop dupl
duplicates tag pidlink, gen(dupl_pidlink)
drop if dupl_pidlink>0 & ar01a!=1

*Owner died between survey rounds
g dead=(ar01a==0) if ar01a!=.

keep hhid07 pid07 pidlink rsnpndnt wave surveyyear interviewmonth ivwyr1 nt01a hhbus nt05aa nt05ab fieldofbus-totalworkers dead

*Identify the businessowners
*nt05aa and nt05ab indicate the household members (pid00) who were primarily responsible for the busines
g primarilyresponsible1=0 if nt01==1
replace primarilyresponsible1=1 if nt05aa==pid07 

g primarilyresponsible2=0 if nt01==1 
replace primarilyresponsible2=1 if nt05ab==pid07 

keep hhid07 pid07 pidlink rsnpndnt wave surveyyear interviewmonth ivwyr1 nt01a hhbus nt05aa nt05ab fieldofbus-primarilyresponsible2

*TO DO: decide whether you need/want to change path for saving IFLS4
/**/
save IFLS4, replace
/**/

clear
*TO DO: change path to where you saved the following file "hh07_all_dta/b3a_tk2.dta"
/*EXAMPLE:*/
use "IFLS/Round 4/hh07_all_dta/b3a_tk2.dta"
/**/
destring  tk23bx, replace
tostring tk26b3, replace
*TO DO: change path to where you saved the following file "hh07_all_dta/bp_tk2.dta"
/*EXAMPLE:*/
merge 1:1 hhid07 pid07 using "IFLS/Round 4/hh07_all_dta/bp_tk2.dta", update nogenerate
/**/
*TO DO: change path to where you saved the following file "hh07_all_dta/b3a_tk1.dta"
/*EXAMPLE:*/
merge 1:1 hhid07 pid07 using "IFLS/Round 4/hh07_all_dta/b3a_tk1.dta", nogenerate
/**/
*TO DO: change path to where you saved the following file "hh07_all_dta/bp_tk1.dta"
/*EXAMPLE:*/
merge 1:1 hhid07 pid07 using "IFLS/Round 4/hh07_all_dta/bp_tk1.dta", update nogenerate
/**/


*Hours worked in self-employment in last month
/* value labels of tk24a
1	Self-employed
2	Self employed with  HHmember assistan
3	Self-employed with employee/fixed wor
4	Government worker
5	Private worker
6	Unpaid family worker
7	Casual worker in agriculture
8	Casual worker not in agriculture
9	Missing
*/



*Hours worked in self-employment in last month
g selfemployed=(tk24a==1 |tk24a==2 | tk24a==3) if (tk24a!=. | tk03!=9) & (tk24a!=. | tk03!=.) 


replacetomissings tk21a
replacetomissings tk22a
	
g hours=tk21a*(30/7) if selfemployed==1
label var hours "based on hours worked during the past week"

g hoursnormal=tk22a*(30/7) if selfemployed==1
label var hoursnormal "based on hours worked during a normal week"

*Worked as wage worker in last month
g wageworker=(tk24a==4 | tk24a==5) if (tk24a!=. | tk03!=9) & (tk24a!=. | tk03!=.) 

*Labor earnings in last month
g laborincome=wageworker*tk25a1

g laborincome_24maa=(wageworker==1 & tk25a1ax==1)
replace laborincome_24maa=. if wageworker==. | tk25a1ax==. | tk25a1ax==98 | tk25a1ax==99

g laborincome_12maa24=(wageworker==1 & tk25a1ax==2 &  tk25a1a==21)
replace laborincome_12maa24=. if wageworker==. | tk25a1ax==. | tk25a1ax==98 | tk25a1ax==99 | tk25a1a==. | tk25a1a==28 | tk25a1a==99 

g laborincome_24maa48=(wageworker==1 & tk25a1ax==1 &  tk25a1a==12)
replace laborincome_24maa48=. if wageworker==. | tk25a1ax==. | tk25a1ax==98 | tk25a1ax==99 | tk25a1a==. | tk25a1a==28 | tk25a1a==99 

g laborincome_48maa=(wageworker==1 & tk25a1ax==1 &  tk25a1a==11)
replace laborincome_48maa=. if wageworker==. | tk25a1ax==. | tk25a1ax==98 | tk25a1ax==99 | tk25a1a==. | tk25a1a==28 | tk25a1a==99 

*Retired
g retired=(tk01==5)
replace retired=. if tk01==99 | tk01==95

keep hhid07 pid07 selfemployed hours* wageworker laborincome retired

*TO DO: change path to where you saved the following file "IFLS4.dta"
/*EXAMPLE:*/
merge 1:1 hhid07 pid07 using IFLS4, nogenerate 
/**/

*There are four obs. which have pidlink=="". I drop them:
drop if pidlink==""

*TO DO: decide whether you need/want to change path for saving IFLS4
/**/
save IFLS4, replace
/**/

*Household consumption

clear
*TO DO: change path to where you saved the following file "hh07_all_dta/b1_ks1.dta"
/*EXAMPLE:*/
use "IFLS/Round 4/hh07_all_dta/b1_ks1.dta"
/**/

replacetomissings ks02
replacetomissings ks03

egen help=rowtotal(ks02 ks03) if ks03x=="1" & ks02x=="1", m 
bysort hhid07: egen weeklyfoodconsump=total(help), m

keep hhid07 weeklyfoodconsump
duplicates drop

*TO DO: change path to where you saved the following file "hh07_all_dta/b1_ks0.dta"
/*EXAMPLE:*/
merge 1:1 hhid07 using "IFLS/Round 4/hh07_all_dta/b1_ks0.dta", nogenerate
/**/
replacetomissings ks04b

*Substract value of food given to person out of HH
replace weeklyfoodconsump=weeklyfoodconsump-ks04b
replace weeklyfoodconsump=. if ks04bx!="1"

keep hhid07 weeklyfoodconsump

*TO DO: decide whether you need/want to change path for saving consumpexp
/**/
save consumpexp, replace
/**/

clear
*TO DO: change path to where you saved the following file "hh07_all_dta/b1_ks2.dta"
/*EXAMPLE:*/
use "IFLS/Round 4/hh07_all_dta/b1_ks2.dta"
/**/

replacetomissings ks06
replace ks06=. if ks06x!="1"

bysort hhid07: egen monthlynonfoodexp=total(ks06), m

keep hhid07 monthlynonfoodexp
duplicates drop

*TO DO: change path to where you saved the following file "hh07_all_dta/b1_ks0.dta"
/*EXAMPLE:*/
merge 1:1 hhid07 using "IFLS/Round 4/hh07_all_dta/b1_ks0.dta", nogenerate
/**/

replacetomissings ks07a
replace ks07a=. if ks07ax!="1"

*Add value of nonfood items consumed that HH self-produced or received from another source
replace monthlynonfoodexp=monthlynonfoodexp+ks07a

keep hhid07 monthlynonfoodexp

*TO DO: change path to where you saved the following file "consumpexp.dta"
/*EXAMPLE:*/
merge 1:1 hhid07 using consumpexp, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving consumpexp
/**/
save consumpexp, replace
/**/

clear
*TO DO: change path to where you saved the following file "hh07_all_dta/b1_ks3.dta"
/*EXAMPLE:*/
use "IFLS/Round 4/hh07_all_dta/b1_ks3.dta"
/**/

foreach var of varlist ks08 ks09a{
replace `var'=. if `var'x!="1"
replacetomissings `var'
}


egen help=rowtotal(ks08 ks09a), m 
bysort hhid07: egen yearlynonfoodexp=total(help), m

keep hhid07 yearlynonfoodexp
duplicates drop

*TO DO: change path to where you saved the following file "consumpexp.dta"
/*EXAMPLE:*/
merge 1:1 hhid07 using consumpexp, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving consumpexp
/**/
save consumpexp, replace
/**/

clear
*TO DO: change path to where you saved the following file "hh07_all_dta/b1_ks0.dta"
/*EXAMPLE:*/
use "IFLS/Round 4/hh07_all_dta/b1_ks0.dta"
/**/

foreach var of varlist ks10aa ks10ab ks11aa ks11ab ks12aa ks12ab ks12bb{
replacetomissings `var'
}

egen yearlyeducexp=rowtotal(ks10aa ks10ab ks11aa ks11ab ks12aa ks12ab ks12bb),m

keep hhid07 yearlyeducexp

*TO DO: change path to where you saved the following file "consumpexp.dta"
/*EXAMPLE:*/
merge 1:1 hhid07 using consumpexp, nogenerate
/**/

replace monthlynonfoodexp=12*monthlynonfoodexp
replace weeklyfoodconsump=52*weeklyfoodconsump
egen hh_exp=rowtotal(yearlynonfoodexp yearlyeducexp monthlynonfoodexp weeklyfoodconsump), missing

keep hhid07 hh_exp

*TO DO: change path to where you saved the following file "hh07_all_dta/bk_ar0.dta"
/*EXAMPLE:*/
merge 1:1 hhid07 using "IFLS/Round 4/hh07_all_dta/bk_ar0.dta", keep (master match) nogenerate
/**/

g pcexpend=hh_exp/hhsize

keep hhid07 pcexpend

rename pcexpend pcexpend2007

*TO DO: decide whether you need/want to change path for saving consumpexp
/**/
save consumpexp, replace
/**/

*TO DO: change path to where you saved the following file "IFLS4.dta"
/*EXAMPLE:*/
merge 1:m hhid07 using IFLS4, nogenerate keep(match using)
/**/


*TO DO: decide whether you need/want to change path for saving IFLS4
/**/
save IFLS4, replace
/**/

*Exchange rate for approximate midpoint of survey period
/*	From User's Guide Vol. 1 (p. 19):
	"field work took place largely between late November 2007 and the end of
	April 2008, with long distance tracking extending through the end of May 2008."
	From User's Guide Vol. 1 (p. 23):
	"there were two phases of main fieldwork: the main fieldwork periods went 
	from November 25 2007 to end of May 2008 and from December 26 to mid-June 2008.
	As teams finished their main fieldwork period they began their long-distance
	tracking phase (from roughly mid-April to early July 2008)‚." 
-> I chose as approximate midpoint of survey: March 5, 2008
*/



g excrate=0.00011
label var excrate "Local to USD exchange rate at time of survey"

g excratemonth="3-2008"


*TO DO: decide whether you need/want to change path for saving IFLS4
/**/
save IFLS4, replace
/**/

*Include baseline vars for round 4

clear
*TO DO: change path to where you saved the following file "hh07_all_dta/bk_ar1.dta"
/*EXAMPLE:*/
use "IFLS/Round 4/hh07_all_dta/bk_ar1.dta"
/**/

replacetomissings ar09

*Child under 5 in household
g under5=0
replace under5=. if ar09==. 
replace under5=1 if ar09<5 
bysort hhid07: egen childunder5=max(under5)
drop under5

*Child aged 5 to 12 in household
g aged5to12=0
replace aged5to12=. if ar09==. 
replace aged5to12=1 if ar09>=5 & ar09<12
bysort hhid07: egen childaged5to12=max(aged5to12)
drop aged5to12

*Has adult aged 65+ in the household
g is65orover=0
replace is65orover=. if ar09==. 
replace is65orover=1 if ar09>=65 & ar09!=. 
bysort hhid07: egen adult65andover=max(is65orover)
drop is65orover

*Marital status of owner
g married=(ar13==2) if ar13!=.

*Education of owner
replacetomissings ar16
g ownertertiary=(ar16==60 | ar16==61 | ar16==62 | ar16==63) if ar16!=.

replacetomissings ar17
*Years of education
*None
g educyears=0 if (ar16==1 | ar16==90)
*Elementary School
replace educyears=ar17 if (ar16==2 | ar16==72)
replace educyears=6 if ar17==7 & (ar16==2 | ar16==72)
*Junior High
replace educyears=ar17+6 if (ar16==3 | ar16==4 | ar16==73)
replace educyears=3+6 if ar17==7 & (ar16==3 | ar16==4 | ar16==73)
*High School
replace educyears=ar17+9 if (ar16==5 | ar16==6 | ar16==74)
replace educyears=3+9 if ar17==7 & (ar16==5 | ar16==6 | ar16==74)
*Tertiary education
replace educyears=ar17+12 if (ar16==60 | ar16==61)
replace educyears=4+12 if ar17==7 & (ar16==60 | ar16==61)
replace educyears=ar17+16 if (ar16==62)
replace educyears=2+16 if ar17==7 & (ar16==62)
replace educyears=ar17+18 if (ar16==63)
replace educyears=3+16 if ar17==7 & (ar16==63)

keep hhid07 pid07 childunder5-educyears

*TO DO: change path to where you saved the following file "IFLS4.dta"
/*EXAMPLE:*/
merge 1:1 hhid07 pid07 using IFLS4, nogenerate keep(2 3)
/**/

*TO DO: decide whether you need/want to change path for saving IFLS4
/**/
save IFLS4, replace
/**/


clear
*TO DO: change path to where you saved the following file "hh07_all_dta/bek_ek1.dta"
/*EXAMPLE:*/
use "IFLS/Round 4/hh07_all_dta/bek_ek1.dta"
/**/
*Raven progressive matrices score
*I compute the score as the percentage of correct answers for questions ek01-ek12
foreach var of varlist ek1x-ek12x{
replace `var'=(`var'==1) if `var'!=9
replace `var'=. if `var'==9
}

egen raven=rowtotal(ek1x-ek12x),m
replace raven=raven/12

keep pidlink raven

*TO DO: change path to where you saved the following file "IFLS4.dta"
/*EXAMPLE:*/
merge 1:1 pidlink using IFLS4, nogenerate keep(2 3)
/**/

*TO DO: decide whether you need/want to change path for saving IFLS4
/**/
save IFLS4, replace
/**/


*TO DO: change path to where you saved the following file "hh07_all_dta/bk_sc.dta"
/*EXAMPLE*/
merge m:1 hhid07 using "IFLS/Round 4/hh07_all_dta/bk_sc.dta",  keepusing(sc05) nogenerate keep(match master) 
/**/

g urban=(sc05==1)

drop sc05 

*TO DO: decide whether you need/want to change path for saving IFLS4
/**/
save IFLS4, replace
/**/

********************************************************************************
*Round 5
********************************************************************************
clear
*TO DO: change path to where you saved the following file "hh14_all_dta/b2_cov.dta"
/*EXAMPLE*/
use "IFLS/Round 5/hh14_all_dta/b2_cov.dta"
/**/

replace rspndnt=pid14

keep hhid14 rspndnt

*TO DO: change path to where you saved the following file "hh14_all_dta/b2_time.dta"
/*EXAMPLE*/
merge 1:m hhid14 using "IFLS/Round 5/hh14_all_dta/b2_time.dta", nogenerate
/**/

*I just take the information from the first time the interview was conducted
keep if time_occ==1

g help=string(ivwmth)+"-"+string(ivwyr)

g interviewmonth2014=monthly(help,"MY")

replace ivwyr=yearly(string(ivwyr),"Y")

keep rspndnt hhid14 interviewmonth2014 ivwyr

*Survey round number
g wave=3

g surveyyear=2014

*TO DO: change path to where you saved the following file "hh14_all_dta/b2_nt1.dta"
/*EXAMPLE*/
merge 1:1 hhid14 using "IFLS/Round 5/hh14_all_dta/b2_nt1.dta", nogenerate
/**/

replace nt01a=0 if nt01==3

*Household operates a non-farm business
g hhbus=(nt01==1) & nt01!=9 & nt01!=.
drop nt01

*Survival
*later

keep rspndnt hhid14 interviewmonth2014 wave surveyyear ivwyr hhbus nt01a

*TO DO: change path to where you saved the following file "hh14_all_dta/b2_nt2.dta"
/*EXAMPLE*/
merge 1:m  hhid14 using "IFLS/Round 5/hh14_all_dta/b2_nt2.dta", nogenerate
/**/

*Household entirely owns non-farm business
g enf_bus=(nt02==1) if nt02!=.

g tbdropped5=(nt01a>1) if nt01a!=. | enf_bus!=1

/*Since the data is in long format in case a hh operates more than one business I drop
 duplicates in folio tbdropped to be able to merge the 2000 with data at the individual
 level and the 2007 data later
*/
duplicates drop hhid14 tbdropped, force

replacetomissings nt15y
g help=string(nt15m)+"-"+string(nt15y)
g startofbus=monthly(help,"MY")
replace startofbus=yearly(string(nt15y),"Y") if nt15x==8 | nt15x==9 | nt15m==. | nt15m==98 | nt15m==99

g agefirm=(interviewmonth2014-startofbus)/12
/*I use 2014 and 2015 as the interviewdate for the yearly start dates of the businesses,
 as I don't know when they started in the start year and hence are treating all
 as if they had started in January of that year.*/
replace agefirm=(ivwyr-startofbus) if nt15x==8 | nt15x==9 | nt15m==. | nt15m==98 | nt15m==99

*As there is one negative agefirm, I replace it by 0:
replace agefirm=0 if agefirm<0

g x_agefirm=.
replace x_agefirm=1 if nt15x==1
replace x_agefirm=0 if ( nt15x==8 | nt15x==9 | nt15x==.) | ((nt15m==. | nt15m==98 | nt15m==99) & nt15x==1)
g closeddown=(nt18==3) if nt18!=. & nt18!=9

drop help


# delimit ;
label define fieldofbus
1 	"Agriculture,forestry,fishing,factory"
2	"Sales"
4	"Electricity,Gas and Water"
5	"Construction"
7	"Transportation and communication"
8	"Finance,insurance,real estate"  
21	"Restaurant, food store"
22	"Industrial: food"
23	"Industrial: garment"
24	"Industrial: other"
25	"Store: outside of food"
31	"Service: Government"       
32	"Service: Teacher"                            
33	"Service: Professional staff"             
34	"Service: Transportation (becak, ojek, taxi)"
35	"Service: Other (tailor, salon)"
95	"Other";
# delimit cr


rename nt05c fieldofbus
label values fieldofbus fieldofbus 

*Capital stock
/* There is something wrong with the amounts used to calculate the capital stock.
	In the questionnaire there are questions for the amount as well as unfolding bracket
	possibilities. It seems that what is given in nt10a-nt10h is rather the unfolding bracket
	code than the actual amount.
foreach x in a b c1 c4 h{
replacetomissings nt10`x'
}

foreach x in a b c1 c4 h{
replace nt10`x'=. if nt10`x'x==7 | nt10`x'x==8 | nt10`x'x==9
replace nt10`x'=0 if nt10`x'x==3
}

foreach x in a b c1 c4 h{
count if nt10`x'!=.
}

egen capitalstock=rowtotal(nt10a nt10b nt10c1 nt10c4 nt10h), missing
replace capitalstock=. if nt10a==. | nt10b==. | nt10c1==. | nt10c4==. | nt10h==.
*/

g sales=.
replace sales=nt07 if  nt07x==1
replace sales=nt07_2 if  nt07x_2==1
*Since sales are given for past 12 months:
replace sales=sales/12

/*In the 5th round, for businesses for which no clear figure on revenues was given
 (the majority of businesses, i. p. all but 65), questions were asked on whether it was 
 below, above or about a certain thresholds. I combine the information on the exact figures with
 this information to construct dummy variables on the ranges asked. 
 
 In addition to the values and ranges for nt07 and nt07a respectively, there are
 values and ranges (variables nt07_2 and nt07a2) given which appear to be measuring
 revenues too (I assume that they measure the same figures that nt07 and nt07a are 
 measuring, respectively) and are given for those household businesses for whom
 there are no values given for revenues in nt07 and nt07a. Therefore I combine these two 
 variables for each type of answer (amount and range) into one single variable.

  According to RAND, the proceeding is correct.

 */
 
g sales_4maa6=(nt07a1==22 | nt07a1==112| nt07a1==113 | nt07a1==231) | (nt07a2==22 | nt07a2==112 | nt07a2==113 | nt07a2==231 ) | (nt07>=2000000 & nt07<4000000) | (nt07_2>=2000000 & nt07_2<4000000) 
replace sales_4maa6=. if ((nt07a1==. | nt07a1==18 | nt07a1==28 | nt07a1==238) & ( nt07a2==. | nt07a2==18 | nt07a2==28 | nt07a2==118 | nt07a2==238 | nt07a2==2338)) &  (nt07==.) & (nt07_2==.)

g sales_6maa10=(nt07a1==12 | nt07a1==131 | nt07a1==232 | nt07a1==2331) | (nt07a2==12 | nt07a2==131 | nt07a2==2331) | (nt07>=4000000 & nt07<8000000) | (nt07_2>=4000000 & nt07_2<8000000)
replace  sales_6maa10=. if ((nt07a1==. | nt07a1==18 | nt07a1==28 | nt07a1==238) & ( nt07a2==. | nt07a2==18 | nt07a2==28 | nt07a2==118 | nt07a2==238 |  nt07a2==2338)) &  (nt07==.) & (nt07_2==.)

g sales_10maa=nt07a1==132 | nt07a1==133 | nt07a1==2332 | nt07a1==2333 | nt07>=8000000 | nt07_2>=8000000
replace sales_10maa=. if ((nt07a1==. | nt07a1==18 | nt07a1==28 | nt07a1==238) & ( nt07a2==. | nt07a2==18 | nt07a2==28 | nt07a2==118 | nt07a2==238 |  nt07a2==2338)) &  (nt07==.) & (nt07_2==.)

drop nt07 nt07x nt07a1 nt07a2 nt07_2 nt07x_2


*Business profits in last month
*For profits there are also two versions of variabels for amounts given, which I combine
replacetomissings nt09
replacetomissings nt09_2

g profits=.
replace profits=nt09 if  nt09x==1  |  nt09x==3
replace profits=nt09_2 if  nt09x_2==1  |  nt09x_2==3
*Since profits are given for past 12 months:
replace profits=profits/12
drop nt09  nt09_2  nt09x nt09x_2 

*Business expenses in last month
/*The variables used to construct expenses have the same structure as the variables used to
construct sales, i.e. amounts and ranges, and two versions, and so I proceed as for sales*/
g expenses=.
replace expenses=nt08 if  nt08x==1
replace expenses=nt08_2 if  nt08x_2==1
*Since expenses are given for past 12 months:
replace expenses=expenses/12

g expenses_4maa6=(nt08a2==22 | nt08a2==112 | nt08a2==113 | nt08a2==231 ) | (nt08>=2000000 & nt08<4000000) | (nt08_2>=2000000 & nt08_2<4000000) 
replace expenses_4maa6=. if (nt08a2==. | nt08a2==18 | nt08a2==28 | nt08a2==118 | nt08a2==238) & (nt08a3==. | nt08a3==2338) & (nt08==.) & (nt08_2==.)

g expenses_6maa10= (nt08a2==12 | nt08a2==131) | (nt08>=4000000 & nt08<8000000) | (nt08_2>=4000000 & nt08_2<8000000)
replace expenses_6maa10=. if ( nt08a2==. | nt08a2==18 | nt08a2==28 | nt08a2==118 | nt08a2==238) & (nt08a3==. | nt08a3==2338) & (nt08==.) & (nt08_2==.)

g expenses_10maa=nt08a2==132 | nt08a2==133 | nt08a2==2333 | nt08a3==2332 | nt08a3==2333 | nt08>=8000000 | nt08_2>=8000000
replace expenses_10maa=. if ( nt08a2==. | nt08a2==18 | nt08a2==28 | nt08a2==118 | nt08a2==238) & (nt08a3==. | nt08a3==2338) & (nt08==.) & (nt08_2==.)

drop nt08 nt08x nt08a3 nt08a2 nt08_2 nt08x_2

*Employment
g employees=.
replace employees=nt23 if nt23x==1

egen totalworkers=rowtotal(nt23 nt22), m
replace totalworkers=. if  nt23x==8 | nt22x==8 | nt23x==. | nt22x==. | nt23==. | nt22==.
drop nt23 nt23x nt22 nt22x

keep rspndnt hhid14 interviewmonth2014 wave surveyyear nt01a hhbus nt05aa nt05ab fieldofbus nt15x nt15m nt15y enf_bus-totalworkers

*TO DO: change path to where you saved the following file "hh14_all_dta/bk_ar1.dta"
/*EXAMPLE*/
merge 1:m hhid14 using "IFLS/Round 5/hh14_all_dta/bk_ar1.dta", nogenerate keep(1 3)
/**/

drop if ar01a==3 | ar01a==6

/*There are a still a couple of duplicates left, most of which have the person appearing
 in two households as dead. Since I cannot be sure to which household the person belongs
 in this case, I drop these duplicate observations*/
duplicates tag pidlink, gen(dupl_pidlink)
drop if dupl_pidlink>0 & ar01a==0

*There still remain duplicates in pidlink, I deal with:
drop dupl
duplicates tag pidlink, gen(dupl_pidlink)
drop if dupl_pidlink>0 & ar01a!=1

*There still remain duplicates in pidlink, which all have ar01a==1 and so I drop them
drop dupl
duplicates tag pidlink, gen(dupl_pidlink)

drop if dupl>0

*Owner died between survey rounds
g dead=(ar01a==0) if ar01a!=.

keep hhid14 pid14 pidlink rspndnt interviewmonth wave surveyyear nt01a hhbus nt05aa nt05ab fieldofbus nt15x nt15m nt15y enf_bus-totalworkers dead


*Identify the businessowners
*nt05aa and nt05ab indicate the household members (pid00) who were primarily responsible for the busines
g primarilyresponsible1=0 if hhbus==1
replace primarilyresponsible1=1 if nt05aa==pid14

g primarilyresponsible2=0 if hhbus==1 
replace primarilyresponsible2=1 if nt05ab==pid14 

keep hhid14 pid14 pidlink rspndnt interviewmonth wave surveyyear nt01a hhbus nt05aa nt05ab fieldofbus nt15x nt15m nt15y enf_bus-primarilyresponsible2

*TO DO: decide whether you need/want to change path for saving IFLS5
/**/
save IFLS5, replace
/**/

clear
*TO DO: change path to where you saved the following file "hh14_all_dta/b3a_tk1.dta"
/*EXAMPLE*/
use "IFLS/Round 5/hh14_all_dta/b3a_tk1.dta"
/**/
*TO DO: change path to where you saved the following file "hh14_all_dta/b3a_tk2.dta"
/*EXAMPLE*/
merge 1:1 hhid14 pid14 using "IFLS/Round 5/hh14_all_dta/b3a_tk2.dta", nogenerate
/**/

*Hours worked in self-employment in last month
/* value labels of tk24a
1	Self-employed
2	Self employed with  HHmember assistan
3	Self-employed with employee/fixed wor
4	Government worker
5	Private worker
6	Unpaid family worker
7	Casual worker in agriculture
8	Casual worker not in agriculture
9	Missing
*/

g selfemployed=(tk24a==1 |tk24a==2 | tk24a==3) if (tk24a!=. | tk03!=9) & (tk24a!=. | tk03!=.)

replacetomissings tk21a
replacetomissings tk22a

g hours=tk21a*(30/7) if selfemployed==1
label var hours "based on hours worked during the past week"

g hoursnormal=tk22a*(30/7) if selfemployed==1
label var hoursnormal "based on hours worked during a normal week"

*Worked as wage worker in last month
g wageworker=(tk24a==4 | tk24a==5) if (tk24a!=. | tk03!=9) & (tk24a!=. | tk03!=.)
replace wageworker=. if tk24a==9

*Labor earnings in last month
replacetomissings tk25a1

g laborincome=wageworker*tk25a1

g laborincome_2maa8_2014=(wageworker==1 & tk25a1x==1) &  (tk25a1a==22 | tk25a1a==112 | tk25a1a==113 | tk25a1a==231)
replace laborincome_2maa8_2014=. if wageworker==. | tk25a1x==. | tk25a1x==8 | tk25a1a==. | tk25a1a==18 | tk25a1a==28 | tk25a1a==118 | tk25a1a==138

g laborincome_8maa10_2014=(wageworker==1 & tk25a1x==1) &  (tk25a1a==12 | tk25a1a==2331)
replace laborincome_8maa10_2014=. if wageworker==. | tk25a1x==. | tk25a1x==8 | tk25a1a==. | tk25a1a==18 | tk25a1a==28 | tk25a1a==118 | tk25a1a==138

g laborincome_10maa_2014=(wageworker==1 & tk25a1x==1) &  (tk25a1a==133 | tk25a1a==133)
replace laborincome_10maa_2014=. if wageworker==. | tk25a1x==. | tk25a1x==8 | tk25a1a==. | tk25a1a==18 | tk25a1a==28 | tk25a1a==118 | tk25a1a==138

*Retired
g retired=(tk01==5) if tk01!=95

keep hhid14 pid14 selfemployed hours* wageworker laborincome retired

*TO DO: change path to where you saved the following file "IFLS5.dta"
/*EXAMPLE*/
merge 1:m hhid14 pid14 using IFLS5, nogenerate keep(2 3)
/**/

*TO DO: decide whether you need/want to change path for saving IFLS5
/**/
save IFLS5, replace
/**/

*Household consumption

clear
*TO DO: change path to where you saved the following file "hh14_all_dta/b1_ks1.dta"
/*EXAMPLE*/
use "IFLS/Round 5/hh14_all_dta/b1_ks1.dta"
/**/
egen help=rowtotal(ks02 ks03) if ks03x==1 & ks02x==1, m 
bysort hhid14: egen weeklyfoodconsump=total(help), m

keep hhid14 weeklyfoodconsump
duplicates drop

*TO DO: change path to where you saved the following file "hh14_all_dta/b1_ks0.dta"
/*EXAMPLE*/
merge 1:1 hhid14 using "IFLS/Round 5/hh14_all_dta/b1_ks0.dta", nogenerate
/**/

*Substract value of food given to person out of HH
replace weeklyfoodconsump=weeklyfoodconsump-ks04b
replace weeklyfoodconsump=. if ks04bx!=1

keep hhid14 weeklyfoodconsump

*TO DO: decide whether you need/want to change path for saving consumpexp
/**/
save consumpexp, replace
/**/

clear
*TO DO: change path to where you saved the following file "hh14_all_dta/b1_ks2.dta"
/*EXAMPLE*/
use "IFLS/Round 5/hh14_all_dta/b1_ks2.dta"
/**/
replace ks06=. if ks06x!=1

bysort hhid14: egen monthlynonfoodexp=total(ks06), m

keep hhid14 monthlynonfoodexp
duplicates drop

*TO DO: change path to where you saved the following file "hh14_all_dta/b1_ks0.dta"
/*EXAMPLE*/
merge 1:1 hhid14 using "IFLS/Round 5/hh14_all_dta/b1_ks0.dta", nogenerate
/**/

*Add value of nonfood items consumed that HH self-produced or received from another source
replace monthlynonfoodexp=monthlynonfoodexp+ks07a
replace  monthlynonfoodexp=. if ks07ax==1

keep hhid14 monthlynonfoodexp

*TO DO: change path to where you saved the following file "consumpexp.dta"
/*EXAMPLE*/
merge 1:1 hhid14 using consumpexp, nogenerate
/**/


*TO DO: decide whether you need/want to change path for saving consumpexp
/**/
save consumpexp, replace
/**/


clear
*TO DO: change path to where you saved the following file "hh14_all_dta/b1_ks3.dta"
/*EXAMPLE*/
use "IFLS/Round 5/hh14_all_dta/b1_ks3.dta"
/**/

foreach var of varlist ks08 ks09a{
replace `var'=. if `var'x!=1
}

egen help=rowtotal(ks08 ks09a), m 
bysort hhid14: egen yearlynonfoodexp=total(help), m

keep hhid14 yearlynonfoodexp
duplicates drop

*TO DO: change path to where you saved the following file "consumpexp.dta"
/*EXAMPLE*/
merge 1:1 hhid14 using consumpexp, nogenerate
/**/

*TO DO: decide whether you need/want to change path for saving consumpexp
/**/
save consumpexp, replace
/**/

clear
*TO DO: change path to where you saved the following file "hh14_all_dta/b1_ks0.dta"
/*EXAMPLE*/
use "IFLS/Round 5/hh14_all_dta/b1_ks0.dta"
/**/

foreach var of varlist ks10aa ks10ab ks11aa ks11ab ks12aa ks12ab ks12bb{
replace `var'=. if `var'x!=1
}

egen yearlyeducexp=rowtotal(ks10aa ks10ab ks11aa ks11ab ks12aa ks12ab ks12bb),m

keep hhid14 yearlyeducexp

*TO DO: change path to where you saved the following file "consumpexp.dta"
/*EXAMPLE*/
merge 1:1 hhid14 using consumpexp, nogenerate
/**/

replace monthlynonfoodexp=12*monthlynonfoodexp
replace weeklyfoodconsump=52*weeklyfoodconsump
egen hh_exp=rowtotal(yearlynonfoodexp yearlyeducexp monthlynonfoodexp weeklyfoodconsump), missing

keep hhid14 hh_exp
*TO DO: decide whether you need/want to change path for saving consumpexp
/**/
save consumpexp, replace
/**/

clear
*TO DO: change path to where you saved the following file "hh14_all_dta/bk_ar1.dta"
/*EXAMPLE*/
use "IFLS/Round 5/hh14_all_dta/bk_ar1.dta"
/**/
drop if ar01a==0 | ar01a==3

bysort hhid14: egen help=seq()
bysort hhid14: egen hhsize=max(help)
*I find the hhsize pretty small with a mean of 3.7, but I calculated it the way I was told to do by RAND
keep hhid14 hhsize

duplicates drop

*TO DO: change path to where you saved the following file "consumpexp.dta"
/*EXAMPLE*/
merge 1:1 hhid14 using consumpexp, nogenerate keep (2 3)
/**/

g pcexpend=hh_exp/hhsize

keep hhid14 pcexpend

*TO DO: decide whether you need/want to change path for saving consumpexp
/**/
save consumpexp, replace
/**/

*TO DO: change path to where you saved the following file "IFLS5.dta"
/*EXAMPLE*/
merge 1:m hhid14 using IFLS5, nogenerate keep(match using)
/**/

*TO DO: decide whether you need/want to change path for saving IFLS5
/**/
save IFLS5, replace
/**/

*Exchange rate for approximate midpoint of survey period
/*	From User's Guide Vol. 1 (p. 25):
	"field work took place largely between late October 2014 and the end of
	April 2015, with long distance tracking extending through the end of August 2015."
	From User's Guide Vol. 1 (p. 23):
	"There were two phases of fieldwork, main field work and the tracking period.
	The main fieldwork periods went from September 2014 to first week of May 2015.
	As teams finished their main fieldwork period they began their long-distance
	tracking phase (from roughly mid-May to end of September)." 
-> I chose as approximate midpoint of survey: January 31, 2015
*/


g excrate=0.00008
label var excrate "Local to USD exchange rate at time of survey"

g excratemonth="1-2015"


*TO DO: decide whether you need/want to change path for saving IFLS5
/**/
save IFLS5, replace
/**/

*Include baseline vars for round 5

clear
*TO DO: change path to where you saved the following file "hh14_all_dta/bk_ar1.dta"
/*EXAMPLE*/
use "IFLS/Round 5/hh14_all_dta/bk_ar1.dta"
/**/

replacetomissings ar09

*Child under 5 in household
g under5=0
replace under5=. if ar09==. 
replace under5=1 if ar09<5 
bysort hhid14: egen childunder5=max(under5)
drop under5

*Child aged 5 to 12 in household
g aged5to12=0
replace aged5to12=. if ar09==. 
replace aged5to12=1 if ar09>=5 & ar09<12
bysort hhid14: egen childaged5to12=max(aged5to12)
drop aged5to12

*Has adult aged 65+ in the household
g is65orover=0
replace is65orover=. if ar09==. 
replace is65orover=1 if ar09>=65 & ar09!=. 
bysort hhid14: egen adult65andover=max(is65orover)
drop is65orover

*Marital status of owner
g married=(ar13==2) if ar13!=.

*Education of owner
replacetomissings ar16
g ownertertiary=(ar16==60 | ar16==61 | ar16==62 | ar16==63) if ar16!=.

replacetomissings ar17
*Years of education
*None
g educyears=0 if (ar16==1 | ar16==90)
*Elementary School
replace educyears=ar17 if (ar16==2 | ar16==72)
replace educyears=6 if ar17==7 & (ar16==2 | ar16==72)
*Junior High
replace educyears=ar17+6 if (ar16==3 | ar16==4 | ar16==73)
replace educyears=3+6 if ar17==7 & (ar16==3 | ar16==4 | ar16==73)
*High School
replace educyears=ar17+9 if (ar16==5 | ar16==6 | ar16==74)
replace educyears=3+9 if ar17==7 & (ar16==5 | ar16==6 | ar16==74)
*Tertiary education
replace educyears=ar17+12 if (ar16==60 | ar16==61)
replace educyears=4+12 if ar17==7 & (ar16==60 | ar16==61)
replace educyears=ar17+16 if (ar16==62)
replace educyears=2+16 if ar17==7 & (ar16==62)
replace educyears=ar17+18 if (ar16==63)
replace educyears=3+16 if ar17==7 & (ar16==63)

keep hhid14 pid14 childunder5-educyears

*TO DO: change path to where you saved the following file "IFLS5.dta"
/*EXAMPLE*/
merge 1:1 hhid14 pid14 using IFLS5, nogenerate  keep(2 3)
/**/

*TO DO: decide whether you need/want to change path for saving IFLS5
/**/
save IFLS5, replace
/**/

clear

*TO DO: change path to where you saved the following file "hh14_all_dta/ek_ek1.dta"
/*EXAMPLE*/
use "IFLS/Round 5/hh14_all_dta/ek_ek1.dta"
/**/
*Raven progressive matrices score
*I compute the score as the percentage of correct answers for questions ek01-ek12
foreach var of varlist ek1x-ek12x{
replace `var'=(`var'==1) if `var'!=9
replace `var'=. if `var'==9
}

egen raven=rowtotal(ek1x-ek12x),m
replace raven=raven/12

keep pidlink raven

*TO DO: change path to where you saved the following file "IFLS5.dta"
/*EXAMPLE*/
merge 1:1 pidlink using IFLS5, nogenerate  keep(2 3)
/**/

*TO DO: decide whether you need/want to change path for saving IFLS5
/**/
save IFLS5, replace
/**/

*TO DO: change path to where you saved the following file "hh14_all_dta/bk_sc1.dta"
/*EXAMPLE*/
merge m:1 hhid14 using "IFLS/Round 5/hh14_all_dta/bk_sc1.dta",  keepusing(sc05) nogenerate keep(match master) 
/**/

g urban=(sc05==1)

drop sc05 

*TO DO: decide whether you need/want to change path for saving IFLS5
/**/
save IFLS5, replace
/**/

/* MERGE IFLS3-5, CLEAN IT AND DO ANALYSIS*/
********************************************************************************
*Merge business information from all rounds to create survival, newfirmstarted and attrition variables
********************************************************************************
clear
*TO DO: change path to where you saved the following file "IFLS3.dta"
/*EXAMPLE*/
use IFLS3
/**/

keep hhid00 hhbus nt01a nt05aa0 nt05ab interviewmonth2000 fieldofbus nt15yr startofbus agefirm tbdropped3
duplicates drop

rename hhid00 hhid

foreach var of varlist  hhbus nt01a nt05aa0 nt05ab fieldofbus nt15yr startofbus agefirm tbdropped3{
rename `var' `var'2000
}
*There is one duplicate in hhid. I drop these obs:
duplicates tag hhid, gen(dupl_hhid)
drop if dupl>0
drop dupl

*TO DO: decide whether you need/want to change path for saving survivalnf3
/**/
save survivalnf3, replace
/**/

clear
*TO DO: change path to where you saved the following file "IFLS4.dta"
/*EXAMPLE*/
use IFLS4
/**/
keep hhid07 hhbus nt01a nt05aa nt05ab interviewmonth2007 ivwyr1 fieldofbus nt15x nt15mth nt15myr startofbus agefirm tbdropped4
duplicates drop

rename hhid07 hhid

foreach var of varlist  hhbus nt01a nt05aa nt05ab ivwyr1  fieldofbus nt15x nt15mth nt15myr startofbus agefirm tbdropped4{
rename `var' `var'2007
}

*TO DO: decide whether you need/want to change path for saving survivalnf4
/**/
save survivalnf4, replace
/**/

clear
*TO DO: change path to where you saved the following file "IFLS5.dta"
/*EXAMPLE*/
use IFLS5
/**/

keep hhid14 hhbus nt01a nt05aa nt05ab interviewmonth2014 fieldofbus nt15x nt15m nt15y startofbus agefirm tbdropped5
duplicates drop

rename hhid14 hhid

foreach var of varlist  hhbus nt01a nt05aa nt05ab fieldofbus nt15x nt15m nt15y startofbus agefirm tbdropped5{
rename `var' `var'2014
}


*TO DO: decide whether you need/want to change path for saving survivalnf5
/**/
save survivalnf5, replace
/**/

*Survival from round 1 to round 2

clear
*TO DO: change path to where you saved the following file "survivalnf3.dta"
/*EXAMPLE*/
use survivalnf3
/**/

*TO DO: change path to where you saved the following file "survivalnf4.dta"
/*EXAMPLE*/
merge 1:1 hhid using survivalnf4, keep(1 3)
/**/

g survival2007=0 if hhbus2000==1 & hhbus2007==0 & tbdropped32000==0 & tbdropped42007==0
g newfirmstarted2007=0 if  hhbus2000==1 &  hhbus2007==0 & tbdropped32000==0 & tbdropped42007==0

/*A firm is coded as surviving in 2007 if the household had one firm in 2000 and
 one firm in 2007, and the startdates of years of the business start are identical*/
replace survival2007=1 if hhbus2000==1 & hhbus2007==1 & nt01a2000==1 & nt01a2007==1 & (startofbus2000==startofbus2007 | nt15yr2000==nt15myr2007) & startofbus2000!=. & startofbus2007!=. 

/* A firm is coded as as a new firm if the startdate in 2007 was given as being after 2000.
	Survival is coded as missing in that case*/
replace newfirmstarted2007=1 if hhbus2000==1 & hhbus2007==1 & nt01a2000==1 & nt01a2007==1 & startofbus2000!=startofbus2007 & nt15yr2000!=nt15myr2007 & nt15myr2007>2000 & startofbus2007!=. & nt15myr2007!=.
replace newfirmstarted2007=0 if hhbus2000==1 & hhbus2007==1 & nt01a2000==1 & nt01a2007==1 & startofbus2000==startofbus2007 & startofbus2007!=. 
replace newfirmstarted2007=1 if hhbus2000==0 & hhbus2007==1 &  nt01a2007==1 & ((startofbus2007>interviewmonth2000)|(startofbus2007>2000 & (nt15x2007==8 | nt15x2007==9 | nt15mth2007==.))) & startofbus2007!=. & tbdropped32000==0 & tbdropped42007==0
replace newfirmstarted2007=0 if hhbus2000==0 & hhbus2007==1 &  nt01a2007==1 & ((startofbus2007<=interviewmonth2000)|(startofbus2007<=2000 & (nt15x2007==8 | nt15x2007==9 | nt15mth2007==.))) & startofbus2007!=. & tbdropped32000==0 & tbdropped42007==0

/*If the field of the business remains the same across both waves, and the startyear
 in 2007 is different to the one indicated in 2000 but the 2007-startyear is not a year
 after 2000,I code the business as surviving.*/
replace survival2007=1 if hhbus2000==1 & hhbus2007==1 & tbdropped32000==0 & tbdropped42007==0 & startofbus2000!=startofbus2007 & nt15yr2000!=nt15myr2007 & nt15myr2007<=2000 & fieldofbus2000==fieldofbus2007 

/* If at least one owner (person(s) responsible for the business) remains the same
 across both waves, and the startyear in 2007 is different to the one indicated in 2000 but the 2007-startyear is not a year
 after 2000,I code the business as surviving.*/
replace survival2007=1 if hhbus2000==1 & hhbus2007==1 & tbdropped32000==0 & tbdropped42007==0 & startofbus2000!=startofbus2007 & nt15yr2000!=nt15myr2007 & nt15myr2007<=2000 & fieldofbus2000!=fieldofbus2007 & (nt05aa02000==nt05aa2007 | nt05aa02000==nt05ab2007 | nt05ab2000==nt05aa2007 | nt05ab2000==nt05ab2007)

keep hhid newfirmstarted2007 survival2007	
*TO DO: decide whether you need/want to change path for saving survivalnf00_07
/**/							
save survivalnf00_07, replace 
/**/

*Survival from round 1 to round 3
clear
*TO DO: change path to where you saved the following file "survivalnf3.dta"
/*EXAMPLE*/
use survivalnf3
/**/

*TO DO: change path to where you saved the following file "survivalnf5.dta"
/*EXAMPLE*/
merge 1:1 hhid using survivalnf5,keep(1 3)
/**/

g survival2014=0 if hhbus2000==1 & hhbus2014==0 & tbdropped32000==0 & tbdropped52014==0
g newfirmstarted2014=0 if  hhbus2000==1 &  hhbus2014==0 & tbdropped32000==0 & tbdropped52014==0

/*A firm is coded as surviving in 2014 if the household had one firm in 2000 and
 one firm in 2014, and the startdates of years of the business start are identical*/
replace survival2014=1 if hhbus2000==1 & hhbus2014==1 & nt01a2000==1 & nt01a2014==1 & (startofbus2000==startofbus2014 | nt15yr2000==nt15y2014) & startofbus2000!=. & startofbus2014!=. 

/* A firm is coded as as a new firm if the startdate in 2014 was given as being after 2000.
	Survival is coded as missing in that case*/
replace newfirmstarted2014=1 if hhbus2000==1 & hhbus2014==1 & nt01a2000==1 & nt01a2014==1 & startofbus2000!=startofbus2014 & nt15yr2000!=nt15y2014 & nt15y2014>2000 & startofbus2014!=. & nt15y2014!=.
replace newfirmstarted2014=0 if hhbus2000==1 & hhbus2014==1 & nt01a2000==1 & nt01a2014==1 & startofbus2000==startofbus2014 & startofbus2014!=. 
replace newfirmstarted2014=1 if hhbus2000==0 & hhbus2014==1 &  nt01a2014==1 & ((startofbus2014>interviewmonth2000)|(startofbus2014>2000 & (nt15x2014==8 | nt15x2014==9 | nt15m2014==.))) & startofbus2014!=. & tbdropped32000==0 & tbdropped52014==0
replace newfirmstarted2014=0 if hhbus2000==0 & hhbus2014==1 &  nt01a2014==1 & ((startofbus2014<=interviewmonth2000)|(startofbus2014<=2000 & (nt15x2014==8 | nt15x2014==9 | nt15m2014==.))) & startofbus2014!=. & tbdropped32000==0 & tbdropped52014==0

/*If the field of the business remains the same across both waves, and the startyear
 in 2014 is different to the one indicated in 2000 but the 2000-startyear is not a year
 after 2000,I code the business as surviving.*/
replace survival2014=1 if hhbus2000==1 & hhbus2014==1 & tbdropped32000==0 & tbdropped52014==0 & startofbus2000!=startofbus2014 & nt15yr2000!=nt15y2014 & nt15y2014<=2000 & fieldofbus2000==fieldofbus2014 

/* If at least one owner (person(s) responsible for the business) remains the same
 across both waves, and the startyear in 2007 is different to the one indicated in 2000 but the 2007-startyear is not a year
 after 2000,I code the business as surviving.*/
replace survival2014=1 if hhbus2000==1 & hhbus2014==1 & tbdropped32000==0 & tbdropped52014==0 & startofbus2000!=startofbus2014 & nt15yr2000!=nt15y2014 & nt15y2014<=2000 & fieldofbus2000!=fieldofbus2014 & (nt05aa02000==nt05aa2014 | nt05aa02000==nt05ab2014 | nt05ab2000==nt05aa2014 | nt05ab2000==nt05ab2014)

keep hhid newfirmstarted2014 survival2014	
*TO DO: decide whether you need/want to change path for saving survivalnf00_14
/**/								
save survivalnf00_14, replace 
/**/

*Survival from round 2 to round 3
clear
*TO DO: change path to where you saved the following file "survivalnf4.dta"
/*EXAMPLE*/
use survivalnf4
/**/

*TO DO: change path to where you saved the following file "survivalnf5.dta"
/*EXAMPLE*/
merge 1:1 hhid using survivalnf5, keep(1 3)
/**/

*I assume that ivwyr=7 == 2007 and ivwyr=2008
replace ivwyr12007=2000+ivwyr12007

g survival0714=0 if hhbus2007==1 & hhbus2014==0 & tbdropped42007==0 & tbdropped52014==0
g newfirmstarted0714=0 if  hhbus2007==1 &  hhbus2014==0 & tbdropped42007==0 & tbdropped52014==0

/*A firm is coded as surviving in 2014 if the household had one firm in 2007 and
 one firm in 2014, and the startdates or years of the business start are identical*/
replace survival0714=1 if hhbus2007==1 & hhbus2014==1 & nt01a2007==1 & nt01a2014==1 & (startofbus2007==startofbus2014 | nt15myr2007==nt15y2014) & startofbus2007!=. & startofbus2014!=. 

/* A firm is coded as as a new firm if the startdate in 2014 was given as being after 2007.
	Survival is coded as missing in that case*/
replace newfirmstarted0714=1 if hhbus2007==1 & hhbus2014==1 & nt01a2007==1 & nt01a2014==1 & startofbus2007!=startofbus2014 & nt15myr2007!=nt15y2014 & nt15y2014>ivwyr12007 & startofbus2014!=. & nt15y2014!=.
replace newfirmstarted0714=0 if hhbus2007==1 & hhbus2014==1 & nt01a2007==1 & nt01a2014==1 & startofbus2007==startofbus2014 & startofbus2014!=. 
replace newfirmstarted0714=1 if hhbus2007==0 & hhbus2014==1 &  nt01a2014==1 & ((startofbus2014>interviewmonth2007)|(startofbus2014>=ivwyr12007 & (nt15x2014==8 | nt15x2014==9 | nt15m2014==.))) & startofbus2014!=. & tbdropped42007==0 & tbdropped52014==0
replace newfirmstarted0714=0 if hhbus2007==0 & hhbus2014==1 &  nt01a2014==1 & ((startofbus2014<=interviewmonth2007)|(startofbus2014<=ivwyr12007 & (nt15x2014==8 | nt15x2014==9 | nt15m2014==.))) & startofbus2014!=. & tbdropped42007==0 & tbdropped52014==0

/*If the field of the business remains the same across both waves, and the startyear
 in 2014 is different to the one indicated in 2007 but the 2007-startyear is not a year
 after 2007 or 2008,I code the business as surviving.*/
replace survival0714=1 if hhbus2007==1 & hhbus2014==1 & tbdropped42007==0 & tbdropped52014==0 & startofbus2007!=startofbus2014 & nt15myr2007!=nt15y2014 & nt15y2014<=ivwyr12007 & fieldofbus2007==fieldofbus2014 

/* If at least one owner (person(s) responsible for the business) remains the same
 across both waves, and the startyear in 2007 is different to the one indicated in 2000 but the 2007-startyear is not a year
 after 2000,I code the business as surviving.*/
replace survival0714=1 if hhbus2007==1 & hhbus2014==1 & tbdropped42007==0 & tbdropped52014==0 & startofbus2007!=startofbus2014 & nt15myr2007!=nt15y2014 & nt15y2014<=ivwyr12007 & fieldofbus2007!=fieldofbus2014 & (nt05aa2007==nt05aa2014 | nt05aa2007==nt05ab2014 | nt05ab2007==nt05aa2014 | nt05ab2007==nt05ab2014)

keep hhid newfirmstarted0714 survival0714		
*TO DO: decide whether you need/want to change path for saving survivalnf07_14
/**/							
save survivalnf07_14, replace 
/**/
********************************************************************************
*Merge the datasets to create the IFLS_master dataset
********************************************************************************

clear
*TO DO: change path to where you saved the following file "IFLS_3-5.dta"
/*EXAMPLE*/
use IFLS_3-5
/**/

order 	pidlink hhid00 pid00 hhid07 pid07 hhid14 pid14 ///
		result00 result07 result14 ///
		res00b1 res00b2 res00bk res07b1 res07b2 res07bk res14b1 res14b2 res14bk ///
		res00b3a res00b3b res00ek res07b3a res07b3b res07bek1 res07bek2 res14b3a res14b3b res14bek ///
		country ///
		ownerage2000 female married ownertertiary educyears childunder5 childaged5to12 adult65andover raven ///
		familyill

drop ar01a_14-res14us

*TO DO: change path to where you saved the following file "IFLS3.dta"
/*EXAMPLE*/
merge 1:1 pidlink using IFLS3, keep(3) nogenerate
/**/

order 	wave surveyyear interviewmonth2000 ///
		hhbus primarilyresponsible1 primarilyresponsible2 ///
		enf_bus tbdropped ///
		agefirm x_agefirm ///
		fieldofbus ///
		urban ///
		employees totalworkers capitalstock profits sales  expenses selfemployed hours* wageworker laborincome retired pcexpend excrate excratemonth ///
		, after(familyill)

foreach var of 	varlist	wave surveyyear ///
						female married ownertertiary educyears childunder5 childaged5to12 adult65andover raven familyill ///
						hhbus primarilyresponsible1 primarilyresponsible2 ///
						enf_bus tbdropped ///
						agefirm x_agefirm ///
						fieldofbus ///
						urban ///
						employees totalworkers capitalstock profits sales expenses selfemployed hours* wageworker laborincome retired excrate excratemonth{
						
rename `var' `var'2000
} 
						
drop rspndnt-closeddown

*TO DO: change path to where you saved the following file "IFLS4.dta"
/*EXAMPLE*/
merge 1:1 pidlink using IFLS4, keep(1 3) generate(merge1)
/**/

g attrit=(merge1==1)

order   attrit wave surveyyear interviewmonth2007 ///
		ownerage2007 married ownertertiary educyears childunder5 childaged5to12 adult65andover raven ///
		hhbus primarilyresponsible1 primarilyresponsible2 ///
		enf_bus tbdropped4 ///
		agefirm x_agefirm ///
		fieldofbus ///
		urban ///
		employees totalworkers capitalstock profits sales* expenses* selfemployed hours* wageworker laborincome retired pcexpend2007 excrate excratemonth ///
		dead ///
		, after(excrate2000)
		
foreach var of 	varlist	attrit wave surveyyear ///
						married ownertertiary educyears childunder5 childaged5to12 adult65andover raven ///
						hhbus primarilyresponsible1 primarilyresponsible2 ///
						enf_bus tbdropped4 ///
						agefirm x_agefirm ///
						fieldofbus ///
						urban ///
						employees totalworkers capitalstock profits sales sales_2maa4 sales_4maa sales_4maa8 sales_8maa expenses expenses_2maa4 expenses_4maa expenses_4maa8 expenses_8maa selfemployed hours hoursnormal wageworker laborincome retired excrate excratemonth dead{
						
rename `var' `var'2007
} 

 
drop rsnpndnt-closeddown

 
/*In order to be able to merge this information with the one from the survivalnf dataset,
I need to create a var "hhid" out of hhid00 that is only "active" if the hh remains
 the same between 2000 and 2007:*/

g hhid=hhid00 if hhid07==hhid00 & attrit2007!=1

*TO DO: change path to where you saved the following file "survivalnf00_07.dta"
/*EXAMPLE*/
merge m:1 hhid using survivalnf00_07,  keep(1 3)	
/**/

drop hhid

*TO DO: change path to where you saved the following file "IFLS5.dta"
/*EXAMPLE*/
merge 1:1 pidlink using IFLS5, keep(1 3) generate(merge2)
/**/

g attrit0714=(merge2==1)
g attrit=((merge1==1 | merge1==3) & merge2==1)


order   attrit wave surveyyear interviewmonth2014 ///
		ownerage2014 married ownertertiary educyears childunder5 childaged5to12 adult65andover raven ///
		hhbus primarilyresponsible1 primarilyresponsible2 ///
		enf_bus tbdropped5 ///
		agefirm x_agefirm ///
		fieldofbus ///
		urban ///
		employees totalworkers profits sales sales_4maa6 sales_6maa10 sales_10maa expenses expenses_4maa6 expenses_6maa10 expenses_10maa selfemployed hours  wageworker laborincome retired pcexpend excrate excratemonth ///
		dead ///
		, after(newfirmstarted2007)
		
foreach var of 	varlist	attrit wave surveyyear ///
						married ownertertiary educyears childunder5 childaged5to12 adult65andover raven ///
						hhbus primarilyresponsible1 primarilyresponsible2 ///
						enf_bus tbdropped5 ///
						agefirm x_agefirm ///
						fieldofbus ///
						urban ///
						employees totalworkers profits sales sales_4maa6 sales_6maa10 sales_10maa expenses expenses_4maa6 expenses_6maa10 expenses_10maa selfemployed hours hoursnormal wageworker laborincome retired  pcexpend excrate excratemonth dead{
						
rename `var' `var'2014
} 

drop rspndnt-merge2

 
/*In order to be able to merge this information with the one from the survivalnf dataset,
I need to create a var "hhid" out of hhid00 that is only "active" if the hh remains
 the same between 2000 and 2014:*/

g hhid=hhid00 if hhid14==hhid00 & attrit2014!=1

*TO DO: change path to where you saved the following file "survivalnf00_14.dta"
/*EXAMPLE*/
merge m:1 hhid using survivalnf00_14, nogenerate keep(1 3)	
/**/
drop hhid


/*In order to be able to merge this information with the one from the survivalnf dataset,
I need to create a var "hhid" out of hhid00 that is only "active" if the hh remains
 the same between 2007 and 2014:*/

g hhid=hhid07 if hhid14==hhid07 & attrit2014!=1

*TO DO: change path to where you saved the following file "survivalnf07_14"
/*EXAMPLE*/
merge m:1 hhid using survivalnf07_14, nogenerate keep(1 3)	
/**/
drop hhid

*TO DO: decide whether you need/want to change path for saving IFLS_master
/**/		
save IFLS_master, replace
/**/

********************************************************************************
*Cleaning it up:
********************************************************************************
*Keep if the household operated a household in at least one of the three rounds
keep if hhbus2000==1 |  hhbus2007==1 | hhbus2014==1 

*Drop if the household operated more than one business in any of the three rounds:
drop if tbdropped32000==1 | tbdropped42007==1 | tbdropped5==1

*Keep the business owners:
keep if primarilyresponsible12000==1 | primarilyresponsible22000==1 | primarilyresponsible12007==1 | primarilyresponsible22007==1 | primarilyresponsible12014==1 | primarilyresponsible22014==1

/*Replace missings for businessowners if the household is not operating a household
 business in that round:*/
foreach x in 2000 2007 2014{
forvalues i=1/2{
replace primarilyresponsible`i'`x'=0 if hhbus`x'==0 & primarilyresponsible`i'`x'==.
}
}

/*Flag if businesses are jointly operated and appear more than once, since they appear
with different owners*/
foreach x in 00 07 14{
rename hhid`x' hhid20`x'
}

foreach x in 2000 2007 2014{
g responsible`x'=(primarilyresponsible1`x'==1 | primarilyresponsible2`x'==1 )
duplicates tag hhid`x' responsible`x' agefirm`x' x_agefirm`x' employees`x' profits`x' sales`x' if hhbus`x'==1, gen(totalowners`x')

replace totalowners`x'=totalowners`x'+1

g jointbus`x'=(totalowners`x'>1) if hhbus`x'==1
}
/*
*Generate a joint survival variable for survival from round 1 to round 3
replace survival2014=survival0714 if survival0714!=.
*/

*TO DO: decide whether you need/want to change path for saving IFLS_master
/*		*/
save IFLS_master, replace
/**/

*Identify the individual businesses
keep hhid*
duplicates drop
*TO DO: decide whether you need/want to change path for saving helpIFLS_master
/**/	 	
save helpIFLS_master, replace
/**/

g splitoff2007=0 if hhid2000==hhid2007 & hhid2000!="" & hhid2007!=""
replace splitoff2007=1 if hhid2000!=hhid2007 & hhid2000!="" & hhid2007!=""

g splitoff2014=0 if  hhid2007==hhid2014 & hhid2007!="" & hhid2014!=""
replace splitoff2014=1 if hhid2007!=hhid2014 & hhid2007!="" & hhid2014!=""

*TO DO: change path to where you saved the following file "IFLS_master"
/*EXAMPLE*/
merge 1:m hhid2000 hhid2007 hhid2014 using IFLS_master, nogenerate
/**/

rename female2000 female

*Replace values of previous waves to missing if household is a splitoff household
ds *2000, has(type numeric)
foreach var of varlist `r(varlist)' /*hhbus2000 primarilyresponsible12000 primarilyresponsible22000 enf_bus2000 agefirm2000 x_agefirm2000 fieldofbus2000 employees2000 totalworkers2000 capitalstock2000 profits2000 selfemployed2000 wageworker2000 laborincome2000 retired2000 pcexpend2000 excrate2000 sales2000 expenses2000 hours2000 hoursnormal2000 responsible2000 totalowners2000 jointbus2000*/{
replace `var'=. if splitoff2007==1 | splitoff2014==1
}

ds *2000, not(type numeric) 
foreach var of varlist `r(varlist)'{
replace `var'="" if splitoff2007==1 | splitoff2014==1
}

*Replace values of previous waves to missing if household is a splitoff household
ds *2007, has(type numeric)
foreach var of varlist `r(varlist)' {
replace `var'=. if splitoff2014==1
}

ds *2007, not(type numeric) 
foreach var of varlist `r(varlist)'{
replace `var'="" if splitoff2014==1
}

*Generate firm (and owner) identification number in survey
*Firm identification

egen help2000=group(hhid2000) if hhbus2000==1, missing
egen help2007=group(hhid2007) if hhbus2007==1, missing
egen help2014=group(hhid2014) if hhbus2014==1, missing
egen help=group(hhid2000 hhid2007 hhid2014), m

*Create a variable for inclusion of jointly operated businesses only once:

*For business operated by only one hh_member (4,204 obs.):
duplicates tag help, gen(dupl_hhfirm)
g incl=1 if dupl_hhfirm==0

/*Given that there are jointly owned firms, I create a new variable,
 that has three categories: male (base category), female and jointly operated*/
foreach x in 2000 2007 2014{
g mfj`x'=female if jointbus`x'==0
replace mfj`x'=2 if jointbus`x'==1
}

*TO DO: decide whether you need/want to change path for saving IFLS_master
/*	*/	
save IFLS_master, replace
/**/

drop splitoff2007 splitoff2014 pid00-pid14 result* res00* res07b* res14b* res00b3a* interviewmonth* enf_bus* tbdropped* merge* _merge help* 
destring hhid2000-hhid2014, replace
egen hhid=rowmax(hhid2000-hhid2014)
drop hhid2000-hhid2014


quietly: reshape long wave surveyyear ownerage familyill married ownertertiary educyears childunder5 childaged5to12 adult65andover raven pcexpend excrate excratemonth selfemployed hours hoursnormal wageworker laborincome retired hhbus agefirm x_agefirm capitalstock employees totalworkers sales sales_4maa sales_2maa4 sales_4maa8 sales_8maa sales_4maa6 sales_6maa10 sales_10maa expenses_4maa expenses_2maa4 expenses_4maa8 expenses_8maa expenses_4maa6 expenses_6maa10 expenses_10maa expenses profits jointbus dead fieldofbus urban mfj, i(hhid pidlink) j(survey)

			
*keep if household operates a business in any round
keep if hhbus==1


*keep the businessowners:
foreach x in 2000 2007 2014{
g businessowner`x'=primarilyresponsible1`x'==1 | primarilyresponsible2`x'==1
}

keep if businessowner2000==1 | businessowner2007==1 | businessowner2014==1

*keep if firm has an owner in the sample
foreach x in businessowner2000 businessowner2007 businessowner2014{
bysort hhid: egen total`x'=total(`x')
}

g test=0
foreach x in 2000 2007 2014{
replace test=1 if surveyyear==`x' & totalbusinessowner`x'>=1
}

drop if test==0
drop test

*7 years		
g attrit_7yrs=.
g survival_7yrs=.
g newfirmstarted_7yrs=.


foreach x in attrit survival newfirmstarted{
replace `x'_7yrs=`x'0714 if surveyyear==2007
drop `x'0714
}
		
*7.5 years		
g attrit_7p5yrs=.
g survival_7p5yrs=.
g newfirmstarted_7p5yrs=.


foreach x in attrit survival newfirmstarted{
replace `x'_7p5yrs=`x'2007 if surveyyear==2000
drop `x'2007
}

*14.5 years		
g attrit_14p5yrs=.
g survival_14p5yrs=.
g newfirmstarted_14p5yrs=.


foreach x in attrit survival newfirmstarted{
replace `x'_14p5yrs=`x'2014 if surveyyear==2000
drop `x'2014
}


*Coding didn't pick this up correctly
foreach x in 7yrs 7p5yrs 14p5yrs{
replace newfirmstarted_`x'=0 if survival_`x'==1
}

sort hhid surveyyear
bysort hhid: egen help1=min(surveyyear)
order surveyyear help1, after(survey)
g help21=surveyyear-help1
order help21, after(help1)

g help1_1=newfirmstarted_7p5yrs if help21==0 & surveyyear==2000
replace help1_1=newfirmstarted_7yrs if help21==0 & surveyyear==2007

g help1_2=newfirmstarted_14p5yrs if help21==0 & surveyyear==2000
order help1_2, after(help1_1)

replace help21=1 if help21==7
replace help21=2 if help21==14

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


g help2_1=newfirmstarted_7yrs if help22==0 & surveyyear==2007

g help2_2=.

local i=2
forvalues k=1/2{
bysort hhid: egen help2`i'_`k'=total(help`i'_`k'), m
}

replace help22=1 if help22==7

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


g period_3=3 if surveyyear==2014 & period_1==. & period_2==.

egen period=rowtotal(period_1-period_3),m
order period, after(pidlink)
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

*TO DO: decide whether you need/want to change path for saving IFLS_masterfc
/*	*/	
save IFLS_masterfc, replace
/**/

*For check=1
*If for the period survival has been coded -> this will determine sameaszero
tab survival_7p5yrs help1_1 if maxperiod==3 & surveyyear==2000, m
tab survival_14p5yrs help1_2 if maxperiod==3 & surveyyear==2000, m
tab survival_7yrs help2_1 if maxperiod==3 & period==2 & surveyyear==2007, m


tab survival_7p5yrs help1_1 if maxperiod==2 & surveyyear==2000, m
tab survival_7yrs help1_1 if maxperiod==2 & period==1 & surveyyear==2007, m

*There are no such cases!

*Problem: There is no variable on firm closure in the data set

*Rules
*If firm in t+1 or t+2 younger than t+x - t -> newfirmstarted
g minsvy=help1
bysort hhid: egen maxsvy=max(surveyyear)

g hlpnf0007=1 if maxperiod==3 & period==2 & surveyyear==2007 & agefirm<7.5 & sameaszero1==.
replace hlpnf0007=1 if maxperiod==2 & period==2 & surveyyear==2007 & agefirm<7.5 & sameaszero1==.
g hlpnf0014=1 if maxperiod==3 & period==3 & surveyyear==2014 & agefirm<14.5 &  sameaszero1==.
replace hlpnf0014=1 if maxperiod==2 & period==2 & surveyyear==2014 & minsvy==2000 & agefirm<14.5 & sameaszero1==.
g hlpnf0714=1 if maxperiod==2 & period==2 & surveyyear==2014 & minsvy==2007 & agefirm<7 & sameaszero1==.
replace hlpnf0714=1 if maxperiod==3 & period==2 & surveyyear==2007 & agefirm<7 &  sameaszero2==.

foreach x in nf0007 nf0014 nf0714{
bysort hhid: egen `x'=total(hlp`x')
replace `x'=(`x' >= 1) if `x'!=.
}

replace sameaszero1=0 if sameaszero1==. & maxperiod==3 & period==2 & surveyyear==2007 & agefirm<7.5 & nf0007==1
replace newfirmstarted_7p5yrs=1 if  newfirmstarted_7p5yrs!=1 & maxperiod==3 & period==1 & surveyyear==2000 & nf0007==1
replace sameaszero1=0 if sameaszero1==. & maxperiod==2 & period==2 & surveyyear==2007 & agefirm<7.5 & nf0007==1
replace newfirmstarted_7p5yrs=1 if  newfirmstarted_7p5yrs!=1 & maxperiod==2 & period==1 & surveyyear==2000 & nf0007==1
replace sameaszero1=0 if sameaszero1==. & maxperiod==3 & period==3 & surveyyear==2014 & agefirm<14.5 & nf0014==1
replace newfirmstarted_14p5yrs=1 if newfirmstarted_14p5yrs!=1 & maxperiod==3 & period==1 & surveyyear==2000 & nf0014==1
replace sameaszero1=0 if sameaszero1==. & maxperiod==2 & period==2 & surveyyear==2014 & minsvy==2000  & agefirm<14.5 & nf0014==1
replace newfirmstarted_14p5yrs=1 if newfirmstarted_14p5yrs!=1 & maxperiod==2 & period==1 & surveyyear==2000 & minsvy==2000 & nf0014==1
replace sameaszero1=0 if sameaszero1==. & maxperiod==2 & period==2 & surveyyear==2014 & agefirm<7 & nf0714==1
replace newfirmstarted_7yrs=1 if newfirmstarted_7yrs!=1 & maxperiod==2 & period==1 & surveyyear==2007 & nf0714==1
replace sameaszero2=0 if sameaszero2==. & maxperiod==3 & period==3 & surveyyear==2014 & agefirm<7 & nf0714==1
replace newfirmstarted_7yrs=1 if newfirmstarted_7yrs!=1 & maxperiod==3 & period==2 & surveyyear==2007 & nf0714==1

*There are still 189 obs. with sameaszero1==.
*Out of these, 103 obs. have sameaszero1=. because agefirm==. -> I need to think about how to deal with these obs., especially if they are not the last period
*If they are missing in the first period, I can still use them -> there are no such obs.
*If they are missing in middle period?
*If they are missing in last period?

count if sameaszero1==. & agefirm==.
count if sameaszero1==. & agefirm==. & period==1
count if sameaszero1==. & agefirm==. & surveyyear==maxsvy
*76
count if sameaszero1==. & agefirm==. & surveyyear!=maxsvy & surveyyear!=minsvy
*27

*I drop them if they have missings in age, since this is important in determining survival or newfirmstart
g hlptbdropped=(sameaszero1==. & agefirm==.)
bysort hhid: egen tbdropped=max(hlptbdropped)
drop if tbdropped==1
drop tbdropped

*86 obs. / 51 hhids have sameaszero1==. due to other reasons, such as sector and/or owner changes
*-> code them manually

egen test=group(hhid) if sameaszero1==. & agefirm!=.
list test hhid if sameaszero1==. & agefirm!=.

*hhid=90600 - code as two different firms (1 in 2000 and another in 2007 and 2014)
local hhid=90600
replace sameaszero1=0 if hhid==`hhid' & surveyyear>=2007
replace newfirmstarted_7p5yrs=. if hhid==`hhid' & surveyyear==2000
replace survival_7p5yrs=. if hhid==`hhid' & surveyyear==2000

*hhid=141400 - code as two different firms since ages don't overlap, different sectors and different owners
local hhid=141400
replace sameaszero1=0 if hhid==`hhid' & surveyyear>=2007

*hhid=300831 - code as two different firms since ages don't overlap, different sectors and different owners
local hhid=300831
replace sameaszero1=0 if hhid==`hhid' & surveyyear>=2007

*hhid=362031 - code as different firms
local hhid=362031
replace sameaszero1=0 if hhid==`hhid' & surveyyear==2014

*hhid=421600 - different firms
local hhid=421600
replace sameaszero1=0 if hhid==`hhid' & surveyyear==2007

*hhid=472351 - code as same firm
local hhid=472351
replace sameaszero1=1 if hhid==`hhid' & surveyyear==2014
replace newfirmstarted_7yrs=0 if hhid==`hhid' & surveyyear==2007
replace survival_7yrs=1 if hhid==`hhid' & surveyyear==2007

*hhid=491051 - looks like temporary closing and reopening -> new firm
local hhid=491051 
replace sameaszero1=0 if hhid==`hhid' & surveyyear==2014
replace newfirmstarted_7yrs=1 if hhid==`hhid' & surveyyear==2007
replace survival_7yrs=0 if hhid==`hhid' & surveyyear==2007

*hhid=500300 - code as two different firms (1 in 2000 and another in 2007 and 2014)
local hhid=500300
replace sameaszero1=0 if hhid==`hhid' & surveyyear>=2007
replace newfirmstarted_7p5yrs=. if hhid==`hhid' & surveyyear==2000
replace survival_7p5yrs=. if hhid==`hhid' & surveyyear==2000

*hhid=560852 - looks like temporary closing and reopening -> new firm
local hhid=560852
replace sameaszero1=0 if hhid==`hhid' & surveyyear==2014
replace newfirmstarted_7yrs=1 if hhid==`hhid' & surveyyear==2007
replace survival_7yrs=0 if hhid==`hhid' & surveyyear==2007

*hhid=570752 - code as same firm
local hhid=570752
replace sameaszero1=1 if hhid==`hhid' & surveyyear==2014
replace newfirmstarted_7yrs=0 if hhid==`hhid' & surveyyear==2007
replace survival_7yrs=1 if hhid==`hhid' & surveyyear==2007

*hhid=640332 - code as same firm
local hhid=640332
replace sameaszero1=1 if hhid==`hhid' & surveyyear==2014
replace newfirmstarted_7yrs=0 if hhid==`hhid' & surveyyear==2007
replace survival_7yrs=1 if hhid==`hhid' & surveyyear==2007

*hhid=640751 - code as closure and new firm
local hhid=640751
replace sameaszero1=0 if hhid==`hhid' & surveyyear==2014
replace newfirmstarted_7yrs=1 if hhid==`hhid' & surveyyear==2007
replace survival_7yrs=0 if hhid==`hhid' & surveyyear==2007

*hhid=780731 - code same different businesses
local hhid=780731
replace sameaszero1=1 if hhid==`hhid' & surveyyear==2014
replace newfirmstarted_7yrs=0 if hhid==`hhid' & surveyyear==2007
replace survival_7yrs=1 if hhid==`hhid' & surveyyear==2007

*hhid=980251 - looks like temporary closing and reopening -> new firm
local hhid=980251
replace sameaszero1=0 if hhid==`hhid' & surveyyear==2014
replace newfirmstarted_7yrs=1 if hhid==`hhid' & surveyyear==2007
replace survival_7yrs=0 if hhid==`hhid' & surveyyear==2007

*hhid=991151 - code as same firm
local hhid=991151
replace sameaszero1=1 if hhid==`hhid' & surveyyear==2014
replace newfirmstarted_7yrs=0 if hhid==`hhid' & surveyyear==2007
replace survival_7yrs=1 if hhid==`hhid' & surveyyear==2007

*hhid=1101141 - code as same firm
local hhid=1101141
replace sameaszero1=1 if hhid==`hhid' & surveyyear==2014
replace newfirmstarted_7yrs=0 if hhid==`hhid' & surveyyear==2007
replace survival_7yrs=1 if hhid==`hhid' & surveyyear==2007

*hhid=1182200 - code as different businesses
local hhid=1182200
replace sameaszero1=0 if hhid==`hhid' & surveyyear==2007

*hhid=1211251 - same firm
local hhid=1211251
replace sameaszero1=1 if hhid==`hhid' & surveyyear==2014
replace newfirmstarted_7yrs=0 if hhid==`hhid' & surveyyear==2007
replace survival_7yrs=1 if hhid==`hhid' & surveyyear==2007

*hhid=1310451 - same firm
local hhid=1310451
replace sameaszero1=1 if hhid==`hhid' & surveyyear==2014
replace newfirmstarted_7yrs=0 if hhid==`hhid' & surveyyear==2007
replace survival_7yrs=1 if hhid==`hhid' & surveyyear==2007

*hhid=1370311 - looks like temporary closing and reopening -> new firm
local hhid=1370311
replace sameaszero1=0 if hhid==`hhid' & surveyyear==2014
replace newfirmstarted_7yrs=1 if hhid==`hhid' & surveyyear==2007
replace survival_7yrs=0 if hhid==`hhid' & surveyyear==2007

*hhid=1371851 - looks like temporary closing and reopening -> new firm
local hhid=1371851
replace sameaszero1=0 if hhid==`hhid' & surveyyear==2014
replace newfirmstarted_7yrs=1 if hhid==`hhid' & surveyyear==2007
replace survival_7yrs=0 if hhid==`hhid' & surveyyear==2007

*hhid=1402000 - code as different businesses
local hhid=1402000
replace sameaszero1=0 if hhid==`hhid' & surveyyear==2014

*hhid=1481543 - code as same business
local hhid=1481543
replace sameaszero1=1 if hhid==`hhid' & surveyyear==2014
replace newfirmstarted_7yrs=0 if hhid==`hhid' & surveyyear==2007
replace survival_7yrs=1 if hhid==`hhid' & surveyyear==2007

*hhid=1541731 - code as survival
local hhid=1541731
replace sameaszero1=1 if hhid==`hhid' & surveyyear==2014
replace newfirmstarted_7yrs=0 if hhid==`hhid' & surveyyear==2007
replace survival_7yrs=1 if hhid==`hhid' & surveyyear==2007

*hhid=1632700 - two different businesses (1 in 2000 and another in 2000 and 2014)
local hhid=1632700
replace sameaszero1=0 if hhid==`hhid' & surveyyear>=2007
replace newfirmstarted_7p5yrs=. if hhid==`hhid' & surveyyear==2000
replace survival_7p5yrs=. if hhid==`hhid' & surveyyear==2000

*hhid=1682800 - three different businesses
local hhid=1682800
forvalues i=1/2{
replace sameaszero`i'=0 if hhid==`hhid' & surveyyear==2014
}

*hhid=1683051 - same business
local hhid=1683051
replace sameaszero1=1 if hhid==`hhid' & surveyyear==2014
replace newfirmstarted_7yrs=0 if hhid==`hhid' & surveyyear==2007
replace survival_7yrs=1 if hhid==`hhid' & surveyyear==2007

*hhid=1732700 -> code as three different firms but the one from 2000 has nf 14=1
local hhid=1732700
replace sameaszero1=0 if hhid==`hhid' & surveyyear>=2007
replace sameaszero2=0 if hhid==`hhid' & surveyyear==2014
replace newfirmstarted_7yrs=. if hhid==`hhid' & surveyyear==2007
replace survival_7yrs=. if hhid==`hhid' & surveyyear==2007
replace newfirmstarted_14p5yrs=1 if hhid==`hhid' & surveyyear==2007
replace survival_14p5yrs=0 if hhid==`hhid' & surveyyear==2007

*hhid=1851500 -> code as temporary closure between 2000 and 2007
local hhid=1851500
replace sameaszero1=0 if hhid==`hhid' & surveyyear>=2007
replace newfirmstarted_7p5yrs=1 if hhid==`hhid' & surveyyear==2000
replace survival_7p5yrs=0 if hhid==`hhid' & surveyyear==2000
replace newfirmstarted_14p5yrs=1 if hhid==`hhid' & surveyyear==2000
replace survival_14p5yrs=0 if hhid==`hhid' & surveyyear==2000

*hhid=2412900 -> code as same firm
local hhid=2412900
replace sameaszero1=0 if hhid==`hhid' & surveyyear==2014
replace newfirmstarted_14p5yrs=0 if hhid==`hhid' & surveyyear==2000
replace survival_14p5yrs=1 if hhid==`hhid' & surveyyear==2000

*hhid=2481100 -> code as two different firms
local hhid=2481100
replace sameaszero1=0 if hhid==`hhid' & surveyyear==2014

*hhid=2490151 -> code as same firm
local hhid=2490151
replace sameaszero1=1 if hhid==`hhid' & surveyyear==2014
replace newfirmstarted_7yrs=0 if hhid==`hhid' & surveyyear==2007
replace survival_7yrs=1 if hhid==`hhid' & surveyyear==2007

*hhid=2560351 -> code as same firm
local hhid=2560351
replace sameaszero1=1 if hhid==`hhid' & surveyyear==2014
replace newfirmstarted_7yrs=0 if hhid==`hhid' & surveyyear==2007
replace survival_7yrs=1 if hhid==`hhid' & surveyyear==2007

*hhid=2600300 -> code as two different firms (1 in 2000 and another in 2007 and 2014)
local hhid=2600300
replace sameaszero1=0 if hhid==`hhid' & surveyyear>=2007

*hhid=2620431 -> code as two different firms (1 in 2000 and another in 2007 and 2014)
local hhid=2620431
replace sameaszero1=0 if hhid==`hhid' & surveyyear>=2007
replace newfirmstarted_14p5yrs=. if hhid==`hhid' & surveyyear==2000
replace survival_14p5yrs=. if hhid==`hhid' & surveyyear==2000

*hhid=2634211 -> code as same business
local hhid=2634211
replace sameaszero1=1 if hhid==`hhid' & surveyyear==2014
replace newfirmstarted_14p5yrs=0 if hhid==`hhid' & surveyyear==2000
replace survival_14p5yrs=1 if hhid==`hhid' & surveyyear==2000

*hhid=2682100 -> code as two different firms (1 in 2000 and another in 2007 and 2014)
local hhid=2682100 
replace sameaszero1=0 if hhid==`hhid' & surveyyear>=2007
replace newfirmstarted_7p5yrs=. if hhid==`hhid' & surveyyear==2000
replace survival_7p5yrs=. if hhid==`hhid' & surveyyear==2000
replace newfirmstarted_14p5yrs=. if hhid==`hhid' & surveyyear==2000
replace survival_14p5yrs=. if hhid==`hhid' & surveyyear==2000

*hhid=2690600 -> code as two different businesses
local hhid=2690600
replace sameaszero1=0 if hhid==`hhid' & surveyyear==2014

*hhid=2731351 -> code as same business
local hhid=2731351
replace sameaszero1=1 if hhid==`hhid' & surveyyear==2014
replace newfirmstarted_7yrs=0 if hhid==`hhid' & surveyyear==2007
replace survival_7yrs=1 if hhid==`hhid' & surveyyear==2007

*hhid=2750300  -> code as same business
local hhid=2750300 
replace sameaszero1=1 if hhid==`hhid' & surveyyear==2014
replace newfirmstarted_7p5yrs=0 if hhid==`hhid' & surveyyear==2000
replace survival_7p5yrs=1 if hhid==`hhid' & surveyyear==2000
replace newfirmstarted_14p5yrs=0 if hhid==`hhid' & surveyyear==2000
replace survival_14p5yrs=1 if hhid==`hhid' & surveyyear==2000

*hhid=2860531 -> code as same firm
local hhid=2860531
replace sameaszero1=1 if hhid==`hhid' & surveyyear==2014
replace newfirmstarted_7yrs=0 if hhid==`hhid' & surveyyear==2007
replace survival_7yrs=1 if hhid==`hhid' & surveyyear==2007

*hhid=2942041 -> code as different firm
local hhid=2942041
replace sameaszero1=0 if hhid==`hhid' & surveyyear==2014

*hhid=2961821 -> same firm
local hhid=2961821
replace sameaszero1=1 if hhid==`hhid' & surveyyear==2014
replace newfirmstarted_7yrs=0 if hhid==`hhid' & surveyyear==2007
replace survival_7yrs=1 if hhid==`hhid' & surveyyear==2007

*hhid=2992900 -> two different firms
local hhid=2992900
replace sameaszero1=0 if hhid==`hhid' & surveyyear==2014

*hhid=3052000 - two different firms (one in 2000 and another in 2007 and 2014=
local hhid=3052000
replace sameaszero1=0 if hhid==`hhid' & surveyyear==2014

*hhid=3071500 -> code as same firm
local hhid=3071500
replace sameaszero1=1 if hhid==`hhid' & surveyyear==2014
replace newfirmstarted_14p5yrs=0 if hhid==`hhid' & surveyyear==2000
replace survival_14p5yrs=1 if hhid==`hhid' & surveyyear==2000

*hhid=3100551 -> code as same firm
local hhid=3100551
replace sameaszero1=1 if hhid==`hhid' & surveyyear==2014
replace newfirmstarted_7yrs=0 if hhid==`hhid' & surveyyear==2007
replace survival_7yrs=1 if hhid==`hhid' & surveyyear==2007

*hhid=3130700 -> code as different firm
local hhid=3130700
replace sameaszero1=0 if hhid==`hhid' & surveyyear==2007

*hhid=3131200 -> two different firms
local hhid=3131200
replace sameaszero1=0 if hhid==`hhid' & surveyyear==2007

*hhid=3180151 -> same firm
local hhid=3180151
replace sameaszero1=1 if hhid==`hhid' & surveyyear==2014
replace newfirmstarted_7yrs=0 if hhid==`hhid' & surveyyear==2007
replace survival_7yrs=1 if hhid==`hhid' & surveyyear==2007

*TO DO: decide whether you need/want to change path for saving IFLS_masterfc
/*	*/	
save IFLS_masterfc, replace
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

g check2=1 if rthelpcheck3==1

drop rthelpcheck* helpcheck2*

*-> 52 households:
*hhid=32900 -> two different firms (1 in 2000 and another in 2007 and 2014)
*hhid=42900 -> temp closure btw 2000 and 2007 -> recode sameaszero & survival_14p5 & nf_survival_14p4
*hhid=80200 -> two different firms (1 in 2000 and another in 2007 and 2014)
*hhid=151100 -> code as same firm
*hhid=171200 -> code as same firm
*hhid=201400 -> code as same firm
*hhid=211000 -> three different firms ; only recode sameaszero1 in 2014
local hhid=211000
forvalues i=1/2{
replace sameaszero`i'=0 if hhid==`hhid' & surveyyear==2014
}
replace newfirmstarted_7yrs=. if hhid==`hhid' & surveyyear==2007
replace survival_7yrs=. if hhid==`hhid' & surveyyear==2007

*hhid=291631 -> code as three different businesses but  only recode sameaszero1 in 2007
local hhid=291631
forvalues i=1/2{
replace sameaszero`i'=0 if hhid==`hhid' & surveyyear==2014
}
replace newfirmstarted_7yrs=. if hhid==`hhid' & surveyyear==2007
replace survival_7yrs=. if hhid==`hhid' & surveyyear==2007
*hhid=312331 -> temp closure btw 2000 and 2007 -> recode sameaszero & survival_14p5 & nf_survival_14p4
*hhid=560631 -> three different firms ; only recode sameaszero1 in 2014 and code nf & sv 7p5 for 2000
local hhid=560631
forvalues i=1/2{
replace sameaszero`i'=0 if hhid==`hhid' & surveyyear==2014
}
replace newfirmstarted_7yrs=. if hhid==`hhid' & surveyyear==2007
replace survival_7yrs=. if hhid==`hhid' & surveyyear==2007
*hhid=591900 -> two different firms (1 in 2000 and another in 2007 and 2014)
*hhid=670600 -> three different firms ; only recode sameaszero1 in 2014 and code nf & sv 7p5 for 2000
local hhid=670600
forvalues i=1/2{
replace sameaszero`i'=0 if hhid==`hhid' & surveyyear==2014
}
replace newfirmstarted_7yrs=. if hhid==`hhid' & surveyyear==2007
replace survival_7yrs=. if hhid==`hhid' & surveyyear==2007
*hhid=840631 -> code as same firm
*hhid=882000 -> code as same firm
*hhid=911300 -> two different firms
*hhid=954731 -> code as same firm
*hhid=1021032 -> temp closure btw 2000 and 2007 -> recode sameaszero & survival_14p5 & nf_survival_14p4
*hhid=1130800 -> code as same firm
*hhid=1191200 -> code as same firm
*hhid=1230500 -> code as same firm
*hhid=1461700 -> temp closure btw 2000 and 2007 -> recode sameaszero & survival_14p5 & nf_survival_14p4
*hhid=1552000  -> three different firms -> recode sameaszero
local hhid=1552000
forvalues i=1/2{
replace sameaszero`i'=0 if hhid==`hhid' & surveyyear==2014
}
replace newfirmstarted_7yrs=. if hhid==`hhid' & surveyyear==2007
replace survival_7yrs=. if hhid==`hhid' & surveyyear==2007
*hhid=1580300 -> code as same firm
*hhid=1642331 -> two different firms (1 in 2000 and another in 2007 and 2014) ; recode survival_14p5 & nf_survival_14p4
*hhid=1690400  -> three different firms -> recode sameaszero & survival_14p5 & nf_survival_14p4
local hhid=1690400
forvalues i=1/2{
replace sameaszero`i'=0 if hhid==`hhid' & surveyyear==2014
}
replace newfirmstarted_7yrs=. if hhid==`hhid' & surveyyear==2007
replace survival_7yrs=. if hhid==`hhid' & surveyyear==2007
replace newfirmstarted_14p5yrs=. if hhid==`hhid' & surveyyear==2000
replace survival_14p5yrs=. if hhid==`hhid' & surveyyear==2000
*hhid=1692700 -> three different firms -> recode sameaszero & survival_14p5 & nf_survival_14p4
local hhid=1692700
forvalues i=1/2{
replace sameaszero`i'=0 if hhid==`hhid' & surveyyear==2014
}
replace newfirmstarted_7yrs=. if hhid==`hhid' & surveyyear==2007
replace survival_7yrs=. if hhid==`hhid' & surveyyear==2007
replace newfirmstarted_14p5yrs=. if hhid==`hhid' & surveyyear==2000
replace survival_14p5yrs=. if hhid==`hhid' & surveyyear==2000
*hhid=1761511 -> two different firms (1 in 2000 and another in 2007 and 2014)  recode sameaszero & survival_14p5 & nf_14p4
*hhid=1780600 -> code as same firm
*hhid=1902000 -> temp closure between 2000 and 2014 and different firm in 2000 ; recode sameaszero & survival_7p5 & nf_7p5
*hhid=2171731 -> temp closure between 2000 and 2014 and different firm in 2000 ; recode sameaszero & survival_7p5 & nf_7p5
*hhid=2192700 -> code as same firm
*hhid=2210700 -> three different firms ; recode recode sameaszero & survival_14p5 & nf_14p5
local hhid=2210700
forvalues i=1/2{
replace sameaszero`i'=0 if hhid==`hhid' & surveyyear==2014
}
replace newfirmstarted_7yrs=. if hhid==`hhid' & surveyyear==2007
replace survival_7yrs=. if hhid==`hhid' & surveyyear==2007
replace newfirmstarted_14p5yrs=. if hhid==`hhid' & surveyyear==2000
replace survival_14p5yrs=. if hhid==`hhid' & surveyyear==2000
*hhid=2262700 -> two different firms (1 in 2000 and another in 2007 and 2014)
*hhid=2300100 -> two different firms (1 in 2000 and another in 2007 and 2014)
*hhid=2312000 -> two different firms (1 in 2000 and another in 2007 and 2014)
*hhid=2370400 -> two different firms (1 in 2000 and another in 2007 and 2014)
*hhid=2381400 -> two different firms (2000 and 2014 are the same and 2007 is different)
local hhid=2381400
forvalues i=1/2{
replace sameaszero`i'=0 if hhid==`hhid' & surveyyear==2014
}
replace newfirmstarted_7yrs=. if hhid==`hhid' & surveyyear==2007
replace survival_7yrs=. if hhid==`hhid' & surveyyear==2007
*hhid=2430700 -> two different firms (1 in 2000 and another in 2007 and 2014)
*hhid=2631100  -> code as same firm
*hhid=2712100  -> code as same firm
*hhid=2740100 -> two different firms (1 in 2000 and another in 2007 and 2014)
*hhid=2771300 -> three different firms (nf_7p5=1 from 2000 to 2007)
local hhid=2771300
forvalues i=1/2{
replace sameaszero`i'=0 if hhid==`hhid' & surveyyear==2014
}
replace newfirmstarted_7yrs=. if hhid==`hhid' & surveyyear==2007
replace survival_7yrs=. if hhid==`hhid' & surveyyear==2007
replace newfirmstarted_14p5yrs=. if hhid==`hhid' & surveyyear==2000
replace survival_14p5yrs=. if hhid==`hhid' & surveyyear==2000
*hhid=2771400 -> code as same firm
*hhid=2771900 -> two different firms (1 in 2000 and another in 2007 and 2014)
*hhid=2801100 -> temp closure from 2000 to 2007 -> two diff firms
*hhid=2801221 -> code as same firm
*hhid=2801900 -> code as same firm
*hhid=2850700 -> temp closure from 2000 to 2007 -> two diff firms
*hhid=2904200 -> code as same firm
*hhid=2990831 -> code as same firm
*hhid=3012400 -> code as same firm
*hhid=3030900 -> three different firms
local hhid=3030900
forvalues i=1/2{
replace sameaszero`i'=0 if hhid==`hhid' & surveyyear==2014
}
replace newfirmstarted_7yrs=. if hhid==`hhid' & surveyyear==2007
replace survival_7yrs=. if hhid==`hhid' & surveyyear==2007
replace newfirmstarted_14p5yrs=. if hhid==`hhid' & surveyyear==2000
replace survival_14p5yrs=. if hhid==`hhid' & surveyyear==2000


*Same firm:
foreach x in 151100 171200 201400 840631 882000 954731 1130800 1191200 1230500 1580300 1780600 2192700 2631100 2712100 2771400 2801221 2801900 2904200 2990831 3012400{
local newid=`x'
replace sameaszero1=1 if hhid==`x' & surveyyear==2007
replace newfirmstarted_7p5yrs=0 if hhid==`x' & surveyyear==2000
replace survival_7p5yrs=1 if hhid==`x' & surveyyear==2000
}

*Two different firms (1 in 2000 and another in 2007 and 2014)
foreach x in 32900 80200 591900 911300 1642331 1761511 2262700 2300100 2312000 2370400 2430700 2740100 2771900{
local newid=`x'
replace sameaszero1=0 if hhid==`x' & surveyyear==2014
replace newfirmstarted_14p5yrs=1 if hhid==`x' & surveyyear==2000
replace survival_14p5yrs=0 if hhid==`x' & surveyyear==2000
}

*Temp closure btw 2000 and 2007
foreach x in 42900 312331 1021032 1461700 2801100 2850700{
local newid=`x'
replace sameaszero1=0 if hhid==`x' & surveyyear==2014
replace newfirmstarted_14p5yrs=1 if hhid==`x' & surveyyear==2000
replace survival_14p5yrs=0 if hhid==`x' & surveyyear==2000
}

*Temp closure between 2000 and 2014 and different firm in 2007 ; recode sameaszero & survival_7 & nf_7
foreach x in 1902000 2171731{
local newid=`x'
replace sameaszero1=0 if hhid==`x' & surveyyear==2014
replace newfirmstarted_14p5yrs=0 if hhid==`x' & surveyyear==2000
replace survival_14p5yrs=1 if hhid==`x' & surveyyear==2000
replace newfirmstarted_7yrs=. if hhid==`x' & surveyyear==2007
replace survival_7yrs=. if hhid==`x' & surveyyear==2007
}

*TO DO: decide whether you need/want to change path for saving IFLS_masterfc
/*	*/	
save IFLS_masterfc, replace
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

*121800 -> same firm
*250400 -> same firm
*391132 -> nf in 2007 -> two firms, 1 in 2000 and another in 2007 and 2014
local hhid=391132
replace sameaszero1=0 if hhid==`hhid' & surveyyear==2007
replace newfirmstarted_7p5yrs=1 if hhid==`hhid' & surveyyear==2000
replace survival_7p5yrs=. if hhid==`hhid' & surveyyear==2000
replace newfirmstarted_14p5yrs=1 if hhid==`hhid' & surveyyear==2000
replace survival_14p5yrs=. if hhid==`hhid' & surveyyear==2000
*391700 ->  same firm
*420721 ->  same firm
*432421 ->  same firm
*552012 -> different firms -> 1 in 2000 and another in 2007 and 2014 but no nf from 2000 to 2007
local hhid=552012
replace sameaszero1=0 if hhid==`hhid' & surveyyear==2007
replace newfirmstarted_7p5yrs=0 if hhid==`hhid' & surveyyear==2000
replace survival_7p5yrs=. if hhid==`hhid' & surveyyear==2000
replace newfirmstarted_14p5yrs=0 if hhid==`hhid' & surveyyear==2000
replace survival_14p5yrs=. if hhid==`hhid' & surveyyear==2000
*560600 ->  same firm
*651300 ->  same firm
*661400 ->  same firm
*741000 -> nf created in 2014
local hhid=741000
replace sameaszero2=0 if hhid==`hhid' & surveyyear==2014
replace newfirmstarted_7yrs=1 if hhid==`hhid' & surveyyear==2007
replace survival_7yrs=. if hhid==`hhid' & surveyyear==2007
*811800 ->  same firm
*821632 ->  same firm
*1060800 ->  same firm
*1150100 -> same firm in 2000 and 2007 and new in 2014
*1280100 -> same firm in 2000 and 2007 and new in 2014
*1341331  ->  same firm
*1370200  ->  same firm
*1600700 -> same firm in 2000 and 2007 and new in 2014
*1642500  ->  same firm
*1692500 -> same firm in 2000 and 2007 and different (not new!) in 2014
*1721900 ->  same firm
*1820600 ->  same firm
*1840600 ->  same firm
*1851221 ->  same firm
*1891311 -> same firm in 2000 and 2007 and new in 2014
*1920600 -> same firm in 2000 and 2007 and different (not new!) in 2014
*2012000 ->  same firm
*2041400 -> same firm in 2000 and 2007 and new in 2014
*2082200  ->  same firm
*2242300  ->  same firm
*2401900  ->  same firm
*2412900  ->  same firm
*2632531 -> same firm in 2000 and 2007 and new in 2014
*2710300  ->  same firm
*2720732  -> same firm in 2000 and 2007 and new in 2014
*2740500  -> same firm in 2000 and 2007 and new in 2014
*2800600   ->  same firm
*3000600 -> two different firms (1 in 2000, and another in 2007 and 2014)
local hhid=3000600
replace sameaszero1=0 if hhid==`hhid' & surveyyear==2007
replace newfirmstarted_7p5yrs=. if hhid==`hhid' & surveyyear==2000
replace survival_7p5yrs=. if hhid==`hhid' & surveyyear==2000
replace newfirmstarted_14p5yrs=. if hhid==`hhid' & surveyyear==2000
replace survival_14p5yrs=. if hhid==`hhid' & surveyyear==2000
*3162400   ->  same firm
*3200600 ->  -> two different firms (1 in 2000, and another in 2007 and 2014) + nf from 2000 to 2007 and 2014
local hhid=3200600
replace sameaszero1=0 if hhid==`hhid' & surveyyear==2007
replace newfirmstarted_7p5yrs=1 if hhid==`hhid' & surveyyear==2000
replace survival_7p5yrs=. if hhid==`hhid' & surveyyear==2000
replace newfirmstarted_14p5yrs=1 if hhid==`hhid' & surveyyear==2000
replace survival_14p5yrs=. if hhid==`hhid' & surveyyear==2000


*Same firm
foreach x in 121800 250400 391700 420721 432421 560600 651300 661400 811800 821632 1060800 1341331 1370200 1642500 1721900 1820600 1840600 1851221 2012000 2082200 2242300 2401900 2412900 2710300 2800600 3162400{
local hhid=`x'
replace sameaszero1=1 if hhid==`x' & surveyyear==2014
replace newfirmstarted_14p5yrs=0 if hhid==`x' & surveyyear==2000
replace survival_14p5yrs=1 if hhid==`x' & surveyyear==2000
}

*Same firm in 2000 and 2007 and new in 2014
foreach x in 1150100 1280100 1600700 1891311 2041400 2632531 2720732 2740500{
replace sameaszero2=0 if hhid==`x' & surveyyear==2014
replace newfirmstarted_7yrs=1 if hhid==`x' & surveyyear==2000
replace survival_7yrs=. if hhid==`x' & surveyyear==2000
}

*Same firm in 2000 and 2007 and different (not new!) in 2014
foreach x in 1692500 1920600{
replace sameaszero2=0 if hhid==`x' & surveyyear==2014
replace newfirmstarted_7yrs=. if hhid==`x' & surveyyear==2000
replace survival_7yrs=. if hhid==`x' & surveyyear==2000
}

*TO DO: decide whether you need/want to change path for saving IFLS_masterfc
/*		*/
save IFLS_masterfc, replace
/**/

*Generate firmid for the clear cases 
sort hhid surveyyear
egen helphhfirmid1=group(hhid sameaszero1) if sameaszero1==1
local i=2
local j=`i'-1
egen helphhfirmid`i'=group(hhid sameaszero`i') if sameaszero`j'==0 & sameaszero`i'==1


egen hhfirmid=group(hhid helphhfirmid1-helphhfirmid2), m
order hhfirmid, after(pidlink)


*TO DO: decide whether you need/want to change path for saving IFLS_masterfc
/*		*/
save IFLS_masterfc, replace
/**/

*Now decide on the owner - depending on the years in which the same hhfirmid is reported
keep if incl!=1
keep hhid pidlink hhfirmid totaldupl surveyyear businessowner* 

g hlpsvyear1=surveyyear

reshape wide hlpsvyear1, i(hhid pidlink hhfirmid) j(surveyyear)

foreach i in 2000 2007 2014{
replace hlpsvyear1`i'=(hlpsvyear1`i'!=.)
replace businessowner`i'=businessowner`i'*hlpsvyear1`i'
}
egen totalownership=rowtotal(businessowner2000-businessowner2014)
bysort hhfirmid: egen maxtotalownership=max(totalownership)
g hlpincl=(maxtotalownership==totalownership)
duplicates tag hhfirmid hlpincl, gen(duplhlpincl)
g incl=.
*In case there are no duplicates in maximum ownership
replace incl=(hlpincl==1) if duplhlpincl==0
bysort hhfirmid: egen helpinclonemaxo=total(incl)
replace incl=0 if incl==. & helpinclonemaxo==1

*duplicates in terms of owner/person:
duplicates tag hhid pidlink, gen(duplperson)


*If person only appears once, choose owner with the lowest hc_id (this will choose the household head if he/she is among the owners)
bysort hhfirmid: egen testincl=total(incl)
bysort hhfirmid: egen totalduplperson=total(duplperson)
sort hhfirmid hhid pidlink
g pid=substr(pidlink, 3 ,7)
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


keep hhid pidlink hhfirmid incl hlpsvyear12000-hlpsvyear12014

reshape long hlpsvyear1, i(hhid pidlink hhfirmid) j(surveyyear)
keep if hlpsvyear1==1
drop hlpsvyear1

*TO DO: decide whether you need/want to change path for saving IFLS_masterfchlp
/*		*/
save IFLS_masterfchlp, replace
/**/

*TO DO: change path to where you saved the following file "IFLS_masterfc"
/*EXAMPLE*/
use IFLS_masterfc, clear
/**/

*TO DO: change path to where you saved the following file "IFLS_masterfchlp"
/*EXAMPLE*/
merge 1:1 hhid pidlink hhfirmid surveyyear using IFLS_masterfchlp, update
/**/

*TO DO: decide whether you need/want to change path for saving IFLS_masterfc
/**/	
save IFLS_masterfc,replace
/**/

*test if for a given household owners change depending on hhfirmid
g pid=substr(pidlink, 3 ,7)
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
replace survey="BL-"+survey if survey=="2000"
replace survey="R-"+survey if survey!="BL-2000" & survey!="2014"
replace survey="L-"+survey if survey=="2014"

g lastround=(surveyyear==2014)


drop businessowner* sameaszero* period* maxperiod minsvy* primarilyresponsible* newhelpcheck* newhelpcheck maxnewhelpcheck helphhfirmid* _merge mdevhc_id help* dupl totaldupl incl check maxsvy responsible* totalowners* dupl_hhfirm totalbusinessowner* hlpnf* nf* hlptbdropped test check2

                                         
*Make the ids look nicer
foreach x of varlist hhfirmid ownerid householdid{
tostring `x', format("%04.0f") replace
replace `x'="IFLS"+"-"+`x'
}

rename hhfirmid firmid

*If a firm is coded to be dead once, it should be so for all subsequent periods too:
replace survival_14p5yrs=0 if survival_7p5yrs==0 & survival_14p5yrs==. & surveyyear==2000

*TO DO: decide whether you need/want to change path for saving IFLS_masterfc
/*	*/
save IFLS_masterfc,replace
/**/

*Code fieldofbus into retail, manuf, services and othersector
g retail=(fieldofbus==2 | fieldofbus==25)
g manuf=(fieldofbus==22 | fieldofbus==23 | fieldofbus==24)
g services=(fieldofbus==31 | fieldofbus==32 | fieldofbus==33 | fieldofbus==34 | fieldofbus==35 | fieldofbus==7 | fieldofbus==8 | fieldofbus==21)
g othersector=(fieldofbus==95 | fieldofbus==4 | fieldofbus==5 | fieldofbus==1)

*TO DO: Make sure the final dataset "IFLS_masterfc" is saved in the folder “Do-files and readme/Construction of Dataset/Data for combination”
/*	*/
save IFLS_masterfc,replace
/**/
