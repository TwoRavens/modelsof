***************************************************************************************
***************************************************************************************
*** 																				***
***  Replication File (1)															***
*** 																				***
***  Source: Emmenegger, Patrick, Marx, Paul, and Schraff, Dominik. 2016. Off to 	***
***  a bad start: unemployment and political interest during early adulthood.       ***
***	                                    											***
*** 																				***
***************************************************************************************
***************************************************************************************

***Create dataset 
*Note: Due to data protection regulations, you will have to request the SOEP data yourself. 
*It can be requested here: http://www.diw.de/en/diw_02.c.222517.en/data.html
*To replicate the results, you need two SOEP Versions:
* (1) SOEP v30 long beta - DOI: 10.5684/soep.v30beta
* (2) SOEP v30 long - DOI: 10.5684/soep.v30

*Make sure you request the long versions of the data!
*For simplicity, you can also just use the SOEP v30 long data. 
*Slight deviations might occure, but the results are nearly identical.

set more off

*Below, you will have to set the correct directories
*All data is merged from the SOEP v30 long beta 
*Only the survey weights are merged from SOEP v30 long

use pid syear hid d11101 i11102 d11109 l11102 e11106 d11104 ///
using "Directory\SOEP_v30_long_beta\pequiv.dta"

merge 1:1 pid syear using "Directory\SOEP_v30_long_beta\pl.dta",  ///
keepusing(plh0007 pli0098 plh0006)
drop if _merge== 2
drop _merge

merge 1:1 pid syear using "Directory\SOEP_v30_long_beta\pgen.dta",  ///
keepusing(pglfs pgjobch pgexpue pgegp pgisco88)
drop if _merge== 2
drop _merge

merge m:1 pid using "Directory\SOEP_v30_long_beta\ppfad.dta",  ///
keepusing(migback sex)
drop if _merge== 2
drop _merge

*Here, use the SOEP v30 
merge 1:1 pid syear using "Directory\SOEP_v30_long\ppfadl.dta",  ///
keepusing(pbleib phrf)
drop if _merge== 2
drop _merge

merge m:m hid syear using "Directory\SOEP_v30_long_beta\hl.dta",  ///
keepusing(hlc0043)
drop if _merge== 2
drop _merge


*Operationalize variables
drop if d11101<=15
drop if d11101>65

gen working= 1 if pglfs== 11
bysort pid (syear): carryforward working, replace
replace working= 0 if working== .

bysort pid (syear): gen t= _n if working== 1
bysort pid (syear): gen pynr= _n 
egen nmis = rmiss(t)
bysort pid (syear): egen tot_mis = total(nmis)
bysort pid (syear): replace t= t - tot_mis
replace t = t - 1
label var t "t0 = first observation in employment"

tab pglfs if t== 0
tab pglfs if t== 1
tab pglfs if t== 2

gen entrant= 1 if pgjobch== 5 & t!=.
bysort pid (syear): carryforward entrant, replace
replace entrant= 0 if entrant==.

gen ue= 1 if pglfs== 6 & t!=.
bysort pid (syear): carryforward ue, replace
replace ue= 0 if ue==. & t!=.
tab ue if t== 0
tab ue if t== 1
label var ue "unemployment after t0, based on pglfs"

gen polint = plh0007 if plh0007>-1
recode polint (1=4) (2=3) (3=2) (4=1)
label var polint "political interest, recoded"

gen polint_t0 = polint if t== 0
bysort pid (syear): carryforward polint_t0, replace

gen hh_inc= i11102 if i11102>0
gen hh_inc_t0 = hh_inc if t== 0
bysort pid (syear): carryforward hh_inc_t0, replace

gen mback= migback if migback>0
recode mback (1=0) (2=1) (3=1) (4=1)

gen age= d11101

gen eduy= d11109 if d11109>0

gen east= l11102
recode east (1=0) (2=1)

gen industry= e11106 if e11106>0
gen industry_t0= industry if t== 0
bysort pid (syear): carryforward industry_t0, replace

gen polint_ch_t2= polint - polint_t0 if t==2
gen polint_ch_t3= polint - polint_t0 if t==3
gen polint_ch_t4= polint - polint_t0 if t==4
gen polint_ch_t5= polint - polint_t0 if t==5

gen weight = pbleib
replace weight = phrf if pynr== 1

