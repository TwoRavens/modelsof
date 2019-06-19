/* This program process the March CPS data set we used in order to reduce it to exactly the variables used and reported in our analysis.
 */

cd C:\imputations\selection\forREstat

capture log close

set more off

log using restatmarch.log, replace

/* we extracted data using CPS utilities.  
details on these extractins can be obtained from author Bollinger
details linking variable names between CPS utilities and BLS public use files can also be obtained individuals using the data provided in the REstat archive should comment out the next section and include the following (appropriately modified for directory) use statement

/* use C:\imputations\selection\forREstat\BHrestatmarch.dta */

***********************************
comment out below if using provided data
CONSTRUCTING DATA FROM RAW DATA FILES PRODUCED BY CPS UTILITIES  */

use C:\Datasets\CPSutilitieswork\finalnonresponse\mar08,clear
append using C:\Datasets\CPSutilitieswork\finalnonresponse\mar07
append using C:\Datasets\CPSutilitieswork\finalnonresponse\mar06
append using C:\Datasets\CPSutilitieswork\finalnonresponse\mar05
append using C:\Datasets\CPSutilitieswork\finalnonresponse\mar04
append using C:\Datasets\CPSutilitieswork\finalnonresponse\mar03
append using C:\Datasets\CPSutilitieswork\finalnonresponse\mar02
append using C:\Datasets\CPSutilitieswork\finalnonresponse\mar01
append using C:\Datasets\CPSutilitieswork\finalnonresponse\mar00
append using C:\Datasets\CPSutilitieswork\finalnonresponse\mar99

keep if clslyr > 0
keep if clslyr < 5 /*  dropping non paid workers and self employed */
drop if (indmly == 14)*(real(_year) > 2002)

keep hrespd lineno spouse aincer aincwg1 mis grdatn _race _female _spneth clslyr _marstat age citstat indmly occmly _divisn metsize ftpt incwag _year wkslyr hrslyr race wgt schft aindlyr aocclyr relhd

gen proxy = 1 - (hrespd == lineno)
gen spouseproxy = proxy*(hrespd == spouse)
gen nonspouseproxy = proxy - spouseproxy

gen wsimpute = aincer|aincwg1  /* earnings imputations*/


gen mis1or5 = (mis== 1)|(mis == 5)

gen elem = (grdatn < 35)
gen ed9th = (grdatn == 35)
gen ed10th = (grdatn == 36)
gen ed11th = (grdatn == 37)
gen ed12nodip = (grdatn == 38)
gen edHSgrad = (grdatn == 39)
gen edsomecoll = (grdatn == 40)
gen edvocassoc = (grdatn == 41)
gen edaccassoc = (grdatn == 42)
gen edassoc = edvocassoc + edaccassoc
gen edBA = (grdatn == 43)
gen edMA = (grdatn == 44)
gen edPro = (grdatn == 45)
gen edPhd = (grdatn == 46)
gen dropout = ed9th|ed10th|ed11th|ed12nodip

gen black = _race == 2
gen other = _race == 3

gen hispanic = (_spneth != 8)


gen federal = (clslyr == 2)
gen statew = (clslyr == 3)
gen local = (clslyr == 4)



gen marriedsp = (_marstat == 1)
gen marriedsa = (_marstat == 2)|(_marstat == 3)|(_marstat == 4)|(_marstat == 5)
gen nevermarr = (_marstat == 6)

gen marriedmale = (1 - _female)*marriedsp
gen marriedfem = _female*marriedsp
gen prevmarrmale = (1-_female)*marriedsa
gen prevmarrfem = _female*marriedsa
gen singlefem = _female*nevermarr
gen singlemale = 1- marriedmale - marriedfem - prevmarrmale - prevmarrfem - singlefem


gen yrsed = 4 
replace yrsed = 6 if (grdatn == 33)
replace yrsed = 8 if (grdatn == 34)
replace yrsed = 9 if (grdatn == 35)
replace yrsed = 10 if (grdatn == 36)
replace yrsed = 11 if (grdatn == 37)
replace yrsed = 11 if (grdatn == 38)
replace yrsed = 12 if (grdatn == 39)
replace yrsed = 13 if (grdatn == 40)
replace yrsed = 14 if (grdatn == 41)|(grdatn == 42)
replace yrsed = 16 if (grdatn == 43)
replace yrsed = 18 if (grdatn == 44)
replace yrsed = 20 if (grdatn == 45)|(grdatn == 46)

