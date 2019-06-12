clear all

set more off
set mem 500m

*cd "C:\Users\ldzan\Dropbox\Paper_Geoff\Analysis"
cd "/Users/aneundorf/Dropbox/Paper_Geoff/Analysis/"
use "Data/BHPS_working", clear

* ========================================
* = Recoding of variables   =
* ========================================


gen year = time + 1991
replace year = 1991 if wave=="a"
tab year



* ========================================
* = Recode Party ID =
* ========================================


tab partyid vote1, col

tab partyid,m
tab partyid, nolabel

recode partyid (4=0) 
lab def pidlbl1 0"No/other PID" 1"Cons" 2"Labour" 3"Libdem"
lab val partyid pidlbl1
tab partyid

tab partyid2,m

rename partyid2 pid3cat 

recode pid3cat (4=0)
lab val pid3cat pidlbl1
tab pid3cat


* ========================================
* = Recode Party ID as ordinal measure =
* ========================================

tab vote5
tab vote5, nolabel

drop pidstrength
gen pidstrength = .
replace pidstrength = 1 if pid3cat==2 & vote5==1
replace pidstrength = 2 if pid3cat==2 & vote5==2
replace pidstrength = 3 if pid3cat==2 & vote5==3
replace pidstrength = 4 if partyid==0
replace pidstrength = 5 if pid3cat==1 & vote5==3
replace pidstrength = 6 if pid3cat==1 & vote5==2
replace pidstrength = 7 if pid3cat==1 & vote5==1

lab def pidst1 1"Strong Labour" 2"Weak Labour" 3"Independent Labour" 4"Independent Independent" ///
5 "Independent Tory" 6"Weak Tory" 7 "Strong Tory"
lab val pidstrength pidst1
tab pidstrength


* ===================================
* = gen lagged effects =
* ===================================
bysort pid (year): gen pid_1 = pid3cat[_n-1]
bysort pid (year): gen pid_2 = pid3cat[_n-2]
bysort pid (year): gen pid_3 = pid3cat[_n-3]
bysort pid (year): gen pid_4 = pid3cat[_n-4]

bysort pid (year): gen pid_add1 = pid3cat[_n+1]
bysort pid (year): gen pid_add2 = pid3cat[_n+2]
bysort pid (year): gen pid_add3 = pid3cat[_n+3]
bysort pid (year): gen pid_add4 = pid3cat[_n+4]

*browse pid year pid3cat pid_1 pid_2 pid_3 pid_4 pid_add1 pid_add2


* ========================================
* = Recode Voting =
* ========================================


tab1 vote7 vote8
tab1 vote7 vote8, nolabel


gen vote = vote8
recode vote (3/8=0) (-9/-1=.)
replace vote = 0 if vote7==2

lab val vote pidlbl1
tab vote

tab pid3cat vote, nof row col

* ========================================
* = Recode Party ID as ordinal measure =
* ========================================

tab vote5
tab vote5, nolabel

gen pidstrength = .
replace pidstrength = 1 if pid3cat==2 & vote5==1
replace pidstrength = 2 if pid3cat==2 & vote5==2
replace pidstrength = 3 if pid3cat==2 & vote5==3
replace pidstrength = 4 if partyid==0
replace pidstrength = 5 if pid3cat==1 & vote5==3
replace pidstrength = 6 if pid3cat==1 & vote5==2
replace pidstrength = 7 if pid3cat==1 & vote5==1

lab def pidst1 1"Strong Labour" 2"Weak Labour" 3"Independent Labour" 4"Independent Independent" ///
5 "Independent Tory" 6"Weak Tory" 7 "Strong Tory"
lab val pidstrength pidst1
tab pidstrength




* ========================================
** Political Ideology
* ========================================
tab opsoca 
tab opsocb 
tab opsocc 
tab opsocd 
tab opsoce 
tab opsocf

