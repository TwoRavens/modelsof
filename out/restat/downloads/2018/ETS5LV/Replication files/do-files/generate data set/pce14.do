

/*This do-file is adapted from the IFLS14 consumption generating do-file available 
on the IFLS website */

clear
#delimit ;
set more off ;
set mem 72m ;
capture log close ;
set lines 140 ;
set matsize 300 ;
*log using E:\PCE\logfile\pce07, text replace ;
cd c:/;

global dir8 "$ifls/IFLS5/hh14_all_dta";
					

**************************************************************************** ;
*pce07.do  ;
*Files used: ; 
* Original files: bk_sc.dta, bk_ar1.dta, b1_ks0.dta, b1_ks1.dta, b1_ks2.dta, b2_kr.dta  ;
*Files created:  ;
*attrit_pce14.dta  ;
****************************************************************************  ;



set more off  ;
set trace off  ;
set mem 32m  ;
set matsize 300  ;

****************************************************************************  ;
* I. Create a file with kecamatan ID, kabupaten ID, etc  ;
****************************************************************************  ;
#delimit ;
use hhid14 commid14 result14 if hhid14~="" using "$dir8/htrack.dta", clear ;

  gen com34=real(substr(commid14,3,2) )  ;
  gen origea14=(com34~=.)  ;
  lab var origea "In IFLS EA 14"  ;
  drop com34  ;
  sort hhid14 ;
save "$dir0\commid14.dta", replace ;

#delimit ;
use hhid* sc*  using "$dir8\bk_sc1.dta", clear ;
* note the July 2 2009 version of bk_sc still has the wrong hhid07 ;
* hhid07 is still the 9 digit version of the hhid ;
* variable "x" is the hhid07 ;


  bys hhid14: keep if _n==_N ;
 gen provid07=sc01_14_14 ;
 gen double kabid14=100*sc01_14_14+ sc02_14_14 ;
 gen double kecid14=(kabid14*1000)+sc03_14_14 ;
 sort hhid14 ;
 merge n:1 hhid14 using "$dir0\commid14" ;
 keep if _merge==3 ;
 drop _merge ;
 gen rural=(sc05~=1) ;
 sort hhid14 ;

save "$dir0\sc14", replace  ;


**************************************************************************** ;
* II. Housing Expenditures, Book KR (B2_KR.DTA)  ;
****************************************************************************
* II.1 Identify outliers 
****************************************************************************  ;
#delimit ;
use hhid14 kr03 kr04* kr05* using  "$dir8\b2_kr", clear  ;
bys hhid14: keep if _n==_N ;
format kr04a kr05a %12.0f  ;
tab1 kr04a kr05a  ;
sort hhid14  ;

gen kr04=kr04a if kr04ax==2 ;
replace kr04=kr04a/12 if kr04ax==1 ;

gen kr05=kr05a if kr05ax==2 ;
replace kr05=kr05a/12 if kr05ax==1 ;

gen _outlierkr04=1 if kr04>20000000 & kr04~=. ;
gen _outlierkr05=1 if kr05>20000000 & kr05~=.  ;

list hhid14 kr04 if _outlierkr04==1 ;
list hhid14 kr05 if _outlierkr05==1  ;


mvencode _outlierkr*, mv(0)  ;
list hhid14 kr04 kr05 if _outlierkr04==1 | _outlierkr05==1  ;
tab1 _outlier*  ;
sort hhid14  ;
save "$dir0\tempkr14", replace  ;


* II.2 Merge with kecid, kabid, information  ;
****************************************************************************  ;
#delimit ;
use "$dir0\sc14", clear  ;
sort hhid14  ;
merge 1:n hhid14 using "$dir0\tempkr14" ;
tab _merge  ;
*Only keep HHs who answered Book 2  ;
keep if _merge==3  ;
drop _merge  ;

tab kr04ax  ;
tab kr05ax  ;

* II.3 Generate median variables   ;
****************************************************************************  ;
egen medcom05a=median(kr05), by(commid14)  ;
egen medkec05a=median(kr05), by(kecid)  ;
egen medkab05a=median(kr05), by(kabid)  ;

egen medcom04a=median(kr04), by(origea)  ;
egen medkec04a=median(kr04), by(kecid)  ;
egen medkab04a=median(kr04), by(kabid)  ;
compress  ;


* II.4. Imputation   ;
****************************************************************************  ;
rename kr04 origkr04  ;
rename kr05 origkr05  ;

gen kr04=origkr04 if kr04ax~=. & origkr04~=.  ;
replace kr04=medcom04a if origea==1 & kr04ax~=. & origkr04==.  ;
replace kr04=medkec04a if kr04ax~=. & kr04==.  ;
replace kr04=medkab04a if kr04ax~=. & kr04==.  ;

gen kr05=origkr05 if kr05ax~=. & origkr05~=.  ;
replace kr05=medcom05a if origea==1 & kr05ax~=. & origkr05==. ; 
replace kr05=medkec05a if kr05ax~=. & kr05==.  ;
replace kr05=medkab05a if kr05ax~=. & kr05==.  ;


gen  owners=(kr05ax~=.)  ;
lab define owners 1 "Owners" 0 "Renters" ; 
lab value owners owners  ;
lab var owners "Owners or renters?"  ;

replace kr04=. if _outlierkr04==1  ;
replace kr05=. if _outlierkr05==1  ;

gen _outlierkr=(_outlierkr04==1 | _outlierkr05==1)  ;

lab var _outlierkr04 "Any outlier in kr04"  ;
lab var _outlierkr05 "Any outlier in kr05" ; 
lab var _outlierkr "Any outlier in kr"  ;


* II.5 Generate variable containing information on missing values in this data file   ;
****************************************************************************  ;
gen misskr=1 if kr04==. & kr04ax~=.  ;
replace misskr=1 if kr05==. & kr05ax~=.  ;
replace misskr=0 if misskr==.  ;
lab var misskr "Household with missng kr04 or kr05"  ;
tab misskr, m  ;

* II.6 Label, compress, sort, and save the data  ;
****************************************************************************  ;
lab data "KRwith imputed values"  ;
compress  ;
sort hhid14   ;
capture drop med* origk*  ;
save "$dir0\b2_kr14", replace  ;

