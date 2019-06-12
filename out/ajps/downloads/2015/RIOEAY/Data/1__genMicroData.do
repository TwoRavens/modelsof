/* 
Step 1 of 6
Combines 4 ESS data sets and executes some
basic recodes (incl. income calculations).
*/

* Requires (from SSC): dropmiss

* ESS original source files:
* Downloaded from 
* ess1e06.dta (ESS 1)
* ESS1csFR.dta (file for income in France)
* ESS1csIE.dta (file for income in Ireland)
* ess2e03.dta (ESS 2)
* ESS2csFR.dta (file for income in France)
* ess3e03.dta (ESS 3)
* ess4e02.dta (ESS 4)



* Note: turn on word-wrap in your text editor




set more off

* =========
* = ESS 1 =
* =========
use "original_ESS_files/ess1e06.dta", clear
keep if cntry=="AT"|cntry=="BE"|cntry=="CH"|cntry=="DE"|cntry=="DK"|cntry=="ES"|cntry=="FI"| cntry=="FR"|cntry=="GB"|cntry=="IE"|cntry=="NL"|cntry=="NO"| cntry=="SE"|cntry=="PT"

merge 1:1 cntry idno using "original_ESS_files/ESS1csFR.dta", keepusing(hinctnfr wrkctfr rlgdnmfr)
replace hinctnt = hinctnfr if cntry == "FR"
replace rlgdnm = rlgdnmfr if cntry == "FR"
recode wrkctfr (3 4 = 2) (5=6)
replace wrkctr = wrkctfr if cntry == "FR"
drop _merge

merge 1:1 cntry idno using "original_ESS_files/ESS1csIE.dta", keepusing(hinctnie)
replace hinctnt = hinctnie if cntry == "IE"

recode hincsrc (77/99=.)

keep essround idno cntry lrscale gincdif happy ctzcntr brncntr hhmmb yrbrn gndr domicil edulvl eduyrs emplrel emplno jbspv njbspv mnactic wrkctr  iscoco nacer1 hinctnt hincfel uemp3m edulvlf emprf14 emplnof jbspvf edulvlm emprm14 emplnom jbspvm occm14ie regionat regionbe regionch regionde regiondk regiones regionfi regionfr regiongb regionie  regionnl regionno regionpt regionse dweight pweight dvrcdev chldhm stflife health aesfdrk ipeqopt crmvct rlgdnm rlgatnd hincsrc

gen year = 2002

save ess1, replace


* =========
* = ESS 2 =
* =========
use "original_ESS_files/ess2e03.dta", clear
keep if cntry=="AT"|cntry=="BE"|cntry=="CH"|cntry=="DE"|cntry=="DK"|cntry=="ES"|cntry=="FI"| cntry=="FR"|cntry=="GB"|cntry=="IE"|cntry=="NL"|cntry=="NO"| cntry=="SE"|cntry=="PT"

merge 1:1 cntry idno using "original_ESS_files/ESS2csFI.dta", keepusing(rlgdnmfi)
drop _merge
merge 1:1 cntry idno using "original_ESS_files/ESS2csFR.dta", keepusing(wrkctfr rlgdnmfr)
drop _merge
recode wrkctfr (3 4 = 2) (5=6)
replace wrkctra = wrkctfr if cntry == "FR"
replace rlgdnm = rlgdnmfr if cntry == "FR"
replace rlgdnm = rlgdnmfi if cntry == "FI"

recode hincsrca (1=1) (2 3 =2) (4=3) (5=4) (6=5) (7=6) (8=7) (77/99=.), gen(hincsrc)