gen exp = age - yrsed - 6
replace exp = age - 16 if (age - 16) < exp
replace exp = 0 if exp < 0
gen exp2 = exp^2
gen exp3 = exp^3
gen exp4 = exp^4


gen foreign4 = (citstat == 4)
gen foreign5 = (citstat == 5)
gen foreign = foreign4 + foreign5
gen asian = (race == 4)
replace other = other - asian
replace other = 0 if hispanic
replace black = 0 if hispanic
replace asian = 0 if hispanic
gen white = 1 - black - asian - other - hispanic



gen indmlynew = indmly

replace indmly = 4 if (real(_year) > 2002)  
replace indmlynew = 4 if (real(_year) < 2003) /* will be base */

replace indmly = 4 if (indmly == 5) /* combining manuf prior to 2003 */
replace indmly = 4 if indmly == 14 /* pulling public out */

replace indmlynew = 4 if indmlynew == 13 /* pulling public out */

char indmly[omit] 4
char indmlynew[omit] 4

xi i.indmly, prefix(i) 
xi i.indmlynew, prefix(n)


gen occmlynew = 1 
replace occmlynew = 2 if (occmly > 2)*(occmly < 12)
replace occmlynew = 3 if (occmly >11)*(occmly < 16)
replace occmlynew = 4 if occmly == 16
replace occmlynew = 5 if occmly == 17
replace occmlynew = 6 if occmly == 18
replace occmlynew = 7 if occmly == 19
replace occmlynew = 8 if occmly == 20
replace occmlynew = 9 if occmly == 21
replace occmlynew = 10 if occmly == 22
replace occmlynew = 1 if (real(_year) < 2003)

replace occmly = 1 if real(_year) > 2002

xi i.occmly, prefix(o)
xi i.occmlynew, prefix(p)

xi i._divisn, prefix(d) noomit
xi i.metsize, prefix(m) noomit
xi i.ftpt, prefix(w) noomit



gen rincwag = incwag/1.889 
replace rincwag = incwag/1.840 if _year == "2004"
replace rincwag = incwag/1.799 if _year == "2003"
replace rincwag = incwag/1.771 if _year == "2002"
replace rincwag = incwag/1.722 if _year == "2001"
replace rincwag = incwag/1.666 if _year == "2000"
replace rincwag = incwag/1.630 if _year == "1999"
replace rincwag = incwag/1.953 if _year == "2006"
replace rincwag = incwag/2.016 if _year == "2007"
replace rincwag = incwag/2.073 if _year == "2008"

/* this does not adjust to 2008 dollars, but to the base year, need to adjust for means */

label var rincwag "real W&S earnings"

gen rwage = rincwag/(wkslyr*hrslyr)

label var rwage "constructed real hourly wage"

gen lnwage = log(rwage)
label var lnwage "log of constructed real hourly wage"
gen lnwage2 = lnwage
replace lnwage2 = . if wsimpute
label var lnwage2 "log hourly wage - no imputations"

gen primarysample = (schft !=1)&(age >= 18)&(age <= 65)&(ftpt == 1)

keep wsimpute lnwage lnwage2 wgt schft age ftpt _year proxy spouseproxy nonspouseproxy mis1or5 _female rwage elem ed9th ed10th ed11th ed12nodip dropout edHSgrad edsomecoll edassoc edBA edMA edPro edPhd age foreign hispanic white black asian other mmetsize_0-mmetsize_7 d_divisn_1-d_divisn_9 aindlyr aocclyr exp exp2 exp3 exp4 marriedmale prevmarrmale marriedfem prevmarrfem singlefem foreign4 foreign5 iindmly_1-iindmly_13 ooccmly_2-ooccmly_14 nindmlynew_1-nindmlynew_12 federal statew local poccmlynew_2-poccmlynew_10 relhd primarysample


