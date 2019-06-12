********************************************************************************

********************************************************************************
**THIS DO-FILE COMBINES THE PREPARED DATA FROM EACH SURVEY AND CONSTRUCTS THE MASTER DATASET USED IN THE ANALYSES
**Small Firm Death in Developing Countries
**March 12, 2018
**David McKenzie (dmckenzie@worldbank.org) and Anna Luisa Paffhausen (apaffhausen@worldbank.org)
**The analysis was performed with Stata, version 14.2

*Note: Change the directory to the folder “Do-files and readme” on your computer before running this do-file.

********************************************************************************

********************************************************************************
clear all
*TO DO: change directory 
/*EXAMPLE:*/
cd  "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Do-files and readme - Revised version"
/**/
set more off

********************************************************************************
*TTHAI
********************************************************************************
use "Construction of Dataset/Data for combination/TTHAImasterfc.dta"

********************************************************************************
*NGLSMSISA
********************************************************************************
append using "Construction of Dataset/Data for combination/NGLSMSISA_masterfc.dta"

********************************************************************************
*IFLS
********************************************************************************
append using "Construction of Dataset/Data for combination/IFLS_masterfc.dta"

********************************************************************************
*MXFLS
********************************************************************************
append using "Construction of Dataset/Data for combination/MXFLS_masterfc.dta"

********************************************************************************
*UGANDA WINGS PROGRAM
********************************************************************************
append using "Construction of Dataset/Data for combination/UGWINGSfc.dta"

********************************************************************************
*KENYA GET AHEAD PROGRAM
********************************************************************************
append using "Construction of Dataset/Data for combination/KENYAGETAHEAD_masterfc.dta"

********************************************************************************
*EGYPT MACROINSURANCE EXPERIMENT
********************************************************************************
append using "Construction of Dataset/Data for combination/EGYPTMACROINS_masterfc.dta"

********************************************************************************
*SLLSE
********************************************************************************
append using "Construction of Dataset/Data for combination/SLLSE_masterfc.dta"

********************************************************************************
*SLKFEMBUSTRAINING
********************************************************************************
append using "Construction of Dataset/Data for combination/SLKFEMBUSTRAINING_masterfc.dta"

********************************************************************************
*SKLINFORMALITY
********************************************************************************
append using "Construction of Dataset/Data for combination/SKLINFORMALITY_masterfc.dta"

********************************************************************************
*SLMS
********************************************************************************
append using "Construction of Dataset/Data for combination/SLMS_masterfc.dta"

********************************************************************************
*GHANAFLYP
********************************************************************************
append using "Construction of Dataset/Data for combination/GHANAFLYP_masterfc.dta"

********************************************************************************
*BENINFORM
********************************************************************************
append using "Construction of Dataset/Data for combination/BENINFORM_masterfc.dta"

********************************************************************************
*MALAWIFORM
********************************************************************************
append using "Construction of Dataset/Data for combination/MALAWIFORM_masterfc.dta"

********************************************************************************
*TOGOINF
********************************************************************************
append using "Construction of Dataset/Data for combination/TOGOINF_masterfc.dta"

********************************************************************************
*NGYOUWIN
********************************************************************************
append using "Construction of Dataset/Data for combination/NGYOUWIN_masterfc.dta"

********************************************************************************

save "Construction of Dataset/Data for combination/CombinedMaster", replace

*Round firm age for Mexico, Indonesia, and Nigeria
replace agefirm=round(agefirm,0.5) if country=="Mexico" | country=="Indonesia" | (country=="Nigeria" & surveyname=="")

*Replace agefirm=0 if it is negative
replace agefirm=0 if agefirm<0

*Replace ownerage=. if it is out of range
replace ownerage=. if ownerage==999
*I keep the ones under 15 as for now

*Generate a variable indicating female ownership for single-owner businesses
g female_so=female if mfj!=2

*Replace childunder5 and childaged5to12 to dummy variables
foreach var of varlist childunder5 childaged5to12{
replace `var'=(`var'>0) if `var'!=.
}