ren nacer11 nacer1 
keep essround idno cntry lrscale gincdif happy ctzcntr brncntr hhmmb yrbrn gndr domicil edulvl eduyrs emplrel emplno jbspv njbspv mnactic wrkctr  iscoco nacer1 hinctnt hincfel uemp3m edulvlf emprf14 emplnof jbspvf edulvlm emprm14 emplnom jbspvm regionat regionbe regioach regionde regiondk regiones regioafi regionfr regiongb regionie regionnl regionno regionpt regionse dweight pweight dvrcdev chldhm stflife health aesfdrk ipeqopt crmvct rlgdnm rlgatnd hincsrc

gen year = 2004

save ess2, replace


* =========
* = ESS 3 =
* =========
use "original_ESS_files/ess3e03.dta", clear
keep if cntry=="AT"|cntry=="BE"|cntry=="CH"|cntry=="DE"|cntry=="DK"|cntry=="ES"|cntry=="FI"| cntry=="FR"|cntry=="GB"|cntry=="IE"|cntry=="NL"|cntry=="NO"| cntry=="SE"|cntry=="PT"

ren nacer11 nacer1 

recode hincsrca (1=1) (2 3 =2) (4=3) (5=4) (6=5) (7=6) (8=7) (77/99=.), gen(hincsrc)

keep essround idno cntry lrscale gincdif happy ctzcntr brncntr hhmmb yrbrn gndr domicil edulvl eduyrs emplrel emplno jbspv njbspv mnactic wrkctr  iscoco nacer1 hinctnt hincfel uemp3m edulvlf emprf14 emplnof jbspvf edulvlm emprm14 emplnom jbspvm regionat regionbe regioach regionde regiondk regioaes regioafi regionfr regiongb regioaie regionnl regionno regionpt regionse dweight pweight dvrcdev chldhm stflife health aesfdrk ipeqopt crmvct rlgdnm rlgatnd hincsrc

gen year = 2006

save ess3, replace


* =========
* = ESS 4 =
* =========
use "original_ESS_files/ess4e02.dta", clear
keep if cntry=="AT"|cntry=="BE"|cntry=="CH"|cntry=="DE"|cntry=="DK"|cntry=="ES"|cntry=="FI"| cntry=="FR"|cntry=="GB"|cntry=="IE"|cntry=="NL"|cntry=="NO"| cntry=="SE"|cntry=="PT"

ren nacer11 nacer1 

recode hincsrca (1=1) (2 3 =2) (4=3) (5=4) (6=5) (7=6) (8=7) (77/99=.), gen(hincsrc)

keep essround idno cntry lrscale gincdif happy ctzcntr brncntr hhmmb yrbrn gndr domicil edulvl eduyrs emplrel emplno jbspv njbspv mnactic wrkctr  iscoco nacer1 hinctnt hincfel uemp3m edulvlf emprf14 emplnof jbspvf edulvlm emprm14 emplnom jbspvm regionbe regioach regionde regioadk regioaes regioafi regionfr regiongb regionnl regionno regioapt regionse dweight pweight dvrcdev chldhm  stflife health aesfdrk ipeqopt crmvct rlgdnm rlgatnd hincsrc

gen year = 2008

save ess4, replace






* =================================================
* = .............merge .......................... =
* =================================================
 /* note that region is not harmonized here! */

use ess1, clear
append using ess2 ess3 ess4



* ========================================================
* =  ...........recodes................................. =
* ========================================================

* gen country-years
gen str cntryyear= "------"
foreach v in AT BE CH DE DK ES FI FR GB IE NL NO PT SE {
  replace cntryyear = `"`v'1"' if cntry=="`v'" & essround==1
  replace cntryyear = `"`v'2"' if cntry=="`v'" & essround==2
  replace cntryyear = `"`v'3"' if cntry=="`v'" & essround==3
  replace cntryyear = `"`v'4"' if cntry=="`v'" & essround==4
  replace cntryyear = `"`v'5"' if cntry=="`v'" & essround==5
}



* ===================
* =       Age       =
* ===================

recode yrbrn (7777/9999=.)
gen age = 999999
replace age =  year - yrbrn

* =====================
* =     gender        =
* =====================
recode gndr (1=0)(2=1)(9=.),gen(female)

