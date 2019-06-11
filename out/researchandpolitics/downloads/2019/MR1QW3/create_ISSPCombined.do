
*===============================================================*
*Do-File: 
*Do State Responses to Automation Matter for Voters? *
*Research and Politics *
*ISSP FILE *

*January 25th 2019*
*===============================================================*

*In order to create the ISSP files download the following files from the GESIS archive
* 1990 - ZA1950
* 1991 - ZA5070
* 1992 - ZA2310
* 1993 - ZA2450
* 1994 - ZA2620
* 1995 - ZA2880
* 1996 - ZA2900
* 1997 - ZA3090
* 1998 - ZA3190
* 1999 - ZA3430
* 2000 - ZA3440
* 2001 - ZA3680
* 2002 - ZA3880
* 2003 - ZA3910
* 2004 - ZA3950
* 2005 - ZA4350
* 2005 - ZA4350
* 2006 - ZA4700
* 2007 - ZA4850
* 2008 - ZA4950
* 2009 - ZA5400
* 2010 - ZA5500
* 2011 - ZA5800
* 2012 - ZA5900
* 2013 - ZA5950
* 2014 - ZA6670
* 2015 - ZA6770
* 2016 - ZA6900

*The occupational recoding for 1995-1997 draws on the work of Cusack, Iversen, and Rehm and Iversen and Soskice 2001,
*http://www.people.fas.harvard.edu/~iversen/SkillSpecificity.htm* 
*The citations for this code are further noted below



clear
set more off

* set working directory
cd "INSERTYOURPATH"   

local cleaning_originals 1
*This codes the individual ISSP files*
local cleaning_combined 1
*This cleans the combined files*
local party_coding 1
*This codes the party families*
local merging 1
*This merges the contextual data*

set more off
if `cleaning_originals'==1 { 
set more off 
local year_1995 1 
local year_1996 1 
local year_1997 1 
local year_1998 1 
local year_1999 1 
local year_2000 1 
local year_2001 1 
local year_2002 1 
local year_2003 1 
local year_2004 1 
local year_2005 1 
local year_2006 1 
local year_2007 1 
local year_2008 1 
local year_2009 1 
local year_2010 1 
local year_2011 1 
local year_2012 1 
local year_2013 1 
local year_2014 1 
local year_2015 1 
local year_2016 1 

tempfile temp95    /* create a temporary file */
tempfile temp96    
tempfile temp97    
tempfile temp98    
tempfile temp99    
tempfile temp00   
tempfile temp01    
tempfile temp02    
tempfile temp03    
tempfile temp04    
tempfile temp05    
tempfile temp06    
tempfile temp07    
tempfile temp08    
tempfile temp09    
tempfile temp10    
tempfile temp11    
tempfile temp12   
tempfile temp13    
tempfile temp14    
tempfile temp15    
 
if `year_1995'==1 {
********
* 1995 *
********
use "ZA2880.dta", clear

local main_variables 1
local parties 1
local occupation_recode 1

if `main_variables'==1 {
gen case=v2
lab var case "Case ID Number"

gen YYYY=1995
lab var YYYY "Survey Year"

recode v342 0=., gen(weight)
lab val weight weight
lab var weight "Weight"

gen country=.
replace country=36 if v3==1
replace country=276 if v3==2
replace country=276 if v3==3
replace country=826 if v3==4
replace country=840 if v3==6
replace country=40 if v3==7
replace country=380 if v3==9
replace country=372 if v3==10
replace country=528 if v3==11
replace country=578 if v3==12
replace country=752 if v3==13
replace country=554 if v3==19
replace country=124 if v3==20
replace country=392 if v3==23
replace country=724 if v3==24

lab def country ///
	36 "Australia" ///
	40 "Austria" ///
	124 "Canada" ///
	276 "Germany" ///
	380 "Italy" ///
	372 "Ireland" ///
	392 "Japan" ///
	528 "Netherlands" ///
	554 "New Zealand" ///
	578 "Norway" ///
	724 "Spain" ///
	752 "Sweden" ///
	826 "UK" ///
	840 "USA" 
lab val country country
lab var country "Country"
tab country

gen east_germany=1 if v3==3

recode v200 0=., gen(sex)

gen age= v201
gen birth=1995-age
label var birth "Year of Birth"

gen empl=.
replace empl =2 if v206==1
replace empl =2 if v206 ==2
replace empl =1 if v206 ==5
lab def empl ///
	1 "Unemployed" ///
	2 "Employed" 
lab val empl empl
lab var empl "Employment Status - 2"
tab empl

gen employee=.
replace employee =2 if v213 ==1
replace employee =1 if v213 ==2
lab def employee ///
	1 "Employed" ///
	2 "Self Employed" 
lab val employee employee
lab var employee "Employee"
tab employee

tab v206
recode v206 0=., gen(emplB)
lab def emplB ///
	1 "Employed FT" ///
	2 "Employed PT" ///
	3 "Less than PT" ///
	4 "Helping Family Member" ///
	5 "Unemployed" ///
	6 "Student" ///
	7 "Retired" ///
	8 "Housewife/man" ///
	9 "Perm. dis" ///
	10 "Not in LF" 
lab val emplB emplB
lab var emplB "Employment Status"
tab emplB


gen education=.
replace education=1 if v205==1
replace education=1 if v205==2
replace education=1 if v205==3
replace education=2 if v205==4
replace education=3 if v205==5
replace education=4 if v205==6
replace education=5 if v205==7
lab def education ///
	1 "Less than lower secondary" ///
	2 "Lower Secondary" ///
	3 "Upper Secondary" ///
	4 "Vocational" ///
	5 "Degree" 
lab val education education
lab var education "Education Collapsed"
tab education
}

if `parties'==1 {

gen party_type=.
replace party_type=2 if country==36
replace party_type=1 if country==40
replace party_type=2 if country==124
replace party_type=2 if country==756
replace party_type=1 if country==276
replace party_type=1 if country==724
replace party_type=1 if country==826
replace party_type=1 if country==380
replace party_type=1 if country==372
replace party_type=2 if country==392
replace party_type=3 if country==528
replace party_type=2 if country==578
replace party_type=3 if country==554
replace party_type=2 if country==752
replace party_type=1 if country==840


gen party=.
*Australia*
replace party =v271 if country==36
replace party=99 if v271==. & country==36

*Austria*
replace party =v270 if country==40
replace party=8 if party==4 & country==40
replace party=9 if party==5 & country==40
replace party=99 if v270==. & country==40
replace party=96 if v270==95 & country==40

*Canada*
replace party =v273 if country==124
replace party=97 if v273==96
replace party=99 if v273==. & country==124
replace party=96 if v273==95 & country==124

*Germany*
replace party =2 if country==276 & v275==1
replace party =1 if country==276 & v275==2
replace party =4 if country==276 & v275==3
replace party =5 if country==276 & v275==4
replace party =8 if country==276 & v275==7
replace party =9 if country==276 & v275==8
replace party =97 if country==276 & v275==96
replace party=99 if v275==. & country==276
replace party =96 if country==276 & v275==9
replace party =96 if country==276 & v275==10
replace party =96 if country==276 & v275==11
replace party =10 if country==276 & v275==12
replace party =96 if country==276 & v275==13
replace party =96 if country==276 & v275==14
replace party =96 if country==276 & v275==15
replace party =96 if country==276 & v275==16
replace party =96 if country==276 & v275==17

*Spain*
replace party=1 if country==724 & v276==1
replace party=2 if country==724 & v276==2
replace party=3 if country==724 & v276==3
replace party=4 if country==724 & v276==4
replace party=6 if country==724 & v276==5
replace party=5 if country==724 & v276==6
replace party=7 if country==724 & v276==7
replace party=97 if country==724 & v276==96
replace party=96 if v276==95
replace party=99 if v276==. & country==724

*UK*
replace party =v277 if country==826
replace party=4 if v277==6
replace party=5 if v277==7
replace party=6 if v277==8
replace party=99 if v277==93
replace party=97 if v277==96
replace party=96 if v277==95
replace party=99 if v277==. & country==826

*Italy*
replace party =1 if v279==1 & country==380
replace party =16 if v279==2 & country==380
replace party =17 if v279==3 & country==380
replace party =19 if v279==4 & country==380
replace party =18 if v279==5 & country==380
replace party =96 if v279==6 & country==380
replace party =18 if v279==7 & country==380
replace party =21 if v279==8 & country==380
replace party =11 if v279==9 & country==380
replace party =12 if v279==10 & country==380
replace party =96 if v279==11 & country==380
replace party =7 if v279==12 & country==380
replace party =8 if v279==13 & country==380
replace party =12 if v279==14 & country==380
replace party =14 if v279==15 & country==380
replace party =97 if v279==96 & country==380
replace party=99 if v279==. & country==380
replace party =96 if v279==95 & country==380

*Ireland*
replace party=v280 if country==372
replace party=99 if v280==. & country==372
replace party =97 if v280==96 & country==372

*Japan*
replace party=1 if v281==1 & country==392
replace party=7 if v281==2 & country==392
replace party=2 if v281==3 & country==392
replace party=8 if v281==4 & country==392
replace party=4 if v281==5 & country==392
replace party=99 if v281==. & country==392
replace party =97 if v281==96 & country==392
replace party =96 if v281==95 & country==392

*Norway*
replace party=10 if v283==1 & country==578
replace party=6 if v283==2 & country==578
replace party=1 if v283==3 & country==578
replace party=2 if v283==4 & country==578
replace party=4 if v283==5 & country==578
replace party=3 if v283==6 & country==578
replace party=7 if v283==7 & country==578
replace party=5 if v283==8 & country==578
replace party=99 if v283==. & country==578
replace party =97 if v283==96 & country==578
replace party =96 if v283==95 & country==578

*Netherlands*
replace party=1 if v284==1 & country==528
replace party=2 if v284==2 & country==528
replace party=3 if v284==3 & country==528
replace party=4 if v284==4 & country==528
replace party=8 if v284==5 & country==528
replace party=9 if v284==6 & country==528
replace party=10 if v284==7 & country==528
replace party=11 if v284==8 & country==528
replace party=11 if v284==9 & country==528
replace party=5 if v284==10 & country==528
replace party=6 if v284==11 & country==528
replace party=7 if v284==12 & country==528
replace party=99 if v284==. & country==528
replace party =97 if v284==96 & country==528
replace party =96 if v284==95 & country==528


replace party=11 if v285==1 & country==554
replace party=2 if v285==2 & country==554
replace party=3 if v285==3 & country==554
replace party=9 if v285==4 & country==554
replace party=96 if v285==95 & country==554
replace party=99 if v285==. & country==554


*Sweden*
replace party=v289 if country==752
replace party=12 if v289==6 & country==752
replace party=6 if v289==7 & country==752
replace party=7 if v289==8 & country==752
replace party=99 if v289==. & country==752
replace party =97 if v289==96 & country==752
replace party =96 if v289==95 & country==752

replace party=v292 if country==840
replace party=99 if v292==. & country==840
replace party =97 if v292==96 & country==840
replace party =96 if v292==95 & country==840

lab val party party
lab var party "Party Choice"
tab party

}

if `occupation_recode'==1 {

recode v209 0=., gen(isco_nat)
lab val isco_nat isco_nat
lab var isco_nat "Occupation Nationally Specific"

gen isco_6895=v208 if  country==578  |  country==554 | country==276|  country==40 |  country==724 |  country==840  

gen isco=v208 if isco_6895==.
gen isco_3=.

*Some occupational recoding draws on the work of Cusack, Iversen, and Rehm and Iversen and Soskice 2001,
*http://www.people.fas.harvard.edu/~iversen/SkillSpecificity.htm* 

gen occ88=isco_6895 if isco_68!=1 
recode occ88 0100=-2110 0110=-2113 0120=-2111 0131=-2114 0132=-2111 0133=-2112 0140=-3111 0200=-2140 ///
 0210=-2141 0220=-2142 0230=-2143 0240=-2145 0250=-2146 0260=-2147 0270=-2147 0280=-2149 0290=-2149 0300=-3110 ///
 0310=-2148 0320=-3118 0321=-3118 0329=-3118 0330=-3112 0340=-3113 0340=-3114 0350=-3115 0360=-3116 ///
 0370=-3117 0380=-3117 0390=-3119 0400=-3140 0410=-3143 0411=-3143 0419=-3143 0420=-3142 0421=-3142 ///
 0429=-3142 0430=-3141 0500=-2210 0510=-2211 0520=-2212 0521=-2212 0529=-2212 0530=-2213 0531=-3213 ///
 0539=-2213 0540=-3211 0541=-3212 0549=-3211 0600=-2221 0610=-2221 0611=-2221 0619=-2221 0620=-3221 ///
 0630=-2222 0640=-3225 0650=-2223 0660=-3227 0670=-2224 0680=-3228 0690=-3223 0700=-2230 0710=-2230 ///
 0711=-2230 0719=-2230 0720=-3231 0730=-2230 0740=-3232 0750=-3224 0751=-3224 0759=-3224 0760=-3226 ///
 0761=-3226 0762=-3226 0769=-3226 0770=-3133 0780=-3220 0790=-3229 0791=-3226 0792=-3241 0793=-3222 ///
 0799=-2226  0800=-2120 0810=-2122 0820=-2121 0830=-2131 0840=-3434 0849=-2132 0900=-2441 1100=-2411 ///
 1101=-2411 1109=-2411 1200=-2420 1210=-2421 1211=-2421 1219=-2421 1220=-2422 1221=-2422 1222=-2422 ///
 1229=-2422 1290=-2429 1291=-2429 1299=-2429 0130=-2110  1300=-2300 1310=-2310 1311=-1229 1319=-2310 ///
 1320=-2321 1321=-2323 1329=-2321 1330=-2331 1340=-2332 1350=-2340 1390=-2359 1391=-1229 1392=-2352 ///
 1393=-3300 1394=-1229 1399=-2322 1400=-2460 1410=-2460 1411=-2460 1412=-3480 1413=-2460 1414=-2460 ///
 1415=-2460 1416=-3480 1419=-2460  1490=-3480 1491=-3242 1499=-3480 1500=-2451 1510=-2451 1511=-2451 ///
 1519=-2451 1590=-2451 1591=-2451 1592=-2451 1593=-2419 1599=-2451  1600=-2450 1610=-2452 1620=-3471 ///
 1621=-3471 1622=-3471 1629=-3471 1630=-3131 1631=-3131 1639=-3131 1700=-3470 1710=-3473 1711=-2453 ///
 1712=-3473 1713=-3473 1719=-2453  1720=-3473 1721=-2454 1729=-3473 1730=-2455 1731=-2455 1732=-2455 ///
 1739=-2455 1740=-1229 1749=-1229 1750=-3474 1790=-3470 1791=-3473 1799=-3472 1800=-3475 1801=-3475 ///
 1809=-3475 1900=-2400 1910=-2432 1920=-2442 1921=-2445 1922=-2443 1923=-2443 1924=-2442 1929=-2442 1930=-2446 1931=-3460 ///
 1939=-2446 1940=-2412 1941=-2412 1949=-1232 1950=-2444 1951=-2444 1959=-2444 1960=-2000 1990=-3400 1991=-5150 1992=-3450 ///
 1993=-5113 1994=-3340 1995=-3429 1999=-3100 20=1100 2000=-1110 2010=-1100 2011=-1120 2012=-1120 2013=-1120 2014=-1120 ///
 2015=-1130 2020=-1110 2021=-1110 2022=-1110 2023=-1110 2024=-1110 2029=-1110 2030=-1120 2031=-1120 2032=-1120 2033=-1120 ///
 2034=-1120 2035=-1120 2036=-1130 2039=-1120 2100=-1300 2110=-1200 2110=-1200 2111=-1210 2112=-1210 2113=-1319 2114=-1227 ///
 2115=-1227 2116=-1313 2119=-1210 2119=-1210 2120=-1220 2190=-1220 2191=-1230 2192=-1230 2193=-1230 2194=-1230 2195=-1141 ///
 2196=-1142 2197=-1142 2199=-1227 3000=-1231 3009=-1240 3100=-3440 3101=-3440 3102=-3444 3103=-3441 3104=-3442 3109=-3440 ///
 3200=-4110 3210=-4111 3211=-4115 3219=-4111 3220=-4113 3300=-3430 3310=-3433 3311=-4211 3312=-4211 3313=-4212 3314=-4212 ///
 3315=-4211 3319=-3433 3390=-4120 3391=-4215 3399=-4121 3400=-3120 3410=-4114 3420=-3122 3500=-4133 3510=-1226 3520=-1226 ///
 3590=-4133 3600=-5112 3601=-5112 3602=-5112 3609=-5112 3700=-4142 3701=-9151 3709=-4142 3800=-4223 3801=-3132 3802=-3132 ///
 3809=-4223 3900=-4100 3910=-4131 3911=-4131 3919=-4131 3920=-4132 3930=-4100 3931=-4100 3932=-3432 3939=-4100 3940=-4222 ///
 3941=-4233 3942=-4131 3943=-3414 3949=-4222 3950=-4141 3951=-4141 3959=-4141 3990=-4190 3991=-4143  3992=-1141 3993=-9153 ///
 3999=-4143 4000=-1314 4001=-1217  4002=-1231  4009=-1314 4100=-1314 4101=-1224 4102=-5230 4103=-1224 4104=-3421 4105=-3421  ///
 4106=-1314 4107=-9333 4108=-3423 4109=-1314 4200=-1233 4210=-1233 4220=-3416 4221=-3416 4222=-3416 4229=-3416 4300=-3415 /// 
 4310=-3415 4311=-3415 4319=-3415 4320=-3415 4400=-3410 4410=-3412 4411=-3413 4412=-3411 4419=-3412 4420=-3429 4430=-3417 ///
 4431=-3417 4432=-3417 4500=-5200 4510=-5220 4511=-5220 4512=-5220 4513=-5210 4514=-5220 4519=-5220 4520=-9110 4521=-9110 ///
 4522=-9113 4523=-9112 4524=-9113 4525=-9110 4529=-5230 4900=-5200 5000=-1315 5001=-1315 5002=-1225 5009=-1225 5100=-1315 ///
 5100=-5000 5101=-1315 5102=-1315 5103=-1315 5104=-1315 5109=-1315 5200=-5121 5201=-5121 5209=-5121 5300=-5120 5310=-5122 ///
 5311=-5122 5312=-9132 5319=-5122 5320=-5123 5321=-5123 5322=-5123 5329=-5123 5400=-9130 5401=-5131 5402=-9132 5403=-9152 ///
 5409=-5142 5500=-9140 5510=-9141 5511=-9141 5512=-9141 5519=-9141 5520=-9132 5521=-9142 5522=-7143 5529=-9132 5600=-8264 ///
 5700=-5141 5701=-5141 5702=-5141 5703=-5141 5709=-5141 5800=-5160 5810=-5161 5820=-5162 5821=-3451 5822=-1229 5823=-1229 ///
 5829=-5162 5830=-5164 5831=-1229 5832=-3452 5833=-5164 5890=-5169 5891=-5163 5892=-3432 5899=-9152 5900=-5100 5910=-5113 ///
 5920=-5143 5990=-5100 5991=-9152 5992=-9151 5993=-9151 5994=-9152 5995=-9120 5996=-5111 5997=-4213 5998=-9151 5999=-5132 ///
 6000=-1311 6001=-6132 6009=-1311 6100=-6133 6110=-6133 6111=-1311 6112=-6210 6113=-6133 6114=-6133 6115=-6130 6116=-6130 ///
 6117=-9211 6119=-6133 6120=-6130 6200=-9211 6210=-9211 6211=-9211 6219=-9211 6220=-9211 6230=-9211 6239=-9211 6240=-9211 ///
 6240=-9211 6250=-9211 6260=-9211 6270=-9211 6280=-8331 6290=-9211 6290=-9200 6291=-9211 6299=-6100 6300=-9212 6310=-6141 ///
 6311=-6141 6319=-6141 6320=-9142  6329=-6141  6400=-6150 6410=-6150 6411=-6150 6419=-6150 6490=-6150 6491=-6154 6499=-9213 ///
 7000=-7510 7001=-7510 7009=-7510 7100=-7110 7110=-7111 7111=-7111 7112=-7111 7113=-7111 7119=-7111 7120=-8112 7130=-8113 ///
 7139=-8113 7200=-7220 7210=-8121 7220=-8122 7230=-8123 7240=-8122 7250=-7211 7260=-8123 7270=-8124 7280=-8223 7290=-8120 ///
 7300=-8140 7310=-8141 7320=-8141 7321=-7421 7329=-8141 7330=-8142 7340=-8143 7400=-8150 7410=-8151 7420=-8152 7430=-8153 ///
 7440=-8154 7450=-8155 7490=-8159 7491=-6142 7499=-8159 7500=-8260 7510=-8261 7520=-8261 7530=-7432 7540=-8262 7541=-7432 ///
 7549=-8262 7550=-8262 7560=-8264 7590=-8260 7600=-7441 7610=-7441 7620=-7441 7700=-8270 7710=-8273 7711=-8273 7719=-8273 ///
 7720=-8276 7730=-7411 7731=-8271  7739=-7411  7740=-8270 7750=-8272 7760=-7412 7761=-7412 7769=-7412 7770=-8277 7780=-8278 ///
 7790=-8270 7799=-7411  7800=-8279 7810=-8279 7820=-8279 7830=-8279 7890=-8279 7900=-7433 7910=-7433 7911=-7433 7919=-7433 ///
 7920=-7434 7930=-7433 7940=-7435 7950=-7436 7960=-7437 0799=-2221  7990=-8269 8000=-7442 8010=-7442 8020=-7442 8030=-7442 ///
 8100=-7420 8110=-7422 8120=-8240 8190=-7420 8191=-7422 8199=-7422 8200=-7113 8300=-7220 8310=-7221 8311=-7221 8319=-7221 ///
 8320=-7222 8321=-7222 8329=-7222 8330=-7223 8331=-7223 8339=-7223 8340=-8211 8350=-7224 8350=-8211 8351=-8223 8359=-7224 ///
 8390=-7220 8400=-7230 8410=-7230 8411=-8281 8412=-7233 8419=-7230 8420=-7311 8421=-7311 8422=-7311 8429=-7311 8430=-7231 ///
 8431=-1314 8439=-7231 8440=-7232 8490=-7230 8491=-7231 8492=-7233 8493=-8280 8494=-7234 8499=-7230 8500=-7240 8510=-7241 ///
 8520=-7242 8530=-8282 8540=-7243 8550=-7137 8551=-7137 8559=-7137 8560=-7244 8570=-7245 8590=-7240 8600=-3130 8610=-3132 ///
 8620=-3139 8700=-7210 8710=-7136 8711=-7136 8719=-7136 8720=-7212 8730=-7213 8731=-7213 8732=-7213 8733=-7213 8739=-7213 ///
 8740=-7214 8800=-7313 8801=-7313 8809=-7313 8900=-7320 8910=-7322 8911=-7322 8919=-7322 8920=-7321 8930=-8131 8940=-7323 /// 
 8950=-7324 8990=-8130 9000=-8230 9010=-8230 9020=-8231 9100=-8253 9200=-7340 9210=-7341 9211=-7341 9219=-7341 9220=-8251 ///
 9230=-7342 9240=-7343 9250=-7343 9260=-7345 9270=-8224 9290=-7340 9300=-7241 9310=-7141 9311=-7141 9319=-7141 9390=-7142 ///
 9400=-7520 9410=-7312 9420=-7424 9430=-8212 9490=-7331 9491=-7331 9492=-7331 9493=-7331 9499=-8400 9500=-7120 9510=-7122 /// 
 9520=-7123 9530=-7131 9540=-7124 9541=-7124 9542=-7124 9549=-7124 9550=-7133 9551=-7133 9559=-7133 9560=-7134 9570=-7135 /// 
 9590=-7129 9591=-7129 9592=-7129 9593=-7129 9594=-7129 9595=-9313 9596=-7129 9599=-7141 9600=-8160 9610=-8161 9690=-8160 /// 
 9700=-9330 9710=-9333 9711=-9333 9712=-9151 9713=-9151 9714=-9322 9719=-9333 9720=-7215 9730=-8333 9731=-8333 9739=-8333 ///
 9740=-8332 9790=-8334 9800=-8320 9810=-8340 9811=-8340 9819=-8340 9820=-8162 9830=-8311 9831=-8311 9832=-8311 9839=-8311 /// 
 9839=-8311 9840=-8312 9850=-8320 9851=-8323 9852=-8324 9853=-8324 9854=-9333 9855=-3340 9859=-8322 9860=-9332 9861=-9332 ///
 9869=-9332 9890=-8320 9891=-8312 9899=-9331 9900=-9300 9950=-7520 9951=-7520 9959=-7520 9970=-8290 9971=-7530 9979=-8280 ///
 9990=-9300 9991=-9320 9992=-9320 9993=-9320 9994=-9312 9995=-9162 9996=-9161 9997=-9312 9999=-9300 if isco_68!=1

replace isco=-(occ88) if country==40 | country==724 | country==840 | country==578 |country==554  |country==276 
replace isco=. if occ88>0 & occ88!=.

gen isco_sweden= isco_nat if country==752 
replace isco_sweden= isco_nat if country==752 & isco_sweden==.

recode isco_sweden 981=-011 989=-011 211=-121 030=-122 102=-122 203=-122 942=-122 331=-131 014=-211 015=-211 016=-211 019=-211 262=-212 251=-213 021=-221 022=-221 101=-222 121=-222 141=-222 104=-223 032=-230 031=-231 034=-232 035=-232 033=-233 219=-241 221=-241 231=-241 239=-241 261=-241 311=-241 051=-242 052=-242 053=-242 054=-242 059=-242 091=-243 092=-243 069=-244 099=-244 061=-245 062=-245 063=-245 073=-245 075=-245 041=-246 201=-247 202=-247 269=-247 212=-248 151=-249 191=-249 001=-311 002=-311 003=-311 004=-311 005=-311 006=-311 007=-311 008=-311 009=-311 012=-311 252=-312  259=-312  074=-313 675=-313 744=-313 766=-313 601=-314 602=-314 603=-314 621=-314 662=-314 162=-315 023=-321 111=-322 122=-322 131=-322 149=-322 161=-322 169=-322 192=-322 743=-322 103=-323 105=-323 013=-324 036=-331 291=-341 292=-341 293=-341 312=-341 319=-341 321=-341 332=-341 222=-342 229=-342 296=-342 037=-343 209=-343 294=-344 904=-344 903=-345 049=-346 152=-346 199=-346 071=-347 076=-347 077=-347 119=-347 961=-347 241=-411 232=-412 297=-413 652=-413 661=-413 663=-413 664=-413 882=-413 681=-415 242=-419 249=-419 299=-419 671=-421 979=-421 295=-422 651=-422 653=-422 669=-422 673=-422 674=-422 915=-422 949=-422 916=-511 911=-512 912=-512 914=-512 919=-512 039=-513 106=-513 107=-513 109=-513 112=-513 123=-513 139=-513 153=-513 154=-513 155=-513 159=-513 941=-514 971=-514 691=-515 699=-515 901=-515 905=-515 906=-515 313=-522 333=-522 339=-522 399=-522 400=-610 402=-610 401=-611 403=-611 413=-611 405=-612 406=-612 409=-612 412=-612 414=-612 419=-612 404=-614 441=-614 449=-614 421=-615 431=-615 432=-615 439=-615 501=-711 775=-712 791=-712 793=-712 794=-712 799=-712 755=-713 761=-713 782=-713 795=-713 796=-713 931=-713 781=-714 783=-714 902=-714 909=-714 754=-721 756=-721 757=-721 736=-722 759=-722 612=-723 753=-723 762=-724 763=-724 764=-724 765=-724 741=-731 742=-731 745=-731 749=-731 853=-731 072=-732 746=-732 789=-732 812=-732 814=-732 819=-732 079=-733 801=-734 802=-734 822=-741 826=-741 776=-742 711=-743 712=-743 713=-743 714=-743 715=-743 721=-744 852=-744 511=-811 521=-811 531=-811 731=-812 732=-812 733=-812 735=-812 737=-812 739=-812 811=-813 813=-813 771=-814 772=-814 773=-814 841=-814 842=-814 831=-815 619=-816 861=-816 751=-821 832=-821 851=-821 854=-821 758=-822 805=-822 839=-822 833=-823 834=-823 835=-823 777=-824 803=-825 804=-825 809=-825 843=-825 701=-826 702=-826 703=-826 705=-826 706=-826 707=-826 709=-826 716=-826 719=-826 722=-826 723=-826 951=-826 952=-826 959=-826 821=-827 823=-827 824=-827 825=-827 827=-827 828=-827 829=-827 752=-828 769=-828 779=-828 859=-828 631=-831 642=-831 659=-831 640=-832 641=-832 649=-832 411=-833 509=-833 871=-833 872=-833 873=-833 611=-834 921=-912 929=-912 932=-912 913=-913 682=-914 689=-914 889=-914 939=-915 891=-919 029=-921 599=-931 849=-932 849=-932 643=-933 879=-933 881=-933 879=-933 881=-933 40=-246 200=-247 300=-241 999=. 999=.
replace isco_3=-(isco_sweden)

 gen isco_uk= isco_nat if country==826 

recode isco_uk 10=11 11=13 12=12 13=12 14=12 15=01 16=13 17=34 19=11 20=21 21=21 22=22 23=23 24=24 25=24 26=21 27=24 29=24 30=31 31=31 32=21 33=31 34=22 35=34 36=34 37=34 38=24 39=24 40=41 41=41 42=41 43=41 44=41 45=41 46=42 49=41 50=71 51=72 52=72 53=72 54=72 55=74 56=73 57=71 58=74 59=73 60=01 61=51 62=51 63=51 64=32 65=33 66=51 67=51 69=51 70=34 71=34 72=52 73=91 79=34 80=82 81=82 82=81 83=81 84=82 85=82 86=82 87=51 88=83 89=81 90=92 91=93 92=93 93=93 94=41 95=91 99=93 999=81
gen isco_uka=string(isco_uk)

gen isco_stringa=string(isco)
gen isco_stringb=string(isco_3)

 gen isco_3s=substr(isco_stringa, 1, 3)
destring isco_3s, replace
replace isco_3s=isco_3 if isco_3s==.
gen isco_combined=isco_3s
replace isco_combined=. if isco_combined==0
replace isco_combined=. if isco_combined==9999

gen isco_2=substr(isco_stringa, 1, 2)
gen isco_2a=substr(isco_stringb, 1, 2) 
replace isco_2=isco_2a if country==752
replace isco_2="" if isco==0
replace isco_2="" if isco_3==0
replace isco_2=isco_uka if country==826

merge m:1 isco_2 using "Occupation_GROUPS.dta"

}


drop v*
drop if country==.
save `temp95', replace
}

if `year_1996'==1 {
********
* 1996 *
********
set more off
use "ZA2900.dta", clear

local main_variables 1
local parties 1
local occupation_recode 1

if `main_variables'==1 {

gen case=v2
lab var case "Case ID Number"

gen YYYY=1996
lab var YYYY "Survey Year"

recode v325 0=., gen(weight)
lab val weight weight
lab var weight "Weight"

gen country=.
replace country=36 if v3==1
replace country=276 if v3==2
replace country=276 if v3==3
replace country=826 if v3==4
replace country=840 if v3==6
replace country=380 if v3==9
replace country=372 if v3==10
replace country=578 if v3==12
replace country=752 if v3==13
replace country=554 if v3==19
replace country=124 if v3==20
replace country=392 if v3==24
replace country=724 if v3==25
replace country=250 if v3==27
replace country=756 if v3==30
lab def country ///
	36 "Australia" ///
	124 "Canada" ///
	250 "France" ///
	276 "Germany" ///
	380 "Italy" ///
	372 "Ireland" ///
	392 "Japan" ///
	554 "New Zealand" ///
	578 "Norway" ///
	724 "Spain" ///
	752 "Sweden" ///
	756 "Switzerland" ///
	826 "UK" ///
	840 "USA" 
lab val country country
lab var country "Country"
tab country

gen east_germany=1 if v3==3


recode v200 0=., gen(sex)

gen age= v201
replace age=. if v201 ==99
gen birth=1996-age
label var birth "Year of Birth"

gen empl=.
replace empl=2 if v206==1
replace empl=2 if v206 ==2
replace empl=1 if v206 ==5
lab def empl ///
	1 "Unemployed" ///
	2 "Employed" 
lab val empl empl
lab var empl "Employment Status - 2"
tab empl

gen employee=.
replace employee =2 if v213 ==1
replace employee =1 if v213 ==2
lab def employee ///
	1 "Employed" ///
	2 "Self Employed" 
lab val employee employee
lab var employee "Employee"
tab employee

tab v206
recode v206 0=., gen(emplB)
lab def emplB ///
	1 "Employed FT" ///
	2 "Employed PT" ///
	3 "Less than PT" ///
	4 "Helping Family Member" ///
	5 "Unemployed" ///
	6 "Student" ///
	7 "Retired" ///
	8 "Housewife/man" ///
	9 "Perm. dis" ///
	10 "Not in LF" 
lab val emplB emplB
lab var emplB "Employment Status"
tab emplB

gen education=.
replace education=1 if v205==1
replace education=1 if v205==2
replace education=1 if v205==3
replace education=2 if v205==4
replace education=3 if v205==5
replace education=4 if v205==6
replace education=5 if v205==7
lab def education ///
	1 "Less than lower secondary" ///
	2 "Lower Secondary" ///
	3 "Upper Secondary" ///
	4 "Vocational" ///
	5 "Degree" 
lab val education education
lab var education "Education Collapsed"
tab education


}

if `parties'==1 {

gen party_type=.
replace party_type=2 if country==36
replace party_type=2 if country==124
replace party_type=2 if country==756
replace party_type=1 if country==276
replace party_type=2 if country==724
replace party_type=2 if country==250
replace party_type=1 if country==826
replace party_type=1 if country==380
replace party_type=1 if country==372
replace party_type=2 if country==392
replace party_type=2 if country==578
replace party_type=2 if country==554
replace party_type=2 if country==752
replace party_type=1 if country==840

gen party=.
replace party=1 if v224==1 & country==36 
replace party=2 if v224==2 & country==36 
replace party=3 if v224==3 & country==36 
replace party=4 if v224==4 & country==36 
replace party=6 if v224==6 & country==36 
replace party=7 if v224==5 & country==36 
replace party=97 if v224 ==96 & country ==36
replace party=99 if v224 ==.a & country ==36
replace party=99 if v224 ==.b & country ==36
replace party=96 if v224 ==95 & country ==36


replace party=1 if v226==1 & country==124 
replace party=2 if v226==2 & country== 124 
replace party=3 if v226==3 & country== 124 
replace party=4 if v226==4 & country== 124 
replace party=5 if v226==5 & country== 124 
replace party=6 if v226==6 & country== 124 
replace party=7 if v226==7 & country== 124 
replace party=8 if v226==8 & country== 124 
replace party=9 if v226==9 & country== 124 
replace party=97 if v226 ==96 & country == 124
replace party=99 if v226 ==.a & country ==124
replace party=99 if v226 ==.b & country ==124
replace party=96 if v226 ==95 & country == 124

replace party=v232 if country==250
replace party=97 if v232 ==96 & country == 250
replace party=99 if v232 ==.a & country ==250
replace party=99 if v232 ==.b & country ==250
replace party=96 if v232 ==95 & country == 250

replace party=1 if v230==2 & country==276 
replace party=2 if v230 ==1 & country== 276 
replace party=4 if v230 ==3 & country== 276 
replace party=5 if v230 ==4 & country== 276 
replace party=6 if v230 ==5 & country== 276 
replace party=7 if v230 ==6 & country== 276 
replace party=8 if v230 ==7 & country== 276 
replace party=9 if v230 ==8 & country== 276 
replace party=97 if v230 ==96 & country == 276
replace party=99 if v230 ==.a & country ==276
replace party=99 if v230 ==.b & country ==276
replace party=99 if v230 ==.c & country ==276
replace party=99 if v230 ==.d & country ==276
replace party=96 if v230 ==95 & country == 276



replace party=1 if v237==1 & country==372 
replace party=2 if v237 ==2 & country== 372 
replace party=3 if v237 ==3 & country== 372 
replace party=4 if v237 ==4 & country== 372 
replace party=5 if v237 ==5 & country== 372 
replace party=6 if v237 ==6 & country== 372 
replace party=7 if v237 ==7 & country== 372 
replace party=8 if v237 ==8 & country== 372 
replace party=97 if v237 ==96 & country == 372
replace party=99 if v230 ==.a & country ==372
replace party=99 if v230 ==.b & country ==372
replace party=99 if v230 ==.c & country ==372
replace party=96 if v237 ==95 & country == 372


replace party=15 if v259==1 & country==380 
replace party=16 if v259 ==2 & country== 380 
replace party=17 if v259 ==3 & country== 380 
replace party=18 if v259 ==4 & country== 380 
replace party=19 if v259 ==5 & country== 380 
replace party=11 if v259 ==6 & country== 380 
replace party=20 if v259 ==7 & country== 380 
replace party=21 if v259 ==8 & country== 380 
replace party=22 if v259 ==9 & country== 380 
replace party=23 if v259 ==10 & country== 380 
replace party=12 if v259 ==11 & country== 380 
replace party=14 if v259 ==12 & country== 380 
replace party=96 if v259 ==94 & country == 380
replace party=96 if v259 ==95 & country == 380
replace party=97 if v259 ==96 & country == 380
replace party=99 if v259 ==.a & country ==380
replace party=99 if v259 ==.b & country ==380
replace party=99 if v259 ==.c & country ==380



replace party=1 if v238==1 & country==392 
replace party=2 if v238 ==3 & country== 392 
replace party=4 if v238 ==5 & country== 392 
replace party=5 if v238 ==4 & country== 392 
replace party=7 if v238 ==2 & country== 392 
replace party=8 if v238 ==4 & country== 392 
replace party=96 if v238 ==95 & country == 392
replace party=97 if v238 ==96 & country == 392
replace party=99 if v238 ==.a & country ==392
replace party=99 if v238 ==.b & country ==392
replace party=99 if v238 ==.c & country ==392

replace party=2 if v241 ==2 & country== 554 
replace party=3 if v241 ==3 & country== 554 
replace party=9 if v241 ==4 & country== 554 
replace party=11 if v241 ==1 & country== 554 
replace party=96 if v241 ==95 & country == 554
replace party=97 if v241 ==96 & country == 554
replace party=99 if v241 ==.a & country ==554
replace party=99 if v241 ==.b & country ==554
replace party=99 if v241 ==.c & country ==554

replace party=1 if v240==3 & country==578 
replace party=2 if v240 ==4 & country== 578 
replace party=3 if v240 ==6 & country== 578 
replace party=4 if v240 ==5 & country== 578 
replace party=5 if v240 ==8 & country== 578 
replace party=6 if v240 ==2 & country== 578 
replace party=7 if v240 ==7 & country== 578 
replace party=10 if v240 ==1 & country== 578 
replace party=96 if v240 ==95 & country == 578
replace party=97 if v240 ==96 & country == 578
replace party=99 if v240 ==.a & country ==578
replace party=99 if v240 ==.b & country ==578
replace party=99 if v240 ==.c & country ==578

replace party=1 if v255==3 & country==724 
replace party=2 if v255 ==1 & country== 724 
replace party=3 if v255 ==4 & country== 724 
replace party=4 if v255 ==2 & country== 724 
replace party=5 if v255 ==7 & country== 724 
replace party=5 if v255 ==8 & country== 724 
replace party=5 if v255 ==12 & country== 724 
replace party=5 if v255 ==13 & country== 724 
replace party=5 if v255 ==14 & country== 724 
replace party=6 if v255 ==5 & country== 724 
replace party=6 if v255 ==6 & country== 724 
replace party=6 if v255 ==9 & country== 724 
replace party=6 if v255 ==10 & country== 724 
replace party=6 if v255 ==11 & country== 724 
replace party=96 if v255 ==94 & country == 724
replace party=96 if v255 ==95 & country == 724
replace party=97 if v255 ==96 & country == 724
replace party=99 if v255 ==.a & country ==724
replace party=99 if v255 ==.b & country ==724
replace party=99 if v255 ==.c & country ==724

replace party=1 if v245==1 & country==752 
replace party=2 if v245 ==2 & country== 752 
replace party=3 if v245 ==3 & country== 752 
replace party=4 if v245 ==4 & country== 752 
replace party=5 if v245 ==5 & country== 752 
replace party=6 if v245 ==6 & country== 752 
replace party=7 if v245 ==7 & country== 752 
replace party=96 if v245 ==95 & country == 752
replace party=97 if v245 ==96 & country == 752
replace party=99 if v245 ==.a & country ==752
replace party=99 if v245 ==.b & country ==752
replace party=99 if v245 ==.c & country ==752

replace party=1 if v227==1 & country==756 
replace party=2 if v227 ==2 & country== 756 
replace party=3 if v227 ==3 & country== 756 
replace party=4 if v227 ==4 & country== 756 
replace party=5 if v227 ==5 & country== 756 
replace party=13 if v227 ==6 & country== 756 
replace party=7 if v227 ==7 & country== 756 
replace party=14 if v227 ==8 & country== 756 
replace party=8 if v227 ==9 & country== 756 
replace party=10 if v227 ==10 & country== 756 
replace party=20 if v227 ==11 & country== 756
replace party=15 if v227 ==12 & country== 756  
replace party=6 if v227 ==13 & country== 756 
replace party=12 if v227 ==14 & country== 756 
replace party=16 if v227 ==15 & country== 756 
replace party=96 if v227 ==95 & country == 756
replace party=97 if v227 ==96 & country == 756
replace party=99 if v227 ==.a & country ==756
replace party=99 if v227 ==.b & country ==756
replace party=99 if v227 ==.c & country ==756

replace party=1 if v233==1 & country==826 
replace party=2 if v233 ==2 & country== 826 
replace party=3 if v233 ==3 & country== 826 
replace party=4 if v233 ==6 & country== 826 
replace party=5 if v233 ==7 & country== 826 
replace party=96 if v233 ==95 & country == 826
replace party=97 if v233 ==96 & country == 826
replace party=99 if v233 ==.a & country ==826
replace party=99 if v233 ==.b & country ==826
replace party=99 if v233 ==.c & country ==826


replace party=v247 if country == 840
replace party=99 if v247 ==95 & country == 840
replace party=99 if v247 ==.a & country ==840
replace party=99 if v247 ==.b & country ==840
replace party=99 if v247 ==.c & country ==840


lab val party party
lab var party "Party Choice"
tab party

 }
 
if `occupation_recode'==1 {
recode v208 0=., gen(occup96)
lab val occup96 occup96
lab var occup96 "Occupation"

recode v208 0=., gen(occupN96)
lab val occupN96 occupN96
lab var occupN96 "Occupation National"

gen isco=v208
replace isco=. if country==578
replace isco=. if country==724
replace isco=. if country==840

gen isco_6896=v208 if country==578
replace isco_6896=v208 if country==724
replace isco_6896=v208 if country==840

gen isco_nat=v209
gen isco_3=.

gen isco88=v208 if country==36 | country==276 | country==554 | country==756 ///
| country==372 | country==124 | country==250 

*Some occupational recoding draws on the work of Cusack, Iversen, and Rehm and Iversen and Soskice 2001,
*http://www.people.fas.harvard.edu/~iversen/SkillSpecificity.htm* 

gen occ88=isco_6896 if isco_68!=1
recode occ88 0100=-2110 0110=-2113 0120=-2111 0131=-2114 0132=-2111 0133=-2112 0140=-3111 0200=-2140 ///
 0210=-2141 0220=-2142 0230=-2143 0240=-2145 0250=-2146 0260=-2147 0270=-2147 0280=-2149 0290=-2149 0300=-3110 ///
 0310=-2148 0320=-3118 0321=-3118 0329=-3118 0330=-3112 0340=-3113 0340=-3114 0350=-3115 0360=-3116 ///
 0370=-3117 0380=-3117 0390=-3119 0400=-3140 0410=-3143 0411=-3143 0419=-3143 0420=-3142 0421=-3142 ///
 0429=-3142 0430=-3141 0500=-2210 0510=-2211 0520=-2212 0521=-2212 0529=-2212 0530=-2213 0531=-3213 ///
 0539=-2213 0540=-3211 0541=-3212 0549=-3211 0600=-2221 0610=-2221 0611=-2221 0619=-2221 0620=-3221 ///
 0630=-2222 0640=-3225 0650=-2223 0660=-3227 0670=-2224 0680=-3228 0690=-3223 0700=-2230 0710=-2230 ///
 0711=-2230 0719=-2230 0720=-3231 0730=-2230 0740=-3232 0750=-3224 0751=-3224 0759=-3224 0760=-3226 ///
 0761=-3226 0762=-3226 0769=-3226 0770=-3133 0780=-3220 0790=-3229 0791=-3226 0792=-3241 0793=-3222 ///
 0799=-2226  0800=-2120 0810=-2122 0820=-2121 0830=-2131 0840=-3434 0849=-2132 0900=-2441 1100=-2411 ///
 1101=-2411 1109=-2411 1200=-2420 1210=-2421 1211=-2421 1219=-2421 1220=-2422 1221=-2422 1222=-2422 ///
 1229=-2422 1290=-2429 1291=-2429 1299=-2429 0130=-2110  1300=-2300 1310=-2310 1311=-1229 1319=-2310 ///
 1320=-2321 1321=-2323 1329=-2321 1330=-2331 1340=-2332 1350=-2340 1390=-2359 1391=-1229 1392=-2352 ///
 1393=-3300 1394=-1229 1399=-2322 1400=-2460 1410=-2460 1411=-2460 1412=-3480 1413=-2460 1414=-2460 ///
 1415=-2460 1416=-3480 1419=-2460  1490=-3480 1491=-3242 1499=-3480 1500=-2451 1510=-2451 1511=-2451 ///
 1519=-2451 1590=-2451 1591=-2451 1592=-2451 1593=-2419 1599=-2451  1600=-2450 1610=-2452 1620=-3471 ///
 1621=-3471 1622=-3471 1629=-3471 1630=-3131 1631=-3131 1639=-3131 1700=-3470 1710=-3473 1711=-2453 ///
 1712=-3473 1713=-3473 1719=-2453  1720=-3473 1721=-2454 1729=-3473 1730=-2455 1731=-2455 1732=-2455 ///
 1739=-2455 1740=-1229 1749=-1229 1750=-3474 1790=-3470 1791=-3473 1799=-3472 1800=-3475 1801=-3475 ///
 1809=-3475 1900=-2400 1910=-2432 1920=-2442 1921=-2445 1922=-2443 1923=-2443 1924=-2442 1929=-2442 1930=-2446 1931=-3460 ///
 1939=-2446 1940=-2412 1941=-2412 1949=-1232 1950=-2444 1951=-2444 1959=-2444 1960=-2000 1990=-3400 1991=-5150 1992=-3450 ///
 1993=-5113 1994=-3340 1995=-3429 1999=-3100 20=1100 2000=-1110 2010=-1100 2011=-1120 2012=-1120 2013=-1120 2014=-1120 ///
 2015=-1130 2020=-1110 2021=-1110 2022=-1110 2023=-1110 2024=-1110 2029=-1110 2030=-1120 2031=-1120 2032=-1120 2033=-1120 ///
 2034=-1120 2035=-1120 2036=-1130 2039=-1120 2100=-1300 2110=-1200 2110=-1200 2111=-1210 2112=-1210 2113=-1319 2114=-1227 ///
 2115=-1227 2116=-1313 2119=-1210 2119=-1210 2120=-1220 2190=-1220 2191=-1230 2192=-1230 2193=-1230 2194=-1230 2195=-1141 ///
 2196=-1142 2197=-1142 2199=-1227 3000=-1231 3009=-1240 3100=-3440 3101=-3440 3102=-3444 3103=-3441 3104=-3442 3109=-3440 ///
 3200=-4110 3210=-4111 3211=-4115 3219=-4111 3220=-4113 3300=-3430 3310=-3433 3311=-4211 3312=-4211 3313=-4212 3314=-4212 ///
 3315=-4211 3319=-3433 3390=-4120 3391=-4215 3399=-4121 3400=-3120 3410=-4114 3420=-3122 3500=-4133 3510=-1226 3520=-1226 ///
 3590=-4133 3600=-5112 3601=-5112 3602=-5112 3609=-5112 3700=-4142 3701=-9151 3709=-4142 3800=-4223 3801=-3132 3802=-3132 ///
 3809=-4223 3900=-4100 3910=-4131 3911=-4131 3919=-4131 3920=-4132 3930=-4100 3931=-4100 3932=-3432 3939=-4100 3940=-4222 ///
 3941=-4233 3942=-4131 3943=-3414 3949=-4222 3950=-4141 3951=-4141 3959=-4141 3990=-4190 3991=-4143  3992=-1141 3993=-9153 ///
 3999=-4143 4000=-1314 4001=-1217  4002=-1231  4009=-1314 4100=-1314 4101=-1224 4102=-5230 4103=-1224 4104=-3421 4105=-3421  ///
 4106=-1314 4107=-9333 4108=-3423 4109=-1314 4200=-1233 4210=-1233 4220=-3416 4221=-3416 4222=-3416 4229=-3416 4300=-3415 /// 
 4310=-3415 4311=-3415 4319=-3415 4320=-3415 4400=-3410 4410=-3412 4411=-3413 4412=-3411 4419=-3412 4420=-3429 4430=-3417 ///
 4431=-3417 4432=-3417 4500=-5200 4510=-5220 4511=-5220 4512=-5220 4513=-5210 4514=-5220 4519=-5220 4520=-9110 4521=-9110 ///
 4522=-9113 4523=-9112 4524=-9113 4525=-9110 4529=-5230 4900=-5200 5000=-1315 5001=-1315 5002=-1225 5009=-1225 5100=-1315 ///
 5100=-5000 5101=-1315 5102=-1315 5103=-1315 5104=-1315 5109=-1315 5200=-5121 5201=-5121 5209=-5121 5300=-5120 5310=-5122 ///
 5311=-5122 5312=-9132 5319=-5122 5320=-5123 5321=-5123 5322=-5123 5329=-5123 5400=-9130 5401=-5131 5402=-9132 5403=-9152 ///
 5409=-5142 5500=-9140 5510=-9141 5511=-9141 5512=-9141 5519=-9141 5520=-9132 5521=-9142 5522=-7143 5529=-9132 5600=-8264 ///
 5700=-5141 5701=-5141 5702=-5141 5703=-5141 5709=-5141 5800=-5160 5810=-5161 5820=-5162 5821=-3451 5822=-1229 5823=-1229 ///
 5829=-5162 5830=-5164 5831=-1229 5832=-3452 5833=-5164 5890=-5169 5891=-5163 5892=-3432 5899=-9152 5900=-5100 5910=-5113 ///
 5920=-5143 5990=-5100 5991=-9152 5992=-9151 5993=-9151 5994=-9152 5995=-9120 5996=-5111 5997=-4213 5998=-9151 5999=-5132 ///
 6000=-1311 6001=-6132 6009=-1311 6100=-6133 6110=-6133 6111=-1311 6112=-6210 6113=-6133 6114=-6133 6115=-6130 6116=-6130 ///
 6117=-9211 6119=-6133 6120=-6130 6200=-9211 6210=-9211 6211=-9211 6219=-9211 6220=-9211 6230=-9211 6239=-9211 6240=-9211 ///
 6240=-9211 6250=-9211 6260=-9211 6270=-9211 6280=-8331 6290=-9211 6290=-9200 6291=-9211 6299=-6100 6300=-9212 6310=-6141 ///
 6311=-6141 6319=-6141 6320=-9142  6329=-6141  6400=-6150 6410=-6150 6411=-6150 6419=-6150 6490=-6150 6491=-6154 6499=-9213 ///
 7000=-7510 7001=-7510 7009=-7510 7100=-7110 7110=-7111 7111=-7111 7112=-7111 7113=-7111 7119=-7111 7120=-8112 7130=-8113 ///
 7139=-8113 7200=-7220 7210=-8121 7220=-8122 7230=-8123 7240=-8122 7250=-7211 7260=-8123 7270=-8124 7280=-8223 7290=-8120 ///
 7300=-8140 7310=-8141 7320=-8141 7321=-7421 7329=-8141 7330=-8142 7340=-8143 7400=-8150 7410=-8151 7420=-8152 7430=-8153 ///
 7440=-8154 7450=-8155 7490=-8159 7491=-6142 7499=-8159 7500=-8260 7510=-8261 7520=-8261 7530=-7432 7540=-8262 7541=-7432 ///
 7549=-8262 7550=-8262 7560=-8264 7590=-8260 7600=-7441 7610=-7441 7620=-7441 7700=-8270 7710=-8273 7711=-8273 7719=-8273 ///
 7720=-8276 7730=-7411 7731=-8271  7739=-7411  7740=-8270 7750=-8272 7760=-7412 7761=-7412 7769=-7412 7770=-8277 7780=-8278 ///
 7790=-8270 7799=-7411  7800=-8279 7810=-8279 7820=-8279 7830=-8279 7890=-8279 7900=-7433 7910=-7433 7911=-7433 7919=-7433 ///
 7920=-7434 7930=-7433 7940=-7435 7950=-7436 7960=-7437 0799=-2221  7990=-8269 8000=-7442 8010=-7442 8020=-7442 8030=-7442 ///
 8100=-7420 8110=-7422 8120=-8240 8190=-7420 8191=-7422 8199=-7422 8200=-7113 8300=-7220 8310=-7221 8311=-7221 8319=-7221 ///
 8320=-7222 8321=-7222 8329=-7222 8330=-7223 8331=-7223 8339=-7223 8340=-8211 8350=-7224 8350=-8211 8351=-8223 8359=-7224 ///
 8390=-7220 8400=-7230 8410=-7230 8411=-8281 8412=-7233 8419=-7230 8420=-7311 8421=-7311 8422=-7311 8429=-7311 8430=-7231 ///
 8431=-1314 8439=-7231 8440=-7232 8490=-7230 8491=-7231 8492=-7233 8493=-8280 8494=-7234 8499=-7230 8500=-7240 8510=-7241 ///
 8520=-7242 8530=-8282 8540=-7243 8550=-7137 8551=-7137 8559=-7137 8560=-7244 8570=-7245 8590=-7240 8600=-3130 8610=-3132 ///
 8620=-3139 8700=-7210 8710=-7136 8711=-7136 8719=-7136 8720=-7212 8730=-7213 8731=-7213 8732=-7213 8733=-7213 8739=-7213 ///
 8740=-7214 8800=-7313 8801=-7313 8809=-7313 8900=-7320 8910=-7322 8911=-7322 8919=-7322 8920=-7321 8930=-8131 8940=-7323 /// 
 8950=-7324 8990=-8130 9000=-8230 9010=-8230 9020=-8231 9100=-8253 9200=-7340 9210=-7341 9211=-7341 9219=-7341 9220=-8251 ///
 9230=-7342 9240=-7343 9250=-7343 9260=-7345 9270=-8224 9290=-7340 9300=-7241 9310=-7141 9311=-7141 9319=-7141 9390=-7142 ///
 9400=-7520 9410=-7312 9420=-7424 9430=-8212 9490=-7331 9491=-7331 9492=-7331 9493=-7331 9499=-8400 9500=-7120 9510=-7122 /// 
 9520=-7123 9530=-7131 9540=-7124 9541=-7124 9542=-7124 9549=-7124 9550=-7133 9551=-7133 9559=-7133 9560=-7134 9570=-7135 /// 
 9590=-7129 9591=-7129 9592=-7129 9593=-7129 9594=-7129 9595=-9313 9596=-7129 9599=-7141 9600=-8160 9610=-8161 9690=-8160 /// 
 9700=-9330 9710=-9333 9711=-9333 9712=-9151 9713=-9151 9714=-9322 9719=-9333 9720=-7215 9730=-8333 9731=-8333 9739=-8333 ///
 9740=-8332 9790=-8334 9800=-8320 9810=-8340 9811=-8340 9819=-8340 9820=-8162 9830=-8311 9831=-8311 9832=-8311 9839=-8311 /// 
 9839=-8311 9840=-8312 9850=-8320 9851=-8323 9852=-8324 9853=-8324 9854=-9333 9855=-3340 9859=-8322 9860=-9332 9861=-9332 ///
 9869=-9332 9890=-8320 9891=-8312 9899=-9331 9900=-9300 9950=-7520 9951=-7520 9959=-7520 9970=-8290 9971=-7530 9979=-8280 ///
 9990=-9300 9991=-9320 9992=-9320 9993=-9320 9994=-9312 9995=-9162 9996=-9161 9997=-9312 9999=-9300 if isco_68!=1

replace isco=-(occ88) if country==578 | country==724 | country==840 
replace isco=. if occ88>0 & occ88!=.

gen isco_sweden= isco_nat if country==752 
replace isco_sweden= isco_nat if country==752 & isco_sweden==.

recode isco_sweden 981=-011 989=-011 211=-121 030=-122 102=-122 203=-122 942=-122 331=-131 014=-211 015=-211 016=-211 019=-211 262=-212 251=-213 021=-221 022=-221 101=-222 121=-222 141=-222 104=-223 032=-230 031=-231 034=-232 035=-232 033=-233 219=-241 221=-241 231=-241 239=-241 261=-241 311=-241 051=-242 052=-242 053=-242 054=-242 059=-242 091=-243 092=-243 069=-244 099=-244 061=-245 062=-245 063=-245 073=-245 075=-245 041=-246 201=-247 202=-247 269=-247 212=-248 151=-249 191=-249 001=-311 002=-311 003=-311 004=-311 005=-311 006=-311 007=-311 008=-311 009=-311 012=-311 252=-312  259=-312  074=-313 675=-313 744=-313 766=-313 601=-314 602=-314 603=-314 621=-314 662=-314 162=-315 023=-321 111=-322 122=-322 131=-322 149=-322 161=-322 169=-322 192=-322 743=-322 103=-323 105=-323 013=-324 036=-331 291=-341 292=-341 293=-341 312=-341 319=-341 321=-341 332=-341 222=-342 229=-342 296=-342 037=-343 209=-343 294=-344 904=-344 903=-345 049=-346 152=-346 199=-346 071=-347 076=-347 077=-347 119=-347 961=-347 241=-411 232=-412 297=-413 652=-413 661=-413 663=-413 664=-413 882=-413 681=-415 242=-419 249=-419 299=-419 671=-421 979=-421 295=-422 651=-422 653=-422 669=-422 673=-422 674=-422 915=-422 949=-422 916=-511 911=-512 912=-512 914=-512 919=-512 039=-513 106=-513 107=-513 109=-513 112=-513 123=-513 139=-513 153=-513 154=-513 155=-513 159=-513 941=-514 971=-514 691=-515 699=-515 901=-515 905=-515 906=-515 313=-522 333=-522 339=-522 399=-522 400=-610 402=-610 401=-611 403=-611 413=-611 405=-612 406=-612 409=-612 412=-612 414=-612 419=-612 404=-614 441=-614 449=-614 421=-615 431=-615 432=-615 439=-615 501=-711 775=-712 791=-712 793=-712 794=-712 799=-712 755=-713 761=-713 782=-713 795=-713 796=-713 931=-713 781=-714 783=-714 902=-714 909=-714 754=-721 756=-721 757=-721 736=-722 759=-722 612=-723 753=-723 762=-724 763=-724 764=-724 765=-724 741=-731 742=-731 745=-731 749=-731 853=-731 072=-732 746=-732 789=-732 812=-732 814=-732 819=-732 079=-733 801=-734 802=-734 822=-741 826=-741 776=-742 711=-743 712=-743 713=-743 714=-743 715=-743 721=-744 852=-744 511=-811 521=-811 531=-811 731=-812 732=-812 733=-812 735=-812 737=-812 739=-812 811=-813 813=-813 771=-814 772=-814 773=-814 841=-814 842=-814 831=-815 619=-816 861=-816 751=-821 832=-821 851=-821 854=-821 758=-822 805=-822 839=-822 833=-823 834=-823 835=-823 777=-824 803=-825 804=-825 809=-825 843=-825 701=-826 702=-826 703=-826 705=-826 706=-826 707=-826 709=-826 716=-826 719=-826 722=-826 723=-826 951=-826 952=-826 959=-826 821=-827 823=-827 824=-827 825=-827 827=-827 828=-827 829=-827 752=-828 769=-828 779=-828 859=-828 631=-831 642=-831 659=-831 640=-832 641=-832 649=-832 411=-833 509=-833 871=-833 872=-833 873=-833 611=-834 921=-912 929=-912 932=-912 913=-913 682=-914 689=-914 889=-914 939=-915 891=-919 029=-921 599=-931 849=-932 849=-932 643=-933 879=-933 881=-933 879=-933 881=-933 40=-246 200=-247 300=-241 999=. 999=.
replace isco_3=-(isco_sweden)

 gen isco_uk= isco_nat if country==826 

recode isco_uk 10=11 11=13 12=12 13=12 14=12 15=01 16=13 17=34 19=11 20=21 21=21 22=22 23=23 24=24 25=24 26=21 27=24 29=24 30=31 31=31 32=21 33=31 34=22 35=34 36=34 37=34 38=24 39=24 40=41 41=41 42=41 43=41 44=41 45=41 46=42 49=41 50=71 51=72 52=72 53=72 54=72 55=74 56=73 57=71 58=74 59=73 60=01 61=51 62=51 63=51 64=32 65=33 66=51 67=51 69=51 70=34 71=34 72=52 73=91 79=34 80=82 81=82 82=81 83=81 84=82 85=82 86=82 87=51 88=83 89=81 90=92 91=93 92=93 93=93 94=41 95=91 99=93 999=81
gen isco_uka=string(isco_uk)


gen isco_stringa=string(isco)
gen isco_stringb=string(isco_3)

 gen isco_3s=substr(isco_stringa, 1, 3)
destring isco_3s, replace
replace isco_3s=isco_3 if isco_3s==.
gen isco_combined=isco_3s
replace isco_combined=. if isco_combined==0
replace isco_combined=. if isco_combined==9999

gen isco_2=substr(isco_stringa, 1, 2)
gen isco_2a=substr(isco_stringb, 1, 2) 
replace isco_2=isco_2a if country==752
replace isco_2="" if isco==0
replace isco_2="" if isco_3==0
replace isco_2=isco_uka if country==826

merge m:1 isco_2 using "Occupation_GROUPS.dta"
drop _merge
 } 
 

drop v*
drop if country==.

save `temp96', replace
}
if `year_1997'==1 {
********
* 1997 *
********
use "ZA3090.dta", clear
set more off
local main_variables 1
local parties 1
local occupation_recode 1

if `main_variables'==1 {
gen case=v2
lab var case "Case ID Number"


gen YYYY=1997
lab var YYYY "Survey Year"

recode weight 0=.
lab val weight weight
lab var weight "Weight"

gen country=.
replace country=36 if v3==1
replace country=276 if v3==2
replace country=276 if v3==3
replace country=826 if v3==4
replace country=840 if v3==6
replace country=380 if v3==9
replace country=372 if v3==10
replace country=528 if v3==11
replace country=578 if v3==12
replace country=752 if v3==13
replace country=554 if v3==19
replace country=124 if v3==20
replace country=392 if v3==24
replace country=724 if v3==25
replace country=250 if v3==27
replace country=620 if v3==29
replace country=208 if v3==30
replace country=756 if v3==31
lab def country ///
	36 "Australia" ///
	124 "Canada" ///
	208 "Denmark" ///
	250 "France" ///
	276 "Germany" ///
	380 "Italy" ///
	372 "Ireland" ///
	392 "Japan" ///
	528 "Netherlands" ///
	554 "New Zealand" ///
	578 "Norway" ///
	620 "Portugal" ///
	724 "Spain" ///
	752 "Sweden" ///
	756 "Switzerland" ///
	826 "UK" ///
	840 "USA" 
lab val country country
lab var country "Country"
tab country

gen east_germany=1 if v3==3

recode sex 9=.

replace age=. if age ==99
gen birth=1997-age
label var birth "Year of Birth"

gen empl=.
replace empl=2 if wrkst==1
replace empl=2 if wrkst ==2
replace empl=1 if wrkst ==5
lab def empl ///
	1 "Unemployed" ///
	2 "Employed" 
lab val empl empl
lab var empl "Employment Status - 2"
tab empl

gen employee=.
replace employee =2 if selfemp ==1
replace employee =1 if selfemp ==2
lab def employee ///
	1 "Employed" ///
	2 "Self Employed" 
lab val employee employee
lab var employee "Employee"
tab employee

tab wrkst
recode wrkst 0=. 99=., gen(emplB)
lab def emplB ///
	1 "Employed FT" ///
	2 "Employed PT" ///
	3 "Less than PT" ///
	4 "Helping Family Member" ///
	5 "Unemployed" ///
	6 "Student" ///
	7 "Retired" ///
	8 "Housewife/man" ///
	9 "Perm. dis" ///
	10 "Not in LF" 
lab val emplB emplB
lab var emplB "Employment Status"
tab emplB

gen education=.
replace education=1 if degree==1
replace education=1 if degree==2
replace education=1 if degree==3
replace education=2 if degree==4
replace education=3 if degree==5
replace education=4 if degree==6
replace education=5 if degree==7
lab def education ///
	1 "Less than lower secondary" ///
	2 "Lower Secondary" ///
	3 "Upper Secondary" ///
	4 "Vocational" ///
	5 "Degree" 
lab val education education
lab var education "Education Collapsed"
tab education

}
if `parties'==1 {

gen party_type=.
replace party_type=2 if country==124
replace party_type=2 if country==756
replace party_type=2 if country==276
replace party_type=3 if country==208 /**/
replace party_type=2 if country==724
replace party_type=2 if country==250
replace party_type=2 if country==826
replace party_type=1 if country==380
replace party_type=2 if country==578
replace party_type=1 if country==528
replace party_type=2 if country==554
replace party_type=2 if country==620
replace party_type=2 if country==752
replace party_type=1 if country==840


gen party=.

*Canada*
replace party=4 if cdn_prty==1 & country==124 
replace party=1 if cdn_prty==2 & country== 124 
replace party=2 if cdn_prty==3 & country== 124 
replace party=3 if cdn_prty==4 & country== 124 
replace party=4 if cdn_prty==5 & country== 124 
replace party=96 if cdn_prty==8 & country== 124 
replace party=97 if cdn_prty==9 & country== 124 
replace party=99 if cdn_prty==99 & country== 124 
replace party=99 if cdn_prty==. & country== 124 

*Denmark*

replace party=dk_prty if country==208 
replace party=7 if dk_prty==6 & country== 208 
replace party=9 if dk_prty==7 & country== 208 
replace party=10 if dk_prty==8 & country== 208 
replace party=11 if dk_prty==9 & country== 208 
replace party=96 if dk_prty==10 & country== 208 
replace party=97 if dk_prty==11 & country== 208 
replace party=99 if dk_prty>=12 & dk_prty<=14  & country== 208 
replace party=99 if dk_prty ==. & country == 208

replace party=f_prty if country==250
replace party=96 if f_prty ==8 & country == 250
replace party=97 if f_prty ==9 & country == 250
replace party=99 if f_prty ==. & country == 250

replace party=1 if d_prty==2 & country==276 
replace party=2 if d_prty ==1 & country== 276 
replace party=4 if d_prty ==3 & country== 276 
replace party=5 if d_prty ==4 & country== 276 
replace party=8 if d_prty ==7 & country== 276 
replace party=9 if d_prty ==8 & country== 276 
replace party=96 if d_prty ==95 & country == 276
replace party=97 if d_prty ==96 & country == 276
replace party=99 if d_prty ==99 & country == 276
replace party=99 if d_prty ==98 & country == 276
replace party=99 if d_prty ==. & country == 276




replace party=14 if i_prty==1 & country==380 
replace party=12 if i_prty ==2 & country== 380 
replace party=22 if i_prty ==3 & country== 380 
replace party=23 if i_prty ==4 & country== 380 
replace party=21 if i_prty ==5 & country== 380 
replace party=28 if i_prty ==6 & country== 380 
replace party=29 if i_prty ==7 & country== 380 
replace party=11 if i_prty ==8 & country== 380 
replace party=18 if i_prty ==9 & country== 380 
replace party=18 if i_prty ==10 & country== 380 
replace party=19 if i_prty ==11 & country== 380 
replace party=17 if i_prty ==12 & country== 380 
replace party=16 if i_prty ==13 & country== 380 
replace party=1 if i_prty ==14 & country== 380 
replace party=96 if i_prty ==15 & country== 380 
replace party=97 if i_prty ==16 & country == 380
replace party=99 if i_prty ==. & country == 380


replace party=10 if n_prty ==1 & country== 578 
replace party=6 if n_prty ==2 & country== 578 
replace party=1 if n_prty ==3 & country== 578 
replace party=2 if n_prty ==4 & country== 578 
replace party=4 if n_prty ==5 & country== 578 
replace party=3 if n_prty ==6 & country== 578 
replace party=7 if n_prty ==7 & country== 578 
replace party=5 if n_prty ==8 & country== 578 
replace party=96 if n_prty ==95 & country == 578
replace party=97 if n_prty ==96 & country == 578
replace party=99 if n_prty ==. & country == 578


replace party=1 if nl_prty ==1 & country== 528 
replace party=2 if nl_prty ==2 & country== 528 
replace party=3 if nl_prty ==6 & country== 528 
replace party=4 if nl_prty ==8 & country== 528 
replace party=5 if nl_prty ==13 & country== 528 
replace party=6 if nl_prty ==14 & country== 528 
replace party=7 if nl_prty ==15 & country== 528 
replace party=8 if nl_prty ==25 & country== 528 
replace party=9 if nl_prty ==28 & country== 528 
replace party=10 if nl_prty ==29 & country== 528 
replace party=11 if nl_prty ==30 & country== 528 
replace party=11 if nl_prty ==31 & country== 528 
replace party=99 if nl_prty ==18 & country== 528 
replace party=96 if nl_prty ==19 & country== 528 
replace party=99 if nl_prty ==20 & country== 528 
replace party=96 if nl_prty ==21 & country== 528 
replace party=99 if nl_prty ==. & country== 528 

replace party=11 if nz_prty ==1 & country== 554 
replace party=2 if nz_prty ==2 & country== 554 
replace party=3 if nz_prty ==3 & country== 554 
replace party=9 if nz_prty ==4 & country== 554 
replace party=96 if nz_prty ==5 & country== 554 
replace party=97 if nz_prty ==6 & country== 554 
replace party=99 if nz_prty ==8 & country== 554 
replace party=99 if nz_prty ==. & country== 554

replace party=p_prty if country== 620   
replace party=96 if p_prty ==8 & country== 620 
replace party=97 if p_prty ==9 & country== 620 
replace party=99 if p_prty ==10 & country== 620 
replace party=99 if p_prty ==. & country== 620


replace party=e_prty if  country== 724 
replace party=96 if e_prty ==8 & country== 724 
replace party=96 if e_prty ==9 & country== 724 
replace party=97 if e_prty ==10 & country== 724 
replace party=99 if e_prty ==11 & country== 724 
replace party=99 if e_prty ==12 & country== 724 
replace party=99 if e_prty ==. & country== 724


replace party=s_prty if country==752 
replace party=96 if s_prty ==95 & country== 752 
replace party=97 if s_prty ==96 & country== 752 
replace party=99 if s_prty ==. & country== 752

replace party=ch_prty if  country==756 & ch_prty<=5
replace party=13 if ch_prty ==6 & country== 756 
replace party=7 if ch_prty ==7 & country== 756 
replace party=14 if ch_prty ==8 & country== 756 
replace party=8 if ch_prty ==9 & country== 756 
replace party=10 if ch_prty ==10 & country== 756 
replace party=10 if ch_prty ==11 & country== 756 
replace party=15 if ch_prty ==12 & country== 756 
replace party=6 if ch_prty ==13 & country== 756 
replace party=12 if ch_prty ==14 & country== 756 
replace party=16 if ch_prty ==15 & country== 756 
replace party=96 if ch_prty ==95 & country== 756 
replace party=99 if ch_prty ==. & country== 756

replace party=1 if gb_prty==1 & country==826 
replace party=2 if gb_prty ==2 & country== 826 
replace party=3 if gb_prty ==3 & country== 826 
replace party=4 if gb_prty ==6 & country== 826 
replace party=5 if gb_prty ==7 & country== 826 
replace party=6 if gb_prty ==8 & country== 826 
replace party=96 if gb_prty ==95 & country == 826
replace party=97 if gb_prty ==96 & country == 826
replace party=99 if gb_prty ==98 & country == 826
replace party=99 if gb_prty ==99 & country == 826
replace party=99 if gb_prty ==. & country== 826


replace party=usa_prty if country == 840
replace party=96 if usa_prty ==95 & country == 840
replace party=99 if usa_prty ==. & country== 840

lab val party party
lab var party "Party Choice"
tab party
}

if `occupation_recode'==1 {
gen isco=isco88
gen isco_3=isco88_3
gen isco_3_6897=.
replace isco_3_6897 =isco68_3 if country==380
replace isco_3_6897 =isco68_3 if country==724

*Some occupational recoding draws on the work of Cusack, Iversen, and Rehm and Iversen and Soskice 2001,
*http://www.people.fas.harvard.edu/~iversen/SkillSpecificity.htm* 
gen isco_nat=gb_occ if country==826
gen occ88a=isco_3_6897
recode occ88a 010=-211 011=-211 012=-211 013=-211 014=-311 020=-214 021=-214 022=-214 023=-214 024=-214 025=-214 026=-214 ///
 027=-214 028=-214 029=-214 030=-311 031=-214 032=-311 033=-311 034=-311 035=-311 036=-311 037=-311 038=-311 039=-311 ///
 040=-314 041=-314 041=-314 042=-314 043=-314 050=-221 051=-221 052=-221 053=-221 054=-321 060=-222 061=-222 062=-322 ///
 063=-222 064=-322 065=-222 066=-322 067=-222 068=-322 069=-322 070=-223 071=-223 072=-323 073=-223 074=-323 075=-322 ///
 076=-322 077=-313 078=-322 079=-322 080=-212 081=-212 082=-212 083=-213 084=-213 090=-244 110=-241 120=-242 121=-242 ///
 122/124=-242 129=-242 013=-211 130=-230 131=-231 132=-232 133=-233 134=-233 135=-234 139=-235 140=-246 141=-212 149=-212 ///
 150=-245 151/152=-245 159=-245 160=-245 161=-245 162=-347 163=-313 170=-347 171=-245 172=-245 173=-245 174=-122 175=-347  ///
 179=-347 180/182=-347 190=-240 191=-243 192=-244 193=-346 194=-241 195=-244 196/199=-200 2=-110 200=-111 201=-112 ///
 202=-111 203=-112 210=-130 211=-120 212=-122 219=-123 220=-120 300=-123 310/312=-344 320=-411 321=-411 322=-411 330=-343 ///
 331=-421 339=-412 340=-312 341=-411 342/343=-312 350=-413 351=-122 352/353=-122 359=-413 360=-511 369/373=-414 380=-422 ///
 380=-422 390=-410 391=-413 392=-413 393=-410 394=-413 395/397=-414 399=-414 400=-131 410=-131 420=-123 421=-123 422=-341 ///
 430=-341 431=-341 432=-341 440=-341 441=-341 442=-342 443/444=-341 450=-520 451=-522 452/454=-911 490=-520 500=-131 ///
 510=-120 520=-512 530=-512 531=-512 532=-512 540=-513 541=-513 550=-914 551=-914 552=-714 560=-826 570/571=-514 /// 
 580=-516 581=-516 582=-345 583/587=-345 589=-343 590=-510 591=-511 592/594=-514 599=-915 600/602=-131 610=-613  ///
 611=-613 612/615=-613 620=-921 621=-921 622=-921 623=-921 624=-921 625=-921 626=-921 627=-921 628=-833 629=-610 ///
 630=-921 631=-614 632=-914  640=-615 641=-615 64=-615 649=-921 700=-751 710=-711 711=-711 712=-811 713=-811 /// 
 720=-722 721=-812 722=-812 723=-812 724=-812 725=-721 726=-812 727/729=-812 728=-822 72=-812 730=-814 731=-814 /// 
 732=-814 733=-814 734=-814 740=-815 741=-815 742=-815 743=-815 744=-815 745=-815 74=-815 749=-815 750=-826 751=-826 ///
 752=-826 753=-743 754=-826 755=-826 756=-826 75=-826 759=-826 760=-744 761=-744 762=-744 770=-827 771=-827 773=-741 ///
 774=-827 775=-827 776=-741 777=-827 778=-827 77=-827 779=-741  780=-827 781=-827 782=-827 783=-827 78=-827 789/790=-743 /// 
 791=-743 792=-743 793=-743 794=-743 795=-743 796=-743 079=-222  79=-826 799=-826 800=-744 801=-744 802=-744 803=-744 /// 
 810=-742 811=-742 812=-824 81=-742 819=-742 820=-711 830=-722 831=-722 832=-722 833=-722 834=-821 835/836=-722 83=-722 ///
 840=-723 841=-828 842=-731 843=-723 844=-723 84=-723 849=-723 850=-724 851=-724 852=-724 853=-828 854=-724 855=-713 ///
 856=-724 857=-724 85=-724 859=-724 860=-313 861=-313 862=-313 870=-721 871=-713 872=-721 873=-721 874=-721 878/880=-731 /// 
 890=-732 891=-732 892=-732 893=-813 894=-732 895=-732 89=-813 899=-813 900=-823 901=-823 902=-823 910=-825 920=-734 ///
 921=-734 922=-825 923=-734 924=-734 925=-734 926=-734 927=-822 92=-734 929/930=-724 931/932=-714 93=-714 939=-714 ///
 940=-752 941=-731 942=-742 943=-821 94=-733 948/949=-840 950=-712 951=-712 952=-712 953=-713 954=-712 955=-713 956=-713 ///
 957=-713 95=-712 959=-714 960=-816 961=-816 96=-816 969=-816 970=-933 971=-933 972=-721 973=-833 974=-833 97=-833 /// 
 979/980=-832 981=-834 982=-816 983=-831 984=-831 985=-334 986=-933 98=-832 988/989=-933 990/993=-930 995=-752 997/998=-829 ///
 99=-930 999=-930  
 
 gen isco_uk= isco_nat if country==826 

recode isco_uk 10=11 11=13 12=12 13=12 14=12 15=01 16=13 17=34 19=11 20=21 21=21 22=22 23=23 24=24 25=24 26=21 27=24 29=24 30=31 31=31 32=21 33=31 34=22 35=34 36=34 37=34 38=24 39=24 40=41 41=41 42=41 43=41 44=41 45=41 46=42 49=41 50=71 51=72 52=72 53=72 54=72 55=74 56=73 57=71 58=74 59=73 60=01 61=51 62=51 63=51 64=32 65=33 66=51 67=51 69=51 70=34 71=34 72=52 73=91 79=34 80=82 81=82 82=81 83=81 84=82 85=82 86=82 87=51 88=83 89=81 90=92 91=93 92=93 93=93 94=41 95=91 99=93 999=81
gen isco_uka=string(isco_uk)
 
replace occ88a=-(occ88a)
replace occ88a=. if occ88a<0
replace isco_3=occ88a if isco_3==.

gen isco_stringa=string(isco)
gen isco_stringb=string(isco_3)

 gen isco_3s=substr(isco_stringa, 1, 3)
destring isco_3s, replace
replace isco_3s=isco_3 if isco_3s==.
gen isco_combined=isco_3s
replace isco_combined=. if isco_combined==0
replace isco_combined=. if isco_combined==9999

gen isco_2=substr(isco_stringa, 1, 2)
replace isco_2=substr(isco_stringb, 1, 2) if isco_2=="."
replace isco_2="" if isco==0
replace isco_2="" if isco_3==0
replace isco_2=isco_uka if country==826

merge m:1 isco_2 using "Occupation_GROUPS.dta"

}

order sex age weight
drop v1-usa_ethn
drop if country==.

save `temp97', replace

}
if `year_1998'==1 {
********
* 1998 *
********
use "ZA3190.dta", clear

local main_variables 1
local income 1
local parties 1
local occupation_recode 1
local save 1

if `main_variables'==1 {

gen case=v2
lab var case "Case ID Number"

gen YYYY=1998
lab var YYYY "Survey Year"

recode v316 0=., gen(weight)
lab val weight weight
lab var weight "Weight"

gen country=.
replace country=36 if v3==1
replace country=276 if v3==2
replace country=276 if v3==3
replace country=826 if v3==4
replace country=840 if v3==6
replace country=40 if v3==7
replace country=380 if v3==9
replace country=372 if v3==10
replace country=528 if v3==11
replace country=578 if v3==12
replace country=752 if v3==13
replace country=554 if v3==19
replace country=124 if v3==20
replace country=392 if v3==24
replace country=724 if v3==25
replace country=250 if v3==28
replace country=620 if v3==30
replace country=208 if v3==32
replace country=756 if v3==33
lab def country ///
	36 "Australia" ///
	40 "Austria" ///
	124 "Canada" ///
	208 "Denmark" ///
	250 "France" ///
	276 "Germany" ///
	380 "Italy" ///
	372 "Ireland" ///
	392 "Japan" ///
	528 "Netherlands" ///
	554 "New Zealand" ///
	578 "Norway" ///
	620 "Portugal" ///
	724 "Spain" ///
	752 "Sweden" ///
	756 "Switzerland" ///
	826 "UK" ///
	840 "USA" 
lab val country country
lab var country "Country"
tab country


gen east_germany=1 if v3==3

recode v200 0=., gen(sex)

gen age= v201
replace age=. if v201 ==99
gen birth=1998-age
label var birth "Year of Birth"

gen empl=.
replace empl=2 if v206==1
replace empl=2 if v206 ==2
replace empl=1 if v206 ==5
lab def empl ///
	1 "Unemployed" ///
	2 "Employed" 
lab val empl empl
lab var empl "Employment Status - 2"
tab empl


gen employee=.
replace employee =2 if v211 ==1
replace employee =1 if v211 ==2
lab def employee ///
	1 "Employed" ///
	2 "Self Employed" 
lab val employee employee
lab var employee "Employee"
tab employee

tab v206
recode v206 0=., gen(emplB)
lab def emplB ///
	1 "Employed FT" ///
	2 "Employed PT" ///
	3 "Less than PT" ///
	4 "Helping Family Member" ///
	5 "Unemployed" ///
	6 "Student" ///
	7 "Retired" ///
	8 "Housewife/man" ///
	9 "Perm. dis" ///
	10 "Not in LF" 
lab val emplB emplB
lab var emplB "Employment Status"
tab emplB



gen education=.
replace education=1 if v205==1
replace education=1 if v205==2
replace education=1 if v205==3
replace education=2 if v205==4
replace education=3 if v205==5
replace education=4 if v205==6
replace education=5 if v205==7
lab def education ///
	1 "Less than lower secondary" ///
	2 "Lower Secondary" ///
	3 "Upper Secondary" ///
	4 "Vocational" ///
	5 "Degree" 
lab val education education
lab var education "Education Collapsed"
tab education



}



if `parties'==1 {
gen party_type=.
replace party_type=1 if country==40
replace party_type=2 if country==36
replace party_type=2 if country==124
replace party_type=2 if country==756
replace party_type=1 if country==276
replace party_type=3 if country==208 /**/
replace party_type=2 if country==724
replace party_type=2 if country==250
replace party_type=1 if country==826
replace party_type=1 if country==380
replace party_type=1 if country==372
replace party_type=2 if country==392
replace party_type=2 if country==578
replace party_type=1 if country==528
replace party_type=2 if country==554
replace party_type=2 if country==620
replace party_type=2 if country==752
replace party_type=1 if country==840


gen party=.
replace party=1 if v223==1 & country==36 
replace party=2 if v223 ==2 & country==36 
replace party=3 if v223 ==3 & country==36 
replace party=4 if v223 ==4 & country==36 
replace party=7 if v223 ==5 & country==36 
replace party=8 if v223 ==6 & country==36 
replace party=96 if v223 ==95 & country ==36
replace party=97 if v223 ==96 & country ==36
replace party=99 if v223 ==.a & country ==36
replace party=99 if v223 ==.b & country ==36

replace party=1 if v222==1 & country==40 
replace party=2 if v222 ==2 & country==40 
replace party=3 if v222 ==3 & country==40 
replace party=4 if v222 ==4 & country==40 
replace party=9 if v222 ==5 & country==40 
replace party=96 if v222 ==95 & country ==40
replace party=97 if v222 ==96 & country ==40
replace party=99 if v222 ==.a & country ==40
replace party=99 if v222 ==.b & country ==40



replace party=1 if v225==2 & country==124 
replace party=2 if v225==3 & country== 124 
replace party=3 if v225==4 & country== 124 
replace party=4 if v225==5 & country== 124 
replace party=5 if v225==1 & country== 124 
replace party=6 if v225==6 & country== 124 
replace party=7 if v225==7 & country== 124 
replace party=8 if v225==8 & country== 124 
replace party=9 if v225==9 & country== 124 
replace party=96 if v225 ==95 & country == 124
replace party=97 if v225 ==98 & country == 124
replace party=99 if v225 ==.a & country ==124
replace party=99 if v225 ==.b & country ==124


replace party=v230 if country==208 & v230<=86
replace party=93 if v230 ==93 & country == 208
replace party=97 if v230 ==96 & country == 208
replace party=99 if v230 ==.a & country ==208
replace party=99 if v230 ==.b & country ==208


replace party=1 if v232==1 & country==250 
replace party=2 if v232==2 & country== 250 
replace party=3 if v232==3 & country== 250 
replace party=4 if v232==4 & country== 250 
replace party=5 if v232==5 & country== 250 
replace party=6 if v232==6 & country== 250 
replace party=7 if v232==7 & country== 250 
replace party=96 if v232 ==95 & country == 250
replace party=97 if v232 ==96 & country == 250
replace party=99 if v232 ==.a & country ==250
replace party=99 if v232 ==.b & country ==250



replace party=1 if v229==2 & country==276 
replace party=2 if v229 ==1 & country== 276 
replace party=4 if v229 ==3 & country== 276 
replace party=5 if v229 ==4 & country== 276 
replace party=6 if v229 ==5 & country== 276 
replace party=7 if v229 ==6 & country== 276 
replace party=8 if v229 ==7 & country== 276 
replace party=9 if v229 ==8 & country== 276 
replace party=96 if v229 ==95 & country == 276
replace party=97 if v229 ==96 & country == 276
replace party=99 if v229 ==.a & country ==276
replace party=99 if v229 ==.b & country ==276



replace party=1 if v237==1 & country==372 
replace party=2 if v237 ==2 & country== 372 
replace party=3 if v237 ==3 & country== 372 
replace party=4 if v237 ==4 & country== 372 
replace party=5 if v237 ==5 & country== 372 
replace party=6 if v237 ==6 & country== 372 
replace party=7 if v237 ==7 & country== 372 
replace party=8 if v237 ==8 & country== 372 
replace party=96 if v237 ==95 & country == 372
replace party=97 if v237 ==96 & country == 372
replace party=99 if v237 ==.a & country ==372
replace party=99 if v237 ==.b & country ==372


replace party=14 if v235 ==1 & country==380 
replace party=26 if v235 ==2 & country== 380 
replace party=12 if v235 ==3 & country== 380 
replace party=22 if v235 ==4 & country== 380 
replace party=23 if v235 ==5 & country== 380 
replace party=27 if v235 ==6 & country== 380 
replace party=27 if v235 ==7 & country== 380 
replace party=29 if v235 ==8 & country== 380 
replace party=11 if v235 ==9 & country== 380 
replace party=30 if v235 ==10 & country== 380 
replace party=18 if v235 ==11 & country== 380 
replace party=19 if v235 ==12 & country== 380 
replace party=17 if v235 ==13 & country== 380 
replace party=16 if v235 ==14 & country== 380 
replace party=15 if v235 ==15 & country== 380 
replace party=96 if v235 ==94 & country == 380
replace party=96 if v235 ==95 & country == 380
replace party=97 if v235 ==96 & country == 380
replace party=99 if v235 ==.a & country ==380
replace party=99 if v235 ==.b & country ==380



replace party=1 if v238==1 & country==392 
replace party=2 if v238 ==6 & country== 392 
replace party=3 if v238 ==4 & country== 392 
replace party=4 if v238 ==5 & country== 392 
replace party=9 if v238 ==2 & country== 392 
replace party=10 if v238 ==3 & country== 392 
replace party=96 if v238 ==95 & country == 392
replace party=97 if v238 ==96 & country == 392
replace party=99 if v238 ==.a & country ==392
replace party=99 if v238 ==.b & country ==392

replace party=v241 if country==528 & v241<=96
replace party=96 if v241 ==94 & country == 528
replace party=96 if v241 ==95 & country == 528
replace party=97 if v241 ==96 & country == 528
replace party=99 if v241 ==.a & country ==528
replace party=99 if v241 ==.b & country ==528



replace party=2 if v242 ==4 & country== 554 
replace party=3 if v242 ==5 & country== 554 
replace party=9 if v242 ==6 & country== 554 
replace party=11 if v242 ==2 & country== 554 
replace party=12 if v242 ==1 & country== 554 
replace party=13 if v242 ==3 & country== 554 
replace party=14 if v242 ==7 & country== 554 
replace party=96 if v242 ==95 & country == 554
replace party=97 if v242 == 96 & country == 554
replace party=99 if v242 ==.a & country ==554
replace party=99 if v242 ==.b & country ==554

replace party=1 if v240==3 & country==578 
replace party=2 if v240 ==4 & country== 578 
replace party=3 if v240 ==6 & country== 578 
replace party=4 if v240 ==5 & country== 578 
replace party=5 if v240 ==8 & country== 578 
replace party=6 if v240 ==2 & country== 578 
replace party=7 if v240 ==7 & country== 578 
replace party=10 if v240 ==1 & country== 578 
replace party=96 if v240 ==95 & country == 578
replace party=97 if v240 == 96 & country == 578
replace party=99 if v240 ==.a & country ==578
replace party=99 if v240 ==.b & country ==578

replace party=v243 if country==620 & v243<=96
replace party=96 if v243 ==94 & country == 620
replace party=96 if v243 ==95 & country == 620
replace party=97 if v243 ==96 & country == 620
replace party=99 if v243 ==.a & country ==620
replace party=99 if v243 ==.b & country ==620


replace party=1 if v231==2 & country==724 
replace party=3 if v231 ==3 & country== 724 
replace party=4 if v231 ==1 & country== 724 
replace party=5 if v231 ==6 & country== 724 
replace party=5 if v231 ==7 & country== 724 
replace party=5 if v231 ==11 & country== 724 
replace party=5 if v231 ==12 & country== 724 
replace party=6 if v231 ==4 & country== 724 
replace party=6 if v231 ==5 & country== 724 
replace party=6 if v231 ==8 & country== 724 
replace party=6 if v231 ==9 & country== 724 
replace party=6 if v231 ==10 & country== 724 
replace party=6 if v231 ==13 & country== 724 
replace party=96 if v231 ==94 & country == 724
replace party= 96 if v231 ==95 & country == 724
replace party=97 if v231 ==96 & country == 724
replace party=99 if v231 ==.a & country ==724
replace party=99 if v231 ==.b & country ==724

replace party=1 if v248==1 & country==752 
replace party=2 if v248 ==2 & country== 752 
replace party=3 if v248 ==3 & country== 752 
replace party=4 if v248 ==4 & country== 752 
replace party=5 if v248 ==5 & country== 752 
replace party=6 if v248 ==6 & country== 752 
replace party=7 if v248 ==7 & country== 752 
replace party=96 if v248 ==95 & country == 752
replace party=97 if v248 ==96 & country == 752
replace party=99 if v248 ==.a & country ==752
replace party=99 if v248 ==.b & country ==752

replace party=2 if v226 ==1 & country== 756 
replace party=7 if v226 ==2 & country== 756 
replace party=1 if v226==3 & country==756 
replace party=3 if v226 ==4 & country== 756 
replace party=4 if v226 ==5 & country== 756 
replace party=5 if v226 ==6 & country== 756 
replace party=6 if v226 ==7 & country== 756 
replace party=8 if v226 ==8 & country== 756
replace party=15 if v226 ==9 & country== 756  
replace party=10 if v226 ==10 & country== 756 
replace party=13 if v226 ==11 & country== 756 
replace party=96 if v226 ==95 & country == 756
replace party=97 if v226 == 96 & country == 756
replace party=99 if v226 ==.a & country ==756
replace party=99 if v226 ==.b & country ==756

replace party=1 if v233==1 & country==826 
replace party=2 if v233 ==2 & country== 826 
replace party=3 if v233 ==3 & country== 826 
replace party=4 if v233 ==6 & country== 826 
replace party=5 if v233 ==7 & country== 826 
replace party=6 if v233 ==8 & country== 826 
replace party= 96 if v233 ==9 & country== 826 
replace party= 96 if v233 ==10 & country== 826 
replace party= 96 if v233 ==11 & country== 826 
replace party= 96 if v233 ==12 & country== 826 
replace party= 96 if v233 ==13 & country== 826 
replace party= 96 if v233 ==14 & country== 826 
replace party= 96 if v233 ==15 & country== 826 
replace party= 96 if v233 ==95 & country == 826
replace party=97 if v233 == 96 & country == 826
replace party=99 if v233 ==.a & country ==826
replace party=99 if v233 ==.b & country ==826


replace party=v251 if country == 840
replace party=96 if v251 ==95 & country == 840
replace party=99 if v251 ==.a & country ==840
replace party=99 if v251 ==.b & country ==840

lab val party party
lab var party "Party Choice"
tab party
}


if `occupation_recode'==1 {


recode v208 0=., gen(occup98)
lab val occup98 occup98
lab var occup98 "Occupation"

gen isco=v208

gen isco_string=string(occup98)
 gen isco_3s=substr(isco_string, 1, 3)
destring isco_3s, replace
gen isco_combined=isco_3s
replace isco_combined=isco_3 if isco_combined==.
replace isco_combined=isco_3 if isco_combined==.
replace isco_combined=. if isco_combined==0
replace isco_combined=. if isco_combined==9999

gen isco_2=substr(isco_string, 1, 2)

merge m:1 isco_2 using "Occupation_GROUPS.dta"

 
 
 }
 
drop v*
drop if country==.

save `temp98', replace
}
if `year_1999'==1 {
********
* 1999 *
********
use "ZA3430.dta", clear
set more off

local main_variables 1
local parties 1
local occupation_recode 1

if `main_variables'==1 {


gen case=v2
lab var case "Case ID Number"

gen YYYY=1999
lab var YYYY "Survey Year"



recode weight 0=.
lab val weight weight
lab var weight "Weight"


gen country=.
replace country=36 if v3==1
replace country=276 if v3==2
replace country=276 if v3==3
replace country=826 if v3==4
replace country=840 if v3==6
replace country =40 if v3==7
replace country =372 if v3==10
replace country=578 if v3==12
replace country=752 if v3==13
replace country=554 if v3==19
replace country=124 if v3==20
replace country=392 if v3==24
replace country=724 if v3==25
replace country=250 if v3==27
replace country=620 if v3==29
lab def country ///
	36 "Australia" ///
	40 "Austria" ///
	124 "Canada" ///
	276 "Germany" ///
	372 "Ireland" ///
	380 "Italy" ///
	392 "Japan" ///
	528 "Netherlands" ///
	554 "New Zealand" ///
	578 "Norway" ///
	620 "Portugal" ///
	724 "Spain" ///
	752 "Sweden" ///
	826 "UK" ///
	840 "USA" 
lab val country country
lab var country "Country"
tab country

gen east_germany=1 if v3==3


recode sex 0=.

tab age
recode age 98=. 

gen birth=1999-age
label var birth "Year of Birth"


gen empl=.
replace empl =2 if wrkst ==1
replace empl =2 if wrkst ==2
replace empl =1 if wrkst ==5
lab def empl ///
	1 "Unemployed" ///
	2 "Employed" 
lab val empl empl
lab var empl "Employment Status - 2"
tab empl

gen employee=.
replace employee =2 if selfemp ==1
replace employee =1 if selfemp ==2
lab def employee ///
	1 "Employed" ///
	2 "Self Employed" 
lab val employee employee
lab var employee "Employee"
tab employee

tab wrkst
recode wrkst 0=., gen(emplB)
lab def emplB ///
	1 "Employed FT" ///
	2 "Employed PT" ///
	3 "Less than PT" ///
	4 "Helping Family Member" ///
	5 "Unemployed" ///
	6 "Student" ///
	7 "Retired" ///
	8 "Housewife/man" ///
	9 "Perm. dis" ///
	10 "Not in LF" 
lab val emplB emplB
lab var emplB "Employment Status"
tab emplB

gen education=.
replace education=1 if degree==1
replace education=1 if degree ==2
replace education=1 if degree ==3
replace education=2 if degree ==4
replace education=3 if degree ==5
replace education=4 if degree ==6
replace education=5 if degree ==7
lab def education ///
	1 "Less than lower secondary" ///
	2 "Lower Secondary" ///
	3 "Upper Secondary" ///
	4 "Vocational" ///
	5 "Degree" 
lab val education education
lab var education "Education Collapsed"
tab education

}

if `parties'==1 {
gen party_type=2
gen party=.

replace party=1 if x_prty==101 & country==36 
replace party=2 if x_prty ==102 & country==36 
replace party=3 if x_prty ==103 & country==36 
replace party=4 if x_prty ==104 & country==36 
replace party=7 if x_prty ==105 & country==36 
replace party=8 if x_prty ==106 & country==36 
replace party=97 if x_prty ==107 & country ==36
replace party=99 if x_prty ==109 & country ==36


replace party=1 if x_prty==701 & country==40 
replace party=2 if x_prty ==702 & country==40 
replace party=3 if x_prty ==703 & country==40 
replace party=4 if x_prty ==704 & country==40 
replace party=9 if x_prty ==705 & country==40 
replace party=96 if x_prty ==795 & country ==40
replace party=97 if x_prty ==796 & country ==40
replace party=99 if x_prty ==799 & country ==40



replace party=1 if x_prty==2002 & country==124 
replace party=2 if x_prty==2003 & country== 124 
replace party=3 if x_prty==2004 & country== 124 
replace party=4 if x_prty==2005 & country== 124 
replace party=5 if x_prty==2001 & country== 124 
replace party=96 if x_prty == 2006 & country == 124
replace party=97 if x_prty ==2008 & country == 124
replace party=99 if x_prty ==2009 & country == 124


replace party=1 if x_prty==2701 & country==250 
replace party=2 if x_prty==2702 & country== 250 
replace party=3 if x_prty==2703 & country== 250 
replace party=4 if x_prty==2704 & country== 250 
replace party=5 if x_prty==2705 & country== 250 
replace party=6 if x_prty==2706 & country== 250 
replace party=7 if x_prty==2707 & country== 250 
replace party=96 if x_prty ==2708 & country == 250
replace party=99 if x_prty ==2700 & country == 250
replace party=97 if x_prty ==2709 & country == 250



replace party=1 if x_prty==302 & country==276 
replace party=2 if x_prty ==301 & country== 276 
replace party=4 if x_prty ==303 & country== 276 
replace party=5 if x_prty ==304 & country== 276 
replace party=8 if x_prty ==307 & country== 276 
replace party=9 if x_prty ==308 & country== 276 
replace party=96 if x_prty ==395 & country == 276
replace party=99 if x_prty ==300 & country == 276
replace party=99 if x_prty ==397 & country == 276
replace party=99 if x_prty ==398 & country == 276
replace party=97 if x_prty ==396 & country == 276





replace party=1 if x_prty==2401 & country==392 
replace party=2 if x_prty ==2406 & country== 392 
replace party=3 if x_prty ==2404 & country== 392 
replace party=4 if x_prty ==2405 & country== 392 
replace party=9 if x_prty ==2402 & country== 392 
replace party=10 if x_prty ==2403 & country== 392 
replace party=11 if x_prty ==2407 & country== 392 
replace party=96 if x_prty ==2408 & country == 392
replace party=97 if x_prty ==2409 & country == 392
replace party=99 if x_prty ==2499 & country == 392



replace party=2 if x_prty ==1904 & country== 554 
replace party=3 if x_prty ==1905 & country== 554 
replace party=9 if x_prty ==1906 & country== 554 
replace party=11 if x_prty ==1902 & country== 554 
replace party=12 if x_prty ==1901 & country== 554 
replace party=13 if x_prty ==1903 & country== 554 
replace party=14 if x_prty ==1907 & country== 554 
replace party=96 if x_prty ==1908 & country == 554
replace party=99 if x_prty == 1909 & country == 554
replace party=99 if x_prty ==1910 & country == 554
replace party=97 if x_prty ==1911 & country == 554

replace party=1 if x_prty==1203 & country==578 
replace party=2 if x_prty ==1204 & country== 578 
replace party=3 if x_prty ==1206 & country== 578 
replace party=4 if x_prty ==1205 & country== 578 
replace party=5 if x_prty ==1208 & country== 578 
replace party=6 if x_prty ==1202 & country== 578 
replace party=7 if x_prty ==1207 & country== 578 
replace party=10 if x_prty ==1201 & country== 578 
replace party=96 if x_prty ==1295 & country == 578
replace party=97 if x_prty == 1296 & country == 578
replace party=99 if x_prty ==1297 & country == 578
replace party=99 if x_prty ==1298 & country == 578
replace party=99 if x_prty ==1299 & country == 578

replace party=1 if x_prty==2902 & country==620
replace party=2 if x_prty==2903 & country==620
replace party=4 if x_prty==2905 & country==620
replace party=5 if x_prty==2906 & country==620
replace party=6 if x_prty==2907 & country==620
replace party=7 if x_prty==2908 & country==620
replace party=8 if x_prty==2901 & country==620
replace party=96 if x_prty == 2909 & country == 620
replace party=97 if x_prty == 2910 & country == 620
replace party=99 if x_prty ==2998 & country == 620
replace party=99 if x_prty ==2999 & country == 620


replace party=1 if x_prty==2501 & country==724 
replace party=3 if x_prty ==2503 & country== 724 
replace party=4 if x_prty ==2504 & country== 724 
replace party=5 if x_prty ==2505 & country== 724 
replace party=6 if x_prty ==2506 & country== 724 
replace party=7 if x_prty ==2507 & country== 724 
replace party= 96 if x_prty ==2508 & country == 724
replace party=96 if x_prty ==2509 & country == 724
replace party=97 if x_prty ==2510 & country == 724
replace party=99 if x_prty == 2511 & country == 724
replace party=99 if x_prty == 2512 & country == 724
replace party=96 if x_prty == 2513 & country == 724

replace party=1 if x_prty==1301 & country==752 
replace party=2 if x_prty ==1302 & country== 752 
replace party=3 if x_prty ==1303 & country== 752 
replace party=4 if x_prty ==1304 & country== 752 
replace party=5 if x_prty ==1305 & country== 752 
replace party=6 if x_prty ==1306 & country== 752 
replace party=7 if x_prty ==1307 & country== 752 
replace party=96 if x_prty ==1395 & country == 752
replace party=97 if x_prty ==1396 & country == 752
replace party=99 if x_prty ==1399 & country == 752


replace party=1 if x_prty==401 & country==826 
replace party=2 if x_prty ==402 & country== 826 
replace party=3 if x_prty ==403 & country== 826 
replace party=4 if x_prty ==406 & country== 826 
replace party=5 if x_prty ==407 & country== 826 
replace party=6 if x_prty ==408 & country== 826 
replace party= 96 if x_prty ==493 & country == 826
replace party= 96 if x_prty ==495 & country == 826
replace party=97 if x_prty == 496 & country == 826
replace party=99 if x_prty ==497 & country == 826
replace party=99 if x_prty ==498 & country == 826


replace party=1 if x_prty==601 & country == 840
replace party=2 if x_prty==602 & country == 840
replace party=3 if x_prty==603 & country == 840
replace party=4 if x_prty==604 & country == 840
replace party=5 if x_prty==605 & country == 840
replace party=6 if x_prty==606 & country == 840
replace party=7 if x_prty==607 & country == 840
replace party=96 if x_prty ==695 & country == 840
replace party=99 if x_prty ==600 & country == 840

lab val party party
lab var party "Party Choice"
tab party

}

if `occupation_recode'==1 {

gen isco= isco88_4


gen isco_3=isco88_3

gen isco_stringa=string(isco)
gen isco_stringb=string(isco_3)

 gen isco_3s=substr(isco_stringa, 1, 3)
destring isco_3s, replace
replace isco_3s=isco_3 if isco_3s==.
gen isco_combined=isco_3s
replace isco_combined=. if isco_combined==0
replace isco_combined=. if isco_combined==9999

gen isco_2=substr(isco_stringa, 1, 2)
replace isco_2="" if isco_2=="0"
replace isco_2=substr(isco_stringb, 1, 2) if isco_2==""
replace isco_2="" if isco==9995
replace isco_2="" if isco_3==996



merge m:1 isco_2 using "Occupation_GROUPS.dta"


}

order sex age weight
drop if country==.
drop v1-wrkh_int
save `temp99', replace
}
if `year_2000'==1 {
********
* 2000 *
********
set more off
use "ZA3440.dta", clear

local main_variables 1
local parties 1
local occupation_recode 1

if `main_variables'==1 {

gen case=v2
lab var case "Case ID Number"

gen YYYY=2000
lab var YYYY "Survey Year"

recode v327 0=., gen(weight)
lab val weight weight
lab var weight "Weight"

gen country=.
replace country=276 if v3==2
replace country=276 if v3==3
replace country=826 if v3==4
replace country=840 if v3==6
replace country =40 if v3==7
replace country =372 if v3==10
replace country =528 if v3==11
replace country=578 if v3==12
replace country=752 if v3==13
replace country=554 if v3==19
replace country=124 if v3==20
replace country=392 if v3==24
replace country=724 if v3==25
replace country=620 if v3==30
replace country=208 if v3==32
replace country =756 if v3==33
replace country=246 if v3==37
lab def country ///
	40 "Austria" ///
	124 "Canada" ///
	208 "Denmark" ///
	246 "Finland" ///
	276 "Germany" ///
	372 "Ireland" ///
	392 "Japan" ///
	528 "Netherlands" ///
	554 "New Zealand" ///
	578 "Norway" ///
	620 "Portugal" ///
	724 "Spain" ///
	752 "Sweden" ///
	756 "Switzerland" ///
	826 "UK" ///
	840 "USA" 
lab val country country
lab var country "Country"
tab country

gen east_germany=1 if v3==3

recode v200 0=., gen(sex)

gen age = v201
gen birth=2000-age
label var birth "Year of Birth"

gen empl=.
replace empl =2 if v231 ==1
replace empl =2 if v231 ==2
replace empl =1 if v231 ==5
lab def empl ///
	1 "Unemployed" ///
	2 "Employed" 
lab val empl empl
lab var empl "Employment Status - 2"
tab empl

gen employee=.
replace employee =2 if v236 ==1
replace employee =1 if v236 ==2
lab def employee ///
	1 "Employed" ///
	2 "Self Employed" 
lab val employee employee
lab var employee "Employee"
tab employee

tab v231
recode v231 0=., gen(emplB)
lab def emplB ///
	1 "Employed FT" ///
	2 "Employed PT" ///
	3 "Less than PT" ///
	4 "Helping Family Member" ///
	5 "Unemployed" ///
	6 "Student" ///
	7 "Retired" ///
	8 "Housewife/man" ///
	9 "Perm. dis" ///
	10 "Not in LF" 
lab val emplB emplB
lab var emplB "Employment Status"
tab emplB
 
gen education=.
replace education=1 if v205==1
replace education=1 if v205 ==2
replace education=1 if v205 ==3
replace education=2 if v205 ==4
replace education=3 if v205 ==5
replace education=4 if v205 ==6
replace education=5 if v205 ==7
lab def education ///
	1 "Less than lower secondary" ///
	2 "Lower Secondary" ///
	3 "Upper Secondary" ///
	4 "Vocational" ///
	5 "Degree" 
lab val education education
lab var education "Education Collapsed"
tab education

}
if `parties'==1 {
gen party_type=1 if country==40 
replace party_type=2 if country==124 
replace party_type=3 if country==208
replace party_type=2 if country==246
replace party_type=1 if country==276 
replace party_type=1 if country==372 
replace party_type=2 if country==392 
replace party_type=2 if country==578 
replace party_type=1 if country==528 
replace party_type=2 if country==554 
replace party_type=2 if country==620 
replace party_type=3 if country==724
replace party_type=2 if country==752 
replace party_type=2 if country==756 
replace party_type=2 if country==840 
replace party_type=2 if country==826 

gen party=.
replace party=1 if v247 ==1 & country==40 
replace party=2 if v247 ==2 & country==40 
replace party=3 if v247 ==3 & country==40 
replace party=4 if v247 ==4 & country==40 
replace party=9 if v247 ==5 & country==40 
replace party=96 if v247 ==95 & country ==40
replace party= 97 if v247 ==96 & country ==40
replace party= 99 if v247 ==.a & country ==40
replace party= 99 if v247 ==.b & country ==40

replace party=1 if v249==2 & country==124 
replace party=2 if v249 ==3 & country== 124 
replace party=3 if v249 ==4 & country== 124 
replace party=4 if v249 ==5 & country== 124 
replace party=5 if v249 ==1 & country== 124 
replace party=96 if v249 == 95 & country == 124
replace party= 97 if v249 ==96 & country == 124
replace party= 99 if v249 ==.a & country == 124
replace party= 99 if v249 ==.b & country == 124

replace party=1 if v253==1 & country==208 
replace party=2 if v253 ==2 & country== 208 
replace party=3 if v253 ==3 & country== 208 
replace party=4 if v253 ==4 & country== 208 
replace party=5 if v253 ==5 & country== 208 
replace party=6 if v253 ==6 & country== 208 
replace party=7 if v253 ==7 & country== 208 
replace party=8 if v253 ==8 & country== 208 
replace party=9 if v253 ==9 & country== 208 
replace party=10 if v253 ==10 & country== 208 
replace party=11 if v253 ==11 & country== 208 
replace party=96 if v253 == 95 & country == 208
replace party= 97 if v253 ==96 & country == 208
replace party= 99 if v253 ==.a & country == 208
replace party= 99 if v253 ==.b & country == 208
replace party= 99 if v253 ==.c & country == 208
replace party= 99 if v253 ==.d & country == 208

replace party=v269 if country == 246
replace party=96 if v269 ==95 & country == 246
replace party=98 if v269 ==96 & country == 246
replace party=99 if v269 ==.a & country == 246
replace party=99 if v269 ==.b & country == 246
replace party=99 if v269 ==.c & country == 246
replace party=99 if v269 ==.d & country == 246


replace party=1 if v252==2 & country==276 
replace party=2 if v252 ==1 & country== 276 
replace party=4 if v252 ==3 & country== 276 
replace party=5 if v252 ==4 & country== 276 
replace party=6 if v252 ==5 & country== 276 
replace party=7 if v252 ==6 & country== 276 
replace party=8 if v252 ==7 & country== 276 
replace party=9 if v252 ==8 & country== 276 
replace party=96 if v252 ==95 & country == 276
replace party=97 if v252 ==96 & country == 276
replace party=99 if v252 ==.a & country == 276
replace party=99 if v252 ==.b & country == 276
replace party=99 if v252 ==.d & country == 276


replace party=1 if v257==1 & country ==372 
replace party=2 if v257 ==2 & country== 372 
replace party=3 if v257 ==3 & country== 372 
replace party=4 if v257 ==4 & country== 372 
replace party=5 if v257 ==5 & country== 372 
replace party=6 if v257 ==6 & country== 372 
replace party=7 if v257 ==7 & country== 372 
replace party=8 if v257 ==8 & country== 372 
replace party=96 if v257 ==95 & country == 372
replace party=97 if v257 ==96 & country == 372
replace party=99 if v257 ==.a & country == 372
replace party=99 if v257 ==.b & country == 372
replace party=99 if v257 ==.c & country == 372



replace party=1 if v258==1 & country==392 
replace party=2 if v258 ==6 & country== 392 
replace party=3 if v258 ==4 & country== 392 
replace party=4 if v258 ==5 & country== 392 
replace party=9 if v258 ==2 & country== 392 
replace party=12 if v258 ==3 & country== 392 
replace party=11 if v258 ==7 & country== 392 
replace party=96 if v258 ==95 & country == 392
replace party=97 if v258 ==96 & country == 392
replace party=99 if v258 ==.a & country == 392
replace party=99 if v258 ==.b & country == 392

replace party =1 if v262==1 & country==528
replace party =2 if v262==2 & country==528
replace party =3 if v262==3 & country==528
replace party =4 if v262==4 & country==528
replace party =5 if v262==5 & country==528
replace party =6 if v262==6 & country==528
replace party =7 if v262==7 & country==528
replace party =8 if v262==8 & country==528
replace party =9 if v262==9 & country==528
replace party =10 if v262==10 & country==528
replace party =11 if v262==11 & country==528
replace party =12 if v262==12 & country==528
replace party =96 if v262 ==94 & country == 528
replace party =96 if v262 ==95 & country == 528
replace party =97 if v262 ==96 & country == 528
replace party =99 if v262 ==.a & country == 528
replace party =99 if v262 ==.b & country == 528
replace party =99 if v262 ==.d & country == 528

replace party=1 if v263 ==3 & country== 554 
replace party=2 if v263 ==4 & country== 554 
replace party=3 if v263 ==5 & country== 554 
replace party=9 if v263 ==6 & country== 554 
replace party=11 if v263 ==2 & country== 554 
replace party=12 if v263 ==1 & country== 554 
replace party=14 if v263 ==7 & country== 554 
replace party=96 if v263 ==95 & country == 554
replace party=97 if v263 == 96 & country == 554
replace party=99 if v263 ==.a & country == 554
replace party=99 if v263 ==.b & country == 554
replace party=99 if v263 ==.c & country == 554

replace party=1 if v261==3 & country==578 
replace party=2 if v261 ==4 & country== 578 
replace party=3 if v261 ==6 & country== 578 
replace party=4 if v261 ==5 & country== 578 
replace party=5 if v261 ==8 & country== 578 
replace party=6 if v261 ==2 & country== 578 
replace party=7 if v261 ==7 & country== 578 
replace party=10 if v261 ==1 & country== 578 
replace party=96 if v261 ==95 & country == 578
replace party=97 if v261 == 96 & country == 578
replace party= 99 if v261 ==.a & country == 578
replace party= 99 if v261 ==.b & country == 578
replace party= 99 if v261 ==.c & country == 578

replace party=1 if v264 ==2 & country==620
replace party=2 if v264 ==3 & country==620
replace party=3 if v264 ==4 & country==620
replace party=4 if v264 ==5 & country==620
replace party=5 if v264 ==6 & country==620
replace party=6 if v264 ==7 & country==620
replace party=7 if v264 ==8 & country==620
replace party=8 if v264 ==1 & country==620
replace party=96 if v264 == 95 & country == 620
replace party=97 if v264 == 96 & country == 620
replace party=99 if v264 == .a & country == 620
replace party=99 if v264 == .b & country == 620


replace party=1 if v254==1 & country==724 
replace party=3 if v254 ==2 & country== 724 
replace party=4 if v254 ==3 & country== 724 
replace party=5 if v254 ==4 & country== 724 
replace party=5 if v254 ==5 & country== 724 
replace party=6 if v254 ==6 & country== 724 
replace party=5 if v254 ==7 & country== 724 
replace party=6 if v254 ==8 & country== 724 
replace party=6 if v254 ==9 & country== 724 
replace party=6 if v254 ==10 & country== 724 
replace party=6 if v254 ==11 & country== 724 
replace party=96 if v254 ==12 & country== 724 
replace party= 96 if v254 ==95 & country == 724
replace party=97 if v254 ==96 & country == 724
replace party= 99 if v254 ==.a & country == 724
replace party= 99 if v254 == .b & country == 724
replace party= 99 if v254 == .c & country == 724
replace party= 99 if v254 == .d & country == 724

replace party=1 if v268==1 & country==752 
replace party=2 if v268 ==2 & country== 752 
replace party=3 if v268 ==3 & country== 752 
replace party=4 if v268 ==4 & country== 752 
replace party=5 if v268 ==5 & country== 752 
replace party=6 if v268 ==6 & country== 752 
replace party=7 if v268 ==7 & country== 752 
replace party=96 if v268 ==95 & country == 752
replace party=97 if v268 ==96 & country == 752
replace party=99 if v268 ==.a & country == 752
replace party=99 if v268 ==.b & country == 752


replace party =2 if v250 ==1 & country== 756 
replace party =7 if v250 ==2 & country== 756 
replace party =1 if v250==3 & country==756 
replace party =3 if v250 ==4 & country== 756 
replace party =4 if v250 ==5 & country== 756 
replace party =5 if v250 ==6 & country== 756 
replace party =6 if v250 ==7 & country== 756 
replace party =8 if v250 ==8 & country== 756 
replace party =15 if v250 ==9 & country== 756 
replace party =10 if v250 ==10 & country== 756 
replace party =96 if v250 ==95 & country == 756
replace party =97 if v250 == 96 & country == 756
replace party =99 if v250 ==.a & country == 756
replace party =99 if v250 ==.b & country == 756


replace party=1 if v255==1 & country==826 
replace party=2 if v255 ==2 & country== 826 
replace party=3 if v255 ==3 & country== 826 
replace party=4 if v255 ==7 & country== 826 
replace party=5 if v255 ==8 & country== 826 
replace party=6 if v255 ==9 & country== 826 
replace party= 96 if v255 ==93 & country == 826
replace party= 96 if v255 ==95 & country == 826
replace party=97 if v255 == 96 & country == 826
replace party=99 if v255 ==.a & country == 826
replace party=99 if v255 ==.b & country == 826
replace party=99 if v255 ==.c & country == 826

replace party =v271 if country == 840
replace party =96 if v251 ==95 & country == 840
replace party =99 if v251 ==.a & country == 840
replace party =99 if v251 ==.b & country == 840

lab val party party
lab var party "Party Choice"
tab party
}

if `occupation_recode'==1 {
gen isco= v233

tab v233
recode v233 0=., gen(occup00)
lab val occup00 v233
lab var occup00 "Occupation"
tab occup00

replace occup00=. if country==392 /*Missing correct codes*/

gen isco_string=string(occup00)
 gen isco_3s=substr(isco_string, 1, 3)
destring isco_3s, replace
gen isco_combined=isco_3s
replace isco_combined=isco_3 if isco_combined==.
replace isco_combined=isco_3 if isco_combined==.
replace isco_combined=. if isco_combined==0
replace isco_combined=. if isco_combined==9999

gen isco_2=substr(isco_string, 1, 2)

merge m:1 isco_2 using "Occupation_GROUPS.dta"


}

drop v*
drop if country==.

save `temp00', replace
}
if `year_2001'==1 {
********
* 2001 *
********
set more off 
use "ZA3680.dta", clear

local main_variables 1
local parties 1
local occupation_recode 1

if `main_variables'==1 {

recode weight 0=.
lab val weight weight
lab var weight "Weight"

gen case=V2
lab var case "Case ID Number"

gen YYYY=2001
lab var YYYY "Survey Year"

gen country=.
replace country=36 if V3==1
replace country=276 if V3==2
replace country=276 if V3==3
replace country=826 if V3==4
replace country=840 if V3==6
replace country =40 if V3==7
replace country =380 if V3==9
replace country =372 if V3==10
replace country =528 if V3==11
replace country=578 if V3==12
replace country=752 if V3==13
replace country=554 if V3==19
replace country=124 if V3==20
replace country=392 if V3==24
replace country=724 if V3==25
replace country=250 if V3==28
replace country=620 if V3==30
replace country=208 if V3==32
replace country =756 if V3==33
replace country=246 if V3==37
lab def country ///
	36 "Australia" ///
	40 "Austria" ///
	124 "Canada" ///
	208 "Denmark" ///
	246 "Finland" ///
	250 "France" ///
	276 "Germany" ///
	372 "Ireland" ///
	380 "Italy" ///
	392 "Japan" ///
	528 "Netherlands" ///
	554 "New Zealand" ///
	578 "Norway" ///
	620 "Portugal" ///
	724 "Spain" ///
	752 "Sweden" ///
	756 "Switzerland" ///
	826 "UK" ///
	840 "USA" 
lab val country country
lab var country "Country"
tab country

gen east_germany=1 if V3==3


recode sex 0=.

gen birth=2001-age
label var birth "Year of Birth"

gen empl=.
replace empl =2 if wrkst ==1
replace empl =2 if wrkst ==2
replace empl =1 if wrkst ==5
lab def empl ///
	1 "Unemployed" ///
	2 "Employed" 
lab val empl empl
lab var empl "Employment Status - 2"
tab empl


gen employee=.
replace employee =2 if selfemp ==1
replace employee =1 if selfemp ==2
lab def employee ///
	1 "Employed" ///
	2 "Self Employed" 
lab val employee employee
lab var employee "Employee"
tab employee

tab wrkst
recode wrkst 0=. 11=1 12=10, gen(emplB)
lab def emplB ///
	1 "Employed FT" ///
	2 "Employed PT" ///
	3 "Less than PT" ///
	4 "Helping Family Member" ///
	5 "Unemployed" ///
	6 "Student" ///
	7 "Retired" ///
	8 "Housewife/man" ///
	9 "Perm. dis" ///
	10 "Not in LF" 
lab val emplB emplB
lab var emplB "Employment Status"
tab emplB

gen education=.
replace education=1 if degree==1
replace education=1 if degree ==2
replace education=1 if degree ==3
replace education=2 if degree ==4
replace education=3 if degree ==5
replace education=4 if degree ==6
replace education=5 if degree ==7
lab def education ///
	1 "Less than lower secondary" ///
	2 "Lower Secondary" ///
	3 "Upper Secondary" ///
	4 "Vocational" ///
	5 "Degree" 
lab val education education
lab var education "Education Collapsed"
tab education

} 

if `parties' ==1 {

gen party_type=1 /*Respondent's voting intention in national elections*/
replace party_type=3 if country==208
replace party_type=3 if country==756 /*Double */

gen party=.
replace party=1 if A_PRTY ==1 & country==40 
replace party=2 if A_PRTY ==2 & country==40 
replace party=3 if A_PRTY ==3 & country==40 
replace party=4 if A_PRTY ==4 & country==40 
replace party=9 if A_PRTY ==5 & country==40 
replace party=96 if A_PRTY ==95 & country ==40
replace party=97 if A_PRTY ==96 & country ==40
replace party= 99 if A_PRTY ==0 & country ==40

replace party=1 if AUS_PRTY ==1 & country==36
replace party=2 if AUS_PRTY ==2 & country==36
replace party=3 if AUS_PRTY ==3 & country==36
replace party=4 if AUS_PRTY ==4 & country==36
replace party=7 if AUS_PRTY ==5 & country==36
replace party=96 if AUS_PRTY ==95 & country ==36
replace party=99 if AUS_PRTY ==. & country ==36

replace party=5 if CDN_PRTY ==1 & country==124
replace party=1 if CDN_PRTY ==2 & country==124
replace party=2 if CDN_PRTY ==3 & country==124
replace party=3 if CDN_PRTY ==4 & country==124
replace party=4 if CDN_PRTY ==5 & country==124
replace party=96 if CDN_PRTY ==95 & country ==124
replace party=97 if CDN_PRTY ==96 & country ==124
replace party=99 if CDN_PRTY ==. & country ==124


replace party=1 if DK_PRTY ==1 & country==208
replace party=2 if DK_PRTY ==2 & country==208
replace party=3 if DK_PRTY ==3 & country==208
replace party=4 if DK_PRTY ==4 & country==208
replace party=5 if DK_PRTY ==5 & country==208
replace party=6 if DK_PRTY ==6 & country==208
replace party=7 if DK_PRTY ==7 & country==208
replace party=9 if DK_PRTY ==8 & country==208
replace party=10 if DK_PRTY ==9 & country==208
replace party=11 if DK_PRTY ==10 & country==208
replace party=97 if DK_PRTY ==0  & country==208
replace party=99 if DK_PRTY ==12 & country==208
replace party=99 if DK_PRTY ==13 & country==208
replace party=99 if DK_PRTY ==. & country==208

replace party=2 if D_PRTY==1 & country==276
replace party=1 if D_PRTY==2 & country==276
replace party=4 if D_PRTY==3 & country==276
replace party=5 if D_PRTY==4 & country==276
replace party=8 if D_PRTY==7 & country==276
replace party=9 if D_PRTY==8 & country==276
replace party=96 if D_PRTY==95 & country==276
replace party=97 if D_PRTY==96 & country==276
replace party=99 if D_PRTY==. & country==276


replace party=2 if F_PRTY ==1 & country==250
replace party=1 if F_PRTY ==2 & country==250
replace party=3 if F_PRTY ==3 & country==250
replace party=4 if F_PRTY ==4 & country==250
replace party=5 if F_PRTY ==5 & country==250
replace party=6 if F_PRTY ==6 & country==250
replace party=7 if F_PRTY ==7 & country==250
replace party=96 if F_PRTY ==8 & country==250
replace party=97 if F_PRTY ==0 & country==250
replace party=99 if F_PRTY ==. & country==250

replace party=1 if SF_PRTY ==1 & country==246
replace party=2 if SF_PRTY ==2 & country==246
replace party=3 if SF_PRTY ==3 & country==246
replace party=4 if SF_PRTY ==4 & country==246
replace party=4 if SF_PRTY ==5 & country==246
replace party=6 if SF_PRTY ==6 & country==246
replace party=7 if SF_PRTY ==7 & country==246
replace party=8 if SF_PRTY ==8 & country==246
replace party=9 if SF_PRTY ==9 & country==246
replace party=96 if SF_PRTY ==10 & country==246
replace party=97 if SF_PRTY ==96 & country==246
replace party=99 if SF_PRTY ==. & country==246



replace party=1 if J_PRTY ==1 & country==392
replace party=9 if J_PRTY ==2 & country==392
replace party=10 if J_PRTY ==3 & country==392
replace party=3 if J_PRTY ==4 & country==392
replace party=4 if J_PRTY ==5 & country==392
replace party=2 if J_PRTY ==6 & country==392
replace party=12 if J_PRTY ==7 & country==392
replace party=96 if J_PRTY ==95 & country==392
replace party=97 if J_PRTY ==96 & country==392
replace party=99 if J_PRTY ==. & country==392

replace party=12 if NZ_PRTY ==1 & country==554
replace party=11 if NZ_PRTY ==2 & country==554
replace party=2 if NZ_PRTY ==4 & country==554
replace party=3 if NZ_PRTY ==5 & country==554
replace party=9 if NZ_PRTY ==6 & country==554
replace party=14 if NZ_PRTY ==7 & country==554
replace party=96 if NZ_PRTY ==95 & country==554
replace party=97 if NZ_PRTY ==96 & country==554
replace party=99 if NZ_PRTY ==. & country==554


replace party=10 if N_PRTY ==1 & country==578
replace party=6 if N_PRTY ==2 & country==578
replace party=1 if N_PRTY ==3 & country==578
replace party=2 if N_PRTY ==4 & country==578
replace party=4 if N_PRTY ==5 & country==578
replace party=3 if N_PRTY ==6 & country==578
replace party=7 if N_PRTY ==7 & country==578
replace party=5 if N_PRTY ==8 & country==578
replace party=96 if N_PRTY ==96 & country==578
replace party=97 if N_PRTY ==96 & country==578
replace party=99 if N_PRTY ==. & country==578

replace party=1 if E_PRTY ==1 & country==724
replace party=3 if E_PRTY ==2 & country==724
replace party=4 if E_PRTY ==3 & country==724
replace party=5 if E_PRTY ==4 & country==724
replace party=6 if E_PRTY ==5 & country==724
replace party=7 if E_PRTY ==6 & country==724
replace party=96 if E_PRTY ==7 & country==724
replace party=96 if E_PRTY ==8 & country==724
replace party=97 if E_PRTY ==9 & country==724
replace party=99 if E_PRTY ==. & country==724

replace party=2 if CH_PRTY ==1 & country==756
replace party=7 if CH_PRTY ==2 & country==756
replace party=1 if CH_PRTY ==3 & country==756
replace party=3 if CH_PRTY ==4 & country==756
replace party=4 if CH_PRTY ==5 & country==756
replace party=6 if CH_PRTY ==7 & country==756
replace party=8 if CH_PRTY ==8 & country==756
replace party=15 if CH_PRTY ==9 & country==756
replace party=10 if CH_PRTY ==10 & country==756
replace party=13 if CH_PRTY ==11 & country==756
replace party=96 if CH_PRTY ==95 & country==756
replace party=96 if CH_PRTY ==96 & country==756
replace party=99 if CH_PRTY ==. & country==756

replace party=1 if GB_PRTY ==1 & country==826
replace party=2 if GB_PRTY ==2 & country==826
replace party=3 if GB_PRTY ==3 & country==826
replace party=4 if GB_PRTY ==6 & country==826
replace party=5 if GB_PRTY ==7 & country==826
replace party=6 if GB_PRTY ==8 & country==826
replace party=96 if GB_PRTY ==95 & country==826
replace party=97 if GB_PRTY ==96 & country==826
replace party=99 if GB_PRTY ==. & country==826
replace party=99 if GB_PRTY ==93 & country==826

replace party =USA_PRTY if country == 840
replace party =96 if USA_PRTY ==95 & country == 840

lab val party party
lab var party "Party Choice"
tab party

}
if `occupation_recode'==1 {

gen isco= ISCO88
gen isco_3=ISCO88_3
gen occup01=isco

gen isco_stringa=string(isco)
gen isco_stringb=string(isco_3)

 gen isco_3s=substr(isco_stringa, 1, 3)
destring isco_3s, replace
replace isco_3s=isco_3 if isco_3s==.
gen isco_combined=isco_3s
replace isco_combined=. if isco_combined==0
replace isco_combined=. if isco_combined==9999

gen isco_2=substr(isco_stringa, 1, 2)
replace isco_2=substr(isco_stringb, 1, 2) if isco_2=="."
replace isco_2="" if occup01==9995
replace isco_2="" if isco_3==996

merge m:1 isco_2 using "Occupation_GROUPS.dta"


}
order sex age weight
drop V1-mode
drop if country==.


save `temp01', replace
}
if `year_2002'==1 {
********
* 2002 *
********
set more off
use "ZA3880.dta", clear

local main_variables 1
local parties 1
local occupation_recode 1

if `main_variables'==1 {

recode v361 0=., gen(weight)
lab val weight weight
lab var weight "Weight"

gen case=v3
lab var case "Case ID Number"

gen YYYY=2002
lab var YYYY "Survey Year"


gen country=.
replace country=36 if COUNTRY==1
replace country=276 if COUNTRY==2
replace country=276 if COUNTRY==3
replace country=826 if COUNTRY==4
replace country=840 if COUNTRY==6
replace country =40 if COUNTRY==7
replace country =380 if COUNTRY==9
replace country =372 if COUNTRY==10
replace country =528 if COUNTRY==11
replace country=578 if COUNTRY==12
replace country=752 if COUNTRY==13
replace country=554 if COUNTRY==19
replace country=124 if COUNTRY==20
replace country=392 if COUNTRY==24
replace country=724 if COUNTRY==25
replace country=250 if COUNTRY==28
replace country=620 if COUNTRY==30
replace country=208 if COUNTRY==32
replace country =756 if COUNTRY==33
replace country=246 if COUNTRY==37
replace country=56 if COUNTRY==34
lab def country ///
		36 "Australia" ///
40 "Austria" ///
	56 "Belgium" ///
	124 "Canada" ///
	208 "Denmark" ///
	246 "Finland" ///
	250 "France" ///
	276 "Germany" ///
	372 "Ireland" ///
	380 "Italy" ///
	392 "Japan" ///
	528 "Netherlands" ///
	554 "New Zealand" ///
	578 "Norway" ///
	620 "Portugal" ///
	724 "Spain" ///
	752 "Sweden" ///
	756 "Switzerland" ///
	826 "UK" ///
	840 "USA" 
lab val country country
lab var country "Country"
tab country

gen east_germany=1 if COUNTRY==3

recode v200 0=., gen(sex)

gen age = v201
gen birth=2002-age
label var birth "Year of Birth"

gen empl=.
replace empl =2 if v239 ==1
replace empl =2 if v239 ==2
replace empl =1 if v239 ==5
lab def empl ///
	1 "Unemployed" ///
	2 "Employed" 
lab val empl empl
lab var empl "Employment Status - 2"
tab empl

gen employee=.
replace employee =2 if v242 ==4
replace employee =1 if v242 ==1 | v242 ==2 | v242 ==3 | v242 ==5 | v242 ==6
lab def employee ///
	1 "Employed" ///
	2 "Self Employed" 
lab val employee employee
lab var employee "Employee"
tab employee

tab v239
recode v239 0=. 11=1 12=10, gen(emplB)
lab def emplB ///
	1 "Employed FT" ///
	2 "Employed PT" ///
	3 "Less than PT" ///
	4 "Helping Family Member" ///
	5 "Unemployed" ///
	6 "Student" ///
	7 "Retired" ///
	8 "Housewife/man" ///
	9 "Perm. dis" ///
	10 "Not in LF" 
lab val emplB emplB
lab var emplB "Employment Status"
tab emplB

gen education=.
replace education=1 if v205==0
replace education=1 if v205 ==1
replace education=2 if v205 ==2
replace education=3 if v205 ==3
replace education=4 if v205 ==4
replace education=5 if v205 ==5
lab def education ///
	1 "Less than lower secondary" ///
	2 "Lower Secondary" ///
	3 "Upper Secondary" ///
	4 "Vocational" ///
	5 "Degree" 
lab val education education
lab var education "Education Collapsed"
tab education

}

if `parties'==1 {

gen party_type=3 if country==36
replace party_type=3 if country==40 
replace party_type=2 if country==756
replace party_type=1 if country==276
replace party_type=3 if country==208
replace party_type=3 if country==724
replace party_type=2 if country==250
replace party_type=2 if country==826
replace party_type=1 if country==372
replace party_type=2 if country==392
replace party_type=1 if country==528
replace party_type=2 if country==578
replace party_type=2 if country==554
replace party_type=2 if country==752
replace party_type=2 if country==246
replace party_type=2 if country==840

gen vote=v287

gen party=.

replace party=v254 if country==40 & v254<=96
replace party=96 if v254==95
replace party=97 if vote==2 & country==40 & party==.
replace party=99 if v254==.d & country==40  & party==.
replace party=99 if v254==.r & country==40  & party==.


replace party=v255 if country==36 & v255<=95
replace party=7 if v255==5
replace party=96 if v255==95
replace party=99 if v255==.a & country==36



replace party=v262 if country==208 & v262<=96
replace party=96 if v262==95
replace party=97 if v262==96
replace party=97 if vote==2 & country==208 & party==.
replace party=99 if v262==.a &  country==208  & party==.
replace party=99 if v262==.d &  country==208 & party==.


replace party=2 if v261==1 & country==276
replace party=1 if v261==2 & country==276
replace party=4 if v261==3 & country==276
replace party=5 if v261==4 & country==276
replace party=8 if v261==7 & country==276
replace party=9 if v261==8 & country==276
replace party=96 if v261==95 & country==276
replace party=97 if v261==96 & country==276
replace party=99 if v261==.a & country==276
replace party=99 if v261==.n & country==276

replace party=2 if v261==1 & country==276.1
replace party=1 if v261==2 & country==276.1
replace party=4 if v261==3 & country==276.1
replace party=5 if v261==4 & country==276.1
replace party=8 if v261==7 & country==276.1
replace party=9 if v261==8 & country==276.1
replace party=96 if v261==95 & country==276.1
replace party=97 if v261==96 & country==276.1
replace party=99 if v261==.a & country==276.1
replace party=99 if v261==.n & country==276.1


replace party=v282 if country==246 & v282<=96
replace party=96 if v282==95
replace party=99 if v282==96
replace party=99 if v282==.a & country==246
replace party=99 if v282==.n & country==246

replace party=v264 if country==250 & v264<=96
replace party=96 if v264==95
replace party=97 if v264==96
replace party=99 if v264==.a & country==250

replace party=v269 if country==372 & v269<=96
replace party=96 if v269==95
replace party=97 if v269==96
replace party=99 if v269==.a & country==372
replace party=99 if v269==.n & country==372


replace party=v274 if country==528 & v274<=5
replace party=8 if v274==6 & country==528
replace party=10 if v274==7 & country==528
replace party=13 if v274==8 & country==528
replace party=15 if v274==9 & country==528
replace party=16 if v274==10 & country==528
replace party=96 if v274==94 & country==528
replace party=96 if v274==95 & country==528
replace party=97 if v274==96 & country==528
replace party=99 if v274==.n & country==528
replace party=99 if v274==.a & country==528


replace party=1 if v270 ==1 & country==392
replace party=9 if v270 ==2 & country==392
replace party=10 if v270 ==3 & country==392
replace party=3 if v270 ==4 & country==392
replace party=4 if v270 ==5 & country==392
replace party=2 if v270 ==6 & country==392
replace party=96 if v270 ==95 & country==392
replace party=97 if v270 ==96 & country==392
replace party=99 if v270 ==.a & country==392
replace party=99 if v270 ==.n & country==392

replace party=12 if v275 ==1 & country==554
replace party=11 if v275 ==2 & country==554
replace party=2 if v275 ==4 & country==554
replace party=3 if v275 ==5 & country==554
replace party=9 if v275 ==6 & country==554
replace party=14 if v275 ==7 & country==554
replace party=96 if v275 ==95 & country==554
replace party=97 if v275 ==96 & country==554
replace party=99 if v275 ==.a & country==554
replace party=99 if v275 ==.n & country==554


replace party=10 if v273 ==1 & country==578
replace party=6 if v273 ==2 & country==578
replace party=1 if v273 ==3 & country==578
replace party=2 if v273 ==4 & country==578
replace party=4 if v273 ==5 & country==578
replace party=3 if v273 ==6 & country==578
replace party=7 if v273 ==7 & country==578
replace party=5 if v273 ==8 & country==578
replace party=96 if v273 ==95 & country==578
replace party=97 if v273 ==96 & country==578
replace party=99 if v273 ==.a & country==578
replace party=99 if v273 ==.n & country==578

replace party=1 if v263 ==1 & country==724
replace party=3 if v263 ==2 & country==724
replace party=4 if v263 ==3 & country==724
replace party=5 if v263 ==4 & country==724
replace party=5 if v263 ==5 & country==724
replace party=6 if v263 ==6 & country==724
replace party=5 if v263 ==7 & country==724
replace party=6 if v263 ==8 & country==724
replace party=6 if v263 ==9 & country==724
replace party=7 if v263 ==10 & country==724
replace party=6 if v263 ==11 & country==724
replace party=6 if v263 ==12 & country==724
replace party=99 if v263 ==94 & country==724
replace party=96 if v263 ==95 & country==724
replace party=97 if v263 ==96 & country==724
replace party=99 if v263 ==.a & country==724
replace party=99 if v263 ==.n & country==724

replace party=2 if v258 ==1 & country==756
replace party=7 if v258 ==2 & country==756
replace party=1 if v258 ==3 & country==756
replace party=3 if v258 ==4 & country==756
replace party=4 if v258 ==5 & country==756
replace party=6 if v258 ==7 & country==756
replace party=8 if v258 ==8 & country==756
replace party=15 if v258 ==9 & country==756
replace party=10 if v258 ==10 & country==756
replace party=96 if v258 ==95 & country==756
replace party=97 if v258 ==96 & country==756
replace party=99 if v258 ==.a & country==756
replace party=99 if v258 ==.n & country==756

replace party=1 if v266 ==1 & country==826
replace party=2 if v266 ==2 & country==826
replace party=3 if v266 ==3 & country==826
replace party=4 if v266 ==6 & country==826
replace party=5 if v266 ==7 & country==826
replace party=6 if v266 ==8 & country==826
replace party=7 if v266==4 | v266==5 | v266>=9 & v266<=12
replace party=96 if v266 ==13 |v266 ==14 | v266 ==95
replace party=97 if v266==96
replace party=99 if v266==93
replace party=99 if v266 ==.a & country==826
replace party=99 if v266 ==.n & country==826

replace party=v281 if country==752 & v281<=96
replace party=96 if v281 ==95
replace party=97 if v281 ==96
replace party=99 if v281 ==.a & country==752
replace party=99 if v281 ==.n & country==752

replace party =v286 if country == 840 & v286<=96
replace party =96 if v286 ==95 & country == 840
replace party=99 if v286 ==.a & country==840

lab val party party
lab var party "Party Choice"
tab party

}

if `occupation_recode'==1 {
gen isco= v241
gen occup02=isco
gen isco_string=string(occup02)
gen isco_3s=substr(isco_string, 1, 3)
destring isco_3s, replace
gen isco_combined=isco_3s
replace isco_combined=isco_3 if isco_combined==.
replace isco_combined=isco_3 if isco_combined==.
replace isco_combined=. if isco_combined==0
replace isco_combined=. if isco_combined==9999

gen isco_2=substr(isco_string, 1, 2)

merge m:1 isco_2 using "Occupation_GROUPS.dta"

}

drop v*
drop if country==.
drop C_ALPHAN COUNTRY

save `temp02', replace
}
if `year_2003'==1 {
********
* 2003 *
********
use "ZA3910.dta", clear
set more off
local main_variables 1
local parties 1
local occupation_recode 1

if `main_variables'==1 {

gen case=V3
lab var case "Case ID Number"

gen YYYY=2003
lab var YYYY "Survey Year"

recode weight 0=.
lab val weight weight
lab var weight "Weight"

gen country=.
replace country=36 if COUNTRY==1
replace country=276 if COUNTRY==2
replace country=276 if COUNTRY==3
replace country=826 if COUNTRY==4
replace country=840 if COUNTRY==6
replace country =40 if COUNTRY==7
replace country =380 if COUNTRY==9
replace country =372 if COUNTRY==10
replace country =528 if COUNTRY==11
replace country=578 if COUNTRY==12
replace country=752 if COUNTRY==13
replace country=554 if COUNTRY==19
replace country=124 if COUNTRY==20
replace country=392 if COUNTRY==24
replace country=724 if COUNTRY==25
replace country=250 if COUNTRY==28
replace country=620 if COUNTRY==30
replace country=208 if COUNTRY==32
replace country =756 if COUNTRY==33
replace country=246 if COUNTRY==37
replace country=56 if COUNTRY==34
lab def country ///
		36 "Australia" ///
40 "Austria" ///
	56 "Belgium" ///
	124 "Canada" ///
	208 "Denmark" ///
	246 "Finland" ///
	250 "France" ///
	276 "Germany" ///
	372 "Ireland" ///
	380 "Italy" ///
	392 "Japan" ///
	528 "Netherlands" ///
	554 "New Zealand" ///
	578 "Norway" ///
	620 "Portugal" ///
	724 "Spain" ///
	752 "Sweden" ///
	756 "Switzerland" ///
	826 "UK" ///
	840 "USA" 
lab val country country
lab var country "Country"
tab country

gen east_germany=1 if COUNTRY==3


recode sex 0=.

gen birth=2003-age
label var birth "Year of Birth"

gen empl=.
replace empl =2 if wrkst ==1
replace empl =2 if wrkst ==2
replace empl =1 if wrkst ==5
lab def empl ///
	1 "Unemployed" ///
	2 "Employed" 
lab val empl empl
lab var empl "Employment Status - 2"
tab empl

gen employee=.
replace employee =2 if wrktype ==4
replace employee =1 if wrktype ==1 | wrktype ==2 | wrktype ==3 | wrktype ==5 | wrktype ==6
lab def employee ///
	1 "Employed" ///
	2 "Self Employed" 
lab val employee employee
lab var employee "Employee"
tab employee


tab wrkst
recode wrkst 0=. 11=1 12=10, gen(emplB)
lab def emplB ///
	1 "Employed FT" ///
	2 "Employed PT" ///
	3 "Less than PT" ///
	4 "Helping Family Member" ///
	5 "Unemployed" ///
	6 "Student" ///
	7 "Retired" ///
	8 "Housewife/man" ///
	9 "Perm. dis" ///
	10 "Not in LF" 
lab val emplB emplB
lab var emplB "Employment Status"
tab emplB

gen education=.
replace education=1 if degree==0
replace education=1 if degree ==1
replace education=2 if degree ==2
replace education=3 if degree ==3
replace education=4 if degree ==4
replace education=5 if degree ==5
lab def education ///
	1 "Less than lower secondary" ///
	2 "Lower Secondary" ///
	3 "Upper Secondary" ///
	4 "Vocational" ///
	5 "Degree" 
lab val education education
lab var education "Education Collapsed"
tab education

}

if `parties'==1 {

gen party_type=1 

gen vote=vote_le

gen party=.

replace party=at_prty if country==40 & at_prty<=96
replace party=96 if at_prty==95
replace party=97 if at_prty==96
replace party=99 if at_prty==.a & country==40
replace party=99 if at_prty==.r & country==40
replace party=99 if at_prty==.n & country==40

replace party=au_prty if country==36 & au_prty<=96
replace party=7 if au_prty==5
replace party=8 if au_prty==6
replace party=96 if au_prty==95
replace party=97 if au_prty==96
replace party=99 if au_prty==.a & country==36
replace party=99 if au_prty==.r & country==36
replace party=99 if au_prty==.n & country==36

replace party=3 if ca_prty==1
replace party=2 if ca_prty==2
replace party=1 if ca_prty==3
replace party=4 if ca_prty==4
replace party=96 if ca_prty==95
replace party=97 if ca_prty==96
replace party=99 if ca_prty==.a & country==124
replace party=99 if ca_prty==.r & country==124
replace party=99 if ca_prty==.n & country==124

replace party=dk_prty if country==208  & dk_prty<=96
replace party=96 if dk_prty==95
replace party=97 if dk_prty==96
replace party=99 if dk_prty==.a & country==208
replace party=99 if dk_prty==.r & country==208
replace party=99 if dk_prty==.n & country==208


replace party=2 if de_prty==1 & country==276
replace party=1 if de_prty==2 & country==276
replace party=4 if de_prty==3 & country==276
replace party=5 if de_prty==4 & country==276
replace party=8 if de_prty==7 & country==276
replace party=9 if de_prty==8 & country==276
replace party=96 if de_prty==95 & country==276
replace party=97 if de_prty==96 & country==276
replace party=99 if de_prty==.a & country==276
replace party=99 if de_prty==.r & country==276
replace party=99 if de_prty==.n & country==276


replace party=2 if de_prty==1 & country==276.1
replace party=1 if de_prty==2 & country==276.1
replace party=4 if de_prty==3 & country==276.1
replace party=5 if de_prty==4 & country==276.1
replace party=8 if de_prty==7 & country==276.1
replace party=9 if de_prty==8 & country==276.1
replace party=96 if de_prty==95 & country==276.1
replace party=97 if de_prty==96 & country==276.1
replace party=99 if de_prty==.a & country==276.1
replace party=99 if de_prty==.r & country==276.1
replace party=99 if de_prty==.n & country==276.1


replace party=fi_prty if country==246 & fi_prty<=96
replace party=96 if fi_prty==95
replace party=97 if fi_prty==96
replace party=99 if fi_prty==.a & country==246
replace party=99 if fi_prty==.r & country==246
replace party=99 if fi_prty==.n & country==246

replace party=fr_prty if country==250 & fr_prty<=96
replace party=2 if fr_prty==1
replace party=1 if fr_prty==2
replace party=96 if fr_prty==95
replace party=97 if fr_prty==96
replace party=99 if fr_prty==.a & country==250
replace party=99 if fr_prty==.r & country==250
replace party=99 if fr_prty==.n & country==250

replace party=ie_prty if country==372 & ie_prty<=96
replace party=5 if ie_prty==4
replace party=6 if ie_prty==5
replace party=11 if ie_prty==6
replace party=96 if ie_prty==95
replace party=99 if ie_prty==96
replace party=99 if ie_prty==.a & country==250
replace party=99 if ie_prty==.r & country==250
replace party=99 if ie_prty==.n & country==250

replace party=1 if jp_prty ==1 & country==392
replace party=9 if jp_prty ==2 & country==392
replace party=3 if jp_prty ==4 & country==392
replace party=4 if jp_prty ==5 & country==392
replace party=2 if jp_prty ==6 & country==392
replace party=96 if jp_prty ==95 & country==392
replace party=97 if jp_prty ==96 & country==392
replace party=99 if jp_prty==.a & country==392
replace party=99 if jp_prty==.r & country==392
replace party=99 if jp_prty==.n & country==392


replace party=nl_prty if country==528 & nl_prty<=96
replace party=96 if nl_prty==95 & country==528
replace party=97 if nl_prty==96 & country==528
replace party=99 if nl_prty==.a & country==528
replace party=99 if nl_prty==.r & country==528
replace party=99 if nl_prty==.n & country==528


replace party=8 if pt_prty==1 & country==620 
replace party=1 if pt_prty==2 & country==620 
replace party=2 if pt_prty==3 & country==620 
replace party=4 if pt_prty==5 & country==620 
replace party=5 if pt_prty==6 & country==620 
replace party=6 if pt_prty==7 & country==620 
replace party=7 if pt_prty==8 & country==620 
replace party=96 if pt_prty==95 & country==620 
replace party=97 if pt_prty==96 & country==620 
replace party=99 if pt_prty==.a & country==620
replace party=99 if pt_prty==.r & country==620
replace party=99 if pt_prty==.n & country==620


replace party=12 if nz_prty ==1 & country==554
replace party=11 if nz_prty ==2 & country==554
replace party=1 if nz_prty ==3 & country==554
replace party=2 if nz_prty ==4 & country==554
replace party=3 if nz_prty ==5 & country==554
replace party=9 if nz_prty ==6 & country==554
replace party=15 if nz_prty ==7 & country==554
replace party=14 if nz_prty ==8 & country==554
replace party=99 if nz_prty ==9 & country==554
replace party=99 if nz_prty ==96 & country==554
replace party=99 if nz_prty==.a & country==554
replace party=99 if nz_prty==.r & country==554
replace party=99 if nz_prty==.n & country==554


replace party=10 if no_prty ==1 & country==578
replace party=6 if no_prty ==2 & country==578
replace party=1 if no_prty ==3 & country==578
replace party=2 if no_prty ==4 & country==578
replace party=4 if no_prty ==5 & country==578
replace party=3 if no_prty ==6 & country==578
replace party=7 if no_prty ==7 & country==578
replace party=5 if no_prty ==8 & country==578
replace party=96 if no_prty ==95 & country==578
replace party=97 if no_prty ==96 & country==578
replace party=99 if no_prty==.a & country==578
replace party=99 if no_prty==.r & country==578
replace party=99 if no_prty==.n & country==578

replace party=1 if es_prty ==1 & country==724
replace party=3 if es_prty ==2 & country==724
replace party=4 if es_prty ==3 & country==724
replace party=5 if es_prty ==4 & country==724
replace party=6 if es_prty ==5 & country==724
replace party=7 if es_prty ==6 & country==724
replace party=99 if es_prty ==94 & country==724
replace party=95 if es_prty ==95 & country==724
replace party=97 if es_prty ==96 & country==724
replace party=99 if es_prty==.a & country==724
replace party=99 if es_prty==.r & country==724
replace party=99 if es_prty==.n & country==724

replace party=2 if ch_prty ==1 & country==756
replace party=7 if ch_prty ==2 & country==756
replace party=1 if ch_prty ==3 & country==756
replace party=3 if ch_prty ==4 & country==756
replace party=4 if ch_prty ==5 & country==756
replace party=6 if ch_prty ==7 & country==756
replace party=8 if ch_prty ==8 & country==756
replace party=15 if ch_prty ==9 & country==756
replace party=10 if ch_prty ==10 & country==756
replace party=96 if ch_prty ==95 & country==756
replace party=97 if ch_prty ==96 & country==756
replace party=99 if ch_prty==.a & country==756
replace party=99 if ch_prty==.r & country==756
replace party=99 if ch_prty==.n & country==756

replace party=1 if gb_prty ==1 & country==826
replace party=2 if gb_prty ==2 & country==826
replace party=3 if gb_prty ==3 & country==826
replace party=4 if gb_prty ==6 & country==826
replace party=5 if gb_prty ==7 & country==826
replace party=96 if gb_prty ==95
replace party=97 if gb_prty==96
replace party=99 if gb_prty==93
replace party=99 if gb_prty==.a & country==826
replace party=99 if gb_prty==.r & country==826
replace party=99 if gb_prty==.n & country==826

replace party=se_prty if country==752 & se_prty<=96
replace party=96 if se_prty ==95
replace party=97 if se_prty ==96
replace party=99 if se_prty==.a & country==752
replace party=99 if se_prty==.r & country==752
replace party=99 if se_prty==.n & country==752

replace party =us_prty if country == 840
replace party =96 if us_prty ==95 & country == 840
replace party=99 if us_prty==.a & country==752
replace party=99 if us_prty==.r & country==752
replace party=99 if us_prty==.n & country==752

lab val party party
lab var party "Party Choice"
tab party
}

if `occupation_recode'==1 {

gen isco= isco88
gen occup03=isco
gen isco_string=string(occup03)
 gen isco_3s=substr(isco_string, 1, 3)
destring isco_3s, replace
gen isco_combined=isco_3s
replace isco_combined=isco_3 if isco_combined==.
replace isco_combined=isco_3 if isco_combined==.
replace isco_combined=. if isco_combined==0
replace isco_combined=. if isco_combined==9999

gen isco_2=substr(isco_string, 1, 2)

merge m:1 isco_2 using "Occupation_GROUPS.dta"
}

order sex age weight
drop v1-spis88_1
drop if country==.

save `temp03', replace
}
if `year_2004'==1 {
********
* 2004 *
********
use "ZA3950.dta", clear

local main_variables 1
local parties 1
local occupation_recode 1

if `main_variables'==1 {

gen case=v3
lab var case "Case ID Number"

gen YYYY=2004
lab var YYYY "Survey Year"

recode v381 0=., gen(weight)
lab val weight weight
lab var weight "Weight"


gen country=.
replace country=36 if COUNTRY==1
replace country=276 if COUNTRY==2
replace country=276 if COUNTRY==3
replace country=826 if COUNTRY==4
replace country=840 if COUNTRY==6
replace country =40 if COUNTRY==7
replace country =380 if COUNTRY==9
replace country =372 if COUNTRY==10
replace country =528 if COUNTRY==11
replace country=578 if COUNTRY==12
replace country=752 if COUNTRY==13
replace country=554 if COUNTRY==19
replace country=124 if COUNTRY==20
replace country=392 if COUNTRY==24
replace country=724 if COUNTRY==25
replace country=250 if COUNTRY==28
replace country=620 if COUNTRY==30
replace country=208 if COUNTRY==32
replace country =756 if COUNTRY==33
replace country=246 if COUNTRY==37
replace country=56 if COUNTRY==34
lab def country ///
	36 "Australia" ///
	40 "Austria" ///
	56 "Belgium" ///
	124 "Canada" ///
	208 "Denmark" ///
	246 "Finland" ///
	250 "France" ///
	276 "Germany" ///
	372 "Ireland" ///
	380 "Italy" ///
	392 "Japan" ///
	528 "Netherlands" ///
	554 "New Zealand" ///
	578 "Norway" ///
	620 "Portugal" ///
	724 "Spain" ///
	752 "Sweden" ///
	756 "Switzerland" ///
	826 "UK" ///
	840 "USA" 
lab val country country
lab var country "Country"
tab country

gen east_germany=1 if COUNTRY==3

recode v200 0=., gen(sex)


gen age = v201
gen birth=2004-age
label var birth "Year of Birth"

gen empl=.
replace empl =2 if v244 ==1
replace empl =2 if v244 ==2
replace empl =1 if v244 ==5
lab def empl ///
	1 "Unemployed" ///
	2 "Employed" 
lab val empl empl
lab var empl "Employment Status - 2"
tab empl

gen employee=.
replace employee =2 if v247 ==4
replace employee =1 if v247 ==1 | v247 ==2 | v247 ==3 | v247 ==5 | v247 ==6
lab def employee ///
	1 "Employed" ///
	2 "Self Employed" 
lab val employee employee
lab var employee "Employee"
tab employee

tab v244
recode v244 0=. 11=1 12=10, gen(emplB)
lab def emplB ///
	1 "Employed FT" ///
	2 "Employed PT" ///
	3 "Less than PT" ///
	4 "Helping Family Member" ///
	5 "Unemployed" ///
	6 "Student" ///
	7 "Retired" ///
	8 "Housewife/man" ///
	9 "Perm. dis" ///
	10 "Not in LF" 
lab val emplB emplB
lab var emplB "Employment Status"
tab emplB


gen education=.
replace education=1 if v205==0
replace education=1 if v205 ==1
replace education=2 if v205 ==2
replace education=3 if v205 ==3
replace education=4 if v205 ==4
replace education=5 if v205 ==5
lab def education ///
	1 "Less than lower secondary" ///
	2 "Lower Secondary" ///
	3 "Upper Secondary" ///
	4 "Vocational" ///
	5 "Degree" 
lab val education education
lab var education "Education Collapsed"
tab education
}

if `parties'==1 {

gen party_type=3 if country==40
replace party_type=2 if country==36
replace party_type=2 if country==124
replace party_type=2 if country==756
replace party_type=1 if country==276
replace party_type=3 if country==208
replace party_type=3 if country==724
replace party_type=1 if country==246
replace party_type=2 if country==250
replace party_type=1 if country==826
replace party_type=2 if country==372
replace party_type=2 if country==392
replace party_type=3 if country==528
replace party_type=1 if country==578
replace party_type=2 if country==752
replace party_type=2 if country==620
replace party_type=2 if country==840
replace party_type=3 if country==554

gen vote=v297


gen party=.
replace party=v259 if country==40  & v259<=96
replace party=96 if v259==95
replace party=96 if vote==2 & country==40 & party==.
replace party=99 if v259==.a & country==40 & party==.
replace party=99 if v259==.n & country==40 & party==.

replace party=v260 if country==36 & v260<96
replace party=7 if v260==5
replace party=8 if v260==6
replace party=9 if v260==7
replace party=96 if v260==95
replace party=97 if v260==96
replace party=99 if v260==.n & country==36 & party==.

replace party=3 if v263==1
replace party=2 if v263==2
replace party=1 if v263==3
replace party=4 if v263==4
replace party=96 if v263==95
replace party=97 if v263==96
replace party=99 if v263==.n & country==124 & party==.

replace party=v269 if country==208  & v269<96
replace party=10 if v269==9
replace party=11 if v269==10
replace party=96 if v269==95
replace party=97 if v269==96
replace party=99 if v269==.n & country==208 & party==.


replace party=2 if v268==1 & country==276
replace party=1 if v268==2 & country==276
replace party=4 if v268==3 & country==276
replace party=5 if v268==4 & country==276
replace party=8 if v268==5 & country==276
replace party=9 if v268==6 & country==276
replace party=96 if v268==95 & country==276
replace party=97 if v268==96 & country==276
replace party=99 if v268==.n & country==276 & party==.

replace party=2 if v268==1 & country==276.1
replace party=1 if v268==2 & country==276.1
replace party=4 if v268==3 & country==276.1
replace party=5 if v268==4 & country==276.1
replace party=8 if v268==5 & country==276.1
replace party=9 if v268==6 & country==276.1
replace party=96 if v268==95 & country==276.1
replace party=97 if v268==96 & country==276.1
replace party=99 if v268==.n & country==276.1 & party==.



replace party=v271 if country==246 & v271<=96
replace party=96 if v271==95
replace party=97 if v271==96
replace party=99 if v271==.n & country==246 & party==.

replace party=v273 if country==250 & v273<=96
replace party=96 if v273==95
replace party=97 if v273==96
replace party=99 if v273==.n & country==250 & party==.

replace party=v276 if country==372 & v276<=96
replace party=5 if v276==4
replace party=6 if v276==5
replace party=11 if v276==6
replace party=96 if v276==95
replace party=97 if v276==96
replace party=99 if v276==.n & country==372 & party==.

replace party=1 if v278 ==1 & country==392
replace party=9 if v278 ==2 & country==392
replace party=3 if v278 ==4 & country==392
replace party=4 if v278 ==5 & country==392
replace party=2 if v278 ==6 & country==392
replace party=96 if v278 ==95 & country==392
replace party=97 if v278 ==96 & country==392
replace party=99 if v278==.n & country==392 & party==.


replace party=v282 if country==528 &  v282<=96
replace party=96 if v282==95 & country==528
replace party=97 if v282==96 & country==528
replace party=99 if v282==.n & country==528 & party==.


replace party=8 if v287==1 & country==620 
replace party=1 if v287==2 & country==620 
replace party=2 if v287==3 & country==620 
replace party=4 if v287==5 & country==620 
replace party=5 if v287==6 & country==620 
replace party=6 if v287==7 & country==620 
replace party=7 if v287==8 & country==620 
replace party=96 if v287==95 & country==620 
replace party=97 if v287==96 & country==620 
replace party=99 if v287==.n & country==620 & party==.


replace party=12 if v284 ==1 & country==554
replace party=11 if v284 ==2 & country==554
replace party=1 if v284 ==3 & country==554
replace party=2 if v284 ==4 & country==554
replace party=3 if v284 ==5 & country==554
replace party=9 if v284 ==6 & country==554
replace party=15 if v284 ==7 & country==554
replace party=14 if v284 ==8 & country==554
replace party=96 if v284 ==9 & country==554
replace party=97 if v284 ==96 & country==554
replace party=99 if v284==.n & country==554 & party==.


replace party=10 if v283 ==1 & country==578
replace party=6 if v283 ==2 & country==578
replace party=1 if v283 ==3 & country==578
replace party=2 if v283 ==4 & country==578
replace party=4 if v283 ==5 & country==578
replace party=3 if v283 ==6 & country==578
replace party=7 if v283 ==7 & country==578
replace party=5 if v283 ==8 & country==578
replace party=96 if v283 ==95 & country==578
replace party=97 if v283 ==96 & country==578
replace party=99 if v283==.n & country==578 & party==.

replace party=3 if v270 ==1 & country==724
replace party=1 if v270 ==2 & country==724
replace party=4 if v270 ==3 & country==724
replace party=5 if v270 ==4 & country==724
replace party=6 if v270 ==5 & country==724
replace party=5 if v270 ==6 & country==724
replace party=6 if v270 ==7 & country==724
replace party=5 if v270 ==8 & country==724
replace party=6 if v270 ==9 & country==724
replace party=6 if v270 ==10 & country==724
replace party=6 if v270 ==11 & country==724
replace party=99 if v270 ==94 & country==724
replace party=97 if v270 ==95 & country==724
replace party=99 if v270==.n & country==724 & party==.

replace party=2 if v264 ==1 & country==756
replace party=7 if v264 ==2 & country==756
replace party=1 if v264 ==3 & country==756
replace party=3 if v264 ==4 & country==756
replace party=4 if v264 ==5 & country==756
replace party=6 if v264 ==7 & country==756
replace party=8 if v264 ==8 & country==756
replace party=15 if v264 ==9 & country==756
replace party=10 if v264 ==10 & country==756
replace party=13 if v264 ==11 & country==756
replace party=96 if v264 ==95 & country==756
replace party=97 if v264 ==96 & country==756
replace party=99 if v264==.n & country==756 & party==.

replace party=1 if v274 ==1 & country==826
replace party=2 if v274 ==2 & country==826
replace party=3 if v274 ==3 & country==826
replace party=4 if v274 ==6 & country==826
replace party=5 if v274 ==7 & country==826
replace party=6 if v274 ==8 & country==826
replace party=96 if v274 ==95
replace party=97 if v274==96
replace party=99 if v274==93
replace party=99 if v274==.n & country==826 & party==.


replace party=v289 if country==752 & v289<=96
replace party=96 if v289 ==95
replace party=97 if v289 ==96
replace party=99 if v289==.n & country==752 & party==.

replace party =v293 if country == 840 & v293<=96
replace party =96 if v293 ==95 & country == 840
replace party=99 if v293==.n & country==840 & party==.


foreach var of varlist v259 v260 v263 v264 v268 v269 ///
 v270 v271 v272 v273 v274 v276 v278 v282 v283 v284 v289 v293 {
 replace party=99 if `var'==.a
 }

lab val party party
lab var party "Party Choice"
tab party

}

if `occupation_recode'==1 {
gen isco= v246

gen occup04=isco
recode occup04 9995=.
gen isco_string=string(occup04)
 gen isco_3s=substr(isco_string, 1, 3)
destring isco_3s, replace
gen isco_combined=isco_3s
replace isco_combined=isco_3 if isco_combined==.
replace isco_combined=isco_3 if isco_combined==.
replace isco_combined=. if isco_combined==0
replace isco_combined=. if isco_combined==9999
gen isco_2=substr(isco_string, 1, 2)

merge m:1 isco_2 using "Occupation_GROUPS.dta"
}

drop v1-v381
drop if country==.


save `temp04', replace

}
if `year_2005'==1 { 
********
* 2005 *
********
use "ZA4350.dta", clear

local main_variables 1
local parties 1
local occupation_recode 1

if `main_variables'==1 {


gen YYYY=2005
lab var YYYY "Survey Year"

gen case=V3
lab var case "Case ID Number"

gen weight=WEIGHT
recode weight 0=.
lab val weight weight
lab var weight "Weight"


gen country=.
replace country=36 if COUNTRY==1
replace country=276 if COUNTRY==2
replace country=276 if COUNTRY==3
replace country=826 if COUNTRY==4
replace country=840 if COUNTRY==6
replace country =40 if COUNTRY==7
replace country =380 if COUNTRY==9
replace country =372 if COUNTRY==10
replace country =528 if COUNTRY==11
replace country=578 if COUNTRY==12
replace country=752 if COUNTRY==13
replace country=554 if COUNTRY==19
replace country=124 if COUNTRY==20
replace country=392 if COUNTRY==24
replace country=724 if COUNTRY==25
replace country=250 if COUNTRY==28
replace country=620 if COUNTRY==30
replace country=208 if COUNTRY==32
replace country =756 if COUNTRY==33
replace country=246 if COUNTRY==37
replace country=56 if COUNTRY==34
lab def country ///
		36 "Australia" ///
40 "Austria" ///
	56 "Belgium" ///
	124 "Canada" ///
	208 "Denmark" ///
	246 "Finland" ///
	250 "France" ///
	276 "Germany" ///
	372 "Ireland" ///
	380 "Italy" ///
	392 "Japan" ///
	528 "Netherlands" ///
	554 "New Zealand" ///
	578 "Norway" ///
	620 "Portugal" ///
	724 "Spain" ///
	752 "Sweden" ///
	756 "Switzerland" ///
	826 "UK" ///
	840 "USA" 
lab val country country
lab var country "Country"
tab country

gen east_germany=1 if COUNTRY==3


gen sex=SEX
recode sex 0=.

gen age=AGE

gen birth=2005-age
label var birth "Year of Birth"


gen empl=.
replace empl =2 if WRKST ==1
replace empl =2 if WRKST ==2
replace empl =1 if WRKST ==5
lab def empl ///
	1 "Unemployed" ///
	2 "Employed" 
lab val empl empl
lab var empl "Employment Status - 2"
tab empl

gen employee=.
replace employee =2 if WRKTYPE ==4
replace employee =1 if WRKTYPE ==1 | WRKTYPE ==2 | WRKTYPE ==3 | WRKTYPE ==5 | WRKTYPE ==6
lab def employee ///
	1 "Employed" ///
	2 "Self Employed" 
lab val employee employee
lab var employee "Employee"
tab employee

tab WRKST
recode WRKST 0=. 11=1 12=10, gen(emplB)
lab def emplB ///
	1 "Employed FT" ///
	2 "Employed PT" ///
	3 "Less than PT" ///
	4 "Helping Family Member" ///
	5 "Unemployed" ///
	6 "Student" ///
	7 "Retired" ///
	8 "Housewife/man" ///
	9 "Perm. dis" ///
	10 "Not in LF" 
lab val emplB emplB
lab var emplB "Employment Status"
tab emplB

gen education=.
replace education=1 if DEGREE==0
replace education=1 if DEGREE ==1
replace education=2 if DEGREE ==2
replace education=3 if DEGREE ==3
replace education=4 if DEGREE ==4
replace education=5 if DEGREE ==5
lab def education ///
	1 "Less than lower secondary" ///
	2 "Lower Secondary" ///
	3 "Upper Secondary" ///
	4 "Vocational" ///
	5 "Degree" 
lab val education education
lab var education "Education Collapsed"
tab education
}

if `parties'==1 {

gen party_type=.
replace party_type=2 if country==36
replace party_type=2 if country==124
replace party_type=2 if country==756
replace party_type=1 if country==276
replace party_type=3 if country==208
replace party_type=2 if country==724
replace party_type=1 if country==246
replace party_type=2 if country==250
replace party_type=1 if country==826
replace party_type=2 if country==372
replace party_type=2 if country==392
replace party_type=1 if country==528
replace party_type=1 if country==578
replace party_type=2 if country==554
replace party_type=2 if country==620
replace party_type=2 if country==752
replace party_type=2 if country==840

gen vote=VOTE_LE



gen party=.
replace party=AU_PRTY if country==36 & AU_PRTY<=96
replace party=7 if AU_PRTY==5
replace party=8 if AU_PRTY==6
replace party=9 if AU_PRTY==7
replace party=96 if AU_PRTY==95
replace party=97 if AU_PRTY==96
replace party=99 if AU_PRTY==.a & country==36 | AU_PRTY==.n & country==36

replace party=CA_PRTY if country==124 & CA_PRTY<=96
replace party=96 if CA_PRTY==95
replace party=97 if CA_PRTY==96
replace party=99 if CA_PRTY==.a & country==124 | CA_PRTY==.n & country==124

replace party=DK_PRTY if country==208  & DK_PRTY<=5
replace party=96 if DK_PRTY==6
replace party=6 if DK_PRTY==7
replace party=7 if DK_PRTY==8
replace party=9 if DK_PRTY==9
replace party=10 if DK_PRTY==10
replace party=11 if DK_PRTY==11
replace party=96 if DK_PRTY==95
replace party=97 if DK_PRTY==96
replace party=99 if DK_PRTY==93
replace party=99 if DK_PRTY==.a & country==208 | DK_PRTY==.n & country==208


replace party=2 if DE_PRTY==1 & country==276
replace party=1 if DE_PRTY==2 & country==276
replace party=4 if DE_PRTY==3 & country==276
replace party=5 if DE_PRTY==4 & country==276
replace party=10 if DE_PRTY==5 & country==276
replace party=8 if DE_PRTY==7 & country==276
replace party=9 if DE_PRTY==8 & country==276
replace party=96 if DE_PRTY==95 & country==276
replace party=97 if DE_PRTY==96 & country==276
replace party=99 if DE_PRTY==.a & country==276 | DE_PRTY==.n & country==276


replace party=2 if DE_PRTY==1 & country==276.1
replace party=1 if DE_PRTY==2 & country==276.1
replace party=4 if DE_PRTY==3 & country==276.1
replace party=5 if DE_PRTY==4 & country==276.1
replace party=10 if DE_PRTY==5 & country==276.1
replace party=8 if DE_PRTY==7 & country==276.1
replace party=9 if DE_PRTY==8 & country==276.1
replace party=96 if DE_PRTY==95 & country==276.1
replace party=97 if DE_PRTY==96 & country==276.1
replace party=99 if DE_PRTY==.a & country==276.1 | DE_PRTY==.n & country==276.1



replace party=FI_PRTY if country==246 & FI_PRTY<=96
replace party=96 if FI_PRTY==95
replace party=96 if FI_PRTY==96
replace party=99 if FI_PRTY==.a & country==246 | FI_PRTY==.n & country==246

replace party=FR_PRTY if country==250 & FR_PRTY<=96
replace party=96 if FR_PRTY==95
replace party=97 if FR_PRTY==96
replace party=99 if FR_PRTY==.a & country==250 | FR_PRTY==.n & country==250

replace party=IE_PRTY if country==372 & IE_PRTY<=96
replace party=96 if IE_PRTY==95
replace party=97 if IE_PRTY==96
replace party=99 if IE_PRTY==.a & country==372 | IE_PRTY==.n & country==372

replace party=1 if JP_PRTY ==1 & country==392
replace party=9 if JP_PRTY ==2 & country==392
replace party=3 if JP_PRTY ==4 & country==392
replace party=4 if JP_PRTY ==5 & country==392
replace party=2 if JP_PRTY ==6 & country==392
replace party=96 if JP_PRTY ==95 & country==392
replace party=97 if JP_PRTY ==96 & country==392
replace party=99 if JP_PRTY==.a & country==392 | JP_PRTY==.n & country==392


replace party=3 if NL_PRTY==1 &  country==528 
replace party=1 if NL_PRTY==2 &  country==528 
replace party=2 if NL_PRTY==3 &  country==528 
replace party=10 if NL_PRTY==4 &  country==528 
replace party=8 if NL_PRTY==5 &  country==528 
replace party=13 if NL_PRTY==6 &  country==528 
replace party=4 if NL_PRTY==7 &  country==528 
replace party=14 if NL_PRTY==8 &  country==528 
replace party=15 if NL_PRTY==9 &  country==528 
replace party=5 if NL_PRTY==10 &  country==528 
replace party=96 if NL_PRTY==11 &  country==528 
replace party=97 if NL_PRTY==96 &  country==528 
replace party=99 if NL_PRTY==.a & country==528 | NL_PRTY==.n & country==528


replace party=8 if PT_PRTY==1 & country==620 
replace party=1 if PT_PRTY==2 & country==620 
replace party=2 if PT_PRTY==3 & country==620 
replace party=10 if PT_PRTY==4 & country==620 
replace party=11 if PT_PRTY==5 & country==620 
replace party=12 if PT_PRTY==6 & country==620 
replace party=14 if PT_PRTY==8 & country==620 
replace party=4 if PT_PRTY==10 & country==620 
replace party=5 if PT_PRTY==11 & country==620 
replace party=96 if PT_PRTY==95 & country==620 
replace party=97 if PT_PRTY==96 & country==620 
replace party=99 if PT_PRTY==.a & country==620 | PT_PRTY==.n & country==620


replace party=12 if NZ_PRTY ==1 & country==554
replace party=11 if NZ_PRTY ==2 & country==554
replace party=1 if NZ_PRTY ==3 & country==554
replace party=2 if NZ_PRTY ==4 & country==554
replace party=3 if NZ_PRTY ==5 & country==554
replace party=9 if NZ_PRTY ==6 & country==554
replace party=15 if NZ_PRTY ==7 & country==554
replace party=14 if NZ_PRTY ==8 & country==554
replace party=16 if NZ_PRTY ==9 & country==554
replace party=96 if NZ_PRTY ==95 & country==554
replace party=97 if NZ_PRTY ==96 & country==554
replace party=99 if NZ_PRTY==.a & country==554 | NZ_PRTY==.n & country==554


replace party=10 if NO_PRTY ==1 & country==578
replace party=6 if NO_PRTY ==2 & country==578
replace party=1 if NO_PRTY ==3 & country==578
replace party=2 if NO_PRTY ==4 & country==578
replace party=4 if NO_PRTY ==5 & country==578
replace party=3 if NO_PRTY ==6 & country==578
replace party=7 if NO_PRTY ==7 & country==578
replace party=5 if NO_PRTY ==8 & country==578
replace party=96 if NO_PRTY ==95 & country==578
replace party=97 if NO_PRTY ==96 & country==578
replace party=99 if NO_PRTY==.a & country==578 | NO_PRTY==.n & country==578

replace party=1 if ES_PRTY ==1 & country==724
replace party=3 if ES_PRTY ==2 & country==724
replace party=4 if ES_PRTY ==3 & country==724
replace party=5 if ES_PRTY ==4 & country==724
replace party=6 if ES_PRTY ==5 & country==724
replace party=7 if ES_PRTY ==6 & country==724
replace party=96 if ES_PRTY ==95 & country==724
replace party=96 if ES_PRTY ==8 & country==724
replace party=97 if ES_PRTY ==96 & country==724
replace party=99 if ES_PRTY==.a & country==724 | ES_PRTY==.n & country==724

replace party=2 if CH_PRTY ==1 & country==756
replace party=7 if CH_PRTY ==2 & country==756
replace party=1 if CH_PRTY ==3 & country==756
replace party=3 if CH_PRTY ==4 & country==756
replace party=4 if CH_PRTY ==5 & country==756
replace party=6 if CH_PRTY ==7 & country==756
replace party=8 if CH_PRTY ==8 & country==756
replace party=15 if CH_PRTY ==9 & country==756
replace party=10 if CH_PRTY ==10 & country==756
replace party=13 if CH_PRTY ==11 & country==756
replace party=96 if CH_PRTY ==95 & country==756
replace party=97 if CH_PRTY ==96 & country==756
replace party=99 if CH_PRTY==.a & country==756 | CH_PRTY==.n & country==756

replace party=1 if GB_PRTY ==1 & country==826
replace party=2 if GB_PRTY ==2 & country==826
replace party=3 if GB_PRTY ==3 & country==826
replace party=4 if GB_PRTY ==6 & country==826
replace party=5 if GB_PRTY ==7 & country==826
replace party=6 if GB_PRTY ==8 & country==826
replace party=96 if GB_PRTY ==95
replace party=97 if GB_PRTY==96 
replace party=99 if GB_PRTY==93
replace party=99 if GB_PRTY==.a & country==826 | GB_PRTY==.n & country==826

replace party=SE_PRTY if country==752
replace party=96 if SE_PRTY ==95
replace party=97 if SE_PRTY ==96
replace party=99 if SE_PRTY==.a & country==752 | SE_PRTY==.n & country==752

replace party =US_PRTY if country == 840
replace party =96 if US_PRTY ==95 & country == 840
replace party=99 if US_PRTY==.a & country==840 | US_PRTY==.n & country==840

lab val party party
lab var party "Party Choice"
tab party

}

if `occupation_recode'==1 {
gen isco= ISCO88

gen isco_string=string(isco)
 gen isco_3s=substr(isco_string, 1, 3)
destring isco_3s, replace
gen isco_combined=isco_3s
replace isco_combined=isco_3 if isco_combined==.
replace isco_combined=isco_3 if isco_combined==.
replace isco_combined=. if isco_combined==0
replace isco_combined=. if isco_combined==9999
gen isco_2=substr(isco_string, 1, 2)

merge m:1 isco_2 using "Occupation_GROUPS.dta"



}

drop V*
drop COUNTRY-WEIGHT
drop if country==.

save `temp05', replace
}
if `year_2006'==1 {
********
* 2006 *
********
use "ZA4700.dta", clear

local main_variables 1
local parties 1
local occupation_recode 1

if `main_variables'==1 {


gen case=V2
lab var case "Case ID Number"

gen YYYY=2006
lab var YYYY "Survey Year"

gen weight=WEIGHT
recode weight 0=.
lab val weight weight
lab var weight "Weight"


gen country=.
replace country=36 if V3==36
replace country=124 if V3==124
replace country=208 if V3==208
replace country=246 if V3==246
replace country=250 if V3==250
replace country=276 if V3==276.1
replace country=276 if V3==276.2
replace country=372 if V3==372
replace country=392 if V3==392
replace country=528 if V3==528
replace country=554 if V3==554
replace country=578 if V3==578
replace country=620 if V3==620
replace country=724 if V3==724
replace country=752 if V3==752
replace country=756 if V3==756
replace country=826 if V3==826.1
replace country=840 if V3==840
lab def country ///
	36 "Australia" ///
	124 "Canada" ///
	208 "Denmark" ///
	246 "Finland" ///
	250 "France" ///
	276 "Germany" ///
	372 "Ireland" ///
	392 "Japan" ///
	528 "Netherlands" ///
	554 "New Zealand" ///
	578 "Norway" ///
	620 "Portugal" ///
	724 "Spain" ///
	752 "Sweden" ///
	756 "Switzerland" ///
	826 "UK" ///
	840 "USA" 
lab val country country
lab var country "Country"
tab country

gen east_germany=1 if V3==276.2


gen sex=SEX
recode sex 0=.

gen age=AGE 

gen birth=2006-age
label var birth "Year of Birth"

gen empl=.
replace empl=2 if WRKST ==1
replace empl=2 if WRKST ==2
replace empl=1 if WRKST ==5
lab def empl ///
	1 "Unemployed" ///
	2 "Employed" 
lab val empl empl
lab var empl "Employment Status - 2"
tab empl


gen employee=.
replace employee =2 if WRKTYPE ==4
replace employee =1 if WRKTYPE ==1
replace employee =1 if WRKTYPE ==2
replace employee =1 if WRKTYPE ==3
replace employee =1 if WRKTYPE ==6
lab def employee ///
	1 "Employed" ///
	2 "Self Employed" 
lab val employee employee
lab var employee "Employee"
tab employee

tab WRKST
recode WRKST 0=., gen(emplB)
lab def emplB ///
	1 "Employed FT" ///
	2 "Employed PT" ///
	3 "Less than PT" ///
	4 "Helping Family Member" ///
	5 "Unemployed" ///
	6 "Student" ///
	7 "Retired" ///
	8 "Housewife/man" ///
	9 "Perm. dis" ///
	10 "Not in LF" 
lab val emplB emplB
lab var emplB "Employment Status"
tab emplB

gen education=.
replace education=1 if DEGREE==0
replace education=1 if DEGREE==1
replace education=2 if DEGREE==2
replace education=3 if DEGREE==3
replace education=4 if DEGREE==4
replace education=5 if DEGREE==5
lab def education ///
	1 "Less than lower secondary" ///
	2 "Lower Secondary" ///
	3 "Upper Secondary" ///
	4 "Vocational" ///
	5 "Degree" 
lab val education education
lab var education "Education Collapsed"
tab education


}

if `parties'==1 {

gen party_type=.
replace party_type=2 if country==36
replace party_type=2 if country==124
replace party_type=2 if country==756
replace party_type=1 if country==276
replace party_type=3 if country==208
replace party_type=3 if country==724
replace party_type=1 if country==246
replace party_type=2 if country==250
replace party_type=1 if country==826
replace party_type=2 if country==372
replace party_type=2 if country==392
replace party_type=1 if country==528
replace party_type=1 if country==578
replace party_type=3 if country==554
replace party_type=2 if country==620
replace party_type=2 if country==752
replace party_type=2 if country==840
 

gen vote=VOTE_LE

gen party=.
replace party=1 if AU_PRTY==1 & country==36 
replace party=2 if AU_PRTY ==2 & country==36 
replace party=3 if AU_PRTY ==3 & country==36 
replace party=4 if AU_PRTY ==4 & country==36 
replace party=7 if AU_PRTY ==5 & country==36 
replace party=8 if AU_PRTY ==6 & country==36 
replace party=9 if AU_PRTY ==7 & country==36 
replace party=96 if AU_PRTY ==95 & country ==36
replace party=97 if AU_PRTY ==96 & country ==36
replace party=99 if AU_PRTY ==.a & country ==36 | AU_PRTY ==.b & country ==36


replace party=1 if CA_PRTY==1 & country==124 
replace party=2 if CA_PRTY ==2 & country== 124 
replace party=3 if CA_PRTY ==3 & country== 124 
replace party=4 if CA_PRTY ==4 & country== 124 
replace party=96 if CA_PRTY ==95 & country == 124
replace party=97 if CA_PRTY ==96 & country == 124
replace party=99 if  CA_PRTY ==.c & country == 124
replace party=99 if CA_PRTY ==.a & country ==124 | CA_PRTY ==.b & country ==124

replace party =1 if DK_PRTY==1 & country ==208
replace party =2 if DK_PRTY==2 & country ==208
replace party =3 if DK_PRTY==3 & country ==208
replace party =5 if DK_PRTY==4 & country ==208
replace party =6 if DK_PRTY==6 & country ==208
replace party =7 if DK_PRTY==5 & country ==208
replace party =9 if DK_PRTY==7 & country ==208
replace party =11 if DK_PRTY==9 & country ==208
replace party =12 if DK_PRTY==8 & country ==208
replace party =96 if DK_PRTY ==94 & country == 208
replace party =96 if DK_PRTY ==95 & country == 208
replace party =97 if DK_PRTY ==96 & country == 208
replace party=99 if  DK_PRTY ==.c & country == 208 | DK_PRTY ==.d & country == 208
replace party=99 if DK_PRTY ==.a & country ==208 | DK_PRTY ==.b & country ==208

replace party = FI_PRTY if country ==246 & FI_PRTY<=96
replace party =96 if FI_PRTY ==95 & country == 246
replace party =97 if FI_PRTY ==96 & country == 246
replace party=99 if  FI_PRTY ==.c & country == 246 | FI_PRTY ==.d & country == 246
replace party=99 if FI_PRTY ==.a & country ==246 | FI_PRTY ==.b & country ==246


replace party=1 if FR_PRTY==1 & country==250 
replace party=2 if FR_PRTY==2 & country== 250 
replace party=3 if FR_PRTY==3 & country== 250 
replace party=4 if FR_PRTY==4 & country== 250 
replace party=5 if FR_PRTY==5 & country== 250 
replace party=6 if FR_PRTY==6 & country== 250 
replace party=7 if FR_PRTY==7 & country== 250 
replace party=96 if FR_PRTY ==95 & country == 250
replace party=97 if FR_PRTY ==96 & country == 250
replace party=99 if  FR_PRTY ==.c & country == 250 | FR_PRTY ==.d & country == 250
replace party=99 if FR_PRTY ==.a & country ==250 | FR_PRTY ==.b & country ==250


replace party=1 if DE_PRTY==2 & country==276 
replace party=2 if DE_PRTY ==1 & country== 276 
replace party=4 if DE_PRTY ==3 & country== 276 
replace party=5 if DE_PRTY ==4 & country== 276 
replace party=6 if DE_PRTY ==5 & country== 276 
replace party=7 if DE_PRTY ==6 & country== 276 
replace party=8 if DE_PRTY ==7 & country== 276 
replace party=9 if DE_PRTY ==8 & country== 276 
replace party=96 if DE_PRTY ==95 & country == 276
replace party=99 if DE_PRTY ==94 & country == 276
replace party=97 if DE_PRTY ==96 & country == 276
replace party=99 if  DE_PRTY ==.c & country == 276 | DE_PRTY ==.d & country == 276
replace party=99 if DE_PRTY ==.a & country ==276 | DE_PRTY ==.b & country ==276




replace party=1 if IE_PRTY==1 & country==372 
replace party=2 if IE_PRTY ==2 & country== 372 
replace party=3 if IE_PRTY ==3 & country== 372 
replace party=4 if IE_PRTY ==4 & country== 372 
replace party=5 if IE_PRTY ==5 & country== 372 
replace party=6 if IE_PRTY ==6 & country== 372 
replace party=7 if IE_PRTY ==7 & country== 372 
replace party=8 if IE_PRTY ==8 & country== 372 
replace party=96 if IE_PRTY ==95 & country == 372
replace party=97 if IE_PRTY ==96 & country == 372
replace party=99 if  IE_PRTY ==.c & country == 372 | IE_PRTY ==.d & country == 372
replace party=99 if IE_PRTY ==.a & country ==372 | IE_PRTY ==.b & country ==372


replace party=1 if JP_PRTY==1 & country==392 
replace party=2 if JP_PRTY ==6 & country== 392 
replace party=3 if JP_PRTY ==4 & country== 392 
replace party=4 if JP_PRTY ==5 & country== 392 
replace party=9 if JP_PRTY ==2 & country== 392 
replace party=10 if JP_PRTY ==3 & country== 392 
replace party=96 if JP_PRTY ==95 & country == 392
replace party=97 if JP_PRTY ==96 & country == 392
replace party=99 if  JP_PRTY ==.c & country == 392 | JP_PRTY ==.d & country == 392
replace party=99 if JP_PRTY ==.a & country ==392 | JP_PRTY ==.b & country ==392

replace party=KR_PRTY if country == 410 & KR_PRTY<=96
replace party =96 if KR_PRTY ==95 & country == 410
replace party =99 if KR_PRTY ==96 & country == 410
replace party =99 if KR_PRTY ==97 & country == 410
replace party =99 if KR_PRTY ==98 & country == 410
replace party=99 if  KR_PRTY ==.c & country == 410 | KR_PRTY ==.d & country == 410
replace party=99 if KR_PRTY ==.a & country ==410 | KR_PRTY ==.b & country ==410

replace party =1 if NL_PRTY==2 & country==528
replace party =2 if NL_PRTY==3 & country==528
replace party =3 if NL_PRTY==1 & country==528
replace party =4 if NL_PRTY==7 & country==528
replace party =5 if NL_PRTY==10 & country==528
replace party =6 if NL_PRTY==9 & country==528
replace party =8 if NL_PRTY==5 & country==528
replace party =10 if NL_PRTY==4 & country==528
replace party =13 if NL_PRTY==6 & country==528
replace party =14 if NL_PRTY==8 & country==528
replace party =96 if NL_PRTY ==94 & country == 528
replace party =96 if NL_PRTY ==95 & country == 528
replace party =97 if NL_PRTY ==96 & country == 528
replace party=99 if  NL_PRTY ==.c & country == 528 | NL_PRTY ==.d & country == 528
replace party=99 if NL_PRTY ==.a & country ==528 | NL_PRTY ==.b & country ==528

replace party=1 if NZ_PRTY ==3 & country== 554 
replace party=2 if NZ_PRTY ==4 & country== 554 
replace party=3 if NZ_PRTY ==5 & country== 554 
replace party=9 if NZ_PRTY ==6 & country== 554 
replace party=11 if NZ_PRTY ==2 & country== 554 
replace party=12 if NZ_PRTY ==1 & country== 554 
replace party=14 if NZ_PRTY ==8 & country== 554 
replace party=15 if NZ_PRTY ==7 & country== 554 
replace party=16 if NZ_PRTY ==9 & country== 554 
replace party=96 if NZ_PRTY ==95 & country == 554
replace party=97 if NZ_PRTY == 96 & country == 554
replace party=99 if  NZ_PRTY ==.c & country == 554 | NZ_PRTY ==.d & country == 554
replace party=99 if NZ_PRTY ==.a & country ==554 | NZ_PRTY ==.b & country ==554

replace party=1 if NO_PRTY==3 & country==578 
replace party=2 if NO_PRTY ==4 & country== 578 
replace party=3 if NO_PRTY ==6 & country== 578 
replace party=4 if NO_PRTY ==5 & country== 578 
replace party=5 if NO_PRTY ==8 & country== 578 
replace party=6 if NO_PRTY ==2 & country== 578 
replace party=7 if NO_PRTY ==7 & country== 578 
replace party=10 if NO_PRTY ==1 & country== 578 
replace party=96 if NO_PRTY ==95 & country == 578
replace party=97 if NO_PRTY == 96 & country == 578
replace party=99 if  NO_PRTY ==.c & country == 578 | NO_PRTY ==.d & country == 578
replace party=99 if NO_PRTY ==.a & country ==578 | NO_PRTY ==.b & country ==578


replace party=1 if PT_PRTY ==2 & country ==620
replace party=2 if PT_PRTY ==3 & country ==620
replace party=4 if PT_PRTY ==10 & country ==620
replace party=5 if PT_PRTY ==11 & country ==620
replace party=8 if PT_PRTY ==1 & country ==620
replace party=9 if PT_PRTY ==3 & country ==620
replace party=10 if PT_PRTY ==4 & country ==620
replace party=11 if PT_PRTY ==5 & country ==620
replace party=12 if PT_PRTY ==6 & country ==620
replace party=13 if PT_PRTY ==7 & country ==620
replace party=14 if PT_PRTY ==8 & country ==620
replace party=15 if PT_PRTY ==9 & country ==620
replace party=96 if PT_PRTY == 95 & country == 620
replace party=97 if PT_PRTY == 96 & country == 620
replace party=99 if  PT_PRTY ==.c & country == 620 | PT_PRTY ==.d & country == 620
replace party=99 if PT_PRTY ==.a & country ==620 | PT_PRTY ==.b & country ==620


replace party=1 if ES_PRTY==2 & country==724 
replace party=3 if ES_PRTY ==1 & country== 724 
replace party=4 if ES_PRTY ==3 & country== 724 
replace party=5 if ES_PRTY ==4 & country== 724 
replace party=6 if ES_PRTY ==5 & country== 724 
replace party=5 if ES_PRTY ==6 & country== 724 
replace party=6 if ES_PRTY ==7 & country== 724 
replace party=5 if ES_PRTY ==8 & country== 724 
replace party=6 if ES_PRTY ==9 & country== 724 
replace party=6 if ES_PRTY ==10 & country== 724 
replace party=6 if ES_PRTY ==11 & country== 724 
replace party=96 if ES_PRTY ==94 & country == 724
replace party= 96 if ES_PRTY ==95 & country == 724
replace party=97 if ES_PRTY == 96 & country == 724
replace party=99 if  ES_PRTY ==.c & country == 724 | ES_PRTY ==.d & country == 724
replace party=99 if ES_PRTY ==.a & country ==724 | ES_PRTY ==.b & country ==724

replace party=1 if SE_PRTY==1 & country==752 
replace party=2 if SE_PRTY ==2 & country== 752 
replace party=3 if SE_PRTY ==3 & country== 752 
replace party=4 if SE_PRTY ==4 & country== 752 
replace party=5 if SE_PRTY ==5 & country== 752 
replace party=6 if SE_PRTY ==6 & country== 752 
replace party=7 if SE_PRTY ==7 & country== 752 
replace party=96 if SE_PRTY ==95 & country == 752
replace party=97 if SE_PRTY == 96 & country == 752
replace party=99 if  SE_PRTY ==.c & country == 752 | SE_PRTY ==.d & country == 752
replace party=99 if SE_PRTY ==.a & country ==752 | SE_PRTY ==.b & country ==752

replace party=2 if CH_PRTY ==1 & country== 756 
replace party=7 if CH_PRTY ==2 & country== 756 
replace party=1 if CH_PRTY==3 & country==756 
replace party=3 if CH_PRTY ==4 & country== 756 
replace party=4 if CH_PRTY ==5 & country== 756 
replace party=6 if CH_PRTY ==7 & country== 756 
replace party=8 if CH_PRTY ==8 & country== 756 
replace party=15 if CH_PRTY ==9 & country== 756 
replace party=10 if CH_PRTY ==10 & country== 756 
replace party=13 if CH_PRTY ==11 & country== 756 
replace party=96 if CH_PRTY ==95 & country == 756
replace party=97 if CH_PRTY ==96 & country == 756
replace party=99 if  CH_PRTY ==.c & country == 756 | CH_PRTY ==.d & country == 756
replace party=99 if CH_PRTY ==.a & country ==756 | CH_PRTY ==.b & country ==756

replace party=1 if GB_PRTY==1 & country==826 
replace party=2 if GB_PRTY ==2 & country== 826 
replace party=3 if GB_PRTY ==3 & country== 826 
replace party=4 if GB_PRTY ==6 & country== 826 
replace party=5 if GB_PRTY ==7 & country== 826 
replace party=6 if GB_PRTY ==8 & country== 826 
replace party=96 if GB_PRTY ==93 & country == 826
replace party=96 if GB_PRTY ==95 & country == 826
replace party=97 if GB_PRTY ==96 & country == 826
replace party=99 if  GB_PRTY ==.c & country == 826 | GB_PRTY ==.d & country == 826
replace party=99 if GB_PRTY ==.a & country ==826 | GB_PRTY ==.b & country ==826


replace party=US_PRTY if country == 840
replace party=96 if US_PRTY ==95 & country == 840
replace party=99 if  US_PRTY ==.c & country == 840 | US_PRTY ==.d & country == 840
replace party=99 if US_PRTY ==.a & country ==840 | US_PRTY ==.b & country ==840

lab val party party
lab var party "Party Choice"
tab party

 }
 
 if `occupation_recode'==1 {
 gen isco= ISCO88

 recode isco 9995=.
gen isco_string=string(isco)
 gen isco_3s=substr(isco_string, 1, 3)
destring isco_3s, replace
gen isco_combined=isco_3s
replace isco_combined=isco_3 if isco_combined==.
replace isco_combined=isco_3 if isco_combined==.
replace isco_combined=. if isco_combined==0
replace isco_combined=. if isco_combined==9999
gen isco_2=substr(isco_string, 1, 2)

merge m:1 isco_2 using "Occupation_GROUPS.dta"


 }
drop V*
drop SEX AGE COHAB MARITAL EDUCYRS DEGREE AU* CA* CH* CL* CZ* DE* DK* DO* ES*  FI* FR* GB* HR* HU* IE* IL* JP* KR* LV* NL* NO* NZ* PH* PL* PT* RU* SE* SI* TW* US* UY* ZA* WRKST WRKHRS ISCO88 WRKSUP WRKTYPE NEMPLOY UNION SPWRKST SPISCO88 SPWRKTYP HOMPOP HHCYCLE PARTY_LR RELIG RELIGGRP ATTEND TOPBOT URBRURAL ETHNIC MODE WEIGHT
drop if country==.


save `temp06', replace
}
if `year_2007'==1 {
********
* 2007 *
********
use "ZA4850.dta", clear
set more off


local main_variables 1
local parties 1
local occupation_recode 1

if `main_variables'==1 {
gen case=V3
lab var case "Case ID Number"

gen YYYY=2007
lab var YYYY "Survey Year"

recode weight 0=.
lab val weight weight
lab var weight "Weight"

gen country=.
replace country=36 if V4==36
replace country=40 if V4==40
replace country=56 if V4==56.1
replace country=124 if V4==124
replace country=208 if V4==208
replace country=246 if V4==246
replace country=250 if V4==250
replace country =276 if V4==276.1
replace country =276 if V4==276.2
replace country =372 if V4==372
replace country=392 if V4==392
replace country =528 if V4==528
replace country=554 if V4==554
replace country=578 if V4==578
replace country=620 if V4==620
replace country=724 if V4==724
replace country=752 if V4==752
replace country=756 if V4==756
replace country =826 if V4==826.1
replace country=840 if V4==840
lab def country ///
	36 "Australia" ///
	124 "Canada" ///
	208 "Denmark" ///
	246 "Finland" ///
	250 "France" ///
	276 "Germany" ///
	372 "Ireland" ///
	392 "Japan" ///
	528 "Netherlands" ///
	554 "New Zealand" ///
	578 "Norway" ///
	620 "Portugal" ///
	724 "Spain" ///
	752 "Sweden" ///
	756 "Switzerland" ///
	826 "UK" ///
	840 "USA" 
lab val country country
lab var country "Country"
tab country

gen east_germany=1 if V4==276.2


recode sex 0=.
tab age

gen birth=2007-age
label var birth "Year of Birth"


gen empl=.
replace empl=2 if wrkst ==1
replace empl=2 if wrkst ==2
replace empl=1 if wrkst ==5
lab def empl ///
	1 "Unemployed" ///
	2 "Employed" 
lab val empl empl
lab var empl "Employment Status - 2"
tab empl

gen employee=.
replace employee =2 if wrktype ==4
replace employee =1 if wrktype ==1
replace employee =1 if wrktype ==2
replace employee =1 if wrktype ==3
replace employee =1 if wrktype ==6
lab def employee ///
	1 "Employed" ///
	2 "Self Employed" 
lab val employee employee
lab var employee "Employee"
tab employee

tab wrkst
recode wrkst 0=., gen(emplB)
lab def emplB ///
	1 "Employed FT" ///
	2 "Employed PT" ///
	3 "Less than PT" ///
	4 "Helping Family Member" ///
	5 "Unemployed" ///
	6 "Student" ///
	7 "Retired" ///
	8 "Housewife/man" ///
	9 "Perm. dis" ///
	10 "Not in LF" 
lab val emplB emplB
lab var emplB "Employment Status"
tab emplB

gen education=.
replace education=1 if degree==0
replace education=1 if degree==1
replace education=2 if degree==2
replace education=3 if degree==3
replace education=4 if degree==4
replace education=5 if degree==5
lab def education ///
	1 "Less than lower secondary" ///
	2 "Lower Secondary" ///
	3 "Upper Secondary" ///
	4 "Vocational" ///
	5 "degree" 
lab val education education
lab var education "Education Collapsed"
tab education


} 
if `parties'==1 { 

gen vote=VOTE_LE

gen party_type=.
replace party_type=3 if country==40
replace party_type=2 if country==36
replace party_type=2 if country==756
replace party_type=1 if country==276
replace party_type=1 if country==56
replace party_type=1 if country==246
replace party_type=2 if country==250
replace party_type=1 if country==826
replace party_type=2 if country==372
replace party_type=2 if country==392
replace party_type=1 if country==578
replace party_type=3 if country==554
replace party_type=2 if country==752
replace party_type=2 if country==840

gen party=.
replace party=2 if AT_PRTY==1 & country==40 
replace party=1 if AT_PRTY ==2 & country==40 
replace party=3 if AT_PRTY ==3 & country==40 
replace party=4 if AT_PRTY ==4 & country==40 
replace party=10 if AT_PRTY ==5 & country==40 
replace party=9 if AT_PRTY ==6 & country==40 
replace party=96 if AT_PRTY ==95 & country ==40
replace party=97 if VOTE_LE==2 & country ==40
replace party=99 if AT_PRTY==. & country==40



replace party=1 if AU_PRTY==1 & country==36 
replace party=2 if AU_PRTY ==2 & country==36 
replace party=3 if AU_PRTY ==3 & country==36 
replace party=4 if AU_PRTY ==4 & country==36 
replace party=7 if AU_PRTY ==5 & country==36 
replace party=8 if AU_PRTY ==6 & country==36 
replace party=9 if AU_PRTY ==7 & country==36 
replace party=96 if AU_PRTY ==95 & country ==36
replace party=97 if AU_PRTY ==96 & country ==36
replace party=99 if AU_PRTY==. & country==36

replace party=1 if FLA_PRTY==1 & country==56 
replace party=7 if FLA_PRTY ==2 & country==56 
replace party=5 if FLA_PRTY ==3 & country==56 
replace party=2 if FLA_PRTY ==4 & country==56 
replace party=8 if FLA_PRTY ==5 & country==56 
replace party=3 if FLA_PRTY ==6 & country==56 
replace party=15 if FLA_PRTY ==10 & country==56 
replace party=11 if FLA_PRTY ==11 & country==56 
replace party=96 if FLA_PRTY ==95 & country ==56
replace party=96 if FLA_PRTY ==93 & country ==56
replace party=99 if FLA_PRTY==. & country==56




replace party = FI_PRTY if country ==246 & FI_PRTY<=96
replace party =96 if FI_PRTY ==95 & country == 246
replace party =99 if FI_PRTY ==. & country == 246


replace party=1 if FR_PRTY==1 & country==250 
replace party=2 if FR_PRTY==2 & country== 250 
replace party=3 if FR_PRTY==3 & country== 250 
replace party=4 if FR_PRTY==4 & country== 250 
replace party=5 if FR_PRTY==5 & country== 250 
replace party=6 if FR_PRTY==6 & country== 250 
replace party=7 if FR_PRTY==7 & country== 250 
replace party=96 if FR_PRTY ==95 & country == 250
replace party=97 if FR_PRTY ==96 & country == 250
replace party =99 if FR_PRTY ==. & country == 250


replace party=1 if DE_PRTY==2 & country==276 
replace party=2 if DE_PRTY ==1 & country== 276 
replace party=4 if DE_PRTY ==3 & country== 276 
replace party=5 if DE_PRTY ==4 & country== 276 
replace party=8 if DE_PRTY ==5 & country== 276 
replace party=9 if DE_PRTY ==6 & country== 276 
replace party=6 if DE_PRTY ==7 & country== 276 
replace party=96 if DE_PRTY ==95 & country == 276
replace party =99 if DE_PRTY ==. & country == 276




replace party=1 if IE_PRTY==1 & country==372 
replace party=2 if IE_PRTY ==2 & country== 372 
replace party=3 if IE_PRTY ==3 & country== 372 
replace party=5 if IE_PRTY ==4 & country== 372 
replace party=6 if IE_PRTY ==5 & country== 372 
replace party=7 if IE_PRTY ==6 & country== 372 
replace party=96 if IE_PRTY ==95 & country == 372
replace party =99 if IE_PRTY ==. & country == 372


replace party=1 if JP_PRTY==1 & country==392 
replace party=9 if JP_PRTY ==2 & country== 392 
replace party=3 if JP_PRTY ==4 & country== 392 
replace party=4 if JP_PRTY ==5 & country== 392 
replace party=2 if JP_PRTY ==6 & country== 392 
replace party=96 if JP_PRTY ==95 & country == 392
replace party=97 if JP_PRTY ==96 & country == 392
replace party=99 if JP_PRTY ==97 & country == 392
replace party=99 if JP_PRTY ==98 & country == 392
replace party =99 if JP_PRTY ==. & country == 392

replace party=12 if NZ_PRTY ==1 & country== 554 
replace party=11 if NZ_PRTY ==2 & country== 554 
replace party=1 if NZ_PRTY ==3 & country== 554 
replace party=2 if NZ_PRTY ==4 & country== 554 
replace party=3 if NZ_PRTY ==5 & country== 554 
replace party=9 if NZ_PRTY ==6 & country== 554 
replace party=15 if NZ_PRTY ==7 & country== 554 
replace party=14 if NZ_PRTY ==8 & country== 554 
replace party=16 if NZ_PRTY ==9 & country== 554 
replace party=96 if NZ_PRTY ==95 & country == 554
replace party=97 if NZ_PRTY == 96 & country == 554
replace party =99 if NZ_PRTY ==. & country == 554

replace party=10 if NO_PRTY ==1 & country== 578 
replace party=6 if NO_PRTY ==2 & country== 578 
replace party=1 if NO_PRTY==3 & country==578 
replace party=2 if NO_PRTY ==4 & country== 578 
replace party=4 if NO_PRTY ==5 & country== 578 
replace party=3 if NO_PRTY ==6 & country== 578 
replace party=7 if NO_PRTY ==7 & country== 578 
replace party=5 if NO_PRTY ==8 & country== 578 
replace party=96 if NO_PRTY ==95 & country == 578
replace party=97 if NO_PRTY == 96 & country == 578
replace party =99 if NO_PRTY ==. & country == 578



replace party=1 if SE_PRTY==1 & country==752 
replace party=2 if SE_PRTY ==2 & country== 752 
replace party=3 if SE_PRTY ==3 & country== 752 
replace party=4 if SE_PRTY ==4 & country== 752 
replace party=5 if SE_PRTY ==5 & country== 752 
replace party=6 if SE_PRTY ==6 & country== 752 
replace party=7 if SE_PRTY ==7 & country== 752 
replace party=96 if SE_PRTY ==95 & country == 752
replace party=97 if SE_PRTY == 96 & country == 752
replace party =99 if SE_PRTY ==. & country == 752

replace party=2 if CH_PRTY ==1 & country== 756 
replace party=7 if CH_PRTY ==2 & country== 756 
replace party=1 if CH_PRTY==3 & country==756 
replace party=3 if CH_PRTY ==4 & country== 756 
replace party=4 if CH_PRTY ==5 & country== 756 
replace party=6 if CH_PRTY ==7 & country== 756 
replace party=8 if CH_PRTY ==8 & country== 756 
replace party=15 if CH_PRTY ==9 & country== 756 
replace party=10 if CH_PRTY ==10 & country== 756 
replace party=13 if CH_PRTY ==11 & country== 756 
replace party=96 if CH_PRTY ==95 & country == 756
replace party=97 if CH_PRTY ==96 & country == 756
replace party =99 if CH_PRTY ==. & country == 756

replace party=1 if GB_PRTY==1 & country==826 
replace party=2 if GB_PRTY ==2 & country== 826 
replace party=3 if GB_PRTY ==3 & country== 826 
replace party=4 if GB_PRTY ==6 & country== 826 
replace party=5 if GB_PRTY ==7 & country== 826 
replace party=6 if GB_PRTY ==8 & country== 826 
replace party=96 if GB_PRTY ==93 & country == 826
replace party=96 if GB_PRTY ==95 & country == 826
replace party=97 if GB_PRTY ==96 & country == 826
replace party =99 if GB_PRTY ==. & country == 826


replace party=US_PRTY if country == 840
replace party=96 if US_PRTY ==95 & country == 840
replace party =99 if US_PRTY ==. & country == 840

lab val party party
lab var party "Party Choice"
tab party

}
if `occupation_recode'==1 {
gen isco= ISCO88

recode isco 9995=.
gen isco_string=string(isco)
 gen isco_3s=substr(isco_string, 1, 3)
destring isco_3s, replace
gen isco_combined=isco_3s
replace isco_combined=isco_3 if isco_combined==.
replace isco_combined=isco_3 if isco_combined==.
replace isco_combined=. if isco_combined==0
replace isco_combined=. if isco_combined==9999
gen isco_2=substr(isco_string, 1, 2)

merge m:1 isco_2 using "Occupation_GROUPS.dta"

}



drop V*
drop if country==.
drop marital- subscase degree
save `temp07', replace

}
if `year_2008'==1 {
********
* 2008 *
********
use  "ZA4950_v2.dta", clear


local main_variables 1
local parties 1
local occupation_recode 1

if `main_variables'==1 {
gen weight=WEIGHT
recode weight 0=.
lab val weight weight
lab var weight "Weight"


gen case=V3
lab var case "Case ID Number"
gen YYYY=2008
lab var YYYY "Survey Year"

gen country=.
replace country = V5 if V5==36 |  V5==40  |  V5==56  |  V5==208 |  V5==246   |  V5==250 |  V5==276 |  V5==380 |  V5==392 
replace country = V5 if V5==528 |  V5==554  |  V5==578  |  V5==620 |  V5==724   |  V5==752 |  V5==756 |  V5==826 |  V5==840
lab def country ///
	36 "Australia" ///
	40 "Austria" ///
	40 "Belgium" ///
	208 "Denmark" ///
	246 "Finland" ///
	250 "France" ///
	276 "Germany" ///
	372 "Ireland" ///
	380 "Italy" ///
	392 "Japan" ///
	528 "Netherlands" ///
	554 "New Zealand" ///
	578 "Norway" ///
	620 "Portugal" ///
	724 "Spain" ///
	752 "Sweden" ///
	756 "Switzerland" ///
	826 "UK" ///
	840 "USA" 
lab val country country
lab var country "Country"
tab country

drop if country==.

gen east_germany=1 if V4==276.2

tab SEX
gen sex=SEX
recode sex 0=.

gen age=AGE
replace age=. if AGE ==99
gen birth=2008-age
label var birth "Year of Birth"

gen empl=.
replace empl=2 if WRKST ==1
replace empl=2 if WRKST ==2
replace empl=1 if WRKST ==5
lab def empl ///
	1 "Unemployed" ///
	2 "Employed" 
lab val empl empl
lab var empl "Employment Status - 2"
tab empl

gen employee=.
replace employee =1 if WRKTYPE>=1 & WRKTYPE<=3
replace employee =1 if WRKTYPE==6
replace employee =2 if WRKTYPE ==4
lab def employee ///
	1 "Employed" ///
	2 "Self Employed" 
lab val employee employee
lab var employee "Employee"
tab employee

recode WRKST 0=., gen(emplB)
lab def emplB ///
	1 "Employed FT" ///
	2 "Employed PT" ///
	3 "Less than PT" ///
	4 "Helping Family Member" ///
	5 "Unemployed" ///
	6 "Student" ///
	7 "Retired" ///
	8 "Housewife/man" ///
	9 "Perm. dis" ///
	10 "Not in LF" 
lab val emplB emplB
lab var emplB "Employment Status"
tab emplB



gen education=.
replace education=1 if DEGREE==0
replace education=1 if DEGREE==1
replace education=2 if DEGREE==2
replace education=3 if DEGREE==3
replace education=4 if DEGREE==4
replace education=5 if DEGREE==5
lab def education ///
	1 "Less than lower secondary" ///
	2 "Lower Secondary" ///
	3 "Upper Secondary" ///
	4 "Vocational" ///
	5 "Degree" 
lab val education education
lab var education "Education Collapsed"
tab education
}

if `parties'==1 {

gen vote=VOTE_LE

gen party_type=.
replace party_type=3 if country==40
replace party_type=2 if country==36
replace party_type=1 if country==56
replace party_type=2 if country==756
replace party_type=1 if country==276
replace party_type=3 if country==208
replace party_type=3 if country==724
replace party_type=1 if country==246
replace party_type=2 if country==250
replace party_type=1 if country==826
replace party_type=2 if country==372
replace party_type=1 if country==380
replace party_type=2 if country==392
replace party_type=1 if country==528
replace party_type=1 if country==578
replace party_type=3 if country==554
replace party_type=2 if country==620
replace party_type=2 if country==752
replace party_type=2 if country==840


gen party=.
replace party=1 if AU_PRTY==1 & country==36 
replace party=2 if AU_PRTY ==2 & country==36 
replace party=3 if AU_PRTY ==3 & country==36 
replace party=4 if AU_PRTY ==4 & country==36 
replace party=7 if AU_PRTY ==5 & country==36 
replace party=8 if AU_PRTY ==6 & country==36 
replace party=9 if AU_PRTY ==7 & country==36 
replace party=96 if AU_PRTY ==95 & country ==36
replace party=97 if AU_PRTY ==96 & country ==36
replace party=99 if AU_PRTY ==.a & country==36 | AU_PRTY ==.n & country==36

replace party=2 if AT_PRTY ==1 & country== 40 
replace party=1 if AT_PRTY==2 & country==40 
replace party=3 if AT_PRTY ==3 & country== 40 
replace party=4 if AT_PRTY ==4 & country== 40 
replace party=10 if AT_PRTY ==5 & country== 40 
replace party=7 if AT_PRTY ==6 & country== 40 
replace party=96 if AT_PRTY ==95 & country == 40
replace party=97 if AT_PRTY ==96 & country == 40
replace party=99 if AT_PRTY ==.a & country==40 | AT_PRTY ==.n & country==40

replace party=1  if BE_PRTY ==1 & country == 56
replace party=7  if BE_PRTY ==2 & country == 56
replace party=5  if BE_PRTY ==3 & country == 56
replace party=2  if BE_PRTY ==4 & country == 56
replace party=8  if BE_PRTY ==5 & country == 56
replace party=3  if BE_PRTY ==6 & country == 56
replace party=15  if BE_PRTY ==7 & country == 56
replace party=96  if BE_PRTY ==8 & country == 56
replace party=14  if BE_PRTY ==9 & country == 56
replace party=96 if BE_PRTY ==12 & country == 56
replace party=96 if BE_PRTY ==10 & country == 56
replace party=96 if BE_PRTY ==95 & country == 56
replace party=97 if BE_PRTY ==96 & country == 56
replace party=99 if BE_PRTY ==.a & country==56 | BE_PRTY ==.n & country==56


replace party =1 if DK_PRTY==1 & country ==208
replace party =2 if DK_PRTY==2 & country ==208
replace party =3 if DK_PRTY==3 & country ==208
replace party =5 if DK_PRTY==4 & country ==208
replace party =7 if DK_PRTY==5 & country ==208
replace party =6 if DK_PRTY==6 & country ==208
replace party =9 if DK_PRTY==7 & country ==208
replace party =12 if DK_PRTY==8 & country ==208
replace party =11 if DK_PRTY==9 & country ==208
replace party =96 if DK_PRTY ==94 & country == 208
replace party =96 if DK_PRTY ==95 & country == 208
replace party =97 if DK_PRTY ==96 & country == 208
replace party=99 if DK_PRTY ==.a & country==208 | DK_PRTY ==.n & country==208

replace party = FI_PRTY if country ==246 & FI_PRTY<=96
replace party =96 if FI_PRTY ==95 & country == 246
replace party =97 if FI_PRTY ==96 & country == 246
replace party=99 if FI_PRTY ==.a & country==246 | FI_PRTY ==.n & country==246


replace party=1 if FR_PRTY==1 & country==250 
replace party=2 if FR_PRTY==2 & country== 250 
replace party=3 if FR_PRTY==3 & country== 250 
replace party=4 if FR_PRTY==4 & country== 250 
replace party=5 if FR_PRTY==5 & country== 250 
replace party=6 if FR_PRTY==6 & country== 250 
replace party=7 if FR_PRTY==7 & country== 250 
replace party=96 if FR_PRTY ==95 & country == 250
replace party=97  if FR_PRTY ==96 & country == 250
replace party=99 if FR_PRTY ==.a & country==250 | FR_PRTY ==.n & country==250


replace party=2 if DE_PRTY ==1 & country== 276 
replace party=1 if DE_PRTY==2 & country==276 
replace party=4 if DE_PRTY ==3 & country== 276 
replace party=5 if DE_PRTY ==4 & country== 276 
replace party=8 if DE_PRTY ==5 & country== 276 
replace party=9 if DE_PRTY ==6 & country== 276 
replace party=6 if DE_PRTY ==7 & country== 276 
replace party=96 if DE_PRTY ==95 & country == 276
replace party=99  if DE_PRTY ==94 & country == 276
replace party=97  if DE_PRTY ==96 & country == 276
replace party=99 if DE_PRTY ==.a & country==276 | DE_PRTY ==.n & country==276


replace party=17 if IT_PRTY==1 & country==380
replace party=11 if IT_PRTY==2 & country==380
replace party=50 if IT_PRTY==3 & country==380
replace party=20 if IT_PRTY==4 & country==380
replace party=51 if IT_PRTY==5 & country==380
replace party=52 if IT_PRTY==6 & country==380
replace party=37 if IT_PRTY==8 & country==380
replace party=34 if IT_PRTY==9 & country==380
replace party=49 if IT_PRTY==10 & country==380
replace party=18 if IT_PRTY==12 & country==380
replace party=14 if IT_PRTY==16 & country==380
replace party=52 if IT_PRTY==17 & country==380
replace party=6 if IT_PRTY==18 & country==380
replace party=26 if IT_PRTY==19 & country==380
replace party=22 if IT_PRTY==20 & country==380
replace party=15 if IT_PRTY==21 & country==380
replace party=96 if IT_PRTY==18 & country==380
replace party=97 if IT_PRTY==96 & country==380
replace party=99 if IT_PRTY ==.a & country==380 | IT_PRTY ==.n & country==380


replace party=1 if JP_PRTY==1 & country==392 
replace party=9 if JP_PRTY ==2 & country== 392 
replace party=3 if JP_PRTY ==4 & country== 392 
replace party=4 if JP_PRTY ==5 & country== 392 
replace party=2 if JP_PRTY ==6 & country== 392 
replace party=96 if JP_PRTY ==95 & country == 392
replace party=97  if JP_PRTY ==96 & country == 392
replace party=99 if JP_PRTY ==.a & country==392 | JP_PRTY ==.n & country==392

replace party=6 if KR_PRTY==1 & country == 410
replace party=2 if KR_PRTY==2 & country == 410
replace party=9 if KR_PRTY==3 & country == 410
replace party=13 if KR_PRTY==4 & country == 410
replace party=7 if KR_PRTY==5 & country == 410
replace party=5 if KR_PRTY==6 & country == 410
replace party =96 if KR_PRTY ==95 & country == 410
replace party =97 if KR_PRTY ==96 & country == 410
replace party =99 if KR_PRTY ==97 & country == 410
replace party =99 if KR_PRTY ==98 & country == 410
replace party=99 if KR_PRTY ==.a & country==410 | KR_PRTY ==.n & country==410

replace party=3 if NL_PRTY ==1 & country== 528 
replace party=1 if NL_PRTY ==2 & country== 528 
replace party=2 if NL_PRTY ==3 & country== 528 
replace party=10 if NL_PRTY ==4 & country== 528 
replace party=8 if NL_PRTY ==5 & country== 528 
replace party=13 if NL_PRTY ==6 & country== 528 
replace party=4 if NL_PRTY ==7 & country== 528 
replace party=14 if NL_PRTY ==8 & country== 528 
replace party=15 if NL_PRTY ==9 & country== 528 
replace party=5 if NL_PRTY ==10 & country== 528 
replace party=17 if NL_PRTY ==11 & country== 528 
replace party=18 if NL_PRTY ==12 & country== 528 
replace party=96 if NL_PRTY ==95 & country == 528
replace party=97  if NL_PRTY == 96 & country == 528
replace party=99 if NL_PRTY ==.a & country==528 | NL_PRTY ==.n & country==528

replace party=2 if NZ_PRTY ==4 & country== 554 
replace party=3 if NZ_PRTY ==5 & country== 554 
replace party=15 if NZ_PRTY ==7 & country== 554 
replace party=14 if NZ_PRTY ==8 & country== 554 
replace party=11 if NZ_PRTY ==2 & country== 554 
replace party=12 if NZ_PRTY ==1 & country== 554 
replace party=16 if NZ_PRTY ==9 & country== 554 
replace party=9 if NZ_PRTY ==6 & country== 554 
replace party=1 if NZ_PRTY ==3 & country== 554 
replace party=96 if NZ_PRTY ==95 & country == 554
replace party=97  if NZ_PRTY == 96 & country == 554
replace party=99 if NZ_PRTY ==.a & country==554 | NZ_PRTY ==.n & country==554

replace party=10 if NO_PRTY ==1 & country== 578 
replace party=6 if NO_PRTY ==2 & country== 578 
replace party=1 if NO_PRTY==3 & country==578 
replace party=2 if NO_PRTY ==4 & country== 578 
replace party=4 if NO_PRTY ==5 & country== 578 
replace party=3 if NO_PRTY ==6 & country== 578 
replace party=7 if NO_PRTY ==7 & country== 578 
replace party=5 if NO_PRTY ==8 & country== 578 
replace party=96 if NO_PRTY ==95 & country == 578
replace party=97  if NO_PRTY == 96 & country == 578
replace party=99 if NO_PRTY ==.a & country==578 | NO_PRTY ==.n & country==578


replace party=8 if PT_PRTY ==1 & country ==620
replace party=1 if PT_PRTY ==2 & country ==620
replace party=9 if PT_PRTY ==3 & country ==620
replace party=3 if PT_PRTY ==4 & country ==620
replace party=4 if PT_PRTY ==5 & country ==620
replace party=5 if PT_PRTY ==6 & country ==620
replace party=6 if PT_PRTY ==7 & country ==620
replace party=7 if PT_PRTY ==8 & country ==620
replace party=96 if PT_PRTY == 95 & country == 620
replace party=97 if PT_PRTY == 96 & country == 620
replace party=99 if PT_PRTY ==.a & country==620 | PT_PRTY ==.n & country==620


replace party=3 if ES_PRTY==1 & country==724 
replace party=1 if ES_PRTY ==2 & country== 724 
replace party=4 if ES_PRTY ==3 & country== 724 
replace party=5 if ES_PRTY ==4 & country== 724 
replace party=6 if ES_PRTY ==5 & country== 724 
replace party=5 if ES_PRTY ==6 & country== 724 
replace party=6 if ES_PRTY ==7 & country== 724 
replace party=6 if ES_PRTY ==8 & country== 724 
replace party=5 if ES_PRTY ==9 & country== 724 
replace party=6 if ES_PRTY ==10 & country== 724 
replace party=96 if ES_PRTY ==94 & country == 724
replace party= 96 if ES_PRTY ==95 & country == 724
replace party=97  if ES_PRTY == 96 & country == 724
replace party=99 if ES_PRTY ==.a & country==724 | ES_PRTY ==.n & country==724

replace party=1 if SE_PRTY==1 & country==752 
replace party=2 if SE_PRTY ==2 & country== 752 
replace party=3 if SE_PRTY ==3 & country== 752 
replace party=4 if SE_PRTY ==4 & country== 752 
replace party=5 if SE_PRTY ==5 & country== 752 
replace party=6 if SE_PRTY ==6 & country== 752 
replace party=7 if SE_PRTY ==7 & country== 752 
replace party=96 if SE_PRTY ==95 & country == 752
replace party=97  if SE_PRTY == 96 & country == 752
replace party=99 if SE_PRTY ==.a & country==752 | SE_PRTY ==.n & country==752

replace party=1 if CH_PRTY==1 & country==756 
replace party=2 if CH_PRTY ==2 & country== 756 
replace party=3 if CH_PRTY ==3 & country== 756 
replace party=4 if CH_PRTY ==4 & country== 756 
replace party=6 if CH_PRTY ==5 & country== 756 
replace party=7 if CH_PRTY ==6 & country== 756 
replace party=12 if CH_PRTY ==7 & country== 756 
replace party=8 if CH_PRTY ==8 & country== 756 
replace party=10 if CH_PRTY ==9 & country== 756 
replace party=20 if CH_PRTY ==10 & country== 756 
replace party=15 if CH_PRTY ==11 & country== 756 
replace party=17 if CH_PRTY ==12 & country== 756 
replace party=16 if CH_PRTY ==13 & country== 756 
replace party=99  if CH_PRTY ==90 & country== 756 
replace party=96 if CH_PRTY ==95 & country == 756
replace party=97  if CH_PRTY ==96 & country == 756
replace party=99 if CH_PRTY ==.a & country==756 | CH_PRTY ==.n & country==756

replace party=1 if GB_PRTY==1 & country==826 
replace party=2 if GB_PRTY ==2 & country== 826 
replace party=3 if GB_PRTY ==3 & country== 826 
replace party=4 if GB_PRTY ==6 & country== 826 
replace party=5 if GB_PRTY ==7 & country== 826 
replace party=6 if GB_PRTY ==8 & country== 826 
replace party=96 if GB_PRTY ==93 & country == 826
replace party=96 if GB_PRTY ==95 & country == 826
replace party=97  if GB_PRTY ==96 & country == 826
replace party=99 if GB_PRTY ==.a & country==826 | GB_PRTY ==.n & country==826


replace party=US_PRTY if country == 840
replace party=96 if US_PRTY ==95 & country == 840
replace party=99 if US_PRTY ==.a & country==840 | US_PRTY ==.n & country==840

lab val party party
lab var party "Party Choice"
tab party
}

if `occupation_recode'==1 {

recode ISCO88 9995=.
gen isco_string=string(ISCO88)
 gen isco_3s=substr(isco_string, 1, 3)
destring isco_3s, replace
gen isco_combined=isco_3s
replace isco_combined=isco_3 if isco_combined==.
replace isco_combined=isco_3 if isco_combined==.
replace isco_combined=. if isco_combined==0
replace isco_combined=. if isco_combined==9999
gen isco_2=substr(isco_string, 1, 2)

merge m:1 isco_2 using "Occupation_GROUPS.dta"


rename ISCO88 isco


}

order isco 

drop AGE-ZA_SIZE
drop V*
drop C_ALPHAN-WEIGHT
save `temp08', replace
}
if `year_2009'==1 {
********
* 2009 *
********
use "ZA5400.dta", clear

local main_variables 1
local parties 1
local occupation_recode 1

if `main_variables'==1 {
gen case=V3
lab var case "Case ID Number"

gen YYYY=2009
lab var YYYY "Survey Year"

gen weight=WEIGHT
recode weight 0=.
lab val weight weight
lab var weight "Weight"


gen country=.
replace country=36 if V4==36
replace country=40 if V4==40
replace country= 56 if V4==56.1
replace country=208 if V4==208
replace country=246 if V4==246
replace country=250 if V4==250
replace country =276 if V4==276.1
replace country =276 if V4==276.2
replace country =372 if V4==372
replace country = 380 if V4==380
replace country=392 if V4==392
replace country =528 if V4==528
replace country=554 if V4==554
replace country=578 if V4==578
replace country=620 if V4==620
replace country=724 if V4==724
replace country=752 if V4==752
replace country=756 if V4==756
replace country =826 if V4==826.1
replace country=840 if V4==840
lab def country ///
	36 "Australia" ///
	40 "Austria" ///
	56 "Belgium" ///
	208 "Denmark" ///
	246 "Finland" ///
	250 "France" ///
	276 "Germany" ///
	372 "Ireland" ///
	380 "Italy" ///
	392 "Japan" ///
	528 "Netherlands" ///
	554 "New Zealand" ///
	578 "Norway" ///
	620 "Portugal" ///
	724 "Spain" ///
	752 "Sweden" ///
	756 "Switzerland" ///
	826 "UK" ///
	840 "USA" 
lab val country country
lab var country "Country"
tab country

gen east_germany=1 if V4==276.2


gen sex=SEX
recode sex 0=.

gen age=AGE

gen birth=2009-age
label var birth "Year of Birth"

gen empl=.
replace empl=2 if WRKST ==1
replace empl=2 if WRKST ==2
replace empl=1 if WRKST ==5
lab def empl ///
	1 "Unemployed" ///
	2 "Employed" 
lab val empl empl
lab var empl "Employment Status - 2"
tab empl


gen employee=.
replace employee =2 if WRKTYPE ==4
replace employee =1 if WRKTYPE ==1
replace employee =1 if WRKTYPE ==2
replace employee =1 if WRKTYPE ==3
replace employee =1 if WRKTYPE ==6
replace employee =1 if WRKTYPE ==5
lab def employee ///
	1 "Employed" ///
	2 "Self Employed" 
lab val employee employee
lab var employee "Employee"
tab employee

recode WRKST 0=., gen(emplB)
lab def emplB ///
	1 "Employed FT" ///
	2 "Employed PT" ///
	3 "Less than PT" ///
	4 "Helping Family Member" ///
	5 "Unemployed" ///
	6 "Student" ///
	7 "Retired" ///
	8 "Housewife/man" ///
	9 "Perm. dis" ///
	10 "Not in LF" 
lab val emplB emplB
lab var emplB "Employment Status"
tab emplB

gen education=.
replace education=1 if DEGREE==0
replace education=1 if DEGREE==1
replace education=2 if DEGREE==2
replace education=3 if DEGREE==3
replace education=4 if DEGREE==4
replace education=5 if DEGREE==5
lab def education ///
	1 "Less than lower secondary" ///
	2 "Lower Secondary" ///
	3 "Upper Secondary" ///
	4 "Vocational" ///
	5 "Degree" 
lab val education education
lab var education "Education Collapsed"
tab education
}

if `parties'==1 {


gen vote=VOTE_LE

gen party_type=.
replace party_type=1 if country==40
replace party_type=2 if country==36
replace party_type=1 if country==56
replace party_type=2 if country==756
replace party_type=1 if country==276
replace party_type=3 if country==208
replace party_type=2 if country==724
replace party_type=1 if country==246
replace party_type=2 if country==250
replace party_type=1 if country==826
replace party_type=1 if country==380
replace party_type=2 if country==392
replace party_type=1 if country==578
replace party_type=3 if country==554
replace party_type=2 if country==620
replace party_type=2 if country==752
replace party_type=2 if country==840


gen party=.
replace party=1 if AU_PRTY==1 & country==36 
replace party=2 if AU_PRTY ==2 & country==36 
replace party=3 if AU_PRTY ==3 & country==36 
replace party=4 if AU_PRTY ==4 & country==36 
replace party=7 if AU_PRTY ==5 & country==36 
replace party=8 if AU_PRTY ==6 & country==36 
replace party=9 if AU_PRTY ==7 & country==36 
replace party=96 if AU_PRTY ==95 & country ==36
replace party=97 if AU_PRTY ==96 & country ==36
replace party=99 if AU_PRTY ==.a & country ==36 | AU_PRTY ==.b & country ==36

replace party=1 if AT_PRTY==2 & country==40 
replace party=2 if AT_PRTY ==1 & country== 40 
replace party=3 if AT_PRTY ==3 & country== 40 
replace party=4 if AT_PRTY ==4 & country== 40 
replace party=7 if AT_PRTY ==6 & country== 40 
replace party=10 if AT_PRTY ==5 & country== 40 
replace party=96 if AT_PRTY ==95 & country == 40
replace party=97 if AT_PRTY ==96 & country == 40
replace party=99 if AT_PRTY ==.a & country ==40 | AT_PRTY ==.b & country ==40
replace party=99 if AT_PRTY ==.c & country ==40 | AT_PRTY ==.d & country ==40

replace party=BE_PRTY if country == 56
replace party=96 if BE_PRTY ==12 & country == 56
replace party=96 if BE_PRTY ==10 & country == 56
replace party=96 if BE_PRTY ==95 & country == 56
replace party=97 if BE_PRTY ==96 & country == 56
replace party=99 if BE_PRTY ==.a & country ==56 | BE_PRTY ==.b & country ==56
replace party=99 if BE_PRTY ==.c & country ==56 | BE_PRTY ==.d & country ==56


replace party =1 if DK_PRTY==1 & country ==208
replace party =2 if DK_PRTY==2 & country ==208
replace party =3 if DK_PRTY==3 & country ==208
replace party =5 if DK_PRTY==4 & country ==208
replace party =6 if DK_PRTY==6 & country ==208
replace party =7 if DK_PRTY==5 & country ==208
replace party =9 if DK_PRTY==7 & country ==208
replace party =11 if DK_PRTY==9 & country ==208
replace party =12 if DK_PRTY==8 & country ==208
replace party =96 if DK_PRTY ==94 & country == 208
replace party =96 if DK_PRTY ==95 & country == 208
replace party =97 if DK_PRTY ==96 & country == 208
replace party=99 if DK_PRTY ==.a & country ==208| DK_PRTY ==.b & country ==208
replace party=99 if DK_PRTY ==.c & country ==208 | DK_PRTY ==.d & country ==208

replace party = FI_PRTY if country ==246 & FI_PRTY<=96
replace party =96 if FI_PRTY ==95 & country == 246
replace party =99 if FI_PRTY ==96 & country == 246
replace party =99 if FI_PRTY ==97 & country == 246
replace party =99 if FI_PRTY ==98 & country == 246
replace party=99 if FI_PRTY ==.a & country ==246| FI_PRTY ==.b & country ==246
replace party=99 if FI_PRTY ==.c & country ==246 | FI_PRTY ==.d & country ==246


replace party=1 if FR_PRTY==1 & country==250  & FR_PRTY<=96
replace party=2 if FR_PRTY==2 & country== 250 
replace party=3 if FR_PRTY==3 & country== 250 
replace party=4 if FR_PRTY==4 & country== 250 
replace party=5 if FR_PRTY==5 & country== 250 
replace party=6 if FR_PRTY==6 & country== 250 
replace party=7 if FR_PRTY==7 & country== 250 
replace party=96 if FR_PRTY ==95 & country == 250
replace party=97  if FR_PRTY ==96 & country == 250
replace party=99 if FR_PRTY ==.a & country ==250| FR_PRTY ==.b & country ==250
replace party=99 if FR_PRTY ==.c & country ==250 | FR_PRTY ==.d & country ==250


replace party=1 if DE_PRTY==2 & country==276 
replace party=2 if DE_PRTY ==1 & country== 276 
replace party=4 if DE_PRTY ==3 & country== 276 
replace party=5 if DE_PRTY ==5 & country== 276 
replace party=6 if DE_PRTY ==6 & country== 276 
replace party=9 if DE_PRTY ==4 & country== 276 
replace party=11 if DE_PRTY ==7 & country== 276 
replace party=96 if DE_PRTY ==95 & country == 276
replace party=99  if DE_PRTY ==94 & country == 276
replace party=97  if DE_PRTY ==96 & country == 276
replace party=99 if DE_PRTY ==.a & country ==276| DE_PRTY ==.b & country ==276
replace party=99 if DE_PRTY ==.c & country ==276 | DE_PRTY ==.d & country ==276



replace party=45 if IT_PRTY==1 & country==380
replace party=46 if IT_PRTY==2 & country==380
replace party=37 if IT_PRTY==3 & country==380
replace party=34 if IT_PRTY==4 & country==380
replace party=47 if IT_PRTY==5 & country==380
replace party=18 if IT_PRTY==6 & country==380
replace party=48 if IT_PRTY==7 & country==380
replace party=17 if IT_PRTY==8 & country==380
replace party=11 if IT_PRTY==9 & country==380
replace party=44 if IT_PRTY==10 & country==380
replace party=40 if IT_PRTY==11 & country==380
replace party=49 if IT_PRTY==12 & country==380
replace party=22 if IT_PRTY==14 & country==380
replace party=96 if IT_PRTY==17 & country==380
replace party=96 if IT_PRTY==18 & country==380
replace party=96 if IT_PRTY==95 & country==380
replace party=97 if IT_PRTY==96 & country==380
replace party=99 if IT_PRTY ==.a & country ==380| IT_PRTY ==.b & country ==380
replace party=99 if IT_PRTY ==.c & country ==380 | IT_PRTY ==.d & country ==380


replace party=1 if JP_PRTY==1 & country==392 
replace party=2 if JP_PRTY ==6 & country== 392 
replace party=3 if JP_PRTY ==4 & country== 392 
replace party=4 if JP_PRTY ==5 & country== 392 
replace party=9 if JP_PRTY ==2 & country== 392 
replace party=10 if JP_PRTY ==3 & country== 392 
replace party=96 if JP_PRTY ==95 & country == 392
replace party=99  if JP_PRTY ==96 & country == 392
replace party=96  if JP_PRTY ==97 & country == 392
replace party=99 if JP_PRTY ==.a & country ==392| JP_PRTY ==.b & country ==392
replace party=99 if JP_PRTY ==.c & country ==392 | JP_PRTY ==.d & country ==392

replace party=2 if KR_PRTY==2 & country == 410
replace party=3 if KR_PRTY==3 & country == 410
replace party=5 if KR_PRTY==5 & country == 410
replace party=6 if KR_PRTY==1 & country == 410
replace party=7 if KR_PRTY==4 & country == 410
replace party=8 if KR_PRTY==6 & country == 410
replace party =96 if KR_PRTY ==95 & country == 410
replace party =97 if KR_PRTY ==96 & country == 410
replace party=99 if KR_PRTY ==.a & country ==410| KR_PRTY ==.b & country ==410
replace party=99 if KR_PRTY ==.c & country ==410 | KR_PRTY ==.d & country ==410

replace party=1 if NZ_PRTY ==4 & country== 554 
replace party=2 if NZ_PRTY ==5 & country== 554 
replace party=3 if NZ_PRTY ==7 & country== 554 
replace party=9 if NZ_PRTY ==8 & country== 554 
replace party=11 if NZ_PRTY ==2 & country== 554 
replace party=12 if NZ_PRTY ==1 & country== 554 
replace party=14 if NZ_PRTY ==10 & country== 554 
replace party=15 if NZ_PRTY ==9 & country== 554 
replace party=16 if NZ_PRTY ==6 & country== 554 
replace party=17 if NZ_PRTY ==3 & country== 554 
replace party=96 if NZ_PRTY ==95 & country == 554
replace party=97  if NZ_PRTY == 96 & country == 554
replace party=99 if NZ_PRTY ==.a & country ==554| NZ_PRTY ==.b & country ==554
replace party=99 if NZ_PRTY ==.c & country ==554 | NZ_PRTY ==.d & country ==554

replace party=1 if NO_PRTY==3 & country==578 
replace party=2 if NO_PRTY ==4 & country== 578 
replace party=3 if NO_PRTY ==6 & country== 578 
replace party=4 if NO_PRTY ==5 & country== 578 
replace party=5 if NO_PRTY ==8 & country== 578 
replace party=6 if NO_PRTY ==2 & country== 578 
replace party=7 if NO_PRTY ==7 & country== 578 
replace party=10 if NO_PRTY ==1 & country== 578 
replace party=96 if NO_PRTY ==95 & country == 578
replace party=97  if NO_PRTY == 96 & country == 578
replace party=99 if NO_PRTY ==.a & country ==578| NO_PRTY ==.b & country ==578
replace party=99 if NO_PRTY ==.c & country ==578 | NO_PRTY ==.d & country ==578


replace party=1 if PT_PRTY ==2 & country ==620
replace party=2 if PT_PRTY ==3 & country ==620
replace party=3 if PT_PRTY ==4 & country ==620
replace party=4 if PT_PRTY ==5 & country ==620
replace party=5 if PT_PRTY ==6 & country ==620
replace party=6 if PT_PRTY ==7 & country ==620
replace party=8 if PT_PRTY ==1 & country ==620
replace party=96 if PT_PRTY == 95 & country == 620
replace party=97 if PT_PRTY == 96 & country == 620
replace party=99 if PT_PRTY ==.a & country ==620| PT_PRTY ==.b & country ==620
replace party=99 if PT_PRTY ==.c & country ==620 | PT_PRTY ==.d & country ==620


replace party=1 if ES_PRTY==1 & country==724 
replace party=3 if ES_PRTY ==2 & country== 724 
replace party=4 if ES_PRTY ==3 & country== 724 
replace party=6 if ES_PRTY ==4 & country== 724 
replace party=5 if ES_PRTY ==5 & country== 724 
replace party=5 if ES_PRTY ==6 & country== 724 
replace party=6 if ES_PRTY ==8 & country== 724 
replace party=6 if ES_PRTY ==9 & country== 724 
replace party=6 if ES_PRTY ==10 & country== 724 
replace party=96 if ES_PRTY ==94 & country == 724
replace party= 96 if ES_PRTY ==95 & country == 724
replace party=99  if ES_PRTY == 97 & country == 724
replace party=99 if ES_PRTY ==.a & country ==724| ES_PRTY ==.b & country ==724
replace party=99 if ES_PRTY ==.c & country ==724 | ES_PRTY ==.d & country ==724

replace party=1 if SE_PRTY==1 & country==752 
replace party=2 if SE_PRTY ==2 & country== 752 
replace party=3 if SE_PRTY ==3 & country== 752 
replace party=4 if SE_PRTY ==4 & country== 752 
replace party=5 if SE_PRTY ==5 & country== 752 
replace party=6 if SE_PRTY ==6 & country== 752 
replace party=7 if SE_PRTY ==8 & country== 752 
replace party=8 if SE_PRTY ==7 & country== 752 
replace party=96 if SE_PRTY ==95 & country == 752
replace party=97  if SE_PRTY == 96 & country == 752
replace party=99 if SE_PRTY ==.a & country ==752| SE_PRTY ==.b & country ==752
replace party=99 if SE_PRTY ==.c & country ==752 | SE_PRTY ==.d & country ==752

replace party=1 if CH_PRTY==1 & country==756 
replace party=2 if CH_PRTY ==2 & country== 756 
replace party=3 if CH_PRTY ==3 & country== 756 
replace party=4 if CH_PRTY ==4 & country== 756 
replace party=6 if CH_PRTY ==5 & country== 756 
replace party=7 if CH_PRTY ==6 & country== 756 
replace party=12 if CH_PRTY ==7 & country== 756 
replace party=8 if CH_PRTY ==8 & country== 756 
replace party=10 if CH_PRTY ==9 & country== 756 
replace party=20 if CH_PRTY ==10 & country== 756 
replace party=15 if CH_PRTY ==11 & country== 756 
replace party=17 if CH_PRTY ==12 & country== 756 
replace party=16 if CH_PRTY ==13 & country== 756 
replace party=99  if CH_PRTY ==90 & country== 756 
replace party=96 if CH_PRTY ==95 & country == 756
replace party=97  if CH_PRTY ==96 & country == 756
replace party=99 if CH_PRTY ==.a & country ==756| CH_PRTY ==.b & country ==756
replace party=99 if CH_PRTY ==.c & country ==756 | CH_PRTY ==.d & country ==756

replace party=1 if GB_PRTY==1 & country==826 
replace party=2 if GB_PRTY ==2 & country== 826 
replace party=3 if GB_PRTY ==3 & country== 826 
replace party=4 if GB_PRTY ==6 & country== 826 
replace party=5 if GB_PRTY ==7 & country== 826 
replace party=6 if GB_PRTY ==8 & country== 826 
replace party=99 if GB_PRTY ==93 & country == 826
replace party=96 if GB_PRTY ==95 & country == 826
replace party=97  if GB_PRTY ==96 & country == 826
replace party=99 if GB_PRTY ==.a & country ==826| GB_PRTY ==.b & country ==826
replace party=99 if GB_PRTY ==.c & country ==826 | GB_PRTY ==.d & country ==826


replace party=US_PRTY if country == 840
replace party=96 if US_PRTY ==95 & country == 840
replace party=99 if US_PRTY ==.a & country ==826| US_PRTY ==.b & country ==826
replace party=99 if US_PRTY ==.c & country ==826 | US_PRTY ==.d & country ==826

lab val party party
lab var party "Party Choice"
tab party

 gen party_lr=PARTY_LR
 }

if `occupation_recode'==1 {
gen isco= ISCO88

recode isco 9995=.
gen isco_string=string(isco)
 gen isco_3s=substr(isco_string, 1, 3)
destring isco_3s, replace
gen isco_combined=isco_3s
replace isco_combined=isco_3 if isco_combined==.
replace isco_combined=isco_3 if isco_combined==.
replace isco_combined=. if isco_combined==0
replace isco_combined=. if isco_combined==9999
gen isco_2=substr(isco_string, 1, 2)

merge m:1 isco_2 using "Occupation_GROUPS.dta"

}

drop V*
drop if country==.
drop SEX AGE COHAB MARITAL EDUCYRS DEGREE AR* AT* AU* BE* BG* CH* CL* CN* CY* CZ* DE* DK* EE* ES*  FI* FR* GB* HR* HU* IL* IS* JP* KR* LV* NO* NZ* PH* PL* PT* RU* SE* SI* SK* TR* TW* UA* US* ZA*  C_ALPHAN WRKST WRKHRS ISCO88 WRKSUP WRKTYPE NEMPLOY UNION SPWRKST SPISCO88 SPWRKTYP HOMPOP HHCYCLE PARTY_LR RELIG RELIGGRP ATTEND TOPBOT URBRURAL ETHNIC MODE WEIGHT
drop IT* SUBSCASE

save `temp09', replace
}



if `year_2010'==1 {
********
* 2010 *
********
use "ZA5500.dta", clear

local main_variables 1
local parties 1
local occupation_recode 1

if `main_variables'==1 {
gen YYYY=2010
lab var YYYY "Survey Year"

gen weight=WEIGHT
recode weight 0=.
lab val weight weight
lab var weight "Weight"


gen country=.
replace country=40 if V4==40
replace country= 56 if V4==56
replace country= 124 if V4==124
replace country=208 if V4==208
replace country=246 if V4==246
replace country=250 if V4==250
replace country =276 if V4==276
replace country=392 if V4==392
replace country =528 if V4==528
replace country=554 if V4==554
replace country=578 if V4==578
replace country=620 if V4==620
replace country=724 if V4==724
replace country=752 if V4==752
replace country=756 if V4==756
replace country =826 if V4==826
replace country=840 if V4==840
lab def country ///
	124 "Canada" ///
	40 "Austria" ///
	56 "Belgium" ///
	208 "Denmark" ///
	246 "Finland" ///
	250 "France" ///
	276 "Germany" ///
	372 "Ireland" ///
	392 "Japan" ///
	528 "Netherlands" ///
	554 "New Zealand" ///
	578 "Norway" ///
	620 "Portugal" ///
	724 "Spain" ///
	752 "Sweden" ///
	756 "Switzerland" ///
	826 "UK" ///
	840 "USA" 
lab val country country
lab var country "Country"
tab country

gen east_germany=1 if V3==276.2


gen sex=SEX
recode sex 0=.

tab AGE
gen age=AGE

gen birth=2010-age
label var birth "Year of Birth"

gen empl=.
replace empl=2 if WORK ==1
replace empl=1 if WORK ==2
replace empl=1 if WORK ==3
lab def empl ///
	1 "Not in Work" ///
	2 "Employed" 
lab val empl empl
lab var empl "Employment Status - 2"
tab empl



gen employee=.
replace employee =2 if EMPREL ==2
replace employee =2 if EMPREL ==3
replace employee =1 if EMPREL ==1
replace employee =1 if EMPREL ==4
lab def employee ///
	1 "Employed" ///
	2 "Self Employed" 
lab val employee employee
lab var employee "Employee"
tab employee


gen emplB=.
replace emplB=1 if MAIN==1
replace emplB=5 if MAIN==2
replace emplB=6 if MAIN==3
replace emplB=6 if MAIN==4
replace emplB=7 if MAIN==6
replace emplB=8 if MAIN==7
replace emplB=1 if MAIN==8
replace emplB=9 if MAIN==5
replace emplB=10 if MAIN==9
replace emplB=10 if MAIN==10

lab def emplB ///
	1 "Employed FT" ///
	2 "Employed PT" ///
	3 "Less than PT" ///
	4 "Helping Family Member" ///
	5 "Unemployed" ///
	6 "Student" ///
	7 "Retired" ///
	8 "Housewife/man" ///
	9 "Perm. dis" ///
	10 "Not in LF" 
lab val emplB emplB
lab var emplB "Employment Status"
tab emplB

gen education=.
replace education=1 if DEGREE==0
replace education=1 if DEGREE==1
replace education=2 if DEGREE==2
replace education=3 if DEGREE==3
replace education=4 if DEGREE==4
replace education=5 if DEGREE==5

lab def education ///
	1 "Less than lower secondary" ///
	2 "Lower Secondary" ///
	3 "Upper Secondary" ///
	4 "Vocational" ///
	5 "Degree" 
lab val education education
lab var education "Education Collapsed"
tab education
}

if `parties'==1 {

gen vote=VOTE_LE

gen party_type=.
replace party_type=1 if country==40
replace party_type=2 if country==56
replace party_type=2 if country==124
replace party_type=2 if country==756
replace party_type=1 if country==276
replace party_type=3 if country==208
replace party_type=2 if country==724
replace party_type=2 if country==246
replace party_type=2 if country==250
replace party_type=1 if country==826
replace party_type=2 if country==392
replace party_type=3 if country==578
replace party_type=3 if country==554
replace party_type=2 if country==752
replace party_type=2 if country==840


gen party=.

replace party=1 if AT_PRTY==2 & country==40 
replace party=2 if AT_PRTY ==1 & country== 40 
replace party=3 if AT_PRTY ==3 & country== 40 
replace party=4 if AT_PRTY ==4 & country== 40 
replace party=7 if AT_PRTY ==6 & country== 40 
replace party=11 if AT_PRTY ==5 & country== 40 
replace party=96 if AT_PRTY ==94 & country == 40
replace party=97 if AT_PRTY ==95 & country == 40
replace party=97 if AT_PRTY ==96 & country == 40
replace party=99 if AT_PRTY ==.a & country == 40 
replace party=99 if AT_PRTY ==.b & country == 40 
replace party=99 if AT_PRTY ==.c & country == 40 

replace party=1 if BE_PRTY==1 & country == 56
replace party=2 if BE_PRTY==2 & country == 56
replace party=3 if BE_PRTY==3 & country == 56
replace party=4 if BE_PRTY==4 & country == 56
replace party=5 if BE_PRTY==5 & country == 56
replace party=7 if BE_PRTY==6 & country == 56
replace party=8 if BE_PRTY==7 & country == 56
replace party=16 if BE_PRTY==8 & country == 56
replace party=14 if BE_PRTY==11 & country == 56
replace party=12 if BE_PRTY==12 & country == 56
replace party=20 if BE_PRTY==12 & country == 56
replace party=96 if BE_PRTY ==13 & country == 56
replace party=96 if BE_PRTY ==94 & country == 56
replace party=96 if BE_PRTY ==95 & country == 56
replace party=97 if BE_PRTY ==96 & country == 56
replace party=99 if BE_PRTY ==.a & country == 56 
replace party=99 if BE_PRTY ==.b & country == 56 
replace party=99 if BE_PRTY ==.c & country == 56 

replace party=1 if CA_PRTY==1 & country==124 
replace party=2 if CA_PRTY ==2 & country== 124 
replace party=3 if CA_PRTY ==3 & country== 124 
replace party=4 if CA_PRTY ==4 & country== 124 
replace party=9 if CA_PRTY ==5 & country== 124 
replace party=96 if CA_PRTY ==95 & country == 124
replace party=99 if CA_PRTY ==.a & country == 124 
replace party=99 if CA_PRTY ==.b & country == 124 
replace party=99 if CA_PRTY ==.c & country == 124 



replace party =1 if DK_PRTY==1 & country ==208
replace party =2 if DK_PRTY==2 & country ==208
replace party =3 if DK_PRTY==3 & country ==208
replace party =5 if DK_PRTY==4 & country ==208
replace party =6 if DK_PRTY==6 & country ==208
replace party =7 if DK_PRTY==5 & country ==208
replace party =9 if DK_PRTY==7 & country ==208
replace party =11 if DK_PRTY==9 & country ==208
replace party =12 if DK_PRTY==8 & country ==208
replace party =96 if DK_PRTY ==94 & country == 208
replace party =96 if DK_PRTY ==95 & country == 208
replace party =97 if DK_PRTY ==96 & country == 208
replace party=99 if DK_PRTY ==.a & country == 208 
replace party=99 if DK_PRTY ==.b & country == 208 
replace party=99 if DK_PRTY ==.c & country == 208 

replace party = FI_PRTY if country ==246 & FI_PRTY<=96
replace party =96 if FI_PRTY ==95 & country == 246
replace party = 97 if FI_PRTY ==96 & country == 246
replace party=99 if FI_PRTY ==.a & country == 246 
replace party=99 if FI_PRTY ==.b & country == 246 
replace party=99 if FI_PRTY ==.c & country == 246 


replace party=1 if FR_PRTY==1 & country==250 
replace party=2 if FR_PRTY==2 & country== 250 
replace party=3 if FR_PRTY==3 & country== 250 
replace party=4 if FR_PRTY==4 & country== 250 
replace party=8 if FR_PRTY==5 & country== 250 
replace party=6 if FR_PRTY==6 & country== 250 
replace party=7 if FR_PRTY==7 & country== 250 
replace party=96 if FR_PRTY ==95 & country == 250
replace party=97 if FR_PRTY ==96 & country == 250
replace party=99 if FR_PRTY ==.a & country == 250 
replace party=99 if FR_PRTY ==.b & country == 250 
replace party=99 if FR_PRTY ==.c & country == 250 


replace party=1 if DE_PRTY==2 & country==276 
replace party=2 if DE_PRTY ==1 & country== 276 
replace party=4 if DE_PRTY ==3 & country== 276 
replace party=5 if DE_PRTY ==5 & country== 276 
replace party=6 if DE_PRTY ==6 & country== 276 
replace party=9 if DE_PRTY ==4 & country== 276 
replace party=11 if DE_PRTY ==7 & country== 276 
replace party=96 if DE_PRTY ==95 & country == 276
replace party=99 if DE_PRTY ==94 & country == 276
replace party= 97 if DE_PRTY ==96 & country == 276
replace party=99 if DE_PRTY ==.a & country == 276 
replace party=99 if DE_PRTY ==.b & country == 276 
replace party=99 if DE_PRTY ==.c & country == 276 




replace party=1 if JP_PRTY==1 & country==392 
replace party=2 if JP_PRTY ==6 & country== 392 
replace party=3 if JP_PRTY ==4 & country== 392 
replace party=4 if JP_PRTY ==5 & country== 392 
replace party=9 if JP_PRTY ==2 & country== 392 
replace party=10 if JP_PRTY ==3 & country== 392 
replace party=13 if JP_PRTY ==7 & country== 392 
replace party=96 if JP_PRTY ==95 & country == 392
replace party=97 if JP_PRTY ==96 & country == 392
replace party=99 if JP_PRTY ==.a & country == 392 
replace party=99 if JP_PRTY ==.b & country == 392 
replace party=99 if JP_PRTY ==.c & country == 392 

replace party=2 if KR_PRTY==1 & country == 410
replace party=3 if KR_PRTY==2 & country == 410
replace party=5 if KR_PRTY==5 & country == 410
replace party=6 if KR_PRTY==3 & country == 410
replace party=9 if KR_PRTY==4 & country == 410
replace party=10 if KR_PRTY==6 & country == 410
replace party=11 if KR_PRTY==7 & country == 410
replace party=12 if KR_PRTY==8 & country == 410
replace party =96 if KR_PRTY ==9 & country == 410
replace party =96 if KR_PRTY ==95 & country == 410
replace party =97 if KR_PRTY ==96 & country == 410
replace party=99 if KR_PRTY ==.a & country == 410 
replace party=99 if KR_PRTY ==.b & country == 410 
replace party=99 if KR_PRTY ==.c & country == 410 

replace party=1 if NZ_PRTY ==4 & country== 554 
replace party=2 if NZ_PRTY ==5 & country== 554 
replace party=3 if NZ_PRTY ==7 & country== 554 
replace party=9 if NZ_PRTY ==8 & country== 554 
replace party=11 if NZ_PRTY ==2 & country== 554 
replace party=12 if NZ_PRTY ==1 & country== 554 
replace party=14 if NZ_PRTY ==10 & country== 554 
replace party=15 if NZ_PRTY ==9 & country== 554 
replace party=16 if NZ_PRTY ==6 & country== 554 
replace party=17 if NZ_PRTY ==3 & country== 554 
replace party=96 if NZ_PRTY ==95 & country == 554
replace party=97 if NZ_PRTY == 96 & country == 554
replace party=99 if NZ_PRTY ==.a & country == 554 
replace party=99 if NZ_PRTY ==.b & country == 554 
replace party=99 if NZ_PRTY ==.c & country == 554 

replace party=1 if NO_PRTY==3 & country==578 
replace party=2 if NO_PRTY ==4 & country== 578 
replace party=3 if NO_PRTY ==6 & country== 578 
replace party=4 if NO_PRTY ==5 & country== 578 
replace party=5 if NO_PRTY ==8 & country== 578 
replace party=6 if NO_PRTY ==2 & country== 578 
replace party=7 if NO_PRTY ==7 & country== 578 
replace party=10 if NO_PRTY ==1 & country== 578 
replace party=96 if NO_PRTY ==95 & country == 578
replace party=97 if NO_PRTY == 96 & country == 578
replace party=99 if NO_PRTY ==.a & country == 578 
replace party=99 if NO_PRTY ==.b & country == 578 
replace party=99 if NO_PRTY ==.c & country == 578 

replace party=1 if ES_PRTY==2 & country==724 
replace party=3 if ES_PRTY ==1 & country== 724 
replace party=4 if ES_PRTY ==3 & country== 724 
replace party=5 if ES_PRTY ==4 & country== 724 
replace party=6 if ES_PRTY ==5 & country== 724 
replace party=5 if ES_PRTY ==6 & country== 724 
replace party=6 if ES_PRTY ==7 & country== 724 
replace party=6 if ES_PRTY ==8 & country== 724 
replace party=5 if ES_PRTY ==9 & country== 724 
replace party=6 if ES_PRTY ==10 & country== 724 
replace party=5 if ES_PRTY ==11 & country== 724 
replace party=96 if ES_PRTY ==94 & country == 724
replace party=96 if ES_PRTY ==95 & country == 724
replace party=97 if ES_PRTY == 96 & country == 724
replace party=99 if ES_PRTY ==.a & country == 724 
replace party=99 if ES_PRTY ==.b & country == 724 
replace party=99 if ES_PRTY ==.c & country == 724 


replace party=1 if SE_PRTY==1 & country==752 
replace party=2 if SE_PRTY ==2 & country== 752 
replace party=3 if SE_PRTY ==3 & country== 752 
replace party=4 if SE_PRTY ==4 & country== 752 
replace party=5 if SE_PRTY ==5 & country== 752 
replace party=6 if SE_PRTY ==6 & country== 752 
replace party=7 if SE_PRTY ==7 & country== 752 
replace party=8 if SE_PRTY ==10 & country== 752 
replace party=9 if SE_PRTY ==8 & country== 752 
replace party=10 if SE_PRTY ==9 & country== 752 
replace party=96 if SE_PRTY ==95 & country == 752
replace party=97 if SE_PRTY == 96 & country == 752
replace party=99 if SE_PRTY ==.a & country == 752 
replace party=99 if SE_PRTY ==.b & country == 752 
replace party=99 if SE_PRTY ==.c & country == 752 

replace party=1 if CH_PRTY==1 & country==756 
replace party=2 if CH_PRTY ==2 & country== 756 
replace party=3 if CH_PRTY ==3 & country== 756 
replace party=4 if CH_PRTY ==4 & country== 756 
replace party=18 if CH_PRTY ==5 & country== 756 
replace party=7 if CH_PRTY ==6 & country== 756 
replace party=12 if CH_PRTY ==7 & country== 756 
replace party=8 if CH_PRTY ==8 & country== 756 
replace party=10 if CH_PRTY ==9 & country== 756 
replace party=20 if CH_PRTY ==10 & country== 756 
replace party=15 if CH_PRTY ==11 & country== 756 
replace party=17 if CH_PRTY ==12 & country== 756 
replace party=16 if CH_PRTY ==13 & country== 756 
replace party=96 if CH_PRTY ==95 & country == 756
replace party=97 if CH_PRTY ==96 & country == 756
replace party=99 if CH_PRTY ==.a & country == 756 
replace party=99 if CH_PRTY ==.b & country == 756 
replace party=99 if CH_PRTY ==.c & country == 756 

replace party=1 if GB_PRTY==1 & country==826 
replace party=2 if GB_PRTY ==2 & country== 826 
replace party=3 if GB_PRTY ==3 & country== 826 
replace party=4 if GB_PRTY ==6 & country== 826 
replace party=5 if GB_PRTY ==7 & country== 826 
replace party=6 if GB_PRTY ==8 & country== 826 
replace party=96 if GB_PRTY ==93 & country == 826
replace party=96 if GB_PRTY ==95 & country == 826
replace party=97 if GB_PRTY ==96 & country == 826
replace party=99 if GB_PRTY ==.a & country == 826 
replace party=99 if GB_PRTY ==.b & country == 826 
replace party=99 if GB_PRTY ==.c & country == 826 


replace party=US_PRTY if country == 840
replace party=96 if US_PRTY ==95 & country == 840
replace party=99 if US_PRTY ==.a & country == 840 
replace party=99 if US_PRTY ==.b & country == 840 
replace party=99 if US_PRTY ==.c & country == 840 


lab val party party
lab var party "Party Choice"
tab party

}
if `occupation_recode'==1 {


gen isco= ISCO88

recode isco 9995=.
gen isco_string=string(isco)
 gen isco_3s=substr(isco_string, 1, 3)
destring isco_3s, replace
gen isco_combined=isco_3s
replace isco_combined=isco_3 if isco_combined==.
replace isco_combined=isco_3 if isco_combined==.
replace isco_combined=. if isco_combined==0
replace isco_combined=. if isco_combined==9999
gen isco_2=substr(isco_string, 1, 2)

merge m:1 isco_2 using "Occupation_GROUPS.dta"



}


drop V*
drop if country==.
drop BIRTH WORK EMPREL NSUP TYPORG1 TYPORG2 MAIN PARTLIV SPWORK SPWRKHRS SPEMPREL SPWRKSUP SPMAINST HHCHILDR HHTODD SUBSCASE DATEYR DATEMO DATEDY SEX AGE MARITAL EDUCYRS DEGREE AR* AT* BE* BG* CA* CH* CL* CZ* DE* DK* ES*  FI* FR* GB* HR* IL*  JP* KR* LT* LV* MX* NO* NZ* PH* RU* SE* SI* SK* TR* TW* US* ZA*  C_ALPHAN WRKHRS ISCO88 WRKSUP NEMPLOY UNION SPISCO88 HOMPOP PARTY_LR RELIG RELIGGRP ATTEND TOPBOT URBRURAL MODE WEIGHT

save `temp10', replace

}
if `year_2011'==1 {
********
* 2011 *
********
use "ZA5800.dta", clear
local main_variables 1
local parties 1
local occupation_recode 1

if `main_variables'==1 {

gen weight=WEIGHT

gen YYYY=2011
lab var YYYY "Survey Year"


gen country=.
replace country=36 if V4==36
replace country=56 if V4==56
replace country=208 if V4== 208
replace country=246 if V4==246
replace country=250 if V4==250
replace country =276 if V4==276
replace country=392 if V4==392
replace country=411 if V4== 411
replace country =528 if V4==528
replace country=578 if V4==578
replace country=620 if V4==620
replace country=752 if V4==752
replace country=756 if V4==756
replace country =826 if V4==826
replace country=840 if V4==840
lab def country ///
	36 "Australia" ///
	56 "Belgium" ///
	208 "Denmark" ///
	246 "Finland" ///
	250 "France" ///
	276 "Germany" ///
	392 "Japan" ///
	411 "Korea" ///
	528 "Netherlands" ///
	578 "Norway" ///
	620 "Portugal" ///
	752 "Sweden" ///
	756 "Switzerland" ///
	826 "UK" ///
	840 "USA" 
lab val country country
lab var country "Country"
tab country

gen east_germany=1 if V3==27602


gen sex=SEX
recode sex 0=.

gen age=AGE

gen birth=2011-age
label var birth "Year of Birth"

gen empl=.
replace empl=2 if WORK ==1
replace empl=1 if WORK ==2
replace empl=1 if WORK ==3
lab def empl ///
	1 "Not in Work" ///
	2 "Employed" 
lab val empl empl
lab var empl "Employment Status - 2"
tab empl



gen employee=.
replace employee =2 if EMPREL ==2
replace employee =2 if EMPREL ==3
replace employee =1 if EMPREL ==1
replace employee =1 if EMPREL ==4
lab def employee ///
	1 "Employed" ///
	2 "Self Employed" 
lab val employee employee
lab var employee "Employee"
tab employee


gen emplB=.
replace emplB=1 if MAIN==1
replace emplB=5 if MAIN==2
replace emplB=6 if MAIN==3
replace emplB=6 if MAIN==4
replace emplB=7 if MAIN==6
replace emplB=8 if MAIN==7
replace emplB=1 if MAIN==8
replace emplB=9 if MAIN==5
replace emplB=11 if MAIN==9
replace emplB=11 if MAIN==11

lab def emplB ///
	1 "Employed FT" ///
	2 "Employed PT" ///
	3 "Less than PT" ///
	4 "Helping Family Member" ///
	5 "Unemployed" ///
	6 "Student" ///
	7 "Retired" ///
	8 "Housewife/man" ///
	9 "Perm. dis" ///
	11 "Not in LF" 
lab val emplB emplB
lab var emplB "Employment Status"
tab emplB



gen education=.
replace education=1 if DEGREE==0
replace education=1 if DEGREE==1
replace education=2 if DEGREE==2
replace education=3 if DEGREE==3
replace education=4 if DEGREE==4
replace education=5 if DEGREE==5

lab def education ///
	1 "Less than lower secondary" ///
	2 "Lower Secondary" ///
	3 "Upper Secondary" ///
	4 "Vocational" ///
	5 "Degree" 
lab val education education
lab var education "Education Collapsed"
tab education

}

if `parties'==1 {

gen party_type=3

gen vote=VOTE_LE

gen party=.
replace party=1 if AU_PRTY==2 & country==36 
replace party=2 if AU_PRTY ==1 & country==36 
replace party=3 if AU_PRTY ==3 & country==36 
replace party=4 if AU_PRTY ==4 & country==36 
replace party=7 if AU_PRTY ==5 & country==36 
replace party=8 if AU_PRTY ==6 & country==36 
replace party=9 if AU_PRTY ==7 & country==36 
replace party=96 if AU_PRTY ==95 & country ==36
replace party=97 if VOTE_LE==2 & country ==36
replace party=99 if AU_PRTY==.a & country ==36
replace party=99 if AU_PRTY==.b & country ==36
replace party=99 if AU_PRTY==.c & country ==36
replace party=99 if AU_PRTY==.d & country ==36


replace party=1 if BE_PRTY==1 & country == 56
replace party=2 if BE_PRTY==2 & country == 56
replace party=3 if BE_PRTY==3 & country == 56
replace party=4 if BE_PRTY==4 & country == 56
replace party=5 if BE_PRTY==5 & country == 56
replace party=7 if BE_PRTY==6 & country == 56
replace party=8 if BE_PRTY==7 & country == 56
replace party=16 if BE_PRTY==8 & country == 56
replace party=11 if BE_PRTY==9 & country == 56
replace party=13 if BE_PRTY==10 & country == 56
replace party=14 if BE_PRTY==11 & country == 56
replace party=18 if BE_PRTY==12 & country == 56
replace party=96 if BE_PRTY ==13 & country == 56
replace party=96 if BE_PRTY ==94 & country == 56
replace party=96 if BE_PRTY ==95 & country == 56
replace party=97 if VOTE_LE==2 & country ==56
replace party=99 if BE_PRTY==.a & country ==56
replace party=99 if BE_PRTY==.b & country ==56
replace party=99 if BE_PRTY==.c & country ==56
replace party=99 if BE_PRTY==.d & country ==56



replace party =1 if DK_PRTY==1 & country ==208
replace party =2 if DK_PRTY==2 & country ==208
replace party =3 if DK_PRTY==3 & country ==208
replace party =5 if DK_PRTY==4 & country ==208
replace party =7 if DK_PRTY==5 & country ==208
replace party =6 if DK_PRTY==6 & country ==208
replace party =9 if DK_PRTY==7 & country ==208
replace party =12 if DK_PRTY==8 & country ==208
replace party =11 if DK_PRTY==9 & country ==208
replace party =96 if DK_PRTY ==95 & country == 208
replace party =99 if DK_PRTY ==96 & country == 208
replace party=97 if VOTE_LE==2 & country ==208
replace party=99 if DK_PRTY==.a & country ==208
replace party=99 if DK_PRTY==.b & country ==208
replace party=99 if DK_PRTY==.c & country ==208
replace party=99 if DK_PRTY==.d & country ==208


replace party = FI_PRTY if country ==246 & FI_PRTY<=96
replace party =96 if FI_PRTY ==95 & country == 246
replace party = 99 if FI_PRTY ==96 & country == 246
replace party = 99 if FI_PRTY ==97 & country == 246
replace party = 99 if FI_PRTY ==98 & country == 246
replace party=97 if VOTE_LE==2 & country ==246
replace party=99 if FI_PRTY==.a & country ==246
replace party=99 if FI_PRTY==.b & country ==246
replace party=99 if FI_PRTY==.c & country ==246
replace party=99 if FI_PRTY==.d & country ==246


replace party=2 if FR_PRTY==1 & country==250 
replace party=1 if FR_PRTY==2 & country== 250 
replace party=3 if FR_PRTY==3 & country== 250 
replace party=4 if FR_PRTY==4 & country== 250 
replace party=5 if FR_PRTY==5 & country== 250 
replace party=6 if FR_PRTY==6 & country== 250 
replace party=7 if FR_PRTY==7 & country== 250 
replace party=96 if FR_PRTY ==95 & country == 250
replace party=99 if FR_PRTY ==96 & country == 250
replace party=99 if FR_PRTY ==97 & country == 250
replace party=97 if VOTE_LE==2 & country ==250
replace party=99 if FR_PRTY==.a & country ==250
replace party=99 if FR_PRTY==.b & country ==250
replace party=99 if FR_PRTY==.c & country ==250
replace party=99 if FR_PRTY==.d & country ==250


replace party=2 if DE_PRTY ==1 & country== 276 
replace party=1 if DE_PRTY==2 & country==276 
replace party=4 if DE_PRTY ==3 & country== 276 
replace party=9 if DE_PRTY ==4 & country== 276 
replace party=5 if DE_PRTY ==5 & country== 276 
replace party=11 if DE_PRTY ==6 & country== 276 
replace party=6 if DE_PRTY ==7 & country== 276 
replace party=96 if DE_PRTY ==95 & country == 276
replace party=99 if DE_PRTY ==96 & country == 276
replace party=97 if VOTE_LE==2 & country ==276
replace party=99 if DE_PRTY==.a & country ==276
replace party=99 if DE_PRTY==.b & country ==276
replace party=99 if DE_PRTY==.c & country ==276
replace party=99 if DE_PRTY==.d & country ==276



replace party=9 if JP_PRTY==1 & country==392 
replace party=1 if JP_PRTY==2 & country==392 
replace party=3 if JP_PRTY ==3 & country== 392 
replace party=13 if JP_PRTY ==4 & country== 392
replace party=4 if JP_PRTY ==5 & country== 392  
replace party=2 if JP_PRTY ==6 & country== 392 
replace party=96 if JP_PRTY ==95 & country == 392
replace party=97 if VOTE_LE==2 & country ==392
replace party=99 if JP_PRTY==.a & country ==392
replace party=99 if JP_PRTY==.b & country ==392
replace party=99 if JP_PRTY==.c & country ==392
replace party=99 if JP_PRTY==.d & country ==392

replace party=2 if KR_PRTY==1 & country == 410
replace party=3 if KR_PRTY==2 & country == 410
replace party=6 if KR_PRTY==3 & country == 410
replace party=9 if KR_PRTY==4 & country == 410
replace party=5 if KR_PRTY==5 & country == 410
replace party=11 if KR_PRTY==6 & country == 410
replace party=11 if KR_PRTY==7 & country == 410
replace party=12 if KR_PRTY==8 & country == 410
replace party =96 if KR_PRTY ==9 & country == 410
replace party=97 if VOTE_LE==2 & country ==410
replace party=99 if KR_PRTY==.a & country ==410
replace party=99 if KR_PRTY==.b & country ==410
replace party=99 if KR_PRTY==.c & country ==410
replace party=99 if KR_PRTY==.d & country ==410

replace party =2 if NL_PRTY==1 & country==528
replace party =1 if NL_PRTY==2 & country==528
replace party =14 if NL_PRTY==3 & country==528
replace party =3 if NL_PRTY==4 & country==528
replace party =11 if NL_PRTY==5 & country==528
replace party =4 if NL_PRTY==6 & country==528
replace party =8 if NL_PRTY==7 & country==528
replace party =15 if NL_PRTY==8 & country==528
replace party =5 if NL_PRTY==9 & country==528
replace party =17 if NL_PRTY==10 & country==528
replace party =18 if NL_PRTY==11 & country==528
replace party =96 if NL_PRTY==12 & country==528
replace party=97 if VOTE_LE==2 & country ==528
replace party=99 if NL_PRTY==.a & country ==528
replace party=99 if NL_PRTY==.b & country ==528
replace party=99 if NL_PRTY==.c & country ==528
replace party=99 if NL_PRTY==.d & country ==528

replace party=11 if NO_PRTY ==1 & country== 578 
replace party=6 if NO_PRTY ==2 & country== 578 
replace party=1 if NO_PRTY==3 & country==578 
replace party=2 if NO_PRTY ==4 & country== 578
replace party=4 if NO_PRTY ==5 & country== 578  
replace party=3 if NO_PRTY ==6 & country== 578 
replace party=7 if NO_PRTY ==7 & country== 578 
replace party=5 if NO_PRTY ==8 & country== 578 
replace party=96 if NO_PRTY ==95 & country == 578
replace party=97 if VOTE_LE==2 & country ==578
replace party=99 if NO_PRTY==.a & country ==578
replace party=99 if NO_PRTY==.b & country ==578
replace party=99 if NO_PRTY==.c & country ==578
replace party=99 if NO_PRTY==.d & country ==578

replace party=8 if PT_PRTY ==1 & country ==620
replace party=1 if PT_PRTY ==2 & country ==620
replace party=2 if PT_PRTY ==3 & country ==620
replace party=3 if PT_PRTY ==4 & country ==620
replace party=4 if PT_PRTY ==5 & country ==620
replace party=5 if PT_PRTY ==6 & country ==620
replace party=6 if PT_PRTY ==7 & country ==620
replace party=97 if VOTE_LE==2 & country ==620
replace party=99 if PT_PRTY==.a & country ==620
replace party=99 if PT_PRTY==.b & country ==620
replace party=99 if PT_PRTY==.c & country ==620
replace party=99 if PT_PRTY==.d & country ==620


replace party=1 if SE_PRTY==1 & country==752 
replace party=2 if SE_PRTY ==2 & country== 752 
replace party=3 if SE_PRTY ==3 & country== 752 
replace party=4 if SE_PRTY ==4 & country== 752 
replace party=5 if SE_PRTY ==5 & country== 752 
replace party=6 if SE_PRTY ==6 & country== 752 
replace party=7 if SE_PRTY ==7 & country== 752 
replace party=8 if SE_PRTY ==10 & country== 752 
replace party=9 if SE_PRTY ==8 & country== 752 
replace party=96 if SE_PRTY ==95 & country == 752
replace party=97 if VOTE_LE==2 & country ==752
replace party=99 if SE_PRTY==.a & country ==752
replace party=99 if SE_PRTY==.b & country ==752
replace party=99 if SE_PRTY==.c & country ==752
replace party=99 if SE_PRTY==.d & country ==752

replace party=1 if CH_PRTY==1 & country==756 
replace party=2 if CH_PRTY ==2 & country== 756 
replace party=3 if CH_PRTY ==3 & country== 756 
replace party=4 if CH_PRTY ==4 & country== 756 
replace party=6 if CH_PRTY ==5 & country== 756 
replace party=7 if CH_PRTY ==6 & country== 756 
replace party=12 if CH_PRTY ==7 & country== 756 
replace party=8 if CH_PRTY ==8 & country== 756 
replace party=11 if CH_PRTY ==9 & country== 756 
replace party=20 if CH_PRTY ==10 & country== 756 
replace party=15 if CH_PRTY ==11 & country== 756 
replace party=17 if CH_PRTY ==12 & country== 756 
replace party=16 if CH_PRTY ==13 & country== 756 
replace party=96 if CH_PRTY ==94 & country == 756
replace party= 96 if CH_PRTY ==95 & country == 756
replace party=97 if VOTE_LE==2 & country ==756
replace party=99 if CH_PRTY==.a & country ==756
replace party=99 if CH_PRTY==.b & country ==756
replace party=99 if CH_PRTY==.c & country ==756
replace party=99 if CH_PRTY==.d & country ==756

replace party=1 if GB_PRTY==1 & country==826 
replace party=2 if GB_PRTY ==2 & country== 826 
replace party=3 if GB_PRTY ==3 & country== 826 
replace party=4 if GB_PRTY ==6 & country== 826 
replace party=5 if GB_PRTY ==7 & country== 826 
replace party=6 if GB_PRTY ==8 & country== 826 
replace party=96 if GB_PRTY ==93 & country == 826
replace party=96 if GB_PRTY ==95 & country == 826
replace party=99 if GB_PRTY ==96 & country == 826
replace party=97 if VOTE_LE==2 & country ==826
replace party=99 if GB_PRTY==.a & country ==826
replace party=99 if GB_PRTY==.b & country ==826
replace party=99 if GB_PRTY==.c & country ==826
replace party=99 if GB_PRTY==.d & country ==826


replace party=US_PRTY if country == 840
replace party=96 if US_PRTY ==95 & country == 840
replace party=97 if VOTE_LE==2 & country ==840
replace party=99 if GB_PRTY==.a & country ==840
replace party=99 if GB_PRTY==.b & country ==840
replace party=99 if GB_PRTY==.c & country ==840
replace party=99 if GB_PRTY==.d & country ==840

lab val party party
lab var party "Party Choice"
tab party

}





if `occupation_recode'==1 {
gen isco=ISCO88

recode isco 9995=.
gen isco_string=string(isco)
 gen isco_3s=substr(isco_string, 1, 3)
destring isco_3s, replace
gen isco_combined=isco_3s
replace isco_combined=isco_3 if isco_combined==.
replace isco_combined=isco_3 if isco_combined==.
replace isco_combined=. if isco_combined==0
replace isco_combined=. if isco_combined==9999
gen isco_2=substr(isco_string, 1, 2)

merge m:1 isco_2 using "Occupation_GROUPS.dta"


}


drop BIRTH AGE EDUCYRS PT_DEGR WORK EMPREL NSUP TYPORG1 TYPORG2 MAINSTAT PARTLIV SPWORK SPWRKHRS SPEMPREL SPWRKSUP SPMAINST PT_RELIG PT_PRTY PT_ETHN HHCHILDR HHTODD PT_RINC PT_INC  MARITAL CASEID DATEYR DATEMO DATEDY SUBSCASE AU*  BE* BG*  CH* CL* CZ* DE* DK* FI* FR* GB* HR* IL*  JP* KR* LT* NO* NL* PH* PL* RU* SE* SI* SK* TR* TW* US* ZA*  C_ALPHAN WRKHRS ISCO88 WRKSUP NEMPLOY UNION SPISCO88 HOMPOP PARTY_LR RELIG RELIGGRP ATTEND TOPBOT URBRURAL MODE WEIGHT
drop V*
drop PT*
drop if country==.

save `temp11', replace


}
if `year_2012'==1 {
********
* 2012 *
********
use "ZA5900.dta", clear
local main_variables 1
local parties 1
local occupation_recode 1

if `main_variables'==1 {
gen YYYY=2012
lab var YYYY "Survey Year"


gen weight=WEIGHT
recode weight 0=.
lab val weight weight
lab var weight "Weight"


gen country=.
replace country=36 if V4==36
replace country=40 if V4==40
replace country=56 if V4==56
replace country=124 if V4==124
replace country=208 if V4== 208
replace country=246 if V4==246
replace country=250 if V4==250
replace country =276 if V4==276
replace country =372 if V4==372
replace country=392 if V4==392
replace country =528 if V4==528
replace country=578 if V4==578
replace country=620 if V4==620
replace country=724 if V4==724
replace country=752 if V4==752
replace country=756 if V4==756
replace country =826 if V4==826
replace country=840 if V4==840
lab def country ///
	36 "Australia" ///
	56 "Belgium" ///
	208 "Denmark" ///
	246 "Finland" ///
	250 "France" ///
	276 "Germany" ///
	392 "Japan" ///
	528 "Netherlands" ///
	578 "Norway" ///
	620 "Portugal" ///
	752 "Sweden" ///
	756 "Switzerland" ///
	826 "UK" ///
	840 "USA" 
lab val country country
lab var country "Country"
tab country


gen east_germany=1 if V3==27602



gen sex=SEX
recode sex 0=. 9=.

tab AGE
gen age=AGE
recode age 999=.

gen birth=2012-age
label var birth "Year of Birth"

gen empl=.
replace empl=2 if WORK ==1
replace empl=1 if WORK ==2
replace empl=1 if WORK ==3
lab def empl ///
	1 "Not in Work" ///
	2 "Employed" 
lab val empl empl
lab var empl "Employment Status - 2"
tab empl



gen employee=.
replace employee =2 if EMPREL ==2
replace employee =2 if EMPREL ==3
replace employee =1 if EMPREL ==1
replace employee =1 if EMPREL ==4
lab def employee ///
	1 "Employed" ///
	2 "Self Employed" 
lab val employee employee
lab var employee "Employee"
tab employee

gen emplB=.
replace emplB=1 if MAIN==1
replace emplB=5 if MAIN==2
replace emplB=6 if MAIN==3
replace emplB=6 if MAIN==4
replace emplB=7 if MAIN==6
replace emplB=8 if MAIN==7
replace emplB=1 if MAIN==8
replace emplB=9 if MAIN==5
replace emplB=12 if MAIN==9
replace emplB=12 if MAIN==12

lab def emplB ///
	1 "Employed FT" ///
	2 "Employed PT" ///
	3 "Less than PT" ///
	4 "Helping Family Member" ///
	5 "Unemployed" ///
	6 "Student" ///
	7 "Retired" ///
	8 "Housewife/man" ///
	9 "Perm. dis" ///
	12 "Not in LF" 
lab val emplB emplB
lab var emplB "Employment Status"
tab emplB


gen education=.
replace education=1 if DEGREE==0
replace education=1 if DEGREE==1
replace education=2 if DEGREE==2
replace education=3 if DEGREE==3
replace education=4 if DEGREE==4
replace education=5 if DEGREE==5

lab def education ///
	1 "Less than lower secondary" ///
	2 "Lower Secondary" ///
	3 "Upper Secondary" ///
	4 "Vocational" ///
	5 "Degree" 
lab val education education
lab var education "Education Collapsed"
tab education


}


if `parties'==1 {
gen party_type=3

gen vote=VOTE_LE

gen party=.

replace party=1 if AU_PRTY ==1 & country==36 
replace party=2 if AU_PRTY==2 & country==36 
replace party=3 if AU_PRTY ==3 & country==36 
replace party=4 if AU_PRTY ==4 & country==36 
replace party=7 if AU_PRTY ==5 & country==36 
replace party=8 if AU_PRTY ==6 & country==36 
replace party=9 if AU_PRTY ==7 & country==36 
replace party=96 if AU_PRTY ==95 & country ==36

replace party=2 if AT_PRTY ==1 & country==40 
replace party=1 if AT_PRTY==2 & country==40 
replace party=3 if AT_PRTY ==3 & country==40 
replace party=4 if AT_PRTY ==4 & country==40 
replace party=10 if AT_PRTY ==5 & country==40 
replace party=14 if AT_PRTY ==6 & country==40 
replace party=12 if AT_PRTY ==7 & country==40 
replace party=96 if AT_PRTY ==95 & country ==40


replace party=1 if BE_PRTY==1 & country == 56
replace party=2 if BE_PRTY==2 & country == 56
replace party=3 if BE_PRTY==3 & country == 56
replace party=4 if BE_PRTY==4 & country == 56
replace party=5 if BE_PRTY==5 & country == 56
replace party=7 if BE_PRTY==6 & country == 56
replace party=8 if BE_PRTY==7 & country == 56
replace party=16 if BE_PRTY==8 & country == 56
replace party=12 if BE_PRTY==9 & country == 56
replace party=13 if BE_PRTY==10 & country == 56
replace party=14 if BE_PRTY==12 & country == 56
replace party=24 if BE_PRTY==12 & country == 56
replace party=96 if BE_PRTY ==94 & country == 56
replace party=96 if BE_PRTY ==95 & country == 56

replace party =1 if CA_PRTY==1 & country ==124
replace party =2 if CA_PRTY==2 & country ==124
replace party =3 if CA_PRTY==3 & country ==124
replace party =4 if CA_PRTY==4 & country ==124
replace party =9 if CA_PRTY==5 & country ==124
replace party=96 if CA_PRTY ==95 & country == 124

replace party =1 if DK_PRTY==1 & country ==208
replace party =2 if DK_PRTY==2 & country ==208
replace party =3 if DK_PRTY==3 & country ==208
replace party =5 if DK_PRTY==4 & country ==208
replace party =7 if DK_PRTY==5 & country ==208
replace party =6 if DK_PRTY==6 & country ==208
replace party =9 if DK_PRTY==7 & country ==208
replace party =12 if DK_PRTY==8 & country ==208
replace party =12 if DK_PRTY==9 & country ==208
replace party =96 if DK_PRTY ==95 & country == 208
replace party =99 if DK_PRTY ==96 & country == 208

replace party = FI_PRTY if country ==246
replace party =96 if FI_PRTY ==95 & country == 246
replace party = 99 if FI_PRTY ==96 & country == 246
replace party = 99 if FI_PRTY ==97 & country == 246
replace party = 99 if FI_PRTY ==98 & country == 246
replace party=. if FI_PRTY==0

replace party=2 if FR_PRTY==1 & country==250 
replace party=2 if FR_PRTY==2 & country== 250 
replace party=2 if FR_PRTY==3 & country== 250 
replace party=3 if FR_PRTY==4 & country== 250 
replace party=4 if FR_PRTY==5 & country== 250 
replace party=5 if FR_PRTY==6 & country== 250 
replace party=6 if FR_PRTY==7 & country== 250 
replace party=7 if FR_PRTY==9 & country== 250 
replace party=96 if FR_PRTY==8 & country== 250 
replace party=96 if FR_PRTY==10 & country== 250 
replace party=96 if FR_PRTY ==95 & country == 250
replace party=99 if FR_PRTY ==96 & country == 250
replace party=99 if FR_PRTY ==97 & country == 250


replace party=2 if DE_PRTY ==1 & country== 276 
replace party=1 if DE_PRTY==2 & country==276 
replace party=4 if DE_PRTY ==3 & country== 276 
replace party=9 if DE_PRTY ==4 & country== 276 
replace party=5 if DE_PRTY ==5 & country== 276 
replace party=12 if DE_PRTY ==6 & country== 276 
replace party=10 if DE_PRTY ==7 & country== 276 
replace party=96 if DE_PRTY ==95 & country == 276
replace party=99 if DE_PRTY ==96 & country == 276

replace party=2 if IE_PRTY ==1 & country== 372 
replace party=3 if IE_PRTY==2 & country==372 
replace party=1 if IE_PRTY ==3 & country== 372 
replace party=7 if IE_PRTY ==4 & country== 372 
replace party=12 if IE_PRTY ==5 & country== 372 
replace party=10 if IE_PRTY ==6 & country== 372 
replace party=96 if IE_PRTY ==7 & country== 372 
replace party=6 if IE_PRTY ==8 & country== 372 
replace party=96 if IE_PRTY ==9 & country== 372 
replace party=96 if IE_PRTY ==12 & country== 372 
replace party=96 if IE_PRTY ==13 & country== 372 
replace party=96 if IE_PRTY ==95 & country == 372
replace party=99 if IE_PRTY ==96 & country == 372




replace party=9 if JP_PRTY==1 & country==392 
replace party=1 if JP_PRTY==2 & country==392 
replace party=3 if JP_PRTY ==3 & country== 392 
replace party=13 if JP_PRTY ==4 & country== 392
replace party=4 if JP_PRTY ==5 & country== 392  
replace party=2 if JP_PRTY ==6 & country== 392 
replace party=96 if JP_PRTY ==95 & country == 392


replace party =2 if NL_PRTY==1 & country==528
replace party =1 if NL_PRTY==2 & country==528
replace party =14 if NL_PRTY==3 & country==528
replace party =3 if NL_PRTY==4 & country==528
replace party =10 if NL_PRTY==5 & country==528
replace party =4 if NL_PRTY==6 & country==528
replace party =8 if NL_PRTY==7 & country==528
replace party =15 if NL_PRTY==8 & country==528
replace party =5 if NL_PRTY==9 & country==528
replace party =17 if NL_PRTY==10 & country==528
replace party =12 if NL_PRTY==11 & country==528
replace party =96 if NL_PRTY==12 & country==528

replace party=10 if NO_PRTY ==1 & country== 578 
replace party=6 if NO_PRTY ==2 & country== 578 
replace party=1 if NO_PRTY==3 & country==578 
replace party=2 if NO_PRTY ==4 & country== 578
replace party=4 if NO_PRTY ==5 & country== 578  
replace party=3 if NO_PRTY ==6 & country== 578 
replace party=7 if NO_PRTY ==7 & country== 578 
replace party=5 if NO_PRTY ==8 & country== 578 
replace party=96 if NO_PRTY ==95 & country == 578

replace party=8 if PT_PRTY ==1 & country ==620
replace party=1 if PT_PRTY ==2 & country ==620
replace party=2 if PT_PRTY ==3 & country ==620
replace party=3 if PT_PRTY ==4 & country ==620
replace party=4 if PT_PRTY ==5 & country ==620
replace party=5 if PT_PRTY ==6 & country ==620
replace party=96 if PT_PRTY ==95 & country == 620


replace party=1 if SE_PRTY==1 & country==752 
replace party=2 if SE_PRTY ==2 & country== 752 
replace party=3 if SE_PRTY ==3 & country== 752 
replace party=4 if SE_PRTY ==4 & country== 752 
replace party=5 if SE_PRTY ==5 & country== 752 
replace party=6 if SE_PRTY ==6 & country== 752 
replace party=8 if SE_PRTY ==7 & country== 752 
replace party=7 if SE_PRTY ==8 & country== 752 
replace party=96 if SE_PRTY ==95 & country == 752

replace party=1 if CH_PRTY==1 & country==756 
replace party=2 if CH_PRTY ==2 & country== 756 
replace party=3 if CH_PRTY ==3 & country== 756 
replace party=4 if CH_PRTY ==4 & country== 756 
replace party=18 if CH_PRTY ==5 & country== 756 
replace party=7 if CH_PRTY ==6 & country== 756 
replace party=12 if CH_PRTY ==7 & country== 756 
replace party=8 if CH_PRTY ==8 & country== 756 
replace party=10 if CH_PRTY ==9 & country== 756 
replace party=20 if CH_PRTY ==10 & country== 756 
replace party=15 if CH_PRTY ==11 & country== 756 
replace party=17 if CH_PRTY ==12 & country== 756 
replace party=16 if CH_PRTY ==13 & country== 756 
replace party=96 if CH_PRTY ==14 & country== 756 
replace party=96 if CH_PRTY ==94 & country == 756
replace party= 96 if CH_PRTY ==95 & country == 756
replace party=99 if CH_PRTY ==96 & country == 756

replace party=1 if GB_PRTY==1 & country==826 
replace party=2 if GB_PRTY ==2 & country== 826 
replace party=3 if GB_PRTY ==3 & country== 826 
replace party=4 if GB_PRTY ==6 & country== 826 
replace party=5 if GB_PRTY ==7 & country== 826 
replace party=6 if GB_PRTY ==8 & country== 826 
replace party=96 if GB_PRTY ==93 & country == 826
replace party=96 if GB_PRTY ==95 & country == 826
replace party=99 if GB_PRTY ==96 & country == 826

replace party=1 if ES_PRTY==1 & country==724 
replace party=3 if ES_PRTY ==2 & country==724 
replace party=4 if ES_PRTY ==3 & country==724 
replace party=6 if ES_PRTY ==4 & country==724 
replace party=5 if ES_PRTY ==5 & country==724 
replace party=6 if ES_PRTY ==6 & country==724 
replace party=5 if ES_PRTY ==7 & country==724 
replace party=6 if ES_PRTY ==8 & country==724 
replace party=6 if ES_PRTY ==9 & country==724 
replace party=5 if ES_PRTY ==10 & country==724 
replace party=6 if ES_PRTY ==11 & country==724 
replace party=6 if ES_PRTY ==12 & country==724 
replace party=6 if ES_PRTY ==13 & country==724 
replace party=99 if ES_PRTY ==94 & country == 724
replace party= 96 if ES_PRTY ==95 & country == 724
replace party=99 if ES_PRTY ==96 & country == 724


replace party=US_PRTY if country == 840
replace party=96 if US_PRTY ==95 & country == 840


foreach var of varlist AT_PRTY AU_PRTY BE_PRTY CA_PRTY CH_PRTY DE_PRTY DK_PRTY ///
ES_PRTY FI_PRTY FR_PRTY GB_PRTY IE_PRTY ///
 JP_PRTY KR_PRTY NL_PRTY NO_PRTY PT_PRTY SE_PRTY US_PRTY {
replace party=99 if `var'==98 |  `var'==99
replace party=97 if `var'==0

}
replace party=97 if vote==2 & party==.

 
lab val party party
lab var party "Party Choice"
tab party

rename PARTY_LR party_lr12
}
if `occupation_recode'==1 {
gen isco=ISCO88

recode isco 9995=.
gen isco_string=string(isco)
 gen isco_3s=substr(isco_string, 1, 3)
destring isco_3s, replace
gen isco_combined=isco_3s
replace isco_combined=isco_3 if isco_combined==.
replace isco_combined=isco_3 if isco_combined==.
replace isco_combined=. if isco_combined==0
replace isco_combined=. if isco_combined==9999
gen isco_2=substr(isco_string, 1, 2)

merge m:1 isco_2 using "Occupation_GROUPS.dta"

}

drop V*
drop DOI-MODE
drop if country==.

save `temp12', replace

}
if `year_2013'==1 {
********
* 2013 *
********
set more off
use "ZA5950.dta", clear

local main_variables 1
local parties 1
local occupation_recode 1

if `main_variables'==1 {
gen YYYY=2013
lab var YYYY "Survey Year"


gen weight=WEIGHT
recode weight 0=.
lab val weight weight
lab var weight "Weight"



gen country=.
replace country=36 if V4==36
replace country=40 if V4==40
replace country=56 if V4==56
replace country=134 if V4==134
replace country=208 if V4== 208
replace country=246 if V4==246
replace country=250 if V4==250
replace country =276 if V4==276
replace country =372 if V4==372
replace country=392 if V4==392
replace country =528 if V4==528
replace country=578 if V4==578
replace country=620 if V4==620
replace country=724 if V4==724
replace country=752 if V4==752
replace country=756 if V4==756
replace country =826 if V4==826
replace country=840 if V4==840
lab def country ///
	36 "Australia" ///
	56 "Belgium" ///
	208 "Denmark" ///
	246 "Finland" ///
	250 "France" ///
	276 "Germany" ///
	392 "Japan" ///
	528 "Netherlands" ///
	578 "Norway" ///
	620 "Portugal" ///
	752 "Sweden" ///
	756 "Switzerland" ///
	826 "UK" ///
	840 "USA" 
lab val country country
lab var country "Country"
tab country

gen east_germany=1 if V3==27602


gen sex=SEX
recode sex 0=. 9=.

tab AGE
gen age=AGE
recode age 999=. 

gen birth=2013-age
label var birth "Year of Birth"

gen empl=.
replace empl=2 if WORK ==1
replace empl=1 if WORK ==2
replace empl=1 if WORK ==3
lab def empl ///
	1 "Not in Work" ///
	2 "Employed" 
lab val empl empl
lab var empl "Employment Status - 2"
tab empl



gen employee=.
replace employee =2 if EMPREL ==2
replace employee =2 if EMPREL ==3
replace employee =1 if EMPREL ==1
replace employee =1 if EMPREL ==4
lab def employee ///
	1 "Employed" ///
	2 "Self Employed" 
lab val employee employee
lab var employee "Employee"
tab employee

gen emplB=.
replace emplB=1 if MAIN==1
replace emplB=5 if MAIN==2
replace emplB=6 if MAIN==3
replace emplB=6 if MAIN==4
replace emplB=7 if MAIN==6
replace emplB=8 if MAIN==7
replace emplB=1 if MAIN==8
replace emplB=9 if MAIN==5
replace emplB=13 if MAIN==9
replace emplB=13 if MAIN==13

lab def emplB ///
	1 "Employed FT" ///
	2 "Employed PT" ///
	3 "Less than PT" ///
	4 "Helping Family Member" ///
	5 "Unemployed" ///
	6 "Student" ///
	7 "Retired" ///
	8 "Housewife/man" ///
	9 "Perm. dis" ///
	13 "Not in LF" 
lab val emplB emplB
lab var emplB "Employment Status"
tab emplB

gen education=.
replace education=1 if DEGREE==0
replace education=1 if DEGREE==1
replace education=2 if DEGREE==2
replace education=3 if DEGREE==3
replace education=4 if DEGREE==4
replace education=5 if DEGREE==5

lab def education ///
	1 "Less than lower secondary" ///
	2 "Lower Secondary" ///
	3 "Upper Secondary" ///
	4 "Vocational" ///
	5 "Degree" 
lab val education education
lab var education "Education Collapsed"
tab education

}

if `parties'==1 {
gen party_type=3 

gen vote=VOTE_LE


gen party=.


replace party=1 if BE_PRTY==1 & country == 56
replace party=2 if BE_PRTY==2 & country == 56
replace party=3 if BE_PRTY==3 & country == 56
replace party=4 if BE_PRTY==4 & country == 56
replace party=5 if BE_PRTY==5 & country == 56
replace party=7 if BE_PRTY==6 & country == 56
replace party=8 if BE_PRTY==7 & country == 56
replace party=16 if BE_PRTY==8 & country == 56
replace party=11 if BE_PRTY==9 & country == 56
replace party=13 if BE_PRTY==10 & country == 56
replace party=14 if BE_PRTY==11 & country == 56
replace party=24 if BE_PRTY==12 & country == 56
replace party=96 if BE_PRTY ==94 & country == 56
replace party=96 if BE_PRTY ==95 & country == 56



replace party =1 if DK_PRTY==1 & country ==208
replace party =2 if DK_PRTY==2 & country ==208
replace party =3 if DK_PRTY==3 & country ==208
replace party =5 if DK_PRTY==4 & country ==208
replace party =7 if DK_PRTY==5 & country ==208
replace party =6 if DK_PRTY==6 & country ==208
replace party =9 if DK_PRTY==7 & country ==208
replace party =12 if DK_PRTY==8 & country ==208
replace party =11 if DK_PRTY==9 & country ==208
replace party =96 if DK_PRTY ==95 & country == 208
replace party =99 if DK_PRTY ==96 & country == 208

replace party = FI_PRTY if country ==246
replace party =96 if FI_PRTY ==95 & country == 246
replace party = 99 if FI_PRTY ==96 & country == 246
replace party = 99 if FI_PRTY ==97 & country == 246
replace party = 99 if FI_PRTY ==98 & country == 246


replace party=2 if FR_PRTY==1 & country==250 
replace party=2 if FR_PRTY==2 & country== 250 
replace party=2 if FR_PRTY==3 & country== 250 
replace party=3 if FR_PRTY==4 & country== 250 
replace party=4 if FR_PRTY==5 & country== 250 
replace party=5 if FR_PRTY==6 & country== 250 
replace party=6 if FR_PRTY==7 & country== 250 
replace party=7 if FR_PRTY==9 & country== 250 
replace party=96 if FR_PRTY==8 & country== 250 
replace party=96 if FR_PRTY==10 & country== 250 
replace party=96 if FR_PRTY ==95 & country == 250
replace party=99 if FR_PRTY ==96 & country == 250
replace party=99 if FR_PRTY ==97 & country == 250


replace party=2 if DE_PRTY ==1 & country== 276 
replace party=1 if DE_PRTY==2 & country==276 
replace party=4 if DE_PRTY ==3 & country== 276 
replace party=9 if DE_PRTY ==4 & country== 276 
replace party=5 if DE_PRTY ==5 & country== 276 
replace party=10 if DE_PRTY ==6 & country== 276 
replace party=11 if DE_PRTY ==7 & country== 276 
replace party=12 if DE_PRTY ==8 & country== 276 
replace party=96 if DE_PRTY ==9 & country== 276 
replace party=96 if DE_PRTY ==95 & country == 276
replace party=99 if DE_PRTY ==96 & country == 276

replace party=2 if IE_PRTY ==1 & country== 372 
replace party=3 if IE_PRTY==2 & country==372 
replace party=1 if IE_PRTY ==3 & country== 372 
replace party=7 if IE_PRTY ==4 & country== 372 
replace party=11 if IE_PRTY ==5 & country== 372 
replace party=10 if IE_PRTY ==6 & country== 372 
replace party=96 if IE_PRTY ==7 & country== 372 
replace party=6 if IE_PRTY ==8 & country== 372 
replace party=96 if IE_PRTY ==9 & country== 372 
replace party=96 if IE_PRTY ==11 & country== 372 
replace party=96 if IE_PRTY ==13 & country== 372 
replace party=96 if IE_PRTY ==95 & country == 372
replace party=99 if IE_PRTY ==96 & country == 372




replace party=1 if JP_PRTY==1 & country==392 
replace party=9 if JP_PRTY==2 & country==392 
replace party=14 if JP_PRTY ==3 & country== 392 
replace party=3 if JP_PRTY ==4 & country== 392
replace party=13 if JP_PRTY ==5 & country== 392  
replace party=4 if JP_PRTY ==6 & country== 392 
replace party=96 if JP_PRTY ==7 & country== 392 
replace party=2 if JP_PRTY ==8 & country== 392 
replace party=96 if JP_PRTY ==9 & country== 392 
replace party=96 if JP_PRTY ==10 & country== 392 
replace party=96 if JP_PRTY ==11 & country== 392 
replace party=96 if JP_PRTY ==12 & country== 392 
replace party=96 if JP_PRTY ==95 & country == 392



replace party=6 if NO_PRTY ==1 & country== 578 
replace party=1 if NO_PRTY ==2 & country== 578 
replace party=2 if NO_PRTY==3 & country==578 
replace party=4 if NO_PRTY ==4 & country== 578
replace party=12 if NO_PRTY ==5 & country== 578  
replace party=10 if NO_PRTY ==6 & country== 578 
replace party=3 if NO_PRTY ==7 & country== 578 
replace party=7 if NO_PRTY ==8 & country== 578 
replace party=5 if NO_PRTY ==9 & country== 578 
replace party=96 if NO_PRTY ==95 & country == 578

replace party=8 if PT_PRTY ==1 & country ==620
replace party=1 if PT_PRTY ==2 & country ==620
replace party=2 if PT_PRTY ==3 & country ==620
replace party=3 if PT_PRTY ==4 & country ==620
replace party=4 if PT_PRTY ==5 & country ==620
replace party=5 if PT_PRTY ==6 & country ==620
replace party=96 if PT_PRTY ==95 & country == 620


replace party=1 if SE_PRTY==1 & country==752 
replace party=2 if SE_PRTY ==2 & country== 752 
replace party=3 if SE_PRTY ==3 & country== 752 
replace party=4 if SE_PRTY ==4 & country== 752 
replace party=5 if SE_PRTY ==5 & country== 752 
replace party=6 if SE_PRTY ==6 & country== 752 
replace party=8 if SE_PRTY ==7 & country== 752 
replace party=7 if SE_PRTY ==8 & country== 752 
replace party=96 if SE_PRTY ==95 & country == 752

replace party=1 if CH_PRTY==1 & country==756 
replace party=2 if CH_PRTY ==2 & country== 756 
replace party=3 if CH_PRTY ==3 & country== 756 
replace party=4 if CH_PRTY ==4 & country== 756 
replace party=18 if CH_PRTY ==5 & country== 756 
replace party=7 if CH_PRTY ==6 & country== 756 
replace party=13 if CH_PRTY ==7 & country== 756 
replace party=8 if CH_PRTY ==8 & country== 756 
replace party=10 if CH_PRTY ==9 & country== 756 
replace party=20 if CH_PRTY ==10 & country== 756 
replace party=15 if CH_PRTY ==11 & country== 756 
replace party=17 if CH_PRTY ==12 & country== 756 
replace party=16 if CH_PRTY ==13 & country== 756 
replace party=96 if CH_PRTY ==14 & country == 756
replace party= 96 if CH_PRTY ==95 & country == 756
replace party=99 if CH_PRTY ==96 & country == 756

replace party=1 if GB_PRTY==1 & country==826 
replace party=2 if GB_PRTY ==2 & country== 826 
replace party=3 if GB_PRTY ==3 & country== 826 
replace party=4 if GB_PRTY ==6 & country== 826 
replace party=5 if GB_PRTY ==7 & country== 826 
replace party=6 if GB_PRTY ==8 & country== 826 
replace party=96 if GB_PRTY ==93 & country == 826
replace party=96 if GB_PRTY ==95 & country == 826
replace party=99 if GB_PRTY ==96 & country == 826



replace party=3 if ES_PRTY==1 & country==724 
replace party=1 if ES_PRTY ==2 & country==724 
replace party=4 if ES_PRTY ==3 & country==724 
replace party=5 if ES_PRTY ==4 & country==724 
replace party=6 if ES_PRTY ==5 & country==724 
replace party=5 if ES_PRTY ==6 & country==724 
replace party=6 if ES_PRTY ==7 & country==724 
replace party=6 if ES_PRTY ==8 & country==724 
replace party=5 if ES_PRTY ==9 & country==724 
replace party=99 if ES_PRTY ==94 & country == 724
replace party= 96 if ES_PRTY ==95 & country == 724
replace party=99 if ES_PRTY ==96 & country == 724



replace party=US_PRTY if country == 840
replace party=96 if US_PRTY ==95 & country == 840

lab val party party
lab var party "Party Choice"
tab party


rename PARTY_LR party_lr13

foreach var of varlist BE_PRTY CH_PRTY DE_PRTY DK_PRTY ES_PRTY FI_PRTY FR_PRTY GB_PRTY IE_PRTY  ///
JP_PRTY KR_PRTY NO_PRTY SE_PRTY US_PRTY {
replace party=99 if `var'==98 |  `var'==99
replace party=97 if `var'==0
replace party=96 if `var'==96

}
replace party=97 if vote==2 & party==.

}

if `occupation_recode'==1 {
gen isco=ISCO88

recode ISCO88 0=., gen(occup13)
lab val occup13 occup13
lab var occup13 "Occupation"


recode occup13 9995=.
gen isco_string=string(occup13)
 gen isco_3s=substr(isco_string, 1, 3)
destring isco_3s, replace
gen isco_combined=isco_3s
replace isco_combined=isco_3 if isco_combined==.
replace isco_combined=isco_3 if isco_combined==.
replace isco_combined=. if isco_combined==0
replace isco_combined=. if isco_combined==9999
gen isco_2=substr(isco_string, 1, 2)

merge m:1 isco_2 using "Occupation_GROUPS.dta"
}

order rti group_RTI
drop V*
drop DOI-MODE
drop if country==.


save `temp13', replace
}


if `year_2014'==1 {
********
* 2014 *
********
use "ZA6670.dta", clear
set more off 

local main_variables 1
local parties 1
local occupation_recode 1

if `main_variables'==1 {
gen YYYY=2014
lab var YYYY "Survey Year"


gen weight=WEIGHT
recode weight 0=.
lab val weight weight
lab var weight "Weight"


gen country=.
replace country=36 if V4==36
replace country=40 if V4==40
replace country=56 if V4==56
replace country=144 if V4==144
replace country=208 if V4== 208
replace country=246 if V4==246
replace country=250 if V4==250
replace country=276 if V4==276
replace country=372 if V4==372
replace country=392 if V4==392
replace country=528 if V4==528
replace country=578 if V4==578
replace country=620 if V4==620
replace country=724 if V4==724
replace country=752 if V4==752
replace country=756 if V4==756
replace country =826 if V4==826
replace country=840 if V4==840
lab def country ///
	36 "Australia" ///
	40 "Austria" ///
	56 "Belgium" ///
	124 "Canada" ///
	208 "Denmark" ///
	246 "Finland" ///
	250 "France" ///
	276 "Germany" ///
	372 "Ireland" ///
	392 "Japan" ///
	528 "Netherlands" ///
	554 "New Zealand" ///
	578 "Norway" ///
	620 "Portugal" ///
	752 "Sweden" ///
	756 "Switzerland" ///
	826 "UK" ///
	840 "USA" 
lab val country country
lab var country "Country"
tab country

gen east_germany=1 if V3==27602


gen sex=SEX
recode sex 0=. 9=.

tab AGE
gen age=AGE
recode age 999=.

gen birth=2014-age
label var birth "Year of Birth"

gen empl=.
replace empl=2 if WORK ==1
replace empl=1 if WORK ==2
replace empl=1 if WORK ==3
lab def empl ///
	1 "Not in Work" ///
	2 "Employed" 
lab val empl empl
lab var empl "Employment Status - 2"
tab empl


gen employee=.
replace employee =2 if EMPREL ==2
replace employee =2 if EMPREL ==3
replace employee =1 if EMPREL ==1
replace employee =1 if EMPREL ==4
lab def employee ///
	1 "Employed" ///
	2 "Self Employed" 
lab val employee employee
lab var employee "Employee"
tab employee

gen emplB=.
replace emplB=1 if MAIN==1
replace emplB=5 if MAIN==2
replace emplB=6 if MAIN==3
replace emplB=6 if MAIN==4
replace emplB=7 if MAIN==6
replace emplB=8 if MAIN==7
replace emplB=1 if MAIN==8
replace emplB=9 if MAIN==5
replace emplB=14 if MAIN==9
replace emplB=14 if MAIN==14

lab def emplB ///
	1 "Employed FT" ///
	2 "Employed PT" ///
	3 "Less than PT" ///
	4 "Helping Family Member" ///
	5 "Unemployed" ///
	6 "Student" ///
	7 "Retired" ///
	8 "Housewife/man" ///
	9 "Perm. dis" ///
	14 "Not in LF" 
lab val emplB emplB
lab var emplB "Employment Status"
tab emplB

gen education=.
replace education=1 if DEGREE==0
replace education=1 if DEGREE==1
replace education=2 if DEGREE==2
replace education=3 if DEGREE==3
replace education=4 if DEGREE==4
replace education=5 if DEGREE==5

lab def education ///
	1 "Less than lower secondary" ///
	2 "Lower Secondary" ///
	3 "Upper Secondary" ///
	4 "Vocational" ///
	5 "Degree" 
lab val education education
lab var education "Education Collapsed"
tab education

}
if `parties'==1 {
gen party_type=3

gen vote=VOTE_LE

gen party=.

replace party=2 if AU_PRTY ==1 & country==36 
replace party=1 if AU_PRTY==2 & country==36 
replace party=3 if AU_PRTY ==3 & country==36 
replace party=7 if AU_PRTY ==5 & country==36 
replace party=8 if AU_PRTY ==6 & country==36 
replace party=9 if AU_PRTY ==7 & country==36 
replace party=96 if AU_PRTY>=9 & AU_PRTY<=90 & country ==36
replace party=96 if AU_PRTY ==95 & country ==36
replace party=96 if AU_PRTY ==96 & country ==36

replace party=96 if AT_PRTY ==1 & country==40 
replace party=3 if AT_PRTY==2 & country==40 
replace party=1 if AT_PRTY ==3 & country==40 
replace party=2 if AT_PRTY ==4 & country==40 
replace party=96 if AT_PRTY ==5 & country==40 
replace party=4 if AT_PRTY ==6 & country==40 
replace party=96 if AT_PRTY ==95 & country ==40
replace party=99 if AT_PRTY ==96 & country ==40


replace party=14 if BE_PRTY==1 & country == 56
replace party=2 if BE_PRTY==2 & country == 56
replace party=8 if BE_PRTY==3 & country == 56
replace party=96 if BE_PRTY==4 & country == 56
replace party=23 if BE_PRTY==5 & country == 56
replace party=14 if BE_PRTY==6 & country == 56
replace party=5 if BE_PRTY==7 & country == 56
replace party=3 if BE_PRTY==8 & country == 56
replace party=16 if BE_PRTY==9 & country == 56
replace party=13 if BE_PRTY==10 & country == 56
replace party=96 if BE_PRTY==11 & country == 56
replace party=7 if BE_PRTY==12 & country == 56
replace party=4 if BE_PRTY==13 & country == 56
replace party=11 if BE_PRTY==14 & country == 56
replace party=1 if BE_PRTY==15 & country == 56
replace party=24 if BE_PRTY==16 & country == 56
replace party=15 if BE_PRTY==17 & country == 56
replace party=20 if BE_PRTY==18 & country == 56
replace party=19 if BE_PRTY==19 & country == 56
replace party=96 if BE_PRTY ==94 & country == 56
replace party=96 if BE_PRTY ==95 & country == 56



replace party =1 if DK_PRTY==1 & country ==208
replace party =2 if DK_PRTY==2 & country ==208
replace party =3 if DK_PRTY==3 & country ==208
replace party =5 if DK_PRTY==4 & country ==208
replace party =7 if DK_PRTY==5 & country ==208
replace party =6 if DK_PRTY==6 & country ==208
replace party =9 if DK_PRTY==7 & country ==208
replace party =12 if DK_PRTY==8 & country ==208
replace party =11 if DK_PRTY==9 & country ==208
replace party =96 if DK_PRTY ==95 & country == 208
replace party =99 if DK_PRTY ==96 & country == 208

replace party = FI_PRTY if country ==246
replace party =96 if FI_PRTY ==95 & country == 246
replace party = 99 if FI_PRTY ==96 & country == 246
replace party = 99 if FI_PRTY ==97 & country == 246
replace party = 99 if FI_PRTY ==98 & country == 246


replace party=2 if FR_PRTY==1 & country==250 
replace party=2 if FR_PRTY==2 & country== 250 
replace party=2 if FR_PRTY==3 & country== 250 
replace party=3 if FR_PRTY==4 & country== 250 
replace party=4 if FR_PRTY==5 & country== 250 
replace party=5 if FR_PRTY==6 & country== 250 
replace party=6 if FR_PRTY==7 & country== 250 
replace party=7 if FR_PRTY==9 & country== 250 
replace party=96 if FR_PRTY==8 & country== 250 
replace party=96 if FR_PRTY==10 & country== 250 
replace party=96 if FR_PRTY ==95 & country == 250
replace party=99 if FR_PRTY ==96 & country == 250
replace party=99 if FR_PRTY ==97 & country == 250


replace party=2 if DE_PRTY ==1 & country== 276 
replace party=1 if DE_PRTY==2 & country==276 
replace party=9 if DE_PRTY ==3 & country== 276 
replace party=5 if DE_PRTY ==4 & country== 276 
replace party=4 if DE_PRTY ==5 & country== 276 
replace party=12 if DE_PRTY ==6 & country== 276 
replace party=11 if DE_PRTY ==7 & country== 276 
replace party=10 if DE_PRTY ==8 & country== 276 
replace party=96 if DE_PRTY ==9 & country== 276 
replace party=96 if DE_PRTY ==95 & country == 276
replace party=99 if DE_PRTY ==96 & country == 276




replace party=1 if JP_PRTY==1 & country==392 
replace party=9 if JP_PRTY==2 & country==392 
replace party=14 if JP_PRTY ==3 & country== 392 
replace party=3 if JP_PRTY ==4 & country== 392
replace party=13 if JP_PRTY ==5 & country== 392  
replace party=4 if JP_PRTY ==6 & country== 392 
replace party=96 if JP_PRTY ==7 & country== 392 
replace party=2 if JP_PRTY ==8 & country== 392 
replace party=96 if JP_PRTY ==9 & country== 392 
replace party=96 if JP_PRTY ==10 & country== 392 
replace party=96 if JP_PRTY ==11 & country== 392 
replace party=96 if JP_PRTY ==12 & country== 392 
replace party=96 if JP_PRTY ==95 & country == 392

replace party=2 if NL_PRTY ==1 & country== 528 
replace party=1 if NL_PRTY ==2 & country== 528 
replace party=14 if NL_PRTY ==3 & country== 528 
replace party=3 if NL_PRTY ==4 & country== 528 
replace party=10 if NL_PRTY ==5 & country== 528 
replace party=4 if NL_PRTY ==6 & country== 528 
replace party=8 if NL_PRTY ==7 & country== 528 
replace party=15 if NL_PRTY ==8 & country== 528 
replace party=5 if NL_PRTY ==9 & country== 528 
replace party=17 if NL_PRTY ==10 & country== 528 
replace party=11 if NL_PRTY ==11 & country== 528 
replace party=96 if NL_PRTY ==95 & country == 528


replace party=6 if NO_PRTY ==1 & country== 578 
replace party=1 if NO_PRTY ==2 & country== 578 
replace party=2 if NO_PRTY==3 & country==578 
replace party=4 if NO_PRTY ==4 & country== 578
replace party=12 if NO_PRTY ==5 & country== 578  
replace party=10 if NO_PRTY ==6 & country== 578 
replace party=3 if NO_PRTY ==7 & country== 578 
replace party=7 if NO_PRTY ==8 & country== 578 
replace party=5 if NO_PRTY ==9 & country== 578 
replace party=96 if NO_PRTY ==95 & country == 578


replace party=1 if ES_PRTY==1 & country==724 
replace party=3 if ES_PRTY ==2 & country== 724 
replace party=4 if ES_PRTY ==3 & country== 724 
replace party=6 if ES_PRTY ==4 & country== 724 
replace party=5 if ES_PRTY ==5 & country== 724 
replace party=6 if ES_PRTY ==6 & country== 724 
replace party=5 if ES_PRTY ==7 & country== 724 
replace party=6 if ES_PRTY ==8 & country== 724 
replace party=6 if ES_PRTY ==9 & country== 724 
replace party=5 if ES_PRTY ==10 & country== 724 
replace party=8 if ES_PRTY ==11 & country== 724 
replace party=96 if ES_PRTY ==12 & country== 724 
replace party=96 if ES_PRTY ==13 & country== 724 

replace party=96 if ES_PRTY ==95 & country == 724

replace party=1 if SE_PRTY==1 & country==752 
replace party=2 if SE_PRTY ==2 & country== 752 
replace party=3 if SE_PRTY ==3 & country== 752 
replace party=4 if SE_PRTY ==4 & country== 752 
replace party=5 if SE_PRTY ==5 & country== 752 
replace party=6 if SE_PRTY ==6 & country== 752 
replace party=8 if SE_PRTY ==7 & country== 752 
replace party=7 if SE_PRTY ==8 & country== 752 
replace party=96 if SE_PRTY ==95 & country == 752

replace party=1 if CH_PRTY==1 & country==756 
replace party=2 if CH_PRTY ==2 & country== 756 
replace party=3 if CH_PRTY ==3 & country== 756 
replace party=4 if CH_PRTY ==4 & country== 756 
replace party=18 if CH_PRTY ==5 & country== 756 
replace party=7 if CH_PRTY ==6 & country== 756 
replace party=14 if CH_PRTY ==7 & country== 756 
replace party=8 if CH_PRTY ==8 & country== 756 
replace party=10 if CH_PRTY ==9 & country== 756 
replace party=20 if CH_PRTY ==10 & country== 756 
replace party=15 if CH_PRTY ==11 & country== 756 
replace party=17 if CH_PRTY ==12 & country== 756 
replace party=16 if CH_PRTY ==13 & country== 756 
replace party=96 if CH_PRTY ==14 & country == 756
replace party= 96 if CH_PRTY ==95 & country == 756
replace party=99 if CH_PRTY ==96 & country == 756

replace party=US_PRTY if country == 840
replace party=96 if US_PRTY ==95 & country == 840

lab val party party
lab var party "Party Choice"
tab party

rename PARTY_LR party_lr14


foreach var of varlist AT_PRTY AU_PRTY BE_PRTY CH_PRTY DE_PRTY DK_PRTY ES_PRTY FI_PRTY FR_PRTY ///
 GB_PRTY JP_PRTY NL_PRTY NO_PRTY SE_PRTY US_PRTY {
 replace party=99 if `var'==99 & party==.
  replace party=97 if `var'==0 & party==.
 replace party=99 if `var'==97 & party==.

 }
 }
 
if `occupation_recode'==1 {
gen isco_08=ISCO08 if country!=40
gen isco_08_3=ISCO08 if country==40

gen isco88=.
replace isco_08_3=isco_08_3/10
replace isco_08_3=. if isco_08_3==9998
gen isco_3=.

*** ISCO 08*** 
replace isco88=	1110	if isco_08==	1111
replace isco88=	1120	if isco_08==	1112
replace isco88=	1130	if isco_08==	1113
replace isco88=	1141	if isco_08==	1114
replace isco88=	1142	if isco_08==	1114
replace isco88=	1143	if isco_08==	1114
replace isco88=	1210	if isco_08==	1120
replace isco88=	1221	if isco_08==	1311
replace isco88=	1221	if isco_08==	1312
replace isco88=	1222	if isco_08==	1321
replace isco88=	1222	if isco_08==	1322
replace isco88=	1223	if isco_08==	1323
replace isco88=	1223	if isco_08==	3123
replace isco88=	1224	if isco_08==	1420
replace isco88=	1225	if isco_08==	1411
replace isco88=	1225	if isco_08==	1412
replace isco88=	1226	if isco_08==	1324
replace isco88=	1226	if isco_08==	1330
replace isco88=	1227	if isco_08==	1219
replace isco88=	1227	if isco_08==	1346
replace isco88=	1228	if isco_08==	1219
replace isco88=	1229	if isco_08==	1213
replace isco88=	1229	if isco_08==	1219
replace isco88=	1229	if isco_08==	1341
replace isco88=	1229	if isco_08==	1342
replace isco88=	1229	if isco_08==	1343
replace isco88=	1229	if isco_08==	1344
replace isco88=	1229	if isco_08==	1345
replace isco88=	1229	if isco_08==	1349
replace isco88=	1229	if isco_08==	1439
replace isco88=	1229	if isco_08==	2654
replace isco88=	1229	if isco_08==	3435
replace isco88=	1231	if isco_08==	1211
replace isco88=	1231	if isco_08==	1219
replace isco88=	1232	if isco_08==	1212
replace isco88=	1233	if isco_08==	1221
replace isco88=	1234	if isco_08==	1222
replace isco88=	1235	if isco_08==	1324
replace isco88=	1236	if isco_08==	1330
replace isco88=	1237	if isco_08==	1223
replace isco88=	1239	if isco_08==	1213
replace isco88=	1311	if isco_08==	6111
replace isco88=	1311	if isco_08==	6112
replace isco88=	1311	if isco_08==	6113
replace isco88=	1311	if isco_08==	6114
replace isco88=	1311	if isco_08==	6121
replace isco88=	1311	if isco_08==	6122
replace isco88=	1311	if isco_08==	6130
replace isco88=	1311	if isco_08==	6210
replace isco88=	1311	if isco_08==	6221
replace isco88=	1311	if isco_08==	6222
replace isco88=	1311	if isco_08==	6223
replace isco88=	1312	if isco_08==	1321
replace isco88=	1312	if isco_08==	1322
replace isco88=	1313	if isco_08==	1323
replace isco88=	1314	if isco_08==	1420
replace isco88=	1314	if isco_08==	5221
replace isco88=	1315	if isco_08==	1411
replace isco88=	1315	if isco_08==	1412
replace isco88=	1316	if isco_08==	1324
replace isco88=	1316	if isco_08==	1330
replace isco88=	1317	if isco_08==	1211
replace isco88=	1317	if isco_08==	1212
replace isco88=	1317	if isco_08==	1219
replace isco88=	1317	if isco_08==	1221
replace isco88=	1317	if isco_08==	1222
replace isco88=	1317	if isco_08==	1330
replace isco88=	1317	if isco_08==	1346
replace isco88=	1318	if isco_08==	1219
replace isco88=	1319	if isco_08==	1223
replace isco88=	1319	if isco_08==	1341
replace isco88=	1319	if isco_08==	1342
replace isco88=	1319	if isco_08==	1343
replace isco88=	1319	if isco_08==	1344
replace isco88=	1319	if isco_08==	1345
replace isco88=	1319	if isco_08==	1349
replace isco88=	1319	if isco_08==	1431
replace isco88=	1319	if isco_08==	1439
replace isco88=	2111	if isco_08==	2111
replace isco88=	2112	if isco_08==	2112
replace isco88=	2113	if isco_08==	2113
replace isco88=	2113	if isco_08==	2262
replace isco88=	2114	if isco_08==	2114
replace isco88=	2121	if isco_08==	2120
replace isco88=	2122	if isco_08==	2120
replace isco88=	2131	if isco_08==	2511
replace isco88=	2131	if isco_08==	2512
replace isco88=	2131	if isco_08==	2513
replace isco88=	2131	if isco_08==	2519
replace isco88=	2131	if isco_08==	2521
replace isco88=	2131	if isco_08==	2522
replace isco88=	2131	if isco_08==	2523
replace isco88=	2132	if isco_08==	2513
replace isco88=	2132	if isco_08==	2514
replace isco88=	2132	if isco_08==	2519
replace isco88=	2139	if isco_08==	2513
replace isco88=	2139	if isco_08==	2519
replace isco88=	2139	if isco_08==	2529
replace isco88=	2141	if isco_08==	2161
replace isco88=	2141	if isco_08==	2162
replace isco88=	2141	if isco_08==	2164
replace isco88=	2142	if isco_08==	2142
replace isco88=	2143	if isco_08==	2151
replace isco88=	2144	if isco_08==	2152
replace isco88=	2144	if isco_08==	2153
replace isco88=	2145	if isco_08==	2144
replace isco88=	2146	if isco_08==	2145
replace isco88=	2147	if isco_08==	2146
replace isco88=	2148	if isco_08==	2165
replace isco88=	2149	if isco_08==	2141
replace isco88=	2149	if isco_08==	2143
replace isco88=	2149	if isco_08==	2149
replace isco88=	2211	if isco_08==	2131
replace isco88=	2211	if isco_08==	2133
replace isco88=	2212	if isco_08==	2131
replace isco88=	2212	if isco_08==	2212
replace isco88=	2212	if isco_08==	2250
replace isco88=	2213	if isco_08==	2132
replace isco88=	2221	if isco_08==	2211
replace isco88=	2221	if isco_08==	2212
replace isco88=	2222	if isco_08==	2261
replace isco88=	2223	if isco_08==	2250
replace isco88=	2224	if isco_08==	2262
replace isco88=	2229	if isco_08==	2263
replace isco88=	2229	if isco_08==	2269
replace isco88=	2230	if isco_08==	1342
replace isco88=	2230	if isco_08==	1343
replace isco88=	2230	if isco_08==	2221
replace isco88=	2230	if isco_08==	2222
replace isco88=	2230	if isco_08==	3221
replace isco88=	2230	if isco_08==	3222
replace isco88=	2310	if isco_08==	2310
replace isco88=	2310	if isco_08==	2320
replace isco88=	2320	if isco_08==	2320
replace isco88=	2320	if isco_08==	2330
replace isco88=	2331	if isco_08==	2341
replace isco88=	2332	if isco_08==	2342
replace isco88=	2340	if isco_08==	2352
replace isco88=	2351	if isco_08==	2351
replace isco88=	2352	if isco_08==	2351
replace isco88=	2359	if isco_08==	2353
replace isco88=	2359	if isco_08==	2354
replace isco88=	2359	if isco_08==	2355
replace isco88=	2359	if isco_08==	2356
replace isco88=	2359	if isco_08==	2359
replace isco88=	2411	if isco_08==	2411
replace isco88=	2411	if isco_08==	2412
replace isco88=	2412	if isco_08==	2263
replace isco88=	2412	if isco_08==	2423
replace isco88=	2412	if isco_08==	2424
replace isco88=	2419	if isco_08==	2412
replace isco88=	2419	if isco_08==	2413
replace isco88=	2419	if isco_08==	2421
replace isco88=	2419	if isco_08==	2422
replace isco88=	2419	if isco_08==	2431
replace isco88=	2419	if isco_08==	2432
replace isco88=	2419	if isco_08==	3339
replace isco88=	2421	if isco_08==	2611
replace isco88=	2422	if isco_08==	2612
replace isco88=	2429	if isco_08==	2619
replace isco88=	2431	if isco_08==	2621
replace isco88=	2432	if isco_08==	2622
replace isco88=	2441	if isco_08==	2631
replace isco88=	2442	if isco_08==	2632
replace isco88=	2443	if isco_08==	2633
replace isco88=	2444	if isco_08==	2643
replace isco88=	2445	if isco_08==	2634
replace isco88=	2446	if isco_08==	2635
replace isco88=	2451	if isco_08==	2431
replace isco88=	2451	if isco_08==	2432
replace isco88=	2451	if isco_08==	2641
replace isco88=	2451	if isco_08==	2642
replace isco88=	2452	if isco_08==	2651
replace isco88=	2453	if isco_08==	2652
replace isco88=	2454	if isco_08==	2653
replace isco88=	2455	if isco_08==	2654
replace isco88=	2455	if isco_08==	2655
replace isco88=	2460	if isco_08==	2636
replace isco88=	3111	if isco_08==	3111
replace isco88=	3112	if isco_08==	3112
replace isco88=	3113	if isco_08==	3113
replace isco88=	3114	if isco_08==	3114
replace isco88=	3114	if isco_08==	3522
replace isco88=	3115	if isco_08==	3115
replace isco88=	3116	if isco_08==	3116
replace isco88=	3117	if isco_08==	3117
replace isco88=	3118	if isco_08==	3118
replace isco88=	3119	if isco_08==	3119
replace isco88=	3121	if isco_08==	3512
replace isco88=	3121	if isco_08==	3513
replace isco88=	3121	if isco_08==	3514
replace isco88=	3122	if isco_08==	3511
replace isco88=	3122	if isco_08==	3514
replace isco88=	3123	if isco_08==	3139
replace isco88=	3131	if isco_08==	3431
replace isco88=	3131	if isco_08==	3521
replace isco88=	3132	if isco_08==	3521
replace isco88=	3132	if isco_08==	3522
replace isco88=	3133	if isco_08==	3211
replace isco88=	3141	if isco_08==	3151
replace isco88=	3142	if isco_08==	3152
replace isco88=	3143	if isco_08==	3153
replace isco88=	3144	if isco_08==	3154
replace isco88=	3145	if isco_08==	3155
replace isco88=	3151	if isco_08==	3112
replace isco88=	3151	if isco_08==	3359
replace isco88=	3152	if isco_08==	2263
replace isco88=	3152	if isco_08==	3113
replace isco88=	3152	if isco_08==	3114
replace isco88=	3152	if isco_08==	3115
replace isco88=	3152	if isco_08==	3117
replace isco88=	3152	if isco_08==	3257
replace isco88=	3152	if isco_08==	7543
replace isco88=	3211	if isco_08==	3141
replace isco88=	3211	if isco_08==	3212
replace isco88=	3212	if isco_08==	3142
replace isco88=	3212	if isco_08==	3143
replace isco88=	3213	if isco_08==	2132
replace isco88=	3221	if isco_08==	2240
replace isco88=	3221	if isco_08==	3253
replace isco88=	3221	if isco_08==	3256
replace isco88=	3222	if isco_08==	2263
replace isco88=	3222	if isco_08==	3257
replace isco88=	3223	if isco_08==	2265
replace isco88=	3224	if isco_08==	2267
replace isco88=	3224	if isco_08==	3254
replace isco88=	3225	if isco_08==	3251
replace isco88=	3226	if isco_08==	2264
replace isco88=	3226	if isco_08==	2269
replace isco88=	3226	if isco_08==	3255
replace isco88=	3226	if isco_08==	3259
replace isco88=	3227	if isco_08==	3240
replace isco88=	3228	if isco_08==	3213
replace isco88=	3229	if isco_08==	2230
replace isco88=	3229	if isco_08==	2266
replace isco88=	3229	if isco_08==	2267
replace isco88=	3229	if isco_08==	2269
replace isco88=	3229	if isco_08==	3259
replace isco88=	3231	if isco_08==	3221
replace isco88=	3232	if isco_08==	3222
replace isco88=	3241	if isco_08==	2230
replace isco88=	3241	if isco_08==	3230
replace isco88=	3242	if isco_08==	3413
replace isco88=	3310	if isco_08==	2341
replace isco88=	3320	if isco_08==	2342
replace isco88=	3330	if isco_08==	2352
replace isco88=	3340	if isco_08==	2353
replace isco88=	3340	if isco_08==	2355
replace isco88=	3340	if isco_08==	2356
replace isco88=	3340	if isco_08==	2359
replace isco88=	3340	if isco_08==	3153
replace isco88=	3340	if isco_08==	3423
replace isco88=	3340	if isco_08==	3435
replace isco88=	3340	if isco_08==	5165
replace isco88=	3411	if isco_08==	2412
replace isco88=	3411	if isco_08==	3311
replace isco88=	3412	if isco_08==	3321
replace isco88=	3413	if isco_08==	3334
replace isco88=	3414	if isco_08==	4221
replace isco88=	3415	if isco_08==	2433
replace isco88=	3415	if isco_08==	2434
replace isco88=	3415	if isco_08==	3322
replace isco88=	3416	if isco_08==	3323
replace isco88=	3417	if isco_08==	3315
replace isco88=	3417	if isco_08==	3339
replace isco88=	3419	if isco_08==	3312
replace isco88=	3421	if isco_08==	3324
replace isco88=	3422	if isco_08==	3331
replace isco88=	3423	if isco_08==	3333
replace isco88=	3429	if isco_08==	3339
replace isco88=	3431	if isco_08==	3341
replace isco88=	3431	if isco_08==	3342
replace isco88=	3431	if isco_08==	3343
replace isco88=	3431	if isco_08==	3344
replace isco88=	3432	if isco_08==	3411
replace isco88=	3433	if isco_08==	3313
replace isco88=	3434	if isco_08==	3313
replace isco88=	3434	if isco_08==	3314
replace isco88=	3439	if isco_08==	3332
replace isco88=	3439	if isco_08==	3343
replace isco88=	3439	if isco_08==	3359
replace isco88=	3439	if isco_08==	3433
replace isco88=	3441	if isco_08==	3351
replace isco88=	3442	if isco_08==	3352
replace isco88=	3443	if isco_08==	3353
replace isco88=	3444	if isco_08==	3354
replace isco88=	3449	if isco_08==	3359
replace isco88=	3450	if isco_08==	3355
replace isco88=	3450	if isco_08==	3411
replace isco88=	3460	if isco_08==	3412
replace isco88=	3471	if isco_08==	2163
replace isco88=	3471	if isco_08==	2166
replace isco88=	3471	if isco_08==	3432
replace isco88=	3471	if isco_08==	3433
replace isco88=	3471	if isco_08==	3435
replace isco88=	3472	if isco_08==	2642
replace isco88=	3472	if isco_08==	2656
replace isco88=	3473	if isco_08==	2652
replace isco88=	3473	if isco_08==	2653
replace isco88=	3474	if isco_08==	2659
replace isco88=	3475	if isco_08==	3421
replace isco88=	3475	if isco_08==	3422
replace isco88=	3475	if isco_08==	3423
replace isco88=	3480	if isco_08==	3413
replace isco88=	4111	if isco_08==	3341
replace isco88=	4111	if isco_08==	4131
replace isco88=	4112	if isco_08==	3341
replace isco88=	4112	if isco_08==	4131
replace isco88=	4113	if isco_08==	4132
replace isco88=	4114	if isco_08==	3341
replace isco88=	4114	if isco_08==	4132
replace isco88=	4115	if isco_08==	3341
replace isco88=	4115	if isco_08==	3342
replace isco88=	4115	if isco_08==	3344
replace isco88=	4115	if isco_08==	4120
replace isco88=	4121	if isco_08==	3341
replace isco88=	4121	if isco_08==	4311
replace isco88=	4121	if isco_08==	4313
replace isco88=	4122	if isco_08==	3341
replace isco88=	4122	if isco_08==	4312
replace isco88=	4131	if isco_08==	3341
replace isco88=	4131	if isco_08==	4321
replace isco88=	4132	if isco_08==	3341
replace isco88=	4132	if isco_08==	4322
replace isco88=	4133	if isco_08==	3341
replace isco88=	4133	if isco_08==	4323
replace isco88=	4141	if isco_08==	3341
replace isco88=	4141	if isco_08==	4411
replace isco88=	4141	if isco_08==	4415
replace isco88=	4142	if isco_08==	3341
replace isco88=	4142	if isco_08==	4412
replace isco88=	4143	if isco_08==	3252
replace isco88=	4143	if isco_08==	3341
replace isco88=	4143	if isco_08==	4413
replace isco88=	4144	if isco_08==	3341
replace isco88=	4144	if isco_08==	4414
replace isco88=	4190	if isco_08==	3341
replace isco88=	4190	if isco_08==	4110
replace isco88=	4190	if isco_08==	4227
replace isco88=	4190	if isco_08==	4416
replace isco88=	4190	if isco_08==	4419
replace isco88=	4211	if isco_08==	4211
replace isco88=	4211	if isco_08==	4212
replace isco88=	4211	if isco_08==	5230
replace isco88=	4212	if isco_08==	4211
replace isco88=	4213	if isco_08==	4212
replace isco88=	4214	if isco_08==	4213
replace isco88=	4215	if isco_08==	4214
replace isco88=	4221	if isco_08==	4221
replace isco88=	4222	if isco_08==	3341
replace isco88=	4222	if isco_08==	4222
replace isco88=	4222	if isco_08==	4224
replace isco88=	4222	if isco_08==	4225
replace isco88=	4222	if isco_08==	4226
replace isco88=	4222	if isco_08==	4229
replace isco88=	4223	if isco_08==	3341
replace isco88=	4223	if isco_08==	4223
replace isco88=	5111	if isco_08==	5111
replace isco88=	5112	if isco_08==	5112
replace isco88=	5113	if isco_08==	5113
replace isco88=	5121	if isco_08==	5151
replace isco88=	5121	if isco_08==	5152
replace isco88=	5122	if isco_08==	3434
replace isco88=	5122	if isco_08==	5120
replace isco88=	5122	if isco_08==	9411
replace isco88=	5123	if isco_08==	5131
replace isco88=	5123	if isco_08==	5132
replace isco88=	5131	if isco_08==	5311
replace isco88=	5131	if isco_08==	5312
replace isco88=	5132	if isco_08==	3258
replace isco88=	5132	if isco_08==	5321
replace isco88=	5132	if isco_08==	5329
replace isco88=	5133	if isco_08==	5322
replace isco88=	5139	if isco_08==	5164
replace isco88=	5139	if isco_08==	5329
replace isco88=	5141	if isco_08==	5141
replace isco88=	5141	if isco_08==	5142
replace isco88=	5142	if isco_08==	5162
replace isco88=	5143	if isco_08==	5163
replace isco88=	5149	if isco_08==	5169
replace isco88=	5151	if isco_08==	5161
replace isco88=	5152	if isco_08==	5161
replace isco88=	5161	if isco_08==	5411
replace isco88=	5162	if isco_08==	5412
replace isco88=	5163	if isco_08==	5413
replace isco88=	5169	if isco_08==	5414
replace isco88=	5169	if isco_08==	5419
replace isco88=	5210	if isco_08==	5241
replace isco88=	5220	if isco_08==	5222
replace isco88=	5220	if isco_08==	5223
replace isco88=	5220	if isco_08==	5242
replace isco88=	5220	if isco_08==	5245
replace isco88=	5220	if isco_08==	5246
replace isco88=	5220	if isco_08==	5249
replace isco88=	5230	if isco_08==	5211
replace isco88=	5230	if isco_08==	5246
replace isco88=	6111	if isco_08==	6111
replace isco88=	6112	if isco_08==	6112
replace isco88=	6113	if isco_08==	6113
replace isco88=	6113	if isco_08==	9214
replace isco88=	6114	if isco_08==	6114
replace isco88=	6121	if isco_08==	6121
replace isco88=	6122	if isco_08==	6122
replace isco88=	6123	if isco_08==	6123
replace isco88=	6124	if isco_08==	6121
replace isco88=	6124	if isco_08==	6122
replace isco88=	6124	if isco_08==	6123
replace isco88=	6129	if isco_08==	5164
replace isco88=	6129	if isco_08==	6129
replace isco88=	6130	if isco_08==	6130
replace isco88=	6141	if isco_08==	6210
replace isco88=	6142	if isco_08==	6210
replace isco88=	6151	if isco_08==	6221
replace isco88=	6152	if isco_08==	6222
replace isco88=	6152	if isco_08==	7541
replace isco88=	6153	if isco_08==	6223
replace isco88=	6154	if isco_08==	6224
replace isco88=	6210	if isco_08==	6310
replace isco88=	6210	if isco_08==	6320
replace isco88=	6210	if isco_08==	6330
replace isco88=	6210	if isco_08==	6340
replace isco88=	7111	if isco_08==	3121
replace isco88=	7111	if isco_08==	8111
replace isco88=	7112	if isco_08==	7542
replace isco88=	7113	if isco_08==	7113
replace isco88=	7121	if isco_08==	7111
replace isco88=	7122	if isco_08==	7112
replace isco88=	7122	if isco_08==	7113
replace isco88=	7123	if isco_08==	7114
replace isco88=	7124	if isco_08==	7115
replace isco88=	7129	if isco_08==	3123
replace isco88=	7129	if isco_08==	7111
replace isco88=	7129	if isco_08==	7119
replace isco88=	7131	if isco_08==	7121
replace isco88=	7132	if isco_08==	7122
replace isco88=	7133	if isco_08==	7123
replace isco88=	7134	if isco_08==	7124
replace isco88=	7135	if isco_08==	7125
replace isco88=	7136	if isco_08==	7126
replace isco88=	7137	if isco_08==	7411
replace isco88=	7141	if isco_08==	7131
replace isco88=	7142	if isco_08==	7132
replace isco88=	7143	if isco_08==	7133
replace isco88=	7143	if isco_08==	7544
replace isco88=	7211	if isco_08==	7211
replace isco88=	7212	if isco_08==	7212
replace isco88=	7213	if isco_08==	7213
replace isco88=	7214	if isco_08==	7214
replace isco88=	7215	if isco_08==	7215
replace isco88=	7216	if isco_08==	7541
replace isco88=	7221	if isco_08==	7221
replace isco88=	7222	if isco_08==	7222
replace isco88=	7223	if isco_08==	7223
replace isco88=	7224	if isco_08==	7224
replace isco88=	7231	if isco_08==	7231
replace isco88=	7231	if isco_08==	7234
replace isco88=	7232	if isco_08==	7232
replace isco88=	7233	if isco_08==	7127
replace isco88=	7233	if isco_08==	7233
replace isco88=	7241	if isco_08==	7412
replace isco88=	7242	if isco_08==	7421
replace isco88=	7242	if isco_08==	7422
replace isco88=	7243	if isco_08==	7421
replace isco88=	7243	if isco_08==	7422
replace isco88=	7244	if isco_08==	7422
replace isco88=	7245	if isco_08==	7413
replace isco88=	7245	if isco_08==	7422
replace isco88=	7311	if isco_08==	3214
replace isco88=	7311	if isco_08==	7311
replace isco88=	7312	if isco_08==	7312
replace isco88=	7313	if isco_08==	7313
replace isco88=	7321	if isco_08==	7314
replace isco88=	7322	if isco_08==	7315
replace isco88=	7322	if isco_08==	7549
replace isco88=	7323	if isco_08==	7316
replace isco88=	7324	if isco_08==	7316
replace isco88=	7331	if isco_08==	7317
replace isco88=	7331	if isco_08==	7319
replace isco88=	7332	if isco_08==	7318
replace isco88=	7341	if isco_08==	7321
replace isco88=	7341	if isco_08==	7322
replace isco88=	7342	if isco_08==	7321
replace isco88=	7343	if isco_08==	7321
replace isco88=	7344	if isco_08==	8132
replace isco88=	7345	if isco_08==	7323
replace isco88=	7346	if isco_08==	7322
replace isco88=	7411	if isco_08==	7511
replace isco88=	7412	if isco_08==	7512
replace isco88=	7413	if isco_08==	7513
replace isco88=	7414	if isco_08==	7514
replace isco88=	7415	if isco_08==	7515
replace isco88=	7416	if isco_08==	7516
replace isco88=	7421	if isco_08==	7521
replace isco88=	7422	if isco_08==	7522
replace isco88=	7423	if isco_08==	7523
replace isco88=	7424	if isco_08==	7317
replace isco88=	7431	if isco_08==	7318
replace isco88=	7432	if isco_08==	7318
replace isco88=	7432	if isco_08==	8152
replace isco88=	7433	if isco_08==	7531
replace isco88=	7434	if isco_08==	7531
replace isco88=	7435	if isco_08==	7532
replace isco88=	7436	if isco_08==	7533
replace isco88=	7437	if isco_08==	7534
replace isco88=	7441	if isco_08==	7535
replace isco88=	7442	if isco_08==	7536
replace isco88=	8111	if isco_08==	3121
replace isco88=	8111	if isco_08==	8111
replace isco88=	8112	if isco_08==	8112
replace isco88=	8113	if isco_08==	8113
replace isco88=	8121	if isco_08==	3135
replace isco88=	8121	if isco_08==	8121
replace isco88=	8122	if isco_08==	3135
replace isco88=	8122	if isco_08==	8121
replace isco88=	8123	if isco_08==	3135
replace isco88=	8123	if isco_08==	8121
replace isco88=	8124	if isco_08==	3135
replace isco88=	8124	if isco_08==	8121
replace isco88=	8131	if isco_08==	8181
replace isco88=	8139	if isco_08==	8181
replace isco88=	8141	if isco_08==	8172
replace isco88=	8142	if isco_08==	3139
replace isco88=	8142	if isco_08==	8171
replace isco88=	8143	if isco_08==	3139
replace isco88=	8143	if isco_08==	8171
replace isco88=	8151	if isco_08==	8131
replace isco88=	8152	if isco_08==	3133
replace isco88=	8152	if isco_08==	8131
replace isco88=	8153	if isco_08==	3133
replace isco88=	8153	if isco_08==	8131
replace isco88=	8154	if isco_08==	3133
replace isco88=	8154	if isco_08==	8131
replace isco88=	8155	if isco_08==	3134
replace isco88=	8155	if isco_08==	8131
replace isco88=	8159	if isco_08==	3133
replace isco88=	8159	if isco_08==	8131
replace isco88=	8161	if isco_08==	3131
replace isco88=	8162	if isco_08==	8182
replace isco88=	8163	if isco_08==	3132
replace isco88=	8171	if isco_08==	3122
replace isco88=	8171	if isco_08==	3139
replace isco88=	8172	if isco_08==	3122
replace isco88=	8172	if isco_08==	3139
replace isco88=	8211	if isco_08==	3122
replace isco88=	8211	if isco_08==	7223
replace isco88=	8212	if isco_08==	8114
replace isco88=	8221	if isco_08==	3122
replace isco88=	8221	if isco_08==	8131
replace isco88=	8222	if isco_08==	3122
replace isco88=	8222	if isco_08==	8131
replace isco88=	8223	if isco_08==	3122
replace isco88=	8223	if isco_08==	8122
replace isco88=	8224	if isco_08==	3122
replace isco88=	8224	if isco_08==	8132
replace isco88=	8229	if isco_08==	3122
replace isco88=	8229	if isco_08==	8131
replace isco88=	8231	if isco_08==	3122
replace isco88=	8231	if isco_08==	8141
replace isco88=	8232	if isco_08==	3122
replace isco88=	8232	if isco_08==	8142
replace isco88=	8240	if isco_08==	3122
replace isco88=	8240	if isco_08==	7523
replace isco88=	8251	if isco_08==	3122
replace isco88=	8251	if isco_08==	7322
replace isco88=	8252	if isco_08==	3122
replace isco88=	8252	if isco_08==	7323
replace isco88=	8253	if isco_08==	3122
replace isco88=	8253	if isco_08==	8143
replace isco88=	8261	if isco_08==	3122
replace isco88=	8261	if isco_08==	8151
replace isco88=	8262	if isco_08==	3122
replace isco88=	8262	if isco_08==	8152
replace isco88=	8263	if isco_08==	3122
replace isco88=	8263	if isco_08==	8153
replace isco88=	8264	if isco_08==	3122
replace isco88=	8264	if isco_08==	8154
replace isco88=	8264	if isco_08==	8157
replace isco88=	8265	if isco_08==	3122
replace isco88=	8265	if isco_08==	8155
replace isco88=	8266	if isco_08==	3122
replace isco88=	8266	if isco_08==	8156
replace isco88=	8269	if isco_08==	3122
replace isco88=	8269	if isco_08==	8159
replace isco88=	8271	if isco_08==	3122
replace isco88=	8271	if isco_08==	8160
replace isco88=	8272	if isco_08==	3122
replace isco88=	8272	if isco_08==	8160
replace isco88=	8273	if isco_08==	3122
replace isco88=	8273	if isco_08==	8160
replace isco88=	8274	if isco_08==	3122
replace isco88=	8274	if isco_08==	8160
replace isco88=	8275	if isco_08==	3122
replace isco88=	8275	if isco_08==	8160
replace isco88=	8276	if isco_08==	3122
replace isco88=	8276	if isco_08==	8160
replace isco88=	8277	if isco_08==	3122
replace isco88=	8277	if isco_08==	8160
replace isco88=	8278	if isco_08==	3122
replace isco88=	8278	if isco_08==	8160
replace isco88=	8279	if isco_08==	3122
replace isco88=	8279	if isco_08==	8160
replace isco88=	8281	if isco_08==	3122
replace isco88=	8281	if isco_08==	8211
replace isco88=	8282	if isco_08==	3122
replace isco88=	8282	if isco_08==	8212
replace isco88=	8283	if isco_08==	3122
replace isco88=	8283	if isco_08==	8212
replace isco88=	8284	if isco_08==	3122
replace isco88=	8284	if isco_08==	8219
replace isco88=	8285	if isco_08==	3122
replace isco88=	8285	if isco_08==	8219
replace isco88=	8286	if isco_08==	3122
replace isco88=	8286	if isco_08==	8219
replace isco88=	8290	if isco_08==	3122
replace isco88=	8290	if isco_08==	8183
replace isco88=	8290	if isco_08==	8189
replace isco88=	8290	if isco_08==	8219
replace isco88=	8311	if isco_08==	8311
replace isco88=	8312	if isco_08==	8312
replace isco88=	8321	if isco_08==	8321
replace isco88=	8322	if isco_08==	8322
replace isco88=	8323	if isco_08==	8331
replace isco88=	8324	if isco_08==	8332
replace isco88=	8331	if isco_08==	8341
replace isco88=	8332	if isco_08==	8342
replace isco88=	8333	if isco_08==	8343
replace isco88=	8334	if isco_08==	8344
replace isco88=	8340	if isco_08==	8350
replace isco88=	9111	if isco_08==	5212
replace isco88=	9112	if isco_08==	9520
replace isco88=	9113	if isco_08==	5243
replace isco88=	9113	if isco_08==	5244
replace isco88=	9120	if isco_08==	9510
replace isco88=	9131	if isco_08==	9111
replace isco88=	9132	if isco_08==	9112
replace isco88=	9132	if isco_08==	9412
replace isco88=	9133	if isco_08==	9121
replace isco88=	9141	if isco_08==	5153
replace isco88=	9142	if isco_08==	9122
replace isco88=	9142	if isco_08==	9123
replace isco88=	9142	if isco_08==	9129
replace isco88=	9151	if isco_08==	9621
replace isco88=	9152	if isco_08==	5414
replace isco88=	9152	if isco_08==	9621
replace isco88=	9152	if isco_08==	9629
replace isco88=	9153	if isco_08==	9623
replace isco88=	9161	if isco_08==	9611
replace isco88=	9161	if isco_08==	9612
replace isco88=	9162	if isco_08==	9613
replace isco88=	9162	if isco_08==	9622
replace isco88=	9162	if isco_08==	9624
replace isco88=	9211	if isco_08==	9211
replace isco88=	9211	if isco_08==	9212
replace isco88=	9211	if isco_08==	9213
replace isco88=	9211	if isco_08==	9214
replace isco88=	9212	if isco_08==	9215
replace isco88=	9213	if isco_08==	9216
replace isco88=	9311	if isco_08==	9311
replace isco88=	9312	if isco_08==	9312
replace isco88=	9313	if isco_08==	9313
replace isco88=	9321	if isco_08==	9329
replace isco88=	9321	if isco_08==	9612
replace isco88=	9322	if isco_08==	9321
replace isco88=	9322	if isco_08==	9329
replace isco88=	9331	if isco_08==	9331
replace isco88=	9332	if isco_08==	9332
replace isco88=	9333	if isco_08==	9333
replace isco88=	9333	if isco_08==	9334
replace isco88=	0110	if isco_08==	0110
replace isco88=	0110	if isco_08==	0210
replace isco88=	0110	if isco_08==	0310

 replace  isco_08_3=isco_08/10 if isco88==. & isco_08<=9620
 
 replace isco_3=	11	if isco_08_3==	11
replace isco_3=	11	if isco_08_3==	21
replace isco_3=	11	if isco_08_3==	31
replace isco_3=	114	if isco_08_3==	111
replace isco_3=	121	if isco_08_3==	112
replace isco_3=	122	if isco_08_3==	121
replace isco_3=	123	if isco_08_3==	122
replace isco_3=	122	if isco_08_3==	131
replace isco_3=	122	if isco_08_3==	132
replace isco_3=	131	if isco_08_3==	133
replace isco_3=	122	if isco_08_3==	134
replace isco_3=	122	if isco_08_3==	141
replace isco_3=	122	if isco_08_3==	142
replace isco_3=	131	if isco_08_3==	143
replace isco_3=	211	if isco_08_3==	211
replace isco_3=	212	if isco_08_3==	212
replace isco_3=	221	if isco_08_3==	213
replace isco_3=	214	if isco_08_3==	214
replace isco_3=	214	if isco_08_3==	215
replace isco_3=	214	if isco_08_3==	216
replace isco_3=	222	if isco_08_3==	221
replace isco_3=	223	if isco_08_3==	222
replace isco_3=	322	if isco_08_3==	223
replace isco_3=	322	if isco_08_3==	224
replace isco_3=	221	if isco_08_3==	225
replace isco_3=	322	if isco_08_3==	226
replace isco_3=	231	if isco_08_3==	231
replace isco_3=	231	if isco_08_3==	232
replace isco_3=	232	if isco_08_3==	233
replace isco_3=	233	if isco_08_3==	234
replace isco_3=	235	if isco_08_3==	235
replace isco_3=	241	if isco_08_3==	241
replace isco_3=	241	if isco_08_3==	242
replace isco_3=	241	if isco_08_3==	243
replace isco_3=	213	if isco_08_3==	251
replace isco_3=	213	if isco_08_3==	252
replace isco_3=	242	if isco_08_3==	261
replace isco_3=	243	if isco_08_3==	262
replace isco_3=	244	if isco_08_3==	263
replace isco_3=	245	if isco_08_3==	264
replace isco_3=	245	if isco_08_3==	265
replace isco_3=	311	if isco_08_3==	311
replace isco_3=	827	if isco_08_3==	312
replace isco_3=	815	if isco_08_3==	313
replace isco_3=	321	if isco_08_3==	314
replace isco_3=	314	if isco_08_3==	315
replace isco_3=	313	if isco_08_3==	321
replace isco_3=	223	if isco_08_3==	322
replace isco_3=	324	if isco_08_3==	323
replace isco_3=	322	if isco_08_3==	324
replace isco_3=	322	if isco_08_3==	325
replace isco_3=	341	if isco_08_3==	331
replace isco_3=	341	if isco_08_3==	332
replace isco_3=	342	if isco_08_3==	333
replace isco_3=	411	if isco_08_3==	334
replace isco_3=	344	if isco_08_3==	335
replace isco_3=	324	if isco_08_3==	341
replace isco_3=	347	if isco_08_3==	342
replace isco_3=	347	if isco_08_3==	343
replace isco_3=	312	if isco_08_3==	351
replace isco_3=	313	if isco_08_3==	352
replace isco_3=	419	if isco_08_3==	411
replace isco_3=	411	if isco_08_3==	412
replace isco_3=	411	if isco_08_3==	413
replace isco_3=	421	if isco_08_3==	421
replace isco_3=	422	if isco_08_3==	422
replace isco_3=	412	if isco_08_3==	431
replace isco_3=	413	if isco_08_3==	432
replace isco_3=	414	if isco_08_3==	441
replace isco_3=	511	if isco_08_3==	511
replace isco_3=	512	if isco_08_3==	512
replace isco_3=	512	if isco_08_3==	513
replace isco_3=	514	if isco_08_3==	514
replace isco_3=	512	if isco_08_3==	515
replace isco_3=	514	if isco_08_3==	516
replace isco_3=	523	if isco_08_3==	521
replace isco_3=	522	if isco_08_3==	522
replace isco_3=	421	if isco_08_3==	523
replace isco_3=	522	if isco_08_3==	524
replace isco_3=	513	if isco_08_3==	531
replace isco_3=	513	if isco_08_3==	532
replace isco_3=	516	if isco_08_3==	541
replace isco_3=	131	if isco_08_3==	611
replace isco_3=	612	if isco_08_3==	612
replace isco_3=	131	if isco_08_3==	613
replace isco_3=	614	if isco_08_3==	621
replace isco_3=	615	if isco_08_3==	622
replace isco_3=	621	if isco_08_3==	631
replace isco_3=	621	if isco_08_3==	632
replace isco_3=	621	if isco_08_3==	633
replace isco_3=	621	if isco_08_3==	634
replace isco_3=	712	if isco_08_3==	711
replace isco_3=	713	if isco_08_3==	712
replace isco_3=	714	if isco_08_3==	713
replace isco_3=	721	if isco_08_3==	721
replace isco_3=	722	if isco_08_3==	722
replace isco_3=	723	if isco_08_3==	723
replace isco_3=	732	if isco_08_3==	731
replace isco_3=	734	if isco_08_3==	732
replace isco_3=	724	if isco_08_3==	741
replace isco_3=	724	if isco_08_3==	742
replace isco_3=	741	if isco_08_3==	751
replace isco_3=	742	if isco_08_3==	752
replace isco_3=	743	if isco_08_3==	753
replace isco_3=	315	if isco_08_3==	754
replace isco_3=	811	if isco_08_3==	811
replace isco_3=	812	if isco_08_3==	812
replace isco_3=	815	if isco_08_3==	813
replace isco_3=	823	if isco_08_3==	814
replace isco_3=	826	if isco_08_3==	815
replace isco_3=	827	if isco_08_3==	816
replace isco_3=	814	if isco_08_3==	817
replace isco_3=	813	if isco_08_3==	818
replace isco_3=	828	if isco_08_3==	821
replace isco_3=	831	if isco_08_3==	831
replace isco_3=	832	if isco_08_3==	832
replace isco_3=	832	if isco_08_3==	833
replace isco_3=	833	if isco_08_3==	834
replace isco_3=	834	if isco_08_3==	835
replace isco_3=	913	if isco_08_3==	911
replace isco_3=	914	if isco_08_3==	912
replace isco_3=	921	if isco_08_3==	921
replace isco_3=	931	if isco_08_3==	931
replace isco_3=	932	if isco_08_3==	932
replace isco_3=	933	if isco_08_3==	933
replace isco_3=	512	if isco_08_3==	941
replace isco_3=	912	if isco_08_3==	951
replace isco_3=	911	if isco_08_3==	952
replace isco_3=	916	if isco_08_3==	961
replace isco_3=	915	if isco_08_3==	962


gen isco_string=string(isco88)
gen isco_stringb=string(isco_3)

 gen isco_3s=substr(isco_string, 1, 3)
destring isco_3s, replace
      gen isco_combined=isco_3s
      replace isco_combined=isco_3 if isco_combined==.
      replace isco_combined=isco_3 if isco_combined==.
replace isco_combined=. if isco_combined==0
replace isco_combined=. if isco_combined==9999

gen isco_2=substr(isco_string, 1, 2)
gen isco_2a=substr(isco_stringb, 1, 2) 
replace isco_2=isco_2a if isco_2=="."

/*Manual Replacements - Largest 2-digit in code group*/
replace isco_2="11" if isco_08==1100 & isco_2=="."
replace isco_2="12" if isco_08==1200 & isco_2=="."
replace isco_2="12" if isco_08==1300 & isco_2=="."
replace isco_2="12" if isco_08==1400 & isco_2=="."
replace isco_2="21" if isco_08==2100 & isco_2=="."
replace isco_2="22" if isco_08==2200 & isco_2=="."
replace isco_2="23" if isco_08==2300 & isco_2=="." /*Match to Teaching Other*/
replace isco_2="23" if isco_08==2500 & isco_2=="." /*Match to Teaching Other*/
/*2500 no fclear match, 30000 no clear*/
replace isco_2="24" if isco_08==2400 & isco_2=="."
replace isco_2="24" if isco_08==2600 & isco_2=="."
replace isco_2="31" if isco_08==3100 & isco_2=="."
replace isco_2="32" if isco_08==3200 & isco_2=="."
replace isco_2="34" if isco_08==3300 & isco_2=="."
replace isco_2="31" if isco_08==3500 & isco_2=="."
replace isco_2="41" if isco_08==4000 & isco_2=="." /*Match on title*/
replace isco_2="41" if isco_08==4200 & isco_2=="." /*Match on title*/
replace isco_2="51" if isco_08==5100 & isco_2=="." 
replace isco_2="52" if isco_08==5200 & isco_2=="." 
replace isco_2="51" if isco_08==5300 & isco_2=="." 
replace isco_2="62" if isco_08==6330 & isco_2=="."
replace isco_2="62" if isco_08==6340 & isco_2=="."
replace isco_2="73" if isco_08==7000 & isco_2=="." /*Match to Craft Other*/
replace isco_2="71" if isco_08==7100 & isco_2=="."
replace isco_2="72" if isco_08==7200 & isco_2=="."
replace isco_2="73" if isco_08==7300 & isco_2=="."
replace isco_2="72" if isco_08==7400 & isco_2=="."
replace isco_2="74" if isco_08==7500 & isco_2=="."
replace isco_2="81" if isco_08==8000 & isco_2=="." /*Match to Plant NEC*/
replace isco_2="81" if isco_08==8100 & isco_2=="." 
replace isco_2="82" if isco_08==8200 & isco_2=="." 
replace isco_2="83" if isco_08==8300 & isco_2=="." 
replace isco_2="91" if isco_08==9000 & isco_2=="." /*Match to Elementary NEC*/
replace isco_2="91" if isco_08==9100 & isco_2=="." 
replace isco_2="92" if isco_08==9200 & isco_2=="." 
replace isco_2="93" if isco_08==9300 & isco_2=="." 

/*9400 9600 splits*/

merge m:1 isco_2 using "Occupation_GROUPS.dta"
drop isco_08 isco_08_3
}

drop V*
drop DOI-MODE GROUP
drop if country==.


save `temp14', replace


}
if `year_2015'==1 {
********
* 2015 *
********

use "ZA6770.dta", clear
set more off

local main_variables 1
local parties 1
local occupation_recode 1

if `main_variables'==1 {
gen YYYY=2015
lab var YYYY "Survey Year"


gen weight=WEIGHT
recode weight 0=.
lab val weight weight
lab var weight "Weight"


gen country2=.
replace country2=36 if country==36
replace country2=40 if country==40
replace country2=56 if country==56
replace country2=154 if country==154
replace country2=208 if country== 208
replace country2=246 if country==246
replace country2=250 if country==250
replace country2=276 if country==276
replace country2=372 if country==372
replace country2=392 if country==392
replace country2=410 if country== 410
replace country2=528 if country==528
replace country2=554 if country==554
replace country2=578 if country==578
replace country2=620 if country==620
replace country2=724 if country==724
replace country2=752 if country==752
replace country2=756 if country==756
replace country2=826 if country==826
replace country2=840 if country==840
lab def country2 ///
	36 "Australia" ///
	40 "Austria" ///
	56 "Belgium" ///
	124 "Canada" ///
	208 "Denmark" ///
	246 "Finland" ///
	250 "France" ///
	276 "Germany" ///
	372 "Ireland" ///
	392 "Japan" ///
	410 "Korea" ///
	528 "Netherlands" ///
	554 "New Zealand" ///
	578 "Norway" ///
	620 "Portugal" ///
	724 "Spain" ///
	752 "Sweden" ///
	756 "Switzerland" ///
	826 "UK" ///
	840 "USA" 
lab val country2 country2
lab var country2 "Country"
tab country2

drop country

rename country2 country

gen east_germany=1 if c_sample==27602


gen sex=SEX
recode sex 0=. 9=.


tab AGE
gen age=AGE

recode age 999=. 0=.
gen birth=2015-age
label var birth "Year of Birth"

gen empl=.
replace empl=2 if WORK ==1
replace empl=1 if WORK ==2
replace empl=1 if WORK ==3
lab def empl ///
	1 "Not in Work" ///
	2 "Employed" 
lab val empl empl
lab var empl "Employment Status - 2"
tab empl

gen employee=.
replace employee =2 if EMPREL ==2
replace employee =2 if EMPREL ==3
replace employee =1 if EMPREL ==1
replace employee =1 if EMPREL ==4
lab def employee ///
	1 "Employed" ///
	2 "Self Employed" 
lab val employee employee
lab var employee "Employee"
tab employee

gen emplB=.
replace emplB=1 if MAIN==1
replace emplB=5 if MAIN==2
replace emplB=6 if MAIN==3
replace emplB=6 if MAIN==4
replace emplB=7 if MAIN==6
replace emplB=8 if MAIN==7
replace emplB=1 if MAIN==8
replace emplB=9 if MAIN==5
replace emplB=15 if MAIN==9
replace emplB=15 if MAIN==15

lab def emplB ///
	1 "Employed FT" ///
	2 "Employed PT" ///
	3 "Less than PT" ///
	4 "Helping Family Member" ///
	5 "Unemployed" ///
	6 "Student" ///
	7 "Retired" ///
	8 "Housewife/man" ///
	9 "Perm. dis" ///
	15 "Not in LF" 
lab val emplB emplB
lab var emplB "Employment Status"
tab emplB

gen education=.
replace education=1 if DEGREE==0
replace education=1 if DEGREE==1
replace education=2 if DEGREE==2
replace education=3 if DEGREE==3
replace education=4 if DEGREE==4
replace education=5 if DEGREE==5

lab def education ///
	1 "Less than lower secondary" ///
	2 "Lower Secondary" ///
	3 "Upper Secondary" ///
	4 "Vocational" ///
	5 "Degree" 
lab val education education
lab var education "Education Collapsed"
tab education

}
if `parties'==1 {

gen party_type=3

gen vote=VOTE_LE

gen party=.

replace party=2 if AU_PRTY ==1 & country==36 
replace party=1 if AU_PRTY==2 & country==36 
replace party=3 if AU_PRTY ==3 & country==36 
replace party=5 if AU_PRTY ==4 & country==36 
replace party=7 if AU_PRTY ==5 & country==36 
replace party=8 if AU_PRTY ==6 & country==36 
replace party=9 if AU_PRTY ==7 & country==36 
replace party=96 if AU_PRTY>=9 & AU_PRTY<=90 & country ==36
replace party=96 if AU_PRTY ==95 & country ==36
replace party=99 if AU_PRTY ==96 & country ==36

replace party=96 if AT_PRTY ==1 & country==40 
replace party=3 if AT_PRTY==2 & country==40 
replace party=1 if AT_PRTY ==3 & country==40 
replace party=2 if AT_PRTY ==4 & country==40 
replace party=96 if AT_PRTY ==5 & country==40 
replace party=4 if AT_PRTY ==6 & country==40 
replace party=96 if AT_PRTY ==95 & country ==40
replace party=99 if AT_PRTY ==96 & country ==40


replace party=15 if BE_PRTY==1 & country == 56
replace party=2 if BE_PRTY==2 & country == 56
replace party=8 if BE_PRTY==3 & country == 56
replace party=96 if BE_PRTY==4 & country == 56
replace party=23 if BE_PRTY==5 & country == 56
replace party=15 if BE_PRTY==6 & country == 56
replace party=5 if BE_PRTY==7 & country == 56
replace party=3 if BE_PRTY==8 & country == 56
replace party=16 if BE_PRTY==9 & country == 56
replace party=13 if BE_PRTY==10 & country == 56
replace party=96 if BE_PRTY==11 & country == 56
replace party=7 if BE_PRTY==12 & country == 56
replace party=4 if BE_PRTY==13 & country == 56
replace party=11 if BE_PRTY==14 & country == 56
replace party=1 if BE_PRTY==15 & country == 56
replace party=24 if BE_PRTY==16 & country == 56
replace party=15 if BE_PRTY==17 & country == 56
replace party=20 if BE_PRTY==18 & country == 56
replace party=19 if BE_PRTY==19 & country == 56
replace party=96 if BE_PRTY ==94 & country == 56
replace party=96 if BE_PRTY ==95 & country == 56



replace party =1 if DK_PRTY==1 & country ==208
replace party =2 if DK_PRTY==2 & country ==208
replace party =3 if DK_PRTY==3 & country ==208
replace party =5 if DK_PRTY==4 & country ==208
replace party =7 if DK_PRTY==5 & country ==208
replace party =6 if DK_PRTY==6 & country ==208
replace party =9 if DK_PRTY==7 & country ==208
replace party =12 if DK_PRTY==8 & country ==208
replace party =11 if DK_PRTY==9 & country ==208
replace party =96 if DK_PRTY ==95 & country == 208
replace party =99 if DK_PRTY ==96 & country == 208

replace party =3 if FI_PRTY==1 & country ==246
replace party =8 if FI_PRTY==2 & country ==246
replace party =5 if FI_PRTY==3 & country ==246
replace party =2 if FI_PRTY==4 & country ==246
replace party =7 if FI_PRTY==5 & country ==246
replace party =1 if FI_PRTY==6 & country ==246
replace party =4 if FI_PRTY==7 & country ==246
replace party =6 if FI_PRTY==8 & country ==246
replace party =96 if FI_PRTY ==95 & country == 246
replace party = 99 if FI_PRTY ==96 & country == 246
replace party = 99 if FI_PRTY ==97 & country == 246
replace party = 99 if FI_PRTY ==98 & country == 246


replace party=2 if FR_PRTY==1 & country==250 
replace party=2 if FR_PRTY==2 & country== 250 
replace party=2 if FR_PRTY==3 & country== 250 
replace party=3 if FR_PRTY==4 & country== 250 
replace party=4 if FR_PRTY==5 & country== 250 
replace party=5 if FR_PRTY==6 & country== 250 
replace party=6 if FR_PRTY==7 & country== 250 
replace party=7 if FR_PRTY==9 & country== 250 
replace party=96 if FR_PRTY==8 & country== 250 
replace party=96 if FR_PRTY==10 & country== 250 
replace party=96 if FR_PRTY ==95 & country == 250
replace party=99 if FR_PRTY ==96 & country == 250
replace party=99 if FR_PRTY ==97 & country == 250


replace party=2 if DE_PRTY ==1 & country== 276 
replace party=1 if DE_PRTY==2 & country==276 
replace party=9 if DE_PRTY ==3 & country== 276 
replace party=5 if DE_PRTY ==4 & country== 276 
replace party=4 if DE_PRTY ==5 & country== 276 
replace party=12 if DE_PRTY ==6 & country== 276 
replace party=11 if DE_PRTY ==7 & country== 276 
replace party=10 if DE_PRTY ==8 & country== 276 
replace party=96 if DE_PRTY ==9 & country== 276 
replace party=96 if DE_PRTY ==95 & country == 276
replace party=99 if DE_PRTY ==96 & country == 276




replace party=1 if JP_PRTY==1 & country==392 
replace party=9 if JP_PRTY==2 & country==392 
replace party=14 if JP_PRTY ==3 & country== 392 
replace party=3 if JP_PRTY ==4 & country== 392
replace party=16 if JP_PRTY ==5 & country== 392  
replace party=4 if JP_PRTY ==6 & country== 392 
replace party=96 if JP_PRTY ==7 & country== 392 
replace party=2 if JP_PRTY ==8 & country== 392 
replace party=96 if JP_PRTY ==9 & country== 392 
replace party=96 if JP_PRTY ==10 & country== 392 
replace party=96 if JP_PRTY ==11 & country== 392 
replace party=96 if JP_PRTY ==12 & country== 392 
replace party=96 if JP_PRTY ==95 & country == 392



replace party=6 if NO_PRTY ==1 & country== 578 
replace party=1 if NO_PRTY ==2 & country== 578 
replace party=2 if NO_PRTY==3 & country==578 
replace party=4 if NO_PRTY ==4 & country== 578
replace party=12 if NO_PRTY ==5 & country== 578  
replace party=10 if NO_PRTY ==6 & country== 578 
replace party=3 if NO_PRTY ==7 & country== 578 
replace party=7 if NO_PRTY ==8 & country== 578 
replace party=5 if NO_PRTY ==9 & country== 578 
replace party=96 if NO_PRTY ==95 & country == 578

replace party=2 if NZ_PRTY ==1 & country==554
replace party=3 if NZ_PRTY ==2 & country==554
replace party=1 if NZ_PRTY ==3 & country==554
replace party=9 if NZ_PRTY ==4 & country==554
replace party=12 if NZ_PRTY ==5 & country==554
replace party=14 if NZ_PRTY ==6 & country==554
replace party=16 if NZ_PRTY ==7 & country==554
replace party=16 if NZ_PRTY ==8 & country==554
replace party=96 if NZ_PRTY ==95 & country==554
replace party=99 if NZ_PRTY ==96 & country==554




replace party=1 if SE_PRTY==1 & country==752 
replace party=2 if SE_PRTY ==2 & country== 752 
replace party=3 if SE_PRTY ==3 & country== 752 
replace party=4 if SE_PRTY ==4 & country== 752 
replace party=5 if SE_PRTY ==5 & country== 752 
replace party=6 if SE_PRTY ==6 & country== 752 
replace party=8 if SE_PRTY ==7 & country== 752 
replace party=7 if SE_PRTY ==8 & country== 752 
replace party=96 if SE_PRTY ==95 & country == 752

replace party=1 if CH_PRTY==1 & country==756 
replace party=2 if CH_PRTY ==2 & country== 756 
replace party=3 if CH_PRTY ==3 & country== 756 
replace party=4 if CH_PRTY ==4 & country== 756 
replace party=18 if CH_PRTY ==5 & country== 756 
replace party=7 if CH_PRTY ==6 & country== 756 
replace party=15 if CH_PRTY ==7 & country== 756 
replace party=8 if CH_PRTY ==8 & country== 756 
replace party=10 if CH_PRTY ==9 & country== 756 
replace party=20 if CH_PRTY ==10 & country== 756 
replace party=15 if CH_PRTY ==11 & country== 756 
replace party=17 if CH_PRTY ==12 & country== 756 
replace party=16 if CH_PRTY ==13 & country== 756 
replace party=96 if CH_PRTY ==14 & country == 756
replace party= 96 if CH_PRTY ==95 & country == 756
replace party=99 if CH_PRTY ==96 & country == 756

replace party=US_PRTY if country == 840
replace party=96 if US_PRTY ==95 & country == 840


foreach var of varlist AT_PRTY AU_PRTY BE_PRTY CH_PRTY DE_PRTY ///
 DK_PRTY ES_PRTY FI_PRTY FR_PRTY GB_PRTY JP_PRTY NO_PRTY NZ_PRTY SE_PRTY US_PRTY {
   replace party=96 if `var'==96 & party==.
 replace party=97 if `var'==0 & party==.
 replace party=99 if `var'==99 & party==.
 replace party=99 if `var'==97 & party==.
 replace party=99 if `var'==98 & party==.

 }

lab val party party
lab var party "Party Choice"
tab party

rename PARTY_LR party_lr15
}




if `occupation_recode'==1 {
gen  isco_08=ISCO08

gen isco88=.
gen isco_3=.

*** ISCO 08*** 
replace isco88=	1110	if isco_08==	1111
replace isco88=	1120	if isco_08==	1112
replace isco88=	1130	if isco_08==	1113
replace isco88=	1141	if isco_08==	1114
replace isco88=	1142	if isco_08==	1114
replace isco88=	1143	if isco_08==	1114
replace isco88=	1210	if isco_08==	1120
replace isco88=	1221	if isco_08==	1311
replace isco88=	1221	if isco_08==	1312
replace isco88=	1222	if isco_08==	1321
replace isco88=	1222	if isco_08==	1322
replace isco88=	1223	if isco_08==	1323
replace isco88=	1223	if isco_08==	3123
replace isco88=	1224	if isco_08==	1420
replace isco88=	1225	if isco_08==	1411
replace isco88=	1225	if isco_08==	1412
replace isco88=	1226	if isco_08==	1324
replace isco88=	1226	if isco_08==	1330
replace isco88=	1227	if isco_08==	1219
replace isco88=	1227	if isco_08==	1346
replace isco88=	1228	if isco_08==	1219
replace isco88=	1229	if isco_08==	1213
replace isco88=	1229	if isco_08==	1219
replace isco88=	1229	if isco_08==	1341
replace isco88=	1229	if isco_08==	1342
replace isco88=	1229	if isco_08==	1343
replace isco88=	1229	if isco_08==	1344
replace isco88=	1229	if isco_08==	1345
replace isco88=	1229	if isco_08==	1349
replace isco88=	1229	if isco_08==	1439
replace isco88=	1229	if isco_08==	2654
replace isco88=	1229	if isco_08==	3435
replace isco88=	1231	if isco_08==	1211
replace isco88=	1231	if isco_08==	1219
replace isco88=	1232	if isco_08==	1212
replace isco88=	1233	if isco_08==	1221
replace isco88=	1234	if isco_08==	1222
replace isco88=	1235	if isco_08==	1324
replace isco88=	1236	if isco_08==	1330
replace isco88=	1237	if isco_08==	1223
replace isco88=	1239	if isco_08==	1213
replace isco88=	1311	if isco_08==	6111
replace isco88=	1311	if isco_08==	6112
replace isco88=	1311	if isco_08==	6113
replace isco88=	1311	if isco_08==	6114
replace isco88=	1311	if isco_08==	6121
replace isco88=	1311	if isco_08==	6122
replace isco88=	1311	if isco_08==	6130
replace isco88=	1311	if isco_08==	6210
replace isco88=	1311	if isco_08==	6221
replace isco88=	1311	if isco_08==	6222
replace isco88=	1311	if isco_08==	6223
replace isco88=	1312	if isco_08==	1321
replace isco88=	1312	if isco_08==	1322
replace isco88=	1313	if isco_08==	1323
replace isco88=	1314	if isco_08==	1420
replace isco88=	1314	if isco_08==	5221
replace isco88=	1315	if isco_08==	1411
replace isco88=	1315	if isco_08==	1412
replace isco88=	1316	if isco_08==	1324
replace isco88=	1316	if isco_08==	1330
replace isco88=	1317	if isco_08==	1211
replace isco88=	1317	if isco_08==	1212
replace isco88=	1317	if isco_08==	1219
replace isco88=	1317	if isco_08==	1221
replace isco88=	1317	if isco_08==	1222
replace isco88=	1317	if isco_08==	1330
replace isco88=	1317	if isco_08==	1346
replace isco88=	1318	if isco_08==	1219
replace isco88=	1319	if isco_08==	1223
replace isco88=	1319	if isco_08==	1341
replace isco88=	1319	if isco_08==	1342
replace isco88=	1319	if isco_08==	1343
replace isco88=	1319	if isco_08==	1344
replace isco88=	1319	if isco_08==	1345
replace isco88=	1319	if isco_08==	1349
replace isco88=	1319	if isco_08==	1431
replace isco88=	1319	if isco_08==	1439
replace isco88=	2111	if isco_08==	2111
replace isco88=	2112	if isco_08==	2112
replace isco88=	2113	if isco_08==	2113
replace isco88=	2113	if isco_08==	2262
replace isco88=	2114	if isco_08==	2114
replace isco88=	2121	if isco_08==	2120
replace isco88=	2122	if isco_08==	2120
replace isco88=	2131	if isco_08==	2511
replace isco88=	2131	if isco_08==	2512
replace isco88=	2131	if isco_08==	2513
replace isco88=	2131	if isco_08==	2519
replace isco88=	2131	if isco_08==	2521
replace isco88=	2131	if isco_08==	2522
replace isco88=	2131	if isco_08==	2523
replace isco88=	2132	if isco_08==	2513
replace isco88=	2132	if isco_08==	2514
replace isco88=	2132	if isco_08==	2519
replace isco88=	2139	if isco_08==	2513
replace isco88=	2139	if isco_08==	2519
replace isco88=	2139	if isco_08==	2529
replace isco88=	2141	if isco_08==	2161
replace isco88=	2141	if isco_08==	2162
replace isco88=	2141	if isco_08==	2164
replace isco88=	2142	if isco_08==	2142
replace isco88=	2143	if isco_08==	2151
replace isco88=	2144	if isco_08==	2152
replace isco88=	2144	if isco_08==	2153
replace isco88=	2145	if isco_08==	2144
replace isco88=	2146	if isco_08==	2145
replace isco88=	2147	if isco_08==	2146
replace isco88=	2148	if isco_08==	2165
replace isco88=	2149	if isco_08==	2141
replace isco88=	2149	if isco_08==	2143
replace isco88=	2149	if isco_08==	2149
replace isco88=	2211	if isco_08==	2131
replace isco88=	2211	if isco_08==	2133
replace isco88=	2212	if isco_08==	2131
replace isco88=	2212	if isco_08==	2212
replace isco88=	2212	if isco_08==	2250
replace isco88=	2213	if isco_08==	2132
replace isco88=	2221	if isco_08==	2211
replace isco88=	2221	if isco_08==	2212
replace isco88=	2222	if isco_08==	2261
replace isco88=	2223	if isco_08==	2250
replace isco88=	2224	if isco_08==	2262
replace isco88=	2229	if isco_08==	2263
replace isco88=	2229	if isco_08==	2269
replace isco88=	2230	if isco_08==	1342
replace isco88=	2230	if isco_08==	1343
replace isco88=	2230	if isco_08==	2221
replace isco88=	2230	if isco_08==	2222
replace isco88=	2230	if isco_08==	3221
replace isco88=	2230	if isco_08==	3222
replace isco88=	2310	if isco_08==	2310
replace isco88=	2310	if isco_08==	2320
replace isco88=	2320	if isco_08==	2320
replace isco88=	2320	if isco_08==	2330
replace isco88=	2331	if isco_08==	2341
replace isco88=	2332	if isco_08==	2342
replace isco88=	2340	if isco_08==	2352
replace isco88=	2351	if isco_08==	2351
replace isco88=	2352	if isco_08==	2351
replace isco88=	2359	if isco_08==	2353
replace isco88=	2359	if isco_08==	2354
replace isco88=	2359	if isco_08==	2355
replace isco88=	2359	if isco_08==	2356
replace isco88=	2359	if isco_08==	2359
replace isco88=	2411	if isco_08==	2411
replace isco88=	2411	if isco_08==	2412
replace isco88=	2412	if isco_08==	2263
replace isco88=	2412	if isco_08==	2423
replace isco88=	2412	if isco_08==	2424
replace isco88=	2419	if isco_08==	2412
replace isco88=	2419	if isco_08==	2413
replace isco88=	2419	if isco_08==	2421
replace isco88=	2419	if isco_08==	2422
replace isco88=	2419	if isco_08==	2431
replace isco88=	2419	if isco_08==	2432
replace isco88=	2419	if isco_08==	3339
replace isco88=	2421	if isco_08==	2611
replace isco88=	2422	if isco_08==	2612
replace isco88=	2429	if isco_08==	2619
replace isco88=	2431	if isco_08==	2621
replace isco88=	2432	if isco_08==	2622
replace isco88=	2441	if isco_08==	2631
replace isco88=	2442	if isco_08==	2632
replace isco88=	2443	if isco_08==	2633
replace isco88=	2444	if isco_08==	2643
replace isco88=	2445	if isco_08==	2634
replace isco88=	2446	if isco_08==	2635
replace isco88=	2451	if isco_08==	2431
replace isco88=	2451	if isco_08==	2432
replace isco88=	2451	if isco_08==	2641
replace isco88=	2451	if isco_08==	2642
replace isco88=	2452	if isco_08==	2651
replace isco88=	2453	if isco_08==	2652
replace isco88=	2454	if isco_08==	2653
replace isco88=	2455	if isco_08==	2654
replace isco88=	2455	if isco_08==	2655
replace isco88=	2460	if isco_08==	2636
replace isco88=	3111	if isco_08==	3111
replace isco88=	3112	if isco_08==	3112
replace isco88=	3113	if isco_08==	3113
replace isco88=	3114	if isco_08==	3114
replace isco88=	3114	if isco_08==	3522
replace isco88=	3115	if isco_08==	3115
replace isco88=	3116	if isco_08==	3116
replace isco88=	3117	if isco_08==	3117
replace isco88=	3118	if isco_08==	3118
replace isco88=	3119	if isco_08==	3119
replace isco88=	3121	if isco_08==	3512
replace isco88=	3121	if isco_08==	3513
replace isco88=	3121	if isco_08==	3514
replace isco88=	3122	if isco_08==	3511
replace isco88=	3122	if isco_08==	3514
replace isco88=	3123	if isco_08==	3139
replace isco88=	3131	if isco_08==	3431
replace isco88=	3131	if isco_08==	3521
replace isco88=	3132	if isco_08==	3521
replace isco88=	3132	if isco_08==	3522
replace isco88=	3133	if isco_08==	3211
replace isco88=	3141	if isco_08==	3151
replace isco88=	3142	if isco_08==	3152
replace isco88=	3143	if isco_08==	3153
replace isco88=	3144	if isco_08==	3154
replace isco88=	3145	if isco_08==	3155
replace isco88=	3151	if isco_08==	3112
replace isco88=	3151	if isco_08==	3359
replace isco88=	3152	if isco_08==	2263
replace isco88=	3152	if isco_08==	3113
replace isco88=	3152	if isco_08==	3114
replace isco88=	3152	if isco_08==	3115
replace isco88=	3152	if isco_08==	3117
replace isco88=	3152	if isco_08==	3257
replace isco88=	3152	if isco_08==	7543
replace isco88=	3211	if isco_08==	3141
replace isco88=	3211	if isco_08==	3212
replace isco88=	3212	if isco_08==	3142
replace isco88=	3212	if isco_08==	3143
replace isco88=	3213	if isco_08==	2132
replace isco88=	3221	if isco_08==	2240
replace isco88=	3221	if isco_08==	3253
replace isco88=	3221	if isco_08==	3256
replace isco88=	3222	if isco_08==	2263
replace isco88=	3222	if isco_08==	3257
replace isco88=	3223	if isco_08==	2265
replace isco88=	3224	if isco_08==	2267
replace isco88=	3224	if isco_08==	3254
replace isco88=	3225	if isco_08==	3251
replace isco88=	3226	if isco_08==	2264
replace isco88=	3226	if isco_08==	2269
replace isco88=	3226	if isco_08==	3255
replace isco88=	3226	if isco_08==	3259
replace isco88=	3227	if isco_08==	3240
replace isco88=	3228	if isco_08==	3213
replace isco88=	3229	if isco_08==	2230
replace isco88=	3229	if isco_08==	2266
replace isco88=	3229	if isco_08==	2267
replace isco88=	3229	if isco_08==	2269
replace isco88=	3229	if isco_08==	3259
replace isco88=	3231	if isco_08==	3221
replace isco88=	3232	if isco_08==	3222
replace isco88=	3241	if isco_08==	2230
replace isco88=	3241	if isco_08==	3230
replace isco88=	3242	if isco_08==	3413
replace isco88=	3310	if isco_08==	2341
replace isco88=	3320	if isco_08==	2342
replace isco88=	3330	if isco_08==	2352
replace isco88=	3340	if isco_08==	2353
replace isco88=	3340	if isco_08==	2355
replace isco88=	3340	if isco_08==	2356
replace isco88=	3340	if isco_08==	2359
replace isco88=	3340	if isco_08==	3153
replace isco88=	3340	if isco_08==	3423
replace isco88=	3340	if isco_08==	3435
replace isco88=	3340	if isco_08==	5165
replace isco88=	3411	if isco_08==	2412
replace isco88=	3411	if isco_08==	3311
replace isco88=	3412	if isco_08==	3321
replace isco88=	3413	if isco_08==	3334
replace isco88=	3414	if isco_08==	4221
replace isco88=	3415	if isco_08==	2433
replace isco88=	3415	if isco_08==	2434
replace isco88=	3415	if isco_08==	3322
replace isco88=	3416	if isco_08==	3323
replace isco88=	3417	if isco_08==	3315
replace isco88=	3417	if isco_08==	3339
replace isco88=	3419	if isco_08==	3312
replace isco88=	3421	if isco_08==	3324
replace isco88=	3422	if isco_08==	3331
replace isco88=	3423	if isco_08==	3333
replace isco88=	3429	if isco_08==	3339
replace isco88=	3431	if isco_08==	3341
replace isco88=	3431	if isco_08==	3342
replace isco88=	3431	if isco_08==	3343
replace isco88=	3431	if isco_08==	3344
replace isco88=	3432	if isco_08==	3411
replace isco88=	3433	if isco_08==	3313
replace isco88=	3434	if isco_08==	3313
replace isco88=	3434	if isco_08==	3314
replace isco88=	3439	if isco_08==	3332
replace isco88=	3439	if isco_08==	3343
replace isco88=	3439	if isco_08==	3359
replace isco88=	3439	if isco_08==	3433
replace isco88=	3441	if isco_08==	3351
replace isco88=	3442	if isco_08==	3352
replace isco88=	3443	if isco_08==	3353
replace isco88=	3444	if isco_08==	3354
replace isco88=	3449	if isco_08==	3359
replace isco88=	3450	if isco_08==	3355
replace isco88=	3450	if isco_08==	3411
replace isco88=	3460	if isco_08==	3412
replace isco88=	3471	if isco_08==	2163
replace isco88=	3471	if isco_08==	2166
replace isco88=	3471	if isco_08==	3432
replace isco88=	3471	if isco_08==	3433
replace isco88=	3471	if isco_08==	3435
replace isco88=	3472	if isco_08==	2642
replace isco88=	3472	if isco_08==	2656
replace isco88=	3473	if isco_08==	2652
replace isco88=	3473	if isco_08==	2653
replace isco88=	3474	if isco_08==	2659
replace isco88=	3475	if isco_08==	3421
replace isco88=	3475	if isco_08==	3422
replace isco88=	3475	if isco_08==	3423
replace isco88=	3480	if isco_08==	3413
replace isco88=	4111	if isco_08==	3341
replace isco88=	4111	if isco_08==	4131
replace isco88=	4112	if isco_08==	3341
replace isco88=	4112	if isco_08==	4131
replace isco88=	4113	if isco_08==	4132
replace isco88=	4114	if isco_08==	3341
replace isco88=	4114	if isco_08==	4132
replace isco88=	4115	if isco_08==	3341
replace isco88=	4115	if isco_08==	3342
replace isco88=	4115	if isco_08==	3344
replace isco88=	4115	if isco_08==	4120
replace isco88=	4121	if isco_08==	3341
replace isco88=	4121	if isco_08==	4311
replace isco88=	4121	if isco_08==	4313
replace isco88=	4122	if isco_08==	3341
replace isco88=	4122	if isco_08==	4312
replace isco88=	4131	if isco_08==	3341
replace isco88=	4131	if isco_08==	4321
replace isco88=	4132	if isco_08==	3341
replace isco88=	4132	if isco_08==	4322
replace isco88=	4133	if isco_08==	3341
replace isco88=	4133	if isco_08==	4323
replace isco88=	4141	if isco_08==	3341
replace isco88=	4141	if isco_08==	4411
replace isco88=	4141	if isco_08==	4415
replace isco88=	4142	if isco_08==	3341
replace isco88=	4142	if isco_08==	4412
replace isco88=	4143	if isco_08==	3252
replace isco88=	4143	if isco_08==	3341
replace isco88=	4143	if isco_08==	4413
replace isco88=	4144	if isco_08==	3341
replace isco88=	4144	if isco_08==	4414
replace isco88=	4190	if isco_08==	3341
replace isco88=	4190	if isco_08==	4110
replace isco88=	4190	if isco_08==	4227
replace isco88=	4190	if isco_08==	4416
replace isco88=	4190	if isco_08==	4419
replace isco88=	4211	if isco_08==	4211
replace isco88=	4211	if isco_08==	4212
replace isco88=	4211	if isco_08==	5230
replace isco88=	4212	if isco_08==	4211
replace isco88=	4213	if isco_08==	4212
replace isco88=	4214	if isco_08==	4213
replace isco88=	4215	if isco_08==	4214
replace isco88=	4221	if isco_08==	4221
replace isco88=	4222	if isco_08==	3341
replace isco88=	4222	if isco_08==	4222
replace isco88=	4222	if isco_08==	4224
replace isco88=	4222	if isco_08==	4225
replace isco88=	4222	if isco_08==	4226
replace isco88=	4222	if isco_08==	4229
replace isco88=	4223	if isco_08==	3341
replace isco88=	4223	if isco_08==	4223
replace isco88=	5111	if isco_08==	5111
replace isco88=	5112	if isco_08==	5112
replace isco88=	5113	if isco_08==	5113
replace isco88=	5121	if isco_08==	5151
replace isco88=	5121	if isco_08==	5152
replace isco88=	5122	if isco_08==	3434
replace isco88=	5122	if isco_08==	5120
replace isco88=	5122	if isco_08==	9411
replace isco88=	5123	if isco_08==	5131
replace isco88=	5123	if isco_08==	5132
replace isco88=	5131	if isco_08==	5311
replace isco88=	5131	if isco_08==	5312
replace isco88=	5132	if isco_08==	3258
replace isco88=	5132	if isco_08==	5321
replace isco88=	5132	if isco_08==	5329
replace isco88=	5133	if isco_08==	5322
replace isco88=	5139	if isco_08==	5164
replace isco88=	5139	if isco_08==	5329
replace isco88=	5141	if isco_08==	5141
replace isco88=	5141	if isco_08==	5142
replace isco88=	5142	if isco_08==	5162
replace isco88=	5143	if isco_08==	5163
replace isco88=	5149	if isco_08==	5169
replace isco88=	5151	if isco_08==	5161
replace isco88=	5152	if isco_08==	5161
replace isco88=	5161	if isco_08==	5411
replace isco88=	5162	if isco_08==	5412
replace isco88=	5163	if isco_08==	5413
replace isco88=	5169	if isco_08==	5414
replace isco88=	5169	if isco_08==	5419
replace isco88=	5210	if isco_08==	5241
replace isco88=	5220	if isco_08==	5222
replace isco88=	5220	if isco_08==	5223
replace isco88=	5220	if isco_08==	5242
replace isco88=	5220	if isco_08==	5245
replace isco88=	5220	if isco_08==	5246
replace isco88=	5220	if isco_08==	5249
replace isco88=	5230	if isco_08==	5211
replace isco88=	5230	if isco_08==	5246
replace isco88=	6111	if isco_08==	6111
replace isco88=	6112	if isco_08==	6112
replace isco88=	6113	if isco_08==	6113
replace isco88=	6113	if isco_08==	9214
replace isco88=	6114	if isco_08==	6114
replace isco88=	6121	if isco_08==	6121
replace isco88=	6122	if isco_08==	6122
replace isco88=	6123	if isco_08==	6123
replace isco88=	6124	if isco_08==	6121
replace isco88=	6124	if isco_08==	6122
replace isco88=	6124	if isco_08==	6123
replace isco88=	6129	if isco_08==	5164
replace isco88=	6129	if isco_08==	6129
replace isco88=	6130	if isco_08==	6130
replace isco88=	6141	if isco_08==	6210
replace isco88=	6142	if isco_08==	6210
replace isco88=	6151	if isco_08==	6221
replace isco88=	6152	if isco_08==	6222
replace isco88=	6152	if isco_08==	7541
replace isco88=	6153	if isco_08==	6223
replace isco88=	6154	if isco_08==	6224
replace isco88=	6210	if isco_08==	6310
replace isco88=	6210	if isco_08==	6320
replace isco88=	6210	if isco_08==	6330
replace isco88=	6210	if isco_08==	6340
replace isco88=	7111	if isco_08==	3121
replace isco88=	7111	if isco_08==	8111
replace isco88=	7112	if isco_08==	7542
replace isco88=	7113	if isco_08==	7113
replace isco88=	7121	if isco_08==	7111
replace isco88=	7122	if isco_08==	7112
replace isco88=	7122	if isco_08==	7113
replace isco88=	7123	if isco_08==	7114
replace isco88=	7124	if isco_08==	7115
replace isco88=	7129	if isco_08==	3123
replace isco88=	7129	if isco_08==	7111
replace isco88=	7129	if isco_08==	7119
replace isco88=	7131	if isco_08==	7121
replace isco88=	7132	if isco_08==	7122
replace isco88=	7133	if isco_08==	7123
replace isco88=	7134	if isco_08==	7124
replace isco88=	7135	if isco_08==	7125
replace isco88=	7136	if isco_08==	7126
replace isco88=	7137	if isco_08==	7411
replace isco88=	7141	if isco_08==	7131
replace isco88=	7142	if isco_08==	7132
replace isco88=	7143	if isco_08==	7133
replace isco88=	7143	if isco_08==	7544
replace isco88=	7211	if isco_08==	7211
replace isco88=	7212	if isco_08==	7212
replace isco88=	7213	if isco_08==	7213
replace isco88=	7214	if isco_08==	7214
replace isco88=	7215	if isco_08==	7215
replace isco88=	7216	if isco_08==	7541
replace isco88=	7221	if isco_08==	7221
replace isco88=	7222	if isco_08==	7222
replace isco88=	7223	if isco_08==	7223
replace isco88=	7224	if isco_08==	7224
replace isco88=	7231	if isco_08==	7231
replace isco88=	7231	if isco_08==	7234
replace isco88=	7232	if isco_08==	7232
replace isco88=	7233	if isco_08==	7127
replace isco88=	7233	if isco_08==	7233
replace isco88=	7241	if isco_08==	7412
replace isco88=	7242	if isco_08==	7421
replace isco88=	7242	if isco_08==	7422
replace isco88=	7243	if isco_08==	7421
replace isco88=	7243	if isco_08==	7422
replace isco88=	7244	if isco_08==	7422
replace isco88=	7245	if isco_08==	7413
replace isco88=	7245	if isco_08==	7422
replace isco88=	7311	if isco_08==	3214
replace isco88=	7311	if isco_08==	7311
replace isco88=	7312	if isco_08==	7312
replace isco88=	7313	if isco_08==	7313
replace isco88=	7321	if isco_08==	7314
replace isco88=	7322	if isco_08==	7315
replace isco88=	7322	if isco_08==	7549
replace isco88=	7323	if isco_08==	7316
replace isco88=	7324	if isco_08==	7316
replace isco88=	7331	if isco_08==	7317
replace isco88=	7331	if isco_08==	7319
replace isco88=	7332	if isco_08==	7318
replace isco88=	7341	if isco_08==	7321
replace isco88=	7341	if isco_08==	7322
replace isco88=	7342	if isco_08==	7321
replace isco88=	7343	if isco_08==	7321
replace isco88=	7344	if isco_08==	8132
replace isco88=	7345	if isco_08==	7323
replace isco88=	7346	if isco_08==	7322
replace isco88=	7411	if isco_08==	7511
replace isco88=	7412	if isco_08==	7512
replace isco88=	7413	if isco_08==	7513
replace isco88=	7414	if isco_08==	7514
replace isco88=	7415	if isco_08==	7515
replace isco88=	7416	if isco_08==	7516
replace isco88=	7421	if isco_08==	7521
replace isco88=	7422	if isco_08==	7522
replace isco88=	7423	if isco_08==	7523
replace isco88=	7424	if isco_08==	7317
replace isco88=	7431	if isco_08==	7318
replace isco88=	7432	if isco_08==	7318
replace isco88=	7432	if isco_08==	8152
replace isco88=	7433	if isco_08==	7531
replace isco88=	7434	if isco_08==	7531
replace isco88=	7435	if isco_08==	7532
replace isco88=	7436	if isco_08==	7533
replace isco88=	7437	if isco_08==	7534
replace isco88=	7441	if isco_08==	7535
replace isco88=	7442	if isco_08==	7536
replace isco88=	8111	if isco_08==	3121
replace isco88=	8111	if isco_08==	8111
replace isco88=	8112	if isco_08==	8112
replace isco88=	8113	if isco_08==	8113
replace isco88=	8121	if isco_08==	3135
replace isco88=	8121	if isco_08==	8121
replace isco88=	8122	if isco_08==	3135
replace isco88=	8122	if isco_08==	8121
replace isco88=	8123	if isco_08==	3135
replace isco88=	8123	if isco_08==	8121
replace isco88=	8124	if isco_08==	3135
replace isco88=	8124	if isco_08==	8121
replace isco88=	8131	if isco_08==	8181
replace isco88=	8139	if isco_08==	8181
replace isco88=	8141	if isco_08==	8172
replace isco88=	8142	if isco_08==	3139
replace isco88=	8142	if isco_08==	8171
replace isco88=	8143	if isco_08==	3139
replace isco88=	8143	if isco_08==	8171
replace isco88=	8151	if isco_08==	8131
replace isco88=	8152	if isco_08==	3133
replace isco88=	8152	if isco_08==	8131
replace isco88=	8153	if isco_08==	3133
replace isco88=	8153	if isco_08==	8131
replace isco88=	8154	if isco_08==	3133
replace isco88=	8154	if isco_08==	8131
replace isco88=	8155	if isco_08==	3134
replace isco88=	8155	if isco_08==	8131
replace isco88=	8159	if isco_08==	3133
replace isco88=	8159	if isco_08==	8131
replace isco88=	8161	if isco_08==	3131
replace isco88=	8162	if isco_08==	8182
replace isco88=	8163	if isco_08==	3132
replace isco88=	8171	if isco_08==	3122
replace isco88=	8171	if isco_08==	3139
replace isco88=	8172	if isco_08==	3122
replace isco88=	8172	if isco_08==	3139
replace isco88=	8211	if isco_08==	3122
replace isco88=	8211	if isco_08==	7223
replace isco88=	8212	if isco_08==	8114
replace isco88=	8221	if isco_08==	3122
replace isco88=	8221	if isco_08==	8131
replace isco88=	8222	if isco_08==	3122
replace isco88=	8222	if isco_08==	8131
replace isco88=	8223	if isco_08==	3122
replace isco88=	8223	if isco_08==	8122
replace isco88=	8224	if isco_08==	3122
replace isco88=	8224	if isco_08==	8132
replace isco88=	8229	if isco_08==	3122
replace isco88=	8229	if isco_08==	8131
replace isco88=	8231	if isco_08==	3122
replace isco88=	8231	if isco_08==	8141
replace isco88=	8232	if isco_08==	3122
replace isco88=	8232	if isco_08==	8142
replace isco88=	8240	if isco_08==	3122
replace isco88=	8240	if isco_08==	7523
replace isco88=	8251	if isco_08==	3122
replace isco88=	8251	if isco_08==	7322
replace isco88=	8252	if isco_08==	3122
replace isco88=	8252	if isco_08==	7323
replace isco88=	8253	if isco_08==	3122
replace isco88=	8253	if isco_08==	8143
replace isco88=	8261	if isco_08==	3122
replace isco88=	8261	if isco_08==	8151
replace isco88=	8262	if isco_08==	3122
replace isco88=	8262	if isco_08==	8152
replace isco88=	8263	if isco_08==	3122
replace isco88=	8263	if isco_08==	8153
replace isco88=	8264	if isco_08==	3122
replace isco88=	8264	if isco_08==	8154
replace isco88=	8264	if isco_08==	8157
replace isco88=	8265	if isco_08==	3122
replace isco88=	8265	if isco_08==	8155
replace isco88=	8266	if isco_08==	3122
replace isco88=	8266	if isco_08==	8156
replace isco88=	8269	if isco_08==	3122
replace isco88=	8269	if isco_08==	8159
replace isco88=	8271	if isco_08==	3122
replace isco88=	8271	if isco_08==	8160
replace isco88=	8272	if isco_08==	3122
replace isco88=	8272	if isco_08==	8160
replace isco88=	8273	if isco_08==	3122
replace isco88=	8273	if isco_08==	8160
replace isco88=	8274	if isco_08==	3122
replace isco88=	8274	if isco_08==	8160
replace isco88=	8275	if isco_08==	3122
replace isco88=	8275	if isco_08==	8160
replace isco88=	8276	if isco_08==	3122
replace isco88=	8276	if isco_08==	8160
replace isco88=	8277	if isco_08==	3122
replace isco88=	8277	if isco_08==	8160
replace isco88=	8278	if isco_08==	3122
replace isco88=	8278	if isco_08==	8160
replace isco88=	8279	if isco_08==	3122
replace isco88=	8279	if isco_08==	8160
replace isco88=	8281	if isco_08==	3122
replace isco88=	8281	if isco_08==	8211
replace isco88=	8282	if isco_08==	3122
replace isco88=	8282	if isco_08==	8212
replace isco88=	8283	if isco_08==	3122
replace isco88=	8283	if isco_08==	8212
replace isco88=	8284	if isco_08==	3122
replace isco88=	8284	if isco_08==	8219
replace isco88=	8285	if isco_08==	3122
replace isco88=	8285	if isco_08==	8219
replace isco88=	8286	if isco_08==	3122
replace isco88=	8286	if isco_08==	8219
replace isco88=	8290	if isco_08==	3122
replace isco88=	8290	if isco_08==	8183
replace isco88=	8290	if isco_08==	8189
replace isco88=	8290	if isco_08==	8219
replace isco88=	8311	if isco_08==	8311
replace isco88=	8312	if isco_08==	8312
replace isco88=	8321	if isco_08==	8321
replace isco88=	8322	if isco_08==	8322
replace isco88=	8323	if isco_08==	8331
replace isco88=	8324	if isco_08==	8332
replace isco88=	8331	if isco_08==	8341
replace isco88=	8332	if isco_08==	8342
replace isco88=	8333	if isco_08==	8343
replace isco88=	8334	if isco_08==	8344
replace isco88=	8340	if isco_08==	8350
replace isco88=	9111	if isco_08==	5212
replace isco88=	9112	if isco_08==	9520
replace isco88=	9113	if isco_08==	5243
replace isco88=	9113	if isco_08==	5244
replace isco88=	9120	if isco_08==	9510
replace isco88=	9131	if isco_08==	9111
replace isco88=	9132	if isco_08==	9112
replace isco88=	9132	if isco_08==	9412
replace isco88=	9133	if isco_08==	9121
replace isco88=	9141	if isco_08==	5153
replace isco88=	9142	if isco_08==	9122
replace isco88=	9142	if isco_08==	9123
replace isco88=	9142	if isco_08==	9129
replace isco88=	9151	if isco_08==	9621
replace isco88=	9152	if isco_08==	5414
replace isco88=	9152	if isco_08==	9621
replace isco88=	9152	if isco_08==	9629
replace isco88=	9153	if isco_08==	9623
replace isco88=	9161	if isco_08==	9611
replace isco88=	9161	if isco_08==	9612
replace isco88=	9162	if isco_08==	9613
replace isco88=	9162	if isco_08==	9622
replace isco88=	9162	if isco_08==	9624
replace isco88=	9211	if isco_08==	9211
replace isco88=	9211	if isco_08==	9212
replace isco88=	9211	if isco_08==	9213
replace isco88=	9211	if isco_08==	9214
replace isco88=	9212	if isco_08==	9215
replace isco88=	9213	if isco_08==	9216
replace isco88=	9311	if isco_08==	9311
replace isco88=	9312	if isco_08==	9312
replace isco88=	9313	if isco_08==	9313
replace isco88=	9321	if isco_08==	9329
replace isco88=	9321	if isco_08==	9612
replace isco88=	9322	if isco_08==	9321
replace isco88=	9322	if isco_08==	9329
replace isco88=	9331	if isco_08==	9331
replace isco88=	9332	if isco_08==	9332
replace isco88=	9333	if isco_08==	9333
replace isco88=	9333	if isco_08==	9334
replace isco88=	0110	if isco_08==	0110
replace isco88=	0110	if isco_08==	0210
replace isco88=	0110	if isco_08==	0310

 gen  isco_08_3=isco_08/10 if isco88==. & isco_08<=9620
 
 replace isco_3=	11	if isco_08_3==	11
replace isco_3=	11	if isco_08_3==	21
replace isco_3=	11	if isco_08_3==	31
replace isco_3=	114	if isco_08_3==	111
replace isco_3=	121	if isco_08_3==	112
replace isco_3=	122	if isco_08_3==	121
replace isco_3=	123	if isco_08_3==	122
replace isco_3=	122	if isco_08_3==	131
replace isco_3=	122	if isco_08_3==	132
replace isco_3=	131	if isco_08_3==	133
replace isco_3=	122	if isco_08_3==	134
replace isco_3=	122	if isco_08_3==	141
replace isco_3=	122	if isco_08_3==	142
replace isco_3=	131	if isco_08_3==	143
replace isco_3=	211	if isco_08_3==	211
replace isco_3=	212	if isco_08_3==	212
replace isco_3=	221	if isco_08_3==	213
replace isco_3=	214	if isco_08_3==	214
replace isco_3=	214	if isco_08_3==	215
replace isco_3=	214	if isco_08_3==	216
replace isco_3=	222	if isco_08_3==	221
replace isco_3=	223	if isco_08_3==	222
replace isco_3=	322	if isco_08_3==	223
replace isco_3=	322	if isco_08_3==	224
replace isco_3=	221	if isco_08_3==	225
replace isco_3=	322	if isco_08_3==	226
replace isco_3=	231	if isco_08_3==	231
replace isco_3=	231	if isco_08_3==	232
replace isco_3=	232	if isco_08_3==	233
replace isco_3=	233	if isco_08_3==	234
replace isco_3=	235	if isco_08_3==	235
replace isco_3=	241	if isco_08_3==	241
replace isco_3=	241	if isco_08_3==	242
replace isco_3=	241	if isco_08_3==	243
replace isco_3=	213	if isco_08_3==	251
replace isco_3=	213	if isco_08_3==	252
replace isco_3=	242	if isco_08_3==	261
replace isco_3=	243	if isco_08_3==	262
replace isco_3=	244	if isco_08_3==	263
replace isco_3=	245	if isco_08_3==	264
replace isco_3=	245	if isco_08_3==	265
replace isco_3=	311	if isco_08_3==	311
replace isco_3=	827	if isco_08_3==	312
replace isco_3=	815	if isco_08_3==	313
replace isco_3=	321	if isco_08_3==	314
replace isco_3=	314	if isco_08_3==	315
replace isco_3=	313	if isco_08_3==	321
replace isco_3=	223	if isco_08_3==	322
replace isco_3=	324	if isco_08_3==	323
replace isco_3=	322	if isco_08_3==	324
replace isco_3=	322	if isco_08_3==	325
replace isco_3=	341	if isco_08_3==	331
replace isco_3=	341	if isco_08_3==	332
replace isco_3=	342	if isco_08_3==	333
replace isco_3=	411	if isco_08_3==	334
replace isco_3=	344	if isco_08_3==	335
replace isco_3=	324	if isco_08_3==	341
replace isco_3=	347	if isco_08_3==	342
replace isco_3=	347	if isco_08_3==	343
replace isco_3=	312	if isco_08_3==	351
replace isco_3=	313	if isco_08_3==	352
replace isco_3=	419	if isco_08_3==	411
replace isco_3=	411	if isco_08_3==	412
replace isco_3=	411	if isco_08_3==	413
replace isco_3=	421	if isco_08_3==	421
replace isco_3=	422	if isco_08_3==	422
replace isco_3=	412	if isco_08_3==	431
replace isco_3=	413	if isco_08_3==	432
replace isco_3=	414	if isco_08_3==	441
replace isco_3=	511	if isco_08_3==	511
replace isco_3=	512	if isco_08_3==	512
replace isco_3=	512	if isco_08_3==	513
replace isco_3=	514	if isco_08_3==	514
replace isco_3=	512	if isco_08_3==	515
replace isco_3=	514	if isco_08_3==	516
replace isco_3=	523	if isco_08_3==	521
replace isco_3=	522	if isco_08_3==	522
replace isco_3=	421	if isco_08_3==	523
replace isco_3=	522	if isco_08_3==	524
replace isco_3=	513	if isco_08_3==	531
replace isco_3=	513	if isco_08_3==	532
replace isco_3=	516	if isco_08_3==	541
replace isco_3=	131	if isco_08_3==	611
replace isco_3=	612	if isco_08_3==	612
replace isco_3=	131	if isco_08_3==	613
replace isco_3=	614	if isco_08_3==	621
replace isco_3=	615	if isco_08_3==	622
replace isco_3=	621	if isco_08_3==	631
replace isco_3=	621	if isco_08_3==	632
replace isco_3=	621	if isco_08_3==	633
replace isco_3=	621	if isco_08_3==	634
replace isco_3=	712	if isco_08_3==	711
replace isco_3=	713	if isco_08_3==	712
replace isco_3=	714	if isco_08_3==	713
replace isco_3=	721	if isco_08_3==	721
replace isco_3=	722	if isco_08_3==	722
replace isco_3=	723	if isco_08_3==	723
replace isco_3=	732	if isco_08_3==	731
replace isco_3=	734	if isco_08_3==	732
replace isco_3=	724	if isco_08_3==	741
replace isco_3=	724	if isco_08_3==	742
replace isco_3=	741	if isco_08_3==	751
replace isco_3=	742	if isco_08_3==	752
replace isco_3=	743	if isco_08_3==	753
replace isco_3=	315	if isco_08_3==	754
replace isco_3=	811	if isco_08_3==	811
replace isco_3=	812	if isco_08_3==	812
replace isco_3=	815	if isco_08_3==	813
replace isco_3=	823	if isco_08_3==	814
replace isco_3=	826	if isco_08_3==	815
replace isco_3=	827	if isco_08_3==	816
replace isco_3=	814	if isco_08_3==	817
replace isco_3=	813	if isco_08_3==	818
replace isco_3=	828	if isco_08_3==	821
replace isco_3=	831	if isco_08_3==	831
replace isco_3=	832	if isco_08_3==	832
replace isco_3=	832	if isco_08_3==	833
replace isco_3=	833	if isco_08_3==	834
replace isco_3=	834	if isco_08_3==	835
replace isco_3=	913	if isco_08_3==	911
replace isco_3=	914	if isco_08_3==	912
replace isco_3=	921	if isco_08_3==	921
replace isco_3=	931	if isco_08_3==	931
replace isco_3=	932	if isco_08_3==	932
replace isco_3=	933	if isco_08_3==	933
replace isco_3=	512	if isco_08_3==	941
replace isco_3=	912	if isco_08_3==	951
replace isco_3=	911	if isco_08_3==	952
replace isco_3=	916	if isco_08_3==	961
replace isco_3=	915	if isco_08_3==	962


gen isco_string=string(isco88)
gen isco_stringb=string(isco_3)

 gen isco_3s=substr(isco_string, 1, 3)
destring isco_3s, replace
      gen isco_combined=isco_3s
      replace isco_combined=isco_3 if isco_combined==.
      replace isco_combined=isco_3 if isco_combined==.
replace isco_combined=. if isco_combined==0
replace isco_combined=. if isco_combined==9999

gen isco_2=substr(isco_string, 1, 2)
gen isco_2a=substr(isco_stringb, 1, 2) 
replace isco_2=isco_2a if isco_2=="."

/*Manual Replacements - Largest 2-digit in code group*/
replace isco_2="11" if isco_08==1100 & isco_2=="."
replace isco_2="12" if isco_08==1200 & isco_2=="."
replace isco_2="12" if isco_08==1300 & isco_2=="."
replace isco_2="12" if isco_08==1400 & isco_2=="."
replace isco_2="21" if isco_08==2100 & isco_2=="."
replace isco_2="22" if isco_08==2200 & isco_2=="."
replace isco_2="23" if isco_08==2300 & isco_2=="." /*Match to Teaching Other*/
replace isco_2="23" if isco_08==2500 & isco_2=="." /*Match to Teaching Other*/
/*2500 no fclear match, 30000 no clear*/
replace isco_2="24" if isco_08==2400 & isco_2=="."
replace isco_2="24" if isco_08==2600 & isco_2=="."
replace isco_2="31" if isco_08==3100 & isco_2=="."
replace isco_2="32" if isco_08==3200 & isco_2=="."
replace isco_2="34" if isco_08==3300 & isco_2=="."
replace isco_2="31" if isco_08==3500 & isco_2=="."
replace isco_2="41" if isco_08==4000 & isco_2=="." /*Match on title*/
replace isco_2="41" if isco_08==4100 & isco_2=="." 
replace isco_2="41" if isco_08==4200 & isco_2=="." /*Match on title*/
replace isco_2="41" if isco_08==4300 & isco_2=="." /*Match on title*/
replace isco_2="41" if isco_08==4400 & isco_2=="." /**/
replace isco_2="51" if isco_08==5400 & isco_2=="." 
replace isco_2="51" if isco_08==5100 & isco_2=="." 
replace isco_2="52" if isco_08==5200 & isco_2=="." 
replace isco_2="51" if isco_08==5300 & isco_2=="." 
replace isco_2="62" if isco_08==6330 & isco_2=="."
replace isco_2="62" if isco_08==6340 & isco_2=="."
replace isco_2="73" if isco_08==7000 & isco_2=="." /*Match to Craft Other*/
replace isco_2="71" if isco_08==7100 & isco_2=="."
replace isco_2="72" if isco_08==7200 & isco_2=="."
replace isco_2="73" if isco_08==7300 & isco_2=="."
replace isco_2="72" if isco_08==7400 & isco_2=="."
replace isco_2="74" if isco_08==7500 & isco_2=="."
replace isco_2="81" if isco_08==8000 & isco_2=="." /*Match to Plant NEC*/
replace isco_2="81" if isco_08==8100 & isco_2=="." 
replace isco_2="82" if isco_08==8200 & isco_2=="." 
replace isco_2="83" if isco_08==8300 & isco_2=="." 
replace isco_2="91" if isco_08==9000 & isco_2=="." /*Match to Elementary NEC*/
replace isco_2="91" if isco_08==9100 & isco_2=="." 
replace isco_2="92" if isco_08==9200 & isco_2=="." 
replace isco_2="93" if isco_08==9300 & isco_2=="." 

/*9400 9600 splits*/

merge m:1 isco_2 using "Occupation_GROUPS.dta"
}

drop V1-MODE
drop v*
drop studyno-c_alphan
drop if country==.

save `temp15', replace
}

use `temp95'
append using `temp96'
append using `temp97'
append using `temp98'
append using `temp99'
append using `temp00'
append using `temp01'
append using `temp02'
append using `temp03'
append using `temp04'
append using `temp05'
append using `temp06'
append using `temp07'
append using `temp08'
append using `temp09'
append using `temp10'
append using `temp11'
append using `temp12'
append using `temp13'
append using `temp14'
append using `temp15'

rename isco_2 ISCO_2
drop isco*
rename ISCO_2 isco_2
drop occup*


}
if `cleaning_combined'==1 { 

** VARIABLE RECODING*** 

rename YYYY year 
rename country ccode

gen unemployed_all=1 if emplB==5
replace unemployed_all=0 if emplB!=5

gen degree=1 if education==5
replace degree=0 if education!=5

gen nosec=1 if education==1
replace nosec=0 if education!=1

gen group_RTI2=(group_RTI-1)/4 /*Recodes RTI to run 0-1*/

gen age_groups3=1 if age>=18 & age<35
replace age_groups3=2 if age>=35 & age<55
replace age_groups3=3 if age>=55

replace isco_2="" if isco_2==".a"
replace isco_2="" if isco_2==".b"
replace isco_2="" if isco_2==".c"
replace isco_2="" if isco_2==".d"
replace isco_2="" if isco_2==".e"
replace isco_2="" if isco_2==".n"
replace isco_2="" if isco_2=="0"
replace isco_2="" if isco_2=="."
replace isco_2="" if isco_2=="99"
replace isco_2="" if isco_2=="9999"
destring isco_2, replace

** GROUPING VARIABLES** 
*This defines the group of countries present in each cycle* 
gen sample1=1 if ccode==			36
replace sample1=1 if ccode==		40
replace sample1=1 if ccode==		124
replace sample1=1 if ccode==		208
replace sample1=1 if ccode==		246
replace sample1=1 if ccode==		250
replace sample1=1 if ccode==		276
replace sample1=1 if ccode==		372
replace sample1=1 if ccode==		392
replace sample1=1 if ccode==		528
replace sample1=1 if ccode==		554
replace sample1=1 if ccode==		578
replace sample1=1 if ccode==		620
replace sample1=1 if ccode==		724
replace sample1=1 if ccode==		752
replace sample1=1 if ccode==		756
replace sample1=1 if ccode==		826
replace sample1=1 if ccode==		840

*This defines the cycles* 
gen cycle=.
replace cycle=5 if year>=1995 & year<2000
replace cycle=6 if year>=2000 & year<2005
replace cycle=7 if year>=2005 & year<2010
replace cycle=8 if year>=2010 & year<=2015
replace cycle=9 if year>2015

*Cluster Variables*
gen cy=ccode*year
gen cy2=ccode*cycle

** SAMPLE *** 
*Restricts to those in labor force, with reliable occupational data
gen sample_rti=1 if  empl!=. 
replace sample_rti=. if emplB>=1 & emplB<=5 & sample_rti==.
replace sample_rti=. if age<=20 | age>65

keep if sample_rti==1 

}

if `party_coding'==1 {
*This creates broad party families from the country-year party recoding

gen vote_sd=.
gen vote_left=.
gen vote_green=. 
gen vote_cons=. 
gen vote_liberal=.
gen vote_communist=.  
gen vote_cd=.
gen vote_rpop=.
gen vote_regional=.
gen vote_otherleft=.
gen vote_otherright=.
gen vote_other=.
gen vote_welfare=.

*Australia*
replace vote_green=1 if party==7 & ccode==36 /* Greens */ 
replace vote_green =0 if vote_green!=1 & ccode==36 & party<=9 

replace vote_sd=1 if party==2 & ccode==36  /* Labour */ 
replace vote_sd=0 if vote_sd!=1 & ccode==36 & party<=9 

replace vote_otherleft =1 if party==4 & ccode==36  /* Australia Democrats*/
replace vote_otherleft=1 if party==5 & ccode==36  /* Democratic Labour Party*/
replace vote_otherleft =0 if vote_otherleft!=1 & ccode==36 & party<=9 

replace vote_liberal=1 if party==1 & ccode==36  /*Liberal*/
replace vote_liberal =0 if vote_liberal!=1 & ccode==36 & party<=9 

replace vote_cons=1 if party==3 & ccode==36  /*National */
replace vote_cons=1 if party==9 & ccode==36  /*Family First */
replace vote_cons =0 if vote_cons!=1 & ccode==36 & party<=9 

replace vote_rpop =1 if party==8 & ccode==36  /* One Nation */
replace vote_rpop =0 if vote_rpop!=1 & ccode==36 & party<=9 /*  */ 

replace vote_regional=0 if ccode==36 &  party<=9
replace vote_cd =0 if ccode==36 &  party<=9
replace vote_communist=0 if ccode==36 &  party<=9
replace vote_other=0 if ccode==36 &  party<=9

*Austria*
replace vote_green =1 if party==4 & ccode==40  /* VGO */ 
replace vote_green =1 if party==8 & ccode==40  /* GA */ 
replace vote_green =0 if vote_green!=1 & ccode==40 & party<=16

replace vote_communist =1 if party==7 & ccode==40  /* KPO */ 
replace vote_communist =0 if vote_communist!=1 & ccode==40 & party<=16

replace vote_sd=1 if party==1 & ccode==40  /* SPO */ 
replace vote_sd =0 if vote_sd!=1 & ccode==40 & party<=16

replace vote_liberal=1 if party==9 & ccode==40  /* LIF */ 
replace vote_liberal =1 if ccode==40 & party==12 /* Neos */
replace vote_liberal =0 if vote_liberal!=1 & ccode== 40 & party<=16
 
replace vote_cd =1 if party==2 & ccode==40  /* OVP */ 
replace vote_cd =0 if vote_cd!=1 & ccode==40 & party<=16

replace vote_rpop =1 if party==3 & ccode==40 /* FPO*/
replace vote_rpop =1 if party==10 & ccode==40 /* BZOE */
replace vote_rpop =1 if party==14 & ccode==40 /* Team Frank Stronach  */
replace vote_rpop =0 if vote_rpop!=1 & ccode==40 & party<=16

replace vote_other=0 if ccode==40
replace vote_cons=0 if ccode==40
replace vote_otherright=0 if ccode==40
replace vote_otherleft=0 if ccode==40
replace vote_regional=0 if ccode==40

*Belgium*
replace vote_green =1 if party==2 & ccode==56  /* Groen! */ 
replace vote_green =1 if party==16 & ccode==56  /* Ecolo */ 
replace vote_green =0 if vote_green!=1 & ccode== 56 & party<=24

replace vote_communist= 1 if party==20 & ccode==56 /* PTB*/
replace vote_communist =0 if vote_communist!=1 & ccode== 56 & party<=24

replace vote_sd=1 if party==7 & ccode==56  /* Socialist/SPa/Spirit */ 
replace vote_sd=1 if party==13 & ccode==56  /* PS */ 
replace vote_sd =0 if vote_sd!=1 & ccode== 56 & party<=24

replace vote_otherleft=1 if party==15 & ccode==56 /*PvdA */
replace vote_otherleft =0 if vote_otherleft!=1 & ccode== 56 & party<=24

replace vote_liberal =1 if party==5 & ccode==56  /* PVV/VLD */ 
replace vote_liberal =1 if party==14 & ccode==56  /* MR/PFL-FDF*/ 
replace vote_liberal =1 if party==3 & ccode==56  /* LDD*/ 
replace vote_liberal =1 if party==23 & ccode==56  /*  Vivant */ 
replace vote_liberal =0 if vote_liberal!=1 & ccode== 56& party<=28

replace vote_cd =1 if party==1 & ccode==56  /* CVP */ 
replace vote_cd =1 if party==11 & ccode==56  /* CDH/PSC */ 
replace vote_cd =0 if vote_cd!=1 & ccode== 56 & party<=24

replace vote_cons =1 if party==24 & ccode==56 /* PP */
replace vote_cons =0 if vote_cons!=1 & ccode== 56 & party<=24

replace vote_rpop =1 if party==19 & ccode==56  /* FN */ 
replace vote_rpop =1 if party==8 & ccode ==56  /* Vlaams Belang*/
replace vote_rpop =0 if vote_rpop!=1 & ccode== 56   & party<=28

replace vote_regional=1 if party==4 & ccode==56 /* NV-A */
replace vote_regional=1 if party==17 & ccode ==56 /* VU-ID */
replace vote_regional =0 if vote_regional!=1 & ccode== 56 & party<=24

replace vote_otherright =0 if ccode== 56 & party<=24
replace vote_other =0 if ccode== 56 & vote_other!=1 & party<=24 

*Canada*

replace vote_green =1 if party==9 & ccode==124  /* Green */ 
replace vote_green =0 if vote_green!=1 & ccode==124 & party<=9

replace vote_communist =1 if party==8 & ccode==124 /* Communist */ 
replace vote_communist=0 if vote_communist!=1 & ccode==124 & party<=9

replace vote_sd=1 if party==3 & ccode==124  /* NDP */ 
replace vote_sd =0 if vote_sd!=1 & ccode==124 & party<=9

replace vote_otherleft=0 if ccode==124 

replace vote_liberal =1 if party==2 & ccode==124 /* Liberal */ 
replace vote_liberal =0 if vote_liberal!=1 & ccode==124 & party<=9

replace vote_cons =1 if party==1 & ccode==124 /* PC/CA/Conservative */ 
replace vote_cons =1 if party==5 & ccode==124 /* Reform */ 
replace vote_cons =1 if party==10 & ccode==124 /* Social Credit */ 
replace vote_cons =0 if vote_cons!=1 & ccode==124 & party<=9

replace vote_cd =0 if ccode==124 
replace vote_rpop =0 if ccode==124 

replace vote_regional=1 if party==4 & ccode==124 /* BQ*/
replace vote_regional =0 if vote_regional!=1 & ccode==124 & party<=9

replace vote_other=1 if party==6 & ccode==124 /* Lib*/
replace vote_other=1 if party==7 & ccode==124 /* Confed*/
replace vote_other =0 if vote_other!=1 & ccode==124 & party<=9


*Denmark*

replace vote_sd=1 if party==1 & ccode==208  /* SD */ 
replace vote_sd =0 if vote_sd!=1 & ccode==208 & party<=12

replace vote_green =0 if vote_green!=1 & ccode==208 & party<=12

replace vote_communist =1 if party==13 & ccode==208 /* DKP */ 
replace vote_communist =1 if party==5 & ccode==208 /* SF */ 
replace vote_communist =1 if party==11 & ccode==208  /* Leftwing Alliance */ 
replace vote_communist=0 if vote_communist!=1 & ccode==208 & party<=12

replace vote_otherleft=0 if vote_otherleft!=1 & ccode==208 & party<=12

replace vote_liberal =1 if party==9 & ccode==208 /* Liberal */ 
replace vote_liberal =1 if party==2 & ccode==208 /* RV */ 
replace vote_liberal =1 if party==12 & ccode==208 /* New Alliance */ 
replace vote_liberal =0 if vote_liberal!=1 & ccode==208 & party<=12

replace vote_cons =1 if party==3 & ccode==208 /* Conservative KF */ 
replace vote_cons =0 if vote_cons!=1 & ccode==208 & party<=12

replace vote_cd =1 if party==7 & ccode==208 /* Christian Peoples */ 
replace vote_cd =1 if party==4 & ccode==208 /* CD */ 
replace vote_cd =0 if vote_cd!=1 & ccode==208 & party<=12


replace vote_rpop =1 if party==6 & ccode== 208 /* People's party (DF)*/
replace vote_rpop =1 if party==10 & ccode == 208 /* FRP */
replace vote_rpop =0 if vote_rpop!=1 & ccode ==208 & party<=16

replace vote_regional =0 if ccode== 208 

replace vote_otherright=0 if ccode==208

replace vote_other=1 if ccode==208 & party==14 /* Rets Retsforbundet */
replace vote_other=0 if vote_other!=1 & ccode ==208 & party<=16


*Finland*

replace vote_green =1 if party==6 & ccode==246  /* VIHR */
replace vote_green =0 if vote_green!=1 & ccode==246 & party<=9

replace vote_communist =1 if party==4 & ccode==246 /* VAS */ 
replace vote_communist=0 if vote_communist!=1 & ccode==246 & party<=9

replace vote_otherleft =0 if vote_otherleft!=1 & ccode==246 & party<=9

replace vote_sd=1 if party==1 & ccode==246  /* SD */ 
replace vote_sd =0 if vote_sd!=1 & ccode==246 & party<=9

replace vote_liberal =1 if party==10 & ccode==246 /* Liberal */ 
replace vote_liberal =0 if vote_liberal!=1 & ccode==246 & party<=9

replace vote_cons =1 if party==3 & ccode==246 /* KOK */ 
replace vote_cons =0 if vote_cons!=1 & ccode==246 & party<=9

replace vote_cd =1 if party==7 & ccode==246 /* Christian Peoples */ 
replace vote_cd =0 if vote_cd!=1 & ccode==246 & party<=9

replace vote_rpop =1 if party==8 & ccode== 246 /* True Finns*/
replace vote_rpop =0 if vote_rpop!=1 & ccode == 246 & party<=9

replace vote_regional =1 if party==5 & ccode== 246 /* Swedish People's party*/
replace vote_regional =0 if vote_regional!=1 & ccode == 246 & party<=9

replace vote_other =1 if party==9 & ccode==246 /* Reform*/ 
replace vote_other =0 if vote_other!=1 & ccode == 246 & party<=9

replace vote_otherright =1 if party==2 & ccode==246 /* KESK */ 
replace vote_otherright =0 if vote_otherright!=1 & ccode == 246 & party<=9

*France*

replace vote_communist =1 if party==1 & ccode==250 /* Communist */ 
replace vote_communist =1 if party==2 & ccode==250 /* Far left (LCR, LO) */ 
replace vote_communist=0 if vote_communist!=1 & ccode==250 & party<=8

replace vote_otherleft =0 if vote_otherleft!=1 & ccode==250 & party<=8

replace vote_sd=1 if party==3 & ccode==250  /* PS */ 
replace vote_sd =0 if vote_sd!=1 & ccode==250 & party<=8

replace vote_green =1 if party==4 & ccode==250  /* Green */ 
replace vote_green =0 if vote_green!=1 & ccode==250 & party<=8

replace vote_liberal =0 if vote_liberal!=1 & ccode==250 & party<=8

replace vote_cons =1 if party==6 & ccode==250 /* RPR/ UMP */ 
replace vote_cons =1 if party==5 & ccode==250 /* UDF */ 
replace vote_cons =0 if vote_cons!=1 & ccode==250 & party<=8

replace vote_cd =0 if ccode==250 & party<=8

replace vote_rpop =1 if party==7 & ccode==250 /* FN*/
replace vote_rpop =0 if vote_rpop!=1 & ccode == 250 & party<=26

replace vote_otherright =1 if ccode == 250 & party==8 /* Chasse*/
replace vote_otherright =0 if vote_otherright!=1 & ccode == 250 & party<=26

replace vote_other=0 if vote_other!=1 & ccode==250 & party<=8

*Germany*

replace vote_sd=1 if party==1 & ccode==276  /* SPD */ 
replace vote_sd =0 if vote_sd!=1 & ccode==276 & party<=12

replace vote_green =1 if party==5 & ccode==276  /* Green */ 
replace vote_green =0 if vote_green!=1 & ccode==276 & party<=12

replace vote_communist =1 if party==9 & ccode==276 /* PDS/Linke */ 
replace vote_communist =1 if party==7 & ccode==276 /* DKP */ 
replace vote_communist=0 if vote_communist!=1 & ccode==276 & party<=12

replace vote_otherleft =0 if  ccode==276

replace vote_liberal =1 if party==4 & ccode==276 /* FDP */ 
replace vote_liberal =0 if vote_liberal!=1 & ccode==276 & party<=12

replace vote_cd =1 if party==2 & ccode==276 /* CDU */ 
replace vote_cd =1 if party==3 & ccode==276 /* CSU */ 
replace vote_cd =0 if vote_cd!=1 & ccode==276 & party<=12

replace vote_cons =0 if ccode==276 & party<=12

replace vote_rpop =1 if party==10 & ccode==276 /* NPD */
replace vote_rpop =1 if party==8 & ccode==276 /* Republikaner*/
replace vote_rpop = 1 if party==12 & ccode == 276 /* Afd*/
replace vote_rpop =0 if vote_rpop!=1 & ccode == 276 & party<=14

replace vote_otherright =0 if vote_otherright!=1 & ccode ==276 & party<=14

replace vote_other = 1 if party==11 & ccode == 276 /* Pirate*/
replace vote_other = 1 if party==96 & ccode == 276 /* Other*/
replace vote_other =0 if vote_other!=1 & ccode == 276 & party<=14

*Ireland*

replace vote_sd=1 if party==3 & ccode==372  /* Labour */ 
replace vote_sd =0 if vote_sd!=1 & ccode==372 & party<=12

replace vote_green =1 if party==6 & ccode==372  /* Green */ 
replace vote_green =0 if vote_green!=1 & ccode==372 & party<=12

replace vote_communist =1 if party==4 & ccode==372 /* Workers */ 
replace vote_communist =1 if party==11 & ccode==372 /* Socialist */ 
replace vote_communist=0 if vote_communist!=1 & ccode==372 & party<=12

replace vote_otherleft =1 if party==8 & ccode==372 /* Demoratic Left */ 
replace vote_otherleft =1 if party==10 & ccode==372 /* PBP */ 
replace vote_otherleft =1 if party==11 & ccode==372 /* Socialist */ 
replace vote_otherleft =0 if vote_otherleft!=1 & ccode==372 & party<=12

replace vote_otherright=0 if ccode==372

replace vote_liberal =1 if party==5 & ccode==372 /* PD - Progressive Democrats */ 
replace vote_liberal =0 if vote_liberal!=1 & ccode==372 & party<=12

replace vote_cd =1 if party==2 & ccode==372 /* Fine Gael */ 
replace vote_cd =0 if vote_cd!=1 & ccode==372 & party<=12

replace vote_cons =1 if party==1 & ccode==372 /* Fianna Fail */ 
replace vote_cons =0 if vote_cons!=1 & ccode==372 & party<=12

replace vote_regional =1 if party==7 & ccode==372 /* Sinn Fein */
replace vote_regional =0 if vote_regional!=1 & ccode ==372 & party<=12

replace vote_rpop=0 if ccode==372

replace vote_other =1 if party==9 & ccode==372 /* Indep */ 
replace vote_other =0 if vote_other!=1 & ccode ==372 & party<=12

*Italy*
replace vote_green =1 if party==8 & ccode==380  /* Green Verdi */ 
replace vote_green =1 if party==22 & ccode==380  /* Feder. Verdi */ 
replace vote_green =0 if vote_green!=1 & ccode==380 & party<= 53

replace vote_communist =1 if party==14 & ccode==380 /* RC */ 
replace vote_communist =1 if party==26 & ccode==380 /* Other Communists */ 
replace vote_communist =1 if party==23 & ccode==380 /* Socialist International */ 
replace vote_communist =1 if party==45 & ccode==380 /* Fed Della Sinistra */ 
replace vote_communist =1 if party==46 & ccode==380 /* Sinistra and Liberta */ 
replace vote_communist=0 if vote_communist!=1 & ccode==380 & party<=53

replace vote_sd=1 if party==12 & ccode==380  /* PDS */ 
replace vote_sd=1 if party==21 & ccode==380  /* Prodi */ 
replace vote_sd=1 if party==37 & ccode==380  /* PD */ 
replace vote_sd =0 if vote_sd!=1 & ccode==380 & party<= 53


replace vote_otherleft =1 if party==7 & ccode==380 /* Partito Radicale */ 
replace vote_otherleft =1 if party==20 & ccode==380 /* Lista Dini */ 
replace vote_otherleft =0 if vote_otherleft!=1 & ccode==380 & party<= 53

replace vote_liberal =1 if party==19 & ccode==380 /* Lista Pannela */ 
replace vote_liberal =1 if party==34 & ccode==380 /* Italia dei Valori */ 
replace vote_liberal =1 if party==47 & ccode==380 /* API */ 
replace vote_liberal =0 if vote_liberal!=1 & ccode==380 & party<=53

replace vote_cd =1 if party==18 & ccode==380 /* CCD-CDU */ 
replace vote_cd =1 if party==27 & ccode==380 /* PPI */ 
replace vote_cd =1 if party==28 & ccode==380 /* Segni */ 
replace vote_cd =1 if party==29 & ccode==380 /* Movement for Aut */ 
replace vote_cd =1 if party==30 & ccode==380 /* UDR */ 
replace vote_cd =0 if vote_cd!=1 & ccode==380 & party<=52

replace vote_cons =1 if party==17 & ccode==380 /* Forza */ 
replace vote_cons =1 if party==44 & ccode==380 /* La Destra */ 
replace vote_cons =1 if party==48 & ccode==380 /* Futuro e Liberta */ 
replace vote_cons =0 if vote_cons!=1 & ccode==380 & party<=53

replace vote_regional =0 if vote_regional!=1 & ccode ==372 & party<=53

replace vote_rpop =1 if party==1 & ccode==380 /* MSI */ 
replace vote_rpop =1 if party==16 & ccode==380 /* AN */ 
replace vote_rpop =1 if party==15 & ccode==380 /* Tricolore */ 
replace vote_rpop =1 if party==11 & ccode==380 /* Lega */
replace vote_rpop =0 if vote_rpop!=1 & ccode==380 & party<=53

replace vote_otherright =0 if vote_otherright!=1 & ccode==380 & party<=53

replace vote_other=1 if party==40 & ccode==380 /* MS5 */ 
replace vote_other =0 if vote_other!=1 & ccode==380 & party<=53

*Japan*

replace vote_sd=1 if party==2 & ccode==392  /* SPD */ 
replace vote_sd=1 if party==9 & ccode==392 /* DPJ */ 
replace vote_sd =0 if vote_sd!=1 & ccode==392 & party<=16

replace vote_green =0 if ccode==392

replace vote_communist =1 if party==4 & ccode==392 /* JCP */ 
replace vote_communist=0 if vote_communist!=1 & ccode==392 & party<=16

replace vote_otherleft =1 if party==5 & ccode==392 /* DSP*/ 

replace vote_liberal =1 if party==13 & ccode==392 /* YP */ 
replace vote_liberal =0 if vote_liberal!=1 & ccode==392 & party<=16

replace vote_cons =1 if party==1 & ccode==392 /* LDP */ 
replace vote_cons =1 if party==3 & ccode==392 /* Komei */ 
replace vote_cons =1 if party==7 & ccode==392 /* NF */ 
replace vote_cons =1 if party==8 & ccode==392 /* New Party */ 
replace vote_cons =1 if party==10 & ccode==392 /* LP */ 
replace vote_cons =1 if party==12 & ccode==392 /* New Conservative */ 
replace vote_cons =1 if party==14 & ccode==392 /* Renewal */ 
replace vote_cons =0 if vote_cons!=1 & ccode==392 & party<=16

replace vote_cd =0 if vote_cd!=1 & ccode==392 & party<=16

replace vote_rpop =0 if ccode==392

replace vote_regional =0 if ccode==392

replace vote_other =1 if party==6 & ccode==392 /*United Social Democratic*/ 
replace vote_other =0 if vote_other!=1 & ccode==392 & party<=16

*Netherlands*
replace vote_sd=1 if party==1 & ccode==528  /* PvdA */ 
replace vote_sd =0 if vote_sd!=1 & ccode==528 & party<=18

replace vote_green =1 if party==8 & ccode==528  /* Green Left */ 
replace vote_green =0 if vote_green!=1 & ccode==528 & party<=18

replace vote_communist =1 if party==10 & ccode==528 /* Socialist */ 
replace vote_communist=0 if vote_communist!=1 & ccode==528 & party<=18

replace vote_otherleft =0 if vote_otherleft!=1 & ccode==528 & party<=18

replace vote_liberal =1 if party==2 & ccode==528 /*VVD*/ 
replace vote_liberal =1 if party==4 & ccode==528 /* D'66 */ 
replace vote_liberal =1 if party==16 & ccode==528 /*Liveable Netherlands*/ 
replace vote_liberal =0 if vote_liberal!=1 & ccode==528 & party<=18

replace vote_cons =1 if party==5 & ccode==528 /*SGP */ 
replace vote_cons =1 if party==6 & ccode==528 /*GPV */ 
replace vote_cons =1 if party==7 & ccode==528 /*RPF */ 
replace vote_cons =0 if vote_cons!=1 & ccode==528 & party<=18

replace vote_cd =1 if party==3 & ccode==528 /* CDA */ 
replace vote_cd =1 if party==15 & ccode==528 /* CU */ 
replace vote_cd =0 if vote_cd!=1 & ccode==528 & party<=18

replace vote_rpop =1 if party==13 & ccode==528 /* LPF */ 
replace vote_rpop =1 if party==14 & ccode==528 /* PVV */ 
replace vote_rpop =1 if party==18 & ccode==528 /* TON (Verdonk) */ 
replace vote_rpop =0 if vote_rpop!=1 & ccode==528 & party<=18

replace vote_regional =0 if ccode==528

replace vote_other =1 if party==11 & ccode==528 /* 55 Plus */ 
replace vote_other =1 if party==17 & ccode==528 /* Animals */ 
replace vote_other =1 if party==19 & ccode==528 /* Pirate */ 
replace vote_other =0 if vote_other!=1 & ccode==528 & party<=18

replace vote_otherright =1 if party==9 & ccode==528 & party<=18
replace vote_otherright =0 if vote_otherright!=1 & ccode==528 & party<=18

replace party=96 if party==11 & year==1994 & ccode==528 | party==11 & year==1998 & ccode==528


*New Zealand*
replace vote_sd=1 if party==2 & ccode==554  /* Labour */ 
replace vote_sd =0 if vote_sd!=1 & ccode==554 & party<=17

replace vote_green =1 if party==1 & ccode==554  /* Green */ 
replace vote_green =0 if vote_green!=1 & ccode==554 & party<=17

replace vote_communist =0 if ccode==554

replace vote_otherleft =1 if party==11 & ccode==554 /* Alliance */ 
replace vote_otherleft =1 if party==4 & ccode==554 /* New Labour */ 
replace vote_otherleft =1 if party==15 & ccode==554 /* Progresive */ 
replace vote_otherleft =0 if vote_otherleft!=1 & ccode==554 & party<=17

replace vote_liberal =1 if party==12 & ccode==554 /*ACT*/ 
replace vote_liberal =1 if party==8 & ccode==554 /*Liberal*/ 
replace vote_liberal =1 if party==10 & ccode==554 /*Demo*/ 
replace vote_liberal =1 if party==14 & ccode==554 /*United*/ 
replace vote_liberal =0 if vote_liberal!=1 & ccode==554 & party<=17

replace vote_cons =1 if party==3 & ccode==554 /*National*/ 
replace vote_cons =0 if vote_cons!=1 & ccode==554 & party<=17

replace vote_cd =1 if party==13 & ccode==554 /*CC*/ 
replace vote_cd =0 if vote_cd!=1 & ccode==554 & party<=17

replace vote_rpop =1 if party==9 & ccode==554 /*NZ FIrst*/ 
replace vote_rpop =0 if vote_rpop!=1 & ccode==554 & party<=17

replace vote_regional =0 if vote_regional!=1 & ccode==554 & party<=17

replace vote_other=1 if party==16 & ccode==554 /* Maori */ 
replace vote_other=1 if party==17 & ccode==554 /* Destiny */ 
replace vote_other =0 if vote_other!=1 & ccode==554 & party<=17

*Norway*
replace vote_sd=1 if party==6 & ccode==578  /* Labour */ 
replace vote_sd =0 if vote_sd!=1 & ccode==578 & party<=12

replace vote_green =1 if party==12 & ccode==578 /* Green */ 
replace vote_green =0 if vote_green!=1 & ccode==578 & party<=12

replace vote_communist =1 if party==7 & ccode==578 /* SV */ 
replace vote_communist =1 if party==10 & ccode==578 /* RV - Red Electoral Alliance */ 
replace vote_communist =0 if vote_communist!=1 & ccode==578 & party<=12

replace vote_liberal =1 if party==5 & ccode==578 /*Liberal*/ 
replace vote_liberal =0 if vote_liberal!=1 & ccode==578 & party<=12


replace vote_cons =1 if party==2 & ccode==578 /*Conservative (H)*/ 
replace vote_cons =0 if vote_cons!=1 & ccode==578 & party<=12


replace vote_cd =1 if party==4 & ccode==578 /* KRF*/ 
replace vote_cd =0 if vote_cd!=1 & ccode==578 & party<=12

replace vote_rpop =1 if party==1 & ccode==578 /* Progress*/ 
replace vote_rpop =0 if vote_rpop!=1 & ccode==578 & party<=12

replace vote_otherleft =0 if ccode==578 & party<=12
replace vote_otherright =0 if ccode==578 & party<=12

replace vote_other =1 if party==3 & ccode==578 /* Centre*/ 
replace vote_other =0 if vote_other!=1 & ccode==578 & party<=12

*Portugal*
replace vote_sd=1 if party==5 & ccode==620  /* PS */ 
replace vote_sd =0 if vote_sd!=1 & ccode==620 & party<=14

replace vote_green =1 if  ccode==620 & party==10
replace vote_green =0 if vote_green!=1 & ccode==620 & party<=14

replace vote_communist =1 if party==2 & ccode==620 /* PCP */ 
replace vote_communist =1 if party==8 & ccode==620 /* BE */ 
replace vote_communist =1 if party==9 & ccode==620 /* CDU PCP PEV */ 
replace vote_communist =1 if party==6 & ccode==620 /* PSR*/ 
replace vote_communist =1 if party==3 & ccode==620 /* MRPP*/ 
replace vote_communist =1 if party==7 & ccode==620 /* UDP*/ 
replace vote_communist =0 if vote_communist!=1 & ccode==620 & party<=14

replace vote_liberal =1 if party==4 & ccode==620 /*PSD */ 
replace vote_liberal =1 if party==13 & ccode==620 /*PSD */ 
replace vote_liberal =0 if vote_liberal!=1 & ccode==620 & party<=14


replace vote_cd =1 if party==1 & ccode==620 /* CDS*/ 
replace vote_cd =0 if vote_cd!=1 & ccode==620 & party<=14

replace vote_rpop =1 if party==14 & ccode==620 & party<=14
replace vote_rpop =0 if vote_rpop!=1 & ccode==620 & party<=14

replace vote_otherleft =0 if ccode==620 & party<=14
replace vote_otherright=0 if ccode==620 & party<=14

replace vote_other =1 if party==12 & ccode==620 & party<=14
replace vote_other =0 if vote_other!=1 & ccode==620 & party<=14

*Spain* 
replace vote_sd=1 if party==3 & ccode== 724  /* PSOE */ 
replace vote_sd =0 if vote_sd!=1 & ccode== 724 & party<=15

replace vote_green =1 if party==8 & ccode== 724  /* Equio */ 
replace vote_green =0 if vote_green!=1 & ccode== 724 & party<=15

replace vote_communist =1 if party==4 & ccode== 724 /* IU */ 
replace vote_communist =0 if vote_communist!=1 & ccode== 724 & party<=15

replace vote_otherleft =1 if party==6 & ccode== 724  /* Left nationalist */ 
replace vote_otherleft =1 if party==12 & ccode== 724  /* Other Left */ 
replace vote_otherleft =1 if party==15 & ccode== 724  /* Podemos */ 
replace vote_otherleft =0 if vote_otherleft!=1 & ccode== 724 & party<=15


replace vote_liberal =0 if ccode== 724 & party<=15

replace vote_cons =1 if party==1 & ccode== 724 /* PP */ 
replace vote_cons =0 if vote_cons!=1 & ccode== 724 & party<=15

replace vote_cd =1 if party==2 & ccode== 724 /* CDS*/ 
replace vote_cd =0 if vote_cd!=1 & ccode== 724 & party<=15

replace vote_otherright =1 if ccode==724 & party==5 /*Right Nationalists*/

replace vote_regional =1 if party==5 & ccode== 724 /* Right nationalist*/ 
replace vote_regional =1 if party==6 & ccode== 724 /* Left nationalist*/ 
replace vote_regional =11 if party==6 & ccode== 724 /* Other Regional*/ 
replace vote_regional =0 if vote_regional!=1 & ccode== 724 & party<=15

replace vote_rpop =0 if vote_rpop!=1 & ccode== 724 & party<=15

replace vote_other =0 if vote_other!=1 & ccode== 724 & party<=15

*Sweden*

replace vote_sd=1 if party==6 & ccode==752  /* SAP */ 
replace vote_sd =0 if vote_sd!=1 & ccode==752 & party<=12

replace vote_green =1 if party==4 & ccode==752  /* MP */ 
replace vote_green =0 if vote_green!=1 & ccode==752 & party<=12

replace vote_communist =1 if party==7 & ccode==752 /* VP */ 
replace vote_communist =0 if vote_communist!=1 & ccode==752 & party<=12

replace vote_otherleft =0 if ccode==752 & party<=12

replace vote_liberal =1 if party==2 & ccode==752 /* FP */ 
replace vote_liberal =0 if vote_liberal!=1 & ccode==752 & party<=12

replace vote_cons =1 if party==5 & ccode==752 /* Moderate */ 
replace vote_cons =0 if vote_cons!=1 & ccode==752 & party<=12

replace vote_cd =1 if party==3 & ccode==752 /* KDS*/ 
replace vote_cd =0 if vote_cd!=1 & ccode==752 & party<=12

replace vote_rpop =1 if party==8 & ccode==752 /* Sweden Democrat*/ 
replace vote_rpop =1 if party==12 & ccode==752 /* New Democrat*/ 
replace vote_rpop =0 if vote_rpop!=1 & ccode==752 & party<=12

replace vote_otherright=1 if party==1 & ccode==752
replace vote_otherright =0 if vote_otherright!=1 & ccode==752 & party<=12

replace vote_regional=0 if ccode==752

replace vote_other=1 if party==1 & ccode==752
replace vote_other=1 if party==9 & ccode==752
replace vote_other=1 if party==10 & ccode==752
replace vote_other =0 if vote_other!=1 & ccode==752 & party<=12

*Switzerland*
replace vote_sd=1 if party==3 & ccode==756  /* SD */ 
replace vote_sd =0 if vote_sd!=1 & ccode==756 & party<=20

replace vote_green =1 if party==10 & ccode==756  /* GPS */ 
replace vote_green =1 if party==19 & ccode==756  /* Fem */ 
replace vote_green =1 if party==20 & ccode==756  /* Green Liberal */ 
replace vote_green =0 if vote_green!=1 & ccode==756 & party<=20

replace vote_communist =1 if party==8 & ccode==756 /* PDA */ 
replace vote_communist =1 if party==9 & ccode==756 /* POCH */ 
replace vote_communist =0 if vote_communist!=1 & ccode==756 & party<=20

replace vote_otherleft =1 if party==5 & ccode==756 & party<=20 /*LDU*/
replace vote_otherleft =0 if vote_otherleft!=1 & ccode==756 & party<=20

replace vote_liberal =1 if party==1 & ccode==756 /* FDP/PRD */ 
replace vote_liberal =1 if party==6 & ccode==756 /* Lib/Con */ 
replace vote_liberal =0 if vote_liberal!=1 & ccode==756 & party<=20

replace vote_cons =1 if party==17 & ccode==756 /* FDU */ 
replace vote_cons =1 if party==18 & ccode==756 /* BDP */ 
replace vote_cons =0 if vote_cons!=1 & ccode==756 & party<=20

replace vote_cd =1 if party==2 & ccode==756 /* CVP*/ 
replace vote_cd =1 if party==7 & ccode==756 /* EVP*/ 
replace vote_cd =1 if party==6 & ccode==756 /* LPS*/ 
replace vote_cd =1 if party==12 & ccode==756 /* CPS*/ 
replace vote_cd =0 if vote_cd!=1 & ccode==756 & party<=20

replace vote_rpop =1 if party==15 & ccode==756 /* Swiss Democrat*/ 
replace vote_rpop =1 if party==4 & ccode==756 /* SVP*/ 
replace vote_rpop =1 if party==13 & ccode==756 /* FPS*/ 
replace vote_rpop =1 if party==11 & ccode==756 /* FDU*/ 
replace vote_rpop =1 if party==16 & ccode==756 /* Lega*/ 
replace vote_rpop =0 if vote_rpop!=1 & ccode==756 & party<=20

replace vote_regional =0 if vote_regional!=1 & ccode==756 & party<=20

replace vote_otherright =1 if party==18 & ccode==756 /* Conservative Democrat*/ 
replace vote_otherright =0 if vote_otherright!=1 & ccode==756 & party<=20

replace vote_other =1 if party==14 & ccode==756 /* */ 

*UK*
replace vote_sd=1 if party==2 & ccode==826  /* Labour */ 
replace vote_sd =0 if vote_sd!=1 & ccode==826 & party<=6

replace vote_green =1 if party==6 & ccode==826  /* Green */ 
replace vote_green =0 if vote_green!=1 & ccode==826 & party<=6

replace vote_communist=0 if ccode==826

replace vote_otherleft =0 if ccode==826 & party<=6

replace vote_liberal =1 if party==3 & ccode==826 & party<=6
replace vote_liberal =0 if vote_liberal!=1 & ccode==826 & party<=6

replace vote_cons =1 if party==1 & ccode==826 /* Conservative */ 
replace vote_cons =0 if vote_cons!=1 & ccode==826 & party<=6

replace vote_cd =0 if ccode==826 & party<=6

replace vote_rpop =1 if party==8 & ccode==826 /* BNP*/ 
replace vote_rpop =1 if party==9 & ccode==826 /* UKIP*/ 
replace vote_rpop =1 if party==	78 & ccode==826 /* National Front*/ 


replace vote_rpop =0 if vote_rpop!=1 & ccode==826 & party<=9

replace vote_otherright=0 if ccode==826

replace vote_regional =1 if party==4 & ccode==826 /* SNP*/ 
replace vote_regional =1 if party==5 & ccode==826 /* PC*/ 
replace vote_regional =0 if vote_regional!=1 & ccode==826 & party<=6

replace vote_other=1 if ccode==826 & party==10
replace vote_other=0 if ccode==826 & vote_other!=1

*USA*

*Recodes the US, which distinguishes identifiers by strength*
recode party 1=2 2=2 3=2 4=96 5=6 6=6 7=6 if ccode==840 & party_type==2
recode party 1=2 2=2 3=2 4=96 5=6 6=6 7=6 if ccode==840 & party_type==1
recode party 1=2 2=2 3=2 4=96 5=6 6=6 7=6 if ccode==840 & year==1999
recode party  4=96 3=96 0=97 if ccode==840 & party_type==3
recode party  95=96 if ccode==840 

replace vote_sd=1 if party==2 & ccode==840  /* Democrats */ 
replace vote_sd =0 if vote_sd!=1 & ccode==840 & party<=7

replace vote_cons =1 if party==6 & ccode==840 /* Republicans */ 
replace vote_cons =0 if vote_cons!=1 & ccode==840 & party<=7

replace vote_rpop=0 if ccode==840


*This codes the other, don't know, and missing
foreach var of varlist vote_*{
replace `var'=. if party==99
replace `var'=0 if party==96
replace `var'=0 if party==97
replace `var'=. if party==.

gen `var'2=`var'
replace `var'2=0 if party==99
replace `var'2=0 if party==96
replace `var'2=0 if party==97
}

*Creates combined party family variable*
gen party_fam=.
replace party_fam=1 if vote_communist==1
replace party_fam=2 if vote_otherleft==1
replace party_fam=3 if vote_sd==1
replace party_fam=4 if vote_green==1
replace party_fam=5 if vote_cd==1
replace party_fam=6 if vote_liberal==1
replace party_fam=7 if vote_cons==1
replace party_fam=8 if vote_rpop==1
replace party_fam=7 if vote_otherright==1
replace party_fam=10 if vote_regional==1
replace party_fam=11 if vote_other==1
replace party_fam=12 if party==97

lab def party_fam ///
1 "Communist" ///		
2 "Left" ///		
3 "Main SD" ///		
4 "Green" ///		
5 "Christian" ///		
6 "Liberal" ///		
7 "Conservative" ///		
8 "Right" ///		
10	"Regional" ///		
11	"Other/Not Available" ///	
12	"Non-Voter"
lab val party_fam party_family
lab var party_fam "Party Family"
tab party_fam

*This defines the more limited party family*
gen pf2=1 if party_fam==1 | party_fam==2 | party_fam==4 /*Other Left*/
replace pf2=2 if party_fam==3 /*Social Democrats*/
replace pf2=3 if party_fam==5 | party_fam==6 | party_fam==7 /*Mainstream Right*/
replace pf2=4 if party_fam==8 /*Right Populist*/
replace pf2=5 if party_fam==10  |  party_fam==11 /*Regional, Other*/
replace pf2=6 if party_fam==12 /*Non Voters*/


*This excludes regional and non-classifiable parties:
* Bloc Quebecois (Canada)
* Swedish People’s Party (Finland)
* Scottish National Party 
* Plaid Cymru (UK)
* Sinn Fein (Ireland)
* Non easily classifiable, Pirate, Senior Party
*  "Independent" (USA)

gen pf3=pf2 
recode pf3 5=. 6=5 

*Takes out small parties with fewer than 15 voters*/
replace pf3=. if party==5 & ccode==36 /*Democratic Labour - Australia*/
replace pf3=. if party==23 & ccode==56 /*Vivant - Belgium*/
replace pf3=. if party==8 & ccode==124/* Communist - Canada  */
replace pf3=. if party==7 & ccode==276 /* DKP - Germany*/
replace pf3=. if party==23 & ccode==380 /* Soc -Italy */
replace pf3=. if party==29 & ccode==380 /* AUto -Italy*/
replace pf3=. if party==28 & ccode==380 /* Segni -Italy*/
replace pf3=. if party==30 & ccode==380 /* UDR -Italy*/
replace pf3=. if party==44 & ccode==380 /* Destra -Italy*/
replace pf3=. if party==47 & ccode==380 /* API -Italy*/
replace pf3=. if party==48 & ccode==380 /* Futuro -Italy*/
replace pf3=. if party==12 & ccode==392 /* New Conservative - Japan*/
replace pf3=. if party==16 & ccode==528/* Liveable -Netherlands*/
replace pf3=. if party==15 & ccode==554 /* Jim Anderton - NZ*/
replace pf3=. if party==3 & ccode==620 /* MRPP - Portugal*/
replace pf3=. if party==14 & ccode==620 /* PNR - Portugal*/
replace pf3=. if party==7 & ccode==620 /* UDP - Portugal*/
replace pf3=. if party==10 & ccode==620 /* Movim - Portugal*/
replace pf3=. if party==8  & ccode==724 /* Equo - Portugal*/
replace pf3=. if party==15 & ccode==724  /* Podemos - Portugal*/

* Overall, 6069 voters in sample with occupational data are excluded, 3.3% of the total
* Note, using pf2, all models can be re-estimated including these parties, which does not change the substantive results 


*Recodes large nationalist/agrarian parties with an identifiable left-right stance */
replace pf3=1 if party==6 & ccode==724 /*Left-leaning nationalists in Spain as left parties*/
replace pf3=3 if party==5 & ccode==724 /*Right-leaning nationalists in Spain as center-right parties*/
replace pf3=4 if party==4 & ccode==56 /* Belgian NVA as a right populist party*/
replace pf3=3 if party==3 & ccode==578 /* Norwegian Center Party as a center-right party */
replace pf3=3 if party==1 & ccode==752 /* Swedish Center Party as a center-right party */

*Labels*/
lab def pf3 ///
1 "Other Left" ///		
2 "Mainstream Left" ///		
3 "Mainstream Right" ///		
4 "Right Populist" ///		
5 "Non Voters" 
lab val pf3 pf3
lab var pf3 "Party Family"
tab pf3
*Creates a variable to limit the sample to those with right populists*
bysort ccode cycle: egen m_right_pop=mean(vote_rpop)
gen no_rpop=1 if m_right_pop==0
drop if m_right_pop==.
gen vote_rpopX=vote_rpop
replace vote_rpopX=. if m_right_pop==0
}



if `merging'==1 {
*Combines the Contextual Data*
merge m:1 ccode year using "RP_Context_Data.dta", generate(_mergeQ) force
drop if _mergeQ==2

drop _merge*

*This defines the electoral system* 
replace  prop=0 if ccode==36
replace  prop=1 if ccode==40
replace  prop=1 if ccode==56
replace  prop=0 if ccode==124
replace  prop=1 if ccode==208
replace  prop=1 if ccode==246
replace  prop=1 if ccode==276
replace  prop=1 if ccode==250
replace  prop=1 if ccode==372
replace  prop=0 if ccode==380 & prop==. /*Italy*/
replace  prop=1 if ccode==380 & prop==2 /*Italy*/
replace  prop=0 if ccode==392
replace  prop=1 if ccode==528
replace  prop=0 if ccode==554 & year<=1996 /*NZ*/
replace  prop=1 if ccode==554 & prop==2 /*NZ*/
replace  prop=1 if ccode==554 & prop==. /*NZ*/
replace  prop=1 if ccode==578
replace  prop=1 if ccode==620
replace  prop=1 if ccode==724
replace  prop=1 if ccode==752
replace  prop=1 if ccode==756
replace  prop=0 if ccode==826
replace  prop=0 if ccode==840


*This combines the several measures of unemployment to provide a longer time-series*
replace unemployment_rate=unem_rate_total if unemployment_rate==.

*This rescales the spending variable to run 0-1
replace prog_gdp9002=prog_gdp9002/100
replace m_prog_gdp9002=m_prog_gdp9002/100


save "ISSP_Combined.dta", replace

}
