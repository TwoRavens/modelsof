// This do-file contains the stata code for creating the Analysis Dataset
// used in the analyses presented in columns 1, 2 and 4 of Table 4 are based. 

set more off 

// The original data come from different years of the Swedish National Election Study
// that can be ordered from Swedish National Data Service (www.snd.gu.se). 
cd "C:/Users/lindgren_ko/Desktop"

// Read in the data for the 1973 election study
use "VU/1973/0040.DTA", clear

//Rename the variables of interest
	keep V1 V7 V8 V219 V12 V145 V236
	rename V1 IDnumber
	rename V7 BirthYear
	rename V8 Gender
	rename V219 Education
	rename V12 PolIntr
	rename V145 ReadPol
	rename V236 BirthPlace
	
	gen ElectionStudy=1973
	tempfile V73
	save `V73'

// Read in the data for the 1976 election study	
use "VU/1976/0008.DTA", clear
	keep  V1 V279 V281 V247 V14 V266 V13 V263
	rename V1 IDnumber
	rename V279 BirthYear
	rename V281 Gender
	rename V247 Education
	rename V14 PolIntr
	rename V266 LivingPlace
	rename V13 ReadPol
	rename V263 BirthPlace
	
	gen ElectionStudy=1976
	tempfile V76
	save `V76'

// Read in the data for the 1979 election study	
use "VU/1979/0089.DTA", clear
	keep  V1 V286 V288 V256 V45 V278 V27 V271
	rename V1 IDnumber
	rename V286 BirthYear
	rename V288 Gender
	rename V256 Education
	rename V45 PolIntr
	rename V278 LivingPlace
	rename V27 ReadPol
	rename V271 BirthPlace

	gen ElectionStudy=1979
	tempfile V79
	save `V79'
	
// Read in the data for the 1982 election study
use "VU/1982/0157.dta", clear
	keep  v1 v291 v290 v190 v27 v268 v23
	rename v1 IDnumber
	rename v291 BirthYear
	rename v290 Gender
	rename v190 Education
	rename v27 PolIntr
	rename v268 LivingPlace
	rename v23 ReadPol
	
	gen ElectionStudy=1982
	tempfile V82
	save `V82'
	
// Read in the data for the 1985 election study
use "VU/1985/0217.dta", clear
	keep v1 v366 v365 v319 v36 v257 v258 v260 v251 v252 v253 v254 v256 v259 v370 v37 v28 
	rename v1 IDnumber
	rename v366 BirthYear
	rename v365 Gender
	rename v319 Education
	rename v36 PolIntr
	rename v37 PolNetwork 
	rename v28 ReadPol
	rename v257 Kuns1_85
	rename v258 Kuns2_85
	rename v260 Kuns3_85
	rename v251 Kuns4_85
	rename v252 Kuns5_85
	rename v253 Kuns6_85
	rename v254 Kuns7_85
	rename v256 Kuns8_85
	rename v259 Kuns9_85	
	rename v370 LivingPlace
	
	gen ElectionStudy=1985
	
