
**********************************

*Getting treatment vector
use randomcheck.dta, clear
collapse (mean) treat, by(schid) fast
merge schid using treatschool
tab treat _m
list if _m == 3 & treat == 0
*These are two schools that closed after randomization but before implementation of experiment
*When authors call treatment vector use treatschool, so I will go with that for these two observations
replace treat = 1 if _m == 3
sort schid
mkmat schid treat, matrix(Y)
global N = 120
keep schid treat
gen N = _n
save Sample1, replace

*****************************

*My shortened version of their code

*Table 2 - Panel A - All okay

use "randomcheck.dta", clear
generate time = month-7 + 12*(year-2003)
replace time=2 if month==8 & day>24
drop if schid==1111 | schid==1211 | schid==2493 | schid==5221 | schid==5231| schid==5332| schid==5711
gen RC=1
sort schid
save randomcheck_CODED, replace

drop if time==1
regress open treat, cluster(schid)
regress open treat if time<9, cluster(schid)
regress open treat if time>8 & time<16, cluster(schid)
regress open treat if time>15, cluster(schid)


*Table 2 - Panels B & C - All okay

use Teacher_test.dta, clear

gen score=comp1+comp2+comp3+clozet+story+attitude+nnc1+nc1+nc2+nnc2+nnc3+nc3+vp+map
keep schid score
sort schid
merge schid using randomcheck_coded
keep if RC==1
drop if score==.
egen med_score=median(score)
gen above_score=0
replace above_score=1 if score>=med_score

drop if time==1
regress open treat if above_score == 1, cluster(schid)
regress open treat if above_score == 1 & time<9, cluster(schid)
regress open treat if above_score == 1 & time>8 & time<16, cluster(schid)
regress open treat if above_score == 1 & time>15, cluster(schid)

regress open treat if above_score == 0, cluster(schid)
regress open treat if above_score == 0 & time<9, cluster(schid)
regress open treat if above_score == 0 & time>8 & time<16, cluster(schid)
regress open treat if above_score == 0 & time>15, cluster(schid)


*Table 6 - Misreport a coefficient as a standard error
use randomcheck_CODED, clear
drop if time==1
keep if open==1

foreach X in inside interact_kids bbused {
	regress `X' treat, cluster(schid)
	regress `X'  treat if time<9, cluster(schid)
	regress `X' treat if time>8 & time<16, cluster(schid)
	regress `X' treat if time>15, cluster(schid)
	}

**************************

*Combining Tables 2 and 6 into one randomization analysis with shortened code

*Randomization analysis
use Teacher_test.dta, clear
gen score=comp1+comp2+comp3+clozet+story+attitude+nnc1+nc1+nc2+nnc2+nnc3+nc3+vp+map
keep schid score
sort schid
merge schid using randomcheck_coded
keep if RC==1
egen med_score=median(score)
gen above_score=0 if score ~= .
replace above_score=1 if score>=med_score & score ~= .
drop if time==1

foreach X in "RC==1" "above_score == 1" "above_score == 0" {
	foreach Y in "time > 1" "time < 9" "time > 8 & time < 16" "time > 15" {
		regress open treat if `X' & `Y', cluster(schid)	
		}
	}

foreach X in inside interact_kids bbused {
	foreach Y in "time > 1" "time < 9" "time > 8 & time < 16" "time > 15" {
		regress `X' treat if open == 1 & `Y', cluster(schid)
		}
	}

svmat Y
save DatDHR1, replace

***********************************************************************************************************;

*Table 3 - only treatment schools
*Table 4 - structural model, no stata do file code
*Table 5 - policy analysis

*Table 7 - All okay

capture mkdir Temp

use roster_rema2012.dta, clear
drop if month==12 & year==2005
append using "rosterfin", force

sort schid childno attendance
drop if year==2003 & month<9
drop if year==205
generate time = month-7 + (year-2003)*12
gen trend=time-1
replace attendance = 2 if attendance ==-999 |attendance ==-888 |attendance ==-777 |attendance ==-666 |attendance ==-444 |attendance ==-333 
replace attendance=0 if attendance==2
replace attendance=0 if attendance==22
gen reg=.
replace reg=0 if status==1
replace reg=1 if status==2
label variable reg "CHILD ATTENDS SCHOOL REGULARLY (>10 DAYS)"

sort schid year month day
merge schid year month day using "rc_for_roster"
drop if randomcheck==.
drop if month==8 & year==2003
save Temp/temp1, replace

use Temp/temp1, clear
drop _merge
sort schid childno
merge schid childno using "enroll1"
drop _merge
sort schid childno
merge schid childno using "pre_writ_attend"

gen pretest=1 if time<10
replace pretest=0 if pretest==.
gen posttest=1 if time==10 | time==11 | time==12 | time==13 | time==14 | time==15
replace posttest=0 if posttest !=1
gen postexp=0
replace postexp=1 if time>15
gen treatpre=treat*pretest
gen treatpost=treat*posttest
gen treatexp=treat*postexp
sort time
tab time, gen(t_)
drop if time==1
drop if childno==.
keep if enrolled1==1
save Temp\Roster_CODED, replace

**PANEL A & B, COL 1;

use Temp\Roster_CODED, clear

reg attendance treat if open == 1, cluster(schid)
regress attendance treatpre treatpost treatexp t_* if open == 1, cluster(schid)
reg attendance treat , cluster(schid)
regress attendance treatpre treatpost treatexp t_*, cluster(schid)

keep if open==1
gsort schid childno -year -month -day
gen last=0
replace last=last[_n-1]+1 if childno==childno[_n-1] & schid==schid[_n-1]
keep if last<5
gen tempgov=0
replace tempgov=1 if reason=="2"
sort schid childno treat
collapse (sum) attendance tempgov, by(schid childno treat)
gen drop=0
replace drop=1 if attendance==0
gen gov=0
replace gov=1 if tempgov!=0 & drop==1
keep schid childno drop gov treat
sort schid childno treat
save Temp\drop, replace

use Temp\Roster_CODED, clear
drop _merge
sort schid childno treat
merge schid childno treat using Temp\drop

**PANEL A & B, ROW 2;

gen drop2=drop 
replace drop2=0 if gov==1 

reg attendance treat if open == 1 & drop == 0, cluster(schid)
regress attendance treatpre treatpost treatexp t_* if open == 1 & drop == 0, cluster(schid)

reg attendance treat if drop == 0, cluster(schid)
regress attendance treatpre treatpost treatexp t_* if drop == 0, cluster(schid)

**PANEL C ROW 1;

reg attendance treat if drop == 0 & pre_writ == 0, cluster(schid)
regress attendance treatpre treatpost treatexp t_* if drop == 0 & pre_writ == 0, cluster(schid)

**PANEL C ROW 2;

reg attendance treat if drop == 0 & pre_writ == 1, cluster(schid)
regress attendance treatpre treatpost treatexp t_* if drop == 0 & pre_writ == 1, cluster(schid)


*Since data was reloaded in merge, can run altogether

foreach X in "if open == 1" "" "if open == 1 & drop == 0" "if drop == 0" "if drop == 0 & pre_writ == 0" "if drop == 0 & pre_writ == 1" {
	reg attendance treat `X', cluster(schid)
	reg attendance treatpre treatpost treatexp t_1-t_29 `X', cluster(schid)
	}

svmat Y
save DatDHR2a, replace

*****************************

*Table 10 - All okay

use Temp/drop, clear
reg drop treat, cluster(schid)
reg gov treat, cluster(schid)
gen drop2=drop
replace drop2=0 if gov==1
reg drop2 treat, cluster(schid)