* ====================
* =    education     =
* ====================
recode eduyrs (77/99=.)

* ======================
* = income differences =
* ======================
recode gincdif (1=5) (2=4) (3=3) (4=2) (5=1) (7 8 9=.),gen(rincd)

* ============================
* =     Limited contract     =
* ============================
gen lmtctr = 0
replace lmtctr = 1 if wrkctr == 2 & essround == 1
replace lmtctr = 1 if wrkctra == 2 & (essround == 2 | essround == 3| essround == 4| essround == 5)
replace lmtctr = 1 if wrkctra == 3 & (essround == 2 | essround == 3| essround == 4| essround == 5)


* ===========================
* =   Transfer classes      =
* ===========================
*Transfer class : coding Gelissen
// 1 working  2 unempl  3 retired/disabled  4 Not in LF
recode mnactic (1 = 1) (3 4 =2) (5 6 =3)  (2 7 8 9=4) (77 88 99= .),gen(transfer)


* =================================
* =    unemployment experience    =
* =================================
 recode uemp3m (1=1) (2=0) (7 8 9 = .), gen(uempl3)


* =================================
* =           crime               =
* =================================

/* fear */
recode aesfdrk (7 8 9 = .), gen(fear)

/* victim */
recode crmvct (1=1) (2=0) (7 8 9=.), gen(victim)

* =================================
* =      inequity / altriusm   
* =================================
recode ipeqopt (7 8 9 =.)
vreverse ipeqopt, gen(equalop)
recode equalop (1 2=1) (3=2) (4=3) (5=4) (6=5)



/*===============================\
| Income: in 2005 PPP US Dollars |
\===============================*/

* ESS 1-3
generate income=.
replace income=900 if hinctnt==1 // range Less than 1800, mid-point 900
replace income=2700 if hinctnt==2 // range 1800 to under 3600, mid-point 2700
replace income=4800 if hinctnt==3 // range 3600 to under 6000, mid-point 4800
replace income=9000 if hinctnt==4 // range 6000 to under 12000, mid-point 9000
replace income=15000 if hinctnt==5 // range 12000 to under 18000, mid-point 15000
replace income=21000 if hinctnt==6 // range 18000 to under 24000, mid-point 21000
replace income=27000 if hinctnt==7 // range 24000 to under 30000, mid-point 27000
replace income=33000 if hinctnt==8 // range 30000 to under 36000, mid-point 33000
replace income=48000 if hinctnt==9 // range 36000 to under 60000, mid-point 48000
replace income=75000 if hinctnt==10 // range 60000 to under 90000, mid-point 75000
replace income=105000 if hinctnt==11 // range 90000 to under 120000, mid-point 105000

