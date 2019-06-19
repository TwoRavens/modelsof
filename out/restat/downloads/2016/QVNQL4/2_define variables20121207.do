set more off
cd /media/Data/Research/shak/EmpiricalApp/NLSY
* cd /home/user/NLSY

* rename variables
use ./data/workdata/workdata, clear

* some basic variables
rename R0000600 AGE1979
rename R0618200 AFQT_1
rename R0618300 AFQT_2
rename R0000300 birthmonth
rename R0000500 birthyear
rename R0000700 birthcntry
rename R0006500 HGC_MOTHER
rename R0007900 HGC_FATHER
rename R0214700 SAMPLE_RACE
rename R0214800 SAMPLE_SEX
rename R0173600 SID
rename R0009100 siblings
rename R0001610 residence_south
rename R0001800 URBAN
/*
keep CASEID 
save ./data/workdata/workdata_part1, 
*/

* years of schooling variables
* HIGHEST GRADE COMPLETED AS OF MAY 1 SURVEY YEAR (REVISED)
rename R0216701 EDU1979
rename R0406401 EDU1980
rename R0618901 EDU1981
rename R0898201 EDU1982
rename R1145001 EDU1983
rename R1520201 EDU1984
rename R1890901 EDU1985
rename R2258001 EDU1986
rename R2445401 EDU1987
rename R2871101 EDU1988
rename R3074801 EDU1989
rename R3401501 EDU1990
rename R3656901 EDU1991
rename R4007401 EDU1992
rename R4418501 EDU1993
rename R5103900 EDU1994
rename R5166901 EDU1996
rename R6479600 EDU1998
rename R7007300 EDU2000 
rename R7704600 EDU2002
rename R8497000 EDU2004
rename T0988800 EDU2006
rename T2210700 EDU2008
rename T3108600 EDU2010

* family income variables
* TOTAL NET FAMILY INCOME IN PAST CALENDAR YEAR *KEY* (TRUNCATED)
rename R0217900 FIN78
rename R0406010 FIN79
rename R0618410 FIN80
rename R0898600 FIN81
rename R1144500 FIN82
rename R1519700 FIN83
rename R1890400 FIN84
rename R2257500 FIN85

* IS CURRENT OR LAST COLLEGE ATTENDED A 2- OR 4-YEAR SCHOOL?
rename R0021500 att1979
rename R0230800 att1980
rename R0419000 att1981
rename R0666100 att1982
rename R0907400 att1983
rename R1207500 att1984
rename R1606700 att1985
rename R1907100 att1986
rename R2511000 att1988
rename R2909900 att1989
rename R3111900 att1990
rename R3712400 att1992
rename R4140100 att1993
rename R4528500 att1994
rename R5223800 att1996
rename R5824200 att1998
rename R6542700 att2000
rename R7105900 att2002
rename R7812800 att2004
rename T0016700 att2006
rename T1217100 att2008
rename T2275300 att2010	

* hourc : NUMBER OF HOURS WORKED IN PAST CALENDAR YEAR *KEY*
rename R0215710 hourc1979
rename R0407300 hourc1980
rename R0646600 hourc1981
rename R0896800 hourc1982
rename R1145200 hourc1983
rename R1520400 hourc1984
rename R1891100 hourc1985
rename R2258200 hourc1986
rename R2445600 hourc1987
rename R2871400 hourc1988
rename R3075100 hourc1989
rename R3401800 hourc1990
rename R3657200 hourc1991
rename R4007700 hourc1992
rename R4418800 hourc1993
rename R5081800 hourc1994
rename R5167100 hourc1996
rename R6479900 hourc1998
rename R7007600 hourc2000
rename R7704900 hourc2002
rename R8497300 hourc2004
rename T0989100 hourc2006
rename T2210900 hourc2008
rename T3108800 hourc2010

* WORKC : NUMBER OF WEEKS WORKED IN PAST CALENDAR YEAR *KEY*
rename R0115200 WORKC1975
rename R0115100 WORKC1976
rename R0115000 WORKC1977
rename R0215700 WORKC1979
rename R0407200 WORKC1980
rename R0646300 WORKC1981
rename R0896900 WORKC1982
rename R1145300 WORKC1983
rename R1520500 WORKC1984
rename R1891200 WORKC1985
rename R2258300 WORKC1986
rename R2445700 WORKC1987
rename R2871500 WORKC1988
rename R3075200 WORKC1989
rename R3401900 WORKC1990
rename R3657300 WORKC1991
rename R4007800 WORKC1992
rename R4418900 WORKC1993
rename R5081900 WORKC1994
rename R5167200 WORKC1996
rename R6480000 WORKC1998
rename R7007700 WORKC2000
rename R7705000 WORKC2002
rename R8497400 WORKC2004
rename T0989200 WORKC2006
rename T2211000 WORKC2008
rename T3108900 WORKC2010

