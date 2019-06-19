**Data File & Creation of All Tables and Figures  ***1-17-2017****
**RESTAT paper "Gentrification and Failing Schools: The Unintended Consequences of School Choice under NCLB"
*by Stephen B. Billings, Eric J. Brunner and Stephen L. Ross.
**contact for questions regarding replication -> stephen.billings@colorado.edu

**INSERT WORK SPACE LOCATION 
global data ""
*global data "C:\Research\SchoolChoiceNCLBFINAL"
cd "$data"



**PARCEL/SALES DATA
use "RawData\historicsales.dta", clear
rename parcelid taxpid
drop if salesprice==0
gen SalesDate = date( salesdate,"MDY")
drop salesdate
gsort taxpid -SalesDate
by taxpid: gen Count = _n
*Limited to five most recent sales
drop  seqnumber legalreference grantorname salescode
drop if Count > 5
format SalesDate %d 
reshape wide SalesDate salesprice, i(taxpid) j(Count)
save temp.dta,replace


use "RawData\masterparcels.dta", clear
drop if taxpid==""
duplicates drop taxpid, force
save temp2.dta,replace

use "RawData\parceldetails.dta", clear
drop if taxpid==""
merge m:1 taxpid using temp2.dta
drop _merge
merge m:1 taxpid using temp.dta
*Remove approximately 10k historic sales observations that are not matchable
*to current parcel data
drop if _merge==2
duplicates drop
drop _merge
gen acres=totalac
*Card no is different for each building on parcel
save FullParcelLayer.dta, replace


**Keeping attributes of main building on parcel (card #1) 
sort taxpid cardno
duplicates drop taxpid, force
generate SalesDate_t = SalesDate1
gen DistCBD = distcbd/5280
gen DistCBDsq = (DistCBD*DistCBD)
gen DistInterstate = distinstra/5280

*** Coding Types of Properties
generate PropertyType ="Commercial" if (descproper=="Office" | descproper=="Warehouse" ///
| descproper=="Commercial" | descproper=="Hotel/Motel" | descproper=="Warehouse Lg")
replace PropertyType ="SFResidential" if descproper=="Single-Fam"
replace PropertyType ="MFResidential" if (descproper=="Multi-Family" | descproper=="Attached Res")
replace PropertyType = "VacantLand" if vacantorim=="VAC"

**These are all school assignment codes based on the output of a simple spatial merge in ArcGIS b/t included parcel data and CMS provide GIS maps for school boundaries.
**GIS maps were made available as part of data sharing agreement with CMS and need to be requested in order to replicate.
order hschn1011 hschn0910 hschn0809 hschid0708  hsch0607 hsch0506 hsch0405 hsch0304 hssch0203 hschid01 hschid00 hssch99 hsatt98 mschn1011 ///
mschn0910 mschn0809  midid0708 msch0607- msch98 eschn1011 eschn0910 /// 
eschn0809 eschid0708 esch0607 schl0506 schl0405 schl0304 eschid0203 eschid01 esch0001 esch9900 esch9899 esch0203
rename esch0203 school_name0203
rename eschn1011 schl1011
rename eschn0910 schl0910
rename eschn0809 schl0809
rename eschid0708 schl0708
rename esch0607 schl0607
rename eschid0203 schl0203
rename esch0001 schl00
rename esch9900 schl99
rename esch9899 schl98

**Couple issues with GIS maps - fixing codes
**Same schools but changed school ids

foreach var of varlist schl1011-schl0203 {
*Billingsville
replace `var'=4335  if `var'==4326
*Bruns Ave.
replace `var'=4489  if `var'==4331
}


**ELEMENTARY SCHOOL - Merge in failing schools
tostring hschn1011-schl98, replace
merge m:1 schl1011 using "RawData\FailingSchMerge\fs10.dta"
drop if _merge==2
drop _merge

merge m:1 schl0910 using "RawData\FailingSchMerge\fs09.dta"
drop if _merge==2
drop _merge

merge m:1 schl0809 using "RawData\FailingSchMerge\fs08.dta"
drop if _merge==2
drop _merge

*new elon park (non-failing)
replace schl0708 ="4383" if schl0708=="0"
merge m:1 schl0708 using "RawData\FailingSchMerge\fs07.dta"
drop if _merge==2
drop _merge

merge m:1 schl0607 using "RawData\FailingSchMerge\fs06.dta"
drop if _merge==2
drop _merge

merge m:1 schl0506 using "RawData\FailingSchMerge\fs05.dta"
drop if _merge==2
drop _merge

merge m:1 schl0405 using "RawData\FailingSchMerge\fs04.dta"
drop if _merge==2
drop _merge

merge m:1 schl0304 using "RawData\FailingSchMerge\fs03.dta"
drop if _merge==2
drop _merge


foreach var of varlist schl1011-schl0203  school_name1011- failing0304 school_name0203 {
rename `var' Elem`var'
}

**MIDDLE SCHOOL

rename mschn1011 schl1011
rename mschn0910 schl0910
rename mschn0809 schl0809
rename midid0708 schl0708
rename msch0607 schl0607
rename msch0506 schl0506
rename msch0405 schl0405
rename msch0304 schl0304
rename midsch0203 schl0203


**Add-in Measures of Failing Schools
merge m:1 schl1011 using "RawData\FailingSchMerge\fs10.dta"
drop if _merge==2
drop _merge

merge m:1 schl0910 using "RawData\FailingSchMerge\fs09.dta"
drop if _merge==2
drop _merge

merge m:1 schl0809 using "RawData\FailingSchMerge\fs08.dta"
drop if _merge==2
drop _merge

merge m:1 schl0708 using "RawData\FailingSchMerge\fs07.dta"
drop if _merge==2
drop _merge

merge m:1 schl0607 using "RawData\FailingSchMerge\fs06.dta"
drop if _merge==2
drop _merge

merge m:1 schl0506 using "RawData\FailingSchMerge\fs05.dta"
drop if _merge==2
drop _merge

merge m:1 schl0405 using "RawData\FailingSchMerge\fs04.dta"
drop if _merge==2
drop _merge

merge m:1 schl0304 using "RawData\FailingSchMerge\fs03.dta"
drop if _merge==2
drop _merge

foreach var of varlist schl1011-schl0203  school_name1011- failing0304 {
rename `var' Mid`var'
}
rename Midschl0304 MidSch0304
rename Midschl0203 MidSch0203
rename Elemschl0304 ElemSch0304
rename Elemschl0203 ElemSch0203
save temp_parcel.dta,replace
drop hschid01- hsatt98 mschid01- msch98 eschid01- schl98
order Elemschool_name1011 Elemschool_name0910 Elemschool_name0809 Elemschool_name0708 ///
Elemschool_name0607 Elemschool_name0506 Elemschool_name0405 Elemschool_name0304 Midschool_name1011 ///
Midschool_name0910 Midschool_name0809 Midschool_name0708 Midschool_name0607 Midschool_name0506 Midschool_name0405 Midschool_name0304
foreach var of varlist  Elemfailing1011- Elemfailing0304 Midfailing1011- Midfailing0304 {
replace `var' = 0 if `var'==.
}
drop Elemschool_name1011- Midschool_name0304 Elemschool_name0203- nc_pin ownerlastn- cownerlast deedbook deedpage typeofdeed legalrefer

**Couple GIS Map Codes that differ from CMS assignment codes. fixing here.
replace ElemSch0203= "4507" if ElemSch0203=="4555"
replace ElemSch0203= "4462" if ElemSch0203=="4666"
replace ElemSch0203= "4487" if ElemSch0203=="4777"
replace ElemSch0203= "4574" if ElemSch0203=="4888"
replace ElemSch0203= "4414" if ElemSch0203=="4999"
replace MidSch0203= "5431" if MidSch0203=="5999"

save Main1.dta,replace



**************************************************
**ASSIGN FAILING TO NEIGH BASED ON ORIG NEIGH BOUNDARIES
**************************************************


**ELEMENTARY SCHOOL
use "RawData\FailingSchMerge\fs10.dta", clear
rename schl1011 schl0910
merge m:1 schl0910 using "RawData\FailingSchMerge\fs09.dta"
drop _merge
rename schl0910 schl0809
merge m:1 schl0809 using "RawData\FailingSchMerge\fs08.dta"
drop _merge
rename schl0809 schl0708
merge m:1 schl0708 using "RawData\FailingSchMerge\fs07.dta"
drop _merge
rename schl0708 schl0607
merge m:1 schl0607 using "RawData\FailingSchMerge\fs06.dta"
drop _merge
rename schl0607 schl0506
merge m:1 schl0506 using "RawData\FailingSchMerge\fs05.dta"
drop _merge
rename schl0506 schl0405
merge m:1 schl0405 using "RawData\FailingSchMerge\fs04.dta"
drop _merge
rename schl0405 schl0304
merge m:1 schl0304 using "RawData\FailingSchMerge\fs03.dta"
drop _merge
drop school_name1011 school_name0910 school_name0809 school_name0708 school_name0607 school_name0506 school_name0405 school_name0304
rename schl0304 ElemSch0203

***********************************
**For schools that existed in 02-03
*************************************

egen anyfail=rowtotal( failing1011 - failing0304)
count
count if anyfail>0
drop anyfail

save t1.dta,replace
destring ElemSch0203, generate(E)
foreach var of varlist failing1011 failing0910 failing0809- failing0304 {
gen Elem`var' = `var' if E<5000 
}
drop failing1011 failing0910 failing0809- failing0304
keep if E<5000

egen anyfail=rowtotal( Elemfailing1011 - Elemfailing0304)
count
count if anyfail>0
drop anyfail

save tt.dta,replace

use t1.dta,clear
destring ElemSch0203, generate(E)
foreach var of varlist failing1011 failing0910 failing0809- failing0304 {
gen Mid`var' = `var' if E>5000
}
drop failing1011 failing0910 failing0809- failing0304
keep if E>5000

egen anyfail=rowtotal( Midfailing1011 - Midfailing0304)
count if E<7000
count if anyfail>0
drop anyfail

rename ElemSch0203 MidSch0203
save tt1.dta,replace


use Main1.dta, clear
duplicates drop ElemSch0203 MidSch0203, force
keep ElemSch0203 MidSch0203
merge m:1 ElemSch0203 using tt.dta
**Schools not active in 02-03
drop if _merge==2
drop _merge
merge m:1 MidSch0203 using tt1.dta
drop if _merge==2
drop _merge

foreach var of varlist Elemfailing1011- Midfailing0304 {
tab `var'
}

foreach var of varlist Elemfailing1011- Midfailing0304 {
replace `var'=0 if `var'==.
}

rename Midfailing1011 Midfailing2011
rename Midfailing0910 Midfailing2010
rename Midfailing0809 Midfailing2009
rename Midfailing0708 Midfailing2008
rename Midfailing0607 Midfailing2007
rename Midfailing0506 Midfailing2006
rename Midfailing0405 Midfailing2005
rename Midfailing0304 Midfailing2004
rename Elemfailing1011 Elemfailing2011
rename Elemfailing0910 Elemfailing2010
rename Elemfailing0809 Elemfailing2009
rename Elemfailing0708 Elemfailing2008
rename Elemfailing0607 Elemfailing2007
rename Elemfailing0506 Elemfailing2006
rename Elemfailing0405 Elemfailing2005
rename Elemfailing0304 Elemfailing2004
reshape long Elemfailing Midfailing, i(ElemSch0203 MidSch0203) j(SchYear)



**ASSIGN FAILING TO NEIGH BASED ON ORIG NEIGH BOUNDARIES in 02-03
keep ElemSch0203 MidSch0203 Midfailing Elemfailing SchYear
save fail_orig_neigh.dta,replace
erase temp.dta
erase temp2.dta
erase tt.dta
erase tt1.dta
erase t1.dta


*********************************************
**Panel for Summary Statistics
*********************************************


**Current Year Boundaries
use Main1.dta, clear
keep ElemSch0203 MidSch0203 Elemfailing1011- Midfailing0304
collapse (mean) Elemfailing1011- Midfailing0304, by(ElemSch0203 MidSch0203)
sort ElemSch0203 MidSch0203
rename Midfailing1011 Midfailing2011
rename Midfailing0910 Midfailing2010
rename Midfailing0809 Midfailing2009
rename Midfailing0708 Midfailing2008
rename Midfailing0607 Midfailing2007
rename Midfailing0506 Midfailing2006
rename Midfailing0405 Midfailing2005
rename Midfailing0304 Midfailing2004
rename Elemfailing1011 Elemfailing2011
rename Elemfailing0910 Elemfailing2010
rename Elemfailing0809 Elemfailing2009
rename Elemfailing0708 Elemfailing2008
rename Elemfailing0607 Elemfailing2007
rename Elemfailing0506 Elemfailing2006
rename Elemfailing0405 Elemfailing2005
rename Elemfailing0304 Elemfailing2004


duplicates drop ElemSch0203 MidSch0203, force
reshape long Midfailing Elemfailing, i(ElemSch0203 MidSch0203) j(SchYear)
**accounts for changing boundaries and how to assign if failing based on current year boundaries  
replace Elemfailing=0 if Elemfailing<0.5
replace Elemfailing=1 if Elemfailing>=0.5
replace Midfailing=0 if Midfailing<0.5
replace Midfailing=1 if Midfailing>=0.5
keep ElemSch0203 MidSch0203 Elemfailing Midfailing SchYear 
save panel_fail_current.dta,replace

**No HS are failing for this time period 2003-2010.

use Main1.dta, clear
gen Count=1
gen SFCount=1 if PropertyType=="SFResidential"
gen MFCount=1 if PropertyType=="MFResidential"
gen CommCount=1 if PropertyType=="Commercial"

gen age = 2010 - yearbuilt
egen baths = rowtotal(fullbaths halfbaths)

collapse (median) age bedrooms DistCBD DistInterstate baths  ///
(mean) MeanAge=age MeanBeds=bedrooms MeanDistCBD=DistCBD MeanDistInt=DistInterstate MeanBaths=baths ///
(sum) TotalParcels=Count SFParcels=SFCount MFParcels=MFCount CommParcels=CommCount, by(fips ElemSch0203 MidSch0203)
gen year=.
gen quarter=.
save temp.dta, replace
save temp1.dta,replace

**Creating full panel
forval num = 2003/2011 {
forval qt =1/4 {
use temp.dta,clear
expand 2, generate(orig)
replace year = `num' if orig==1
replace quarter = `qt' if orig==1
keep if orig==1
append using temp1.dta
save temp1.dta,replace
}
}

drop if fips==""
drop if year==.
drop orig
gen SchYear = year if quarter<=2
replace SchYear=year+1 if quarter>2
save temp.dta,replace
erase temp1.dta


use Main1.dta, clear
keep if PropertyType=="SFResidential" & SalesDate_t~=.
generate Ps1year=year(SalesDate_t)
generate Ps1quarter=quarter(SalesDate_t)
replace salesprice1=. if salesprice1<10000
gen Count=1 if salesprice1~=.
gen PriceSqFt = (salesprice1/ heatedarea)
collapse (median) PriceSqFt (mean) MeanPriceSqFt=PriceSqFt meanprice=salesprice1 (sum) TotalSales=Count, by(Ps1year Ps1quarter fips ElemSch0203 MidSch0203)
rename Ps1year year
rename Ps1quarter quarter

**generate school year variable
gen SchYear = year if quarter<=2
replace SchYear=year+1 if quarter>2
drop if year<2003
drop if year>2011
save temp2.dta,replace


use temp2.dta, clear
merge 1:1 fips ElemSch0203 MidSch0203 year quarter using temp.dta
**_merge==2 for observations without property sale
drop _merge

merge m:1 ElemSch0203 MidSch0203 SchYear using panel_fail_current.dta
replace Elemfailing=0 if SchYear==2003 & _merge==1
replace Midfailing =0 if SchYear==2003 & _merge==1
drop if SchYear==2012
drop _merge
erase temp.dta
erase temp2.dta
save MainPanel.dta,replace

use Main1.dta, clear
keep taxpid ElemSch0203 MidSch0203 hssch0203 neighcode fips
save temp.dta,replace


******************
*MORTGAGE DATA
******************
/*
Restricted the sample in the hmda data to occupancy code=1 which is "Owner-occupied as a principal dwelling".  

match_code=1 is match on tract, lender name and loan amount,
match_code=2 is match on tract, subsidiary (or new name) and loan amount
match_code=3 is match on tract, close lender name and loan amount
match_code=4 is match on tract, lender name and rounded loan amount
match_code=5 is match on tract, subsidiary (or new name) and rounded loan amount
match_code=6 is match on tract, close lender name and rounded loan amount
match_code=7 if match on tract, lender name and loan amount within $5,000.

*/

******
*INSERT DO FILE FOR CREATING MORTGAGE INCOME HERE
******


use "RawData\mort_income.dta", clear
keep year- y 
merge m:1 taxpid using temp.dta, update
drop if _merge==2
drop _merge
gen quarter = quarter(mortdate)

gen MortgIncome = applicantincome if (match_code==1 | match_code==2 | match_code==3)

gen MortgIncomeAlt = applicantincome if match_code<7

duplicates drop taxpid mortdate MortgIncome MortgIncomeAlt, force

drop state county tract1
merge m:1 taxpid using Main1.dta
drop if _merge==2
drop respid-error applicantsex- tract0 T2- month hschn1011- hsch0304 disths distmidsch distelesch eleschprox- name_12 _merge
keep year- y MortgIncome MortgIncomeAlt quarter
save IndividMortg.dta,replace




**************************************************************************
***ALL CMS RAW DATA - MUST REQUEST FROM CHARLOTTE-MECKLENBURG SCHOOLS
*1) TEST SCORE FILE 1999-2011
*2) STUDENT FILE 1999-2011
**************************************************************************
*Couple hundred students had two test scores in the same year, so average together
use "TEST SCORE FILE 1999-2011", clear
collapse (mean) s_math_zd s_read_zd s_engl_zd s_alg1_zd ,by(s_lasid s_year)
save test.dta,replace