*Clean employees and totalworkers for Thailand
*(Given that less than 1 percent have 0 for totalworkers, I assume, they counted the owner)
replace totalworkers=totalworkers-1 if totalworkers!=0 & country=="Thailand"

*(Given that there are no zeros for employees, I assume that they reported the number conditional on having any paid employees)
replace employees=0 if employees==. & totalworkers!=. & country=="Thailand"

*Clean the coding of sectors
egen sectortest1=rowtotal(retail manuf services othersector)
egen sectortest2=rowmiss(retail manuf services othersector)

replace othersector=0 if sectortest2==1 & sectortest1==1

foreach var of varlist retail manuf services othersector{
replace `var'=0 if `var'==. &  sectortest2==3 & sectortest1==1
}

drop sectortest*


*Convert all monetary values into real USD
foreach var of varlist pcexpend* laborincome* expenses* sales* profits* capitalstock* inventories* sales_4maa6* sales_6maa10* sales_10maa* expenses_4maa6* expenses_6maa10* expenses_10maa* sales_4maa* sales_2maa4* sales_4maa8* sales_8maa* expenses_4maa* expenses_2maa4* expenses_4maa8* expenses_8maa*{
replace `var'=`var'*excrate
}
save "Construction of Dataset/Data for combination/CombinedMaster", replace

import excel "Construction of Dataset/Data for combination/US_CPIdata.xlsx", sheet("Tabelle1") firstrow clear


reshape long CPI, i(Year) j(month)

g excratemonth=string(month)+"-"+string(Year)
drop month Year

merge 1:m excratemonth using  "Construction of Dataset/Data for combination/CombinedMaster.dta", keep(using match) nogenerate

g baseCPI=CPI if excratemonth=="1-2015"
su baseCPI
replace baseCPI=`r(max)' if baseCPI==.

foreach var of varlist  pcexpend* laborincome* expenses* sales* profits* capitalstock* inventories* sales_4maa6* sales_6maa10* sales_10maa* expenses_4maa6* expenses_6maa10* expenses_10maa* sales_4maa* sales_2maa4* sales_4maa8* sales_8maa* expenses_4maa* expenses_2maa4* expenses_4maa8* expenses_8maa*{
replace `var'=`var'*(baseCPI/CPI)
}

save "Construction of Dataset/Data for combination/CombinedMaster", replace


*Merge data on per capita GDP
import excel "Construction of Dataset/Data for combination/GDPpcdata.xlsx", sheet("Data") firstrow clear
reshape long GDP, i(country) j(surveyyear)

merge 1:m country surveyyear using  "Construction of Dataset/Data for combination/CombinedMaster.dta", keep(using match) nogenerate

save "Construction of Dataset/Data for combination/CombinedMaster", replace

import excel "Construction of Dataset/Data for combination/annualCPI.xlsx", sheet("Tabelle1") firstrow clear

merge 1:m surveyyear using  "Construction of Dataset/Data for combination/CombinedMaster.dta", keep(using match) nogenerate
 
replace GDP=GDP*(baseCPI/annualCPI)