* ESS 4
replace income=2500 if hinctnta==1&cntry=="BE"&essround==4 // range less than 5000mid-point 2500
replace income=7500 if hinctnta==2&cntry=="BE"&essround==4 // range 5000 to under 10000 mid-point 7500
replace income=11000 if hinctnta==3&cntry=="BE"&essround==4 // range 10000 to under 12000 mid-point 11000
replace income=13000 if hinctnta==4&cntry=="BE"&essround==4 // range 12000 to under 14000 mid-point 13000
replace income=15000 if hinctnta==5&cntry=="BE"&essround==4 // range 14000 to under 16000 mid-point 15000
replace income=17000 if hinctnta==6&cntry=="BE"&essround==4 // range 16000 to under 18000 mid-point 17000
replace income=19500 if hinctnta==7&cntry=="BE"&essround==4 // range 18000 to under 21000 mid-point 19500
replace income=23500 if hinctnta==8&cntry=="BE"&essround==4 // range 21000 to under 26000 mid-point 23500
replace income=30500 if hinctnta==9&cntry=="BE"&essround==4 // range 26000 to under 35000 mid-point 30500
replace income=55000	 if hinctnta==1&cntry=="DK"&essround==4  //	range	0	to	under	110000	mid-point	55000
replace income=129000 if hinctnta==2&cntry=="DK"&essround==4  //	range	110000	to	under	148000	mid-point	129000
replace income=167000 if hinctnta==3&cntry=="DK"&essround==4  //	range	148000	to	under	186000	mid-point	167000
replace income=206000 if hinctnta==4&cntry=="DK"&essround==4  //	range	186000	to	under	226000	mid-point	206000
replace income=251500 if hinctnta==5&cntry=="DK"&essround==4  //	range	226000	to	under	277000	mid-point	251500
replace income=307500 if hinctnta==6&cntry=="DK"&essround==4  //	range	277000	to	under	338000	mid-point	307500
replace income=365500 if hinctnta==7&cntry=="DK"&essround==4  //	range	338000	to	under	393000	mid-point	365500
replace income=421500 if hinctnta==8&cntry=="DK"&essround==4  //	range	393000	to	under	450000	mid-point	421500
replace income=492000 if hinctnta==9&cntry=="DK"&essround==4  //	range	450000	to	under	534000	mid-point	492000
replace income=5400 if hinctnta==1&cntry=="FI"&essround==4 // range less than 10800mid-point 5400
replace income=12600 if hinctnta==2&cntry=="FI"&essround==4 // range 10800 to under 14400 mid-point 12600
replace income=16200 if hinctnta==3&cntry=="FI"&essround==4 // range 14400 to under 18000 mid-point 16200
replace income=19800 if hinctnta==4&cntry=="FI"&essround==4 // range 18000 to under 21600 mid-point 19800
replace income=24000 if hinctnta==5&cntry=="FI"&essround==4 // range 21600 to under 26400 mid-point 24000
replace income=28800 if hinctnta==6&cntry=="FI"&essround==4 // range 26400 to under 31200 mid-point 28800
replace income=34200 if hinctnta==7&cntry=="FI"&essround==4 // range 31200 to under 37200 mid-point 34200
replace income=40800 if hinctnta==8&cntry=="FI"&essround==4 // range 37200 to under 44400 mid-point 40800
replace income=49800 if hinctnta==9&cntry=="FI"&essround==4 // range 44400 to under 55200 mid-point 49800
replace income=5700 if hinctnta==1&cntry=="FR"&essround==4 // range less than 11400mid-point 5700
replace income=12900 if hinctnta==2&cntry=="FR"&essround==4 // range 11400 to under 14400 mid-point 12900
replace income=16200 if hinctnta==3&cntry=="FR"&essround==4 // range 14400 to under 18000 mid-point 16200
replace income=19500 if hinctnta==4&cntry=="FR"&essround==4 // range 18000 to under 21000 mid-point 19500
replace income=22500 if hinctnta==5&cntry=="FR"&essround==4 // range 21000 to under 24000 mid-point 22500
replace income=26400 if hinctnta==6&cntry=="FR"&essround==4 // range 24000 to under 28800 mid-point 26400
replace income=31200 if hinctnta==7&cntry=="FR"&essround==4 // range 28800 to under 33600 mid-point 31200
replace income=36600 if hinctnta==8&cntry=="FR"&essround==4 // range 33600 to under 39600 mid-point 36600
replace income=44400 if hinctnta==9&cntry=="FR"&essround==4 // range 39600 to under 49200 mid-point 44400
replace income=6600 if hinctnta==1&cntry=="DE"&essround==4 // range less than 13200mid-point 6600
replace income=15350 if hinctnta==2&cntry=="DE"&essround==4 // range 13200 to under 17500 mid-point 15350
replace income=19800 if hinctnta==3&cntry=="DE"&essround==4 // range 17500 to under 22100 mid-point 19800
replace income=24550 if hinctnta==4&cntry=="DE"&essround==4 // range 22100 to under 27000 mid-point 24550
replace income=29750 if hinctnta==5&cntry=="DE"&essround==4 // range 27000 to under 32500 mid-point 29750
replace income=35400 if hinctnta==6&cntry=="DE"&essround==4 // range 32500 to under 38300 mid-point 35400
replace income=41750 if hinctnta==7&cntry=="DE"&essround==4 // range 38300 to under 45200 mid-point 41750
replace income=49900 if hinctnta==8&cntry=="DE"&essround==4 // range 45200 to under 54600 mid-point 49900
replace income=62500 if hinctnta==9&cntry=="DE"&essround==4 // range 54600 to under 70400 mid-point 62500
replace income=62500	 if hinctnta==1&cntry=="NO"&essround==4	//	range	0	to	under	125000	mid-point	62500
replace income=147500 if hinctnta==2&cntry=="NO"&essround==4	//	range	 125000	to	under 170000 mid-point	147500
replace income=195000 if hinctnta==3&cntry=="NO"&essround==4	//	range	 170000	to	under 220000 mid-point	195000
replace income=245000 if hinctnta==4&cntry=="NO"&essround==4	//	range	 220000	to	under 270000 mid-point	245000
replace income=297500 if hinctnta==5&cntry=="NO"&essround==4	//	range	 270000	to	under 325000 mid-point	297500
replace income=362500 if hinctnta==6&cntry=="NO"&essround==4	//	range	 325000	to	under 400000 mid-point	362500
replace income=437500 if hinctnta==7&cntry=="NO"&essround==4	//	range	 400000	to	under 475000 mid-point	437500
replace income=512500 if hinctnta==8&cntry=="NO"&essround==4	//	range	 475000	to	under 550000 mid-point	512500
replace income=610000 if hinctnta==9&cntry=="NO"&essround==4	//	range	 550000	to	under 670000 mid-point	610000
replace income=2500 if hinctnta==1&cntry=="PT"&essround==4 // range less than 5000mid-point 2500
replace income=6000 if hinctnta==2&cntry=="PT"&essround==4 // range 5000 to under 7000 mid-point 6000
replace income=8000 if hinctnta==3&cntry=="PT"&essround==4 // range 7000 to under 9000 mid-point 8000
replace income=10000 if hinctnta==4&cntry=="PT"&essround==4 // range 9000 to under 11000 mid-point 10000
replace income=12400 if hinctnta==5&cntry=="PT"&essround==4 // range 11000 to under 13800 mid-point 12400
replace income=14900 if hinctnta==6&cntry=="PT"&essround==4 // range 13800 to under 16000 mid-point 14900
replace income=17750 if hinctnta==7&cntry=="PT"&essround==4 // range 16000 to under 19500 mid-point 17750
replace income=22000 if hinctnta==8&cntry=="PT"&essround==4 // range 19500 to under 24500 mid-point 22000
replace income=29750 if hinctnta==9&cntry=="PT"&essround==4 // range 24500 to under 35000 mid-point 29750
replace income=4000 if hinctnta==1&cntry=="ES"&essround==4 // range less than 8000mid-point 4000
replace income=9500 if hinctnta==2&cntry=="ES"&essround==4 // range 8000 to under 11000 mid-point 9500
replace income=12500 if hinctnta==3&cntry=="ES"&essround==4 // range 11000 to under 14000 mid-point 12500
replace income=15500 if hinctnta==4&cntry=="ES"&essround==4 // range 14000 to under 17000 mid-point 15500
replace income=18500 if hinctnta==5&cntry=="ES"&essround==4 // range 17000 to under 20000 mid-point 18500
replace income=21500 if hinctnta==6&cntry=="ES"&essround==4 // range 20000 to under 23000 mid-point 21500
replace income=25000 if hinctnta==7&cntry=="ES"&essround==4 // range 23000 to under 27000 mid-point 25000
replace income=30000 if hinctnta==8&cntry=="ES"&essround==4 // range 27000 to under 33000 mid-point 30000
replace income=37000 if hinctnta==9&cntry=="ES"&essround==4 // range 33000 to under 41000 mid-point 37000
replace income=15750 if hinctnta==1&cntry=="CH"&essround==4	//	range	0	to	under	31500	mid-point	15750
replace income=38250 if hinctnta==2&cntry=="CH"&essround==4	//	range	31500	to	under	45000	mid-point	38250
replace income=50250 if hinctnta==3&cntry=="CH"&essround==4	//	range	45000	to	under	55500	mid-point	50250
replace income=60250 if hinctnta==4&cntry=="CH"&essround==4	//	range	55500	to	under	65000	mid-point	60250
replace income=70250 if hinctnta==5&cntry=="CH"&essround==4	//	range	65000	to	under	75500	mid-point	70250
replace income=81500 if hinctnta==6&cntry=="CH"&essround==4	//	range	75500	to	under	87500	mid-point	81500
replace income=94750 if hinctnta==7&cntry=="CH"&essround==4	//	range	87500	to	under	102000	mid-point	94750
replace income=112000 if hinctnta==8&cntry=="CH"&essround==4	//	range	102000	to	under	122000	mid-point	112000
replace income=139250 if hinctnta==9&cntry=="CH"&essround==4	//	range	122000	to	under	156500	mid-point	139250
replace income=4275 if hinctnta==1&cntry=="GB"&essround==4	//	range	0	to	under	8550	mid-point	4275
replace income=10010 if hinctnta==2&cntry=="GB"&essround==4	//	range	8550	to	under	11470	mid-point	10010
replace income=12955 if hinctnta==3&cntry=="GB"&essround==4	//	range	11470	to	under	14440	mid-point	12955
replace income=15900 if hinctnta==4&cntry=="GB"&essround==4	//	range	14440	to	under	17360	mid-point	15900
replace income=19240 if hinctnta==5&cntry=="GB"&essround==4	//	range	17360	to	under	21120	mid-point	19240
replace income=23385 if hinctnta==6&cntry=="GB"&essround==4	//	range	21120	to	under	25650	mid-point	23385
replace income=28260 if hinctnta==7&cntry=="GB"&essround==4	//	range	25650	to	under	30870	mid-point	28260
replace income=40490 if hinctnta==8&cntry=="GB"&essround==4	//	range	30870	to	under	50110	mid-point	40490
replace income=52015 if hinctnta==9&cntry=="GB"&essround==4	//	range	50110	to	under	53920	mid-point	52015
replace income=48600 if hinctnta==1&cntry=="SE"&essround==4	//	range	0	to	under	97200	mid-point	48600
replace income=109800 if hinctnta==2&cntry=="SE"&essround==4	//	range	97200	to	under	122400	mid-point	109800
replace income=135600 if hinctnta==3&cntry=="SE"&essround==4	//	range	122400	to	under	148800	mid-point	135600
replace income=164400 if hinctnta==4&cntry=="SE"&essround==4	//	range	148800	to	under	180000	mid-point	164400
replace income=196200 if hinctnta==5&cntry=="SE"&essround==4	//	range	180000	to	under	212400	mid-point	196200
replace income=232200 if hinctnta==6&cntry=="SE"&essround==4	//	range	212400	to	under	252000	mid-point	232200
replace income=283800 if hinctnta==7&cntry=="SE"&essround==4	//	range	252000	to	under	315600	mid-point	283800
replace income=356400 if hinctnta==8&cntry=="SE"&essround==4	//	range	315600	to	under	397200	mid-point	356400
replace income=445800 if hinctnta==9&cntry=="SE"&essround==4	//	range	397200	to	under	494400	mid-point	445800
replace income=5850 if hinctnta==1&cntry=="NL"&essround==4 // range 0 or more mid-point 5850
replace income=13350 if hinctnta==2&cntry=="NL"&essround==4 // range 11700 or more mid-point 13350
replace income=16600 if hinctnta==3&cntry=="NL"&essround==4 // range 15000 or more mid-point 16600
replace income=19850 if hinctnta==4&cntry=="NL"&essround==4 // range 18200 or more mid-point 19850
replace income=23400 if hinctnta==5&cntry=="NL"&essround==4 // range 21500 or more mid-point 23400
replace income=27400 if hinctnta==6&cntry=="NL"&essround==4 // range 25300 or more mid-point 27400
replace income=31850 if hinctnta==7&cntry=="NL"&essround==4 // range 29500 or more mid-point 31850
replace income=37200 if hinctnta==8&cntry=="NL"&essround==4 // range 34200 or more mid-point 37200
replace income=45250 if hinctnta==9&cntry=="NL"&essround==4 // range 40200 or more mid-point 45250


