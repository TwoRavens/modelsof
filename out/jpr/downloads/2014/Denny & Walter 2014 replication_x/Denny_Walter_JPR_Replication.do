******************************
* "Ethnicity and civil war"
* Elaine K. Denny and Barbara F. Walter
* Replication file for Table I
******************************


*Initial data download
*Original data sets available at the links below 
*Modify the following code to users' relevant directories
*Set dir0 to folder containing downloaded data
global dir0 "C:\Users\ekdenny\Downloads\"
global dir1 "C:\Users\ekdenny\Desktop\JPR data\"


*Download Battle Deaths Data Set Version 3.0 from:  "http://www.prio.no/Data/Armed-Conflict/Battle-Deaths/The-Battle-Deaths-Dataset-version-30/"
*Citation:  Lacina, Bethany & Nils Petter Gleditsch. (2005) Monitoring Trends in Global Combat: A New Dataset of Battle Deaths. European Journal of Population 21 (2–3): 145–166. 


*Download Ethnic Armed Conflict dataset from: "http://thedata.harvard.edu/dvn/dv/epr/faces/study/StudyPage.xhtml;jsessionid=e85b451ee598232052b6f571ba32?globalId=hdl:1902.1/11797&studyListingIndex=0_e85b451ee598232052b6f571ba32"
*Citation:  Cederman, Lars-Erik; Andreas Wimmer & Brian Min. (2010) Why do ethnic groups rebel?: New data and analysis. World Politics 62 (1): 87–119.



****************
****************

clear all

set more 1


set mem 10M
set matsize 500

*First we identify conflicts that classify as "civil war" according to the battle death thresholds outlined in the paper.
*These conflicts will then be merged with EAC data to narrow the universe of cases considered to those which meet our civil war definition.

**Import Battle Death Data
import excel "$dir0\PRIO_bd3.0.xls", sheet("bdonly") firstrow clear


gen gwno = gwnoloc
*one variable for Suez Canal is non-int for n=586
drop if [_n]==586
replace gwno=750 if location=="Hyderabad"


****************************************************************************************************
*Assessing best, high, and low estimates for conflict battle deaths
*We use best estimantes where available; low estimates otherwise.

drop if type<3
gen countTerm = [_n]
sort countTerm year

gen ID = id

gen countvar=[_n]
gen sequence = .
sort ID year
replace sequence = countvar if ID!=ID[_n-1]
replace sequence = countvar if ID==ID[_n-1] & year[_n]-year[_n-1]!=1
replace sequence = sequence[_n-1] if sequence==.
sort sequence


gen YearlyBDBest = bdeadbes
replace  YearlyBDBest = . if bdeadbes <0
gen YearlyBDHighBest =  YearlyBDBest
replace  YearlyBDHighBest =  bdeadhig if  YearlyBDBest==.
gen YearlyBDLowBest =  YearlyBDBest
replace  YearlyBDLowBest =  bdeadlow if  YearlyBDBest==.

sort sequence year
by sequence: egen ConflictBDBestHigh = total(YearlyBDHighBest) 
by sequence: egen ConflictBDBestLow = total( YearlyBDLowBest)
 
gen TotalBDHigh =  ConflictBDBestHigh
gen TotalBDLow =  ConflictBDBestLow

by sequence: egen YearNos = count(countvar)

gen AnnualBDHigh =  TotalBDHigh/ YearNos
gen AnnualBDLow =  TotalBDLow/  YearNos

by sequence: egen MaxYearlyBDHigh = max(bdeadhig)
by sequence: egen MaxYearlyBDLow = max( bdeadlow)

gen startyr = year(startdate2)
gen confstartyr = year(startdate)
gen yearfinalterm2 = year(ependdate)

sort sequence
by sequence: egen yearfinalterm = max(yearfinalterm2)


************************************************
drop if year!=startyr
*We select civil war cases using the best estimate of total battle deaths where available, and the low estimate otherwise:
drop if TotalBDLow<1000

***********************************
*Harmonizing start and end year data (dates and designation of conflict episodes) between Battle Death and EAC data sets:
*Also, note that EAC data run through 2005, while the Battle Death data set runs through 2008.
*Coding will account for this below.
***********************************

replace startyr = 1957 if gwno==40 & startyr == 1956 & id==45
replace  startyr= 1966 if gwno==100 &  startyr== 1964 & id==92
replace yearfinalterm = 2005 if gwno==100 & startyr == 1966
replace startyr = 1981 if gwno==135 & startyr == 1982 & id==95
replace startyr = 1973 if gwno==160 & startyr == 1974 & id==50
replace yearfinalterm = 1998 if gwno==200 & yearfinalterm == 1991 & id==119
replace yearfinalterm = 1995 if gwno==344 & yearfinalterm == 1993  & id==195
replace yearfinalterm = 2005 if gwno==365 & yearfinalterm == .  & id==206
replace startyr = 1994 if startyr==1999 & gwno ==365 & id==206

