*----------------------------------------------------------------------------------------*
*	Paper:			Dualization and electoral realignment
*	Author:		    Silja HŠusermann
*	Version:		June 18th 2018
*	Data:			European Social Survey Data rounds 1-5
*----------------------------------------------------------------------------------------*

*----------------------------------------------------------------------------------------*
*---------------------------------- TABLE OF CONTENTS -----------------------------------*
*----------------------------------------------------------------------------------------*

* 1. prepare/recode ESS1
* 2. prepare/recode ESS2
* 3. prepare/recode ESS3
* 4. prepare/recode ESS4
* 5. prepare/recode ESS5
* 6. Merge into 1 file
* 7. Analysis - frequencies, table 1
* 8. Analysis - participation and partyvote, table 2



*----------------------------------------------------------------------------------------*
*	1. prepare/recode ESS1
*----------------------------------------------------------------------------------------*

*----------------------------------------------------------------------------------------*
*	1. Operationalization of variables, round 1
*----------------------------------------------------------------------------------------*
* Basic commands
clear all
set mem 1g
set more off
capture log close

* Import dataset (from ESS website)

use ESS1e06_4.dta


*	1.0 country selection: 
* AT, BE, CH, GE, DK, SP, FIN, FR, UK, GR, IE, IT, NL, NO, PT, SE
 
drop if cntry=="CZ"
drop if cntry=="HU"
drop if cntry=="LU"
drop if cntry=="PL"
drop if cntry=="SI"
drop if cntry=="IL"

gen at=cntry=="AT"
lab var at "Country dummy Austria"
gen be=cntry=="BE"
lab var be "Country dummy Belgium"
gen ch=cntry=="CH"
lab var ch "Country dummy Switzerland"
gen de=cntry=="DE"
lab var de "Country dummy Germany"
gen dk=cntry=="DK"
lab var dk "Country dummy Denmark"
gen es=cntry=="ES"
lab var es "Country dummy Spain"
gen fi=cntry=="FI"
lab var fi "Country dummy Finland"
gen fr=cntry=="FR"
lab var fr "Country dummy France"
gen gb=cntry=="GB"
lab var gb "Country dummy United Kingdom"
gen gr=cntry=="GR"
lab var gr "Country dummy Greece"
gen ie=cntry=="IE"
lab var ie "Country dummy Ireland"
gen it=cntry=="IT"
lab var it "Country dummy Italy"
gen nl=cntry=="NL"
lab var nl "Country dummy Netherlands"
gen no=cntry=="NO"
lab var no "Country dummy Norway"
gen pt=cntry=="PT"
lab var pt "Country dummy Portugal"
gen se=cntry=="SE"
lab var se "Country dummy Sweden"


*******************************
*   1.1 GLOBALIZATION LOSERS
*******************************

** from Rommel/Walter 2017: combination of offshoreable and low-skill (educlvl und offshore2)

* Creation of variable
gen educyrs=eduyrs
lab var educyrs "Years of Education"
* Recoding of variable
replace educyrs=25 if eduyrs>25 & eduyrs<.


* Creation of variable
gen educlvl=edulvla
lab var educlvl "Education level"
* Recoding of variable and definition of value label
recode educlvl (55=.)
label define educlvl 1 "Less than lower secondary education" ///
	2 "Lower secondary education completed" ///
	3 "Upper secondary education completed" ///
	4 "Post-secondary, non-tertiary education completed" ///
	5 "Tertiary education completed"
label values educlvl educlvl


*** Creation of 4-digit ISCO-Code
gen isco=iscoco
lab var isco "4-digit ISCO-code"

*** Metric offshoreability variable	
* Creation of variable
gen offshore=.
replace offshore=0 if isco<.
replace offshore=49 if isco==1142
replace offshore=55 if isco==1222
replace offshore=28 if isco==1226
replace offshore=55 if isco==1228
replace offshore=83 if isco==1231
replace offshore=49 if isco==1232
replace offshore=40 if isco==1233
replace offshore=53 if isco==1234
replace offshore=49 if isco==1235
replace offshore=55 if isco==1236
replace offshore=55 if isco==1237
replace offshore=55 if isco==1311
replace offshore=55 if isco==1312
replace offshore=55 if isco==1313
replace offshore=55 if isco==1314
replace offshore=55 if isco==1315
replace offshore=48 if isco==1316
replace offshore=52 if isco==1317
replace offshore=55 if isco==1318
replace offshore=55 if isco==1319
replace offshore=66 if isco==2111
replace offshore=74 if isco==2112
replace offshore=66 if isco==2113
replace offshore=66 if isco==2114
replace offshore=89 if isco==2121
replace offshore=96 if isco==2122
replace offshore=83 if isco==2131
replace offshore=90 if isco==2139
replace offshore=25 if isco==2141
replace offshore=64 if isco==2143
replace offshore=74 if isco==2144
replace offshore=72 if isco==2146
replace offshore=69 if isco==2147
replace offshore=86 if isco==2148
replace offshore=71 if isco==2149
replace offshore=81 if isco==2211
replace offshore=83 if isco==2212
replace offshore=72 if isco==2411
replace offshore=50 if isco==2419
replace offshore=74 if isco==2421
replace offshore=67 if isco==2444
replace offshore=90 if isco==2451
replace offshore=78 if isco==2452
replace offshore=25 if isco==2453
replace offshore=48 if isco==2455
replace offshore=47 if isco==3111
replace offshore=47 if isco==3113
replace offshore=47 if isco==3114
replace offshore=72 if isco==3115
replace offshore=47 if isco==3116
replace offshore=94 if isco==3118
replace offshore=54 if isco==3119
replace offshore=75 if isco==3121
replace offshore=84 if isco==3122
replace offshore=68 if isco==3123
replace offshore=36 if isco==3131
replace offshore=36 if isco==3132
replace offshore=46 if isco==3133
replace offshore=34 if isco==3139
replace offshore=52 if isco==3141
replace offshore=60 if isco==3152
replace offshore=55 if isco==3211
replace offshore=55 if isco==3212
replace offshore=44 if isco==3213
replace offshore=32 if isco==3228
replace offshore=51 if isco==3411
replace offshore=85 if isco==3412
replace offshore=50 if isco==3414
replace offshore=55 if isco==3416
replace offshore=59 if isco==3419
replace offshore=51 if isco==3421
replace offshore=48 if isco==3422
replace offshore=38 if isco==3431
replace offshore=51 if isco==3432
replace offshore=84 if isco==3433
replace offshore=84 if isco==3434
replace offshore=54 if isco==3439
replace offshore=100 if isco==3442
replace offshore=85 if isco==3471
replace offshore=30 if isco==3472
replace offshore=95 if isco==4111
replace offshore=94 if isco==4112
replace offshore=100 if isco==4113
replace offshore=71 if isco==4114
replace offshore=38 if isco==4115
replace offshore=84 if isco==4121
replace offshore=54 if isco==4122
replace offshore=31 if isco==4131
replace offshore=67 if isco==4132
replace offshore=67 if isco==4133
replace offshore=46 if isco==4141
replace offshore=26 if isco==4142
replace offshore=95 if isco==4143
replace offshore=54 if isco==4144
replace offshore=54 if isco==4190
replace offshore=94 if isco==4211
replace offshore=54 if isco==4214
replace offshore=65 if isco==4215
replace offshore=72 if isco==4221
replace offshore=54 if isco==4222
replace offshore=50 if isco==4223
replace offshore=86 if isco==5113
replace offshore=59 if isco==6142
replace offshore=36 if isco==7111
replace offshore=35 if isco==7112
replace offshore=36 if isco==7113
replace offshore=65 if isco==7211
replace offshore=69 if isco==7212
replace offshore=70 if isco==7213
replace offshore=70 if isco==7222
replace offshore=68 if isco==7223
replace offshore=68 if isco==7224
replace offshore=26 if isco==7311
replace offshore=64 if isco==7313
replace offshore=69 if isco==7321
replace offshore=69 if isco==7322
replace offshore=68 if isco==7323
replace offshore=68 if isco==7324
replace offshore=60 if isco==7331
replace offshore=75 if isco==7332
replace offshore=59 if isco==7341
replace offshore=59 if isco==7342
replace offshore=59 if isco==7343
replace offshore=34 if isco==7344
replace offshore=59 if isco==7345
replace offshore=75 if isco==7346
replace offshore=68 if isco==7413
replace offshore=27 if isco==7414
replace offshore=55 if isco==7415
replace offshore=43 if isco==7421
replace offshore=57 if isco==7422
replace offshore=57 if isco==7423
replace offshore=66 if isco==7424
replace offshore=75 if isco==7431
replace offshore=75 if isco==7432
replace offshore=75 if isco==7433
replace offshore=73 if isco==7434
replace offshore=75 if isco==7435
replace offshore=75 if isco==7436
replace offshore=57 if isco==7437
replace offshore=75 if isco==7441
replace offshore=72 if isco==7442
replace offshore=36 if isco==8111
replace offshore=36 if isco==8112
replace offshore=36 if isco==8113
replace offshore=59 if isco==8121
replace offshore=68 if isco==8122
replace offshore=70 if isco==8123
replace offshore=68 if isco==8124
replace offshore=69 if isco==8131
replace offshore=68 if isco==8139
replace offshore=57 if isco==8141
replace offshore=68 if isco==8142
replace offshore=68 if isco==8143
replace offshore=68 if isco==8151
replace offshore=70 if isco==8152
replace offshore=68 if isco==8153
replace offshore=68 if isco==8154
replace offshore=29 if isco==8155
replace offshore=68 if isco==8159
replace offshore=42 if isco==8161
replace offshore=55 if isco==8162
replace offshore=29 if isco==8163
replace offshore=64 if isco==8171
replace offshore=68 if isco==8172
replace offshore=68 if isco==8211
replace offshore=68 if isco==8212
replace offshore=68 if isco==8221
replace offshore=35 if isco==8222
replace offshore=68 if isco==8223
replace offshore=41 if isco==8224
replace offshore=29 if isco==8229
replace offshore=69 if isco==8231
replace offshore=68 if isco==8232
replace offshore=57 if isco==8240
replace offshore=58 if isco==8251
replace offshore=59 if isco==8252
replace offshore=68 if isco==8253
replace offshore=75 if isco==8261
replace offshore=75 if isco==8262
replace offshore=75 if isco==8263
replace offshore=75 if isco==8264
replace offshore=75 if isco==8265
replace offshore=75 if isco==8266
replace offshore=75 if isco==8269
replace offshore=27 if isco==8271
replace offshore=68 if isco==8272
replace offshore=68 if isco==8273
replace offshore=30 if isco==8274
replace offshore=31 if isco==8275
replace offshore=68 if isco==8276
replace offshore=27 if isco==8277
replace offshore=68 if isco==8278
replace offshore=66 if isco==8281
replace offshore=66 if isco==8282
replace offshore=66 if isco==8283
replace offshore=68 if isco==8284
replace offshore=57 if isco==8285
replace offshore=64 if isco==8286
replace offshore=68 if isco==8290
replace offshore=34 if isco==8340
replace offshore=95 if isco==9113
replace offshore=64 if isco==9321
replace offshore=29 if isco==9333
replace offshore=55 if isco==1227
replace offshore=89 if isco==2121
replace offshore=100 if isco==2132
replace offshore=70 if isco==2145
replace offshore=71 if isco==2149
replace offshore=81 if isco==2211
replace offshore=46 if isco==2412
replace offshore=50 if isco==2419
replace offshore=33 if isco==2432
replace offshore=89 if isco==2441
replace offshore=48 if isco==2455
replace offshore=72 if isco==3115
replace offshore=54 if isco==3119
replace offshore=46 if isco==3133
replace offshore=34 if isco==3139
replace offshore=34 if isco==3224
replace offshore=51 if isco==3411
replace offshore=25 if isco==3415
replace offshore=50 if isco==3417
replace offshore=59 if isco==3419
replace offshore=51 if isco==3432
replace offshore=54 if isco==3439
replace offshore=90 if isco==3460
replace offshore=54 if isco==4122
replace offshore=31 if isco==4131
replace offshore=67 if isco==4132
replace offshore=46 if isco==4141
replace offshore=26 if isco==4142
replace offshore=54 if isco==4222
replace offshore=68 if isco==7141
replace offshore=68 if isco==7224
replace offshore=65 if isco==7241
replace offshore=34 if isco==7344
replace offshore=72 if isco==7442
replace offshore=68 if isco==8122
replace offshore=68 if isco==8139
replace offshore=42 if isco==8161
replace offshore=68 if isco==8211
replace offshore=68 if isco==8223
replace offshore=41 if isco==8224
replace offshore=57 if isco==8240
replace offshore=58 if isco==8251
replace offshore=75 if isco==8269
replace offshore=66 if isco==8281
replace offshore=66 if isco==8283
replace offshore=68 if isco==8284
replace offshore=68 if isco==8290
replace offshore=70 if isco==9322
lab var offshore "Offshoring Potential (Blinder 2007), metric"

*** Creation of ordinal (4-point scale) offshoreability variable
* Creation of variable
gen offshore4=.
replace offshore4=4 if offshore<.
replace offshore4=3 if offshore<75
replace offshore4=2 if offshore<50
replace offshore4=1 if offshore<25
lab var offshore4 "Offshoring Potential (Blinder 2007), ordinal"
* Definition of value label
lab define offshore4 1 "0-24%" 2 "5-49%" 3 "50-74%" 4 "75-100%"
lab values offshore4 offshore4

*** Creation of dichotomous offshoreability variable
* Creation of variable
gen offshore2=.
replace offshore2=1 if offshore>0 & offshore<.
replace offshore2=0 if offshore==0
lab var offshore2 "Offshoring Potential (Blinder 2007), dichotomous"
* Definition of value label
lab define offshore2 0 "Not offshoreable" 1 "Offshoreable"
lab values offshore2 offshore2

***********************

*** Creation of globalization loser variable 1 : low-skilled offshoreable
* Creation of variable
gen glob_losers1=.
replace glob_losers1=1 if offshore2==1 & educlvl<3
replace glob_losers1=0 if offshore2==0 & educlvl<3
replace glob_losers1=0 if offshore2==1 & educlvl>2
replace glob_losers1=0 if offshore2==0 & educlvl>2
lab var glob_losers1 "Globalization losers; lowskilled exposed "
* Definition of value label
lab define glob_losers1 1 "glob loser (l-s off)" 0 "not loser"
lab values glob_losers1 glob_losers1

*** Creation of winner variable 1: low-skilled sheltered
* Creation of variable
gen glob_winners1=.
replace glob_winners1 =0 if offshore2==1 & educlvl<3
replace glob_winners1 =1 if offshore2==0 & educlvl<3
replace glob_winners1 =0 if offshore2==1 & educlvl>2
replace glob_winners1 =0 if offshore2==0 & educlvl>2
lab var glob_winners1 "Globalization winners; lowskilled sheltered "
* Definition of value label
lab define glob_winners1 1 "glob winners (l-s sheltered)" 0 "not winner"
lab values glob_winners1 glob_losers1



************************************
*	1.2 MODERNIZATION LOSERS

* Oesch 16-classes for respondents only, code from his website  http://people.unil.ch/danieloesch/

****************************************************************************************
* Respondent's Oesch class position
* Recode and create variables used to construct class variable for respondents
* Variables used to construct class variable for respondents: iscoco, emplrel, emplno
****************************************************************************************

**** Recode occupation variable (isco88 com 4-digit) for respondents

tab iscoco

recode iscoco (66666 77777 88888 99999=-9), copyrest gen(isco_mainjob)
label variable isco_mainjob "Current occupation of respondent - isco88 4-digit"
tab isco_mainjob

**** Recode employment status for respondents

tab emplrel

recode emplrel (6 7 8 9=9), copyrest gen(emplrel_r)
replace emplrel_r=-9 if cntry=="FR" & (essround==1 | essround==2) // Replace this command line with [SYNTAX A] or [SYNTAX C]
replace emplrel_r=-9 if cntry=="HU" & essround==2 // Replace this command line with [SYNTAX E]
label define emplrel_r ///
1 "Employee" ///
2 "Self-employed" ///
3 "Working for own family business" ///
9 "Missing"
label value emplrel_r emplrel_r
tab emplrel_r

tab emplno

recode emplno (0 66666 77777 88888 99999=0)(1/9=1)(10/10000=2), gen(emplno_r)
label define emplno_r ///
0 "0 employees" ///
1 "1-9 employees" ///
2 "10+ employees"
label value emplno_r emplno_r
tab emplno_r


gen selfem_mainjob=.
replace selfem_mainjob=1 if emplrel_r==1 | emplrel_r==9
replace selfem_mainjob=2 if emplrel_r==2 & emplno_r==0
replace selfem_mainjob=2 if emplrel_r==3
replace selfem_mainjob=3 if emplrel_r==2 & emplno_r==1
replace selfem_mainjob=4 if emplrel_r==2 & emplno_r==2
label variable selfem_mainjob "Employment status for respondants"
label define selfem_mainjob ///
1 "Not self-employed" ///
2 "Self-empl without employees" ///
3 "Self-empl with 1-9 employees" ///
4 "Self-empl with 10 or more"
label value selfem_mainjob selfem_mainjob
tab selfem_mainjob



* Create Oesch class schema for respondents


gen class16_r = -9

* Large employers (1)

replace class16_r=1 if selfem_mainjob==4


* Self-employed professionals (2)

replace class16_r=2 if (selfem_mainjob==2 | selfem_mainjob==3) & (isco_mainjob >= 2000 & isco_mainjob <= 2229) 
replace class16_r=2 if (selfem_mainjob==2 | selfem_mainjob==3) & (isco_mainjob >= 2300 & isco_mainjob <= 2470)

* Small business owners with employees (3)

replace class16_r=3 if (selfem_mainjob==3) & (isco_mainjob >= 1000 & isco_mainjob <= 1999)
replace class16_r=3 if (selfem_mainjob==3) & (isco_mainjob >= 3000 & isco_mainjob <= 9333)
replace class16_r=3 if (selfem_mainjob==3) & (isco_mainjob == 2230)

* Small business owners without employees (4)

replace class16_r=4 if (selfem_mainjob==2) & (isco_mainjob >= 1000 & isco_mainjob <= 1999)
replace class16_r=4 if (selfem_mainjob==2) & (isco_mainjob >= 3000 & isco_mainjob <= 9333)
replace class16_r=4 if (selfem_mainjob==2) & (isco_mainjob == 2230)

* Technical experts (5)

replace class16_r=5 if (selfem_mainjob==1) & (isco_mainjob >= 2100 & isco_mainjob <= 2213)

* Technicians (6)

replace class16_r=6 if (selfem_mainjob==1) & (isco_mainjob >= 3100 & isco_mainjob <= 3152)
replace class16_r=6 if (selfem_mainjob==1) & (isco_mainjob >= 3210 & isco_mainjob <= 3213)
replace class16_r=6 if (selfem_mainjob==1) & (isco_mainjob == 3434)

* Skilled manual (7)

replace class16_r=7 if (selfem_mainjob==1) & (isco_mainjob >= 6000 & isco_mainjob <= 7442)
replace class16_r=7 if (selfem_mainjob==1) & (isco_mainjob >= 8310 & isco_mainjob <= 8312)
replace class16_r=7 if (selfem_mainjob==1) & (isco_mainjob >= 8324 & isco_mainjob <= 8330)
replace class16_r=7 if (selfem_mainjob==1) & (isco_mainjob >= 8332 & isco_mainjob <= 8340)

* Low-skilled manual (8)

replace class16_r=8 if (selfem_mainjob==1) & (isco_mainjob >= 8000 & isco_mainjob <= 8300)
replace class16_r=8 if (selfem_mainjob==1) & (isco_mainjob >= 8320 & isco_mainjob <= 8321)
replace class16_r=8 if (selfem_mainjob==1) & (isco_mainjob == 8331)
replace class16_r=8 if (selfem_mainjob==1) & (isco_mainjob >= 9153 & isco_mainjob <= 9333)

* Higher-grade managers and administrators (9)

replace class16_r=9 if (selfem_mainjob==1) & (isco_mainjob >= 1000 & isco_mainjob <= 1239)
replace class16_r=9 if (selfem_mainjob==1) & (isco_mainjob >= 2400 & isco_mainjob <= 2429)
replace class16_r=9 if (selfem_mainjob==1) & (isco_mainjob == 2441)
replace class16_r=9 if (selfem_mainjob==1) & (isco_mainjob == 2470)

* Lower-grade managers and administrators (10)

replace class16_r=10 if (selfem_mainjob==1) & (isco_mainjob >= 1300 & isco_mainjob <= 1319)
replace class16_r=10 if (selfem_mainjob==1) & (isco_mainjob >= 3400 & isco_mainjob <= 3433)
replace class16_r=10 if (selfem_mainjob==1) & (isco_mainjob >= 3440 & isco_mainjob <= 3450)

* Skilled clerks (11)

replace class16_r=11 if (selfem_mainjob==1) & (isco_mainjob >= 4000 & isco_mainjob <= 4112)
replace class16_r=11 if (selfem_mainjob==1) & (isco_mainjob >= 4114 & isco_mainjob <= 4210)
replace class16_r=11 if (selfem_mainjob==1) & (isco_mainjob >= 4212 & isco_mainjob <= 4222)

* Unskilled clerks (12)

replace class16_r=12 if (selfem_mainjob==1) & (isco_mainjob == 4113)
replace class16_r=12 if (selfem_mainjob==1) & (isco_mainjob == 4211)
replace class16_r=12 if (selfem_mainjob==1) & (isco_mainjob == 4223)

* Socio-cultural professionals (13)

replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob >= 2220 &  isco_mainjob <= 2229)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob >= 2300 &  isco_mainjob <= 2320)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob >= 2340 &  isco_mainjob <= 2359)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob >= 2430 &  isco_mainjob <= 2440)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob >= 2442 &  isco_mainjob <= 2443)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob == 2445)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob == 2451)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob == 2460)

* Socio-cultural semi-professionals (14)

replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob == 2230)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob >= 2330 & isco_mainjob <= 2332)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob == 2444)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob >= 2446 & isco_mainjob <= 2450)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob >= 2452 & isco_mainjob <= 2455)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob == 3200)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob >= 3220 & isco_mainjob <= 3224)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob == 3226)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob >= 3229 & isco_mainjob <= 3340)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob >= 3460 & isco_mainjob <= 3472)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob == 3480)

* Skilled service (15)

replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob == 3225)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob >= 3227 & isco_mainjob <= 3228)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob >= 3473 & isco_mainjob <= 3475)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob >= 5000 & isco_mainjob <= 5113)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob == 5122)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob >= 5131 & isco_mainjob <= 5132)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob >= 5140 & isco_mainjob <= 5141)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob == 5143)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob >= 5160 & isco_mainjob <= 5220)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob == 8323)

* Low-skilled service (16)

replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob >= 5120 & isco_mainjob <= 5121)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob >= 5123 & isco_mainjob <= 5130)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob >= 5133 & isco_mainjob <= 5139)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob == 5142)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob == 5149)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob == 5230)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob == 8322)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob >= 9100 &  isco_mainjob <= 9152)

mvdecode class16_r, mv(-9)
label variable class16_r "Respondent's Oesch class position - 16 classes"
label define class16_r ///
1 "Large employers" ///
2 "Self-employed professionals" ///
3 "Small business owners with employees" ///
4 "Small business owners without employees" ///
5 "Technical experts" ///
6 "Technicians" ///
7 "Skilled manual" ///
8 "Low-skilled manual" ///
9 "Higher-grade managers and administrators" ///
10 "Lower-grade managers and administrators" ///
11 "Skilled clerks" ///
12 "Unskilled clerks" ///
13 "Socio-cultural professionals" ///
14 "Socio-cultural semi-professionals" ///
15 "Skilled service" ///
16 "Low-skilled service"
label value class16_r class16_r
tab class16_r

recode class16_r (1 2=1)(3 4=2)(5 6=3)(7 8=4)(9 10=5)(11 12=6)(13 14=7)(15 16=8), gen(class8_r)
label variable class8_r "Respondent's Oesch class position - 8 classes"
label define class8_r ///
1 "Self-employed professionals and large employers" ///
2 "Small business owners" ///
3 "Technical (semi-)professionals" ///
4 "Production workers" ///
5 "(Associate) managers" ///
6 "Clerks" ///
7 "Socio-cultural (semi-)professionals" ///
8 "Service workers"
label value class8_r class8_r
tab class8_r


*** Aggregated sector variable (from Rommel and Walter)
* Creation of variable
gen sector=.
replace sector=1 if nace==1 | nace==2 | nace==5
replace sector=2 if nace==10 | nace==11 | nace==12 | nace==13 | nace==14
replace sector=3 if nace==15 | nace==16 | nace==17 | nace==18 | nace==19 | nace==20 ///
	 | nace==21 | nace==22 | nace==23 | nace==24 | nace==25 | nace==26 | nace==27 ///
	 | nace==28 | nace==29 | nace==30 | nace==31 | nace==32 | nace==33 | nace==34 ///
	 | nace==35 | nace==36 | nace==37
replace sector=4 if nace==40 | nace==41
replace sector=5 if nace==45
replace sector=6 if nace==50 | nace==51 | nace==52 | nace==55
replace sector=7 if nace==60 | nace==61 | nace==62 | nace==63 | nace==64
replace sector=8 if nace==65 | nace==66 | nace==67 | nace==70 | nace==71 | nace==72 ///
	 | nace==73 | nace==74
replace sector=9 if nace==75 | nace==80 | nace==85 | nace==90 | nace==91 | nace==92 ///
	 | nace==93 | nace==95 | nace==99
lab var sector "Aggregated sector variable"
* Definition of value label
lab define sector 1 "Agriculture, hunting, forestry and fishing" ///
	2 "Mining and quarrying" ///
	3 "Manufacturing" ///
	4 "Electricity, gas and water" ///
	5 "Construction" ///
	6 "Wholesale and retail trade and restaurants and hotels" ///
	7 "Transport, storage and communications" ///
	8 "Financing, insurance, real estate and busines services" ///
	9 "Community, social and personal services"
lab values sector sector



*** Creation of modernization loser variable 1 : routine service (class 16)
* Creation of variable
gen mod_losers1=.
replace mod_losers1 =1 if class16_r==16
replace mod_losers1 =0 if class16_r!=16
replace mod_losers1=. if class16_r==.

lab var mod_losers1 "Modernization losers 1; routine service oesch "
* Definition of value label
lab define mod_losers1 1 "mod loser (routine service)" 0 "not loser"
lab values mod_losers1 mod_losers1


*** Creation of modernization loser variable 4 : routine and skilled manual (classes 7,8)
* Creation of variable
gen mod_losers4=0
replace mod_losers4 =1 if class16_r==7
replace mod_losers4 =1 if class16_r==8
replace mod_losers4 =. if class16_r==.

lab var mod_losers4 "Modernization losers 4; routine and skilled manual oesch "
* Definition of value label
lab define mod_losers4 1 "mod loser (routine and skilled manual)" 0 "not loser"
lab values mod_losers4 mod_losers4


*** Creation of modernization winner variable 1 : socio-cult prof (13, 14)
* Creation of variable
gen mod_winners1=0
replace mod_winners1 =1 if class16_r==13
replace mod_winners1 =1 if class16_r==14
replace mod_winners1 =. if class16_r==.

lab var mod_winners1 "Modernization winners 1; SCP oesch "
* Definition of value label
lab define mod_winners1 1 "mod winners (SCP oesch)" 0 "not winner"
lab values mod_winners1 mod_winners1


************************************
************************************
*	1.3 lm status: unempl, temp, involunt parttime

*** unemployed in last 5 years
* Creation of variable
gen unemployed5y=uemp5yr==1
lab var unemployed5y "Unemployed in last 5 years"
* Definition of value label
lab define unemployed5y 1 "unemployed in last 5 years" 0 "other"
lab values unemployed5y unemployed5y


*** temporary employed
* Creation of variable
gen temp=wrkctr==2
lab var temp "temporary employed (limited contract)"
* Definition of value label
lab define temp 1 "limited contract" 0 "other"
lab values temp temp


*** part-time
* Creation of variable
gen parttime=wkhct<30
lab var parttime "parttime employed (<30h)"
* Definition of value label
lab define parttime 1 "parttime" 0 "other"
lab values parttime parttime


************************************
************************************
* 	1.4 other variables : country dummies, polint, age, age2, income?, gender, sector?

*** Gender
* Creation of variable
gen gender=gndr
lab var gender "Gender"
* Recoding of variable and definition of value label
recode gender (1=0) (2=1)
lab define gender 0 "male" 1 "female"
lab values gender gender


*** Age
* Creation of variable
gen age=2002-yrbrn
lab var age "Age in years"
gen age2=age^2
lab var age2 "Age in years (squared)"


*** Political interest
* Creation of variable
gen polint=polintr
recode polint (1=4) (2=3) (3=2) (4=1)
lab var polint "Interest in politics"
* Definition of value label
lab define polint 4 "Very interested" 3 "Quite interested" 2 "Hardly interested" ///
	1 "Not at all interested"
lab values polint polint

*** relative income (difference between respondent class and median class per country)
gen inc=hinctnt
sum hinctnt if cntry=="AT", detail
replace inc=hinctnt-r(p50) if cntry=="AT"
sum hinctnt if cntry=="BE", detail
replace inc=hinctnt-r(p50) if cntry=="BE"
sum hinctnt if cntry=="CH", detail
replace inc=hinctnt-r(p50) if cntry=="CH"
sum hinctnt if cntry=="CZ", detail
replace inc=hinctnt-r(p50) if cntry=="CZ"
sum hinctnt if cntry=="DE", detail
replace inc=hinctnt-r(p50) if cntry=="DE"
sum hinctnt if cntry=="DK", detail
replace inc=hinctnt-r(p50) if cntry=="DK"
sum hinctnt if cntry=="EE", detail
replace inc=hinctnt-r(p50) if cntry=="EE"
sum hinctnt if cntry=="ES", detail
replace inc=hinctnt-r(p50) if cntry=="ES"
sum hinctnt if cntry=="FI", detail
replace inc=hinctnt-r(p50) if cntry=="FI"
sum hinctnt if cntry=="FR", detail
replace inc=hinctnt-r(p50) if cntry=="FR"
sum hinctnt if cntry=="GB", detail
replace inc=hinctnt-r(p50) if cntry=="GB"
sum hinctnt if cntry=="GR", detail
replace inc=hinctnt-r(p50) if cntry=="GR"
sum hinctnt if cntry=="HU", detail
replace inc=hinctnt-r(p50) if cntry=="HU"
sum hinctnt if cntry=="IE", detail
replace inc=hinctnt-r(p50) if cntry=="IE"
sum hinctnt if cntry=="IL", detail
replace inc=hinctnt-r(p50) if cntry=="IL"
sum hinctnt if cntry=="IS", detail
replace inc=hinctnt-r(p50) if cntry=="IS"
sum hinctnt if cntry=="IT", detail
replace inc=hinctnt-r(p50) if cntry=="IT"
sum hinctnt if cntry=="LU", detail
replace inc=hinctnt-r(p50) if cntry=="LU"
sum hinctnt if cntry=="NL", detail
replace inc=hinctnt-r(p50) if cntry=="NL"
sum hinctnt if cntry=="NO", detail
replace inc=hinctnt-r(p50) if cntry=="NO"
sum hinctnt if cntry=="PL", detail
replace inc=hinctnt-r(p50) if cntry=="PL"
sum hinctnt if cntry=="PT", detail
replace inc=hinctnt-r(p50) if cntry=="PT"
sum hinctnt if cntry=="SE", detail
replace inc=hinctnt-r(p50) if cntry=="SE"
sum hinctnt if cntry=="SI", detail
replace inc=hinctnt-r(p50) if cntry=="SI"
sum hinctnt if cntry=="SK", detail
replace inc=hinctnt-r(p50) if cntry=="SK"
lab var inc "Income, difference between respondet class and median class per country"

