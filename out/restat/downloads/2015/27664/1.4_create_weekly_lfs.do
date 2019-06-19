**-------------------------------------------------------------------
** NLSY97 SKIN COLOR RECODING - THROUGH 2010 (RD 14)
**-------------------------------------------------------------------

/*
BE SURE TO DEFINE THE DIRECTORY GLOBAL TO WHERE YOUR DATA ARE.
*/

clear
clear mata
clear matrix
set mem 7700m
set maxvar 7000
version 11
set more off
qui infile using "${extracts}/skincolor/skincolor.dct
qui do "${extracts}/skincolor/skincolor-value-labels.do"

/*
Note that last interview date is june 09, 2011 = week 23, year 2011
but last recoded employment variable ends in week 22, 2011
2673 = EMP
2678 = INTV
*/



* DROP FEMALES AND NON BLACK OR WHITE TO MAKE COMPUTATION FASTER
*--------------------------------------------------------------------

* DROP FEMALES 
drop if R0536300==2

* HISPANIC
cap drop hispanic 
recode R0538600 (-9/-1=.), gen(hispanic)

* WHITE NON-HISP
cap drop wnh
gen wnh=R0538700==1 & R1482600==4 & (hispanic==0 | hispanic==.) 
tab wnh	 

* BLACK NON-HISP
cap drop bnh
gen bnh=R0538700==2 & R1482600==1 & (hispanic==0 | hispanic==.)
tab bnh		 

* OTHER NON-HISP
cap drop onh
gen onh=R0538700>2 & R1482600!=2 & hispanic==0
replace onh= 1 if (R0538700<0 | R0538700==2) & R1482600==3 & (hispanic==0 | hispanic==.)
tab onh		 

* HISPANIC ONLY
cap drop hh
gen hh=(R0538700==5 | R0538700<0) & R1482600==2 
tab hh 		 

* WHITE-HISPANIC
cap drop hw
gen hw=R0538700==1 & hispanic==1
tab hw		 

* BLACK-HISPANIC
cap drop hb
gen hb=R0538700==2 & hispanic==1
tab hb		 

* OTHER-HISPANIC
cap drop ho
gen ho=(R0538700==3 | R0538700==4) & hispanic==1
tab ho		 

* RACE VARIABLE
cap drop racefull
gen racefull=.
replace racefull=1 if wnh==1
replace racefull=2 if bnh==1
replace racefull=3 if onh==1
replace racefull=4 if hh==1
replace racefull=5 if hw==1
replace racefull=6 if hb==1
replace racefull=7 if ho==1
tab racefull
lab def racefull 1"White non-Hisp" 2"Black non-Hisp" 3"Other non-Hisp" 4"Hispanic" 5"Hisp White" 6"Hisp Black" 7"Hisp Other", modify
lab val racefull racefull
tab racefull, m

* RACE
recode racefull (1=1) (2=2) (4/7=3) (3=4), gen(race)
label define race 1"White" 2"Black" 3"Hispanic" 4"Other", modify
label values race race

lab var race Race
tab race, gen(x)
rename x1 white
rename x2 black
rename x3 hisp
rename x4 other
lab var white White
lab var black Black 
lab var hisp Hisp 
lab var other Other