// Recode the knowledge items so that they take on 1 if correct, and 0 otherwise
	gen RKuns1_85=(Kuns1_85==5) if Kuns1_85<. 
	gen RKuns2_85=(Kuns2_85==1) if Kuns2_85<.
	gen RKuns3_85=(Kuns3_85==5) if Kuns3_85<.
	gen RKuns4_85=(Kuns4_85==44) if Kuns4_85<.
	gen RKuns5_85=(Kuns5_85==22) if Kuns5_85<.
	gen RKuns6_85=(Kuns6_85==33) if Kuns6_85<.
	gen RKuns7_85=(Kuns7_85==55) if Kuns7_85<.
	gen RKuns8_85=(Kuns8_85==1) if Kuns8_85<.
	gen RKuns9_85=(Kuns9_85==5) if Kuns9_85<. 
	
	gen KnowFacts=(RKuns1_85+RKuns2_85+RKuns3_85+RKuns8_85+RKuns9_85)/5
	gen KnowPersons=(RKuns4_85+RKuns5_85+RKuns6_85+RKuns7_85)/4
	
	gen PolKnowledge=(RKuns1_+RKuns2_+RKuns3_+RKuns4_+RKuns5_+RKuns6_+RKuns7_+RKuns8_+RKuns9_)/9
	
	tempfile V85
	save `V85'

// Read in the data for the 1988 election study	
use "VU/1988/0227.DTA", clear
	keep  V1 V367 V366 V299 V25 V230 V231 V232 V233 V224 V228 V226 V227 V225 V229 V371 V26 V18 V296
	rename V1 IDnumber
	rename V367 BirthYear
	rename V366 Gender
	rename V299 Education
	rename V25 PolIntr
	rename V26 PolNetwork
	rename V18 ReadPol
	rename V230 Kuns1_88
	rename V231 Kuns2_88
	rename V232 Kuns3_88
	rename V233 Kuns4_88
	rename V224 Kuns5_88
	rename V228 Kuns6_88
	rename V226 Kuns7_88
	rename V227 Kuns8_88
	rename V225 Kuns9_88	
	rename V229 Kuns10_88
	rename V371 LivingPlace
	rename V296 BirthPlace
	
	gen ElectionStudy=1988
	
// Recode the knowledge items so that they take on 1 if correct, and 0 otherwise
	gen RKuns1_88=(Kuns1_88==5) if Kuns1_88<.
	gen RKuns2_88=(Kuns2_88==1) if Kuns2_88<. 
	gen RKuns3_88=(Kuns3_88==5) if Kuns3_88<.
	gen RKuns4_88=(Kuns4_88==5) if Kuns4_88<.
	gen RKuns5_88=(Kuns5_88==44) if Kuns5_88<.
	gen RKuns6_88=(Kuns6_88==9) if Kuns6_88<.
	gen RKuns7_88=(Kuns7_88==33) if Kuns7_88<.
	gen RKuns8_88=(Kuns8_88==33) if Kuns8_88<.
	gen RKuns9_88=(Kuns9_88==22) if Kuns9_88<.
	gen RKuns10_88=(Kuns10_88==1) if Kuns10_88<.
	
// Create additative indexes of the different knowledge items
	gen KnowFacts=(RKuns1_88+RKuns2_88+RKuns3_88+RKuns10_88)/4
	gen KnowPersons=(RKuns5_88+RKuns6_88+RKuns7_88+RKuns8_88+RKuns9_88)/5
	gen PolKnowledge=(RKuns1_+RKuns2_+RKuns3_+RKuns5_+RKuns6_+RKuns7_+RKuns8_+RKuns9_+RKuns10_)/9
	
	tempfile V88
	save `V88'

// Read in the data for the 1991 election study	
use "VU/1991/0391.DTA", clear
	keep V4 V14 V15 V359 V24 V287 V284 V285 V286 V289 V288 V277 V281 V282 V278 V279 V280 V283 V410 V25 V16 V453
	rename V4 IDnumber
	rename V14 BirthYear
	rename V15 Gender
	rename V359 Education
	rename V24 PolIntr
	rename V25 PolNetwork
	rename V16 ReadPol
	rename V287 Kuns1_91
	rename V284 Kuns2_91
	rename V285 Kuns3_91
	rename V286 Kuns4_91
	rename V289 Kuns5_91
	rename V288 Kuns6_91
	rename V277 Kuns7_91
	rename V281 Kuns8_91
	rename V282 Kuns9_91	
	rename V278 Kuns10_91
	rename V279 Kuns11_91
	rename V280 Kuns12_91	
	rename V283 Kuns13_91
	rename V410 LivingPlace
	rename V453 BirthPlace
	
// Recode the knowledge items so that they take on 1 if correct, and 0 otherwise
	gen RKuns1_91=(Kuns1_91==5) if Kuns1_91<.
	gen RKuns2_91=(Kuns2_91==5) if Kuns2_91<. 
	gen RKuns3_91=(Kuns3_91==1) if Kuns3_91<.
	gen RKuns4_91=(Kuns4_91==1) if Kuns4_91<.
	gen RKuns5_91=(Kuns5_91==1) if Kuns5_91<.
	gen RKuns6_91=(Kuns6_91==5) if Kuns6_91<.
	gen RKuns7_91=(Kuns7_91==44) if Kuns7_91<.
	gen RKuns8_91=(Kuns8_91==9) if Kuns8_91<.
	gen RKuns9_91=(Kuns9_91==11) if Kuns9_91<.
	gen RKuns10_91=(Kuns10_91==22) if Kuns10_91<.
	gen RKuns11_91=(Kuns11_91==33) if Kuns11_91<.
	gen RKuns12_91=(Kuns12_91==55) if Kuns12_91<.
	gen RKuns13_91=(Kuns13_91==5) if Kuns13_91<.
	
