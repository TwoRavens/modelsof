/* *******************************************************************************************************************
DO FILE FOR "ELECTORAL COMPETITIVENESS, TAX BARGAINING AND POLITICAL INCENTIVES IN DEVELOPING COUNTRIES"

THIS FILE CONTAINS TO CONSTRUCT ALL RELEVANT VARIABLES, AND TO PRODUCE ALL OF THE TABLES REPORTED IN THE MAIN PAPER
AND APPENDIX.  FILE DOES NOT EMPLOY LOOPS, FOR EASE OF REVIEW.

Author: Wilson Prichard
Date: 10/11/2015
********************************************************************************************************************/

cap clear
cap log close
set vir on
set more off
set matsize 800

cap cd /Users/wilsonp/Dropbox/Documents/Academic/IDS/IDS_Tax_RPC/My_Research_Projects/Active_Projects/Electoral_Cycles/Data/

global PathData   "Data"
global PathLog 	"Log_files"
global PathDo 	"Do_files"
global PathDataOrig "Data_orig"
global PathEst "Tables"
global PathGraph "Figures"

log using $PathLog\paper.log, replace

*****************************************************************************
*** prepare the dataset in panel structure (saved as Final)
*****************************************************************************

*** Open the dataset
use $PathDataOrig/Prichard_ElectoralCycles.dta, clear 

*** generate a country identifier as number code (and not string variable)
encode iso, ge(ccode)
move ccode year

*** declare country identifier and time identifier
xtset ccode year
tab year, gen(yr)

*** describe and summarize the dataset (baseline)
describe
summarize

*** describe and summarize the dataset (panel setting)
xtdescribe
xtsum

*** gen log of gdp_ppp
gen lgdp=log(gdp_ppp)

*** generate 
gen totnotax=totrev-tottax

************************************************
*** Prepare Additional Bakground Variables *****
************************************************

*** gen a OPEC dummy (Angola, United Arab Emirates, Algeria, Gabon, Kuwait, Nigeria, Qatar, Venezuela, Iran, Saudi Arabia) - missing Iraq)
gen opec=1 if iso=="AGO" | iso=="ARE" | iso=="DZA"  | iso=="GAB"  | iso=="KWT"  | iso=="NGA"  | iso=="QAT"  | iso=="VEN"  | iso=="IRN"  | iso=="SAU" | iso=="LBY" 
replace opec=0 if opec==.

*** gen a OPEC dummy two (Angola, United Arab Emirates, Algeria, Gabon, Kuwait, Nigeria, Qatar, Venezuela, Iran, Saudi Arabia, Ecuador and Indonesia) - missing Iraq)
*** we include Ecuador and Indonesia, formerly part of the OPEC but now withdrawn
gen opec2=1 if iso=="AGO" | iso=="ARE" | iso=="DZA"  | iso=="GAB"  | iso=="KWT"  | iso=="NGA"  | iso=="QAT"  | iso=="VEN"  | iso=="IRN"  | iso=="SAU" | iso=="LBY" | iso=="ECU"  | iso=="IND" 
replace opec2=0 if opec2==.

***gen oil resource rich if OPEC or nontaxrevenue >15% GDP***
gen resource_rich = 1 if opec2 ==1 | iso == "COG" | iso == "BWA" | iso == "KAZ" | iso== "OMN" | iso == "SDN" | iso == "TTO" | iso == "YEM" | iso == "TMP" | iso == "RUS"
gen nonresource = .
replace nonresource = 1 if resource_rich == . 

***gen region dummies***

gen region1 =0
replace region1 = 1 if region == 1
gen region2 =0
replace region2 = 1 if region == 2
gen region3 =0
replace region3 = 1 if region == 3
gen region4 =0
replace region4 = 1 if region == 4
gen region5 =0
replace region5 = 1 if region == 5
gen region6 =0
replace region6 = 1 if region == 6

/***GENERATE INCOME GROUPS***/

gen incomegroup = .
replace incomegroup = 1 if iso == "AFG" | iso =="BGD" | iso =="BEN" | iso =="BFA" | iso =="BDI" | iso =="KHM" | iso =="CAF" | iso =="TCD" | iso =="COM" | iso =="ZAR" | iso =="ERI" | iso =="ETH" | iso =="GMB" | iso =="GIN" | iso =="GNB" | iso =="HTI" | iso =="KEN" | iso =="KGZ" | iso =="LBR" | iso =="MDG" | iso =="MWI" | iso =="MOZ" | iso =="NPL" | iso =="NER" | iso == "PRK" | iso =="RWA" | iso == "SSD" | iso =="SLE" | iso =="SOM" | iso =="TJK" | iso =="TZA" | iso =="TGO" | iso =="UGA" | iso =="ZWE"
replace incomegroup = 2 if iso == "ARM" | iso == "BTN" | iso == "BOL" | iso == "CMR" | iso == "CPV" | iso == "COG" | iso == "CIV" | iso == "DJI" | iso == "EGY" | iso== "FSM" | iso == "SLV" | iso == "GEO" | iso == "GHA" | iso == "GTM" | iso == "GUY" | iso == "HND" | iso == "IDN" | iso == "IND" | iso == "KIR" | iso == "KSV" | iso == "LAO" | iso == "LSO" | iso == "MRT" | iso == "MDA" | iso == "MNG" | iso == "MOR" | iso == "NIC" | iso == "NGA" | iso == "PAK" | iso == "PNG" | iso == "PRY" | iso == "PHL" | iso == "WSM" | iso == "STP" | iso == "SEN" | iso == "SLB" | iso == "LKA" | iso == "SDN" | iso == "SWZ" | iso == "SYR" | iso == "TMP" | iso == "UKR" | iso == "UZB" | iso == "VUT" | iso == "VNM" | iso == "WBG" | iso == "YEM" | iso == "ZMB"
replace incomegroup = 3 if iso == "AGO" | iso =="ALB" | iso =="DZA" | iso =="ARG" | iso =="AZE" | iso =="BLR" | iso =="BLZ" | iso =="BIH" | iso =="BWA" | iso =="BRA" | iso =="BGR" | iso =="CHN" | iso =="COL" | iso =="CRI" | iso =="CUB" | iso =="DOM" | iso =="ECU" | iso =="FJI" | iso =="GAB" | iso =="GRD" | iso =="HUN" | iso =="IRN"| iso =="IRQ" | iso =="JAM" | iso =="JOR" | iso =="KAZ" | iso =="LBN" | iso =="LBY" | iso =="MKD" | iso =="MYS" | iso =="MDV" | iso =="MHL" | iso =="MUS" | iso =="MEX" | iso =="MNE" | iso =="NAM" | iso =="PLW" | iso =="PAN" | iso =="PER" | iso =="ROM" | iso =="SRB" | iso =="SYC" | iso =="ZFA" | iso =="LCA" | iso =="VCT" | iso =="SUR" | iso =="THA" | iso =="TUN" | iso =="TUR" | iso =="TKM" | iso =="TUV" | iso =="VEN"
replace incomegroup = 4 if iso == "ATG" | iso =="ABW" | iso =="BHS" | iso =="BHR" | iso =="BRB" | iso =="BRN" | iso =="HRV" | iso =="CYP" | iso =="GNQ" | iso =="HKG" | iso =="KWT" | iso =="LVA" | iso =="LTU" | iso =="MAC" | iso =="MLT" | iso =="OMN" | iso =="QAT" | iso =="RUS" | iso =="SMR" | iso =="SAU" | iso =="SGP" | iso =="KNA" | iso =="TTO" | iso =="ARE" | iso =="URY"
replace incomegroup = 5 if iso == "AUS" | iso == "AUT" | iso == "BEL" | iso == "CAN" | iso == "CHL" | iso == "CZE" | iso == "DNK" | iso == "EST" | iso == "FIN" | iso == "FRA" | iso == "DEU" | iso == "GRC" | iso == "ISL" | iso == "IRL" | iso == "ITA" | iso == "ISR" | iso == "JPN" | iso == "KOR" | iso == "LUX" | iso == "NDL" | iso == "NZL" | iso == "NOR" | iso == "POL" | iso == "PRT" | iso == "SVK" | iso == "SVN" | iso == "ESP" | iso == "SWE" | iso == "CHE" | iso == "GBR" | iso == "USA"

gen lowincome = .
replace lowincome = 1 if incomegroup ==1 | incomegroup==2

save $PathData/Prichard_ElectoralCycles_FINAL, replace

**************************************************
*** PREPARE DATASET AND VARIABLES FOR ANALYSIS ***
**************************************************

*** get rid of problematic observations***
drop if prob1==1 | prob2==1 | prob3==1
drop if pop < 1000000
drop if iso == "SYR" & year <1991
drop if iso == "EGY" & year <1988
drop if iso == "ZWE"

*********************************************************************************************
***GENERATE BASELINE ELECTORAL VARIABLES: ALL, CONTESTED, FREE AND FAIR, TRANSITION, FIRST***
*********************************************************************************************

***Generate election variables based on calendar (c) year of the election***

gen election_c = 0
replace election_c = 1 if nelda20 == "yes"  /*Includes only elections that are for the executive, excluding purely legislative elections*/

gen election_c_opp = election_c /*Additionally excludes elections in which there is no opposition*/
replace election_c_opp = 0 if nelda3 == "no" | nelda4 == "no" | nelda5 == "no"

gen election_c_free = election_c_opp /*Additionally excludes elections that are not free and fair*/
replace election_c_free = 0 if nelda14 == "yes" | nelda15 == "yes" | nelda32 == "yes" | nelda34 == "yes" | nelda47 == "yes" | nelda49 == "yes"

gen election_c_transition = 0 /*Includes only elections that result in a change of power to a new political party (not a hand off of power within the same party)*/
replace election_c_transition = 1 if nelda20 == "yes" & nelda24 == "yes"

gen election_c_first = 0 /*Includes only first elections (including first elections after an interruption) which include an opposition)*/
replace election_c_first = 1 if nelda20 == "yes" & nelda2 == "yes" & nelda3 == "yes" & nelda4 == "yes" & nelda5 == "yes"

***Generate variables where "election year" is the effective (e) year, defined as t-1 if election was held in the first X months of the year***

***e1 - Elections in first 1 months of the year are coded as t-1***

gen keep_election_year1 = 1 if mmdd != . & mmdd> 199 & nelda20 == "yes"
gen change_election_year1 = 1 if mmdd != . & mmdd <199 & nelda20 == "yes"
gen effective_election_year1 = change_election_year1[_n+1]

gen e1_nelda2 = nelda2
replace e1_nelda2 = nelda2[_n+1] if effective_election_year1 == 1

gen e1_nelda3 = nelda3
replace e1_nelda3 = nelda3[_n+1] if effective_election_year1 == 1

gen e1_nelda4 = nelda4
replace e1_nelda4 = nelda4[_n+1] if effective_election_year1 == 1

gen e1_nelda5 = nelda5
replace e1_nelda5 = nelda5[_n+1] if effective_election_year1 == 1

gen e1_nelda11 = nelda11
replace e1_nelda11 = nelda11[_n+1] if effective_election_year1 == 1

gen e1_nelda12 = nelda12
replace e1_nelda12 = nelda12[_n+1] if effective_election_year1 == 1

gen e1_nelda14 = nelda14
replace e1_nelda14 = nelda14[_n+1] if effective_election_year1 == 1

gen e1_nelda15 = nelda15
replace e1_nelda15 = nelda15[_n+1] if effective_election_year1 == 1

gen e1_nelda16 = nelda16
replace e1_nelda16 = nelda16[_n+1] if effective_election_year1 == 1

gen e1_nelda20 = nelda20
replace e1_nelda20 = nelda20[_n+1] if effective_election_year1 == 1

gen e1_nelda32 = nelda32
replace e1_nelda32 = nelda32[_n+1] if effective_election_year1 == 1

gen e1_nelda34 = nelda34
replace e1_nelda34 = nelda34[_n+1] if effective_election_year1 == 1

gen e1_nelda47 = nelda47
replace e1_nelda47 = nelda47[_n+1] if effective_election_year1 == 1

gen e1_nelda49 = nelda49
replace e1_nelda49 = nelda49[_n+1] if effective_election_year1 == 1

gen e1_nelda24 = nelda24
replace e1_nelda24 = nelda24[_n+1] if effective_election_year1 == 1

gen election_e1 = 0
replace election_e1 = 1 if keep_election_year1 == 1 
replace election_e1 = 1 if effective_election_year1 == 1
 
gen election_e1_opp = election_e1 /*Additionally excludes elections in which there is no opposition*/
replace election_e1_opp = 0 if e1_nelda3 == "no" | e1_nelda4 == "no" | e1_nelda5 == "no"

gen election_e1_free = election_e1_opp /*Additionally excludes elections that are not free and fair*/
replace election_e1_free = 0 if e1_nelda14 == "yes" | e1_nelda15 == "yes" | e1_nelda32 == "yes" | e1_nelda34 == "yes" | e1_nelda47 == "yes" | e1_nelda49 == "yes"

gen election_e1_transition = election_e1 /*Includes only elections that result in a change of power to a new political party (not a hand off of power within the same party)*/
replace election_e1_transition = 0 if e1_nelda24 == "no"

gen election_e1_first = election_e1 /*Includes only first elections (including first elections after an interruption) which include an opposition)*/
replace election_e1_first = 0 if e1_nelda20 == "no" | e1_nelda2 == "no" | e1_nelda3 == "no" | e1_nelda4 == "no" | e1_nelda5 == "no"

***e2 - Elections in first 2 months of the year are coded as t-1***

gen keep_election_year2 = 1 if mmdd != . & mmdd> 299 & nelda20 == "yes"
gen change_election_year2 = 1 if mmdd != . & mmdd <299 & nelda20 == "yes"
gen effective_election_year2 = change_election_year2[_n+1]

gen e2_nelda2 = nelda2
replace e2_nelda2 = nelda2[_n+1] if effective_election_year2 == 1

gen e2_nelda3 = nelda3
replace e2_nelda3 = nelda3[_n+1] if effective_election_year2 == 1

gen e2_nelda4 = nelda4
replace e2_nelda4 = nelda4[_n+1] if effective_election_year2 == 1

gen e2_nelda5 = nelda5
replace e2_nelda5 = nelda5[_n+1] if effective_election_year2 == 1

gen e2_nelda11 = nelda11
replace e2_nelda11 = nelda11[_n+1] if effective_election_year2 == 1

gen e2_nelda12 = nelda12
replace e2_nelda12 = nelda12[_n+1] if effective_election_year2 == 1

gen e2_nelda14 = nelda14
replace e2_nelda14 = nelda14[_n+1] if effective_election_year2 == 1

gen e2_nelda15 = nelda15
replace e2_nelda15 = nelda15[_n+1] if effective_election_year2 == 1

gen e2_nelda16 = nelda16
replace e2_nelda16 = nelda16[_n+1] if effective_election_year2 == 1

gen e2_nelda20 = nelda20
replace e2_nelda20 = nelda20[_n+1] if effective_election_year2 == 1

gen e2_nelda32 = nelda32
replace e2_nelda32 = nelda32[_n+1] if effective_election_year2 == 1

gen e2_nelda34 = nelda34
replace e2_nelda34 = nelda34[_n+1] if effective_election_year2 == 1

gen e2_nelda47 = nelda47
replace e2_nelda47 = nelda47[_n+1] if effective_election_year2 == 1

gen e2_nelda49 = nelda49
replace e2_nelda49 = nelda49[_n+1] if effective_election_year2 == 1

gen e2_nelda24 = nelda24
replace e2_nelda24 = nelda24[_n+1] if effective_election_year2 == 1

gen election_e2 = 0
replace election_e2 = 1 if keep_election_year2 == 1 
replace election_e2 = 1 if effective_election_year2 == 1
 
gen election_e2_opp = election_e2 /*Additionally excludes elections in which there is no opposition*/
replace election_e2_opp = 0 if e2_nelda3 == "no" | e2_nelda4 == "no" | e2_nelda5 == "no"

gen election_e2_free = election_e2_opp /*Additionally excludes elections that are not free and fair*/
replace election_e2_free = 0 if e2_nelda14 == "yes" | e2_nelda15 == "yes" | e2_nelda32 == "yes" | e2_nelda34 == "yes" | e2_nelda47 == "yes" | e2_nelda49 == "yes"

gen election_e2_transition = election_e2 /*Includes only elections that result in a change of power to a new political party (not a hand off of power within the same party)*/
replace election_e2_transition = 0 if e2_nelda24 == "no"

gen election_e2_first = election_e2 /*Includes only first elections (including first elections after an interruption) which include an opposition)*/
replace election_e2_first = 0 if e2_nelda20 == "no" | e2_nelda2 == "no" | e2_nelda3 == "no" | e2_nelda4 == "no" | e2_nelda5 == "no"

***e3 - Elections in first 3 months of the year are coded as t-1***

gen keep_election_year3 = 1 if mmdd != . & mmdd> 399 & nelda20 == "yes"
gen change_election_year3 = 1 if mmdd != . & mmdd <399 & nelda20 == "yes"
gen effective_election_year3 = change_election_year3[_n+1]

gen e3_nelda2 = nelda2
replace e3_nelda2 = nelda2[_n+1] if effective_election_year3 == 1

gen e3_nelda3 = nelda3
replace e3_nelda3 = nelda3[_n+1] if effective_election_year3 == 1

gen e3_nelda4 = nelda4
replace e3_nelda4 = nelda4[_n+1] if effective_election_year3 == 1

gen e3_nelda5 = nelda5
replace e3_nelda5 = nelda5[_n+1] if effective_election_year3 == 1

gen e3_nelda11 = nelda11
replace e3_nelda11 = nelda11[_n+1] if effective_election_year3 == 1

gen e3_nelda12 = nelda12
replace e3_nelda12 = nelda12[_n+1] if effective_election_year3 == 1

gen e3_nelda14 = nelda14
replace e3_nelda14 = nelda14[_n+1] if effective_election_year3 == 1

gen e3_nelda15 = nelda15
replace e3_nelda15 = nelda15[_n+1] if effective_election_year3 == 1

gen e3_nelda16 = nelda16
replace e3_nelda16 = nelda16[_n+1] if effective_election_year3 == 1

gen e3_nelda20 = nelda20
replace e3_nelda20 = nelda20[_n+1] if effective_election_year3 == 1

gen e3_nelda32 = nelda32
replace e3_nelda32 = nelda32[_n+1] if effective_election_year3 == 1

gen e3_nelda34 = nelda34
replace e3_nelda34 = nelda34[_n+1] if effective_election_year3 == 1

gen e3_nelda47 = nelda47
replace e3_nelda47 = nelda47[_n+1] if effective_election_year3 == 1

gen e3_nelda49 = nelda49
replace e3_nelda49 = nelda49[_n+1] if effective_election_year3 == 1

gen e3_nelda24 = nelda24
replace e3_nelda24 = nelda24[_n+1] if effective_election_year3 == 1

gen election_e3 = 0
replace election_e3 = 1 if keep_election_year3 == 1 
replace election_e3 = 1 if effective_election_year3 == 1
 
gen election_e3_opp = election_e3 /*Additionally excludes elections in which there is no opposition*/
replace election_e3_opp = 0 if e3_nelda3 == "no" | e3_nelda4 == "no" | e3_nelda5 == "no"

gen election_e3_free = election_e3_opp /*Additionally excludes elections that are not free and fair*/
replace election_e3_free = 0 if e3_nelda14 == "yes" | e3_nelda15 == "yes" | e3_nelda32 == "yes" | e3_nelda34 == "yes" | e3_nelda47 == "yes" | e3_nelda49 == "yes"

gen election_e3_transition = election_e3 /*Includes only elections that result in a change of power to a new political party (not a hand off of power within the same party)*/
replace election_e3_transition = 0 if e3_nelda24 == "no"

gen election_e3_first = election_e3 /*Includes only first elections (including first elections after an interruption) which include an opposition)*/
replace election_e3_first = 0 if e3_nelda20 == "no" | e3_nelda2 == "no" | e3_nelda3 == "no" | e3_nelda4 == "no" | e3_nelda5 == "no"

***e4 - Elections in first 4 months of the year are coded as t-1***

gen keep_election_year4 = 1 if mmdd != . & mmdd> 499 & nelda20 == "yes"
gen change_election_year4 = 1 if mmdd != . & mmdd <499 & nelda20 == "yes"
gen effective_election_year4 = change_election_year4[_n+1]

gen e4_nelda2 = nelda2
replace e4_nelda2 = nelda2[_n+1] if effective_election_year4 == 1

gen e4_nelda3 = nelda3
replace e4_nelda3 = nelda3[_n+1] if effective_election_year4 == 1

gen e4_nelda4 = nelda4
replace e4_nelda4 = nelda4[_n+1] if effective_election_year4 == 1

gen e4_nelda5 = nelda5
replace e4_nelda5 = nelda5[_n+1] if effective_election_year4 == 1

gen e4_nelda11 = nelda11
replace e4_nelda11 = nelda11[_n+1] if effective_election_year4 == 1

gen e4_nelda12 = nelda12
replace e4_nelda12 = nelda12[_n+1] if effective_election_year4 == 1

gen e4_nelda14 = nelda14
replace e4_nelda14 = nelda14[_n+1] if effective_election_year4 == 1

gen e4_nelda15 = nelda15
replace e4_nelda15 = nelda15[_n+1] if effective_election_year4 == 1

gen e4_nelda16 = nelda16
replace e4_nelda16 = nelda16[_n+1] if effective_election_year4 == 1

gen e4_nelda20 = nelda20
replace e4_nelda20 = nelda20[_n+1] if effective_election_year4 == 1

gen e4_nelda32 = nelda32
replace e4_nelda32 = nelda32[_n+1] if effective_election_year4 == 1

gen e4_nelda34 = nelda34
replace e4_nelda34 = nelda34[_n+1] if effective_election_year4 == 1

gen e4_nelda47 = nelda47
replace e4_nelda47 = nelda47[_n+1] if effective_election_year4 == 1

gen e4_nelda49 = nelda49
replace e4_nelda49 = nelda49[_n+1] if effective_election_year4 == 1

gen e4_nelda24 = nelda24
replace e4_nelda24 = nelda24[_n+1] if effective_election_year4 == 1

gen election_e4 = 0
replace election_e4 = 1 if keep_election_year4 == 1 
replace election_e4 = 1 if effective_election_year4 == 1
 
gen election_e4_opp = election_e4 /*Additionally excludes elections in which there is no opposition*/
replace election_e4_opp = 0 if e4_nelda3 == "no" | e4_nelda4 == "no" | e4_nelda5 == "no"