************************************
************************************
*	1.5 Party choice and participation (Rommel&Walter)

*** Partisan preference, last election (not classified parties are missings)
* Creation of variable
gen party_vote=.
label var party_vote "Partisan preference, last election"
* Austria
replace   party_vote=3         if        prtvtat== 1
replace   party_vote=5         if        prtvtat== 2
replace   party_vote=7         if        prtvtat== 3
replace   party_vote=1         if        prtvtat== 4
replace   party_vote=4         if        prtvtat== 5
replace   party_vote=0         if        prtvtat== 6

* Belgium
replace   party_vote=1         if        prtvtbe== 1
replace   party_vote=5         if        prtvtbe== 2
replace   party_vote=3         if        prtvtbe== 3
replace   party_vote=4         if        prtvtbe== 5
replace   party_vote=0         if        prtvtbe== 6
replace   party_vote=.         if        prtvtbe== 7
replace   party_vote=7         if        prtvtbe== 8
replace   party_vote=.         if        prtvtbe== 9
replace   party_vote=1         if        prtvtbe== 11
replace   party_vote=5         if        prtvtbe== 12
replace   party_vote=4         if        prtvtbe== 13
replace   party_vote=3         if        prtvtbe== 14
replace   party_vote=7         if        prtvtbe== 15
replace   party_vote=.         if        prtvtbe== 16
replace   party_vote=0         if        prtvtbe== 17
* Switzerland
replace   party_vote=4         if        prtvtch== 1
replace   party_vote=5         if        prtvtch== 2
replace   party_vote=3         if        prtvtch== 3
replace   party_vote=7         if        prtvtch== 4
replace   party_vote=4         if        prtvtch== 5
replace   party_vote=4         if        prtvtch== 6
replace   party_vote=5         if        prtvtch== 7
replace   party_vote=.         if        prtvtch== 8
replace   party_vote=2         if        prtvtch== 9
replace   party_vote=1         if        prtvtch== 10
replace   party_vote=5         if        prtvtch== 11
replace   party_vote=7         if        prtvtch== 12
replace   party_vote=7         if        prtvtch== 13
replace   party_vote=.         if        prtvtch== 14
replace   party_vote=7         if        prtvtch== 15
replace   party_vote=0         if        prtvtch== 16
* Germany
replace   party_vote=3         if        prtvde1== 1
replace   party_vote=5         if        prtvde1== 2
replace   party_vote=1         if        prtvde1== 3
replace   party_vote=4         if        prtvde1== 4
replace   party_vote=2         if        prtvde1== 5
replace   party_vote=7         if        prtvde1== 6
replace   party_vote=0         if        prtvde1== 7
* Denmark
replace   party_vote=3         if        prtvtdk== 1
replace   party_vote=1         if        prtvtdk== 2
replace   party_vote=6         if        prtvtdk== 3
replace   party_vote=5         if        prtvtdk== 4
replace   party_vote=1         if        prtvtdk== 5
replace   party_vote=7         if        prtvtdk== 6
replace   party_vote=5         if        prtvtdk== 7
replace   party_vote=6         if        prtvtdk== 8
replace   party_vote=7         if        prtvtdk== 9
replace   party_vote=2         if        prtvtdk== 10
replace   party_vote=0         if        prtvtdk== 11
* Spain
replace   party_vote=6         if        prtvtes== 1
replace   party_vote=3         if        prtvtes== 2
replace   party_vote=2         if        prtvtes== 3
replace   party_vote=6         if        prtvtes== 4
replace   party_vote=0         if        prtvtes== 5
replace   party_vote=.         if        prtvtes== 6
replace   party_vote=0         if        prtvtes== 7
replace   party_vote=0         if        prtvtes== 8
replace   party_vote=0         if        prtvtes== 9
replace   party_vote=0         if        prtvtes== 10
replace   party_vote=0         if        prtvtes== 11
replace   party_vote=0         if        prtvtes== 12
replace   party_vote=0         if        prtvtes== 68
* Finland
replace   party_vote=6         if        prtvtfi== 1
replace   party_vote=0         if        prtvtfi== 2
replace   party_vote=4         if        prtvtfi== 3
replace   party_vote=5         if        prtvtfi== 4
replace   party_vote=7         if        prtvtfi== 5
replace   party_vote=5         if        prtvtfi== 6
replace   party_vote=.         if        prtvtfi== 7
replace   party_vote=1         if        prtvtfi== 8
replace   party_vote=3         if        prtvtfi== 9
replace   party_vote=2         if        prtvtfi== 10
replace   party_vote=.         if        prtvtfi== 11
replace   party_vote=.         if        prtvtfi== 12
replace   party_vote=0         if        prtvtfi== 14
* France
replace   party_vote=.         if        prtvtfr== 1
replace   party_vote=4         if        prtvtfr== 2
replace   party_vote=7         if        prtvtfr== 3
replace   party_vote=2         if        prtvtfr== 4
replace   party_vote=2         if        prtvtfr== 5
replace   party_vote=2         if        prtvtfr== 6
replace   party_vote=7         if        prtvtfr== 7
replace   party_vote=.         if        prtvtfr== 8
replace   party_vote=2         if        prtvtfr== 9
replace   party_vote=3         if        prtvtfr== 10
replace   party_vote=.         if        prtvtfr== 11
replace   party_vote=6         if        prtvtfr== 12
replace   party_vote=4         if        prtvtfr== 13
replace   party_vote=1         if        prtvtfr== 14
replace   party_vote=.         if        prtvtfr== 15
replace   party_vote=0         if        prtvtfr== 16
* Great Britain
replace   party_vote=6         if        prtvtgb== 1
replace   party_vote=3         if        prtvtgb== 2
replace   party_vote=4         if        prtvtgb== 3
replace   party_vote=0         if        prtvtgb== 4
replace   party_vote=0         if        prtvtgb== 5
replace   party_vote=.         if        prtvtgb== 6
replace   party_vote=0         if        prtvtgb== 7
replace   party_vote=6         if        prtvtgb== 11
replace   party_vote=0         if        prtvtgb== 12
replace   party_vote=2         if        prtvtgb== 13
replace   party_vote=3         if        prtvtgb== 14
replace   party_vote=.         if        prtvtgb== 15
replace   party_vote=.         if        prtvtgb== 17
replace   party_vote=.         if        prtvtgb== 18
* Greece
replace   party_vote=3         if        prtvtgr== 1
replace   party_vote=6         if        prtvtgr== 2
replace   party_vote=2         if        prtvtgr== 3
replace   party_vote=2         if        prtvtgr== 4
replace   party_vote=3         if        prtvtgr== 5
replace   party_vote=0         if        prtvtgr== 6
* Ireland
replace   party_vote=6         if        prtvtie== 1
replace   party_vote=5         if        prtvtie== 2
replace   party_vote=3         if        prtvtie== 3
replace   party_vote=4         if        prtvtie== 4
replace   party_vote=1         if        prtvtie== 5
replace   party_vote=2         if        prtvtie== 6
replace   party_vote=.         if        prtvtie== 7
replace   party_vote=0         if        prtvtie== 8
* Italy
replace   party_vote=3         if        prtvtit== 1
replace   party_vote=5         if        prtvtit== 2
replace   party_vote=2         if        prtvtit== 3
replace   party_vote=1         if        prtvtit== 4
replace   party_vote=2         if        prtvtit== 7
replace   party_vote=6         if        prtvtit== 8
replace   party_vote=7         if        prtvtit== 9
replace   party_vote=5         if        prtvtit== 10
replace   party_vote=7         if        prtvtit== 11
replace   party_vote=3         if        prtvtit== 12
replace   party_vote=.         if        prtvtit== 13
replace   party_vote=0         if        prtvtit== 14
replace   party_vote=.         if        prtvtit== 15
replace   party_vote=7         if        prtvtit== 16
replace   party_vote=0         if        prtvtit== 17
replace   party_vote=.         if        prtvtit== 70
* Netherlands
replace   party_vote=5         if        prtvtnl== 1
replace   party_vote=3         if        prtvtnl== 2
replace   party_vote=4         if        prtvtnl== 3
replace   party_vote=7         if        prtvtnl== 4
replace   party_vote=4         if        prtvtnl== 5
replace   party_vote=1         if        prtvtnl== 6
replace   party_vote=2         if        prtvtnl== 7
replace   party_vote=5         if        prtvtnl== 8
replace   party_vote=4         if        prtvtnl== 9
replace   party_vote=4         if        prtvtnl== 10
replace   party_vote=0         if        prtvtnl== 11
* Norway
replace   party_vote=.         if        prtvtno== 1
replace   party_vote=2         if        prtvtno== 2
replace   party_vote=3         if        prtvtno== 3
replace   party_vote=4         if        prtvtno== 4
replace   party_vote=5         if        prtvtno== 5
replace   party_vote=5         if        prtvtno== 6
replace   party_vote=6         if        prtvtno== 7
replace   party_vote=7         if        prtvtno== 8
replace   party_vote=.         if        prtvtno== 9
replace   party_vote=0         if        prtvtno== 10
* Portugal
replace   party_vote=2         if        prtvtpt== 1
replace   party_vote=5         if        prtvtpt== 2
replace   party_vote=.         if        prtvtpt== 3
replace   party_vote=2         if        prtvtpt== 5
replace   party_vote=.         if        prtvtpt== 6
replace   party_vote=3         if        prtvtpt== 10
replace   party_vote=5         if        prtvtpt== 11
replace   party_vote=0         if        prtvtpt== 12
replace   party_vote=.         if        prtvtpt== 13
* Sweden
replace   party_vote=5         if        prtvtse== 1
replace   party_vote=4         if        prtvtse== 2
replace   party_vote=5         if        prtvtse== 3
replace   party_vote=1         if        prtvtse== 4
replace   party_vote=6         if        prtvtse== 5
replace   party_vote=3         if        prtvtse== 6
replace   party_vote=2         if        prtvtse== 7
replace   party_vote=0         if        prtvtse== 8

* Definition of value labels
label def party_vote 0 "Other" 1 "Green" 2 "Communist" 3 "Social democratic" ///
	4 "Liberal"	5 "Christian democratic" 6 "Conservative" 7 "Right-Wing"
label val party_vote party_vote


*** Partisan preference, closeness (not classified parties are missings)
* Creation of variable
gen party_close=.
label var party_close "Party closeness"
* Austria
replace   party_close=3         if        prtclat== 1
replace   party_close=5         if        prtclat== 2
replace   party_close=7         if        prtclat== 3
replace   party_close=1         if        prtclat== 4
replace   party_close=4         if        prtclat== 5
replace   party_close=0         if        prtclat== 6

* Belgium
replace   party_close=1         if        prtclbe== 1
replace   party_close=5         if        prtclbe== 2
replace   party_close=3         if        prtclbe== 3
replace   party_close=4         if        prtclbe== 5
replace   party_close=0         if        prtclbe== 6
replace   party_close=.         if        prtclbe== 7
replace   party_close=7         if        prtclbe== 8
replace   party_close=.         if        prtclbe== 9
replace   party_close=1         if        prtclbe== 11
replace   party_close=5         if        prtclbe== 12
replace   party_close=4         if        prtclbe== 13
replace   party_close=3         if        prtclbe== 14
replace   party_close=7         if        prtclbe== 15
replace   party_close=.         if        prtclbe== 16
replace   party_close=0         if        prtclbe== 17
* Switzerland
replace   party_close=4         if        prtclch== 1
replace   party_close=5         if        prtclch== 2
replace   party_close=3         if        prtclch== 3
replace   party_close=7         if        prtclch== 4
replace   party_close=4         if        prtclch== 5
replace   party_close=4         if        prtclch== 6
replace   party_close=5         if        prtclch== 7
replace   party_close=.         if        prtclch== 8
replace   party_close=2         if        prtclch== 9
replace   party_close=1         if        prtclch== 10
replace   party_close=5         if        prtclch== 11
replace   party_close=7         if        prtclch== 12
replace   party_close=7         if        prtclch== 13
replace   party_close=.         if        prtclch== 14
replace   party_close=7         if        prtclch== 15
replace   party_close=0         if        prtclch== 16
* Germany
replace   party_close=3         if        prtclde== 1
replace   party_close=5         if        prtclde== 2
replace   party_close=1         if        prtclde== 3
replace   party_close=4         if        prtclde== 4
replace   party_close=2         if        prtclde== 5
replace   party_close=7         if        prtclde== 6
replace   party_close=0         if        prtclde== 7
* Denmark
replace   party_close=3         if        prtcldk== 1
replace   party_close=1         if        prtcldk== 2
replace   party_close=6         if        prtcldk== 3
replace   party_close=5         if        prtcldk== 4
replace   party_close=1         if        prtcldk== 5
replace   party_close=7         if        prtcldk== 6
replace   party_close=5         if        prtcldk== 7
replace   party_close=6         if        prtcldk== 8
replace   party_close=7         if        prtcldk== 9
replace   party_close=2         if        prtcldk== 10
replace   party_close=0         if        prtcldk== 11
* Spain
replace   party_close=6         if        prtcles== 1
replace   party_close=3         if        prtcles== 2
replace   party_close=2         if        prtcles== 3
replace   party_close=6         if        prtcles== 4
replace   party_close=0         if        prtcles== 5
replace   party_close=.         if        prtcles== 6
replace   party_close=0         if        prtcles== 7
replace   party_close=0         if        prtcles== 8
replace   party_close=0         if        prtcles== 9
replace   party_close=0         if        prtcles== 10
replace   party_close=0         if        prtcles== 11
replace   party_close=0         if        prtcles== 12
replace   party_close=0         if        prtcles== 68
* Finland
replace   party_close=6         if        prtclfi== 1
replace   party_close=0         if        prtclfi== 2
replace   party_close=4         if        prtclfi== 3
replace   party_close=5         if        prtclfi== 4
replace   party_close=7         if        prtclfi== 5
replace   party_close=5         if        prtclfi== 6
replace   party_close=.         if        prtclfi== 7
replace   party_close=1         if        prtclfi== 8
replace   party_close=3         if        prtclfi== 9
replace   party_close=2         if        prtclfi== 10
replace   party_close=.         if        prtclfi== 11
replace   party_close=.         if        prtclfi== 12
replace   party_close=0         if        prtclfi== 14
* France
replace   party_close=.         if        prtclfr== 1
replace   party_close=4         if        prtclfr== 2
replace   party_close=7         if        prtclfr== 3
replace   party_close=2         if        prtclfr== 4
replace   party_close=2         if        prtclfr== 5
replace   party_close=2         if        prtclfr== 6
replace   party_close=7         if        prtclfr== 7
replace   party_close=.         if        prtclfr== 8
replace   party_close=2         if        prtclfr== 9
replace   party_close=3         if        prtclfr== 10
replace   party_close=.         if        prtclfr== 11
replace   party_close=6         if        prtclfr== 12
replace   party_close=4         if        prtclfr== 13
replace   party_close=1         if        prtclfr== 14
replace   party_close=.         if        prtclfr== 15
replace   party_close=0         if        prtclfr== 16
* Great Britain
replace   party_close=6         if        prtclgb== 1
replace   party_close=3         if        prtclgb== 2
replace   party_close=4         if        prtclgb== 3
replace   party_close=0         if        prtclgb== 4
replace   party_close=0         if        prtclgb== 5
replace   party_close=.         if        prtclgb== 6
replace   party_close=0         if        prtclgb== 7
replace   party_close=6         if        prtclgb== 11
replace   party_close=0         if        prtclgb== 12
replace   party_close=2         if        prtclgb== 13
replace   party_close=3         if        prtclgb== 14
replace   party_close=.         if        prtclgb== 15
replace   party_close=.         if        prtclgb== 17
replace   party_close=.         if        prtclgb== 18
* Greece
replace   party_close=3         if        prtclgr== 1
replace   party_close=6         if        prtclgr== 2
replace   party_close=2         if        prtclgr== 3
replace   party_close=2         if        prtclgr== 4
replace   party_close=3         if        prtclgr== 5
replace   party_close=0         if        prtclgr== 6
* Ireland
replace   party_close=6         if        prtclie== 1
replace   party_close=5         if        prtclie== 2
replace   party_close=3         if        prtclie== 3
replace   party_close=4         if        prtclie== 4
replace   party_close=1         if        prtclie== 5
replace   party_close=2         if        prtclie== 6
replace   party_close=.         if        prtclie== 7
replace   party_close=0         if        prtclie== 8
* Italy
replace   party_close=3         if        prtclit== 1
replace   party_close=5         if        prtclit== 2
replace   party_close=2         if        prtclit== 3
replace   party_close=1         if        prtclit== 4
replace   party_close=2         if        prtclit== 7
replace   party_close=6         if        prtclit== 8
replace   party_close=7         if        prtclit== 9
replace   party_close=5         if        prtclit== 10
replace   party_close=7         if        prtclit== 11
replace   party_close=3         if        prtclit== 12
replace   party_close=.         if        prtclit== 13
replace   party_close=0         if        prtclit== 14
replace   party_close=.         if        prtclit== 15
replace   party_close=7         if        prtclit== 16
replace   party_close=0         if        prtclit== 17
replace   party_close=.         if        prtclit== 70
* Netherlands
replace   party_close=5         if        prtclnl== 1
replace   party_close=3         if        prtclnl== 2
replace   party_close=4         if        prtclnl== 3
replace   party_close=7         if        prtclnl== 4
replace   party_close=4         if        prtclnl== 5
replace   party_close=1         if        prtclnl== 6
replace   party_close=2         if        prtclnl== 7
replace   party_close=5         if        prtclnl== 8
replace   party_close=4         if        prtclnl== 9
replace   party_close=4         if        prtclnl== 10
replace   party_close=0         if        prtclnl== 11
* Norway
replace   party_close=.         if        prtclno== 1
replace   party_close=2         if        prtclno== 2
replace   party_close=3         if        prtclno== 3
replace   party_close=4         if        prtclno== 4
replace   party_close=5         if        prtclno== 5
replace   party_close=5         if        prtclno== 6
replace   party_close=6         if        prtclno== 7
replace   party_close=7         if        prtclno== 8
replace   party_close=.         if        prtclno== 9
replace   party_close=0         if        prtclno== 10
* Portugal
replace   party_close=2         if        prtclpt== 1
replace   party_close=5         if        prtclpt== 2
replace   party_close=.         if        prtclpt== 3
replace   party_close=2         if        prtclpt== 5
replace   party_close=.         if        prtclpt== 6
replace   party_close=3         if        prtclpt== 10
replace   party_close=5         if        prtclpt== 11
replace   party_close=0         if        prtclpt== 12
replace   party_close=.         if        prtclpt== 13
* Sweden
replace   party_close=5         if        prtclse== 1
replace   party_close=4         if        prtclse== 2
replace   party_close=5         if        prtclse== 3
replace   party_close=1         if        prtclse== 4
replace   party_close=6         if        prtclse== 5
replace   party_close=3         if        prtclse== 6
replace   party_close=2         if        prtclse== 7
replace   party_close=0         if        prtclse== 8

* Definition of value labels
label def party_close 0 "Other" 1 "Green" 2 "Communist" 3 "Social democratic" ///
	4 "Liberal"	5 "Christian democratic" 6 "Conservative" 7 "Right-Wing"
label val party_close party_close

*** Voter participation
* Creation of variable 
gen voted=vote==1
replace voted=. if vote>2
lab var voted "Voter participation"
* Definition of value label
lab define voted 1 "Voter" 0 "Non-voter"
lab values voted voted

save "ESSrecoded1.dta", replace


*----------------------------------------------------------------------------------------*
*	2. prepare/recode ESS2
*----------------------------------------------------------------------------------------*


*----------------------------------------------------------------------------------------*
*	1. Operationalization of variables, round 2 - 2004
*----------------------------------------------------------------------------------------*
* Basic commands
clear all
set mem 1g
set more off
capture log close

* Import dataset (from ESS website)
use ESS2e03_4.dta



*	1.0 country selection: 
* AT, BE, CH, GE, DK, SP, FIN, FR, UK, GR, IE, IT, NL, NO, PT, SE
 
drop if cntry=="CZ"
drop if cntry=="HU"
drop if cntry=="LU"
drop if cntry=="PL"
drop if cntry=="SI"
drop if cntry=="IL"
drop if cntry=="EE"
drop if cntry=="IS"
drop if cntry=="SK"
drop if cntry=="TR"
drop if cntry=="UA"


gen at=cntry=="AT"
lab var at "Country dummy Austria"
gen be=cntry=="BE"
lab var be "Country dummy Belgium"
gen ch=cntry=="CH"
lab var ch "Country dummy Switzerland"
gen de=cntry=="DE"
lab var de "Country dummy Germany"
gen dk=cntry=="DK"
lab var dk "Country dummy Denmark"
gen es=cntry=="ES"
lab var es "Country dummy Spain"
gen fi=cntry=="FI"
lab var fi "Country dummy Finland"
gen fr=cntry=="FR"
lab var fr "Country dummy France"
gen gb=cntry=="GB"
lab var gb "Country dummy United Kingdom"
gen gr=cntry=="GR"
lab var gr "Country dummy Greece"
gen ie=cntry=="IE"
lab var ie "Country dummy Ireland"
gen it=cntry=="IT"
lab var it "Country dummy Italy"
gen nl=cntry=="NL"
lab var nl "Country dummy Netherlands"
gen no=cntry=="NO"
lab var no "Country dummy Norway"
gen pt=cntry=="PT"
lab var pt "Country dummy Portugal"
gen se=cntry=="SE"
lab var se "Country dummy Sweden"


*******************************
*   1.1 GLOBALIZATION LOSERS
*******************************

** from Rommel /Walter: combination of offshoreable and low-skill (educlvl und offshore2)

* Creation of variable
gen educyrs=eduyrs
lab var educyrs "Years of Education"
* Recoding of variable
replace educyrs=25 if eduyrs>25 & eduyrs<.


***** 2.2 Education level
*----------------------------------------------------------------------------------------*

* Creation of variable
gen educlvl=edulvla
lab var educlvl "Education level"
* Recoding of variable and definition of value label
recode educlvl (55=.)
label define educlvl 1 "Less than lower secondary education" ///
	2 "Lower secondary education completed" ///
	3 "Upper secondary education completed" ///
	4 "Post-secondary, non-tertiary education completed" ///
	5 "Tertiary education completed"
label values educlvl educlvl


*** Creation of 4-digit ISCO-Code
gen isco=iscoco
lab var isco "4-digit ISCO-code"

*** Metric offshoreability variable	
* Creation of variable
gen offshore=.
replace offshore=0 if isco<.
replace offshore=49 if isco==1142
replace offshore=55 if isco==1222
replace offshore=28 if isco==1226
replace offshore=55 if isco==1228
replace offshore=83 if isco==1231
replace offshore=49 if isco==1232
replace offshore=40 if isco==1233
replace offshore=53 if isco==1234
replace offshore=49 if isco==1235
replace offshore=55 if isco==1236
replace offshore=55 if isco==1237
replace offshore=55 if isco==1311
replace offshore=55 if isco==1312
replace offshore=55 if isco==1313
replace offshore=55 if isco==1314
replace offshore=55 if isco==1315
replace offshore=48 if isco==1316
replace offshore=52 if isco==1317
replace offshore=55 if isco==1318
replace offshore=55 if isco==1319
replace offshore=66 if isco==2111
replace offshore=74 if isco==2112
replace offshore=66 if isco==2113
replace offshore=66 if isco==2114
replace offshore=89 if isco==2121
replace offshore=96 if isco==2122
replace offshore=83 if isco==2131
replace offshore=90 if isco==2139
replace offshore=25 if isco==2141
replace offshore=64 if isco==2143
replace offshore=74 if isco==2144
replace offshore=72 if isco==2146
replace offshore=69 if isco==2147
replace offshore=86 if isco==2148
replace offshore=71 if isco==2149
replace offshore=81 if isco==2211
replace offshore=83 if isco==2212
replace offshore=72 if isco==2411
replace offshore=50 if isco==2419
replace offshore=74 if isco==2421
replace offshore=67 if isco==2444
replace offshore=90 if isco==2451
replace offshore=78 if isco==2452
replace offshore=25 if isco==2453
replace offshore=48 if isco==2455
replace offshore=47 if isco==3111
replace offshore=47 if isco==3113
replace offshore=47 if isco==3114
replace offshore=72 if isco==3115
replace offshore=47 if isco==3116
replace offshore=94 if isco==3118
replace offshore=54 if isco==3119
replace offshore=75 if isco==3121
replace offshore=84 if isco==3122
replace offshore=68 if isco==3123
replace offshore=36 if isco==3131
replace offshore=36 if isco==3132
replace offshore=46 if isco==3133
replace offshore=34 if isco==3139
replace offshore=52 if isco==3141
replace offshore=60 if isco==3152
replace offshore=55 if isco==3211
replace offshore=55 if isco==3212
replace offshore=44 if isco==3213
replace offshore=32 if isco==3228
replace offshore=51 if isco==3411
replace offshore=85 if isco==3412
replace offshore=50 if isco==3414
replace offshore=55 if isco==3416
replace offshore=59 if isco==3419
replace offshore=51 if isco==3421
replace offshore=48 if isco==3422
replace offshore=38 if isco==3431
replace offshore=51 if isco==3432
replace offshore=84 if isco==3433
replace offshore=84 if isco==3434
replace offshore=54 if isco==3439
replace offshore=100 if isco==3442
replace offshore=85 if isco==3471
replace offshore=30 if isco==3472
replace offshore=95 if isco==4111
replace offshore=94 if isco==4112
replace offshore=100 if isco==4113
replace offshore=71 if isco==4114
replace offshore=38 if isco==4115
replace offshore=84 if isco==4121
replace offshore=54 if isco==4122
replace offshore=31 if isco==4131
replace offshore=67 if isco==4132
replace offshore=67 if isco==4133
replace offshore=46 if isco==4141
replace offshore=26 if isco==4142
replace offshore=95 if isco==4143
replace offshore=54 if isco==4144
replace offshore=54 if isco==4190
replace offshore=94 if isco==4211
replace offshore=54 if isco==4214
replace offshore=65 if isco==4215
replace offshore=72 if isco==4221
replace offshore=54 if isco==4222
replace offshore=50 if isco==4223
replace offshore=86 if isco==5113
replace offshore=59 if isco==6142
replace offshore=36 if isco==7111
replace offshore=35 if isco==7112
replace offshore=36 if isco==7113
replace offshore=65 if isco==7211
replace offshore=69 if isco==7212
replace offshore=70 if isco==7213
replace offshore=70 if isco==7222
replace offshore=68 if isco==7223
replace offshore=68 if isco==7224
replace offshore=26 if isco==7311
replace offshore=64 if isco==7313
replace offshore=69 if isco==7321
replace offshore=69 if isco==7322
replace offshore=68 if isco==7323
replace offshore=68 if isco==7324
replace offshore=60 if isco==7331
replace offshore=75 if isco==7332
replace offshore=59 if isco==7341
replace offshore=59 if isco==7342
replace offshore=59 if isco==7343
replace offshore=34 if isco==7344
replace offshore=59 if isco==7345
replace offshore=75 if isco==7346
replace offshore=68 if isco==7413
replace offshore=27 if isco==7414
replace offshore=55 if isco==7415
replace offshore=43 if isco==7421
replace offshore=57 if isco==7422
replace offshore=57 if isco==7423
replace offshore=66 if isco==7424
replace offshore=75 if isco==7431
replace offshore=75 if isco==7432
replace offshore=75 if isco==7433
replace offshore=73 if isco==7434
replace offshore=75 if isco==7435
replace offshore=75 if isco==7436
replace offshore=57 if isco==7437
replace offshore=75 if isco==7441
replace offshore=72 if isco==7442
replace offshore=36 if isco==8111
replace offshore=36 if isco==8112
replace offshore=36 if isco==8113
replace offshore=59 if isco==8121
replace offshore=68 if isco==8122
replace offshore=70 if isco==8123
replace offshore=68 if isco==8124
replace offshore=69 if isco==8131
replace offshore=68 if isco==8139
replace offshore=57 if isco==8141
replace offshore=68 if isco==8142
replace offshore=68 if isco==8143
replace offshore=68 if isco==8151
replace offshore=70 if isco==8152
replace offshore=68 if isco==8153
replace offshore=68 if isco==8154
replace offshore=29 if isco==8155
replace offshore=68 if isco==8159
replace offshore=42 if isco==8161
replace offshore=55 if isco==8162
replace offshore=29 if isco==8163
replace offshore=64 if isco==8171
replace offshore=68 if isco==8172
replace offshore=68 if isco==8211
replace offshore=68 if isco==8212
replace offshore=68 if isco==8221
replace offshore=35 if isco==8222
replace offshore=68 if isco==8223
replace offshore=41 if isco==8224
replace offshore=29 if isco==8229
replace offshore=69 if isco==8231
replace offshore=68 if isco==8232
replace offshore=57 if isco==8240
replace offshore=58 if isco==8251
replace offshore=59 if isco==8252
replace offshore=68 if isco==8253
replace offshore=75 if isco==8261
replace offshore=75 if isco==8262
replace offshore=75 if isco==8263
replace offshore=75 if isco==8264
replace offshore=75 if isco==8265
replace offshore=75 if isco==8266
replace offshore=75 if isco==8269
replace offshore=27 if isco==8271
replace offshore=68 if isco==8272
replace offshore=68 if isco==8273
replace offshore=30 if isco==8274
replace offshore=31 if isco==8275
replace offshore=68 if isco==8276
replace offshore=27 if isco==8277
replace offshore=68 if isco==8278
replace offshore=66 if isco==8281
replace offshore=66 if isco==8282
replace offshore=66 if isco==8283
replace offshore=68 if isco==8284
replace offshore=57 if isco==8285
replace offshore=64 if isco==8286
replace offshore=68 if isco==8290
replace offshore=34 if isco==8340
replace offshore=95 if isco==9113
replace offshore=64 if isco==9321
replace offshore=29 if isco==9333
replace offshore=55 if isco==1227
replace offshore=89 if isco==2121
replace offshore=100 if isco==2132
replace offshore=70 if isco==2145
replace offshore=71 if isco==2149
replace offshore=81 if isco==2211
replace offshore=46 if isco==2412
replace offshore=50 if isco==2419
replace offshore=33 if isco==2432
replace offshore=89 if isco==2441
replace offshore=48 if isco==2455
replace offshore=72 if isco==3115
replace offshore=54 if isco==3119
replace offshore=46 if isco==3133
replace offshore=34 if isco==3139
replace offshore=34 if isco==3224
replace offshore=51 if isco==3411
replace offshore=25 if isco==3415
replace offshore=50 if isco==3417
replace offshore=59 if isco==3419
replace offshore=51 if isco==3432
replace offshore=54 if isco==3439
replace offshore=90 if isco==3460
replace offshore=54 if isco==4122
replace offshore=31 if isco==4131
replace offshore=67 if isco==4132
replace offshore=46 if isco==4141
replace offshore=26 if isco==4142
replace offshore=54 if isco==4222
replace offshore=68 if isco==7141
replace offshore=68 if isco==7224
replace offshore=65 if isco==7241
replace offshore=34 if isco==7344
replace offshore=72 if isco==7442
replace offshore=68 if isco==8122
replace offshore=68 if isco==8139
replace offshore=42 if isco==8161
replace offshore=68 if isco==8211
replace offshore=68 if isco==8223
replace offshore=41 if isco==8224
replace offshore=57 if isco==8240
replace offshore=58 if isco==8251
replace offshore=75 if isco==8269
replace offshore=66 if isco==8281
replace offshore=66 if isco==8283
replace offshore=68 if isco==8284
replace offshore=68 if isco==8290
replace offshore=70 if isco==9322
lab var offshore "Offshoring Potential (Blinder 2007), metric"

*** Creation of ordinal (4-point scale) offshoreability variable
* Creation of variable
gen offshore4=.
replace offshore4=4 if offshore<.
replace offshore4=3 if offshore<75
replace offshore4=2 if offshore<50
replace offshore4=1 if offshore<25
lab var offshore4 "Offshoring Potential (Blinder 2007), ordinal"
* Definition of value label
lab define offshore4 1 "0-24%" 2 "5-49%" 3 "50-74%" 4 "75-100%"
lab values offshore4 offshore4

