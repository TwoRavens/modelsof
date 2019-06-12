****************************************************************************************************************
**																											  **
** This do file is part of the replication material for the following article: 								  **
**  "An Asymmetrical 'President-in-Power' Effect" 											                  **
** 		Authors: Davide Morisi, John Jost, and Vishal Singh													  **
** 		Journal: American Political Science Review															  **
**																											  **
** This file replicates the following things from the article: 												  **
**																											  **
**		RECODING OF ANES DATASET																			  **
**																											  **
****************************************************************************************************************

*RECODING OF "ANES Time Series Cumulative Data File (1948-2012)"
*Downloaded on December 5, 2017, from https://electionstudies.org/data-center/

*use "...\anes_timeseries_cdf.dta", clear

***************
*IDENTIFIERS, WEIGHTS, YEARS

*year
rename VCF0004 year
ta year

*study respondent number
rename VCF0006 respid

*unique resp num
rename VCF0006a uniqueid

*weights
sum VCF0009x VCF0009y VCF0009z
rename VCF0009x weight1 // combined sample
rename VCF0009y weight2 // FTF
rename VCF0009z weight3 // web

*****************
*DEMOGRAPHICS

*gender
fre VCF0104
recode VCF0104 (1=0 "male") (2=1 "female"), gen(female)
fre female

*age categories
fre VCF0102
recode VCF0102 0=. 7=6, gen(agegroup)
label de VCF0102_ 6"65+", modify
label values agegroup VCF0102_
fre agegroup

*education
fre VCF0110
recode VCF0110 0=., gen(edu4)
label values edu4 VCF0110_
fre edu4

*ethnicity (afro-american)
fre VCF0106
recode VCF0106 (2=1 "afro american") (1 3=0 "other") (9=.), gen(black)
fre black

*work status (unemployed)
fre VCF0118
recode VCF0118 (2=1 "unemployed") (9=.) (else=0 "other"), gen(unempl)
fre unempl
 
*income (percentiles)
fre VCF0114
ta year if VCF0114==. // income missing in year 2002
gen income5 = 99
replace income5 = 1 if VCF0114==1
replace income5 = 2 if VCF0114==2
replace income5 = 3 if VCF0114==3
replace income5 = 4 if VCF0114==4
replace income5 = 5 if VCF0114==5
label de inc1 1"0 to 16 percentile" 2"17 to 33 percentile" 3"34 to 67 percentile" 4"68 to 95 percentile" 5"96 to 100 percentile" 99"Missing/DK/Unreported", modify
label values income5 inc1
ta income5

*religion
fre VCF0128
recode VCF0128 0=., gen(religion)
label values religion VCF0128_
fre religion

*census region
fre VCF0112
rename VCF0112 census
recode census .=99
ta census // 99=missing


*******************
*TRUST

*1. TRUST IN GOV (How Much Does R Trust the Federal Govt To Do What is Right)
fre VCF0604
recode VCF0604 (0 9=.), gen(trust)
label values trust VCF0604_
fre trust
*rescaled from 0 to 1
gen trust01 = (trust-1)/3
label var trust01 "How Much Does R Trust the Federal Govt To Do What is Right"
label de trust01 0"None of the time" 1"Just about always"
label values trust01 trust01
fre trust01
*rescaled as a dummy for alternative analysis
recode trust (1/2=0 "None of the time/some of the time") (3/4=1 "Most of the time/Just about always"), gen(trustdum)
fre trustdum

*additional variables for trust index
*2. Is Federal Govt Run by Few Interests/for the Benefit of All
fre VCF0605
recode VCF0605 (0 9=.), gen(govinten)
label values govinten VCF0605_
ta govinten
*rescaled from 0 to 1
gen govint01 = govinten-1
label de govint01 0"Few big interests" 1"Benefit of all"
label values govint01 govint01
fre govint01

*3. How Much Does the Federal Government Waste Tax Money
fre VCF0606
recode VCF0606 (0 9=.), gen(govwasten)
label values govwasten VCF0606_
ta govwasten
*rescaled from 0 to 1
gen govwaste01 = (govwasten-1)/2
label de govwaste01 0"waste a lot" 1"don't waste very much"
label values govwaste01 govwaste01
ta govwaste01

**********************
*IDEOLOGY AND PARTY ID