* DROP 
foreach x in hispanic wnh bnh onh hh hw hb ho {
	cap drop `x'
}

* SKIN COLOR VARIABLES
*--------------------------------------------------------------------

* SKIN COLOR (2008-2010)
cap drop color*

recode T3173000 (-9/-1=.), gen(color_2008) 
recode T4584700 (-9/-1=.), gen(color_2009)     
recode T6217800 (-9/-1=.), gen(color_2010)  

gen color=(color_2008)
replace color=color_2009 if color==. & color_2009!=.  

replace color=color_2010 if color==. & color_2010!=.  
lab var color "Skincolor"
tab color race, m

* DROP
*--------------------------------------------------------------------
drop if race>2
drop if (black==1 & color==.)
drop race* white black hisp other color*

* MAKE INTERVIEW DATES
*-------------------------------------------------------------------
cap drop intdt_*
recode R1209401 R1209400 R1209402 (-9/-1=.)
gen intdt_1997=mdy(R1209401, R1209400, R1209402)
recode R2568301 R2568300 R2568302 (-9/-1=.)
gen intdt_1998=mdy(R2568301, R2568300, R2568302)
recode R3890301 R3890300 R3890302 (-9/-1=.)
gen intdt_1999=mdy(R3890301, R3890300, R3890302)
recode R5472301 R5472300 R5472302 (-9/-1=.)
gen intdt_2000=mdy(R5472301, R5472300, R5472302)
recode R7236101 R7236100 R7236102 (-9/-1=.)
gen intdt_2001=mdy(R7236101, R7236100, R7236102)
recode S1550901 S1550900 S1550902 (-9/-1=.)
gen intdt_2002=mdy(S1550901, S1550900, S1550902)
recode S2020801 S2020800 S2020802 (-9/-1=.)
gen intdt_2003=mdy(S2020801, S2020800, S2020802)
recode S3822001 S3822000 S3822002 (-9/-1=.)
gen intdt_2004=mdy(S3822001, S3822000, S3822002)
recode S5422001 S5422000 S5422002 (-9/-1=.)
gen intdt_2005=mdy(S5422001, S5422000, S5422002)
recode S7524101 S7524100 S7524102 (-9/-1=.)
gen intdt_2006=mdy(S7524101, S7524100, S7524102)
recode T0024501 T0024500 T0024502 (-9/-1=.)
gen intdt_2007=mdy(T0024501, T0024500, T0024502)
recode T2019401 T2019400 T2019402 (-9/-1=.)
gen intdt_2008=mdy(T2019401, T2019400, T2019402)
recode T3610001 T3610000 T3610002 (-9/-1=.)
gen intdt_2009=mdy(T3610001, T3610000, T3610002)
recode T5210401 T5210400 T5210402 (-9/-1=.)
gen intdt_2010=mdy(T5210401, T5210400, T5210402)
format intdt_* %td

rename R0000100 id
cap drop A*
cap drop Z*
cap drop R*
cap drop S*
cap drop T*
rename id R0000100

set more off
compress



* CREATE INTERVIEW WEEK FOR EACH YEAR
* ASSIGN "DUMMY" WEEK FOR NON-INTERVIEWED YEAR.
******************************************************************
* SINCE ALL RESPONDENTS HAVE DIFFERENT INTERVALS BETWEEN INTERVIEWS
* AND SOME MISS YEARS, I TAKE # WEEKS WORKED IN PAST CALENDAR YEAR FROM INTV DATE
* IF AN INTERVIEW(S) IS SKIPPED. IN THIS CASE, I ASSIGN AN FALSE INTV DATE 52 
* WEEKS PRIOR TO THE CURRENT.
* THIS WORKS B/C WE WANT WEEKS WORKED BY CALENDAR YEAR.


* BEGIN WITH 1997 SEPARATELY - NO ONE MISSED
cap drop newdt*
gen newdt_1997=intdt_1997
 format newdt_1997 %td
cap drop intvwk_1997
gen intvwk_1997=wofd(newdt_1997)
 format intvwk_1997 %tw

* 1998-2010
forvalues yr=1998(1)2010 {
	local yr1=`yr'-1
	cap drop newdt_`yr'
	gen newdt_`yr'=intdt_`yr' 
	replace newdt_`yr'=(newdt_`yr1'+365) if newdt_`yr'==. 
	format newdt_`yr' %td
	count if newdt_`yr'==.
	
	cap drop intvwk_`yr'
	gen intvwk_`yr'=wofd(newdt_`yr')
	format intvwk_`yr' %tw
	count if intvwk_`yr'==.
}
cap drop newdt*


* Intvwk_year in %tw = week/year of interview for each round
* Now there are all non-missing
******************************************************************