*** Creation of dichotomous offshoreability variable
* Creation of variable
gen offshore2=.
replace offshore2=1 if offshore>0 & offshore<.
replace offshore2=0 if offshore==0
lab var offshore2 "Offshoring Potential (Blinder 2007), dichotomous"
* Definition of value label
lab define offshore2 0 "Not offshoreable" 1 "Offshoreable"
lab values offshore2 offshore2


***********************

*** Creation of globalization loser variable 1 : low-skilled offshoreable
* Creation of variable
gen glob_losers1=.
replace glob_losers1=1 if offshore2==1 & educlvl<3
replace glob_losers1=0 if offshore2==0 & educlvl<3
replace glob_losers1=0 if offshore2==1 & educlvl>2
replace glob_losers1=0 if offshore2==0 & educlvl>2
lab var glob_losers1 "Globalization losers; lowskilled exposed "
* Definition of value label
lab define glob_losers1 1 "glob loser (l-s off)" 0 "not loser"
lab values glob_losers1 glob_losers1


*** Creation of winner variable 1: low-skilled sheltered
* Creation of variable
gen glob_winners1=.
replace glob_winners1 =0 if offshore2==1 & educlvl<3
replace glob_winners1 =1 if offshore2==0 & educlvl<3
replace glob_winners1 =0 if offshore2==1 & educlvl>2
replace glob_winners1 =0 if offshore2==0 & educlvl>2
lab var glob_winners1 "Globalization winners; lowskilled sheltered "
* Definition of value label
lab define glob_winners1 1 "glob winners (l-s sheltered)" 0 "not winner"
lab values glob_winners1 glob_losers1



************************************
*	1.2 MODERNIZATION LOSERS

* Oesch 16-classes for respondents only (according to syntax on his website)

****************************************************************************************
* Respondent's Oesch class position
* Recode and create variables used to construct class variable for respondents
* Variables used to construct class variable for respondents: iscoco, emplrel, emplno
****************************************************************************************

**** Recode occupation variable (isco88 com 4-digit) for respondents

tab iscoco

recode iscoco (66666 77777 88888 99999=-9), copyrest gen(isco_mainjob)
label variable isco_mainjob "Current occupation of respondent - isco88 4-digit"
tab isco_mainjob

**** Recode employment status for respondents

tab emplrel

recode emplrel (6 7 8 9=9), copyrest gen(emplrel_r)
replace emplrel_r=-9 if cntry=="FR" & (essround==1 | essround==2) // Replace this command line with [SYNTAX A] or [SYNTAX C]
replace emplrel_r=-9 if cntry=="HU" & essround==2 // Replace this command line with [SYNTAX E]
label define emplrel_r ///
1 "Employee" ///
2 "Self-employed" ///
3 "Working for own family business" ///
9 "Missing"
label value emplrel_r emplrel_r
tab emplrel_r

tab emplno

recode emplno (0 66666 77777 88888 99999=0)(1/9=1)(10/10000=2), gen(emplno_r)
label define emplno_r ///
0 "0 employees" ///
1 "1-9 employees" ///
2 "10+ employees"
label value emplno_r emplno_r
tab emplno_r


gen selfem_mainjob=.
replace selfem_mainjob=1 if emplrel_r==1 | emplrel_r==9
replace selfem_mainjob=2 if emplrel_r==2 & emplno_r==0
replace selfem_mainjob=2 if emplrel_r==3
replace selfem_mainjob=3 if emplrel_r==2 & emplno_r==1
replace selfem_mainjob=4 if emplrel_r==2 & emplno_r==2
label variable selfem_mainjob "Employment status for respondants"
label define selfem_mainjob ///
1 "Not self-employed" ///
2 "Self-empl without employees" ///
3 "Self-empl with 1-9 employees" ///
4 "Self-empl with 10 or more"
label value selfem_mainjob selfem_mainjob
tab selfem_mainjob



* Create Oesch class schema for respondents


gen class16_r = -9

* Large employers (1)

replace class16_r=1 if selfem_mainjob==4


* Self-employed professionals (2)

replace class16_r=2 if (selfem_mainjob==2 | selfem_mainjob==3) & (isco_mainjob >= 2000 & isco_mainjob <= 2229) 
replace class16_r=2 if (selfem_mainjob==2 | selfem_mainjob==3) & (isco_mainjob >= 2300 & isco_mainjob <= 2470)

* Small business owners with employees (3)

replace class16_r=3 if (selfem_mainjob==3) & (isco_mainjob >= 1000 & isco_mainjob <= 1999)
replace class16_r=3 if (selfem_mainjob==3) & (isco_mainjob >= 3000 & isco_mainjob <= 9333)
replace class16_r=3 if (selfem_mainjob==3) & (isco_mainjob == 2230)

* Small business owners without employees (4)

replace class16_r=4 if (selfem_mainjob==2) & (isco_mainjob >= 1000 & isco_mainjob <= 1999)
replace class16_r=4 if (selfem_mainjob==2) & (isco_mainjob >= 3000 & isco_mainjob <= 9333)
replace class16_r=4 if (selfem_mainjob==2) & (isco_mainjob == 2230)

* Technical experts (5)

replace class16_r=5 if (selfem_mainjob==1) & (isco_mainjob >= 2100 & isco_mainjob <= 2213)

* Technicians (6)

replace class16_r=6 if (selfem_mainjob==1) & (isco_mainjob >= 3100 & isco_mainjob <= 3152)
replace class16_r=6 if (selfem_mainjob==1) & (isco_mainjob >= 3210 & isco_mainjob <= 3213)
replace class16_r=6 if (selfem_mainjob==1) & (isco_mainjob == 3434)

* Skilled manual (7)

replace class16_r=7 if (selfem_mainjob==1) & (isco_mainjob >= 6000 & isco_mainjob <= 7442)
replace class16_r=7 if (selfem_mainjob==1) & (isco_mainjob >= 8310 & isco_mainjob <= 8312)
replace class16_r=7 if (selfem_mainjob==1) & (isco_mainjob >= 8324 & isco_mainjob <= 8330)
replace class16_r=7 if (selfem_mainjob==1) & (isco_mainjob >= 8332 & isco_mainjob <= 8340)

* Low-skilled manual (8)

replace class16_r=8 if (selfem_mainjob==1) & (isco_mainjob >= 8000 & isco_mainjob <= 8300)
replace class16_r=8 if (selfem_mainjob==1) & (isco_mainjob >= 8320 & isco_mainjob <= 8321)
replace class16_r=8 if (selfem_mainjob==1) & (isco_mainjob == 8331)
replace class16_r=8 if (selfem_mainjob==1) & (isco_mainjob >= 9153 & isco_mainjob <= 9333)

* Higher-grade managers and administrators (9)

replace class16_r=9 if (selfem_mainjob==1) & (isco_mainjob >= 1000 & isco_mainjob <= 1239)
replace class16_r=9 if (selfem_mainjob==1) & (isco_mainjob >= 2400 & isco_mainjob <= 2429)
replace class16_r=9 if (selfem_mainjob==1) & (isco_mainjob == 2441)
replace class16_r=9 if (selfem_mainjob==1) & (isco_mainjob == 2470)

* Lower-grade managers and administrators (10)

replace class16_r=10 if (selfem_mainjob==1) & (isco_mainjob >= 1300 & isco_mainjob <= 1319)
replace class16_r=10 if (selfem_mainjob==1) & (isco_mainjob >= 3400 & isco_mainjob <= 3433)
replace class16_r=10 if (selfem_mainjob==1) & (isco_mainjob >= 3440 & isco_mainjob <= 3450)

* Skilled clerks (11)

replace class16_r=11 if (selfem_mainjob==1) & (isco_mainjob >= 4000 & isco_mainjob <= 4112)
replace class16_r=11 if (selfem_mainjob==1) & (isco_mainjob >= 4114 & isco_mainjob <= 4210)
replace class16_r=11 if (selfem_mainjob==1) & (isco_mainjob >= 4212 & isco_mainjob <= 4222)

* Unskilled clerks (12)

replace class16_r=12 if (selfem_mainjob==1) & (isco_mainjob == 4113)
replace class16_r=12 if (selfem_mainjob==1) & (isco_mainjob == 4211)
replace class16_r=12 if (selfem_mainjob==1) & (isco_mainjob == 4223)

* Socio-cultural professionals (13)

replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob >= 2220 &  isco_mainjob <= 2229)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob >= 2300 &  isco_mainjob <= 2320)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob >= 2340 &  isco_mainjob <= 2359)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob >= 2430 &  isco_mainjob <= 2440)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob >= 2442 &  isco_mainjob <= 2443)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob == 2445)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob == 2451)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob == 2460)

* Socio-cultural semi-professionals (14)

replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob == 2230)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob >= 2330 & isco_mainjob <= 2332)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob == 2444)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob >= 2446 & isco_mainjob <= 2450)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob >= 2452 & isco_mainjob <= 2455)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob == 3200)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob >= 3220 & isco_mainjob <= 3224)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob == 3226)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob >= 3229 & isco_mainjob <= 3340)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob >= 3460 & isco_mainjob <= 3472)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob == 3480)

* Skilled service (15)

replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob == 3225)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob >= 3227 & isco_mainjob <= 3228)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob >= 3473 & isco_mainjob <= 3475)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob >= 5000 & isco_mainjob <= 5113)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob == 5122)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob >= 5131 & isco_mainjob <= 5132)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob >= 5140 & isco_mainjob <= 5141)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob == 5143)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob >= 5160 & isco_mainjob <= 5220)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob == 8323)

* Low-skilled service (16)

replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob >= 5120 & isco_mainjob <= 5121)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob >= 5123 & isco_mainjob <= 5130)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob >= 5133 & isco_mainjob <= 5139)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob == 5142)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob == 5149)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob == 5230)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob == 8322)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob >= 9100 &  isco_mainjob <= 9152)

mvdecode class16_r, mv(-9)
label variable class16_r "Respondent's Oesch class position - 16 classes"
label define class16_r ///
1 "Large employers" ///
2 "Self-employed professionals" ///
3 "Small business owners with employees" ///
4 "Small business owners without employees" ///
5 "Technical experts" ///
6 "Technicians" ///
7 "Skilled manual" ///
8 "Low-skilled manual" ///
9 "Higher-grade managers and administrators" ///
10 "Lower-grade managers and administrators" ///
11 "Skilled clerks" ///
12 "Unskilled clerks" ///
13 "Socio-cultural professionals" ///
14 "Socio-cultural semi-professionals" ///
15 "Skilled service" ///
16 "Low-skilled service"
label value class16_r class16_r
tab class16_r

recode class16_r (1 2=1)(3 4=2)(5 6=3)(7 8=4)(9 10=5)(11 12=6)(13 14=7)(15 16=8), gen(class8_r)
label variable class8_r "Respondent's Oesch class position - 8 classes"
label define class8_r ///
1 "Self-employed professionals and large employers" ///
2 "Small business owners" ///
3 "Technical (semi-)professionals" ///
4 "Production workers" ///
5 "(Associate) managers" ///
6 "Clerks" ///
7 "Socio-cultural (semi-)professionals" ///
8 "Service workers"
label value class8_r class8_r
tab class8_r


*** Aggregated sector variable
* Creation of variable
gen sector=.
replace sector=1 if nace==1 | nace==2 | nace==5
replace sector=2 if nace==10 | nace==11 | nace==12 | nace==13 | nace==14
replace sector=3 if nace==15 | nace==16 | nace==17 | nace==18 | nace==19 | nace==20 ///
	 | nace==21 | nace==22 | nace==23 | nace==24 | nace==25 | nace==26 | nace==27 ///
	 | nace==28 | nace==29 | nace==30 | nace==31 | nace==32 | nace==33 | nace==34 ///
	 | nace==35 | nace==36 | nace==37
replace sector=4 if nace==40 | nace==41
replace sector=5 if nace==45
replace sector=6 if nace==50 | nace==51 | nace==52 | nace==55
replace sector=7 if nace==60 | nace==61 | nace==62 | nace==63 | nace==64
replace sector=8 if nace==65 | nace==66 | nace==67 | nace==70 | nace==71 | nace==72 ///
	 | nace==73 | nace==74
replace sector=9 if nace==75 | nace==80 | nace==85 | nace==90 | nace==91 | nace==92 ///
	 | nace==93 | nace==95 | nace==99
lab var sector "Aggregated sector variable"
* Definition of value label
lab define sector 1 "Agriculture, hunting, forestry and fishing" ///
	2 "Mining and quarrying" ///
	3 "Manufacturing" ///
	4 "Electricity, gas and water" ///
	5 "Construction" ///
	6 "Wholesale and retail trade and restaurants and hotels" ///
	7 "Transport, storage and communications" ///
	8 "Financing, insurance, real estate and busines services" ///
	9 "Community, social and personal services"
lab values sector sector

*** Gender
* Creation of variable
gen gender=gndr
lab var gender "Gender"
* Recoding of variable and definition of value label
recode gender (1=0) (2=1)
lab define gender 0 "male" 1 "female"
lab values gender gender


*** Creation of modernization loser variable 1 : routine service (class 16)
* Creation of variable
gen mod_losers1=.
replace mod_losers1 =1 if class16_r==16
replace mod_losers1 =0 if class16_r!=16
replace mod_losers1=. if class16_r==.

lab var mod_losers1 "Modernization losers 1; routine service oesch "
* Definition of value label
lab define mod_losers1 1 "mod loser (routine service)" 0 "not loser"
lab values mod_losers1 mod_losers1


*** Creation of modernization loser variable 4 : routine and skilled manual (classes 7,8)
* Creation of variable
gen mod_losers4=0
replace mod_losers4 =1 if class16_r==7
replace mod_losers4 =1 if class16_r==8
replace mod_losers4 =. if class16_r==.

lab var mod_losers4 "Modernization losers 4; routine and skilled manual oesch "
* Definition of value label
lab define mod_losers4 1 "mod loser (routine and skilled manual)" 0 "not loser"
lab values mod_losers4 mod_losers4



*** Creation of modernization winner variable 1 : socio-cult prof
* Creation of variable
gen mod_winners1=0
replace mod_winners1 =1 if class16_r==13
replace mod_winners1 =1 if class16_r==14
replace mod_winners1 =. if class16_r==.

lab var mod_winners1 "Modernization winners 1; SCP oesch "
* Definition of value label
lab define mod_winners1 1 "mod winners (SCP oesch)" 0 "not winner"
lab values mod_winners1 mod_winners1



************************************
************************************
*	1.3 lm status: unempl, temp, involunt parttime

*** unemployed in last 5 years
* Creation of variable
gen unemployed5y=uemp5yr==1
lab var unemployed5y "Unemployed in last 5 years"
* Definition of value label
lab define unemployed5y 1 "unemployed in last 5 years" 0 "other"
lab values unemployed5y unemployed5y


*** temporary employed
* Creation of variable
gen temp=wrkctr==2
lab var temp "temporary employed (limited contract)"
* Definition of value label
lab define temp 1 "limited contract" 0 "other"
lab values temp temp


*** part-time
* Creation of variable
gen parttime=wkhct<30
lab var parttime "parttime employed (<30h)"
* Definition of value label
lab define parttime 1 "parttime" 0 "other"
lab values parttime parttime


************************************
************************************

* 	1.4 other variables : country dummies, polint, age, age2, income?, gender, sector?



*** Age
* Creation of variable
gen age=2004-yrbrn
lab var age "Age in years"
gen age2=age^2
lab var age2 "Age in years (squared)"


*** Political interest
* Creation of variable
gen polint=polintr
recode polint (1=4) (2=3) (3=2) (4=1)
lab var polint "Interest in politics"
* Definition of value label
lab define polint 4 "Very interested" 3 "Quite interested" 2 "Hardly interested" ///
	1 "Not at all interested"
lab values polint polint

*** income (difference between respondent class and median class per country)
gen inc=hinctnt
sum hinctnt if cntry=="AT", detail
replace inc=hinctnt-r(p50) if cntry=="AT"
sum hinctnt if cntry=="BE", detail
replace inc=hinctnt-r(p50) if cntry=="BE"
sum hinctnt if cntry=="CH", detail
replace inc=hinctnt-r(p50) if cntry=="CH"
sum hinctnt if cntry=="CZ", detail
replace inc=hinctnt-r(p50) if cntry=="CZ"
sum hinctnt if cntry=="DE", detail
replace inc=hinctnt-r(p50) if cntry=="DE"
sum hinctnt if cntry=="DK", detail
replace inc=hinctnt-r(p50) if cntry=="DK"
sum hinctnt if cntry=="EE", detail
replace inc=hinctnt-r(p50) if cntry=="EE"
sum hinctnt if cntry=="ES", detail
replace inc=hinctnt-r(p50) if cntry=="ES"
sum hinctnt if cntry=="FI", detail
replace inc=hinctnt-r(p50) if cntry=="FI"
sum hinctnt if cntry=="FR", detail
replace inc=hinctnt-r(p50) if cntry=="FR"
sum hinctnt if cntry=="GB", detail
replace inc=hinctnt-r(p50) if cntry=="GB"
sum hinctnt if cntry=="GR", detail
replace inc=hinctnt-r(p50) if cntry=="GR"
sum hinctnt if cntry=="HU", detail
replace inc=hinctnt-r(p50) if cntry=="HU"
sum hinctnt if cntry=="IE", detail
replace inc=hinctnt-r(p50) if cntry=="IE"
sum hinctnt if cntry=="IL", detail
replace inc=hinctnt-r(p50) if cntry=="IL"
sum hinctnt if cntry=="IS", detail
replace inc=hinctnt-r(p50) if cntry=="IS"
sum hinctnt if cntry=="IT", detail
replace inc=hinctnt-r(p50) if cntry=="IT"
sum hinctnt if cntry=="LU", detail
replace inc=hinctnt-r(p50) if cntry=="LU"
sum hinctnt if cntry=="NL", detail
replace inc=hinctnt-r(p50) if cntry=="NL"
sum hinctnt if cntry=="NO", detail
replace inc=hinctnt-r(p50) if cntry=="NO"
sum hinctnt if cntry=="PL", detail
replace inc=hinctnt-r(p50) if cntry=="PL"
sum hinctnt if cntry=="PT", detail
replace inc=hinctnt-r(p50) if cntry=="PT"
sum hinctnt if cntry=="SE", detail
replace inc=hinctnt-r(p50) if cntry=="SE"
sum hinctnt if cntry=="SI", detail
replace inc=hinctnt-r(p50) if cntry=="SI"
sum hinctnt if cntry=="SK", detail
replace inc=hinctnt-r(p50) if cntry=="SK"
lab var inc "Income, difference between respondet class and median class per country"


************************************
************************************
*	1.5 Party choice and participation (adapted from Rommel&Walter)

*** Partisan preference, last election (not classified parties are missings)
* Creation of variable
gen party_vote=.
label var party_vote "Partisan preference, last election"
* Austria
replace   party_vote=3         if        prtvtat== 1
replace   party_vote=5         if        prtvtat== 2
replace   party_vote=7         if        prtvtat== 3
replace   party_vote=1         if        prtvtat== 4
replace   party_vote=4         if        prtvtat== 5
replace   party_vote=0         if        prtvtat== 6
* Belgium
replace   party_vote=1         if        prtvtabe==1
replace   party_vote=5         if        prtvtabe==2
replace   party_vote=5         if        prtvtabe==3
replace   party_vote=3         if        prtvtabe==5
replace   party_vote=.         if        prtvtabe==6
replace   party_vote=7         if        prtvtabe==7
replace   party_vote=4         if        prtvtabe==8
replace   party_vote=5         if        prtvtabe==9
replace   party_vote=1         if        prtvtabe==10
replace   party_vote=7         if        prtvtabe==11
replace   party_vote=4         if        prtvtabe==12
replace   party_vote=3         if        prtvtabe==13
replace   party_vote=0         if        prtvtabe==14
replace   party_vote=.         if        prtvtabe==15
replace   party_vote=.         if        prtvtabe==16
* Switzerland
replace   party_vote=4         if        prtvtch== 1
replace   party_vote=5         if        prtvtch== 2
replace   party_vote=3         if        prtvtch== 3
replace   party_vote=7         if        prtvtch== 4
replace   party_vote=4         if        prtvtch== 5
replace   party_vote=5         if        prtvtch== 7
replace   party_vote=.         if        prtvtch== 8
replace   party_vote=2         if        prtvtch== 9
replace   party_vote=1         if        prtvtch== 10
replace   party_vote=7         if        prtvtch== 11
replace   party_vote=7         if        prtvtch== 12
replace   party_vote=7         if        prtvtch== 13
replace   party_vote=.         if        prtvtch== 14
replace   party_vote=7         if        prtvtch== 15
replace   party_vote=0         if        prtvtch== 16

* Germany
replace   party_vote=3         if        prtvade1==1
replace   party_vote=5         if        prtvade1==2
replace   party_vote=1         if        prtvade1==3
replace   party_vote=4         if        prtvade1==4
replace   party_vote=2         if        prtvade1==5
replace   party_vote=7         if        prtvade1==6
replace   party_vote=7         if        prtvade1==7
replace   party_vote=0         if        prtvade1==8
* Denmark
replace   party_vote=3         if        prtvtdk== 1
replace   party_vote=1         if        prtvtdk== 2
replace   party_vote=6         if        prtvtdk== 3
replace   party_vote=5         if        prtvtdk== 4
replace   party_vote=1         if        prtvtdk== 5
replace   party_vote=7         if        prtvtdk== 6
replace   party_vote=5         if        prtvtdk== 7
replace   party_vote=6         if        prtvtdk== 8
replace   party_vote=7         if        prtvtdk== 9
replace   party_vote=2         if        prtvtdk== 10
replace   party_vote=0         if        prtvtdk== 11

* Spain
replace   party_vote=6         if        prtvtaes==1
replace   party_vote=3         if        prtvtaes==2
replace   party_vote=2         if        prtvtaes==3
replace   party_vote=6         if        prtvtaes==4
replace   party_vote=0         if        prtvtaes==5
replace   party_vote=.         if        prtvtaes==6
replace   party_vote=0         if        prtvtaes==7
replace   party_vote=0         if        prtvtaes==8
replace   party_vote=0         if        prtvtaes==9
replace   party_vote=0         if        prtvtaes==10
replace   party_vote=0         if        prtvtaes==11
replace   party_vote=0         if        prtvtaes==12
replace   party_vote=0         if        prtvtaes==74
replace   party_vote=.         if        prtvtaes==75
replace   party_vote=.         if        prtvtaes==76
* Finland
replace   party_vote=6         if        prtvtfi== 1
replace   party_vote=0         if        prtvtfi== 2
replace   party_vote=4         if        prtvtfi== 3
replace   party_vote=5         if        prtvtfi== 4
replace   party_vote=7         if        prtvtfi== 5
replace   party_vote=5         if        prtvtfi== 6
replace   party_vote=.         if        prtvtfi== 7
replace   party_vote=1         if        prtvtfi== 8
replace   party_vote=3         if        prtvtfi== 9
replace   party_vote=2         if        prtvtfi== 10
replace   party_vote=.         if        prtvtfi== 11
replace   party_vote=.         if        prtvtfi== 12
replace   party_vote=0         if        prtvtfi== 14
* France
replace   party_vote=.         if        prtvtfr== 1
replace   party_vote=4         if        prtvtfr== 2
replace   party_vote=7         if        prtvtfr== 3
replace   party_vote=.         if        prtvtfr== 4
replace   party_vote=.         if        prtvtfr== 5
replace   party_vote=2         if        prtvtfr== 6
replace   party_vote=7         if        prtvtfr== 7
replace   party_vote=.         if        prtvtfr== 8
replace   party_vote=2         if        prtvtfr== 9
replace   party_vote=3         if        prtvtfr== 10
replace   party_vote=.         if        prtvtfr== 11
replace   party_vote=6         if        prtvtfr== 12
replace   party_vote=4         if        prtvtfr== 13
replace   party_vote=1         if        prtvtfr== 14
replace   party_vote=.         if        prtvtfr== 15
replace   party_vote=0         if        prtvtfr== 16
* Great Britain
replace   party_vote=6         if        prtvtgb== 1
replace   party_vote=3         if        prtvtgb== 2
replace   party_vote=4         if        prtvtgb== 3
replace   party_vote=0         if        prtvtgb== 4
replace   party_vote=0         if        prtvtgb== 5
replace   party_vote=.         if        prtvtgb== 6
replace   party_vote=0         if        prtvtgb== 7
replace   party_vote=6         if        prtvtgb== 11
replace   party_vote=0         if        prtvtgb== 12
replace   party_vote=2         if        prtvtgb== 13
replace   party_vote=3         if        prtvtgb== 14
replace   party_vote=0         if        prtvtgb== 22
* Greece
replace   party_vote=3         if        prtvtagr==1
replace   party_vote=6         if        prtvtagr==2
replace   party_vote=2         if        prtvtagr==3
replace   party_vote=2         if        prtvtagr==4
replace   party_vote=3         if        prtvtagr==5
replace   party_vote=7         if        prtvtagr==6
replace   party_vote=0         if        prtvtagr==7

* Ireland
replace   party_vote=6         if        prtvtie== 1
replace   party_vote=5         if        prtvtie== 2
replace   party_vote=3         if        prtvtie== 3
replace   party_vote=4         if        prtvtie== 4
replace   party_vote=1         if        prtvtie== 5
replace   party_vote=2         if        prtvtie== 6
replace   party_vote=.         if        prtvtie== 7
replace   party_vote=0         if        prtvtie== 8

* Italy
replace   party_vote=3         if        prtvtait==1
replace   party_vote=5         if        prtvtait==2
replace   party_vote=2         if        prtvtait==3
replace   party_vote=1         if        prtvtait==4
replace   party_vote=0         if        prtvtait==6
replace   party_vote=2         if        prtvtait==7
replace   party_vote=6         if        prtvtait==8
replace   party_vote=7         if        prtvtait==9
replace   party_vote=5         if        prtvtait==10
replace   party_vote=7         if        prtvtait==11
replace   party_vote=3         if        prtvtait==12
replace   party_vote=.         if        prtvtait==13
replace   party_vote=0         if        prtvtait==14
replace   party_vote=.         if        prtvtait==15
replace   party_vote=7         if        prtvtait==16
replace   party_vote=0         if        prtvtait==17
replace   party_vote=.         if        prtvtait==18
replace   party_vote=3         if        prtvtait==19
replace   party_vote=.         if        prtvtait==70

* Netherlands
replace   party_vote=5         if        prtvtanl==1
replace   party_vote=3         if        prtvtanl==2
replace   party_vote=4         if        prtvtanl==3
replace   party_vote=7         if        prtvtanl==4
replace   party_vote=4         if        prtvtanl==5
replace   party_vote=1         if        prtvtanl==6
replace   party_vote=2         if        prtvtanl==7
replace   party_vote=5         if        prtvtanl==8
replace   party_vote=4         if        prtvtanl==9
replace   party_vote=4         if        prtvtanl==10
replace   party_vote=0         if        prtvtanl==11
replace   party_vote=0         if        prtvtanl==12
replace   party_vote=.         if        prtvtanl==13
* Norway
replace   party_vote=.         if        prtvtno== 1
replace   party_vote=2         if        prtvtno== 2
replace   party_vote=3         if        prtvtno== 3
replace   party_vote=4         if        prtvtno== 4
replace   party_vote=5         if        prtvtno== 5
replace   party_vote=5         if        prtvtno== 6
replace   party_vote=6         if        prtvtno== 7
replace   party_vote=7         if        prtvtno== 8
replace   party_vote=.         if        prtvtno== 9
replace   party_vote=0         if        prtvtno== 10

* Portugal
replace   party_vote=2         if        prtvtpt== 1
replace   party_vote=5         if        prtvtpt== 2
replace   party_vote=.         if        prtvtpt== 4
replace   party_vote=2         if        prtvtpt== 5
replace   party_vote=.         if        prtvtpt== 6
replace   party_vote=7         if        prtvtpt== 9
replace   party_vote=3         if        prtvtpt== 10
replace   party_vote=5         if        prtvtpt== 11
replace   party_vote=0         if        prtvtpt== 12
replace   party_vote=.         if        prtvtpt== 13
* Sweden
replace   party_vote=5         if        prtvtse== 1
replace   party_vote=4         if        prtvtse== 2
replace   party_vote=5         if        prtvtse== 3
replace   party_vote=1         if        prtvtse== 4
replace   party_vote=6         if        prtvtse== 5
replace   party_vote=3         if        prtvtse== 6
replace   party_vote=2         if        prtvtse== 7
replace   party_vote=0         if        prtvtse== 8

* Definition of value labels
label def party_vote 0 "Other" 1 "Green" 2 "Communist" 3 "Social democratic" ///
	4 "Liberal"	5 "Christian democratic" 6 "Conservative" 7 "Right-Wing"
label val party_vote party_vote

*** Party closeness (not classified parties are missings)
* Creation of variable
gen party_close=.
label var party_close "Party closeness"
* Austria: no observations
* Belgium
replace   party_close=1         if        prtclabe==1
replace   party_close=5         if        prtclabe==2
replace   party_close=5         if        prtclabe==3
replace   party_close=5         if        prtclabe==4
replace   party_close=3         if        prtclabe==5
replace   party_close=.         if        prtclabe==6
replace   party_close=7         if        prtclabe==7
replace   party_close=4         if        prtclabe==8
replace   party_close=5         if        prtclabe==9
replace   party_close=1         if        prtclabe==10
replace   party_close=7         if        prtclabe==11
replace   party_close=4         if        prtclabe==12
replace   party_close=3         if        prtclabe==13
replace   party_close=.         if        prtclabe==14
replace   party_close=.         if        prtclabe==15
replace   party_close=0         if        prtclabe==16
replace   party_close=.         if        prtclabe==17
replace   party_close=.         if        prtclabe==18
* Switzerland
replace   party_close=4         if        prtclch==1
replace   party_close=5         if        prtclch==2
replace   party_close=3         if        prtclch==3
replace   party_close=7         if        prtclch==4
replace   party_close=4         if        prtclch==5
replace   party_close=.         if        prtclch==6
replace   party_close=2         if        prtclch==7
replace   party_close=1         if        prtclch==8
replace   party_close=.         if        prtclch==9
replace   party_close=7         if        prtclch==10
replace   party_close=7         if        prtclch==11
replace   party_close=5         if        prtclch==12
replace   party_close=7         if        prtclch==13
replace   party_close=.         if        prtclch==18
replace   party_close=.         if        prtclch==19
replace   party_close=0         if        prtclch==20

* Germany
replace   party_close=3         if        prtclade==1
replace   party_close=5         if        prtclade==2
replace   party_close=1         if        prtclade==3
replace   party_close=4         if        prtclade==4
replace   party_close=2         if        prtclade==5
replace   party_close=7         if        prtclade==6
replace   party_close=7         if        prtclade==7
replace   party_close=0         if        prtclade==8
* Denmark
replace   party_close=3         if        prtcldk==1
replace   party_close=1         if        prtcldk==2
replace   party_close=6         if        prtcldk==3
replace   party_close=1         if        prtcldk==4
replace   party_close=7         if        prtcldk==5
replace   party_close=5         if        prtcldk==6
replace   party_close=4         if        prtcldk==7
replace   party_close=0         if        prtcldk==8
replace   party_close=2         if        prtcldk==9
replace   party_close=0         if        prtcldk==10