use "STUDENT FILE 1999-2011", clear
keep s_lasid s_year s_schoolname s_schoolcode s_grade s_yearscms
merge 1:1 s_lasid s_year using test.dta
drop _merge

collapse (mean) HSEngl=s_engl_zd HSAlg=s_alg1_zd Math=s_math_zd Read=s_read_zd , by(s_schoolcode s_year)
tsset s_schoolcode s_year
drop if s_schoolcode<300
tsfill, full
gen LagHSEngl = L1.HSEngl
gen LagHSAlg = L1.HSAlg
gen LagMath = L1.Math
gen LagRead = L1.Read
forval num=2/7  {
replace LagHSEngl = L`num'.HSEngl if LagHSEngl==.
replace LagHSAlg = L`num'.HSAlg if LagHSAlg==.
replace LagMath = L`num'.Math if LagMath==.
replace LagRead = L`num'.Read if LagRead==.
}


*In some cases have a new school, so need to use current year test scores since no previous test scores.
replace LagHSEngl = HSEngl if LagHSEngl==. & HSEngl!=.
replace LagHSAlg = HSAlg if LagHSAlg==. & HSAlg!=.
replace LagMath = Math if LagMath==. & Math!=.
replace LagRead = Read if LagRead==. & Read!=.
save MainStudent.dta, replace

use Main1.dta, clear
rename hschn1011 Highschl2011 
rename hschn0910 Highschl2010 
rename hschn0809 Highschl2009 
rename hschid0708 Highschl2008 
rename hsch0607 Highschl2007 
rename hsch0506 Highschl2006 
rename hsch0405 Highschl2005 
rename hsch0304 Highschl2004 
rename hssch0203 Highschl2003 
rename Midschl1011 Midschl2011
rename Midschl0910 Midschl2010
rename Midschl0809 Midschl2009
rename Midschl0708 Midschl2008
rename Midschl0607 Midschl2007
rename Midschl0506 Midschl2006
rename Midschl0405 Midschl2005
rename MidSch0304 Midschl2004
rename MidSch0203 Midschl2003
rename Elemschl1011 Elemschl2011
rename Elemschl0910 Elemschl2010
rename Elemschl0809 Elemschl2009
rename Elemschl0708 Elemschl2008
rename Elemschl0607 Elemschl2007
rename Elemschl0506 Elemschl2006
rename Elemschl0405 Elemschl2005
rename ElemSch0304 Elemschl2004
rename ElemSch0203 Elemschl2003
gen ElemSch0203=Elemschl2003
gen MidSch0203=Midschl2003
gen ElemSch0304=Elemschl2004
gen MidSch0304=Midschl2004

keep taxpid fips neighcode Highschl2011-Elemschl2003 ElemSch0203 MidSch0203
reshape long Highschl Midschl Elemschl, i(taxpid) j(year)
save temp3.dta,replace

        

**Linking GIS shapefile School Codes to Adminstrative School Codes.
clear
insheet using "RawData\CMSGISLink.csv", comma
rename highschl Highschl
rename midschl Midschl
rename elemschl Elemschl
tostring Highschl Midschl Elemschl ,replace
save temp.dta,replace

use temp.dta,clear
drop Midschl Elemschl midschoolname elemschoolname midschcode elemschcode
save H.dta,replace

use temp.dta,clear
drop Highschl Elemschl highschoolname elemschoolname highschcode elemschcode 
save M.dta,replace

use temp.dta,clear
drop Highschl Midschl highschoolname midschoolname highschcode midschcode 
save E.dta,replace


use temp3.dta,clear
merge m:1 Highschl using H.dta
drop if _merge==2
drop _merge
merge m:1 Midschl using M.dta
drop if _merge==2
drop _merge
merge m:1 Elemschl using E.dta
drop if _merge==2
drop _merge
save ParcelSchs1.dta,replace
erase H.dta
erase M.dta
erase E.dta
erase temp3.dta



use MainStudent.dta, clear
drop Math Read LagMath LagRead
rename s_schoolcode highschcode
rename s_year year
save HighTestScores.dta,replace

use MainStudent.dta, clear
rename Math Midmath
rename Read Midread
rename LagMath Midlagmath
rename LagRead Midlagread
drop HSEngl HSAlg LagHSEngl LagHSAlg
rename s_schoolcode midschcode
rename s_year year
save MidTestScores.dta,replace

use MainStudent.dta, clear
rename Math Elemath
rename Read Eleread
rename LagMath Elelagmath
rename LagRead Elelagread
drop HSEngl HSAlg LagHSEngl LagHSAlg
rename s_schoolcode elemschcode
rename s_year year
save ElemTestScores.dta,replace

use ParcelSchs1.dta, clear
merge m:1 highschcode year using HighTestScores.dta
**Non-assigned schools (magnet)
drop if _merge==2
drop _merge


merge m:1 midschcode year using MidTestScores.dta
**Non-assigned schools (magnet)
drop if _merge==2
drop _merge


merge m:1 elemschcode year using ElemTestScores.dta
**Non-assigned schools (magnet)
drop if _merge==2
drop _merge
gen Asshighschcode = highschcode
gen Assmidschcode = midschcode
gen Asselemschcode = elemschcode

rename year SchYear
save ParcelAssSchTests.dta,replace
collapse (mean) HSEngl- Elelagread, by(SchYear ElemSch0203 MidSch0203)
**THIS IS BASED ON CURRENT YEAR BOUNDARIES
save CMSTestPanel2.dta,replace

**FOR ORIGINAL NEIGH BOUNDARIES
use ParcelSchs1.dta, clear
rename year SchYear
merge m:1 SchYear ElemSch0203 MidSch0203 using CMSTestPanel2.dta
drop _merge
duplicates drop SchYear ElemSch0203 MidSch0203,force

**CAN KEEP CURRENT NEIGHBORHOOD DATA HERE IF WANT TO USE LATER
keep SchYear fips ElemSch0203 MidSch0203 LagHSEngl LagHSAlg Midlagmath Midlagread Elelagmath Elelagread
erase HighTestScores.dta
erase MidTestScores.dta
erase ElemTestScores.dta
save orig_neigh_test.dta,replace


use fail_orig_neigh.dta,clear
merge 1:m ElemSch0203 MidSch0203 SchYear using orig_neigh_test.dta
drop _merge

**2002-2003 school year
replace Elemfailing=0 if Elemfailing==.
replace Midfailing=0 if Midfailing==.
save fail_orig_neigh.dta,replace



************************************************
*FALSIFICATION MEASURES OF FAIL - used in later tables
************************************************

clear
insheet name code Elemschl Midschl ayp2003 ayp2004 ayp2005 ayp2006 ayp2007 ayp2008 ayp2009 ayp2010 ayp2011 using "RawData\ayp_merge.csv", comma
reshape long ayp , i(elemschl) j(year)
rename elemschl Elemschl
rename midschl Midschl
tostring Elemschl, replace
tostring Midschl, replace
rename year SchYear
gen ElemSch0203 = 4000+code
tostring ElemSch0203,replace
gen MidSch0203 = 5000+code
tostring MidSch0203,replace
**removing observations that have same info, but GIS do not match school codes (fine)
duplicates drop ElemSch0203 MidSch0203 SchYear ayp, force
save temp_ayp.dta,replace


**non-title 1 failing schools from CMS school district files

use temp_ayp.dta, clear
merge m:1 name SchYear using "RawData/non_title_failing.dta" 
drop _merge
save temp_ayp2.dta,replace

**school_code and elem_schl same thing for parcel data, not the same for stundent data == assigned versus attended

use fail_orig_neigh.dta, clear
merge m:1 ElemSch0203 SchYear using temp_ayp2.dta
drop if _merge==2
drop _merge
drop code
rename ayp elem_ayp
rename fail_nontitle1 fail_nontitle_elem
merge m:1 MidSch0203 SchYear using temp_ayp2.dta
drop if _merge==2
drop _merge
rename ayp mid_ayp
rename fail_nontitle1 fail_nontitle_mid
egen AnyFailing = rowmax( Elemfailing Midfailing)
save fail_ayp_temp.dta,replace


use fail_ayp_temp.dta,clear
egen NeighS = group(ElemSch0203 MidSch0203)
tsset NeighS SchYear
sort NeighS SchYear


gen lag_elem_ayp = L1.elem_ayp
gen lag_elem_ayp2 = L2.elem_ayp
gen lag_mid_ayp = L1.mid_ayp
gen lag_mid_ayp2 = L2.mid_ayp

sum elem_ayp if SchYear>=2003
sum mid_ayp if SchYear>=2003

*82% of mid schools meet AYP in a given year. 90% of elem schools fail meet AYP in a given year

gen Midfailing_false = ((lag_mid_ayp==1 & mid_ayp~=1)  & Midfailing==0 ) 
gen Elemfailing_false = ((lag_elem_ayp==1 & elem_ayp~=1)  & Elemfailing==0 )

gen Midfailing_false2 = ((lag_mid_ayp2==1 & lag_mid_ayp~=1)  & Midfailing==0 ) 
gen Elemfailing_false2 = ((lag_elem_ayp2==1 & lag_elem_ayp~=1)  & Elemfailing==0 )

gen AnyFailing_false =(Elemfailing_false==1 | Midfailing_false==1)
gen AnyFailing_false2 =(Elemfailing_false2==1 | Midfailing_false2==1)
gen AnyFailing_false3 =(fail_nontitle_elem==1 | fail_nontitle_mid==1)

replace AnyFailing_false=0 if AnyFailing==1
replace AnyFailing_false2=0 if AnyFailing==1
replace AnyFailing_false3=0 if AnyFailing==1

egen mid_test = rowmean(Midlagmath Midlagread)
egen elem_test = rowmean(Elelagmath Elelagread)
by NeighS, sort: egen ever_fail= max(AnyFailing)

save temp2.dta,replace
sum AnyFailing AnyFailing_false AnyFailing_false2 AnyFailing_false3



use fail_orig_neigh.dta,clear
merge 1:1 ElemSch0203 MidSch0203 SchYear using temp2.dta

drop Elemschl- code NeighS mid_test elem_test _merge
egen schs = group(ElemSch0203 MidSch0203)
egen NeighS = group(ElemSch0203 MidSch0203)
tsset NeighS SchYear

by NeighS, sort: gen AnyFailingLag = AnyFailing[_n-1]
foreach var of varlist AnyFailing AnyFailing_false AnyFailing_false2 AnyFailing_false3 {
replace `var' =0 if `var'==.
}
save fail_orig_neigh2.dta,replace

use fail_orig_neigh2, clear
egen AvgElemTestScoresLag = rowmean(Elelagmath Elelagread)
egen AvgMidTestScoresLag = rowmean( Midlagmath Midlagread)
egen AvgHSTestScoresLag = rowmean(LagHSEngl LagHSAlg)
keep ElemSch0203 MidSch0203 SchYear AnyFailing AnyFailing_false AnyFailing_false2  AnyFailing_false3 ///
AnyFailingLag AvgElemTestScoresLag AvgMidTestScoresLag AvgHSTestScoresLag
save t1.dta,replace

erase temp.dta
erase temp2.dta
erase temp_ayp.dta