foreach X in drop gov drop2 {
	reg `X' treat, cluster(schid)
	}

svmat Y
save DatDHR2b, replace


***********************************************


*Table 8 - All okay - Since upper panel concerns attrition, following usual procedure drop from analysis

*Part A

use "Closed School.dta", clear
gen close=1 if mon10=="Closed" & mon11=="Closed"
gen schid=idnum
keep schid close
sort schid
save Temp\tempclose, replace

use pre_verbal
rename total_1_to_4 pre_math_v
rename total_5_to_11 pre_lang_v
rename total pre_total_v
gen pre_writ=0
keep schid childno pre_math_v pre_lang_v pre_total_v pre_writ
save Temp\temp1, replace

use pre_written
rename total_1_to_4 pre_math_w
rename total_5_to_11 pre_lang_w
rename total pre_total_w
gen pre_writ=1
keep schid childno pre_math_w pre_lang_w pre_total_w pre_writ
save Temp\temp2, replace

use Temp\temp1, clear
append using Temp\temp2
sort schid childno
save Temp\testdata, replace

use mid_verbal, clear
rename tot_1_to_4 mid_math_v
rename tot_5_to_11 mid_lang_v
rename total mid_total_v
keep schid childno mid_math_v mid_lang_v mid_total_v
replace schid=2492 if schid==2493
sort schid childno
save Temp\temp3, replace

use mid_written, clear
rename total_1_to_5 mid_math_w
rename total_6_to_16 mid_lang_w
rename total mid_total_w
gen mid_writ=1
keep schid childno mid_math_w mid_lang_w mid_total_w mid_writ
replace schid=2492 if schid==2493
sort schid childno
save Temp\temp4, replace

use Temp\temp3, clear
sort schid childno
merge schid childno using Temp\temp4
drop _merge
sort schid childno
merge schid childno using Temp\testdata
save Temp\testdata, replace

replace pre_math_w=56 if schid==4231 & childno==3
replace pre_total_v=11 if schid==3511 & childno==17
replace pre_total_w=34 if schid==4252 & childno==22
gen block = int(schid/1000)
drop _merge
sort schid
merge schid using treatschool
gen treat = 0
replace treat = 1 if _merge == 3

for var _all: replace X = . if X == -999
for var _all: replace X = . if X == -888
for var _all: replace X = . if X == -777

drop _merge
sort schid
merge schid using Temp/tempclose
drop if treat==.
save Temp\test_new.dta, replace

use Temp\test_new.dta, clear
drop if schid==1211 | schid==5332 | schid==5711 | schid==1111 | schid==2111 | schid==5221 | schid==5611 | schid==1113 
drop if schid==5731 & childno==24
save Temp\test_new.dta, replace

gen entry=0
replace entry=1 if (pre_total_v==. & pre_total_w==.) & mid_total_v!=. 
gen missing=0
replace missing=1 if (pre_total_v!=. | pre_total_w!=.) & mid_total_v==. 
gen stayer=0
replace stayer=1 if missing==0 & entry==0
drop if entry==1

capture program drop zscore1
program define zscore1
	syntax, option1(string)
sort treat
egen m1_`option1'=mean(`option1') if treat==0
egen sd1_`option1'=sd(`option1') if treat==0
egen m_`option1'=mean(m1_`option1')
egen sd_`option1'=mean(sd1_`option1')
gen z_`option1'=(`option1'-m_`option1')/sd_`option1'
end

zscore1, option1(pre_total_v)
zscore1, option1(pre_total_w)

gen treat_missing=treat*missing

**PANEL A/COL 3;
regress missing treat, cluster(schid)
regress pre_writ treat_missing missing treat, cluster(schid)
regress z_pre_total_v treat_missing missing treat, cluster(schid)
regress z_pre_total_w treat_missing missing treat, cluster(schid)
save Temp\test_new, replace


use Temp\test_new, clear
drop if stayer==0
replace pre_math_w=pre_math_w/5
replace pre_lang_w=pre_lang_w/5
replace pre_total_w=pre_total_w/5
replace mid_math_w=mid_math_w/5
replace mid_lang_w=mid_lang_w/5
replace mid_total_w=mid_total_w/5
replace pre_math_v=0 if pre_math_v==.
replace pre_lang_v=0 if pre_lang_v==.
replace pre_total_v=0 if pre_total_v==.
replace pre_math_w=0 if pre_math_w==.
replace pre_lang_w=0 if pre_lang_w==.
replace pre_total_w=0 if pre_total_w==.
replace mid_math_v=0 if mid_math_v==.
replace mid_lang_v=0 if mid_lang_v==.
replace mid_total_v=0 if mid_total_v==.
replace mid_math_w=0 if mid_math_w==.
replace mid_lang_w=0 if mid_lang_w==.
replace mid_total_w=0 if mid_total_w==.
gen add_mid_math=mid_math_v+mid_math_w
gen add_mid_lang=mid_lang_v+mid_lang_w
gen add_mid_total=mid_total_v+mid_total_w

capture program drop zscore
program define zscore
	syntax, option1(string)
sort treat
egen m1_`option1'=mean(`option1') if treat==0
egen sd1_`option1'=sd(`option1') if treat==0
egen m_`option1'=mean(m1_`option1')
egen sd_`option1'=mean(sd1_`option1')
gen z_`option1'=(`option1'-m_`option1')/sd_`option1'
end

zscore, option1(add_mid_math)
zscore, option1(add_mid_lang)
zscore, option1(add_mid_total)

replace mid_writ=0 if mid_writ==.

**PANEL B/THIRD COLUMN;
regress mid_writ treat, cluster(schid)
regress z_add_mid_math treat, cluster(schid)
regress z_add_mid_lang treat, cluster(schid)
regress z_add_mid_total treat, cluster(schid)

foreach X in mid_writ z_add_mid_math z_add_mid_lang z_add_mid_total {
	regress `X' treat, cluster(schid)
	}

svmat Y
save DatDHR3a, replace

****************
*************

*Part B

capture program drop zscore1
capture program drop zscore

use "Closed School.dta", clear
gen close=1 if mon10=="Closed" &  mon11=="Closed"
gen schid=idnum
keep schid close
sort schid
save Temp\tempclose, replace

use pre_verbal
rename total_1_to_4 pre_math_v
rename total_5_to_11 pre_lang_v
rename total pre_total_v
gen pre_writ=0
keep schid childno pre_math_v pre_lang_v pre_total_v pre_writ
save Temp\temp1, replace

use pre_written, clear
rename total_1_to_4 pre_math_w
rename total_5_to_11 pre_lang_w
rename total pre_total_w

gen pre_writ=1
keep schid childno pre_math_w pre_lang_w pre_total_w pre_writ
save Temp\temp2, replace

use Temp\temp1, clear
append using Temp\temp2
sort schid childno
save Temp\testdata, replace

use post_verbal, clear  
for var _all: replace X = 0 if X == -999
for var _all: replace X = 0 if X == -888
for var _all: replace X = 0 if X == -777
for var _all: replace X = 0 if X == .
for var _all: replace X = 0 if X <0
egen post_math_v=rsum(ques7 ques8 ques9 ques10)
egen post_lang_v=rsum(ques1 ques2 ques3 ques4 ques5 ques6)
replace post_math_v=10*post_math_v/8
replace post_lang_v=10*post_lang_v/12
egen post_total_v=rsum(post_math_v post_lang_v)
rename idnum schid
keep schid childno post_math_v post_lang_v post_total_v
replace schid=2492 if schid==2493
sort schid childno
save Temp\temp3, replace

use post_written, clear
for var _all: replace X = 0 if X == -999
for var _all: replace X = 0 if X == -888
for var _all: replace X = 0 if X == -777
for var _all: replace X = 0 if X ==  777
for var _all: replace X = 0 if X == .
for var _all: replace X = 0 if X <0