* Spain
replace   party_close=6         if        prtclaes==1
replace   party_close=3         if        prtclaes==2
replace   party_close=2         if        prtclaes==3
replace   party_close=6         if        prtclaes==4
replace   party_close=0         if        prtclaes==5
replace   party_close=0         if        prtclaes==6
replace   party_close=0         if        prtclaes==7
replace   party_close=0         if        prtclaes==8
replace   party_close=.         if        prtclaes==9
replace   party_close=.         if        prtclaes==10
replace   party_close=0         if        prtclaes==74
replace   party_close=.         if        prtclaes==75
replace   party_close=.         if        prtclaes==76
* Finland
replace   party_close=6         if        prtclfi==1
replace   party_close=0         if        prtclfi==2
replace   party_close=4         if        prtclfi==3
replace   party_close=5         if        prtclfi==4
replace   party_close=7         if        prtclfi==5
replace   party_close=5         if        prtclfi==6
replace   party_close=.         if        prtclfi==8
replace   party_close=.         if        prtclfi==9
replace   party_close=.         if        prtclfi==11
replace   party_close=1         if        prtclfi==13
replace   party_close=3         if        prtclfi==14
replace   party_close=2         if        prtclfi==15
replace   party_close=.         if        prtclfi==16
replace   party_close=.         if        prtclfi==17
replace   party_close=.         if        prtclfi==18
replace   party_close=0         if        prtclfi==19
* France
replace   party_close=.         if        prtclfr ==1
replace   party_close=7         if        prtclfr==2
replace   party_close=2         if        prtclfr==3
replace   party_close=2         if        prtclfr==4
replace   party_close=.         if        prtclfr==5
replace   party_close=4         if        prtclfr==6
replace   party_close=2         if        prtclfr==7
replace   party_close=3         if        prtclfr==8
replace   party_close=.         if        prtclfr==9
replace   party_close=4         if        prtclfr==10
replace   party_close=6         if        prtclfr==11
replace   party_close=1         if        prtclfr==12
replace   party_close=.         if        prtclfr==13
replace   party_close=0         if        prtclfr==14
replace   party_close=0         if        prtclfr==15
replace   party_close=0         if        prtclfr==16
replace   party_close=.         if        prtclfr==17
replace   party_close=.         if        prtclfr==18
* Great Britain
replace   party_close=6         if        prtclgb== 1
replace   party_close=3         if        prtclgb== 2
replace   party_close=4         if        prtclgb== 3
replace   party_close=0         if        prtclgb== 4
replace   party_close=0         if        prtclgb== 5
replace   party_close=.         if        prtclgb== 6
replace   party_close=0         if        prtclgb== 7
replace   party_close=6         if        prtclgb== 11
replace   party_close=0         if        prtclgb== 12
replace   party_close=2         if        prtclgb== 13
replace   party_close=3         if        prtclgb== 14
replace   party_close=0         if        prtclgb== 15
* Greece
replace   party_close=3         if        prtclagr==1
replace   party_close=6         if        prtclagr==2
replace   party_close=2         if        prtclagr==3
replace   party_close=7         if        prtclagr==4
replace   party_close=2         if        prtclagr==5
replace   party_close=.         if        prtclagr==6
replace   party_close=.         if        prtclagr==7
replace   party_close=.         if        prtclagr==8
replace   party_close=.         if        prtclagr==9
replace   party_close=.         if        prtclagr==10
replace   party_close=.         if        prtclagr==11
replace   party_close=.         if        prtclagr==12
replace   party_close=.         if        prtclagr==13
replace   party_close=0         if        prtclagr==14

* Ireland
replace   party_close=6         if        prtclie==1
replace   party_close=5         if        prtclie==2
replace   party_close=1         if        prtclie==3
replace   party_close=.         if        prtclie==4
replace   party_close=3         if        prtclie==5
replace   party_close=.         if        prtclie==6
replace   party_close=2         if        prtclie==7
replace   party_close=2         if        prtclie==8
replace   party_close=.         if        prtclie==9
replace   party_close=0         if        prtclie==10

* Iceland: no observations
* Italy: no observations
* Luxembourg: no observations
* Netherlands
replace   party_close=4         if        prtclanl==1
replace   party_close=3         if        prtclanl==2
replace   party_close=7         if        prtclanl==3
replace   party_close=5         if        prtclanl==4
replace   party_close=2         if        prtclanl==5
replace   party_close=4         if        prtclanl==6
replace   party_close=1         if        prtclanl==7
replace   party_close=5         if        prtclanl==8
replace   party_close=4         if        prtclanl==9
replace   party_close=.         if        prtclanl==10
replace   party_close=.         if        prtclanl==11
replace   party_close=0         if        prtclanl==12
replace   party_close=.         if        prtclanl==13
* Norway
replace   party_close=.         if        prtclno==1
replace   party_close=2         if        prtclno==2
replace   party_close=3         if        prtclno==3
replace   party_close=4         if        prtclno==4
replace   party_close=5         if        prtclno==5
replace   party_close=5         if        prtclno==6
replace   party_close=6         if        prtclno==7
replace   party_close=7         if        prtclno==8
replace   party_close=.         if        prtclno==9
replace   party_close=0         if        prtclno==10

* Portugal
replace   party_close=2         if        prtclapt==1
replace   party_close=5         if        prtclapt==2
replace   party_close=2         if        prtclapt==3
replace   party_close=.         if        prtclapt==4
replace   party_close=.         if        prtclapt==6
replace   party_close=.         if        prtclapt==7
replace   party_close=7         if        prtclapt==8
replace   party_close=.         if        prtclapt==9
replace   party_close=5         if        prtclapt==10
replace   party_close=3         if        prtclapt==11
replace   party_close=.         if        prtclapt==12
replace   party_close=0         if        prtclapt==13
* Sweden
replace   party_close=5         if        prtclse==1
replace   party_close=4         if        prtclse==2
replace   party_close=5         if        prtclse==3
replace   party_close=1         if        prtclse==4
replace   party_close=6         if        prtclse==5
replace   party_close=3         if        prtclse==6
replace   party_close=2         if        prtclse==7
replace   party_close=.         if        prtclse==8
replace   party_close=.         if        prtclse==9
replace   party_close=7         if        prtclse==10
replace   party_close=0         if        prtclse==11

* Definition of value labels
label def party_close 0 "Other" 1 "Green" 2 "Communist" 3 "Social democratic" ///
	4 "Liberal"	5 "Christian democratic" 6 "Conservative" 7 "Nationalist"
label val party_close party_close

*** Voter participation
* Creation of variable 
gen voted=vote==1
replace voted=. if vote>2
lab var voted "Voter participation"
* Definition of value label
lab define voted 1 "Voter" 0 "Non-voter"
lab values voted voted

save "ESSrecoded2.dta", replace




*----------------------------------------------------------------------------------------*
*	3. prepare/recode ESS3
*----------------------------------------------------------------------------------------*

*----------------------------------------------------------------------------------------*
*	1. Operationalization of variables, round 2 - 2004
*----------------------------------------------------------------------------------------*
* Basic commands
clear all
set mem 1g
set more off
capture log close

* Import dataset (from ESS website)
use ESS3e03_5.dta


*	1.0 country selection: 
* AT, BE, CH, GE, DK, SP, FIN, FR, UK, GR, IE, IT, NL, NO, PT, SE
 
drop if cntry=="CZ"
drop if cntry=="HU"
drop if cntry=="LU"
drop if cntry=="PL"
drop if cntry=="SI"
drop if cntry=="IL"
drop if cntry=="EE"
drop if cntry=="IS"
drop if cntry=="SK"
drop if cntry=="TR"
drop if cntry=="UA"
drop if cntry=="RU"
drop if cntry=="BG"
drop if cntry=="CY"
drop if cntry=="LV"
drop if cntry=="RO"


gen at=cntry=="AT"
lab var at "Country dummy Austria"
gen be=cntry=="BE"
lab var be "Country dummy Belgium"
gen ch=cntry=="CH"
lab var ch "Country dummy Switzerland"
gen de=cntry=="DE"
lab var de "Country dummy Germany"
gen dk=cntry=="DK"
lab var dk "Country dummy Denmark"
gen es=cntry=="ES"
lab var es "Country dummy Spain"
gen fi=cntry=="FI"
lab var fi "Country dummy Finland"
gen fr=cntry=="FR"
lab var fr "Country dummy France"
gen gb=cntry=="GB"
lab var gb "Country dummy United Kingdom"
gen gr=cntry=="GR"
lab var gr "Country dummy Greece"
gen ie=cntry=="IE"
lab var ie "Country dummy Ireland"
gen it=cntry=="IT"
lab var it "Country dummy Italy"
gen nl=cntry=="NL"
lab var nl "Country dummy Netherlands"
gen no=cntry=="NO"
lab var no "Country dummy Norway"
gen pt=cntry=="PT"
lab var pt "Country dummy Portugal"
gen se=cntry=="SE"
lab var se "Country dummy Sweden"


*******************************
*   1.1 GLOBALIZATION LOSERS
*******************************

** from Rommel /Walter: combination of offshoreable and low-skill (educlvl und offshore2)

* Creation of variable
gen educyrs=eduyrs
lab var educyrs "Years of Education"
* Recoding of variable
replace educyrs=25 if eduyrs>25 & eduyrs<.


***** 2.2 Education level
*----------------------------------------------------------------------------------------*

* Creation of variable
gen educlvl=edulvla
lab var educlvl "Education level"
* Recoding of variable and definition of value label
recode educlvl (55=.)
label define educlvl 1 "Less than lower secondary education" ///
	2 "Lower secondary education completed" ///
	3 "Upper secondary education completed" ///
	4 "Post-secondary, non-tertiary education completed" ///
	5 "Tertiary education completed"
label values educlvl educlvl


*** Creation of 4-digit ISCO-Code
gen isco=iscoco
lab var isco "4-digit ISCO-code"

*** Metric offshoreability variable	
* Creation of variable
gen offshore=.
replace offshore=0 if isco<.
replace offshore=49 if isco==1142
replace offshore=55 if isco==1222
replace offshore=28 if isco==1226
replace offshore=55 if isco==1228
replace offshore=83 if isco==1231
replace offshore=49 if isco==1232
replace offshore=40 if isco==1233
replace offshore=53 if isco==1234
replace offshore=49 if isco==1235
replace offshore=55 if isco==1236
replace offshore=55 if isco==1237
replace offshore=55 if isco==1311
replace offshore=55 if isco==1312
replace offshore=55 if isco==1313
replace offshore=55 if isco==1314
replace offshore=55 if isco==1315
replace offshore=48 if isco==1316
replace offshore=52 if isco==1317
replace offshore=55 if isco==1318
replace offshore=55 if isco==1319
replace offshore=66 if isco==2111
replace offshore=74 if isco==2112
replace offshore=66 if isco==2113
replace offshore=66 if isco==2114
replace offshore=89 if isco==2121
replace offshore=96 if isco==2122
replace offshore=83 if isco==2131
replace offshore=90 if isco==2139
replace offshore=25 if isco==2141
replace offshore=64 if isco==2143
replace offshore=74 if isco==2144
replace offshore=72 if isco==2146
replace offshore=69 if isco==2147
replace offshore=86 if isco==2148
replace offshore=71 if isco==2149
replace offshore=81 if isco==2211
replace offshore=83 if isco==2212
replace offshore=72 if isco==2411
replace offshore=50 if isco==2419
replace offshore=74 if isco==2421
replace offshore=67 if isco==2444
replace offshore=90 if isco==2451
replace offshore=78 if isco==2452
replace offshore=25 if isco==2453
replace offshore=48 if isco==2455
replace offshore=47 if isco==3111
replace offshore=47 if isco==3113
replace offshore=47 if isco==3114
replace offshore=72 if isco==3115
replace offshore=47 if isco==3116
replace offshore=94 if isco==3118
replace offshore=54 if isco==3119
replace offshore=75 if isco==3121
replace offshore=84 if isco==3122
replace offshore=68 if isco==3123
replace offshore=36 if isco==3131
replace offshore=36 if isco==3132
replace offshore=46 if isco==3133
replace offshore=34 if isco==3139
replace offshore=52 if isco==3141
replace offshore=60 if isco==3152
replace offshore=55 if isco==3211
replace offshore=55 if isco==3212
replace offshore=44 if isco==3213
replace offshore=32 if isco==3228
replace offshore=51 if isco==3411
replace offshore=85 if isco==3412
replace offshore=50 if isco==3414
replace offshore=55 if isco==3416
replace offshore=59 if isco==3419
replace offshore=51 if isco==3421
replace offshore=48 if isco==3422
replace offshore=38 if isco==3431
replace offshore=51 if isco==3432
replace offshore=84 if isco==3433
replace offshore=84 if isco==3434
replace offshore=54 if isco==3439
replace offshore=100 if isco==3442
replace offshore=85 if isco==3471
replace offshore=30 if isco==3472
replace offshore=95 if isco==4111
replace offshore=94 if isco==4112
replace offshore=100 if isco==4113
replace offshore=71 if isco==4114
replace offshore=38 if isco==4115
replace offshore=84 if isco==4121
replace offshore=54 if isco==4122
replace offshore=31 if isco==4131
replace offshore=67 if isco==4132
replace offshore=67 if isco==4133
replace offshore=46 if isco==4141
replace offshore=26 if isco==4142
replace offshore=95 if isco==4143
replace offshore=54 if isco==4144
replace offshore=54 if isco==4190
replace offshore=94 if isco==4211
replace offshore=54 if isco==4214
replace offshore=65 if isco==4215
replace offshore=72 if isco==4221
replace offshore=54 if isco==4222
replace offshore=50 if isco==4223
replace offshore=86 if isco==5113
replace offshore=59 if isco==6142
replace offshore=36 if isco==7111
replace offshore=35 if isco==7112
replace offshore=36 if isco==7113
replace offshore=65 if isco==7211
replace offshore=69 if isco==7212
replace offshore=70 if isco==7213
replace offshore=70 if isco==7222
replace offshore=68 if isco==7223
replace offshore=68 if isco==7224
replace offshore=26 if isco==7311
replace offshore=64 if isco==7313
replace offshore=69 if isco==7321
replace offshore=69 if isco==7322
replace offshore=68 if isco==7323
replace offshore=68 if isco==7324
replace offshore=60 if isco==7331
replace offshore=75 if isco==7332
replace offshore=59 if isco==7341
replace offshore=59 if isco==7342
replace offshore=59 if isco==7343
replace offshore=34 if isco==7344
replace offshore=59 if isco==7345
replace offshore=75 if isco==7346
replace offshore=68 if isco==7413
replace offshore=27 if isco==7414
replace offshore=55 if isco==7415
replace offshore=43 if isco==7421
replace offshore=57 if isco==7422
replace offshore=57 if isco==7423
replace offshore=66 if isco==7424
replace offshore=75 if isco==7431
replace offshore=75 if isco==7432
replace offshore=75 if isco==7433
replace offshore=73 if isco==7434
replace offshore=75 if isco==7435
replace offshore=75 if isco==7436
replace offshore=57 if isco==7437
replace offshore=75 if isco==7441
replace offshore=72 if isco==7442
replace offshore=36 if isco==8111
replace offshore=36 if isco==8112
replace offshore=36 if isco==8113
replace offshore=59 if isco==8121
replace offshore=68 if isco==8122
replace offshore=70 if isco==8123
replace offshore=68 if isco==8124
replace offshore=69 if isco==8131
replace offshore=68 if isco==8139
replace offshore=57 if isco==8141
replace offshore=68 if isco==8142
replace offshore=68 if isco==8143
replace offshore=68 if isco==8151
replace offshore=70 if isco==8152
replace offshore=68 if isco==8153
replace offshore=68 if isco==8154
replace offshore=29 if isco==8155
replace offshore=68 if isco==8159
replace offshore=42 if isco==8161
replace offshore=55 if isco==8162
replace offshore=29 if isco==8163
replace offshore=64 if isco==8171
replace offshore=68 if isco==8172
replace offshore=68 if isco==8211
replace offshore=68 if isco==8212
replace offshore=68 if isco==8221
replace offshore=35 if isco==8222
replace offshore=68 if isco==8223
replace offshore=41 if isco==8224
replace offshore=29 if isco==8229
replace offshore=69 if isco==8231
replace offshore=68 if isco==8232
replace offshore=57 if isco==8240
replace offshore=58 if isco==8251
replace offshore=59 if isco==8252
replace offshore=68 if isco==8253
replace offshore=75 if isco==8261
replace offshore=75 if isco==8262
replace offshore=75 if isco==8263
replace offshore=75 if isco==8264
replace offshore=75 if isco==8265
replace offshore=75 if isco==8266
replace offshore=75 if isco==8269
replace offshore=27 if isco==8271
replace offshore=68 if isco==8272
replace offshore=68 if isco==8273
replace offshore=30 if isco==8274
replace offshore=31 if isco==8275
replace offshore=68 if isco==8276
replace offshore=27 if isco==8277
replace offshore=68 if isco==8278
replace offshore=66 if isco==8281
replace offshore=66 if isco==8282
replace offshore=66 if isco==8283
replace offshore=68 if isco==8284
replace offshore=57 if isco==8285
replace offshore=64 if isco==8286
replace offshore=68 if isco==8290
replace offshore=34 if isco==8340
replace offshore=95 if isco==9113
replace offshore=64 if isco==9321
replace offshore=29 if isco==9333
replace offshore=55 if isco==1227
replace offshore=89 if isco==2121
replace offshore=100 if isco==2132
replace offshore=70 if isco==2145
replace offshore=71 if isco==2149
replace offshore=81 if isco==2211
replace offshore=46 if isco==2412
replace offshore=50 if isco==2419
replace offshore=33 if isco==2432
replace offshore=89 if isco==2441
replace offshore=48 if isco==2455
replace offshore=72 if isco==3115
replace offshore=54 if isco==3119
replace offshore=46 if isco==3133
replace offshore=34 if isco==3139
replace offshore=34 if isco==3224
replace offshore=51 if isco==3411
replace offshore=25 if isco==3415
replace offshore=50 if isco==3417
replace offshore=59 if isco==3419
replace offshore=51 if isco==3432
replace offshore=54 if isco==3439
replace offshore=90 if isco==3460
replace offshore=54 if isco==4122
replace offshore=31 if isco==4131
replace offshore=67 if isco==4132
replace offshore=46 if isco==4141
replace offshore=26 if isco==4142
replace offshore=54 if isco==4222
replace offshore=68 if isco==7141
replace offshore=68 if isco==7224
replace offshore=65 if isco==7241
replace offshore=34 if isco==7344
replace offshore=72 if isco==7442
replace offshore=68 if isco==8122
replace offshore=68 if isco==8139
replace offshore=42 if isco==8161
replace offshore=68 if isco==8211
replace offshore=68 if isco==8223
replace offshore=41 if isco==8224
replace offshore=57 if isco==8240
replace offshore=58 if isco==8251
replace offshore=75 if isco==8269
replace offshore=66 if isco==8281
replace offshore=66 if isco==8283
replace offshore=68 if isco==8284
replace offshore=68 if isco==8290
replace offshore=70 if isco==9322
lab var offshore "Offshoring Potential (Blinder 2007), metric"

*** Creation of ordinal (4-point scale) offshoreability variable
* Creation of variable
gen offshore4=.
replace offshore4=4 if offshore<.
replace offshore4=3 if offshore<75
replace offshore4=2 if offshore<50
replace offshore4=1 if offshore<25
lab var offshore4 "Offshoring Potential (Blinder 2007), ordinal"
* Definition of value label
lab define offshore4 1 "0-24%" 2 "5-49%" 3 "50-74%" 4 "75-100%"
lab values offshore4 offshore4

*** Creation of dichotomous offshoreability variable
* Creation of variable
gen offshore2=.
replace offshore2=1 if offshore>0 & offshore<.
replace offshore2=0 if offshore==0
lab var offshore2 "Offshoring Potential (Blinder 2007), dichotomous"
* Definition of value label
lab define offshore2 0 "Not offshoreable" 1 "Offshoreable"
lab values offshore2 offshore2


***********************

*** Creation of globalization loser variable 1 : low-skilled offshoreable
* Creation of variable
gen glob_losers1=.
replace glob_losers1=1 if offshore2==1 & educlvl<3
replace glob_losers1=0 if offshore2==0 & educlvl<3
replace glob_losers1=0 if offshore2==1 & educlvl>2
replace glob_losers1=0 if offshore2==0 & educlvl>2
lab var glob_losers1 "Globalization losers; lowskilled exposed "
* Definition of value label
lab define glob_losers1 1 "glob loser (l-s off)" 0 "not loser"
lab values glob_losers1 glob_losers1

*** Creation of winner variable 1: low-skilled sheltered
* Creation of variable
gen glob_winners1=.
replace glob_winners1 =0 if offshore2==1 & educlvl<3
replace glob_winners1 =1 if offshore2==0 & educlvl<3
replace glob_winners1 =0 if offshore2==1 & educlvl>2
replace glob_winners1 =0 if offshore2==0 & educlvl>2
lab var glob_winners1 "Globalization winners; lowskilled sheltered "
* Definition of value label
lab define glob_winners1 1 "glob winners (l-s sheltered)" 0 "not winner"
lab values glob_winners1 glob_losers1



************************************
*	1.2 MODERNIZATION LOSERS

* Oesch 16-classes for respondents only (according to syntax on his website)

****************************************************************************************
* Respondent's Oesch class position
* Recode and create variables used to construct class variable for respondents
* Variables used to construct class variable for respondents: iscoco, emplrel, emplno
****************************************************************************************

**** Recode occupation variable (isco88 com 4-digit) for respondents

tab iscoco

recode iscoco (66666 77777 88888 99999=-9), copyrest gen(isco_mainjob)
label variable isco_mainjob "Current occupation of respondent - isco88 4-digit"
tab isco_mainjob

**** Recode employment status for respondents

tab emplrel

recode emplrel (6 7 8 9=9), copyrest gen(emplrel_r)
replace emplrel_r=-9 if cntry=="FR" & (essround==1 | essround==2) // Replace this command line with [SYNTAX A] or [SYNTAX C]
replace emplrel_r=-9 if cntry=="HU" & essround==2 // Replace this command line with [SYNTAX E]
label define emplrel_r ///
1 "Employee" ///
2 "Self-employed" ///
3 "Working for own family business" ///
9 "Missing"
label value emplrel_r emplrel_r
tab emplrel_r

tab emplno

recode emplno (0 66666 77777 88888 99999=0)(1/9=1)(10/10000=2), gen(emplno_r)
label define emplno_r ///
0 "0 employees" ///
1 "1-9 employees" ///
2 "10+ employees"
label value emplno_r emplno_r
tab emplno_r


gen selfem_mainjob=.
replace selfem_mainjob=1 if emplrel_r==1 | emplrel_r==9
replace selfem_mainjob=2 if emplrel_r==2 & emplno_r==0
replace selfem_mainjob=2 if emplrel_r==3
replace selfem_mainjob=3 if emplrel_r==2 & emplno_r==1
replace selfem_mainjob=4 if emplrel_r==2 & emplno_r==2
label variable selfem_mainjob "Employment status for respondants"
label define selfem_mainjob ///
1 "Not self-employed" ///
2 "Self-empl without employees" ///
3 "Self-empl with 1-9 employees" ///
4 "Self-empl with 10 or more"
label value selfem_mainjob selfem_mainjob
tab selfem_mainjob



* Create Oesch class schema for respondents


gen class16_r = -9

* Large employers (1)

replace class16_r=1 if selfem_mainjob==4


* Self-employed professionals (2)

replace class16_r=2 if (selfem_mainjob==2 | selfem_mainjob==3) & (isco_mainjob >= 2000 & isco_mainjob <= 2229) 
replace class16_r=2 if (selfem_mainjob==2 | selfem_mainjob==3) & (isco_mainjob >= 2300 & isco_mainjob <= 2470)

* Small business owners with employees (3)

replace class16_r=3 if (selfem_mainjob==3) & (isco_mainjob >= 1000 & isco_mainjob <= 1999)
replace class16_r=3 if (selfem_mainjob==3) & (isco_mainjob >= 3000 & isco_mainjob <= 9333)
replace class16_r=3 if (selfem_mainjob==3) & (isco_mainjob == 2230)

* Small business owners without employees (4)

replace class16_r=4 if (selfem_mainjob==2) & (isco_mainjob >= 1000 & isco_mainjob <= 1999)
replace class16_r=4 if (selfem_mainjob==2) & (isco_mainjob >= 3000 & isco_mainjob <= 9333)
replace class16_r=4 if (selfem_mainjob==2) & (isco_mainjob == 2230)

* Technical experts (5)

replace class16_r=5 if (selfem_mainjob==1) & (isco_mainjob >= 2100 & isco_mainjob <= 2213)

* Technicians (6)

replace class16_r=6 if (selfem_mainjob==1) & (isco_mainjob >= 3100 & isco_mainjob <= 3152)
replace class16_r=6 if (selfem_mainjob==1) & (isco_mainjob >= 3210 & isco_mainjob <= 3213)
replace class16_r=6 if (selfem_mainjob==1) & (isco_mainjob == 3434)

* Skilled manual (7)

replace class16_r=7 if (selfem_mainjob==1) & (isco_mainjob >= 6000 & isco_mainjob <= 7442)
replace class16_r=7 if (selfem_mainjob==1) & (isco_mainjob >= 8310 & isco_mainjob <= 8312)
replace class16_r=7 if (selfem_mainjob==1) & (isco_mainjob >= 8324 & isco_mainjob <= 8330)
replace class16_r=7 if (selfem_mainjob==1) & (isco_mainjob >= 8332 & isco_mainjob <= 8340)

* Low-skilled manual (8)

replace class16_r=8 if (selfem_mainjob==1) & (isco_mainjob >= 8000 & isco_mainjob <= 8300)
replace class16_r=8 if (selfem_mainjob==1) & (isco_mainjob >= 8320 & isco_mainjob <= 8321)
replace class16_r=8 if (selfem_mainjob==1) & (isco_mainjob == 8331)
replace class16_r=8 if (selfem_mainjob==1) & (isco_mainjob >= 9153 & isco_mainjob <= 9333)

* Higher-grade managers and administrators (9)

replace class16_r=9 if (selfem_mainjob==1) & (isco_mainjob >= 1000 & isco_mainjob <= 1239)
replace class16_r=9 if (selfem_mainjob==1) & (isco_mainjob >= 2400 & isco_mainjob <= 2429)
replace class16_r=9 if (selfem_mainjob==1) & (isco_mainjob == 2441)
replace class16_r=9 if (selfem_mainjob==1) & (isco_mainjob == 2470)

* Lower-grade managers and administrators (10)

replace class16_r=10 if (selfem_mainjob==1) & (isco_mainjob >= 1300 & isco_mainjob <= 1319)
replace class16_r=10 if (selfem_mainjob==1) & (isco_mainjob >= 3400 & isco_mainjob <= 3433)
replace class16_r=10 if (selfem_mainjob==1) & (isco_mainjob >= 3440 & isco_mainjob <= 3450)

* Skilled clerks (11)

replace class16_r=11 if (selfem_mainjob==1) & (isco_mainjob >= 4000 & isco_mainjob <= 4112)
replace class16_r=11 if (selfem_mainjob==1) & (isco_mainjob >= 4114 & isco_mainjob <= 4210)
replace class16_r=11 if (selfem_mainjob==1) & (isco_mainjob >= 4212 & isco_mainjob <= 4222)

* Unskilled clerks (12)

replace class16_r=12 if (selfem_mainjob==1) & (isco_mainjob == 4113)
replace class16_r=12 if (selfem_mainjob==1) & (isco_mainjob == 4211)
replace class16_r=12 if (selfem_mainjob==1) & (isco_mainjob == 4223)

* Socio-cultural professionals (13)

replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob >= 2220 &  isco_mainjob <= 2229)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob >= 2300 &  isco_mainjob <= 2320)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob >= 2340 &  isco_mainjob <= 2359)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob >= 2430 &  isco_mainjob <= 2440)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob >= 2442 &  isco_mainjob <= 2443)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob == 2445)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob == 2451)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob == 2460)

* Socio-cultural semi-professionals (14)

replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob == 2230)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob >= 2330 & isco_mainjob <= 2332)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob == 2444)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob >= 2446 & isco_mainjob <= 2450)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob >= 2452 & isco_mainjob <= 2455)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob == 3200)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob >= 3220 & isco_mainjob <= 3224)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob == 3226)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob >= 3229 & isco_mainjob <= 3340)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob >= 3460 & isco_mainjob <= 3472)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob == 3480)

* Skilled service (15)

replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob == 3225)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob >= 3227 & isco_mainjob <= 3228)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob >= 3473 & isco_mainjob <= 3475)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob >= 5000 & isco_mainjob <= 5113)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob == 5122)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob >= 5131 & isco_mainjob <= 5132)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob >= 5140 & isco_mainjob <= 5141)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob == 5143)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob >= 5160 & isco_mainjob <= 5220)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob == 8323)

* Low-skilled service (16)

replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob >= 5120 & isco_mainjob <= 5121)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob >= 5123 & isco_mainjob <= 5130)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob >= 5133 & isco_mainjob <= 5139)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob == 5142)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob == 5149)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob == 5230)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob == 8322)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob >= 9100 &  isco_mainjob <= 9152)

mvdecode class16_r, mv(-9)
label variable class16_r "Respondent's Oesch class position - 16 classes"
label define class16_r ///
1 "Large employers" ///
2 "Self-employed professionals" ///
3 "Small business owners with employees" ///
4 "Small business owners without employees" ///
5 "Technical experts" ///
6 "Technicians" ///
7 "Skilled manual" ///
8 "Low-skilled manual" ///
9 "Higher-grade managers and administrators" ///
10 "Lower-grade managers and administrators" ///
11 "Skilled clerks" ///
12 "Unskilled clerks" ///
13 "Socio-cultural professionals" ///
14 "Socio-cultural semi-professionals" ///
15 "Skilled service" ///
16 "Low-skilled service"
label value class16_r class16_r
tab class16_r

recode class16_r (1 2=1)(3 4=2)(5 6=3)(7 8=4)(9 10=5)(11 12=6)(13 14=7)(15 16=8), gen(class8_r)
label variable class8_r "Respondent's Oesch class position - 8 classes"
label define class8_r ///
1 "Self-employed professionals and large employers" ///
2 "Small business owners" ///
3 "Technical (semi-)professionals" ///
4 "Production workers" ///
5 "(Associate) managers" ///
6 "Clerks" ///
7 "Socio-cultural (semi-)professionals" ///
8 "Service workers"
label value class8_r class8_r
tab class8_r


*** Aggregated sector variable
* Creation of variable
gen sector=.
replace sector=1 if nace==1 | nace==2 | nace==5
replace sector=2 if nace==10 | nace==11 | nace==12 | nace==13 | nace==14
replace sector=3 if nace==15 | nace==16 | nace==17 | nace==18 | nace==19 | nace==20 ///
	 | nace==21 | nace==22 | nace==23 | nace==24 | nace==25 | nace==26 | nace==27 ///
	 | nace==28 | nace==29 | nace==30 | nace==31 | nace==32 | nace==33 | nace==34 ///
	 | nace==35 | nace==36 | nace==37
replace sector=4 if nace==40 | nace==41
replace sector=5 if nace==45
replace sector=6 if nace==50 | nace==51 | nace==52 | nace==55
replace sector=7 if nace==60 | nace==61 | nace==62 | nace==63 | nace==64
replace sector=8 if nace==65 | nace==66 | nace==67 | nace==70 | nace==71 | nace==72 ///
	 | nace==73 | nace==74
replace sector=9 if nace==75 | nace==80 | nace==85 | nace==90 | nace==91 | nace==92 ///
	 | nace==93 | nace==95 | nace==99
lab var sector "Aggregated sector variable"
* Definition of value label
lab define sector 1 "Agriculture, hunting, forestry and fishing" ///
	2 "Mining and quarrying" ///
	3 "Manufacturing" ///
	4 "Electricity, gas and water" ///
	5 "Construction" ///
	6 "Wholesale and retail trade and restaurants and hotels" ///
	7 "Transport, storage and communications" ///
	8 "Financing, insurance, real estate and busines services" ///
	9 "Community, social and personal services"
lab values sector sector

*** Gender
* Creation of variable
gen gender=gndr
lab var gender "Gender"
* Recoding of variable and definition of value label
recode gender (1=0) (2=1)
lab define gender 0 "male" 1 "female"
lab values gender gender