**Need to make panel of Attended School Test Scores using geocoded data to match CMS student tests, school attended to neighborhoods.
*99% geocode match rate - use address locator based on parcel shapefiles from Mecklenburg County ( http://maps.co.mecklenburg.nc.us/openmapping/data.html )

use "STUDENT FILE 1999-2011 geocoded in ArcGIS", clear
keep  x y s_lasid s_year s_firstnam s_lastname s_middlena s_appelnam s_zip taxpid
rename s_firstnam s_firstname 
rename s_middlena s_middlename  
rename s_appelnam s_appelname
save geotemp.dta,replace



use ParcelAssSchTests.dta,clear
keep taxpid SchYear Asshighschcode Assmidschcode Asselemschcode HSEngl- Elelagread fips neighcode ElemSch0203 MidSch0203
rename SchYear s_year
compress
save A.dta,replace

**Will give us assigned and attended schools 
use "STUDENT FILE DATA 1999-2011", clear
drop if s_grade<0
merge 1:1 s_lasid s_year using geotemp.dta, update
drop if _merge==2
drop _merge
keep s_lasid s_year s_schoolcode s_grade taxpid
merge m:1 taxpid s_year using A.dta
**Removing data for school years prior to 2003
drop if _merge==1
*Removes parcels without student assigned to them
drop if _merge==2
drop _merge

gen AssSchCode = Asselemschcode if s_grade<=5
replace AssSchCode = Assmidschcode if s_grade<=8 & s_grade>5
replace AssSchCode = Asshighschcode if s_grade>=9

gen AttendNonAssignedSch = (s_schoolcode!=AssSchCode)
save non_comp_student.dta,replace

gen ElemStudents=(s_grade<=5)
gen MidStudents=(s_grade<=8 & s_grade>5)
gen HighStudents=(s_grade>=9)

foreach var of varlist ElemStudents-HighStudents {
gen NonComp`var' = `var'*AttendNonAssignedSch
}

rename s_year SchYear
collapse (sum) ElemStudents-HighStudents NonCompElemStudents-NonCompHighStudents , by(fips ElemSch0203 MidSch0203 SchYear)
save PanelNonComp.dta,replace
erase A.dta



********************
*NEED TO MERGE IN PARCEL LEVEL FAILING TEST SCORES BASED ON SCHOOL ID FOR TEST SCORES AND FAILING
********************
use Main1.dta, clear
keep taxpid hssch0203
save hs_temp.dta,replace

use Main1.dta, clear

rename Midfailing1011 Midfailing2011
rename Midfailing0910 Midfailing2010
rename Midfailing0809 Midfailing2009
rename Midfailing0708 Midfailing2008
rename Midfailing0607 Midfailing2007
rename Midfailing0506 Midfailing2006
rename Midfailing0405 Midfailing2005
rename Midfailing0304 Midfailing2004
rename Elemfailing1011 Elemfailing2011
rename Elemfailing0910 Elemfailing2010
rename Elemfailing0809 Elemfailing2009
rename Elemfailing0708 Elemfailing2008
rename Elemfailing0607 Elemfailing2007
rename Elemfailing0506 Elemfailing2006
rename Elemfailing0405 Elemfailing2005
rename Elemfailing0304 Elemfailing2004
keep taxpid Elemfailing2011- Midfailing2004
reshape long Midfailing Elemfailing, i(taxpid) j(SchYear)
keep taxpid SchYear Elemfailing Midfailing 
save ParcelFailing.dta,replace

merge 1:1 taxpid SchYear using ParcelAssSchTests.dta

replace Elemfailing=0 if SchYear==2003
replace Midfailing=0 if SchYear==2003
drop _merge
merge m:1 taxpid using hs_temp.dta
drop _merge
drop highschoolname midschoolname elemschoolname Asshighschcode Assmidschcode Asselemschcode
save ParcelSchFinal1.dta,replace


*******************
**CREATE MASTER PANEL
******************
use MainPanel.dta, clear
drop if fips==""
merge m:1 ElemSch0203 MidSch0203 SchYear using CMSTestPanel2.dta
drop _merge

**Setting neigh/years without students to zero.
merge m:1 ElemSch0203 MidSch0203 fips SchYear using PanelNonComp.dta
foreach var of varlist ElemStudents- NonCompHighStudents {
replace `var'=0 if `var'==.
}
drop _merge
save FinalPanel1.dta,replace


use FinalPanel1.dta, clear
merge m:1 ElemSch0203 MidSch0203 SchYear using t1.dta
drop _merge
label variable AnyFailing "Failing School"
egen NonCompStudents = rowtotal( NonCompElemStudents NonCompMidStudents )
egen TotalStudents=rowtotal( ElemStudents MidStudents )
gen PortionNonComp = NonCompStudents/TotalStudents
gen TotalStudentsPerParcel = TotalStudents/SFParcels
save FinalPanel3.dta,replace


**CBG 2000 data - Mecklenburg County
use "RawData\FIPSData.dta", clear
keep CSfips CBGMedianHHIncome
rename CSfips fips
xtile CBGQuints = CBGMedianHHIncome if CBGMedianHHIncome<=84560, nq(3)
*(about 28 out of 1 million obs assigned to failing in cbg with hh income of 88514)-assign that fips cbgincome to 3rd quartile.
replace CBGQuints=3 if fips=="371190022004" 
replace CBGQuints=4 if CBGQuints==.
save CBGData.dta, replace




*****************
**Hedonic Model
*****************
use Main1.dta, clear
drop eleschprox- hschmag hsch1011- name_12 parlegalde Elemfailing1011- Midfailing0304
keep if PropertyType=="SFResidential"
drop if acres>5
drop if fullbaths==0 & halfbaths==0
order taxpid salesprice1- SalesDate5
gen saledate=SalesDate1
gen saleprice = salesprice1
gen LogPrice = ln(salesprice1)
gen year = year(SalesDate1)
gen quarter = quarter(SalesDate1)
order LogPrice-quarter

**Need to include each sale as a separate observations
expand 5, generate(add_sale)
sort taxpid add_sale
by taxpid: gen c=_n

foreach i of num 2/5 {
replace saledate = SalesDate`i' if add_sale==1 & c==`i'
replace saleprice = salesprice`i' if add_sale==1 & c==`i'
replace LogPrice = ln(salesprice`i') if add_sale==1 & c==`i'
replace year = year(SalesDate`i') if add_sale==1 & c==`i'
replace quarter = quarter(SalesDate`i') if add_sale==1 & c==`i'
}

drop if LogPrice==.
drop add_sale c
gen age = year - yearbuilt
replace age=. if age<0
gen agesquared = (age*age)/1000
gen agecubed = (age*age*age)/1000
gen sqft=heatedarea/1000
gen sqftsquared = (sqft*sqft)
gen fireplace = numfirepla

drop if 2010 < yearbuilt
drop if yearbuilt<1800
drop if salesprice1==.
drop if salesprice1<10000
drop if heatedarea<300

drop if year==.
gen SchYear = year if quarter<=2
replace SchYear=year+1 if quarter>2
save prices00_02.dta,replace

merge m:1 taxpid SchYear using ParcelSchFinal1.dta

drop if _merge==2
drop if _merge==1
drop _merge



*******************************
******Merging original neigh info
**********************************

merge m:1 ElemSch0203 MidSch0203 SchYear using t1.dta
drop _merge
merge m:1 neighcode using temp_neighcbg.dta
drop if _merge==2
drop _merge

merge m:1 fips using CBGData.dta
drop if _merge==2
drop _merge


*************************
*INDIVIDUAL MORTGAGE DATA
**************************
merge m:m taxpid using IndividMortg.dta
save ParcelMain2.dta, replace

**create panel measure of mortgage income
collapse (mean) MortgIncome MortgIncomeAlt, by(ElemSch0203 MidSch0203 fips SchYear)
save MortgagePanel.dta,replace

use FinalPanel3.dta, clear
collapse (max) AnyFailing , by(fips)
save fail_fips.dta,replace


use prices00_02.dta, clear
keep if (SchYear>=1998 & SchYear<=2002)
egen Time=group(year quarter)
gen price1= exp(LogPrice)
by fips, sort: egen fips_avg_logprice = mean(LogPrice)
duplicates drop fips, force
keep fips fips_avg_logprice 
merge 1:1 fips using fail_fips.dta
keep if _merge==3
drop _merge
gen t1 = fips_avg_logprice*AnyFailing
egen max_fail_fips2 = max(t1) 
save temp2a.dta,replace
xtile CBGPrice = fips_avg_logprice if fips_avg_logprice<=max_fail_fips2, nq(3)
replace CBGPrice=4 if CBGPrice==.
quietly tab CBGPrice, generate(CBGP)
save fips_home.dta,replace

*************************
**Produces Figure 1A
*************************
use fips_home.dta, clear
gen price1 = exp( fips_avg_logprice)

twoway (histogram price1 if AnyFailing==1, bin(30)  ) , xline(94000 150000 389000) ///
xtitle(Avg Sales Price 1998-2002)  scheme(s1mono) 
graph export Hist_Terciles_All_Fails.tif, replace


**COUNT FAILING SCHOOLS - for Table 1
use Main1.dta, clear
keep fips ElemSch0203 MidSch0203
duplicates drop
merge m:1 fips using fips_home.dta
drop _merge
save cbg_temp2.dta,replace

use fail_orig_neigh.dta,clear
merge m:m ElemSch0203 MidSch0203 using cbg_temp2.dta
tab ElemSch0203
tab MidSch0203
tab ElemSch0203 if Elemfailing==1
tab MidSch0203 if Midfailing==1

tab ElemSch0203 if CBGPrice==1
tab MidSch0203 if CBGPrice==1
tab ElemSch0203 if Elemfailing==1 & CBGPrice==1
tab MidSch0203 if Midfailing==1 & CBGPrice==1

tab ElemSch0203 if CBGPrice==2
tab MidSch0203 if CBGPrice==2
tab ElemSch0203 if Elemfailing==1 & CBGPrice==2
tab MidSch0203 if Midfailing==1 & CBGPrice==2

tab ElemSch0203 if CBGPrice==3
tab MidSch0203 if CBGPrice==3
tab ElemSch0203 if Elemfailing==1 & CBGPrice==3
tab MidSch0203 if Midfailing==1 & CBGPrice==3

erase cbg_temp2.dta



use "RawData\FIPSData.dta", clear
rename CSfips fips
keep fips CBGLandArea- PercUnemploy
save cbg_temp.dta,replace


**SUMMARIZE HOW MANY NEIGHBORHOODS LEADING TO IDENTIFICATION
use FinalPanel3.dta, clear
merge m:1 fips using fips_home.dta
drop _merge
drop if TotalParcels<5
gen c=1
by fips SchYear quarter, sort: egen NumbSchs=total(c)
merge m:1 fips using cbg_temp.dta
drop _merge

collapse (max) AnyFailing NumbSchs (median) CBGP1-CBGP4 , by(fips)

count if AnyFailing==1 
count if AnyFailing==1 & CBGP1==1
count if AnyFailing==1 & CBGP2==1 
count if AnyFailing==1 & CBGP3==1 
count if AnyFailing==1 & CBGP4==1 


use FinalPanel3.dta, clear
gen TotalSalesParcel = TotalSales/SFParcels
replace TotalSalesParcel=0 if TotalSalesParcel==.
egen FE = group(fips SchYear)
egen TotStudents = rowtotal( ElemStudents MidStudents)
egen Time=group(year quarter)

drop if TotalParcels<5
egen Neigh = group( fips ElemSch0203 MidSch0203)
egen schs = group( ElemSch0203 MidSch0203)
drop if year==2003 & quarter<=2

merge m:1 fips using fips_home.dta
drop _merge
foreach var of varlist  CBGP1-CBGP4 {
gen `var'_Fail = AnyFailing*`var'


}
drop if SchYear<=2003

merge m:1 fips ElemSch0203 MidSch0203 SchYear using ass_sch_panel.dta
gen PortionMagnet = AttendMagnetSchl/ Count
gen PortionNonAssPublic = AttendNonAssignedPublicSchl/ Count
replace PortionNonComp=0 if PortionNonComp==.
replace PortionMagnet=0 if PortionMagnet==.
replace PortionNonAssPublic =0 if PortionNonAssPublic ==.
save temp2.dta,replace


********************
**Produces Figure 2
********************


duplicates drop Neigh SchYear,force

kdensity PortionNonComp if AnyFailing==1 & ( CBGP3==1) [aw=TotStudents], bw(0.1) gen(D1 y1)
kdensity PortionNonComp if AnyFailing==0 & ( CBGP3==1)  [aw=TotStudents], bw(0.1) gen(D2 y2)
label variable y1 "Failing School in High-Price Neighborhood"
label variable y2 "Non-Failing School in High-Price Neighborhood"
twoway  (line y1 D1 , lw(medthick)) (line y2 D2 , lp(longdash_dot) lw(medium)),  ///
xtitle(% Students In Non-Assigned Schools) ytitle(Density) ylabel(none) legend(cols(1)) scheme(s1mono)
drop D1 D2 y1 y2
graph export StudentsNonCompHighIncome_cbg2.tif, replace

kdensity PortionNonComp if AnyFailing==1 & ( CBGP1==1 ) [aw=TotStudents], bw(0.1) gen(D1 y1)
kdensity PortionNonComp if AnyFailing==0 & ( CBGP1==1 )  [aw=TotStudents], bw(0.1) gen(D2 y2)
label variable y1 "Failing School in Low-Price Neighborhood"
label variable y2 "Non-Failing School in Low-Price Neighborhood"
twoway  (line y1 D1 , lw(medthick)) (line y2 D2 , lp(longdash_dot) lw(medium)),  ///
xtitle(% Students In Non-Assigned Schools) ytitle(Density) ylabel(none) legend(cols(1)) scheme(s1mono)
drop D1 D2 y1 y2
graph export StudentsNonCompLowIncome_cbg2.tif, replace


**Summary Statistics
use fips_home.dta,clear
keep fips fips_avg_logprice
save older_prices.dta,replace


use temp2.dta,clear

drop fips_avg_logprice _merge
merge m:1 fips using older_prices.dta
drop _merge
gen neigh_house_price = exp(fips_avg_logprice)
merge m:1 fips ElemSch0203 MidSch0203 SchYear using MortgagePanel.dta

*Range of Terciles for table 1

by  CBGPrice, sort:sum neigh_house_price
replace meanprice=. if meanprice> 1000000
*mortgage income in $000s
replace MortgIncome = . if MortgIncome>1000

drop if SchYear<=2003
drop if fips==""
 
collapse (mean) neigh_house_price MortgIncome PortionNonComp PortionMagnet PortionNonAssPublic AnyFailing ///
 AvgElemTestScoresLag AvgMidTestScoresLag AvgHSTestScoresLag CBGPrice [aw=TotStudents] , by(fips SchYear)  
save temp_sum.dta,replace


use temp2.dta,clear
 drop if SchYear<=2003
drop if fips=="" 
 
collapse (sum) TotalSales , by(fips SchYear) 

save temp_sum2.dta,replace

use temp2.dta,clear
 drop if SchYear<=2003
drop if fips=="" 
duplicates drop Neigh SchYear, force
 
collapse (sum) SFParcels MFParcels TotStudents, by(fips SchYear) 

save temp_sum3.dta,replace
merge 1:1 fips SchYear using temp_sum.dta
drop _merge
merge 1:1 fips SchYear using temp_sum2.dta
drop _merge

 
 
collapse (mean) neigh_house_price MortgIncome SFParcels MFParcels PortionNonComp PortionMagnet PortionNonAssPublic AnyFailing ///
 AvgElemTestScoresLag AvgMidTestScoresLag AvgHSTestScoresLag CBGPrice TotStudents TotalSales   , by(fips)

***************
****Table 1
****************
local covs "neigh_house_price SFParcels MFParcels TotalSales MortgIncome TotStudents PortionNonComp PortionMagnet PortionNonAssPublic AnyFailing  AvgElemTestScoresLag AvgMidTestScoresLag AvgHSTestScoresLag "

estpost tabstat `covs' , by(CBGPrice) missing   ///
statistics(mean sd) columns(statistics)

esttab using SumStats.csv, replace main(mean) aux(sd) nostar unstack obslast ///
mtitles("CBGP1" "CBGP2" "CBGP3" "CBGP4" "All")  ///
addnotes("Note: Mean of each variable with standard deviation in parentheses.") ///
title("Summary Statistics by Terciles of Failing Neighborhoods 2004-2011 School Years \label{Table1}")

duplicates drop fips, force
by CBGPrice, sort:count


**
use fail_orig_neigh.dta, clear
keep if Elemfailing==1
keep ElemSch0203 SchYear
sort ElemSch0203 SchYear
duplicates drop ElemSch0203, force
rename SchYear first_year_fail_elem
save elem_first_year_fail.dta, replace

use fail_orig_neigh.dta, clear
keep if Midfailing==1
keep MidSch0203 SchYear
sort MidSch0203 SchYear
duplicates drop MidSch0203, force
rename SchYear first_year_fail_mid
save mid_first_year_fail.dta, replace
append using elem_first_year_fail.dta
egen first_year_fail = rowtotal( first_year_fail_mid first_year_fail_elem)

**************
**CREATE FIGURE 2A - TOP
**************
twoway (histogram first_year_fail, discrete frequency ) , ///
xtitle(First Year School Designated as Failing) ytitle(# Failing Schools) scheme(s1mono) 
graph export Year_Initial_Fail.tif, replace


use fail_orig_neigh.dta, clear
keep if Elemfailing==1
keep ElemSch0203 SchYear
sort ElemSch0203 SchYear
duplicates drop ElemSch0203 SchYear, force
rename SchYear year_fail_elem
save elem_year_fail.dta, replace

use fail_orig_neigh.dta, clear
keep if Midfailing==1
keep MidSch0203 SchYear
sort MidSch0203 SchYear
duplicates drop MidSch0203 SchYear, force
rename SchYear year_fail_mid
save mid_year_fail.dta, replace
append using elem_year_fail.dta
egen year_fail = rowtotal(year_fail_mid year_fail_elem)

*************
**CREATE FIGURE 2A - BOTTOM
*************
twoway (histogram year_fail, discrete frequency ) , ///
xtitle(Year of Failing Status) ytitle(# Failing Schools) scheme(s1mono) 
graph export Years_Fail.tif, replace



*************************
**SINGLE SALES HEDONIC
*************************

use ParcelMain2.dta, clear
egen Time=group(year quarter)
label variable AnyFailing "Failing School"
egen fips_year = group(fips SchYear)
egen fips_sch = group(fips ElemSch0203 MidSch0203)


egen schs=group(ElemSch0203 MidSch0203 hssch0203)

drop _merge
merge m:1 fips using fips_home.dta
drop _merge
foreach var of varlist  CBGP1-CBGP3 {
gen `var'_Fail = AnyFailing*`var'
gen `var'_Fail_false = AnyFailing_false*`var'
gen `var'_Fail_false2 = AnyFailing_false2*`var'
gen `var'_Fail_false3 = AnyFailing_false3*`var'
}

order saleprice saledate


**Master housing price/mortgage dataset. just getting rid of mortgage info for now.
duplicates drop
drop if taxpid==""
*duplicate sales entry in assessors data
gen P=1 if SalesDate1==SalesDate2 & SalesDate2~=. & saleprice==salesprice2 & saledate==SalesDate2
replace P=1 if SalesDate2==SalesDate3 & SalesDate3~=. & saleprice==salesprice3 & saledate==SalesDate3
replace P=1 if SalesDate3==SalesDate4 & SalesDate4~=. & saleprice==salesprice4 & saledate==SalesDate4
replace P=1 if SalesDate4==SalesDate5 & SalesDate5~=. & saleprice==salesprice5 & saledate==SalesDate5
drop if P==1
drop P
save temp_reg.dta,replace



use temp_reg.dta,clear
*Have two mortgages matched to the same parcel. Just dropping one of them for now since
*only care about property sale here.
duplicates drop taxpid saleprice saledate, force
keep if saleprice>=10000 & saleprice<= 5000000
keep if SchYear>2003
save house_price.dta,replace


 
use house_price.dta,clear 
xi:reg  AnyFailing  AvgElemTestScoresLag AvgMidTestScoresLag AvgHSTestScoresLag , r 
outreg2 using Regressions1_18_17, keep(  ) ///
alpha(0.01, 0.05, 0.10) nocons excel dec(3) nor2 ct(FINAL TABLES) replace




local covars1 "acres fullbaths halfbaths bedrooms sqft sqftsquared age agesquared agecubed fireplace i.storyheigh i.aheatingty i.heatedfuel i.actype i.extwall  i.foundation i.bldggrade DistCBD DistCBDsq DistInterstate"

**************** 
**Table 3, col 1
****************

xi:areg LogPrice CBGP1_Fail CBGP2_Fail CBGP3_Fail CBGP1-CBGP4 AvgElemTestScoresLag AvgMidTestScoresLag AvgHSTestScoresLag `covars1' ///
i.schs i.Time , abs(fips_year) cluster(fips)
test CBGP3_Fail=CBGP1_Fail


**************** 
**Table 6A, col 1
****************

local covars1 "acres fullbaths halfbaths bedrooms sqft sqftsquared age agesquared agecubed fireplace i.storyheigh i.aheatingty i.heatedfuel i.actype i.extwall  i.foundation i.bldggrade DistCBD DistCBDsq DistInterstate"

xi:areg LogPrice  CBGP1_Fail CBGP2_Fail CBGP3_Fail CBGP1-CBGP4 AvgElemTestScoresLag AvgMidTestScoresLag AvgHSTestScoresLag `covars1' i.schs i.Time, abs(fips_sch) cluster(fips)
test CBGP3_Fail=CBGP1_Fail



**************** 
**Evidence that effects occur for homes withe lots of bedrooms
****************


local covars1 "acres fullbaths halfbaths bedrooms sqft sqftsquared age agesquared agecubed fireplace i.storyheigh i.aheatingty i.heatedfuel i.actype i.extwall  i.foundation i.bldggrade DistCBD DistCBDsq DistInterstate"

gen lg_house = (bedrooms>=4)
foreach var of varlist  CBGP1-CBGP3  {
gen `var'_Fail_lg_house = AnyFailing*`var'*lg_house
}
gen AnyFailing_lg_house=AnyFailing*lg_house

xi:areg LogPrice  CBGP1_Fail CBGP2_Fail CBGP3_Fail AnyFailing_lg_house CBGP2_Fail_lg_house CBGP3_Fail_lg_house lg_house AvgElemTestScoresLag AvgMidTestScoresLag AvgHSTestScoresLag ///
`covars1'  i.schs i.Time   , abs(fips_year) cluster(fips)
test CBGP3_Fail=CBGP1_Fail




*****************************************
**BISECTING RESULT BY YEARS OF INITIAL FAIL
************************************************
use house_price.dta,clear
gen year_fail1 = Elemfailing*SchYear
gen year_fail2 = Midfailing*SchYear
replace year_fail1=. if  year_fail1==0
replace year_fail2=. if  year_fail2==0
by ElemSch0203 , sort: egen first_year_fail1= min(year_fail1)
by MidSch0203, sort: egen first_year_fail2= min(year_fail2)
egen first_year_fail = rowmin(first_year_fail1 first_year_fail2)
gen late_fail = (first_year_fail>2005 )
replace late_fail=. if first_year_fail==. 
gen years_fail = SchYear - first_year_fail
replace years_fail = 0 if years_fail==.

gen lt_since_fail = (years_fail>3)
tab first_year_fail if AnyFailing==1

foreach var of varlist AnyFailing CBGP1_Fail CBGP2_Fail CBGP3_Fail {
gen `var'_later = late_fail*`var'
replace `var'_later =0 if `var'_later==.
gen `var'_years	= `var'*years_fail
replace `var'_years = 0 if `var'_years==.
gen `var'_lt_since_fail	= `var'*lt_since_fail
replace `var'_lt_since_fail = 0 if `var'_lt_since_fail==.
}

local covars1 "acres fullbaths halfbaths bedrooms sqft sqftsquared age agesquared agecubed fireplace i.storyheigh i.aheatingty i.heatedfuel i.actype i.extwall  i.foundation i.bldggrade DistCBD DistCBDsq DistInterstate"

***************
**TABLE 10, col 1
**************

xi:areg LogPrice CBGP1_Fail_lt_since_fail CBGP2_Fail_lt_since_fail CBGP3_Fail_lt_since_fail CBGP1_Fail CBGP2_Fail CBGP3_Fail CBGP1-CBGP4 AvgElemTestScoresLag AvgMidTestScoresLag AvgHSTestScoresLag ///
 `covars1' i.schs i.Time , abs(fips_year) cluster(fips)
 test CBGP1_Fail_lt_since_fail=CBGP3_Fail_lt_since_fail
  test CBGP1_Fail=CBGP3_Fail


***************
**TABLE 3A, col 1
**************

xi:areg LogPrice CBGP1_Fail_years CBGP2_Fail_years CBGP3_Fail_years CBGP1_Fail CBGP2_Fail CBGP3_Fail CBGP1-CBGP4 AvgElemTestScoresLag AvgMidTestScoresLag AvgHSTestScoresLag ///
 `covars1' i.schs i.Time , abs(fips_year) cluster(fips)
  test CBGP1_Fail_years=CBGP3_Fail_years
    test CBGP1_Fail=CBGP3_Fail



*****************************
**FALSIFICATION TESTS
*****************************


use temp_reg.dta,clear
duplicates drop ElemSch0203 MidSch0203 SchYear, force
egen Neigh = group(ElemSch0203 MidSch0203)
keep AnyFailing SchYear Neigh ElemSch0203 MidSch0203
tsset Neigh SchYear
sort Neigh SchYear
by Neigh, sort: egen EverFail = max(AnyFailing)
by Neigh, sort: egen first_year_fail = min(SchYear) if AnyFailing==1
collapse (max) EverFail first_year_fail, by(ElemSch0203 MidSch0203)
save first_yr_fail_temp.dta,replace


use house_price.dta,clear
merge m:1 ElemSch0203 MidSch0203 using first_yr_fail_temp.dta
drop if _merge==2
drop _merge
sum EverFail AnyFailing
drop if AnyFailing==1 
sum EverFail AnyFailing
**This removes the cases of students after a school gets out of failing designation
drop if (EverFail==1 & SchYear>=first_year_fail)
sum EverFail AnyFailing
gen yrs_prior_fail = (first_year_fail - SchYear)
replace EverFail=0 if (EverFail==1 & (yrs_prior_fail <2))

sum EverFail AnyFailing

gen fail_false = EverFail
foreach var of varlist  CBGP1-CBGP4  {
gen fail_false_`var' = EverFail*`var'

}


**********
*Table 1A, col 1  - Years Prior to Failing
**********

local covars1 "acres fullbaths halfbaths bedrooms sqft sqftsquared age agesquared agecubed fireplace i.storyheigh i.aheatingty i.heatedfuel i.actype i.extwall  i.foundation i.bldggrade DistCBD DistCBDsq DistInterstate"


xi:areg LogPrice  fail_false_CBGP1 fail_false_CBGP2 fail_false_CBGP3 AvgElemTestScoresLag AvgMidTestScoresLag AvgHSTestScoresLag `covars1' ///
 i.schs i.Time, abs(fips_year) cluster(fips)  


use house_price.dta,clear
by ElemSch0203 MidSch0203, sort: egen ever_fail = max(AnyFailing)


local covars1 "acres fullbaths halfbaths bedrooms sqft sqftsquared age agesquared agecubed fireplace i.storyheigh i.aheatingty i.heatedfuel i.actype i.extwall  i.foundation i.bldggrade DistCBD DistCBDsq DistInterstate"

drop if AnyFailing==1

foreach var of varlist AnyFailing_false2 AnyFailing_false3  {
replace  `var'= 0 if CBGP4==1
}

***************
*Table  2A, col 1 - Based on AYP failing 
*************** 


xi:areg LogPrice  CBGP1_Fail_false2 CBGP2_Fail_false2 CBGP3_Fail_false2 ///
AvgElemTestScoresLag AvgMidTestScoresLag AvgHSTestScoresLag `covars1' i.schs i.Time, abs(fips_year) cluster(fips)


***************
*Table  9, col 1 - Based on Title 1 failing
*************** 
xi:areg LogPrice  CBGP1_Fail_false3 CBGP2_Fail_false3 CBGP3_Fail_false3 ///
AvgElemTestScoresLag AvgMidTestScoresLag AvgHSTestScoresLag `covars1' i.schs i.Time, abs(fips_year) cluster(fips)




*******************************
*RANDOM BOUNDARYS - PRICE MODELS - Table  9, col 1.
********************************

**Randomly shifting boundaries to get distribution of results

*95% width of all CBG = 2.3 miles = 12,144 feet (95%) /  9979 (95%) just failing
*base on avg. of all CBG = 0.8 miles = 4,244 feet (50%) /  3590 (50%) just failing

* For Failing..

global dist "3590"
global round "300"

set seed 123123

clear
set obs 1
gen test=1
save reg_false.dta, replace 


use house_price.dta, clear
*format fips %16.0g
drop if x==. | y==. | fips==""
keep acres fullbaths halfbaths bedrooms sqft sqftsquared age agesquared agecubed fireplace storyheigh ///
aheatingty heatedfuel actype extwall foundation bldggrade DistCBD DistCBDsq DistInterstate ///
LogPrice Time x y SchYear
save reg_temp4.dta,replace

use FullParcelLayer.dta, clear
duplicates drop taxpid, force
keep taxpid x y
save geo_info.dta,replace

use ParcelSchFinal1.dta,clear
duplicates drop taxpid, force
merge 1:1 taxpid using geo_info.dta
keep x y ElemSch0203 MidSch0203 hssch0203 fips
egen schs = group(ElemSch0203 MidSch0203 hssch0203)
save parcel_data.dta,replace

erase geo_info.dta

use ParcelSchFinal1.dta,clear
duplicates drop ElemSch0203 MidSch0203 fips SchYear, force
egen AnyFailing = rowtotal(Elemfailing Midfailing)
egen AvgElemTestScoresLag = rowmean(Elelagmath Elelagread)
egen AvgMidTestScoresLag = rowmean(Midlagmath Midlagread)
egen AvgHSTestScoresLag = rowmean(LagHSEngl LagHSAlg)
drop Elemfailing Midfailing Elelagmath Elelagread Midlagmath Midlagread LagHSEngl LagHSAlg
merge m:1 fips using fips_home.dta
drop _merge

foreach var of varlist  CBGP1-CBGP3  {
gen `var'_Fail = AnyFailing*`var'
}
save temp_f1.dta,replace





use reg_temp4.dta,clear
gen test_x = round(x, $round )
gen test_y = round(y, $round )
replace x = test_x
replace y = test_y
drop test_x test_y
save false_main.dta,replace

************************************ 
**START LOOP HERE. JUST RANDOM ONES.
************************************


forvalues i = 1/100 {
clear
set obs 1
gen a = 2*runiform() - 1
*gen a = runiform()
save test_r.dta

use parcel_data.dta,clear
cross using test_r.dta
erase test_r.dta
replace x = x + $dist *(1+a) if a>0
replace x = x - ($dist *(1-a)) if a<0
replace y = y + $dist *(1+a) if a>0
replace y = y - ($dist *(1-a)) if a<0
gen test_x = round(x, $round )
gen test_y = round(y, $round )
replace x = test_x
replace y = test_y
drop test_x test_y a
duplicates drop x y, force
save parcel.dta,replace


use false_main.dta, clear
merge m:1 x y using parcel.dta
keep if _merge==3
drop _merge
merge m:1 ElemSch0203 MidSch0203 fips SchYear using temp_f1.dta
drop _merge
save false_sch.dta,replace


est clear

egen fips_year = group(fips SchYear)

local covars1 "acres fullbaths halfbaths bedrooms sqft sqftsquared age agesquared agecubed fireplace i.storyheigh i.aheatingty i.heatedfuel i.actype i.extwall  i.foundation i.bldggrade DistCBD DistCBDsq DistInterstate"

xi:areg LogPrice CBGP1_Fail CBGP2_Fail CBGP3_Fail CBGP1-CBGP4 AvgElemTestScoresLag AvgMidTestScoresLag AvgHSTestScoresLag ///
 `covars1' i.schs i.Time , abs(fips_year) cluster(fips)
regsave,  pval  
gen boot_count = `i'
append using reg_false.dta
save reg_false.dta, replace 
 
}




use reg_false.dta, clear
gen CBGP1_Fail = coef if var=="CBGP1_Fail"
gen CBGP2_Fail = coef if var=="CBGP2_Fail"
gen CBGP3_Fail = coef if var=="CBGP3_Fail"

estpost tabstat CBGP1_Fail CBGP2_Fail CBGP3_Fail , missing   ///
statistics(mean sd) columns(statistics)

esttab using Falsification.csv, append main(mean) aux(sd) nostar unstack obslast ///
mtitles("LogPrice") 





*************************
**INDIVIDUAL MORTGAGE INCOME
*************************
use temp_reg.dta,clear
gen match=(mortdate~=.)
gen samedate_mortgage=(mortdate==saledate & mortdate~=.)
gen prior30_mortgage=(saledate-mortdate<=31 & saledate-mortdate>=0 & mortdate~=.)
sum match-prior30_mortgage
order taxpid match samedate_mortgage prior30_mortgage salesprice1 SalesDate1 loanamount1 saleprice saledate mortdate salesprice1 SalesDate1
keep if prior30_mortgage==1
gen LogIncome = ln(MortgIncome)
gen LogIncomeAlt = ln(MortgIncomeAlt)
duplicates drop mort_id mortdate, force

gen bad_obs =(MortgIncome >= loanamount1)
save mort_data.dta,replace



use mort_data.dta, clear
*mortgage data limited to 2004-2010
keep if SchYear>2003



*******************************
**Table 3, col 2-3
*********************************

*a) all mortgages

