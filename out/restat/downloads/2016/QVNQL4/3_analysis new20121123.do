set more off
cd /media/Data/Research/shak/EmpiricalApp/NLSY
* cd /home/user/NLSY
****************************************************************************************************************************************
* for computing years of schooling
* in NLS investigator, the variable title : HIGHEST GRADE COMPLETED AS OF MAY 1 SURVEY YEAR (REVISED)
set more off
use ./data/workdata/analysis, clear
order CASEID EDU AGE att

* adopt linear interpolation to deal with missing values
replace EDU = . if EDU < 0
ipolate EDU AGE, gen(EDUipo) by(CASEID)

rename EDU EDUraw
rename EDUipo EDU

* create educational dummy
gen edu_1 = ( EDU >=0 & EDU <= 11  )
gen edu_2 = ( EDU == 12 )
gen edu_3 = ( EDU >= 13 & EDU <=15 ) | att==1  	/* two year college */
gen edu_4 = ( EDU >= 16 & EDU <=20 ) | att==2	/* four year college */

****************************************************************************************************************************************
* for computing family background and geographic controls
gen black = ( SAMPLE_RACE == 2 )
gen hispanic = ( SAMPLE_RACE == 1 )
gen urban = ( URBAN == 1 )
gen south = ( residence_south == 1 )
****************************************************************************************************************************************
* for computing family income (in 1999 dollars)
gen fin78 = FIN78 if FIN78 >= 0
gen fin79 = FIN79 if FIN79 >= 0
gen fin80 = FIN80 if FIN80 >= 0
gen fin81 = FIN81 if FIN81 >= 0
gen fin82 = FIN82 if FIN82 >= 0
gen fin83 = FIN83 if FIN83 >= 0
gen fin84 = FIN84 if FIN84 >= 0
gen fin85 = FIN85 if FIN85 >= 0

gen fi78 = fin78 / 0.391357
gen fi79 = fin79 / 0.435774
gen fi80 = fin80 / 0.494598
gen fi81 = fin81 / 0.545618
gen fi82 = fin82 / 0.579232
gen fi83 = fin83 / 0.597839
gen fi84 = fin84 / 0.623649
gen fi85 = fin85 / 0.645858

reshape wide WORKC WORKI hourc att AGE INC EDU* wrk_exp wrk_exp_rev edu_*, i(CASEID) j(year)
* drop missing variables
foreach x of varlist _all {
 quietly sum `x'
 if `r(N)'== 0 {
 drop `x'
}
}

gen	fi = fi83 		if AGE1979==14 & missing(fi82)==1 & missing(fi81)==1 & missing(fi83)==0
replace	fi = fi81 		if AGE1979==14 & missing(fi82)==1 & missing(fi81)==0 & missing(fi83)==1
replace	fi = (fi81+fi83)/2	if AGE1979==14 & missing(fi82)==1 & missing(fi81)==0 & missing(fi83)==0
replace	fi = fi82 		if AGE1979==14 & missing(fi82)==0

replace	fi = fi82 		if AGE1979==15 & missing(fi81)==1 & missing(fi80)==1 & missing(fi82)==0
replace	fi = fi80 		if AGE1979==15 & missing(fi81)==1 & missing(fi80)==0 & missing(fi82)==1
replace	fi = (fi80+fi82)/2 	if AGE1979==15 & missing(fi81)==1 & missing(fi80)==0 & missing(fi82)==0
replace	fi = fi81 		if AGE1979==15 & missing(fi81)==0

replace	fi = fi81 		if AGE1979==16 & missing(fi80)==1 & missing(fi79)==1 & missing(fi81)==0
replace	fi = fi79 		if AGE1979==16 & missing(fi80)==1 & missing(fi79)==0 & missing(fi81)==1
replace	fi = (fi79+fi81)/2 	if AGE1979==16 & missing(fi80)==1 & missing(fi79)==0 & missing(fi81)==0
replace	fi = fi80 		if AGE1979==16 & missing(fi80)==0

replace	fi = fi80 		if AGE1979==17 & missing(fi79)==1 & missing(fi78)==1 & missing(fi80)==0
replace	fi = fi78 		if AGE1979==17 & missing(fi79)==1 & missing(fi78)==0 & missing(fi80)==1
replace	fi = (fi78+fi80)/2 	if AGE1979==17 & missing(fi79)==1 & missing(fi78)==0 & missing(fi80)==0
replace	fi = fi79 		if AGE1979==17 & missing(fi79)==0

drop fi7* fi8* 
drop fin*
drop FIN*
xtile ficat=fi, n(3) 

****************************************************************************************************************************************
* computing ln wage
reshape long WORKC WORKI hourc att AGE INC EDU EDUraw wrk_exp wrk_exp_rev edu_1 edu_2 edu_3 edu_4, i(CASEID) j(year)

* to deal with the missing values
foreach x in INC hourc WORKC wrk_exp_rev {
	replace  `x'= . if `x' < 0 
}