egen post_math_w=rsum(_6a _6b _7a _7b _7c _8a _8b _8c _8d _8e _8f _8g _8h _9a _9b  _9c _9d _9e _9f  _9g  _9h c62 c63 c64 c65)
egen post_lang_w=rsum( _1a _1b _1c _1d _1e _1f _1g _1h _1i _1j _2a _2b _2c _2d _2e _2f _2g _2h _2i _2j _3a _3b _3c _3d _3e _4a _4b _4c _4d _4e _4f _4g _5a _5b _5c _5d _5e)
replace post_math_w=10*post_math_w/45
replace post_lang_w=10*post_lang_w/55
egen post_total_w=rsum(post_math_w  post_lang_w)
rename sch_id schid
rename ch_no_ childno
gen post_writ=1
keep schid childno post_math_w post_lang_w post_total_w post_writ
replace schid=2492 if schid==2493
sort schid childno
save Temp\temp4, replace

use Temp\temp3, clear
sort schid childno
merge schid childno using Temp\temp4
drop _merge

sort schid childno
merge schid childno using Temp\testdata
save Temp\testdata, replace

replace pre_math_w=56 if schid==4231 & childno==3
replace pre_total_v=11 if schid==3511 & childno==17
replace pre_total_w=34 if schid==4252 & childno==22
gen block = int(schid/1000)

drop _merge
sort schid
merge schid using treatschool
gen treat = 0
replace treat = 1 if _merge == 3

for var _all: replace X = . if X == -999
for var _all: replace X = . if X == -888
for var _all: replace X = . if X == -777
drop _merge
sort schid
merge schid using Temp\tempclose
drop if treat==.
save Temp\test_new.dta, replace

use Temp\test_new.dta
drop if schid==1211 | schid==5332 | schid==5711 | schid==1111 | schid==2111 | schid==5221 | schid==5611 | schid==1113
drop if schid==5731 & childno==24
save Temp\test_new.dta, replace

gen entry=0
replace entry=1 if (pre_total_v==. & pre_total_w==.) & post_total_v!=. 
gen missing=0
replace missing=1 if (pre_total_v!=. | pre_total_w!=.) & post_total_v==. 
gen stayer=0
replace stayer=1 if missing==0 & entry==0
drop if entry==1

program define zscore1
	syntax, option1(string)
sort treat
egen m1_`option1'=mean(`option1') if treat==0
egen sd1_`option1'=sd(`option1') if treat==0
egen m_`option1'=mean(m1_`option1')
egen sd_`option1'=mean(sd1_`option1')
gen z_`option1'=(`option1'-m_`option1')/sd_`option1'
end

zscore1, option1(pre_total_v)
zscore1, option1(pre_total_w)

gen treat_missing=treat*missing

**PANEL A/COL 6

regress missing treat, cluster(schid)
regress pre_writ treat_missing missing treat, cluster(schid)
regress z_pre_total_v treat_missing missing treat, cluster(schid)
regress z_pre_total_w treat_missing missing treat, cluster(schid)
save Temp\test_new, replace

use Temp\test_new, clear
drop if stayer==0
replace pre_math_w=pre_math_w/5
replace pre_lang_w=pre_lang_w/5
replace pre_total_w=pre_total_w/5
replace pre_math_v=0 if pre_math_v==.
replace pre_lang_v=0 if pre_lang_v==.
replace pre_total_v=0 if pre_total_v==.
replace pre_math_w=0 if pre_math_w==.
replace pre_lang_w=0 if pre_lang_w==.
replace pre_total_w=0 if pre_total_w==.
replace post_math_v=0 if post_math_v==.
replace post_lang_v=0 if post_lang_v==.
replace post_total_v=0 if post_total_v==.
replace post_math_w=0 if post_math_w==.
replace post_lang_w=0 if post_lang_w==.
replace post_total_w=0 if post_total_w==.
gen add_post_math=post_math_v+post_math_w
gen add_post_lang=post_lang_v+post_lang_w
gen add_post_total=post_total_v+post_total_w

gen post_dummy=1
drop _merge
sort schid childno
merge schid childno using normalization
save Temp\data_norm, replace

program define zscore
	syntax, option1(string) option2(string)
sort treat
egen m1_`option1'=mean(`option2') if treat==0 & `option2'!=.
egen sd1_`option1'=sd(`option2') if treat==0 & `option2'!=.
egen m_`option1'=mean(m1_`option1')
egen sd_`option1'=mean(sd1_`option1')
gen z_`option1'=(`option1'-m_`option1')/sd_`option1'
end

zscore, option1(add_post_math) option2(math_old)
zscore, option1(add_post_lang) option2(lang_old)
zscore, option1(add_post_total) option2(total_old)

replace post_writ=0 if post_writ==.
keep if post_dummy==1

**PANEL B/COL 4 AND COL 5

regress post_writ treat, cluster(schid)
regress z_add_post_math treat, cluster(schid)
regress z_add_post_lang treat, cluster(schid)
regress z_add_post_total treat, cluster(schid)

foreach X in post_writ z_add_post_math z_add_post_lang z_add_post_total {
	regress `X' treat, cluster(schid)
	}

svmat Y
save DatDHR3b, replace

********************************************

*Table 9 - Error in observations in RHS of Panel B - also, block entered as number !
*Parts A, B, C, & D (lots of loading and manipulating files in their code)

*Part A

use "Closed School.dta", clear
gen close=1 if mon10=="Closed" &  mon11=="Closed"
gen schid=idnum
keep schid close
sort schid
save Temp\tempclose, replace

use pre_verbal
rename total_1_to_4 pre_math_v
rename total_5_to_11 pre_lang_v
rename total pre_total_v
gen pre_writ=0
keep schid childno pre_math_v pre_lang_v pre_total_v pre_writ
save Temp\temp1, replace

use pre_written, clear
rename total_1_to_4 pre_math_w
rename total_5_to_11 pre_lang_w
rename total pre_total_w
gen pre_writ=1
keep schid childno pre_math_w pre_lang_w pre_total_w pre_writ
save Temp\temp2, replace

use Temp\temp1, clear
append using Temp\temp2
sort schid childno
save Temp\testdata, replace

use mid_verbal, clear
rename tot_1_to_4 mid_math_v
rename tot_5_to_11 mid_lang_v
rename total mid_total_v
keep schid childno mid_math_v mid_lang_v mid_total_v
replace schid=2492 if schid==2493
sort schid childno
save Temp\temp3, replace

use mid_written, clear
rename total_1_to_5 mid_math_w
rename total_6_to_16 mid_lang_w
rename total mid_total_w
gen mid_writ=1
keep schid childno mid_math_w mid_lang_w mid_total_w mid_writ
replace schid=2492 if schid==2493
sort schid childno
save Temp\temp4, replace

use Temp\temp3, clear
sort schid childno
merge schid childno using Temp\temp4
drop _merge

sort schid childno
merge schid childno using Temp\testdata
save Temp\testdata, replace

replace pre_math_w=56 if schid==4231 & childno==3
replace pre_total_v=11 if schid==3511 & childno==17
replace pre_total_w=34 if schid==4252 & childno==22
gen block = int(schid/1000)

drop _merge
sort schid
merge schid using treatschool
gen treat = 0
replace treat = 1 if _merge == 3

for var _all: replace X = . if X == -999
for var _all: replace X = . if X == -888
for var _all: replace X = . if X == -777

drop _merge
sort schid
merge schid using Temp/tempclose
drop if treat==.
save Temp\test_new.dta, replace

use Temp\test_new.dta
drop if schid==1211 | schid==5332 | schid==5711 | schid==1111 | schid==2111 | schid==5221 | schid==5611 | schid==1113
drop if schid==5731 & childno==24
save Temp\test_new.dta, replace