g baseline=(substr(survey,1,2)=="BL" | (country=="Thailand" & lastround!=1) | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012")))

replace GDP=. if baseline!=1

drop baseline

rename GDP pcGDP

save "Construction of Dataset/Data for combination/CombinedMaster", replace

*Merge data on GDP Growth rate
import excel "Construction of Dataset/Data for combination/GrowthRateData.xlsx", sheet("Data") firstrow clear
reshape long Grate, i(country) j(surveyyear)

merge 1:m country surveyyear using "Construction of Dataset/Data for combination/CombinedMaster", keep(using match) nogenerate

g baseline=(substr(survey,1,2)=="BL" | (country=="Thailand" & lastround!=1) | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012")))

replace Grate=. if baseline!=1

drop baseline

save "Construction of Dataset/Data for combination/CombinedMaster", replace

*Replace laborincome to be income from all labor, including the business (except for Kenya GETAHEAD, Sri Lanka, GHANAFLYP, and Egypt, for which this is already the case)
egen laborincomereplace=rowtotal(laborincome profits) if country!="Kenya" & country!="Egypt" & country!="Sri Lanka" & country!="Ghana" & country!="Benin" & country!="Malawi" & country!="Togo" & surveyname!="NGYOUWIN", m
replace laborincome=laborincomereplace if country!="Kenya" & country!="Egypt" & country!="Sri Lanka" & country!="Ghana" & country!="Benin" & country!="Malawi" & country!="Togo" & surveyname!="NGYOUWIN"
drop laborincomereplace

*Generate agegroups for firmage
g stagegroup="under 2 years" if agefirm<2
g agegroup=1 if agefirm<2
replace stagegroup="2 to 5 years" if agefirm<5 & agefirm>=2
replace agegroup=2 if agefirm<5 & agefirm>=2
replace stagegroup="5 to 10 years" if agefirm<10 & agefirm>=5
replace agegroup=3 if agefirm<10 & agefirm>=5
replace stagegroup="10 to 15 years" if agefirm<15 & agefirm>=10
replace agegroup=4 if agefirm<15 & agefirm>=10
replace stagegroup="15 to 20 years" if agefirm>=15 & agefirm<20
replace agegroup=5 if agefirm>=15 & agefirm<20
replace stagegroup="20 to 30 years" if agefirm>=20 & agefirm<30
replace agegroup=6 if agefirm>=20 & agefirm<30
replace stagegroup="30 years and older" if agefirm>=30 & agefirm!=.
replace agegroup=7 if agefirm>=30 & agefirm!=.

label define agegroup       1     "under 2 years" ///
							2     "2 to 4 years" ///
							3     "5 to 9 years" ///
							4  	  "10 to 14 years" ///
							5     "15 to 19 years" ///
							6     "20 to 29 years" ///
							7     "30 years and older"

label values agegroup agegroup

*Generate agegroups for ownerage
g owneragegroup=1 if ownerage>=15 & ownerage<20
replace owneragegroup=2 if ownerage>=20 & ownerage<25
replace owneragegroup=3 if ownerage>=25 & ownerage<30
replace owneragegroup=4 if ownerage>=30 & ownerage<35
replace owneragegroup=5 if ownerage>=35 & ownerage<40
replace owneragegroup=6 if ownerage>=40 & ownerage<45
replace owneragegroup=7 if ownerage>=45 & ownerage<50
replace owneragegroup=8 if ownerage>=50 & ownerage<60
replace owneragegroup=9 if ownerage>=60 & ownerage!=.

*Generate groups for educyears
g educyearsgroup=1 if educyears>=0 & educyears<=13
replace educyearsgroup=2 if educyears>=14 & educyears!=.

label define educyearsgroup     1     "0 to 13 years" ///
								2     "more than 13 years"

label values educyearsgroup educyearsgroup


*Generate a variable indicating whether the firm is in manufacturing, retail, services or any other sector
g sector1234=1 if retail==1
replace sector1234=2 if manuf==1
replace sector1234=3 if services==1
replace sector1234=4 if othersector==1

label define sector 1 retail ///
					2 manufacturing ///
					3 services ///
					4 other
					
label values sector1234 sector		

*Generate profit groups to look at subsistence businesses:
*splitting by US$2 per day or less vs $2-5 vs >$5
*since profits are given for a month, I multiply the values with 3
g subsgroup=1 if profits>0 & profits<30
replace subsgroup=2 if profits>=30 & profits<60
replace subsgroup=3 if profits>=60 & profits<90
replace subsgroup=4 if profits>=90 & profits<120
replace subsgroup=5 if profits>=120 & profits<150
replace subsgroup=6 if profits>=150 & profits<180
replace subsgroup=7 if profits>=180 & profits<210
replace subsgroup=8 if profits>=210 & profits<240
replace subsgroup=9 if profits>=240 & profits<270
replace subsgroup=10 if profits>=270 & profits<300			

label define subsgroup 	1 "less than US$1 per day" ///
						2 "US$1-US$2 per day" ///
						3 "US$2-US$3 per day" ///
						4 "US$3-US$4 per day" ///
						5 "US$4-US$5 per day" ///
						6 "US$5-US$6 per day" ///
						7 "US$6-US$7 per day" ///
						8 "US$7-US$8 per day" ///
						9 "US$8-US$9 per day" ///
						10 "US$9-US$10 per day" 

label values subsgroup subsgroup	

*Generate mfj variable
replace mfj=0 if female==0 & jointbus!=1
replace mfj=1 if female==1 & jointbus!=1
replace mfj=2 if jointbus==1

label define mfj	0 "male" ///
					1 "female" ///
					2 "joint business"

label values mfj mfj
					
save "Construction of Dataset/Data for combination/CombinedMaster", replace


*Round horizons over which we observe survival/death to the nearest integer of 0.25 for 0-2 years:
foreach x1 in  4{
foreach x2 in 	attrit survival newfirmstarted /// 
				reasonforclosure reasonclosure mainactivity wageworker dead retired laborincome /// 
				sales profits hours hoursnormal employees totalworkers /// 
				subjwell pcexpend_  /// 
				{
capture: sum `x2'_`x1'mths 
	if _rc==111 {
	g `x2'_`x1'mths=.
	}
capture: sum `x2'_3mths 
	if _rc==111 {
	g `x2'_3mths=.
	}	
replace `x2'_3mths = `x2'_`x1'mths if `x2'_3mths==.
drop `x2'_`x1'mths 
}
}
foreach x1 in  4{
foreach x2 in 	introduction_10  {
capture: sum `x2'_`x1'mths 
	if _rc==111 {
	g `x2'_`x1'mths=""
	}
capture: sum `x2'_3mths 
	if _rc==111 {
	g `x2'_3mths=""
	}	
replace `x2'_3mths = `x2'_`x1'mths if `x2'_3mths==""
drop `x2'_`x1'mths 
}
}