save C:\imputations\selection\forREstat\BHrestatmarch.dta, replace

/*********************************************** END DATA CONSTRUCTION *********************************
If only analyzing provided data, comment out above and begin here after opening data set */





/* table 1, full sample imputation/missing rates */


tab wsimpute
tab wsimpute  [fweight = wgt]

/* primary analysis sample */

drop if schft == 1
keep if (age >= 18)&(age <= 65)
keep if ftpt == 1

sum primarysample

/* table 1, primary sample imputation/missing rates */

tab wsimpute
tab wsimpute  [fweight = wgt]

table _year [fweight = wgt],  contents(mean wsimpute)

tab proxy wsimpute [aweight = wgt], row col cell

gen bigprox = "self"
replace bigprox = "spouse" if spouseproxy
replace bigprox = "nonspous" if nonspouseproxy

table bigprox [aweight = wgt],  contents(mean wsimpute)

drop bigprox

table mis1or5 [aweight = wgt], contents(mean wsimpute)

/* table 2, primary sample */

tab proxy spouseprox, row col cell

tab proxy spouseprox if !_female, row col cell
tab proxy spouseprox if _female, row col cell


/* appendix table A1: weighted means by response status */

sort wsimpute

by wsimpute: sum proxy mis1or5 rwage _female elem dropout edHSgrad edsomecoll edassoc edBA edMA edPro edPhd age _female foreign hispanic white black asian hispanic mmetsize_0-mmetsize_7 d_divisn_1-d_divisn_9 aindlyr aocclyr rwage [fweight = wgt]


/* table 3 and Appendix table 2 primary sample */

xi i._year, noomit prefix(y)

gen responder = 1 - wsimpute

dprobit responder mis1or5 nonspouseproxy spouseproxy elem ed9th ed10th ed11th ed12nodip edsomecoll edassoc edBA edMA edPro edPhd exp exp2 exp3 exp4 marriedmale prevmarrmale marriedfem prevmarrfem singlefem black asian other hispanic foreign4 foreign5 mmetsize_2-mmetsize_7 d_divisn_2-d_divisn_9 iindmly_1-iindmly_13 ooccmly_2-ooccmly_14 nindmlynew_1-nindmlynew_12 federal statew local poccmlynew_2-poccmlynew_10 y_year_1-y_year_4 y_year_6-y_year_10 if !_female

dprobit responder mis1or5 nonspouseproxy spouseproxy elem ed9th ed10th ed11th ed12nodip edsomecoll edassoc edBA edMA edPro edPhd exp exp2 exp3 exp4 marriedmale prevmarrmale marriedfem prevmarrfem singlefem black asian other hispanic foreign4 foreign5 mmetsize_2-mmetsize_7 d_divisn_2-d_divisn_9 iindmly_1-iindmly_13 ooccmly_2-ooccmly_14 nindmlynew_1-nindmlynew_12 federal statew local poccmlynew_2-poccmlynew_10 y_year_1-y_year_4 y_year_6-y_year_10 if _female


/* table 4 and appendix tables A3 through a6 */

/* primary sample */
/*men*/

/*Ols*/

reg lnwage2 elem ed9th ed10th ed11th ed12nodip edsomecoll edassoc edBA edMA edPro edPhd exp exp2 exp3 exp4 marriedmale prevmarrmale black asian other hispanic foreign4 foreign5 mmetsize_2-mmetsize_7 d_divisn_2-d_divisn_9 iindmly_1-iindmly_13 ooccmly_2-ooccmly_14 nindmlynew_1-nindmlynew_12 federal statew local poccmlynew_2-poccmlynew_10 y_year_1-y_year_4 y_year_6-y_year_10 if !_female, robust

predict olshat

/* heckman two step with proxy in exclusions */