gen election_e4_free = election_e4_opp /*Additionally excludes elections that are not free and fair*/
replace election_e4_free = 0 if e4_nelda14 == "yes" | e4_nelda15 == "yes" | e4_nelda32 == "yes" | e4_nelda34 == "yes" | e4_nelda47 == "yes" | e4_nelda49 == "yes"

gen election_e4_transition = election_e4 /*Includes only elections that result in a change of power to a new political party (not a hand off of power within the same party)*/
replace election_e4_transition = 0 if e4_nelda24 == "no"

gen election_e4_first = election_e4 /*Includes only first elections (including first elections after an interruption) which include an opposition)*/
replace election_e4_first = 0 if e4_nelda20 == "no" | e4_nelda2 == "no" | e4_nelda3 == "no" | e4_nelda4 == "no" | e4_nelda5 == "no"

***e5 - elections in first five months of the year are coded as t-1*** 

gen keep_election_year5 = 1 if mmdd != . & mmdd> 599 & nelda20 == "yes"
gen change_election_year5 = 1 if mmdd != . & mmdd <599 & nelda20 == "yes"
gen effective_election_year5 = change_election_year5[_n+1]

gen e5_nelda2 = nelda2
replace e5_nelda2 = nelda2[_n+1] if effective_election_year5 == 1

gen e5_nelda3 = nelda3
replace e5_nelda3 = nelda3[_n+1] if effective_election_year5 == 1

gen e5_nelda4 = nelda4
replace e5_nelda4 = nelda4[_n+1] if effective_election_year5 == 1

gen e5_nelda5 = nelda5
replace e5_nelda5 = nelda5[_n+1] if effective_election_year5 == 1

gen e5_nelda11 = nelda11
replace e5_nelda11 = nelda11[_n+1] if effective_election_year5 == 1

gen e5_nelda12 = nelda12
replace e5_nelda12 = nelda12[_n+1] if effective_election_year5 == 1

gen e5_nelda14 = nelda14
replace e5_nelda14 = nelda14[_n+1] if effective_election_year5 == 1

gen e5_nelda15 = nelda15
replace e5_nelda15 = nelda15[_n+1] if effective_election_year5 == 1

gen e5_nelda16 = nelda16
replace e5_nelda16 = nelda16[_n+1] if effective_election_year5 == 1

gen e5_nelda20 = nelda20
replace e5_nelda20 = nelda20[_n+1] if effective_election_year5 == 1

gen e5_nelda32 = nelda32
replace e5_nelda32 = nelda32[_n+1] if effective_election_year5 == 1

gen e5_nelda34 = nelda34
replace e5_nelda34 = nelda34[_n+1] if effective_election_year5 == 1

gen e5_nelda47 = nelda47
replace e5_nelda47 = nelda47[_n+1] if effective_election_year5 == 1

gen e5_nelda49 = nelda49
replace e5_nelda49 = nelda49[_n+1] if effective_election_year5 == 1

gen e5_nelda24 = nelda24
replace e5_nelda24 = nelda24[_n+1] if effective_election_year5 == 1

gen election_e5 = 0
replace election_e5 = 1 if keep_election_year5 == 1 
replace election_e5 = 1 if effective_election_year5 == 1
 
gen election_e5_opp = election_e5 /*Additionally excludes elections in which there is no opposition*/
replace election_e5_opp = 0 if e5_nelda3 == "no" | e5_nelda4 == "no" | e5_nelda5 == "no"

gen election_e5_free = election_e5_opp /*Additionally excludes elections that are not free and fair*/
replace election_e5_free = 0 if e5_nelda14 == "yes" | e5_nelda15 == "yes" | e5_nelda32 == "yes" | e5_nelda34 == "yes" | e5_nelda47 == "yes" | e5_nelda49 == "yes"

gen election_e5_transition = election_e5 /*Includes only elections that result in a change of power to a new political party (not a hand off of power within the same party)*/
replace election_e5_transition = 0 if e5_nelda24 == "no"

gen election_e5_first = election_e5 /*Includes only first elections (including first elections after an interruption) which include an opposition)*/
replace election_e5_first = 0 if e5_nelda20 == "no" | e5_nelda2 == "no" | e5_nelda3 == "no" | e5_nelda4 == "no" | e5_nelda5 == "no"

***e6 - Elections in first 6 months of the year are coded as t-1***

gen keep_election_year6 = 1 if mmdd != . & mmdd> 699 & nelda20 == "yes"
gen change_election_year6 = 1 if mmdd != . & mmdd <699 & nelda20 == "yes"
gen effective_election_year6 = change_election_year6[_n+1]

gen e6_nelda2 = nelda2
replace e6_nelda2 = nelda2[_n+1] if effective_election_year6 == 1

gen e6_nelda3 = nelda3
replace e6_nelda3 = nelda3[_n+1] if effective_election_year6 == 1

gen e6_nelda4 = nelda4
replace e6_nelda4 = nelda4[_n+1] if effective_election_year6 == 1

gen e6_nelda5 = nelda5
replace e6_nelda5 = nelda5[_n+1] if effective_election_year6 == 1

gen e6_nelda11 = nelda11
replace e6_nelda11 = nelda11[_n+1] if effective_election_year6 == 1

gen e6_nelda12 = nelda12
replace e6_nelda12 = nelda12[_n+1] if effective_election_year6 == 1

gen e6_nelda14 = nelda14
replace e6_nelda14 = nelda14[_n+1] if effective_election_year6 == 1

gen e6_nelda15 = nelda15
replace e6_nelda15 = nelda15[_n+1] if effective_election_year6 == 1

gen e6_nelda16 = nelda16
replace e6_nelda16 = nelda16[_n+1] if effective_election_year6 == 1

gen e6_nelda20 = nelda20
replace e6_nelda20 = nelda20[_n+1] if effective_election_year6 == 1

gen e6_nelda32 = nelda32
replace e6_nelda32 = nelda32[_n+1] if effective_election_year6 == 1

gen e6_nelda34 = nelda34
replace e6_nelda34 = nelda34[_n+1] if effective_election_year6 == 1

gen e6_nelda47 = nelda47
replace e6_nelda47 = nelda47[_n+1] if effective_election_year6 == 1

gen e6_nelda49 = nelda49
replace e6_nelda49 = nelda49[_n+1] if effective_election_year6 == 1

gen e6_nelda24 = nelda24
replace e6_nelda24 = nelda24[_n+1] if effective_election_year6 == 1

gen election_e6 = 0
replace election_e6 = 1 if keep_election_year6 == 1 
replace election_e6 = 1 if effective_election_year6 == 1
 
gen election_e6_opp = election_e6 /*Additionally excludes elections in which there is no opposition*/
replace election_e6_opp = 0 if e6_nelda3 == "no" | e6_nelda4 == "no" | e6_nelda5 == "no"

gen election_e6_free = election_e6_opp /*Additionally excludes elections that are not free and fair*/
replace election_e6_free = 0 if e6_nelda14 == "yes" | e6_nelda15 == "yes" | e6_nelda32 == "yes" | e6_nelda34 == "yes" | e6_nelda47 == "yes" | e6_nelda49 == "yes"

gen election_e6_transition = election_e6 /*Includes only elections that result in a change of power to a new political party (not a hand off of power within the same party)*/
replace election_e6_transition = 0 if e6_nelda24 == "no"

gen election_e6_first = election_e6 /*Includes only first elections (including first elections after an interruption) which include an opposition)*/
replace election_e6_first = 0 if e6_nelda20 == "no" | e6_nelda2 == "no" | e6_nelda3 == "no" | e6_nelda4 == "no" | e6_nelda5 == "no"

***e7 - Elections in first 7 months of the year are coded as t-1***

gen keep_election_year7 = 1 if mmdd != . & mmdd> 799 & nelda20 == "yes"
gen change_election_year7 = 1 if mmdd != . & mmdd <799 & nelda20 == "yes"
gen effective_election_year7 = change_election_year7[_n+1]

gen e7_nelda2 = nelda2
replace e7_nelda2 = nelda2[_n+1] if effective_election_year7 == 1

gen e7_nelda3 = nelda3
replace e7_nelda3 = nelda3[_n+1] if effective_election_year7 == 1

gen e7_nelda4 = nelda4
replace e7_nelda4 = nelda4[_n+1] if effective_election_year7 == 1

gen e7_nelda5 = nelda5
replace e7_nelda5 = nelda5[_n+1] if effective_election_year7 == 1

gen e7_nelda11 = nelda11
replace e7_nelda11 = nelda11[_n+1] if effective_election_year7 == 1

gen e7_nelda12 = nelda12
replace e7_nelda12 = nelda12[_n+1] if effective_election_year7 == 1

gen e7_nelda14 = nelda14
replace e7_nelda14 = nelda14[_n+1] if effective_election_year7 == 1

gen e7_nelda15 = nelda15
replace e7_nelda15 = nelda15[_n+1] if effective_election_year7 == 1

gen e7_nelda16 = nelda16
replace e7_nelda16 = nelda16[_n+1] if effective_election_year7 == 1

gen e7_nelda20 = nelda20
replace e7_nelda20 = nelda20[_n+1] if effective_election_year7 == 1

gen e7_nelda32 = nelda32
replace e7_nelda32 = nelda32[_n+1] if effective_election_year7 == 1

gen e7_nelda34 = nelda34
replace e7_nelda34 = nelda34[_n+1] if effective_election_year7 == 1

gen e7_nelda47 = nelda47
replace e7_nelda47 = nelda47[_n+1] if effective_election_year7 == 1

gen e7_nelda49 = nelda49
replace e7_nelda49 = nelda49[_n+1] if effective_election_year7 == 1

gen e7_nelda24 = nelda24
replace e7_nelda24 = nelda24[_n+1] if effective_election_year7 == 1

gen election_e7 = 0
replace election_e7 = 1 if keep_election_year7 == 1 
replace election_e7 = 1 if effective_election_year7 == 1
 
gen election_e7_opp = election_e7 /*Additionally excludes elections in which there is no opposition*/
replace election_e7_opp = 0 if e7_nelda3 == "no" | e7_nelda4 == "no" | e7_nelda5 == "no"

gen election_e7_free = election_e7_opp /*Additionally excludes elections that are not free and fair*/
replace election_e7_free = 0 if e7_nelda14 == "yes" | e7_nelda15 == "yes" | e7_nelda32 == "yes" | e7_nelda34 == "yes" | e7_nelda47 == "yes" | e7_nelda49 == "yes"

gen election_e7_transition = election_e7 /*Includes only elections that result in a change of power to a new political party (not a hand off of power within the same party)*/
replace election_e7_transition = 0 if e7_nelda24 == "no"

gen election_e7_first = election_e7 /*Includes only first elections (including first elections after an interruption) which include an opposition)*/
replace election_e7_first = 0 if e7_nelda20 == "no" | e7_nelda2 == "no" | e7_nelda3 == "no" | e7_nelda4 == "no" | e7_nelda5 == "no"

***e8 - Elections in first 8 months of the year are coded as t-1***

gen keep_election_year8 = 1 if mmdd != . & mmdd> 899 & nelda20 == "yes"
gen change_election_year8 = 1 if mmdd != . & mmdd <899 & nelda20 == "yes"
gen effective_election_year8 = change_election_year8[_n+1]

gen e8_nelda2 = nelda2
replace e8_nelda2 = nelda2[_n+1] if effective_election_year8 == 1

gen e8_nelda3 = nelda3
replace e8_nelda3 = nelda3[_n+1] if effective_election_year8 == 1

gen e8_nelda4 = nelda4
replace e8_nelda4 = nelda4[_n+1] if effective_election_year8 == 1

gen e8_nelda5 = nelda5
replace e8_nelda5 = nelda5[_n+1] if effective_election_year8 == 1

gen e8_nelda11 = nelda11
replace e8_nelda11 = nelda11[_n+1] if effective_election_year8 == 1

gen e8_nelda12 = nelda12
replace e8_nelda12 = nelda12[_n+1] if effective_election_year8 == 1

gen e8_nelda14 = nelda14
replace e8_nelda14 = nelda14[_n+1] if effective_election_year8 == 1

gen e8_nelda15 = nelda15
replace e8_nelda15 = nelda15[_n+1] if effective_election_year8 == 1

gen e8_nelda16 = nelda16
replace e8_nelda16 = nelda16[_n+1] if effective_election_year8 == 1

gen e8_nelda20 = nelda20
replace e8_nelda20 = nelda20[_n+1] if effective_election_year8 == 1

gen e8_nelda32 = nelda32
replace e8_nelda32 = nelda32[_n+1] if effective_election_year8 == 1

gen e8_nelda34 = nelda34
replace e8_nelda34 = nelda34[_n+1] if effective_election_year8 == 1

gen e8_nelda47 = nelda47
replace e8_nelda47 = nelda47[_n+1] if effective_election_year8 == 1

gen e8_nelda49 = nelda49
replace e8_nelda49 = nelda49[_n+1] if effective_election_year8 == 1

gen e8_nelda24 = nelda24
replace e8_nelda24 = nelda24[_n+1] if effective_election_year8 == 1

gen election_e8 = 0
replace election_e8 = 1 if keep_election_year8 == 1 
replace election_e8 = 1 if effective_election_year8 == 1
 
gen election_e8_opp = election_e8 /*Additionally excludes elections in which there is no opposition*/
replace election_e8_opp = 0 if e8_nelda3 == "no" | e8_nelda4 == "no" | e8_nelda5 == "no"

gen election_e8_free = election_e8_opp /*Additionally excludes elections that are not free and fair*/
replace election_e8_free = 0 if e8_nelda14 == "yes" | e8_nelda15 == "yes" | e8_nelda32 == "yes" | e8_nelda34 == "yes" | e8_nelda47 == "yes" | e8_nelda49 == "yes"

gen election_e8_transition = election_e8 /*Includes only elections that result in a change of power to a new political party (not a hand off of power within the same party)*/
replace election_e8_transition = 0 if e8_nelda24 == "no"

gen election_e8_first = election_e8 /*Includes only first elections (including first elections after an interruption) which include an opposition)*/
replace election_e8_first = 0 if e8_nelda20 == "no" | e8_nelda2 == "no" | e8_nelda3 == "no" | e8_nelda4 == "no" | e8_nelda5 == "no"

***e9 - Elections in first 9 months of the year are coded as t-1***

gen keep_election_year9 = 1 if mmdd != . & mmdd> 999 & nelda20 == "yes"
gen change_election_year9 = 1 if mmdd != . & mmdd <999 & nelda20 == "yes"
gen effective_election_year9 = change_election_year9[_n+1]

gen e9_nelda2 = nelda2
replace e9_nelda2 = nelda2[_n+1] if effective_election_year9 == 1

gen e9_nelda3 = nelda3
replace e9_nelda3 = nelda3[_n+1] if effective_election_year9 == 1

gen e9_nelda4 = nelda4
replace e9_nelda4 = nelda4[_n+1] if effective_election_year9 == 1

gen e9_nelda5 = nelda5
replace e9_nelda5 = nelda5[_n+1] if effective_election_year9 == 1

gen e9_nelda11 = nelda11
replace e9_nelda11 = nelda11[_n+1] if effective_election_year9 == 1

gen e9_nelda12 = nelda12
replace e9_nelda12 = nelda12[_n+1] if effective_election_year9 == 1

gen e9_nelda14 = nelda14
replace e9_nelda14 = nelda14[_n+1] if effective_election_year9 == 1

gen e9_nelda15 = nelda15
replace e9_nelda15 = nelda15[_n+1] if effective_election_year9 == 1

gen e9_nelda16 = nelda16
replace e9_nelda16 = nelda16[_n+1] if effective_election_year9 == 1

gen e9_nelda20 = nelda20
replace e9_nelda20 = nelda20[_n+1] if effective_election_year9 == 1

gen e9_nelda32 = nelda32
replace e9_nelda32 = nelda32[_n+1] if effective_election_year9 == 1

gen e9_nelda34 = nelda34
replace e9_nelda34 = nelda34[_n+1] if effective_election_year9 == 1

gen e9_nelda47 = nelda47
replace e9_nelda47 = nelda47[_n+1] if effective_election_year9 == 1

gen e9_nelda49 = nelda49
replace e9_nelda49 = nelda49[_n+1] if effective_election_year9 == 1

gen e9_nelda24 = nelda24
replace e9_nelda24 = nelda24[_n+1] if effective_election_year9 == 1

gen election_e9 = 0
replace election_e9 = 1 if keep_election_year9 == 1 
replace election_e9 = 1 if effective_election_year9 == 1
 
gen election_e9_opp = election_e9 /*Additionally excludes elections in which there is no opposition*/
replace election_e9_opp = 0 if e9_nelda3 == "no" | e9_nelda4 == "no" | e9_nelda5 == "no"

gen election_e9_free = election_e9_opp /*Additionally excludes elections that are not free and fair*/
replace election_e9_free = 0 if e9_nelda14 == "yes" | e9_nelda15 == "yes" | e9_nelda32 == "yes" | e9_nelda34 == "yes" | e9_nelda47 == "yes" | e9_nelda49 == "yes"

gen election_e9_transition = election_e9 /*Includes only elections that result in a change of power to a new political party (not a hand off of power within the same party)*/
replace election_e9_transition = 0 if e9_nelda24 == "no"

gen election_e9_first = election_e9 /*Includes only first elections (including first elections after an interruption) which include an opposition)*/
replace election_e9_first = 0 if e9_nelda20 == "no" | e9_nelda2 == "no" | e9_nelda3 == "no" | e9_nelda4 == "no" | e9_nelda5 == "no"

***e10 - Elections in first 10 months of the year are coded as t-1***

gen keep_election_year10 = 1 if mmdd != . & mmdd> 1099 & nelda20 == "yes"
gen change_election_year10 = 1 if mmdd != . & mmdd <1099 & nelda20 == "yes"
gen effective_election_year10 = change_election_year10[_n+1]

gen e10_nelda2 = nelda2
replace e10_nelda2 = nelda2[_n+1] if effective_election_year10 == 1

gen e10_nelda3 = nelda3
replace e10_nelda3 = nelda3[_n+1] if effective_election_year10 == 1

gen e10_nelda4 = nelda4
replace e10_nelda4 = nelda4[_n+1] if effective_election_year10 == 1

gen e10_nelda5 = nelda5
replace e10_nelda5 = nelda5[_n+1] if effective_election_year10 == 1

gen e10_nelda11 = nelda11
replace e10_nelda11 = nelda11[_n+1] if effective_election_year10 == 1

gen e10_nelda12 = nelda12
replace e10_nelda12 = nelda12[_n+1] if effective_election_year10 == 1

gen e10_nelda14 = nelda14
replace e10_nelda14 = nelda14[_n+1] if effective_election_year10 == 1

gen e10_nelda15 = nelda15
replace e10_nelda15 = nelda15[_n+1] if effective_election_year10 == 1

gen e10_nelda16 = nelda16
replace e10_nelda16 = nelda16[_n+1] if effective_election_year10 == 1

gen e10_nelda20 = nelda20
replace e10_nelda20 = nelda20[_n+1] if effective_election_year10 == 1

gen e10_nelda32 = nelda32
replace e10_nelda32 = nelda32[_n+1] if effective_election_year10 == 1

gen e10_nelda34 = nelda34
replace e10_nelda34 = nelda34[_n+1] if effective_election_year10 == 1

gen e10_nelda47 = nelda47
replace e10_nelda47 = nelda47[_n+1] if effective_election_year10 == 1

gen e10_nelda49 = nelda49
replace e10_nelda49 = nelda49[_n+1] if effective_election_year10 == 1

gen e10_nelda24 = nelda24
replace e10_nelda24 = nelda24[_n+1] if effective_election_year10 == 1

gen election_e10 = 0
replace election_e10 = 1 if keep_election_year10 == 1 
replace election_e10 = 1 if effective_election_year10 == 1
 
gen election_e10_opp = election_e10 /*Additionally excludes elections in which there is no opposition*/
replace election_e10_opp = 0 if e10_nelda3 == "no" | e10_nelda4 == "no" | e10_nelda5 == "no"

gen election_e10_free = election_e10_opp /*Additionally excludes elections that are not free and fair*/
replace election_e10_free = 0 if e10_nelda14 == "yes" | e10_nelda15 == "yes" | e10_nelda32 == "yes" | e10_nelda34 == "yes" | e10_nelda47 == "yes" | e10_nelda49 == "yes"

gen election_e10_transition = election_e10 /*Includes only elections that result in a change of power to a new political party (not a hand off of power within the same party)*/
replace election_e10_transition = 0 if e10_nelda24 == "no"

gen election_e10_first = election_e10 /*Includes only first elections (including first elections after an interruption) which include an opposition)*/
replace election_e10_first = 0 if e10_nelda20 == "no" | e10_nelda2 == "no" | e10_nelda3 == "no" | e10_nelda4 == "no" | e10_nelda5 == "no"

***e11 - Elections in first 11 months of the year are coded as t-1***

gen keep_election_year11 = 1 if mmdd != . & mmdd> 1199 & nelda20 == "yes"
gen change_election_year11 = 1 if mmdd != . & mmdd <1199 & nelda20 == "yes"
gen effective_election_year11 = change_election_year11[_n+1]

gen e11_nelda2 = nelda2
replace e11_nelda2 = nelda2[_n+1] if effective_election_year11 == 1

gen e11_nelda3 = nelda3
replace e11_nelda3 = nelda3[_n+1] if effective_election_year11 == 1

gen e11_nelda4 = nelda4
replace e11_nelda4 = nelda4[_n+1] if effective_election_year11 == 1

gen e11_nelda5 = nelda5
replace e11_nelda5 = nelda5[_n+1] if effective_election_year11 == 1

gen e11_nelda11 = nelda11
replace e11_nelda11 = nelda11[_n+1] if effective_election_year11 == 1

gen e11_nelda12 = nelda12
replace e11_nelda12 = nelda12[_n+1] if effective_election_year11 == 1

gen e11_nelda14 = nelda14
replace e11_nelda14 = nelda14[_n+1] if effective_election_year11 == 1

gen e11_nelda15 = nelda15
replace e11_nelda15 = nelda15[_n+1] if effective_election_year11 == 1

gen e11_nelda16 = nelda16
replace e11_nelda16 = nelda16[_n+1] if effective_election_year11 == 1

gen e11_nelda20 = nelda20
replace e11_nelda20 = nelda20[_n+1] if effective_election_year11 == 1

gen e11_nelda32 = nelda32
replace e11_nelda32 = nelda32[_n+1] if effective_election_year11 == 1