* WORKI : NUMBER OF WEEKS WORKED SINCE LAST INT *KEY*
rename R0215300 WORKI1979
rename R0406700 WORKI1980
rename R0645800 WORKI1981
rename R0897300 WORKI1982
rename R1145800 WORKI1983
rename R1521000 WORKI1984
rename R1891700 WORKI1985
rename R2258800 WORKI1986
rename R2446200 WORKI1987
rename R2872000 WORKI1988
rename R3075700 WORKI1989
rename R3402400 WORKI1990
rename R3657800 WORKI1991
rename R4008300 WORKI1992
rename R4419400 WORKI1993
rename R5082400 WORKI1994
rename R5167700 WORKI1996
rename R6480500 WORKI1998
rename R7008200 WORKI2000
rename R7705500 WORKI2002
rename R8497900 WORKI2004
rename T0989700 WORKI2006
rename T2211500 WORKI2008
rename T3109400 WORKI2010

* INC : TOTAL INCOME FROM WAGES AND SALARY IN PAST CALENDAR YEAR (TRUNC) (REVISED)
rename R0155400 INC1979
rename R0169100 INC1979a 
rename R0312300 INC1980 
rename R0328000 INC1980a 
rename R0482600 INC1981 
rename R0498500 INC1981a
rename R0782101 INC1982
rename R0798600 INC1982a
rename R1024001 INC1983
rename R1410701 INC1984
rename R1778501 INC1985
rename R2141601 INC1986
rename R2350301 INC1987
rename R2722501 INC1988
rename R2971401 INC1989
rename R3279401 INC1990
rename R3559001 INC1991
rename R3897101 INC1992
rename R4295101 INC1993
rename R4982801 INC1994
rename R5626201 INC1996
rename R6364601 INC1998
rename R6909701 INC2000
rename R7607800 INC2002
rename R8316300 INC2004
rename T0912400 INC2006
rename T2076700 INC2008
rename T3045300 INC2010
replace INC1979 = INC1979a if INC1979 < 0 & INC1979a > 0
replace INC1980 = INC1980a if INC1980 < 0 & INC1980a > 0
replace INC1981 = INC1981a if INC1981 < 0 & INC1981a > 0
replace INC1982 = INC1982a if INC1982 < 0 & INC1982a > 0
drop *a

* for using svyset, we divide SID into 3 groups  
gen grp = 1 if SID <= 8
replace grp = 3 if SID >= 15
replace grp = 2 if (grp ~= 1 & grp ~= 3)
sort CASEID
save ./data/workdata/analysis_0, replace
****************************************************************************************************************************************
* compute age 
use ./data/workdata/analysis_0, clear
keep CASEID AGE1979

forvalue i=1980/2010{
gen AGE`i' = AGE1979
}
reshape long AGE, i(CASEID) j(year)
replace AGE = AGE + (year - 1979)
reshape wide AGE, i(CASEID) j(year)

sort CASEID
save ./data/workdata/age, replace
****************************************************************************************************************************************
* compute WORKC : number of weeks worked in past calendar year
use ./data/workdata/analysis_0, clear

drop WORKI*
gen WORKC1978 = .
* create missing years
forv i=1995(2)2009{
gen WORKC`i' = .
}
aorder

reshape long WORKC, i(CASEID) j(year)
gen WRKC_ori = WORKC
bysort CASEID : gen WRKC_frd = WORKC[_n+1] if year >= 1978
bysort CASEID : replace WORKC = WRKC_frd if year >= 1978
drop WRKC_frd WRKC_ori
* rename workc 
rename WORKC workc
reshape wide workc, i(CASEID) j(year)
sort CASEID
save ./data/workdata/wrkc, replace
****************************************************************************************************************************************
* compute WORKI : number of weeks worked since last interview
use ./data/workdata/analysis_0, clear
drop WORKC*