gen entry=0
replace entry=1 if (pre_total_v==. & pre_total_w==.) & mid_total_v!=. 
gen missing=0
replace missing=1 if (pre_total_v!=. | pre_total_w!=.) & mid_total_v==. 
gen stayer=0
replace stayer=1 if missing==0 & entry==0
save Temp\test_new, replace

drop if stayer==0
replace pre_math_w=pre_math_w/5
replace pre_lang_w=pre_lang_w/5
replace pre_total_w=pre_total_w/5
replace mid_math_w=mid_math_w/5
replace mid_lang_w=mid_lang_w/5
replace mid_total_w=mid_total_w/5
replace pre_math_v=0 if pre_math_v==.
replace pre_lang_v=0 if pre_lang_v==.
replace pre_total_v=0 if pre_total_v==.
replace pre_math_w=0 if pre_math_w==.
replace pre_lang_w=0 if pre_lang_w==.
replace pre_total_w=0 if pre_total_w==.
replace mid_math_v=0 if mid_math_v==.
replace mid_lang_v=0 if mid_lang_v==.
replace mid_total_v=0 if mid_total_v==.
replace mid_math_w=0 if mid_math_w==.
replace mid_lang_w=0 if mid_lang_w==.
replace mid_total_w=0 if mid_total_w==.
gen add_mid_math=mid_math_v+mid_math_w
gen add_mid_lang=mid_lang_v+mid_lang_w
gen add_mid_total=mid_total_v+mid_total_w

capture program drop zscore
program define zscore
	syntax, option1(string)
sort treat
egen m1_`option1'=mean(`option1') if treat==0
egen sd1_`option1'=sd(`option1') if treat==0
egen m_`option1'=mean(m1_`option1')
egen sd_`option1'=mean(sd1_`option1')
gen z_`option1'=(`option1'-m_`option1')/sd_`option1'
end

zscore, option1(add_mid_math)
zscore, option1(add_mid_lang)
zscore, option1(add_mid_total)
replace mid_writ=0 if mid_writ==.

**PANEL A;
regress mid_writ treat pre_math_v pre_math_w pre_writ, cluster(schid)
regress z_add_mid_math treat pre_math_v pre_math_w pre_writ, cluster(schid)
regress z_add_mid_lang treat pre_lang_v pre_lang_w pre_writ, cluster(schid)
regress z_add_mid_total treat pre_total_v pre_total_w pre_writ, cluster(schid)

**PANEL C;
regress z_add_mid_math treat pre_math_v pre_math_w if pre_writ==0, cluster(schid)
regress z_add_mid_lang treat pre_lang_v pre_lang_w if pre_writ==0, cluster(schid)
regress z_add_mid_total treat pre_total_v pre_total_w if pre_writ==0, cluster(schid)

**PANEL D;
regress z_add_mid_math treat pre_math_v pre_math_w if pre_writ==1, cluster(schid)
regress z_add_mid_lang treat pre_lang_v pre_lang_w if pre_writ==1, cluster(schid)
regress z_add_mid_total treat pre_total_v pre_total_w if pre_writ==1, cluster(schid)

regress mid_writ treat pre_math_v pre_math_w pre_writ, cluster(schid)
foreach X in math lang total {
	regress z_add_mid_`X' treat pre_`X'_v pre_`X'_w pre_writ, cluster(schid)
	}

foreach X in math lang total {
	regress z_add_mid_`X' treat pre_`X'_v if pre_writ==0, cluster(schid)
	}

foreach X in math lang total {
	regress z_add_mid_`X' treat pre_`X'_w if pre_writ==1, cluster(schid)
	}

svmat Y
save DatDHR4a, replace

****************************

*Part B

use "Closed School.dta", clear
gen close=1 if mon10=="Closed" &  mon11=="Closed"
gen schid=idnum
keep schid close
sort schid
save Temp/tempclose, replace

use pre_verbal.dta, clear
rename total_1_to_4 pre_math_v
rename total_5_to_11 pre_lang_v
rename total pre_total_v
gen pre_writ=0
keep schid childno pre_math_v pre_lang_v pre_total_v pre_writ
save Temp\temp1, replace

use pre_written, clear
rename total_1_to_4 pre_math_w
rename total_5_to_11 pre_lang_w
rename total pre_total_w
gen pre_writ=1
keep schid childno pre_math_w pre_lang_w pre_total_w pre_writ
save Temp\temp2, replace

use Temp\temp1, clear
append using Temp\temp2
sort schid childno
save Temp\testdata, replace

use mid_verbal
rename tot_1_to_4 mid_math_v
rename tot_5_to_11 mid_lang_v
rename total mid_total_v
keep schid childno mid_math_v mid_lang_v mid_total_v
replace schid=2492 if schid==2493
sort schid childno
save Temp\temp3, replace

use mid_written
rename total_1_to_5 mid_math_w
rename total_6_to_16 mid_lang_w
rename total mid_total_w
gen mid_writ=1
keep schid childno mid_math_w mid_lang_w mid_total_w mid_writ
replace schid=2492 if schid==2493
sort schid childno
save Temp\temp4, replace

use Temp\temp3, clear
sort schid childno
merge schid childno using Temp\temp4
drop _merge

sort schid childno
merge schid childno using Temp\testdata
save Temp\testdata, replace

replace pre_math_w=56 if schid==4231 & childno==3
replace pre_total_v=11 if schid==3511 & childno==17
replace pre_total_w=34 if schid==4252 & childno==22
gen block = int(schid/1000)

drop _merge
sort schid
merge schid using treatschool
gen treat = 0
replace treat = 1 if _merge == 3

for var _all: replace X = . if X == -999
for var _all: replace X = . if X == -888
for var _all: replace X = . if X == -777

drop _merge
sort schid
merge schid using Temp\tempclose
drop if treat==.
save Temp\test_new.dta, replace

drop if schid==1211| schid==5332 | schid==5711 | schid==1111 | schid==2111 | schid==5221 | schid==5611 | schid==1113
drop if schid==5731 & childno==24
save Temp\test_new.dta, replace

gen entry=0
replace entry=1 if (pre_total_v==. & pre_total_w==.) & mid_total_v!=. 
gen missing=0
replace missing=1 if (pre_total_v!=. | pre_total_w!=.) & mid_total_v==. 
gen stayer=0
replace stayer=1 if missing==0 & entry==0
save Temp\test_new, replace

drop if stayer==0
replace pre_math_w=pre_math_w/5
replace pre_lang_w=pre_lang_w/5
replace pre_total_w=pre_total_w/5
replace mid_math_w=mid_math_w/5
replace mid_lang_w=mid_lang_w/5
replace mid_total_w=mid_total_w/5
replace pre_math_v=0 if pre_math_v==.
replace pre_lang_v=0 if pre_lang_v==.
replace pre_total_v=0 if pre_total_v==.
replace pre_math_w=0 if pre_math_w==.
replace pre_lang_w=0 if pre_lang_w==.
replace pre_total_w=0 if pre_total_w==.
replace mid_math_v=0 if mid_math_v==.
replace mid_lang_v=0 if mid_lang_v==.
replace mid_total_v=0 if mid_total_v==.
replace mid_math_w=0 if mid_math_w==.
replace mid_lang_w=0 if mid_lang_w==.
replace mid_total_w=0 if mid_total_w==.
gen add_mid_math=mid_math_v+mid_math_w
gen add_mid_lang=mid_lang_v+mid_lang_w
gen add_mid_total=mid_total_v+mid_total_w

capture program drop zscore
program define zscore
	syntax, option1(string)