* define hourly and weekly wage in the past calendar year
gen hrwc = INC / hourc if hourc>0
gen wkwc = INC / WORKC if WORKC>0
* INC is for past calendar year, wrk_exp_rev is for current year, so shift back
* the meaning of wkrev is similar to wkwc, just above
gen wk_rev_back = wrk_exp_rev[_n-1] if year >= 1978
order CASEID year wrk_exp_rev wk_rev_back
gen wkrev = INC / wk_rev_back if wk_rev_back >0
drop wk_rev_back
order CASEID year INC hourc hrwc WORKC wkwc wrk_exp_rev wkrev

foreach x in hrwc wkwc wkrev {
	gen ln_`x' = ln(`x')
}
order CASEID year INC hourc hrwc ln_hrwc wkwc ln_wkwc wkrev ln_wkrev
save .\data\workdata\temp, replace

****************************************************************************************************************************************
* computing work experience
* wrk_exp = the weeks worked in current year (in WORKC)
* wrk_exp_rev = the weeks worked in current year (major WORKC, replaced in terms of WORKI if missing)

use  .\data\workdata\temp, clear
set more off

reshape wide WORKC WORKI hourc att AGE INC EDU EDUraw wrk_exp wrk_exp_rev edu_1 edu_2 edu_3 edu_4 hrwc ln_hrwc wkwc ln_wkwc wkrev ln_wkrev, i(CASEID) j(year)
* if we drop missing variables here, the following codes would have trouble, plz see the explanations below
* work experience is the accumulative number of work weeks (or years) since being graduated from school.
* Is wrk_exp* accumulative? yes, exprew_rev is accumulative
foreach x of varlist _all {
 quietly sum `x'
 if `r(N)'== 0 {
 drop `x'
}
}
* when data goes from wide form to long form, STATA would create missing values for filling missing years
* e.g., id = 1, with income1980 =100, income1981 =200, saving1980 =50
*   id = 1,      income   saving
* year = 1980,     100      50
* year = 1981,     200       .
* when we transform long form back into wide form, we would get a missing column, i.e., saving1981 = .
* so I usually have two ways to do:
* (1) treat saving1980 as time invariant variable if we are dealing with income variable,
* in other words, use "reshape long income" instead of "reshape long income saving"
* (2) reshape almost all variables, then drop missing columns after each transformation (long to wide)
* in the following, we originally used wrk_exp, which refers to WORKC, so this variable would lack, for instance, 1994 data
* when we drop the missings, WORKC1994 would disappear, this would result in the error in the loop
* now we are using "wrk_exp_rev", which would not have this problem

replace wrk_exp_rev1975 = 0 if wrk_exp_rev1975 == .
gen experw_rev1975 = wrk_exp_rev1975/52
local i = 1975
while `i' < 2010 {
	local t = `i' + 1
	replace wrk_exp_rev`t' = 0 if wrk_exp_rev`t' == .
	gen experw_rev`t' = experw_rev`i' + wrk_exp_rev`t'/52
	local i = `t'
}
/* check if the wrk_exp_rev is accumulative
reshape long wrk_exp_rev experw_rev, i(CASEID) j(year)
order CASEID year wrk_exp_rev experw_rev
*/

* potential work experience  
reshape long WORKC WORKI hourc att AGE INC EDU EDUraw wrk_exp wrk_exp_rev edu_1 edu_2 edu_3 edu_4 /*
*/ hrwc ln_hrwc wkwc ln_wkwc wkrev ln_wkrev experw_rev, i(CASEID) j(year)
order CASEID year AGE EDU
gen pexper = AGE - EDU - 5
order CASEID year AGE EDU pexper

reshape wide WORKC WORKI hourc att AGE INC EDU EDUraw wrk_exp wrk_exp_rev edu_1 edu_2 edu_3 edu_4 /*
*/ hrwc ln_hrwc wkwc ln_wkwc wkrev ln_wkrev experw_rev pexper, i(CASEID) j(year)
* drop missing variables
foreach x of varlist _all {
 quietly sum `x'
 if `r(N)'== 0 {
 drop `x'
}
}
****************************************************************************************************************************************
* N= 4302 
keep if SAMPLE_SEX == 1
keep if SID <= 14
keep if HGC_MOTHER >= 0
keep if HGC_FATHER >= 0
keep if AFQT_1 >= 0
keep if AFQT_2 >= 0

