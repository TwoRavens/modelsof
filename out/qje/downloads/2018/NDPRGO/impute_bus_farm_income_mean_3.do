* by hand imputation
cd E:\RA\RA_Inequality\summer\data1

use impute_test, clear

gen miss1 = ( merge5 == 1)
keep if merge5 == 1
drop merge* rat1 rat2 rat3 rat4 rat5 meanbusfmind* tot_gr*

gen truestate = statefip

* AL - LA
replace statefip = 22 if statefip == 1

* AZ - CA 
replace statefip = 6 if statefip == 4

* AK - OK

replace statefip = 40 if statefip == 5

* CT - MA

replace statefip = 25 if statefip == 9

* DE - MD

replace statefip = 24 if statefip == 10

* DC - NJ

replace statefip = 34 if statefip == 11

* FL - NC

replace statefip = 37 if statefip == 12

* GA - LA

replace statefip = 22 if statefip == 13

* ID - WA

replace statefip = 53 if statefip == 16

* IN - IL
replace statefip = 17 if statefip == 18

* IO - IL

replace statefip = 17 if statefip == 19

* KS - CO 

replace statefip = 8 if statefip == 20

* KY - IL 

replace statefip = 8 if statefip == 21

* MA - NY

replace statefip = 36 if statefip == 25

* ME - MA

replace statefip = 25 if statefip == 23

* MD - NY

replace statefip = 36 if statefip == 11

* MN - MI
replace statefip = 26 if statefip == 27

* MS - LA

replace statefip = 22 if statefip == 28

* MO - IL
replace statefip = 17 if statefip == 29

* MN - WA 
replace statefip = 53 if statefip == 30

* NE - CO
replace statefip = 8 if statefip == 31

* NV - CA
replace statefip = 6 if statefip == 32

* NH - MA

replace statefip = 25 if statefip == 33

* NM - TX
replace statefip = 48 if statefip == 35

* ND - WA
replace statefip = 53 if statefip == 38

* OH - PA 
replace statefip = 42 if statefip == 39

* OR - WA 
replace statefip = 53 if statefip == 41

* RI - NY
replace statefip = 36 if statefip == 44

* SC - NC 
replace statefip = 37 if statefip == 45

* SD - WA 

* VT - MA 

replace statefip = 53 if statefip == 46

* TN - NC 
replace statefip = 37 if statefip == 47

* UT - CO
replace statefip = 8 if statefip == 49

* VT - MA 
replace statefip = 25 if statefip == 50

* VA - NC
replace statefip = 37 if statefip == 51

* WV - PA 
replace statefip = 42 if statefip == 54

* WI - MI
replace statefip = 26 if statefip == 55

* WY - CO
replace statefip = 8 if statefip == 56


* (1)
merge m:1 state racegr agr agegr educgr earnind using rat11950


drop if _merge == 2 
rename _merge merge1 

* (2)

sort state racegr agr  educgr earnind 

merge m:1 state racegr agr educgr earnind using rat21950
drop if _merge == 2 

rename _merge merge2

* (3) 

sort state racegr agr agegr earnind

merge m:1 state racegr agr agegr earnind using rat31950
drop if _merge == 2 

rename _merge merge3

* (4) 

merge m:1 state racegr agr earnind using rat41950
drop if _merge == 2 

rename _merge merge4

* (5) 
merge m:1 state racegr earnind using rat51950
drop if _merge == 2 

rename _merge merge5

gen missing = (merge5 == 1)

count if missing == 1

* very good
drop statefip
rename truestate statefip

* IMPUTATION

*randomly assign who gets positive bfi
* (1)
drop unidraw posbfi

gen unidraw = runiform()

gen posbfi = (unidraw <= meanbusfmind)

replace posbfi = . if posbfi == 0
replace incbusfm  = posbfi * rat1 * meanincw40 if merge1 == 3

*(2)
drop unidraw posbfi

gen unidraw = runiform()

gen posbfi = (unidraw <= meanbusfmind2)

replace incbusfm = posbfi * rat2 * meanincw402 if merge2 == 3 & merge1 != 3

*(3)
drop unidraw posbfi

gen unidraw = runiform()

gen posbfi = (unidraw <= meanbusfmind3)

replace incbusfm = posbfi * rat3 * meanincw403 if merge3 == 3 & merge1 != 3 & merge2 != 3

*(4)

drop unidraw posbfi

gen unidraw = runiform()

gen posbfi = (unidraw <= meanbusfmind4)

replace incbusfm = posbfi * rat4 * meanincw404 if merge4 == 3 &  merge3 != 3 & merge1 != 3 & merge2 != 3

* (5)

drop unidraw posbfi

gen unidraw = runiform()

gen posbfi = (unidraw <= meanbusfmind5)

replace incbusfm = posbfi * rat5 * meanincw405 if merge5 == 3 & merge4 != 3 &  merge3 != 3 & merge1 != 3 & merge2 != 3

* save
save hand_impute, replace

* the imputed in the previous stage
use impute_test, clear

* drop the unmatched in the previous stage to append the hand imputed
drop if merge5 == 1

append using hand_impute, force

rename incbusfm incbusfm_rep
sort year serial age educ race ind1950

drop dup 
bysort year serial age educ race ind1950 incwage: gen dup = cond(_N==1,0,_n)

drop if dup > 1
save incbusfm.dta, replace

use completedata_1964_app_07.dta, clear
*bysort year serial age educ race ind1950 incwage: gen dup = cond(_N==1,0,_n)

*drop if dup > 1

sort year serial year serial age educ race ind1950 

merge m:1 year serial age educ race ind1950 incwage using incbusfm.dta
replace incbusfm = incbusfm_rep if year == 1940 
drop incbusfm_rep 
drop _merge

save completedata1964_1940.dta, replace

append using C:\Users\ok9\acs_1964_2014.dta

save completedata_1964_acs_1940.dta