foreach x1 in  7{
foreach x2 in 	attrit survival newfirmstarted /// 
				reasonforclosure reasonclosure mainactivity wageworker dead retired laborincome /// 
				sales profits hours hoursnormal employees totalworkers /// 
				subjwell pcexpend_  /// 
				{
capture: sum `x2'_`x1'mths 
	if _rc==111 {
	g `x2'_`x1'mths=.
	}
capture: sum `x2'_6mths 
	if _rc==111 {
	g `x2'_6mths=.
	}	
replace `x2'_6mths = `x2'_`x1'mths if `x2'_6mths==.
drop `x2'_`x1'mths 
}
}
foreach x1 in  7{
foreach x2 in 	introduction_10  {
capture: sum `x2'_`x1'mths 
	if _rc==111 {
	g `x2'_`x1'mths=""
	}
capture: sum `x2'_6mths 
	if _rc==111 {
	g `x2'_6mths=""
	}	
replace `x2'_6mths = `x2'_`x1'mths if `x2'_6mths==""
drop `x2'_`x1'mths 
}
}


foreach x1 in  10 {
foreach x2 in 	attrit survival newfirmstarted /// 
				reasonforclosure reasonclosure mainactivity wageworker dead retired laborincome /// 
				sales profits hours hoursnormal employees totalworkers /// 
				subjwell pcexpend_  /// 
				{
capture: sum `x2'_`x1'mths 
	if _rc==111 {
	g `x2'_`x1'mths=.
	}
capture: sum `x2'_9mths 
	if _rc==111 {
	g `x2'_9mths=.
	}	
replace `x2'_9mths = `x2'_`x1'mths if `x2'_9mths==.
drop `x2'_`x1'mths 
}
}
foreach x1 in  10{
foreach x2 in 	introduction_10  {
capture: sum `x2'_`x1'mths 
	if _rc==111 {
	g `x2'_`x1'mths=""
	}
capture: sum `x2'_9mths 
	if _rc==111 {
	g `x2'_9mths=""
	}	
replace `x2'_9mths = `x2'_`x1'mths if `x2'_9mths==""
drop `x2'_`x1'mths 
}
}