*ideology full scale
fre VCF0803
recode VCF0803 (0 9=.), gen(ideo7)
label values ideo7 VCF0803_
ta ideo7
*3 cat
recode ideo7 (1/3=1 "Liberal") (4=2 "Moderate") (5/7=3 "Conservative"), gen(ideo3)
fre ideo3
*dummy (liberal vs. conservative)
recode ideo7 (1/3=1 "Liberal") (4=.) (5/7=2 "Conservative"), gen(ideo2)
fre ideo2

*party id full scale
fre VCF0301
recode VCF0301 0=., gen(partyid7)
label values partyid7 VCF0301_
fre partyid7
*3 cat
recode VCF0301 (0=.) (1/3=1 "Democrat") (4=2 "Independent") (5/7=3 "Republican"), gen(partyid3)
tab partyid3
*dummy (Democrat vs. Republican)
recode VCF0301 (0 4=.) (1/3=1 "Democrat") (5/7=2 "Republican"), gen(partyid2)
tab partyid2

********************
*Remove surveys with no questions on trust, ideology and party identification
tab year if (VCF0604!=. & VCF0803!=. & VCF0301!=.)
drop if year<1972
ta year

**********************
*Save recoded dataset
*save "...\anes_timeseries_cdf_recoded.dta"



********************************************************
********************************************************
*RECODING OF "ANES 2016 Time Series Study"
*Downloaded on December 5, 2017, from https://electionstudies.org/data-center/

*use "...\anes_timeseries_2016.dta", clear


***************
*IDENTIFIERS, WEIGHTS, YEARS

*year
gen year = 2016
ta year

*study respondent number
rename V160001 uniqueid

*weights pre-election
sum V160101 V160101f V160101w
rename V160101 weight16_1
rename V160101f weight16_2
rename V160101w weight16_3

*****************
*DEMOGRAPHICS

*gender
fre V161342
recode V161342 (-9 3=.) (1=0) (2=1), gen(female)
fre female

*age categories
fre V161267
recode V161267 -9/-8=. 18/24=1 25/35=2 35/44=3 45/54=4 55/64=5 65/99=6, gen(agegroup)

*education
fre V161270
recode V161270 (-9=.) (1/4=1) (5/9=2) (10=3) (11/16=4) (90=2) (95=.), gen(edu4)
fre edu4

*ethnicity (afro american)
fre V161310x
recode V161310x (-9=.) (2=1) (else=0), gen(black)
fre black

*work status (unemployed)
fre V161277
recode V161277 (-9=.) (4=1) (else=0), gen(unempl)
ta unempl
 
*income (recode using the same categories as in time series)
fre V161361x
ta V161361x if V161361x>-5
recode V161361x (1/5=1) (6/11=2) (12/20=3) (21/26=4) (27/28=5) (-9 -5=99), gen(income5)
ta income5

*religion types
fre V161247a V161247b
gen religion = 4 if (V161247a!=-9 & V161247b!=-9)
replace religion = 1 if (V161247a==1 | V161247b==1)
replace religion = 2 if (V161247a==2 | V161247b==2)
replace religion = 3 if (V161247a==3 | V161247b==3)
fre religion // 4 includes none/other/dk (11 missing)

*census region not available
gen census = 99

******************
* TRUST

*TRUST IN GOV (How Much Does R Trust the Federal Govt To Do What is Right)
fre V161215
recode  V161215 (-9 -8=.), gen(trust16)
label values trust16 V161215
ta trust16
*rescaled from 0 to 1
gen trust16_01 = ((-trust16)+5)/4
label var trust16_01 "How Much Does R Trust the Federal Govt To Do What is Right 2016"
label de trust16_01 0"Never" 1"Always"
label values trust16_01 trust16_01
fre trust16_01

*additional variables for trust index
*2. Is Federal Govt Run by Few Interests/for the Benefit of All
fre V161216
recode V161216 (-9 -8=.), gen(govinten)
label values govinten V161216
ta govinten
*rescaled from 0 to 1
gen govint01 = govinten-1
fre govint01

*3. How Much Does the Federal Government Waste Tax Money
fre V161217
recode V161217 (-9 -8=.), gen(govwasten)
label values govwasten V161217
ta govwasten
*rescaled from 0 to 1
gen govwaste01 = (govwasten-1)/2
ta govwaste01

