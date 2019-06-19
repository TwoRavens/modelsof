global x "$masterpath/computerfiles/"
global y "$masterpath/datafiles/"
global z "$masterpath/autor/"

clear
set mem 15000m
*******************************************
* Computer Use Rates by Occupation x Year *
*******************************************
!gunzip ${x}oct8497means-gen.dta.gz
use ${x}oct8497means-gen, clear
keep if sex==0 /*both sexes*/
rename use84 use1984 
rename use97 use1997
keep occ8090 use1984 use1997

***********************
* Linearize 1985-1997 *
***********************
local j=1985
local i=1984
while `j'<=1996 {
while `i'<=1995 {
  gen percent`i'=(use1997-use`i')/(1997-`i')
  gen use`j'=use`i'+percent`i'
  local i=`i'+1
  local j=`j'+1
}
}

***********************
* Linearize 1982-1983 *
***********************
gen use1983=use1984-percent1984
gen use1982=use1983-percent1984
replace use1983=1 if use1983>1 & use1983<.
replace use1982=1 if use1982>1 & use1982<.
replace use1983=0 if use1983<0
replace use1982=0 if use1982<0

***********************
* Linearize 1998-2002 *
***********************
local j=1998
local i=1997
while `j'<=2002 {
while `i'<=2001 {
  gen use`j'=use`i'+percent1995
  local i=`i'+1
  local j=`j'+1
}
}
local j=1998
while `j'<=2002 {
  replace use`j'=1 if use`j'>1 & use`j'<.
  replace use`j'=0 if use`j'<0
  local j=`j'+1
}
drop percent*
reshape long use, i(occ8090) j(year)

sort occ8090 year
by occ8090: gen p_use=use[_n-1]
sort occ8090 year
save ${y}compuse_occ8090.dta, replace

*******************************************
* Computer Use Rates by Industry x Year *
*******************************************
!gunzip ${x}cps1-mf.dta.gz
use ${x}cps1-mf, clear
rename usecompw use
keep ind7090 year use
drop if year==74 | year==79 /* usecompw==. */
sort ind7090 year 
tempfile computeruse84_89_93
save `computeruse84_89_93', replace

!gunzip ${x}cpsaug00.dta.gz
use ${x}cpsaug00, clear
/*PESIU15A    2    Where does ... use the INTERNET?             941-942
                   Does (he/she) use it at work?
                   EDITED UNIVERSE: PES14 = 1
                   VALID ENTRIES:
                   <-1>    Out of universe
                   <1>   Yes
                   <2>   No  */
drop if pesiu15a==-1
drop if peio1icd==-1
gen use=pesiu15a==1 
rename hryear4 year
rename peio1icd ind90
keep ind90 year use
sort ind90 
merge ind90 using ${z}ind90
keep if _merge==1|_merge==3
collapse use, by(ind7090 year)
sort ind7090 year
merge ind7090 year using `computeruse84_89_93'
drop _merge
sort year ind7090
replace year=1984 if year==84
replace year=1989 if year==89
replace year=1993 if year==93

reshape wide use, i(ind7090) j(year)

***********************
* Linearize 1985-1988 *
***********************
local j=1985
local i=1984
while `j'<=1988 {
while `i'<=1987 {
  gen percent`i'=(use1989-use`i')/(1989-`i')
  gen use`j'=use`i'+percent`i'
  local i=`i'+1
  local j=`j'+1
}
}

***********************
* Linearize 1982-1983 *
***********************
gen use1983=use1984-percent1984
gen use1982=use1983-percent1984
replace use1983=1 if use1983>1 & use1983<.
replace use1982=1 if use1982>1 & use1982<.
replace use1983=0 if use1983<0
replace use1982=0 if use1982<0
drop percent*

***********************
* Linearize 1990-1992 *
***********************
local j=1990
local i=1989
while `j'<=1992 {
while `i'<=1991 {
  gen percent`i'=(use1993-use`i')/(1993-`i')
  gen use`j'=use`i'+percent`i'
  local i=`i'+1
  local j=`j'+1
}
}
drop percent*

***********************
* Linearize 1994-1999 *
***********************
local j=1994
local i=1993
while `j'<=1999 {
while `i'<=1998 {
  gen percent`i'=(use2000-use`i')/(2000-`i')
  gen use`j'=use`i'+percent`i'
  local i=`i'+1
  local j=`j'+1
}
}

***********************
* Linearize 2001-2002 *
***********************
gen use2001=use2000+percent1998
gen use2002=use2001+percent1998
replace use2001=1 if use2001>1 & use2001<.
replace use2002=1 if use2002>1 & use2002<.
replace use2001=0 if use2001<0
replace use2002=0 if use2002<0

drop percent*
reshape long use, i(ind7090) j(year)
sort ind7090 year
by ind7090: gen p_use=use[_n-1]
sort ind7090 year
save ${y}compuse_ind7090.dta, replace

!gzip ${x}oct8497means-gen.dta

exit