sort treat
egen m1_`option1'=mean(`option1') if treat==0
egen sd1_`option1'=sd(`option1') if treat==0
egen m_`option1'=mean(m1_`option1')
egen sd_`option1'=mean(sd1_`option1')
gen z_`option1'=(`option1'-m_`option1')/sd_`option1'
end

zscore, option1(add_mid_math)
zscore, option1(add_mid_lang)
zscore, option1(add_mid_total)
replace mid_writ=0 if mid_writ==.

drop block
gen block = int(schid/1000)

drop _merge
sort schid
merge schid using BaselineChar.dta


**TABLE 9 PANEL B;
regress mid_writ treat pre_math_v pre_math_w pre_writ block score infra, cluster(schid)
regress z_add_mid_math treat pre_math_v pre_math_w pre_writ block score infra, cluster(schid)
regress z_add_mid_lang treat pre_lang_v pre_lang_w pre_writ block score infra, cluster(schid)
regress z_add_mid_total treat pre_total_v pre_total_w pre_writ block score infra, cluster(schid)

drop _merge
sort schid childno
save Temp\genderdata, replace

use Temp\Roster_CODED.dta, clear
drop if sex==-999
collapse (mean) sex, by(schid childno)
sort schid childno

merge schid childno using Temp\genderdata
replace sex=1 if sex<1.5 & sex!=.
replace sex=2 if sex>=1.5 & sex!=.

**GIRLS PANEL E;
regress mid_writ treat pre_math_v pre_math_w pre_writ if sex == 2, cluster(schid)
regress z_add_mid_math treat pre_math_v pre_math_w pre_writ if sex == 2, cluster(schid)
regress z_add_mid_lang treat pre_lang_v pre_lang_w pre_writ if sex == 2, cluster(schid)
regress z_add_mid_total treat pre_total_v pre_total_w pre_writ if sex == 2, cluster(schid)

**BOYS PANEL F;
regress mid_writ treat pre_math_v pre_math_w pre_writ if sex == 1, cluster(schid)
regress z_add_mid_math treat pre_math_v pre_math_w pre_writ if sex == 1, cluster(schid)
regress z_add_mid_lang treat pre_lang_v pre_lang_w pre_writ if sex == 1, cluster(schid)
regress z_add_mid_total treat pre_total_v pre_total_w pre_writ if sex == 1, cluster(schid)

*When merged reloaded all original data, so can run as one randomization

drop if treat == .

regress mid_writ treat pre_math_v pre_math_w pre_writ block score infra, cluster(schid)
foreach X in math lang total {
	regress z_add_mid_`X' treat pre_`X'_v pre_`X'_w pre_writ block score infra, cluster(schid)
	}
foreach S in 2 1 {
	regress mid_writ treat pre_math_v pre_math_w pre_writ if sex == `S', cluster(schid)
	foreach X in math lang total {
		regress z_add_mid_`X' treat pre_`X'_v pre_`X'_w pre_writ if sex == `S', cluster(schid)
		}
	}

svmat Y
save DatDHR4b, replace

*****************************

*Part C

use "Closed School.dta", clear
gen close=1 if mon10=="Closed" &  mon11=="Closed"
gen schid=idnum
keep schid close
sort schid
save Temp\tempclose, replace

use pre_verbal, clear
rename total_1_to_4 pre_math_v
rename total_5_to_11 pre_lang_v
rename total pre_total_v
gen pre_writ=0
keep schid childno pre_math_v pre_lang_v pre_total_v pre_writ
save Temp\temp1, replace

use pre_written, clear
rename total_1_to_4 pre_math_w
rename total_5_to_11 pre_lang_w
rename total pre_total_w
gen pre_writ=1
keep schid childno pre_math_w pre_lang_w pre_total_w pre_writ
save Temp\temp2, replace

use Temp\temp1, clear
append using Temp\temp2
sort schid childno
save Temp\testdata, replace

use post_verbal, clear
for var _all: replace X = 0 if X == -999
for var _all: replace X = 0 if X == -888
for var _all: replace X = 0 if X == -777
for var _all: replace X = 0 if X == .
for var _all: replace X = 0 if X <0
egen post_math_v=rsum(ques7 ques8 ques9 ques10)
egen post_lang_v=rsum(ques1 ques2 ques3 ques4 ques5 ques6)
replace post_math_v=10*post_math_v/8
replace post_lang_v=10*post_lang_v/12
egen post_total_v=rsum(post_math_v post_lang_v)
rename idnum schid
keep schid childno post_math_v post_lang_v post_total_v
replace schid=2492 if schid==2493
sort schid childno
save Temp\temp3, replace

use post_written, clear
for var _all: replace X = 0 if X == -999
for var _all: replace X = 0 if X == -888
for var _all: replace X = 0 if X == -777
for var _all: replace X = 0 if X ==  777
for var _all: replace X = 0 if X == .
for var _all: replace X = 0 if X <0
egen post_math_w=rsum(_6a _6b _7a _7b _7c _8a _8b _8c _8d _8e _8f _8g _8h _9a _9b  _9c _9d _9e _9f  _9g  _9h c62 c63 c64 c65)
egen post_lang_w=rsum( _1a _1b _1c _1d _1e _1f _1g _1h _1i _1j _2a _2b _2c _2d _2e _2f _2g _2h _2i _2j _3a _3b _3c _3d _3e _4a _4b _4c _4d _4e _4f _4g _5a _5b _5c _5d _5e)
replace post_math_w=10*post_math_w/45
replace post_lang_w=10*post_lang_w/55
egen post_total_w=rsum(post_math_w  post_lang_w)
rename sch_id schid
rename ch_no_ childno
gen post_writ=1
keep schid childno post_math_w post_lang_w post_total_w post_writ
replace schid=2492 if schid==2493
sort schid childno
save Temp\temp4, replace

use Temp\temp3, clear
sort schid childno
merge schid childno using Temp\temp4
drop _merge
sort schid childno
merge schid childno using Temp\testdata
save Temp\testdata, replace

replace pre_math_w=56 if schid==4231 & childno==3
replace pre_total_v=11 if schid==3511 & childno==17
replace pre_total_w=34 if schid==4252 & childno==22
gen block = int(schid/1000)

drop _merge
sort schid
merge schid using treatschool
gen treat = 0
replace treat = 1 if _merge == 3

for var _all: replace X = . if X == -999
for var _all: replace X = . if X == -888
for var _all: replace X = . if X == -777

drop _merge
sort schid
merge schid using Temp\tempclose
drop if treat==.
save Temp\test_new.dta, replace

use Temp\test_new.dta, clear
drop if schid==1211 | schid==5332 | schid==5711 | schid==1111 | schid==2111 | schid==5221 | schid==5611 | schid==1113 
drop if schid==5731 & childno==24
save Temp\test_new.dta, replace

gen entry=0
replace entry=1 if (pre_total_v==. & pre_total_w==.) & post_total_v!=. 
gen missing=0
replace missing=1 if (pre_total_v!=. | pre_total_w!=.) & post_total_v==. 
gen stayer=0
replace stayer=1 if missing==0 & entry==0
save Temp\test_new, replace

drop if stayer==0
replace pre_math_w=pre_math_w/5
replace pre_lang_w=pre_lang_w/5
replace pre_total_w=pre_total_w/5
replace pre_math_v=0 if pre_math_v==.
replace pre_lang_v=0 if pre_lang_v==.
replace pre_total_v=0 if pre_total_v==.
replace pre_math_w=0 if pre_math_w==.
replace pre_lang_w=0 if pre_lang_w==.
replace pre_total_w=0 if pre_total_w==.
replace post_math_v=0 if post_math_v==.
replace post_lang_v=0 if post_lang_v==.
replace post_total_v=0 if post_total_v==.
replace post_math_w=0 if post_math_w==.
replace post_lang_w=0 if post_lang_w==.
replace post_total_w=0 if post_total_w==.
gen add_post_math=post_math_v+post_math_w
gen add_post_lang=post_lang_v+post_lang_w
gen add_post_total=post_total_v+post_total_w

gen post_dummy=1
drop _merge
sort schid childno
merge schid childno using normalization
save Temp\data_norm, replace

capture program drop zscore
keep if post_dummy==1 
program define zscore
	syntax, option1(string) option2(string)
sort treat
egen m1_`option1'=mean(`option2') if treat==0 & `option2'!=.
egen sd1_`option1'=sd(`option2') if treat==0 & `option2'!=.
egen m_`option1'=mean(m1_`option1')
egen sd_`option1'=mean(sd1_`option1')
gen z_`option1'=(`option1'-m_`option1')/sd_`option1'
end

zscore, option1(add_post_math) option2(math_old)
zscore, option1(add_post_lang) option2(lang_old)
zscore, option1(add_post_total) option2(total_old)
replace post_writ=0 if post_writ==.

**PANEL A;
regress post_writ treat pre_math_v pre_math_w pre_writ, cluster(schid)
regress z_add_post_math treat pre_math_v pre_math_w pre_writ, cluster(schid)
regress z_add_post_lang treat pre_lang_v pre_lang_w pre_writ, cluster(schid)
regress z_add_post_total treat pre_total_v pre_total_w pre_writ, cluster(schid)

**PANEL C;
regress z_add_post_math treat pre_math_v pre_math_w if pre_writ==0, cluster(schid)
regress z_add_post_lang treat pre_lang_v pre_lang_w if pre_writ==0, cluster(schid)
regress z_add_post_total treat pre_total_v pre_total_w if pre_writ==0, cluster(schid)

**PANEL D;
regress z_add_post_math treat pre_math_v pre_math_w if pre_writ==1, cluster(schid)
regress z_add_post_lang treat pre_lang_v pre_lang_w if pre_writ==1, cluster(schid)
regress z_add_post_total treat pre_total_v pre_total_w if pre_writ==1, cluster(schid)

regress post_writ treat pre_math_v pre_math_w pre_writ, cluster(schid)
foreach X in math lang total {
	regress z_add_post_`X' treat pre_`X'_v pre_`X'_w pre_writ, cluster(schid)
	}
foreach X in math lang total {
	regress z_add_post_`X' treat pre_`X'_v if pre_writ==0, cluster(schid)
	}