xi:areg LogIncome  CBGP1_Fail  CBGP2_Fail CBGP3_Fail CBGP1-CBGP4  AvgElemTestScoresLag AvgMidTestScoresLag AvgHSTestScoresLag  ///
 i.schs i.Time , abs(fips_year) cluster(fips)


*b) remove potential non-owner occupied

xi:areg LogIncome  CBGP1_Fail  CBGP2_Fail CBGP3_Fail CBGP1-CBGP4  AvgElemTestScoresLag AvgMidTestScoresLag AvgHSTestScoresLag ///
i.schs i.Time if owner~=0, abs(fips_year) cluster(fips)




******************************************
**Table 6A, col 2-3
******************************************

use mort_data.dta, clear

keep if SchYear>2003


*a) all mortgages

xi:areg LogIncome  CBGP1_Fail CBGP2_Fail CBGP3_Fail CBGP1-CBGP4  AvgElemTestScoresLag AvgMidTestScoresLag AvgHSTestScoresLag  ///
 i.schs i.Time , abs(fips_sch) cluster(fips)


*b) remove potential non-owner occupied

xi:areg LogIncome  CBGP1_Fail  CBGP2_Fail CBGP3_Fail CBGP1-CBGP4  AvgElemTestScoresLag AvgMidTestScoresLag AvgHSTestScoresLag ///
i.schs i.Time if owner~=0, abs(fips_sch) cluster(fips)