*** Creation of modernization loser variable 1 : routine service (class 16)
* Creation of variable
gen mod_losers1=.
replace mod_losers1 =1 if class16_r==16
replace mod_losers1 =0 if class16_r!=16
replace mod_losers1=. if class16_r==.

lab var mod_losers1 "Modernization losers 1; routine service oesch "
* Definition of value label
lab define mod_losers1 1 "mod loser (routine service)" 0 "not loser"
lab values mod_losers1 mod_losers1


*** Creation of modernization loser variable 4 : routine and skilled manual (classes 7,8)
* Creation of variable
gen mod_losers4=0
replace mod_losers4 =1 if class16_r==7
replace mod_losers4 =1 if class16_r==8
replace mod_losers4 =. if class16_r==.

lab var mod_losers4 "Modernization losers 4; routine and skilled manual oesch "
* Definition of value label
lab define mod_losers4 1 "mod loser (routine and skilled manual)" 0 "not loser"
lab values mod_losers4 mod_losers4


*** Creation of modernization winner variable 1 : socio-cult prof
* Creation of variable
gen mod_winners1=0
replace mod_winners1 =1 if class16_r==13
replace mod_winners1 =1 if class16_r==14
replace mod_winners1 =. if class16_r==.

lab var mod_winners1 "Modernization winners 1; SCP oesch "
* Definition of value label
lab define mod_winners1 1 "mod winners (SCP oesch)" 0 "not winner"
lab values mod_winners1 mod_winners1




************************************
************************************
*	1.3 lm status: unempl, temp, involunt parttime


*** unemployed in last 5 years
* Creation of variable
gen unemployed5y=uemp5yr==1
lab var unemployed5y "Unemployed in last 5 years"
* Definition of value label
lab define unemployed5y 1 "unemployed in last 5 years" 0 "other"
lab values unemployed5y unemployed5y


*** temporary employed
* Creation of variable
gen temp=wrkctr==2
lab var temp "temporary employed (limited contract)"
* Definition of value label
lab define temp 1 "limited contract" 0 "other"
lab values temp temp


*** part-time
* Creation of variable
gen parttime=wkhct<30
lab var parttime "parttime employed (<30h)"
* Definition of value label
lab define parttime 1 "parttime" 0 "other"
lab values parttime parttime


************************************
************************************
* 	1.4 other variables : country dummies, polint, age, age2, income?, gender, sector?


*** Age
drop age
* Creation of variable
gen age=2006-yrbrn
lab var age "Age in years"
gen age2=age^2
lab var age2 "Age in years (squared)"


*** Political interest
* Creation of variable
gen polint=polintr
recode polint (1=4) (2=3) (3=2) (4=1)
lab var polint "Interest in politics"
* Definition of value label
lab define polint 4 "Very interested" 3 "Quite interested" 2 "Hardly interested" ///
	1 "Not at all interested"
lab values polint polint

*** Income
* Creation of variable
gen inc=hinctnt
sum hinctnt if cntry=="AT", detail
replace inc=hinctnt-r(p50) if cntry=="AT"
sum hinctnt if cntry=="BE", detail
replace inc=hinctnt-r(p50) if cntry=="BE"
sum hinctnt if cntry=="CH", detail
replace inc=hinctnt-r(p50) if cntry=="CH"
sum hinctnt if cntry=="CZ", detail
replace inc=hinctnt-r(p50) if cntry=="CZ"
sum hinctnt if cntry=="DE", detail
replace inc=hinctnt-r(p50) if cntry=="DE"
sum hinctnt if cntry=="DK", detail
replace inc=hinctnt-r(p50) if cntry=="DK"
sum hinctnt if cntry=="EE", detail
replace inc=hinctnt-r(p50) if cntry=="EE"
sum hinctnt if cntry=="ES", detail
replace inc=hinctnt-r(p50) if cntry=="ES"
sum hinctnt if cntry=="FI", detail
replace inc=hinctnt-r(p50) if cntry=="FI"
sum hinctnt if cntry=="FR", detail
replace inc=hinctnt-r(p50) if cntry=="FR"
sum hinctnt if cntry=="GB", detail
replace inc=hinctnt-r(p50) if cntry=="GB"
sum hinctnt if cntry=="GR", detail
replace inc=hinctnt-r(p50) if cntry=="GR"
sum hinctnt if cntry=="HU", detail
replace inc=hinctnt-r(p50) if cntry=="HU"
sum hinctnt if cntry=="IE", detail
replace inc=hinctnt-r(p50) if cntry=="IE"
sum hinctnt if cntry=="IL", detail
replace inc=hinctnt-r(p50) if cntry=="IL"
sum hinctnt if cntry=="IS", detail
replace inc=hinctnt-r(p50) if cntry=="IS"
sum hinctnt if cntry=="IT", detail
replace inc=hinctnt-r(p50) if cntry=="IT"
sum hinctnt if cntry=="LU", detail
replace inc=hinctnt-r(p50) if cntry=="LU"
sum hinctnt if cntry=="NL", detail
replace inc=hinctnt-r(p50) if cntry=="NL"
sum hinctnt if cntry=="NO", detail
replace inc=hinctnt-r(p50) if cntry=="NO"
sum hinctnt if cntry=="PL", detail
replace inc=hinctnt-r(p50) if cntry=="PL"
sum hinctnt if cntry=="PT", detail
replace inc=hinctnt-r(p50) if cntry=="PT"
sum hinctnt if cntry=="SE", detail
replace inc=hinctnt-r(p50) if cntry=="SE"
sum hinctnt if cntry=="SI", detail
replace inc=hinctnt-r(p50) if cntry=="SI"
sum hinctnt if cntry=="SK", detail
replace inc=hinctnt-r(p50) if cntry=="SK"
lab var inc "Income, difference between respondet class and median class per country"


************************************
************************************
*	1.5 Party choice and participation (adapted from Rommel&Walter)

*** Partisan preference, last election (not classified parties are missings)
* Creation of variable
gen party_vote=.
label var party_vote "Partisan preference, last election"
* Austria
replace   party_vote=3         if        prtvtaat==1
replace   party_vote=5         if        prtvtaat==2
replace   party_vote=7         if        prtvtaat==3
replace   party_vote=7         if        prtvtaat==4
replace   party_vote=1         if        prtvtaat==5
replace   party_vote=4         if        prtvtaat==6
replace   party_vote=2         if        prtvtaat==7
replace   party_vote=0         if        prtvtaat==8
* Belgium
replace   party_vote=1         if        prtvtabe==1
replace   party_vote=5         if        prtvtabe==2
replace   party_vote=5         if        prtvtabe==3
replace   party_vote=3         if        prtvtabe==5
replace   party_vote=.         if        prtvtabe==6
replace   party_vote=7         if        prtvtabe==7
replace   party_vote=4         if        prtvtabe==8
replace   party_vote=5         if        prtvtabe==9
replace   party_vote=1         if        prtvtabe==10
replace   party_vote=7         if        prtvtabe==11
replace   party_vote=4         if        prtvtabe==12
replace   party_vote=3         if        prtvtabe==13
replace   party_vote=0         if        prtvtabe==14
replace   party_vote=.         if        prtvtabe==15
replace   party_vote=.         if        prtvtabe==16
* Switzerland
replace   party_vote=4         if        prtvtach==1
replace   party_vote=5         if        prtvtach==2
replace   party_vote=3         if        prtvtach==3
replace   party_vote=7         if        prtvtach==4
replace   party_vote=4         if        prtvtach==5
replace   party_vote=5         if        prtvtach==7
replace   party_vote=.         if        prtvtach==8
replace   party_vote=2         if        prtvtach==9
replace   party_vote=1         if        prtvtach==10
replace   party_vote=7         if        prtvtach==11
replace   party_vote=7         if        prtvtach==12
replace   party_vote=7         if        prtvtach==13
replace   party_vote=.         if        prtvtach==14
replace   party_vote=.         if        prtvtach==15
replace   party_vote=0         if        prtvtach==16
* Czech Republic: no observations
* Germany
replace   party_vote=3         if        prtvbde1==1
replace   party_vote=5         if        prtvbde1==2
replace   party_vote=1         if        prtvbde1==3
replace   party_vote=4         if        prtvbde1==4
replace   party_vote=2         if        prtvbde1==5
replace   party_vote=7         if        prtvbde1==6
replace   party_vote=7         if        prtvbde1==7
replace   party_vote=0         if        prtvbde1==8
* Denmark
replace   party_vote=3         if        prtvtadk==1
replace   party_vote=1         if        prtvtadk==2
replace   party_vote=6         if        prtvtadk==3
replace   party_vote=5         if        prtvtadk==4
replace   party_vote=1         if        prtvtadk==5
replace   party_vote=7         if        prtvtadk==6
replace   party_vote=5         if        prtvtadk==7
replace   party_vote=4         if        prtvtadk==8
replace   party_vote=7         if        prtvtadk==9
replace   party_vote=2         if        prtvtadk==10
replace   party_vote=0         if        prtvtadk==11
* Spain
replace   party_vote=6         if        prtvtaes==1
replace   party_vote=3         if        prtvtaes==2
replace   party_vote=2         if        prtvtaes==3
replace   party_vote=6         if        prtvtaes==4
replace   party_vote=0         if        prtvtaes==5
replace   party_vote=.         if        prtvtaes==6
replace   party_vote=0         if        prtvtaes==7
replace   party_vote=0         if        prtvtaes==8
replace   party_vote=0         if        prtvtaes==9
replace   party_vote=0         if        prtvtaes==10
replace   party_vote=0         if        prtvtaes==11
replace   party_vote=0         if        prtvtaes==12
replace   party_vote=.         if        prtvtaes==13
replace   party_vote=0         if        prtvtaes==74
replace   party_vote=.         if        prtvtaes==75
replace   party_vote=.         if        prtvtaes==76
* Finland
replace   party_vote=6         if        prtvtfi== 1
replace   party_vote=0         if        prtvtfi== 2
replace   party_vote=5         if        prtvtfi== 4
replace   party_vote=7         if        prtvtfi== 5
replace   party_vote=5         if        prtvtfi== 6
replace   party_vote=1         if        prtvtfi== 8
replace   party_vote=3         if        prtvtfi== 9
replace   party_vote=2         if        prtvtfi== 10
replace   party_vote=.         if        prtvtfi== 11
replace   party_vote=0         if        prtvtfi== 14
* France
replace   party_vote=.         if        prtvtafr==1
replace   party_vote=4         if        prtvtafr==2
replace   party_vote=7         if        prtvtafr==3
replace   party_vote=.         if        prtvtafr==4
replace   party_vote=.         if        prtvtafr==5
replace   party_vote=2         if        prtvtafr==6
replace   party_vote=7         if        prtvtafr==7
replace   party_vote=.         if        prtvtafr==8
replace   party_vote=2         if        prtvtafr==9
replace   party_vote=3         if        prtvtafr==10
replace   party_vote=.         if        prtvtafr==11
replace   party_vote=6         if        prtvtafr==12
replace   party_vote=4         if        prtvtafr==13
replace   party_vote=1         if        prtvtafr==14
replace   party_vote=.         if        prtvtafr==15
replace   party_vote=0         if        prtvtafr==16
replace   party_vote=.         if        prtvtafr==17
* Great Britain
replace   party_vote=6         if        prtvtagb==1
replace   party_vote=3         if        prtvtagb==2
replace   party_vote=4         if        prtvtagb==3
replace   party_vote=0         if        prtvtagb==4
replace   party_vote=0         if        prtvtagb==5
replace   party_vote=.         if        prtvtagb==6
replace   party_vote=7         if        prtvtagb==7
replace   party_vote=0         if        prtvtagb==8
replace   party_vote=.         if        prtvtagb==9
replace   party_vote=6         if        prtvtagb==11
replace   party_vote=0         if        prtvtagb==12
replace   party_vote=2         if        prtvtagb==13
replace   party_vote=3         if        prtvtagb==14
replace   party_vote=0         if        prtvtagb==15
replace   party_vote=0         if        prtvtagb==22
* Greece: no observations
* Ireland
replace   party_vote=6         if        prtvtie== 1
replace   party_vote=5         if        prtvtie== 2
replace   party_vote=3         if        prtvtie== 3
replace   party_vote=4         if        prtvtie== 4
replace   party_vote=1         if        prtvtie== 5
replace   party_vote=2         if        prtvtie== 6
replace   party_vote=.         if        prtvtie== 7
replace   party_vote=0         if        prtvtie== 8
* Israel: no observations
* Iceland: no observations
* Italy: no observations
* Luxembourg: no observations
* Netherlands
replace   party_vote=5         if        prtvtbnl==1
replace   party_vote=3         if        prtvtbnl==2
replace   party_vote=4         if        prtvtbnl==3
replace   party_vote=7         if        prtvtbnl==4
replace   party_vote=4         if        prtvtbnl==5
replace   party_vote=1         if        prtvtbnl==6
replace   party_vote=2         if        prtvtbnl==7
replace   party_vote=5         if        prtvtbnl==8
replace   party_vote=4         if        prtvtbnl==9
replace   party_vote=4         if        prtvtbnl==10
replace   party_vote=0         if        prtvtbnl==11
replace   party_vote=.         if        prtvtbnl==12
* Norway
replace   party_vote=.         if        prtvtno== 1
replace   party_vote=2         if        prtvtno== 2
replace   party_vote=3         if        prtvtno== 3
replace   party_vote=4         if        prtvtno== 4
replace   party_vote=5         if        prtvtno== 5
replace   party_vote=5         if        prtvtno== 6
replace   party_vote=6         if        prtvtno== 7
replace   party_vote=7         if        prtvtno== 8
replace   party_vote=.         if        prtvtno== 9
replace   party_vote=0         if        prtvtno== 10
* Portugal
replace   party_vote=2         if        prtvtapt==1
replace   party_vote=5         if        prtvtapt==2
replace   party_vote=2         if        prtvtapt==3
replace   party_vote=.         if        prtvtapt==4
replace   party_vote=.         if        prtvtapt==6
replace   party_vote=.         if        prtvtapt==7
replace   party_vote=5         if        prtvtapt==10
replace   party_vote=3         if        prtvtapt==11
replace   party_vote=.         if        prtvtapt==12
* Sweden
replace   party_vote=5         if        prtvtse== 1
replace   party_vote=4         if        prtvtse== 2
replace   party_vote=5         if        prtvtse== 3
replace   party_vote=1         if        prtvtse== 4
replace   party_vote=6         if        prtvtse== 5
replace   party_vote=3         if        prtvtse== 6
replace   party_vote=2         if        prtvtse== 7
replace   party_vote=0         if        prtvtse== 8
* Definition of value labels
label def party_vote 0 "Other" 1 "Green" 2 "Communist" 3 "Social democratic" ///
	4 "Liberal"	5 "Christian democratic" 6 "Conservative" 7 "Right-Wing"
label val party_vote party_vote

*** Party closeness (not classified parties are missings)
* Creation of variable
gen party_close=.
label var party_close "Party closeness"
* Austria
replace   party_close=3         if        prtclaat==1
replace   party_close=5         if        prtclaat==2
replace   party_close=7         if        prtclaat==3
replace   party_close=7         if        prtclaat==4
replace   party_close=1         if        prtclaat==5
replace   party_close=4         if        prtclaat==6
replace   party_close=2         if        prtclaat==7
replace   party_close=0         if        prtclaat==8
* Belgium
replace   party_close=1         if        prtclabe==1
replace   party_close=5         if        prtclabe==2
replace   party_close=5         if        prtclabe==3
replace   party_close=3         if        prtclabe==5
replace   party_close=.         if        prtclabe==6
replace   party_close=7         if        prtclabe==7
replace   party_close=4         if        prtclabe==8
replace   party_close=5         if        prtclabe==9
replace   party_close=1         if        prtclabe==10
replace   party_close=7         if        prtclabe==11
replace   party_close=4         if        prtclabe==12
replace   party_close=3         if        prtclabe==13
replace   party_close=0         if        prtclabe==14
replace   party_close=.         if        prtclabe==15
replace   party_close=.         if        prtclabe==16
* Switzerland
replace   party_close=4         if        prtclach==1
replace   party_close=5         if        prtclach==2
replace   party_close=3         if        prtclach==3
replace   party_close=7         if        prtclach==4
replace   party_close=4         if        prtclach==5
replace   party_close=5         if        prtclach==7
replace   party_close=.         if        prtclach==8
replace   party_close=2         if        prtclach==9
replace   party_close=1         if        prtclach==10
replace   party_close=7         if        prtclach==11
replace   party_close=7         if        prtclach==12
replace   party_close=7         if        prtclach==13
replace   party_close=.         if        prtclach==14
replace   party_close=.         if        prtclach==15
replace   party_close=0         if        prtclach==16
* Czech Republic: no observations
* Germany
replace   party_close=3         if        prtclbde==1
replace   party_close=5         if        prtclbde==2
replace   party_close=1         if        prtclbde==3
replace   party_close=4         if        prtclbde==4
replace   party_close=2         if        prtclbde==5
replace   party_close=7         if        prtclbde==6
replace   party_close=7         if        prtclbde==7
replace   party_close=0         if        prtclbde==8
* Denmark
replace   party_close=3         if        prtcladk==1
replace   party_close=1         if        prtcladk==2
replace   party_close=6         if        prtcladk==3
replace   party_close=5         if        prtcladk==4
replace   party_close=1         if        prtcladk==5
replace   party_close=7         if        prtcladk==6
replace   party_close=5         if        prtcladk==7
replace   party_close=4         if        prtcladk==8
replace   party_close=7         if        prtcladk==9
replace   party_close=2         if        prtcladk==10
replace   party_close=0         if        prtcladk==11
* Spain
replace   party_close=6         if        prtclaes==1
replace   party_close=3         if        prtclaes==2
replace   party_close=2         if        prtclaes==3
replace   party_close=6         if        prtclaes==4
replace   party_close=0         if        prtclaes==5
replace   party_close=.         if        prtclaes==6
replace   party_close=0         if        prtclaes==7
replace   party_close=0         if        prtclaes==8
replace   party_close=0         if        prtclaes==9
replace   party_close=0         if        prtclaes==10
replace   party_close=0         if        prtclaes==11
replace   party_close=0         if        prtclaes==12
replace   party_close=.         if        prtclaes==13
replace   party_close=0         if        prtclaes==74
replace   party_close=.         if        prtclaes==75
replace   party_close=.         if        prtclaes==76
* Finland
replace   party_close=6         if        prtclfi== 1
replace   party_close=0         if        prtclfi== 2
replace   party_close=5         if        prtclfi== 4
replace   party_close=7         if        prtclfi== 5
replace   party_close=5         if        prtclfi== 6
replace   party_close=1         if        prtclfi== 8
replace   party_close=3         if        prtclfi== 9
replace   party_close=2         if        prtclfi== 10
replace   party_close=.         if        prtclfi== 11
replace   party_close=0         if        prtclfi== 14
* France
replace   party_close=.         if        prtclafr==1
replace   party_close=4         if        prtclafr==2
replace   party_close=7         if        prtclafr==3
replace   party_close=.         if        prtclafr==4
replace   party_close=.         if        prtclafr==5
replace   party_close=2         if        prtclafr==6
replace   party_close=7         if        prtclafr==7
replace   party_close=.         if        prtclafr==8
replace   party_close=2         if        prtclafr==9
replace   party_close=3         if        prtclafr==10
replace   party_close=.         if        prtclafr==11
replace   party_close=6         if        prtclafr==12
replace   party_close=4         if        prtclafr==13
replace   party_close=1         if        prtclafr==14
replace   party_close=.         if        prtclafr==15
replace   party_close=0         if        prtclafr==16
replace   party_close=.         if        prtclafr==17
* Great Britain
replace   party_close=6         if        prtclagb==1
replace   party_close=3         if        prtclagb==2
replace   party_close=4         if        prtclagb==3
replace   party_close=0         if        prtclagb==4
replace   party_close=0         if        prtclagb==5
replace   party_close=.         if        prtclagb==6
replace   party_close=7         if        prtclagb==7
replace   party_close=0         if        prtclagb==8
replace   party_close=.         if        prtclagb==9
replace   party_close=6         if        prtclagb==11
replace   party_close=0         if        prtclagb==12
replace   party_close=2         if        prtclagb==13
replace   party_close=3         if        prtclagb==14
replace   party_close=0         if        prtclagb==15
replace   party_close=0         if        prtclagb==22
* Greece: no observations
* Ireland
replace   party_close=6         if        prtclaie== 1
replace   party_close=5         if        prtclaie== 2
replace   party_close=3         if        prtclaie== 3
replace   party_close=4         if        prtclaie== 4
replace   party_close=1         if        prtclaie== 5
replace   party_close=2         if        prtclaie== 6
replace   party_close=.         if        prtclaie== 7
replace   party_close=0         if        prtclaie== 8
* Israel: no observations
* Iceland: no observations
* Italy: no observations
* Luxembourg: no observations
* Netherlands
replace   party_close=5         if        prtclnl==1
replace   party_close=3         if        prtclnl==2
replace   party_close=4         if        prtclnl==3
replace   party_close=7         if        prtclnl==4
replace   party_close=4         if        prtclnl==5
replace   party_close=1         if        prtclnl==6
replace   party_close=2         if        prtclnl==7
replace   party_close=5         if        prtclnl==8
replace   party_close=4         if        prtclnl==9
replace   party_close=4         if        prtclnl==10
replace   party_close=0         if        prtclnl==11
replace   party_close=.         if        prtclnl==12
* Norway
replace   party_close=.         if        prtclno== 1
replace   party_close=2         if        prtclno== 2
replace   party_close=3         if        prtclno== 3
replace   party_close=4         if        prtclno== 4
replace   party_close=5         if        prtclno== 5
replace   party_close=5         if        prtclno== 6
replace   party_close=6         if        prtclno== 7
replace   party_close=7         if        prtclno== 8
replace   party_close=.         if        prtclno== 9
replace   party_close=0         if        prtclno== 10
* Portugal
replace   party_close=2         if        prtclbpt==1
replace   party_close=5         if        prtclbpt==2
replace   party_close=2         if        prtclbpt==3
replace   party_close=.         if        prtclbpt==4
replace   party_close=.         if        prtclbpt==6
replace   party_close=.         if        prtclbpt==7
replace   party_close=5         if        prtclbpt==10
replace   party_close=3         if        prtclbpt==11
replace   party_close=.         if        prtclbpt==12
* Sweden
replace   party_close=5         if        prtclse== 1
replace   party_close=4         if        prtclse== 2
replace   party_close=5         if        prtclse== 3
replace   party_close=1         if        prtclse== 4
replace   party_close=6         if        prtclse== 5
replace   party_close=3         if        prtclse== 6
replace   party_close=2         if        prtclse== 7
replace   party_close=0         if        prtclse== 8
* Definition of value labels
label def party_close 0 "Other" 1 "Green" 2 "Communist" 3 "Social democratic" ///
	4 "Liberal"	5 "Christian democratic" 6 "Conservative" 7 "Right-Wing"
label val party_close party_close

*** Voter participation
* Creation of variable 
gen voted=vote==1
replace voted=. if vote>2
lab var voted "Voter participation"
* Definition of value label
lab define voted 1 "Voter" 0 "Non-voter"
lab values voted voted


save "ESSrecoded3.dta", replace

*----------------------------------------------------------------------------------------*
*	4. prepare/recode ESS4
*----------------------------------------------------------------------------------------*



*----------------------------------------------------------------------------------------*
*	1. Operationalization of variables, round 4 - 2008
*----------------------------------------------------------------------------------------*
* Basic commands
clear all
set mem 1g
set more off
capture log close


* Import dataset (from ESS website)
use ESS4e04_3.dta



*	1.0 country selection: 
* AT, BE, CH, GE, DK, SP, FIN, FR, UK, GR, IE, IT, NL, NO, PT, SE
 
drop if cntry=="CZ"
drop if cntry=="HU"
drop if cntry=="LU"
drop if cntry=="PL"
drop if cntry=="SI"
drop if cntry=="IL"
drop if cntry=="EE"
drop if cntry=="IS"
drop if cntry=="SK"
drop if cntry=="TR"
drop if cntry=="UA"
drop if cntry=="RU"
drop if cntry=="BG"
drop if cntry=="CY"
drop if cntry=="LV"
drop if cntry=="RO"
drop if cntry=="HR"
drop if cntry=="LT"


gen at=cntry=="AT"
lab var at "Country dummy Austria"
gen be=cntry=="BE"
lab var be "Country dummy Belgium"
gen ch=cntry=="CH"
lab var ch "Country dummy Switzerland"
gen de=cntry=="DE"
lab var de "Country dummy Germany"
gen dk=cntry=="DK"
lab var dk "Country dummy Denmark"
gen es=cntry=="ES"
lab var es "Country dummy Spain"
gen fi=cntry=="FI"
lab var fi "Country dummy Finland"
gen fr=cntry=="FR"
lab var fr "Country dummy France"
gen gb=cntry=="GB"
lab var gb "Country dummy United Kingdom"
gen gr=cntry=="GR"
lab var gr "Country dummy Greece"
gen ie=cntry=="IE"
lab var ie "Country dummy Ireland"
gen it=cntry=="IT"
lab var it "Country dummy Italy"
gen nl=cntry=="NL"
lab var nl "Country dummy Netherlands"
gen no=cntry=="NO"
lab var no "Country dummy Norway"
gen pt=cntry=="PT"
lab var pt "Country dummy Portugal"
gen se=cntry=="SE"
lab var se "Country dummy Sweden"


*******************************
*   1.1 GLOBALIZATION LOSERS
*******************************

** from Rommel /Walter: combination of offshoreable and low-skill (educlvl und offshore2)

* Creation of variable
gen educyrs=eduyrs
lab var educyrs "Years of Education"
* Recoding of variable
replace educyrs=25 if eduyrs>25 & eduyrs<.


***** 2.2 Education level
*----------------------------------------------------------------------------------------*

* Creation of variable
gen educlvl=edulvla
lab var educlvl "Education level"
* Recoding of variable and definition of value label
recode educlvl (55=.)
label define educlvl 1 "Less than lower secondary education" ///
	2 "Lower secondary education completed" ///
	3 "Upper secondary education completed" ///
	4 "Post-secondary, non-tertiary education completed" ///
	5 "Tertiary education completed"
label values educlvl educlvl


*** Creation of 4-digit ISCO-Code
gen isco=iscoco
lab var isco "4-digit ISCO-code"

*** Metric offshoreability variable
* Creation of variable
gen offshore=.
replace offshore=0 if isco<.
replace offshore=49 if isco==1142
replace offshore=55 if isco==1222
replace offshore=28 if isco==1226
replace offshore=55 if isco==1228
replace offshore=83 if isco==1231
replace offshore=49 if isco==1232
replace offshore=40 if isco==1233
replace offshore=53 if isco==1234
replace offshore=49 if isco==1235
replace offshore=55 if isco==1236
replace offshore=55 if isco==1237
replace offshore=55 if isco==1311
replace offshore=55 if isco==1312
replace offshore=55 if isco==1313
replace offshore=55 if isco==1314
replace offshore=55 if isco==1315
replace offshore=48 if isco==1316
replace offshore=52 if isco==1317
replace offshore=55 if isco==1318
replace offshore=55 if isco==1319
replace offshore=66 if isco==2111
replace offshore=74 if isco==2112
replace offshore=66 if isco==2113
replace offshore=66 if isco==2114
replace offshore=89 if isco==2121
replace offshore=96 if isco==2122
replace offshore=83 if isco==2131
replace offshore=90 if isco==2139
replace offshore=25 if isco==2141
replace offshore=64 if isco==2143
replace offshore=74 if isco==2144
replace offshore=72 if isco==2146
replace offshore=69 if isco==2147
replace offshore=86 if isco==2148
replace offshore=71 if isco==2149
replace offshore=81 if isco==2211
replace offshore=83 if isco==2212
replace offshore=72 if isco==2411
replace offshore=50 if isco==2419
replace offshore=74 if isco==2421
replace offshore=67 if isco==2444
replace offshore=90 if isco==2451
replace offshore=78 if isco==2452
replace offshore=25 if isco==2453
replace offshore=48 if isco==2455
replace offshore=47 if isco==3111
replace offshore=47 if isco==3113
replace offshore=47 if isco==3114
replace offshore=72 if isco==3115
replace offshore=47 if isco==3116
replace offshore=94 if isco==3118
replace offshore=54 if isco==3119
replace offshore=75 if isco==3121
replace offshore=84 if isco==3122
replace offshore=68 if isco==3123
replace offshore=36 if isco==3131
replace offshore=36 if isco==3132
replace offshore=46 if isco==3133
replace offshore=34 if isco==3139
replace offshore=52 if isco==3141
replace offshore=60 if isco==3152
replace offshore=55 if isco==3211
replace offshore=55 if isco==3212
replace offshore=44 if isco==3213
replace offshore=32 if isco==3228
replace offshore=51 if isco==3411
replace offshore=85 if isco==3412
replace offshore=50 if isco==3414
replace offshore=55 if isco==3416
replace offshore=59 if isco==3419
replace offshore=51 if isco==3421
replace offshore=48 if isco==3422
replace offshore=38 if isco==3431
replace offshore=51 if isco==3432
replace offshore=84 if isco==3433
replace offshore=84 if isco==3434
replace offshore=54 if isco==3439
replace offshore=100 if isco==3442
replace offshore=85 if isco==3471
replace offshore=30 if isco==3472
replace offshore=95 if isco==4111
replace offshore=94 if isco==4112
replace offshore=100 if isco==4113
replace offshore=71 if isco==4114
replace offshore=38 if isco==4115
replace offshore=84 if isco==4121
replace offshore=54 if isco==4122
replace offshore=31 if isco==4131
replace offshore=67 if isco==4132
replace offshore=67 if isco==4133
replace offshore=46 if isco==4141
replace offshore=26 if isco==4142
replace offshore=95 if isco==4143
replace offshore=54 if isco==4144
replace offshore=54 if isco==4190
replace offshore=94 if isco==4211
replace offshore=54 if isco==4214
replace offshore=65 if isco==4215
replace offshore=72 if isco==4221
replace offshore=54 if isco==4222
replace offshore=50 if isco==4223
replace offshore=86 if isco==5113
replace offshore=59 if isco==6142
replace offshore=36 if isco==7111
replace offshore=35 if isco==7112
replace offshore=36 if isco==7113
replace offshore=65 if isco==7211
replace offshore=69 if isco==7212
replace offshore=70 if isco==7213
replace offshore=70 if isco==7222
replace offshore=68 if isco==7223
replace offshore=68 if isco==7224
replace offshore=26 if isco==7311
replace offshore=64 if isco==7313
replace offshore=69 if isco==7321
replace offshore=69 if isco==7322
replace offshore=68 if isco==7323
replace offshore=68 if isco==7324
replace offshore=60 if isco==7331
replace offshore=75 if isco==7332
replace offshore=59 if isco==7341
replace offshore=59 if isco==7342
replace offshore=59 if isco==7343
replace offshore=34 if isco==7344
replace offshore=59 if isco==7345
replace offshore=75 if isco==7346
replace offshore=68 if isco==7413
replace offshore=27 if isco==7414
replace offshore=55 if isco==7415
replace offshore=43 if isco==7421
replace offshore=57 if isco==7422
replace offshore=57 if isco==7423
replace offshore=66 if isco==7424
replace offshore=75 if isco==7431
replace offshore=75 if isco==7432
replace offshore=75 if isco==7433
replace offshore=73 if isco==7434
replace offshore=75 if isco==7435
replace offshore=75 if isco==7436
replace offshore=57 if isco==7437
replace offshore=75 if isco==7441
replace offshore=72 if isco==7442
replace offshore=36 if isco==8111
replace offshore=36 if isco==8112
replace offshore=36 if isco==8113
replace offshore=59 if isco==8121
replace offshore=68 if isco==8122
replace offshore=70 if isco==8123
replace offshore=68 if isco==8124
replace offshore=69 if isco==8131
replace offshore=68 if isco==8139
replace offshore=57 if isco==8141
replace offshore=68 if isco==8142
replace offshore=68 if isco==8143
replace offshore=68 if isco==8151
replace offshore=70 if isco==8152
replace offshore=68 if isco==8153
replace offshore=68 if isco==8154
replace offshore=29 if isco==8155
replace offshore=68 if isco==8159
replace offshore=42 if isco==8161
replace offshore=55 if isco==8162
replace offshore=29 if isco==8163
replace offshore=64 if isco==8171
replace offshore=68 if isco==8172
replace offshore=68 if isco==8211
replace offshore=68 if isco==8212
replace offshore=68 if isco==8221
replace offshore=35 if isco==8222
replace offshore=68 if isco==8223
replace offshore=41 if isco==8224
replace offshore=29 if isco==8229
replace offshore=69 if isco==8231
replace offshore=68 if isco==8232
replace offshore=57 if isco==8240
replace offshore=58 if isco==8251
replace offshore=59 if isco==8252
replace offshore=68 if isco==8253
replace offshore=75 if isco==8261
replace offshore=75 if isco==8262
replace offshore=75 if isco==8263
replace offshore=75 if isco==8264
replace offshore=75 if isco==8265
replace offshore=75 if isco==8266
replace offshore=75 if isco==8269
replace offshore=27 if isco==8271
replace offshore=68 if isco==8272
replace offshore=68 if isco==8273
replace offshore=30 if isco==8274
replace offshore=31 if isco==8275
replace offshore=68 if isco==8276
replace offshore=27 if isco==8277
replace offshore=68 if isco==8278
replace offshore=66 if isco==8281
replace offshore=66 if isco==8282
replace offshore=66 if isco==8283
replace offshore=68 if isco==8284
replace offshore=57 if isco==8285
replace offshore=64 if isco==8286
replace offshore=68 if isco==8290
replace offshore=34 if isco==8340
replace offshore=95 if isco==9113
replace offshore=64 if isco==9321
replace offshore=29 if isco==9333
replace offshore=55 if isco==1227
replace offshore=89 if isco==2121
replace offshore=100 if isco==2132
replace offshore=70 if isco==2145
replace offshore=71 if isco==2149
replace offshore=81 if isco==2211
replace offshore=46 if isco==2412
replace offshore=50 if isco==2419
replace offshore=33 if isco==2432
replace offshore=89 if isco==2441
replace offshore=48 if isco==2455
replace offshore=72 if isco==3115
replace offshore=54 if isco==3119
replace offshore=46 if isco==3133
replace offshore=34 if isco==3139
replace offshore=34 if isco==3224
replace offshore=51 if isco==3411
replace offshore=25 if isco==3415
replace offshore=50 if isco==3417
replace offshore=59 if isco==3419
replace offshore=51 if isco==3432
replace offshore=54 if isco==3439
replace offshore=90 if isco==3460
replace offshore=54 if isco==4122
replace offshore=31 if isco==4131
replace offshore=67 if isco==4132
replace offshore=46 if isco==4141
replace offshore=26 if isco==4142
replace offshore=54 if isco==4222
replace offshore=68 if isco==7141
replace offshore=68 if isco==7224
replace offshore=65 if isco==7241
replace offshore=34 if isco==7344
replace offshore=72 if isco==7442
replace offshore=68 if isco==8122
replace offshore=68 if isco==8139
replace offshore=42 if isco==8161
replace offshore=68 if isco==8211
replace offshore=68 if isco==8223
replace offshore=41 if isco==8224
replace offshore=57 if isco==8240
replace offshore=58 if isco==8251
replace offshore=75 if isco==8269
replace offshore=66 if isco==8281
replace offshore=66 if isco==8283
replace offshore=68 if isco==8284
replace offshore=68 if isco==8290
replace offshore=70 if isco==9322
lab var offshore "Offshoring Potential (Blinder 2007), metric"