************************************************************************  ;
* III. Book 1 - KS  Food Consumption: KS02, KS03  ;
************************************************************************  ;
* III.1 Identify outliers  ;
****************************************************************************  ;
# delimit ;
use hhid14 ks02 ks03 ks1type using "$dir8\b1_ks1", clear  ;
bys hhid14 ks1type: keep if _n==_N ;
format ks02 ks03 %12.0f  ;
compress  ;

* KS02  ;
gen y=1 if ks02>=999995 ;
gen z=1 if ks03>=999995 ;
replace ks02=. if y==1 ;
replace ks03=. if z==1 ;

bys hhid14: egen _outlierks02=max(y)  ;
bys hhid14: egen _outlierks03=max(z)  ;
mvencode _outlierks02, mv(0)  ;
mvencode _outlierks03, mv(0)  ;
lab var _outlierks02 "Any outlier in ks02" ; 
lab var _outlierks03 "Any outlier in ks03"  ;
tab1 _outlierks02 _outlierks03  ;
drop y  z   ;
sort hhid14  ;

* III.2. Reshape b1_ks1.dta from long to wide  ;
****************************************************************************  ;
reshape wide ks02 ks03, i(hhid) j(ks1type) string  ;
gen _outlierks=(_outlierks02==1 | _outlierks03==1)  ;
lab var _outlierks02 "Any outlier in ks02"  ;
lab var _outlierks03 "Any outlier in ks03"  ;
lab var _outlierks "Any outlier in ks"  ;
aorder  ;
sort hhid14 ;
save "$dir0\b1_ks114wide", replace ; 
compress  ;

* III.3. Merge with kecamatan ID, etc ; 
****************************************************************************  ;
# delimit ;
use "$dir0\sc14", clear  ;
sort hhid14  ;
merge 1:n hhid14 using "$dir0\b1_ks114wide"  ;
tab _merge  ;
keep if _merge==3  ;
drop _merge  ;

* III.4. Generate median variables  ;
****************************************************************************  ;
for var ks*: egen medcomX=median(X), by(commid14)  ;
for var ks*: egen medkecX=median(X), by(kecid)  ;
for var ks*: egen medkabX=median(X), by(kabid)  ;

* III.5. Imputation  ;
****************************************************************************  ;
for var ks*: gen origX=X  ;

for var ks*: replace X=origX if origX~=.  ;
for var ks02*: replace X=medcomX if X==. & origea==1 & _outlierks02~=1  ;
for var ks02*: replace X=medkecX if X==. & _outlierks02~=1  ;
for var ks02*: replace X=medkabX if X==. & _outlierks02~=1  ;
for var ks03*: replace X=medcomX if X==. & origea==1 & _outlierks03~=1  ;
for var ks03*: replace X=medkecX if X==. & _outlierks03~=1  ;
for var ks03*: replace X=medkabX if X==. & _outlierks03~=1  ;


for var ks*: replace X=medcomX if origX==. & X==.  ;

for var ks02*: replace X=. if _outlierks02==1  ;
for var ks03*: replace X=. if _outlierks03==1  ;

********************************************************************** 


* III.6. Generate total  ;
gen sumks02=ks02A+ks02AA+ks02B+ks02BA+ks02C+ks02CA+ks02D+ks02DA+ks02E+ks02EA+ks02F+ks02FA+ks02G+ks02GA /* ;
*/ +ks02H+ ks02HA+ks02I+ks02IA+ks02IB+ ks02J+ks02K+ks02L+ks02M+ks02N+ks02OA+ks02OB+ks02P+ks02Q+ks02S /* ;
*/ +ks02R+ks02T+ks02U+ks02V+ks02W+ks02X+ks02Y+ks02Z  ;

gen sumks03=ks03A+ks03AA+ks03B+ks03BA+ks03C+ks03CA+ks03D+ks03DA+ks03E+ks03EA+ks03F+ks03FA+ks03G+ks03GA /*   ;
*/ +ks03H+ ks03HA+ ks03I+ ks03IA+ks03IB+ ks03J+ks03K+ks03L+ks03M+ks03N+ks03OA+ks03OB+ks03P+ks03Q+ks03S  /* ;
*/ +ks03R+ks03T+ks03U+ks03V+ks03W+ks03X+ks03Y+ks03Z  ;


* III.7 Generate variable containing information on missing values in this data file   ;
**************************************************************************** 
capture drop missks02  ;
capture drop missks03  ;
gen missks02=(sumks02==.)  ;
gen missks03=(sumks03==.)  ;

lab var missks02 "Household w/ at least 1 KS02 missing"  ;
lab var missks03 "Household w/ at least 1 KS03 missing"  ;

tab1 miss*  ;

* III.8 Label, sort, save the data  ;
****************************************************************************  ;
sort hhid14   ;
capture drop med* origk* sum*  ;
compress  ;
label data "Wide version of b1_ks1, with imputation"  ;
save "$dir0\b1_ks114", replace  ;


********************************************************************************  ;
* IV. KS06 (B1_KS2.DTA)  ;
********************************************************************************  ;

* IV.1 Identify outliers  ;
****************************************************************************  ;
#delimit ;
use hhid14 ks2type ks06 using "$dir8\b1_ks2", clear  ;
bys hhid14 ks2type: keep if _n==_N ;
format ks06 %16.0f ;
replace ks06=. if ks06>=99999995 ;

gen  z=0  ;
replace z=1 if ks06>=9100000 & ks2type=="C1" ;
replace z=1 if ks06>=6100000 & ks2type=="D" ;
replace z=1 if ks06>=9000000 & ks2type=="E" ;
replace z=1 if ks06>=7000000 & ks2type=="F2" ;
replace z=1 if ks06>=15000000 & ks2type=="G" ;

*replace ks06=. if z==1 ;

bys hhid14: egen _outlierks06=max(z)  ;
drop z ;

lab var _outlierks06 "Any outlier in ks06" ; 
tab _outlierks06  ;
sort hhid14  ;
compress  ;