/* Values for top-coded categories */

/* For 2002-2006  */
gen hinctnt11=.
replace hinctnt11=1 if (hinctnt==11&essround<4)|(hinctnta==9&essround==4)
gen hinctnt12=.
replace hinctnt12=1 if (hinctnt==12&essround<4)|(hinctnta==9&essround==4)

by cntry essround, sort: egen freqtopminus1=count(hinctnt11)
by cntry essround, sort: egen freqtop=count(hinctnt12)

gen v=((ln(freqtopminus1+freqtop))-ln(freqtop))/(ln(120000)-ln(90000))
replace income=120000*(v/(v-1)) if hinctnt==12 // range 120000 or more, mid-point Hout 2004

/* For 2004 */
gen topmax=.
gen topmin=.
replace topmax=35000 if cntry=="BE"&essround==4 // range 35000
replace topmax=534000 if cntry=="DK"&essround==4 //	range	450000	to	under	534000
replace topmax=55200 if cntry=="FI"&essround==4 // range 55200
replace topmax=49200 if cntry=="FR"&essround==4 // range 49200
replace topmax=70400 if cntry=="DE"&essround==4 // range 70400
replace topmax=670000 if cntry=="NO"&essround==4 //	range	550000	to	under	670000
replace topmax=35000 if cntry=="PT"&essround==4 // range 35000
replace topmax=41000 if cntry=="ES"&essround==4 // range 41000
replace topmax=156500 if cntry=="CH"&essround==4 //	range	122000	to	under	156500
replace topmax=53920 if cntry=="GB"&essround==4 //	range	50110	to	under	53920
replace topmax=50300 if cntry=="NL"&essround==4 // range 50300
replace topmax=494400 if cntry=="SE"&essround==4 //	range	397200	to	under	494400