**********************
*IDEOLOGY AND PARTY ID

*ideology full scale
fre V161126
recode V161126 (-9 -8 99=.), gen(ideo7)
label values ideo7 V161126
ta ideo7
*3 cat
recode ideo7 (1/3=1) (4=2) (5/7=3), gen(ideo3)
ta ideo3
*dummy
recode ideo7 (1/3=1) (4=.) (5/7=2), gen(ideo2)
ta ideo2

*party id full scale
fre V161158x
recode V161158x -9 -8=., gen(partyid7)
*3 cat
recode partyid7 (1/3=1) (4=2) (5/7=3), gen(partyid3) // 1=dem 2=indep, 3=rep
ta partyid3
*dummy
recode partyid3 2=. 3=2, gen(partyid2) // 1=dem, 2=rep
ta partyid2


**********
*keep only relevant variables and save as recoded

keep year uniqueid weight16_1 weight16_2 weight16_3 ///
female agegroup edu4 black unempl income5 religion census ///
trust16 trust16_01 govinten govint01 govwasten govwaste01 ///
ideo7 ideo3 ideo2 partyid7 partyid3 partyid2

*save "...\anes_timeseries_2016_recoded.dta"


********************************************************
********************************************************
*ADD 2016 DATA TO TIME SERIES

*use "...\anes_timeseries_cdf_recoded.dta", clear
*append using "...\anes_timeseries_2016_recoded.dta"


********************************************************
********************************************************
*RECODING OF FINAL DATASET

*TRUST FINAL DV
*Trust quasi-interval
ta trust01
ta trust16_01
gen trustall = .
replace trustall = trust01 if year<2016
replace trustall = trust16_01 if year==2016
ta trustall // combination cumulative + 2016

*TRUST INDEX - combination of 3 questions:
fre trustall // Trust in govt to do what is right
fre govint01 // Federal Govt Run by Few Interests/for the Benefit of All
fre govwaste01 // How Much Does the Federal Government Waste Tax Money”
*create index
gen trust_index = trustall+govint01+govwaste01
ta trust_index // full index from 0 to 3
gen trust_index01 = trust_index/3
ta trust_index01 // full index from 0 (min trust) to 1 (max trust)


*************************
*PRESIDENT IN POWER

/*list of presidents, presidents' party and years
pres.	party		year
Nixon	Republican	1972
Nixon	Republican	1974
Ford	Republican	1976
Carter	Democrat	1978
Carter	Democrat	1980
Reagan	Republican	1982
Reagan	Republican	1984
Reagan	Republican	1986
Reagan	Republican	1988
Bush	Republican	1990
Bush	Republican	1992
Clinton	Democrat	1994
Clinton	Democrat	1996
Clinton	Democrat	1998
Clinton	Democrat	2000
Bush	Republican	2002
Bush	Republican	2004
Bush	Republican	2008
Obama	Democrat	2012
*/

*DEMOCRATIC / REPUBLICAN PRESIDENT
gen prespower = .
replace prespower = 1 if (year==1964 | year==1966 | year==1968 | year==1978 | year==1980 | year==1994 | year==1996 | year==1998 | year==2000 | year==2012 | year==2016)
replace prespower = 2 if (year==1958 | year==1970 | year==1972 | year==1974 | year==1976 | year==1982 | year==1984 | year==1986 | year==1988 | year==1990 | year==1992 | year==2002	| year==2004 | year==2008)
label var prespower "President in power"
label de prespower 1"Democratic pres" 2"Republican pres"
label values prespower prespower
fre prespower 
ta year prespower