*****************************************
**BISECTING RESULT BY YEARS OF INITIAL FAIL
************************************************

use mort_data.dta, clear
merge m:1 ElemSch0203 MidSch0203 using first_yr_fail_temp.dta
gen late_fail = (first_year_fail>2005 )
replace late_fail=. if first_year_fail==. 
keep if SchYear>2003

**70% of sales ever assigned to a failing school have school that fails for first time in 2005
tab first_year_fail if AnyFailing==1

gen years_fail = SchYear - first_year_fail
replace years_fail = 0 if years_fail==.


foreach var of varlist AnyFailing CBGP1_Fail CBGP2_Fail CBGP3_Fail {
gen `var'_later = late_fail*`var'
replace `var'_later =0 if `var'_later==.
gen `var'_years	= `var'*years_fail
replace `var'_years = 0 if `var'_years==.
}

******************************************
**Table 3A, col 2
******************************************

xi:areg LogIncome AnyFailing_years CBGP2_Fail_years CBGP3_Fail_years AnyFailing CBGP2_Fail CBGP3_Fail CBGP1-CBGP4 AvgElemTestScoresLag AvgMidTestScoresLag AvgHSTestScoresLag ///
i.schs i.Time , abs(fips_year) cluster(fips)
outreg2 using Regressions1_18_17, keep(AnyFailing_years CBGP2_Fail_years CBGP3_Fail_years AnyFailing CBGP2_Fail CBGP3_Fail) ///
alpha(0.01, 0.05, 0.10) nocons excel dec(3)  nor2 ct(LogIncome , bisect by years since fail ) append

xi:areg LogIncome CBGP1_Fail_years CBGP2_Fail_years CBGP3_Fail_years AnyFailing CBGP2_Fail CBGP3_Fail CBGP1-CBGP4 AvgElemTestScoresLag AvgMidTestScoresLag AvgHSTestScoresLag ///
i.schs i.Time , abs(fips_year) cluster(fips)
outreg2 using Regressions1_18_17, keep(CBGP1_Fail_years CBGP2_Fail_years CBGP3_Fail_years CBGP1_Fail CBGP2_Fail CBGP3_Fail) ///
alpha(0.01, 0.05, 0.10) nocons excel dec(3)  nor2 ct(LogIncome , bisect by years since fail ) append

******************************************
**Table 10, col 2
******************************************

xi:areg LogIncome  AnyFailing_later  CBGP2_Fail_later CBGP3_Fail_later AnyFailing CBGP2_Fail CBGP3_Fail CBGP1-CBGP4  AvgElemTestScoresLag AvgMidTestScoresLag AvgHSTestScoresLag  ///
 i.schs i.Time , abs(fips_year) cluster(fips)
outreg2 using Regressions1_18_17, keep(AnyFailing_later CBGP2_Fail_later CBGP3_Fail_later AnyFailing CBGP2_Fail CBGP3_Fail) ///
alpha(0.01, 0.05, 0.10) nocons excel dec(3)  nor2 ct(LogIncome , bisect by year initial fail,  all mortgages ) append

xi:areg LogIncome   CBGP1_Fail_later CBGP2_Fail_later CBGP3_Fail_later CBGP1_Fail CBGP2_Fail CBGP3_Fail CBGP1-CBGP4  AvgElemTestScoresLag AvgMidTestScoresLag AvgHSTestScoresLag  ///
 i.schs i.Time , abs(fips_year) cluster(fips)
outreg2 using Regressions1_18_17, keep( CBGP1_Fail_later CBGP2_Fail_later CBGP3_Fail_later CBGP1_Fail CBGP2_Fail CBGP3_Fail) ///
alpha(0.01, 0.05, 0.10) nocons excel dec(3)  nor2 ct(LogIncome , bisect by year initial fail,  all mortgages ) append



*******************************************
**TRY RACE OF INDIVIDUALS AS OUTCOME 
*************************************************


**NO EFFECTS

use mort_data.dta, clear
gen black=( applicantrace1==3 )
gen white=( applicantrace1==5 )
gen hispanic=( applicantethnicity==1 )
gen non_white=(black==1 | hispanic==1)

replace black=. if ( applicantrace1==6 | applicantrace1==7 )
replace hispanic=. if ( applicantrace1==6 | applicantrace1==7 )
replace non_white=. if ( applicantrace1==6 | applicantrace1==7 )
replace white=. if ( applicantrace1==6 | applicantrace1==7 )

keep if SchYear>2003



xi:areg black  CBGP1_Fail  CBGP2_Fail CBGP3_Fail CBGP1-CBGP4  AvgElemTestScoresLag AvgMidTestScoresLag AvgHSTestScoresLag ///
  i.schs i.Time , abs(fips_year) cluster(fips)
outreg2 using Regressions1_18_17, keep( CBGP1_Fail CBGP2_Fail CBGP3_Fail ) ///
alpha(0.01, 0.05, 0.10) nocons excel dec(3)  nor2 ct(black, mortgage applicant) append



xi:areg hispanic  CBGP1_Fail CBGP2_Fail CBGP3_Fail CBGP1-CBGP4  AvgElemTestScoresLag AvgMidTestScoresLag AvgHSTestScoresLag  ///
 i.schs i.Time , abs(fips_year) cluster(fips)
outreg2 using Regressions1_18_17, keep( CBGP1_Fail CBGP2_Fail CBGP3_Fail ) ///
alpha(0.01, 0.05, 0.10) nocons excel dec(3)  nor2 ct(hispanic, mortgage applicant) append


xi:areg white  CBGP1_Fail  CBGP2_Fail CBGP3_Fail CBGP1-CBGP4  AvgElemTestScoresLag AvgMidTestScoresLag AvgHSTestScoresLag  ///
 i.schs i.Time , abs(fips_year) cluster(fips)
outreg2 using Regressions1_18_17, keep( CBGP1_Fail CBGP2_Fail CBGP3_Fail ) ///
alpha(0.01, 0.05, 0.10) nocons excel dec(3)  nor2 ct(white, mortgage applicant) append








use mort_data.dta, clear
merge m:1 ElemSch0203 MidSch0203 using first_yr_fail_temp.dta
drop if _merge==2
drop _merge
sum EverFail AnyFailing
drop if AnyFailing==1 
sum EverFail AnyFailing
**This removes the cases of students after a school gets out of failing designation
drop if (EverFail==1 & SchYear>=first_year_fail)
sum EverFail AnyFailing
gen yrs_prior_fail = (first_year_fail - SchYear)
replace EverFail=0 if (EverFail==1 & (yrs_prior_fail <2))

sum EverFail AnyFailing

gen fail_false = EverFail
foreach var of varlist  CBGP1-CBGP4  {
gen fail_false_`var' = EverFail*`var'

}

**********
*Table 1A, col 2  - Years Prior to Failing
**********

xi:areg LogIncome  fail_false fail_false_CBGP2 fail_false_CBGP3 AvgElemTestScoresLag AvgMidTestScoresLag AvgHSTestScoresLag  ///
 i.schs i.Time if SchYear<=2011, abs(fips_year) cluster(fips)  



use mort_data.dta, clear

by ElemSch0203 MidSch0203, sort: egen ever_fail = max(AnyFailing)
keep if SchYear>2003

drop if AnyFailing==1

foreach var of varlist AnyFailing_false AnyFailing_false2 {
replace  `var'= 0 if CBGP4==1
}


***************
*Table  2A, col 2 - Based on AYP failing 
*************** 



xi:areg LogIncome  CBGP1_Fail_false2 CBGP2_Fail_false2 CBGP3_Fail_false2 ///
AvgElemTestScoresLag AvgMidTestScoresLag AvgHSTestScoresLag  i.schs i.Time, abs(fips_year) cluster(fips)



***************
*Table  9, col 2 - Based on Title 1 failing
*************** 

xi:areg LogIncome  CBGP1_Fail_false3 CBGP2_Fail_false3 CBGP3_Fail_false3 ///
AvgElemTestScoresLag AvgMidTestScoresLag AvgHSTestScoresLag  i.schs i.Time, abs(fips_year) cluster(fips)



***************
*- Table  9, col 1. - income, random boundaries
***************
*95% width of all CBG = 2.3 miles = 12,144 feet (95%) /  9979 (95%) just failing
*base on avg. of all CBG = 0.8 miles = 4,244 feet (50%) /  3590 (50%) just failing

* For Failing..

global dist "3590"
global round "300"


*testing for simulation error
set seed 342566

clear
set obs 1
gen test=1
save reg_false.dta, replace 


use mort_data.dta, clear
keep if SchYear>2003
drop if x==. | y==. | fips==""
keep LogIncome Time x y SchYear
save reg_temp4.dta,replace

use FullParcelLayer.dta, clear
duplicates drop taxpid, force
keep taxpid x y
save geo_info.dta,replace

use ParcelSchFinal1.dta,clear
duplicates drop taxpid, force
merge 1:1 taxpid using geo_info.dta
keep x y ElemSch0203 MidSch0203 hssch0203 fips
egen schs = group(ElemSch0203 MidSch0203 hssch0203)
save parcel_data.dta,replace

erase geo_info.dta

use ParcelSchFinal1.dta,clear
duplicates drop ElemSch0203 MidSch0203 fips SchYear, force
egen AnyFailing = rowtotal(Elemfailing Midfailing)
egen AvgElemTestScoresLag = rowmean(Elelagmath Elelagread)
egen AvgMidTestScoresLag = rowmean(Midlagmath Midlagread)
egen AvgHSTestScoresLag = rowmean(LagHSEngl LagHSAlg)
drop Elemfailing Midfailing Elelagmath Elelagread Midlagmath Midlagread LagHSEngl LagHSAlg
merge m:1 fips using fips_home.dta
drop _merge

foreach var of varlist  CBGP1-CBGP3  {
gen `var'_Fail = AnyFailing*`var'
}
save temp_f1.dta,replace


use reg_temp4.dta,clear
gen test_x = round(x, $round )
gen test_y = round(y, $round )
replace x = test_x
replace y = test_y
drop test_x test_y
save false_main.dta,replace

************************************ 
**START LOOP HERE. JUST RANDOM ONES.
************************************


forvalues i = 1/100 {
clear
set obs 1
gen a = 2*runiform() - 1
*gen a = runiform()
save test_r.dta

use parcel_data.dta,clear
cross using test_r.dta
erase test_r.dta
replace x = x + $dist *(1+a) if a>0
replace x = x - ($dist *(1-a)) if a<0
replace y = y + $dist *(1+a) if a>0
replace y = y - ($dist *(1-a)) if a<0
gen test_x = round(x, $round )
gen test_y = round(y, $round )
replace x = test_x
replace y = test_y
drop test_x test_y a
duplicates drop x y, force
save parcel.dta,replace


use false_main.dta, clear
merge m:1 x y using parcel.dta
keep if _merge==3
drop _merge
merge m:1 ElemSch0203 MidSch0203 fips SchYear using temp_f1.dta
drop _merge
save false_sch.dta,replace


est clear

egen fips_year = group(fips SchYear)

xi:areg LogIncome  CBGP1_Fail CBGP2_Fail CBGP3_Fail CBGP1-CBGP4  AvgElemTestScoresLag AvgMidTestScoresLag AvgHSTestScoresLag  ///
 i.schs i.Time , abs(fips_year) cluster(fips)
regsave,  pval  
gen boot_count = `i'
append using reg_false.dta
save reg_false.dta, replace 
 
}




use reg_false.dta, clear
gen CBGP1_Fail = coef if var=="CBGP1_Fail"
gen CBGP2_Fail = coef if var=="CBGP2_Fail"
gen CBGP3_Fail = coef if var=="CBGP3_Fail"

estpost tabstat CBGP1_Fail CBGP2_Fail CBGP3_Fail , missing   ///
statistics(mean sd) columns(statistics)

esttab using Falsification.csv, append main(mean) aux(sd) nostar unstack obslast ///
mtitles("LogIncome") 



****
*CREATING STUDENT DATA FOR REGRESSION
*****



*use "STUDENT FILE 1999-2011 geocoded in ArcGIS", clear
use "C:\Research\BillingsCMS\geocodedcms99_11.dta", clear
keep  x y s_lasid s_year s_firstnam s_lastname s_middlena s_appelnam s_zip taxpid 
rename s_firstnam s_firstname 
rename s_middlena s_middlename  
rename s_appelnam s_appelname
save geotemp.dta,replace


use FullParcelLayer.dta,clear
sort taxpid cardno
keep taxpid descproper salesprice1- SalesDate5 acres fullbaths halfbaths heatedarea yearbuilt extravalue landvalue descbuildi neighcode 
duplicates drop taxpid, force
save temp1.dta,replace

*use TEST SCORE FILE 1999-2011, clear
use "C:\Research\BillingsCMS\cms_student_tests2.dta", clear
**Coding Correction told for me by Andy Baxter on 06/5/2012
replace s_lasid=8000000 + s_lasid if s_lasid < 8000000
collapse (mean) s_math_zd s_read_zd s_engl_zd s_alg1_zd ,by(s_lasid s_year)
drop if s_year<1999
save temp2.dta,replace

use ParcelSchFinal1.dta, clear
keep taxpid fips ElemSch0203 MidSch0203 hssch0203
duplicates drop
save p_temp.dta,replace

*use STUDENT FILE 1999-2011, clear
use "C:\Research\BillingsCMS\cms_student\cms_student.dta", clear
drop if s_grade<-1
merge 1:1 s_lasid s_year using geotemp.dta, update
drop _merge
rename x x_parcel
rename y y_parcel


keep s_lasid s_year s_yr1_in_schl s_yearscms s_schoolcode s_grade s_male s_race s_dob s_age s_firstname s_lastname s_zip s_city s_address ///
x_parcel y_parcel taxpid  s_moves_btyr s_moves_wiyr 
merge 1:1 s_lasid s_year using temp2.dta
drop if _merge==2
drop _merge
merge m:1 taxpid using temp1.dta, update
drop if _merge==2
drop _merge
sort s_lasid s_year
tsset s_lasid s_year
by s_lasid, sort: carryforward taxpid, replace

rename s_year SchYear
merge m:1 taxpid SchYear using ParcelSchFinal1.dta
tab _merge
drop if _merge==2
drop _merge
**filling in some missing neighborhood (02-03) info for students
merge m:1 taxpid using p_temp.dta, update
tab _merge
drop if _merge==2


egen Neigh =group(ElemSch0203 MidSch0203 fips)

*Prev Year Moved
sort s_lasid SchYear
tsset s_lasid SchYear
by s_lasid, sort: gen lagNeigh = Neigh[_n-1]
gen PrevYrMoved = ((Neigh~=lagNeigh) & Neigh~=.)
replace PrevYrMoved = . if lagNeigh==.
gen EnterCMSTransfer =(s_grade>=0 & PrevYrMoved==.)



**Next Year Moved
by s_lasid, sort: gen leadNeigh = Neigh[_n+1]
gen NextYrMoved = ((Neigh~=leadNeigh) & Neigh~=.)
replace NextYrMoved = . if leadNeigh==.
gen ExitCMSTransfer =(s_grade<9 & NextYrMoved==.)



forval num = 1/5 {
generate sales`num'schyear = year(SalesDate`num')
generate sales`num'schqt = quarter(SalesDate`num')
replace sales`num'schyear = sales`num'schyear + 1 if sales`num'schqt >2
gen moved_prior_schyr`num' =((SchYear - sales`num'schyear)<=1 & (SchYear - sales`num'schyear)>=0)
replace moved_prior_schyr`num' =. if salesprice`num' < 10000
gen moved_next_schyr`num' =((SchYear - sales`num'schyear)<0 & (SchYear - sales`num'schyear)>=-1)
replace moved_next_schyr`num' =. if salesprice`num' < 10000
gen years_neigh`num' = (SchYear - sales`num'schyear)
replace years_neigh`num' =. if salesprice`num' < 10000
}