foreach X in math lang total {
	regress z_add_post_`X' treat pre_`X'_w if pre_writ==1, cluster(schid)
	}

svmat Y
save DatDHR4c, replace

****************************

*Part D - Errors for number of observations in Panel B of right-hand side of table

use "Closed School.dta", clear
gen close=1 if mon10=="Closed" &  mon11=="Closed"
gen schid=idnum
keep schid close
sort schid
save Temp\tempclose, replace

use pre_verbal, clear
rename total_1_to_4 pre_math_v
rename total_5_to_11 pre_lang_v
rename total pre_total_v
gen pre_writ=0
keep schid childno pre_math_v pre_lang_v pre_total_v pre_writ
save Temp\temp1, replace

use pre_written, clear
rename total_1_to_4 pre_math_w
rename total_5_to_11 pre_lang_w
rename total pre_total_w
gen pre_writ=1
keep schid childno pre_math_w pre_lang_w pre_total_w pre_writ
save Temp\temp2, replace

use Temp\temp1, clear
append using Temp\temp2
sort schid childno
save Temp\testdata, replace

use post_verbal, clear
for var _all: replace X = 0 if X == -999
for var _all: replace X = 0 if X == -888
for var _all: replace X = 0 if X == -777
for var _all: replace X = 0 if X == .
for var _all: replace X = 0 if X <0
egen post_math_v=rsum(ques7 ques8 ques9 ques10)
egen post_lang_v=rsum(ques1 ques2 ques3 ques4 ques5 ques6)
replace post_math_v=10*post_math_v/8
replace post_lang_v=10*post_lang_v/12
egen post_total_v=rsum(post_math_v post_lang_v)
rename idnum schid
keep schid childno post_math_v post_lang_v post_total_v
replace schid=2492 if schid==2493
sort schid childno
save Temp\temp3, replace

use post_written
for var _all: replace X = 0 if X == -999
for var _all: replace X = 0 if X == -888
for var _all: replace X = 0 if X == -777
for var _all: replace X = 0 if X ==  777
for var _all: replace X = 0 if X == .
for var _all: replace X = 0 if X <0
egen post_math_w=rsum(_6a _6b _7a _7b _7c _8a _8b _8c _8d _8e _8f _8g _8h _9a _9b  _9c _9d _9e _9f  _9g  _9h c62 c63 c64 c65)
egen post_lang_w=rsum( _1a _1b _1c _1d _1e _1f _1g _1h _1i _1j _2a _2b _2c _2d _2e _2f _2g _2h _2i _2j _3a _3b _3c _3d _3e _4a _4b _4c _4d _4e _4f _4g _5a _5b _5c _5d _5e)
replace post_math_w=10*post_math_w/45
replace post_lang_w=10*post_lang_w/55
egen post_total_w=rsum(post_math_w  post_lang_w)
rename sch_id schid
rename ch_no_ childno
gen post_writ=1
keep schid childno post_math_w post_lang_w post_total_w post_writ
replace schid=2492 if schid==2493
sort schid childno
save Temp\temp4, replace

use Temp\temp3, clear
sort schid childno
merge schid childno using Temp\temp4
drop _merge
sort schid childno
merge schid childno using Temp\testdata
save Temp\testdata, replace

replace pre_math_w=56 if schid==4231 & childno==3
replace pre_total_v=11 if schid==3511 & childno==17
replace pre_total_w=34 if schid==4252 & childno==22
gen block = int(schid/1000)

drop _merge
sort schid
merge schid using treatschool
gen treat = 0
replace treat = 1 if _merge == 3

for var _all: replace X = . if X == -999
for var _all: replace X = . if X == -888
for var _all: replace X = . if X == -777

drop _merge
sort schid
merge schid using Temp\tempclose
drop if treat==.
save Temp\test_new.dta, replace

use Temp\test_new.dta, clear
drop if schid==1211 | schid==5332 | schid==5711 | schid==1111 | schid==2111 | schid==5221 | schid==5611 | schid==1113
drop if schid==5731 & childno==24
save Temp\test_new.dta, replace

gen entry=0
replace entry=1 if (pre_total_v==. & pre_total_w==.) & post_total_v!=. 
gen missing=0
replace missing=1 if (pre_total_v!=. | pre_total_w!=.) & post_total_v==. 
gen stayer=0
replace stayer=1 if missing==0 & entry==0
save Temp\test_new, replace

drop if stayer==0
replace pre_math_w=pre_math_w/5
replace pre_lang_w=pre_lang_w/5
replace pre_total_w=pre_total_w/5
replace pre_math_v=0 if pre_math_v==.
replace pre_lang_v=0 if pre_lang_v==.
replace pre_total_v=0 if pre_total_v==.
replace pre_math_w=0 if pre_math_w==.
replace pre_lang_w=0 if pre_lang_w==.
replace pre_total_w=0 if pre_total_w==.
replace post_math_v=0 if post_math_v==.
replace post_lang_v=0 if post_lang_v==.
replace post_total_v=0 if post_total_v==.
replace post_math_w=0 if post_math_w==.
replace post_lang_w=0 if post_lang_w==.
replace post_total_w=0 if post_total_w==.
gen add_post_math=post_math_v+post_math_w
gen add_post_lang=post_lang_v+post_lang_w
gen add_post_total=post_total_v+post_total_w

gen post_dummy=1
drop _merge
sort schid childno
merge schid childno using normalization
save Temp\data_norm, replace