replace gwno=679 if gwno==678 & yearfinalterm==1994 & id== 207
replace yearfinalterm = 2005 if gwno==700 & yearfinalterm == .
replace yearfinalterm = 2005 if gwno==800 & yearfinalterm == .
replace  yearfinalterm= 2005 if gwno==516 &  yearfinalterm== 1992 & id==90
replace  startyr=1972 if gwno==552 &  startyr== 1973  & id==122
replace yearfinalterm = 2005 if gwno==615 & yearfinalterm == .
replace  startyr=1974 if gwno==771 &  startyr== 1975
replace yearfinalterm = 2005 if gwno==790 & yearfinalterm == 2006

replace  startyr= 2000 if gwno==700 &  startyr== 1978
replace  startyr= 1990 if gwno==770 &  startyr== 1995
replace  startyr= 1983 if gwno==780 &  startyr== 1984  & id==157
replace  startyr= 1979 if gwno==811 &  startyr== 1978 & id==103
replace  startyr= 1959 if gwno==812 &  startyr== 1963   & id==65
replace  startyr= 1993 if gwno==484 &  startyr== 1997   & id==214
replace  startyr= 1984 if gwno==471 &  startyr== 1960  
replace  startyr= 1998 if gwno==490 &  startyr== 1996 & id==86
replace  startyr= 1991 if gwno==540 &  startyr== 1998 

replace  startyr= 1981 if gwno==560 &  startyr== 1985 
replace  startyr= 1975 if gwno==660 &  startyr== 1982  & id==63
replace yearfinalterm = 2002 if gwno==484 & yearfinalterm == 1999  & id==214
replace yearfinalterm = 1984 if gwno==471 & yearfinalterm==1961
replace yearfinalterm = 2004 if gwno==540 & yearfinalterm == 2002
replace yearfinalterm = 2002 if gwno==540 & yearfinalterm == 1995
replace yearfinalterm = 2004 if gwno==625 & yearfinalterm == .

replace yearfinalterm = 2005 if gwno==640 & yearfinalterm == .
replace yearfinalterm = 1990 if gwno==660 & yearfinalterm == 1986   & id==63
replace yearfinalterm = 2005 if gwno==666 & yearfinalterm == 1996   & id==37
replace yearfinalterm = 1998 if gwno==702 & yearfinalterm == 1996
replace yearfinalterm = 1959 if gwno==710 & yearfinalterm == 1950
replace yearfinalterm = 2003 if gwno==780 & yearfinalterm == 2001
replace yearfinalterm = 1969 if gwno==811 & yearfinalterm == 1975

replace yearfinalterm = 1986 if gwno==500 & yearfinalterm == 1992
replace yearfinalterm = 2005 if gwno==500 & yearfinalterm == 2007
replace  startyr= 1981 if gwno==500 &  startyr== 1978
replace  startyr= 1986 if gwno==500 &  startyr== 1994
replace yearfinalterm = 2005 if gwno==516 & yearfinalterm == 2006 & id==90
replace  startyr= 1991 if gwno==516 &  startyr== 1994 & id==90
replace startyr = 1981 if gwno==520 & startyr == 1986
replace yearfinalterm = 1978 if gwno==520 & yearfinalterm == 1984
replace  startyr= 1978 if gwno==520 &  startyr== 1982
replace yearfinalterm = 2002 if gwno==520 & yearfinalterm == .
replace  startyr= 2001 if gwno==520 &  startyr== 2006

replace  startyr= 1975 if gwno==530 &  startyr== 1976 & yearfinalterm==1983
replace  startyr= 1989 if gwno==530 &  startyr== 1987 & yearfinalterm==1992
replace  startyr= 1996 if gwno==530 &  startyr== 1995 & id==211
replace  startyr= 1989 if gwno==530 &  startyr== 1964 & id==78
replace  startyr= 1996 if gwno==530 &  startyr== 1998 & id == 219
replace yearfinalterm = 2005 if gwno==530 & yearfinalterm == . & id==219
replace  startyr= 1996 if gwno==530 &  startyr== 1999 & id == 133
replace yearfinalterm = 1999 if gwno==530 & yearfinalterm == 2002 & id==133
replace yearfinalterm = 2001 if gwno==630 & yearfinalterm == 1982 & id==143
replace yearfinalterm = 1996 if gwno==630 & yearfinalterm == 1988 & id==6
 