gen e11_nelda34 = nelda34
replace e11_nelda34 = nelda34[_n+1] if effective_election_year11 == 1

gen e11_nelda47 = nelda47
replace e11_nelda47 = nelda47[_n+1] if effective_election_year11 == 1

gen e11_nelda49 = nelda49
replace e11_nelda49 = nelda49[_n+1] if effective_election_year11 == 1

gen e11_nelda24 = nelda24
replace e11_nelda24 = nelda24[_n+1] if effective_election_year11 == 1

gen election_e11 = 0
replace election_e11 = 1 if keep_election_year11 == 1 
replace election_e11 = 1 if effective_election_year11 == 1
 
gen election_e11_opp = election_e11 /*Additionally excludes elections in which there is no opposition*/
replace election_e11_opp = 0 if e11_nelda3 == "no" | e11_nelda4 == "no" | e11_nelda5 == "no"

gen election_e11_free = election_e11_opp /*Additionally excludes elections that are not free and fair*/
replace election_e11_free = 0 if e11_nelda14 == "yes" | e11_nelda15 == "yes" | e11_nelda32 == "yes" | e11_nelda34 == "yes" | e11_nelda47 == "yes" | e11_nelda49 == "yes"

gen election_e11_transition = election_e11 /*Includes only elections that result in a change of power to a new political party (not a hand off of power within the same party)*/
replace election_e11_transition = 0 if e11_nelda24 == "no"

gen election_e11_first = election_e11 /*Includes only first elections (including first elections after an interruption) which include an opposition)*/
replace election_e11_first = 0 if e11_nelda20 == "no" | e11_nelda2 == "no" | e11_nelda3 == "no" | e11_nelda4 == "no" | e11_nelda5 == "no"

***e12 - Elections in first 12 months of the year are coded as t-1***

gen keep_election_year12 = 1 if mmdd != . & mmdd> 1299 & nelda20 == "yes"
gen change_election_year12 = 1 if mmdd != . & mmdd <1299 & nelda20 == "yes"
gen effective_election_year12 = change_election_year12[_n+1]

gen e12_nelda2 = nelda2
replace e12_nelda2 = nelda2[_n+1] if effective_election_year12 == 1

gen e12_nelda3 = nelda3
replace e12_nelda3 = nelda3[_n+1] if effective_election_year12 == 1

gen e12_nelda4 = nelda4
replace e12_nelda4 = nelda4[_n+1] if effective_election_year12 == 1

gen e12_nelda5 = nelda5
replace e12_nelda5 = nelda5[_n+1] if effective_election_year12 == 1

gen e12_nelda11 = nelda11
replace e12_nelda11 = nelda11[_n+1] if effective_election_year12 == 1

gen e12_nelda12 = nelda12
replace e12_nelda12 = nelda12[_n+1] if effective_election_year12 == 1

gen e12_nelda14 = nelda14
replace e12_nelda14 = nelda14[_n+1] if effective_election_year12 == 1

gen e12_nelda15 = nelda15
replace e12_nelda15 = nelda15[_n+1] if effective_election_year12 == 1

gen e12_nelda16 = nelda16
replace e12_nelda16 = nelda16[_n+1] if effective_election_year12 == 1

gen e12_nelda20 = nelda20
replace e12_nelda20 = nelda20[_n+1] if effective_election_year12 == 1

gen e12_nelda32 = nelda32
replace e12_nelda32 = nelda32[_n+1] if effective_election_year12 == 1

gen e12_nelda34 = nelda34
replace e12_nelda34 = nelda34[_n+1] if effective_election_year12 == 1

gen e12_nelda47 = nelda47
replace e12_nelda47 = nelda47[_n+1] if effective_election_year12 == 1

gen e12_nelda49 = nelda49
replace e12_nelda49 = nelda49[_n+1] if effective_election_year12 == 1

gen e12_nelda24 = nelda24
replace e12_nelda24 = nelda24[_n+1] if effective_election_year12 == 1

gen election_e12 = 0
replace election_e12 = 1 if keep_election_year12 == 1 
replace election_e12 = 1 if effective_election_year12 == 1
 
gen election_e12_opp = election_e12 /*Additionally excludes elections in which there is no opposition*/
replace election_e12_opp = 0 if e12_nelda3 == "no" | e12_nelda4 == "no" | e12_nelda5 == "no"

gen election_e12_free = election_e12_opp /*Additionally excludes elections that are not free and fair*/
replace election_e12_free = 0 if e12_nelda14 == "yes" | e12_nelda15 == "yes" | e12_nelda32 == "yes" | e12_nelda34 == "yes" | e12_nelda47 == "yes" | e12_nelda49 == "yes"

gen election_e12_transition = election_e12 /*Includes only elections that result in a change of power to a new political party (not a hand off of power within the same party)*/
replace election_e12_transition = 0 if e12_nelda24 == "no"

gen election_e12_first = election_e12 /*Includes only first elections (including first elections after an interruption) which include an opposition)*/
replace election_e12_first = 0 if e12_nelda20 == "no" | e12_nelda2 == "no" | e12_nelda3 == "no" | e12_nelda4 == "no" | e12_nelda5 == "no"

***e13 - Elections in first 13 months of the year are coded as t-1***

gen keep_election_year13 = 1 if mmdd != . & mmdd> 199 & nelda20 == "yes"
gen change_election_year13 = 1 if mmdd != . & mmdd <199 & nelda20 == "yes"
gen effective_election_year13 = change_election_year13[_n+2]

gen e13_nelda2 = nelda2
replace e13_nelda2 = nelda2[_n+2] if effective_election_year13 == 1

gen e13_nelda3 = nelda3
replace e13_nelda3 = nelda3[_n+2] if effective_election_year13 == 1

gen e13_nelda4 = nelda4
replace e13_nelda4 = nelda4[_n+2] if effective_election_year13 == 1

gen e13_nelda5 = nelda5
replace e13_nelda5 = nelda5[_n+2] if effective_election_year13 == 1

gen e13_nelda11 = nelda11
replace e13_nelda11 = nelda11[_n+2] if effective_election_year13 == 1

gen e13_nelda12 = nelda12
replace e13_nelda12 = nelda12[_n+2] if effective_election_year13 == 1

gen e13_nelda14 = nelda14
replace e13_nelda14 = nelda14[_n+2] if effective_election_year13 == 1

gen e13_nelda15 = nelda15
replace e13_nelda15 = nelda15[_n+2] if effective_election_year13 == 1

gen e13_nelda16 = nelda16
replace e13_nelda16 = nelda16[_n+2] if effective_election_year13 == 1

gen e13_nelda20 = nelda20
replace e13_nelda20 = nelda20[_n+2] if effective_election_year13 == 1

gen e13_nelda32 = nelda32
replace e13_nelda32 = nelda32[_n+2] if effective_election_year13 == 1

gen e13_nelda34 = nelda34
replace e13_nelda34 = nelda34[_n+2] if effective_election_year13 == 1

gen e13_nelda47 = nelda47
replace e13_nelda47 = nelda47[_n+2] if effective_election_year13 == 1

gen e13_nelda49 = nelda49
replace e13_nelda49 = nelda49[_n+2] if effective_election_year13 == 1

gen e13_nelda24 = nelda24
replace e13_nelda24 = nelda24[_n+2] if effective_election_year13 == 1

gen election_e13 = 0
replace election_e13 = 1 if keep_election_year13 == 1 
replace election_e13 = 1 if effective_election_year13 == 1
 
gen election_e13_opp = election_e13 /*Additionally excludes elections in which there is no opposition*/
replace election_e13_opp = 0 if e13_nelda3 == "no" | e13_nelda4 == "no" | e13_nelda5 == "no"

gen election_e13_free = election_e13_opp /*Additionally excludes elections that are not free and fair*/
replace election_e13_free = 0 if e13_nelda14 == "yes" | e13_nelda15 == "yes" | e13_nelda32 == "yes" | e13_nelda34 == "yes" | e13_nelda47 == "yes" | e13_nelda49 == "yes"

gen election_e13_transition = election_e13 /*Includes only elections that result in a change of power to a new political party (not a hand off of power within the same party)*/
replace election_e13_transition = 0 if e13_nelda24 == "no"

gen election_e13_first = election_e13 /*Includes only first elections (including first elections after an interruption) which include an opposition)*/
replace election_e13_first = 0 if e13_nelda20 == "no" | e13_nelda2 == "no" | e13_nelda3 == "no" | e13_nelda4 == "no" | e13_nelda5 == "no"

****************************************************
****CONSTRUCT ELECTORAL COMPETITIVENESS VARIABLES***
****************************************************

***CORE COMPETITIVENESS VARIABLES, WHERE COMPETITIVE = RULING PARTY WINS LESS THAN 60% OF SEATS***

gen maj2 = maj if maj >=0 & maj<=1

gen comp = 0
replace comp = 1 if maj2[_n+1] <0.60

gen comp_c = comp

gen comp_e1 = comp
replace comp_e1 = comp[_n+1] if effective_election_year1 == 1

gen comp_e2 = comp
replace comp_e2 = comp[_n+1] if effective_election_year2 == 1

gen comp_e3 = comp
replace comp_e3 = comp[_n+1] if effective_election_year3 == 1

gen comp_e4 = comp
replace comp_e4 = comp[_n+1] if effective_election_year4 == 1

gen comp_e5 = comp
replace comp_e5 = comp[_n+1] if effective_election_year5 == 1

gen comp_e6 = comp
replace comp_e6 = comp[_n+1] if effective_election_year6 == 1

gen comp_e7 = comp
replace comp_e7 = comp[_n+1] if effective_election_year7 == 1

gen comp_e8 = comp
replace comp_e8 = comp[_n+1] if effective_election_year8 == 1

gen comp_e9 = comp
replace comp_e9 = comp[_n+1] if effective_election_year9 == 1

gen comp_e10 = comp
replace comp_e10 = comp[_n+1] if effective_election_year10 == 1

gen comp_e11 = comp
replace comp_e11 = comp[_n+1] if effective_election_year11 == 1

gen comp_e12 = comp
replace comp_e12 = comp[_n+1] if effective_election_year12 == 1

gen comp_e13 = comp
replace comp_e13 = comp[_n+2] if effective_election_year13 == 1

gen election_e5_comp = 0
replace election_e5_comp = 1 if election_e5 == 1 & comp_e5 == 1

gen election_c_comp = 0
replace election_c_comp = 1 if election_c == 1 & comp_c == 1

gen election_e1_comp = 0
replace election_e1_comp = 1 if election_e2 == 1 & comp_e1 == 1

gen election_e2_comp = 0
replace election_e2_comp = 1 if election_e2 == 1 & comp_e2 == 1

gen election_e3_comp = 0
replace election_e3_comp = 1 if election_e3 == 1 & comp_e3 == 1

gen election_e4_comp = 0
replace election_e4_comp = 1 if election_e4 == 1 & comp_e4 == 1

gen election_e6_comp = 0
replace election_e6_comp = 1 if election_e6 == 1 & comp_e6 == 1

gen election_e7_comp = 0
replace election_e7_comp = 1 if election_e7 == 1 & comp_e7 == 1

gen election_e8_comp = 0
replace election_e8_comp = 1 if election_e8 == 1 & comp_e8 == 1

gen election_e9_comp = 0
replace election_e9_comp = 1 if election_e9 == 1 & comp_e9 == 1

gen election_e10_comp = 0
replace election_e10_comp = 1 if election_e10 == 1 & comp_e10 == 1

gen election_e11_comp = 0
replace election_e11_comp = 1 if election_e11 == 1 & comp_e11 == 1

gen election_e12_comp = 0
replace election_e12_comp = 1 if election_e12 == 1 & comp_e12 == 1

gen election_e13_comp = 0
replace election_e13_comp = 1 if election_e13 == 1 & comp_e13 == 1

***ALTERNATIVE MEASURES OF ELECTORAL COMPETITIVENESS***

***COMP50 - COMPETITIVE IF RULING PARTY WINS LESS THAN 50% OF TOTAL SEATS***

gen comp50 = 0
replace comp50 = 1 if maj2[_n+1]<0.50

gen comp50_e5 = comp50
replace comp50_e5 = comp50[_n+1] if effective_election_year5 == 1

gen comp50_e1 = comp50
replace comp50_e1 = comp50[_n+1] if effective_election_year1 == 1

gen comp50_e2 = comp50
replace comp50_e2 = comp50[_n+1] if effective_election_year2 == 1

gen comp50_e3 = comp50
replace comp50_e3 = comp50[_n+1] if effective_election_year3 == 1

gen comp50_e4 = comp50
replace comp50_e4 = comp50[_n+1] if effective_election_year4 == 1

gen comp50_e6 = comp50
replace comp50_e6 = comp50[_n+1] if effective_election_year6 == 1

gen comp50_e7 = comp50
replace comp50_e7 = comp50[_n+1] if effective_election_year7 == 1

gen comp50_e8 = comp50
replace comp50_e8 = comp50[_n+1] if effective_election_year8 == 1

gen comp50_e9 = comp50
replace comp50_e9 = comp50[_n+1] if effective_election_year9 == 1

gen comp50_e10 = comp50
replace comp50_e10 = comp50[_n+1] if effective_election_year10 == 1

gen comp50_e11 = comp50
replace comp50_e11 = comp50[_n+1] if effective_election_year11 == 1

gen comp50_e12 = comp50
replace comp50_e12 = comp50[_n+1] if effective_election_year12 == 1

gen comp50_e13 = comp50
replace comp50_e13 = comp50[_n+2] if effective_election_year13 == 1

gen comp50_c = comp50

gen election_e5_comp50 = 0
replace election_e5_comp50 = 1 if election_e5 == 1 & comp50_e5 == 1

gen election_c_comp50 = 0
replace election_c_comp50 = 1 if election_c == 1 & comp50_c == 1

gen election_e1_comp50 = 0
replace election_e1_comp50 = 1 if election_e1 == 1 & comp50_e1 == 1

gen election_e2_comp50 = 0
replace election_e2_comp50 = 1 if election_e2 == 1 & comp50_e2 == 1

gen election_e3_comp50 = 0
replace election_e3_comp50 = 1 if election_e3 == 1 & comp50_e3 == 1

gen election_e4_comp50 = 0
replace election_e4_comp50 = 1 if election_e4 == 1 & comp50_e4 == 1

gen election_e6_comp50 = 0
replace election_e6_comp50 = 1 if election_e6 == 1 & comp50_e6 == 1

gen election_e7_comp50 = 0
replace election_e7_comp50 = 1 if election_e7 == 1 & comp50_e7 == 1

gen election_e8_comp50 = 0
replace election_e8_comp50 = 1 if election_e8 == 1 & comp50_e8 == 1

gen election_e9_comp50 = 0
replace election_e9_comp50 = 1 if election_e9 == 1 & comp50_e9 == 1

gen election_e10_comp50 = 0
replace election_e10_comp50 = 1 if election_e10 == 1 & comp50_e10 == 1

gen election_e11_comp50 = 0
replace election_e11_comp50 = 1 if election_e11 == 1 & comp50_e11 == 1

gen election_e12_comp50 = 0
replace election_e12_comp50 = 1 if election_e12 == 1 & comp50_e12 == 1

gen election_e13_comp50 = 0
replace election_e13_comp50 = 1 if election_e13 == 1 & comp50_e13 == 1

***COMP70 - COMPETITIVE IF RULING PARTY WINS LESS THAN 70% OF TOTAL SEATS***

gen comp70 = 0
replace comp70 = 1 if maj2[_n+1]<0.70

gen comp70_e5 = comp70
replace comp70_e5 = comp70[_n+1] if effective_election_year5 == 1

gen comp70_e1 = comp70
replace comp70_e1 = comp70[_n+1] if effective_election_year1 == 1

gen comp70_e2 = comp70
replace comp70_e2 = comp70[_n+1] if effective_election_year2 == 1

gen comp70_e3 = comp70
replace comp70_e3 = comp70[_n+1] if effective_election_year3 == 1

gen comp70_e4 = comp70
replace comp70_e4 = comp70[_n+1] if effective_election_year4 == 1

gen comp70_e6 = comp70
replace comp70_e6 = comp70[_n+1] if effective_election_year6 == 1

gen comp70_e7 = comp70
replace comp70_e7 = comp70[_n+1] if effective_election_year7 == 1

gen comp70_e8 = comp70
replace comp70_e8 = comp70[_n+1] if effective_election_year8 == 1

gen comp70_e9 = comp70
replace comp70_e9 = comp70[_n+1] if effective_election_year9 == 1

gen comp70_e10 = comp70
replace comp70_e10 = comp70[_n+1] if effective_election_year10 == 1

gen comp70_e11 = comp70
replace comp70_e11 = comp70[_n+1] if effective_election_year11 == 1

gen comp70_e12 = comp70
replace comp70_e12 = comp70[_n+1] if effective_election_year12 == 1

gen comp70_e13 = comp70
replace comp70_e13 = comp70[_n+2] if effective_election_year13 == 1

gen comp70_c = comp70

gen election_e5_comp70 = 0
replace election_e5_comp70 = 1 if election_e5 == 1 & comp70_e5 == 1

gen election_c_comp70 = 0
replace election_c_comp70 = 1 if election_c == 1 & comp70_c == 1

gen election_e1_comp70 = 0
replace election_e1_comp70 = 1 if election_e1 == 1 & comp70_e1 == 1

gen election_e2_comp70 = 0
replace election_e2_comp70 = 1 if election_e2 == 1 & comp70_e2 == 1

gen election_e3_comp70 = 0
replace election_e3_comp70 = 1 if election_e3 == 1 & comp70_e3 == 1

gen election_e4_comp70 = 0
replace election_e4_comp70 = 1 if election_e4 == 1 & comp70_e4 == 1

gen election_e6_comp70 = 0
replace election_e6_comp70 = 1 if election_e6 == 1 & comp70_e6 == 1

gen election_e7_comp70 = 0
replace election_e7_comp70 = 1 if election_e7 == 1 & comp70_e7 == 1

gen election_e8_comp70 = 0
replace election_e8_comp70 = 1 if election_e8 == 1 & comp70_e8 == 1

gen election_e9_comp70 = 0
replace election_e9_comp70 = 1 if election_e9 == 1 & comp70_e9 == 1

gen election_e10_comp70 = 0
replace election_e10_comp70 = 1 if election_e10 == 1 & comp70_e10 == 1

gen election_e11_comp70 = 0
replace election_e11_comp70 = 1 if election_e11 == 1 & comp70_e11 == 1

gen election_e12_comp70 = 0
replace election_e12_comp70 = 1 if election_e12 == 1 & comp70_e12 == 1

gen election_e13_comp70 = 0
replace election_e13_comp70 = 1 if election_e13 == 1 & comp70_e13 == 1

***COMP VOTE - COMPETITIVE IF RULING PARTY RECEIVES LESS THAN 60% OF TOTAL VOTES***

gen numvote2 = numvote if numvote >0 & numvote<=100 /*Eliminate missing values, of which there are somewhat more than for total seats*/

gen comp_vote = 0
replace comp_vote = 1 if numvote2[_n+1]<60

gen comp_vote_e3 = comp_vote
replace comp_vote_e3 = comp_vote[_n+1] if effective_election_year3 == 1

gen comp_vote_e4 = comp_vote
replace comp_vote_e4 = comp_vote[_n+1] if effective_election_year4 == 1

gen comp_vote_e5 = comp_vote
replace comp_vote_e5 = comp_vote[_n+1] if effective_election_year5 == 1

gen comp_vote_e6 = comp_vote
replace comp_vote_e6 = comp_vote[_n+1] if effective_election_year6 == 1

gen election_c_comp_vote = 0
replace election_c_comp_vote = 1 if election_c == 1 & comp_vote == 1

gen election_e3_comp_vote = 0
replace election_e3_comp_vote = 1 if election_e3 == 1 & comp_vote_e3 == 1

gen election_e4_comp_vote = 0
replace election_e4_comp_vote = 1 if election_e4 == 1 & comp_vote_e4 == 1

gen election_e5_comp_vote = 0
replace election_e5_comp_vote = 1 if election_e5 == 1 & comp_vote_e5 == 1

gen election_e6_comp_vote = 0
replace election_e6_comp_vote = 1 if election_e6 == 1 & comp_vote_e6 == 1

***COMP VOTE50 - COMPETITIVE IF RULING PARTY RECEIVES LESS THAN 50% OF TOTAL VOTES***

gen comp_vote50 = 0
replace comp_vote50 = 1 if numvote2[_n+1]<50

gen comp_vote50_e3 = comp_vote50
replace comp_vote50_e3 = comp_vote50[_n+1] if effective_election_year3 == 1

gen comp_vote50_e4 = comp_vote50
replace comp_vote50_e4 = comp_vote50[_n+1] if effective_election_year4 == 1

gen comp_vote50_e5 = comp_vote50
replace comp_vote50_e5 = comp_vote50[_n+1] if effective_election_year5 == 1

gen comp_vote50_e6 = comp_vote50
replace comp_vote50_e6 = comp_vote50[_n+1] if effective_election_year6 == 1

gen election_c_comp_vote50 = 0
replace election_c_comp_vote50 = 1 if election_c == 1 & comp_vote50 == 1

gen election_e3_comp_vote50 = 0
replace election_e3_comp_vote50 = 1 if election_e3 == 1 & comp_vote50_e3 == 1

gen election_e4_comp_vote50 = 0
replace election_e4_comp_vote50 = 1 if election_e4 == 1 & comp_vote50_e4 == 1

gen election_e5_comp_vote50 = 0
replace election_e5_comp_vote50 = 1 if election_e5 == 1 & comp_vote50_e5 == 1

gen election_e6_comp_vote50 = 0
replace election_e6_comp_vote50 = 1 if election_e6 == 1 & comp_vote50_e6 == 1

***COMP VOTE70 - COMPETITIVE IF RULING PARTY RECEIVES LESS THAN 70% OF TOTAL VOTES***

gen comp_vote70 = 0
replace comp_vote70 = 1 if numvote2[_n+1]<70

gen comp_vote70_e3 = comp_vote70
replace comp_vote70_e3 = comp_vote70[_n+1] if effective_election_year3 == 1

gen comp_vote70_e4 = comp_vote70
replace comp_vote70_e4 = comp_vote70[_n+1] if effective_election_year4 == 1

gen comp_vote70_e5 = comp_vote70
replace comp_vote70_e5 = comp_vote70[_n+1] if effective_election_year5 == 1

gen comp_vote70_e6 = comp_vote70
replace comp_vote70_e6 = comp_vote70[_n+1] if effective_election_year6 == 1

gen election_c_comp_vote70 = 0
replace election_c_comp_vote70 = 1 if election_c == 1 & comp70 == 1