capture program drop zscore
keep if post_dummy==1
program define zscore
	syntax, option1(string) option2(string)
sort treat
egen m1_`option1'=mean(`option2') if treat==0 & `option2'!=.
egen sd1_`option1'=sd(`option2') if treat==0 & `option2'!=.
egen m_`option1'=mean(m1_`option1')
egen sd_`option1'=mean(sd1_`option1')
gen z_`option1'=(`option1'-m_`option1')/sd_`option1'
end

zscore, option1(add_post_math) option2(math_old)
zscore, option1(add_post_lang) option2(lang_old)
zscore, option1(add_post_total) option2(total_old)
replace post_writ=0 if post_writ==.
drop block
gen block = int(schid/1000)

drop _merge
sort schid
merge schid using BaselineChar.dta

**TABLE 9 PANEL B;
regress post_writ treat pre_math_v pre_math_w pre_writ block score infra, cluster(schid)
regress z_add_post_math treat pre_math_v pre_math_w pre_writ block score infra, cluster(schid)
regress z_add_post_lang treat pre_lang_v pre_lang_w pre_writ block score infra, cluster(schid)
regress z_add_post_total treat pre_total_v pre_total_w pre_writ block score infra, cluster(schid)

drop _merge
sort schid childno
save Temp\genderdata, replace

use Temp\Roster_CODED.dta, clear
drop if sex==-999
collapse (mean) sex, by(schid childno)
sort schid childno
merge schid childno using Temp\genderdata
replace sex=1 if sex<1.5 & sex!=.
replace sex=2 if sex>=1.5 & sex!=.


**GIRLS PANEL E;

regress post_writ treat pre_math_v pre_math_w pre_writ if sex == 2, cluster(schid)
regress z_add_post_math treat pre_math_v pre_math_w pre_writ if sex == 2, cluster(schid)
regress z_add_post_lang treat pre_lang_v pre_lang_w pre_writ if sex == 2, cluster(schid)
regress z_add_post_total treat pre_total_v pre_total_w pre_writ if sex == 2, cluster(schid)


**BOYS PANEL F;

regress post_writ treat pre_math_v pre_math_w pre_writ if sex == 1, cluster(schid)
regress z_add_post_math treat pre_math_v pre_math_w pre_writ if sex == 1, cluster(schid)
regress z_add_post_lang treat pre_lang_v pre_lang_w pre_writ if sex == 1, cluster(schid)
regress z_add_post_total treat pre_total_v pre_total_w pre_writ if sex == 1, cluster(schid)

drop if treat == .
*Can run everything together as panel B data was reloaded in the merge

regress post_writ treat pre_math_v pre_math_w pre_writ block score infra, cluster(schid)
foreach X in math lang total {
	regress z_add_post_`X' treat pre_`X'_v pre_`X'_w pre_writ block score infra, cluster(schid)
	}

foreach S in 2 1 {
	regress post_writ treat pre_math_v pre_math_w pre_writ if sex == `S', cluster(schid)
	foreach X in math lang total {
		regress z_add_post_`X' treat pre_`X'_v pre_`X'_w pre_writ if sex == `S', cluster(schid)
		}
	}

svmat Y
save DatDHR4d, replace


************************

*Table 11: Part a - All okay

use "Closed School.dta", clear
gen close=1 if mon10=="Closed" &  mon11=="Closed"
gen schid=idnum
keep schid close
sort schid
save Temp\tempclose, replace

use pre_verbal, clear
rename total_1_to_4 pre_math_v
rename total_5_to_11 pre_lang_v
rename total pre_total_v
gen pre_writ=0
keep schid childno pre_math_v pre_lang_v pre_total_v pre_writ
save Temp\temp1, replace

use pre_written, clear
rename total_1_to_4 pre_math_w
rename total_5_to_11 pre_lang_w
rename total pre_total_w
gen pre_writ=1
keep schid childno pre_math_w pre_lang_w pre_total_w pre_writ
save Temp\temp2, replace

use Temp\temp1, clear
append using Temp\temp2
sort schid childno
save Temp\testdata, replace

use mid_verbal, clear
rename tot_1_to_4 mid_math_v
rename tot_5_to_11 mid_lang_v
rename total mid_total_v
keep schid childno mid_math_v mid_lang_v mid_total_v
replace schid=2492 if schid==2493
sort schid childno
save Temp\temp3, replace

use mid_written, clear
rename total_1_to_5 mid_math_w
rename total_6_to_16 mid_lang_w
rename total mid_total_w
gen mid_writ=1
keep schid childno mid_math_w mid_lang_w mid_total_w mid_writ
replace schid=2492 if schid==2493
sort schid childno
save Temp\temp4, replace

use Temp\temp3
sort schid childno
merge schid childno using Temp\temp4
drop _merge
sort schid childno
merge schid childno using Temp\testdata
save Temp\testdata, replace

replace pre_math_w=56 if schid==4231 & childno==3
replace pre_total_v=11 if schid==3511 & childno==17
replace pre_total_w=34 if schid==4252 & childno==22
gen block = int(schid/1000)

drop _merge
sort schid
merge schid using treatschool
gen treat = 0
replace treat = 1 if _merge == 3
for var _all: replace X = . if X == -999
for var _all: replace X = . if X == -888
for var _all: replace X = . if X == -777
drop _merge
sort schid
merge schid using Temp\tempclose
drop if treat==.
save Temp\test_new.dta, replace

use Temp\test_new.dta, clear
drop if schid==1211 | schid==5332 | schid==5711 | schid==1111 | schid==2111 | schid==5221 | schid==5611 | schid==1113 | (schid==5731 & childno==24)
save Temp\test_new.dta, replace

gen entry=0
replace entry=1 if (pre_total_v==. & pre_total_w==.) & mid_total_v!=. 
gen missing=0
replace missing=1 if (pre_total_v!=. | pre_total_w!=.) & mid_total_v==. 
gen stayer=0
replace stayer=1 if missing==0 & entry==0
tab entry
tab missing
tab stayer
save Temp\test_new, replace

drop if stayer==0
replace pre_math_w=pre_math_w/5
replace pre_lang_w=pre_lang_w/5
replace pre_total_w=pre_total_w/5
replace mid_math_w=mid_math_w/5
replace mid_lang_w=mid_lang_w/5
replace mid_total_w=mid_total_w/5
replace pre_math_v=0 if pre_math_v==.
replace pre_lang_v=0 if pre_lang_v==.
replace pre_total_v=0 if pre_total_v==.
replace pre_math_w=0 if pre_math_w==.
replace pre_lang_w=0 if pre_lang_w==.
replace pre_total_w=0 if pre_total_w==.
replace mid_math_v=0 if mid_math_v==.
replace mid_lang_v=0 if mid_lang_v==.
replace mid_total_v=0 if mid_total_v==.
replace mid_math_w=0 if mid_math_w==.
replace mid_lang_w=0 if mid_lang_w==.
replace mid_total_w=0 if mid_total_w==.
gen add_mid_math=mid_math_v+mid_math_w
gen add_mid_lang=mid_lang_v+mid_lang_w
gen add_mid_total=mid_total_v+mid_total_w

capture program drop zscore
program define zscore
	syntax, option1(string)
	sort treat
	egen m1_`option1'=mean(`option1') if treat==0
	egen sd1_`option1'=sd(`option1') if treat==0
	egen m_`option1'=mean(m1_`option1')
	egen sd_`option1'=mean(sd1_`option1')
	gen z_`option1'=(`option1'-m_`option1')/sd_`option1'
end

zscore, option1(add_mid_math)
zscore, option1(add_mid_lang)
zscore, option1(add_mid_total)
replace mid_writ=0 if mid_writ==.

drop _merge
sort schid
merge schid using av_random
drop _merge
sort schid
merge schid using av_payments
drop if stayer==.
replace payment=1000 if treat==0

*Column 4 IV regression is the only one with a treatment measure
*All others are simple regressions on "open"
ivreg mid_writ (open=treat) pre_math_v pre_math_w pre_writ, cluster(schid)
ivreg z_add_mid_total (open=treat) pre_total_v pre_total_w pre_writ, cluster(schid)


*Duplicates intent to treat elsewhere in paper

ivreg mid_writ (open=treat) pre_math_v pre_math_w pre_writ, cluster(schid)
ivreg z_add_mid_total (open=treat) pre_total_v pre_total_w pre_writ, cluster(schid)

*itt: reg mid_writ treat pre_math_v pre_math_w pre_writ, cluster(schid)
*itt: reg z_add_mid_total treat pre_total_v pre_total_w pre_writ, cluster(schid)


****************************************************************

*Table 11: Part b - All okay

use "Closed School.dta", clear
gen close=1 if mon10=="Closed" &  mon11=="Closed"
gen schid=idnum
keep schid close
sort schid
save Temp\tempclose, replace

use pre_verbal, clear
rename total_1_to_4 pre_math_v
rename total_5_to_11 pre_lang_v
rename total pre_total_v
gen pre_writ=0
keep schid childno pre_math_v pre_lang_v pre_total_v pre_writ
save Temp\temp1, replace

use pre_written, clear
rename total_1_to_4 pre_math_w
rename total_5_to_11 pre_lang_w
rename total pre_total_w
gen pre_writ=1
keep schid childno pre_math_w pre_lang_w pre_total_w pre_writ
save Temp\temp2, replace

use Temp\temp1, clear
append using Temp\temp2
sort schid childno
save Temp\testdata, replace

use post_verbal, clear
for var _all: replace X = 0 if X == -999
for var _all: replace X = 0 if X == -888
for var _all: replace X = 0 if X == -777
for var _all: replace X = 0 if X == .
for var _all: replace X = 0 if X <0
egen post_math_v=rsum(ques7 ques8 ques9 ques10)
egen post_lang_v=rsum(ques1 ques2 ques3 ques4 ques5 ques6)
replace post_math_v=10*post_math_v/8
replace post_lang_v=10*post_lang_v/12
egen post_total_v=rsum(post_math_v post_lang_v)
rename idnum schid
keep schid childno post_math_v post_lang_v post_total_v
replace schid=2492 if schid==2493
sort schid childno
save Temp\temp3, replace

use post_written, clear
for var _all: replace X = 0 if X == -999
for var _all: replace X = 0 if X == -888
for var _all: replace X = 0 if X == -777
for var _all: replace X = 0 if X ==  777
for var _all: replace X = 0 if X == .
for var _all: replace X = 0 if X <0
egen post_math_w=rsum(_6a _6b _7a _7b _7c _8a _8b _8c _8d _8e _8f _8g _8h _9a _9b  _9c _9d _9e _9f  _9g  _9h c62 c63 c64 c65)
egen post_lang_w=rsum( _1a _1b _1c _1d _1e _1f _1g _1h _1i _1j _2a _2b _2c _2d _2e _2f _2g _2h _2i _2j _3a _3b _3c _3d _3e _4a _4b _4c _4d _4e _4f _4g _5a _5b _5c _5d _5e)
replace post_math_w=10*post_math_w/45
replace post_lang_w=10*post_lang_w/55
egen post_total_w=rsum(post_math_w  post_lang_w)
rename sch_id schid
rename ch_no_ childno
gen post_writ=1
keep schid childno post_math_w post_lang_w post_total_w post_writ
replace schid=2492 if schid==2493
sort schid childno
save Temp\temp4, replace

use Temp\temp3, clear
sort schid childno
merge schid childno using Temp\temp4
drop _merge
sort schid childno
merge schid childno using Temp\testdata
save Temp\testdata, replace

replace pre_math_w=56 if schid==4231 & childno==3
replace pre_total_v=11 if schid==3511 & childno==17
replace pre_total_w=34 if schid==4252 & childno==22
gen block = int(schid/1000)
drop _merge
sort schid
merge schid using treatschool
gen treat = 0
replace treat = 1 if _merge == 3

for var _all: replace X = . if X == -999
for var _all: replace X = . if X == -888
for var _all: replace X = . if X == -777

drop _merge
sort schid
merge schid using Temp\tempclose
drop if treat==.
save Temp\test_new.dta, replace

use Temp\test_new.dta, clear
drop if schid==1211 | schid==5332 | schid==5711 | schid==1111 | schid==2111 | schid==5221 | schid==5611 | schid==1113 | (schid==5731 & childno==24)
save Temp\test_new.dta, replace

gen entry=0
replace entry=1 if (pre_total_v==. & pre_total_w==.) & post_total_v!=.
gen missing=0
replace missing=1 if (pre_total_v!=. | pre_total_w!=.) & post_total_v==. 
gen stayer=0
replace stayer=1 if missing==0 & entry==0
save Temp\test_new, replace

drop if stayer==0
replace pre_math_w=pre_math_w/5
replace pre_lang_w=pre_lang_w/5
replace pre_total_w=pre_total_w/5
replace pre_math_v=0 if pre_math_v==.
replace pre_lang_v=0 if pre_lang_v==.
replace pre_total_v=0 if pre_total_v==.
replace pre_math_w=0 if pre_math_w==.
replace pre_lang_w=0 if pre_lang_w==.
replace pre_total_w=0 if pre_total_w==.
replace post_math_v=0 if post_math_v==.
replace post_lang_v=0 if post_lang_v==.
replace post_total_v=0 if post_total_v==.
replace post_math_w=0 if post_math_w==.
replace post_lang_w=0 if post_lang_w==.
replace post_total_w=0 if post_total_w==.
gen add_post_math=post_math_v+post_math_w
gen add_post_lang=post_lang_v+post_lang_w
gen add_post_total=post_total_v+post_total_w
gen post_dummy=1
drop _merge
sort schid childno
merge schid childno using normalization
save Temp\data_norm, replace

capture program drop zscore
keep if post_dummy==1 
program define zscore
	syntax, option1(string) option2(string)
	sort treat
	egen m1_`option1'=mean(`option2') if treat==0 & `option2'!=.
	egen sd1_`option1'=sd(`option2') if treat==0 & `option2'!=.
	egen m_`option1'=mean(m1_`option1')
	egen sd_`option1'=mean(sd1_`option1')
	gen z_`option1'=(`option1'-m_`option1')/sd_`option1'
end

zscore, option1(add_post_math) option2(math_old)
zscore, option1(add_post_lang) option2(lang_old)
zscore, option1(add_post_total) option2(total_old)

replace post_writ=0 if post_writ==.
sort treat
by treat: sum post_writ
drop _merge
sort schid
merge schid using av_random_post
drop _merge
sort schid
merge schid using av_payments_post
drop if stayer==.
replace payment=1000 if treat==0

*Column 4 IV regression is the only one with a treatment measure
*All others are simple regressions on "open"
ivreg post_writ (open=treat) pre_math_v pre_math_w pre_writ, cluster(schid)
ivreg z_add_post_total (open=treat) pre_total_v pre_total_w pre_writ, cluster(schid)


*Duplicates intent to treat regressions elsewhere in paper

*ivreg post_writ (open=treat) pre_math_v pre_math_w pre_writ, cluster(schid)
*ivreg z_add_post_total (open=treat) pre_total_v pre_total_w pre_writ, cluster(schid)

*itt: reg post_writ treat pre_math_v pre_math_w pre_writ, cluster(schid)
*itt: reg z_add_post_total treat pre_total_v pre_total_w pre_writ, cluster(schid)


drop _all

	




