egen moved_prior_schyr_sales=rowmax(moved_prior_schyr1 moved_prior_schyr2 moved_prior_schyr3 moved_prior_schyr4 moved_prior_schyr5)
egen moved_next_schyr_sales=rowmax(moved_next_schyr1 moved_next_schyr2 moved_next_schyr3 moved_next_schyr4 moved_next_schyr5)

gen years_neigh_sales = years_neigh1
forval num = 2/5 {
replace years_neigh_sales = years_neigh`num' if years_neigh_sales<0
}
replace years_neigh_sales = . if years_neigh_sales<0
replace years_neigh_sales = 1 if (moved_prior_schyr_sales==1 | PrevYrMoved==1)
by s_lasid, sort: gen lag_year_neigh_sales=years_neigh_sales[_n-1]
replace years_neigh_sales = lag_year_neigh_sales + 1 if (Neigh==lagNeigh & Neigh~=.) & years_neigh_sales==.
replace years_neigh_sales = lag_year_neigh_sales + 1 if (Neigh==lagNeigh & Neigh~=.) 
replace moved_prior_schyr_sales=1 if PrevYrMoved==1
replace moved_next_schyr_sales=1 if NextYrMoved==1
order SchYear s_lasid s_grade moved_prior_schyr_sales moved_next_schyr_sales years_neigh_sales SalesDate1 SalesDate2 SalesDate3 PrevYrMoved NextYrMoved
keep SchYear-years_neigh_sales  PrevYrMoved- halfbaths acres descproper neighcode EnterCMSTransfer ExitCMSTransfer fips Neigh Elemfailing Midfailing ///
Elelagmath Elelagread Midlagmath Midlagread LagHSEngl LagHSAlg ElemSch0203 MidSch0203 hssch0203



**Only can merge from 2003 on, but can use info from prior years.
keep if SchYear>=2002
save indiv_movt_test.dta,replace 


use IndividMortg.dta, clear
gen SchYear = year if quarter<=2
replace SchYear=year+1 if quarter>2
collapse (max) owner, by(taxpid SchYear)
keep taxpid SchYear owner
save temp.dta,replace

use indiv_movt_test.dta,clear
merge m:1 taxpid SchYear using temp.dta
tab owner if _merge==3
tab owner if _merge==2
drop if _merge==2
drop _merge

sort s_lasid SchYear
by s_lasid ,sort: replace owner = owner[_n-1] if (owner==. & taxpid==taxpid[_n-1])
by s_lasid ,sort: replace owner = owner[_n-2] if (owner==. & taxpid==taxpid[_n-2])
by s_lasid ,sort: replace owner = owner[_n-3] if (owner==. & taxpid==taxpid[_n-3])
by s_lasid ,sort: replace owner = owner[_n-4] if (owner==. & taxpid==taxpid[_n-4])
by s_lasid ,sort: replace owner = owner[_n-5] if (owner==. & taxpid==taxpid[_n-5])
by s_lasid ,sort: replace owner = owner[_n-6] if (owner==. & taxpid==taxpid[_n-6])
by s_lasid ,sort: replace owner = owner[_n-7] if (owner==. & taxpid==taxpid[_n-7])
by s_lasid ,sort: replace owner = owner[_n-8] if (owner==. & taxpid==taxpid[_n-8])
label variable owner "indicator if can distinguish owner=0/1 from mortgages. missing otherwise"
gen SF_parcels = (descproper=="Single-Fam")

**Current Neigh CBGIncome data
merge m:1 fips using CBGData.dta
drop if _merge==2


save indiv_movt_test2.dta,replace


*A) all students

**individual non-comp student
use non_comp_student.dta,clear
keep s_lasid s_year AttendNonAssignedSch s_schoolcode
rename s_year SchYear
save non_comp_student2.dta,replace



use indiv_movt_test2.dta, clear
gen AnyFailing =( Elemfailing==1 | Midfailing==1 )
drop Elemfailing Midfailing

label variable AnyFailing "Failing School"

drop _merge
merge m:1 fips using CBGData.dta
quietly tab CBGQuints, gen(CBG)
drop _merge

merge m:1 neighcode using temp_neighcbg.dta
drop if _merge==2
drop _merge

merge m:1 fips using fips_home.dta
drop _merge



rename AnyFailing AnyFailing_cur
merge m:1 ElemSch0203 MidSch0203 SchYear using t1.dta
*Schools created after 2003
foreach var of varlist AnyFailing_false AnyFailing_false2 AnyFailing  {
replace `var'=0 if _merge==1
}
drop if _merge==2
drop _merge

sort s_lasid SchYear
tsset s_lasid SchYear


gen test = (PrevYrMoved==1 & SchYear>=2003)
by s_lasid, sort: egen first_yrmove1 = min(SchYear) if test==1
by s_lasid, sort: carryforward first_yrmove1, replace
gen mover=(SchYear>=first_yrmove1)
drop test first_yrmove1


gen prev_mover_fail=( PrevYrMoved==1 & AnyFailing==1 & SchYear>=2003)
by s_lasid, sort: egen first_yrmove_fail = min(SchYear) if prev_mover_fail==1
by s_lasid, sort: carryforward first_yrmove_fail, replace
gen mover_fail=(SchYear>=first_yrmove_fail)
drop prev_mover_fail first_yrmove_fail


gen test = (NextYrMoved==1 & SchYear>=2003)
by s_lasid, sort: egen first_yrmove1 = min(SchYear) if test==1
by s_lasid, sort: carryforward first_yrmove1, replace
gen mover_out=(SchYear>=first_yrmove1)
drop test first_yrmove1


gen prev_mover_fail=( NextYrMoved==1 & AnyFailing==1 & SchYear>=2003)
by s_lasid, sort: egen first_yrmove_fail = min(SchYear) if prev_mover_fail==1
by s_lasid, sort: carryforward first_yrmove_fail, replace
gen mover_fail_out=(SchYear>=first_yrmove_fail)


by s_lasid, sort:egen any_move = max(PrevYrMoved)

gen alt_schyr = SchYear - years_neigh_sales + 1



**Current Year School attended for 02-03 boundaries

egen schs=group(ElemSch0203 MidSch0203 hssch0203)
**Only doing middle and elementary school kids
keep if s_grade<9
save reg.dta,replace

**Student Count
use reg.dta,clear
gen c=1
collapse (sum) c ,by(fips SchYear)



*Generating First test Score in CMS to control for student type
use reg.dta,clear
merge 1:1 s_lasid SchYear using non_comp_student2.dta
drop if _merge==2
**missing information on school attended? 2%
replace AttendNonAssignedSch=0 if AttendNonAssignedSch==.
drop _merge 
sort s_lasid SchYear
tsset s_lasid SchYear
by s_lasid, sort: egen first_test_year_math = min(SchYear) if s_math_zd~=.
gen first_year_math = s_math_zd if first_test_year_math==SchYear
by s_lasid, sort: carryforward first_year_math, replace
gen test_math_lag = first_year_math
replace test_math_lag=. if SchYear<=first_test_year_math

by s_lasid, sort: egen first_test_year_read = min(SchYear) if s_read_zd~=.
gen first_year_read = s_read_zd if first_test_year_read==SchYear
by s_lasid, sort: carryforward first_year_read, replace
gen test_read_lag = first_year_read
replace test_read_lag=. if SchYear<=first_test_year_read

gen missing_math_test=(test_math_lag==.)
gen missing_read_test=(test_read_lag==.)
replace test_math_lag=0 if missing_math_test==1
replace test_read_lag=0 if missing_read_test==1


**based on schools that are never assigned to anyone
gen AttendMagnetSchl=(s_schoolcode<300 | s_schoolcode==334 | s_schoolcode==336 ///
| s_schoolcode==344 | s_schoolcode==358 | s_schoolcode==364  | s_schoolcode==375  ///
| s_schoolcode==384  | s_schoolcode==386  | s_schoolcode==405  | s_schoolcode==429 ///
| s_schoolcode==439 | s_schoolcode==454 | s_schoolcode==456 | s_schoolcode==461 ///
| s_schoolcode==488  | s_schoolcode==496  | s_schoolcode==497  | s_schoolcode==498 ///
| s_schoolcode==513  | s_schoolcode==532  | s_schoolcode==565 | s_schoolcode==586 ///
| s_schoolcode>600)

**There are some schools that are partial magnets and thus coded as magnets but some people are also assigned to them.
*Could code either way---> similar results
replace AttendMagnetSchl=0 if AttendNonAssignedSch==0
gen AttendNonAssignedPublicSchl=(AttendMagnetSchl==0 & AttendNonAssignedSch==1)
sum AttendNonAssignedSch AttendMagnetSchl AttendNonAssignedPublicSchl

sort s_lasid SchYear
tsset s_lasid SchYear
by s_lasid, sort: gen test1 = s_schoolcode if SchYear==2003
by s_lasid, sort: egen test2 = max(test1)
gen new_school=(s_schoolcode~=test2)
replace new_school=. if test2==.

tsset s_lasid SchYear
sort s_lasid SchYear
by s_lasid, sort: gen alttest1 = L1.s_schoolcode if PrevYrMoved==1 & SchYear==2003
forval num= 2004/2011 {

by s_lasid, sort: replace alttest1 = L1.s_schoolcode if PrevYrMoved==1 & SchYear==`num' & alttest1==.
}

bysort s_lasid: carryforward alttest1, gen(alttest2)
gen altnew_school =(s_schoolcode~=alttest2)
order s_lasid SchYear NextYrMoved PrevYrMoved s_schoolcode new_school altnew_school test1 alttest1 test2 alttest2


**dealing with non-movers
replace altnew_school=0 if alttest2==.
drop alttest1 alttest2 test1 test2
**Treating first year in CMS as new school


gen NewAttendNonAssignedSch = AttendNonAssignedSch *new_school
gen NewAttendMagnetSchl = AttendMagnetSchl *new_school
gen NewAttendNonAssPublicSchl = AttendNonAssignedPublicSchl*new_school

gen AltNewAttendNonAssignedSch = AttendNonAssignedSch *altnew_school
gen AltNewAttendMagnetSchl = AttendMagnetSchl *altnew_school
gen AltNewAttendNonAssPublicSchl = AttendNonAssignedPublicSchl*altnew_school



local lagtest "test_math_lag test_read_lag missing_math_test missing_read_test"
egen fips_year = group(fips SchYear)
egen fips_sch = group(fips ElemSch0203 MidSch0203)





foreach var of varlist  CBGP1-CBGP4  {
gen `var'_Fail = AnyFailing*`var'


}

gen owner1=(owner~=0 & SF_parcels==1)
foreach var of varlist  AnyFailing {
gen `var'_owner = `var'*owner1



}

foreach var of varlist  CBGP1-CBGP4 {
gen `var'_Fail_owner = `var'*owner1*AnyFailing
}



foreach var of varlist  CBGP1-CBGP4 {
gen `var'_prevyr_mover = `var'*PrevYrMoved
gen `var'_mover = `var'*mover
gen `var'_mover_fail = `var'*mover_fail
gen `var'_any_move  = `var'*any_move 


}

foreach var of varlist  AnyFailing CBGP1_Fail CBGP2_Fail CBGP3_Fail CBGP4_Fail {
gen `var'_prevyr_mover = `var'*PrevYrMoved
gen `var'_mover = `var'*mover
gen `var'_mover_fail = `var'*mover_fail
gen `var'_any_move  = `var'*any_move 

}



save temp_reg2.dta,replace
drop if SchYear==2002


save reg2.dta,replace


**need to keep this to create ass_sch_panel
use reg2.dta, clear
gen Count=1
collapse (sum) AttendMagnetSchl AttendNonAssignedPublicSchl Count, by(fips ElemSch0203 MidSch0203 SchYear)
save ass_sch_panel.dta,replace




*******************************
**Only students in CMS in 2003
******************************
use reg2.dta,clear
by s_lasid, sort: egen first_cms_yr = min(SchYear)
keep if first_cms_yr<=2003
save reg3.dta,replace





********************************************************
**Fixing Residents to be in Same Neigh from 2003 forward
********************************************************

use reg3.dta,clear
keep if SchYear==2003
keep s_lasid ElemSch0203 MidSch0203 hssch0203 taxpid fips Neigh 
save temp_s.dta,replace

use reg3.dta,clear
drop x_parcel y_parcel taxpid extravalue- MidSch0203 LagHSEngl- Neigh ///
 owner CBGMedianHHIncome- CBG4 weighted_cbg_income weighted_cbg_quints mover- schs fips_year- first_cms_yr
merge m:1 s_lasid using temp_s.dta

drop _merge
merge m:1 fips using CBGData.dta
quietly tab CBGQuints, gen(CBG)
drop _merge

merge m:1 fips using fips_home.dta
drop _merge

rename AnyFailing AnyFailing_cur
merge m:1 ElemSch0203 MidSch0203 SchYear using t1.dta
*Schools created after 2003
foreach var of varlist AnyFailing_false AnyFailing_false2 AnyFailing  {
replace `var'=0 if _merge==1
}
drop if _merge==2
drop _merge

sort s_lasid SchYear
tsset s_lasid SchYear


egen schs=group(ElemSch0203 MidSch0203 hssch0203)

local lagtest "test_math_lag test_read_lag missing_math_test missing_read_test"
egen fips_year = group(fips SchYear)
egen fips_sch = group(fips ElemSch0203 MidSch0203)


foreach var of varlist  CBGP1-CBGP4  {
gen `var'_Fail = AnyFailing*`var'


}

save reg4.dta,replace




**BALANCING TEST

use FinalPanel3.dta, clear
gen TotalSalesParcel = TotalSales/SFParcels
drop TotalStudents TotalStudentsPerParcel
egen TotalStudents = rowtotal(ElemStudents MidStudents)
gen TotalStudentsPerParcel = TotalStudents/SFParcels
replace TotalSalesParcel=0 if TotalSalesParcel==.
replace TotalStudentsPerParcel=0 if TotalStudentsPerParcel==.
**generating annualized values from quarterly values
collapse  (sum) TotalSalesParcel (mean) TotalStudents    ///
TotalStudentsPerParcel  PortionNonComp TotalParcels SFParcels MeanPriceSqFt, by(ElemSch0203 MidSch0203 fips SchYear)
egen Neigh =group(ElemSch0203 MidSch0203 fips)
tsset Neigh SchYear
keep if SchYear==2003
save temp.dta, replace

use FinalPanel3.dta, clear
gen TotalSalesParcel = TotalSales/SFParcels
drop TotalStudents TotalStudentsPerParcel
egen TotalStudents = rowtotal(ElemStudents MidStudents)
gen TotalStudentsPerParcel = TotalStudents/SFParcels
replace TotalSalesParcel=0 if TotalSalesParcel==.
replace TotalStudentsPerParcel=0 if TotalStudentsPerParcel==.
**generating annualized values from quarterly values
collapse  (sum) TotalSalesParcel (mean) TotalStudents    ///
TotalStudentsPerParcel  PortionNonComp TotalParcels SFParcels MeanPriceSqFt, by(ElemSch0203 MidSch0203 fips SchYear)
egen Neigh =group(ElemSch0203 MidSch0203 fips)
tsset Neigh SchYear
save temp_alt.dta, replace

keep if SchYear==2003
collapse (mean) Prior2002_PriceSqFt=MeanPriceSqFt Prior2002_TotalSales=TotalSalesParcel , by(ElemSch0203 MidSch0203 fips)
save temp_alt2.dta, replace

**fixes people to 2003 neighborhood
use reg4.dta,clear
collapse (max) Fail=AnyFailing, by(fips ElemSch0203 MidSch0203)
save reg_f.dta,replace



*Do individual level measure of balancing test
use temp_parcel.dta,clear
keep taxpid eschid01 mschid01
save temp_parcel2.dta,replace

use reg4.dta,clear
keep s_lasid SchYear AvgElemTestScoresLag AvgMidTestScoresLag AvgHSTestScoresLag
*Since using one year lag Test Scores - 2004 data will gives 2003
keep if SchYear==2004
drop SchYear
save temp2.dta,replace