****************************************************************************************************************************************
* for computing AFQT
set more off
local x0 i.AGE1979*i.birthmonth

rename AFQT_1 AFQT80 
rename AFQT_2 AFQT89 

* temporarily assume weight00
foreach afqt in AFQT80 AFQT89 {
	xi: regress `afqt' `x0' [fweight=weight00]
	predict `afqt'q if e(sample), res
	xtile `afqt'q_p = `afqt'q, n(100)
}
drop _I*

****************************************************************
* merge with Geocode
sort CASEID
save ./data/workdata/tempt.dta, replace

use "/media/Data/Data_utte/US data/NLSY/location/code_14_year17.dta"
gen yearat17=YEAR17+1900
rename ID CASEID
sort CASEID
merge 1:1 CASEID using ./workdata/tempt.dta 
tab _merge
keep if _merge==3
drop _merge 
sort CASEID
save ./data/workdata/tempt0.dta, replace

use "/media/Data/Data_utte/US data/NLSY/college/ID_cnty14localcost.dta" /* 1999 dollars */
drop fips14 state14 year17
rename ID CASEID
sort CASEID
merge 1:1 CASEID using ./data/workdata/tempt0.dta 
tab _merge
keep if _merge==3
drop _merge state14
sort CASEID
save ./data/workdata/tempt1.dta, replace

use "/media/Data/Data_utte/US data/NLSY/college/ID_cnty14c01232008.dta"
drop fips year
rename ID CASEID
sort CASEID
merge 1:1 CASEID using ./data/workdata/tempt1.dta 
tab _merge
keep if _merge==3
drop _merge fips*
drop meanc* med* Room_c Board_c
sort CASEID
save ./data/workdata/tempt2.dta, replace

** bring in census with pop80sqmil (population density)
use "/media/Data/Data_utte/US data/NLSY/college/ID_cnty14.dta", clear
keep ID pop* fips year17
gen yearat17=1900+year17  
drop year17
drop if missing(fips)==1
sort fips yearat17
save ./data/workdata/popdensity80.dta, replace

** merge census with college opening data
use "/media/Data/Data_utte/college open(backed)/US universities/open.dta", clear
keep if yearat17>= 1974 & yearat17<=1982
sort fips yearat17
merge 1:m fips yearat17 using ./workdata/popdensity80.dta 
tab _merge /* there are two persons with geocode ID but they have no opening information. I kept them for now */
drop if _merge==1
drop _merge 
rename ID CASEID
sort CASEID
merge 1:1 CASEID using ./data/workdata/tempt2.dta /* there are 244 persons who have ID but didn't have opening or census info */
tab _merge
drop if _merge==1
drop _merge fips
sort CASEID
save ./data/workdata/summary.dta, replace

* public 4 yr college in county = card4pub
* tuition cost in county = Intuit_c, cost
* residence in northeast = ne14
* residence in west = west14
* residence in west = south14

***************************************************************************************************************************************
* SUMMARY STATS
* reshape wide hourc WORKC WORKI INC hrwc ln_hrwc wkwc ln_wkwc wkwi ln_wkwi, i(CASEID) j(year)
use ./data/workdata/summary.dta, clear






keep CASEID grp weight* EDU1990 edu_11990 edu_21990 edu_31990 edu_41990 /*
	*/ AFQT80q_p AFQT89q_p HGC_MOTHER HGC_FATHER siblings black hispanic fi urban south /*
	*/ experw_rev1990 experw_rev1993 experw_rev1995 experw_rev1997 experw_rev1999 /*
	*/ pexper1990 pexper1993 pexper1995 pexper1997 pexper1999 /*
	*/ experw_rev20* pexper20* /*
	*/ ln_hrwc1991 ln_hrwc1994 ln_hrwc1996 ln_hrwc1998 ln_hrwc2000 /*
	*/ ln_wkwc1991 ln_wkwc1994 ln_wkwc1996 ln_wkwc1998 ln_wkwc2000 /*
	*/ ln_wkrev1991 ln_wkrev1994 ln_wkrev1996 ln_wkrev1998 ln_wkrev2000 /*
	*/ ln_hrwc2002 ln_hrwc2004 ln_hrwc2006 ln_hrwc2008 ln_hrwc2010 /*
	*/ ln_wkwc2002 ln_wkwc2004 ln_wkwc2006 ln_wkwc2008 ln_wkwc2010 /*
	*/ ln_wkrev2002 ln_wkrev2004 ln_wkrev2006 ln_wkrev2008 ln_wkrev2010 /*
	*/ pop80sqmil ne14 south14 west14 card4pub Intuit_c cost