// Create additative indexes of the different knowledge items	
	gen KnowFacts=(RKuns1_91+RKuns2_91+RKuns3_91+RKuns4_91+RKuns5_91+RKuns6_91+RKuns13_91)/7
	gen KnowPersons=(RKuns7_91+RKuns8_91+RKuns9_91+RKuns10_91+RKuns11_91+RKuns12_91)/6
	gen PolKnowledge=(RKuns1_+RKuns2_+RKuns3_+RKuns4_+RKuns5_+RKuns6_+RKuns7_+RKuns8_+RKuns9_+RKuns10_+RKuns11+RKuns12+RKuns13)/13
	
	gen ElectionStudy=1991
	
	tempfile V91
	save `V91'
	
// Read in the data for the 1994 election study	
use "VU/1994/0570.DTA", clear
keep  V4 V11 V12 V368 V22 V298 V296 V297 V288 V289 V294 V293 V290 V291 V292 V295 V300 V299 V482 V23 V13 V410
	rename V4 IDnumber
	rename V11 BirthYear
	rename V12 Gender
	rename V368 Education
	rename V22 PolIntr
	rename V23 PolNetwork
	rename V13 ReadPol
	rename V298 Kuns1_94
	rename V296 Kuns2_94
	rename V297 Kuns3_94
	rename V288 Kuns4_94
	rename V289 Kuns5_94
	rename V294 Kuns6_94
	rename V293 Kuns7_94
	rename V290 Kuns8_94
	rename V291 Kuns9_94	
	rename V292 Kuns10_94
	rename V295 Kuns11_94
	rename V300 Kuns12_94	
	rename V299 Kuns13_94
	rename V482 LivingPlace
	rename V410 BirthPlace
	
// Recode the knowledge items so that they take on 1 if correct, and 0 otherwise
	gen RKuns1_94=(Kuns1_94==1) if Kuns1_94<.
	gen RKuns2_94=(Kuns2_94==1) if Kuns2_94<. 
	gen RKuns3_94=(Kuns3_94==5) if Kuns3_94<.
	gen RKuns4_94=(Kuns4_94==44) if Kuns4_94<.
	gen RKuns5_94=(Kuns5_94==22) if Kuns5_94<.
	gen RKuns6_94=(Kuns6_94==66) if Kuns6_94<.
	gen RKuns7_94=(Kuns7_94==11) if Kuns7_94<.
	gen RKuns8_94=(Kuns8_94==33) if Kuns8_94<.
	gen RKuns9_94=(Kuns9_94==55) if Kuns9_94<.
	gen RKuns10_94=(Kuns10_94==9) if Kuns10_94<.
	gen RKuns11_94=(Kuns11_94==5) if Kuns11_94<.
	gen RKuns12_94=(Kuns12_94==1) if Kuns12_94<.
	gen RKuns13_94=(Kuns13_94==5) if Kuns13_94<.
	
// Create additative indexes of the different knowledge items
	gen KnowFacts=(RKuns1_94+RKuns2_94+RKuns3_94+RKuns11_94+RKuns12_94+RKuns13_94)/6
	gen KnowPersons=(RKuns4_94+RKuns5_94+RKuns6_94+RKuns7_94+RKuns8_94+RKuns9_94+RKuns10_94)/7
	gen PolKnowledge=(RKuns1_+RKuns2_+RKuns3_+RKuns4_+RKuns5_+RKuns6_+RKuns7_+RKuns8_+RKuns9_+RKuns10_+RKuns11+RKuns12+RKuns13)/13

	gen ElectionStudy=1994
	
	tempfile V94
	save `V94'