gen election_e3_comp_vote70 = 0
replace election_e3_comp_vote70 = 1 if election_e3 == 1 & comp_vote70_e3 == 1

gen election_e4_comp_vote70 = 0
replace election_e4_comp_vote70 = 1 if election_e4 == 1 & comp_vote70_e4 == 1

gen election_e5_comp_vote70 = 0
replace election_e5_comp_vote70 = 1 if election_e5 == 1 & comp_vote70_e5 == 1

gen election_e6_comp_vote70 = 0
replace election_e6_comp_vote70 = 1 if election_e6 == 1 & comp_vote70_e6 == 1

*******************************************************************************
***LIMIT TRANSITION AND COMPETITIVENESS VARAIBLES TO OPPOSED ELECTIONS ONLY****
***Addresses very minor differences in coding between datasets and variables***
*******************************************************************************

replace election_c_transition = 0 if election_c_opp == 0

replace election_c_comp = 0 if election_c_opp == 0

replace election_c_comp50 = 0 if election_c_opp == 0

replace election_c_comp70 = 0 if election_c_opp == 0

replace election_c_comp_vote = 0 if election_c_opp == 0

replace election_c_comp_vote50 = 0 if election_c_opp == 0

replace election_c_comp_vote70 = 0 if election_c_opp == 0


replace election_e1_transition = 0 if election_e1_opp == 0

replace election_e1_comp = 0 if election_e1_opp == 0

replace election_e1_comp50 = 0 if election_e1_opp == 0

replace election_e1_comp70 = 0 if election_e1_opp == 0


replace election_e2_transition = 0 if election_e2_opp == 0

replace election_e2_comp = 0 if election_e2_opp == 0

replace election_e2_comp50 = 0 if election_e2_opp == 0

replace election_e2_comp70 = 0 if election_e2_opp == 0


replace election_e3_transition = 0 if election_e3_opp == 0

replace election_e3_comp = 0 if election_e3_opp == 0

replace election_e3_comp50 = 0 if election_e3_opp == 0

replace election_e3_comp70 = 0 if election_e3_opp == 0

replace election_e3_comp_vote = 0 if election_e3_opp == 0

replace election_e3_comp_vote50 = 0 if election_e3_opp == 0

replace election_e3_comp_vote70 = 0 if election_e3_opp == 0


replace election_e4_transition = 0 if election_e4_opp == 0

replace election_e4_comp = 0 if election_e4_opp == 0

replace election_e4_comp50 = 0 if election_e4_opp == 0

replace election_e4_comp70 = 0 if election_e4_opp == 0

replace election_e4_comp_vote = 0 if election_e4_opp == 0

replace election_e4_comp_vote50 = 0 if election_e4_opp == 0

replace election_e4_comp_vote70 = 0 if election_e4_opp == 0


replace election_e5_transition = 0 if election_e5_opp == 0

replace election_e5_comp = 0 if election_e5_opp == 0

replace election_e5_comp50 = 0 if election_e5_opp == 0

replace election_e5_comp70 = 0 if election_e5_opp == 0

replace election_e5_comp_vote = 0 if election_e5_opp == 0

replace election_e5_comp_vote50 = 0 if election_e5_opp == 0

replace election_e5_comp_vote70 = 0 if election_e5_opp == 0

replace election_e5_transition = 0 if election_e5_opp == 0


replace election_e6_comp = 0 if election_e6_opp == 0

replace election_e6_comp50 = 0 if election_e6_opp == 0

replace election_e6_comp70 = 0 if election_e6_opp == 0

replace election_e6_comp_vote = 0 if election_e6_opp == 0

replace election_e6_comp_vote50 = 0 if election_e6_opp == 0

replace election_e6_comp_vote70 = 0 if election_e6_opp == 0


replace election_e7_transition = 0 if election_e7_opp == 0

replace election_e7_comp = 0 if election_e7_opp == 0

replace election_e7_comp50 = 0 if election_e7_opp == 0

replace election_e7_comp70 = 0 if election_e7_opp == 0


replace election_e8_transition = 0 if election_e8_opp == 0

replace election_e8_comp = 0 if election_e8_opp == 0

replace election_e8_comp50 = 0 if election_e8_opp == 0

replace election_e8_comp70 = 0 if election_e8_opp == 0


replace election_e9_transition = 0 if election_e9_opp == 0

replace election_e9_comp = 0 if election_e9_opp == 0

replace election_e9_comp50 = 0 if election_e9_opp == 0

replace election_e9_comp70 = 0 if election_e9_opp == 0


replace election_e10_transition = 0 if election_e10_opp == 0

replace election_e10_comp = 0 if election_e10_opp == 0

replace election_e10_comp50 = 0 if election_e10_opp == 0

replace election_e10_comp70 = 0 if election_e10_opp == 0


replace election_e11_transition = 0 if election_e11_opp == 0

replace election_e11_comp = 0 if election_e11_opp == 0

replace election_e11_comp50 = 0 if election_e11_opp == 0

replace election_e11_comp70 = 0 if election_e11_opp == 0


replace election_e12_transition = 0 if election_e12_opp == 0

replace election_e12_comp = 0 if election_e12_opp == 0

replace election_e12_comp50 = 0 if election_e12_opp == 0

replace election_e12_comp70 = 0 if election_e12_opp == 0


replace election_e13_transition = 0 if election_e13_opp == 0

replace election_e13_comp = 0 if election_e13_opp == 0

replace election_e13_comp50 = 0 if election_e13_opp == 0

replace election_e13_comp70 = 0 if election_e13_opp == 0

********************************************************************************
***PREAPRE VARIABLES DISENTANGLING IMPACTS OF COMPETITIVENESS AND TRANSITIONS***
********************************************************************************

gen election_c_comp_trans = election_c_comp
replace election_c_comp_trans = 0 if election_c_transition != 1

gen election_c_comp_notrans = election_c_comp
replace election_c_comp_notrans = 0 if election_c_transition == 1

gen election_c_trans_nocomp = election_c_trans
replace election_c_trans_nocomp = 0 if election_c_comp == 1

gen election_e1_comp_trans = election_e1_comp
replace election_e1_comp_trans = 0 if election_e1_transition != 1

gen election_e1_comp_notrans = election_e1_comp
replace election_e1_comp_notrans = 0 if election_e1_transition == 1

gen election_e1_trans_nocomp = election_e1_trans
replace election_e1_trans_nocomp = 0 if election_e1_comp == 1

gen election_e2_comp_trans = election_e2_comp
replace election_e2_comp_trans = 0 if election_e2_transition != 1

gen election_e2_comp_notrans = election_e2_comp
replace election_e2_comp_notrans = 0 if election_e2_transition == 1

gen election_e2_trans_nocomp = election_e2_trans
replace election_e2_trans_nocomp = 0 if election_e2_comp == 1

gen election_e3_comp_trans = election_e3_comp
replace election_e3_comp_trans = 0 if election_e3_transition != 1

gen election_e3_comp_notrans = election_e3_comp
replace election_e3_comp_notrans = 0 if election_e3_transition == 1

gen election_e3_trans_nocomp = election_e3_trans
replace election_e3_trans_nocomp = 0 if election_e3_comp == 1

gen election_e4_comp_trans = election_e4_comp
replace election_e4_comp_trans = 0 if election_e4_transition != 1

gen election_e4_comp_notrans = election_e4_comp
replace election_e4_comp_notrans = 0 if election_e4_transition == 1

gen election_e4_trans_nocomp = election_e4_trans
replace election_e4_trans_nocomp = 0 if election_e4_comp == 1

gen election_e5_comp_trans = election_e5_comp
replace election_e5_comp_trans = 0 if election_e5_transition != 1

gen election_e5_comp_notrans = election_e5_comp
replace election_e5_comp_notrans = 0 if election_e5_transition == 1

gen election_e5_trans_nocomp = election_e5_trans
replace election_e5_trans_nocomp = 0 if election_e5_comp == 1

gen election_e6_comp_trans = election_e6_comp
replace election_e6_comp_trans = 0 if election_e6_transition != 1

gen election_e6_comp_notrans = election_e6_comp
replace election_e6_comp_notrans = 0 if election_e6_transition == 1

gen election_e6_trans_nocomp = election_e6_trans
replace election_e6_trans_nocomp = 0 if election_e6_comp == 1

gen election_e7_comp_trans = election_e7_comp
replace election_e7_comp_trans = 0 if election_e7_transition != 1

gen election_e7_comp_notrans = election_e7_comp
replace election_e7_comp_notrans = 0 if election_e7_transition == 1

gen election_e7_trans_nocomp = election_e7_trans
replace election_e7_trans_nocomp = 0 if election_e7_comp == 1

gen election_e8_comp_trans = election_e8_comp
replace election_e8_comp_trans = 0 if election_e8_transition != 1

gen election_e8_comp_notrans = election_e8_comp
replace election_e8_comp_notrans = 0 if election_e8_transition == 1

gen election_e8_trans_nocomp = election_e8_trans
replace election_e8_trans_nocomp = 0 if election_e8_comp == 1

gen election_e9_comp_trans = election_e9_comp
replace election_e9_comp_trans = 0 if election_e9_transition != 1

gen election_e9_comp_notrans = election_e9_comp
replace election_e9_comp_notrans = 0 if election_e9_transition == 1

gen election_e9_trans_nocomp = election_e9_trans
replace election_e9_trans_nocomp = 0 if election_e9_comp == 1

gen election_e10_comp_trans = election_e10_comp
replace election_e10_comp_trans = 0 if election_e10_transition != 1

gen election_e10_comp_notrans = election_e10_comp
replace election_e10_comp_notrans = 0 if election_e10_transition == 1

gen election_e10_trans_nocomp = election_e10_trans
replace election_e10_trans_nocomp = 0 if election_e10_comp == 1

gen election_e11_comp_trans = election_e11_comp
replace election_e11_comp_trans = 0 if election_e11_transition != 1

gen election_e11_comp_notrans = election_e11_comp
replace election_e11_comp_notrans = 0 if election_e11_transition == 1

gen election_e11_trans_nocomp = election_e11_trans
replace election_e11_trans_nocomp = 0 if election_e11_comp == 1

gen election_e12_comp_trans = election_e12_comp
replace election_e12_comp_trans = 0 if election_e12_transition != 1

gen election_e12_comp_notrans = election_e12_comp
replace election_e12_comp_notrans = 0 if election_e12_transition == 1

gen election_e12_trans_nocomp = election_e12_trans
replace election_e12_trans_nocomp = 0 if election_e12_comp == 1

gen election_e13_comp_trans = election_e13_comp
replace election_e13_comp_trans = 0 if election_e13_transition != 1

gen election_e13_comp_notrans = election_e13_comp
replace election_e13_comp_notrans = 0 if election_e13_transition == 1

gen election_e13_trans_nocomp = election_e13_trans
replace election_e13_trans_nocomp = 0 if election_e13_comp == 1

*************************************************************
***CONSTRUCTING ALTERNATIVE VARIABLES FOR ELECTION QUALITY***
*************************************************************

gen ff_e5 = 0
replace ff_e5 = ff
replace ff_e5 = ff[_n+1] if effective_election_year5 == 1

gen fof = 0
replace fof = 0 if free == 0 & fair == 0
replace fof = 1 if free == 1 | fair == 1

gen fof_e5 = fof
replace fof_e5 = fof[_n+1] if effective_election_year5 == 1

gen nfnf = 0
replace nfnf = 0 if free == 1 | fair == 1
replace nfnf = 1 if free == 0 & fair == 0

gen nfnf_e5 = nfnf
replace nfnf_e5 = nfnf[_n+1] if effective_election_year5 == 1

gen qedgood = 0
replace qedgood = 1 if qed_ff == 2

gen qedok = 0
replace qedok = 1 if qed_ff == 2 | qed_ff == 1

gen qedgood_e5 = qedgood
replace qedgood_e5 = qedgood[_n+1] if effective_election_year5 == 1

gen qedok_e5 = qedok
replace qedok_e5 = qedok[_n+1] if effective_election_year5 == 1

gen polity70 = .
replace polity70 = 1 if polity_s>69
replace polity70 = 0 if polity_s<70

gen polity70_e5 = polity70
replace polity70_e5 = polity70[_n+1] if effective_election_year5 == 1

gen nofraud_dpi = 1
replace nofraud_dpi = 0 if fraud ==1

gen nofraud_dpi_e5 = nofraud_dpi
replace nofraud_dpi_e5 = nofraud_dpi[_n+1] if effective_election_year5 == 1

gen election_e5_ff = 0
replace election_e5_ff = 1 if election_e5 == 1 & ff_e5 == 1

gen election_e5_fof = 0
replace election_e5_fof = 1 if election_e5 == 1 & fof_e5 == 1

gen election_e5_nfnf = 0
replace election_e5_nfnf = 1 if election_e5 == 1 & nfnf_e5 == 1

gen election_e5_qedgood = 0
replace election_e5_qedgood = 1 if election_e5 == 1 & qedgood_e5 == 1

gen election_e5_qedok = 0
replace election_e5_qedok = 1 if election_e5 == 1 & qedok_e5 == 1

gen election_e5_polity70 = 0
replace election_e5_polity70 = 1 if election_e5 == 1 & polity70_e5 == 1

gen election_e5_nofraud_dpi = 0
replace election_e5_nofraud_dpi = 1 if election_e5 == 1 & nofraud_dpi_e5 == 1

***************************
***Save Prepared Dataset***
***************************

save $PathData/Prichard_ElectoralCycles_FINAL, replace

drop if incomegroup != 1 & incomegroup != 2 & incomegroup != 3


************************************************************************************************
************************************************************************************************
************************************DESCRIPTIVE DATA********************************************
************************************************************************************************
************************************************************************************************


***********FIGURE 1: ELECTION YEAR CHANGES IN TAX COLLECTION*************

sum d.tottax

sum d.tottax if election_e5 == 1

sum d.tottax if election_e5_opp == 1

sum d.tottax if election_e5_free == 1

sum d.tottax if election_e5_first == 1

sum d.tottax if election_e5_comp == 1

sum d.tottax if election_e5_transition == 1 & election_e5_comp == 1

sum d.tottax if election_e5_transition == 0 & election_e5_comp == 1

sum d.tottax if election_e5_transition == 1 & election_e5_comp == 0

sum d.tottax if election_e5_transition == 1


************************************************************************************************
************************************************************************************************
************************************MAIN PAPER TABLES*******************************************
************************************************************************************************
************************************************************************************************

*****************************************************************
***Table 1: Effect of Different Election Types on Tax Revenue ***
*****************************************************************

xtreg tottax L.tottax election_e5 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 , vce(robust)fe i(ccode)
est store r1

xtreg tottax L.tottax election_e5 election_e5_opp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 , vce(robust)fe i(ccode)
est store r2

lincom election_e5 + election_e5_opp

xtreg tottax L.tottax election_e5_opp election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 , vce(robust)fe i(ccode)
est store r3

lincom election_e5_opp + election_e5_comp

xtabond2 tottax L.tottax election_e5 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e5, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r4

xtabond2 tottax L.tottax election_e5 election_e5_opp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e5 election_e5_opp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r5

lincom election_e5 + election_e5_opp

xtabond2 tottax L.tottax election_e5_opp election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e5_opp election_e5_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r6

lincom election_e5_opp + election_e5_comp