replace topmin=26000 if cntry=="BE"&essround==4 // range 35000
replace topmin=450000 if cntry=="DK"&essround==4 //	range	450000	to	under	534000
replace topmin=44400 if cntry=="FI"&essround==4 // range 55200
replace topmin=39600 if cntry=="FR"&essround==4 // range 49200
replace topmin=54600 if cntry=="DE"&essround==4 // range 70400
replace topmin=550000 if cntry=="NO"&essround==4 //	range	550000	to	under	670000
replace topmin=24500 if cntry=="PT"&essround==4 // range 35000
replace topmin=33000 if cntry=="ES"&essround==4 // range 41000
replace topmin=122000 if cntry=="CH"&essround==4 //	range	122000	to	under	156500
replace topmin=50110 if cntry=="GB"&essround==4 //	range	50110	to	under	53920
replace topmin=40200 if cntry=="NL"&essround==4 // range 50300
replace topmin=397200 if cntry=="SE"&essround==4 //	range	397200	to	under	494400

gen v4=((ln(freqtopminus1+freqtop))-ln(freqtop))/(ln(topmax)-ln(topmin)) if essround==4
replace income=topmax*(v4/(v4-1)) if hinctnta==10

drop v v4 topmin topmax hinctnt11 hinctnt12 freqtopminus1 freqtop