*PRESIDENT WITH SAME IDEOLOGY AS RESPONDENT
fre prespower ideo2
*Liberals
gen ownpresL = prespower if ideo2==1
ta ownpresL
recode ownpresL 2=0 .=0
*Conservatives
gen ownpresC = prespower if ideo2==2
ta ownpresC
recode ownpresC 2=1 1=0 .=0
*Combined
gen ownpresLC = ownpresL + ownpresC if (ideo2==1 | ideo2==2) & (prespower==1 | prespower==2)
label variable ownpresLC "President with same ideology as R"
label define ownpresLC 0"Other ideology" 1"Same ideology"
label values ownpresLC ownpresLC
fre ownpresLC
ta ideo2 prespower
ta ideo2 ownpresLC
*Including moderates (republican pres = moderates' own president)
fre ideo3
gen ownpresM = prespower if ideo3==2
ta ownpresM
recode ownpresM 2=1 1=0 .=0
*combined
gen ownpresLCM = ownpresL + ownpresC + ownpresM if (ideo2==1 | ideo2==2 | ideo3==2 ) & (prespower==1 | prespower==2)
label variable ownpresLCM "President with same ideology as R"
label define ownpresLCM 0"Other ideology" 1"Same ideology"
label values ownpresLCM ownpresLCM
fre ownpresLCM
ta ideo3 prespower
ta ideo3 ownpresLCM
drop ownpresL ownpresC ownpresM

*PRESIDENT FROM SAME PARTY AS RESPONDENT
fre prespower
fre partyid2
*Democrats
gen ownpresD = prespower if partyid2==1
ta ownpresD
recode ownpresD 2=0 .=0
*Republicans
gen ownpresR = prespower if partyid2==2
ta ownpresR
recode ownpresR 2=1 1=0 .=0
*combined
gen ownpresDR = ownpresD + ownpresR if (partyid2==1 | partyid2==2) & (prespower==1 | prespower==2)
label variable ownpresDR "President from party same party as R"
label define ownpresDR 0"Other party" 1"Same party"
label values ownpresDR ownpresDR
fre ownpresDR
ta partyid2 prespower
ta partyid2 ownpresDR
*Including independents (republican pres = independents' own president)
fre partyid3
gen ownpresI = prespower if partyid3==2
ta ownpresI
recode ownpresI 2=1 1=0 .=0
*combined
gen ownpresDRI = ownpresD + ownpresR + ownpresI if (partyid2==1 | partyid2==2 | partyid3==2) & (prespower==1 | prespower==2)
label variable ownpresDRI "President with same ideology as R"
label define ownpresDRI 0"Other party" 1"Same party"
label values ownpresDRI ownpresDRI
fre ownpresDRI
ta partyid3 prespower
ta partyid3 ownpresDRI
drop ownpresD ownpresR ownpresI


******************
*OTHER VARIABLES

*PARTY WITH MAJORITY IN SENATE
gen partysen = 1
replace partysen = 2 if (year==1982 | year==1984 | year==1986 | year==1996 | year==1998 | year==2000 | year==2004 | year==2016)
label var partysen "Party with majority in Senate"
label de partysen 1 "Democratic party" 2"Republican party"
label values partysen partysen
fre partysen
ta year partysen

*PARTY WITH MAJORITY IN HOSUE
gen partyhouse = 1
replace partyhouse = 2 if (year==1996 | year==1998 | year==2000 | year==2002 | year==2004 | year==2012 | year==2016)
label var partyhouse "Party with majority in House"
label de partyhouse 1 "Democratic party" 2"Republican party"
label values partyhouse partyhouse
ta partyhouse
ta year partyhouse

*Divided/united congress
fre partysen partyhouse
gen congr_dum = .
replace congr_dum = 1 if (partysen==1 & partyhouse==1) | (partysen==2 & partyhouse==2)
replace congr_dum = 2 if (partysen==1 & partyhouse==2) | (partysen==2 & partyhouse==1)
label de congr_dum 1"united congress" 2"divided congress"
label values congr_dum congr_dum
ta congr_dum
ta year congr_dum

*TIME (PERIODS)
recode year (1970/1980=1 "1970/1980") (1982/2000=2 "1982/2000") (2002/2016=3 "2002/2016") (else=.), gen(preschange)
ta year preschange

*SWITCH YEARS
recode year (1976/1978=1 "1976/1978") ///
	(1980/1982=2 "1980/1982") ///
	(1992/1994=3 "1992/1994") ///
	(2000/2002=4 "2000/2002") ///
	(2008/2012=5 "2008/2012") ///
	(else=.), gen(switchyear)
ta switchyear
ta year switchyear

*WEIGHTS
sum weight1 // cumulative
sum weight16_1 // 2016
gen weightall = .
replace weightall = weight1 if weight16_1==.
replace weightall = weight16_1 if weight1==.
sum weightall, d

*save as combined dataset
*save "...\anes_combined.dta", replace