foreach x1 in  11mths  1p083yrs {
foreach x2 in 	attrit survival newfirmstarted /// 
				reasonforclosure reasonclosure mainactivity wageworker dead retired laborincome /// 
				sales profits hours hoursnormal employees totalworkers /// 
				subjwell pcexpend_  /// 
				{
capture: sum `x2'_`x1'
	if _rc==111 {
	g `x2'_`x1'=.
	}
capture: sum `x2'_1yr
	if _rc==111 {
	g `x2'_1yr=.
	}	
replace `x2'_1yr = `x2'_`x1' if `x2'_1yr==.
drop `x2'_`x1'
}
}
foreach x1 in 11mths  1p083yrs{
foreach x2 in 	introduction_10  {
capture: sum `x2'_`x1' 
	if _rc==111 {
	g `x2'_`x1'=""
	}
capture: sum `x2'_1yr
	if _rc==111 {
	g `x2'_1yr=""
	}	
replace `x2'_1yr = `x2'_`x1' if `x2'_1yr==""
drop `x2'_`x1' 
}
}


foreach x1 in  1p167yrs  1p33yrs {
foreach x2 in 	attrit survival newfirmstarted /// 
				reasonforclosure reasonclosure mainactivity wageworker dead retired laborincome /// 
				sales profits hours hoursnormal employees totalworkers /// 
				subjwell pcexpend_  /// 
				{
capture: sum `x2'_`x1'
	if _rc==111 {
	g `x2'_`x1'=.
	}
capture: sum `x2'_1p25yrs
	if _rc==111 {
	g `x2'_1p25yrs=.
	}	
replace `x2'_1p25yrs = `x2'_`x1' if `x2'_1p25yrs==.
drop `x2'_`x1'
}
}
foreach x1 in 1p167yrs 1p33yrs{
foreach x2 in 	introduction_10  {
capture: sum `x2'_`x1' 
	if _rc==111 {
	g `x2'_`x1'=""
	}
capture: sum `x2'_1p25yrs
	if _rc==111 {
	g `x2'_1p25yrs=""
	}	
replace `x2'_1p25yrs = `x2'_`x1' if `x2'_1p25yrs==""
drop `x2'_`x1' 
}
}


foreach x1 in  1yr8mths  1p833yrs {
foreach x2 in 	attrit survival newfirmstarted /// 
				reasonforclosure reasonclosure mainactivity wageworker dead retired laborincome /// 
				sales profits hours hoursnormal employees totalworkers /// 
				subjwell pcexpend_  /// 
				{
capture: sum `x2'_`x1'
	if _rc==111 {
	g `x2'_`x1'=.
	}
capture: sum `x2'_1p75yrs
	if _rc==111 {
	g `x2'_1p75yrs=.
	}	
replace `x2'_1p75yrs = `x2'_`x1' if `x2'_1p75yrs==.
drop `x2'_`x1'
}
}
foreach x1 in 1yr8mths  1p833yrs{
foreach x2 in 	introduction_10  {
capture: sum `x2'_`x1' 
	if _rc==111 {
	g `x2'_`x1'=""
	}
capture: sum `x2'_1p75yrs
	if _rc==111 {
	g `x2'_1p75yrs=""
	}	
replace `x2'_1p75yrs = `x2'_`x1' if `x2'_1p75yrs==""
drop `x2'_`x1' 
}
}


foreach x1 in  2p167yrs {
foreach x2 in 	attrit survival newfirmstarted /// 
				reasonforclosure reasonclosure mainactivity wageworker dead retired laborincome /// 
				sales profits hours hoursnormal employees totalworkers /// 
				subjwell pcexpend_  /// 
				{
capture: sum `x2'_`x1'
	if _rc==111 {
	g `x2'_`x1'=.
	}
capture: sum `x2'_2yrs
	if _rc==111 {
	g `x2'_2yrs=.
	}	
replace `x2'_2yrs = `x2'_`x1' if `x2'_2yrs==.
drop `x2'_`x1'
}
}
foreach x1 in 2p167yrs{
foreach x2 in 	introduction_10  {
capture: sum `x2'_`x1' 
	if _rc==111 {
	g `x2'_`x1'=""
	}
capture: sum `x2'_2yrs
	if _rc==111 {
	g `x2'_2yrs=""
	}	
replace `x2'_2yrs = `x2'_`x1' if `x2'_2yrs==""
drop `x2'_`x1' 
}
}