/* PPP 2005 conversion */

merge m:1 cntry year using ppp_cpi
tab year if _merge==2
drop if _merge==2
drop _merge

/* national income ESS exchange rates 2002-2006 */
gen natincome=income
replace natincome=income*(7.4) if cntry=="DK" & (essround==1 | essround==2 | essround==3)
replace natincome=income*(7.17) if cntry=="NO" & (essround==1 | essround==2 | essround==3)
replace natincome=income*(9.4) if cntry=="SE" & (essround==1 | essround==2 | essround==3)
replace natincome=income*(1.5) if cntry=="CH" & (essround==1 | essround==2 | essround==3)
replace natincome=income*(.66) if cntry=="GB" & (essround==1 | essround==2 | essround==3)

/* Turn into national currency, year 2005 */
gen natincome2005=natincome*100/cpi2005

/* Turn into PPP corrected US dollars 2005 */
gen income_ppp2005=natincome2005/ppp2005

/* clean intermediary variables */
drop natincome natincome2005 income


/*=========\
| Industry |
\=========*/

gen temp = nacer1
drop nacer1 
gen nacer1 = int(temp/10)
recode nacer1 (66/99=99)


* ===============
* =  left right =
* ===============
recode lrscale (77 88 99=.),gen(lright)


* ======================
* =    ESEC classes    =
* ======================
recode iscoco (66666/99999=.), gen(isco4)
recode jbspv (1=1) (else = 0), gen(supvis)
recode emplno (66666/99999=-1)
recode emplrel (2=1)(else =0), gen(sempl)
qui do "isco2esec.do"
isco2esec esec, isco(isco4) sv(supvis) sempl(sempl) emplno(emplno)
recode esec (4 5 = 4) (.=99)


