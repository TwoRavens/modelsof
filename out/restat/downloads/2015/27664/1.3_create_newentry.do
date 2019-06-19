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


* INTERVIEW IN FALL OR SPRING - JAN 1980 IS MONTH 1
*-------------------------------------------------------------------
local yr=1997
foreach x in R1209300 R2568200 R3890100 R5472200 R7236000 S1550800 S2020700 S3821900 S5421900 S7524000 T0024400 T2019300 T3609900 T5210300 {
 cap drop intv_`yr'
 recode `x' (-9/-1=.), gen(intv_`yr')
 replace intv_`yr'=(intv_`yr'+239)
 format intv_`yr' %tm
 local yr=`yr'+1
}


* K-12 ENROLLMENT (NO ONE IS IN K-12 AFTER MAY 2009)
*-------------------------------------------------------------------
set more off
local yr=1996
foreach x in E50117 E50118 E50119 E50120 E50121 E50122 E50123 E50124 E50125 E50126 E50127 E50128 E50129 {
	local yr=(`yr'+1)
	local m=0
	foreach M in 01 02 03 04 05 06 07 08 09 10 11 12 { 
		local m=(`m'+1)
		cap drop enrhs`m'_`yr'
		cap qui recode `x'`M' (-9/-1=.) (1=0) (2/8=1), gen(enrhs`m'_`yr')	
	}
}

* MAKE ENROLL HS = 0 AFTER MAY, 2009 - MISSING IF NOT INTERVIEWED
forvalues m=6(1)12 {
	cap drop enrhs`m'_2009
	gen enrhs`m'_2009=0
	replace enrhs`m'_2009=. if T3601400<0
}	
forvalues m=1(1)12 {
	cap drop enrhs`m'_2010
	gen enrhs`m'_2010=0
	replace enrhs`m'_2010=. if T5201300<0
}	


* COLLEGE ENROLLMENT
* THESE WERE INCORRECT IN THE PREVIOUS VERSION (E51117 E51118 E51119 E51120)
* THEY WARE E50117 E50118 E50119 E50120
*-------------------------------------------------------------------
set more off
local yr=1996
foreach x in E51117 E51118 E51119 E51120 E51121 E51122 E51123 E51124 E51125 E51126 E51127 E51128 E51129 E51130 {
	local yr=(`yr'+1)
	local m=0
	foreach M in 01 02 03 04 05 06 07 08 09 10 11 12 { 
		local m=(`m'+1)
		cap drop enrco`M'_`yr'
		qui recode `x'`M' (-9/-1=.) (1=0) (2/8=1), gen(enrco`m'_`yr')	
		qui recode `x'`M' (-9/-1=.) (1=0) (2=1) (3/4=0), gen(enr2yr`m'_`yr')	
		qui recode `x'`M' (-9/-1=.) (1/2=0) (3=1) (4=0), gen(enr4yr`m'_`yr')	
		qui recode `x'`M' (-9/-1=.) (1/3=0) (4=1), gen(enrgr`m'_`yr')		
	}
}	


* ANY ENROLLMENT
*-------------------------------------------------------------------
forvalues yr=1997(1)2010 {
		forvalues m=1(1)12 {
			cap drop enr`m'_`yr'
			qui gen enr`m'_`yr'=(enrhs`m'_`yr'==1 | enrco`m'_`yr'==1)
			qui replace enr`m'_`yr'=. if (enrhs`m'_`yr'==. & enrco`m'_`yr'==.)
		}
	* MONTHS OF SPRING ENROLLMENT		
	cap drop enrsp_`yr'
	qui egen enrsp_`yr'=rowtotal(enr2_`yr'-enr5_`yr') 
		cap drop miss
		qui egen miss=rowmiss(enr2_`yr'-enr5_`yr')
		qui replace enrsp_`yr'=. if miss==4
	* MONTHS OF FALL ENROLLMENT
	cap drop enrfl_`yr'
	qui egen enrfl_`yr'=rowtotal(enr9_`yr'-enr11_`yr')
		cap drop miss
		qui egen miss=rowmiss(enr9_`yr'-enr11_`yr')
		qui replace enrfl_`yr'=. if miss==3
		cap drop miss
}



* KEEP ONLY VARIABLES CREATED 
*-------------------------------------------------------------------
rename R0000100 id
foreach x in E R S T Z {
	cap drop `x'*
}
rename id R0000100
keep R0000100 enrfl_* enrsp_* *intv_*  



* RESHAPE TO LONG
*-------------------------------------------------------------------
set more off
reshape long enrfl_ enrsp_  intv_,  i(R0000100) j(year)
rensfix _


* Interviewed in spring or fall (or in next calendar year)
* Must be interviewed in fall or spring of next year
* for non-enrollment spell to begin if it begins in fall 
*-------------------------------------------------------------------
cap drop tmp_intv
gen tmp_intv=dofm(intv)
format tmp_intv %td
cap drop intvyr
gen intvyr=year(tmp_intv)
cap drop intvmo
gen intvmo=month(tmp_intv)
 cap drop tmp_intv


* Indicates if interview was conducted in fall of intv year
* Or in the following calendar year
* If above is true => non-enrollment spell can begin in the fall
* This is because if its a spring intv, then the wage may be taken while enrolled
*-------------------------------------------------------------------
cap drop fall_intv
gen fall_intv=(intvmo>=10) | (intvyr==year+1)


* Recode to dummies, 1=not enrolled
*-------------------------------------------------------------------
cap drop spring
cap drop fall 
recode enrsp (0=1) (1/4=0), gen(spring)
recode enrfl (0=1) (1/3=0), gen(fall)


* Next year's response
*-------------------------------------------------------------------
sort R0000100 year
cap drop spring1 
bys R0000100: gen spring1=spring[_n+1]
cap drop fall1
bys R0000100: gen fall1=fall[_n+1]


* Nonenr, 3 of 4 consec terms if one is missing, 
* Else 4 consecutive terms
*-------------------------------------------------------------------
cap drop tmp_sum 
egen tmp_sum=rowtotal(spring fall spring1 fall1)
cap drop tmp_year
gen tmp_year=year if tmp_sum==4 
cap drop tmp_miss
egen tmp_miss=rowmiss(spring fall spring1 fall1)
cap drop tmp_year2
gen tmp_year2=year if tmp_sum==3 & tmp_miss==1 
replace tmp_year=tmp_year2 if tmp_year==. & tmp_year2!=.


* NEW_ENTRY VARIABLE
*-------------------------------------------------------------------
sort R0000100 year
cap drop new_entry
bys R0000100: egen new_entry=min(tmp_year)


* 2010 entry = all of 2010 non-enrolled
*-------------------------------------------------------------------
cap drop tmp_2010
gen tmp_2010=(fall==0 & spring==0 & year==2010)
bys R0000100: egen max=max(tmp_2010)
replace new_entry=2010 if max==1 & new_entry==.



* Save
*-------------------------------------------------------------------
keep R0000100 year new_entry
compress
sort R0000100 year
save "${data}/1.3_newentry.dta", replace