*Round horizons over which we observe survival/death to the nearest integer of 0.5 for 2-6 years:
foreach x1 in  2p25yrs {
foreach x2 in 	attrit survival newfirmstarted /// 
				reasonforclosure reasonclosure mainactivity wageworker dead retired laborincome /// 
				sales profits hours hoursnormal employees totalworkers /// 
				subjwell pcexpend_  /// 
				{
capture: sum `x2'_`x1'
	if _rc==111 {
	g `x2'_`x1'=.
	}
capture: sum `x2'_30mths
	if _rc==111 {
	g `x2'_30mths=.
	}	
replace `x2'_30mths = `x2'_`x1' if `x2'_30mths==.
drop `x2'_`x1'
}
}
foreach x1 in 2p25yrs{
foreach x2 in 	introduction_10  {
capture: sum `x2'_`x1' 
	if _rc==111 {
	g `x2'_`x1'=""
	}
capture: sum `x2'_30mths
	if _rc==111 {
	g `x2'_30mths=""
	}	
replace `x2'_30mths = `x2'_`x1'  if `x2'_30mths==""
drop `x2'_`x1' 
}
}


foreach x1 in  2p833yrs 2p9167yrs {
foreach x2 in 	attrit survival newfirmstarted /// 
				reasonforclosure reasonclosure mainactivity wageworker dead retired laborincome /// 
				sales profits hours hoursnormal employees totalworkers /// 
				subjwell pcexpend_  /// 
				{
capture: sum `x2'_`x1'
	if _rc==111 {
	g `x2'_`x1'=.
	}
capture: sum `x2'_3yrs
	if _rc==111 {
	g `x2'_3yrs=.
	}	
replace `x2'_3yrs = `x2'_`x1' if `x2'_3yrs==.
drop `x2'_`x1'
}
}
foreach x1 in 2p833yrs 2p9167yrs{
foreach x2 in 	introduction_10  {
capture: sum `x2'_`x1' 
	if _rc==111 {
	g `x2'_`x1'=""
	}
capture: sum `x2'_3yrs
	if _rc==111 {
	g `x2'_3yrs=""
	}	
replace `x2'_3yrs = `x2'_`x1' if `x2'_3yrs==""
drop `x2'_`x1' 
}
}


foreach x1 in  3p667yrs {
foreach x2 in 	attrit survival newfirmstarted /// 
				reasonforclosure reasonclosure mainactivity wageworker dead retired laborincome /// 
				sales profits hours hoursnormal employees totalworkers /// 
				subjwell pcexpend_  /// 
				{
capture: sum `x2'_`x1'
	if _rc==111 {
	g `x2'_`x1'=.
	}
capture: sum `x2'_3p5yrs
	if _rc==111 {
	g `x2'_3p5yrs=.
	}	
replace `x2'_3p5yrs = `x2'_`x1' if `x2'_3p5yrs==.
drop `x2'_`x1'
}
}
foreach x1 in 3p667yrs{
foreach x2 in 	introduction_10  {
capture: sum `x2'_`x1' 
	if _rc==111 {
	g `x2'_`x1'=""
	}
capture: sum `x2'_3p5yrs
	if _rc==111 {
	g `x2'_3p5yrs=""
	}	
replace `x2'_3p5yrs = `x2'_`x1' if `x2'_3p5yrs==""
drop `x2'_`x1' 
}
}


foreach x1 in  5p17yrs {
foreach x2 in 	attrit survival newfirmstarted /// 
				reasonforclosure reasonclosure mainactivity wageworker dead retired laborincome /// 
				sales profits hours hoursnormal employees totalworkers /// 
				subjwell pcexpend_  /// 
				{
capture: sum `x2'_`x1'
	if _rc==111 {
	g `x2'_`x1'=.
	}
capture: sum `x2'_5yrs
	if _rc==111 {
	g `x2'_5yrs=.
	}	
replace `x2'_5yrs = `x2'_`x1' if `x2'_5yrs==.
drop `x2'_`x1'
}
}
foreach x1 in 5p17yrs{
foreach x2 in 	introduction_10  {
capture: sum `x2'_`x1' 
	if _rc==111 {
	g `x2'_`x1'=""
	}
capture: sum `x2'_5yrs
	if _rc==111 {
	g `x2'_5yrs=""
	}	
replace `x2'_5yrs = `x2'_`x1' if `x2'_5yrs==""
drop `x2'_`x1' 
}
}