*** Creation of ordinal (4-point scale) offshoreability variable
* Creation of variable
gen offshore4=.
replace offshore4=4 if offshore<.
replace offshore4=3 if offshore<75
replace offshore4=2 if offshore<50
replace offshore4=1 if offshore<25
lab var offshore4 "Offshoring Potential (Blinder 2007), ordinal"
* Definition of value label
lab define offshore4 1 "0-24%" 2 "5-49%" 3 "50-74%" 4 "75-100%"
lab values offshore4 offshore4

*** Creation of dichotomous offshoreability variable
* Creation of variable
gen offshore2=.
replace offshore2=1 if offshore>0 & offshore<.
replace offshore2=0 if offshore==0
lab var offshore2 "Offshoring Potential (Blinder 2007), dichotomous"
* Definition of value label
lab define offshore2 0 "Not offshoreable" 1 "Offshoreable"
lab values offshore2 offshore2

***********************

*** Creation of globalization loser variable 1 : low-skilled offshoreable
* Creation of variable
gen glob_losers1=.
replace glob_losers1=1 if offshore2==1 & educlvl<3
replace glob_losers1=0 if offshore2==0 & educlvl<3
replace glob_losers1=0 if offshore2==1 & educlvl>2
replace glob_losers1=0 if offshore2==0 & educlvl>2
lab var glob_losers1 "Globalization losers; lowskilled exposed "
* Definition of value label
lab define glob_losers1 1 "glob loser (l-s off)" 0 "not loser"
lab values glob_losers1 glob_losers1


*** Creation of winner variable 1: low-skilled sheltered
* Creation of variable
gen glob_winners1=.
replace glob_winners1 =0 if offshore2==1 & educlvl<3
replace glob_winners1 =1 if offshore2==0 & educlvl<3
replace glob_winners1 =0 if offshore2==1 & educlvl>2
replace glob_winners1 =0 if offshore2==0 & educlvl>2
lab var glob_winners1 "Globalization winners; lowskilled sheltered "
* Definition of value label
lab define glob_winners1 1 "glob winners (l-s sheltered)" 0 "not winner"
lab values glob_winners1 glob_losers1


************************************
*	1.2 MODERNIZATION LOSERS

* Oesch 16-classes for respondents only (according to syntax on his website)

****************************************************************************************
* Respondent's Oesch class position
* Recode and create variables used to construct class variable for respondents
* Variables used to construct class variable for respondents: iscoco, emplrel, emplno
****************************************************************************************

**** Recode occupation variable (isco88 com 4-digit) for respondents

tab iscoco

recode iscoco (missing=-9), copyrest gen(isco_mainjob)
label variable isco_mainjob "Current occupation of respondent - isco88 4-digit"
tab isco_mainjob

**** Recode employment status for respondents

tab emplrel

recode emplrel (missing=9), copyrest gen(emplrel_r)
replace emplrel_r=-9 if cntry=="FR" & (essround==1 | essround==2) // Replace this command line with [SYNTAX G and SYNTAX I]
replace emplrel_r=-9 if cntry=="HU" & essround==2 // Replace this command line with [SYNTAX E]
label define emplrel_r ///
1 "Employee" ///
2 "Self-employed" ///
3 "Working for own family business" ///
9 "Missing"
label value emplrel_r emplrel_r
tab emplrel_r

tab emplno

recode emplno (0=0)(1/9=1)(10/10000=2)(missing=0), gen(emplno_r)
label define emplno_r ///
0 "0 employees" ///
1 "1-9 employees" ///
2 "10+ employees"
label value emplno_r emplno_r
tab emplno_r


gen selfem_mainjob=.
replace selfem_mainjob=1 if emplrel_r==1 | emplrel_r==9
replace selfem_mainjob=2 if emplrel_r==2 & emplno_r==0
replace selfem_mainjob=2 if emplrel_r==3
replace selfem_mainjob=3 if emplrel_r==2 & emplno_r==1
replace selfem_mainjob=4 if emplrel_r==2 & emplno_r==2
label variable selfem_mainjob "Employment status for respondants"
label define selfem_mainjob ///
1 "Not self-employed" ///
2 "Self-empl without employees" ///
3 "Self-empl with 1-9 employees" ///
4 "Self-empl with 10 or more"
label value selfem_mainjob selfem_mainjob
tab selfem_mainjob


*************************************************
* Create Oesch class schema for respondents
*************************************************

gen class16_r = -9

* Large employers (1)

replace class16_r=1 if selfem_mainjob==4


* Self-employed professionals (2)

replace class16_r=2 if (selfem_mainjob==2 | selfem_mainjob==3) & (isco_mainjob >= 2000 & isco_mainjob <= 2229) 
replace class16_r=2 if (selfem_mainjob==2 | selfem_mainjob==3) & (isco_mainjob >= 2300 & isco_mainjob <= 2470)

* Small business owners with employees (3)

replace class16_r=3 if (selfem_mainjob==3) & (isco_mainjob >= 1000 & isco_mainjob <= 1999)
replace class16_r=3 if (selfem_mainjob==3) & (isco_mainjob >= 3000 & isco_mainjob <= 9333)
replace class16_r=3 if (selfem_mainjob==3) & (isco_mainjob == 2230)

* Small business owners without employees (4)

replace class16_r=4 if (selfem_mainjob==2) & (isco_mainjob >= 1000 & isco_mainjob <= 1999)
replace class16_r=4 if (selfem_mainjob==2) & (isco_mainjob >= 3000 & isco_mainjob <= 9333)
replace class16_r=4 if (selfem_mainjob==2) & (isco_mainjob == 2230)

* Technical experts (5)

replace class16_r=5 if (selfem_mainjob==1) & (isco_mainjob >= 2100 & isco_mainjob <= 2213)

* Technicians (6)

replace class16_r=6 if (selfem_mainjob==1) & (isco_mainjob >= 3100 & isco_mainjob <= 3152)
replace class16_r=6 if (selfem_mainjob==1) & (isco_mainjob >= 3210 & isco_mainjob <= 3213)
replace class16_r=6 if (selfem_mainjob==1) & (isco_mainjob == 3434)

* Skilled manual (7)

replace class16_r=7 if (selfem_mainjob==1) & (isco_mainjob >= 6000 & isco_mainjob <= 7442)
replace class16_r=7 if (selfem_mainjob==1) & (isco_mainjob >= 8310 & isco_mainjob <= 8312)
replace class16_r=7 if (selfem_mainjob==1) & (isco_mainjob >= 8324 & isco_mainjob <= 8330)
replace class16_r=7 if (selfem_mainjob==1) & (isco_mainjob >= 8332 & isco_mainjob <= 8340)

* Low-skilled manual (8)

replace class16_r=8 if (selfem_mainjob==1) & (isco_mainjob >= 8000 & isco_mainjob <= 8300)
replace class16_r=8 if (selfem_mainjob==1) & (isco_mainjob >= 8320 & isco_mainjob <= 8321)
replace class16_r=8 if (selfem_mainjob==1) & (isco_mainjob == 8331)
replace class16_r=8 if (selfem_mainjob==1) & (isco_mainjob >= 9153 & isco_mainjob <= 9333)

* Higher-grade managers and administrators (9)

replace class16_r=9 if (selfem_mainjob==1) & (isco_mainjob >= 1000 & isco_mainjob <= 1239)
replace class16_r=9 if (selfem_mainjob==1) & (isco_mainjob >= 2400 & isco_mainjob <= 2429)
replace class16_r=9 if (selfem_mainjob==1) & (isco_mainjob == 2441)
replace class16_r=9 if (selfem_mainjob==1) & (isco_mainjob == 2470)

* Lower-grade managers and administrators (10)

replace class16_r=10 if (selfem_mainjob==1) & (isco_mainjob >= 1300 & isco_mainjob <= 1319)
replace class16_r=10 if (selfem_mainjob==1) & (isco_mainjob >= 3400 & isco_mainjob <= 3433)
replace class16_r=10 if (selfem_mainjob==1) & (isco_mainjob >= 3440 & isco_mainjob <= 3450)

* Skilled clerks (11)

replace class16_r=11 if (selfem_mainjob==1) & (isco_mainjob >= 4000 & isco_mainjob <= 4112)
replace class16_r=11 if (selfem_mainjob==1) & (isco_mainjob >= 4114 & isco_mainjob <= 4210)
replace class16_r=11 if (selfem_mainjob==1) & (isco_mainjob >= 4212 & isco_mainjob <= 4222)

* Unskilled clerks (12)

replace class16_r=12 if (selfem_mainjob==1) & (isco_mainjob == 4113)
replace class16_r=12 if (selfem_mainjob==1) & (isco_mainjob == 4211)
replace class16_r=12 if (selfem_mainjob==1) & (isco_mainjob == 4223)

* Socio-cultural professionals (13)

replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob >= 2220 &  isco_mainjob <= 2229)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob >= 2300 &  isco_mainjob <= 2320)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob >= 2340 &  isco_mainjob <= 2359)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob >= 2430 &  isco_mainjob <= 2440)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob >= 2442 &  isco_mainjob <= 2443)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob == 2445)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob == 2451)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob == 2460)

* Socio-cultural semi-professionals (14)

replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob == 2230)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob >= 2330 & isco_mainjob <= 2332)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob == 2444)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob >= 2446 & isco_mainjob <= 2450)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob >= 2452 & isco_mainjob <= 2455)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob == 3200)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob >= 3220 & isco_mainjob <= 3224)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob == 3226)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob >= 3229 & isco_mainjob <= 3340)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob >= 3460 & isco_mainjob <= 3472)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob == 3480)

* Skilled service (15)

replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob == 3225)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob >= 3227 & isco_mainjob <= 3228)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob >= 3473 & isco_mainjob <= 3475)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob >= 5000 & isco_mainjob <= 5113)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob == 5122)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob >= 5131 & isco_mainjob <= 5132)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob >= 5140 & isco_mainjob <= 5141)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob == 5143)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob >= 5160 & isco_mainjob <= 5220)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob == 8323)

* Low-skilled service (16)

replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob >= 5120 & isco_mainjob <= 5121)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob >= 5123 & isco_mainjob <= 5130)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob >= 5133 & isco_mainjob <= 5139)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob == 5142)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob == 5149)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob == 5230)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob == 8322)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob >= 9100 &  isco_mainjob <= 9152)

mvdecode class16_r, mv(-9)
label variable class16_r "Respondent's Oesch class position - 16 classes"
label define class16_r ///
1 "Large employers" ///
2 "Self-employed professionals" ///
3 "Small business owners with employees" ///
4 "Small business owners without employees" ///
5 "Technical experts" ///
6 "Technicians" ///
7 "Skilled manual" ///
8 "Low-skilled manual" ///
9 "Higher-grade managers and administrators" ///
10 "Lower-grade managers and administrators" ///
11 "Skilled clerks" ///
12 "Unskilled clerks" ///
13 "Socio-cultural professionals" ///
14 "Socio-cultural semi-professionals" ///
15 "Skilled service" ///
16 "Low-skilled service"
label value class16_r class16_r
tab class16_r

recode class16_r (1 2=1)(3 4=2)(5 6=3)(7 8=4)(9 10=5)(11 12=6)(13 14=7)(15 16=8), gen(class8_r)
label variable class8_r "Respondent's Oesch class position - 8 classes"
label define class8_r ///
1 "Self-employed professionals and large employers" ///
2 "Small business owners" ///
3 "Technical (semi-)professionals" ///
4 "Production workers" ///
5 "(Associate) managers" ///
6 "Clerks" ///
7 "Socio-cultural (semi-)professionals" ///
8 "Service workers"
label value class8_r class8_r
tab class8_r


*** Aggregated sector variable
* Creation of variable
gen sector=.
replace sector=1 if nace==1 | nace==2 | nace==5
replace sector=2 if nace==10 | nace==11 | nace==12 | nace==13 | nace==14
replace sector=3 if nace==15 | nace==16 | nace==17 | nace==18 | nace==19 | nace==20 ///
	 | nace==21 | nace==22 | nace==23 | nace==24 | nace==25 | nace==26 | nace==27 ///
	 | nace==28 | nace==29 | nace==30 | nace==31 | nace==32 | nace==33 | nace==34 ///
	 | nace==35 | nace==36 | nace==37
replace sector=4 if nace==40 | nace==41
replace sector=5 if nace==45
replace sector=6 if nace==50 | nace==51 | nace==52 | nace==55
replace sector=7 if nace==60 | nace==61 | nace==62 | nace==63 | nace==64
replace sector=8 if nace==65 | nace==66 | nace==67 | nace==70 | nace==71 | nace==72 ///
	 | nace==73 | nace==74
replace sector=9 if nace==75 | nace==80 | nace==85 | nace==90 | nace==91 | nace==92 ///
	 | nace==93 | nace==95 | nace==99
lab var sector "Aggregated sector variable"
* Definition of value label
lab define sector 1 "Agriculture, hunting, forestry and fishing" ///
	2 "Mining and quarrying" ///
	3 "Manufacturing" ///
	4 "Electricity, gas and water" ///
	5 "Construction" ///
	6 "Wholesale and retail trade and restaurants and hotels" ///
	7 "Transport, storage and communications" ///
	8 "Financing, insurance, real estate and busines services" ///
	9 "Community, social and personal services"
lab values sector sector


*** Gender
* Creation of variable
gen gender=gndr
lab var gender "Gender"
* Recoding of variable and definition of value label
recode gender (1=0) (2=1)
lab define gender 0 "male" 1 "female"
lab values gender gender



*** Creation of modernization loser variable 1 : routine service (class 16)
* Creation of variable
gen mod_losers1=.
replace mod_losers1 =1 if class16_r==16
replace mod_losers1 =0 if class16_r!=16
replace mod_losers1=. if class16_r==.

lab var mod_losers1 "Modernization losers 1; routine service oesch "
* Definition of value label
lab define mod_losers1 1 "mod loser (routine service)" 0 "not loser"
lab values mod_losers1 mod_losers1


*** Creation of modernization loser variable 4 : routine and skilled manual (classes 7,8)
* Creation of variable
gen mod_losers4=0
replace mod_losers4 =1 if class16_r==7
replace mod_losers4 =1 if class16_r==8
replace mod_losers4 =. if class16_r==.

lab var mod_losers4 "Modernization losers 4; routine and skilled manual oesch "
* Definition of value label
lab define mod_losers4 1 "mod loser (routine and skilled manual)" 0 "not loser"
lab values mod_losers4 mod_losers4

*** Creation of modernization winner variable 1 : socio-cult prof
* Creation of variable
gen mod_winners1=0
replace mod_winners1 =1 if class16_r==13
replace mod_winners1 =1 if class16_r==14
replace mod_winners1 =. if class16_r==.

lab var mod_winners1 "Modernization winners 1; SCP oesch "
* Definition of value label
lab define mod_winners1 1 "mod winners (SCP oesch)" 0 "not winner"
lab values mod_winners1 mod_winners1


************************************
************************************
*	1.3 lm status: unempl, temp, involunt parttime


*** unemployed in last 5 years
* Creation of variable
gen unemployed5y=uemp5yr==1
lab var unemployed5y "Unemployed in last 5 years"
* Definition of value label
lab define unemployed5y 1 "unemployed in last 5 years" 0 "other"
lab values unemployed5y unemployed5y


*** temporary employed
* Creation of variable
gen temp=wrkctr==2
lab var temp "temporary employed (limited contract)"
* Definition of value label
lab define temp 1 "limited contract" 0 "other"
lab values temp temp


*** part-time
* Creation of variable
gen parttime=wkhct<30
lab var parttime "parttime employed (<30h)"
* Definition of value label
lab define parttime 1 "parttime" 0 "other"
lab values parttime parttime


************************************
************************************
* 	1.4 other variables : country dummies, polint, age, age2, income?, gender, sector?



*** Age
* Creation of variable
gen age=2008-yrbrn
lab var age "Age in years"
gen age2=age^2
lab var age2 "Age in years (squared)"


*** Political interest
* Creation of variable
gen polint=polintr
recode polint (1=4) (2=3) (3=2) (4=1)
lab var polint "Interest in politics"
* Definition of value label
lab define polint 4 "Very interested" 3 "Quite interested" 2 "Hardly interested" ///
	1 "Not at all interested"
lab values polint polint


*** Income
* Creation of variable
gen inc=hinctnt
sum hinctnt if cntry=="AT", detail
replace inc=hinctnt-r(p50) if cntry=="AT"
sum hinctnt if cntry=="BE", detail
replace inc=hinctnt-r(p50) if cntry=="BE"
sum hinctnt if cntry=="CH", detail
replace inc=hinctnt-r(p50) if cntry=="CH"
sum hinctnt if cntry=="CZ", detail
replace inc=hinctnt-r(p50) if cntry=="CZ"
sum hinctnt if cntry=="DE", detail
replace inc=hinctnt-r(p50) if cntry=="DE"
sum hinctnt if cntry=="DK", detail
replace inc=hinctnt-r(p50) if cntry=="DK"
sum hinctnt if cntry=="EE", detail
replace inc=hinctnt-r(p50) if cntry=="EE"
sum hinctnt if cntry=="ES", detail
replace inc=hinctnt-r(p50) if cntry=="ES"
sum hinctnt if cntry=="FI", detail
replace inc=hinctnt-r(p50) if cntry=="FI"
sum hinctnt if cntry=="FR", detail
replace inc=hinctnt-r(p50) if cntry=="FR"
sum hinctnt if cntry=="GB", detail
replace inc=hinctnt-r(p50) if cntry=="GB"
sum hinctnt if cntry=="GR", detail
replace inc=hinctnt-r(p50) if cntry=="GR"
sum hinctnt if cntry=="HU", detail
replace inc=hinctnt-r(p50) if cntry=="HU"
sum hinctnt if cntry=="IE", detail
replace inc=hinctnt-r(p50) if cntry=="IE"
sum hinctnt if cntry=="IL", detail
replace inc=hinctnt-r(p50) if cntry=="IL"
sum hinctnt if cntry=="IS", detail
replace inc=hinctnt-r(p50) if cntry=="IS"
sum hinctnt if cntry=="IT", detail
replace inc=hinctnt-r(p50) if cntry=="IT"
sum hinctnt if cntry=="LU", detail
replace inc=hinctnt-r(p50) if cntry=="LU"
sum hinctnt if cntry=="NL", detail
replace inc=hinctnt-r(p50) if cntry=="NL"
sum hinctnt if cntry=="NO", detail
replace inc=hinctnt-r(p50) if cntry=="NO"
sum hinctnt if cntry=="PL", detail
replace inc=hinctnt-r(p50) if cntry=="PL"
sum hinctnt if cntry=="PT", detail
replace inc=hinctnt-r(p50) if cntry=="PT"
sum hinctnt if cntry=="SE", detail
replace inc=hinctnt-r(p50) if cntry=="SE"
sum hinctnt if cntry=="SI", detail
replace inc=hinctnt-r(p50) if cntry=="SI"
sum hinctnt if cntry=="SK", detail
replace inc=hinctnt-r(p50) if cntry=="SK"
lab var inc "Income, difference between respondet class and median class per country"


************************************
************************************
*	1.5 Party choice and participation (adapted from Rommel&Walter)

*** Partisan preference, last election (not classified parties are missings)
* Creation of variable
gen party_vote=.
label var party_vote "Partisan preference, last election"
* Austria: no observations
* Belgium
replace   party_vote=1         if        prtvtbbe==1
replace   party_vote=5         if        prtvtbbe==2
replace   party_vote=5         if        prtvtbbe==4
replace   party_vote=3         if        prtvtbbe==5
replace   party_vote=7         if        prtvtbbe==7
replace   party_vote=4         if        prtvtbbe==8
replace   party_vote=5         if        prtvtbbe==9
replace   party_vote=1         if        prtvtbbe==10
replace   party_vote=7         if        prtvtbbe==11
replace   party_vote=4         if        prtvtbbe==12
replace   party_vote=3         if        prtvtbbe==13
replace   party_vote=0         if        prtvtbbe==14
replace   party_vote=.         if        prtvtbbe==15
replace   party_vote=.         if        prtvtbbe==16
* Switzerland
replace   party_vote=4         if        prtvtbch==1
replace   party_vote=5         if        prtvtbch==2
replace   party_vote=3         if        prtvtbch==3
replace   party_vote=7         if        prtvtbch==4
replace   party_vote=4         if        prtvtbch==5
replace   party_vote=.         if        prtvtbch==6
replace   party_vote=2         if        prtvtbch==7
replace   party_vote=1         if        prtvtbch==8
replace   party_vote=.         if        prtvtbch==9
replace   party_vote=7         if        prtvtbch==10
replace   party_vote=7         if        prtvtbch==11
replace   party_vote=5         if        prtvtbch==12
replace   party_vote=.         if        prtvtbch==13
replace   party_vote=.         if        prtvtbch==15
replace   party_vote=.         if        prtvtbch==16

* Germany
replace   party_vote=3         if        prtvbde1==1
replace   party_vote=5         if        prtvbde1==2
replace   party_vote=1         if        prtvbde1==3
replace   party_vote=4         if        prtvbde1==4
replace   party_vote=2         if        prtvbde1==5
replace   party_vote=7         if        prtvbde1==6
replace   party_vote=7         if        prtvbde1==7
replace   party_vote=0         if        prtvbde1==8
* Denmark
replace   party_vote=3         if        prtvtbdk==1
replace   party_vote=1         if        prtvtbdk==2
replace   party_vote=6         if        prtvtbdk==3
replace   party_vote=1         if        prtvtbdk==4
replace   party_vote=7         if        prtvtbdk==5
replace   party_vote=5         if        prtvtbdk==6
replace   party_vote=4         if        prtvtbdk==7
replace   party_vote=0         if        prtvtbdk==8
replace   party_vote=2         if        prtvtbdk==9
replace   party_vote=0         if        prtvtbdk==10

* Spain
replace   party_vote=6         if        prtvtbes==1
replace   party_vote=3         if        prtvtbes==2
replace   party_vote=2         if        prtvtbes==3
replace   party_vote=6         if        prtvtbes==4
replace   party_vote=0         if        prtvtbes==5
replace   party_vote=0         if        prtvtbes==6
replace   party_vote=0         if        prtvtbes==7
replace   party_vote=0         if        prtvtbes==8
replace   party_vote=.         if        prtvtbes==9
replace   party_vote=.         if        prtvtbes==10
replace   party_vote=0         if        prtvtbes==74
replace   party_vote=.         if        prtvtbes==75
replace   party_vote=.         if        prtvtbes==76
* Finland
replace   party_vote=6         if        prtvtafi==1
replace   party_vote=0         if        prtvtafi==2
replace   party_vote=4         if        prtvtafi==3
replace   party_vote=5         if        prtvtafi==4
replace   party_vote=7         if        prtvtafi==5
replace   party_vote=5         if        prtvtafi==6
replace   party_vote=1         if        prtvtafi==7
replace   party_vote=3         if        prtvtafi==8
replace   party_vote=2         if        prtvtafi==9
replace   party_vote=.         if        prtvtafi==10
replace   party_vote=.         if        prtvtafi==11
replace   party_vote=0         if        prtvtafi==12
* France
replace   party_vote=.         if        prtvtbfr==1
replace   party_vote=7         if        prtvtbfr==2
replace   party_vote=2         if        prtvtbfr==3
replace   party_vote=2         if        prtvtbfr==4
replace   party_vote=.         if        prtvtbfr==5
replace   party_vote=4         if        prtvtbfr==6
replace   party_vote=2         if        prtvtbfr==7
replace   party_vote=3         if        prtvtbfr==8
replace   party_vote=.         if        prtvtbfr==9
replace   party_vote=4         if        prtvtbfr==10
replace   party_vote=6         if        prtvtbfr==11
replace   party_vote=1         if        prtvtbfr==12
replace   party_vote=.         if        prtvtbfr==13
replace   party_vote=0         if        prtvtbfr==14
replace   party_vote=0         if        prtvtbfr==15
replace   party_vote=0         if        prtvtbfr==16
replace   party_vote=.         if        prtvtbfr==17
replace   party_vote=.         if        prtvtbfr==18
* Great Britain
replace   party_vote=6         if        prtvtgb== 1
replace   party_vote=3         if        prtvtgb== 2
replace   party_vote=4         if        prtvtgb== 3
replace   party_vote=0         if        prtvtgb== 4
replace   party_vote=0         if        prtvtgb== 5
replace   party_vote=.         if        prtvtgb== 6
replace   party_vote=0         if        prtvtgb== 7
replace   party_vote=6         if        prtvtgb== 11
replace   party_vote=0         if        prtvtgb== 12
replace   party_vote=2         if        prtvtgb== 13
replace   party_vote=3         if        prtvtgb== 14
replace   party_vote=0         if        prtvtgb== 15
* Greece
replace   party_vote=3         if        prtvtbgr==1
replace   party_vote=6         if        prtvtbgr==2
replace   party_vote=2         if        prtvtbgr==3
replace   party_vote=2         if        prtvtbgr==4
replace   party_vote=7         if        prtvtbgr==5
replace   party_vote=.         if        prtvtbgr==6
replace   party_vote=0         if        prtvtbgr==7

* Ireland
replace   party_vote=6         if        prtvtie== 1
replace   party_vote=5         if        prtvtie== 2
replace   party_vote=3         if        prtvtie== 3
replace   party_vote=4         if        prtvtie== 4
replace   party_vote=1         if        prtvtie== 5
replace   party_vote=2         if        prtvtie== 6
replace   party_vote=.         if        prtvtie== 7
replace   party_vote=0         if        prtvtie== 8

* Iceland: no observations
* Italy: no observations
* Luxembourg:  no observations
* Netherlands
replace   party_vote=5         if        prtvtcnl==1
replace   party_vote=3         if        prtvtcnl==2
replace   party_vote=4         if        prtvtcnl==3
replace   party_vote=7         if        prtvtcnl==4
replace   party_vote=4         if        prtvtcnl==5
replace   party_vote=1         if        prtvtcnl==6
replace   party_vote=2         if        prtvtcnl==7
replace   party_vote=5         if        prtvtcnl==8
replace   party_vote=4         if        prtvtcnl==9
replace   party_vote=4         if        prtvtcnl==10
replace   party_vote=7         if        prtvtcnl==11
replace   party_vote=.         if        prtvtcnl==12
replace   party_vote=0         if        prtvtcnl==13
replace   party_vote=.         if        prtvtcnl==14
* Norway
replace   party_vote=.         if        prtvtno== 1
replace   party_vote=2         if        prtvtno== 2
replace   party_vote=3         if        prtvtno== 3
replace   party_vote=4         if        prtvtno== 4
replace   party_vote=5         if        prtvtno== 5
replace   party_vote=5         if        prtvtno== 6
replace   party_vote=6         if        prtvtno== 7
replace   party_vote=7         if        prtvtno== 8
replace   party_vote=.         if        prtvtno== 9
replace   party_vote=0         if        prtvtno== 10
* Portugal
replace   party_vote=2         if        prtvtapt==1
replace   party_vote=5         if        prtvtapt==2
replace   party_vote=2         if        prtvtapt==3
replace   party_vote=.         if        prtvtapt==4
replace   party_vote=.         if        prtvtapt==6
replace   party_vote=.         if        prtvtapt==7
replace   party_vote=7         if        prtvtapt==8
replace   party_vote=5         if        prtvtapt==10
replace   party_vote=3         if        prtvtapt==11
replace   party_vote=.         if        prtvtapt==12
* Sweden
replace   party_vote=5         if        prtvtse== 1
replace   party_vote=4         if        prtvtse== 2
replace   party_vote=5         if        prtvtse== 3
replace   party_vote=1         if        prtvtse== 4
replace   party_vote=6         if        prtvtse== 5
replace   party_vote=3         if        prtvtse== 6
replace   party_vote=2         if        prtvtse== 7
replace   party_vote=0         if        prtvtse== 8

* Definition of value labels
label def party_vote 0 "Other" 1 "Green" 2 "Communist" 3 "Social democratic" ///
	4 "Liberal"	5 "Christian democratic" 6 "Conservative" 7 "Right-Wing"
label val party_vote party_vote