****Housing Prices - add into model
use prices00_02.dta, clear
keep if (SchYear>=1998 & SchYear<=2002)
gen price1= exp(LogPrice)
drop if price1<10000 | price1>999999
by fips MidSch0203 ElemSch0203, sort: egen fips_sch_avg_price = mean(price1)
gen price1998 = price1 if SchYear==1998 | SchYear==1999
gen price2002 = price1 if SchYear==2002 | SchYear==2001
by fips MidSch0203 ElemSch0203, sort: egen fips_sch_avg_price1998 = mean(price1998)
by fips MidSch0203 ElemSch0203, sort: egen fips_sch_avg_price2002 = mean(price2002)
gen fips_sch_avg_price_chg = fips_sch_avg_price2002 - fips_sch_avg_price1998
keep fips MidSch0203 ElemSch0203 fips_sch_avg_price fips_sch_avg_price_chg
duplicates drop fips MidSch0203 ElemSch0203, force
save prices_balance.dta,replace



use reg4.dta,clear
gen black =(s_race==1)
gen hispanic=(s_race==3)
keep if ( s_grade<=8)
merge m:1 fips ElemSch0203 MidSch0203 using temp.dta
keep if _merge==3
drop _merge
merge m:1 fips ElemSch0203 MidSch0203 using reg_f.dta
drop _merge
drop if s_lasid==.

drop  missing_math_test missing_read_test
merge m:1 taxpid using temp_parcel2.dta
drop if _merge==2
drop _merge
merge m:1 s_lasid using temp2.dta, update replace
drop _merge
erase temp2.dta


tsset s_lasid SchYear
sort s_lasid SchYear
gen missing_math_test =(s_math_zd==.)
gen missing_read_test =(s_read_zd==.)
replace s_math_zd=0 if missing_math_test==1
replace s_read_zd=0 if missing_read_test==1


foreach var of varlist AttendNonAssignedSch SF_parcels s_male black hispanic s_read_zd s_math_zd missing_math_test missing_read_test {
by ElemSch0203 MidSch0203, sort: egen S`var' = mean(`var')
}




keep if SchYear==2003
egen prevsch_cbg_fe = group(fips mschid01 eschid01)
save summary_students.dta,replace




merge m:1 fips ElemSch0203 MidSch0203 using prices_balance.dta 
replace fips_sch_avg_price = fips_sch_avg_price/1000
generate prior_sales_missing=(fips_sch_avg_price==.)
replace fips_sch_avg_price=0 if prior_sales_missing==1
replace fips_sch_avg_price_chg = fips_sch_avg_price_chg/1000
generate prior_chg_sales_missing=(fips_sch_avg_price_chg==.)
replace fips_sch_avg_price_chg=0 if prior_chg_sales_missing==1
drop _merge
drop if s_lasid==.
save histogram_temp.dta,replace

*******
*Table 2
******

xi: areg Fail AttendNonAssignedSch SF_parcels s_male black hispanic s_read_zd s_math_zd fips_sch_avg_price fips_sch_avg_price_chg ///
missing_math_test missing_read_test prior_sales_missing prior_chg_sales_missing i.s_grade, abs(fips) cluster(fips)
test AttendNonAssignedSch SF_parcels s_male black hispanic s_read_zd s_math_zd fips_sch_avg_price fips_sch_avg_price_chg

xi: areg Fail AttendNonAssignedSch SF_parcels s_male black hispanic s_read_zd s_math_zd fips_sch_avg_price fips_sch_avg_price_chg ///
missing_math_test missing_read_test prior_sales_missing prior_chg_sales_missing AvgElemTestScoresLag AvgMidTestScoresLag AvgHSTestScoresLag i.s_grade , abs(fips) cluster(fips)
test AttendNonAssignedSch SF_parcels s_male black hispanic s_read_zd s_math_zd fips_sch_avg_price fips_sch_avg_price_chg


xi: areg Fail AttendNonAssignedSch SF_parcels s_male black hispanic s_read_zd s_math_zd fips_sch_avg_price fips_sch_avg_price_chg ///
missing_math_test missing_read_test prior_sales_missing prior_chg_sales_missing AvgElemTestScoresLag AvgMidTestScoresLag AvgHSTestScoresLag i.s_grade if CBGP1==1 , abs(fips) cluster(fips)
test AttendNonAssignedSch SF_parcels s_male black hispanic s_read_zd s_math_zd fips_sch_avg_price fips_sch_avg_price_chg


xi: areg Fail AttendNonAssignedSch SF_parcels s_male black hispanic s_read_zd s_math_zd fips_sch_avg_price fips_sch_avg_price_chg ///
missing_math_test missing_read_test prior_sales_missing prior_chg_sales_missing AvgElemTestScoresLag AvgMidTestScoresLag AvgHSTestScoresLag i.s_grade if CBGP2==1 , abs(fips) cluster(fips)
test AttendNonAssignedSch SF_parcels s_male black hispanic s_read_zd s_math_zd  fips_sch_avg_price fips_sch_avg_price_chg


xi: areg Fail AttendNonAssignedSch SF_parcels s_male black hispanic s_read_zd s_math_zd fips_sch_avg_price fips_sch_avg_price_chg ///
missing_math_test missing_read_test prior_sales_missing prior_chg_sales_missing AvgElemTestScoresLag AvgMidTestScoresLag AvgHSTestScoresLag i.s_grade if CBGP3==1 , abs(fips) cluster(fips)
test AttendNonAssignedSch SF_parcels s_male black hispanic s_read_zd s_math_zd fips_sch_avg_price fips_sch_avg_price_chg




 

use summary_students.dta,clear
merge m:1 ElemSch0203 MidSch0203 using first_yr_fail_temp.dta
*missing geo info or no price to classify
drop if CBGPrice==.

egen terciles_fail = group(CBGPrice EverFail)

local covs "CBGPrice EverFail AttendNonAssignedSch AttendMagnetSchl AttendNonAssignedPublicSchl SF_parcels s_male black hispanic s_read_zd s_math_zd missing_math_test missing_read_test AvgElemTestScoresLag AvgMidTestScoresLag AvgHSTestScoresLag s_grade SchYear"
estpost tabstat `covs' , by(terciles_fail) missing   ///
statistics(mean sd count) columns(statistics)

*****
*Table 7A
*****


esttab using SumStats2.csv, replace main(mean) aux(count) nostar unstack obslast ///
mtitles("CBGP1" "CBGP2" "CBGP3" "CBGP4" "All")  ///
addnotes("Note: Mean of each variable with standard deviation in parentheses.") ///
title("Summary Statistics by Terciles of Failing Neighborhoods 2003 Individual Covariates \label{Table2}")






********************************
***MODELS TO MAKE SURE IN CMS 2003 CONSISTENT WITH FIX TO 2003 NEIGH
**********************************


use reg3.dta,clear
keep if SchYear==2003
keep s_lasid ElemSch0203 MidSch0203 hssch0203 taxpid fips
rename ElemSch0203 ElemSch0203_2
rename MidSch0203 MidSch0203_2
rename fips fips_2
save temp_s.dta,replace


use reg3.dta,clear
merge m:1 s_lasid using temp_s.dta

tsset s_lasid SchYear
sort s_lasid SchYear
gen neigh_mover=(ElemSch0203~=ElemSch0203_2 | MidSch0203~=MidSch0203_2 | fips~=fips_2 )
replace neigh_mover=. if SchYear==2003
gen neigh_ever_mover=neigh_mover
forval num =1/9 {

replace neigh_ever_mover=L`num'.neigh_mover if L`num'.neigh_mover==1 

}

foreach var of varlist  CBGP1-CBGP4 {
gen `var'_AnyFailingLag   = `var'*AnyFailingLag 
}


foreach var of varlist   CBGP1-CBGP4 {
gen `var'_neigh_mover = `var'*neigh_mover
gen `var'_neigh_ever_mover = `var'*neigh_ever_mover

}

foreach var of varlist  AnyFailing CBGP1_Fail CBGP2_Fail CBGP3_Fail CBGP4_Fail {
gen `var'_neigh_mover  = `var'*neigh_mover
gen `var'_neigh_ever_mover = `var'*neigh_ever_mover
}
tsset s_lasid SchYear
sort s_lasid SchYear

 
 
keep if SchYear>2003 
drop _merge
merge m:1 ElemSch0203 MidSch0203 using first_yr_fail_temp.dta
gen late_fail = (first_year_fail>2005 )
replace late_fail=. if first_year_fail==. 
drop _merge
gen years_fail = SchYear - first_year_fail
replace years_fail = 0 if years_fail==.

foreach var of varlist AnyFailing CBGP1_Fail CBGP2_Fail CBGP3_Fail {
gen `var'_later = late_fail*`var'
replace `var'_later =0 if `var'_later==.
gen `var'_years	= `var'*years_fail
replace `var'_years = 0 if `var'_years==.
}
encode fips, generate(fips2)



**Table 10, col 3,4

foreach var of varlist PrevYrMoved AttendNonAssignedSch {
xi:reg2hdfe `var'  CBGP1_Fail_later CBGP2_Fail_later CBGP3_Fail_later CBGP1_Fail CBGP2_Fail CBGP3_Fail AvgElemTestScoresLag AvgMidTestScoresLag ///
 AvgHSTestScoresLag test_math_lag test_read_lag missing_math_test missing_read_test i.s_grade s_male i.s_race i.schs ///
, id1(s_lasid) id2(fips_year) cluster(fips2) tol(0.0001)
test CBGP1_Fail=CBGP3_Fail
gen p=r(p)
return clear
test CBGP1_Fail_later=CBGP3_Fail_later
gen p1=r(p)
}

**Table 3A, col 3,4


foreach var of varlist PrevYrMoved AttendNonAssignedSch  {


xi:reg2hdfe `var'  CBGP1_Fail_years CBGP2_Fail_years CBGP3_Fail_years CBGP1_Fail CBGP2_Fail CBGP3_Fail AvgElemTestScoresLag AvgMidTestScoresLag ///
 AvgHSTestScoresLag test_math_lag test_read_lag missing_math_test missing_read_test i.s_grade s_male i.s_race i.schs ///
, id1(s_lasid) id2(fips_year) cluster(fips2) tol(0.0001)
test CBGP1_Fail=CBGP3_Fail
gen p=r(p)
return clear
test CBGP1_Fail_later=CBGP3_Fail_later
gen p1=r(p)

}


 
**CALCULATE % OF SAMPLE THAT IS IN ORIGINAL HOME
xi:areg PrevYrMoved AnyFailing CBGP2_Fail CBGP3_Fail  AvgElemTestScoresLag AvgMidTestScoresLag AvgHSTestScoresLag ///
test_math_lag test_read_lag missing_math_test missing_read_test i.s_grade s_male i.s_race i.schs ///
 , abs(fips_year) cluster(fips)
 
generate in_sample = 1 if e(sample)==1  
count if in_sample==1
count if neigh_ever_mover==0 & in_sample==1


encode fips, generate(fips2)
drop _merge



**
*Table 5 & Table 8, col 4
**


 foreach var of varlist PrevYrMoved AttendNonAssignedSch AttendNonAssignedPublicSchl AttendMagnetSchl   {
 

xi:reg2hdfe `var'  CBGP1_Fail CBGP2_Fail CBGP3_Fail AvgElemTestScoresLag AvgMidTestScoresLag ///
 AvgHSTestScoresLag test_math_lag test_read_lag missing_math_test missing_read_test i.s_grade s_male i.s_race i.schs ///
, id1(s_lasid) id2(fips_year) cluster(fips2) tol(0.0001)
test CBGP1_Fail=CBGP3_Fail
gen p=r(p)

}



**
*Table 8, col 1,2
*


 foreach var of varlist PrevYrMoved    {
 

xi:areg `var'  AnyFailing AvgElemTestScoresLag AvgMidTestScoresLag ///
 AvgHSTestScoresLag test_math_lag test_read_lag missing_math_test missing_read_test i.s_grade s_male i.s_race i.schs ///
, abs(fips_year) cluster(fips2)


xi:areg `var'  CBGP1_Fail CBGP2_Fail CBGP3_Fail AvgElemTestScoresLag AvgMidTestScoresLag ///
 AvgHSTestScoresLag test_math_lag test_read_lag missing_math_test missing_read_test i.s_grade s_male i.s_race i.schs ///
, abs(fips_year) cluster(fips2) 
test CBGP1_Fail=CBGP3_Fail
gen p=r(p)


}

**
*Table 8, col 3
*


 foreach var of varlist PrevYrMoved    {
 

xi:reg2hdfe `var'  AnyFailing AvgElemTestScoresLag AvgMidTestScoresLag ///
 AvgHSTestScoresLag test_math_lag test_read_lag missing_math_test missing_read_test i.s_grade s_male i.s_race i.schs ///
, id1(s_lasid) id2(fips_year) cluster(fips2) tol(0.0001)


}



***
*Table 6
**



 foreach var of varlist  AttendNonAssignedSch AttendNonAssignedPublicSchl  AttendMagnetSchl  {
 

xi:reg2hdfe `var'  CBGP1_Fail CBGP2_Fail CBGP3_Fail AvgElemTestScoresLag AvgMidTestScoresLag ///
AvgHSTestScoresLag test_math_lag test_read_lag missing_math_test missing_read_test i.s_grade s_male i.s_race i.schs ///
if neigh_ever_mover==0, id1(s_lasid) id2(fips_year) cluster(fips2) tol(0.0001)
test CBGP1_Fail=CBGP3_Fail


xi:reg2hdfe `var'  CBGP1_Fail CBGP2_Fail CBGP3_Fail AvgElemTestScoresLag AvgMidTestScoresLag ///
 AvgHSTestScoresLag test_math_lag test_read_lag missing_math_test missing_read_test i.s_grade s_male i.s_race i.schs ///
if neigh_ever_mover==1, id1(s_lasid) id2(fips_year) cluster(fips2) tol(0.0001)
test CBGP1_Fail=CBGP3_Fail

}



*****
* Table 5A, col 3,4
****

 foreach var of varlist s_read_zd s_math_zd {
 
 xi:areg `var'  CBGP1_Fail CBGP2_Fail CBGP3_Fail AvgElemTestScoresLag AvgMidTestScoresLag ///
 AvgHSTestScoresLag test_math_lag test_read_lag missing_math_test missing_read_test i.s_grade s_male i.s_race i.schs ///
, abs(fips_year) cluster(fips2) 
test CBGP1_Fail=CBGP3_Fail
gen p=r(p)


 xi:reg2hdfe `var'  CBGP1_Fail CBGP2_Fail CBGP3_Fail AvgElemTestScoresLag AvgMidTestScoresLag ///
 AvgHSTestScoresLag test_math_lag test_read_lag missing_math_test missing_read_test i.s_grade s_male i.s_race i.schs ///
, id1(s_lasid) id2(fips_year) cluster(fips2) tol(0.0001)
test CBGP1_Fail=CBGP3_Fail
gen p=r(p)

 
 }





tsset s_lasid SchYear
sort s_lasid SchYear
keep s_lasid SchYear neigh_mover neigh_ever_mover
save reg3_move.dta,replace

*****************************
***Fix Neighs to 03 results
**********************************

use reg4.dta,clear
keep if SchYear>2003
tsset s_lasid SchYear
sort s_lasid SchYear
by s_lasid, sort: egen moves = max( PrevYrMoved)

xi:areg AttendNonAssignedSch AnyFailing AvgElemTestScoresLag AvgMidTestScoresLag AvgHSTestScoresLag test_math_lag test_read_lag ///
missing_math_test missing_read_test i.s_grade s_male i.s_race i.schs , abs(fips_year) cluster(fips)
gen in_sample=(e(sample)==1)

xi:areg AttendNonAssignedSch AnyFailing CBGP2_Fail CBGP3_Fail  AvgElemTestScoresLag AvgMidTestScoresLag AvgHSTestScoresLag ///
test_math_lag test_read_lag missing_math_test missing_read_test i.s_grade s_male i.s_race i.schs , abs(fips_year) cluster(fips)
gen in_sample2=(e(sample)==1)
keep s_lasid SchYear in_sample in_sample2
save reg3_temp.dta,replace