foreach x1 in  5p67yrs {
foreach x2 in 	attrit survival newfirmstarted /// 
				reasonforclosure reasonclosure mainactivity wageworker dead retired laborincome /// 
				sales profits hours hoursnormal employees totalworkers /// 
				subjwell pcexpend_  /// 
				{
capture: sum `x2'_`x1'
	if _rc==111 {
	g `x2'_`x1'=.
	}
capture: sum `x2'_5p5yrs
	if _rc==111 {
	g `x2'_5p5yrs=.
	}	
replace `x2'_5p5yrs = `x2'_`x1' if `x2'_5p5yrs==.
drop `x2'_`x1'
}
}
foreach x1 in 5p67yrs{
foreach x2 in 	introduction_10  {
capture: sum `x2'_`x1' 
	if _rc==111 {
	g `x2'_`x1'=""
	}
capture: sum `x2'_5p5yrs
	if _rc==111 {
	g `x2'_5p5yrs=""
	}	
replace `x2'_5p5yrs = `x2'_`x1' if `x2'_5p5yrs==""
drop `x2'_`x1' 
}
}


foreach x1 in  5p75yrs {
foreach x2 in 	attrit survival newfirmstarted /// 
				reasonforclosure reasonclosure mainactivity wageworker dead retired laborincome /// 
				sales profits hours hoursnormal employees totalworkers /// 
				subjwell pcexpend_  /// 
				{
capture: sum `x2'_`x1'
	if _rc==111 {
	g `x2'_`x1'=.
	}
capture: sum `x2'_6yrs
	if _rc==111 {
	g `x2'_6yrs=.
	}	
replace `x2'_6yrs = `x2'_`x1' if `x2'_6yrs==.
drop `x2'_`x1'
}
}
foreach x1 in 5p75yrs{
foreach x2 in 	introduction_10  {
capture: sum `x2'_`x1' 
	if _rc==111 {
	g `x2'_`x1'=""
	}
capture: sum `x2'_6yrs
	if _rc==111 {
	g `x2'_6yrs=""
	}	
replace `x2'_6yrs = `x2'_`x1' if `x2'_6yrs==""
drop `x2'_`x1' 
}
}


*Round horizons over which we observe survival/death to the nearest integer of 1 for 6 years and more:
foreach x1 in  7p5yrs {
foreach x2 in 	attrit survival newfirmstarted /// 
				reasonforclosure reasonclosure mainactivity wageworker dead retired laborincome /// 
				sales profits hours hoursnormal employees totalworkers /// 
				subjwell pcexpend_  /// 
				{
capture: sum `x2'_`x1'
	if _rc==111 {
	g `x2'_`x1'=.
	}
capture: sum `x2'_8yrs
	if _rc==111 {
	g `x2'_8yrs=.
	}	
replace `x2'_8yrs = `x2'_`x1' if `x2'_8yrs==.
drop `x2'_`x1'
}
}
foreach x1 in 7p5yrs {
foreach x2 in 	introduction_10  {
capture: sum `x2'_`x1' 
	if _rc==111 {
	g `x2'_`x1'=""
	}
capture: sum `x2'_8yrs
	if _rc==111 {
	g `x2'_8yrs=""
	}	
replace `x2'_8yrs = `x2'_`x1' if `x2'_8yrs==""
drop `x2'_`x1' 
}
}