local waves = " a c"
foreach i of local waves {
gen opsoc_`i'_rev = opsoc`i'
recode opsoc_`i'_rev (-9/0=.) (5=1) (4=2) (2=4) (1=5)
}

local waves = " b d e f"
foreach i of local waves {
gen opsoc_`i'_rev = opsoc`i'
recode opsoc_`i'_rev (-9/0=.) 
}

factor opsoc_a_rev -opsoc_f_rev, pcf 

gen econideo_scale = opsoc_a_rev  + opsoc_c_rev + opsoc_b_rev + opsoc_d_rev + opsoc_e_rev + opsoc_f_rev
tab econideo_scale

*kdensity econideo_scale 

** Gen lagged effects for dependent variables 


bysort pid (year): gen econideo_scale_1 = econideo_scale[_n-2] 
bysort pid (year): gen econideo_scale_2 = econideo_scale[_n-3] 
bysort pid (year): gen econideo_scale_3 = econideo_scale[_n-4]  

sort pid year
browse pid year econideo_scale econideo_scale_1 econideo_scale_2 econideo_scale_3


gen econ_lag = econideo_scale_1 if year==1993 | year==1995  | year== 1997
replace econ_lag = econideo_scale_2 if year==2000 | year==2007
replace econ_lag = econideo_scale_3 if year==2004

*browse pid year econideo_scale econ_lag econideo_scale_1 econideo_scale_2 econideo_scale_3




* ========================================
** First year included in study

egen min_year = min(year) if pid3cat!=., by(pid)
*browse pid year min_year partyid2 
tab min_year



* ============================================
** 0.  Employment (NOTE: EXCLUDE PENSIONERS)

tab1 jbft jbstat
tab jbstat, nolabel

gen retire =0
replace retire = 1 if jbstat==4

*drop if retire==1

saveold "BHPS_recoded", replace


* ========================================
** 1a) Age: Min

bysort pid: gen age1 = age if year== min_year
recode age1 (.=-2)
bysort pid: egen min_age = max(age1)
lab var min_age "Age at t=0"
recode min_age (-2=.)
drop age1

tab min_age

*browse pid year min_year partyid2 age min_age 

** 1b) Age: Mean

bysort pid: egen mean_age = mean(age) if pid3cat!=.
lab var mean_age "Mean Age "
*tab mean_age

tab age


/*
*** 5-year cohorts: averaged macro data will be matched when R' were between 15 and 19 old

gen age5=.
set more off
foreach num of numlist 16(5)80 {
	replace age5 = `num' if min_age==`num' | min_age==`num'+1 | min_age==`num'+2 | min_age==`num'+3 | min_age==`num'+4 
	}
replace age5= 16 if min_age==15 
replace age5= 86 if min_age>80 

lab var age5 "Age (when entered panel) groups devided into 5-year intervals"
tab age5, gen(age5_)
*/
*** 10-year cohorts: averaged macro data will be matched when R' were between 15 and 19 old
drop age10
gen age10=.
set more off
foreach num of numlist 15(10)80 {
	replace age10 = `num' if min_age==`num' | min_age==`num'+1 | min_age==`num'+2 | min_age==`num'+3 | min_age==`num'+4 | min_age==`num'+5 | min_age==`num'+6 | min_age==`num'+7 | min_age==`num'+8 | min_age==`num'+9 
	}
replace age10= 65 if min_age>65 

lab var age10 "Age (when entered panel) groups devided into 10-year intervals"
tab age10 if pid3cat!=.


*browse pid year min_year partyid2 age min_age mean_age 


* ========================================
** 2) Gender 

tab female,m


* ========================================
** 3) Region: min

tab region, m
tab region, nolabel

*xtmixed region || pid:, mle
*xtreg region, i(pid) mle

******


bysort pid: gen reg1 = region if year== min_year 
recode reg1 (.=-2)
bysort pid: egen min_region = max(reg1)
lab var min_region "Region at t=0"
recode min_region (-2=.)
drop reg1

recode min_region (1 / 2 = 1) (13/14 = 12) (15=16) (7=8) (9/10=11)

lab def reglbl 3 "r. of south east" 4 " south west " 5 " east anglia " 6 "east midlands"  ///
8 "r. of west midlands" 11 " r. of north west" 12 "yorkshire & humber"  ///
16"r. of north east " 1 "Greater London"

lab val min_region reglbl
tab min_region

*browse pid year min_year partyid2 region min_region 


* ========================================
** 4a) Social Class: Min


tab esec3, m
tab esec4 
tab esec4, nolabel

*xtreg esec4, i(pid) mle

****************

bysort pid: gen cla1 = esec3 if year== min_year 
recode cla1 (.=-2)
bysort pid: egen min_class6 = max(cla1)
lab var min_class6 "Class (6 Cat) at t=0"
recode min_class6 (-2=.)
drop cla1