* IV.2. Generate variable containing information on missing values in this data file   ;
****************************************************************************  ;
gen   x=1 if ks06==.  ;
replace x=0 if ks2type=="F2" ; 
replace x=0 if x==.   ;
egen   missks06=max(x), by(hhid14) ; 
lab var missks06 "Household w/ at least 1 KS06 missing, excl. F2"  ;
compress  ;
drop x  ;

* IV.3. Reshape b1_ks2.dta from long to wide  ;
****************************************************************************  ;
drop if ks2type=="" ;
reshape wide ks06, i(hhid14) j(ks2type) string  ;
tab missks06  ;
sort hhid14  ;
compress  ;
label data "Wide version of b1_ks2"  ;
save "$dir0\b1_ks214_wide", replace  ;


* IV.5. Merge with commid, kecid, kabid info  ;
****************************************************************************  ;
# delimit ;
use hhid* kecid kabid commid14 rural origea using "$dir0\sc14", clear  ;
sort hhid14  ;
merge 1:n hhid14 using "$dir0\b1_ks214_wide"  ;
tab _merge  ;
*Only keep HHs which answered Book 1  ;
keep if _merge==3  ;
drop _merge  ;

inspect ks06*  ;

* IV.5. Generate median variables  ;
****************************************************************************  ;
for var ks*:  egen medcomX=median(X), by(commid14)  ;
for var ks*:  egen medkecX=median(X), by(kecid)  ;
for var ks*:  egen medkabX=median(X), by(kabid)  ;


compress   ;

* IV.6. Imputation  ;
****************************************************************************  ;

for var ks*: gen origX=X  ;
for var ks*: replace X=medcomX if X==. & origea==1  & _outlierks06~=1  ;
for var ks*: replace X=medkecX if X==. & _outlierks06~=1  ;
for var ks*: replace X=medkabX if X==. & _outlierks06~=1  ;

for var ks06*: replace X=medcomX if origX==. & X==.  ;

for var ks06*: replace X=. if _outlierks06==1  ;

********** END OF THE 'MANUAL' IMPUTATION OF KS06************************************************************  ;

* IV.7 Generate variable containing information on missing values in this data file   ;
****************************************************************************  ;
capture drop missks06 ;
gen ks06A=ks06A1+ks06A2+ks06A3+ks06A4  ;
gen sumks06=ks06A+ks06B+ks06C+ks06C1+ks06D+ks06E+ks06F1+ks06G  ;
gen missks06=(sumks06==.)  ;
lab var missks06 "Household w/ at least 1 KS06 missing -excluding F2"  ;
tab missks06  ;

* IV.8. save the data ;
****************************************************************************  ;
compress  ;
capture drop origk* med* sumks  ;
sort hhid14 ;
save "$dir0\b1_ks214", replace  ;


********************************************************************************  ;
* V. KS08, KS09a,  (B1_KS3.DTA)  ;
********************************************************************************  ;
* V.1. Identify outliers  ;
****************************************************************************  ;
# delimit ;

use ks08 ks09a ks3type hhid14 using "$dir8\b1_ks3", clear  ;
bys hhid14 ks3type: keep if _n==_N ;
replace ks08=. if ks08>=98989998 ;
replace ks09a=. if ks09a>=98998998 ;
sort hhid14 ks3type  ;

gen     _z=1 if ks08>12000000 & ks08~=.  & ks3type=="A" ;
replace _z=1 if ks08>13500000 & ks08~=.  & ks3type=="B" ;
replace _z=1 if ks08>30000000 & ks08~=.  & ks3type=="C" ;
replace _z=1 if ks08>41000000 & ks08~=.  & ks3type=="D" ;
replace _z=1 if ks08>10300000 & ks08~=.  & ks3type=="E" ;
replace _z=1 if ks08>81000000 & ks08~=.  & ks3type=="F" ;
replace _z=1 if ks08>17000000 & ks08~=.  & ks3type=="G" ;

gen     _x=1 if ks09>5000000 & ks09~=.  & ks3type=="A" ;
replace _x=1 if ks09>3160000 & ks09~=.  & ks3type=="B" ;
replace _x=1 if ks09>30000000 & ks09~=.  & ks3type=="C" ;
replace _x=1 if ks09>20000000 & ks09~=.  & ks3type=="D" ;
replace _x=1 if ks09>28000000 & ks09~=.  & ks3type=="F" ;

replace ks08=. if _z==1 ;
replace ks09=. if _x==1 ;

bys hhid14: egen _outlierks08=max(_z) ;
bys hhid14: egen _outlierks09=max(_x) ;

mvencode _outlierks08, mv(0) ;
mvencode _outlierks09, mv(0) ;
drop _x _z ;

sort hhid14  ;

compress  ;

lab var _outlierks08 "Any outlier in ks08"  ;
lab var _outlierks09 "Any outlier in ks09"  ;

tab1 _outlier*  ;
compress  ;

*V.2. Reshape b1_ks3.dta from long to wide  ;
****************************************************************************  ;
drop if ks3type=="";
reshape wide ks08 ks09a, i(hhid14 ) j(ks3type) string  ;
sort hhid14   ;
compress  ;
label data "Wide version of b1_ks3 created pre_pce.do"  ;
save "$dir0\b1_ks314_wide", replace  ;

*V.3 Merge with kecamatan ID information  ;
****************************************************************************  ;

# delimit ;
use "$dir0\b1_ks314_wide", clear  ;
sort hhid14  ;
save "$dir0\tempks314", replace  ;


use hhid*  commid14 kecid kabid origea rural using "$dir0\sc14", clear  ;
sort hhid14  ;
merge hhid14 using "$dir0\tempks314"  ;
tab _merge  ;
*Only keep HHs which answered Book 2  ;
keep if _merge==3  ;
drop _merge  ;

inspect ks*  ;

*V.4 Generate median variables  ;
****************************************************************************  ;
for var ks*: egen medcomX=median(X), by(commid14)  ;
for var ks*: egen medkecX=median(X), by(kecid)  ;
for var ks*: egen medkabX=median(X), by(kabid)  ;