// Read in the data for the 1998 election study
use "VU/1998/0750.dta", clear
	rename V4 IDnumber
	rename V11 BirthYear
	rename V12 Gender
	rename V384 Education
	rename V22 PolIntr
	rename V222 Kuns1_98
	rename V220 Kuns2_98
	rename V221 Kuns3_98
	rename V214 Kuns4_98
	rename V213 Kuns5_98
	rename V218 Kuns6_98
	rename V217 Kuns7_98
	rename V212 Kuns8_98
	rename V215 Kuns9_98	
	rename V216 Kuns10_98
	rename V225 Kuns11_98
	rename V219 Kuns12_98	
	rename V224 Kuns13_98
	rename V223 Kuns14_98
	rename V465 LivingPlace
	rename V408 BirthPlace
	rename V23 PolNetwork
	rename V13 ReadPol
	drop V*
	
// Recode the knowledge items so that they take on 1 if correct, and 0 otherwise
	gen RKuns1_98=(Kuns1_98==1) if Kuns1_98<.
	gen RKuns2_98=(Kuns2_98==1) if Kuns2_98<. 
	gen RKuns3_98=(Kuns3_98==5) if Kuns3_98<.
	gen RKuns4_98=(Kuns4_98==33) if Kuns4_98<.
	gen RKuns5_98=(Kuns5_98==22) if Kuns5_98<.
	gen RKuns6_98=(Kuns6_98==66) if Kuns6_98<.
	gen RKuns7_98=(Kuns7_98==11) if Kuns7_98<.
	gen RKuns8_98=(Kuns8_98==44) if Kuns8_98<.
	gen RKuns9_98=(Kuns9_98==55) if Kuns9_98<.
	gen RKuns10_98=(Kuns10_98==9) if Kuns10_98<.
	gen RKuns11_98=(Kuns11_98==5) if Kuns11_98<.
	gen RKuns12_98=(Kuns12_98==5) if Kuns12_98<.
	gen RKuns13_98=(Kuns13_98==1) if Kuns13_98<.
	gen RKuns14_98=(Kuns14_98==5) if Kuns14_98<.
	
// Create additative indexes of the different knowledge items
	gen KnowFacts=(RKuns1_98+RKuns2_98+RKuns3_98+RKuns11_98+RKuns12_98+RKuns13_98+RKuns14_98)/7
	gen KnowPersons=(RKuns4_98+RKuns5_98+RKuns6_98+RKuns7_98+RKuns8_98+RKuns9_98+RKuns10_98)/7
	gen PolKnowledge=(RKuns1_+RKuns2_+RKuns3_+RKuns4_+RKuns5_+RKuns6_+RKuns7_+RKuns8_+RKuns9_+RKuns10_+RKuns11+RKuns12+RKuns13+RKuns14)/14
	
	gen ElectionStudy=1998
	
	tempfile V98
	save `V98'

// Read in the data for the 2002 election study	
use "VU/2002/0812.DTA", clear
	rename V4 IDnumber
	rename V11 BirthYear
	rename V12 Gender
	rename V500 Education
	rename V23 PolIntr
	rename V297 Kuns1_02
	rename V292 Kuns2_02
	rename V293 Kuns3_02
	rename V296 Kuns4_02
	rename V294 Kuns5_02
	rename V290 Kuns6_02
	rename V284 Kuns7_02
	rename V286 Kuns8_02
	rename V289 Kuns9_02	
	rename V288 Kuns10_02
	rename V283 Kuns11_02
	rename V285 Kuns12_02	
	rename V287 Kuns13_02
	rename V298 Kuns14_02
	rename V291 Kuns15_02
	rename V295 Kuns16_02
	rename V588 LivingPlace
	rename V513 BirthPlace
	rename V24 PolNetwork
	rename V13 ReadPol
	drop V*
	
// Recode the knowledge items so that they take on 1 if correct, and 0 otherwise
	gen RKuns1_02=(Kuns1_02==1) if Kuns1_02<.
	gen RKuns2_02=(Kuns2_02==1) if Kuns2_02<. 
	gen RKuns3_02=(Kuns3_02==1) if Kuns3_02<.
	gen RKuns4_02=(Kuns4_02==5) if Kuns4_02<.
	gen RKuns5_02=(Kuns5_02==5) if Kuns5_02<.
	gen RKuns6_02=(Kuns6_02==2) if Kuns6_02<.
	gen RKuns7_02=(Kuns7_02==2) if Kuns7_02<.
	gen RKuns8_02=(Kuns8_02==5) if Kuns8_02<.
	gen RKuns9_02=(Kuns9_02==6) if Kuns9_02<.
	gen RKuns10_02=(Kuns10_02==1) if Kuns10_02<.
	gen RKuns11_02=(Kuns11_02==4) if Kuns11_02<.
	gen RKuns12_02=(Kuns12_02==3) if Kuns12_02<.
	gen RKuns13_02=(Kuns13_02==7) if Kuns13_02<.
	gen RKuns14_02=(Kuns14_02==1) if Kuns14_02<.
	gen RKuns15_02=(Kuns15_02==5) if Kuns15_02<.
	gen RKuns16_02=(Kuns16_02==1) if Kuns16_02<.
	
// Create additative indexes of the different knowledge items
	gen KnowFacts=(RKuns1_02+RKuns2_02+RKuns3_02+RKuns4_02+RKuns5_02+RKuns14_02+RKuns15_02+RKuns16_02)/8
	gen KnowPersons=(RKuns6_02+RKuns7_02+RKuns8_02+RKuns9_02+RKuns10_02+RKuns11_02+RKuns12_02+RKuns13_02)/8
	gen PolKnowledge=(RKuns1_+RKuns2_+RKuns3_+RKuns4_+RKuns5_+RKuns6_+RKuns7_+RKuns8_+RKuns9_+RKuns10_+RKuns11+RKuns12+RKuns13+RKuns14+RKuns15+RKuns16)/16	
	gen ElectionStudy=2002
	
	tempfile V02
	save `V02'