* create missing years
forv i=1995(2)2009{
gen WORKI`i' = .
}
* the maximum value of WORKI1979 is 84, so I assume 2 years ago
gen WORKI1977 = .
gen WORKI1978 = .

reshape long WORKI, i(CASEID) j(year)  
gen WRKI_ori = WORKI
* year_idnt stands for identification (of number of periods)
gen year_idnt = year
replace WORKI = . if WORKI < 0

reshape wide WORKI WRKI_ori year_idn, i(CASEID) j(year)

* replicate
forv i=2009(-1)1977{
local j = `i' + 1
replace WORKI`i' = WORKI`j' if WORKI`i' == . & WORKI`j' ~= .
replace year_idnt`i' = year_idnt`j' if WORKI`i' == WORKI`j'
}

reshape long WORKI WRKI_ori year_idnt, i(CASEID) j(year)
* keep if CASEID == 1033
order CASEID WORKI year_idnt  

* duplicate
expand 2  
sort CASEID year  

* beark into two pieces
bysort CASEID WORKI year_idnt : gen halfyear = _N
gen avg_wrki = WORKI / halfyear
order CASEID WORKI avg_wrki year_idnt
sort CASEID year  

* distinguish first and next half year
bysort CASEID year : gen cnt = _n
* year_ is for breaking into two pieces
gen year_ = year
tostring year_, replace
order CASEID year avg_wrki year_
sort CASEID year cnt
foreach x in year_{
replace year_ = year_ + "u" if cnt == 1
replace year_ = year_ + "l" if cnt == 2
}

bysort CASEID : gen year_frd = year_[_n+1]
bysort CASEID : gen avg_wrki_frd = avg_wrki[_n+1]
order CASEID year avg_wrki avg_wrki_frd year_ year_frd
* drop if year_frd == ""

* note that what we want is, for example, year 2009 wrki = 2009l + 2010u
* so drop the same year
destring year_ year_frd, replace ignore("u", "l")
drop if year_ == year_frd

gen worki = avg_wrki + avg_wrki_frd
order CASEID year worki
* for the last 2010 obs
replace worki = avg_wrki if avg_wrki ~= . & avg_wrki_frd == .

* compare WORKI WRKI_ori
keep CASEID year worki
order CASEID year 

reshape wide worki, i(CASEID) j(year)
sort CASEID
save ./data/workdata/wrki, replace
****************************************************************************************************************************************
* merge age
use ./data/workdata/analysis_0, clear
merge 1:1 CASEID using ./data/workdata/age
tab _merge
drop _merge
sort CASEID
save ./data/workdata/analysis_1, replace
****************************************************************************************************************************************
* merge work experience variables
use ./data/workdata/analysis_1, clear
sort CASEID
merge 1:1 CASEID using ./data/workdata/wrki
tab _merge
drop _merge
sort CASEID
merge 1:1 CASEID using ./data/workdata/wrkc
tab _merge
drop _merge
save ./data/workdata/analysis_2, replace
****************************************************************************************************************************************
* define work experience variable
use ./data/workdata/analysis_2, clear
reshape long WORKC WORKI workc worki hourc att AGE INC EDU, i(CASEID) j(year)
order CASEID year WORKC WORKI workc worki

* define work experience variable for current year
gen wrk_exp = workc
replace wrk_exp = . if wrk_exp < 0
* so far, wrk_exp represents "workc", and note that workc1979 (actual year) = WORKC1980 (past calendar year)
* worki means the average weeks worked, computed from WORKI (since last interview)

* to use WORKI in place of "missing WORKC"
* wrk_exp_rev stands for wrk_exp_revised
gen wrk_exp_rev = workc
replace wrk_exp_rev = worki if wrk_exp_rev == . & worki >= 0
order CASEID year wrk_exp wrk_exp_rev WORKC WORKI workc worki
drop workc worki

reshape wide WORKC WORKI hourc att AGE INC EDU wrk_exp wrk_exp_rev, i(CASEID) j(year)
* drop missing variables
foreach x of varlist _all {
 quietly sum `x'
 if `r(N)'== 0 {
 drop `x'
}
}
reshape long WORKC WORKI hourc att AGE INC EDU wrk_exp wrk_exp_rev, i(CASEID) j(year)

gen INCnow=INC[_n+1]  /* define the TOTAL INCOME FROM WAGES AND SALARY IN current CALENDAR YEAR */
sort CASEID year
save ./data/workdata/analysis, replace