*** Party closeness (not classified parties are missings)
* Creation of variable
gen party_close=.
label var party_close "Party closeness"
* Austria: no observations
* Belgium
replace   party_close=1         if        prtclbbe==1
replace   party_close=5         if        prtclbbe==2
replace   party_close=5         if        prtclbbe==4
replace   party_close=3         if        prtclbbe==5
replace   party_close=7         if        prtclbbe==7
replace   party_close=4         if        prtclbbe==8
replace   party_close=5         if        prtclbbe==9
replace   party_close=1         if        prtclbbe==10
replace   party_close=7         if        prtclbbe==11
replace   party_close=4         if        prtclbbe==12
replace   party_close=3         if        prtclbbe==13
replace   party_close=0         if        prtclbbe==14
replace   party_close=.         if        prtclbbe==15
replace   party_close=.         if        prtclbbe==16
* Switzerland
replace   party_close=4         if        prtclbch==1
replace   party_close=5         if        prtclbch==2
replace   party_close=3         if        prtclbch==3
replace   party_close=7         if        prtclbch==4
replace   party_close=4         if        prtclbch==5
replace   party_close=.         if        prtclbch==6
replace   party_close=2         if        prtclbch==7
replace   party_close=1         if        prtclbch==8
replace   party_close=.         if        prtclbch==9
replace   party_close=7         if        prtclbch==10
replace   party_close=7         if        prtclbch==11
replace   party_close=5         if        prtclbch==12
replace   party_close=.         if        prtclbch==13
replace   party_close=.         if        prtclbch==15
replace   party_close=.         if        prtclbch==16

* Germany
replace   party_close=3         if        prtclbde==1
replace   party_close=5         if        prtclbde==2
replace   party_close=1         if        prtclbde==3
replace   party_close=4         if        prtclbde==4
replace   party_close=2         if        prtclbde==5
replace   party_close=7         if        prtclbde==6
replace   party_close=7         if        prtclbde==7
replace   party_close=0         if        prtclbde==8
* Denmark
replace   party_close=3         if        prtclbdk==1
replace   party_close=1         if        prtclbdk==2
replace   party_close=6         if        prtclbdk==3
replace   party_close=1         if        prtclbdk==4
replace   party_close=7         if        prtclbdk==5
replace   party_close=5         if        prtclbdk==6
replace   party_close=4         if        prtclbdk==7
replace   party_close=0         if        prtclbdk==8
replace   party_close=2         if        prtclbdk==9
replace   party_close=0         if        prtclbdk==10

* Spain
replace   party_close=6         if        prtclbes==1
replace   party_close=3         if        prtclbes==2
replace   party_close=2         if        prtclbes==3
replace   party_close=6         if        prtclbes==4
replace   party_close=0         if        prtclbes==5
replace   party_close=0         if        prtclbes==6
replace   party_close=0         if        prtclbes==7
replace   party_close=0         if        prtclbes==8
replace   party_close=.         if        prtclbes==9
replace   party_close=.         if        prtclbes==10
replace   party_close=0         if        prtclbes==74
replace   party_close=.         if        prtclbes==75
replace   party_close=.         if        prtclbes==76
* Finland
replace   party_close=6         if        prtclafi==1
replace   party_close=0         if        prtclafi==2
replace   party_close=4         if        prtclafi==3
replace   party_close=5         if        prtclafi==4
replace   party_close=7         if        prtclafi==5
replace   party_close=5         if        prtclafi==6
replace   party_close=1         if        prtclafi==7
replace   party_close=3         if        prtclafi==8
replace   party_close=2         if        prtclafi==9
replace   party_close=.         if        prtclafi==10
replace   party_close=.         if        prtclafi==11
replace   party_close=0         if        prtclafi==12
* France
replace   party_close=.         if        prtclbfr==1
replace   party_close=7         if        prtclbfr==2
replace   party_close=2         if        prtclbfr==3
replace   party_close=2         if        prtclbfr==4
replace   party_close=.         if        prtclbfr==5
replace   party_close=4         if        prtclbfr==6
replace   party_close=2         if        prtclbfr==7
replace   party_close=3         if        prtclbfr==8
replace   party_close=.         if        prtclbfr==9
replace   party_close=4         if        prtclbfr==10
replace   party_close=6         if        prtclbfr==11
replace   party_close=1         if        prtclbfr==12
replace   party_close=.         if        prtclbfr==13
replace   party_close=0         if        prtclbfr==14
replace   party_close=0         if        prtclbfr==15
replace   party_close=0         if        prtclbfr==16
replace   party_close=.         if        prtclbfr==17
replace   party_close=.         if        prtclbfr==18
* Great Britain
replace   party_close=6         if        prtclgb== 1
replace   party_close=3         if        prtclgb== 2
replace   party_close=4         if        prtclgb== 3
replace   party_close=0         if        prtclgb== 4
replace   party_close=0         if        prtclgb== 5
replace   party_close=.         if        prtclgb== 6
replace   party_close=0         if        prtclgb== 7
replace   party_close=6         if        prtclgb== 11
replace   party_close=0         if        prtclgb== 12
replace   party_close=2         if        prtclgb== 13
replace   party_close=3         if        prtclgb== 14
replace   party_close=0         if        prtclgb== 15
* Greece
replace   party_close=3         if        prtclbgr==1
replace   party_close=6         if        prtclbgr==2
replace   party_close=2         if        prtclbgr==3
replace   party_close=2         if        prtclbgr==4
replace   party_close=7         if        prtclbgr==5
replace   party_close=.         if        prtclbgr==6
replace   party_close=0         if        prtclbgr==7

* Ireland
replace   party_close=6         if        prtclbie== 1
replace   party_close=5         if        prtclbie== 2
replace   party_close=3         if        prtclbie== 3
replace   party_close=4         if        prtclbie== 4
replace   party_close=1         if        prtclbie== 5
replace   party_close=2         if        prtclbie== 6
replace   party_close=.         if        prtclbie== 7
replace   party_close=0         if        prtclbie== 8

* Iceland: no observations
* Italy: no observations
* Luxembourg:  no observations
* Netherlands
replace   party_close=5         if        prtclbnl==1
replace   party_close=3         if        prtclbnl==2
replace   party_close=4         if        prtclbnl==3
replace   party_close=7         if        prtclbnl==4
replace   party_close=4         if        prtclbnl==5
replace   party_close=1         if        prtclbnl==6
replace   party_close=2         if        prtclbnl==7
replace   party_close=5         if        prtclbnl==8
replace   party_close=4         if        prtclbnl==9
replace   party_close=4         if        prtclbnl==10
replace   party_close=7         if        prtclbnl==11
replace   party_close=.         if        prtclbnl==12
replace   party_close=0         if        prtclbnl==13
replace   party_close=.         if        prtclbnl==14
* Norway
replace   party_close=.         if        prtclno== 1
replace   party_close=2         if        prtclno== 2
replace   party_close=3         if        prtclno== 3
replace   party_close=4         if        prtclno== 4
replace   party_close=5         if        prtclno== 5
replace   party_close=5         if        prtclno== 6
replace   party_close=6         if        prtclno== 7
replace   party_close=7         if        prtclno== 8
replace   party_close=.         if        prtclno== 9
replace   party_close=0         if        prtclno== 10
* Portugal
replace   party_close=2         if        prtclbpt==1
replace   party_close=5         if        prtclbpt==2
replace   party_close=2         if        prtclbpt==3
replace   party_close=.         if        prtclbpt==4
replace   party_close=.         if        prtclbpt==6
replace   party_close=.         if        prtclbpt==7
replace   party_close=7         if        prtclbpt==8
replace   party_close=5         if        prtclbpt==10
replace   party_close=3         if        prtclbpt==11
replace   party_close=.         if        prtclbpt==12
* Sweden
replace   party_close=5         if        prtclse== 1
replace   party_close=4         if        prtclse== 2
replace   party_close=5         if        prtclse== 3
replace   party_close=1         if        prtclse== 4
replace   party_close=6         if        prtclse== 5
replace   party_close=3         if        prtclse== 6
replace   party_close=2         if        prtclse== 7
replace   party_close=0         if        prtclse== 8

* Definition of value labels
label def party_close 0 "Other" 1 "Green" 2 "Communist" 3 "Social democratic" ///
	4 "Liberal"	5 "Christian democratic" 6 "Conservative" 7 "Right-Wing"
label val party_close party_close


*** Voter participation
* Creation of variable 
gen voted=vote==1
replace voted=. if vote>2
lab var voted "Voter participation"
* Definition of value label
lab define voted 1 "Voter" 0 "Non-voter"
lab values voted voted


save "ESSrecoded4.dta", replace

*----------------------------------------------------------------------------------------*
*	5. prepare/recode ESS5
*----------------------------------------------------------------------------------------*


*----------------------------------------------------------------------------------------*
*	1. Operationalization of variables, round 5 - 2010
*----------------------------------------------------------------------------------------*
* Basic commands
clear all
set mem 1g
set more off
capture log close


* Import dataset (from ESS website)
use ESS5e03_2.dta



*	1.0 country selection: 
* AT, BE, CH, GE, DK, SP, FIN, FR, UK, GR, IE, IT, NL, NO, PT, SE
 
drop if cntry=="CZ"
drop if cntry=="HU"
drop if cntry=="LU"
drop if cntry=="PL"
drop if cntry=="SI"
drop if cntry=="IL"
drop if cntry=="EE"
drop if cntry=="IS"
drop if cntry=="SK"
drop if cntry=="TR"
drop if cntry=="UA"
drop if cntry=="RU"
drop if cntry=="BG"
drop if cntry=="CY"
drop if cntry=="LV"
drop if cntry=="RO"
drop if cntry=="HR"
drop if cntry=="LT"


gen at=cntry=="AT"
lab var at "Country dummy Austria"
gen be=cntry=="BE"
lab var be "Country dummy Belgium"
gen ch=cntry=="CH"
lab var ch "Country dummy Switzerland"
gen de=cntry=="DE"
lab var de "Country dummy Germany"
gen dk=cntry=="DK"
lab var dk "Country dummy Denmark"
gen es=cntry=="ES"
lab var es "Country dummy Spain"
gen fi=cntry=="FI"
lab var fi "Country dummy Finland"
gen fr=cntry=="FR"
lab var fr "Country dummy France"
gen gb=cntry=="GB"
lab var gb "Country dummy United Kingdom"
gen gr=cntry=="GR"
lab var gr "Country dummy Greece"
gen ie=cntry=="IE"
lab var ie "Country dummy Ireland"
gen it=cntry=="IT"
lab var it "Country dummy Italy"
gen nl=cntry=="NL"
lab var nl "Country dummy Netherlands"
gen no=cntry=="NO"
lab var no "Country dummy Norway"
gen pt=cntry=="PT"
lab var pt "Country dummy Portugal"
gen se=cntry=="SE"
lab var se "Country dummy Sweden"


*******************************
*   1.1 GLOBALIZATION LOSERS
*******************************

** from Rommel /Walter: combination of offshoreable and low-skill (educlvl und offshore2)

* Creation of variable
gen educyrs=eduyrs
lab var educyrs "Years of Education"
* Recoding of variable
replace educyrs=25 if eduyrs>25 & eduyrs<.


***** 2.2 Education level
*----------------------------------------------------------------------------------------*

* Creation of variable
gen educlvl=edulvlb
lab var educlvl "Education level"
* Recoding of variable and definition of value label
recode educlvl (0=1) (113=1) (129=1) (212=2) (213=2) (221=2) (222=2) (229=2) (311=3) ///
	(312=3) (313=3) (321=3) (322=3) (323=3) (412=4) (413=4) (421=4) (422=4) (423=4) ///
	(510=5) (520=5) (610=5) (620=5) (710=5) (720=5) (800=5) (5555=.)
label define educlvl 1 "Less than lower secondary education" ///
	2 "Lower secondary education completed" ///
	3 "Upper secondary education completed" ///
	4 "Post-secondary, non-tertiary education completed" ///
	5 "Tertiary education completed"
label values educlvl educlvl


*** Creation of 4-digit ISCO-Code
gen isco=iscoco
lab var isco "4-digit ISCO-code"

*** Metric offshoreability variable	
* Creation of variable
gen offshore=.
replace offshore=0 if isco<.
replace offshore=49 if isco==1142
replace offshore=55 if isco==1222
replace offshore=28 if isco==1226
replace offshore=55 if isco==1228
replace offshore=83 if isco==1231
replace offshore=49 if isco==1232
replace offshore=40 if isco==1233
replace offshore=53 if isco==1234
replace offshore=49 if isco==1235
replace offshore=55 if isco==1236
replace offshore=55 if isco==1237
replace offshore=55 if isco==1311
replace offshore=55 if isco==1312
replace offshore=55 if isco==1313
replace offshore=55 if isco==1314
replace offshore=55 if isco==1315
replace offshore=48 if isco==1316
replace offshore=52 if isco==1317
replace offshore=55 if isco==1318
replace offshore=55 if isco==1319
replace offshore=66 if isco==2111
replace offshore=74 if isco==2112
replace offshore=66 if isco==2113
replace offshore=66 if isco==2114
replace offshore=89 if isco==2121
replace offshore=96 if isco==2122
replace offshore=83 if isco==2131
replace offshore=90 if isco==2139
replace offshore=25 if isco==2141
replace offshore=64 if isco==2143
replace offshore=74 if isco==2144
replace offshore=72 if isco==2146
replace offshore=69 if isco==2147
replace offshore=86 if isco==2148
replace offshore=71 if isco==2149
replace offshore=81 if isco==2211
replace offshore=83 if isco==2212
replace offshore=72 if isco==2411
replace offshore=50 if isco==2419
replace offshore=74 if isco==2421
replace offshore=67 if isco==2444
replace offshore=90 if isco==2451
replace offshore=78 if isco==2452
replace offshore=25 if isco==2453
replace offshore=48 if isco==2455
replace offshore=47 if isco==3111
replace offshore=47 if isco==3113
replace offshore=47 if isco==3114
replace offshore=72 if isco==3115
replace offshore=47 if isco==3116
replace offshore=94 if isco==3118
replace offshore=54 if isco==3119
replace offshore=75 if isco==3121
replace offshore=84 if isco==3122
replace offshore=68 if isco==3123
replace offshore=36 if isco==3131
replace offshore=36 if isco==3132
replace offshore=46 if isco==3133
replace offshore=34 if isco==3139
replace offshore=52 if isco==3141
replace offshore=60 if isco==3152
replace offshore=55 if isco==3211
replace offshore=55 if isco==3212
replace offshore=44 if isco==3213
replace offshore=32 if isco==3228
replace offshore=51 if isco==3411
replace offshore=85 if isco==3412
replace offshore=50 if isco==3414
replace offshore=55 if isco==3416
replace offshore=59 if isco==3419
replace offshore=51 if isco==3421
replace offshore=48 if isco==3422
replace offshore=38 if isco==3431
replace offshore=51 if isco==3432
replace offshore=84 if isco==3433
replace offshore=84 if isco==3434
replace offshore=54 if isco==3439
replace offshore=100 if isco==3442
replace offshore=85 if isco==3471
replace offshore=30 if isco==3472
replace offshore=95 if isco==4111
replace offshore=94 if isco==4112
replace offshore=100 if isco==4113
replace offshore=71 if isco==4114
replace offshore=38 if isco==4115
replace offshore=84 if isco==4121
replace offshore=54 if isco==4122
replace offshore=31 if isco==4131
replace offshore=67 if isco==4132
replace offshore=67 if isco==4133
replace offshore=46 if isco==4141
replace offshore=26 if isco==4142
replace offshore=95 if isco==4143
replace offshore=54 if isco==4144
replace offshore=54 if isco==4190
replace offshore=94 if isco==4211
replace offshore=54 if isco==4214
replace offshore=65 if isco==4215
replace offshore=72 if isco==4221
replace offshore=54 if isco==4222
replace offshore=50 if isco==4223
replace offshore=86 if isco==5113
replace offshore=59 if isco==6142
replace offshore=36 if isco==7111
replace offshore=35 if isco==7112
replace offshore=36 if isco==7113
replace offshore=65 if isco==7211
replace offshore=69 if isco==7212
replace offshore=70 if isco==7213
replace offshore=70 if isco==7222
replace offshore=68 if isco==7223
replace offshore=68 if isco==7224
replace offshore=26 if isco==7311
replace offshore=64 if isco==7313
replace offshore=69 if isco==7321
replace offshore=69 if isco==7322
replace offshore=68 if isco==7323
replace offshore=68 if isco==7324
replace offshore=60 if isco==7331
replace offshore=75 if isco==7332
replace offshore=59 if isco==7341
replace offshore=59 if isco==7342
replace offshore=59 if isco==7343
replace offshore=34 if isco==7344
replace offshore=59 if isco==7345
replace offshore=75 if isco==7346
replace offshore=68 if isco==7413
replace offshore=27 if isco==7414
replace offshore=55 if isco==7415
replace offshore=43 if isco==7421
replace offshore=57 if isco==7422
replace offshore=57 if isco==7423
replace offshore=66 if isco==7424
replace offshore=75 if isco==7431
replace offshore=75 if isco==7432
replace offshore=75 if isco==7433
replace offshore=73 if isco==7434
replace offshore=75 if isco==7435
replace offshore=75 if isco==7436
replace offshore=57 if isco==7437
replace offshore=75 if isco==7441
replace offshore=72 if isco==7442
replace offshore=36 if isco==8111
replace offshore=36 if isco==8112
replace offshore=36 if isco==8113
replace offshore=59 if isco==8121
replace offshore=68 if isco==8122
replace offshore=70 if isco==8123
replace offshore=68 if isco==8124
replace offshore=69 if isco==8131
replace offshore=68 if isco==8139
replace offshore=57 if isco==8141
replace offshore=68 if isco==8142
replace offshore=68 if isco==8143
replace offshore=68 if isco==8151
replace offshore=70 if isco==8152
replace offshore=68 if isco==8153
replace offshore=68 if isco==8154
replace offshore=29 if isco==8155
replace offshore=68 if isco==8159
replace offshore=42 if isco==8161
replace offshore=55 if isco==8162
replace offshore=29 if isco==8163
replace offshore=64 if isco==8171
replace offshore=68 if isco==8172
replace offshore=68 if isco==8211
replace offshore=68 if isco==8212
replace offshore=68 if isco==8221
replace offshore=35 if isco==8222
replace offshore=68 if isco==8223
replace offshore=41 if isco==8224
replace offshore=29 if isco==8229
replace offshore=69 if isco==8231
replace offshore=68 if isco==8232
replace offshore=57 if isco==8240
replace offshore=58 if isco==8251
replace offshore=59 if isco==8252
replace offshore=68 if isco==8253
replace offshore=75 if isco==8261
replace offshore=75 if isco==8262
replace offshore=75 if isco==8263
replace offshore=75 if isco==8264
replace offshore=75 if isco==8265
replace offshore=75 if isco==8266
replace offshore=75 if isco==8269
replace offshore=27 if isco==8271
replace offshore=68 if isco==8272
replace offshore=68 if isco==8273
replace offshore=30 if isco==8274
replace offshore=31 if isco==8275
replace offshore=68 if isco==8276
replace offshore=27 if isco==8277
replace offshore=68 if isco==8278
replace offshore=66 if isco==8281
replace offshore=66 if isco==8282
replace offshore=66 if isco==8283
replace offshore=68 if isco==8284
replace offshore=57 if isco==8285
replace offshore=64 if isco==8286
replace offshore=68 if isco==8290
replace offshore=34 if isco==8340
replace offshore=95 if isco==9113
replace offshore=64 if isco==9321
replace offshore=29 if isco==9333
replace offshore=55 if isco==1227
replace offshore=89 if isco==2121
replace offshore=100 if isco==2132
replace offshore=70 if isco==2145
replace offshore=71 if isco==2149
replace offshore=81 if isco==2211
replace offshore=46 if isco==2412
replace offshore=50 if isco==2419
replace offshore=33 if isco==2432
replace offshore=89 if isco==2441
replace offshore=48 if isco==2455
replace offshore=72 if isco==3115
replace offshore=54 if isco==3119
replace offshore=46 if isco==3133
replace offshore=34 if isco==3139
replace offshore=34 if isco==3224
replace offshore=51 if isco==3411
replace offshore=25 if isco==3415
replace offshore=50 if isco==3417
replace offshore=59 if isco==3419
replace offshore=51 if isco==3432
replace offshore=54 if isco==3439
replace offshore=90 if isco==3460
replace offshore=54 if isco==4122
replace offshore=31 if isco==4131
replace offshore=67 if isco==4132
replace offshore=46 if isco==4141
replace offshore=26 if isco==4142
replace offshore=54 if isco==4222
replace offshore=68 if isco==7141
replace offshore=68 if isco==7224
replace offshore=65 if isco==7241
replace offshore=34 if isco==7344
replace offshore=72 if isco==7442
replace offshore=68 if isco==8122
replace offshore=68 if isco==8139
replace offshore=42 if isco==8161
replace offshore=68 if isco==8211
replace offshore=68 if isco==8223
replace offshore=41 if isco==8224
replace offshore=57 if isco==8240
replace offshore=58 if isco==8251
replace offshore=75 if isco==8269
replace offshore=66 if isco==8281
replace offshore=66 if isco==8283
replace offshore=68 if isco==8284
replace offshore=68 if isco==8290
replace offshore=70 if isco==9322
lab var offshore "Offshoring Potential (Blinder 2007), metric"

*** Creation of ordinal (4-point scale) offshoreability variable
* Creation of variable
gen offshore4=.
replace offshore4=4 if offshore<.
replace offshore4=3 if offshore<75
replace offshore4=2 if offshore<50
replace offshore4=1 if offshore<25
lab var offshore4 "Offshoring Potential (Blinder 2007), ordinal"
* Definition of value label
lab define offshore4 1 "0-24%" 2 "5-49%" 3 "50-74%" 4 "75-100%"
lab values offshore4 offshore4

*** Creation of dichotomous offshoreability variable
* Creation of variable
gen offshore2=.
replace offshore2=1 if offshore>0 & offshore<.
replace offshore2=0 if offshore==0
lab var offshore2 "Offshoring Potential (Blinder 2007), dichotomous"
* Definition of value label
lab define offshore2 0 "Not offshoreable" 1 "Offshoreable"
lab values offshore2 offshore2


***********************

*** Creation of globalization loser variable 1 : low-skilled offshoreable
* Creation of variable
gen glob_losers1=.
replace glob_losers1=1 if offshore2==1 & educlvl<3
replace glob_losers1=0 if offshore2==0 & educlvl<3
replace glob_losers1=0 if offshore2==1 & educlvl>2
replace glob_losers1=0 if offshore2==0 & educlvl>2
lab var glob_losers1 "Globalization losers; lowskilled exposed "
* Definition of value label
lab define glob_losers1 1 "glob loser (l-s off)" 0 "not loser"
lab values glob_losers1 glob_losers1



*** Creation of winner variable 1: low-skilled sheltered
* Creation of variable
gen glob_winners1=.
replace glob_winners1 =0 if offshore2==1 & educlvl<3
replace glob_winners1 =1 if offshore2==0 & educlvl<3
replace glob_winners1 =0 if offshore2==1 & educlvl>2
replace glob_winners1 =0 if offshore2==0 & educlvl>2
lab var glob_winners1 "Globalization winners; lowskilled sheltered "
* Definition of value label
lab define glob_winners1 1 "glob winners (l-s sheltered)" 0 "not winner"
lab values glob_winners1 glob_losers1



************************************
*	1.2 MODERNIZATION LOSERS

* Oesch 16-classes for respondents only (according to syntax on his website)

****************************************************************************************
* Respondent's Oesch class position
* Recode and create variables used to construct class variable for respondents
* Variables used to construct class variable for respondents: iscoco, emplrel, emplno
****************************************************************************************

**** Recode occupation variable (isco88 com 4-digit) for respondents

tab iscoco

recode iscoco (missing=-9), copyrest gen(isco_mainjob)
label variable isco_mainjob "Current occupation of respondent - isco88 4-digit"
tab isco_mainjob

**** Recode employment status for respondents

tab emplrel

recode emplrel (missing=9), copyrest gen(emplrel_r)
replace emplrel_r=-9 if cntry=="FR" & (essround==1 | essround==2) // Replace this command line with [SYNTAX G and SYNTAX I]
replace emplrel_r=-9 if cntry=="HU" & essround==2 // Replace this command line with [SYNTAX E]
label define emplrel_r ///
1 "Employee" ///
2 "Self-employed" ///
3 "Working for own family business" ///
9 "Missing"
label value emplrel_r emplrel_r
tab emplrel_r

tab emplno

recode emplno (0=0)(1/9=1)(10/10000=2)(missing=0), gen(emplno_r)
label define emplno_r ///
0 "0 employees" ///
1 "1-9 employees" ///
2 "10+ employees"
label value emplno_r emplno_r
tab emplno_r


gen selfem_mainjob=.
replace selfem_mainjob=1 if emplrel_r==1 | emplrel_r==9
replace selfem_mainjob=2 if emplrel_r==2 & emplno_r==0
replace selfem_mainjob=2 if emplrel_r==3
replace selfem_mainjob=3 if emplrel_r==2 & emplno_r==1
replace selfem_mainjob=4 if emplrel_r==2 & emplno_r==2
label variable selfem_mainjob "Employment status for respondants"
label define selfem_mainjob ///
1 "Not self-employed" ///
2 "Self-empl without employees" ///
3 "Self-empl with 1-9 employees" ///
4 "Self-empl with 10 or more"
label value selfem_mainjob selfem_mainjob
tab selfem_mainjob


*************************************************
* Create Oesch class schema for respondents
*************************************************

gen class16_r = -9

* Large employers (1)

replace class16_r=1 if selfem_mainjob==4


* Self-employed professionals (2)

replace class16_r=2 if (selfem_mainjob==2 | selfem_mainjob==3) & (isco_mainjob >= 2000 & isco_mainjob <= 2229) 
replace class16_r=2 if (selfem_mainjob==2 | selfem_mainjob==3) & (isco_mainjob >= 2300 & isco_mainjob <= 2470)

* Small business owners with employees (3)

replace class16_r=3 if (selfem_mainjob==3) & (isco_mainjob >= 1000 & isco_mainjob <= 1999)
replace class16_r=3 if (selfem_mainjob==3) & (isco_mainjob >= 3000 & isco_mainjob <= 9333)
replace class16_r=3 if (selfem_mainjob==3) & (isco_mainjob == 2230)

* Small business owners without employees (4)

replace class16_r=4 if (selfem_mainjob==2) & (isco_mainjob >= 1000 & isco_mainjob <= 1999)
replace class16_r=4 if (selfem_mainjob==2) & (isco_mainjob >= 3000 & isco_mainjob <= 9333)
replace class16_r=4 if (selfem_mainjob==2) & (isco_mainjob == 2230)

* Technical experts (5)

replace class16_r=5 if (selfem_mainjob==1) & (isco_mainjob >= 2100 & isco_mainjob <= 2213)

* Technicians (6)

replace class16_r=6 if (selfem_mainjob==1) & (isco_mainjob >= 3100 & isco_mainjob <= 3152)
replace class16_r=6 if (selfem_mainjob==1) & (isco_mainjob >= 3210 & isco_mainjob <= 3213)
replace class16_r=6 if (selfem_mainjob==1) & (isco_mainjob == 3434)

* Skilled manual (7)

replace class16_r=7 if (selfem_mainjob==1) & (isco_mainjob >= 6000 & isco_mainjob <= 7442)
replace class16_r=7 if (selfem_mainjob==1) & (isco_mainjob >= 8310 & isco_mainjob <= 8312)
replace class16_r=7 if (selfem_mainjob==1) & (isco_mainjob >= 8324 & isco_mainjob <= 8330)
replace class16_r=7 if (selfem_mainjob==1) & (isco_mainjob >= 8332 & isco_mainjob <= 8340)

* Low-skilled manual (8)

replace class16_r=8 if (selfem_mainjob==1) & (isco_mainjob >= 8000 & isco_mainjob <= 8300)
replace class16_r=8 if (selfem_mainjob==1) & (isco_mainjob >= 8320 & isco_mainjob <= 8321)
replace class16_r=8 if (selfem_mainjob==1) & (isco_mainjob == 8331)
replace class16_r=8 if (selfem_mainjob==1) & (isco_mainjob >= 9153 & isco_mainjob <= 9333)

* Higher-grade managers and administrators (9)

replace class16_r=9 if (selfem_mainjob==1) & (isco_mainjob >= 1000 & isco_mainjob <= 1239)
replace class16_r=9 if (selfem_mainjob==1) & (isco_mainjob >= 2400 & isco_mainjob <= 2429)
replace class16_r=9 if (selfem_mainjob==1) & (isco_mainjob == 2441)
replace class16_r=9 if (selfem_mainjob==1) & (isco_mainjob == 2470)

* Lower-grade managers and administrators (10)

replace class16_r=10 if (selfem_mainjob==1) & (isco_mainjob >= 1300 & isco_mainjob <= 1319)
replace class16_r=10 if (selfem_mainjob==1) & (isco_mainjob >= 3400 & isco_mainjob <= 3433)
replace class16_r=10 if (selfem_mainjob==1) & (isco_mainjob >= 3440 & isco_mainjob <= 3450)

* Skilled clerks (11)

replace class16_r=11 if (selfem_mainjob==1) & (isco_mainjob >= 4000 & isco_mainjob <= 4112)
replace class16_r=11 if (selfem_mainjob==1) & (isco_mainjob >= 4114 & isco_mainjob <= 4210)
replace class16_r=11 if (selfem_mainjob==1) & (isco_mainjob >= 4212 & isco_mainjob <= 4222)

* Unskilled clerks (12)

replace class16_r=12 if (selfem_mainjob==1) & (isco_mainjob == 4113)
replace class16_r=12 if (selfem_mainjob==1) & (isco_mainjob == 4211)
replace class16_r=12 if (selfem_mainjob==1) & (isco_mainjob == 4223)

* Socio-cultural professionals (13)

replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob >= 2220 &  isco_mainjob <= 2229)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob >= 2300 &  isco_mainjob <= 2320)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob >= 2340 &  isco_mainjob <= 2359)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob >= 2430 &  isco_mainjob <= 2440)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob >= 2442 &  isco_mainjob <= 2443)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob == 2445)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob == 2451)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob == 2460)

* Socio-cultural semi-professionals (14)

replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob == 2230)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob >= 2330 & isco_mainjob <= 2332)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob == 2444)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob >= 2446 & isco_mainjob <= 2450)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob >= 2452 & isco_mainjob <= 2455)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob == 3200)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob >= 3220 & isco_mainjob <= 3224)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob == 3226)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob >= 3229 & isco_mainjob <= 3340)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob >= 3460 & isco_mainjob <= 3472)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob == 3480)

* Skilled service (15)

replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob == 3225)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob >= 3227 & isco_mainjob <= 3228)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob >= 3473 & isco_mainjob <= 3475)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob >= 5000 & isco_mainjob <= 5113)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob == 5122)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob >= 5131 & isco_mainjob <= 5132)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob >= 5140 & isco_mainjob <= 5141)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob == 5143)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob >= 5160 & isco_mainjob <= 5220)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob == 8323)

* Low-skilled service (16)

replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob >= 5120 & isco_mainjob <= 5121)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob >= 5123 & isco_mainjob <= 5130)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob >= 5133 & isco_mainjob <= 5139)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob == 5142)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob == 5149)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob == 5230)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob == 8322)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob >= 9100 &  isco_mainjob <= 9152)

mvdecode class16_r, mv(-9)
label variable class16_r "Respondent's Oesch class position - 16 classes"
label define class16_r ///
1 "Large employers" ///
2 "Self-employed professionals" ///
3 "Small business owners with employees" ///
4 "Small business owners without employees" ///
5 "Technical experts" ///
6 "Technicians" ///
7 "Skilled manual" ///
8 "Low-skilled manual" ///
9 "Higher-grade managers and administrators" ///
10 "Lower-grade managers and administrators" ///
11 "Skilled clerks" ///
12 "Unskilled clerks" ///
13 "Socio-cultural professionals" ///
14 "Socio-cultural semi-professionals" ///
15 "Skilled service" ///
16 "Low-skilled service"
label value class16_r class16_r
tab class16_r