use reg4.dta, clear
merge 1:1 s_lasid SchYear using reg3_temp.dta
keep if SchYear>2003
drop _merge
merge 1:1 s_lasid SchYear using reg3_move.dta
drop _merge



***
*Table 4
***

foreach var of varlist AttendNonAssignedSch AttendNonAssignedPublicSchl AttendMagnetSchl   {

xi:areg  `var' CBGP1_Fail CBGP2_Fail CBGP3_Fail AvgElemTestScoresLag AvgMidTestScoresLag AvgHSTestScoresLag ///
test_math_lag test_read_lag missing_math_test missing_read_test i.s_grade s_male i.s_race i.schs ///
 , abs(fips_year) cluster(fips)
 test CBGP1_Fail=CBGP3_Fail
gen p=r(p)


}


foreach var of varlist AttendNonAssignedSch AttendNonAssignedPublicSchl AttendMagnetSchl   {

 xi:reg2hdfe `var'  CBGP1_Fail CBGP2_Fail CBGP3_Fail AvgElemTestScoresLag AvgMidTestScoresLag ///
 AvgHSTestScoresLag test_math_lag test_read_lag missing_math_test missing_read_test i.s_grade s_male i.s_race i.schs ///
, id1(s_lasid) id2(fips_year) cluster(fips2) tol(0.0001)
 test CBGP1_Fail=CBGP3_Fail
gen p=r(p)


}

********
**Table 5A, col 1-2
*********

foreach var of varlist s_read_zd s_math_zd  {

xi:areg  `var' CBGP1_Fail CBGP2_Fail CBGP3_Fail AvgElemTestScoresLag AvgMidTestScoresLag AvgHSTestScoresLag ///
test_math_lag test_read_lag missing_math_test missing_read_test i.s_grade s_male i.s_race i.schs ///
 , abs(fips_year) cluster(fips)
 test CBGP1_Fail=CBGP3_Fail
gen p=r(p)


}

foreach var of varlist s_read_zd s_math_zd  {

 xi:reg2hdfe `var'  CBGP1_Fail CBGP2_Fail CBGP3_Fail AvgElemTestScoresLag AvgMidTestScoresLag ///
 AvgHSTestScoresLag test_math_lag test_read_lag missing_math_test missing_read_test i.s_grade s_male i.s_race i.schs ///
, id1(s_lasid) id2(fips_year) cluster(fips2) tol(0.0001)
 test CBGP1_Fail=CBGP3_Fail
gen p=r(p)


}


erase reg3_temp.dta
erase reg3_move.dta


use reg3.dta,clear
keep if SchYear==2003
keep s_lasid ElemSch0203 MidSch0203 hssch0203 taxpid fips
rename ElemSch0203 ElemSch0203_2
rename MidSch0203 MidSch0203_2
rename fips fips_2
save temp_s.dta,replace


use reg3.dta,clear
merge m:1 s_lasid using temp_s.dta

tsset s_lasid SchYear
sort s_lasid SchYear
gen neigh_mover=(ElemSch0203~=ElemSch0203_2 | MidSch0203~=MidSch0203_2 | fips~=fips_2 )
replace neigh_mover=. if SchYear==2003
gen neigh_ever_mover=neigh_mover
forval num =1/9 {

replace neigh_ever_mover=L`num'.neigh_mover if L`num'.neigh_mover==1 

}



foreach var of varlist  CBG1-CBG4 CBGP1-CBGP4 {
gen `var'_neigh_mover = `var'*neigh_mover
gen `var'_neigh_ever_mover = `var'*neigh_ever_mover


}

foreach var of varlist  AnyFailing CBGP1_Fail CBGP2_Fail CBGP3_Fail CBGP4_Fail {
gen `var'_neigh_mover  = `var'*neigh_mover
gen `var'_neigh_ever_mover = `var'*neigh_ever_mover

}
tsset s_lasid SchYear
sort s_lasid SchYear
by s_lasid, sort: egen moves = max( PrevYrMoved)
drop _merge


 
 encode fips, generate(fips2)
 keep if SchYear>2003



**RESULTS WITH DROPPING THOSE WHO MOVED PRIOR TO FAILING

tsset s_lasid SchYear
sort s_lasid SchYear
forval num=1/8 {
gen F`num'fail = F`num'.AnyFailing
}

egen future_fail = rowmax(F1fail-F8fail)
drop F1fail-F8fail
gen drop_mover_prefail = (future_fail==1 & AnyFailing==0 & neigh_ever_mover==1)
sum drop_mover_prefail

save temp_newschool.dta,replace



use temp_newschool.dta,clear


*****
*Table 4A
****
foreach var of varlist AttendNonAssignedSch AttendNonAssignedPublicSchl AttendMagnetSchl  {


xi:reg2hdfe `var'  CBGP1_Fail CBGP2_Fail CBGP3_Fail AvgElemTestScoresLag AvgMidTestScoresLag AvgHSTestScoresLag i.s_grade  i.schs ///
if neigh_ever_mover==1 & drop_mover_prefail~=1, id1(s_lasid) id2(fips_year) cluster(fips2) tol(0.0001)
 test CBGP1_Fail=CBGP3_Fail
gen p=r(p)

}


******
*Table 7
*****


foreach var of varlist AltNewAttendNonAssignedSch AltNewAttendNonAssPublicSchl AltNewAttendMagnetSchl  {

xi:reg2hdfe `var'  CBGP1_Fail CBGP2_Fail CBGP3_Fail AvgElemTestScoresLag AvgMidTestScoresLag AvgHSTestScoresLag i.s_grade i.schs  ///
if neigh_ever_mover==1, id1(s_lasid) id2(fips_year) cluster(fips2) tol(0.0001)
 test CBGP1_Fail=CBGP3_Fail
gen p=r(p)


}




***************************
**FALSIFICATION
***************************


use reg3.dta,clear
merge m:1 ElemSch0203 MidSch0203 using first_yr_fail_temp.dta
sum EverFail AnyFailing
drop if AnyFailing==1 
sum EverFail AnyFailing
**This removes the cases of students after a school gets out of failing designation
drop if (EverFail==1 & SchYear>=first_year_fail)
sum EverFail AnyFailing
gen yrs_prior_fail = (first_year_fail - SchYear)
replace EverFail=0 if (EverFail==1 & (yrs_prior_fail <2))

sum EverFail AnyFailing

gen fail_false = EverFail
foreach var of varlist  CBGP1-CBGP4  {
gen fail_false_`var' = EverFail*`var'

}
encode fips, generate(fips2)
drop _merge


**********
*Table 1A, col 3-4  - Years Prior to Failing
**********

foreach var of varlist PrevYrMoved AttendNonAssignedSch  {

xi:reg2hdfe  `var' fail_false_CBGP1 fail_false_CBGP2 fail_false_CBGP3 AvgElemTestScoresLag AvgMidTestScoresLag AvgHSTestScoresLag i.s_grade  i.schs ///
if SchYear <= 2011 , id1(s_lasid) id2(fips_year) cluster(fips2) tol(0.0001)
 test CBGP1_Fail=CBGP3_Fail
gen p=r(p)

}




***********************************
*FALSIFICATION TESTs
******************************* 



use reg3.dta,clear
keep if SchYear>2003
encode fips, generate(fips2)
by ElemSch0203 MidSch0203, sort: egen ever_fail = max(AnyFailing)
drop if AnyFailing==1
foreach var of varlist AnyFailing_false AnyFailing_false2 AnyFailing_false3 {
replace  `var'= 0 if CBGP4==1
}


foreach var of varlist  CBGP1-CBGP3  {
gen `var'_Fail_false2 = AnyFailing_false2*`var'
gen `var'_Fail_false3 = AnyFailing_false3*`var'
}

***************
*Table  2A, col 3-4 - Based on AYP failing 
*************** 
foreach var of varlist PrevYrMoved  AttendNonAssignedSch  {
 

xi:reg2hdfe `var'  CBGP1_Fail_false2 CBGP2_Fail_false2 CBGP3_Fail_false2 ///
AvgElemTestScoresLag AvgMidTestScoresLag AvgHSTestScoresLag i.s_grade i.schs , id1(s_lasid) id2(fips_year) cluster(fips2) tol(0.0001)
 test CBGP1_Fail=CBGP3_Fail
gen p=r(p)
outreg2 using Regressions1_18_17, keep(CBGP1_Fail_false2 CBGP2_Fail_false2 CBGP3_Fail_false2 ) addstat(p-value, p) ///
alpha(0.01, 0.05, 0.10) nocons excel dec(3)  nor2 ct(`var' , indiv FE, AYP fail ) append
drop p
}



***************
*Table  9, col 3-4 - Based on Title 1 failing
*************** 


foreach var of varlist PrevYrMoved  AttendNonAssignedSch  {



xi:reg2hdfe `var' CBGP1_Fail_false3 CBGP2_Fail_false3 CBGP3_Fail_false3 ///
AvgElemTestScoresLag AvgMidTestScoresLag AvgHSTestScoresLag i.s_grade i.schs , id1(s_lasid) id2(fips_year) cluster(fips2) tol(0.0001)
 test CBGP1_Fail=CBGP3_Fail
gen p=r(p)
outreg2 using Regressions1_18_17, keep(CBGP1_Fail_false3 CBGP2_Fail_false3 CBGP3_Fail_false3) addstat(p-value, p) ///
alpha(0.01, 0.05, 0.10) nocons excel dec(3)  nor2 ct(`var' , indiv FE, non-Title I fail) append
drop p

}



***************
*- Table  9, col 3-4 - non-assigned school, movt, random boundaries
***************


global dist "3590"
global round "300"
set seed 234411

clear
set obs 1
gen test=1
save reg_false.dta, replace 


use reg3.dta, clear
*format fips %16.0g
rename x_parcel x
rename y_parcel y
drop if x==. | y==. | fips==""
keep PrevYrMoved AttendNonAssignedSch AttendNonAssignedPublicSchl AttendMagnetSchl test_math_lag test_read_lag ///
missing_math_test missing_read_test s_grade s_male s_race x y SchYear
save reg_temp4.dta,replace

use FullParcelLayer.dta, clear
duplicates drop taxpid, force
keep taxpid x y
save geo_info.dta,replace

use ParcelSchFinal1.dta,clear
duplicates drop taxpid, force
merge 1:1 taxpid using geo_info.dta
keep x y ElemSch0203 MidSch0203 hssch0203 fips
egen schs = group(ElemSch0203 MidSch0203 hssch0203)
save parcel_data.dta,replace

erase geo_info.dta

use ParcelSchFinal1.dta,clear
duplicates drop ElemSch0203 MidSch0203 fips SchYear, force
egen AnyFailing = rowtotal(Elemfailing Midfailing)
egen AvgElemTestScoresLag = rowmean(Elelagmath Elelagread)
egen AvgMidTestScoresLag = rowmean(Midlagmath Midlagread)
egen AvgHSTestScoresLag = rowmean(LagHSEngl LagHSAlg)
drop Elemfailing Midfailing Elelagmath Elelagread Midlagmath Midlagread LagHSEngl LagHSAlg
merge m:1 fips using fips_home.dta
drop _merge

foreach var of varlist  CBGP1-CBGP3  {
gen `var'_Fail = AnyFailing*`var'
}
save temp_f1.dta,replace


use reg_temp4.dta,clear
gen test_x = round(x, $round )
gen test_y = round(y, $round )
replace x = test_x
replace y = test_y
drop test_x test_y
keep if SchYear>2003
save false_main.dta,replace

************************************ 
**START LOOP HERE. JUST RANDOM ONES.
************************************


forvalues i = 1/100 {
clear
set obs 1
gen a = 2*runiform() - 1
*gen a = runiform()
save test_r.dta

use parcel_data.dta,clear
cross using test_r.dta
erase test_r.dta
replace x = x + $dist *(1+a) if a>0
replace x = x - ($dist *(1-a)) if a<0
replace y = y + $dist *(1+a) if a>0
replace y = y - ($dist *(1-a)) if a<0
gen test_x = round(x, $round )
gen test_y = round(y, $round )
replace x = test_x
replace y = test_y
drop test_x test_y a
duplicates drop x y, force
save parcel.dta,replace


use false_main.dta, clear
merge m:1 x y using parcel.dta
keep if _merge==3
drop _merge
merge m:1 ElemSch0203 MidSch0203 fips SchYear using temp_f1.dta
drop _merge
egen fips_year = group(fips SchYear)
save false_sch.dta,replace


est clear


foreach var of varlist PrevYrMoved AttendNonAssignedSch  {
 
use false_sch.dta,clear
xi:areg  `var' CBGP1_Fail CBGP2_Fail CBGP3_Fail  AvgElemTestScoresLag AvgMidTestScoresLag AvgHSTestScoresLag ///
test_math_lag test_read_lag missing_math_test missing_read_test i.s_grade s_male i.s_race i.schs ///
 , abs(fips_year) cluster(fips)
regsave,  pval  
gen boot_count = `i'
gen dep_var ="`var'"
append using reg_false.dta
save reg_false.dta, replace 
} 
}




use reg_false.dta, clear
gen CBGP1_Fail = coef if var=="CBGP1_Fail"
gen CBGP2_Fail = coef if var=="CBGP2_Fail"
gen CBGP3_Fail = coef if var=="CBGP3_Fail"

estpost tabstat CBGP1_Fail CBGP2_Fail CBGP3_Fail , by(dep_var) missing   ///
statistics(mean sd) columns(statistics)

esttab using Falsification.csv, append main(mean) aux(sd) nostar unstack obslast





****Stats of Failures
*bring in all Title 1 schools
clear
import excel "RawData\Charlotte Schools AYP ResultsV3.xlsx", sheet("Title I") firstrow
carryforward Schools, replace


collapse (max) Fail_Read- OtherFAIL, by(Schools)


gen fail05 = (Fail_2004==1 & Fail_2005==1)
gen fail06 = (Fail_2005==1 & Fail_2006==1)
gen fail07 = (Fail_2006==1 & Fail_2007==1)
gen fail08 = (Fail_2007==1 & Fail_2008==1)
gen fail09 = (Fail_2008==1 & Fail_2009==1)
gen fail10 = (Fail_2009==1 & Fail_2010==1)
gen fail11 = (Fail_2010==1 & Fail_2011==1)
gen ever_twice_fail=(fail05==1 | fail06==1 | fail07==1 | fail08==1 | fail09==1 | fail10==1 | fail11==1)

gen out_fail05 = (Fail_2004==0 & Fail_2005==0)
gen out_fail06 = (Fail_2005==0 & Fail_2006==0)
gen out_fail07 = (Fail_2006==0 & Fail_2007==0)
gen out_fail08 = (Fail_2007==0 & Fail_2008==0)
gen out_fail09 = (Fail_2008==0 & Fail_2009==0)
gen out_fail10 = (Fail_2009==0 & Fail_2010==0)
gen out_fail11 = (Fail_2010==0 & Fail_2011==0)
order Schools fail05- fail11 out_fail05- out_fail11


*schools not around in 2002-2003
drop if Schools=="(Bishop) Spaugh Middle"
drop if Schools=="Derita Alternative"
drop if Schools=="Morgan School"
drop if Schools=="Whitewater Academy"
drop if Schools=="Whitewater Middle"
drop if Schools=="Walter G. Byers Elementary"
drop if Fail_2011==1 & (Fail_2004==0 & Fail_2005==0 & Fail_2006==0 & Fail_2007==0 & Fail_2008==0 & Fail_2009==0 & Fail_2010==0)
count if ever_twice_fail==1
sum ever_twice_fail
keep if ever_twice_fail==1




!del *temp*.dta
!del *reg*.dta
!del *movt*.dta
!del *fail*.dta
!del *Panel*.dta
!del *Parcel*.dta
!del *student*.dta
!del *Sch*.dta
!del *neigh*.dta
!del *price*.dta
!del *data*.dta
!del *home*.dta

erase t1.dta
erase IndividMortg.dta
erase Main1.dta
erase HMDA.dta
erase CBGData.dta
erase FullParcelLayer.dta