svyset, clear
svyset CASEID [pweight = weight00], strata(grp)

* (a) schooling variables
sum EDU1990 edu_11990 edu_21990 edu_31990 edu_41990 
quietly svy : mean EDU1990
estat sd
quietly svy : mean edu_11990 edu_21990 edu_31990 edu_41990
estat sd

* (b) ability and family background
sum AFQT80q_p AFQT89q_p HGC_MOTHER HGC_FATHER siblings black hispanic fi
quietly svy : mean AFQT80q_p AFQT89q_p
estat sd
quietly svy : mean HGC_MOTHER HGC_FATHER siblings black hispanic
estat sd
quietly svy : mean fi
estat sd

* (c) geographic controls at age 14
sum urban pop80sqmil ne14 south14 west14
quietly svy : mean urban ne14 south14 west14 
estat sd
quietly svy : mean pop80sqmil
estat sd

* (d) instruments for schooling
sum card4pub Intuit_c cost
quietly svy : mean card4pub 
estat sd
quietly svy : mean Intuit_c
estat sd
quietly svy : mean cost
estat sd

* actual work experience (WORKC, missing in place of WORKI)
sum experw_rev1990 experw_rev1993 experw_rev1995 experw_rev1997 experw_rev1999
quietly svy : mean experw_rev1990 experw_rev1993 experw_rev1995 experw_rev1997 experw_rev1999
estat sd

* potential work experience
sum pexper1990 pexper1993 pexper1995 pexper1997 pexper1999
foreach x in pexper1990 pexper1993 pexper1995 pexper1997 pexper1999{
quietly svy : mean `x'
estat sd
}

* log hourly earnings
sum ln_hrwc1991 ln_hrwc1994 ln_hrwc1996 ln_hrwc1998 ln_hrwc2000
foreach x in ln_hrwc1991 ln_hrwc1994 ln_hrwc1996 ln_hrwc1998 ln_hrwc2000{
quietly svy : mean `x'
estat sd
}

* log weekly earnings
sum ln_wkwc1991 ln_wkwc1994 ln_wkwc1996 ln_wkwc1998 ln_wkwc2000
foreach x in ln_wkwc1991 ln_wkwc1994 ln_wkwc1996 ln_wkwc1998 ln_wkwc2000{
quietly svy : mean `x'
estat sd
}

* log weekly earnings 2
sum ln_wkrev1991 ln_wkrev1994 ln_wkrev1996 ln_wkrev1998 ln_wkrev2000
foreach x in ln_wkrev1991 ln_wkrev1994 ln_wkrev1996 ln_wkrev1998 ln_wkrev2000{
quietly svy : mean `x'
estat sd
}
****************************************************************************************************************************************
****************************************************************************************************************************************
svyset, clear
svyset CASEID [pweight = weight10], strata(grp)
* actual work experience after 2000, each variable is for current year
sum experw_rev2001 experw_rev2003 experw_rev2005 experw_rev2007 experw_rev2009
quietly svy : mean experw_rev2001 experw_rev2003 experw_rev2005 experw_rev2007 experw_rev2009
estat sd

* petential work experience after 2000, each variable is for current year
sum pexper2001 pexper2003 pexper2005 pexper2007 pexper2009
forvalue i=2001(2)2009{
quietly svy : mean pexper`i'
estat sd
}

* log hourly earnings after 2000, each variable is for past calendar year
sum ln_hrwc2002 ln_hrwc2004 ln_hrwc2006 ln_hrwc2008 ln_hrwc2010 
foreach x in ln_hrwc2002 ln_hrwc2004 ln_hrwc2006 ln_hrwc2008 ln_hrwc2010{
quietly svy : mean `x'
estat sd
}

* log weekly earnings after 2000, each variable is for past calendar year
sum ln_wkwc2002 ln_wkwc2004 ln_wkwc2006 ln_wkwc2008 ln_wkwc2010
foreach x in ln_wkwc2002 ln_wkwc2004 ln_wkwc2006 ln_wkwc2008 ln_wkwc2010{
quietly svy : mean `x'
estat sd
}

* log weekly earnings 2 after 2000, each variable is for past calendar year
sum ln_wkrev2002 ln_wkrev2004 ln_wkrev2006 ln_wkrev2008 ln_wkrev2010
foreach x in ln_wkrev2002 ln_wkrev2004 ln_wkrev2006 ln_wkrev2008 ln_wkrev2010{
quietly svy : mean `x'
estat sd
}