gen weight_p = weight
bysort pid (syear): replace weight_p=  weight_p * weight_p[_n-1] if pynr> 1

gen ue_u30_03= 1 if pgexpue>=0.3 & age== 29
bysort pid (syear): carryforward ue_u30_03, replace
replace ue_u30_03= 0 if ue_u30_03== .

gen ue_30o= 1 if pglfs== 6 & age>=30
bysort pid (syear): carryforward ue_30o, replace
replace ue_30o= 0 if ue_30o== .

gen gold= pgegp if pgegp>0

gen mart_stat= d11104 if d11104>0

gen no_kids= hlc0043 if hlc0043>0
replace no_kids= 0 if hlc0043== -2

gen curch_attend= pli0098 if pli0098>0
recode curch_attend (1=5) (2=4) (3=3) (4=2) (5=1)

gen notvoted_09= plh0006 if plh0006>0 & plh0006<3
recode notvoted_09 (1=0) (2=1)
bysort pid (syear): replace notvoted_09= notvoted_09[_n+1]

gen voted_09= notvoted_09
recode voted_09 (1=0) (0=1)

gen ue123= 1 if ue== 1 & t== 3
bysort pid (syear): carryforward ue123, replace
replace ue123= 0 if ue123== .

gen isco1= .
replace isco1= 0 if pgisco88> 0 & pgisco88<1000
replace isco1= 1 if pgisco88>=1000 & pgisco88<2000
replace isco1= 2 if pgisco88>=2000 & pgisco88<3000
replace isco1= 3 if pgisco88>=3000 & pgisco88<4000
replace isco1= 4 if pgisco88>=4000 & pgisco88<5000
replace isco1= 5 if pgisco88>=5000 & pgisco88<6000
replace isco1= 6 if pgisco88>=6000 & pgisco88<7000
replace isco1= 7 if pgisco88>=7000 & pgisco88<8000
replace isco1= 8 if pgisco88>=8000 & pgisco88<9000
replace isco1= 9 if pgisco88>=9000 & pgisco88<10000

gen isco_t0= isco1 if t== 0
bysort pid (syear): carryforward isco_t0, replace

set seed 14795
gen u = runiform()

drop hid d11101 d11104 d11109 e11106 i11102 l11102 pli0098 plh0007 plh0006 ///
migback pgisco88 pgegp pgexpue pgjobch hlc0043 nmis tot_mis weight notvoted_09

label var working "first observation in employment, based on pglfs"
label var pynr "bysort pid (syear): gen pynr= _n"
label var t "t0 = first observation in employment; based on pglfs"
label var ue "unemployment after t0, based on pglfs"
label var polint "plh0007, coding reversed"
label var polint_t0 "polint t0, based on plh0007"
label var hh_inc "HH Net Income, based on i11102"
label var hh_inc_t0 "hh_inc t0, based on i11102"
label var mback "migrant background, based on migback"
label var age "age, based on d11101"
label var eduy "Years in Education, based on d11109"
label var east "1==East, based on l11102 (recoded)"
label var industry "1digit industry codes, based on e11106"
label var industry_t0 "industry in t0, based on e11106"
label var entrant "first job, based on pgjobch"
label var polint_ch_t2 "change in polint from t0-t2, based on plh0007"
label var polint_ch_t3 "change in polint from t0-t3, based on plh0007"
label var polint_ch_t4 "change in polint from t0-t4, based on plh0007"
label var polint_ch_t5 "change in polint from t0-t5, based on plh0007"
label var pbleib "Inverse Bleibewahrscheinlichkeit"
label var phrf "Hochrechnungsfaktor"
label var weight_p "1st wave phrf times pbleib"
label var ue_u30_03 "early unemployment, based on pgexpue"
label var ue_30o "later unemployment, based on pglfs"
label var gold "Goldthorpe classes, based on pgegp"
label var mart_stat "marital status, based on pgfamstd"
label var no_kids "number of kids, based on hlc0043"
label var curch_attend "church attendance, based on pli0098"
label var voted_09 "turnout tlections 2009, based on bap126"
label var ue123 "unemployed in t1, t2, or t3; based on pglfs"
label var isco1 "1digit ISCO code, based on pgisco88"
label var isco_t0 "isco1 at t0, based on pgisco88"
label var u "random variable for sorting"