*V.5. Imputation  ;
****************************************************************************  ;
for var ks*: gen origX=X  ;
for var ks08*: replace X=medcomX if X==. & origea==1  & _outlierks08~=1  ;
for var ks08*: replace X=medkecX if X==. & _outlierks08~=1  ;
for var ks08*: replace X=medkabX if X==. & _outlierks08~=1  ;
for var ks09*: replace X=medcomX if X==. & origea==1  & _outlierks09~=1  ;
for var ks09*: replace X=medkecX if X==. & _outlierks09~=1  ;
for var ks09*: replace X=medkabX if X==. & _outlierks09~=1  ;


for var ks08* ks09*: replace X=medcomX if origX==. & X==.  ;

for var ks08*: replace X=. if _outlierks08==1  ;
for var ks09*: replace X=. if _outlierks09==1  ;

********** END OF THE 'MANUAL' IMPUTATION OF KS08 AND KS09 ************************************************************  ;
inspect ks*  ;

compress   ;
sort hhid14  ;

* V.6 Generate variable containing information on missing values in this data file   ;
****************************************************************************  ;
gen sumks08=ks08A+ks08B+ks08C+ks08D+ks08E+ks08F+ks08G  ;
capture drop missks08  ;
gen missks08=(sumks08==.)  ;

gen sumks09=ks09aA+ks09aB+ks09aC+ks09aD+ks09aF  ;
capture drop missks09  ;
gen missks09=(sumks09==.)  ;

*V.7. save the data  ;
****************************************************************************  ;
lab var  missks08 "Household w/ at least 1 KS08 missing"  ;
lab var  missks09 "Household w/ at least 1 KS09a missing"  ;
tab1 miss*  ;
capture drop med* origk* sum*  ;
compress  ;
sort hhid14  ;

save "$dir0\b1_ks314", replace  ;

********************************************************************************  ;
* VI. B1_KS0  ;
********************************************************************************  ;
# delimit ;
use  hhid14 ks04b ks07a ks10aa ks10ab ks11aa ks11ab ks12aa ks12ab ks12bb using "$dir8\b1_ks0", clear  ;
bys hhid14: keep if _n==_N ;

replace ks04b=. if ks04b>=995995 ;
gen _outlierks04b=. ;

replace ks07a=. if ks07a>=99999995 ;
gen _outlierks07a=1 if ks07a> 3610000;
 
for var ks10* ks11* ks12*: replace X=. if X>=98998998;

for var ks10* ks11* ks12*: gen _outlierX=. ;

replace _outlierks10aa=1 if ks10aa>31200000 ;
replace _outlierks10ab=1 if ks10ab>35000000;
replace _outlierks11aa=1 if ks11aa>7720000;
replace _outlierks11ab=1 if ks11ab>12250000;
replace _outlierks12ab=1 if ks12ab>40000000 ;
replace _outlierks12bb=1 if ks12bb>27000000;
sort hhid14  ;

mvencode  _outlier*, mv(0) ;

lab var _outlierks04b "Any outlier in ks04b" ;
lab var _outlierks07a "Any outlier in ks07a" ;
lab var _outlierks10aa "Any outlier in ks10aa" ;
lab var _outlierks10ab "Any outlier in ks10ab" ;
lab var _outlierks11aa "Any outlier in ks11aa" ;
lab var _outlierks11ab "Any outlier in ks11ab" ;
lab var _outlierks12aa "Any outlier in ks12aa" ;
lab var _outlierks12ab "Any outlier in ks12ab " ;
lab var _outlierks12bb "Any outlier in ks12bb" ;

merge 1:1 hhid14 using "$dir0\sc14"  ;
tab _merge  ;
keep if _merge==3  ;
drop _merge  ;
 
* VI.1. Identify outliers  ;
********************************************************************************  ;
gen byte _outlierks0=0   ;
lab var _outlierks0 "Any outlier in ks0.dta"  ;
tab _outlierks0  ;

* VI.2. Generate median variables  ;
********************************************************************************  ;
for var ks*: egen medcomX=median(X), by(commid14) ; 
for var ks*: egen medkecX=median(X), by(kecid)  ;
for var ks*: egen medkabX=median(X), by(kabid) ;

* VI.3. Imputation  ;
********************************************************************************  ;
for var ks*: gen origX=X  ;
for var ks*: replace X=medcomX if X==. & origea==1  & _outlierks0~=1  ;
for var ks*: replace X=medkecX if X==. & _outlierks0~=1  ;
for var ks*: replace X=medkabX if X==. & _outlierks0~=1  ;
 

for var ks07a* ks10* ks1* : replace X=medcomX if origX==. & X==.  ;

for var ks07a* ks10* ks1*: replace X=. if _outlierks0==1  ;

********** *************  ;

* VI.4 Generate variable containing information on missing values in this data file  ;
********************************************************************************  ;
gen miss4b=1 if ks04b==.  ;
lab var miss4b "Household with missing ks04b"  ;
mvencode miss4b, mv(0)  ;
tab miss4b  ;

gen miss7a=1 if ks07a==.  ;
lab var miss7a "Household with missing ks07a"  ;
mvencode miss7a, mv(0)  ;
tab miss7a  ;

gen miss10aa=1 if ks10aa==.  ;
lab var miss10aa "Household with missing ks10aa"  ;
mvencode miss10aa, mv(0)  ;
tab miss10aa  ;

gen miss10ab=1 if ks10ab==.  ;
lab var miss10ab "Household with missing ks10ab"  ;
mvencode miss10ab, mv(0)  ;
tab miss10ab  ;

gen miss11aa=1 if ks11aa==.  ;
lab var miss11aa "Household with missing ks11aa"  ;
mvencode miss11aa, mv(0)  ;
tab miss11aa  ;

gen miss11ab=1 if ks11ab==.  ;
lab var miss11ab "Household with missing ks11ab"  ;
mvencode miss11ab, mv(0)  ;
tab miss11ab  ;

gen miss12aa=1 if ks12aa==.  ;
lab var miss12aa "Household with missing ks12aa"  ;
mvencode miss12aa, mv(0)  ;
tab miss12aa  ;

gen miss12ab=1 if ks12ab==.  ;
lab var miss12ab "Household with missing ks12ab"  ;
mvencode miss12ab, mv(0)  ;
tab miss12ab  ;

gen miss12bb=1 if ks12bb==.  ;
lab var miss12bb "Household with missing ks12bb"  ;
mvencode miss12bb, mv(0)  ;
tab miss12bb  ;