* ===================
* = Religion        =
* ===================
*current denom
recode rlgdnm (1=1 "cath")(2=2 "prot")(3/8 =3 "other")(66=0 "none") (77 99 = .),gen (denom)
* church attendance
recode rlgatnd (77 88 99=.)
vreverse  rlgatnd ,gen(attend)



* ==============
* =  more .... =
* ==============
* things to use for superefficient imputation
* children in household
recode chldhm (1=1)(2 9=0),gen(children)
* divorced
recode dvrcdev (1=1)(2 6 7 8 9=0),gen(divorce)
* life satisfaction
recode stflife (77/99=.)
*subj. health
recode health (7 8 9 =.)
* N household members
recode hhmmb (77/99=.)
* living in urban area?
recode domicil (7 8 9=.)
* feeling about income
recode hincfel (7 8 9 =.)

/* gen weight variable */
gen weight = dweight*pweight



* =================================================================
* = remove some cases............................................ =
* =================================================================

* drop respondents under 18 and with missing gender
drop if age < 18
drop if age == 123
drop if female == .
* drop countryyears with too coarse region info
* dk in ess4 reduced to 5 regions (instead of 15)
drop if cntryyear=="DK4"
* IE 3 only coarse region cat.
drop if cntryyear=="IE3"
drop if cntryyear=="FI1"
drop if cntryyear=="FI2"

* drop missing age (will not be used in listw. analyses, nor do we impute it)
count
dropmiss age, obs any force
count


* =================================================================
* =    output to file ........................................... =
* =================================================================

egen cntryn = group(cntry)
compress
sort cntry year idno

keep cntry cntryyear rincd age female eduyrs lmtctr transfer uempl3 income_ppp2005 esec lright children divorce stflife health hhmmb domicil hincfel regionat regionbe regionch regionde regiondk regiones regionfr regiongb regionie regionnl regionno regionpt regionse regioach regioafi regioaes regioapt year weight iscoco nacer1 fear equalop victim denom attend hincsrc 

gen idno = _n

saveold working, replace


rm ess1.dta
rm ess2.dta
rm ess3.dta
rm ess4.dta