heckman lnwage2 elem ed9th ed10th ed11th ed12nodip edsomecoll edassoc edBA edMA edPro edPhd exp exp2 exp3 exp4 marriedmale prevmarrmale black asian other hispanic foreign4 foreign5 mmetsize_2-mmetsize_7 d_divisn_2-d_divisn_9 iindmly_1-iindmly_13 ooccmly_2-ooccmly_14 nindmlynew_1-nindmlynew_12 federal statew local poccmlynew_2-poccmlynew_10 y_year_1-y_year_4 y_year_6-y_year_10 if !_female, select(mis1or5 nonspouseproxy spouseproxy elem ed9th ed10th ed11th ed12nodip edsomecoll edassoc edBA edMA edPro edPhd exp exp2 exp3 exp4 marriedmale prevmarrmale black asian other hispanic foreign4 foreign5 mmetsize_2-mmetsize_7 d_divisn_2-d_divisn_9 iindmly_1-iindmly_13 ooccmly_2-ooccmly_14 nindmlynew_1-nindmlynew_12 federal statew local poccmlynew_2-poccmlynew_10 y_year_1-y_year_4 y_year_6-y_year_10) two


/* heckman two step with proxy in main equation */

heckman lnwage2 elem ed9th ed10th ed11th ed12nodip edsomecoll edassoc edBA edMA edPro edPhd exp exp2 exp3 exp4 marriedmale prevmarrmale black asian other hispanic foreign4 foreign5 mmetsize_2-mmetsize_7 d_divisn_2-d_divisn_9 iindmly_1-iindmly_13 ooccmly_2-ooccmly_14 nindmlynew_1-nindmlynew_12 federal statew local poccmlynew_2-poccmlynew_10 y_year_1-y_year_4 y_year_6-y_year_10 nonspouseproxy spouseproxy if !_female, select(mis1or5 nonspouseproxy spouseproxy elem ed9th ed10th ed11th ed12nodip edsomecoll edassoc edBA edMA edPro edPhd exp exp2 exp3 exp4 marriedmale prevmarrmale black asian other hispanic foreign4 foreign5 mmetsize_2-mmetsize_7 d_divisn_2-d_divisn_9 iindmly_1-iindmly_13 ooccmly_2-ooccmly_14 nindmlynew_1-nindmlynew_12 federal statew local poccmlynew_2-poccmlynew_10 y_year_1-y_year_4 y_year_6-y_year_10) two 

predict selecthat



/* women */

/*Ols*/

reg lnwage2 elem ed9th ed10th ed11th ed12nodip edsomecoll edassoc edBA edMA edPro edPhd exp exp2 exp3 exp4 marriedfem prevmarrfem black asian other hispanic foreign4 foreign5 mmetsize_2-mmetsize_7 d_divisn_2-d_divisn_9 iindmly_1-iindmly_13 ooccmly_2-ooccmly_14 nindmlynew_1-nindmlynew_12 federal statew local poccmlynew_2-poccmlynew_10 y_year_1-y_year_4 y_year_6-y_year_10 if _female, robust

predict temp

replace olshat = temp if _female

drop temp


/* heckman two step with proxy in exclusions */

heckman lnwage2 elem ed9th ed10th ed11th ed12nodip edsomecoll edassoc edBA edMA edPro edPhd exp exp2 exp3 exp4 marriedfem prevmarrfem black asian other hispanic foreign4 foreign5 mmetsize_2-mmetsize_7 d_divisn_2-d_divisn_9 iindmly_1-iindmly_13 ooccmly_2-ooccmly_14 nindmlynew_1-nindmlynew_12 federal statew local poccmlynew_2-poccmlynew_10 y_year_1-y_year_4 y_year_6-y_year_10 if _female, select(mis1or5 nonspouseproxy spouseproxy elem ed9th ed10th ed11th ed12nodip edsomecoll edassoc edBA edMA edPro edPhd exp exp2 exp3 exp4 marriedfem prevmarrfem black asian other hispanic foreign4 foreign5 mmetsize_2-mmetsize_7 d_divisn_2-d_divisn_9 iindmly_1-iindmly_13 ooccmly_2-ooccmly_14 nindmlynew_1-nindmlynew_12 federal statew local poccmlynew_2-poccmlynew_10 y_year_1-y_year_4 y_year_6-y_year_10) two


/* heckman two step with proxy in main equation */