* VI.5 save the file  ;
************************************************************************************  ;
capture drop  med* origk*  ;
sort hhid14   ;
compress   ;
label data "Shorter version of b1_ks0 created using pre_pce.do"  ;
save "$dir0\b1_ks014", replace  ;

************************************************************************************  ;
* VII. MERGE ALL EXPENDITURE FILES  ;
************************************************************************************  ;
#delimit ;
use "$dir0\b1_ks014", clear  ;
merge 1:1 hhid14  using "$dir0\b1_ks114"  ;
tab _merge  ;
rename _merge _m1  ;
 ;
merge 1:1 hhid14   using "$dir0\b1_ks214"  ;
tab _merge  ;
rename _merge _m2   ;
merge 1:1 hhid14   using "$dir0\b1_ks314"  ;
tab _merge  ;
rename _merge _m3  ;
merge 1:1 hhid14   using "$dir0\b2_kr14"  ;
tab _merge  ;
* _merge=1 hh in Book 1-KS but not in Book 2 - KR  ;
* _merge=2 hh in Book 2-KR but not in Book 1 - KS  ;
list hhid14  _merge if _merge~=3  ;
*keep if _merge==3  ;
rename _merge _mkr  ;

gen z=missks02+missks03+missks06+miss4b+miss7a+missks08+missks09+misskr+miss10aa+miss10ab+miss11aa+miss11ab+miss12aa+miss12ab+miss12bb  ;
gen missing=1 if z>0 & z~=. ;
replace missing=1 if z==.   ;
replace missing=0 if missing==. & z~=.  ;
replace missing=1 if z==. ;

drop z   ;
lab var missing "Household with at least 1 part of expenditure missing"  ;
tab missing, m  ;
lab data "Merged Book1/KS with missing value & outlier information. Wide version"  ;
save "$dir0\pre_pce14.dta", replace  ;


******************************************************************************  ;
*VIII. PCE    ;
******************************************************************************  ;
# delimit ;
use "$dir0\pre_pce14" ,clear  ;
**FOOD (KS02, KS03, AND KS04B), MONTHLY  ;

gen mrice=ks02A*52/12  ;
gen mstaple=(ks02A+ks02B+ks02C+ks02D+ks02E)*52/12   ;
gen mvege=(ks02F+ks02G+ks02H)*52/12  ;
gen mdried=(ks02I+ks02J)*52/12  	 ;
gen mmeat=(ks02K+ks02L+ks02OA+ks02OB)*52/12   ;
gen mfish=(ks02M+ks02N)*52/12  ;
gen mdairy=(ks02P+ks02Q)*52/12   ;
gen mspices=(ks02R+ks02S+ks02T+ks02U+ks02V)*52/12  ;
gen msugar=(ks02W+ks02AA)*52/12   ;
gen moil=(ks02X+ks02Y)*52/12  ;
gen mbeve=(ks02Z+ks02BA+ks02CA+ks02DA+ks02EA)*52/12   ;
gen maltb=(ks02FA+ks02GA+ks02HA)*52/12   ;
gen msnack=(ks02IA)*52/12  ;
gen mfdout=(ks02IB)*52/12  ;

gen irice=ks03A*52/12  ;
gen istaple=(ks03A+ks03B+ks03C+ks03D+ks03E)*52/12   ;
gen ivege=(ks03F+ks03G+ks03H)*52/12  ;
gen idried=(ks03I+ks03J)*52/12   ;
gen imeat=(ks03K+ks03L+ks03OA+ks03OB)*52/12   ;
gen ifish=(ks03M+ks03N)*52/12  ;
gen idairy=(ks03P+ks03Q)*52/12   ;
gen ispices=(ks03R+ks03S+ks03T+ks03U+ks03V)*52/12  ;
gen isugar=(ks03W+ks03AA)*52/12   ;
gen ioil=(ks03X+ks03Y)*52/12  ;
gen ibeve=(ks03Z+ks03BA+ks03CA+ks03DA+ks03EA)*52/12   ;
gen ialtb=(ks03FA+ks03GA+ks03HA)*52/12   ;
gen isnack=(ks03IA)*52/12  ;
gen ifdout=(ks03IB)*52/12  ;
 
gen xrice=mrice+irice  ;
gen xstaple=mstaple+istaple  ;
gen xvege=mvege+ivege  ;
gen xdried=mdried+idried  ;
gen xmeat=mmeat+imeat  ;
gen xfish=mfish+ifish  ;
gen xdairy=mdairy+idairy ; 
gen xspices=mspices+ispices ;  
gen xsugar=msugar+isugar  ;
gen xoil=moil+ioil  ;
gen xbeve=mbeve+ibeve  ;
gen xaltb=maltb+ialtb  ;
gen xsnack=msnack+isnack ; 
gen xfdout=mfdout+ifdout   ;

*TOTAL MONTHLY  ;

*mfood: total ks02  ;
gen mfood =mstaple+mvege+mdried+mmeat+mfish+mdairy+mspices+msugar+moil+mbeve+maltb+msnack+mfdout  ;

*ifood: total ks03  ;
gen ifood =istaple+ivege+idried+imeat+ifish+idairy+ispices+isugar+ioil+ibeve+ialtb+isnack+ifdout  ;

*xfdtout: Food transfer, ks04b  ;
gen xfdtout=ks04b*52/12  ;
lab var xfdtout "Monthly food transfer, ks04b"  ;

******************************************************************  ;
*MONTHLY EXPENDITURE ON FOOD: KS02 AND KS03 (NOT INCLUDING KS04B) ;
*****************************************************************  ;
gen xfood =xstaple+xvege+xdried+xmeat+xfish+xdairy+xspices+xsugar+xoil+xbeve+xaltb+xsnack+xfdout  ;
lab var xfood "Monthly food consumption, ks02 and ks03"  ;

