****************************************************************************************************************
**																											  **
** This do file is part of the replication material for the following article: 								  **
**  	"An Asymmetrical 'President-in-Power' Effect" 											              **
** 		Authors: Davide Morisi, John Jost, and Vishal Singh													  **
** 		Journal: American Political Science Review															  **
**																											  **
** This file replicates the following things from the article: 												  **
**																											  **
**		RECODING OF GSS DATASET																				  **
**																											  **
****************************************************************************************************************

*RECODING OF "GSS 1972-2016 Cross-Sectional Cumulative Data (Release 4, August 16, 2018) - With GSS Codebook"
*Downloaded from http://gss.norc.org/get-the-data/stata on 23 October 2018

clear all
set maxvar 10000
*use "...\GSS7216_R4.DTA", clear

**********
*DEMOGRAPHICS

*gender
fre sex
recode sex (1=0 "male") (2=1 "female"), gen(female)
fre female

*age categories (same categories as in ANES)
recode age 18/24=1 25/34=2 35/44=3 45/54=4 55/64=5 65/99=6 .d=. .n=., gen(agegroup)
label define agegroup 1"18 - 24" 2"25 - 34" 3"35 - 44" 4"45 - 54" 5"55 - 64" 6"65+"
label values agegroup agegroup
ta agegroup

*education
fre degree
recode degree (0=0 "below high school") (1=1 "high school") (2=2 "some college") (3/4=3 "college or more") (else=.), gen(edu)
fre edu

*ethnicity (afro american)
fre race
recode race (2=1 "black") (1 3=0 "other") (else=.), gen(black)
fre black

*work status (unemployed)
ta wrkstat, m
fre wrkstat
recode wrkstat (4=1 "unemployed") (else=0 "other"), gen(unempl)
fre unempl

*income - generate income with same 5 categories as ANES
recode realinc .i=., gen(realincr)
sum realinc, d // family income in constant $
egen p16 = pctile(realincr), p(16)
egen p33 = pctile(realincr), p(33)
egen p67 = pctile(realincr), p(67)
egen p95 = pctile(realincr), p(95)
gen income1 = realincr if realincr<=p16
gen income2 = realincr if (realincr>p16 & realincr<=p33)
gen income3 = realincr if (realincr>p33 & realincr<=p67)
gen income4 = realincr if (realincr>p67 & realincr<=p95)
gen income5 = realincr if realincr>p95
recode income1 0/900000=1 .=0, gen(income1r)
recode income2 0/900000=2 .=0, gen(income2r)
recode income3 0/900000=3 .=0, gen(income3r)
recode income4 0/900000=4 .=0, gen(income4r)
recode income5 0/900000=5 .=0, gen(income5r)
gen income5anes2 = income1r+income2r+income3r+income4r+income5r
recode income5anes2 (0=6) (.=6)
label variable income5anes "Income 5 categories(ANES)"
label define income5anes 1"0 to 16 percentile" 2"17 to 33 percentile" 3"34 to 67 percentile" 4"68 to 95 percentile" 5"96 to 100 percentile" 6"Unreported/Missing"
label values income5anes income5anes
fre income5anes
drop p16 p33 p67 p95 income1 income2 income3 income4 income5 income1r income2r income3r income4r income5r

*religion
recode relig (1=1 "Protestant") (2=2 "Catholic") (3=3 "Jewish") (else=4 "Other/None"), gen(rel4)
ta rel4

*census areas
fre region
/*
1. New England		Northeast
2. Middle Atlantic	Northeast
3. East North Central	Midwest
4. West North Central	Midwest
5. South Atlantic	South
6. East South Central	South
7. West South Central	South
8. Mountain		West
9. Pacific		West
*/
recode region (1 2=1 "northeast") (3 4=2 "midwest") (5 6 7=3 "south") (8 9=4 "west"), gen(census)
fre census 

*******************
*TRUST - CONFIDENCE IN FEDERAL GOVT
ta confed, m
fre confed
*I am going to name some institutions in this country.
*As far as the people running these institutions are concerned,
*would you say you have a great deal of confidence, only some confidence, or hardly any confidence at all in them? 
*1	A great deal
*2	Only some
*3	Hardly any
recode confed (1=2) (2=1) (3=0) (else=.), gen(confed_rec)
fre confed_rec
*rescaled from 0 to 1
gen trust01 = confed_rec/2
label var trust01 "Confidence in federal govt"
label de trust01 0"Hardly any" 1"A great deal"
label values trust01 trust01
ta trust01, m

**********************
*IDEOLOGY AND PARTY ID

*ideology - full scale
fre polviews
*3 cat
recode polviews (1/3=1 "liberals") (4=2 "moderates") (5/7=3 "conservatives") (else=.), gen(ideo3)
ta ideo3
*dummy
recode polviews (1/3=1 "liberals") (5/7=2 "conservatives") (else=.), gen(ideo2)
ta ideo2

*party id full scale
fre partyid
recode partyid 7=., gen(partyid7)
label values partyid7 PARTYID
fre partyid7
*3 categories
drop partyid3
recode partyid (0/2=1 "democrat") (3=2 "independent") (4/6=3 "republican") (else=.), gen(partyid3)
fre partyid3
*dummy
drop partyid2
recode partyid (0/2=1 "democrat") (4/6=2 "republican") (else=.), gen(partyid2)
fre partyid2

*************************
*PRESIDENT IN POWER

*DEMOCRATIC / REPUBLICAN PRESIDENT
gen prespower = .
replace prespower = 1 if (year==1977 | year==1978 | year==1980 | year==1993 | year==1994 | year==1996 | year==1998 | year==2000 | year==2010 | year==2012 | year==2014 | year==2016)
replace prespower = 2 if (year==1974 | year==1975 | year==1976 | year==1982 | year==1983 | year==1984 | year==1986 | year==1987 | year==1988 | year==1989 | year==1990 | year==1991 | year==2002| year==2004 | year==2006 | year==2008)
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

*PARTY WITH MAJORITY IN SENATE
gen partysen = 1
replace partysen = 2 if (year==1982 | year==1983 | year==1984 | year==1985 | year==1986 | year==1996 | year==1998 | year==2000 | year==2004 | year==2006 | year==2016)
label var partysen "Party with majority in Senate"
label de partysen 1 "Democratic party" 2"Republican party"
label values partysen partysen
fre partysen
ta year partysen

*PARTY WITH MAJORITY IN HOSUE
gen partyhouse = 1
replace partyhouse = 2 if (year==1996 | year==1998 | year==2000 | year==2002 | year==2004 | year==2006 | year==2012 | year==2014 | year==2016)
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
recode year (1974/1980=1 "1974/1980") (1982/2000=2 "1982/2000") (2002/2016=3 "2002/2016") (else=.), gen(preschange)
ta year preschange

*SWITCH YEARS
recode year (1976 1978=1 "1976 and 1978") ///
	(1980/1982=2 "1980/1982") ///
	(1991/1993=3 "1991/1993") ///
	(2000/2002=4 "2000/2002") ///
	(2008 2012=5 "2008 and 2012") ///
	(else=.), gen(switch)
ta switch
ta year switch

*WEIGHTS
sum wtssall, d

*******************
*Remove surveys with no questions on trust, ideology and party identification
fre confed
fre polviews
fre partyid
tab year if confed!=.i & polviews!=.i
drop if year<1974 | year==1985
ta year

****************
*Save as recoded
*save "...\GSS7216_R4_recoded.DTA", replace