// Read in the data for the 2006 election study
use "VU/2006/0861distr.dta", clear
 rename v1 IDnumber
 rename sex Gender 
 rename v772 Education 
 rename v11 PolIntr
 rename v602 Kuns1_06 
 rename v603 Kuns2_06
 rename v604 Kuns3_06
 rename v605 Kuns4_06
 rename v606 Kuns5_06
 rename v607 Kuns6_06
 rename v608 Kuns7_06
 rename v609 Kuns8_06
 rename v610 Kuns9_06
 rename v611 Kuns10_06
 rename v612 Kuns11_06
 rename v613 Kuns12_06
 rename v614 Kuns13_06
 rename v615 Kuns14_06
 rename v616 Kuns15_06
 rename v617 Kuns16_06
 rename v618 Kuns17_06
 rename v814 LivingPlace
 rename v807 BirthPlace
 rename v12	PolNetwork
 rename v3 ReadPol
  
// Recode the knowledge items so that they take on 1 if correct, and 0 otherwise
 gen RKuns1_06=(Kuns1_06==4) if Kuns1_06<.
	gen RKuns2_06=(Kuns2_06==2) if Kuns2_06<. 
	gen RKuns3_06=(Kuns3_06==3) if Kuns3_06<.
	gen RKuns4_06=(Kuns4_06==5) if Kuns4_06<.
	gen RKuns5_06=(Kuns5_06==7) if Kuns5_06<.
	gen RKuns6_06=(Kuns6_06==1) if Kuns6_06<.
	gen RKuns7_06=(Kuns7_06==6) if Kuns7_06<.
	gen RKuns8_06=(Kuns8_06==2) if Kuns8_06<.
	gen RKuns9_06=(Kuns9_06==2) if Kuns9_06<.
	gen RKuns10_06=(Kuns10_06==5) if Kuns10_06<.
	gen RKuns11_06=(Kuns11_06==1) if Kuns11_06<.
	gen RKuns12_06=(Kuns12_06==5) if Kuns12_06<.
	gen RKuns13_06=(Kuns13_06==1) if Kuns13_06<.
	gen RKuns14_06=(Kuns14_06==1) if Kuns14_06<.
	gen RKuns15_06=(Kuns15_06==1) if Kuns15_06<.
	gen RKuns16_06=(Kuns16_06==5) if Kuns16_06<.
	gen RKuns17_06=(Kuns17_06==1) if Kuns16_06<.
	