lab var mrice "Monthly food consumption ks02: rice"   ;
lab var mstaple "Monthly food consumption ks02: staple" ;  
lab var mvege "Monthly food consumption ks02: vegetable, fruit"  ;
lab var mdried "Monthly food consumption ks02: dried food"  ;
lab var mmeat "Monthly food consumption ks02: meat"  ;
lab var mfish "Monthly food consumption ks02: fish"  ;
lab var mdairy "Monthly food consumption ks02: dairy"  ;
lab var mspices "Monthly food consumption ks02: spices"  ;
lab var msugar "Monthly food consumption ks02: sugar"  ;
lab var moil "Monthly food consumption ks02: oil"   ;
lab var mbeve "Monthly food consumption ks02: beverages" ; 
lab var maltb "Monthly food consumption ks02: alcohol/tobacco" ; 
lab var msnack "Monthly food consumption ks02: snacks"  ;
lab var mfdout "Monthly food consumption ks02: food out of home"  ;

lab var irice "Monthly food consumption ks03: rice"  ;
lab var istaple "Monthly food consumption ks03: staple" ;  
lab var ivege "Monthly food consumption ks03: vegetable, fruit" ; 
lab var idried "Monthly food consumption ks03: dried food"  ;
lab var imeat "Monthly food consumption ks03: meat"  ;
lab var ifish "Monthly food consumption ks03: fish"  ;
lab var idairy "Monthly food consumption ks03: dairy"  ;
lab var ispices "Monthly food consumption ks03: spices"  ;
lab var isugar "Monthly food consumption ks03: sugar"  ;
lab var ioil "Monthly food consumption ks03: oil"   ;
lab var ibeve "Monthly food consumption ks03: beverages"  ;
lab var ialtb "Monthly food consumption ks03: alcohol/tobacco"  ;
lab var isnack "Monthly food consumption ks03: snacks"  ;
lab var ifdout "Monthly food consumption ks03: food out of home"  ;

lab var xrice "Monthly food consumption ks02+ks03: rice"   ;
lab var xstaple "Monthly food consumption ks02+ks03: staple" ;  
lab var xvege "Monthly food consumption ks02+ks03: vegetable, fruit" ; 
lab var xdried "Monthly food consumption ks02+ks03: dried food"  ;
lab var xmeat "Monthly food consumption ks02+ks03: meat"  ;
lab var xfish "Monthly food consumption ks02+ks03: fish"  ;
lab var xdairy "Monthly food consumption ks02+ks03: dairy"  ;
lab var xspices "Monthly food consumption ks02+ks03: spices"  ;
lab var xsugar "Monthly food consumption ks02+ks03: sugar"  ;
lab var xoil "Monthly food consumption ks02+ks03: oil"   ;
lab var xbeve "Monthly food consumption ks02+ks03: beverages" ; 
lab var xaltb "Monthly food consumption ks02+ks03: alcohol/tobacco"  ;
lab var xsnack "Monthly food consumption ks02+ks03: snacks"  ;
lab var xfdout "Monthly food consumption ks02+ks03: food out of home"  ;

lab var mfood "Monthly food cons.,market purch. all ks02"  ;
lab var ifood "Monthly food cons.,own-prod. all ks03"  ;


*END OF FOOD  ;

* NON-FOOD FROM KS2TYPE (KS06), MONTHLY  ;

rename ks06A xutility  ;
rename ks06B xpersonal  ;
rename ks06C xhhgood  ;
rename ks06C1 xdomest  ;
rename ks06D xrecreat  ;
rename ks06E xtransp  ;
rename ks06F1 xlottery  ;
rename ks06F2 xarisan  ;
rename ks06G xtransf2  ;

lab var xutility "Monthly expend. on utility ks06A"  ;
lab var xpersonal "Monthly expend. on personal goods ks06B"  ;
lab var xhhgood "Monthly expend. on hh goods ks06C"  ;
lab var xdomest "Monthly expend. on domestic goods ks06C1"  ;
lab var xrecreat "Monthly expend. on recreation ks06D"  ;
lab var xtransp "Monthly expend. on transport. ks06E"  ;
lab var xlottery "Monthly expend. on lottery ks06F1"  ;
lab var xarisan "Monthly expend. on arisan ks06F2"  ;
lab var xtransf2 "Monthly expend. on transfer ks06G"  ;

rename ks07a inonfood  ;
lab var inonfood "Monthly non-food own-produce (ks07a)"  ;


*xnonfood2 IS ALL KS06 EXCLUDING TRANSFER AND ARISAN   ;
gen xnonfood2=xutility+xpersonal+xhhgood+xdomest+xrecreat+xtransp+xlottery   ;

*totks06 IS ALL KS06   ;
gen totks06=xnonfood2+xtransf2+xarisan  ;

lab var xnonfood2 "Monthly non-food expend. ks2type, transfer & arisan excl."  ;
lab var totks06 "Monthly non-food expend. ks2type, transfer & arisan incl."  ;
sort hhid14  ;

*NON-FOOD FROM KS3TYPE (KS08, KS09A), CONVERTED TO MONTHLY FIGURES  ;

gen mcloth=ks08A/12  ;
gen mfurn=ks08B/12  ;
gen mmedical=ks08C/12 ; 
gen mcerem=ks08D/12  ;
gen mtax=ks08E/12  ;
gen mother=ks08F/12  ;
gen mtransf3=ks08G/12  ;

gen icloth=ks09aA/12  ;
gen ifurn=ks09aB/12  ;
gen imedical=ks09aC/12 ; 
gen icerem=ks09aD/12  ;
gen iother=ks09aF/12  ;

gen xcloth=mcloth+icloth ; 
gen xfurn=mfurn+ifurn  ;
gen xmedical=mmedical+imedical ; 
gen xcerem=mcerem+icerem ; 
gen xtax=mtax  ;
gen xother=mother+iother  ;
gen xtransf3=mtransf3  ;
	
*xnonfood3 IS ALL KS08 and KS09a EXCLUDING TRANSFER   ;
gen xnonfood3=xcloth+xfurn+xmedical+xcerem+xtax+xother   ;

lab var mcloth "Monthly non-food expend: clothing,ks08A"  ;
lab var mfurn "Monthly non-food expend: furniture,ks08B"  ;
lab var mmedical "Monthly non-food expend: medical,ks08C"  ;
lab var mcerem "Monthly non-food expend: ceremony,ks08D"  ;
lab var mtax "Monthly non-food expend: tax,ks08E"  ;
lab var mother "Monthly non-food expend: other,ks08F" ; 
lab var mtransf3 "Monthly non-food expend: transfer,ks08G" ; 