recode class16_r (1 2=1)(3 4=2)(5 6=3)(7 8=4)(9 10=5)(11 12=6)(13 14=7)(15 16=8), gen(class8_r)
label variable class8_r "Respondent's Oesch class position - 8 classes"
label define class8_r ///
1 "Self-employed professionals and large employers" ///
2 "Small business owners" ///
3 "Technical (semi-)professionals" ///
4 "Production workers" ///
5 "(Associate) managers" ///
6 "Clerks" ///
7 "Socio-cultural (semi-)professionals" ///
8 "Service workers"
label value class8_r class8_r
tab class8_r


*** Aggregated sector variable
* Creation of variable
gen sector=.
replace sector=1 if nace==1 | nace==2 | nace==5
replace sector=2 if nace==10 | nace==11 | nace==12 | nace==13 | nace==14
replace sector=3 if nace==15 | nace==16 | nace==17 | nace==18 | nace==19 | nace==20 ///
	 | nace==21 | nace==22 | nace==23 | nace==24 | nace==25 | nace==26 | nace==27 ///
	 | nace==28 | nace==29 | nace==30 | nace==31 | nace==32 | nace==33 | nace==34 ///
	 | nace==35 | nace==36 | nace==37
replace sector=4 if nace==40 | nace==41
replace sector=5 if nace==45
replace sector=6 if nace==50 | nace==51 | nace==52 | nace==55
replace sector=7 if nace==60 | nace==61 | nace==62 | nace==63 | nace==64
replace sector=8 if nace==65 | nace==66 | nace==67 | nace==70 | nace==71 | nace==72 ///
	 | nace==73 | nace==74
replace sector=9 if nace==75 | nace==80 | nace==85 | nace==90 | nace==91 | nace==92 ///
	 | nace==93 | nace==95 | nace==99
lab var sector "Aggregated sector variable"
* Definition of value label
lab define sector 1 "Agriculture, hunting, forestry and fishing" ///
	2 "Mining and quarrying" ///
	3 "Manufacturing" ///
	4 "Electricity, gas and water" ///
	5 "Construction" ///
	6 "Wholesale and retail trade and restaurants and hotels" ///
	7 "Transport, storage and communications" ///
	8 "Financing, insurance, real estate and busines services" ///
	9 "Community, social and personal services"
lab values sector sector


*** Gender
*** Gender
* Creation of variable
gen gender=gndr
lab var gender "Gender"
* Recoding of variable and definition of value label
recode gender (1=0) (2=1)
lab define gender 0 "male" 1 "female"
lab values gender gender


*** Creation of modernization loser variable 1 : routine service (class 16)
* Creation of variable
gen mod_losers1=.
replace mod_losers1 =1 if class16_r==16
replace mod_losers1 =0 if class16_r!=16
replace mod_losers1=. if class16_r==.

lab var mod_losers1 "Modernization losers 1; routine service oesch "
* Definition of value label
lab define mod_losers1 1 "mod loser (routine service)" 0 "not loser"
lab values mod_losers1 mod_losers1



*** Creation of modernization loser variable 4 : routine and skilled manual (classes 7,8)
* Creation of variable
gen mod_losers4=0
replace mod_losers4 =1 if class16_r==7
replace mod_losers4 =1 if class16_r==8
replace mod_losers4 =. if class16_r==.

lab var mod_losers4 "Modernization losers 4; routine and skilled manual oesch "
* Definition of value label
lab define mod_losers4 1 "mod loser (routine and skilled manual)" 0 "not loser"
lab values mod_losers4 mod_losers4


*** Creation of modernization winner variable 1 : socio-cult prof
* Creation of variable
gen mod_winners1=0
replace mod_winners1 =1 if class16_r==13
replace mod_winners1 =1 if class16_r==14
replace mod_winners1 =. if class16_r==.

lab var mod_winners1 "Modernization winners 1; SCP oesch "
* Definition of value label
lab define mod_winners1 1 "mod winners (SCP oesch)" 0 "not winner"
lab values mod_winners1 mod_winners1


************************************
************************************
*	1.3 lm status: unempl, temp, involunt parttime


*** unemployed in last 5 years
* Creation of variable
gen unemployed5y=uemp5yr==1
lab var unemployed5y "Unemployed in last 5 years"
* Definition of value label
lab define unemployed5y 1 "unemployed in last 5 years" 0 "other"
lab values unemployed5y unemployed5y


*** temporary employed
* Creation of variable
gen temp=wrkctr==2
lab var temp "temporary employed (limited contract)"
* Definition of value label
lab define temp 1 "limited contract" 0 "other"
lab values temp temp


*** part-time
* Creation of variable
gen parttime=wkhct<30
lab var parttime "parttime employed (<30h)"
* Definition of value label
lab define parttime 1 "parttime" 0 "other"
lab values parttime parttime


************************************
************************************
* 	1.4 other variables : country dummies, polint, age, age2, income?, gender, sector?



*** Age
* Creation of variable
gen age=2010-yrbrn
lab var age "Age in years"
gen age2=age^2
lab var age2 "Age in years (squared)"


*** Political interest
* Creation of variable
gen polint=polintr
recode polint (1=4) (2=3) (3=2) (4=1)
lab var polint "Interest in politics"
* Definition of value label
lab define polint 4 "Very interested" 3 "Quite interested" 2 "Hardly interested" ///
	1 "Not at all interested"
lab values polint polint


*** Income
* Creation of variable
gen inc=hinctnt
sum hinctnt if cntry=="AT", detail
replace inc=hinctnt-r(p50) if cntry=="AT"
sum hinctnt if cntry=="BE", detail
replace inc=hinctnt-r(p50) if cntry=="BE"
sum hinctnt if cntry=="CH", detail
replace inc=hinctnt-r(p50) if cntry=="CH"
sum hinctnt if cntry=="CZ", detail
replace inc=hinctnt-r(p50) if cntry=="CZ"
sum hinctnt if cntry=="DE", detail
replace inc=hinctnt-r(p50) if cntry=="DE"
sum hinctnt if cntry=="DK", detail
replace inc=hinctnt-r(p50) if cntry=="DK"
sum hinctnt if cntry=="EE", detail
replace inc=hinctnt-r(p50) if cntry=="EE"
sum hinctnt if cntry=="ES", detail
replace inc=hinctnt-r(p50) if cntry=="ES"
sum hinctnt if cntry=="FI", detail
replace inc=hinctnt-r(p50) if cntry=="FI"
sum hinctnt if cntry=="FR", detail
replace inc=hinctnt-r(p50) if cntry=="FR"
sum hinctnt if cntry=="GB", detail
replace inc=hinctnt-r(p50) if cntry=="GB"
sum hinctnt if cntry=="GR", detail
replace inc=hinctnt-r(p50) if cntry=="GR"
sum hinctnt if cntry=="HU", detail
replace inc=hinctnt-r(p50) if cntry=="HU"
sum hinctnt if cntry=="IE", detail
replace inc=hinctnt-r(p50) if cntry=="IE"
sum hinctnt if cntry=="IL", detail
replace inc=hinctnt-r(p50) if cntry=="IL"
sum hinctnt if cntry=="IS", detail
replace inc=hinctnt-r(p50) if cntry=="IS"
sum hinctnt if cntry=="IT", detail
replace inc=hinctnt-r(p50) if cntry=="IT"
sum hinctnt if cntry=="LU", detail
replace inc=hinctnt-r(p50) if cntry=="LU"
sum hinctnt if cntry=="NL", detail
replace inc=hinctnt-r(p50) if cntry=="NL"
sum hinctnt if cntry=="NO", detail
replace inc=hinctnt-r(p50) if cntry=="NO"
sum hinctnt if cntry=="PL", detail
replace inc=hinctnt-r(p50) if cntry=="PL"
sum hinctnt if cntry=="PT", detail
replace inc=hinctnt-r(p50) if cntry=="PT"
sum hinctnt if cntry=="SE", detail
replace inc=hinctnt-r(p50) if cntry=="SE"
sum hinctnt if cntry=="SI", detail
replace inc=hinctnt-r(p50) if cntry=="SI"
sum hinctnt if cntry=="SK", detail
replace inc=hinctnt-r(p50) if cntry=="SK"
lab var inc "Income, difference between respondet class and median class per country"


************************************
************************************
*	1.5 Party choice and participation (adapted from Rommel&Walter)

*** Partisan preference, last election (not classified parties are missings)
* Creation of variable
gen party_vote=.
label var party_vote "Partisan preference, last election"
* Austria: no observations
* Belgium
replace   party_vote=1         if        prtvtcbe==1
replace   party_vote=5         if        prtvtcbe==2
replace   party_vote=5         if        prtvtcbe==3
replace   party_vote=5         if        prtvtcbe==4
replace   party_vote=3         if        prtvtcbe==5
replace   party_vote=.         if        prtvtcbe==6
replace   party_vote=7         if        prtvtcbe==7
replace   party_vote=4         if        prtvtcbe==8
replace   party_vote=5         if        prtvtcbe==9
replace   party_vote=1         if        prtvtcbe==10
replace   party_vote=7         if        prtvtcbe==11
replace   party_vote=4         if        prtvtcbe==12
replace   party_vote=3         if        prtvtcbe==13
replace   party_vote=.         if        prtvtcbe==14
replace   party_vote=.         if        prtvtcbe==15
replace   party_vote=0         if        prtvtcbe==16
replace   party_vote=.         if        prtvtcbe==17
replace   party_vote=.         if        prtvtcbe==18
* Switzerland
replace   party_vote=4         if        prtvtcch==1
replace   party_vote=5         if        prtvtcch==2
replace   party_vote=3         if        prtvtcch==3
replace   party_vote=7         if        prtvtcch==4
replace   party_vote=4         if        prtvtcch==5
replace   party_vote=.         if        prtvtcch==6
replace   party_vote=2         if        prtvtcch==7
replace   party_vote=1         if        prtvtcch==8
replace   party_vote=.         if        prtvtcch==9
replace   party_vote=7         if        prtvtcch==10
replace   party_vote=7         if        prtvtcch==11
replace   party_vote=5         if        prtvtcch==12
replace   party_vote=7         if        prtvtcch==13
replace   party_vote=.         if        prtvtcch==18
replace   party_vote=.         if        prtvtcch==19
replace   party_vote=0         if        prtvtcch==20

* Germany
replace   party_vote=3         if        prtvcde1==1
replace   party_vote=5         if        prtvcde1==2
replace   party_vote=1         if        prtvcde1==3
replace   party_vote=4         if        prtvcde1==4
replace   party_vote=2         if        prtvcde1==5
replace   party_vote=7         if        prtvcde1==6
replace   party_vote=7         if        prtvcde1==7
replace   party_vote=0         if        prtvcde1==8
* Denmark
replace   party_vote=3         if        prtvtbdk==1
replace   party_vote=1         if        prtvtbdk==2
replace   party_vote=6         if        prtvtbdk==3
replace   party_vote=1         if        prtvtbdk==4
replace   party_vote=7         if        prtvtbdk==5
replace   party_vote=5         if        prtvtbdk==6
replace   party_vote=4         if        prtvtbdk==7
replace   party_vote=0         if        prtvtbdk==8
replace   party_vote=2         if        prtvtbdk==9
replace   party_vote=0         if        prtvtbdk==10

* Spain
replace   party_vote=6         if        prtvtbes==1
replace   party_vote=3         if        prtvtbes==2
replace   party_vote=2         if        prtvtbes==3
replace   party_vote=6         if        prtvtbes==4
replace   party_vote=0         if        prtvtbes==5
replace   party_vote=0         if        prtvtbes==6
replace   party_vote=0         if        prtvtbes==7
replace   party_vote=0         if        prtvtbes==8
replace   party_vote=.         if        prtvtbes==9
replace   party_vote=.         if        prtvtbes==10
replace   party_vote=0         if        prtvtbes==74
replace   party_vote=.         if        prtvtbes==75
replace   party_vote=.         if        prtvtbes==76
* Finland
replace   party_vote=6         if        prtvtbfi==1
replace   party_vote=0         if        prtvtbfi==2
replace   party_vote=4         if        prtvtbfi==3
replace   party_vote=5         if        prtvtbfi==4
replace   party_vote=7         if        prtvtbfi==5
replace   party_vote=5         if        prtvtbfi==6
replace   party_vote=.         if        prtvtbfi==8
replace   party_vote=.         if        prtvtbfi==9
replace   party_vote=.         if        prtvtbfi==11
replace   party_vote=1         if        prtvtbfi==13
replace   party_vote=3         if        prtvtbfi==14
replace   party_vote=2         if        prtvtbfi==15
replace   party_vote=.         if        prtvtbfi==16
replace   party_vote=.         if        prtvtbfi==17
replace   party_vote=.         if        prtvtbfi==18
replace   party_vote=0         if        prtvtbfi==19
* France
replace   party_vote=.         if        prtvtbfr==1
replace   party_vote=7         if        prtvtbfr==2
replace   party_vote=2         if        prtvtbfr==3
replace   party_vote=2         if        prtvtbfr==4
replace   party_vote=.         if        prtvtbfr==5
replace   party_vote=4         if        prtvtbfr==6
replace   party_vote=2         if        prtvtbfr==7
replace   party_vote=3         if        prtvtbfr==8
replace   party_vote=.         if        prtvtbfr==9
replace   party_vote=4         if        prtvtbfr==10
replace   party_vote=6         if        prtvtbfr==11
replace   party_vote=1         if        prtvtbfr==12
replace   party_vote=.         if        prtvtbfr==13
replace   party_vote=0         if        prtvtbfr==14
replace   party_vote=0         if        prtvtbfr==15
replace   party_vote=0         if        prtvtbfr==16
replace   party_vote=.         if        prtvtbfr==17
replace   party_vote=.         if        prtvtbfr==18
* Great Britain
replace   party_vote=6         if        prtvtgb== 1
replace   party_vote=3         if        prtvtgb== 2
replace   party_vote=4         if        prtvtgb== 3
replace   party_vote=0         if        prtvtgb== 4
replace   party_vote=0         if        prtvtgb== 5
replace   party_vote=.         if        prtvtgb== 6
replace   party_vote=0         if        prtvtgb== 7
replace   party_vote=6         if        prtvtgb== 11
replace   party_vote=0         if        prtvtgb== 12
replace   party_vote=2         if        prtvtgb== 13
replace   party_vote=3         if        prtvtgb== 14
replace   party_vote=0         if        prtvtgb== 15
* Greece
replace   party_vote=3         if        prtvtcgr==1
replace   party_vote=6         if        prtvtcgr==2
replace   party_vote=2         if        prtvtcgr==3
replace   party_vote=7         if        prtvtcgr==4
replace   party_vote=2         if        prtvtcgr==5
replace   party_vote=.         if        prtvtcgr==6
replace   party_vote=.         if        prtvtcgr==7
replace   party_vote=.         if        prtvtcgr==8
replace   party_vote=.         if        prtvtcgr==9
replace   party_vote=.         if        prtvtcgr==10
replace   party_vote=.         if        prtvtcgr==11
replace   party_vote=.         if        prtvtcgr==12
replace   party_vote=.         if        prtvtcgr==13
replace   party_vote=0         if        prtvtcgr==14

* Ireland
replace   party_vote=6         if        prtvtaie==1
replace   party_vote=5         if        prtvtaie==2
replace   party_vote=1         if        prtvtaie==3
replace   party_vote=.         if        prtvtaie==4
replace   party_vote=3         if        prtvtaie==5
replace   party_vote=.         if        prtvtaie==6
replace   party_vote=2         if        prtvtaie==7
replace   party_vote=2         if        prtvtaie==8
replace   party_vote=.         if        prtvtaie==9
replace   party_vote=0         if        prtvtaie==10

* Iceland: no observations
* Italy: no observations
* Luxembourg: no observations
* Netherlands
replace   party_vote=4         if        prtvtdnl==1
replace   party_vote=3         if        prtvtdnl==2
replace   party_vote=7         if        prtvtdnl==3
replace   party_vote=5         if        prtvtdnl==4
replace   party_vote=2         if        prtvtdnl==5
replace   party_vote=4         if        prtvtdnl==6
replace   party_vote=1         if        prtvtdnl==7
replace   party_vote=5         if        prtvtdnl==8
replace   party_vote=4         if        prtvtdnl==9
replace   party_vote=.         if        prtvtdnl==10
replace   party_vote=.         if        prtvtdnl==11
replace   party_vote=0         if        prtvtdnl==12
replace   party_vote=.         if        prtvtdnl==13
* Norway
replace   party_vote=.         if        prtvtano==1
replace   party_vote=2         if        prtvtano==2
replace   party_vote=3         if        prtvtano==3
replace   party_vote=4         if        prtvtano==4
replace   party_vote=5         if        prtvtano==5
replace   party_vote=5         if        prtvtano==6
replace   party_vote=6         if        prtvtano==7
replace   party_vote=7         if        prtvtano==8
replace   party_vote=.         if        prtvtano==9
replace   party_vote=0         if        prtvtano==10

* Portugal
replace   party_vote=2         if        prtvtbpt==1
replace   party_vote=5         if        prtvtbpt==2
replace   party_vote=2         if        prtvtbpt==3
replace   party_vote=.         if        prtvtbpt==4
replace   party_vote=.         if        prtvtbpt==6
replace   party_vote=.         if        prtvtbpt==7
replace   party_vote=7         if        prtvtbpt==8
replace   party_vote=.         if        prtvtbpt==9
replace   party_vote=5         if        prtvtbpt==10
replace   party_vote=3         if        prtvtbpt==11
replace   party_vote=.         if        prtvtbpt==12
replace   party_vote=0         if        prtvtbpt==13
* Sweden
replace   party_vote=5         if        prtvtase==1
replace   party_vote=4         if        prtvtase==2
replace   party_vote=5         if        prtvtase==3
replace   party_vote=1         if        prtvtase==4
replace   party_vote=6         if        prtvtase==5
replace   party_vote=3         if        prtvtase==6
replace   party_vote=2         if        prtvtase==7
replace   party_vote=.         if        prtvtase==8
replace   party_vote=.         if        prtvtase==9
replace   party_vote=7         if        prtvtase==10
replace   party_vote=0         if        prtvtase==11

* Definition of value labels
label def party_vote 0 "Other" 1 "Green" 2 "Communist" 3 "Social democratic" ///
	4 "Liberal"	5 "Christian democratic" 6 "Conservative" 7 "Nationalist"
	label val party_vote party_vote
	
	*** Party closeness (not classified parties are missings)
* Creation of variable
gen party_close=.
label var party_close "Party closeness"
* Austria: no observations
* Belgium
replace   party_close=1         if        prtclcbe==1
replace   party_close=5         if        prtclcbe==2
replace   party_close=5         if        prtclcbe==3
replace   party_close=5         if        prtclcbe==4
replace   party_close=3         if        prtclcbe==5
replace   party_close=.         if        prtclcbe==6
replace   party_close=7         if        prtclcbe==7
replace   party_close=4         if        prtclcbe==8
replace   party_close=5         if        prtclcbe==9
replace   party_close=1         if        prtclcbe==10
replace   party_close=7         if        prtclcbe==11
replace   party_close=4         if        prtclcbe==12
replace   party_close=3         if        prtclcbe==13
replace   party_close=.         if        prtclcbe==14
replace   party_close=.         if        prtclcbe==15
replace   party_close=0         if        prtclcbe==16
replace   party_close=.         if        prtclcbe==17
replace   party_close=.         if        prtclcbe==18
* Switzerland
replace   party_close=4         if        prtclcch==1
replace   party_close=5         if        prtclcch==2
replace   party_close=3         if        prtclcch==3
replace   party_close=7         if        prtclcch==4
replace   party_close=4         if        prtclcch==5
replace   party_close=.         if        prtclcch==6
replace   party_close=2         if        prtclcch==7
replace   party_close=1         if        prtclcch==8
replace   party_close=.         if        prtclcch==9
replace   party_close=7         if        prtclcch==10
replace   party_close=7         if        prtclcch==11
replace   party_close=5         if        prtclcch==12
replace   party_close=7         if        prtclcch==13
replace   party_close=.         if        prtclcch==18
replace   party_close=.         if        prtclcch==19
replace   party_close=0         if        prtclcch==20

* Germany
replace   party_close=3         if        prtclcde==1
replace   party_close=5         if        prtclcde==2
replace   party_close=1         if        prtclcde==3
replace   party_close=4         if        prtclcde==4
replace   party_close=2         if        prtclcde==5
replace   party_close=7         if        prtclcde==6
replace   party_close=7         if        prtclcde==7
replace   party_close=0         if        prtclcde==8
* Denmark
replace   party_close=3         if        prtclbdk==1
replace   party_close=1         if        prtclbdk==2
replace   party_close=6         if        prtclbdk==3
replace   party_close=1         if        prtclbdk==4
replace   party_close=7         if        prtclbdk==5
replace   party_close=5         if        prtclbdk==6
replace   party_close=4         if        prtclbdk==7
replace   party_close=0         if        prtclbdk==8
replace   party_close=2         if        prtclbdk==9
replace   party_close=0         if        prtclbdk==10

* Spain
replace   party_close=6         if        prtclbes==1
replace   party_close=3         if        prtclbes==2
replace   party_close=2         if        prtclbes==3
replace   party_close=6         if        prtclbes==4
replace   party_close=0         if        prtclbes==5
replace   party_close=0         if        prtclbes==6
replace   party_close=0         if        prtclbes==7
replace   party_close=0         if        prtclbes==8
replace   party_close=.         if        prtclbes==9
replace   party_close=.         if        prtclbes==10
replace   party_close=0         if        prtclbes==74
replace   party_close=.         if        prtclbes==75
replace   party_close=.         if        prtclbes==76
* Finland
replace   party_close=6         if        prtclbfi==1
replace   party_close=0         if        prtclbfi==2
replace   party_close=4         if        prtclbfi==3
replace   party_close=5         if        prtclbfi==4
replace   party_close=7         if        prtclbfi==5
replace   party_close=5         if        prtclbfi==6
replace   party_close=.         if        prtclbfi==8
replace   party_close=.         if        prtclbfi==9
replace   party_close=.         if        prtclbfi==11
replace   party_close=1         if        prtclbfi==13
replace   party_close=3         if        prtclbfi==14
replace   party_close=2         if        prtclbfi==15
replace   party_close=.         if        prtclbfi==16
replace   party_close=.         if        prtclbfi==17
replace   party_close=.         if        prtclbfi==18
replace   party_close=0         if        prtclbfi==19
* France
replace   party_close=.         if        prtclcfr==1
replace   party_close=7         if        prtclcfr==2
replace   party_close=2         if        prtclcfr==3
replace   party_close=2         if        prtclcfr==4
replace   party_close=.         if        prtclcfr==5
replace   party_close=4         if        prtclcfr==6
replace   party_close=2         if        prtclcfr==7
replace   party_close=3         if        prtclcfr==8
replace   party_close=.         if        prtclcfr==9
replace   party_close=4         if        prtclcfr==10
replace   party_close=6         if        prtclcfr==11
replace   party_close=1         if        prtclcfr==12
replace   party_close=.         if        prtclcfr==13
replace   party_close=0         if        prtclcfr==14
replace   party_close=0         if        prtclcfr==15
replace   party_close=0         if        prtclcfr==16
replace   party_close=.         if        prtclcfr==17
replace   party_close=.         if        prtclcfr==18
* Great Britain
replace   party_close=6         if        prtclgb== 1
replace   party_close=3         if        prtclgb== 2
replace   party_close=4         if        prtclgb== 3
replace   party_close=0         if        prtclgb== 4
replace   party_close=0         if        prtclgb== 5
replace   party_close=.         if        prtclgb== 6
replace   party_close=0         if        prtclgb== 7
replace   party_close=6         if        prtclgb== 11
replace   party_close=0         if        prtclgb== 12
replace   party_close=2         if        prtclgb== 13
replace   party_close=3         if        prtclgb== 14
replace   party_close=0         if        prtclgb== 15
* Greece
replace   party_close=3         if        prtclcgr==1
replace   party_close=6         if        prtclcgr==2
replace   party_close=2         if        prtclcgr==3
replace   party_close=7         if        prtclcgr==4
replace   party_close=2         if        prtclcgr==5
replace   party_close=.         if        prtclcgr==6
replace   party_close=.         if        prtclcgr==7
replace   party_close=.         if        prtclcgr==8
replace   party_close=.         if        prtclcgr==9
replace   party_close=.         if        prtclcgr==10
replace   party_close=.         if        prtclcgr==11
replace   party_close=.         if        prtclcgr==12
replace   party_close=.         if        prtclcgr==13
replace   party_close=0         if        prtclcgr==14

* Ireland
replace   party_close=6         if        prtclaie==1
replace   party_close=5         if        prtclaie==2
replace   party_close=1         if        prtclaie==3
replace   party_close=.         if        prtclaie==4
replace   party_close=3         if        prtclaie==5
replace   party_close=.         if        prtclaie==6
replace   party_close=2         if        prtclaie==7
replace   party_close=2         if        prtclaie==8
replace   party_close=.         if        prtclaie==9
replace   party_close=0         if        prtclaie==10

* Iceland: no observations
* Italy: no observations
* Luxembourg: no observations
* Netherlands
replace   party_close=4         if        prtclcnl==1
replace   party_close=3         if        prtclcnl==2
replace   party_close=7         if        prtclcnl==3
replace   party_close=5         if        prtclcnl==4
replace   party_close=2         if        prtclcnl==5
replace   party_close=4         if        prtclcnl==6
replace   party_close=1         if        prtclcnl==7
replace   party_close=5         if        prtclcnl==8
replace   party_close=4         if        prtclcnl==9
replace   party_close=.         if        prtclcnl==10
replace   party_close=.         if        prtclcnl==11
replace   party_close=0         if        prtclcnl==12
replace   party_close=.         if        prtclcnl==13
* Norway
replace   party_close=.         if        prtclano==1
replace   party_close=2         if        prtclano==2
replace   party_close=3         if        prtclano==3
replace   party_close=4         if        prtclano==4
replace   party_close=5         if        prtclano==5
replace   party_close=5         if        prtclano==6
replace   party_close=6         if        prtclano==7
replace   party_close=7         if        prtclano==8
replace   party_close=.         if        prtclano==9
replace   party_close=0         if        prtclano==10

* Portugal
replace   party_close=2         if        prtclcpt==1
replace   party_close=5         if        prtclcpt==2
replace   party_close=2         if        prtclcpt==3
replace   party_close=.         if        prtclcpt==4
replace   party_close=.         if        prtclcpt==6
replace   party_close=.         if        prtclcpt==7
replace   party_close=7         if        prtclcpt==8
replace   party_close=.         if        prtclcpt==9
replace   party_close=5         if        prtclcpt==10
replace   party_close=3         if        prtclcpt==11
replace   party_close=.         if        prtclcpt==12
replace   party_close=0         if        prtclcpt==13
* Sweden
replace   party_close=5         if        prtclase==1
replace   party_close=4         if        prtclase==2
replace   party_close=5         if        prtclase==3
replace   party_close=1         if        prtclase==4
replace   party_close=6         if        prtclase==5
replace   party_close=3         if        prtclase==6
replace   party_close=2         if        prtclase==7
replace   party_close=.         if        prtclase==8
replace   party_close=.         if        prtclase==9
replace   party_close=7         if        prtclase==10
replace   party_close=0         if        prtclase==11

* Definition of value labels
label def party_close 0 "Other" 1 "Green" 2 "Communist" 3 "Social democratic" ///
	4 "Liberal"	5 "Christian democratic" 6 "Conservative" 7 "Nationalist"
label val party_close party_close


*** Voter participation
* Creation of variable 
gen voted=vote==1
replace voted=. if vote>2
lab var voted "Voter participation"
* Definition of value label
lab define voted 1 "Voter" 0 "Non-voter"
lab values voted voted


save "ESSrecoded5.dta", replace

*----------------------------------------------------------------------------------------*
*	6. Merge
*----------------------------------------------------------------------------------------*
* Basic commands
clear all
set mem 1g
set more off
capture log close
*dataset

use "ESSrecoded1.dta"

append using "ESSrecoded2.dta"
append using "ESSrecoded3.dta"
append using "ESSrecoded4.dta"
append using "ESSrecoded5.dta"


save "ESSrecoded1_5.dta", replace


*----------------------------------------------------------------------------------------*
*	7. Analysis - frequencies
*----------------------------------------------------------------------------------------*

use "ESSrecoded1_5.dta"


mean unemployed5y
mean temp
mean parttime


mean unemployed5y if glob_losers1==1
mean unemployed5y if glob_winners1==1
mean unemployed5y if mod_losers1==1
mean unemployed5y if mod_losers4==1
mean unemployed5y if mod_winners1==1

mean temp if glob_losers1==1
mean temp if glob_winners1==1
mean temp if mod_losers1==1
mean temp if mod_losers4==1
mean temp if mod_winners1==1

mean parttime if glob_losers1==1
mean parttime if glob_winners1==1
mean parttime if mod_losers1==1
mean parttime if mod_losers4==1
mean parttime if mod_winners1==1

* frequencies --> table 1 (via xlsx)


*----------------------------------------------------------------------------------------*
*	8. Analysis - participation and partyvote
*----------------------------------------------------------------------------------------*

* ropop dummy (rpop vs. anderes)

gen vrpop=.
replace vrpop=0 if inlist(party_vote,1,2,3,4,5,6)
replace vrpop=1 if party_vote==7

* add non-voters to the vrpop-reference group
replace vrpop=0 if voted==0

* generate low education as a control variable
gen edlow=0
replace edlow=1 if educlvl==1
replace edlow=1 if educlvl==2


* Nur fuer Lander mit rechts-populistischen Parteien 
* nur AT, BE, CH, DK, FI, FR, NL, NO


drop if de==1
drop if es==1
drop if gb==1
drop if gr==1
drop if ie==1
drop if pt==1
drop if se==1
drop if it==1

* Auslaender ausschliessen

drop if ctzcntr==2


* DETERMINANTS OF VOTING AND RPOP-VOTE AMONG THE WORKING CLASS ONLY (outsider, glob_losers1: low-skilled offshoreable, mod_losers1: routine service; mod_losers4: routine and skilled manual)
gen work=0
replace work=1 if class8_r==4
replace work=1 if class8_r==6
replace work=1 if class8_r==8
replace work=. if class8_r==.

preserve
keep if work==1
logit voted unemployed5y temp parttime edlow gender age inc be dk fi fr nl no
estimates store votedlogit1
restore

preserve
keep if work==1
logit vrpop unemployed5y temp parttime edlow gender age inc be dk fi fr nl no
estimates store vrpoplogit1
restore

preserve
keep if work==1
logit voted unemployed5y temp parttime glob_losers1 edlow gender age inc be dk fi fr nl no
estimates store votedlogit2
restore

preserve
keep if work==1
logit vrpop unemployed5y temp parttime glob_losers1 edlow gender age inc be dk fi fr nl no
estimates store vrpoplogit2
restore

preserve
keep if work==1
logit voted unemployed5y temp parttime mod_losers4 edlow gender age inc be dk fi fr nl no
estimates store votedlogit3
restore

preserve
keep if work==1
logit vrpop unemployed5y temp parttime mod_losers4 edlow gender age inc be dk fi fr nl no
estimates store vrpoplogit3
restore

preserve
keep if work==1
logit voted unemployed5y temp parttime mod_losers1 edlow gender age inc be dk fi fr nl no
estimates store votedlogit4
restore

preserve
keep if work==1
logit vrpop unemployed5y temp parttime mod_losers1 edlow gender age inc be dk fi fr nl no
estimates store vrpoplogit4
restore

estout votedlogit1 vrpoplogit1 votedlogit2 vrpoplogit2 votedlogit3 vrpoplogit3 votedlogit4 vrpoplogit4, cells(b(star fmt(%9.2f)) z(fmt(%9.2f))) style(fixed) starlevels(# 0.10 * 0.05 ** 0.01 *** 0.001) stats(N)