// Create additative indexes of the different knowledge items
	gen KnowFacts=(RKuns10_06+RKuns11_06+RKuns12_06+RKuns13_06+RKuns14_06+RKuns15_06+RKuns16_06+RKuns17_06)/8
	gen KnowPersons=(RKuns1_06+RKuns2_06+RKuns3_06+RKuns4_06+RKuns5_06+RKuns6_06+RKuns7_06+RKuns8_06+RKuns9_06)/9
	gen PolKnowledge=(RKuns1_+RKuns2_+RKuns3_+RKuns4_+RKuns5_+RKuns6_+RKuns7_+RKuns8_+RKuns9_+RKuns10_+RKuns11+RKuns12+RKuns13+RKuns15+RKuns14+RKuns16+RKuns17)/17
	
 
 //Finns bara sjuställig ålderskod för 2006, använd denna för att imputera födelseAr
	gen BirthYear=1986 if age7==1
  replace BirthYear=1980 if age7==2
	replace BirthYear=1970 if age7==3
	replace BirthYear=1960 if age7==4
	replace BirthYear=1950 if age7==5
	replace BirthYear=1940 if age7==6
	replace BirthYear=1928 if age7==7
	
 keep IDnumber Gender Education PolIntr KnowFacts KnowPersons PolKnow BirthYear LivingPlace PolNetwork ReadPol BirthPlace
	
 gen ElectionStudy=2006
 tempfile V06
 save `V06'

// Read in the data for the 2010 election study 
 use "VU/VU2010 SND/vu10snd.dta", clear
	rename V1 IDnumber
	rename S1 Gender
	rename S2 BirthYear
	rename V1116 Education
	rename V10 PolIntr
	rename V916 Kuns1_10
	rename V917 Kuns2_10
	rename V918 Kuns3_10
	rename V919 Kuns4_10
	rename V920 Kuns5_10
	rename V921 Kuns6_10
	rename V922 Kuns7_10
	rename V923 Kuns8_10
	rename V924 Kuns9_10
	rename V1148 LivingPlace
	rename V1142 BirthPlace
	rename S11 UtbSun
	rename V11 PolNetwork 
	rename V3 ReadPol 
	rename V7035 KunIndex
	
	rename V925 Kuns10_10
	rename V926 Kuns11_10
	rename V927 Kuns12_10
	rename V928 Kuns13_10
	rename V929 Kuns14_10
	rename V930 Kuns15_10
	rename V931 Kuns16_10
	rename V932 Kuns17_10
	rename V933 Kuns18_10
	
// Recode the knowledge items so that they take on 1 if correct, and 0 otherwise
	gen RKuns1_10=(Kuns1_10==5) if Kuns1_10!=.c & Kuns1_10!=.d & Kuns1_10!=.l & Kuns1_10!=.
	gen RKuns2_10=(Kuns2_10==3) if Kuns2_10!=.c & Kuns2_10!=.d & Kuns2_10!=.l & Kuns2_10!=.
	gen RKuns3_10=(Kuns3_10==4) if Kuns3_10!=.c & Kuns3_10!=.d & Kuns3_10!=.l & Kuns3_10!=.
	gen RKuns4_10=(Kuns4_10==5) if Kuns4_10!=.c & Kuns4_10!=.d & Kuns4_10!=.l & Kuns4_10!=.
	gen RKuns5_10=(Kuns5_10==2) if Kuns5_10!=.c & Kuns5_10!=.d & Kuns5_10!=.l & Kuns5_10!=.
	gen RKuns6_10=(Kuns6_10==7) if Kuns6_10!=.c & Kuns6_10!=.d & Kuns6_10!=.l & Kuns6_10!=.
	gen RKuns7_10=(Kuns7_10==1) if Kuns7_10!=.c & Kuns7_10!=.d & Kuns7_10!=.l & Kuns7_10!=.
	gen RKuns8_10=(Kuns8_10==6) if Kuns8_10!=.c & Kuns8_10!=.d & Kuns8_10!=.l & Kuns8_10!=.
	gen RKuns9_10=(Kuns9_10==2) if Kuns9_10!=.c & Kuns9_10!=.d & Kuns9_10!=.l & Kuns9_10!=.
	gen RKuns10_10=(Kuns10_10==5) if Kuns10_10!=.c & Kuns10_10!=.d & Kuns10_10!=.l & Kuns10_10!=.
	gen RKuns11_10=(Kuns11_10==1) if Kuns11_10!=.c & Kuns11_10!=.d & Kuns11_10!=.l & Kuns11_10!=.
	gen RKuns12_10=(Kuns12_10==5) if Kuns12_10!=.c & Kuns12_10!=.d & Kuns12_10!=.l & Kuns12_10!=.
	gen RKuns13_10=(Kuns13_10==5) if Kuns13_10!=.c & Kuns13_10!=.d & Kuns13_10!=.l & Kuns13_10!=.
	gen RKuns14_10=(Kuns14_10==1) if Kuns14_10!=.c & Kuns14_10!=.d & Kuns14_10!=.l & Kuns14_10!=.
	gen RKuns15_10=(Kuns15_10==1) if Kuns15_10!=.c & Kuns15_10!=.d & Kuns15_10!=.l & Kuns15_10!=.
	gen RKuns16_10=(Kuns16_10==5) if Kuns16_10!=.c & Kuns16_10!=.d & Kuns16_10!=.l & Kuns16_10!=.
	gen RKuns17_10=(Kuns17_10==1) if Kuns17_10!=.c & Kuns17_10!=.d & Kuns17_10!=.l & Kuns17_10!=.
	gen RKuns18_10=(Kuns18_10==5) if Kuns18_10!=.c & Kuns18_10!=.d & Kuns18_10!=.l & Kuns18_10!=.
		
// Create additative indexes of the different knowledge items
	gen KnowFacts=(RKuns10_10+RKuns11_10+RKuns12_10+RKuns13_10+RKuns14_10+RKuns15_10+RKuns16_10+RKuns17_10+RKuns17_10)/9
	gen KnowPersons=(RKuns1_10+RKuns2_10+RKuns3_10+RKuns4_10+RKuns5_10+RKuns6_10+RKuns7_10+RKuns8_10+RKuns9_10)/9
	gen PolKnowledge=(RKuns1_+RKuns2_+RKuns3_+RKuns4_+RKuns5_+RKuns6_+RKuns7_+RKuns8_+RKuns9_+RKuns10_+RKuns11+RKuns12+RKuns13+RKuns14+RKuns15+RKuns16+RKuns17+RKuns18)/18

	keep IDnumber Gender BirthYear Education PolIntr KnowFacts KnowPersons PolKnow UtbSun LivingPlace PolNetwork ReadPol BirthPlace
	gen ElectionStudy=2010
	
// Append the data for the different years to one big file	
  append using `V73'
	append using `V76'
	append using `V79'
	append using `V82'
	append using `V85'
	append using `V88'
	append using `V91'
	append using `V94'
	append using `V98'
	append using `V02'
	append using `V06'
	