lab var icloth "Monthly non-food expend: clothing,ks09aA"  ;
lab var ifurn "Monthly non-food expend: furniture,ks09aB"  ;
lab var imedical "Monthly non-food expend: medical,ks09aC"  ;
lab var icerem "Monthly non-food expend: ceremony,ks09aD" ; 
lab var iother "Monthly non-food expend: other,ks09aF"  ;

lab var xcloth "Monthly non-food expend: clothing,ks08A+ks09aA"  ;
lab var xfurn "Monthly non-food expend: furniture,ks08B+ks09aB"  ;
lab var xmedical "Monthly non-food expend: medical,ks08C+ks09aC"  ;
lab var xcerem "Monthly non-food expend: ceremony,ks08D+ks09aD"  ;
lab var xtax "Monthly non-food expend: tax,ks08E"  ;
lab var xother "Monthly non-food expend: other,ks08F+ks09aF"  ;
lab var xtransf3 "Monthly non-food expend: transfer,ks08G"  ;

lab var xnonfood3 "Monthly non-food expend. ks3type(all ks08,ks09a excl. ks08G)"  ;


**HOUSING  ;

gen xhrent=kr04 if kr04ax~=. ; 
gen xhown=kr05 if kr05ax~=.  ;
gen xhouse=kr04 if kr04ax~=.  ;
replace xhouse=kr05 if kr05ax~=.  ;

lab var xhrent "Monthly expend. on housing:rent (kr04)"  ;
lab var xhown "Monthly expend. on housing:own  (kr05)"  ;
lab var xhouse "Monthly expend. on housing (kr04/kr05)"   ;

********  ;
*EDUCATIOn  ;

gen xedutuit=ks10aa/12  ;
gen xeduunif=ks11aa/12  ;
gen xedutran=ks12aa/12  ;
gen xeduc=xedutuit+xeduunif+xedutran  ;
gen xedutuitout=ks10ab/12 ; 
gen xeduunifout=ks11ab/12  ;
gen xedutranout=ks12ab/12  ;
gen xedubordout=ks12bb/12  ;
gen xeducout=xedutuitout+xeduunifout+xedutranout+xedubordout  ;
gen xeducall=xeduc+xeducout  ;

lab var xedutuit "Monthly expend. on educ.:tuition, ks10aa"  ;
lab var xeduunif "Monthly expend. on educ.:uniform, ks11aa"  ;
lab var xedutran "Monthly expend. on educ.:transport, ks12aa"  ;
lab var xedutuitout "Monthly expend. on educ. out of home:tuition, ks10ab"  ;
lab var xeduunifout "Monthly expend. on educ. out of home:uniform, ks11ab"  ;
lab var xedutranout "Monthly expend. on educ. out of home:transport, ks12ab"  ;
lab var xedubordout "Monthly expend. on educ. out of home:boarding, ks12bb"  ;
lab var xeduc "Monthly expend. on educ ks10aa-ks12aa"  ;
lab var xeducout "Monthly expend. on educ, out of home ks10ab-ks12bb"  ;
lab var xeducall "Monthly expend. on educ, all (ks10aa-ks12bb)"  ;

*NOTE: FOR CALCULATING HH EXPENDITURE, USE XEDUC (EXPEND. ON KIDS INSIDE THE HOME)   ;

*********************************  ;
*MONTHLY EXPENDITURE CATEGORIES  ;
******************************  ;

drop ks02* ks03*  ;

***************************************  ;
* HOUSEHOLD EXPENDITURE: XFOOD + XNONFOOD  ;
***************************************  ;

**FOOD : xfood: total of KS02 and KS03, already generated   ;

**NONFOOD:xnonfood=xnonfood2+xnonfood3+xhousing+xeduc+inonfood,  ;
*SO IT IS THE TOTAL OF KS06 WITHOUT ARISAN + TOTAL KS08,KS09 + HOUSING + EDUCATION FOR CHILDREN IN THE HOME ONLY + OWN-PRODUCED NON0-FOOD.  ;
*ks06 w/o arisan, ks08, ks09a, ks10aa-ks12aa, ks07a). Generated below:  ;

gen xnonfood=xnonfood2+xnonfood3+xhouse+xeduc+inonfood  ;
lab var xnonfood "Monthly non-food expenditure"   ;

** HHEXP: MONTHLY HOUSEHOLD EXPENDITURE   ;
gen hhexp=xfood+xnonfood  ;
lab var hhexp "Monthly expenditure"  ;
inspect hhexp  ;


**********************************  ;
*OTHER CATEGORIES  ;
**************************************  ;

*MONTHLY FOOD CONSUMPTION: FROM KS02,KS03 AND TRANSFER OF FOOD OUT  ;
gen hhfood=xfood+xfdtout  ;
lab var hhfood "Monthly consumption on food (ks02,ks03 AND ks04b)"  ;

*MONTHLY TRANSFER: FROM KS04B, KS06G, KS8G, AND EDUC FOR KID OUTSIDE THE HOME monthly  ;
gen xtransfer=xfdtout+xtransf2+xtransf3+xeducout  ;
lab var xtransfer "Monthly transfer (from ks04b,ks6G,ks08G,ks10ab-ks12bb)"  ;

*MONTHLY EXPENDITURES ON HOUSEHOLD EXPENSES   ;
gen xhhx=xutility+xhhgood+xdomest+xfurn  ;
lab var xhhx "Monthly expend. on household expenses"  ;

*MONTHLY EXPENDITURES ON TRANSPORTATION: xtransp (already generated)  ;

*MONTHLY EXPENDITURES ON MEDICAL: xmedical (already generated)  ;

*MONTHLY EXPENDITURES ON ENTERTAINMENT  ;
gen xentn=xrecreat+xlottery+xcerem  ;
lab var xentn "Monthly expend. on entertainment"  ;

*MONTHLY EXPENDITURES ON DURABLES  ;
gen xdura=xfurn+xother+xtransf3   ;
lab var xdura "Monthly expend. on durables"  ;

*MONTHLY EXPENDITURES ON CEREMONIES AND TAX  ;
gen xritax=xcerem+xtax  ;
lab var xritax "Monthly expend. on ritual and tax"  ;