esttab  r1 r2 r3 r4 r5 r6/*
*/ using $PathEst/Maintables_20151010_tables.rtf, replace cells(b(star fmt(4)) se(par fmt(4))) /*
*/ legend label varlabels(_cons Constant) stats(N N_g r2 , fmt(0 3))  /*
*/ title("Table 1: Effect of Different Elections Types on Tax Revenue") /*
*/ starlevels(* 0.10 ** 0.05 *** 0.01) modelwidth(4) varwidth(12) /*
*/ keep(L.tottax election_e5 election_e5_opp election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ order(L.tottax election_e5 election_e5_opp election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ mlabels("FE" "FE" "FE" "Sys-GMM" "Sys-GMM" "Sys-GMM" )

*************************************************************************************
***Table 2: Re-estimating Results Using Alternative Definitions of Competitiveness***
*************************************************************************************

use $PathData/Prichard_ElectoralCycles_FINAL, clear
drop if incomegroup != 1 & incomegroup != 2 & incomegroup != 3

xtreg tottax L.tottax election_e5_opp election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 , vce(robust)fe i(ccode)
est store r1

lincom election_e5_opp + election_e5_comp

xtabond2 tottax L.tottax election_e5_opp election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.tottax election_e5_opp election_e5_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r2

lincom election_e5_opp + election_e5_comp

xtreg tottax L.tottax election_e5_opp election_e5_comp50 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 , vce(robust)fe i(ccode)
est store r3

lincom election_e5_opp + election_e5_comp50

xtabond2 tottax L.tottax election_e5_opp election_e5_comp50 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.tottax election_e5_opp election_e5_comp50, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r4

lincom election_e5_opp + election_e5_comp50

xtreg tottax L.tottax election_e5_opp election_e5_comp70 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 , vce(robust)fe i(ccode)
est store r5

lincom election_e5_opp + election_e5_comp70

xtabond2 tottax L.tottax election_e5_opp election_e5_comp70 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.tottax election_e5_opp election_e5_comp70, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r6

lincom election_e5_opp + election_e5_comp70

xtreg tottax L.tottax election_e5_opp election_e5_comp_vote lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 , vce(robust)fe i(ccode)
est store r7

lincom election_e5_opp + election_e5_comp_vote

xtabond2 tottax L.tottax election_e5_opp election_e5_comp_vote lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.tottax election_e5_opp election_e5_comp_vote, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r8

lincom election_e5_opp + election_e5_comp_vote

xtreg tottax L.tottax election_e5_opp election_e5_comp_vote50 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 , vce(robust)fe i(ccode)
est store r9

lincom election_e5_opp + election_e5_comp_vote50

xtabond2 tottax L.tottax election_e5_opp election_e5_comp_vote50 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.tottax election_e5_opp election_e5_comp_vote50, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r10

lincom election_e5_opp + election_e5_comp_vote50

xtreg tottax L.tottax election_e5_opp election_e5_comp_vote70 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 , vce(robust)fe i(ccode)
est store r11

lincom election_e5_opp + election_e5_comp_vote70

xtabond2 tottax L.tottax election_e5_opp election_e5_comp_vote70 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.tottax election_e5_opp election_e5_comp_vote70, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r12

lincom election_e5_opp + election_e5_comp_vote70

esttab  r1 r2 r3 r4 r5 r6 r7 r8 r9 r10 r11 r12/*
*/ using $PathEst/Maintables_20151010_tables.rtf, append cells(b(star fmt(4)) se(par fmt(4))) /*
*/ legend label varlabels(_cons Constant) stats(N N_g r2 , fmt(0 3))  /*
*/ title("Table 2: Re-estimating Key Results Using Alternative Definitions of Competitive") /*
*/ starlevels(* 0.10 ** 0.05 *** 0.01) modelwidth(4) varwidth(12) /*
*/ keep(L.tottax election_e5_opp election_e5_comp election_e5_comp50 election_e5_comp70 election_e5_comp_vote election_e5_comp_vote50  election_e5_comp_vote70 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ order(L.tottax election_e5_opp election_e5_comp election_e5_comp50 election_e5_comp70 election_e5_comp_vote election_e5_comp_vote50  election_e5_comp_vote70 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ mlabels("FE" "Sys-GMM" "FE" "Sys-GMM" "FE" "Sys-GMM" "FE" "Sys-GMM" "FE" "Sys-GMM" "FE" "Sys-GMM")

*********************************************************************
***Table 3: Effect of Elections on Direct and Indirect Tax Revenue***
*********************************************************************

xtreg direct L.direct election_e5 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 , vce(robust)fe i(ccode)
est store r1

xtabond2 direct L.direct election_e5 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.direct election_e5, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r2

xtreg indirect L.indirect election_e5 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 , vce(robust)fe i(ccode)
est store r3

xtabond2 indirect L.indirect election_e5 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.indirect election_e5, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r4

xtreg direct L.direct election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 , vce(robust)fe i(ccode)
est store r5

xtabond2 direct L.direct election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.direct election_e5_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r6

xtreg indirect L.indirect election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 , vce(robust)fe i(ccode)
est store r7

xtabond2 indirect L.indirect election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.indirect election_e5_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r8

esttab  r1 r2 r3 r4 r5 r6 r7 r8 /*
*/ using $PathEst/Maintables_20151010_tables.rtf, append cells(b(star fmt(4)) se(par fmt(4))) /*
*/ legend label varlabels(_cons Constant) stats(N N_g r2 , fmt(0 3))  /*
*/ title("Table 3: Effect of Elections on Direct and Indirect Tax Revenue") /*
*/ starlevels(* 0.10 ** 0.05 *** 0.01) modelwidth(4) varwidth(12) /*
*/ keep(L.direct L.indirect election_e5 election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ order(L.direct L.indirect election_e5 election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ mlabels("FE" "Sys-GMM" "FE" "Sys-GMM" "FE" "Sys-GMM" "FE" "Sys-GMM" "FE" "Sys-GMM" "FE" "Sys-GMM")

*******************************************************************************
*****Table 4: Distinguishing Between Competitive and Transitional Elections****
*******************************************************************************

use $PathData/Prichard_ElectoralCycles_FINAL, clear
drop if incomegroup != 1 & incomegroup != 2 & incomegroup != 3

xtreg tottax L.tottax election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 , vce(robust)fe i(ccode)
est store r1

xtreg tottax L.tottax election_e5_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 , vce(robust)fe i(ccode)
est store r2

xtreg tottax L.tottax election_e5_comp_trans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 , vce(robust)fe i(ccode) 
est store r3

xtreg tottax L.tottax election_e5_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 , vce(robust)fe i(ccode) 
est store r4

xtreg tottax L.tottax election_e5_trans_nocomp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 , vce(robust)fe i(ccode) 
est store r5

xtabond2 tottax L.tottax election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e5_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r6

xtabond2 tottax L.tottax election_e5_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e5_transition, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r7

xtabond2 tottax L.tottax election_e5_comp_trans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e5_comp_trans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r8

xtabond2 tottax L.tottax election_e5_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e5_comp_notrans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r9

xtabond2 tottax L.tottax election_e5_trans_nocomp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e5_trans_nocomp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r10

esttab  r1 r2 r3 r4 r5 r6 r7 r8 r9 r10/*
*/ using $PathEst/Maintables_20151010_tables.rtf, append cells(b(star fmt(4)) se(par fmt(4))) /*
*/ legend label varlabels(_cons Constant) stats(N N_g r2 , fmt(0 3))  /*
*/ title("Table 4: Distinguishing Between Competitive and Transition Elections") /*
*/ starlevels(* 0.10 ** 0.05 *** 0.01) modelwidth(4) varwidth(12) /*
*/ keep(election_e5_comp election_e5_transition election_e5_comp_trans election_e5_comp_notrans election_e5_trans_nocomp imports civil_war_hm totnontax growthpc lgdp agric inflationgdp) /*
*/ order(election_e5_comp election_e5_transition election_e5_comp_trans election_e5_comp_notrans election_e5_trans_nocomp imports civil_war_hm totnontax growthpc lgdp agric inflationgdp) /*
*/ mlabels("FE" "FE" "FE" "FE" "FE" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" )

***Table 5a: Impact of Employing Alternative Definitions of Election Year – Fixed Effects, Competitive Elections***

use $PathData/Prichard_ElectoralCycles_FINAL, clear
drop if incomegroup != 1 & incomegroup != 2 & incomegroup != 3

xtreg tottax L.tottax election_c_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r1

xtreg tottax L.tottax election_e1_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r2

xtreg tottax L.tottax election_e2_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r3

xtreg tottax L.tottax election_e3_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r4

xtreg tottax L.tottax election_e4_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r5

xtreg tottax L.tottax election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r6

xtreg tottax L.tottax election_e6_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r7

xtreg tottax L.tottax election_e7_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r8

xtreg tottax L.tottax election_e8_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r9

xtreg tottax L.tottax election_e9_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r10

xtreg tottax L.tottax election_e10_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r11

xtreg tottax L.tottax election_e11_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r12

xtreg tottax L.tottax election_e12_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r13

xtreg tottax L.tottax election_e13_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r14

esttab  r1 r2 r3 r4 r5 r6 r7 r8 r9 r10 r11 r12 r13 r14/*
*/ using $PathEst/Maintables_20151010_tables.rtf, append cells(b(star fmt(4)) se(par fmt(4))) /*
*/ legend label varlabels(_cons Constant) stats(N N_g r2 , fmt(0 3))  /*
*/ title("Table 5a: Impact of Employing Alternative Definitions of Election Year – Fixed Effects, Competitive Elections") /*
*/ starlevels(* 0.10 ** 0.05 *** 0.01) modelwidth(4) varwidth(12) /*
*/ keep(L.tottax election_c_comp election_e1_comp election_e2_comp election_e3_comp election_e4_comp election_e5_comp election_e6_comp election_e7_comp election_e8_comp election_e9_comp election_e10_comp election_e11_comp election_e12_comp election_e13_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ order(L.tottax election_c_comp election_e1_comp election_e2_comp election_e3_comp election_e4_comp election_e5_comp election_e6_comp election_e7_comp election_e8_comp election_e9_comp election_e10_comp election_e11_comp election_e12_comp election_e13_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ mlabels("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE")

***Table 5b: Impact of Employing Alternative Definitions of Election Year – System-GMM, Competitive Elections***

use $PathData/Prichard_ElectoralCycles_FINAL, clear
drop if incomegroup != 1 & incomegroup != 2 & incomegroup != 3

xtabond2 tottax L.tottax election_c_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_c_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r1

**lincom election_c_opp + election_c_comp

xtabond2 tottax L.tottax election_e1_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e1_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r2

**lincom election_e1_opp + election_e1_comp

xtabond2 tottax L.tottax election_e2_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e2_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r3

**lincom election_e2_opp + election_e2_comp

xtabond2 tottax L.tottax election_e3_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e3_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r4

**lincom election_e3_opp + election_e3_comp

xtabond2 tottax L.tottax election_e4_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e4_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r5

**lincom election_e4_opp + election_e4_comp

xtabond2 tottax L.tottax election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e5_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r6

**lincom election_e5_opp + election_e5_comp

xtabond2 tottax L.tottax election_e6_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e6_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r7

**lincom election_e6_opp + election_e6_comp

xtabond2 tottax L.tottax election_e7_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e7_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r8

**lincom election_e7_opp + election_e7_comp

xtabond2 tottax L.tottax election_e8_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e8_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r9

**lincom election_e8_opp + election_e8_comp

xtabond2 tottax L.tottax election_e9_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e9_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r10

**lincom election_e9_opp + election_e9_comp

xtabond2 tottax L.tottax election_e10_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e10_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r11

**lincom election_e10_opp + election_e10_comp

xtabond2 tottax L.tottax election_e11_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e11_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r12

**lincom election_e11_opp + election_e11_comp

xtabond2 tottax L.tottax election_e12_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e12_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r13

**lincom election_e12_opp + election_e12_comp

xtabond2 tottax L.tottax election_e13_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e13_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r14

**lincom election_e13_opp + election_e13_comp

esttab  r1 r2 r3 r4 r5 r6 r7 r8 r9 r10 r11 r12 r13 r14/*
*/ using $PathEst/Maintables_20151010_tables.rtf, append cells(b(star fmt(4)) se(par fmt(4))) /*
*/ legend label varlabels(_cons Constant) stats(N N_g r2 , fmt(0 3))  /*
*/ title("Table 5b: Impact of Employing Alternative Definitions of Election Year – System-GMM, Competitive Elections") /*
*/ starlevels(* 0.10 ** 0.05 *** 0.01) modelwidth(4) varwidth(12) /*
*/ keep(L.tottax election_c_comp election_e1_comp election_e2_comp election_e3_comp election_e4_comp election_e5_comp election_e6_comp election_e7_comp election_e8_comp election_e9_comp election_e10_comp election_e11_comp election_e12_comp election_e13_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ order(L.tottax election_c_comp election_e1_comp election_e2_comp election_e3_comp election_e4_comp election_e5_comp election_e6_comp election_e7_comp election_e8_comp election_e9_comp election_e10_comp election_e11_comp election_e12_comp election_e13_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ mlabels("Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM")

***Table 6: Countries That Experienced Large Changes in Tax Collection Prior to Competitive Elections***

use $PathData/Prichard_ElectoralCycles_FINAL, clear
drop if incomegroup != 1 & incomegroup != 2 & incomegroup != 3

list country year tottax d.tottax election_e5_comp if (d.tottax>0.02 | d.tottax <(-.02)) & d.tottax != . & election_e5_comp ==1

use $PathData/Prichard_ElectoralCycles_FINAL, clear
drop if incomegroup != 1 & incomegroup != 2 & incomegroup != 3

list country year tottax d.tottax election_e5_comp election_e5_transition if (d.tottax>0.015 | d.tottax <(-.015)) & d.tottax != . & election_e5_comp ==1

*********************
*********************
***APPENDIX TABLES***
*********************
*********************

***********************************************************************************************************
***Table A1: Robustness Checks: Re-estimating “Free and Fair” Results With Alternative Election Datasets***
***********************************************************************************************************

use $PathData/Prichard_ElectoralCycles_FINAL, clear
drop if incomegroup != 1 & incomegroup != 2 & incomegroup != 3

***Eliminating any incongruities between nelda coding and coding in other elections datasets, in order to ensure that the sub-components are strictly a subset of contested elections***
replace election_e5_ff = 0 if election_e5_opp == 0
replace election_e5_fof = 0 if election_e5_opp == 0
replace election_e5_polity70 = 0 if election_e5_opp == 0
replace election_e5_nofraud_dpi = 0 if election_e5_opp == 0
replace election_e5_qedgood = 0 if election_e5_opp == 0
replace election_e5_qedok = 0 if election_e5_opp == 0

xtabond2 tottax L.tottax election_e5_opp election_e5_free lgdp agric imports civil_war totnontax inflationgdp growthpc yr1-yr31, gmm(L1.tottax election_e5_opp election_e5_free, collapse) ivstyle(lgdp agric imports civil_war totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r1

lincom election_e5_opp + election_e5_free

xtabond2 tottax L.tottax election_e5_opp election_e5_ff lgdp agric imports civil_war totnontax inflationgdp growthpc yr1-yr31, gmm(L1.tottax election_e5_opp election_e5_ff, collapse) ivstyle(lgdp agric imports civil_war totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r2

lincom election_e5_opp + election_e5_ff

xtabond2 tottax L.tottax election_e5_opp election_e5_fof lgdp agric imports civil_war totnontax inflationgdp growthpc yr1-yr31, gmm(L1.tottax election_e5_opp election_e5_fof, collapse) ivstyle(lgdp agric imports civil_war totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r3

lincom election_e5_opp + election_e5_fof

xtabond2 tottax L.tottax election_e5_opp election_e5_polity70 lgdp agric imports civil_war totnontax inflationgdp growthpc yr1-yr31, gmm(L1.tottax election_e5_opp election_e5_polity70, collapse) ivstyle(lgdp agric imports civil_war totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r4

lincom election_e5_opp + election_e5_polity70

xtabond2 tottax L.tottax election_e5_opp election_e5_nofraud_dpi lgdp agric imports civil_war totnontax inflationgdp growthpc yr1-yr31, gmm(L1.tottax election_e5_opp election_e5_nofraud_dpi, collapse) ivstyle(lgdp agric imports civil_war totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r5

lincom election_e5_opp + election_e5_nofraud_dpi

drop if year >2004

xtabond2 tottax L.tottax election_e5_opp election_e5_qedgood lgdp agric imports civil_war totnontax inflationgdp growthpc yr1-yr31, gmm(L1.tottax election_e5_opp election_e5_qedgood, collapse) ivstyle(lgdp agric imports civil_war totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r6

lincom election_e5_opp + election_e5_qedgood

xtabond2 tottax L.tottax election_e5_opp election_e5_qedok lgdp agric imports civil_war totnontax inflationgdp growthpc yr1-yr31, gmm(L1.tottax election_e5_opp election_e5_qedok, collapse) ivstyle(lgdp agric imports civil_war totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r7

lincom election_e5_opp + election_e5_qedok

esttab  r1 r2 r3 r4 r5 r6 r7/*
*/ using $PathEst/Appendixtables_2015_1010_tables.rtf, replace cells(b(star fmt(4)) se(par fmt(4))) /*
*/ legend label varlabels(_cons Constant) stats(N N_g r2 , fmt(0 3))  /*
*/ title("Table A1: Robustness Checks: Re-estimating “Free and Fair” Results With Alternative Election Datasets") /*
*/ starlevels(* 0.10 ** 0.05 *** 0.01) modelwidth(4) varwidth(12) /*
*/ keep(L.tottax election_e5_opp election_e5_free election_e5_ff election_e5_fof election_e5_polity70 election_e5_nofraud_dpi election_e5_qedgood election_e5_qedok lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ order (L.tottax election_e5_opp election_e5_free election_e5_ff election_e5_fof election_e5_polity70 election_e5_nofraud_dpi election_e5_qedgood election_e5_qedok lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ mlabels("Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM")

************************************************************************************************
***Table A2: Testing Robustness of Alternative Instrument Structures for System-GMM Estimates***
************************************************************************************************

use $PathData/Prichard_ElectoralCycles_FINAL, clear
drop if incomegroup != 1 & incomegroup != 2 & incomegroup != 3

***Most Exogenous, Simple Collapsed Instrument Matrix***

xtabond2 tottax L.tottax election_e5_opp election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e5_opp election_e5_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r1

lincom election_e5_opp + election_e5_comp

***Most Exogenous, Structured Lags following Ehrhart***

xtabond2 tottax L.tottax election_e5_opp election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e5_opp election_e5_comp, laglimits (1 3) collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r2

lincom election_e5_opp + election_e5_comp

***Most Exogenous, Structured Lags extended***

xtabond2 tottax L.tottax election_e5_opp election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e5_opp election_e5_comp, laglimits (1 5) collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r3

lincom election_e5_opp + election_e5_comp

***Most Endogenous, Simple Collapsed Instrument Matrix***

xtabond2 tottax L.tottax election_e5_opp election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e5_opp election_e5_comp lgdp imports inflationgdp growthpc totnontax, collapse) ivstyle(agric civil_war_hm growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r4

lincom election_e5_opp + election_e5_comp

***Most Endogenous, Structured Lags following Ehrhart***

xtabond2 tottax L.tottax election_e5_opp election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e5_opp election_e5_comp, laglimits(1 3) collapse) gmm(lgdp imports inflationgdp growthpc totnontax, laglimits(2 3) collapse) ivstyle(agric civil_war_hm growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r5

lincom election_e5_opp + election_e5_comp

***Most Endogenous, Structured Lags extended***

xtabond2 tottax L.tottax election_e5_opp election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e5_opp election_e5_comp,laglimits(1 5) collapse) gmm(lgdp imports inflationgdp growthpc totnontax, laglimits(2 5) collapse) ivstyle(agric civil_war_hm growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r6

lincom election_e5_opp + election_e5_comp

esttab  r1 r2 r3 r4 r5 r6/*
*/ using $PathEst/Appendixtables_2015_1010_tables.rtf, append cells(b(star fmt(4)) se(par fmt(4))) /*
*/ legend label varlabels(_cons Constant) stats(N N_g r2 , fmt(0 3))  /*
*/ title("Table A2: Robustness Checks: Alternative GMM Instrument Structures - Election_Opp") /*
*/ starlevels(* 0.10 ** 0.05 *** 0.01) modelwidth(4) varwidth(12) /*
*/ keep(election_e5_opp election_e5_comp imports civil_war_hm totnontax growthpc lgdp agric inflationgdp) /*
*/ order(election_e5_opp election_e5_comp imports civil_war_hm totnontax growthpc lgdp agric inflationgdp) /*
*/ mlabels("Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM")

*****************************************************************************
***Table A3: Testing Robustness to Employing a First-Differences Estimator***
*****************************************************************************

use $PathData/Prichard_ElectoralCycles_FINAL, clear

regress D.tottax election_e5 D.imports D.civil_war_hm D.totnontax growthpc D.inflationgdp, vce(cluster ccode)
est store r1

regress D.tottax election_e5_opp D.imports D.civil_war_hm D.totnontax growthpc D.inflationgdp, vce(cluster ccode)
est store r2

regress D.tottax election_e5_free D.imports D.civil_war_hm D.totnontax growthpc D.inflationgdp, vce(cluster ccode)
est store r3

regress D.tottax election_e5_first D.imports D.civil_war_hm D.totnontax growthpc D.inflationgdp, vce(cluster ccode)
est store r4

regress D.tottax election_e5_transition D.imports D.civil_war_hm D.totnontax growthpc D.inflationgdp, vce(cluster ccode)
est store r5

regress D.tottax election_e5_comp D.imports D.civil_war_hm D.totnontax growthpc D.inflationgdp, vce(cluster ccode)
est store r6

regress D.tottax election_e5_comp_trans D.imports D.civil_war_hm D.totnontax growthpc D.inflationgdp, vce(cluster ccode)
est store r7

regress D.tottax election_e5_comp_notrans D.imports D.civil_war_hm D.totnontax growthpc D.inflationgdp, vce(cluster ccode)
est store r8

regress D.tottax election_e5_trans_nocomp D.imports D.civil_war_hm D.totnontax growthpc D.inflationgdp, vce(cluster ccode)
est store r9

esttab  r1 r2 r3 r4 r5 r6 r7 r8 r9/*
*/ using $PathEst/Appendixtables_2015_1010_tables.rtf, append cells(b(star fmt(4)) se(par fmt(4))) /*
*/ legend label varlabels(_cons Constant) stats(N N_g r2 , fmt(0 3))  /*
*/ title("Table A3: Testing Robustness to Employing a First-Differences Estimator") /*
*/ starlevels(* 0.10 ** 0.05 *** 0.01) modelwidth(4) varwidth(12) /*
*/ keep(election_e5 election_e5_opp election_e5_free election_e5_first election_e5_transition election_e5_comp election_e5_comp_trans election_e5_comp_notrans election_e5_trans_nocomp D.imports D.civil_war_hm D.totnontax growthpc D.inflationgdp ) /*
*/ order(election_e5 election_e5_opp election_e5_free election_e5_first election_e5_transition election_e5_comp election_e5_comp_trans election_e5_comp_notrans election_e5_trans_nocomp D.imports D.civil_war_hm D.totnontax growthpc D.inflationgdp ) /*
*/ mlabels("FD" "FD" "FD" "FD" "FD" "FD" "FD" "FD" "FD")

***************************************************************************************************
***Table A4: Robustness Checks: Re-estimating Results Using Only Central Government Revenue Data***
***************************************************************************************************

use $PathData/Prichard_ElectoralCycles_FINAL, clear
drop if incomegroup != 1 & incomegroup != 2 & incomegroup != 3

xtabond2 tottax_cen L.tottax_cen election_e5 lgdp agric imports civil_war_hm totnontax_cen inflationgdp growthpc yr1-yr31, gmm(L1.tottax_cen election_e5, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax_cen inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r1

xtabond2 tottax_cen L.tottax_cen election_e5 election_e5_opp lgdp agric imports civil_war_hm totnontax_cen inflationgdp growthpc yr1-yr31, gmm(L1.tottax_cen election_e5 election_e5_opp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax_cen inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r2

lincom election_e5 + election_e5_opp

xtabond2 tottax_cen L.tottax_cen election_e5_opp election_e5_comp lgdp agric imports civil_war_hm totnontax_cen inflationgdp growthpc yr1-yr31, gmm(L1.tottax_cen election_e5_opp election_e5_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax_cen inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r3

lincom election_e5_opp + election_e5_comp

xtabond2 tottax_cen L.tottax_cen election_e5_opp election_e5_transition lgdp agric imports civil_war_hm totnontax_cen inflationgdp growthpc yr1-yr31, gmm(L1.tottax_cen election_e5_opp election_e5_transition, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax_cen inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r4

lincom election_e5_opp + election_e5_transition

xtreg tottax_cen L.tottax_cen election_e5 lgdp agric imports civil_war_hm totnontax_cen inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r5

xtreg tottax_cen L.tottax_cen election_e5 election_e5_opp lgdp agric imports civil_war_hm totnontax_cen inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r6

lincom election_e5 + election_e5_opp

xtreg tottax_cen L.tottax_cen election_e5_opp election_e5_comp lgdp agric imports civil_war_hm totnontax_cen inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r7

lincom election_e5_opp + election_e5_comp

xtreg tottax_cen L.tottax_cen election_e5_opp election_e5_transition lgdp agric imports civil_war_hm totnontax_cen inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r8

lincom election_e5_opp + election_e5_transition

esttab  r1 r2 r3 r4 r5 r6 r7 r8/*
*/ using $PathEst/Appendixtables_2015_1010_tables.rtf, append cells(b(star fmt(4)) se(par fmt(4))) /*
*/ legend label varlabels(_cons Constant) stats(N N_g r2 , fmt(0 3))  /*
*/ title("Table A4: Robustness Checks: Re-estimating Results Using Only Central Government Revenue Data") /*
*/ starlevels(* 0.10 ** 0.05 *** 0.01) modelwidth(4) varwidth(12) /*
*/ keep(L.tottax_cen election_e5 election_e5_opp election_e5_comp election_e5_transition) /*
*/ order(L.tottax_cen election_e5 election_e5_opp election_e5_comp election_e5_transition) /*
*/ mlabels("Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "FE" "FE" "FE" "FE") /*
***/ addnotes("All regression results include controls for lgdp, agric, imports, civil_war and tonontax_cen, though they are not reported in order to conserve space")

***Table A5: Testing Robustness to Altering the Time Period Covered by the Data – Fixed-Effects***

use $PathData/Prichard_ElectoralCycles_FINAL, clear
drop if incomegroup != 1 & incomegroup != 2 & incomegroup != 3

xtreg tottax L.tottax election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 if year<2009, vce(robust)fe i(ccode)
est store r1

xtreg tottax L.tottax election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 if year<2006, vce(robust)fe i(ccode)
est store r2

xtreg tottax L.tottax election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 if year<2003, vce(robust)fe i(ccode)
est store r3

xtreg tottax L.tottax election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 if year<2000, vce(robust)fe i(ccode)
est store r4

xtreg tottax L.tottax election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 if year<1997, vce(robust)fe i(ccode)
est store r5

xtreg tottax L.tottax election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 if year>1985, vce(robust)fe i(ccode)
est store r6

xtreg tottax L.tottax election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 if year>1988, vce(robust)fe i(ccode)
est store r7

xtreg tottax L.tottax election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 if year>1991, vce(robust)fe i(ccode)
est store r8

xtreg tottax L.tottax election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 if year>1994, vce(robust)fe i(ccode)
est store r9

xtreg tottax L.tottax election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 if year>1997, vce(robust)fe i(ccode)
est store r10

esttab  r1 r2 r3 r4 r5 r6 r7 r8 r9 r10/*
*/ using $PathEst/Appendixtables_2015_1010_tables.rtf, append cells(b(star fmt(4)) se(par fmt(4))) /*
*/ legend label varlabels(_cons Constant) stats(N N_g r2 , fmt(0 3))  /*
*/ title("Table A5: Testing Robustness to Altering the Time Period Covered by the Data – Fixed-Effects") /*
*/ starlevels(* 0.10 ** 0.05 *** 0.01) modelwidth(4) varwidth(12) /*
*/ keep(L.tottax election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ order(L.tottax election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ mlabels("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE")

***Table A6: Testing Robustness to Altering the Time Period Covered by the Data – Sys-GMM***

use $PathData/Prichard_ElectoralCycles_FINAL, clear
drop if incomegroup != 1 & incomegroup != 2 & incomegroup != 3

xtabond2 tottax L.tottax election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 if year<2009, gmm(L.tottax election_e5_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r1

xtabond2 tottax L.tottax election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 if year<2006, gmm(L.tottax election_e5_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r2

xtabond2 tottax L.tottax election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 if year<2003, gmm(L.tottax election_e5_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r3

xtabond2 tottax L.tottax election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 if year<2000, gmm(L.tottax election_e5_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r4

xtabond2 tottax L.tottax election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 if year<1997, gmm(L.tottax election_e5_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r5

xtabond2 tottax L.tottax election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 if year>1985, gmm(L.tottax election_e5_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r6

xtabond2 tottax L.tottax election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 if year>1988, gmm(L.tottax election_e5_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r7

xtabond2 tottax L.tottax election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 if year>1991, gmm(L.tottax election_e5_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r8

xtabond2 tottax L.tottax election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 if year>1994, gmm(L.tottax election_e5_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r9

xtabond2 tottax L.tottax election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 if year>1997, gmm(L.tottax election_e5_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r10

esttab  r1 r2 r3 r4 r5 r6 r7 r8 r9 r10/*
*/ using $PathEst/Appendixtables_2015_1010_tables.rtf, append cells(b(star fmt(4)) se(par fmt(4))) /*
*/ legend label varlabels(_cons Constant) stats(N N_g r2 , fmt(0 3))  /*
*/ title("Table A6: Testing Robustness to Altering the Time Period Covered by the Data – Sys-GMM") /*
*/ starlevels(* 0.10 ** 0.05 *** 0.01) modelwidth(4) varwidth(12) /*
*/ keep(L.tottax election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ order(L.tottax election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ mlabels("Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM")

**********************************************************
*********ALTERNATIVE DEFINITIONS OF ELECTION YEAR*********
**********************************************************

***Table A7: Impact of Employing Alternative Definitions of Election Year – Fixed Effects, Transition Elections***

use $PathData/Prichard_ElectoralCycles_FINAL, clear
drop if incomegroup != 1 & incomegroup != 2 & incomegroup != 3

xtreg tottax L.tottax election_c_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r1

xtreg tottax L.tottax election_e1_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r2

xtreg tottax L.tottax election_e2_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r3

xtreg tottax L.tottax election_e3_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r4

xtreg tottax L.tottax election_e4_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r5

xtreg tottax L.tottax election_e5_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r6

xtreg tottax L.tottax election_e6_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r7

xtreg tottax L.tottax election_e7_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r8

xtreg tottax L.tottax election_e8_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r9

xtreg tottax L.tottax election_e9_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r10

xtreg tottax L.tottax election_e10_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r11

xtreg tottax L.tottax election_e11_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r12

xtreg tottax L.tottax election_e12_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r13

xtreg tottax L.tottax election_e13_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r14

esttab  r1 r2 r3 r4 r5 r6 r7 r8 r9 r10 r11 r12 r13 r14/*
*/ using $PathEst/Appendixtables_2015_1010_tables.rtf, append cells(b(star fmt(4)) se(par fmt(4))) /*
*/ legend label varlabels(_cons Constant) stats(N N_g r2 , fmt(0 3))  /*
*/ title("Table A7: Impact of Employing Alternative Definitions of Election Year – Fixed Effects, Transition Elections") /*
*/ starlevels(* 0.10 ** 0.05 *** 0.01) modelwidth(4) varwidth(12) /*
*/ keep(L.tottax election_c_transition election_e1_transition election_e2_transition election_e3_transition election_e4_transition election_e5_transition election_e6_transition election_e7_transition election_e8_transition election_e9_transition election_e10_transition election_e11_transition election_e12_transition election_e13_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ order(L.tottax election_c_transition election_e1_transition election_e2_transition election_e3_transition election_e4_transition election_e5_transition election_e6_transition election_e7_transition election_e8_transition election_e9_transition election_e10_transition election_e11_transition election_e12_transition election_e13_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ mlabels("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE")

***Table A8: Impact of Employing Alternative Definitions of Election Year – System-GMM, Transition Elections***

use $PathData/Prichard_ElectoralCycles_FINAL, clear
drop if incomegroup != 1 & incomegroup != 2 & incomegroup != 3

xtabond2 tottax L.tottax election_c_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_c_transition, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r1

xtabond2 tottax L.tottax election_e1_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e1_transition, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r2

xtabond2 tottax L.tottax election_e2_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e2_transition, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r3

xtabond2 tottax L.tottax election_e3_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e3_transition, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r4

xtabond2 tottax L.tottax election_e4_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e4_transition, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r5

xtabond2 tottax L.tottax election_e5_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e5_transition, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r6

xtabond2 tottax L.tottax election_e6_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e6_transition, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r7

xtabond2 tottax L.tottax election_e7_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e7_transition, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r8

xtabond2 tottax L.tottax election_e8_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e8_transition, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r9

xtabond2 tottax L.tottax election_e9_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e9_transition, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r10

xtabond2 tottax L.tottax election_e10_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e10_transition, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r11

xtabond2 tottax L.tottax election_e11_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e11_transition, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r12

xtabond2 tottax L.tottax election_e12_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e12_transition, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r13

xtabond2 tottax L.tottax election_e13_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e13_transition, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r14

esttab  r1 r2 r3 r4 r5 r6 r7 r8 r9 r10 r11 r12 r13 r14/*
*/ using $PathEst/Appendixtables_2015_1010_tables.rtf, append cells(b(star fmt(4)) se(par fmt(4))) /*
*/ legend label varlabels(_cons Constant) stats(N N_g r2 , fmt(0 3))  /*
*/ title("Table A8: Impact of Employing Alternative Definitions of Election Year – System-GMM, Transition Elections") /*
*/ starlevels(* 0.10 ** 0.05 *** 0.01) modelwidth(4) varwidth(12) /*
*/ keep(L.tottax election_c_transition election_e1_transition election_e2_transition election_e3_transition election_e4_transition election_e5_transition election_e6_transition election_e7_transition election_e8_transition election_e9_transition election_e10_transition election_e11_transition election_e12_transition election_e13_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ order(L.tottax election_c_transition election_e1_transition election_e2_transition election_e3_transition election_e4_transition election_e5_transition election_e6_transition election_e7_transition election_e8_transition election_e9_transition election_e10_transition election_e11_transition election_e12_transition election_e13_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ mlabels("Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM")

***Table A9: Impact of Employing Alternative Definitions of Election Year – Fixed-Effects, Competitive and Transition Elections***

use $PathData/Prichard_ElectoralCycles_FINAL, clear
drop if incomegroup != 1 & incomegroup != 2 & incomegroup != 3

xtreg tottax L.tottax election_c_comp_trans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r1

xtreg tottax L.tottax election_e1_comp_trans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r2

xtreg tottax L.tottax election_e2_comp_trans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r3

xtreg tottax L.tottax election_e3_comp_trans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r4

xtreg tottax L.tottax election_e4_comp_trans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r5

xtreg tottax L.tottax election_e5_comp_trans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r6

xtreg tottax L.tottax election_e6_comp_trans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r7

xtreg tottax L.tottax election_e7_comp_trans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r8

xtreg tottax L.tottax election_e8_comp_trans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r9

xtreg tottax L.tottax election_e9_comp_trans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r10

xtreg tottax L.tottax election_e10_comp_trans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r11

xtreg tottax L.tottax election_e11_comp_trans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r12

xtreg tottax L.tottax election_e12_comp_trans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r13

xtreg tottax L.tottax election_e13_comp_trans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r14

esttab  r1 r2 r3 r4 r5 r6 r7 r8 r9 r10 r11 r12 r13 r14/*
*/ using $PathEst/Appendixtables_2015_1010_tables.rtf, append cells(b(star fmt(4)) se(par fmt(4))) /*
*/ legend label varlabels(_cons Constant) stats(N N_g r2 , fmt(0 3))  /*
*/ title("Table A9: Impact of Employing Alternative Definitions of Election Year – Fixed-Effects, Competitive and Transition Elections") /*
*/ starlevels(* 0.10 ** 0.05 *** 0.01) modelwidth(4) varwidth(12) /*
*/ keep(L.tottax election_c_comp_trans election_e1_comp_trans election_e2_comp_trans election_e3_comp_trans election_e4_comp_trans election_e5_comp_trans election_e6_comp_trans election_e7_comp_trans election_e8_comp_trans election_e9_comp_trans election_e10_comp_trans election_e11_comp_trans election_e12_comp_trans election_e13_comp_trans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ order(L.tottax election_c_comp_trans election_e1_comp_trans election_e2_comp_trans election_e3_comp_trans election_e4_comp_trans election_e5_comp_trans election_e6_comp_trans election_e7_comp_trans election_e8_comp_trans election_e9_comp_trans election_e10_comp_trans election_e11_comp_trans election_e12_comp_trans election_e13_comp_trans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ mlabels("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE")

***Table A10: Impact of Employing Alternative Definitions of Election Year – System-GMM, Competitive and Transition Elections***

use $PathData/Prichard_ElectoralCycles_FINAL, clear
drop if incomegroup != 1 & incomegroup != 2 & incomegroup != 3

xtabond2 tottax L.tottax election_c_comp_trans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_c_comp_trans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r1

xtabond2 tottax L.tottax election_e1_comp_trans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e1_comp_trans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r2

xtabond2 tottax L.tottax election_e2_comp_trans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e2_comp_trans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r3

xtabond2 tottax L.tottax election_e3_comp_trans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e3_comp_trans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r4

xtabond2 tottax L.tottax election_e4_comp_trans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e4_comp_trans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r5

xtabond2 tottax L.tottax election_e5_comp_trans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e5_comp_trans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r6

xtabond2 tottax L.tottax election_e6_comp_trans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e6_comp_trans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r7

xtabond2 tottax L.tottax election_e7_comp_trans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e7_comp_trans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r8

xtabond2 tottax L.tottax election_e8_comp_trans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e8_comp_trans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r9

xtabond2 tottax L.tottax election_e9_comp_trans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e9_comp_trans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r10

xtabond2 tottax L.tottax election_e10_comp_trans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e10_comp_trans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r11

xtabond2 tottax L.tottax election_e11_comp_trans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e11_comp_trans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r12

xtabond2 tottax L.tottax election_e12_comp_trans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e12_comp_trans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r13

xtabond2 tottax L.tottax election_e13_comp_trans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e13_comp_trans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r14

esttab  r1 r2 r3 r4 r5 r6 r7 r8 r9 r10 r11 r12 r13 r14/*
*/ using $PathEst/Appendixtables_2015_1010_tables.rtf, append cells(b(star fmt(4)) se(par fmt(4))) /*
*/ legend label varlabels(_cons Constant) stats(N N_g r2 , fmt(0 3))  /*
*/ title("Table A10: Impact of Employing Alternative Definitions of Election Year – System-GMM, Competitive and Transition Elections") /*
*/ starlevels(* 0.10 ** 0.05 *** 0.01) modelwidth(4) varwidth(12) /*
*/ keep(L.tottax election_c_comp_trans election_e1_comp_trans election_e2_comp_trans election_e3_comp_trans election_e4_comp_trans election_e5_comp_trans election_e6_comp_trans election_e7_comp_trans election_e8_comp_trans election_e9_comp_trans election_e10_comp_trans election_e11_comp_trans election_e12_comp_trans election_e13_comp_trans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ order(L.tottax election_c_comp_trans election_e1_comp_trans election_e2_comp_trans election_e3_comp_trans election_e4_comp_trans election_e5_comp_trans election_e6_comp_trans election_e7_comp_trans election_e8_comp_trans election_e9_comp_trans election_e10_comp_trans election_e11_comp_trans election_e12_comp_trans election_e13_comp_trans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ mlabels("Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM")


***Table A11: Impact of Employing Alternative Definitions of Election Year – Fixed-Effects, Competitive, No Transition***

use $PathData/Prichard_ElectoralCycles_FINAL, clear
drop if incomegroup != 1 & incomegroup != 2 & incomegroup != 3

xtreg tottax L.tottax election_c_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r1

xtreg tottax L.tottax election_e1_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r2

xtreg tottax L.tottax election_e2_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r3

xtreg tottax L.tottax election_e3_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r4

xtreg tottax L.tottax election_e4_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r5

xtreg tottax L.tottax election_e5_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r6

xtreg tottax L.tottax election_e6_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r7

xtreg tottax L.tottax election_e7_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r8

xtreg tottax L.tottax election_e8_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r9

xtreg tottax L.tottax election_e9_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r10

xtreg tottax L.tottax election_e10_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r11

xtreg tottax L.tottax election_e11_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r12

xtreg tottax L.tottax election_e12_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r13

xtreg tottax L.tottax election_e13_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r14

esttab  r1 r2 r3 r4 r5 r6 r7 r8 r9 r10 r11 r12 r13 r14/*
*/ using $PathEst/Appendixtables_2015_1010_tables.rtf, append cells(b(star fmt(4)) se(par fmt(4))) /*
*/ legend label varlabels(_cons Constant) stats(N N_g r2 , fmt(0 3))  /*
*/ title("Table A11: Impact of Employing Alternative Definitions of Election Year – Fixed-Effects, Competitive, No Transition") /*
*/ starlevels(* 0.10 ** 0.05 *** 0.01) modelwidth(4) varwidth(12) /*
*/ keep(L.tottax election_c_comp_notrans election_e1_comp_notrans election_e2_comp_notrans election_e3_comp_notrans election_e4_comp_notrans election_e5_comp_notrans election_e6_comp_notrans election_e7_comp_notrans election_e8_comp_notrans election_e9_comp_notrans election_e10_comp_notrans election_e11_comp_notrans election_e12_comp_notrans election_e13_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ order(L.tottax election_c_comp_notrans election_e1_comp_notrans election_e2_comp_notrans election_e3_comp_notrans election_e4_comp_notrans election_e5_comp_notrans election_e6_comp_notrans election_e7_comp_notrans election_e8_comp_notrans election_e9_comp_notrans election_e10_comp_notrans election_e11_comp_notrans election_e12_comp_notrans election_e13_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ mlabels("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE")

***Table A12: Impact of Employing Alternative Definitions of Election Year – System-GMM, Competitive, No Transition***

use $PathData/Prichard_ElectoralCycles_FINAL, clear
drop if incomegroup != 1 & incomegroup != 2 & incomegroup != 3

xtabond2 tottax L.tottax election_c_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_c_comp_notrans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r1

xtabond2 tottax L.tottax election_e1_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e1_comp_notrans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r2

xtabond2 tottax L.tottax election_e2_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e2_comp_notrans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r3

xtabond2 tottax L.tottax election_e3_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e3_comp_notrans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r4

xtabond2 tottax L.tottax election_e4_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e4_comp_notrans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r5

xtabond2 tottax L.tottax election_e5_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e5_comp_notrans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r6

xtabond2 tottax L.tottax election_e6_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e6_comp_notrans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r7

xtabond2 tottax L.tottax election_e7_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e7_comp_notrans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r8

xtabond2 tottax L.tottax election_e8_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e8_comp_notrans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r9

xtabond2 tottax L.tottax election_e9_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e9_comp_notrans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r10

xtabond2 tottax L.tottax election_e10_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e10_comp_notrans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r11

xtabond2 tottax L.tottax election_e11_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e11_comp_notrans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r12

xtabond2 tottax L.tottax election_e12_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e12_comp_notrans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r13

xtabond2 tottax L.tottax election_e13_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e13_comp_notrans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r14

esttab  r1 r2 r3 r4 r5 r6 r7 r8 r9 r10 r11 r12 r13 r14/*
*/ using $PathEst/Appendixtables_2015_1010_tables.rtf, append cells(b(star fmt(4)) se(par fmt(4))) /*
*/ legend label varlabels(_cons Constant) stats(N N_g r2 , fmt(0 3))  /*
*/ title("Table A12: Impact of Employing Alternative Definitions of Election Year – System-GMM, Competitive, No Transition") /*
*/ starlevels(* 0.10 ** 0.05 *** 0.01) modelwidth(4) varwidth(12) /*
*/ keep(L.tottax election_c_comp_notrans election_e1_comp_notrans election_e2_comp_notrans election_e3_comp_notrans election_e4_comp_notrans election_e5_comp_notrans election_e6_comp_notrans election_e7_comp_notrans election_e8_comp_notrans election_e9_comp_notrans election_e10_comp_notrans election_e11_comp_notrans election_e12_comp_notrans election_e13_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ order(L.tottax election_c_comp_notrans election_e1_comp_notrans election_e2_comp_notrans election_e3_comp_notrans election_e4_comp_notrans election_e5_comp_notrans election_e6_comp_notrans election_e7_comp_notrans election_e8_comp_notrans election_e9_comp_notrans election_e10_comp_notrans election_e11_comp_notrans election_e12_comp_notrans election_e13_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ mlabels("Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM")

***Table A13: Impact of Employing Alternative Definitions of Election Year – Fixed-Effects, Transition, Uncompetitive***

use $PathData/Prichard_ElectoralCycles_FINAL, clear
drop if incomegroup != 1 & incomegroup != 2 & incomegroup != 3

xtreg tottax L.tottax election_c_trans_nocomp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r1

xtreg tottax L.tottax election_e1_trans_nocomp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r2

xtreg tottax L.tottax election_e2_trans_nocomp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r3

xtreg tottax L.tottax election_e3_trans_nocomp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r4

xtreg tottax L.tottax election_e4_trans_nocomp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r5

xtreg tottax L.tottax election_e5_trans_nocomp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r6

xtreg tottax L.tottax election_e6_trans_nocomp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r7

xtreg tottax L.tottax election_e7_trans_nocomp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r8

xtreg tottax L.tottax election_e8_trans_nocomp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r9

xtreg tottax L.tottax election_e9_trans_nocomp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r10

xtreg tottax L.tottax election_e10_trans_nocomp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r11

xtreg tottax L.tottax election_e11_trans_nocomp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r12

xtreg tottax L.tottax election_e12_trans_nocomp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r13

xtreg tottax L.tottax election_e13_trans_nocomp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r14

esttab  r1 r2 r3 r4 r5 r6 r7 r8 r9 r10 r11 r12 r13 r14/*
*/ using $PathEst/Appendixtables_2015_1010_tables.rtf, append cells(b(star fmt(4)) se(par fmt(4))) /*
*/ legend label varlabels(_cons Constant) stats(N N_g r2 , fmt(0 3))  /*
*/ title("Table A13: Impact of Employing Alternative Definitions of Election Year – Fixed-Effects, Transition, Uncompetitive") /*
*/ starlevels(* 0.10 ** 0.05 *** 0.01) modelwidth(4) varwidth(12) /*
*/ keep(L.tottax election_c_trans_nocomp election_e1_trans_nocomp election_e2_trans_nocomp election_e3_trans_nocomp election_e4_trans_nocomp election_e5_trans_nocomp election_e6_trans_nocomp election_e7_trans_nocomp election_e8_trans_nocomp election_e9_trans_nocomp election_e10_trans_nocomp election_e11_trans_nocomp election_e12_trans_nocomp election_e13_trans_nocomp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ order(L.tottax election_c_trans_nocomp election_e1_trans_nocomp election_e2_trans_nocomp election_e3_trans_nocomp election_e4_trans_nocomp election_e5_trans_nocomp election_e6_trans_nocomp election_e7_trans_nocomp election_e8_trans_nocomp election_e9_trans_nocomp election_e10_trans_nocomp election_e11_trans_nocomp election_e12_trans_nocomp election_e13_trans_nocomp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ mlabels("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE")

***Table A14: Impact of Employing Alternative Definitions of Election Year – System-GMM, Transition, Uncompetitive***

use $PathData/Prichard_ElectoralCycles_FINAL, clear
drop if incomegroup != 1 & incomegroup != 2 & incomegroup != 3

xtabond2 tottax L.tottax election_c_trans_nocomp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_c_trans_nocomp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r1

xtabond2 tottax L.tottax election_e1_trans_nocomp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e1_trans_nocomp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r2

xtabond2 tottax L.tottax election_e2_trans_nocomp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e2_trans_nocomp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r3

xtabond2 tottax L.tottax election_e3_trans_nocomp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e3_trans_nocomp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r4

xtabond2 tottax L.tottax election_e4_trans_nocomp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e4_trans_nocomp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r5

xtabond2 tottax L.tottax election_e5_trans_nocomp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e5_trans_nocomp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r6

xtabond2 tottax L.tottax election_e6_trans_nocomp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e6_trans_nocomp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r7

xtabond2 tottax L.tottax election_e7_trans_nocomp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e7_trans_nocomp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r8

xtabond2 tottax L.tottax election_e8_trans_nocomp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e8_trans_nocomp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r9

xtabond2 tottax L.tottax election_e9_trans_nocomp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e9_trans_nocomp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r10

xtabond2 tottax L.tottax election_e10_trans_nocomp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e10_trans_nocomp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r11

xtabond2 tottax L.tottax election_e11_trans_nocomp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e11_trans_nocomp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r12

xtabond2 tottax L.tottax election_e12_trans_nocomp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e12_trans_nocomp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r13

xtabond2 tottax L.tottax election_e13_trans_nocomp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e13_trans_nocomp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r14

esttab  r1 r2 r3 r4 r5 r6 r7 r8 r9 r10 r11 r12 r13 r14/*
*/ using $PathEst/Appendixtables_2015_1010_tables.rtf, append cells(b(star fmt(4)) se(par fmt(4))) /*
*/ legend label varlabels(_cons Constant) stats(N N_g r2 , fmt(0 3))  /*
*/ title("Table A14: Impact of Employing Alternative Definitions of Election Year – System-GMM, Transition, Uncompetitive") /*
*/ starlevels(* 0.10 ** 0.05 *** 0.01) modelwidth(4) varwidth(12) /*
*/ keep(L.tottax election_c_trans_nocomp election_e1_trans_nocomp election_e2_trans_nocomp election_e3_trans_nocomp election_e4_trans_nocomp election_e5_trans_nocomp election_e6_trans_nocomp election_e7_trans_nocomp election_e8_trans_nocomp election_e9_trans_nocomp election_e10_trans_nocomp election_e11_trans_nocomp election_e12_trans_nocomp election_e13_trans_nocomp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ order(L.tottax election_c_trans_nocomp election_e1_trans_nocomp election_e2_trans_nocomp election_e3_trans_nocomp election_e4_trans_nocomp election_e5_trans_nocomp election_e6_trans_nocomp election_e7_trans_nocomp election_e8_trans_nocomp election_e9_trans_nocomp election_e10_trans_nocomp election_e11_trans_nocomp election_e12_trans_nocomp election_e13_trans_nocomp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ mlabels("Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM")

***Table A15: Robustness Checks: Re-estimating Key Results Using Same Year Definition of Elections***

use $PathData/Prichard_ElectoralCycles_FINAL, clear
drop if incomegroup != 1 & incomegroup != 2 & incomegroup != 3

xtabond2 tottax L.tottax election_c lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.tottax election_c, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r1

xtabond2 tottax L.tottax election_c election_c_opp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_c election_c_opp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r2

lincom election_c + election_c_opp

xtabond2 tottax L.tottax election_c_opp election_c_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_c_opp election_c_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r3

lincom election_c_opp + election_c_comp

xtabond2 tottax L.tottax election_c_opp election_c_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_c_opp election_c_transition, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r4

lincom election_c_opp + election_c_transition

xtabond2 tottax L.tottax election_c_opp election_c_comp_trans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_c_opp election_c_comp_trans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r5

lincom election_c_opp + election_c_comp_trans

xtabond2 tottax L.tottax election_c_opp election_c_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_c_opp election_c_comp_notrans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r6

lincom election_c_opp + election_c_comp_notrans

xtabond2 direct L.direct election_c lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.direct election_c, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r7

xtabond2 indirect L.indirect election_c lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.indirect election_c, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r8

xtabond2 direct L.direct election_c_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.direct election_c_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r9

xtabond2 indirect L.indirect election_c_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.indirect election_c_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r10

esttab  r1 r2 r3 r4 r5 r6 r7 r8 r9 r10/*
*/ using $PathEst/Appendixtables_2015_1010_tables.rtf, append cells(b(star fmt(4)) se(par fmt(4))) /*
*/ legend label varlabels(_cons Constant) stats(N N_g r2 , fmt(0 3))  /*
*/ title("Table A15: Robustness Checks: Re-estimating Key Results Using Same Year Definition of Elections") /*
*/ starlevels(* 0.10 ** 0.05 *** 0.01) modelwidth(4) varwidth(12) /*
*/ keep(L.tottax L.direct L.indirect election_c election_c_opp election_c_comp election_c_transition election_c_comp_trans election_c_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ order(L.tottax L.direct L.indirect election_c election_c_opp election_c_comp election_c_transition election_c_comp_trans election_c_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ mlabels("Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM")

**********************************************************************************************
***Table A16: Robustness Checks: Re-estimating Key Results Using E3 Definition of Elections***
**********************************************************************************************

use $PathData/Prichard_ElectoralCycles_FINAL, clear
drop if incomegroup != 1 & incomegroup != 2 & incomegroup != 3

xtabond2 tottax L.tottax election_e3 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.tottax election_e3, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r1

xtabond2 tottax L.tottax election_e3 election_e3_opp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e3 election_e3_opp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r2

lincom election_e3 + election_e3_opp

xtabond2 tottax L.tottax election_e3_opp election_e3_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e3_opp election_e3_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r3

lincom election_e3_opp + election_e3_comp

xtabond2 tottax L.tottax election_e3_opp election_e3_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e3_opp election_e3_transition, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r4

lincom election_e3_opp + election_e3_transition

xtabond2 tottax L.tottax election_e3_opp election_e3_comp_trans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e3_opp election_e3_comp_trans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r5

lincom election_e3_opp + election_e3_comp_trans

xtabond2 tottax L.tottax election_e3_opp election_e3_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e3_opp election_e3_comp_notrans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r6

lincom election_e3_opp + election_e3_comp_notrans

xtabond2 direct L.direct election_e3 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.direct election_e3, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r7

xtabond2 indirect L.indirect election_e3 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.indirect election_e3, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r8

xtabond2 direct L.direct election_e3_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.direct election_e3_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r9

xtabond2 indirect L.indirect election_e3_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.indirect election_e3_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r10

esttab  r1 r2 r3 r4 r5 r6 r7 r8 r9 r10/*
*/ using $PathEst/Appendixtables_2015_1010_tables.rtf, append cells(b(star fmt(4)) se(par fmt(4))) /*
*/ legend label varlabels(_cons Constant) stats(N N_g r2 , fmt(0 3))  /*
*/ title("Table A16: Robustness Checks: Re-estimating Key Results Using E3 Definition of Elections") /*
*/ starlevels(* 0.10 ** 0.05 *** 0.01) modelwidth(4) varwidth(12) /*
*/ keep(L.tottax L.direct L.indirect election_e3 election_e3_opp election_e3_comp election_e3_transition election_e3_comp_trans election_e3_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ order(L.tottax L.direct L.indirect election_e3 election_e3_opp election_e3_comp election_e3_transition election_e3_comp_trans election_e3_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ mlabels("Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM")

**********************************************************************************************
***Table A17: Robustness Checks: Re-estimating Key Results Using E4 Definition of Elections***
**********************************************************************************************

use $PathData/Prichard_ElectoralCycles_FINAL, clear
drop if incomegroup != 1 & incomegroup != 2 & incomegroup != 3

xtabond2 tottax L.tottax election_e4 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.tottax election_e4, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r1

xtabond2 tottax L.tottax election_e4 election_e4_opp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e4 election_e4_opp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r2

lincom election_e4 + election_e4_opp

xtabond2 tottax L.tottax election_e4_opp election_e4_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e4_opp election_e4_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r3

lincom election_e4_opp + election_e4_comp

xtabond2 tottax L.tottax election_e4_opp election_e4_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e4_opp election_e4_transition, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r4

lincom election_e4_opp + election_e4_transition

xtabond2 tottax L.tottax election_e4_opp election_e4_comp_trans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e4_opp election_e4_comp_trans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r5

lincom election_e4_opp + election_e4_comp_trans

xtabond2 tottax L.tottax election_e4_opp election_e4_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e4_opp election_e4_comp_notrans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r6

lincom election_e4_opp + election_e4_comp_notrans

xtabond2 direct L.direct election_e4 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.direct election_e4, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r7

xtabond2 indirect L.indirect election_e4 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.indirect election_e4, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r8

xtabond2 direct L.direct election_e4_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.direct election_e4_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r9

xtabond2 indirect L.indirect election_e4_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.indirect election_e4_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r10

esttab  r1 r2 r3 r4 r5 r6 r7 r8 r9 r10/*
*/ using $PathEst/Appendixtables_2015_1010_tables.rtf, append cells(b(star fmt(4)) se(par fmt(4))) /*
*/ legend label varlabels(_cons Constant) stats(N N_g r2 , fmt(0 3))  /*
*/ title("Table A17: Robustness Checks: Re-estimating Key Results Using E4 Definition of Elections") /*
*/ starlevels(* 0.10 ** 0.05 *** 0.01) modelwidth(4) varwidth(12) /*
*/ keep(L.tottax L.direct L.indirect election_e4 election_e4_opp election_e4_comp election_e4_transition election_e4_comp_trans election_e4_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ order(L.tottax L.direct L.indirect election_e4 election_e4_opp election_e4_comp election_e4_transition election_e4_comp_trans election_e4_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ mlabels("Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM")

**********************************************************************************************
***Table A18: Robustness Checks: Re-estimating Key Results Using E6 Definition of Elections***
**********************************************************************************************

use $PathData/Prichard_ElectoralCycles_FINAL, clear
drop if incomegroup != 1 & incomegroup != 2 & incomegroup != 3

xtabond2 tottax L.tottax election_e6 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.tottax election_e6, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r1

xtabond2 tottax L.tottax election_e6 election_e6_opp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e6 election_e6_opp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r2

lincom election_e6 + election_e6_opp

xtabond2 tottax L.tottax election_e6_opp election_e6_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e6_opp election_e6_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r3

lincom election_e6_opp + election_e6_comp

xtabond2 tottax L.tottax election_e6_opp election_e6_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e6_opp election_e6_transition, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r4

lincom election_e6_opp + election_e6_transition

xtabond2 tottax L.tottax election_e6_opp election_e6_comp_trans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e6_opp election_e6_comp_trans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r5

lincom election_e6_opp + election_e6_comp_trans

xtabond2 tottax L.tottax election_e6_opp election_e6_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e6_opp election_e6_comp_notrans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r6

lincom election_e6_opp + election_e6_comp_notrans

xtabond2 direct L.direct election_e6 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.direct election_e6, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r7

xtabond2 indirect L.indirect election_e6 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.indirect election_e6, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r8

xtabond2 direct L.direct election_e6_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.direct election_e6_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r9

xtabond2 indirect L.indirect election_e6_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.indirect election_e6_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r10

esttab  r1 r2 r3 r4 r5 r6 r7 r8 r9 r10/*
*/ using $PathEst/Appendixtables_2015_1010_tables.rtf, append cells(b(star fmt(4)) se(par fmt(4))) /*
*/ legend label varlabels(_cons Constant) stats(N N_g r2 , fmt(0 3))  /*
*/ title("Table A18: Robustness Checks: Re-estimating Key Results Using E6 Definition of Elections") /*
*/ starlevels(* 0.10 ** 0.05 *** 0.01) modelwidth(4) varwidth(12) /*
*/ keep(L.tottax L.direct L.indirect election_e6 election_e6_opp election_e6_comp election_e6_transition election_e6_comp_trans election_e6_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ order(L.tottax L.direct L.indirect election_e6 election_e6_opp election_e6_comp election_e6_transition election_e6_comp_trans election_e6_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ mlabels("Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM")

**********************************************************************************************
***Table A19: Robustness Checks: Re-estimating Key Results Using E7 Definition of Elections***
**********************************************************************************************

use $PathData/Prichard_ElectoralCycles_FINAL, clear
drop if incomegroup != 1 & incomegroup != 2 & incomegroup != 3

xtabond2 tottax L.tottax election_e7 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.tottax election_e7, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r1

xtabond2 tottax L.tottax election_e7 election_e7_opp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e7 election_e7_opp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r2

lincom election_e7 + election_e7_opp

xtabond2 tottax L.tottax election_e7_opp election_e7_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e7_opp election_e7_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r3

lincom election_e7_opp + election_e7_comp

xtabond2 tottax L.tottax election_e7_opp election_e7_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e7_opp election_e7_transition, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r4

lincom election_e7_opp + election_e7_transition

xtabond2 tottax L.tottax election_e7_opp election_e7_comp_trans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e7_opp election_e7_comp_trans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r5

lincom election_e7_opp + election_e7_comp_trans

xtabond2 tottax L.tottax election_e7_opp election_e7_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e7_opp election_e7_comp_notrans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r6

lincom election_e7_opp + election_e7_comp_notrans

xtabond2 direct L.direct election_e7 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.direct election_e7, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r7

xtabond2 indirect L.indirect election_e7 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.indirect election_e7, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r8

xtabond2 direct L.direct election_e7_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.direct election_e7_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r9

xtabond2 indirect L.indirect election_e7_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.indirect election_e7_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r10

esttab  r1 r2 r3 r4 r5 r6 r7 r8 r9 r10/*
*/ using $PathEst/Appendixtables_2015_1010_tables.rtf, append cells(b(star fmt(4)) se(par fmt(4))) /*
*/ legend label varlabels(_cons Constant) stats(N N_g r2 , fmt(0 3))  /*
*/ title("Table A19: Robustness Checks: Re-estimating Key Results Using E7 Definition of Elections") /*
*/ starlevels(* 0.10 ** 0.05 *** 0.01) modelwidth(4) varwidth(12) /*
*/ keep(L.tottax L.direct L.indirect election_e7 election_e7_opp election_e7_comp election_e7_transition election_e7_comp_trans election_e7_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ order(L.tottax L.direct L.indirect election_e7 election_e7_opp election_e7_comp election_e7_transition election_e7_comp_trans election_e7_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ mlabels("Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM")

**********************************************************************************************
***Table A20: Robustness Checks: Re-estimating Key Results Using E8 Definition of Elections***
**********************************************************************************************

use $PathData/Prichard_ElectoralCycles_FINAL, clear
drop if incomegroup != 1 & incomegroup != 2 & incomegroup != 3

xtabond2 tottax L.tottax election_e8 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.tottax election_e8, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r1

xtabond2 tottax L.tottax election_e8 election_e8_opp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e8 election_e8_opp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r2

lincom election_e8 + election_e8_opp

xtabond2 tottax L.tottax election_e8_opp election_e8_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e8_opp election_e8_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r3

lincom election_e8_opp + election_e8_comp

xtabond2 tottax L.tottax election_e8_opp election_e8_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e8_opp election_e8_transition, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r4

lincom election_e8_opp + election_e8_transition

xtabond2 tottax L.tottax election_e8_opp election_e8_comp_trans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e8_opp election_e8_comp_trans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r5

lincom election_e8_opp + election_e8_comp_trans

xtabond2 tottax L.tottax election_e8_opp election_e8_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e8_opp election_e8_comp_notrans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r6

lincom election_e8_opp + election_e8_comp_notrans

xtabond2 direct L.direct election_e8 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.direct election_e8, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r7

xtabond2 indirect L.indirect election_e8 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.indirect election_e8, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r8

xtabond2 direct L.direct election_e8_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.direct election_e8_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r9

xtabond2 indirect L.indirect election_e8_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.indirect election_e8_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r10

esttab  r1 r2 r3 r4 r5 r6 r7 r8 r9 r10/*
*/ using $PathEst/Appendixtables_2015_1010_tables.rtf, append cells(b(star fmt(4)) se(par fmt(4))) /*
*/ legend label varlabels(_cons Constant) stats(N N_g r2 , fmt(0 3))  /*
*/ title("Table A20: Robustness Checks: Re-estimating Key Results Using E8 Definition of Elections ") /*
*/ starlevels(* 0.10 ** 0.05 *** 0.01) modelwidth(4) varwidth(12) /*
*/ keep(L.tottax L.direct L.indirect election_e8 election_e8_opp election_e8_comp election_e8_transition election_e8_comp_trans election_e8_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ order(L.tottax L.direct L.indirect election_e8 election_e8_opp election_e8_comp election_e8_transition election_e8_comp_trans election_e8_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ mlabels("Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM")

*********************************************
**********DIFFERENT SAMPLES******************
*********************************************

***********************************************************************************************
***Table A21: Robustness Checks: Re-estimating Key Results Including All Countries – Sys-GMM***
***********************************************************************************************

use $PathData/Prichard_ElectoralCycles_FINAL, clear

xtabond2 tottax L.tottax election_e5 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.tottax election_e5, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r1

xtabond2 tottax L.tottax election_e5 election_e5_opp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e5 election_e5_opp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r2

lincom election_e5 + election_e5_opp

xtabond2 tottax L.tottax election_e5_opp election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e5_opp election_e5_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r3

lincom election_e5_opp + election_e5_comp

xtabond2 tottax L.tottax election_e5_opp election_e5_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e5_opp election_e5_transition, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r4

lincom election_e5_opp + election_e5_transition

xtabond2 tottax L.tottax election_e5_opp election_e5_comp_trans lgdp agric imports civil_war_hm totnontax yr1-yr31, gmm(L.tottax election_e5_opp election_e5_comp_trans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r5

lincom election_e5_opp + election_e5_comp_trans

xtabond2 tottax L.tottax election_e5_opp election_e5_comp_notrans lgdp agric imports civil_war_hm totnontax yr1-yr31, gmm(L.tottax election_e5_opp election_e5_comp_notrans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r6

lincom election_e5_opp + election_e5_comp_notrans

xtabond2 direct L.direct election_e5 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.direct election_e5, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r7

xtabond2 indirect L.indirect election_e5 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.indirect election_e5, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r8

xtabond2 direct L.direct election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.direct election_e5_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r9

xtabond2 indirect L.indirect election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.indirect election_e5_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r10

esttab  r1 r2 r3 r4 r5 r6 r7 r8 r9 r10/*
*/ using $PathEst/Appendixtables_2015_1010_tables.rtf, append cells(b(star fmt(4)) se(par fmt(4))) /*
*/ legend label varlabels(_cons Constant) stats(N N_g r2 , fmt(0 3))  /*
*/ title("Table A21: Robustness Checks: Re-estimating Key Results Including All Countries – Sys-GMM") /*
*/ starlevels(* 0.10 ** 0.05 *** 0.01) modelwidth(4) varwidth(12) /*
*/ keep(L.tottax L.direct L.indirect election_e5 election_e5_opp election_e5_comp election_e5_opp election_e5_comp election_e5_transition election_e5_comp_trans election_e5_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ order(L.tottax L.direct L.indirect election_e5 election_e5_opp election_e5_comp election_e5_opp election_e5_comp election_e5_transition election_e5_comp_trans election_e5_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ mlabels("Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" )

******************************************************************************************************
***Table A22: Robustness Checks: Re-estimating Key Results Including All Countries – Fixed-Effects ***
******************************************************************************************************

use $PathData/Prichard_ElectoralCycles_FINAL, clear

xtreg tottax L.tottax election_e5 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r1

xtreg tottax L.tottax election_e5 election_e5_opp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r2

lincom election_e5 + election_e5_opp

xtreg tottax L.tottax election_e5_opp election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r3

lincom election_e5_opp + election_e5_comp

xtreg tottax L.tottax election_e5_opp election_e5_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r4

lincom election_e5_opp + election_e5_transition

xtreg tottax L.tottax election_e5_opp election_e5_comp_trans lgdp agric imports civil_war_hm totnontax yr1-yr31, vce(robust)fe i(ccode)
est store r5

lincom election_e5_opp + election_e5_comp_trans

xtreg tottax L.tottax election_e5_opp election_e5_comp_notrans lgdp agric imports civil_war_hm totnontax yr1-yr31, vce(robust)fe i(ccode)
est store r6

lincom election_e5_opp + election_e5_comp_notrans

xtreg direct L.direct election_e5 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r7

xtreg indirect L.indirect election_e5 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r8

xtreg direct L.direct election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r9

xtreg indirect L.indirect election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r10

esttab  r1 r2 r3 r4 r5 r6 r7 r8 r9 r10 r11/*
*/ using $PathEst/Appendixtables_2015_1010_tables.rtf, append cells(b(star fmt(4)) se(par fmt(4))) /*
*/ legend label varlabels(_cons Constant) stats(N N_g r2 , fmt(0 3))  /*
*/ title("Table A22: Robustness Checks: Re-estimating Key Results Including All Countries – Fixed-Effects ") /*
*/ starlevels(* 0.10 ** 0.05 *** 0.01) modelwidth(4) varwidth(12) /*
*/ keep(L.tottax L.direct L.indirect election_e5 election_e5_opp election_e5_comp election_e5_transition election_e5_comp_trans election_e5_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ order(L.tottax L.direct L.indirect election_e5 election_e5_opp election_e5_comp election_e5_transition election_e5_comp_trans election_e5_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ mlabels("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE")

************************************************************************************************************
***Table A23: Robustness Checks: Re-estimating Key Results Including All Non-Resource Countries – Sys-GMM***
************************************************************************************************************

use $PathData/Prichard_ElectoralCycles_FINAL, clear
drop if resource_rich == 1

xtabond2 tottax L.tottax election_e5 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.tottax election_e5, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r1

xtabond2 tottax L.tottax election_e5 election_e5_opp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e5 election_e5_opp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r2

lincom election_e5 + election_e5_opp

xtabond2 tottax L.tottax election_e5_opp election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e5_opp election_e5_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r3

lincom election_e5_opp + election_e5_comp

xtabond2 tottax L.tottax election_e5_opp election_e5_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e5_opp election_e5_transition, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r4

lincom election_e5_opp + election_e5_transition

xtabond2 tottax L.tottax election_e5_opp election_e5_comp_trans lgdp agric imports civil_war_hm totnontax yr1-yr31, gmm(L.tottax election_e5_opp election_e5_comp_trans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r5

lincom election_e5_opp + election_e5_comp_trans

xtabond2 tottax L.tottax election_e5_opp election_e5_comp_notrans lgdp agric imports civil_war_hm totnontax yr1-yr31, gmm(L.tottax election_e5_opp election_e5_comp_notrans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r6

lincom election_e5_opp + election_e5_comp_notrans

xtabond2 direct L.direct election_e5 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.direct election_e5, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r7

xtabond2 indirect L.indirect election_e5 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.indirect election_e5, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r8

xtabond2 direct L.direct election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.direct election_e5_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r9

xtabond2 indirect L.indirect election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.indirect election_e5_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r10

esttab  r1 r2 r3 r4 r5 r6 r7 r8 r9 r10 /*
*/ using $PathEst/Appendixtables_2015_1010_tables.rtf, append cells(b(star fmt(4)) se(par fmt(4))) /*
*/ legend label varlabels(_cons Constant) stats(N N_g r2 , fmt(0 3))  /*
*/ title("Table A23: Robustness Checks: Re-estimating Key Results Including All Non-Resource Countries – Sys-GMM") /*
*/ starlevels(* 0.10 ** 0.05 *** 0.01) modelwidth(4) varwidth(12) /*
*/ keep(L.tottax L.direct L.indirect election_e5 election_e5_opp election_e5_comp election_e5_opp election_e5_comp election_e5_transition election_e5_comp_trans election_e5_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ order(L.tottax L.direct L.indirect election_e5 election_e5_opp election_e5_comp election_e5_opp election_e5_comp election_e5_transition election_e5_comp_trans election_e5_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ mlabels("Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" )

******************************************************************************************************************
***Table A24: Robustness Checks: Re-estimating Key Results Including All Non-Resource Countries – Fixed-Effects***
******************************************************************************************************************

use $PathData/Prichard_ElectoralCycles_FINAL, clear
drop if resource_rich == 1

xtreg tottax L.tottax election_e5 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r1

xtreg tottax L.tottax election_e5 election_e5_opp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r2

lincom election_e5 + election_e5_opp

xtreg tottax L.tottax election_e5_opp election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r3

lincom election_e5_opp + election_e5_comp

xtreg tottax L.tottax election_e5_opp election_e5_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r4

lincom election_e5_opp + election_e5_transition

xtreg tottax L.tottax election_e5_opp election_e5_comp_trans lgdp agric imports civil_war_hm totnontax yr1-yr31, vce(robust)fe i(ccode)
est store r5

lincom election_e5_opp + election_e5_comp_trans

xtreg tottax L.tottax election_e5_opp election_e5_comp_notrans lgdp agric imports civil_war_hm totnontax yr1-yr31, vce(robust)fe i(ccode)
est store r6

lincom election_e5_opp + election_e5_comp_notrans

xtreg direct L.direct election_e5 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r7

xtreg indirect L.indirect election_e5 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r8

xtreg direct L.direct election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r9

xtreg indirect L.indirect election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r10

esttab  r1 r2 r3 r4 r5 r6 r7 r8 r9 r10 r11/*
*/ using $PathEst/Appendixtables_2015_1010_tables.rtf, append cells(b(star fmt(4)) se(par fmt(4))) /*
*/ legend label varlabels(_cons Constant) stats(N N_g r2 , fmt(0 3))  /*
*/ title("Table A24: Robustness Checks: Re-estimating Key Results Including All Non-Resource Countries – Fixed-Effects") /*
*/ starlevels(* 0.10 ** 0.05 *** 0.01) modelwidth(4) varwidth(12) /*
*/ keep(L.tottax L.direct L.indirect election_e5 election_e5_opp election_e5_comp election_e5_transition election_e5_comp_trans election_e5_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ order(L.tottax L.direct L.indirect election_e5 election_e5_opp election_e5_comp election_e5_transition election_e5_comp_trans election_e5_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ mlabels("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE")

***********************************************************************************************************************
***Table A25: Robustness Checks: Re-estimating Key Results Including All Non-Resource Developing Countries – Sys-GMM***
***********************************************************************************************************************

use $PathData/Prichard_ElectoralCycles_FINAL, clear
drop if incomegroup !=1 & incomegroup != 2 & incomegroup != 3
drop if resource_rich == 1

xtabond2 tottax L.tottax election_e5 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.tottax election_e5, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r1

xtabond2 tottax L.tottax election_e5 election_e5_opp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e5 election_e5_opp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r2

lincom election_e5 + election_e5_opp

xtabond2 tottax L.tottax election_e5_opp election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e5_opp election_e5_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r3

lincom election_e5_opp + election_e5_comp

xtabond2 tottax L.tottax election_e5_opp election_e5_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e5_opp election_e5_transition, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r4

lincom election_e5_opp + election_e5_transition

xtabond2 tottax L.tottax election_e5_opp election_e5_comp_trans lgdp agric imports civil_war_hm totnontax yr1-yr31, gmm(L.tottax election_e5_opp election_e5_comp_trans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r5

lincom election_e5_opp + election_e5_comp_trans

xtabond2 tottax L.tottax election_e5_opp election_e5_comp_notrans lgdp agric imports civil_war_hm totnontax yr1-yr31, gmm(L.tottax election_e5_opp election_e5_comp_notrans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r6

lincom election_e5_opp + election_e5_comp_notrans

xtabond2 direct L.direct election_e5 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.direct election_e5, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r7

xtabond2 indirect L.indirect election_e5 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.indirect election_e5, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r8

xtabond2 direct L.direct election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.direct election_e5_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r9

xtabond2 indirect L.indirect election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.indirect election_e5_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r10

esttab  r1 r2 r3 r4 r5 r6 r7 r8 r9 r10/*
*/ using $PathEst/Appendixtables_2015_1010_tables.rtf, append cells(b(star fmt(4)) se(par fmt(4))) /*
*/ legend label varlabels(_cons Constant) stats(N N_g r2 , fmt(0 3))  /*
*/ title("Table A25: Robustness Checks: Re-estimating Key Results Including All Non-Resource Developing Countries – Sys-GMM") /*
*/ starlevels(* 0.10 ** 0.05 *** 0.01) modelwidth(4) varwidth(12) /*
*/ keep(L.tottax L.direct L.indirect election_e5 election_e5_opp election_e5_comp election_e5_opp election_e5_comp election_e5_transition election_e5_comp_trans election_e5_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ order(L.tottax L.direct L.indirect election_e5 election_e5_opp election_e5_comp election_e5_opp election_e5_comp election_e5_transition election_e5_comp_trans election_e5_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ mlabels("Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" )

*****************************************************************************************************************************
***Table A26: Robustness Checks: Re-estimating Key Results Including All Non-Resource Developing Countries – Fixed Effects***
*****************************************************************************************************************************

use $PathData/Prichard_ElectoralCycles_FINAL, clear
drop if incomegroup !=1 & incomegroup != 2 

xtreg tottax L.tottax election_e5 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r1

xtreg tottax L.tottax election_e5 election_e5_opp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r2

lincom election_e5 + election_e5_opp

xtreg tottax L.tottax election_e5_opp election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r3

lincom election_e5_opp + election_e5_comp

xtreg tottax L.tottax election_e5_opp election_e5_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r4

lincom election_e5_opp + election_e5_transition

xtreg tottax L.tottax election_e5_opp election_e5_comp_trans lgdp agric imports civil_war_hm totnontax yr1-yr31, vce(robust)fe i(ccode)
est store r5

lincom election_e5_opp + election_e5_comp_trans

xtreg tottax L.tottax election_e5_opp election_e5_comp_notrans lgdp agric imports civil_war_hm totnontax yr1-yr31, vce(robust)fe i(ccode)
est store r6

lincom election_e5_opp + election_e5_comp_notrans

xtreg direct L.direct election_e5 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r7

xtreg indirect L.indirect election_e5 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r8

xtreg direct L.direct election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r9

xtreg indirect L.indirect election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r10

esttab  r1 r2 r3 r4 r5 r6 r7 r8 r9 r10 r11/*
*/ using $PathEst/Appendixtables_2015_1010_tables.rtf, append cells(b(star fmt(4)) se(par fmt(4))) /*
*/ legend label varlabels(_cons Constant) stats(N N_g r2 , fmt(0 3))  /*
*/ title("Table A26: Robustness Checks: Re-estimating Key Results Including All Non-Resource Developing Countries – Fixed Effects") /*
*/ starlevels(* 0.10 ** 0.05 *** 0.01) modelwidth(4) varwidth(12) /*
*/ keep(L.tottax L.direct L.indirect election_e5 election_e5_opp election_e5_comp election_e5_transition election_e5_comp_trans election_e5_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ order(L.tottax L.direct L.indirect election_e5 election_e5_opp election_e5_comp election_e5_transition election_e5_comp_trans election_e5_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ mlabels("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE")

**********************************************************************************************************
***Table A27: Robustness Checks: Re-estimating Key Results Including All Low-Income Countries – Sys-GMM***
**********************************************************************************************************

use $PathData/Prichard_ElectoralCycles_FINAL, clear
drop if incomegroup !=1 & incomegroup != 2 

xtabond2 tottax L.tottax election_e5 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.tottax election_e5, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r1

xtabond2 tottax L.tottax election_e5 election_e5_opp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e5 election_e5_opp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r2

lincom election_e5 + election_e5_opp

xtabond2 tottax L.tottax election_e5_opp election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e5_opp election_e5_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r3

lincom election_e5_opp + election_e5_comp

xtabond2 tottax L.tottax election_e5_opp election_e5_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L.tottax election_e5_opp election_e5_transition, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r4

lincom election_e5_opp + election_e5_transition

xtabond2 tottax L.tottax election_e5_opp election_e5_comp_trans lgdp agric imports civil_war_hm totnontax yr1-yr31, gmm(L.tottax election_e5_opp election_e5_comp_trans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r5

lincom election_e5_opp + election_e5_comp_trans

xtabond2 tottax L.tottax election_e5_opp election_e5_comp_notrans lgdp agric imports civil_war_hm totnontax yr1-yr31, gmm(L.tottax election_e5_opp election_e5_comp_notrans, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax yr1-yr31) nodiffsargan twostep robust orthogonal 
est store r6

lincom election_e5_opp + election_e5_comp_notrans

xtabond2 direct L.direct election_e5 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.direct election_e5, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r7

xtabond2 indirect L.indirect election_e5 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.indirect election_e5, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r8

xtabond2 direct L.direct election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.direct election_e5_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r9

xtabond2 indirect L.indirect election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, gmm(L1.indirect election_e5_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31) nodiffsargan  twostep robust orthogonal 
est store r10

esttab  r1 r2 r3 r4 r5 r6 r7 r8 r9 r10/*
*/ using $PathEst/Appendixtables_2015_1010_tables.rtf, append cells(b(star fmt(4)) se(par fmt(4))) /*
*/ legend label varlabels(_cons Constant) stats(N N_g r2 , fmt(0 3))  /*
*/ title("Table A27: Robustness Checks: Re-estimating Key Results Including All Low-Income Countries – Sys-GMM") /*
*/ starlevels(* 0.10 ** 0.05 *** 0.01) modelwidth(4) varwidth(12) /*
*/ keep(L.tottax L.direct L.indirect election_e5 election_e5_opp election_e5_comp election_e5_opp election_e5_comp election_e5_transition election_e5_comp_trans election_e5_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ order(L.tottax L.direct L.indirect election_e5 election_e5_opp election_e5_comp election_e5_opp election_e5_comp election_e5_transition election_e5_comp_trans election_e5_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ mlabels("Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM" "Sys-GMM")

****************************************************************************************************************
***Table A28: Robustness Checks: Re-estimating Key Results Including All Low-Income Countries – Fixed-Effects***
****************************************************************************************************************

use $PathData/Prichard_ElectoralCycles_FINAL, clear
drop if incomegroup !=1 & incomegroup != 2 

xtreg tottax L.tottax election_e5 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r1

xtreg tottax L.tottax election_e5 election_e5_opp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r2

lincom election_e5 + election_e5_opp

xtreg tottax L.tottax election_e5_opp election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r3

lincom election_e5_opp + election_e5_comp

xtreg tottax L.tottax election_e5_opp election_e5_transition lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r4

lincom election_e5_opp + election_e5_transition

xtreg tottax L.tottax election_e5_opp election_e5_comp_trans lgdp agric imports civil_war_hm totnontax yr1-yr31, vce(robust)fe i(ccode)
est store r5

lincom election_e5_opp + election_e5_comp_trans

xtreg tottax L.tottax election_e5_opp election_e5_comp_notrans lgdp agric imports civil_war_hm totnontax yr1-yr31, vce(robust)fe i(ccode)
est store r6

lincom election_e5_opp + election_e5_comp_notrans

xtreg direct L.direct election_e5 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r7

xtreg indirect L.indirect election_e5 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r8

xtreg direct L.direct election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r9

xtreg indirect L.indirect election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r10

esttab  r1 r2 r3 r4 r5 r6 r7 r8 r9 r10 r11/*
*/ using $PathEst/Appendixtables_2015_1010_tables.rtf, append cells(b(star fmt(4)) se(par fmt(4))) /*
*/ legend label varlabels(_cons Constant) stats(N N_g r2 , fmt(0 3))  /*
*/ title("Table A28: Robustness Checks: Re-estimating Key Results Including All Low-Income Countries – Fixed-Effects") /*
*/ starlevels(* 0.10 ** 0.05 *** 0.01) modelwidth(4) varwidth(12) /*
*/ keep(L.tottax L.direct L.indirect election_e5 election_e5_opp election_e5_comp election_e5_transition election_e5_comp_trans election_e5_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ order(L.tottax L.direct L.indirect election_e5 election_e5_opp election_e5_comp election_e5_transition election_e5_comp_trans election_e5_comp_notrans lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ mlabels("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE")

**************************************************************************************************************
***Table A29: Robustness Checks: Re-estimating Key Results Distinguishing Between Old and Young Democracies***
**************************************************************************************************************

use $PathData/Prichard_ElectoralCycles_FINAL, clear
drop if incomegroup != 1 & incomegroup != 2 & incomegroup != 3

gen demage = 0
replace demage = time if regime == 1

gen election_e5_opp_young = 0
replace election_e5_opp_young = 1 if election_e5_opp == 1 & demage<10
gen election_e5_opp_old = 0
replace election_e5_opp_old = 1 if election_e5_opp == 1 & demage>=10

xtreg tottax L.tottax election_e5_opp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 region1 region2 region3 region4 region5 region6, vce(robust)fe i(ccode)
xtreg tottax L.tottax election_e5_opp_young lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 region1 region2 region3 region4 region5 region6, vce(robust)fe i(ccode)
xtreg tottax L.tottax election_e5_opp_old lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 region1 region2 region3 region4 region5 region6, vce(robust)fe i(ccode)

xtabond2 tottax L.tottax election_e5_opp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 region1 region2 region3 region4 region5 region6, gmm(L.tottax election_e5_opp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 region1 region2 region3 region4 region5 region6) nodiffsargan twostep robust orthogonal
xtabond2 tottax L.tottax election_e5_opp_young lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 region1 region2 region3 region4 region5 region6, gmm(L.tottax election_e5_opp_young, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 region1 region2 region3 region4 region5 region6) nodiffsargan twostep robust orthogonal
xtabond2 tottax L.tottax election_e5_opp_old lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 region1 region2 region3 region4 region5 region6, gmm(L.tottax election_e5_opp_old, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 region1 region2 region3 region4 region5 region6) nodiffsargan twostep robust orthogonal

gen election_e5_comp_young = 0
replace election_e5_comp_young = 1 if election_e5_comp == 1 & demage<10
gen election_e5_comp_old = 0
replace election_e5_comp_old = 1 if election_e5_comp == 1 & demage>=10

summarize election_e5_comp
summarize election_e5_comp_old
summarize election_e5_comp_young

***There are 92 competitive elections that occured in young democracies, 69 that occured in old democracies****
***The effect of competitive elections is effectively limited to young democracies*

xtreg tottax L.tottax election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 , vce(robust)fe i(ccode)
est store r1

xtreg tottax L.tottax election_e5_comp_young lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 , vce(robust)fe i(ccode)
est store r2

xtreg tottax L.tottax election_e5_comp_old lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 , vce(robust)fe i(ccode)
est store r3

xtabond2 tottax L.tottax election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 region1 region2 region3 region4 region5 region6, gmm(L.tottax election_e5_comp, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 region1 region2 region3 region4 region5 region6) nodiffsargan twostep robust orthogonal
est store r4

xtabond2 tottax L.tottax election_e5_comp_young lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 region1 region2 region3 region4 region5 region6, gmm(L.tottax election_e5_comp_young, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 region1 region2 region3 region4 region5 region6) nodiffsargan twostep robust orthogonal
est store r5

xtabond2 tottax L.tottax election_e5_comp_old lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 region1 region2 region3 region4 region5 region6, gmm(L.tottax election_e5_comp_old, collapse) ivstyle(lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31 region1 region2 region3 region4 region5 region6) nodiffsargan twostep robust orthogonal
est store r6

esttab  r1 r2 r3 r4 r5 r6 /*
*/ using $PathEst/Appendixtables_2015_1010_tables.rtf, append cells(b(star fmt(4)) se(par fmt(4))) /*
*/ legend label varlabels(_cons Constant) stats(N N_g r2 , fmt(0 3))  /*
*/ title("Table A29: Robustness Checks: Re-estimating Key Results Distinguishing Between Old and Young Democracies") /*
*/ starlevels(* 0.10 ** 0.05 *** 0.01) modelwidth(4) varwidth(12) /*
*/ keep(L.tottax election_e5_comp election_e5_comp_young election_e5_comp_old lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ order(L.tottax election_e5_comp election_e5_comp_young election_e5_comp_old lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ mlabels("FE" "FE" "FE" "Sys-GMM" "Sys-GMM" "Sys-GMM")

********************************************************************************************************
***Table A30: Impact of Competitive Elections in Lower-Income Countries – Fixed-Effects, Using Comp50***
********************************************************************************************************

use $PathData/Prichard_ElectoralCycles_FINAL, clear
drop if incomegroup !=1 & incomegroup != 2 

xtreg tottax L.tottax election_c_comp50 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r1

xtreg tottax L.tottax election_e1_comp50 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r2

xtreg tottax L.tottax election_e2_comp50 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r3

xtreg tottax L.tottax election_e3_comp50 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r4

xtreg tottax L.tottax election_e4_comp50 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r5

xtreg tottax L.tottax election_e5_comp50 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r6

xtreg tottax L.tottax election_e6_comp50 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r7

xtreg tottax L.tottax election_e7_comp50 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r8

xtreg tottax L.tottax election_e8_comp50 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r9

xtreg tottax L.tottax election_e9_comp50 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r10

xtreg tottax L.tottax election_e10_comp50 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r11

xtreg tottax L.tottax election_e11_comp50 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r12

xtreg tottax L.tottax election_e12_comp50 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r13

xtreg tottax L.tottax election_e13_comp50 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r14

esttab  r1 r2 r3 r4 r5 r6 r7 r8 r9 r10 r11 r12 r13 r14/*
*/ using $PathEst/Appendixtables_2015_1010_tables.rtf, append cells(b(star fmt(4)) se(par fmt(4))) /*
*/ legend label varlabels(_cons Constant) stats(N N_g r2 , fmt(0 3))  /*
*/ title("Table A30: Impact of Competitive Elections in Lower-Income Countries – Fixed-Effects, Using Comp50") /*
*/ starlevels(* 0.10 ** 0.05 *** 0.01) modelwidth(4) varwidth(12) /*
*/ keep(L.tottax election_c_comp50 election_e1_comp50 election_e2_comp50 election_e3_comp50 election_e4_comp50 election_e5_comp50 election_e6_comp50 election_e7_comp50 election_e8_comp50 election_e9_comp50 election_e10_comp50 election_e11_comp50 election_e12_comp50 election_e13_comp50 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ order(L.tottax election_c_comp50 election_e1_comp50 election_e2_comp50 election_e3_comp50 election_e4_comp50 election_e5_comp50 election_e6_comp50 election_e7_comp50 election_e8_comp50 election_e9_comp50 election_e10_comp50 election_e11_comp50 election_e12_comp50 election_e13_comp50 lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ mlabels("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE")

***Table A31: Impact of Competitive Elections in Lower-Income Countries Using Alternative Election Years – Fixed-Effects***

use $PathData/Prichard_ElectoralCycles_FINAL, clear
drop if incomegroup != 1 & incomegroup != 2

xtreg tottax L.tottax election_c_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r1

xtreg tottax L.tottax election_e1_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r2

xtreg tottax L.tottax election_e2_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r3

xtreg tottax L.tottax election_e3_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r4

xtreg tottax L.tottax election_e4_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r5

xtreg tottax L.tottax election_e5_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r6

xtreg tottax L.tottax election_e6_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r7

xtreg tottax L.tottax election_e7_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r8

xtreg tottax L.tottax election_e8_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r9

xtreg tottax L.tottax election_e9_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r10

xtreg tottax L.tottax election_e10_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r11

xtreg tottax L.tottax election_e11_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r12

xtreg tottax L.tottax election_e12_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r13

xtreg tottax L.tottax election_e13_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc yr1-yr31, vce(robust)fe i(ccode)
est store r14

esttab  r1 r2 r3 r4 r5 r6 r7 r8 r9 r10 r11 r12 r13 r14/*
*/ using $PathEst/Appendixtables_2015_1010_tables.rtf, append cells(b(star fmt(4)) se(par fmt(4))) /*
*/ legend label varlabels(_cons Constant) stats(N N_g r2 , fmt(0 3))  /*
*/ title("Table A31: Impact of Competitive Elections in Lower-Income Countries Using Alternative Election Years – Fixed-Effects") /*
*/ starlevels(* 0.10 ** 0.05 *** 0.01) modelwidth(4) varwidth(12) /*
*/ keep(L.tottax election_c_comp election_e1_comp election_e2_comp election_e3_comp election_e4_comp election_e5_comp election_e6_comp election_e7_comp election_e8_comp election_e9_comp election_e10_comp election_e11_comp election_e12_comp election_e13_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ order(L.tottax election_c_comp election_e1_comp election_e2_comp election_e3_comp election_e4_comp election_e5_comp election_e6_comp election_e7_comp election_e8_comp election_e9_comp election_e10_comp election_e11_comp election_e12_comp election_e13_comp lgdp agric imports civil_war_hm totnontax inflationgdp growthpc) /*
*/ mlabels("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE")

******************************************************************
***Table A32: Robustness Checks: Excluding Extreme Observations***
******************************************************************

use $PathData/Prichard_ElectoralCycles_FINAL, clear
drop if incomegroup != 1 & incomegroup != 2 & incomegroup != 3

drop if country == "Belarus" | country == "Moldova" | country == "Mauritania" | country == "Nicaragua" | country == "Peru" | country == "Romania" | country == "Ukraine"
drop if country == "Bosnia and Herzegovina" | country == "Lebanon" | country == "Malawi" | country == "Congo, Dem. Rep."

xtreg tottax L.tottax election_e5_opp election_e5_comp lgdp agric imports civil_war_hm totnontax growthpc inflationgdp yr1-yr31 , vce(robust)fe i(ccode)
est store r1

lincom election_e5_opp + election_e5_comp

xtreg tottax L.tottax election_e5_opp election_e5_comp50 lgdp agric imports civil_war_hm totnontax growthpc inflationgdp yr1-yr31 , vce(robust)fe i(ccode)
est store r2

lincom election_e5_opp + election_e5_comp50

xtreg tottax L.tottax election_e6_opp election_e6_comp lgdp agric imports civil_war_hm totnontax growthpc inflationgdp yr1-yr31 , vce(robust)fe i(ccode)
est store r3

lincom election_e6_opp + election_e6_comp

xtreg tottax L.tottax election_e6_opp election_e6_comp50 lgdp agric imports civil_war_hm totnontax growthpc inflationgdp yr1-yr31 , vce(robust)fe i(ccode)
est store r4

lincom election_e6_opp + election_e6_comp50

drop if country == "Argentina" | country == "Costa Rica" | country == "Dominican Republic" | country == "Honduras" | country == "Madagascar" | country == "Mozambique" | country == "El Salvador"
drop if country == "Azerbaijan" | country == "Colombia" | country == "Ecuador" | country == "Ghana" | country == "Papua New Guinea"

xtreg tottax L.tottax election_e5_opp election_e5_comp lgdp agric imports civil_war_hm totnontax growthpc inflationgdp yr1-yr31 , vce(robust)fe i(ccode)
est store r5

lincom election_e5_opp + election_e5_comp

xtreg tottax L.tottax election_e5_opp election_e5_comp50 lgdp agric imports civil_war_hm totnontax growthpc inflationgdp yr1-yr31 , vce(robust)fe i(ccode)
est store r6

lincom election_e5_opp + election_e5_comp50

xtreg tottax L.tottax election_e6_opp election_e6_comp lgdp agric imports civil_war_hm totnontax growthpc inflationgdp yr1-yr31 , vce(robust)fe i(ccode)
est store r7

lincom election_e6_opp + election_e6_comp

xtreg tottax L.tottax election_e6_opp election_e6_comp50 lgdp agric imports civil_war_hm totnontax growthpc inflationgdp yr1-yr31 , vce(robust)fe i(ccode)
est store r8

lincom election_e6_opp + election_e6_comp50

esttab  r1 r2 r3 r4 r5 r6 r7 r8/*
*/ using $PathEst/Appendixtables_2015_1010_tables.rtf, append cells(b(star fmt(4)) se(par fmt(4))) /*
*/ legend label varlabels(_cons Constant) stats(N N_g r2 , fmt(0 3))  /*
*/ title("Table A32: Robustness Checks: Excluding Extreme Observations") /*
*/ starlevels(* 0.10 ** 0.05 *** 0.01) modelwidth(4) varwidth(12) /*
*/ keep(L.tottax election_e5_opp election_e5_comp election_e5_comp50 election_e6_comp election_e6_comp50 imports civil_war_hm totnontax growthpc lgdp agric inflationgdp ) /*
*/ order(L.tottax election_e5_opp election_e5_comp election_e5_comp50 election_e6_comp election_e6_comp50 imports civil_war_hm totnontax growthpc lgdp agric inflationgdp ) /*
*/ mlabels("Drop Extreme Values Comp E5 FE" "Drop Extreme Values Comp50 E5 FE" "Drop Extreme Values Comp E6 FE" "Drop Extreme Values Comp50 E6 FE" "Drop Larger Set of Extreme Values Comp E5 FE" "Drop Larger Set of Extreme Values Comp50 E5 FE" "Drop Larger Set of Extreme Values Comp E6 FE" "Drop Larger Set of Extreme Values Comp50 E6 FE")  