replace yearfinalterm = 1996 if gwno==645 & yearfinalterm == 1970 
replace startyr = 1982 if gwno==645 & startyr == 1991 
replace yearfinalterm = 2005 if gwno==645 & yearfinalterm == . 
replace yearfinalterm = 1968 if gwno==750 & yearfinalterm == 1959 & id==139
replace yearfinalterm = 2004 if gwno==750 & yearfinalterm == 1988 & id==139 
replace yearfinalterm = 2005 if gwno==750 & yearfinalterm == 1988 & id==152 
replace yearfinalterm = 2005 if gwno==750 & yearfinalterm == 1994   & id==29
replace yearfinalterm = 2005 if gwno==750 & yearfinalterm == 1997 & id==54

replace yearfinalterm = 2005 if gwno==750 & yearfinalterm == .  & id==169 
replace yearfinalterm = 2005 if gwno==750 & yearfinalterm == . & id==170 
replace  startyr= 1989 if gwno==750 &  startyr== 1993  & id==227
replace  startyr= 1990 if gwno==750 &  startyr== 1994 & id==170
replace yearfinalterm = 1968 if gwno==750 & yearfinalterm == 1959 & id==54
replace  startyr= 1960 if gwno==775 &  startyr== 1959 & id==67
replace yearfinalterm = 2005 if gwno==775 & yearfinalterm == 1970 & id==67
replace yearfinalterm = 1994 if gwno==775 & yearfinalterm == 1992 & id==24
replace yearfinalterm = 2005 if gwno==775 & yearfinalterm == 1992 & id==23
replace  startyr= 1948 if gwno==775 &  startyr== 1949 &id==23
replace yearfinalterm = 1994 if gwno==775 & yearfinalterm == 1988 & id==25
replace  startyr= 1948 if gwno==775 &  startyr== 1949 & id==26
replace yearfinalterm = 1949 if gwno==775 & yearfinalterm == 1950 & id==34

replace yearfinalterm = 2005 if gwno==840 & yearfinalterm == . & id==10
replace startyr = 1999 if gwno==840 & startyr == 1969 & yearfinalterm==2005 & id==10
replace yearfinalterm = 2005 if gwno==840 & yearfinalterm == 1990 & id==112
replace startyr = 1972 if gwno==840 & startyr == 1970 & yearfinalterm==2005 & id==112
replace yearfinalterm = 1998 if gwno==850 & yearfinalterm == 1989  & id==134 
replace yearfinalterm = 1978 if gwno==850 & yearfinalterm == 1965  & id==94
replace yearfinalterm = 2005 if gwno==850 & yearfinalterm == 1991 & id==171
replace  startyr= 1965 if gwno==850 &  startyr== 1976  & id==94

replace  startyr= 1965 if gwno==483 &  startyr== 1966  & id==91
replace  startyr= 1998 if gwno==483 &  startyr== 1997  & id==91
replace  startyr= 1980 if gwno==483 &  startyr== 1976  & id==91
replace  startyr= 1987 if gwno==483 &  startyr== 1989  & id==91
replace yearfinalterm = 1978 if gwno==483 & yearfinalterm == 1972 & id==91
replace yearfinalterm = 1997 if gwno==483 & yearfinalterm == 1994 & id==91


*****

sort gwno startyr yearfinalterm
gen same = .
replace same = 1 if gwno[_n]==gwno[_n-1] & startyr[_n]==startyr[_n-1] & yearfinalterm[_n]==yearfinalterm[_n-1]


save "$dir1\BattleDeaths30modified.dta", replace

clear

***************************************************************************************************************************************************************
*from Ethnic Armed Conflict data set:

import delimited "$dir0\EAC.csv"

gen yearfinalterm = endyr

gen year= startyr
gen gwno = cowcode
drop if gwno==.

drop country
sort gwno year startyr  yearfinalterm
gen same = .
replace same = 1 if gwno[_n]==gwno[_n-1]  & startyr[_n]==startyr[_n-1] & yearfinalterm[_n]==yearfinalterm[_n-1]

merge 1:1 gwno startyr yearfinalterm same using "$dir1\BattleDeaths30modified.dta"
outsheet using "$dir1\EACPRIOmerge1.csv", comma replace


*****
*merged data analysis
drop if _merge!=3
tab ethnowar secession, col
*(Source of Table 1 in paper)

******

*preparing data for generating Figures 1 & 2 in R
gen ethnicconflict = ethnowar
drop if ethnowar==.
replace ethnicconflict=2 if ethnicconflict==0
gen duration = (yearfinalterm-startyr)+1

save "$dir1\DennyWalterJPR.dta", replace

*saved in STATA 13.  
*to save as STATA 12 for R adaptation, need to modify string variables:
*drop variables where str#>244

drop notes

saveold "$dir1\Denny_Walter_JPR_stata12.dta", replace
*This data set can now be uploaded into R using the R code also provided
*to produce Figures 1 & 2