heckman lnwage2 elem ed9th ed10th ed11th ed12nodip edsomecoll edassoc edBA edMA edPro edPhd exp exp2 exp3 exp4 marriedfem prevmarrfem black asian other hispanic foreign4 foreign5 mmetsize_2-mmetsize_7 d_divisn_2-d_divisn_9 iindmly_1-iindmly_13 ooccmly_2-ooccmly_14 nindmlynew_1-nindmlynew_12 federal statew local poccmlynew_2-poccmlynew_10 y_year_1-y_year_4 y_year_6-y_year_10 nonspouseproxy spouseproxy if _female, select(mis1or5 nonspouseproxy spouseproxy elem ed9th ed10th ed11th ed12nodip edsomecoll edassoc edBA edMA edPro edPhd exp exp2 exp3 exp4 marriedfem prevmarrfem black asian other hispanic foreign4 foreign5 mmetsize_2-mmetsize_7 d_divisn_2-d_divisn_9 iindmly_1-iindmly_13 ooccmly_2-ooccmly_14 nindmlynew_1-nindmlynew_12 federal statew local poccmlynew_2-poccmlynew_10 y_year_1-y_year_4 y_year_6-y_year_10) two 

predict temp

replace selecthat = temp if _female

drop temp



/* Co-head Sample */

/*men*/

/*Ols*/

reg lnwage2 elem ed9th ed10th ed11th ed12nodip edsomecoll edassoc edBA edMA edPro edPhd exp exp2 exp3 exp4 marriedmale prevmarrmale black asian other hispanic foreign4 foreign5 mmetsize_2-mmetsize_7 d_divisn_2-d_divisn_9 iindmly_1-iindmly_13 ooccmly_2-ooccmly_14 nindmlynew_1-nindmlynew_12 federal statew local poccmlynew_2-poccmlynew_10 y_year_1-y_year_4 y_year_6-y_year_10 if !_female&relhd<5, robust

predict olshatcohead


/* heckman two step with proxy in exclusions */

heckman lnwage2 elem ed9th ed10th ed11th ed12nodip edsomecoll edassoc edBA edMA edPro edPhd exp exp2 exp3 exp4 marriedmale prevmarrmale black asian other hispanic foreign4 foreign5 mmetsize_2-mmetsize_7 d_divisn_2-d_divisn_9 iindmly_1-iindmly_13 ooccmly_2-ooccmly_14 nindmlynew_1-nindmlynew_12 federal statew local poccmlynew_2-poccmlynew_10 y_year_1-y_year_4 y_year_6-y_year_10 if !_female&relhd<5, select(mis1or5 nonspouseproxy spouseproxy elem ed9th ed10th ed11th ed12nodip edsomecoll edassoc edBA edMA edPro edPhd exp exp2 exp3 exp4 marriedmale prevmarrmale black asian other hispanic foreign4 foreign5 mmetsize_2-mmetsize_7 d_divisn_2-d_divisn_9 iindmly_1-iindmly_13 ooccmly_2-ooccmly_14 nindmlynew_1-nindmlynew_12 federal statew local poccmlynew_2-poccmlynew_10 y_year_1-y_year_4 y_year_6-y_year_10) two


/* heckman two step with proxy in main equation */

heckman lnwage2 elem ed9th ed10th ed11th ed12nodip edsomecoll edassoc edBA edMA edPro edPhd exp exp2 exp3 exp4 marriedmale prevmarrmale black asian other hispanic foreign4 foreign5 mmetsize_2-mmetsize_7 d_divisn_2-d_divisn_9 iindmly_1-iindmly_13 ooccmly_2-ooccmly_14 nindmlynew_1-nindmlynew_12 federal statew local poccmlynew_2-poccmlynew_10 y_year_1-y_year_4 y_year_6-y_year_10 nonspouseproxy spouseproxy if !_female&relhd<5, select(mis1or5 nonspouseproxy spouseproxy elem ed9th ed10th ed11th ed12nodip edsomecoll edassoc edBA edMA edPro edPhd exp exp2 exp3 exp4 marriedmale prevmarrmale black asian other hispanic foreign4 foreign5 mmetsize_2-mmetsize_7 d_divisn_2-d_divisn_9 iindmly_1-iindmly_13 ooccmly_2-ooccmly_14 nindmlynew_1-nindmlynew_12 federal statew local poccmlynew_2-poccmlynew_10 y_year_1-y_year_4 y_year_6-y_year_10) two 