//Recode year of birth to a common scale for all years, this does not work for
//individuals born before 1900, but that does not matter since they will not be
//included in the analysis.
	replace BirthYear=BirthYear+1900 if BirthYear<1000
			
	gen SchoolType=""
	replace SchoolType="Old Primary" if inrange(Education,11,14 ) & ElectionStudy==1973 
	replace SchoolType="New Primary" if Education==21 & ElectionStudy==1973 
	replace SchoolType="Secondary" if Education>21 & ElectionStudy==1973 & Education<.
	replace SchoolType="Old Primary" if inrange(Education,11,14 ) & ElectionStudy==1976 
	replace SchoolType="New Primary" if Education==21 & ElectionStudy==1976 
	replace SchoolType="Secondary" if Education>21 & Education<.
	
	replace SchoolType="Old Primary" if Education==1 & ElectionStudy==1982 
	replace SchoolType="New Primary" if Education==3 & ElectionStudy==1982 
	replace SchoolType="Secondary" if Education>3  & ElectionStudy==1982 & Education<8
	replace SchoolType="Old Primary" if Education==1 & ElectionStudy==1985 
	replace SchoolType="New Primary" if Education==3 & ElectionStudy==1985 
	replace SchoolType="Secondary" if Education>3  & ElectionStudy==1985 & Education<8
	replace SchoolType="Old Primary" if Education==1 & ElectionStudy==1988 
	replace SchoolType="New Primary" if Education==2 & ElectionStudy==1988 
	replace SchoolType="Secondary" if Education>3  & ElectionStudy==1988 & Education<8
	replace SchoolType="Old Primary" if Education==1 & ElectionStudy==1991 
	replace SchoolType="New Primary" if Education==2 & ElectionStudy==1991 
	replace SchoolType="Secondary" if Education>3  & ElectionStudy==1991 & Education<8
	replace SchoolType="Old Primary" if Education==1 & ElectionStudy==1994 
	replace SchoolType="New Primary" if Education==2 & ElectionStudy==1994 
	replace SchoolType="Secondary" if Education>3  & ElectionStudy==1994 & Education<8
	replace SchoolType="Old Primary" if Education==1 & ElectionStudy==1998 
	replace SchoolType="New Primary" if Education==2 & ElectionStudy==1998 
	replace SchoolType="Secondary" if Education>3  & ElectionStudy==1998 & Education<8
	replace SchoolType="Old Primary" if Education==1 & ElectionStudy==2002 
	replace SchoolType="New Primary" if Education==2 & ElectionStudy==2002 
	replace SchoolType="Secondary" if Education>3  & ElectionStudy==2002 & Education<8
	replace SchoolType="Old Primary" if Education==1 & ElectionStudy==2006 
	replace SchoolType="New Primary" if Education==2 & ElectionStudy==2006 
	replace SchoolType="Secondary" if Education>3  & ElectionStudy==2006 & Education<8
	
	replace SchoolType="Old Primary" if (Education==1 | (Education==2 & UtbSun<200)) & ElectionStudy==2010 
	replace SchoolType="New Primary" if (Education==2 & UtbSun>200) & ElectionStudy==2010 
	replace SchoolType="Secondary" if Education>3  & ElectionStudy==2010 & Education<13

	gen nSchoolType=1 if SchoolType=="Old Primary"
	replace nSchoolType=2 if SchoolType=="New Primary"
	replace nSchoolType=3 if SchoolType=="Secondary"
	label define skola 1 "Old Primary" 2 "New Primary" 3 "Secondary"
	label values nSchoolType skola 
	