rename min_class6 min_class
lab def classlbl 2"Intermediate" 3"Self-employed" 4"Lower sales services" 5"technicians" 6"Manual workers" 1 "Service"
lab val min_class classlbl

tab min_class

gen socclass= esec3
lab val socclass classlbl

tab socclass

*browse pid year min_year partyid2 esec4 min_class 



* ========================================
** 5a) Housing: Min


tab housing, m
tab housing2, m
tab housing2, nolabel

*xtreg housing2, i(pid) mle

*xtmixed housing2 time || pid:, mle

***************************

bysort pid: gen tem1 = housing2  if year== min_year 
recode tem1 (.=-2)
bysort pid: egen min_housing = max(tem1)
lab var min_housing  "Housing at t=0"
recode min_housing (-2=.)
drop tem1

*browse pid year min_year partyid2 housing2 min_housing

lab def houslbl 2"Mortgage" 3"Social" 4"Rented" 1"Own"
lab val min_housing houslbl
tab min_housing



* ========================================
** 6a) Education: Min


tab casmin, m
tab casmin, nolabel
recode casmin (-7/-1=.)
tab casmin

tab isced
tab isced, nolabel
recode isced (-7/0=.)

tab isced
tab isced educ

tab qfedhi
tab qfedhi, nolabel
tab qfedhi educ

drop educ
gen educ = isced
recode educ  (7=6)  (2=1) 
replace educ=1 if qfedhi==13
lab def educlbl 1 "Primary or still in school" 3 "low sec-voc" 4 "hisec-mivoc" 5"higher voc" 6 "degree"
lab val educ educlbl
tab educ

*xtreg educ, i(pid) mle

*************************

bysort pid: gen tem1 = educ  if year== min_year 
recode tem1 (.=-2)
bysort pid: egen min_educ = max(tem1)
lab var min_educ  "Education at t=0"
recode min_educ (-2=.)
drop tem1

lab val min_educ educlbl
tab min_educ


** 5b) Education: Max

bysort pid: egen max_educ = max(educ) if pid3cat!=.
lab var max_educ "Max Education"


lab val max_educ educlbl
tab max_educ

**** Highest qualification

tab qfedhi
tab qfedhi, nolabel

recode qfedhi (-9/-7=.) (13=.) (1/2=5 "Uni degree") (3/5=4 "Oth degree") (6=3 "A-levels") (7=2 "O-levels") ///
 (8/11=1 "Less than O-levels") (12=0 "No qualif"), gen(educ_high)

tab educ_high
tab educ_high max_educ



* ========================================
** 7a) Income: Min

*kdensity logyrinc
*kdensity incyear if incyear <100000

gen inc_log = log(incyear)
*kdensity inc_log

bys year: egen incyear_5 = xtile(incyear), nq(5) 


*************************

bysort pid: gen tem1 = incyear_5  if year== min_year 
recode tem1 (.=-2)
bysort pid: egen min_inc = max(tem1)
lab var min_inc  "Income in quintiles at t=0"
recode min_inc (-2=.)
drop tem1

tab min_inc



* ========================================
** 8) Political Interest

tab vote6,m
tab vote6, nolabel

gen polint = vote6
recode polint (-9/0=.) (1=4) (2=3) (3=2) (4=1)
lab def intlbl 1"not at all int" 2"not very int" 3"fairly int" 4"very int"
lab val polint intlbl
lab var polint "RECODE Political Interest"
tab polint


bysort pid: egen mean_int = mean(polint) if pid3cat!=.
lab var mean_int "Mean Interest"



*** Safe all ***

saveold "Data/BHPS_recoded", replace

*** Create smaller dataset ***

use "Data/BHPS_recoded", clear

bys pid: egen validresp_econ = count(econideo_scale)
tab validresp_econ

drop if econideo_scale==. | validresp_econ<3

tab time,m
recode time (2=1) (4=2) (6=3) (9=4) (13=5) (16=6)

saveold "Data/BHPS_atleast3validresponses", replace


*** Create smaller dataset ***

use "Data/BHPS_recoded", clear

bys pid: egen validresp_econ = count(econideo_scale)
tab validresp_econ
drop if econideo_scale==. | validresp_econ<7

tab time,m
recode time (2=1) (4=2) (6=3) (9=4) (13=5) (16=6)

save "Data/BHPS_recoded_nomissing_fullresponse", replace