predict selecthatcohead


/* women */

/*Ols*/

reg lnwage2 elem ed9th ed10th ed11th ed12nodip edsomecoll edassoc edBA edMA edPro edPhd exp exp2 exp3 exp4 marriedfem prevmarrfem black asian other hispanic foreign4 foreign5 mmetsize_2-mmetsize_7 d_divisn_2-d_divisn_9 iindmly_1-iindmly_13 ooccmly_2-ooccmly_14 nindmlynew_1-nindmlynew_12 federal statew local poccmlynew_2-poccmlynew_10 y_year_1-y_year_4 y_year_6-y_year_10 if _female&relhd<5, robust

predict temp

replace olshatcohead = temp if _female&relhd<5

drop temp


/* heckman two step with proxy in exclusions */

heckman lnwage2 elem ed9th ed10th ed11th ed12nodip edsomecoll edassoc edBA edMA edPro edPhd exp exp2 exp3 exp4 marriedfem prevmarrfem black asian other hispanic foreign4 foreign5 mmetsize_2-mmetsize_7 d_divisn_2-d_divisn_9 iindmly_1-iindmly_13 ooccmly_2-ooccmly_14 nindmlynew_1-nindmlynew_12 federal statew local poccmlynew_2-poccmlynew_10 y_year_1-y_year_4 y_year_6-y_year_10 if _female&relhd<5, select(mis1or5 nonspouseproxy spouseproxy elem ed9th ed10th ed11th ed12nodip edsomecoll edassoc edBA edMA edPro edPhd exp exp2 exp3 exp4 marriedfem prevmarrfem black asian other hispanic foreign4 foreign5 mmetsize_2-mmetsize_7 d_divisn_2-d_divisn_9 iindmly_1-iindmly_13 ooccmly_2-ooccmly_14 nindmlynew_1-nindmlynew_12 federal statew local poccmlynew_2-poccmlynew_10 y_year_1-y_year_4 y_year_6-y_year_10) two


/* heckman two step with proxy in main equation */

heckman lnwage2 elem ed9th ed10th ed11th ed12nodip edsomecoll edassoc edBA edMA edPro edPhd exp exp2 exp3 exp4 marriedfem prevmarrfem black asian other hispanic foreign4 foreign5 mmetsize_2-mmetsize_7 d_divisn_2-d_divisn_9 iindmly_1-iindmly_13 ooccmly_2-ooccmly_14 nindmlynew_1-nindmlynew_12 federal statew local poccmlynew_2-poccmlynew_10 y_year_1-y_year_4 y_year_6-y_year_10 nonspouseproxy spouseproxy if _female&relhd<5, select(mis1or5 nonspouseproxy spouseproxy elem ed9th ed10th ed11th ed12nodip edsomecoll edassoc edBA edMA edPro edPhd exp exp2 exp3 exp4 marriedfem prevmarrfem black asian other hispanic foreign4 foreign5 mmetsize_2-mmetsize_7 d_divisn_2-d_divisn_9 iindmly_1-iindmly_13 ooccmly_2-ooccmly_14 nindmlynew_1-nindmlynew_12 federal statew local poccmlynew_2-poccmlynew_10 y_year_1-y_year_4 y_year_6-y_year_10) two 

predict temp

replace selecthatcohead = temp if _female&relhd<5

drop temp

/*converting to 2008 real */

replace olshat = olshat + ln(2.15303)
replace selecthat = selecthat + ln(2.15303)
replace olshatcohead = olshatcohead + ln(2.15303)
replace selecthatcohead = selecthatcohead + ln(2.15303)
replace lnwage = lnwage + ln(2.15303)
replace lnwage2 = lnwage2 + ln(2.15303) if lnwage2 != .


/* table 5 */

table _female, contents(mean lnwage mean lnwage2 mean olshat mean selecthat)

table _female if relhd < 5, contents(mean lnwage mean lnwage2 mean olshatcohead mean selecthatcohead)



log close