foreach x1 in  10p416yrs {
foreach x2 in 	attrit survival newfirmstarted /// 
				reasonforclosure reasonclosure mainactivity wageworker dead retired laborincome /// 
				sales profits hours hoursnormal employees totalworkers /// 
				subjwell pcexpend_  /// 
				{
capture: sum `x2'_`x1'
	if _rc==111 {
	g `x2'_`x1'=.
	}
capture: sum `x2'_10yrs
	if _rc==111 {
	g `x2'_10yrs=.
	}	
replace `x2'_10yrs = `x2'_`x1' if `x2'_10yrs==.
drop `x2'_`x1'
}
}
foreach x1 in 10p416yrs {
foreach x2 in 	introduction_10  {
capture: sum `x2'_`x1' 
	if _rc==111 {
	g `x2'_`x1'=""
	}
capture: sum `x2'_10yrs
	if _rc==111 {
	g `x2'_10yrs=""
	}	
replace `x2'_10yrs = `x2'_`x1'  if `x2'_10yrs==""
drop `x2'_`x1' 
}
}

foreach x1 in  10p916yrs {
foreach x2 in 	attrit survival newfirmstarted /// 
				reasonforclosure reasonclosure mainactivity wageworker dead retired laborincome /// 
				sales profits hours hoursnormal employees totalworkers /// 
				subjwell pcexpend_  /// 
				{
capture: sum `x2'_`x1'
	if _rc==111 {
	g `x2'_`x1'=.
	}
capture: sum `x2'_11yrs
	if _rc==111 {
	g `x2'_11yrs=.
	}	
replace `x2'_11yrs = `x2'_`x1' if `x2'_11yrs==.
drop `x2'_`x1'
}
}
foreach x1 in 10p916yrs {
foreach x2 in 	introduction_10  {
capture: sum `x2'_`x1' 
	if _rc==111 {
	g `x2'_`x1'=""
	}
capture: sum `x2'_11yrs
	if _rc==111 {
	g `x2'_11yrs=""
	}	
replace `x2'_11yrs = `x2'_`x1' if `x2'_11yrs==""
drop `x2'_`x1' 
}
}


foreach x1 in  14p5yrs {
foreach x2 in 	attrit survival newfirmstarted /// 
				reasonforclosure reasonclosure mainactivity wageworker dead retired laborincome /// 
				sales profits hours hoursnormal employees totalworkers /// 
				subjwell pcexpend_  /// 
				{
capture: sum `x2'_`x1'
	if _rc==111 {
	g `x2'_`x1'=.
	}
capture: sum `x2'_15yrs
	if _rc==111 {
	g `x2'_15yrs=.
	}	
replace `x2'_15yrs = `x2'_`x1' if `x2'_15yrs==.
drop `x2'_`x1'
}
}
foreach x1 in 14p5yrs {
foreach x2 in 	introduction_10  {
capture: sum `x2'_`x1' 
	if _rc==111 {
	g `x2'_`x1'=""
	}
capture: sum `x2'_15yrs
	if _rc==111 {
	g `x2'_15yrs=""
	}	
replace `x2'_15yrs = `x2'_`x1' if `x2'_15yrs==""
drop `x2'_`x1' 
}
}


*Recode survival to capture survival in self-employment:

local p_1 ="3mths"
local p_2 ="6mths"
local p_3 ="9mths"
local p_4="1yr" 
local p_5="1p25yrs" 
local p_6="18mths" 
local p_7="1p75yrs" 
local p_8="2yrs" 
local p_9="30mths" 
local p_10="3yrs" 
local p_11="3p5yrs" 
local p_12="4yrs" 
local p_13="4p5yrs"
local p_14="5yrs" 
local p_15="5p5yrs" 
local p_16="6yrs" 
local p_17="7yrs" 
local p_18="8yrs" 
local p_19="9yrs" 
local p_20="10yrs" 
local p_21="11yrs" 
local p_22="12yrs" 
local p_23="13yrs" 
local p_24="14yrs" 
local p_25="15yrs" 
local p_26="16yrs" 
local p_27="17yrs"


forvalues i=1/27{
g anyfirm_`p_`i''=survival_`p_`i''==1 | newfirmstarted_`p_`i''==1 
replace anyfirm_`p_`i''=. if (survival_`p_`i''==. & newfirmstarted_`p_`i''==.)
}


save CombinedMaster_RH, replace