//For the period 1991-2010 we can identify foreign-born individuals. Before that
//we simply have to assume that all people were born and went to school in Sweden,
//although data for later years indicate that about 3 percent of the respondents
//were born abroad. 
	replace BirthPlace=. if BirthPlace==7 & ElectionStudy==1976 //Recode 2 obs in 1976 to missing
	gen Immigrated=(BirthPlace>4) if BirthPlace<. & ElectionStudy!=1991
	replace Immigrated=1 if ElectionStudy==1991 & BirthPlace>25 & BirthPlace<.
	replace Immigrated=0 if ElectionStudy==1991 & BirthPlace<26
	replace Immigrated=0 if BirthPlace==.
	
//Recode political network to vary between 0 and 1 and higher values indicating more politically active networks
	replace PolNetwork=(5-PolNetwork)/4 if PolNetwork<5
	replace PolNetwork=. if PolNetwork>4
	
//Recode political interest to vary between 0 and 1 and higher values indicating higher political interest
	replace PolIntr=(5-PolIntr)/4 if PolIntr<5
	replace PolIntr=. if PolIntr>4

//Generate indicator for whether respondent is male	
	gen Male=-1*Gender+2
	
//Keep the variables that will be used in the analyses.
	keep IDnumber PolInt SchoolType nSchoolType Male ElectionStudy BirthYear Immigrated PolKnowledge PolNetwork
	
//Keep only the cohorts born between 1943 and 1955
	keep if inrange(BirthYear, 1943, 1955)
	
	label var Male "Is R male?"  
	label var BirthYear "Year of birth" 
	label var PolIntr "Political interest" 
	label var PolNetwork "Political network" 
	label var PolKnowledge "Political knowledge" 
	label var ElectionStudy "Year of election study" 
	label var SchoolType "Type of school" 
	label var nSchoolType "Numeric type of school" 
	label var Immigrated "Is R born abroad?"
	
	cd "C:/Users/lindgren_ko/Dropbox/Swedish Reform/GRRPaper/AJPSSub/AJPSRevision/AcceptedManuscript/ReplicationFiles/SNESAnalysis"	
	order IDnumber ElectionStudy
	save ajps-DataTable4a, replace	
	
	
	