* Make continuous weekly time dummy indicating week of interview
forvalues i=1924(1)2678 {		 
	cap drop intv`i'
	qui gen intv`i'=0
}

* Fill =1 indicating week of interview
set more off
forvalues yr=1997(1)2010 {
	forvalues i=1924(1)2678 {	
		qui replace intv`i'=1 if intvwk_`yr'==`i'
	}	
}
	

* This is for labor force status
******************************************************************
/* EMP_STATUS weekly variable
0: No information reported to account for week; job dates indeterminate
1: Not associated with an employer, not actively searching for an employer job
2: Not working (unemployment vs. out of labor force cannot be determined)
3: Associated with an employer, periods not working for the employer are missing
4: Unemployed
5: Out of the labor force
6: Active military service
9000-9999999=employed (Roster ID number associated with employer)
Define:
1=Employed 			(3, 6, 9701/99999999)
2=Unemployed		(4)
3=NILF				(1, 5)
.=missing or other	(-9/-1, 0, 2)
*/
******************************************************************
* STUBS ARE THE NLSY97 VARIABLE STUBS, WEEKS ARE THE LAST TWO DIGITS OF THE NLSY VARIABLE NAME
* THERE IS 1 STUB PER YEAR; EACH 2 DIGIT SUFFIX IDENTIFIES THE WEEK- 
* E.G. E00118{05} IS WEEK 5, 2008.
*
* LFS=LABOR FORCE STATUS, (UN)EMP=(UN)EMPLOYED, NILF=NOT IN LABOR FORCE
local stub "E00117 E00118 E00119 E00120 E00121 E00122 E00123 E00124 E00125 E00126 E00127 E00128 E00129 E00130"
local week "01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52"
set more off
local w=1924 
foreach x in `stub'  {
	foreach i in `week' {
		* VERIFY WEEK STUB IS CORRECT
		*cap drop tmp
		*qui gen tmp=`w'
		*qui format tmp %tw
		*tab tmp
		*d `x'`i' 
		* CREATE VARIABLES
		cap drop lfs`w'	
		qui recode `x'`i' (-9/-1 0 2 =.) (3 6 999/999999=.1) (4=.2) (1 5=.3) , gen(lfs`w') 
		qui recode lfs`w' (.1=1) (.2=2) (.3=3)
 		drop `x'`i' 
 		local w=(`w'+1)
	}
}
* 2011
local week "01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22"
set more off
local w=2652 
	foreach i in `week' {
	cap drop work`w'
	qui recode E00231`i' (-9/-1=.) (0 81/9999=0), gen(work`w') 
	local w=`w'+1
}
	

* Intwk`i'_`yr' = 1 if that week was the interview week, 0 otherwise
* work`i'_`yr'=
* Else, incl missing, 0
* -----------------------------------------------------------------------*
local stub "E00217 E00218 E00219 E00220 E00221 E00222 E00223 E00224 E00225 E00226 E00227 E00228 E00229 E00230"
local week "01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52"
set more off
local w=1924 
foreach x in `stub'  {
	foreach i in `week' {
	cap drop work`w'
	qui recode `x'`i' (-9/-1=.) (81/9999=.), gen(work`w') 
	local w=`w'+1
	}
}
disp `w'	
	
* 2011
local week "01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22"
set more off
local w=2652 
	foreach i in `week' {
	cap drop work`w'
	qui recode E00231`i' (-9/-1=.) (81/9999=.), gen(work`w') 
	local w=`w'+1
}


* Extend last week of employment questions to match interview date question timing
* -----------------------------------------------------------------------*
forvalues i= 2674(1)2678 {
	cap drop lfs`i'
	gen lfs`i'=0
	cap drop work`i'
	gen work`i'=0
}

* DROP VARIABLES
* -----------------------------------------------------------------------*
cap drop E*


* RESHAPE TO LONG
* -----------------------------------------------------------------------*
set more off
reshape long intv lfs work, i(R0000100) j(week) 
sort R0000100 week

* SAVE AS TMP_LFS
* -----------------------------------------------------------------------*
save "${data}/weekly_lfs.dta", replace


* DEFINE AND CLEAN EMPLOYED, UNEMPLOYED AND NILF  
* -----------------------------------------------------------------------*

* RECODE LFS
replace lfs=1 if work>0 & work<.

* EMP
cap drop emp
recode lfs (2/3=0), gen(emp)

* UNEMP
cap drop unemp
recode lfs (1 3=0) (2=1), gen(unemp)

* NILF
cap drop nilf
recode lfs (1/2=0) (3=1), gen(nilf)

* WORK (RECODE)
* NOTE ABOUT 10% OF WEEKS EMPLOYED HAVE NO HOURS!
replace work=0 if (unemp==1 | nilf==1 | emp==0)
count if work==. &  emp==1
count if emp==1 &  work>0 & work!=.


* WEEKS EMPLOYED, UNEMPLOYED AND NILF  
* -----------------------------------------------------------------------*

* COUNT OF WEEKS WITH VALID LFS RESPONSE
cap drop lfswks
gen lfswks=(lfs!=.)
bys R0000100: replace lfswks	=cond(intv[_n-1]==0, lfswks+lfswks[_n-1], lfswks) if week>1942

* WEEKS LFS=EMPLOYED
cap drop empwks
gen empwks=emp
recode empwks (.=0)
bys R0000100: replace empwks    =cond(intv[_n-1]==0, empwks+empwks[_n-1], empwks) if week>1942

* WEEKS LFS=UNEMPLOYED
cap drop unempwks
gen unempwks=unemp
recode unempwks (.=0)
bys R0000100: replace unempwks  =cond(intv[_n-1]==0, unempwks+unempwks[_n-1], unempwks) if week>1942

* WEEKS LFS=NILF
cap drop nilfwks
gen nilfwks=nilf
recode nilfwks (.=0)
bys R0000100: replace nilfwks   =cond(intv[_n-1]==0, nilfwks+nilfwks[_n-1], nilfwks) if week>1942


* WEEKS EMPLOYED 30 HOURS
* -----------------------------------------------------------------------*

* WEEKS WITH VALID HOURS WORKED
cap drop workwks
gen workwks=(work!=.)
bys R0000100: replace workwks	=cond(intv[_n-1]==0, workwks+workwks[_n-1], workwks) if week>1942

* WEEKS EMPLOYED 30+ HOURS
cap drop empwks30
gen empwks30=(work>=30 & work<.)
bys R0000100: replace empwks30=cond(intv[_n-1]==0, empwks30+empwks30[_n-1], empwks30) if week>1942
 

* Now keep only if intv==1 = interview data (should be 14 a person)
* And make year variable (1=1997, ...) - missing 24 people in 2008
* -----------------------------------------------------------------------*
keep if intv==1
cap drop year
bys R0000100: gen year=_n
replace year=year+1996

* COUNT WEEKS SINCE LAST INTERVIEW
cap drop totwks
gen totwks=.
forvalues i=1998(1)2010 {
    local j=`i'-1
    replace totwks=(intvwk_`i'-intvwk_`j') if year==`i' & totwks==.
}
        

* DEFINE SHARE OF WEEKS EMPLOYED SINCE LAST INTERVIEW 
* -----------------------------------------------------------------------*
cap drop shremp_v1
gen shremp_v1=(empwks/lfswks)
lab var shremp_v1 "Share weeks employed"
note shremp_v1: Weeks employed / weeks w/ LFS!=.

cap drop shrwks30_v1
gen shrwks30_v1=(empwks30/workwks)
lab var shrwks30_v1 "Share weeks employed 30 hrs"
note shrwks30_v1: Weeks employed / weeks w/ hrs!=.


* SAVE
* -----------------------------------------------------------------------*
keep  R0000100 year shremp_v1 shrwks30_v1  
keep  R0000100 year shremp_v1 shrwks30_v1 
sort  R0000100 year 
compress
save "${data}/tmp_1.4_weekly_lfs.dta", replace




