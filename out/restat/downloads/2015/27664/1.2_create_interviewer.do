**-------------------------------------------------------------------
** NLSY97 SKIN COLOR RECODING - THROUGH 2010 (RD 14)
*-------------------------------------------------------------------
clear
clear mata
clear matrix
set mem 1g
set maxvar 7000
version 11
set more off
qui infile using "${extracts}/skincolor/skincolor.dct
qui do "${extracts}/skincolor/skincolor-value-labels.do"


* INTERVIEWER CHARACTERISTICS
* INTERVIEWER BACKGROUND QUESTIONS BEGIN IN 2002
*----------------------------------------------------------------------
*----------------------------------------------------------------------

* INTERVIEWER ID
*----------------------------------------------------------------------
local y=2002
foreach x in  S1598300 S2067200 S3861800 S5444400 S7545700 T0042300 T2022700 T3613500 T5213400 {
 cap drop intvid_`y'
 recode `x' (-9/-1=.), gen(intvid_`y')
 lab var intvid_`y' "Intv ID `y'"
 local y=`y'+1
}

* INTERVIEWER HISPANIC
*----------------------------------------------------------------------
local y=2002
foreach x in S1604500 S2067700 S3862300 S5444900 S7546200 T0042800 T2023200 T3614000 T5213900 {
 cap drop intvhisp_`y'
 recode `x' (-9/-1=.) (2=0), gen(intvhisp_`y')
 lab var intvhisp_`y' "Intv Hisp `y'"
 local y=`y'+1
}
 
* INTERVIEWER RACE
*----------------------------------------------------------------------
lab def intvrace 1"White" 2"Black" 3"Other", modify
local y=2002
foreach x in S1609200 S2067800 S3862400 S5445000 S7546300 T0042900 T2023300 T3614100 T5214000 {
 cap drop intvrace_`y'
 recode `x' (-9/-1=.) (1=1) (2=2) (3/6=3), gen(intvrace_`y')
 lab var intvrace_`y' "Intv Race `y'"
 local y=`y'+1
}


* INTERVIEWER GENDER
*----------------------------------------------------------------------
local y=2002
foreach x in S1604600 S2067900 S3862500 S5445100 S7546400 T0043000 T2023400 T3614200 T5214100 {
 cap drop intvmale_`y' 
 recode `x' (-9/-1=.) (2=0), gen(intvmale_`y')
 lab var intvmale_`y' "Intv male `y'"
 local y=`y'+1
 }


 * INTERVIEWER HGC
 *---------------------------------------------------------------------- 
lab def intvhgc 1"HS or less" 2"Some coll" 3"College" 4"More than college", modify
local y=2002
foreach x in S1604700 S2068000 S3862600 S5445200 S7546500 T0043100 T2023500 T3614300 T5214200 {
 cap drop intvhgc_`y'
 recode `x' (-9/-1 99=.) (1/4=1) (5/6=2) (7=3) (8/11=4), gen(intvhgc_`y')
 recode `x' (-9/-1 99=.) (1/6=0) (7/11=1), gen(intvcoll_`y')
 lab var intvcoll_`y' "Intv college `y'"
 lab var intvhgc_`y'  "Intv HGC `y'"
 lab val intvhgc_`y' intvhgc
 local y=`y'+1
}

* INTERVIEWER YOB
*----------------------------------------------------------------------
local y=2002
foreach x in S1604400 S2067600 S3862200 S5444800 S7546100 T0042700 T2023100 T3613900 T5213800 {
 cap drop intvyob_`y'
 recode `x' (-9/-1=.), gen(intvyob_`y')
 local y=`y'+1
}		
				

* RESHAPE LONG (BY INTVIEWER ID)
*----------------------------------------------------------------------------
rename R0000100 id
cap drop T*
cap drop S*
cap drop R*
cap drop E*
cap drop Z*
rename id R0000100

* RESHAPE
reshape long intvid_ intvrace_ intvmale_ intvhisp_ intvhgc_ intvcoll_ intvyob_, i(R0000100) j(year)
rensfix _

* KEEP 1 OBS FOR EACH INTERVIEWER-YEAR
sort intvid year
cap drop group
egen group=group(intvid year)
bys group: keep if _n==1

* DROP IF INTVID==. (FROM NON_INTVW YEARS)
drop if intvid==.


* INTVMALE 
cap drop tmp*
bys intvid: egen tmpmax=max(intvmale)
bys intvid: egen tmpmin=min(intvmale)
tab tmpmax tmpmin if intvmale ==., m
replace intvmale =tmpmin if tmpmin==tmpmax & intvmale ==.


* AGE >=50 (IN 2008)
cap drop intv50
gen intv50=(intvyob<=1958)
replace intv50=. if intvyob==.

cap drop tmp*
bys intvid: egen tmpmax=max(intv50)
bys intvid: egen tmpmin=min(intv50)
tab tmpmax tmpmin if intv50==.
replace intv50=tmpmin if tmpmin==tmpmax & intv50==.

* RACE (EVER WHITE, BLACK, OTHER) 
cap drop tmp*
bys intvid: gen tmpW=intvrace==1
bys intvid: gen tmpB=intvrace==2
bys intvid: gen tmpO=intvrace==3
bys intvid: gen tmpH=intvhisp==1
foreach x in W B O H {
	cap drop ever`x'
	bys intvid: gen ever`x'=tmp`x'==1
}

* COMBINED INTV RACE
cap drop tmprace
gen tmprace=.
replace tmprace=1 if tmpW==1 & (tmpB==0 & tmpO==0 & tmpH==0) & tmprace==.
replace tmprace=2 if tmpB==1 & tmprace==.
replace tmprace=3 if (tmpO==1 | tmpH==1) & tmprace==.
tab tmprace intvrace, m
tab tmprace intvhisp, m
drop intvrace
rename tmprace intvrace
cap drop tmp*
tab intvrace, m

cap drop tmp*
bys intvid: egen tmpmax=max(intvrace)
bys intvid: egen tmpmin=min(intvrace)
tab tmpmax tmpmin if intvrace ==., m
replace intvrace=tmpmin if tmpmin==tmpmax & intvrace ==.
tab intvrace, m

* INDIVIDUAL RACE
cap drop intvwhite
cap drop intvblack
cap drop intvother
recode intvrace (2 3 =0) (1=1), gen(intvwhite)
recode intvrace (1 3 =0) (2=1), gen(intvblack)
recode intvrace (1 2 =0) (3=1), gen(intvother)


* INTERVIEWER HGC MAX
cap drop tmp*
bys intvid: egen tmp1=max(intvhgc)
cap drop intvhgc
gen intvhgc=tmp
cap drop tmp*
lab def intvhgc 1"HS or less" 2"Some coll" 3"College" 4"More than college", modify
lab val intvhgc intvhgc

* INTERVIEWER COLLEGE
cap drop intvcoll
recode intvhgc (1/2=0) (3/4=1), gen(intvcoll)


* KEEP 1 OBS PER INTERVIEWER 
* KEEP VARS
*----------------------------------------------------------------------
bys intvid: keep if _n==1
keep intvid intvmale intvrace intv50 intvhgc intvwhite intvblack intvother intvcoll


* MISSING INTERVIEWER DATA 
*----------------------------------------------------------------------
cap drop _intv
gen _intv=(intvmale==. | intvrace==. | intv50==. | intvhgc==.)
 lab var _intv "Interviewer data missing"
 tab _intv, m

* SAVE
compress
sort intvid
save "${data}/1.2_interviewer.dta", replace