sort hhid14  ;
drop ks0*   ;
compress  ;
save "$dir0\pce14_wo_hhsize.dta", replace  ;


**************************************************************************************************** ;
* IX. MERGE WITH HHSIZE.DTA,  DATA FROM AR WITH INFO ON HHSIZE (AR01==1 OR 5) ;
*************************************************************************************************   ;
# delimit ;

use hhid14 ar00 ar01a if ar01a==1 | ar01a==2 | ar01a==5 | ar01a==11 using "$dir8\bk_ar1", clear  ;
bys hhid14 ar00: keep if _n==_N ;
bys hhid14: gen hhsize=_N  ;
bys hhid14: keep if _n==_N ;
lab var hhsize "HH size"  ;
sort hhid14  ;
save "$dir0\hhsize14", replace  ;

merge 1:1 hhid14  using "$dir0\pce14_wo_hhsize.dta " ;
lab var _merge "Expenditure available?"  ;
lab val _merge _mexp ;
lab define _mexp 1 "1.Roster only" 2 "2.Expend only" 3 "3.Yes"  ;
tab _merge   ;
*keep if _merge==3  ;
tab missing _merge, m  ;
tab _mkr _merge, m  ;
rename _merge _mexp ;

inspect hhexp   ;
inspect hhsize  ;

*PER CAPITA EXPENDITURES: HHEXP/HHSIZE ;
gen pce=hhexp/hhsize  ;
lab var pce "Per capita expenditure"  ;

inspect pce  ;
sum pce, detail  ;
sum pce if missing==0 , detail  ;

gen lnpce=log(pce)  ;
lab var lnpce "Log of per capita expenditure"  ;


**EXPENDITURE SHARES:  EXPEND. x 100 / HHEXP  ;

gen wrice=xrice*100/hhexp  ;
gen wstaple=xstaple*100/hhexp  ;
gen wvege=xvege*100/hhexp  ;
gen wfood=xfood*100/hhexp  ;
gen woil=xoil*100/hhexp	  ;
gen wmedical=xmedical*100/hhexp  ;
gen wcloth=xcloth*100/hhexp  ;
gen wdairy=xdairy*100/hhexp  ;
gen weducall=xeducall*100/hhexp  ;
gen whous=xhous*100/hhexp  ;
gen wmtfs=(xmeat+xfish)*100/hhexp  ;
gen wnonfood=xnonfood*100/hhexp  ;
gen waltb=xaltb*100/hhexp  ;

lab var wrice "Expend. share: rice"  ;
lab var wstaple "Expend. share: staple food"  ;
lab var wvege "Expend. share: vegetable"  ;
lab var woil "Expend. share: oil"  ;
lab var waltb "Expend. share: alcohol+tobacco"  ;
lab var wfood "Expend. share: food"  ;

lab var wmedical "Expend. share: medical cost"  ;
lab var wcloth "Expend. share: clothing"  ;
lab var wdairy "Expend. share: dairy"  ;
lab var weducall "Expend. share: education (all)"  ;
lab var whous "Expend. share: housing"  ;
lab var wmtfs "Expend. share: meat+fish"  ;
lab var wnonfood "Expend. share: nonfood excl.arisan"  ;

compress  ;
tab1 miss*, m ;

drop sc* commid* kabid kecid   origea ;
sort hhid14 ;
merge hhid14 using "$dir0\sc14" ;
rename _merge _msc ;
capture drop origea provid14 ;

# delimit ;
gen provid14=sc01_14 ;
keep hhid14  prov* kabid kecid x* m* i* w* _out* hh* *pce hhsize owners  _mexp commid14 _msc sc05 result14  ;
gen origea14=1 if (substr(commid14,3,1)=="0" | substr(commid14,3,1)=="1" | substr(commid14,3,1)=="2" | substr(commid14,3,1)=="3" |  substr(commid14,3,1)=="4" | /* ;
*/ substr(commid14,3,1)=="5"|  substr(commid14,3,1)=="6"|  substr(commid14,3,1)=="7"|  substr(commid14,3,1)=="8" |  substr(commid14,3,1)=="9" ) & /* ;
*/ (substr(commid14,4,1)=="0"|  substr(commid14,4,1)=="1"|  substr(commid14,4,1)=="2"|  substr(commid14,4,1)=="3" |  substr(commid14,4,1)=="4" | /* ;
*/ substr(commid14,4,1)=="5"|  substr(commid14,4,1)=="6"|  substr(commid14,4,1)=="7"|  substr(commid14,4,1)=="8" |  substr(commid14,4,1)=="9")  ;
replace origea=0 if origea==. ;
lab var origea "In IFLS  EA 14" ;

*
replace sc05=2 if commid14=="1314" | commid14=="6309" |commid14=="7310" ;
replace sc05=1 if commid14=="1206" | commid14=="1604" | commid14=="1611" | commid14=="3231" | commid14=="5201"  | commid14=="7316" ;

gen rural=(sc05~=1) ;

for var miss*: replace X=1 if X==. ;
for var _outlier*: replace X=0 if X==. ;

gen _outlierfood=1 if _outlierks02==1 | _outlierks03==1  ;
replace _outlierfood=0 if _outlierfood==. ;
gen _outlier=1 if _outlierks==1 | _outlierkr==1 ;
replace _outlier=0 if _outlier==. ;

lab var hhid14 "Household ID 2007" ;
lab var _msc "SC vars" ;
lab var result14 "Book K Result" ;
lab var _outlierfood "Household w/ at least 1 outlier in food exp." ;
lab var _outlier "Household w/ at least 1 outlier in exp." ;


lab var provid14 "Province ID" ;
lab var kabid14 "Kabupaten ID" ;
lab var kecid14 "Kecamatan ID" ;
lab var rural "Urban=0 Rural=1" ;

compress ;
tab1 miss*, m;

keep hhid14 commid14 prov* kabid* kecid* orige  m* i* w* _out* hh* *pce hhsize owners;

# delimit ;
lab data "Per Capita Expenditure 2014"  ;
sort hhid14  ;
save "$ifls/consumption\pce14nom.dta", replace  ;


